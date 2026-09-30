; gfx/settings/screens_bank71.asm
; bank 71, $6F44-$7740 (2044 bytes); pinned by layout.link
; settings screen art loaded by bank 67

SECTION "gfx/settings/screens_bank71", ROMX

; ---- data $6F44-$6F69 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_71_6F44:: ; 71:6F44
	db $09, $00, $00, $00, $00, $00, $08, $01, $00, $08, $00, $02, $00, $08, $08, $03
	db $00, $00, $10, $00, $20, $08, $10, $02, $20, $10, $00, $00, $40, $10, $08, $01
	db $40, $10, $10, $00, $60

; ---- data $6F69-$6F6A (1 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces; 0 piece(s) = an empty frame (1 byte); length tiles exactly against the frame-table pointers

Data_71_6F69:: ; 71:6F69
	db $00

; ---- data $6F6A-$6F6F (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:30 1:30; ends exactly at the tilemap block 6F6F

Data_71_6F6A:: ; 71:6F6A
	db $02, $00, $1E, $01, $1E

; ---- data $6F6F-$723F (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 67:65FD: hl=$6F6F a=$71 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Data_71_6F6F:: ; 71:6F6F
	INCBIN "gfx/settings/screens_bank71/tilemap_6f6f.tilemap"
	INCBIN "gfx/settings/screens_bank71/tilemap_6f6f.attrmap"

; ---- gfx $723F-$7271 (50 bytes) [PROBABLE] tiles-2bpp: heuristic: 35 coherent tiles (hsim2=0.670 vsim2=0.903, 1 blank) parity 1; 558/608 bytes also covered by call-site blocks [clipped from 7011-7271 by higher-priority evidence]

Data_71_723F:: ; 71:723F
	db $00, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FC, $01, $FD, $01, $FD, $01, $FC, $01, $FD, $01
	db $FC, $00

; ---- data $7271-$7740 (1231 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown [clipped from 7240-7740 by higher-priority evidence]

Data_71_7271:: ; 71:7271
	db $FF, $00, $1E, $40, $42, $54, $54, $56, $52, $52, $40, $F4, $F4, $F6, $42, $00
	db $FF, $00, $3F, $A0, $9F, $A2, $9C, $A1, $91, $A7, $96, $A6, $90, $80, $90, $00
	db $FF, $00, $DF, $A8, $27, $72, $51, $DC, $8C, $FF, $FB, $FB, $20, $20, $20, $00
	db $FF, $00, $FF, $00, $FC, $0B, $F3, $17, $64, $4C, $28, $5A, $10, $55, $11, $00
	db $FF, $00, $FF, $00, $1F, $E8, $E7, $F4, $93, $98, $8B, $AC, $85, $B5, $04, $00
	db $FF, $00, $FF, $00, $80, $3F, $BF, $3F, $80, $00, $C0, $1F, $E0, $00, $FF, $00
	db $FF, $00, $04, $55, $51, $55, $50, $54, $00, $05, $01, $FD, $00, $00, $FE, $00
	db $FF, $00, $F3, $04, $75, $86, $82, $9F, $1F, $07, $02, $9A, $A2, $82, $02, $00
	db $FF, $00, $FF, $00, $F8, $03, $1B, $D1, $C0, $17, $07, $F7, $02, $03, $1B, $00
	db $FF, $00, $8F, $20, $20, $FE, $FE, $8C, $88, $FF, $FF, $07, $02, $FE, $FE, $00
	db $FF, $00, $FF, $00, $FF, $80, $7F, $00, $7F, $40, $3F, $40, $3F, $40, $3F, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FC, $00, $FC, $01, $FD, $01, $FC, $00, $FC, $01, $FE, $00, $FF, $00, $FF, $E2
	db $E0, $F1, $D1, $D7, $46, $46, $40, $50, $40, $5E, $00, $10, $0E, $70, $8F, $D7
	db $C7, $D7, $80, $92, $82, $B3, $81, $A7, $97, $A7, $10, $20, $10, $E7, $18, $FF
	db $FF, $FF, $20, $22, $22, $26, $24, $FF, $FF, $FF, $00, $00, $00, $FF, $00, $55
	db $11, $53, $12, $52, $12, $5E, $0C, $6D, $00, $53, $20, $4E, $31, $C0, $3F, $45
	db $34, $55, $24, $AD, $48, $9B, $10, $76, $61, $6C, $03, $98, $07, $00, $FF, $00
	db $CF, $20, $AF, $60, $4F, $40, $40, $7F, $3F, $3F, $80, $00, $C0, $1F, $E0, $00
	db $FE, $00, $FE, $00, $FE, $00, $0E, $E9, $E5, $E9, $04, $08, $04, $F9, $06, $1F
	db $1F, $87, $82, $9A, $A2, $82, $82, $9F, $1F, $5F, $00, $40, $00, $DF, $20, $D3
	db $CA, $13, $0B, $F3, $08, $02, $1A, $D6, $C4, $D4, $00, $11, $08, $F3, $0C, $06
	db $02, $FE, $FE, $FE, $22, $A7, $85, $FD, $FC, $FC, $00, $01, $00, $7F, $80, $C0
	db $3F, $80, $7F, $80, $7F, $00, $7F, $40, $3F, $40, $3F, $C0, $3F, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $90
	db $8F, $90, $8F, $90, $8F, $9F, $8F, $98, $88, $90, $8F, $90, $8F, $90, $8F, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $08
	db $F1, $08, $F1, $08, $F1, $F8, $F1, $88, $81, $08, $F1, $08, $F1, $08, $F1, $10
	db $8F, $10, $8F, $10, $8F, $1F, $8F, $18, $88, $10, $8F, $10, $8F, $10, $8F, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $09
	db $F1, $09, $F1, $09, $F1, $F9, $F1, $89, $81, $09, $F1, $09, $F1, $09, $F1, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FE, $00, $FE, $00, $FE, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $88, $27, $27, $FF, $F9, $F9, $09, $09, $09, $59, $91, $39, $A9, $00
	db $FF, $00, $0C, $E1, $E9, $EB, $23, $2B, $21, $29, $25, $29, $25, $29, $25, $00
	db $FF, $00, $90, $27, $27, $F7, $F4, $34, $24, $E7, $E7, $27, $24, $E4, $E4, $00
	db $FF, $00, $30, $A7, $97, $A7, $90, $A5, $95, $A3, $9A, $A6, $94, $AF, $8B, $00
	db $FF, $00, $0B, $A4, $A5, $AE, $AA, $BE, $14, $FD, $E8, $ED, $04, $FE, $FA, $00
	db $FF, $00, $F4, $09, $E9, $1C, $D4, $B5, $21, $BE, $1C, $1F, $8B, $3F, $BC, $00
	db $FF, $00, $06, $F4, $F2, $34, $12, $F4, $F2, $34, $13, $F8, $FB, $FA, $41, $00
	db $FF, $00, $00, $FF, $FF, $F5, $04, $7F, $7F, $7F, $44, $44, $44, $7F, $7F, $00
	db $FF, $00, $08, $EB, $E3, $EB, $02, $CB, $C3, $DB, $42, $53, $4B, $D3, $CA, $00
	db $FF, $00, $00, $EF, $EF, $2C, $28, $EF, $EF, $2C, $28, $EF, $EF, $EF, $00, $00
	db $FF, $00, $3F, $A0, $9F, $A0, $9F, $A0, $9F, $A0, $9F, $A0, $9F, $A0, $9F, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FE, $00, $FE, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $79
	db $71, $F9, $A9, $AA, $23, $23, $22, $26, $A4, $24, $80, $09, $C0, $1B, $E4, $29
	db $25, $2B, $23, $2B, $20, $29, $25, $CB, $E2, $EA, $00, $08, $04, $79, $86, $27
	db $27, $F7, $F4, $F4, $04, $25, $24, $35, $15, $55, $00, $C0, $00, $9F, $60, $AB
	db $82, $A3, $93, $AB, $91, $A1, $81, $2F, $8F, $AF, $00, $20, $00, $EF, $10, $0A
	db $08, $F8, $F8, $FB, $10, $10, $10, $FE, $FE, $FE, $00, $00, $00, $FF, $00, $BA
	db $0A, $AF, $2D, $AD, $28, $A9, $09, $BF, $3E, $BE, $00, $80, $00, $BF, $40, $4A
	db $49, $5A, $50, $52, $40, $56, $50, $D8, $CA, $CA, $01, $12, $01, $FE, $01, $7F
	db $44, $44, $44, $FF, $FF, $FF, $40, $41, $41, $5D, $00, $10, $0C, $71, $8E, $D2
	db $4A, $42, $4A, $EA, $E2, $6A, $42, $CA, $C2, $DA, $00, $10, $08, $F3, $0C, $FE
	db $FE, $FE, $28, $FE, $FE, $F8, $28, $69, $49, $41, $00, $90, $00, $B7, $48, $A0
	db $9F, $A0, $9F, $A0, $9F, $A0, $9F, $A0, $9F, $A0, $1F, $20, $1F, $E0, $1F, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $90
	db $8F, $90, $8F, $90, $8F, $9F, $8F, $98, $88, $90, $8F, $90, $8F, $90, $8F, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $09
	db $F1, $09, $F1, $09, $F1, $F9, $F1, $89, $81, $09, $F1, $09, $F1, $09, $F1, $90
	db $8F, $90, $8F, $90, $8F, $9F, $8F, $98, $88, $90, $8F, $90, $8F, $90, $8F, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $09
	db $F1, $09, $F1, $09, $F1, $F9, $F1, $89, $81, $09, $F1, $09, $F1, $09, $F1
