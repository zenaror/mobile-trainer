; audio/music/music_19.asm
; bank 05, $5B06-$5DCF (713 bytes); pinned by layout.link
; song id 19

SECTION "audio/music/music_19", ROMX

; ---- data $5B06-$5B34 (46 bytes) [CONFIRMED] read as data by executed code (in up to 18/18 scenarios); content class unknown

Data_05_5B06:: ; 05:5B06
	db $BF, $7F, $BD, $00, $BC, $2A, $BE, $00, $88, $D3, $48, $12, $8C, $47, $84, $D7
	db $49, $88, $D3, $48, $84, $D7, $46, $88, $D3, $45, $84, $48, $8C, $D7, $88, $DB
	db $46, $99, $88, $D3, $44, $8C, $D7, $84, $D3, $43, $8C, $D3, $8C, $D3

; ---- data $5B34-$5B6D (57 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_5B34:: ; 05:5B34
	db $41, $8C, $D7, $3E, $88, $DB, $3F, $99, $88, $D3, $48, $8C, $47, $84, $D7, $49
	db $88, $D3, $48, $84, $D7, $46, $88, $D3, $45, $84, $48, $8C, $D7, $46, $88, $DB
	db $4D, $90, $D7, $41, $88, $D3, $42, $84, $43, $94, $3F, $84, $D7, $43, $88, $D3
	db $48, $8C, $DB, $44, $A1, $B2, $0A, $5B, $B1

; ---- data $5B6D-$5BCB (94 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_5B6D:: ; 05:5B6D
	db $BF, $7F, $BD, $00, $BE, $05, $88, $D3, $3F, $0C, $84, $BE, $04, $D4, $4B, $13
	db $86, $BE, $05, $82, $D3, $3E, $0C, $84, $D7, $41, $88, $D3, $3F, $84, $BE, $04
	db $D4, $44, $13, $86, $BE, $05, $82, $D3, $3C, $0C, $84, $3F, $8C, $BE, $04, $D4
	db $4A, $13, $86, $BE, $05, $82, $DB, $3E, $0C, $90, $BE, $04, $D4, $41, $13, $86
	db $BE, $05, $86, $88, $D3, $3D, $0C, $84, $BE, $04, $D4, $49, $13, $86, $BE, $05
	db $82, $D3, $3D, $0C, $84, $D3, $8C, $BE, $04, $D4, $49, $13, $86, $BE

; ---- data $5BCB-$5C4C (129 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_5BCB:: ; 05:5BCB
	db $05, $86, $D3, $3C, $0C, $8C, $BE, $04, $D4, $48, $13, $86, $BE, $05, $82, $DB
	db $3C, $0C, $90, $BE, $04, $D4, $3F, $13, $86, $BE, $05, $86, $88, $D3, $0C, $84
	db $BE, $04, $D4, $4B, $13, $86, $BE, $05, $82, $D3, $3E, $0C, $84, $D7, $41, $88
	db $D3, $3F, $84, $BE, $04, $D4, $44, $13, $86, $BE, $05, $82, $D3, $3C, $0C, $84
	db $3F, $8C, $BE, $04, $D4, $4A, $13, $86, $BE, $05, $82, $DB, $46, $0C, $90, $BE
	db $04, $D4, $41, $13, $86, $BE, $05, $82, $D3, $3E, $0C, $84, $3F, $8C, $BE, $04
	db $D4, $49, $13, $86, $BE, $05, $82, $D3, $37, $0C, $84, $D7, $3F, $88, $D3, $84
	db $BE, $04, $D4, $49, $13, $86, $BE, $05, $82, $DB, $3C, $0C, $A1, $B2, $71, $5B
	db $B1

; ---- data $5C4C-$5C9E (82 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_5C4C:: ; 05:5C4C
	db $BF, $7F, $BD, $F4, $BE, $08, $D5, $38, $1F, $8C, $BE, $09, $D4, $50, $13, $86
	db $BE, $08, $86, $D5, $33, $1F, $8C, $BE, $09, $D4, $48, $13, $86, $BE, $08, $86
	db $D5, $3A, $1F, $8C, $BE, $09, $D4, $4D, $13, $86, $BE, $08, $86, $D5, $35, $1F
	db $8C, $BE, $09, $D4, $44, $13, $86, $BE, $08, $86, $D5, $3F, $1F, $8C, $BE, $09
	db $D4, $4B, $13, $86, $BE, $08, $86, $D5, $33, $1F, $8C, $BE, $09, $D4, $4B, $13
	db $86, $BE

; ---- data $5C9E-$5D14 (118 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_5C9E:: ; 05:5C9E
	db $08, $86, $D5, $38, $1F, $8C, $BE, $09, $D4, $4B, $13, $86, $BE, $08, $86, $D5
	db $33, $1F, $8C, $BE, $09, $D4, $44, $13, $86, $BE, $08, $86, $D5, $38, $1F, $8C
	db $BE, $09, $D3, $50, $13, $86, $BE, $08, $86, $D5, $33, $1F, $8C, $BE, $09, $D3
	db $48, $13, $86, $BE, $08, $86, $D5, $3A, $1F, $8C, $BE, $09, $D3, $4D, $13, $86
	db $BE, $08, $86, $D5, $35, $1F, $8C, $BE, $09, $D3, $44, $13, $86, $BE, $08, $86
	db $D5, $3F, $1F, $8C, $BE, $09, $D4, $4F, $13, $86, $BE, $08, $86, $D5, $33, $1F
	db $8C, $BE, $09, $D4, $4F, $13, $8C, $BE, $08, $D4, $44, $8C, $D5, $33, $1F, $8C
	db $2C, $98, $B2, $50, $5C, $B1

; ---- data $5D14-$5D69 (85 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_5D14:: ; 05:5D14
	db $BF, $7F, $BD, $00, $BE, $64, $D3, $27, $0F, $8C, $C1, $28, $D3, $25, $0D, $81
	db $C1, $40, $8B, $D2, $24, $0B, $8C, $C1, $28, $D3, $25, $0D, $81, $C1, $40, $8B
	db $D3, $27, $0F, $8C, $C1, $28, $D3, $25, $0D, $81, $C1, $40, $8B, $D2, $24, $0B
	db $8C, $C1, $28, $D3, $25, $0D, $81, $C1, $40, $8B, $D3, $27, $0F, $8C, $C1, $28
	db $D3, $25, $0D, $81, $C1, $40, $8B, $D2, $24, $0B, $8C, $C1, $28, $D3, $25, $0D
	db $81, $C1, $40, $8B, $D3

; ---- data $5D69-$5DB5 (76 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_5D69:: ; 05:5D69
	db $27, $0F, $8C, $C1, $28, $D3, $25, $0D, $81, $C1, $40, $8B, $D2, $24, $0B, $8C
	db $C1, $28, $D3, $25, $0D, $81, $C1, $40, $8B, $B4, $B3, $4E, $5D, $D3, $27, $0F
	db $8C, $C1, $28, $D3, $25, $0D, $81, $C1, $40, $8B, $D2, $24, $0B, $8C, $C1, $28
	db $D3, $25, $0D, $81, $C1, $40, $8B, $D2, $24, $0B, $8C, $C1, $28, $D3, $25, $0D
	db $81, $C1, $40, $8B, $D3, $27, $0F, $98, $B2, $18, $5D, $B1

; ---- data $5DB5-$5DB7 (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 5DB7 (12 words = NN*(KK+1)); the byte before (5DB4) is $B1

Data_05_5DB5:: ; 05:5DB5
	db $04, $02

; ---- words $5DB7-$5DCF (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 5DB5 [v4: bytes 5DB7-5DBF were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_5DB7:: ; 05:5DB7
	dw Data_05_5B06, Data_05_5B6D, Data_05_5C4C, Data_05_5D14, $5B0A, $5B71, $5C50, $5D18
	dw $5B6C, $5C4B, $5D13, $5DB4
