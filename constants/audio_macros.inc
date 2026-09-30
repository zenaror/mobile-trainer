; constants/audio_macros.inc -- macros for the sound data of banks 04 and 05 (pre-included through includes.asm).
;
; Every macro emits exactly the bytes that the sound driver (bank 04, audio/engine.asm) reads; nothing here adds or reorders a
; byte.  Names are taken from the driver code only where the code demonstrates the behaviour; all other commands keep their
; opcode in the name (sound_cmd_C1 ...) and their argument is the raw byte.  The full evidence is in docs/research/audio_format.md
; (status: CONFIRMED / PROBABLE / HYPOTHESIS per construct), the generator of the macro form is tools/audio_to_macros.py.
;
; Stream (one per track), decoded by SoundDrv_ReadNextCommand (04:459B):
;   $81-$B0      wait: the duration table Table_SoundDrv_Durations (04:5044) value is the number of sequencer ticks
;   $B1          sound_end       stop the track
;   $B2 dw       sound_jump      continue at the address (same ROM bank as the stream)
;   $B3 dw       sound_call      push the return address (5 levels at most), continue at the address
;   $B4          sound_ret       pop the return address (a no-op when nothing was pushed)
;   $B5 db dw    sound_loop      counted loop, never used by the data
;   $BC-$CA db   one-byte commands
;   $CD db db    extended command (sub-command, argument), never used by the data
;   $CE, $D0-$FF sound_note      note with duration (0 for $CE, else the table value of index opcode-$CF) followed by up to
;                                three optional bytes: pitch ($24-$7F), modifier ($00-$1F), adjust ($20-$23)
;   $CF          sound_cmd_CF    optional pitch byte ($24-$7F)
;   a byte < $80 where a command is expected repeats the last opcode >= $BE ("running status"): sound_rs (below)
;
; Duration table: the operand of sound_wait / sound_note is the VALUE of Table_SoundDrv_Durations, not its index.  The 49 values
; below are the table bytes (audio/notes.asm); an operand that is not a table value is an assembly error.

DEF _sound_dur_idx = 0
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
; duration field is 0, SoundDrv_CmdNote entry 04:4A27)
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
; sound_note duration, pitch          : + pitch byte ($24-$7F, minus $24 is an index into Table_SoundDrv_NoteFreq)
; sound_note duration, pitch, mod     : + modifier byte (<$20, kept in track+$0A as (mod << 3) | 7)
; sound_note_mod duration, mod        : modifier without pitch
; The optional bytes may appear in any order in the stream and each class at most once (04:4A36-4A81); the data only
; contains pitch then modifier, the adjust bytes ($20-$23, added to the duration) are not used.
MACRO sound_note
	_sound_note_op \1
	IF _NARG > 1
		db \2
	ENDC
	IF _NARG > 2
		db \3
	ENDC
ENDM

MACRO sound_note_mod
	ASSERT _NARG == 2, "sound_note_mod duration, mod"
	_sound_note_op \1
	db \2
ENDM

; sound_cmd_CF [pitch] : opcode $CF, with an optional pitch byte ($24-$7F) like a note (SoundDrv_CmdNote entry 04:4B66, which
; calls SoundDrv_NoteGateExpired for the hardware channels of this track; used twice: bare in a reachable track of song $1A,
; with a pitch in an unreachable coda of song $11)
MACRO sound_cmd_CF
	_sound_op $CF
	IF _NARG > 0
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

; sound_cmd_C0 .. sound_cmd_CA value : the other one-byte commands.  Every handler stores the byte in a field of the track
; record (see docs/research/audio_format.md); what the fields mean is not proven, so the macros only name the opcode.
; $C7, $C8, $CB and $CC have no handler (they end the track) and $B6-$BB neither, so there is no macro for them.
MACRO _sound_cmd_1
	_sound_op \1
	db \2
ENDM

MACRO sound_cmd_C0
	ASSERT _NARG == 1, "sound_cmd_C0 value"
	_sound_cmd_1 $C0, \1
ENDM

MACRO sound_cmd_C1
	ASSERT _NARG == 1, "sound_cmd_C1 value"
	_sound_cmd_1 $C1, \1
ENDM

MACRO sound_cmd_C2
	ASSERT _NARG == 1, "sound_cmd_C2 value"
	_sound_cmd_1 $C2, \1
ENDM

MACRO sound_cmd_C3
	ASSERT _NARG == 1, "sound_cmd_C3 value"
	_sound_cmd_1 $C3, \1
ENDM

MACRO sound_cmd_C4
	ASSERT _NARG == 1, "sound_cmd_C4 value"
	_sound_cmd_1 $C4, \1
ENDM

MACRO sound_cmd_C5
	ASSERT _NARG == 1, "sound_cmd_C5 value"
	_sound_cmd_1 $C5, \1
ENDM

MACRO sound_cmd_C6
	ASSERT _NARG == 1, "sound_cmd_C6 value"
	_sound_cmd_1 $C6, \1
ENDM

MACRO sound_cmd_C9
	ASSERT _NARG == 1, "sound_cmd_C9 value"
	_sound_cmd_1 $C9, \1
ENDM

MACRO sound_cmd_CA
	ASSERT _NARG == 1, "sound_cmd_CA value"
	_sound_cmd_1 $CA, \1
ENDM

; sound_cmd_CD sub, value : extended command (SoundDrv_CmdExtended, 04:473E); sub-commands 1-7, 10 and 11 store `value` in a
; track field (Table_SoundDrv_ExtCommands, 04:4726), every other sub-command ends the track.  Never used by the data.
MACRO sound_cmd_CD
	ASSERT _NARG == 2, "sound_cmd_CD sub, value"
	_sound_op $CD
	db \1, \2
ENDM
