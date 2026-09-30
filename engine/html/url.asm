; engine/html/url.asm
; bank 74, $5905-$5A96 (401 bytes); pinned by layout.link
; URL scheme table, scheme id, URL resolving

SECTION "engine/html/url", ROMX

; ---- ptrtable $5905-$591D (24 bytes) [PROBABLE] URL scheme pointer list (11 entries + $0000): $591D, $5923, $592A, $5938, $5930, $593D, $5945, $594B, $5951, $5959, $595F. Items follow at 591D, tile exactly to the code at 74:5969; bytes 5905-591D... were read as data by executed code in 5/18 scenarios

HtmlUrl_SchemeTable:: ; 74:5905
Table_74_5905::
	dw HtmlUrl_SchemeNames
	dw $5923
	dw $592A
	dw $5938
	dw $5930
	dw $593D
	dw $5945
	dw $594B
	dw $5951
	dw $5959
	dw $595F
	dw $0000

; ---- data $591D-$5969 (76 bytes) [PROBABLE] URL scheme name items [ASCII NUL][value byte]: $591D "http" -> $01; $5923 "https" -> $FF; $592A "file" -> $FF; $5930 "mailto" -> $FF; $5938 "ftp" -> $FF; $593D "gopher" -> $FF; $5945 "news" -> $FF; $594B "nntp" -> $FF; $5951 "telnet" -> $FF; $5959 "wais" -> $FF; $595F "prospero" -> $FF (value $01 for http, $FF for the others). (Value byte follows the name as in the tag/attribute tables at 74:4000.)

HtmlUrl_SchemeNames:: ; 74:591D
Data_74_591D::
	db $68, $74, $74, $70, $00, $01, $68, $74, $74, $70, $73, $00, $FF, $66, $69, $6C
	db $65, $00, $FF, $6D, $61, $69, $6C, $74, $6F, $00, $FF, $66, $74, $70, $00, $FF
	db $67, $6F, $70, $68, $65, $72, $00, $FF, $6E, $65, $77, $73, $00, $FF, $6E, $6E
	db $74, $70, $00, $FF, $74, $65, $6C, $6E, $65, $74, $00, $FF, $77, $61, $69, $73
	db $00, $FF, $70, $72, $6F, $73, $70, $65, $72, $6F, $00, $FF

HtmlUrl_GetSchemeId:: ; 74:5969
Function_74_5969::
	; [CONFIRMED] 22 insn(s); 22 executed (in up to 5/18 scenarios); entry proven: target of an
	; executed call/far call
	push hl
.loop ; 74:596A
	ld a, [hli]
	or a, a
	jr z, .l597F
	cp a, $3A
	jr nz, .loop
	pop hl
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	ld bc, HtmlUrl_SchemeTable
	jp Function_00_10E9
.l597F ; 74:597F
	pop hl
	ret

HtmlUrl_Resolve:: ; 74:5981
	call Function_00_0392
	push hl
.l5985 ; 74:5985
	ld a, [hli]
	or a, a
	jr z, .l59B0
	cp a, $3A
	jr nz, .l5985

	; [CONFIRMED] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 0;
	; fall-through of the jrcc at 74:598B (executed) [executed in 1 scenarios]
	pop hl
	push hl
	push de
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	ld bc, HtmlUrl_SchemeTable
	call Function_00_10E9
	or a, a
	jr z, .l59B3
	pop de
	pop hl
	ld de, $C380
	ld bc, $0100
	call CopyBytes
	ld hl, $C380
	jp Label_74_5A5A

.l59B0 ; 74:59B0
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 2/18 scenarios)
	pop hl
	push hl
	push de
.l59B3 ; 74:59B3
	pop de
	ld h, d
	ld l, e
.l59B6 ; 74:59B6
	ld a, [hli]
	or a, a
	jr z, Label_74_59E0
	cp a, $3A
	jr nz, .l59B6
	push de
	ld h, d
	ld l, e
	ld a, e
	ldh [hRam_FFB0], a
	ld a, d
	ldh [hRam_FFB1], a
	ld bc, HtmlUrl_SchemeTable
	call Function_00_10E9
	ld bc, $0100
	ld de, $C380
	or a, a
	jr nz, Label_74_59F1

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 74:59D4 (executed)
	jr Label_74_59E7

