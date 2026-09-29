#!/usr/bin/env python3
"""Byte-exact comparison of the reference ROM and the rebuilt ROM.

usage: compare_rom.py REFERENCE BUILT [--max-runs N] [--config DIR]

Prints size/hash comparison, then differing byte runs grouped per bank and
mapped to the regions of config/regions/bankNN.tsv (gaps between regions are
reported as raw/gap).  Exit status 0 only when the two files are identical.

Importable: compare(ref_bytes, built_bytes, cfgdir=None, maxruns=40, out=print) -> bool
"""
import hashlib
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from lib import mtcfg  # noqa: E402

BANK_SIZE = 0x4000


def load_region_map(cfgdir, nbanks):
    """Gap-filled regions per bank, or {} (with a note) if the config cannot be read."""
    cfgdir = cfgdir or os.path.join(mtcfg.ROOT, 'config')
    diag = mtcfg.Diag()
    try:
        regs = mtcfg.load_regions(cfgdir, nbanks, diag)
        diag.raise_if_errors()
        return regs
    except mtcfg.GenError as e:
        print('note: region mapping unavailable (%s)' % str(e).splitlines()[0], file=sys.stderr)
        return {}


def describe(regmap, off):
    bank = off // BANK_SIZE
    addr = (off % BANK_SIZE) + (0 if bank == 0 else 0x4000)
    r = mtcfg.region_at(regmap.get(bank, []), addr)
    if r is None:
        return '-'
    tag = 'raw/gap' if r.gap else r.kind
    return '%s %s $%04X-$%04X' % (tag, r.label or '-', r.start, r.end)


def diff_runs(ref, built):
    n = min(len(ref), len(built))
    runs, i = [], 0
    while i < n:
        if ref[i] != built[i]:
            j = i
            while j < n and ref[j] != built[j]:
                j += 1
            runs.append((i, j))
            i = j
        else:
            i += 1
    return runs


def compare(ref, built, cfgdir=None, maxruns=40, out=print):
    out('reference: %d bytes sha256 %s' % (len(ref), hashlib.sha256(ref).hexdigest()))
    out('built    : %d bytes sha256 %s' % (len(built), hashlib.sha256(built).hexdigest()))
    if ref == built:
        out('RESULT: IDENTICAL')
        return True
    runs = diff_runs(ref, built)
    tot = sum(j - i for i, j in runs)
    out('RESULT: DIFFERENT  size_delta=%d  differing_bytes=%d  runs=%d' % (len(built) - len(ref), tot, len(runs)))
    regmap = load_region_map(cfgdir, max(1, len(ref) // BANK_SIZE))
    for i, j in runs[:maxruns]:
        out('  0x%06X-0x%06X (%d bytes) bank %02X @%04X  region %s' % (
            i, j, j - i, i // BANK_SIZE, (i % BANK_SIZE) + (0 if i < BANK_SIZE else 0x4000), describe(regmap, i)))
    if len(runs) > maxruns:
        out('  ... %d more runs' % (len(runs) - maxruns))
    return False


def main(argv):
    args, maxruns, cfgdir, i = [], 40, None, 0
    while i < len(argv):
        a = argv[i]
        if a == '--max-runs':
            maxruns = int(argv[i + 1])
            i += 2
        elif a == '--config':
            cfgdir = argv[i + 1]
            i += 2
        else:
            args.append(a)
            i += 1
    if len(args) != 2:
        print(__doc__)
        return 2
    with open(args[0], 'rb') as f1, open(args[1], 'rb') as f2:
        ref, built = f1.read(), f2.read()
    return 0 if compare(ref, built, cfgdir, maxruns) else 1


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
