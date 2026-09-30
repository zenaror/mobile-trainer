#!/usr/bin/env python3
"""Cross-check the labels of the source against the linker's symbol file.

    python3 tools/sym_check.py [--sym build/mobile_trainer.sym] [--fix] [--quiet]

The source tree (home/ engine/ data/ gfx/ audio/ lib/ consts.asm zero_labels.asm) defines every label as `Name::`,
followed by a `; BB:AAAA` comment that gives its bank and address when the file was written.  The ROM position of a
label is decided by layout.link and by the code before it, so after edits those comments can become stale.  This tool
reads build/mobile_trainer.sym (rgblink -n, written by `make`) and reports

  * labels defined in the source but missing from the .sym file, and .sym labels that no source file defines;
  * labels defined twice;
  * `Name:: ; BB:AAAA` comments that disagree with the linker's address (stale);
  * exported constants (consts.asm) missing from the .sym file.

Exit status 1 when any of the first four is found (stale comments count).  `--fix` rewrites stale comments in place
(only the `BB:AAAA` after a label; nothing else in a file is touched) and then exits 0 if nothing else is wrong.
The .sym file is authoritative: comments are for readers, they carry no meaning for the build.
"""
import argparse
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRCDIRS = ('home', 'engine', 'data', 'gfx', 'audio', 'lib')
EXTRA = ('consts.asm', 'zero_labels.asm')

LABEL = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)::(?P<rest>.*)$')
COMMENT_ADDR = re.compile(r'^(?P<pre>\s*;\s*)(?P<bank>[0-9A-Fa-f]{2}):(?P<addr>[0-9A-Fa-f]{4})(?P<post>\b.*)$')
EXPORT = re.compile(r'^EXPORT\s+([A-Za-z_][A-Za-z0-9_]*)\s*$')


def source_files():
    out = []
    for d in SRCDIRS:
        for dp, dn, fn in os.walk(os.path.join(ROOT, d)):
            dn.sort()
            out += [os.path.join(dp, f) for f in sorted(fn) if f.endswith('.asm')]
    out += [os.path.join(ROOT, f) for f in EXTRA if os.path.exists(os.path.join(ROOT, f))]
    return out


def read_sym(path):
    labels, consts = {}, {}
    with open(path, encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith(';'):
                continue
            addr, name = line.split(None, 1)
            if ':' in addr:
                bank, a = addr.split(':')
                labels.setdefault(name, (int(bank, 16), int(a, 16)))
            else:
                consts[name] = int(addr, 16)
    return labels, consts


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    ap.add_argument('--sym', default=os.path.join(ROOT, 'build', 'mobile_trainer.sym'))
    ap.add_argument('--fix', action='store_true', help='rewrite stale `; BB:AAAA` label comments in place')
    ap.add_argument('-q', '--quiet', action='store_true')
    args = ap.parse_args()
    if not os.path.exists(args.sym):
        print('missing %s (run `make` first)' % args.sym, file=sys.stderr)
        return 2
    sym, symconst = read_sym(args.sym)

    defs = {}          # name -> [(file, lineno)]
    stale = []         # (file, lineno, name, commented, actual)
    exports = []
    nfiles = 0
    edits = {}         # file -> {lineno: new line}
    for path in source_files():
        rel = os.path.relpath(path, ROOT)
        nfiles += 1
        with open(path, encoding='utf-8', newline='') as f:
            lines = f.read().split('\n')
        for i, line in enumerate(lines):
            m = EXPORT.match(line)
            if m:
                exports.append(m.group(1))
            m = LABEL.match(line)
            if not m:
                continue
            name = m.group(1)
            defs.setdefault(name, []).append((rel, i + 1))
            cm = re.match(r'^\s*(;.*)$', m.group('rest'))
            if cm and name in sym:
                am = COMMENT_ADDR.match(cm.group(1))
                if am and 'runs at' not in am.group('post'):    # LOAD blocks: comment = ROM address, label = run-time address
                    got = (int(am.group('bank'), 16), int(am.group('addr'), 16))
                    if got != sym[name]:
                        stale.append((rel, i + 1, name, '%02X:%04X' % got, '%02X:%04X' % sym[name]))
                        new = '%s:: ; %02X:%04X%s' % (name, sym[name][0], sym[name][1], am.group('post'))
                        edits.setdefault(path, {})[i] = new

    missing = sorted(n for n in defs if n not in sym)
    unowned = sorted(n for n in sym if n not in defs)
    dup = sorted(n for n, w in defs.items() if len(w) > 1)
    const_missing = sorted(n for n in exports if n not in symconst)

    fixed = 0
    if args.fix and edits:
        for path, ed in edits.items():
            with open(path, encoding='utf-8', newline='') as f:
                lines = f.read().split('\n')
            for i, new in ed.items():
                lines[i] = new
                fixed += 1
            with open(path, 'w', encoding='utf-8', newline='') as f:
                f.write('\n'.join(lines))
        stale = []

    def show(title, items, fmt=str, limit=20):
        if items:
            print('%s (%d):' % (title, len(items)))
            for it in items[:limit]:
                print('  ' + fmt(it))
            if len(items) > limit:
                print('  ... %d more' % (len(items) - limit))

    show('labels missing from %s' % os.path.relpath(args.sym, ROOT), missing)
    show('.sym labels defined by no source file', unowned)
    show('labels defined more than once', dup, lambda n: '%s: %s' % (n, ', '.join('%s:%d' % w for w in defs[n])))
    show('constants missing from the .sym file', const_missing)
    show('stale address comments', stale, lambda s: '%s:%d %s says %s, linker says %s' % s)
    bad = len(missing) + len(unowned) + len(dup) + len(const_missing) + len(stale)
    if not args.quiet or bad:
        print('sym_check: %d source files, %d labels defined, %d labels in .sym, %d constants exported (%d in .sym)%s'
              % (nfiles, len(defs), len(sym), len(exports), len(exports) - len(const_missing),
                 ', %d comments fixed' % fixed if args.fix else ''))
        print('sym_check: %s' % ('OK: every source label is in the .sym file at the address its comment gives' if not bad
                                 else 'FAILED (%d problem(s))' % bad))
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
