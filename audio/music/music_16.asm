; audio/music/music_16.asm
; bank 05, $5174-$54E3 (879 bytes); pinned by layout.link
; song id 16

SECTION "audio/music/music_16", ROMX

; ---- data $5174-$51D9 (101 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown

Data_05_5174:: ; 05:5174
	sound_volume $7F
	sound_pitch_add $00
Data_05_5178:: ; 05:5178
	sound_tempo $3F
	sound_instrument $03
	sound_cmd_C5 $10
	sound_cmd_C3 $20
	sound_cmd_C4 $30
	sound_wait 24
	sound_note 12, $42, $15
	sound_wait 12
	sound_rs sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $42
	sound_wait 12
	sound_rs sound_note 12, $44
	sound_wait 24
	sound_rs sound_note 12, $42
	sound_wait 12
	sound_wait 12
	sound_note 6, $3D
	sound_wait 12
	sound_note 72
	sound_wait 72
	sound_wait 24
	sound_note 12, $42
	sound_wait 12
	sound_rs sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $42
	sound_wait 12
	sound_rs sound_note 12, $44
	sound_wait 24
	sound_rs sound_note 12, $42
	sound_wait 12
	sound_wait 12
	sound_rs sound_note 12, $3A
	sound_wait 24
	sound_rs sound_note 12, $3B
	sound_wait 24
	sound_note 36, $3D
	sound_wait 36
	sound_wait 24
	sound_note 12, $42
	sound_wait 12
	sound_rs sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $42
	sound_wait 12
	sound_rs sound_note 12, $44
	sound_wait 24
	sound_note 24, $3D
	sound_wait 12
	sound_wait 12
	sound_note 12, $3F
	sound_wait 12
	sound_rs sound_note 12, $41
	sound_wait 12
	sound_note 18, $42
	sound_wait 24
	sound_note 12, $3D
	sound_wait 12
	sound_rs sound_note 12, $3A
	sound_wait 12
	sound_note 24, $3D
	sound_wait 12
	sound_wait 12
	sound_note 6, $3B
	sound_wait 12
	sound_note 48
	sound_wait 60
	sound_note 24, $3F
	sound_wait 12
	sound_wait 12
	sound_note 6, $3D
	sound_wait 12
	sound_note 48
	sound_wait 72
	sound_jump Data_05_5178

; ---- data $51D9-$51DA (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_51D9:: ; 05:51D9
	sound_end

; ---- data $51DA-$52D7 (253 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown

Data_05_51DA:: ; 05:51DA
	sound_volume $7F
	sound_pitch_add $00
Data_05_51DE:: ; 05:51DE
	sound_instrument $05
	sound_note 24, $42, $0D
	sound_wait 24
	sound_instrument $04
	sound_note 12, $47, $15
	sound_wait 12
	sound_instrument $05
	sound_note 24, $3F, $0D
	sound_wait 24
	sound_note 12, $4B
	sound_wait 12
	sound_instrument $04
	sound_note 12, $47, $15
	sound_wait 12
	sound_instrument $05
	sound_note 24, $46, $0D
	sound_wait 12
	sound_wait 12
	sound_note 12, $3D
	sound_wait 12
	sound_instrument $04
	sound_note 12, $42, $15
	sound_wait 12
	sound_instrument $05
	sound_note 24, $4E, $0D
	sound_wait 24
	sound_note 12, $3D
	sound_wait 12
	sound_instrument $04
	sound_note 12, $42, $15
	sound_wait 12
	sound_instrument $05
	sound_note 12, $46, $0D
	sound_wait 12
	sound_note 24, $44
	sound_wait 24
	sound_instrument $04
	sound_note 12, $47, $15
	sound_wait 12
	sound_instrument $05
	sound_note 24, $3D, $0D
	sound_wait 24
	sound_note 12, $41
	sound_wait 12
	sound_instrument $04
	sound_note 12, $47, $15
	sound_wait 12
	sound_instrument $05
	sound_note 24, $42, $0D
	sound_wait 12
	sound_wait 12
	sound_note 12, $49
	sound_wait 12
	sound_instrument $04
	sound_note 12, $46, $15
	sound_wait 12
	sound_instrument $05
	sound_note 12, $3F, $0D
	sound_wait 24
	sound_rs sound_note 12, $40
	sound_wait 12
	sound_instrument $04
	sound_note 12, $46, $15
	sound_wait 12
	sound_instrument $05
	sound_note 12, $3D, $0D
	sound_wait 12
	sound_note 24, $42
	sound_wait 24
	sound_instrument $04
	sound_note 12, $47, $15
	sound_wait 12
	sound_instrument $05
	sound_note 24, $3F, $0D
	sound_wait 24
	sound_note 12, $4B
	sound_wait 12
	sound_instrument $04
	sound_note 12, $47, $15
	sound_wait 12
	sound_instrument $05
	sound_note 24, $44, $0D
	sound_wait 12
	sound_wait 12
	sound_note 12, $3D
	sound_wait 12
	sound_instrument $04
	sound_note 12, $44, $15
	sound_wait 12
	sound_instrument $05
	sound_note 24, $46, $0D
	sound_wait 24
	sound_note 12, $3A
	sound_wait 12
	sound_instrument $04
	sound_note 12, $46, $15
	sound_wait 12
	sound_instrument $05
	sound_note 24, $42, $0D
	sound_wait 12
	sound_wait 12
	sound_note 12, $44
	sound_wait 12
	sound_instrument $04
	sound_note 12, $47, $15
	sound_wait 12
	sound_instrument $05
	sound_note 24, $38, $0D
	sound_wait 24
	sound_note 12, $44
	sound_wait 12
	sound_instrument $04
	sound_note 12, $47, $15
	sound_wait 12
	sound_instrument $05
	sound_note 24, $44, $0D
	sound_wait 12
	sound_wait 12
	sound_note 12, $3D
	sound_wait 12
	sound_instrument $04
	sound_note 12, $47, $15
	sound_wait 12
	sound_instrument $05
	sound_note 24, $40, $0D
	sound_wait 24
	sound_instrument $04
	sound_note 6, $4C, $15
	sound_wait 12
	sound_note 12
	sound_wait 12
	sound_instrument $05
	sound_note 24, $40, $0D
	sound_wait 12
	sound_jump Data_05_51DE

; ---- data $52D7-$52D9 (2 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_52D7:: ; 05:52D7
	sound_wait 12
	sound_end

; ---- data $52D9-$53D1 (248 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown

Data_05_52D9:: ; 05:52D9
	sound_volume $7F
	sound_pitch_add $00
Data_05_52DD:: ; 05:52DD
	sound_instrument $08
	sound_note 24, $2F, $1F
	sound_wait 24
	sound_instrument $09
	sound_note 12, $3F, $15
	sound_wait 12
	sound_instrument $08
	sound_note 6, $2A, $1F
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_instrument $09
	sound_note 12, $3F, $15
	sound_wait 12
	sound_instrument $08
	sound_note 12, $2F, $1F
	sound_wait 12
	sound_note 24, $2E
	sound_wait 24
	sound_instrument $09
	sound_note 12, $3A, $15
	sound_wait 12
	sound_instrument $08
	sound_note 6, $2A, $1F
	sound_wait 12
	sound_note 12
	sound_wait 12
	sound_note 12, $2E, $15
	sound_wait 12
	sound_instrument $09
	sound_note 12, $3A, $1F
	sound_wait 12
	sound_instrument $08
	sound_note 12, $2D
	sound_wait 12
	sound_note 24, $2C
	sound_wait 24
	sound_instrument $09
	sound_note 12, $3F, $15
	sound_wait 12
	sound_instrument $08
	sound_note 6, $31, $1F
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_instrument $09
	sound_note 12, $3F, $15
	sound_wait 12
	sound_instrument $08
	sound_note 12, $2C, $1F
	sound_wait 12
	sound_note 24, $2A
	sound_wait 24
	sound_instrument $09
	sound_note 12, $3D, $15
	sound_wait 12
	sound_instrument $08
	sound_note 12, $2C, $1F
	sound_wait 24
	sound_rs sound_note 12, $2E
	sound_wait 12
	sound_instrument $09
	sound_note 12, $40, $15
	sound_wait 12
	sound_instrument $08
	sound_note 12, $2E, $1F
	sound_wait 12
	sound_note 24, $2F
	sound_wait 24
	sound_instrument $09
	sound_note 12, $3F, $15
	sound_wait 12
	sound_instrument $08
	sound_note 6, $2A, $1F
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_instrument $09
	sound_note 12, $3F, $15
	sound_wait 12
	sound_instrument $08
	sound_note 12, $2F, $1F
	sound_wait 12
	sound_note 24, $2E
	sound_wait 24
	sound_instrument $09
	sound_note 12, $3D, $15
	sound_wait 12
	sound_instrument $08
	sound_note 6, $27, $1F
	sound_wait 12
	sound_note 12
	sound_wait 12
	sound_note 12, $2E, $15
	sound_wait 12
	sound_instrument $09
	sound_note 12, $3F, $1F
	sound_wait 12
	sound_instrument $08
	sound_note 12, $27
	sound_wait 12
	sound_note 24, $28
	sound_wait 24
	sound_instrument $09
	sound_note 12, $40, $15
	sound_wait 12
	sound_instrument $08
	sound_note 6, $2F, $1F
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_instrument $09
	sound_note 12, $40, $15
	sound_wait 12
	sound_instrument $08
	sound_note 12, $28, $1F
	sound_wait 12
	sound_note 24, $2A
	sound_wait 24
	sound_instrument $09
	sound_note 12, $40, $18
	sound_wait 12
	sound_instrument $08
	sound_note 12, $2A, $1F
	sound_wait 24
	sound_instrument $09
	sound_note 6, $44, $18
	sound_wait 12
	sound_note 12
	sound_wait 12
	sound_instrument $08
	sound_note 12, $2A, $1F
	sound_wait 12
	sound_jump Data_05_52DD

; ---- data $53D1-$53D2 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_53D1:: ; 05:53D1
	sound_end

; ---- data $53D2-$54C8 (246 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown

Data_05_53D2:: ; 05:53D2
	sound_volume $7F
	sound_pitch_add $00
Data_05_53D6:: ; 05:53D6
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 4, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $2F, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 4, $27, $10
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 3
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $2F, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 4, $27, $10
	sound_wait 12
Data_05_5404:: ; 05:5404
	sound_cmd_C1 $20
	sound_note 6, $2F, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 4, $27, $10
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $2F, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 4, $27, $10
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $2F, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 12
	sound_ret
Data_05_5434:: ; 05:5434
	sound_note 4, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $2F, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 4, $27, $10
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 3
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $2F, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 4, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_ret
Data_05_5461:: ; 05:5461
	sound_cmd_C1 $20
	sound_note 6, $2F, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 4, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 4, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $2F, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_rs sound_cmd_C1 $20
	sound_note 6
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_ret
	sound_note 4, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $2F, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 4, $27, $10
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 3
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $2F, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 4, $27, $10
	sound_wait 12
	sound_call Data_05_5404
	sound_call Data_05_5434
	sound_call Data_05_5461
	sound_jump Data_05_53D6

; ---- data $54C8-$54C9 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_54C8:: ; 05:54C8
	sound_end

; ---- data $54C9-$54CB (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 54CB (12 words = NN*(KK+1)); the byte before (54C8) is $B1

Data_05_54C9:: ; 05:54C9
	sound_stream_header 4, 2

; ---- words $54CB-$54E3 (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 54C9 [v4: bytes 54CB-54D3 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_54CB:: ; 05:54CB
	dw Data_05_5174, Data_05_51DA, Data_05_52D9, Data_05_53D2 ; track stream pointers (read by the driver)
	dw Data_05_5178, Data_05_51DE, Data_05_52DD, Data_05_53D6 ; not read by the driver: target of each track's final sound_jump
	dw Data_05_51D9, Data_05_52D7, Data_05_53D1, Data_05_54C8 ; not read by the driver: address after each track's final sound_jump
