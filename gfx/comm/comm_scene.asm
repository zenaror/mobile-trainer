; gfx/comm/comm_scene.asm
; bank 70, $4822-$7590 (11630 bytes); pinned by layout.link
; comm scene text-box maps, object tables, tiles, panorama map

SECTION "gfx/comm/comm_scene", ROMX

; ---- ptrtable $4822-$4832 (16 bytes) [CONFIRMED] 8 word pointers to the 20x4 tilemap+attr blocks 7090..74F0 (stride $A0); indexed by A in Function_70_4803 (70:4803, executed) via ld hl,$4822 ; add a,a ... ; length 8 = 16 bytes to the next table at 4832; all 8 targets are block-aligned in 7090-7590

CommScene_TextBoxMaps:: ; 70:4822
Table_70_4822::
	dw Tilemap_CommScene_TextBox0
	dw Tilemap_CommScene_TextBox1
	dw Tilemap_CommScene_TextBox2
	dw Tilemap_CommScene_TextBox3
	dw Tilemap_CommScene_TextBox4
	dw Tilemap_CommScene_TextBox5
	dw Tilemap_CommScene_TextBox6
	dw Tilemap_CommScene_TextBox7

; ---- ptrtable $4832-$4846 (20 bytes) [PROBABLE] animation table: 5 entries x 4 bytes (2 pointers each; entry 0 may be null), used as DE by init_object_from_table (00:0A82 / 00:0AB8, index = B&7F): word0 = list of frame pointers, word1 = count + 2-byte pairs. No executed caller found; same format as the CONFIRMED tables 534C/53EB; whole structure tiles exactly (every pointer lands on a record start)

Table_70_4832:: ; 70:4832
	dw $0000
	dw $0000
	dw Table_70_4846
	dw Data_70_4904
	dw Table_70_4911
	dw Data_70_4AB9
	dw Table_70_4AC2
	dw Data_70_4B84
	dw Table_70_4B91
	dw Data_70_4C4F

; ---- ptrtable $4846-$4852 (12 bytes) [PROBABLE] list of 6 frame pointers (word0 of an entry of Table_70_4832); each target is a count-prefixed OAM record

Table_70_4846:: ; 70:4846
	dw Data_70_4852
	dw Data_70_4857
	dw Data_70_4868
	dw Data_70_4881
	dw Data_70_48B2
	dw Data_70_4903

; ---- data $4852-$4857 (5 bytes) [PROBABLE] sprite frame record: count=1 then 1 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4852:: ; 70:4852
	db $01, $0D, $0C, $58, $00

; ---- data $4857-$4868 (17 bytes) [PROBABLE] sprite frame record: count=4 then 4 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4857:: ; 70:4857
	db $04, $08, $18, $44, $20, $08, $10, $46, $20, $08, $00, $44, $00, $08, $08, $46
	db $00

; ---- data $4868-$4881 (25 bytes) [PROBABLE] sprite frame record: count=6 then 6 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4868:: ; 70:4868
	db $06, $00, $04, $30, $00, $00, $0C, $32, $00, $00, $14, $34, $00, $10, $04, $36
	db $00, $10, $0C, $38, $00, $10, $14, $3A, $00

; ---- data $4881-$48B2 (49 bytes) [PROBABLE] sprite frame record: count=12 then 12 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4881:: ; 70:4881
	db $0C, $00, $00, $20, $00, $00, $08, $22, $00, $00, $10, $24, $00, $00, $18, $26
	db $00, $10, $00, $28, $00, $10, $08, $2A, $00, $10, $10, $2C, $00, $10, $18, $2E
	db $00, $20, $18, $4A, $00, $F4, $08, $4A, $00, $14, $F8, $4A, $00, $04, $1E, $4A
	db $00

; ---- data $48B2-$4903 (81 bytes) [PROBABLE] sprite frame record: count=20 then 20 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_48B2:: ; 70:48B2
	db $14, $00, $00, $10, $06, $00, $08, $12, $06, $00, $10, $14, $06, $00, $18, $16
	db $06, $10, $00, $18, $06, $10, $08, $1A, $06, $10, $10, $1C, $06, $10, $18, $1E
	db $06, $00, $00, $00, $05, $00, $08, $02, $05, $00, $10, $04, $05, $00, $18, $06
	db $05, $10, $00, $08, $05, $10, $08, $0A, $05, $10, $10, $0C, $05, $10, $18, $0E
	db $05, $1C, $18, $48, $00, $FC, $28, $48, $00, $10, $F4, $48, $00, $E8, $04, $48
	db $00

; ---- data $4903-$4904 (1 bytes) [PROBABLE] sprite frame record: count=0 then 0 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4903:: ; 70:4903
	db $00

; ---- data $4904-$4911 (13 bytes) [PROBABLE] count=6 then 6 x 2-byte pairs; word1 of an entry of Table_70_4832 (read by 00:0AB8 through [slot+8])

Data_70_4904:: ; 70:4904
	db $06, $05, $07, $00, $05, $01, $07, $02, $04, $03, $07, $04, $0A

; ---- ptrtable $4911-$4919 (8 bytes) [PROBABLE] list of 4 frame pointers (word0 of an entry of Table_70_4832); each target is a count-prefixed OAM record

Table_70_4911:: ; 70:4911
	dw Data_70_4919
	dw Data_70_497E
	dw Data_70_49E3
	dw Data_70_4A50

; ---- data $4919-$497E (101 bytes) [PROBABLE] sprite frame record: count=25 then 25 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4919:: ; 70:4919
	db $19, $04, $18, $3C, $00, $14, $18, $3E, $00, $00, $00, $10, $06, $00, $08, $12
	db $06, $00, $10, $14, $06, $00, $18, $16, $06, $10, $00, $18, $06, $10, $08, $1A
	db $06, $10, $10, $1C, $06, $10, $18, $1E, $06, $00, $00, $00, $05, $00, $08, $02
	db $05, $00, $10, $04, $05, $00, $18, $06, $05, $10, $00, $08, $05, $10, $08, $0A
	db $05, $10, $10, $0C, $05, $10, $18, $0E, $05, $3C, $04, $4E, $00, $CC, $04, $3C
	db $00, $DC, $04, $3E, $00, $E4, $28, $50, $00, $F4, $28, $52, $00, $F4, $F4, $50
	db $00, $04, $F4, $52, $00

; ---- data $497E-$49E3 (101 bytes) [PROBABLE] sprite frame record: count=25 then 25 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_497E:: ; 70:497E
	db $19, $01, $00, $10, $06, $01, $08, $12, $06, $01, $10, $14, $06, $01, $18, $16
	db $06, $11, $00, $18, $06, $11, $08, $1A, $06, $11, $10, $1C, $06, $11, $18, $1E
	db $06, $01, $00, $00, $05, $01, $08, $02, $05, $01, $10, $04, $05, $01, $18, $06
	db $05, $11, $00, $08, $05, $11, $08, $0A, $05, $11, $10, $0C, $05, $11, $18, $0E
	db $05, $24, $04, $3C, $00, $34, $04, $3E, $00, $E8, $18, $3C, $00, $F8, $18, $3E
	db $00, $D8, $F4, $50, $00, $E8, $F4, $52, $00, $C8, $28, $50, $00, $D8, $28, $52
	db $00, $34, $28, $50, $00

; ---- data $49E3-$4A50 (109 bytes) [PROBABLE] sprite frame record: count=27 then 27 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_49E3:: ; 70:49E3
	db $1B, $02, $00, $10, $06, $02, $08, $12, $06, $02, $10, $14, $06, $02, $18, $16
	db $06, $12, $00, $18, $06, $12, $08, $1A, $06, $12, $10, $1C, $06, $12, $18, $1E
	db $06, $02, $00, $00, $05, $02, $08, $02, $05, $02, $10, $04, $05, $02, $18, $06
	db $05, $12, $00, $08, $05, $12, $08, $0A, $05, $12, $10, $0C, $05, $12, $18, $0E
	db $05, $08, $04, $3C, $00, $18, $04, $3E, $00, $3C, $18, $4E, $00, $CC, $18, $3C
	db $00, $DC, $18, $3E, $00, $BC, $F4, $50, $00, $CC, $F4, $52, $00, $1C, $28, $50
	db $20, $2C, $28, $52, $20, $2C, $F4, $50, $00, $3C, $F4, $56, $00

