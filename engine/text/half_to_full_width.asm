; engine/text/half_to_full_width.asm
; bank 55, $6CC6-$6E94 (462 bytes); pinned by layout.link
; Text_HalfToFullWidth and its 224-entry table

SECTION "engine/text/half_to_full_width", ROMX

Text_HalfToFullWidth:: ; 55:6CC6
	; [CONFIRMED] 72 insn(s); 72 executed (in up to 11/18 scenarios) (part of region $6C3B-$6CD4)
	sub a, $20
	ld h, $00
	ld l, a
	add hl, hl
	ld de, $6CD4
	add hl, de
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ret

; ---- text $6CD4-$6E94 (448 bytes) [PROBABLE] Shift-JIS keyboard row(s) inside the run 6CD4-6E94: clean cp932 pairs with NUL row terminators ( ！”＃＄％＆’（）＊＋，－．／０１２３); 6 executed-read range(s) of the run touch it; sits between the CONFIRMED/PROBABLE text rows of the same on-screen keyboard page [split from a merged data run by classify_g2]

PUSHC sjis
Table_Text_HalfToFullWidth:: ; 55:6CD4
String_55_6CD4::
	db "　！”＃＄％＆’（）＊＋，－．／０"
	db "１２３４５６７８９：；＜＝＞？＠Ａ"
	db "ＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲ"
	db "ＳＴＵＶＷＸＹＺ［￥］＾＿｀ａｂｃ"
	db "ｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔ"
	db "ｕｖｗｘｙｚ｛｜｝￣　　　　　　　"
	db "　　　　　　　　　　　　　　　　　"
	db "　　　　　　　　　　。「」、・ヲァ"
	db "ィゥェォャュョッーアイウエオカキク"
	db "ケコサシスセソタチツテトナニヌネノ"
	db "ハヒフヘホマミムメモヤユヨラリルレ"
	db "ロワン゛゜　　　　　　　　　　　　"
	db "　　　　　　　　　　　　　　　　　"
	db "　　　"
POPC
