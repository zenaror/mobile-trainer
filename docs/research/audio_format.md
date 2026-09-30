# Sound data format (banks 04 and 05) and its macro form

The sound driver of bank 04 (`audio/engine.asm`, `SoundDrv_*`) plays 70 sound ids from 59 stream headers: 13 songs in bank 04 (ids `$01`-`$0D`), 16 songs in bank 05
(`$0E`-`$1D`), 30 sound effects in bank 05 (`$29`-`$46`), plus ids `$1E`-`$28`, which are eleven copies of the record of song 1.  This note re-derives the
format from the driver, records what is proven and what is only inferred, and documents the macros of [`constants/audio_macros.inc`](../../constants/audio_macros.inc)
in which every byte of the sound data is now written: `audio/music/*.asm`, `audio/sfx.asm`, `audio/music_pointers.asm` (streams and song table) and, since the second
pass, `audio/notes.asm`, `audio/instruments.asm` and `audio/wave_samples.asm` (the tables the driver indexes).  The bytes are unchanged: `make` still ends in `SHA-256 OK`.

Status words as in `STYLE.md`.  The earlier description is `naming_g1.md` section 7 (written by one agent from the same code); everything below was re-checked against the driver,
including by *running the driver code* (section 9), and the differences are listed in section 12.  The first pass (sections 1-4, stream format, song table) and the second pass
(sections 5-8: what the commands, instrument bytes and tables do to the hardware) are kept in one document.

## 1. Summary of the evidence

| question | result | status |
|---|---|---|
| layout of the 8-byte song record | `dw header, dw bank, db priority, db flags, db track count, db spare` | CONFIRMED (`SoundDrv_LoadSongHeader` 04:430A, `SoundDrv_StartTrack` 04:434C) |
| how a track's stream bytes are consumed (waits, notes, running status, flow commands, one-byte commands) | see section 4 | CONFIRMED for every construct the data uses (driver code executed on all 152 tracks), CONFIRMED by synthetic streams for the constructs it does not use |
| every byte of the stream ranges (04:574D-7E8C, 05:4000-68C3) explained | yes: 11916 commands + 59 headers, no unknown byte, no overlap, no ambiguous decoding | CONFIRMED (tool run) |
| what the commands `$C0`-`$C6`, `$C9`, `$CF` and the note bytes do to the sound | pan, pitch bend (+ scale), vibrato (rate, delay, depth, disable), detune, note off, note volume, note gate time: section 5 | CONFIRMED (code read, and the driver run on synthetic songs with its APU writes compared with models) |
| `$CA` and the sub-commands 6, 7 of `$CD` | `$CA` stores a byte nothing reads; `$CD` 1-5, 10, 11 patch the instrument copy of the track; 6, 7 set two fields of a note-end path | `$CA` CONFIRMED to have no reader (static + read watch); `$CD` 1-3, 10 CONFIRMED, 4, 5, 11 PROBABLE, 6, 7 effect only partly shown |
| layout of the 6-byte instrument record (`Table_SoundDrv_Instruments`) | channel class + duty/wave/width, length, NR10, two envelope bytes, per-note pitch: section 6 | CONFIRMED for bytes 0-2 and 5 (code + synthetic records), CONFIRMED for the envelope fields of bytes 3-4 on 80 of 100 records (section 7), PROBABLE for the wave channel's volume |
| the 3-byte note record (`Table_SoundDrv_NoteFreq`), duration table, wave patterns | 11-bit period + interpolation step, ticks, 32 4-bit samples: section 8 | CONFIRMED |
| two extra pointer sets in 22 headers (loop point, address after the final jump) | present in all 86 tracks of those headers | PROBABLE (never read by the driver; pattern in the data) |

## 2. Where the data is

| file | bank, range | content |
|---|---|---|
| `audio/music_pointers.asm` | 04:551D-574D | `Table_SoundDrv_Songs`: 70 records of 8 bytes, record of id *n* at `$5515 + 8*n` |
| `audio/music/music_01..0d.asm` | 04:574D-7E8C | streams and headers of songs 1-13 |
| `audio/music/music_0e..1d.asm` | 05:4000-631A | streams and headers of songs `$0E`-`$1D` |
| `audio/sfx.asm` | 05:631A-68C3 | streams and headers of effects `$29`-`$46` |
| `audio/notes.asm` | 04:5044-51DD | `Table_SoundDrv_Durations` (49 bytes), `Table_SoundDrv_NoteFreq` (120 x 3 bytes) |
| `audio/instruments.asm` | 04:51DD-547D | `Table_SoundDrv_Instruments` (112 x 6 bytes) |
| `audio/wave_samples.asm` | 04:547D-551D | `Table_SoundDrv_WavePatterns` (10 x 16 bytes) |

A header is stored **after** the streams of its song (the last bytes of each file), and the song record points at the header; the track pointers in the header point back at
the streams, which are in the same ROM bank.

## 3. Song record and stream header

### 3.1 Song record (CONFIRMED)

`SoundDrv_LoadSongHeader` (04:430A) accepts ids 1-`$46`, multiplies the id by 8, adds `$5515` and reads the record:

| offset | size | field | used as |
|---|---|---|---|
| +0 | word | address of the stream header | `wSoundDrv_HeaderPtr` = address + 2 (the first two header bytes are skipped) |
| +2 | word | ROM bank (9 bits, `wBank4ReadBank` D026/D027) | bank of the header and of all its streams (read by `00:215E/216F`) |
| +4 | byte | priority | `wSoundDrv_HeaderPriority`; stored in the track record at +8 by `SoundDrv_StartTrack`; compared with the track's priority when a track is taken over |
| +5 | byte | flags | `wSoundDrv_HeaderFlags`; bit 7 set: `SoundDrv_PlaySfx` (04:41C0) starts all tracks; $FF in all 70 records, so the `<$80` branch (04:41D0-4216) is never taken by this data |
| +6 | byte | track count | `wSoundDrv_HeaderTrackCount`; one track record is started per pointer |
| +7 | byte | spare | never read; `$00` in all 70 records |

Data: priority `$C8` in 67 records, `$D2` for ids `$30` and `$31`, `$C9` for `$35`; flags `$FF` in all; track counts 4 (35 records), 1 (19), 2 (11), 3 (5).
Macro: `sound_song Header, priority, flags, tracks` emits `dw Header`, `dw BANK(Header)`, `db priority, flags, tracks, $00`.

