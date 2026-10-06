; gfx/mailbox/objects.asm
; bank 26, $7AB0-$7D41 (657 bytes); pinned by layout.link
; palettes and object tables (cursor, arrows, digits, envelopes) of the mailbox

SECTION "gfx/mailbox/objects", ROMX

; ---- data $7AB0-$7ABC (12 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 7420-7B00 by higher-priority evidence]

Data_26_7AB0:: ; 26:7AB0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- zero $7ABC-$7AC0 (4 bytes) [PROBABLE] 4 zero bytes (two blank palette words) before the palette block
	ds $4, $00

; ---- data $7AC0-$7B00 (64 bytes) [PROBABLE] 8 palettes x 4 RGB555 words (all 32 words have bit15 clear; contains 7FFF); the mapper heuristic that extended this palette to 7BE4 swallowed pointer words (0x7Cxx have bit15 clear too)

Palette_Profile_Obj:: ; 26:7AC0
Palette_26_7AC0::
	INCLUDE "gfx/mailbox/objects/palette_7ac0.pal"

; ---- words $7B00-$7BE0 (224 bytes) [PROBABLE] 14 rows of 16 bytes = 4 identical 4-byte object-table entries (ptr to frame table, ptr to script); every pointer lands on a frame-table/script start found by the sequential sweep of 7B00-7D41 (26:7B00-7D41 (ends at the zero padding)); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs

Mailbox_ObjTable:: ; 26:7B00
Table_26_7B00::
	sprite_object_entry Mailbox_ObjAnimData, SpriteScript_26_7C06 ; entry 0
	sprite_object_entry Mailbox_ObjAnimData, SpriteScript_26_7C06 ; entry 1
	sprite_object_entry Mailbox_ObjAnimData, SpriteScript_26_7C06 ; entry 2
	sprite_object_entry Mailbox_ObjAnimData, SpriteScript_26_7C06 ; entry 3
Mailbox_ObjTable_Entry4:: ; 26:7B10
	sprite_object_entry SpriteFrameTable_26_7C0B, SpriteScript_26_7C1A ; entry 4
	sprite_object_entry SpriteFrameTable_26_7C0B, SpriteScript_26_7C1A ; entry 5
	sprite_object_entry SpriteFrameTable_26_7C0B, SpriteScript_26_7C1A ; entry 6
	sprite_object_entry SpriteFrameTable_26_7C0B, SpriteScript_26_7C1A ; entry 7
Mailbox_ObjTable_Entry8:: ; 26:7B20
	sprite_object_entry SpriteFrameTable_26_7C1D, SpriteScript_26_7C2C ; entry 8
	sprite_object_entry SpriteFrameTable_26_7C1D, SpriteScript_26_7C2C ; entry 9
	sprite_object_entry SpriteFrameTable_26_7C1D, SpriteScript_26_7C2C ; entry 10
	sprite_object_entry SpriteFrameTable_26_7C1D, SpriteScript_26_7C2C ; entry 11
Mailbox_ObjTable_Entry12:: ; 26:7B30
	sprite_object_entry SpriteFrameTable_26_7C2F, SpriteScript_26_7C3E ; entry 12
	sprite_object_entry SpriteFrameTable_26_7C2F, SpriteScript_26_7C3E ; entry 13
	sprite_object_entry SpriteFrameTable_26_7C2F, SpriteScript_26_7C3E ; entry 14
	sprite_object_entry SpriteFrameTable_26_7C2F, SpriteScript_26_7C3E ; entry 15
Mailbox_ObjTable_Entry16:: ; 26:7B40
	sprite_object_entry SpriteFrameTable_26_7C41, SpriteScript_26_7C67 ; entry 16
	sprite_object_entry SpriteFrameTable_26_7C41, SpriteScript_26_7C67 ; entry 17
	sprite_object_entry SpriteFrameTable_26_7C41, SpriteScript_26_7C67 ; entry 18
	sprite_object_entry SpriteFrameTable_26_7C41, SpriteScript_26_7C67 ; entry 19
Mailbox_ObjTable_Entry20:: ; 26:7B50
	sprite_object_entry SpriteFrameTable_26_7C6C, SpriteScript_26_7C92 ; entry 20
	sprite_object_entry SpriteFrameTable_26_7C6C, SpriteScript_26_7C92 ; entry 21
	sprite_object_entry SpriteFrameTable_26_7C6C, SpriteScript_26_7C92 ; entry 22
	sprite_object_entry SpriteFrameTable_26_7C6C, SpriteScript_26_7C92 ; entry 23
