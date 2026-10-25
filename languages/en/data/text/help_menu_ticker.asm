; data/text/help_menu_ticker.asm
; bank 6A, $64B1-$6716 (613 bytes); pinned by layout.link
; Built-in English interface strings and pointer tables; unused original allocation bytes are retained.

SECTION "data/text/help_menu_ticker", ROMX

PUSHC sjis

HelpMenu_ObjectEntryTailAndTickerBank:: ; 6A:64B1
; Retained original storage bytes; outside the selected live string extents.
	db $64, $6A
HelpMenu_TickerTitleBodyPointerTable:: ; 6A:64B3
	dw HelpMenu_TickerEntry0_Title
	dw HelpMenu_TickerEntry0_Body
	dw HelpMenu_TickerEntry1_Title
	dw HelpMenu_TickerEntry1_Body
	dw HelpMenu_TickerEntry2_Title
	dw HelpMenu_TickerEntry2_Body
	dw HelpMenu_TickerEntry3_Title
	dw HelpMenu_TickerEntry3_Body
	dw String_HelpMenu_MailTitle
	dw HelpMenu_TickerEntry4_Body
	dw HelpMenu_TickerEntry5_Title
	dw HelpMenu_TickerEntry5_Body
	dw HelpMenu_TickerEntry6_Title
	dw HelpMenu_TickerEntry6_Body
	dw HelpMenu_TickerEntry7_Title
	dw HelpMenu_TickerEntry7_Body
; Retained original storage bytes; outside the selected live string extents.
	db $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $67, $83, $8C, $81, $5B, $83, $69
	db $81, $5B, $00, $82, $B1, $82, $CC, $83, $4A, $81, $5B, $83, $67, $83, $8A, $83
	db $62, $83, $57, $82, $CC, $81, $40, $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82
	db $F0, $82, $B5, $82, $DC, $82, $B7, $00, $83, $81, $81, $5B, $83, $8B, $82, $C1
	db $82, $C4, $81, $48, $00, $83, $81, $81, $5B, $83, $8B, $82, $CC, $81, $40, $82
	db $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82, $DC, $82, $B7, $00
	db $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $82, $C1, $82, $C4
	db $81, $48, $00, $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $82
	db $CC, $81, $40, $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82
	db $DC, $82, $B7, $00, $83, $82, $83, $6F, $83, $43, $83, $8B, $82, $B6, $82, $C4
	db $82, $F1, $00
HelpMenu_TickerEntry3_Body:: ; 6A:6576
	db "Ｌｏｏｋ　ｕｐ　ｕｎｋｎｏｗｎ　ｗｏｒｄｓ", 0
; Retained original storage bytes; outside the selected live string extents.
	db $83, $81, $81, $5B, $83, $8B, $00, $83, $81, $81, $5B, $83, $8B, $82, $CC, $81
	db $40, $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82, $DC, $82
	db $B7, $00, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $BF, $82, $E5, $82, $A4
	db $00, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $BF, $82, $E5, $82, $A4, $82
	db $CC, $81, $40, $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82
	db $DC, $82, $B7, $00, $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57
	db $00, $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $82, $CC, $81
	db $40, $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82, $DC, $82
	db $B7, $00, $83, $79, $81, $5B, $83, $57, $83, $8A, $83, $58, $83, $67, $00, $83
	db $79, $81, $5B, $83, $57, $83, $8A, $83, $58, $83, $67, $82, $CC, $81, $40, $82
	db $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82, $DC, $82, $B7, $00
HelpMenu_LockedTickerTable:: ; 6A:6651
; Retained original storage bytes; outside the selected live string extents.
	db $6A
HelpMenu_LockedTickerEntries_0_2:: ; 6A:6652
; Retained original storage bytes; outside the selected live string extents.
	db $00, $00, $00, $00, $72, $66, $7B, $66, $96, $66, $9F, $66
HelpMenu_LockedTickerEntries_3_5:: ; 6A:665E
; Retained original storage bytes; outside the selected live string extents.
	db $00, $00, $00, $00, $00, $00, $00, $00, $C0, $66, $C9, $66
