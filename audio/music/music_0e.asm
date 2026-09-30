; audio/music/music_0e.asm
; bank 05, $4000-$4232 (562 bytes); pinned by layout.link
; song id 0E

SECTION "audio/music/music_0e", ROMX

; ---- data $4000-$4024 (36 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_4000:: ; 05:4000
	db $BF, $7F, $BD, $00, $BC, $3B, $BE, $29, $C5, $14, $C3, $28, $C4, $20, $EF, $48
	db $13, $A4, $DB, $46, $8C, $45, $8C, $F3, $43, $8C, $A4, $DB, $41, $8C, $40, $8C
	db $F3, $41, $8C, $A4

; ---- data $4024-$4047 (35 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4024:: ; 05:4024
	db $DB, $46, $8C, $45, $8C, $F7, $43, $8C, $B0, $EF, $48, $A4, $DB, $46, $8C, $45
	db $8C, $F3, $43, $8C, $A4, $DB, $41, $8C, $40, $8C, $FB, $41, $8C, $B0, $B0, $B2
	db $04, $40, $B1

; ---- data $4047-$4090 (73 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_4047:: ; 05:4047
	db $BF, $7F, $BD, $00, $BE, $06, $8C, $D3, $45, $0C, $8C, $BE, $04, $DB, $4D, $15
	db $8C, $BE, $06, $D3, $41, $0C, $8C, $4A, $8C, $46, $8C, $BE, $04, $DB, $4D, $15
	db $8C, $BE, $06, $D3, $48, $0C, $8C, $8C, $D3, $3C, $0C, $8C, $BE, $04, $DB, $4D
	db $15, $8C, $BE, $06, $D3, $48, $0C, $8C, $43, $8C, $48, $8C, $BE, $04, $DB, $4C
	db $15, $8C, $BE, $06, $D3, $46, $0C, $8C, $B4

; ---- data $4090-$40FF (111 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4090:: ; 05:4090
	db $D3, $45, $0C, $8C, $41, $8C, $BE, $04, $DB, $4D, $15, $8C, $BE, $06, $D3, $48
	db $0C, $8C, $4A, $8C, $46, $8C, $BE, $04, $DB, $4D, $15, $8C, $BE, $06, $D3, $43
	db $0C, $8C, $B4, $8C, $D3, $3C, $0C, $8C, $BE, $04, $DB, $4D, $15, $8C, $BE, $06
	db $D3, $48, $0C, $8C, $46, $98, $BE, $04, $DB, $4C, $15, $8C, $BE, $06, $D3, $43
	db $0C, $8C, $B4, $8C, $45, $8C, $BE, $04, $DB, $4D, $15, $8C, $BE, $06, $D3, $41
	db $0C, $8C, $4A, $8C, $46, $8C, $BE, $04, $DB, $4D, $15, $8C, $BE, $06, $D3, $48
	db $0C, $8C, $B3, $6E, $40, $B3, $90, $40, $B3, $B3, $40, $B2, $4B, $40, $B1

; ---- data $40FF-$4139 (58 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_40FF:: ; 05:40FF
	db $BF, $7F, $BD, $00, $BE, $08, $E7, $2D, $1F, $98, $BE, $09, $DB, $45, $15, $8C
	db $BE, $08, $DB, $2E, $1F, $8C, $E7, $98, $BE, $09, $DB, $46, $15, $98, $B4, $BE
	db $08, $E7, $30, $1F, $98, $BE, $09, $DB, $46, $15, $8C, $BE, $08, $DB, $24, $1F
	db $8C, $E7, $98, $BE, $09, $DB, $43, $15, $98, $B4

; ---- data $4139-$4167 (46 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4139:: ; 05:4139
	db $BE, $08, $E7, $26, $1F, $98, $BE, $09, $DB, $45, $15, $8C, $BE, $08, $DB, $2B
	db $1F, $8C, $E7, $98, $BE, $09, $DB, $46, $15, $98, $B4, $B3, $1E, $41, $B3, $03
	db $41, $B3, $1E, $41, $B3, $39, $41, $B3, $1E, $41, $B2, $03, $41, $B1

; ---- data $4167-$41D0 (105 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_4167:: ; 05:4167
	db $BF, $7F, $BD, $00, $BE, $64, $D5, $27, $11, $8C, $D2, $24, $0B, $8C, $C1, $20
	db $D5, $2F, $0F, $81, $C1, $40, $8B, $D5, $27, $11, $86, $D2, $24, $0B, $86, $D5
	db $27, $11, $8C, $2A, $0B, $86, $D2, $24, $86, $C1, $20, $D5, $2F, $0F, $81, $C1
	db $40, $8B, $D2, $24, $0B, $86, $D2, $86, $D5, $27, $11, $8C, $D2, $24, $0B, $8C
	db $C1, $20, $D5, $2F, $0F, $81, $C1, $40, $8B, $D5, $27, $11, $86, $D2, $24, $0B
	db $86, $D5, $27, $11, $8C, $2A, $0B, $86, $D2, $24, $86, $C1, $20, $D5, $2F, $0F
	db $81, $C1, $40, $8B, $D2, $24, $0B, $86, $D2

; ---- data $41D0-$4218 (72 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_41D0:: ; 05:41D0
	db $86, $B4, $B3, $9F, $41, $D5, $27, $11, $8C, $D2, $24, $0B, $8C, $C1, $20, $D5
	db $2F, $0F, $81, $C1, $40, $8B, $D5, $27, $11, $86, $D2, $24, $0B, $86, $D5, $27
	db $11, $8C, $2A, $0B, $86, $D2, $24, $86, $C1, $20, $D5, $2F, $0F, $81, $C1, $40
	db $8B, $D2, $24, $0B, $86, $D5, $86, $B4, $B3, $9F, $41, $B3, $9F, $41, $B3, $9F
	db $41, $B3, $D5, $41, $B2, $6B, $41, $B1

; ---- data $4218-$421A (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 421A (12 words = NN*(KK+1)); the byte before (4217) is $B1

Data_05_4218:: ; 05:4218
	db $04, $02

; ---- words $421A-$4232 (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 4218 [v4: bytes 421A-4222 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_421A:: ; 05:421A
	dw Data_05_4000, Data_05_4047, Data_05_40FF, Data_05_4167, $4004, $404B, $4103, $416B
	dw $4046, $40FE, $4166, $4217
