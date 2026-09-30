; audio/music/music_13.asm
; bank 05, $4CA1-$4D80 (223 bytes); pinned by layout.link
; song id 13

SECTION "audio/music/music_13", ROMX

; ---- data $4CA1-$4D76 (213 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

Data_05_4CA1:: ; 05:4CA1
	db $BF, $7F, $BD, $00, $BC, $37, $BE, $01, $D3, $48, $16, $86, $BE, $20, $D3, $57
	db $0D, $86, $BE, $01, $D7, $48, $16, $8C, $D3, $4A, $86, $D3, $86, $BE, $20, $D3
	db $59, $0D, $86, $BE, $01, $D5, $4B, $16, $86, $07, $86, $BE, $20, $D5, $5B, $0D
	db $86, $57, $86, $D7, $4F, $88, $B1, $BF, $7F, $BD, $00, $BE, $05, $D3, $3F, $11
	db $86, $BE, $04, $D3, $50, $0D, $86, $BE, $05, $D7, $3F, $11, $8C, $D3, $41, $86
	db $D3, $86, $BE, $04, $D3, $52, $0D, $86, $BE, $05, $D5, $43, $11, $86, $05, $86
	db $BE, $04, $D5, $52, $0D, $86, $4F, $86, $D7, $3F, $88, $B1, $BF, $7F, $BD, $00
	db $BE, $08, $D5, $38, $1F, $86, $2C, $86, $DB, $38, $8C, $D5, $3A, $86, $2E, $8C
	db $33, $8C, $2E, $86, $2B, $86, $D7, $27, $88, $B1, $BF, $7F, $BD, $00, $BE, $64
	db $D4, $27, $11, $86, $D2, $24, $0B, $86, $C1, $28, $D4, $25, $0F, $81, $C1, $40
	db $85, $D4, $27, $11, $86, $D2, $24, $0B, $86, $C1, $28, $D4, $25, $0F, $81, $C1
	db $40, $85, $D2, $24, $0B, $86, $D4, $27, $11, $86, $C1, $28, $D4, $25, $0F, $81
	db $C1, $40, $85, $D2, $24, $0B, $86, $D4, $27, $11, $86, $C1, $28, $D5, $25, $0F
	db $81, $C1, $40, $85, $B1

; ---- data $4D76-$4D78 (2 bytes) [PROBABLE] header NN=04 KK=00 of the channel-pointer table at 4D78 (4 words = NN*(KK+1)); the byte before (4D75) is $B1 [v4: bytes 4D76-4D77 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_4D76:: ; 05:4D76
	db $04, $00

; ---- words $4D78-$4D80 (8 bytes) [PROBABLE] 4 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 4D76 [v4: bytes 4D78-4D80 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_4D78:: ; 05:4D78
	dw Data_05_4CA1, $4CD8, $4D0D, $4D2B
