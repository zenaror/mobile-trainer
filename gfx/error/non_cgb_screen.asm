; gfx/error/non_cgb_screen.asm
; bank 6B, $4000-$4C80 (3200 bytes); pinned by layout.link
; non-CGB screen tilemap and tiles

SECTION "gfx/error/non_cgb_screen", ROMX

; ---- zero $4000-$4060 (96 bytes) [HYPOTHESIS] 0x00 run of 100 bytes [clipped from 4000-4064 by higher-priority proposals]

NonCgb_Tilemap:: ; 6B:4000
	ds $60, $00

; ---- gfx $4060-$4240 (480 bytes) [CONFIRMED] 32x15 tilemap: 480 tile indices; continuation of the bytes copied to BG map $9800

NonCgb_Tilemap_Continuation_4060:: ; 6B:4060
	INCBIN "gfx/error/non_cgb_screen/tilemap_4060.tilemap"

; ---- gfx $4240-$4480 (576 bytes) [HYPOTHESIS] tiles-2bpp candidate; 36 tiles, bytes are only $00/$10, no known reader

NonCgb_CandidateTileData_4240:: ; 6B:4240
	INCBIN "gfx/error/non_cgb_screen/tiles_4240.2bpp"

; ---- gfx $4480-$4C30 (1968 bytes) [PROBABLE] 123 2bpp tiles loaded by NonCgb_ErrorScreen with the following $50 zero bytes

NonCgb_Tiles:: ; 6B:4480
	INCBIN "gfx/error/non_cgb_screen/non_cgb_tiles.2bpp"

; ---- zero $4C30-$4C80 (80 bytes) [HYPOTHESIS] 0x00 run of 82 bytes [clipped from 4C2E-4C80 by higher-priority proposals]
	ds $50, $00
