; gfx/bank41.asm
; bank 41, $4000-$7540 (13632 bytes); pinned by layout.link
; four screen packages (160 tiles + 20x18 tilemap/attr map + palettes); no loader found

SECTION "gfx/bank41", ROMX

; ---- gfx $4000-$4A00 (2560 bytes) [PROBABLE] 160 x 2bpp tiles of screen record 0; visually verified as tile art (rendered 2bpp sheet: frames, digits, glyphs); blank ($00) and solid ($FF) tiles are part of the set. bank 41 = 4 identical-layout screen records of $D50 bytes each (4000+4*$D50 = 7540 = start of the zero tail): 160 tiles ($A00) + 20x18 tilemap + 20x18 attribute map ($2D0 total, same shape as the 85 CONFIRMED copy_tilemap_rect_pair blocks elsewhere, e.g. 1A:47B5) + 16 CGB palettes ($80). No code references bank 41 (never executed in the 18 traces), so the kind rests on content and exact tiling

Tiles_41_4000:: ; 41:4000
	INCBIN "gfx/bank41/tiles_4000.2bpp"

; ---- data $4A00-$4CD0 (720 bytes) [PROBABLE] 20x18 tile-index map ($168) followed by the 20x18 attribute map ($168; values actually present: $09-$0C; a CGB BG-attribute-like layout is assumed, not verified since nothing loads this bank) of screen record 0; row stride 20 verified by the repeating column pattern

Tilemap_41_4A00:: ; 41:4A00
	INCBIN "gfx/bank41/tilemap_4a00.tilemap"
	INCBIN "gfx/bank41/tilemap_4a00.attrmap"

; ---- data $4CD0-$4D50 (128 bytes) [PROBABLE] 16 CGB palettes x 4 RGB555 words (bit15 clear, palettes like 0000 294A 56B5 7FFF) of screen record 0

Palette_41_4CD0:: ; 41:4CD0
	INCLUDE "gfx/bank41/palette_4cd0.pal"

; ---- gfx $4D50-$5750 (2560 bytes) [PROBABLE] 160 x 2bpp tiles of screen record 1; visually verified as tile art (rendered 2bpp sheet: frames, digits, glyphs); blank ($00) and solid ($FF) tiles are part of the set. bank 41 = 4 identical-layout screen records of $D50 bytes each (4000+4*$D50 = 7540 = start of the zero tail): 160 tiles ($A00) + 20x18 tilemap + 20x18 attribute map ($2D0 total, same shape as the 85 CONFIRMED copy_tilemap_rect_pair blocks elsewhere, e.g. 1A:47B5) + 16 CGB palettes ($80). No code references bank 41 (never executed in the 18 traces), so the kind rests on content and exact tiling

Tiles_41_4D50:: ; 41:4D50
	INCBIN "gfx/bank41/tiles_4d50.2bpp"

; ---- data $5750-$5A20 (720 bytes) [PROBABLE] 20x18 tile-index map ($168) followed by the 20x18 attribute map ($168; values actually present: $08-$0C; a CGB BG-attribute-like layout is assumed, not verified since nothing loads this bank) of screen record 1; row stride 20 verified by the repeating column pattern

Tilemap_41_5750:: ; 41:5750
	INCBIN "gfx/bank41/tilemap_5750.tilemap"
	INCBIN "gfx/bank41/tilemap_5750.attrmap"

; ---- data $5A20-$5AA0 (128 bytes) [PROBABLE] 16 CGB palettes x 4 RGB555 words (bit15 clear, palettes like 0000 294A 56B5 7FFF) of screen record 1

Palette_41_5A20:: ; 41:5A20
	INCLUDE "gfx/bank41/palette_5a20.pal"

; ---- gfx $5AA0-$64A0 (2560 bytes) [PROBABLE] 160 x 2bpp tiles of screen record 2; visually verified as tile art (rendered 2bpp sheet: frames, digits, glyphs); blank ($00) and solid ($FF) tiles are part of the set. bank 41 = 4 identical-layout screen records of $D50 bytes each (4000+4*$D50 = 7540 = start of the zero tail): 160 tiles ($A00) + 20x18 tilemap + 20x18 attribute map ($2D0 total, same shape as the 85 CONFIRMED copy_tilemap_rect_pair blocks elsewhere, e.g. 1A:47B5) + 16 CGB palettes ($80). No code references bank 41 (never executed in the 18 traces), so the kind rests on content and exact tiling

Tiles_41_5AA0:: ; 41:5AA0
	INCBIN "gfx/bank41/tiles_5aa0.2bpp"

; ---- data $64A0-$6770 (720 bytes) [PROBABLE] 20x18 tile-index map ($168) followed by the 20x18 attribute map ($168; values actually present: $09,$0A,$0B,$10; a CGB BG-attribute-like layout is assumed, not verified since nothing loads this bank) of screen record 2; row stride 20 verified by the repeating column pattern

Tilemap_41_64A0:: ; 41:64A0
	INCBIN "gfx/bank41/tilemap_64a0.tilemap"
	INCBIN "gfx/bank41/tilemap_64a0.attrmap"

; ---- data $6770-$67F0 (128 bytes) [PROBABLE] 16 CGB palettes x 4 RGB555 words (bit15 clear, palettes like 0000 294A 56B5 7FFF) of screen record 2

Palette_41_6770:: ; 41:6770
	INCLUDE "gfx/bank41/palette_6770.pal"

; ---- gfx $67F0-$71F0 (2560 bytes) [PROBABLE] 160 x 2bpp tiles of screen record 3; visually verified as tile art (rendered 2bpp sheet: frames, digits, glyphs); blank ($00) and solid ($FF) tiles are part of the set. bank 41 = 4 identical-layout screen records of $D50 bytes each (4000+4*$D50 = 7540 = start of the zero tail): 160 tiles ($A00) + 20x18 tilemap + 20x18 attribute map ($2D0 total, same shape as the 85 CONFIRMED copy_tilemap_rect_pair blocks elsewhere, e.g. 1A:47B5) + 16 CGB palettes ($80). No code references bank 41 (never executed in the 18 traces), so the kind rests on content and exact tiling

Tiles_41_67F0:: ; 41:67F0
	INCBIN "gfx/bank41/tiles_67f0.2bpp"

; ---- data $71F0-$74C0 (720 bytes) [PROBABLE] 20x18 tile-index map ($168) followed by the 20x18 attribute map ($168; values actually present: $00,$09,$0A,$0B,$2A; a CGB BG-attribute-like layout is assumed, not verified since nothing loads this bank) of screen record 3; row stride 20 verified by the repeating column pattern

Tilemap_41_71F0:: ; 41:71F0
	INCBIN "gfx/bank41/tilemap_71f0.tilemap"
	INCBIN "gfx/bank41/tilemap_71f0.attrmap"

; ---- data $74C0-$7540 (128 bytes) [PROBABLE] 16 CGB palettes x 4 RGB555 words (bit15 clear, palettes like 0000 294A 56B5 7FFF) of screen record 3

Palette_41_74C0:: ; 41:74C0
	INCLUDE "gfx/bank41/palette_74c0.pal"
