; data/text/dialog_messages.asm
; bank 72, $502B-$63D8 (5037 bytes); pinned by layout.link
; English dialog text in original allocations; record 72:5597 keeps its first-line terminator at +35.

SECTION "data/text/dialog_messages", ROMX

PUSHC sjis

; ---- ptrtable $502B-$50BD (146 bytes) [CONFIRMED] nested little-endian pointers: four list heads at $502B, then lists of 1/23/44/1 slots. The 69 slots address 68 distinct records; lists 0 and 3 share $50BD. Dialog_Open selects list by D and record by E. This establishes the static layout, not validity of arbitrary selectors or natural use of every slot.

Dialog_ListTable:: ; 72:502B

	dw Dialog_List0
	dw Dialog_List1_Browser
	dw Dialog_List2_Mail
	dw Dialog_List3

Dialog_List0:: ; 72:5033
	dw String_Dialog_Msg0000

Dialog_List1_Browser:: ; 72:5035
	dw $5102
	dw $5147
	dw String_Dialog_Msg0102
	dw String_Dialog_Msg0103
	dw $5216
	dw $525B
	dw String_Dialog_Msg0106
	dw $52E5
	dw String_Dialog_Msg0108
	dw $536F
	dw $53B4
	dw String_Dialog_Msg010B
	dw $543E
	dw String_Dialog_Msg010D
	dw String_Dialog_Msg010E
	dw String_Dialog_Msg010F
	dw String_Dialog_Msg0110
	dw $5597
	dw String_Dialog_Msg0112
	dw String_Dialog_Msg0113
	dw String_Dialog_Msg0114
	dw String_Dialog_Msg0115
	dw String_Dialog_Msg0116

Dialog_List2_Mail:: ; 72:5063
	dw String_Dialog_Msg0200
	dw String_Dialog_Msg0201
	dw String_Dialog_Msg0202
	dw String_Dialog_Msg0203
	dw $5849
	dw $588E
	dw String_Dialog_Msg0206
	dw String_Dialog_Msg0207
	dw $595D
	dw String_Dialog_Msg0209
	dw String_Dialog_Msg020A
	dw $5A2C
	dw String_Dialog_Msg020C
	dw $5AB6
	dw String_Dialog_Msg020E
	dw $5B40
	dw String_Dialog_Msg0210
	dw $5BCA
	dw String_Dialog_Msg0212
	dw $5C54
	dw String_Dialog_Msg0214
	dw String_Dialog_Msg0215
	dw $5D23
	dw $5D68
	dw String_Dialog_Msg0218
	dw String_Dialog_Msg0219
	dw $5E37
	dw $5E7C
	dw $5EC1
	dw $5F06
	dw $5F4B
	dw String_Dialog_Msg021F
	dw String_Dialog_Msg0220
	dw $603B
	dw String_Dialog_Msg0222
	dw $60E6
	dw String_Dialog_Msg0224
	dw $6191
	dw $61F7
	dw $625D
	dw $62C3
	dw $6308
	dw $634D
	dw String_Dialog_Msg022B

Dialog_List3:: ; 72:50BB
	dw String_Dialog_Msg0000

