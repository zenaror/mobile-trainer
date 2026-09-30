; audio/music/music_17.asm
; bank 05, $54E3-$5AF6 (1555 bytes); pinned by layout.link
; song id 17

SECTION "audio/music/music_17", ROMX

; ---- data $54E3-$5617 (308 bytes) [CONFIRMED] read as data by executed code (in up to 12/18 scenarios); content class unknown

Data_05_54E3:: ; 05:54E3
	db $BF, $7F, $BD, $00, $BC, $36, $BE, $01, $C5, $18, $C3, $20, $C4, $16, $DB, $44
	db $13, $8C, $D4, $49, $8C, $D5, $48, $86, $D4, $46, $8C, $E7, $44, $A2, $9C, $D4
	db $44, $13, $8C, $DB, $42, $8C, $D4, $41, $8C, $DB, $42, $8C, $D4, $3F, $8C, $B4
	db $C1, $28, $E1, $41, $13, $81, $C1, $40, $91, $D5, $44, $AA, $B4, $B3, $01, $55
	db $C1, $28, $E1, $41, $13, $81, $C1, $40, $91, $D4, $3D, $92, $DB, $38, $8C, $E1
	db $3A, $92, $D5, $3D, $92, $DB, $3F, $8C, $B4, $8C, $DB, $38, $13, $98, $42, $98
	db $DB, $8C, $DB, $41, $8C, $3F, $8C, $B4, $E7, $3D, $B0, $AA, $BE, $20, $D5, $44
	db $13, $92, $B4, $BE, $01, $C5, $18, $C3, $20, $C4, $16, $DB, $8C, $D4, $49, $8C
	db $D5, $48, $86, $D4, $46, $8C, $E7, $44, $A2, $B3, $01, $55, $B3, $13, $55, $B3
	db $01, $55, $B3, $23, $55, $B3, $3C, $55, $E7, $3D, $13, $B0, $B3, $4E, $55, $BE
	db $01, $8C, $C1, $28, $D5, $46, $13, $81, $C1, $40, $85, $D5, $45, $86, $46, $86
	db $D4, $48, $8C, $D5, $49, $8C, $D5, $8C, $D5, $48, $8C, $DB, $46, $92, $44, $92
	db $46, $92, $E1, $3D, $9A, $D5, $3F, $8C, $41, $8C, $DB, $42, $86, $9C, $D5, $8C
	db $C1, $28, $D5, $81, $C1, $40, $85, $D4, $41, $8C, $D5, $3F, $8C, $DB, $3D, $92
	db $41, $98, $42, $98, $43, $92, $E1, $44, $9A, $8C, $C1, $28, $D5, $46, $81, $C1
	db $40, $85, $D5, $45, $86, $46, $86, $D4, $48, $8C, $D5, $49, $8C, $D5, $8C, $D5
	db $48, $8C, $DB, $46, $92, $44, $92, $46, $92, $3D, $98, $3F, $98, $41, $8C, $98
	db $3A, $98, $46, $92, $3D, $92, $D7, $46, $8C, $F7, $44, $B0, $92, $BE, $26, $D2
	db $09, $8C, $D2, $38, $92, $44, $8C, $50, $8C, $44, $86, $5C, $86, $50, $86, $38
	db $86, $B2, $E7, $54

; ---- data $5617-$5618 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_5617:: ; 05:5617
	db $B1

; ---- data $5618-$585A (578 bytes) [CONFIRMED] read as data by executed code (in up to 12/18 scenarios); content class unknown

