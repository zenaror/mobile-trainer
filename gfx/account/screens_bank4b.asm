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
	db $53, $88, $B0, $88, $A3, $1C, $60, $1F, $C0, $3F, $80, $7F, $00, $FF, $00, $FF
	db $FD, $00, $01, $00, $FF, $00, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $27, $A1, $29, $A0, $2A, $A4, $28, $A7, $28, $A7, $28, $87, $08, $87, $38, $C7
	db $80, $B8, $C5, $59, $51, $0C, $90, $08, $33, $CB, $03, $F8, $00, $F8, $03, $FC
	db $7F, $7F, $FF, $81, $C3, $46, $5A, $3C, $BD, $C3, $C3, $00, $18, $00, $F3, $0C
	db $27, $17, $67, $14, $46, $32, $03, $21, $AD, $8E, $AE, $00, $20, $00, $EF, $10
	db $FD, $FC, $FD, $40, $01, $40, $40, $80, $BE, $7E, $7E, $00, $00, $00, $FF, $00
	db $3B, $8B, $2B, $A8, $2A, $AA, $28, $AA, $A8, $08, $8B, $00, $A2, $41, $8E, $71
	db $BA, $19, $DA, $C1, $E2, $21, $E6, $C1, $F4, $33, $34, $03, $44, $83, $1C, $E3
	db $05, $F4, $05, $F4, $05, $F4, $0D, $C4, $19, $DC, $1D, $C0, $01, $C0, $1F, $E0
	db $00, $FF, $00, $1F, $D0, $CF, $D0, $4F, $D0, $8F, $B0, $0F, $60, $1F, $C0, $3F
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $09, $F1, $09, $F1, $09, $F1, $F9, $F1, $89, $81, $09, $F1, $09, $F1, $09, $F1
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $09, $F1, $09, $F1, $09, $F1, $F9, $F1, $89, $81, $09, $F1, $09, $F1, $09, $F1
	db $90, $8F, $90, $8F, $90, $8F, $9F, $8F, $98, $88, $90, $8F, $90, $8F, $90, $8F
	db $90, $8F, $90, $8F, $90, $8F, $9F, $8F, $98, $88, $90, $8F, $90, $8F, $90, $8F
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $E0, $0F, $EF, $0F, $E0, $00, $F0, $07, $F8, $00, $FF
	db $00, $FF, $00, $C1, $15, $14, $D5, $D4, $D5, $00, $01, $00, $FF, $00, $00, $FF
	db $00, $FF, $00, $F1, $0C, $0C, $7C, $70, $70, $10, $7C, $7C, $7C, $10, $10, $10
	db $00, $FF, $00, $C6, $14, $12, $94, $92, $94, $92, $94, $92, $94, $92, $94, $92
	db $00, $FF, $00, $00, $FF, $FF, $FF, $88, $88, $88, $FF, $FF, $FF, $88, $88, $88
	db $00, $FF, $00, $38, $A2, $82, $AF, $8F, $AF, $88, $AF, $87, $A7, $85, $AF, $8A
	db $00, $FF, $00, $80, $3E, $3E, $BE, $88, $BE, $BE, $B6, $22, $3E, $3E, $36, $22
	db $00, $FF, $00, $FF, $80, $78, $97, $67, $AF, $49, $99, $51, $B5, $21, $AB, $22
	db $00, $FF, $00, $FE, $00, $3E, $D0, $CE, $E8, $26, $30, $17, $58, $0A, $6A, $08
	db $00, $FF, $00, $04, $F1, $F1, $FF, $4F, $4F, $49, $4A, $42, $77, $77, $FE, $DC
	db $00, $FF, $00, $78, $03, $0B, $EB, $E0, $EB, $23, $AB, $80, $EB, $E3, $CB, $80
	db $00, $FF, $00, $00, $DF, $DF, $DF, $04, $DC, $DC, $DE, $06, $CE, $C8, $D9, $11
	db $00, $FF, $00, $31, $A4, $94, $A5, $85, $AD, $8D, $AF, $82, $A7, $85, $AF, $8F
	db $00, $FF, $00, $8F, $20, $21, $3D, $3C, $7D, $44, $ED, $A8, $BB, $10, $38, $28
	db $00, $FF, $00, $80, $3F, $BF, $3F, $80, $00, $80, $3F, $C0, $02, $FC, $01, $FD
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $F3, $0A, $E9, $1A, $D1, $10, $D0, $1F, $CF, $0F, $E0, $00, $F0, $07, $F8
	db $00, $FF, $00, $FF, $00, $FF, $00, $03, $FA, $F9, $FA, $01, $02, $01, $FE, $01
	db $3A, $B8, $3C, $B4, $74, $50, $50, $10, $16, $10, $54, $83, $04, $C3, $1C, $E3
	db $94, $92, $94, $92, $94, $90, $95, $11, $75, $71, $75, $00, $04, $00, $7D, $82
	db $FF, $FF, $FF, $88, $88, $88, $A8, $08, $29, $09, $69, $00, $42, $20, $CE, $31
	db $AF, $85, $AD, $88, $AF, $8F, $A8, $88, $AF, $8F, $AF, $00, $20, $00, $EF, $10
	db $3E, $3E, $B6, $A2, $BE, $BE, $BE, $94, $B6, $A2, $AA, $00, $18, $04, $F1, $0E
	db $AA, $22, $A6, $24, $A5, $24, $BD, $18, $DA, $00, $A6, $40, $9D, $62, $80, $7F
	db $8A, $68, $AA, $48, $5A, $91, $36, $21, $EC, $C3, $D8, $07, $30, $0F, $00, $FF
	db $DF, $57, $56, $54, $57, $57, $76, $74, $77, $07, $07, $00, $70, $80, $07, $F8
	db $EB, $E3, $CB, $80, $EB, $E3, $CB, $82, $EB, $E3, $EB, $00, $08, $00, $FB, $04
	db $D3, $C2, $C6, $04, $D4, $D4, $D5, $55, $D7, $C7, $C7, $00, $10, $00, $F7, $08
	db $AE, $02, $2A, $0A, $AA, $8A, $AA, $8A, $AA, $02, $22, $00, $68, $10, $C3, $3C
	db $EE, $C6, $F6, $30, $B8, $88, $39, $B0, $3D, $0C, $CD, $00, $91, $60, $87, $78
	db $81, $7D, $81, $7D, $81, $7D, $83, $71, $06, $F7, $07, $F0, $00, $F0, $07, $F8
	db $00, $FF, $00, $07, $F4, $F3, $F4, $13, $34, $23, $6C, $43, $D8, $87, $B0, $0F
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $09, $F1, $09, $F1, $09, $F1, $F9, $F1, $89, $81, $09, $F1, $09, $F1, $09, $F1
	db $60, $1F, $40, $3F, $40, $3F, $40, $3F, $40, $3F, $40, $3F, $40, $3F, $C0, $3F
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $09, $F1, $09, $F1, $09, $F1, $F9, $F1, $89, $81, $09, $F1, $09, $F1, $09, $F1
	db $90, $8F, $90, $8F, $90, $8F, $9F, $8F, $98, $88, $90, $8F, $90, $8F, $90, $8F
	db $90, $8F, $90, $8F, $90, $8F, $9F, $8F, $98, $88, $90, $8F, $90, $8F, $90, $8F
	db $00, $FF, $00, $FF, $00, $F0, $07, $F7, $07, $F0, $00, $F8, $03, $FC, $00, $FF
	db $00, $FF, $00, $E0, $0A, $0A, $EA, $EA, $EA, $00, $00, $00, $FF, $00, $00, $FF
	db $00, $FF, $00, $F8, $86, $06, $BE, $38, $B8, $08, $BE, $3E, $BE, $08, $08, $88
	db $00, $FF, $00, $E3, $0A, $09, $4A, $49, $4A, $49, $4A, $49, $4A, $49, $4A, $49
	db $00, $FF, $00, $00, $7F, $7F, $7F, $44, $44, $44, $7F, $7F, $7F, $44, $44, $44
	db $00, $FF, $00, $1F, $D0, $C0, $D7, $47, $57, $45, $D5, $C5, $D5, $45, $57, $47
	db $00, $FF, $00, $E3, $08, $08, $7F, $7F, $7F, $08, $08, $08, $7F, $7F, $7F, $02
	db $00, $FF, $00, $C0, $1F, $5F, $5B, $11, $5F, $1F, $5B, $11, $5F, $1F, $5F, $10
	db $00, $FF, $00, $01, $7D, $7C, $6D, $44, $7D, $7C, $6D, $44, $7D, $7C, $7D, $04
	db $00, $FF, $00, $FF, $00, $F0, $2F, $CF, $5F, $92, $32, $A2, $6A, $42, $56, $44
	db $00, $FF, $00, $FC, $01, $7D, $A1, $9C, $D0, $4C, $60, $2E, $B0, $14, $D5, $11
	db $00, $FF, $00, $08, $E2, $E2, $FF, $9F, $9F, $92, $95, $85, $EF, $EF, $FD, $B9
	db $00, $FF, $00, $F0, $07, $17, $D7, $C0, $D7, $47, $57, $00, $D7, $C7, $97, $00
	db $00, $FF, $00, $00, $BF, $BF, $BF, $09, $B9, $B9, $BD, $0D, $9D, $91, $B3, $23
	db $00, $FF, $00, $63, $48, $28, $4A, $0A, $5A, $1A, $5F, $05, $4F, $0A, $5E, $1E
	db $00, $FF, $00, $1F, $40, $43, $7A, $79, $FA, $89, $DA, $51, $76, $21, $70, $51
	db $00, $F9, $05, $F4, $0D, $E8, $08, $E8, $0F, $E7, $07, $F0, $00, $F8, $03, $FC
	db $00, $FF, $00, $FF, $00, $FF, $00, $01, $FD, $FC, $FD, $00, $01, $00, $FF, $00
	db $1D, $DC, $1E, $DA, $3A, $A8, $28, $88, $0B, $88, $2A, $C1, $02, $E1, $0E, $F1
	db $4A, $49, $4A, $49, $4A, $48, $4A, $08, $3A, $38, $3A, $80, $02, $80, $3E, $C1
	db $7F, $7F, $7F, $44, $44, $44, $D4, $84, $94, $84, $B4, $00, $21, $10, $E7, $18
	db $D7, $C5, $D5, $45, $55, $45, $57, $47, $D7, $C0, $D0, $00, $10, $0F, $70, $8F
	db $7F, $7F, $7F, $22, $32, $12, $52, $02, $6E, $0E, $4E, $20, $00, $E0, $0F, $F0
	db $53, $13, $53, $12, $53, $13, $D3, $12, $93, $53, $93, $40, $80, $40, $9F, $60
	db $E5, $E4, $65, $24, $E5, $E4, $65, $24, $ED, $EC, $ED, $00, $01, $00, $FF, $00
	db $55, $44, $4D, $48, $4A, $49, $7A, $30, $B5, $01, $4D, $80, $3A, $C4, $00, $FF
	db $15, $D0, $54, $90, $B4, $22, $6C, $42, $D8, $86, $B0, $0E, $60, $1F, $00, $FF
	db $BF, $AF, $AD, $A9, $AF, $AF, $ED, $E9, $EF, $0F, $0F, $00, $E0, $00, $0F, $F0
	db $D7, $C7, $97, $00, $D7, $C7, $97, $04, $D7, $C7, $D7, $00, $10, $00, $F7, $08
	db $A7, $84, $8C, $08, $A9, $A9, $AB, $AB, $AF, $8E, $8E, $00, $20, $00, $EF, $10
	db $5D, $05, $55, $14, $55, $15, $54, $15, $54, $04, $45, $00, $D1, $20, $87, $78
	db $DD, $8C, $ED, $60, $71, $10, $73, $60, $7A, $19, $9A, $01, $22, $C1, $0E, $F1
	db $00, $FF, $00, $00, $7F, $7F, $7F, $00, $00, $00, $7E, $80, $05, $F9, $03, $FA

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
Data_4B_5898::
	INCBIN "gfx/account/screens_bank4b/tilemap_5898.tilemap"
	INCBIN "gfx/account/screens_bank4b/tilemap_5898.attrmap"

; ---- data $5B68-$5B90 (40 bytes) [PROBABLE] 10 x 4-byte entries (tile, tile+$10 pair, attr, attr) = $A7/$B7,$A8/$B8,...,$C0/$C1 with attributes $0A $0A, placed right after the 720-byte tilemap+attr block 5898-5B68 (same shape as the entries at 76C0 after the block 73F0-76C0); entries 5B68, 5B74, 5B7C and following were read by executed code; the use of the entries is not decoded

Table_4B_5B68:: ; 4B:5B68
	db $A7, $B7, $0A, $0A, $A8, $B8, $0A, $0A, $A9, $B9, $0A, $0A, $AA, $BA, $0A, $0A
	db $AB, $BB, $0A, $0A, $AC, $BC, $0A, $0A, $AD, $BD, $0A, $0A, $AE, $BE, $0A, $0A
	db $AF, $BF, $0A, $0A, $C0, $C1, $0A, $0A
