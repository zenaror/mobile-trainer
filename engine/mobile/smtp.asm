; engine/mobile/smtp.asm
; bank 54, $44FE-$485C (862 bytes); pinned by layout.link
; SMTP HELO/QUIT/MAIL FROM/DATA start and poll, mail header builder

SECTION "engine/mobile/smtp", ROMX

Smtp_StartHelo:: ; 54:44FE
	; [CONFIRMED] 45 insn(s) executed; cut out of the PROBABLE region 44C3-475A by apply_coverage
	; --split [executed in 2 scenarios]
	call Mobile_ResetCommandTimer
	ld a, $03
	ld [wMobileRetriesLeft], a
	ld a, $01
	ld [wMobileTaskKind], a
	xor a, a
	ld [wMobileTaskStep], a
	ld hl, $C201
	ld a, $14
	farcall MobileAPI
	ret

Smtp_HeloPoll:: ; 54:451B
	call Mobile_CheckTimeout
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, .l452C
	bit 0, a
	jr z, .l4532
	ld a, $01
	ret
.l452C ; 54:452C
	call Mobile_FetchResult
	ld a, $FF
	ret
.l4532 ; 54:4532
	ld hl, $C1D8
	xor a, a
	ld [hl], a
	ret

Smtp_StartQuit:: ; 54:4538
	call Mobile_ResetCommandTimer
	ld a, $03
	ld [wMobileRetriesLeft], a
	ld a, $01
	ld [wMobileTaskKind], a
	xor a, a
	ld [wMobileTaskStep], a
	ld a, $1A
	farcall MobileAPI
	ret

Smtp_QuitPoll:: ; 54:4552
	call Mobile_CheckTimeout
	farcall MailSession_UpdateTimerDisplay
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, .l4569
	bit 0, a
	jr z, .l456F
	ld a, $01
	ret

.l4569 ; 54:4569
	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 44C3-475A by apply_coverage --split
	call Mobile_FetchResult
	ld a, $FF
	ret

.l456F ; 54:456F
	; [CONFIRMED] 210 insn(s) executed; cut out of the PROBABLE region 44C3-475A by apply_coverage
	; --split [executed in 4 scenarios]
	ld hl, $C1D8
	xor a, a
	ld [hl], a
	ret

Smtp_StartMailFrom:: ; 54:4575
	call Mobile_ResetCommandTimer
	ld a, $03
	ld [wMobileRetriesLeft], a
	ld a, $01
	ld [wMobileTaskKind], a
	xor a, a
	ld [wMobileTaskStep], a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, Data_54_475A
	ld de, $C240
	ld bc, $000A
	farcall CopyBytes
	ld c, $01
	ld de, $C240
	ld b, $06
	call Mail_BuildHeaderField
	ld hl, $C201
	ld c, $40
	call Smtp_CopyFieldToWork
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, sProfileName
	ld a, [hl]
	or a, a
	jr z, .l45DB
	dec de
	ld a, $20
	ld [de], a
	inc de
	ld a, $28
	ld [de], a
	inc de
	farcall Smtp_CopyDisplayName
	dec de
	ld hl, String_Mail_CloseParen
	farcall CopyString
.l45DB ; 54:45DB
	ld hl, $C580
	ld de, $C480
	ld bc, $0100
	farcall Charset_SjisToIso2022Jp
	ld hl, $C480
	call Smtp_MeasureField
	ld c, $01
	ld de, $C240
	ld b, $00
	call Mail_BuildHeaderField
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, sMailDraft_ToAddress
	ld c, $40
	call Smtp_CopyFieldToWork
	push de
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld de, sNetWorkPage
	ld hl, $C201
	farcall CopyString
	ld hl, $C580
	farcall CopyString
	xor a, a
	ld [de], a
	pop de
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, sMailDraft_ToName
	ld a, [hl]
	or a, a
	jr z, .l464D
	dec de
	ld a, $20
	ld [de], a
	inc de
	ld a, $28
	ld [de], a
	inc de
	call Smtp_CopyDisplayName
	dec de
	ld hl, String_Mail_CloseParen
	farcall CopyString
