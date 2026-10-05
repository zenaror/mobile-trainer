#!/usr/bin/env python3
"""Execution coverage of every label of the sound driver (bank 04, 4000-5044), from analysis/coverage_union.tsv.

For each label in build/mobile_trainer.sym with bank 04 and address in [4000,5044): entry count / scenarios from the union
of the 64 mGBA scenarios, and executed instruction starts / all instruction starts in [label, next label).  Instruction starts
come from a linear decode with tools/sm83.py from the label (labels sit on instruction starts).  Data tables are skipped.
Usage: python3 analysis/audio2_verify/cov_labels.py [ROOT]
"""
import os, sys, re
ROOT = sys.argv[1] if len(sys.argv) > 1 else os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(ROOT, 'tools'))
import sm83
rom = open(os.path.join(ROOT, 'Mobile Trainer (Japan).gbc'), 'rb').read()
def off(bank, addr): return bank * 0x4000 + (addr - 0x4000)
cov = {}
for line in open(os.path.join(ROOT, 'analysis/coverage_union.tsv')):
    if line.startswith('#'): continue
    f = line.rstrip('\n').split('\t')
    if f[0] == '04':
        cov[int(f[1], 16)] = (int(f[2]), int(f[3]))
syms = {}
for line in open(os.path.join(ROOT, 'build/mobile_trainer.sym')):
    m = re.match(r'([0-9a-f]{2}):([0-9a-f]{4}) (\S+)$', line.strip())
    if m and m.group(1) == '04' and '.' not in m.group(3):
        a = int(m.group(2), 16)
        if 0x4000 <= a < 0x5044: syms.setdefault(a, []).append(m.group(3))
addrs = sorted(syms)
DATA = {0x449B: 0x44A3, 0x44A3: 0x44B1, 0x46E8: 0x473E}   # word tables, up to the next code (46E8-4726 commands, 4726-473E ext)
out = []
for i, a in enumerate(addrs):
    end = addrs[i + 1] if i + 1 < len(addrs) else 0x5044
    names = ' = '.join(sorted(syms[a], key=lambda s: (s.startswith(('Label_', 'Function_', 'Data_', 'Table_0')), s)))
    if any(n.startswith(('Table_', 'Data_04')) for n in syms[a]):
        out.append((a, names, None)); continue
    starts = []; p = a
    while p < end:
        ins = sm83.decode(rom, off(4, p), p)
        starts.append(p); p += ins.length
    ex = sum(1 for s in starts if s in cov)
    out.append((a, names, (len(starts), ex, cov.get(a, (0, 0)))))
for a, names, info in out:
    if info is None: print(f'{a:04X}  {names:60s} (data table)'); continue
    n, ex, (cnt, sc) = info
    print(f'{a:04X}  {names:60s} insns {n:4d}  executed {ex:4d}  entry x{cnt:<9d} scen {sc:2d}')
