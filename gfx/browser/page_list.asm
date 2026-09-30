; gfx/browser/page_list.asm
; bank 24, $5400-$6BF0 (6128 bytes); pinned by layout.link
; page list tiles, tilemaps, palettes, object tables

SECTION "gfx/browser/page_list", ROMX

; ---- gfx $5400-$55D0 (464 bytes) [PROBABLE] 2bpp tiles by coherence: 29 non-blank tiles, mean adjacent-pixel similarity h=0.67 v=0.50 (random data ~0.25-0.35); part of the 1024-byte block 5400-5800 uploaded by Function_00_0749 (general HDMA start: hl=$5400 a=$24 c=$40 de=$9301) at 24:432C; call site never executed in a trace

PageList_Tiles_5400:: ; 24:5400
Tiles_24_5400::
	db $F0, $00, $EF, $07, $EF, $0F, $EF, $0F, $EF, $0F, $EF, $0F, $EF, $0F, $EF, $0F
	db $00, $00, $FD, $FC, $C1, $81, $BD, $B8, $BC, $28, $6C, $44, $66, $44, $66, $42
	db $00, $00, $DF, $9F, $DF, $5F, $DF, $9F, $3F, $1F, $33, $E1, $ED, $EC, $EE, $62
	db $00, $00, $FF, $FF, $FC, $F8, $FB, $FB, $FB, $F8, $F8, $F8, $FB, $FB, $FB, $78
	db $00, $00, $EB, $EA, $2B, $0A, $CB, $CA, $D6, $04, $16, $14, $D6, $D4, $D6, $14
	db $00, $00, $7F, $7F, $4F, $07, $37, $27, $B7, $27, $B7, $A7, $B7, $A7, $B7, $87
	db $00, $00, $FF, $FF, $90, $00, $67, $47, $67, $40, $60, $40, $60, $4F, $6F, $4F
	db $00, $00, $FF, $FF, $07, $02, $FA, $F2, $FA, $12, $1A, $12, $1A, $D2, $DA, $92
	db $00, $00, $FF, $FF, $3F, $1F, $DF, $9F, $DF, $9F, $DF, $9F, $DF, $9F, $C0, $80
	db $07, $00, $FB, $F0, $FB, $F8, $FB, $F8, $FB, $F8, $FB, $F8, $FB, $F8, $FB, $78
	db $FF, $FF, $FF, $FF, $FF, $FF, $C0, $C0, $FF, $C0, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $00, $00, $FF, $00, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $01, $01, $FF, $01, $FF, $FF, $FF, $FF, $FF, $FF
	db $80, $FF, $5F, $A0, $91, $6E, $F5, $0E, $11, $EE, $DF, $E0, $C0, $FF, $FF, $FF
	db $00, $FF, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $00, $FF, $FF, $FF
	db $07, $FF, $F7, $7F, $F7, $7F, $F7, $7F, $F7, $7F, $F7, $7F, $07, $FF, $FF, $FF
	db $EF, $0F, $EF, $0F, $EF, $0F, $EF, $0F, $EF, $0F, $EF, $0F, $EF, $07, $F0, $00
	db $13, $0A, $1B, $F1, $F9, $FD, $FD, $F8, $FC, $FE, $FE, $FC, $FE, $FF, $00, $00
	db $63, $61, $61, $38, $A0, $24, $D8, $9A, $DC, $9D, $DE, $1E, $1F, $3F, $00, $C0
	db $08, $04, $F0, $F3, $F7, $07, $06, $0C, $05, $F5, $0D, $04, $FC, $FE, $00, $01
	db $16, $34, $16, $C4, $EC, $C8, $18, $11, $F0, $E2, $E1, $05, $03, $0B, $00, $F0
	db $87, $CF, $87, $B6, $FE, $FC, $E1, $C1, $DF, $DE, $DE, $C0, $C0, $E0, $00, $1F
	db $6F, $4F, $6F, $4E, $CE, $8C, $89, $11, $07, $26, $16, $50, $30, $B8, $00, $07
	db $B6, $22, $66, $46, $F6, $A6, $B2, $20, $3C, $1C, $1C, $40, $00, $A3, $00, $1C
	db $FF, $FE, $FF, $80, $C0, $80, $C0, $9F, $DF, $9F, $DF, $1F, $1F, $3F, $00, $C0
	db $7B, $78, $7B, $78, $7B, $F8, $7B, $78, $FB, $F8, $FB, $F8, $FB, $F0, $07, $00
	db $FF, $FF, $FF, $FF, $C0, $C0, $FF, $C0, $FF, $FF, $FF, $FF, $00, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $00, $00, $FF, $00, $FF, $FF, $FF, $FF, $00, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $01, $01, $FF, $01, $FF, $FF, $FF, $FF, $00, $FF, $FF, $FF

; ---- gfx $55D0-$5810 (576 bytes) [PROBABLE] tiles-2bpp: heuristic: 33 coherent tiles (hsim2=0.738 vsim2=0.702, 1 blank) parity 0

Data_24_55D0:: ; 24:55D0
	db $FF, $FF, $FF, $FF, $FF, $FF, $E4, $E4, $FF, $E4, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $92, $92, $FF, $92, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $49, $49, $FF, $49, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $80, $FF, $5F, $A0, $91, $6E, $F5, $0E
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00, $FF, $FF, $01, $FF, $01, $FF, $01
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $07, $FF, $F7, $7F, $F7, $7F, $F7, $7F
	db $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01
	db $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $02
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $00, $80, $7F, $3F, $7C, $40, $7B, $43, $77, $46, $6E, $4C, $1F, $1F, $7F, $5F
	db $00, $01, $FE, $FC, $FE, $00, $7E, $00, $7E, $00, $06, $00, $FA, $F8, $FA, $F8
	db $00, $80, $7F, $3F, $7F, $40, $7F, $7F, $40, $40, $7F, $40, $60, $40, $6F, $4F
	db $00, $01, $FE, $7C, $C6, $44, $C6, $C4, $46, $44, $C6, $46, $82, $82, $46, $44
	db $00, $80, $7F, $3F, $7F, $40, $7F, $40, $77, $40, $7B, $40, $7F, $40, $7F, $40
	db $00, $01, $FE, $FC, $FE, $00, $7E, $00, $76, $00, $EE, $00, $FE, $00, $FE, $00
	db $FB, $06, $F6, $0C, $EC, $18, $E8, $18, $E8, $18, $E8, $18, $E8, $18, $E8, $18
	db $C0, $40, $C0, $60, $A0, $70, $D0, $38, $E8, $18, $E8, $18, $E8, $18, $E8, $18
	db $D0, $30, $A0, $60, $C1, $41, $C1, $41, $C0, $40, $C0, $60, $A0, $70, $D0, $38
	db $FF, $FF, $FF, $FF, $E4, $E4, $FF, $E4, $FF, $FF, $FF, $FF, $00, $FF, $FF, $FF
	db $11, $EE, $DF, $E0, $C0, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $01, $FF, $01, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $F7, $7F, $F7, $7F, $07, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $FE, $FF
	db $FF, $FF, $80, $FF, $80, $FF, $BF, $C0, $BF, $C0, $BF, $C0, $BF, $C0, $BF, $C0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $7F, $5F, $7F, $5F, $7F, $7F, $7F, $5F, $1F, $07, $60, $40, $7F, $00, $00, $80
	db $86, $80, $DE, $80, $9E, $80, $DE, $80, $9E, $00, $3E, $00, $FE, $00, $00, $01
	db $6F, $4F, $6F, $4F, $60, $40, $77, $40, $63, $40, $76, $40, $7F, $00, $00, $80
	db $6E, $28, $5E, $10, $5E, $10, $DE, $10, $5E, $10, $DE, $10, $FE, $00, $00, $01
	db $67, $40, $7F, $40, $7F, $40, $7B, $40, $77, $40, $7F, $40, $7F, $00, $00, $80
	db $F2, $00, $FE, $00, $FE, $00, $EE, $00, $76, $00, $7E, $00, $FE, $00, $00, $01
	db $E8, $18, $E8, $18, $E8, $18, $D8, $30, $B0, $60, $E0, $40, $C1, $41, $C1, $41
	db $D0, $30, $A0, $60, $C1, $41, $C1, $41, $C0, $40, $C0, $60, $A0, $70, $D0, $38
	db $FF, $FF, $FF, $FF, $92, $92, $FF, $92, $FF, $FF, $FF, $FF, $00, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $49, $49, $FF, $49, $FF, $FF, $FF, $FF, $00, $FF, $FF, $FF

