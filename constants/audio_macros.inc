; constants/audio_macros.inc -- macros for the sound data of banks 04 and 05 (pre-included through includes.asm).
;
; Every macro emits exactly the bytes that the sound driver (bank 04, audio/engine.asm) reads; nothing here adds or reorders a
; byte.  Names are taken from the driver code only where the code demonstrates the behaviour (by reading it and by running the
; driver code on synthetic streams, tools/audio_driver_check.py); a command whose effect is not demonstrated keeps its opcode in
; the name (sound_cmd_CA, sound_cmd_CD) and its argument is the raw byte.  The full evidence is in docs/research/audio_format.md
; (status: CONFIRMED / PROBABLE / HYPOTHESIS per construct), the generator of the macro form is tools/audio_to_macros.py.
;
; Stream (one per track), decoded by SoundDrv_ReadNextCommand (04:459B):
;   $81-$B0      wait: the duration table Table_SoundDrv_Durations (04:5044) value is the number of sequencer ticks
;   $B1          sound_end       stop the track
;   $B2 dw       sound_jump      continue at the address (same ROM bank as the stream)
;   $B3 dw       sound_call      push the return address (5 levels at most), continue at the address
;   $B4          sound_ret       pop the return address (a no-op when nothing was pushed)
;   $B5 db dw    sound_loop      counted loop, never used by the data
;   $BC-$CA db   one-byte commands (tempo, pitch add, instrument, volume, pan, pitch bend, vibrato, detune ...)
;   $CD db db    extended command (sub-command, argument), never used by the data
;   $CE, $D0-$FF sound_note      note with duration (0 for $CE, else the table value of index opcode-$CF) followed by up to
;                                three optional bytes: pitch ($24-$7F), volume ($00-$1F), adjust ($20-$23)
;   $CF          sound_note_off  release of the held note of a pitch; optional pitch byte ($24-$7F)
;   a byte < $80 where a command is expected repeats the last opcode >= $BE ("running status"): sound_rs (below)
;
; Duration table: the operand of sound_wait / sound_note is the VALUE of Table_SoundDrv_Durations, not its index.  The 49 values
; below are the table bytes (audio/notes.asm, written with sound_durations, which checks every entry against this list); an
; operand that is not a table value is an assembly error.

DEF _sound_dur_idx = 0
DEF _sound_dur_pos = 0
DEF _sound_rs = 0

MACRO _sound_dur_def
	REPT _NARG
		DEF _sound_t = \1
		DEF _SOUND_DUR_{d:_sound_t} EQU _sound_dur_idx
		DEF _sound_dur_idx += 1
		SHIFT
	ENDR
ENDM

	_sound_dur_def 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24
	_sound_dur_def 28, 30, 32, 36, 40, 42, 44, 48, 52, 54, 56, 60, 64, 66, 68, 72, 76, 78, 80, 84, 88, 90, 92, 96

; _sound_op $op : the opcode byte, unless the macro is the target of sound_rs (then the driver must be given a data byte
; there: it re-uses the last opcode >= $BE, so only opcodes >= $BE can be written that way)
MACRO _sound_op
	IF _sound_rs
		ASSERT (\1) >= $BE, "running status only repeats opcodes >= $BE"
		DEF _sound_rs = 0
	ELSE
		db \1
	ENDC
ENDM

; sound_rs <macro and its arguments> : running status.  The following macro omits its opcode byte; the driver takes the
; first data byte as the first argument of the last opcode >= $BE that it executed (SoundDrv_ReadNextCommand, 04:45B6-45C0:
; only an opcode byte >= $BE is stored in track+$11, a byte with bit 7 clear re-uses it).  The macro that follows must be the
; same command as that last opcode; the generator tools/audio_to_macros.py checks this by decoding the stream.
MACRO sound_rs
	ASSERT _sound_rs == 0, "sound_rs cannot be nested"
	DEF _sound_rs = 1
	\#
ENDM

; ---- song table and stream header ----------------------------------------------------------------------------------

; sound_song Header, priority, flags, tracks : one 8-byte record of Table_SoundDrv_Songs (04:551D), read by
; SoundDrv_LoadSongHeader (04:430A): dw header address, dw ROM bank of the header and of the streams (BANK(Header)),
; db priority (track+8), db flags, db track count, db spare (never read by the driver, $00 in all 70 records)
MACRO sound_song
	ASSERT _NARG == 4, "sound_song Header, priority, flags, tracks"
	dw \1
	dw BANK(\1)
	db \2, \3, \4, $00
