#!/usr/bin/env python3
"""Write analysis/audio2_verify/verdicts.tsv: one line per verified name / claim with its verdict (UPHELD, CORRECTED, DOWNGRADED, RETRACTED, NOT VERIFIED), the method
and the exact evidence, and print the counts.  The list is the source of truth for the counts quoted in docs/research/audio2_verify_static.md.
DOWNGRADED = name or claim kept, status lowered (CONFIRMED -> PROBABLE) because the code never runs in the 64 scenarios / only the author's interpreter shows it.
CORRECTED  = the text or the name changes.   Usage: python3 make_verdicts.py"""
import os, collections
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
V = []
def add(i, scope, item, verdict, method, evidence): V.append((i, scope, item, verdict, method, evidence))

# ---------------------------------------------------------------- names: the 40 applied driver rows
U, D, C = 'UPHELD', 'DOWNGRADED', 'CORRECTED'
rows = [
 ('SoundDrv_CmdWait', U, '04:4756 executed 1.1M x62; `add a,$31 / jp z` no-op, table index opcode-$80, counter value-1'),
 ('SoundDrv_TickVibrato', U, '04:45E6 9.5M x62; delay +$2B, phase +$20 += +$1F, triangle, (hi(tri*depth)-depth/2)*8 to +$24/$25'),
 ('SoundDrv_CmdSetPitchAdd', U, '04:483A 79k x63; +$12 added at 04:4A88 and 04:4B84'),
 ('SoundDrv_ParamPitchOffset', D, '04:4840 never executed; word to +$13/$14 + flag bit 2; SetTrackParam has no caller'),
 ('SoundDrv_CmdPitchBend', U, '04:4896 302k x61; formula note in claim C-5.1-C1'),
 ('SoundDrv_PitchBendProduct', U, '04:48AD 323k x61; sla b, Mul8x8, negate by dec hl/cpl'),
 ('SoundDrv_CmdPitchBendScale', U, '04:48D5 21k x61; +$1A then product'),
 ('SoundDrv_CmdVibratoRate', U, '04:48EC 5k x61; +$1F; presets +$20 for $00/$80 (that branch never ran)'),
 ('SoundDrv_ParamVibratoRate', D, '04:4908 never executed; same two cases via SetTrackFieldByte/Word'),
 ('SoundDrv_CmdVibratoDelay', U, '04:4925 4.6k x61; +$2A, copied to +$2B at 04:4A93'),
 ('SoundDrv_CmdPan', D, '04:4955 never executed; +$17 -> +$2E -> NR51 masks re-derived (left 00-1F, both 20-5F, right 60-7F)'),
 ('SoundDrv_ParamPanOffset', D, '04:4962 never executed; D03C bit 0, bc=$18'),
 ('SoundDrv_CmdVibratoDepth', U, '04:4970 5k x61; bc=$21'),
 ('SoundDrv_CmdStoreTrackByte', U, '04:4973 89k x63; 9 referrers re-listed'),
 ('SoundDrv_CmdVibratoDisable', D, '04:4984 never executed; or $07, +$23; polarity right'),
 ('SoundDrv_ParamVibratoDepth', D, '04:4991 never executed; writes +$22 (second addend, 04:460A-460B), not +$21; twin-like with CmdVibratoDepth, kept'),
 ('SoundDrv_CmdDetune', D, '04:4997 never executed; +$1D, exact (v-$40)/64 semitones'),
 ('SoundDrv_CmdStoreTrackSigned', D, '04:49A2 never executed; rlca - $80'),
 ('SoundDrv_ExtSetTrack27', U, '04:49C3 PROBABLE; $CD 6 -> +$27 (table entry 6)'),
 ('SoundDrv_ExtSetTrack28', U, '04:49C8 PROBABLE; $CD 7 -> +$28'),
 ('SoundDrv_ExtSetInstrByte0', D, '04:49D3 never executed; $CD 1 -> +$0C'),
 ('SoundDrv_ExtSetInstrByte1', D, '04:49D8 never executed; $CD 10 -> +$0D'),
 ('SoundDrv_ExtSetInstrByte2', U, '04:49DD PROBABLE; $CD 11 -> +$0E'),
 ('SoundDrv_ExtSetInstrByte3Hi', D, '04:49E2 never executed; $CD 2 -> high nibble of +$0F'),
 ('SoundDrv_StoreHighNibble', D, '04:49E5 never executed; swap/and $F0 over old low nibble: polarity right'),
 ('SoundDrv_ExtSetInstrByte3Lo', D, '04:49FF never executed; $CD 3 -> low nibble of +$0F'),
 ('SoundDrv_StoreLowNibble', D, '04:4A02 never executed; and $0F over old high nibble: polarity right'),
 ('SoundDrv_ExtSetInstrByte4Hi', U, '04:4A1A PROBABLE; $CD 4 -> high nibble of +$10'),
 ('SoundDrv_ExtSetInstrByte4Lo', U, '04:4A1F PROBABLE; $CD 5 -> low nibble of +$10'),
 ('SoundDrv_CmdUnassigned', D, '04:4A24 never executed; jp CmdEnd; "unassigned" is an interpretation (neighbours $B9-$BB, $CC jump to CmdEnd directly)'),
 ('SoundDrv_CmdNoteHeld', U, '04:4A27 37 x12; ld b,0 / jr ReadNoteBytes; gate 0 never decremented (04:4BF7-4BF9)'),
 ('SoundDrv_ReadNoteBytes', U, '04:4A36 917k x63; classes by value, each once'),
 ('SoundDrv_CmdNoteOff', U, '04:4B66 18 x7; text "each channel" corrected: first match only (jr $4BC5 at 04:4BBE)'),
 ('SoundDrv_ServiceChannelGate', U, '04:4BEB 5.4M x62; track flags < $C0 -> stop; gate 0 held; dec [hl]'),
 ('SoundDrv_StopChannelTrackEnded', C, 'renamed SoundDrv_StopChannelTrackNotRunning: only test is flags < $C0 (04:4BF2-4BF4), true for ended, paused (res 7 at 04:4443) and restarted ($A0) tracks'),
 ('SoundDrv_StopChannel', U, '04:4C0F 61k x63; xor a / ld [hl],a / jp SilenceChannel'),
 ('SoundDrv_LoadSustainField', U, '04:4DD3 465k x62; byte 4 & $F0; callers 04:4CF4, 04:4D2A'),
 ('SoundDrv_ComputeTargetVolume', U, '04:4DDF 881k x62; (hi(+$2F)*hi(ch+6)+$0F)&$F0'),
 ('SoundDrv_ComputeSustainVolume', U, '04:4E04 881k x62; double ceil product'),
 ('SoundDrv_WaveLevelChanged', U, '04:4E34 2.7M x62; wave channel only, (new^old)&$C0 sets the volume flag'),
]
for i, (n, v, e) in enumerate(rows, 1):
    add(f'N{i:02d}', 'name (audio2_renames.tsv driver row)', n, v, 'code re-read at the label, callers/callees, coverage_union.tsv', e)
