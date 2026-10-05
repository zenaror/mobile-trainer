#!/usr/bin/env python3
"""V2.5: the mechanical comments of audio/notes.asm (pitch byte + note name), audio/instruments.asm (id + decoded envelope) and audio/wave_samples.asm
(instrument byte 0) against values recomputed from the ROM bytes / the arguments on the same line."""
import os, re, sys
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
rom = open(os.path.join(ROOT, 'Mobile Trainer (Japan).gbc'), 'rb').read()
rb = lambda a: rom[4 * 0x4000 + a - 0x4000]
NAMES = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
bad = 0; n = 0
# notes
for ln in open(os.path.join(ROOT, 'audio/notes.asm'), encoding='utf-8'):
    m = re.match(r'\s*sound_note_freq\s+\$([0-9A-F]{4}),\s*\$([0-9A-F]{2})\s*;\s*pitch \$([0-9A-F]{2}) (\S+)', ln)
    if not m: continue
    n += 1
    per, step, pit, name = int(m.group(1), 16), int(m.group(2), 16), int(m.group(3), 16), m.group(4)
    idx = pit - 0x24
    a = 0x5075 + 3 * idx
    if (rb(a) | rb(a + 1) << 8, rb(a + 2)) != (per, step): bad += 1; print('note row differs from ROM', ln.strip())
    exp = NAMES[pit % 12] + str(pit // 12 - 1)
    if exp != name: bad += 1; print('note name', ln.strip(), 'expected', exp)
print('note rows checked:', n, ' problems:', bad)
# instruments
def env(r):
    a, s = r[3], r[4]
    f = lambda v: '-' if v == 0 else f'{v:X}'
    return f'attack {f((~(a >> 5)) & 7)}, decay {f((~(a >> 1)) & 7)}, sustain {s >> 4:X}, release {f((~(s >> 1)) & 7)}'
n = bad2 = 0
for ln in open(os.path.join(ROOT, 'audio/instruments.asm'), encoding='utf-8'):
    m = re.match(r'\s*sound_instr_(\w+)\s+([^;]*);\s*id \$([0-9A-F]{2})(.*)$', ln)
    if not m: continue
    n += 1
    i = int(m.group(3), 16)
    r = [rb(0x51DD + 6 * i + j) for j in range(6)]
    cls = 'pulse1' if r[0] < 8 else 'pulse2' if r[0] < 16 else 'wave' if r[0] < 0x40 else 'noise'
    if cls.replace('pulse', 'pulse') != m.group(1) and not (cls == 'noise' and m.group(1) == 'noise'): bad2 += 1; print('class', ln.strip(), cls)
    rest = m.group(4)
    if env(r) not in rest: bad2 += 1; print('env text', ln.strip(), env(r))
    mm = re.search(r'per-note record of pitch \$([0-9A-F]{2})', rest)
    if mm and int(mm.group(1), 16) + 0x40 != i: bad2 += 1; print('per-note pitch', ln.strip())
    if (i >= 0x64) != bool(mm): bad2 += 1; print('per-note flag', ln.strip())
print('instrument rows checked:', n, ' problems:', bad2)
# wave
n = bad3 = 0
txt = open(os.path.join(ROOT, 'audio/wave_samples.asm'), encoding='utf-8').read()
for k, m in enumerate(re.finditer(r'; wave (\d+) \(instrument byte 0 = \$([0-9A-F]{2})\)', txt)):
    n += 1
    if int(m.group(1)) != k or int(m.group(2), 16) != 0x10 + k: bad3 += 1; print('wave comment', m.group(0))
print('wave comments checked:', n, ' problems:', bad3)
