; gfx/address_book/list.asm
; bank 2F, $4D40-$5098 (856 bytes); pinned by layout.link
; list tilemap and cursor animation table

SECTION "gfx/address_book/list", ROMX

; ---- data $4D40-$5010 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2F:45EA: hl=$4D40 a=$2F b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Abook_List:: ; 2F:4D40

	INCBIN "gfx/address_book/list/abook_list.tilemap"
	INCBIN "gfx/address_book/list/abook_list.attrmap"

; ---- ptrtable $5010-$5050 (64 bytes) [PROBABLE] 32 words, all inside $5050-$5098 of the same bank (animation/OAM frame data); tables of 4-byte entries (2 words) addressed by ld de,imm before FarCall 00:0A82 (init_object_from_table: reads the 4-byte entry number B&$7F of the table at DE); each 16-byte table = 4 identical-pair entries; callers 2F:4507 ld de,$5010, 2F:4522 $5020, 2F:453D $5030, 2F:4558 $5040 (a=$2F b=$81)

Table_Abook_ButtonCursorAnims:: ; 2F:5010

	sprite_object_entry Abook_ButtonCursor_ObjAnimData, Abook_ButtonCursorAnim0Script ; entry 0
	sprite_object_entry Abook_ButtonCursor_ObjAnimData, Abook_ButtonCursorAnim0Script ; entry 1
	sprite_object_entry Abook_ButtonCursor_ObjAnimData, Abook_ButtonCursorAnim0Script ; entry 2
	sprite_object_entry Abook_ButtonCursor_ObjAnimData, Abook_ButtonCursorAnim0Script ; entry 3
Table_Abook_ButtonCursorAnims_Entry4:: ; 2F:5020
	sprite_object_entry Abook_ButtonCursorAnim1Frames, Abook_ButtonCursorAnim1Script ; entry 4
	sprite_object_entry Abook_ButtonCursorAnim1Frames, Abook_ButtonCursorAnim1Script ; entry 5
	sprite_object_entry Abook_ButtonCursorAnim1Frames, Abook_ButtonCursorAnim1Script ; entry 6
	sprite_object_entry Abook_ButtonCursorAnim1Frames, Abook_ButtonCursorAnim1Script ; entry 7
Table_Abook_ButtonCursorAnims_Entry8:: ; 2F:5030
	sprite_object_entry Abook_ButtonCursorAnim2Frames, Abook_ButtonCursorAnim2Script ; entry 8
	sprite_object_entry Abook_ButtonCursorAnim2Frames, Abook_ButtonCursorAnim2Script ; entry 9
	sprite_object_entry Abook_ButtonCursorAnim2Frames, Abook_ButtonCursorAnim2Script ; entry 10
	sprite_object_entry Abook_ButtonCursorAnim2Frames, Abook_ButtonCursorAnim2Script ; entry 11
Table_Abook_ButtonCursorAnims_Entry12:: ; 2F:5040
	sprite_object_entry Abook_ButtonCursorAnim3Frames, Abook_ButtonCursorAnim3Script ; entry 12
	sprite_object_entry Abook_ButtonCursorAnim3Frames, Abook_ButtonCursorAnim3Script ; entry 13
	sprite_object_entry Abook_ButtonCursorAnim3Frames, Abook_ButtonCursorAnim3Script ; entry 14
	sprite_object_entry Abook_ButtonCursorAnim3Frames, Abook_ButtonCursorAnim3Script ; entry 15

; ---- data $5050-$5098 (72 bytes) [PROBABLE] four selectable object-entry chains; each is a 2-byte frame-table pointer, one 13-byte frame with three OAM pieces, and a 3-byte single-step script (frame 0, delay $40); the table at $5010 selects chain 0 and the tables at $5020/$5030/$5040 select chains 1/2/3

Abook_ButtonCursor_ObjAnimData:: ; 2F:5050

	sprite_frame_table Abook_ButtonCursorAnim0Frame
Abook_ButtonCursorAnim0Frame:: ; 2F:5052
	sprite_frame 3
	sprite_oam -11, -4, $44, 3
	sprite_oam -11, 4, $45, 3
	sprite_oam -11, 12, $46, 3
Abook_ButtonCursorAnim0Script:: ; 2F:505F
	sprite_anim 1
	sprite_anim_step 0, 64
Abook_ButtonCursorAnim1Frames:: ; 2F:5062
	sprite_frame_table Abook_ButtonCursorAnim1Frame
Abook_ButtonCursorAnim1Frame:: ; 2F:5064
	sprite_frame 3
	sprite_oam -11, -4, $47, 3
	sprite_oam -11, 4, $48, 3
	sprite_oam -11, 12, $49, 3
Abook_ButtonCursorAnim1Script:: ; 2F:5071
	sprite_anim 1
	sprite_anim_step 0, 64
Abook_ButtonCursorAnim2Frames:: ; 2F:5074
	sprite_frame_table Abook_ButtonCursorAnim2Frame
Abook_ButtonCursorAnim2Frame:: ; 2F:5076
	sprite_frame 3
	sprite_oam -11, -4, $4A, 3
	sprite_oam -11, 4, $4B, 3
	sprite_oam -11, 12, $4C, 3
Abook_ButtonCursorAnim2Script:: ; 2F:5083
	sprite_anim 1
	sprite_anim_step 0, 64
Abook_ButtonCursorAnim3Frames:: ; 2F:5086
	sprite_frame_table Abook_ButtonCursorAnim3Frame
Abook_ButtonCursorAnim3Frame:: ; 2F:5088
	sprite_frame 3
	sprite_oam -11, -4, $4D, 3
	sprite_oam -11, 4, $4E, 3
	sprite_oam -11, 12, $4F, 3
Abook_ButtonCursorAnim3Script:: ; 2F:5095
	sprite_anim 1
	sprite_anim_step 0, 64
