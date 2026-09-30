; audio/music/music_0a.asm
; bank 04, $77E9-$79A4 (443 bytes); pinned by layout.link
; song id 0A

SECTION "audio/music/music_0a", ROMX

; ---- data $77E9-$79A4 (443 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; command semantics not decoded (part of region $574D-$7E8C)
	db $BF, $7F, $BD, $00, $BC, $42, $BE, $4D, $C5, $18, $C4, $28, $EF, $45, $1A, $A0
	db $E7, $48, $98, $EF, $4C, $1A, $A0, $E7, $51, $98, $B4, $FB, $4F, $A8, $A8, $EF
	db $45, $1A, $A0, $E7, $48, $98, $B4, $EF, $4A, $A0, $E7, $4C, $98, $EF, $4F, $A0
	db $E7, $4A, $98, $EF, $47, $A0, $E7, $43, $98, $B3, $08, $78, $B3, $FC, $77, $FB
	db $4F, $1A, $A8, $A8, $E7, $54, $98, $51, $98, $4D, $98, $EF, $4C, $A0, $E7, $4A
	db $98, $FB, $48, $A8, $A8, $B3, $08, $78, $B2, $FC, $77, $B1, $BF, $7F, $BD, $00
	db $BE, $2B, $DB, $35, $10, $8C, $3C, $8C, $41, $8C, $45, $8C, $48, $8C, $4C, $8C
	db $DB, $35, $10, $8C, $3C, $8C, $41, $8C, $45, $8C, $48, $8C, $4C, $8C, $B4, $DB
	db $34, $10, $8C, $3B, $8C, $40, $8C, $43, $8C, $47, $8C, $4A, $8C, $B4, $B3, $68
	db $78, $DB, $32, $10, $8C, $39, $8C, $3E, $8C, $41, $8C, $45, $8C, $48, $8C, $B4
	db $B3, $7A, $78, $DB, $30, $10, $8C, $37, $8C, $3C, $8C, $43, $8C, $47, $8C, $4A
	db $8C, $B4, $30, $8C, $37, $8C, $3C, $8C, $40, $8C, $43, $8C, $47, $8C, $B3, $59
	db $78, $B3, $59, $78, $B3, $68, $78, $B3, $68, $78, $B3, $7A, $78, $DB, $2B, $10
	db $8C, $37, $8C, $3E, $8C, $41, $8C, $45, $8C, $48, $8C, $B3, $8C, $78, $DB, $4F
	db $10, $8C, $4C, $8C, $4A, $8C, $47, $8C, $43, $8C, $4C, $8C, $B3, $59, $78, $B2
	db $59, $78, $B1, $BF, $7F, $BD, $00, $BE, $37, $8C, $DB, $35, $0B, $8C, $3C, $8C
	db $41, $8C, $45, $8C, $48, $8C, $DB, $4C, $0B, $8C, $35, $8C, $3C, $8C, $41, $8C
	db $45, $8C, $48, $8C, $B4, $DB, $4C, $0B, $8C, $34, $8C, $3B, $8C, $40, $8C, $43
	db $8C, $47, $8C, $B4, $DB, $4A, $0B, $8C, $34, $8C, $3B, $8C, $40, $8C, $43, $8C
	db $47, $8C, $B4, $DB, $4A, $0B, $8C, $32, $8C, $39, $8C, $3E, $8C, $41, $8C, $45
	db $8C, $B4, $48, $8C, $32, $8C, $39, $8C, $3E, $8C, $41, $8C, $45, $8C, $DB, $48
	db $0B, $8C, $30, $8C, $37, $8C, $3C, $8C, $43, $8C, $47, $8C, $B4, $4A, $8C, $30
	db $8C, $37, $8C, $3C, $8C, $40, $8C, $43, $8C, $47, $8C, $35, $8C, $3C, $8C, $41
	db $8C, $45, $8C, $48, $8C, $B3, $EF, $78, $B3, $FE, $78, $B3, $0D, $79, $B3, $1C
	db $79, $DB, $48, $0B, $8C, $2B, $8C, $37, $8C, $3E, $8C, $41, $8C, $45, $8C, $B3
	db $37, $79, $DB, $4A, $0B, $8C, $4F, $8C, $4C, $8C, $4A, $8C, $47, $8C, $43, $8C
	db $B3, $EF, $78, $B2, $EF, $78, $B1, $03, $02, $E9, $77, $45, $78, $DC, $78, $FC
	db $77, $59, $78, $EF, $78, $44, $78, $DB, $78, $8F, $79