Mailbox_ObjTable_Entry24:: ; 26:7B60
	sprite_object_entry SpriteFrameTable_26_7C97, SpriteScript_26_7C9E ; entry 24
	sprite_object_entry SpriteFrameTable_26_7C97, SpriteScript_26_7C9E ; entry 25
	sprite_object_entry SpriteFrameTable_26_7C97, SpriteScript_26_7C9E ; entry 26
	sprite_object_entry SpriteFrameTable_26_7C97, SpriteScript_26_7C9E ; entry 27
Mailbox_ObjTable_Entry28:: ; 26:7B70
	sprite_object_entry SpriteFrameTable_26_7CA1, SpriteScript_26_7CA8 ; entry 28
	sprite_object_entry SpriteFrameTable_26_7CA1, SpriteScript_26_7CA8 ; entry 29
	sprite_object_entry SpriteFrameTable_26_7CA1, SpriteScript_26_7CA8 ; entry 30
	sprite_object_entry SpriteFrameTable_26_7CA1, SpriteScript_26_7CA8 ; entry 31
Mailbox_ObjTable_Entry32:: ; 26:7B80
	sprite_object_entry SpriteFrameTable_26_7CAB, SpriteScript_26_7CB2 ; entry 32
	sprite_object_entry SpriteFrameTable_26_7CAB, SpriteScript_26_7CB2 ; entry 33
	sprite_object_entry SpriteFrameTable_26_7CAB, SpriteScript_26_7CB2 ; entry 34
	sprite_object_entry SpriteFrameTable_26_7CAB, SpriteScript_26_7CB2 ; entry 35
Mailbox_ObjTable_Entry36:: ; 26:7B90
	sprite_object_entry SpriteFrameTable_26_7CB5, SpriteScript_26_7CBC ; entry 36
	sprite_object_entry SpriteFrameTable_26_7CB5, SpriteScript_26_7CBC ; entry 37
	sprite_object_entry SpriteFrameTable_26_7CB5, SpriteScript_26_7CBC ; entry 38
	sprite_object_entry SpriteFrameTable_26_7CB5, SpriteScript_26_7CBC ; entry 39
Mailbox_ObjTable_Entry40:: ; 26:7BA0
	sprite_object_entry SpriteFrameTable_26_7CBF, SpriteScript_26_7CD2 ; entry 40
	sprite_object_entry SpriteFrameTable_26_7CBF, SpriteScript_26_7CD2 ; entry 41
	sprite_object_entry SpriteFrameTable_26_7CBF, SpriteScript_26_7CD2 ; entry 42
	sprite_object_entry SpriteFrameTable_26_7CBF, SpriteScript_26_7CD2 ; entry 43
Mailbox_ObjTable_Entry44:: ; 26:7BB0
	sprite_object_entry SpriteFrameTable_26_7CD5, SpriteScript_26_7CE8 ; entry 44
	sprite_object_entry SpriteFrameTable_26_7CD5, SpriteScript_26_7CE8 ; entry 45
	sprite_object_entry SpriteFrameTable_26_7CD5, SpriteScript_26_7CE8 ; entry 46
	sprite_object_entry SpriteFrameTable_26_7CD5, SpriteScript_26_7CE8 ; entry 47
Mailbox_ObjTable_Entry48:: ; 26:7BC0
	sprite_object_entry SpriteFrameTable_26_7CEB, SpriteScript_26_7D11 ; entry 48
	sprite_object_entry SpriteFrameTable_26_7CEB, SpriteScript_26_7D11 ; entry 49
	sprite_object_entry SpriteFrameTable_26_7CEB, SpriteScript_26_7D11 ; entry 50
	sprite_object_entry SpriteFrameTable_26_7CEB, SpriteScript_26_7D11 ; entry 51
Mailbox_ObjTable_Entry52:: ; 26:7BD0
	sprite_object_entry SpriteFrameTable_26_7D16, SpriteScript_26_7D3C ; entry 52
	sprite_object_entry SpriteFrameTable_26_7D16, SpriteScript_26_7D3C ; entry 53
	sprite_object_entry SpriteFrameTable_26_7D16, SpriteScript_26_7D3C ; entry 54
	sprite_object_entry SpriteFrameTable_26_7D16, SpriteScript_26_7D3C ; entry 55

