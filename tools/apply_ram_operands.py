#!/usr/bin/env python3
"""Write the raw pointer operands of WRAM0 and HRAM (`ld hl, $C0A0`) as the name of the object they point at (`ld hl, wGlyphBufLeft`).

    python3 tools/apply_ram_operands.py [--areas wram0,hram] [--dry-run] [--report FILE] [options]
    python3 tools/apply_ram_operands.py --check [--areas ...] [--root DIR]

  --areas A,B    wram0 ($C000-$CFFF, `ram/wram.asm`), hram ($FF80-$FFFE, `ram/hram.asm`) and/or io ($FF00-$FF7F, the hardware registers of `constants/hardware.inc`); default wram0
  --root DIR     tree to edit (default: the repository root; use it to work in a copy)
  --dry-run      analyse and print what would change; write nothing, build nothing
  --no-build     apply the edit but do not run the build / SHA-256 / sym_check verification (no rollback then!)
  --no-symcheck  run the build and the SHA-256 check but not tools/sym_check.py
  --report FILE  write a TSV with one line per operand (file, line, operand, outcome, replacement)
  --check        read-only audit: lists the operands that are still raw although an object covers the address; exit 1 when there are some

Why (STYLE.md, RAM): the generator wrote RAM names where code reads or writes a variable (`ld a, [wTimerEnable]`) but left every pointer *immediate* numeric
(`ld hl, $C0A0`), because an immediate can be a constant.  In `$C000-$CFFF` (WRAM0, never banked) it practically never is: it is the address of something, and
`ram/wram.asm` names what is there.  In HRAM and the hardware registers it often is a constant (the 16-bit negative numbers `$FF9C` = -100, `$FFF6` = -10 that `add hl, bc`
adds), so those two areas are rewritten only after a look at the next use of the register.  The edit is a text rewrite of the operand only (`ld hl, $C0A0` ->
`ld hl, wGlyphBufLeft`, `ld de, $C0A3` -> `ld de, wGlyphBufLeft + $03`): `name` is the same number, so no byte of the ROM changes (`make` and the SHA-256 prove it, and the files
are restored if not).  The banked areas (`$D000-$DFFF` WRAM, `$A000-$BFFF` SRAM) are not touched here: their names depend on the bank, see tools/apply_banked_names.py.

Rules
  * only code lines of the form `ld hl|de|bc, $XXXX` (4 hex digits, optional trailing comment) in home/ engine/ lib/ data/ audio/;
  * the object that gets the operand is the innermost *semantic* object of the area that covers the address (`DEF name EQU $addr ; size N ...`, start <= addr < start + N, the
    one with the greatest start, then the smallest size); the neutral names (`wRam_C...`, `hRam_FF...`, size 1) are used only when no semantic object covers the address and the
    address is exactly theirs;
  * left numeric: (1) an address that has a screen-local alias in `ram/overlays.asm`, in a file that is inside the scope of that alias (the neutral name would be rewritten into the
    alias by tools/apply_overlay_aliases.py, and a window base such as `ld hl, $C0D4` is not the byte the alias names); (2) a *value*: in HRAM and the hardware registers an operand
    whose first use is `add hl, <the register>` (or `add hl, bc|de` when the register is hl), and in every area a DE that goes to `Sprite_SetPosition` (the Y, X pair) or a BC that goes
    to `CommTime_DrawNumber` (the addend); (3) a line whose trailing comment starts with `; raw` (a human decision, with the reason: a dead load, a scratch use of the buffer, ...);
  * an operand with no object at its address stays numeric and is reported.
After editing the tree the tool builds (`make`, or $RENAME_BUILD_CMD), compares the ROM's SHA-256 with roms.sha256 and runs tools/sym_check.py (as tools/apply_renames.py
does); on any failure every touched file is restored and the exit status is 1.  Idempotent: a second run finds nothing to do.

Exit status: 0 ok, 1 build/verification failed and everything was rolled back (or --check found raw operands), 2 usage or input error (nothing written).
"""
import argparse
import fnmatch
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import apply_renames as ar  # noqa: E402

