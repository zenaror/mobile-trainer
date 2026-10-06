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
	sprite_object_entry Data_TextCursor_ObjAnimData, SpriteScript_7F_7BA6 ; entry 0
	sprite_object_entry Data_TextCursor_ObjAnimData, SpriteScript_7F_7BA6 ; entry 1
	sprite_object_entry Data_TextCursor_ObjAnimData, SpriteScript_7F_7BA6 ; entry 2
	sprite_object_entry Data_TextCursor_ObjAnimData, SpriteScript_7F_7BA6 ; entry 3
Table_TextCursor_ObjTables_Entry4:: ; 7F:7B50
	sprite_object_entry SpriteFrameTable_7F_7BB0, SpriteScript_7F_7BC2 ; entry 4
	sprite_object_entry SpriteFrameTable_7F_7BB0, SpriteScript_7F_7BC2 ; entry 5
	sprite_object_entry SpriteFrameTable_7F_7BB0, SpriteScript_7F_7BC2 ; entry 6
	sprite_object_entry SpriteFrameTable_7F_7BB0, SpriteScript_7F_7BC2 ; entry 7
Table_TextCursor_ObjTables_Entry8:: ; 7F:7B60
	sprite_object_entry SpriteFrameTable_7F_7BCF, SpriteScript_7F_7C1B ; entry 8
	sprite_object_entry SpriteFrameTable_7F_7BCF, SpriteScript_7F_7C1B ; entry 9
	sprite_object_entry SpriteFrameTable_7F_7BCF, SpriteScript_7F_7C1B ; entry 10
	sprite_object_entry SpriteFrameTable_7F_7BCF, SpriteScript_7F_7C1B ; entry 11
Table_TextCursor_ObjTables_Entry12:: ; 7F:7B70
	sprite_object_entry SpriteFrameTable_7F_7C24, SpriteScript_7F_7C5D ; entry 12
	sprite_object_entry SpriteFrameTable_7F_7C24, SpriteScript_7F_7C5D ; entry 13
	sprite_object_entry SpriteFrameTable_7F_7C24, SpriteScript_7F_7C5D ; entry 14
	sprite_object_entry SpriteFrameTable_7F_7C24, SpriteScript_7F_7C5D ; entry 15
Table_TextCursor_ObjTables_Entry16:: ; 7F:7B80
	sprite_object_entry SpriteFrameTable_7F_7C64, SpriteScript_7F_7CBC ; entry 16
	sprite_object_entry SpriteFrameTable_7F_7C64, SpriteScript_7F_7CBC ; entry 17
	sprite_object_entry SpriteFrameTable_7F_7C64, SpriteScript_7F_7CBC ; entry 18
	sprite_object_entry SpriteFrameTable_7F_7C64, SpriteScript_7F_7CBC ; entry 19

; ---- data $7B90-$7CC5 (309 bytes) [PROBABLE] animation descriptors / sprite lists reached from the object tables 7F:7B40-7B90 (format as in bank 72:786C-7A1F); parts of it are CONFIRMED read by executed code (5/18 scenarios)

Data_TextCursor_ObjAnimData:: ; 7F:7B90
Data_7F_7B90::
	sprite_frame_table SpriteFrame_7F_7B94, SpriteFrame_7F_7B9D
SpriteFrame_7F_7B94:: ; 7F:7B94
	sprite_frame 2
	sprite_oam 0, 24, $08, OAMF_XFLIP | 1
	sprite_oam 0, 0, $08, 1
SpriteFrame_7F_7B9D:: ; 7F:7B9D
	sprite_frame 2
	sprite_oam 0, 25, $08, OAMF_XFLIP | 1
	sprite_oam 0, -1, $08, 1
SpriteScript_7F_7BA6:: ; 7F:7BA6
	sprite_anim 2
	sprite_anim_step 0, 80
	sprite_anim_step 1, 8
	db $02, $00, $2E, $01, $08 ; not reached by any walked sprite chain
SpriteFrameTable_7F_7BB0:: ; 7F:7BB0
	sprite_frame_table SpriteFrame_7F_7BB4, SpriteFrame_7F_7BBD
SpriteFrame_7F_7BB4:: ; 7F:7BB4
	sprite_frame 2
	sprite_oam 0, 0, $27, 0
	sprite_oam 8, 0, $28, 0
SpriteFrame_7F_7BBD:: ; 7F:7BBD
	sprite_frame 1
	sprite_oam 0, 0, $29, 0
SpriteScript_7F_7BC2:: ; 7F:7BC2
	sprite_anim 2
	sprite_anim_step 0, 20
	sprite_anim_step 1, 20
	db $02, $00, $0F, $01, $0F, $01, $00, $04 ; not reached by any walked sprite chain
