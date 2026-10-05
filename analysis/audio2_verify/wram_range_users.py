#!/usr/bin/env python3
"""Who addresses the sound driver's WRAM range $D040-$D27F outside audio/?  For each code line with such an operand, find the nearest preceding `ld a, $0N` that is
followed within 2 lines by `ldh [rSVBK], a` or `ldh [hWRAMBank], a` (look back 80 lines, same file) and report N.  A hit with N = 1 would be a candidate reader/writer of
the driver state; 'none' means the bank selection is made elsewhere (caller / earlier in the screen)."""
import os, re, sys, collections
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RANGE = re.compile(r'\$(D0[4-9A-F][0-9A-F]|D1[0-9A-F]{2}|D2[0-7][0-9A-F])\b')
res = collections.Counter(); ones = []
for top in ('engine', 'home', 'lib', 'data'):
    for d, _, fs in os.walk(os.path.join(ROOT, top)):
        for f in fs:
            if not f.endswith('.asm'): continue
            p = os.path.join(d, f)
            L = open(p, encoding='utf-8', errors='replace').read().split('\n')
            for i, ln in enumerate(L):
                code = ln.split(';')[0]
                if not RANGE.search(code): continue
                if re.match(r'\s*(db|dw)\b', code): continue
                n = None
                for j in range(i - 1, max(i - 80, -1), -1):
                    cj = L[j].split(';')[0].strip()
                    m = re.match(r'ld a, \$0([0-9])$', cj)
                    if m:
                        nxt = ' '.join(x.split(';')[0].strip() for x in L[j + 1:j + 3])
                        if 'rSVBK' in nxt or 'hWRAMBank' in nxt: n = int(m.group(1)); break
                key = 'none' if n is None else str(n)
                res[key] += 1
                if n == 1 or n == 0: ones.append((os.path.relpath(p, ROOT), i + 1, code.strip()))
print('operand sites in $D040-$D27F outside audio/:', sum(res.values()), dict(res))
print('sites with a preceding SVBK select of bank 0/1:', ones[:20])
