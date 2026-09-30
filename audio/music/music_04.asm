; audio/music/music_04.asm
; bank 04, $5F0E-$6102 (500 bytes); pinned by layout.link
; song id 04

SECTION "audio/music/music_04", ROMX

; ---- data $5F0E-$6102 (500 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; command semantics not decoded (part of region $574D-$7E8C)
	db $BF, $7F, $BD, $00, $BC, $2D, $BE, $2F, $8C, $D7, $3E, $16, $88, $D3, $3D, $84
	db $D7, $3E, $88, $D3, $3F, $8C, $DB, $41, $90, $3A, $8C, $3C, $8C, $3A, $8C, $3D
	db $8C, $D3, $3C, $8C, $D7, $3A, $88, $D3, $3C, $8C, $EE, $3A, $A1, $B0, $B0, $8C
	db $D7, $3E, $88, $D3, $3D, $84, $D7, $3E, $88, $D3, $41, $8C, $DF, $44, $90, $DB
	db $43, $8C, $41, $8C, $3A, $8C, $3D, $8C, $D3, $3C, $8C, $D7, $3A, $88, $D3, $37
	db $8C, $EE, $3A, $A1, $B0, $B0, $B2, $12, $5F, $B1, $BF, $7F, $BD, $00, $BE, $04
	db $98, $D5, $52, $15, $A0, $D5, $98, $98, $D5, $52, $15, $A0, $D5, $98, $B4, $B3
	db $75, $5F, $B3, $75, $5F, $B3, $75, $5F, $B3, $75, $5F, $B3, $75, $5F, $B3, $75
	db $5F, $B2, $6C, $5F, $B1, $BF, $7F, $BD, $F4, $BE, $08, $D7, $2E, $1F, $8C, $D7
	db $8C, $BE, $09, $D7, $56, $15, $9C, $BE, $08, $D7, $38, $1F, $88, $D3, $3A, $84
	db $BE, $09, $D7, $56, $15, $88, $BE, $08, $D3, $38, $1F, $84, $DB, $35, $8C, $D7
	db $33, $1F, $8C, $D7, $8C, $BE, $09, $D7, $55, $15, $9C, $BE, $08, $D7, $3D, $1F
	db $88, $D3, $3F, $84, $BE, $09, $D7, $55, $15, $88, $BE, $08, $D3, $3D, $1F, $84
	db $DB, $3A, $8C, $B4, $D7, $2E, $1F, $8C, $D7, $8C, $BE, $09, $D7, $56, $15, $9C
	db $BE, $08, $D7, $38, $1F, $88, $D3, $3A, $84, $BE, $09, $D7, $56, $15, $88, $BE
	db $08, $D3, $38, $1F, $84, $DB, $35, $8C, $B4, $B3, $BD, $5F, $B3, $E2, $5F, $B3
	db $BD, $5F, $B3, $E2, $5F, $B3, $BD, $5F, $B2, $97, $5F, $B1, $BF, $7F, $BD, $00
	db $BE, $64, $D3, $27, $11, $8C, $DB, $2A, $0B, $8C, $C1, $20, $D5, $25, $10, $81
	db $C1, $40, $8B, $D2, $24, $0B, $88, $C1, $20, $D5, $25, $0C, $81, $C1, $40, $83
	db $D2, $24, $0B, $88, $D2, $84, $D3, $27, $11, $8C, $C1, $20, $D5, $25, $10, $81
	db $C1, $40, $8B, $D2, $24, $0B, $88, $C1, $20, $D3, $25, $0C, $81, $C1, $40, $83
	db $D3, $27, $11, $8C, $DB, $2A, $0B, $8C, $C1, $20, $D5, $25, $10, $81, $C1, $40
	db $8B, $D2, $24, $0B, $88, $C1, $20, $D5, $25, $0C, $81, $C1, $40, $83, $D2, $24
	db $0B, $88, $D2, $84, $D3, $27, $11, $8C, $C1, $20, $D5, $25, $10, $81, $C1, $40
	db $8B, $D2, $24, $0B, $88, $D2, $84, $B4, $D3, $27, $11, $8C, $DB, $2A, $0B, $8C
	db $C1, $20, $D5, $25, $10, $81, $C1, $40, $8B, $D2, $24, $0B, $88, $C1, $20, $D5
	db $25, $0C, $81, $C1, $40, $83, $D2, $24, $0B, $88, $D2, $84, $D3, $27, $11, $8C
	db $C1, $20, $D5, $25, $10, $81, $C1, $40, $8B, $D2, $24, $0B, $88, $C1, $20, $D3
	db $25, $0C, $81, $C1, $40, $83, $B4, $B3, $5E, $60, $B3, $96, $60, $B3, $5E, $60
	db $B3, $96, $60, $B3, $5E, $60, $B2, $1E, $60, $B1, $04, $02, $0E, $5F, $68, $5F
	db $93, $5F, $1A, $60, $12, $5F, $6C, $5F, $97, $5F, $1E, $60, $67, $5F, $92, $5F
	db $19, $60, $E7, $60
