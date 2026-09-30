; data/text/dialog_messages.asm
; bank 72, $502B-$63D8 (5037 bytes); pinned by layout.link
; dialog list table and the 69 message records

SECTION "data/text/dialog_messages", ROMX

; ---- ptrtable $502B-$50BD (146 bytes) [PROBABLE] little-endian word table, 73 entries, monotone=0.99, 92% of targets on string start/after NUL, targets $5033..$50BD; referenced by ld r16,$502B at 72:402D

Dialog_ListTable:: ; 72:502B
Table_72_502B::
	dw Dialog_List0
	dw Dialog_List1_Browser
	dw Dialog_List2_Mail
	dw Dialog_List3

Dialog_List0:: ; 72:5033
	dw String_72_50BD

Dialog_List1_Browser:: ; 72:5035
	dw $5102
	dw $5147
	dw String_72_518C
	dw String_72_51D1
	dw $5216
	dw $525B
	dw String_72_52A0
	dw $52E5
	dw String_72_532A
	dw $536F
	dw $53B4
	dw String_72_53F9
	dw $543E
	dw String_72_5483
	dw String_72_54C8
	dw String_72_550D
	dw String_72_5552
	dw $5597
	dw String_72_55DC
	dw String_72_5621
	dw String_72_5666
	dw String_72_56AB
	dw String_72_56F0

Dialog_List2_Mail:: ; 72:5063
	dw String_72_5735
	dw String_72_577A
	dw Data_72_57BF
	dw String_72_5804
	dw $5849
	dw $588E
	dw String_72_58D3
	dw String_72_5918
	dw $595D
	dw String_72_59A2
	dw String_72_59E7
	dw $5A2C
	dw String_72_5A71
	dw $5AB6
	dw String_72_5AFB
	dw $5B40
	dw String_72_5B85
	dw $5BCA
	dw String_72_5C0F
	dw $5C54
	dw String_72_5C99
	dw String_72_5CDE
	dw $5D23
	dw $5D68
	dw String_72_5DAD
	dw String_72_5DF2
	dw $5E37
	dw $5E7C
	dw $5EC1
	dw $5F06
	dw $5F4B
	dw String_72_5F90
	dw String_72_5FF6
	dw $603B
	dw String_72_6080
	dw $60E6
	dw String_72_612B
	dw $6191
	dw $61F7
	dw $625D
	dw $62C3
	dw $6308
	dw $634D
	dw String_72_6392

Dialog_List3:: ; 72:50BB
	dw String_72_50BD

