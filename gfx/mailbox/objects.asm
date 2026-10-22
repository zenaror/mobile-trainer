; gfx/mailbox/objects.asm
; bank 26, $7AB0-$7D41 (657 bytes); pinned by layout.link
; profile HDMA tail, palettes and object tables (cursor, arrows, digits, envelopes)

SECTION "gfx/mailbox/objects", ROMX

; ---- data $7AB0-$7AC0 (16 bytes) [CONFIRMED] all-zero tail of the executed Profile_InitScreen request: bank 26 source $7820-$7AC0 is copied to VRAM0 $8000-$82A0; this aligned 16-byte unit maps to $8290-$82A0; tilemap selection/display is not established

Profile_InitScreen_HDMALoadZeroTail:: ; 26:7AB0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	ds $4, $00

; ---- data $7AC0-$7B00 (64 bytes) [PROBABLE] 8 palettes x 4 RGB555 words (all 32 words have bit15 clear; contains 7FFF); the mapper heuristic that extended this palette to 7BE4 swallowed pointer words (0x7Cxx have bit15 clear too)

Palette_Profile_Obj:: ; 26:7AC0
	INCLUDE "gfx/mailbox/objects/palette_7ac0.pal"

; ---- words $7B00-$7BE0 (224 bytes) [PROBABLE] 14 rows of 16 bytes = 4 identical 4-byte object-table entries (ptr to frame table, ptr to script); every pointer lands on a frame-table/script start found by the sequential sweep of 7B00-7D41 (26:7B00-7D41 (ends at the zero padding)); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs

Mailbox_ObjTable:: ; 26:7B00
	sprite_object_entry Mailbox_ObjAnimData, SpriteScript_Mailbox_ObjectEntry00 ; entry 0
	sprite_object_entry Mailbox_ObjAnimData, SpriteScript_Mailbox_ObjectEntry00 ; entry 1
	sprite_object_entry Mailbox_ObjAnimData, SpriteScript_Mailbox_ObjectEntry00 ; entry 2
	sprite_object_entry Mailbox_ObjAnimData, SpriteScript_Mailbox_ObjectEntry00 ; entry 3
