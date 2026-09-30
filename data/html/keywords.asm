; data/html/keywords.asm
; bank 74, $4000-$4165 (357 bytes); pinned by layout.link
; tag, attribute, entity and value keyword tables of the HTML parser

SECTION "data/html/keywords", ROMX

PUSHC sjis

; ---- ptrtable $4000-$4006 (6 bytes) [PROBABLE] pointer list (2 entries + $0000 terminator): $4006, $400A. Followed by the NUL-terminated name items it points at (or, for a lone pointer, an item elsewhere). Part of the HTML tag/attribute lookup tables of the home-page renderer (bank 74, homepage/monkey traces read these bytes as data); format decoded by hand: every target is an item start and the items tile the area exactly up to the code at 74:4165

Html_ResultCodePtrs:: ; 74:4000
Table_74_4000::
	dw Html_ResultCodeNames
	dw $400A
	dw $0000

; ---- data $4006-$400E (8 bytes) [PROBABLE] items [ASCII name][NUL][value byte]: $4006 "ng" -> $01; $400A "ok" -> $02. (Value byte follows the name: e.g. tags html=1..pre=$11, entities lt->'<', gt->'>', amp->'&', quot->'"', nbsp->' '). Pointer list precedes it.

Html_ResultCodeNames:: ; 74:4006
Data_74_4006::
	db "ng", 0, $01
	db "ok", 0, $02

; ---- ptrtable $400E-$401A (12 bytes) [PROBABLE] pointer list (5 entries + $0000 terminator): $401A, $401E, $4022, $4027, $402D. Followed by the NUL-terminated name items it points at (or, for a lone pointer, an item elsewhere). Part of the HTML tag/attribute lookup tables of the home-page renderer (bank 74, homepage/monkey traces read these bytes as data); format decoded by hand: every target is an item start and the items tile the area exactly up to the code at 74:4165

Html_EntityPtrs:: ; 74:400E
Table_74_400E::
	dw Html_EntityNames
	dw $401E
	dw $4022
	dw $4027
	dw $402D
	dw $0000

; ---- data $401A-$4033 (25 bytes) [PROBABLE] items [ASCII name][NUL][value byte]: $401A "lt" -> $3C; $401E "gt" -> $3E; $4022 "amp" -> $26; $4027 "quot" -> $22; $402D "nbsp" -> $20. (Value byte follows the name: e.g. tags html=1..pre=$11, entities lt->'<', gt->'>', amp->'&', quot->'"', nbsp->' '). Pointer list precedes it.

Html_EntityNames:: ; 74:401A
Data_74_401A::
	db "lt", 0, $3C
	db "gt", 0, $3E
	db "amp", 0, $26
	db "quot", 0, $22
	db "nbsp", 0, $20

; ---- ptrtable $4033-$403B (8 bytes) [PROBABLE] pointer list (3 entries + $0000 terminator): $403B, $4043, $404B. Followed by the NUL-terminated name items it points at (or, for a lone pointer, an item elsewhere). Part of the HTML tag/attribute lookup tables of the home-page renderer (bank 74, homepage/monkey traces read these bytes as data); format decoded by hand: every target is an item start and the items tile the area exactly up to the code at 74:4165

Html_MetaAttrPtrs:: ; 74:4033
Table_74_4033::
	dw Html_MetaAttrNames
	dw $4043
	dw $404B
	dw $0000

; ---- data $403B-$4053 (24 bytes) [PROBABLE] items [ASCII name][NUL][value byte]: $403B "ppp_id" -> $01; $4043 "r_code" -> $02; $404B "d_code" -> $03. (Value byte follows the name: e.g. tags html=1..pre=$11, entities lt->'<', gt->'>', amp->'&', quot->'"', nbsp->' '). Pointer list precedes it.

Html_MetaAttrNames:: ; 74:403B
Data_74_403B::
	db "ppp_id", 0, $01
	db "r_code", 0, $02
	db "d_code", 0, $03

; ---- ptrtable $4053-$4057 (4 bytes) [PROBABLE] pointer list (1 entries + $0000 terminator): $4118. Followed by the NUL-terminated name items it points at (or, for a lone pointer, an item elsewhere). Part of the HTML tag/attribute lookup tables of the home-page renderer (bank 74, homepage/monkey traces read these bytes as data); format decoded by hand: every target is an item start and the items tile the area exactly up to the code at 74:4165

Html_TitleTagPtrs:: ; 74:4053
Table_74_4053::
	dw $4118
	dw $0000

; ---- ptrtable $4057-$405B (4 bytes) [PROBABLE] pointer list (1 entries + $0000 terminator): $405B. Followed by the NUL-terminated name items it points at (or, for a lone pointer, an item elsewhere). Part of the HTML tag/attribute lookup tables of the home-page renderer (bank 74, homepage/monkey traces read these bytes as data); format decoded by hand: every target is an item start and the items tile the area exactly up to the code at 74:4165

