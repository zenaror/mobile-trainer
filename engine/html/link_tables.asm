; engine/html/link_tables.asm
; bank 74, $5A96-$5C61 (459 bytes); pinned by layout.link
; link/string tables, resource records, decimal parse, path normalising

SECTION "engine/html/link_tables", ROMX

Html_LinkTable_Init:: ; 74:5A96
Function_74_5A96::
	; [CONFIRMED] 38 insn(s); 38 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $00
	ld [wHtmlLinkHeapPtr], a
	ld a, $D8
	ld [wHtmlLinkHeapPtr + 1], a
	xor a, a
	ld [wHtmlLinkPtrList], a
	ld [wHtmlLinkPtrList + $01], a
	ret

Html_StringTable_Add:: ; 74:5AAE
	push hl
	ld hl, wAttrUrlBuf
	push de
	call Html_StringTable_Find
	pop hl
	or a, a
	jr nz, .l5AF6
	ld [bc], a
	inc bc
	ld [bc], a
	dec bc
	dec bc
	ld a, h
	ld [bc], a
	dec bc
	ld a, l
	ld [bc], a
	pop bc
	inc hl
	inc hl
	ld a, c
	sub a, l
	ld a, b
	sbc a, h
	dec hl
	bit 7, a
	jr z, .l5AD7

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 74:5ACE (executed)
	xor a, a
	ld [hli], a
	ld de, $FFFF
	ld a, e
	ret

.l5AD7 ; 74:5AD7
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios)
	push de
	ld de, wAttrUrlBuf
.loop ; 74:5ADB
	ld a, [de]
	or a, a
	jr z, .l5AF3
	ld [hli], a
	inc de
	inc hl
	ld a, c
	sub a, l
	ld a, b
	sbc a, h
	dec hl
	bit 7, a
	jr z, .loop

	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 74:5AE9 (executed)
	xor a, a
	ld [hli], a
	pop de
	ld de, $FFFF
	ld a, e
	ret

.l5AF3 ; 74:5AF3
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)
	ld [hli], a
	pop de
	ret

.l5AF6 ; 74:5AF6
	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by jrcc from 74:5AB8 (executed) [executed in 4 scenarios]
	pop bc
	ret

Html_StringTable_Find:: ; 74:5AF8
Function_74_5AF8::
	; [CONFIRMED] 29 insn(s); 29 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, l
	ldh [hHtmlLinks_StringStart], a
	ld a, h
	ldh [hHtmlLinks_StringStartHi], a
	ld de, $FFFF
.l5B01 ; 74:5B01
	inc de
	ld a, d
	or a, a
	jr nz, .l5B4B
	push de
	ld a, [bc]
	inc bc
	ld e, a
	ld a, [bc]
	inc bc
	ld d, a
	or a, e
	jr z, .l5B49
	inc de
	push bc
	ld b, $00
.l5B14 ; 74:5B14
	inc b
	jr z, .l5B3F
	ld a, [de]
	inc de
	cp a, $41
	jr c, .l5B23
	cp a, $5B
	jr nc, .l5B23

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 74:5B1F (executed)
	add a, $20

.l5B23 ; 74:5B23
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)
	ld c, a
	ld a, [hli]
	or a, a
	jr z, .l5B38
	cp a, $41
	jr c, .l5B32
	cp a, $5B
	jr nc, .l5B32

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 74:5B2E (executed)
	add a, $20

.l5B32 ; 74:5B32
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 2/18 scenarios)
	cp a, c
	jr z, .l5B14
	pop bc
	jr .l5B3F

.l5B38 ; 74:5B38
	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1;
	; entered by jrcc from 74:5B26 (executed) | 3 insn(s) executed; cut out of the PROBABLE region
	; 5B38-5B3E by apply_coverage --split [executed in 6 scenarios]
	sub a, c
	pop bc
	jr z, .l5B48

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5B38-5B3E by apply_coverage --split
	jr .l5B3F

	; [HYPOTHESIS] single 'pop bc' (c1) after the unconditional 'jr $5B3F' at 74:5B3C; nothing
	; targets 5B3E (tgt scan), so unreachable; falls into 5B3F (target of 3 jr)
	pop bc

.l5B3F ; 74:5B3F
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)
	pop de
	ldh a, [hHtmlLinks_StringStart]
	ld l, a
	ldh a, [hHtmlLinks_StringStartHi]
	ld h, a
	jr .l5B01

.l5B48 ; 74:5B48
	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 2;
	; entered by jrcc from 74:5B3A (PROBABLE code) [executed in 4 scenarios]
	inc a

.l5B49 ; 74:5B49
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 2/18 scenarios)
	pop de
	ret

.l5B4B ; 74:5B4B
	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by jrcc from 74:5B04 (executed)
	ld de, $FFFF
	ret

Html_NextResourceRecord:: ; 74:5B4F
Function_74_5B4F::
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	call BankSwitch_H
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ret

Html_ParseDecimal:: ; 74:5B5C
	; [CONFIRMED] 43 insn(s) reached by static flow only; seeds: exec x43; min discovery hops 1;
	; entered by far from 74:4CD5 (PROBABLE code) [executed in 3 scenarios]
	ld bc, $0000
	ld de, $0000
