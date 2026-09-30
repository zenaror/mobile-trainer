; gfx/account/screens_bank5d.asm
; bank 5D, $4800-$7360 (11104 bytes); pinned by layout.link
; account screens art loaded by bank 68

SECTION "gfx/account/screens_bank5d", ROMX

; ---- gfx $4800-$4C00 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:5DFD: hl=$4800 a=$5D c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Account_PasswordEntry_Tiles9000Vb1:: ; 5D:4800
Data_5D_4800::
	INCBIN "gfx/account/screens_bank5d/tiles_4800.2bpp"

; ---- gfx $4C00-$5000 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:5E0F: hl=$4C00 a=$5D c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_Account_PasswordEntry_Tiles9400Vb1:: ; 5D:4C00
Data_5D_4C00::
	INCBIN "gfx/account/screens_bank5d/tiles_4c00.2bpp"

; ---- data $5000-$5320 (800 bytes) [CONFIRMED] read as data by executed code (in up to 7/18 scenarios); content class unknown [clipped from 4000-7318 by higher-priority evidence]

Data_5D_5000:: ; 5D:5000
	db $6F, $6F, $6F, $6F, $26, $27, $28, $29, $2A, $4E, $4F, $60, $61, $62, $63, $64
	db $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $36, $37, $38, $39, $3A, $5E, $5F, $70
	db $71, $72, $73, $74, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $00
	db $00, $00, $00, $00, $00, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F
	db $6F, $6F, $6F, $00, $00, $00, $00, $00, $00, $6F, $6F, $6F, $6F, $6F, $6F, $6F
	db $6F, $6F, $6F, $6F, $6F, $6F, $6F, $75, $76, $76, $76, $76, $75, $6F, $6F, $6F
	db $6F, $6F, $6F, $6F, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $10, $10, $10, $10, $10, $10, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $10, $10, $10, $10, $10, $10, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $0B, $0B, $0B, $0B, $0B
	db $2B, $09, $09, $09, $09, $09, $09, $09, $6F, $43, $44, $45, $46, $47, $48, $49
	db $4A, $4B, $4C, $4D, $4E, $4F, $60, $61, $62, $63, $64, $6F, $6F, $53, $54, $55
	db $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F, $70, $71, $72, $73, $74, $6F
	db $6F, $6F, $6F, $6F, $6F, $6F, $6F, $00, $00, $00, $00, $00, $00, $6F, $6F, $6F
	db $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $00, $00, $00, $00, $00
	db $00, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $75
	db $76, $76, $76, $76, $75, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $10, $10, $10, $10, $10
	db $10, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $10
	db $10, $10, $10, $10, $10, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $0B, $0B, $0B, $0B, $0B, $2B, $09, $09, $09, $09, $09, $09, $09
	db $6F, $65, $66, $67, $68, $45, $26, $27, $28, $29, $2A, $2B, $2C, $2D, $2E, $2F
	db $40, $41, $42, $6F, $6F, $6A, $6B, $6C, $6D, $55, $36, $37, $38, $39, $3A, $3B
	db $3C, $3D, $3E, $3F, $50, $51, $52, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $00
	db $00, $00, $00, $00, $00, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F
	db $6F, $6F, $6F, $00, $00, $00, $00, $00, $00, $6F, $6F, $6F, $6F, $6F, $6F, $6F
	db $6F, $6F, $6F, $6F, $6F, $6F, $6F, $75, $76, $76, $76, $76, $75, $6F, $6F, $6F
	db $6F, $6F, $6F, $6F, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $10, $10, $10, $10, $10, $10, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $10, $10, $10, $10, $10, $10, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $0B, $0B, $0B, $0B, $0B
	db $2B, $09, $09, $09, $09, $09, $09, $09, $6F, $6F, $69, $2D, $42, $26, $27, $28
	db $29, $2A, $2B, $2C, $2D, $2E, $2F, $40, $41, $42, $6F, $6F, $6F, $6F, $6E, $3D
	db $52, $36, $37, $38, $39, $3A, $3B, $3C, $3D, $3E, $3F, $50, $51, $52, $6F, $6F
	db $6F, $6F, $6F, $6F, $6F, $6F, $6F, $00, $00, $00, $00, $00, $00, $6F, $6F, $6F
	db $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $00, $00, $00, $00, $00
	db $00, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $75
	db $76, $76, $76, $76, $75, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $10, $10, $10, $10, $10
	db $10, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $10
	db $10, $10, $10, $10, $10, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $0B, $0B, $0B, $0B, $0B, $2B, $09, $09, $09, $09, $09, $09, $09

; ---- gfx $5320-$5720 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:6125: hl=$5320 a=$5D c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Account_PasswordIntro_Tiles9000Vb1:: ; 5D:5320
Data_5D_5320::
	INCBIN "gfx/account/screens_bank5d/tiles_5320.2bpp"

; ---- gfx $5720-$5B20 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:6137: hl=$5720 a=$5D c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_Account_PasswordIntro_Tiles9400Vb1:: ; 5D:5720
Data_5D_5720::
	INCBIN "gfx/account/screens_bank5d/tiles_5720.2bpp"

