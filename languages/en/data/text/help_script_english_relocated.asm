; English HelpScript content with same-bank symbolic navigation.
; Five donor topics; control order retained; invalid no-glyph cells use wide blanks.
; [PROBABLE] Static reader, glyph, branch and allocation checks; runtime unvalidated.

SECTION "English HelpScript stream", ROMX[$61CC], BANK[$6C]
PUSHC sjis


HelpScript_EnglishEntry:: ; 6C:61CC
	db $18, $00, $01
	dw HelpScript_EnglishTopicTrainer - (@ + 2)
	db $18, $00, $09
	dw HelpScript_EnglishTopicMail - (@ + 2)
	db $18, $00, $0A
	dw HelpScript_EnglishTopicAddressBook - (@ + 2)
	db $18, $00, $11
	dw HelpScript_EnglishTopicHomePage - (@ + 2)
	db $18, $00, $12
	dw HelpScript_EnglishTopicPageList - (@ + 2)
	db $18, $00, $81
	dw HelpScript_EnglishTopicTrainer - (@ + 2)
	db $18, $00, $89
	dw HelpScript_EnglishTopicMail - (@ + 2)
	db $18, $00, $8A
	dw HelpScript_EnglishTopicAddressBook - (@ + 2)
	db $18, $00, $91
	dw HelpScript_EnglishTopicHomePage - (@ + 2)
	db $18, $00, $92
	dw HelpScript_EnglishTopicPageList - (@ + 2)
	db $04
	dw HelpScript_EnglishTerminal - (@ + 2)

HelpScript_EnglishTopicTrainer:: ; 6C:6201
	db $08
	dw HelpScript_EnglishTrainerSeenFlag - (@ + 2)

HelpScript_EnglishTrainerPage00:: ; 6C:6204
	db $03, $01, $01
	db $30
	db "Ｍ．Ｔｒａｉｎｅｒ　", 0
	db "Ｗｅｌｃｏｍｅ　ｔｏ"
	db $10
	db "Ｍｏｂｉｌｅ　Ｔｒａｉｎｅｒ！"
	db $10
	db 0
	db $06
	dw HelpScript_EnglishTrainerFinish - (@ + 2)

HelpScript_EnglishTrainerPage01:: ; 6C:6255
	db $03, $01, $01
	db "Ｂｅｆｏｒｅ　ｙｏｕ　ｐｌａｙ，ｐｌｅａｓｅ　ｒｅａｄ　ｔｈｅ　ｉｎｓｔｒｕｃｔｉｏｎｓ．"
	db 0
	db $06
	dw HelpScript_EnglishTrainerPage00 - (@ + 2)

HelpScript_EnglishTrainerPage02:: ; 6C:62B6
	db $03, $02, $02
	db "Ｗｉｔｈ　ｔｈｉｓ　ｇａｍｅ，"
	db $10
	db "ｙｏｕ　ｃａｎ　ｕｓｅ　ｅ"
	db $B0
	db $10
	db "ｍａｉｌ　ａｎｄ　ｂｒｏｗｓｅｒ"
	db 0
	db $06
	dw HelpScript_EnglishTrainerPage01 - (@ + 2)

HelpScript_EnglishTrainerPage03:: ; 6C:6318
	db $03, $03, $03
	db "Ｕｓｉｎｇ　ｙｏｕｒ　ＧＢ，"
	db $10
	db "ｙｏｕ　ｃａｎ　ｅｎｊｏｙ"
	db $10
	db "ｓｅｎｄｉｎｇ　ｅｍａｉｌｓ．"
	db 0
	db $06
	dw HelpScript_EnglishTrainerPage02 - (@ + 2)

HelpScript_EnglishTrainerPage04:: ; 6C:6375
	db $03, $03, $03
	db "Ｏｎ　ｔｈｅ　ｈｏｍｅｐａｇｅ，ｙｏｕ　ｃａｎ　ｒｅａｄ"
	db $10
	db "ｎｅｗｓ　ａｎｄ　ｕｐｄａｔｅｓ"
	db 0
	db $06
	dw HelpScript_EnglishTrainerPage03 - (@ + 2)

