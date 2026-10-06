; audio/music/music_03.asm
; bank 04, $5CD9-$5F0E (565 bytes); pinned by layout.link
; song id 03

SECTION "audio/music/music_03", ROMX

; ---- data $5CD9-$5F0E (565 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; commands decoded (docs/research/audio_format.md) (part of region $574D-$7E8C)

SoundSong03_Track0:: ; 04:5CD9
Data_04_5CD9::
	sound_volume $7F
	sound_pitch_add $00
SoundSong03_Track0_Loop:: ; 04:5CDD
Data_04_5CDD::
	sound_tempo $54
	sound_instrument $1E
	sound_vibrato_depth $18
	sound_vibrato_rate $18
	sound_vibrato_delay $20
	sound_pitch_bend $33
	sound_note 72, $42, $14
	sound_wait 3
	sound_pitch_bend $40
	sound_wait 80
	sound_wait 1
	sound_note 96, $40
	sound_wait 12
	sound_wait 96
	sound_note 12, $42
	sound_wait 24
	sound_note 12
	sound_wait 24
	sound_note 12
	sound_wait 12
	sound_pitch_bend $33
	sound_note 12
	sound_wait 3
	sound_pitch_bend $40
	sound_wait 21
	sound_note 96, $40
	sound_wait 12
	sound_wait 96
	sound_pitch_bend $33
	sound_note 72, $44
	sound_wait 3
	sound_pitch_bend $40
	sound_wait 80
	sound_wait 1
	sound_note 96, $42
	sound_wait 12
	sound_wait 96
	sound_note 12, $44
	sound_wait 24
	sound_note 12
	sound_wait 24
	sound_note 12
	sound_wait 12
	sound_pitch_bend $33
	sound_note 12
	sound_wait 3
	sound_pitch_bend $40
	sound_wait 21
	sound_note 96, $42
	sound_wait 12
	sound_wait 96
	sound_jump SoundSong03_Track0_Loop
SoundSong03_Track0_AfterJump:: ; 04:5D29
Data_04_5D29::
	sound_end
SoundSong03_Track1:: ; 04:5D2A
Data_04_5D2A::
	sound_volume $7F
	sound_pitch_add $00
SoundSong03_Track1_Loop:: ; 04:5D2E
Data_04_5D2E::
	sound_instrument $04
	sound_wait 24
	sound_note 12, $4A, $15
	sound_wait 36
	sound_note 12
	sound_wait 36
	sound_note 12, $49
	sound_wait 36
	sound_note 12
	sound_wait 36
	sound_note 12
	sound_wait 24
	sound_wait 24
	sound_note 12, $4A
	sound_wait 36
	sound_note 12
	sound_wait 36
	sound_note 12, $49
	sound_wait 36
	sound_note 12
	sound_wait 24
	sound_note 12
	sound_wait 36
SoundSong03_Track1_Sub1:: ; 04:5D4B
Data_04_5D4B::
	sound_wait 24
	sound_note 12, $4C, $15
	sound_wait 36
	sound_note 12
	sound_wait 36
	sound_ret
	sound_note 12, $4B
	sound_wait 36
	sound_note 12
	sound_wait 36
	sound_note 12
	sound_wait 24
	sound_call SoundSong03_Track1_Sub1
	sound_note 12, $4B, $15
	sound_wait 36
	sound_note 12
	sound_wait 24
	sound_note 12
	sound_wait 36
	sound_jump SoundSong03_Track1_Loop
SoundSong03_Track1_AfterJump:: ; 04:5D68
Data_04_5D68::
	sound_end
SoundSong03_Track2:: ; 04:5D69
Data_04_5D69::
	sound_volume $7F
	sound_pitch_add $F4
SoundSong03_Track2_Loop:: ; 04:5D6D
Data_04_5D6D::
	sound_instrument $08
	sound_note 24, $34, $1F
	sound_wait 24
	sound_instrument $09
	sound_note 12, $50, $15
	sound_wait 12
	sound_instrument $08
	sound_note 12, $34, $1F
	sound_wait 12
	sound_note 12
	sound_wait 12
	sound_instrument $09
	sound_note 12, $50, $15
	sound_wait 24
	sound_instrument $08
	sound_note 12, $39, $1F
	sound_wait 12
	sound_ret
	sound_instrument $09
	sound_note 12, $4F, $15
	sound_wait 24
	sound_instrument $08
	sound_note 24, $39, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 12, $4F, $15
	sound_wait 24
	sound_instrument $08
	sound_note 12, $39, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 12, $4F, $15
	sound_wait 24
	sound_call SoundSong03_Track2_Loop
	sound_instrument $09
	sound_note 12, $4F, $15
	sound_wait 24
	sound_instrument $08
	sound_note 12, $39, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 12, $4F, $15
	sound_wait 24
	sound_note 12
	sound_wait 12
	sound_instrument $08
	sound_note 12, $38, $1F
	sound_wait 12
	sound_rs sound_note 12, $37
	sound_wait 12
	sound_note 24, $36
	sound_wait 24
	sound_instrument $09
	sound_note 12, $52, $15
	sound_wait 12
	sound_instrument $08
	sound_note 12, $36, $1F
	sound_wait 12
	sound_note 12
	sound_wait 12
	sound_instrument $09
	sound_note 12, $52, $15
	sound_wait 24
	sound_instrument $08
	sound_note 12, $3B, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 12, $51, $15
	sound_wait 24
	sound_instrument $08
	sound_note 24, $3B, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 12, $51, $15
	sound_wait 24
	sound_instrument $08
	sound_note 12, $3B, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 12, $51, $15
	sound_wait 24
	sound_instrument $08
	sound_note 24, $36, $1F
	sound_wait 24
	sound_instrument $09
	sound_note 12, $52, $15
	sound_wait 12
	sound_instrument $08
	sound_note 12, $36, $1F
	sound_wait 12
	sound_note 12
	sound_wait 12
	sound_instrument $09
	sound_note 12, $52, $15
	sound_wait 24
	sound_instrument $08
	sound_note 12, $3B, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 12, $51, $15
	sound_wait 24
	sound_instrument $08
	sound_note 12, $2F, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 12, $51, $15
	sound_wait 24
	sound_note 12
	sound_wait 12
	sound_instrument $08
	sound_note 12, $32, $1F
	sound_wait 12
	sound_rs sound_note 12, $33
	sound_wait 12
	sound_jump SoundSong03_Track2_Loop
SoundSong03_Track2_AfterJump:: ; 04:5E45
Data_04_5E45::
	sound_end
SoundSong03_Track3:: ; 04:5E46
Data_04_5E46::
	sound_volume $7F
	sound_pitch_add $00
SoundSong03_Track3_Loop:: ; 04:5E4A
Data_04_5E4A::
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 4, $27, $15
	sound_wait 12
	sound_rs sound_note 4, $24, $0B
	sound_wait 12
	sound_note 6, $29, $13
	sound_wait 12
	sound_note 4, $27, $15
	sound_wait 6
	sound_rs sound_note 4, $24, $0B
	sound_wait 6
	sound_note 4
	sound_wait 12
	sound_note 6, $29, $13
	sound_wait 12
	sound_note 4, $24, $0B
	sound_wait 12
	sound_rs sound_note 4, $27, $15
	sound_wait 12
SoundSong03_Track3_Sub1:: ; 04:5E6B
Data_04_5E6B::
	sound_note 6, $29, $13
	sound_wait 12
	sound_note 4, $24, $0B
	sound_wait 12
	sound_rs sound_note 4, $27, $15
	sound_wait 12
	sound_note 6, $29, $13
	sound_wait 12
	sound_note 4, $24, $0B
	sound_wait 12
	sound_rs sound_note 4, $27, $15
	sound_wait 12
	sound_note 6, $29, $13
	sound_wait 12
	sound_note 4, $24, $0B
	sound_wait 12
	sound_ret
SoundSong03_Track3_Sub2:: ; 04:5E8A
Data_04_5E8A::
	sound_note 4, $27, $15
	sound_wait 12
	sound_rs sound_note 4, $24, $0B
	sound_wait 12
	sound_note 6, $29, $13
	sound_wait 12
	sound_note 4, $27, $15
	sound_wait 6
	sound_rs sound_note 4, $24, $0B
	sound_wait 6
	sound_note 4
	sound_wait 12
	sound_note 6, $29, $13
	sound_wait 12
	sound_note 4, $27, $15
	sound_wait 12
	sound_rs sound_note 4, $24, $0B
	sound_wait 12
	sound_ret
SoundSong03_Track3_Sub3:: ; 04:5EAA
Data_04_5EAA::
	sound_note 6, $29, $13
	sound_wait 12
	sound_note 4, $27, $15
	sound_wait 12
	sound_rs sound_note 4, $24, $0B
	sound_wait 12
	sound_rs sound_note 4, $27, $15
	sound_wait 12
	sound_rs sound_note 4, $24, $0B
	sound_wait 12
	sound_note 6, $29, $13
	sound_wait 12
	sound_note 6
	sound_wait 12
	sound_note 4, $24, $0B
	sound_wait 6
	sound_note 4
	sound_wait 6
	sound_ret
	sound_note 4, $27, $15
	sound_wait 12
	sound_rs sound_note 4, $24, $0B
	sound_wait 12
	sound_note 6, $29, $13
	sound_wait 12
	sound_note 4, $27, $15
	sound_wait 6
	sound_rs sound_note 4, $24, $0B
	sound_wait 6
	sound_note 4
	sound_wait 12
	sound_note 6, $29, $13
	sound_wait 12
	sound_note 4, $24, $0B
	sound_wait 12
	sound_rs sound_note 4, $27, $15
	sound_wait 12
	sound_call SoundSong03_Track3_Sub1
	sound_call SoundSong03_Track3_Sub2
	sound_call SoundSong03_Track3_Sub3
	sound_jump SoundSong03_Track3_Loop
SoundSong03_Track3_AfterJump:: ; 04:5EF3
Data_04_5EF3::
	sound_end
SoundSong03_Header:: ; 04:5EF4
Data_04_5EF4::
	sound_stream_header 4, 2
	dw SoundSong03_Track0, SoundSong03_Track1, SoundSong03_Track2, SoundSong03_Track3 ; track stream pointers (read by the driver)
	; not read by the driver: target of each track's final sound_jump
	dw SoundSong03_Track0_Loop, SoundSong03_Track1_Loop
	dw SoundSong03_Track2_Loop, SoundSong03_Track3_Loop
	; not read by the driver: address after each track's final sound_jump
	dw SoundSong03_Track0_AfterJump, SoundSong03_Track1_AfterJump
	dw SoundSong03_Track2_AfterJump, SoundSong03_Track3_AfterJump