Mailbox_ObjTable_Entry4:: ; 26:7B10
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry04, SpriteScript_Mailbox_ObjectEntry04 ; entry 4
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry04, SpriteScript_Mailbox_ObjectEntry04 ; entry 5
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry04, SpriteScript_Mailbox_ObjectEntry04 ; entry 6
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry04, SpriteScript_Mailbox_ObjectEntry04 ; entry 7
Mailbox_ObjTable_Entry8:: ; 26:7B20
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry08, SpriteScript_Mailbox_ObjectEntry08 ; entry 8
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry08, SpriteScript_Mailbox_ObjectEntry08 ; entry 9
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry08, SpriteScript_Mailbox_ObjectEntry08 ; entry 10
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry08, SpriteScript_Mailbox_ObjectEntry08 ; entry 11
Mailbox_ObjTable_Entry12:: ; 26:7B30
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry12, SpriteScript_Mailbox_ObjectEntry12 ; entry 12
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry12, SpriteScript_Mailbox_ObjectEntry12 ; entry 13
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry12, SpriteScript_Mailbox_ObjectEntry12 ; entry 14
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry12, SpriteScript_Mailbox_ObjectEntry12 ; entry 15
Mailbox_ObjTable_Entry16:: ; 26:7B40
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry16, SpriteScript_Mailbox_ObjectEntry16 ; entry 16
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry16, SpriteScript_Mailbox_ObjectEntry16 ; entry 17
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry16, SpriteScript_Mailbox_ObjectEntry16 ; entry 18
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry16, SpriteScript_Mailbox_ObjectEntry16 ; entry 19
Mailbox_ObjTable_Entry20:: ; 26:7B50
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry20, SpriteScript_Mailbox_ObjectEntry20 ; entry 20
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry20, SpriteScript_Mailbox_ObjectEntry20 ; entry 21
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry20, SpriteScript_Mailbox_ObjectEntry20 ; entry 22
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry20, SpriteScript_Mailbox_ObjectEntry20 ; entry 23
Mailbox_ObjTable_Entry24:: ; 26:7B60
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry24, SpriteScript_Mailbox_ObjectEntry24 ; entry 24
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry24, SpriteScript_Mailbox_ObjectEntry24 ; entry 25
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry24, SpriteScript_Mailbox_ObjectEntry24 ; entry 26
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry24, SpriteScript_Mailbox_ObjectEntry24 ; entry 27
Mailbox_ObjTable_Entry28:: ; 26:7B70
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry28, SpriteScript_Mailbox_ObjectEntry28 ; entry 28
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry28, SpriteScript_Mailbox_ObjectEntry28 ; entry 29
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry28, SpriteScript_Mailbox_ObjectEntry28 ; entry 30
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry28, SpriteScript_Mailbox_ObjectEntry28 ; entry 31
Mailbox_ObjTable_Entry32:: ; 26:7B80
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry32, SpriteScript_Mailbox_ObjectEntry32 ; entry 32
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry32, SpriteScript_Mailbox_ObjectEntry32 ; entry 33
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry32, SpriteScript_Mailbox_ObjectEntry32 ; entry 34
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry32, SpriteScript_Mailbox_ObjectEntry32 ; entry 35
Mailbox_ObjTable_Entry36:: ; 26:7B90
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry36, SpriteScript_Mailbox_ObjectEntry36 ; entry 36
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry36, SpriteScript_Mailbox_ObjectEntry36 ; entry 37
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry36, SpriteScript_Mailbox_ObjectEntry36 ; entry 38
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry36, SpriteScript_Mailbox_ObjectEntry36 ; entry 39
Mailbox_ObjTable_Entry40:: ; 26:7BA0
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry40, SpriteScript_Mailbox_ObjectEntry40 ; entry 40
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry40, SpriteScript_Mailbox_ObjectEntry40 ; entry 41
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry40, SpriteScript_Mailbox_ObjectEntry40 ; entry 42
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry40, SpriteScript_Mailbox_ObjectEntry40 ; entry 43
Mailbox_ObjTable_Entry44:: ; 26:7BB0
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry44, SpriteScript_Mailbox_ObjectEntry44 ; entry 44
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry44, SpriteScript_Mailbox_ObjectEntry44 ; entry 45
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry44, SpriteScript_Mailbox_ObjectEntry44 ; entry 46
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry44, SpriteScript_Mailbox_ObjectEntry44 ; entry 47
Mailbox_ObjTable_Entry48:: ; 26:7BC0
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry48, SpriteScript_Mailbox_ObjectEntry48 ; entry 48
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry48, SpriteScript_Mailbox_ObjectEntry48 ; entry 49
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry48, SpriteScript_Mailbox_ObjectEntry48 ; entry 50
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry48, SpriteScript_Mailbox_ObjectEntry48 ; entry 51
Mailbox_ObjTable_Entry52:: ; 26:7BD0
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry52, SpriteScript_Mailbox_ObjectEntry52 ; entry 52
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry52, SpriteScript_Mailbox_ObjectEntry52 ; entry 53
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry52, SpriteScript_Mailbox_ObjectEntry52 ; entry 54
	sprite_object_entry SpriteFrameTable_Mailbox_ObjectEntry52, SpriteScript_Mailbox_ObjectEntry52 ; entry 55

; ---- data $7BE0-$7D41 (353 bytes) [PROBABLE] 14 object record(s): 14 frame tables, 19 frames, 14 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 26:7B00-7D41 (ends at the zero padding)

Mailbox_ObjAnimData:: ; 26:7BE0
	sprite_frame_table SpriteFrame_Mailbox_ObjectEntry00_Frame00, SpriteFrame_Mailbox_ObjectEntry00_Frame01
SpriteFrame_Mailbox_ObjectEntry00_Frame00:: ; 26:7BE4
	sprite_frame 4
	sprite_oam -2, -2, $00, 0
	sprite_oam -2, 10, $00, OAMF_XFLIP
	sprite_oam 10, -2, $00, OAMF_YFLIP
	sprite_oam 10, 10, $00, OAMF_YFLIP | OAMF_XFLIP
SpriteFrame_Mailbox_ObjectEntry00_Frame01:: ; 26:7BF5
	sprite_frame 4
	sprite_oam -3, -3, $00, 0
	sprite_oam -3, 11, $00, OAMF_XFLIP
	sprite_oam 11, -3, $00, OAMF_YFLIP
	sprite_oam 11, 11, $00, OAMF_YFLIP | OAMF_XFLIP
SpriteScript_Mailbox_ObjectEntry00:: ; 26:7C06
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
SpriteFrameTable_Mailbox_ObjectEntry04:: ; 26:7C0B
	sprite_frame_table SpriteFrame_Mailbox_ObjectEntry04_Frame00
