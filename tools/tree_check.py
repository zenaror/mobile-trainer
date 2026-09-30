#!/usr/bin/env python3
"""Tree-mode end-to-end check: layout -> generated tree -> rgbasm/rgblink with layout.link -> compare with the reference ROM.

    tree_check.py [--layout FILE] [--config DIR] [--rom FILE] [--tree DIR] [--header data|rgbfix] [--strict] [--keep DIR] [--no-onefile]

* without --tree the tree is generated (in memory) from ROM + config + layout;
  with --tree DIR an existing generated tree on disk (e.g. build/tree_src) is checked instead of a fresh one
  (and additionally compared with what the generator would write now: a stale tree is reported).
* the tree is assembled two ways -- every file as its own object (`rgbasm -P includes.asm`, what the Makefile does)
  and, unless --no-onefile, `main.asm` as one object -- and linked with its `layout.link` (`rgblink -p 0x00`);
  both ROMs must be byte-identical to the reference ROM and hash to the SHA-256 of roms.sha256.
* determinism: a second generation must give exactly the same files.
Exit status 0 only if everything holds.
"""
import argparse
import hashlib
import os
import shutil
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import gen_asm                                  # noqa: E402
import compare_rom                              # noqa: E402
from lib import mtcfg, layout as layoutlib      # noqa: E402
from lib.mtcfg import GenError, Diag            # noqa: E402

ROOT = mtcfg.ROOT


def read_tree(d):
    mp = os.path.join(d, gen_asm.MANIFEST)
    if not os.path.exists(mp):
        raise GenError('%s has no %s: not a tree written by gen_asm.py --tree' % (d, gen_asm.MANIFEST))
    files = {}
    for rel in open(mp, encoding='utf-8').read().split():
        with open(os.path.join(d, rel), encoding='utf-8') as fh:
            files[rel] = fh.read()
    with open(mp, encoding='utf-8') as fh:
        files[gen_asm.MANIFEST] = fh.read()
    return files


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('--layout', default=os.path.join(ROOT, 'analysis', 'layout', 'layout.tsv'))
    ap.add_argument('--config', default=os.path.join(ROOT, 'config'))
    ap.add_argument('--rom', default=os.path.join(ROOT, 'baserom.gbc'))
    ap.add_argument('--tree', help='check this generated tree on disk instead of generating one')
    ap.add_argument('--strict', action='store_true')
    ap.add_argument('--header', choices=('data', 'rgbfix'), help='cartridge header: bytes in the source (default) or written by rgbfix (with --tree: detected from the tree)')
    ap.add_argument('--keep', help='keep the temp build in this directory')
    ap.add_argument('--no-onefile', action='store_true', help='skip the one-object (main.asm) build')
    ap.add_argument('--xrefs', action='append', default=[])
    a = ap.parse_args(argv)
    if a.header is None:
        a.header = 'data'
        if a.tree and os.path.exists(os.path.join(a.tree, 'tree.mk')) and 'TREE_RGBFIX' in open(os.path.join(a.tree, 'tree.mk')).read():
            a.header = 'rgbfix'
    try:
        model, diag = gen_asm.load_model(a.rom, a.config, None, a.strict, a.xrefs, header=a.header)
        lay = layoutlib.load_layout(a.layout, model.nbanks, Diag(a.strict))
        fresh = model.generate_tree(lay)
    except GenError as e:
        print('error: %s' % e, file=sys.stderr)
        return 1
    ok = True
    files = fresh
    if a.tree:
        try:
            files = read_tree(a.tree)
        except (GenError, OSError) as e:
            print('error: %s' % e, file=sys.stderr)
            return 1
        stale = sorted(n for n in set(files) | set(fresh) if files.get(n) != fresh.get(n))
        if stale:
            print('FAIL  %s differs from the generator output for %d file(s), e.g. %s' % (a.tree, len(stale), ', '.join(stale[:5])))
            ok = False
        else:
            print('ok    %s is up to date (%d files)' % (a.tree, len(files)))
    model2, _ = gen_asm.load_model(a.rom, a.config, None, a.strict, a.xrefs, header=a.header)
    again = model2.generate_tree(layoutlib.load_layout(a.layout, model2.nbanks, Diag(a.strict)))
    if again != fresh:
        print('FAIL  generation is not deterministic')
        ok = False
    else:
        print('ok    deterministic: two generations give the same %d files' % len(fresh))
    with open(a.rom, 'rb') as fh:
        rom = fh.read()
    want = None      # roms.sha256 describes the real reference ROM only
    sha = os.path.join(ROOT, 'roms.sha256')
    if os.path.exists(sha) and os.path.abspath(a.rom) == os.path.join(ROOT, 'baserom.gbc'):
        want = open(sha).read().split()[0]
    tmp = a.keep or tempfile.mkdtemp(prefix='mttree_')
    try:
        for onefile in ((False,) if a.no_onefile else (False, True)):
            work = os.path.join(tmp, 'onefile' if onefile else 'files')
            os.makedirs(work, exist_ok=True)
            label = 'one object (main.asm)' if onefile else 'one object per file'
            try:
                built_path, log = gen_asm.assemble_tree(files, work, os.path.dirname(os.path.abspath(a.rom)), onefile=onefile)
            except GenError as e:
                print('FAIL  %s: %s' % (label, e))
                ok = False
                continue
            for line in log[:5]:
                print('warning: ' + line)
            with open(built_path, 'rb') as fh:
                built = fh.read()
            same = compare_rom.compare(rom, built, a.config, out=lambda *x, **k: None)
            h = hashlib.sha256(built).hexdigest()
            if want is not None and h != want:
                same = False
            print('%-5s %s: %d bytes, sha256 %s%s' % ('ok' if same else 'FAIL', label, len(built), h[:16] + '...',
                                                     '' if same else '  (differs from the reference ROM)'))
            ok = ok and same
    finally:
        if not a.keep:
            shutil.rmtree(tmp, ignore_errors=True)
    print('tree_check: %s (%d files, %d sections, layout %s)' % ('OK' if ok else 'FAILED', len(files), len(lay.sections), lay.source))
    return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(main())
