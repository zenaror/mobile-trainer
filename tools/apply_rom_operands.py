#!/usr/bin/env python3
"""Write the raw ROM pointers of the code, `ld hl|de|bc, $XXXX` with an address below $8000, as labels.

    python3 tools/apply_rom_operands.py [--dry-run] [--check] [--report FILE] [--consumers FILE] [--no-build]

Needs build/mobile_trainer.sym (run `make` first).  An immediate below `$8000` is either a pointer into the ROM or a number that happens to lie in that range (a Y,X pair `$5A47`, a length `$0040`,
the id `$0020`): the number alone proves nothing, so an operand is rewritten only when a *consumer rule* says that the routine which receives the register reads it as a pointer into the ROM and the
bank of that pointer is shown.

Rules (`analysis/naming2/rom_consumers.tsv`: consumer, register, bank, proof)
  * the consumer is found as for the banked WRAM pointers (tools/apply_ram_operands.py `find_consumer_ex`): the first `call`, `farcall` or tail `jp Label` of the straight line after the load, with
    only plain instructions that do not touch the register in between;
  * `bank` is `A` when the routine takes the ROM bank of the pointer in A (`Sprite_InitSlot`: DE = the object table, A = its bank; `Palette_LoadToBuffer`, `Gfx_StartHDMA`, `TextTiles_RenderLine`,
    `Tilemap_CopyRectAndAttr`: HL = the source, A = its bank): the constant `ld a, $NN` that is the nearest write of A before the call is the bank, and a pointer below $4000 is in bank 0 whatever A is;
    `mapped` when the routine reads the pointer in the ROM bank that is mapped while it runs and selects no bank itself (`CopyBytes`, `CopyString`, `StringAppend`): that is the bank of the routine
    after a `farcall`, and the bank of the code that loads the pointer after a plain `call` (a ROMX bank, the routine in ROM0 or in the same bank, no write of a ROM bank register in between);
    a pointer below $4000 is in bank 0 for both;
    a two-digit hex number (`75`) when the routine reads the pointer in that fixed ROM bank whoever calls it (the serial interrupt selects bank 75 before it reads a packet);
  * the target (bank, address) must be a label of that bank, or the start of a `sprite_object_entry` line (the tables of the sprite engine: a new label `<table>_Entry<N>` is written in front of the
    line, N = the entry index counted from the label of the table); anything else stays numeric and is counted, which tells which rule or label to add next;
  * the nearest write of A, when it is `ld a, $NN` with the bank of the target, becomes `ld a, BANK(Label)` (`xor a` and every other write stay as they are): the pointer and its bank are then one
    fact in the source.

Why the bytes cannot change: the label is the same number (the .sym file places it there), `BANK(Label)` is the bank of the section that holds it, and the SHA-256 (`make`) proves both; the files are
restored when it differs.  Idempotent: a second run finds no numeric operand it may rewrite.  `; raw` lines are never rewritten.
"""
import argparse
import collections
import csv
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import apply_ram_operands as ao  # noqa: E402
import apply_renames as ar  # noqa: E402
import line_addresses as la  # noqa: E402

ROOT = os.path.dirname(HERE)
CONSUMERS = 'analysis/naming2/rom_consumers.tsv'
LD = re.compile(r'^(\s*ld (hl|de|bc), )\$([0-9A-Fa-f]{4})(\s*(?:;.*)?)$')
LD_LABEL = re.compile(r'^\s*ld (hl|de|bc), ([A-Za-z_][A-Za-z0-9_]*)(?: \+ (?:\$[0-9A-Fa-f]+|[0-9]+))?\s*(;.*)?$')
LD_A = re.compile(r'^(\s*ld a, )\$([0-9A-Fa-f]{2})(\s*(?:;.*)?)$')
SYM = re.compile(r'^([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4}) ([A-Za-z_][A-Za-z0-9_]*)\s*$')
GENERIC = re.compile(r'^(Data|Tiles|Tilemap|Attrmap|Palette|Font|Table|String|Function|Label)_[0-9A-F]{2}_[0-9A-F]{4}$')
ENTRY = re.compile(r'^\tsprite_object_entry\b')
ENTRY_LABEL = re.compile(r'^(.+)_Entry[0-9]+$')
GLOBAL = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)::?(?:\s*;.*)?$')
BANKS = ('A', 'mapped')
FIXED = re.compile(r'^[0-9A-Fa-f]{2}$')                # a bank number: the routine reads the pointer in that ROM bank whoever calls it
FIRST_POINTER = 0x0150                                # below it lie the restart and interrupt vectors and the cartridge header: `ld de, $0000` is `no hook`, not `Rst_00`
SOURCE_DIRS = ao.SOURCE_DIRS                          # the code that holds the operands
MAP_DIRS = SOURCE_DIRS + ('gfx/',)                    # every file that can hold the target of a pointer


