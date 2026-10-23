; home/string.asm
; bank 00, $14BF-$153D (126 bytes); pinned by layout.link
; CopyString, CompareString, StringLength, XOR-$A5 coders

SECTION "home/string", ROM0

CopyString:: ; 00:14BF
	; [CONFIRMED] copy [HL++] to [DE++] up to and including the $00 terminator [reached via inferred
	; links; raw refs 33] [executed in 32 scenarios]
	ld a, [hli]
	ld [de], a
	inc de
	or a, a
	jr nz, CopyString
	ret

CopyStringMax:: ; 00:14C6
	; [CONFIRMED] copy at most BC bytes, stop after the terminator [reached via inferred links; raw
	; refs 6] [executed in 6 scenarios]
	ld a, c
	or a, b
	ret z
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	or a, a
	jr nz, CopyStringMax
	ret

CopyStringMax_ZeroSourceIfEntryCountZero:: ; 00:14D1
	; Historical address alias retired; entry/copy CONFIRMED; entry-zero store PROBABLE.
	; [CONFIRMED] nonzero-entry copy; entry BC==0 source-zero branch is [PROBABLE] (see .zero_source_byte).
	; Later exhaustion joins CopyStringMax and returns without that explicit source store.
	; Entry/copy path observed in 2 historical scenarios; no zero-entry caller is established.
	ld a, c
	or a, b
	jr z, .zero_source_byte
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	or a, a
	jr nz, CopyStringMax
	ret

.zero_source_byte ; 00:14DD
	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 14D1-14E0 by apply_coverage --split
	xor a, a
	ld [hl], a
	ret

EncodeXorA5:: ; 00:14E0
	; [CONFIRMED] copy [HL++] to [DE++] XOR $A5 until the source byte is $00 (terminator is stored
	; as $A5) [candidate; raw refs 6] [executed in 8 scenarios]
	ld a, [hli]
	xor a, $A5
	ld [de], a
	inc de
	xor a, $A5
	jr nz, EncodeXorA5
	ret

DecodeXorA5:: ; 00:14EA
	; [CONFIRMED] copy [HL++] XOR $A5 to [DE++] until the decoded byte is $00 (inverse of
	; EncodeXorA5) [reached via inferred links; raw refs 23] [executed in 11 scenarios]
	ld a, [hli]
	xor a, $A5
	ld [de], a
	inc de
	or a, a
	jr nz, DecodeXorA5
	ret

StringAppend:: ; 00:14F3
	; Historical address alias retired; proper operation name retained.
	; [CONFIRMED] string append: finds the first byte equal to A in the string at DE and copies the
	; string at HL there (A=0: strcat) [reached via inferred links; raw refs 19] [executed in 10
	; scenarios]
	push hl
	ld h, d
	ld l, e
	pop de
.find_append_position ; 00:14F7
	cp a, [hl]
	inc hl
	jr nz, .find_append_position
	dec hl
	push hl
	ld h, d
	ld l, e
	pop de
.copy_append_string ; 00:1500
	ld a, [hli]
	ld b, a
	ld [de], a
	inc de
	ld a, b
	or a, a
	jr nz, .copy_append_string
	ret

CompareString:: ; 00:1509
	; [CONFIRMED] strcmp(HL, DE): A = [HL]-[DE] at the first difference (0 only if both strings end
	; together); verified on interpreter [reached via inferred links; raw refs 11] [executed in 14
	; scenarios]
	push hl
	ld h, d
	ld l, e
	pop de
	dec de
	dec hl
.compare_next_character ; 00:150F
	inc de
	inc hl
	ld a, [de]
	or a, a
	jr z, .return_character_difference
	cp a, [hl]
	jr z, .compare_next_character
.return_character_difference ; 00:1518
	sub a, [hl]
	ret

CompareStringN:: ; 00:151A
	; [CONFIRMED] like CompareString but compares at most B bytes (A = [HL]-[DE]); verified on
	; interpreter [candidate; raw refs 2] [executed in 34 scenarios]
	ld a, b
	and a, a
	jr z, .return_to_caller
.compare_bounded_character ; 00:151E
	dec b
	jr z, .compare_final_characters
	ld a, [hl]
	or a, a
	jr z, .compare_final_characters
	ld c, a
	ld a, [de]
	cp a, c
	jr nz, .compare_final_characters
	inc hl
	inc de
	jr .compare_bounded_character
.compare_final_characters ; 00:152E
	ld a, [de]
	ld c, a
	ld a, [hl]
	sub a, c
.return_to_caller ; 00:1532
	ret

StringLength:: ; 00:1533
	; [CONFIRMED] BC = length of the $00-terminated string at HL [reached via inferred links; raw
	; refs 5] [executed in 7 scenarios]
	xor a, a
	ld bc, $FFFF
.count_string_byte ; 00:1537
	cp a, [hl]
	inc hl
	inc bc
	jr nz, .count_string_byte
	ret