PageList_Tiles_5800:: ; 24:5800
	db $FE, $01, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FE, $01, $FD, $03

; ---- gfx $5810-$58B0 (160 bytes) [PROBABLE] 2bpp tiles by coherence: 9 non-blank tiles, mean adjacent-pixel similarity h=0.72 v=0.79 (random data ~0.25-0.35); part of the 256-byte block 5800-5900 uploaded by Function_00_0749 (hl=$5800 a=$24 c=$10 de=$9701) at 24:4341; call site never executed

Tiles_24_5810:: ; 24:5810
	db $80, $C0, $7F, $FF, $80, $7F, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $80, $00
	db $00, $00, $FF, $FF, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $00
	db $01, $03, $FE, $FF, $01, $FE, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $00
	db $7F, $80, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $EF, $F0, $1F, $10
	db $3F, $10, $3F, $10, $3F, $10, $33, $1C, $33, $1C, $33, $1C, $33, $1C, $33, $1C
	db $33, $1C, $33, $1C, $33, $1C, $33, $1C, $33, $1C, $33, $1C, $33, $1C, $33, $1C
	db $33, $1C, $33, $1C, $33, $1C, $33, $1C, $33, $1C, $33, $1C, $FF, $FF, $00, $00
	db $E8, $18, $E8, $18, $E8, $18, $E8, $18, $E8, $18, $E8, $18, $FF, $FF, $00, $00
	db $FC, $80, $FC, $80, $FC, $80, $FC, $80, $FC, $80, $FC, $80, $FC, $80, $FC, $80
	db $FC, $80, $FC, $80, $FC, $80, $FC, $80, $FC, $80, $FC, $80, $FC, $80, $FE, $40

; ---- zero $58B0-$5900 (80 bytes) [HYPOTHESIS] padding? run of 80 x $00 in unclassified bytes
	ds $50, $00

; ---- data $5900-$5BD0 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 24:43A7: hl=$5900 a=$24 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

PageList_Tilemap_5900:: ; 24:5900
Data_24_5900::
	db $63, $53, $55, $55, $55, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $55
	db $55, $55, $53, $63, $64, $54, $55, $55, $55, $40, $41, $42, $43, $44, $45, $46
	db $47, $48, $49, $55, $55, $55, $54, $64, $70, $73, $72, $72, $72, $72, $72, $72
	db $72, $72, $72, $72, $72, $72, $72, $72, $72, $72, $73, $74, $5C, $4D, $4E, $4F
	db $3A, $3B, $3B, $3B, $3B, $3B, $3B, $3B, $3B, $3B, $3B, $3B, $3B, $3B, $3C, $75
	db $6C, $50, $51, $52, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $34, $35, $36, $37
	db $38, $39, $3A, $76, $5D, $60, $61, $62, $40, $41, $42, $43, $44, $45, $46, $47
	db $48, $49, $4A, $4B, $4C, $4D, $4E, $76, $6D, $3D, $3E, $3F, $54, $55, $56, $57
	db $58, $59, $5A, $5B, $5C, $5D, $5E, $5F, $60, $61, $62, $76, $6C, $50, $51, $52
	db $68, $69, $6A, $6B, $6C, $6D, $6E, $6F, $70, $71, $72, $73, $74, $75, $76, $76
	db $5D, $60, $61, $62, $7C, $7D, $7E, $7F, $80, $81, $82, $83, $84, $85, $86, $87
	db $88, $89, $8A, $76, $6D, $3D, $3E, $3F, $90, $91, $92, $93, $94, $95, $96, $97
	db $98, $99, $9A, $9B, $9C, $9D, $9E, $76, $6C, $50, $51, $52, $A4, $A5, $A6, $A7
	db $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF, $B0, $B1, $B2, $76, $5D, $60, $61, $62
	db $B8, $B9, $BA, $BB, $BC, $BD, $BE, $BF, $C0, $C1, $C2, $C3, $C4, $C5, $C6, $76
	db $5E, $3D, $3E, $3F, $CC, $CD, $CE, $CF, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7
	db $D8, $D9, $DA, $76, $78, $5F, $6E, $6F, $4A, $4B, $4B, $4B, $4B, $4B, $4B, $4B
	db $4B, $4B, $4B, $4B, $4B, $4B, $4C, $77, $65, $65, $65, $56, $57, $65, $65, $65
	db $65, $58, $59, $65, $65, $65, $65, $5A, $5B, $65, $65, $65, $65, $65, $65, $66
	db $67, $65, $65, $65, $65, $68, $69, $65, $65, $65, $65, $6A, $6B, $65, $65, $65
	db $00, $01, $02, $03, $28, $29, $2A, $2B, $50, $51, $52, $53, $78, $79, $7A, $7B
	db $A0, $A1, $A2, $A3, $14, $15, $16, $17, $3C, $3D, $3E, $3F, $64, $65, $66, $67
	db $8C, $8D, $8E, $8F, $B4, $B5, $B6, $B7, $09, $29, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $29, $2D, $29, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $0D
	db $0D, $2D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D
	db $0D, $0D, $0D, $0D, $0D, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $0D, $0D, $09, $09, $09, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0D, $0D, $09, $09, $09
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0D
	db $0D, $09, $09, $09, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $0D, $0D, $09, $09, $09, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $0D, $0D, $09, $09, $09, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0D, $0D, $09, $09, $09
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0D
	db $0D, $09, $09, $09, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $0D, $0D, $09, $09, $09, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $0D, $0D, $09, $09, $09, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0D, $0D, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $0D
	db $09, $09, $09, $0B, $0B, $09, $09, $09, $09, $0B, $0B, $09, $09, $09, $09, $0B
	db $0B, $09, $09, $09, $09, $09, $09, $0B, $0B, $09, $09, $09, $09, $0B, $0B, $09
	db $09, $09, $09, $0B, $0B, $09, $09, $09, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04

; ---- data $5BD0-$5EA0 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 24:43C9: hl=$5BD0 a=$24 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

