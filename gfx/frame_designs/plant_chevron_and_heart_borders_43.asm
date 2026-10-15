; gfx/frame_designs/plant_chevron_and_heart_borders_43.asm
; bank 43, $4000-$7540 (13632 bytes); pinned by layout.link
; four screen packages; no loader found

SECTION "gfx/frame_designs/plant_chevron_and_heart_borders_43", ROMX

; ---- gfx $4000-$4A00 (2560 bytes) [PROBABLE] package 1 of 4: 160 tiles (2bpp, $A00 bytes); rendered as coherent screen art (title/menu graphics: e.g. Japanese 'START MENU B' and English 'START MENU / B BACK' button tiles, digits 0-9 and ':' as the last tiles). No loader reference was found in the ROM (no ld hl/HDMA call site with bank $43), so the bounds come from the exact package tiling. bank 43 is exactly 4 identical-layout packages of $0D50 bytes each ($4000,$4D50,$5AA0,$67F0; the last ends at $7540 = start of the trailing zero padding): [160 tiles = $A00][20x18 tile map = 360][20x18 attribute map = 360][64 RGB555 words = $80]; the palette of every package begins with the same colours $7FFF,$011C,$7E02,$0000 and all 4 x 64 words have bit15 clear

Tiles_43_4000:: ; 43:4000
	INCBIN "gfx/frame_designs/plant_chevron_and_heart_borders_43/green_plant_motif_border_43_4000_tiles.2bpp"

