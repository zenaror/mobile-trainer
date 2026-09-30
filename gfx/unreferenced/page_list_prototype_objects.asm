; gfx/unreferenced/page_list_prototype_objects.asm
; bank 7F, $7830-$7CC5 (1173 bytes); pinned by layout.link
; prototype tiles and object animation data

SECTION "gfx/unreferenced/page_list_prototype_objects", ROMX

; ---- gfx $7830-$7B00 (720 bytes) [PROBABLE] 45 tiles (0x2D0 bytes) of 2bpp sprite-like graphics (rendered: signal/sync-style icons and small diagonal shapes; blank rows/tiles included); no HDMA call site found in the ROM (address never loaded as an immediate); bounded by the ret of 7F:782F before and the 8 palettes (7B00) after

Tiles_7F_7830:: ; 7F:7830
	INCBIN "gfx/unreferenced/page_list_prototype_objects/tiles_7830.2bpp"

; ---- data $7B00-$7B40 (64 bytes) [PROBABLE] 8 RGB555 palettes of 4 colours (64 bytes, all words < $8000; the last five are 0000 294A 56B5 7FFF); the mapper heuristic that made 7B10-7BA0 one 18-group palette ran over the object tables that follow (7B40-7B90)

Palette_TextCursor_Obj:: ; 7F:7B00
Palette_7F_7B00::
	INCLUDE "gfx/unreferenced/page_list_prototype_objects/palette_7b00.pal"

; ---- words $7B40-$7B90 (80 bytes) [PROBABLE] 5 object tables of 4 entries x 2 words (7B40, 7B50, 7B60, 7B70, 7B80; 16 bytes each, every entry repeated) read by init_object_from_table (00:0A82, de=$7B50/$7B60/$7B70/$7B80, a=$7F, callers in banks 2A, 2C, 2D, 2F, 65); all words point into 7B90-7CC5

Table_TextCursor_ObjTables:: ; 7F:7B40
Table_7F_7B40::
	dw Data_TextCursor_ObjAnimData, $7BA6, Data_TextCursor_ObjAnimData, $7BA6, Data_TextCursor_ObjAnimData, $7BA6, Data_TextCursor_ObjAnimData, $7BA6
	dw $7BB0, $7BC2, $7BB0, $7BC2, $7BB0, $7BC2, $7BB0, $7BC2
	dw $7BCF, $7C1B, $7BCF, $7C1B, $7BCF, $7C1B, $7BCF, $7C1B
	dw $7C24, $7C5D, $7C24, $7C5D, $7C24, $7C5D, $7C24, $7C5D
	dw $7C64, $7CBC, $7C64, $7CBC, $7C64, $7CBC, $7C64, $7CBC

; ---- data $7B90-$7CC5 (309 bytes) [PROBABLE] animation descriptors / sprite lists reached from the object tables 7F:7B40-7B90 (format as in bank 72:786C-7A1F); parts of it are CONFIRMED read by executed code (5/18 scenarios)

Data_TextCursor_ObjAnimData:: ; 7F:7B90
Data_7F_7B90::
	db $94, $7B, $9D, $7B, $02, $00, $18, $08, $21, $00, $00, $08, $01, $02, $00, $19
	db $08, $21, $00, $FF, $08, $01, $02, $00, $50, $01, $08, $02, $00, $2E, $01, $08
	db $B4, $7B, $BD, $7B, $02, $00, $00, $27, $00, $08, $00, $28, $00, $01, $00, $00
	db $29, $00, $02, $00, $14, $01, $14, $02, $00, $0F, $01, $0F, $01, $00, $04, $D7
	db $7B, $E8, $7B, $F9, $7B, $0A, $7C, $04, $00, $00, $0C, $00, $00, $08, $0D, $00
	db $08, $00, $0E, $00, $08, $08, $0F, $00, $04, $00, $00, $10, $00, $00, $08, $11
	db $00, $08, $00, $12, $00, $08, $08, $13, $00, $04, $00, $00, $14, $00, $00, $08
	db $15, $00, $08, $00, $16, $00, $08, $08, $17, $00, $04, $00, $00, $10, $00, $00
	db $08, $11, $00, $08, $00, $12, $00, $08, $08, $13, $00, $04, $00, $0C, $01, $0A
	db $02, $0F, $03, $0A, $2A, $7C, $3B, $7C, $4C, $7C, $04, $00, $00, $0C, $00, $00
	db $08, $0D, $00, $08, $00, $0E, $00, $08, $08, $0F, $00, $04, $FC, $00, $0C, $00
	db $FC, $08, $0D, $00, $04, $00, $0E, $00, $04, $08, $0F, $00, $04, $00, $00, $0C
	db $00, $00, $08, $0D, $00, $08, $00, $0E, $00, $08, $08, $0F, $00, $03, $00, $05
	db $01, $08, $02, $0A, $6C, $7C, $79, $7C, $8E, $7C, $A3, $7C, $03, $08, $00, $19
	db $00, $08, $08, $1A, $00, $00, $08, $18, $00, $05, $FF, $08, $1B, $00, $07, $00
	db $1C, $00, $07, $08, $1D, $00, $00, $FF, $25, $00, $09, $09, $26, $00, $05, $00
	db $06, $1E, $00, $08, $FE, $1F, $00, $08, $06, $20, $00, $FF, $FE, $25, $00, $09
	db $0A, $26, $00, $06, $02, $FD, $21, $00, $02, $05, $22, $00, $0A, $FD, $23, $00
	db $0A, $05, $24, $00, $FE, $FD, $25, $00, $09, $0B, $26, $00, $04, $00, $0A, $01
	db $0A, $02, $05, $03, $0A
