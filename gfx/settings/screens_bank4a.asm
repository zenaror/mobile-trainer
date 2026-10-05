; gfx/settings/screens_bank4a.asm
; bank 4A, $5F80-$7378 (5112 bytes); pinned by layout.link
; settings screen art (loaded by bank 67)

SECTION "gfx/settings/screens_bank4a", ROMX

; ---- gfx $5F80-$6080 (256 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:6385: hl=$5F80 a=$4A c=$10 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_AdapterCheck_Tiles8000:: ; 4A:5F80
Data_4A_5F80::
	INCBIN "gfx/settings/screens_bank4a/tiles_5f80.2bpp"

; ---- gfx $6080-$6480 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:6397: hl=$6080 a=$4A c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_AdapterCheck_Tiles9000Vb1:: ; 4A:6080
Data_4A_6080::
	INCBIN "gfx/settings/screens_bank4a/tiles_6080.2bpp"

; ---- gfx $6480-$6880 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:63A9: hl=$6480 a=$4A c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_AdapterCheck_Tiles9400Vb1:: ; 4A:6480
Data_4A_6480::
	INCBIN "gfx/settings/screens_bank4a/tiles_6480.2bpp"

; ---- data $6880-$68D0 (80 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 67:63DC: hl=$6600 a=$4A b=18 rows c=20 cols (tiles then attrs) de=$D000 [clipped from 6600-68D0 by higher-priority evidence]

Data_4A_6880:: ; 4A:6880
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08

; ---- gfx $68D0-$6920 (80 bytes) [PROBABLE] tiles-2bpp: heuristic: 52 coherent tiles (hsim2=0.623 vsim2=0.877, 2 blank) parity 1; 832/912 bytes also covered by call-site blocks [clipped from 65C1-6951 by higher-priority evidence]

AdapterCheck_ObjTableAndAnimData:: ; 4A:68D0
Data_4A_68D0::
	INCBIN "gfx/settings/screens_bank4a/tiles_68d0.2bpp"

; ---- gfx $6920-$6D20 (1024 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (67:4394 67:4A09); first: hdma_rom_to_vram at 67:4394: hl=$6920 a=$4A c=$40 de=$9001 (dest VRAM $9000, vbank=1) [first call site executed: 63 hits in 3 scenarios (analysis/coverage_union.tsv)]

Gfx_PhoneKeypadAndComment_Tiles9000Vb1:: ; 4A:6920
Data_4A_6920::
	INCBIN "gfx/settings/screens_bank4a/tiles_6920.2bpp"

; ---- gfx $6D20-$7120 (1024 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (67:43A6 67:4A1B); first: hdma_rom_to_vram at 67:43A6: hl=$6D20 a=$4A c=$40 de=$9401 (dest VRAM $9400, vbank=1) [first call site executed: 63 hits in 3 scenarios (analysis/coverage_union.tsv)]

Gfx_PhoneKeypadAndComment_Tiles9400Vb1:: ; 4A:6D20
Data_4A_6D20::
	INCBIN "gfx/settings/screens_bank4a/tiles_6d20.2bpp"

; ---- data $7120-$71E8 (200 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 67:43CE: hl=$7120 a=$4A b=5 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 38 hits in 3 scenarios (analysis/coverage_union.tsv)]

Tilemap_PhoneKeypad_4A_7120:: ; 4A:7120
Data_4A_7120::
	INCBIN "gfx/settings/screens_bank4a/tilemap_7120.tilemap"
	INCBIN "gfx/settings/screens_bank4a/tilemap_7120.attrmap"

; ---- data $71E8-$72B0 (200 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 67:43E1: hl=$71E8 a=$4A b=5 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 25 hits in 3 scenarios (analysis/coverage_union.tsv)]

Tilemap_PhoneKeypad_4A_71E8:: ; 4A:71E8
Data_4A_71E8::
	INCBIN "gfx/settings/screens_bank4a/tilemap_71e8.tilemap"
	INCBIN "gfx/settings/screens_bank4a/tilemap_71e8.attrmap"

; ---- data $72B0-$7378 (200 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 67:4A3D: hl=$72B0 a=$4A b=5 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 13 hits in 3 scenarios (analysis/coverage_union.tsv)]

Tilemap_PhoneComment:: ; 4A:72B0
Data_4A_72B0::
	INCBIN "gfx/settings/screens_bank4a/tilemap_72b0.tilemap"
	INCBIN "gfx/settings/screens_bank4a/tilemap_72b0.attrmap"