def read_rules(root, path):
    """{(consumer, register): (bank, proof)}; raises ValueError for a malformed row."""
    rules = {}
    with open(os.path.join(root, path), encoding='utf-8') as fh:
        for n, line in enumerate(fh, 1):
            if line.startswith('#') or not line.strip():
                continue
            c = line.rstrip('\n').split('\t')
            if len(c) != 4 or c[1] not in ('hl', 'de', 'bc') or (c[2] not in BANKS and not FIXED.match(c[2])) or not c[0] or not c[3]:
                raise ValueError('%s:%d: a row is consumer, register (hl, de or bc), bank (%s) and a proof' % (path, n, ', '.join(BANKS)))
            if (c[0], c[1]) in rules:
                raise ValueError('%s:%d: %s %s twice' % (path, n, c[0], c[1]))
            rules[(c[0], c[1])] = (c[2], c[3])
    return rules


def read_symbols(root):
    """{(bank, address): [global label names]} and {name: (bank, address)} of build/mobile_trainer.sym (local labels `Parent.local` are left out)."""
    by_addr, by_name = collections.defaultdict(list), {}
    with open(os.path.join(root, 'build', 'mobile_trainer.sym'), encoding='utf-8') as fh:
        for line in fh:
            m = SYM.match(line.strip())
            if m and '.' not in m.group(3):
                k = (int(m.group(1), 16), int(m.group(2), 16))
                by_addr[k].append(m.group(3))
                by_name[m.group(3)] = k
    return by_addr, by_name


def line_map(root, tree):
    """{(bank, address): [(file, line index)]} and {(file, line index): (bank, address)}: every instruction or data line of the source, from ONE build of a marked copy (tools/line_addresses.py).
    Lines inside a macro definition, continuation lines and the lines in front of the first global label of a file cannot carry a marker and are left out."""
    sites = []
    for rel in sorted(tree.files):
        if not rel.endswith('.asm') or not rel.startswith(MAP_DIRS):
            continue
        inmacro = cont = seen = False
        for i, l in enumerate(tree.files[rel]):
            s = l.strip()
            was_cont, cont = cont, s.endswith('\\') and not s.startswith(';')
            if re.match(r'^MACRO\b', l):
                inmacro = True
            if inmacro:
                inmacro = not re.match(r'^ENDM\b', l)
                continue
            if was_cont:
                continue
            if GLOBAL.match(l):
                seen = True
            if l.startswith('\t') and s and not s.startswith(';') and seen:
                sites.append((rel, i + 1))
    res = la.addresses(root, sites)
    at, of = collections.defaultdict(list), {}
    for (rel, n), r in res.items():
        if r:
            k = (int(r[0], 16), int(r[1], 16))
            at[k].append((rel, n - 1))
            of[(rel, n - 1)] = k
    return at, of


def reads_a(ins):
    """True for a plain instruction that reads A without writing it (`ld [de], a`, `ld b, a`, `ldh [x], a`, `cp a, c`, `bit 7, a`, `push af`): the constant is then used by something besides the call."""
    if not isinstance(ins, tuple):
        return False
    m, ops = ins
    return ((m in ('ld', 'ldh') and len(ops) == 2 and ops[1] == 'a') or (m == 'cp' and bool(ops)) or (m == 'bit' and ops[-1:] == ['a']) or (m == 'push' and ops == ['af']))


def a_source(lines, ci):
    """(constant, index of the `ld a, $NN` line or None): the value of A when the call at lines[ci] runs, and the line that sets it when that is an `ld a, $NN` (the spelling LD_A knows, not marked
    `; raw`) whose value nothing but the call reads (an instruction between the load and the call that reads A, `ld [wCount], a` or `ld b, a`, makes the constant a number of its own: the line is
    then left as it is).  The line is the *nearest* write of A, the one that `a_before` read: a spelling that LD_A does not know ends the proof, it never moves it to an older line."""
    value = ao.a_before(lines, ci)
    if value is None:
        return None, None
    for k in range(ci - 1, max(-1, ci - 40), -1):
        ins = ao.parse_insn(lines[k])
        if not isinstance(ins, tuple):
            continue
        if ins[0] == 'ld' and len(ins[1]) == 2 and ins[1][0] == 'a':
            if not LD_A.match(lines[k]) or '; raw' in lines[k]:
                return value, None
            if any(reads_a(ao.parse_insn(lines[j])) for j in range(k + 1, ci)):
                return value, None
            return value, k
        if ins[0] == 'xor' and ins[1] in (['a'], ['a', 'a']):
            return value, None
    return value, None


