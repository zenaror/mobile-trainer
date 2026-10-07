; data/text/browser_start_ticker.asm
; bank 73, $4000-$4097 (151 bytes); pinned by layout.link
; ticker table and strings of the browser start menu

SECTION "data/text/browser_start_ticker", ROMX

PUSHC sjis

; ---- data $4000-$4001 (1 bytes) [CONFIRMED] text-ROM bank field: 73:62CB -> Ticker_Start 48:42D4 -> ReadByteFar; stored in wTickerTextBank ($C0EB); byte read in 19 whole/19 union natural scenarios (typing_73_browser_remaining.md); unchanged bank byte also valid for English relocated label; original JP natural-read evidence; English text runtime UNVALIDATED.

Data_BrowserStart_StringIndexBank:: ; 73:4000
Data_73_4000::
	db BANK(BrowserStart_Strings)

; ---- ptrtable $4001-$4009 (8 bytes) [CONFIRMED] original-ROM format: two title/body pointer pairs in ROM bank 73
; Original natural reads: 73:62C6 -> 48:42D4, stride 4; 8 whole / 19 union scenarios; no universal index clamp. English first title: 73:7FED, same format/bank; English runtime UNVALIDATED.
BrowserStart_StringTable:: ; 73:4001
Table_73_4001::
	dw BrowserStart_Strings
	dw $4016
	dw $4065
	dw $4072

; ---- text $4009-$4097 (142 bytes) [PROBABLE] English layout: original 13-byte title slot padding and three JP strings; relocated title at 73:7FED.
; Original JP four NUL strings (13/79/13/37), 69 glyphs: 8 whole / 19 union natural reads [CONFIRMED]; English runtime UNVALIDATED.
	; Original 13-byte title slot retained after relocation.
	ds 13, 0
	db "インターネットをつかって　にんてんどうモバイルホームページをみることができます", 0
	db "ページリスト", 0
	db "ページリストを　つかうことができます", 0

POPC
