; gfx/help/help_screens_a.asm
; bank 6A, $4000-$64B1 (9393 bytes); pinned by layout.link
; help screen tilemaps, tiles, palettes, object tables loaded by bank 6C

SECTION "gfx/help/help_screens_a", ROMX

; ---- data $4000-$42D0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 6C:40CE: hl=$4000 a=$6A b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_HelpMenu_6A_4000:: ; 6A:4000

	INCBIN "gfx/help/help_screens_a/help_menu_page1_background.tilemap"
	INCBIN "gfx/help/help_screens_a/help_menu_page1_background.attrmap"

; ---- data $42D0-$45A0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 6C:40F1: hl=$42D0 a=$6A b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_HelpMenu_6A_42D0:: ; 6A:42D0

	INCBIN "gfx/help/help_screens_a/help_menu_page2_background.tilemap"
	INCBIN "gfx/help/help_screens_a/help_menu_page2_background.attrmap"

; ---- data $45A0-$4870 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 6C:410C: hl=$45A0 a=$6A b=18 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 50 hits in 4 scenarios (analysis/coverage_union.tsv)]

Tilemap_HelpMenu_6A_45A0:: ; 6A:45A0

	INCBIN "gfx/help/help_screens_a/help_menu_page3_background.tilemap"
	INCBIN "gfx/help/help_screens_a/help_menu_page3_background.attrmap"

; ---- data $4870-$4A14 (420 bytes) [CONFIRMED] HelpMenu page 1 normal
; item rectangles: 21 rows x 10 tile indices, then the same number of attribute bytes.
; Tilemap_CopyRectAndAttrPtr copies each packed source to WRAM7:D000/D400; fixed
; asset halves match the original bank 6A. Natural data union reads 420/420 bytes.
; Item rows: 4/3/4/3, followed by locked-item variants of 3/4 rows.

Tilemap_HelpMenu_Page1_NormalItems:: ; 6A:4870
	INCBIN "gfx/help/help_screens_a/help_menu_page1_normal_items.tilemap"
	INCBIN "gfx/help/help_screens_a/help_menu_page1_normal_items.attrmap"

; ---- data $4A14-$4AC8 (180 bytes) [CONFIRMED] HelpMenu page 2 normal
; item rectangles: 9 rows x 10 tile indices, then the same number of attribute bytes.
; Tilemap_CopyRectAndAttrPtr copies each packed source to WRAM7:D000/D400; fixed
; asset halves match the original bank 6A. Natural data union reads 180/180 bytes.
; Item rows: 3/3, followed by the locked-item2 variant of 3 rows.

Tilemap_HelpMenu_Page2_NormalItems:: ; 6A:4A14
	INCBIN "gfx/help/help_screens_a/help_menu_page2_normal_items.tilemap"
	INCBIN "gfx/help/help_screens_a/help_menu_page2_normal_items.attrmap"

; ---- data $4AC8-$4B7C (180 bytes) [CONFIRMED] HelpMenu page 3 normal
; item rectangles: 9 rows x 10 tile indices, then the same number of attribute bytes.
; Tilemap_CopyRectAndAttrPtr copies each packed source to WRAM7:D000/D400; fixed
; asset halves match the original bank 6A. Natural data union reads 180/180 bytes.
; Item rows: 3/3, followed by the locked-item2 variant of 3 rows.

Tilemap_HelpMenu_Page3_NormalItems:: ; 6A:4AC8
	INCBIN "gfx/help/help_screens_a/help_menu_page3_normal_items.tilemap"
	INCBIN "gfx/help/help_screens_a/help_menu_page3_normal_items.attrmap"

; ---- data $4B7C-$4D20 (420 bytes) [PROBABLE] HelpMenu page 1 selected
; item rectangles: 21 rows x 10 tile indices, then the same number of attribute bytes.
; Tilemap_CopyRectAndAttrPtr copies each packed source to WRAM7:D000/D400; fixed
; asset halves match the original bank 6A. Natural data union reads 360/420 bytes.
; Item rows: 4/3/4/3, followed by locked-item variants of 3/4 rows.
; Unread: $4C08-$4C26 and $4CDA-$4CF8 (locked item2); its call never ran naturally.

