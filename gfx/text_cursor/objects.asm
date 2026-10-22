; gfx/text_cursor/objects.asm
; bank 7F, $7B00-$7CC5 (453 bytes); extent is fixed by layout.link.
; Palette, repeated object-table entries and animation/frame data used by text editors.

SECTION "gfx/text_cursor/objects", ROMX

; ---- data $7B00-$7B40 (64 bytes) [PROBABLE] 8 RGB555 palettes of 4 colours (all words < $8000; the last five are 0000 294A 56B5 7FFF); the mapper heuristic that made 7B10-7BA0 one 18-group palette ran over the object tables that follow (7B40-7B90)
Palette_TextCursor_Obj:: ; 7F:7B00
	INCLUDE "gfx/text_cursor/objects/text_cursor_obj_palette.pal"

; ---- words $7B40-$7B90 (80 bytes) [PROBABLE] 5 object tables of 4 entries x 2 words (7B40, 7B50, 7B60, 7B70, 7B80; 16 bytes each, every entry repeated) read by init_object_from_table (00:0A82, de=$7B50/$7B60/$7B70/$7B80, a=$7F, callers in banks 2A, 2C, 2D, 2F, 65); all words point into 7B90-7CC5

Table_TextCursor_ObjTables:: ; 7F:7B40
	sprite_object_entry Data_TextCursor_ObjAnimData, SpriteScript_TextCursor_ObjectEntry00 ; entry 0
	sprite_object_entry Data_TextCursor_ObjAnimData, SpriteScript_TextCursor_ObjectEntry00 ; entry 1
	sprite_object_entry Data_TextCursor_ObjAnimData, SpriteScript_TextCursor_ObjectEntry00 ; entry 2
	sprite_object_entry Data_TextCursor_ObjAnimData, SpriteScript_TextCursor_ObjectEntry00 ; entry 3
Table_TextCursor_ObjTables_Entry4:: ; 7F:7B50
	sprite_object_entry SpriteFrameTable_TextCursor_ObjectEntry01, SpriteScript_TextCursor_ObjectEntry01 ; entry 4
	sprite_object_entry SpriteFrameTable_TextCursor_ObjectEntry01, SpriteScript_TextCursor_ObjectEntry01 ; entry 5
	sprite_object_entry SpriteFrameTable_TextCursor_ObjectEntry01, SpriteScript_TextCursor_ObjectEntry01 ; entry 6
	sprite_object_entry SpriteFrameTable_TextCursor_ObjectEntry01, SpriteScript_TextCursor_ObjectEntry01 ; entry 7
Table_TextCursor_ObjTables_Entry8:: ; 7F:7B60
	sprite_object_entry SpriteFrameTable_TextCursor_ObjectEntry02, SpriteScript_TextCursor_ObjectEntry02 ; entry 8
	sprite_object_entry SpriteFrameTable_TextCursor_ObjectEntry02, SpriteScript_TextCursor_ObjectEntry02 ; entry 9
	sprite_object_entry SpriteFrameTable_TextCursor_ObjectEntry02, SpriteScript_TextCursor_ObjectEntry02 ; entry 10
	sprite_object_entry SpriteFrameTable_TextCursor_ObjectEntry02, SpriteScript_TextCursor_ObjectEntry02 ; entry 11
Table_TextCursor_ObjTables_Entry12:: ; 7F:7B70
	sprite_object_entry SpriteFrameTable_TextCursor_ObjectEntry03, SpriteScript_TextCursor_ObjectEntry03 ; entry 12
	sprite_object_entry SpriteFrameTable_TextCursor_ObjectEntry03, SpriteScript_TextCursor_ObjectEntry03 ; entry 13
	sprite_object_entry SpriteFrameTable_TextCursor_ObjectEntry03, SpriteScript_TextCursor_ObjectEntry03 ; entry 14
	sprite_object_entry SpriteFrameTable_TextCursor_ObjectEntry03, SpriteScript_TextCursor_ObjectEntry03 ; entry 15