PageList_Tilemap_5BD0:: ; 24:5BD0
Data_24_5BD0::
	db $63, $79, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F, $10, $11
	db $12, $7D, $79, $63, $64, $7A, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F, $20, $21
	db $22, $23, $24, $25, $26, $7D, $7A, $64, $70, $71, $72, $72, $72, $72, $72, $72
	db $72, $72, $72, $72, $72, $72, $72, $72, $72, $72, $73, $74, $5C, $4D, $4E, $4F
	db $3A, $3B, $3B, $3B, $3B, $3B, $3B, $3B, $3B, $3B, $3B, $3B, $3B, $3B, $3C, $75
	db $6C, $50, $51, $52, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $34, $35, $36, $37
	db $38, $39, $3A, $76, $5D, $60, $61, $62, $40, $41, $42, $43, $44, $45, $46, $47
	db $48, $49, $4A, $4B, $4C, $4D, $4E, $76, $6D, $3D, $3E, $3F, $54, $55, $56, $57
	db $58, $59, $5A, $5B, $5C, $5D, $5E, $5F, $60, $61, $62, $76, $6C, $50, $51, $52
	db $68, $69, $6A, $6B, $6C, $6D, $6E, $6F, $70, $71, $72, $73, $74, $75, $76, $76
	db $5D, $60, $61, $62, $7C, $7D, $7E, $7F, $80, $81, $82, $83, $84, $85, $86, $87
	db $88, $89, $8A, $76, $6D, $3D, $3E, $3F, $90, $91, $92, $93, $94, $95, $96, $97
	db $98, $99, $9A, $9B, $9C, $9D, $9E, $76, $6C, $50, $51, $52, $A4, $A5, $A6, $A7
	db $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF, $B0, $B1, $B2, $76, $5D, $60, $61, $62
	db $B8, $B9, $BA, $BB, $BC, $BD, $BE, $BF, $C0, $C1, $C2, $C3, $C4, $C5, $C6, $76
	db $5E, $3D, $3E, $3F, $CC, $CD, $CE, $CF, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7
	db $D8, $D9, $DA, $76, $78, $5F, $6E, $6F, $4A, $4B, $4B, $4B, $4B, $4B, $4B, $4B
	db $4B, $4B, $4B, $4B, $4B, $4B, $4C, $77, $65, $65, $65, $56, $57, $65, $65, $65
	db $65, $58, $59, $65, $65, $65, $65, $5A, $5B, $65, $65, $65, $65, $65, $65, $66
	db $67, $65, $65, $65, $65, $68, $69, $65, $65, $65, $65, $6A, $6B, $65, $65, $65
	db $00, $01, $02, $03, $28, $29, $2A, $2B, $50, $51, $52, $53, $78, $79, $7A, $7B
	db $A0, $A1, $A2, $A3, $14, $15, $16, $17, $3C, $3D, $3E, $3F, $64, $65, $66, $67
	db $8C, $8D, $8E, $8F, $B4, $B5, $B6, $B7, $09, $09, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $09, $29, $29, $2D, $09, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $09, $29, $0D
	db $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D
	db $0D, $0D, $0D, $0D, $0D, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $0D, $0D, $09, $09, $09, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0D, $0D, $09, $09, $09
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0D
	db $0D, $09, $09, $09, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $0D, $0D, $09, $09, $09, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $0D, $0D, $09, $09, $09, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0D, $0D, $09, $09, $09
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0D
	db $0D, $09, $09, $09, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $0D, $0D, $09, $09, $09, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $0D, $0D, $09, $09, $09, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0D, $0D, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $0D
	db $09, $09, $09, $0B, $0B, $09, $09, $09, $09, $0B, $0B, $09, $09, $09, $09, $0B
	db $0B, $09, $09, $09, $09, $09, $09, $0B, $0B, $09, $09, $09, $09, $0B, $0B, $09
	db $09, $09, $09, $0B, $0B, $09, $09, $09, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04

; ---- data $5EA0-$5EE0 (64 bytes) [PROBABLE] 64-byte RGB555 palette block copied by Function_4F_4000 (-> 00:050C copy; hl=$5EA0 a=$24 bc=$0040 de=$D800, WRAM7 BG palette buffer) at 24:4393; call site never executed; replaces the mapper palette guess 5EC6-5EDE

PageList_BgPalette:: ; 24:5EA0
Palette_24_5EA0::
	db $FF, $7F, $FF, $01, $FF, $7F, $00, $00, $20, $7D, $6D, $7A, $00, $00, $FF, $7F
	db $FF, $01, $FF, $7F, $00, $00, $FF, $7F, $80, $40, $41, $7D, $20, $7D, $6F, $7F
	db $00, $00, $BD, $01, $20, $7D, $FF, $7F, $FF, $7F, $F4, $57, $E0, $02, $00, $00
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F

; ---- gfx $5EE0-$5EF1 (17 bytes) [PROBABLE] 2bpp tiles (too few non-blank tiles to score); first bytes of the 1024-byte block 5EE0-62E0 uploaded by Function_00_0749 (hl=$5EE0 a=$24 c=$40 de=$8000) at 24:4356; call site never executed

PageList_Tiles_5EE0:: ; 24:5EE0
Tiles_24_5EE0::
	db $FF, $FF, $FF, $8A, $FF, $FF, $FF, $8B, $FF, $FA, $FB, $F7, $F5, $8D, $F8, $F8
	db $BE

; ---- gfx $5EF1-$6301 (1040 bytes) [PROBABLE] tiles-2bpp: heuristic: 45 coherent tiles (hsim2=0.655 vsim2=0.638, 7 blank) parity 1

