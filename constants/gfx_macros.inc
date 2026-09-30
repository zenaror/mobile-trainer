; constants/gfx_macros.inc -- the RGB macro used by the palette files (gfx/**/*.pal), pre-included through includes.asm.
;
; RGB r, g, b [, r, g, b ...] : one 15-bit CGB colour word per triple, little endian, as the palette RAM takes it:
;   word = (b << 10) | (g << 5) | r         (bit 15 clear, each component 0-31)
; e.g. RGB 31, 31, 31 = dw $7FFF.  A .pal file is a list of `RGB` lines, four colours (one palette) per block.

MACRO RGB
	ASSERT _NARG % 3 == 0, "RGB takes r, g, b triples"
	REPT _NARG / 3
		ASSERT (\1) >= 0 && (\1) <= 31 && (\2) >= 0 && (\2) <= 31 && (\3) >= 0 && (\3) <= 31, "RGB components are 0-31"
		dw ((\3) << 10) | ((\2) << 5) | (\1)
		SHIFT 3
	ENDR
ENDM