HelpScript_EnglishTrainerPage05:: ; 6C:63D5
	db $03, $02, $04
	db "Ｃｏｎｔｒｏｌｓ："
	db $10
	db "εＭｏｖｅ　ｃｕｒｓｏｒ"
	db $10
	db "γＣｏｎｆｉｒｍ"
	db 0
	db $06
	dw HelpScript_EnglishTrainerPage04 - (@ + 2)

HelpScript_EnglishTrainerPage06:: ; 6C:6418
	db $03, $03, $04
	db "δＣａｎｃｅｌ　ａｎｄ　ｇｏ"
	db $10
	db "ｂａｃｋ"
	db 0
	db $06
	dw HelpScript_EnglishTrainerPage05 - (@ + 2)

HelpScript_EnglishTrainerPage07:: ; 6C:6444
	db $03, $02, $04
	db "Ｐｒｅｓｓ　Ｓｔａｒｔ　ｔｏ"
	db $10
	db "ｏｐｅｎ　ｔｈｅ　ｍｅｎｕ"
	db 0
	db $06
	dw HelpScript_EnglishTrainerPage06 - (@ + 2)

HelpScript_EnglishTrainerPage08:: ; 6C:6482
	db $03, $02, $05
	db "Ｙｏｕ　ｃａｎ　ｒｅａｄ　ａｌｌ"
	db $10
	db "ｅｘｐｌａｎａｔｉｏｎｓ　ｂｙ"
	db $10
	db "ｓｅｌｅｃｔｉｎｇ　ＨＥＬＰ"
	db 0
	db $06
	dw HelpScript_EnglishTrainerPage07 - (@ + 2)

HelpScript_EnglishTrainerPage09:: ; 6C:64E5
	db $03, $02, $05
	db "Ｉｆ　ｙｏｕ　ｄｏｎ’ｔ"
	db $10
	db "ｕｎｄｅｒｓｔａｎｄ　ａ"
	db $10
	db "ｗｏｒｄ，ｙｏｕ　ｃａｎ"
	db 0
	db $06
	dw HelpScript_EnglishTrainerPage08 - (@ + 2)

HelpScript_EnglishTrainerPage10:: ; 6C:6536
	db $03, $02, $05
	db "ｃｈｅｃｋ　ｔｈｅ　Ｍｏｂｉｌｅ"
	db $10
	db "Ｄｉｃｔｉｏｎａｒｙ．　　　　"
	db 0
	db $06
	dw HelpScript_EnglishTrainerPage09 - (@ + 2)

HelpScript_EnglishTrainerFinish:: ; 6C:657C
	db $06
	dw HelpScript_EnglishTerminal - (@ + 2)

HelpScript_EnglishTrainerSeenFlag:: ; 6C:657F
	db $10, $01, $01
	db $04
	dw HelpScript_EnglishTerminal - (@ + 2)

HelpScript_EnglishTopicMail:: ; 6C:6585
	db $08
	dw HelpScript_EnglishMailSeenFlag - (@ + 2)

HelpScript_EnglishMailPage00:: ; 6C:6588
	db $03, $01, $06
	db $30
	db "　Ｅｍａｉｌ　", 0
	db "Ａｎ　ｅｍａｉｌ　ｉｓ　ｌｉｋｅ"
	db $10
	db "ａ　ｌｅｔｔｅｒ　ｙｏｕ"
	db $10
	db "ｓｅｎｄ　ｏｎｌｉｎｅ"
	db 0
	db $06
	dw HelpScript_EnglishMailFinish - (@ + 2)

HelpScript_EnglishMailPage01:: ; 6C:65EF
	db $03, $02, $06
	db "Ｙｏｕ　ｃａｎ　ｅｍａｉｌ"
	db $10
	db "ｆｒｉｅｎｄｓ　ｗｈｏ　ｈａｖｅ"
	db $10
	db "ａｎ　ｅｍａｉｌ　ａｄｄｒｅｓｓ"
	db 0
	db $06
	dw HelpScript_EnglishMailPage00 - (@ + 2)

HelpScript_EnglishMailPage02:: ; 6C:6652
	db $03, $05, $06
	db "Ａｎ　ｅｍａｉｌ　ａｄｄｒｅｓｓ"
	db $10
	db "ｉｓ　ｌｉｋｅ　ａ　ｈｏｍｅ"
	db $10
	db "ａｄｄｒｅｓｓ　ｏｎｌｉｎｅ"
	db 0
	db $06
	dw HelpScript_EnglishMailPage01 - (@ + 2)

