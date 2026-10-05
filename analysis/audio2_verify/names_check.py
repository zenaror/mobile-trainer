#!/usr/bin/env python3
"""V2.1 mechanical check of the 210 generated rows (SoundSongNN_Header / SoundSongNN_TrackK) of analysis/naming2/audio2_renames.tsv
against the song table and headers as decoded by decode_streams.py (independent of tools/audio_to_macros.py).
Expected: the header label carries the lowest id whose record uses the header; track k of that header = k-th word of the header (set 0);
Data_SoundDrv_Streams (04:574D, track 0 of song 1) keeps its label."""
import sys, os, re, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import decode_streams as D
ROOT = D.ROOT
rows = []
for ln in open(os.path.join(ROOT, 'analysis/naming2/audio2_renames.tsv'), encoding='utf-8'):
    if ln.startswith('#') or not ln.strip(): continue
    f = ln.rstrip('\n').split('\t')
    rows.append(f)
gen = [r for r in rows if 'SoundSong' in r[1]]
print('manifest rows:', len(rows), ' generated SoundSong rows:', len(gen))
users = collections.defaultdict(list)
for n, r in D.records.items(): users[(r['bank'], r['header'])].append(n)
expected = {}      # old name -> (new name, kind, bank, addr)
for (bank, h), ids in users.items():
    n = min(ids)
    expected[f'Data_{bank:02X}_{h:04X}'] = (f'SoundSong{n:02X}_Header', bank, h)
    for k in range(D.records[n]['count']):
        st = D.rw(bank, h + 2 + 2 * k)
        expected[f'Data_{bank:02X}_{st:04X}'] = (f'SoundSong{n:02X}_Track{k}', bank, st)
bad = 0; seen = set()
for old, new, kind, status, ev in [r[:5] for r in gen]:
    seen.add(old)
    e = expected.get(old)
    if not e or e[0] != new:
        bad += 1; print('  MISMATCH', old, new, e)
    if kind != 'data' or status != 'CONFIRMED': print('  kind/status', old, kind, status)
missing = [o for o in expected if o not in seen]
print('rows whose (old,new) differ from the independent derivation:', bad, ' expected names without a row:', missing)
# header ids: first id vs all ids
shared = {k: v for k, v in users.items() if len(v) > 1}
print('headers shared by several ids:', {f'{b:02X}:{h:04X}': [f'{i:02X}' for i in v] for (b, h), v in shared.items()})
# what the ids are used for: music ids 01..1D vs sfx ids 29..46 (callers_ids.py)
print('ids 01-1D headers:', len({(r['bank'], r['header']) for n, r in D.records.items() if n <= 0x1D}), ' ids 29-46 headers:', len({(r['bank'], r['header']) for n, r in D.records.items() if n >= 0x29}))
print('SFX header rows (first id 29..46):', sum(1 for o, (nn, b, a) in expected.items() if re.match(r'SoundSong(2[9A-F]|3[0-9A-F]|4[0-6])_', nn)))
