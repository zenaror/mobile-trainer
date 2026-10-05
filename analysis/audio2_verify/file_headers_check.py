#!/usr/bin/env python3
"""V2.5: the first comment lines of every audio/*.asm and audio/music/*.asm (`; bank BB, $AAAA-$ZZZZ (N bytes); pinned by layout.link`, `; song id NN ...`)
against the real extents from build/mobile_trainer.sym + the map (section sizes) and against the song table."""
import os, re, glob, sys
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
if len(sys.argv) > 1: ROOT = sys.argv[1]
# section extents from the .map file: "SECTION: $4000-$5043 ($1044 bytes) ["audio/engine"]"
mp = open(os.path.join(ROOT, 'build/mobile_trainer.map'), encoding='utf-8').read()
sec = {}
cur_bank = None
for ln in mp.split('\n'):
    m = re.match(r'(?:ROM\w*|SRAM|WRAM\w*|VRAM|OAM|HRAM) bank #(\d+):', ln)
    if m: cur_bank = int(m.group(1)); continue
    m = re.match(r'\s*SECTION: \$([0-9a-f]{4})-\$([0-9a-f]{4}) \(\$([0-9a-f]+) bytes?\) \["([^"]+)"', ln)
    if m and cur_bank is not None: sec[m.group(4)] = (cur_bank, int(m.group(1), 16), int(m.group(2), 16), int(m.group(3), 16))
files = ['audio/engine.asm', 'audio/instruments.asm', 'audio/notes.asm', 'audio/wave_samples.asm', 'audio/music_pointers.asm', 'audio/sfx.asm'] + sorted(os.path.relpath(p, ROOT) for p in glob.glob(os.path.join(ROOT, 'audio/music/music_*.asm')))
bad = 0
for f in files:
    txt = open(os.path.join(ROOT, f), encoding='utf-8').read().split('\n')
    hdr = '\n'.join(txt[:3])
    m = re.search(r'bank (\d+), \$([0-9A-F]{4})-\$([0-9A-F]{4}) \((\d+) bytes\)', hdr)
    sm = re.search(r'SECTION "([^"]+)"', '\n'.join(txt[:8]))
    s = sec.get(sm.group(1)) if sm else None
    if not m or not s: print('?', f, bool(m), bool(s)); bad += 1; continue
    hb, ha, he, hn = int(m.group(1)), int(m.group(2), 16), int(m.group(3), 16), int(m.group(4))
    sb, sa, se, sn = s
    ok = (hb, ha, he - ha, hn) == (sb, sa, se + 1 - sa, sn)
    # header comments give [start,end) end exclusive: size = end-start
    print(f'{f:32s} header: bank {hb:02d} ${ha:04X}-${he:04X} ({hn:5d} bytes)   map: bank {sb:02d} ${sa:04X}-${se:04X} ({sn:5d} bytes)   {"OK" if ok else "MISMATCH"}')
    bad += (not ok)
print('mismatches:', bad)