HelpScript_EnglishMailPage03:: ; 6C:66B3
	db $03, $05, $07
	db "Ｔｏ　ｗｒｉｔｅ　ａｎ"
	db $10
	db "ｅｍａｉｌ，　ｆｉｒｓｔ"
	db $10
	db "ｓｅｌｅｃｔ　"
	db $21
	db "Ｗｒｉｔｅ"
	db $20
	db 0
	db $06
	dw HelpScript_EnglishMailPage02 - (@ + 2)

HelpScript_EnglishMailPage04:: ; 6C:6704
	db $03, $02, $08
	db "Ｅｎｔｅｒ　ａｎ　Ｅｍａｉｌ"
	db $10
	db "Ａｄｄｒｅｓｓ　ａｎｄ"
	db $10
	db "Ｅｍａｉｌ　Ｔｉｔｌｅ"
	db 0
	db $06
	dw HelpScript_EnglishMailPage03 - (@ + 2)

HelpScript_EnglishMailPage05:: ; 6C:6755
	db $03, $03, $09
	db "Ａｆｔｅｒ　ｅｎｔｅｒｉｎｇ　ａ"
	db $10
	db "Ｔｉｔｌｅ，　ｗｒｉｔｅ　ｔｈｅ"
	db $10
	db "ｅｍａｉｌ　ｂｏｄｙ"
	db 0
	db $06
	dw HelpScript_EnglishMailPage04 - (@ + 2)

HelpScript_EnglishMailPage06:: ; 6C:67B2
	db $03, $02, $0A
	db "Ｗｈｅｎ　ｙｏｕ’ｒｅ"
	db $10
	db "ｄｏｎｅ，　ｓｅｌｅｃｔ　ｔｈｅ"
	db $10
	db "Ｓａｖｅ　ｏｐｔｉｏｎ"
	db 0
	db $06
	dw HelpScript_EnglishMailPage05 - (@ + 2)

HelpScript_EnglishMailPage07:: ; 6C:6807
	db $03, $05, $0B
	db "Ｔｈｅｎ，　ｓｅｌｅｃｔ　"
	db $10
	db $21
	db "Ｓｅｎｄ／Ｒｅｃｖ"
	db $20
	db "　ｔｏ"
	db $10
	db "ｓｅｎｄ　ｔｈｅ　ｅｍａｉｌ"
	db 0
	db $06
	dw HelpScript_EnglishMailPage06 - (@ + 2)

HelpScript_EnglishMailPage08:: ; 6C:6860
	db $03, $02, $0C
	db "Ａｆｔｅｒ　ｓｅｎｄｉｎｇ，"
	db $10
	db "ｙｏｕ　ｗｉｌｌ　ａｌｓｏ"
	db $10
	db "ｒｅｃｅｉｖｅ　ｎｅｗ　ｍａｉｌ"
	db 0
	db $06
	dw HelpScript_EnglishMailPage07 - (@ + 2)

HelpScript_EnglishMailPage09:: ; 6C:68BF
	db $03, $05, $0D
	db "Ｎｅｗ　ｅｍａｉｌｓ　ｗｉｌｌ"
	db $10
	db "ａｐｐｅａｒ　ｉｎ　ｙｏｕｒ"
	db $10
	db "ｍａｉｌｂｏｘ"
	db 0
	db $06
	dw HelpScript_EnglishMailPage08 - (@ + 2)

HelpScript_EnglishMailPage10:: ; 6C:6910
	db $03, $02, $0E
	db "Ｙｏｕ　ｃａｎ　ｏｎｌｙ"
	db $10
	db "ｋｅｅｐ　ｕｐ　ｔｏ　１２"
	db $10
	db "ｅｍａｉｌｓ　ａｔ　ａ　ｔｉｍｅ"
	db 0
	db $06
	dw HelpScript_EnglishMailPage09 - (@ + 2)

