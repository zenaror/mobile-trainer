; data/text/pokemon_names_bank53.asm
; bank 53, $4000-$8000 (16384 bytes); pinned by layout.link
; English donor name records; typed Shift-JIS bytes, reader and rendering remain unproved.

SECTION "data/text/pokemon_names_bank53", ROMX

PUSHC sjis

; ---- ptrtable $4000-$4032 (50 bytes) [PROBABLE] 25 words: ten original offsets and fifteen
; bank-53 tail targets. Raw donor pointers and NUL string extents checked; no reader is established.

Table_53_4000:: ; 53:4000
	dw PokemonName00
	dw PokemonName01
	dw PokemonName02
	dw PokemonName03
	dw PokemonName04
	dw PokemonName05
	dw PokemonName06
	dw PokemonName07
	dw PokemonName08
	dw PokemonName09
	dw PokemonName10
	dw PokemonName11
	dw PokemonName12
	dw PokemonName13
	dw PokemonName14
	dw PokemonName15
	dw PokemonName16
	dw PokemonName17
	dw PokemonName18
	dw PokemonName19
	dw PokemonName20
	dw PokemonName21
	dw PokemonName22
	dw PokemonName23
	dw PokemonName24

; ---- data $4032-$4171 (319 bytes) [PROBABLE] ten typed donor strings at original offsets,
; with fifteen zero-filled former slots and six trailing zero bytes. No consumer claim.

String_53_4032:: ; 53:4032
	; [CONFIRMED] Historical neutral label retained at its original address. This former slot
	; is now thirteen zero bytes; the donor table points to $7FF1 instead. Reader remains unproved.
	ds $0D, $00
	ds $0D, $00
PokemonName02:: ; 53:404C (English table ordinal; language-specific address)
	db "ＴＯＧＥＰＩ", 0
PokemonName03:: ; 53:4059 (English table ordinal; language-specific address)
	db "ＭＥＯＷＴＨ", 0
PokemonName04:: ; 53:4066 (English table ordinal; language-specific address)
	db "ＬＵＧＩＡ", 0
	ds $0B, $00
	ds $0D, $00
PokemonName07:: ; 53:4089 (English table ordinal; language-specific address)
	db "ＥＮＴＥＩ", 0
	ds $02, $00
PokemonName08:: ; 53:4096 (English table ordinal; language-specific address)
	db "ＳＣＩＺＯＲ", 0
	ds $0D, $00
	ds $0D, $00
	ds $0B, $00
	ds $0D, $00
	ds $0D, $00
	ds $0D, $00
PokemonName15:: ; 53:40EF (English table ordinal; language-specific address)
	db "ＰＩＣＨＵ", 0
	ds $02, $00
PokemonName16:: ; 53:40FC (English table ordinal; language-specific address)
	db "ＬＥＤＹＢＡ", 0
	ds $0D, $00
PokemonName18:: ; 53:4116 (English table ordinal; language-specific address)
	db "ＭＥＷＴＷＯ", 0
PokemonName19:: ; 53:4123 (English table ordinal; language-specific address)
	db "ＨＯーＯＨ", 0
	ds $02, $00
	ds $0D, $00
	ds $0D, $00
	ds $0D, $00
PokemonName23:: ; 53:4157 (English table ordinal; language-specific address)
	db "ＥＳＰＥＯＮ", 0
	ds $0D, $00

; ---- zero $4171-$7F01 (15760 bytes) [CONFIRMED] Explicit bytes of the existing linker padding;
; published English and both Japanese controls are zero throughout this bounded interval.
	ds $3D90, $00

; ---- text $7F01-$8000 (255 bytes) [PROBABLE] Fifteen contiguous fullwidth Shift-JIS donor names,
; NUL terminated. Encoding and lengths match the donor; reader, font choice and layout are unproved.

String_53_7F01:: ; 53:7F01
PokemonName24:: ; 53:7F01 (English table ordinal; language-specific address)
	db "ＰＯＲＹＧＯＮ２", 0

String_53_7F12:: ; 53:7F12
PokemonName22:: ; 53:7F12 (English table ordinal; language-specific address)
	db "ＶＥＮＵＳＡＵＲ", 0

String_53_7F23:: ; 53:7F23
PokemonName21:: ; 53:7F23 (English table ordinal; language-specific address)
	db "ＤＩＧＬＥＴＴ", 0

String_53_7F32:: ; 53:7F32
PokemonName20:: ; 53:7F32 (English table ordinal; language-specific address)
	db "ＷＯＢＢＵＦＦＥＴ", 0

String_53_7F45:: ; 53:7F45
PokemonName17:: ; 53:7F45 (English table ordinal; language-specific address)
	db "ＢＥＬＬＯＳＳＯＭ", 0

String_53_7F58:: ; 53:7F58
PokemonName14:: ; 53:7F58 (English table ordinal; language-specific address)
	db "ＳＵＤＯＷＯＯＤＯ", 0

String_53_7F6B:: ; 53:7F6B
PokemonName13:: ; 53:7F6B (English table ordinal; language-specific address)
	db "ＤＲＡＧＯＮＡＩＲ", 0

String_53_7F7E:: ; 53:7F7E
PokemonName12:: ; 53:7F7E (English table ordinal; language-specific address)
	db "ＴＹＲＡＮＩＴＡＲ", 0

String_53_7F91:: ; 53:7F91
PokemonName11:: ; 53:7F91 (English table ordinal; language-specific address)
	db "ＭＡＲＩＬＬ", 0

String_53_7F9E:: ; 53:7F9E
PokemonName10:: ; 53:7F9E (English table ordinal; language-specific address)
	db "ＵＭＢＲＥＯＮ", 0

String_53_7FAD:: ; 53:7FAD
PokemonName09:: ; 53:7FAD (English table ordinal; language-specific address)
	db "ＰＳＹＤＵＣＫ", 0

String_53_7FBC:: ; 53:7FBC
PokemonName06:: ; 53:7FBC (English table ordinal; language-specific address)
	db "ＴＯＴＯＤＩＬＥ", 0

String_53_7FCD:: ; 53:7FCD
PokemonName05:: ; 53:7FCD (English table ordinal; language-specific address)
	db "ＪＩＧＧＬＹＰＵＦＦ", 0

String_53_7FE2:: ; 53:7FE2
PokemonName01:: ; 53:7FE2 (English table ordinal; language-specific address)
	db "ＰＩＫＡＣＨＵ", 0

String_53_7FF1:: ; 53:7FF1
PokemonName00:: ; 53:7FF1 (English table ordinal; language-specific address)
	db "ＰＯＲＹＧＯＮ", 0

POPC
