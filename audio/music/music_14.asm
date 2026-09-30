; audio/music/music_14.asm
; bank 05, $4D80-$50BC (828 bytes); pinned by layout.link
; song id 14

SECTION "audio/music/music_14", ROMX

; ---- data $4D80-$4E22 (162 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

Data_05_4D80:: ; 05:4D80
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $30
	sound_instrument $00
	sound_wait 12
	sound_note 3, $45, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_rs sound_note_mod 3, $11
	sound_wait 4
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_note 3, $41, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_note 3, $43, $11
	sound_wait 4
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_rs sound_note_mod 3, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $05
	sound_wait 4
Data_05_4DA3:: ; 05:4DA3
	sound_wait 12
	sound_note 3, $45, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_rs sound_note_mod 3, $11
	sound_wait 4
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_note 3, $46, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_note 3, $48, $11
	sound_wait 4
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_note 3, $43, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $05
	sound_wait 4
	sound_ret
Data_05_4DC1:: ; 05:4DC1
	sound_wait 12
	sound_note 3, $45, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_rs sound_note_mod 3, $11
	sound_wait 4
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_note 3, $41, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_note 3, $43, $11
	sound_wait 4
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_rs sound_note_mod 3, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $05
	sound_wait 4
	sound_ret
Data_05_4DDD:: ; 05:4DDD
	sound_wait 12
	sound_note 3, $41, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_rs sound_note_mod 3, $11
	sound_wait 4
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_note 3, $46, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_note 3, $45, $11
	sound_wait 4
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_note 3, $41, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $05
	sound_wait 4
	sound_ret
	sound_call Data_05_4DC1
	sound_call Data_05_4DA3
	sound_call Data_05_4DC1
	sound_call Data_05_4DDD
	sound_call Data_05_4DC1
	sound_call Data_05_4DA3
	sound_call Data_05_4DC1
	sound_call Data_05_4DDD
	sound_call Data_05_4DC1
	sound_call Data_05_4DA3
	sound_call Data_05_4DC1
	sound_call Data_05_4DDD
	sound_call Data_05_4DC1

; ---- data $4E22-$4E5B (57 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4E22:: ; 05:4E22
	sound_call Data_05_4DA3
	sound_call Data_05_4DC1
	sound_call Data_05_4DDD
	sound_call Data_05_4DC1
	sound_call Data_05_4DA3
	sound_call Data_05_4DC1
	sound_note 3, $41, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $05
	sound_wait 88
	sound_instrument $00
	sound_wait 12
	sound_note 3, $45, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_rs sound_note_mod 3, $11
	sound_wait 4
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_note 3, $41, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_note 3, $43, $11
	sound_wait 4
	sound_rs sound_note_mod 3, $05
	sound_wait 12
	sound_rs sound_note_mod 3, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $05
	sound_wait 4
	sound_jump Data_05_4DA3
Data_05_4E5A:: ; 05:4E5A
	sound_end

; ---- data $4E5B-$4F6A (271 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_4E5B:: ; 05:4E5B
	sound_volume $7F
	sound_pitch_add $00
Data_05_4E5F:: ; 05:4E5F
	sound_instrument $04
	sound_note 6, $29, $19
	sound_wait 12
	sound_instrument $05
	sound_note 3, $3C, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $04
	sound_wait 4
	sound_instrument $04
	sound_note 6, $29, $19
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 3, $3C, $11
	sound_wait 4
	sound_rs sound_note_mod 3, $04
	sound_wait 6
	sound_instrument $04
	sound_wait 2
	sound_note 6, $2E, $19
	sound_wait 4
	sound_instrument $05
	sound_note 3, $39, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $04
	sound_wait 4
	sound_instrument $04
	sound_note 6, $30, $19
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 3, $3A, $11
	sound_wait 4
	sound_rs sound_note_mod 3, $04
	sound_wait 6
	sound_instrument $04
	sound_wait 2
	sound_note 6, $30, $19
	sound_wait 4
	sound_instrument $05
	sound_note 3, $3A, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $04
	sound_wait 4
	sound_ret
Data_05_4EAA:: ; 05:4EAA
	sound_instrument $04
	sound_note 6, $29, $19
	sound_wait 12
	sound_instrument $05
	sound_note 3, $3C, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $04
	sound_wait 4
	sound_instrument $04
	sound_note 6, $29, $19
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 3, $3C, $11
	sound_wait 4
	sound_rs sound_note_mod 3, $04
	sound_wait 6
	sound_instrument $04
	sound_wait 2
	sound_note 6, $2E, $19
	sound_wait 4
	sound_instrument $05
	sound_note 3, $3D, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $04
	sound_wait 4
	sound_instrument $04
	sound_note 6, $30, $19
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 3, $3F, $11
	sound_wait 4
	sound_rs sound_note_mod 3, $04
	sound_wait 6
	sound_instrument $04
	sound_wait 2
	sound_note 6, $24, $19
	sound_wait 4
	sound_instrument $05
	sound_note 3, $3A, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $04
	sound_wait 4
	sound_ret
	sound_call Data_05_4E5F
Data_05_4EF8:: ; 05:4EF8
	sound_instrument $04
	sound_note 6, $2E, $19
	sound_wait 12
	sound_instrument $05
	sound_note 3, $3A, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $04
	sound_wait 4
	sound_instrument $04
	sound_note 6, $2E, $19
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 3, $3A, $11
	sound_wait 4
	sound_rs sound_note_mod 3, $04
	sound_wait 6
	sound_instrument $04
	sound_wait 2
	sound_note 6, $30, $19
	sound_wait 4
	sound_instrument $05
	sound_note 3, $3D, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $04
	sound_wait 4
	sound_instrument $04
	sound_note 6, $24, $19
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 3, $3C, $11
	sound_wait 4
	sound_rs sound_note_mod 3, $04
	sound_wait 6
	sound_instrument $04
	sound_wait 2
	sound_note 6, $30, $19
	sound_wait 4
	sound_instrument $05
	sound_note 3, $3A, $11
	sound_wait 8
	sound_rs sound_note_mod 3, $04
	sound_wait 4
	sound_ret
	sound_call Data_05_4E5F
	sound_call Data_05_4EAA
	sound_call Data_05_4E5F
	sound_call Data_05_4EF8
	sound_call Data_05_4E5F
	sound_call Data_05_4EAA
	sound_call Data_05_4E5F
	sound_call Data_05_4EF8
	sound_call Data_05_4E5F
	sound_call Data_05_4EAA
	sound_call Data_05_4E5F
	sound_call Data_05_4EF8
	sound_call Data_05_4E5F

; ---- data $4F6A-$4F87 (29 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4F6A:: ; 05:4F6A
	sound_call Data_05_4EAA
	sound_call Data_05_4E5F
	sound_call Data_05_4EF8
	sound_call Data_05_4E5F
	sound_call Data_05_4EAA
	sound_call Data_05_4E5F
	sound_note 3, $3A, $11
	sound_wait 96
	sound_call Data_05_4E5F
	sound_jump Data_05_4EAA
Data_05_4F86:: ; 05:4F86
	sound_end

; ---- data $4F87-$4FD5 (78 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_4F87:: ; 05:4F87
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $09
	sound_note 2, $54, $15
	sound_wait 24
	sound_rs sound_note 2, $48, $0E
	sound_wait 24
	sound_rs sound_note 2, $54, $15
	sound_wait 24
	sound_rs sound_note 2, $48, $0E
	sound_wait 24
Data_05_4F9A:: ; 05:4F9A
	sound_note 2, $54, $15
	sound_wait 24
	sound_rs sound_note 2, $48, $0E
	sound_wait 24
	sound_rs sound_note 2, $54, $15
	sound_wait 24
	sound_rs sound_note 2, $48, $0E
	sound_wait 24
	sound_ret
	sound_call Data_05_4F9A
	sound_call Data_05_4F9A
	sound_call Data_05_4F9A
	sound_call Data_05_4F9A
	sound_call Data_05_4F9A
	sound_call Data_05_4F9A
	sound_call Data_05_4F9A
	sound_call Data_05_4F9A
	sound_call Data_05_4F9A
	sound_call Data_05_4F9A
	sound_call Data_05_4F9A
	sound_call Data_05_4F9A
	sound_call Data_05_4F9A
	sound_call Data_05_4F9A
	sound_call Data_05_4F9A

; ---- data $4FD5-$5004 (47 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4FD5:: ; 05:4FD5
	sound_call Data_05_4F9A
	sound_call Data_05_4F9A
	sound_call Data_05_4F9A
	sound_call Data_05_4F9A
	sound_call Data_05_4F9A
	sound_note 2, $54, $15
	sound_wait 24
	sound_rs sound_note 2, $48, $0E
	sound_wait 24
	sound_instrument $08
	sound_note_mod 5, $1F
	sound_wait 48
	sound_note 5
	sound_wait 48
	sound_note 5
	sound_wait 48
	sound_note 44, $54
	sound_wait 48
	sound_instrument $09
	sound_note_mod 2, $15
	sound_wait 24
	sound_note 2, $48, $0E
	sound_wait 24
	sound_jump Data_05_4F9A
Data_05_5003:: ; 05:5003
	sound_end

; ---- data $5004-$5085 (129 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_5004:: ; 05:5004
	sound_volume $7F
	sound_pitch_add $00
Data_05_5008:: ; 05:5008
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 4, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 4, $2F, $0E
	sound_wait 12
	sound_rs sound_note 4, $2A
	sound_wait 8
	sound_rs sound_note 4, $2F
	sound_wait 4
	sound_note 4, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 4, $2F, $0E
	sound_wait 8
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 3
	sound_wait 8
	sound_note 3, $2A, $0E
	sound_wait 4
	sound_ret
Data_05_5031:: ; 05:5031
	sound_note 4, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 4, $2F, $0E
	sound_wait 12
	sound_rs sound_note 4, $2A
	sound_wait 8
	sound_rs sound_note 4, $2F
	sound_wait 4
	sound_note 4, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 4, $2F, $0E
	sound_wait 8
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 3
	sound_wait 8
	sound_note 3, $2A, $0E
	sound_wait 4
	sound_ret
	sound_call Data_05_5031
	sound_call Data_05_5031
	sound_call Data_05_5031
	sound_call Data_05_5031
	sound_call Data_05_5031
	sound_call Data_05_5031
	sound_call Data_05_5031
	sound_call Data_05_5031
	sound_call Data_05_5031
	sound_call Data_05_5031
	sound_call Data_05_5031
	sound_call Data_05_5031
	sound_call Data_05_5031
	sound_call Data_05_5031
	sound_call Data_05_5031

; ---- data $5085-$50A2 (29 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_5085:: ; 05:5085
	sound_call Data_05_5031
	sound_call Data_05_5031
	sound_call Data_05_5031
	sound_call Data_05_5031
	sound_call Data_05_5031
	sound_call Data_05_5031
	sound_note 4, $27, $10
	sound_wait 96
	sound_call Data_05_5008
	sound_jump Data_05_5031
Data_05_50A1:: ; 05:50A1
	sound_end

; ---- data $50A2-$50A4 (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 50A4 (12 words = NN*(KK+1)); the byte before (50A1) is $B1

Data_05_50A2:: ; 05:50A2
	sound_stream_header 4, 2

; ---- words $50A4-$50BC (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 50A2 [v4: bytes 50A4-50AC were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_50A4:: ; 05:50A4
	dw Data_05_4D80, Data_05_4E5B, Data_05_4F87, Data_05_5004 ; track stream pointers (read by the driver)
	dw Data_05_4DA3, Data_05_4EAA, Data_05_4F9A, Data_05_5031 ; not read by the driver: target of each track's final sound_jump
	dw Data_05_4E5A, Data_05_4F86, Data_05_5003, Data_05_50A1 ; not read by the driver: address after each track's final sound_jump
