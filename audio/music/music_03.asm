; audio/music/music_03.asm
; bank 04, $5CD9-$5F0E (565 bytes); pinned by layout.link
; song id 03

SECTION "audio/music/music_03", ROMX

; ---- data $5CD9-$5F0E (565 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; command semantics not decoded (part of region $574D-$7E8C)
	db $BF, $7F, $BD, $00, $BC, $54, $BE, $1E, $C5, $18, $C3, $18, $C4, $20, $C1, $33
	db $F7, $42, $14, $83, $C1, $40, $AB, $81, $FF, $40, $8C, $B0, $DB, $42, $98, $DB
	db $98, $DB, $8C, $C1, $33, $DB, $83, $C1, $40, $95, $FF, $40, $8C, $B0, $C1, $33
	db $F7, $44, $83, $C1, $40, $AB, $81, $FF, $42, $8C, $B0, $DB, $44, $98, $DB, $98
	db $DB, $8C, $C1, $33, $DB, $83, $C1, $40, $95, $FF, $42, $8C, $B0, $B2, $DD, $5C
	db $B1, $BF, $7F, $BD, $00, $BE, $04, $98, $DB, $4A, $15, $9C, $DB, $9C, $DB, $49
	db $9C, $DB, $9C, $DB, $98, $98, $DB, $4A, $9C, $DB, $9C, $DB, $49, $9C, $DB, $98
	db $DB, $9C, $98, $DB, $4C, $15, $9C, $DB, $9C, $B4, $DB, $4B, $9C, $DB, $9C, $DB
	db $98, $B3, $4B, $5D, $DB, $4B, $15, $9C, $DB, $98, $DB, $9C, $B2, $2E, $5D, $B1
	db $BF, $7F, $BD, $F4, $BE, $08, $E7, $34, $1F, $98, $BE, $09, $DB, $50, $15, $8C
	db $BE, $08, $DB, $34, $1F, $8C, $DB, $8C, $BE, $09, $DB, $50, $15, $98, $BE, $08
	db $DB, $39, $1F, $8C, $B4, $BE, $09, $DB, $4F, $15, $98, $BE, $08, $E7, $39, $1F
	db $8C, $BE, $09, $DB, $4F, $15, $98, $BE, $08, $DB, $39, $1F, $8C, $BE, $09, $DB
	db $4F, $15, $98, $B3, $6D, $5D, $BE, $09, $DB, $4F, $15, $98, $BE, $08, $DB, $39
	db $1F, $8C, $BE, $09, $DB, $4F, $15, $98, $DB, $8C, $BE, $08, $DB, $38, $1F, $8C
	db $37, $8C, $E7, $36, $98, $BE, $09, $DB, $52, $15, $8C, $BE, $08, $DB, $36, $1F
	db $8C, $DB, $8C, $BE, $09, $DB, $52, $15, $98, $BE, $08, $DB, $3B, $1F, $8C, $BE
	db $09, $DB, $51, $15, $98, $BE, $08, $E7, $3B, $1F, $8C, $BE, $09, $DB, $51, $15
	db $98, $BE, $08, $DB, $3B, $1F, $8C, $BE, $09, $DB, $51, $15, $98, $BE, $08, $E7
	db $36, $1F, $98, $BE, $09, $DB, $52, $15, $8C, $BE, $08, $DB, $36, $1F, $8C, $DB
	db $8C, $BE, $09, $DB, $52, $15, $98, $BE, $08, $DB, $3B, $1F, $8C, $BE, $09, $DB
	db $51, $15, $98, $BE, $08, $DB, $2F, $1F, $8C, $BE, $09, $DB, $51, $15, $98, $DB
	db $8C, $BE, $08, $DB, $32, $1F, $8C, $33, $8C, $B2, $6D, $5D, $B1, $BF, $7F, $BD
	db $00, $BE, $64, $D3, $27, $15, $8C, $24, $0B, $8C, $D5, $29, $13, $8C, $D3, $27
	db $15, $86, $24, $0B, $86, $D3, $8C, $D5, $29, $13, $8C, $D3, $24, $0B, $8C, $27
	db $15, $8C, $D5, $29, $13, $8C, $D3, $24, $0B, $8C, $27, $15, $8C, $D5, $29, $13
	db $8C, $D3, $24, $0B, $8C, $27, $15, $8C, $D5, $29, $13, $8C, $D3, $24, $0B, $8C
	db $B4, $D3, $27, $15, $8C, $24, $0B, $8C, $D5, $29, $13, $8C, $D3, $27, $15, $86
	db $24, $0B, $86, $D3, $8C, $D5, $29, $13, $8C, $D3, $27, $15, $8C, $24, $0B, $8C
	db $B4, $D5, $29, $13, $8C, $D3, $27, $15, $8C, $24, $0B, $8C, $27, $15, $8C, $24
	db $0B, $8C, $D5, $29, $13, $8C, $D5, $8C, $D3, $24, $0B, $86, $D3, $86, $B4, $D3
	db $27, $15, $8C, $24, $0B, $8C, $D5, $29, $13, $8C, $D3, $27, $15, $86, $24, $0B
	db $86, $D3, $8C, $D5, $29, $13, $8C, $D3, $24, $0B, $8C, $27, $15, $8C, $B3, $6B
	db $5E, $B3, $8A, $5E, $B3, $AA, $5E, $B2, $4A, $5E, $B1, $04, $02, $D9, $5C, $2A
	db $5D, $69, $5D, $46, $5E, $DD, $5C, $2E, $5D, $6D, $5D, $4A, $5E, $29, $5D, $68
	db $5D, $45, $5E, $F3, $5E
