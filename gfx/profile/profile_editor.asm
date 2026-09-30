; gfx/profile/profile_editor.asm
; bank 2A, $6300-$6F95 (3221 bytes); pinned by layout.link
; profile editor tiles, tilemap, palette, animation table

SECTION "gfx/profile/profile_editor", ROMX

; ---- data $6300-$6B40 (2112 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 6300-6E50 by higher-priority evidence]

Gfx_Profile_Tiles9300:: ; 2A:6300
Data_2A_6300::
	db $FF, $FF, $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $FF, $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $FF, $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $FF, $FF, $00, $01, $03, $03, $06, $06, $0D, $0C, $0A, $0F, $0A, $0F, $0A
	db $FF, $FF, $FF, $00, $F8, $FC, $C4, $0E, $FA, $FF, $F5, $0F, $5D, $E7, $FD, $E7
	db $FF, $FF, $FF, $00, $00, $00, $07, $0F, $0A, $08, $0D, $9A, $1D, $B2, $30, $AF
	db $FF, $FF, $FF, $00, $00, $00, $00, $81, $81, $C1, $E3, $F3, $DD, $3C, $3E, $C1
	db $FF, $FF, $FF, $00, $00, $00, $FE, $FF, $55, $01, $AB, $54, $AB, $54, $0F, $F0
	db $FF, $FF, $FF, $00, $00, $00, $FF, $FF, $6A, $00, $B5, $4A, $B5, $4A, $BE, $40
	db $FF, $FF, $FF, $00, $00, $01, $01, $83, $83, $C6, $86, $C5, $87, $C5, $87, $C5
	db $FF, $FF, $FF, $00, $FC, $FE, $E2, $07, $7D, $FF, $FA, $07, $FE, $73, $FE, $73
	db $FF, $FF, $FF, $00, $00, $00, $03, $07, $06, $8C, $8D, $CA, $98, $D7, $95, $D2
	db $FF, $FF, $FF, $00, $00, $00, $0F, $8F, $D4, $D0, $BB, $34, $7B, $84, $F8, $07
	db $FF, $FF, $FF, $00, $00, $00, $FF, $FF, $A7, $00, $58, $A7, $5D, $A2, $F8, $07
	db $FF, $FF, $FF, $00, $00, $00, $C0, $E0, $A0, $30, $60, $B0, $E0, $30, $50, $98
	db $FF, $FF, $00, $FF, $FF, $00, $00, $FF, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $0B, $0A, $0B, $0A, $0B, $0E, $0B, $0E, $05, $0F, $02, $07, $01, $03, $00, $01
	db $FD, $07, $FD, $E7, $FD, $E7, $BD, $E7, $BA, $FF, $04, $FF, $F8, $FE, $00, $FC
	db $3D, $A2, $30, $AF, $1E, $B1, $0E, $9D, $05, $84, $03, $07, $00, $03, $00, $00
	db $E3, $1C, $3E, $C1, $DE, $1D, $E6, $7D, $45, $74, $83, $E7, $00, $C3, $00, $00
	db $B8, $47, $AF, $50, $AF, $57, $AD, $57, $55, $07, $F8, $FF, $00, $FC, $00, $00
	db $9D, $61, $A3, $5D, $B5, $41, $BE, $5F, $50, $1F, $E0, $F8, $00, $F0, $00, $00
	db $05, $C5, $05, $85, $05, $87, $05, $87, $02, $07, $01, $03, $00, $01, $00, $00
	db $FA, $07, $FE, $73, $FE, $73, $FA, $07, $FD, $FF, $02, $FF, $FC, $FF, $00, $FE
	db $98, $D7, $95, $D2, $8D, $DA, $8A, $C9, $05, $CC, $03, $87, $00, $03, $00, $00
	db $73, $88, $D7, $28, $D7, $28, $28, $C7, $D7, $10, $EF, $FF, $00, $FF, $00, $00
	db $F7, $08, $F8, $02, $FA, $05, $78, $93, $D7, $10, $EF, $FF, $00, $FF, $00, $00
	db $B0, $58, $B0, $58, $B0, $58, $50, $98, $A0, $38, $C0, $F0, $00, $E0, $00, $00
	db $00, $00, $00, $00, $00, $00, $33, $CC, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $33, $CC
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $01, $FE
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $3E, $80, $BF, $3F, $C0, $FF
	db $00, $FF, $00, $FE, $01, $FD, $3A, $82, $7E, $7E, $80, $80, $80, $FF, $FF, $80
	db $00, $FF, $E0, $0F, $F7, $F0, $1F, $0F, $10, $E0, $50, $A7, $13, $E4, $33, $45
	db $00, $FF, $00, $FF, $F8, $03, $FD, $FC, $07, $03, $06, $FA, $E6, $0B, $E7, $EA
	db $00, $FF, $00, $FF, $00, $FF, $FF, $00, $FF, $FF, $00, $00, $00, $FF, $FC, $01
	db $00, $FF, $00, $FF, $00, $FF, $00, $7F, $80, $BF, $DF, $40, $FF, $7F, $C4, $7C
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $7C, $01, $7D, $7C, $83, $83, $41, $39
	db $00, $FF, $00, $FF, $07, $F0, $0F, $EE, $13, $D1, $F3, $15, $F3, $F5, $13, $F5
	db $00, $FF, $00, $FF, $C0, $1F, $E0, $EF, $30, $17, $3F, $50, $3F, $5F, $30, $5F
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $FC, $01, $FD, $FC, $03, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $80, $7F
	db $FF, $FF, $00, $FF, $FF, $00, $00, $FF, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $FF, $00, $FF, $FF, $00, $00, $FF, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $FF, $00, $FF, $00, $00, $FF, $FF, $FF, $FF, $FF, $00, $FF, $00, $FF, $00
	db $03, $FD, $01, $F9, $06, $03, $FE, $FB, $FE, $FB, $FE, $03, $FE, $03, $FE, $03
	db $9F, $C0, $00, $80, $00, $00, $00, $38, $14, $78, $3C, $78, $14, $78, $38, $00
	db $FF, $FF, $01, $FF, $01, $01, $02, $02, $3C, $3C, $40, $43, $43, $7C, $7F, $41
	db $33, $55, $33, $55, $33, $55, $33, $55, $73, $95, $F0, $34, $D0, $77, $9F, $D0
	db $27, $EB, $26, $2B, $26, $2A, $26, $2A, $E6, $EA, $07, $0B, $07, $FB, $FF, $03
	db $FC, $FD, $04, $FD, $04, $05, $08, $09, $F1, $F2, $03, $0C, $0F, $F1, $FE, $07
	db $D8, $5B, $E1, $66, $C3, $5D, $C3, $75, $F3, $45, $B3, $F5, $13, $B5, $1F, $31
	db $70, $CC, $F8, $76, $8C, $FB, $07, $8C, $03, $87, $00, $83, $00, $80, $00, $80
	db $F3, $F5, $33, $15, $33, $D5, $F3, $15, $E3, $E5, $43, $CD, $47, $F9, $7F, $C3
	db $37, $58, $30, $58, $30, $58, $30, $5C, $3C, $5F, $26, $43, $06, $7B, $FE, $03
	db $F9, $03, $00, $01, $00, $00, $00, $1C, $0A, $3C, $1E, $3C, $0A, $3C, $1C, $00
	db $C0, $BF, $80, $9F, $60, $C0, $7F, $DF, $7F, $DF, $7F, $C0, $7F, $C0, $7F, $C0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Gfx_Profile_Tiles9700:: ; 2A:6700
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $FE, $03, $FD, $03, $FD, $01, $FE, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $00, $80, $00, $C0, $80, $FF, $FF, $FF, $3F, $7F, $FF, $00, $FF, $00, $FF, $00
	db $3E, $7F, $00, $3F, $00, $FF, $FF, $FF, $FF, $FF, $FF, $00, $FF, $00, $FF, $00
	db $0F, $9F, $00, $0F, $00, $FF, $FF, $FF, $FF, $FF, $FF, $00, $FF, $00, $FF, $00
	db $FC, $FF, $00, $FC, $00, $FF, $FF, $FF, $FF, $FF, $FF, $00, $FF, $00, $FF, $00
	db $F8, $FE, $00, $FC, $00, $FF, $FF, $FF, $FF, $FF, $FF, $00, $FF, $00, $FF, $00
	db $0E, $1F, $00, $0E, $00, $FF, $FF, $FF, $FF, $FF, $FF, $00, $FF, $00, $FF, $00
	db $00, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $00, $FF, $00, $FF, $00
	db $3C, $7F, $00, $3E, $00, $FF, $FF, $FF, $FF, $FF, $FF, $00, $FF, $00, $FF, $00
	db $FC, $FE, $00, $FC, $00, $FF, $FF, $FF, $FF, $FF, $FF, $00, $FF, $00, $FF, $00
	db $00, $01, $00, $03, $01, $FF, $FF, $FF, $FC, $FE, $FF, $00, $FF, $00, $FF, $00
	db $7F, $C0, $BF, $C0, $BF, $80, $7F, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $FF, $00, $FF, $FF, $00, $00, $FF, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $FF, $00, $FF, $FF, $00, $00, $FF, $00, $00, $00, $00, $00, $00, $00, $00