def choose_label(names):
    """The label to write for an address with several names: a semantic one before a generic one, then the first."""
    semantic = [n for n in names if not GENERIC.match(n)]
    return (semantic or names)[0]


def labels_above(lines, i):
    """The global labels of the run above lines[i]: labels, `sprite_object_entry` lines, blanks and comments, up to the first other line."""
    out = set()
    for k in range(i - 1, -1, -1):
        m = GLOBAL.match(lines[k])
        if m:
            out.add(m.group(1))
        elif not ENTRY.match(lines[k]) and lines[k].strip() and not lines[k].strip().startswith(';'):
            break
    return out


def table_label(tree, rel, i, by_name):
    """(parent label, entry number) for the `sprite_object_entry` line lines[i]: the global label above it with only `sprite_object_entry` lines (and blank or comment lines) in between.  A label
    `<X>_Entry<N>` is passed over (its entries still count) only when `<X>` is itself a label of the run above, i.e. when an earlier run of this tool wrote it: a semantic label that merely ends in
    `_Entry<N>` is a real table label and is the parent."""
    lines = tree.files[rel]
    above = labels_above(lines, i)
    n = 0
    names = []
    for k in range(i - 1, -1, -1):
        line = lines[k]
        m = GLOBAL.match(line)
        me = ENTRY_LABEL.match(m.group(1)) if m else None
        if me and me.group(1) in above:
            continue                                      # `<table>_Entry<N>` written by an earlier run: part of the table, the entries above it still count
        if m:
            names.append(m.group(1))
            if k > 0 and GLOBAL.match(lines[k - 1]):
                continue                                  # another label of the same address above
            break
        if ENTRY.match(line):
            n += 1
        elif line.strip() and not line.strip().startswith(';'):
            return None
    else:
        return None
    parent = choose_label(names)
    return (parent, n) if parent in by_name else None


ROM_BANK_WRITE = re.compile(r'^\s*ld\s+\[\s*(?:\$[23][0-9A-Fa-f]{3}|rROMB[01])\s*\]\s*,\s*a\b', re.I)


def mapped_bank(lines, rel, i, ci, consumer, by_name, of):
    """The ROM bank that is mapped while the consumer reads a pointer of $4000 and above, for a routine that reads it without selecting a bank itself: for a `farcall` to a target of $4000 and above
    the bank of the target (the macro writes `BANK(Label)` as the inline bank byte and BankSwitch_H selects it), else the bank of the code that loads the pointer: a plain `call` or tail `jp` keeps
    it, and so does a `farcall` to a ROM0 label (its inline bank byte is `BANK(Label)` = 0 and BankSwitch_H does nothing for A = 0, `or a, a / ret z`).  The code must be in a ROMX bank, the routine in
    ROM0 or in the same bank, and no write of a ROM bank register may lie between the load and the call; None otherwise."""
    ins = ao.parse_insn(lines[ci])
    target = by_name.get(consumer)
    if isinstance(ins, tuple) and ins[0] == 'farcall' and target and target[1] >= 0x4000:
        return target[0] if target[0] >= 1 else None                  # the inline bank byte of `farcall Label` is BANK(Label)
    me = of.get((rel, i))
    caller = me[0] if me else 0
    if caller < 1 or not target or target[0] not in (0, caller):
        return None
    if any(ROM_BANK_WRITE.match(lines[k]) for k in range(i + 1, ci)):
        return None
    return caller


def bank_only(lines, rel, i, ml, rules, by_name):
    """A row `bank only` for `ld hl|de|bc, Label [+ off]` whose consumer takes the ROM bank in A when the nearest write of A is `ld a, $NN` with the bank of the label: only that line is rewritten."""
    reg, name = ml.group(1), ml.group(2)
    bank, addr = by_name[name]
    if addr < 0x4000 or addr >= 0x8000:
        return None
    consumer, ci, _ = ao.find_consumer_ex(lines, i, reg)
    rule = rules.get((consumer, reg)) if consumer else None
    if rule is None or rule[0] != 'A':
        return None
    a, a_index = a_source(lines, ci)
    if a_index is None or a != bank:
        return None
    return (rel, i, reg, addr, 'bank only', name, consumer, bank, a_index, None)