SpriteFrame_Mailbox_ObjectEntry04_Frame00:: ; 26:7C0D
	sprite_frame 3
	sprite_oam -11, -4, $18, 0
	sprite_oam -11, 4, $19, 0
	sprite_oam -11, 12, $0D, 0
SpriteScript_Mailbox_ObjectEntry04:: ; 26:7C1A
	sprite_anim 1
	sprite_anim_step 0, 64
SpriteFrameTable_Mailbox_ObjectEntry08:: ; 26:7C1D
	sprite_frame_table SpriteFrame_Mailbox_ObjectEntry08_Frame00
SpriteFrame_Mailbox_ObjectEntry08_Frame00:: ; 26:7C1F
	sprite_frame 3
	sprite_oam -11, -4, $1A, 0
	sprite_oam -11, 4, $1B, 0
	sprite_oam -11, 12, $1C, 0
SpriteScript_Mailbox_ObjectEntry08:: ; 26:7C2C
	sprite_anim 1
	sprite_anim_step 0, 64
SpriteFrameTable_Mailbox_ObjectEntry12:: ; 26:7C2F
	sprite_frame_table SpriteFrame_Mailbox_ObjectEntry12_Frame00
SpriteFrame_Mailbox_ObjectEntry12_Frame00:: ; 26:7C31
	sprite_frame 3
	sprite_oam -11, -4, $1D, 0
	sprite_oam -11, 4, $1E, 0
	sprite_oam -11, 12, $1F, 0
SpriteScript_Mailbox_ObjectEntry12:: ; 26:7C3E
	sprite_anim 1
	sprite_anim_step 0, 64
SpriteFrameTable_Mailbox_ObjectEntry16:: ; 26:7C41
	sprite_frame_table SpriteFrame_Mailbox_ObjectEntry16_Frame00, SpriteFrame_Mailbox_ObjectEntry16_Frame01
SpriteFrame_Mailbox_ObjectEntry16_Frame00:: ; 26:7C45
	sprite_frame 4
	sprite_oam 0, 0, $22, 0
	sprite_oam 0, 8, $23, 0
	sprite_oam 0, 0, $20, 3
	sprite_oam 0, 8, $21, 3
SpriteFrame_Mailbox_ObjectEntry16_Frame01:: ; 26:7C56
	sprite_frame 4
	sprite_oam -1, 0, $22, 0
	sprite_oam -1, 8, $23, 0
	sprite_oam -1, 0, $20, 3
	sprite_oam -1, 8, $21, 3
SpriteScript_Mailbox_ObjectEntry16:: ; 26:7C67
	sprite_anim 2
	sprite_anim_step 0, 20
	sprite_anim_step 1, 20
SpriteFrameTable_Mailbox_ObjectEntry20:: ; 26:7C6C
	sprite_frame_table SpriteFrame_Mailbox_ObjectEntry20_Frame00, SpriteFrame_Mailbox_ObjectEntry20_Frame01
SpriteFrame_Mailbox_ObjectEntry20_Frame00:: ; 26:7C70
	sprite_frame 4
	sprite_oam 0, 0, $22, OAMF_YFLIP
	sprite_oam 0, 8, $23, OAMF_YFLIP
	sprite_oam 0, 0, $20, OAMF_YFLIP | 3
	sprite_oam 0, 8, $21, OAMF_YFLIP | 3
SpriteFrame_Mailbox_ObjectEntry20_Frame01:: ; 26:7C81
	sprite_frame 4
	sprite_oam 1, 0, $22, OAMF_YFLIP
	sprite_oam 1, 8, $23, OAMF_YFLIP
	sprite_oam 1, 0, $20, OAMF_YFLIP | 3
	sprite_oam 1, 8, $21, OAMF_YFLIP | 3
SpriteScript_Mailbox_ObjectEntry20:: ; 26:7C92
	sprite_anim 2
	sprite_anim_step 0, 20
	sprite_anim_step 1, 20
SpriteFrameTable_Mailbox_ObjectEntry24:: ; 26:7C97
	sprite_frame_table SpriteFrame_Mailbox_ObjectEntry24_Frame00
SpriteFrame_Mailbox_ObjectEntry24_Frame00:: ; 26:7C99
	sprite_frame 1
	sprite_oam 2, 16, $01, 1
SpriteScript_Mailbox_ObjectEntry24:: ; 26:7C9E
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_Mailbox_ObjectEntry28:: ; 26:7CA1
	sprite_frame_table SpriteFrame_Mailbox_ObjectEntry28_Frame00