.l464D ; 54:464D
	ld hl, $C580
	ld de, $C480
	ld bc, $0100
	farcall Charset_SjisToIso2022Jp
	ld hl, $C480
	call Smtp_MeasureField
	ld c, $01
	ld de, $C240
	ld b, $03
	call Mail_BuildHeaderField
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, sMailDraft_Subject
	ld a, [hl]
	or a, a
	jr z, .l46A9
	ld de, $C500
	ld bc, $0014
	farcall CopyBytes
	xor a, a
	ld [wRam_C514], a
	ld hl, $C500
	ld de, $C480
	ld bc, $0080
	farcall Charset_SjisToIso2022Jp
	ld hl, $C480
	call Smtp_MeasureField
	ld c, $01
	ld de, $C240
	ld b, $05
	call Mail_BuildHeaderField
.l46A9 ; 54:46A9
	xor a, a
	ld [wRam_C245], a
	ld c, $01
	ld de, $C240
	ld b, $07
	call Mail_BuildHeaderField
	ld c, $01
	ld de, $C240
	ld b, $08
	call Mail_BuildHeaderField
	ld c, $01
	ld de, $C240
	ld b, $0A
	call Mail_BuildHeaderField
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, sNetWorkPage
	ld a, $16
	farcall MobileAPI
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	xor a, a
	ret

Mail_BuildHeaderField:: ; 54:46E8
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $08
	farcall Mail_DispatchFar
	ld c, $00
	cp a, $FF
	jr z, Mail_BuildHeaderField
	ld c, l
	ld b, h
	ld hl, $C241
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	ld a, l
	ld [wRam_C241], a
	ld a, h
	ld [wRam_C242], a
	ld a, $FF
	xor a, c
	ld c, a
	ld a, $FF
	xor a, b
	ld b, a
	inc bc
	ld hl, $C243
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	ld a, l
	ld [wRam_C243], a
	ld a, h
	ld [wRam_C244], a
	ret

Smtp_MeasureField:: ; 54:4726
Function_54_4726::
	ld b, $00
.loop ; 54:4728
	ld a, [hli]
	or a, a
	jr z, .l4731
	inc b
	ld a, b
	cp a, c
	jr nz, .loop
.l4731 ; 54:4731
	ld a, b
	ld [wRam_C245], a
	ret

Smtp_CopyFieldToWork:: ; 54:4736
Function_54_4736::
	ld b, $00
	ld de, $C580
.loop ; 54:473B
	ld a, [hli]
	ld [de], a
	inc de
	or a, a
	ret z
	inc b
	ld a, b
	cp a, c
	jr nz, .loop

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 44C3-475A by apply_coverage --split
	xor a, a
	ld [de], a
	ret

Smtp_CopyDisplayName:: ; 54:4748
Function_54_4748::
	; [CONFIRMED] 15 insn(s) executed; cut out of the PROBABLE region 44C3-475A by apply_coverage
	; --split [executed in 1 scenarios]
	ld b, $00
.loop ; 54:474A
	ld a, [hli]
	ld [de], a
	inc de
	or a, a
	ret z
	inc b
	ld a, $10
	cp a, b
	jr nz, .loop
	xor a, a
	ld [de], a
	inc de
	inc b
	ret

; ---- data $475A-$4764 (10 bytes) [PROBABLE] 10-byte blob copied to WRAM $C240 by CopyBytes 00:050C (FarCall 0C 05 00, bc=$000A) at 54:4593 (ld hl,$475A ; ld de,$C240)

Data_54_475A:: ; 54:475A
	db $03, $00, $A1, $00, $0F, $00, $00, $80, $C4, $00

; ---- data $4764-$4770 (12 bytes) [HYPOTHESIS] 12 bytes between the $C240 blob and the string at 4770; use not found (content unresolved)

Data_54_4764:: ; 54:4764
	db $00, $01, $C2, $00, $00, $00, $A0, $00, $00, $00, $A1, $00