ENDM

; sound_stream_header tracks, extra_sets : the two bytes at the start of a stream header.  The driver skips them (it only
; uses the track count of the song record); in all 59 headers byte 0 equals that count and byte 1 is the number of pointer
; sets that follow the first one (0 or 2).  The header continues with (extra_sets + 1) sets of `tracks` words:
;   set 0 = the stream address of every track (read by SoundDrv_InitTrackRuntime),
;   set 1 and 2 (only when extra_sets = 2, never read by the driver) = the target and the address after the track's final
;   sound_jump (verified on all 86 tracks that have them).
MACRO sound_stream_header
	ASSERT _NARG == 2, "sound_stream_header tracks, extra_sets"
	db \1, \2
ENDM

; ---- timing -----------------------------------------------------------------------------------------------------------

; sound_wait ticks : wait for that many ticks ($80 + index in the duration table; 0 is $80, which the driver skips at once)
MACRO sound_wait
	ASSERT _NARG == 1, "sound_wait ticks"
	DEF _sound_t = \1
	ASSERT DEF(_SOUND_DUR_{d:_sound_t}), "not a value of Table_SoundDrv_Durations"
	_sound_op $80 + _SOUND_DUR_{d:_sound_t}
ENDM

; ---- notes ---------------------------------------------------------------------------------------------------------------

; _sound_note_op duration : $CF + index of the duration in the table ($D0-$FF); duration 0 is written as $CE (a note whose
; duration field is 0, SoundDrv_CmdNoteHeld, 04:4A27)
MACRO _sound_note_op
	DEF _sound_t = \1
	ASSERT DEF(_SOUND_DUR_{d:_sound_t}), "not a value of Table_SoundDrv_Durations"
	IF _sound_t == 0
		_sound_op $CE
	ELSE
		_sound_op $CF + _SOUND_DUR_{d:_sound_t}
	ENDC
ENDM

; sound_note duration                 : note with no optional byte
; sound_note duration, pitch          : + pitch byte ($24-$7F; minus $24 is an index into Table_SoundDrv_NoteFreq, one semitone per step)
; sound_note duration, pitch, vol     : + volume byte (<$20, kept in track+$0A as (vol << 3) | 7)
; sound_note_vol duration, vol        : volume without pitch
; `duration` is the gate time: the note is released that many ticks after it starts (duration 0 = held until sound_note_off
; or the end of the track).  It does NOT delay the next command (only sound_wait does).  `vol` is multiplied with the track
; volume (sound_volume) to give the volume nibble of the channel's NRx2 register and stays in force for the following notes.
; The optional bytes may appear in any order in the stream and each class at most once (04:4A36-4A81); the data only
; contains pitch then volume, the adjust bytes ($20-$23, added to the duration) are not used.
MACRO sound_note
	_sound_note_op \1
	IF _NARG > 1
		ASSERT (\2) >= $24 && (\2) <= $7F, "sound_note pitch is $24-$7F (a smaller byte would be read as a volume or adjust byte)"
		db \2
	ENDC
	IF _NARG > 2
		ASSERT (\3) >= 0 && (\3) <= $1F, "sound_note volume is $00-$1F (a larger byte would be read as a pitch or adjust byte)"
		db \3
	ENDC
ENDM

MACRO sound_note_vol
	ASSERT _NARG == 2, "sound_note_vol duration, vol"
	ASSERT (\2) >= 0 && (\2) <= $1F, "sound_note_vol volume is $00-$1F"
	_sound_note_op \1
	db \2
ENDM

