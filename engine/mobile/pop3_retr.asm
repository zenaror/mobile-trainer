; engine/mobile/pop3_retr.asm
; bank 54, $4CB0-$5168 (1208 bytes); pinned by layout.link
; POP3 RETR start and poll

SECTION "engine/mobile/pop3_retr", ROMX

Pop3_StartRetr:: ; 54:4CB0
	; [CONFIRMED] 366 insn(s) reached by static flow only; seeds: exec x366; min discovery hops 9;
	; entered by far from 26:48CC (PROBABLE code) | 42 insn(s) executed; cut out of the PROBABLE
	; region 4CB0-4FC3 by apply_coverage --split [executed in 1 scenarios]
	push hl
	call Mobile_ResetCommandTimer
	pop hl
	ld a, l
	ld [wMobileTaskArgs + 4], a
	ld a, h
	ld [wMobileTaskArgs + 5], a
	ld a, $03
	ld [wMobileRetriesLeft], a
	ld a, $01
	ld [wMobileTaskKind], a
	xor a, a
	ld [wMobileTaskStep], a
	ld [wRam_C240], a
	ldh a, [hSRAMBank]
	ld [wPop3SavedSramBank], a
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ld [wMailFetchStatus], a
	ld de, sNetWorkPage
	ld bc, $0FFF
	ld a, $24
	farcall MobileAPI
	ret

Pop3_RetrPoll:: ; 54:4CF4
	call Mobile_CheckTimeout
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, .fetch_result_return_ff
	bit 2, a
	jr nz, .call_retr_api_with_zero_capacity
	bit 0, a
	jr z, .advance_retr_step
	ld a, $01
	ret
.fetch_result_return_ff ; 54:4D09
	call Mobile_FetchResult
	ld a, $FF
	ret

.call_retr_api_with_zero_capacity ; 54:4D0F
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	ld de, wRam_C480
	ld bc, $0000
	ld a, $24
	farcall MobileAPI
	ld a, $01
	ret

.advance_retr_step ; 54:4D20
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage
	; --split [executed in 5 scenarios]
	ld hl, wMobileTaskStep
	inc [hl]
	ld a, [hl]
	dec a
	jr z, .parse_retr_mail
	dec a
	jr z, .return_fetch_status_and_clear_task

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	ld a, $FF
	ret

.return_fetch_status_and_clear_task ; 54:4D2E
	; [CONFIRMED] 40 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage
	; --split [executed in 5 scenarios]
	ld a, [wMailFetchStatus]
	ld b, a
	ld hl, wMobileTaskKind
	xor a, a
	ld [hl], a
	ret
.parse_retr_mail ; 54:4D38
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call Mail_ScanAndCheckGameMail
	or a, a
	jp nz, .restore_banks_and_finish_status_1
	ld de, wRam_C240
	ld hl, Data_Pop3Retr_ParseBodyArgs
	ld bc, $0008
	farcall CopyBytes
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $04
	ld de, wRam_C240
	farcall Mail_DispatchFar
	or a, a
	jp nz, .restore_banks_and_finish_status_1
	ld de, wRam_C240
	ld hl, Data_Pop3Retr_DecodeFromHeaderArgs
	ld bc, $0007
	farcall CopyBytes
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $06
	ld de, wRam_C240
	farcall Mail_DispatchFar
	or a, a
	jr z, .convert_and_split_from_header

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	ld a, $02
	ld [wMailFetchStatus], a
	jr .decode_subject_header

.convert_and_split_from_header ; 54:4D9A
	; [CONFIRMED] 40 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage
	; --split [executed in 6 scenarios]
	ld de, wRam_C480
	add hl, de
	xor a, a
	ld [hl], a
	ld de, wRam_C580
	ld hl, wRam_C480
	ld bc, $0200
	farcall Charset_Iso2022JpToSjis
	farcall MailRecord_GetFreeSlotPtr
	ld bc, $00C9
	push hl
	add hl, bc
	ld e, l
	ld d, h
	pop hl
	ld bc, $00ED
	add hl, bc
	call Mail_SplitFromHeader
	ld hl, wMailFrom_AddressDest
	ld a, [hli]
	ld h, [hl]
	ld l, a
