#!/usr/bin/env python3
"""Write the button masks that the code tests right after it reads a joypad variable as PADF_* / PADB_* names.

    python3 tools/apply_pad_masks.py [--dry-run] [--check] [--root DIR] [--report FILE]

The polling routine of bank 7D (7D:7B7C) stores the buttons in hJoyHeld, hJoyPressed and hJoyPressedRepeat as one bit per button, 1 = pressed: bit 0 A, bit 1 B, bit 2 Select, bit 3 Start,
bit 4 Right, bit 5 Left, bit 6 Up, bit 7 Down (home/jump_table.asm, the DEF lines of ram/hram.asm; the order inside each nibble is the hardware's, the two nibbles are put together by the ROM: rP1 buttons nibble in bits 3-0,
directions nibble in bits 7-4, inverted so that 1 = pressed; 7D:7B7C-7B9E, 7D:7BC1-7BED).
So where A still holds the variable, a mask is a set of buttons and says so:

	ldh a, [hJoyPressed]                       ldh a, [hJoyPressed]
	and a, $02                      ->         and a, PADF_B
	bit 4, a                        ->         bit PADB_RIGHT, a

The proof is local: after `ldh a, [hJoyHeld|hJoyPressed|hJoyPressedRepeat]` the scan goes forward over `bit N, a` tests, conditional jumps (`jr|jp cc`, `ret cc`) and `push af` (none of them writes A) and rewrites each
`bit N, a` (the bit number becomes `PADB_<button>`) and the first `and a, $NN` (the mask becomes the OR of the `PADF_<button>` flags of its bits; the scan ends there, because `and` writes A), and a `cp a, $NN` right after that `and` whose value lies inside the mask and that is followed by an equality branch (`jr|jp|call|ret z|nz`; a `cp` that feeds `jr c|nc` compares magnitudes, not buttons, and stays numeric)
(`and a, PADF_B | PADF_SELECT | PADF_RIGHT / cp a, PADF_B | PADF_SELECT | PADF_RIGHT`: the buttons that must all be down).  An `xor a, $NN` that is followed by an equality branch
is the exact-combination test (`xor a, PADF_SELECT | PADF_LEFT / jr nz`: zero only when exactly these buttons are down); it ends the scan like the `and`.  It stops at
a label (another path may join with a different A), a call, an unconditional jump, a return, a write of A, or any instruction it does not know.  `$F0` is written `PADF_DPAD` (the four directions), `$0F` `PADF_BUTTONS`
(A, B, Select, Start), `$FF` stays numeric.  `; raw` lines and lines with a trailing comment that starts with `; raw` are left alone.  The constants are defined in constants/hardware.inc.

Why the bytes cannot change: each name is the number it replaces (the tool checks the table against the numbers itself) and `make` compares the SHA-256, restoring the files when it differs.  Idempotent.
`--check` exits 1 when a test of this form is left numeric (a `bit PADB_x, a` that is already written does not stop the scan, so a half-written chain is completed).
"""
import argparse
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import apply_renames as ar  # noqa: E402

ROOT = os.path.dirname(HERE)
SOURCE_DIRS = ('engine/', 'home/', 'lib/')
BUTTONS = ('A', 'B', 'SELECT', 'START', 'RIGHT', 'LEFT', 'UP', 'DOWN')          # bit 0 .. bit 7
VARS = ('hJoyHeld', 'hJoyPressed', 'hJoyPressedRepeat')
LOAD = re.compile(r'^\tldh a, \[(%s)\]\s*(;.*)?$' % '|'.join(VARS))
BIT = re.compile(r'^(\tbit )([0-7])(, a)(\s*(?:;.*)?)$')
AND = re.compile(r'^(\tand a, )\$([0-9A-F]{2})(\s*(?:;.*)?)$')
AND_NAMED = re.compile(r'^\tand a, ((?:PADF_[A-Z]+)(?: \| PADF_[A-Z]+)*)\s*(?:;.*)?$')
CP = re.compile(r'^(\tcp a, )\$([0-9A-F]{2})(\s*(?:;.*)?)$')
XOR = re.compile(r'^(\txor a, )\$([0-9A-F]{2})(\s*(?:;.*)?)$')
BIT_NAMED = re.compile(r'^\tbit PADB_[A-Z]+, a\s*(?:;.*)?$')
EQ_BRANCH = re.compile(r'^\t(?:jr|jp|call|ret) (?:z|nz)\b')
COND = re.compile(r'^\t(?:jr|jp) (?:z|nz|c|nc),|^\tret (?:z|nz|c|nc)\b|^\tpush af\b')
SPECIAL = {0xF0: 'PADF_DPAD', 0x0F: 'PADF_BUTTONS'}


def name_value(expr):
    """The number of a PADF_ expression (the names the tool writes)."""
    total = 0
    for n in expr.split(' | '):
        total |= {'PADF_DPAD': 0xF0, 'PADF_BUTTONS': 0x0F}.get(n, 1 << BUTTONS.index(n[5:]) if n[5:] in BUTTONS else 0)
    return total


