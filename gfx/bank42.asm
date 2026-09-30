; gfx/bank42.asm
; bank 42, $4000-$7540 (13632 bytes); pinned by layout.link
; four screen packages; no loader found

SECTION "gfx/bank42", ROMX

; ---- gfx $4000-$4540 (1344 bytes) [PROBABLE] 2bpp tiles by coherence: 84 non-blank tiles, mean adjacent-pixel similarity h=0.59 v=0.57 (random data ~0.25-0.35);

Tiles_42_4000:: ; 42:4000
	INCBIN "gfx/bank42/tiles_4000.2bpp"

; ---- zero $4540-$4802 (706 bytes) [HYPOTHESIS] 0x00 run of 706 bytes
	ds $2C2, $00

; ---- gfx $4802-$48AB (169 bytes) [HYPOTHESIS] 2bpp tiles by coherence: 10 non-blank tiles, mean adjacent-pixel similarity h=0.52 v=0.62 (random data ~0.25-0.35);

Data_42_4802:: ; 42:4802
	INCBIN "gfx/bank42/tiles_4802.2bpp"
	db $00, $00, $00, $00, $10, $3C, $24, $18, $18

; ---- zero $48AB-$4900 (85 bytes) [HYPOTHESIS] padding? run of 85 x $00 in unclassified bytes
	ds $55, $00

; ---- gfx $4900-$49B0 (176 bytes) [HYPOTHESIS] 2bpp tiles by coherence: 10 non-blank tiles, mean adjacent-pixel similarity h=0.59 v=0.67 (random data ~0.25-0.35); 11 tiles: glyphs 0-9 and : (large digits) seen when rendered

Data_42_4900:: ; 42:4900
	INCBIN "gfx/bank42/tiles_4900.2bpp"

; ---- zero $49B0-$4A00 (80 bytes) [HYPOTHESIS] 0x00 run of 86 bytes [clipped from 49AA-4A00 by higher-priority proposals]
	ds $50, $00

; ---- data $4A00-$4CD0 (720 bytes) [PROBABLE] tilemap+attr block of screen 1: 20x18 tile indices (360 B) then 20x18 CGB attribute bytes (360 B, all values < $10 as bank/palette attributes) = the 2x$168-byte layout that copy_tilemap_rect_pair (00:08EA, b=18 rows c=20 cols) loads for the CONFIRMED screens of banks 24/4B/5F/71; followed by a 128-byte palette block; no direct reference found (bank 42 is not named by any ld hl/ld a,bank site), so structural PROBABLE only

Tilemap_42_4A00:: ; 42:4A00
	INCBIN "gfx/bank42/tilemap_4a00.tilemap"
	INCBIN "gfx/bank42/tilemap_4a00.attrmap"

; ---- data $4CD0-$4D50 (128 bytes) [PROBABLE] RGB555 palette block (128 B = 8 BG + 8 OBJ palettes of 4 colours, starts with the same $7FFF,$011C,$7E02 colours in all four screens of this bank); replaces the mapper palette guess that was offset by 6/2 bytes

Palette_42_4CD0:: ; 42:4CD0
	INCLUDE "gfx/bank42/palette_4cd0.pal"

; ---- gfx $4D50-$4F00 (432 bytes) [PROBABLE] 2bpp tiles by coherence: 27 non-blank tiles, mean adjacent-pixel similarity h=0.56 v=0.59 (random data ~0.25-0.35);

Tiles_42_4D50:: ; 42:4D50
	INCBIN "gfx/bank42/tiles_4d50.2bpp"

; ---- gfx $4F00-$52C0 (960 bytes) [PROBABLE] tiles-2bpp: heuristic: 56 coherent tiles (hsim2=0.656 vsim2=0.620, 1 blank) parity 0

Data_42_4F00:: ; 42:4F00
	INCBIN "gfx/bank42/tiles_4f00.2bpp"

; ---- gfx $52C0-$52E0 (32 bytes) [HYPOTHESIS] 2bpp tiles by coherence: 1 non-blank tiles, mean adjacent-pixel similarity h=0.71 v=0.30 (random data ~0.25-0.35);

Data_42_52C0:: ; 42:52C0
	INCBIN "gfx/bank42/tiles_52c0.2bpp"

; ---- gfx $52E0-$5750 (1136 bytes) [PROBABLE] tiles-2bpp: heuristic: 47 coherent tiles (hsim2=0.582 vsim2=0.596, 20 blank) parity 0 [range trimmed from 52E0-5760 by classify_g2]

Data_42_52E0:: ; 42:52E0
	INCBIN "gfx/bank42/tiles_52e0.2bpp"

