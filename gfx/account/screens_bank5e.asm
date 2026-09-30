; gfx/account/screens_bank5e.asm
; bank 5E, $4800-$78A0 (12448 bytes); pinned by layout.link
; account screens art loaded by bank 68 (includes 32 bytes read by bank 55)

SECTION "gfx/account/screens_bank5e", ROMX

; ---- gfx $4800-$4C00 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:5375: hl=$4800 a=$5E c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Account_LoginIdEntry_Tiles9000Vb1:: ; 5E:4800
Data_5E_4800::
	INCBIN "gfx/account/screens_bank5e/tiles_4800.2bpp"

; ---- gfx $4C00-$4D00 (256 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:5387: hl=$4C00 a=$5E c=$10 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_Account_LoginIdEntry_Tiles9400Vb1:: ; 5E:4C00
Data_5E_4C00::
	INCBIN "gfx/account/screens_bank5e/tiles_4c00.2bpp"

; ---- data $4D00-$4D40 (64 bytes) [CONFIRMED] read as data by executed code (in up to 7/18 scenarios); content class unknown [clipped from 4000-4E08 by higher-priority evidence]

Data_5E_4D00:: ; 5E:4D00
	db $00, $00, $00, $00, $00, $00, $FF, $7F, $00, $00, $4A, $41, $73, $42, $FF, $7F
	db $00, $00, $40, $7C, $45, $5B, $FF, $7F, $00, $00, $6E, $7D, $7B, $7E, $FF, $7F
	db $00, $00, $4E, $76, $FF, $7F, $00, $00, $FF, $7F, $F3, $6B, $00, $00, $EF, $3D
	db $FF, $7F, $F3, $6B, $C8, $39, $00, $00, $DF, $40, $CD, $7D, $FF, $7F, $00, $00

; ---- data $4D40-$4E08 (200 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:53A9: hl=$4D40 a=$5E b=5 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Account_LoginIdEntry:: ; 5E:4D40
Data_5E_4D40::
	INCBIN "gfx/account/screens_bank5e/tilemap_4d40.tilemap"
	INCBIN "gfx/account/screens_bank5e/tilemap_4d40.attrmap"

; ---- zero $4E08-$4E10 (8 bytes) [PROBABLE] 8 bytes $00 between the 5x20 tilemap+attr block (4D40-4E08, 200 bytes) and the tile block at 4E10: padding to the 16-byte tile alignment
	ds $8, $00

; ---- gfx $4E10-$5210 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:564B: hl=$4E10 a=$5E c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Account_LoginIdIntro_Tiles9000Vb1:: ; 5E:4E10
Data_5E_4E10::
	INCBIN "gfx/account/screens_bank5e/tiles_4e10.2bpp"

; ---- gfx $5210-$5610 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:565D: hl=$5210 a=$5E c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_Account_LoginIdIntro_Tiles9400Vb1:: ; 5E:5210
Data_5E_5210::
	INCBIN "gfx/account/screens_bank5e/tiles_5210.2bpp"

; ---- data $5610-$57E0 (464 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:567F: hl=$5510 a=$5E b=18 rows c=20 cols (tiles then attrs) de=$D000 [clipped from 5510-57E0 by higher-priority evidence]

Data_5E_5610:: ; 5E:5610
	db $00, $00, $00, $12, $12, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $12, $04, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $14, $13, $13, $13
	db $13, $13, $13, $13, $13, $13, $13, $13, $13, $13, $13, $13, $13, $13, $13, $14
	db $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F, $0F, $0F, $0F, $0F, $0F, $0F
	db $0F, $0F, $0F, $0F, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F, $1F, $1F
	db $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $29, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0B, $0B, $0B, $0B, $0B, $0B, $2B, $0A, $0A, $0A, $0A, $0A
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $29, $29, $09, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $29, $09, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $29, $09, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $29
	db $09, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $29, $09, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $29, $09, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $29, $09, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $29
	db $09, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $29, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $29, $29, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09

; ---- gfx $57E0-$5800 (32 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:6710: hl=$57E0 a=$5E c=$02 de=$8800 (dest VRAM $8800, vbank=0)

Gfx_Kbd_T1_Tiles8800:: ; 5E:57E0
Data_5E_57E0::
	INCBIN "gfx/account/screens_bank5e/tiles_57e0.2bpp"

; ---- gfx $5800-$5C00 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:5828: hl=$5800 a=$5E c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Account_MailAddressEntry_Tiles9000Vb1:: ; 5E:5800
Data_5E_5800::
	INCBIN "gfx/account/screens_bank5e/tiles_5800.2bpp"

; ---- gfx $5C00-$6000 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:583A: hl=$5C00 a=$5E c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_Account_MailAddressEntry_Tiles9400Vb1:: ; 5E:5C00
Data_5E_5C00::
	INCBIN "gfx/account/screens_bank5e/tiles_5c00.2bpp"

; ---- data $6000-$60C8 (200 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:585C: hl=$6000 a=$5E b=5 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Account_MailAddressEntry:: ; 5E:6000
Data_5E_6000::
	INCBIN "gfx/account/screens_bank5e/tilemap_6000.tilemap"
	INCBIN "gfx/account/screens_bank5e/tilemap_6000.attrmap"

; ---- zero $60C8-$60D0 (8 bytes) [PROBABLE] 8 bytes $00 between the 5x20 tilemap+attr block (6000-60C8, 200 bytes) and the tile block at 60D0: padding to the 16-byte tile alignment
	ds $8, $00

; ---- gfx $60D0-$64D0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:5C2E: hl=$60D0 a=$5E c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Account_MailIntro_Tiles9000Vb1:: ; 5E:60D0
Data_5E_60D0::
	INCBIN "gfx/account/screens_bank5e/tiles_60d0.2bpp"

; ---- gfx $64D0-$68D0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:5C40: hl=$64D0 a=$5E c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_Account_MailIntro_Tiles9400Vb1:: ; 5E:64D0
Data_5E_64D0::
	INCBIN "gfx/account/screens_bank5e/tiles_64d0.2bpp"

; ---- data $68D0-$6BA0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:5C62: hl=$68D0 a=$5E b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Account_MailIntro:: ; 5E:68D0
Data_5E_68D0::
	INCBIN "gfx/account/screens_bank5e/tilemap_68d0.tilemap"
	INCBIN "gfx/account/screens_bank5e/tilemap_68d0.attrmap"

; ---- gfx $6BA0-$6FA0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:6E5E: hl=$6BA0 a=$5E c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Account_ActionConfirmPage_Tiles9000Vb1:: ; 5E:6BA0
Data_5E_6BA0::
	INCBIN "gfx/account/screens_bank5e/tiles_6ba0.2bpp"

; ---- gfx $6FA0-$73A0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:6E70: hl=$6FA0 a=$5E c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_Account_ActionConfirmPage_Tiles9400Vb1:: ; 5E:6FA0
Data_5E_6FA0::
	INCBIN "gfx/account/screens_bank5e/tiles_6fa0.2bpp"

; ---- data $73A0-$75D0 (560 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:6ECE: hl=$7300 a=$5E b=18 rows c=20 cols (tiles then attrs) de=$D000 [clipped from 7300-75D0 by higher-priority evidence]

Data_5E_73A0:: ; 5E:73A0
	db $03, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $03, $13, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $13, $13, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $13, $13, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $13
	db $13, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $13, $13, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $13, $13, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $13, $03, $04, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $03
	db $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $22, $22, $22, $22, $22, $22, $22
	db $22, $22, $22, $22, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $32, $32, $32
	db $32, $32, $32, $32, $32, $32, $32, $32, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $29, $0A, $0A, $0A, $0A, $0A, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $09, $09
	db $09, $09, $09, $09, $09, $09, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $09, $09, $09, $09, $09, $09, $09, $09, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0F, $0F, $0F, $0F, $0A, $0A, $0F, $0F, $0F, $0F, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0F, $0F, $0F, $0F, $0A, $0A, $0F
	db $0F, $0F, $0F, $0A, $0A, $0A, $0A, $0A, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $29, $29, $09, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $29
	db $09, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $29, $09, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $29, $09, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $29, $09, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $29
	db $49, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $69, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49
	db $49, $49, $49, $49, $49, $49, $69, $69, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09

; ---- data $75D0-$78A0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:6EBB: hl=$75D0 a=$5E b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Account_ActionConfirmPage:: ; 5E:75D0
Data_5E_75D0::
	INCBIN "gfx/account/screens_bank5e/tilemap_75d0.tilemap"
	INCBIN "gfx/account/screens_bank5e/tilemap_75d0.attrmap"