Tilemap_HelpMenu_Page1_SelectedItems:: ; 6A:4B7C
	INCBIN "gfx/help/help_screens_a/help_menu_page1_selected_items.tilemap"
	INCBIN "gfx/help/help_screens_a/help_menu_page1_selected_items.attrmap"

; ---- data $4D20-$4DD4 (180 bytes) [CONFIRMED] HelpMenu page 2 selected
; item rectangles: 9 rows x 10 tile indices, then the same number of attribute bytes.
; Tilemap_CopyRectAndAttrPtr copies each packed source to WRAM7:D000/D400; fixed
; asset halves match the original bank 6A. Natural data union reads 180/180 bytes.
; Item rows: 3/3, followed by the locked-item2 variant of 3 rows.

Tilemap_HelpMenu_Page2_SelectedItems:: ; 6A:4D20
	INCBIN "gfx/help/help_screens_a/help_menu_page2_selected_items.tilemap"
	INCBIN "gfx/help/help_screens_a/help_menu_page2_selected_items.attrmap"

; ---- data $4DD4-$4E88 (180 bytes) [CONFIRMED] HelpMenu page 3 selected
; item rectangles: 9 rows x 10 tile indices, then the same number of attribute bytes.
; Tilemap_CopyRectAndAttrPtr copies each packed source to WRAM7:D000/D400; fixed
; asset halves match the original bank 6A. Natural data union reads 180/180 bytes.
; Item rows: 3/3, followed by the locked-item2 variant of 3 rows.

Tilemap_HelpMenu_Page3_SelectedItems:: ; 6A:4DD4
	INCBIN "gfx/help/help_screens_a/help_menu_page3_selected_items.tilemap"
	INCBIN "gfx/help/help_screens_a/help_menu_page3_selected_items.attrmap"

; ---- zero $4E88-$4E90 (8 bytes) [PROBABLE] 8 zero bytes (padding before the tile block at 4E90)
	ds $8, $00

; ---- gfx $4E90-$5290 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:4047: hl=$4E90 a=$6A c=$40 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_HelpMenu_Tiles8000:: ; 6A:4E90

	INCBIN "gfx/help/help_screens_a/help_menu_vram8000_vb0_tiles.2bpp"

; ---- gfx $5290-$5690 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:4059: hl=$5290 a=$6A c=$40 de=$8800 (dest VRAM $8800, vbank=0)

Gfx_HelpMenu_Tiles8800:: ; 6A:5290

	INCBIN "gfx/help/help_screens_a/help_menu_vram8800_vb0_tiles.2bpp"

; ---- gfx $5690-$5A90 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:406B: hl=$5690 a=$6A c=$40 de=$8C00 (dest VRAM $8C00, vbank=0)

Gfx_HelpMenu_Tiles8C00:: ; 6A:5690

	INCBIN "gfx/help/help_screens_a/help_menu_vram8c00_vb0_tiles.2bpp"

; ---- gfx $5A90-$5AB0 (32 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:407D: hl=$5A90 a=$6A c=$02 de=$9000 (dest VRAM $9000, vbank=0)

Gfx_HelpMenu_Tiles9000:: ; 6A:5A90

	INCBIN "gfx/help/help_screens_a/help_menu_vram9000_vb0_tiles.2bpp"

; ---- gfx $5AB0-$5EB0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:408F: hl=$5AB0 a=$6A c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_HelpMenu_Tiles9000Vb1:: ; 6A:5AB0

	INCBIN "gfx/help/help_screens_a/help_menu_vram9000_vb1_tiles.2bpp"

; ---- gfx $5EB0-$62B0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:40A1: hl=$5EB0 a=$6A c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_HelpMenu_Tiles9400Vb1:: ; 6A:5EB0

	INCBIN "gfx/help/help_screens_a/help_menu_vram9400_vb1_tiles.2bpp"

; ---- data $62B0-$62F0 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/help/help_menu.asm:82, call 6C:40B2 executed 411 hits in 12 scenarios (analysis/coverage_union.tsv))

