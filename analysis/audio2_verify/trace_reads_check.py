#!/usr/bin/env python3
"""Cross-check of the independent decode with the EXISTING mGBA data-access traces (traces/detail/*/dataaccess.tsv, 64 scenarios; read-only, the traces are not part of
the private copy: pass the directory).  `rom_read bank start end_exclusive` = ROM bytes read as data.
Checks, for the two stream ranges 04:574D-7E8C and 05:4000-68C3:
  1. no byte of the 99 'tail' bytes behind the final jumps (the commands no path reaches) was ever read;
  2. every read byte lies in a decoded command or header (nothing outside);
  3. how much of the decoded command bytes the 64 scenarios actually read (which songs / effects were ever played).
Usage: trace_reads_check.py TRACES_DETAIL_DIR"""
import sys, os, glob, collections, io, contextlib
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
with contextlib.redirect_stdout(io.StringIO()):
    import decode_streams as D
    import coverage_check as C
d = sys.argv[1]
RANGES = {4: (0x574D, 0x7E8C), 5: (0x4000, 0x68C3)}
read = {b: bytearray(hi - lo) for b, (lo, hi) in RANGES.items()}
nsc = 0
for f in sorted(glob.glob(os.path.join(d, '*', 'dataaccess.tsv'))):
    nsc += 1
    for ln in open(f):
        if ln.startswith('#'): continue
        k, b, s, e = ln.rstrip('\n').split('\t')[:4]
        if k != 'rom_read': continue
        b = int(b, 16)
        if b not in RANGES: continue
        lo, hi = RANGES[b]
        s, e = int(s, 16), int(e, 16)
        for a in range(max(s, lo), min(e, hi)): read[b][a - lo] = 1
print('scenarios read:', nsc)
kind = {b: bytearray(hi - lo) for b, (lo, hi) in RANGES.items()}   # 0 gap(tail), 1 command, 2 header
allc = dict(C.o['_cmds']); allc.update(C.tail_cmds)
tailset = set(C.tail_cmds)
for (b, a), c in allc.items():
    for x in range(a, a + c.size): kind[b][x - RANGES[b][0]] = 3 if (b, a) in tailset else 1
for (b, h), hd in C.o['_headers'].items():
    for x in range(h, h + hd['size']): kind[b][x - RANGES[b][0]] = 2
tot = collections.Counter(); rd = collections.Counter()
for b, (lo, hi) in RANGES.items():
    for i in range(hi - lo):
        tot[kind[b][i]] += 1
        if read[b][i]: rd[kind[b][i]] += 1
names = {1: 'reachable command bytes', 2: 'header bytes', 3: 'bytes of the 93 unreachable (tail) commands'}
for k in (1, 2, 3): print(f'{names[k]:48s} {tot[k]:6d}  read in the 64 scenarios: {rd[k]:6d}')
print('bytes read outside every decoded command / header:', sum(1 for b in RANGES for i in range(RANGES[b][1] - RANGES[b][0]) if read[b][i] and kind[b][i] == 0))
# per header: was any byte of its tracks read?  -> which ids were ever played
played = {}
for (bank, h, k, st), in [((t[0], t[1], t[2], t[3]),) for t in C.o['_tracks']]:
    pass
ids_played = []
for n, r in D.records.items():
    bank, h = r['bank'], r['header']
    # the first command bytes of each track
    ok = any(read[bank][st - RANGES[bank][0]] for k in range(r['count']) for st in [D.rw(bank, h + 2 + 2 * k)])
    ids_played.append((n, ok))
print('ids whose track-0..n first byte was read at least once:', sum(1 for n, ok in ids_played if ok), 'of 70;  never read:', [f'{n:02X}' for n, ok in ids_played if not ok])
print('header words read (set 0) per header; extra sets (set 1/2) read?:', end=' ')
xr = 0; xt = 0
for (bank, h), hd in C.o['_headers'].items():
    if hd['extra'] == 2:
        lo = h + 2 + 2 * hd['count']; hi_ = h + hd['size']
        xt += hi_ - lo
        xr += sum(read[bank][x - RANGES[bank][0]] for x in range(lo, hi_))
print(f'{xr} of {xt} bytes of set 1 + set 2 were read as data in 64 scenarios')
