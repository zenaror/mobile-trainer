#!/usr/bin/env python3
"""Existing mGBA data-access traces vs the sound tables: which 6-byte instrument records, 3-byte note records, wave patterns and duration entries were ever read as data in
the 64 scenarios, compared with the independent walk of the streams (instrument_usage.py logic).  Read-only use of traces/detail.   Usage: trace_table_reads.py TRACES_DETAIL_DIR"""
import sys, os, glob, collections, io, contextlib
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ['A2V_QUIET'] = '1'
with contextlib.redirect_stdout(io.StringIO()):
    import decode_streams as D
    import coverage_check as C
    import instrument_usage as U
d = sys.argv[1]
rd = bytearray(0x4000)   # bank 04 bytes read as data
for f in sorted(glob.glob(os.path.join(d, '*', 'dataaccess.tsv'))):
    for ln in open(f):
        if ln.startswith('#'): continue
        k, b, s, e = ln.rstrip('\n').split('\t')[:4]
        if k == 'rom_read' and int(b, 16) == 4:
            for a in range(int(s, 16), int(e, 16)):
                if 0x4000 <= a < 0x8000: rd[a - 0x4000] = 1
inst_read = [i for i in range(112) if any(rd[0x51DD - 0x4000 + 6 * i + j] for j in range(6))]
inst_full = [i for i in range(112) if all(rd[0x51DD - 0x4000 + 6 * i + j] for j in range(6))]
print('instrument records with any byte read in the scenarios:', len(inst_read), ' fully read (6/6):', len(inst_full))
# the walk: ids selected by the data (+ drum records for the pitches used); U.tot_inst, U.tot_drum exist after import
sel = set(U.tot_inst) | {0x40 + p for p in U.tot_drum}
print('records selected by the data (walk):', len(sel), '  read but not selected:', sorted(set(inst_read) - sel), '  selected but never read in the scenarios:', sorted(sel - set(inst_read)))
# byte level: which bytes of the records are read (byte 0..5)
cnt = collections.Counter()
for i in inst_read:
    for j in range(6):
        if rd[0x51DD - 0x4000 + 6 * i + j]: cnt[j] += 1
print('records read per byte offset 0..5:', [cnt[j] for j in range(6)])
note_read = [i for i in range(120) if any(rd[0x5075 - 0x4000 + 3 * i + j] for j in range(3))]
print('note table records read:', len(note_read), ' index range', min(note_read), max(note_read))
wav_read = sorted({(a - (0x547D - 0x4000)) // 16 for a in range(0x547D - 0x4000, 0x551D - 0x4000) if rd[a]})
print('wave patterns read as data:', wav_read, ' (the copy loop reads all 16 bytes: wave patterns used by selected wave records:', sorted({U.ins[i][0] - 0x10 for i in sel if 0x10 <= U.ins[i][0] < 0x40}), ')')
dur_read = [i for i in range(49) if rd[0x5044 - 0x4000 + i]]
print('duration table entries read:', len(dur_read), 'of 49;  distinct duration indexes used by waits/notes in the data:', len({c.args[0] for c in C.o['_cmds'].values() if c.kind == 'wait'} | {c.args[0] + 0 for c in C.o['_cmds'].values() if c.kind == 'note' and c.args[0] is not None}))
