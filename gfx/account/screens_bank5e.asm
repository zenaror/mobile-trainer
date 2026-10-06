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

; ---- data $4D00-$4D40 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/account/login_id_entry.asm:123, call 68:5398 executed 129 hits in 8 scenarios (analysis/coverage_union.tsv)); +$00 bc=$40 into wPaletteBufBg (engine/account/login_id_entry.asm:402, call 68:566E executed 155 hits in 8 scenarios (analysis/coverage_union.tsv)); +$00 bc=$40 into wPaletteBufBg (engine/account/mail_address_entry.asm:138, call 68:584B executed 88 hits in 8 scenarios (analysis/coverage_union.tsv)); and 6 more load(s)

Data_5E_4D00:: ; 5E:4D00
	INCLUDE "gfx/account/screens_bank5e/palette_4d00.pal"

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

; ---- gfx $5210-$5510 (768 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:565D: hl=$5210 a=$5E c=$40 de=$9401 (dest VRAM $9400, vbank=1); the last $100 bytes of the old blob hold the head of a tilemap pair; the blocks below type them by what the code reads, and the HDMA request that copies the tiles copies them into VRAM as well

Gfx_Account_LoginIdIntro_Tiles9400Vb1:: ; 5E:5210
Data_5E_5210::
	INCBIN "gfx/account/screens_bank5e/tiles_5210.2bpp"

; ---- data $5510-$57E0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:567F: hl=$5510 a=$5E b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Account_LoginIdIntro_5E_5510:: ; 5E:5510
	INCBIN "gfx/account/screens_bank5e/account_login_id_intro_5e_5510.tilemap"
	INCBIN "gfx/account/screens_bank5e/account_login_id_intro_5e_5510.attrmap"

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

; ---- gfx $6FA0-$72C0 (800 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:6E70: hl=$6FA0 a=$5E c=$40 de=$9401 (dest VRAM $9400, vbank=1); the last $E0 bytes of the old blob hold a palette and the head of a tilemap pair; the blocks below type them by what the code reads, and the HDMA request that copies the tiles copies them into VRAM as well

Gfx_Account_ActionConfirmPage_Tiles9400Vb1:: ; 5E:6FA0
Data_5E_6FA0::
	INCBIN "gfx/account/screens_bank5e/tiles_6fa0.2bpp"

; ---- data $72C0-$7300 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/account/action_confirm.asm:51, call 68:6E93 executed 213 hits in 19 scenarios (analysis/coverage_union.tsv))

Palette_Account_ActionConfirmPage_Bg:: ; 5E:72C0
	INCLUDE "gfx/account/screens_bank5e/account_action_confirm_page_bg.pal"

; ---- data $7300-$75D0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:6ECE: hl=$7300 a=$5E b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Account_ActionConfirmPage_Variant0:: ; 5E:7300
	INCBIN "gfx/account/screens_bank5e/account_action_confirm_page_5e_7300.tilemap"
	INCBIN "gfx/account/screens_bank5e/account_action_confirm_page_5e_7300.attrmap"

; ---- data $75D0-$78A0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:6EBB: hl=$75D0 a=$5E b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Account_ActionConfirmPage_NonzeroVariant:: ; 5E:75D0
Data_5E_75D0::
	INCBIN "gfx/account/screens_bank5e/tilemap_75d0.tilemap"
	INCBIN "gfx/account/screens_bank5e/tilemap_75d0.attrmap"
