; gfx/comm/connection_icon.asm
; bank 69, $4152-$4C46 (2804 bytes); pinned by layout.link
; connection icon tiles, palettes, object tables

SECTION "gfx/comm/connection_icon", ROMX

; ---- gfx $4152-$4160 (14 bytes) [PROBABLE] tiles-2bpp: heuristic: 49 coherent tiles (hsim2=0.735 vsim2=0.659, 3 blank) parity 1; 993/1008 bytes also covered by call-site blocks [clipped from 4151-4541 by higher-priority evidence]

Data_69_4152:: ; 69:4152
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- gfx $4160-$4560 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 69:4124: hl=$4160 a=$69 c=$40 de=$8200 (dest VRAM $8200, vbank=0)

ConnIcon_Tiles0:: ; 69:4160
Data_69_4160::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $1E, $1E, $21, $3F, $40, $7F, $40, $7F, $40, $7F, $61, $5E, $3F, $21, $1E, $12
	db $00, $00, $00, $00, $80, $80, $80, $80, $80, $80, $80, $80, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $1E, $1E, $21, $3F, $40, $7F, $40, $7F, $40, $7F, $61, $5E, $3F, $21, $1E, $12
	db $00, $00, $00, $00, $80, $80, $80, $80, $80, $80, $80, $80, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $1E, $1E, $21, $3F, $40, $7F, $40, $7F, $40, $7F, $61, $5E, $3F, $21
	db $00, $00, $00, $00, $00, $00, $80, $80, $80, $80, $80, $80, $80, $80, $60, $60
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $0F, $0F, $10, $1F, $20, $3F, $20, $3F, $20, $3F, $30, $2F, $1F, $10
	db $00, $00, $00, $00, $80, $80, $40, $C0, $40, $C0, $40, $C0, $C0, $40, $80, $80
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01
	db $00, $00, $00, $00, $00, $00, $78, $78, $84, $FC, $02, $FE, $02, $FE, $02, $FE
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $27, $3B, $D3, $FE, $33, $FF, $73, $BF, $D2, $DE, $33, $3F, $39, $2F, $7C, $47
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $16, $1A, $32, $2E, $22, $3E, $4A, $7E, $5A, $6E, $33, $3F, $11, $1E, $11, $1E
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $80, $80
	db $00, $00, $00, $00, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00
	db $35, $3B, $F2, $DF, $F3, $3F, $F3, $3F, $D6, $DA, $37, $2F, $27, $3B, $47, $7A
	db $00, $00, $C0, $C0, $20, $E0, $E0, $20, $C0, $C0, $00, $00, $80, $80, $80, $80
	db $01, $01, $02, $03, $03, $02, $01, $01, $00, $00, $01, $01, $01, $01, $00, $00
	db $FF, $F3, $F4, $1B, $F3, $7F, $92, $9E, $E7, $FD, $0F, $FC, $33, $D2, $99, $E9
	db $D0, $B0, $30, $D0, $E0, $E0, $00, $00, $60, $60, $90, $F0, $30, $D0, $E0, $20
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $1F, $13, $2C, $34, $24, $3C, $52, $7E, $5E, $72, $4F, $7F, $33, $3D, $11, $1F
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $C0, $40, $40, $C0
	db $01, $01, $00, $00, $00, $00, $01, $01, $01, $01, $03, $02, $02, $03, $03, $02
	db $86, $7A, $FC, $84, $F8, $98, $B7, $57, $19, $FF, $5B, $BD, $43, $FD, $FF, $41
	db $00, $00, $00, $00, $00, $00, $80, $80, $40, $C0, $C0, $40, $C0, $40, $C0, $40
	db $FF, $F3, $07, $FA, $F3, $7F, $92, $9E, $F9, $EF, $FC, $0F, $F2, $13, $F9, $89
	db $00, $00, $01, $01, $03, $03, $07, $07, $0E, $0F, $1F, $1E, $00, $00, $00, $00
	db $7F, $7F, $FF, $C0, $8C, $F3, $06, $F9, $1F, $E0, $FF, $00, $00, $00, $00, $00
	db $00, $00, $C0, $C0, $60, $A0, $30, $D0, $E8, $18, $FC, $04, $00, $00, $00, $00
	db $00, $00, $01, $01, $03, $03, $07, $07, $0F, $0E, $1E, $1F, $00, $00, $00, $00
	db $7F, $7F, $FF, $C0, $83, $FC, $02, $FD, $DF, $20, $7F, $80, $00, $00, $00, $00
	db $80, $80, $C0, $C0, $E0, $20, $F0, $10, $F8, $08, $DC, $24, $00, $00, $00, $00
	db $00, $00, $01, $01, $03, $03, $07, $07, $0E, $0F, $1E, $1F, $00, $00, $00, $00
	db $7F, $7F, $FF, $C0, $FE, $81, $5B, $A4, $77, $88, $FF, $00, $00, $00, $00, $00
	db $80, $80, $C0, $C0, $E0, $20, $F0, $10, $F8, $08, $8C, $74, $00, $00, $00, $00
	db $00, $00, $01, $01, $03, $03, $07, $07, $0E, $0F, $1F, $1E, $00, $00, $00, $00
	db $7F, $7F, $FF, $C0, $B0, $CF, $FC, $03, $FE, $01, $7F, $80, $00, $00, $00, $00
	db $00, $00, $C0, $C0, $E0, $20, $30, $D0, $18, $E8, $0C, $F4, $00, $00, $00, $00
	db $01, $01, $01, $01, $03, $03, $07, $07, $0E, $0F, $1F, $1E, $00, $00, $00, $00
	db $FF, $FF, $FF, $C0, $8C, $F3, $06, $F9, $1F, $E0, $FF, $00, $00, $00, $00, $00
	db $80, $80, $C0, $C0, $60, $A0, $30, $D0, $E8, $18, $FC, $04, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $3C, $3C, $42, $7E, $81, $FF, $81, $FF, $81, $FF
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $02, $03, $02, $03
	db $00, $00, $00, $00, $00, $00, $00, $00, $F0, $F0, $08, $F8, $04, $FC, $04, $FC
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $02, $03, $04, $07
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $E0, $E0, $10, $F0, $08, $F8
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $03, $02, $02, $03, $03, $02
	db $C3, $BD, $7E, $42, $FE, $8E, $39, $DF, $1B, $FD, $5B, $B5, $43, $FD, $FF, $4F
	db $00, $00, $00, $00, $00, $00, $80, $80, $40, $C0, $C0, $40, $C0, $40, $C0, $40
	db $02, $03, $03, $02, $01, $01, $00, $00, $01, $01, $01, $01, $02, $03, $03, $02
	db $04, $FC, $0C, $F4, $F9, $09, $B6, $D7, $19, $FF, $1B, $FD, $43, $FD, $FF, $41
	db $00, $00, $00, $00, $80, $80, $40, $C0, $C0, $40, $C0, $40, $C0, $40, $C0, $C0
	db $04, $07, $04, $07, $06, $05, $03, $02, $01, $01, $01, $01, $02, $03, $03, $02
	db $08, $F8, $0F, $FF, $19, $EF, $FB, $1D, $7B, $9D, $13, $FD, $47, $FB, $FE, $4E
	db $00, $00, $80, $80, $40, $C0, $C0, $40, $C0, $40, $C0, $40, $80, $80, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- gfx $4560-$4760 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 69:4136: hl=$4560 a=$69 c=$20 de=$8600 (dest VRAM $8600, vbank=0)

