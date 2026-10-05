#!/usr/bin/env python3
"""List instruction starts of a bank-04 address range that no scenario of analysis/coverage_union.tsv executed.  Usage: unexec.py START END (hex)"""
import sys, os
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(ROOT, 'tools'))
import sm83
rom = open(os.path.join(ROOT, 'Mobile Trainer (Japan).gbc'), 'rb').read()
cov = {}
for line in open(os.path.join(ROOT, 'analysis/coverage_union.tsv')):
    if line.startswith('#'): continue
    f = line.rstrip('\n').split('\t')
    if f[0] == '04': cov[int(f[1], 16)] = int(f[2])
a0, a1 = int(sys.argv[1], 16), int(sys.argv[2], 16)
# decode from the covered addresses / labels is not available here: linear decode from a0 (a0 must be an instruction start)
p = a0
while p < a1:
    ins = sm83.decode(rom, 4 * 0x4000 + p - 0x4000, p)
    mark = f'x{cov[p]}' if p in cov else 'NEVER'
    print(f'{p:04X}  {ins.raw.hex():8s} {ins.text():24s} {mark}')
    p += ins.length
