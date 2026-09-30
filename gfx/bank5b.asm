; gfx/bank5b.asm
; bank 5B, $4000-$56E0 (5856 bytes); pinned by layout.link
; 360 tiles of art and 12 palettes; no loader found

SECTION "gfx/bank5b", ROMX

; ---- gfx $4000-$5200 (4608 bytes) [PROBABLE] 288 x 2bpp tiles (0x1200 bytes): rendered as a 16-wide tile sheet the whole span is coherent tile art (logo lettering, window frames, katakana/kana glyph tiles); tiles are 16-aligned from 4000 and the run 4000-5680 is an exact multiple of 16; the $FF runs at 42F0/44F0/48FE are solid-colour tiles inside the art; no loader call site found (bank 5B has no direct hl/a immediate references); mapper heuristics listed 12 overlapping HYPOTHESIS tile blocks over it

Tiles_5B_4000:: ; 5B:4000
	INCBIN "gfx/bank5b/tiles_4000.2bpp"

; ---- gfx $5200-$5680 (1152 bytes) [PROBABLE] 72 x 2bpp tiles (0x480 bytes) continuing the tile sheet above; the whole span was read as data by executed code in 1/18 scenarios (CPU copy of 0x480 bytes) and renders as coherent tile art

Tiles_5B_5200:: ; 5B:5200
	INCBIN "gfx/bank5b/tiles_5200.2bpp"

; ---- data $5680-$56E0 (96 bytes) [PROBABLE] 12 CGB palettes x 4 RGB555 words (0x60 bytes), bit15 clear in all words, contains 7FFF (mapper heuristic); after the tile sheet; 56A0-56A8 read by executed code

Palette_5B_5680:: ; 5B:5680
	INCLUDE "gfx/bank5b/palette_5680.pal"
