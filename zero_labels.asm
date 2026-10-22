; zero_labels.asm
; Labels that name bytes inside an all-zero range which the layout leaves uncovered (the linker pads it with 0x00).
; Each section holds only the zero bytes from the label to the next label / the end of its region / the end of the range,
; so the ROM is unchanged.  To move a label into a real file, put the section in that file and pin it in layout.link.

SECTION "zero_labels", ROMX
; ROM [48:69AB,48:69CB) (32 bytes); layout.link pins this section there

; ---- data [48:69AB,48:69CB) (32 bytes) [CONFIRMED] reader-selected source outside the declared Font_GlyphRun_83BF INCBIN; content identity and intent unknown

FontReader_OutOfRunSource_48_69AB:: ; 48:69AB
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
