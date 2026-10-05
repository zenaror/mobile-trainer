; engine/mobile/pop3_dele.asm
; bank 54, $5386-$53E9 (99 bytes); pinned by layout.link
; POP3 DELE start and poll

SECTION "engine/mobile/pop3_dele", ROMX

Pop3_StartDele:: ; 54:5386
	; [CONFIRMED] 41 insn(s) reached by static flow only; seeds: exec x41; min discovery hops 17;
	; entered by far from 23:4FB5 (PROBABLE code) | 34 insn(s) executed; cut out of the PROBABLE
	; region 5386-53E9 by apply_coverage --split [executed in 5 scenarios]
	or a, a
	jr nz, .l5391
	farcall MailServerMgr_UpdateTimerDisplay
	jr .l5397
.l5391 ; 54:5391
	farcall MailSrvDel_DrawElapsedTime
.l5397 ; 54:5397
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
	ld a, $26
	farcall MobileAPI
	ret

Pop3_DelePoll:: ; 54:53BB
	or a, a
	jr nz, .l53C6
	farcall MailServerMgr_UpdateTimerDisplay
	jr .l53CC
.l53C6 ; 54:53C6
	farcall MailSrvDel_DrawElapsedTime
.l53CC ; 54:53CC
	call Mobile_CheckTimeout
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, .l53DD
	bit 0, a
	jr z, .l53E3
	ld a, $01
	ret

.l53DD ; 54:53DD
	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5386-53E9 by apply_coverage --split
	call Mobile_FetchResult
	ld a, $FF
	ret

.l53E3 ; 54:53E3
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 5386-53E9 by apply_coverage
	; --split [executed in 8 scenarios]
	ld hl, wMobileTaskKind
	xor a, a
	ld [hl], a
	ret
