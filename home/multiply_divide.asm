; home/multiply_divide.asm
; bank 00, $0D34-$0DB9 (133 bytes); pinned by layout.link
; 32-bit multiply/divide (and the odd 0D34 routine)

SECTION "home/multiply_divide", ROM0

Function_00_0D34:: ; 00:0D34
	; [PROBABLE] normal nonaliasing flow: DE = signed byte at WRAM0[$C200+entry E]; restores AF.
	; Writes hROMBankLo/[$2100]: $F0, then entry A; no explicit high-bank write.
	; Entry A supplies the intended low bank; physical $F0-to-$70 wrap is unvalidated.
	; Purpose/caller and stack/IRQ contract unresolved; no maintained symbol caller found.
	push af
	ld d, $C2
	ld a, $F0
	ldh [hROMBankLo], a
	ld [$2100], a
	ld a, [de]
	ld e, a
	ld d, $00
	rla
	jr nc, .skip
	dec d
.skip ; 00:0D46
	pop af
	ldh [hROMBankLo], a
	ld [$2100], a
	ret

Multiply16x16to32:: ; 00:0D4D
	; [CONFIRMED] BC:HL = DE * HL (32-bit product); verified on interpreter [reached via inferred
	; links; raw refs 4] | 13 insn(s) executed; cut out of the PROBABLE region 0D4D-0D67 by
	; apply_coverage --split [executed in 15 scenarios]
	push af
	ld c, e
	ld b, d
	ld e, l
	ld d, h
	ld hl, $0000
	ld a, $10
.loop ; 00:0D57
	add hl, hl
	rl c
	rl b
	jr nc, .l0D62
	add hl, de
	jr nc, .l0D62

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 0D4D-0D67 by apply_coverage --split
	inc bc

.l0D62 ; 00:0D62
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 0D4D-0D67 by apply_coverage
	; --split [executed in 15 scenarios]
	dec a
	jr nz, .loop
	pop af
	ret

Divide16:: ; 00:0D67
	; [CONFIRMED] HL = HL / DE, DE = HL % DE (unsigned 16/16); verified on interpreter [reached via
	; inferred links; raw refs 12] [executed in 18 scenarios]
	ld c, e
	ld b, d
	ld e, l
	ld d, h
	ld hl, $0000
	ld a, $10
.loop ; 00:0D70
	push af
	sla e
	rl d
	ld a, l
	adc a, a
	ld l, a
	ld a, h
	adc a, a
	ld h, a
	ld a, l
	sub a, c
	ld l, a
	ld a, h
	sbc a, b
	ld h, a
	jr nc, .l0D86
	add hl, bc
	jr .l0D87
.l0D86 ; 00:0D86
	inc de
.l0D87 ; 00:0D87
	pop af
	dec a
	jr nz, .loop
	ld a, e
	ld e, l
	ld l, a
	ld a, d
	ld d, h
	ld h, a
	ret

Divide32by15:: ; 00:0D92
	; [CONFIRMED] BC:DE / HL -> DE = quotient, BC = remainder (unsigned; exact for HL<$8000 and
	; BC<HL); verified on 200 random cases on interpreter [reached via inferred links; raw refs 6]
	; [executed in 9 scenarios]
	ld a, $10
	or a, a
.loop ; 00:0D95
	ldh [hDivide32by15_BitsLeft], a
	rl e
	rl d
	rl c
	rl b
	ld a, c
	sub a, l
	ld c, a
	ld a, b
	sbc a, h
	ld b, a
	jr nc, .l0DAE
	ld a, c
	add a, l
	ld c, a
	ld a, b
	adc a, h
	ld b, a
	scf
.l0DAE ; 00:0DAE
	ccf
	ldh a, [hDivide32by15_BitsLeft]
	dec a
	jr nz, .loop
	rl e
	rl d
	ret
