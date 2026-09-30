; gfx/error/non_cgb_screen.asm
; bank 6B, $4000-$4C80 (3200 bytes); pinned by layout.link
; non-CGB screen tilemap and tiles

SECTION "gfx/error/non_cgb_screen", ROMX

; ---- zero $4000-$4060 (96 bytes) [HYPOTHESIS] 0x00 run of 100 bytes [clipped from 4000-4064 by higher-priority proposals]

NonCgb_Tilemap:: ; 6B:4000
	ds $60, $00

; ---- gfx $4060-$4C30 (3024 bytes) [PROBABLE] tiles-2bpp: heuristic: 154 coherent tiles (hsim2=0.792 vsim2=0.865, 33 blank) parity 0

Data_6B_4060:: ; 6B:4060
	INCBIN "gfx/error/non_cgb_screen/tiles_4060.2bpp"

NonCgb_Tiles:: ; 6B:4480
	INCBIN "gfx/error/non_cgb_screen/non_cgb_tiles.2bpp"

; ---- zero $4C30-$4C80 (80 bytes) [HYPOTHESIS] 0x00 run of 82 bytes [clipped from 4C2E-4C80 by higher-priority proposals]
	ds $50, $00
