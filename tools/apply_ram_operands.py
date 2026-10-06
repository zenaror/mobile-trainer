#!/usr/bin/env python3
"""Write the raw pointer operands of WRAM (`ld hl, $C0A0`) and HRAM as the name of the object they point at (`ld hl, wGlyphBufLeft`).

    python3 tools/apply_ram_operands.py [--areas wram0,hram,io] [--dry-run] [--report FILE] [options]
    python3 tools/apply_ram_operands.py --areas wramx [--consumers FILE] [--calls FILE] [--dry-run] [options]
    python3 tools/apply_ram_operands.py --elements wSpriteSlots [--observed] [--dry-run] [options]
    python3 tools/apply_ram_operands.py --neutral [--observed] [--dry-run] [options]
    python3 tools/apply_ram_operands.py --check [--areas ...] [--elements ... [--observed]] [--neutral] [--root DIR]

  --areas A,B    wram0 ($C000-$CFFF, `ram/wram.asm`), hram ($FF80-$FFFE, `ram/hram.asm`), io ($FF00-$FF7F, the hardware registers of `constants/hardware.inc`) and/or wramx
                 (banked WRAM $D000-$DFFF, the names of `ram/banked.asm`, only where a consumer rule proves the bank, see below); default wram0 (no area when only --elements is given)
  --consumers F  consumer rules of the wramx area (TAB separated; default analysis/naming2/wramx_consumers.tsv)
  --calls F      bank effects of routines, used by the bank proofs (default analysis/naming2/wramx_calls.tsv)
  --elements N   container names of `ram/wram.asm` (an array of records whose elements are named in `ram/banked.asm`): `N + 128` becomes `wSpriteSlot8`, `N + 129` becomes
                 `wSpriteSlot8 + $01`, where the bank of the access is shown (see below)
  --neutral      the neutral banked names `wRam_D000`..`wRam_DFFF` of the generated accesses (`ld a, [wRam_D1A6]`) become the name of `ram/banked.asm` for the bank shown at the access
                 (`wScreenTileMap + $1A6`); a bare `ld hl|de|bc, wRam_Dxxx` is a pointer and stays
  --observed     with --elements, --neutral and --areas wramx (the `switch` rows, the `a` rows with A = 0 and the `(direct)` rows): the replays also prove the bank
                 (analysis/rambank/observed_banks.tsv: every replayed execution of the instruction ran under that bank only; a bank that contradicts the scan, or several banks, leave the
                 site alone; for a pointer the instruction is the one that consumes or dereferences it, or the load when no bank register is written in between); builds a marked copy of the
                 tree to map source lines to ROM addresses (tools/line_addresses.py, needs rgbasm)
  --root DIR     tree to edit (default: the repository root; use it to work in a copy)
  --dry-run      analyse and print what would change; write nothing, build nothing
  --no-build     apply the edit but do not run the build / SHA-256 / sym_check verification (no rollback then!)
  --no-symcheck  run the build and the SHA-256 check but not tools/sym_check.py
  --report FILE  write a TSV with one line per operand (file, line, operand, outcome, replacement, consumer, bank: the last two for the wramx operands, the consumer found and the bank proved)
  --check        read-only audit: lists the operands and expressions that are still raw although the tool can name them; exit 1 when there are some

Why (STYLE.md, RAM): the generator wrote RAM names where code reads or writes a variable (`ld a, [wTimerEnable]`) but left every pointer *immediate* numeric
(`ld hl, $C0A0`), because an immediate can be a constant.  In `$C000-$CFFF` (WRAM0, never banked) it practically never is: it is the address of something, and
`ram/wram.asm` names what is there.  In HRAM and the hardware registers it often is a constant (the 16-bit negative numbers `$FF9C` = -100, `$FFF6` = -10 that `add hl, bc`
adds), so those two areas are rewritten only after a look at the next use of the register.  The edit is a text rewrite of the operand only (`ld hl, $C0A0` ->
`ld hl, wGlyphBufLeft`, `ld de, $C0A3` -> `ld de, wGlyphBufLeft + $03`): `name` is the same number, so no byte of the ROM changes (`make` and the SHA-256 prove it, and the files
are restored if not).  SRAM (`$A000-$BFFF`) is not touched here (tools/apply_banked_names.py).

Rules
  * only code lines of the form `ld hl|de|bc, $XXXX` (4 hex digits, optional trailing comment) in home/ engine/ lib/ data/ audio/;
  * the object that gets the operand is the innermost *semantic* object of the area that covers the address (`DEF name EQU $addr ; size N ...`, start <= addr < start + N, the
    one with the greatest start, then the smallest size); the neutral names (`wRam_C...`, `hRam_FF...`, size 1) are used only when no semantic object covers the address and the
    address is exactly theirs;
  * left numeric: (1) an address that has a screen-local alias in `ram/overlays.asm`, in a file that is inside the scope of that alias (the neutral name would be rewritten into the
    alias by tools/apply_overlay_aliases.py, and a window base such as `ld hl, $C0D4` is not the byte the alias names); (2) a *value*: in HRAM and the hardware registers an operand
    whose first use is `add hl, <the register>` (or `add hl, bc|de` when the register is hl), and in every area a DE that goes to `Sprite_SetPosition` (the Y, X pair) or a BC that goes
    to `CommTime_DrawNumber` (the addend); (3) a line whose trailing comment starts with `; raw` (a human decision, with the reason: a dead load, a scratch use of the buffer, ...), in every mode (--areas, --elements, --neutral)
    and for tools/apply_manual_sites.py too;
    (4) with the banked names (--areas wramx, --elements, --neutral): a name whose DEF line in `ram/banked.asm` says `CAVEAT` (the address has other meanings elsewhere, so the name is
    true only in the flow its comment gives, as `wMailComposeMode` at `$D524`, which other screens use as digit scratch): counted as `caveat`, never written by the tool;
  * an operand with no object at its address stays numeric and is reported.

The wramx area (banked WRAM `$D000-$DFFF`: the same address is another variable in every bank, so the number alone proves nothing).  An operand is rewritten only when a
*consumer rule* proves the bank in which the pointer is dereferenced.  The consumer is the first `call`, `farcall` or tail `jp Label` of the straight line after the load, when only
plain instructions (no label, jump, macro or data line) that do not touch the register come first; a write of a bank register may lie between the load and the call, and the bank of a
`switch` or `a = 0` consumer is then the one shown at the call, never the one of the load.  A row of `analysis/naming2/wramx_consumers.tsv` (consumer,
register, bank W1-W7 or `*`, needs, family, proof) says that this routine dereferences that register in that bank (`*`: the bank that the proof shows, any of W1-W7): `needs` is `-` when the
routine selects the bank itself (`Sprite_InitSlot` selects bank 7 before it writes the slot), `fixed` when the bank is a property of the code and not of its caller (the mail library of bank 0F is entered only
through `Mail_DispatchFar`, which follows the bank 5 idiom, and nothing in the bank writes a WRAM bank register: the proof of the row states the invariant), `switch` when the caller does, `a` when the routine takes the bank of the pointer in A
(`Gfx_StartHDMA`: A = 0 means the bank in force, which holds only for a consumer that the effects table lists as `keeps if A=0`: `TextTiles_RenderGrid` hands A to `ReadByteFar`, which has no test for 0), or `dest` when the bank is the value stored in `hTextTiles_DestBank` (the text renderer: the scan starts at the consumer call, not at the load, and finds the nearest
`ldh [hTextTiles_DestBank], a` with `ld a, $0N` before it in the same straight line, no label, unconditional jump or call but the renderers in between: the store may lie between the load and the call).  The consumer `(direct)` stands for a pointer that no call receives: the first
instruction that uses the register reads or writes memory through it (`ld a, [hl]`), with the bank shown at that instruction as for `switch` (plus the replays with --observed); a local label that
only heads a loop whose body keeps the bank, and a bank switch (the idiom), may come before it.  For `switch` the tool must
show the bank by a backward scan of the straight line: the nearest write
of the bank register must be the idiom `ld a, $0N / ldh [hWRAMBank], a / ldh [rSVBK], a` (or a call to a routine that `sets` the bank in `analysis/naming2/wramx_calls.tsv`); for `a` the
constant in A at the call (`ld a, $NN` or `xor a` as the nearest write of A) must be the bank, or 0 with the idiom showing the bank.  The scan
gives up at a global label, at an unconditional `ret`/`jp`/`jr` (what follows is another path), at a call to a routine that is not known to `keep` the bank (`wramx_calls.tsv` lists
the routines that keep or set it, or keep it `if A=0`; an unknown routine, a conditional call, `rst` or a macro ends the proof), and at a local label unless every way into it shows the same bank (the fall-through from above, unless the line above is an unconditional `ret`/`jp`/`jr`;
each `jr`/`jp` that names the label from above; the back edges of a loop whose body writes no bank register and calls only routines that keep it, provided that no label inside the body is entered from outside it; any other
mention of the label, a `call`, a table word, a load of its address, gives up, and so do more than four nested joins), and in a routine that loads the address of a bank register (`ld de, rSVBK`) anywhere; the scan reaches back
at most 60 lines for each way into a label.  `family` is a regular expression for the name: a rule about sprite slots never writes a palette
name.  The name is the innermost object of `ram/banked.asm` for that bank that covers the address.  Operands without a rule (`no rule`), whose bank is not shown (`bank not shown`),
that have no name in the bank (`no object`), whose name is of another family (`wrong family`) or whose pointer walks further than the object in a loop (`overrun`: a `ld bc, $NNNN`, `ld b, $NN`
or `ld c, $NN` among the two instructions before the load and the ones up to the dereference, for a `(direct)` pointer with a loop head between the load and the dereference, that exceeds the bytes from the pointer to the end of
the object: a wipe or copy over the neighbours; a heuristic that does not see a count in DE or A, set further up, in two immediates or an end-address compare) stay numeric and are counted per consumer, which tells which rule
to write next.

--elements: `ld [wSpriteSlots + 128], a` in the generated code is the byte `$DA80` written as the container name plus a decimal offset.  When the elements of the container (the names
of `ram/banked.asm` that lie inside it: `wSpriteSlot0` ... `wSpriteSlot13`) are known, every code expression `container`, `container + N` or `container + $XX` of a code line
without a string is rewritten as `element` or `element + $XX` (hexadecimal offsets, STYLE.md) when the bank of the access is shown: by the backward scan above (bank of the elements),
or with --observed because every replayed execution of the instruction ran under that bank only (an instruction seen under another bank is reported `other bank`).  A bare
`ld hl|de|bc, container` is the base of the whole array and stays, and so does an expression that is part of a larger one (`container + 16 * 3`, `container - 1`).  The value is
the same, so the ROM does not change.

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
    'wramx': ('ram/banked.asm', 0xD000, 0xE000, re.compile(r'^$^')),
}
BANKED_DEF = re.compile(r'^DEF\s+([A-Za-z_][A-Za-z0-9_]*)\s+EQU\s+\$([0-9A-F]{4})\s*;\s*bank\s+(W[1-7])\s+size\s+(\d+)\b')
CONSUMERS = 'analysis/naming2/wramx_consumers.tsv'
CALLS = 'analysis/naming2/wramx_calls.tsv'
SWITCH_WINDOW = 60                                  # lines searched backwards for the bank-switch idiom
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
FAMILY = {'hl': {'hl', 'h', 'l', '[hl]', '[hli]', '[hld]', '[hl+]', '[hl-]'}, 'bc': {'bc', 'b', 'c', '[bc]', '[c]'}, 'de': {'de', 'd', 'e', '[de]'}}
PLAIN = {'ld', 'ldh', 'push', 'pop', 'xor', 'or', 'and', 'add', 'adc', 'sub', 'sbc', 'inc', 'dec', 'cp', 'bit', 'set', 'res', 'swap', 'sla', 'sra', 'srl', 'rl', 'rr', 'rlc', 'rrc',
         'rla', 'rra', 'rlca', 'rrca', 'cpl', 'ccf', 'scf', 'daa', 'nop', 'di', 'ei'}      # instructions that neither jump nor call: anything else (a macro, a data line) ends a proof
BANK_REGS = ('[rSVBK]', '[hWRAMBank]', '[$FF70]', '[$FF8D]', '[$70]', '[$8D]', '[$ff70]', '[$ff8d]', '[c]',
             'rSVBK', 'hWRAMBank', '$FF70', '$FF8D', '$ff70', '$ff8d')                        # every spelling of the WRAM bank register and its shadow, a store through [c], and the address of either register as an operand
BARE_BANK_REGS = ('rSVBK', 'hWRAMBank', '$FF70', '$FF8D', '$ff70', '$ff8d')            # the address of a bank register or its shadow as an immediate (`ld de, rSVBK`)
CONDITIONS = {'z', 'nz', 'c', 'nc'}
TRANSFERS = {'call', 'jp', 'jr', 'ret', 'reti', 'rst', 'farcall'}


class Obj:
    def __init__(self, name, start, size, neutral, bank=None, caveat=False):
        self.name, self.start, self.size, self.neutral, self.bank, self.caveat = name, start, size, neutral, bank, caveat


def read_objects(tree, area):
    rel, lo, hi, neutral_re = AREAS[area]
    objs = []
    for line in tree.files.get(rel, []):
        if area == 'wramx':
            m = BANKED_DEF.match(line)
            if m:
                objs.append(Obj(m.group(1), int(m.group(2), 16), int(m.group(4)), False, m.group(3), 'CAVEAT' in line))
            continue
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


REGTOK = re.compile(r'^\[?(?:af|bc|de|hl|sp|[abcdehl]|hli|hld|hl\+|hl-|nz|z|nc)\]?$', re.I)


def parse_insn(line):
    """None for a global label or a directive (the straight line ends), '' for a blank or comment-only line, else (mnemonic, operands); registers and conditions are lower-cased."""
    raw = line.split(';')[0]
    if not raw.strip():
        return ''
    if not raw.startswith('\t'):
        return None
    parts = raw.strip().split(None, 1)
    ops = [o.strip() for o in parts[1].split(',')] if len(parts) > 1 else []
    return parts[0].lower(), [o.lower() if REGTOK.match(o) else o for o in ops]


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


def read_tsv(root, path, what):
    """The rows (list of column lists, with the file line number) of a TAB separated file under the root (or absolute); `#` and blank lines are skipped."""
    full = path if os.path.isabs(path) else os.path.join(root, path)
    try:
        with open(full, encoding='utf-8') as f:
            text = f.read().split('\n')
    except OSError as e:
        raise ValueError('cannot read the %s: %s' % (what, e))
    return [(n, line.split('\t')) for n, line in enumerate(text, 1) if line.strip() and not line.startswith('#')]


def read_rules(root, path):
    """{(consumer, register): (bank, needs, family regex, proof)} of the consumer rules file; raises ValueError on a missing file or a malformed row."""
    rules = {}
    for n, cols in read_tsv(root, path, 'consumer rules'):
        if len(cols) != 6:
            raise ValueError('%s:%d: 6 TAB separated columns expected (consumer, register, bank, needs, family, proof)' % (path, n))
        consumer, reg, bank, needs, family, proof = [c.strip() for c in cols]
        try:
            re.compile(family)
        except re.error:
            family = ''
        if (reg not in ('hl', 'de', 'bc') or not re.match(r'^(W[1-7]|\*)$', bank) or needs not in ('-', 'fixed', 'switch', 'a', 'dest') or not consumer or not family or not proof
                or (bank == '*' and needs in ('-', 'fixed')) or (consumer == DIRECT and needs != 'switch')):      # `(direct)` has no routine that selects the bank or takes it in A
            raise ValueError('%s:%d: bad rule row %r' % (path, n, cols[:5]))
        if (consumer, reg) in rules:
            raise ValueError('%s:%d: duplicate rule for %s %s' % (path, n, consumer, reg))
        rules[(consumer, reg)] = (bank, needs, family, proof)
    return rules


def read_calls(root, path):
    """{routine: 'keeps' | 'keeps0' | 'W1'..'W7'} of the bank effects file (routine, effect, proof): `keeps` = the WRAM bank in force is the same after the call, `keeps if A=0` = the same when A is
    the constant 0 at the call (the routine takes a bank in A, 0 meaning none), `sets W7` = it is bank 7 after the call."""
    effects = {}
    for n, cols in read_tsv(root, path, 'bank effects of calls'):
        if len(cols) != 3:
            raise ValueError('%s:%d: 3 TAB separated columns expected (routine, effect, proof)' % (path, n))
        routine, effect, proof = [c.strip() for c in cols]
        m = re.match(r'^(keeps|keeps if A=0|sets (W[1-7]))$', effect)
        if not routine or not m or not proof:
            raise ValueError('%s:%d: bad row %r' % (path, n, cols[:2]))
        if routine in effects:
            raise ValueError('%s:%d: duplicate routine %s' % (path, n, routine))
        effects[routine] = 'keeps' if effect == 'keeps' else 'keeps0' if effect == 'keeps if A=0' else m.group(2)
    return effects


def find_consumer_ex(lines, i, reg):
    """(routine, line index, bank_changed): as find_consumer, but a write of a bank register between the load and the call does not end the search: `bank_changed` is then True and the bank of a
    `switch` consumer is the one shown *at the call* (bank_at(lines, ci)), never the one of the load (the replays saw the load, not the call)."""
    changed = False
    for j in range(i + 1, min(i + 60, len(lines))):
        if lines[j].startswith('.'):
            return None, None, False                       # a local label: another path joins here
        ins = parse_insn(lines[j])
        if ins is None:
            return None, None, False
        if ins == '':
            continue
        m, ops = ins
        if m == 'farcall' and len(ops) == 1:
            return ops[0], j, changed
        if m == 'call' and len(ops) == 1:
            return ops[0], j, changed                      # (a conditional `call nz, X` has two operands: not a proof)
        if m == 'jp' and len(ops) == 1 and ops[0] != 'hl' and re.match(r'^[A-Za-z_][A-Za-z0-9_]*$', ops[0]):
            return ops[0], j, changed                      # a tail call: `jp Sprite_SetPosition`
        if m not in PLAIN:
            return None, None, False                       # another transfer, a macro, a data line
        if any(o in FAMILY[reg] for o in ops):
            return None, None, False                       # the register is touched before the call
        if any(o in BANK_REGS for o in ops):
            changed = True                                 # the bank changes between the load and the call: the proof is made at the call
    return None, None, False


GLOBAL_LABEL = re.compile(r'^[A-Za-z_][A-Za-z0-9_]*::?')
IMM8 = re.compile(r'^\$([0-9A-F]{2})$', re.I)


def writes_bank(ins):
    """True for `ldh|ld [rSVBK|hWRAMBank], a` (any spelling of the two)."""
    return bool(ins) and ins[0] in ('ldh', 'ld') and len(ins[1]) == 2 and ins[1][0] in BANK_REGS


def previous_insns(lines, j, count):
    """The `count` instructions before lines[j] in the straight line, nearest first (fewer when a label or directive comes first)."""
    out = []
    for k in range(j - 1, max(-1, j - 1 - SWITCH_WINDOW), -1):
        line = lines[k]
        if line.startswith('.') or (line.strip() and not line.startswith('\t') and not line.startswith(';')):
            break
        ins = parse_insn(line)
        if ins is None or ins == '':
            continue
        out.append(ins)
        if len(out) == count:
            break
    return out


def call_effect(ins, effects):
    """The bank effect of a call/farcall instruction (`keeps`, `W7`, or None when unknown, conditional or not in the effects table)."""
    m, ops = ins
    if m not in ('call', 'farcall') or len(ops) != 1:
        return None
    return effects.get(ops[0])


DEST_REG = '[hTextTiles_DestBank]'
DEST_READERS = ('TextTiles_RenderLine', 'TextTiles_RenderGrid', 'TextTiles_RenderGridRows')      # they read hTextTiles_DestBank and never write it


def dest_bank_before(lines, i):
    """The WRAM bank N (1-7) that the straight line before lines[i] stored in hTextTiles_DestBank: the nearest `ldh [hTextTiles_DestBank], a` with the constant in A from `ld a, $0N` (other
    stores of the same A may come between).  Every writer of the variable is such an inline store, so the scan gives up only at a label (loop heads are not passed), an unconditional
    `ret`/`jp`/`jr`, a conditional call, `rst`, a macro or a data line, and at any call except the TextTiles_Render* routines, which only read it."""
    for j in range(i - 1, max(-1, i - 1 - SWITCH_WINDOW), -1):
        line = lines[j]
        if line.startswith('.') or (line.strip() and not line.startswith('\t') and not line.startswith(';')):
            return None
        ins = parse_insn(line)
        if ins is None or ins == '':
            continue
        m, ops = ins
        if m in ('ldh', 'ld') and len(ops) == 2 and ops[0] == DEST_REG and ops[1] == 'a':
            n = a_before(lines, j)
            return n if n is not None and 1 <= n <= 7 else None
        if m in ('ret', 'reti') and not ops:
            return None
        if m in ('jp', 'jr') and len(ops) == 1:
            return None
        if m in ('ret', 'reti', 'jp', 'jr'):
            continue
        if m in ('call', 'farcall'):
            if len(ops) == 1 and ops[0] in DEST_READERS:
                continue
            return None
        if m not in PLAIN:
            return None
    return None


def keeps_bank(lines, k, ins, effects):
    """True when the call at lines[k] is known to leave the bank in force alone (`keeps`, or `keeps if A=0` with A = 0 at the call)."""
    eff = call_effect(ins, effects)
    return eff == 'keeps' or (eff == 'keeps0' and a_before(lines, k) == 0)



def interior_entries_ok(lines, j, last, s, e):
    """True when no local label inside the loop body (j, last] is mentioned from outside [j, last] or by anything but a jr/jp: such a label is a second way into the body (a jump over the head,
    a table word, a load of its address), which would bring a bank that the head does not show to the back edge."""
    for x in range(j + 1, last + 1):
        if not lines[x].startswith('.'):
            continue
        name = lines[x].split(';')[0].strip().rstrip(':')
        pat = re.compile(r'(?<![A-Za-z0-9_.])%s(?![A-Za-z0-9_])' % re.escape(name))
        for y in range(s, e):
            if y == x or not pat.search(lines[y].split(';')[0]):
                continue
            ins = parse_insn(lines[y])
            if not ins or ins[0] not in ('jr', 'jp') or ins[1] == ['hl'] or not (j < y <= last):
                return False
    return True


def loop_head_keeps_bank(lines, j, effects, need_ref=False):
    """True when the local label at lines[j] is only the head of a loop (every reference is a jr/jp *after* it, inside the same routine) and the loop body, from the head to the last back
    edge, neither writes the bank register nor calls a routine that is not known to keep the bank, and no label inside the body is a second way in (interior_entries_ok): the bank at the head is
    then the bank of the code that falls into it.  With `need_ref` the label must really be jumped back to (a label with no reference is no loop head: the search for the dereference of a pointer
    passes loop heads only)."""
    name = lines[j].split(';')[0].strip().rstrip(':')
    s = j
    while s > 0 and not GLOBAL_LABEL.match(lines[s]):
        s -= 1
    e = j + 1
    while e < len(lines) and not GLOBAL_LABEL.match(lines[e]):
        e += 1
    pat = re.compile(r'(?<![A-Za-z0-9_.])%s(?![A-Za-z0-9_])' % re.escape(name))
    refs = []
    for k in range(s, e):
        if k == j or not pat.search(lines[k].split(';')[0]):
            continue
        ins = parse_insn(lines[k])
        if not ins or k < j or ins[0] not in ('jr', 'jp'):
            return False                                   # a forward jump, a call or a data reference: another path enters here
        refs.append(k)
    if need_ref and not refs:
        return False
    last = max(refs) if refs else j
    for k in range(j + 1, last + 1):
        ins = parse_insn(lines[k])
        if not ins:
            continue
        if writes_bank(ins) or any(o in BANK_REGS for o in ins[1]):
            return False
        if ins[0] in ('call', 'farcall') and not keeps_bank(lines, k, ins, effects):
            return False
        if ins[0] not in PLAIN and ins[0] not in ('jr', 'jp', 'ret', 'reti', 'call', 'farcall'):
            return False                                   # rst, a macro, a data line
    if refs and not interior_entries_ok(lines, j, last, s, e):
        return False
    return True


def label_join_bank(lines, j, effects, depth=0):
    """The WRAM bank in force at the local label lines[j] when every way into it shows the same bank, else None.  The ways in are the fall-through from the code above (none when the previous
    instruction is an unconditional `ret`/`jp`/`jr`; a global label or a data line above gives up), every `jr`/`jp` that names the label (conditional or not) from *above* it, and the back edges from
    below, which add nothing when the loop body writes no bank register, calls only routines that keep it and has no label that is entered from outside the body (interior_entries_ok).  Any other mention of the label (a `call`, a `dw`, a `ld`) is an entry from elsewhere
    and gives up, and so does a nesting deeper than four joins (the scans only go up the routine, so there are no cycles).  Every way in is scanned like bank_at; the answer is the bank
    that all of them show."""
    if depth >= 4:
        return None
    s = j
    while s > 0 and not GLOBAL_LABEL.match(lines[s]):
        s -= 1
    e = j + 1
    while e < len(lines) and not GLOBAL_LABEL.match(lines[e]):
        e += 1
    run = [j]                                            # adjacent labels name the same address
    k = j - 1
    while k >= s and (lines[k].startswith('.') or not lines[k].strip() or lines[k].lstrip().startswith(';')):
        if lines[k].startswith('.'):
            run.append(k)
        k -= 1
    top = min(run)
    names = [lines[x].split(';')[0].strip().rstrip(':') for x in run]
    forward, back = [], []
    for name in names:
        pat = re.compile(r'(?<![A-Za-z0-9_.])%s(?![A-Za-z0-9_])' % re.escape(name))
        for x in range(s, e):
            if x in run or not pat.search(lines[x].split(';')[0]):
                continue
            ins = parse_insn(lines[x])
            if not ins or ins[0] not in ('jr', 'jp') or ins[1] == ['hl']:
                return None                              # a call, a table word, a load of the address: an entry the scan cannot see
            (forward if x < top else back).append(x)
    if back:
        last = max(back)
        for x in range(j + 1, last + 1):                 # the loop body must keep the bank
            ins = parse_insn(lines[x])
            if not ins:
                continue
            if writes_bank(ins) or any(o in BANK_REGS for o in ins[1]):
                return None
            if ins[0] in ('call', 'farcall') and not keeps_bank(lines, x, ins, effects):
                return None
            if ins[0] not in PLAIN and ins[0] not in ('jr', 'jp', 'ret', 'reti', 'call', 'farcall'):
                return None
        if not interior_entries_ok(lines, j, last, s, e):
            return None
    banks = []
    prev = None                                          # the instruction before the run of labels
    for x in range(top - 1, s - 1, -1):
        if lines[x].strip() and not lines[x].lstrip().startswith(';'):
            prev = x
            break
    if prev is None:
        return None
    ins = parse_insn(lines[prev])                        # None for the global label that starts the routine: the scan from the label gives up there
    falls = not (ins and ((ins[0] in ('ret', 'reti') and not ins[1]) or (ins[0] in ('jp', 'jr') and len(ins[1]) == 1)))
    if falls:
        banks.append(bank_at(lines, top, effects, depth + 1))
    for x in forward:
        banks.append(bank_at(lines, x, effects, depth + 1))
    if not banks or banks[0] is None or any(b != banks[0] for b in banks):
        return None
    return banks[0]



def routine_materializes_bank_address(lines, i):
    """True when the routine that contains lines[i] (between the global labels around it) loads the address of a bank register or of its shadow into any register (`ld de, rSVBK`, `ld hl, $FF70`),
    anywhere: a later `ld [de], a` would then be a bank write that no backward scan can see, whatever the distance to the idiom."""
    s = i
    while s > 0 and not GLOBAL_LABEL.match(lines[s]):
        s -= 1
    e = i + 1
    while e < len(lines) and not GLOBAL_LABEL.match(lines[e]):
        e += 1
    for x in range(s, e):
        ins = parse_insn(lines[x])
        if ins and ins != '' and not writes_bank(ins) and any(o in BARE_BANK_REGS for o in ins[1]):
            return True
    return False


def bank_at(lines, i, effects, depth=0):
    """The WRAM bank N (1-7) in force when lines[i] runs, found by a backward scan of the straight line: the nearest write of the bank register must be the idiom `ld a, $0N / ldh [hWRAMBank], a /
    ldh [rSVBK], a`, or a call to a routine that `sets` the bank (analysis/naming2/wramx_calls.tsv).  The scan gives up (None) at a global label, at an unconditional `ret`/`jp`/`jr` (the code
    below is another path), at a call whose effect is unknown or not `keeps`, at a conditional call, at `rst`, a macro or a data line, and at a local label unless every way into it shows the same bank
    (label_join_bank), and refuses every proof in a routine that loads the address of a bank register (routine_materializes_bank_address); calls between the idiom and the site must be known to keep the bank."""
    if depth == 0 and routine_materializes_bank_address(lines, i):
        return None
    for j in range(i - 1, max(-1, i - 1 - SWITCH_WINDOW), -1):
        line = lines[j]
        if line.startswith('.'):
            return label_join_bank(lines, j, effects, depth)
        if line.strip() and not line.startswith('\t') and not line.startswith(';'):
            return None                                    # a global label or directive: the routine may be entered from anywhere
        ins = parse_insn(line)
        if ins is None or ins == '':
            continue
        m, ops = ins
        if not writes_bank(ins) and any(o in BARE_BANK_REGS for o in ops):
            return None                                    # the address of a bank register is loaded (`ld de, $FF70`): a store through it may change the bank
        if writes_bank(ins):
            if ops[0] not in ('[rSVBK]', '[$FF70]'):
                return None                                # the shadow written alone
            back = previous_insns(lines, j, 2)
            if len(back) < 2:
                return None
            second, first = back                           # the instruction right before the write, and the one before that
            if (second[0] in ('ldh', 'ld') and len(second[1]) == 2 and second[1][0] in ('[hWRAMBank]', '[$FF8D]') and second[1][1] == 'a'
                    and first[0] == 'ld' and len(first[1]) == 2 and first[1][0] == 'a'):
                mm = IMM8.match(first[1][1])
                if mm and 1 <= int(mm.group(1), 16) <= 7:
                    return int(mm.group(1), 16)
            return None
        if m in ('ret', 'reti') and not ops:
            return None                                    # unconditional: what follows is another path (a fragment)
        if m in ('jp', 'jr') and len(ops) == 1:
            return None                                    # unconditional (jp hl too)
        if m in ('ret', 'reti', 'jp', 'jr'):
            continue                                       # conditional: the fall-through path
        if m in ('call', 'farcall'):
            if keeps_bank(lines, j, ins, effects):
                continue
            eff = call_effect(ins, effects)
            if eff and eff[0] == 'W':
                return int(eff[1])                         # the routine leaves this bank selected
            return None
        if m not in PLAIN:
            return None                                    # rst, a macro, a data line
    return None


def bank_switch_before(lines, i, bank, effects):
    """True when bank_at shows this bank (`W7`)."""
    return bank_at(lines, i, effects) == int(bank[1])


def a_before(lines, ci):
    """The constant in A when the call at lines[ci] runs: the nearest write of A in the straight line before it is `ld a, $NN` or `xor a`; None for any other write of A, a label, a jump
    or a call on the way (the registers they leave are unknown)."""
    for k in range(ci - 1, max(-1, ci - 40), -1):
        line = lines[k]
        if line.startswith('.') or (line.strip() and not line.startswith('\t') and not line.startswith(';')):
            return None
        ins = parse_insn(line)
        if ins is None or ins == '':
            continue
        m, ops = ins
        if m not in PLAIN:
            return None
        if m == 'ld' and len(ops) == 2 and ops[0] == 'a':
            mm = IMM8.match(ops[1])
            return int(mm.group(1), 16) if mm else None
        if m == 'xor' and ops in (['a'], ['a', 'a']):
            return 0
        if (m in ('and', 'or', 'xor', 'sub', 'sbc', 'adc') or (m == 'add' and not (ops and ops[0] in ('hl', 'sp'))) or (m in ('inc', 'dec', 'swap', 'rl', 'rr', 'rlc', 'rrc', 'sla', 'sra', 'srl', 'res', 'set') and 'a' in ops)
                or m in ('rla', 'rra', 'rlca', 'rrca', 'cpl', 'daa') or (m == 'pop' and ops == ['af']) or (m == 'ldh' and ops and ops[0] == 'a')):
            return None
    return None


DEREF = {'hl': {'[hl]', '[hli]', '[hld]', '[hl+]', '[hl-]'}, 'de': {'[de]'}, 'bc': {'[bc]'}}
DIRECT = '(direct)'                                  # the pseudo consumer of a pointer that is dereferenced by the next instruction that uses it


def first_use_deref(lines, i, reg, effects):
    """(index, bank_changed, looped) of the instruction that dereferences the register loaded at lines[i] as its first use (`ld a, [hl]`, `ld [de], a`, `ld a, [hli]`, `inc [hl]`, ...), or
    (None, False, False) when a label, jump, call, macro or data line comes first or the first instruction that uses the register does anything but dereference it.  Two things do not end the
    search: (1) a local label that only heads a loop whose body keeps the bank (loop_head_keeps_bank: every reference is a backward jr/jp of the same routine), since the fall-through path is
    the only way into the first pass (`looped` is then True: the dereference walks on from the pointer, see loop_count); (2) a write of a bank register between the load and the use:
    `bank_changed` is then True and the bank is the one shown at the use (bank_at(lines, index)), so a replay mask of the load is no proof."""
    changed = looped = False
    for j in range(i + 1, min(i + 30, len(lines))):
        if lines[j].startswith('.'):
            if loop_head_keeps_bank(lines, j, effects, need_ref=True):
                looped = True
                continue
            return None, False, False
        ins = parse_insn(lines[j])
        if ins is None:
            return None, False, False
        if ins == '':
            continue
        m, ops = ins
        if m not in PLAIN:
            return None, False, False
        if any(o in BANK_REGS for o in ops):
            changed = True
            continue
        if any(o in FAMILY[reg] for o in ops):
            return ((j, changed, looped) if any(o in DEREF[reg] for o in ops) else (None, False, False))
    return None, False, False


COUNT_LD = re.compile(r'^ld (bc|b|c), \$([0-9A-F]+)$', re.I)


def loop_count(lines, i, ci):
    """The largest byte count that the straight line around a pointer loop shows: an immediate `ld bc, $NNNN` (not $FFFF, the start of a pre-incremented length count), `ld b, $NN` or `ld c, $NN`
    (0 = 256) among the two instructions before the load lines[i] and the ones up to the dereference lines[ci]; None when there is none.  A loop that walks further than the object that the
    pointer names is a wipe or copy over the neighbours, which the project leaves raw (the rule rows say so for FillBytes and CopyBytes)."""
    best = None
    for k in list(range(max(0, i - 2), i)) + list(range(i + 1, ci)):
        mm = COUNT_LD.match(lines[k].split(';')[0].strip())
        if not mm:
            continue
        n = int(mm.group(2), 16)
        if mm.group(1).lower() == 'bc':
            if n == 0xFFFF:
                continue
        elif n == 0:
            n = 256
        best = n if best is None else max(best, n)
    return best


NO_MASK = object()                                   # no replay evidence usable for the site


def evidence_mask(masks, rel, i, ci, changed):
    """The replay mask that proves the bank of the pointer loaded at lines[i] and consumed (called, dereferenced) at lines[ci]: the mask of the consumer instruction when the replays have one
    (its bank is the bank in force where the pointer is used), else the mask of the load when no bank register is written in between; NO_MASK when there is none (no replays, or the bank
    changes between load and consumer and the consumer was never mapped or never executed: `None` is a mapped instruction that never ran, which proves nothing either way)."""
    if masks is None:
        return NO_MASK
    at = masks.get((rel, ci + 1))
    if at:
        return at
    if changed:
        return NO_MASK
    return masks.get((rel, i + 1))


def mask_conflict(mask, static):
    """True when the replays saw the instruction under several banks, or under a bank other than the one the scan shows."""
    if not mask:
        return False
    return mask & (mask - 1) != 0 or (static is not None and mask != 1 << static)


def single_bank(mask):
    """The bank of a replay mask with exactly one bit set, else None (never executed, or seen under several banks)."""
    return mask.bit_length() - 1 if mask and mask & (mask - 1) == 0 else None


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


def plan(tree, areas, rules=None, effects=None, masks=None, why=None):
    """List of (relpath, index, operand_value, outcome, replacement); the replacement of a `no rule` row is the consumer found.  `why`, a dict, receives {(relpath, index): (consumer, bank)}
    for every wramx operand (the consumer the tool found, `(direct)` for a pointer dereferenced by the next instruction, and the bank it proved, 0 for none)."""
    effects = {} if effects is None else effects
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
            elif area == 'wramx':
                consumer, ci, changed = find_consumer_ex(lines, i, reg)
                direct = looped = False
                if consumer is None and (DIRECT, reg) in rules:
                    di, changed, looped = first_use_deref(lines, i, reg, effects)
                    if di is not None:
                        direct, consumer, ci = True, DIRECT, di      # ci: the instruction that dereferences the pointer
                rule = rules.get((consumer, reg)) if consumer else None
                n = None
                if rule is not None:
                    rbank, needs = rule[0], rule[1]
                    if needs in ('-', 'fixed'):
                        n = int(rbank[1])
                    elif needs == 'switch':
                        n = bank_at(lines, ci, effects)                     # the bank in force where the pointer is consumed (a bank switch may lie between the load and the call)
                        mk = evidence_mask(masks, rel, i, ci, changed)
                        if mk != NO_MASK:                                   # the replays: the consumer (or, when nothing switches in between, the load) ran under one bank only
                            if mask_conflict(mk, n):
                                n = None
                            elif n is None:
                                n = single_bank(mk)
                    elif needs == 'a':
                        a = a_before(lines, ci)            # the routine takes the bank of the pointer in A; A = 0 keeps the bank in force
                        n = (a if 1 <= a <= 7 else None) if a else (bank_at(lines, ci, effects) if a == 0 and effects.get(consumer) == 'keeps0' else None)      # A = 0 is `the bank in force` only for a routine that the effects table lists as `keeps if A=0`
                        mk = evidence_mask(masks, rel, i, ci, changed) if a == 0 and effects.get(consumer) == 'keeps0' else NO_MASK
                        if mk != NO_MASK:                                   # A = 0 means `the bank in force`, shown like `switch`
                            if mask_conflict(mk, n):
                                n = None
                            elif n is None:
                                n = single_bank(mk)
                    else:
                        n = dest_bank_before(lines, ci)    # scan from the consumer call (the store lies between the load and the call in 32 of 147 operands)
                    if n is not None and rbank != '*' and n != int(rbank[1]):
                        n = None
                if why is not None:
                    why[(rel, i)] = (consumer or '', n or 0)
                if rule is None:
                    rows.append((rel, i, v, 'no rule', consumer or '(none)'))
                elif n is None:
                    rows.append((rel, i, v, 'bank not shown', consumer))
                else:
                    obj = choose([o for o in tables[area][0] if o.bank == 'W%d' % n], v)
                    if obj is None:
                        rows.append((rel, i, v, 'no object', consumer))
                    elif not re.fullmatch(rule[2], obj.name):
                        rows.append((rel, i, v, 'wrong family', '%s %s' % (consumer, obj.name)))      # the rule is about another kind of object
                    elif obj.caveat:
                        rows.append((rel, i, v, 'caveat', '%s %s' % (consumer, obj.name)))            # the DEF line says the address has other meanings: the name is not written by a tool
                    elif looped and (loop_count(lines, i, ci) or 0) > obj.start + obj.size - v:
                        rows.append((rel, i, v, 'overrun', '%s %s' % (consumer, obj.name)))           # a loop over more bytes than the object has: a wipe or copy over the neighbours, left raw
                    else:
                        rows.append((rel, i, v, 'apply', text_for(obj, v)))
            else:
                obj = choose(tables[area][0], v)
                if obj is None:
                    rows.append((rel, i, v, 'no object', ''))
                else:
                    rows.append((rel, i, v, 'apply', text_for(obj, v)))
    return rows


def lines_of(tree, new, rel):
    return new[rel] if rel in new else list(tree.files[rel])


def apply_rows(tree, rows, new):
    """Apply the operand rewrites to `new` ({relpath: list of lines}, edited in place)."""
    for rel, i, v, outcome, text in rows:
        if outcome != 'apply':
            continue
        lines = lines_of(tree, new, rel)
        m = LD.match(lines[i])
        lines[i] = m.group(1) + text + m.group(3)
        new[rel] = lines
    return new


def container_info(tree, name):
    for line in tree.files.get('ram/wram.asm', []):
        m = OBJ_DEF.match(line)
        if m and m.group(1) == name:
            return int(m.group(2), 16), int(m.group(3))
    return None


def split_code(line):
    k = line.find(';')
    return (line, '') if k < 0 else (line[:k], line[k:])


def observed_masks(root, sites):
    """{(file, line): wram_mask or None} of analysis/rambank/observed_banks.tsv for the instruction at every source line (None: unmapped or never executed in the replays); builds a marked copy of the tree."""
    import line_addresses as la
    res = la.addresses(root, sorted(sites))
    out = {}
    for s, r in res.items():
        out[s] = None if r is None else la.observed_wram_mask(root, r[0], r[1])
    return out


def plan_elements(tree, containers, observed=None, effects=None):
    """List of (relpath, index, start, end, old, outcome, new): every `container`, `container + N` expression of a code line, and what the element name for it is.
    The bank of the access must be shown: the idiom of bank_switch_before, or (with `observed`, {(file, line): mask}) the replays saw the instruction under that bank only; an instruction
    seen under another bank is `other bank`, one with no proof `bank not shown`; a match that is part of a larger arithmetic expression is `complex` and left alone."""
    effects = {} if effects is None else effects
    banked = read_objects(tree, 'wramx')
    rows = []
    for cname in containers:
        info = container_info(tree, cname)
        if info is None:
            raise ValueError('%s is not defined in ram/wram.asm' % cname)
        cstart, csize = info
        elems = [o for o in banked if cstart <= o.start and o.start + o.size <= cstart + csize]
        if not elems:
            raise ValueError('ram/banked.asm has no names inside %s ($%04X-$%04X)' % (cname, cstart, cstart + csize - 1))
        banks = sorted({o.bank for o in elems})
        if len(banks) != 1:
            raise ValueError('the elements of %s are in several banks: %s' % (cname, ', '.join(banks)))
        bank = banks[0]
        bit = 1 << int(bank[1])
        pat = re.compile(r'\b%s\b(?:\s*\+\s*(\$[0-9A-Fa-f]+|\d+)\b)?' % re.escape(cname))
        base = re.compile(r'^\s*ld (?:hl|de|bc), %s\s*$' % re.escape(cname))
        for rel in sorted(tree.files):
            if not rel.endswith('.asm') or not rel.startswith(SOURCE_DIRS):
                continue
            for i, line in enumerate(tree.files[rel]):
                if not line.startswith('\t'):
                    continue
                code, comment = split_code(line)
                if '"' in code or base.match(code) or RAW_MARK.search(comment):
                    continue                               # a string, the base of the whole array, or a line marked `; raw`
                for m in pat.finditer(code):
                    before = code[:m.start()].rstrip()[-1:]
                    after = code[m.end():].lstrip()[:1]
                    if before in tuple('-*/%&|^<>~(') or after in tuple('*/%&|^<>-+'):
                        rows.append((rel, i, m.start(), m.end(), m.group(0), 'complex', ''))        # `N + 16 * 3`, `N - 1`: not a plain offset
                        continue
                    n = 0 if m.group(1) is None else (int(m.group(1)[1:], 16) if m.group(1).startswith('$') else int(m.group(1)))
                    addr = cstart + n
                    cover = [o for o in elems if o.start <= addr < o.start + o.size]
                    if not cover:
                        rows.append((rel, i, m.start(), m.end(), m.group(0), 'no element', ''))
                        continue
                    seen = observed.get((rel, i + 1)) if observed is not None else None
                    if max(cover, key=lambda o: (o.start, -o.size)).caveat:
                        outcome = 'caveat'
                    elif seen is not None and seen != bit:
                        outcome = 'other bank'                 # the replays saw this instruction under another bank (or under several)
                    elif seen == bit or bank_switch_before(tree.files[rel], i, bank, effects):
                        outcome = 'apply'
                    else:
                        outcome = 'bank not shown'
                    rows.append((rel, i, m.start(), m.end(), m.group(0), outcome, text_for(max(cover, key=lambda o: (o.start, -o.size)), addr)))
    return rows


def apply_elements(tree, rows, new):
    """Apply the element rewrites to `new` ({relpath: list of lines}, edited in place)."""
    by_line = {}
    for rel, i, s, e, old, outcome, text in rows:
        if outcome == 'apply':
            by_line.setdefault((rel, i), []).append((s, e, text))
    for (rel, i), items in by_line.items():
        lines = lines_of(tree, new, rel)
        line = lines[i]
        for s, e, text in sorted(items, reverse=True):
            line = line[:s] + text + line[e:]
        lines[i] = line
        new[rel] = lines
    return new


NEUTRAL_WRAMX = re.compile(r'\bwRam_(D[0-9A-F]{3})\b(?:\s*\+\s*(\$[0-9A-Fa-f]+|\d+)\b)?')


def plan_neutral(tree, observed=None, effects=None):
    """List of (relpath, index, start, end, old, outcome, new): every use of a neutral banked name `wRam_Dxxx` (or `wRam_Dxxx + N`) in a code line and the name of `ram/banked.asm` that replaces it
    when the bank of the access is shown: by the backward scan (bank_at), or with `observed` ({(file, line): mask}) because every replayed execution of the instruction ran under one bank.
    A static and a dynamic bank that differ, an instruction seen under several banks, or no proof leave the use as it is (`other bank`, `bank not shown`); a bare `ld hl|de|bc, wRam_Dxxx`
    (a pointer: its bank is the consumer's, see --areas wramx), a larger arithmetic expression (`complex`) and an address with no name in that bank (`no object`) too."""
    effects = {} if effects is None else effects
    objs = read_objects(tree, 'wramx')
    rows = []
    pointer = re.compile(r'^\s*ld (?:hl|de|bc), wRam_D[0-9A-F]{3}\s*$')
    for rel in sorted(tree.files):
        if not rel.endswith('.asm') or not rel.startswith(SOURCE_DIRS):
            continue
        lines = tree.files[rel]
        for i, line in enumerate(lines):
            if not line.startswith('\t'):
                continue
            code, comment = split_code(line)
            if '"' in code or pointer.match(code) or RAW_MARK.search(comment):          # a line marked `; raw` is a human decision
                continue
            for m in NEUTRAL_WRAMX.finditer(code):
                before = code[:m.start()].rstrip()[-1:]
                after = code[m.end():].lstrip()[:1]
                if before in tuple('-*/%&|^<>~(') or after in tuple('*/%&|^<>-+'):
                    rows.append((rel, i, m.start(), m.end(), m.group(0), 'complex', ''))
                    continue
                add = 0 if m.group(2) is None else (int(m.group(2)[1:], 16) if m.group(2).startswith('$') else int(m.group(2)))
                addr = int(m.group(1), 16) + add
                if not 0xD000 <= addr < 0xE000:
                    continue
                static = bank_at(lines, i, effects)
                mask = observed.get((rel, i + 1)) if observed is not None else None
                dynamic = None if not mask else (mask.bit_length() - 1 if mask & (mask - 1) == 0 else -1)      # -1: several banks
                if dynamic == -1 or (static and dynamic is not None and static != dynamic):
                    rows.append((rel, i, m.start(), m.end(), m.group(0), 'other bank', ''))
                    continue
                bank = static or dynamic
                if not bank:
                    rows.append((rel, i, m.start(), m.end(), m.group(0), 'bank not shown', ''))
                    continue
                obj = choose([o for o in objs if o.bank == 'W%d' % bank], addr)
                if obj is None:
                    rows.append((rel, i, m.start(), m.end(), m.group(0), 'no object', 'W%d $%04X' % (bank, addr)))
                elif obj.caveat:
                    rows.append((rel, i, m.start(), m.end(), m.group(0), 'caveat', obj.name))
                else:
                    rows.append((rel, i, m.start(), m.end(), m.group(0), 'apply', text_for(obj, addr)))
    return rows


def top_consumers(rows, outcome, n=12):
    counts = {}
    for r in rows:
        if r[3] == outcome:
            counts[r[4]] = counts.get(r[4], 0) + 1
    return sorted(counts.items(), key=lambda kv: (-kv[1], kv[0]))[:n]


def main(argv=None):
    ap = argparse.ArgumentParser(description='Write the raw RAM pointer operands as the names of their objects (see the module docstring).')
    ap.add_argument('--areas', default=None)
    ap.add_argument('--consumers', default=CONSUMERS)
    ap.add_argument('--calls', default=CALLS)
    ap.add_argument('--elements', default='')
    ap.add_argument('--neutral', action='store_true', help='write the neutral banked names (wRam_D000..wRam_DFFF) as the names of ram/banked.asm where the bank of the access is shown')
    ap.add_argument('--observed', action='store_true', help='with --elements or --neutral: also accept the replays (observed_banks.tsv) as proof of the bank; needs rgbasm (a marked copy is built)')
    ap.add_argument('--root', default=ROOT)
    ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--no-build', action='store_true')
    ap.add_argument('--no-symcheck', action='store_true')
    ap.add_argument('--report', metavar='FILE')
    ap.add_argument('--check', action='store_true')
    args = ap.parse_args(argv)
    containers = [c.strip() for c in args.elements.split(',') if c.strip()]
    areas = [a.strip() for a in (args.areas if args.areas is not None else ('' if (containers or args.neutral) else 'wram0')).split(',') if a.strip()]
    if (not areas and not containers and not args.neutral) or any(a not in AREAS for a in areas):
        print('apply_ram_operands: --areas takes %s' % ', '.join(AREAS), file=sys.stderr)
        return 2
    root = os.path.abspath(args.root)
    try:
        tree = ar.Tree.load(root)
    except OSError as e:
        print('apply_ram_operands: cannot read the tree: %s' % e, file=sys.stderr)
        return 2
    for a in areas + (['wramx'] if (containers or args.neutral) else []):
        if AREAS[a][0] not in tree.files:
            print('apply_ram_operands: %s has no %s' % (root, AREAS[a][0]), file=sys.stderr)
            return 2
    rules, effects = {}, {}
    if 'wramx' in areas or containers or args.neutral:
        try:
            if 'wramx' in areas:
                rules = read_rules(root, args.consumers)
            effects = read_calls(root, args.calls)
        except ValueError as e:
            print('apply_ram_operands: %s' % e, file=sys.stderr)
            return 2
    try:
        masks = None
        if (containers or args.neutral or 'wramx' in areas) and args.observed:
            wanted = set()
            for rel, text in tree.files.items():
                if rel.endswith('.asm') and rel.startswith(SOURCE_DIRS):
                    for i, line in enumerate(text):
                        code = split_code(line)[0] if line.startswith('\t') else ''
                        if code and (any(re.search(r'\b%s\b' % re.escape(c), code) for c in containers) or (args.neutral and NEUTRAL_WRAMX.search(code))
                                     or ('wramx' in areas and LD.match(line) and LD.match(line).group(2).startswith('D'))):
                            wanted.add((rel, i + 1))
                        m = LD.match(line) if 'wramx' in areas else None
                        if m and m.group(2).startswith('D'):                   # the instruction that consumes or dereferences the pointer: the bank in force there is the one that counts
                            reg = m.group(1).split()[-1].rstrip(',')
                            _, ci, _ = find_consumer_ex(text, i, reg)
                            if ci is None:
                                ci, _, _ = first_use_deref(text, i, reg, effects)
                            if ci is not None:
                                wanted.add((rel, ci + 1))
            masks = observed_masks(root, wanted)
        why = {}
        rows = plan(tree, areas, rules, effects, masks, why) if areas else []
        erows = plan_elements(tree, containers, masks, effects) if containers else []
        nrows = plan_neutral(tree, masks, effects) if args.neutral else []
    except (ValueError, RuntimeError) as e:
        print('apply_ram_operands: %s' % e, file=sys.stderr)
        return 2
    todo = [r for r in rows if r[3] == 'apply']
    etodo = [r for r in erows if r[5] == 'apply']
    ntodo = [r for r in nrows if r[5] == 'apply']
    counts = {}
    for r in rows:
        counts[r[3]] = counts.get(r[3], 0) + 1
    by_name = {}
    for r in todo:
        by_name[r[4].split(' + ')[0]] = by_name.get(r[4].split(' + ')[0], 0) + 1
    for r in etodo + ntodo:
        by_name[r[6].split(' + ')[0]] = by_name.get(r[6].split(' + ')[0], 0) + 1
    if args.report:
        with open(args.report, 'w', encoding='utf-8') as f:
            f.write('file\tline\toperand\toutcome\treplacement\tconsumer\tbank\n')
            for rel, i, v, outcome, text in rows:
                consumer, bank = why.get((rel, i), ('', 0))
                f.write('%s\t%d\t$%04X\t%s\t%s\t%s\t%s\n' % (rel, i + 1, v, outcome, text, consumer, 'W%d' % bank if bank else ''))
            for rel, i, s, e, old, outcome, text in erows + nrows:
                f.write('%s\t%d\t%s\t%s\t%s\t\t\n' % (rel, i + 1, old, outcome, text))
    purpose = counts.get('overlay base', 0) + counts.get('value', 0) + counts.get('marked raw', 0)
    pending = sum(counts.get(k, 0) for k in ('no rule', 'bank not shown', 'wrong family'))
    if args.check:
        for rel, i, v, outcome, text in rows:
            if outcome == 'apply':
                print('  raw  %s:%d  $%04X  -> %s' % (rel, i + 1, v, text))
        for rel, i, s, e, old, outcome, text in erows:
            if outcome == 'apply':
                print('  expr %s:%d  %s  -> %s' % (rel, i + 1, old, text))
        for rel, i, s, e, old, outcome, text in nrows:
            if outcome == 'apply':
                print('  neutral %s:%d  %s  -> %s' % (rel, i + 1, old, text))
        if areas:
            print('apply_ram_operands: --check: %d raw operand(s) with an object, %d left numeric on purpose (%d overlay base, %d value, %d marked raw), %d without an object'
                  % (len(todo), purpose, counts.get('overlay base', 0), counts.get('value', 0), counts.get('marked raw', 0), counts.get('no object', 0))
                  + ('; wramx: %d without a consumer rule or a shown bank, %d caveat, %d overrun' % (pending, counts.get('caveat', 0), counts.get('overrun', 0)) if 'wramx' in areas else ''))
        if containers:
            print('apply_ram_operands: --check: %d expression(s) of %s that an element name replaces, %d without an element, %d with the bank not shown, %d seen in another bank, %d complex, %d caveat'
                  % (len(etodo), ', '.join(containers), sum(1 for r in erows if r[5] == 'no element'), sum(1 for r in erows if r[5] == 'bank not shown'), sum(1 for r in erows if r[5] == 'other bank'),
                     sum(1 for r in erows if r[5] == 'complex'), sum(1 for r in erows if r[5] == 'caveat')))
        if args.neutral:
            print('apply_ram_operands: --check: %d use(s) of a neutral banked name that a banked name replaces, %d with the bank not shown, %d with the bank in doubt, %d without a name in the bank, %d complex, %d caveat'
                  % (len(ntodo), sum(1 for r in nrows if r[5] == 'bank not shown'), sum(1 for r in nrows if r[5] == 'other bank'), sum(1 for r in nrows if r[5] == 'no object'), sum(1 for r in nrows if r[5] == 'complex'),
                     sum(1 for r in nrows if r[5] == 'caveat')))
        return 1 if (todo or etodo or ntodo) else 0
    for rel, i, v, outcome, text in rows:
        if outcome == 'no object':
            print('  no object        %s:%d  $%04X' % (rel, i + 1, v))
    for rel, i, s, e, old, outcome, text in erows:
        if outcome in ('no element', 'other bank'):
            print('  %-16s %s:%d  %s' % (outcome, rel, i + 1, old))
    if areas:
        print('apply_ram_operands: summary: %d operand(s) in %d file(s) to rewrite with %d distinct name(s); left numeric: %d overlay base, %d value, %d marked raw; %d without an object'
              % (len(todo), len({r[0] for r in todo}), len({r[4].split(' + ')[0] for r in todo}), counts.get('overlay base', 0), counts.get('value', 0), counts.get('marked raw', 0), counts.get('no object', 0))
              + ('; wramx: %d no consumer rule, %d bank not shown, %d wrong family, %d caveat, %d overrun' % (counts.get('no rule', 0), counts.get('bank not shown', 0), counts.get('wrong family', 0), counts.get('caveat', 0), counts.get('overrun', 0)) if 'wramx' in areas else ''))
    if containers:
        print('apply_ram_operands: summary: %d expression(s) of %s in %d file(s) to rewrite; left as they are: %d bank not shown, %d seen in another bank, %d complex, %d without an element, %d caveat'
              % (len(etodo), ', '.join(containers), len({r[0] for r in etodo}), sum(1 for r in erows if r[5] == 'bank not shown'), sum(1 for r in erows if r[5] == 'other bank'),
                 sum(1 for r in erows if r[5] == 'complex'), sum(1 for r in erows if r[5] == 'no element'), sum(1 for r in erows if r[5] == 'caveat')))
    if args.neutral:
        print('apply_ram_operands: summary: %d use(s) of a neutral banked name in %d file(s) to rewrite; left as they are: %d bank not shown, %d bank in doubt, %d without a name in the bank, %d complex, %d caveat'
              % (len(ntodo), len({r[0] for r in ntodo}), sum(1 for r in nrows if r[5] == 'bank not shown'), sum(1 for r in nrows if r[5] == 'other bank'), sum(1 for r in nrows if r[5] == 'no object'), sum(1 for r in nrows if r[5] == 'complex'),
                 sum(1 for r in nrows if r[5] == 'caveat')))
    if args.dry_run:
        for name, n in sorted(by_name.items(), key=lambda kv: (-kv[1], kv[0]))[:16]:
            print('    %5d  %s' % (n, name))
        for outcome in ('no rule', 'bank not shown', 'wrong family', 'overrun'):
            if any(r[3] == outcome for r in rows):
                print('  %s, by consumer:' % outcome)
                for c, n in top_consumers(rows, outcome):
                    print('    %5d  %s' % (n, c))
        print('(dry run: nothing written, nothing built)')
        return 0
    if not todo and not etodo and not ntodo:
        return 0
    edits = {}
    apply_rows(tree, rows, edits)
    apply_elements(tree, erows, edits)
    apply_elements(tree, nrows, edits)
    new = {rel: '\n'.join(lines) for rel, lines in edits.items()}
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