HelpScript_EnglishMailPage11:: ; 6C:696B
	db $03, $02, $0E
	db "ｓｏ　ｙｏｕ　ｓｈｏｕｌｄ"
	db $10
	db "ｄｅｌｅｔｅ　ｙｏｕｒ"
	db $10
	db "ｏｌｄ　ｅｍａｉｌｓ　ｏｆｔｅｎ"
	db 0
	db $06
	dw HelpScript_EnglishMailPage10 - (@ + 2)

HelpScript_EnglishMailPage12:: ; 6C:69C4
	db $03, $02, $1F
	db "Ｙｏｕ　ｃａｎ　ａｌｓｏ"
	db $10
	db "ｍａｎａｇｅ　ｍａｉｌ　ｏｎ"
	db $10
	db "ｔｈｅ　ｍａｉｌ　ｓｅｒｖｅｒ"
	db 0
	db $06
	dw HelpScript_EnglishMailPage11 - (@ + 2)

HelpScript_EnglishMailPage13:: ; 6C:6A1F
	db $03, $02, $1F
	db "Ｉｆ　ｙｏｕ　ｄｏｎ’ｔ"
	db $10
	db "ｄｅｌｅｔｅ　ｅｍａｉｌｓ　ｏｎ"
	db $10
	db "ｔｈｅ　ｓｅｒｖｅｒ，"
	db 0
	db $06
	dw HelpScript_EnglishMailPage12 - (@ + 2)

HelpScript_EnglishMailPage14:: ; 6C:6A76
	db $03, $02, $1F
	db "ｃｏｍｍｕｎｉｃａｔｉｏｎ"
	db $10
	db "ｔｉｍｅｓ　ｍａｙ　ｔａｋｅ"
	db $10
	db "ｌｏｎｇｅｒ"
	db 0
	db $06
	dw HelpScript_EnglishMailPage13 - (@ + 2)

HelpScript_EnglishMailPage15:: ; 6C:6AC1
	db $03, $03, $0F
	db "Ｕｓｉｎｇ　ｅｍａｉｌ，　ｙｏｕ"
	db $10
	db "ｃａｎ　ｓｔａｙ　ｉｎ"
	db $10
	db "ｃｏｎｔａｃｔ"
	db 0
	db $06
	dw HelpScript_EnglishMailPage14 - (@ + 2)

HelpScript_EnglishMailPage16:: ; 6C:6B0E
	db $03, $02, $0F
	db "Ｈａｖｅ　ｆｕｎ　ａｎｄ"
	db $10
	db "ｍａｋｅ　ｎｅｗ　ｆｒｉｅｎｄｓ"
	db $10
	db "ｏｎｌｉｎｅ！"
	db $20
	db "　　　"
	db 0
	db $06
	dw HelpScript_EnglishMailPage15 - (@ + 2)

HelpScript_EnglishMailFinish:: ; 6C:6B64
	db $06
	dw HelpScript_EnglishTerminal - (@ + 2)

HelpScript_EnglishMailSeenFlag:: ; 6C:6B67
	db $10, $02, $01
	db $04
	dw HelpScript_EnglishTerminal - (@ + 2)

HelpScript_EnglishTopicAddressBook:: ; 6C:6B6D
	db $08
	dw HelpScript_EnglishAddressBookSeenFlag - (@ + 2)

HelpScript_EnglishAddressBookPage00:: ; 6C:6B70
	db $03, $01, $10
	db $30
	db "Ａｄｄｒ．Ｂｏｏｋ", 0
	db "Ｍｅｍｏｒｉｚｉｎｇ　ｅｍａｉｌ"
	db $10
	db "ａｄｄｒｅｓｓｅｓ　ｉｓ"
	db $10
	db "ｄｉｆｆｉｃｕｌｔ，　ｓｏ　ｉｔ"
	db $10
	db 0
	db $06
	dw HelpScript_EnglishAddressBookFinish - (@ + 2)

HelpScript_EnglishAddressBookPage01:: ; 6C:6BE6
	db $03, $04, $10
	db "ｈｅｌｐｓ　ｔｏ　ｓａｖｅ"
	db $10
	db "ｔｈｅｍ　ｉｎ　ａｎ"
	db $10
	db "Ａｄｄｒｅｓｓ　Ｂｏｏｋ．"
	db 0
	db $06
	dw HelpScript_EnglishAddressBookPage00 - (@ + 2)

