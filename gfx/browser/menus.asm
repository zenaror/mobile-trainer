; gfx/browser/menus.asm
; bank 72, $6C10-$7A1F (3599 bytes); pinned by layout.link
; browser menu tiles, maps, palette, cursor object table

SECTION "gfx/browser/menus", ROMX

; ---- gfx $6C10-$7010 (1024 bytes) [CONFIRMED] tiles-vram: 3 call site(s) (4E:61C1 4E:62BC 72:6733); first: hdma_rom_to_vram at 4E:61C1: hl=$6C10 a=$72 c=$40 de=$8801 (dest VRAM $8800, vbank=1)

BrowserMenu3_Tiles0:: ; 72:6C10
Data_72_6C10::
	db $01, $00, $03, $01, $07, $02, $0E, $05, $1C, $0B, $38, $17, $7F, $3F, $7F, $00
	db $F8, $F8, $F8, $88, $F0, $B0, $E0, $A0, $C0, $C0, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $80, $80, $80, $80, $F8, $F8, $B8, $68, $F8, $A8, $F8, $A8, $A8, $D8, $F0, $F0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $FF, $00, $00, $00, $FF
	db $80, $7F, $FF, $00, $FF, $00, $FF, $00, $FF, $80, $7F, $80, $3F, $40, $1F, $20
	db $80, $00, $C0, $80, $E0, $C0, $70, $E0, $38, $F0, $1C, $F8, $FE, $FC, $FE, $00
	db $FF, $0F, $7F, $80, $7F, $80, $7F, $80, $7F, $80, $7F, $80, $7F, $80, $7F, $80
	db $1F, $1F, $1F, $11, $3F, $35, $7F, $61, $FF, $D7, $FF, $BB, $EF, $ED, $07, $07
	db $1F, $1F, $1F, $11, $FF, $FF, $FF, $11, $FF, $FF, $1F, $1E, $1E, $11, $1F, $1F
	db $FF, $FF, $FF, $56, $FF, $F6, $DF, $56, $DF, $5E, $4E, $CD, $8D, $8B, $0E, $0E
	db $FF, $FF, $FF, $85, $FF, $F5, $BF, $B4, $FF, $ED, $FF, $D5, $FF, $B5, $FF, $FF
	db $00, $00, $00, $00, $80, $80, $E0, $E0, $E0, $20, $E0, $E0, $00, $00, $00, $00
	db $7F, $7F, $FF, $DB, $FF, $81, $FF, $DB, $7E, $5A, $7F, $5F, $5F, $61, $3F, $3F
	db $FB, $FB, $FF, $06, $F7, $FB, $0F, $0B, $0F, $0B, $FB, $F7, $F5, $8D, $F9, $F9
	db $FF, $FF, $FF, $2A, $FF, $46, $FF, $7E, $C3, $42, $FF, $7E, $FF, $46, $FF, $FF
	db $07, $07, $0F, $0D, $0F, $08, $0F, $0D, $07, $05, $07, $05, $07, $05, $07, $07
	db $C7, $C7, $EF, $6D, $D7, $38, $FF, $55, $FF, $D5, $DF, $B6, $F7, $F9, $0F, $0F
	db $CF, $CF, $EF, $68, $DF, $3E, $FF, $58, $FB, $57, $FF, $DC, $D7, $B4, $E7, $E7
	db $C0, $C0, $C0, $40, $C0, $C0, $A0, $60, $E0, $A0, $E0, $A0, $A0, $60, $C0, $C0
	db $80, $7F, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $FF, $00, $00, $00, $FF
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $7F, $C0, $80, $BF, $87, $BC, $8C, $BE, $9E, $AD, $AD, $AD, $AD, $B4, $B4
	db $FF, $FE, $03, $01, $FF, $D1, $7F, $7D, $57, $55, $47, $45, $C7, $C5, $C7, $C5
	db $FF, $7F, $C0, $80, $BF, $98, $A7, $A4, $A3, $A2, $B1, $91, $B8, $88, $BC, $BC
	db $FF, $FE, $03, $01, $FF, $19, $E7, $25, $C7, $45, $8F, $89, $1F, $11, $3F, $3D
	db $FF, $7F, $C0, $80, $FF, $FC, $87, $87, $85, $85, $9C, $9C, $88, $88, $88, $88
	db $FF, $FE, $03, $01, $FF, $01, $FF, $61, $BF, $BD, $A3, $A3, $21, $21, $29, $29
	db $FF, $FF, $00, $00, $FF, $00, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $FF, $FF, $00, $00, $FF, $00, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $C0, $E0, $00, $07, $0F, $9F, $11, $3E, $21, $3B, $21, $71, $23, $79, $3F, $6E
	db $00, $00, $00, $FF, $FF, $FF, $FF, $00, $FF, $0F, $F8, $0F, $FF, $00, $FF, $00
	db $00, $00, $00, $FF, $FF, $FF, $FF, $00, $FF, $FF, $00, $FF, $FF, $00, $FF, $00
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $01, $FE, $FF, $00, $FF, $00, $FF, $00, $FF, $01, $FE, $01, $FC, $02, $F8, $04
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $FF, $00, $00, $00, $FF
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $A0, $A0, $AC, $AC, $B6, $A6, $B9, $91, $BF, $88, $BF, $87, $FF, $80, $FF, $7F
	db $47, $45, $FF, $45, $47, $45, $FF, $45, $FF, $45, $FF, $FD, $FF, $01, $FF, $FE
	db $BC, $BC, $B8, $88, $B1, $91, $A3, $A2, $A7, $A4, $BF, $98, $FF, $80, $FF, $7F
	db $3F, $3D, $1F, $11, $8F, $89, $C7, $45, $E7, $25, $FF, $19, $FF, $01, $FF, $FE
	db $9C, $9C, $84, $84, $85, $85, $FD, $F9, $BF, $8E, $BF, $80, $FF, $80, $FF, $7F
	db $29, $29, $29, $29, $29, $29, $A1, $A1, $E3, $E3, $FF, $3D, $FF, $01, $FF, $FE
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $3F, $60, $3F, $60, $3F, $60, $3F, $60, $3F, $60, $3F, $60, $3F, $60, $3F, $60
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $31, $6E, $21, $7B, $21, $71, $23, $79, $3F, $6E, $3F, $60, $3F, $60, $3F, $60
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $80, $7F, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $80, $7F, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $FF, $00, $00, $00, $FF
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00

