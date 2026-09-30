; data/keyboard/pages.asm
; bank 55, $4000-$5BA2 (7074 bytes); pinned by layout.link
; keyboard start/ok cells, page pointers, page layouts, neighbour records

SECTION "data/keyboard/pages", ROMX

PUSHC sjis

; ---- data $4000-$4014 (20 bytes) [PROBABLE] 20-byte header ($0014, $0003, zeros, $4634?, $58 run) of the on-screen keyboard tables; bytes 4000-4001, 4004, 4006-400B, 400E, 4010-4013 were read by executed code (traces); fields not decoded [verifier: restored from HYPOTHESIS; the traces prove the read ranges as data (they were CONFIRMED before the merge) and the block is one 20-byte header]

Table_Kbd_StartCell:: ; 55:4000
Data_55_4000::
	db $14, $00, $03, $00, $00, $00, $00, $00, $00, $00

Table_Kbd_OkCell:: ; 55:400A
	db $34, $46, $46, $58, $58, $58, $58, $58, $58, $58

; ---- ptrtable $4014-$4046 (50 bytes) [PROBABLE] 25 words $4028...$498E (all inside the bank, ascending, the last three $4826/$48DA/$498E are $B4 apart); read by executed code; they point at the keyboard character pages below (page starts 4046, 40B2, 4142, 41D2 then every $B4 up to 498E)

Table_Kbd_PagePointers:: ; 55:4014
Table_55_4014::
	dw $4028
	dw $402A
	dw $402C
	dw $402E
	dw $4030
	dw $4032
	dw $4034
	dw $403C
	dw $403C
	dw $4044
	dw Data_Kbd_Page_Digits
	dw Data_Kbd_Page_IdChars
	dw Data_Kbd_Page_PhoneKeypad
	dw Data_Kbd_Page_Ascii3
	dw Data_Kbd_Page_Ascii4
	dw Data_Kbd_Page_Ascii5
	dw Data_Kbd_Page_T6_Hiragana
	dw Data_Kbd_Page_T6_Katakana
	dw Data_Kbd_Page_T6_FullWidthAlnum
	dw Data_Kbd_Page_T6_Symbols
	dw Data_Kbd_Page_T78_Hiragana
	dw Data_Kbd_Page_T78_Katakana
	dw Data_Kbd_Page_T78_FullWidthAlnum
	dw Data_Kbd_Page_T78_Symbols
	dw Data_Kbd_Page_T9_Ascii

; ---- data $4046-$40B2 (108 bytes) [PROBABLE] keyboard character page block (108 bytes): cells of 4 bytes (00 00 00 xx) or 2 bytes (00 xx) holding ASCII codes 0-9/a-z/A-Z with zero padding and, at the end of the page, the markers ff 83 / ff 82; page boundaries are the word-table entries at 4014 (block starts 4046/40B2/4142/41D2/4286/433A are entries, sizes $6C,$90,$90,$B4,$B4,$B4); the mapper labelled 4040-43E0 "tiles-2bpp" but the content is character codes (digits, letters, zeros), not tile data

Data_Kbd_Page_Digits:: ; 55:4046
Data_55_4046::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $31, $00, $00, $00, $32, $00, $00
	db $00, $33, $00, $00, $00, $34, $00, $00, $00, $35, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $36, $00, $00
	db $00, $37, $00, $00, $00, $38, $00, $00, $00, $39, $00, $00, $00, $30, $00, $00
	db $00, $00, $FF, $83, $00, $00, $00, $00, $FF, $82, $00, $00

; ---- data $40B2-$4142 (144 bytes) [PROBABLE] keyboard character page block (144 bytes): cells of 4 bytes (00 00 00 xx) or 2 bytes (00 xx) holding ASCII codes 0-9/a-z/A-Z with zero padding and, at the end of the page, the markers ff 83 / ff 82; page boundaries are the word-table entries at 4014 (block starts 4046/40B2/4142/41D2/4286/433A are entries, sizes $6C,$90,$90,$B4,$B4,$B4); the mapper labelled 4040-43E0 "tiles-2bpp" but the content is character codes (digits, letters, zeros), not tile data

Data_Kbd_Page_IdChars:: ; 55:40B2
Data_55_40B2::
	db $00, $31, $00, $32, $00, $33, $00, $34, $00, $35, $00, $00, $00, $36, $00, $37
	db $00, $38, $00, $39, $00, $30, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $61, $00, $62, $00, $63, $00, $64, $00, $65, $00, $00
	db $00, $66, $00, $67, $00, $68, $00, $69, $00, $6A, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $6B, $00, $6C, $00, $6D, $00, $6E
	db $00, $6F, $00, $00, $00, $70, $00, $71, $00, $72, $00, $73, $00, $74, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $75, $00, $76
	db $00, $77, $00, $78, $00, $79, $00, $00, $00, $7A, $00, $2E, $00, $40, $00, $2D
	db $00, $5F, $00, $2B, $00, $00, $FF, $83, $00, $00, $00, $00, $FF, $82, $00, $00

; ---- data $4142-$41D2 (144 bytes) [PROBABLE] keyboard character page block (144 bytes): cells of 4 bytes (00 00 00 xx) or 2 bytes (00 xx) holding ASCII codes 0-9/a-z/A-Z with zero padding and, at the end of the page, the markers ff 83 / ff 82; page boundaries are the word-table entries at 4014 (block starts 4046/40B2/4142/41D2/4286/433A are entries, sizes $6C,$90,$90,$B4,$B4,$B4); the mapper labelled 4040-43E0 "tiles-2bpp" but the content is character codes (digits, letters, zeros), not tile data

Data_Kbd_Page_PhoneKeypad:: ; 55:4142
Data_55_4142::
	db $00, $00, $00, $00, $00, $00, $00, $31, $00, $00, $00, $00, $00, $32, $00, $00
	db $00, $00, $00, $33, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $34, $00, $00, $00, $00
	db $00, $35, $00, $00, $00, $00, $00, $36, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $37
	db $00, $00, $00, $00, $00, $38, $00, $00, $00, $00, $00, $39, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $2A, $00, $00, $00, $00, $00, $30, $00, $00, $00, $00, $00, $23
	db $00, $00, $00, $00, $00, $00, $FF, $83, $00, $00, $00, $00, $FF, $82, $00, $00

; ---- data $41D2-$4286 (180 bytes) [PROBABLE] keyboard character page block (180 bytes): cells of 4 bytes (00 00 00 xx) or 2 bytes (00 xx) holding ASCII codes 0-9/a-z/A-Z with zero padding and, at the end of the page, the markers ff 83 / ff 82; page boundaries are the word-table entries at 4014 (block starts 4046/40B2/4142/41D2/4286/433A are entries, sizes $6C,$90,$90,$B4,$B4,$B4); the mapper labelled 4040-43E0 "tiles-2bpp" but the content is character codes (digits, letters, zeros), not tile data

Data_Kbd_Page_Ascii3:: ; 55:41D2
Data_55_41D2::
	db $00, $41, $00, $42, $00, $43, $00, $44, $00, $45, $00, $00, $00, $61, $00, $62
	db $00, $63, $00, $64, $00, $65, $00, $00, $00, $5A, $00, $30, $00, $31, $00, $32
	db $00, $33, $00, $34, $00, $46, $00, $47, $00, $48, $00, $49, $00, $4A, $00, $00
	db $00, $66, $00, $67, $00, $68, $00, $69, $00, $6A, $00, $00, $00, $7A, $00, $35
	db $00, $36, $00, $37, $00, $38, $00, $39, $00, $4B, $00, $4C, $00, $4D, $00, $4E
	db $00, $4F, $00, $00, $00, $6B, $00, $6C, $00, $6D, $00, $6E, $00, $6F, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $20, $00, $50, $00, $51
	db $00, $52, $00, $53, $00, $54, $00, $00, $00, $70, $00, $71, $00, $72, $00, $73
	db $00, $74, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $55, $00, $56, $00, $57, $00, $58, $00, $59, $00, $00, $00, $75, $00, $76
	db $00, $77, $00, $78, $00, $79, $00, $00, $00, $00, $FF, $83, $00, $00, $00, $00
	db $FF, $82, $00, $00

