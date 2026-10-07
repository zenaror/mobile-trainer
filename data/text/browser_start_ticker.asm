; data/text/browser_start_ticker.asm
; bank 73, $4000-$4097 (151 bytes); pinned by layout.link
; ticker table and strings of the browser start menu

SECTION "data/text/browser_start_ticker", ROMX

PUSHC sjis

; ---- data $4000-$4001 (1 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_BrowserStart_StringIndexBank:: ; 73:4000
Data_73_4000::
	db $73

; ---- ptrtable $4001-$4009 (8 bytes) [CONFIRMED] two title/body pointer pairs in ROM bank 73
; 73:62C6 -> 48:42D4, stride 4; reads: 8 whole / 19 union scenarios; no universal index clamp.
BrowserStart_StringTable:: ; 73:4001
Table_73_4001::
	dw BrowserStart_Strings
	dw $4016
	dw $4065
	dw $4072

; ---- text $4009-$4097 (142 bytes) [CONFIRMED] four original JP Shift-JIS strings, NUL terminated
; Original JP: sizes 13/79/13/37 including NUL; reads: 8 whole / 19 union scenarios.
BrowserStart_Strings:: ; 73:4009
String_73_4009::
	db "ホームページ", 0
	db "インターネットをつかって　にんてんどうモバイルホームページをみることができます", 0
	db "ページリスト", 0
	db "ページリストを　つかうことができます", 0

POPC