; ---- text $4770-$4772 (2 bytes) [PROBABLE] NUL-terminated string ")" ($29 $00); passed in HL to CopyString 00:14BF at 54:45D2 and 54:4644

PUSHC sjis
String_Mail_CloseParen:: ; 54:4770
String_54_4770::
	db ")", 0
POPC

Smtp_DataPoll:: ; 54:4772
	; [CONFIRMED] 112 insn(s) reached by static flow only; seeds: exec x112; min discovery hops 1;
	; entered by far from 26:42BA (PROBABLE code) | 22 insn(s) executed; cut out of the PROBABLE
	; region 4772-4856 by apply_coverage --split [executed in 2 scenarios]
	call Mobile_CheckTimeout
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, .l4782
	bit 0, a
	jr z, .l478E
	jr .l47BF
.l4782 ; 54:4782
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	call Mobile_FetchResult
	ld a, $FF
	ret
.l478E ; 54:478E
	ld hl, $C1D9
	inc [hl]
	ld a, [hl]
	dec a
	jr z, .l47A6
	dec a
	jr z, .l47C2
	dec a
	jp z, .l482C

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4772-4856 by apply_coverage --split
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $FF
	ret

.l47A6 ; 54:47A6
	; [CONFIRMED] 66 insn(s) executed; cut out of the PROBABLE region 4772-4856 by apply_coverage
	; --split [executed in 5 scenarios]
	ld hl, $C241
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $5F00
	add hl, de
	ld c, l
	ld b, h
	ld hl, sSmtp_HeaderText
	ld a, $18
	ld d, $00
	farcall MobileAPI
.l47BF ; 54:47BF
	ld a, $01
	ret
.l47C2 ; 54:47C2
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, sMailDraft_Body
	ld c, $C0
	call Smtp_MeasureBody
	ld hl, sMailDraft_Body
	ld a, [hl]
	or a, a
	jr z, .l4834
	ld c, b
	ld b, $00
	push bc
	ld de, $C580
	farcall CopyBytes
	pop bc
	ld hl, $C580
	add hl, bc
	xor a, a
	ld [hl], a
	ld de, $C480
	ld a, $0D
	ld [de], a
	inc de
	ld a, $0A
	ld [de], a
	inc de
	ld hl, $C580
	ld bc, $0200
	farcall Charset_SjisToIso2022Jp
	ld hl, $C482
	add hl, bc
	ld e, l
	ld d, h
	ld hl, String_Smtp_EndOfData
	farcall CopyString
.l4812 ; 54:4812
	ld hl, $C480
	ld bc, $FFFF
.l4818 ; 54:4818
	inc bc
	ld a, [hli]
	or a, a
	jr nz, .l4818
	ld hl, $C480
	ld a, $18
	ld d, $01
	farcall MobileAPI
	jr .l47BF
.l482C ; 54:482C
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ret

.l4834 ; 54:4834
	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4772-4856 by apply_coverage --split
	ld de, $C480
	ld a, $0D
	ld [de], a
	inc de
	ld a, $0A
	ld [de], a
	inc de
	ld hl, String_Smtp_EndOfData
	farcall CopyString
	jr .l4812

Smtp_MeasureBody:: ; 54:484A
Function_54_484A::
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 4772-4856 by apply_coverage
	; --split [executed in 5 scenarios]
	ld b, $00
.loop ; 54:484C
	ld a, [hli]
	or a, a
	jr z, .done
	inc b
	ld a, b
	cp a, c
	jr nz, .loop
.done ; 54:4855
	ret

; ---- text $4856-$485C (6 bytes) [PROBABLE] NUL-terminated ASCII string CR LF "." CR LF (SMTP end-of-data marker); passed in HL to CopyString 00:14BF (FarCall bf 14 00) at 54:4809 and 54:483F

PUSHC sjis
String_Smtp_EndOfData:: ; 54:4856
String_54_4856::
	db $0D, $0A
	db ".", $0D, $0A, 0
POPC