Palette_HelpMenu_Bg:: ; 6A:62B0

	INCLUDE "gfx/help/help_screens_a/help_menu_bg.pal"

; ---- data $62F0-$6330 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufObj (engine/help/help_menu.asm:139, call 6C:4143 executed 411 hits in 12 scenarios (analysis/coverage_union.tsv))

Palette_HelpMenu_Obj:: ; 6A:62F0
	INCLUDE "gfx/help/help_screens_a/help_menu_obj.pal"

; ---- object animation data $6330-$64AE (382 bytes) [CONFIRMED]; nine frame pointers,
; nine OAM records and their nine-step script. The object entry is split across owners.

; Bank 6A: CONFIRMED help-menu object data, 6A:6330-64AE (382 bytes).
; Object entry at 64AE points here and to the animation script at 649B.
; Frame records use the shared sprite macros; all labels stay in bank 6A.
SpriteFrameTable_HelpMenu:: ; 6A:6330
	sprite_frame_table SpriteFrame_HelpMenu_00, SpriteFrame_HelpMenu_01, SpriteFrame_HelpMenu_02, SpriteFrame_HelpMenu_03, SpriteFrame_HelpMenu_04, SpriteFrame_HelpMenu_05, SpriteFrame_HelpMenu_06, SpriteFrame_HelpMenu_07, SpriteFrame_HelpMenu_08

; ---- OAM frame 00, 8 pieces, 6342-6363 [CONFIRMED]
SpriteFrame_HelpMenu_00:: ; 6A:6342
	sprite_frame 8
	sprite_oam 0, 0, $00, $00
	sprite_oam 0, 8, $01, $00
	sprite_oam 8, 0, $10, $00
	sprite_oam 8, 8, $11, $00
	sprite_oam 16, 0, $20, $00
	sprite_oam 16, 8, $21, $00
	sprite_oam 24, 0, $30, $00
	sprite_oam 24, 8, $31, $00

; ---- OAM frame 01, 8 pieces, 6363-6384 [CONFIRMED]
SpriteFrame_HelpMenu_01:: ; 6A:6363
	sprite_frame 8
	sprite_oam 0, 0, $02, $00
	sprite_oam 0, 8, $03, $00
	sprite_oam 8, 0, $12, $00
	sprite_oam 8, 8, $13, $00
	sprite_oam 16, 0, $22, $00
	sprite_oam 16, 8, $23, $00
	sprite_oam 24, 0, $32, $00
	sprite_oam 24, 8, $33, $00

; ---- OAM frame 02, 8 pieces, 6384-63A5 [CONFIRMED]
SpriteFrame_HelpMenu_02:: ; 6A:6384
	sprite_frame 8
	sprite_oam 0, 0, $04, $00
	sprite_oam 0, 8, $05, $00
	sprite_oam 8, 0, $14, $00
	sprite_oam 8, 8, $15, $00
	sprite_oam 16, 0, $24, $00
	sprite_oam 16, 8, $25, $00
	sprite_oam 24, 0, $34, $00
	sprite_oam 24, 8, $35, $00

; ---- OAM frame 03, 8 pieces, 63A5-63C6 [CONFIRMED]
SpriteFrame_HelpMenu_03:: ; 6A:63A5
	sprite_frame 8
	sprite_oam 0, 0, $06, $00
	sprite_oam 0, 8, $07, $00
	sprite_oam 8, 0, $16, $00
	sprite_oam 8, 8, $17, $00
	sprite_oam 16, 0, $26, $00
	sprite_oam 16, 8, $27, $00
	sprite_oam 24, 0, $36, $00
	sprite_oam 24, 8, $37, $00

