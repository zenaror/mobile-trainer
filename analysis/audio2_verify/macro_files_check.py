#!/usr/bin/env python3
"""Parse audio/music/*.asm and audio/sfx.asm (the macro form of the streams) and compare, command by command, with the independent decoder.

For each file: walk the lines, keep an address counter (reset by every label line `Name:: ; BB:AAAA`), emit the bytes each `sound_*` macro stands for
(opcode map written here from the driver's command table, durations via the value list read from the ROM table at 04:5044), and check
  (1) the emitted bytes equal the ROM bytes at that address,
  (2) the `; BB:AAAA` comment of every label equals the counter,
  (3) every `dw Label` word equals the ROM word at that address (labels resolved from the label lines of all these files),
  (4) every ROM command found by decode_streams.py at that address has the same kind/size as the macro line (so the macro text and the decode agree),
  (5) the song table lines of audio/music_pointers.asm (`sound_song Header, prio, flags, tracks ; id $NN`) equal the ROM records.
Usage: python3 macro_files_check.py [ROOT]
"""
import sys, os, re, glob, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import decode_streams as D

ROOT = D.ROOT
DUR = [D.rb(4, 0x5044 + i) for i in range(49)]        # Table_SoundDrv_Durations, 04:5044
IDX = {v: i for i, v in enumerate(DUR)}
assert len(IDX) == 49, 'the 49 table entries are distinct'

OPS = {'sound_end': 0xB1, 'sound_jump': 0xB2, 'sound_call': 0xB3, 'sound_ret': 0xB4, 'sound_loop': 0xB5, 'sound_tempo': 0xBC, 'sound_pitch_add': 0xBD,
       'sound_instrument': 0xBE, 'sound_volume': 0xBF, 'sound_pan': 0xC0, 'sound_pitch_bend': 0xC1, 'sound_pitch_bend_scale': 0xC2, 'sound_vibrato_rate': 0xC3,
       'sound_vibrato_delay': 0xC4, 'sound_vibrato_depth': 0xC5, 'sound_vibrato_disable': 0xC6, 'sound_detune': 0xC9, 'sound_cmd_CA': 0xCA, 'sound_cmd_CD': 0xCD,
       'sound_note_off': 0xCF}

files = sorted(glob.glob(os.path.join(ROOT, 'audio/music/music_*.asm'))) + [os.path.join(ROOT, 'audio/sfx.asm')]
LAB = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)::\s*(?:;\s*([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4}))?')

def num(s, labels):
    s = s.strip()
    if s.startswith('$'): return int(s[1:], 16)
    if re.fullmatch(r'\d+', s): return int(s)
    if s in CONSTS: return CONSTS[s]
    if s in labels: return labels[s]
    raise KeyError(s)

CONSTS = {'SOUND_INSTRUMENT_PER_NOTE': 0x64}      # DEF SOUND_INSTRUMENT_PER_NOTE EQU $64 in constants/audio_macros.inc (the one constant the stream files use)
# pass 1: label addresses (from the comments of the label lines; duplicates/aliases without comment share the address of the previous labelled line)
labels = {}; label_bank = {}
for f in files + [os.path.join(ROOT, 'audio/music_pointers.asm')]:
    last = None
    for ln in open(f, encoding='utf-8'):
        m = LAB.match(ln)
        if m:
            if m.group(2): last = (int(m.group(2), 16), int(m.group(3), 16))
            if last: labels[m.group(1)] = last[1]; label_bank[m.group(1)] = last[0]
        elif ln.strip() and not ln.startswith(('\t', ';', ' ')): last = None