Table_TextCursor_ObjTables_Entry16:: ; 7F:7B80
	sprite_object_entry SpriteFrameTable_TextCursor_ObjectEntry04, SpriteScript_TextCursor_ObjectEntry04 ; entry 16
	sprite_object_entry SpriteFrameTable_TextCursor_ObjectEntry04, SpriteScript_TextCursor_ObjectEntry04 ; entry 17
	sprite_object_entry SpriteFrameTable_TextCursor_ObjectEntry04, SpriteScript_TextCursor_ObjectEntry04 ; entry 18
	sprite_object_entry SpriteFrameTable_TextCursor_ObjectEntry04, SpriteScript_TextCursor_ObjectEntry04 ; entry 19

; ---- data $7B90-$7CC5 (309 bytes) [PROBABLE] animation descriptors / sprite lists reached from the object tables 7F:7B40-7B90 (format as in bank 72:786C-7A1F); parts of it are CONFIRMED read by executed code (5/18 scenarios)

Data_TextCursor_ObjAnimData:: ; 7F:7B90
	sprite_frame_table SpriteFrame_TextCursor_ObjectEntry00_Frame00, SpriteFrame_TextCursor_ObjectEntry00_Frame01
SpriteFrame_TextCursor_ObjectEntry00_Frame00:: ; 7F:7B94
	sprite_frame 2
	sprite_oam 0, 24, $08, OAMF_XFLIP | 1
	sprite_oam 0, 0, $08, 1
SpriteFrame_TextCursor_ObjectEntry00_Frame01:: ; 7F:7B9D
	sprite_frame 2
	sprite_oam 0, 25, $08, OAMF_XFLIP | 1
	sprite_oam 0, -1, $08, 1
SpriteScript_TextCursor_ObjectEntry00:: ; 7F:7BA6
	sprite_anim 2
	sprite_anim_step 0, 80
	sprite_anim_step 1, 8
	db $02, $00, $2E, $01, $08 ; not reached by any walked sprite chain
SpriteFrameTable_TextCursor_ObjectEntry01:: ; 7F:7BB0
	sprite_frame_table SpriteFrame_TextCursor_ObjectEntry01_Frame00, SpriteFrame_TextCursor_ObjectEntry01_Frame01
SpriteFrame_TextCursor_ObjectEntry01_Frame00:: ; 7F:7BB4
	sprite_frame 2
	sprite_oam 0, 0, $27, 0
	sprite_oam 8, 0, $28, 0
SpriteFrame_TextCursor_ObjectEntry01_Frame01:: ; 7F:7BBD
	sprite_frame 1
	sprite_oam 0, 0, $29, 0
SpriteScript_TextCursor_ObjectEntry01:: ; 7F:7BC2
	sprite_anim 2
	sprite_anim_step 0, 20
	sprite_anim_step 1, 20
	db $02, $00, $0F, $01, $0F, $01, $00, $04 ; not reached by any walked sprite chain
SpriteFrameTable_TextCursor_ObjectEntry02:: ; 7F:7BCF
	sprite_frame_table SpriteFrame_TextCursor_ObjectEntry02_Frame00, SpriteFrame_TextCursor_ObjectEntry02_Frame01, SpriteFrame_TextCursor_ObjectEntry02_Frame02, SpriteFrame_TextCursor_ObjectEntry02_Frame03
SpriteFrame_TextCursor_ObjectEntry02_Frame00:: ; 7F:7BD7
	sprite_frame 4
	sprite_oam 0, 0, $0C, 0
	sprite_oam 0, 8, $0D, 0
	sprite_oam 8, 0, $0E, 0
	sprite_oam 8, 8, $0F, 0
SpriteFrame_TextCursor_ObjectEntry02_Frame01:: ; 7F:7BE8
	sprite_frame 4
	sprite_oam 0, 0, $10, 0
	sprite_oam 0, 8, $11, 0
	sprite_oam 8, 0, $12, 0
	sprite_oam 8, 8, $13, 0
SpriteFrame_TextCursor_ObjectEntry02_Frame02:: ; 7F:7BF9
	sprite_frame 4
	sprite_oam 0, 0, $14, 0
	sprite_oam 0, 8, $15, 0
	sprite_oam 8, 0, $16, 0
	sprite_oam 8, 8, $17, 0
