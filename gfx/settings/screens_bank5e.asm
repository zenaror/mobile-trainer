; gfx/settings/screens_bank5e.asm
; bank 5E, $4000-$4800 (2048 bytes); pinned by layout.link
; shared phone and account text-entry VRAM sources loaded by banks 67 and 68

SECTION "gfx/settings/screens_bank5e", ROMX

; ---- gfx $4000-$4400 (1024 bytes) [CONFIRMED] tiles-vram: 4 call site(s) (67:4370 67:49E5 68:5351 68:5804); first: hdma_rom_to_vram at 67:4370: hl=$4000 a=$5E c=$40 de=$8801 (dest VRAM $8800, vbank=1) [first call site executed: 63 hits in 3 scenarios (analysis/coverage_union.tsv)]

Gfx_SharedTextEntry_Vram8800Vb1:: ; 5E:4000
Data_5E_4000::
	INCBIN "gfx/settings/screens_bank5e/tiles_4000.2bpp"

; ---- gfx $4400-$4800 (1024 bytes) [CONFIRMED] tiles-vram: 4 call site(s) (67:4382 67:49F7 68:5363 68:5816); first: hdma_rom_to_vram at 67:4382: hl=$4400 a=$5E c=$40 de=$8C01 (dest VRAM $8C00, vbank=1) [first call site executed: 63 hits in 3 scenarios (analysis/coverage_union.tsv)]

Gfx_SharedTextEntry_Vram8C00Vb1:: ; 5E:4400
Data_5E_4400::
	INCBIN "gfx/settings/screens_bank5e/tiles_4400.2bpp"
