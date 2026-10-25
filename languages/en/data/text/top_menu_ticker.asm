; data/text/top_menu_ticker.asm
; bank 1E, $4000-$40D7 (215 bytes); pinned by layout.link
; Built-in English interface strings and pointer tables; unused original allocation bytes are retained.

SECTION "data/text/top_menu_ticker", ROMX

PUSHC sjis

Data_TopMenu_StringIndexBank:: ; 1E:4000
; Retained original storage bytes; outside the selected live string extents.
	db $1E
Table_TopMenu_Strings:: ; 1E:4001
	dw String_TopMenu_Title0
	dw String_TopMenu_Text0
	dw String_TopMenu_Title1
	dw String_TopMenu_Text1
	dw String_TopMenu_Title2
	dw String_TopMenu_Text2
; Retained original storage bytes; outside the selected live string extents.
	db $83, $81, $81, $5B, $83, $8B, $00, $83, $81, $81, $5B, $83, $8B, $82, $F0, $82
	db $A9, $82, $A2, $82, $BD, $82, $E8, $81, $40, $82, $BB, $82, $A4, $82, $B5, $82
	db $F1, $82, $C6, $82, $B6, $82, $E3, $82, $B5, $82, $F1, $82, $AA, $82, $C5, $82
	db $AB, $82, $DC, $82, $B7, $00, $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B
	db $83, $57, $00
String_TopMenu_Text1:: ; 1E:4050
	db "Ｖｉｅｗ　Ｎｉｎｔｅｎｄｏ’ｓ　Ｍｏｂｉｌｅ　Ｈｏｍｅ　Ｐａｇｅ　ｏｎｌｉｎｅ", 0
; Retained original storage bytes; outside the selected live string extents.
	db $83, $77, $83, $8B, $83, $76, $00, $82, $B1, $82, $CC, $83, $4A, $81, $5B, $83
	db $67, $83, $8A, $83, $62, $83, $57, $82, $CC, $82, $B9, $82, $C2, $82, $DF, $82
	db $A2, $82, $F0, $81, $40, $82, $DD, $82, $E9, $82, $B1, $82, $C6, $82, $AA, $82
	db $C5, $82, $AB, $82, $DC, $82, $B7, $00

POPC

; ---- text $7F5B-$7FA4 (73 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/top_menu_ticker/english/String_TopMenu_Text2", ROMX[$7F5B], BANK[$1E]
PUSHC sjis
String_TopMenu_Text2:: ; 1E:7F5B
	db "Ｖｉｅｗ　ｉｎｓｔｒｕｃｔｉｏｎｓ　ｆｏｒ　ｔｈｉｓ　ｃａｒｔｒｉｄｇｅ", 0
POPC

; ---- text $7FA4-$7FAD (9 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/top_menu_ticker/english/String_TopMenu_Title2", ROMX[$7FA4], BANK[$1E]
PUSHC sjis
String_TopMenu_Title2:: ; 1E:7FA4
	db "Ｈｅｌｐ", 0
POPC

; ---- text $7FAD-$7FC0 (19 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/top_menu_ticker/english/String_TopMenu_Title1", ROMX[$7FAD], BANK[$1E]
PUSHC sjis
String_TopMenu_Title1:: ; 1E:7FAD
	db "Ｈｏｍｅ　Ｐａｇｅ", 0
POPC

; ---- text $7FC0-$7FF5 (53 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/top_menu_ticker/english/String_TopMenu_Text0", ROMX[$7FC0], BANK[$1E]
PUSHC sjis
String_TopMenu_Text0:: ; 1E:7FC0
	db "Ｃｏｍｐｏｓｅ　ａｎｄ　ｔｒａｎｓｆｅｒ　ｅｍａｉｌ", 0
POPC

; ---- text $7FF5-$8000 (11 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/top_menu_ticker/english/String_TopMenu_Title0", ROMX[$7FF5], BANK[$1E]
PUSHC sjis
String_TopMenu_Title0:: ; 1E:7FF5
	db "Ｅｍａｉｌ", 0
POPC
