; home/keyword_scan.asm
; bank 00, $10E9-$131A (561 bytes); pinned by layout.link
; keyword lookup and token/attribute scanner

SECTION "home/keyword_scan", ROM0

Html_MatchKeyword:: ; 00:10E9
	; Historical address alias retired; proper operation name retained.
	; [CONFIRMED] compare HL text with BC keyword pointers; fold input-side ASCII case only.
	; Return metadata after TABLE keyword; retry uses caller-saved start at FFB0/FFB1.
	; A null table terminator alone does not supply a safe arbitrary direct-call contract.
	call Sound_FrameService
.read_next_keyword_pointer ; 00:10EC
	ld a, [bc]
	inc bc
	ld e, a
	ld a, [bc]
	inc bc
	ld d, a
	or a, e
	ret z
	push bc
.compare_keyword_case_folded ; 00:10F5
	ld a, [de]
	inc de
	ld c, a
	ld a, [hli]
	or a, a
	jr z, .check_keyword_terminator
	cp a, $41
	jr c, .compare_folded_character
	cp a, $5B
	jr nc, .compare_folded_character
	add a, $20
.compare_folded_character ; 00:1106
	cp a, c
	jr z, .compare_keyword_case_folded
	dec hl
.check_keyword_terminator ; 00:110A
	ld a, c
	pop bc
	or a, a
	jr z, .return_keyword_value
	ldh a, [hRam_FFB0]
	ld l, a
	ldh a, [hRam_FFB1]
	ld h, a
	jr .read_next_keyword_pointer
.return_keyword_value ; 00:1117
	ld a, [de]
	ret

Html_ScanAttributes:: ; 00:1119
	; Historical address alias retired; proper operation name retained.
	; [CONFIRMED] token/attribute scanner over an ASCII-like stream: stops at $00 or $3E (>),
	; handles $3D (=), quotes $22/$27, skips bytes <$21; uses 10E9 for keywords, DE=$C380 output.
	; HYPOTHESIS: HTML-like tag parser [reached via inferred links; raw refs 236] | 12 insn(s)
	; executed; cut out of the PROBABLE region 1119-131A by apply_coverage --split [executed in 15
	; scenarios]
	call Sound_FrameService
.scan_attribute_name ; 00:111C
	ld a, [hli]
	or a, a
	jr z, .return_zero_with_cursor_backed_up
	cp a, $3E
	jr z, .return_zero_with_cursor_backed_up
	cp a, $3D
	jp z, .classify_unmatched_value
	cp a, $21
	jr c, .skip_attribute_whitespace
	cp a, $81
	jr c, .clear_carry_for_single_byte

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	cp a, $A0
	jr c, .skip_trail_byte_if_carry
	cp a, $E0
	jr c, .clear_carry_for_single_byte
	cp a, $F0
	jr c, .skip_trail_byte_if_carry
	cp a, $F8
	jr c, .clear_carry_for_single_byte
	cp a, $FA
	jr c, .skip_trail_byte_if_carry

.clear_carry_for_single_byte ; 00:1145
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 15 scenarios]
	or a, a
.skip_trail_byte_if_carry ; 00:1146
	jr nc, .match_attribute_keyword

	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	ld a, [hli]
	jr .scan_attribute_name
.restore_de_bc_before_no_value ; 00:114B
	ldh a, [hRam_FFB0]
	ld e, a
	ldh a, [hRam_FFB1]
	ld d, a
	pop bc

.return_zero_with_cursor_backed_up ; 00:1152
	; [CONFIRMED] 46 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 15 scenarios]
	dec hl
	xor a, a
	ret
.skip_attribute_whitespace ; 00:1155
	ld a, [hli]
	or a, a
	jr z, .return_zero_with_cursor_backed_up
	cp a, $3D
	jp z, .classify_unmatched_value
	cp a, $21
	jr c, .skip_attribute_whitespace
	dec hl
	jr .scan_attribute_name
.match_attribute_keyword ; 00:1165
	dec hl
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	push bc
	push de
	call Html_MatchKeyword
	pop de
	or a, a
	jr nz, .prepare_attribute_value_buffer
	ldh a, [hRam_FFB0]
	ld l, a
	ldh a, [hRam_FFB1]
	ld h, a
	inc hl
	pop bc
	jr .scan_attribute_name
.prepare_attribute_value_buffer ; 00:117F
	ld c, a
	ld b, $00
	ld a, e
	ldh [hRam_FFB0], a
	ld a, d
	ldh [hRam_FFB1], a
	ld de, wAttrUrlBuf
