; gfx/help/help_screens_a.asm
; bank 6A, $4000-$64B1 (9393 bytes); pinned by layout.link
; help screen tilemaps, tiles, palettes, object tables loaded by bank 6C

SECTION "gfx/help/help_screens_a", ROMX

; ---- data $4000-$42D0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 6C:40CE: hl=$4000 a=$6A b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_HelpMenu_6A_4000:: ; 6A:4000
Data_6A_4000::
	INCBIN "gfx/help/help_screens_a/tilemap_4000.tilemap"
	INCBIN "gfx/help/help_screens_a/tilemap_4000.attrmap"

; ---- data $42D0-$45A0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 6C:40F1: hl=$42D0 a=$6A b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_HelpMenu_6A_42D0:: ; 6A:42D0
Data_6A_42D0::
	INCBIN "gfx/help/help_screens_a/tilemap_42d0.tilemap"
	INCBIN "gfx/help/help_screens_a/tilemap_42d0.attrmap"

; ---- data $45A0-$4870 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 6C:410C: hl=$45A0 a=$6A b=18 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 50 hits in 4 scenarios (analysis/coverage_union.tsv)]

Tilemap_HelpMenu_6A_45A0:: ; 6A:45A0
Data_6A_45A0::
	INCBIN "gfx/help/help_screens_a/tilemap_45a0.tilemap"
	INCBIN "gfx/help/help_screens_a/tilemap_45a0.attrmap"

; ---- data $4870-$4A14 (420 bytes) [PROBABLE] 10-wide box tilemap: 21 rows x 10 tile indices (0xd2 bytes) then 21 rows x 10 attribute bytes (+0xd2); code at 6C:43DC does `ld hl,$4870` then indexes it with an offset and adds 0xd2 to reach the attribute byte (`ld bc,$00D2`/`ld a,$5A`); attribute rows mirror the tile rows (left border attr 09/19, right border 29 = X-flip); parts read by executed code in up to 3/18 scenarios

Tilemap_6A_4870:: ; 6A:4870
	INCBIN "gfx/help/help_screens_a/tilemap_4870.tilemap"
	INCBIN "gfx/help/help_screens_a/tilemap_4870.attrmap"

; ---- data $4A14-$4AC8 (180 bytes) [PROBABLE] 10-wide box tilemap: 9 rows x 10 tile indices (0x5a bytes) then 9 rows x 10 attribute bytes (+0x5a); code at 6C:446D does `ld hl,$4A14` then indexes it with an offset and adds 0x5a to reach the attribute byte (`ld bc,$00D2`/`ld a,$5A`); attribute rows mirror the tile rows (left border attr 09/19, right border 29 = X-flip); parts read by executed code in up to 3/18 scenarios

Tilemap_6A_4A14:: ; 6A:4A14
	INCBIN "gfx/help/help_screens_a/tilemap_4a14.tilemap"
	INCBIN "gfx/help/help_screens_a/tilemap_4a14.attrmap"

; ---- data $4AC8-$4B7C (180 bytes) [PROBABLE] 10-wide box tilemap: 9 rows x 10 tile indices (0x5a bytes) then 9 rows x 10 attribute bytes (+0x5a); code at 6C:44FA does `ld hl,$4AC8` then indexes it with an offset and adds 0x5a to reach the attribute byte (`ld bc,$00D2`/`ld a,$5A`); attribute rows mirror the tile rows (left border attr 09/19, right border 29 = X-flip); parts read by executed code in up to 3/18 scenarios

Tilemap_6A_4AC8:: ; 6A:4AC8
	INCBIN "gfx/help/help_screens_a/tilemap_4ac8.tilemap"
	INCBIN "gfx/help/help_screens_a/tilemap_4ac8.attrmap"

; ---- data $4B7C-$4D20 (420 bytes) [PROBABLE] 10-wide box tilemap: 21 rows x 10 tile indices (0xd2 bytes) then 21 rows x 10 attribute bytes (+0xd2); code at 6C:45FE does `ld hl,$4B7C` then indexes it with an offset and adds 0xd2 to reach the attribute byte (`ld bc,$00D2`/`ld a,$5A`); attribute rows mirror the tile rows (left border attr 09/19, right border 29 = X-flip); parts read by executed code in up to 3/18 scenarios

Tilemap_6A_4B7C:: ; 6A:4B7C
	INCBIN "gfx/help/help_screens_a/tilemap_4b7c.tilemap"
	INCBIN "gfx/help/help_screens_a/tilemap_4b7c.attrmap"

; ---- data $4D20-$4DD4 (180 bytes) [PROBABLE] 10-wide box tilemap: 9 rows x 10 tile indices (0x5a bytes) then 9 rows x 10 attribute bytes (+0x5a); code at 6C:468F does `ld hl,$4D20` then indexes it with an offset and adds 0x5a to reach the attribute byte (`ld bc,$00D2`/`ld a,$5A`); attribute rows mirror the tile rows (left border attr 09/19, right border 29 = X-flip); parts read by executed code in up to 3/18 scenarios

Tilemap_6A_4D20:: ; 6A:4D20
	INCBIN "gfx/help/help_screens_a/tilemap_4d20.tilemap"
	INCBIN "gfx/help/help_screens_a/tilemap_4d20.attrmap"

