; home/text_measure.asm
; bank 00, $1408-$14BF (183 bytes); pinned by layout.link
; text width/fit measurement

SECTION "home/text_measure", ROM0

Text_MeasureFit:: ; 00:1408
	; Historical address alias retired; proper operation name retained.
	; [CONFIRMED] text measure: A=bank, HL=string, BC=limit, DE=x: adds 6 per single-byte char, 12
	; per double-byte, $30 per tab; stops at 00/0A/0D; returns BC = bytes that fit [candidate; raw
	; refs 13] | 17 insn(s) executed; cut out of the PROBABLE region 1408-14BF by apply_coverage
	; --split [executed in 1 scenarios]
	call BankSwitch_H
	ld a, c
	ldh [hTextMeasure_RightLimitX], a
	ld a, b
	ldh [hTextMeasure_RightLimitXHi], a
	ld bc, $0000
.measure_next_character ; 00:1414
	ld a, [hli]
	cp a, $20
	jr nc, .classify_character_width
	cp a, $00
	jp z, .back_up_one_source_byte_and_return
	cp a, $0A
	jp z, .back_up_one_source_byte_and_return
	cp a, $0D
	jp z, .back_up_one_source_byte_and_return
	cp a, $09
	jr z, .add_30_and_check_right_limit

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1408-14BF by apply_coverage --split
	inc bc
	jr .measure_next_character

.add_30_and_check_right_limit ; 00:142F
	; [CONFIRMED] 23 insn(s) executed; cut out of the PROBABLE region 1408-14BF by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, e
	add a, $30
	ld e, a
	ld a, d
	adc a, $00
	ld d, a
	bit 7, a
	jr nz, .measure_next_character
	ldh a, [hTextMeasure_RightLimitX]
	sub a, e
	ldh a, [hTextMeasure_RightLimitXHi]
	sbc a, d
	jr c, .undo_width06
	jr nz, .count_one_byte_and_continue
	ldh a, [hTextMeasure_RightLimitX]
	sub a, e
	jr z, .count_final_byte_and_return
.count_one_byte_and_continue ; 00:144A
	inc bc
	jr .measure_next_character
.classify_character_width ; 00:144D
	cp a, $81
	jr c, .clear_carry_for_narrow_char
	cp a, $A0
	jr c, .measure_narrow_unless_carry

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1408-14BF by apply_coverage --split
	cp a, $E0
	jr c, .clear_carry_for_narrow_char
	cp a, $F0
	jr c, .measure_narrow_unless_carry
	cp a, $F8
	jr c, .clear_carry_for_narrow_char
	cp a, $FA
	jr c, .measure_narrow_unless_carry

.clear_carry_for_narrow_char ; 00:1465
	; [CONFIRMED] 45 insn(s) executed; cut out of the PROBABLE region 1408-14BF by apply_coverage
	; --split [executed in 6 scenarios]
	or a, a
.measure_narrow_unless_carry ; 00:1466
	jr c, .measure_wide_character
	ld a, e
	add a, $06
	ld e, a
	ld a, d
	adc a, $00
	ld d, a
	bit 7, a
	jr nz, .measure_next_character
	ldh a, [hTextMeasure_RightLimitX]
	sub a, e
	ldh a, [hTextMeasure_RightLimitXHi]
	sbc a, d
	jr c, .undo_width06
	jr nz, .count_narrow_byte_and_continue
	ldh a, [hTextMeasure_RightLimitX]
	sub a, e
	jr z, .count_final_byte_and_return
.count_narrow_byte_and_continue ; 00:1483
	inc bc
	jr .measure_next_character
.measure_wide_character ; 00:1486
	inc hl
	ld a, e
	add a, $0C
	ld e, a
	ld a, d
	adc a, $00
	ld d, a
	bit 7, a
	jr nz, .measure_next_character
	ldh a, [hTextMeasure_RightLimitX]
	sub a, e
	ldh a, [hTextMeasure_RightLimitXHi]
	sbc a, d
	jr c, .undo_width0c_and_back_up_two_bytes
	jr nz, .count_wide_bytes_and_continue
	ldh a, [hTextMeasure_RightLimitX]
	sub a, e
	jr z, .count_extra_wide_byte_at_limit
.count_wide_bytes_and_continue ; 00:14A2
	inc bc
	inc bc
	jp .measure_next_character
.count_extra_wide_byte_at_limit ; 00:14A7
	inc bc
.count_final_byte_and_return ; 00:14A8
	inc bc
	ret

.undo_width06 ; 00:14AA
	; [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1408-14BF by apply_coverage --split
	ld a, e
	sub a, $06
	ld e, a
	ld a, d
	sbc a, $00
	ld d, a
.back_up_one_source_byte_and_return ; 00:14B2
	dec hl
	ret
.undo_width0c_and_back_up_two_bytes ; 00:14B4
	ld a, e
	sub a, $0C
	ld e, a
	ld a, d
	sbc a, $00
	ld d, a
	dec hl
	dec hl
	ret