HelpScript_EnglishAddressBookPage02:: ; 6C:6C37
	db $03, $03, $11
	db "Ｏｎ　ｔｈｅ　Ａｄｄｒ．Ｂｏｏｋ"
	db $10
	db "ｓｃｒｅｅｎ，　ｐｉｃｋ　ａ"
	db $10
	db "ｓｌｏｔ　＆　ｐｒｅｓｓ　ＡＤＤ"
	db 0
	db $06
	dw HelpScript_EnglishAddressBookPage01 - (@ + 2)

HelpScript_EnglishAddressBookPage03:: ; 6C:6C9C
	db $03, $03, $11
	db "Ｅｎｔｅｒ　ｎａｍｅ　＆"
	db $10
	db "ｅｍａｉｌ　ａｄｄｒｅｓｓ．"
	db 0
	db $06
	dw HelpScript_EnglishAddressBookPage02 - (@ + 2)

HelpScript_EnglishAddressBookPage04:: ; 6C:6CD8
	db $03, $03, $12
	db "Ｔｈｅｎ，　ｐｒｅｓｓ　"
	db $21
	db "ＯＫ"
	db $20
	db "．"
	db 0
	db $06
	dw HelpScript_EnglishAddressBookPage03 - (@ + 2)

HelpScript_EnglishAddressBookPage05:: ; 6C:6CFF
	db $03, $02, $13
	db "Ｏｎｃｅ　ａｎ　ｅｍａｉｌ"
	db $10
	db "ｉｓ　ｓａｖｅｄ，　ｙｏｕ"
	db $10
	db "ｃａｎ　ｒｅｕｓｅ　ｉｔ．"
	db 0
	db $06
	dw HelpScript_EnglishAddressBookPage04 - (@ + 2)

HelpScript_EnglishAddressBookPage06:: ; 6C:6D56
	db $03, $03, $13
	db "Ｏｎ　ｔｈｅ　ｅｍａｉｌ"
	db $10
	db "ａｄｄｒｅｓｓ　ｓｃｒｅｅｎ，"
	db $10
	db "ｐｒｅｓｓ　ＳＥＬＥＣＴ"
	db 0
	db $06
	dw HelpScript_EnglishAddressBookPage05 - (@ + 2)

HelpScript_EnglishAddressBookPage07:: ; 6C:6DAD
	db $03, $03, $13
	db "ｔｏ　ｖｉｅｗ　ｔｈｅ"
	db $10
	db "Ａｄｄｒｅｓｓ　Ｂｏｏｋ．　　　　"
	db 0
	db $06
	dw HelpScript_EnglishAddressBookPage06 - (@ + 2)

HelpScript_EnglishAddressBookFinish:: ; 6C:6DED
	db $06
	dw HelpScript_EnglishTerminal - (@ + 2)

HelpScript_EnglishAddressBookSeenFlag:: ; 6C:6DF0
	db $10, $03, $01
	db $04
	dw HelpScript_EnglishTerminal - (@ + 2)

HelpScript_EnglishTopicHomePage:: ; 6C:6DF6
	db $08
	dw HelpScript_EnglishHomePageSeenFlag - (@ + 2)

HelpScript_EnglishHomePagePage00:: ; 6C:6DF9
	db $03, $01, $14
	db $30
	db "Ｈｏｍｅ　Ｐａｇｅ", 0
	db "ホ"
	db $B0
	db "ムペ"
	db $B0
	db "ジ"
	db $ED
	db $B1
	db $BF
	db $F1
	db $CF
	db $B4
	db $C6
	db $A4
	db $BD
	db $BA
	db $10
	db $BC
	db $EA
	db $B9
	db $A4
	db $BE
	db $C2
	db $D2
	db $B2
	db $BD
	db $D9
	db $D6
	db $A1
	db 0
	db $06
	dw HelpScript_EnglishHomePageFinish - (@ + 2)

HelpScript_EnglishHomePagePage01:: ; 6C:6E35
	db $03, $01, $15
	db "ホ"
	db $B0
	db "ムペ"
	db $B0
	db "ジ"
	db $CA
	db $A4
	db $B4
	db $D4
	db $D3
	db $E6
	db $A6
	db $C2
	db $B6
	db $AF
	db $10
	db $C0
	db $B2
	db $DB
	db $DD
	db $C5
	db $E6
	db $AE
	db $B3
	db $CE
	db $B3
	db $A6
	db $D0
	db $D9
	db $BA
	db $C4
	db $E0
	db $10
	db $ED
	db $B7
	db $D9
	db $DD
	db $EA
	db $A1
	db 0
	db $06
	dw HelpScript_EnglishHomePagePage00 - (@ + 2)

