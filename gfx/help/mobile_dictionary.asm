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

; ---- data $5390-$53D0 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/help/mobile_dictionary.asm:54, call 1A:4072 executed 87 hits in 8 scenarios (analysis/coverage_union.tsv))

Palette_MobileDict_Bg:: ; 1A:5390
Data_1A_5390::
	INCLUDE "gfx/help/mobile_dictionary/mobile_dict_bg.pal"

; ---- data $53D0-$55A0 (464 bytes) [PROBABLE] palette-rgb555: heuristic: 232 RGB555 words as 58 palette group(s) of 4 (the rest of a heuristic block; the palette array(s) that the code reads were cut out of it)

Palette_MobileDict_Obj:: ; 1A:53D0
	INCLUDE "gfx/help/mobile_dictionary/mobile_dict_obj.pal"

; ---- data $55A0-$55DA (58 bytes) [PROBABLE] palette-rgb555: heuristic: 288 RGB555 words as 72 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance) [clipped from 539A-55DA by higher-priority evidence]

Objects_MobileDict:: ; 1A:55A0
Data_1A_55A0::
	db $10, $54, $26, $54 ; sprite object-table entry kept as db: pointer target 1A:5410 has no label
	db $2B, $54, $41, $54 ; sprite object-table entry kept as db: pointer target 1A:542B has no label
Objects_MobileDict_Entry2:: ; 1A:55A8
	db $46, $54, $61, $54 ; sprite object-table entry kept as db: pointer target 1A:5446 has no label
	db $64, $54, $7F, $54 ; sprite object-table entry kept as db: pointer target 1A:5464 has no label
	db $82, $54, $9D, $54 ; sprite object-table entry kept as db: pointer target 1A:5482 has no label
	db $A0, $54, $BB, $54 ; sprite object-table entry kept as db: pointer target 1A:54A0 has no label
	db $BE, $54, $D9, $54 ; sprite object-table entry kept as db: pointer target 1A:54BE has no label
	db $DC, $54, $F7, $54 ; sprite object-table entry kept as db: pointer target 1A:54DC has no label
	db $FA, $54, $15, $55 ; sprite object-table entry kept as db: pointer target 1A:54FA has no label
	db $18, $55, $33, $55 ; sprite object-table entry kept as db: pointer target 1A:5518 has no label
	db $36, $55, $51, $55 ; sprite object-table entry kept as db: pointer target 1A:5536 has no label
	db $54, $55, $6F, $55 ; sprite object-table entry kept as db: pointer target 1A:5554 has no label
	db $72, $55, $9D, $55 ; sprite object-table entry kept as db: pointer target 1A:5572 has no label
	db $00, $00, $00, $00, $00, $00