ConnIcon_Tiles1:: ; 69:4560
Data_69_4560::
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
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- data $4760-$4778 (24 bytes) [PROBABLE] 3 RGB555 palettes of 4 colours (00 00 4A 29 B5 56 FF 7F = grey ramp; bit15 clear). Previous 168-word palette claim for 4760-48B0 was wrong beyond 4778: the bytes from 4778 are the animation table below

ConnIcon_Palettes:: ; 69:4760
Palette_69_4760::
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $7C, $B7, $00, $DF, $02, $00, $00
	db $00, $7C, $E0, $01, $8B, $03, $00, $00

; ---- ptrtable $4778-$4794 (28 bytes) [PROBABLE] 7 entries x 4 bytes = 2 pointers each, table passed as DE to init_object_from_table (00:0A82) at 4E:6057 (a=$69): entry index B&7F is read by 00:0AB8, word0 -> slot+2/3 (pointer list of frames), word1 -> slot+8/9 (count + 2-byte pairs). Every target lands on a record boundary of the parse below (tiles 4778-4C46 exactly)

ConnIcon_ObjTable:: ; 69:4778
Table_69_4778::
	dw Table_69_4794
	dw Data_69_48AC
	dw Table_69_4794
	dw Data_69_48AC
	dw Table_69_48B5
	dw Data_69_49CD
	dw Table_69_49DE
	dw Data_69_4A01
	dw Table_69_4A73
	dw Data_69_4B9F
	dw Table_69_4BAB
	dw Data_69_4C41
	dw Table_69_4A05
	dw Data_69_4A6A