HelpScript_EnglishHomePagePage02:: ; 6C:6E68
	db $03, $03, $15
	db "ホ"
	db $B0
	db "ムペ"
	db $B0
	db "ジ"
	db $CA
	db $BE
	db $B6
	db $B2
	db $E6
	db $AD
	db $B3
	db $C6
	db $C0
	db $B8
	db $10
	db $BB
	db $DD
	db $B1
	db $AF
	db $C3
	db $A4
	db $D0
	db $DD
	db $C5
	db $C2
	db $C5
	db $E0
	db $AF
	db $C3
	db $B2
	db $D9
	db $10
	db $DD
	db $EA
	db $D6
	db $A1
	db 0
	db $06
	dw HelpScript_EnglishHomePagePage01 - (@ + 2)

HelpScript_EnglishHomePagePage03:: ; 6C:6E99
	db $03, $05, $16
	db $E6
	db $AC
	db $B1
	db $21
	db "【ホ"
	db $B0
	db "ムペ"
	db $B0
	db "ジ】"
	db $20
	db $A6
	db $B5
	db $BC
	db $C3
	db $A4
	db $10
	db "ホ"
	db $B0
	db "ムペ"
	db $B0
	db "ジ"
	db $A6
	db $D0
	db $C3
	db $D0
	db $D6
	db $B3
	db "！"
	db 0
	db $06
	dw HelpScript_EnglishHomePagePage02 - (@ + 2)

HelpScript_EnglishHomePagePage04:: ; 6C:6ECB
	db $03, $05, $17
	db "ホ"
	db $B0
	db "ムペ"
	db $B0
	db "ジ"
	db $A6
	db $D0
	db $C3
	db $B2
	db $C3
	db $A4
	db $21
	db $B1
	db $B5
	db $B2
	db $D3
	db $10
	db $E6
	db $E0
	db $B1
	db $AF
	db $C0
	db $D7
	db $A4
	db "Ａボタ"
	db $FF
	db $20
	db $A6
	db $B5
	db $BC
	db $C3
	db $D0
	db $10
	db $D6
	db $B3
	db $A1
	db 0
	db $06
	dw HelpScript_EnglishHomePagePage03 - (@ + 2)

HelpScript_EnglishHomePagePage05:: ; 6C:6F00
	db $03, $05, $17
	db $BF
	db $C9
	db "ペ"
	db $B0
	db "ジ"
	db $C4
	db $C2
	db $C5
	db $E0
	db $AF
	db $C3
	db $B2
	db $D9
	db "ペ"
	db $B0
	db "ジ"
	db $10
	db $C6
	db $A4
	db "ジ"
	db $FC
	db $FF
	db "プ"
	db $BD
	db $D9
	db $BA
	db $C4
	db $E0
	db $ED
	db $B7
	db $D9
	db $DD
	db $EA
	db $10
	db $D6
	db $A1
	db 0
	db $06
	dw HelpScript_EnglishHomePagePage04 - (@ + 2)

HelpScript_EnglishHomePagePage06:: ; 6C:6F31
	db $03, $05, $17
	db $BA
	db $DA
	db $A6
	db $A4
	db $21
	db "ホ"
	db $B0
	db "ムペ"
	db $B0
	db "ジ"
	db $E0
	db "リ"
	db $FF
	db "ク"
	db $BC
	db $C3
	db $10
	db $B2
	db $D9
	db $20
	db $C4
	db $B2
	db $B3
	db $DD
	db $EA
	db $D6
	db $A1
	db 0
	db $06
	dw HelpScript_EnglishHomePagePage05 - (@ + 2)