HelpMenu_LockedTickerEntries_6_7:: ; 6A:666A
; Retained original storage bytes; outside the selected live string extents.
	db $00, $00, $00, $00, $EC, $66, $F5, $66
HelpMenu_LockedTicker_Entry2_Title:: ; 6A:6672
; Retained original storage bytes; outside the selected live string extents.
	db $81, $48, $81, $48, $81, $48, $81, $48, $00
HelpMenu_LockedTicker_Entry2_Body:: ; 6A:667B
; Retained original storage bytes; outside the selected live string extents.
	db $81, $48, $81, $48, $81, $48, $82, $CC, $81, $40, $82, $B9, $82, $C2, $82, $DF
	db $82, $A2, $82, $F0, $82, $B5, $82, $DC, $82, $B7, $00
HelpMenu_LockedTicker_Entry3_Title:: ; 6A:6696
; Retained original storage bytes; outside the selected live string extents.
	db $81, $48, $81, $48, $81, $48, $81, $48, $00
HelpMenu_LockedTicker_Entry3_Body:: ; 6A:669F
; Retained original storage bytes; outside the selected live string extents.
	db $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $82, $CC, $81, $40
	db $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82, $DC, $82, $B7
	db $00
HelpMenu_LockedTicker_Entry4_Title:: ; 6A:66C0
; Retained original storage bytes; outside the selected live string extents.
	db $81, $48, $81, $48, $81, $48, $81, $48, $00
HelpMenu_LockedTicker_Entry4_Body:: ; 6A:66C9
; Retained original storage bytes; outside the selected live string extents.
	db $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $82, $CC
	db $81, $40, $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82, $DC
	db $82, $B7, $00
HelpMenu_LockedTicker_Entry7_Title:: ; 6A:66EC
; Retained original storage bytes; outside the selected live string extents.
	db $81, $48, $81, $48, $81, $48, $81, $48, $00
HelpMenu_LockedTicker_Entry7_Body:: ; 6A:66F5
; Retained original storage bytes; outside the selected live string extents.
	db $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $82, $CC, $81, $40
	db $82, $B9, $82, $C2, $82, $DF, $82, $A2, $82, $F0, $82, $B5, $82, $DC, $82, $B7
	db $00

POPC

