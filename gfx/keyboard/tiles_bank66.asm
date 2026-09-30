; gfx/keyboard/tiles_bank66.asm
; bank 66, $4000-$74B8 (13496 bytes); pinned by layout.link
; keyboard tiles and tilemaps loaded by bank 55

SECTION "gfx/keyboard/tiles_bank66", ROMX

; ---- gfx $4000-$4400 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:687D: hl=$4000 a=$66 c=$40 de=$8801 (dest VRAM $8800, vbank=1)

Gfx_Kbd_T6_Page0_Tiles8800Vb1:: ; 66:4000
Data_66_4000::
	INCBIN "gfx/keyboard/tiles_bank66/tiles_4000.2bpp"

; ---- gfx $4400-$4800 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:688F: hl=$4400 a=$66 c=$40 de=$8C01 (dest VRAM $8C00, vbank=1)

Gfx_Kbd_T6_Page0_Tiles8C00Vb1:: ; 66:4400
Data_66_4400::
	INCBIN "gfx/keyboard/tiles_bank66/tiles_4400.2bpp"

; ---- gfx $4800-$4A40 (576 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:68A1: hl=$4800 a=$66 c=$24 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Kbd_T6_Page0_Tiles9000Vb1:: ; 66:4800
Data_66_4800::
	INCBIN "gfx/keyboard/tiles_bank66/tiles_4800.2bpp"

; ---- gfx $4A40-$4E40 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:68B6: hl=$4A40 a=$66 c=$40 de=$8801 (dest VRAM $8800, vbank=1)

Gfx_Kbd_T6_Page1_Tiles8800Vb1:: ; 66:4A40
Data_66_4A40::
	INCBIN "gfx/keyboard/tiles_bank66/tiles_4a40.2bpp"

; ---- gfx $4E40-$5240 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:68C8: hl=$4E40 a=$66 c=$40 de=$8C01 (dest VRAM $8C00, vbank=1)

Gfx_Kbd_T6_Page1_Tiles8C00Vb1:: ; 66:4E40
Data_66_4E40::
	INCBIN "gfx/keyboard/tiles_bank66/tiles_4e40.2bpp"

; ---- gfx $5240-$5480 (576 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:68DA: hl=$5240 a=$66 c=$24 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Kbd_T6_Page1_Tiles9000Vb1:: ; 66:5240
Data_66_5240::
	INCBIN "gfx/keyboard/tiles_bank66/tiles_5240.2bpp"

; ---- gfx $5480-$5880 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:68EF: hl=$5480 a=$66 c=$40 de=$8801 (dest VRAM $8800, vbank=1)

Gfx_Kbd_T6_Page2_Tiles8800Vb1:: ; 66:5480
Data_66_5480::
	INCBIN "gfx/keyboard/tiles_bank66/tiles_5480.2bpp"

; ---- gfx $5880-$5C80 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:6901: hl=$5880 a=$66 c=$40 de=$8C01 (dest VRAM $8C00, vbank=1)

Gfx_Kbd_T6_Page2_Tiles8C00Vb1:: ; 66:5880
Data_66_5880::
	INCBIN "gfx/keyboard/tiles_bank66/tiles_5880.2bpp"

; ---- gfx $5C80-$5EC0 (576 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:6913: hl=$5C80 a=$66 c=$24 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Kbd_T6_Page2_Tiles9000Vb1:: ; 66:5C80
Data_66_5C80::
	INCBIN "gfx/keyboard/tiles_bank66/tiles_5c80.2bpp"

; ---- gfx $5EC0-$62C0 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:6928: hl=$5EC0 a=$66 c=$40 de=$8801 (dest VRAM $8800, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_Kbd_T6_Page3_Tiles8800Vb1:: ; 66:5EC0
Data_66_5EC0::
	INCBIN "gfx/keyboard/tiles_bank66/tiles_5ec0.2bpp"

; ---- gfx $62C0-$66C0 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:693A: hl=$62C0 a=$66 c=$40 de=$8C01 (dest VRAM $8C00, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_Kbd_T6_Page3_Tiles8C00Vb1:: ; 66:62C0
Data_66_62C0::
	INCBIN "gfx/keyboard/tiles_bank66/tiles_62c0.2bpp"

; ---- gfx $66C0-$6900 (576 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:694C: hl=$66C0 a=$66 c=$24 de=$9001 (dest VRAM $9000, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_Kbd_T6_Page3_Tiles9000Vb1:: ; 66:66C0
Data_66_66C0::
	INCBIN "gfx/keyboard/tiles_bank66/tiles_66c0.2bpp"

; ---- gfx $6900-$6A90 (400 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:6AD5: hl=$6900 a=$66 c=$19 de=$8A81 (dest VRAM $8A80, vbank=1)

Gfx_Kbd_T10_Tiles8A80Vb1:: ; 66:6900
Data_66_6900::
	INCBIN "gfx/keyboard/tiles_bank66/tiles_6900.2bpp"

; ---- gfx $6A90-$7190 (1792 bytes) [PROBABLE] tiles-2bpp: heuristic: 100 coherent tiles (hsim2=0.789 vsim2=0.790, 19 blank) parity 0; 128/1920 bytes also covered by call-site blocks [clipped from 6A10-7190 by higher-priority evidence]

Data_66_6A90:: ; 66:6A90
	INCBIN "gfx/keyboard/tiles_bank66/tiles_6a90.2bpp"

; ---- data $7190-$7210 (128 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown [clipped from 6900-74B8 by higher-priority evidence]

Data_66_7190:: ; 66:7190
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

; ---- data $7210-$73C8 (440 bytes) [CONFIRMED] tilemap+attr: 2 call site(s) (55:6961 55:6A74); first: copy_tilemap_rect_pair at 55:6961: hl=$7210 a=$66 b=11 rows c=20 cols (tiles then attrs) de=$D240

Tilemap_Kbd_T6And78_PageTail:: ; 66:7210
Data_66_7210::
	INCBIN "gfx/keyboard/tiles_bank66/tilemap_7210.tilemap"
	INCBIN "gfx/keyboard/tiles_bank66/tilemap_7210.attrmap"

; ---- data $73C8-$74B8 (240 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 55:6AE6: hl=$73C8 a=$66 b=6 rows c=20 cols (tiles then attrs) de=$D240

Tilemap_Kbd_T10:: ; 66:73C8
Data_66_73C8::
	INCBIN "gfx/keyboard/tiles_bank66/tilemap_73c8.tilemap"
	INCBIN "gfx/keyboard/tiles_bank66/tilemap_73c8.attrmap"