HelpScript_EnglishHomePagePage07:: ; 6C:6F5A
	db $03, $02, $18
	db "Ｂボタ"
	db $FF
	db $A6
	db $B5
	db $BD
	db $C4
	db $A4
	db $CF
	db $B4
	db $C9
	db "ペ"
	db $B0
	db "ジ"
	db $C6
	db $10
	db $D3
	db $EE
	db $D9
	db $BA
	db $C4
	db $D3
	db $ED
	db $B7
	db $D9
	db $DD
	db $EA
	db $D6
	db $A1
	db 0
	db $06
	dw HelpScript_EnglishHomePagePage06 - (@ + 2)

HelpScript_EnglishHomePagePage08:: ; 6C:6F84
	db $03, $02, $19
	db "ホ"
	db $B0
	db "ムペ"
	db $B0
	db "ジ"
	db $A6
	db $D0
	db $C3
	db $B2
	db $D9
	db $C4
	db $B7
	db $C6
	db $CA
	db $A4
	db $10
	db $21
	db $B5
	db $B6
	db $C8
	db $E0
	db $B6
	db $B6
	db $D9
	db $DD
	db $EA
	db $A1
	db $20
	db 0
	db $06
	dw HelpScript_EnglishHomePagePage07 - (@ + 2)

HelpScript_EnglishHomePagePage09:: ; 6C:6FAC
	db $03, $02, $19
	db $B1
	db $CF
	db $D8
	db $21
	db $C5
	db $E0
	db $B2
	db $E6
	db $B6
	db $DD
	db $BE
	db $C2
	db $E9
	db $B8
	db $BD
	db $D9
	db $C9
	db $CA
	db $D4
	db $D2
	db $D6
	db $B3
	db $20
	db $C8
	db $A1
	db 0
	db $06
	dw HelpScript_EnglishHomePagePage08 - (@ + 2)

HelpScript_EnglishHomePagePage10:: ; 6C:6FCC
	db $03, $03, $1A
	db "ゲ"
	db $B0
	db "ムソフト"
	db $C9
	db $FB
	db "ュ"
	db $B0
	db $FD
	db $D4
	db $A4
	db $B5
	db $D3
	db $BC
	db $10
	db $DB
	db $B2
	db $E6
	db $AE
	db $B3
	db $CE
	db $B3
	db $A6
	db $A4
	db $B2
	db $C2
	db $ED
	db $D3
	db $EE
	db $BA
	db $ED
	db $10
	db $D3
	db $D0
	db $D9
	db $BA
	db $C4
	db $E0
	db $ED
	db $B7
	db $D9
	db $DD
	db $EA
	db $D6
	db $A1
	db 0
	db $06
	dw HelpScript_EnglishHomePagePage09 - (@ + 2)

HelpScript_EnglishHomePagePage11:: ; 6C:7008
	db $03, $03, $1A
	db $BF
	db $DA
	db $C4
	db $A4
	db $C6
	db $DD
	db $C3
	db $DD
	db $EE
	db $B3
	db "モバイ"
	db $FA
	db "ホ"
	db $B0
	db $10
	db "ムペ"
	db $B0
	db "ジ"
	db $C6
	db $CA
	db $A4
	db $C0
	db $B2
	db $BE
	db $C2
	db $C5
	db $B5
	db $BC
	db $D7
	db $BE
	db $10
	db $E0
	db $B1
	db $D9
	db $C9
	db $ED
	db $A4
	db $D0
	db $C6
	db $B7
	db $C3
	db $C8
	db $A1
	db 0
	db $06
	dw HelpScript_EnglishHomePagePage10 - (@ + 2)

HelpScript_EnglishHomePagePage12:: ; 6C:7044
	db $03, $03, $1A
	db "キミ"
	db $CA
	db $EE
	db $DD
	db $C5
	db $E6
	db $AE
	db $B3
	db $CE
	db $B3
	db $E0
	db $D0
	db $C0
	db $B2
	db $C9
	db $10
	db $B6
	db $C5
	db "？ホ"
	db $B0
	db "ムペ"
	db $B0
	db "ジ"
	db $C6
	db $CA
	db $A4
	db $B7
	db $D0
	db $C9
	db $BC
	db $10
	db $D7
	db $C5
	db $B2
	db $E6
	db $AE
	db $B3
	db $CE
	db $B3
	db $E0
	db $B2
	db $AF
	db $F4
	db $B2
	db $EA
	db $D6
	db $A1
	db 0
	db $06
	dw HelpScript_EnglishHomePagePage11 - (@ + 2)