ROOT = os.path.dirname(HERE)
SOURCE_DIRS = ('home/', 'engine/', 'lib/', 'data/', 'audio/')
AREAS = {
    'wram0': ('ram/wram.asm', 0xC000, 0xD000, re.compile(r'^wRam_C[0-9A-F]{3}$')),
    'hram': ('ram/hram.asm', 0xFF80, 0xFFFF, re.compile(r'^hRam_FF[0-9A-F]{2}$')),
    'io': ('constants/hardware.inc', 0xFF00, 0xFF80, re.compile(r'^$^')),
}
IO_DEF = re.compile(r'^DEF\s+(r[A-Z0-9_]+)\s+EQU\s+\$(FF[0-7][0-9A-F])\b')
OBJ_DEF = re.compile(r'^DEF\s+([A-Za-z_][A-Za-z0-9_]*)\s+EQU\s+\$([0-9A-F]{4})\s*;\s*size\s+(\d+)\b')
ALIAS_DEF = re.compile(r'^DEF\s+[A-Za-z_][A-Za-z0-9_]*\s+EQU\s+((?:wRam_C[0-9A-F]{3})|(?:hRam_FF[0-9A-F]{2}))\s*;')
LD = re.compile(r'^(\s*ld (?:hl|de|bc), )\$([0-9A-F]{4})(\s*(?:;.*)?)$')
OVERLAYS = 'ram/overlays.asm'
GROUP_HEAD = re.compile(r'^;\s*----\s*(.+?)\s*$')
RAW_MARK = re.compile(r';\s*raw\b')
# routines that take a *value* in a register, not an address: register sets
VALUE_CALLS = {'Sprite_SetPosition': {'de'}, 'CommTime_DrawNumber': {'bc'}}          # a routine name matches by prefix: `CommTime_DrawNumber_27_4FFB` is a dead twin


def value_registers(target):
    for name, regs in VALUE_CALLS.items():
        if target == name or target.startswith(name + '_'):
            return regs
    return ()
FAMILY = {'hl': {'hl', 'h', 'l', '[hl]', '[hli]', '[hld]', '[hl+]', '[hl-]'}, 'bc': {'bc', 'b', 'c', '[bc]'}, 'de': {'de', 'd', 'e', '[de]'}}
CONDITIONS = {'z', 'nz', 'c', 'nc'}
TRANSFERS = {'call', 'jp', 'jr', 'ret', 'reti', 'rst', 'farcall'}


class Obj:
    def __init__(self, name, start, size, neutral):
        self.name, self.start, self.size, self.neutral = name, start, size, neutral


def read_objects(tree, area):
    rel, lo, hi, neutral_re = AREAS[area]
    objs = []
    for line in tree.files.get(rel, []):
        if area == 'io':
            m = IO_DEF.match(line)
            if m and not any(o.start == int(m.group(2), 16) for o in objs):
                objs.append(Obj(m.group(1), int(m.group(2), 16), 1, False))
            continue
        m = OBJ_DEF.match(line)
        if m:
            a = int(m.group(2), 16)
            if lo <= a < hi:
                objs.append(Obj(m.group(1), a, int(m.group(3)), bool(neutral_re.match(m.group(1)))))
    return objs


def alias_scopes(tree):
    """{address: [(includes, excludes)]}: the scope of every screen-local alias of `ram/overlays.asm` (the group header `; ---- <scope>` above it)."""
    out = {}
    scope = ([], [])
    for line in tree.files.get(OVERLAYS, []):
        h = GROUP_HEAD.match(line)
        if h:
            inc, exc = [], []
            for item in h.group(1).split(','):
                item = item.strip().split('@')[0]
                if item.startswith('!'):
                    exc.append(item[1:])
                elif item:
                    inc.append(item)
            scope = (inc, exc)
            continue
        m = ALIAS_DEF.match(line)
        if m:
            out.setdefault(int(m.group(1)[-4:], 16), []).append(scope)
    return out


def in_alias_scope(scopes, v, rel):
    for inc, exc in scopes.get(v, []):
        if any(fnmatch.fnmatchcase(rel, p) for p in inc) and not any(fnmatch.fnmatchcase(rel, p) for p in exc):
            return True
    return False


