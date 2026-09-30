; audio/music/music_0c.asm
; bank 04, $7BF3-$7DBC (457 bytes); pinned by layout.link
; song id 0C

SECTION "audio/music/music_0c", ROMX

; ---- data $7BF3-$7DBC (457 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; command semantics not decoded (part of region $574D-$7E8C)
	db $BF, $7F, $BD, $00, $BC, $47, $BE, $02, $D4, $49, $15, $8C, $08, $98, $D4, $44
	db $15, $8C, $08, $98, $DB, $47, $15, $8C, $D4, $46, $8C, $D4, $08, $9C, $D4, $42
	db $15, $8C, $DB, $43, $8C, $D4, $44, $8C, $DB, $43, $8C, $D4, $44, $8C, $49, $8C
	db $D4, $08, $98, $D4, $44, $15, $8C, $08, $98, $DB, $47, $15, $8C, $D4, $46, $8C
	db $D4, $08, $A4, $D4, $44, $15, $8C, $DB, $8C, $DB, $08, $8C, $B2, $F7, $7B, $B1
	db $BF, $7F, $BD, $00, $BE, $06, $D4, $44, $13, $8C, $BE, $04, $D4, $5C, $0C, $8C
	db $DB, $8C, $BE, $06, $D4, $3D, $13, $8C, $BE, $04, $D4, $5C, $0C, $8C, $D4, $8C
	db $BE, $06, $DB, $41, $13, $8C, $D4, $40, $8C, $8C, $BE, $04, $D4, $5C, $0C, $8C
	db $DB, $8C, $BE, $06, $D4, $3A, $13, $8C, $DB, $3B, $8C, $D4, $3C, $8C, $DB, $3B
	db $8C, $D4, $3C, $8C, $41, $8C, $BE, $04, $D4, $5C, $0C, $8C, $DB, $8C, $BE, $06
	db $D4, $3D, $13, $8C, $BE, $04, $D4, $5C, $0C, $8C, $D4, $8C, $BE, $06, $DB, $41
	db $13, $8C, $D4, $40, $8C, $8C, $BE, $04, $D4, $5C, $0C, $8C, $DB, $9C, $BE, $06
	db $D4, $3C, $13, $8C, $DB, $98, $B2, $47, $7C, $B1, $BF, $7F, $BD, $00, $BE, $08
	db $DB, $25, $1F, $8C, $D5, $2C, $8C, $31, $8C, $2F, $98, $2C, $98, $2A, $8C, $9C
	db $31, $8C, $DB, $2B, $8C, $D5, $2C, $8C, $DB, $2B, $8C, $D5, $2C, $8C, $DB, $25
	db $8C, $D5, $2C, $8C, $31, $8C, $2F, $98, $2C, $98, $2A, $8C, $A4, $32, $8C, $E7
	db $98, $B2, $C1, $7C, $B1, $BF, $7F, $BD, $00, $BE, $64, $D5, $27, $10, $8C, $D2
	db $24, $0B, $8C, $C1, $28, $D5, $25, $0E, $81, $C1, $40, $8B, $D5, $27, $10, $8C
	db $D2, $24, $0B, $8C, $C1, $28, $D5, $25, $0E, $81, $C1, $40, $8B, $D2, $24, $0B
	db $8C, $D2, $8C, $D5, $27, $10, $8C, $D2, $24, $0B, $8C, $C1, $28, $D5, $25, $0E
	db $81, $C1, $40, $8B, $D5, $27, $10, $8C, $D2, $24, $0B, $8C, $D2, $8C, $C1, $28
	db $D5, $25, $0E, $81, $C1, $40, $8B, $D2, $24, $0B, $8C, $D5, $27, $10, $8C, $D2
	db $24, $0B, $8C, $C1, $28, $D5, $25, $0E, $81, $C1, $40, $8B, $D5, $27, $10, $8C
	db $D2, $24, $0B, $8C, $C1, $28, $D5, $25, $0E, $81, $C1, $40, $8B, $D2, $24, $0B
	db $8C, $D2, $8C, $D5, $27, $10, $8C, $D2, $24, $0B, $8C, $C1, $28, $D5, $25, $0E
	db $81, $C1, $40, $8B, $D5, $27, $10, $8C, $D2, $24, $0B, $8C, $D2, $8C, $C1, $28
	db $D5, $25, $0E, $81, $C1, $40, $8B, $DB, $24, $0D, $8C, $B2, $FC, $7C, $B1, $04
	db $02, $F3, $7B, $43, $7C, $BD, $7C, $F8, $7C, $F7, $7B, $47, $7C, $C1, $7C, $FC
	db $7C, $42, $7C, $BC, $7C, $F7, $7C, $A1, $7D
