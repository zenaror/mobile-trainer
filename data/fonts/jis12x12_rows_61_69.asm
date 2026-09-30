; data/fonts/jis12x12_rows_61_69.asm
; bank 78, $4000-$7B7C (15228 bytes); pinned by layout.link
; JIS X 0208 12x12 font rows 61-69

SECTION "data/fonts/jis12x12_rows_61_69", ROMX

; ---- gfx $4000-$7B7C (15228 bytes) [PROBABLE] font12x12: JIS X 0208 12x12 1bpp glyphs, 18 bytes/glyph (2 rows of 12 bits per 3 bytes), JIS rows 61,62,63,64,65,66,67,68,69, 94 cols/row; layout from 7F:400E/4072/40B9 + tables 7F:40F9/7F:4150 (verified structure, layout from engine code)

GlyphFont_Jis12x12_78:: ; 78:4000
Data_78_4000::
	INCBIN "data/fonts/jis12x12_rows_61_69.bin"