Data_05_5618:: ; 05:5618
	db $BF, $7F, $BD, $00, $BE, $06, $D5, $41, $0B, $8C, $44, $86, $3D, $86, $BE, $04
	db $D5, $4D, $12, $86, $BE, $06, $D5, $41, $0B, $8C, $44, $8C, $49, $8C, $3D, $86
	db $BE, $04, $DB, $4D, $12, $8C, $BE, $06, $D5, $44, $0B, $8C, $B4, $D5, $46, $0B
	db $8C, $49, $86, $42, $86, $BE, $04, $D5, $4E, $12, $86, $BE, $06, $D5, $46, $0B
	db $8C, $44, $8C, $3C, $8C, $3F, $86, $BE, $04, $DB, $50, $12, $8C, $BE, $06, $D5
	db $44, $0B, $8C, $B4, $D5, $41, $0B, $8C, $44, $86, $3D, $86, $BE, $04, $D5, $4D
	db $12, $86, $BE, $06, $D5, $41, $0B, $8C, $44, $8C, $49, $8C, $41, $86, $BE, $04
	db $DB, $4D, $12, $8C, $BE, $06, $D5, $49, $0B, $8C, $B4, $D5, $46, $0B, $8C, $3D
	db $8C, $BE, $04, $D5, $4E, $12, $86, $BE, $06, $D5, $46, $0B, $8C, $44, $8C, $3C
	db $8C, $3F, $86, $BE, $04, $DB, $50, $12, $8C, $BE, $06, $D5, $44, $0B, $8C, $B4
	db $D5, $41, $0B, $8C, $46, $8C, $BE, $04, $D5, $4D, $12, $86, $BE, $06, $D5, $3D
	db $0B, $8C, $42, $8C, $46, $8C, $3A, $86, $BE, $04, $DB, $4E, $12, $8C, $BE, $06
	db $D5, $44, $0B, $8C, $B4, $D5, $48, $0B, $8C, $3F, $8C, $BE, $04, $D5, $50, $12
	db $86, $BE, $06, $D5, $42, $0B, $86, $BE, $04, $DB, $52, $12, $98, $DB, $8C, $DB
	db $50, $8C, $4E, $8C, $B4, $BE, $06, $D5, $44, $0B, $8C, $49, $8C, $BE, $04, $D5
	db $4D, $12, $86, $BE, $06, $D5, $3D, $0B, $8C, $47, $8C, $3B, $8C, $40, $86, $BE
	db $04, $DB, $4C, $12, $8C, $BE, $06, $D5, $44, $0B, $8C, $B4, $46, $8C, $49, $86
	db $3D, $86, $BE, $04, $D5, $4E, $12, $86, $BE, $06, $D5, $46, $0B, $8C, $48, $8C
	db $3C, $8C, $3F, $86, $BE, $04, $DB, $50, $12, $8C, $BE, $06, $D5, $42, $0B, $86
	db $3F, $86, $B3, $1C, $56, $B3, $45, $56, $B3, $6C, $56, $B3, $93, $56, $B3, $B8
	db $56, $B3, $DD, $56, $B3, $FD, $56, $D5, $46, $0B, $8C, $49, $86, $3D, $86, $BE
	db $04, $D5, $4E, $12, $86, $BE, $06, $D5, $46, $0B, $8C, $48, $8C, $3C, $8C, $3F
	db $86, $BE, $04, $DB, $50, $12, $8C, $BE, $06, $D5, $43, $0B, $86, $37, $86, $D5
	db $42, $0B, $8C, $49, $8C, $BE, $04, $D5, $4E, $12, $86, $BE, $06, $D5, $3D, $0B
	db $8C, $46, $8C, $3D, $8C, $40, $86, $BE, $04, $DB, $4E, $12, $8C, $BE, $06, $D5
	db $49, $0B, $8C, $B4, $D5, $48, $0B, $8C, $3F, $8C, $BE, $04, $D5, $4D, $12, $86
	db $BE, $06, $D5, $48, $0B, $8C, $46, $8C, $49, $8C, $3D, $86, $BE, $04, $DB, $52
	db $12, $8C, $BE, $06, $D5, $41, $0B, $8C, $B4, $46, $8C, $D5, $3F, $0C, $8C, $BE
	db $04, $D5, $4B, $12, $86, $BE, $06, $D5, $46, $0B, $8C, $44, $8C, $48, $8C, $3C
	db $86, $BE, $04, $DB, $50, $12, $8C, $BE, $06, $D5, $42, $0B, $8C, $BE, $04, $DB
	db $49, $12, $98, $4B, $98, $4C, $92, $D5, $4D, $8C, $BE, $06, $D5, $44, $0B, $86
	db $3D, $8C, $B3, $87, $57, $B3, $AC, $57, $D5, $43, $0B, $8C, $46, $8C, $BE, $04
	db $D5, $49, $12, $86, $BE, $06, $D5, $3D, $0B, $8C, $4B, $8C, $43, $8C, $46, $86
	db $BE, $04, $DB, $4D, $12, $8C, $BE, $06, $D5, $3F, $0B, $8C, $44, $8C, $48, $8C
	db $BE, $04, $D5, $50, $12, $86, $BE, $06, $D5, $3F, $0B, $8C, $4B, $8C, $42, $8C
	db $48, $86, $BE, $04, $D5, $50, $12, $8C, $BE, $06, $D5, $3F, $0B, $8C, $B0, $B2
	db $1C, $56

