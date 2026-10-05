; engine/settings/http_redirect.asm
; bank 67, $5F66-$60BA (340 bytes); pinned by layout.link
; HTTP redirect URL resolving/joining/normalising

SECTION "engine/settings/http_redirect", ROMX

HttpRedirect_ResolveUrl:: ; 67:5F66
	; [CONFIRMED] 220 insn(s) reached by static flow only; seeds: exec x220; min discovery hops 2;
	; entered by call from 67:5D5B (PROBABLE code) | 66 insn(s) executed; cut out of the PROBABLE
	; region 5F66-60BA by apply_coverage --split [executed in 1 scenarios]
	ld a, [wMobileErrorExtra]
	ld l, a
	ld a, [wMobileErrorExtra + 1]
	ld h, a
	ld a, [hli]
	cp a, $68
	jr nz, .l5FA0
	ld a, [hli]
	cp a, $74
	jr nz, .l5FA0
	ld a, [hli]
	cp a, $74
	jr nz, .l5FA0
	ld a, [hli]
	cp a, $70
	jr nz, .l5FA0
	ld a, [hli]
	cp a, $3A
	jr nz, .l5FA0
	ld a, [hli]
	cp a, $2F
	jr nz, .l5FA0
	ld a, [hli]
	cp a, $2F
	jr nz, .l5FA0
	ld a, [wMobileErrorExtra]
	ld l, a
	ld a, [wMobileErrorExtra + 1]
	ld h, a
	ld de, sPwdChg_HttpUrl
	call CopyString
	ret
.l5FA0 ; 67:5FA0
	ld hl, sPwdChg_HttpUrl
	ld a, [wMobileErrorExtra]
	ld e, a
	ld a, [wMobileErrorExtra + 1]
	ld d, a
	call HttpRedirect_JoinRelative
	ld hl, sPwdChg_HttpUrl
	call HttpRedirect_NormalizePath
	ret

HttpRedirect_JoinRelative:: ; 67:5FB5
	ld a, [de]
	cp a, $2F
	jr nz, .l5FE0
.l5FBA ; 67:5FBA
	ld a, [hl]
	or a, a
	jr z, .l5FC5
	cp a, $2F
	jr z, .l5FC5
	inc hl
	jr .l5FBA
.l5FC5 ; 67:5FC5
	inc hl
	ld a, [hl]
	cp a, $2F
	jr nz, .l5FF2
	inc hl
.l5FCC ; 67:5FCC
	ld a, [hl]
	or a, a
	jr z, .l5FD7
	cp a, $2F
	jr z, .l5FD7
	inc hl
	jr .l5FCC
.l5FD7 ; 67:5FD7
	ld a, [hl]
	or a, a
	jr nz, .l5FF2

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5F66-60BA by apply_coverage --split
	ld a, $2F
	ld [hl], a
	jr .l5FF2

.l5FE0 ; 67:5FE0
	; [CONFIRMED] 34 insn(s) executed; cut out of the PROBABLE region 5F66-60BA by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, [hl]
	or a, a
	jr z, .l5FE7
	inc hl
	jr .l5FE0
.l5FE7 ; 67:5FE7
	dec hl
	ld a, [hl]
	cp a, $2F
	jr z, .skip
	inc hl
	ld a, $2F
	ld [hl], a
.skip ; 67:5FF1
	inc hl
.l5FF2 ; 67:5FF2
	ld a, [de]
	inc de
	ld [hli], a
	or a, a
	jr nz, .l5FF2
	ret

HttpRedirect_NormalizePath:: ; 67:5FF9
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	ld d, h
	ld e, l
.l6001 ; 67:6001
	ld a, [hl]
	or a, a
	jp z, .l6092
	cp a, $3F
	jp z, .l6092
	cp a, $23
	jp z, .l6092
	cp a, $5C
	jr nz, .l6017

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5F66-60BA by apply_coverage --split
	ld a, $2F
	ld [hl], a

.l6017 ; 67:6017
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 5F66-60BA by apply_coverage
	; --split [executed in 1 scenarios]
	ld b, h
	ld c, l
	ld a, [bc]
	cp a, $2F
	jr nz, .l6031
	inc bc
	ld a, [bc]
	cp a, $2E
	jr nz, .l6031

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5F66-60BA by apply_coverage --split
	inc bc
	ld a, [bc]
	cp a, $2F
	jr z, .l602E
	cp a, $5C
	jr nz, .l6031
.l602E ; 67:602E
	inc hl
	jr .l608E

.l6031 ; 67:6031
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 5F66-60BA by apply_coverage
	; --split [executed in 1 scenarios]
	ld b, h
	ld c, l
	ld a, [bc]
	cp a, $2F
	jr nz, .l608B
	inc bc
	ld a, [bc]
	cp a, $2E
	jr nz, .l608B

	; [PROBABLE] 53 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5F66-60BA by apply_coverage --split
	inc bc
	ld a, [bc]
	cp a, $2E
	jr nz, .l608B
	inc bc
	ld a, [bc]
	cp a, $2F
	jr z, .l6059
	or a, a
	jr z, .l6059
	cp a, $3F
	jr z, .l6059
	cp a, $23
	jr z, .l6059
	cp a, $5C
	jr nz, .l608B
.l6059 ; 67:6059
	ldh a, [hRam_FFB0]
	ld c, a
	ldh a, [hRam_FFB1]
	ld b, a
	ld a, d
	sub a, b
	ld a, e
	sbc a, c
	jr z, .l6066
	dec de
.l6066 ; 67:6066
	ldh a, [hRam_FFB0]
	ld c, a
	ldh a, [hRam_FFB1]
	ld b, a
.l606C ; 67:606C
	ld a, [de]
	cp a, $2F
	jr z, .l607A
	ld a, d
	sub a, b
	ld a, e
	sbc a, c
	jr z, .l607A
	dec de
	jr .l606C
.l607A ; 67:607A
	inc hl
	inc hl
	ld b, h
	ld c, l
	ld a, [bc]
	cp a, $2E
	jr nz, .l608E
	inc bc
	ld a, [bc]
	or a, a
	jr nz, .l608E
	inc de
	jr .l608E

.l608B ; 67:608B
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 5F66-60BA by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, [hl]
	ld [de], a
	inc de
.l608E ; 67:608E
	inc hl
	jp .l6001
.l6092 ; 67:6092
	ld a, [hl]
	or a, a
	jr z, .l609B

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5F66-60BA by apply_coverage --split
	ld [de], a
	inc de
	inc hl
	jr .l6092

.l609B ; 67:609B
	; [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 5F66-60BA by apply_coverage
	; --split [executed in 1 scenarios]
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
	jr nc, .done
	dec de
	ld a, [de]
	cp a, $2E
	jr nz, .done

	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5F66-60BA by apply_coverage --split
	dec de
	ld a, [de]
	cp a, $2F
	jr nz, .done
	inc de
	xor a, a
	ld [de], a

.done ; 67:60B9
	; [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 5F66-60BA by apply_coverage
	; --split [executed in 1 scenarios]
	ret
