; data/text/help_menu_ticker.asm
; bank 6A, $64B1-$6716 (613 bytes); pinned by layout.link
; ticker tables and strings of the help menu (read through the bank 48 ticker)

SECTION "data/text/help_menu_ticker", ROMX

; ---- ptrtable $64B1-$64D3 (34 bytes) [PROBABLE] little-endian word table, 17 entries, monotone=0.94, 94% of targets on string start/after NUL, targets $6A64..$6630

Table_6A_64B1:: ; 6A:64B1
	dw $6A64
	dw String_6A_64D3
	dw $64E6
	dw $650B
	dw $6518
	dw $6533
	dw $6546
	dw $6567
	dw $6576
	dw Data_6A_65A1
	dw String_6A_65A8
	dw $65C3
	dw $65D2
	dw $65F5
	dw $6602
	dw $6623
	dw $6630

; ---- text $64D3-$65A1 (206 bytes) [PROBABLE] text: 8 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_6A_64D3:: ; 6A:64D3
	db $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $67, $83, $8C, $81, $5B, $83, $69, $81, $5B, $00 ; "モバイルトレーナー"
	db $82, $B1, $82, $CC, $83, $4A, $81, $5B, $83, $67, $83, $8A, $83, $62, $83, $57, $82, $CC, $81, $40, $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82, $DC ; "このカートリッジの　せつめいをしま"
	db $82, $B7, $00 ; "す"
	db $83, $81, $81, $5B, $83, $8B, $82, $C1, $82, $C4, $81, $48, $00 ; "メールって？"
	db $83, $81, $81, $5B, $83, $8B, $82, $CC, $81, $40, $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82, $DC, $82, $B7, $00 ; "メールの　せつめいをします"
	db $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $82, $C1, $82, $C4, $81, $48, $00 ; "ホームページって？"
	db $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $82, $CC, $81, $40, $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82, $DC, $82, $B7, $00 ; "ホームページの　せつめいをします"
	db $83, $82, $83, $6F, $83, $43, $83, $8B, $82, $B6, $82, $C4, $82, $F1, $00 ; "モバイルじてん"
	db $82, $ED, $82, $A9, $82, $E7, $82, $C8, $82, $A2, $82, $B1, $82, $C6, $82, $CE, $82, $F0, $81, $40, $82, $B5, $82, $E7, $82, $D7, $82, $E9, $82, $B1, $82, $C6, $82, $AA ; "わからないことばを　しらべることが"
	db $82, $C5, $82, $AB, $82, $DC, $82, $B7, $00 ; "できます"

; ---- data $65A1-$65A8 (7 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 6567-65F5 by higher-priority evidence]

Data_6A_65A1:: ; 6A:65A1
	db $83, $81, $81, $5B, $83, $8B, $00

; ---- text $65A8-$6651 (169 bytes) [PROBABLE] text: 7 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_6A_65A8:: ; 6A:65A8
	db $83, $81, $81, $5B, $83, $8B, $82, $CC, $81, $40, $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82, $DC, $82, $B7, $00 ; "メールの　せつめいをします"
	db $83, $41, $83, $68, $83, $8C, $83, $58, $82, $BF, $82, $E5, $82, $A4, $00 ; "アドレスちょう"
	db $83, $41, $83, $68, $83, $8C, $83, $58, $82, $BF, $82, $E5, $82, $A4, $82, $CC, $81, $40, $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82, $DC, $82, $B7 ; "アドレスちょうの　せつめいをします"
	db $00 ; ""
	db $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $00 ; "ホームページ"
	db $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $82, $CC, $81, $40, $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82, $DC, $82, $B7, $00 ; "ホームページの　せつめいをします"
	db $83, $79, $81, $5B, $83, $57, $83, $8A, $83, $58, $83, $67, $00 ; "ページリスト"
	db $83, $79, $81, $5B, $83, $57, $83, $8A, $83, $58, $83, $67, $82, $CC, $81, $40, $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82, $DC, $82, $B7, $00 ; "ページリストの　せつめいをします"