problems = []; stats = collections.Counter(); macro_cmds = {}      # (bank, addr) -> (name, size)
for f in files:
    bank = None; addr = None; rs = False
    for no, ln in enumerate(open(f, encoding='utf-8'), 1):
        raw = ln.rstrip('\n'); code = raw.split(';')[0].strip()
        m = LAB.match(raw)
        if m and m.group(2):
            b, a = int(m.group(2), 16), int(m.group(3), 16)
            if addr is not None and a != addr: problems.append((os.path.basename(f), no, f'label {m.group(1)} says {b:02X}:{a:04X}, counter {addr:04X}'))
            bank, addr = b, a; stats['labels_checked'] += 1
            continue
        if not code or code.startswith('SECTION') or re.match(r'^[A-Za-z_][A-Za-z0-9_]*::?$', code): continue
        if bank is None: problems.append((os.path.basename(f), no, f'code before first label: {code}')); continue
        toks = re.match(r'(\w+)\s*(.*)$', code)
        name, argstr = toks.group(1), toks.group(2)
        rs = False
        if name == 'sound_rs':
            rs = True
            toks = re.match(r'(\w+)\s*(.*)$', argstr); name, argstr = toks.group(1), toks.group(2)
        args = [a.strip() for a in argstr.split(',')] if argstr else []
        out = []
        if name == 'sound_wait': out = [0x80 + IDX[num(args[0], labels)]]
        elif name == 'sound_note':
            d = num(args[0], labels); out = [0xCE if d == 0 else 0xCF + IDX[d]] + [num(a, labels) for a in args[1:]]
        elif name == 'sound_note_vol':
            d = num(args[0], labels); out = [0xCE if d == 0 else 0xCF + IDX[d], num(args[1], labels)]
        elif name == 'sound_note_off': out = [0xCF] + [num(a, labels) for a in args]
        elif name in ('sound_jump', 'sound_call'):
            t = num(args[0], labels); out = [OPS[name], t & 255, t >> 8]
        elif name == 'sound_loop':
            t = num(args[1], labels); out = [0xB5, num(args[0], labels), t & 255, t >> 8]
        elif name == 'sound_cmd_CD': out = [0xCD, num(args[0], labels), num(args[1], labels)]
        elif name in OPS: out = [OPS[name]] + [num(a, labels) for a in args]
        elif name == 'sound_stream_header':
            out = [num(args[0], labels), num(args[1], labels)]
        elif name == 'dw':
            out = []
            for a in args: v = num(a, labels); out += [v & 255, v >> 8]
        elif name == 'db': out = [num(a, labels) for a in args]; stats['db_lines'] += 1
        else:
            problems.append((os.path.basename(f), no, f'unknown line: {code}')); continue
        if rs:
            if out[0] < 0xBE: problems.append((os.path.basename(f), no, f'sound_rs on opcode {out[0]:02X}'))
            out = out[1:]
        rom = [D.rb(bank, addr + i) for i in range(len(out))]
        if rom != out: problems.append((os.path.basename(f), no, f'{bank:02X}:{addr:04X} {code}: macro bytes {bytes(out).hex()} != ROM {bytes(rom).hex()}'))
        else: stats['macro_lines_equal_rom'] += 1
        macro_cmds[(bank, addr)] = (name, len(out), rs)
        addr += len(out)
print('files:', len(files), ' lines checked equal to ROM:', stats['macro_lines_equal_rom'], ' labels with address comment checked:', stats['labels_checked'], ' db lines:', stats['db_lines'])
print('problems:', len(problems))
for p in problems[:15]: print('  ', p)

# (4) macro lines vs decoder
o = D.main()
allc = dict(o['_cmds'])
import coverage_check as C
allc.update(C.tail_cmds)
kind_of = {'sound_wait': ('wait', 'wait0'), 'sound_note': ('note',), 'sound_note_vol': ('note',), 'sound_note_off': ('noteoff',), 'sound_jump': ('jump',), 'sound_call': ('call',),
           'sound_ret': ('ret',), 'sound_loop': ('loop',), 'sound_end': ('end',), 'sound_cmd_CD': ('cd', 'cd_end')}
mism = []
for (bank, a), (name, size, rs) in macro_cmds.items():
    if name in ('dw', 'db', 'sound_stream_header'): continue
    c = allc.get((bank, a))
    if c is None: mism.append((bank, a, name, 'no decoded command at this address')); continue
    exp = kind_of.get(name, ('cmd1',))
    if c.kind not in exp or c.size != size or c.rs != rs: mism.append((bank, a, name, c.kind, c.size, size, c.rs, rs))
print('commands in macro files:', sum(1 for k, v in macro_cmds.items() if v[0] not in ('dw', 'db', 'sound_stream_header')), ' decoder commands:', len(allc), ' mismatches macro vs decoder:', len(mism))
for m in mism[:10]: print('  ', m)
only_dec = [k for k in allc if k not in macro_cmds]
print('decoded commands without a macro line:', len(only_dec))

# (5) song table lines
recs = D.records
bad = 0; n = 0
for ln in open(os.path.join(ROOT, 'audio/music_pointers.asm'), encoding='utf-8'):
    m = re.match(r'\s*sound_song\s+(\w+),\s*(\$[0-9A-F]+),\s*(\$[0-9A-F]+),\s*(\d+)\s*;\s*id\s+\$([0-9A-F]{2})', ln)
    if not m: continue
    n += 1
    r = recs[int(m.group(5), 16)]
    if (labels[m.group(1)], int(m.group(2)[1:], 16), int(m.group(3)[1:], 16), int(m.group(4)), label_bank[m.group(1)]) != (r['header'], r['prio'], r['flags'], r['count'], r['bank']):
        bad += 1; print('  SONG LINE MISMATCH', ln.strip(), r)
print('song table lines:', n, ' mismatching ROM records:', bad)
print('spare byte values:', collections.Counter(r['spare'] for r in recs.values()), ' flags:', collections.Counter(r['flags'] for r in recs.values()),
      ' prio:', collections.Counter(r['prio'] for r in recs.values()), ' counts:', sorted(collections.Counter(r['count'] for r in recs.values()).items()),
      ' banks:', collections.Counter(r['bank'] for r in recs.values()))
