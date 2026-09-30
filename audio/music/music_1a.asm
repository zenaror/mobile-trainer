; audio/music/music_1a.asm
; bank 05, $5DCF-$60E9 (794 bytes); pinned by layout.link
; song id 1A

SECTION "audio/music/music_1a", ROMX

; ---- data $5DCF-$5E23 (84 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_5DCF:: ; 05:5DCF
	sound_volume $7F
	sound_pitch_add $00
Data_05_5DD3:: ; 05:5DD3
	sound_tempo $39
	sound_instrument $52
	sound_cmd_C5 $10
	sound_cmd_C3 $20
	sound_cmd_C4 $1E
	sound_note 60, $47, $18
	sound_wait 60
	sound_note 12, $49, $19
	sound_wait 12
	sound_note 8, $47
	sound_wait 12
	sound_note 72
	sound_wait 12
	sound_wait 60
	sound_note 12, $49
	sound_wait 12
	sound_rs sound_note 12, $4B
	sound_wait 12
	sound_note 72, $4C
	sound_wait 12
	sound_wait 60
	sound_note 12, $4B
	sound_wait 12
	sound_rs sound_note 12, $49
	sound_wait 12
	sound_note 36, $4B
	sound_wait 12
	sound_wait 24
	sound_note 12, $4C
	sound_wait 12
	sound_rs sound_note 12, $4B
	sound_wait 24
	sound_rs sound_note 12, $49
	sound_wait 24
	sound_note 72, $47
	sound_wait 12
	sound_wait 60
	sound_note 12, $49
	sound_wait 12
	sound_rs sound_note 12, $4B
	sound_wait 12
	sound_note 48, $49
	sound_wait 12
	sound_wait 36
	sound_note 36, $44
	sound_wait 36
	sound_note 24, $49
	sound_wait 24
	sound_note 60, $47
	sound_wait 60
	sound_note 12, $44
	sound_wait 12
	sound_rs sound_note 12, $46
	sound_wait 12
	sound_note 36, $47
	sound_wait 12
	sound_wait 24

; ---- data $5E23-$5E37 (20 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_5E23:: ; 05:5E23
	sound_note 24, $46
	sound_wait 24
	sound_note 12, $44
	sound_wait 12
	sound_note 24, $46
	sound_wait 24
	sound_note 0, $47
	sound_wait 12
	sound_wait 96
	sound_wait 60
	sound_cmd_CF
	sound_wait 36
	sound_jump Data_05_5DD3
Data_05_5E36:: ; 05:5E36
	sound_end

; ---- data $5E37-$5F09 (210 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_5E37:: ; 05:5E37
	sound_volume $7F
	sound_pitch_add $00
Data_05_5E3B:: ; 05:5E3B
	sound_instrument $05
	sound_note 24, $44, $0C
	sound_wait 24
	sound_instrument $04
	sound_note 12, $4C, $12
	sound_wait 12
	sound_instrument $05
	sound_note 24, $40, $0C
	sound_wait 24
	sound_note 12, $47
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4C, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $3B, $0C
	sound_wait 12
	sound_rs sound_note 12, $42
	sound_wait 12
	sound_rs sound_note 12, $3B
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4B, $12
	sound_wait 12
	sound_instrument $05
	sound_note 24, $42, $0C
	sound_wait 24
	sound_note 12, $47
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4E, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $42, $0C
	sound_wait 12
	sound_note 24, $44
	sound_wait 24
	sound_instrument $04
	sound_note 12, $49, $12
	sound_wait 12
	sound_instrument $05
	sound_note 24, $40, $0C
	sound_wait 24
	sound_note 12, $49
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4C, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $42, $0C
	sound_wait 12
	sound_rs sound_note 12, $47
	sound_wait 12
	sound_rs sound_note 12, $3F
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4E, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $47, $0C
	sound_wait 24
	sound_rs sound_note 12, $46
	sound_wait 24
	sound_instrument $05
	sound_note 36, $44
	sound_wait 12
	sound_wait 24
	sound_instrument $04
	sound_note 12, $4B, $12
	sound_wait 12
	sound_instrument $05
	sound_note 24, $3F, $0C
	sound_wait 24
	sound_note 12, $47
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4B, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $3B, $0C
	sound_wait 12
	sound_note 24, $3D
	sound_wait 24
	sound_instrument $04
	sound_note 12, $4D, $12
	sound_wait 12
	sound_instrument $05
	sound_note 24, $41, $0C
	sound_wait 24
	sound_note 12, $49
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4D, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $41, $0C
	sound_wait 12
	sound_note 24, $44
	sound_wait 24
	sound_instrument $04
	sound_note 12, $4C, $12
	sound_wait 12
	sound_instrument $05
	sound_note 24, $40, $0C
	sound_wait 24
	sound_note 12, $38
	sound_wait 12
	sound_instrument $04
	sound_note 12, $47, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $3B, $0C
	sound_wait 12
	db $E7 ; start of `sound_note 24, $44`; a label lies inside this command

; ---- data $5F09-$5F67 (94 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_5F09:: ; 05:5F09
	db $44 ; rest of `sound_note 24, $44`
	sound_wait 24
	sound_instrument $04
	sound_note 12, $4C, $12
	sound_wait 12
	sound_instrument $05
	sound_note 24, $40, $0C
	sound_wait 24
	sound_note 12, $49
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4C, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $40, $0C
	sound_wait 12
	sound_rs sound_note 12, $47
	sound_wait 12
	sound_rs sound_note 12, $3D
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4C, $12
	sound_wait 12
	sound_instrument $05
	sound_note 24, $40, $0C
	sound_wait 24
	sound_note 12, $45
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4C, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $3D, $0C
	sound_wait 12
	sound_rs sound_note 12, $3F
	sound_wait 12
	sound_rs sound_note 12, $3B
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4B, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $40, $0C
	sound_wait 24
	sound_rs sound_note 12, $42
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4E, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $3B, $0C
	sound_wait 12
	sound_jump Data_05_5E3B
Data_05_5F66:: ; 05:5F66
	sound_end

; ---- data $5F67-$5FF1 (138 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_5F67:: ; 05:5F67
	sound_volume $7F
	sound_pitch_add $00
Data_05_5F6B:: ; 05:5F6B
	sound_instrument $20
	sound_note 24, $28, $19
	sound_wait 24
	sound_note 12, $44, $12
	sound_wait 12
	sound_note 8, $2F, $19
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_note 12, $44, $12
	sound_wait 12
	sound_rs sound_note 12, $34, $19
	sound_wait 12
	sound_note 24, $33
	sound_wait 24
	sound_note 12, $42, $12
	sound_wait 12
	sound_note 8, $2F, $19
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_note 12, $47, $12
	sound_wait 24
	sound_note 24, $31, $19
	sound_wait 24
	sound_note 12, $40, $12
	sound_wait 12
	sound_note 8, $2A, $19
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_note 24, $46, $12
	sound_wait 12
	sound_note 12, $2A
	sound_wait 12
	sound_note 36, $2F, $19
	sound_wait 24
	sound_note 12, $42, $12
	sound_wait 12
	sound_rs sound_note 12, $2F, $19
	sound_wait 24
	sound_rs sound_note 12, $2E
	sound_wait 24
	sound_note 36, $2C
	sound_wait 12
	sound_wait 24
	sound_note 12, $44, $12
	sound_wait 12
	sound_note 8, $33, $19
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_note 12, $44, $12
	sound_wait 12
	sound_rs sound_note 12, $2C, $19
	sound_wait 12
	sound_note 24, $31
	sound_wait 24
	sound_note 12, $44, $12
	sound_wait 12
	sound_note 8, $2C, $19
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_note 12, $44, $12
	sound_wait 24
	sound_note 24, $2A, $19
	sound_wait 24
	sound_note 12, $44, $12
	sound_wait 12
	sound_note 8, $2A, $19
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_note 12, $40, $12
	sound_wait 12
	sound_rs sound_note 12, $25, $19
	sound_wait 12
	db $E7 ; start of `sound_note 24, $2A`; a label lies inside this command

; ---- data $5FF1-$602A (57 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_5FF1:: ; 05:5FF1
	db $2A ; rest of `sound_note 24, $2A`
	sound_wait 24
	sound_note 12, $44, $12
	sound_wait 12
	sound_note 8, $36, $19
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_note 12, $44, $12
	sound_wait 24
	sound_note 24, $2F, $19
	sound_wait 24
	sound_note 12, $45, $12
	sound_wait 12
	sound_note 8, $2A, $19
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_note 12, $45, $12
	sound_wait 12
	sound_rs sound_note 12, $2A, $19
	sound_wait 12
	sound_note 24, $2F
	sound_wait 24
	sound_note 12, $42, $12
	sound_wait 12
	sound_rs sound_note 12, $31, $19
	sound_wait 24
	sound_rs sound_note 12, $33
	sound_wait 12
	sound_note 12, $47, $12
	sound_wait 24
	sound_jump Data_05_5F6B
Data_05_6029:: ; 05:6029
	sound_end

; ---- data $602A-$609A (112 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_602A:: ; 05:602A
	sound_volume $7F
	sound_pitch_add $00
Data_05_602E:: ; 05:602E
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 6, $27, $0F
	sound_wait 12
	sound_note 4, $24, $0B
	sound_wait 12
	sound_cmd_C1 $28
	sound_note 6, $2F, $0D
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 6, $27, $0F
	sound_wait 6
	sound_note 4, $24, $09
	sound_wait 6
	sound_note 6, $27, $0F
	sound_wait 12
	sound_note 4, $24, $0B
	sound_wait 12
	sound_cmd_C1 $28
	sound_note 6, $2F, $0D
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 12, $24
	sound_wait 12
Data_05_605D:: ; 05:605D
	sound_note 6, $27, $0F
	sound_wait 12
	sound_note 4, $24, $0B
	sound_wait 12
	sound_cmd_C1 $28
	sound_note 6, $2F, $0D
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 6, $27, $0F
	sound_wait 6
	sound_note 4, $24, $09
	sound_wait 6
	sound_note 6, $27, $0F
	sound_wait 12
	sound_note 4, $24, $0B
	sound_wait 12
	sound_cmd_C1 $28
	sound_note 6, $2F, $0D
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 12, $24
	sound_wait 12
	sound_ret
	sound_call Data_05_605D
	sound_call Data_05_605D
	sound_call Data_05_605D
	sound_call Data_05_605D
	sound_call Data_05_605D

; ---- data $609A-$60CF (53 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_609A:: ; 05:609A
	sound_call Data_05_605D
	sound_call Data_05_605D
	sound_note 6, $27, $0F
	sound_wait 12
	sound_note 4, $24, $0B
	sound_wait 12
	sound_cmd_C1 $28
	sound_note 6, $2F, $0D
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 4, $24, $0B
	sound_wait 12
	sound_note 6, $27, $0F
	sound_wait 12
	sound_cmd_C1 $28
	sound_note 6, $2F, $0D
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_rs sound_cmd_C1 $28
	sound_note 6
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 12, $24
	sound_wait 12
	sound_jump Data_05_602E
Data_05_60CE:: ; 05:60CE
	sound_end

; ---- data $60CF-$60D1 (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 60D1 (12 words = NN*(KK+1)); the byte before (60CE) is $B1

Data_05_60CF:: ; 05:60CF
	sound_stream_header 4, 2

; ---- words $60D1-$60E9 (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 60CF [v4: bytes 60D1-60D9 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_60D1:: ; 05:60D1
	dw Data_05_5DCF, Data_05_5E37, Data_05_5F67, Data_05_602A ; track stream pointers (read by the driver)
	dw Data_05_5DD3, Data_05_5E3B, Data_05_5F6B, Data_05_602E ; not read by the driver: target of each track's final sound_jump
	dw Data_05_5E36, Data_05_5F66, Data_05_6029, Data_05_60CE ; not read by the driver: address after each track's final sound_jump