Data_24_5EF1:: ; 24:5EF1
	db $BE, $BF, $A3, $FF, $FF, $FF, $7E, $FF, $1E, $FE, $5D, $FD, $63, $FE, $FE, $1F
	db $1F, $FF, $F1, $FF, $05, $FF, $F1, $FE, $F6, $F4, $EC, $E8, $98, $F0, $F0, $F8
	db $F8, $F8, $88, $F0, $B0, $E0, $A0, $C0, $C0, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $1F, $1F, $28, $3F, $5B, $7F, $42, $7E, $3B, $3F, $08, $0F, $0F, $0F, $00
	db $00, $FF, $FF, $00, $FF, $80, $FF, $80, $FF, $80, $FF, $00, $FF, $FF, $FF, $00
	db $00, $FE, $FE, $5E, $A2, $5E, $A2, $5E, $A2, $5E, $A2, $5E, $A2, $FE, $FE, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $38, $38, $44, $7C, $BB, $FF, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $3F, $3F, $7F, $40, $E1, $9E, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $C0, $40, $00
	db $00, $00, $00, $0F, $0F, $13, $1E, $2A, $3F, $5A, $7F, $4A, $6F, $8A, $EF, $7F
	db $7F, $C0, $BF, $BF, $7F, $40, $FF, $80, $FF, $80, $FF, $80, $FF, $80, $FF, $80
	db $80, $C0, $40, $60, $A0, $B0, $D0, $50, $F0, $50, $F0, $50, $F0, $50, $F0, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $38
	db $38, $7F, $6F, $7F, $40, $7F, $6E, $3F, $2D, $3F, $2F, $2F, $30, $1F, $1F, $00
	db $00, $83, $83, $83, $82, $FF, $FF, $FF, $83, $FF, $FF, $81, $81, $81, $81, $7C
	db $7C, $FC, $D4, $EC, $14, $FC, $EC, $F8, $E8, $E8, $D8, $D0, $30, $E0, $E0, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1C
	db $1C, $22, $3E, $5D, $7F, $A9, $EF, $B6, $FF, $4A, $7B, $32, $33, $02, $03, $3F
	db $3F, $C0, $FF, $3F, $FF, $40, $FF, $80, $FF, $80, $FF, $B0, $FF, $B0, $DF, $00
	db $00, $C0, $C0, $20, $E0, $A0, $E0, $50, $F0, $50, $F0, $50, $F0, $50, $F0, $A5
	db $E7, $A5, $E7, $A1, $E7, $5B, $7F, $25, $3D, $19, $19, $03, $03, $02, $03, $9E
	db $7F, $21, $FF, $40, $FF, $40, $FF, $40, $FF, $40, $FF, $40, $FF, $80, $FF, $60
	db $A0, $20, $E0, $A0, $E0, $A0, $E0, $A0, $E0, $A0, $E0, $A0, $E0, $50, $F0, $AA
	db $EF, $AA, $EF, $A6, $EF, $96, $FF, $4A, $7B, $32, $33, $02, $03, $02, $03, $80
	db $FF, $80, $FF, $80, $FF, $80, $FF, $B0, $FF, $B0, $DF, $80, $FF, $80, $FF, $50
	db $F0, $50, $F0, $50, $F0, $50, $F0, $50, $F0, $50, $F0, $50, $F0, $50, $F0, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $77
	db $77, $7F, $5D, $7F, $50, $7F, $5D, $77, $55, $7F, $5D, $7D, $5B, $7F, $7F, $00
	db $00, $81, $81, $81, $81, $81, $81, $00, $00, $00, $00, $00, $00, $00, $00, $1C
	db $1C, $FE, $F6, $FE, $02, $FE, $D6, $7C, $44, $7C, $74, $74, $4C, $78, $78, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7D
	db $07, $7D, $07, $7D, $07, $7D, $07, $7F, $0F, $7F, $08, $7C, $07, $7F, $03, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $FF, $FF, $00, $00, $FF, $FF, $FF, $2F
	db $F8, $2F, $F8, $2F, $F8, $2F, $F8, $FF, $FC, $FF, $04, $2F, $D8, $FF, $F0, $7E
	db $03, $7E, $03, $7E, $03, $7E, $03, $7E, $07, $7F, $05, $7C, $07, $7F, $07, $80
	db $FF, $B0, $FF, $B0, $DF, $80, $FF, $80, $FF, $80, $FF, $FF, $00, $FF, $FF, $5F
	db $F0, $5F, $F0, $5F, $F0, $5F, $F0, $5F, $F8, $7F, $E8, $CF, $38, $FF, $F8, $7E
	db $03, $7E, $03, $7E, $03, $7E, $03, $7E, $07, $7F, $04, $7C, $07, $7F, $07, $80
	db $FF, $80, $FF, $80, $FF, $80, $FF, $80, $FF, $80, $FF, $FF, $00, $FF, $FF, $5F
	db $F0, $5F, $F0, $5F, $F0, $5F, $F0, $5F, $F8, $7F, $C8, $CF, $38, $FF, $F8, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $07, $07, $0B, $0E, $16, $1F, $2A, $3F, $2A, $3F, $00
	db $00, $7F, $7F, $C0, $BF, $BF, $7F, $40, $FF, $80, $FF, $80, $FF, $80, $FF, $00
	db $00, $80, $80, $C0, $40, $60, $A0, $B0, $D0, $50, $F0, $50, $F0, $50, $F0, $00
	db $00, $1F, $1F, $28, $3F, $5B, $7F, $42, $7E, $3B, $3F, $08, $0F, $0F, $0F, $00
	db $00, $FF, $FF, $00, $FF, $80, $FF, $80, $FF, $80, $FF, $00, $FF, $FF, $FF, $00
	db $00, $FE, $FE, $5E, $A2, $5E, $A2, $5E, $A2, $5E, $A2, $5E, $A2, $FE, $FE, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $38, $38, $44, $7C, $BA, $FE, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $1F, $1F, $3F, $20, $F0, $CF, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $C0, $40, $E0, $20, $00
	db $00, $00, $00, $00, $00, $0E, $0F, $11, $1F, $2D, $3F, $59, $7F, $4B, $6F, $00
	db $00, $3F, $7F, $60, $DF, $DF, $BF, $BD, $67, $7A, $CF, $7A, $CF, $74, $DF, $00
	db $00, $C0, $E0, $60, $B0, $B0, $D8, $58, $E8, $28, $F8, $28, $F8, $28, $F8, $00
	db $00, $00, $00, $00, $01, $01, $03, $1F, $02, $3B, $07, $6C, $1F, $52, $3D, $00
	db $00, $7F, $FF, $80, $FF, $BF, $7F, $7F, $80, $F7, $F9, $2D, $DF, $F7, $0B, $00
	db $00, $80, $C0, $F8, $7C, $BC, $C6, $8E, $F2, $06, $FA, $06, $FA, $06, $FA, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

PageList_Tiles_62E0:: ; 24:62E0
	db $5A, $7F, $52, $77, $52, $77, $52, $77, $5A, $7F, $26, $3F, $1A, $1B, $02, $03
	db $80, $FF, $80, $FF, $80, $FF, $80, $FF, $80, $FF, $B0, $FF, $B0, $DF, $80, $FF
	db $50

; ---- gfx $6301-$63D0 (207 bytes) [PROBABLE] 2bpp tiles by coherence: 12 non-blank tiles, mean adjacent-pixel similarity h=0.49 v=0.75 (random data ~0.25-0.35); inside block 62E0-64E0 uploaded by Function_00_0749 (hl=$62E0 a=$24 c=$20 de=$8400) at 24:436B; call site never executed

Tiles_24_6301:: ; 24:6301
	db $F0, $50, $F0, $50, $F0, $50, $F0, $50, $F0, $50, $F0, $50, $F0, $50, $F0, $1C
	db $1C, $22, $3E, $5D, $7F, $A9, $EF, $B6, $FF, $4A, $7B, $32, $33, $02, $03, $3F
	db $3F, $C0, $FF, $3F, $FF, $40, $FF, $80, $FF, $80, $FF, $B0, $FF, $B0, $DF, $00
	db $00, $C0, $C0, $20, $E0, $A0, $E0, $50, $F0, $50, $F0, $50, $F0, $50, $F0, $A9
	db $EF, $A4, $E7, $A4, $E7, $59, $7F, $23, $3F, $1D, $1D, $01, $01, $01, $01, $CF
	db $BF, $90, $FF, $A0, $FF, $A0, $FF, $A0, $FF, $A0, $FF, $A0, $FF, $40, $FF, $30
	db $D0, $90, $F0, $50, $F0, $50, $F0, $50, $F0, $50, $F0, $50, $F0, $28, $F8, $4B
	db $6F, $AB, $EF, $AB, $EF, $AB, $EF, $B5, $FD, $49, $79, $31, $31, $01, $01, $74
	db $DF, $74, $DF, $74, $DF, $74, $DF, $74, $DF, $75, $DF, $75, $DE, $74, $DF, $28
	db $F8, $28, $F8, $28, $F8, $28, $F8, $28, $F8, $A8, $F8, $A8, $F8, $28, $F8, $21
	db $7E, $41, $7E, $42, $FD, $86, $F9, $85, $FA, $8B, $F4, $DF, $A0, $8F, $F0, $F1
	db $0F, $F9, $07, $F9, $07, $FD, $03, $FB, $05, $F9, $07, $FD, $03, $FD, $03, $06
	db $FA, $06, $FA, $06, $FA, $06, $FA, $07, $FB, $05, $FB, $07, $FB, $06, $FA

