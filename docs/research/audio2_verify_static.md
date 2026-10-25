# Audio pass 2: static adversarial reference

## V2.2  Command semantics and the track record (`audio_format.md` sections 4.1-4.3, 5.1-5.3)

Method: the driver (04:4000-5044) was re-read from the first instruction; every `ld bc,$00xx / $FFxx` offset of `audio/engine.asm` (about 120 immediates) was listed and traced to the field it reaches (`ld bc` after `add hl,bc` chains from
track+0), so a field with "no reader" was searched for in every access path; the ROM bytes of `SoundDrv_InitTrackRuntime` were disassembled again; the pitch-bend arithmetic was transcribed (`bend_formula.py`, 12 instructions, a hand model
and not an emulation).  Statuses follow the rule of V2.1.

### Section 4.1-4.3 (reading a command, notes)

| claim | verdict |
| --- | --- |
| `ReadNextCommand`: `Bank4_ReadStreamWord` gives C = byte, B = next byte, DE = address + 1; bit 7 set: opcode and prefetched argument, opcodes `>= $BE` stored in track+`$11`; bit 7 clear: opcode = track+`$11`, `dec de` | UPHELD |
| dispatch `>= $D0` note, `< $B1` wait, else `Table_SoundDrv_Commands[opcode-$B1]` (31 words); `$80` no-op | UPHELD |
| the 11 end opcodes, 8 of them through `CmdUnassigned` | UPHELD |
| `$B3` call: depth +2, limit 5 nested calls, stack words at track+`$30`+depth (`$32`-`$3B`); `$B4` pops, empty stack = no-op | UPHELD |
| `$B5` counted loop semantics | UPHELD (code reading; never executed: status PROBABLE, the doc says "CONFIRMED by synthetic streams") |
| `$BC` tempo: group selected by `wBank4State` bit 5, step = tempo*scale/64 (min 1, max `$FF`); one tick per frame at tempo `$4A`, scale `$40` | UPHELD |
| `$BD` pitch add, `$BE` instrument copy of 5 bytes to track+`$0C`, `$64` sets flag bit 4 and any other id clears it, per-note mode takes record `pitch+add+$40` and byte 5 | UPHELD |
| `$BF`: track+`$15` = `rlca(byte)`, flag bit 1 | UPHELD |
| `$CD`: 2 operands, sub >= `$0C` or 0, 8, 9 end the track, otherwise the table of 12 words | UPHELD |
| notes: classes by value (`>= $24` pitch, `< $20` volume `(v<<3) OR 7`, `$20-$23` adjust added to the duration), each class once, a repeated class ends the note without consuming the byte (it is then read as a data byte = running status), duration from `Table[opcode-$CF]` or 0 for `$CE` | UPHELD |
| in the data: pitch always before volume | UPHELD |
| gate time: the counter channel+7 is decremented once per tick by `ServiceChannelGate`, 0 = held, expiry sets state `01` + bit 6; the track step runs after the channel service in the tick, so a note of *d* ticks is released at tick *d* | UPHELD |
| `+$12` is added at note start and in `$CF` | UPHELD |

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

* The absence of readers of `+$1E`, `+$30`, `+$31` is shown for the driver and the ROM0 stubs only.  211 operand sites in `$D040-$D27F` exist in other banks (screen buffers); which WRAM bank each uses was not checked.

* The noise channel's pitch formula (04:4F2D), `StartNote`'s channel take-over rules (04:4B06-4B18) and `SoundDrv_PlaySfx`'s `flags < $80` branch (never used by the data) were read but not verified in depth.

The optional whole-tree `python3 tools/audio_to_macros.py --check` exits 1 in
this checkout because 26 other audio files are not yet in the form written by
that converter; `audio/sfx.asm` is not among the listed files. This is outside
the alias-only pass and is not treated as a gate result for it.
