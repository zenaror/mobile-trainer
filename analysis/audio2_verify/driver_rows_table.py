#!/usr/bin/env python3
"""Per applied driver row of analysis/naming2/audio2_renames.tsv: address (from the neutral old name or build/mobile_trainer.sym), entry execution count and number of
scenarios in analysis/coverage_union.tsv, manifest status and the status this verifier assigns under the rule 'never executed in the 64 scenarios => at most PROBABLE'."""
import os, re, sys
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
cov = {}
for line in open(os.path.join(ROOT, 'analysis/coverage_union.tsv')):
    if line.startswith('#'): continue
    f = line.rstrip('\n').split('\t')
    if f[0] == '04': cov[int(f[1], 16)] = (int(f[2]), int(f[3]))
syms = {}
for line in open(os.path.join(ROOT, 'build/mobile_trainer.sym')):
    m = re.match(r'04:([0-9a-f]{4}) (\S+)$', line.strip())
    if m and '.' not in m.group(2): syms[m.group(2)] = int(m.group(1), 16)
rows = [l.rstrip('\n').split('\t') for l in open(os.path.join(ROOT, 'analysis/naming2/audio2_renames.tsv')) if not l.startswith('#') and l.strip()]
out = []; down = 0; kept = 0
for r in rows:
    old, new, kind, status = r[:4]
    if 'SoundSong' in new or status == 'HYPOTHESIS': continue
    a = syms.get(new) or syms.get(old)
    n, sc = cov.get(a, (0, 0))
    mine = status if (n > 0 or status != 'CONFIRMED') else 'PROBABLE'
    if mine != status: down += 1
    else: kept += 1
    out.append((a, new, kind, status, n, sc, mine))
print(f'{"addr":6s} {"name":36s} {"manifest":10s} {"entry x":>10s} {"scen":>4s}  verifier')
for a, new, kind, st, n, sc, mine in out:
    print(f'04:{a:04X} {new:36s} {st:10s} {n:10d} {sc:4d}  {mine}' + ('   <- lowered' if mine != st else ''))
print('applied driver rows:', len(out), ' status lowered:', down, ' unchanged:', kept)