; ---- ptrtable $4794-$47A4 (16 bytes) [PROBABLE] list of 8 frame pointers (word0 of Table_69_4778 entries); each target is a count-prefixed OAM record

Table_69_4794:: ; 69:4794
	dw Data_69_47A4
	dw Data_69_47C1
	dw Data_69_47E2
	dw Data_69_4803
	dw Data_69_4824
	dw Data_69_4841
	dw Data_69_4862
	dw Data_69_4887

; ---- data $47A4-$47C1 (29 bytes) [PROBABLE] sprite frame record: count=7 then 7 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_47A4:: ; 69:47A4
	db $07, $01, $08, $21, $05, $01, $10, $22, $06, $09, $08, $31, $05, $09, $10, $32
	db $06, $11, $00, $40, $06, $11, $08, $41, $06, $11, $10, $42, $06

; ---- data $47C1-$47E2 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_47C1:: ; 69:47C1
	db $08, $01, $08, $24, $05, $01, $10, $25, $05, $09, $00, $33, $06, $09, $08, $34
	db $05, $09, $10, $35, $05, $11, $00, $43, $06, $11, $08, $44, $06, $11, $10, $45
	db $06

; ---- data $47E2-$4803 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_47E2:: ; 69:47E2
	db $08, $01, $08, $27, $05, $01, $10, $28, $05, $09, $00, $36, $05, $09, $08, $37
	db $05, $09, $10, $38, $05, $11, $00, $46, $06, $11, $08, $47, $06, $11, $10, $48
	db $06

; ---- data $4803-$4824 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4803:: ; 69:4803
	db $08, $01, $08, $24, $05, $01, $10, $25, $05, $09, $00, $33, $06, $09, $08, $34
	db $05, $09, $10, $35, $05, $11, $00, $49, $06, $11, $08, $4A, $06, $11, $10, $4B
	db $06

; ---- data $4824-$4841 (29 bytes) [PROBABLE] sprite frame record: count=7 then 7 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4824:: ; 69:4824
	db $07, $01, $08, $21, $05, $01, $10, $22, $06, $09, $08, $31, $05, $09, $10, $32
	db $06, $11, $00, $40, $06, $11, $08, $41, $06, $11, $10, $42, $06

; ---- data $4841-$4862 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4841:: ; 69:4841
	db $08, $01, $08, $24, $05, $01, $10, $25, $05, $09, $00, $33, $06, $09, $10, $35
	db $05, $11, $00, $43, $06, $11, $08, $44, $06, $11, $10, $45, $06, $09, $08, $2F
	db $05

; ---- data $4862-$4887 (37 bytes) [PROBABLE] sprite frame record: count=9 then 9 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4862:: ; 69:4862
	db $09, $01, $00, $26, $05, $01, $08, $27, $05, $01, $10, $28, $05, $09, $00, $36
	db $05, $09, $10, $38, $05, $11, $00, $46, $06, $11, $08, $47, $06, $11, $10, $48
	db $06, $09, $08, $3F, $05

; ---- data $4887-$48AC (37 bytes) [PROBABLE] sprite frame record: count=9 then 9 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4887:: ; 69:4887
	db $09, $01, $00, $23, $05, $01, $08, $24, $05, $01, $10, $25, $05, $09, $00, $33
	db $06, $09, $10, $35, $05, $11, $00, $43, $06, $11, $08, $44, $06, $11, $10, $45
	db $06, $09, $08, $2F, $05

; ---- data $48AC-$48B5 (9 bytes) [PROBABLE] count=4 then 4 x 2-byte pairs; word1 of an entry of Table_69_4778 (read via 00:0AB8 at +1..)