; ---- data $4286-$433A (180 bytes) [PROBABLE] keyboard character page block (180 bytes): cells of 4 bytes (00 00 00 xx) or 2 bytes (00 xx) holding ASCII codes 0-9/a-z/A-Z with zero padding and, at the end of the page, the markers ff 83 / ff 82; page boundaries are the word-table entries at 4014 (block starts 4046/40B2/4142/41D2/4286/433A are entries, sizes $6C,$90,$90,$B4,$B4,$B4); the mapper labelled 4040-43E0 "tiles-2bpp" but the content is character codes (digits, letters, zeros), not tile data

Data_Kbd_Page_Ascii4:: ; 55:4286
Data_55_4286::
	db $00, $41, $00, $42, $00, $43, $00, $44, $00, $45, $00, $00, $00, $61, $00, $62
	db $00, $63, $00, $64, $00, $65, $00, $00, $00, $5A, $00, $30, $00, $31, $00, $32
	db $00, $33, $00, $34, $00, $46, $00, $47, $00, $48, $00, $49, $00, $4A, $00, $00
	db $00, $66, $00, $67, $00, $68, $00, $69, $00, $6A, $00, $00, $00, $7A, $00, $35
	db $00, $36, $00, $37, $00, $38, $00, $39, $00, $4B, $00, $4C, $00, $4D, $00, $4E
	db $00, $4F, $00, $00, $00, $6B, $00, $6C, $00, $6D, $00, $6E, $00, $6F, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $00, $51
	db $00, $52, $00, $53, $00, $54, $00, $00, $00, $70, $00, $71, $00, $72, $00, $73
	db $00, $74, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $55, $00, $56, $00, $57, $00, $58, $00, $59, $00, $00, $00, $75, $00, $76
	db $00, $77, $00, $78, $00, $79, $00, $00, $00, $00, $FF, $83, $00, $00, $00, $00
	db $FF, $82, $00, $00

; ---- data $433A-$43EE (180 bytes) [PROBABLE] keyboard character page block (180 bytes): cells of 4 bytes (00 00 00 xx) or 2 bytes (00 xx) holding ASCII codes 0-9/a-z/A-Z with zero padding and, at the end of the page, the markers ff 83 / ff 82; page boundaries are the word-table entries at 4014 (block starts 4046/40B2/4142/41D2/4286/433A are entries, sizes $6C,$90,$90,$B4,$B4,$B4); the mapper labelled 4040-43E0 "tiles-2bpp" but the content is character codes (digits, letters, zeros), not tile data

Data_Kbd_Page_Ascii5:: ; 55:433A
Data_55_433A::
	db $00, $41, $00, $42, $00, $43, $00, $44, $00, $45, $00, $00, $00, $61, $00, $62
	db $00, $63, $00, $64, $00, $65, $00, $00, $00, $5A, $00, $30, $00, $31, $00, $32
	db $00, $33, $00, $34, $00, $46, $00, $47, $00, $48, $00, $49, $00, $4A, $00, $00
	db $00, $66, $00, $67, $00, $68, $00, $69, $00, $6A, $00, $00, $00, $7A, $00, $35
	db $00, $36, $00, $37, $00, $38, $00, $39, $00, $4B, $00, $4C, $00, $4D, $00, $4E
	db $00, $4F, $00, $00, $00, $6B, $00, $6C, $00, $6D, $00, $6E, $00, $6F, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $00, $51
	db $00, $52, $00, $53, $00, $54, $00, $00, $00, $70, $00, $71, $00, $72, $00, $73
	db $00, $74, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $55, $00, $56, $00, $57, $00, $58, $00, $59, $00, $00, $00, $75, $00, $76
	db $00, $77, $00, $78, $00, $79, $00, $00, $00, $00, $FF, $83, $00, $00, $00, $00
	db $FF, $82, $00, $00

; ---- text $43EE-$43F9 (11 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

Data_Kbd_Page_T6_Hiragana:: ; 55:43EE
String_55_43EE::
	db "あいうえお", 0

; ---- text $43F9-$4406 (13 bytes) [PROBABLE] text block: 11 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 43EE-4495 by higher-priority evidence]

String_55_43F9:: ; 55:43F9
	db 0
	db "はひふへほ", 0
	db 0

; ---- text $4406-$441D (23 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_55_4406:: ; 55:4406
	db "っゃゅょ、。かきくけこ", 0

; ---- text $441D-$442A (13 bytes) [PROBABLE] text block: 11 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 43EE-4495 by higher-priority evidence]

String_55_441D:: ; 55:441D
	db 0
	db "まみむめも", 0
	db 0

; ---- text $442A-$4441 (23 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_55_442A:: ; 55:442A
	db "ーぁぃぅぇぉさしすせそ", 0

; ---- text $4441-$444E (13 bytes) [PROBABLE] text block: 11 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 43EE-4495 by higher-priority evidence]

String_55_4441:: ; 55:4441
	db 0
	db "や　ゆ　よ", 0
	db 0

; ---- text $444E-$4465 (23 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_55_444E:: ; 55:444E
	db "・…！？～♪たちつてと", 0

; ---- text $4465-$4495 (48 bytes) [PROBABLE] text block: 11 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 43EE-4495 by higher-priority evidence]

String_55_4465:: ; 55:4465
	db 0
	db "らりるれろ", 0
	db 0
	db "「」（）", $01, $20, $01, $0D, "なにぬねの", 0
	db 0
	db "わをん゜゛", 0

; ---- data $4495-$44A4 (15 bytes) [PROBABLE] keyboard page trailer/separator bytes (00 00 ff 83 00 00 00 00 ff 82 00 00 pattern, identical to the trailers at 43E0/45FD; the ff 83 / ff 82 words are read by executed code); part of the run 4495-44A4 that executed code reads piecewise [split by classify_g2]

Data_55_4495:: ; 55:4495
	db $00, $00, $00, $FF, $83, $00, $00, $00, $00, $FF, $82, $00, $00

Data_Kbd_Page_T6_Katakana:: ; 55:44A2
	db $83, $41

; ---- text $44A4-$44BA (22 bytes) [PROBABLE] Shift-JIS keyboard row(s) NUL separated (9 double-byte chars, decodes cleanly with cp932: イウエオ||ハヒフヘホ||), between confirmed/probable text rows of the same on-screen keyboard character pages

String_55_44A4:: ; 55:44A4
	db "イウエオ", 0
	db 0
	db "ハヒフヘホ", 0
	db 0