; ---- data $585A-$585B (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_585A:: ; 05:585A
	db $B1

; ---- data $585B-$5997 (316 bytes) [CONFIRMED] read as data by executed code (in up to 12/18 scenarios); content class unknown

Data_05_585B:: ; 05:585B
	db $BF, $7F, $BD, $00, $BE, $09, $D5, $25, $1B, $98, $44, $12, $92, $29, $1B, $92
	db $D5, $8C, $DB, $44, $12, $8C, $29, $1B, $8C, $D5, $2A, $1B, $98, $46, $12, $92
	db $2C, $1B, $92, $D5, $8C, $DB, $48, $12, $8C, $2C, $1B, $8C, $B4, $D5, $25, $1B
	db $98, $44, $12, $92, $29, $1B, $92, $D5, $8C, $DB, $44, $12, $8C, $29, $1B, $8C
	db $B4, $B3, $74, $58, $D5, $2E, $1B, $98, $46, $12, $92, $27, $1B, $92, $D5, $8C
	db $DB, $46, $12, $8C, $D5, $2C, $1B, $8C, $B4, $8C, $D5, $2C, $1B, $8C, $48, $12
	db $8C, $2A, $1B, $98, $DB, $8C, $DB, $29, $8C, $27, $8C, $B4, $D5, $25, $1B, $98
	db $44, $12, $92, $28, $1B, $92, $D5, $8C, $DB, $44, $12, $8C, $28, $1B, $8C, $B4
	db $B3, $74, $58, $B3, $88, $58, $B3, $74, $58, $B3, $88, $58, $B3, $74, $58, $B3
	db $9F, $58, $B3, $B4, $58, $B3, $C7, $58, $D5, $2A, $1B, $98, $46, $12, $92, $2C
	db $1B, $92, $D5, $8C, $DB, $48, $12, $8C, $2B, $1B, $8C, $D5, $2A, $1B, $98, $46
	db $12, $92, $2A, $1B, $92, $D5, $8C, $DB, $46, $12, $8C, $2A, $1B, $8C, $B4, $D5
	db $29, $1B, $98, $44, $12, $92, $2E, $1B, $92, $D5, $8C, $DB, $49, $12, $8C, $2E
	db $1B, $8C, $B4, $D5, $27, $98, $D5, $42, $12, $92, $2C, $1B, $92, $D5, $8C, $DB
	db $48, $12, $8C, $2C, $1B, $8C, $D5, $25, $98, $DB, $27, $98, $28, $92, $D5, $29
	db $92, $DB, $25, $8C, $B3, $06, $59, $B3, $1A, $59, $D5, $27, $1B, $98, $43, $12
	db $92, $27, $1B, $92, $D5, $8C, $DB, $46, $12, $8C, $27, $1B, $8C, $D5, $2C, $98
	db $D5, $48, $12, $92, $2C, $1B, $92, $D5, $8C, $DB, $48, $12, $8C, $27, $1B, $8C
	db $D5, $2C, $8C, $BE, $46, $D2, $44, $13, $8C, $38, $92, $44, $8C, $50, $8C, $44
	db $86, $5C, $86, $50, $86, $38, $86, $44, $86, $B2, $5F, $58

; ---- data $5997-$5998 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_5997:: ; 05:5997
	db $B1

; ---- data $5998-$5ADB (323 bytes) [CONFIRMED] read as data by executed code (in up to 12/18 scenarios); content class unknown

Data_05_5998:: ; 05:5998
	db $BF, $7F, $BD, $00, $BE, $64, $D3, $27, $0F, $86, $D2, $24, $0A, $86, $DB, $0C
	db $8C, $C1, $20, $D5, $25, $0D, $81, $C1, $40, $8B, $D2, $24, $0A, $86, $C1, $20
	db $D5, $25, $0D, $81, $C1, $40, $85, $D2, $24, $0A, $86, $D5, $2A, $86, $D3, $27
	db $0F, $8C, $C1, $20, $D5, $25, $0D, $81, $C1, $40, $85, $D2, $24, $0A, $86, $D2
	db $86, $D5, $86, $D3, $27, $0F, $86, $D2, $24, $0A, $86, $DB, $0C, $8C, $C1, $20
	db $D5, $25, $0D, $81, $C1, $40, $8B, $D2, $24, $0A, $86, $C1, $20, $D5, $25, $0D
	db $81, $C1, $40, $85, $D2, $24, $0A, $86, $D5, $2A, $86, $D3, $27, $0F, $8C, $C1
	db $20, $D5, $25, $0D, $81, $C1, $40, $85, $D2, $24, $0A, $86, $D2, $86, $D5, $86
	db $B4, $B3, $DB, $59, $B3, $DB, $59, $B3, $DB, $59, $B3, $DB, $59, $B3, $DB, $59
	db $D3, $27, $0F, $86, $D2, $24, $0A, $86, $DB, $0C, $8C, $C1, $20, $D5, $25, $0D
	db $81, $C1, $40, $8B, $D2, $24, $0A, $86, $C1, $20, $D5, $25, $0D, $81, $C1, $40
	db $85, $D3, $24, $0A, $86, $C1, $20, $D5, $25, $0D, $81, $C1, $40, $85, $D3, $27
	db $0F, $8C, $C1, $20, $D5, $25, $0D, $81, $C1, $40, $85, $D2, $24, $0A, $86, $D2
	db $86, $D5, $2A, $86, $B4, $B3, $DB, $59, $B3, $DB, $59, $B3, $DB, $59, $B3, $DB
	db $59, $B3, $DB, $59, $B3, $DB, $59, $B3, $DB, $59, $B3, $28, $5A, $B3, $DB, $59
	db $B3, $DB, $59, $B3, $DB, $59, $B3, $28, $5A, $B3, $DB, $59, $B3, $DB, $59, $B3
	db $DB, $59, $B3, $DB, $59, $D3, $27, $0F, $86, $D2, $24, $0A, $86, $DB, $0C, $8C
	db $C1, $20, $D5, $25, $0D, $81, $C1, $40, $8B, $D2, $24, $0A, $86, $C1, $20, $D5
	db $25, $0D, $81, $C1, $40, $85, $D3, $24, $0A, $86, $C1, $20, $D5, $25, $0D, $81
	db $C1, $40, $85, $D3, $27, $0F, $8C, $C1, $20, $D5, $25, $0D, $81, $C1, $40, $97
	db $B2, $9C, $59

; ---- data $5ADB-$5ADC (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_5ADB:: ; 05:5ADB
	db $B1

; ---- data $5ADC-$5ADE (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 5ADE (12 words = NN*(KK+1)); the byte before (5ADB) is $B1

Data_05_5ADC:: ; 05:5ADC
	db $04, $02

; ---- words $5ADE-$5AF6 (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 5ADC [v4: bytes 5ADE-5AE6 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_5ADE:: ; 05:5ADE
	dw Data_05_54E3, Data_05_5618, Data_05_585B, Data_05_5998, $54E7, $561C, $585F, $599C
	dw Data_05_5617, Data_05_585A, Data_05_5997, Data_05_5ADB
