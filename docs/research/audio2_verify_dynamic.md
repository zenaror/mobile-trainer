# Audio part 2: dynamic (mGBA) adversarial reference

## Summary

**Status upgrades the emulator supports:** wave channel output level (NR32 formula, PROBABLE -> CONFIRMED), noise pitch formula (04:4F2D, "only read" -> CONFIRMED, formula given), the note-end fields
`+$27`/`+$28` (HYPOTHESIS "a tail" -> CONFIRMED: constant-volume tail, level `ceil(hi(+$2F)*hi(+$27)/16)`, length about `(256 - +$28) * 15` frames), `$CD` sub-commands 4, 5, 11 (PROBABLE -> CONFIRMED).
Answered open question: the takeover rule of the song priority (`new >= old`).

It boots the ROM for 300 frames   (so HRAM, the bank-switch mirrors and the RAM vectors are the real ones), then takes the machine over: the CPU is parked in a `jr $` loop in WRAM, `IE = 0`, and the   harness plays the role of the ROM's main loop.

* It single-steps the SM83 core (`core->step`) and records, with frame number, sequencer-tick counters (entries of 04:40F5 = music ticks tM, 04:40AC = sfx ticks tS) and PC:   every CPU write to FF10-FF3F (`W`), every command start (the `call` of the stream reader at 04:45A7: DE = command address, `C`), StartNote (04:4A81, `N`), NoteGateExpired   (04:4BFC, `G`), selected routine entries with the whole track and channel record (`Q`: WriteChannelPitch 04:4ECA, WriteChannelVolume 04:4F97, WriteChannelParams 04:4E4B,   WriteChannelPan 04:4F4F, UpdateChannel 04:4C14, ComputeTrackOutput 04:4668, StartNote after the per-note instrument copy 04:4ABE, TickVibrato 04:45E6, the tail test 04:4D6A), CPU data reads of ROM (`--romread`) and of watched WRAM addresses (`--rwatch`),   end-of-frame snapshots of the track / channel records (`--snap`), mGBA's own APU state per frame (`--apu`: envelope volume, length / playing flags, noise ratio and shift, wave level, NR51) and the audio samples it renders (`--audio`).

### V1.1  Command boundaries (doc sections 1, 3.2, 4.1, 4.2, 4.4, 9.1-9.2)

Method: all 59 distinct stream headers (ids `$01`-`$1D` through `Sound_PlayMusic`, `$29`-`$46` through `Sound_PlaySfx`; ids `$1E`-`$28` share the header of song 1) were played on mGBA until every track had taken its final `$B2` jump twice or ended (`--stop-loops 2`).

Executions by kind: wait 15 016, note 13 328 (3 550 running-status commands: note 2 376, note-volume 1 043, `$C1` 119, `$BE` 12), one-byte commands 5 439, `$B4` 776, `$B3` 552, `$B2` 172, `$B1` 66, `$CF` 2.  39 distinct wait values were executed (1-12, 14-18, 20, 21, 23, 24, 28, 30, 32, 36, 42, 44, 48, 52, 54, 56, 60, 66, 72, 78, 80, 84, 88, 96): every one lasted exactly that many ticks.

| claim (doc) | verdict |
| --- | --- |
| Section 1 / 4.4: all stream bytes explained: 11 916 commands, no overlap, no ambiguous decoding; command sizes of section 4.2 / 4.3 | UPHELD (executed part) |
| 4.1: a byte with bit 7 clear where a command is expected repeats the last opcode >= `$BE` (running status), `$B2`-`$BD` are not stored | UPHELD |
| 4.2: `$81`-`$B0` wait = `Table_SoundDrv_Durations[op-$80]` ticks, `$80` no-op | UPHELD |
| 4.2: `$B2` jumps, `$B3` pushes the address behind the word and jumps, `$B4` pops | UPHELD (depth 1) |
| 4.3: a note is the opcode plus 0-2 optional bytes (pitch, volume); `sound_note_vol` = volume without pitch | UPHELD |
| 3.2: set 0 of the header = stream start of every track (read by the driver) | UPHELD |
| 3.2: header bytes +0 / +1 and sets 1 and 2 are not read by the driver | UPHELD for the driver, NOT VERIFIED elsewhere |
| 3.2: set 1 = loop point = operand of the final `sound_jump`, set 2 = address behind it, 86 of 86 tracks of the 22 headers | UPHELD |
| 3.1: song record bytes +0..+6 used, +7 spare never read | UPHELD |