; ---- text $44BA-$44D1 (23 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_55_44BA:: ; 55:44BA
	db "ッャュョ、。カキクケコ", 0

; ---- text $44D1-$44DE (13 bytes) [PROBABLE] Shift-JIS keyboard row(s) NUL separated (5 double-byte chars, decodes cleanly with cp932: |マミムメモ||), between confirmed/probable text rows of the same on-screen keyboard character pages

String_55_44D1:: ; 55:44D1
	db 0
	db "マミムメモ", 0
	db 0

; ---- text $44DE-$44F5 (23 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_55_44DE:: ; 55:44DE
	db "ーァィゥェォサシスセソ", 0

; ---- text $44F5-$4502 (13 bytes) [PROBABLE] Shift-JIS keyboard row(s) NUL separated (5 double-byte chars, decodes cleanly with cp932: |ヤ ユ ヨ||), between confirmed/probable text rows of the same on-screen keyboard character pages

String_55_44F5:: ; 55:44F5
	db 0
	db "ヤ　ユ　ヨ", 0
	db 0

; ---- text $4502-$4519 (23 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_55_4502:: ; 55:4502
	db "・…！？～♪タチツテト", 0

; ---- text $4519-$4532 (25 bytes) [PROBABLE] Shift-JIS keyboard row(s) NUL separated (9 double-byte chars, decodes cleanly with cp932: |ラリルレロ||「」（） ), between confirmed/probable text rows of the same on-screen keyboard character pages

String_55_4519:: ; 55:4519
	db 0
	db "ラリルレロ", 0
	db 0
	db "「」（）", $01, $20, $01, $0D

; ---- text $4532-$454A (24 bytes) [PROBABLE] Shift-JIS keyboard row(s) inside the run 4532-4554: clean cp932 pairs with NUL row terminators (ナニヌネノ||ワヲン゜゛||); 1 executed-read range(s) of the run touch it; sits between the CONFIRMED/PROBABLE text rows of the same on-screen keyboard page [split from a merged data run by classify_g2]

String_55_4532:: ; 55:4532
	db "ナニヌネノ", 0
	db 0
	db "ワヲン゜゛", 0
	db 0

; ---- data $454A-$4554 (10 bytes) [PROBABLE] keyboard page trailer/separator bytes (00 00 ff 83 00 00 00 00 ff 82 00 00 pattern, identical to the trailers at 43E0/45FD; the ff 83 / ff 82 words are read by executed code); part of the run 4532-4554 that executed code reads piecewise [split by classify_g2]

Data_55_454A:: ; 55:454A
	db $00, $00, $FF, $83, $00, $00, $00, $00, $FF, $82

; ---- text $4554-$456E (26 bytes) [PROBABLE] Shift-JIS keyboard row(s) NUL separated (10 double-byte chars, decodes cleanly with cp932: ||ＡＢＣＤＥ||ａｂｃｄｅ||), between confirmed/probable text rows of the same on-screen keyboard character pages

String_55_4554:: ; 55:4554
	db 0
	db 0

Data_Kbd_Page_T6_FullWidthAlnum:: ; 55:4556
	db "ＡＢＣＤＥ", 0
	db 0
	db "ａｂｃｄｅ", 0
	db 0

; ---- text $456E-$4585 (23 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_55_456E:: ; 55:456E
	db "Ｚ０１２３４ＦＧＨＩＪ", 0

; ---- text $4585-$45FD (120 bytes) [PROBABLE] text block: 9 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 456E-45FD by higher-priority evidence]

String_55_4585:: ; 55:4585
	db 0
	db "ｆｇｈｉｊ", 0
	db 0
	db "ｚ５６７８９ＫＬＭＮＯ", 0
	db 0
	db "ｋｌｍｎｏ", 0
	db 0
	db "．，！？：／ＰＱＲＳＴ", 0
	db 0
	db "ｐｑｒｓｔ", 0
	db 0
	db "＠－＿＋", $01, $20, $01, $0D, "ＵＶＷＸＹ", 0
	db 0
	db "ｕｖｗｘｙ", 0

; ---- data $45FD-$460A (13 bytes) [PROBABLE] keyboard page trailer/separator bytes (00 00 ff 83 00 00 00 00 ff 82 00 00 pattern, identical to the trailers at 43E0/45FD; the ff 83 / ff 82 words are read by executed code); part of the run 45FD-460A that executed code reads piecewise [split by classify_g2]

Data_55_45FD:: ; 55:45FD
	db $00, $00, $00, $FF, $83, $00, $00, $00, $00, $FF, $82, $00, $00

; ---- text $460A-$468D (131 bytes) [PROBABLE] text block: 8 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII

Data_Kbd_Page_T6_Symbols:: ; 55:460A
String_55_460A::
	db "＋－＝＃＄", 0
	db 0
	db "％＆￥！？", 0
	db 0
	db "＠０１２３４＊‘’”：", 0
	db 0
	db "；．，（）", 0
	db 0
	db "／５６７８９｛｝［］＜", 0
	db 0
	db "＞～＿＾｜", 0
	db 0
	db "・…、。ー♪「」『』【", 0
	db 0
	db "】×÷〒※", 0

; ---- text $468D-$46B0 (35 bytes) [PROBABLE] Shift-JIS keyboard rows (symbols: arrows, stars, squares; codes 01 20 / 01 0D are inline controls) NUL separated; decodes cleanly with cp932; between the text rows 460A-468D and 46BE of the same page

String_55_468D:: ; 55:468D
	db 0
	db "→←↑↓", $01, $20, $01, $0D, "★◆■▲●　☆◇□△○"

; ---- data $46B0-$46BE (14 bytes) [PROBABLE] 14-byte page trailer 00 00 00 00 ff 83 00 00 00 00 ff 82 00 00, byte-identical to the trailers at 43E0/45FD/4765 (the ff 83 / ff 82 words are read by executed code at 4498/449E/4552/4606/476E)

Data_55_46B0:: ; 55:46B0
	db $00, $00, $00, $00, $FF, $83, $00, $00, $00, $00, $FF, $82, $00, $00

; ---- text $46BE-$46C9 (11 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

Data_Kbd_Page_T78_Hiragana:: ; 55:46BE
String_55_46BE::
	db "あいうえお", 0

; ---- text $46C9-$46D6 (13 bytes) [PROBABLE] text block: 11 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 46BE-4765 by higher-priority evidence]

String_55_46C9:: ; 55:46C9
	db 0
	db "はひふへほ", 0
	db 0

; ---- text $46D6-$46ED (23 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_55_46D6:: ; 55:46D6
	db "っゃゅょ、。かきくけこ", 0

; ---- text $46ED-$46FA (13 bytes) [PROBABLE] text block: 11 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 46BE-4765 by higher-priority evidence]

String_55_46ED:: ; 55:46ED
	db 0
	db "まみむめも", 0
	db 0

; ---- text $46FA-$4711 (23 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_55_46FA:: ; 55:46FA
	db "ーぁぃぅぇぉさしすせそ", 0

; ---- text $4711-$471E (13 bytes) [PROBABLE] text block: 11 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 46BE-4765 by higher-priority evidence]

String_55_4711:: ; 55:4711
	db 0
	db "や　ゆ　よ", 0
	db 0

; ---- text $471E-$4735 (23 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_55_471E:: ; 55:471E
	db "・…！？～♪たちつてと", 0

; ---- text $4735-$4765 (48 bytes) [PROBABLE] text block: 11 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 46BE-4765 by higher-priority evidence]

String_55_4735:: ; 55:4735
	db 0
	db "らりるれろ", 0
	db 0
	db "「」（）　", $01, $20, "なにぬねの", 0
	db 0
	db "わをん゜゛", 0

; ---- data $4765-$4771 (12 bytes) [PROBABLE] keyboard page trailer/separator bytes (00 00 ff 83 00 00 00 00 ff 82 00 00 pattern, identical to the trailers at 43E0/45FD; the ff 83 / ff 82 words are read by executed code); part of the run 4765-477A that executed code reads piecewise [split by classify_g2]

Data_55_4765:: ; 55:4765
	db $00, $00, $00, $FF, $83, $00, $00, $00, $00, $FF, $82, $00

; ---- text $4771-$477A (9 bytes) [PROBABLE] Shift-JIS keyboard row(s) inside the run 4765-477A: clean cp932 pairs with NUL row terminators (|アイウエ); 1 executed-read range(s) of the run touch it; sits between the CONFIRMED/PROBABLE text rows of the same on-screen keyboard page [split from a merged data run by classify_g2]

String_55_4771:: ; 55:4771
	db 0

Data_Kbd_Page_T78_Katakana:: ; 55:4772
	db "アイウエ"

; ---- text $477A-$478A (16 bytes) [PROBABLE] Shift-JIS keyboard row(s) NUL separated (6 double-byte chars, decodes cleanly with cp932: オ||ハヒフヘホ||), between confirmed/probable text rows of the same on-screen keyboard character pages

String_55_477A:: ; 55:477A
	db "オ", 0
	db 0
	db "ハヒフヘホ", 0
	db 0

; ---- text $478A-$47A1 (23 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_55_478A:: ; 55:478A
	db "ッャュョ、。カキクケコ", 0

; ---- text $47A1-$47AE (13 bytes) [PROBABLE] Shift-JIS keyboard row(s) NUL separated (5 double-byte chars, decodes cleanly with cp932: |マミムメモ||), between confirmed/probable text rows of the same on-screen keyboard character pages

String_55_47A1:: ; 55:47A1
	db 0
	db "マミムメモ", 0
	db 0

; ---- text $47AE-$47C5 (23 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_55_47AE:: ; 55:47AE
	db "ーァィゥェォサシスセソ", 0

; ---- text $47C5-$47D2 (13 bytes) [PROBABLE] Shift-JIS keyboard row(s) NUL separated (5 double-byte chars, decodes cleanly with cp932: |ヤ ユ ヨ||), between confirmed/probable text rows of the same on-screen keyboard character pages

String_55_47C5:: ; 55:47C5
	db 0
	db "ヤ　ユ　ヨ", 0
	db 0

; ---- text $47D2-$47E9 (23 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_55_47D2:: ; 55:47D2
	db "・…！？～♪タチツテト", 0

; ---- text $47E9-$481A (49 bytes) [PROBABLE] Shift-JIS keyboard row(s) inside the run 47E9-482E: clean cp932 pairs with NUL row terminators (|ラリルレロ||「」（） ^ ナニヌネノ); 0 executed-read range(s) of the run touch it; sits between the CONFIRMED/PROBABLE text rows of the same on-screen keyboard page [split from a merged data run by classify_g2]

String_55_47E9:: ; 55:47E9
	db 0
	db "ラリルレロ", 0
	db 0
	db "「」（）　", $01, $20, "ナニヌネノ", 0
	db 0
	db "ワヲン゜゛", 0
	db 0

; ---- data $481A-$4825 (11 bytes) [PROBABLE] keyboard page trailer/separator bytes (00 00 ff 83 00 00 00 00 ff 82 00 00 pattern, identical to the trailers at 43E0/45FD; the ff 83 / ff 82 words are read by executed code); part of the run 47E9-482E that executed code reads piecewise [split by classify_g2]

Data_55_481A:: ; 55:481A
	db $00, $00, $FF, $83, $00, $00, $00, $00, $FF, $82, $00

; ---- text $4825-$482E (9 bytes) [PROBABLE] Shift-JIS keyboard row(s) inside the run 47E9-482E: clean cp932 pairs with NUL row terminators (|ＡＢＣＤ); 1 executed-read range(s) of the run touch it; sits between the CONFIRMED/PROBABLE text rows of the same on-screen keyboard page [split from a merged data run by classify_g2]

String_55_4825:: ; 55:4825
	db 0

Data_Kbd_Page_T78_FullWidthAlnum:: ; 55:4826
	db "ＡＢＣＤ"

; ---- text $482E-$483E (16 bytes) [PROBABLE] Shift-JIS keyboard row(s) NUL separated (6 double-byte chars, decodes cleanly with cp932: Ｅ||ａｂｃｄｅ||), between confirmed/probable text rows of the same on-screen keyboard character pages

String_55_482E:: ; 55:482E
	db "Ｅ", 0
	db 0
	db "ａｂｃｄｅ", 0
	db 0

; ---- text $483E-$4855 (23 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_55_483E:: ; 55:483E
	db "Ｚ０１２３４ＦＧＨＩＪ", 0

; ---- text $4855-$48CD (120 bytes) [PROBABLE] text block: 9 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 483E-48CD by higher-priority evidence]

String_55_4855:: ; 55:4855
	db 0
	db "ｆｇｈｉｊ", 0
	db 0
	db "ｚ５６７８９ＫＬＭＮＯ", 0
	db 0
	db "ｋｌｍｎｏ", 0
	db 0
	db "．，！？：／ＰＱＲＳＴ", 0
	db 0
	db "ｐｑｒｓｔ", 0
	db 0
	db "＠－＿＋　", $01, $20, "ＵＶＷＸＹ", 0
	db 0
	db "ｕｖｗｘｙ", 0

; ---- data $48CD-$48DA (13 bytes) [PROBABLE] keyboard page trailer/separator bytes (00 00 ff 83 00 00 00 00 ff 82 00 00 pattern, identical to the trailers at 43E0/45FD; the ff 83 / ff 82 words are read by executed code); part of the run 48CD-48DA that executed code reads piecewise [split by classify_g2]

Data_55_48CD:: ; 55:48CD
	db $00, $00, $00, $FF, $83, $00, $00, $00, $00, $FF, $82, $00, $00

; ---- text $48DA-$495D (131 bytes) [PROBABLE] text block: 8 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII

Data_Kbd_Page_T78_Symbols:: ; 55:48DA
String_55_48DA::
	db "＋－＝＃＄", 0
	db 0
	db "％＆￥！？", 0
	db 0
	db "＠０１２３４＊‘’”：", 0
	db 0
	db "；．，（）", 0
	db 0
	db "／５６７８９｛｝［］＜", 0
	db 0
	db "＞～＿＾｜", 0
	db 0
	db "・…、。ー♪「」『』【", 0
	db 0
	db "】×÷〒※", 0

; ---- text $495D-$4982 (37 bytes) [PROBABLE] Shift-JIS keyboard row(s) (arrows, spaces; 01 20 inline control) NUL separated, clean cp932; between the text rows 48DA-495D and the page trailer at 4982

String_55_495D:: ; 55:495D
	db 0
	db "→←↑↓　", $01, $20, "★◆■▲●　☆◇□△○", 0
	db 0

; ---- data $4982-$498E (12 bytes) [PROBABLE] 12-byte page trailer 00 00 ff 83 00 00 00 00 ff 82 00 00 (same marker pattern as 43E0/45FD; the ff 83 / ff 82 words are read by executed code)

Data_55_4982:: ; 55:4982
	db $00, $00, $FF, $83, $00, $00, $00, $00, $FF, $82, $00, $00

; ---- data $498E-$4A42 (180 bytes) [PROBABLE] last keyboard character page (block $B4 from the table at 4014, entry 498E): 16-bit cells 00 41 00 42 ... 00 5A / 00 61 ... 00 7A / 00 30 ... (Latin letters and digits as 00 xx words); parts read by executed code

Data_Kbd_Page_T9_Ascii:: ; 55:498E
Data_55_498E::
	db $00, $41, $00, $42, $00, $43, $00, $44, $00, $45, $00, $00, $00, $61, $00, $62
	db $00, $63, $00, $64, $00, $65, $00, $00, $00, $5A, $00, $30, $00, $31, $00, $32
	db $00, $33, $00, $34, $00, $46, $00, $47, $00, $48, $00, $49, $00, $4A, $00, $00
	db $00, $66, $00, $67, $00, $68, $00, $69, $00, $6A, $00, $00, $00, $7A, $00, $35
	db $00, $36, $00, $37, $00, $38, $00, $39, $00, $4B, $00, $4C, $00, $4D, $00, $4E
	db $00, $4F, $00, $00, $00, $6B, $00, $6C, $00, $6D, $00, $6E, $00, $6F, $00, $00
	db $00, $2E, $00, $40, $00, $2D, $00, $5F, $00, $2B, $00, $00, $00, $50, $00, $51
	db $00, $52, $00, $53, $00, $54, $00, $00, $00, $70, $00, $71, $00, $72, $00, $73
	db $00, $74, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $55, $00, $56, $00, $57, $00, $58, $00, $59, $00, $00, $00, $75, $00, $76
	db $00, $77, $00, $78, $00, $79, $00, $00, $00, $00, $FF, $83, $00, $00, $00, $00
	db $FF, $82, $00, $00

; ---- words $4A42-$4A56 (20 bytes) [PROBABLE] 10 words $4A56,$4B9A,$4D4A,$4EFA,$5116,$5332,$554E,$576A,$576A,$5986 read by executed code; the first target equals the table end and the targets tile the bytes up to the code at $5BA2 exactly (block sizes $144,$1B0,$1B0,$21C x5 = 54/72/90 six-byte records)

Table_Kbd_NeighbourRecords:: ; 55:4A42
Table_55_4A42::
	dw Data_Kbd_T0_NeighbourRecords, Data_Kbd_T1_NeighbourRecords, Data_Kbd_T2_NeighbourRecords, Data_Kbd_T3_NeighbourRecords, Data_Kbd_T4_NeighbourRecords, Data_Kbd_T5_NeighbourRecords, Data_Kbd_T6_NeighbourRecords, Data_Kbd_T78_NeighbourRecords
	dw Data_Kbd_T78_NeighbourRecords, Data_Kbd_T9_NeighbourRecords

; ---- data $4A56-$4B9A (324 bytes) [PROBABLE] keyboard cursor/neighbour record block (324 bytes = 54 records of 6 bytes, e.g. "58 23 00 20 23 13", "00 24 00 00 12 14"), start given by the word table at 4A42, extents tile exactly; parts read by executed code; field meaning not decoded; the mapper labelled 4A51-4F61 "tiles-2bpp" but the bytes are small indices and zeros in 6-byte rows

Data_Kbd_T0_NeighbourRecords:: ; 55:4A56
Data_55_4A56::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $34, $16, $26, $26, $00, $08, $00, $00
	db $00, $00, $00, $00, $14, $18, $28, $28, $00, $00, $00, $00, $00, $00, $00, $00
	db $16, $1A, $2A, $2A, $00, $00, $00, $00, $00, $00, $00, $00, $18, $1C, $2C, $2C
	db $00, $00, $00, $00, $00, $00, $00, $00, $1A, $31, $2E, $2E, $00, $04, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $34, $28, $14, $14, $00, $08, $00, $00, $00, $00, $00, $00
	db $26, $2A, $16, $16, $00, $00, $00, $00, $00, $00, $00, $00, $28, $2C, $18, $18
	db $00, $00, $00, $00, $00, $00, $00, $00, $2A, $2E, $1A, $1A, $00, $00, $00, $00
	db $00, $00, $00, $00, $2C, $31, $1C, $1C, $00, $04, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $2E, $34, $31, $31, $80, $0C, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $31, $26, $34, $34, $40, $0C, $00, $00
	db $00, $00, $00, $00

; ---- data $4B9A-$4D4A (432 bytes) [PROBABLE] keyboard cursor/neighbour record block (432 bytes = 72 records of 6 bytes, e.g. "58 23 00 20 23 13", "00 24 00 00 12 14"), start given by the word table at 4A42, extents tile exactly; parts read by executed code; field meaning not decoded; the mapper labelled 4A51-4F61 "tiles-2bpp" but the bytes are small indices and zeros in 6-byte rows

Data_Kbd_T1_NeighbourRecords:: ; 55:4B9A
Data_55_4B9A::
	db $46, $01, $36, $12, $00, $08, $00, $02, $37, $13, $00, $00, $01, $03, $38, $14
	db $00, $00, $02, $04, $39, $15, $00, $00, $03, $06, $3A, $16, $00, $00, $00, $00
	db $00, $00, $00, $00, $04, $07, $3C, $18, $00, $00, $06, $08, $3D, $19, $00, $00
	db $07, $09, $3E, $1A, $00, $00, $08, $0A, $3F, $1B, $00, $00, $09, $43, $40, $1C
	db $00, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $46, $13, $00, $24
	db $00, $08, $12, $14, $01, $25, $00, $00, $13, $15, $02, $26, $00, $00, $14, $16
	db $03, $27, $00, $00, $15, $18, $04, $28, $00, $00, $00, $00, $00, $00, $00, $00
	db $16, $19, $06, $2A, $00, $00, $18, $1A, $07, $2B, $00, $00, $19, $1B, $08, $2C
	db $00, $00, $1A, $1C, $09, $2D, $00, $00, $1B, $43, $0A, $2E, $00, $04, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $46, $25, $12, $36, $00, $08, $24, $26
	db $13, $37, $00, $00, $25, $27, $14, $38, $00, $00, $26, $28, $15, $39, $00, $00
	db $27, $2A, $16, $3A, $00, $00, $00, $00, $00, $00, $00, $00, $28, $2B, $18, $3C
	db $00, $00, $2A, $2C, $19, $3D, $00, $00, $2B, $2D, $1A, $3E, $00, $00, $2C, $2E
	db $1B, $3F, $00, $00, $2D, $43, $1C, $40, $00, $04, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $46, $37, $24, $00, $00, $08, $36, $38, $25, $01, $00, $00
	db $37, $39, $26, $02, $00, $00, $38, $3A, $27, $03, $00, $00, $39, $3C, $28, $04
	db $00, $00, $00, $00, $00, $00, $00, $00, $3A, $3D, $2A, $06, $00, $00, $3C, $3E
	db $2B, $07, $00, $00, $3D, $3F, $2C, $08, $00, $00, $3E, $40, $2D, $09, $00, $00
	db $3F, $41, $2E, $0A, $00, $00, $40, $43, $2E, $0A, $00, $44, $00, $00, $00, $00
	db $00, $00, $2E, $46, $43, $43, $80, $0C, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $43, $36, $46, $46, $40, $0C, $00, $00, $00, $00, $00, $00

; ---- data $4D4A-$4EFA (432 bytes) [PROBABLE] keyboard cursor/neighbour record block (432 bytes = 72 records of 6 bytes, e.g. "58 23 00 20 23 13", "00 24 00 00 12 14"), start given by the word table at 4A42, extents tile exactly; parts read by executed code; field meaning not decoded; the mapper labelled 4A51-4F61 "tiles-2bpp" but the bytes are small indices and zeros in 6-byte rows

Data_Kbd_T2_NeighbourRecords:: ; 55:4D4A
Data_55_4D4A::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $46, $06, $39, $15, $00, $08, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $03, $09, $3C, $18, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $06, $43, $3F, $1B, $00, $04, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $46, $18
	db $03, $27, $00, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $15, $1B, $06, $2A, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $18, $43, $09, $2D, $00, $04, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $46, $2A, $15, $39, $00, $08
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $27, $2D, $18, $3C
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2A, $43
	db $1B, $3F, $00, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $46, $3C, $27, $03, $00, $08, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $39, $3F, $2A, $06, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3C, $43, $2D, $09, $00, $04
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $3F, $46, $43, $43, $80, $0C, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $43, $39, $46, $46, $40, $0C, $00, $00, $00, $00, $00, $00

; ---- data $4EFA-$5116 (540 bytes) [PROBABLE] keyboard cursor/neighbour record block (540 bytes = 90 records of 6 bytes, e.g. "58 23 00 20 23 13", "00 24 00 00 12 14"), start given by the word table at 4A42, extents tile exactly; parts read by executed code; field meaning not decoded; the mapper labelled 4A51-4F61 "tiles-2bpp" but the bytes are small indices and zeros in 6-byte rows

Data_Kbd_T3_NeighbourRecords:: ; 55:4EFA
Data_55_4EFA::
	db $11, $01, $48, $12, $00, $00, $00, $02, $49, $13, $00, $00, $01, $03, $4A, $14
	db $00, $00, $02, $04, $4B, $15, $00, $00, $03, $06, $4C, $16, $00, $00, $00, $00
	db $00, $00, $00, $00, $04, $07, $4E, $18, $00, $00, $06, $08, $4F, $19, $00, $00
	db $07, $09, $50, $1A, $00, $00, $08, $0A, $51, $1B, $00, $00, $09, $0C, $52, $1C
	db $00, $00, $00, $00, $00, $00, $00, $00, $0A, $0D, $55, $1E, $00, $20, $0C, $0E
	db $55, $1F, $00, $20, $0D, $0F, $55, $20, $00, $20, $0E, $10, $58, $21, $00, $20
	db $0F, $11, $58, $22, $00, $20, $10, $00, $58, $23, $00, $20, $23, $13, $00, $24
	db $00, $00, $12, $14, $01, $25, $00, $00, $13, $15, $02, $26, $00, $00, $14, $16
	db $03, $27, $00, $00, $15, $18, $04, $28, $00, $00, $00, $00, $00, $00, $00, $00
	db $16, $19, $06, $2A, $00, $00, $18, $1A, $07, $2B, $00, $00, $19, $1B, $08, $2C
	db $00, $00, $1A, $1C, $09, $2D, $00, $00, $1B, $1E, $0A, $2E, $00, $00, $00, $00
	db $00, $00, $00, $00, $1C, $1F, $0C, $55, $00, $10, $1E, $20, $0D, $55, $00, $10
	db $1F, $21, $0E, $55, $00, $10, $20, $22, $0F, $58, $00, $10, $21, $23, $10, $58
	db $00, $10, $22, $12, $11, $35, $00, $00, $35, $25, $12, $36, $00, $00, $24, $26
	db $13, $37, $00, $00, $25, $27, $14, $38, $00, $00, $26, $28, $15, $39, $00, $00
	db $27, $2A, $16, $3A, $00, $00, $00, $00, $00, $00, $00, $00, $28, $2B, $18, $3C
	db $00, $00, $2A, $2C, $19, $3D, $00, $00, $2B, $2D, $1A, $3E, $00, $00, $2C, $2E
	db $1B, $3F, $00, $00, $2D, $35, $1C, $40, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2E, $24
	db $23, $58, $00, $10, $58, $37, $24, $48, $00, $08, $36, $38, $25, $49, $00, $00
	db $37, $39, $26, $4A, $00, $00, $38, $3A, $27, $4B, $00, $00, $39, $3C, $28, $4C
	db $00, $00, $00, $00, $00, $00, $00, $00, $3A, $3D, $2A, $4E, $00, $00, $3C, $3E
	db $2B, $4F, $00, $00, $3D, $3F, $2C, $50, $00, $00, $3E, $40, $2D, $51, $00, $00
	db $3F, $55, $2E, $52, $00, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $58, $49, $36, $00, $00, $08, $48, $4A, $37, $01, $00, $00, $49, $4B, $38, $02
	db $00, $00, $4A, $4C, $39, $03, $00, $00, $4B, $4E, $3A, $04, $00, $00, $00, $00
	db $00, $00, $00, $00, $4C, $4F, $3C, $06, $00, $00, $4E, $50, $3D, $07, $00, $00
	db $4F, $51, $3E, $08, $00, $00, $50, $52, $3F, $09, $00, $00, $51, $55, $40, $0A
	db $00, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $52, $58
	db $1F, $0D, $B0, $3C, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $55, $48, $22, $10, $70, $3C, $00, $00, $00, $00, $00, $00

; ---- data $5116-$5332 (540 bytes) [PROBABLE] keyboard cursor/neighbour record block (540 bytes = 90 records of 6 bytes, e.g. "58 23 00 20 23 13", "00 24 00 00 12 14"), start given by the word table at 4A42, extents tile exactly; parts read by executed code; field meaning not decoded; the mapper labelled 4A51-4F61 "tiles-2bpp" but the bytes are small indices and zeros in 6-byte rows

Data_Kbd_T4_NeighbourRecords:: ; 55:5116
Data_55_5116::
	db $11, $01, $48, $12, $00, $00, $00, $02, $49, $13, $00, $00, $01, $03, $4A, $14
	db $00, $00, $02, $04, $4B, $15, $00, $00, $03, $06, $4C, $16, $00, $00, $00, $00
	db $00, $00, $00, $00, $04, $07, $4E, $18, $00, $00, $06, $08, $4F, $19, $00, $00
	db $07, $09, $50, $1A, $00, $00, $08, $0A, $51, $1B, $00, $00, $09, $0C, $52, $1C
	db $00, $00, $00, $00, $00, $00, $00, $00, $0A, $0D, $55, $1E, $00, $20, $0C, $0E
	db $55, $1F, $00, $20, $0D, $0F, $55, $20, $00, $20, $0E, $10, $58, $21, $00, $20
	db $0F, $11, $58, $22, $00, $20, $10, $00, $58, $23, $00, $20, $23, $13, $00, $24
	db $00, $00, $12, $14, $01, $25, $00, $00, $13, $15, $02, $26, $00, $00, $14, $16
	db $03, $27, $00, $00, $15, $18, $04, $28, $00, $00, $00, $00, $00, $00, $00, $00
	db $16, $19, $06, $2A, $00, $00, $18, $1A, $07, $2B, $00, $00, $19, $1B, $08, $2C
	db $00, $00, $1A, $1C, $09, $2D, $00, $00, $1B, $1E, $0A, $2E, $00, $00, $00, $00
	db $00, $00, $00, $00, $1C, $1F, $0C, $55, $00, $10, $1E, $20, $0D, $55, $00, $10
	db $1F, $21, $0E, $55, $00, $10, $20, $22, $0F, $58, $00, $10, $21, $23, $10, $58
	db $00, $10, $22, $12, $11, $58, $00, $10, $58, $25, $12, $36, $00, $08, $24, $26
	db $13, $37, $00, $00, $25, $27, $14, $38, $00, $00, $26, $28, $15, $39, $00, $00
	db $27, $2A, $16, $3A, $00, $00, $00, $00, $00, $00, $00, $00, $28, $2B, $18, $3C
	db $00, $00, $2A, $2C, $19, $3D, $00, $00, $2B, $2D, $1A, $3E, $00, $00, $2C, $2E
	db $1B, $3F, $00, $00, $2D, $55, $1C, $40, $00, $04, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $58, $37, $24, $48, $00, $08, $36, $38, $25, $49, $00, $00
	db $37, $39, $26, $4A, $00, $00, $38, $3A, $27, $4B, $00, $00, $39, $3C, $28, $4C
	db $00, $00, $00, $00, $00, $00, $00, $00, $3A, $3D, $2A, $4E, $00, $00, $3C, $3E
	db $2B, $4F, $00, $00, $3D, $3F, $2C, $50, $00, $00, $3E, $40, $2D, $51, $00, $00
	db $3F, $55, $2E, $52, $00, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $58, $49, $36, $00, $00, $08, $48, $4A, $37, $01, $00, $00, $49, $4B, $38, $02
	db $00, $00, $4A, $4C, $39, $03, $00, $00, $4B, $4E, $3A, $04, $00, $00, $00, $00
	db $00, $00, $00, $00, $4C, $4F, $3C, $06, $00, $00, $4E, $50, $3D, $07, $00, $00
	db $4F, $51, $3E, $08, $00, $00, $50, $52, $3F, $09, $00, $00, $51, $55, $40, $0A
	db $00, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $52, $58
	db $1F, $0D, $B0, $3C, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $55, $48, $22, $10, $70, $3C, $00, $00, $00, $00, $00, $00

; ---- data $5332-$554E (540 bytes) [PROBABLE] keyboard cursor/neighbour record block (540 bytes = 90 records of 6 bytes, e.g. "58 23 00 20 23 13", "00 24 00 00 12 14"), start given by the word table at 4A42, extents tile exactly; parts read by executed code; field meaning not decoded; the mapper labelled 4A51-4F61 "tiles-2bpp" but the bytes are small indices and zeros in 6-byte rows

Data_Kbd_T5_NeighbourRecords:: ; 55:5332
Data_55_5332::
	db $11, $01, $48, $12, $00, $00, $00, $02, $49, $13, $00, $00, $01, $03, $4A, $14
	db $00, $00, $02, $04, $4B, $15, $00, $00, $03, $06, $4C, $16, $00, $00, $00, $00
	db $00, $00, $00, $00, $04, $07, $4E, $18, $00, $00, $06, $08, $4F, $19, $00, $00
	db $07, $09, $50, $1A, $00, $00, $08, $0A, $51, $1B, $00, $00, $09, $0C, $52, $1C
	db $00, $00, $00, $00, $00, $00, $00, $00, $0A, $0D, $55, $1E, $00, $20, $0C, $0E
	db $55, $1F, $00, $20, $0D, $0F, $55, $20, $00, $20, $0E, $10, $58, $21, $00, $20
	db $0F, $11, $58, $22, $00, $20, $10, $00, $58, $23, $00, $20, $23, $13, $00, $24
	db $00, $00, $12, $14, $01, $25, $00, $00, $13, $15, $02, $26, $00, $00, $14, $16
	db $03, $27, $00, $00, $15, $18, $04, $28, $00, $00, $00, $00, $00, $00, $00, $00
	db $16, $19, $06, $2A, $00, $00, $18, $1A, $07, $2B, $00, $00, $19, $1B, $08, $2C
	db $00, $00, $1A, $1C, $09, $2D, $00, $00, $1B, $1E, $0A, $2E, $00, $00, $00, $00
	db $00, $00, $00, $00, $1C, $1F, $0C, $55, $00, $10, $1E, $20, $0D, $55, $00, $10
	db $1F, $21, $0E, $55, $00, $10, $20, $22, $0F, $58, $00, $10, $21, $23, $10, $58
	db $00, $10, $22, $12, $11, $58, $00, $10, $58, $25, $12, $36, $00, $08, $24, $26
	db $13, $37, $00, $00, $25, $27, $14, $38, $00, $00, $26, $28, $15, $39, $00, $00
	db $27, $2A, $16, $3A, $00, $00, $00, $00, $00, $00, $00, $00, $28, $2B, $18, $3C
	db $00, $00, $2A, $2C, $19, $3D, $00, $00, $2B, $2D, $1A, $3E, $00, $00, $2C, $2E
	db $1B, $3F, $00, $00, $2D, $55, $1C, $40, $00, $04, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $58, $37, $24, $48, $00, $08, $36, $38, $25, $49, $00, $00
	db $37, $39, $26, $4A, $00, $00, $38, $3A, $27, $4B, $00, $00, $39, $3C, $28, $4C
	db $00, $00, $00, $00, $00, $00, $00, $00, $3A, $3D, $2A, $4E, $00, $00, $3C, $3E
	db $2B, $4F, $00, $00, $3D, $3F, $2C, $50, $00, $00, $3E, $40, $2D, $51, $00, $00
	db $3F, $55, $2E, $52, $00, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $58, $49, $36, $00, $00, $08, $48, $4A, $37, $01, $00, $00, $49, $4B, $38, $02
	db $00, $00, $4A, $4C, $39, $03, $00, $00, $4B, $4E, $3A, $04, $00, $00, $00, $00
	db $00, $00, $00, $00, $4C, $4F, $3C, $06, $00, $00, $4E, $50, $3D, $07, $00, $00
	db $4F, $51, $3E, $08, $00, $00, $50, $52, $3F, $09, $00, $00, $51, $55, $40, $0A
	db $00, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $52, $58
	db $1F, $0D, $B0, $3C, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $55, $48, $22, $10, $70, $3C, $00, $00, $00, $00, $00, $00

; ---- data $554E-$576A (540 bytes) [PROBABLE] keyboard cursor/neighbour record block (540 bytes = 90 records of 6 bytes, e.g. "58 23 00 20 23 13", "00 24 00 00 12 14"), start given by the word table at 4A42, extents tile exactly; parts read by executed code; field meaning not decoded; the mapper labelled 4A51-4F61 "tiles-2bpp" but the bytes are small indices and zeros in 6-byte rows

Data_Kbd_T6_NeighbourRecords:: ; 55:554E
Data_55_554E::
	db $11, $01, $48, $12, $00, $00, $00, $02, $49, $13, $00, $00, $01, $03, $4A, $14
	db $00, $00, $02, $04, $4B, $15, $00, $00, $03, $06, $4C, $16, $00, $00, $00, $00
	db $00, $00, $00, $00, $04, $07, $4E, $18, $00, $00, $06, $08, $4F, $19, $00, $00
	db $07, $09, $50, $1A, $00, $00, $08, $0A, $51, $1B, $00, $00, $09, $0C, $52, $1C
	db $00, $00, $00, $00, $00, $00, $00, $00, $0A, $0D, $55, $1E, $00, $20, $0C, $0E
	db $55, $1F, $00, $20, $0D, $0F, $55, $20, $00, $20, $0E, $10, $58, $21, $00, $20
	db $0F, $11, $58, $22, $00, $20, $10, $00, $58, $23, $00, $20, $23, $13, $00, $24
	db $00, $00, $12, $14, $01, $25, $00, $00, $13, $15, $02, $26, $00, $00, $14, $16
	db $03, $27, $00, $00, $15, $18, $04, $28, $00, $00, $00, $00, $00, $00, $00, $00
	db $16, $19, $06, $2A, $00, $00, $18, $1A, $07, $2B, $00, $00, $19, $1B, $08, $2C
	db $00, $00, $1A, $1C, $09, $2D, $00, $00, $1B, $1E, $0A, $2E, $00, $00, $00, $00
	db $00, $00, $00, $00, $1C, $1F, $0C, $30, $00, $00, $1E, $20, $0D, $31, $00, $00
	db $1F, $21, $0E, $32, $00, $00, $20, $22, $0F, $33, $00, $00, $21, $23, $10, $34
	db $00, $00, $22, $12, $11, $35, $00, $00, $35, $25, $12, $36, $00, $00, $24, $26
	db $13, $37, $00, $00, $25, $27, $14, $38, $00, $00, $26, $28, $15, $39, $00, $00
	db $27, $2A, $16, $3A, $00, $00, $00, $00, $00, $00, $00, $00, $28, $2B, $18, $3C
	db $00, $00, $2A, $2C, $19, $3D, $00, $00, $2B, $2D, $1A, $3E, $00, $00, $2C, $2E
	db $1B, $3F, $00, $00, $2D, $30, $1C, $40, $00, $00, $00, $00, $00, $00, $00, $00
	db $2E, $31, $1E, $42, $00, $00, $30, $32, $1F, $43, $00, $00, $31, $33, $20, $44
	db $00, $00, $32, $34, $21, $45, $00, $00, $33, $35, $22, $46, $00, $00, $34, $24
	db $23, $47, $00, $00, $47, $37, $24, $48, $00, $00, $36, $38, $25, $49, $00, $00
	db $37, $39, $26, $4A, $00, $00, $38, $3A, $27, $4B, $00, $00, $39, $3C, $28, $4C
	db $00, $00, $00, $00, $00, $00, $00, $00, $3A, $3D, $2A, $4E, $00, $00, $3C, $3E
	db $2B, $4F, $00, $00, $3D, $3F, $2C, $50, $00, $00, $3E, $40, $2D, $51, $00, $00
	db $3F, $42, $2E, $52, $00, $00, $00, $00, $00, $00, $00, $00, $40, $43, $30, $55
	db $00, $10, $42, $44, $31, $55, $00, $10, $43, $45, $32, $55, $00, $10, $44, $46
	db $33, $58, $00, $10, $45, $47, $34, $58, $00, $10, $46, $36, $35, $58, $00, $10
	db $58, $49, $36, $00, $00, $08, $48, $4A, $37, $01, $00, $00, $49, $4B, $38, $02
	db $00, $00, $4A, $4C, $39, $03, $00, $00, $4B, $4E, $3A, $04, $00, $00, $00, $00
	db $00, $00, $00, $00, $4C, $4F, $3C, $06, $00, $00, $4E, $50, $3D, $07, $00, $00
	db $4F, $51, $3E, $08, $00, $00, $50, $52, $3F, $09, $00, $00, $51, $55, $40, $0A
	db $00, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $52, $58
	db $43, $0D, $B0, $3C, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $55, $48, $46, $10, $70, $3C, $00, $00, $00, $00, $00, $00

; ---- data $576A-$5986 (540 bytes) [PROBABLE] keyboard cursor/neighbour record block (540 bytes = 90 records of 6 bytes, e.g. "58 23 00 20 23 13", "00 24 00 00 12 14"), start given by the word table at 4A42, extents tile exactly; parts read by executed code; field meaning not decoded; the mapper labelled 4A51-4F61 "tiles-2bpp" but the bytes are small indices and zeros in 6-byte rows

Data_Kbd_T78_NeighbourRecords:: ; 55:576A
Data_55_576A::
	db $11, $01, $48, $12, $00, $00, $00, $02, $49, $13, $00, $00, $01, $03, $4A, $14
	db $00, $00, $02, $04, $4B, $15, $00, $00, $03, $06, $4C, $16, $00, $00, $00, $00
	db $00, $00, $00, $00, $04, $07, $4E, $18, $00, $00, $06, $08, $4F, $19, $00, $00
	db $07, $09, $50, $1A, $00, $00, $08, $0A, $51, $1B, $00, $00, $09, $0C, $52, $1C
	db $00, $00, $00, $00, $00, $00, $00, $00, $0A, $0D, $55, $1E, $00, $20, $0C, $0E
	db $55, $1F, $00, $20, $0D, $0F, $55, $20, $00, $20, $0E, $10, $58, $21, $00, $20
	db $0F, $11, $58, $22, $00, $20, $10, $00, $58, $23, $00, $20, $23, $13, $00, $24
	db $00, $00, $12, $14, $01, $25, $00, $00, $13, $15, $02, $26, $00, $00, $14, $16
	db $03, $27, $00, $00, $15, $18, $04, $28, $00, $00, $00, $00, $00, $00, $00, $00
	db $16, $19, $06, $2A, $00, $00, $18, $1A, $07, $2B, $00, $00, $19, $1B, $08, $2C
	db $00, $00, $1A, $1C, $09, $2D, $00, $00, $1B, $1E, $0A, $2E, $00, $00, $00, $00
	db $00, $00, $00, $00, $1C, $1F, $0C, $30, $00, $00, $1E, $20, $0D, $31, $00, $00
	db $1F, $21, $0E, $32, $00, $00, $20, $22, $0F, $33, $00, $00, $21, $23, $10, $34
	db $00, $00, $22, $12, $11, $35, $00, $00, $35, $25, $12, $36, $00, $00, $24, $26
	db $13, $37, $00, $00, $25, $27, $14, $38, $00, $00, $26, $28, $15, $39, $00, $00
	db $27, $2A, $16, $3A, $00, $00, $00, $00, $00, $00, $00, $00, $28, $2B, $18, $3C
	db $00, $00, $2A, $2C, $19, $3D, $00, $00, $2B, $2D, $1A, $3E, $00, $00, $2C, $2E
	db $1B, $3F, $00, $00, $2D, $30, $1C, $40, $00, $00, $00, $00, $00, $00, $00, $00
	db $2E, $31, $1E, $42, $00, $00, $30, $32, $1F, $43, $00, $00, $31, $33, $20, $44
	db $00, $00, $32, $34, $21, $45, $00, $00, $33, $35, $22, $46, $00, $00, $34, $24
	db $23, $47, $00, $00, $47, $37, $24, $48, $00, $00, $36, $38, $25, $49, $00, $00
	db $37, $39, $26, $4A, $00, $00, $38, $3A, $27, $4B, $00, $00, $39, $3C, $28, $4C
	db $00, $00, $00, $00, $00, $00, $00, $00, $3A, $3D, $2A, $4E, $00, $00, $3C, $3E
	db $2B, $4F, $00, $00, $3D, $3F, $2C, $50, $00, $00, $3E, $40, $2D, $51, $00, $00
	db $3F, $42, $2E, $52, $00, $00, $00, $00, $00, $00, $00, $00, $40, $43, $30, $55
	db $00, $10, $42, $44, $31, $55, $00, $10, $43, $45, $32, $55, $00, $10, $44, $46
	db $33, $58, $00, $10, $45, $47, $34, $58, $00, $10, $46, $36, $35, $58, $00, $10
	db $58, $49, $36, $00, $00, $08, $48, $4A, $37, $01, $00, $00, $49, $4B, $38, $02
	db $00, $00, $4A, $4C, $39, $03, $00, $00, $4B, $4E, $3A, $04, $00, $00, $00, $00
	db $00, $00, $00, $00, $4C, $4F, $3C, $06, $00, $00, $4E, $50, $3D, $07, $00, $00
	db $4F, $51, $3E, $08, $00, $00, $50, $52, $3F, $09, $00, $00, $51, $55, $40, $0A
	db $00, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $52, $58
	db $43, $0D, $B0, $3C, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $55, $48, $46, $10, $70, $3C, $00, $00, $00, $00, $00, $00

; ---- data $5986-$5BA2 (540 bytes) [PROBABLE] keyboard cursor/neighbour record block (540 bytes = 90 records of 6 bytes, e.g. "58 23 00 20 23 13", "00 24 00 00 12 14"), start given by the word table at 4A42, extents tile exactly; parts read by executed code; field meaning not decoded; the mapper labelled 4A51-4F61 "tiles-2bpp" but the bytes are small indices and zeros in 6-byte rows

Data_Kbd_T9_NeighbourRecords:: ; 55:5986
Data_55_5986::
	db $11, $01, $48, $12, $00, $00, $00, $02, $49, $13, $00, $00, $01, $03, $4A, $14
	db $00, $00, $02, $04, $4B, $15, $00, $00, $03, $06, $4C, $16, $00, $00, $00, $00
	db $00, $00, $00, $00, $04, $07, $4E, $18, $00, $00, $06, $08, $4F, $19, $00, $00
	db $07, $09, $50, $1A, $00, $00, $08, $0A, $51, $1B, $00, $00, $09, $0C, $52, $1C
	db $00, $00, $00, $00, $00, $00, $00, $00, $0A, $0D, $55, $1E, $00, $20, $0C, $0E
	db $55, $1F, $00, $20, $0D, $0F, $55, $20, $00, $20, $0E, $10, $58, $21, $00, $20
	db $0F, $11, $58, $22, $00, $20, $10, $00, $58, $23, $00, $00, $23, $13, $00, $24
	db $00, $00, $12, $14, $01, $25, $00, $00, $13, $15, $02, $26, $00, $00, $14, $16
	db $03, $27, $00, $00, $15, $18, $04, $28, $00, $00, $00, $00, $00, $00, $00, $00
	db $16, $19, $06, $2A, $00, $00, $18, $1A, $07, $2B, $00, $00, $19, $1B, $08, $2C
	db $00, $00, $1A, $1C, $09, $2D, $00, $00, $1B, $1E, $0A, $2E, $00, $00, $00, $00
	db $00, $00, $00, $00, $1C, $1F, $0C, $30, $00, $00, $1E, $20, $0D, $31, $00, $00
	db $1F, $21, $0E, $32, $00, $00, $20, $22, $0F, $33, $00, $00, $21, $23, $10, $34
	db $00, $00, $22, $12, $11, $34, $00, $00, $34, $25, $12, $36, $00, $00, $24, $26
	db $13, $37, $00, $00, $25, $27, $14, $38, $00, $00, $26, $28, $15, $39, $00, $00
	db $27, $2A, $16, $3A, $00, $00, $00, $00, $00, $00, $00, $00, $28, $2B, $18, $3C
	db $00, $00, $2A, $2C, $19, $3D, $00, $00, $2B, $2D, $1A, $3E, $00, $00, $2C, $2E
	db $1B, $3F, $00, $00, $2D, $30, $1C, $40, $00, $00, $00, $00, $00, $00, $00, $00
	db $2E, $31, $1E, $55, $00, $10, $30, $32, $1F, $55, $00, $10, $31, $33, $20, $55
	db $00, $10, $32, $34, $21, $58, $00, $10, $33, $24, $22, $58, $00, $10, $00, $00
	db $00, $00, $00, $00, $58, $37, $24, $48, $00, $08, $36, $38, $25, $49, $00, $00
	db $37, $39, $26, $4A, $00, $00, $38, $3A, $27, $4B, $00, $00, $39, $3C, $28, $4C
	db $00, $00, $00, $00, $00, $00, $00, $00, $3A, $3D, $2A, $4E, $00, $00, $3C, $3E
	db $2B, $4F, $00, $00, $3D, $3F, $2C, $50, $00, $00, $3E, $40, $2D, $51, $00, $00
	db $3F, $55, $2E, $52, $00, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $58, $49, $36, $00, $00, $00, $48, $4A, $37, $01, $00, $00, $49, $4B, $38, $02
	db $00, $00, $4A, $4C, $39, $03, $00, $00, $4B, $4E, $3A, $04, $00, $00, $00, $00
	db $00, $00, $00, $00, $4C, $4F, $3C, $06, $00, $00, $4E, $50, $3D, $07, $00, $00
	db $4F, $51, $3E, $08, $00, $00, $50, $52, $3F, $09, $00, $00, $51, $55, $40, $0A
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $52, $58
	db $31, $0D, $B0, $3C, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $55, $48, $34, $10, $70, $3C, $00, $00, $00, $00, $00, $00

POPC
