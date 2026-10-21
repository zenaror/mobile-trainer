; gfx/frame_designs/metal_flame_and_creature_borders_42.asm
; bank 42, $4000-$7540 (13632 bytes); pinned by layout.link
; four screen packages; no loader found

SECTION "gfx/frame_designs/metal_flame_and_creature_borders_42", ROMX

; ---- gfx $4000-$4540 (1344 bytes) [PROBABLE] 2bpp tiles by coherence: 84 non-blank tiles, mean adjacent-pixel similarity h=0.59 v=0.57 (random data ~0.25-0.35);

FrameDesignCandidate_MetalScrewBorder_Tiles_4000:: ; 42:4000
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/metal_screw_border_42_4000_tile_fragment_0000.2bpp"

; ---- zero $4540-$4802 (706 bytes) [HYPOTHESIS] 0x00 run of 706 bytes
	; Raw byte backing for a conditional 2bpp editing view only; original purpose and HYPOTHESIS level retained.
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/metal_screw_border_42_4000_raw_4540_4560.bin"
	ds $2A2, $00

; ---- gfx $4802-$48AB (169 bytes) [HYPOTHESIS] 2bpp tiles by coherence: 10 non-blank tiles, mean adjacent-pixel similarity h=0.52 v=0.62 (random data ~0.25-0.35);

FrameDesignCandidate_MetalScrewBorder_Tiles_4802:: ; 42:4802
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/metal_screw_border_42_4000_tile_fragment_0802.2bpp"
	db $00, $00, $00, $00, $10, $3C, $24, $18, $18

; ---- zero $48AB-$4900 (85 bytes) [HYPOTHESIS] padding? run of 85 x $00 in unclassified bytes
	ds $55, $00

; ---- gfx $4900-$49B0 (176 bytes) [HYPOTHESIS] 2bpp tiles by coherence: 10 non-blank tiles, mean adjacent-pixel similarity h=0.59 v=0.67 (random data ~0.25-0.35); 11 tiles: glyphs 0-9 and : (large digits) seen when rendered

FrameDesignCandidate_MetalScrewBorder_LargeDigits_4900:: ; 42:4900
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/metal_screw_border_42_4000_tile_fragment_0900.2bpp"

; ---- zero $49B0-$4A00 (80 bytes) [HYPOTHESIS] 0x00 run of 86 bytes [clipped from 49AA-4A00 by higher-priority proposals]
	ds $50, $00

; ---- data $4A00-$4CD0 (720 bytes) [PROBABLE] tilemap+attr block of screen 1: 20x18 tile indices (360 B) then 20x18 CGB attribute bytes (360 B, all values < $10 as bank/palette attributes) = the 2x$168-byte layout that copy_tilemap_rect_pair (00:08EA, b=18 rows c=20 cols) loads for the CONFIRMED screens of banks 24/4B/5F/71; followed by a 128-byte palette block; no direct reference found (bank 42 is not named by any ld hl/ld a,bank site), so structural PROBABLE only

FrameDesignCandidate_MetalScrewBorder_Tilemap_4A00:: ; 42:4A00
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/metal_screw_border_42_4000_tilemap.tilemap"
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/metal_screw_border_42_4000_attributes.attrmap"

; ---- data $4CD0-$4D50 (128 bytes) [PROBABLE] RGB555 palette block (128 B = 8 BG + 8 OBJ palettes of 4 colours, starts with the same $7FFF,$011C,$7E02 colours in all four screens of this bank); replaces the mapper palette guess that was offset by 6/2 bytes

FrameDesignCandidate_MetalScrewBorder_Palettes_4CD0:: ; 42:4CD0
	INCLUDE "gfx/frame_designs/metal_flame_and_creature_borders_42/metal_screw_border_42_4000_palettes.pal"

; ---- gfx $4D50-$4F00 (432 bytes) [PROBABLE] 2bpp tiles by coherence: 27 non-blank tiles, mean adjacent-pixel similarity h=0.56 v=0.59 (random data ~0.25-0.35);

FrameDesignCandidate_FlameJaggedBorder_Tiles_4D50:: ; 42:4D50
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/flame_jagged_border_42_4d50_tile_fragment_0000.2bpp"

; ---- gfx $4F00-$52C0 (960 bytes) [PROBABLE] tiles-2bpp: heuristic: 56 coherent tiles (hsim2=0.656 vsim2=0.620, 1 blank) parity 0