def parse_insn(line):
    """None for a global label or a directive (the straight line ends), '' for a blank or comment-only line, else (mnemonic, operands)."""
    raw = line.split(';')[0]
    if not raw.strip():
        return ''
    if not raw.startswith('\t'):
        return None
    parts = raw.strip().split(None, 1)
    ops = [o.strip() for o in parts[1].split(',')] if len(parts) > 1 else []
    return parts[0].lower(), ops


def is_value(lines, i, reg, area):
    """True when the register loaded at lines[i] is used as a number: `add hl, reg` first (HRAM and hardware registers only), or handed to a routine that takes a value."""
    seen = 0
    for j in range(i + 1, min(i + 120, len(lines))):
        if seen > 30:
            return False                                   # thirty instructions without a use: not a value
        if lines[j].startswith('.'):
            continue                                       # a local label (a loop head) does not end the straight line
        ins = parse_insn(lines[j])
        if ins is None:
            return False                                   # a global label or a directive ends it
        if ins == '':
            continue
        m, ops = ins
        if m in TRANSFERS:
            if m in ('call', 'farcall') and ops and reg in value_registers(ops[0]):
                return True
            if m in ('jr', 'jp') and ops and ops[0] in CONDITIONS:
                continue                                   # a conditional jump: the straight line goes on (the use may sit after the branch)
            return False
        mention = False
        for k, o in enumerate(ops):
            if m in ('jr', 'jp', 'ret') and k == 0 and o in CONDITIONS:
                continue
            if o in FAMILY[reg]:
                mention = True
        if mention:
            if area in ('hram', 'io') and m == 'add' and len(ops) == 2 and ops[0] == 'hl' and (reg == 'hl' or ops[1] in FAMILY[reg]):
                return True
            return False
        seen += 1
    return False


def choose(objs, v):
    """The object whose name replaces the address v, or None."""
    sem = [o for o in objs if not o.neutral and o.start <= v < o.start + o.size]
    if sem:
        return max(sem, key=lambda o: (o.start, -o.size))
    for o in objs:
        if o.neutral and o.start == v:
            return o
    return None


def text_for(obj, v):
    return obj.name if v == obj.start else '%s + $%02X' % (obj.name, v - obj.start)


def plan(tree, areas):
    """List of (relpath, index, operand_value, outcome, replacement)."""
    tables = {}
    scopes = alias_scopes(tree)
    for a in areas:
        tables[a] = (read_objects(tree, a), AREAS[a][1], AREAS[a][2])
    rows = []
    for rel in sorted(tree.files):
        if not rel.endswith('.asm') or not rel.startswith(SOURCE_DIRS):
            continue
        lines = tree.files[rel]
        for i, line in enumerate(lines):
            m = LD.match(line)
            if not m:
                continue
            v = int(m.group(2), 16)
            area = next((a for a, (_, lo, hi) in tables.items() if lo <= v < hi), None)
            if area is None:
                continue
            reg = m.group(1).split()[-1].rstrip(',')
            if RAW_MARK.search(m.group(3)):
                rows.append((rel, i, v, 'marked raw', ''))
            elif in_alias_scope(scopes, v, rel):
                rows.append((rel, i, v, 'overlay base', ''))
            elif is_value(lines, i, reg, area):
                rows.append((rel, i, v, 'value', ''))
            else:
                obj = choose(tables[area][0], v)
                if obj is None:
                    rows.append((rel, i, v, 'no object', ''))
                else:
                    rows.append((rel, i, v, 'apply', text_for(obj, v)))
    return rows


def apply_rows(tree, rows):
    new = {}
    for rel, i, v, outcome, text in rows:
        if outcome != 'apply':
            continue
        lines = new[rel] if rel in new else list(tree.files[rel])
        m = LD.match(lines[i])
        lines[i] = m.group(1) + text + m.group(3)
        new[rel] = lines
    return {rel: '\n'.join(lines) for rel, lines in new.items()}


