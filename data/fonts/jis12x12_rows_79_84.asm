; data/fonts/jis12x12_rows_79_84.asm
; bank 76, $4000-$67A8 (10152 bytes); pinned by layout.link
; JIS X 0208 12x12 font rows 79-84

SECTION "data/fonts/jis12x12_rows_79_84", ROMX

; ---- gfx $4000-$67A8 (10152 bytes) [PROBABLE] font12x12: JIS X 0208 12x12 1bpp glyphs, 18 bytes/glyph (2 rows of 12 bits per 3 bytes), JIS rows 79,80,81,82,83,84, 94 cols/row; layout from 7F:400E/4072/40B9 + tables 7F:40F9/7F:4150 (verified structure, layout from engine code)

Data_76_4000:: ; 76:4000
	INCBIN "data/fonts/jis12x12_rows_79_84.bin"
