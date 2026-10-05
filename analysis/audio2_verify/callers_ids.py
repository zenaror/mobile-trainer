#!/usr/bin/env python3
"""List the sound ids that callers load into BC before calling the ROM0 sound stubs (static scan of the .asm tree).

For every `call/jp/farcall Sound_<Play...>` look back up to 8 instruction lines in the same file for `ld bc, $XXXX`, `ld c, $XX`, `ld b, $XX`.
Prints per stub the ids found and the unresolved call sites.  Not a proof (the id can come from a table or a register): it only shows what is loaded
with an immediate.   Usage: python3 analysis/audio2_verify/callers_ids.py [ROOT]
"""
import os, re, sys, collections
ROOT = sys.argv[1] if len(sys.argv) > 1 else os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
STUBS = ['Sound_PlaySfx', 'Sound_PlayMusic', 'Sound_PlayMusicOrResume', 'Sound_PlayMusicIfNotPlaying', 'Sound_StopSfxById', 'Sound_PauseMusic', 'Sound_ResumeMusic',
         'Sound_StartFadeOut', 'Sound_SetTrackParam', 'Sound_GetPlayingId', 'Sound_GetActiveMasks']
res = {s: collections.defaultdict(list) for s in STUBS}
unres = {s: [] for s in STUBS}
for d, _, fs in os.walk(ROOT):
    if any(x in d for x in ('/build', '/.git', '/docs', '/analysis', '/tools', '/traces', '/config')): continue
    for f in fs:
        if not f.endswith('.asm'): continue
        p = os.path.join(d, f)
        lines = open(p, encoding='utf-8', errors='replace').read().split('\n')
        for i, ln in enumerate(lines):
            code = ln.split(';')[0]
            m = re.search(r'\b(?:call|jp|jr|farcall)\s+(?:nz,\s*|z,\s*|nc,\s*|c,\s*)?(Sound_\w+)\b', code)
            if not m or m.group(1) not in STUBS: continue
            s = m.group(1)
            bc = None; c = None; b = None
            for j in range(i - 1, max(i - 9, -1), -1):
                cj = lines[j].split(';')[0].strip()
                if re.match(r'^[A-Za-z_.][\w.]*:?:?$', cj) or cj.startswith('.'):   # label line: keep looking (fallthrough from earlier code is possible)
                    pass
                mm = re.match(r'ld bc,\s*(\$[0-9A-Fa-f]+|\d+)', cj)
                if mm and bc is None and c is None and b is None: bc = int(mm.group(1).replace('$', '0x'), 16 if mm.group(1).startswith('$') else 10); break
                mm = re.match(r'ld c,\s*(\$[0-9A-Fa-f]+|\d+)$', cj)
                if mm and c is None: c = int(mm.group(1).replace('$', '0x'), 16 if mm.group(1).startswith('$') else 10)
                mm = re.match(r'ld b,\s*(\$[0-9A-Fa-f]+|\d+)$', cj)
                if mm and b is None: b = int(mm.group(1).replace('$', '0x'), 16 if mm.group(1).startswith('$') else 10)
                if c is not None and b is not None: break
            if bc is None and c is not None and b is not None: bc = (b << 8) | c
            if bc is None and c is not None and b is None: bc = c   # B unknown: report C only
            rel = os.path.relpath(p, ROOT)
            if bc is None: unres[s].append(f'{rel}:{i+1}')
            else: res[s][bc].append(f'{rel}:{i+1}')
for s in STUBS:
    n = sum(len(v) for v in res[s].values()) + len(unres[s])
    print(f'== {s}: {n} call sites, {sum(len(v) for v in res[s].values())} with an immediate id, {len(unres[s])} unresolved')
    for k in sorted(res[s]): print(f'   id {k:#06x} x{len(res[s][k])}  e.g. {res[s][k][0]}')
    if unres[s]: print('   unresolved:', ', '.join(unres[s][:12]), '...' if len(unres[s]) > 12 else '')
