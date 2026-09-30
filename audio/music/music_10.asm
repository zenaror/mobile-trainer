; audio/music/music_10.asm
; bank 05, $455A-$4700 (422 bytes); pinned by layout.link
; song id 10

SECTION "audio/music/music_10", ROMX

; ---- data $455A-$45A4 (74 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_455A:: ; 05:455A
	db $BF, $7F, $BD, $00, $BC, $48, $BE, $27, $C5, $0E, $C3, $20, $C4, $10, $98, $C1
	db $2C, $DF, $4C, $15, $81, $C1, $40, $8F, $D7, $45, $88, $4C, $A0, $98, $C1, $2C
	db $DF, $4E, $81, $C1, $40, $8F, $D7, $44, $88, $4E, $A0, $98, $4C, $98, $DF, $90
	db $D7, $4E, $88, $DF, $50, $90, $C1, $2C, $D7, $51, $81, $C1, $40, $87, $90, $D7
	db $50, $98, $4C, $98, $EA, $4E, $9B, $B2, $5E, $45

; ---- data $45A4-$45A5 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_45A4:: ; 05:45A4
	db $B1

; ---- data $45A5-$461A (117 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_45A5:: ; 05:45A5
	db $BF, $7F, $BD, $00, $BE, $06, $D5, $40, $0E, $98, $BE, $04, $D7, $3D, $15, $90
	db $BE, $06, $D5, $0E, $88, $D5, $49, $90, $39, $88, $BE, $04, $D7, $3D, $15, $98
	db $BE, $06, $D5, $42, $0E, $98, $BE, $04, $D7, $3F, $15, $90, $BE, $06, $D5, $0E
	db $88, $D5, $48, $90, $38, $88, $BE, $04, $D7, $3F, $15, $98, $BE, $06, $D5, $44
	db $0E, $98, $BE, $04, $D7, $15, $90, $BE, $06, $D5, $40, $0E, $88, $49, $90, $38
	db $88, $BE, $04, $D7, $40, $15, $98, $BE, $06, $D5, $42, $0E, $98, $BE, $04, $D7
	db $15, $90, $BE, $06, $D5, $3E, $0E, $88, $4A, $90, $39, $88, $BE, $04, $E7, $42
	db $15, $98, $B2, $A9, $45

; ---- data $461A-$461B (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_461A:: ; 05:461A
	db $B1

; ---- data $461B-$466C (81 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_461B:: ; 05:461B
	db $BF, $7F, $BD, $F4, $BE, $09, $D7, $39, $1F, $98, $51, $15, $90, $34, $1F, $88
	db $DF, $39, $90, $D7, $88, $D7, $51, $15, $98, $38, $1F, $98, $54, $15, $90, $33
	db $1F, $88, $DF, $38, $90, $D7, $88, $D7, $54, $15, $98, $31, $1F, $98, $55, $15
	db $90, $38, $1F, $88, $DF, $31, $90, $D7, $88, $D7, $55, $98, $2F, $98, $D7, $56
	db $15, $90, $2F, $1F, $88, $DF, $34, $90, $D7, $88, $E7, $56, $15, $98, $B2, $1F
	db $46

; ---- data $466C-$466D (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_466C:: ; 05:466C
	db $B1

; ---- data $466D-$46E5 (120 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_466D:: ; 05:466D
	db $BF, $7F, $BD, $00, $BE, $64, $D3, $27, $11, $98, $D5, $2F, $0F, $90, $D2, $24
	db $0B, $88, $D3, $27, $11, $90, $D3, $88, $D5, $2F, $0F, $90, $D3, $24, $0B, $88
	db $27, $11, $98, $D5, $2F, $0F, $90, $D3, $27, $11, $88, $D2, $24, $0B, $88, $D2
	db $88, $D3, $27, $11, $88, $D5, $2F, $0F, $90, $D7, $24, $0B, $88, $D3, $27, $11
	db $98, $D5, $2F, $0F, $90, $D2, $24, $0B, $88, $D3, $27, $11, $90, $D3, $88, $D5
	db $2F, $0F, $90, $D2, $24, $0B, $88, $D3, $27, $11, $98, $D5, $2F, $0F, $90, $D3
	db $27, $11, $88, $D2, $24, $0B, $88, $D2, $88, $D3, $27, $11, $88, $D5, $2F, $0F
	db $90, $D7, $24, $0D, $88, $B2, $71, $46

; ---- data $46E5-$46E6 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_46E5:: ; 05:46E5
	db $B1

; ---- data $46E6-$46E8 (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 46E8 (12 words = NN*(KK+1)); the byte before (46E5) is $B1

Data_05_46E6:: ; 05:46E6
	db $04, $02

; ---- words $46E8-$4700 (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 46E6 [v4: bytes 46E8-46F0 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_46E8:: ; 05:46E8
	dw Data_05_455A, Data_05_45A5, Data_05_461B, Data_05_466D, $455E, $45A9, $461F, $4671
	dw Data_05_45A4, Data_05_461A, Data_05_466C, Data_05_46E5