; ---- data $5750-$5A20 (720 bytes) [PROBABLE] tilemap+attr block of screen 2: 20x18 tile indices (360 B) then 20x18 CGB attribute bytes (360 B, all values < $10 as bank/palette attributes) = the 2x$168-byte layout that copy_tilemap_rect_pair (00:08EA, b=18 rows c=20 cols) loads for the CONFIRMED screens of banks 24/4B/5F/71; followed by a 128-byte palette block; no direct reference found (bank 42 is not named by any ld hl/ld a,bank site), so structural PROBABLE only

Tilemap_42_5750:: ; 42:5750
	INCBIN "gfx/bank42/tilemap_5750.tilemap"
	INCBIN "gfx/bank42/tilemap_5750.attrmap"

; ---- data $5A20-$5AA0 (128 bytes) [PROBABLE] RGB555 palette block (128 B = 8 BG + 8 OBJ palettes of 4 colours, starts with the same $7FFF,$011C,$7E02 colours in all four screens of this bank); replaces the mapper palette guess that was offset by 6/2 bytes

Palette_42_5A20:: ; 42:5A20
	INCLUDE "gfx/bank42/palette_5a20.pal"

; ---- gfx $5AA0-$5E5E (958 bytes) [PROBABLE] 2bpp tiles by coherence: 59 non-blank tiles, mean adjacent-pixel similarity h=0.76 v=0.63 (random data ~0.25-0.35);

Tiles_42_5AA0:: ; 42:5AA0
	INCBIN "gfx/bank42/tiles_5aa0.2bpp"
	db $38, $38, $7C, $7C, $FE, $FE, $EE, $EE, $FE, $FE, $7C, $7C, $38, $38

; ---- zero $5E5E-$5E90 (50 bytes) [HYPOTHESIS] padding? run of 50 x $00 in unclassified bytes
	ds $32, $00

; ---- gfx $5E90-$5F60 (208 bytes) [HYPOTHESIS] 2bpp tiles by coherence: 13 non-blank tiles, mean adjacent-pixel similarity h=0.60 v=0.68 (random data ~0.25-0.35);

Data_42_5E90:: ; 42:5E90
	INCBIN "gfx/bank42/tiles_5e90.2bpp"

; ---- zero $5F60-$5F92 (50 bytes) [HYPOTHESIS] padding? run of 50 x $00 in unclassified bytes
	ds $32, $00

; ---- gfx $5F92-$6140 (430 bytes) [PROBABLE] 2bpp tiles by coherence: 26 non-blank tiles, mean adjacent-pixel similarity h=0.71 v=0.66 (random data ~0.25-0.35);

Tiles_42_5F92:: ; 42:5F92
	INCBIN "gfx/bank42/tiles_5f92.2bpp"
	db $FF, $B5, $FF, $B5, $FF, $A5, $FF, $BD, $FF, $C3, $FF, $FF, $FF, $FF

; ---- zero $6140-$62A0 (352 bytes) [HYPOTHESIS] padding? run of 352 x $00 in unclassified bytes
	ds $160, $00

; ---- gfx $62A0-$634A (170 bytes) [HYPOTHESIS] 2bpp tiles by coherence: 10 non-blank tiles, mean adjacent-pixel similarity h=0.48 v=0.62 (random data ~0.25-0.35);

Data_42_62A0:: ; 42:62A0
	INCBIN "gfx/bank42/tiles_62a0.2bpp"
	db $00, $00, $00, $00, $10, $18, $18, $10, $08, $10

; ---- zero $634A-$63A0 (86 bytes) [HYPOTHESIS] 0x00 run of 86 bytes
	ds $56, $00

; ---- gfx $63A0-$63B0 (16 bytes) [HYPOTHESIS] 2bpp tiles (too few non-blank tiles to score);

Data_42_63A0:: ; 42:63A0
	INCBIN "gfx/bank42/tiles_63a0.2bpp"

; ---- gfx $63B0-$64A0 (240 bytes) [PROBABLE] tiles-2bpp: heuristic: 47 coherent tiles (hsim2=0.620 vsim2=0.850, 5 blank) parity 0 [range trimmed from 63B0-6740 by classify_g2]

Data_42_63B0:: ; 42:63B0
	INCBIN "gfx/bank42/tiles_63b0.2bpp"

; ---- data $64A0-$6770 (720 bytes) [PROBABLE] tilemap+attr block of screen 3: 20x18 tile indices (360 B) then 20x18 CGB attribute bytes (360 B; values $01,$08-$0B,$2A,$2B: valid CGB attribute bits, palette 0-3, tile bank 1 and, for $2A/$2B, X-flip - NOT all < $10 as the other three screens) = the 2x$168-byte layout that copy_tilemap_rect_pair (00:08EA, b=18 rows c=20 cols) loads for the CONFIRMED screens of banks 24/4B/5F/71; followed by a 128-byte palette block; no direct reference found (bank 42 is not named by any ld hl/ld a,bank site), so structural PROBABLE only