.cut_from_address_at_space ; 54:4DCA
	ld a, [hli]
	or a, a
	jr z, .decode_subject_header
	cp a, $20
	jr nz, .cut_from_address_at_space
	dec hl
	xor a, a
	ld [hl], a
.decode_subject_header ; 54:4DD5
	ld a, $05
	ld [wRam_C240], a
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $06
	ld de, wRam_C240
	farcall Mail_DispatchFar
	or a, a
	jr z, .l4DF5

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	ld a, $02
	ld [wMailFetchStatus], a
	jr .decode_date_header

.l4DF5 ; 54:4DF5
	; [CONFIRMED] 47 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage
	; --split [executed in 4 scenarios]
	ld de, wRam_C480
	add hl, de
	xor a, a
	ld [hl], a
	farcall MailRecord_GetFreeSlotPtr
	ld de, $00D9
	add hl, de
	ld e, l
	ld d, h
	push hl
	ld hl, wRam_C480
	ld bc, $0014
	farcall Charset_Iso2022JpToSjis
	ld hl, wRam_C580
	ld b, $1A
	xor a, a
.clear_subject_measure_buffer ; 54:4E1A
	ld [hli], a
	dec b
	jr nz, .clear_subject_measure_buffer
	ld hl, wRam_C480
	ld de, wRam_C580
	ld bc, $0018
	farcall Charset_Iso2022JpToSjis
	ld hl, wRam_C580
	ld b, $FF
.count_converted_subject_bytes ; 54:4E32
	inc b
	ld a, [hli]
	or a, a
	jr nz, .count_converted_subject_bytes
	pop hl
	ld a, b
	cp a, $15
	jr c, .decode_date_header
	ld a, $02
	ld [wMailFetchStatus], a
	ld b, $12
	call Text_TruncateSjis
.decode_date_header ; 54:4E47
	ld a, $06
	ld [wRam_C240], a
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $06
	ld de, wRam_C240
	farcall Mail_DispatchFar
	or a, a
	jr z, .store_date_and_prepare_body

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	ld a, $02
	ld [wMailFetchStatus], a
	jr .l4DF5

.store_date_and_prepare_body ; 54:4E67
	; [CONFIRMED] 42 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage
	; --split [executed in 6 scenarios]
	call Mail_ParseDate
	farcall MailRecord_GetFreeSlotPtr
	ld de, $0003
	add hl, de
	ld e, l
	ld d, h
	ld hl, wRam_C580
	ld bc, $0006
	farcall CopyBytes
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, sPop3RetrBodyPtrLen + $03
	ld a, [hld]
	ld b, a
	ld a, [hld]
	ld c, a
	ld a, [hld]
	ld l, [hl]
	ld h, a
	push hl
	add hl, bc
.trim_body_trailing_crlf ; 54:4E95
	xor a, a
	ld [hld], a
	ld a, [hl]
	cp a, $0A
	jr z, .trim_body_trailing_crlf
	cp a, $0D
	jr z, .trim_body_trailing_crlf
	pop hl
	ld bc, $00C1
	ld de, wRam_C480
	farcall Charset_Iso2022JpToSjis
	ld hl, wRam_C480
	ld b, $C0
.replace_body_tabs_with_spaces ; 54:4EB2
	dec b
	jr z, .select_body_copy_method
	ld a, [hli]
	or a, a
	jr z, .select_body_copy_method
	cp a, $09
	jr nz, .replace_body_tabs_with_spaces

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	dec hl
	ld a, $20
	ld [hli], a
	jr .replace_body_tabs_with_spaces