; ---- text $7DBB-$7DFE (67 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/help_menu_ticker/english/HelpMenu_TickerEntry7_Body", ROMX[$7DBB], BANK[$6A]
PUSHC sjis
HelpMenu_TickerEntry7_Body:: ; 6A:7DBB
	db "Ｅｘｐｌａｉｎｓ　ｈｏｗ　ｔｏ　ｕｓｅ　ｔｈｅ　ｂｏｏｋｍａｒｋｓ", 0
POPC

; ---- text $7DFE-$7E11 (19 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/help_menu_ticker/english/HelpMenu_TickerEntry7_Title", ROMX[$7DFE], BANK[$6A]
PUSHC sjis
HelpMenu_TickerEntry7_Title:: ; 6A:7DFE
	db "Ｂｏｏｋｍａｒｋｓ", 0
POPC

; ---- text $7E11-$7E4A (57 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/help_menu_ticker/english/HelpMenu_TickerEntry6_Body", ROMX[$7E11], BANK[$6A]
PUSHC sjis
HelpMenu_TickerEntry6_Body:: ; 6A:7E11
	db "Ｅｘｐｌａｉｎｓ　ｗｈａｔ　ａ　ｈｏｍｅ　ｐａｇｅ　ｉｓ", 0
POPC

; ---- text $7E4A-$7E5D (19 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/help_menu_ticker/english/HelpMenu_TickerEntry6_Title", ROMX[$7E4A], BANK[$6A]
PUSHC sjis
HelpMenu_TickerEntry6_Title:: ; 6A:7E4A
	db "Ｈｏｍｅ　Ｐａｇｅ", 0
POPC

; ---- text $7E5D-$7E90 (51 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/help_menu_ticker/english/HelpMenu_TickerEntry5_Body", ROMX[$7E5D], BANK[$6A]
PUSHC sjis
HelpMenu_TickerEntry5_Body:: ; 6A:7E5D
	db "Ｅｘｐｌａｉｎｓ　ｔｈｅ　ａｄｄｒｅｓｓ　ｂｏｏｋ", 0
POPC

; ---- text $7E90-$7EA1 (17 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/help_menu_ticker/english/HelpMenu_TickerEntry5_Title", ROMX[$7E90], BANK[$6A]
PUSHC sjis
HelpMenu_TickerEntry5_Title:: ; 6A:7E90
	db "Ｃｏｎｔａｃｔｓ", 0
POPC

; ---- text $7EA1-$7ECE (45 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/help_menu_ticker/english/HelpMenu_TickerEntry4_Body", ROMX[$7EA1], BANK[$6A]
PUSHC sjis
HelpMenu_TickerEntry4_Body:: ; 6A:7EA1
	db "Ｅｘｐｌａｉｎｓ　ｗｈａｔ　ｅｍａｉｌ　ｉｓ", 0
POPC

; ---- text $7ECE-$7ED9 (11 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/help_menu_ticker/english/String_HelpMenu_MailTitle", ROMX[$7ECE], BANK[$6A]
PUSHC sjis
String_HelpMenu_MailTitle:: ; 6A:7ECE
	db "Ｅｍａｉｌ", 0
POPC

; ---- text $7ED9-$7EFC (35 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/help_menu_ticker/english/HelpMenu_TickerEntry3_Title", ROMX[$7ED9], BANK[$6A]
PUSHC sjis
HelpMenu_TickerEntry3_Title:: ; 6A:7ED9
	db "Ｍｏｂｉｌｅ　Ｄｉｃｔｉｏｎａｒｙ", 0
POPC

; ---- text $7EFC-$7F3D (65 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/help_menu_ticker/english/HelpMenu_TickerEntry2_Body", ROMX[$7EFC], BANK[$6A]
PUSHC sjis
HelpMenu_TickerEntry2_Body:: ; 6A:7EFC
	db "Ｅｘｐｌａｎａｔｉｏｎｓ　ａｂｏｕｔ　ｔｈｅ　ｈｏｍｅ　ｐａｇｅ", 0
POPC

; ---- text $7F3D-$7F52 (21 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/help_menu_ticker/english/HelpMenu_TickerEntry2_Title", ROMX[$7F3D], BANK[$6A]
PUSHC sjis
HelpMenu_TickerEntry2_Title:: ; 6A:7F3D
	db "Ｈｏｍｅ　Ｐａｇｅ？", 0
POPC

; ---- text $7F52-$7F83 (49 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/help_menu_ticker/english/HelpMenu_TickerEntry1_Body", ROMX[$7F52], BANK[$6A]
PUSHC sjis
HelpMenu_TickerEntry1_Body:: ; 6A:7F52
	db "Ｅｘｐｌａｎａｔｉｏｎｓ　ａｂｏｕｔ　ｅｍａｉｌ", 0
POPC

; ---- text $7F83-$7FA0 (29 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/help_menu_ticker/english/HelpMenu_TickerEntry1_Title", ROMX[$7F83], BANK[$6A]
PUSHC sjis
HelpMenu_TickerEntry1_Title:: ; 6A:7F83
	db "Ｗｈａｔ　ｉｓ　Ｅｍａｉｌ？", 0
POPC

; ---- text $7FA0-$7FE3 (67 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/help_menu_ticker/english/HelpMenu_TickerEntry0_Body", ROMX[$7FA0], BANK[$6A]
PUSHC sjis
HelpMenu_TickerEntry0_Body:: ; 6A:7FA0
	db "Ｉｎｓｔｒｕｃｔｉｏｎｓ　ａｂｏｕｔ　ｔｈｉｓ　ｃａｒｔｒｉｄｇｅ", 0
POPC

; ---- text $7FE3-$8000 (29 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "data/text/help_menu_ticker/english/HelpMenu_TickerEntry0_Title", ROMX[$7FE3], BANK[$6A]
PUSHC sjis
HelpMenu_TickerEntry0_Title:: ; 6A:7FE3
	db "Ｍｏｂｉｌｅ　Ｔｒａｉｎｅｒ", 0
POPC
