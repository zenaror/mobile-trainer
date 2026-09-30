; data/text/browser_start_ticker.asm
; bank 73, $4000-$4097 (151 bytes); pinned by layout.link
; ticker table and strings of the browser start menu

SECTION "data/text/browser_start_ticker", ROMX

; ---- data $4000-$4001 (1 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_73_4000:: ; 73:4000
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
	db $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $00 ; "ホームページ"
	db $83, $43, $83, $93, $83, $5E, $81, $5B, $83, $6C, $83, $62, $83, $67, $82, $F0, $82, $C2, $82, $A9, $82, $C1, $82, $C4, $81, $40, $82, $C9, $82, $F1, $82, $C4, $82, $F1 ; "インターネットをつかって　にんてん"
	db $82, $C7, $82, $A4, $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $82, $F0, $82, $DD, $82, $E9, $82, $B1, $82, $C6 ; "どうモバイルホームページをみること"
	db $82, $AA, $82, $C5, $82, $AB, $82, $DC, $82, $B7, $00 ; "ができます"
	db $83, $79, $81, $5B, $83, $57, $83, $8A, $83, $58, $83, $67, $00 ; "ページリスト"
	db $83, $79, $81, $5B, $83, $57, $83, $8A, $83, $58, $83, $67, $82, $F0, $81, $40, $82, $C2, $82, $A9, $82, $A4, $82, $B1, $82, $C6, $82, $AA, $82, $C5, $82, $AB, $82, $DC ; "ページリストを　つかうことができま"
	db $82, $B7, $00 ; "す"