; ---- data $7BE0-$7D41 (353 bytes) [PROBABLE] 14 object record(s): 14 frame tables, 19 frames, 14 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 26:7B00-7D41 (ends at the zero padding)

Mailbox_ObjAnimData:: ; 26:7BE0
Data_26_7BE0::
	sprite_frame_table SpriteFrame_26_7BE4, SpriteFrame_26_7BF5
SpriteFrame_26_7BE4:: ; 26:7BE4
	sprite_frame 4
	sprite_oam -2, -2, $00, 0
	sprite_oam -2, 10, $00, OAMF_XFLIP
	sprite_oam 10, -2, $00, OAMF_YFLIP
	sprite_oam 10, 10, $00, OAMF_YFLIP | OAMF_XFLIP
SpriteFrame_26_7BF5:: ; 26:7BF5
	sprite_frame 4
	sprite_oam -3, -3, $00, 0
	sprite_oam -3, 11, $00, OAMF_XFLIP
	sprite_oam 11, -3, $00, OAMF_YFLIP
	sprite_oam 11, 11, $00, OAMF_YFLIP | OAMF_XFLIP
SpriteScript_26_7C06:: ; 26:7C06
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
SpriteFrameTable_26_7C0B:: ; 26:7C0B
	sprite_frame_table SpriteFrame_26_7C0D
SpriteFrame_26_7C0D:: ; 26:7C0D
	sprite_frame 3
	sprite_oam -11, -4, $18, 0
	sprite_oam -11, 4, $19, 0
	sprite_oam -11, 12, $0D, 0
SpriteScript_26_7C1A:: ; 26:7C1A
	sprite_anim 1
	sprite_anim_step 0, 64
SpriteFrameTable_26_7C1D:: ; 26:7C1D
	sprite_frame_table SpriteFrame_26_7C1F
SpriteFrame_26_7C1F:: ; 26:7C1F
	sprite_frame 3
	sprite_oam -11, -4, $1A, 0
	sprite_oam -11, 4, $1B, 0
	sprite_oam -11, 12, $1C, 0
SpriteScript_26_7C2C:: ; 26:7C2C
	sprite_anim 1
	sprite_anim_step 0, 64
SpriteFrameTable_26_7C2F:: ; 26:7C2F
	sprite_frame_table SpriteFrame_26_7C31
SpriteFrame_26_7C31:: ; 26:7C31
	sprite_frame 3
	sprite_oam -11, -4, $1D, 0
	sprite_oam -11, 4, $1E, 0
	sprite_oam -11, 12, $1F, 0
SpriteScript_26_7C3E:: ; 26:7C3E
	sprite_anim 1
	sprite_anim_step 0, 64
SpriteFrameTable_26_7C41:: ; 26:7C41
	sprite_frame_table SpriteFrame_26_7C45, SpriteFrame_26_7C56
SpriteFrame_26_7C45:: ; 26:7C45
	sprite_frame 4
	sprite_oam 0, 0, $22, 0
	sprite_oam 0, 8, $23, 0
	sprite_oam 0, 0, $20, 3
	sprite_oam 0, 8, $21, 3
SpriteFrame_26_7C56:: ; 26:7C56
	sprite_frame 4
	sprite_oam -1, 0, $22, 0
	sprite_oam -1, 8, $23, 0
	sprite_oam -1, 0, $20, 3
	sprite_oam -1, 8, $21, 3
SpriteScript_26_7C67:: ; 26:7C67
	sprite_anim 2
	sprite_anim_step 0, 20
	sprite_anim_step 1, 20
SpriteFrameTable_26_7C6C:: ; 26:7C6C
	sprite_frame_table SpriteFrame_26_7C70, SpriteFrame_26_7C81
SpriteFrame_26_7C70:: ; 26:7C70
	sprite_frame 4
	sprite_oam 0, 0, $22, OAMF_YFLIP
	sprite_oam 0, 8, $23, OAMF_YFLIP
	sprite_oam 0, 0, $20, OAMF_YFLIP | 3
	sprite_oam 0, 8, $21, OAMF_YFLIP | 3