.find_attribute_equals ; 00:118B
	ld a, [hli]
	or a, a
	jr z, .restore_de_bc_before_no_value
	cp a, $3E
	jr z, .restore_de_bc_before_no_value
	cp a, $21
	jr c, .skip_whitespace_before_equals
	cp a, $3D
	jr z, .classify_value_after_equals

	; [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	ldh a, [hRam_FFB0]
	ld e, a
	ldh a, [hRam_FFB1]
	ld d, a
	pop bc
	jp .scan_attribute_name
.skip_whitespace_before_equals ; 00:11A5
	ld a, [hli]
	or a, a
	jr z, .restore_de_bc_before_no_value
	cp a, $21
	jr c, .skip_whitespace_before_equals
	dec hl
	jr .find_attribute_equals

.classify_value_after_equals ; 00:11B0
	; [CONFIRMED] 25 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 3 scenarios]
	ld a, [hli]
	or a, a
	jr z, .restore_de_bc_before_no_value
	cp a, $3E
	jr z, .restore_de_bc_before_no_value
	cp a, $22
	jp z, .copy_double_quoted_value
	cp a, $27
	jp z, .copy_single_quoted_value
	cp a, $21
	jr c, .classify_value_after_equals
	dec hl
.copy_unquoted_value ; 00:11C7
	ld a, [hli]
	or a, a
	jr z, .back_up_source_before_terminating_value
	cp a, $3E
	jr z, .back_up_source_before_terminating_value
	cp a, $21
	jr c, .terminate_value_and_return_keyword
	inc b
	jr z, .terminate_value_and_return_keyword
	ld [de], a
	inc de
	cp a, $81
	jr c, .clear_carry_for_single_unquoted_byte

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	cp a, $A0
	jr c, .copy_unquoted_trail_byte_if_carry
	cp a, $E0
	jr c, .clear_carry_for_single_unquoted_byte
	cp a, $F0
	jr c, .copy_unquoted_trail_byte_if_carry
	cp a, $F8
	jr c, .clear_carry_for_single_unquoted_byte
	cp a, $FA
	jr c, .copy_unquoted_trail_byte_if_carry

.clear_carry_for_single_unquoted_byte ; 00:11F0
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 3 scenarios]
	or a, a
.copy_unquoted_trail_byte_if_carry ; 00:11F1
	jr nc, .copy_unquoted_value

	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	inc b
	jr z, .back_up_output_on_length_wrap
	ld a, [hli]
	ld [de], a
	inc de
	jr .copy_unquoted_value

.back_up_source_before_terminating_value ; 00:11FB
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 4 scenarios]
	dec hl
	jr .terminate_value_and_return_keyword

.back_up_output_on_length_wrap ; 00:11FE
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	dec de

.terminate_value_and_return_keyword ; 00:11FF
	; [CONFIRMED] 24 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 15 scenarios]
	xor a, a
	ld [de], a
	ldh a, [hRam_FFB0]
	ld e, a
	ldh a, [hRam_FFB1]
	ld d, a
	ld a, c
	pop bc
	ret
.copy_double_quoted_value ; 00:120A
	ld a, [hli]
	or a, a
	jr z, .back_up_source_before_terminating_value
	cp a, $3E
	jr z, .back_up_source_before_terminating_value
	cp a, $22
	jr z, .terminate_value_and_return_keyword
	inc b
	jr z, .terminate_value_and_return_keyword
	cp a, $20
	jr c, .copy_double_quoted_value
	ld [de], a
	inc de
	cp a, $81
	jr c, .clear_carry_for_single_double_quoted_byte

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	cp a, $A0
	jr c, .copy_double_quoted_trail_byte_if_carry
	cp a, $E0
	jr c, .clear_carry_for_single_double_quoted_byte
	cp a, $F0
	jr c, .copy_double_quoted_trail_byte_if_carry
	cp a, $F8
	jr c, .clear_carry_for_single_double_quoted_byte
	cp a, $FA
	jr c, .copy_double_quoted_trail_byte_if_carry

.clear_carry_for_single_double_quoted_byte ; 00:1237
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 15 scenarios]
	or a, a
.copy_double_quoted_trail_byte_if_carry ; 00:1238
	jr nc, .copy_double_quoted_value

	; [PROBABLE] 39 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	inc b
	jr z, .back_up_output_on_length_wrap
	ld a, [hli]
	ld [de], a
	inc de
	jr .copy_double_quoted_value