; ---- data $4A50-$4AB9 (105 bytes) [PROBABLE] sprite frame record: count=26 then 26 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4A50:: ; 70:4A50
	db $1A, $20, $18, $3C, $00, $30, $18, $3E, $00, $01, $00, $10, $06, $01, $08, $12
	db $06, $01, $10, $14, $06, $01, $18, $16, $06, $11, $00, $18, $06, $11, $08, $1A
	db $06, $11, $10, $1C, $06, $11, $18, $1E, $06, $01, $00, $00, $05, $01, $08, $02
	db $05, $01, $10, $04, $05, $01, $18, $06, $05, $11, $00, $08, $05, $11, $08, $0A
	db $05, $11, $10, $0C, $05, $11, $18, $0E, $05, $E8, $04, $3C, $00, $F8, $04, $3E
	db $00, $10, $F4, $50, $00, $20, $F4, $52, $00, $00, $28, $50, $00, $10, $28, $52
	db $00, $B4, $18, $3C, $00, $C4, $18, $3E, $00

; ---- data $4AB9-$4AC2 (9 bytes) [PROBABLE] count=4 then 4 x 2-byte pairs; word1 of an entry of Table_70_4832 (read by 00:0AB8 through [slot+8])

Data_70_4AB9:: ; 70:4AB9
	db $04, $00, $0C, $01, $0C, $02, $0C, $03, $0C

; ---- ptrtable $4AC2-$4ACE (12 bytes) [PROBABLE] list of 6 frame pointers (word0 of an entry of Table_70_4832); each target is a count-prefixed OAM record

Table_70_4AC2:: ; 70:4AC2
	dw Data_70_4ACE
	dw Data_70_4B1F
	dw Data_70_4B48
	dw Data_70_4B61
	dw Data_70_4B72
	dw Data_70_4B7B

; ---- data $4ACE-$4B1F (81 bytes) [PROBABLE] sprite frame record: count=20 then 20 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4ACE:: ; 70:4ACE
	db $14, $18, $18, $48, $00, $00, $00, $10, $06, $00, $08, $12, $06, $00, $10, $14
	db $06, $00, $18, $16, $06, $10, $00, $18, $06, $10, $08, $1A, $06, $10, $10, $1C
	db $06, $10, $18, $1E, $06, $00, $00, $00, $05, $00, $08, $02, $05, $00, $10, $04
	db $05, $00, $18, $06, $05, $10, $00, $08, $05, $10, $08, $0A, $05, $10, $10, $0C
	db $05, $10, $18, $0E, $05, $F8, $28, $4A, $00, $E0, $04, $48, $00, $08, $F0, $4A
	db $00

; ---- data $4B1F-$4B48 (41 bytes) [PROBABLE] sprite frame record: count=10 then 10 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4B1F:: ; 70:4B1F
	db $0A, $00, $00, $20, $00, $00, $08, $22, $00, $00, $10, $24, $00, $00, $18, $26
	db $00, $10, $00, $28, $00, $10, $08, $2A, $00, $10, $10, $2C, $00, $10, $18, $2E
	db $00, $E3, $04, $4A, $00, $20, $18, $4A, $00

; ---- data $4B48-$4B61 (25 bytes) [PROBABLE] sprite frame record: count=6 then 6 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4B48:: ; 70:4B48
	db $06, $00, $04, $30, $00, $00, $0C, $32, $00, $00, $14, $34, $00, $10, $04, $36
	db $00, $10, $0C, $38, $00, $10, $14, $3A, $00

; ---- data $4B61-$4B72 (17 bytes) [PROBABLE] sprite frame record: count=4 then 4 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4B61:: ; 70:4B61
	db $04, $00, $08, $42, $00, $00, $10, $42, $20, $10, $08, $42, $40, $10, $10, $42
	db $60

; ---- data $4B72-$4B7B (9 bytes) [PROBABLE] sprite frame record: count=2 then 2 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4B72:: ; 70:4B72
	db $02, $F0, $0C, $40, $00, $00, $0C, $40, $40

; ---- data $4B7B-$4B84 (9 bytes) [PROBABLE] sprite frame record: count=2 then 2 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4B7B:: ; 70:4B7B
	db $02, $C0, $0C, $40, $00, $D0, $0C, $40, $40

; ---- data $4B84-$4B91 (13 bytes) [PROBABLE] count=6 then 6 x 2-byte pairs; word1 of an entry of Table_70_4832 (read by 00:0AB8 through [slot+8])

Data_70_4B84:: ; 70:4B84
	db $06, $00, $0A, $01, $07, $02, $05, $03, $07, $04, $05, $05, $05

; ---- ptrtable $4B91-$4B9D (12 bytes) [PROBABLE] list of 6 frame pointers (word0 of an entry of Table_70_4832); each target is a count-prefixed OAM record

Table_70_4B91:: ; 70:4B91
	dw Data_70_4B9D
	dw Data_70_4BEE
	dw Data_70_4C17
	dw Data_70_4C30
	dw Data_70_4C41
	dw Data_70_4C4A

; ---- data $4B9D-$4BEE (81 bytes) [PROBABLE] sprite frame record: count=20 then 20 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4B9D:: ; 70:4B9D
	db $14, $18, $18, $48, $00, $00, $00, $10, $06, $00, $08, $12, $06, $00, $10, $14
	db $06, $00, $18, $16, $06, $10, $00, $18, $06, $10, $08, $1A, $06, $10, $10, $1C
	db $06, $10, $18, $1E, $06, $00, $00, $00, $05, $00, $08, $02, $05, $00, $10, $04
	db $05, $00, $18, $06, $05, $10, $00, $08, $05, $10, $08, $0A, $05, $10, $10, $0C
	db $05, $10, $18, $0E, $05, $F8, $28, $4A, $00, $E0, $04, $48, $00, $08, $F0, $4A
	db $00

; ---- data $4BEE-$4C17 (41 bytes) [PROBABLE] sprite frame record: count=10 then 10 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4BEE:: ; 70:4BEE
	db $0A, $00, $00, $20, $00, $00, $08, $22, $00, $00, $10, $24, $00, $00, $18, $26
	db $00, $10, $00, $28, $00, $10, $08, $2A, $00, $10, $10, $2C, $00, $10, $18, $2E
	db $00, $E3, $04, $4A, $00, $20, $18, $4A, $00

; ---- data $4C17-$4C30 (25 bytes) [PROBABLE] sprite frame record: count=6 then 6 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4C17:: ; 70:4C17
	db $06, $00, $04, $30, $00, $00, $0C, $32, $00, $00, $14, $34, $00, $10, $04, $36
	db $00, $10, $0C, $38, $00, $10, $14, $3A, $00

; ---- data $4C30-$4C41 (17 bytes) [PROBABLE] sprite frame record: count=4 then 4 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4C30:: ; 70:4C30
	db $04, $00, $08, $42, $00, $00, $10, $42, $20, $10, $08, $42, $40, $10, $10, $42
	db $60

; ---- data $4C41-$4C4A (9 bytes) [PROBABLE] sprite frame record: count=2 then 2 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4C41:: ; 70:4C41
	db $02, $10, $0C, $40, $00, $20, $0C, $40, $40

; ---- data $4C4A-$4C4F (5 bytes) [PROBABLE] sprite frame record: count=1 then 1 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4832

Data_70_4C4A:: ; 70:4C4A
	db $01, $34, $0C, $40, $00

; ---- data $4C4F-$4C5C (13 bytes) [PROBABLE] count=6 then 6 x 2-byte pairs; word1 of an entry of Table_70_4832 (read by 00:0AB8 through [slot+8])

