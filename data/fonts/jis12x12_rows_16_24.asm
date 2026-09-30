; data/fonts/jis12x12_rows_16_24.asm
; bank 7D, $4000-$7B7C (15228 bytes); pinned by layout.link
; JIS X 0208 12x12 font rows 16-24

SECTION "data/fonts/jis12x12_rows_16_24", ROMX

; ---- gfx $4000-$7B7C (15228 bytes) [PROBABLE] font12x12: JIS X 0208 12x12 1bpp glyphs, 18 bytes/glyph (2 rows of 12 bits per 3 bytes), JIS rows 16,17,18,19,20,21,22,23,24, 94 cols/row; layout from 7F:400E/4072/40B9 + tables 7F:40F9/7F:4150 (verified structure, layout from engine code)

GlyphFont_Jis12x12_7D:: ; 7D:4000
Data_7D_4000::
	INCBIN "data/fonts/jis12x12_rows_16_24.bin"
