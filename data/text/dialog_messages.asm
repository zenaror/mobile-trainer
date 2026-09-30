; data/text/dialog_messages.asm
; bank 72, $502B-$63D8 (5037 bytes); pinned by layout.link
; dialog list table and the 69 message records

SECTION "data/text/dialog_messages", ROMX

PUSHC sjis

; ---- ptrtable $502B-$50BD (146 bytes) [PROBABLE] little-endian word table, 73 entries, monotone=0.99, 92% of targets on string start/after NUL, targets $5033..$50BD; referenced by ld r16,$502B at 72:402D

Dialog_ListTable:: ; 72:502B
Table_72_502B::
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
	dw Data_Dialog_Msg0202
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
String_72_50BD::
	db $86, $02, $01 ; record header
	db "　　　　　　　　　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $00, $01 ; record header
	db "　　　１００　　　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $00 ; record header

; ---- text $514A-$518C (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_514A:: ; 72:514A
	db "　　　　でんわを　きって　　　　", 0
	db "　　　ホームページをみます。　　", 0

; ---- text $518C-$51B0 (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0102:: ; 72:518C
String_72_518C::
	db $86, $00, $01 ; record header
	db "　　　　　　　　　　　　　　　　", 0

; ---- text $51B0-$51D1 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_51B0:: ; 72:51B0
	db "　　　でんわをきりました。　　　", 0

; ---- text $51D1-$525E (141 bytes) [PROBABLE] text block: 7 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 51B0-52A0 by higher-priority evidence]

String_Dialog_Msg0103:: ; 72:51D1
String_72_51D1::
	db $86, $02, $01 ; record header
	db "　メモリーボールをからにします。", 0
	db "　　　　よろしいですか？　　　　", 0
	db $86, $02, $01 ; record header
	db "　　セーブされているデータを　　", 0
	db "うわがきします。よろしいですか？", 0
	db $86, $02, $00 ; record header

; ---- text $525E-$52A0 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_525E:: ; 72:525E
	db "　でんわをきってホームページを　", 0
	db "　　　しゅうりょうします。　　　", 0

; ---- text $52A0-$52E8 (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0106:: ; 72:52A0
String_72_52A0::
	db $86, $02, $01 ; record header
	db "　　　　　　１０６　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $01, $01 ; record header

; ---- text $52E8-$532A (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_52E8:: ; 72:52E8
	db "　ホームページがおおきすぎて　　", 0
	db "すべてひょうじ　できませんでした", 0

; ---- text $532A-$53C5 (155 bytes) [PROBABLE] text block: 7 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 52E8-53C5 by higher-priority evidence]

String_Dialog_Msg0108:: ; 72:532A
String_72_532A::
	db $86, $02, $01 ; record header
	db "　ページのないようをけします。　", 0
	db "　　　　よろしいですか？　　　　", 0
	db $86, $02, $01 ; record header
	db "　　セーブされているデータを　　", 0
	db "うわがきします。よろしいですか？", 0
	db $86, $01, $01 ; record header
	db "　　　じかんが"

; ---- text $53C5-$53D8 (19 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_53C5:: ; 72:53C5
	db $F9, "D", $F9, "D", $F9, "D", $F9, "D", $F9, "Dふん　　", 0

; ---- text $53D8-$53F9 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_53D8:: ; 72:53D8
	db "　　　　　をこえました。　　　　", 0

; ---- text $53F9-$541D (36 bytes) [PROBABLE] text block: 2 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 53D8-541D by higher-priority evidence]

String_Dialog_Msg010B:: ; 72:53F9
String_72_53F9::
	db $86, $01, $01 ; record header
	db "　　　でんわをきりました。　　　", 0

; ---- text $541D-$5441 (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_541D:: ; 72:541D
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $01, $01 ; record header

; ---- text $5441-$5483 (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5441:: ; 72:5441
	db "　ホームページがおおきすぎて　　", 0
	db "すべてひょうじ　できませんでした", 0

; ---- text $5483-$54A7 (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg010D:: ; 72:5483
String_72_5483::
	db $86, $00, $01 ; record header
	db "　　　　　　　　　　　　　　　　", 0

; ---- text $54A7-$54C8 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_54A7:: ; 72:54A7
	db "　　　でんわをきっています。　　", 0

; ---- text $54C8-$54EC (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg010E:: ; 72:54C8
String_72_54C8::
	db $86, $00, $01 ; record header
	db "　　　　　　　　　　　　　　　　", 0

; ---- text $54EC-$550D (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_54EC:: ; 72:54EC
	db "　　　でんわがきれました。　　　", 0

; ---- text $550D-$5531 (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg010F:: ; 72:550D
String_72_550D::
	db $86, $00, $01 ; record header
	db "　　　　　　　　　　　　　　　　", 0

; ---- text $5531-$5552 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5531:: ; 72:5531
	db "　　　でんわをきっています。　　", 0

; ---- text $5552-$5576 (36 bytes) [PROBABLE] text block: 2 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5531-5576 by higher-priority evidence]

String_Dialog_Msg0110:: ; 72:5552
String_72_5552::
	db $86, $01, $01 ; record header
	db "　　　でんわがきれました。　　　", 0

; ---- text $5576-$559A (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_72_5576:: ; 72:5576
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $00 ; record header

; ---- text $559A-$55DC (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_559A:: ; 72:559A
	db "つうしんせつぞくを　つづけます。", 0
	db "　　　　よろしいですか？　　　　", 0

; ---- text $55DC-$5600 (36 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0112:: ; 72:55DC
String_72_55DC::
	db $86, $00, $01 ; record header
	db "　　　　　　　　　　　　　　　　", 0

; ---- text $5600-$5621 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5600:: ; 72:5600
	db "　もどれるページが　ありません。", 0

; ---- text $5621-$5645 (36 bytes) [PROBABLE] text block: 2 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5600-5645 by higher-priority evidence]

String_Dialog_Msg0113:: ; 72:5621
String_72_5621::
	db $86, $01, $01 ; record header
	db "　もどれるページが　ありません。", 0

; ---- data $5645-$5666 (33 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 5621-5666 by higher-priority evidence]

Data_72_5645:: ; 72:5645
	db "　　　　　　　　　　　　　　　　", 0

; ---- text $5666-$5669 (3 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0114:: ; 72:5666
String_72_5666::
	db $86, $02, $00 ; record header

; ---- text $5669-$56AB (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5669:: ; 72:5669
	db "　　　　ホームページを　　　　　", 0
	db "　　　しゅうりょうします。　　　", 0

; ---- text $56AB-$56AE (3 bytes) [PROBABLE] text block: 8 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5669-577A by higher-priority evidence]

String_Dialog_Msg0115:: ; 72:56AB
String_72_56AB::
	db $86, $00, $00 ; record header

; ---- text $56AE-$56F0 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_56AE:: ; 72:56AE
	db "　　ホームページをただしく　　　", 0
	db "　　ひょうじできませんでした。　", 0

; ---- text $56F0-$56F3 (3 bytes) [PROBABLE] text block: 8 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5669-577A by higher-priority evidence]

String_Dialog_Msg0116:: ; 72:56F0
String_72_56F0::
	db $86, $01, $00 ; record header

; ---- text $56F3-$5735 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_56F3:: ; 72:56F3
	db "　　ホームページをただしく　　　", 0
	db "　　ひょうじできませんでした。　", 0

; ---- text $5735-$577A (69 bytes) [PROBABLE] text block: 8 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5669-577A by higher-priority evidence]

String_Dialog_Msg0200:: ; 72:5735
String_72_5735::
	db $86, $02, $01 ; record header
	db "　かきかけのメールは　きえて　　", 0
	db "　しまいます。よろしいですか？　", 0

; ---- text $577A-$57BF (69 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0201:: ; 72:577A
String_72_577A::
	db $86, $02, $01 ; record header
	db "　　　　　２０１　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0

; ---- data $57BF-$57C2 (3 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 57BF-5804 by higher-priority evidence]

Data_Dialog_Msg0202:: ; 72:57BF
Data_72_57BF::
	db $86, $02, $00

; ---- text $57C2-$5804 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_57C2:: ; 72:57C2
	db "　かいたメールを　セーブします。", 0
	db "　　　　よろしいですか？　　　　", 0

; ---- text $5804-$5891 (141 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0203:: ; 72:5804
String_72_5804::
	db $86, $02, $01 ; record header
	db "　　　　　２０３　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $01 ; record header
	db "　　　　　２０４　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $01, $01 ; record header

; ---- text $5891-$58D3 (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5891:: ; 72:5891
	db "　　　　メールアドレスは　　　　", 0
	db "　　かならずかいてください。　　", 0

; ---- text $58D3-$5918 (69 bytes) [PROBABLE] text block: 4 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5891-5918 by higher-priority evidence]

String_Dialog_Msg0206:: ; 72:58D3
String_72_58D3::
	db $86, $02, $01 ; record header
	db "　もらったメールを　けします。　", 0
	db "　　　　よろしいですか？　　　　", 0

; ---- text $5918-$5960 (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0207:: ; 72:5918
String_72_5918::
	db $86, $02, $01 ; record header
	db "　　　　　２０７　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $01 ; record header

; ---- text $5960-$59A2 (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5960:: ; 72:5960
	db "　　　　メールアドレスを　　　　", 0
	db "うわがきします　よろしいですか？", 0

; ---- text $59A2-$59E7 (69 bytes) [PROBABLE] text block: 4 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5960-59E7 by higher-priority evidence]

String_Dialog_Msg0209:: ; 72:59A2
String_72_59A2::
	db $86, $02, $01 ; record header
	db "　　かいたメールを　けします。　", 0
	db "　　　　よろしいですか？　　　　", 0

; ---- text $59E7-$5A2F (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg020A:: ; 72:59E7
String_72_59E7::
	db $86, $02, $01 ; record header
	db "　　　　　２１０　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $00 ; record header

; ---- text $5A2F-$5A71 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5A2F:: ; 72:5A2F
	db "メールアドレスを　セーブします。", 0
	db "　　　　よろしいですか？　　　　", 0

; ---- text $5A71-$5AB9 (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg020C:: ; 72:5A71
String_72_5A71::
	db $86, $02, $01 ; record header
	db "　　　　　２０３　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $01 ; record header

; ---- text $5AB9-$5AFB (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5AB9:: ; 72:5AB9
	db "　メールアドレスを　けします。　", 0
	db "　　　　よろしいですか？　　　　", 0

; ---- text $5AFB-$5B43 (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg020E:: ; 72:5AFB
String_72_5AFB::
	db $86, $02, $01 ; record header
	db "　　　　　２１４　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $01 ; record header

; ---- text $5B43-$5B85 (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5B43:: ; 72:5B43
	db "　かきかけのへんじは　きえて　　", 0
	db "　しまいます。よろしいですか？　", 0

; ---- text $5B85-$5BCD (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0210:: ; 72:5B85
String_72_5B85::
	db $86, $02, $01 ; record header
	db "　　　　　２０６　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $00 ; record header

; ---- text $5BCD-$5C0F (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5BCD:: ; 72:5BCD
	db "　メールのしゅうせいをやめます。", 0
	db "　　　　よろしいですか？　　　　", 0

; ---- text $5C0F-$5C57 (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0212:: ; 72:5C0F
String_72_5C0F::
	db $86, $02, $01 ; record header
	db "　　　　　２１８　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $01, $01 ; record header

; ---- text $5C57-$5C99 (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5C57:: ; 72:5C57
	db "おくっていないメールがあります。", 0
	db "へんじをかくことが　できません。", 0

; ---- text $5C99-$5CDE (69 bytes) [PROBABLE] text block: 4 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5C57-5CDE by higher-priority evidence]

String_Dialog_Msg0214:: ; 72:5C99
String_72_5C99::
	db $86, $01, $01 ; record header
	db "　　　　ニックネームは　　　　　", 0
	db "　　かならずかいてください。　　", 0

; ---- text $5CDE-$5D6B (141 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0215:: ; 72:5CDE
String_72_5CDE::
	db $86, $02, $01 ; record header
	db "　　　　　２２１　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $01 ; record header
	db "　　　　　２２２　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $01 ; record header

; ---- text $5D6B-$5DAD (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5D6B:: ; 72:5D6B
	db "　かきかけのデータは　きえて　　", 0
	db "　しまいます。よろしいですか？　", 0

; ---- text $5DAD-$5DB0 (3 bytes) [PROBABLE] text block: 4 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5D6B-5DF2 by higher-priority evidence]

String_Dialog_Msg0218:: ; 72:5DAD
String_72_5DAD::
	db $86, $02, $00 ; record header

; ---- text $5DB0-$5DF2 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5DB0:: ; 72:5DB0
	db "アドレスのしゅうせいをやめます。", 0
	db "　　　　よろしいですか？　　　　", 0

; ---- text $5DF2-$5F4E (348 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0219:: ; 72:5DF2
String_72_5DF2::
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

String_72_5F4E:: ; 72:5F4E
	db "もじすうのオーバーしたメールです", 0
	db "すべてひょうじできませんでした。", 0

; ---- text $5F90-$5F93 (3 bytes) [PROBABLE] text block: 5 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 5F4E-5FF6 by higher-priority evidence]

String_Dialog_Msg021F:: ; 72:5F90
String_72_5F90::
	db $86, $05, $00 ; record header

; ---- text $5F93-$5FF6 (99 bytes) [CONFIRMED] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_5F93:: ; 72:5F93
	db "　メールボックスがいっぱいで　　", 0
	db "　　メールをうけとれません。　　", 0
	db "セーブしたメールをけしますか？　", 0

; ---- text $5FF6-$603E (72 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0220:: ; 72:5FF6
String_72_5FF6::
	db $86, $02, $01 ; record header
	db "　　　　　２３２　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $00 ; record header

; ---- text $603E-$6080 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_603E:: ; 72:603E
	db "　メールをけしました。つづけて　", 0
	db "　ほかのメールもけしますか？　　", 0

; ---- text $6080-$60E9 (105 bytes) [PROBABLE] message records of the 72:502B pointer table: 86 aa bb header + 32-byte line + 00 (+ second/third 32-byte line + 00); the record starts are table targets (dw at 72:5033-50A9...), whole span decodes as cp932 (full-width spaces/digits, header 86 aa bb, NULs) per docs/research/text_encoding.md section on bank 72 records; ends with the 86 header of the next record

String_Dialog_Msg0222:: ; 72:6080
String_72_6080::
	db $86, $04, $01 ; record header
	db "　　　　　　２３４　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db "　　　　　　　　　　　　　　　　", 0
	db $86, $02, $01 ; record header

; ---- text $60E9-$612B (66 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_60E9:: ; 72:60E9
	db "サーバにあるメールをけします。　", 0
	db "　　　　よろしいですか？　　　　", 0

; ---- text $612B-$6350 (549 bytes) [PROBABLE] text block: 22 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 60E9-63D7 by higher-priority evidence]

String_Dialog_Msg0224:: ; 72:612B
String_72_612B::
	db $86, $04, $01 ; record header
	db "ほかのソフトのメールがあります。", 0
	db "　たまると　つうしんじかんが　　", 0
	db "　　ながくなってしまいます。　　", 0
	db $86, $04, $01 ; record header
	db "　　ほかのソフトのメールが　　　", 0
	db "　　ふえてきました。はやめに　　", 0
	db "　　けすようにしてください　　　", 0
	db $86, $04, $01 ; record header
	db "ほかのソフトのメールが　たくさん", 0
	db "あります。メールサーバがめんで　", 0
	db "　　メールをけしてください。　　", 0
	db $86, $04, $01 ; record header
	db "　サーバのメールをけすまえに　　", 0
	db "せつめいしょの　ちゅういじこうを", 0
	db "　　　　　みてください。　　　　", 0
	db $86, $00, $01 ; record header
	db "　サーバにメールはありません。　", 0
	db "　　　でんわをきります。　　　　", 0
	db $86, $00, $01 ; record header
	db "チェックをしゅうりょうしました。", 0
	db "　　　でんわをきります。　　　　", 0
	db $86, $02, $00 ; record header

; ---- text $6350-$6392 (66 bytes) [CONFIRMED] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_72_6350:: ; 72:6350
	db "　　サーバメールのさくじょを　　", 0
	db "　　やめます。よろしいですか？　", 0

; ---- text $6392-$63D7 (69 bytes) [PROBABLE] text block: 22 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 60E9-63D7 by higher-priority evidence]

String_Dialog_Msg022B:: ; 72:6392
String_72_6392::
	db $86, $01, $01 ; record header
	db "　おかしなデータがあったので　　", 0
	db "　ただしくひょうじできません。　", 0

; ---- data $63D7-$63D8 (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint) | observed: single $AF (xor a) after the string terminator at 63D6 and directly before the far-call target 72:63D8 (4E:4D10 calls 63D8, not 63D7); left unclassified

Data_72_63D7:: ; 72:63D7
	db $AF

POPC