Gfx_Profile_Tiles8800:: ; 2A:6800
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $03, $06, $0F, $18, $3F, $60, $FF
	db $00, $00, $00, $00, $00, $00, $00, $00, $FF, $FF, $5F, $C0, $60, $DF, $60, $DF
	db $00, $00, $00, $00, $00, $00, $00, $00, $DF, $FF, $AF, $20, $25, $DA, $25, $DA
	db $00, $00, $00, $00, $00, $00, $00, $00, $B9, $FF, $56, $46, $4F, $B6, $4F, $B6
	db $00, $00, $00, $00, $00, $00, $00, $00, $FE, $FF, $FD, $01, $03, $FD, $03, $FD
	db $E8, $36, $E8, $36, $E8, $36, $E8, $36, $E8, $36, $E8, $36, $E9, $37, $EB, $36
	db $42, $3C, $BD, $46, $1E, $FF, $4E, $BF, $66, $9D, $12, $FD, $E9, $F6, $C2, $CC
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3F, $7F, $5F, $40, $60, $5F
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $83, $C7, $45, $44, $C6, $45
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $FB, $FF, $F7, $04, $0E, $F1
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $C0, $C0, $A0, $20, $50, $90
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $78, $FC, $B4, $84, $CC, $B4
	db $F9, $03, $F6, $07, $EB, $0C, $D4, $19, $D8, $33, $E8, $36, $E8, $36, $E8, $36
	db $FF, $FF, $00, $FF, $FF, $00, $00, $FF, $00, $00, $00, $00, $00, $00, $00, $00
	db $9F, $C0, $6F, $E0, $D7, $30, $2B, $98, $1B, $CC, $07, $6C, $07, $6C, $07, $6C
	db $01, $03, $06, $0F, $08, $0F, $04, $0F, $04, $07, $02, $07, $3E, $3F, $37, $31
	db $8C, $E1, $21, $8C, $40, $BF, $04, $33, $82, $6D, $92, $6D, $01, $2C, $44, $B1
	db $5F, $C0, $39, $76, $99, $76, $19, $36, $58, $B7, $18, $B7, $19, $36, $19, $F6
	db $25, $DA, $25, $DA, $27, $D8, $27, $D8, $20, $DF, $20, $DF, $E7, $18, $E7, $DB
	db $4F, $B6, $4F, $B7, $CC, $37, $CC, $34, $CC, $34, $CC, $34, $CF, $37, $CF, $B0
	db $F3, $0D, $F3, $ED, $73, $ED, $63, $4D, $21, $DD, $C6, $9B, $C6, $BB, $81, $3D
	db $EA, $36, $EA, $36, $E9, $37, $E8, $36, $E8, $36, $E8, $36, $E8, $36, $E9, $37
	db $C8, $08, $04, $04, $00, $04, $82, $82, $41, $41, $63, $66, $9F, $9C, $1F, $08
	db $60, $5F, $5F, $40, $3F, $7F, $00, $3F, $C0, $C0, $20, $20, $91, $11, $11, $11
	db $C6, $45, $46, $45, $86, $CD, $0A, $89, $0C, $0B, $FC, $FB, $7F, $00, $A9, $56
	db $08, $F7, $48, $B7, $4F, $B0, $4F, $B4, $4A, $B5, $CE, $31, $CC, $33, $48, $37
	db $30, $D0, $30, $D0, $3F, $DF, $3D, $C1, $23, $D8, $61, $9E, $11, $E6, $1F, $E0
	db $CC, $B4, $CC, $B4, $4C, $34, $8C, $24, $9C, $64, $9E, $6F, $1D, $41, $33, $CD
	db $FF, $FF, $00, $FF, $FF, $00, $00, $FF, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $FF, $00, $FF, $FF, $00, $00, $FF, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $FF, $00, $FF, $FF, $00, $00, $FF, $00, $00, $00, $00, $00, $00, $00, $00
	db $2B, $29, $2D, $24, $2E, $22, $27, $21, $21, $20, $3F, $3F, $00, $1F, $00, $00
	db $20, $9F, $8C, $E0, $80, $FF, $C3, $7F, $CD, $7F, $B0, $FD, $00, $F0, $00, $00
	db $29, $66, $51, $CE, $63, $DC, $66, $D8, $5D, $C1, $BE, $FF, $00, $3E, $00, $00
	db $E6, $DB, $E6, $DA, $E6, $DA, $E6, $DA, $5A, $C2, $3C, $FE, $00, $3C, $00, $00
	db $C9, $B6, $C1, $BE, $C3, $BC, $C7, $B8, $FA, $82, $7D, $FF, $00, $7D, $00, $00
	db $93, $6D, $13, $6D, $13, $CD, $33, $CD, $FD, $01, $FE, $FF, $00, $FE, $00, $00
	db $E9, $37, $E9, $37, $E9, $37, $E9, $37, $E8, $37, $E8, $36, $E8, $36, $E8, $36
	db $7E, $48, $38, $38, $7F, $0F, $7A, $78, $B4, $91, $7F, $FF, $00, $7F, $00, $00
	db $61, $61, $BF, $BF, $5F, $40, $60, $5F, $E0, $DF, $5E, $C0, $3F, $FF, $00, $3F
	db $A9, $56, $A9, $56, $F1, $0E, $82, $7D, $86, $79, $BA, $82, $7D, $FF, $00, $7D
	db $C8, $37, $8E, $71, $9E, $65, $16, $E5, $3E, $CD, $D5, $1C, $E3, $F7, $00, $E3
	db $7F, $8E, $53, $9E, $63, $B2, $63, $A2, $63, $A2, $A2, $22, $C1, $E3, $00, $C1
	db $33, $CD, $33, $CD, $33, $CD, $03, $FD, $03, $FD, $FD, $01, $FE, $FF, $00, $FE
	db $00, $00, $FF, $00, $00, $FF, $00, $FF, $00, $00, $00, $FF, $FF, $FF, $00, $00
	db $05, $6C, $05, $EC, $0B, $CC, $0B, $98, $17, $30, $6F, $E0, $9F, $C0, $7F, $00
	db $05, $6C, $05, $6C, $05, $6C, $05, $6C, $05, $6C, $05, $6C, $05, $6C, $05, $6C
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $42, $3C, $BD, $46, $1E, $FF, $4E, $BF, $66, $9D, $72, $BD, $B9, $46, $42, $3C
	db $E8, $36, $E8, $36, $E8, $36, $E8, $36, $E8, $36, $E8, $36, $E8, $36, $E8, $36
	db $E8, $36, $E8, $37, $D8, $33, $D4, $19, $EB, $0C, $F6, $07, $F9, $03, $FF, $00