Data_69_48AC:: ; 69:48AC
	db $04, $00, $08, $01, $08, $02, $08, $03, $08

; ---- ptrtable $48B5-$48C5 (16 bytes) [PROBABLE] list of 8 frame pointers (word0 of Table_69_4778 entries); each target is a count-prefixed OAM record

Table_69_48B5:: ; 69:48B5
	dw Data_69_48C5
	dw Data_69_48E2
	dw Data_69_4903
	dw Data_69_4924
	dw Data_69_4945
	dw Data_69_4962
	dw Data_69_4983
	dw Data_69_49A8

; ---- data $48C5-$48E2 (29 bytes) [PROBABLE] sprite frame record: count=7 then 7 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_48C5:: ; 69:48C5
	db $07, $01, $08, $21, $05, $01, $10, $22, $06, $09, $08, $31, $05, $09, $10, $32
	db $06, $11, $00, $40, $06, $11, $08, $41, $06, $11, $10, $42, $06

; ---- data $48E2-$4903 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_48E2:: ; 69:48E2
	db $08, $01, $08, $24, $05, $01, $10, $25, $05, $09, $00, $33, $06, $09, $08, $34
	db $05, $09, $10, $35, $05, $11, $00, $43, $06, $11, $08, $44, $06, $11, $10, $45
	db $06

; ---- data $4903-$4924 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4903:: ; 69:4903
	db $08, $01, $08, $27, $05, $01, $10, $28, $05, $09, $00, $36, $05, $09, $08, $37
	db $05, $09, $10, $38, $05, $11, $00, $46, $06, $11, $08, $47, $06, $11, $10, $48
	db $06

; ---- data $4924-$4945 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4924:: ; 69:4924
	db $08, $01, $08, $24, $05, $01, $10, $25, $05, $09, $00, $33, $06, $09, $08, $34
	db $05, $09, $10, $35, $05, $11, $00, $49, $06, $11, $08, $4A, $06, $11, $10, $4B
	db $06

; ---- data $4945-$4962 (29 bytes) [PROBABLE] sprite frame record: count=7 then 7 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4945:: ; 69:4945
	db $07, $01, $08, $21, $05, $01, $10, $22, $06, $09, $08, $31, $05, $09, $10, $32
	db $06, $11, $00, $40, $06, $11, $08, $41, $06, $11, $10, $42, $06

; ---- data $4962-$4983 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4962:: ; 69:4962
	db $08, $01, $08, $24, $05, $01, $10, $25, $05, $09, $00, $33, $06, $09, $10, $35
	db $05, $11, $00, $43, $06, $11, $08, $44, $06, $11, $10, $45, $06, $09, $08, $2F
	db $05

; ---- data $4983-$49A8 (37 bytes) [PROBABLE] sprite frame record: count=9 then 9 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4983:: ; 69:4983
	db $09, $01, $00, $26, $05, $01, $08, $27, $05, $01, $10, $28, $05, $09, $00, $36
	db $05, $09, $10, $38, $05, $11, $00, $46, $06, $11, $08, $47, $06, $11, $10, $48
	db $06, $09, $08, $3F, $05

; ---- data $49A8-$49CD (37 bytes) [PROBABLE] sprite frame record: count=9 then 9 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_49A8:: ; 69:49A8
	db $09, $01, $00, $23, $05, $01, $08, $24, $05, $01, $10, $25, $05, $09, $00, $33
	db $06, $09, $10, $35, $05, $11, $00, $43, $06, $11, $08, $44, $06, $11, $10, $45
	db $06, $09, $08, $2F, $05

; ---- data $49CD-$49DE (17 bytes) [PROBABLE] count=8 then 8 x 2-byte pairs; word1 of an entry of Table_69_4778 (read via 00:0AB8 at +1..)

Data_69_49CD:: ; 69:49CD
	db $08, $00, $08, $01, $08, $02, $08, $03, $08, $00, $08, $05, $08, $06, $08, $07
	db $08

; ---- ptrtable $49DE-$49E0 (2 bytes) [PROBABLE] list of 1 frame pointers (word0 of Table_69_4778 entries); each target is a count-prefixed OAM record

Table_69_49DE:: ; 69:49DE
	dw Data_69_49E0