; ---- OAM frame 04, 8 pieces, 63C6-63E7 [CONFIRMED]
SpriteFrame_HelpMenu_04:: ; 6A:63C6
	sprite_frame 8
	sprite_oam 0, 0, $02, $00
	sprite_oam 0, 8, $03, $00
	sprite_oam 8, 0, $12, $00
	sprite_oam 8, 8, $13, $00
	sprite_oam 16, 0, $22, $00
	sprite_oam 16, 8, $23, $00
	sprite_oam 24, 0, $32, $00
	sprite_oam 24, 8, $33, $00

; ---- OAM frame 05, 8 pieces, 63E7-6408 [CONFIRMED]
SpriteFrame_HelpMenu_05:: ; 6A:63E7
	sprite_frame 8
	sprite_oam 0, 0, $08, $00
	sprite_oam 0, 8, $09, $00
	sprite_oam 8, 0, $18, $00
	sprite_oam 8, 8, $19, $00
	sprite_oam 16, 0, $28, $00
	sprite_oam 16, 8, $29, $00
	sprite_oam 24, 0, $38, $00
	sprite_oam 24, 8, $39, $00

; ---- OAM frame 06, 8 pieces, 6408-6429 [CONFIRMED]
SpriteFrame_HelpMenu_06:: ; 6A:6408
	sprite_frame 8
	sprite_oam 0, 0, $00, $00
	sprite_oam 0, 8, $01, $00
	sprite_oam 8, 0, $10, $00
	sprite_oam 8, 8, $11, $00
	sprite_oam 16, 0, $20, $00
	sprite_oam 16, 8, $21, $00
	sprite_oam 24, 0, $30, $00
	sprite_oam 24, 8, $31, $00

; ---- OAM frame 07, 12 pieces, 6429-645A [CONFIRMED]
SpriteFrame_HelpMenu_07:: ; 6A:6429
	sprite_frame 12
	sprite_oam 0, 0, $00, $00
	sprite_oam 0, 8, $01, $00
	sprite_oam 8, 0, $10, $00
	sprite_oam 8, 8, $11, $00
	sprite_oam 16, 0, $20, $00
	sprite_oam 16, 8, $21, $00
	sprite_oam 24, 0, $30, $00
	sprite_oam 24, 8, $31, $00
	sprite_oam 0, -8, $0A, $00
	sprite_oam 8, -8, $1A, $00
	sprite_oam 0, 16, $0A, $00
	sprite_oam 8, 16, $1A, $00

; ---- OAM frame 08, 16 pieces, 645A-649B [CONFIRMED]
SpriteFrame_HelpMenu_08:: ; 6A:645A
	sprite_frame 16
	sprite_oam 0, 0, $00, $00
	sprite_oam 0, 8, $01, $00
	sprite_oam 8, 0, $10, $00
	sprite_oam 8, 8, $11, $00
	sprite_oam 16, 0, $20, $00
	sprite_oam 16, 8, $21, $00
	sprite_oam 24, 0, $30, $00
	sprite_oam 24, 8, $31, $00
	sprite_oam 0, -8, $0A, $00
	sprite_oam 8, -8, $1A, $00
	sprite_oam 0, 16, $0A, $00
	sprite_oam 8, 16, $1A, $00
	sprite_oam 4, -16, $0A, $00
	sprite_oam 12, -16, $1A, $00
	sprite_oam 4, 24, $0A, $00
	sprite_oam 12, 24, $1A, $00

; ---- animation script, nine indexed steps, 649B-64AE [CONFIRMED]
SpriteScript_HelpMenu:: ; 6A:649B
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

; [CONFIRMED] logical four-byte object entry $6330/$649B at $64AE-$64B2.
; Its low three bytes are here; the script pointer high byte and ticker bank follow at
; 6A:$64B1 in data/text/help_menu_ticker.asm. All four bytes are naturally read.
Objects_HelpMenu:: ; 6A:64AE
	db LOW(SpriteFrameTable_HelpMenu), HIGH(SpriteFrameTable_HelpMenu), LOW(SpriteScript_HelpMenu)
