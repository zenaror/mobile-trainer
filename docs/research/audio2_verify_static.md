# Audio pass 2: static adversarial verification

Scope: the names of `analysis/naming2/audio2_renames.tsv` (40 applied driver rows + 210 generated `SoundSongNN_*` rows; the 2 HYPOTHESIS rows are not applied), the names of the sound tables and macros, and the claims of
`docs/research/audio_format.md` (sections 1-12) and of `constants/audio_macros.inc` about the sound driver (bank 04) and the sound data (banks 04/05).
Fixes: [`analysis/naming2/verify_audio2_fixes.tsv`](../../analysis/naming2/verify_audio2_fixes.tsv) (77 rows; applies cleanly with `tools/apply_renames.py --strict`; `make` stays IDENTICAL, `make sym-check` OK).
Scripts and per-claim verdicts: [`analysis/audio2_verify/`](../../analysis/audio2_verify/) (`run_all.sh` re-runs everything; `verdicts.tsv` has one line per verified name or claim).
Status (2026-10-05): the 77 renames of the TSV and the three-line change of `tools/audio_to_macros.py` (prefix `SoundSfx`) were applied to the tree (`make` IDENTICAL, `sym_check` OK, `tools/audio_to_macros.py --check` exit 0); the patch file was not kept.  The text corrections under "Corrections to apply" were applied on 2026-10-05 together with those of the dynamic report, in `docs/research/audio_format.md` and the other files named there.  Line numbers in this report are those of the tree at 8f9b055.
**Erratum (2026-10-05, after the mGBA run of [`audio2_verify_dynamic.md`](audio2_verify_dynamic.md)): finding 5 and the "Suggested wording" for `+$27/+$28` below are WRONG and withdrawn.**  The report notes the 8-bit wrap of the age counter but does not follow it through: the counter rises by one every 15 ticks, so it wraps to 0 after
about `(256 - +$28) * 15` ticks and the channel is then silenced; `+$28` therefore is a tail length.  On mGBA 48 of 48 combinations of (`+$27`, `+$28`) equal that model.  The status stays PROBABLE (no song sets either field; synthetic runs do not raise a status): `audio_format.md` section 5.1 has the corrected text.
Verifier stance: try to refute every name and claim; a claim is UPHELD only when re-derived independently from the ROM bytes and the disassembly (not from the evidence column, not from `tools/audio_driver_check.py`
or `tools/audio_to_macros.py`).  This verifier is STATIC: no emulation; its only dynamic input is the existing mGBA material of the repository (`analysis/coverage_union.tsv`, `traces/detail/*/dataaccess.tsv`) read as data.

## Result

| verdict | names (56 items) | claims and text (60 items) | total |
|---|---|---|---|
| UPHELD | 38 | 38 | 76 |
| DOWNGRADED (name or claim kept, status CONFIRMED -> PROBABLE) | 15 | 6 | 21 |
| CORRECTED (name or text changes) | 3 | 14 | 17 |
| RETRACTED | 0 | 0 | 0 |
| NOT VERIFIED | 0 | 2 | 2 |

Names: 40 applied driver rows (24 upheld, 15 lowered, 1 renamed), 2 HYPOTHESIS rows (kept neutral), the 210 generated `SoundSongNN_*` rows (210 of 210 equal the independent derivation; 75 of them get the prefix `SoundSfx`, one more label is renamed),
the `SoundDrv_` prefix rule, 9 `Table_SoundDrv_*` names and 34 `sound_*` macros (upheld).  Nothing refuted outright, no polarity inversion and no swapped twins.  The two NOT VERIFIED items are the author-interpreter runs of section 9 (not emulated here) and the absence of readers
of three unused track fields in banks other than the driver's.

The findings that matter most (details in the sections below):

1. **Section 5.3 states a wrong initial instrument copy**: `+$0C..+$10` is `0, 0, 0, $FF, $FF` (ROM 04:43A2-43B1), not `0, 0, $FF, $FF, 0`; two effects (ids `$2A`, `$2B`) depend on this default record.
2. **15 driver names are CONFIRMED in the manifest but never run** in the 64 scenarios (opcodes `$C0 $C6 $C9 $CD` and the `SetTrackParam` family are not in the data); the names are right, the status is PROBABLE.  The doc's CONFIRMED for `$B5`, adjust bytes, `$C0`, `$C6`, `$C9`, `$CD`
   and instrument bytes 1-2 (always 0 in the data) has the same cause.
3. **`$C1` formula is exact only for `v >= $40`**; below `$40` the code adds `scale` units of 1/256 semitone (18.75 cents at the largest scale used).
4. **`$CF` releases the first matching channel only**, not each.
5. **[WITHDRAWN, see the erratum under Status] The "tail after the note" hypothesis (`+$27/+$28`) is contradicted by the code's own counter**: the age counter gets +1 (+2 on every 15th tick) per tick and only -1 in the end state, so it cannot count down; `+$28` is not a duration.
6. **Attack evidence**: the doc's attack row rests on record `$68`, which the data never selects; the only attack record used is wave record `$4B` (effect `$42`).
7. **`SoundSongNN` for the 30 effect records contradicts the project's own classification** (ids `$29-$46` go only to `Sound_PlaySfx`; the sound-test screen says "MUSIC" / "SOUND"): renamed `SoundSfxNN_*` (75 rows); `SoundDrv_StopChannelTrackEnded` states a cause the code does not test: renamed `...TrackNotRunning`.
8. Stale text: `REVERSE_ENGINEERING.md:62` still lists the role of bank 04 as open ("PROBABLE at best") although the sound driver is CONFIRMED by 3.4 million executed ticks; stale pre-rename names in the doc and the macro comments; 124 superseded region comments.
9. Strong confirmations: the independent decoder reproduces every count of the doc (70 / 59 / 152 / 11,916 commands / 19,716 bytes / 20,482 bytes covered without gap or overlap / usage of every opcode), the macro files equal the ROM and the decoder line by line, the tables are exact
   (note table within 0.852 of the equal-tempered period for MIDI 36 + index), and the existing mGBA traces agree with the decode on 11 further points (54 instrument records read = the 54 selected, byte 5 read only for the 10 per-note records, 0 of 99 unreachable bytes read, 0 of 344 extra-header bytes read).

## Method (all static; no emulation)

* Private copy of the tree (`rsync` without `.git`, `traces`, `build`, `.cache`), `make` -> `SHA-256 OK` / `RESULT: IDENTICAL`, `make sym-check` OK before any experiment.
* Code: `audio/engine.asm` (04:4000-5044) and the ROM0 stubs `home/audio.asm` were read in full; the bytes of `SoundDrv_InitTrackRuntime` were disassembled again from the ROM with `tools/sm83.py` (used as a tool only).
* Execution evidence: `analysis/coverage_union.tsv` (union of the 64 existing mGBA scenarios) per routine, `analysis/audio2_verify/cov_labels.py`.  Rule applied (as in the earlier passes,
  `naming2_verify_g1_home.md`): CONFIRMED needs a demonstration, code that never ran in the 64 scenarios is capped at PROBABLE; the evidence "tools/audio_driver_check.py" is the author's own
  interpreter and is not counted as independent.
* Data: `analysis/audio2_verify/decode_streams.py` is a new stream decoder written from the driver code (not from `tools/audio_to_macros.py`); `usage_counts.py`, `coverage_check.py`,
  `macro_files_check.py`, `names_check.py`, `callers_ids.py` build on it.  Tables: `tables_check.py` (V2.4).
* Callers: `grep`/`callers_ids.py` over the `.asm` tree.

## V2.1  Names (`analysis/naming2/audio2_renames.tsv`)

Rows: 252 = 42 driver rows (40 applied; the 2 HYPOTHESIS rows `Label_04_49B6` / `Label_04_49CD` keep their neutral names) + 210 generated `SoundSongNN_*` rows.  Prefix rule (`SoundDrv_` only in the bank-04
driver body): all 125 `SoundDrv_*` / `Table_SoundDrv_*` symbols of `build/mobile_trainer.sym` are in bank 04, none in ROM0 (the ROM0 helpers are `Sound_*` / `Bank4_*`): UPHELD.  No polarity inversion, no swapped twins and
no name collision was found (the `Hi`/`Lo` nibble twins, `Set`/`Clear`-style pairs, `Sfx`/`Music` service pair and the `ExtSetInstrByte0..4` series were each re-traced against the code and the command tables, see the table).

