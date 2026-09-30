; audio/music/music_01.asm
; bank 04, $574D-$58C6 (377 bytes); pinned by layout.link
; song id 01 (ids 1E-28 reuse its header)

SECTION "audio/music/music_01", ROMX

; ---- data $574D-$58C6 (377 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; command semantics not decoded (part of region $574D-$7E8C)

Data_SoundDrv_Streams:: ; 04:574D
Data_04_574D::
	db $BF, $7F, $BD, $00, $BC, $3D, $BE, $52, $C5, $0F, $C3, $2A, $C4, $1A, $8C, $D5
	db $48, $1A, $86, $47, $86, $48, $86, $D4, $4D, $8C, $4B, $8C, $D4, $8C, $D5, $4A
	db $86, $DB, $48, $8C, $46, $8C, $45, $8C, $D5, $46, $86, $EF, $48, $A2, $D5, $46
	db $86, $4A, $86, $4D, $86, $52, $86, $D7, $54, $88, $B1, $BF, $7F, $BD, $00, $BE
	db $06, $D4, $45, $12, $86, $03, $8C, $D4, $48, $12, $86, $BE, $04, $D5, $4D, $15
	db $86, $BE, $06, $D4, $45, $12, $86, $03, $86, $D4, $43, $12, $86, $03, $86, $D4
	db $46, $12, $86, $03, $86, $D4, $3F, $12, $86, $BE, $04, $D7, $4B, $15, $8C, $BE
	db $06, $D4, $46, $12, $86, $03, $86, $D4, $45, $12, $86, $03, $86, $D4, $48, $12
	db $86, $41, $86, $D4, $03, $86, $D4, $45, $12, $86, $BE, $05, $DB, $4D, $10, $8C
	db $D5, $4F, $86, $E1, $50, $92, $BE, $06, $D5, $3E, $12, $86, $41, $86, $46, $86
	db $4A, $86, $D7, $4C, $88, $B1, $BF, $7F, $BD, $00, $BE, $20, $D7, $29, $1D, $92
	db $D5, $35, $86, $BE, $20, $D5, $45, $15, $8C, $BE, $20, $D5, $29, $1D, $8C, $D7
	db $27, $92, $D5, $33, $86, $BE, $20, $D7, $43, $15, $8C, $BE, $20, $D5, $27, $1D
	db $8C, $D7, $29, $92, $D5, $35, $92, $D7, $2C, $92, $D5, $38, $92, $2E, $8C, $3A
	db $8C, $D7, $30, $88, $B1, $BF, $7F, $BD, $00, $BE, $64, $D3, $27, $11, $86, $D5
	db $2A, $0B, $86, $D3, $24, $86, $D3, $86, $C1, $28, $D3, $2F, $0F, $81, $C1, $40
	db $85, $D3, $24, $0B, $86, $D3, $86, $D3, $27, $11, $86, $24, $0B, $86, $D5, $2A
	db $86, $D3, $27, $11, $86, $24, $0B, $86, $C1, $28, $D3, $2F, $0F, $81, $C1, $40
	db $85, $D3, $24, $0B, $86, $27, $11, $86, $D5, $2A, $0B, $86, $D3, $27, $11, $86
	db $D5, $2A, $0B, $86, $D3, $24, $86, $D3, $86, $C1, $28, $D3, $2F, $0F, $81, $C1
	db $40, $85, $D3, $24, $0B, $86, $D3, $86, $D3, $27, $11, $86, $24, $0B, $86, $D5
	db $2A, $86, $D3, $27, $11, $86, $24, $0B, $86, $C1, $28, $D3, $2F, $0F, $81, $C1
	db $40, $85, $D3, $24, $0B, $86, $D3, $86, $D3, $27, $11, $86, $D5, $86, $B1, $04
	db $00, $4D, $57, $88, $57, $F3, $57, $32, $58