def main(argv=None):
    ap = argparse.ArgumentParser(description='Write the raw RAM pointer operands as the names of their objects (see the module docstring).')
    ap.add_argument('--areas', default='wram0')
    ap.add_argument('--root', default=ROOT)
    ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--no-build', action='store_true')
    ap.add_argument('--no-symcheck', action='store_true')
    ap.add_argument('--report', metavar='FILE')
    ap.add_argument('--check', action='store_true')
    args = ap.parse_args(argv)
    areas = [a.strip() for a in args.areas.split(',') if a.strip()]
    if not areas or any(a not in AREAS for a in areas):
        print('apply_ram_operands: --areas takes %s' % ', '.join(AREAS), file=sys.stderr)
        return 2
    root = os.path.abspath(args.root)
    try:
        tree = ar.Tree.load(root)
    except OSError as e:
        print('apply_ram_operands: cannot read the tree: %s' % e, file=sys.stderr)
        return 2
    for a in areas:
        if AREAS[a][0] not in tree.files:
            print('apply_ram_operands: %s has no %s' % (root, AREAS[a][0]), file=sys.stderr)
            return 2
    rows = plan(tree, areas)
    todo = [r for r in rows if r[3] == 'apply']
    counts = {}
    for r in rows:
        counts[r[3]] = counts.get(r[3], 0) + 1
    by_name = {}
    for r in todo:
        by_name[r[4].split(' + ')[0]] = by_name.get(r[4].split(' + ')[0], 0) + 1
    if args.report:
        with open(args.report, 'w', encoding='utf-8') as f:
            f.write('file\tline\toperand\toutcome\treplacement\n')
            for rel, i, v, outcome, text in rows:
                f.write('%s\t%d\t$%04X\t%s\t%s\n' % (rel, i + 1, v, outcome, text))
    if args.check:
        for rel, i, v, outcome, text in rows:
            if outcome == 'apply':
                print('  raw  %s:%d  $%04X  -> %s' % (rel, i + 1, v, text))
        print('apply_ram_operands: --check: %d raw operand(s) with an object, %d left numeric on purpose (%d overlay base, %d value, %d marked raw), %d without an object'
              % (len(todo), counts.get('overlay base', 0) + counts.get('value', 0) + counts.get('marked raw', 0), counts.get('overlay base', 0), counts.get('value', 0), counts.get('marked raw', 0), counts.get('no object', 0)))
        return 1 if todo else 0
    for rel, i, v, outcome, text in rows:
        if outcome == 'no object':
            print('  no object        %s:%d  $%04X' % (rel, i + 1, v))
    print('apply_ram_operands: summary: %d operand(s) in %d file(s) to rewrite with %d distinct name(s); left numeric: %d overlay base, %d value, %d marked raw; %d without an object'
          % (len(todo), len({r[0] for r in todo}), len(by_name), counts.get('overlay base', 0), counts.get('value', 0), counts.get('marked raw', 0), counts.get('no object', 0)))
    if args.dry_run:
        for name, n in sorted(by_name.items(), key=lambda kv: (-kv[1], kv[0]))[:12]:
            print('    %5d  %s' % (n, name))
        print('(dry run: nothing written, nothing built)')
        return 0
    if not todo:
        return 0
    new = apply_rows(tree, rows)
    originals = {rel: open(os.path.join(root, rel), 'rb').read() for rel in new}
    for rel, text in sorted(new.items()):
        with open(os.path.join(root, rel), 'w', encoding='utf-8', newline='') as f:
            f.write(text)
    if args.no_build:
        print('apply_ram_operands: written without verification (--no-build): %d file(s)' % len(new))
        return 0
    ok, msg = ar.verify_tree(root, not args.no_symcheck, 'mobile_trainer.gbc')
    if not ok:
        print('apply_ram_operands: VERIFICATION FAILED, restoring %d file(s):\n%s' % (len(new), msg))
        for rel, data in originals.items():
            with open(os.path.join(root, rel), 'wb') as f:
                f.write(data)
        ar.verify_tree(root, False, 'mobile_trainer.gbc')
        return 1
    print('apply_ram_operands: verification: %s' % msg)
    return 0


if __name__ == '__main__':
    sys.exit(main())
