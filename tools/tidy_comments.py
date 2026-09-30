#!/usr/bin/env python3
"""Turn the `; ---- code ...` region headers into pokecrystal-style comments under the function label.

    python3 tools/tidy_comments.py [--check] [--verbose]

The generator opened every block of code with a header line

    ; ---- code $04D8-$04EE (22 bytes) [CONFIRMED] fill BC bytes at HL with A (BC=0 fills 256 bytes when B=0) ...

followed by a blank line and the label.  This tool deletes that line (and the blank line after it) and puts its note,
wrapped to 100 columns, right under the first label of the block (after all alias labels, before the first instruction):

    FillBytes:: ; 00:04D8
    	; [CONFIRMED] fill BC bytes at HL with A (BC=0 fills 256 bytes when B=0); used to clear
    	; VRAM/WRAM/HRAM in Boot

* The comment starts with the evidence status tag of the block, `[CONFIRMED]`, `[PROBABLE]` or `[HYPOTHESIS]`, followed
  by the note text, unchanged (only wrapped).  Nothing of the note is dropped.
* Dropped: the word `code`/`ramcode`, `$start-$end` and `(n bytes)`.  The address of the label is in its `; BB:AAAA`
  comment and in build/mobile_trainer.sym, the size is the distance to the next block.
* A block that has no label (a fall-through piece cut out of a function) gets its comment directly above its first
  instruction, indented like the code.
* Headers of other kinds (`data`, `words`, `ptrtable`, `text`, `gfx`, `zero`) are not touched.

Idempotent; `--check` writes nothing and exits 1 when a file would change.  Assembly is unaffected (comments only).
"""
import argparse
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCOPE_DIRS = ('home', 'engine', 'lib', 'audio')
WIDTH = 100          # target width of a comment line, a tab counting 4 columns
TAB = 4

HEADER = re.compile(r'^; ---- (?:code|ramcode) \$[0-9A-Fa-f]{4}-\$[0-9A-Fa-f]{4} \(\d+ bytes\) '
                    r'\[(?P<status>CONFIRMED|PROBABLE|HYPOTHESIS)\](?: (?P<note>.*))?$')
LABEL = re.compile(r'^(?:[A-Za-z_][A-Za-z0-9_]*::?|\.[A-Za-z_][A-Za-z0-9_]*)(?:\s.*)?$')


def wrap(text, width):
    words = text.split(' ')
    lines, cur = [], ''
    for w in words:
        if cur and len(cur) + 1 + len(w) > width:
            lines.append(cur)
            cur = w
        else:
            cur = w if not cur else cur + ' ' + w
    if cur:
        lines.append(cur)
    return lines


def comment_lines(status, note):
    text = '[%s]' % status + (' ' + note.strip() if note and note.strip() else '')
    return ['\t; ' + l for l in wrap(text, WIDTH - TAB - 2)]


def tidy(lines):
    out = list(lines)
    i = 0
    done = skipped = 0
    while i < len(out):
        m = HEADER.match(out[i])
        if not m:
            i += 1
            continue
        # find the first instruction after the label group
        j = i + 1
        while j < len(out) and (out[j].strip() == '' or (LABEL.match(out[j]) and not out[j].startswith(';'))
                                or out[j].startswith('\tLOAD')):
            j += 1
        if j >= len(out) or not out[j].startswith('\t') or out[j].lstrip().startswith(';'):
            skipped += 1
            i += 1
            continue
        ins = comment_lines(m.group('status'), m.group('note'))
        out[j:j] = ins
        # drop the header and the blank line that follows it
        end = i + 1
        if end < len(out) and out[end].strip() == '':
            end += 1
        del out[i:end]
        done += 1
        # the insertion point moved up by (end - i); continue at the header's old position
    return out, done, skipped


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    ap.add_argument('--check', action='store_true', help='write nothing; exit 1 if a file would change')
    ap.add_argument('-v', '--verbose', action='store_true')
    ap.add_argument('--root', default=ROOT)
    args = ap.parse_args()
    changed = total = skipped = 0
    for d in SCOPE_DIRS:
        for dp, dn, fn in os.walk(os.path.join(args.root, d)):
            dn.sort()
            for f in sorted(fn):
                if not f.endswith('.asm'):
                    continue
                p = os.path.join(dp, f)
                with open(p, encoding='utf-8', newline='') as fh:
                    lines = fh.read().split('\n')
                new, n, s = tidy(lines)
                total += n
                skipped += s
                if new != lines:
                    changed += 1
                    if args.verbose or args.check:
                        print(('would change ' if args.check else 'changed ') + os.path.relpath(p, args.root))
                    if not args.check:
                        with open(p, 'w', encoding='utf-8', newline='') as fh:
                            fh.write('\n'.join(new))
                if s and args.verbose:
                    print('  %d header(s) left as they are in %s' % (s, os.path.relpath(p, args.root)))
    print('tidy_comments: %d code header(s) rewritten as label comments, %d left; %d file(s) %s'
          % (total, skipped, changed, 'would change' if args.check else 'changed'))
    return 1 if (args.check and changed) else 0


if __name__ == '__main__':
    sys.exit(main())
