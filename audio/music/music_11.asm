; audio/music/music_11.asm
; bank 05, $4700-$4A2F (815 bytes); pinned by layout.link
; song id 11

SECTION "audio/music/music_11", ROMX

; ---- data $4700-$4766 (102 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_4700:: ; 05:4700
	db $BF, $7F, $BD, $00, $BC, $47, $BE, $24, $C5, $18, $C3, $1C, $C4, $20, $FF, $43
	db $13, $B0, $EB, $46, $13, $9C, $44, $9C, $43, $98, $B4, $FF, $41, $AC, $BE, $20
	db $D3, $44, $10, $86, $50, $86, $55, $86, $D3, $06, $86, $D3, $49, $10, $86, $06
	db $86, $D3, $4D, $10, $86, $06, $86, $D3, $54, $10, $86, $06, $86, $D3, $49, $10
	db $86, $06, $86, $D3, $4D, $10, $86, $06, $86, $D3, $50, $10, $86, $06, $86, $D3
	db $49, $10, $86, $06, $86, $BE, $24, $FF, $43, $13, $B0, $B3, $12, $47, $CE, $42
	db $13, $B0, $B0, $B2, $04, $47

; ---- data $4766-$4769 (3 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4766:: ; 05:4766
	db $CF, $42, $B1

; ---- data $4769-$48D3 (362 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_4769:: ; 05:4769
	db $BF, $7F, $BD, $00, $BE, $06, $D3, $3F, $11, $86, $07, $86, $D3, $43, $11, $86
	db $07, $86, $BE, $04, $DB, $46, $15, $8C, $BE, $06, $D3, $3F, $11, $86, $07, $86
	db $D3, $4B, $11, $86, $07, $86, $D3, $43, $11, $86, $07, $86, $BE, $04, $DB, $46
	db $15, $8C, $BE, $06, $D3, $43, $11, $86, $07, $86, $8C, $D3, $46, $11, $86, $07
	db $86, $BE, $04, $DB, $3F, $15, $8C, $BE, $06, $D3, $43, $11, $86, $07, $86, $D3
	db $4B, $11, $86, $07, $86, $D3, $3F, $11, $86, $07, $86, $BE, $04, $DB, $46, $15
	db $8C, $BE, $06, $D3, $4B, $11, $86, $07, $86, $B4, $D3, $3D, $11, $86, $07, $86
	db $D3, $41, $11, $86, $07, $86, $BE, $04, $DB, $44, $15, $8C, $BE, $06, $D3, $41
	db $11, $86, $07, $86, $D3, $49, $11, $86, $07, $86, $D3, $41, $11, $86, $07, $86
	db $BE, $04, $DB, $44, $15, $8C, $BE, $06, $D3, $3D, $11, $86, $07, $86, $8C, $D3
	db $41, $11, $86, $07, $86, $BE, $04, $DB, $44, $15, $8C, $BE, $06, $D3, $41, $11
	db $86, $07, $86, $D3, $49, $11, $86, $07, $86, $D3, $3D, $11, $86, $07, $86, $BE
	db $04, $DB, $49, $15, $8C, $BE, $06, $D3, $41, $11, $86, $07, $86, $D3, $3F, $11
	db $86, $07, $86, $D3, $43, $11, $86, $07, $86, $BE, $04, $DB, $46, $15, $8C, $BE
	db $06, $D3, $3F, $11, $86, $07, $86, $D3, $4B, $11, $86, $07, $86, $D3, $43, $11
	db $86, $07, $86, $BE, $04, $DB, $46, $15, $8C, $BE, $06, $D3, $43, $11, $86, $07
	db $86, $B3, $A3, $47, $D3, $3E, $11, $86, $07, $86, $D3, $42, $11, $86, $07, $86
	db $BE, $04, $DB, $45, $15, $8C, $BE, $06, $D3, $42, $11, $86, $07, $86, $D3, $4A
	db $11, $86, $07, $86, $D3, $42, $11, $86, $07, $86, $BE, $04, $DB, $45, $15, $8C
	db $BE, $06, $D3, $3E, $11, $86, $07, $86, $8C, $D3, $42, $11, $86, $07, $86, $BE
	db $04, $DB, $45, $15, $8C, $BE, $06, $D3, $42, $11, $86, $07, $86, $D3, $4A, $11
	db $86, $07, $86, $D3, $3E, $11, $86, $07, $86, $BE, $04, $DB, $4A, $15, $8C, $BE
	db $06, $D3, $42, $11, $86, $07, $86, $B2, $6D, $47

; ---- data $48D3-$48D4 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_48D3:: ; 05:48D3
	db $B1

; ---- data $48D4-$4990 (188 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_48D4:: ; 05:48D4
	db $BF, $7F, $BD, $00, $BE, $08, $E7, $27, $1D, $98, $BE, $09, $DB, $3F, $15, $8C
	db $BE, $08, $D5, $2E, $1D, $8C, $E7, $98, $BE, $09, $DB, $3F, $15, $98, $B4, $BE
	db $08, $D2, $52, $13, $86, $5B, $86, $4F, $86, $57, $86, $BE, $09, $DB, $37, $15
	db $8C, $BE, $08, $D2, $4F, $13, $86, $57, $86, $4B, $86, $52, $86, $46, $86, $4F
	db $86, $BE, $09, $DB, $3F, $15, $8C, $BE, $08, $DB, $33, $1D, $8C, $B4, $E7, $31
	db $98, $BE, $09, $DB, $3D, $15, $8C, $BE, $08, $D5, $2C, $1D, $8C, $E7, $98, $BE
	db $09, $DB, $3D, $15, $98, $8C, $BE, $08, $D7, $31, $1D, $8C, $BE, $09, $DB, $3D
	db $15, $8C, $BE, $08, $D7, $31, $1D, $98, $DB, $8C, $BE, $09, $DB, $41, $15, $98
	db $B3, $D8, $48, $B3, $F3, $48, $E7, $32, $1D, $98, $BE, $09, $DB, $3E, $15, $8C
	db $BE, $08, $D5, $2D, $1D, $8C, $E7, $98, $BE, $09, $DB, $3E, $15, $98, $8C, $BE
	db $08, $D7, $32, $1D, $8C, $BE, $09, $DB, $3E, $15, $8C, $BE, $08, $D7, $32, $1D
	db $98, $DB, $8C, $BE, $09, $DB, $42, $15, $98, $B2, $D8, $48

; ---- data $4990-$4991 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4990:: ; 05:4990
	db $B1

; ---- data $4991-$4A14 (131 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_4991:: ; 05:4991
	db $BF, $7F, $BD, $00, $BE, $64, $D5, $27, $11, $8C, $D2, $24, $0B, $8C, $C1, $20
	db $D5, $25, $0F, $81, $C1, $40, $9B, $83, $D5, $27, $11, $8C, $C1, $20, $D5, $25
	db $0F, $81, $C1, $40, $8B, $D2, $24, $0B, $8C, $D5, $27, $11, $8C, $D2, $24, $0B
	db $8C, $C1, $20, $D5, $25, $0F, $81, $C1, $40, $9B, $83, $D5, $27, $11, $8C, $C1
	db $20, $D5, $25, $0F, $81, $C1, $40, $8B, $D2, $24, $0B, $8C, $B4, $B3, $BA, $49
	db $D5, $27, $11, $8C, $D2, $24, $0B, $8C, $C1, $20, $D5, $25, $0F, $81, $C1, $40
	db $9B, $83, $D5, $27, $11, $8C, $C1, $20, $D5, $25, $0F, $81, $C1, $40, $8B, $DB
	db $24, $0B, $8C, $B4, $B3, $BA, $49, $B3, $BA, $49, $B3, $BA, $49, $B3, $E1, $49
	db $B2, $95, $49

; ---- data $4A14-$4A15 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4A14:: ; 05:4A14
	db $B1

; ---- data $4A15-$4A17 (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 4A17 (12 words = NN*(KK+1)); the byte before (4A14) is $B1

Data_05_4A15:: ; 05:4A15
	db $04, $02

; ---- words $4A17-$4A2F (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 4A15 [v4: bytes 4A17-4A1F were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_4A17:: ; 05:4A17
	dw Data_05_4700, Data_05_4769, Data_05_48D4, Data_05_4991, $4704, $476D, $48D8, $4995
	dw Data_05_4766, Data_05_48D3, Data_05_4990, Data_05_4A14