| verdict | rows |
|---|---|
| name upheld, status upheld | 24 driver rows (17 CONFIRMED, 7 PROBABLE) |
| name upheld, status lowered CONFIRMED -> PROBABLE (code never executed in the 64 scenarios) | 15 driver rows |
| name corrected (behaviour unchanged) | 1 driver row (`SoundDrv_StopChannelTrackEnded`) |
| 210 generated rows: mechanical derivation equal | 210 of 210; of these 75 (the 30 sound-effect records) get the prefix `SoundSfx` instead of `SoundSong`, and `Data_SoundDrv_Streams` is renamed `SoundSong01_Track0` (2 + 75 rows in `verify_audio2_fixes.tsv`) |
| HYPOTHESIS rows (not applied) | 2, nothing to apply; the idea `SoundDrv_CmdStoreTrack1E` for `$CA` stays correctly neutral, see the note on `+$1E` in V2.2 |

### The 40 applied driver rows (re-read at the label; entry count x scenarios from `analysis/coverage_union.tsv`, `analysis/audio2_verify/driver_rows_table.py`)

| name (04:addr) | executed | manifest | verifier | what the code does (re-derived) |
|---|---|---|---|---|
| `SoundDrv_CmdWait` (4756) | 1.1M x62 | CONFIRMED | UPHELD | `$80`: `add a,$31 / jp z` = no-op; else counter `Table[opcode-$80]-1` to track+1, stream pointer to +2/+3, falls into `SoundDrv_TickVibrato`; the old name `CmdRest` was wrong, a note never comes here |
| `SoundDrv_TickVibrato` (45E6) | 9.5M x62 | CONFIRMED | UPHELD | delay counter +`$2B` (phase forced to `$40` = centre while it runs), phase +`$20` += rate +`$1F`, triangle (`sla a / cpl` on carry), `(hi(tri*depth) - depth/2)*8` as 16 bit to +`$24/$25`, then falls into `SoundDrv_ComputeTrackOutput` |
| `SoundDrv_CmdSetPitchAdd` (483A) | 79k x63 | CONFIRMED | UPHELD | `bc=$12 / jp CmdStoreTrackByte`; +`$12` is added to the pitch in `StartNote` (4A88) and `CmdNoteOff` (4B84) |
| `SoundDrv_ParamPitchOffset` (4840) | never | CONFIRMED | status -> PROBABLE | sets bit 2 of `wRam_D03C`, word `D038/D039` to +`$13/$14` of the selected tracks (`SetTrackFieldWord`); `ComputeTrackOutput` adds it into +`$2C/$2D`.  Entry 1 of `Table_SoundDrv_ParamHandlers`; `SoundDrv_SetTrackParam` has no caller |
| `SoundDrv_CmdPitchBend` (4896) | 302k x61 | CONFIRMED | UPHELD | +`$19` = `rlca - $80`; product via `PitchBendProduct`; formula note in V2.2 |
| `SoundDrv_PitchBendProduct` (48AD) | 323k x61 | CONFIRMED | UPHELD | `sla b`; positive: `HL = b*c`; negative: `HL = ~b*c`, `BC = -HL` (`dec hl / cpl / cpl`); result to +`$1B/$1C`, flag bit 2; shared by `$C1`/`$C2` |
| `SoundDrv_CmdPitchBendScale` (48D5) | 21k x61 | CONFIRMED | UPHELD | +`$1A` = byte, reloads b = +`$19`, jumps to the product |
| `SoundDrv_CmdVibratoRate` (48EC) | 5k x61 | CONFIRMED | UPHELD | +`$1F` = byte; `sla a / jr nz`; for `$00`/`$80`: `ccf / rra / rra` presets +`$20` = `$40`/`$00` (this 4-instruction branch never ran) |
| `SoundDrv_ParamVibratoRate` (4908) | never | CONFIRMED | status -> PROBABLE | same two cases through `SetTrackFieldByte` (+`$1F`) / `SetTrackFieldWord` (+`$1F/$20` = `($00,$40)` or `($80,$00)`) |
| `SoundDrv_CmdVibratoDelay` (4925) | 4.6k x61 | CONFIRMED | UPHELD | `bc=$2A / jr CmdStoreTrackByte`; `StartNote` copies +`$2A` to +`$2B` (4A93-4A94) |
| `SoundDrv_CmdPan` (4955) | never | CONFIRMED | status -> PROBABLE | flag bit 0 (`wRam_D019` = `wSoundDrv_UpdateFlags`), `bc=$17`, `CmdStoreTrackSigned`; `ComputeTrackOutput` +`$2E` = +`$17` + +`$18`; `WriteChannelPan` (4F4F-4F96): masks `$EE/$DD/$BB/$77` with bits `$11/$22/$44/$88` per channel, bit 7 of +`$2E` and bit 6 pick `AND $F0` (left only) / `AND $0F` (right only) / both: value `$00-$1F` left, `$20-$5F` both, `$60-$7F` right (re-derived, matches the macro comment) |
| `SoundDrv_ParamPanOffset` (4962) | never | CONFIRMED | status -> PROBABLE | bit 0 into `D03C`, `bc=$18`, `SetTrackFieldByte` |
| `SoundDrv_CmdVibratoDepth` (4970) | 5k x61 | CONFIRMED | UPHELD | `bc=$21`, falls into `CmdStoreTrackByte` |
| `SoundDrv_CmdStoreTrackByte` (4973) | 89k x63 | CONFIRMED | UPHELD | `[track+bc] = stream byte; inc de`; users `$BD $C4 $C5 $C6 $CA` and `$CD` 1, 6, 7, 10, 11 (all 9 referrers re-listed) |
| `SoundDrv_CmdVibratoDisable` (4984) | never | CONFIRMED | status -> PROBABLE | `or $07` to the flag byte, `bc=$23`, store; polarity right (non-zero = vibrato left out: `ComputeTrackOutput` tests +`$23`, `TickVibrato` then skips the +`$24/$25` update but keeps advancing the phase) |
| `SoundDrv_ParamVibratoDepth` (4991) | never | CONFIRMED | status -> PROBABLE | writes +`$22`, the second addend of the depth (`ld a,[hli] ; add a,[hl]` at 460A-460B), not the field of `$C5` (+`$21`): the name is accurate but twin-like with `CmdVibratoDepth`; kept |
| `SoundDrv_CmdDetune` (4997) | never | CONFIRMED | status -> PROBABLE | bit 2, `bc=$1D`, falls into `CmdStoreTrackSigned`; `ComputeTrackOutput` adds the sign-extended `2*(+$1D)`: `(v-$40)/64` semitones exactly (no asymmetry here) |
| `SoundDrv_CmdStoreTrackSigned` (49A2) | never | CONFIRMED | status -> PROBABLE | `[track+bc] = rlca(stream byte) - $80`; referrers: `CmdPan` (jr), `CmdDetune` (fall-through) |
| `SoundDrv_ExtSetTrack27` / `Track28` (49C3 / 49C8) | never | PROBABLE | UPHELD | `$CD` 6 / 7 into +`$27` / +`$28` (`Table_SoundDrv_ExtCommands` entries 6, 7); read at 4D66 / 4D68 (not 4D67 / 4D69) |
| `SoundDrv_ExtSetInstrByte0 / Byte1 / Byte2` (49D3 / 49D8 / 49DD) | never | CONFIRMED / CONFIRMED / PROBABLE | UPHELD, first two -> PROBABLE | `$CD` 1 / 10 / 11 into +`$0C` / +`$0D` / +`$0E` (table order 1, 10, 11 re-read) |
| `SoundDrv_ExtSetInstrByte3Hi / 3Lo / 4Hi / 4Lo` (49E2 / 49FF / 4A1A / 4A1F) and `SoundDrv_StoreHighNibble` / `StoreLowNibble` (49E5 / 4A02) | never | CONFIRMED / CONFIRMED / PROBABLE / PROBABLE; helpers CONFIRMED | UPHELD, 3Hi, 3Lo and both helpers -> PROBABLE | `$CD` 2, 3, 4, 5 -> +`$0F` high / low nibble, +`$10` high / low; `StoreHighNibble` = `swap a / and $F0` of the stream byte or-ed over the old low nibble, `StoreLowNibble` = `and $0F` over the old high nibble: polarity of every `Hi`/`Lo` pair correct |
| `SoundDrv_CmdUnassigned` (4A24) | never | CONFIRMED | status -> PROBABLE | `jp SoundDrv_CmdEnd`; 8 table slots (`$B6-$B8`, `$C7`, `$C8`, `$CB`, ext 8, 9).  "Unassigned" is the reading that the slot has no function of its own; the neighbours `$B9-$BB`, `$CC` jump to `CmdEnd` directly, so the split between the two names is not explained by the code: interpretation, kept as PROBABLE |
| `SoundDrv_CmdNoteHeld` (4A27) | 37 x12 | CONFIRMED | UPHELD | `ld b,0 / jr ReadNoteBytes`; gate counter 0 is never decremented (`ServiceChannelGate` 4BF7-4BF9) |
| `SoundDrv_ReadNoteBytes` (4A36) | 917k x63 | CONFIRMED | UPHELD | classes: bit 7 stop, `>= $24` pitch (+`$09`), `< $20` volume (+`$0A` = `(v<<3) OR 7`), else adjust (+`$0B`); each class once (flag bits 7, 6, 5 of `b`); the adjust branch never ran |
| `SoundDrv_CmdNoteOff` (4B66) | 18 x7 | CONFIRMED | UPHELD (text corrected) | optional pitch byte (`>= $24`, bit 7 clear) into +`$09`, `pitch + add` compared with channel+3; releases **the first** matching channel only: after `call NoteGateExpired` (4BBB) the `jr $4BC5` (4BBE) leaves the loop; the "each channel" of the evidence text and of `audio_format.md` 5.1 is wrong |
| `SoundDrv_ServiceChannelGate` (4BEB) | 5.4M x62 | CONFIRMED | UPHELD | track flags `< $C0` -> stop; gate (channel+7) 0 -> held; `dec [hl]; ret nz`; falls into `NoteGateExpired` |
| `SoundDrv_StopChannelTrackEnded` (4C0B) | 10.9k x59 | PROBABLE | **RENAMED** `SoundDrv_StopChannelTrackNotRunning` | only referrer is 4BF4 (`jr c` after `cp $C0`) in `ServiceChannelGate`, not also `UpdateChannel` (that one does `pop hl / jr SoundDrv_StopChannel`); `flags < $C0` is true for an ended track (`CmdEnd` writes 0) but also for a paused music track (`PauseMusicCore` `res 7,[hl]` at 4443 on the four music tracks, executed 2652 = 4 x 663 times) and a restarted track (`StartTrack` writes `$A0`), so "TrackEnded" asserts a cause the code does not test |
| `SoundDrv_StopChannel` (4C0F) | 61k x63 | CONFIRMED | UPHELD | `xor a / ld [hl],a / jp SilenceChannel` (hl = channel flags) |
| `SoundDrv_LoadSustainField` (4DD3) | 465k x62 | PROBABLE | UPHELD | `hl-5`: byte 4 of the channel instrument copy `& $F0`, `hl+5`; callers 04:4CF4 and 04:4D2A, both with hl = channel+`$11` |
| `SoundDrv_ComputeTargetVolume` (4DDF) | 881k x62 | CONFIRMED | UPHELD | channel+`$10` = `(hi(track+$2F)*hi(channel+6) + $0F) & $F0` |
| `SoundDrv_ComputeSustainVolume` (4E04) | 881k x62 | CONFIRMED | UPHELD | channel+`$10` = `(hi(track+$2F) * hi(hi(byte4)*hi(note vol) + $0F) + $0F) & $F0` |
| `SoundDrv_WaveLevelChanged` (4E34) | 2.7M x62 | PROBABLE | UPHELD | non-wave channel (`ChannelReg != $1C`): returns; wave: sets the volume flag when `(new ^ old) & $C0` (the top two bits drive NR32's level: `sub $40 / xor $C0 / rrca` in `WriteChannelVolume` 4FC0) |

Other `SoundDrv_*` names that exist from the first naming pass and are referenced by the doc (`CmdNote`, `StartNote`, `UpdateChannel`, `WriteChannel*`, `NoteToIndex`, `LookupFrequency`, `Mul8x8`, `MulNibbles`, `Select*`, `Next*`,
`Table_SoundDrv_*`) were re-read as well: none is contradicted (e.g. `MulNibbles` = `hi(b) * hi(c)`, `Mul8x8` = `HL = B*C`, `SelectChannel1-4` = pulse 1, pulse 2, wave, noise with NRx2 = `$12 $17 $1C $21`).

### Status corrections (the source carries no per-name status; manifest rows untouched, as in the earlier verification notes)

15 rows CONFIRMED -> PROBABLE because the entry never executes in the 64 scenarios (the opcodes `$C0 $C6 $C9 $CA $CD` are not in the data, `SoundDrv_SetTrackParam` has no caller) and the cited evidence is
`tools/audio_driver_check.py` (the author's own interpreter, not an emulator trace): `ParamPitchOffset`, `ParamVibratoRate`, `CmdPan`, `ParamPanOffset`, `CmdVibratoDisable`, `ParamVibratoDepth`, `CmdDetune`,
`CmdStoreTrackSigned`, `ExtSetInstrByte0`, `ExtSetInstrByte1`, `ExtSetInstrByte3Hi`, `StoreHighNibble`, `ExtSetInstrByte3Lo`, `StoreLowNibble`, `CmdUnassigned`.  The behaviour of each was re-read from the disassembly and
agrees with its name; only the status word changes.  (The existing `[PROBABLE]` comments under these labels in `audio/engine.asm`, produced by the coverage pass, already say so.)

### Evidence-text errors (name and status unaffected)

| row | text | what the tree shows |
|---|---|---|
| `SoundDrv_StopChannelTrackEnded` | "reached by jr from ServiceChannelGate and UpdateChannel" | only `ServiceChannelGate` (04:4BF4) |
| `SoundDrv_ExtSetTrack27/28` and `audio_format.md` 5.1 | "+`$27`/+`$28` read at 04:4D67 / 04:4D69" | `ld a,[hli]` at 04:4D66 (+`$27`), `ld d,[hl]` at 04:4D68 (+`$28`); 4D67 is `ld c,a`, 4D69 `pop hl` |
| `SoundDrv_CmdNoteOff`, `audio_format.md` 5.1 | "releases each channel" | the first matching channel (loop exit 04:4BBE) |
| `SoundDrv_CmdPitchBend` | "(byte-$40)*scale/64 semitones" | exact for `v >= $40`; for `v < $40` the code gives `4(v-$40)*scale + scale` units of 1/256 semitone (V2.2) |
| `audio_format.md` 4.3, 4.2, 7, 10, 12, macros header | stale names `Label_04_4BEB`, `Function_04_4E34`, `SoundDrv_CmdRest`, "the manifest renames it", "(SoundDrv_CmdNote entry 04:4B66)" for `SoundDrv_CmdNoteOff`, "(SoundDrv_CmdNote entry 04:4A27)" for `SoundDrv_CmdNoteHeld` | renamed in the tree since b939965 |

### The 210 generated rows

`analysis/audio2_verify/names_check.py` rebuilds the expected `(old, new)` pairs from the song table and the headers (lowest id using a header, track *k* = word *k* of the header): 210 of 210 equal, none missing except
`Data_04_574D` (kept as `Data_SoundDrv_Streams`).  Two corrections follow from the evidence about what the ids are:

1. **`SoundSongNN` for the effects (75 rows).**  The ids `$29`-`$46` are sound effects: 367 call sites of `Sound_PlaySfx` load them as immediates (`analysis/audio2_verify/callers_ids.py`: `$29 $2A ... $46`, only `$37` has no immediate caller; plus two
   calls with `$48`, out of the table, both in `engine/unreferenced/page_list_prototype.asm` lines 626 and 1904), `Sound_PlayMusic` / `Sound_PlayMusicOrResume` receive only `$01`-`$1D` from every game caller, including the table-driven `Notice_PageSoundTable` (`$09 $13 $19`); only the unreferenced sound-test screen passes arbitrary ids, and the debug sound-test screen (unreferenced) labels its
   `A` button (`Sound_PlayMusic`) "MUSIC" and its `B` button (`Sound_PlaySfx`) "SOUND" in its own help string.  `audio_format.md` itself counts "13 songs + 16 songs + 30 sound effects".  A label `SoundSong29_Header` in `audio/sfx.asm` therefore contradicts the evidence
   the project already has; `SoundSfxNN_Header` / `SoundSfxNN_TrackK` for the 30 effect records is the honest family name (PROBABLE: classification by callers, not by execution of each id).  `Table_SoundDrv_Songs`, `sound_song` and `SoundDrv_LoadSongHeader` are the driver's generic record
   names (the same code loads both kinds) and are left as they are.  Follow-up for the coordinator if the rows are applied: `tools/audio_to_macros.py` lines 611, 860, 867 and the text of `audio_format.md` sections 10 and 12 use the prefix `SoundSong`.
2. **`Data_SoundDrv_Streams` -> `SoundSong01_Track0`.**  The label is on 04:574D = word 0 of the header of song `$01`; it names the whole stream area although it is one track, and it is the only track start of the family without the `SoundSongNN_TrackK` form
   (the converter already ignores it: `tools/audio_to_macros.py:613`).

Not changed (noted): the music ids `$01`-`$1D` are named by id only; the 11 ids `$1E`-`$28` repeat song `$01` and no code calls them (only the unreferenced sound-test screen can request any 16-bit id): the open question of section 11 can be answered "not reachable in normal play".

## V2.2  Command semantics and the track record (`audio_format.md` sections 4.1-4.3, 5.1-5.3)

Method: the driver (04:4000-5044) was re-read from the first instruction; every `ld bc,$00xx / $FFxx` offset of `audio/engine.asm` (about 120 immediates) was listed and traced to the field it reaches (`ld bc` after `add hl,bc` chains from
track+0), so a field with "no reader" was searched for in every access path; the ROM bytes of `SoundDrv_InitTrackRuntime` were disassembled again; the pitch-bend arithmetic was transcribed (`bend_formula.py`, 12 instructions, a hand model
and not an emulation).  Statuses follow the rule of V2.1.

### Section 4.1-4.3 (reading a command, notes)

| claim | verdict | evidence |
|---|---|---|
| `ReadNextCommand`: `Bank4_ReadStreamWord` gives C = byte, B = next byte, DE = address + 1; bit 7 set: opcode and prefetched argument, opcodes `>= $BE` stored in track+`$11`; bit 7 clear: opcode = track+`$11`, `dec de` | UPHELD | 04:459B-45C5; `Bank4_ReadStreamWord` (00:216F) does `inc de` once between the two reads |
| dispatch `>= $D0` note, `< $B1` wait, else `Table_SoundDrv_Commands[opcode-$B1]` (31 words); `$80` no-op | UPHELD | `add a,$31 / jp z` = `$80` only; `add a,$44 / adc a,$50` = `$5044 + opcode - $80` |
| the 11 end opcodes, 8 of them through `CmdUnassigned` | UPHELD | table 04:46E8: `$B6-$B8 $C7 $C8 $CB` -> `CmdUnassigned`, `$B1 $B9-$BB $CC` -> `CmdEnd` directly |
| `$B3` call: depth +2, limit 5 nested calls, stack words at track+`$30`+depth (`$32`-`$3B`); `$B4` pops, empty stack = no-op | UPHELD | 04:4777-47C4: `cp $0A / jp nc,CmdEnd`; store at `+$26+depth+$0A`; `CmdReturn` reads `+$26+newdepth+$0C` (same words) |
| `$B5` counted loop semantics | UPHELD (code reading; never executed: status PROBABLE, the doc says "CONFIRMED by synthetic streams") | 04:47C5-47E2: count 0 -> `jr z,CmdJump`; else `inc [hl] / cp [hl] / jr nz,CmdJump`, equal: clear, skip the word |
| `$BC` tempo: group selected by `wBank4State` bit 5, step = tempo*scale/64 (min 1, max `$FF`); one tick per frame at tempo `$4A`, scale `$40` | UPHELD | `SfxTickLoop` (04:40AC) / `MusicTickLoop` run while the 16-bit accumulator >= `$4A`; each frame adds the step |
| `$BD` pitch add, `$BE` instrument copy of 5 bytes to track+`$0C`, `$64` sets flag bit 4 and any other id clears it, per-note mode takes record `pitch+add+$40` and byte 5 | UPHELD | 04:484E-4888, 04:4AA0-4ABD |
| `$BF`: track+`$15` = `rlca(byte)`, flag bit 1 | UPHELD | 04:492A-4946 |
| `$CD`: 2 operands, sub >= `$0C` or 0, 8, 9 end the track, otherwise the table of 12 words | UPHELD | 04:473E-4754: `cp $0C / jp nc,CmdEnd`; the argument is read at DE after the sub byte, the handler's single `inc de` consumes it |
| notes: classes by value (`>= $24` pitch, `< $20` volume `(v<<3) OR 7`, `$20-$23` adjust added to the duration), each class once, a repeated class ends the note without consuming the byte (it is then read as a data byte = running status), duration from `Table[opcode-$CF]` or 0 for `$CE` | UPHELD | 04:4A27-4A80 |
| in the data: pitch always before volume | UPHELD | 2311 of 2311 notes with both bytes have the pitch byte first |
| gate time: the counter channel+7 is decremented once per tick by `ServiceChannelGate`, 0 = held, expiry sets state `01` + bit 6; the track step runs after the channel service in the tick, so a note of *d* ticks is released at tick *d* | UPHELD | 04:4BEB-4C0A; order of the loops in 04:40AC-40CF |
| `+$12` is added at note start and in `$CF` | UPHELD | `StartNote` 04:4A88, `CmdNoteOff` 04:4B84 |

### Section 5.1 (commands `$C0`-`$CF`)

| opcode | claim | verdict |
|---|---|---|
| `$C0` | +`$17` = `2v-$80`, +`$2E` = +`$17`+`$18`, NR51 left only `$00-$1F`, both `$20-$5F`, right only `$60-$7F`, never used | UPHELD; status PROBABLE (never executed; the exact formula is `rlca(v) - $80`, equal to `2v-$80` only for `v < $80`, the macro range) |
| `$C1` | +`$19` = `2v-$80`, +`$1B/$1C` = `2*(+$19)*+$1A` signed, pitch offset `(v-$40)*scale/64` semitones | **CORRECTED**: exact only for `v >= $40`.  The negative branch (04:48B9-48C5) multiplies `~(2n & $FF)`, i.e. `2*abs(n)-1`, and negates, so for `v < $40` the product is `4(v-$40)*scale + scale` (units 1/256 semitone): e.g. `v=$00`, scale 2: -510, not -512; at the largest scale of the data (`$30`) the offset is 48/256 semitone = 18.75 cents too high.  `bend_formula.py` checks all 8192 pairs `v,scale < $80`: positive side exact, negative side always `+scale`.  The data has 550 uses with `v` from `$00` to `$7C`; the error is inaudible at scale 2 (0.8 cent) but is a property of the code |
| `$C2` | +`$1A` (2 at start), recomputes the product | UPHELD |
| `$C3` | +`$1F` (`$17` at start); `$00`/`$80` preset the phase to `$40`/`$00` | UPHELD (the preset branch itself never ran: PROBABLE for that sentence) |
| `$C4` | +`$2A`, copied to +`$2B` at each note start, phase held | UPHELD; "held" = the phase is forced to `$40` (centre of the triangle, zero deviation) and the LFO starts again from there when +`$2B` reaches 0 |
| `$C5` | +`$21`; depth = +`$21` + +`$22`; peak-to-peak depth*8/256 semitones | UPHELD (`(hi(tri*depth) - depth/2)*8` spans +/-4*depth units of 1/256 semitone) |
| `$C6` | +`$23`, flag bits 0-2, non-zero leaves the term out | UPHELD, status PROBABLE; refinement: the phase +`$20` keeps running, only the +`$24/$25` update and the sum skip the term |
| `$C9` | +`$1D` = `2v-$80`, bit 2, `(v-$40)/64` semitones | UPHELD (exact, `2*(+$1D)` sign-extended: no asymmetry), status PROBABLE |
| `$CA` | +`$1E`, bit 2, nothing reads +`$1E` | UPHELD as a code fact: the only `ld bc,$001E` is at 04:49B6; no `$FFxx` chain, no block copy or scan of a track record exists in the driver (`SoundDrv_Init` clears only byte 0 of each record, `ChannelPhase` only byte 0), and no code outside the driver is known to address the driver's bank-1 WRAM (the sound-test screen only calls the stubs; the other 211 operand sites in `$D040-$D27F` found by `wram_range_users.py` are screen buffers, e.g. the BG map staging buffers `$D000-$D7FF`, used with the screen's own WRAM bank; not checked site by site) |
| `$CD` | sub 1,10,11 -> +`$0C/$0D/$0E`; 2,3 high/low nibble of +`$0F`; 4,5 of +`$10`; 6,7 -> +`$27/$28`; 0,8,9,>=12 end | UPHELD; the doc's "CONFIRMED on the running driver" is the author's interpreter and the opcode is not in the data: PROBABLE |
| `$CF` | optional pitch byte to +`$09`; releases **each** channel of the track with `pitch+add` and gate 0 | **CORRECTED**: the first matching channel only (loop exit 04:4BBE after the first `NoteGateExpired`); executed 18 times in the ROM, always with the bare form |

`+$27/+$28` (HYPOTHESIS "a tail after the note"): re-read at 04:4D54-4D87.  When a note's envelope has ended (`.l4D54`), if +`$2F` (track volume out), +`$27` and +`$28` are all non-zero the channel gets NRx2 = `(hi(+$2F)*hi(+$27))` rounded up
(period 0), its age counter channel+`$12` := +`$28`, and the state bits are cleared (`and $8F`: state `00`).  In state `00` the only code is 04:4D89-4D8E: `dec [channel+$12]; jr nz` (stop when 0).  But `SoundDrv_UpdateChannel` adds 1 to that same counter
on every tick (2 on every 15th) before the state dispatch (04:4C3F-4C4A, every state with bit 6 clear), so in state `00` its net change per tick is 0 (or +1): **the counter cannot count down to 0**; the channel keeps the tail volume until
the track stops or the channel is taken over (the only exit by itself is the 8-bit wrap after (256-d)*15 ticks).  This agrees with the author's observation that the channel "was not silenced before the track ended" and means "+`$28` = tail length in ticks" is not what the code does.
Suggested wording (WITHDRAWN, see the erratum under Status): HYPOTHESIS (unchanged status): +`$27` is a tail volume factor and +`$28` only has to be non-zero.  Neither the state-`00` branch (04:4C5C, 4D72-4D8E) nor +`$27/$28` is executed in the 64 scenarios.

### Section 5.2 (per-tick chain) and the `Param` handlers

UPHELD line by line: `StepTrack` (wait running -> `TickVibrato`), `ComputeTrackOutput` sums (`+$2C/$2D` = sign-extended `2*(+$1D)` + `+$1B/$1C` + `+$13/$14` + `+$24/$25` unless `+$23`; `+$2E` = `+$17`+`+$18`; `+$2F` = `MulNibbles(+$15,+$16)+$0F & $F0`, `>= $40` -> `$FF`, else `rlca rlca`),
flag write-back at 04:46E6, `ChannelPhase` clearing bits 0-2 each frame (`and $F8`), `WriteChannelPitch` (period = table[index + high byte] + ceil(step*low/256) through `Mul8x8`, `+255` and `h`; wave channel +`$0C` = one octave because the wave channel plays half the pulse
frequency for the same period), `Table_SoundDrv_ParamHandlers` (7 words: tempo scale, +`$13/$14`, +`$16`, +`$18`, +`$22`, +`$1F`, +`$27/$28`) and the mask building (`D03B & $0F` = SFX tracks, `D03A` swapped = music tracks).  `UpdateFade` lowers +`$16` by 4 every
`FadeSpeed` ticks from `$40` and pauses the music at the end.

### Section 5.3 (track record of `$3C` bytes)

| row | verdict |
|---|---|
| +0 flags: bit 7 active, bit 6 initialised, bit 4 per-note mode, bits 0-2 changed | UPHELD, **incomplete**: `StartTrack` stores `$A0`, so bit 5 is set until `InitTrackRuntime` writes `$C0`; `ResumeMusic` (04:42EC) restarts the tracks with `flags & $60 != 0` (bit 5 or 6 = not ended), `PauseMusicCore` clears bit 7 only |
| +1 .. +`$0B` (counter, stream, bank, id, priority, pitch, note volume, duration), +`$11`, +`$12`..+`$2F` initial values and readers/writers | UPHELD (each initial value re-read in the ROM bytes 04:438B-43DB) |
| +`$0C`..+`$10` initial `0, 0, FF, FF, 0` | **CORRECTED**: `0, 0, 0, $FF, $FF`.  ROM 04:43A2-43AD: `xor a` then six `ld [hli],a` from +`$09` clear +`$09..+$0E` (pitch, note volume, duration, instrument bytes 0-2), then two `$FF` store +`$0F`, +`$10` (bytes 3, 4), then four zeros +`$11..+$14`.  This matters: two effects, `SoundSong2A_Track0` and `SoundSong2B_Track0` (05:632E, 05:634E; ids `$2A`, `$2B`), play their first note before any `sound_instrument`, so they use this default record = pulse 1, duty 0, no length, no sweep, no attack, no decay, sustain `F`, no release |
| +`$1E` | UPHELD (see `$CA`) |
| +`$27/$28` readers | UPHELD, read at 04:4D66 / 04:4D68 (text says 4D67) |
| +`$26` depth 2 per call; +`$29` loop counter | UPHELD |
| +`$30` `$FF` init, +`$31` not initialised, +`$32`-`$3B` stack | UPHELD: the stack formula `+$30+depth` with depth 2..10 never touches +`$30/$31`, so they are padding; nothing else reads them |
| ROM-wide: no other reader | UPHELD for the driver and the ROM0 stubs (every access path enumerated); NOT VERIFIED for the other banks: 211 operand sites in `$D040-$D27F` exist outside `audio/` (BG map staging buffers and similar, with the screen's own WRAM bank), a per-site check of the active `rSVBK` was not done.  The six sites that use the exact address of +`$1E`, +`$30` or +`$31` of some record (`$D05E`.., `$D070`.., `$D071`..) are tilemap destinations (`help_menu.asm:432, 705`, `result_page.asm:383`, `register_config.asm:237`, `delete_registration.asm:489`, `mail_session_screen.asm:762`: arguments of `Tilemap_CopyRectAndAttr*` / `Tilemap_FillAscendingWithAttr`, offsets `row*32+col` from `$D000`), not reads of track records |

### Sections 6-7 (instrument bytes, envelope)

UPHELD in structure: byte 0 classes (`cp $10 / $08 / $40` in `StartNote`), byte 1 length, byte 2 NR10, byte 5, records `$64-$6F` per note, attack = `~b7b6b5` (`swap / cpl / rrca / and 7`, 04:4C7F-4C83), decay = `~b3b2b1` (04:4CED-4CF0), release = `~b3b2b1` of byte 4 (04:4C9F-4CA2),
sustain = high nibble of byte 4 with the two-step ceil product, the software mirror (channel+`$11`) stepped every `period` ticks with the 16/15 correction of `TickDivider`, wave level = top two bits (`WriteChannelVolume` 04:4FC0).  Two precisions:

* **Attack evidence (section 7 table and section 1)**: the attack row rests on record `$68` (a noise drum, "NR42 `$09`") and "the other 79 simulated records have none".  The data never selects `$68` (per-note pitches used: `$24-$27 $29 $2A $2C-$2F`, `instrument_usage.py`).  The only record the data uses
  with an attack (attack 2) is the **wave** record `$4B` (pattern 0), selected once, by the effect `SoundSong42_Track0` (`BE $4B` at 05:675B, id `$42`): the attack start (04:4C87-4C8C, executed 12 times) and the attack stepping (04:4CAE-4CCF, 204 times, 106 steps) did execute in the real scenarios, so the state machine is demonstrated by the ROM runs, but on the wave channel, whose
  volume path the doc calls "PROBABLE, not simulated".  Status: attack code CONFIRMED executed (wave channel), pulse/noise attack PROBABLE (never selected by the data).
* The state-`00` / tail branch is never executed (see above).  Byte 3 bits 4 and 0, byte 4 bit 0: no reader found, statistics 88 / 88 / 109 of 112 records set.

## V2.3  Independent decoder: result

`decode_streams.py` follows `SoundDrv_LoadSongHeader` (record of id *n* at 04:$5515 + 8n, ids 1..$46), the header words, and `SoundDrv_ReadNextCommand` (running status for a data byte,
opcode >= `$BE` stored, dispatch `>= $D0` note / `< $B1` wait / table) with jump, call (depth limit 5), return and `$B5` both ways, from every set-0 pointer.

| claim of `audio_format.md` | recount | verdict |
|---|---|---|
| 70 song records, 59 distinct headers, 152 tracks, 152 distinct stream starts | 70 / 59 / 152 / 152 | UPHELD |
| header = 2 bytes + `count` words (+ 2 more sets when byte 1 = 2); byte 0 = track count in all 59; byte 1 = 0 (37) or 2 (22) | exactly that (sizes 4 x19, 6 x11, 8 x3, 10 x4, 20 x2, 26 x20 = 766 bytes) | UPHELD |
| record fields: priority `$C8` x67, `$D2` x2 (ids `$30`,`$31`), `$C9` x1 (`$35`), flags `$FF` x70, spare `$00` x70, counts 4 x35, 1 x19, 2 x11, 3 x5 | recomputed from the ROM | UPHELD |
| 11 916 commands, 19 716 bytes | 11 823 reachable + 93 behind a track's final jump = 11 916; 19 716 bytes | UPHELD |
| the ranges 04:574D-7E8C and 05:4000-68C3 are covered completely, no overlap, no ambiguous decoding | 20 482 bytes = 19 716 command bytes + 766 header bytes, 0 gaps, 0 overlaps, 0 addresses decoded two ways (all running-status contexts agree) | UPHELD |
| the 93 unreachable commands = 86 `$B1` + 7 in three codas | 86 gaps of 1 x83, 2, 3, 11 bytes; kinds: 86 `$B1`, 3 waits, 2 notes, 1 `$CF`, 1 one-byte command | UPHELD |
| set 1 = the target of the track's final `$B2`, set 2 = the address right behind it, in all 86 tracks of the 22 extra-set headers; loop point = start + 4 in 79 | final jump found right before the set-2 word and its operand = set-1 word in 86/86; `start + 4` in 79/86 | UPHELD |
| 66 tracks end in a reached `$B1`, 86 loop through a backward `$B2`, none both | 66 / 86 / 0 / 0 (neither) | UPHELD |
| usage: wait 4871, note 4325 (1241 by running status), `$BE` 1110 (6), `$C1` 550 (101), `$B3` 276, `$BF` 152, `$BD` 152, `$B4` 113, `$B2` 86, `$B1` 152, `$BC` 59, `$C2` 19, `$C5` 18, `$C3` 17, `$C4` 14, `$CF` 2; never `$B5 $C0 $C6 $C9 $CA $CD` | identical counts; `$80` (no-op wait) never used | UPHELD |
| notes: 2311 pitch+vol, 1381 pitch, 329 vol only, 304 bare; no adjust byte | identical (two of the notes are `$CE`, duration 0) | UPHELD |
| all 152 tracks start `BF $7F BD vv`, `BD` only there (`$00` x145, `$F4` x7) | identical | UPHELD |
| `$BE $64` x27, 45 distinct `$BE` operands (max `$64`) | identical | UPHELD |
| operand statistics: `$C1` 37 values (`$40` x232, `$28` x113, `$20` x89), `$C2` 8 values (`$0C`, `$30` x6), `$C3` 8 (`$20` x6, `$40` x4), `$C4` 9, `$C5` 7 (max `$48`), note volumes 30 values 0-`$1F`, `$BC` 18 values (`$4A` x33) | identical; every `$C1` operand is < `$80` (max `$7C`), which matters for the `2v - $80` formula (see V2.2) | UPHELD |
| `$CF` used twice: bare in a reachable track (05:5E31, song `$1A`), with pitch `$42` in an unreachable coda (05:4766, song `$11`) | identical | UPHELD |
| every macro line of `audio/music/*.asm`, `audio/sfx.asm` (12 078 lines, 30 files) re-assembled by `macro_files_check.py` equals the ROM bytes; 535 label address comments equal the running counter; 11 916 macro commands = 11 916 decoded commands, kind/size/running-status identical; 70 `sound_song` lines = the 70 ROM records | 0 problems | UPHELD |

Names (V2.1, mechanical part): all 210 generated rows `Data_BB_AAAA -> SoundSongNN_Header / SoundSongNN_TrackK` equal the independent derivation (header label = lowest id whose record uses the
header; track *k* = *k*-th set-0 word; only `Data_04_574D` is left out on purpose, it keeps `Data_SoundDrv_Streams`); the only header shared by several ids is 04:58BC (ids `$01`, `$1E`-`$28`).

## V2.4  Tables and instruments (own script `analysis/audio2_verify/tables_check.py`, bytes read from the ROM)

| claim | recount | verdict |
|---|---|---|
| `Table_SoundDrv_Durations` 04:5044, 49 bytes `00..18` step 1 then `1C 1E 20 24 28 2A 2C 30 34 36 38 3C 40 42 44 48 4C 4E 50 54 58 5A 5C 60`; wait = `$80 + index` (`$80`-`$B0`), note = `$CF + index` (`$D0`-`$FF`) | identical, strictly increasing; the code arithmetic `add a,$31 / add a,$44 / adc a,$50` (wait) and `sub $CF / add $44` (note) gives exactly `$5044 + opcode - $80` and `$5044 + opcode - $CF` (re-derived by hand from 04:4756-4760 and 04:4A2B-4A35) | UPHELD |
| `Table_SoundDrv_NoteFreq` 04:5075, 120 x (`dw period`, `db step`); ends at 04:51DD | identical sizes; periods < 2048 | UPHELD |
| every period is within 1 of `2048 - 131072/f`, `f` = equal-tempered frequency of MIDI note `36 + index`, A4 = 440 | max error 0.852 (record 76); rounded error histogram 0: 114, -1: 5, +1: 1; the only offset that fits is 36 (120/120, next best 38 with 38/120) | UPHELD (so pitch byte = MIDI number, `$24` = C2, `$3C` = C4, record 33 = 439.84 Hz) |
| step = next period - this period, within 1 | `step - (next - this)`: 0 x76, -1 x35, +1 x8 over records 0-118 | UPHELD |
| record 119 "saturates at 2046" | the record is `$07FE` = 2046, and the exact value `2048 - 131072/f` for MIDI 155 is 2045.93; the periods of records >= 89 are non-strictly increasing (repeats of `$07F4..$07FE`) because one semitone moves the period by less than one unit there | UPHELD for the numbers, wording CORRECTED: it is the exact rounding at the top of the scale (11-bit maximum is 2047), not a clamp.  Harmless: pitch bytes in the data stop at `$7F` (index 91) |
| 112 instrument records of 6 bytes 04:51DD-547D | exact size | UPHELD |
| class distribution pulse 1 11, pulse 2 63, wave 20, noise 18; byte 1 and 2 `$00` in all 112; wave patterns used 0, 1, 3, 4, 5, 7, 8, 9; byte 5 `$3C` in the 100 ordinary records | identical (wave pattern counts 0:4 1:2 3:1 4:2 5:2 7:4 8:3 9:2) | UPHELD |
| envelope field decode shown in the per-record comments of `audio/instruments.asm` (attack = bits 7-5 of byte 3 inverted, decay = bits 3-1 inverted, sustain = high nibble of byte 4, release = bits 3-1 of byte 4 inverted) | the code at 04:4C5F-4C8E (`swap / cpl / rrca / and 7` gives ~b7b6b5 for the attack; `cpl / rrca / and 7` gives ~b3b2b1 for decay and release) re-read: the decode in the comments is the code's.  Records with an attack: only `$4B` (attack 2) and `$68` (attack 1); `$4B` is one of the 20 wave records, which the doc's 80 simulated (pulse/noise) records exclude (see V2.2) | UPHELD (structure) |
| byte 3 bits 4 and 0 and byte 4 bit 0 "not read by any path" | no code path of 04:4C14-4DD2 tests them; the bits are set in 88 / 88 / 109 of the 112 records (compatible with "unused bits stored as 1", as the inverted fields are) | UPHELD as HYPOTHESIS (no reader), the "CONFIRMED (80 records simulated)" of section 7 does not extend to these bits |
| wave patterns `Table_SoundDrv_WavePatterns` 04:547D, 10 x 16 bytes, high nibble first (Pan Docs: the upper nibble of a wave RAM byte plays first) | pattern 0 fits a sine to 0.5 sample level; 1 is an exact triangle (0..F..0); 2 an exact falling ramp (each level twice); 3 falls with plateaus at 8 and 7; 4-7 are two-level pulses with exactly 4, 8, 12, 16 high samples of 32; 8 deviates from the best sine by 2.8 levels; 9 has five levels (`0 4 8 B F`, plateaus of 7 to 14 samples) | UPHELD for 0-7; the description of 8 ("smooth single-peak") is acceptable; the description of 9 is CORRECTED to "five-level stepped bump with plateaus at `8` and `F`", not smooth.  All shape words stay interpretation of the samples (PROBABLE), only the copy to `$FF30-$FF3F` is code-proven |

## V2.5  Text and macros

| item | verdict |
|---|---|
| Mechanical comments: 120 note rows (`; pitch $XX C#3`...) re-derived from the pitch byte (`NAMES[p % 12] + (p / 12 - 1)`) and the ROM bytes of the record; 112 instrument comments (class, `attack/decay/sustain/release` decoded from bytes 3-4, per-note id = pitch + `$40`); 10 wave comments | UPHELD, 0 problems (`table_comments_check.py`) |
| File header lines `; bank BB, $AAAA-$ZZZZ (N bytes)` of all 6 + 29 audio files vs the section extents of `build/mobile_trainer.map`; `; song id NN` vs the header label inside each file; each music file ends exactly with its header | UPHELD, 0 mismatches (`file_headers_check.py`) |
| "the 333 labels that were missing" (first pass) and "7 labels removed, unreferenced" (second pass) | UPHELD: `git` (read-only) shows 333 added by d9661aa and the 7 removed by 520dc88 (`Data_05_5B34 5BCB 5C9E 5D69 5F09 5FF1 68BE`) with 0 non-definition references in the parent tree |
| Section 10 example "How to add a song" (`NewSong_*`) | UPHELD: assembles with the project flags (`-Weverything -P includes.asm -E`), no warning; record 0 of the instrument table is `0B 00 00 FB 7F 3C` (pulse 2, duty 3) and pitch `$40` is E4 (`$0672` = 329.6 Hz) as the comments say |
| `audio_macros.inc` operand checks (`macro_asserts_test.sh`: 18 one-line test sources assembled) | duration not in the table, `sound_rs` on an opcode `< $BE`, nested `sound_rs`, duty > 3, wave class > `$2F`, 12-bit period, wrong argument counts: REFUSED as documented.  ACCEPTED although the driver would read something else: `sound_note d, $10` (a "pitch" `< $24` is taken as a volume byte), `sound_note d, p, $25` (a "volume" `>= $20` is taken as pitch or adjust), `sound_note d, $80` (bit 7 = an opcode), `sound_note_off $10`, `sound_instr_wave 10` (pattern 10 does not exist, the table has 0-9, the assert allows `$2F`), `sound_pan $90` and `sound_pitch_bend $90` (the `2v - $80` formulas assume `v < $80`).  Suggested hardening, no byte changes: `ASSERT (\2) >= $24 && (\2) <= $7F` for the pitch operand, `(\3) <= $1F` for the volume operand, the same pitch assert in `sound_note_off`, `<= 9` for the wave pattern, `<= $7F` for the one-byte `sound_pan / pitch_bend / detune` operands (the data satisfies all of them) |
| comment wording in `audio_macros.inc` | stale names: line 99-100 "(SoundDrv_CmdNote entry 04:4A27)" is `SoundDrv_CmdNoteHeld`, line 136 "(SoundDrv_CmdNote entry 04:4B66)" is `SoundDrv_CmdNoteOff`; line 226 "scale ... `$00-$7F` in the data" (the data uses `$04`-`$30`); line 225 the bend formula (V2.2) |
| `audio_format.md` section 12 and 4.3/7/10 text | stale names listed in V2.1; "the manifest of the second pass renames it" is past; the sentence of section 8 "record 119 saturates at 2046" (V2.4); the wave pattern 9 description; `$CF` "each channel"; 5.3 initial instrument bytes; the "CONFIRMED" statuses of constructs the data never uses (`$B5`, `$C0`, `$C6`, `$C9`, `$CD`, adjust bytes), which rest on the author's interpreter |
| source region comments of the stream files | 214 `; ---- data/words ...` comments remain in `audio/music/*.asm` and `audio/sfx.asm`, 124 of them still say "content class unknown" / "command semantics not decoded" for bytes that are now fully decoded (acknowledged in section 10 of the doc, but a reader of `audio/sfx.asm` sees `[CONFIRMED] ... content class unknown` above `sound_volume $7F`).  `audio/music_pointers.asm` still describes the record as "word $FFC8 ... word 0001-0004" and its second line says "70 headers" for 70 records (the table has 70 records pointing to 59 headers).  Mechanical cleanup suggested (`tools/audio_to_macros.py` already rewrites these files) |
| `REVERSE_ENGINEERING.md:62` "Role of bank 04 (APU init confirmed; 'sound driver' is PROBABLE at best)" | **STALE / contradicted**: `SoundDrv_FrameTick` runs 3,420,468 times in 63 scenarios, writes the APU registers of all four channels (`WriteChannel*` 0.9-1.3M executions), loads song records (`SoundDrv_LoadSongHeader` 53,887 executions) and starts tracks (`SoundDrv_StartTrack` 79,365), plays effects through `SoundDrv_PlaySfx` (46,508): the role of bank 04 is CONFIRMED (sound driver, tables and the song table).  The "open question" line should be removed or reworded |
| `REVERSE_ENGINEERING.md:38` "The format was checked by running the ROM's own driver on all 152 tracks" and "Commands named by demonstrated effect: pan (`$C0`), ..., detune" | overstated: the driver code was run in the author's own SM83 interpreter (`tools/audio_driver_check.py`), not in an emulator, and `$C0`, `$C6`, `$C9` never execute in the ROM; suggested: "re-executed in a small SM83 interpreter; commands the data never uses are named from the code (PROBABLE)" |
| `docs/README.md:94` "driver-verified (reference, current)" | same caveat (interpreter), otherwise accurate |

## Cross-check with the existing mGBA traces (read-only use of `traces/detail/*/dataaccess.tsv`, 64 scenarios; no new emulation)

The traces list the ROM bytes read as data.  `trace_reads_check.py` and `trace_table_reads.py` compare them with the independent decode (they need the trace directory as an argument; the private copy does not contain `traces/`):

| check | result |
|---|---|
| reachable command bytes read in the 64 scenarios | 19,224 of 19,617 (98 %) |
| bytes of the 93 unreachable commands (the 99 tail bytes behind final jumps) read | **0 of 99**: the doc's "no path reaches them" is consistent with the runs |
| bytes read inside the two stream ranges but outside every decoded command / header | 0 |
| ids whose first stream byte was read in some scenario | 69 of 70; never played: id `$37` (also the only effect id with no immediate `Sound_PlaySfx` caller) |
| the extra header sets (set 1 + set 2 of the 22 headers, 344 bytes) | **0 bytes read** in 64 scenarios (the only header bytes read besides the set-0 words are byte 0 of 36 headers, each directly behind a track's final `$B1`: the two-byte read of that `$B1` prefetches the next byte); supports "never read by the driver" (the meaning of the sets stays PROBABLE) |
| instrument records read as data | 54 records = exactly the 44 ids selected by `$BE` plus the 10 per-note records `$64-$67 $69 $6A $6C-$6F` of the walk (`instrument_usage.py`); none extra, none missing |
| bytes of those records read | bytes 0-4 of all 54, **byte 5 only of the 10 per-note records**: the "byte 5 is read only by the per-note mode" of section 6 is demonstrated by the ROM runs, not only by code reading |
| wave patterns read as data | 0, 1, 3, 4, 5, 7, 8, 9 = the patterns of the selected wave records |
| duration table entries read | 40 of 49 = the 39 wait values plus the note durations (union) of the decode |
| note table records read | 72 (index 0-82) |
| entries of `Table_SoundDrv_Commands` read by the dispatcher in the 64 scenarios | opcodes `$B1 $B2 $B3 $B4 $BC $BD $BE $BF $C1 $C2 $C3 $C4 $C5 $CE $CF` = exactly the opcodes the decode finds in the data; `$B5 $C0 $C6 $C9 $CA $CD` never dispatched; `Table_SoundDrv_ExtCommands`, `Table_SoundDrv_ParamHandlers` and `Table_SoundDrv_SfxTrackPtrs` never read (matches the "never executed" statuses of V2.1) |

## Corrections to apply in the repository (exact places; line numbers of the tree at 8f9b055)

### Names (executable)

```
python3 tools/apply_renames.py --manifest analysis/naming2/verify_audio2_fixes.tsv --strict      # 77 rows: block A lines 4-5, block B (effects) lines 7-81
patch -p1 < analysis/audio2_verify/audio_to_macros_sfx.patch                                    # converter: also prefers SoundSfx*, writes SoundSfx names for ids >= $29
python3 tools/audio_to_macros.py                                                                 # rewrites audio/music/music_01.asm (one token: dw Data_04_574D -> SoundSong01_Track0), rebuilds, SHA-256 + sym_check
python3 tools/audio_to_macros.py --check                                                         # exit 0
```

Tested on a private copy: the manifest alone (`--strict`): 77 applied, 0 refused, `SHA-256 OK`, `sym_check OK`, `make` RESULT: IDENTICAL; with the converter patch and one converter run `--check` exits 0 and the build is still IDENTICAL.  Block B (lines 7-81) can be dropped to keep `SoundSong`
for the effects; block A (lines 4-5) applies alone (dry run).  Without the converter patch `tools/audio_to_macros.py --check` exits 1 (3 files "not in macro form") after the manifest is applied.

### Text (no byte changes)

| file:line | change |
|---|---|
| `docs/research/audio_format.md:88, 95, 385` | `SoundDrv_CmdRest` -> `SoundDrv_CmdWait` (line 385: the rename is applied, not "renames it") |
| `:127`, `:244` | `Label_04_4BEB` -> `SoundDrv_ServiceChannelGate`; `Function_04_4E34` -> `SoundDrv_WaveLevelChanged` |
| `:18, :20-22, :100, :117, :152, :158, :159, :164-166, :223-224` | status words: `$B5`, adjust bytes, `$C0`, `$C6`, `$C9`, `$CD` 1-3/10 and instrument bytes 1-2 are PROBABLE (never executed in the ROM; the evidence is the author's interpreter) |
| `:153`, `constants/audio_macros.inc:225` | `$C1`: "exact for `v >= $40`; below `$40` the code adds `scale` units of 1/256 semitone (`4(v-$40)*scale + scale`)"; macro line 226: the scales used by the data are `$04-$30` |
| `:162` | `$CF` releases the first matching channel only |
| `:166-169`, `:206` | `+$27` / `+$28` are read at 04:4D66 / 04:4D68; add that the age counter cannot count down in state `00` (net 0 / +1 per tick), so `+$28` is not a tail length (HYPOTHESIS: `+$27` a tail volume factor) [withdrawn: see the erratum under Status] |
| `:188` | flags: add bit 5 (`$A0` from `StartTrack`; `ResumeMusic` tests `$60`) |
| `:193` | initial instrument copy `0, 0, 0, FF, FF` (two effects `$2A`, `$2B` play before any `sound_instrument`) |
| `:238`, `:243-245`, `:22` | attack: the data never selects `$68`; the only record with an attack is wave record `$4B` (effect `$42`, `BE $4B` at 05:675B), whose attack ran 12 times in the ROM scenarios; pulse/noise attack is PROBABLE |
| `:253-254` | record 119 `$07FE` is the exact rounding of `2048 - 131072/f` (2045.93), not a clamp |
| `:257` | pattern 9 is a five-level stepped bump (`0 4 8 B F`), not smooth |
| `:378` | ids `$1E`-`$28`: only the unreferenced sound-test screen can request them: not reachable in normal play |
| `:314-316, :330` and `REVERSE_ENGINEERING.md:38` | prefix `SoundSfx` for the effects if block B is applied; rewording of "checked by running the ROM's own driver" (an SM83 interpreter) and "named by demonstrated effect" |
| `REVERSE_ENGINEERING.md:62` | delete or rewrite the open question: the role of bank 04 (sound driver) is CONFIRMED (SoundDrv_FrameTick 3,420,468 executions, 63 scenarios) |
| `constants/audio_macros.inc:99-100, :136` | `(SoundDrv_CmdNote entry 04:4A27)` -> `SoundDrv_CmdNoteHeld`; `(SoundDrv_CmdNote entry 04:4B66)` -> `SoundDrv_CmdNoteOff`; optional ASSERTs listed in V2.5 |
| `audio/music_pointers.asm:3, :7` | "70 headers" -> "70 records"; the old region comment (words `$FFC8`, `0001-0004`) contradicts the macro lines below it |
| `audio/music/*.asm`, `audio/sfx.asm` | 124 of the 214 `; ---- data/words` region comments still say "content class unknown" / "command semantics not decoded" |

## Limits and what was not verified

* Static only: "never executed" means absent from the 64 existing mGBA scenarios (`coverage_union.tsv`); code reading can be wrong in the same way for the author and for me, so every statement where the two agree was cross-checked against a second, independent source where one exists
  (ROM bytes, coverage, data-access traces, a hand model of the arithmetic).  Nothing here was run on hardware or in a new emulation.
* Section 9 of the doc (the interpreter runs: 36 combinations, 80 simulated envelope records, 152-track agreement) is NOT VERIFIED here; the decoder facts it rests on were re-derived.
* The absence of readers of `+$1E`, `+$30`, `+$31` is shown for the driver and the ROM0 stubs only.  211 operand sites in `$D040-$D27F` exist in other banks (screen buffers); which WRAM bank each uses was not checked.
* The noise channel's pitch formula (04:4F2D), `StartNote`'s channel take-over rules (04:4B06-4B18) and `SoundDrv_PlaySfx`'s `flags < $80` branch (never used by the data) were read but not verified in depth.
* Shape words for the wave patterns remain interpretation of the samples; only the sine fit of pattern 0 and the exact forms of 1, 2 and 4-7 are computed.
* The `SoundSfx` prefix rests on caller classification (static immediates, 367 sites) and the sound-test text; per-id execution was not checked (ids `$29-$46` except `$37` have an immediate caller; `$37` was never played in the 64 scenarios and has none).
* Nothing was written to the real repository, to the OMM, or to the network.

