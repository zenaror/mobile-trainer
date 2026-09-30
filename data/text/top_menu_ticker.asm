; data/text/top_menu_ticker.asm
; bank 1E, $4000-$40D7 (215 bytes); pinned by layout.link
; ticker table and strings of the top menu (read through the bank 48 ticker)

SECTION "data/text/top_menu_ticker", ROMX

PUSHC sjis

; ---- data $4000-$4001 (1 bytes) [CONFIRMED] read as data by executed code (in up to 11/18 scenarios); content class unknown [clipped from 4000-4735 by higher-priority evidence]

Data_1E_4000:: ; 1E:4000
	db $1E

; ---- ptrtable $4001-$400D (12 bytes) [PROBABLE] little-endian word table, 6 entries, monotone=1.00, 100% of targets on string start/after NUL, targets $400D..$40A6

Table_1E_4001:: ; 1E:4001
	dw Data_1E_400D
	dw String_1E_4014
	dw $4043
	dw $4050
	dw Data_1E_409F
	dw String_1E_40A6

; ---- data $400D-$4014 (7 bytes) [CONFIRMED] read as data by executed code (in up to 11/18 scenarios); content class unknown [clipped from 4000-4735 by higher-priority evidence]

Data_1E_400D:: ; 1E:400D
	db "メール", 0

; ---- text $4014-$409F (139 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_1E_4014:: ; 1E:4014
	db "メールをかいたり　そうしんとじゅしんができます", 0
	db "ホームページ", 0
	db "インターネットをつかって　にんてんどうモバイルホームページをみることができます", 0

; ---- data $409F-$40A6 (7 bytes) [CONFIRMED] read as data by executed code (in up to 11/18 scenarios); content class unknown [clipped from 4000-4735 by higher-priority evidence]

Data_1E_409F:: ; 1E:409F
	db "ヘルプ", 0

; ---- text $40A6-$40D7 (49 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_1E_40A6:: ; 1E:40A6
	db "このカートリッジのせつめいを　みることができます", 0

POPC
