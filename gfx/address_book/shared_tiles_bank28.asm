; gfx/address_book/shared_tiles_bank28.asm
; bank 28, $4BD0-$54B0 (2272 bytes); pinned by layout.link
; address-book tiles/palette/tables stored in bank 28 (loaded by banks 2A, 2C, 2F)

SECTION "gfx/address_book/shared_tiles_bank28", ROMX

; ---- gfx $4BD0-$4FD0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2C:5931: hl=$4BD0 a=$28 c=$40 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_AddrBookShared_Tiles8000:: ; 28:4BD0
Data_28_4BD0::
	INCBIN "gfx/address_book/shared_tiles_bank28/tiles_4bd0.2bpp"

; ---- gfx $4FD0-$51D0 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2C:5946: hl=$4FD0 a=$28 c=$20 de=$8400 (dest VRAM $8400, vbank=0)

Gfx_AddrBookShared_Tiles8400:: ; 28:4FD0
Data_28_4FD0::
	INCBIN "gfx/address_book/shared_tiles_bank28/tiles_4fd0.2bpp"

; ---- data $51D0-$5210 (64 bytes) [PROBABLE] 8 palettes x 4 RGB555 words (0x40 bytes, all bit15 clear; partly read by executed code) right before the object tables at 5210

Palette_AbookList_Bg:: ; 28:51D0
Palette_28_51D0::
	INCLUDE "gfx/address_book/shared_tiles_bank28/palette_51d0.pal"

