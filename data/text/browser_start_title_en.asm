; Growing English ticker title, retained within its original ROM bank.
SECTION "English browser start title", ROMX[$7FED], BANK[$73]
PUSHC sjis
BrowserStart_Strings:: ; 73:7FED
String_73_4009:: ; 73:7FED (historical alias)
	db "Ｈｏｍｅ　Ｐａｇｅ", 0
POPC