Html_BrAttrPtrs:: ; 74:4057
Table_74_4057::
	dw Html_BrAttrNames
	dw $0000

; ---- data $405B-$4062 (7 bytes) [PROBABLE] items [ASCII name][NUL][value byte]: $405B "clear" -> $01. (Value byte follows the name: e.g. tags html=1..pre=$11, entities lt->'<', gt->'>', amp->'&', quot->'"', nbsp->' '). Pointer list precedes it.

Html_BrAttrNames:: ; 74:405B
Data_74_405B::
	db "clear", 0, $01

; ---- ptrtable $4062-$4066 (4 bytes) [PROBABLE] pointer list (1 entries + $0000 terminator): $4066. Followed by the NUL-terminated name items it points at (or, for a lone pointer, an item elsewhere). Part of the HTML tag/attribute lookup tables of the home-page renderer (bank 74, homepage/monkey traces read these bytes as data); format decoded by hand: every target is an item start and the items tile the area exactly up to the code at 74:4165

Html_HrAttrPtrs:: ; 74:4062
Table_74_4062::
	dw Html_HrAttrNames
	dw $0000

; ---- data $4066-$406D (7 bytes) [PROBABLE] items [ASCII name][NUL][value byte]: $4066 "width" -> $01. (Value byte follows the name: e.g. tags html=1..pre=$11, entities lt->'<', gt->'>', amp->'&', quot->'"', nbsp->' '). Pointer list precedes it.

Html_HrAttrNames:: ; 74:4066
Data_74_4066::
	db "width", 0, $01

; ---- ptrtable $406D-$4071 (4 bytes) [PROBABLE] pointer list (1 entries + $0000 terminator): $4071. Followed by the NUL-terminated name items it points at (or, for a lone pointer, an item elsewhere). Part of the HTML tag/attribute lookup tables of the home-page renderer (bank 74, homepage/monkey traces read these bytes as data); format decoded by hand: every target is an item start and the items tile the area exactly up to the code at 74:4165

Html_AlignAttrPtrs:: ; 74:406D
Table_74_406D::
	dw Html_AlignAttrNames
	dw $0000

; ---- data $4071-$4078 (7 bytes) [PROBABLE] items [ASCII name][NUL][value byte]: $4071 "align" -> $01. (Value byte follows the name: e.g. tags html=1..pre=$11, entities lt->'<', gt->'>', amp->'&', quot->'"', nbsp->' '). Pointer list precedes it.

Html_AlignAttrNames:: ; 74:4071
Data_74_4071::
	db "align", 0, $01

; ---- ptrtable $4078-$407E (6 bytes) [PROBABLE] pointer list (2 entries + $0000 terminator): $407E, $4084. Followed by the NUL-terminated name items it points at (or, for a lone pointer, an item elsewhere). Part of the HTML tag/attribute lookup tables of the home-page renderer (bank 74, homepage/monkey traces read these bytes as data); format decoded by hand: every target is an item start and the items tile the area exactly up to the code at 74:4165

Html_AnchorAttrPtrs:: ; 74:4078
Table_74_4078::
	dw Html_AnchorAttrNames
	dw $4084
	dw $0000

; ---- data $407E-$408A (12 bytes) [PROBABLE] items [ASCII name][NUL][value byte]: $407E "href" -> $01; $4084 "name" -> $02. (Value byte follows the name: e.g. tags html=1..pre=$11, entities lt->'<', gt->'>', amp->'&', quot->'"', nbsp->' '). Pointer list precedes it.

Html_AnchorAttrNames:: ; 74:407E
Data_74_407E::
	db "href", 0, $01
	db "name", 0, $02

; ---- ptrtable $408A-$4090 (6 bytes) [PROBABLE] pointer list (2 entries + $0000 terminator): $4090, $4095. Followed by the NUL-terminated name items it points at (or, for a lone pointer, an item elsewhere). Part of the HTML tag/attribute lookup tables of the home-page renderer (bank 74, homepage/monkey traces read these bytes as data); format decoded by hand: every target is an item start and the items tile the area exactly up to the code at 74:4165

Html_ImgAttrPtrs:: ; 74:408A
Table_74_408A::
	dw Html_ImgAttrNames
	dw $4095
	dw $0000

; ---- data $4090-$409C (12 bytes) [PROBABLE] items [ASCII name][NUL][value byte]: $4090 "src" -> $01; $4095 "align" -> $02. (Value byte follows the name: e.g. tags html=1..pre=$11, entities lt->'<', gt->'>', amp->'&', quot->'"', nbsp->' '). Pointer list precedes it.

Html_ImgAttrNames:: ; 74:4090
Data_74_4090::
	db "src", 0, $01
	db "align", 0, $02