Data_70_4C4F:: ; 70:4C4F
	db $06, $00, $0A, $01, $07, $02, $05, $03, $07, $04, $05, $05, $05

; ---- ptrtable $4C5C-$4C64 (8 bytes) [PROBABLE] animation table: 2 entries x 4 bytes (2 pointers each; entry 0 may be null), used as DE by init_object_from_table (00:0A82 / 00:0AB8, index = B&7F): word0 = list of frame pointers, word1 = count + 2-byte pairs. No executed caller found; same format as the CONFIRMED tables 534C/53EB; whole structure tiles exactly (every pointer lands on a record start)

Table_70_4C5C:: ; 70:4C5C
	dw $0000
	dw $0000
	dw Table_70_4C64
	dw Data_70_4D9E

; ---- ptrtable $4C64-$4C80 (28 bytes) [PROBABLE] list of 14 frame pointers (word0 of an entry of Table_70_4C5C); each target is a count-prefixed OAM record

Table_70_4C64:: ; 70:4C64
	dw Data_70_4C80
	dw Data_70_4C99
	dw Data_70_4CB2
	dw Data_70_4CCB
	dw Data_70_4CDC
	dw Data_70_4CED
	dw Data_70_4CFE
	dw Data_70_4D17
	dw Data_70_4D28
	dw Data_70_4D39
	dw Data_70_4D52
	dw Data_70_4D63
	dw Data_70_4D7C
	dw Data_70_4D8D

; ---- data $4C80-$4C99 (25 bytes) [PROBABLE] sprite frame record: count=6 then 6 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4C5C

Data_70_4C80:: ; 70:4C80
	db $06, $D4, $48, $20, $00, $D4, $50, $22, $00, $10, $60, $2C, $00, $10, $68, $2E
	db $00, $20, $E0, $28, $00, $20, $E8, $2A, $00

; ---- data $4C99-$4CB2 (25 bytes) [PROBABLE] sprite frame record: count=6 then 6 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4C5C

Data_70_4C99:: ; 70:4C99
	db $06, $E0, $30, $20, $00, $E0, $38, $22, $00, $1C, $48, $2C, $00, $1C, $50, $2E
	db $00, $2C, $C8, $28, $00, $2C, $D0, $2A, $00

; ---- data $4CB2-$4CCB (25 bytes) [PROBABLE] sprite frame record: count=6 then 6 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4C5C

Data_70_4CB2:: ; 70:4CB2
	db $06, $EC, $18, $20, $00, $EC, $20, $22, $00, $28, $30, $2C, $00, $28, $38, $2E
	db $00, $38, $B0, $24, $00, $38, $B8, $26, $00

; ---- data $4CCB-$4CDC (17 bytes) [PROBABLE] sprite frame record: count=4 then 4 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4C5C

Data_70_4CCB:: ; 70:4CCB
	db $04, $F8, $00, $20, $00, $F8, $08, $22, $00, $34, $18, $2C, $00, $34, $20, $2E
	db $00

; ---- data $4CDC-$4CED (17 bytes) [PROBABLE] sprite frame record: count=4 then 4 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4C5C

Data_70_4CDC:: ; 70:4CDC
	db $04, $04, $E8, $20, $00, $04, $F0, $22, $00, $C8, $30, $2C, $00, $C8, $38, $2E
	db $00

; ---- data $4CED-$4CFE (17 bytes) [PROBABLE] sprite frame record: count=4 then 4 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4C5C

Data_70_4CED:: ; 70:4CED
	db $04, $10, $D0, $20, $00, $10, $D8, $22, $00, $D4, $18, $2C, $00, $D4, $20, $2E
	db $00

; ---- data $4CFE-$4D17 (25 bytes) [PROBABLE] sprite frame record: count=6 then 6 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4C5C

Data_70_4CFE:: ; 70:4CFE
	db $06, $1C, $B8, $20, $00, $1C, $C0, $22, $00, $FC, $58, $20, $00, $FC, $60, $22
	db $00, $E0, $00, $2C, $00, $E0, $08, $2E, $00

; ---- data $4D17-$4D28 (17 bytes) [PROBABLE] sprite frame record: count=4 then 4 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4C5C

Data_70_4D17:: ; 70:4D17
	db $04, $08, $38, $20, $00, $08, $40, $22, $00, $EC, $E0, $2C, $00, $EC, $E8, $2E
	db $00

; ---- data $4D28-$4D39 (17 bytes) [PROBABLE] sprite frame record: count=4 then 4 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4C5C

Data_70_4D28:: ; 70:4D28
	db $04, $14, $20, $20, $00, $14, $28, $22, $00, $F8, $C0, $2C, $00, $F8, $C8, $2E
	db $00

; ---- data $4D39-$4D52 (25 bytes) [PROBABLE] sprite frame record: count=6 then 6 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4C5C

Data_70_4D39:: ; 70:4D39
	db $06, $20, $08, $20, $00, $20, $10, $22, $00, $E4, $58, $28, $00, $E4, $60, $2A
	db $00, $04, $A8, $2C, $00, $04, $B0, $2E, $00

; ---- data $4D52-$4D63 (17 bytes) [PROBABLE] sprite frame record: count=4 then 4 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4C5C

Data_70_4D52:: ; 70:4D52
	db $04, $2C, $F0, $20, $00, $2C, $F8, $22, $00, $F0, $40, $28, $00, $F0, $48, $2A
	db $00

; ---- data $4D63-$4D7C (25 bytes) [PROBABLE] sprite frame record: count=6 then 6 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4C5C

Data_70_4D63:: ; 70:4D63
	db $06, $D0, $F0, $20, $00, $D0, $F8, $22, $00, $FC, $28, $28, $00, $FC, $30, $2A
	db $00, $38, $D8, $24, $00, $38, $E0, $26, $00

; ---- data $4D7C-$4D8D (17 bytes) [PROBABLE] sprite frame record: count=4 then 4 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4C5C

Data_70_4D7C:: ; 70:4D7C
	db $04, $DC, $D8, $20, $00, $DC, $E0, $22, $00, $08, $10, $28, $00, $08, $18, $2A
	db $00

; ---- data $4D8D-$4D9E (17 bytes) [PROBABLE] sprite frame record: count=4 then 4 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4C5C

Data_70_4D8D:: ; 70:4D8D
	db $04, $E8, $C0, $20, $00, $E8, $C8, $22, $00, $14, $F8, $28, $00, $14, $00, $2A
	db $00

; ---- data $4D9E-$4DBB (29 bytes) [PROBABLE] count=14 then 14 x 2-byte pairs; word1 of an entry of Table_70_4C5C (read by 00:0AB8 through [slot+8])

Data_70_4D9E:: ; 70:4D9E
	db $0E, $00, $06, $01, $06, $02, $06, $03, $06, $04, $06, $05, $06, $06, $06, $07
	db $06, $08, $06, $09, $06, $0A, $06, $0B, $06, $0C, $06, $0D, $06

; ---- ptrtable $4DBB-$4DCF (20 bytes) [PROBABLE] animation table: 5 entries x 4 bytes (2 pointers each; entry 0 may be null), used as DE by init_object_from_table (00:0A82 / 00:0AB8, index = B&7F): word0 = list of frame pointers, word1 = count + 2-byte pairs. No executed caller found; same format as the CONFIRMED tables 534C/53EB; whole structure tiles exactly (every pointer lands on a record start)

Table_70_4DBB:: ; 70:4DBB
	dw $0000
	dw $0000
	dw Table_70_4DCF
	dw Data_70_4E47
	dw Table_70_4E50
	dw Data_70_4FE4
	dw Table_70_4FED
	dw Data_70_517C
	dw Table_70_5187
	dw Data_70_5265

; ---- ptrtable $4DCF-$4DD7 (8 bytes) [PROBABLE] list of 4 frame pointers (word0 of an entry of Table_70_4DBB); each target is a count-prefixed OAM record

