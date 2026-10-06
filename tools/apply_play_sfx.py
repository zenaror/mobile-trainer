#!/usr/bin/env python3
"""Write the eight-line sound wrapper of the user interface as the macro `play_sfx ID`.

    python3 tools/apply_play_sfx.py [--dry-run] [--check] [--root DIR] [--consts FILE]

The user interface plays its sound effects with one fixed idiom (367 of the 368 `call Sound_PlaySfx` sites; the other one, in the sound test, sets BC elsewhere):

	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $00NN
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a

It saves the WRAM bank, selects bank 1 (the sound driver runs only under it, invariant S1 of tools/invariants_check.py), plays effect NN and restores the bank.  The macro `play_sfx` of
constants/macros.inc expands to exactly these eight instructions; a site becomes `play_sfx SFX_NAME` (the constant of consts.asm for the id: `DEF SFX_NAME EQU $00NN`) or `play_sfx $00NN` when the id has
no constant, the file is a dead prototype (engine/unreferenced/: it follows an older table of ids) or the site is in code that no entry reaches (a [HYPOTHESIS] stub).
Only a site of exactly these eight lines, each without a comment and with nothing between them, is rewritten; a site with a comment, a label or another line inside stays as it is.

Why the bytes cannot change: the expansion is the same eight instructions; `make` compares the SHA-256 and the files are restored when it differs.  Idempotent.  `--check` exits 1 when a
site of the idiom is left.  The proof scans of tools/apply_ram_operands.py stop at a macro line (it is not a plain instruction), so they never cross it: they lose a proof, never invent one.
"""
import argparse
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import apply_renames as ar  # noqa: E402

ROOT = os.path.dirname(HERE)
CONSTS = 'consts.asm'
NUMERIC_DIRS = ('engine/unreferenced/',)          # dead prototypes that follow an older table of ids (page_list_prototype.asm plays $0031 on A): their ids stay numbers
SOURCE_DIRS = ('engine/', 'home/', 'lib/', 'audio/', 'data/')
IDIOM = (r'\tldh a, \[hWRAMBank\]', r'\tpush af', r'\tld a, \$01', r'\tldh \[rSVBK\], a', r'\tld bc, \$([0-9A-F]{4})', r'\tcall Sound_PlaySfx', r'\tpop af', r'\tldh \[rSVBK\], a')
IDIOM_RE = [re.compile('^' + p + '$') for p in IDIOM]
CONST_DEF = re.compile(r'^DEF (SFX_[A-Z0-9_]+) EQU \$([0-9A-Fa-f]{2,4})\s*(?:;.*)?$')


def read_constants(root, path):
    """{id: name} of the `DEF SFX_xxx EQU $nn` lines; a duplicated id or name raises ValueError (an empty dict when the file is absent)."""
    full = os.path.join(root, path)
    if not os.path.exists(full):
        return {}
    ids, names = {}, set()
    with open(full, encoding='utf-8') as fh:
        for n, line in enumerate(fh, 1):
            m = CONST_DEF.match(line.rstrip('\n'))
            if not m:
                continue
            i = int(m.group(2), 16)
            if i in ids or m.group(1) in names:
                raise ValueError('%s:%d: %s is defined twice (by id or by name)' % (path, n, m.group(1)))
            ids[i] = m.group(1)
            names.add(m.group(1))
    return ids


def find_sites(lines):
    """[(index of the first idiom line, id)]: every run of the eight lines exactly."""
    out = []
    for i in range(len(lines) - 7):
        m = IDIOM_RE[4].match(lines[i + 4])
        if m and all(IDIOM_RE[k].match(lines[i + k]) for k in range(8)):
            out.append((i, int(m.group(1), 16)))
    return out


def hypothesis_above(lines, i):
    """True when the comment block right above lines[i] says [HYPOTHESIS]: code with no found entry (a stub that nothing calls); a name there would be a claim about code that never runs."""
    k = i - 1
    while k >= 0 and (not lines[k].strip() or lines[k].strip().startswith(';')):
        if '[HYPOTHESIS]' in lines[k]:
            return True
        k -= 1
    return False


def rewrite(lines, consts, numeric=False):
    """The new lines and the number of sites written (the sites are replaced from the last to the first); `numeric` keeps every id a number (the files of NUMERIC_DIRS), and so does a site in a
    [HYPOTHESIS] stub."""
    sites = find_sites(lines)
    new = list(lines)
    for i, sid in reversed(sites):
        keep = numeric or hypothesis_above(lines, i)
        new[i:i + 8] = ['\tplay_sfx %s' % ('$%04X' % sid if keep else consts.get(sid, '$%04X' % sid))]
    return new, len(sites)


def main(argv=None):
    ap = argparse.ArgumentParser(description='Write the sound wrapper idiom as play_sfx (see the module docstring).')
    ap.add_argument('--root', default=ROOT)
    ap.add_argument('--consts', default=CONSTS)
    ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--check', action='store_true')
    ap.add_argument('--no-build', action='store_true')
    args = ap.parse_args(argv)
    root = os.path.abspath(args.root)
    try:
        consts = read_constants(root, args.consts)
        tree = ar.Tree.load(root)
    except (OSError, ValueError) as e:
        print('apply_play_sfx: %s' % e, file=sys.stderr)
        return 2
    changed, total, named = {}, 0, 0
    for rel in sorted(tree.files):
        if not rel.endswith('.asm') or not rel.startswith(SOURCE_DIRS):
            continue
        numeric = rel.startswith(NUMERIC_DIRS)
        new, n = rewrite(tree.files[rel], consts, numeric)
        if n:
            changed[rel] = new
            total += n
            named += 0 if numeric else sum(1 for i, sid in find_sites(tree.files[rel]) if sid in consts and not hypothesis_above(tree.files[rel], i))
    print('apply_play_sfx: %d site(s) of the idiom in %d file(s), %d with a named constant, %d as a number' % (total, len(changed), named, total - named))
    if args.check:
        return 1 if total else 0
    if args.dry_run or not total:
        return 0
    originals = {rel: open(os.path.join(root, rel), 'rb').read() for rel in changed}
    for rel, lines in changed.items():
        with open(os.path.join(root, rel), 'w', encoding='utf-8', newline='') as fh:
            fh.write('\n'.join(lines))
    if args.no_build:
        return 0
    ok, msg = ar.verify_tree(root, True, 'mobile_trainer.gbc')
    if not ok:
        print('apply_play_sfx: VERIFICATION FAILED, restoring %d file(s):\n%s' % (len(changed), msg))
        for rel, data in originals.items():
            with open(os.path.join(root, rel), 'wb') as fh:
                fh.write(data)
        ar.verify_tree(root, False, 'mobile_trainer.gbc')
        return 1
    print('apply_play_sfx: verification: %s' % msg)
    return 0


if __name__ == '__main__':
    sys.exit(main())