; ---- words $5210-$5280 (112 bytes) [PROBABLE] 7 rows of 16 bytes = 4 identical 4-byte object-table entries (ptr to frame table, ptr to script); every pointer lands on a frame-table/script start found by the sequential sweep of 5210-54B0 (28:5210-54B0); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs [v4: bytes 5214-5218, 5224-5228, 5244-5248 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

AddrBookShared_ObjTable:: ; 28:5210
Table_28_5210::
	sprite_object_entry AddrBookShared_ObjAnimData, SpriteScript_28_52A6 ; entry 0
	sprite_object_entry AddrBookShared_ObjAnimData, SpriteScript_28_52A6 ; entry 1
	sprite_object_entry AddrBookShared_ObjAnimData, SpriteScript_28_52A6 ; entry 2
	sprite_object_entry AddrBookShared_ObjAnimData, SpriteScript_28_52A6 ; entry 3
AddrBookShared_ObjTable_Entry4:: ; 28:5220
	sprite_object_entry SpriteFrameTable_28_52AB, SpriteScript_28_52BE ; entry 4
	sprite_object_entry SpriteFrameTable_28_52AB, SpriteScript_28_52BE ; entry 5
	sprite_object_entry SpriteFrameTable_28_52AB, SpriteScript_28_52BE ; entry 6
	sprite_object_entry SpriteFrameTable_28_52AB, SpriteScript_28_52BE ; entry 7
AddrBookShared_ObjTable_Entry8:: ; 28:5230
	sprite_object_entry SpriteFrameTable_28_52C1, SpriteScript_28_52D4 ; entry 8
	sprite_object_entry SpriteFrameTable_28_52C1, SpriteScript_28_52D4 ; entry 9
	sprite_object_entry SpriteFrameTable_28_52C1, SpriteScript_28_52D4 ; entry 10
	sprite_object_entry SpriteFrameTable_28_52C1, SpriteScript_28_52D4 ; entry 11
AddrBookShared_ObjTable_Entry12:: ; 28:5240
	sprite_object_entry SpriteFrameTable_28_52D7, SpriteScript_28_536E ; entry 12
	sprite_object_entry SpriteFrameTable_28_52D7, SpriteScript_28_536E ; entry 13
	sprite_object_entry SpriteFrameTable_28_52D7, SpriteScript_28_536E ; entry 14
	sprite_object_entry SpriteFrameTable_28_52D7, SpriteScript_28_536E ; entry 15
AddrBookShared_ObjTable_Entry16:: ; 28:5250
	sprite_object_entry SpriteFrameTable_28_5379, SpriteScript_28_5428 ; entry 16
	sprite_object_entry SpriteFrameTable_28_5379, SpriteScript_28_5428 ; entry 17
	sprite_object_entry SpriteFrameTable_28_5379, SpriteScript_28_5428 ; entry 18
	sprite_object_entry SpriteFrameTable_28_5379, SpriteScript_28_5428 ; entry 19
	sprite_object_entry SpriteFrameTable_28_5436, SpriteScript_28_546C ; entry 20
	sprite_object_entry SpriteFrameTable_28_5436, SpriteScript_28_546C ; entry 21
	sprite_object_entry SpriteFrameTable_28_5436, SpriteScript_28_546C ; entry 22
	sprite_object_entry SpriteFrameTable_28_5436, SpriteScript_28_546C ; entry 23
	sprite_object_entry SpriteFrameTable_28_546F, SpriteScript_28_54A5 ; entry 24
	sprite_object_entry SpriteFrameTable_28_546F, SpriteScript_28_54A5 ; entry 25
	sprite_object_entry SpriteFrameTable_28_546F, SpriteScript_28_54A5 ; entry 26
	sprite_object_entry SpriteFrameTable_28_546F, SpriteScript_28_54A5 ; entry 27

; ---- data $5280-$54B0 (560 bytes) [PROBABLE] 7 object record(s): 7 frame tables, 18 frames, 8 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 28:5210-54B0 [v4: bytes 5280-52C1, 52D7-5379 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

AddrBookShared_ObjAnimData:: ; 28:5280
Data_28_5280::
	sprite_frame_table SpriteFrame_28_5284, SpriteFrame_28_5295
SpriteFrame_28_5284:: ; 28:5284
	sprite_frame 4
	sprite_oam 10, -2, $00, OAMF_YFLIP | 2
	sprite_oam 10, 10, $00, OAMF_YFLIP | OAMF_XFLIP | 2
	sprite_oam -2, -2, $00, 2
	sprite_oam -2, 10, $00, OAMF_XFLIP | 2
SpriteFrame_28_5295:: ; 28:5295
	sprite_frame 4
	sprite_oam 11, -3, $00, OAMF_YFLIP | 2
	sprite_oam 11, 11, $00, OAMF_YFLIP | OAMF_XFLIP | 2
	sprite_oam -3, -3, $00, 2
	sprite_oam -3, 11, $00, OAMF_XFLIP | 2
SpriteScript_28_52A6:: ; 28:52A6
	sprite_anim 2
	sprite_anim_step 0, 64
	sprite_anim_step 1, 8
SpriteFrameTable_28_52AB:: ; 28:52AB
	sprite_frame_table SpriteFrame_28_52AD
SpriteFrame_28_52AD:: ; 28:52AD
	sprite_frame 4
	sprite_oam 0, 8, $0D, 0
	sprite_oam 0, 16, $0E, 0
	sprite_oam 8, 8, $2E, 0
	sprite_oam 8, 16, $2F, 0
SpriteScript_28_52BE:: ; 28:52BE
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_52C1:: ; 28:52C1
	sprite_frame_table SpriteFrame_28_52C3
SpriteFrame_28_52C3:: ; 28:52C3
	sprite_frame 4
	sprite_oam 0, 8, $01, 0
	sprite_oam 0, 16, $02, 0
	sprite_oam 8, 8, $03, 0
	sprite_oam 8, 16, $04, 0
SpriteScript_28_52D4:: ; 28:52D4
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_52D7:: ; 28:52D7
	sprite_frame_table SpriteFrame_28_52E1, SpriteFrame_28_52F2, SpriteFrame_28_5313, SpriteFrame_28_5334
	sprite_frame_table SpriteFrame_28_5355
SpriteFrame_28_52E1:: ; 28:52E1
	sprite_frame 4
	sprite_oam 0, 8, $0D, 0
	sprite_oam 0, 16, $0E, 0
	sprite_oam 8, 8, $2E, 0
	sprite_oam 8, 16, $2F, 0
SpriteFrame_28_52F2:: ; 28:52F2
	sprite_frame 8
	sprite_oam 1, 8, $22, 0
	sprite_oam 1, 16, $23, 0
	sprite_oam 9, 16, $1F, 0
	sprite_oam 9, 8, $0F, 0
	sprite_oam 3, 8, $42, 2
	sprite_oam 3, 16, $42, 2
	sprite_oam 11, 8, $43, 2
	sprite_oam 11, 16, $43, 2
SpriteFrame_28_5313:: ; 28:5313
	sprite_frame 8
	sprite_oam -7, 9, $24, 2
	sprite_oam -7, 17, $25, 2
	sprite_oam 1, 9, $26, 2
	sprite_oam 1, 17, $27, 2
	sprite_oam 3, 9, $42, 2
	sprite_oam 3, 17, $42, 2
	sprite_oam 4, 9, $42, 2
	sprite_oam 4, 17, $42, 2
SpriteFrame_28_5334:: ; 28:5334
	sprite_frame 8
	sprite_oam -5, 5, $28, 2
	sprite_oam -5, 13, $29, 2
	sprite_oam -5, 21, $2A, 2
	sprite_oam 3, 5, $2B, 2
	sprite_oam 3, 13, $2C, 2
	sprite_oam 3, 21, $2D, 2
	sprite_oam 4, 8, $42, 2
	sprite_oam 4, 16, $42, 2
SpriteFrame_28_5355:: ; 28:5355
	sprite_frame 6
	sprite_oam -3, 5, $19, 2
	sprite_oam -3, 13, $1A, 2
	sprite_oam -3, 21, $1B, 2
	sprite_oam 5, 5, $1C, 2
	sprite_oam 5, 13, $1D, 2
	sprite_oam 5, 21, $1E, 2
SpriteScript_28_536E:: ; 28:536E
	sprite_anim 5
	sprite_anim_step 0, 5
	sprite_anim_step 1, 5
	sprite_anim_step 2, 5
	sprite_anim_step 3, 3
	sprite_anim_step 4, 18
SpriteFrameTable_28_5379:: ; 28:5379
	sprite_frame_table SpriteFrame_28_5383, SpriteFrame_28_5394, SpriteFrame_28_53B5, SpriteFrame_28_53D6
	sprite_frame_table SpriteFrame_28_5403
SpriteFrame_28_5383:: ; 28:5383
	sprite_frame 4
	sprite_oam 0, 8, $01, 0
	sprite_oam 0, 16, $02, 0
	sprite_oam 8, 8, $03, 0
	sprite_oam 8, 16, $04, 0
SpriteFrame_28_5394:: ; 28:5394
	sprite_frame 8
	sprite_oam 1, 8, $05, 0
	sprite_oam 1, 16, $06, 0
	sprite_oam 9, 8, $07, 0
	sprite_oam 9, 16, $08, 0
	sprite_oam 3, 8, $42, 2
	sprite_oam 3, 16, $42, 2
	sprite_oam 11, 8, $43, 2
	sprite_oam 11, 16, $43, 2
SpriteFrame_28_53B5:: ; 28:53B5
	sprite_frame 8
	sprite_oam 1, 9, $26, 2
	sprite_oam 1, 17, $27, 2
	sprite_oam -7, 9, $20, 2
	sprite_oam -7, 17, $21, 2
	sprite_oam 3, 9, $42, 2
	sprite_oam 3, 17, $42, 2
	sprite_oam 4, 9, $42, 2
	sprite_oam 4, 17, $42, 2
SpriteFrame_28_53D6:: ; 28:53D6
	sprite_frame 11
	sprite_oam 3, 5, $2B, 2
	sprite_oam 3, 13, $2C, 2
	sprite_oam 3, 21, $2D, 2
	sprite_oam -5, 5, $30, 2
	sprite_oam -5, 13, $31, 2
	sprite_oam -5, 21, $32, 2
	sprite_oam -13, 5, $33, 2
	sprite_oam -13, 13, $34, 2
	sprite_oam -13, 21, $35, 2
	sprite_oam 4, 8, $42, 2
	sprite_oam 4, 16, $42, 2
SpriteFrame_28_5403:: ; 28:5403
	sprite_frame 9
	sprite_oam -10, 5, $10, 2
	sprite_oam -10, 13, $11, 2
	sprite_oam -10, 21, $12, 2
	sprite_oam -2, 5, $13, 2
	sprite_oam -2, 13, $14, 2
	sprite_oam -2, 21, $15, 2
	sprite_oam 6, 5, $16, 2
	sprite_oam 6, 13, $17, 2
	sprite_oam 6, 21, $18, 2
SpriteScript_28_5428:: ; 28:5428
	sprite_anim 5
	sprite_anim_step 0, 5
	sprite_anim_step 1, 5
	sprite_anim_step 2, 5
	sprite_anim_step 3, 3
	sprite_anim_step 4, 18
	db $01, $00, $04 ; not reached by any walked sprite chain
SpriteFrameTable_28_5436:: ; 28:5436
	sprite_frame_table SpriteFrame_28_543A, SpriteFrame_28_544B
SpriteFrame_28_543A:: ; 28:543A
	sprite_frame 4
	sprite_oam 0, 8, $0D, 0
	sprite_oam 0, 16, $0E, 0
	sprite_oam 8, 8, $2E, 0
	sprite_oam 8, 16, $2F, 0
SpriteFrame_28_544B:: ; 28:544B
	sprite_frame 8
	sprite_oam -5, 8, $36, 0
	sprite_oam -5, 16, $37, 0
	sprite_oam 3, 8, $38, 0
	sprite_oam 3, 16, $39, 0
	sprite_oam 1, 8, $42, 2
	sprite_oam 1, 16, $42, 2
	sprite_oam 9, 8, $43, 2
	sprite_oam 9, 16, $43, 2
SpriteScript_28_546C:: ; 28:546C
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_546F:: ; 28:546F
	sprite_frame_table SpriteFrame_28_5473, SpriteFrame_28_5494
SpriteFrame_28_5473:: ; 28:5473
	sprite_frame 8
	sprite_oam -5, 8, $09, 0
	sprite_oam -5, 16, $0A, 0
	sprite_oam 3, 8, $0B, 0
	sprite_oam 3, 16, $0C, 0
	sprite_oam 1, 8, $42, 2
	sprite_oam 1, 16, $42, 2
	sprite_oam 9, 8, $43, 2
	sprite_oam 9, 16, $43, 2
SpriteFrame_28_5494:: ; 28:5494
	sprite_frame 4
	sprite_oam 0, 8, $01, 0
	sprite_oam 0, 16, $02, 0
	sprite_oam 8, 8, $03, 0
	sprite_oam 8, 16, $04, 0
SpriteScript_28_54A5:: ; 28:54A5
	sprite_anim 2
	sprite_anim_step 0, 5
	sprite_anim_step 1, 20
	db $00, $00, $00, $00, $00, $00