; ---- zero $63D0-$63E0 (16 bytes) [HYPOTHESIS] padding? run of 16 x $00 in unclassified bytes
	ds $10, $00

; ---- gfx $63E0-$64E0 (256 bytes) [PROBABLE] 2bpp tiles by coherence: 15 non-blank tiles, mean adjacent-pixel similarity h=0.61 v=0.72 (random data ~0.25-0.35); inside block 62E0-64E0 uploaded by Function_00_0749 (hl=$62E0 a=$24 c=$20 de=$8400) at 24:436B; call site never executed

Tiles_24_63E0:: ; 24:63E0
	db $7E, $03, $7E, $03, $7E, $03, $7E, $03, $7E, $07, $7F, $04, $7C, $07, $7F, $07
	db $80, $FF, $80, $FF, $80, $FF, $80, $FF, $80, $FF, $80, $FF, $FF, $00, $FF, $FF
	db $5F, $F0, $5F, $F0, $5F, $F0, $5F, $F0, $5F, $F8, $7F, $C8, $CF, $38, $FF, $F8
	db $7D, $07, $7D, $07, $7D, $07, $7D, $07, $7F, $0F, $7F, $08, $7C, $07, $7F, $03
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $FF, $FF, $00, $00, $FF, $FF, $FF
	db $2F, $F8, $2F, $F8, $2F, $F8, $2F, $F8, $FF, $FC, $FF, $04, $2F, $D8, $FF, $F0
	db $7F, $01, $7F, $01, $7F, $01, $7F, $01, $7F, $03, $7F, $02, $7E, $03, $7F, $03
	db $40, $FF, $58, $FF, $58, $EF, $40, $FF, $40, $FF, $FF, $C0, $7F, $80, $FF, $FF
	db $2F, $F8, $2F, $F8, $2F, $F8, $2F, $F8, $2F, $FC, $FF, $34, $E7, $1C, $FF, $FC
	db $7F, $01, $7F, $01, $7F, $01, $7F, $01, $7F, $03, $7F, $02, $7E, $03, $7F, $03
	db $74, $DF, $74, $DF, $74, $DF, $74, $DF, $74, $DF, $F4, $5F, $7F, $97, $FF, $FF
	db $2F, $F8, $2F, $F8, $2F, $F8, $2F, $F8, $2F, $FC, $FF, $E4, $E7, $1C, $FF, $FC
	db $67, $D8, $5F, $60, $2E, $71, $57, $38, $6D, $1E, $7B, $07, $7C, $07, $7F, $07
	db $F9, $07, $3B, $C5, $37, $C9, $FF, $03, $ED, $1F, $F7, $F9, $01, $FF, $FF, $FF
	db $07, $FA, $07, $FA, $07, $FA, $07, $FA, $07, $FA, $07, $FA, $07, $FA, $FF, $FE
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- data $64E0-$6520 (64 bytes) [PROBABLE] 64-byte RGB555 palette block copied by Function_4F_4000 (hl=$64E0 a=$24 bc=$0040 de=$D840, WRAM7 OBJ palette buffer) at 24:437F; call site never executed; replaces the mapper guess 64DC-65EC (136 words) which swallowed the sprite tables below

PageList_ObjPalette:: ; 24:64E0
Palette_24_64E0::
	db $BF, $18, $FF, $7F, $6D, $7A, $00, $00, $E0, $7F, $FF, $7F, $20, $03, $00, $00
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $E0, $7F, $FF, $7F, $CE, $39, $00, $00, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F

; ---- data $6520-$6530 (16 bytes) [HYPOTHESIS] 16 bytes = 4 x the pair $6E50/$6E76; same 4x-repeated row shape as the object-table rows at 6530+, but the targets fall inside tile data (6BF0-6FF0) so it is not one of them; meaning unknown

Data_24_6520:: ; 24:6520
	db $50, $6E, $76, $6E, $50, $6E, $76, $6E, $50, $6E, $76, $6E, $50, $6E, $76, $6E

; ---- words $6530-$65C0 (144 bytes) [PROBABLE] sprite object table: 4-byte entries (frame-table ptr, animation-script ptr) indexed by B&7F, the layout read by init_object_from_table 00:0A82/00:0AB8; rows of 16 bytes = the same entry repeated 4 times; base $6530 is passed as de with a=$24 at call sites listed in analysis/gfx_candidates.tsv (object-table); entries 65C0/667A 65C0/667A 65C0/667A 65C0/667A

PageList_ObjTable:: ; 24:6530
Table_24_6530::
	dw Table_24_65C0, Data_24_667A, Table_24_65C0, Data_24_667A, Table_24_65C0, Data_24_667A, Table_24_65C0, Data_24_667A
	dw Table_24_6698, Data_24_6752, Table_24_6698, Data_24_6752, Table_24_6698, Data_24_6752, Table_24_6698, Data_24_6752
	dw Table_24_6686, Data_24_6695, Table_24_6686, Data_24_6695, Table_24_6686, Data_24_6695, Table_24_6686, Data_24_6695
	dw Table_24_675E, Data_24_676D, Table_24_675E, Data_24_676D, Table_24_675E, Data_24_676D, Table_24_675E, Data_24_676D
	dw Table_24_6B19, Data_24_6B57, Table_24_6B19, Data_24_6B57, Table_24_6B19, Data_24_6B57, Table_24_6B19, Data_24_6B57
	dw Table_24_6B5C, Data_24_6B9A, Table_24_6B5C, Data_24_6B9A, Table_24_6B5C, Data_24_6B9A, Table_24_6B5C, Data_24_6B9A
	dw Table_24_6B9F, Data_24_6BDD, Table_24_6B9F, Data_24_6BDD, Table_24_6B9F, Data_24_6BDD, Table_24_6B9F, Data_24_6BDD
	dw Table_24_6770, Data_24_685D, Table_24_6770, Data_24_685D, Table_24_6770, Data_24_685D, Table_24_6770, Data_24_685D
	dw Table_24_686D, Data_24_6975, Table_24_686D, Data_24_6975, Table_24_686D, Data_24_6975, Table_24_686D, Data_24_6975

; ---- words $65C0-$65CC (12 bytes) [PROBABLE] sprite frame table: 6 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_65C0:: ; 24:65C0
	dw Data_24_65CC, Data_24_65D9, Data_24_65F2, Data_24_6617, Data_24_663C, Data_24_6661

; ---- data $65CC-$65D9 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Data_24_65CC:: ; 24:65CC
	db $03, $00, $00, $33, $01, $00, $08, $34, $01, $00, $10, $35, $01

