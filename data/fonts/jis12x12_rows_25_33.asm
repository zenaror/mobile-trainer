; data/fonts/jis12x12_rows_25_33.asm
; bank 7C, $4000-$7B7C (15228 bytes); pinned by layout.link
; JIS X 0208 12x12 font rows 25-33 (includes the 10-byte region typed code at 57C3)

SECTION "data/fonts/jis12x12_rows_25_33", ROMX

; ---- gfx $4000-$57C3 (6083 bytes) [PROBABLE] font12x12: JIS X 0208 12x12 1bpp glyphs, 18 bytes/glyph (2 rows of 12 bits per 3 bytes), JIS rows 25,26,27,28,29,30,31,32,33, 94 cols/row; layout from 7F:400E/4072/40B9 + tables 7F:40F9/7F:4150 (verified structure, layout from engine code) [clipped from 4000-7B7C by higher-priority evidence]

GlyphFont_Jis12x12_7C:: ; 7C:4000
Data_7C_4000::
	INCBIN "data/fonts/jis12x12_rows_25_33_4000.bin"

; ---- code $57C3-$57CD (10 bytes) [PROBABLE] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 1; entered by table from 7C:7D5D (executed)
	nop
	ld a, [hl]
	ldh a, [c]
	ld c, c
	inc h
	sub a, d
	ld c, c
	ld a, [hl]
	and a, b
	ret

; ---- gfx $57CD-$7B7C (9135 bytes) [PROBABLE] font12x12: JIS X 0208 12x12 1bpp glyphs, 18 bytes/glyph (2 rows of 12 bits per 3 bytes), JIS rows 25,26,27,28,29,30,31,32,33, 94 cols/row; layout from 7F:400E/4072/40B9 + tables 7F:40F9/7F:4150 (verified structure, layout from engine code) [clipped from 4000-7B7C by higher-priority evidence]

Data_7C_57CD:: ; 7C:57CD
	INCBIN "data/fonts/jis12x12_rows_25_33_57cd.bin"
