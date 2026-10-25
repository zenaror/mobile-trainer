; data/text/browser_start_ticker.asm
; bank 73, $4000-$4097 (151 bytes); pinned by layout.link
; Built-in English interface strings and pointer tables; unused original allocation bytes are retained.

SECTION "data/text/browser_start_ticker", ROMX

PUSHC sjis

Data_BrowserStart_StringIndexBank:: ; 73:4000
; Retained original storage bytes; outside the selected live string extents.
	db $73
BrowserStart_StringTable:: ; 73:4001
	dw BrowserStart_Strings
	dw BrowserStart_TickerBody0
	dw BrowserStart_TickerTitle1
	dw BrowserStart_TickerBody1
; Retained original storage bytes; outside the selected live string extents.
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
BrowserStart_TickerBody0:: ; 73:4016
	db "Ｖｉｅｗ　Ｎｉｎｔｅｎｄｏ’ｓ　Ｍｏｂｉｌｅ　Ｈｏｍｅ　Ｐａｇｅ　ｏｎｌｉｎｅ", 0
; Retained original storage bytes; outside the selected live string extents.
	db $83, $79, $81, $5B, $83, $57, $83, $8A, $83, $58, $83, $67, $00, $83, $79, $81
	db $5B, $83, $57, $83, $8A, $83, $58, $83, $67, $82, $F0, $81, $40, $82, $C2, $82
	db $A9, $82, $A4, $82, $B1, $82, $C6, $82, $AA, $82, $C5, $82, $AB, $82, $DC, $82
	db $B7, $00

POPC

; ---- text $7FB1-$7FDA (41 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/browser_start_ticker/english/BrowserStart_TickerBody1", ROMX[$7FB1], BANK[$73]
PUSHC sjis
BrowserStart_TickerBody1:: ; 73:7FB1
	db "Ａｃｃｅｓｓ　ｂｏｏｋｍａｒｋ　ｌｉｓｔ", 0
POPC

; ---- text $7FDA-$7FED (19 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/browser_start_ticker/english/BrowserStart_TickerTitle1", ROMX[$7FDA], BANK[$73]
PUSHC sjis
BrowserStart_TickerTitle1:: ; 73:7FDA
	db "Ｂｏｏｋｍａｒｋｓ", 0
POPC
