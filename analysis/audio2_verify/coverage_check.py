#!/usr/bin/env python3
"""Tiling check with the independent decoder: reachable commands + headers + 'tails' vs the two stream ranges 04:574D-7E8C and 05:4000-68C3.
Prints the counts the doc claims (docs/research/audio_format.md section 1, 4.4, 9) as recomputed here."""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import decode_streams as D

o = D.main()
import builtins
_print = builtins.print
if os.environ.get('A2V_QUIET'):
    print = lambda *a, **k: None
cmds, headers, tracks = o['_cmds'], o['_headers'], o['_tracks']
RANGES = {4: (0x574D, 0x7E8C), 5: (0x4000, 0x68C3)}

# 1. header spans (size = 2 + 2*count*(1+extra) with extra = byte 1)
print('\n== headers')
print('byte0 == count for all headers:', all(h['byte0'] == h['count'] for h in headers.values()))
print('extra values:', collections.Counter(h['extra'] for h in headers.values()))
print('header size histogram:', collections.Counter(h['size'] for h in headers.values()))
cov = {b: bytearray(r[1] - r[0]) for b, r in RANGES.items()}      # 0 = free, 1 = command, 2 = header
def mark(bank, a, n, val):
    lo, hi = RANGES[bank]
    for x in range(a, a + n):
        if not (lo <= x < hi): print('  outside range', bank, hex(x)); continue
        if cov[bank][x - lo]: print('  OVERLAP at', bank, hex(x)); 
        cov[bank][x - lo] = val
for (bank, a), c in cmds.items(): mark(bank, a, c.size, 1)
for (bank, h), hd in headers.items(): mark(bank, h, hd['size'], 2)
# 2. gaps
print('\n== gaps after subtracting reachable commands and headers')
gaps = []
for bank, (lo, hi) in RANGES.items():
    i = 0; buf = cov[bank]
    while i < len(buf):
        if buf[i] == 0:
            j = i
            while j < len(buf) and buf[j] == 0: j += 1
            gaps.append((bank, lo + i, lo + j)); i = j
        else: i += 1
print('gaps:', len(gaps), ' total bytes:', sum(g[2] - g[1] for g in gaps))
print('gap length histogram:', sorted(collections.Counter(g[2] - g[1] for g in gaps).items()))
# 3. tails: decode every gap linearly (rs = 0 at the start) and see whether it ends exactly at the gap end
tail_cmds = {}
bad = []
for bank, a, e in gaps:
    p = a; rs = 0
    while p < e:
        try:
            cmd, rs2, succ = D.decode(bank, p, rs)
        except Exception as ex:
            bad.append((bank, p, str(ex))); break
        if cmd.kind == 'badrs': bad.append((bank, p, 'badrs')); break
        tail_cmds[(bank, p)] = cmd; p += cmd.size; rs = rs2
    if p != e: bad.append((bank, a, f'gap decode ends at {p:04X} not {e:04X}'))
print('tail commands decoded linearly:', len(tail_cmds), ' kinds:', collections.Counter(c.kind for c in tail_cmds.values()), ' problems:', bad[:5])
print('total commands (reachable + tails):', len(cmds) + len(tail_cmds), ' bytes:', sum(c.size for c in cmds.values()) + sum(c.size for c in tail_cmds.values()))
print('headers bytes:', sum(h['size'] for h in headers.values()), ' command bytes (reachable):', sum(c.size for c in cmds.values()))
tot = sum(hi - lo for lo, hi in RANGES.values())
print('range bytes:', tot, ' covered by commands+headers+tails =', sum(c.size for c in cmds.values()) + sum(c.size for c in tail_cmds.values()) + sum(h['size'] for h in headers.values()))
print('commands only (reachable+tails) bytes (the doc says 19716):', sum(c.size for c in cmds.values()) + sum(c.size for c in tail_cmds.values()))

# 4. the extra pointer sets
print('\n== extra pointer sets (doc section 3.2)')
ok_loop = ok_after = n_tr = 0; plus4 = 0; tails_kinds = collections.Counter(); problems = []
for (bank, h), hd in headers.items():
    if hd['extra'] != 2: continue
    cnt = hd['count']
    for k in range(cnt):
        n_tr += 1
        start = D.rw(bank, h + 2 + 2 * k)
        loop = D.rw(bank, h + 2 + 2 * cnt + 2 * k)
        after = D.rw(bank, h + 2 + 4 * cnt + 2 * k)
        # find the final jump of this track: the jump command whose address+size == after (the command right before `after`)
        # candidates: reachable commands of kind jump in the track
        d = o['_per_track'][(bank, h, k)]
        fj = [ (a, list(v.values())[0]) for a, v in d.items() if list(v.values())[0].kind == 'jump' and a + list(v.values())[0].size == after]
        if len(fj) == 1 and fj[0][1].args[0] == loop: ok_loop += 1; ok_after += 1
        else: problems.append((bank, h, k, hex(start), hex(loop), hex(after), [(hex(a), c.kind, [hex(x) for x in c.args]) for a, c in fj]))
        if loop == start + 4: plus4 += 1
print('tracks in the 22 headers with extra sets:', n_tr, ' (final jump found right before set-2 address and its target == set-1):', ok_loop, ' problems:', len(problems))
for p in problems[:8]: print('  ', p)
print('loop point == start + 4 in', plus4, 'of', n_tr)
for (bank, a), c in sorted(tail_cmds.items()): tails_kinds[(c.kind, c.op)] += 1
print('tail command kinds:', dict(tails_kinds))
