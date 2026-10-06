; gfx/help/help_screens_b.asm
; bank 6A, $6716-$72BF (2985 bytes); pinned by layout.link
; help screen tilemap, tiles, palettes, object tables loaded by bank 6C

SECTION "gfx/help/help_screens_b", ROMX

; ---- data $6716-$69E6 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 6C:5A45: hl=$6716 a=$6A b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_HelpScript:: ; 6A:6716
Data_6A_6716::
	INCBIN "gfx/help/help_screens_b/tilemap_6716.tilemap"
	INCBIN "gfx/help/help_screens_b/tilemap_6716.attrmap"

; ---- gfx $69E6-$69F0 (10 bytes) [PROBABLE] tiles-2bpp: heuristic: 47 coherent tiles (hsim2=0.680 vsim2=0.789, 1 blank) parity 1; 854/864 bytes also covered by call-site blocks [clipped from 68C1-6C21 by higher-priority evidence]

Data_6A_69E6:: ; 6A:69E6
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- gfx $69F0-$6A10 (32 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:59FF: hl=$69F0 a=$6A c=$02 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_HelpScript_Tiles8000:: ; 6A:69F0
Data_6A_69F0::
	INCBIN "gfx/help/help_screens_b/tiles_69f0.2bpp"

; ---- gfx $6A10-$6A20 (16 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:5A11: hl=$6A10 a=$6A c=$01 de=$8AF1 (dest VRAM $8AF0, vbank=1)

Gfx_HelpScript_Tiles8AF0Vb1:: ; 6A:6A10
Data_6A_6A10::
	INCBIN "gfx/help/help_screens_b/tiles_6a10.2bpp"

; ---- gfx $6A20-$6E20 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:5A23: hl=$6A20 a=$6A c=$40 de=$8B01 (dest VRAM $8B00, vbank=1)

Gfx_HelpScript_Tiles8B00Vb1:: ; 6A:6A20
Data_6A_6A20::
	INCBIN "gfx/help/help_screens_b/tiles_6a20.2bpp"

; ---- gfx $6E20-$7220 (1024 bytes) [PROBABLE] 64 x 2bpp tiles (0x400, continues the 0x400 HDMA block 6A20-6E20; rendered: button glyphs "A すすむ B もどる"); no call site with hl=$6E20 found; the mapper heuristic cut it at 70A1 (parity 1) which is wrong

Tiles_6A_6E20:: ; 6A:6E20
	INCBIN "gfx/help/help_screens_b/tiles_6e20.2bpp"

; ---- data $7220-$72A0 (128 bytes) [PROBABLE] 16 palettes x 4 RGB555 words (0x80, all bit15 clear); 6C:5A2F loads hl=$7220 bc=$0040 de=$D800 then calls far 4F:4000; first 0x10 bytes read in 12/18 scenarios

Palette_HelpScript_Bg:: ; 6A:7220
Palette_6A_7220::
	INCLUDE "gfx/help/help_screens_b/palette_7220.pal"

; ---- data $72A0-$72BB (27 bytes) [CONFIRMED] selected slot2 object chain:
; two frame pointers, two count2 OAM records, and script pairs (0,46)/(1,8).
; All 27 bytes have natural read evidence; per-byte scenario counts range 28-30.
; Existing neutral frame-table label and structured macros remain unchanged.

Data_6A_72A0:: ; 6A:72A0
	sprite_frame_table SpriteFrame_6A_72A4, SpriteFrame_6A_72AD
SpriteFrame_6A_72A4:: ; 6A:72A4
	sprite_frame 2
	sprite_oam 0, 0, $00, 0
	sprite_oam 0, 8, $01, 0
SpriteFrame_6A_72AD:: ; 6A:72AD
	sprite_frame 2
	sprite_oam 1, 0, $00, 0
	sprite_oam 1, 8, $01, 0
SpriteScript_6A_72B6:: ; 6A:72B6
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $72BB-$72BF (4 bytes) [CONFIRMED] one slot2 object-table entry
; pointing to frame table $72A0 and script $72B6. OnA/OnB/TextFinished select
; B=$80 (entry0, looping); natural InitSlot counts are 263/20, 292/11, 317/29.
; All four entry bytes read in 30 natural data scenarios; no visual role inferred.

Objects_HelpScript_Slot2:: ; 6A:72BB
Table_6A_72BB::
	sprite_object_entry Data_6A_72A0, SpriteScript_6A_72B6 ; entry 0
