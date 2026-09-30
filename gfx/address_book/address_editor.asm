; gfx/address_book/address_editor.asm
; bank 2F, $77D0-$7EBF (1775 bytes); pinned by layout.link
; address editor tilemap, palette, tables

SECTION "gfx/address_book/address_editor", ROMX

; ---- data $77D0-$7AC0 (752 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 77D0-7DD0 by higher-priority evidence]

Data_2F_77D0:: ; 2F:77D0
	db $00, $00, $FF, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
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
	db $48, $24, $48, $24, $48, $24, $C9, $24, $00, $E9, $06, $06, $FF, $F9, $FD, $00
	db $71, $08, $41, $30, $C5, $24, $8D, $4C, $1C, $95, $3E, $22, $F3, $C1, $E1, $00
	db $F2, $09, $02, $F9, $02, $81, $3B, $B8, $38, $AB, $7C, $44, $E7, $83, $C3, $00
	db $10, $08, $10, $08, $21, $18, $C2, $31, $00, $E3, $18, $08, $FF, $F7, $FF, $00
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
	db $02, $F1, $00, $03, $00, $00, $E1, $10, $00, $F1, $0E, $0E, $FF, $F1, $F9, $00
	db $12, $E9, $12, $09, $12, $09, $E1, $12, $0C, $ED, $1E, $12, $FB, $E1, $F1, $00
	db $42, $21, $C2, $21, $62, $91, $11, $AA, $00, $19, $40, $40, $FF, $BF, $FF, $00
	db $21, $D8, $21, $10, $21, $10, $F1, $08, $00, $F9, $00, $00, $FF, $FF, $FF, $00
	db $20, $96, $20, $90, $20, $90, $20, $90, $00, $B0, $0F, $07, $FF, $F8, $FE, $00
	db $84, $42, $84, $42, $84, $42, $60, $96, $00, $70, $0F, $07, $FF, $F8, $FC, $00
	db $40, $20, $40, $20, $20, $50, $18, $24, $00, $1C, $C3, $C1, $FF, $3E, $3F, $00
	db $67, $10, $69, $16, $29, $54, $27, $18, $00, $37, $C0, $C0, $FF, $3F, $3F, $00
	db $98, $50, $18, $D0, $38, $A0, $30, $A0, $30, $A0, $70, $40, $E0, $80, $C0, $00
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $E0, $C0
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $01, $01
	db $C7, $DB, $CE, $DD, $D9, $CE, $DB, $D5, $D3, $DE, $D2, $DF, $D2, $DF, $DB, $D7
	db $F0, $EE, $18, $FE, $EC, $DA, $24, $FE, $24, $FE, $24, $FE, $64, $BE, $7C, $EA
	db $D9, $CF, $CE, $DD, $C7, $DB, $C0, $DF, $C0, $C0, $FE, $FE, $F8, $F0, $F0, $F7
	db $D8, $F6, $00, $FE, $FE, $FC, $00, $FE, $00, $C0, $1F, $DF, $07, $C3, $03, $FB
	db $F0, $F0, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $03, $03, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

; ---- data $7AC0-$7D90 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2F:7020: hl=$7AC0 a=$2F b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_AbookAddr:: ; 2F:7AC0
Data_2F_7AC0::
	INCBIN "gfx/address_book/address_editor/abook_addr.tilemap"
	INCBIN "gfx/address_book/address_editor/abook_addr.attrmap"

; ---- data $7D90-$7D9E (14 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 77D0-7DD0 by higher-priority evidence]

Palette_AbookAddr_Bg:: ; 2F:7D90
Data_2F_7D90::
	INCLUDE "gfx/address_book/address_editor/abook_addr_bg.pal"

; ---- data $7D9E-$7DBE (32 bytes) [PROBABLE] palette-rgb555: heuristic: 16 RGB555 words as 4 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Data_2F_7D9E:: ; 2F:7D9E
	INCLUDE "gfx/address_book/address_editor/palette_7d9e.pal"

; ---- data $7DBE-$7DD0 (18 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 77D0-7DD0 by higher-priority evidence]

Data_2F_7DBE:: ; 2F:7DBE
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00

; ---- ptrtable $7DD0-$7E20 (80 bytes) [PROBABLE] 40 words, all inside 7E20-7EBF (frame data); tables of 4-byte entries (2 words) addressed by ld de,imm before FarCall 00:0A82 (init_object_from_table: reads the 4-byte entry number B&$7F of the table at DE); each 16-byte table = 4 identical-pair entries; no direct ld de,imm found (caller not located)

Table_2F_7DD0:: ; 2F:7DD0
	dw Data_2F_7E20
	dw $7E46
	dw Data_2F_7E20
	dw $7E46
	dw Data_2F_7E20
	dw $7E46
	dw Data_2F_7E20
	dw $7E46
	dw $7E4B
	dw $7E71
	dw $7E4B
	dw $7E71
	dw $7E4B
	dw $7E71
	dw $7E4B
	dw $7E71
	dw $7E76
	dw $7E8C
	dw $7E76
	dw $7E8C
	dw $7E76
	dw $7E8C
	dw $7E76
	dw $7E8C
	dw $7E91
	dw $7E9C
	dw $7E91
	dw $7E9C
	dw $7E91
	dw $7E9C
	dw $7E91
	dw $7E9C
	dw $7EA1
	dw $7EBC
	dw $7EA1
	dw $7EBC
	dw $7EA1
	dw $7EBC
	dw $7EA1
	dw $7EBC

; ---- data $7E20-$7EBF (159 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; ends with the group 01 00 04 right before the code at 7EBF

Data_2F_7E20:: ; 2F:7E20
	db $24, $7E, $35, $7E, $04, $00, $00, $08, $01, $00, $08, $09, $01, $00, $18, $0A
	db $01, $00, $20, $0B, $01, $04, $FF, $00, $08, $01, $FF, $08, $09, $01, $00, $18
	db $0A, $01, $00, $20, $0B, $01, $02, $00, $2E, $01, $08, $4F, $7E, $60, $7E, $04
	db $00, $18, $08, $01, $00, $20, $09, $01, $00, $00, $0A, $01, $00, $08, $0B, $01
	db $04, $00, $18, $08, $01, $00, $20, $09, $01, $FF, $00, $0A, $01, $FF, $08, $0B
	db $01, $02, $00, $2E, $01, $08, $7A, $7E, $83, $7E, $02, $00, $00, $0A, $01, $00
	db $08, $0B, $01, $02, $FF, $00, $0A, $01, $FF, $08, $0B, $01, $02, $00, $2E, $01
	db $08, $93, $7E, $02, $00, $00, $0A, $01, $00, $08, $0B, $01, $02, $00, $2E, $01
	db $08, $A3, $7E, $06, $FF, $02, $2B, $01, $FF, $0A, $2C, $01, $07, $02, $2D, $01
	db $07, $0A, $2E, $01, $0F, $02, $29, $01, $0F, $0A, $2A, $01, $01, $00, $04
