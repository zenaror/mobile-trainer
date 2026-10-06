; audio/music/music_09.asm
; bank 04, $745F-$77E9 (906 bytes); pinned by layout.link
; song id 09

SECTION "audio/music/music_09", ROMX

; ---- data $745F-$77E9 (906 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; commands decoded (docs/research/audio_format.md) (part of region $574D-$7E8C)

SoundSong09_Track0:: ; 04:745F
Data_04_745F::
	sound_volume $7F
	sound_pitch_add $00
SoundSong09_Track0_Loop:: ; 04:7463
Data_04_7463::
	sound_tempo $30
	sound_instrument $2D
	sound_vibrato_depth $10
	sound_vibrato_rate $20
	sound_vibrato_delay $18
	sound_note 48, $43, $14
	sound_wait 48
	sound_note 16, $44
	sound_wait 16
	sound_rs sound_note 16, $43
	sound_wait 16
	sound_rs sound_note 16, $44
	sound_wait 16
	sound_note 48, $46
	sound_wait 48
	sound_note 16, $48
	sound_wait 16
	sound_rs sound_note 16, $46
	sound_wait 16
	sound_rs sound_note 16, $44
	sound_wait 16
	sound_note 18, $46
	sound_wait 24
	sound_note 24, $3A
	sound_wait 24
	sound_note 16, $43
	sound_wait 16
	sound_rs sound_note 16, $41
	sound_wait 16
	sound_rs sound_note 16, $3F
	sound_wait 16
	sound_note 84, $41
	sound_wait 96
	sound_note 48, $43
	sound_wait 48
	sound_note 16, $44
	sound_wait 16
	sound_rs sound_note 16, $43
	sound_wait 16
	sound_rs sound_note 16, $44
	sound_wait 16
	sound_note 48, $46
	sound_wait 48
	sound_note 16, $48
	sound_wait 16
	sound_rs sound_note 16, $4A
	sound_wait 16
	sound_rs sound_note 16, $4B
	sound_wait 16
	sound_note 42, $3F
	sound_wait 48
	sound_note 16, $44
	sound_wait 16
	sound_rs sound_note 16, $43
	sound_wait 16
	sound_rs sound_note 16, $41
	sound_wait 16
	sound_note 84, $3F
	sound_wait 96
	sound_jump SoundSong09_Track0_Loop
SoundSong09_Track0_AfterJump:: ; 04:74B6
Data_04_74B6::
	sound_end
SoundSong09_Track1:: ; 04:74B7
Data_04_74B7::
	sound_volume $7F
	sound_pitch_add $00
SoundSong09_Track1_Loop:: ; 04:74BB
Data_04_74BB::
	sound_instrument $05
	sound_wait 16
	sound_note 8, $3A, $11
	sound_wait 8
	sound_note 16, $43
	sound_wait 16
	sound_note 8, $3A
	sound_wait 24
	sound_rs sound_note 8, $3E
	sound_wait 8
	sound_note 16, $44
	sound_wait 16
	sound_note 8, $3E
	sound_wait 8
	sound_wait 16
	sound_rs sound_note 8, $3A
	sound_wait 8
	sound_note 16, $41
	sound_wait 16
	sound_note 8, $3F
	sound_wait 16
	sound_rs sound_note 8, $3E
	sound_wait 8
	sound_rs sound_note 8, $44
	sound_wait 8
	sound_note 16, $48
	sound_wait 16
	sound_note 8, $3E
	sound_wait 8
	sound_wait 16
	sound_rs sound_note 8, $3A
	sound_wait 8
	sound_note 16, $43
	sound_wait 16
	sound_note 8, $3A
	sound_wait 24
	sound_rs sound_note 8, $3C
	sound_wait 8
	sound_note 16, $45
	sound_wait 16
	sound_note 8, $3C
	sound_wait 8
	sound_wait 16
	sound_note 8
	sound_wait 8
	sound_note 16, $44
	sound_wait 16
	sound_note 8, $3C
	sound_wait 8
	sound_instrument $04
	sound_note 8, $4A, $13
	sound_wait 8
	sound_rs sound_note 8, $41
	sound_wait 8
	sound_rs sound_note 8, $4B
	sound_wait 8
	sound_rs sound_note 8, $41
	sound_wait 8
	sound_rs sound_note 8, $4D
	sound_wait 8
	sound_rs sound_note 8, $44
	sound_wait 8
	sound_instrument $05
	sound_wait 16
	sound_note 8, $3A, $11
	sound_wait 8
	sound_note 16, $43
	sound_wait 16
	sound_note 8, $3A
	sound_wait 24
	sound_rs sound_note 8, $3C
	sound_wait 8
	sound_note 16, $44
	sound_wait 16
	sound_note 8, $3C
	sound_wait 8
	sound_wait 16
	sound_rs sound_note 8, $3A
	sound_wait 8
	sound_note 16, $41
	sound_wait 16
	sound_note 8, $3F
	sound_wait 16
	sound_rs sound_note 8, $3C
	sound_wait 8
	sound_rs sound_note 8, $44
	sound_wait 8
	sound_note 16, $48
	sound_wait 16
	sound_note 8, $3F
	sound_wait 8
	sound_wait 16
	sound_rs sound_note 8, $3A
	sound_wait 8
	sound_note 16, $43
	sound_wait 16
	sound_note 8, $3A
	sound_wait 8
	sound_instrument $04
	sound_note 8, $48, $13
	sound_wait 8
	sound_rs sound_note 8, $3C
	sound_wait 8
	sound_rs sound_note 8, $46
	sound_wait 8
	sound_rs sound_note 8, $3A
	sound_wait 8
	sound_rs sound_note 8, $44
	sound_wait 8
	sound_rs sound_note 8, $38
	sound_wait 8
	sound_instrument $05
	sound_wait 16
	sound_note 8, $3A, $11
	sound_wait 8
	sound_note 16, $43
	sound_wait 16
	sound_note 8, $3A
	sound_wait 16
	sound_rs sound_note 8, $3C
	sound_wait 8
	sound_rs sound_note 8, $44
	sound_wait 8
	sound_note 16, $4B
	sound_wait 16
	sound_note 8, $3F
	sound_wait 8
	sound_jump SoundSong09_Track1_Loop
SoundSong09_Track1_AfterJump:: ; 04:7568
Data_04_7568::
	sound_end
SoundSong09_Track2:: ; 04:7569
Data_04_7569::
	sound_volume $7F
	sound_pitch_add $F4
SoundSong09_Track2_Loop:: ; 04:756D
Data_04_756D::
	sound_instrument $08
	sound_note 8, $33, $1F
	sound_wait 16
	sound_instrument $4F
	sound_note 8, $3F, $12
	sound_wait 8
	sound_note 16, $46
	sound_wait 16
	sound_note 8, $3F
	sound_wait 8
	sound_instrument $08
	sound_note 8, $35, $1F
	sound_wait 16
	sound_instrument $4F
	sound_note 8, $41, $12
	sound_wait 8
	sound_note 16, $4A
	sound_wait 16
	sound_note 8, $41
	sound_wait 8
	sound_instrument $08
	sound_note 8, $37, $1F
	sound_wait 16
	sound_instrument $4F
	sound_note 8, $41, $12
	sound_wait 8
	sound_note 16, $46
	sound_wait 16
	sound_note 8, $43
	sound_wait 8
	sound_instrument $08
	sound_note 8, $38, $1F
	sound_wait 8
	sound_instrument $4F
	sound_note 8, $41, $12
	sound_wait 8
	sound_rs sound_note 8, $48
	sound_wait 8
	sound_note 16, $4D
	sound_wait 16
	sound_note 8, $41
	sound_wait 8
	sound_instrument $08
	sound_note 8, $37, $1F
	sound_wait 16
	sound_instrument $4F
	sound_note 8, $3F, $12
	sound_wait 8
	sound_note 16, $46
	sound_wait 16
	sound_note 8, $3F
	sound_wait 8
	sound_instrument $08
	sound_note 8, $35, $1F
	sound_wait 16
	sound_instrument $4F
	sound_note 8, $41, $12
	sound_wait 8
	sound_note 16, $48
	sound_wait 16
	sound_note 8, $41
	sound_wait 8
	sound_instrument $08
	sound_note 8, $3A, $1F
	sound_wait 16
	sound_instrument $4F
	sound_note 8, $3F, $12
	sound_wait 8
	sound_note 16, $48
	sound_wait 16
	sound_note 8, $3F
	sound_wait 8
	sound_instrument $09
	sound_note 8, $4D, $14
	sound_wait 8
	sound_instrument $08
	sound_note 8, $2E, $1F
	sound_wait 8
	sound_instrument $09
	sound_note 8, $4F, $14
	sound_wait 8
	sound_instrument $08
	sound_note 8, $30, $1F
	sound_wait 8
	sound_instrument $09
	sound_note 8, $50, $14
	sound_wait 8
	sound_instrument $08
	sound_note 8, $32, $1F
	sound_wait 8
	sound_rs sound_note 8, $33
	sound_wait 16
	sound_instrument $4F
	sound_note 8, $3F, $12
	sound_wait 8
	sound_note 16, $46
	sound_wait 16
	sound_note 8, $3F
	sound_wait 8
	sound_instrument $08
	sound_note 8, $35, $1F
	sound_wait 16
	sound_instrument $4F
	sound_note 8, $41, $12
	sound_wait 8
	sound_note 16, $48
	sound_wait 16
	sound_note 8, $41
	sound_wait 8
	sound_instrument $08
	sound_note 8, $37, $1F
	sound_wait 16
	sound_instrument $4F
	sound_note 8, $41, $12
	sound_wait 8
	sound_note 16, $46
	sound_wait 16
	sound_note 8, $43
	sound_wait 8
	sound_instrument $08
	sound_note 8, $38, $1F
	sound_wait 8
	sound_instrument $4F
	sound_note 8, $3F, $12
	sound_wait 8
	sound_rs sound_note 8, $48
	sound_wait 8
	sound_note 16, $4B
	sound_wait 16
	sound_note 8, $44
	sound_wait 8
	sound_instrument $08
	sound_note 8, $3A, $1F
	sound_wait 16
	sound_instrument $4F
	sound_note 8, $3F, $12
	sound_wait 8
	sound_note 16, $46
	sound_wait 16
	sound_note 8, $3F
	sound_wait 8
	sound_instrument $09
	sound_note 8, $4B, $14
	sound_wait 8
	sound_instrument $08
	sound_note 8, $38, $1F
	sound_wait 8
	sound_instrument $09
	sound_note 8, $4B, $14
	sound_wait 8
	sound_instrument $08
	sound_note 8, $37, $1F
	sound_wait 8
	sound_instrument $09
	sound_note 8, $48, $14
	sound_wait 8
	sound_instrument $08
	sound_note 8, $35, $1F
	sound_wait 8
	sound_instrument $08
	sound_note 8, $33
	sound_wait 16
	sound_instrument $4F
	sound_note 8, $43, $12
	sound_wait 8
	sound_note 16, $4B
	sound_wait 16
	sound_note 8, $43
	sound_wait 8
	sound_instrument $08
	sound_note 8, $3A, $1F
	sound_wait 8
	sound_instrument $4F
	sound_note 8, $3F, $12
	sound_wait 8
	sound_rs sound_note 8, $48
	sound_wait 8
	sound_note 16, $50
	sound_wait 16
	sound_note 8, $44
	sound_wait 8
	sound_jump SoundSong09_Track2_Loop
SoundSong09_Track2_AfterJump:: ; 04:76B5
Data_04_76B5::
	sound_end
SoundSong09_Track3:: ; 04:76B6
Data_04_76B6::
	sound_volume $7F
	sound_pitch_add $00
SoundSong09_Track3_Loop:: ; 04:76BA
Data_04_76BA::
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 5, $27, $11
	sound_wait 8
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 8
	sound_pitch_bend $28
	sound_note 5, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 8
	sound_note 3
	sound_wait 8
	sound_note 5, $27, $11
	sound_wait 8
	sound_note 3, $24, $0B
	sound_wait 8
	sound_pitch_bend $28
	sound_note 5, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 5, $27, $11
	sound_wait 8
SoundSong09_Track3_Sub1:: ; 04:76F0
Data_04_76F0::
	sound_note 5, $27, $11
	sound_wait 8
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 8
	sound_pitch_bend $28
	sound_note 5, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 8
	sound_note 3
	sound_wait 8
	sound_note 5, $27, $11
	sound_wait 8
	sound_note 3, $24, $0B
	sound_wait 8
	sound_pitch_bend $28
	sound_note 5, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 8
	sound_wait 8
	sound_ret
SoundSong09_Track3_Sub2:: ; 04:7723
Data_04_7723::
	sound_note 5, $27, $11
	sound_wait 8
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 8
	sound_pitch_bend $28
	sound_note 5, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 8
	sound_note 3
	sound_wait 8
	sound_note 5, $27, $11
	sound_wait 8
	sound_note 3, $24, $0B
	sound_wait 8
	sound_pitch_bend $28
	sound_note 5, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 5, $27, $11
	sound_wait 8
	sound_ret
	sound_note 5
	sound_wait 8
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 8
	sound_pitch_bend $28
	sound_note 5, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 8
	sound_note 5, $27, $11
	sound_wait 8
	sound_note 3, $24, $0B
	sound_wait 8
	sound_pitch_bend $28
	sound_note 5, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 5, $27, $11
	sound_wait 8
	sound_note 8, $24, $0B
	sound_wait 8
	sound_call SoundSong09_Track3_Sub2
	sound_call SoundSong09_Track3_Sub1
	sound_call SoundSong09_Track3_Sub2
	sound_note 5, $27, $11
	sound_wait 8
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 8
	sound_pitch_bend $28
	sound_note 5, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 8
	sound_note 5, $27, $11
	sound_wait 8
	sound_note 3, $24, $0B
	sound_wait 8
	sound_pitch_bend $28
	sound_note 5, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 5, $27, $11
	sound_wait 8
	sound_note 8, $24, $0E
	sound_wait 8
	sound_jump SoundSong09_Track3_Loop
SoundSong09_Track3_AfterJump:: ; 04:77CE
Data_04_77CE::
	sound_end
SoundSong09_Header:: ; 04:77CF
Data_04_77CF::
	sound_stream_header 4, 2
	dw SoundSong09_Track0, SoundSong09_Track1, SoundSong09_Track2, SoundSong09_Track3 ; track stream pointers (read by the driver)
	dw SoundSong09_Track0_Loop, SoundSong09_Track1_Loop, SoundSong09_Track2_Loop, SoundSong09_Track3_Loop ; not read by the driver: target of each track's final sound_jump
	dw SoundSong09_Track0_AfterJump, SoundSong09_Track1_AfterJump, SoundSong09_Track2_AfterJump, SoundSong09_Track3_AfterJump ; not read by the driver: address after each track's final sound_jump
