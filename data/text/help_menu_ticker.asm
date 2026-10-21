; data/text/help_menu_ticker.asm
; bank 6A, $64B1-$6716 (613 bytes); pinned by layout.link
; ticker tables and strings of the help menu (read through the bank 48 ticker)

SECTION "data/text/help_menu_ticker", ROMX

PUSHC sjis

; ---- data $64B1-$64D3 (34 bytes) [PROBABLE] mixed prefix and pointer table: $64 at $64B1 finishes Objects_HelpMenu; bank byte $6A at $64B2; eight title/body pointer pairs begin at $64B3 and feed Ticker_Start via HelpMenu_ShowItemText.

HelpMenu_ObjectEntryTailAndTickerBank:: ; 6A:64B1
	dw $6A64

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

; ---- text $64D3-$65A1 (206 bytes) [PROBABLE] text: 8 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

HelpMenu_TickerEntry0_Title:: ; 6A:64D3
	db "モバイルトレーナー", 0

HelpMenu_TickerEntry0_Body:: ; 6A:64E6
	db "このカートリッジの　せつめいをします", 0

HelpMenu_TickerEntry1_Title:: ; 6A:650B
	db "メールって？", 0

HelpMenu_TickerEntry1_Body:: ; 6A:6518
	db "メールの　せつめいをします", 0

HelpMenu_TickerEntry2_Title:: ; 6A:6533
	db "ホームページって？", 0

HelpMenu_TickerEntry2_Body:: ; 6A:6546
	db "ホームページの　せつめいをします", 0

HelpMenu_TickerEntry3_Title:: ; 6A:6567
	db "モバイルじてん", 0

HelpMenu_TickerEntry3_Body:: ; 6A:6576
	db "わからないことばを　しらべることができます", 0

; ---- text $65A1-$65A8 (7 bytes) [CONFIRMED] Shift-JIS/NUL title selected by zero-based ticker record 4 (page 2, item 1): three paired characters plus NUL. Source/ROM reader proof identifies the role; all 7 bytes have existing natural data reads, without temporal reader/render attribution.

String_HelpMenu_MailTitle:: ; 6A:65A1
	db "メール", 0

; ---- text $65A8-$6651 (169 bytes) [PROBABLE] title/body strings selected by entries 4-7 of HelpMenu_TickerTitleBodyPointerTable

HelpMenu_TickerEntry4_Body:: ; 6A:65A8
	db "メールの　せつめいをします", 0

HelpMenu_TickerEntry5_Title:: ; 6A:65C3
	db "アドレスちょう", 0

HelpMenu_TickerEntry5_Body:: ; 6A:65D2
	db "アドレスちょうの　せつめいをします", 0

HelpMenu_TickerEntry6_Title:: ; 6A:65F5
	db "ホームページ", 0

HelpMenu_TickerEntry6_Body:: ; 6A:6602
	db "ホームページの　せつめいをします", 0

HelpMenu_TickerEntry7_Title:: ; 6A:6623
	db "ページリスト", 0

HelpMenu_TickerEntry7_Body:: ; 6A:6630
	db "ページリストの　せつめいをします", 0

; ---- data $6651-$6672 (33 bytes) [PROBABLE] locked-item ticker table: bank byte followed by 8 title/body pointer pairs; 6651 was read as data by executed code in up to 3/18 scenarios

HelpMenu_LockedTickerTable:: ; 6A:6651
	db $6A

; ---- words $6652-$665E (12 bytes) [PROBABLE] 3 x 4-byte entries: [0000 0000] [6672 667B] [6696 669F]; entry = pair of pointers to two NUL-terminated Shift-JIS strings (title/label) in 6A:6672-66F5; 6651 byte 6A read separately

HelpMenu_LockedTickerEntries_0_2:: ; 6A:6652
	dw $0000, $0000, HelpMenu_LockedTicker_Entry2_Title, HelpMenu_LockedTicker_Entry2_Body, HelpMenu_LockedTicker_Entry3_Title, HelpMenu_LockedTicker_Entry3_Body

; ---- words $665E-$666A (12 bytes) [PROBABLE] 3 x 4-byte entries: [0000 0000] [0000 0000] [66C0 66C9]; pair of string pointers (see 6A:6652) [v4: bytes 6666-666A were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

HelpMenu_LockedTickerEntries_3_5:: ; 6A:665E
	dw $0000, $0000, $0000, $0000, HelpMenu_LockedTicker_Entry4_Title, HelpMenu_LockedTicker_Entry4_Body

; ---- words $666A-$6672 (8 bytes) [PROBABLE] 2 x 4-byte entries: [0000 0000] [66EC 66F5]; pair of string pointers (see 6A:6652)

HelpMenu_LockedTickerEntries_6_7:: ; 6A:666A
	dw $0000, $0000, HelpMenu_LockedTicker_Entry7_Title, HelpMenu_LockedTicker_Entry7_Body

; ---- text $6672-$667B (9 bytes) [PROBABLE] NUL-terminated Shift-JIS string pointed to by a word of the 6A:6652-6672 tables; 4 x 81 48 (full-width ?) placeholder

HelpMenu_LockedTicker_Entry2_Title:: ; 6A:6672
	db "？？？？", 0

; ---- text $667B-$6696 (27 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

HelpMenu_LockedTicker_Entry2_Body:: ; 6A:667B
	db "？？？の　せつめいをします", 0

; ---- text $6696-$669F (9 bytes) [PROBABLE] NUL-terminated Shift-JIS string pointed to by a word of the 6A:6652-6672 tables; 4 x 81 48 (full-width ?) placeholder [v4: bytes 6696-669F were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

HelpMenu_LockedTicker_Entry3_Title:: ; 6A:6696
	db "？？？？", 0

; ---- text $669F-$66C0 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

HelpMenu_LockedTicker_Entry3_Body:: ; 6A:669F
	db "？？？？？？の　せつめいをします", 0

; ---- text $66C0-$66C9 (9 bytes) [PROBABLE] NUL-terminated Shift-JIS string pointed to by a word of the 6A:6652-6672 tables; 4 x 81 48 (full-width ?) placeholder [v4: bytes 66C0-66C9 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

HelpMenu_LockedTicker_Entry4_Title:: ; 6A:66C0
	db "？？？？", 0

; ---- text $66C9-$66EC (35 bytes) [PROBABLE] NUL-terminated Shift-JIS string pointed to by a word of the 6A:6652-6672 tables; text after the placeholder [v4: bytes 66C9-66EC were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

HelpMenu_LockedTicker_Entry4_Body:: ; 6A:66C9
	db "？？？？？？？の　せつめいをします", 0

; ---- text $66EC-$66F5 (9 bytes) [PROBABLE] NUL-terminated Shift-JIS string pointed to by a word of the 6A:6652-6672 tables; 4 x 81 48 (full-width ?) placeholder

HelpMenu_LockedTicker_Entry7_Title:: ; 6A:66EC
	db "？？？？", 0

; ---- text $66F5-$6716 (33 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

HelpMenu_LockedTicker_Entry7_Body:: ; 6A:66F5
	db "？？？？？？の　せつめいをします", 0

POPC
