; audio/music/music_0d.asm
; bank 04, $7DBC-$7E8C (208 bytes); pinned by layout.link
; song id 0D

SECTION "audio/music/music_0d", ROMX

; ---- data $7DBC-$7E8C (208 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; command semantics not decoded (part of region $574D-$7E8C)
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $02, $D5, $37, $16, $86, $3A, $86, $43, $86
	db $41, $8C, $44, $8C, $49, $86, $4B, $8C, $D1, $4A, $0C, $82, $48, $82, $46, $82
	db $44, $82, $43, $82, $41, $82, $D5, $3F, $16, $86, $B1, $BF, $7F, $BD, $00, $BE
	db $06, $D5, $2E, $15, $86, $33, $86, $3A, $86, $38, $8C, $3D, $8C, $41, $86, $43
	db $8C, $D1, $41, $09, $82, $3F, $82, $3E, $82, $3C, $82, $3A, $82, $38, $82, $D5
	db $37, $15, $86, $B1, $BF, $7F, $BD, $00, $BE, $08, $C2, $0A, $D5, $27, $1F, $8C
	db $2B, $86, $29, $8C, $2C, $92, $2B, $86, $BE, $47, $C1, $40, $D5, $58, $16, $81
	db $C1, $30, $82, $20, $81, $11, $82, $40, $D5, $52, $81, $C1, $30, $82, $20, $81
	db $11, $82, $40, $D5, $4E, $81, $C1, $30, $82, $20, $81, $11, $82, $BE, $08, $C1
	db $40, $D5, $27, $1F, $86, $B1, $BF, $7F, $BD, $00, $BE, $64, $C1, $20, $D2, $27
	db $12, $86, $24, $0B, $86, $25, $10, $86, $27, $12, $86, $24, $0B, $86, $25, $10
	db $86, $24, $0B, $86, $27, $12, $86, $24, $0B, $86, $D5, $2E, $86, $2D, $86, $2C
	db $86, $D2, $27, $12, $83, $B1, $04, $00, $BC, $7D, $E7, $7D, $10, $7E, $52, $7E
