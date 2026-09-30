; audio/music/music_12.asm
; bank 05, $4A2F-$4CA1 (626 bytes); pinned by layout.link
; song id 12

SECTION "audio/music/music_12", ROMX

; ---- data $4A2F-$4B30 (257 bytes) [CONFIRMED] read as data by executed code (in up to 6/18 scenarios); content class unknown

Data_05_4A2F:: ; 05:4A2F
	db $BF, $7F, $BD, $00, $BC, $39, $BE, $08, $D1, $4F, $10, $86, $BE, $0B, $D3, $47
	db $16, $86, $BE, $08, $D1, $5B, $10, $86, $58, $86, $BE, $0B, $D3, $47, $16, $86
	db $BE, $08, $D1, $5B, $10, $86, $54, $86, $BE, $0B, $D3, $46, $16, $86, $BE, $08
	db $D1, $59, $10, $86, $4D, $86, $BE, $0B, $D3, $46, $16, $86, $BE, $08, $D1, $59
	db $10, $86, $54, $86, $4D, $86, $BE, $0B, $D3, $46, $16, $86, $BE, $08, $D1, $59
	db $10, $86, $BE, $0B, $D3, $47, $16, $86, $BE, $08, $D1, $5B, $10, $86, $58, $86
	db $5B, $86, $BE, $0B, $D3, $47, $16, $86, $BE, $08, $D1, $54, $10, $86, $5B, $86
	db $BE, $0B, $D3, $48, $16, $86, $BE, $08, $D1, $58, $10, $86, $50, $86, $BE, $0B
	db $D3, $48, $16, $86, $BE, $08, $D1, $5C, $10, $86, $59, $86, $BE, $0B, $D3, $48
	db $16, $86, $BE, $08, $D1, $55, $10, $86, $59, $86, $B4, $D1, $4F, $10, $86, $BE
	db $0B, $D3, $47, $16, $86, $BE, $08, $D1, $5B, $10, $86, $58, $86, $BE, $0B, $D3
	db $47, $16, $86, $BE, $08, $D1, $5B, $10, $86, $54, $86, $BE, $0B, $D3, $46, $16
	db $86, $BE, $08, $D1, $59, $10, $86, $4D, $86, $BE, $0B, $D3, $46, $16, $86, $BE
	db $08, $D1, $59, $10, $86, $54, $86, $4D, $86, $BE, $0B, $D3, $46, $16, $86, $BE
	db $08, $D1, $59, $10, $86, $B4, $B3, $81, $4A, $B3, $CA, $4A, $B3, $81, $4A, $B3
	db $CA, $4A, $BE, $0B, $D3, $47, $16, $9E, $48, $92, $D3, $92, $D3, $92, $B2, $33
	db $4A

; ---- data $4B30-$4B31 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4B30:: ; 05:4B30
	db $B1

; ---- data $4B31-$4B7B (74 bytes) [CONFIRMED] read as data by executed code (in up to 6/18 scenarios); content class unknown

Data_05_4B31:: ; 05:4B31
	db $BF, $7F, $BD, $00, $BE, $06, $86, $D3, $40, $15, $92, $D3, $92, $D3, $3F, $92
	db $D3, $98, $D3, $8C, $D3, $40, $15, $98, $D3, $92, $D3, $41, $92, $D3, $92, $D3
	db $92, $B4, $86, $D3, $40, $15, $92, $D3, $92, $D3, $3F, $92, $D3, $98, $D3, $8C
	db $B4, $B3, $45, $4B, $B3, $53, $4B, $B3, $45, $4B, $B3, $53, $4B, $D3, $40, $15
	db $9E, $41, $92, $D3, $92, $D3, $92, $B2, $35, $4B

; ---- data $4B7B-$4B7C (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4B7B:: ; 05:4B7B
	db $B1

; ---- data $4B7C-$4BD9 (93 bytes) [CONFIRMED] read as data by executed code (in up to 6/18 scenarios); content class unknown

Data_05_4B7C:: ; 05:4B7C
	db $BF, $7F, $BD, $00, $BE, $21, $DB, $24, $15, $92, $D5, $86, $D5, $30, $9A, $29
	db $8C, $D3, $8C, $D5, $27, $86, $DB, $29, $8C, $DB, $24, $15, $92, $D5, $86, $D5
	db $30, $9A, $31, $8C, $D3, $8C, $D5, $2C, $86, $DB, $25, $8C, $B4, $DB, $24, $15
	db $92, $D5, $86, $D5, $30, $9A, $29, $8C, $D3, $8C, $D5, $27, $86, $DB, $29, $8C
	db $B4, $B3, $95, $4B, $B3, $A9, $4B, $B3, $95, $4B, $B3, $A9, $4B, $DB, $24, $15
	db $A6, $D3, $31, $8C, $D5, $2C, $86, $DB, $25, $8C, $B2, $80, $4B

; ---- data $4BD9-$4BDA (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4BD9:: ; 05:4BD9
	db $B1

; ---- data $4BDA-$4C86 (172 bytes) [CONFIRMED] read as data by executed code (in up to 6/18 scenarios); content class unknown

Data_05_4BDA:: ; 05:4BDA
	db $BF, $7F, $BD, $00, $BE, $64, $D3, $27, $11, $86, $D2, $24, $0B, $86, $DB, $0D
	db $8C, $D5, $2A, $0F, $86, $D2, $24, $0B, $86, $C1, $20, $D5, $25, $10, $81, $C1
	db $40, $85, $D2, $24, $0B, $86, $D3, $27, $11, $86, $D2, $24, $0B, $86, $DB, $0D
	db $8C, $C1, $20, $D5, $25, $10, $81, $C1, $40, $85, $D2, $24, $0B, $86, $D2, $86
	db $D5, $2A, $0F, $86, $D3, $27, $11, $86, $D2, $24, $0B, $86, $DB, $0D, $8C, $D5
	db $2A, $0F, $86, $D2, $24, $0B, $86, $C1, $20, $D5, $25, $10, $81, $C1, $40, $85
	db $D2, $24, $0B, $86, $D3, $27, $11, $86, $D2, $24, $0B, $86, $DB, $0D, $8C, $C1
	db $20, $D5, $25, $10, $81, $C1, $40, $85, $D2, $24, $0B, $86, $D2, $86, $D5, $2A
	db $0F, $86, $B4, $B3, $1E, $4C, $B3, $1E, $4C, $B3, $1E, $4C, $B3, $1E, $4C, $B3
	db $1E, $4C, $D3, $27, $11, $A0, $D2, $2E, $03, $86, $06, $86, $09, $86, $0C, $86
	db $0F, $86, $D2, $86, $D5, $2D, $86, $2C, $86, $B2, $DE, $4B

; ---- data $4C86-$4C87 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4C86:: ; 05:4C86
	db $B1

; ---- data $4C87-$4C89 (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 4C89 (12 words = NN*(KK+1)); the byte before (4C86) is $B1

Data_05_4C87:: ; 05:4C87
	db $04, $02

; ---- words $4C89-$4CA1 (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 4C87 [v4: bytes 4C89-4C91 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_4C89:: ; 05:4C89
	dw Data_05_4A2F, Data_05_4B31, Data_05_4B7C, Data_05_4BDA, $4A33, $4B35, $4B80, $4BDE
	dw Data_05_4B30, Data_05_4B7B, Data_05_4BD9, Data_05_4C86
