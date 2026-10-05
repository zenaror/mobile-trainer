#!/usr/bin/env python3
"""Recount of the 'usage in the data' statistics of docs/research/audio_format.md section 4.4 with the independent decoder."""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import decode_streams as D
import coverage_check as C   # runs the coverage check (prints) and gives tail_cmds etc.
o = C.o
allc = dict(o['_cmds']); allc.update(C.tail_cmds)
reach = set(o['_cmds'])
print('\n================ usage (section 4.4) ================')
print('commands total', len(allc))
kinds = collections.Counter()
rs_kinds = collections.Counter()
opc = collections.Counter(); opc_rs = collections.Counter()
for (b, a), c in allc.items():
    k = 'note' if c.kind == 'note' else c.kind
    key = ('wait' if c.kind in ('wait', 'wait0') else ('note' if c.kind == 'note' else c.op))
    opc[key] += 1
    if c.rs: opc_rs[key] += 1
def nm(k): return k if isinstance(k, str) else f'${k:02X}'
print('by opcode (count, of which by running status):')
for k in sorted(opc, key=lambda k: (isinstance(k, int), k if isinstance(k, int) else 0, str(k))):
    print(f'   {nm(k):6s} {opc[k]:5d}  rs {opc_rs[k]:5d}')
print('never used among documented opcodes:', [f'${x:02X}' for x in (0xB5, 0xC0, 0xC6, 0xC9, 0xCA, 0xCD) if x not in opc])
# $80 waits (no-op)
print('wait0 ($80):', sum(1 for c in allc.values() if c.kind == 'wait0'))
# $B1 reached
reach_b1 = sum(1 for k, c in o['_cmds'].items() if c.op == 0xB1)
print('$B1 total', opc[0xB1], 'reachable', reach_b1, 'in tails', opc[0xB1] - reach_b1)
# tracks reaching an end / looping
n_end = n_loop = n_both = n_neither = 0
for (bank, h, k), d in o['_per_track'].items():
    has_end = any(any(v.kind == 'end' and v.op == 0xB1 for v in vs.values()) for vs in d.values())
    has_loop = any(any(v.kind == 'jump' and v.args[0] < a for v in vs.values()) for a, vs in d.items())
    n_end += has_end; n_loop += has_loop; n_both += (has_end and has_loop); n_neither += (not has_end and not has_loop)
print('tracks: with reachable $B1:', n_end, ' with a backward $B2:', n_loop, ' both:', n_both, ' neither:', n_neither)
# notes: kinds of operand sets
note_classes = collections.Counter(); adj_notes = 0
for (b, a), c in allc.items():
    if c.kind == 'note':
        d, p, v, adj = c.args
        note_classes[('pitch' if p is not None else '') + ('+vol' if v is not None else '') + ('+adj' if adj is not None else '')] += 1
print('note operand classes:', dict(note_classes), ' total', sum(note_classes.values()))
# duration values
wait_vals = collections.Counter(c.args[0] for c in allc.values() if c.kind == 'wait')
note_durs = collections.Counter(c.args[0] for c in allc.values() if c.kind == 'note')
print('distinct wait indexes:', len(wait_vals), ' distinct note duration indexes (None = $CE):', len(note_durs), ' $CE notes:', note_durs.get(None, 0))
# operand statistics of cmd1
for op in (0xBC, 0xBD, 0xBE, 0xBF, 0xC1, 0xC2, 0xC3, 0xC4, 0xC5):
    vals = collections.Counter(c.args[0] for c in allc.values() if c.kind == 'cmd1' and c.op == op)
    print(f'   ${op:02X}: n={sum(vals.values()):4d} distinct={len(vals):3d}', ' top:', vals.most_common(4), ' max:', max(vals) if vals else None, ' any >= $80:', any(v >= 0x80 for v in vals))
vol_vals = collections.Counter(c.args[2] for c in allc.values() if c.kind == 'note' and c.args[2] is not None)
print('note volume distinct:', len(vol_vals), 'range', min(vol_vals), max(vol_vals))
pitch_vals = collections.Counter(c.args[1] for c in allc.values() if c.kind == 'note' and c.args[1] is not None)
print('note pitch range:', hex(min(pitch_vals)), hex(max(pitch_vals)), 'distinct', len(pitch_vals))
# BD: only at start of tracks?
starts = {(b, st) for (b, h, k, st) in o['_tracks']}
bd = [(b, a) for (b, a), c in allc.items() if c.op == 0xBD]
print('$BD count', len(bd), ' at track start+2:', sum(1 for (b, a) in bd if (b, a - 2) in starts), ' values:', collections.Counter(allc[x].args[0] for x in bd))
# first command of each track = BF 7F, second BD vv
ok = 0
for (b, st) in starts:
    c1 = allc[(b, st)]; c2 = allc[(b, st + c1.size)]
    if c1.op == 0xBF and c1.args[0] == 0x7F and c2.op == 0xBD: ok += 1
print('tracks starting BF $7F then BD:', ok, 'of', len(starts))
# BE $64 (per-note instrument mode)
be = collections.Counter(c.args[0] for c in allc.values() if c.kind == 'cmd1' and c.op == 0xBE)
print('$BE operands: distinct', len(be), ' $64 uses:', be[0x64], ' max id', max(be), ' ids > $6F:', [hex(x) for x in be if x > 0x6F])
# BC tempo values
bc = collections.Counter(c.args[0] for c in allc.values() if c.kind == 'cmd1' and c.op == 0xBC)
print('$BC tempo: distinct', len(bc), ' $4A x', bc[0x4A])
# $CF uses
cf = [(b, a, c.args) for (b, a), c in allc.items() if c.kind == 'noteoff']
print('$CF uses:', [(hex(a), 'reachable' if (b, a) in reach else 'tail', [hex(x) if x else None for x in args]) for b, a, args in cf])
# calls
calls = [c for c in allc.values() if c.kind == 'call']
print('$B3 calls:', len(calls), ' targets distinct:', len({(c.bank, c.args[0]) for c in calls}), ' $B4 rets:', sum(1 for c in allc.values() if c.kind == 'ret'))