Table_70_4DCF:: ; 70:4DCF
	dw Data_70_4DD7
	dw Data_70_4DE8
	dw Data_70_4DFD
	dw Data_70_4E1A

; ---- data $4DD7-$4DE8 (17 bytes) [PROBABLE] sprite frame record: count=4 then 4 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_4DD7:: ; 70:4DD7
	db $04, $CC, $0C, $A0, $08, $DC, $0C, $A0, $48, $C6, $07, $A6, $08, $D4, $14, $A6
	db $08

; ---- data $4DE8-$4DFD (21 bytes) [PROBABLE] sprite frame record: count=5 then 5 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_4DE8:: ; 70:4DE8
	db $05, $F4, $0C, $A0, $08, $04, $0C, $A0, $48, $F3, $06, $A6, $08, $EA, $13, $A6
	db $08, $DC, $0B, $A6, $08

; ---- data $4DFD-$4E1A (29 bytes) [PROBABLE] sprite frame record: count=7 then 7 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_4DFD:: ; 70:4DFD
	db $07, $00, $08, $A2, $08, $00, $10, $A2, $28, $10, $08, $A2, $48, $10, $10, $A2
	db $68, $E0, $03, $A4, $08, $F6, $0E, $A6, $08, $D8, $18, $A4, $08

; ---- data $4E1A-$4E47 (45 bytes) [PROBABLE] sprite frame record: count=11 then 11 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_4E1A:: ; 70:4E1A
	db $0B, $00, $00, $60, $08, $00, $08, $62, $08, $00, $10, $64, $08, $00, $18, $66
	db $08, $10, $00, $68, $08, $10, $08, $6A, $08, $10, $10, $6C, $08, $10, $18, $6E
	db $08, $E8, $14, $A4, $08, $08, $F8, $A4, $08, $28, $1C, $A4, $08

; ---- data $4E47-$4E50 (9 bytes) [PROBABLE] count=4 then 4 x 2-byte pairs; word1 of an entry of Table_70_4DBB (read by 00:0AB8 through [slot+8])

Data_70_4E47:: ; 70:4E47
	db $04, $00, $06, $01, $06, $02, $07, $03, $08

; ---- ptrtable $4E50-$4E58 (8 bytes) [PROBABLE] list of 4 frame pointers (word0 of an entry of Table_70_4DBB); each target is a count-prefixed OAM record

Table_70_4E50:: ; 70:4E50
	dw Data_70_4E58
	dw Data_70_4EB5
	dw Data_70_4F16
	dw Data_70_4F7B

; ---- data $4E58-$4EB5 (93 bytes) [PROBABLE] sprite frame record: count=23 then 23 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_4E58:: ; 70:4E58
	db $17, $D4, $14, $A8, $08, $E4, $14, $AA, $08, $F4, $F8, $A8, $08, $04, $F8, $AA
	db $08, $34, $14, $A8, $08, $04, $25, $A8, $08, $14, $25, $AA, $08, $00, $00, $10
	db $0E, $00, $08, $12, $0E, $00, $10, $14, $0E, $00, $18, $16, $0E, $10, $00, $18
	db $0E, $10, $08, $1A, $0E, $10, $10, $1C, $0E, $10, $18, $1E, $0E, $00, $00, $00
	db $0D, $00, $08, $02, $0D, $00, $10, $04, $0D, $00, $18, $06, $0D, $10, $00, $08
	db $0D, $10, $08, $0A, $0D, $10, $10, $0C, $0D, $10, $18, $0E, $0D

; ---- data $4EB5-$4F16 (97 bytes) [PROBABLE] sprite frame record: count=24 then 24 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_4EB5:: ; 70:4EB5
	db $18, $1C, $14, $A8, $08, $2C, $14, $AA, $08, $CC, $14, $AA, $08, $E4, $F8, $A8
	db $08, $F4, $F8, $AA, $08, $EC, $25, $A8, $08, $FC, $25, $AA, $08, $BC, $14, $A8
	db $08, $FF, $00, $10, $0E, $FF, $08, $12, $0E, $FF, $10, $14, $0E, $FF, $18, $16
	db $0E, $0F, $00, $18, $0E, $0F, $08, $1A, $0E, $0F, $10, $1C, $0E, $0F, $18, $1E
	db $0E, $FF, $00, $00, $0D, $FF, $08, $02, $0D, $FF, $10, $04, $0D, $FF, $18, $06
	db $0D, $0F, $00, $08, $0D, $0F, $08, $0A, $0D, $0F, $10, $0C, $0D, $0F, $18, $0E
	db $0D

; ---- data $4F16-$4F7B (101 bytes) [PROBABLE] sprite frame record: count=25 then 25 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_4F16:: ; 70:4F16
	db $19, $04, $14, $A8, $08, $14, $14, $AA, $08, $24, $F8, $A8, $08, $34, $F8, $AA
	db $08, $D4, $25, $A8, $08, $E4, $25, $AA, $08, $34, $25, $A8, $08, $D4, $F8, $AA
	db $08, $C4, $F8, $A8, $08, $FE, $00, $10, $0E, $FE, $08, $12, $0E, $FE, $10, $14
	db $0E, $FE, $18, $16, $0E, $0E, $00, $18, $0E, $0E, $08, $1A, $0E, $0E, $10, $1C
	db $0E, $0E, $18, $1E, $0E, $FE, $00, $00, $0D, $FE, $08, $02, $0D, $FE, $10, $04
	db $0D, $FE, $18, $06, $0D, $0E, $00, $08, $0D, $0E, $08, $0A, $0D, $0E, $10, $0C
	db $0D, $0E, $18, $0E, $0D

; ---- data $4F7B-$4FE4 (105 bytes) [PROBABLE] sprite frame record: count=26 then 26 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_4F7B:: ; 70:4F7B
	db $1A, $EC, $14, $A8, $08, $FC, $14, $AA, $08, $0C, $F8, $A8, $08, $1C, $F8, $AA
	db $08, $1C, $25, $A8, $08, $2C, $25, $AA, $08, $BC, $F8, $AA, $08, $BC, $25, $A8
	db $08, $CC, $25, $AA, $08, $AC, $F8, $A8, $08, $FF, $00, $10, $0E, $FF, $08, $12
	db $0E, $FF, $10, $14, $0E, $FF, $18, $16, $0E, $0F, $00, $18, $0E, $0F, $08, $1A
	db $0E, $0F, $10, $1C, $0E, $0F, $18, $1E, $0E, $FF, $00, $00, $0D, $FF, $08, $02
	db $0D, $FF, $10, $04, $0D, $FF, $18, $06, $0D, $0F, $00, $08, $0D, $0F, $08, $0A
	db $0D, $0F, $10, $0C, $0D, $0F, $18, $0E, $0D

; ---- data $4FE4-$4FED (9 bytes) [PROBABLE] count=4 then 4 x 2-byte pairs; word1 of an entry of Table_70_4DBB (read by 00:0AB8 through [slot+8])

Data_70_4FE4:: ; 70:4FE4
	db $04, $00, $0D, $01, $0A, $02, $0D, $03, $0A

; ---- ptrtable $4FED-$4FF7 (10 bytes) [PROBABLE] list of 5 frame pointers (word0 of an entry of Table_70_4DBB); each target is a count-prefixed OAM record

Table_70_4FED:: ; 70:4FED
	dw Data_70_4FF7
	dw Data_70_5050
	dw Data_70_50A9
	dw Data_70_50F6
	dw Data_70_513B

; ---- data $4FF7-$5050 (89 bytes) [PROBABLE] sprite frame record: count=22 then 22 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_4FF7:: ; 70:4FF7
	db $16, $C8, $14, $A8, $08, $D8, $14, $AA, $08, $E8, $F8, $A8, $08, $F8, $F8, $AA
	db $08, $F8, $25, $A8, $08, $08, $25, $AA, $08, $00, $00, $10, $0E, $00, $08, $12
	db $0E, $00, $10, $14, $0E, $00, $18, $16, $0E, $10, $00, $18, $0E, $10, $08, $1A
	db $0E, $10, $10, $1C, $0E, $10, $18, $1E, $0E, $00, $00, $00, $0D, $00, $08, $02
	db $0D, $00, $10, $04, $0D, $00, $18, $06, $0D, $10, $00, $08, $0D, $10, $08, $0A
	db $0D, $10, $10, $0C, $0D, $10, $18, $0E, $0D