FrameDesignCandidate_FlameJaggedBorder_Tiles_4F00:: ; 42:4F00
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/flame_jagged_border_42_4d50_tile_fragment_01b0.2bpp"

; ---- gfx $52C0-$52E0 (32 bytes) [HYPOTHESIS] 2bpp tiles by coherence: 1 non-blank tiles, mean adjacent-pixel similarity h=0.71 v=0.30 (random data ~0.25-0.35);

FrameDesignCandidate_FlameJaggedBorder_Tiles_52C0:: ; 42:52C0
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/flame_jagged_border_42_4d50_tile_fragment_0570.2bpp"

; ---- gfx $52E0-$5750 (1136 bytes) [PROBABLE] tiles-2bpp: heuristic: 47 coherent tiles (hsim2=0.582 vsim2=0.596, 20 blank) parity 0 [range trimmed from 52E0-5760 by classify_g2]

FrameDesignCandidate_FlameJaggedBorder_Tiles_52E0:: ; 42:52E0
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/flame_jagged_border_42_4d50_tile_fragment_0590.2bpp"

; ---- data $5750-$5A20 (720 bytes) [PROBABLE] tilemap+attr block of screen 2: 20x18 tile indices (360 B) then 20x18 CGB attribute bytes (360 B, all values < $10 as bank/palette attributes) = the 2x$168-byte layout that copy_tilemap_rect_pair (00:08EA, b=18 rows c=20 cols) loads for the CONFIRMED screens of banks 24/4B/5F/71; followed by a 128-byte palette block; no direct reference found (bank 42 is not named by any ld hl/ld a,bank site), so structural PROBABLE only

FrameDesignCandidate_FlameJaggedBorder_Tilemap_5750:: ; 42:5750
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/flame_jagged_border_42_4d50_tilemap.tilemap"
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/flame_jagged_border_42_4d50_attributes.attrmap"

; ---- data $5A20-$5AA0 (128 bytes) [PROBABLE] RGB555 palette block (128 B = 8 BG + 8 OBJ palettes of 4 colours, starts with the same $7FFF,$011C,$7E02 colours in all four screens of this bank); replaces the mapper palette guess that was offset by 6/2 bytes

FrameDesignCandidate_FlameJaggedBorder_Palettes_5A20:: ; 42:5A20
	INCLUDE "gfx/frame_designs/metal_flame_and_creature_borders_42/flame_jagged_border_42_4d50_palettes.pal"

; ---- gfx $5AA0-$5E5E (958 bytes) [PROBABLE] 2bpp tiles by coherence: 59 non-blank tiles, mean adjacent-pixel similarity h=0.76 v=0.63 (random data ~0.25-0.35);

FrameDesignCandidate_BlueBubbleCreatureBorder_Tiles_5AA0:: ; 42:5AA0
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/blue_bubble_creature_border_42_5aa0_tile_fragment_0000.2bpp"
	db $38, $38, $7C, $7C, $FE, $FE, $EE, $EE, $FE, $FE, $7C, $7C, $38, $38

; ---- zero $5E5E-$5E90 (50 bytes) [HYPOTHESIS] padding? run of 50 x $00 in unclassified bytes
	ds $32, $00

; ---- gfx $5E90-$5F60 (208 bytes) [HYPOTHESIS] 2bpp tiles by coherence: 13 non-blank tiles, mean adjacent-pixel similarity h=0.60 v=0.68 (random data ~0.25-0.35);

FrameDesignCandidate_BlueBubbleCreatureBorder_Tiles_5E90:: ; 42:5E90
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/blue_bubble_creature_border_42_5aa0_tile_fragment_03f0.2bpp"

; ---- zero $5F60-$5F92 (50 bytes) [HYPOTHESIS] padding? run of 50 x $00 in unclassified bytes
	ds $32, $00

; ---- gfx $5F92-$6140 (430 bytes) [PROBABLE] 2bpp tiles by coherence: 26 non-blank tiles, mean adjacent-pixel similarity h=0.71 v=0.66 (random data ~0.25-0.35);

