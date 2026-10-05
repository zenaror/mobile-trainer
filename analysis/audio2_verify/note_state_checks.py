#!/usr/bin/env python3
"""Flow-sensitive checks of how the data uses persistent note state (doc section 4.3: the note volume stays in force for following notes; pitch persists for
bare notes; $CF bare uses the last pitch).  State per path: (volume set?, pitch set?, instrument set?)."""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import decode_streams as D
o = D.main()
res = collections.Counter(); samples = collections.defaultdict(list)
def walk(bank, start, tag):
    seen = set(); st = [(start, 0, (), False, False, False)]
    while st:
        a, rs, cs, vol, pit, ins = st.pop()
        if (a, rs, cs, vol, pit, ins) in seen: continue
        seen.add((a, rs, cs, vol, pit, ins))
        cmd, nrs, succ = D.decode(bank, a, rs)
        if cmd.kind == 'cmd1' and cmd.op == 0xBE: ins = True
        if cmd.kind == 'note':
            d, p, v, adj = cmd.args
            if v is not None: vol = True
            if p is not None: pit = True
            if not vol: res['note_before_any_volume'] += 1; samples['note_before_any_volume'].append((tag, hex(a)))
            if p is None and not pit: res['bare_note_before_any_pitch'] += 1; samples['bare_note_before_any_pitch'].append((tag, hex(a)))
            if not ins: res['note_before_any_instrument'] += 1; samples['note_before_any_instrument'].append((tag, hex(a)))
            if p is not None and (p < 0x24 or p > 0x7F): res['pitch_out_of_range'] += 1
            res['notes_walked'] += 1
        if cmd.kind == 'noteoff':
            p = cmd.args[0]
            if p is None and not pit: res['noteoff_bare_before_pitch'] += 1
        for s in succ:
            if s[0] in ('next', 'jump'): st.append((s[1], nrs, cs, vol, pit, ins))
            elif s[0] == 'call':
                if len(cs) < D.MAXDEPTH: st.append((s[1], nrs, cs + (s[2],), vol, pit, ins))
            elif s[0] == 'ret':
                if cs: st.append((cs[-1], nrs, cs[:-1], vol, pit, ins))
                else: st.append((a + cmd.size, nrs, cs, vol, pit, ins))
for bank, h, k, st0 in o['_tracks']: walk(bank, st0, f'{bank:02X}:{h:04X}/{k}')
print(dict(res))
for k, v in samples.items(): print(k, len(set(v)), sorted(set(v))[:8])