; ---- data $5050-$50A9 (89 bytes) [PROBABLE] sprite frame record: count=22 then 22 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_5050:: ; 70:5050
	db $16, $B0, $14, $A8, $08, $C0, $14, $AA, $08, $D0, $F8, $A8, $08, $E0, $F8, $AA
	db $08, $E0, $25, $A8, $08, $F0, $25, $AA, $08, $01, $00, $10, $0E, $01, $08, $12
	db $0E, $01, $10, $14, $0E, $01, $18, $16, $0E, $11, $00, $18, $0E, $11, $08, $1A
	db $0E, $11, $10, $1C, $0E, $11, $18, $1E, $0E, $01, $00, $00, $0D, $01, $08, $02
	db $0D, $01, $10, $04, $0D, $01, $18, $06, $0D, $11, $00, $08, $0D, $11, $08, $0A
	db $0D, $11, $10, $0C, $0D, $11, $18, $0E, $0D

; ---- data $50A9-$50F6 (77 bytes) [PROBABLE] sprite frame record: count=19 then 19 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_50A9:: ; 70:50A9
	db $13, $C8, $F8, $AA, $08, $C8, $25, $A8, $08, $D8, $25, $AA, $08, $00, $00, $50
	db $0E, $00, $08, $52, $0E, $00, $10, $54, $0E, $00, $18, $56, $0E, $10, $00, $58
	db $0E, $10, $08, $5A, $0E, $10, $10, $5C, $0E, $10, $18, $5E, $0E, $00, $00, $40
	db $0D, $00, $08, $42, $0D, $00, $10, $44, $0D, $00, $18, $46, $0D, $10, $00, $48
	db $0D, $10, $08, $4A, $0D, $10, $10, $4C, $0D, $10, $18, $4E, $0D

; ---- data $50F6-$513B (69 bytes) [PROBABLE] sprite frame record: count=17 then 17 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_50F6:: ; 70:50F6
	db $11, $C0, $25, $AA, $08, $00, $00, $30, $0E, $00, $08, $32, $0E, $00, $10, $34
	db $0E, $00, $18, $36, $0E, $10, $00, $38, $0E, $10, $08, $3A, $0E, $10, $10, $3C
	db $0E, $10, $18, $3E, $0E, $00, $00, $20, $0D, $00, $08, $22, $0D, $00, $10, $24
	db $0D, $00, $18, $26, $0D, $10, $00, $28, $0D, $10, $08, $2A, $0D, $10, $10, $2C
	db $0D, $10, $18, $2E, $0D

; ---- data $513B-$517C (65 bytes) [PROBABLE] sprite frame record: count=16 then 16 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_513B:: ; 70:513B
	db $10, $00, $00, $30, $0E, $00, $08, $32, $0E, $00, $10, $34, $0E, $00, $18, $36
	db $0E, $10, $00, $38, $0E, $10, $08, $3A, $0E, $10, $10, $3C, $0E, $10, $18, $3E
	db $0E, $00, $00, $20, $0D, $00, $08, $22, $0D, $00, $10, $24, $0D, $00, $18, $26
	db $0D, $10, $00, $28, $0D, $10, $08, $2A, $0D, $10, $10, $2C, $0D, $10, $18, $2E
	db $0D

; ---- data $517C-$5187 (11 bytes) [PROBABLE] count=5 then 5 x 2-byte pairs; word1 of an entry of Table_70_4DBB (read by 00:0AB8 through [slot+8])

Data_70_517C:: ; 70:517C
	db $05, $00, $0A, $01, $0A, $02, $0A, $03, $0D, $04, $0D

; ---- ptrtable $5187-$5193 (12 bytes) [PROBABLE] list of 6 frame pointers (word0 of an entry of Table_70_4DBB); each target is a count-prefixed OAM record

Table_70_5187:: ; 70:5187
	dw Data_70_5193
	dw Data_70_51B4
	dw Data_70_51CD
	dw Data_70_51DE
	dw Data_70_5203
	dw Data_70_5240

; ---- data $5193-$51B4 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_5193:: ; 70:5193
	db $08, $00, $00, $70, $08, $00, $08, $72, $08, $00, $10, $74, $08, $00, $18, $76
	db $08, $10, $00, $78, $08, $10, $08, $7A, $08, $10, $10, $7C, $08, $10, $18, $7E
	db $08

; ---- data $51B4-$51CD (25 bytes) [PROBABLE] sprite frame record: count=6 then 6 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_51B4:: ; 70:51B4
	db $06, $00, $04, $80, $08, $00, $0C, $82, $08, $00, $14, $84, $08, $10, $04, $86
	db $08, $10, $0C, $88, $08, $10, $14, $8A, $08

; ---- data $51CD-$51DE (17 bytes) [PROBABLE] sprite frame record: count=4 then 4 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_51CD:: ; 70:51CD
	db $04, $00, $08, $A2, $08, $00, $10, $A2, $28, $10, $08, $A2, $48, $10, $10, $A2
	db $68

; ---- data $51DE-$5203 (37 bytes) [PROBABLE] sprite frame record: count=9 then 9 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_51DE:: ; 70:51DE
	db $09, $F8, $04, $8C, $08, $F8, $0C, $8E, $08, $F8, $14, $90, $08, $08, $04, $92
	db $08, $08, $0C, $94, $08, $08, $14, $96, $08, $18, $04, $98, $08, $18, $0C, $9A
	db $08, $18, $14, $9C, $08

; ---- data $5203-$5240 (61 bytes) [PROBABLE] sprite frame record: count=15 then 15 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_5203:: ; 70:5203
	db $0F, $00, $0D, $A4, $08, $10, $18, $A6, $08, $ED, $1C, $A4, $08, $FA, $FC, $A6
	db $08, $DF, $06, $A4, $08, $18, $28, $A4, $08, $30, $00, $A4, $08, $24, $1B, $A4
	db $08, $29, $09, $A6, $08, $38, $22, $A6, $08, $16, $03, $A6, $08, $0D, $F4, $A6
	db $08, $D1, $13, $A6, $08, $F9, $25, $A6, $08, $DF, $22, $A6, $08

; ---- data $5240-$5265 (37 bytes) [PROBABLE] sprite frame record: count=9 then 9 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_4DBB

Data_70_5240:: ; 70:5240
	db $09, $ED, $F7, $A6, $08, $13, $2A, $A6, $08, $3C, $03, $A6, $08, $DB, $34, $A6
	db $08, $0D, $08, $A6, $08, $27, $D5, $A6, $08, $33, $4C, $A6, $08, $D3, $E3, $A6
	db $08, $D0, $59, $A6, $08

; ---- data $5265-$5272 (13 bytes) [PROBABLE] count=6 then 6 x 2-byte pairs; word1 of an entry of Table_70_4DBB (read by 00:0AB8 through [slot+8])

Data_70_5265:: ; 70:5265
	db $06, $00, $0A, $01, $0A, $02, $0A, $03, $0D, $04, $0D, $05, $07

; ---- ptrtable $5272-$527A (8 bytes) [PROBABLE] animation table: 2 entries x 4 bytes (2 pointers each; entry 0 may be null), used as DE by init_object_from_table (00:0A82 / 00:0AB8, index = B&7F): word0 = list of frame pointers, word1 = count + 2-byte pairs. No executed caller found; same format as the CONFIRMED tables 534C/53EB; whole structure tiles exactly (every pointer lands on a record start)

Table_70_5272:: ; 70:5272
	dw $0000
	dw $0000
	dw Table_70_527A
	dw Data_70_5343