def plan(tree, rules, by_addr, by_name, at, of, want_lines):
    """Rows (rel, index, reg, value, outcome, text, consumer, bank, a_index, newlabel); `outcome` is `apply` or the reason the operand stays numeric.  `newlabel` is (name, file, index)."""
    rows = []
    for rel in sorted(tree.files):
        if not rel.endswith('.asm') or not rel.startswith(SOURCE_DIRS):
            continue
        lines = tree.files[rel]
        for i, line in enumerate(lines):
            ml = LD_LABEL.match(line)
            if ml and ml.group(2) in by_name and '; raw' not in (ml.group(3) or ''):
                row = bank_only(lines, rel, i, ml, rules, by_name)           # `ld hl, Label` with `ld a, $NN`: the bank follows the label
                if row:
                    rows.append(row)
                continue
            m = LD.match(line)
            if not m or int(m.group(3), 16) >= 0x8000:
                continue
            if '; raw' in m.group(4):
                continue
            reg, v = m.group(2), int(m.group(3), 16)
            consumer, ci, _ = ao.find_consumer_ex(lines, i, reg)
            rule = rules.get((consumer, reg)) if consumer else None
            if rule is None:
                rows.append((rel, i, reg, v, 'no rule', '', consumer or '(none)', None, None, None))
                continue
            if v < FIRST_POINTER:
                rows.append((rel, i, reg, v, 'vector or null', '', consumer, None, None, None))     # $0000 = no pointer, $0008..$014F = the vectors and the header: a number
                continue
            kind = rule[0]
            a_index = None
            if v < 0x4000:
                bank = 0
                if kind == 'A':
                    _, a_index = a_source(lines, ci)
            elif kind == 'mapped':
                bank = mapped_bank(lines, rel, i, ci, consumer, by_name, of)
                if not bank:
                    rows.append((rel, i, reg, v, 'bank not shown', '', consumer, None, None, None))
                    continue
            elif FIXED.match(kind):
                bank = int(kind, 16)
            else:
                a, a_index = a_source(lines, ci)
                if not isinstance(a, int) or not 1 <= a <= 0x7F:
                    rows.append((rel, i, reg, v, 'bank not shown', '', consumer, None, None, None))
                    continue
                bank = a
            k = (bank, v)
            newlabel = None
            if k in by_addr:
                text = choose_label(by_addr[k])
            elif k in at and len(at[k]) == 1 and ENTRY.match(tree.files[at[k][0][0]][at[k][0][1]]):
                f, j = at[k][0]
                t = table_label(tree, f, j, by_name)
                if t is None:
                    rows.append((rel, i, reg, v, 'no label', '', consumer, bank, None, None))
                    continue
                text = '%s_Entry%d' % t
                if text in by_name:
                    rows.append((rel, i, reg, v, 'name taken', '', consumer, bank, None, None))
                    continue
                newlabel = (text, f, j)
            else:
                rows.append((rel, i, reg, v, 'no label' if k not in at else 'not a table entry', '', consumer, bank, None, None))
                continue
            rows.append((rel, i, reg, v, 'apply', text, consumer, bank, a_index if v >= 0x4000 else None, newlabel))
    return rows


def apply_rows(tree, rows):
    """{relpath: new lines}: the operands, the `ld a` lines and the new labels written."""
    new = {}

    def lines_of(rel):
        if rel not in new:
            new[rel] = list(tree.files[rel])
        return new[rel]

    inserts = collections.defaultdict(dict)
    for rel, i, reg, v, outcome, text, consumer, bank, a_index, newlabel in rows:
        if outcome not in ('apply', 'bank only'):
            continue
        L = lines_of(rel)
        if outcome == 'apply':
            m = LD.match(L[i])
            L[i] = m.group(1) + text + m.group(4)
        if a_index is not None:
            ma = LD_A.match(L[a_index])
            if ma and int(ma.group(2), 16) == bank and '; raw' not in ma.group(3):      # a `; raw` line is never rewritten, the `ld a` line included
                L[a_index] = ma.group(1) + 'BANK(%s)' % text + ma.group(3)
        if newlabel:
            name, f, j = newlabel
            inserts[f][j] = '%s:: ; %02X:%04X' % (name, bank, v)
    for f, items in inserts.items():
        L = lines_of(f)
        for j in sorted(items, reverse=True):
            L.insert(j, items[j])
    return new


