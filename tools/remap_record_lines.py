#!/usr/bin/env python3
"""Update the `line` column of the records of analysis/naming2 after a pass that inserted or removed source lines.

    python3 tools/remap_record_lines.py OLD_REV [--records FILE ...] [--dry-run] [--root DIR]

The records `ramop9_manual.tsv`, `ramop10_manual.tsv`, `ramop10_respell.tsv` and `ramop10_respell_audio.tsv` name a place as (file, 1-based line).  A pass that collapses or inserts lines (the macro `play_sfx` replaced
eight lines by one at 367 sites) moves every line below it, and `tools/apply_manual_sites.py --dry-run` then reports the rows as skipped.  For every file named by a record this tool compares the file at git revision
OLD_REV with the working copy (difflib, line by line): a line that is unchanged moves to its new number, a line that was rewritten in place (same number of lines) keeps its position in the block; a line that was
deleted or lies in a block that changed its length has no new number and is reported (exit status 1, the row is left as it is).  Only the second column of a row is rewritten; every other byte of the file stays.
Run it once per pass, with the revision before the pass: a second run with the same revision would move the rows again (with OLD_REV equal to the current content nothing changes).
"""
import argparse
import difflib
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
RECORDS = ('analysis/naming2/ramop9_manual.tsv', 'analysis/naming2/ramop10_manual.tsv', 'analysis/naming2/ramop10_respell.tsv', 'analysis/naming2/ramop10_respell_audio.tsv')


def old_lines(root, rev, rel):
    out = subprocess.run(['git', '-C', root, 'show', '%s:%s' % (rev, rel)], capture_output=True)
    if out.returncode != 0:
        return None
    return out.stdout.decode('utf-8').split('\n')


def line_map(old, new):
    """{old 1-based line: new 1-based line} for the lines that survive (unchanged, or rewritten inside a block of the same length)."""
    mp = {}
    for tag, i1, i2, j1, j2 in difflib.SequenceMatcher(None, old, new, autojunk=False).get_opcodes():
        if tag == 'equal' or (tag == 'replace' and i2 - i1 == j2 - j1):
            for k in range(i2 - i1):
                mp[i1 + k + 1] = j1 + k + 1
    return mp


def main(argv=None):
    ap = argparse.ArgumentParser(description='Update the line column of the naming records after lines moved (see the module docstring).')
    ap.add_argument('old_rev')
    ap.add_argument('--records', nargs='*', default=list(RECORDS))
    ap.add_argument('--root', default=ROOT)
    ap.add_argument('--dry-run', action='store_true')
    args = ap.parse_args(argv)
    root = os.path.abspath(args.root)
    maps, lost, moved = {}, [], 0
    for rec in args.records:
        path = os.path.join(root, rec)
        with open(path, encoding='utf-8', newline='') as fh:
            text = fh.read()
        rows = text.split('\n')
        head = rows[0].split('\t')
        if 'file' not in head or 'line' not in head:
            print('remap_record_lines: %s has no file and line columns' % rec, file=sys.stderr)
            return 2
        fi, li = head.index('file'), head.index('line')
        for n in range(1, len(rows)):
            c = rows[n].split('\t')
            if len(c) <= max(fi, li) or not c[li].isdigit():
                continue
            f = c[fi]
            if f not in maps:
                old = old_lines(root, args.old_rev, f)
                with open(os.path.join(root, f), encoding='utf-8', newline='') as fh:
                    new = fh.read().split('\n')
                maps[f] = None if old is None else line_map(old, new)
            mp = maps[f]
            if mp is None:
                continue                                              # a file that did not exist at OLD_REV: nothing moved
            new_n = mp.get(int(c[li]))
            if new_n is None:
                lost.append((rec, f, c[li]))
            elif new_n != int(c[li]):
                c[li] = str(new_n)
                rows[n] = '\t'.join(c)
                moved += 1
        if not args.dry_run:
            with open(path, 'w', encoding='utf-8', newline='') as fh:
                fh.write('\n'.join(rows))
    for rec, f, line in lost:
        print('  lost  %s: %s:%s (the line was deleted or its block changed its length)' % (rec, f, line))
    print('remap_record_lines: %d row(s) %s, %d without a new line number' % (moved, 'would move' if args.dry_run else 'moved', len(lost)))
    return 1 if lost else 0


if __name__ == '__main__':
    sys.exit(main())