.copy_single_quoted_value ; 00:1242
	ld a, [hli]
	or a, a
	jr z, .back_up_source_before_terminating_value
	cp a, $3E
	jr z, .back_up_source_before_terminating_value
	cp a, $27
	jr z, .terminate_value_and_return_keyword
	inc b
	jr z, .terminate_value_and_return_keyword
	cp a, $20
	jr c, .copy_single_quoted_value
	ld [de], a
	inc de
	cp a, $81
	jr c, .clear_carry_for_single_single_quoted_byte
	cp a, $A0
	jr c, .copy_single_quoted_trail_byte_if_carry
	cp a, $E0
	jr c, .clear_carry_for_single_single_quoted_byte
	cp a, $F0
	jr c, .copy_single_quoted_trail_byte_if_carry
	cp a, $F8
	jr c, .clear_carry_for_single_single_quoted_byte
	cp a, $FA
	jr c, .copy_single_quoted_trail_byte_if_carry
.clear_carry_for_single_single_quoted_byte ; 00:126F
	or a, a
.copy_single_quoted_trail_byte_if_carry ; 00:1270
	jr nc, .copy_single_quoted_value
	inc b
	jr z, .back_up_output_on_length_wrap
	ld a, [hli]
	ld [de], a
	inc de
	jr .copy_single_quoted_value

.classify_unmatched_value ; 00:127A
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 6 scenarios]
	ld a, [hli]
	or a, a
	jp z, .return_zero_with_cursor_backed_up
	cp a, $3E
	jp z, .return_zero_with_cursor_backed_up
	cp a, $22
	jp z, .skip_double_quoted_value

	; [PROBABLE] 28 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	cp a, $27
	jp z, .skip_single_quoted_value
	cp a, $21
	jr c, .classify_unmatched_value
	dec hl
.skip_unquoted_value ; 00:1293
	ld a, [hli]
	or a, a
	jp z, .return_zero_with_cursor_backed_up
	cp a, $3E
	jp z, .return_zero_with_cursor_backed_up
	cp a, $21
	jp c, .scan_attribute_name
	cp a, $81
	jr c, .clear_carry_for_single_skipped_byte
	cp a, $A0
	jr c, .skip_unquoted_trail_byte_if_carry
	cp a, $E0
	jr c, .clear_carry_for_single_skipped_byte
	cp a, $F0
	jr c, .skip_unquoted_trail_byte_if_carry
	cp a, $F8
	jr c, .clear_carry_for_single_skipped_byte
	cp a, $FA
	jr c, .skip_unquoted_trail_byte_if_carry
.clear_carry_for_single_skipped_byte ; 00:12BA
	or a, a
.skip_unquoted_trail_byte_if_carry ; 00:12BB
	jr nc, .skip_unquoted_value
	ld a, [hli]
	jr .skip_unquoted_value

.skip_double_quoted_value ; 00:12C0
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 6 scenarios]
	ld a, [hli]
	or a, a
	jp z, .return_zero_with_cursor_backed_up
	cp a, $3E
	jp z, .return_zero_with_cursor_backed_up
	cp a, $22
	jp z, .scan_attribute_name
	cp a, $81
	jr c, .clear_carry_for_single_skipped_double_quoted_byte

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	cp a, $A0
	jr c, .skip_double_quoted_trail_byte_if_carry
	cp a, $E0
	jr c, .clear_carry_for_single_skipped_double_quoted_byte
	cp a, $F0
	jr c, .skip_double_quoted_trail_byte_if_carry
	cp a, $F8
	jr c, .clear_carry_for_single_skipped_double_quoted_byte
	cp a, $FA
	jr c, .skip_double_quoted_trail_byte_if_carry

.clear_carry_for_single_skipped_double_quoted_byte ; 00:12E7
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 6 scenarios]
	or a, a
.skip_double_quoted_trail_byte_if_carry ; 00:12E8
	jr nc, .skip_double_quoted_value

	; [PROBABLE] 25 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	ld a, [hli]
	jr .skip_double_quoted_value
.skip_single_quoted_value ; 00:12ED
	ld a, [hli]
	or a, a
	jp z, .return_zero_with_cursor_backed_up
	cp a, $3E
	jp z, .return_zero_with_cursor_backed_up
	cp a, $27
	jp z, .scan_attribute_name
	cp a, $81
	jr c, .clear_carry_for_single_skipped_single_quoted_byte
	cp a, $A0
	jr c, .skip_single_quoted_trail_byte_if_carry
	cp a, $E0
	jr c, .clear_carry_for_single_skipped_single_quoted_byte
	cp a, $F0
	jr c, .skip_single_quoted_trail_byte_if_carry
	cp a, $F8
	jr c, .clear_carry_for_single_skipped_single_quoted_byte
	cp a, $FA
	jr c, .skip_single_quoted_trail_byte_if_carry
.clear_carry_for_single_skipped_single_quoted_byte ; 00:1314
	or a, a
.skip_single_quoted_trail_byte_if_carry ; 00:1315
	jr nc, .skip_single_quoted_value
	ld a, [hli]
	jr .skip_single_quoted_value
