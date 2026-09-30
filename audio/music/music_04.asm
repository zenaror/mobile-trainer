; audio/music/music_04.asm
; bank 04, $5F0E-$6102 (500 bytes); pinned by layout.link
; song id 04

SECTION "audio/music/music_04", ROMX

; ---- data $5F0E-$6102 (500 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; command semantics not decoded (part of region $574D-$7E8C)

SoundSong04_Track0:: ; 04:5F0E
Data_04_5F0E::
	sound_volume $7F
	sound_pitch_add $00
Data_04_5F12:: ; 04:5F12
	sound_tempo $2D
	sound_instrument $2F
	sound_wait 12
	sound_note 8, $3E, $16
	sound_wait 8
	sound_note 4, $3D
	sound_wait 4
	sound_note 8, $3E
	sound_wait 8
	sound_note 4, $3F
	sound_wait 12
	sound_note 12, $41
	sound_wait 16
	sound_rs sound_note 12, $3A
	sound_wait 12
	sound_rs sound_note 12, $3C
	sound_wait 12
	sound_rs sound_note 12, $3A
	sound_wait 12
	sound_rs sound_note 12, $3D
	sound_wait 12
	sound_note 4, $3C
	sound_wait 12
	sound_note 8, $3A
	sound_wait 8
	sound_note 4, $3C
	sound_wait 12
	sound_note 44, $3A
	sound_wait 52
	sound_wait 96
	sound_wait 96
	sound_wait 12
	sound_note 8, $3E
	sound_wait 8
	sound_note 4, $3D
	sound_wait 4
	sound_note 8, $3E
	sound_wait 8
	sound_note 4, $41
	sound_wait 12
	sound_note 16, $44
	sound_wait 16
	sound_note 12, $43
	sound_wait 12
	sound_rs sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $3A
	sound_wait 12
	sound_rs sound_note 12, $3D
	sound_wait 12
	sound_note 4, $3C
	sound_wait 12
	sound_note 8, $3A
	sound_wait 8
	sound_note 4, $37
	sound_wait 12
	sound_note 44, $3A
	sound_wait 52
	sound_wait 96
	sound_wait 96
	sound_jump Data_04_5F12
Data_04_5F67:: ; 04:5F67
	sound_end
SoundSong04_Track1:: ; 04:5F68
Data_04_5F68::
	sound_volume $7F
	sound_pitch_add $00
Data_04_5F6C:: ; 04:5F6C
	sound_instrument $04
	sound_wait 24
	sound_note 6, $52, $15
	sound_wait 48
	sound_note 6
	sound_wait 24
Data_04_5F75:: ; 04:5F75
	sound_wait 24
	sound_note 6, $52, $15
	sound_wait 48
	sound_note 6
	sound_wait 24
	sound_ret
	sound_call Data_04_5F75
	sound_call Data_04_5F75
	sound_call Data_04_5F75
	sound_call Data_04_5F75
	sound_call Data_04_5F75
	sound_call Data_04_5F75
	sound_jump Data_04_5F6C
Data_04_5F92:: ; 04:5F92
	sound_end
SoundSong04_Track2:: ; 04:5F93
Data_04_5F93::
	sound_volume $7F
	sound_pitch_add $F4
Data_04_5F97:: ; 04:5F97
	sound_instrument $08
	sound_note 8, $2E, $1F
	sound_wait 12
	sound_note 8
	sound_wait 12
	sound_instrument $09
	sound_note 8, $56, $15
	sound_wait 36
	sound_instrument $08
	sound_note 8, $38, $1F
	sound_wait 8
	sound_note 4, $3A
	sound_wait 4
	sound_instrument $09
	sound_note 8, $56, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $38, $1F
	sound_wait 4
	sound_note 12, $35
	sound_wait 12
Data_04_5FBD:: ; 04:5FBD
	sound_note 8, $33, $1F
	sound_wait 12
	sound_note 8
	sound_wait 12
	sound_instrument $09
	sound_note 8, $55, $15
	sound_wait 36
	sound_instrument $08
	sound_note 8, $3D, $1F
	sound_wait 8
	sound_note 4, $3F
	sound_wait 4
	sound_instrument $09
	sound_note 8, $55, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $3D, $1F
	sound_wait 4
	sound_note 12, $3A
	sound_wait 12
	sound_ret
Data_04_5FE2:: ; 04:5FE2
	sound_note 8, $2E, $1F
	sound_wait 12
	sound_note 8
	sound_wait 12
	sound_instrument $09
	sound_note 8, $56, $15
	sound_wait 36
	sound_instrument $08
	sound_note 8, $38, $1F
	sound_wait 8
	sound_note 4, $3A
	sound_wait 4
	sound_instrument $09
	sound_note 8, $56, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $38, $1F
	sound_wait 4
	sound_note 12, $35
	sound_wait 12
	sound_ret
	sound_call Data_04_5FBD
	sound_call Data_04_5FE2
	sound_call Data_04_5FBD
	sound_call Data_04_5FE2
	sound_call Data_04_5FBD
	sound_jump Data_04_5F97
Data_04_6019:: ; 04:6019
	sound_end
SoundSong04_Track3:: ; 04:601A
Data_04_601A::
	sound_volume $7F
	sound_pitch_add $00
Data_04_601E:: ; 04:601E
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 4, $27, $11
	sound_wait 12
	sound_note 12, $2A, $0B
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 8
	sound_pitch_bend $20
	sound_note 6, $25, $0C
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 3
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 8
	sound_pitch_bend $20
	sound_note 4, $25, $0C
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 3
Data_04_605E:: ; 04:605E
	sound_note 4, $27, $11
	sound_wait 12
	sound_note 12, $2A, $0B
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 8
	sound_pitch_bend $20
	sound_note 6, $25, $0C
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 3
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 4
	sound_ret
Data_04_6096:: ; 04:6096
	sound_note 4, $27, $11
	sound_wait 12
	sound_note 12, $2A, $0B
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 8
	sound_pitch_bend $20
	sound_note 6, $25, $0C
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 3
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 8
	sound_pitch_bend $20
	sound_note 4, $25, $0C
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 3
	sound_ret
	sound_call Data_04_605E
	sound_call Data_04_6096
	sound_call Data_04_605E
	sound_call Data_04_6096
	sound_call Data_04_605E
	sound_jump Data_04_601E
Data_04_60E7:: ; 04:60E7
	sound_end
SoundSong04_Header:: ; 04:60E8
Data_04_60E8::
	sound_stream_header 4, 2
	dw SoundSong04_Track0, SoundSong04_Track1, SoundSong04_Track2, SoundSong04_Track3 ; track stream pointers (read by the driver)
	dw Data_04_5F12, Data_04_5F6C, Data_04_5F97, Data_04_601E ; not read by the driver: target of each track's final sound_jump
	dw Data_04_5F67, Data_04_5F92, Data_04_6019, Data_04_60E7 ; not read by the driver: address after each track's final sound_jump
