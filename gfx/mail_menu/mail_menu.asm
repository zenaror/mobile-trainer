; gfx/mail_menu/mail_menu.asm
; bank 1D, $45C1-$63BA (7673 bytes); pinned by layout.link
; mail menu tilemaps, attribute maps, tiles, palettes, and animated icon

SECTION "gfx/mail_menu/mail_menu", ROMX

; ---- data $45C1-$4891 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 1D:40CC: hl=$45C1 a=$1D b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_MailMenu_Screen:: ; 1D:45C1

	INCBIN "gfx/mail_menu/mail_menu/mail_menu_screen.tilemap"
	INCBIN "gfx/mail_menu/mail_menu/mail_menu_screen.attrmap"

; ---- data $4891-$4981 (240 bytes) [PROBABLE] 10 columns x 24 rows tile-id map (tiles half of a 240+240 byte pair). base $4891 is base loaded by 'ld hl,$4891' at 1D:42E1 (then + index, ld c,$0A); executed reads in mail_*/monkey traces walk it in 10-byte rows (e.g. 4963-49C7). Attribute half follows at 4981. Covers the former unresolved span 4945-4963 (3 map rows).

Tilemap_MailMenu_PlatesNormal:: ; 1D:4891

	INCBIN "gfx/mail_menu/mail_menu/mail_menu_plates_normal.tilemap"

; ---- data $4981-$4A71 (240 bytes) [PROBABLE] attribute half (10x24) paired with Tilemap_MailMenu_PlatesNormal: values 01/02/09/29 (CGB BG attributes: palette 1/2/1, xflip 0x20); executed reads begin exactly at 4981 in mail_/monkey traces

Attrmap_MailMenu_PlatesNormal:: ; 1D:4981

	INCBIN "gfx/mail_menu/mail_menu/mail_menu_plates_normal.attrmap"

; ---- data $4A71-$4B61 (240 bytes) [PROBABLE] 10x24 tile-id map (frame border 36 37.. 36 in first row); base loaded by 'ld hl,$4A71' at 1D:4357 (+ index, ld c,$0A); executed reads in 10-byte rows from 4A71. the former unresolved span 4A35-4A53 belongs to the preceding attr map, see Attrmap_MailMenu_PlatesNormal

Tilemap_MailMenu_PlatesSelected:: ; 1D:4A71

	INCBIN "gfx/mail_menu/mail_menu/mail_menu_plates_selected.tilemap"

; ---- data $4B61-$4C51 (240 bytes) [PROBABLE] attribute half (10x24) paired with Tilemap_MailMenu_PlatesSelected; executed reads begin at 4B61

Attrmap_MailMenu_PlatesSelected:: ; 1D:4B61

	INCBIN "gfx/mail_menu/mail_menu/mail_menu_plates_selected.attrmap"

; ---- data $4C51-$4CB1 (96 bytes) [PROBABLE] tile-id map half of a 96+96 byte pair loaded at 1D:43BC 'ld hl,$4C51' (with 'ld bc,$0608 ; ld de,$D0C1') then Tilemap_CopyRectAndAttrPtr (far); executed reads at 4C51-4D11 and second halves 4C81-4CB1 / 4CE1-4D11 (48 bytes each)

Tilemap_MailMenu_IconFrames:: ; 1D:4C51

	INCBIN "gfx/mail_menu/mail_menu/mail_menu_icon_frames.tilemap"

; ---- data $4CB1-$4D11 (96 bytes) [PROBABLE] attribute half (values 01/03/09) paired with Tilemap_MailMenu_IconFrames; ends exactly at padding 4D11

Attrmap_MailMenu_IconFrames:: ; 1D:4CB1

	INCBIN "gfx/mail_menu/mail_menu/mail_menu_icon_frames.attrmap"

; ---- zero $4D11-$4D20 (15 bytes) [PROBABLE] 15 bytes of $00 padding before the tile block loaded from 4D20
	ds $F, $00

