; home/html_store.asm
; bank 00, $131A-$1408 (238 bytes); pinned by layout.link
; lookups in the bank 3F index of the built-in HTML store

SECTION "home/html_store", ROM0

HtmlStore_BuildPageUrl:: ; 00:131A
	; Historical address alias retired; proper operation name retained.
	; [CONFIRMED] bank3F index: B chooses prefix; C chooses a far filename (first3E:48A4).
	; Copy prefix then that filename to HL, following the selected record bank byte.
	; Existing entry observed in 5 historical scenarios; no arbitrary-index/buffer guarantee.
	call BankSwitch_H
	push hl
	ld hl, Table_HtmlStore_KeywordPointers
	ld a, $3F
	ldh [hROMBankLo], a
	ld [$2100], a
	ld e, b
	ld b, $00
	ld d, $00
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	pop hl
.copy_first_url_part ; 00:1334
	ld a, [de]
	ld [hli], a
	inc de
	or a, a
	jr nz, .copy_first_url_part
	inc de
	dec hl
	push hl
	ld h, b
	ld l, c
	add hl, hl
	add hl, bc
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ldh [hROMBankLo], a
	ld [$2100], a
	pop hl
.copy_selected_url_suffix ; 00:134D
	ld a, [de]
	ld [hli], a
	inc de
	or a, a
	jr nz, .copy_selected_url_suffix
	ret

HtmlStore_LoadPage:: ; 00:1354
	; Historical address alias retired; proper operation name retained.
	; [CONFIRMED] bank3F prefix index, then far filename records (first3E:48A4).
	; Entry capacity L; ordinary branch copies n=min(record_length,L-2) to output+2.
	; Header=(n-2) mod65536, not n; no-match header0. See dated original-contract note.
	; High(L-2)==$FF is an early reject, not a general checked-buffer guarantee.
	; Existing entry/main-path coverage does not confirm all inputs or unobserved branches.
	; [executed in 8 historical scenarios]
	dec bc
	dec bc
	ld a, b
	cp a, $FF
	ret z
	push de
	ld a, [wBrowserRxBank]
	call BankSwitch_D
	xor a, a
	ld [de], a
	inc de
	ld [de], a
	inc de
	push bc
	push de
	ld bc, Table_HtmlStore_KeywordPointers
	ld a, $3F
	ldh [hROMBankLo], a
	ld [$2100], a
.read_first_pointer_entry ; 00:1372
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	inc bc
	or a, e
	jp z, .clear_length_on_lookup_failure
	push bc
	push hl
.compare_first_string_loop ; 00:137E
	ld a, [de]
	inc de
	ld c, a
	ld a, [hli]
	or a, a
	jr z, .test_first_string_terminator
	cp a, c
	jr z, .compare_first_string_loop
.test_first_string_terminator ; 00:1388
	ld a, c
	or a, a
	jr z, .save_matched_entry_byte

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1354-1408 by apply_coverage --split
	pop hl
	pop bc
	jr .read_first_pointer_entry

.save_matched_entry_byte ; 00:1390
	; [CONFIRMED] 57 insn(s) executed; cut out of the PROBABLE region 1354-1408 by apply_coverage
	; --split [executed in 8 scenarios]
	ld a, [de]
	ld [wRam_C2DC], a
	inc de
	dec hl
	pop bc
	pop bc
	ld b, d
	ld c, e
.read_banked_pointer_entry ; 00:139A
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	inc bc
	or a, e
	jp z, .clear_length_on_lookup_failure
	ld a, [bc]
	ldh [hROMBankLo], a
	ld [$2100], a
	inc bc
	push bc
	push hl
.compare_banked_string_loop ; 00:13AD
	ld a, [de]
	inc de
	ld c, a
	ld a, [hli]
	or a, a
	jr z, .test_banked_string_terminator
	cp a, c
	jr z, .compare_banked_string_loop
.test_banked_string_terminator ; 00:13B7
	ld a, c
	or a, a
	jr z, .load_matched_length
	pop hl
	pop bc
	ld a, $3F
	ldh [hROMBankLo], a
	ld [$2100], a
	jr .read_banked_pointer_entry
.load_matched_length ; 00:13C6
	pop hl
	pop bc
	ld a, [de]
	ldh [hRam_FFB0], a
	inc de
	ld a, [de]
	ldh [hRam_FFB1], a
	inc de
	pop hl
	pop bc
	push de
	push hl
	ldh a, [hRam_FFB0]
	sub a, c
	ld e, a
	ldh a, [hRam_FFB1]
	sbc a, b
	jr c, .clamp_count_to_matched_length

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1354-1408 by apply_coverage --split
	or a, e
	jr nz, .copy_nonempty_payload

.clamp_count_to_matched_length ; 00:13E0
	; [CONFIRMED] 22 insn(s) executed; cut out of the PROBABLE region 1354-1408 by apply_coverage
	; --split [executed in 8 scenarios]
	ldh a, [hRam_FFB0]
	ld c, a
	ldh a, [hRam_FFB1]
	ld b, a
.copy_nonempty_payload ; 00:13E6
	pop de
	pop hl
	push bc
	ld a, b
	or a, c
	jr z, .store_count_minus_two
	call CopyBytes
.store_count_minus_two ; 00:13F0
	pop bc
	dec bc
	dec bc
	pop hl
	ld a, c
	ld [hli], a
	ldh [hRam_FFB1], a
	ld a, b
	ld [hli], a
	ldh [hRam_FFB0], a
	ret

.clear_length_on_lookup_failure ; 00:13FD
	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1354-1408 by apply_coverage --split
	pop de
	pop bc
	pop hl
	xor a, a
	ld [hli], a
	ld [hli], a
	ldh [hRam_FFB0], a
	ldh [hRam_FFB1], a
	ret