; ---- ptrtable $527A-$5280 (6 bytes) [PROBABLE] list of 3 frame pointers (word0 of an entry of Table_70_5272); each target is a count-prefixed OAM record

Table_70_527A:: ; 70:527A
	dw Data_70_5280
	dw Data_70_52C1
	dw Data_70_5302

; ---- data $5280-$52C1 (65 bytes) [PROBABLE] sprite frame record: count=16 then 16 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_5272

Data_70_5280:: ; 70:5280
	db $10, $00, $00, $10, $06, $00, $08, $12, $06, $00, $10, $14, $06, $00, $18, $16
	db $06, $10, $00, $18, $06, $10, $08, $1A, $06, $10, $10, $1C, $06, $10, $18, $1E
	db $06, $00, $00, $00, $05, $00, $08, $02, $05, $00, $10, $04, $05, $00, $18, $06
	db $05, $10, $00, $08, $05, $10, $08, $0A, $05, $10, $10, $0C, $05, $10, $18, $0E
	db $05

; ---- data $52C1-$5302 (65 bytes) [PROBABLE] sprite frame record: count=16 then 16 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_5272

Data_70_52C1:: ; 70:52C1
	db $10, $00, $FF, $10, $06, $00, $07, $12, $06, $00, $0F, $14, $06, $00, $17, $16
	db $06, $10, $FF, $18, $06, $10, $07, $1A, $06, $10, $0F, $1C, $06, $10, $17, $1E
	db $06, $00, $FF, $00, $05, $00, $07, $02, $05, $00, $0F, $04, $05, $00, $17, $06
	db $05, $10, $FF, $08, $05, $10, $07, $0A, $05, $10, $0F, $0C, $05, $10, $17, $0E
	db $05

; ---- data $5302-$5343 (65 bytes) [PROBABLE] sprite frame record: count=16 then 16 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_5272

Data_70_5302:: ; 70:5302
	db $10, $01, $FE, $10, $06, $01, $06, $12, $06, $01, $0E, $14, $06, $01, $16, $16
	db $06, $11, $FE, $18, $06, $11, $06, $1A, $06, $11, $0E, $1C, $06, $11, $16, $1E
	db $06, $01, $FE, $00, $05, $01, $06, $02, $05, $01, $0E, $04, $05, $01, $16, $06
	db $05, $11, $FE, $08, $05, $11, $06, $0A, $05, $11, $0E, $0C, $05, $11, $16, $0E
	db $05

; ---- data $5343-$534C (9 bytes) [PROBABLE] count=4 then 4 x 2-byte pairs; word1 of an entry of Table_70_5272 (read by 00:0AB8 through [slot+8])

Data_70_5343:: ; 70:5343
	db $04, $00, $0A, $01, $0A, $02, $0A, $01, $0A

; ---- ptrtable $534C-$535C (16 bytes) [CONFIRMED] animation table: 4 entries x 4 bytes (2 pointers each; entry 0 may be null), used as DE by init_object_from_table (00:0A82 / 00:0AB8, index = B&7F): word0 = list of frame pointers, word1 = count + 2-byte pairs. CONFIRMED by executed callers: ld de,$53EB at 70:415C and ld de,$534C at 70:45B1 (a=$70, then call 00:0A82). Whole structure tiles exactly (every pointer lands on a record start)

CommScene_ObjTable:: ; 70:534C
Table_70_534C::
	dw $0000
	dw $0000
	dw CommScene_Anim1Frames
	dw CommScene_Anim1Script
	dw CommScene_Anim2Frames
	dw CommScene_Anim2Script
	dw CommScene_Anim3Frames
	dw CommScene_Anim3Script

; ---- ptrtable $535C-$535E (2 bytes) [PROBABLE] list of 1 frame pointers (word0 of an entry of Table_70_534C); each target is a count-prefixed OAM record

CommScene_Anim1Frames:: ; 70:535C
Table_70_535C::
	dw CommScene_Anim1Frame0

; ---- data $535E-$5397 (57 bytes) [PROBABLE] sprite frame record: count=14 then 14 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_534C

CommScene_Anim1Frame0:: ; 70:535E
Data_70_535E::
	db $0E, $00, $00, $00, $0B, $F0, $00, $00, $0B, $10, $00, $00, $0B, $20, $00, $00
	db $0B, $40, $00, $00, $0B, $30, $00, $00, $0B, $F0, $10, $02, $2B, $F0, $08, $04
	db $2B, $40, $10, $02, $6B, $40, $08, $04, $6B, $00, $08, $06, $2B, $30, $08, $06
	db $6B, $10, $08, $06, $2B, $20, $08, $06, $2B

; ---- data $5397-$539A (3 bytes) [PROBABLE] count=1 then 1 x 2-byte pairs; word1 of an entry of Table_70_534C (read by 00:0AB8 through [slot+8])

CommScene_Anim1Script:: ; 70:5397
Data_70_5397::
	db $01, $00, $04

; ---- ptrtable $539A-$539C (2 bytes) [PROBABLE] list of 1 frame pointers (word0 of an entry of Table_70_534C); each target is a count-prefixed OAM record

CommScene_Anim2Frames:: ; 70:539A
Table_70_539A::
	dw CommScene_Anim2Frame0

; ---- data $539C-$53D5 (57 bytes) [PROBABLE] sprite frame record: count=14 then 14 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_534C

CommScene_Anim2Frame0:: ; 70:539C
Data_70_539C::
	db $0E, $F0, $10, $00, $2B, $00, $10, $00, $2B, $10, $10, $00, $2B, $20, $10, $00
	db $2B, $40, $10, $00, $2B, $30, $10, $00, $2B, $F0, $00, $02, $0B, $F0, $08, $04
	db $0B, $40, $00, $02, $4B, $40, $08, $04, $4B, $10, $08, $06, $0B, $30, $08, $06
	db $4B, $00, $08, $06, $0B, $20, $08, $06, $4B

; ---- data $53D5-$53D8 (3 bytes) [PROBABLE] count=1 then 1 x 2-byte pairs; word1 of an entry of Table_70_534C (read by 00:0AB8 through [slot+8])

CommScene_Anim2Script:: ; 70:53D5
Data_70_53D5::
	db $01, $00, $04

; ---- ptrtable $53D8-$53DC (4 bytes) [PROBABLE] list of 2 frame pointers (word0 of an entry of Table_70_534C); each target is a count-prefixed OAM record

CommScene_Anim3Frames:: ; 70:53D8
Table_70_53D8::
	dw CommScene_Anim3Frame0
	dw CommScene_Anim3Frame1

; ---- data $53DC-$53E5 (9 bytes) [PROBABLE] sprite frame record: count=2 then 2 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_534C

CommScene_Anim3Frame0:: ; 70:53DC
Data_70_53DC::
	db $02, $00, $00, $74, $05, $00, $08, $76, $05

; ---- data $53E5-$53E6 (1 bytes) [PROBABLE] sprite frame record: count=0 then 0 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_534C

CommScene_Anim3Frame1:: ; 70:53E5
Data_70_53E5::
	db $00

; ---- data $53E6-$53EB (5 bytes) [PROBABLE] count=2 then 2 x 2-byte pairs; word1 of an entry of Table_70_534C (read by 00:0AB8 through [slot+8])

CommScene_Anim3Script:: ; 70:53E6
Data_70_53E6::
	db $02, $00, $0C, $01, $0C

; ---- ptrtable $53EB-$5403 (24 bytes) [CONFIRMED] animation table: 6 entries x 4 bytes (2 pointers each; entry 0 may be null), used as DE by init_object_from_table (00:0A82 / 00:0AB8, index = B&7F): word0 = list of frame pointers, word1 = count + 2-byte pairs. CONFIRMED by executed callers: ld de,$53EB at 70:415C and ld de,$534C at 70:45B1 (a=$70, then call 00:0A82). Whole structure tiles exactly (every pointer lands on a record start)