; ---- gfx $4D20-$4EB0 (400 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1D:4050: hl=$4D20 a=$1D c=$19 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_MailMenu_Tiles8000Vb0:: ; 1D:4D20

	INCBIN "gfx/mail_menu/mail_menu/mail_menu_tiles_8000_vb0.2bpp"

; ---- gfx $4EB0-$52B0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1D:4062: hl=$4EB0 a=$1D c=$40 de=$8800 (dest VRAM $8800, vbank=0)

Gfx_MailMenu_Tiles8800Vb0:: ; 1D:4EB0

	INCBIN "gfx/mail_menu/mail_menu/mail_menu_tiles_8800_vb0.2bpp"

; ---- gfx $52B0-$56B0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1D:4074: hl=$52B0 a=$1D c=$40 de=$8C00 (dest VRAM $8C00, vbank=0)

Gfx_MailMenu_Tiles8C00Vb0:: ; 1D:52B0

	INCBIN "gfx/mail_menu/mail_menu/mail_menu_tiles_8c00_vb0.2bpp"

; ---- gfx $56B0-$5AB0 (1024 bytes) [CONFIRMED] tiles-vram: full block loads to VB0 $9000 at 1D:4086; final $80 bytes are reused by the VB1 $9000 transfer at 1D:4098.

Gfx_MailMenu_Tiles9000Vb0_SharedTail9000Vb1:: ; 1D:56B0

	INCBIN "gfx/mail_menu/mail_menu/mail_menu_tiles_9000_vb0_shared_tail_9000_vb1.2bpp"

; ---- gfx $5AB0-$5E30 (896 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1D:4098: hl=$5A30 a=$1D c=$40 de=$9001 (dest VRAM $9000, vbank=1) [clipped from 5A30-5E30 by higher-priority evidence]

Gfx_MailMenu_TileSlice9080Vb1:: ; 1D:5AB0

	INCBIN "gfx/mail_menu/mail_menu/mail_menu_tile_slice_9080_vb1.2bpp"

; ---- gfx $5E30-$6230 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1D:40AA: hl=$5E30 a=$1D c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_MailMenu_Tiles9400Vb1:: ; 1D:5E30

	INCBIN "gfx/mail_menu/mail_menu/mail_menu_tiles_9400_vb1.2bpp"

; ---- data $6230-$6270 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/menus/mail_menu.asm:79, call 1D:40BB executed 784 hits in 37 scenarios (analysis/coverage_union.tsv))

Palette_MailMenu_Bg:: ; 1D:6230

	INCLUDE "gfx/mail_menu/mail_menu/mail_menu_bg.pal"

; ---- data $6270-$62B0 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufObj (engine/menus/mail_menu.asm:97, call 1D:40F6 executed 784 hits in 37 scenarios (analysis/coverage_union.tsv))

Palette_MailMenu_Obj:: ; 1D:6270
	INCLUDE "gfx/mail_menu/mail_menu/mail_menu_obj.pal"

; ---- data $62B0-$63BA (266 bytes) [CONFIRMED] sprite structures: nine-entry frame table, nine 6-piece records and a nine-step script; the object entry at $63B6 points here and to the script at $63A3. Sprite_InitSlot at 1D:408D initializes object $80; sprite_anims.tsv records frames 0-8 with delay 8. The frames render as the animated mail-menu icon in gfx/previews/sprites/Table_MailMenu_Objects_1D_63B6.png.

SpriteFrameTable_MailMenu_Icon:: ; 1D:62B0
	sprite_frame_table SpriteFrame_MailMenu_Icon_00, SpriteFrame_MailMenu_Icon_01, SpriteFrame_MailMenu_Icon_02
	sprite_frame_table SpriteFrame_MailMenu_Icon_03, SpriteFrame_MailMenu_Icon_04, SpriteFrame_MailMenu_Icon_05
	sprite_frame_table SpriteFrame_MailMenu_Icon_06, SpriteFrame_MailMenu_Icon_07, SpriteFrame_MailMenu_Icon_08

SpriteFrame_MailMenu_Icon_00:: ; 1D:62C2
	sprite_frame 6
	sprite_oam 0, 0, $00, 0
	sprite_oam 0, 8, $01, 0
	sprite_oam 0, 16, $02, 0
	sprite_oam 8, 0, $10, 0
	sprite_oam 8, 8, $11, 0
	sprite_oam 8, 16, $12, 0
SpriteFrame_MailMenu_Icon_01:: ; 1D:62DB
	sprite_frame 6
	sprite_oam 0, 0, $03, 0
	sprite_oam 0, 8, $04, 0
	sprite_oam 0, 16, $05, 0
	sprite_oam 8, 0, $13, 0
	sprite_oam 8, 8, $14, 0
	sprite_oam 8, 16, $15, 0
SpriteFrame_MailMenu_Icon_02:: ; 1D:62F4
	sprite_frame 6
	sprite_oam 0, 0, $06, 0
	sprite_oam 0, 8, $07, 0
	sprite_oam 0, 16, $08, 0
	sprite_oam 8, 0, $16, 0
	sprite_oam 8, 8, $17, 0
	sprite_oam 8, 16, $18, 0
SpriteFrame_MailMenu_Icon_03:: ; 1D:630D
	sprite_frame 6
	sprite_oam -16, 16, $00, 0
	sprite_oam -16, 24, $01, 0
	sprite_oam -16, 32, $02, 0
	sprite_oam -8, 16, $10, 0
	sprite_oam -8, 24, $11, 0
	sprite_oam -8, 32, $12, 0
SpriteFrame_MailMenu_Icon_04:: ; 1D:6326
	sprite_frame 6
	sprite_oam -14, 20, $03, 0
	sprite_oam -14, 28, $04, 0
	sprite_oam -14, 36, $05, 0
	sprite_oam -6, 20, $13, 0
	sprite_oam -6, 28, $14, 0
	sprite_oam -6, 36, $15, 0
SpriteFrame_MailMenu_Icon_05:: ; 1D:633F
	sprite_frame 6
	sprite_oam -16, 24, $06, 0
	sprite_oam -16, 32, $07, 0
	sprite_oam -16, 40, $08, 0
	sprite_oam -8, 24, $16, 0
	sprite_oam -8, 32, $17, 0
	sprite_oam -8, 40, $18, 0
SpriteFrame_MailMenu_Icon_06:: ; 1D:6358
	sprite_frame 6
	sprite_oam -14, 28, $00, 0
	sprite_oam -14, 36, $01, 0
	sprite_oam -14, 44, $02, 0
	sprite_oam -6, 28, $10, 0
	sprite_oam -6, 36, $11, 0
	sprite_oam -6, 44, $12, 0
SpriteFrame_MailMenu_Icon_07:: ; 1D:6371
	sprite_frame 6
	sprite_oam -16, 32, $03, 0
	sprite_oam -16, 40, $04, 0
	sprite_oam -16, 48, $05, 0
	sprite_oam -8, 32, $13, 0
	sprite_oam -8, 40, $14, 0
	sprite_oam -8, 48, $15, 0
SpriteFrame_MailMenu_Icon_08:: ; 1D:638A
	sprite_frame 6
	sprite_oam -14, 36, $06, 0
	sprite_oam -14, 44, $07, 0
	sprite_oam -14, 52, $08, 0
	sprite_oam -6, 36, $16, 0
	sprite_oam -6, 44, $17, 0
	sprite_oam -6, 52, $18, 0
SpriteScript_MailMenu_Icon:: ; 1D:63A3
	sprite_anim 9
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
	sprite_anim_step 2, 8
	sprite_anim_step 3, 8
	sprite_anim_step 4, 8
	sprite_anim_step 5, 8
	sprite_anim_step 6, 8
	sprite_anim_step 7, 8
	sprite_anim_step 8, 8
Table_MailMenu_Objects:: ; 1D:63B6
	sprite_object_entry SpriteFrameTable_MailMenu_Icon, SpriteScript_MailMenu_Icon ; entry 0