def mask_name(value):
    """The PADF_ expression of a mask, or None for $00 and $FF (not written)."""
    if value in (0x00, 0xFF):
        return None
    if value in SPECIAL:
        return SPECIAL[value]
    return ' | '.join('PADF_%s' % BUTTONS[b] for b in range(8) if value >> b & 1)


def feeds_equality_branch(lines, k):
    """True when the first instruction after lines[k] is a branch on Z (equal / not equal): only then is `cp a, buttons` a comparison of two sets of buttons."""
    k += 1
    while k < len(lines) and (not lines[k].strip() or lines[k].strip().startswith(';')):
        k += 1
    return k < len(lines) and bool(EQ_BRANCH.match(lines[k]))


def rewrite_site(lines, i):
    """[(line index, new text)] for the `bit` tests and the first `and` that follow the joypad load at lines[i]."""
    out = []
    j = i + 1
    while j < len(lines):
        s = lines[j]
        if not s.strip() or s.strip().startswith(';'):
            j += 1
            continue
        if not s.startswith('\t'):
            break                                           # a label: another path joins
        if '; raw' in s:
            break
        if BIT_NAMED.match(s):
            j += 1
            continue
        mb = BIT.match(s)
        if mb:
            out.append((j, mb.group(1) + 'PADB_%s' % BUTTONS[int(mb.group(2))] + mb.group(3) + mb.group(4)))
            j += 1
            continue
        ma = AND.match(s)
        mn = AND_NAMED.match(s)
        if ma or mn:
            mask = int(ma.group(2), 16) if ma else name_value(mn.group(1))
            name = mask_name(mask)
            if name:
                if ma:
                    out.append((j, ma.group(1) + name + ma.group(3)))
                k = j + 1
                while k < len(lines) and (not lines[k].strip() or lines[k].strip().startswith(';')):
                    k += 1
                mc = CP.match(lines[k]) if k < len(lines) else None
                if mc and '; raw' not in lines[k] and feeds_equality_branch(lines, k):
                    val = int(mc.group(2), 16)
                    cname = mask_name(val)
                    if cname and val & ~mask == 0:
                        out.append((k, mc.group(1) + cname + mc.group(3)))            # `and a, mask / cp a, buttons`: the buttons that must all be down
            break
        mx = XOR.match(s)
        if mx:
            name = mask_name(int(mx.group(2), 16))
            if name and feeds_equality_branch(lines, j):
                out.append((j, mx.group(1) + name + mx.group(3)))                 # `xor a, buttons / jr nz`: A is zero only when exactly these buttons are down
            break
        if COND.match(s):
            j += 1
            continue
        break
    return out


def rewrite(lines):
    """The new lines and the number of tests written."""
    new = list(lines)
    n = 0
    for i, l in enumerate(lines):
        if LOAD.match(l) and '; raw' not in l:
            for j, text in rewrite_site(lines, i):
                if new[j] != text:
                    new[j] = text
                    n += 1
    return new, n


def check_table():
    """The names stand for the numbers they replace: PADF_x = 1 << bit, the combined names are the ORs of their bits."""
    for b, name in enumerate(BUTTONS):
        assert mask_name(1 << b) == 'PADF_%s' % name
    assert mask_name(0xF0) == 'PADF_DPAD' and mask_name(0x0F) == 'PADF_BUTTONS'


def main(argv=None):
    ap = argparse.ArgumentParser(description='Write joypad masks as PADF_/PADB_ names (see the module docstring).')
    ap.add_argument('--root', default=ROOT)
    ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--check', action='store_true')
    ap.add_argument('--no-build', action='store_true')
    args = ap.parse_args(argv)
    check_table()
    root = os.path.abspath(args.root)
    try:
        tree = ar.Tree.load(root)
    except OSError as e:
        print('apply_pad_masks: %s' % e, file=sys.stderr)
        return 2
    changed, total = {}, 0
    for rel in sorted(tree.files):
        if not rel.endswith('.asm') or not rel.startswith(SOURCE_DIRS):
            continue
        new, n = rewrite(tree.files[rel])
        if n:
            changed[rel] = new
            total += n
    print('apply_pad_masks: %d test(s) written as names in %d file(s)' % (total, len(changed)))
    if args.check:
        return 1 if total else 0
    if args.dry_run or not total:
        return 0
    originals = {}
    for rel in changed:
        with open(os.path.join(root, rel), 'rb') as fh:
            originals[rel] = fh.read()
    for rel, lines in changed.items():
        with open(os.path.join(root, rel), 'w', encoding='utf-8', newline='') as fh:
            fh.write('\n'.join(lines))
    if args.no_build:
        return 0
    ok, msg = ar.verify_tree(root, True, 'mobile_trainer.gbc')
    if not ok:
        print('apply_pad_masks: VERIFICATION FAILED, restoring %d file(s):\n%s' % (len(changed), msg))
        for rel, data in originals.items():
            with open(os.path.join(root, rel), 'wb') as fh:
                fh.write(data)
        ar.verify_tree(root, False, 'mobile_trainer.gbc')
        return 1
    print('apply_pad_masks: verification: %s' % msg)
    return 0


if __name__ == '__main__':
    sys.exit(main())