; ---- data $4A00-$4B68 (360 bytes) [PROBABLE] package 1: 20x18 tile-id map (360 bytes, 20 bytes per row; verifier: drawn with the package's tiles, attribute map and palette it is a complete 20x18 screen (frame, fill pattern, START/B button legends), which is what validates the tile/tilemap/attrmap/palette split; the earlier 'left/right symmetric rows' remark was wrong (0/18 rows of packages 1,3,4 are symmetric) and is retracted). Tile part of the 720-byte pair that Function_00_08EA-style loaders copy (see bank 50 / 1D for the same pair layout). bank 43 is exactly 4 identical-layout packages of $0D50 bytes each ($4000,$4D50,$5AA0,$67F0; the last ends at $7540 = start of the trailing zero padding): [160 tiles = $A00][20x18 tile map = 360][20x18 attribute map = 360][64 RGB555 words = $80]; the palette of every package begins with the same colours $7FFF,$011C,$7E02,$0000 and all 4 x 64 words have bit15 clear

Tilemap_43_4A00:: ; 43:4A00
	INCBIN "gfx/frame_designs/plant_chevron_and_heart_borders_43/green_plant_motif_border_43_4000_tilemap.tilemap"

; ---- data $4B68-$4CD0 (360 bytes) [PROBABLE] package 1: 20x18 attribute map (360 bytes; palette/bank/flip bytes like $08,$09,$0A,$0B,$0C,$29), second half of the 720-byte tile+attr pair. bank 43 is exactly 4 identical-layout packages of $0D50 bytes each ($4000,$4D50,$5AA0,$67F0; the last ends at $7540 = start of the trailing zero padding): [160 tiles = $A00][20x18 tile map = 360][20x18 attribute map = 360][64 RGB555 words = $80]; the palette of every package begins with the same colours $7FFF,$011C,$7E02,$0000 and all 4 x 64 words have bit15 clear

Attrmap_43_4B68:: ; 43:4B68
	INCBIN "gfx/frame_designs/plant_chevron_and_heart_borders_43/green_plant_motif_border_43_4000_attributes.attrmap"

; ---- data $4CD0-$4D50 (128 bytes) [PROBABLE] package 1: 64 RGB555 words (16 groups of 4, bit15 clear). bank 43 is exactly 4 identical-layout packages of $0D50 bytes each ($4000,$4D50,$5AA0,$67F0; the last ends at $7540 = start of the trailing zero padding): [160 tiles = $A00][20x18 tile map = 360][20x18 attribute map = 360][64 RGB555 words = $80]; the palette of every package begins with the same colours $7FFF,$011C,$7E02,$0000 and all 4 x 64 words have bit15 clear

Palette_43_4CD0:: ; 43:4CD0
	INCLUDE "gfx/frame_designs/plant_chevron_and_heart_borders_43/green_plant_motif_border_43_4000_palettes.pal"

; ---- gfx $4D50-$5750 (2560 bytes) [PROBABLE] package 2 of 4: 160 tiles (2bpp, $A00 bytes); rendered as coherent screen art (title/menu graphics: e.g. Japanese 'START MENU B' and English 'START MENU / B BACK' button tiles, digits 0-9 and ':' as the last tiles). No loader reference was found in the ROM (no ld hl/HDMA call site with bank $43), so the bounds come from the exact package tiling. bank 43 is exactly 4 identical-layout packages of $0D50 bytes each ($4000,$4D50,$5AA0,$67F0; the last ends at $7540 = start of the trailing zero padding): [160 tiles = $A00][20x18 tile map = 360][20x18 attribute map = 360][64 RGB555 words = $80]; the palette of every package begins with the same colours $7FFF,$011C,$7E02,$0000 and all 4 x 64 words have bit15 clear

Tiles_43_4D50:: ; 43:4D50
	INCBIN "gfx/frame_designs/plant_chevron_and_heart_borders_43/blue_yellow_chevron_border_43_4d50_tiles.2bpp"

; ---- data $5750-$58B8 (360 bytes) [PROBABLE] package 2: 20x18 tile-id map (360 bytes, 20 bytes per row; verifier: drawn with the package's tiles, attribute map and palette it is a complete 20x18 screen (frame, fill pattern, START/B button legends), which is what validates the tile/tilemap/attrmap/palette split; the earlier 'left/right symmetric rows' remark was wrong (0/18 rows of packages 1,3,4 are symmetric) and is retracted). Tile part of the 720-byte pair that Function_00_08EA-style loaders copy (see bank 50 / 1D for the same pair layout). bank 43 is exactly 4 identical-layout packages of $0D50 bytes each ($4000,$4D50,$5AA0,$67F0; the last ends at $7540 = start of the trailing zero padding): [160 tiles = $A00][20x18 tile map = 360][20x18 attribute map = 360][64 RGB555 words = $80]; the palette of every package begins with the same colours $7FFF,$011C,$7E02,$0000 and all 4 x 64 words have bit15 clear

Tilemap_43_5750:: ; 43:5750
	INCBIN "gfx/frame_designs/plant_chevron_and_heart_borders_43/blue_yellow_chevron_border_43_4d50_tilemap.tilemap"

; ---- data $58B8-$5A20 (360 bytes) [PROBABLE] package 2: 20x18 attribute map (360 bytes; palette/bank/flip bytes like $08,$09,$0A,$0B,$0C,$29), second half of the 720-byte tile+attr pair. bank 43 is exactly 4 identical-layout packages of $0D50 bytes each ($4000,$4D50,$5AA0,$67F0; the last ends at $7540 = start of the trailing zero padding): [160 tiles = $A00][20x18 tile map = 360][20x18 attribute map = 360][64 RGB555 words = $80]; the palette of every package begins with the same colours $7FFF,$011C,$7E02,$0000 and all 4 x 64 words have bit15 clear

Attrmap_43_58B8:: ; 43:58B8
	INCBIN "gfx/frame_designs/plant_chevron_and_heart_borders_43/blue_yellow_chevron_border_43_4d50_attributes.attrmap"

; ---- data $5A20-$5AA0 (128 bytes) [PROBABLE] package 2: 64 RGB555 words (16 groups of 4, bit15 clear). bank 43 is exactly 4 identical-layout packages of $0D50 bytes each ($4000,$4D50,$5AA0,$67F0; the last ends at $7540 = start of the trailing zero padding): [160 tiles = $A00][20x18 tile map = 360][20x18 attribute map = 360][64 RGB555 words = $80]; the palette of every package begins with the same colours $7FFF,$011C,$7E02,$0000 and all 4 x 64 words have bit15 clear

Palette_43_5A20:: ; 43:5A20
	INCLUDE "gfx/frame_designs/plant_chevron_and_heart_borders_43/blue_yellow_chevron_border_43_4d50_palettes.pal"

; ---- gfx $5AA0-$64A0 (2560 bytes) [PROBABLE] package 3 of 4: 160 tiles (2bpp, $A00 bytes); rendered as coherent screen art (title/menu graphics: e.g. Japanese 'START MENU B' and English 'START MENU / B BACK' button tiles, digits 0-9 and ':' as the last tiles). No loader reference was found in the ROM (no ld hl/HDMA call site with bank $43), so the bounds come from the exact package tiling. bank 43 is exactly 4 identical-layout packages of $0D50 bytes each ($4000,$4D50,$5AA0,$67F0; the last ends at $7540 = start of the trailing zero padding): [160 tiles = $A00][20x18 tile map = 360][20x18 attribute map = 360][64 RGB555 words = $80]; the palette of every package begins with the same colours $7FFF,$011C,$7E02,$0000 and all 4 x 64 words have bit15 clear

Tiles_43_5AA0:: ; 43:5AA0
	INCBIN "gfx/frame_designs/plant_chevron_and_heart_borders_43/leaf_and_seed_border_43_5aa0_tiles.2bpp"

; ---- data $64A0-$6608 (360 bytes) [PROBABLE] package 3: 20x18 tile-id map (360 bytes, 20 bytes per row; verifier: drawn with the package's tiles, attribute map and palette it is a complete 20x18 screen (frame, fill pattern, START/B button legends), which is what validates the tile/tilemap/attrmap/palette split; the earlier 'left/right symmetric rows' remark was wrong (0/18 rows of packages 1,3,4 are symmetric) and is retracted). Tile part of the 720-byte pair that Function_00_08EA-style loaders copy (see bank 50 / 1D for the same pair layout). bank 43 is exactly 4 identical-layout packages of $0D50 bytes each ($4000,$4D50,$5AA0,$67F0; the last ends at $7540 = start of the trailing zero padding): [160 tiles = $A00][20x18 tile map = 360][20x18 attribute map = 360][64 RGB555 words = $80]; the palette of every package begins with the same colours $7FFF,$011C,$7E02,$0000 and all 4 x 64 words have bit15 clear

Tilemap_43_64A0:: ; 43:64A0
	INCBIN "gfx/frame_designs/plant_chevron_and_heart_borders_43/leaf_and_seed_border_43_5aa0_tilemap.tilemap"

; ---- data $6608-$6770 (360 bytes) [PROBABLE] package 3: 20x18 attribute map (360 bytes; palette/bank/flip bytes like $08,$09,$0A,$0B,$0C,$29), second half of the 720-byte tile+attr pair. bank 43 is exactly 4 identical-layout packages of $0D50 bytes each ($4000,$4D50,$5AA0,$67F0; the last ends at $7540 = start of the trailing zero padding): [160 tiles = $A00][20x18 tile map = 360][20x18 attribute map = 360][64 RGB555 words = $80]; the palette of every package begins with the same colours $7FFF,$011C,$7E02,$0000 and all 4 x 64 words have bit15 clear

Attrmap_43_6608:: ; 43:6608
	INCBIN "gfx/frame_designs/plant_chevron_and_heart_borders_43/leaf_and_seed_border_43_5aa0_attributes.attrmap"

; ---- data $6770-$67F0 (128 bytes) [PROBABLE] package 3: 64 RGB555 words (16 groups of 4, bit15 clear). bank 43 is exactly 4 identical-layout packages of $0D50 bytes each ($4000,$4D50,$5AA0,$67F0; the last ends at $7540 = start of the trailing zero padding): [160 tiles = $A00][20x18 tile map = 360][20x18 attribute map = 360][64 RGB555 words = $80]; the palette of every package begins with the same colours $7FFF,$011C,$7E02,$0000 and all 4 x 64 words have bit15 clear

Palette_43_6770:: ; 43:6770
	INCLUDE "gfx/frame_designs/plant_chevron_and_heart_borders_43/leaf_and_seed_border_43_5aa0_palettes.pal"

; ---- gfx $67F0-$71F0 (2560 bytes) [PROBABLE] package 4 of 4: 160 tiles (2bpp, $A00 bytes); rendered as coherent screen art (title/menu graphics: e.g. Japanese 'START MENU B' and English 'START MENU / B BACK' button tiles, digits 0-9 and ':' as the last tiles). No loader reference was found in the ROM (no ld hl/HDMA call site with bank $43), so the bounds come from the exact package tiling. bank 43 is exactly 4 identical-layout packages of $0D50 bytes each ($4000,$4D50,$5AA0,$67F0; the last ends at $7540 = start of the trailing zero padding): [160 tiles = $A00][20x18 tile map = 360][20x18 attribute map = 360][64 RGB555 words = $80]; the palette of every package begins with the same colours $7FFF,$011C,$7E02,$0000 and all 4 x 64 words have bit15 clear

Tiles_43_67F0:: ; 43:67F0
	INCBIN "gfx/frame_designs/plant_chevron_and_heart_borders_43/heart_and_flower_border_43_67f0_tiles.2bpp"

; ---- data $71F0-$7358 (360 bytes) [PROBABLE] package 4: 20x18 tile-id map (360 bytes, 20 bytes per row; verifier: drawn with the package's tiles, attribute map and palette it is a complete 20x18 screen (frame, fill pattern, START/B button legends), which is what validates the tile/tilemap/attrmap/palette split; the earlier 'left/right symmetric rows' remark was wrong (0/18 rows of packages 1,3,4 are symmetric) and is retracted). Tile part of the 720-byte pair that Function_00_08EA-style loaders copy (see bank 50 / 1D for the same pair layout). bank 43 is exactly 4 identical-layout packages of $0D50 bytes each ($4000,$4D50,$5AA0,$67F0; the last ends at $7540 = start of the trailing zero padding): [160 tiles = $A00][20x18 tile map = 360][20x18 attribute map = 360][64 RGB555 words = $80]; the palette of every package begins with the same colours $7FFF,$011C,$7E02,$0000 and all 4 x 64 words have bit15 clear

Tilemap_43_71F0:: ; 43:71F0
	INCBIN "gfx/frame_designs/plant_chevron_and_heart_borders_43/heart_and_flower_border_43_67f0_tilemap.tilemap"

; ---- data $7358-$74C0 (360 bytes) [PROBABLE] package 4: 20x18 attribute map (360 bytes; palette/bank/flip bytes like $08,$09,$0A,$0B,$0C,$29), second half of the 720-byte tile+attr pair. bank 43 is exactly 4 identical-layout packages of $0D50 bytes each ($4000,$4D50,$5AA0,$67F0; the last ends at $7540 = start of the trailing zero padding): [160 tiles = $A00][20x18 tile map = 360][20x18 attribute map = 360][64 RGB555 words = $80]; the palette of every package begins with the same colours $7FFF,$011C,$7E02,$0000 and all 4 x 64 words have bit15 clear

Attrmap_43_7358:: ; 43:7358
	INCBIN "gfx/frame_designs/plant_chevron_and_heart_borders_43/heart_and_flower_border_43_67f0_attributes.attrmap"

; ---- data $74C0-$7540 (128 bytes) [PROBABLE] package 4: 64 RGB555 words (16 groups of 4, bit15 clear). bank 43 is exactly 4 identical-layout packages of $0D50 bytes each ($4000,$4D50,$5AA0,$67F0; the last ends at $7540 = start of the trailing zero padding): [160 tiles = $A00][20x18 tile map = 360][20x18 attribute map = 360][64 RGB555 words = $80]; the palette of every package begins with the same colours $7FFF,$011C,$7E02,$0000 and all 4 x 64 words have bit15 clear

Palette_43_74C0:: ; 43:74C0
	INCLUDE "gfx/frame_designs/plant_chevron_and_heart_borders_43/heart_and_flower_border_43_67f0_palettes.pal"