CommScene_TextObjTable:: ; 70:53EB
Table_70_53EB::
	dw $0000
	dw $0000
	dw CommScene_Text_Anim1Frames
	dw CommScene_Text_Anim1Script
	dw CommScene_Text_Anim2Frames
	dw CommScene_Text_Anim2Script
	dw CommScene_Text_Anim3Frames
	dw CommScene_Text_Anim3Script
	dw CommScene_Text_Anim4Frames
	dw CommScene_Text_Anim4Script
	dw CommScene_Text_Anim5Frames
	dw CommScene_Text_Anim5Script

; ---- ptrtable $5403-$5407 (4 bytes) [PROBABLE] list of 2 frame pointers (word0 of an entry of Table_70_53EB); each target is a count-prefixed OAM record

CommScene_Text_Anim1Frames:: ; 70:5403
Table_70_5403::
	dw CommScene_Text_Anim1Frame0
	dw CommScene_Text_Anim1Frame1

; ---- data $5407-$5418 (17 bytes) [PROBABLE] sprite frame record: count=4 then 4 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_53EB

CommScene_Text_Anim1Frame0:: ; 70:5407
Data_70_5407::
	db $04, $03, $00, $00, $00, $03, $08, $02, $00, $13, $00, $20, $00, $13, $08, $22
	db $00

; ---- data $5418-$5429 (17 bytes) [PROBABLE] sprite frame record: count=4 then 4 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_53EB

CommScene_Text_Anim1Frame1:: ; 70:5418
Data_70_5418::
	db $04, $03, $00, $04, $00, $03, $08, $06, $00, $13, $00, $24, $00, $13, $08, $26
	db $00

; ---- data $5429-$542E (5 bytes) [PROBABLE] count=2 then 2 x 2-byte pairs; word1 of an entry of Table_70_53EB (read by 00:0AB8 through [slot+8])

CommScene_Text_Anim1Script:: ; 70:5429
Data_70_5429::
	db $02, $00, $08, $01, $08

; ---- ptrtable $542E-$5432 (4 bytes) [PROBABLE] list of 2 frame pointers (word0 of an entry of Table_70_53EB); each target is a count-prefixed OAM record

CommScene_Text_Anim2Frames:: ; 70:542E
Table_70_542E::
	dw CommScene_Text_Anim2Frame0
	dw CommScene_Text_Anim2Frame1

; ---- data $5432-$5443 (17 bytes) [PROBABLE] sprite frame record: count=4 then 4 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_53EB

CommScene_Text_Anim2Frame0:: ; 70:5432
Data_70_5432::
	db $04, $03, $08, $00, $20, $03, $00, $02, $20, $13, $08, $20, $20, $13, $00, $22
	db $20

; ---- data $5443-$5454 (17 bytes) [PROBABLE] sprite frame record: count=4 then 4 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_53EB

CommScene_Text_Anim2Frame1:: ; 70:5443
Data_70_5443::
	db $04, $03, $08, $04, $20, $03, $00, $06, $20, $13, $08, $24, $20, $13, $00, $26
	db $20

; ---- data $5454-$5459 (5 bytes) [PROBABLE] count=2 then 2 x 2-byte pairs; word1 of an entry of Table_70_53EB (read by 00:0AB8 through [slot+8])

CommScene_Text_Anim2Script:: ; 70:5454
Data_70_5454::
	db $02, $00, $08, $01, $08

; ---- ptrtable $5459-$545B (2 bytes) [PROBABLE] list of 1 frame pointers (word0 of an entry of Table_70_53EB); each target is a count-prefixed OAM record

CommScene_Text_Anim3Frames:: ; 70:5459
Table_70_5459::
	dw CommScene_Text_Anim3Frame0

; ---- data $545B-$5464 (9 bytes) [PROBABLE] sprite frame record: count=2 then 2 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_53EB

CommScene_Text_Anim3Frame0:: ; 70:545B
Data_70_545B::
	db $02, $0B, $00, $5C, $03, $0B, $08, $5E, $03

; ---- data $5464-$5467 (3 bytes) [PROBABLE] count=1 then 1 x 2-byte pairs; word1 of an entry of Table_70_53EB (read by 00:0AB8 through [slot+8])

CommScene_Text_Anim3Script:: ; 70:5464
Data_70_5464::
	db $01, $00, $08

; ---- ptrtable $5467-$5469 (2 bytes) [PROBABLE] list of 1 frame pointers (word0 of an entry of Table_70_53EB); each target is a count-prefixed OAM record

CommScene_Text_Anim4Frames:: ; 70:5467
Table_70_5467::
	dw CommScene_Text_Anim4Frame0

; ---- data $5469-$5472 (9 bytes) [PROBABLE] sprite frame record: count=2 then 2 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_53EB

CommScene_Text_Anim4Frame0:: ; 70:5469
Data_70_5469::
	db $02, $0B, $08, $5C, $23, $0B, $00, $5E, $23

; ---- data $5472-$5475 (3 bytes) [PROBABLE] count=1 then 1 x 2-byte pairs; word1 of an entry of Table_70_53EB (read by 00:0AB8 through [slot+8])

CommScene_Text_Anim4Script:: ; 70:5472
Data_70_5472::
	db $01, $00, $08

; ---- ptrtable $5475-$5477 (2 bytes) [PROBABLE] list of 1 frame pointers (word0 of an entry of Table_70_53EB); each target is a count-prefixed OAM record

CommScene_Text_Anim5Frames:: ; 70:5475
Table_70_5475::
	dw CommScene_Text_Anim5Frame0

; ---- data $5477-$5480 (9 bytes) [PROBABLE] sprite frame record: count=2 then 2 x 4 bytes (y?,x?,tile,attr; field meaning not verified); referenced from a frame list of Table_70_53EB

CommScene_Text_Anim5Frame0:: ; 70:5477
Data_70_5477::
	db $02, $F8, $00, $3C, $01, $F8, $08, $3E, $01

; ---- data $5480-$5483 (3 bytes) [PROBABLE] count=1 then 1 x 2-byte pairs; word1 of an entry of Table_70_53EB (read by 00:0AB8 through [slot+8])

CommScene_Text_Anim5Script:: ; 70:5480
Data_70_5480::
	db $01, $00, $04

; ---- zero $5483-$5490 (13 bytes) [PROBABLE] 0x00 padding before the tile block at 5490 (13 bytes after the last pair record)
	ds $D, $00

; ---- gfx $5490-$5890 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 70:44E2: hl=$5490 a=$70 c=$40 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_CommScene_Tiles8000:: ; 70:5490
Data_70_5490::
	INCBIN "gfx/comm/comm_scene/tiles_5490.2bpp"

; ---- gfx $5890-$5C90 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 70:44F4: hl=$5890 a=$70 c=$40 de=$8400 (dest VRAM $8400, vbank=0)

Gfx_CommScene_Tiles8400:: ; 70:5890
Data_70_5890::
	INCBIN "gfx/comm/comm_scene/tiles_5890.2bpp"

; ---- gfx $5C90-$6090 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 70:4506: hl=$5C90 a=$70 c=$40 de=$8800 (dest VRAM $8800, vbank=0)

Gfx_CommScene_Tiles8800:: ; 70:5C90
Data_70_5C90::
	INCBIN "gfx/comm/comm_scene/tiles_5c90.2bpp"

; ---- gfx $6090-$6490 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 70:4518: hl=$6090 a=$70 c=$40 de=$8C00 (dest VRAM $8C00, vbank=0)

Gfx_CommScene_Tiles8C00:: ; 70:6090
Data_70_6090::
	INCBIN "gfx/comm/comm_scene/tiles_6090.2bpp"

; ---- gfx $6490-$6690 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 70:452A: hl=$6490 a=$70 c=$20 de=$9000 (dest VRAM $9000, vbank=0)

Data_70_6490:: ; 70:6490
	INCBIN "gfx/comm/comm_scene/tiles_6490.2bpp"

; ---- gfx $6690-$6890 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 70:453C: hl=$6490 a=$70 c=$40 de=$8001 (dest VRAM $8000, vbank=1) [clipped from 6490-6890 by higher-priority evidence]