### V1.2  Register-level effects (doc sections 4.2-4.3, 5.1-5.3, 6, 7, 8)

Method: (a) the 59 headers again with `Q` events (inputs of `WriteChannelPitch/Volume/Params` read from WRAM at the routine entries) and `W` events (every APU write with frame and PC); (b) synthetic ROMs for everything the data does not exercise or exercises only in one corner (sweeps, below).

Method: one synthetic song (bank 6, song record of id `$28`) per experiment, played through the ROM's own stubs; every claim is checked against what mGBA does with the stream (command decode `C` events, track snapshots, APU writes, the emulator's APU state and its rendered audio).

| claim (doc) | verdict |
| --- | --- |
| 5.1 `$C0`: `+$17 = 2v - $80`, `+$2E = +$17 + +$18`, NR51: bits 7/6 of `+$2E` select left only (`$00`-`$1F`), both (`$20`-`$5F`), right only (`$60`-`$7F`) | UPHELD |
| 5.1 `$C6`: nonzero = vibrato term left out of the pitch and not updated | UPHELD |
| 5.1 `$C9`: `+$1D = 2v - $80`, adds `(v - $40) / 64` semitones, added separately | UPHELD |
| 5.1 `$CA`: stores +$1E, flag bit 2; nothing reads +$1E | UPHELD (no reader) |
| 5.1 `$CD` sub-commands 1-7, 10, 11 store the argument in +$0C, high/low nibble of +$0F (2/3) and +$10 (4/5), +$27 (6), +$28 (7), +$0D (10), +$0E (11); 0, 8, 9, >= 12 end the track | UPHELD (sub 4, 5, 11 upgraded from PROBABLE to CONFIRMED) |
| 5.1 `$CF` [pitch]: releases each channel of this track whose note has pitch + add = the given pitch and a gate counter of 0 (held notes); without the byte the last pitch | UPHELD, wording **CORRECTED**, one hazard added |
| 4.2 `$B5` count Label: count 0 always jumps, count n = n passes | UPHELD |
| 4.2 `$B3`: depth counter +2, limit 5 calls, a sixth ends the track | UPHELD |
| 4.2 `$B4` with an empty stack is a no-op | UPHELD |
| 4.2 `$B6`-`$B8`, `$B9`-`$BB`, `$C7`, `$C8`, `$CB`, `$CC` end the track | UPHELD |
| 4.2 `$80` no-op | UPHELD |
| 4.1 opcodes < `$BE` do not update the running status | UPHELD |
| 4.3 note bytes: adjust `$20`-`$23` adds 0-3 to the duration, any order, a second byte of a class ends the note and re-triggers by running status, `$CE` held, note without bytes reuses pitch and volume | UPHELD |
| 5.1 `SoundDrv_SetTrackParam` (04:44B1, 7 entries; "no known caller") | UPHELD |
| 3.1 record: ids 1-`$46` accepted, id 0 pauses / stops, flags bit 7 = all tracks, `$FF` in all records; "the `<$80` branch is never taken" | UPHELD; branch semantics ADDED |
| 11 (open): "what priority `$C9`/`$D2` select in practice" | ANSWERED |

### V1.4  Wave level and noise pitch (doc 7, 4.3)

| claim (doc) | verdict |
| --- | --- |
| 7: wave channel output level through NR32 (`SoundDrv_WriteChannelVolume` 04:4FC0, `Function_04_4E34` flags a change of the top two bits): "PROBABLE, not simulated" | **CONFIRMED** (with the formula) |
| 4.3 / 7: noise channel pitch formula (04:4F2D), "only read, not simulated" | **CONFIRMED** (with the formula) |
| 4.3 / 8: the pitch byte is the MIDI note number (`$24` = C2, `$3C` = C4); the wave channel adds `$0C` "to compensate the channel's octave" | UPHELD (physical) |