add('N41', 'name (HYPOTHESIS row, not applied)', 'Label_04_49B6 (idea SoundDrv_CmdStoreTrack1E)', U, 'code + all-offset enumeration', 'stays neutral: +$1E has a writer (04:49B6) and no reader')
add('N42', 'name (HYPOTHESIS row, not applied)', 'Label_04_49CD (idea SoundDrv_ParamTrackWord27)', U, 'code', 'entry 6 of ParamHandlers: word to +$27/$28; stays neutral')
add('N43', 'name (generated rows)', '210 rows Data_BB_AAAA -> SoundSongNN_Header / TrackK', U, 'names_check.py from the song table and headers', '210 of 210 equal the independent derivation; only Data_04_574D is left out on purpose')
add('N44', 'name (generated rows)', 'prefix SoundSong for the 30 effect records (75 rows)', C, 'callers_ids.py, sound_test.asm help text, audio_format.md section 1', 'ids $29-$46 reach only Sound_PlaySfx (367 immediate call sites); music ids $01-$1D only Sound_PlayMusic*; renamed SoundSfxNN_*')
add('N45', 'name', 'Data_SoundDrv_Streams (04:574D)', C, 'header word 0 of song $01', 'names one track as "the streams"; renamed SoundSong01_Track0')
add('N46', 'name (prefix rule)', 'SoundDrv_ only in the bank-04 body', U, 'build/mobile_trainer.sym', '125 SoundDrv_*/Table_SoundDrv_* symbols, all in bank 04')
for k, (n, e) in enumerate([('Table_SoundDrv_Songs', '70 records of 8 bytes at 04:551D (generic: holds songs and effects)'), ('Table_SoundDrv_Commands', '31 words, opcodes $B1-$CF'),
                            ('Table_SoundDrv_ExtCommands', '12 words, $CD sub-commands 0-11'), ('Table_SoundDrv_ParamHandlers', '7 words, entries re-read'),
                            ('Table_SoundDrv_SfxTrackPtrs', '4 WRAM record addresses indexed 1-4 from 04:4499'), ('Table_SoundDrv_Durations', '49 bytes'),
                            ('Table_SoundDrv_NoteFreq', '120 x (dw period, db step)'), ('Table_SoundDrv_Instruments', '112 x 6 bytes'), ('Table_SoundDrv_WavePatterns', '10 x 16 bytes')], 47):
    add(f'N{k}', 'name (table, earlier pass)', n, U, 'bytes + users', e)
