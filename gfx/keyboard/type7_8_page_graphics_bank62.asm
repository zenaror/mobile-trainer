; gfx/keyboard/type7_8_page_graphics_bank62.asm
; bank 62, $4000-$6C00 (11264 bytes); pinned by layout.link
; keyboard tiles loaded by bank 55

SECTION "gfx/keyboard/type7_8_page_graphics_bank62", ROMX

; ---- gfx $4000-$4400 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:6990: hl=$4000 a=$62 c=$40 de=$8801 (dest VRAM $8800, vbank=1)

Gfx_Kbd_T78_Page0_Tiles8800Vb1:: ; 62:4000
	INCBIN "gfx/keyboard/type7_8_page_graphics_bank62/type7_8_page0_tiles8800_vb1_4000.2bpp"

; ---- gfx $4400-$4800 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:69A2: hl=$4400 a=$62 c=$40 de=$8C01 (dest VRAM $8C00, vbank=1)

Gfx_Kbd_T78_Page0_Tiles8C00Vb1:: ; 62:4400
	INCBIN "gfx/keyboard/type7_8_page_graphics_bank62/type7_8_page0_tiles8c00_vb1_4400.2bpp"

; ---- gfx $4800-$4A40 (576 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:69B4: hl=$4800 a=$62 c=$24 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Kbd_T78_Page0_Tiles9000Vb1:: ; 62:4800
	INCBIN "gfx/keyboard/type7_8_page_graphics_bank62/type7_8_page0_tiles9000_vb1_4800.2bpp"

; ---- gfx $4A40-$4B00 (192 bytes) [PROBABLE] tiles-2bpp: heuristic: 692 coherent tiles (hsim2=0.801 vsim2=0.775, 0 blank) parity 0; 10496/11264 bytes also covered by call-site blocks [clipped from 4000-6C00 by higher-priority evidence]

Gfx_Kbd_T78_Page0_CandidateTailTiles:: ; 62:4A40
	INCBIN "gfx/keyboard/type7_8_page_graphics_bank62/t78_page0_candidate_tail_tiles.2bpp"

; ---- gfx $4B00-$4F00 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:69C9: hl=$4B00 a=$62 c=$40 de=$8801 (dest VRAM $8800, vbank=1)

Gfx_Kbd_T78_Page1_Tiles8800Vb1:: ; 62:4B00
	INCBIN "gfx/keyboard/type7_8_page_graphics_bank62/type7_8_page1_tiles8800_vb1_4b00.2bpp"

; ---- gfx $4F00-$5300 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:69DB: hl=$4F00 a=$62 c=$40 de=$8C01 (dest VRAM $8C00, vbank=1)

Gfx_Kbd_T78_Page1_Tiles8C00Vb1:: ; 62:4F00
	INCBIN "gfx/keyboard/type7_8_page_graphics_bank62/type7_8_page1_tiles8c00_vb1_4f00.2bpp"

; ---- gfx $5300-$5540 (576 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:69ED: hl=$5300 a=$62 c=$24 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Kbd_T78_Page1_Tiles9000Vb1:: ; 62:5300
	INCBIN "gfx/keyboard/type7_8_page_graphics_bank62/type7_8_page1_tiles9000_vb1_5300.2bpp"

; ---- gfx $5540-$5600 (192 bytes) [PROBABLE] tiles-2bpp: heuristic: 692 coherent tiles (hsim2=0.801 vsim2=0.775, 0 blank) parity 0; 10496/11264 bytes also covered by call-site blocks [clipped from 4000-6C00 by higher-priority evidence]

Gfx_Kbd_T78_Page1_CandidateTailTiles:: ; 62:5540
	INCBIN "gfx/keyboard/type7_8_page_graphics_bank62/t78_page1_candidate_tail_tiles.2bpp"

; ---- gfx $5600-$5A00 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:6A02: hl=$5600 a=$62 c=$40 de=$8801 (dest VRAM $8800, vbank=1)

Gfx_Kbd_T78_Page2_Tiles8800Vb1:: ; 62:5600
	INCBIN "gfx/keyboard/type7_8_page_graphics_bank62/type7_8_page2_tiles8800_vb1_5600.2bpp"

; ---- gfx $5A00-$5E00 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:6A14: hl=$5A00 a=$62 c=$40 de=$8C01 (dest VRAM $8C00, vbank=1)

Gfx_Kbd_T78_Page2_Tiles8C00Vb1:: ; 62:5A00
	INCBIN "gfx/keyboard/type7_8_page_graphics_bank62/type7_8_page2_tiles8c00_vb1_5a00.2bpp"

; ---- gfx $5E00-$6040 (576 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:6A26: hl=$5E00 a=$62 c=$24 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Kbd_T78_Page2_Tiles9000Vb1:: ; 62:5E00
	INCBIN "gfx/keyboard/type7_8_page_graphics_bank62/type7_8_page2_tiles9000_vb1_5e00.2bpp"

; ---- gfx $6040-$6100 (192 bytes) [PROBABLE] tiles-2bpp: heuristic: 692 coherent tiles (hsim2=0.801 vsim2=0.775, 0 blank) parity 0; 10496/11264 bytes also covered by call-site blocks [clipped from 4000-6C00 by higher-priority evidence]

Gfx_Kbd_T78_Page2_CandidateTailTiles:: ; 62:6040
	INCBIN "gfx/keyboard/type7_8_page_graphics_bank62/t78_page2_candidate_tail_tiles.2bpp"

; ---- gfx $6100-$6500 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:6A3B: hl=$6100 a=$62 c=$40 de=$8801 (dest VRAM $8800, vbank=1) [first call site executed: 12 hits in 5 scenarios (analysis/coverage_union.tsv)]

Gfx_Kbd_T78_Page3_Tiles8800Vb1:: ; 62:6100
	INCBIN "gfx/keyboard/type7_8_page_graphics_bank62/type7_8_page3_tiles8800_vb1_6100.2bpp"

; ---- gfx $6500-$6900 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:6A4D: hl=$6500 a=$62 c=$40 de=$8C01 (dest VRAM $8C00, vbank=1) [first call site executed: 12 hits in 5 scenarios (analysis/coverage_union.tsv)]

Gfx_Kbd_T78_Page3_Tiles8C00Vb1:: ; 62:6500
	INCBIN "gfx/keyboard/type7_8_page_graphics_bank62/type7_8_page3_tiles8c00_vb1_6500.2bpp"

; ---- gfx $6900-$6B40 (576 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:6A5F: hl=$6900 a=$62 c=$24 de=$9001 (dest VRAM $9000, vbank=1) [first call site executed: 12 hits in 5 scenarios (analysis/coverage_union.tsv)]

Gfx_Kbd_T78_Page3_Tiles9000Vb1:: ; 62:6900
	INCBIN "gfx/keyboard/type7_8_page_graphics_bank62/type7_8_page3_tiles9000_vb1_6900.2bpp"

; ---- gfx $6B40-$6C00 (192 bytes) [PROBABLE] tiles-2bpp: heuristic: 692 coherent tiles (hsim2=0.801 vsim2=0.775, 0 blank) parity 0; 10496/11264 bytes also covered by call-site blocks [clipped from 4000-6C00 by higher-priority evidence]

Gfx_Kbd_T78_Page3_CandidateTailTiles:: ; 62:6B40
	INCBIN "gfx/keyboard/type7_8_page_graphics_bank62/t78_page3_candidate_tail_tiles.2bpp"