; ---- gfx $7010-$7110 (256 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 72:6745: hl=$7010 a=$72 c=$10 de=$8F01 (dest VRAM $8F00, vbank=1)

BrowserMenu3_Tiles1:: ; 72:7010
Data_72_7010::
	db $80, $7F, $7F, $BF, $67, $D8, $5B, $FC, $5D, $FE, $6E, $DF, $77, $CF, $43, $FF
	db $01, $FE, $FE, $FD, $E6, $19, $DA, $3D, $BA, $7D, $76, $F9, $EE, $F1, $C2, $FD
	db $43, $FF, $77, $CF, $6E, $DF, $5D, $FE, $5B, $FC, $67, $D8, $7F, $80, $80, $7F
	db $C2, $FD, $EE, $F1, $76, $F9, $BA, $7D, $DA, $3D, $E6, $19, $FE, $01, $01, $FE
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- data $7110-$7200 (240 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 72:6767: hl=$7110 a=$72 b=6 rows c=20 cols (tiles then attrs) de=$D180

BrowserMenu3_Map:: ; 72:7110
Data_72_7110::
	db $A6, $A7, $A8, $A9, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA
	db $A9, $A8, $A7, $A6, $B6, $B7, $B8, $B9, $A0, $A1, $AF, $AF, $AF, $A2, $A3, $AF
	db $AF, $AF, $A4, $A5, $BF, $B8, $B7, $B6, $AB, $AC, $B8, $B9, $B0, $B1, $AF, $AF
	db $AF, $B2, $B3, $AF, $AF, $AF, $B4, $B5, $BF, $B8, $AC, $AB, $BB, $BC, $BA, $B9
	db $BD, $AD, $AE, $AE, $AE, $9E, $9E, $AE, $AE, $AE, $8F, $BD, $BF, $BA, $BC, $BB
	db $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F
	db $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F
	db $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E
	db $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $2E, $2E, $2E, $2E, $0E, $0E, $0E, $0E
	db $0F, $0F, $0E, $0E, $0E, $0F, $0F, $0E, $0E, $0E, $0F, $0F, $0E, $2E, $2E, $2E
	db $0E, $0E, $0E, $0E, $0F, $0F, $0E, $0E, $0E, $0F, $0F, $0E, $0E, $0E, $0F, $0F
	db $0E, $2E, $2E, $2E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $2E, $2E
	db $2E, $2E, $0E, $2E, $0E, $2E, $2E, $2E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E
	db $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E
	db $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E

; ---- data $7200-$7206 (6 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 6C10-7218 by higher-priority evidence]

Data_72_7200:: ; 72:7200
	db $00, $00, $6D, $7A, $20, $69

; ---- data $7206-$7216 (16 bytes) [PROBABLE] palette-rgb555: heuristic: 8 RGB555 words as 2 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Data_72_7206:: ; 72:7206
	db $FF, $7F, $FF, $7F, $7F, $01, $53, $2C, $00, $00, $E0, $7F, $FF, $7F, $CE, $39

; ---- data $7216-$7218 (2 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 6C10-7218 by higher-priority evidence]

Data_72_7216:: ; 72:7216
	db $00, $00

; ---- zero $7218-$7220 (8 bytes) [PROBABLE] 8 x 00 padding between the palette/data at 72:7206-7218 and the tile block 72:7220
	ds $8, $00

; ---- gfx $7220-$7620 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 72:640B: hl=$7220 a=$72 c=$40 de=$8801 (dest VRAM $8800, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

BrowserMenu2_Tiles0:: ; 72:7220
Data_72_7220::
	db $01, $00, $03, $01, $07, $02, $0E, $05, $1C, $0B, $38, $17, $7F, $3F, $7F, $00
	db $F8, $F8, $F8, $88, $F0, $B0, $E0, $A0, $C0, $C0, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $80, $80, $80, $80, $F8, $F8, $B8, $68, $F8, $A8, $F8, $A8, $A8, $D8, $F0, $F0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $FF, $00, $00, $00, $FF
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $80, $7F, $80, $3F, $40, $1F, $20
	db $80, $00, $C0, $80, $E0, $C0, $70, $E0, $38, $F0, $1C, $F8, $FE, $FC, $FE, $00
	db $FF, $0F, $7F, $80, $7F, $80, $7F, $80, $7F, $80, $7F, $80, $7F, $80, $7F, $80
	db $1F, $1F, $FF, $F5, $FB, $85, $FF, $FA, $0F, $0A, $7B, $77, $75, $4D, $79, $79
	db $0F, $0F, $0F, $08, $EF, $EB, $FF, $BB, $FF, $AF, $DF, $EE, $FE, $1D, $F7, $F7
	db $FF, $FF, $FF, $41, $FF, $7D, $FF, $7D, $FD, $6B, $7A, $F6, $9E, $9A, $0E, $0E
	db $1F, $1F, $1F, $10, $FF, $F6, $FF, $16, $FF, $FE, $06, $05, $0D, $0B, $0E, $0E
	db $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $00, $00, $00, $00
	db $7F, $7F, $FF, $DB, $FF, $81, $FF, $DB, $7E, $5A, $7F, $5F, $5F, $61, $3F, $3F
	db $FB, $FB, $FF, $06, $F7, $FB, $0F, $0B, $0F, $0B, $FB, $F7, $F5, $8D, $F9, $F9
	db $FF, $FF, $FF, $2A, $FF, $46, $FF, $7E, $C3, $42, $FF, $7E, $FF, $46, $FF, $FF
	db $07, $07, $0F, $0D, $0F, $08, $0F, $0D, $07, $05, $07, $05, $07, $05, $07, $07
	db $E3, $E3, $F7, $B6, $EB, $1C, $FF, $AA, $FF, $EA, $6F, $5B, $7B, $7C, $07, $07
	db $EF, $EF, $FF, $B8, $EF, $1F, $FF, $A8, $FF, $AC, $FF, $6B, $EB, $DC, $F7, $F7
	db $E0, $E0, $E0, $20, $E0, $60, $D0, $30, $F0, $D0, $F0, $50, $D0, $30, $E0, $E0
	db $80, $7F, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $FF, $00, $00, $00, $FF
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $7F, $C0, $80, $BF, $87, $BC, $8C, $BE, $9E, $AD, $AD, $AD, $AD, $B4, $B4
	db $FF, $FE, $03, $01, $FF, $D1, $7F, $7D, $57, $55, $47, $45, $C7, $C5, $C7, $C5
	db $FF, $7F, $C0, $80, $BF, $98, $A7, $A4, $A3, $A2, $B1, $91, $B8, $88, $BC, $BC
	db $FF, $FE, $03, $01, $FF, $19, $E7, $25, $C7, $45, $8F, $89, $1F, $11, $3F, $3D
	db $FF, $7F, $C0, $80, $FF, $FC, $87, $87, $85, $85, $9C, $9C, $88, $88, $88, $88
	db $FF, $FE, $03, $01, $FF, $01, $FF, $61, $BF, $BD, $A3, $A3, $21, $21, $29, $29
	db $FF, $FF, $00, $00, $FF, $00, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $FF, $FF, $00, $00, $FF, $00, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $C0, $E0, $00, $07, $0F, $9F, $1F, $30, $3F, $20, $3F, $60, $3F, $7F, $30, $70
	db $00, $00, $00, $FF, $FF, $FF, $FF, $00, $FF, $0F, $F8, $0F, $FF, $00, $FF, $00
	db $00, $00, $00, $FF, $FF, $FF, $FF, $00, $FF, $FF, $00, $FF, $FF, $00, $FF, $00
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $01, $FE, $01, $FC, $02, $F8, $04
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $FF, $00, $00, $00, $FF
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $A0, $A0, $AC, $AC, $B6, $A6, $B9, $91, $BF, $88, $BF, $87, $FF, $80, $FF, $7F
	db $47, $45, $FF, $45, $47, $45, $FF, $45, $FF, $45, $FF, $FD, $FF, $01, $FF, $FE
	db $BC, $BC, $B8, $88, $B1, $91, $A3, $A2, $A7, $A4, $BF, $98, $FF, $80, $FF, $7F
	db $3F, $3D, $1F, $11, $8F, $89, $C7, $45, $E7, $25, $FF, $19, $FF, $01, $FF, $FE
	db $9C, $9C, $84, $84, $85, $85, $FD, $F9, $BF, $8E, $BF, $80, $FF, $80, $FF, $7F
	db $29, $29, $29, $29, $29, $29, $A1, $A1, $E3, $E3, $FF, $3D, $FF, $01, $FF, $FE
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $3F, $60, $3F, $60, $3F, $60, $3F, $60, $3F, $60, $3F, $60, $3F, $60, $3F, $60
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $3F, $60, $3F, $60, $3F, $7F, $30, $70, $3F, $60, $3F, $60, $3F, $60, $3F, $60
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $80, $7F, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $80, $7F, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $FF, $00, $00, $00, $FF
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00

; ---- gfx $7620-$7720 (256 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 72:63F9: hl=$7620 a=$72 c=$10 de=$8F01 (dest VRAM $8F00, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

BrowserMenu2_Tiles1:: ; 72:7620
Data_72_7620::
	db $80, $00, $7F, $3F, $67, $40, $5B, $58, $5D, $5C, $6E, $4E, $77, $47, $43, $43
	db $01, $00, $FE, $FC, $E6, $00, $DA, $18, $BA, $38, $76, $70, $EE, $E0, $C2, $C0
	db $43, $43, $77, $47, $6E, $4E, $5D, $5C, $5B, $58, $67, $40, $7F, $00, $80, $00
	db $C2, $C0, $EE, $E0, $76, $70, $BA, $38, $DA, $18, $E6, $00, $FE, $00, $01, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- data $7720-$7810 (240 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 72:642D: hl=$7720 a=$72 b=6 rows c=20 cols (tiles then attrs) de=$D180 [verifier: call site never executed in a trace -> PROBABLE]

BrowserMenu2_Map:: ; 72:7720
Data_72_7720::
	db $A6, $A7, $A8, $A9, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA
	db $A9, $A8, $A7, $A6, $B6, $B7, $B8, $B9, $AF, $AF, $A2, $A3, $AF, $AF, $AF, $AF
	db $A4, $A5, $BF, $BF, $BF, $B8, $B7, $B6, $AB, $AC, $B8, $B9, $AF, $AF, $B2, $B3
	db $AF, $AF, $AF, $AF, $B4, $B5, $BF, $BF, $BF, $B8, $AC, $AB, $BB, $BC, $BA, $B9
	db $AF, $AD, $9E, $9E, $AE, $AE, $AE, $AE, $9E, $9E, $8F, $BF, $BF, $BA, $BC, $BB
	db $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F
	db $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F
	db $9F, $9F, $9F, $9F, $9F, $9F, $9F, $9F, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E
	db $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $2E, $2E, $2E, $2E, $0E, $0E, $0E, $0E
	db $0E, $0E, $0F, $0F, $0E, $0E, $0E, $0E, $0F, $0F, $0E, $0E, $0E, $2E, $2E, $2E
	db $0E, $0E, $0E, $0E, $0E, $0E, $0F, $0F, $0E, $0E, $0E, $0E, $0F, $0F, $0E, $0E
	db $0E, $2E, $2E, $2E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $2E, $2E, $2E, $2E, $2E
	db $0E, $2E, $0E, $0E, $0E, $2E, $2E, $2E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E
	db $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E
	db $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E

; ---- data $7810-$7828 (24 bytes) [PROBABLE] 3 RGB555 palettes of 4 colours (bit15 clear, black/white ends); 7810 is loaded by ld hl,$7810 (bc=$0010 -> de=$D830, far call 4F:4000) at 72:6417; the third group (7820) follows the same format

BrowserMenu2_Palette:: ; 72:7810
Palette_72_7810::
	db $00, $00, $73, $42, $4A, $41, $FF, $7F, $FF, $7F, $7F, $01, $53, $2C, $00, $00
	db $E0, $7F, $FF, $7F, $CE, $39, $00, $00

; ---- words $7828-$786C (68 bytes) [PROBABLE] object table for init_object_from_table (00:0A82, de=$7828 a=$72, 4-byte entries = 2 words; callers 4E:5F08.., 72:45D2, 72:46D4, 72:64C6, 72:66BE, 72:6802, 72:6A12); 17 entries, every word lands exactly on a descriptor start of the data block 72:786C-7A1F (partition check)

BrowserMenu_CursorObjTable:: ; 72:7828
Table_72_7828::
	dw Data_72_78CA, $78F0, Data_72_78CA, $78F0, $7976, $799D, Data_72_79A0, $79BF
	dw $79C3, $79E6, $7940, $7956, Data_72_795B, $7971, Data_72_78F5, $793B
	dw Data_72_7894, $78AA, $78AF, $78C5, $79E9, $79FF, Data_72_7A04, $7A1A
	dw Data_72_786C, $7873, Data_72_786C, $7873, $7876, $787D, Data_72_7880, $7887
	dw $788A, $7891

; ---- data $786C-$786E (2 bytes) [PROBABLE] descriptor $786C = dw $786E (first word of the animation/sprite data block; target of table entry words)

Data_72_786C:: ; 72:786C
	db $6E, $78

; ---- data $786E-$7880 (18 bytes) [PROBABLE] animation-descriptor / sprite-list block reached from the object table 72:7828: sprite lists = count + count*(y,x,tile,attr) (e.g. 72:78CE 04 fe fe 81 0c ...) and descriptors (01 00 04 dw / 02 00 2e 01 08 dw dw); the table words partition 786C-7A1F exactly at descriptor starts; other bytes of this block are CONFIRMED read by executed code (1/18)

Data_72_786E:: ; 72:786E
	db $01, $00, $00, $FF, $07, $01, $00, $04, $78, $78, $01, $00, $00, $FF, $07, $01
	db $00, $04

; ---- data $7880-$7894 (20 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_72_7880:: ; 72:7880
	db $82, $78, $01, $00, $00, $FF, $07, $01, $00, $04, $8C, $78, $01, $00, $00, $FF
	db $07, $01, $00, $04

; ---- data $7894-$78CA (54 bytes) [PROBABLE] animation-descriptor / sprite-list block reached from the object table 72:7828: sprite lists = count + count*(y,x,tile,attr) (e.g. 72:78CE 04 fe fe 81 0c ...) and descriptors (01 00 04 dw / 02 00 2e 01 08 dw dw); the table words partition 786C-7A1F exactly at descriptor starts; other bytes of this block are CONFIRMED read by executed code (1/18)

Data_72_7894:: ; 72:7894
	db $98, $78, $A1, $78, $02, $00, $00, $0B, $07, $00, $08, $0C, $07, $02, $FF, $00
	db $0B, $07, $FF, $08, $0C, $07, $02, $00, $2E, $01, $08, $B3, $78, $BC, $78, $02
	db $00, $00, $0B, $47, $00, $08, $0C, $47, $02, $01, $00, $0B, $47, $01, $08, $0C
	db $47, $02, $00, $2E, $01, $08

; ---- data $78CA-$78F5 (43 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_72_78CA:: ; 72:78CA
	db $CE, $78, $DF, $78, $04, $FE, $FE, $81, $0C, $FE, $0A, $81, $2C, $0A, $FE, $81
	db $4C, $0A, $0A, $81, $6C, $04, $FD, $FD, $81, $0C, $FD, $0B, $81, $2C, $0B, $FD
	db $81, $4C, $0B, $0B, $81, $6C, $02, $00, $2E, $01, $08

; ---- data $78F5-$795B (102 bytes) [PROBABLE] animation-descriptor / sprite-list block reached from the object table 72:7828: sprite lists = count + count*(y,x,tile,attr) (e.g. 72:78CE 04 fe fe 81 0c ...) and descriptors (01 00 04 dw / 02 00 2e 01 08 dw dw); the table words partition 786C-7A1F exactly at descriptor starts; other bytes of this block are CONFIRMED read by executed code (1/18)

Data_72_78F5:: ; 72:78F5
	db $F9, $78, $1A, $79, $08, $ED, $F8, $F8, $0C, $ED, $00, $F9, $0C, $ED, $08, $FA
	db $0C, $ED, $10, $FB, $0C, $F5, $F8, $FC, $0C, $F5, $00, $FD, $0C, $F5, $08, $FE
	db $0C, $F5, $10, $FF, $0C, $08, $EC, $F8, $F8, $0C, $EC, $00, $F9, $0C, $EC, $08
	db $FA, $0C, $EC, $10, $FB, $0C, $F4, $F8, $FC, $0C, $F4, $00, $FD, $0C, $F4, $08
	db $FE, $0C, $F4, $10, $FF, $0C, $02, $00, $2E, $01, $08, $44, $79, $4D, $79, $02
	db $00, $00, $0B, $07, $00, $08, $0C, $07, $02, $FF, $00, $0B, $07, $FF, $08, $0C
	db $07, $02, $00, $2E, $01, $08

; ---- data $795B-$79A0 (69 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_72_795B:: ; 72:795B
	db $5F, $79, $68, $79, $02, $00, $00, $0B, $47, $00, $08, $0C, $47, $02, $01, $00
	db $0B, $47, $01, $08, $0C, $47, $02, $00, $2E, $01, $08, $78, $79, $09, $ED, $F8
	db $82, $0C, $ED, $00, $83, $0C, $ED, $08, $84, $0C, $ED, $10, $85, $0C, $F5, $F8
	db $92, $0C, $F5, $00, $93, $0C, $F5, $08, $94, $0C, $F5, $10, $95, $0C, $F5, $18
	db $96, $0C, $01, $00, $04

; ---- data $79A0-$7A04 (100 bytes) [PROBABLE] animation-descriptor / sprite-list block reached from the object table 72:7828: sprite lists = count + count*(y,x,tile,attr) (e.g. 72:78CE 04 fe fe 81 0c ...) and descriptors (01 00 04 dw / 02 00 2e 01 08 dw dw); the table words partition 786C-7A1F exactly at descriptor starts; other bytes of this block are CONFIRMED read by executed code (1/18)

Data_72_79A0:: ; 72:79A0
	db $A2, $79, $07, $ED, $F9, $87, $0C, $ED, $01, $88, $0C, $ED, $09, $89, $0C, $F5
	db $F9, $97, $0C, $F5, $01, $98, $0C, $F5, $09, $99, $0C, $F5, $11, $86, $0C, $01
	db $00, $04, $00, $C5, $79, $08, $ED, $F8, $8A, $0C, $ED, $00, $8B, $0C, $ED, $08
	db $8C, $0C, $ED, $10, $8D, $0C, $F5, $F8, $9A, $0C, $F5, $00, $9B, $0C, $F5, $08
	db $9C, $0C, $F5, $10, $9D, $0C, $01, $00, $04, $ED, $79, $F6, $79, $02, $00, $00
	db $00, $00, $00, $08, $01, $00, $02, $FF, $00, $00, $00, $FF, $08, $01, $00, $02
	db $00, $2E, $01, $08

; ---- data $7A04-$7A1F (27 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_72_7A04:: ; 72:7A04
	db $08, $7A, $11, $7A, $02, $00, $00, $00, $40, $00, $08, $01, $40, $02, $01, $00
	db $00, $40, $01, $08, $01, $40, $02, $00, $2E, $01, $08