def main(argv=None):
    ap = argparse.ArgumentParser(description='Write the raw ROM pointers of the code as labels (see the module docstring).')
    ap.add_argument('--consumers', default=CONSUMERS)
    ap.add_argument('--root', default=ROOT)
    ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--check', action='store_true')
    ap.add_argument('--no-build', action='store_true')
    ap.add_argument('--report', metavar='FILE')
    args = ap.parse_args(argv)
    root = os.path.abspath(args.root)
    try:
        tree = ar.Tree.load(root)
        rules = read_rules(root, args.consumers)
        by_addr, by_name = read_symbols(root)
    except (OSError, ValueError) as e:
        print('apply_rom_operands: %s' % e, file=sys.stderr)
        return 2
    try:
        at, of = line_map(root, tree)
    except RuntimeError as e:
        print('apply_rom_operands: %s' % e, file=sys.stderr)
        return 2                                          # could not map the lines (build failed): not the `--check` answer "a rule still proves an operand" (1)
    rows = plan(tree, rules, by_addr, by_name, at, of, None)
    todo = [r for r in rows if r[4] in ('apply', 'bank only')]
    counts = collections.Counter(r[4] for r in rows)
    if args.report:
        with open(args.report, 'w', encoding='utf-8') as fh:
            fh.write('file\tline\treg\tvalue\toutcome\tlabel\tconsumer\tbank\tnew label\n')
            for rel, i, reg, v, outcome, text, consumer, bank, a_index, newlabel in rows:
                fh.write('%s\t%d\t%s\t$%04X\t%s\t%s\t%s\t%s\t%s\n' % (rel, i + 1, reg, v, outcome, text, consumer, '' if bank is None else '%02X' % bank, newlabel[0] if newlabel else ''))
    nlabels = len({r[9][0] for r in todo if r[9]})
    if args.check:
        for rel, i, reg, v, outcome, text, consumer, bank, a_index, newlabel in todo:
            print('  rom  %s:%d  $%04X  -> %s%s' % (rel, i + 1, v, text, '  (bank only)' if outcome == 'bank only' else ''))
        print('apply_rom_operands: --check: %d ROM pointer(s) that a rule proves (%d of them only the bank), %d new label(s); left numeric: %s'
              % (len(todo), counts.get('bank only', 0), nlabels, ', '.join('%d %s' % (n, k) for k, n in sorted(counts.items()) if k not in ('apply', 'bank only'))))
        return 1 if todo else 0
    print('apply_rom_operands: summary: %d operand(s) (%d pointers written as labels, %d bank loads written as BANK(label) only) in %d file(s), %d new label(s); left numeric: %s'
          % (len(todo), counts.get('apply', 0), counts.get('bank only', 0), len({r[0] for r in todo}), nlabels, ', '.join('%d %s' % (n, k) for k, n in sorted(counts.items()) if k not in ('apply', 'bank only'))))
    if args.dry_run:
        by = collections.Counter(r[6] for r in rows if r[4] == 'no rule')
        for c, n in by.most_common(12):
            print('    %5d  no rule: %s' % (n, c))
        print('(dry run: nothing written in the tree; the marked copy that maps the lines was built in a temp directory)')
        return 0
    if not todo:
        return 0
    new = {rel: '\n'.join(lines) for rel, lines in apply_rows(tree, rows).items()}
    originals = {rel: open(os.path.join(root, rel), 'rb').read() for rel in new}

    def restore():
        for rel, data in originals.items():
            with open(os.path.join(root, rel), 'wb') as fh:
                fh.write(data)

    try:
        for rel, text in sorted(new.items()):
            with open(os.path.join(root, rel), 'w', encoding='utf-8', newline='') as fh:
                fh.write(text)
        if args.no_build:
            print('apply_rom_operands: written without verification (--no-build): %d file(s)' % len(new))
            return 0
        ok, msg = ar.verify_tree(root, True, 'mobile_trainer.gbc')
    except BaseException:                                  # an interrupt (Ctrl-C) or an error while writing or building: never leave a tree that was not verified
        restore()
        raise
    if not ok:
        print('apply_rom_operands: VERIFICATION FAILED, restoring %d file(s):\n%s' % (len(new), msg))
        restore()
        ar.verify_tree(root, False, 'mobile_trainer.gbc')
        return 1
    print('apply_rom_operands: verification: %s' % msg)
    return 0


if __name__ == '__main__':
    sys.exit(main())