SpriteFrame_TextCursor_ObjectEntry02_Frame03:: ; 7F:7C0A
	sprite_frame 4
	sprite_oam 0, 0, $10, 0
	sprite_oam 0, 8, $11, 0
	sprite_oam 8, 0, $12, 0
	sprite_oam 8, 8, $13, 0
SpriteScript_TextCursor_ObjectEntry02:: ; 7F:7C1B
	sprite_anim 4
	sprite_anim_step 0, 12
	sprite_anim_step 1, 10
	sprite_anim_step 2, 15
	sprite_anim_step 3, 10
SpriteFrameTable_TextCursor_ObjectEntry03:: ; 7F:7C24
	sprite_frame_table SpriteFrame_TextCursor_ObjectEntry03_Frame00, SpriteFrame_TextCursor_ObjectEntry03_Frame01, SpriteFrame_TextCursor_ObjectEntry03_Frame02
SpriteFrame_TextCursor_ObjectEntry03_Frame00:: ; 7F:7C2A
	sprite_frame 4
	sprite_oam 0, 0, $0C, 0
	sprite_oam 0, 8, $0D, 0
	sprite_oam 8, 0, $0E, 0
	sprite_oam 8, 8, $0F, 0
SpriteFrame_TextCursor_ObjectEntry03_Frame01:: ; 7F:7C3B
	sprite_frame 4
	sprite_oam -4, 0, $0C, 0
	sprite_oam -4, 8, $0D, 0
	sprite_oam 4, 0, $0E, 0
	sprite_oam 4, 8, $0F, 0
SpriteFrame_TextCursor_ObjectEntry03_Frame02:: ; 7F:7C4C
	sprite_frame 4
	sprite_oam 0, 0, $0C, 0
	sprite_oam 0, 8, $0D, 0
	sprite_oam 8, 0, $0E, 0
	sprite_oam 8, 8, $0F, 0
SpriteScript_TextCursor_ObjectEntry03:: ; 7F:7C5D
	sprite_anim 3
	sprite_anim_step 0, 5
	sprite_anim_step 1, 8
	sprite_anim_step 2, 10
SpriteFrameTable_TextCursor_ObjectEntry04:: ; 7F:7C64
	sprite_frame_table SpriteFrame_TextCursor_ObjectEntry04_Frame00, SpriteFrame_TextCursor_ObjectEntry04_Frame01, SpriteFrame_TextCursor_ObjectEntry04_Frame02, SpriteFrame_TextCursor_ObjectEntry04_Frame03
SpriteFrame_TextCursor_ObjectEntry04_Frame00:: ; 7F:7C6C
	sprite_frame 3
	sprite_oam 8, 0, $19, 0
	sprite_oam 8, 8, $1A, 0
	sprite_oam 0, 8, $18, 0
SpriteFrame_TextCursor_ObjectEntry04_Frame01:: ; 7F:7C79
	sprite_frame 5
	sprite_oam -1, 8, $1B, 0
	sprite_oam 7, 0, $1C, 0
	sprite_oam 7, 8, $1D, 0
	sprite_oam 0, -1, $25, 0
	sprite_oam 9, 9, $26, 0
SpriteFrame_TextCursor_ObjectEntry04_Frame02:: ; 7F:7C8E
	sprite_frame 5
	sprite_oam 0, 6, $1E, 0
	sprite_oam 8, -2, $1F, 0
	sprite_oam 8, 6, $20, 0
	sprite_oam -1, -2, $25, 0
	sprite_oam 9, 10, $26, 0
SpriteFrame_TextCursor_ObjectEntry04_Frame03:: ; 7F:7CA3
	sprite_frame 6
	sprite_oam 2, -3, $21, 0
	sprite_oam 2, 5, $22, 0
	sprite_oam 10, -3, $23, 0
	sprite_oam 10, 5, $24, 0
	sprite_oam -2, -3, $25, 0
	sprite_oam 9, 11, $26, 0
SpriteScript_TextCursor_ObjectEntry04:: ; 7F:7CBC
	sprite_anim 4
	sprite_anim_step 0, 10
	sprite_anim_step 1, 10
	sprite_anim_step 2, 5
	sprite_anim_step 3, 10
