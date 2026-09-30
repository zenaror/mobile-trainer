; gfx/mail_server/delete_method_screen.asm
; bank 28, $5F20-$6F20 (4096 bytes); pinned by layout.link
; delete-method screen tiles, two tilemaps, palettes, object tables (loaded by banks 22/23)

SECTION "gfx/mail_server/delete_method_screen", ROMX

; ---- gfx $5F20-$6150 (560 bytes) [PROBABLE] tiles-vram: 2 call site(s) (22:4277 23:4226); first: hdma_rom_to_vram at 22:4277: hl=$5F20 a=$28 c=$23 de=$9301 (dest VRAM $9300, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

MailServerDeleteMethod_Tiles_5F20:: ; 28:5F20
Data_28_5F20::
	INCBIN "gfx/mail_server/delete_method_screen/mail_server_delete_method_tiles_5f20.2bpp"

; ---- gfx $6150-$6550 (1024 bytes) [PROBABLE] tiles-vram: 2 call site(s) (22:428C 23:423B); first: hdma_rom_to_vram at 22:428C: hl=$6150 a=$28 c=$40 de=$8800 (dest VRAM $8800, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

MailServerDeleteMethod_Tiles_6150:: ; 28:6150
Data_28_6150::
	INCBIN "gfx/mail_server/delete_method_screen/mail_server_delete_method_tiles_6150.2bpp"

; ---- gfx $6550-$67E0 (656 bytes) [PROBABLE] tiles-vram: 2 call site(s) (22:42A1 23:4250); first: hdma_rom_to_vram at 22:42A1: hl=$6550 a=$28 c=$29 de=$8C00 (dest VRAM $8C00, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

MailServerDeleteMethod_Tiles_6550:: ; 28:6550
Data_28_6550::
	INCBIN "gfx/mail_server/delete_method_screen/mail_server_delete_method_tiles_6550.2bpp"

; ---- gfx $67E0-$6860 (128 bytes) [PROBABLE] tiles-vram: 2 call site(s) (22:42B6 23:4265); first: hdma_rom_to_vram at 22:42B6: hl=$67E0 a=$28 c=$08 de=$8000 (dest VRAM $8000, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

MailServerDeleteMethod_Tiles_67E0:: ; 28:67E0
Data_28_67E0::
	INCBIN "gfx/mail_server/delete_method_screen/mail_server_delete_method_tiles_67e0.2bpp"

; ---- data $6860-$6B30 (720 bytes) [PROBABLE] tilemap+attr: 2 call site(s) (23:4172 23:4279); first: copy_tilemap_rect_pair at 23:4172: hl=$6860 a=$28 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

MailServerDeleteMethod_Tilemap_First:: ; 28:6860
Data_28_6860::
	INCBIN "gfx/mail_server/delete_method_screen/mail_server_delete_method_tilemap_first.tilemap"
	INCBIN "gfx/mail_server/delete_method_screen/mail_server_delete_method_tilemap_first.attrmap"

; ---- data $6B30-$6E00 (720 bytes) [PROBABLE] tilemap+attr: 2 call site(s) (23:41AD 23:42D0); first: copy_tilemap_rect_pair at 23:41AD: hl=$6B30 a=$28 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

MailServerDeleteMethod_Tilemap_Second:: ; 28:6B30
Data_28_6B30::
	INCBIN "gfx/mail_server/delete_method_screen/mail_server_delete_method_tilemap_second.tilemap"
	INCBIN "gfx/mail_server/delete_method_screen/mail_server_delete_method_tilemap_second.attrmap"

; ---- data $6E00-$6E80 (128 bytes) [PROBABLE] 16 palettes x 4 RGB555 words (0x80 bytes, all words bit15 clear) directly after the tilemap 6B30-6E00 (same tilemap 2D0 + palette 80 layout as bank 45); the mapper heuristic had extended it over the object table words at 6E80-6EA0 [v4: bytes 6E00-6E08 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

MailServerDeleteMethod_BgPalette:: ; 28:6E00
Palette_28_6E00::
	INCLUDE "gfx/mail_server/delete_method_screen/mail_server_delete_method_bg_palette.pal"

MailServerDeleteMethod_ObjPalette:: ; 28:6E40
	INCLUDE "gfx/mail_server/delete_method_screen/mail_server_delete_method_obj_palette.pal"

; ---- words $6E80-$6EA0 (32 bytes) [PROBABLE] 2 rows of 16 bytes = 4 identical 4-byte object-table entries (ptr to frame table, ptr to script); every pointer lands on a frame-table/script start found by the sequential sweep of 6E80-7A5D (28:6E80-7A5D); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs

MailServerDeleteMethod_ObjTable:: ; 28:6E80
Table_28_6E80::
	sprite_object_entry MailServerDeleteMethod_ObjAnimData, SpriteScript_28_6EC6 ; entry 0
	sprite_object_entry MailServerDeleteMethod_ObjAnimData, SpriteScript_28_6EC6 ; entry 1
	sprite_object_entry MailServerDeleteMethod_ObjAnimData, SpriteScript_28_6EC6 ; entry 2
	sprite_object_entry MailServerDeleteMethod_ObjAnimData, SpriteScript_28_6EC6 ; entry 3
	sprite_object_entry SpriteFrameTable_28_6ECB, SpriteScript_28_6F09 ; entry 4
	sprite_object_entry SpriteFrameTable_28_6ECB, SpriteScript_28_6F09 ; entry 5
	sprite_object_entry SpriteFrameTable_28_6ECB, SpriteScript_28_6F09 ; entry 6
	sprite_object_entry SpriteFrameTable_28_6ECB, SpriteScript_28_6F09 ; entry 7

; ---- data $6EA0-$6F20 (128 bytes) [PROBABLE] 2 object record(s): 2 frame tables, 4 frames, 3 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 28:6E80-7A5D [v4: bytes 6ECB-6F12 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

MailServerDeleteMethod_ObjAnimData:: ; 28:6EA0
Data_28_6EA0::
	sprite_frame_table SpriteFrame_28_6EA4, SpriteFrame_28_6EB5
SpriteFrame_28_6EA4:: ; 28:6EA4
	sprite_frame 4
	sprite_oam -2, -2, $00, 0
	sprite_oam -2, 26, $00, OAMF_XFLIP
	sprite_oam 10, -2, $00, OAMF_YFLIP
	sprite_oam 10, 26, $00, OAMF_YFLIP | OAMF_XFLIP
SpriteFrame_28_6EB5:: ; 28:6EB5
	sprite_frame 4
	sprite_oam -3, -3, $00, 0
	sprite_oam -3, 27, $00, OAMF_XFLIP
	sprite_oam 11, -3, $00, OAMF_YFLIP
	sprite_oam 11, 27, $00, OAMF_YFLIP | OAMF_XFLIP
SpriteScript_28_6EC6:: ; 28:6EC6
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
SpriteFrameTable_28_6ECB:: ; 28:6ECB
	sprite_frame_table SpriteFrame_28_6ECF, SpriteFrame_28_6EEC
SpriteFrame_28_6ECF:: ; 28:6ECF
	sprite_frame 7
	sprite_oam 29, 19, $00, 0
	sprite_oam 29, 27, $01, 0
	sprite_oam 37, 19, $02, 0
	sprite_oam 37, 27, $03, 0
	sprite_oam 45, 19, $04, 0
	sprite_oam 45, 27, $05, 0
	sprite_oam 30, 32, $06, 0
SpriteFrame_28_6EEC:: ; 28:6EEC
	sprite_frame 7
	sprite_oam 29, 19, $00, 0
	sprite_oam 29, 27, $01, 0
	sprite_oam 37, 19, $02, 0
	sprite_oam 37, 27, $03, 0
	sprite_oam 45, 19, $04, 0
	sprite_oam 45, 27, $05, 0
	sprite_oam 29, 32, $07, 0
SpriteScript_28_6F09:: ; 28:6F09
	sprite_anim 4
	sprite_anim_step 1, 7
	sprite_anim_step 0, 7
	sprite_anim_step 1, 7
	sprite_anim_step 0, 120
	db $01, $00, $04 ; not reached by any walked sprite chain
	ds $B, $00
