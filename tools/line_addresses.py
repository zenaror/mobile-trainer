#!/usr/bin/env python3
"""Where in the ROM does a line of the source end up?  Maps `file:line` of the hand-maintained source to `bank:address` (read-only for the repository).

    python3 tools/line_addresses.py [--root DIR] [--out FILE] file.asm:LINE [file.asm:LINE ...]
    python3 tools/line_addresses.py --sites FILE [--out FILE]      # FILE: TSV whose first two columns are file and line (extra columns are copied; `#` lines skipped)

How: a copy of the tree gets a local label `.__mNNN` in front of every wanted line (a local label adds no byte and does not change the scope of the labels around it), is built with
`make`, and the addresses are read from the `.sym` file (`BB:AAAA Parent.__mNNN`).  The ROM must come out identical (SHA-256 of roms.sha256), which proves that the markers moved nothing; the
repository itself is never modified.  Output (stdout or --out): `file<TAB>line<TAB>bank<TAB>address` plus the copied columns.  A line that is not an instruction or data line (a label, a comment, a
blank) is reported with an empty address.

The result feeds the evidence tables that are keyed by address: analysis/rambank/observed_banks.tsv (which WRAM bank was selected when an instruction ran, `observed_wram_mask()`),
analysis/coverage_union.tsv (was it executed) and the ROM bytes themselves.
"""
import argparse
import os
import re
import shutil
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import apply_renames as ar  # noqa: E402

ROOT = os.path.dirname(HERE)
SOURCE_DIRS = ('home', 'engine', 'lib', 'data', 'audio', 'gfx')
SKIP = ('.git', 'build', '__pycache__', 'traces', 'analysis', 'docs', 'config', 'tools', 'ghidra')
SYM = re.compile(r'^([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4})\s+(\S+)\.__m(\d+)\s*$')


def copy_tree(root, dst):
    for name in sorted(os.listdir(root)):
        if name in SKIP or name.startswith('.'):
            continue
        src = os.path.join(root, name)
        if os.path.isdir(src):
            shutil.copytree(src, os.path.join(dst, name), ignore=shutil.ignore_patterns('__pycache__', 'build'))
        elif not name.endswith(('.gbc', '.gb', '.sym', '.map')):
            shutil.copy2(src, os.path.join(dst, name))
    os.makedirs(os.path.join(dst, 'tools'), exist_ok=True)
    for name in ('sym_check.py', 'font_png.py', 'pnglib.py'):
        if os.path.exists(os.path.join(root, 'tools', name)):
            shutil.copy2(os.path.join(root, 'tools', name), os.path.join(dst, 'tools', name))


def addresses(root, sites):
    """{(file, line): (bank, addr) or None} for sites = [(file, line)]; builds in a temp copy (raises RuntimeError when the build or the SHA-256 check fails)."""
    tmp = tempfile.mkdtemp(prefix='lineaddr_')
    try:
        copy_tree(root, tmp)
        by_file = {}
        for k, (f, ln) in enumerate(sites):
            by_file.setdefault(f, []).append((ln, k))
        for f, items in by_file.items():
            p = os.path.join(tmp, f)
            with open(p, encoding='utf-8', newline='') as fh:
                lines = fh.read().split('\n')
            for ln, k in sorted(items, reverse=True):
                if not (1 <= ln <= len(lines)):
                    raise RuntimeError('%s has no line %d' % (f, ln))
                text = lines[ln - 1]
                if text.startswith('\t') and text.strip() and not text.strip().startswith(';'):
                    lines.insert(ln - 1, '.__m%d' % k)             # in front of an instruction or a data line
            with open(p, 'w', encoding='utf-8', newline='') as fh:
                fh.write('\n'.join(lines))
        ok, msg = ar.verify_tree(tmp, False, 'mobile_trainer.gbc')
        if not ok:
            raise RuntimeError('the marked copy does not build to the original ROM: %s' % msg)
        out = {}
        with open(os.path.join(tmp, 'build', 'mobile_trainer.sym'), encoding='utf-8') as fh:
            for line in fh:
                m = SYM.match(line.strip())
                if m:
                    k = int(m.group(4))
                    out[sites[k]] = (m.group(1).upper(), m.group(2).upper())
        return {s: out.get(s) for s in sites}
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


def observed_wram_mask(root, bank, addr):
    """The wram_mask (int, bit n = WRAM bank n selected when the instruction started) of analysis/rambank/observed_banks.tsv for an instruction, or None when it never ran in the replays."""
    table = observed_table(root)
    row = table.get((bank.upper(), addr.upper()))
    return None if row is None else row[0]


_OBS = {}


def observed_table(root):
    if root not in _OBS:
        t = {}
        with open(os.path.join(root, 'analysis', 'rambank', 'observed_banks.tsv'), encoding='utf-8') as fh:
            for line in fh:
                if line.startswith('#') or not line.strip():
                    continue
                c = line.rstrip('\n').split('\t')
                t[(c[0].upper(), c[1].upper())] = (int(c[2], 16), int(c[6]))
        _OBS[root] = t
    return _OBS[root]


def main(argv=None):
    ap = argparse.ArgumentParser(description='Map source lines to ROM addresses (see the module docstring).')
    ap.add_argument('sites', nargs='*', help='file.asm:LINE')
    ap.add_argument('--sites', dest='sites_file', metavar='FILE')
    ap.add_argument('--root', default=ROOT)
    ap.add_argument('--out', metavar='FILE')
    args = ap.parse_args(argv)
    root = os.path.abspath(args.root)
    sites, extra = [], {}
    for s in args.sites:
        f, _, ln = s.rpartition(':')
        sites.append((f, int(ln)))
    if args.sites_file:
        with open(args.sites_file, encoding='utf-8') as fh:
            for line in fh:
                if line.startswith('#') or not line.strip():
                    continue
                c = line.rstrip('\n').split('\t')
                key = (c[0], int(c[1]))
                if key not in extra:
                    sites.append(key)
                extra[key] = c[2:]
    if not sites:
        ap.print_usage(sys.stderr)
        return 2
    try:
        res = addresses(root, list(dict.fromkeys(sites)))
    except RuntimeError as e:
        print('line_addresses: %s' % e, file=sys.stderr)
        return 1
    out = open(args.out, 'w', encoding='utf-8') if args.out else sys.stdout
    for key in dict.fromkeys(sites):
        r = res[key]
        out.write('\t'.join([key[0], str(key[1]), r[0] if r else '', r[1] if r else ''] + extra.get(key, [])) + '\n')
    if args.out:
        out.close()
    return 0


if __name__ == '__main__':
    sys.exit(main())