### V1.5  Hypotheses of the doc (5.1, 5.3, 7, 3.2)

| claim (doc) | verdict |
| --- | --- |
| 5.1 / 5.3 `+$27`, `+$28` (`$CD 6`, `$CD 7`, Param 6) "read once at 04:4D67 when a note has run out ... HYPOTHESIS: a tail after the note" | **CONFIRMED** (the hypothesis, with specifics) |
| 5.3 `+$30` initialised to `$FF`, read by nothing; `+$31` not initialised, unused | UPHELD |
| 7: byte 3 bits 4 and 0, byte 4 bit 0 "not read by any path followed here" | UPHELD (no effect on the pulse 2 and noise envelopes in 2 x 1 800 random notes; code) |
| 3.2 header set 1 / set 2 "never read by the driver; no reader searched in other banks" | UPHELD for the driver |

### Other claims of the document and of commit b939965 that were re-derived on the way

| claim | verdict |
| --- | --- |
| 4.2 `$BE id`: copies bytes 0-4 of record `id` of `Table_SoundDrv_Instruments` to track +$0C; id `$64` = per-note instrument mode (record `pitch + add + $40`, byte 5 replaces the pitch) | UPHELD |
| 4.1 / 5.3: `$B3` call stack at track +$32..+$3B, depth counter +$26 = 2 per call | UPHELD |
| 5.1 `$C2` recomputes `+$1B/$1C`; `+$1A` = 2 at start | UPHELD |
| 4.3 / 8: index = pitch - `$24` clamped to 0..`$77` | UPHELD |
| 4.4 usage statistics (11 916 commands, 19 716 bytes, per-macro counts, 1 241 running-status notes, 39 wait values, 27 note durations, 30 note volumes, operand counts of `$C1`-`$C5`, `$BC`, `$BE`, pitch add `$00` x 145 / `$F4` x 7, note byte patterns 2311 / 1381 / 329 / 304, all 152 tracks start `BF 7F BD vv`) | UPHELD |
| 3.1 data: priority `$C8` x 67, `$D2` for `$30` / `$31`, `$C9` for `$35`; flags `$FF` x 70; track counts 4 / 1 / 2 / 3 = 35 / 19 / 11 / 5; spare `$00` x 70; ids `$1E`-`$28` = record 1 | UPHELD |
| 6 / 8 table statistics: classes 11 / 63 / 20 / 18, wave patterns used 0 1 3 4 5 7 8 9, bytes 1 and 2 zero, byte 5 `$3C` in the 100 ordinary records, pattern shapes (patterns 4-7 have 4 / 8 / 12 / 16 samples >= 8) | UPHELD |
| labels of b939965: `SoundSongNN_Header` / `_TrackK` = the first id that uses the header, ids `$1E`-`$28` share the header of song 1, 59 headers = 13 + 16 + 30, 152 tracks | UPHELD |
| names of the control entry points (`StopSfxById`, `StopAllSfx`, `PauseMusic`, `ResumeMusic`, `PlayMusicOrResume`, `PlayMusicIfNotPlaying`, `GetActiveMasks`, `GetPlayingId`, `UpdateFade`/`FadeFinished`, `SetTrackParam`) | UPHELD (behaviour) |
| names of the commands (`CmdPan`, `CmdPitchBend`, `CmdPitchBendScale`, `CmdVibratoRate/Delay/Depth/Disable`, `CmdDetune`, `CmdNoteHeld`, `CmdNoteOff`, `CmdWait`, `CmdSetTempo`, `CmdSetPitchAdd`, `CmdSetInstrument`, `CmdSetVolume`, `CmdJump/Call/Return/Repeat/End`, `ExtSetInstrByte0-4`, `ExtSetTrack27/28`, `Param*`) | UPHELD (behaviour) |

