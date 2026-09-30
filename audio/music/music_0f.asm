; audio/music/music_0f.asm
; bank 05, $4232-$455A (808 bytes); pinned by layout.link
; song id 0F

SECTION "audio/music/music_0f", ROMX

; ---- data $4232-$42E7 (181 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_4232:: ; 05:4232
	db $BF, $7F, $BD, $00, $BC, $46, $BE, $02, $98, $D3, $4A, $13, $86, $09, $86, $D3
	db $4B, $13, $86, $09, $86, $D3, $4D, $13, $86, $09, $9A, $D3, $4F, $13, $86, $09
	db $86, $D3, $4D, $13, $86, $09, $8C, $D3, $46, $13, $86, $09, $8C, $13, $86, $09
	db $9E, $13, $86, $09, $86, $D3, $4B, $13, $86, $09, $9A, $D3, $4A, $13, $86, $09
	db $92, $D3, $46, $13, $86, $09, $86, $D3, $43, $13, $86, $09, $86, $D3, $41, $13
	db $86, $09, $86, $A4, $D3, $42, $13, $86, $09, $86, $D3, $44, $13, $86, $09, $86
	db $D3, $46, $13, $86, $09, $86, $A4, $D3, $48, $13, $86, $09, $86, $D3, $49, $13
	db $86, $09, $86, $D3, $48, $13, $86, $09, $86, $8C, $D3, $44, $13, $86, $09, $92
	db $D3, $50, $13, $86, $09, $92, $D3, $4E, $13, $86, $09, $86, $D3, $4D, $13, $86
	db $09, $86, $D3, $4E, $13, $86, $09, $86, $98, $D3, $46, $13, $86, $09, $86, $D3
	db $49, $13, $86, $09, $92, $D3, $4B, $13, $86, $09, $92, $D3, $4D, $13, $86, $09
	db $86, $B0, $B2, $36, $42

; ---- data $42E7-$42E8 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_42E7:: ; 05:42E7
	db $B1

; ---- data $42E8-$43AE (198 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_42E8:: ; 05:42E8
	db $BF, $7F, $BD, $00, $BE, $04, $98, $D7, $4A, $15, $8C, $BE, $34, $D3, $05, $8C
	db $D3, $4B, $8C, $4D, $8C, $BE, $04, $D7, $46, $15, $8C, $BE, $34, $8C, $D3, $4F
	db $05, $8C, $4D, $8C, $BE, $04, $D7, $43, $15, $8C, $BE, $34, $8C, $D3, $46, $05
	db $98, $BE, $04, $D7, $15, $8C, $BE, $34, $8C, $D3, $05, $8C, $D3, $4B, $8C, $BE
	db $04, $D7, $46, $15, $8C, $BE, $34, $8C, $D3, $4A, $05, $98, $BE, $04, $D7, $43
	db $15, $8C, $BE, $34, $8C, $D3, $41, $05, $98, $BE, $04, $D7, $15, $8C, $BE, $34
	db $9C, $04, $D7, $46, $8C, $BE, $34, $D3, $44, $05, $8C, $46, $98, $BE, $04, $D7
	db $15, $8C, $BE, $34, $9C, $04, $D7, $44, $8C, $BE, $34, $D3, $49, $05, $8C, $48
	db $98, $BE, $04, $D7, $15, $8C, $BE, $34, $8C, $D3, $50, $05, $98, $BE, $04, $D7
	db $44, $15, $8C, $BE, $34, $D3, $4D, $05, $8C, $4E, $98, $BE, $04, $D7, $42, $15
	db $8C, $BE, $34, $D3, $46, $05, $8C, $49, $98, $BE, $04, $D7, $46, $15, $8C, $BE
	db $34, $8C, $D3, $4D, $05, $98, $BE, $04, $D7, $46, $15, $8C, $BE, $34, $9C, $04
	db $D7, $48, $98, $B2, $EC, $42

; ---- data $43AE-$43AF (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_43AE:: ; 05:43AE
	db $B1

; ---- data $43AF-$44BF (272 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_43AF:: ; 05:43AF
	db $BF, $7F, $BD, $F4, $BE, $08, $D7, $2E, $1F, $98, $BE, $09, $D7, $5E, $15, $8C
	db $BE, $08, $D7, $35, $1F, $8C, $2E, $8C, $D7, $8C, $BE, $09, $D7, $59, $15, $8C
	db $BE, $08, $D7, $39, $1F, $8C, $BE, $08, $D7, $37, $98, $BE, $09, $D7, $56, $15
	db $8C, $BE, $08, $D7, $32, $1F, $8C, $37, $8C, $D7, $8C, $BE, $09, $D7, $5B, $15
	db $8C, $BE, $08, $D7, $35, $1F, $8C, $BE, $08, $D7, $33, $98, $BE, $09, $D7, $5B
	db $15, $8C, $BE, $08, $D7, $33, $1F, $8C, $35, $8C, $D7, $8C, $BE, $09, $D7, $57
	db $15, $8C, $BE, $08, $D7, $35, $1F, $8C, $BE, $08, $D7, $2E, $98, $BE, $09, $D7
	db $56, $15, $8C, $BE, $08, $D7, $35, $1F, $8C, $2E, $8C, $D7, $8C, $BE, $09, $D7
	db $59, $15, $8C, $BE, $08, $D7, $38, $1F, $8C, $BE, $08, $D7, $36, $98, $BE, $09
	db $D7, $5A, $15, $8C, $BE, $08, $D7, $31, $1F, $8C, $38, $8C, $D7, $8C, $BE, $09
	db $D7, $57, $15, $8C, $BE, $08, $D7, $36, $1F, $8C, $BE, $08, $D7, $35, $98, $BE
	db $09, $D7, $5C, $15, $8C, $BE, $08, $D7, $35, $1F, $8C, $3A, $8C, $D7, $8C, $BE
	db $09, $D7, $56, $15, $8C, $BE, $08, $D7, $2E, $1F, $8C, $BE, $08, $D7, $33, $98
	db $BE, $09, $D7, $57, $15, $8C, $BE, $08, $D7, $2E, $1F, $8C, $33, $8C, $D7, $8C
	db $BE, $09, $D7, $5A, $15, $8C, $BE, $08, $D7, $33, $1F, $8C, $BE, $08, $D7, $35
	db $98, $BE, $09, $D7, $5B, $15, $8C, $BE, $08, $D7, $30, $1F, $8C, $35, $8C, $D7
	db $8C, $BE, $09, $D7, $5D, $15, $8C, $BE, $08, $D7, $35, $1F, $8C, $B2, $B3, $43

; ---- data $44BF-$44C0 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_44BF:: ; 05:44BF
	db $B1

; ---- data $44C0-$4535 (117 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_44C0:: ; 05:44C0
	db $BF, $7F, $BD, $00, $BE, $64, $D3, $27, $11, $8C, $D2, $24, $0B, $8C, $D5, $25
	db $10, $86, $D2, $24, $0B, $86, $D5, $2A, $0C, $86, $D3, $27, $11, $86, $D3, $86
	db $D2, $24, $0B, $86, $D3, $27, $11, $8C, $D5, $25, $10, $8C, $D2, $24, $0B, $86
	db $D5, $86, $B4, $D3, $27, $11, $8C, $D2, $24, $0B, $8C, $D5, $25, $10, $86, $D2
	db $24, $0B, $86, $D5, $2A, $0C, $86, $D3, $27, $11, $86, $D3, $86, $D2, $24, $0B
	db $86, $D3, $27, $11, $8C, $D5, $25, $10, $8C, $D2, $24, $0B, $86, $D5, $86, $B4
	db $B3, $F3, $44, $B3, $F3, $44, $B3, $F3, $44, $B3, $F3, $44, $B3, $F3, $44, $B3
	db $C4, $44, $B2, $C4, $44

; ---- data $4535-$4540 (11 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4535:: ; 05:4535
	db $BE, $64, $D3, $27, $11, $8C, $D2, $24, $0B, $83, $B1

; ---- data $4540-$4542 (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 4542 (12 words = NN*(KK+1)); the byte before (453F) is $B1

Data_05_4540:: ; 05:4540
	db $04, $02

; ---- words $4542-$455A (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 4540 [v4: bytes 4542-454A were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_4542:: ; 05:4542
	dw Data_05_4232, Data_05_42E8, Data_05_43AF, Data_05_44C0, $4236, $42EC, $43B3, $44C4
	dw Data_05_42E7, Data_05_43AE, Data_05_44BF, Data_05_4535