; ---- text $50BD-$514A (141 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0000:: ; 72:50BD

	db $86, $02, $01 ; record header
	db "　　　　　　　　　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $00, $01 ; record header
	db "　　　１００　　　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $00 ; record header

; ---- text $514A-$518C (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg0101_Text:: ; 72:514A
	db $81, $40, $82, $75, $82, $89, $82, $85, $82, $97, $81, $40, $82, $67, $82, $8F ; English dialog bytes at 72:514A
	db $82, $8D, $82, $85, $81, $40, $82, $6F, $82, $81, $82, $87, $82, $85, $81, $40 ; English dialog bytes at 72:515A
	db $00 ; English dialog bytes at 72:516A
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $8F, $82, $86, $82, $86, $82, $8C ; English dialog bytes at 72:516B
	db $82, $89, $82, $8E, $82, $85, $81, $48, $81, $40, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:517B
	db $00 ; English dialog bytes at 72:518B

; ---- text $518C-$51B0 (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0102:: ; 72:518C

	db $86, $00, $01 ; record header
	db "　　　　　　　　　　　　　　　　", 0

; ---- text $51B0-$51D1 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg0102_Line2:: ; 72:51B0
	db $81, $40, $81, $40, $82, $62, $82, $81, $82, $8C, $82, $8C, $81, $40, $82, $85 ; English dialog bytes at 72:51B0
	db $82, $8E, $82, $84, $82, $85, $82, $84, $81, $44, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:51C0
	db $00 ; English dialog bytes at 72:51D0

; ---- text $51D1-$525E (141 bytes) [PROBABLE] text block: 7 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 51B0-52A0 by higher-priority evidence]

String_Dialog_Msg0103:: ; 72:51D1

	db $86, $02, $01 ; record header
	db $82, $64, $82, $8D, $82, $90, $82, $94, $82, $99, $81, $40, $82, $94, $82, $88 ; English dialog bytes at 72:51D4
	db $82, $85, $81, $40, $82, $8D, $82, $85, $82, $8D, $82, $8F, $82, $92, $82, $99 ; English dialog bytes at 72:51E4
	db $00 ; English dialog bytes at 72:51F4
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $82, $82, $81, $82, $8C ; English dialog bytes at 72:51F5
	db $82, $8C, $82, $93, $81, $48, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:5205
	db $00 ; English dialog bytes at 72:5215
	db $86, $02, $01 ; record header
	db $81, $40, $82, $6E, $82, $96, $82, $85, $82, $92, $82, $97, $82, $92, $82, $89 ; English dialog bytes at 72:5219
	db $82, $94, $82, $85, $81, $40, $82, $94, $82, $88, $82, $85, $81, $40, $81, $40 ; English dialog bytes at 72:5229
	db $00 ; English dialog bytes at 72:5239
	db $81, $40, $81, $40, $81, $40, $82, $93, $82, $81, $82, $96, $82, $85, $81, $40 ; English dialog bytes at 72:523A
	db $82, $84, $82, $81, $82, $94, $82, $81, $81, $48, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:524A
	db $00 ; English dialog bytes at 72:525A
	db $86, $02, $00 ; record header

; ---- text $525E-$52A0 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg0105_Text:: ; 72:525E
	db $82, $63, $82, $89, $82, $93, $82, $83, $82, $8F, $82, $8E, $82, $8E, $82, $85 ; English dialog bytes at 72:525E
	db $82, $83, $82, $94, $81, $40, $82, $83, $82, $81, $82, $8C, $82, $8C, $81, $40 ; English dialog bytes at 72:526E
	db $00 ; English dialog bytes at 72:527E
	db $82, $81, $82, $8E, $82, $84, $81, $40, $82, $85, $82, $8E, $82, $84, $81, $40 ; English dialog bytes at 72:527F
	db $82, $93, $82, $85, $82, $93, $82, $93, $82, $89, $82, $8F, $82, $8E, $81, $48 ; English dialog bytes at 72:528F
	db $00 ; English dialog bytes at 72:529F

; ---- text $52A0-$52E8 (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0106:: ; 72:52A0

	db $86, $02, $01 ; record header
	db "　　　　　　１０６　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $01, $01 ; record header

; ---- text $52E8-$532A (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg0107_Text:: ; 72:52E8
	db $82, $6F, $82, $81, $82, $87, $82, $85, $81, $40, $82, $94, $82, $8F, $82, $8F ; English dialog bytes at 72:52E8
	db $81, $40, $82, $82, $82, $89, $82, $87, $81, $40, $82, $94, $82, $8F, $81, $40 ; English dialog bytes at 72:52F8
	db $00 ; English dialog bytes at 72:5308
	db $81, $40, $82, $86, $82, $95, $82, $8C, $82, $8C, $82, $99, $81, $40, $82, $84 ; English dialog bytes at 72:5309
	db $82, $89, $82, $93, $82, $90, $82, $8C, $82, $81, $82, $99, $81, $44, $81, $40 ; English dialog bytes at 72:5319
	db $00 ; English dialog bytes at 72:5329

; ---- text $532A-$53C5 (155 bytes) [PROBABLE] text block: 7 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 52E8-53C5 by higher-priority evidence]

String_Dialog_Msg0108:: ; 72:532A

	db $86, $02, $01 ; record header
	db $81, $40, $82, $64, $82, $92, $82, $81, $82, $93, $82, $85, $81, $40, $82, $94 ; English dialog bytes at 72:532D
	db $82, $88, $82, $85, $81, $40, $82, $90, $82, $81, $82, $87, $82, $85, $81, $40 ; English dialog bytes at 72:533D
	db $00 ; English dialog bytes at 72:534D
	db $81, $40, $81, $40, $81, $40, $82, $83, $82, $8F, $82, $8E, $82, $94, $82, $85 ; English dialog bytes at 72:534E
	db $82, $8E, $82, $94, $82, $93, $81, $48, $81, $40, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:535E
	db $00 ; English dialog bytes at 72:536E
	db $86, $02, $01 ; record header
	db $81, $40, $82, $6E, $82, $96, $82, $85, $82, $92, $82, $97, $82, $92, $82, $89 ; English dialog bytes at 72:5372
	db $82, $94, $82, $85, $81, $40, $82, $94, $82, $88, $82, $85, $81, $40, $81, $40 ; English dialog bytes at 72:5382
	db $00 ; English dialog bytes at 72:5392
	db $81, $40, $81, $40, $81, $40, $82, $93, $82, $81, $82, $96, $82, $85, $81, $40 ; English dialog bytes at 72:5393
	db $82, $84, $82, $81, $82, $94, $82, $81, $81, $48, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:53A3
	db $00 ; English dialog bytes at 72:53B3
	db $86, $01, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $82, $73, $82, $89, $82, $8D, $82, $85 ; English dialog bytes at 72:53B7

; ---- text $53C5-$53D8 (19 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg010A_Line1Suffix_53C5:: ; 72:53C5
	db $F9, $44, $F9, $44, $F9, $44, $F9, $44, $F9, $44, $82, $8D, $82, $89, $82, $8E ; English dialog bytes at 72:53C5
	db $81, $44, $00 ; English dialog bytes at 72:53D5

; ---- text $53D8-$53F9 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg010A_Line2:: ; 72:53D8
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $85, $82, $98 ; English dialog bytes at 72:53D8
	db $82, $83, $82, $85, $82, $85, $82, $84, $82, $85, $82, $84, $81, $44, $81, $40 ; English dialog bytes at 72:53E8
	db $00 ; English dialog bytes at 72:53F8

; ---- text $53F9-$541D (36 bytes) [PROBABLE] text block: 2 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 53D8-541D by higher-priority evidence]

String_Dialog_Msg010B:: ; 72:53F9

	db $86, $01, $01 ; record header
	db $81, $40, $81, $40, $82, $62, $82, $81, $82, $8C, $82, $8C, $81, $40, $82, $85 ; English dialog bytes at 72:53FC
	db $82, $8E, $82, $84, $82, $85, $82, $84, $81, $44, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:540C
	db $00 ; English dialog bytes at 72:541C

; ---- text $541D-$5441 (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg010B_Line2:: ; 72:541D
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $01, $01 ; record header

; ---- text $5441-$5483 (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg010C_Text:: ; 72:5441
	db $82, $6F, $82, $81, $82, $87, $82, $85, $81, $40, $82, $94, $82, $8F, $82, $8F ; English dialog bytes at 72:5441
	db $81, $40, $82, $82, $82, $89, $82, $87, $81, $40, $82, $94, $82, $8F, $81, $40 ; English dialog bytes at 72:5451
	db $00 ; English dialog bytes at 72:5461
	db $81, $40, $82, $86, $82, $95, $82, $8C, $82, $8C, $82, $99, $81, $40, $82, $84 ; English dialog bytes at 72:5462
	db $82, $89, $82, $93, $82, $90, $82, $8C, $82, $81, $82, $99, $81, $44, $81, $40 ; English dialog bytes at 72:5472
	db $00 ; English dialog bytes at 72:5482

; ---- text $5483-$54A7 (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg010D:: ; 72:5483

	db $86, $00, $01 ; record header
	db "　　　　　　　　　　　　　　　　", 0

; ---- text $54A7-$54C8 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg010D_Line2:: ; 72:54A7
	db $82, $63, $82, $89, $82, $93, $82, $83, $82, $8F, $82, $8E, $82, $8E, $82, $85 ; English dialog bytes at 72:54A7
	db $82, $83, $82, $94, $82, $89, $82, $8E, $82, $87, $81, $44, $81, $44, $81, $44 ; English dialog bytes at 72:54B7
	db $00 ; English dialog bytes at 72:54C7

; ---- text $54C8-$54EC (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg010E:: ; 72:54C8

	db $86, $00, $01 ; record header
	db "　　　　　　　　　　　　　　　　", 0

; ---- text $54EC-$550D (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg010E_Line2:: ; 72:54EC
	db $81, $40, $81, $40, $82, $62, $82, $81, $82, $8C, $82, $8C, $81, $40, $82, $85 ; English dialog bytes at 72:54EC
	db $82, $8E, $82, $84, $82, $85, $82, $84, $81, $44, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:54FC
	db $00 ; English dialog bytes at 72:550C

; ---- text $550D-$5531 (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg010F:: ; 72:550D

	db $86, $00, $01 ; record header
	db "　　　　　　　　　　　　　　　　", 0

; ---- text $5531-$5552 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg010F_Line2:: ; 72:5531
	db $82, $63, $82, $89, $82, $93, $82, $83, $82, $8F, $82, $8E, $82, $8E, $82, $85 ; English dialog bytes at 72:5531
	db $82, $83, $82, $94, $82, $89, $82, $8E, $82, $87, $81, $44, $81, $44, $81, $44 ; English dialog bytes at 72:5541
	db $00 ; English dialog bytes at 72:5551

; ---- text $5552-$5576 (36 bytes) [PROBABLE] text block: 2 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5531-5576 by higher-priority evidence]

String_Dialog_Msg0110:: ; 72:5552

	db $86, $01, $01 ; record header
	db $81, $40, $81, $40, $82, $62, $82, $81, $82, $8C, $82, $8C, $81, $40, $82, $85 ; English dialog bytes at 72:5555
	db $82, $8E, $82, $84, $82, $85, $82, $84, $81, $44, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:5565
	db $00 ; English dialog bytes at 72:5575

; ---- text $5576-$559A (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0110_Line2:: ; 72:5576
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $00 ; record header

; ---- text $559A-$55DC (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg0111_Text:: ; 72:559A
	db $82, $63, $82, $8F, $81, $40, $82, $99, $82, $8F, $82, $95, $81, $40, $82, $97 ; English dialog bytes at 72:559A
	db $82, $81, $82, $8E, $82, $94, $81, $40, $82, $94, $82, $8F, $81, $40, $81, $40 ; English dialog bytes at 72:55AA
	db $00 ; English dialog bytes at 72:55BA
	db $82, $93, $82, $94, $82, $81, $82, $99, $81, $40, $82, $83, $82, $8F, $82, $8E ; English dialog bytes at 72:55BB
	db $82, $8E, $82, $85, $82, $83, $82, $94, $82, $85, $82, $84, $81, $48, $81, $40 ; English dialog bytes at 72:55CB
	db $00 ; English dialog bytes at 72:55DB

; ---- text $55DC-$5600 (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0112:: ; 72:55DC

	db $86, $00, $01 ; record header
	db "　　　　　　　　　　　　　　　　", 0

; ---- text $5600-$5621 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg0112_Line2:: ; 72:5600
	db $82, $6D, $82, $8F, $81, $40, $82, $90, $82, $92, $82, $85, $82, $96, $82, $89 ; English dialog bytes at 72:5600
	db $82, $8F, $82, $95, $82, $93, $81, $40, $82, $90, $82, $81, $82, $87, $82, $85 ; English dialog bytes at 72:5610
	db $00 ; English dialog bytes at 72:5620

; ---- text $5621-$5645 (36 bytes) [PROBABLE] text block: 2 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5600-5645 by higher-priority evidence]

String_Dialog_Msg0113:: ; 72:5621

	db $86, $01, $01 ; record header
	db $82, $6D, $82, $8F, $81, $40, $82, $90, $82, $92, $82, $85, $82, $96, $82, $89 ; English dialog bytes at 72:5624
	db $82, $8F, $82, $95, $82, $93, $81, $40, $82, $90, $82, $81, $82, $87, $82, $85 ; English dialog bytes at 72:5634
	db $00 ; English dialog bytes at 72:5644

; ---- text $5645-$5666 (33 bytes) [CONFIRMED] second NUL-terminated line in Dialog_Msg0113; 16 full-width spaces, with no UI meaning assigned to the blank content

String_Dialog_Msg0113_Line2:: ; 72:5645
	db "　　　　　　　　　　　　　　　　", 0

; ---- text $5666-$5669 (3 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0114:: ; 72:5666

	db $86, $02, $00 ; record header

; ---- text $5669-$56AB (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg0114_Text:: ; 72:5669
	db $82, $70, $82, $95, $82, $89, $82, $94, $81, $40, $82, $96, $82, $89, $82, $85 ; English dialog bytes at 72:5669
	db $82, $97, $82, $89, $82, $8E, $82, $87, $81, $40, $82, $94, $82, $88, $82, $85 ; English dialog bytes at 72:5679
	db $00 ; English dialog bytes at 72:5689
	db $81, $40, $81, $40, $81, $40, $82, $67, $82, $8F, $82, $8D, $82, $85, $81, $40 ; English dialog bytes at 72:568A
	db $82, $6F, $82, $81, $82, $87, $82, $85, $81, $44, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:569A
	db $00 ; English dialog bytes at 72:56AA

; ---- text $56AB-$56AE (3 bytes) [PROBABLE] text block: 8 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5669-577A by higher-priority evidence]

String_Dialog_Msg0115:: ; 72:56AB

	db $86, $00, $00 ; record header

; ---- text $56AE-$56F0 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg0115_Text:: ; 72:56AE
	db $81, $40, $81, $40, $81, $40, $82, $67, $82, $8F, $82, $8D, $82, $85, $81, $40 ; English dialog bytes at 72:56AE
	db $82, $6F, $82, $81, $82, $87, $82, $85, $81, $40, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:56BE
	db $00 ; English dialog bytes at 72:56CE
	db $81, $40, $81, $40, $82, $8C, $82, $8F, $82, $81, $82, $84, $81, $40, $82, $85 ; English dialog bytes at 72:56CF
	db $82, $92, $82, $92, $82, $8F, $82, $92, $81, $44, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:56DF
	db $00 ; English dialog bytes at 72:56EF

; ---- text $56F0-$56F3 (3 bytes) [PROBABLE] text block: 8 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5669-577A by higher-priority evidence]

String_Dialog_Msg0116:: ; 72:56F0

	db $86, $01, $00 ; record header

; ---- text $56F3-$5735 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg0116_Text:: ; 72:56F3
	db $81, $40, $81, $40, $81, $40, $82, $67, $82, $8F, $82, $8D, $82, $85, $81, $40 ; English dialog bytes at 72:56F3
	db $82, $6F, $82, $81, $82, $87, $82, $85, $81, $40, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:5703
	db $00 ; English dialog bytes at 72:5713
	db $81, $40, $81, $40, $82, $8C, $82, $8F, $82, $81, $82, $84, $81, $40, $82, $85 ; English dialog bytes at 72:5714
	db $82, $92, $82, $92, $82, $8F, $82, $92, $81, $44, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:5724
	db $00 ; English dialog bytes at 72:5734

; ---- text $5735-$577A (69 bytes) [PROBABLE] text block: 8 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5669-577A by higher-priority evidence]

String_Dialog_Msg0200:: ; 72:5735

	db $86, $02, $01 ; record header
	db $81, $40, $82, $64, $82, $8D, $82, $81, $82, $89, $82, $8C, $81, $40, $82, $97 ; English dialog bytes at 72:5738
	db $82, $89, $82, $8C, $82, $8C, $81, $40, $82, $82, $82, $85, $81, $40, $81, $40 ; English dialog bytes at 72:5748
	db $00 ; English dialog bytes at 72:5758
	db $82, $8C, $82, $8F, $82, $93, $82, $94, $81, $44, $81, $40, $82, $62, $82, $8F ; English dialog bytes at 72:5759
	db $82, $8E, $82, $94, $82, $89, $82, $8E, $82, $95, $82, $85, $81, $48, $00, $00 ; English dialog bytes at 72:5769
	db $00 ; English dialog bytes at 72:5779

; ---- text $577A-$57BF (69 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0201:: ; 72:577A

	db $86, $02, $01 ; record header
	db "　　　　　２０１　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0

; ---- data $57BF-$57C2 (3 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 57BF-5804 by higher-priority evidence]

String_Dialog_Msg0202:: ; 72:57BF

	db $86, $02, $00

; ---- text $57C2-$5804 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg0202_Text:: ; 72:57C2
	db $81, $40, $82, $64, $82, $8D, $82, $81, $82, $89, $82, $8C, $81, $40, $82, $97 ; English dialog bytes at 72:57C2
	db $82, $89, $82, $8C, $82, $8C, $81, $40, $82, $82, $82, $85, $81, $40, $81, $40 ; English dialog bytes at 72:57D2
	db $00 ; English dialog bytes at 72:57E2
	db $82, $93, $82, $81, $82, $96, $82, $85, $82, $84, $81, $44, $81, $40, $82, $62 ; English dialog bytes at 72:57E3
	db $82, $8F, $82, $8E, $82, $94, $82, $89, $82, $8E, $82, $95, $82, $85, $81, $48 ; English dialog bytes at 72:57F3
	db $00 ; English dialog bytes at 72:5803

; ---- text $5804-$5891 (141 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0203:: ; 72:5804

	db $86, $02, $01 ; record header
	db "　　　　　２０３　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $01 ; record header
	db "　　　　　２０４　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $01, $01 ; record header

; ---- text $5891-$58D3 (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg0205_Text:: ; 72:5891
	db $82, $6F, $82, $8C, $82, $85, $82, $81, $82, $93, $82, $85, $81, $40, $82, $85 ; English dialog bytes at 72:5891
	db $82, $8E, $82, $94, $82, $85, $82, $92, $81, $40, $82, $81, $82, $8E, $81, $40 ; English dialog bytes at 72:58A1
	db $00 ; English dialog bytes at 72:58B1
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $81, $82, $84, $82, $84, $82, $92 ; English dialog bytes at 72:58B2
	db $82, $85, $82, $93, $82, $93, $81, $44, $81, $40, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:58C2
	db $00 ; English dialog bytes at 72:58D2

; ---- text $58D3-$5918 (69 bytes) [PROBABLE] text block: 4 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5891-5918 by higher-priority evidence]

String_Dialog_Msg0206:: ; 72:58D3

	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $82, $64, $82, $92, $82, $81, $82, $93, $82, $85 ; English dialog bytes at 72:58D6
	db $81, $40, $82, $94, $82, $88, $82, $89, $82, $93, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:58E6
	db $00 ; English dialog bytes at 72:58F6
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $85, $82, $8D, $82, $81 ; English dialog bytes at 72:58F7
	db $82, $89, $82, $8C, $81, $48, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:5907
	db $00 ; English dialog bytes at 72:5917

; ---- text $5918-$5960 (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0207:: ; 72:5918

	db $86, $02, $01 ; record header
	db "　　　　　２０７　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $01 ; record header

; ---- text $5960-$59A2 (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg0208_Text:: ; 72:5960
	db $81, $40, $82, $6E, $82, $96, $82, $85, $82, $92, $82, $97, $82, $92, $82, $89 ; English dialog bytes at 72:5960
	db $82, $94, $82, $85, $81, $40, $82, $94, $82, $88, $82, $85, $81, $40, $81, $40 ; English dialog bytes at 72:5970
	db $00 ; English dialog bytes at 72:5980
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $81, $82, $84, $82, $84, $82, $92 ; English dialog bytes at 72:5981
	db $82, $85, $82, $93, $82, $93, $81, $48, $81, $40, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:5991
	db $00 ; English dialog bytes at 72:59A1

; ---- text $59A2-$59E7 (69 bytes) [PROBABLE] text block: 4 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5960-59E7 by higher-priority evidence]

String_Dialog_Msg0209:: ; 72:59A2

	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $82, $63, $82, $85, $82, $8C, $82, $85, $82, $94 ; English dialog bytes at 72:59A5
	db $82, $85, $81, $40, $82, $94, $82, $88, $82, $85, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:59B5
	db $00 ; English dialog bytes at 72:59C5
	db $81, $40, $82, $97, $82, $92, $82, $89, $82, $94, $82, $94, $82, $85, $82, $8E ; English dialog bytes at 72:59C6
	db $81, $40, $82, $85, $82, $8D, $82, $81, $82, $89, $82, $8C, $81, $48, $81, $40 ; English dialog bytes at 72:59D6
	db $00 ; English dialog bytes at 72:59E6

; ---- text $59E7-$5A2F (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg020A:: ; 72:59E7

	db $86, $02, $01 ; record header
	db "　　　　　２１０　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $00 ; record header

; ---- text $5A2F-$5A71 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg020B_Text:: ; 72:5A2F
	db $81, $40, $82, $72, $82, $81, $82, $96, $82, $85, $81, $40, $82, $94, $82, $88 ; English dialog bytes at 72:5A2F
	db $82, $89, $82, $93, $81, $40, $82, $8E, $82, $85, $82, $97, $81, $40, $81, $40 ; English dialog bytes at 72:5A3F
	db $00 ; English dialog bytes at 72:5A4F
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $81, $82, $84, $82, $84, $82, $92 ; English dialog bytes at 72:5A50
	db $82, $85, $82, $93, $82, $93, $81, $48, $81, $40, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:5A60
	db $00 ; English dialog bytes at 72:5A70

; ---- text $5A71-$5AB9 (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg020C:: ; 72:5A71

	db $86, $02, $01 ; record header
	db "　　　　　２０３　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $01 ; record header

; ---- text $5AB9-$5AFB (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg020D_Text:: ; 72:5AB9
	db $81, $40, $81, $40, $81, $40, $82, $63, $82, $85, $82, $8C, $82, $85, $82, $94 ; English dialog bytes at 72:5AB9
	db $82, $85, $81, $40, $82, $94, $82, $88, $82, $85, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:5AC9
	db $00 ; English dialog bytes at 72:5AD9
	db $81, $40, $82, $85, $82, $8D, $82, $81, $82, $89, $82, $8C, $81, $40, $82, $81 ; English dialog bytes at 72:5ADA
	db $82, $84, $82, $84, $82, $92, $82, $85, $82, $93, $82, $93, $81, $48, $81, $40 ; English dialog bytes at 72:5AEA
	db $00 ; English dialog bytes at 72:5AFA

; ---- text $5AFB-$5B43 (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg020E:: ; 72:5AFB

	db $86, $02, $01 ; record header
	db "　　　　　２１４　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $01 ; record header

; ---- text $5B43-$5B85 (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg020F_Text:: ; 72:5B43
	db $81, $40, $81, $40, $82, $63, $82, $89, $82, $93, $82, $83, $82, $81, $82, $92 ; English dialog bytes at 72:5B43
	db $82, $84, $81, $40, $82, $94, $82, $88, $82, $85, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:5B53
	db $00 ; English dialog bytes at 72:5B63
	db $81, $40, $82, $84, $82, $92, $82, $81, $82, $86, $82, $94, $82, $85, $82, $84 ; English dialog bytes at 72:5B64
	db $81, $40, $82, $85, $82, $8D, $82, $81, $82, $89, $82, $8C, $81, $48, $81, $40 ; English dialog bytes at 72:5B74
	db $00 ; English dialog bytes at 72:5B84

; ---- text $5B85-$5BCD (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0210:: ; 72:5B85

	db $86, $02, $01 ; record header
	db "　　　　　２０６　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $00 ; record header

; ---- text $5BCD-$5C0F (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg0211_Text:: ; 72:5BCD
	db $81, $40, $82, $62, $82, $81, $82, $8E, $82, $83, $82, $85, $82, $8C, $81, $40 ; English dialog bytes at 72:5BCD
	db $82, $85, $82, $84, $82, $89, $82, $94, $82, $89, $82, $8E, $82, $87, $81, $40 ; English dialog bytes at 72:5BDD
	db $00 ; English dialog bytes at 72:5BED
	db $81, $40, $82, $85, $82, $8D, $82, $81, $82, $89, $82, $8C, $81, $40, $82, $81 ; English dialog bytes at 72:5BEE
	db $82, $84, $82, $84, $82, $92, $82, $85, $82, $93, $82, $93, $81, $48, $81, $40 ; English dialog bytes at 72:5BFE
	db $00 ; English dialog bytes at 72:5C0E

; ---- text $5C0F-$5C57 (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0212:: ; 72:5C0F

	db $86, $02, $01 ; record header
	db "　　　　　２１８　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $01, $01 ; record header

; ---- text $5C57-$5C99 (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg0213_Text:: ; 72:5C57
	db $82, $6F, $82, $8C, $82, $85, $82, $81, $82, $93, $82, $85, $81, $40, $82, $93 ; English dialog bytes at 72:5C57
	db $82, $85, $82, $8E, $82, $84, $81, $40, $82, $99, $82, $8F, $82, $95, $82, $92 ; English dialog bytes at 72:5C67
	db $00 ; English dialog bytes at 72:5C77
	db $81, $40, $82, $95, $82, $8E, $82, $93, $82, $85, $82, $8E, $82, $94, $81, $40 ; English dialog bytes at 72:5C78
	db $82, $85, $82, $8D, $82, $81, $82, $89, $82, $8C, $81, $44, $81, $40, $81, $40 ; English dialog bytes at 72:5C88
	db $00 ; English dialog bytes at 72:5C98

; ---- text $5C99-$5CDE (69 bytes) [PROBABLE] text block: 4 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5C57-5CDE by higher-priority evidence]

String_Dialog_Msg0214:: ; 72:5C99

	db $86, $01, $01 ; record header
	db $81, $40, $82, $6F, $82, $8C, $82, $85, $82, $81, $82, $93, $82, $85, $81, $40 ; English dialog bytes at 72:5C9C
	db $82, $85, $82, $8E, $82, $94, $82, $85, $82, $92, $81, $40, $82, $81, $81, $40 ; English dialog bytes at 72:5CAC
	db $00 ; English dialog bytes at 72:5CBC
	db $81, $40, $81, $40, $81, $40, $82, $8E, $82, $89, $82, $83, $82, $8B, $82, $8E ; English dialog bytes at 72:5CBD
	db $82, $81, $82, $8D, $82, $85, $81, $44, $81, $40, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:5CCD
	db $00 ; English dialog bytes at 72:5CDD

; ---- text $5CDE-$5D6B (141 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0215:: ; 72:5CDE

	db $86, $02, $01 ; record header
	db "　　　　　２２１　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $01 ; record header
	db "　　　　　２２２　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $01 ; record header

; ---- text $5D6B-$5DAD (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg0217_Text:: ; 72:5D6B
	db $81, $40, $81, $40, $82, $63, $82, $89, $82, $93, $82, $83, $82, $81, $82, $92 ; English dialog bytes at 72:5D6B
	db $82, $84, $81, $40, $82, $94, $82, $88, $82, $85, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:5D7B
	db $00 ; English dialog bytes at 72:5D8B
	db $82, $95, $82, $8E, $82, $86, $82, $89, $82, $8E, $82, $89, $82, $93, $82, $88 ; English dialog bytes at 72:5D8C
	db $82, $85, $82, $84, $81, $40, $82, $84, $82, $81, $82, $94, $82, $81, $81, $48 ; English dialog bytes at 72:5D9C
	db $00 ; English dialog bytes at 72:5DAC

; ---- text $5DAD-$5DB0 (3 bytes) [PROBABLE] text block: 4 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5D6B-5DF2 by higher-priority evidence]

String_Dialog_Msg0218:: ; 72:5DAD

	db $86, $02, $00 ; record header

; ---- text $5DB0-$5DF2 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg0218_Text:: ; 72:5DB0
	db $81, $40, $82, $62, $82, $81, $82, $8E, $82, $83, $82, $85, $82, $8C, $81, $40 ; English dialog bytes at 72:5DB0
	db $82, $85, $82, $84, $82, $89, $82, $94, $82, $89, $82, $8E, $82, $87, $81, $40 ; English dialog bytes at 72:5DC0
	db $00 ; English dialog bytes at 72:5DD0
	db $81, $40, $82, $94, $82, $88, $82, $89, $82, $93, $81, $40, $82, $83, $82, $8F ; English dialog bytes at 72:5DD1
	db $82, $8E, $82, $94, $82, $81, $82, $83, $82, $94, $81, $48, $81, $40, $81, $40 ; English dialog bytes at 72:5DE1
	db $00 ; English dialog bytes at 72:5DF1

; ---- text $5DF2-$5F4E (348 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0219:: ; 72:5DF2

	db $86, $02, $01 ; record header
	db "　　　　　２２５　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $01 ; record header
	db "　　　　　２２６　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $01 ; record header
	db "　　　　　２２７　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $01 ; record header
	db "　　　　　２２８　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $01 ; record header
	db "　　　　　２２９　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $01, $01 ; record header

; ---- text $5F4E-$5F90 (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg021E_Text:: ; 72:5F4E
	db $82, $73, $82, $8F, $82, $8F, $81, $40, $82, $8D, $82, $81, $82, $8E, $82, $99 ; English dialog bytes at 72:5F4E
	db $81, $40, $82, $83, $82, $88, $82, $81, $82, $92, $82, $81, $82, $83, $81, $5B ; English dialog bytes at 72:5F5E
	db $00 ; English dialog bytes at 72:5F6E
	db $82, $94, $82, $85, $82, $92, $82, $93, $81, $40, $82, $94, $82, $8F, $81, $40 ; English dialog bytes at 72:5F6F
	db $82, $84, $82, $89, $82, $93, $82, $90, $82, $8C, $82, $81, $82, $99, $81, $44 ; English dialog bytes at 72:5F7F
	db $00 ; English dialog bytes at 72:5F8F

; ---- text $5F90-$5F93 (3 bytes) [PROBABLE] text block: 5 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5F4E-5FF6 by higher-priority evidence]

String_Dialog_Msg021F:: ; 72:5F90

	db $86, $05, $00 ; record header

; ---- text $5F93-$5FF6 (99 bytes) [CONFIRMED] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg021F_Text:: ; 72:5F93
	db $82, $73, $82, $88, $82, $85, $81, $40, $82, $8D, $82, $81, $82, $89, $82, $8C ; English dialog bytes at 72:5F93
	db $81, $40, $82, $82, $82, $8F, $82, $98, $81, $40, $82, $89, $82, $93, $81, $40 ; English dialog bytes at 72:5FA3
	db $00 ; English dialog bytes at 72:5FB3
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $86, $82, $95 ; English dialog bytes at 72:5FB4
	db $82, $8C, $82, $8C, $81, $44, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:5FC4
	db $00 ; English dialog bytes at 72:5FD4
	db $82, $63, $82, $85, $82, $8C, $81, $44, $81, $40, $82, $8F, $82, $8C, $82, $84 ; English dialog bytes at 72:5FD5
	db $81, $40, $82, $85, $82, $8D, $82, $81, $82, $89, $82, $8C, $81, $48, $81, $40 ; English dialog bytes at 72:5FE5
	db $00 ; English dialog bytes at 72:5FF5

; ---- text $5FF6-$603E (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0220:: ; 72:5FF6

	db $86, $02, $01 ; record header
	db "　　　　　２３２　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $00 ; record header

; ---- text $603E-$6080 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg0221_Text:: ; 72:603E
	db $81, $40, $82, $64, $82, $8D, $82, $81, $82, $89, $82, $8C, $81, $40, $82, $84 ; English dialog bytes at 72:603E
	db $82, $85, $82, $8C, $82, $85, $82, $94, $82, $85, $82, $84, $81, $44, $81, $40 ; English dialog bytes at 72:604E
	db $00 ; English dialog bytes at 72:605E
	db $82, $63, $82, $85, $82, $8C, $82, $85, $82, $94, $82, $85, $81, $40, $82, $81 ; English dialog bytes at 72:605F
	db $82, $8E, $82, $8F, $82, $94, $82, $88, $82, $85, $82, $92, $81, $48, $81, $40 ; English dialog bytes at 72:606F
	db $00 ; English dialog bytes at 72:607F

; ---- text $6080-$60E9 (105 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0222:: ; 72:6080

	db $86, $04, $01 ; record header
	db "　　　　　　２３４　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $01 ; record header

; ---- text $60E9-$612B (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg0223_Text:: ; 72:60E9
	db $81, $40, $81, $40, $82, $63, $82, $85, $82, $8C, $82, $85, $82, $94, $82, $85 ; English dialog bytes at 72:60E9
	db $81, $40, $82, $85, $82, $8D, $82, $81, $82, $89, $82, $8C, $81, $40, $81, $40 ; English dialog bytes at 72:60F9
	db $00 ; English dialog bytes at 72:6109
	db $81, $40, $81, $40, $82, $86, $82, $92, $82, $8F, $82, $8D, $81, $40, $82, $93 ; English dialog bytes at 72:610A
	db $82, $85, $82, $92, $82, $96, $82, $85, $82, $92, $81, $48, $81, $40, $81, $40 ; English dialog bytes at 72:611A
	db $00 ; English dialog bytes at 72:612A

; ---- text $612B-$6350 (549 bytes) [PROBABLE] text block: 22 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 60E9-63D7 by higher-priority evidence]

String_Dialog_Msg0224:: ; 72:612B

	db $86, $04, $01 ; record header
	db $82, $64, $82, $8D, $82, $81, $82, $89, $82, $8C, $81, $40, $82, $86, $82, $92 ; English dialog bytes at 72:612E
	db $82, $8F, $82, $8D, $81, $40, $82, $8F, $82, $94, $82, $88, $82, $85, $82, $92 ; English dialog bytes at 72:613E
	db $00 ; English dialog bytes at 72:614E
	db $81, $40, $82, $90, $82, $92, $82, $8F, $82, $87, $82, $92, $82, $81, $82, $8D ; English dialog bytes at 72:614F
	db $82, $93, $81, $40, $82, $94, $82, $81, $82, $8B, $82, $85, $81, $40, $81, $40 ; English dialog bytes at 72:615F
	db $00 ; English dialog bytes at 72:616F
	db $81, $40, $82, $81, $81, $40, $82, $8C, $82, $8F, $82, $94, $81, $40, $82, $8F ; English dialog bytes at 72:6170
	db $82, $86, $81, $40, $82, $94, $82, $89, $82, $8D, $82, $85, $81, $44, $81, $40 ; English dialog bytes at 72:6180
	db $00 ; English dialog bytes at 72:6190
	db $86, $04, $01 ; record header
	db $81, $40, $82, $6F, $82, $8C, $82, $85, $82, $81, $82, $93, $82, $85, $81, $40 ; English dialog bytes at 72:6194
	db $82, $84, $82, $85, $82, $8C, $82, $85, $82, $94, $82, $85, $81, $40, $81, $40 ; English dialog bytes at 72:61A4
	db $00 ; English dialog bytes at 72:61B4
	db $81, $40, $82, $85, $82, $8D, $82, $81, $82, $89, $82, $8C, $81, $40, $82, $93 ; English dialog bytes at 72:61B5
	db $82, $85, $82, $8E, $82, $94, $81, $40, $82, $82, $82, $99, $81, $40, $81, $40 ; English dialog bytes at 72:61C5
	db $00 ; English dialog bytes at 72:61D5
	db $82, $8F, $82, $94, $82, $88, $82, $85, $82, $92, $81, $40, $82, $90, $82, $92 ; English dialog bytes at 72:61D6
	db $82, $8F, $82, $87, $82, $92, $82, $81, $82, $8D, $82, $93, $81, $44, $81, $40 ; English dialog bytes at 72:61E6
	db $00 ; English dialog bytes at 72:61F6
	db $86, $04, $01 ; record header
	db $81, $40, $82, $6F, $82, $8C, $82, $85, $82, $81, $82, $93, $82, $85, $81, $40 ; English dialog bytes at 72:61FA
	db $82, $84, $82, $85, $82, $8C, $82, $85, $82, $94, $82, $85, $81, $40, $81, $40 ; English dialog bytes at 72:620A
	db $00 ; English dialog bytes at 72:621A
	db $81, $40, $82, $85, $82, $8D, $82, $81, $82, $89, $82, $8C, $81, $40, $82, $93 ; English dialog bytes at 72:621B
	db $82, $85, $82, $8E, $82, $94, $81, $40, $82, $82, $82, $99, $81, $40, $81, $40 ; English dialog bytes at 72:622B
	db $00 ; English dialog bytes at 72:623B
	db $82, $8F, $82, $94, $82, $88, $82, $85, $82, $92, $81, $40, $82, $90, $82, $92 ; English dialog bytes at 72:623C
	db $82, $8F, $82, $87, $82, $92, $82, $81, $82, $8D, $82, $93, $81, $44, $81, $40 ; English dialog bytes at 72:624C
	db $00 ; English dialog bytes at 72:625C
	db $86, $04, $01 ; record header
	db $82, $6F, $82, $8C, $82, $85, $82, $81, $82, $93, $82, $85, $81, $40, $82, $92 ; English dialog bytes at 72:6260
	db $82, $85, $82, $81, $82, $84, $81, $40, $82, $94, $82, $88, $82, $85, $81, $40 ; English dialog bytes at 72:6270
	db $00 ; English dialog bytes at 72:6280
	db $81, $40, $82, $8D, $82, $81, $82, $8E, $82, $95, $82, $81, $82, $8C, $81, $40 ; English dialog bytes at 72:6281
	db $82, $82, $82, $85, $82, $86, $82, $8F, $82, $92, $82, $85, $81, $40, $81, $40 ; English dialog bytes at 72:6291
	db $00 ; English dialog bytes at 72:62A1
	db $81, $40, $81, $40, $81, $40, $82, $84, $82, $85, $82, $8C, $82, $85, $82, $94 ; English dialog bytes at 72:62A2
	db $82, $89, $82, $8E, $82, $87, $81, $44, $81, $40, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:62B2
	db $00 ; English dialog bytes at 72:62C2
	db $86, $00, $01 ; record header
	db $81, $40, $82, $6D, $82, $8F, $81, $40, $82, $85, $82, $8D, $82, $81, $82, $89 ; English dialog bytes at 72:62C6
	db $82, $8C, $81, $40, $82, $8F, $82, $8E, $81, $40, $82, $94, $82, $88, $82, $85 ; English dialog bytes at 72:62D6
	db $00 ; English dialog bytes at 72:62E6
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $93, $82, $85, $82, $92, $82, $96 ; English dialog bytes at 72:62E7
	db $82, $85, $82, $92, $81, $44, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40 ; English dialog bytes at 72:62F7
	db $00 ; English dialog bytes at 72:6307
	db $86, $00, $01 ; record header
	db $82, $62, $82, $88, $82, $85, $82, $83, $82, $8B, $81, $40, $82, $83, $82, $8F ; English dialog bytes at 72:630B
	db $82, $8D, $82, $90, $82, $8C, $82, $85, $82, $94, $82, $85, $82, $84, $81, $44 ; English dialog bytes at 72:631B
	db $00 ; English dialog bytes at 72:632B
	db $82, $65, $82, $89, $82, $8E, $82, $89, $82, $93, $82, $88, $82, $89, $82, $8E ; English dialog bytes at 72:632C
	db $82, $87, $81, $40, $82, $83, $82, $81, $82, $8C, $82, $8C, $81, $44, $00, $00 ; English dialog bytes at 72:633C
	db $00 ; English dialog bytes at 72:634C
	db $86, $02, $00 ; record header

; ---- text $6350-$6392 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Dialog_Msg022A_Text:: ; 72:6350
	db $82, $6D, $82, $8F, $81, $40, $82, $93, $82, $85, $82, $92, $82, $96, $82, $85 ; English dialog bytes at 72:6350
	db $82, $92, $81, $40, $82, $85, $82, $8D, $82, $81, $82, $89, $82, $8C, $81, $40 ; English dialog bytes at 72:6360
	db $00 ; English dialog bytes at 72:6370
	db $82, $97, $82, $89, $82, $8C, $82, $8C, $81, $40, $82, $82, $82, $85, $81, $40 ; English dialog bytes at 72:6371
	db $82, $84, $82, $85, $82, $8C, $82, $85, $82, $94, $82, $85, $82, $84, $81, $44 ; English dialog bytes at 72:6381
	db $00 ; English dialog bytes at 72:6391

; ---- text $6392-$63D7 (69 bytes) [PROBABLE] text block: 22 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 60E9-63D7 by higher-priority evidence]

String_Dialog_Msg022B:: ; 72:6392

	db $86, $01, $01 ; record header
	db $82, $62, $82, $81, $82, $8E, $81, $40, $82, $8E, $82, $8F, $82, $94, $81, $40 ; English dialog bytes at 72:6395
	db $82, $84, $82, $89, $82, $93, $82, $90, $82, $8C, $82, $81, $82, $99, $81, $44 ; English dialog bytes at 72:63A5
	db $00 ; English dialog bytes at 72:63B5
	db $82, $72, $82, $81, $82, $8D, $82, $85, $81, $40, $82, $84, $82, $81, $82, $94 ; English dialog bytes at 72:63B6
	db $82, $81, $81, $40, $82, $86, $82, $8F, $82, $95, $82, $8E, $82, $84, $81, $44 ; English dialog bytes at 72:63C6
	db $00 ; English dialog bytes at 72:63D6

; ---- data $63D7-$63D8 (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint) | observed: single $AF (xor a) after the string terminator at 63D6 and directly before the far-call target 72:63D8; its far-call site is 4E:4D16, not 4E:4D10, which is inside the preceding CALL operand; left unclassified

Data_BrowserMenu_CandidateXorAOpcode_63D7:: ; 72:63D7
	db $AF

POPC
