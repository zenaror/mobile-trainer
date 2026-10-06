; gfx/dialog/dialog_window.asm
; bank 72, $48C0-$502B (1899 bytes); pinned by layout.link
; dialog window tiles, maps, palettes, cursor object table

SECTION "gfx/dialog/dialog_window", ROMX

; ---- gfx $48C0-$4CC0 (1024 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (72:4069 72:41F0); first: hdma_rom_to_vram at 72:4069: hl=$48C0 a=$72 c=$40 de=$8801 (dest VRAM $8800, vbank=1)

Dialog_WindowTiles:: ; 72:48C0
Data_72_48C0::
	INCBIN "gfx/dialog/dialog_window/dialog_window_tiles.2bpp"

; ---- data $4CC0-$4E28 (360 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 72:408B: hl=$4CC0 a=$72 b=9 rows c=20 cols (tiles then attrs) de=$D180

Dialog_WindowMap:: ; 72:4CC0
Data_72_4CC0::
	INCBIN "gfx/dialog/dialog_window/dialog_window_map.tilemap"
	INCBIN "gfx/dialog/dialog_window/dialog_window_map.attrmap"

; ---- data $4E28-$4E40 (24 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); kind palette from the label name [clipped from 48C0-4E40 by higher-priority evidence]

Dialog_Palette:: ; 72:4E28
Data_72_4E28::
	INCLUDE "gfx/dialog/dialog_window/dialog_palette.pal"

Dialog_ObjPalette:: ; 72:4E38
	INCLUDE "gfx/dialog/dialog_window/dialog_obj_palette.pal"

; ---- words $4E40-$4E44 (4 bytes) [PROBABLE] object table entry 0 (2 words 4E48, 4E6E): table of 4-byte entries read by init_object_from_table (00:0A82, de=$4E40 a=$72 at 72:40CB and 72:4252, index B&7F = 1 executed); entry 1 (4E44, CONFIRMED read) holds the same two words; both words land on the sprite-list data at 72:4E48/4E6E

Dialog_CursorObjTable:: ; 72:4E40
Table_72_4E40::
	sprite_object_entry SpriteFrameTable_72_4E48, SpriteScript_72_4E6E ; entry 0

; ---- data $4E44-$4E73 (47 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown [clipped from 4E44-502B by higher-priority evidence]

Data_72_4E44:: ; 72:4E44
	sprite_object_entry SpriteFrameTable_72_4E48, SpriteScript_72_4E6E ; entry 1
SpriteFrameTable_72_4E48:: ; 72:4E48
	sprite_frame_table SpriteFrame_72_4E4C, SpriteFrame_72_4E5D
SpriteFrame_72_4E4C:: ; 72:4E4C
	sprite_frame 4
	sprite_oam -2, -2, $81, OAMF_BANK1 | 4
	sprite_oam 10, -2, $81, OAMF_YFLIP | OAMF_BANK1 | 4
	sprite_oam -2, 26, $81, OAMF_XFLIP | OAMF_BANK1 | 4
	sprite_oam 10, 26, $81, OAMF_YFLIP | OAMF_XFLIP | OAMF_BANK1 | 4
SpriteFrame_72_4E5D:: ; 72:4E5D
	sprite_frame 4
	sprite_oam -3, -3, $81, OAMF_BANK1 | 4
	sprite_oam 11, -3, $81, OAMF_YFLIP | OAMF_BANK1 | 4
	sprite_oam -3, 27, $81, OAMF_XFLIP | OAMF_BANK1 | 4
	sprite_oam 11, 27, $81, OAMF_YFLIP | OAMF_XFLIP | OAMF_BANK1 | 4
SpriteScript_72_4E6E:: ; 72:4E6E
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- data $4E73-$502B (440 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 72:4212: hl=$4E73 a=$72 b=11 rows c=20 cols (tiles then attrs) de=$D140

Dialog_WindowMapTall:: ; 72:4E73
Data_72_4E73::
	INCBIN "gfx/dialog/dialog_window/dialog_window_map_tall.tilemap"
	INCBIN "gfx/dialog/dialog_window/dialog_window_map_tall.attrmap"