; ---- ptrtable $409C-$40A4 (8 bytes) [PROBABLE] pointer list (3 entries + $0000 terminator): $40A4, $40AA, $40B1. Followed by the NUL-terminated name items it points at (or, for a lone pointer, an item elsewhere). Part of the HTML tag/attribute lookup tables of the home-page renderer (bank 74, homepage/monkey traces read these bytes as data); format decoded by hand: every target is an item start and the items tile the area exactly up to the code at 74:4165

Html_ClearValuePtrs:: ; 74:409C
Table_74_409C::
	dw Html_ClearValueNames
	dw $40AA
	dw $40B1
	dw $0000

; ---- data $40A4-$40B6 (18 bytes) [PROBABLE] items [ASCII name][NUL][value byte]: $40A4 "left" -> $01; $40AA "right" -> $02; $40B1 "all" -> $03. (Value byte follows the name: e.g. tags html=1..pre=$11, entities lt->'<', gt->'>', amp->'&', quot->'"', nbsp->' '). Pointer list precedes it.

Html_ClearValueNames:: ; 74:40A4
Data_74_40A4::
	db "left", 0, $01
	db "right", 0, $02
	db "all", 0, $03

; ---- ptrtable $40B6-$40C4 (14 bytes) [PROBABLE] pointer list (6 entries + $0000 terminator): $40D0, $40E0, $40C4, $40E6, $40CB, $40D8. Followed by the NUL-terminated name items it points at (or, for a lone pointer, an item elsewhere). Part of the HTML tag/attribute lookup tables of the home-page renderer (bank 74, homepage/monkey traces read these bytes as data); format decoded by hand: every target is an item start and the items tile the area exactly up to the code at 74:4165

Html_AlignValuePtrs:: ; 74:40B6
Table_74_40B6::
	dw $40D0
	dw $40E0
	dw Html_AlignValueNames
	dw $40E6
	dw $40CB
	dw $40D8
	dw $0000

; ---- data $40C4-$40EE (42 bytes) [PROBABLE] items [ASCII name][NUL][value byte]: $40C4 "right" -> $04; $40CB "top" -> $10; $40D0 "center" -> $08; $40D8 "middle" -> $20; $40E0 "left" -> $0C; $40E6 "bottom" -> $30. (Value byte follows the name: e.g. tags html=1..pre=$11, entities lt->'<', gt->'>', amp->'&', quot->'"', nbsp->' '). Pointer list precedes it.

Html_AlignValueNames:: ; 74:40C4
Data_74_40C4::
	db "right", 0, $04
	db "top", 0, $10
	db "center", 0, $08
	db "middle", 0, $20
	db "left", 0, $0C
	db "bottom", 0, $30

; ---- ptrtable $40EE-$4112 (36 bytes) [PROBABLE] pointer list (17 entries + $0000 terminator): $4157, $4138, $4145, $4140, $413C, $412B, $4133, $414B, $414F, $4153, $4148, $415A, $4160, $4125, $411F, $4118, $4112. Followed by the NUL-terminated name items it points at (or, for a lone pointer, an item elsewhere). Part of the HTML tag/attribute lookup tables of the home-page renderer (bank 74, homepage/monkey traces read these bytes as data); format decoded by hand: every target is an item start and the items tile the area exactly up to the code at 74:4165

Html_TagPtrs:: ; 74:40EE
Table_74_40EE::
	dw $4157
	dw $4138
	dw $4145
	dw $4140
	dw $413C
	dw $412B
	dw $4133
	dw $414B
	dw $414F
	dw $4153
	dw $4148
	dw $415A
	dw $4160
	dw $4125
	dw $411F
	dw $4118
	dw Html_TagNames

Html_NoKeywords:: ; 74:4110
	dw $0000

; ---- data $4112-$4165 (83 bytes) [PROBABLE] items [ASCII name][NUL][value byte]: $4112 "html" -> $01; $4118 "title" -> $02; $411F "head" -> $03; $4125 "body" -> $04; $412B "center" -> $05; $4133 "div" -> $06; $4138 "br" -> $07; $413C "hr" -> $08; $4140 "img" -> $09; $4145 "a" -> $0A; $4148 "b" -> $0B; $414B "ul" -> $0C; $414F "ol" -> $0D; $4153 "li" -> $0E; $4157 "!" -> $0F; $415A "meta" -> $10; $4160 "pre" -> $11. (Value byte follows the name: e.g. tags html=1..pre=$11, entities lt->'<', gt->'>', amp->'&', quot->'"', nbsp->' '). Pointer list precedes it.

Html_TagNames:: ; 74:4112
Data_74_4112::
	db "html", 0, $01
	db "title", 0, $02
	db "head", 0, $03
	db "body", 0, $04
	db "center", 0, $05
	db "div", 0, $06
	db "br", 0, $07
	db "hr", 0, $08
	db "img", 0, $09
	db "a", 0, $0A
	db "b", 0, $0B
	db "ul", 0, $0C
	db "ol", 0, $0D
	db "li", 0, $0E
	db "!", 0, $0F
	db "meta", 0, $10
	db "pre", 0, $11

POPC