; ---- text $50BD-$514A (141 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_50BD:: ; 72:50BD
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $00, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $82, $50, $82, $4F, $82, $4F, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　１００　　　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $02, $00 ; record header

; ---- text $514A-$518C (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_514A:: ; 72:514A
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $C5, $82, $F1, $82, $ED, $82, $F0, $81, $40, $82, $AB, $82, $C1, $82, $C4, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　でんわを　きって　　　　"
	db $81, $40, $81, $40, $81, $40, $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $82, $F0, $82, $DD, $82, $DC, $82, $B7, $81, $42, $81, $40, $81, $40, $00 ; "　　　ホームページをみます。　　"

; ---- text $518C-$51B0 (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_518C:: ; 72:518C
	db $86, $00, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"

; ---- text $51B0-$51D1 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_51B0:: ; 72:51B0
	db $81, $40, $81, $40, $81, $40, $82, $C5, $82, $F1, $82, $ED, $82, $F0, $82, $AB, $82, $E8, $82, $DC, $82, $B5, $82, $BD, $81, $42, $81, $40, $81, $40, $81, $40, $00 ; "　　　でんわをきりました。　　　"

; ---- text $51D1-$525E (141 bytes) [PROBABLE] text block: 7 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 51B0-52A0 by higher-priority evidence]

String_72_51D1:: ; 72:51D1
	db $86, $02, $01 ; record header
	db $81, $40, $83, $81, $83, $82, $83, $8A, $81, $5B, $83, $7B, $81, $5B, $83, $8B, $82, $F0, $82, $A9, $82, $E7, $82, $C9, $82, $B5, $82, $DC, $82, $B7, $81, $42, $00 ; "　メモリーボールをからにします。"
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　よろしいですか？　　　　"
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $83, $5A, $81, $5B, $83, $75, $82, $B3, $82, $EA, $82, $C4, $82, $A2, $82, $E9, $83, $66, $81, $5B, $83, $5E, $82, $F0, $81, $40, $81, $40, $00 ; "　　セーブされているデータを　　"
	db $82, $A4, $82, $ED, $82, $AA, $82, $AB, $82, $B5, $82, $DC, $82, $B7, $81, $42, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $00 ; "うわがきします。よろしいですか？"
	db $86, $02, $00 ; record header

; ---- text $525E-$52A0 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_525E:: ; 72:525E
	db $81, $40, $82, $C5, $82, $F1, $82, $ED, $82, $F0, $82, $AB, $82, $C1, $82, $C4, $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $82, $F0, $81, $40, $00 ; "　でんわをきってホームページを　"
	db $81, $40, $81, $40, $81, $40, $82, $B5, $82, $E3, $82, $A4, $82, $E8, $82, $E5, $82, $A4, $82, $B5, $82, $DC, $82, $B7, $81, $42, $81, $40, $81, $40, $81, $40, $00 ; "　　　しゅうりょうします。　　　"

; ---- text $52A0-$52E8 (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_52A0:: ; 72:52A0
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $50, $82, $4F, $82, $55, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　１０６　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $01, $01 ; record header

; ---- text $52E8-$532A (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_52E8:: ; 72:52E8
	db $81, $40, $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $82, $AA, $82, $A8, $82, $A8, $82, $AB, $82, $B7, $82, $AC, $82, $C4, $81, $40, $81, $40, $00 ; "　ホームページがおおきすぎて　　"
	db $82, $B7, $82, $D7, $82, $C4, $82, $D0, $82, $E5, $82, $A4, $82, $B6, $81, $40, $82, $C5, $82, $AB, $82, $DC, $82, $B9, $82, $F1, $82, $C5, $82, $B5, $82, $BD, $00 ; "すべてひょうじ　できませんでした"

; ---- text $532A-$53C5 (155 bytes) [PROBABLE] text block: 7 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 52E8-53C5 by higher-priority evidence]

String_72_532A:: ; 72:532A
	db $86, $02, $01 ; record header
	db $81, $40, $83, $79, $81, $5B, $83, $57, $82, $CC, $82, $C8, $82, $A2, $82, $E6, $82, $A4, $82, $F0, $82, $AF, $82, $B5, $82, $DC, $82, $B7, $81, $42, $81, $40, $00 ; "　ページのないようをけします。　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　よろしいですか？　　　　"
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $83, $5A, $81, $5B, $83, $75, $82, $B3, $82, $EA, $82, $C4, $82, $A2, $82, $E9, $83, $66, $81, $5B, $83, $5E, $82, $F0, $81, $40, $81, $40, $00 ; "　　セーブされているデータを　　"
	db $82, $A4, $82, $ED, $82, $AA, $82, $AB, $82, $B5, $82, $DC, $82, $B7, $81, $42, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $00 ; "うわがきします。よろしいですか？"
	db $86, $01, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $82, $B6, $82, $A9, $82, $F1, $82, $AA ; "　　　じかんが"

; ---- text $53C5-$53D8 (19 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_53C5:: ; 72:53C5
	db $F9, $44, $F9, $44, $F9, $44, $F9, $44, $F9, $44, $82, $D3, $82, $F1, $81, $40, $81, $40, $00 ; "<$F9><$44><$F9><$44><$F9><$44><$F9><$44><$F9><$44>ふん　　"

; ---- text $53D8-$53F9 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_53D8:: ; 72:53D8
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $F0, $82, $B1, $82, $A6, $82, $DC, $82, $B5, $82, $BD, $81, $42, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　をこえました。　　　　"

; ---- text $53F9-$541D (36 bytes) [PROBABLE] text block: 2 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 53D8-541D by higher-priority evidence]

String_72_53F9:: ; 72:53F9
	db $86, $01, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $82, $C5, $82, $F1, $82, $ED, $82, $F0, $82, $AB, $82, $E8, $82, $DC, $82, $B5, $82, $BD, $81, $42, $81, $40, $81, $40, $81, $40, $00 ; "　　　でんわをきりました。　　　"

; ---- text $541D-$5441 (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_541D:: ; 72:541D
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $01, $01 ; record header

; ---- text $5441-$5483 (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5441:: ; 72:5441
	db $81, $40, $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $82, $AA, $82, $A8, $82, $A8, $82, $AB, $82, $B7, $82, $AC, $82, $C4, $81, $40, $81, $40, $00 ; "　ホームページがおおきすぎて　　"
	db $82, $B7, $82, $D7, $82, $C4, $82, $D0, $82, $E5, $82, $A4, $82, $B6, $81, $40, $82, $C5, $82, $AB, $82, $DC, $82, $B9, $82, $F1, $82, $C5, $82, $B5, $82, $BD, $00 ; "すべてひょうじ　できませんでした"

; ---- text $5483-$54A7 (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_5483:: ; 72:5483
	db $86, $00, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"

; ---- text $54A7-$54C8 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_54A7:: ; 72:54A7
	db $81, $40, $81, $40, $81, $40, $82, $C5, $82, $F1, $82, $ED, $82, $F0, $82, $AB, $82, $C1, $82, $C4, $82, $A2, $82, $DC, $82, $B7, $81, $42, $81, $40, $81, $40, $00 ; "　　　でんわをきっています。　　"

; ---- text $54C8-$54EC (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_54C8:: ; 72:54C8
	db $86, $00, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"

; ---- text $54EC-$550D (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_54EC:: ; 72:54EC
	db $81, $40, $81, $40, $81, $40, $82, $C5, $82, $F1, $82, $ED, $82, $AA, $82, $AB, $82, $EA, $82, $DC, $82, $B5, $82, $BD, $81, $42, $81, $40, $81, $40, $81, $40, $00 ; "　　　でんわがきれました。　　　"

; ---- text $550D-$5531 (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_550D:: ; 72:550D
	db $86, $00, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"

; ---- text $5531-$5552 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5531:: ; 72:5531
	db $81, $40, $81, $40, $81, $40, $82, $C5, $82, $F1, $82, $ED, $82, $F0, $82, $AB, $82, $C1, $82, $C4, $82, $A2, $82, $DC, $82, $B7, $81, $42, $81, $40, $81, $40, $00 ; "　　　でんわをきっています。　　"

; ---- text $5552-$5576 (36 bytes) [PROBABLE] text block: 2 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5531-5576 by higher-priority evidence]

String_72_5552:: ; 72:5552
	db $86, $01, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $82, $C5, $82, $F1, $82, $ED, $82, $AA, $82, $AB, $82, $EA, $82, $DC, $82, $B5, $82, $BD, $81, $42, $81, $40, $81, $40, $81, $40, $00 ; "　　　でんわがきれました。　　　"

; ---- text $5576-$559A (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_5576:: ; 72:5576
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $02, $00 ; record header

; ---- text $559A-$55DC (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_559A:: ; 72:559A
	db $82, $C2, $82, $A4, $82, $B5, $82, $F1, $82, $B9, $82, $C2, $82, $BC, $82, $AD, $82, $F0, $81, $40, $82, $C2, $82, $C3, $82, $AF, $82, $DC, $82, $B7, $81, $42, $00 ; "つうしんせつぞくを　つづけます。"
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　よろしいですか？　　　　"

; ---- text $55DC-$5600 (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_55DC:: ; 72:55DC
	db $86, $00, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"

; ---- text $5600-$5621 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5600:: ; 72:5600
	db $81, $40, $82, $E0, $82, $C7, $82, $EA, $82, $E9, $83, $79, $81, $5B, $83, $57, $82, $AA, $81, $40, $82, $A0, $82, $E8, $82, $DC, $82, $B9, $82, $F1, $81, $42, $00 ; "　もどれるページが　ありません。"

; ---- text $5621-$5645 (36 bytes) [PROBABLE] text block: 2 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5600-5645 by higher-priority evidence]

String_72_5621:: ; 72:5621
	db $86, $01, $01 ; record header
	db $81, $40, $82, $E0, $82, $C7, $82, $EA, $82, $E9, $83, $79, $81, $5B, $83, $57, $82, $AA, $81, $40, $82, $A0, $82, $E8, $82, $DC, $82, $B9, $82, $F1, $81, $42, $00 ; "　もどれるページが　ありません。"

; ---- data $5645-$5666 (33 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 5621-5666 by higher-priority evidence]

Data_72_5645:: ; 72:5645
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40
	db $00

; ---- text $5666-$5669 (3 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_5666:: ; 72:5666
	db $86, $02, $00 ; record header

; ---- text $5669-$56AB (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5669:: ; 72:5669
	db $81, $40, $81, $40, $81, $40, $81, $40, $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $82, $F0, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　ホームページを　　　　　"
	db $81, $40, $81, $40, $81, $40, $82, $B5, $82, $E3, $82, $A4, $82, $E8, $82, $E5, $82, $A4, $82, $B5, $82, $DC, $82, $B7, $81, $42, $81, $40, $81, $40, $81, $40, $00 ; "　　　しゅうりょうします。　　　"

; ---- text $56AB-$56AE (3 bytes) [PROBABLE] text block: 8 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5669-577A by higher-priority evidence]

String_72_56AB:: ; 72:56AB
	db $86, $00, $00 ; record header

; ---- text $56AE-$56F0 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_56AE:: ; 72:56AE
	db $81, $40, $81, $40, $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $82, $F0, $82, $BD, $82, $BE, $82, $B5, $82, $AD, $81, $40, $81, $40, $81, $40, $00 ; "　　ホームページをただしく　　　"
	db $81, $40, $81, $40, $82, $D0, $82, $E5, $82, $A4, $82, $B6, $82, $C5, $82, $AB, $82, $DC, $82, $B9, $82, $F1, $82, $C5, $82, $B5, $82, $BD, $81, $42, $81, $40, $00 ; "　　ひょうじできませんでした。　"

; ---- text $56F0-$56F3 (3 bytes) [PROBABLE] text block: 8 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5669-577A by higher-priority evidence]

String_72_56F0:: ; 72:56F0
	db $86, $01, $00 ; record header

; ---- text $56F3-$5735 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_56F3:: ; 72:56F3
	db $81, $40, $81, $40, $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $82, $F0, $82, $BD, $82, $BE, $82, $B5, $82, $AD, $81, $40, $81, $40, $81, $40, $00 ; "　　ホームページをただしく　　　"
	db $81, $40, $81, $40, $82, $D0, $82, $E5, $82, $A4, $82, $B6, $82, $C5, $82, $AB, $82, $DC, $82, $B9, $82, $F1, $82, $C5, $82, $B5, $82, $BD, $81, $42, $81, $40, $00 ; "　　ひょうじできませんでした。　"

; ---- text $5735-$577A (69 bytes) [PROBABLE] text block: 8 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5669-577A by higher-priority evidence]

String_72_5735:: ; 72:5735
	db $86, $02, $01 ; record header
	db $81, $40, $82, $A9, $82, $AB, $82, $A9, $82, $AF, $82, $CC, $83, $81, $81, $5B, $83, $8B, $82, $CD, $81, $40, $82, $AB, $82, $A6, $82, $C4, $81, $40, $81, $40, $00 ; "　かきかけのメールは　きえて　　"
	db $81, $40, $82, $B5, $82, $DC, $82, $A2, $82, $DC, $82, $B7, $81, $42, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $81, $40, $00 ; "　しまいます。よろしいですか？　"

; ---- text $577A-$57BF (69 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_577A:: ; 72:577A
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $51, $82, $4F, $82, $50, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　２０１　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"

; ---- data $57BF-$57C2 (3 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 57BF-5804 by higher-priority evidence]

Data_72_57BF:: ; 72:57BF
	db $86, $02, $00

; ---- text $57C2-$5804 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_57C2:: ; 72:57C2
	db $81, $40, $82, $A9, $82, $A2, $82, $BD, $83, $81, $81, $5B, $83, $8B, $82, $F0, $81, $40, $83, $5A, $81, $5B, $83, $75, $82, $B5, $82, $DC, $82, $B7, $81, $42, $00 ; "　かいたメールを　セーブします。"
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　よろしいですか？　　　　"

; ---- text $5804-$5891 (141 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_5804:: ; 72:5804
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $51, $82, $4F, $82, $52, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　２０３　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $51, $82, $4F, $82, $53, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　２０４　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $01, $01 ; record header

; ---- text $5891-$58D3 (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5891:: ; 72:5891
	db $81, $40, $81, $40, $81, $40, $81, $40, $83, $81, $81, $5B, $83, $8B, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $CD, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　メールアドレスは　　　　"
	db $81, $40, $81, $40, $82, $A9, $82, $C8, $82, $E7, $82, $B8, $82, $A9, $82, $A2, $82, $C4, $82, $AD, $82, $BE, $82, $B3, $82, $A2, $81, $42, $81, $40, $81, $40, $00 ; "　　かならずかいてください。　　"

; ---- text $58D3-$5918 (69 bytes) [PROBABLE] text block: 4 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5891-5918 by higher-priority evidence]

String_72_58D3:: ; 72:58D3
	db $86, $02, $01 ; record header
	db $81, $40, $82, $E0, $82, $E7, $82, $C1, $82, $BD, $83, $81, $81, $5B, $83, $8B, $82, $F0, $81, $40, $82, $AF, $82, $B5, $82, $DC, $82, $B7, $81, $42, $81, $40, $00 ; "　もらったメールを　けします。　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　よろしいですか？　　　　"

; ---- text $5918-$5960 (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_5918:: ; 72:5918
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $51, $82, $4F, $82, $56, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　２０７　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $02, $01 ; record header

; ---- text $5960-$59A2 (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5960:: ; 72:5960
	db $81, $40, $81, $40, $81, $40, $81, $40, $83, $81, $81, $5B, $83, $8B, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $F0, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　メールアドレスを　　　　"
	db $82, $A4, $82, $ED, $82, $AA, $82, $AB, $82, $B5, $82, $DC, $82, $B7, $81, $40, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $00 ; "うわがきします　よろしいですか？"

; ---- text $59A2-$59E7 (69 bytes) [PROBABLE] text block: 4 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5960-59E7 by higher-priority evidence]

String_72_59A2:: ; 72:59A2
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $82, $A9, $82, $A2, $82, $BD, $83, $81, $81, $5B, $83, $8B, $82, $F0, $81, $40, $82, $AF, $82, $B5, $82, $DC, $82, $B7, $81, $42, $81, $40, $00 ; "　　かいたメールを　けします。　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　よろしいですか？　　　　"

; ---- text $59E7-$5A2F (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_59E7:: ; 72:59E7
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $51, $82, $50, $82, $4F, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　２１０　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $02, $00 ; record header

; ---- text $5A2F-$5A71 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5A2F:: ; 72:5A2F
	db $83, $81, $81, $5B, $83, $8B, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $F0, $81, $40, $83, $5A, $81, $5B, $83, $75, $82, $B5, $82, $DC, $82, $B7, $81, $42, $00 ; "メールアドレスを　セーブします。"
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　よろしいですか？　　　　"

; ---- text $5A71-$5AB9 (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_5A71:: ; 72:5A71
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $51, $82, $4F, $82, $52, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　２０３　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $02, $01 ; record header

; ---- text $5AB9-$5AFB (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5AB9:: ; 72:5AB9
	db $81, $40, $83, $81, $81, $5B, $83, $8B, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $F0, $81, $40, $82, $AF, $82, $B5, $82, $DC, $82, $B7, $81, $42, $81, $40, $00 ; "　メールアドレスを　けします。　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　よろしいですか？　　　　"

; ---- text $5AFB-$5B43 (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_5AFB:: ; 72:5AFB
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $51, $82, $50, $82, $53, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　２１４　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $02, $01 ; record header

; ---- text $5B43-$5B85 (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5B43:: ; 72:5B43
	db $81, $40, $82, $A9, $82, $AB, $82, $A9, $82, $AF, $82, $CC, $82, $D6, $82, $F1, $82, $B6, $82, $CD, $81, $40, $82, $AB, $82, $A6, $82, $C4, $81, $40, $81, $40, $00 ; "　かきかけのへんじは　きえて　　"
	db $81, $40, $82, $B5, $82, $DC, $82, $A2, $82, $DC, $82, $B7, $81, $42, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $81, $40, $00 ; "　しまいます。よろしいですか？　"

; ---- text $5B85-$5BCD (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_5B85:: ; 72:5B85
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $51, $82, $4F, $82, $55, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　２０６　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $02, $00 ; record header

; ---- text $5BCD-$5C0F (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5BCD:: ; 72:5BCD
	db $81, $40, $83, $81, $81, $5B, $83, $8B, $82, $CC, $82, $B5, $82, $E3, $82, $A4, $82, $B9, $82, $A2, $82, $F0, $82, $E2, $82, $DF, $82, $DC, $82, $B7, $81, $42, $00 ; "　メールのしゅうせいをやめます。"
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　よろしいですか？　　　　"

; ---- text $5C0F-$5C57 (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_5C0F:: ; 72:5C0F
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $51, $82, $50, $82, $57, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　２１８　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $01, $01 ; record header

; ---- text $5C57-$5C99 (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5C57:: ; 72:5C57
	db $82, $A8, $82, $AD, $82, $C1, $82, $C4, $82, $A2, $82, $C8, $82, $A2, $83, $81, $81, $5B, $83, $8B, $82, $AA, $82, $A0, $82, $E8, $82, $DC, $82, $B7, $81, $42, $00 ; "おくっていないメールがあります。"
	db $82, $D6, $82, $F1, $82, $B6, $82, $F0, $82, $A9, $82, $AD, $82, $B1, $82, $C6, $82, $AA, $81, $40, $82, $C5, $82, $AB, $82, $DC, $82, $B9, $82, $F1, $81, $42, $00 ; "へんじをかくことが　できません。"

; ---- text $5C99-$5CDE (69 bytes) [PROBABLE] text block: 4 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5C57-5CDE by higher-priority evidence]

String_72_5C99:: ; 72:5C99
	db $86, $01, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $83, $6A, $83, $62, $83, $4E, $83, $6C, $81, $5B, $83, $80, $82, $CD, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　ニックネームは　　　　　"
	db $81, $40, $81, $40, $82, $A9, $82, $C8, $82, $E7, $82, $B8, $82, $A9, $82, $A2, $82, $C4, $82, $AD, $82, $BE, $82, $B3, $82, $A2, $81, $42, $81, $40, $81, $40, $00 ; "　　かならずかいてください。　　"

; ---- text $5CDE-$5D6B (141 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_5CDE:: ; 72:5CDE
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $51, $82, $51, $82, $50, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　２２１　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $51, $82, $51, $82, $51, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　２２２　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $02, $01 ; record header

; ---- text $5D6B-$5DAD (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5D6B:: ; 72:5D6B
	db $81, $40, $82, $A9, $82, $AB, $82, $A9, $82, $AF, $82, $CC, $83, $66, $81, $5B, $83, $5E, $82, $CD, $81, $40, $82, $AB, $82, $A6, $82, $C4, $81, $40, $81, $40, $00 ; "　かきかけのデータは　きえて　　"
	db $81, $40, $82, $B5, $82, $DC, $82, $A2, $82, $DC, $82, $B7, $81, $42, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $81, $40, $00 ; "　しまいます。よろしいですか？　"

; ---- text $5DAD-$5DB0 (3 bytes) [PROBABLE] text block: 4 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5D6B-5DF2 by higher-priority evidence]

String_72_5DAD:: ; 72:5DAD
	db $86, $02, $00 ; record header

; ---- text $5DB0-$5DF2 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5DB0:: ; 72:5DB0
	db $83, $41, $83, $68, $83, $8C, $83, $58, $82, $CC, $82, $B5, $82, $E3, $82, $A4, $82, $B9, $82, $A2, $82, $F0, $82, $E2, $82, $DF, $82, $DC, $82, $B7, $81, $42, $00 ; "アドレスのしゅうせいをやめます。"
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　よろしいですか？　　　　"

; ---- text $5DF2-$5F4E (348 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_5DF2:: ; 72:5DF2
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $51, $82, $51, $82, $54, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　２２５　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $51, $82, $51, $82, $55, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　２２６　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $51, $82, $51, $82, $56, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　２２７　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $51, $82, $51, $82, $57, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　２２８　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $51, $82, $51, $82, $58, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　２２９　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $01, $01 ; record header

; ---- text $5F4E-$5F90 (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5F4E:: ; 72:5F4E
	db $82, $E0, $82, $B6, $82, $B7, $82, $A4, $82, $CC, $83, $49, $81, $5B, $83, $6F, $81, $5B, $82, $B5, $82, $BD, $83, $81, $81, $5B, $83, $8B, $82, $C5, $82, $B7, $00 ; "もじすうのオーバーしたメールです"
	db $82, $B7, $82, $D7, $82, $C4, $82, $D0, $82, $E5, $82, $A4, $82, $B6, $82, $C5, $82, $AB, $82, $DC, $82, $B9, $82, $F1, $82, $C5, $82, $B5, $82, $BD, $81, $42, $00 ; "すべてひょうじできませんでした。"

; ---- text $5F90-$5F93 (3 bytes) [PROBABLE] text block: 5 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5F4E-5FF6 by higher-priority evidence]

String_72_5F90:: ; 72:5F90
	db $86, $05, $00 ; record header

; ---- text $5F93-$5FF6 (99 bytes) [CONFIRMED] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5F93:: ; 72:5F93
	db $81, $40, $83, $81, $81, $5B, $83, $8B, $83, $7B, $83, $62, $83, $4E, $83, $58, $82, $AA, $82, $A2, $82, $C1, $82, $CF, $82, $A2, $82, $C5, $81, $40, $81, $40, $00 ; "　メールボックスがいっぱいで　　"
	db $81, $40, $81, $40, $83, $81, $81, $5B, $83, $8B, $82, $F0, $82, $A4, $82, $AF, $82, $C6, $82, $EA, $82, $DC, $82, $B9, $82, $F1, $81, $42, $81, $40, $81, $40, $00 ; "　　メールをうけとれません。　　"
	db $83, $5A, $81, $5B, $83, $75, $82, $B5, $82, $BD, $83, $81, $81, $5B, $83, $8B, $82, $F0, $82, $AF, $82, $B5, $82, $DC, $82, $B7, $82, $A9, $81, $48, $81, $40, $00 ; "セーブしたメールをけしますか？　"

; ---- text $5FF6-$603E (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_5FF6:: ; 72:5FF6
	db $86, $02, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $51, $82, $52, $82, $51, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　２３２　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $02, $00 ; record header

; ---- text $603E-$6080 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_603E:: ; 72:603E
	db $81, $40, $83, $81, $81, $5B, $83, $8B, $82, $F0, $82, $AF, $82, $B5, $82, $DC, $82, $B5, $82, $BD, $81, $42, $82, $C2, $82, $C3, $82, $AF, $82, $C4, $81, $40, $00 ; "　メールをけしました。つづけて　"
	db $81, $40, $82, $D9, $82, $A9, $82, $CC, $83, $81, $81, $5B, $83, $8B, $82, $E0, $82, $AF, $82, $B5, $82, $DC, $82, $B7, $82, $A9, $81, $48, $81, $40, $81, $40, $00 ; "　ほかのメールもけしますか？　　"

; ---- text $6080-$60E9 (105 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_6080:: ; 72:6080
	db $86, $04, $01 ; record header
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $51, $82, $52, $82, $53, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　２３４　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　　　　　"
	db $86, $02, $01 ; record header

; ---- text $60E9-$612B (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_60E9:: ; 72:60E9
	db $83, $54, $81, $5B, $83, $6F, $82, $C9, $82, $A0, $82, $E9, $83, $81, $81, $5B, $83, $8B, $82, $F0, $82, $AF, $82, $B5, $82, $DC, $82, $B7, $81, $42, $81, $40, $00 ; "サーバにあるメールをけします。　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　よろしいですか？　　　　"

; ---- text $612B-$6350 (549 bytes) [PROBABLE] text block: 22 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 60E9-63D7 by higher-priority evidence]

String_72_612B:: ; 72:612B
	db $86, $04, $01 ; record header
	db $82, $D9, $82, $A9, $82, $CC, $83, $5C, $83, $74, $83, $67, $82, $CC, $83, $81, $81, $5B, $83, $8B, $82, $AA, $82, $A0, $82, $E8, $82, $DC, $82, $B7, $81, $42, $00 ; "ほかのソフトのメールがあります。"
	db $81, $40, $82, $BD, $82, $DC, $82, $E9, $82, $C6, $81, $40, $82, $C2, $82, $A4, $82, $B5, $82, $F1, $82, $B6, $82, $A9, $82, $F1, $82, $AA, $81, $40, $81, $40, $00 ; "　たまると　つうしんじかんが　　"
	db $81, $40, $81, $40, $82, $C8, $82, $AA, $82, $AD, $82, $C8, $82, $C1, $82, $C4, $82, $B5, $82, $DC, $82, $A2, $82, $DC, $82, $B7, $81, $42, $81, $40, $81, $40, $00 ; "　　ながくなってしまいます。　　"
	db $86, $04, $01 ; record header
	db $81, $40, $81, $40, $82, $D9, $82, $A9, $82, $CC, $83, $5C, $83, $74, $83, $67, $82, $CC, $83, $81, $81, $5B, $83, $8B, $82, $AA, $81, $40, $81, $40, $81, $40, $00 ; "　　ほかのソフトのメールが　　　"
	db $81, $40, $81, $40, $82, $D3, $82, $A6, $82, $C4, $82, $AB, $82, $DC, $82, $B5, $82, $BD, $81, $42, $82, $CD, $82, $E2, $82, $DF, $82, $C9, $81, $40, $81, $40, $00 ; "　　ふえてきました。はやめに　　"
	db $81, $40, $81, $40, $82, $AF, $82, $B7, $82, $E6, $82, $A4, $82, $C9, $82, $B5, $82, $C4, $82, $AD, $82, $BE, $82, $B3, $82, $A2, $81, $40, $81, $40, $81, $40, $00 ; "　　けすようにしてください　　　"
	db $86, $04, $01 ; record header
	db $82, $D9, $82, $A9, $82, $CC, $83, $5C, $83, $74, $83, $67, $82, $CC, $83, $81, $81, $5B, $83, $8B, $82, $AA, $81, $40, $82, $BD, $82, $AD, $82, $B3, $82, $F1, $00 ; "ほかのソフトのメールが　たくさん"
	db $82, $A0, $82, $E8, $82, $DC, $82, $B7, $81, $42, $83, $81, $81, $5B, $83, $8B, $83, $54, $81, $5B, $83, $6F, $82, $AA, $82, $DF, $82, $F1, $82, $C5, $81, $40, $00 ; "あります。メールサーバがめんで　"
	db $81, $40, $81, $40, $83, $81, $81, $5B, $83, $8B, $82, $F0, $82, $AF, $82, $B5, $82, $C4, $82, $AD, $82, $BE, $82, $B3, $82, $A2, $81, $42, $81, $40, $81, $40, $00 ; "　　メールをけしてください。　　"
	db $86, $04, $01 ; record header
	db $81, $40, $83, $54, $81, $5B, $83, $6F, $82, $CC, $83, $81, $81, $5B, $83, $8B, $82, $F0, $82, $AF, $82, $B7, $82, $DC, $82, $A6, $82, $C9, $81, $40, $81, $40, $00 ; "　サーバのメールをけすまえに　　"
	db $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $B5, $82, $E5, $82, $CC, $81, $40, $82, $BF, $82, $E3, $82, $A4, $82, $A2, $82, $B6, $82, $B1, $82, $A4, $82, $F0, $00 ; "せつめいしょの　ちゅういじこうを"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $DD, $82, $C4, $82, $AD, $82, $BE, $82, $B3, $82, $A2, $81, $42, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　みてください。　　　　"
	db $86, $00, $01 ; record header
	db $81, $40, $83, $54, $81, $5B, $83, $6F, $82, $C9, $83, $81, $81, $5B, $83, $8B, $82, $CD, $82, $A0, $82, $E8, $82, $DC, $82, $B9, $82, $F1, $81, $42, $81, $40, $00 ; "　サーバにメールはありません。　"
	db $81, $40, $81, $40, $81, $40, $82, $C5, $82, $F1, $82, $ED, $82, $F0, $82, $AB, $82, $E8, $82, $DC, $82, $B7, $81, $42, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　でんわをきります。　　　　"
	db $86, $00, $01 ; record header
	db $83, $60, $83, $46, $83, $62, $83, $4E, $82, $F0, $82, $B5, $82, $E3, $82, $A4, $82, $E8, $82, $E5, $82, $A4, $82, $B5, $82, $DC, $82, $B5, $82, $BD, $81, $42, $00 ; "チェックをしゅうりょうしました。"
	db $81, $40, $81, $40, $81, $40, $82, $C5, $82, $F1, $82, $ED, $82, $F0, $82, $AB, $82, $E8, $82, $DC, $82, $B7, $81, $42, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　でんわをきります。　　　　"
	db $86, $02, $00 ; record header

; ---- text $6350-$6392 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_6350:: ; 72:6350
	db $81, $40, $81, $40, $83, $54, $81, $5B, $83, $6F, $83, $81, $81, $5B, $83, $8B, $82, $CC, $82, $B3, $82, $AD, $82, $B6, $82, $E5, $82, $F0, $81, $40, $81, $40, $00 ; "　　サーバメールのさくじょを　　"
	db $81, $40, $81, $40, $82, $E2, $82, $DF, $82, $DC, $82, $B7, $81, $42, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $81, $40, $00 ; "　　やめます。よろしいですか？　"

; ---- text $6392-$63D7 (69 bytes) [PROBABLE] text block: 22 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 60E9-63D7 by higher-priority evidence]

String_72_6392:: ; 72:6392
	db $86, $01, $01 ; record header
	db $81, $40, $82, $A8, $82, $A9, $82, $B5, $82, $C8, $83, $66, $81, $5B, $83, $5E, $82, $AA, $82, $A0, $82, $C1, $82, $BD, $82, $CC, $82, $C5, $81, $40, $81, $40, $00 ; "　おかしなデータがあったので　　"
	db $81, $40, $82, $BD, $82, $BE, $82, $B5, $82, $AD, $82, $D0, $82, $E5, $82, $A4, $82, $B6, $82, $C5, $82, $AB, $82, $DC, $82, $B9, $82, $F1, $81, $42, $81, $40, $00 ; "　ただしくひょうじできません。　"

; ---- data $63D7-$63D8 (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint) | observed: single $AF (xor a) after the string terminator at 63D6 and directly before the far-call target 72:63D8 (4E:4D10 calls 63D8, not 63D7); left unclassified

Data_72_63D7:: ; 72:63D7
	db $AF