SpriteFrameTable_7F_7BCF:: ; 7F:7BCF
	sprite_frame_table SpriteFrame_7F_7BD7, SpriteFrame_7F_7BE8, SpriteFrame_7F_7BF9, SpriteFrame_7F_7C0A
SpriteFrame_7F_7BD7:: ; 7F:7BD7
	sprite_frame 4
	sprite_oam 0, 0, $0C, 0
	sprite_oam 0, 8, $0D, 0
	sprite_oam 8, 0, $0E, 0
	sprite_oam 8, 8, $0F, 0
SpriteFrame_7F_7BE8:: ; 7F:7BE8
	sprite_frame 4
	sprite_oam 0, 0, $10, 0
	sprite_oam 0, 8, $11, 0
	sprite_oam 8, 0, $12, 0
	sprite_oam 8, 8, $13, 0
SpriteFrame_7F_7BF9:: ; 7F:7BF9
	sprite_frame 4
	sprite_oam 0, 0, $14, 0
	sprite_oam 0, 8, $15, 0
	sprite_oam 8, 0, $16, 0
	sprite_oam 8, 8, $17, 0
SpriteFrame_7F_7C0A:: ; 7F:7C0A
	sprite_frame 4
	sprite_oam 0, 0, $10, 0
	sprite_oam 0, 8, $11, 0
	sprite_oam 8, 0, $12, 0
	sprite_oam 8, 8, $13, 0
SpriteScript_7F_7C1B:: ; 7F:7C1B
	sprite_anim 4
	sprite_anim_step 0, 12
	sprite_anim_step 1, 10
	sprite_anim_step 2, 15
	sprite_anim_step 3, 10
SpriteFrameTable_7F_7C24:: ; 7F:7C24
	sprite_frame_table SpriteFrame_7F_7C2A, SpriteFrame_7F_7C3B, SpriteFrame_7F_7C4C
SpriteFrame_7F_7C2A:: ; 7F:7C2A
	sprite_frame 4
	sprite_oam 0, 0, $0C, 0
	sprite_oam 0, 8, $0D, 0
	sprite_oam 8, 0, $0E, 0
	sprite_oam 8, 8, $0F, 0
SpriteFrame_7F_7C3B:: ; 7F:7C3B
	sprite_frame 4
	sprite_oam -4, 0, $0C, 0
	sprite_oam -4, 8, $0D, 0
	sprite_oam 4, 0, $0E, 0
	sprite_oam 4, 8, $0F, 0
SpriteFrame_7F_7C4C:: ; 7F:7C4C
	sprite_frame 4
	sprite_oam 0, 0, $0C, 0
	sprite_oam 0, 8, $0D, 0
	sprite_oam 8, 0, $0E, 0
	sprite_oam 8, 8, $0F, 0
SpriteScript_7F_7C5D:: ; 7F:7C5D
	sprite_anim 3
	sprite_anim_step 0, 5
	sprite_anim_step 1, 8
	sprite_anim_step 2, 10
SpriteFrameTable_7F_7C64:: ; 7F:7C64
	sprite_frame_table SpriteFrame_7F_7C6C, SpriteFrame_7F_7C79, SpriteFrame_7F_7C8E, SpriteFrame_7F_7CA3
SpriteFrame_7F_7C6C:: ; 7F:7C6C
	sprite_frame 3
	sprite_oam 8, 0, $19, 0
	sprite_oam 8, 8, $1A, 0
	sprite_oam 0, 8, $18, 0
SpriteFrame_7F_7C79:: ; 7F:7C79
	sprite_frame 5
	sprite_oam -1, 8, $1B, 0
	sprite_oam 7, 0, $1C, 0
	sprite_oam 7, 8, $1D, 0
	sprite_oam 0, -1, $25, 0
	sprite_oam 9, 9, $26, 0
SpriteFrame_7F_7C8E:: ; 7F:7C8E
	sprite_frame 5
	sprite_oam 0, 6, $1E, 0
	sprite_oam 8, -2, $1F, 0
	sprite_oam 8, 6, $20, 0
	sprite_oam -1, -2, $25, 0
	sprite_oam 9, 10, $26, 0
SpriteFrame_7F_7CA3:: ; 7F:7CA3
	sprite_frame 6
	sprite_oam 2, -3, $21, 0
	sprite_oam 2, 5, $22, 0
	sprite_oam 10, -3, $23, 0
	sprite_oam 10, 5, $24, 0
	sprite_oam -2, -3, $25, 0
	sprite_oam 9, 11, $26, 0
SpriteScript_7F_7CBC:: ; 7F:7CBC
	sprite_anim 4
	sprite_anim_step 0, 10
	sprite_anim_step 1, 10
	sprite_anim_step 2, 5
	sprite_anim_step 3, 10
