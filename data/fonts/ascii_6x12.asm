; data/fonts/ascii_6x12.asm
; bank 76, $67A8-$6C28 (1152 bytes); pinned by layout.link
; 6x12 ASCII font, 96 glyphs

SECTION "data/fonts/ascii_6x12", ROMX

; ---- gfx $67A8-$6C28 (1152 bytes) [PROBABLE] fontlatin6x12: half-width font, 96 glyphs (0x20..0x7F) x 12 bytes (1 byte/row, 6-8 px wide); address = 76:67A8+(c-$20)*12 from 7F:400E (verified structure, layout from engine code)

Data_76_67A8:: ; 76:67A8
	INCBIN "data/fonts/ascii_6x12.bin"
