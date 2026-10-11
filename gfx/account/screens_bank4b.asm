; gfx/account/screens_bank4b.asm
; bank 4B, $42D0-$5B90 (6336 bytes); pinned by layout.link
; tiles/tilemap loaded by bank 68

SECTION "gfx/account/screens_bank4b", ROMX

; ---- gfx $42D0-$46D0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:76AA: hl=$42D0 a=$4B c=$40 de=$8801 (dest VRAM $8800, vbank=1)

Gfx_Account_ResultPage_Tiles8800Vb1:: ; 4B:42D0
Data_4B_42D0::
	INCBIN "gfx/account/screens_bank4b/tiles_42d0.2bpp"

; ---- gfx $46D0-$4AD0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:76BC: hl=$46D0 a=$4B c=$40 de=$8C01 (dest VRAM $8C00, vbank=1)

Gfx_Account_ResultPage_Tiles8C00Vb1:: ; 4B:46D0
Data_4B_46D0::
	INCBIN "gfx/account/screens_bank4b/tiles_46d0.2bpp"

; ---- data $4AD0-$5080 (1456 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown [clipped from 4000-50F0 by higher-priority evidence]

Data_4B_4AD0:: ; 4B:4AD0
	db $80, $80, $9E, $9E, $9E, $82, $82, $82, $C2, $42, $7E, $3E, $3E, $00, $00, $80
	db $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FF, $00, $FF
	db $80, $98, $80, $BE, $80, $BE, $80, $98, $C2, $42, $7E, $3C, $3C, $00, $00, $80
	db $82, $92, $82, $BA, $82, $BA, $82, $92, $C6, $44, $7C, $38, $38, $00, $00, $82
	db $C6, $C6, $EE, $AA, $AA, $AA, $BA, $92, $92, $92, $92, $82, $82, $00, $00, $38
	db $82, $B2, $86, $84, $FC, $F8, $F8, $80, $80, $82, $80, $BE, $80, $3E, $00, $3E
	db $80, $BE, $80, $BE, $80, $BE, $80, $BE, $80, $80, $FE, $FE, $FE, $00, $00, $00
	db $80, $80, $FC, $FD, $FC, $81, $80, $80, $80, $80, $FE, $FE, $FE, $00, $00, $00
	db $10, $D6, $10, $D6, $10, $D6, $10, $D6, $10, $D6, $10, $D6, $10, $C6, $00, $C6
	db $80, $80, $FC, $FC, $FC, $80, $80, $80, $80, $80, $FE, $FE, $FE, $00, $00, $00
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $03, $F8, $F9, $FC, $84, $86, $82
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $09, $F1, $09, $F1, $09, $F1, $F9, $F1, $89, $81, $09, $F1, $09, $F1, $09, $F1
	db $82, $B2, $82, $BA, $82, $BA, $82, $B2, $86, $84, $FC, $F8, $F8, $01, $00, $03
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $09, $F1, $09, $F1, $09, $F1, $F9, $F1, $89, $81, $09, $F1, $09, $F1, $09, $F1
	db $90, $8F, $90, $8F, $90, $8F, $9F, $8F, $98, $88, $90, $8F, $90, $8F, $90, $8F
	db $90, $8F, $90, $8F, $90, $8F, $9F, $8F, $98, $88, $90, $8F, $90, $8F, $90, $8F
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FE, $00, $FE, $00, $FE, $00, $FE
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $38, $82, $BA, $82, $BA, $82, $BA
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $01, $7C, $7C, $FE, $82, $82, $80
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $C7, $10, $93, $38, $AA, $38, $28
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $80, $3E, $3E, $7E, $40, $C0, $80
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $80, $80, $80
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FE, $00, $FE
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $80, $3C, $3C, $7E, $42, $C2, $80
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $82, $38, $38, $7C, $44, $C6, $82
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $38, $82, $BA, $82, $92, $C6, $C6
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $02, $F8, $F8, $FC, $84, $86, $82
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $3E, $80, $BE, $80, $BE, $80, $BE
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $80, $80, $80
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $10, $10, $10
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $80, $80, $80
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $03, $F8, $F9, $FC, $84, $86, $82
	db $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FF, $00, $FF
	db $82, $BA, $82, $BA, $82, $BA, $82, $92, $C6, $44, $7C, $38, $38, $00, $00, $82
	db $80, $81, $FC, $7C, $7E, $02, $02, $02, $82, $82, $FE, $7C, $7C, $00, $00, $00
	db $6C, $44, $6C, $44, $C6, $82, $FE, $FE, $FE, $82, $82, $82, $82, $38, $00, $38
	db $80, $80, $9E, $9E, $9E, $82, $82, $82, $C2, $42, $7E, $3E, $3E, $00, $00, $80
	db $80, $80, $FC, $FD, $FC, $81, $80, $80, $80, $80, $FE, $FE, $FE, $00, $00, $00
	db $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FF, $00, $FF
	db $80, $98, $80, $BE, $80, $BE, $80, $98, $C2, $42, $7E, $3C, $3C, $00, $00, $80
	db $82, $92, $82, $BA, $82, $BA, $82, $92, $C6, $44, $7C, $38, $38, $00, $00, $82
	db $C6, $C6, $EE, $AA, $AA, $AA, $BA, $92, $92, $92, $92, $82, $82, $00, $00, $38
	db $82, $B2, $86, $84, $FC, $F8, $F8, $80, $80, $82, $80, $BE, $80, $3E, $00, $3E
	db $80, $BE, $80, $BE, $80, $BE, $80, $BE, $80, $80, $FE, $FE, $FE, $00, $00, $00
	db $80, $80, $FC, $FD, $FC, $81, $80, $80, $80, $80, $FE, $FE, $FE, $00, $00, $00
	db $10, $D6, $10, $D6, $10, $D6, $10, $D6, $10, $D6, $10, $D6, $10, $C6, $00, $C6
	db $80, $80, $FC, $FC, $FC, $80, $80, $80, $80, $80, $FE, $FE, $FE, $00, $00, $00
	db $82, $B2, $82, $BA, $82, $BA, $82, $B2, $86, $84, $FC, $F8, $F8, $01, $00, $03
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $09, $F1, $09, $F1, $09, $F1, $F9, $F1, $89, $81, $09, $F1, $09, $F1, $09, $F1
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $09, $F1, $09, $F1, $09, $F1, $F9, $F1, $89, $81, $09, $F1, $09, $F1, $09, $F1
	db $90, $8F, $90, $8F, $90, $8F, $9F, $8F, $98, $88, $90, $8F, $90, $8F, $90, $8F
	db $90, $8F, $90, $8F, $90, $8F, $9F, $8F, $98, $88, $90, $8F, $90, $8F, $90, $8F
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FE, $00, $FE
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $80, $3C, $3C, $7E, $42, $C2, $80
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $C6, $10, $92, $38, $AA, $38, $28
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $3E, $80, $BE, $80, $BE, $80, $BE
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $3F, $80, $BF, $80, $BF, $80, $BF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FE, $00, $FE, $00, $FE, $00, $FE
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $80, $80, $80
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $7C, $7C, $7C, $10, $10, $10
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $38, $82, $BA, $82, $9A, $C2, $CA
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $7C, $7C, $7C, $10, $10, $10
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $7C, $7C, $FE, $82, $82, $80
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $38, $82, $BA, $82, $BA, $82, $BA
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $80, $80, $80
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $03, $F8, $F9, $FC, $84, $86, $82
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FF, $00, $FF
	db $80, $98, $80, $BE, $80, $BE, $80, $98, $C2, $42, $7E, $3C, $3C, $00, $00, $80
	db $6C, $44, $6C, $44, $C6, $82, $FE, $FE, $FE, $82, $82, $82, $82, $38, $00, $38
	db $80, $BE, $80, $BE, $80, $BE, $80, $BE, $80, $80, $FE, $FE, $FE, $00, $00, $00
	db $80, $BF, $80, $BF, $80, $BF, $80, $BF, $80, $80, $FE, $FE, $FE, $00, $00, $00
	db $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE
	db $80, $81, $FC, $FD, $FC, $81, $80, $81, $80, $BF, $80, $BF, $80, $3F, $00, $3F
	db $10, $D6, $10, $D6, $10, $D6, $10, $D6, $10, $10, $7C, $7C, $7C, $00, $00, $00
	db $E2, $A2, $B2, $92, $9A, $8A, $8E, $86, $86, $A2, $82, $B2, $82, $38, $00, $38
	db $10, $D6, $10, $D6, $10, $D6, $10, $D6, $10, $10, $7C, $7C, $7C, $00, $00, $00
	db $80, $80, $FC, $7C, $7E, $02, $02, $02, $82, $82, $FE, $7C, $7C, $00, $00, $00
	db $82, $82, $FE, $FE, $FE, $82, $82, $82, $82, $BA, $82, $BA, $82, $38, $00, $38
	db $80, $80, $FC, $FC, $FC, $80, $80, $80, $80, $80, $FE, $FE, $FE, $00, $00, $00
	db $82, $B2, $82, $BA, $82, $BA, $82, $B2, $86, $84, $FC, $F8, $F8, $01, $00, $03
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF

; ---- gfx $5080-$5400 (896 bytes) [PROBABLE] tiles-2bpp: heuristic: 54 coherent tiles (hsim2=0.832 vsim2=0.732, 0 blank) parity 0

Data_4B_5080:: ; 4B:5080
	INCBIN "gfx/account/screens_bank4b/tiles_5080.2bpp"

; ---- data $5400-$5420 (32 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown [clipped from 5370-5B6C by higher-priority evidence]

Data_4B_5400:: ; 4B:5400
	db $00, $00, $00, $FF, $FF, $00, $F7, $F8, $9B, $0C, $6F, $64, $67, $64, $67, $64
	db $00, $00, $00, $FF, $FF, $00, $FF, $97, $FC, $94, $FF, $94, $FF, $D4, $BF, $B4

; ---- gfx $5420-$5870 (1104 bytes) [PROBABLE] tile data: heuristic: 69 coherent tiles (hsim2=0.852 vsim2=0.752, 0 blank) parity 0; 40/1184 bytes also covered by call-site blocks [clipped from 5420-58C0 by higher-priority proposals]; the 8 bytes behind the INCBIN and the next block ($5878-$5898, 32 bytes) were palette bytes: the palette array below is what engine/account/result_page.asm reads

Data_4B_5420:: ; 4B:5420
	INCBIN "gfx/account/screens_bank4b/tiles_5420.2bpp"

; ---- data $5870-$5898 (40 bytes) [CONFIRMED] palette-rgb555: 20 colours (5 palettes) read by Palette_LoadToBuffer: +$00 bc=$28 into wPaletteBufBg (engine/account/result_page.asm:47, call 68:76D0 executed 31 hits in 8 scenarios (analysis/coverage_union.tsv))

Palette_Account_ResultPage_Bg:: ; 4B:5870
	INCLUDE "gfx/account/screens_bank4b/account_result_page_bg.pal"

; ---- data $5898-$5B68 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:76E1: hl=$5898 a=$4B b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Account_ResultPage:: ; 4B:5898
Data_4B_5898::
	INCBIN "gfx/account/screens_bank4b/tilemap_5898.tilemap"
	INCBIN "gfx/account/screens_bank4b/tilemap_5898.attrmap"

; ---- data $5B68-$5B90 (40 bytes) [PROBABLE] 10 x 4-byte entries (tile, tile+$10 pair, attr, attr) = $A7/$B7,$A8/$B8,...,$C0/$C1 with attributes $0A $0A, placed right after the 720-byte tilemap+attr block 5898-5B68 (same shape as the entries at 76C0 after the block 73F0-76C0); entries 5B68, 5B74, 5B7C and following were read by executed code; the use of the entries is not decoded

Table_4B_5B68:: ; 4B:5B68
	db $A7, $B7, $0A, $0A, $A8, $B8, $0A, $0A, $A9, $B9, $0A, $0A, $AA, $BA, $0A, $0A
	db $AB, $BB, $0A, $0A, $AC, $BC, $0A, $0A, $AD, $BD, $0A, $0A, $AE, $BE, $0A, $0A
	db $AF, $BF, $0A, $0A, $C0, $C1, $0A, $0A