; ---- data $5B20-$5DF0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:6159: hl=$5B20 a=$5D b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Account_PasswordIntro:: ; 5D:5B20
Data_5D_5B20::
	INCBIN "gfx/account/screens_bank5d/tilemap_5b20.tilemap"
	INCBIN "gfx/account/screens_bank5d/tilemap_5b20.attrmap"

; ---- gfx $5DF0-$61F0 (1024 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (68:6238 68:6476); first: hdma_rom_to_vram at 68:6238: hl=$5DF0 a=$5D c=$40 de=$8801 (dest VRAM $8800, vbank=1)

Gfx_Account_ConfirmScreens_Tiles8800Vb1:: ; 5D:5DF0
Data_5D_5DF0::
	INCBIN "gfx/account/screens_bank5d/tiles_5df0.2bpp"

; ---- gfx $61F0-$63F0 (512 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (68:624A 68:6488); first: hdma_rom_to_vram at 68:624A: hl=$61F0 a=$5D c=$20 de=$8C01 (dest VRAM $8C00, vbank=1)

Gfx_Account_ConfirmScreens_Tiles8C00Vb1:: ; 5D:61F0
Data_5D_61F0::
	INCBIN "gfx/account/screens_bank5d/tiles_61f0.2bpp"

; ---- gfx $63F0-$65F0 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:625C: hl=$63F0 a=$5D c=$20 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Account_ConfirmScreen_Tiles9000Vb1:: ; 5D:63F0
Data_5D_63F0::
	INCBIN "gfx/account/screens_bank5d/tiles_63f0.2bpp"

; ---- gfx $65F0-$6630 (64 bytes) [PROBABLE] tiles-2bpp: heuristic: 38 coherent tiles (hsim2=0.711 vsim2=0.719, 5 blank) parity 0; 656/720 bytes also covered by call-site blocks [clipped from 6360-6630 by higher-priority evidence]

Palette_Account_ConfirmScreen_Bg:: ; 5D:65F0
Data_5D_65F0::
	INCBIN "gfx/account/screens_bank5d/tiles_65f0.2bpp"

; ---- data $6630-$6900 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:62A1: hl=$6630 a=$5D b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Account_ConfirmScreen:: ; 5D:6630
Data_5D_6630::
	INCBIN "gfx/account/screens_bank5d/tilemap_6630.tilemap"
	INCBIN "gfx/account/screens_bank5d/tilemap_6630.attrmap"

; ---- gfx $6900-$6C00 (768 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:6B3D: hl=$6900 a=$5D c=$30 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_Registration_WriteConfig_Tiles8000:: ; 5D:6900
Data_5D_6900::
	INCBIN "gfx/account/screens_bank5d/tiles_6900.2bpp"

; ---- gfx $6C00-$6E00 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:6B19: hl=$6A00 a=$5D c=$40 de=$8801 (dest VRAM $8800, vbank=1) [clipped from 6A00-6E00 by higher-priority evidence]

Data_5D_6C00:: ; 5D:6C00
	INCBIN "gfx/account/screens_bank5d/tiles_6c00.2bpp"

; ---- gfx $6E00-$7200 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:6B2B: hl=$6E00 a=$5D c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Registration_WriteConfig_Tiles9000Vb1:: ; 5D:6E00
Data_5D_6E00::
	INCBIN "gfx/account/screens_bank5d/tiles_6e00.2bpp"

; ---- data $7200-$7318 (280 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:6B70: hl=$7048 a=$5D b=18 rows c=20 cols (tiles then attrs) de=$D000 [clipped from 7048-7318 by higher-priority evidence]

Data_5D_7200:: ; 5D:7200
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0B, $0B, $09, $0C, $0C, $0C, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0B, $0B, $09, $0C, $0C
	db $0C, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $09, $0A, $0C, $0C, $0C, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $09, $09, $09, $09, $09, $09, $09, $09
	db $0A, $0A, $0A, $0A, $29, $29, $29, $29, $29, $29, $29, $29, $09, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $29
	db $09, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $29, $09, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $29, $09, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $29, $09, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $29
	db $09, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $29, $49, $49, $69, $69, $69, $69, $69, $69, $69, $69, $69, $69
	db $69, $69, $69, $69, $69, $69, $69, $69

; ---- zero $7318-$731C (4 bytes) [PROBABLE] 4 x 00 (all bytes zero) between two read-data blocks
	ds $4, $00

; ---- data $731C-$735D (65 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown

Data_5D_731C:: ; 5D:731C
	db $20, $73, $54, $73, $28, $73, $31, $73, $3A, $73, $53, $73, $02, $05, $0C, $00
	db $00, $06, $1E, $01, $00, $02, $05, $05, $02, $00, $06, $1E, $03, $00, $06, $13
	db $05, $04, $40, $13, $0D, $05, $40, $06, $1E, $09, $00, $0B, $05, $06, $40, $0B
	db $0D, $07, $40, $03, $05, $08, $40, $00, $04, $00, $14, $01, $14, $02, $14, $03
	db $14

; ---- zero $735D-$7360 (3 bytes) [PROBABLE] 3 x 00 (all bytes zero) between two read-data blocks
	ds $3, $00