SpriteFrame_Mailbox_ObjectEntry28_Frame00:: ; 26:7CA3
	sprite_frame 1
	sprite_oam 2, 16, $02, 1
SpriteScript_Mailbox_ObjectEntry28:: ; 26:7CA8
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_Mailbox_ObjectEntry32:: ; 26:7CAB
	sprite_frame_table SpriteFrame_Mailbox_ObjectEntry32_Frame00
SpriteFrame_Mailbox_ObjectEntry32_Frame00:: ; 26:7CAD
	sprite_frame 1
	sprite_oam 2, 16, $03, 1
SpriteScript_Mailbox_ObjectEntry32:: ; 26:7CB2
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_Mailbox_ObjectEntry36:: ; 26:7CB5
	sprite_frame_table SpriteFrame_Mailbox_ObjectEntry36_Frame00
SpriteFrame_Mailbox_ObjectEntry36_Frame00:: ; 26:7CB7
	sprite_frame 1
	sprite_oam 2, 16, $04, 1
SpriteScript_Mailbox_ObjectEntry36:: ; 26:7CBC
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_Mailbox_ObjectEntry40:: ; 26:7CBF
	sprite_frame_table SpriteFrame_Mailbox_ObjectEntry40_Frame00
SpriteFrame_Mailbox_ObjectEntry40_Frame00:: ; 26:7CC1
	sprite_frame 4
	sprite_oam 0, 0, $11, 2
	sprite_oam 0, 8, $12, 2
	sprite_oam 8, 0, $13, 2
	sprite_oam 8, 7, $13, OAMF_XFLIP | 2
SpriteScript_Mailbox_ObjectEntry40:: ; 26:7CD2
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_Mailbox_ObjectEntry44:: ; 26:7CD5
	sprite_frame_table SpriteFrame_Mailbox_ObjectEntry44_Frame00
SpriteFrame_Mailbox_ObjectEntry44_Frame00:: ; 26:7CD7
	sprite_frame 4
	sprite_oam 0, 0, $14, 2
	sprite_oam 0, 8, $15, 2
	sprite_oam 8, 0, $16, 2
	sprite_oam 8, 8, $17, 2
SpriteScript_Mailbox_ObjectEntry44:: ; 26:7CE8
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_Mailbox_ObjectEntry48:: ; 26:7CEB
	sprite_frame_table SpriteFrame_Mailbox_ObjectEntry48_Frame00, SpriteFrame_Mailbox_ObjectEntry48_Frame01
SpriteFrame_Mailbox_ObjectEntry48_Frame00:: ; 26:7CEF
	sprite_frame 4
	sprite_oam 0, 0, $11, 2
	sprite_oam 0, 8, $12, 2
	sprite_oam 8, 0, $13, 2
	sprite_oam 8, 7, $13, OAMF_XFLIP | 2
SpriteFrame_Mailbox_ObjectEntry48_Frame01:: ; 26:7D00
	sprite_frame 4
	sprite_oam 0, 0, $28, 2
	sprite_oam 0, 8, $29, 2
	sprite_oam 8, 0, $2A, 2
	sprite_oam 8, 8, $2B, 2
SpriteScript_Mailbox_ObjectEntry48:: ; 26:7D11
	sprite_anim 2
	sprite_anim_step 0, 29
	sprite_anim_step 1, 19
SpriteFrameTable_Mailbox_ObjectEntry52:: ; 26:7D16
	sprite_frame_table SpriteFrame_Mailbox_ObjectEntry52_Frame00, SpriteFrame_Mailbox_ObjectEntry52_Frame01
SpriteFrame_Mailbox_ObjectEntry52_Frame00:: ; 26:7D1A
	sprite_frame 4
	sprite_oam 0, 0, $14, 2
	sprite_oam 0, 8, $15, 2
	sprite_oam 8, 0, $16, 2
	sprite_oam 8, 8, $17, 2
SpriteFrame_Mailbox_ObjectEntry52_Frame01:: ; 26:7D2B
	sprite_frame 4
	sprite_oam 0, 0, $24, 2
	sprite_oam 0, 8, $25, 2
	sprite_oam 8, 0, $26, 2
	sprite_oam 8, 8, $27, 2
SpriteScript_Mailbox_ObjectEntry52:: ; 26:7D3C
	sprite_anim 2
	sprite_anim_step 0, 29
	sprite_anim_step 1, 19
