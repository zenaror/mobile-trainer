; data/text/connect_dialog.asm
; bank 56, $4000-$418A (394 bytes); pinned by layout.link
; Built-in English interface strings and pointer tables; unused original allocation bytes are retained.

SECTION "data/text/connect_dialog", ROMX

PUSHC sjis

; Retained original storage bytes; outside the selected live string extents.
	db $82, $C2, $82, $A4, $82, $ED, $82, $E8, $82, $E5, $82, $A4, $82, $C6, $81, $40
	db $82, $B9, $82, $C2, $82, $BC, $82, $AD, $82, $E8, $82, $E5, $82, $A4, $82, $AA
	db $82, $A9, $82, $A9, $82, $E8, $82, $DC, $82, $B7, $81, $42, $0D, $0A, $81, $40
	db $81, $40, $81, $40, $81, $40, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5
	db $82, $B7, $82, $A9, $81, $48, $00, $81, $9C, $82, $C5, $83, $70, $83, $58, $83
	db $8F, $81, $5B, $83, $68, $82, $F0, $0D, $0A, $82, $A9, $82, $A2, $82, $C4, $82
	db $AD, $82, $BE, $82, $B3, $82, $A2, $81, $42, $00, $82, $B9, $82, $C2, $82, $DF
	db $82, $A2, $82, $B5, $82, $E5, $82, $C5, $81, $40, $83, $70, $83, $58, $83, $8F
	db $81, $5B, $83, $68, $82, $D9, $82, $BC, $82, $F1, $82, $C9, $82, $C2, $82, $A2
	db $82, $C4, $82, $CC, $82, $BF, $82, $E3, $82, $A4, $82, $A2, $82, $F0, $0D, $0A
	db $82, $DD, $82, $C4, $82, $AD, $82, $BE, $82, $B3, $82, $A2, $81, $42, $82, $D9
	db $82, $BC, $82, $F1, $82, $B5, $82, $DC, $82, $B7, $82, $A9, $81, $48, $00, $83
	db $4A, $81, $5B, $83, $67, $83, $8A, $83, $62, $83, $57, $82, $C9, $81, $40, $83
	db $70, $83, $58, $83, $8F, $81, $5B, $83, $68, $82, $F0, $0D, $0A, $82, $D9, $82
	db $BC, $82, $F1, $82, $B5, $82, $DC, $82, $B5, $82, $BD, $81, $42, $0D, $0A, $81
	db $9C, $82, $C5, $82, $C2, $82, $A4, $82, $B5, $82, $F1, $82, $F0, $82, $CD, $82
	db $B6, $82, $DF, $82, $DC, $82, $B7, $81, $42, $00
String_ConnectDialog_StoredPasswordNotice:: ; 56:410A
	db "Ｐａｓｓｗｏｒｄ　ｉｓ", $0D, $0A
	db "ａｌｒｅａｄｙ　ｓａｖｅｄ．", $0D, $0A
	db "●　Ｃｏｎｔｉｎｕｅ", 0
; Retained original storage bytes; outside the selected live string extents.
	db $B7, $81, $42, $00, $83, $70, $83, $58, $83, $8F, $81, $5B, $83, $68, $82, $CC
	db $81, $40, $82, $D9, $82, $BC, $82, $F1, $82, $F0, $82, $E2, $82, $DF, $82, $DC
	db $82, $B7, $81, $42, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7
	db $82, $A9, $81, $48, $00

POPC

; ---- text $7E91-$7EDC (75 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/connect_dialog/english/String_ConnectDialog_CancelPasswordStorageConfirm", ROMX[$7E91], BANK[$56]
PUSHC sjis
String_ConnectDialog_CancelPasswordStorageConfirm:: ; 56:7E91
	db "Ｐａｓｓｗｏｒｄ　ｗｉｌｌ　ｂｅｄｅｌｅｔｅｄ．", $0D, $0A
	db "　　　Ｃｏｎｔｉｎｕｅ？", 0
POPC

; ---- text $7EDC-$7F2B (79 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/connect_dialog/english/String_ConnectDialog_PasswordSavedNotice", ROMX[$7EDC], BANK[$56]
PUSHC sjis
String_ConnectDialog_PasswordSavedNotice:: ; 56:7EDC
	db "Ｐａｓｓｗｏｒｄ　ｓａｖｅｄ", $0D, $0A
	db "ｔｏ　ｃａｒｔｒｉｄｇｅ．", $0D, $0A
	db "●　Ｃｏｎｔｉｎｕｅ", 0
POPC

; ---- text $7F2B-$7F86 (91 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/connect_dialog/english/String_ConnectDialog_SavePasswordConfirm", ROMX[$7F2B], BANK[$56]
PUSHC sjis
String_ConnectDialog_SavePasswordConfirm:: ; 56:7F2B
	db "Ｃｈｅｃｋ　ｍａｎｕａｌ　ｆｏｒｐｒｅｃａｕｔｉｏｎｓ．", $0D, $0A
	db "　Ｓａｖｅ　ｐａｓｓｗｏｒｄ？　", 0
POPC

; ---- text $7F86-$7FB1 (43 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/connect_dialog/english/String_ConnectDialog_PasswordEntryPrompt", ROMX[$7F86], BANK[$56]
PUSHC sjis
String_ConnectDialog_PasswordEntryPrompt:: ; 56:7F86
	db "●　Ｅｎｔｅｒ　ｙｏｕｒ", $0D, $0A
	db "ｐａｓｓｗｏｒｄ", 0
POPC

; ---- text $7FB1-$8000 (79 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/connect_dialog/english/String_ConnectDialog_Messages", ROMX[$7FB1], BANK[$56]
PUSHC sjis
String_ConnectDialog_Messages:: ; 56:7FB1
	db "Ｃａｌｌｉｎｇ　ｃｈａｒｇｅｓ　ｍａｙ　ａｐｐｌｙ．", $0D, $0A
	db "　　　Ｃｏｎｔｉｎｕｅ？", 0
POPC
