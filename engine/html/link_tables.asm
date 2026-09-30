; engine/html/link_tables.asm
; bank 74, $5A96-$5C61 (459 bytes); pinned by layout.link
; link/string tables, resource records, decimal parse, path normalising

SECTION "engine/html/link_tables", ROMX

; ---- code $5A96-$5AD0 (58 bytes) [CONFIRMED] 38 insn(s); 38 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Html_LinkTable_Init:: ; 74:5A96
Function_74_5A96::
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $00
	ld [wHtmlLinkHeapPtr], a
	ld a, $D8
	ld [wHtmlLinkHeapPtr + 1], a
	xor a, a
	ld [wHtmlLinkPtrList], a
	ld [wRam_D601], a
	ret

Html_StringTable_Add:: ; 74:5AAE
	push hl
	ld hl, $C380
	push de
	call Html_StringTable_Find
	pop hl
	or a, a
	jr nz, Label_74_5AF6
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
	jr z, Label_74_5AD7

; ---- code $5AD0-$5AD7 (7 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 74:5ACE (executed)
	xor a, a
	ld [hli], a
	ld de, $FFFF
	ld a, e
	ret

; ---- code $5AD7-$5AEB (20 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios)

Label_74_5AD7:: ; 74:5AD7
	push de
	ld de, $C380

Label_74_5ADB:: ; 74:5ADB
	ld a, [de]
	or a, a
	jr z, Label_74_5AF3
	ld [hli], a
	inc de
	inc hl
	ld a, c
	sub a, l
	ld a, b
	sbc a, h
	dec hl
	bit 7, a
	jr z, Label_74_5ADB

; ---- code $5AEB-$5AF3 (8 bytes) [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0; fall-through of the jrcc at 74:5AE9 (executed)
	xor a, a
	ld [hli], a
	pop de
	ld de, $FFFF
	ld a, e
	ret

; ---- code $5AF3-$5AF6 (3 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)

Label_74_5AF3:: ; 74:5AF3
	ld [hli], a
	pop de
	ret

; ---- code $5AF6-$5AF8 (2 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1; entered by jrcc from 74:5AB8 (executed) [executed in 4 scenarios]

Label_74_5AF6:: ; 74:5AF6
	pop bc
	ret

; ---- code $5AF8-$5B21 (41 bytes) [CONFIRMED] 29 insn(s); 29 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Html_StringTable_Find:: ; 74:5AF8
Function_74_5AF8::
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	ld de, $FFFF

Label_74_5B01:: ; 74:5B01
	inc de
	ld a, d
	or a, a
	jr nz, Label_74_5B4B
	push de
	ld a, [bc]
	inc bc
	ld e, a
	ld a, [bc]
	inc bc
	ld d, a
	or a, e
	jr z, Label_74_5B49
	inc de
	push bc
	ld b, $00

Label_74_5B14:: ; 74:5B14
	inc b
	jr z, Label_74_5B3F
	ld a, [de]
	inc de
	cp a, $41
	jr c, Label_74_5B23
	cp a, $5B
	jr nc, Label_74_5B23

; ---- code $5B21-$5B23 (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 74:5B1F (executed)
	add a, $20

; ---- code $5B23-$5B30 (13 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)

Label_74_5B23:: ; 74:5B23
	ld c, a
	ld a, [hli]
	or a, a
	jr z, Label_74_5B38
	cp a, $41
	jr c, Label_74_5B32
	cp a, $5B
	jr nc, Label_74_5B32

; ---- code $5B30-$5B32 (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 74:5B2E (executed)
	add a, $20

; ---- code $5B32-$5B38 (6 bytes) [CONFIRMED] 4 insn(s); 4 executed (in up to 2/18 scenarios)

Label_74_5B32:: ; 74:5B32
	cp a, c
	jr z, Label_74_5B14
	pop bc
	jr Label_74_5B3F

; ---- code $5B38-$5B3C (4 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1; entered by jrcc from 74:5B26 (executed) | 3 insn(s) executed; cut out of the PROBABLE region 5B38-5B3E by apply_coverage --split [executed in 6 scenarios]

Label_74_5B38:: ; 74:5B38
	sub a, c
	pop bc
	jr z, Label_74_5B48

; ---- code $5B3C-$5B3E (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5B38-5B3E by apply_coverage --split
	jr Label_74_5B3F

; ---- code $5B3E-$5B3F (1 bytes) [HYPOTHESIS] single 'pop bc' (c1) after the unconditional 'jr $5B3F' at 74:5B3C; nothing targets 5B3E (tgt scan), so unreachable; falls into 5B3F (target of 3 jr)
	pop bc

; ---- code $5B3F-$5B48 (9 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)

Label_74_5B3F:: ; 74:5B3F
	pop de
	ldh a, [hRam_FFB0]
	ld l, a
	ldh a, [hRam_FFB1]
	ld h, a
	jr Label_74_5B01

; ---- code $5B48-$5B49 (1 bytes) [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 2; entered by jrcc from 74:5B3A (PROBABLE code) [executed in 4 scenarios]

Label_74_5B48:: ; 74:5B48
	inc a

; ---- code $5B49-$5B4B (2 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 2/18 scenarios)

Label_74_5B49:: ; 74:5B49
	pop de
	ret

; ---- code $5B4B-$5B4F (4 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1; entered by jrcc from 74:5B04 (executed)

Label_74_5B4B:: ; 74:5B4B
	ld de, $FFFF
	ret

; ---- code $5B4F-$5B5C (13 bytes) [CONFIRMED] 11 insn(s); 11 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Html_NextResourceRecord:: ; 74:5B4F
Function_74_5B4F::
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

; ---- code $5B5C-$5BA0 (68 bytes) [CONFIRMED] 43 insn(s) reached by static flow only; seeds: exec x43; min discovery hops 1; entered by far from 74:4CD5 (PROBABLE code) [executed in 3 scenarios]

Html_ParseDecimal:: ; 74:5B5C
	ld bc, $0000
	ld de, $0000

Label_74_5B62:: ; 74:5B62
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
	ldh [hRam_FFF7], a
	ld a, d
	ldh [hRam_FFF8], a
	ld a, c
	ldh [hRam_FFF9], a
	sla e
	rl d
	rl c
	sla e
	rl d
	rl c
	ldh a, [hRam_FFF7]
	add a, e
	ld e, a
	ldh a, [hRam_FFF8]
	adc a, d
	ld d, a
	ldh a, [hRam_FFF9]
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
	jr Label_74_5B62

; ---- code $5BA0-$5BBB (27 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

HtmlUrl_NormalizePath:: ; 74:5BA0
Function_74_5BA0::
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	ld d, h
	ld e, l

Label_74_5BA8:: ; 74:5BA8
	ld a, [hl]
	or a, a
	jp z, Label_74_5C39
	cp a, $3F
	jp z, Label_74_5C39
	cp a, $23
	jp z, Label_74_5C39
	cp a, $5C
	jr nz, Label_74_5BBE

; ---- code $5BBB-$5BBE (3 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 74:5BB9 (executed)
	ld a, $2F
	ld [hl], a

; ---- code $5BBE-$5BD5 (23 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios)

Label_74_5BBE:: ; 74:5BBE
	ld b, h
	ld c, l
	ld a, [bc]
	cp a, $2F
	jr nz, Label_74_5BD8
	inc bc
	ld a, [bc]
	cp a, $2E
	jr nz, Label_74_5BD8
	inc bc
	ld a, [bc]
	cp a, $2F
	jr z, Label_74_5BD5
	cp a, $5C
	jr nz, Label_74_5BD8

; ---- code $5BD5-$5BD8 (3 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; entered by jrcc from 74:5BCF (executed)

Label_74_5BD5:: ; 74:5BD5
	inc hl
	jr Label_74_5C35

; ---- code $5BD8-$5BF1 (25 bytes) [CONFIRMED] 17 insn(s); 17 executed (in up to 2/18 scenarios)

Label_74_5BD8:: ; 74:5BD8
	ld b, h
	ld c, l
	ld a, [bc]
	cp a, $2F
	jr nz, Label_74_5C32
	inc bc
	ld a, [bc]
	cp a, $2E
	jr nz, Label_74_5C32
	inc bc
	ld a, [bc]
	cp a, $2E
	jr nz, Label_74_5C32
	inc bc
	ld a, [bc]
	cp a, $2F
	jr z, Label_74_5C00

; ---- code $5BF1-$5C00 (15 bytes) [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0; fall-through of the jrcc at 74:5BEF (executed)
	or a, a
	jr z, Label_74_5C00
	cp a, $3F
	jr z, Label_74_5C00
	cp a, $23
	jr z, Label_74_5C00
	cp a, $5C
	jr nz, Label_74_5C32

; ---- code $5C00-$5C2F (47 bytes) [CONFIRMED] 35 insn(s); 35 executed (in up to 1/18 scenarios)

Label_74_5C00:: ; 74:5C00
	ldh a, [hRam_FFB0]
	ld c, a
	ldh a, [hRam_FFB1]
	ld b, a
	ld a, d
	sub a, b
	ld a, e
	sbc a, c
	jr z, Label_74_5C0D
	dec de

Label_74_5C0D:: ; 74:5C0D
	ldh a, [hRam_FFB0]
	ld c, a
	ldh a, [hRam_FFB1]
	ld b, a

Label_74_5C13:: ; 74:5C13
	ld a, [de]
	cp a, $2F
	jr z, Label_74_5C21
	ld a, d
	sub a, b
	ld a, e
	sbc a, c
	jr z, Label_74_5C21
	dec de
	jr Label_74_5C13

Label_74_5C21:: ; 74:5C21
	inc hl
	inc hl
	ld b, h
	ld c, l
	ld a, [bc]
	cp a, $2E
	jr nz, Label_74_5C35
	inc bc
	ld a, [bc]
	or a, a
	jr nz, Label_74_5C35

; ---- code $5C2F-$5C32 (3 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 74:5C2D (executed)
	inc de
	jr Label_74_5C35

; ---- code $5C32-$5C3D (11 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)

Label_74_5C32:: ; 74:5C32
	ld a, [hl]
	ld [de], a
	inc de

Label_74_5C35:: ; 74:5C35
	inc hl
	jp Label_74_5BA8

Label_74_5C39:: ; 74:5C39
	ld a, [hl]
	or a, a
	jr z, Label_74_5C42

; ---- code $5C3D-$5C42 (5 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 74:5C3B (executed) [executed in 1 scenarios]
	ld [de], a
	inc de
	inc hl
	jr Label_74_5C39

; ---- code $5C42-$5C57 (21 bytes) [CONFIRMED] 16 insn(s); 16 executed (in up to 2/18 scenarios)

Label_74_5C42:: ; 74:5C42
	xor a, a
	ld [de], a
	ldh a, [hRam_FFB0]
	ld c, a
	ldh a, [hRam_FFB1]
	ld b, a
	inc bc
	ld a, b
	sub a, d
	ld a, c
	sbc a, e
	jr nc, Label_74_5C60
	dec de
	ld a, [de]
	cp a, $2E
	jr nz, Label_74_5C60

; ---- code $5C57-$5C60 (9 bytes) [PROBABLE] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0; fall-through of the jrcc at 74:5C55 (executed)
	dec de
	ld a, [de]
	cp a, $2F
	jr nz, Label_74_5C60
	inc de
	xor a, a
	ld [de], a

; ---- code $5C60-$5C61 (1 bytes) [CONFIRMED] 1 insn(s); 1 executed (in up to 2/18 scenarios)

Label_74_5C60:: ; 74:5C60
	ret