SpriteFrame_26_7C81:: ; 26:7C81
	sprite_frame 4
	sprite_oam 1, 0, $22, OAMF_YFLIP
	sprite_oam 1, 8, $23, OAMF_YFLIP
	sprite_oam 1, 0, $20, OAMF_YFLIP | 3
	sprite_oam 1, 8, $21, OAMF_YFLIP | 3
SpriteScript_26_7C92:: ; 26:7C92
	sprite_anim 2
	sprite_anim_step 0, 20
	sprite_anim_step 1, 20
SpriteFrameTable_26_7C97:: ; 26:7C97
	sprite_frame_table SpriteFrame_26_7C99
SpriteFrame_26_7C99:: ; 26:7C99
	sprite_frame 1
	sprite_oam 2, 16, $01, 1
SpriteScript_26_7C9E:: ; 26:7C9E
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_26_7CA1:: ; 26:7CA1
	sprite_frame_table SpriteFrame_26_7CA3
SpriteFrame_26_7CA3:: ; 26:7CA3
	sprite_frame 1
	sprite_oam 2, 16, $02, 1
SpriteScript_26_7CA8:: ; 26:7CA8
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_26_7CAB:: ; 26:7CAB
	sprite_frame_table SpriteFrame_26_7CAD
SpriteFrame_26_7CAD:: ; 26:7CAD
	sprite_frame 1
	sprite_oam 2, 16, $03, 1
SpriteScript_26_7CB2:: ; 26:7CB2
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_26_7CB5:: ; 26:7CB5
	sprite_frame_table SpriteFrame_26_7CB7
SpriteFrame_26_7CB7:: ; 26:7CB7
	sprite_frame 1
	sprite_oam 2, 16, $04, 1
SpriteScript_26_7CBC:: ; 26:7CBC
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_26_7CBF:: ; 26:7CBF
	sprite_frame_table SpriteFrame_26_7CC1
SpriteFrame_26_7CC1:: ; 26:7CC1
	sprite_frame 4
	sprite_oam 0, 0, $11, 2
	sprite_oam 0, 8, $12, 2
	sprite_oam 8, 0, $13, 2
	sprite_oam 8, 7, $13, OAMF_XFLIP | 2
SpriteScript_26_7CD2:: ; 26:7CD2
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_26_7CD5:: ; 26:7CD5
	sprite_frame_table SpriteFrame_26_7CD7
SpriteFrame_26_7CD7:: ; 26:7CD7
	sprite_frame 4
	sprite_oam 0, 0, $14, 2
	sprite_oam 0, 8, $15, 2
	sprite_oam 8, 0, $16, 2
	sprite_oam 8, 8, $17, 2
SpriteScript_26_7CE8:: ; 26:7CE8
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_26_7CEB:: ; 26:7CEB
	sprite_frame_table SpriteFrame_26_7CEF, SpriteFrame_26_7D00
SpriteFrame_26_7CEF:: ; 26:7CEF
	sprite_frame 4
	sprite_oam 0, 0, $11, 2
	sprite_oam 0, 8, $12, 2
	sprite_oam 8, 0, $13, 2
	sprite_oam 8, 7, $13, OAMF_XFLIP | 2
SpriteFrame_26_7D00:: ; 26:7D00
	sprite_frame 4
	sprite_oam 0, 0, $28, 2
	sprite_oam 0, 8, $29, 2
	sprite_oam 8, 0, $2A, 2
	sprite_oam 8, 8, $2B, 2
SpriteScript_26_7D11:: ; 26:7D11
	sprite_anim 2
	sprite_anim_step 0, 29
	sprite_anim_step 1, 19
SpriteFrameTable_26_7D16:: ; 26:7D16
	sprite_frame_table SpriteFrame_26_7D1A, SpriteFrame_26_7D2B
SpriteFrame_26_7D1A:: ; 26:7D1A
	sprite_frame 4
	sprite_oam 0, 0, $14, 2
	sprite_oam 0, 8, $15, 2
	sprite_oam 8, 0, $16, 2
	sprite_oam 8, 8, $17, 2
SpriteFrame_26_7D2B:: ; 26:7D2B
	sprite_frame 4
	sprite_oam 0, 0, $24, 2
	sprite_oam 0, 8, $25, 2
	sprite_oam 8, 0, $26, 2
	sprite_oam 8, 8, $27, 2
SpriteScript_26_7D3C:: ; 26:7D3C
	sprite_anim 2
	sprite_anim_step 0, 29
	sprite_anim_step 1, 19
