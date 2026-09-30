; data/text/browser_start_ticker.asm
; bank 73, $4000-$4097 (151 bytes); pinned by layout.link
; ticker table and strings of the browser start menu

SECTION "data/text/browser_start_ticker", ROMX

PUSHC sjis

; ---- data $4000-$4001 (1 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_BrowserStart_StringIndexBank:: ; 73:4000
Data_73_4000::
	db $73

; ---- ptrtable $4001-$4009 (8 bytes) [PROBABLE] 4 pointers, every target is the first byte of one of the 4 NUL-terminated Shift-JIS strings of String_73_4009; byte 4000 = $73 (own bank number) precedes the table; caller 73:62C6 ld hl,$4000 ; ld a,$73

BrowserStart_StringTable:: ; 73:4001
Table_73_4001::
	dw BrowserStart_Strings
	dw $4016
	dw $4065
	dw $4072

; ---- text $4009-$4097 (142 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

BrowserStart_Strings:: ; 73:4009
String_73_4009::
	db "ホームページ", 0
	db "インターネットをつかって　にんてんどうモバイルホームページをみることができます", 0
	db "ページリスト", 0
	db "ページリストを　つかうことができます", 0

POPC
