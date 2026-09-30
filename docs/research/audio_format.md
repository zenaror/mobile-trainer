# Sound data format (banks 04 and 05) and its macro form

The sound driver of bank 04 (`audio/engine.asm`, `SoundDrv_*`) plays 70 sound ids from 59 stream headers: 13 songs in bank 04 (ids `$01`-`$0D`), 16 songs in bank 05
(`$0E`-`$1D`), 30 sound effects in bank 05 (`$29`-`$46`), plus ids `$1E`-`$28`, which are eleven copies of the record of song 1.  This note re-derives the
format from the driver, records what is proven and what is only inferred, and documents the macros of [`constants/audio_macros.inc`](../../constants/audio_macros.inc)
in which `audio/music/*.asm`, `audio/sfx.asm` and `audio/music_pointers.asm` are now written (the bytes are unchanged: `make` still ends in `SHA-256 OK`).

Status words as in `STYLE.md`.  The earlier description is `naming_g1.md` section 7 (written by one agent from the same code); everything below was re-checked against the driver,
including by *running the driver code* (section 6), and the differences are listed in section 9.

## 1. Summary of the evidence

| question | result | status |
|---|---|---|
| layout of the 8-byte song record | `dw header, dw bank, db priority, db flags, db track count, db spare` | CONFIRMED (`SoundDrv_LoadSongHeader` 04:430A, `SoundDrv_StartTrack` 04:434C) |
| how a track's stream bytes are consumed (waits, notes, running status, flow commands, one-byte commands) | see section 4 | CONFIRMED for every construct the data uses (driver code executed on all 152 tracks), CONFIRMED by synthetic streams for the constructs it does not use |
| every byte of the stream ranges (04:574D-7E8C, 05:4000-68C3) explained | yes: 11916 commands + 59 headers, no unknown byte, no overlap, no ambiguous decoding | CONFIRMED (tool run) |
| what the parameters of the commands mean musically | only partly (section 5) | see the table there |
| two extra pointer sets in 22 headers (loop point, address after the final jump) | present in all 86 tracks of those headers | PROBABLE (never read by the driver; pattern in the data) |

## 2. Where the data is

| file | bank, range | content |
|---|---|---|
| `audio/music_pointers.asm` | 04:551D-574D | `Table_SoundDrv_Songs`: 70 records of 8 bytes, record of id *n* at `$5515 + 8*n` |
| `audio/music/music_01..0d.asm` | 04:574D-7E8C | streams and headers of songs 1-13 |
| `audio/music/music_0e..1d.asm` | 05:4000-631A | streams and headers of songs `$0E`-`$1D` |
| `audio/sfx.asm` | 05:631A-68C3 | streams and headers of effects `$29`-`$46` |
| `audio/notes.asm`, `audio/instruments.asm`, `audio/wave_samples.asm` | 04:5044-551D | duration table, frequency table, instrument table, wave patterns (tables the driver indexes; not converted) |

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
pointer, +4/+5 bank, +`$11` running status (last opcode >= `$BE`), +`$26` call depth, +`$29` loop counter.

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
| `$C0` | 1 | 04:4955 -> 04:49A2 | `(byte rotated left) - $80` into track+`$17`, flag bit 0 | `sound_cmd_C0` |
| `$C1` | 1 | 04:4896 | the same signed value into track+`$19`, multiplied with track+`$1A` into the 16-bit track+`$1B/$1C`, flag bit 2 | `sound_cmd_C1` |
| `$C2` | 1 | 04:48D5 | byte into track+`$1A`, recomputes the product as `$C1` | `sound_cmd_C2` |
| `$C3` | 1 | 04:48EC | byte into track+`$1F` (track+`$20` is also written when the byte is `$00` or `$80`) | `sound_cmd_C3` |
| `$C4` | 1 | 04:4925 -> 04:4973 | byte into track+`$2A` | `sound_cmd_C4` |
| `$C5` | 1 | 04:4970 -> 04:4973 | byte into track+`$21` | `sound_cmd_C5` |
| `$C6` | 1 | 04:4984 -> 04:4973 | byte into track+`$23`, flag bits 0-2 | `sound_cmd_C6` |
| `$C9` | 1 | 04:4997 -> 04:49A2 | `(byte rotated left) - $80` into track+`$1D`, flag bit 2 | `sound_cmd_C9` |
| `$CA` | 1 | 04:49B6 -> 04:4973 | byte into track+`$1E`, flag bit 2 | `sound_cmd_CA` |
| `$CD` | 2 (sub-command, argument) | `SoundDrv_CmdExtended` (04:473E) | sub-commands 1-7, 10, 11 (`Table_SoundDrv_ExtCommands`, 04:4726) store the argument in track+`$0C`, `$0D`, `$0E` (sub 1, 10, 11), in the high/low nibble of +`$0F` (2/3) or +`$10` (4/5), in +`$27` (6) or +`$28` (7); 0, 8, 9 and >= 12 end the track.  Never used | `sound_cmd_CD sub, value` |
| `$CE` | optional bytes as a note | 04:4A27 | note whose duration field is 0 | `sound_note 0, ...` |
| `$CF` | optional pitch byte | 04:4B66 | takes an optional pitch byte like a note (stored in track+`$09`), then walks the four channel records and calls `SoundDrv_NoteGateExpired` for those that belong to this track and whose counter is 0 (04:4B9D-4BC5) | `sound_cmd_CF [pitch]` |
| `$D0`-`$FF` | optional bytes (4.3) | `SoundDrv_CmdNote` | note; duration `Table_SoundDrv_Durations[opcode-$CF]` | `sound_note duration, ...` |