.select_body_copy_method ; 54:4EC3
	; [CONFIRMED] 53 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage
	; --split [executed in 4 scenarios]
	ld b, $00
	ld hl, wRam_C480
	ld a, $C0
	cp a, c
	jr c, .init_body_byte_count
	jr z, .init_body_byte_count
	add hl, bc
	xor a, a
	ld [hl], a
	farcall MailRecord_GetFreeSlotPtr
	ld de, $0009
	add hl, de
	ld e, l
	ld d, h
	ld hl, wRam_C480
	farcall CopyString
.mark_record_and_request_dele ; 54:4EE7
	farcall MailRecord_GetFreeSlotPtr
	ld a, $01
	ld [hli], a
	ld a, [wPop3_BodyIncomplete]
	ld [hli], a
	ld [hl], a
	xor a, a
	farcall SramCheck_Bank0Commit
	ld a, [wPop3SavedSramBank]
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, wMobileTaskArgs + $04
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $26
	farcall MobileAPI
	ld a, $01
	ret
.init_body_byte_count ; 54:4F24
	ld b, $00
	ld hl, wRam_C480
.scan_body_copy_count ; 54:4F29
	ld e, l
	ld d, h
	ld a, [hli]
	inc b
	cp a, $81
	jr c, .l4F45
	cp a, $A0
	jr c, .l4F46

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	cp a, $E0
	jr c, .l4F45
	cp a, $F0
	jr c, .l4F46
	cp a, $F8
	jr c, .l4F45
	cp a, $FA
	jr c, .l4F46