FrameDesignCandidate_BlueBubbleCreatureBorder_Tiles_5F92:: ; 42:5F92
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/blue_bubble_creature_border_42_5aa0_tile_fragment_04f2.2bpp"
	db $FF, $B5, $FF, $B5, $FF, $A5, $FF, $BD, $FF, $C3, $FF, $FF, $FF, $FF

; ---- zero $6140-$62A0 (352 bytes) [HYPOTHESIS] padding? run of 352 x $00 in unclassified bytes
	ds $160, $00

; ---- gfx $62A0-$634A (170 bytes) [HYPOTHESIS] 2bpp tiles by coherence: 10 non-blank tiles, mean adjacent-pixel similarity h=0.48 v=0.62 (random data ~0.25-0.35);

FrameDesignCandidate_BlueBubbleCreatureBorder_Tiles_62A0:: ; 42:62A0
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/blue_bubble_creature_border_42_5aa0_tile_fragment_0800.2bpp"
	db $00, $00, $00, $00, $10, $18, $18, $10, $08, $10

; ---- zero $634A-$63A0 (86 bytes) [HYPOTHESIS] 0x00 run of 86 bytes
	ds $56, $00

; ---- gfx $63A0-$63B0 (16 bytes) [HYPOTHESIS] 2bpp tiles (too few non-blank tiles to score);

FrameDesignCandidate_BlueBubbleCreatureBorder_Tiles_63A0:: ; 42:63A0
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/blue_bubble_creature_border_42_5aa0_tile_fragment_0900.2bpp"

; ---- gfx $63B0-$64A0 (240 bytes) [PROBABLE] tiles-2bpp: heuristic: 47 coherent tiles (hsim2=0.620 vsim2=0.850, 5 blank) parity 0 [range trimmed from 63B0-6740 by classify_g2]

FrameDesignCandidate_BlueBubbleCreatureBorder_Tiles_63B0:: ; 42:63B0
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/blue_bubble_creature_border_42_5aa0_tile_fragment_0910.2bpp"

; ---- data $64A0-$6770 (720 bytes) [PROBABLE] tilemap+attr block of screen 3: 20x18 tile indices (360 B) then 20x18 CGB attribute bytes (360 B; values $01,$08-$0B,$2A,$2B: valid CGB attribute bits, palette 0-3, tile bank 1 and, for $2A/$2B, X-flip - NOT all < $10 as the other three screens) = the 2x$168-byte layout that copy_tilemap_rect_pair (00:08EA, b=18 rows c=20 cols) loads for the CONFIRMED screens of banks 24/4B/5F/71; followed by a 128-byte palette block; no direct reference found (bank 42 is not named by any ld hl/ld a,bank site), so structural PROBABLE only

FrameDesignCandidate_BlueBubbleCreatureBorder_Tilemap_64A0:: ; 42:64A0
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/blue_bubble_creature_border_42_5aa0_tilemap.tilemap"
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/blue_bubble_creature_border_42_5aa0_attributes.attrmap"

; ---- data $6770-$67F0 (128 bytes) [PROBABLE] RGB555 palette block (128 B = 8 BG + 8 OBJ palettes of 4 colours, starts with the same $7FFF,$011C,$7E02 colours in all four screens of this bank); replaces the mapper palette guess that was offset by 6/2 bytes

FrameDesignCandidate_BlueBubbleCreatureBorder_Palettes_6770:: ; 42:6770
	INCLUDE "gfx/frame_designs/metal_flame_and_creature_borders_42/blue_bubble_creature_border_42_5aa0_palettes.pal"

; ---- gfx $67F0-$6800 (16 bytes) [HYPOTHESIS] one 2bpp tile ($FF,$00 x8 = two-colour stripes) directly after the palette block; the old mapper palette region wrongly extended over it

FrameDesignCandidate_OrangeDoubleLineBorder_Tiles_67F0:: ; 42:67F0
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/orange_double_line_border_42_67f0_tile_fragment_0000.2bpp"

; ---- zero $6800-$6810 (16 bytes) [HYPOTHESIS] padding? run of 16 x $00 in unclassified bytes
	; Raw byte backing for a conditional 2bpp editing view only; original purpose and HYPOTHESIS level retained.
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/orange_double_line_border_42_67f0_raw_6800_6810.bin"

; ---- gfx $6810-$69A0 (400 bytes) [PROBABLE] 2bpp tiles by coherence: 25 non-blank tiles, mean adjacent-pixel similarity h=0.60 v=0.60 (random data ~0.25-0.35);

