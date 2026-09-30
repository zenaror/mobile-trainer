; engine/mobile/pop3_dele.asm
; bank 54, $5386-$53E9 (99 bytes); pinned by layout.link
; POP3 DELE start and poll

SECTION "engine/mobile/pop3_dele", ROMX

; ---- code $5386-$53DD (87 bytes) [CONFIRMED] 41 insn(s) reached by static flow only; seeds: exec x41; min discovery hops 17; entered by far from 23:4FB5 (PROBABLE code) | 34 insn(s) executed; cut out of the PROBABLE region 5386-53E9 by apply_coverage --split [executed in 5 scenarios]

Pop3_StartDele:: ; 54:5386
	or a, a
	jr nz, Label_54_5391
	farcall MailServerMgr_UpdateTimerDisplay
	jr Label_54_5397

Label_54_5391:: ; 54:5391
	farcall MailSrvDel_DrawElapsedTime

Label_54_5397:: ; 54:5397
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
	jr nz, Label_54_53C6
	farcall MailServerMgr_UpdateTimerDisplay
	jr Label_54_53CC

Label_54_53C6:: ; 54:53C6
	farcall MailSrvDel_DrawElapsedTime

Label_54_53CC:: ; 54:53CC
	call Mobile_CheckTimeout
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, Label_54_53DD
	bit 0, a
	jr z, Label_54_53E3
	ld a, $01
	ret

; ---- code $53DD-$53E3 (6 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5386-53E9 by apply_coverage --split

Label_54_53DD:: ; 54:53DD
	call Mobile_FetchResult
	ld a, $FF
	ret

; ---- code $53E3-$53E9 (6 bytes) [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 5386-53E9 by apply_coverage --split [executed in 8 scenarios]

Label_54_53E3:: ; 54:53E3
	ld hl, $C1D8
	xor a, a
	ld [hl], a
	ret
