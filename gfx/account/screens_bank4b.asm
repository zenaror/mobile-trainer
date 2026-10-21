; gfx/account/screens_bank4b.asm
; bank 4B, $42D0-$5B90 (6336 bytes); pinned by layout.link
; tiles/tilemap loaded by bank 68

SECTION "gfx/account/screens_bank4b", ROMX

; ---- gfx $42D0-$46D0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:76AA: hl=$42D0 a=$4B c=$40 de=$8801 (dest VRAM $8800, vbank=1)

Gfx_Account_ResultPage_Tiles8800Vb1:: ; 4B:42D0
	INCBIN "gfx/account/screens_bank4b/tiles_42d0.2bpp"

; ---- gfx $46D0-$4AD0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:76BC: hl=$46D0 a=$4B c=$40 de=$8C01 (dest VRAM $8C00, vbank=1)

Gfx_Account_ResultPage_Tiles8C00Vb1:: ; 4B:46D0
	INCBIN "gfx/account/screens_bank4b/tiles_46d0.2bpp"

; ---- gfx $4AD0-$5080 (1456 bytes) [CONFIRMED] tile bytes included in positive VRAM1 DMA source spans [PROBABLE: result-page indexed banner role]

Gfx_Account_ResultPage_Tiles4AD0:: ; 4B:4AD0
	INCBIN "gfx/account/screens_bank4b/account_result_page_tiles4ad0.2bpp"

; ---- gfx $5080-$5400 (896 bytes) [PROBABLE] tiles-2bpp: heuristic: 54 coherent tiles (hsim2=0.832 vsim2=0.732, 0 blank) parity 0

Data_4B_5080:: ; 4B:5080
	INCBIN "gfx/account/screens_bank4b/tiles_5080.2bpp"

; ---- data $5400-$5420 (32 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown [clipped from 5370-5B6C by higher-priority evidence]

Data_4B_5400:: ; 4B:5400
	db $00, $00, $00, $FF, $FF, $00, $F7, $F8, $9B, $0C, $6F, $64, $67, $64, $67, $64
	db $00, $00, $00, $FF, $FF, $00, $FF, $20, $FF, $BE, $63, $62, $BF, $2A, $FD, $28

; ---- gfx $5420-$5870 (1104 bytes) [PROBABLE] tile data: heuristic: 69 coherent tiles (hsim2=0.852 vsim2=0.752, 0 blank) parity 0; 40/1184 bytes also covered by call-site blocks [clipped from 5420-58C0 by higher-priority proposals]; the 8 bytes behind the INCBIN and the next block ($5878-$5898, 32 bytes) were palette bytes: the palette array below is what engine/account/result_page.asm reads

Data_4B_5420:: ; 4B:5420
	INCBIN "gfx/account/screens_bank4b/tiles_5420.2bpp"

; ---- data $5870-$5898 (40 bytes) [CONFIRMED] palette-rgb555: 20 colours (5 palettes) read by Palette_LoadToBuffer: +$00 bc=$28 into wPaletteBufBg (engine/account/result_page.asm:47, call 68:76D0 executed 31 hits in 8 scenarios (analysis/coverage_union.tsv))

Palette_Account_ResultPage_Bg:: ; 4B:5870
	INCLUDE "gfx/account/screens_bank4b/account_result_page_bg.pal"

; ---- data $5898-$5B68 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:76E1: hl=$5898 a=$4B b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Account_ResultPage:: ; 4B:5898
	INCBIN "gfx/account/screens_bank4b/tilemap_5898.tilemap"
	INCBIN "gfx/account/screens_bank4b/tilemap_5898.attrmap"

; ---- data $5B68-$5B90 (40 bytes) [PROBABLE] 10 x 4-byte entries (tile, tile+$10 pair, attr, attr) = $A7/$B7,$A8/$B8,...,$C0/$C1 with attributes $0A $0A, placed right after the 720-byte tilemap+attr block 5898-5B68 (same shape as the entries at 76C0 after the block 73F0-76C0); entries 5B68, 5B74, 5B7C and following were read by executed code; the use of the entries is not decoded

Table_4B_5B68:: ; 4B:5B68
	db $A7, $B7, $0A, $0A, $A8, $B8, $0A, $0A, $A9, $B9, $0A, $0A, $AA, $BA, $0A, $0A
	db $AB, $BB, $0A, $0A, $AC, $BC, $0A, $0A, $AD, $BD, $0A, $0A, $AE, $BE, $0A, $0A
	db $AF, $BF, $0A, $0A, $C0, $C1, $0A, $0A