| where | now | proposed |
|---|---|---|
| `audio_format.md` l.153, `$C1` row | `+$1B/$1C = 2*(+$19) * +$1A (signed 16 bit)` ... `adds (v - $40) * scale / 64 semitones` | `+$1B/$1C = 2*(+$19) * (+$1A)` when `+$19 >= 0` and `(2*(+$19) + 1) * (+$1A)` when `+$19 < 0` (one's complement, 04:48B9-48C5: `cpl b ; mul ; dec hl ; cpl hl`); the offset is `(v - $40) * scale / 64` semitones for v >= `$40` and that plus `scale / 256` below.  Also `constants/audio_macros.inc` l.225 (same sentence) |
| l.193, `+$C..+$10` row | initial `0, 0, FF, FF, 0` | `0, 0, 0, FF, FF` (04:43A3-43AC: six `$00` at +9..+$E, then `$FF`, `$FF` at +$F, +$10) |
| l.239, decay row | `(0 = no decay: $F0)` | `(0 = no decay: the note starts at the sustain level, first NRx2 = S << 4; with sustain code 0 as well it is cut at once, NRx2 $08 / NRx4 $80)` |
| l.224, byte 2 row | `written to NR10 (pulse 1: sweep); no other channel reads it` | `written to reg-2 for both pulse channels: NR10 for pulse 1, FF15 (the unused NR20) for pulse 2; the wave and noise paths do not write it` |
| l.162, `$CF` row | `... whose note has pitch + add = the given pitch ...` | `... that was started with the same pitch byte (the given pitch also gets the pitch add, like a note's) and whose gate counter is 0 (held note) ...`; add: `a byte $00-$23 after $CF is neither a pitch nor consumed: running status re-dispatches $CF for the same byte for ever and the frame tick never returns (observed: 112 357 decodes of one address in a tick)`.  `constants/audio_macros.inc` l.136-139: the same warning |
| l.21 (summary row) and l.164-169 (`$CD` paragraph) | `$CD` 4, 5, 11 PROBABLE; `+$27`/`+$28` "HYPOTHESIS: a tail after the note" | `$CD` 1-7, 10, 11 CONFIRMED on the emulator.  `+$27`/`+$28`: when `+$2F`, `+$27` and `+$28` are non-zero, the note end (release start with code 0, release finished, sustain code 0) re-triggers the channel at the constant level `ceil(hi(+$2F) * hi(+$27) / 16)` (NRx2 = level << 4) and loads `+$28` into the age counter (channel +$12); the channel is silenced after about `(256 - +$28) * 15` frames.  CONFIRMED (48 of 48 combinations equal the model) |
| l.206, `+$27`/`+$28` row | PROBABLE | CONFIRMED (as above); `+$30`, `+$31` rows: keep, add "0 reads in 59 runs, `+$31` untouched by the driver" |
| l.243-245, wave / noise paragraph | `PROBABLE, not simulated` / `only read, not simulated` | wave NR32 = `((M - $40) xor $C0)` rotated right (levels 0-3 mute, 4-7 25 %, 8-11 50 %, 12-15 100 %), rewritten when the top two bits of the mirror its low three bits change; noise NR43 = `(NR43 & 8) | d`, `b = ~(x - $0D)`, `d = b & 3`, `d = ((b & $3C) << 2) | (b & 3) | 4` when `b >= $C0` (x <= `$4C`): CONFIRMED (5 029 real writes, 308 synthetic) |
| l.52, flags row | `... $FF in all 70 records, so the <$80 branch ... is never taken` | add: `< $80 = index (0-3) of the first sfx track: a 2-track effect lands on tracks k, k+1 (only its first track for k = 3); $04-$7F start nothing` |
| l.129, volume paragraph | `... multiplied (high nibbles) with the track volume` | add: the track volume stage is quantised: `+$2F = $00 / $40 / $80 / $C0 / $FF` for `hi(rotl(v))` = 0 / 1-4 / 5-8 / 9-12 / 13-15 |
| l.233-234 (7 intro) | `a software mirror that counts the same steps` | `... within +-1 level of the hardware envelope (equal in 90 % of the frames); every NRx2 write also re-triggers the channel, which re-synchronises the hardware to the mirror` |
| l.281-283 (limits) and l.372-378 (open questions) | wave level and noise pitch "not simulated", `+$27/+$28`, priority open | remove or update: wave level, noise pitch and the tail are now measured; priority rule `new >= old` (a free track is always used first) |
| `audio/engine.asm` (comments only) | - | `SoundDrv_CmdNoteOff`: note the hang for a following byte < `$24`; `SoundDrv_ExtSetTrack27/28`: "tail level / tail length" may replace the neutral wording once the owner accepts `PROBABLE`-free names |

* The 93 commands behind final jumps (86 `$B1`, 7 commands in three codas at 05:4535, 05:4766, 05:52D7) are never executed by any stream: their decode is checked only against the bytes/labels of the build.
* "No reader of header bytes +0/+1, header sets 1/2 and song-record byte +7": shown for the driver only (CPU data-read watch over the driver's executions); other ROM code (screens, the sound test, mail code) was neither run nor searched for such reads.  The same limit applies to the read watch of `+$1E`, `+$30`, `+$31`.
* Only what mGBA's APU model does is measured (register values, its internal envelope / length / ratio state, rendered samples).  Real-hardware behaviour (the zombie-mode quirks of NRx2 writes, wave RAM access while playing, DMG vs CGB differences) was not tested; the hardware frequency formula `131072 / (2048 - P)` is taken from the documentation (mGBA implements it; the measured frequencies agree with it).
* The harness replaces the ROM's main loop: the stubs are called from an idle loop with interrupts masked (`IE = 0`).  The re-entrancy guard of the stubs (`Bank4_GateEnter*`, the deferred tick path), the frame service `Sound_FrameService`, and any interaction with the rest of the ROM (a screen playing sounds while it draws) were not exercised.
* The "unused" envelope bits were swept on pulse 2 and noise (1 800 random notes each); the wave channel was checked for the NR32 mapping but not for these bits.  `Param` entry 5 with value 0 / `$80` (the word store path at 04:4915) and `Param` 0 with a value above `$80` were not examined in detail.
* Channel-level takeover between a music track and an effect (StartNote's priority test at 04:4B10), `Sound_FrameTick` arriving while another stub runs, and the behaviour of the 11 ids `$1E`-`$28` (copies of song 1, not used by any caller found) were not tested; the labels/ids were checked statically only.
* Section 9's claims about `tools/audio_driver_check.py` itself (5 867 + 5 956 commands executed, 300 000 commands run) were not reproduced by running that script; the equivalent figures here are 11 823 distinct / 35 351 executed commands on mGBA.
* The mGBA run models a CGB; the ROM is a CGB cartridge (the boot A register was set to `$11`), the DMG/AGB models were not tried.

## Additional observations (not claims of the note)

* Songs `$18` and `$1B` are one note followed by `$B1`: the track ends in the tick in which the note starts, so `UpdateChannel` silences the channel at once and the "song" makes no sound (frame 2: NRx2 `$08`, NRx4 `$80`, twice).
* For a pitch byte of a per-note-mode note beyond the 112 records (pitch + add + `$40` >= `$70`) the driver reads the bytes that follow the table (wave patterns, then the song records) as an instrument: there is no bound.
* A `$B5` loop with count 0 never leaves; `$B3` beyond depth 5 ends the track silently (no return, no `$B1`).
* The noise "pitch" is not monotonic: above x = `$4C` it cycles through four very high frequencies (NR43 `$08`-`$0B`); the data uses x up to `$64`.
* The ROM's own callers: `Sound_PlaySfx` is called with ids `$29`-`$46` (no `$37` as a literal) and with `$48` only in the unreferenced `engine/unreferenced/page_list_prototype.asm` (l.626, 1904); the driver ignores `$47` and above (nothing starts), so that call would be silent.  `Sound_PlayMusic*` literals cover `$01`-`$1D` except `$19` (computed ids not followed).
* Fade-out (`Sound_StartFadeOut`, A = 1) lowers `+$16` by 4 per tick from `$40` to `$00` and then pauses the music (track flags `$C0` -> `$40`), at which point `PlayMusicOrResume` of the same id resumes at the same stream pointer.