.loop ; 74:5B62
	ld a, [hli]
	cp a, $30
	ret c
	cp a, $3A
	ret nc
	and a, $0F
	ld b, a
	sla e
	rl d
	rl c
	ld a, e
	ldh [hHtmlParseDecimal_Times2Lo], a
	ld a, d
	ldh [hHtmlParseDecimal_Times2Mid], a
	ld a, c
	ldh [hHtmlParseDecimal_Times2Hi], a
	sla e
	rl d
	rl c
	sla e
	rl d
	rl c
	ldh a, [hHtmlParseDecimal_Times2Lo]
	add a, e
	ld e, a
	ldh a, [hHtmlParseDecimal_Times2Mid]
	adc a, d
	ld d, a
	ldh a, [hHtmlParseDecimal_Times2Hi]
	adc a, c
	ld c, a
	ld a, b
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	ld a, $00
	adc a, c
	ld c, a
	jr .loop

HtmlUrl_NormalizePath:: ; 74:5BA0
Function_74_5BA0::
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, l
	ldh [hHtmlLinks_StringStart], a
	ld a, h
	ldh [hHtmlLinks_StringStartHi], a
	ld d, h
	ld e, l
.l5BA8 ; 74:5BA8
	ld a, [hl]
	or a, a
	jp z, .l5C39
	cp a, $3F
	jp z, .l5C39
	cp a, $23
	jp z, .l5C39
	cp a, $5C
	jr nz, .l5BBE

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 74:5BB9 (executed)
	ld a, $2F
	ld [hl], a

.l5BBE ; 74:5BBE
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios)
	ld b, h
	ld c, l
	ld a, [bc]
	cp a, $2F
	jr nz, .l5BD8
	inc bc
	ld a, [bc]
	cp a, $2E
	jr nz, .l5BD8
	inc bc
	ld a, [bc]
	cp a, $2F
	jr z, .l5BD5
	cp a, $5C
	jr nz, .l5BD8

.l5BD5 ; 74:5BD5
	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; entered by jrcc from 74:5BCF (executed)
	inc hl
	jr .l5C35

.l5BD8 ; 74:5BD8
	; [CONFIRMED] 17 insn(s); 17 executed (in up to 2/18 scenarios)
	ld b, h
	ld c, l
	ld a, [bc]
	cp a, $2F
	jr nz, .l5C32
	inc bc
	ld a, [bc]
	cp a, $2E
	jr nz, .l5C32
	inc bc
	ld a, [bc]
	cp a, $2E
	jr nz, .l5C32
	inc bc
	ld a, [bc]
	cp a, $2F
	jr z, .l5C00

	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0;
	; fall-through of the jrcc at 74:5BEF (executed)
	or a, a
	jr z, .l5C00
	cp a, $3F
	jr z, .l5C00
	cp a, $23
	jr z, .l5C00
	cp a, $5C
	jr nz, .l5C32

.l5C00 ; 74:5C00
	; [CONFIRMED] 35 insn(s); 35 executed (in up to 1/18 scenarios)
	ldh a, [hHtmlLinks_StringStart]
	ld c, a
	ldh a, [hHtmlLinks_StringStartHi]
	ld b, a
	ld a, d
	sub a, b
	ld a, e
	sbc a, c
	jr z, .l5C0D
	dec de
.l5C0D ; 74:5C0D
	ldh a, [hHtmlLinks_StringStart]
	ld c, a
	ldh a, [hHtmlLinks_StringStartHi]
	ld b, a
.l5C13 ; 74:5C13
	ld a, [de]
	cp a, $2F
	jr z, .l5C21
	ld a, d
	sub a, b
	ld a, e
	sbc a, c
	jr z, .l5C21
	dec de
	jr .l5C13
.l5C21 ; 74:5C21
	inc hl
	inc hl
	ld b, h
	ld c, l
	ld a, [bc]
	cp a, $2E
	jr nz, .l5C35
	inc bc
	ld a, [bc]
	or a, a
	jr nz, .l5C35

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 74:5C2D (executed)
	inc de
	jr .l5C35

.l5C32 ; 74:5C32
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)
	ld a, [hl]
	ld [de], a
	inc de
.l5C35 ; 74:5C35
	inc hl
	jp .l5BA8
.l5C39 ; 74:5C39
	ld a, [hl]
	or a, a
	jr z, .l5C42

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 74:5C3B (executed) [executed in 1 scenarios]
	ld [de], a
	inc de
	inc hl
	jr .l5C39

.l5C42 ; 74:5C42
	; [CONFIRMED] 16 insn(s); 16 executed (in up to 2/18 scenarios)
	xor a, a
	ld [de], a
	ldh a, [hHtmlLinks_StringStart]
	ld c, a
	ldh a, [hHtmlLinks_StringStartHi]
	ld b, a
	inc bc
	ld a, b
	sub a, d
	ld a, c
	sbc a, e
	jr nc, .done
	dec de
	ld a, [de]
	cp a, $2E
	jr nz, .done

	; [PROBABLE] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0;
	; fall-through of the jrcc at 74:5C55 (executed)
	dec de
	ld a, [de]
	cp a, $2F
	jr nz, .done
	inc de
	xor a, a
	ld [de], a

.done ; 74:5C60
	; [CONFIRMED] 1 insn(s); 1 executed (in up to 2/18 scenarios)
	ret
