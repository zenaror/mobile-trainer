; audio/music/music_16.asm
; bank 05, $5174-$54E3 (879 bytes); pinned by layout.link
; song id 16

SECTION "audio/music/music_16", ROMX

; ---- data $5174-$51D9 (101 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown

Data_05_5174:: ; 05:5174
	db $BF, $7F, $BD, $00, $BC, $3F, $BE, $03, $C5, $10, $C3, $20, $C4, $30, $98, $DB
	db $42, $15, $8C, $41, $8C, $42, $8C, $44, $98, $42, $8C, $8C, $D5, $3D, $8C, $F7
	db $A8, $98, $DB, $42, $8C, $41, $8C, $42, $8C, $44, $98, $42, $8C, $8C, $3A, $98
	db $3B, $98, $EB, $3D, $9C, $98, $DB, $42, $8C, $41, $8C, $42, $8C, $44, $98, $E7
	db $3D, $8C, $8C, $DB, $3F, $8C, $41, $8C, $E1, $42, $98, $DB, $3D, $8C, $3A, $8C
	db $E7, $3D, $8C, $8C, $D5, $3B, $8C, $EF, $A4, $E7, $3F, $8C, $8C, $D5, $3D, $8C
	db $EF, $A8, $B2, $78, $51

; ---- data $51D9-$51DA (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_51D9:: ; 05:51D9
	db $B1

; ---- data $51DA-$52D7 (253 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown

Data_05_51DA:: ; 05:51DA
	db $BF, $7F, $BD, $00, $BE, $05, $E7, $42, $0D, $98, $BE, $04, $DB, $47, $15, $8C
	db $BE, $05, $E7, $3F, $0D, $98, $DB, $4B, $8C, $BE, $04, $DB, $47, $15, $8C, $BE
	db $05, $E7, $46, $0D, $8C, $8C, $DB, $3D, $8C, $BE, $04, $DB, $42, $15, $8C, $BE
	db $05, $E7, $4E, $0D, $98, $DB, $3D, $8C, $BE, $04, $DB, $42, $15, $8C, $BE, $05
	db $DB, $46, $0D, $8C, $E7, $44, $98, $BE, $04, $DB, $47, $15, $8C, $BE, $05, $E7
	db $3D, $0D, $98, $DB, $41, $8C, $BE, $04, $DB, $47, $15, $8C, $BE, $05, $E7, $42
	db $0D, $8C, $8C, $DB, $49, $8C, $BE, $04, $DB, $46, $15, $8C, $BE, $05, $DB, $3F
	db $0D, $98, $40, $8C, $BE, $04, $DB, $46, $15, $8C, $BE, $05, $DB, $3D, $0D, $8C
	db $E7, $42, $98, $BE, $04, $DB, $47, $15, $8C, $BE, $05, $E7, $3F, $0D, $98, $DB
	db $4B, $8C, $BE, $04, $DB, $47, $15, $8C, $BE, $05, $E7, $44, $0D, $8C, $8C, $DB
	db $3D, $8C, $BE, $04, $DB, $44, $15, $8C, $BE, $05, $E7, $46, $0D, $98, $DB, $3A
	db $8C, $BE, $04, $DB, $46, $15, $8C, $BE, $05, $E7, $42, $0D, $8C, $8C, $DB, $44
	db $8C, $BE, $04, $DB, $47, $15, $8C, $BE, $05, $E7, $38, $0D, $98, $DB, $44, $8C
	db $BE, $04, $DB, $47, $15, $8C, $BE, $05, $E7, $44, $0D, $8C, $8C, $DB, $3D, $8C
	db $BE, $04, $DB, $47, $15, $8C, $BE, $05, $E7, $40, $0D, $98, $BE, $04, $D5, $4C
	db $15, $8C, $DB, $8C, $BE, $05, $E7, $40, $0D, $8C, $B2, $DE, $51

; ---- data $52D7-$52D9 (2 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_52D7:: ; 05:52D7
	db $8C, $B1

; ---- data $52D9-$53D1 (248 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown

Data_05_52D9:: ; 05:52D9
	db $BF, $7F, $BD, $00, $BE, $08, $E7, $2F, $1F, $98, $BE, $09, $DB, $3F, $15, $8C
	db $BE, $08, $D5, $2A, $1F, $8C, $E7, $98, $BE, $09, $DB, $3F, $15, $8C, $BE, $08
	db $DB, $2F, $1F, $8C, $E7, $2E, $98, $BE, $09, $DB, $3A, $15, $8C, $BE, $08, $D5
	db $2A, $1F, $8C, $DB, $8C, $DB, $2E, $15, $8C, $BE, $09, $DB, $3A, $1F, $8C, $BE
	db $08, $DB, $2D, $8C, $E7, $2C, $98, $BE, $09, $DB, $3F, $15, $8C, $BE, $08, $D5
	db $31, $1F, $8C, $E7, $98, $BE, $09, $DB, $3F, $15, $8C, $BE, $08, $DB, $2C, $1F
	db $8C, $E7, $2A, $98, $BE, $09, $DB, $3D, $15, $8C, $BE, $08, $DB, $2C, $1F, $98
	db $2E, $8C, $BE, $09, $DB, $40, $15, $8C, $BE, $08, $DB, $2E, $1F, $8C, $E7, $2F
	db $98, $BE, $09, $DB, $3F, $15, $8C, $BE, $08, $D5, $2A, $1F, $8C, $E7, $98, $BE
	db $09, $DB, $3F, $15, $8C, $BE, $08, $DB, $2F, $1F, $8C, $E7, $2E, $98, $BE, $09
	db $DB, $3D, $15, $8C, $BE, $08, $D5, $27, $1F, $8C, $DB, $8C, $DB, $2E, $15, $8C
	db $BE, $09, $DB, $3F, $1F, $8C, $BE, $08, $DB, $27, $8C, $E7, $28, $98, $BE, $09
	db $DB, $40, $15, $8C, $BE, $08, $D5, $2F, $1F, $8C, $E7, $98, $BE, $09, $DB, $40
	db $15, $8C, $BE, $08, $DB, $28, $1F, $8C, $E7, $2A, $98, $BE, $09, $DB, $40, $18
	db $8C, $BE, $08, $DB, $2A, $1F, $98, $BE, $09, $D5, $44, $18, $8C, $DB, $8C, $BE
	db $08, $DB, $2A, $1F, $8C, $B2, $DD, $52

; ---- data $53D1-$53D2 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_53D1:: ; 05:53D1
	db $B1

; ---- data $53D2-$54C8 (246 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown

Data_05_53D2:: ; 05:53D2
	db $BF, $7F, $BD, $00, $BE, $64, $D3, $27, $10, $8C, $D2, $24, $0B, $8C, $C1, $20
	db $D5, $2F, $0E, $81, $C1, $40, $8B, $D3, $27, $10, $86, $D2, $24, $0B, $86, $D2
	db $8C, $C1, $20, $D5, $2F, $0E, $81, $C1, $40, $8B, $D2, $24, $0B, $8C, $D3, $27
	db $10, $8C, $C1, $20, $D5, $2F, $0E, $81, $C1, $40, $8B, $D2, $24, $0B, $8C, $D3
	db $27, $10, $8C, $C1, $20, $D5, $2F, $0E, $81, $C1, $40, $8B, $D2, $24, $0B, $8C
	db $D3, $27, $10, $8C, $C1, $20, $D5, $2F, $0E, $81, $C1, $40, $8B, $D2, $24, $0B
	db $8C, $B4, $D3, $27, $10, $8C, $D2, $24, $0B, $8C, $C1, $20, $D5, $2F, $0E, $81
	db $C1, $40, $8B, $D3, $27, $10, $86, $D2, $24, $0B, $86, $D2, $8C, $C1, $20, $D5
	db $2F, $0E, $81, $C1, $40, $8B, $D3, $27, $10, $8C, $D2, $24, $0B, $8C, $B4, $C1
	db $20, $D5, $2F, $0E, $81, $C1, $40, $8B, $D3, $27, $10, $8C, $D2, $24, $0B, $8C
	db $D3, $27, $10, $8C, $D2, $24, $0B, $8C, $C1, $20, $D5, $2F, $0E, $81, $C1, $40
	db $8B, $20, $D5, $81, $C1, $40, $8B, $D2, $24, $0B, $86, $D2, $86, $B4, $D3, $27
	db $10, $8C, $D2, $24, $0B, $8C, $C1, $20, $D5, $2F, $0E, $81, $C1, $40, $8B, $D3
	db $27, $10, $86, $D2, $24, $0B, $86, $D2, $8C, $C1, $20, $D5, $2F, $0E, $81, $C1
	db $40, $8B, $D2, $24, $0B, $8C, $D3, $27, $10, $8C, $B3, $04, $54, $B3, $34, $54
	db $B3, $61, $54, $B2, $D6, $53

; ---- data $54C8-$54C9 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_54C8:: ; 05:54C8
	db $B1

; ---- data $54C9-$54CB (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 54CB (12 words = NN*(KK+1)); the byte before (54C8) is $B1

Data_05_54C9:: ; 05:54C9
	db $04, $02

; ---- words $54CB-$54E3 (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 54C9 [v4: bytes 54CB-54D3 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_54CB:: ; 05:54CB
	dw Data_05_5174, Data_05_51DA, Data_05_52D9, Data_05_53D2, $5178, $51DE, $52DD, $53D6
	dw Data_05_51D9, Data_05_52D7, Data_05_53D1, Data_05_54C8