; ---- data $6651-$6652 (1 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown

Data_6A_6651:: ; 6A:6651
	db $6A

; ---- words $6652-$665E (12 bytes) [PROBABLE] 3 x 4-byte entries: [0000 0000] [6672 667B] [6696 669F]; entry = pair of pointers to two NUL-terminated Shift-JIS strings (title/label) in 6A:6672-66F5; 6651 byte 6A read separately

Table_6A_6652:: ; 6A:6652
	dw $0000, $0000, String_6A_6672, String_6A_667B, String_6A_6696, String_6A_669F

; ---- words $665E-$666A (12 bytes) [PROBABLE] 3 x 4-byte entries: [0000 0000] [0000 0000] [66C0 66C9]; pair of string pointers (see 6A:6652) [v4: bytes 6666-666A were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_6A_665E:: ; 6A:665E
	dw $0000, $0000, $0000, $0000, String_6A_66C0, String_6A_66C9

; ---- words $666A-$6672 (8 bytes) [PROBABLE] 2 x 4-byte entries: [0000 0000] [66EC 66F5]; pair of string pointers (see 6A:6652)

Table_6A_666A:: ; 6A:666A
	dw $0000, $0000, String_6A_66EC, String_6A_66F5

; ---- text $6672-$667B (9 bytes) [PROBABLE] NUL-terminated Shift-JIS string pointed to by a word of the 6A:6652-6672 tables; 4 x 81 48 (full-width ?) placeholder

String_6A_6672:: ; 6A:6672
	db $81, $48, $81, $48, $81, $48, $81, $48, $00 ; "？？？？"

; ---- text $667B-$6696 (27 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_6A_667B:: ; 6A:667B
	db $81, $48, $81, $48, $81, $48, $82, $CC, $81, $40, $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82, $DC, $82, $B7, $00 ; "？？？の　せつめいをします"

; ---- text $6696-$669F (9 bytes) [PROBABLE] NUL-terminated Shift-JIS string pointed to by a word of the 6A:6652-6672 tables; 4 x 81 48 (full-width ?) placeholder [v4: bytes 6696-669F were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

String_6A_6696:: ; 6A:6696
	db $81, $48, $81, $48, $81, $48, $81, $48, $00 ; "？？？？"

; ---- text $669F-$66C0 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_6A_669F:: ; 6A:669F
	db $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $82, $CC, $81, $40, $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82, $DC, $82, $B7, $00 ; "？？？？？？の　せつめいをします"

; ---- text $66C0-$66C9 (9 bytes) [PROBABLE] NUL-terminated Shift-JIS string pointed to by a word of the 6A:6652-6672 tables; 4 x 81 48 (full-width ?) placeholder [v4: bytes 66C0-66C9 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

String_6A_66C0:: ; 6A:66C0
	db $81, $48, $81, $48, $81, $48, $81, $48, $00 ; "？？？？"

; ---- text $66C9-$66EC (35 bytes) [PROBABLE] NUL-terminated Shift-JIS string pointed to by a word of the 6A:6652-6672 tables; text after the placeholder [v4: bytes 66C9-66EC were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

String_6A_66C9:: ; 6A:66C9
	db $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $82, $CC, $81, $40, $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82, $DC, $82, $B7 ; "？？？？？？？の　せつめいをします"
	db $00 ; ""

; ---- text $66EC-$66F5 (9 bytes) [PROBABLE] NUL-terminated Shift-JIS string pointed to by a word of the 6A:6652-6672 tables; 4 x 81 48 (full-width ?) placeholder

String_6A_66EC:: ; 6A:66EC
	db $81, $48, $81, $48, $81, $48, $81, $48, $00 ; "？？？？"

; ---- text $66F5-$6716 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_6A_66F5:: ; 6A:66F5
	db $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $82, $CC, $81, $40, $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82, $DC, $82, $B7, $00 ; "？？？？？？の　せつめいをします"