; ---- data $6B40-$6E10 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2A:5856: hl=$6B40 a=$2A b=18 rows c=20 cols (tiles then attrs) de=$D000

Data_Profile_TilemapAttr:: ; 2A:6B40
Data_2A_6B40::
	db $51, $51, $51, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D
	db $51, $51, $51, $51, $61, $61, $61, $61, $62, $63, $64, $65, $66, $67, $68, $69
	db $6A, $6B, $6C, $6D, $61, $61, $61, $61, $70, $70, $70, $70, $72, $73, $74, $75
	db $76, $77, $78, $79, $7A, $7B, $7C, $7D, $70, $70, $70, $70, $70, $70, $70, $70
	db $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70
	db $8D, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $9D, $9D, $9E, $9F, $7E, $7E, $7E
	db $8E, $8E, $8E, $8F, $86, $87, $88, $89, $8A, $8B, $8C, $B0, $B0, $B0, $B0, $B0
	db $B0, $B0, $B0, $B0, $B0, $B0, $B1, $AF, $96, $97, $98, $99, $9A, $9B, $9C, $00
	db $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $AF, $A6, $A7, $A8, $A9
	db $AA, $AB, $AC, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F, $AF
	db $B2, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0
	db $B0, $B0, $B0, $AF, $B2, $80, $81, $82, $83, $84, $85, $28, $29, $2A, $2B, $2C
	db $2D, $2E, $B0, $B0, $B0, $B0, $B0, $AF, $B2, $90, $91, $92, $93, $94, $95, $3C
	db $3D, $3E, $3F, $40, $41, $42, $43, $44, $45, $46, $47, $AF, $B2, $A0, $A1, $A2
	db $A3, $A4, $A5, $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $AF
	db $B2, $B1, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0
	db $B0, $B0, $B1, $AF, $B3, $AD, $AD, $AD, $AD, $AD, $AD, $AD, $AD, $AD, $AD, $AD
	db $AD, $AD, $AD, $AD, $AD, $AD, $AD, $AE, $70, $70, $70, $70, $70, $70, $70, $70
	db $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70
	db $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70
	db $30, $31, $32, $30, $31, $32, $30, $31, $33, $34, $35, $36, $37, $38, $39, $3A
	db $3B, $3C, $3D, $3E, $40, $41, $42, $40, $41, $42, $40, $41, $43, $44, $45, $46
	db $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $02, $02, $02, $02, $02, $02, $02, $02
	db $02, $02, $02, $02, $02, $0A, $0A, $0A, $02, $02, $02, $02, $02, $03, $02, $02
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $03, $02
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $03, $02, $02, $02, $02, $02, $02
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $03, $02, $02, $02, $02, $02
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09