.l4F45 ; 54:4F45
	; [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage
	; --split [executed in 1 scenarios]
	or a, a
.l4F46 ; 54:4F46
	jr nc, .skip
	inc b
	inc hl
.skip ; 54:4F4A
	ld a, $C0
	cp a, b
	jr z, .prepare_counted_body_copy
	dec a
	cp a, b
	jr nz, .scan_body_copy_count
	ld a, [hl]
	cp a, $81
	jr c, .l4F6C

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	cp a, $A0
	jr c, .l4F6D
	cp a, $E0
	jr c, .l4F6C
	cp a, $F0
	jr c, .l4F6D
	cp a, $F8
	jr c, .l4F6C
	cp a, $FA
	jr c, .l4F6D

.l4F6C ; 54:4F6C
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage
	; --split [executed in 1 scenarios]
	or a, a
.l4F6D ; 54:4F6D
	jr nc, .prepare_counted_body_copy

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	inc b

.prepare_counted_body_copy ; 54:4F70
	; [CONFIRMED] 26 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage
	; --split [executed in 4 scenarios]
	ld a, c
	ld c, b
	ld b, $00
	push bc
	cp a, $C1
	jr nz, .copy_counted_body_to_record
	ld a, $01
	ld [wPop3_BodyIncomplete], a
	pop bc
	ld bc, $00C0
	push bc
	ld l, e
	ld h, d
	ld a, $81
	ld [hli], a
	ld a, $63
	ld [hl], a
.copy_counted_body_to_record ; 54:4F8B
	farcall MailRecord_GetFreeSlotPtr
	ld de, $0009
	add hl, de
	ld e, l
	ld d, h
	ld hl, wRam_C480
	pop bc
	farcall CopyBytes
	jp .mark_record_and_request_dele

.restore_banks_and_finish_status_1 ; 54:4FA4
	; [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	ld a, $01
	ld [wMailFetchStatus], a
	ld a, [wPop3SavedSramBank]
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	jp .return_fetch_status_and_clear_task

; ---- data $4FC3-$4FCB (8 bytes) [PROBABLE] POP3 RETR selector4 argument template

Data_Pop3Retr_ParseBodyArgs:: ; 54:4FC3
	db $03, $02, $A0, $03, $00, $B0, $00, $08

; ---- data $4FCB-$4FD2 (7 bytes) [PROBABLE] POP3 RETR selector6 immutable From-header seed

Data_Pop3Retr_DecodeFromHeaderArgs:: ; 54:4FCB
	db $00, $03, $02, $A0, $03, $80, $C4

Mail_SplitFromHeader:: ; 54:4FD2

	; [CONFIRMED] 203 insn(s) reached by static flow only; seeds: exec x203; min discovery hops 14;
	; entered by call from 54:4A7F (PROBABLE code) | 36 insn(s) executed; cut out of the PROBABLE
	; region 4FD2-511B by apply_coverage --split [executed in 6 scenarios]
	ld a, e
	ld [wMailFrom_NameDest], a
	ld a, d
	ld [wMailFrom_NameDestHi], a
	ld a, l
	ld [wMailFrom_AddressDest], a
	ld a, h
	ld [wMailFrom_AddressDestHi], a
	ld hl, wRam_C580
	ld bc, $FFFF
.scan_from_delimiter ; 54:4FE8
	inc bc
	ld a, [hli]
	cp a, $3C
	jr z, .split_angle_address
	cp a, $28
	jr z, .split_parenthesized_name
	or a, a
	jr nz, .scan_from_delimiter
	ld a, [wMailFrom_AddressDest]
	ld e, a
	ld a, [wMailFrom_AddressDestHi]
	ld d, a
	ld hl, wRam_C580
	ld b, $40
	call Mail_CopyClampedEllipsis
	ld hl, wMailFrom_NameDest
	ld a, [wMobileTaskStep]
	or a, a
	jr nz, .prepare_name_formatting
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, wRam_C580
	ld b, $10
	call Mail_CopyClampedEllipsis
	jr .prepare_name_formatting

.split_angle_address ; 54:501B
	; [PROBABLE] 31 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4FD2-511B by apply_coverage --split
	push hl
	dec hl
	xor a, a
	ld [hl], a
	dec bc
	ld a, [wMailFrom_NameDest]
	ld e, a
	ld a, [wMailFrom_NameDestHi]
	ld d, a
	ld hl, wRam_C580
	ld b, $10
	call Mail_CopyClampedEllipsis
	pop hl
	push hl
	ld bc, $FFFF
.scan_closing_angle ; 54:5035
	inc bc
	ld a, [hli]
	cp a, $3E
	jr nz, .scan_closing_angle
	dec hl
	xor a, a
	ld [hl], a
	dec bc
	ld a, [wMailFrom_AddressDest]
	ld e, a
	ld a, [wMailFrom_AddressDestHi]
	ld d, a
	pop hl
	ld b, $40
	call Mail_CopyClampedEllipsis
	jr .prepare_name_formatting

.split_parenthesized_name ; 54:504F
	; [CONFIRMED] 52 insn(s) executed; cut out of the PROBABLE region 4FD2-511B by apply_coverage
	; --split [executed in 12 scenarios]
	push hl
	dec hl
	xor a, a
	ld [hl], a
	dec bc
	ld a, [wMailFrom_AddressDest]
	ld e, a
	ld a, [wMailFrom_AddressDestHi]
	ld d, a
	ld hl, wRam_C580
	ld b, $40
	call Mail_CopyClampedEllipsis
	pop hl
	push hl
	ld bc, $FFFF
.scan_closing_parenthesis ; 54:5069
	inc bc
	ld a, [hli]
	cp a, $29
	jr nz, .scan_closing_parenthesis
	dec hl
	xor a, a
	ld [hl], a
	dec bc
	ld a, [wMailFrom_NameDest]
	ld e, a
	ld a, [wMailFrom_NameDestHi]
	ld d, a
	pop hl
	ld b, $10
	call Mail_CopyClampedEllipsis
.prepare_name_formatting ; 54:5081
	ld hl, wMailFrom_NameDest
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld de, $000D
	add hl, de
	ld e, l
	ld d, h
	pop hl
	push hl
	ld b, $10
.trim_name_trailing_space ; 54:5092
	dec b
	jr z, .init_name_conversion_count
	ld a, [hli]
	or a, a
	jr nz, .trim_name_trailing_space
	dec hl
	dec hl
	ld a, [hl]
	cp a, $20
	jr nz, .init_name_conversion_count

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4FD2-511B by apply_coverage --split
	xor a, a
	ld [hl], a

.init_name_conversion_count ; 54:50A2
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 4FD2-511B by apply_coverage
	; --split [executed in 12 scenarios]
	pop hl
	ld b, $07
.convert_name_characters_to_fullwidth ; 54:50A5
	ld a, [hl]
	or a, a
	ret z
	cp a, $81
	jr c, .l50C0
	cp a, $A0
	jr c, .l50C1

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4FD2-511B by apply_coverage --split
	cp a, $E0
	jr c, .l50C0
	cp a, $F0
	jr c, .l50C1
	cp a, $F8
	jr c, .l50C0
	cp a, $FA
	jr c, .l50C1

.l50C0 ; 54:50C0
	; [CONFIRMED] 65 insn(s) executed; cut out of the PROBABLE region 4FD2-511B by apply_coverage
	; --split [executed in 6 scenarios]
	or a, a
.l50C1 ; 54:50C1
	jr c, .advance_name_character
	push hl
	push de
	ld a, $01
	cp a, b
	jr nz, .prepare_name_tail_shift
	inc hl
	ld a, [hli]
	or a, a
	jr z, .prepare_name_tail_shift
	ld a, $81
	ld [hli], a
	ld a, $63
	ld [hl], a
.prepare_name_tail_shift ; 54:50D5
	ld c, b
	dec c
	ld a, b
	add a, c
	ld c, a
	ld l, e
	ld h, d
	dec hl
.shift_name_tail_right ; 54:50DD
	ld a, [hld]
	ld [de], a
	dec de
	dec c
	jr nz, .shift_name_tail_right
	pop de
	pop hl
	ld a, [hl]
	push bc
	push hl
	push de
	farcall Text_HalfToFullWidth
	pop de
	pop hl
	ld a, b
	ld [hli], a
	ld a, c
	ld [hld], a
	pop bc
.advance_name_character ; 54:50F6
	inc hl
	inc hl
	dec b
	jr nz, .convert_name_characters_to_fullwidth
	ret

Mail_CopyClampedEllipsis:: ; 54:50FC

	ld a, [hli]
	ld [de], a
	inc de
	or a, a
	ret z
	dec b
	jr nz, Mail_CopyClampedEllipsis
	ld a, [hl]
	or a, a
	ret z
	dec de
	dec de
	ld hl, Data_Text_Ellipsis2
	ld bc, $0002
	farcall CopyBytes
	ld a, $02
	ld [wMailFetchStatus], a
	ret

; ---- text $511B-$511D (2 bytes) [CONFIRMED] Shift-JIS ellipsis bytes ($81, $63), copied by Mail_CopyClampedEllipsis with BC=$0002; this two-byte span has no terminator [every byte read as data in 6 retained scenarios]

Data_Text_Ellipsis2:: ; 54:511B
	db $81, $63

Mail_ScanAndCheckGameMail:: ; 54:511D

	; [CONFIRMED] 306 insn(s) reached by static flow only; seeds: exec x306; min discovery hops 12;
	; entered by call from 54:49A2 (PROBABLE code) | 79 insn(s) executed; cut out of the PROBABLE
	; region 511D-5343 by apply_coverage --split [executed in 3 scenarios] (part of region
	; $511D-$51B9)
	xor a, a
	ld [sSram_AFFF], a
	ld de, wRam_C240
	ld hl, Data_MailScan_InputPrefix
	ld bc, $0003
	farcall CopyBytes
	ld hl, sNetWorkPage
	ld a, [hli]
	ld [wRam_C243], a
	ld a, [hl]
	ld [wRam_C244], a
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld de, wRam_C240
	farcall Mail_DispatchFar
	ld e, $00
	or a, a
	ret nz
	ld a, b
	ld [wPop3_BodyIncomplete], a
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $02
	ld de, wRam_C240
	farcall Mail_DispatchFar
	ld e, $01
	ret