; ---- text $59D8-$59E0 (8 bytes) [PROBABLE] 'http://' NUL: copied byte-by-byte to $C380 until NUL by the loop at 74:59E7 (ld hl,$59D8 ; ld a,[hli] ; ld [de],a ; inc de ; dec bc ; or a ; jr nz)

PUSHC sjis
HtmlUrl_HttpPrefix:: ; 74:59D8
String_74_59D8::
	db "http://", 0
POPC

Label_74_59E0:: ; 74:59E0
	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 1;
	; entered by jrcc from 74:59B8 (executed)
	push de
	ld bc, $0100
	ld de, $C380

Label_74_59E7:: ; 74:59E7
	ld hl, HtmlUrl_HttpPrefix
.loop ; 74:59EA
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	or a, a
	jr nz, .loop

Label_74_59F1:: ; 74:59F1
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 2/18 scenarios)
	pop hl
	call CopyBytes
	pop hl
	ld a, [hl]
	cp a, $2F
	jr z, .l5A2C
	cp a, $3B
	jr z, .l5A0F
	cp a, $3F
	jr z, .l5A0B
	cp a, $23
	jr nz, .l5A13

	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 1;
	; fall-through of the jrcc at 74:5A05 (executed)
	ld b, $23
	jr .l5A15
.l5A0B ; 74:5A0B
	ld b, $3F
	jr .l5A15
.l5A0F ; 74:5A0F
	ld b, $3B
	jr .l5A15

.l5A13 ; 74:5A13
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios)
	ld b, $2F
.l5A15 ; 74:5A15
	push hl
	ld hl, $C380
	call HtmlUrl_FindLastSegmentDelimiter
	dec hl
	ld a, b
	ld [hli], a
	pop de
.l5A20 ; 74:5A20
	ld a, [de]
	ld [hli], a
	inc de
	or a, a
	jr nz, .l5A20
	ld hl, $C380
	jp Label_74_5A5A

.l5A2C ; 74:5A2C
	; [PROBABLE] 29 insn(s) reached by static flow only; seeds: exec x29; min discovery hops 2;
	; entered by jrcc from 74:59F9 (executed)
	ld d, h
	ld e, l
	inc hl
	ld a, [hld]
	ld hl, $C380
	cp a, $2F
	jr nz, .l5A42
.l5A37 ; 74:5A37
	ld a, [hli]
	cp a, $3A
	jr z, .l5A20
	or a, a
	jr nz, .l5A37
	dec hl
	jr .l5A20
.l5A42 ; 74:5A42
	ld a, [hli]
.l5A43 ; 74:5A43
	or a, a
	jr z, .l5A57
	cp a, $2F
	jr nz, .l5A42
	ld a, [hli]
	cp a, $2F
	jr nz, .l5A43
.l5A4F ; 74:5A4F
	ld a, [hli]
	or a, a
	jr z, .l5A57
	cp a, $2F
	jr nz, .l5A4F
.l5A57 ; 74:5A57
	dec hl
	jr .l5A20

Label_74_5A5A:: ; 74:5A5A
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 2/18 scenarios)
	ld a, [hli]
	or a, a
	ret z
	cp a, $2F
	jr nz, Label_74_5A5A
	ld a, [hli]
	cp a, $2F
	jr nz, .l5A66
.l5A66 ; 74:5A66
	ld a, [hli]
	or a, a
	jr z, .l5A6F
	cp a, $2F
	jr nz, .l5A66
	ret

.l5A6F ; 74:5A6F
	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 1;
	; entered by jrcc from 74:5A68 (executed)
	dec hl
	ld a, $2F
	ld [hli], a
	xor a, a
	ld [hli], a
	ret

HtmlUrl_FindLastSegmentDelimiter:: ; 74:5A76
Function_74_5A76::
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	xor a, a
	ld d, a
	ld e, a
.l5A79 ; 74:5A79
	ld c, a
	ld a, [hli]
	cp a, $2F
	jr nz, .l5A83
	ld d, h
	ld e, l
	jr .l5A79
.l5A83 ; 74:5A83
	or a, a
	jr nz, .l5A79
	ld a, e
	or a, d
	ret z
	ld h, d
	ld l, e
	ld a, $2F
	cp a, b
	ret z

.l5A8F ; 74:5A8F
	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the retcc at 74:5A8E (executed)
	ld a, [hli]
	cp a, b
	ret z
	or a, a
	jr nz, .l5A8F
	ret