; ---- data $4DD4-$4E88 (180 bytes) [PROBABLE] 10-wide box tilemap: 9 rows x 10 tile indices (0x5a bytes) then 9 rows x 10 attribute bytes (+0x5a); code at 6C:471C does `ld hl,$4DD4` then indexes it with an offset and adds 0x5a to reach the attribute byte (`ld bc,$00D2`/`ld a,$5A`); attribute rows mirror the tile rows (left border attr 09/19, right border 29 = X-flip); parts read by executed code in up to 3/18 scenarios

Tilemap_6A_4DD4:: ; 6A:4DD4
	INCBIN "gfx/help/help_screens_a/tilemap_4dd4.tilemap"
	INCBIN "gfx/help/help_screens_a/tilemap_4dd4.attrmap"

; ---- zero $4E88-$4E90 (8 bytes) [PROBABLE] 8 zero bytes (padding before the tile block at 4E90)
	ds $8, $00

; ---- gfx $4E90-$5290 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:4047: hl=$4E90 a=$6A c=$40 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_HelpMenu_Tiles8000:: ; 6A:4E90
Data_6A_4E90::
	INCBIN "gfx/help/help_screens_a/tiles_4e90.2bpp"

; ---- gfx $5290-$5690 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:4059: hl=$5290 a=$6A c=$40 de=$8800 (dest VRAM $8800, vbank=0)

Gfx_HelpMenu_Tiles8800:: ; 6A:5290
Data_6A_5290::
	INCBIN "gfx/help/help_screens_a/tiles_5290.2bpp"

; ---- gfx $5690-$5A90 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:406B: hl=$5690 a=$6A c=$40 de=$8C00 (dest VRAM $8C00, vbank=0)

Gfx_HelpMenu_Tiles8C00:: ; 6A:5690
Data_6A_5690::
	INCBIN "gfx/help/help_screens_a/tiles_5690.2bpp"

; ---- gfx $5A90-$5AB0 (32 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:407D: hl=$5A90 a=$6A c=$02 de=$9000 (dest VRAM $9000, vbank=0)

Gfx_HelpMenu_Tiles9000:: ; 6A:5A90
Data_6A_5A90::
	INCBIN "gfx/help/help_screens_a/tiles_5a90.2bpp"

; ---- gfx $5AB0-$5EB0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:408F: hl=$5AB0 a=$6A c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_HelpMenu_Tiles9000Vb1:: ; 6A:5AB0
Data_6A_5AB0::
	INCBIN "gfx/help/help_screens_a/tiles_5ab0.2bpp"

; ---- gfx $5EB0-$62B0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:40A1: hl=$5EB0 a=$6A c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_HelpMenu_Tiles9400Vb1:: ; 6A:5EB0
Data_6A_5EB0::
	INCBIN "gfx/help/help_screens_a/tiles_5eb0.2bpp"

; ---- data $62B0-$62F0 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/help/help_menu.asm:82, call 6C:40B2 executed 411 hits in 12 scenarios (analysis/coverage_union.tsv))

Palette_HelpMenu_Bg:: ; 6A:62B0
Data_6A_62B0::
	INCLUDE "gfx/help/help_screens_a/help_menu_bg.pal"

; ---- data $62F0-$6330 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufObj (engine/help/help_menu.asm:139, call 6C:4143 executed 411 hits in 12 scenarios (analysis/coverage_union.tsv))

Palette_HelpMenu_Obj:: ; 6A:62F0
	INCLUDE "gfx/help/help_screens_a/help_menu_obj.pal"

; ---- data $6330-$6448 (280 bytes) [PROBABLE] palette-rgb555: heuristic: 140 RGB555 words as 35 palette group(s) of 4 (the rest of a heuristic block; the palette array(s) that the code reads were cut out of it)

Data_6A_6330:: ; 6A:6330
	INCLUDE "gfx/help/help_screens_a/palette_6330.pal"

; ---- data $6448-$64B1 (105 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown [clipped from 4E90-64BB by higher-priority evidence]

Data_6A_6448:: ; 6A:6448
	db $31, $00, $00, $F8, $0A, $00, $08, $F8, $1A, $00, $00, $10, $0A, $00, $08, $10 ; not reached by any walked sprite chain
	db $1A, $00 ; not reached by any walked sprite chain
SpriteFrame_6A_645A:: ; 6A:645A
	sprite_frame 16
	sprite_oam 0, 0, $00, 0
	sprite_oam 0, 8, $01, 0
	sprite_oam 8, 0, $10, 0
	sprite_oam 8, 8, $11, 0
	sprite_oam 16, 0, $20, 0
	sprite_oam 16, 8, $21, 0
	sprite_oam 24, 0, $30, 0
	sprite_oam 24, 8, $31, 0
	sprite_oam 0, -8, $0A, 0
	sprite_oam 8, -8, $1A, 0
	sprite_oam 0, 16, $0A, 0
	sprite_oam 8, 16, $1A, 0
	sprite_oam 4, -16, $0A, 0
	sprite_oam 12, -16, $1A, 0
	sprite_oam 4, 24, $0A, 0
	sprite_oam 12, 24, $1A, 0
SpriteScript_6A_649B:: ; 6A:649B
	sprite_anim 9
	sprite_anim_step 0, 4
	sprite_anim_step 1, 4
	sprite_anim_step 2, 4
	sprite_anim_step 3, 4
	sprite_anim_step 4, 4
	sprite_anim_step 5, 4
	sprite_anim_step 6, 6
	sprite_anim_step 7, 12
	sprite_anim_step 8, 12
Table_6A_64AE:: ; 6A:64AE
	db $30, $63, $9B ; sprite object-table entry kept as db: the item crosses the end of its block