; ---- data $6E10-$6E50 (64 bytes) [PROBABLE] 64 bytes = 32 RGB555 words (bit15 clear) right after the tilemap+attr block 6B40-6E10 (6B40+$2D0); previous data was cut into a CONFIRMED read fragment 6E10-6E30 and a clipped heuristic palette 6E30-6EB0

Palette_Profile_Bg:: ; 2A:6E10
Palette_2A_6E10::
	db $3F, $37, $6C, $7F, $E0, $6C, $00, $00, $DF, $02, $FF, $7F, $1B, $00, $00, $00
	db $DF, $02, $FF, $7F, $1F, $00, $00, $00, $DF, $02, $94, $5A, $61, $20, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F

; ---- words $6E50-$6EA0 (80 bytes) [PROBABLE] animation entry table: 20 entries of 4 bytes (frame-table pointer, script pointer), each animation repeated 4x; format of the sprite-slot initialiser 00:0A82/0AB8 (entry at DE+4*(A&$7F) -> slot[2..3] frame table, slot[6..7] script)

Table_Profile_Anims:: ; 2A:6E50
Table_2A_6E50::
	dw Table_2A_6EA0, Data_2A_6ECE, Table_2A_6EA0, Data_2A_6ECE, Table_2A_6EA0, Data_2A_6ECE, Table_2A_6EA0, Data_2A_6ECE
	dw Table_2A_6ED3, Data_2A_6F01, Table_2A_6ED3, Data_2A_6F01, Table_2A_6ED3, Data_2A_6F01, Table_2A_6ED3, Data_2A_6F01
	dw Table_2A_6F06, Data_2A_6F3C, Table_2A_6F06, Data_2A_6F3C, Table_2A_6F06, Data_2A_6F3C, Table_2A_6F06, Data_2A_6F3C
	dw Table_2A_6F41, Data_2A_6F77, Table_2A_6F41, Data_2A_6F77, Table_2A_6F41, Data_2A_6F77, Table_2A_6F41, Data_2A_6F77
	dw Table_2A_6F7C, Data_2A_6F92, Table_2A_6F7C, Data_2A_6F92, Table_2A_6F7C, Data_2A_6F92, Table_2A_6F7C, Data_2A_6F92