; sound_note_off [pitch] : opcode $CF (SoundDrv_CmdNoteOff, 04:4B66), with an optional pitch byte ($24-$7F) like a note.  It
; releases (SoundDrv_NoteGateExpired) the first channel of this track that holds a note (duration 0) started with that pitch byte
; (the pitch also gets the pitch add, like a note's); without the byte the pitch of the last note is used.  Used twice: bare in a
; reachable track of song $1A, with a pitch in an unreachable coda of song $11.  A byte $00-$23 right after $CF is neither a pitch
; nor consumed: running status dispatches $CF again for ever and the frame tick never returns (hence the assert).
MACRO sound_note_off
	_sound_op $CF
	IF _NARG > 0
		ASSERT (\1) >= $24 && (\1) <= $7F, "sound_note_off pitch is $24-$7F (a smaller byte hangs the driver)"
		db \1
	ENDC
ENDM

; ---- flow ---------------------------------------------------------------------------------------------------------------

MACRO sound_end
	_sound_op $B1
ENDM

MACRO sound_jump
	ASSERT _NARG == 1, "sound_jump Label"
	_sound_op $B2
	dw \1
ENDM

MACRO sound_call
	ASSERT _NARG == 1, "sound_call Label"
	_sound_op $B3
	dw \1
ENDM

MACRO sound_ret
	_sound_op $B4
ENDM

; sound_loop count, Label : counted loop (SoundDrv_CmdRepeat, 04:47C5); count 0 always jumps.  Never used by the data.
MACRO sound_loop
	ASSERT _NARG == 2, "sound_loop count, Label"
	_sound_op $B5
	db \1
	dw \2
ENDM

; ---- one-byte commands ---------------------------------------------------------------------------------------------------

; sound_tempo value      $BC  sets the group tempo (SoundDrv_CmdSetTempo, 04:47E3)
; sound_pitch_add value  $BD  stored in track+$12, added to the pitch byte of every note that starts afterwards (04:4A81-4A8D)
; sound_instrument id    $BE  copies record `id` of Table_SoundDrv_Instruments (04:51DD, 6 bytes) into the track
;                             (SoundDrv_CmdSetInstrument, 04:484E); id $64 selects the per-note instrument mode instead
; sound_volume value     $BF  stores the value (rotated left) in track+$15 and marks the volume as changed (04:492A)
DEF SOUND_INSTRUMENT_PER_NOTE EQU $64

MACRO sound_tempo
	ASSERT _NARG == 1, "sound_tempo value"
	_sound_op $BC
	db \1
ENDM

MACRO sound_pitch_add
	ASSERT _NARG == 1, "sound_pitch_add value"
	_sound_op $BD
	db \1
ENDM

MACRO sound_instrument
	ASSERT _NARG == 1, "sound_instrument id"
	_sound_op $BE
	db \1
ENDM

MACRO sound_volume
	ASSERT _NARG == 1, "sound_volume value"
	_sound_op $BF
	db \1
ENDM

; The other one-byte commands set a field of the track record that SoundDrv_ComputeTrackOutput / SoundDrv_UpdateChannel turn into
; channel registers.  $C7, $C8, $CB and $CC have no handler (they end the track) and $B6-$BB neither, so there is no macro for them.
; Status and evidence of every one of them: docs/research/audio_format.md section 5.
MACRO _sound_cmd_1
	_sound_op \1
	db \2
ENDM

; sound_pan value       $C0  0-$7F, $40 = centre: the sound of this track goes to the left terminal only (0-$1F), both (<= $5F) or the
;                            right terminal only ($60-$7F); written to the channel's bits of NR51.  Never used by the data
MACRO sound_pan
	ASSERT _NARG == 1, "sound_pan value"
	ASSERT (\1) >= 0 && (\1) <= $7F, "sound_pan value is 0-$7F (the code computes rotl(value) - $80)"
	_sound_cmd_1 $C0, \1
ENDM

; sound_pitch_bend value        $C1  0-$7F, $40 = none: pitch offset of (value - $40) * scale / 64 semitones for value >= $40, and that plus scale / 256
;                                    semitone below (the code multiplies the one's complement, 04:48B9-48C5); scale: sound_pitch_bend_scale, 2 at start
; sound_pitch_bend_scale scale  $C2  the factor of the pitch bend (a byte; $04-$30 in the data)
MACRO sound_pitch_bend
	ASSERT _NARG == 1, "sound_pitch_bend value"
	ASSERT (\1) >= 0 && (\1) <= $7F, "sound_pitch_bend value is 0-$7F (the code computes rotl(value) - $80)"
	_sound_cmd_1 $C1, \1
ENDM

MACRO sound_pitch_bend_scale
	ASSERT _NARG == 1, "sound_pitch_bend_scale scale"
	_sound_cmd_1 $C2, \1
ENDM

; sound_vibrato_rate value   $C3  phase step per tick of the triangle wave that drives the vibrato ($17 at start)
; sound_vibrato_delay ticks  $C4  ticks after every note start during which the vibrato is held back (0 at start)
; sound_vibrato_depth value  $C5  depth: peak-to-peak deviation of value * 8 / 256 semitones (0 = no vibrato, at start)
; sound_vibrato_disable v    $C6  a nonzero value leaves the vibrato out of the pitch (0 at start = vibrato applied)
MACRO sound_vibrato_rate
	ASSERT _NARG == 1, "sound_vibrato_rate value"
	_sound_cmd_1 $C3, \1
ENDM

MACRO sound_vibrato_delay
	ASSERT _NARG == 1, "sound_vibrato_delay ticks"
	_sound_cmd_1 $C4, \1
ENDM

MACRO sound_vibrato_depth
	ASSERT _NARG == 1, "sound_vibrato_depth value"
	_sound_cmd_1 $C5, \1
ENDM

MACRO sound_vibrato_disable
	ASSERT _NARG == 1, "sound_vibrato_disable value"
	_sound_cmd_1 $C6, \1
ENDM

; sound_detune value  $C9  0-$7F, $40 = none: pitch offset of (value - $40) / 64 semitones, added to the bend.  Never used by the data
MACRO sound_detune
	ASSERT _NARG == 1, "sound_detune value"
	ASSERT (\1) >= 0 && (\1) <= $7F, "sound_detune value is 0-$7F (the code computes rotl(value) - $80)"
	_sound_cmd_1 $C9, \1
ENDM

; sound_cmd_CA value  $CA  stores the byte in track+$1E and marks the pitch as changed; nothing reads track+$1E (effect not demonstrated)
MACRO sound_cmd_CA
	ASSERT _NARG == 1, "sound_cmd_CA value"
	_sound_cmd_1 $CA, \1
ENDM

; sound_cmd_CD sub, value : extended command (SoundDrv_CmdExtended, 04:473E).  Sub-commands 1-7, 10 and 11 store `value` in a field of
; the track record (Table_SoundDrv_ExtCommands, 04:4726), every other sub-command ends the track.  Never used by the data.
;   sub 1, 10, 11   the bytes 0, 1, 2 of the instrument copy in the track (track+$0C..$0E: channel class + duty / wave / noise width,
;                   length, sweep), as sound_instrument would have copied them, for the notes that follow
;   sub 2, 3        high / low nibble of byte 3 of the instrument copy (track+$0F); sub 4, 5: the same for byte 4 (track+$10); the nibble
;                   stored is the low nibble of `value` in both variants
;   sub 6, 7        track+$27 / track+$28, read by the channel code when a note has run out (SoundDrv_UpdateChannel, 04:4D66 / 04:4D68):
;                   the level (high nibble of +$27) and the length ((256 - +$28) * 15 ticks) of a constant-volume tail after the note,
;                   no tail when one of them is 0.  PROBABLE, demonstrated (synthetic) on mGBA: docs/research/audio_format.md section 5.1
MACRO sound_cmd_CD
	ASSERT _NARG == 2, "sound_cmd_CD sub, value"
	_sound_op $CD
	db \1, \2
ENDM

; ---- tables read by the driver (audio/notes.asm, audio/instruments.asm, audio/wave_samples.asm) ---------------------------

; sound_durations v, ... : entries of Table_SoundDrv_Durations (04:5044, 49 bytes), the ticks of a wait / the gate time of a note; every entry
; is checked against the index list of _sound_dur_def above, so the two cannot drift apart
MACRO sound_durations
	REPT _NARG
		DEF _sound_t = \1
		ASSERT DEF(_SOUND_DUR_{d:_sound_t}), "not a value of the duration list"
		ASSERT _SOUND_DUR_{d:_sound_t} == _sound_dur_pos, "duration table entry out of order"
		db \1
		DEF _sound_dur_pos += 1
		SHIFT
	ENDR
ENDM

; sound_note_freq period, step : a 3-byte record of Table_SoundDrv_NoteFreq (04:5075, 120 records, index = pitch byte - $24, one semitone per
; record).  `period` is the 11-bit period value of the note (low byte NRx3, high 3 bits NRx4); `step` is the per-semitone increment that
; SoundDrv_WriteChannelPitch multiplies with the fractional part (1/256 semitone) of the pitch offset and adds to the period.  All 120 periods are
; within 1 of the equal-tempered value for MIDI note 36 + index (A4 = 440 Hz), and step is the next record's period minus this one's, within 1.
MACRO sound_note_freq
	ASSERT _NARG == 2, "sound_note_freq period, step"
	ASSERT (\1) >= 0 && (\1) <= $7FF, "a period is 11 bits"
	dw \1
	db \2
ENDM

; The 6-byte records of Table_SoundDrv_Instruments (04:51DD, 112 records; the id of sound_instrument indexes it).  sound_instrument copies
; bytes 0-4 to the track; the first note that follows moves them to the hardware channel; byte 0 selects the channel:
; byte 0 < $08 pulse 1 (bits 0-1 duty), $08-$0F pulse 2 (bits 0-1 duty), $10-$3F wave (byte - $10 = pattern of Table_SoundDrv_WavePatterns),
; >= $40 noise (bit 0 = NR43 bit 3, the 7-bit counter).  Byte 1 is the length (0 = none, else NRx1 gets -length and NRx4 bit 6 is set), byte 2
; goes to the register two below NRx1 (NR10 for pulse 1, FF15 = the unused NR20 for pulse 2; the wave and noise paths do not write it; $00 in all 112 records).  Bytes 3 and 4 are the volume envelope (`env_a`, `env_b`; bits:
; env_a 7-5 attack, 3-1 decay, env_b 7-4 sustain, 3-1 release, see docs/research/audio_format.md section 7).  Byte 5 is read only by the
; per-note mode (sound_instrument SOUND_INSTRUMENT_PER_NOTE: record $40 + pitch, records $64-$6F): it replaces the pitch of the note.
MACRO _sound_instr
	db \1, \2, \3, \4, \5, \6
ENDM

; sound_instr_pulse1 duty, length, sweep, env_a, env_b, pitch
MACRO sound_instr_pulse1
	ASSERT _NARG == 6, "sound_instr_pulse1 duty, length, sweep, env_a, env_b, pitch"
	ASSERT (\1) >= 0 && (\1) <= 3, "duty is 2 bits"
	_sound_instr \1, \2, \3, \4, \5, \6
ENDM

; sound_instr_pulse2 duty, length, env_a, env_b, pitch   (byte 2 is $00)
MACRO sound_instr_pulse2
	ASSERT _NARG == 5, "sound_instr_pulse2 duty, length, env_a, env_b, pitch"
	ASSERT (\1) >= 0 && (\1) <= 3, "duty is 2 bits"
	_sound_instr $08 | (\1), \2, $00, \3, \4, \5
ENDM

; sound_instr_wave wave, length, env_a, env_b, pitch     (byte 2 is $00; wave = index in Table_SoundDrv_WavePatterns)
MACRO sound_instr_wave
	ASSERT _NARG == 5, "sound_instr_wave wave, length, env_a, env_b, pitch"
	ASSERT (\1) >= 0 && (\1) <= 9, "wave pattern is 0-9 (Table_SoundDrv_WavePatterns has 10 patterns)"
	_sound_instr $10 + (\1), \2, $00, \3, \4, \5
ENDM

; sound_instr_noise width, length, env_a, env_b, pitch   (byte 2 is $00; width = bit 0 of byte 0: 1 = 7-bit counter)
MACRO sound_instr_noise
	ASSERT _NARG == 5, "sound_instr_noise width, length, env_a, env_b, pitch"
	ASSERT (\1) >= 0 && (\1) <= 1, "width is 1 bit"
	_sound_instr $40 | (\1), \2, $00, \3, \4, \5
ENDM

; sound_instr_raw b0, b1, b2, b3, b4, b5 : a record that none of the four forms above writes exactly (none at present)
MACRO sound_instr_raw
	ASSERT _NARG == 6, "sound_instr_raw b0, b1, b2, b3, b4, b5"
	_sound_instr \1, \2, \3, \4, \5, \6
ENDM

; sound_wave_pattern s0 .. s31 : one 16-byte pattern of Table_SoundDrv_WavePatterns (04:547D, 10 patterns), copied unchanged to wave RAM
; ($FF30-$FF3F) when a wave-channel instrument needs it.  Each byte holds two 4-bit samples, the high nibble first in the hardware,
; so the macro takes the 32 samples in playing order and packs them in pairs.
MACRO sound_wave_pattern
	ASSERT _NARG == 32, "sound_wave_pattern takes 32 samples"
	REPT 16
		ASSERT (\1) >= 0 && (\1) <= 15 && (\2) >= 0 && (\2) <= 15, "a wave sample is 4 bits"
		db ((\1) << 4) | (\2)
		SHIFT 2
	ENDR
ENDM
