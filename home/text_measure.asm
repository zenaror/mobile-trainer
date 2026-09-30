; home/text_measure.asm
; bank 00, $1408-$14BF (183 bytes); pinned by layout.link
; text width/fit measurement

SECTION "home/text_measure", ROM0

; ---- code $1408-$142C (36 bytes) [CONFIRMED] text measure: A=bank, HL=string, BC=limit, DE=x: adds 6 per single-byte char, 12 per double-byte, $30 per tab; stops at 00/0A/0D; returns BC = bytes that fit [candidate; raw refs 13] | 17 insn(s) executed; cut out of the PROBABLE region 1408-14BF by apply_coverage --split [executed in 1 scenarios]

Function_00_1408:: ; 00:1408
	call BankSwitch_H
	ld a, c
	ldh [hRam_FFB0], a
	ld a, b
	ldh [hRam_FFB1], a
	ld bc, $0000

Label_00_1414:: ; 00:1414
	ld a, [hli]
	cp a, $20
	jr nc, Label_00_144D
	cp a, $00
	jp z, Label_00_14B2
	cp a, $0A
	jp z, Label_00_14B2
	cp a, $0D
	jp z, Label_00_14B2
	cp a, $09
	jr z, Label_00_142F

; ---- code $142C-$142F (3 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 1408-14BF by apply_coverage --split
	inc bc
	jr Label_00_1414

; ---- code $142F-$1455 (38 bytes) [CONFIRMED] 23 insn(s) executed; cut out of the PROBABLE region 1408-14BF by apply_coverage --split [executed in 1 scenarios]

Label_00_142F:: ; 00:142F
	ld a, e
	add a, $30
	ld e, a
	ld a, d
	adc a, $00
	ld d, a
	bit 7, a
	jr nz, Label_00_1414
	ldh a, [hRam_FFB0]
	sub a, e
	ldh a, [hRam_FFB1]
	sbc a, d
	jr c, Label_00_14AA
	jr nz, Label_00_144A
	ldh a, [hRam_FFB0]
	sub a, e
	jr z, Label_00_14A8

Label_00_144A:: ; 00:144A
	inc bc
	jr Label_00_1414

Label_00_144D:: ; 00:144D
	cp a, $81
	jr c, Label_00_1465
	cp a, $A0
	jr c, Label_00_1466

; ---- code $1455-$1465 (16 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 1408-14BF by apply_coverage --split
	cp a, $E0
	jr c, Label_00_1465
	cp a, $F0
	jr c, Label_00_1466
	cp a, $F8
	jr c, Label_00_1465
	cp a, $FA
	jr c, Label_00_1466

; ---- code $1465-$14AA (69 bytes) [CONFIRMED] 45 insn(s) executed; cut out of the PROBABLE region 1408-14BF by apply_coverage --split [executed in 6 scenarios]

Label_00_1465:: ; 00:1465
	or a, a

Label_00_1466:: ; 00:1466
	jr c, Label_00_1486
	ld a, e
	add a, $06
	ld e, a
	ld a, d
	adc a, $00
	ld d, a
	bit 7, a
	jr nz, Label_00_1414
	ldh a, [hRam_FFB0]
	sub a, e
	ldh a, [hRam_FFB1]
	sbc a, d
	jr c, Label_00_14AA
	jr nz, Label_00_1483
	ldh a, [hRam_FFB0]
	sub a, e
	jr z, Label_00_14A8

Label_00_1483:: ; 00:1483
	inc bc
	jr Label_00_1414

Label_00_1486:: ; 00:1486
	inc hl
	ld a, e
	add a, $0C
	ld e, a
	ld a, d
	adc a, $00
	ld d, a
	bit 7, a
	jr nz, Label_00_1414
	ldh a, [hRam_FFB0]
	sub a, e
	ldh a, [hRam_FFB1]
	sbc a, d
	jr c, Label_00_14B4
	jr nz, Label_00_14A2
	ldh a, [hRam_FFB0]
	sub a, e
	jr z, Label_00_14A7

Label_00_14A2:: ; 00:14A2
	inc bc
	inc bc
	jp Label_00_1414

Label_00_14A7:: ; 00:14A7
	inc bc

Label_00_14A8:: ; 00:14A8
	inc bc
	ret

; ---- code $14AA-$14BF (21 bytes) [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region 1408-14BF by apply_coverage --split

Label_00_14AA:: ; 00:14AA
	ld a, e
	sub a, $06
	ld e, a
	ld a, d
	sbc a, $00
	ld d, a

Label_00_14B2:: ; 00:14B2
	dec hl
	ret

Label_00_14B4:: ; 00:14B4
	ld a, e
	sub a, $0C
	ld e, a
	ld a, d
	sbc a, $00
	ld d, a
	dec hl
	dec hl
	ret
