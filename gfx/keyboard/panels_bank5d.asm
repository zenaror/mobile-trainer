; gfx/keyboard/panels_bank5d.asm
; bank 5D, $4000-$4800 (2048 bytes); pinned by layout.link
; keyboard panel tiles loaded by bank 55

SECTION "gfx/keyboard/panels_bank5d", ROMX

; ---- gfx $4000-$4400 (1024 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (55:6761 68:5DD9); first: hdma_rom_to_vram at 55:6761: hl=$4000 a=$5D c=$40 de=$8801 (dest VRAM $8800, vbank=1)

Data_5D_4000:: ; 5D:4000
	INCBIN "gfx/keyboard/panels_bank5d/tiles_4000.2bpp"

; ---- gfx $4400-$4800 (1024 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (55:6773 68:5DEB); first: hdma_rom_to_vram at 55:6773: hl=$4400 a=$5D c=$40 de=$8C01 (dest VRAM $8C00, vbank=1)

Data_5D_4400:: ; 5D:4400
	INCBIN "gfx/keyboard/panels_bank5d/tiles_4400.2bpp"