The one-byte handlers each perform exactly one `inc de` (all checked in `audio/engine.asm`); `$C1` has the rest of its mechanism (Mul8x8 of `|value|` and track+`$1A`) shared with `$C2`.

### 4.3 Notes (04:4A2B-4A81)

The opcode gives the duration (value of the table at index `opcode - $CF`, stored in track+`$0B`).  The bytes behind it are read in a loop until a byte with bit 7 set; each byte has a class and
**each class may occur once**: `$24`-`$7F` pitch (track+`$09`), `$00`-`$1F` modifier (track+`$0A` = `(byte << 3) | 7`), `$20`-`$23` adjust (added to track+`$0B`, i.e. to the duration).  They may come
in any order (synthetic streams); a second byte of a class ends the note *without consuming it*, and it is then read as a data byte, i.e. re-triggers the same note by running status.
The data uses pitch, pitch + modifier, modifier only, and no byte at all (4325 notes: 2311 + 1381 + 329 + 304), never adjust bytes, and always pitch before modifier.

`SoundDrv_StartNote` (04:4A81) then forms `pitch + track+$12`; `SoundDrv_WriteChannelPitch` -> `SoundDrv_NoteToIndex` (04:4FEA) subtracts `$24` (clamp 0..`$77`) and indexes
`Table_SoundDrv_NoteFreq` (120 entries of word + byte, 12 per octave, index 0 = `$002C` = 65.4 Hz).  So a pitch byte is a semitone number, `$24` the lowest; for the wave channel `SoundDrv_WriteChannelPitch` (04:4ECA) adds `$0C`
(so the same byte sounds an octave up in the table, compensating the channel's octave), and the noise channel uses a different formula (04:4F2D).  In the data the pitch bytes
range over `$24`-`$7F` and `sound_pitch_add` is `$00` (145 tracks) or `$F4` (7 times, = -12 as a signed byte, one octave).

What is **not** proven: how the modifier byte (`(v << 3) | 7`, copied into the channel record with the instrument bytes) and the note duration field are used when the gate ends
(`SoundDrv_ServiceChannel*`, `SoundDrv_NoteGateExpired` 04:4BFC).  The macros therefore call the first operand `duration` (the value of the table the driver reads), the pitch `pitch` (an index of the
frequency table) and the third `mod`.  The duration is **not** the time until the next command: a note does not block the track, only waits do.

### 4.4 Usage in the data (11916 commands, 19716 bytes)

wait 4871, note 4325 (1241 by running status), `$BE` 1110 (6 by running status), `$C1` 550 (101), `$B3` 276, `$BF` 152, `$BD` 152, `$B4` 113, `$B2` 86, `$B1` 152 (66 reached), `$BC` 59,
`$C2` 19, `$C5` 18, `$C3` 17, `$C4` 14, `$CF` 2, never `$B5`, `$C0`, `$C6`, `$C9`, `$CA`, `$CD`.  All 152 tracks start `BF $7F BD vv` (`BD` occurs only there: `$00` in 145 tracks, `$F4` in 7) -
"volume" and "pitch add" are set first in every track.  `BE $64` (per-note instrument mode, the drum tracks) occurs 27 times, 45 distinct `BE` operands (including `$64`) are used.
Durations used: 39 different values in waits, 27 (0 included) in notes.

## 5. Names in the macros: what the driver proves

| name | status | why |
|---|---|---|
| `sound_wait`, `sound_end`, `sound_jump`, `sound_call`, `sound_ret`, `sound_loop`, `sound_note` (+ `_mod`), `sound_rs` | CONFIRMED | the code path consumes exactly these bytes and does what the name says (waits block the track, notes do not) |
| `sound_tempo` | CONFIRMED | the byte becomes the group tempo that the frame tick multiplies (`SoundDrv_UpdateTempoStep`) |
| `sound_instrument` | PROBABLE | record of a table whose bytes end up in the channel's duty/length/sweep/envelope registers (`SoundDrv_WriteChannelParams`); the record layout is not decoded |
| `sound_volume` | PROBABLE | sets the dirty flag that leads to `SoundDrv_WriteChannelVolume`; the nibble arithmetic of `SoundDrv_UpdateChannel` is not decoded |
| `sound_pitch_add` | CONFIRMED (arithmetic), PROBABLE (signed transposition) | added to the pitch byte at every note start; the value `$F4` occurring 7 times suggests a signed semitone offset |
| `sound_cmd_C0` .. `sound_cmd_CA`, `sound_cmd_CD`, `sound_cmd_CF` | neutral | byte layout CONFIRMED, meaning unknown; see the field list above (the hypothesis in `naming_g1.md` that `$C1` is a pitch offset is consistent with flag bit 2 = pitch update and stays a HYPOTHESIS) |
| `sound_stream_header` | PROBABLE | the driver ignores the two bytes |

## 6. How the decoding was verified

1. **Static, whole ROM** (`tools/audio_to_macros.py`): decodes every track of every header by simulating the control flow of `SoundDrv_ReadNextCommand` (state = address, running status, call
   stack; jump taken, call pushes, return pops, `$B5` both ways) starting at every set-0 pointer, then at the set-2 addresses.  Result: 70 records, 59 headers, 11916 commands, 19716 bytes = the two stream ranges
   04:574D-7E8C and 05:4000-68C3 completely, no unknown opcode, no overlap, no address decoded two ways, no command of size 0.  Every decoded command re-encodes from its fields to the ROM bytes.
2. **Dynamic, driver code** (`tools/audio_driver_check.py`, a few minutes; `--quick` seconds): a small SM83 interpreter runs `SoundDrv_Init` and `SoundDrv_StepTrack` of the original ROM on all 152 tracks
   (the bank-switching stream readers `00:215E/216F` are replaced by plain reads).  The command addresses the driver starts to decode and the (counter, stream pointer) it stores after every
   wait are **identical** to the decoder's for all 152 tracks (about 300000 commands run by the driver code); 5867 + 5956 of the 11916 commands are executed, the other 93 are exactly the ones behind a track's final jump
   (86 `$B1` and 7 further commands in three codas).  66 tracks run into `$B1`; 86 loop through their `$B2`.
3. **Synthetic streams** (same script): 36 hand-made streams check the constructs the data does not use - adjust bytes, byte order and duplicate classes of notes, `$CE`, `$CF` (with and without pitch), `$B5`
   (count 0, 1, 3), `$CD` sub-commands, the ten opcodes without handler, `$80`, `$B4` on an empty stack, running status after `$BE`/`$C1`, opcodes < `$BE` not updating it, and a call depth of 4-7 (limit 5).
   The driver and the decoder agree on all of them.
4. **Build**: `make` -> `SHA-256 OK`, byte compare `IDENTICAL`, no new `rgbasm` warning; `make sym-check` OK.

Limits: the emulation starts from a freshly initialised driver with all other tracks inactive and proves how stream bytes are consumed, not what the sound is.  The interpreter is only tested by
this agreement.  The emulator does not prove what the dirty flags and track fields finally do to the APU; those are the open questions below.  A single execution does not prove general behaviour:
the claims about never-used constructs rest on the synthetic streams.

## 7. The macro form

`constants/audio_macros.inc` is pre-included (`includes.asm`).  Every macro emits exactly the bytes of section 4; the operand of `sound_wait` / `sound_note` is the **value** of
`Table_SoundDrv_Durations` (49 values, listed in the include and checked against the ROM table by the tool); a value that is not in the table is an assembly error.

```asm
Data_04_58C6:: ; 04:58C6            ; start of a track
	sound_volume $7F
	sound_pitch_add $00
Data_04_58CA:: ; 04:58CA            ; loop point, target of the final sound_jump
	sound_tempo $4F
	sound_instrument $00
	sound_wait 24
	sound_note 3, $3F, $13         ; duration 3, pitch $3F, modifier $13
	sound_wait 3
	sound_rs sound_note 9, $3F     ; running status: the opcode byte is omitted
	...
	sound_jump Data_04_58CA
Data_04_593C:: ; 04:593C
	sound_end                       ; never reached: behind the final jump (address listed in the header)
```

* `sound_rs <macro>` omits the opcode byte of the macro that follows; the driver re-uses the last opcode >= `$BE`.  The tool writes it only where the decode shows that this opcode is the one the
  macro stands for (same decoding in every flow state), and the assembler refuses it for opcodes < `$BE`.
* Labels: every header, track start, loop target, jump/call target and pointer word uses a label.  Labels that already existed were kept (and used); the 333 that were missing are `Data_BB_AAAA:: ; BB:AAAA`
  in the file that contains the address (only targets got one).  In `music_02` ... `music_0d` and `sfx` the section start has a label now.
* The region header comments (`; ---- data $A-$B ... [PROBABLE] ... content of individual commands unknown`) are kept unchanged; they record the state before the decode and are superseded by this note.
* **Bytes left as `db` (15 bytes in 7 commands)**: a command that a pre-existing label boundary cuts in two cannot be one macro.  The labels (`Data_05_5B34`, `5B6D`... ; `Data_05_68BE`) are artifacts of the coverage
  pieces (`config/regions/bank05.tsv`: "unread interior", "UNCLASSIFIED") that fall between a command's opcode and its operand; they are kept (nothing references them), so these commands stay as `db`
  with a comment that names the macro they form: `music_19` (4 commands, 9 bytes: a note opcode or `BE` at the end of a block), `music_1a` (2 notes, 4 bytes), `sfx` (the 2-byte header `02 00` of effect `$46`, split by `Data_05_68BE`).

### Regenerating and checking

```
python3 tools/audio_to_macros.py --check       # decode + verify; exit 1 when a file is not in the form the tool writes
python3 tools/audio_to_macros.py               # rewrite, make, SHA-256 + sym_check, restore every file on failure
python3 tools/audio_driver_check.py [--quick]  # run the driver code on the streams (section 6)
```

The tool is idempotent (a second run changes nothing) and works on a copy with `--root DIR`.  It reads the original ROM (`baserom.gbc`, must match `roms.sha256`) and never writes it.

## 8. Open questions

* The fields of the track record that the commands `$C0`-`$CA`, `$CD` set (`+$17`, `$19`-`$1F`, `$21`, `$23`, `$27`, `$28`, `$2A`) and what `SoundDrv_ComputeTrackOutput` / `SoundDrv_UpdateChannel` do with them (vibrato / detune / envelope / pan
  are all conceivable; none is demonstrated).  `$C1`/`$C2` (signed value times a factor into a 16-bit result + "pitch" flag) is the best-supported guess for a pitch offset.
* The layout of a record of `Table_SoundDrv_Instruments` (6 bytes; the first five are copied into the track) and of the third byte of `Table_SoundDrv_NoteFreq` entries.
* The use of the modifier byte `(v << 3) | 7` and of the note duration field after the note starts (gate length?).
* Which effects use the `<$80` flags branch of `SoundDrv_PlaySfx` (none in this data) and what priority `$C9`/`$D2` select in practice.
* Whether the set-1/set-2 pointers of the headers come from the authoring tool (loop point / end address) or are used by code that was never found: no reader was found in the driver (its only reads of header words are those of `SoundDrv_InitTrackRuntime`, through
  `wSoundDrv_HeaderPtr`); no search of the other banks for a reader was made.
* Are ids `$1E`-`$28` (eleven copies of song 1's record) reachable?  Callers use ids up to `$1D` and `$29`-`$48` (`naming_g1.md` section 7).

## 9. Differences from earlier notes

* `naming_g1.md`: "a stream header is `dw ?` (2 bytes) + one stream pointer per track" - the two bytes are `db tracks, db extra_sets` and the header is followed by 0 or 2 further word sets (section 3.2).
  "adjust (`$20`-`$23`)" - it adds 0-3 to the note's duration field.  The decode statistics agree (86 loops, 66 ends; wait 4868 and `$BE` 1109 in that note, 4871 and 1110 here because the 93 unreachable commands behind the
  final jumps are counted).  `SoundDrv_CmdRest` (04:4756) waits, it does not rest: no silence is produced by it; a note does not block the track.  The label was not renamed here (`audio/engine.asm` is outside this change).
* `config/regions` / region headers of the music files: "content of individual commands unknown" and "data read as data by executed code": superseded by the decode above.
* `music_pointers.asm` region header: the record is described as words (`$FFC8`, `0001-0004`); as bytes it is priority `$C8`, flags `$FF`, track count, spare (the driver reads single bytes).
