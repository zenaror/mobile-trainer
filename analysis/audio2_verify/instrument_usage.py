#!/usr/bin/env python3
"""Which instrument records does the data select?  Walk every track in flow order (state machine of the driver: BE sets the record, BE $64 = per-note mode,
note pitch + pitch add + $40 selects the record in that mode), collecting (record, how).  Compares with section 6 claims (drum pitches $24-$27,$29,$2A,$2C-$2F)."""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import decode_streams as D
import tables_check as T  # prints; provides ins
o = D.main()
ins = T.ins
used_direct = collections.Counter(); drum = collections.Counter(); notes_pernote = 0
pitch_add = {}
for (bank, h, k), d in o['_per_track'].items():
    # replay each track along its linear path (first successor only is not enough: use all reachable decodes in address order with a mode flag per decode context)
    pass
# Context-sensitive walk: state (addr, rs, stack, mode, padd) 
def walk(bank, start):
    seen = set(); st = [(start, 0, (), False, 0)]
    out = []
    while st:
        a, rs, cs, mode, padd = st.pop()
        if (a, rs, cs, mode, padd) in seen: continue
        seen.add((a, rs, cs, mode, padd))
        cmd, nrs, succ = D.decode(bank, a, rs)
        if cmd.kind == 'cmd1' and cmd.op == 0xBE:
            if cmd.args[0] == 0x64: mode = True
            else: mode = False; out.append(('inst', cmd.args[0]))
        if cmd.kind == 'cmd1' and cmd.op == 0xBD: padd = cmd.args[0]
        if cmd.kind == 'note' and cmd.args[1] is not None and mode:
            p = (cmd.args[1] + padd) & 0xFF
            out.append(('drum', p))
        if cmd.kind == 'note' and cmd.args[1] is None and mode:
            out.append(('drum_nopitch', None))
        for s in succ:
            if s[0] in ('next', 'jump'): st.append((s[1], nrs, cs, mode, padd))
            elif s[0] == 'call':
                if len(cs) < D.MAXDEPTH: st.append((s[1], nrs, cs + (s[2],), mode, padd))
            elif s[0] == 'ret':
                if cs: st.append((cs[-1], nrs, cs[:-1], mode, padd))
                else: st.append((a + cmd.size, nrs, cs, mode, padd))
    return out
tot_inst = collections.Counter(); tot_drum = collections.Counter(); nopitch = 0
for bank, h, k, st0 in o['_tracks']:
    res = walk(bank, st0)
    for kind, v in set(res):
        if kind == 'inst': tot_inst[v] += 1
        elif kind == 'drum': tot_drum[v] += 1
        else: nopitch += 1
print('\n== instrument records selected (tracks using each; a track counts once per record):')
print('direct ids used:', len(tot_inst), sorted(tot_inst))
print('records with attack != 0 among them:', [(i, T.env(ins[i])['attack']) for i in sorted(tot_inst) if T.env(ins[i])['attack']])
print('per-note pitches used (after pitch add):', {hex(k): v for k, v in sorted(tot_drum.items())}, ' tracks with a per-note note without pitch byte:', nopitch)
print('=> per-note records $%02X..: ' % 0x64, [hex(0x40 + p) for p in sorted(tot_drum)], ' (doc: $64-$67, $69, $6A, $6C-$6F)')
print('record classes of directly selected ids:', collections.Counter(('pulse1' if ins[i][0] < 8 else 'pulse2' if ins[i][0] < 16 else 'wave' if ins[i][0] < 0x40 else 'noise') for i in tot_inst))
print('unused ids among 0..99:', len([i for i in range(100) if i not in tot_inst]))
print('wave records used and their pattern:', sorted((i, ins[i][0] - 0x10) for i in tot_inst if 0x10 <= ins[i][0] < 0x40))