HelpScript_EnglishHomePagePage13:: ; 6C:7084
	db $03, $03, $1A
	db $BB
	db $B2
	db $BC
	db $DD
	db $C9
	db $FB
	db "ュ"
	db $B0
	db $FD
	db $A6
	db $D0
	db $C2
	db $B9
	db $C0
	db $D7
	db $A4
	db $10
	db $C4
	db $D3
	db $EA
	db $C1
	db $C6
	db $E6
	db $CF
	db $DD
	db $BC
	db $C1
	db $AC
	db $B5
	db $B3
	db "！！"
	db 0
	db $06
	dw HelpScript_EnglishHomePagePage12 - (@ + 2)

HelpScript_EnglishHomePageFinish:: ; 6C:70AE
	db $06
	dw HelpScript_EnglishTerminal - (@ + 2)

HelpScript_EnglishHomePageSeenFlag:: ; 6C:70B1
	db $10, $04, $01
	db $04
	dw HelpScript_EnglishTerminal - (@ + 2)

HelpScript_EnglishTopicPageList:: ; 6C:70B7
	db $08
	dw HelpScript_EnglishPageListSeenFlag - (@ + 2)

HelpScript_EnglishPageListPage00:: ; 6C:70BA
	db $03, $01, $1B
	db $30
	db "Ｂｏｏｋｍａｒｋｓ", 0
	db "Ｉｔ’ｓ　ａｎｎｏｙｉｎｇ　ｔｏ"
	db $10
	db "ｊｕｍｐ　ｌｉｎｋｓ　ｔｏ"
	db $10
	db "ｖｉｅｗ　ｙｏｕｒ"
	db 0
	db $06
	dw HelpScript_EnglishPageListFinish - (@ + 2)

HelpScript_EnglishPageListPage01:: ; 6C:7123
	db $03, $01, $1B
	db "ｆａｖｏｒｉｔｅ　ｓｉｔｅｓ，"
	db $10
	db "ｓｏ　ｉｔ　ｈｅｌｐｓ　ｔｏ"
	db $10
	db "ｕｓｅ　Ｂｏｏｋｍａｒｋｓ．"
	db 0
	db $06
	dw HelpScript_EnglishPageListPage00 - (@ + 2)

HelpScript_EnglishPageListPage02:: ; 6C:7182
	db $03, $03, $1C
	db "Ｉｆ　ｙｏｕ　ｆｉｎｄ　ａ"
	db $10
	db "ｐａｇｅ　ｙｏｕ　ｌｉｋｅ，"
	db $10
	db "ｇｏ　ｔｏ　Ｂｏｏｋｍａｒｋｓ，"
	db 0
	db $06
	dw HelpScript_EnglishPageListPage01 - (@ + 2)

HelpScript_EnglishPageListPage03:: ; 6C:71E1
	db $03, $02, $1C
	db "ｐｉｃｋ　ａ　ｓｌｏｔ，"
	db $10
	db "ａｎｄ　ｐｒｅｓｓ　ＳＡＶＥ．"
	db 0
	db $06
	dw HelpScript_EnglishPageListPage02 - (@ + 2)

HelpScript_EnglishPageListPage04Part1:: ; 6C:721F
	db $03, $02, $1D
	db "Ｔｏ　ｖｉｅｗ　ｉｔ，"
	db $10
	db "ｓｅｌｅｃｔ　ｔｈｅ　ｐａｇｅ"
	db $10
	db 0
	db $06
	dw HelpScript_EnglishPageListPage03 - (@ + 2)

HelpScript_EnglishPageListPage04Part2:: ; 6C:725C
	db $03, $02, $1D
	db "ａｎｄ　ｐｒｅｓｓ　ＪＵＭＰ．　　　"
	db 0
	db $06
	dw HelpScript_EnglishPageListPage04Part1 - (@ + 2)

HelpScript_EnglishPageListFinish:: ; 6C:7287
	db $06
	dw HelpScript_EnglishTerminal - (@ + 2)

HelpScript_EnglishPageListSeenFlag:: ; 6C:728A
	db $10, $05, $01
	db $04
	dw HelpScript_EnglishTerminal - (@ + 2)

HelpScript_EnglishTerminal:: ; 6C:7290
	db 0

POPC