### 3.2 Stream header

`SoundDrv_NextHeaderTrack` (04:4374) advances `wSoundDrv_HeaderPtr` by 2 per track, and `SoundDrv_InitTrackRuntime` (04:4386) reads the stream start of the track with
`Bank4_ReadStreamWord` from that address (CONFIRMED: flags `$A0` -> `$C0`, pointer words at header+2, +4, ...).  So a header is `2 bytes` followed by `track count` words.

The data shows more (PROBABLE; the driver never reads it):

| bytes | content | evidence |
|---|---|---|
| +0 | the track count | equal to the count of the song record in all 59 headers |
| +1 | `0` (37 headers) or `2` (22 headers) = number of further word sets | the header size is exactly `2 + 2 * tracks * (extra + 1)` in all 59 cases; nothing else separates it from the next stream |
| set 0 | the stream address of each track | CONFIRMED (read by the driver) |
| set 1 (extra = 2) | the loop point of each track | it is the operand of the `sound_jump` that ends the track, in all 86 tracks (`start + 4`, i.e. behind `BF vv BD vv`, in 79 of them) |
| set 2 (extra = 2) | the address right behind that final `sound_jump` | in all 86 tracks; 83 tails are a single `$B1`, three are short codas that no path reaches (05:4535, 05:4766, 05:52D7) |

Macro: `sound_stream_header tracks, extra_sets` (two bytes), then one `dw` line per set.

## 4. The stream (CONFIRMED where stated)

Each track is decoded by `SoundDrv_StepTrack` (04:456C) -> `SoundDrv_ReadNextCommand` (04:459B).  Track record fields used here: +0 flags, +1 wait counter, +2/+3 stream
pointer, +4/+5 bank, +`$11` running status (last opcode >= `$BE`), +`$26` call depth, +`$29` loop counter.  The whole record is in section 5.3.

### 4.1 Reading a command (04:459B-45C5)

1. `Bank4_ReadStreamWord` reads the next two bytes (C = byte, B = the byte after it).  If bit 7 of the first byte is **set** it is an opcode; the byte behind it is pre-fetched as the
   first argument (`wSoundDrv_StreamByte`).  An opcode >= `$BE` is also stored in track+`$11`.  Opcodes `$80`-`$BD` are **not** stored.
2. If bit 7 is **clear** the byte is data: the driver uses the opcode stored in track+`$11` and treats the byte as its first argument (`dec de`: the byte is not consumed
   yet).  This is *running status*: a data byte where a command is expected repeats the last opcode >= `$BE` (note, `$BE`, `$C1`, ... but never `$B2`-`$BD`).  The track starts
   with +`$11` = 0 (`SoundDrv_InitTrackRuntime` clears it).
3. Dispatch: opcode >= `$D0` -> `SoundDrv_CmdNote`; opcode < `$B1` -> `SoundDrv_CmdRest` (wait); otherwise index `opcode - $B1` into `Table_SoundDrv_Commands` (04:46E8, 31 words).

### 4.2 Commands

| opcode | bytes after the opcode | handler | behaviour | macro |
|---|---|---|---|---|
| `$80` | 0 | 04:4756 | no-op (`jp z, ReadNextCommand`) | `sound_wait 0` |
| `$81`-`$B0` | 0 | `SoundDrv_CmdRest` | wait: `Table_SoundDrv_Durations[opcode-$80]` ticks; the counter (+1) gets `value-1`; the next command is read on the tick that finds the counter 0 | `sound_wait ticks` |
| `$B1` | 0 | `SoundDrv_CmdEnd` | writes 0 to the track flags: the track stops | `sound_end` |
| `$B2` | word | `SoundDrv_CmdJump` | continue at the address (same bank) | `sound_jump Label` |
| `$B3` | word | `SoundDrv_CmdCall` | push the address behind the word (depth counter +2, limit 5 calls: a sixth ends the track), continue at the address | `sound_call Label` |
| `$B4` | 0 | `SoundDrv_CmdReturn` | pop; with an empty stack a no-op | `sound_ret` |
| `$B5` | byte, word | `SoundDrv_CmdRepeat` | counted loop: count 0 always jumps; otherwise the counter (+`$29`) is incremented, the word is taken while it differs from the count, then the counter is cleared and the command falls through (count *n* = *n* passes).  Never used | `sound_loop count, Label` |
| `$B6`-`$B8`, `$B9`-`$BB`, `$C7`, `$C8`, `$CB`, `$CC` | - | end handlers (04:45DB / 04:4A24) | end the track | none (never used) |
| `$BC` | 1 | `SoundDrv_CmdSetTempo` | stores the byte as the group tempo (D005 effects / D00A music, selected by D000 bit 5) and recomputes the tempo step | `sound_tempo` |
| `$BD` | 1 | 04:483A -> 04:4973 | stores the byte in track+`$12`; every note start (04:4A81-4A8D, and 04:4B7F) adds it to the pitch byte before the frequency lookup | `sound_pitch_add` |
| `$BE` | 1 | `SoundDrv_CmdSetInstrument` | copies 5 bytes of record *id* (6 bytes each) of `Table_SoundDrv_Instruments` (04:51DD) to track+`$0C`; id `$64` sets flag bit 4 instead: per-note instrument mode (`SoundDrv_StartNote` then takes the instrument of record `pitch + $40`) | `sound_instrument` |
| `$BF` | 1 | `SoundDrv_CmdSetVolume` | stores the byte rotated left in track+`$15` and sets the "volume changed" flag (bit 1) | `sound_volume` |
| `$C0`-`$CA`, `$CF` | see section 5 | | pan, pitch bend, vibrato, detune, note off | `sound_pan` ... `sound_note_off` |
| `$CD` | 2 (sub-command, argument) | `SoundDrv_CmdExtended` (04:473E) | sub-commands 1-7, 10, 11 (`Table_SoundDrv_ExtCommands`, 04:4726) store the argument in track+`$0C`, `$0D`, `$0E` (sub 1, 10, 11), in the high/low nibble of +`$0F` (2/3) or +`$10` (4/5), in +`$27` (6) or +`$28` (7); 0, 8, 9 and >= 12 end the track.  Never used | `sound_cmd_CD sub, value` |
| `$CE` | optional bytes as a note | 04:4A27 | note whose duration field is 0: held until released | `sound_note 0, ...` |
| `$D0`-`$FF` | optional bytes (4.3) | `SoundDrv_CmdNote` | note; duration `Table_SoundDrv_Durations[opcode-$CF]` | `sound_note duration, ...` |

