; audio/music/music_15.asm
; bank 05, $50BC-$5174 (184 bytes); pinned by layout.link
; song id 15

SECTION "audio/music/music_15", ROMX

; ---- data $50BC-$516A (174 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown

Data_05_50BC:: ; 05:50BC
	db $BF, $7F, $BD, $00, $BC, $46, $BE, $00, $D5, $44, $16, $86, $D3, $50, $8C, $D5
	db $42, $86, $D3, $4E, $8C, $D2, $40, $83, $D2, $4C, $11, $83, $40, $83, $D2, $4C
	db $0F, $83, $40, $83, $4C, $83, $D2, $40, $0D, $83, $4C, $83, $40, $83, $D2, $4C
	db $0B, $83, $40, $83, $4C, $83, $B1, $BF, $7F, $BD, $00, $BE, $05, $D5, $4A, $12
	db $86, $D3, $56, $8C, $D5, $48, $86, $D3, $54, $8C, $D2, $46, $83, $D2, $52, $0E
	db $83, $46, $83, $D2, $52, $0C, $83, $46, $83, $52, $83, $D2, $46, $0A, $83, $52
	db $83, $46, $83, $D2, $52, $08, $83, $46, $83, $52, $83, $B1, $BF, $7F, $BD, $00
	db $BE, $08, $D5, $34, $1F, $86, $D3, $28, $8C, $D5, $32, $86, $D3, $26, $8C, $D5
	db $30, $86, $E9, $24, $9A, $B1, $BF, $7F, $BD, $00, $BE, $64, $D3, $2C, $0F, $86
	db $2D, $86, $D3, $24, $09, $86, $2C, $0F, $86, $2D, $86, $D3, $24, $09, $86, $2C
	db $0F, $86, $D3, $86, $D3, $0D, $86, $0B, $86, $09, $86, $07, $84, $B1

; ---- data $516A-$516C (2 bytes) [PROBABLE] header NN=04 KK=00 of the channel-pointer table at 516C (4 words = NN*(KK+1)); the byte before (5169) is $B1 [v4: bytes 516A-516B were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_516A:: ; 05:516A
	db $04, $00

; ---- words $516C-$5174 (8 bytes) [PROBABLE] 4 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 516A [v4: bytes 516C-5174 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_516C:: ; 05:516C
	dw Data_05_50BC, $50F3, $5128, $5142