Data_70_6690:: ; 70:6690
	INCBIN "gfx/comm/comm_scene/tiles_6690.2bpp"

; ---- gfx $6890-$6A90 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 70:4560: hl=$6690 a=$70 c=$40 de=$9001 (dest VRAM $9000, vbank=1) [clipped from 6690-6A90 by higher-priority evidence]

Data_70_6890:: ; 70:6890
	INCBIN "gfx/comm/comm_scene/tiles_6890.2bpp"

; ---- gfx $6A90-$6C90 (512 bytes) [CONFIRMED] tiles-vram: hdma_rom_to_vram at 70:4572 hl=$6A90 c=$40 de=$9401 (recovered arguments). NOTE: the HDMA length $400 would run to 6E90, but 6C90-6D10 are palettes (copied by 4F:4000 calls) and 6D10-7090 the tilemap (copy_tilemap_rect_pair), so only the first $200 bytes (32 tiles) are tile data by content; the rest of the DMA window is over-read

Gfx_CommScene_Tiles9400Vb1:: ; 70:6A90
Tiles_70_6A90::
	INCBIN "gfx/comm/comm_scene/tiles_6a90.2bpp"

; ---- data $6C90-$6CD0 (64 bytes) [PROBABLE] 64 bytes = 8 CGB palettes, source of the Function_4F_4000 call (bc=$0040, de=$D800, hl=$6C90) in the loader sequence right before the executed copy_tilemap_rect_pair at 70:45A5; RGB555 words

Palette_CommScene_Bg:: ; 70:6C90
Palette_70_6C90::
	INCLUDE "gfx/comm/comm_scene/palette_6c90.pal"

; ---- data $6CD0-$6D10 (64 bytes) [PROBABLE] 64 bytes = 8 CGB palettes, source of the Function_4F_4000 call (bc=$0040, de=$D840, hl=$6CD0); RGB555 words (00 00 4A 29 B5 56 FF 7F ends the block)

Palette_CommScene_Obj:: ; 70:6CD0
Palette_70_6CD0::
	INCLUDE "gfx/comm/comm_scene/palette_6cd0.pal"

; ---- data $6D10-$7090 (896 bytes) [CONFIRMED] tilemap+attr: copy_tilemap_rect_pair at 70:45A5 hl=$6D10 b=14 rows c=32 cols (tiles $1C0 then attrs $1C0) de=$D000

Tilemap_CommScene:: ; 70:6D10
Tilemap_70_6D10::
	INCBIN "gfx/comm/comm_scene/tilemap_6d10.tilemap"
	INCBIN "gfx/comm/comm_scene/tilemap_6d10.attrmap"

; ---- data $7090-$7130 (160 bytes) [CONFIRMED] tilemap+attr 20x4 (80 tile bytes then 80 attribute bytes), entry 0 of Table_70_4822: Function_70_4803 (executed) indexes that table with A and calls copy_tilemap_rect_pair 00:08EA with bc=$0414 (b=4 rows, c=20 cols), de=$D000, hl=table entry; bytes read in traces

Tilemap_CommScene_TextBox0:: ; 70:7090
Tilemap_70_7090::
	INCBIN "gfx/comm/comm_scene/tilemap_7090.tilemap"
	INCBIN "gfx/comm/comm_scene/tilemap_7090.attrmap"

; ---- data $7130-$71D0 (160 bytes) [CONFIRMED] tilemap+attr 20x4 (80 tile bytes then 80 attribute bytes), entry 1 of Table_70_4822: Function_70_4803 (executed) indexes that table with A and calls copy_tilemap_rect_pair 00:08EA with bc=$0414 (b=4 rows, c=20 cols), de=$D000, hl=table entry; bytes read in traces

Tilemap_CommScene_TextBox1:: ; 70:7130
Tilemap_70_7130::
	INCBIN "gfx/comm/comm_scene/tilemap_7130.tilemap"
	INCBIN "gfx/comm/comm_scene/tilemap_7130.attrmap"

; ---- data $71D0-$7270 (160 bytes) [CONFIRMED] tilemap+attr 20x4 (80 tile bytes then 80 attribute bytes), entry 2 of Table_70_4822: Function_70_4803 (executed) indexes that table with A and calls copy_tilemap_rect_pair 00:08EA with bc=$0414 (b=4 rows, c=20 cols), de=$D000, hl=table entry; bytes read in traces

Tilemap_CommScene_TextBox2:: ; 70:71D0
Tilemap_70_71D0::
	INCBIN "gfx/comm/comm_scene/tilemap_71d0.tilemap"
	INCBIN "gfx/comm/comm_scene/tilemap_71d0.attrmap"

; ---- data $7270-$7310 (160 bytes) [CONFIRMED] tilemap+attr 20x4 (80 tile bytes then 80 attribute bytes), entry 3 of Table_70_4822: Function_70_4803 (executed) indexes that table with A and calls copy_tilemap_rect_pair 00:08EA with bc=$0414 (b=4 rows, c=20 cols), de=$D000, hl=table entry; bytes read in traces

Tilemap_CommScene_TextBox3:: ; 70:7270
Tilemap_70_7270::
	INCBIN "gfx/comm/comm_scene/tilemap_7270.tilemap"
	INCBIN "gfx/comm/comm_scene/tilemap_7270.attrmap"

; ---- data $7310-$73B0 (160 bytes) [PROBABLE] tilemap+attr 20x4 (80 tile bytes then 80 attribute bytes), entry 4 of Table_70_4822: Function_70_4803 (executed) indexes that table with A and calls copy_tilemap_rect_pair 00:08EA with bc=$0414 (b=4 rows, c=20 cols), de=$D000, hl=table entry; not read in the 18 traces, same layout

Tilemap_CommScene_TextBox4:: ; 70:7310
Tilemap_70_7310::
	INCBIN "gfx/comm/comm_scene/tilemap_7310.tilemap"
	INCBIN "gfx/comm/comm_scene/tilemap_7310.attrmap"

; ---- data $73B0-$7450 (160 bytes) [PROBABLE] tilemap+attr 20x4 (80 tile bytes then 80 attribute bytes), entry 5 of Table_70_4822: Function_70_4803 (executed) indexes that table with A and calls copy_tilemap_rect_pair 00:08EA with bc=$0414 (b=4 rows, c=20 cols), de=$D000, hl=table entry; not read in the 18 traces, same layout

Tilemap_CommScene_TextBox5:: ; 70:73B0
Tilemap_70_73B0::
	INCBIN "gfx/comm/comm_scene/tilemap_73b0.tilemap"
	INCBIN "gfx/comm/comm_scene/tilemap_73b0.attrmap"

; ---- data $7450-$74F0 (160 bytes) [PROBABLE] tilemap+attr 20x4 (80 tile bytes then 80 attribute bytes), entry 6 of Table_70_4822: Function_70_4803 (executed) indexes that table with A and calls copy_tilemap_rect_pair 00:08EA with bc=$0414 (b=4 rows, c=20 cols), de=$D000, hl=table entry; not read in the 18 traces, same layout

Tilemap_CommScene_TextBox6:: ; 70:7450
Tilemap_70_7450::
	INCBIN "gfx/comm/comm_scene/tilemap_7450.tilemap"
	INCBIN "gfx/comm/comm_scene/tilemap_7450.attrmap"

; ---- data $74F0-$7590 (160 bytes) [PROBABLE] tilemap+attr 20x4 (80 tile bytes then 80 attribute bytes), entry 7 of Table_70_4822: Function_70_4803 (executed) indexes that table with A and calls copy_tilemap_rect_pair 00:08EA with bc=$0414 (b=4 rows, c=20 cols), de=$D000, hl=table entry; not read in the 18 traces, same layout

Tilemap_CommScene_TextBox7:: ; 70:74F0
Tilemap_70_74F0::
	INCBIN "gfx/comm/comm_scene/tilemap_74f0.tilemap"
	INCBIN "gfx/comm/comm_scene/tilemap_74f0.attrmap"