Tilemap_42_64A0:: ; 42:64A0
	INCBIN "gfx/bank42/tilemap_64a0.tilemap"
	INCBIN "gfx/bank42/tilemap_64a0.attrmap"

; ---- data $6770-$67F0 (128 bytes) [PROBABLE] RGB555 palette block (128 B = 8 BG + 8 OBJ palettes of 4 colours, starts with the same $7FFF,$011C,$7E02 colours in all four screens of this bank); replaces the mapper palette guess that was offset by 6/2 bytes

Palette_42_6770:: ; 42:6770
	INCLUDE "gfx/bank42/palette_6770.pal"

; ---- gfx $67F0-$6800 (16 bytes) [HYPOTHESIS] one 2bpp tile ($FF,$00 x8 = two-colour stripes) directly after the palette block; the old mapper palette region wrongly extended over it

Data_42_67F0:: ; 42:67F0
	INCBIN "gfx/bank42/tiles_67f0.2bpp"

; ---- zero $6800-$6810 (16 bytes) [HYPOTHESIS] padding? run of 16 x $00 in unclassified bytes
	ds $10, $00

; ---- gfx $6810-$69A0 (400 bytes) [PROBABLE] 2bpp tiles by coherence: 25 non-blank tiles, mean adjacent-pixel similarity h=0.60 v=0.60 (random data ~0.25-0.35);

Tiles_42_6810:: ; 42:6810
	INCBIN "gfx/bank42/tiles_6810.2bpp"

; ---- data $69A0-$69B0 (16 bytes) [HYPOTHESIS] run of 16 x $FF (padding?) in unclassified bytes

Data_42_69A0:: ; 42:69A0
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

; ---- gfx $69B0-$6CC0 (784 bytes) [HYPOTHESIS] 2bpp tiles by coherence: 49 non-blank tiles, mean adjacent-pixel similarity h=0.56 v=0.47 (random data ~0.25-0.35);

Data_42_69B0:: ; 42:69B0
	INCBIN "gfx/bank42/tiles_69b0.2bpp"

; ---- zero $6CC0-$6FF2 (818 bytes) [HYPOTHESIS] 0x00 run of 818 bytes
	ds $332, $00

; ---- gfx $6FF2-$709E (172 bytes) [HYPOTHESIS] 2bpp tiles by coherence: 10 non-blank tiles, mean adjacent-pixel similarity h=0.49 v=0.61 (random data ~0.25-0.35);

Data_42_6FF2:: ; 42:6FF2
	INCBIN "gfx/bank42/tiles_6ff2.2bpp"
	db $00, $00, $00, $00, $18, $04, $14, $0C, $14, $0C, $1C, $1C

; ---- zero $709E-$70F0 (82 bytes) [HYPOTHESIS] 0x00 run of 82 bytes
	ds $52, $00

; ---- gfx $70F0-$719C (172 bytes) [HYPOTHESIS] 2bpp tiles by coherence: 10 non-blank tiles, mean adjacent-pixel similarity h=0.56 v=0.59 (random data ~0.25-0.35);

Data_42_70F0:: ; 42:70F0
	INCBIN "gfx/bank42/tiles_70f0.2bpp"
	db $00, $00, $00, $00, $18, $04, $14, $0C, $14, $0C, $1C, $1C

; ---- zero $719C-$71F0 (84 bytes) [HYPOTHESIS] padding? run of 86 x $00 in unclassified bytes
	ds $54, $00

; ---- data $71F0-$74C0 (720 bytes) [PROBABLE] tilemap+attr block of screen 4: 20x18 tile indices (360 B) then 20x18 CGB attribute bytes (360 B, all values < $10 as bank/palette attributes) = the 2x$168-byte layout that copy_tilemap_rect_pair (00:08EA, b=18 rows c=20 cols) loads for the CONFIRMED screens of banks 24/4B/5F/71; followed by a 128-byte palette block; no direct reference found (bank 42 is not named by any ld hl/ld a,bank site), so structural PROBABLE only

Tilemap_42_71F0:: ; 42:71F0
	INCBIN "gfx/bank42/tilemap_71f0.tilemap"
	INCBIN "gfx/bank42/tilemap_71f0.attrmap"

; ---- data $74C0-$7540 (128 bytes) [PROBABLE] RGB555 palette block (128 B = 8 BG + 8 OBJ palettes of 4 colours, starts with the same $7FFF,$011C,$7E02 colours in all four screens of this bank); replaces the mapper palette guess that was offset by 6/2 bytes

Palette_42_74C0:: ; 42:74C0
	INCLUDE "gfx/bank42/palette_74c0.pal"
