#!/usr/bin/env python3
"""V2.4: recompute the sound tables from the ROM (own code): durations 04:5044, note frequencies 04:5075, instruments 04:51DD, wave patterns 04:547D."""
import sys, os, math, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import decode_streams as D
rb = lambda a: D.rb(4, a)

print('== durations 04:5044 (49 bytes)')
dur = [rb(0x5044 + i) for i in range(49)]
print(' '.join(f'{x:02X}' for x in dur))
exp = list(range(0, 25)) + [28, 30, 32, 36, 40, 42, 44, 48, 52, 54, 56, 60, 64, 66, 68, 72, 76, 78, 80, 84, 88, 90, 92, 96]
print('equals the doc list (00..18 step 1, then 1C 1E 20 24 28 2A 2C 30 34 36 38 3C 40 42 44 48 4C 4E 50 54 58 5A 5C 60):', dur == exp, ' entries', len(dur), ' strictly increasing:', all(a < b for a, b in zip(dur, dur[1:])))
print('wait opcodes: $80+idx for idx 0..48 -> up to', hex(0x80 + 48), '(= $B0); notes: $CF+idx for idx 1..48 -> $D0..$FF ->', hex(0xCF + 1), hex(0xCF + 48))

print('\n== note frequency table 04:5075 (120 x 3 bytes)')
recs = []
for i in range(120):
    a = 0x5075 + 3 * i
    recs.append((rb(a) | (rb(a + 1) << 8), rb(a + 2)))
print('end address', hex(0x5075 + 360), '(= start of the instrument table 04:51DD ->', 0x5075 + 360 == 0x51DD, ')')
print('periods < 2048 for all:', all(p < 2048 for p, s in recs), ' first/last record:', recs[0], recs[-1])
maxerr = 0; worst = None; errs = collections.Counter()
for i, (p, s) in enumerate(recs):
    m = 36 + i                              # MIDI note, claim: $24 + index
    f = 440.0 * 2 ** ((m - 69) / 12)
    exact = 2048 - 131072 / f
    e = p - exact
    errs[round(e)] += 1
    if abs(e) > abs(maxerr): maxerr, worst = e, i
print('max |period - (2048 - 131072/f)| =', round(abs(maxerr), 3), 'at record', worst, '(claim: within 1) ; rounded error histogram', dict(errs))
print('record 0 frequency from the register value', recs[0][0], ':', round(131072 / (2048 - recs[0][0]), 3), 'Hz (C2 = 65.406 Hz);  record 24 (C4 = MIDI 60) :', round(131072 / (2048 - recs[24][0]), 3), 'Hz (C4 = 261.626 Hz); record 33 (A4 = MIDI 69):', round(131072 / (2048 - recs[33][0]), 3), 'Hz')
# is the MIDI offset determined uniquely? try other offsets, count records within 1
best = []
for off in range(24, 49):
    ok = 0; mx = 0
    for i, (p, s) in enumerate(recs):
        f = 440.0 * 2 ** ((off + i - 69) / 12); e = abs(p - (2048 - 131072 / f)); mx = max(mx, e); ok += e <= 1
    best.append((ok, off, round(mx, 2)))
print('records within 1 of the equal-tempered period, by assumed MIDI number of record 0 (top 3):', sorted(best, reverse=True)[:3])
print('also with A4 = 440 vs other tunings: record 33 should be 440 Hz ->', round(131072 / (2048 - recs[33][0]), 2))
# step claim: step = next period - this period (within 1)
dst = [(recs[i + 1][0] - recs[i][0]) - recs[i][1] for i in range(119)]
print('step - (next period - period) histogram over records 0..118:', dict(collections.Counter(dst)), ' last record step byte:', recs[119][1], ' record 119 period', recs[119][0], '(saturated 2046?)')
print('periods strictly increasing:', all(recs[i][0] < recs[i + 1][0] for i in range(119)), ' max step', max(s for p, s in recs))
print('2048-131072/f for record 119 (MIDI 155) =', round(2048 - 131072 / (440 * 2 ** ((155 - 69) / 12)), 3))

print('\n== wave patterns 04:547D (10 x 16 bytes)')
pats = []
for k in range(10):
    b = [rb(0x547D + 16 * k + i) for i in range(16)]
    s = []
    for x in b: s += [x >> 4, x & 15]        # high nibble first
    pats.append(s)
    print(k, ''.join(f'{v:X}' for v in s), ' bytes', bytes(b).hex())