; ---- words $6EA0-$6EA4 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $6EA4, $6EB9 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2A_6EA0:: ; 2A:6EA0
	dw Data_2A_6EA4, Data_2A_6EB9

; ---- data $6EA4-$6EB9 (21 bytes) [PROBABLE] OAM frame: count=5 then 5 x (y,x,tile,attr) = 21 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6EA4:: ; 2A:6EA4
	db $05, $06, $03, $04, $01, $07, $0C, $02, $01, $07, $14, $03, $01, $FF, $0C, $07
	db $01, $FF, $14, $08, $01

; ---- data $6EB9-$6ECE (21 bytes) [PROBABLE] OAM frame: count=5 then 5 x (y,x,tile,attr) = 21 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6EB9:: ; 2A:6EB9
	db $05, $06, $04, $04, $01, $08, $0C, $02, $01, $08, $14, $03, $01, $00, $0C, $07
	db $01, $00, $14, $08, $01

; ---- data $6ECE-$6ED3 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2a 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2A_6ECE:: ; 2A:6ECE
	db $02, $00, $2A, $01, $08

; ---- words $6ED3-$6ED7 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $6ED7, $6EEC to OAM frames (extent = lowest target); referenced by an animation entry

Table_2A_6ED3:: ; 2A:6ED3
	dw Data_2A_6ED7, Data_2A_6EEC

