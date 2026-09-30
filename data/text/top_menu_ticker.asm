; data/text/top_menu_ticker.asm
; bank 1E, $4000-$40D7 (215 bytes); pinned by layout.link
; ticker table and strings of the top menu (read through the bank 48 ticker)

SECTION "data/text/top_menu_ticker", ROMX

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
	db $83, $81, $81, $5B, $83, $8B, $00

; ---- text $4014-$409F (139 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_1E_4014:: ; 1E:4014
	db $83, $81, $81, $5B, $83, $8B, $82, $F0, $82, $A9, $82, $A2, $82, $BD, $82, $E8, $81, $40, $82, $BB, $82, $A4, $82, $B5, $82, $F1, $82, $C6, $82, $B6, $82, $E3, $82, $B5 ; "メールをかいたり　そうしんとじゅし"
	db $82, $F1, $82, $AA, $82, $C5, $82, $AB, $82, $DC, $82, $B7, $00 ; "んができます"
	db $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $00 ; "ホームページ"
	db $83, $43, $83, $93, $83, $5E, $81, $5B, $83, $6C, $83, $62, $83, $67, $82, $F0, $82, $C2, $82, $A9, $82, $C1, $82, $C4, $81, $40, $82, $C9, $82, $F1, $82, $C4, $82, $F1 ; "インターネットをつかって　にんてん"
	db $82, $C7, $82, $A4, $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $82, $F0, $82, $DD, $82, $E9, $82, $B1, $82, $C6 ; "どうモバイルホームページをみること"
	db $82, $AA, $82, $C5, $82, $AB, $82, $DC, $82, $B7, $00 ; "ができます"

; ---- data $409F-$40A6 (7 bytes) [CONFIRMED] read as data by executed code (in up to 11/18 scenarios); content class unknown [clipped from 4000-4735 by higher-priority evidence]

Data_1E_409F:: ; 1E:409F
	db $83, $77, $83, $8B, $83, $76, $00

; ---- text $40A6-$40D7 (49 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_1E_40A6:: ; 1E:40A6
	db $82, $B1, $82, $CC, $83, $4A, $81, $5B, $83, $67, $83, $8A, $83, $62, $83, $57, $82, $CC, $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $81, $40, $82, $DD, $82, $E9 ; "このカートリッジのせつめいを　みる"
	db $82, $B1, $82, $C6, $82, $AA, $82, $C5, $82, $AB, $82, $DC, $82, $B7, $00 ; "ことができます"
