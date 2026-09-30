; engine/settings/http_redirect.asm
; bank 67, $5F66-$60BA (340 bytes); pinned by layout.link
; HTTP redirect URL resolving/joining/normalising

SECTION "engine/settings/http_redirect", ROMX

; ---- code $5F66-$5FDB (117 bytes) [CONFIRMED] 220 insn(s) reached by static flow only; seeds: exec x220; min discovery hops 2; entered by call from 67:5D5B (PROBABLE code) | 66 insn(s) executed; cut out of the PROBABLE region 5F66-60BA by apply_coverage --split [executed in 1 scenarios]

HttpRedirect_ResolveUrl:: ; 67:5F66
	ld a, [wMobileErrorExtra]
	ld l, a
	ld a, [wMobileErrorExtra + 1]
	ld h, a
	ld a, [hli]
	cp a, $68
	jr nz, Label_67_5FA0
	ld a, [hli]
	cp a, $74
	jr nz, Label_67_5FA0
	ld a, [hli]
	cp a, $74
	jr nz, Label_67_5FA0
	ld a, [hli]
	cp a, $70
	jr nz, Label_67_5FA0
	ld a, [hli]
	cp a, $3A
	jr nz, Label_67_5FA0
	ld a, [hli]
	cp a, $2F
	jr nz, Label_67_5FA0
	ld a, [hli]
	cp a, $2F
	jr nz, Label_67_5FA0
	ld a, [wMobileErrorExtra]
	ld l, a
	ld a, [wMobileErrorExtra + 1]
	ld h, a
	ld de, $A463
	call CopyString
	ret

Label_67_5FA0:: ; 67:5FA0
	ld hl, $A463
	ld a, [wMobileErrorExtra]
	ld e, a
	ld a, [wMobileErrorExtra + 1]
	ld d, a
	call HttpRedirect_JoinRelative
	ld hl, $A463
	call HttpRedirect_NormalizePath
	ret

HttpRedirect_JoinRelative:: ; 67:5FB5
	ld a, [de]
	cp a, $2F
	jr nz, Label_67_5FE0

Label_67_5FBA:: ; 67:5FBA
	ld a, [hl]
	or a, a
	jr z, Label_67_5FC5
	cp a, $2F
	jr z, Label_67_5FC5
	inc hl
	jr Label_67_5FBA

Label_67_5FC5:: ; 67:5FC5
	inc hl
	ld a, [hl]
	cp a, $2F
	jr nz, Label_67_5FF2
	inc hl

Label_67_5FCC:: ; 67:5FCC
	ld a, [hl]
	or a, a
	jr z, Label_67_5FD7
	cp a, $2F
	jr z, Label_67_5FD7
	inc hl
	jr Label_67_5FCC

Label_67_5FD7:: ; 67:5FD7
	ld a, [hl]
	or a, a
	jr nz, Label_67_5FF2