; ---- data $6ED7-$6EEC (21 bytes) [PROBABLE] OAM frame: count=5 then 5 x (y,x,tile,attr) = 21 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6ED7:: ; 2A:6ED7
	db $05, $06, $03, $04, $01, $07, $0C, $00, $01, $07, $14, $01, $01, $FF, $0C, $05
	db $01, $FF, $14, $06, $01

; ---- data $6EEC-$6F01 (21 bytes) [PROBABLE] OAM frame: count=5 then 5 x (y,x,tile,attr) = 21 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6EEC:: ; 2A:6EEC
	db $05, $06, $04, $04, $01, $08, $0C, $00, $01, $08, $14, $01, $01, $00, $0C, $05
	db $01, $00, $14, $06, $01

; ---- data $6F01-$6F06 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2a 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2A_6F01:: ; 2A:6F01
	db $02, $00, $2A, $01, $08

; ---- words $6F06-$6F0A (4 bytes) [PROBABLE] frame table: 2 pointer(s) $6F0A, $6F23 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2A_6F06:: ; 2A:6F06
	dw Data_2A_6F0A, Data_2A_6F23

; ---- data $6F0A-$6F23 (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6F0A:: ; 2A:6F0A
	db $06, $FF, $05, $00, $02, $FF, $0D, $01, $02, $FF, $15, $02, $02, $07, $05, $03
	db $02, $07, $0D, $04, $02, $07, $15, $05, $02

; ---- data $6F23-$6F3C (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6F23:: ; 2A:6F23
	db $06, $FE, $05, $00, $02, $FE, $0D, $01, $02, $FE, $15, $02, $02, $06, $05, $03
	db $02, $06, $0D, $04, $02, $06, $15, $05, $02

; ---- data $6F3C-$6F41 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 08 01 23), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2A_6F3C:: ; 2A:6F3C
	db $02, $00, $08, $01, $23

; ---- words $6F41-$6F45 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $6F45, $6F5E to OAM frames (extent = lowest target); referenced by an animation entry

Table_2A_6F41:: ; 2A:6F41
	dw Data_2A_6F45, Data_2A_6F5E

; ---- data $6F45-$6F5E (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6F45:: ; 2A:6F45
	db $06, $FF, $05, $00, $02, $FF, $0D, $01, $02, $FF, $15, $02, $02, $07, $05, $03
	db $02, $07, $0D, $04, $02, $07, $15, $05, $02

; ---- data $6F5E-$6F77 (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6F5E:: ; 2A:6F5E
	db $06, $FE, $05, $00, $02, $FE, $0D, $01, $02, $FE, $15, $02, $02, $06, $05, $03
	db $02, $06, $0D, $04, $02, $06, $15, $05, $02

; ---- data $6F77-$6F7C (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 08 01 23), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2A_6F77:: ; 2A:6F77
	db $02, $00, $08, $01, $23

; ---- words $6F7C-$6F80 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $6F80, $6F91 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2A_6F7C:: ; 2A:6F7C
	dw Data_2A_6F80, Data_2A_6F91

; ---- data $6F80-$6F91 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6F80:: ; 2A:6F80
	db $04, $DD, $40, $2C, $23, $1C, $40, $2C, $23, $DD, $B8, $2C, $23, $1C, $B8, $2C
	db $23

; ---- data $6F91-$6F92 (1 bytes) [PROBABLE] OAM frame: count=0 then 0 x (y,x,tile,attr) = 1 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6F91:: ; 2A:6F91
	db $00

; ---- data $6F92-$6F95 (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 04), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2A_6F92:: ; 2A:6F92
	db $01, $00, $04