def shape(s):
    hi = sum(1 for v in s if v >= 8)
    peak = max(s); lo = min(s)
    # runs
    ups = sum(1 for a, b in zip(s, s[1:]) if b > a); downs = sum(1 for a, b in zip(s, s[1:]) if b < a)
    distinct = len(set(s))
    return f'min {lo} max {peak} distinct {distinct} high(>=8) {hi} ups {ups} downs {downs} first {s[0]} last {s[-1]}'
for k, s in enumerate(pats): print(k, shape(s))
print('pulse-like (only two distinct levels):', [k for k, s in enumerate(pats) if len(set(s)) <= 2], ' high-sample counts for those:', [sum(1 for v in pats[k] if v == max(pats[k])) for k in range(10) if len(set(pats[k])) <= 2])
print('NR32/volume irrelevant here.')

print('\n== instrument table 04:51DD (112 x 6 bytes)')
ins = []
for i in range(112):
    a = 0x51DD + 6 * i
    ins.append([rb(a + j) for j in range(6)])
print('end', hex(0x51DD + 672), '= start of wave patterns 04:547D ->', 0x51DD + 672 == 0x547D)
cls = collections.Counter(); waves = collections.Counter()
for i, r in enumerate(ins):
    b0 = r[0]
    c = 'pulse1' if b0 < 0x08 else 'pulse2' if b0 < 0x10 else 'wave' if b0 < 0x40 else 'noise'
    cls[c] += 1
    if c == 'wave': waves[b0 - 0x10] += 1
print('class distribution:', dict(cls), ' wave patterns used by records (index: count):', dict(sorted(waves.items())))
print('byte1 values:', collections.Counter(r[1] for r in ins), ' byte2 values:', collections.Counter(r[2] for r in ins))
print('byte0 values by class:', {c: sorted({r[0] for r in ins if (('pulse1' if r[0] < 8 else 'pulse2' if r[0] < 16 else 'wave' if r[0] < 0x40 else 'noise') == c)}) for c in cls})
print('byte5 in records 0..99:', collections.Counter(r[5] for r in ins[:100]), ' records 100..111 (drums):', [f'{r[5]:02X}' for r in ins[100:]])
print('records 100-111 classes:', [r[0] for r in ins[100:]])
print('byte3 bit4 / bit0 set count; byte4 bit0 set count:', sum(1 for r in ins if r[3] & 0x10), sum(1 for r in ins if r[3] & 1), sum(1 for r in ins if r[4] & 1))
print('byte3 distinct', len({r[3] for r in ins}), ' byte4 distinct', len({r[4] for r in ins}))
# sample of record decodes for the doc's envelope claims
def env(r):
    a, s = r[3], r[4]
    return dict(attack=(~(a >> 5)) & 7, decay=(~(a >> 1)) & 7, sustain=s >> 4, release=(~(s >> 1)) & 7)
print('first 6 records:', [(i, [f'{x:02X}' for x in r], env(r)) for i, r in enumerate(ins[:6])])
print('records with attack != 0:', [(i, env(r)['attack']) for i, r in enumerate(ins) if env(r)['attack']])
print('records with decay == 0:', sum(1 for r in ins if env(r)['decay'] == 0), ' release == 0:', sum(1 for r in ins if env(r)['release'] == 0), ' sustain == 0:', sum(1 for r in ins if env(r)['sustain'] == 0))

print('\n== wave pattern shape fits (V2.4: "sine-like", "smooth single-peak")')
def fit_sine(s):
    best = None
    for ph in [x / 64.0 for x in range(64)]:
        for amp in [7.0, 7.25, 7.5, 7.75, 8.0]:
            err = 0
            for k, v in enumerate(s):
                m = 7.5 + amp * math.sin(2 * math.pi * (k + ph) / 32 - math.pi / 2)
                err = max(err, abs(min(15, max(0, m)) - v))
            if best is None or err < best[0]: best = (err, ph, amp)
    return best
for k in (0, 8, 9, 1):
    print(f'pattern {k}: best sine fit max |error| in sample levels = {fit_sine(pats[k])[0]:.2f}  (a pure sine quantised to 4 bits would be <= 0.5-1)')
print('pattern 1 is an exact triangle:', pats[1] == list(range(16)) + list(range(15, -1, -1)))
print('pattern 2 is an exact falling ramp (each level twice):', pats[2] == [15 - i // 2 for i in range(32)])
print('distinct levels pattern 9:', sorted(set(pats[9])), ' counts', collections.Counter(pats[9]))
