; audio/music/music_1a.asm
; bank 05, $5DCF-$60E9 (794 bytes); pinned by layout.link
; song id 1A

SECTION "audio/music/music_1a", ROMX

; ---- data $5DCF-$5E23 (84 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_5DCF:: ; 05:5DCF
	db $BF, $7F, $BD, $00, $BC, $39, $BE, $52, $C5, $10, $C3, $20, $C4, $1E, $F3, $47
	db $18, $A4, $DB, $49, $19, $8C, $D7, $47, $8C, $F7, $8C, $A4, $DB, $49, $8C, $4B
	db $8C, $F7, $4C, $8C, $A4, $DB, $4B, $8C, $49, $8C, $EB, $4B, $8C, $98, $DB, $4C
	db $8C, $4B, $98, $49, $98, $F7, $47, $8C, $A4, $DB, $49, $8C, $4B, $8C, $EF, $49
	db $8C, $9C, $EB, $44, $9C, $E7, $49, $98, $F3, $47, $A4, $DB, $44, $8C, $46, $8C
	db $EB, $47, $8C, $98

; ---- data $5E23-$5E37 (20 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_5E23:: ; 05:5E23
	db $E7, $46, $98, $DB, $44, $8C, $E7, $46, $98, $CE, $47, $8C, $B0, $A4, $CF, $9C
	db $B2, $D3, $5D, $B1

; ---- data $5E37-$5F09 (210 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_5E37:: ; 05:5E37
	db $BF, $7F, $BD, $00, $BE, $05, $E7, $44, $0C, $98, $BE, $04, $DB, $4C, $12, $8C
	db $BE, $05, $E7, $40, $0C, $98, $DB, $47, $8C, $BE, $04, $DB, $4C, $12, $8C, $BE
	db $05, $DB, $3B, $0C, $8C, $42, $8C, $3B, $8C, $BE, $04, $DB, $4B, $12, $8C, $BE
	db $05, $E7, $42, $0C, $98, $DB, $47, $8C, $BE, $04, $DB, $4E, $12, $8C, $BE, $05
	db $DB, $42, $0C, $8C, $E7, $44, $98, $BE, $04, $DB, $49, $12, $8C, $BE, $05, $E7
	db $40, $0C, $98, $DB, $49, $8C, $BE, $04, $DB, $4C, $12, $8C, $BE, $05, $DB, $42
	db $0C, $8C, $47, $8C, $3F, $8C, $BE, $04, $DB, $4E, $12, $8C, $BE, $05, $DB, $47
	db $0C, $98, $46, $98, $BE, $05, $EB, $44, $8C, $98, $BE, $04, $DB, $4B, $12, $8C
	db $BE, $05, $E7, $3F, $0C, $98, $DB, $47, $8C, $BE, $04, $DB, $4B, $12, $8C, $BE
	db $05, $DB, $3B, $0C, $8C, $E7, $3D, $98, $BE, $04, $DB, $4D, $12, $8C, $BE, $05
	db $E7, $41, $0C, $98, $DB, $49, $8C, $BE, $04, $DB, $4D, $12, $8C, $BE, $05, $DB
	db $41, $0C, $8C, $E7, $44, $98, $BE, $04, $DB, $4C, $12, $8C, $BE, $05, $E7, $40
	db $0C, $98, $DB, $38, $8C, $BE, $04, $DB, $47, $12, $8C, $BE, $05, $DB, $3B, $0C
	db $8C, $E7

; ---- data $5F09-$5F67 (94 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_5F09:: ; 05:5F09
	db $44, $98, $BE, $04, $DB, $4C, $12, $8C, $BE, $05, $E7, $40, $0C, $98, $DB, $49
	db $8C, $BE, $04, $DB, $4C, $12, $8C, $BE, $05, $DB, $40, $0C, $8C, $47, $8C, $3D
	db $8C, $BE, $04, $DB, $4C, $12, $8C, $BE, $05, $E7, $40, $0C, $98, $DB, $45, $8C
	db $BE, $04, $DB, $4C, $12, $8C, $BE, $05, $DB, $3D, $0C, $8C, $3F, $8C, $3B, $8C
	db $BE, $04, $DB, $4B, $12, $8C, $BE, $05, $DB, $40, $0C, $98, $42, $8C, $BE, $04
	db $DB, $4E, $12, $8C, $BE, $05, $DB, $3B, $0C, $8C, $B2, $3B, $5E, $B1

; ---- data $5F67-$5FF1 (138 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_5F67:: ; 05:5F67
	db $BF, $7F, $BD, $00, $BE, $20, $E7, $28, $19, $98, $DB, $44, $12, $8C, $D7, $2F
	db $19, $8C, $E7, $98, $DB, $44, $12, $8C, $34, $19, $8C, $E7, $33, $98, $DB, $42
	db $12, $8C, $D7, $2F, $19, $8C, $E7, $98, $DB, $47, $12, $98, $E7, $31, $19, $98
	db $DB, $40, $12, $8C, $D7, $2A, $19, $8C, $E7, $98, $E7, $46, $12, $8C, $DB, $2A
	db $8C, $EB, $2F, $19, $98, $DB, $42, $12, $8C, $2F, $19, $98, $2E, $98, $EB, $2C
	db $8C, $98, $DB, $44, $12, $8C, $D7, $33, $19, $8C, $E7, $98, $DB, $44, $12, $8C
	db $2C, $19, $8C, $E7, $31, $98, $DB, $44, $12, $8C, $D7, $2C, $19, $8C, $E7, $98
	db $DB, $44, $12, $98, $E7, $2A, $19, $98, $DB, $44, $12, $8C, $D7, $2A, $19, $8C
	db $E7, $98, $DB, $40, $12, $8C, $25, $19, $8C, $E7

; ---- data $5FF1-$602A (57 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_5FF1:: ; 05:5FF1
	db $2A, $98, $DB, $44, $12, $8C, $D7, $36, $19, $8C, $E7, $98, $DB, $44, $12, $98
	db $E7, $2F, $19, $98, $DB, $45, $12, $8C, $D7, $2A, $19, $8C, $E7, $98, $DB, $45
	db $12, $8C, $2A, $19, $8C, $E7, $2F, $98, $DB, $42, $12, $8C, $31, $19, $98, $33
	db $8C, $DB, $47, $12, $98, $B2, $6B, $5F, $B1

; ---- data $602A-$609A (112 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_602A:: ; 05:602A
	db $BF, $7F, $BD, $00, $BE, $64, $D5, $27, $0F, $8C, $D3, $24, $0B, $8C, $C1, $28
	db $D5, $2F, $0D, $81, $C1, $40, $8B, $D5, $27, $0F, $86, $D3, $24, $09, $86, $D5
	db $27, $0F, $8C, $D3, $24, $0B, $8C, $C1, $28, $D5, $2F, $0D, $81, $C1, $40, $8B
	db $DB, $24, $8C, $D5, $27, $0F, $8C, $D3, $24, $0B, $8C, $C1, $28, $D5, $2F, $0D
	db $81, $C1, $40, $8B, $D5, $27, $0F, $86, $D3, $24, $09, $86, $D5, $27, $0F, $8C
	db $D3, $24, $0B, $8C, $C1, $28, $D5, $2F, $0D, $81, $C1, $40, $8B, $DB, $24, $8C
	db $B4, $B3, $5D, $60, $B3, $5D, $60, $B3, $5D, $60, $B3, $5D, $60, $B3, $5D, $60

; ---- data $609A-$60CF (53 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_609A:: ; 05:609A
	db $B3, $5D, $60, $B3, $5D, $60, $D5, $27, $0F, $8C, $D3, $24, $0B, $8C, $C1, $28
	db $D5, $2F, $0D, $81, $C1, $40, $8B, $D3, $24, $0B, $8C, $D5, $27, $0F, $8C, $C1
	db $28, $D5, $2F, $0D, $81, $C1, $40, $8B, $28, $D5, $81, $C1, $40, $8B, $DB, $24
	db $8C, $B2, $2E, $60, $B1

; ---- data $60CF-$60D1 (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 60D1 (12 words = NN*(KK+1)); the byte before (60CE) is $B1

Data_05_60CF:: ; 05:60CF
	db $04, $02

; ---- words $60D1-$60E9 (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 60CF [v4: bytes 60D1-60D9 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_60D1:: ; 05:60D1
	dw Data_05_5DCF, Data_05_5E37, Data_05_5F67, Data_05_602A, $5DD3, $5E3B, $5F6B, $602E
	dw $5E36, $5F66, $6029, $60CE