; ---- code $5FDB-$5FE0 (5 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5F66-60BA by apply_coverage --split
	ld a, $2F
	ld [hl], a
	jr Label_67_5FF2

; ---- code $5FE0-$6014 (52 bytes) [CONFIRMED] 34 insn(s) executed; cut out of the PROBABLE region 5F66-60BA by apply_coverage --split [executed in 1 scenarios]

Label_67_5FE0:: ; 67:5FE0
	ld a, [hl]
	or a, a
	jr z, Label_67_5FE7
	inc hl
	jr Label_67_5FE0

Label_67_5FE7:: ; 67:5FE7
	dec hl
	ld a, [hl]
	cp a, $2F
	jr z, Label_67_5FF1
	inc hl
	ld a, $2F
	ld [hl], a

Label_67_5FF1:: ; 67:5FF1
	inc hl

Label_67_5FF2:: ; 67:5FF2
	ld a, [de]
	inc de
	ld [hli], a
	or a, a
	jr nz, Label_67_5FF2
	ret

HttpRedirect_NormalizePath:: ; 67:5FF9
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	ld d, h
	ld e, l

Label_67_6001:: ; 67:6001
	ld a, [hl]
	or a, a
	jp z, Label_67_6092
	cp a, $3F
	jp z, Label_67_6092
	cp a, $23
	jp z, Label_67_6092
	cp a, $5C
	jr nz, Label_67_6017

; ---- code $6014-$6017 (3 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5F66-60BA by apply_coverage --split
	ld a, $2F
	ld [hl], a

; ---- code $6017-$6024 (13 bytes) [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 5F66-60BA by apply_coverage --split [executed in 1 scenarios]

Label_67_6017:: ; 67:6017
	ld b, h
	ld c, l
	ld a, [bc]
	cp a, $2F
	jr nz, Label_67_6031
	inc bc
	ld a, [bc]
	cp a, $2E
	jr nz, Label_67_6031

; ---- code $6024-$6031 (13 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5F66-60BA by apply_coverage --split
	inc bc
	ld a, [bc]
	cp a, $2F
	jr z, Label_67_602E
	cp a, $5C
	jr nz, Label_67_6031

Label_67_602E:: ; 67:602E
	inc hl
	jr Label_67_608E

; ---- code $6031-$603E (13 bytes) [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 5F66-60BA by apply_coverage --split [executed in 1 scenarios]

Label_67_6031:: ; 67:6031
	ld b, h
	ld c, l
	ld a, [bc]
	cp a, $2F
	jr nz, Label_67_608B
	inc bc
	ld a, [bc]
	cp a, $2E
	jr nz, Label_67_608B

; ---- code $603E-$608B (77 bytes) [PROBABLE] 53 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5F66-60BA by apply_coverage --split
	inc bc
	ld a, [bc]
	cp a, $2E
	jr nz, Label_67_608B
	inc bc
	ld a, [bc]
	cp a, $2F
	jr z, Label_67_6059
	or a, a
	jr z, Label_67_6059
	cp a, $3F
	jr z, Label_67_6059
	cp a, $23
	jr z, Label_67_6059
	cp a, $5C
	jr nz, Label_67_608B

Label_67_6059:: ; 67:6059
	ldh a, [hRam_FFB0]
	ld c, a
	ldh a, [hRam_FFB1]
	ld b, a
	ld a, d
	sub a, b
	ld a, e
	sbc a, c
	jr z, Label_67_6066
	dec de

Label_67_6066:: ; 67:6066
	ldh a, [hRam_FFB0]
	ld c, a
	ldh a, [hRam_FFB1]
	ld b, a

Label_67_606C:: ; 67:606C
	ld a, [de]
	cp a, $2F
	jr z, Label_67_607A
	ld a, d
	sub a, b
	ld a, e
	sbc a, c
	jr z, Label_67_607A
	dec de
	jr Label_67_606C

Label_67_607A:: ; 67:607A
	inc hl
	inc hl
	ld b, h
	ld c, l
	ld a, [bc]
	cp a, $2E
	jr nz, Label_67_608E
	inc bc
	ld a, [bc]
	or a, a
	jr nz, Label_67_608E
	inc de
	jr Label_67_608E

; ---- code $608B-$6096 (11 bytes) [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 5F66-60BA by apply_coverage --split [executed in 1 scenarios]

Label_67_608B:: ; 67:608B
	ld a, [hl]
	ld [de], a
	inc de

Label_67_608E:: ; 67:608E
	inc hl
	jp Label_67_6001

Label_67_6092:: ; 67:6092
	ld a, [hl]
	or a, a
	jr z, Label_67_609B

; ---- code $6096-$609B (5 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5F66-60BA by apply_coverage --split
	ld [de], a
	inc de
	inc hl
	jr Label_67_6092

; ---- code $609B-$60B0 (21 bytes) [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 5F66-60BA by apply_coverage --split [executed in 1 scenarios]

Label_67_609B:: ; 67:609B
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
	jr nc, Label_67_60B9
	dec de
	ld a, [de]
	cp a, $2E
	jr nz, Label_67_60B9

; ---- code $60B0-$60B9 (9 bytes) [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5F66-60BA by apply_coverage --split
	dec de
	ld a, [de]
	cp a, $2F
	jr nz, Label_67_60B9
	inc de
	xor a, a
	ld [de], a

; ---- code $60B9-$60BA (1 bytes) [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 5F66-60BA by apply_coverage --split [executed in 1 scenarios]

Label_67_60B9:: ; 67:60B9
	ret