FrameDesignCandidate_OrangeDoubleLineBorder_Tiles_6810:: ; 42:6810
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/orange_double_line_border_42_67f0_tile_fragment_0020.2bpp"

; ---- data $69A0-$69B0 (16 bytes) [HYPOTHESIS] run of 16 x $FF (padding?) in unclassified bytes

FrameDesignCandidate_OrangeDoubleLineBorder_RawBacking_69A0:: ; 42:69A0
	; Raw byte backing for a conditional 2bpp editing view only; original purpose and HYPOTHESIS level retained.
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/orange_double_line_border_42_67f0_raw_69a0_69b0.bin"

; ---- gfx $69B0-$6CC0 (784 bytes) [HYPOTHESIS] 2bpp tiles by coherence: 49 non-blank tiles, mean adjacent-pixel similarity h=0.56 v=0.47 (random data ~0.25-0.35);

FrameDesignCandidate_OrangeDoubleLineBorder_Tiles_69B0:: ; 42:69B0
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/orange_double_line_border_42_67f0_tile_fragment_01c0.2bpp"

; ---- zero $6CC0-$6FF2 (818 bytes) [HYPOTHESIS] 0x00 run of 818 bytes
	; Raw byte backing for a conditional 2bpp editing view only; original purpose and HYPOTHESIS level retained.
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/orange_double_line_border_42_67f0_raw_6cc0_6cd0.bin"
	ds $322, $00

; ---- gfx $6FF2-$709E (172 bytes) [HYPOTHESIS] 2bpp tiles by coherence: 10 non-blank tiles, mean adjacent-pixel similarity h=0.49 v=0.61 (random data ~0.25-0.35);

FrameDesignCandidate_OrangeDoubleLineBorder_Tiles_6FF2:: ; 42:6FF2
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/orange_double_line_border_42_67f0_tile_fragment_0802.2bpp"
	db $00, $00, $00, $00, $18, $04, $14, $0C, $14, $0C, $1C, $1C

; ---- zero $709E-$70F0 (82 bytes) [HYPOTHESIS] 0x00 run of 82 bytes
	ds $52, $00

; ---- gfx $70F0-$719C (172 bytes) [HYPOTHESIS] 2bpp tiles by coherence: 10 non-blank tiles, mean adjacent-pixel similarity h=0.56 v=0.59 (random data ~0.25-0.35);

FrameDesignCandidate_OrangeDoubleLineBorder_Tiles_70F0:: ; 42:70F0
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/orange_double_line_border_42_67f0_tile_fragment_0900.2bpp"
	db $00, $00, $00, $00, $18, $04, $14, $0C, $14, $0C, $1C, $1C

; ---- zero $719C-$71F0 (84 bytes) [HYPOTHESIS] padding? run of 86 x $00 in unclassified bytes
	ds $54, $00

; ---- data $71F0-$74C0 (720 bytes) [PROBABLE] tilemap+attr block of screen 4: 20x18 tile indices (360 B) then 20x18 CGB attribute bytes (360 B, all values < $10 as bank/palette attributes) = the 2x$168-byte layout that copy_tilemap_rect_pair (00:08EA, b=18 rows c=20 cols) loads for the CONFIRMED screens of banks 24/4B/5F/71; followed by a 128-byte palette block; no direct reference found (bank 42 is not named by any ld hl/ld a,bank site), so structural PROBABLE only

FrameDesignCandidate_OrangeDoubleLineBorder_Tilemap_71F0:: ; 42:71F0
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/orange_double_line_border_42_67f0_tilemap.tilemap"
	INCBIN "gfx/frame_designs/metal_flame_and_creature_borders_42/orange_double_line_border_42_67f0_attributes.attrmap"

; ---- data $74C0-$7540 (128 bytes) [PROBABLE] RGB555 palette block (128 B = 8 BG + 8 OBJ palettes of 4 colours, starts with the same $7FFF,$011C,$7E02 colours in all four screens of this bank); replaces the mapper palette guess that was offset by 6/2 bytes

FrameDesignCandidate_OrangeDoubleLineBorder_Palettes_74C0:: ; 42:74C0
	INCLUDE "gfx/frame_designs/metal_flame_and_creature_borders_42/orange_double_line_border_42_67f0_palettes.pal"
