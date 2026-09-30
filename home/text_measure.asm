; home/text_measure.asm
; bank 00, $1408-$14BF (183 bytes); pinned by layout.link
; text width/fit measurement

SECTION "home/text_measure", ROM0

Function_00_1408:: ; 00:1408
	; [CONFIRMED] text measure: A=bank, HL=string, BC=limit, DE=x: adds 6 per single-byte char, 12
	; per double-byte, $30 per tab; stops at 00/0A/0D; returns BC = bytes that fit [candidate; raw
	; refs 13] | 17 insn(s) executed; cut out of the PROBABLE region 1408-14BF by apply_coverage
	; --split [executed in 1 scenarios]
	call BankSwitch_H
	ld a, c
	ldh [hRam_FFB0], a
	ld a, b
	ldh [hRam_FFB1], a
	ld bc, $0000
.loop ; 00:1414
	ld a, [hli]
	cp a, $20
	jr nc, .l144D
	cp a, $00
	jp z, .l14B2
	cp a, $0A
	jp z, .l14B2
	cp a, $0D
	jp z, .l14B2
	cp a, $09
	jr z, .l142F

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1408-14BF by apply_coverage --split
	inc bc
	jr .loop

.l142F ; 00:142F
	; [CONFIRMED] 23 insn(s) executed; cut out of the PROBABLE region 1408-14BF by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, e
	add a, $30
	ld e, a
	ld a, d
	adc a, $00
	ld d, a
	bit 7, a
	jr nz, .loop
	ldh a, [hRam_FFB0]
	sub a, e
	ldh a, [hRam_FFB1]
	sbc a, d
	jr c, .l14AA
	jr nz, .l144A
	ldh a, [hRam_FFB0]
	sub a, e
	jr z, .l14A8
.l144A ; 00:144A
	inc bc
	jr .loop
.l144D ; 00:144D
	cp a, $81
	jr c, .l1465
	cp a, $A0
	jr c, .l1466

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1408-14BF by apply_coverage --split
	cp a, $E0
	jr c, .l1465
	cp a, $F0
	jr c, .l1466
	cp a, $F8
	jr c, .l1465
	cp a, $FA
	jr c, .l1466

.l1465 ; 00:1465
	; [CONFIRMED] 45 insn(s) executed; cut out of the PROBABLE region 1408-14BF by apply_coverage
	; --split [executed in 6 scenarios]
	or a, a
.l1466 ; 00:1466
	jr c, .l1486
	ld a, e
	add a, $06
	ld e, a
	ld a, d
	adc a, $00
	ld d, a
	bit 7, a
	jr nz, .loop
	ldh a, [hRam_FFB0]
	sub a, e
	ldh a, [hRam_FFB1]
	sbc a, d
	jr c, .l14AA
	jr nz, .l1483
	ldh a, [hRam_FFB0]
	sub a, e
	jr z, .l14A8
.l1483 ; 00:1483
	inc bc
	jr .loop
.l1486 ; 00:1486
	inc hl
	ld a, e
	add a, $0C
	ld e, a
	ld a, d
	adc a, $00
	ld d, a
	bit 7, a
	jr nz, .loop
	ldh a, [hRam_FFB0]
	sub a, e
	ldh a, [hRam_FFB1]
	sbc a, d
	jr c, .l14B4
	jr nz, .l14A2
	ldh a, [hRam_FFB0]
	sub a, e
	jr z, .l14A7
.l14A2 ; 00:14A2
	inc bc
	inc bc
	jp .loop
.l14A7 ; 00:14A7
	inc bc
.l14A8 ; 00:14A8
	inc bc
	ret

.l14AA ; 00:14AA
	; [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1408-14BF by apply_coverage --split
	ld a, e
	sub a, $06
	ld e, a
	ld a, d
	sbc a, $00
	ld d, a
.l14B2 ; 00:14B2
	dec hl
	ret
.l14B4 ; 00:14B4
	ld a, e
	sub a, $0C
	ld e, a
	ld a, d
	sbc a, $00
	ld d, a
	dec hl
	dec hl
	ret