add('N56', 'name (macros)', '34 public sound_* macros of constants/audio_macros.inc', U, 'each macro vs the handler it emits', 'names follow the handlers; the two neutral ones (sound_cmd_CA, sound_cmd_CD) are correct')

# ---------------------------------------------------------------- claims
def c(i, loc, claim, verdict, method, evidence): add(i, 'claim ' + loc, claim, verdict, method, evidence)
c('C-1.1', 's1 row 1 / s3.1', 'song record = dw header, dw bank, db priority, flags, count, spare; priority $C8 x67 $D2 x2 $C9 x1; flags $FF; counts 4x35 1x19 2x11 3x5', U, 'LoadSongHeader read + ROM', 'recomputed from the 70 records')
c('C-1.2', 's1 row 2', 'stream consumption for the constructs the data uses', U, 'ReadNextCommand re-read + independent decoder', '11 916 commands decoded; macro lines = decoder')
c('C-1.2b', 's1 row 2 / s4.2', 'constructs the data never uses (`$B5`, adjust bytes, `$CD`, `$80`) "CONFIRMED by synthetic streams"', D, 'rule: never executed in the ROM', 'code read agrees; status PROBABLE (dispatcher never reads $B5/$CD entries in 64 scenarios)')
c('C-1.3', 's1 row 3', 'every byte of 04:574D-7E8C and 05:4000-68C3 explained, no overlap', U, 'decode_streams.py, coverage_check.py', '20 482 = 19 716 + 766, 0 gaps/overlaps')
c('C-1.4', 's1 row 4 / s5.1', '`$C1`-`$C5`, `$CF`: effects CONFIRMED', U, 'code + executed in ROM', 'entries executed (coverage) and read by the dispatcher (traces)')
c('C-1.4b', 's1 row 4 / s5.1', '`$C0`, `$C6`, `$C9` CONFIRMED (32 / - / 6 values simulated)', D, 'rule + traces', 'opcodes absent from the data, handlers never executed; PROBABLE')
c('C-1.5', 's1 row 5 / s5.1', '`$CA` stores a byte nothing reads', U, 'enumeration of every track offset in engine.asm', 'only writer 04:49B6, no reader (limit: other banks not checked per site, see C-5.3-R)')
c('C-1.5b', 's1 row 5 / s5.1', '`$CD` sub-commands 1-3, 10 CONFIRMED on the running driver', D, 'rule', 'never executed in the ROM; the author interpreter only; PROBABLE')
c('C-1.6', 's1 row 6 / s6', 'instrument record layout: byte 0 class, byte 3-4 envelope, byte 5 per-note pitch', U, 'code + traces', 'records read: bytes 0-4 of 54 records, byte 5 of the 10 per-note records only')
c('C-1.6b', 's6', 'byte 1 (length) and byte 2 (NR10) semantics CONFIRMED', D, 'rule', 'both are $00 in all 112 records, the non-zero code paths never run in the ROM; PROBABLE')
c('C-1.7', 's1 row 7 / s8', 'durations, note table, wave patterns', U, 'tables_check.py', 'numbers exact; MIDI offset 36 unique (120/120 within 1)')
c('C-1.8', 's1 row 8 / s3.2', 'extra pointer sets: loop point and address behind the final jump, 86/86, start+4 in 79', U, 'coverage_check.py + traces', 'never read: 0 of 344 bytes in 64 scenarios')
c('C-3.2', 's3.2', 'header = 2 bytes + count words (+2 sets), byte 0 = count, byte 1 = 0 or 2', U, 'decode', '59/59, 37 x0, 22 x2')
c('C-4.1', 's4.1', 'ReadNextCommand: bit 7, running status for opcodes >= $BE, dispatch', U, 'code 04:459B-45CD', 'Bank4_ReadStreamWord does inc de once')
c('C-4.2a', 's4.2', 'wait = Table[opcode-$80], counter value-1, `$80` no-op', U, 'code + arithmetic', '04:4756-4776')
c('C-4.2b', 's4.2', '`$B1`-`$B4` end/jump/call (limit 5)/return (empty = no-op)', U, 'code 04:4777-47C4 + decoder', 'max depth reached in the data is 1; all 113 `$B4` run with an empty stack once (inline first play)')
c('C-4.2c', 's4.2', '`$BC` tempo, `$BD` pitch add, `$BE`/`$64`, `$BF`', U, 'code', '04:47E3-4888, 04:492A')
c('C-4.2d', 's4.2', 'end handlers `$B6-$BB $C7 $C8 $CB $CC` (8 via CmdUnassigned)', U, 'table 04:46E8', 'entries re-read')
c('C-4.3', 's4.3', 'note operand classes, each once, adjust to the duration, pitch before volume in the data', U, 'code 04:4A27-4A80 + decode', '2311/2311 pitch first')
c('C-4.3b', 's4.3', 'gate time: released d ticks after the start, `$CE` held', U, 'loop order 04:40AC-40CF + 04:4BEB', 'channel service precedes the track step in a tick')
c('C-4.4', 's4.4', 'usage statistics (16 counts, 8 operand statistics)', U, 'usage_counts.py', 'all identical')
c('C-5.1-C0', 's5.1', '`$C0` pan formula and NR51 mapping', U, 'WriteChannelPan 04:4F4F-4F96', 'left $00-$1F, both $20-$5F, right $60-$7F; exact only for v < $80')
c('C-5.1-C1', 's5.1', '`$C1`: product = 2*(+$19)*scale, offset (v-$40)*scale/64 semitones', C, 'bend_formula.py (12-instruction hand model, all 8192 pairs)', 'exact for v >= $40; for v < $40 the product is 4(v-$40)*scale + scale (negative branch multiplies 2|n|-1)')
c('C-5.1-C2', 's5.1', '`$C2` scale (2 at start)', U, 'code', '04:48D5')
c('C-5.1-C3', 's5.1', '`$C3` rate $17 at start; $00/$80 preset the phase', U, 'code', 'preset branch 04:48FD-4904 never executed')
c('C-5.1-C4', 's5.1', '`$C4` delay copied to +$2B at note start', U, 'code', 'phase forced to $40 meanwhile')
c('C-5.1-C5', 's5.1', '`$C5` depth*8/256 semitones peak-to-peak', U, 'code 04:462E-463F', '(hi(tri*depth) - depth/2) * 8')
c('C-5.1-C6', 's5.1', '`$C6` non-zero leaves the vibrato out of the pitch', D, 'rule', 'never executed; refinement: phase keeps running')
c('C-5.1-C9', 's5.1', '`$C9` detune (v-$40)/64 semitones', D, 'rule', 'never executed; formula exact')
c('C-5.1-CF', 's5.1', '`$CF` releases each matching channel', C, 'code 04:4B9D-4BC6', 'only the first matching channel (jr $4BC5 after the call)')
c('C-5.1-TAIL', 's5.1 / s11', '+$27/+$28: read at 04:4D67/4D69; "tail after the note" (HYPOTHESIS)', C, 'code 04:4C3F-4C4A, 04:4D54-4D8E', 'reads at 04:4D66/4D68; the age counter gets +1/+2 per tick and -1 in state 00, so it cannot count down: +$28 is not a tail length')
c('C-5.1-P', 's5.1', 'Table_SoundDrv_ParamHandlers 7 entries and what they write', U, 'code', 'entries 0-6 re-read; mask building D03B/D03A')
c('C-5.2', 's5.2', 'per-tick chain, output sums, tempo accumulator', U, 'code 04:4082-4119, 04:4668-46E6', 'all sums re-derived')
c('C-5.3-F', 's5.3', 'flags byte: bit 7 active, bit 6 initialised, bit 4 per-note, bits 0-2 changed', C, 'code', 'bit 5 omitted ($A0 from StartTrack; ResumeMusic tests $60)')
c('C-5.3-I', 's5.3', 'instrument copy +$0C..+$10 initial `0, 0, FF, FF, 0`', C, 'ROM bytes 04:43A2-43B1', 'it is 0, 0, 0, $FF, $FF (two effects rely on it)')
c('C-5.3-O', 's5.3', 'all other fields: initial values, writers, readers', U, 'ROM bytes 04:438B-43DB + code', 'each row re-read')
c('C-5.3-N', 's5.3', '+$1E, +$30, +$31 read by nothing', U, 'enumeration of all offsets in the driver', 'driver and ROM0 stubs only; stack formula never touches +$30/$31')
c('C-5.3-R', 's5.3', 'no reader in other banks', 'NOT VERIFIED', 'wram_range_users.py', '211 operand sites in $D040-$D27F outside audio/ use the screens own WRAM bank; no per-site rSVBK proof')
c('C-7.1', 's7', 'envelope: attack ~b7b6b5, decay ~b3b2b1, sustain hi(byte 4), release ~b3b2b1, mirror stepped every period ticks', U, 'code 04:4C5F-4D3A', 'cpl/rrca/and 7 patterns re-derived; 16/15 correction of TickDivider')
c('C-7.2', 's7 / s1', 'attack CONFIRMED on record $68; the other 79 simulated have none', C, 'instrument_usage.py + traces', 'the data never selects $68; the only attack record used is wave record $4B (SFX $42); attack branch ran 12 times in the ROM')
c('C-7.3', 's7', 'bits 3-4/0 of byte 3 and bit 0 of byte 4 not read', U, 'enumeration of reads of ch+$0B/$0C', 'no instruction tests them (HYPOTHESIS: unused stays right)')
c('C-8.1', 's8', 'duration table 49 bytes', U, 'bytes', 'exact list; index arithmetic re-derived')
c('C-8.2', 's8', 'note table: period within 1 of equal temperament (MIDI 36+i), step = next - this within 1', U, 'tables_check.py', 'max error 0.852; histogram 0:114 -1:5 +1:1; step diff 0:76 -1:35 +1:8')
c('C-8.2b', 's8', 'record 119 saturates at 2046', C, 'tables_check.py', '2046 is the exact rounding (2045.93), not a clamp; wording only')
c('C-8.3', 's8', 'wave patterns 0-8 described as sine, triangle, ramp, plateau, pulses with 4/8/12/16 highs, smooth single peak', U, 'tables_check.py fit', 'pattern 0 fits a sine to 0.5 level; 1, 2 exact; 4-7 exact counts')
c('C-8.3b', 's8', 'pattern 9 "smooth single-peak"', C, 'tables_check.py', 'five levels 0 4 8 B F with plateaus: stepped bump')
c('C-8.4', 's8', 'wave patterns are played high nibble first and copied to $FF30-$FF3F unchanged', U, 'code 04:4EA9-4EC9', 'copy loop; hardware convention')
c('C-9', 's9', 'results of the author interpreter runs (36 combinations, 80 records, 152 tracks ...)', 'NOT VERIFIED', 'static verifier does not emulate', 'left to the dynamic verifier; the decoder facts it relied on were re-derived (C-1.2, C-1.3)')
c('C-10.1', 's10', 'macro bytes = ROM bytes; labels 333 added in the first pass', U, 'macro_files_check.py + git read-only', '12 078 lines equal ROM; 535 label comments; 333 labels added by d9661aa')
c('C-10.2', 's10', '7 unreferenced labels removed by the second pass', U, 'git read-only', 'Data_05_5B34 5BCB 5C9E 5D69 5F09 5FF1 68BE; 0 references in the parent tree')
c('C-10.3', 's10', 'example "How to add a song" assembles without warning', U, 'rgbasm with project flags', 'record 0 = 0B 00 00 FB 7F 3C, pitch $40 = E4')
c('C-10.4', 's10 / macros', 'macro operand checks (asserts)', C, 'macro_asserts_test.sh (18 sources)', 'durations, rs, duty, class, period refused; pitch/volume class mix-ups, wave pattern > 9, operands >= $80 accepted: add ASSERTs')
c('C-11.1', 's11', 'ids $1E-$28 reachable?', C, 'callers_ids.py, sound_test.asm', 'only the unreferenced sound-test screen can request such an id: not reachable in normal play')
c('C-11.2', 's11', 'set-1/set-2 pointers have no reader in the driver', U, 'callers of Bank4_ReadStream*, traces', 'five call sites in engine.asm; 0 bytes of the sets read in 64 scenarios')
c('C-12', 's12', 'differences from naming_g1.md (wait 4868 vs 4871, $BE 1109 vs 1110)', U, 'decode', 'reachable-only counts 4868 and 1109 reproduced')
c('C-T1', 'text', 'REVERSE_ENGINEERING.md:62 role of bank 04 "PROBABLE at best"', C, 'coverage_union.tsv', 'SoundDrv_FrameTick 3.4M executions, APU writes: CONFIRMED sound driver')
c('C-T2', 'text', 'REVERSE_ENGINEERING.md:38 "checked by running the ROM driver", "commands named by demonstrated effect"', C, 'tools/audio_driver_check.py is an interpreter; $C0 $C6 $C9 never run in the ROM', 'reword')
c('C-T3', 'text', 'stale names in audio_format.md and audio_macros.inc (Label_04_4BEB, Function_04_4E34, SoundDrv_CmdRest, CmdNote entry 04:4B66/4A27)', C, 'grep', 'listed in the report')
c('C-T4', 'text', 'mechanical comments: 120 note names, 112 instrument decodes, 10 wave labels, 35 file header extents', U, 'table_comments_check.py, file_headers_check.py', '0 problems')
c('C-T5', 'text', '124 of 214 region header comments in music/sfx still say "content class unknown"', C, 'grep', 'superseded text (acknowledged in s10); cleanup suggested')

out = os.path.join(ROOT, 'analysis/audio2_verify/verdicts.tsv')
with open(out, 'w', encoding='utf-8') as f:
    f.write('# id\tscope\titem\tverdict\tmethod\tevidence\n')
    for r in V: f.write('\t'.join(r) + '\n')
cnt = collections.Counter(); cn = collections.Counter(); cc = collections.Counter()
for r in V:
    cnt[r[3]] += 1
    (cn if r[1].startswith('name') else cc)[r[3]] += 1
print('items:', len(V), dict(cnt))
print('names:', sum(cn.values()), dict(cn), '  claims/text:', sum(cc.values()), dict(cc))
print('wrote', out)
