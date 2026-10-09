; data/text/pokemon_names_bank53.asm
; bank 53, $4000-$8000 (16384 bytes); pinned by layout.link
; English donor name records; typed Shift-JIS bytes, reader and rendering remain unproved.

SECTION "data/text/pokemon_names_bank53", ROMX

PUSHC sjis

; ---- ptrtable $4000-$4032 (50 bytes) [PROBABLE] 25 words: ten original offsets and fifteen
; bank-53 tail targets. Raw donor pointers and NUL string extents checked; no reader is established.

Table_53_4000:: ; 53:4000
	dw String_53_7FF1
	dw String_53_7FE2
	dw $404C
	dw $4059
	dw $4066
	dw String_53_7FCD
	dw String_53_7FBC
	dw $4089
	dw $4096
	dw String_53_7FAD
	dw String_53_7F9E
	dw String_53_7F91
	dw String_53_7F7E
	dw String_53_7F6B
	dw String_53_7F58
	dw $40EF
	dw $40FC
	dw String_53_7F45
	dw $4116
	dw $4123
	dw String_53_7F32
	dw String_53_7F23
	dw String_53_7F12
	dw $4157
	dw String_53_7F01

; ---- data $4032-$4171 (319 bytes) [PROBABLE] ten typed donor strings at original offsets,
; with fifteen zero-filled former slots and six trailing zero bytes. No consumer claim.

String_53_4032:: ; 53:4032
	; [CONFIRMED] Historical neutral label retained at its original address. This former slot
	; is now thirteen zero bytes; the donor table points to $7FF1 instead. Reader remains unproved.
	ds $0D, $00
	ds $0D, $00
	db "ＴＯＧＥＰＩ", 0
	db "ＭＥＯＷＴＨ", 0
	db "ＬＵＧＩＡ", 0
	ds $0B, $00
	ds $0D, $00
	db "ＥＮＴＥＩ", 0
	ds $02, $00
	db "ＳＣＩＺＯＲ", 0
	ds $0D, $00
	ds $0D, $00
	ds $0B, $00
	ds $0D, $00
	ds $0D, $00
	ds $0D, $00
	db "ＰＩＣＨＵ", 0
	ds $02, $00
	db "ＬＥＤＹＢＡ", 0
	ds $0D, $00
	db "ＭＥＷＴＷＯ", 0
	db "ＨＯーＯＨ", 0
	ds $02, $00
	ds $0D, $00
	ds $0D, $00
	ds $0D, $00
	db "ＥＳＰＥＯＮ", 0
	ds $0D, $00

; ---- zero $4171-$7F01 (15760 bytes) [CONFIRMED] Explicit bytes of the existing linker padding;
; published English and both Japanese controls are zero throughout this bounded interval.
	ds $3D90, $00

; ---- text $7F01-$8000 (255 bytes) [PROBABLE] Fifteen contiguous fullwidth Shift-JIS donor names,
; NUL terminated. Encoding and lengths match the donor; reader, font choice and layout are unproved.

String_53_7F01:: ; 53:7F01
	db "ＰＯＲＹＧＯＮ２", 0

String_53_7F12:: ; 53:7F12
	db "ＶＥＮＵＳＡＵＲ", 0

String_53_7F23:: ; 53:7F23
	db "ＤＩＧＬＥＴＴ", 0

String_53_7F32:: ; 53:7F32
	db "ＷＯＢＢＵＦＦＥＴ", 0

String_53_7F45:: ; 53:7F45
	db "ＢＥＬＬＯＳＳＯＭ", 0

String_53_7F58:: ; 53:7F58
	db "ＳＵＤＯＷＯＯＤＯ", 0

String_53_7F6B:: ; 53:7F6B
	db "ＤＲＡＧＯＮＡＩＲ", 0

String_53_7F7E:: ; 53:7F7E
	db "ＴＹＲＡＮＩＴＡＲ", 0

String_53_7F91:: ; 53:7F91
	db "ＭＡＲＩＬＬ", 0

String_53_7F9E:: ; 53:7F9E
	db "ＵＭＢＲＥＯＮ", 0

String_53_7FAD:: ; 53:7FAD
	db "ＰＳＹＤＵＣＫ", 0

String_53_7FBC:: ; 53:7FBC
	db "ＴＯＴＯＤＩＬＥ", 0

String_53_7FCD:: ; 53:7FCD
	db "ＪＩＧＧＬＹＰＵＦＦ", 0

String_53_7FE2:: ; 53:7FE2
	db "ＰＩＫＡＣＨＵ", 0

String_53_7FF1:: ; 53:7FF1
	db "ＰＯＲＹＧＯＮ", 0

POPC
