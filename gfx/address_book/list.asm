; gfx/address_book/list.asm
; bank 2F, $4D40-$5098 (856 bytes); pinned by layout.link
; list tilemap and cursor animation table

SECTION "gfx/address_book/list", ROMX

; ---- data $4D40-$5010 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2F:45EA: hl=$4D40 a=$2F b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Abook_List:: ; 2F:4D40
Data_2F_4D40::
	INCBIN "gfx/address_book/list/abook_list.tilemap"
	INCBIN "gfx/address_book/list/abook_list.attrmap"

; ---- ptrtable $5010-$5050 (64 bytes) [PROBABLE] 32 words, all inside $5050-$5098 of the same bank (animation/OAM frame data); tables of 4-byte entries (2 words) addressed by ld de,imm before FarCall 00:0A82 (init_object_from_table: reads the 4-byte entry number B&$7F of the table at DE); each 16-byte table = 4 identical-pair entries; callers 2F:4507 ld de,$5010, 2F:4522 $5020, 2F:453D $5030, 2F:4558 $5040 (a=$2F b=$81)

Table_Abook_ButtonCursorAnims:: ; 2F:5010
Table_2F_5010::
	sprite_object_entry Abook_ButtonCursor_ObjAnimData, SpriteScript_2F_505F ; entry 0
	sprite_object_entry Abook_ButtonCursor_ObjAnimData, SpriteScript_2F_505F ; entry 1
	sprite_object_entry Abook_ButtonCursor_ObjAnimData, SpriteScript_2F_505F ; entry 2
	sprite_object_entry Abook_ButtonCursor_ObjAnimData, SpriteScript_2F_505F ; entry 3
Table_Abook_ButtonCursorAnims_Entry4:: ; 2F:5020
	sprite_object_entry SpriteFrameTable_2F_5062, SpriteScript_2F_5071 ; entry 4
	sprite_object_entry SpriteFrameTable_2F_5062, SpriteScript_2F_5071 ; entry 5
	sprite_object_entry SpriteFrameTable_2F_5062, SpriteScript_2F_5071 ; entry 6
	sprite_object_entry SpriteFrameTable_2F_5062, SpriteScript_2F_5071 ; entry 7
Table_Abook_ButtonCursorAnims_Entry8:: ; 2F:5030
	sprite_object_entry SpriteFrameTable_2F_5074, SpriteScript_2F_5083 ; entry 8
	sprite_object_entry SpriteFrameTable_2F_5074, SpriteScript_2F_5083 ; entry 9
	sprite_object_entry SpriteFrameTable_2F_5074, SpriteScript_2F_5083 ; entry 10
	sprite_object_entry SpriteFrameTable_2F_5074, SpriteScript_2F_5083 ; entry 11
Table_Abook_ButtonCursorAnims_Entry12:: ; 2F:5040
	sprite_object_entry SpriteFrameTable_2F_5086, SpriteScript_2F_5095 ; entry 12
	sprite_object_entry SpriteFrameTable_2F_5086, SpriteScript_2F_5095 ; entry 13
	sprite_object_entry SpriteFrameTable_2F_5086, SpriteScript_2F_5095 ; entry 14
	sprite_object_entry SpriteFrameTable_2F_5086, SpriteScript_2F_5095 ; entry 15

; ---- data $5050-$5098 (72 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; frames of the 5010 tables (records at 5050/5062/5074/5086: dw list, count 3 x (y,x,tile,attr), 01 00 40)

Abook_ButtonCursor_ObjAnimData:: ; 2F:5050
Data_2F_5050::
	sprite_frame_table SpriteFrame_2F_5052
SpriteFrame_2F_5052:: ; 2F:5052
	sprite_frame 3
	sprite_oam -11, -4, $44, 3
	sprite_oam -11, 4, $45, 3
	sprite_oam -11, 12, $46, 3
SpriteScript_2F_505F:: ; 2F:505F
	sprite_anim 1
	sprite_anim_step 0, 64
SpriteFrameTable_2F_5062:: ; 2F:5062
	sprite_frame_table SpriteFrame_2F_5064
SpriteFrame_2F_5064:: ; 2F:5064
	sprite_frame 3
	sprite_oam -11, -4, $47, 3
	sprite_oam -11, 4, $48, 3
	sprite_oam -11, 12, $49, 3
SpriteScript_2F_5071:: ; 2F:5071
	sprite_anim 1
	sprite_anim_step 0, 64
SpriteFrameTable_2F_5074:: ; 2F:5074
	sprite_frame_table SpriteFrame_2F_5076
SpriteFrame_2F_5076:: ; 2F:5076
	sprite_frame 3
	sprite_oam -11, -4, $4A, 3
	sprite_oam -11, 4, $4B, 3
	sprite_oam -11, 12, $4C, 3
SpriteScript_2F_5083:: ; 2F:5083
	sprite_anim 1
	sprite_anim_step 0, 64
SpriteFrameTable_2F_5086:: ; 2F:5086
	sprite_frame_table SpriteFrame_2F_5088
SpriteFrame_2F_5088:: ; 2F:5088
	sprite_frame 3
	sprite_oam -11, -4, $4D, 3
	sprite_oam -11, 4, $4E, 3
	sprite_oam -11, 12, $4F, 3
SpriteScript_2F_5095:: ; 2F:5095
	sprite_anim 1
	sprite_anim_step 0, 64
