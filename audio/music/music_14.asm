; audio/music/music_14.asm
; bank 05, $4D80-$50BC (828 bytes); pinned by layout.link
; song id 14

SECTION "audio/music/music_14", ROMX

; ---- data $4D80-$4E22 (162 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

Data_05_4D80:: ; 05:4D80
	db $BF, $7F, $BD, $00, $BC, $30, $BE, $00, $8C, $D2, $45, $11, $88, $05, $8C, $11
	db $84, $05, $8C, $D2, $41, $11, $88, $05, $8C, $D2, $43, $11, $84, $05, $8C, $11
	db $88, $05, $84, $8C, $D2, $45, $11, $88, $05, $8C, $11, $84, $05, $8C, $D2, $46
	db $11, $88, $05, $8C, $D2, $48, $11, $84, $05, $8C, $D2, $43, $11, $88, $05, $84
	db $B4, $8C, $D2, $45, $11, $88, $05, $8C, $11, $84, $05, $8C, $D2, $41, $11, $88
	db $05, $8C, $D2, $43, $11, $84, $05, $8C, $11, $88, $05, $84, $B4, $8C, $D2, $41
	db $11, $88, $05, $8C, $11, $84, $05, $8C, $D2, $46, $11, $88, $05, $8C, $D2, $45
	db $11, $84, $05, $8C, $D2, $41, $11, $88, $05, $84, $B4, $B3, $C1, $4D, $B3, $A3
	db $4D, $B3, $C1, $4D, $B3, $DD, $4D, $B3, $C1, $4D, $B3, $A3, $4D, $B3, $C1, $4D
	db $B3, $DD, $4D, $B3, $C1, $4D, $B3, $A3, $4D, $B3, $C1, $4D, $B3, $DD, $4D, $B3
	db $C1, $4D

; ---- data $4E22-$4E5B (57 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4E22:: ; 05:4E22
	db $B3, $A3, $4D, $B3, $C1, $4D, $B3, $DD, $4D, $B3, $C1, $4D, $B3, $A3, $4D, $B3
	db $C1, $4D, $D2, $41, $11, $88, $05, $AD, $BE, $00, $8C, $D2, $45, $11, $88, $05
	db $8C, $11, $84, $05, $8C, $D2, $41, $11, $88, $05, $8C, $D2, $43, $11, $84, $05
	db $8C, $11, $88, $05, $84, $B2, $A3, $4D, $B1

; ---- data $4E5B-$4F6A (271 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_4E5B:: ; 05:4E5B
	db $BF, $7F, $BD, $00, $BE, $04, $D5, $29, $19, $8C, $BE, $05, $D2, $3C, $11, $88
	db $04, $84, $BE, $04, $D5, $29, $19, $86, $BE, $05, $82, $D2, $3C, $11, $84, $04
	db $86, $BE, $04, $82, $D5, $2E, $19, $84, $BE, $05, $D2, $39, $11, $88, $04, $84
	db $BE, $04, $D5, $30, $19, $86, $BE, $05, $82, $D2, $3A, $11, $84, $04, $86, $BE
	db $04, $82, $D5, $30, $19, $84, $BE, $05, $D2, $3A, $11, $88, $04, $84, $B4, $BE
	db $04, $D5, $29, $19, $8C, $BE, $05, $D2, $3C, $11, $88, $04, $84, $BE, $04, $D5
	db $29, $19, $86, $BE, $05, $82, $D2, $3C, $11, $84, $04, $86, $BE, $04, $82, $D5
	db $2E, $19, $84, $BE, $05, $D2, $3D, $11, $88, $04, $84, $BE, $04, $D5, $30, $19
	db $86, $BE, $05, $82, $D2, $3F, $11, $84, $04, $86, $BE, $04, $82, $D5, $24, $19
	db $84, $BE, $05, $D2, $3A, $11, $88, $04, $84, $B4, $B3, $5F, $4E, $BE, $04, $D5
	db $2E, $19, $8C, $BE, $05, $D2, $3A, $11, $88, $04, $84, $BE, $04, $D5, $2E, $19
	db $86, $BE, $05, $82, $D2, $3A, $11, $84, $04, $86, $BE, $04, $82, $D5, $30, $19
	db $84, $BE, $05, $D2, $3D, $11, $88, $04, $84, $BE, $04, $D5, $24, $19, $86, $BE
	db $05, $82, $D2, $3C, $11, $84, $04, $86, $BE, $04, $82, $D5, $30, $19, $84, $BE
	db $05, $D2, $3A, $11, $88, $04, $84, $B4, $B3, $5F, $4E, $B3, $AA, $4E, $B3, $5F
	db $4E, $B3, $F8, $4E, $B3, $5F, $4E, $B3, $AA, $4E, $B3, $5F, $4E, $B3, $F8, $4E
	db $B3, $5F, $4E, $B3, $AA, $4E, $B3, $5F, $4E, $B3, $F8, $4E, $B3, $5F, $4E

; ---- data $4F6A-$4F87 (29 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4F6A:: ; 05:4F6A
	db $B3, $AA, $4E, $B3, $5F, $4E, $B3, $F8, $4E, $B3, $5F, $4E, $B3, $AA, $4E, $B3
	db $5F, $4E, $D2, $3A, $11, $B0, $B3, $5F, $4E, $B2, $AA, $4E, $B1

; ---- data $4F87-$4FD5 (78 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_4F87:: ; 05:4F87
	db $BF, $7F, $BD, $00, $BE, $09, $D1, $54, $15, $98, $48, $0E, $98, $54, $15, $98
	db $48, $0E, $98, $D1, $54, $15, $98, $48, $0E, $98, $54, $15, $98, $48, $0E, $98
	db $B4, $B3, $9A, $4F, $B3, $9A, $4F, $B3, $9A, $4F, $B3, $9A, $4F, $B3, $9A, $4F
	db $B3, $9A, $4F, $B3, $9A, $4F, $B3, $9A, $4F, $B3, $9A, $4F, $B3, $9A, $4F, $B3
	db $9A, $4F, $B3, $9A, $4F, $B3, $9A, $4F, $B3, $9A, $4F, $B3, $9A, $4F

; ---- data $4FD5-$5004 (47 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4FD5:: ; 05:4FD5
	db $B3, $9A, $4F, $B3, $9A, $4F, $B3, $9A, $4F, $B3, $9A, $4F, $B3, $9A, $4F, $D1
	db $54, $15, $98, $48, $0E, $98, $BE, $08, $D4, $1F, $A0, $D4, $A0, $D4, $A0, $EE
	db $54, $A0, $BE, $09, $D1, $15, $98, $D1, $48, $0E, $98, $B2, $9A, $4F, $B1

; ---- data $5004-$5085 (129 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_5004:: ; 05:5004
	db $BF, $7F, $BD, $00, $BE, $64, $D3, $27, $10, $8C, $D2, $24, $0B, $8C, $D3, $2F
	db $0E, $8C, $2A, $88, $2F, $84, $D3, $27, $10, $8C, $D2, $24, $0B, $8C, $D3, $2F
	db $0E, $88, $D2, $24, $0B, $84, $D2, $88, $D2, $2A, $0E, $84, $B4, $D3, $27, $10
	db $8C, $D2, $24, $0B, $8C, $D3, $2F, $0E, $8C, $2A, $88, $2F, $84, $D3, $27, $10
	db $8C, $D2, $24, $0B, $8C, $D3, $2F, $0E, $88, $D2, $24, $0B, $84, $D2, $88, $D2
	db $2A, $0E, $84, $B4, $B3, $31, $50, $B3, $31, $50, $B3, $31, $50, $B3, $31, $50
	db $B3, $31, $50, $B3, $31, $50, $B3, $31, $50, $B3, $31, $50, $B3, $31, $50, $B3
	db $31, $50, $B3, $31, $50, $B3, $31, $50, $B3, $31, $50, $B3, $31, $50, $B3, $31
	db $50

; ---- data $5085-$50A2 (29 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_5085:: ; 05:5085
	db $B3, $31, $50, $B3, $31, $50, $B3, $31, $50, $B3, $31, $50, $B3, $31, $50, $B3
	db $31, $50, $D3, $27, $10, $B0, $B3, $08, $50, $B2, $31, $50, $B1

; ---- data $50A2-$50A4 (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 50A4 (12 words = NN*(KK+1)); the byte before (50A1) is $B1

Data_05_50A2:: ; 05:50A2
	db $04, $02

; ---- words $50A4-$50BC (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 50A2 [v4: bytes 50A4-50AC were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_50A4:: ; 05:50A4
	dw Data_05_4D80, Data_05_4E5B, Data_05_4F87, Data_05_5004, $4DA3, $4EAA, $4F9A, $5031
	dw $4E5A, $4F86, $5003, $50A1
