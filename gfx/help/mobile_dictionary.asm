; gfx/help/mobile_dictionary.asm
; bank 1A, $47B5-$55DA (3621 bytes); pinned by layout.link
; dictionary screen tilemap, tiles, palettes, objects

SECTION "gfx/help/mobile_dictionary", ROMX

; ---- data $47B5-$4A85 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 1A:4083: hl=$47B5 a=$1A b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_MobileDict_Screen:: ; 1A:47B5
Data_1A_47B5::
	INCBIN "gfx/help/mobile_dictionary/mobile_dict_screen.tilemap"
	INCBIN "gfx/help/mobile_dictionary/mobile_dict_screen.attrmap"

; ---- gfx $4A85-$4A90 (11 bytes) [PROBABLE] tiles-2bpp: heuristic: 69 coherent tiles (hsim2=0.685 vsim2=0.637, 0 blank) parity 1; 1205/1216 bytes also covered by call-site blocks [clipped from 4A81-4F41 by higher-priority evidence]

Data_1A_4A85:: ; 1A:4A85
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- gfx $4A90-$4C90 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1A:403D: hl=$4A90 a=$1A c=$20 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_MobileDict_Tiles0:: ; 1A:4A90
Data_1A_4A90::
	INCBIN "gfx/help/mobile_dictionary/mobile_dict_tiles0.2bpp"

; ---- gfx $4C90-$5090 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1A:404F: hl=$4C90 a=$1A c=$40 de=$8B01 (dest VRAM $8B00, vbank=1)

Gfx_MobileDict_Tiles1:: ; 1A:4C90
Data_1A_4C90::
	INCBIN "gfx/help/mobile_dictionary/mobile_dict_tiles1.2bpp"

; ---- gfx $5090-$5390 (768 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1A:4061: hl=$5090 a=$1A c=$30 de=$8F01 (dest VRAM $8F00, vbank=1)

Gfx_MobileDict_Tiles2:: ; 1A:5090
Data_1A_5090::
	INCBIN "gfx/help/mobile_dictionary/mobile_dict_tiles2.2bpp"

; ---- data $5390-$539A (10 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 4A90-5461 by higher-priority evidence]

Palette_MobileDict_Bg:: ; 1A:5390
Data_1A_5390::
	INCLUDE "gfx/help/mobile_dictionary/mobile_dict_bg.pal"

; ---- data $539A-$55A0 (518 bytes) [PROBABLE] CGB palette data (RGB555 words): heuristic: 288 RGB555 words as 72 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance) [clipped from 539A-55DA by higher-priority proposals]

Data_1A_539A:: ; 1A:539A
	INCLUDE "gfx/help/mobile_dictionary/palette_539a.pal"

Palette_MobileDict_Obj:: ; 1A:53D0
	INCLUDE "gfx/help/mobile_dictionary/mobile_dict_obj.pal"

; ---- data $55A0-$55DA (58 bytes) [PROBABLE] palette-rgb555: heuristic: 288 RGB555 words as 72 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance) [clipped from 539A-55DA by higher-priority evidence]

Objects_MobileDict:: ; 1A:55A0
Data_1A_55A0::
	db $10, $54, $26, $54, $2B, $54, $41, $54, $46, $54, $61, $54, $64, $54, $7F, $54
	db $82, $54, $9D, $54, $A0, $54, $BB, $54, $BE, $54, $D9, $54, $DC, $54, $F7, $54
	db $FA, $54, $15, $55, $18, $55, $33, $55, $36, $55, $51, $55, $54, $55, $6F, $55
	db $72, $55, $9D, $55, $00, $00, $00, $00, $00, $00