; ---- data $65D9-$65F2 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_24_65D9:: ; 24:65D9
	db $06, $F8, $00, $43, $01, $F8, $08, $44, $01, $F8, $10, $45, $01, $00, $00, $53
	db $01, $00, $08, $54, $01, $00, $10, $55, $01

; ---- data $65F2-$6617 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_65F2:: ; 24:65F2
	db $09, $F0, $00, $36, $01, $F0, $08, $37, $01, $F0, $10, $38, $01, $F8, $00, $46
	db $01, $F8, $08, $47, $01, $F8, $10, $48, $01, $00, $00, $56, $01, $00, $08, $57
	db $01, $00, $10, $58, $01

; ---- data $6617-$663C (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_6617:: ; 24:6617
	db $09, $F0, $00, $39, $01, $F0, $08, $3A, $01, $F0, $10, $3B, $01, $F8, $00, $49
	db $01, $F8, $08, $4A, $01, $F8, $10, $4B, $01, $00, $00, $59, $01, $00, $08, $5A
	db $01, $00, $10, $5B, $01

; ---- data $663C-$6661 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_663C:: ; 24:663C
	db $09, $F0, $00, $3C, $01, $F0, $08, $3D, $01, $F0, $10, $3E, $01, $F8, $00, $4C
	db $01, $F8, $08, $4D, $01, $F8, $10, $4E, $01, $00, $00, $5C, $01, $00, $08, $5D
	db $01, $00, $10, $5E, $01

; ---- data $6661-$667A (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_24_6661:: ; 24:6661
	db $06, $F8, $00, $43, $01, $F8, $08, $44, $01, $F8, $10, $45, $01, $00, $00, $53
	db $01, $00, $08, $54, $01, $00, $10, $55, $01

; ---- data $667A-$6685 (11 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 5 step(s), (frame,delay) pairs: 0:5 1:2 2:4 3:5 4:5

Data_24_667A:: ; 24:667A
	db $05, $00, $05, $01, $02, $02, $04, $03, $05, $04, $05

; ---- zero $6685-$6686 (1 bytes) [PROBABLE] alignment padding byte(s) between sprite script and the following word table (frame tables sit at even addresses)
	ds $1, $00

; ---- words $6686-$6688 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_6686:: ; 24:6686
	dw Data_24_6688

; ---- data $6688-$6695 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Data_24_6688:: ; 24:6688
	db $03, $00, $00, $33, $01, $00, $08, $34, $01, $00, $10, $35, $01

; ---- data $6695-$6698 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_24_6695:: ; 24:6695
	db $01, $00, $04

; ---- words $6698-$66A4 (12 bytes) [PROBABLE] sprite frame table: 6 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_6698:: ; 24:6698
	dw Data_24_66A4, Data_24_66B1, Data_24_66CA, Data_24_66EF, Data_24_6714, Data_24_6739

; ---- data $66A4-$66B1 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Data_24_66A4:: ; 24:66A4
	db $03, $00, $00, $06, $00, $00, $08, $07, $00, $00, $10, $08, $00

; ---- data $66B1-$66CA (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_24_66B1:: ; 24:66B1
	db $06, $F8, $00, $16, $00, $F8, $08, $17, $00, $F8, $10, $18, $00, $00, $00, $26
	db $00, $00, $08, $27, $00, $00, $10, $28, $00

; ---- data $66CA-$66EF (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_66CA:: ; 24:66CA
	db $09, $F0, $00, $09, $00, $F0, $08, $0A, $00, $F0, $10, $0B, $00, $F8, $00, $19
	db $00, $F8, $08, $1A, $00, $F8, $10, $1B, $00, $00, $00, $29, $00, $00, $08, $2A
	db $00, $00, $10, $2B, $00

; ---- data $66EF-$6714 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_66EF:: ; 24:66EF
	db $09, $F0, $00, $0C, $00, $F0, $08, $0D, $00, $F0, $10, $0E, $00, $F8, $00, $1C
	db $00, $F8, $08, $1D, $00, $F8, $10, $1E, $00, $00, $00, $2C, $00, $00, $08, $2D
	db $00, $00, $10, $2E, $00

; ---- data $6714-$6739 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_6714:: ; 24:6714
	db $09, $F0, $00, $30, $00, $F0, $08, $31, $00, $F0, $10, $32, $00, $F8, $00, $40
	db $00, $F8, $08, $41, $00, $F8, $10, $42, $00, $00, $00, $50, $00, $00, $08, $51
	db $00, $00, $10, $52, $00

; ---- data $6739-$6752 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_24_6739:: ; 24:6739
	db $06, $F8, $00, $16, $00, $F8, $08, $17, $00, $F8, $10, $18, $00, $00, $00, $26
	db $00, $00, $08, $27, $00, $00, $10, $28, $00

; ---- data $6752-$675D (11 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 5 step(s), (frame,delay) pairs: 0:5 1:3 2:5 3:3 4:5

Data_24_6752:: ; 24:6752
	db $05, $00, $05, $01, $03, $02, $05, $03, $03, $04, $05

; ---- zero $675D-$675E (1 bytes) [PROBABLE] alignment padding byte(s) between sprite script and the following word table (frame tables sit at even addresses)
	ds $1, $00

; ---- words $675E-$6760 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_675E:: ; 24:675E
	dw Data_24_6760

; ---- data $6760-$676D (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Data_24_6760:: ; 24:6760
	db $03, $00, $00, $06, $00, $00, $08, $07, $00, $00, $10, $08, $00

; ---- data $676D-$6770 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_24_676D:: ; 24:676D
	db $01, $00, $04

; ---- words $6770-$677E (14 bytes) [PROBABLE] sprite frame table: 7 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_6770:: ; 24:6770
	dw Data_24_677E, Data_24_67A3, Data_24_67C8, Data_24_67D5, Data_24_67EE, Data_24_6813, Data_24_6838

; ---- data $677E-$67A3 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_677E:: ; 24:677E
	db $09, $F0, $00, $30, $00, $F0, $08, $31, $00, $F0, $10, $32, $00, $F8, $00, $40
	db $00, $F8, $08, $41, $00, $F8, $10, $42, $00, $00, $00, $50, $00, $00, $08, $51
	db $00, $00, $10, $52, $00

; ---- data $67A3-$67C8 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_67A3:: ; 24:67A3
	db $09, $F0, $00, $09, $00, $F0, $08, $0A, $00, $F0, $10, $0B, $00, $F8, $00, $19
	db $00, $F8, $08, $1A, $00, $F8, $10, $1B, $00, $00, $00, $29, $00, $00, $08, $2A
	db $00, $00, $10, $2B, $00

; ---- data $67C8-$67D5 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Data_24_67C8:: ; 24:67C8
	db $03, $00, $00, $33, $01, $00, $08, $34, $01, $00, $10, $35, $01

; ---- data $67D5-$67EE (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_24_67D5:: ; 24:67D5
	db $06, $F8, $00, $43, $01, $F8, $08, $44, $01, $F8, $10, $45, $01, $00, $00, $53
	db $01, $00, $08, $54, $01, $00, $10, $55, $01

; ---- data $67EE-$6813 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_67EE:: ; 24:67EE
	db $09, $F0, $00, $36, $01, $F0, $08, $37, $01, $F0, $10, $38, $01, $F8, $00, $46
	db $01, $F8, $08, $47, $01, $F8, $10, $48, $01, $00, $00, $56, $01, $00, $08, $57
	db $01, $00, $10, $58, $01

; ---- data $6813-$6838 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_6813:: ; 24:6813
	db $09, $F0, $00, $39, $01, $F0, $08, $3A, $01, $F0, $10, $3B, $01, $F8, $00, $49
	db $01, $F8, $08, $4A, $01, $F8, $10, $4B, $01, $00, $00, $59, $01, $00, $08, $5A
	db $01, $00, $10, $5B, $01

; ---- data $6838-$685D (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_6838:: ; 24:6838
	db $09, $F0, $00, $3C, $01, $F0, $08, $3D, $01, $F0, $10, $3E, $01, $F8, $00, $4C
	db $01, $F8, $08, $4D, $01, $F8, $10, $4E, $01, $00, $00, $5C, $01, $00, $08, $5D
	db $01, $00, $10, $5E, $01

; ---- data $685D-$686C (15 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 7 step(s), (frame,delay) pairs: 0:5 1:8 2:10 3:8 4:8 5:8 6:5

Data_24_685D:: ; 24:685D
	db $07, $00, $05, $01, $08, $02, $0A, $03, $08, $04, $08, $05, $08, $06, $05

; ---- zero $686C-$686D (1 bytes) [PROBABLE] alignment padding byte(s) between sprite script and the following word table (frame tables sit at even addresses)
	ds $1, $00

; ---- words $686D-$687D (16 bytes) [PROBABLE] sprite frame table: 8 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_686D:: ; 24:686D
	dw Data_24_687D, Data_24_68A2, Data_24_68C7, Data_24_68E0, Data_24_68ED, Data_24_6906, Data_24_692B, Data_24_6950

; ---- data $687D-$68A2 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_687D:: ; 24:687D
	db $09, $F0, $00, $3C, $01, $F0, $08, $3D, $01, $F0, $10, $3E, $01, $F8, $00, $4C
	db $01, $F8, $08, $4D, $01, $F8, $10, $4E, $01, $00, $00, $5C, $01, $00, $08, $5D
	db $01, $00, $10, $5E, $01

; ---- data $68A2-$68C7 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_68A2:: ; 24:68A2
	db $09, $F0, $00, $39, $01, $F0, $08, $3A, $01, $F0, $10, $3B, $01, $F8, $00, $49
	db $01, $F8, $08, $4A, $01, $F8, $10, $4B, $01, $00, $00, $59, $01, $00, $08, $5A
	db $01, $00, $10, $5B, $01

; ---- data $68C7-$68E0 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_24_68C7:: ; 24:68C7
	db $06, $F8, $00, $43, $01, $F8, $08, $44, $01, $F8, $10, $45, $01, $00, $00, $53
	db $01, $00, $08, $54, $01, $00, $10, $55, $01

; ---- data $68E0-$68ED (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Data_24_68E0:: ; 24:68E0
	db $03, $00, $00, $06, $00, $00, $08, $07, $00, $00, $10, $08, $00

; ---- data $68ED-$6906 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_24_68ED:: ; 24:68ED
	db $06, $F8, $00, $16, $00, $F8, $08, $17, $00, $F8, $10, $18, $00, $00, $00, $26
	db $00, $00, $08, $27, $00, $00, $10, $28, $00

; ---- data $6906-$692B (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_6906:: ; 24:6906
	db $09, $F0, $00, $09, $00, $F0, $08, $0A, $00, $F0, $10, $0B, $00, $F8, $00, $19
	db $00, $F8, $08, $1A, $00, $F8, $10, $1B, $00, $00, $00, $29, $00, $00, $08, $2A
	db $00, $00, $10, $2B, $00

; ---- data $692B-$6950 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_692B:: ; 24:692B
	db $09, $F0, $00, $0C, $00, $F0, $08, $0D, $00, $F0, $10, $0E, $00, $F8, $00, $1C
	db $00, $F8, $08, $1D, $00, $F8, $10, $1E, $00, $00, $00, $2C, $00, $00, $08, $2D
	db $00, $00, $10, $2E, $00

; ---- data $6950-$6975 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_6950:: ; 24:6950
	db $09, $F0, $00, $30, $00, $F0, $08, $31, $00, $F0, $10, $32, $00, $F8, $00, $40
	db $00, $F8, $08, $41, $00, $F8, $10, $42, $00, $00, $00, $50, $00, $00, $08, $51
	db $00, $00, $10, $52, $00

; ---- data $6975-$6986 (17 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 8 step(s), (frame,delay) pairs: 0:5 1:8 2:8 3:10 4:8 5:8 6:8 7:5

Data_24_6975:: ; 24:6975
	db $08, $00, $05, $01, $08, $02, $08, $03, $0A, $04, $08, $05, $08, $06, $08, $07
	db $05

; ---- data $6986-$6995 (15 bytes) [HYPOTHESIS] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 7 step(s), (frame,delay) pairs: 0:48 1:5 2:5 3:5 4:5 5:5 6:48; not named by a known object-table row: found because the gap between neighbours equals exactly this script (+ pad)

Data_24_6986:: ; 24:6986
	db $07, $00, $30, $01, $05, $02, $05, $03, $05, $04, $05, $05, $05, $06, $30

; ---- words $6995-$69A1 (12 bytes) [PROBABLE] sprite frame table: 6 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_6995:: ; 24:6995
	dw Data_24_69A1, Data_24_69AE, Data_24_69C7, Data_24_69EC, Data_24_6A11, Data_24_6A36

; ---- data $69A1-$69AE (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Data_24_69A1:: ; 24:69A1
	db $03, $00, $00, $33, $01, $00, $08, $34, $01, $00, $10, $35, $01

; ---- data $69AE-$69C7 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_24_69AE:: ; 24:69AE
	db $06, $F8, $00, $43, $01, $F8, $08, $44, $01, $F8, $10, $45, $01, $00, $00, $53
	db $01, $00, $08, $54, $01, $00, $10, $55, $01

; ---- data $69C7-$69EC (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_69C7:: ; 24:69C7
	db $09, $F0, $00, $36, $01, $F0, $08, $37, $01, $F0, $10, $38, $01, $F8, $00, $46
	db $01, $F8, $08, $47, $01, $F8, $10, $48, $01, $00, $00, $56, $01, $00, $08, $57
	db $01, $00, $10, $58, $01

; ---- data $69EC-$6A11 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_69EC:: ; 24:69EC
	db $09, $F0, $00, $39, $01, $F0, $08, $3A, $01, $F0, $10, $3B, $01, $F8, $00, $49
	db $01, $F8, $08, $4A, $01, $F8, $10, $4B, $01, $00, $00, $59, $01, $00, $08, $5A
	db $01, $00, $10, $5B, $01

; ---- data $6A11-$6A36 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_6A11:: ; 24:6A11
	db $09, $F0, $00, $3C, $01, $F0, $08, $3D, $01, $F0, $10, $3E, $01, $F8, $00, $4C
	db $01, $F8, $08, $4D, $01, $F8, $10, $4E, $01, $00, $00, $5C, $01, $00, $08, $5D
	db $01, $00, $10, $5E, $01

; ---- data $6A36-$6A4F (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_24_6A36:: ; 24:6A36
	db $06, $F8, $00, $43, $01, $F8, $08, $44, $01, $F8, $10, $45, $01, $00, $00, $53
	db $01, $00, $08, $54, $01, $00, $10, $55, $01

; ---- data $6A4F-$6A56 (7 bytes) [HYPOTHESIS] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 3 step(s), (frame,delay) pairs: 4:5 1:5 0:5; not named by a known object-table row: found because the gap between neighbours equals exactly this script (+ pad)

Data_24_6A4F:: ; 24:6A4F
	db $03, $04, $05, $01, $05, $00, $05

; ---- zero $6A56-$6A57 (1 bytes) [PROBABLE] alignment padding byte(s) between sprite script and the following word table (frame tables sit at even addresses)
	ds $1, $00

; ---- words $6A57-$6A63 (12 bytes) [PROBABLE] sprite frame table: 6 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_6A57:: ; 24:6A57
	dw Data_24_6A63, Data_24_6A70, Data_24_6A89, Data_24_6AAE, Data_24_6AD3, Data_24_6AF8

; ---- data $6A63-$6A70 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Data_24_6A63:: ; 24:6A63
	db $03, $00, $00, $06, $00, $00, $08, $07, $00, $00, $10, $08, $00

; ---- data $6A70-$6A89 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_24_6A70:: ; 24:6A70
	db $06, $F8, $00, $16, $00, $F8, $08, $17, $00, $F8, $10, $18, $00, $00, $00, $26
	db $00, $00, $08, $27, $00, $00, $10, $28, $00

; ---- data $6A89-$6AAE (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_6A89:: ; 24:6A89
	db $09, $F0, $00, $09, $00, $F0, $08, $0A, $00, $F0, $10, $0B, $00, $F8, $00, $19
	db $00, $F8, $08, $1A, $00, $F8, $10, $1B, $00, $00, $00, $29, $00, $00, $08, $2A
	db $00, $00, $10, $2B, $00

; ---- data $6AAE-$6AD3 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_6AAE:: ; 24:6AAE
	db $09, $F0, $00, $0C, $00, $F0, $08, $0D, $00, $F0, $10, $0E, $00, $F8, $00, $1C
	db $00, $F8, $08, $1D, $00, $F8, $10, $1E, $00, $00, $00, $2C, $00, $00, $08, $2D
	db $00, $00, $10, $2E, $00

; ---- data $6AD3-$6AF8 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_6AD3:: ; 24:6AD3
	db $09, $F0, $00, $30, $00, $F0, $08, $31, $00, $F0, $10, $32, $00, $F8, $00, $40
	db $00, $F8, $08, $41, $00, $F8, $10, $42, $00, $00, $00, $50, $00, $00, $08, $51
	db $00, $00, $10, $52, $00

; ---- data $6AF8-$6B11 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_24_6AF8:: ; 24:6AF8
	db $06, $F8, $00, $16, $00, $F8, $08, $17, $00, $F8, $10, $18, $00, $00, $00, $26
	db $00, $00, $08, $27, $00, $00, $10, $28, $00

; ---- data $6B11-$6B18 (7 bytes) [HYPOTHESIS] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 3 step(s), (frame,delay) pairs: 4:5 5:5 0:5; not named by a known object-table row: found because the gap between neighbours equals exactly this script (+ pad)

Data_24_6B11:: ; 24:6B11
	db $03, $04, $05, $05, $05, $00, $05

; ---- zero $6B18-$6B19 (1 bytes) [PROBABLE] alignment padding byte(s) between sprite script and the following word table (frame tables sit at even addresses)
	ds $1, $00

; ---- words $6B19-$6B1D (4 bytes) [PROBABLE] sprite frame table: 2 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_6B19:: ; 24:6B19
	dw Data_24_6B1D, Data_24_6B3A

; ---- data $6B1D-$6B3A (29 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 7 piece(s); length tiles exactly against the frame-table pointers

Data_24_6B1D:: ; 24:6B1D
	db $07, $0B, $00, $03, $44, $0B, $0C, $03, $64, $FF, $00, $03, $04, $FF, $0C, $03
	db $24, $F6, $FF, $00, $04, $F6, $07, $01, $04, $F6, $0F, $02, $04

; ---- data $6B3A-$6B57 (29 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 7 piece(s); length tiles exactly against the frame-table pointers

Data_24_6B3A:: ; 24:6B3A
	db $07, $0C, $FF, $03, $44, $0C, $0D, $03, $64, $FE, $FF, $03, $04, $FE, $0D, $03
	db $24, $F6, $FF, $00, $04, $F6, $07, $01, $04, $F6, $0F, $02, $04

; ---- data $6B57-$6B5C (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:46 1:8

Data_24_6B57:: ; 24:6B57
	db $02, $00, $2E, $01, $08

; ---- words $6B5C-$6B60 (4 bytes) [PROBABLE] sprite frame table: 2 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_6B5C:: ; 24:6B5C
	dw Data_24_6B60, Data_24_6B7D

; ---- data $6B60-$6B7D (29 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 7 piece(s); length tiles exactly against the frame-table pointers

Data_24_6B60:: ; 24:6B60
	db $07, $0B, $00, $03, $44, $0B, $0C, $03, $64, $FF, $00, $03, $04, $FF, $0C, $03
	db $24, $F6, $FE, $10, $04, $F6, $06, $11, $04, $F6, $0E, $12, $04

; ---- data $6B7D-$6B9A (29 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 7 piece(s); length tiles exactly against the frame-table pointers

Data_24_6B7D:: ; 24:6B7D
	db $07, $0C, $FF, $03, $44, $0C, $0D, $03, $64, $FE, $FF, $03, $04, $FE, $0D, $03
	db $24, $F6, $FE, $10, $04, $F6, $06, $11, $04, $F6, $0E, $12, $04

; ---- data $6B9A-$6B9F (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:46 1:8

Data_24_6B9A:: ; 24:6B9A
	db $02, $00, $2E, $01, $08

; ---- words $6B9F-$6BA3 (4 bytes) [PROBABLE] sprite frame table: 2 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_6B9F:: ; 24:6B9F
	dw Data_24_6BA3, Data_24_6BC0

; ---- data $6BA3-$6BC0 (29 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 7 piece(s); length tiles exactly against the frame-table pointers

Data_24_6BA3:: ; 24:6BA3
	db $07, $0B, $00, $03, $44, $0B, $0C, $03, $64, $FF, $00, $03, $04, $FF, $0C, $03
	db $24, $F6, $FE, $20, $04, $F6, $06, $21, $04, $F6, $0E, $22, $04

; ---- data $6BC0-$6BDD (29 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 7 piece(s); length tiles exactly against the frame-table pointers

Data_24_6BC0:: ; 24:6BC0
	db $07, $0C, $FF, $03, $44, $0C, $0D, $03, $64, $FE, $FF, $03, $04, $FE, $0D, $03
	db $24, $F6, $FE, $20, $04, $F6, $06, $21, $04, $F6, $0E, $22, $04

; ---- data $6BDD-$6BE2 (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:46 1:8

Data_24_6BDD:: ; 24:6BDD
	db $02, $00, $2E, $01, $08

; ---- zero $6BE2-$6BF0 (14 bytes) [PROBABLE] 0x00 padding after the last sprite script of the 6530 block, before the tile block at 6BF0
	ds $E, $00