; ---- data $49E0-$4A01 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_49E0:: ; 69:49E0
	db $08, $01, $00, $2C, $05, $01, $08, $2D, $05, $09, $00, $3C, $05, $09, $08, $3D
	db $05, $09, $10, $3E, $05, $11, $00, $40, $06, $11, $08, $41, $06, $11, $10, $42
	db $06

; ---- data $4A01-$4A05 (4 bytes) [PROBABLE] count=1 then 1 x 2-byte pairs; word1 of an entry of Table_69_4778 (read via 00:0AB8 at +1..) (+1 unreferenced trailing byte(s) 00 kept with this record)

Data_69_4A01:: ; 69:4A01
	db $01, $00, $05, $00

; ---- ptrtable $4A05-$4A0B (6 bytes) [PROBABLE] list of 3 frame pointers (word0 of Table_69_4778 entries); each target is a count-prefixed OAM record

Table_69_4A05:: ; 69:4A05
	dw Data_69_4A0B
	dw Data_69_4A2C
	dw Data_69_4A49

; ---- data $4A0B-$4A2C (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4A0B:: ; 69:4A0B
	db $08, $01, $00, $2C, $05, $01, $08, $2D, $05, $09, $00, $3C, $05, $09, $08, $3D
	db $05, $09, $10, $3E, $05, $11, $00, $4C, $06, $11, $08, $4D, $06, $11, $10, $4E
	db $06

; ---- data $4A2C-$4A49 (29 bytes) [PROBABLE] sprite frame record: count=7 then 7 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4A2C:: ; 69:4A2C
	db $07, $11, $00, $4C, $06, $11, $08, $4D, $06, $11, $10, $4E, $06, $01, $08, $4F
	db $05, $09, $00, $55, $05, $09, $08, $56, $05, $09, $10, $57, $05

; ---- data $4A49-$4A6A (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4A49:: ; 69:4A49
	db $08, $11, $00, $4C, $06, $11, $08, $4D, $06, $11, $10, $4E, $06, $01, $00, $50
	db $05, $01, $08, $51, $05, $09, $00, $58, $05, $09, $08, $59, $05, $09, $10, $5A
	db $05

; ---- data $4A6A-$4A73 (9 bytes) [PROBABLE] count=4 then 4 x 2-byte pairs; word1 of an entry of Table_69_4778 (read via 00:0AB8 at +1..)

Data_69_4A6A:: ; 69:4A6A
	db $04, $00, $08, $01, $14, $00, $08, $02, $14

; ---- ptrtable $4A73-$4A7B (8 bytes) [PROBABLE] list of 4 frame pointers (word0 of Table_69_4778 entries); each target is a count-prefixed OAM record

Table_69_4A73:: ; 69:4A73
	dw Data_69_4A7B
	dw Data_69_4AC4
	dw Data_69_4B0D
	dw Data_69_4B56

; ---- data $4A7B-$4AC4 (73 bytes) [PROBABLE] sprite frame record: count=18 then 18 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4A7B:: ; 69:4A7B
	db $12, $00, $00, $20, $05, $00, $08, $21, $05, $00, $10, $22, $05, $08, $00, $30
	db $05, $08, $08, $31, $05, $08, $10, $32, $05, $10, $00, $40, $05, $10, $08, $41
	db $05, $10, $10, $42, $05, $00, $00, $2C, $06, $00, $08, $2D, $06, $00, $10, $2E
	db $06, $08, $00, $3C, $06, $08, $08, $3D, $06, $08, $10, $3E, $06, $10, $00, $4C
	db $06, $10, $08, $4D, $06, $10, $10, $4E, $06

; ---- data $4AC4-$4B0D (73 bytes) [PROBABLE] sprite frame record: count=18 then 18 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4AC4:: ; 69:4AC4
	db $12, $00, $00, $23, $05, $00, $08, $24, $05, $00, $10, $25, $05, $08, $00, $33
	db $05, $08, $08, $34, $05, $08, $10, $35, $05, $10, $00, $43, $05, $10, $08, $44
	db $05, $10, $10, $45, $05, $00, $00, $2C, $06, $00, $08, $2D, $06, $00, $10, $2E
	db $06, $08, $00, $3C, $06, $08, $08, $3D, $06, $08, $10, $3E, $06, $10, $00, $4C
	db $06, $10, $08, $4D, $06, $10, $10, $4E, $06

; ---- data $4B0D-$4B56 (73 bytes) [PROBABLE] sprite frame record: count=18 then 18 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4B0D:: ; 69:4B0D
	db $12, $00, $00, $26, $05, $00, $08, $27, $05, $00, $10, $28, $05, $08, $00, $36
	db $05, $08, $08, $37, $05, $08, $10, $38, $05, $10, $00, $46, $05, $10, $08, $47
	db $05, $10, $10, $48, $05, $00, $00, $2C, $06, $00, $08, $2D, $06, $00, $10, $2E
	db $06, $08, $00, $3C, $06, $08, $08, $3D, $06, $08, $10, $3E, $06, $10, $00, $4C
	db $06, $10, $08, $4D, $06, $10, $10, $4E, $06

; ---- data $4B56-$4B9F (73 bytes) [PROBABLE] sprite frame record: count=18 then 18 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4B56:: ; 69:4B56
	db $12, $00, $00, $29, $05, $00, $08, $2A, $05, $00, $10, $2B, $05, $08, $00, $39
	db $05, $08, $08, $3A, $05, $08, $10, $3B, $05, $10, $00, $49, $05, $10, $08, $4A
	db $05, $10, $10, $4B, $05, $00, $00, $2C, $06, $00, $08, $2D, $06, $00, $10, $2E
	db $06, $08, $00, $3C, $06, $08, $08, $3D, $06, $08, $10, $3E, $06, $10, $00, $4C
	db $06, $10, $08, $4D, $06, $10, $10, $4E, $06

; ---- data $4B9F-$4BAB (12 bytes) [PROBABLE] count=4 then 4 x 2-byte pairs; word1 of an entry of Table_69_4778 (read via 00:0AB8 at +1..) (+3 unreferenced trailing byte(s) 010004 kept with this record)

Data_69_4B9F:: ; 69:4B9F
	db $04, $00, $0C, $01, $0C, $02, $0C, $03, $0C, $01, $00, $04

; ---- ptrtable $4BAB-$4BAF (4 bytes) [PROBABLE] list of 2 frame pointers (word0 of Table_69_4778 entries); each target is a count-prefixed OAM record

Table_69_4BAB:: ; 69:4BAB
	dw Data_69_4BAF
	dw Data_69_4BF8

; ---- data $4BAF-$4BF8 (73 bytes) [PROBABLE] sprite frame record: count=18 then 18 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4BAF:: ; 69:4BAF
	db $12, $01, $00, $20, $05, $01, $08, $21, $05, $01, $10, $22, $05, $09, $00, $30
	db $05, $09, $08, $31, $05, $09, $10, $32, $05, $11, $00, $40, $05, $11, $08, $41
	db $05, $11, $10, $42, $05, $01, $00, $2C, $06, $01, $08, $2D, $06, $01, $10, $2E
	db $06, $09, $00, $3C, $06, $09, $08, $3D, $06, $09, $10, $3E, $06, $11, $00, $4C
	db $06, $11, $08, $4D, $06, $11, $10, $4E, $06

; ---- data $4BF8-$4C41 (73 bytes) [PROBABLE] sprite frame record: count=18 then 18 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

Data_69_4BF8:: ; 69:4BF8
	db $12, $00, $00, $20, $05, $00, $08, $21, $05, $00, $10, $22, $05, $08, $00, $30
	db $05, $08, $08, $31, $05, $08, $10, $32, $05, $10, $00, $40, $05, $10, $08, $41
	db $05, $10, $10, $42, $05, $00, $00, $2C, $06, $00, $08, $2D, $06, $00, $10, $2E
	db $06, $08, $00, $3C, $06, $08, $08, $3D, $06, $08, $10, $3E, $06, $10, $00, $4C
	db $06, $10, $08, $4D, $06, $10, $10, $4E, $06

; ---- data $4C41-$4C46 (5 bytes) [PROBABLE] count=2 then 2 x 2-byte pairs; word1 of an entry of Table_69_4778 (read via 00:0AB8 at +1..)

Data_69_4C41:: ; 69:4C41
	db $02, $00, $14, $01, $14
