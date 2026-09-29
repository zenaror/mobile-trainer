#!/usr/bin/env python3
"""Byte-exact comparison of the reference ROM and the rebuilt ROM.

usage: compare_rom.py REFERENCE BUILT [--max-runs N]

Prints size/hash comparison, then differing byte runs grouped per bank, mapped
to config/regions.tsv when that file exists.  Exit status 0 only when the two
files are identical.
"""
import hashlib, os, sys

def load_regions(path):
    regs = []
    if not os.path.exists(path):
        return regs
    for line in open(path):
        if line.startswith('#') or not line.strip():
            continue
        f = line.rstrip('\n').split('\t')
        if len(f) < 5 or f[0] == 'bank':
            continue
        regs.append((int(f[0], 16), int(f[1], 16), int(f[2], 16), f[3], f[4]))
    return regs

def region_of(regs, off):
    bank, addr = (off >> 14), (off & 0x3FFF) + (0 if off < 0x4000 else 0x4000)
    for b, s, e, k, n in regs:
        if b == bank and s <= addr < e:
            return '%s/%s' % (k, n)
    return '-'

def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    maxruns = 40
    if '--max-runs' in sys.argv:
        maxruns = int(sys.argv[sys.argv.index('--max-runs') + 1])
        args = [a for a in args if a != str(maxruns)]
    ref, built = open(args[0], 'rb').read(), open(args[1], 'rb').read()
    print('reference: %d bytes sha256 %s' % (len(ref), hashlib.sha256(ref).hexdigest()))
    print('built    : %d bytes sha256 %s' % (len(built), hashlib.sha256(built).hexdigest()))
    if ref == built:
        print('RESULT: IDENTICAL')
        return 0
    n = min(len(ref), len(built))
    runs, i = [], 0
    while i < n:
        if ref[i] != built[i]:
            j = i
            while j < n and ref[j] != built[j]:
                j += 1
            runs.append((i, j)); i = j
        else:
            i += 1
    tot = sum(j - i for i, j in runs)
    print('RESULT: DIFFERENT  size_delta=%d  differing_bytes=%d  runs=%d' % (len(built) - len(ref), tot, len(runs)))
    regs = load_regions(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'config', 'regions.tsv'))
    for i, j in runs[:maxruns]:
        print('  0x%06X-0x%06X (%d bytes) bank %02X @%04X  region %s' % (
            i, j, j - i, i >> 14, (i & 0x3FFF) + (0 if i < 0x4000 else 0x4000), region_of(regs, i)))
    if len(runs) > maxruns:
        print('  ... %d more runs' % (len(runs) - maxruns))
    return 1

sys.exit(main())