The one-byte handlers each perform exactly one `inc de` (all checked in `audio/engine.asm`); `$C1` has the rest of its mechanism (Mul8x8 of `|value|` and track+`$1A`) shared with `$C2`.

### 4.3 Notes (04:4A2B-4A81)

The opcode gives the duration (value of the table at index `opcode - $CF`, stored in track+`$0B`).  The bytes behind it are read in a loop until a byte with bit 7 set; each byte has a class and
**each class may occur once**: `$24`-`$7F` pitch (track+`$09`), `$00`-`$1F` volume (track+`$0A` = `(byte << 3) | 7`), `$20`-`$23` adjust (added to track+`$0B`, i.e. to the duration).  They may come
in any order (synthetic streams); a second byte of a class ends the note *without consuming it*, and it is then read as a data byte, i.e. re-triggers the same note by running status.
The data uses pitch, pitch + volume, volume only, and no byte at all (4325 notes: 2311 + 1381 + 329 + 304), never adjust bytes, and always pitch before volume.

`SoundDrv_StartNote` (04:4A81) then forms `pitch + track+$12`; `SoundDrv_WriteChannelPitch` -> `SoundDrv_NoteToIndex` (04:4FEA) subtracts `$24` (clamp 0..`$77`) and indexes
`Table_SoundDrv_NoteFreq` (120 records of word + byte, 12 per octave, index 0 = `$002C` = 65.4 Hz).  So a pitch byte is a semitone number, `$24` the lowest, and (section 8) the pitch byte
is the MIDI note number of the tone (36 = C2 with C4 = 60).  For the wave channel `SoundDrv_WriteChannelPitch` (04:4ECA) adds `$0C` (so the same byte sounds an octave up in the table, compensating
the channel's octave), and the noise channel uses a different formula (04:4F2D).  In the data the pitch bytes range over `$24`-`$7F` and `sound_pitch_add` is `$00` (145 tracks) or `$F4`
(7 times, = -12 as a signed byte, one octave down; CONFIRMED by the effects run: `$0C` moves the period index up 12 records, `$F4` down 12).

**Duration and volume (CONFIRMED by the effects run, section 9).**  The duration of a note is its *gate time*: the channel record keeps it as a countdown (channel+7) that
`SoundDrv_ServiceChannelSfx/Music` -> `Label_04_4BEB` decrements once per tick; at 0 the driver calls `SoundDrv_NoteGateExpired`, which starts the release phase of the envelope (section 7).  With
duration 0 (`$CE`) the counter is never decremented: the note is *held* until a `$CF` (`sound_note_off`) for its pitch or until the track ends.  The duration is **not** the time until
the next command: a note does not block the track, only waits do.  The third byte (`sound_note ..., vol`) is the note's volume: `(v << 3) | 7` is multiplied (high nibbles, `SoundDrv_MulNibbles`)
with the track volume of `sound_volume` (and with the fade level) and gives the volume nibble of the channel's NRx2 register; it stays in force for the following notes of the track.  The effects
run compares 36 combinations of `sound_volume` and note volume with that formula: all equal.

### 4.4 Usage in the data (11916 commands, 19716 bytes)

wait 4871, note 4325 (1241 by running status), `$BE` 1110 (6 by running status), `$C1` 550 (101), `$B3` 276, `$BF` 152, `$BD` 152, `$B4` 113, `$B2` 86, `$B1` 152 (66 reached), `$BC` 59,
`$C2` 19, `$C5` 18, `$C3` 17, `$C4` 14, `$CF` 2, never `$B5`, `$C0`, `$C6`, `$C9`, `$CA`, `$CD`.  All 152 tracks start `BF $7F BD vv` (`BD` occurs only there: `$00` in 145 tracks, `$F4` in 7) -
"volume" and "pitch add" are set first in every track.  `BE $64` (per-note instrument mode, the drum tracks) occurs 27 times, 45 distinct `BE` operands (including `$64`) are used.
Durations used: 39 different values in waits, 27 (0 included) in notes.  Operands of the commands that are used: `$C1` 37 distinct values, `$40` (no bend) 232 times, `$28` 113, `$20` 89; `$C2` 8 values
(`$0C` and `$30` six times each); `$C3` 8 values (`$20` six, `$40` four); `$C4` 9 values (`$10`-`$30`); `$C5` 7 values (`$0E`-`$48`); note volumes 30 values (0-`$1F`); `$BC` 18 values (`$4A` 33 times).

## 5. The commands `$C0`-`$CF`: what they do

How this was established: the handler code (`audio/engine.asm`) gives the track field each command writes and the flag bit it sets; `SoundDrv_TickVibrato` (04:45E6),
`SoundDrv_ComputeTrackOutput` (04:4668) and `SoundDrv_UpdateChannel` (04:4C14) turn the fields into channel registers.  Every claim marked CONFIRMED below was then checked by
running the whole frame tick on a synthetic song (`tools/audio_driver_check.py`, section 9) and comparing the APU writes with a model of that code; the number of cases is given.  Names
(macros, and the `SoundDrv_Cmd*` labels proposed in `analysis/naming2/audio2_renames.tsv`) describe the demonstrated *effect*; none of them is known to be the original author's name.

### 5.1 Commands

| opcode | macro | field(s) | effect | status |
|---|---|---|---|---|
| `$C0` | `sound_pan value` | +`$17` = 2*v - `$80`, flag bit 0; +`$2E` = +`$17` + +`$18` | NR51: for the channel of the track, bit 7/6 of +`$2E` select "left only" (value `$00`-`$1F`), both (`$20`-`$5F`), "right only" (`$60`-`$7F`); +`$18` is the pan offset of `Param` 3.  Never used in the data | CONFIRMED (32 values) |
| `$C1` | `sound_pitch_bend value` | +`$19` = 2*v - `$80`; +`$1B/$1C` = 2*(+`$19`) * +`$1A` (signed 16 bit), flag bit 2 | adds (v - `$40`) * scale / 64 semitones to the pitch (unit: 1/256 semitone in the high/low byte of +`$2C/$2D`); `$40` = none.  Used 550 times | CONFIRMED (60 (value, scale) pairs) |
| `$C2` | `sound_pitch_bend_scale scale` | +`$1A` (2 at start); recomputes +`$1B/$1C` | the factor of `$C1` | CONFIRMED |
| `$C3` | `sound_vibrato_rate value` | +`$1F` (`$17` at start); a value of `$00` / `$80` also presets the phase +`$20` to `$40` / `$00` | phase step per tick of the triangle LFO | CONFIRMED (6 settings x 40 ticks) |
| `$C4` | `sound_vibrato_delay ticks` | +`$2A`; every note start copies it to +`$2B` | the vibrato phase is held for that many ticks after each note start | CONFIRMED |
| `$C5` | `sound_vibrato_depth value` | +`$21` (0 at start); the depth is +`$21` + +`$22` (`Param` 4) | peak-to-peak deviation depth * 8 / 256 semitones (depth `$20` = 1 semitone) | CONFIRMED |
| `$C6` | `sound_vibrato_disable value` | +`$23` (0 at start), flag bits 0-2 | nonzero: the vibrato term is left out of the pitch and not updated.  Never used | CONFIRMED |
| `$C9` | `sound_detune value` | +`$1D` = 2*v - `$80`, flag bit 2 | adds (v - `$40`) / 64 semitones (same unit as `$C1` with scale 1, but added separately).  Never used | CONFIRMED (6 values) |
| `$CA` | `sound_cmd_CA value` | +`$1E`, flag bit 2 | none demonstrated: nothing reads +`$1E` (no access in `SoundDrv_TickVibrato`, `SoundDrv_ComputeTrackOutput`, `SoundDrv_UpdateChannel`; none in the read watch of section 9).  Never used.  Name stays neutral | CONFIRMED (no reader), effect unknown |
| `$CD` | `sound_cmd_CD sub, value` | see below | see below.  Never used | see below |
| `$CF` | `sound_note_off [pitch]` | optional pitch byte to +`$09`, then channel records | releases (`SoundDrv_NoteGateExpired`) each channel of this track whose note has pitch + add = the given pitch and a gate counter of 0 (held notes); without the byte the last pitch.  Used twice | CONFIRMED (same pitch, bare, other pitch) |

`$CD` sub-commands (`Table_SoundDrv_ExtCommands`): 1, 10, 11 store the argument in byte 0, 1, 2 of the instrument copy (track+`$0C..$0E`); 2, 3 set the high / low nibble of byte 3
(+`$0F`); 4, 5 the same for byte 4 (+`$10`); 6, 7 store it in +`$27` / +`$28`; 0, 8, 9 and >= 12 end the track.  CONFIRMED on the running driver: sub 1 changes the duty of the next
pulse-2 note, sub 10 sets NR21's length bits and NR24 bit 6, sub 2 + 3 produce the attack write of byte 3 `$A3`; sub 4, 5, 11 are read from the code only (PROBABLE).  +`$27` / +`$28` are read once, at
04:4D67 when a note has run out (`SoundDrv_UpdateChannel`, `.l4D54`): with both set, the driver re-triggers the channel at the note end (NR22 `$40` / `$70` for track volume `$7F` instead of the
silencing `$08`) and loads +`$28` into the channel's age counter (channel+`$12`), which `SoundDrv_UpdateChannel` increments each tick (twice every 15th) while the end state decrements it; in the runs the channel
was not silenced before the track ended, so what the pair is for is only partly shown (HYPOTHESIS: a tail after the note).

The same fields are also reachable from outside the stream: `SoundDrv_SetTrackParam` (04:44B1, stub 00:20D6, no known caller) dispatches on `Table_SoundDrv_ParamHandlers` (04:44A3, 7 entries): 0 tempo
scale (D006/D00B), 1 word to +`$13/$14` (an external pitch offset, added to the pitch like `$C1`; CONFIRMED: a probe of `$0100` moves pulse 2 by one semitone), 2 byte to +`$16` (the volume scale that
`SoundDrv_UpdateFade` writes for the fade-out, multiplied with +`$15` by `SoundDrv_ComputeTrackOutput`), 3 byte to +`$18` (pan offset, CONFIRMED by probe), 4 byte to +`$22` (vibrato depth addend, CONFIRMED by probe),
5 byte to +`$1F` (vibrato rate, as `$C3`), 6 word to +`$27/$28`.

### 5.2 The per-tick chain

`SoundDrv_StepTrack` -> (wait running) `SoundDrv_TickVibrato` (+`$20` phase += +`$1F`, triangle of the phase times depth, written to +`$24/$25`) -> `SoundDrv_ComputeTrackOutput`: if flag bit 2, +`$2C/$2D` = 2*(+`$1D`)
+ (+`$1B/$1C`) + (+`$13/$14`) + (+`$24/$25` unless +`$23` != 0); bit 0: +`$2E` = +`$17` + +`$18`; bit 1: +`$2F` = volume (+`$15` x +`$16`, nibble product, clamped, x4).  `SoundDrv_UpdateChannel` then
writes pitch (`SoundDrv_WriteChannelPitch`: period = table[index + high byte] + ceil(step * low byte / 256), index clamped, +`$0C` for the wave channel), pan (`SoundDrv_WriteChannelPan`) and volume
(`SoundDrv_WriteChannelVolume`) when the matching flag is set.  Tempo: one tick per frame when the group tempo is `$4A` (initial tempo scale `$40`): the frame tick adds the tempo step to a 16-bit
accumulator and runs a tick for every `$4A` in it (04:4082-4119); CONFIRMED by the gate test (a note of *d* ticks is released at frame *d* with `sound_tempo $4A`).

### 5.3 Track record (`$3C` bytes, 8 records at D040: tracks 0-3 effects, 4-7 music; `SoundDrv_InitTrackRuntime` 04:4386 sets the initial values)

| offset | initial | field | written by | read by | status |
|---|---|---|---|---|---|
| +0 | `$C0` | flags: bit 7 active, bit 6 initialised, bit 4 per-note instrument mode, bits 0-2 pan / volume / pitch changed | start, `$BE $64`, commands | `StepTrack`, `ComputeTrackOutput`, `UpdateChannel` | CONFIRMED |
| +1 | 0 | wait counter | waits | `StepTrack` | CONFIRMED |
| +2/+3, +4/+5 | | stream pointer, ROM bank | | `ReadNextCommand` | CONFIRMED |
| +6/+7, +8 | | song id, priority | `StartTrack` | priority: takeover test | CONFIRMED |
| +9, +`$A`, +`$B` | 0 | pitch, note volume `(v<<3)|7`, duration (gate) | `CmdNote` | `StartNote` (copied to the channel) | CONFIRMED |
| +`$C`..+`$10` | 0, 0, FF, FF, 0 | instrument copy, bytes 0-4 | `$BE`, `$CD` 1-5, 10, 11 | `StartNote` (copied to the channel) | CONFIRMED |
| +`$11` | 0 | running status | `ReadNextCommand` | same | CONFIRMED |
| +`$12` | 0 | pitch add | `$BD` | `StartNote`, `$CF` | CONFIRMED |
| +`$13/$14` | 0 | external pitch offset | `Param` 1 | `ComputeTrackOutput` | CONFIRMED |
| +`$15`, +`$16` | `$FF`, `$40` | track volume (2v), volume scale (fade) | `$BF`, `Param` 2 / `UpdateFade` | `ComputeTrackOutput` | CONFIRMED |
| +`$17`, +`$18` | 0, 0 | pan, pan offset | `$C0`, `Param` 3 | `ComputeTrackOutput` | CONFIRMED |
| +`$19`, +`$1A`, +`$1B/$1C` | 0, 2, 0 | pitch bend value, scale, product | `$C1`, `$C2` | `ComputeTrackOutput` | CONFIRMED |
| +`$1D` | 0 | detune | `$C9` | `ComputeTrackOutput` | CONFIRMED |
| +`$1E` | 0 | none | `$CA` | nothing | CONFIRMED (no reader) |
| +`$1F`, +`$20` | `$17`, 0 | vibrato rate, phase | `$C3`, `Param` 5, `TickVibrato` | `TickVibrato` | CONFIRMED |
| +`$21`, +`$22`, +`$23` | 0 | vibrato depth, depth addend, disable | `$C5`, `Param` 4, `$C6` | `TickVibrato`, `ComputeTrackOutput` | CONFIRMED |
| +`$24/$25` | 0 | vibrato output | `TickVibrato` | `ComputeTrackOutput` | CONFIRMED |
| +`$26` | 0 | call depth (2 per `$B3`) | `$B3`, `$B4` | | CONFIRMED |
| +`$27`, +`$28` | 0 | note-end fields (`$CD` 6, 7; `Param` 6) | | `UpdateChannel` 04:4D67 | PROBABLE |
| +`$29` | 0 | loop counter of `$B5` | | | CONFIRMED |
| +`$2A`, +`$2B` | 0 | vibrato delay, its countdown | `$C4`, `StartNote` | `TickVibrato` | CONFIRMED |
| +`$2C/$2D`, +`$2E`, +`$2F` | | output: pitch offset (8.8 semitones), pan bits, volume | `ComputeTrackOutput` | `WriteChannelPitch/Pan`, `UpdateChannel` | CONFIRMED |
| +`$30` | `$FF` | (initialised by `InitTrackRuntime`; read by nothing seen) | | none in the read watch | HYPOTHESIS: unused |
| +`$31` | | not initialised | | none | HYPOTHESIS: unused |
| +`$32`-+`$3B` | | call stack of `$B3`: up to five return addresses (words), `SoundDrv_CmdCall` stores at track + `$30` + new depth (2, 4, .. `$0A`), `SoundDrv_CmdReturn` reads them back | `$B3` | `$B4` | CONFIRMED (code 04:4777-47C5; the read watch sees +`$32/$33` read after a call) |

## 6. The instrument table (`Table_SoundDrv_Instruments`, 04:51DD, 112 records of 6 bytes)

`SoundDrv_GetInstrumentPtr` (04:4889) indexes it by `id * 6`.  `sound_instrument id` copies bytes 0-4 to track+`$0C`; `SoundDrv_StartNote` (04:4A81) copies them with the note to the hardware
channel record (channel+8..+`$C`), where `SoundDrv_WriteChannelParams` (04:4E4B) writes them to the registers at the start of the note.  In the per-note mode (`$BE $64`) `StartNote` instead
takes record `pitch + $40` (pitch including the pitch add) and also byte 5.

| byte | meaning | evidence | status |
|---|---|---|---|
| 0 | channel class and, for the register write, duty / wave / width.  `< $08`: pulse 1, `$08-$0F`: pulse 2 (both: bits 0-1 = duty, written to bits 7-6 of NRx1), `$10-$3F`: wave channel (byte - `$10` = pattern index, section 8), `>= $40`: noise (bit 0 = NR43 bit 3, the 7-bit counter) | class: `StartNote` 04:4ABE-4ADA (`cp $10`, `cp $08`, `cp $40`); duty, wave, width: `WriteChannelParams`; synthetic records | CONFIRMED |
| 1 | length: 0 = none; else NRx1 length bits = -length, NRx4 bit 6 set (NR31 = -length for the wave channel, NR41 for noise) | `WriteChannelParams` 04:4E7D-4EA9; synthetic records (pulse 1, pulse 2, noise; the data has 0 in all 112 records) | CONFIRMED |
| 2 | written to NR10 (pulse 1: sweep); no other channel reads it.  `$00` in all 112 records | `WriteChannelParams` 04:4E8F; synthetic record (`$5A` -> NR10) | CONFIRMED |
| 3, 4 | the volume envelope (section 7) | `UpdateChannel`; 80 records simulated | CONFIRMED for the fields below |
| 5 | pitch byte that replaces the note's own pitch in the per-note mode; read only there (`StartNote` copies it to channel+`$0E`); `$3C` in the 100 ordinary records, the drum pitches in records `$64`-`$6F` | `StartNote` 04:4AAE-4ABB; the data plays pitches `$24`-`$27`, `$29`, `$2A`, `$2C`-`$2F` in per-note tracks (walk over all tracks), i.e. records `$64`-`$67`, `$69`, `$6A`, `$6C`-`$6F` | CONFIRMED |

Distribution in the data: pulse 1 (byte 0 < `$08`) 11 records, pulse 2 63, wave 20 (patterns 0, 1, 3, 4, 5, 7, 8, 9), noise 18; byte 1 and byte 2 are `$00` in all records.

## 7. The envelope (bytes 3 and 4 of the instrument)

`SoundDrv_UpdateChannel` runs a four-state machine per hardware channel, the state being bits 5-4 of the channel flags (channel+0, `$F0` at the start of a note): `11` attack, `10` decay / sustain, `01`
release, `00` end / tail; bit 6 marks a pending transition (set at the start and by `SoundDrv_NoteGateExpired`).  It drives the hardware envelope (period bits of NRx2 with a software mirror that
counts the same steps) instead of programming the volume directly:

| field | bits | effect | status |
|---|---|---|---|
| attack | byte 3 bits 7-5, **inverted** | 0 (bits `111`): none; else the note starts at volume 0 with the increase direction and that period (NRx2 = `$08` \| period), until the mirror reaches the target volume | CONFIRMED (record `$68`: NR42 `$09`; the other 79 simulated records have none) |
| decay | byte 3 bits 3-1, inverted | period of the hardware decay from the target volume: NRx2 = target nibble << 4 \| period (0 = no decay: `$F0`) | CONFIRMED (80 records) |
| sustain | byte 4 bits 7-4 | level the decay stops at: nibble = ceil(hi(+`$2F`) x ceil(hi(byte 4) x hi(note volume byte) / 16) / 16), hi() = high nibble, +`$2F` = the track's volume output; written as NRx2 = level << 4 when the mirror gets there; a level of 0 ends the note | CONFIRMED (sustain write of every record with 0 < level < target) |
| release | byte 4 bits 3-1, inverted | after `NoteGateExpired`: NRx2 = current level << 4 \| period; 0 = cut at once (NRx2 `$08`, NRx4 `$80`) | CONFIRMED (every record with a release period) |

Byte 3 bits 4 and 0 and byte 4 bit 0 are not read by any path followed here (HYPOTHESIS: unused).  The target volume at the start is the nibble product of track volume and note volume (section 4.3).  The wave
channel runs the same machine but has a two-bit output level in NR32 (`SoundDrv_WriteChannelVolume` 04:4FC0; `Function_04_4E34` flags a change of the top two bits): PROBABLE, not simulated.  The noise
pitch formula (04:4F2D) is also only read, not simulated.

## 8. Tables: durations, note frequencies, wave patterns

* `Table_SoundDrv_Durations` (04:5044, 49 bytes): `00..18` step 1, then `1C 1E 20 24 28 2A 2C 30 34 36 38 3C 40 42 44 48 4C 4E 50 54 58 5A 5C 60`; index = `opcode - $80` (wait) or `opcode - $CF` (note); the value is the number of
  ticks of the wait / the gate time of the note.  CONFIRMED (effects run).  Macro `sound_durations v, ...` (audio/notes.asm), which asserts that every entry agrees with the value list `_sound_dur_def` that `sound_wait` / `sound_note` use.
* `Table_SoundDrv_NoteFreq` (04:5075, 120 records of 3 bytes, index = pitch byte - `$24`): `dw` 11-bit period (NRx3 + NRx4 bits 2-0) and `db` step.  `SoundDrv_LookupFrequency` (04:4FF5) returns the period in DE and
  the step in A; `SoundDrv_WriteChannelPitch` adds `ceil(step * fraction / 256)` to the period, where the fraction is the low byte of the pitch offset (+`$2C`) and the high byte (+`$2D`) moves the index: the tone is
  interpolated between two records.  Checks: every one of the 120 periods is within 1 of `2048 - 131072 / f` for `f` = the equal-tempered frequency of MIDI note 36 + index (A4 = 440 Hz: record 0 = 65.4 Hz = C2, record 119
  saturates at 2046), and the step is the next record's period minus this one's (within 1).  So a pitch byte is a MIDI note number (`$24` = 36 = C2, `$3C` = 60 = C4, `$7F` = 127).  Macro `sound_note_freq period, step`, with
  the pitch byte and the note name as a comment (mechanically derived).  CONFIRMED.
* `Table_SoundDrv_WavePatterns` (04:547D, 10 x 16 bytes): copied unchanged to wave RAM `$FF30-$FF3F` by `SoundDrv_WriteChannelParams` when a wave-channel note starts with a pattern different from the cached one
  (`wSoundDrv_WaveCache`).  The hardware plays the high nibble of each byte first, so the macro `sound_wave_pattern s0 .. s31` takes the 32 samples in playing order (mechanically unpacked from the bytes).  By looking at the samples: pattern 0 is sine-like, 1 a triangle (0 up to F and back), 2 a falling ramp, 3 a falling shape with a plateau, 4-7 are pulse shapes with 4, 8, 12 and 16 high samples out of 32, 8 and 9 smooth single-peak shapes.  CONFIRMED (effects run: every wave instrument of records `$00`-`$63`, 20 records, writes its
  pattern to `$FF30-$FF3F`).  Which patterns the data uses: 0, 1, 3, 4, 5, 7, 8, 9.

## 9. How the decoding was verified

1. **Static, whole ROM** (`tools/audio_to_macros.py`): decodes every track of every header by simulating the control flow of `SoundDrv_ReadNextCommand` (state = address, running status, call
   stack; jump taken, call pushes, return pops, `$B5` both ways) starting at every set-0 pointer, then at the set-2 addresses.  Result: 70 records, 59 headers, 11916 commands, 19716 bytes = the two stream ranges
   04:574D-7E8C and 05:4000-68C3 completely, no unknown opcode, no overlap, no address decoded two ways, no command of size 0.  Every decoded command re-encodes from its fields to the ROM bytes.  The same tool writes the three table
   files and checks their invariants (duration list, equal temperament and step of the note table, record classes of the instruments).
2. **Dynamic, driver code** (`tools/audio_driver_check.py`, about a minute; `--quick` runs fewer commands per track (about 20 s with part 4); `--no-effects` skips part 4): a small SM83 interpreter runs `SoundDrv_Init` and `SoundDrv_StepTrack` of the original ROM on all
   152 tracks (the bank-switching stream readers `00:215E/216F` are replaced by plain reads).  The command addresses the driver starts to decode and the (counter, stream pointer) it stores after every
   wait are **identical** to the decoder's for all 152 tracks (about 300000 commands run by the driver code); 5867 + 5956 of the 11916 commands are executed, the other 93 are exactly the ones behind a track's final jump
   (86 `$B1` and 7 further commands in three codas).  66 tracks run into `$B1`; 86 loop through their `$B2`.
3. **Synthetic streams** (same script): 36 hand-made streams check the constructs the data does not use - adjust bytes, byte order and duplicate classes of notes, `$CE`, `$CF` (with and without pitch), `$B5`
   (count 0, 1, 3), `$CD` sub-commands, the ten opcodes without handler, `$80`, `$B4` on an empty stack, running status after `$BE`/`$C1`, opcodes < `$BE` not updating it, and a call depth of 4-7 (limit 5).
   The driver and the decoder agree on all of them.
4. **Effects** (same script, function `check_effects`; new in the second pass): `SoundDrv_PlaySfx` and `SoundDrv_FrameTick` run on a synthetic song (placed in ROM bank 6 of an in-memory copy, its record replacing id `$46`), every write to
   `$FF10-$FF3F` is recorded per frame, and the values are compared with small models written from the driver code: track volume x note volume -> NR22 (36 combinations); gate time of 7 durations; held note and `$CF` (same /
   other pitch / bare); `$C0` (32 values) -> NR51; `$C1` x `$C2` (60 pairs), `$C9` (6), `sound_pitch_add` (4) -> period; vibrato (6 settings x 40 ticks, an exact LFO model); `$C6`; the envelope of 80 pulse/noise records
   (first write, sustain write, final silence) and the release write of the records that have one; synthetic instrument records (duty, length, sweep, noise width); the wave pattern copy of the 20 wave records; `$CD` probes; and a
   read watch over the track record (`CPU.rd`) that shows +`$1E` is never read.  All of them agree.  (At the first run three of the expectations written into the script were wrong - a held note simply ends with the track, the phase preset of `$C3 $00`, and the
   length of the run; the driver was right each time and the script was corrected.)
5. **Build**: `make` -> `SHA-256 OK`, byte compare `IDENTICAL`, no new `rgbasm` warning; `make sym-check` OK.

Limits: the emulation starts from a freshly initialised driver with all other tracks inactive and proves how stream bytes are consumed and what the registers are written with in the cases tried, not what the sound is like.
The interpreter is only tested by this agreement (and by the exact match of models written from the code: a wrong interpreter would have to be wrong in the same way as the reading).  The wave channel's volume and the noise
channel's pitch are not simulated.  A single execution does not prove general behaviour: the claims about never-used constructs rest on the synthetic streams and the models.

## 10. The macro form

`constants/audio_macros.inc` is pre-included (`includes.asm`).  Every macro emits exactly the bytes of the tables above; the operand of `sound_wait` / `sound_note` is the **value** of
`Table_SoundDrv_Durations` (49 values, listed in the include and checked against the ROM table by the tool and, in `audio/notes.asm`, by `sound_durations`); a value that is not in the table is an assembly error.

```asm
Data_04_58C6:: ; 04:58C6            ; start of a track
	sound_volume $7F
	sound_pitch_add $00
Data_04_58CA:: ; 04:58CA            ; loop point, target of the final sound_jump
	sound_tempo $4F
	sound_instrument $00
	sound_wait 24
	sound_note 3, $3F, $13         ; duration 3, pitch $3F, note volume $13
	sound_wait 3
	sound_rs sound_note 9, $3F     ; running status: the opcode byte is omitted
	...
	sound_jump Data_04_58CA
Data_04_593C:: ; 04:593C
	sound_end                       ; never reached: behind the final jump (address listed in the header)
```

* `sound_rs <macro>` omits the opcode byte of the macro that follows; the driver re-uses the last opcode >= `$BE`.  The tool writes it only where the decode shows that this opcode is the one the
  macro stands for (same decoding in every flow state), and the assembler refuses it for opcodes < `$BE`.
* Macro names (second pass): `sound_note_mod` is now `sound_note_vol`, `sound_cmd_CF` is `sound_note_off`, `sound_cmd_C0`..`C6`, `C9` are `sound_pan`, `sound_pitch_bend`, `sound_pitch_bend_scale`,
  `sound_vibrato_rate`, `sound_vibrato_delay`, `sound_vibrato_depth`, `sound_vibrato_disable`, `sound_detune`; `sound_cmd_CA` and `sound_cmd_CD` keep their opcode.  Macro names are not labels: the build hash proves the bytes.
* Table macros: `sound_durations`, `sound_note_freq period, step`, `sound_instr_pulse1 duty, length, sweep, env_a, env_b, pitch` / `sound_instr_pulse2` / `sound_instr_wave` / `sound_instr_noise` (byte 2 is `$00` in
  the last three; `sound_instr_raw` exists for a record none of them writes, and is not used), `sound_wave_pattern` (32 samples).  A comment per record gives the id and the decoded envelope fields.
* Labels: every header, track start, loop target, jump/call target and pointer word uses a label.  Labels that already existed were kept (and used); the 333 that were missing are `Data_BB_AAAA:: ; BB:AAAA`
  in the file that contains the address (only targets got one).  In `music_02` ... `music_0d` and `sfx` the section start has a label now.  `analysis/naming2/audio2_renames.tsv` proposes `SoundSongNN_Header` /
  `SoundSongNN_TrackK` for the 59 headers and the 151 track starts (the name carries the id of the first song record that uses it; ids `$1E`-`$28` share the header of song 1); the track 0 of song 1 keeps its existing
  label `Data_SoundDrv_Streams`.  The converter prefers a `SoundSong*` label when it exists, so it keeps producing the same files after the renames are applied.
* The region header comments (`; ---- data $A-$B ... [PROBABLE] ... content of individual commands unknown`) are kept unchanged; they record the state before the decode and are superseded by this note.  The headers of
  the three table files were rewritten (`[CONFIRMED]` + evidence, the earlier note kept after `superseded note:`).
* **No byte is left as `db` any more.**  First pass: 15 bytes in 7 commands were cut by pre-existing label boundaries (`Data_05_5B34`, `5BCB`, `5C9E`, `5D69`, `5F09`, `5FF1`, `68BE`).  These labels were artifacts of the coverage
  pieces (`config/regions/bank05.tsv`: "unread interior", "UNCLASSIFIED"); nothing referenced them (no stream pointer, jump, call, header word or source line), so the second pass removed them and merged the block that each one started
  into the block before (the merged header keeps the text of both headers, and its status is the weaker of the two).  `tools/audio_to_macros.py` does this itself (`merge_cut_blocks`): a boundary that cuts a command is removed
  when the label is unreferenced; a referenced one would be kept and its command written as `db` (none is left).  The two-byte header of effect `$46` (`02 00`, 05:68BD) is now one `sound_stream_header 2, 0`.  The evidence files `config/regions/bank05.tsv`
  and `analysis/mapper/bank05.tsv` are frozen and still list the old pieces.

### Regenerating and checking

```
python3 tools/audio_to_macros.py --check       # decode + verify; exit 1 when a file is not in the form the tool writes
python3 tools/audio_to_macros.py               # rewrite, make, SHA-256 + sym_check, restore every file on failure
python3 tools/audio_to_macros.py --names FILE  # (with any mode) also write the SoundSongNN_* rows for tools/apply_renames.py
python3 tools/audio_driver_check.py [--quick] [--no-effects]   # run the driver code on the streams (section 9)
```

The tool is idempotent (a second run changes nothing) and works on a copy with `--root DIR`.  It reads the original ROM (`baserom.gbc`, must match `roms.sha256`) and never writes it.

### How to add a song or an effect (a deliberate ROM change)

The hash of the ROM changes, so work on a copy of the tree/branch and keep the reference hash for the unmodified build (STYLE.md section 2).

1. Write the streams and the header in a new file with its own section; a section that is not in `layout.link` floats into free space, in any ROM bank (the song record carries the 9-bit bank, `BANK(Header)`; all
   streams of a song and the header must be in that one bank, and `sound_jump` / `sound_call` targets must be in the same bank as the stream):

   ```asm
   SECTION "audio/music/new_song", ROMX

   NewSong_Header::
   	sound_stream_header 2, 0          ; track count, 0 extra pointer sets (set 1 / 2 are optional and never read)
   	dw NewSong_Track0, NewSong_Track1

   NewSong_Track0::
   	sound_volume $7F                  ; every existing track starts with volume and pitch add
   	sound_pitch_add $00
   	sound_tempo $4A                   ; one tick per frame
   	sound_instrument $00              ; record 0: pulse 2, duty 3
   .loop
   	sound_note 8, $40, $1F            ; gate 8 ticks, pitch $40 (E4), note volume $1F
   	sound_wait 8                      ; the next note starts 8 ticks later
   	sound_note 8, $43
   	sound_wait 8
   	sound_jump .loop
   ```
   (assembled with the project flags in a scratch copy: no warning).  A wait value must be in the duration list; a note's duration too; a pitch is a MIDI number (`$24`-`$7F`); use `sound_instrument $64` for the drum kit of
   records `$64`-`$6F` (the pitches `$24`-`$2F` then select the drum) and one of the 100 other records otherwise.
2. Give the song a record: either change one of the 70 lines of `audio/music_pointers.asm` (`sound_song NewSong_Header, $C8, $FF, 2`: priority, flags `$FF`, track count; the ids `$1E`-`$28` are copies of song 1
   that no caller found in this ROM uses, so they are free candidates) or, for an id above `$46`, move the table and patch the `cp $47` of `SoundDrv_LoadSongHeader`.
3. Play it with the id the driver accepts (`Sound_PlayMusic` / `Sound_PlaySfx` with BC = id; the sound-test screen of the ROM plays any id it is given).
4. `make` will report the changed hash; `python3 tools/audio_driver_check.py --quick` still runs the original streams; run the new streams through the driver with `Sim` (`tools/audio_driver_check.py`) to
   see the register writes before listening.

## 11. Open questions

* What `$CA` was meant to do (its byte is stored in track+`$1E` and read by nothing) and what the note-end fields +`$27` / +`$28` (`$CD` 6, 7, `Param` 6) are for in full (a tail after the note is a HYPOTHESIS).
* The wave channel's volume (two-bit NR32 level from the envelope mirror) and the noise channel's pitch formula (04:4F2D) have only been read, not simulated.
* Byte 3 bits 4 and 0 and byte 4 bit 0 of the instruments: no reader found (HYPOTHESIS: unused).
* Which effects use the `<$80` flags branch of `SoundDrv_PlaySfx` (none in this data) and what priority `$C9`/`$D2` select in practice.
* Whether the set-1/set-2 pointers of the headers come from the authoring tool (loop point / end address) or are used by code that was never found: no reader was found in the driver (its only reads of header words are those of `SoundDrv_InitTrackRuntime`, through
  `wSoundDrv_HeaderPtr`); no search of the other banks for a reader was made.
* Are ids `$1E`-`$28` (eleven copies of song 1's record) reachable?  Callers use ids up to `$1D` and `$29`-`$48` (`naming_g1.md` section 7).
* Which songs/effects are which (the sound-test screen and callers give ids, not titles): the new names are by id only.

## 12. Differences from earlier notes

* `naming_g1.md`: "a stream header is `dw ?` (2 bytes) + one stream pointer per track" - the two bytes are `db tracks, db extra_sets` and the header is followed by 0 or 2 further word sets (section 3.2).
  "adjust (`$20`-`$23`)" - it adds 0-3 to the note's duration field.  The decode statistics agree (86 loops, 66 ends; wait 4868 and `$BE` 1109 in that note, 4871 and 1110 here because the 93 unreachable commands behind the
  final jumps are counted).  `SoundDrv_CmdRest` (04:4756) waits, it does not rest: no silence is produced by it; a note does not block the track.  The manifest of the second pass renames it `SoundDrv_CmdWait`.
  The hypothesis that `$C1` is a pitch offset (flag bit 2 = pitch update) was right and is now CONFIRMED (section 5); the earlier "modifier" byte of a note is the note's volume.
* First-pass statements that the second pass replaced: "the first operand of a note is `duration`, the third `mod`; how they are used when the gate ends is not proven" -> duration is the gate time, the third byte the note volume (section 4.3);
  "`sound_cmd_C0` .. `CA` neutral" -> named by effect except `$CA` (section 5); "the layout of a record of `Table_SoundDrv_Instruments` and of the third byte of `Table_SoundDrv_NoteFreq` entries unknown" -> sections 6 and 8.
  Nothing of the first pass was contradicted.
* `config/regions` / region headers of the music files: "content of individual commands unknown" and "data read as data by executed code": superseded by the decode above.
* `music_pointers.asm` region header: the record is described as words (`$FFC8`, `0001-0004`); as bytes it is priority `$C8`, flags `$FF`, track count, spare (the driver reads single bytes).
