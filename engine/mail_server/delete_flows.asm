; engine/mail_server/delete_flows.asm
; bank 23, $4A06-$55C3 (3005 bytes); pinned by layout.link
; delete-all / check-and-delete transactions (login, TOP/DELE loops), cancel path

SECTION "engine/mail_server/delete_flows", ROMX

MailSrvDel_DeleteAll:: ; 23:4A06
	; [CONFIRMED] 60 insn(s) executed; cut out of the PROBABLE region 4986-4AA4 by apply_coverage
	; --split [executed in 3 scenarios]
	ld a, $01
	ld [wCommNoticeMode], a
	xor a, a
	ld [wCommNoticeGfxSet], a
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite

MailSrvDel_DeleteAll_Confirm:: ; 23:4A1E
	call MailSrvDel_Confirm
	inc a
	jr nz, .l4A26
	dec a
	ret
.l4A26 ; 23:4A26
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock
	ld de, Data_MailSrvDel_DeleteAll_Confirm_SessionBlockTemplate
	ld b, $07
.loop ; 23:4A34
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .loop
	ld d, $01
	ld bc, wMailSessionBlock
	farcall ConnectDialog_Run
	inc b
	jr z, MailSrvDel_DeleteAll_Confirm
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock
	xor a, a
	ld [hli], a
	ld a, $FF
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	inc hl
	inc hl
	inc hl
	inc hl
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	farcall CommTime_Reset
	ld b, $02
	ld a, $00
	farcall MailConnect_Screen
	cp a, $FF
	jr z, .l4A80
	cp a, $20
	jr z, .l4AC0
	cp a, $80
	jr nz, .l4ADC

.l4A80 ; 23:4A80
	; [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4986-4AA4 by apply_coverage --split
	ld a, [wMobileErrorCode]
	cp a, $17
	jp z, .l4AA6
	cp a, $20
	jp z, .l4AA6
	cp a, $21
	jp z, .l4AA6
	cp a, $23
	jp z, .l4AA6
	cp a, $24
	jp z, .l4AA6
	cp a, $26
	jp z, .l4AA6
	jp .l4AC0

	; [HYPOTHESIS] unreachable jr $4B1A (target is an instruction start of the code region
	; 4AA6-4B4A) after the jp at 4AA1; twin of 4BE5-4BE7 (jr $4C5D) in the parallel routine; nothing
	; branches here
	jr .l4B1A

.l4AA6 ; 23:4AA6
	; [PROBABLE] 63 insn(s) reached by static flow only; seeds: exec x63; min discovery hops 3;
	; entered by jpcc from 23:4A85 (PROBABLE code) | 8 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 4AA6-4B4A by apply_coverage --split
	ld a, [wTimerEnable]
	bit 4, a
	jp z, .l4AB8
	ld b, $00
	farcall MailDisconnect_Screen
	jr .l4AC0
.l4AB8 ; 23:4AB8
	ld b, $00
	farcall MailDisconnect_ScreenNoTimer

.l4AC0 ; 23:4AC0
	; [CONFIRMED] 27 insn(s) executed; cut out of the PROBABLE region 4AA6-4B4A by apply_coverage
	; --split [executed in 3 scenarios]
	farcall CommTime_TimerAIsNonZero
	or a, a
	jr nz, .l4ACD
	ld a, h
	or a, l
	jr z, .done
.l4ACD ; 23:4ACD
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen
.done ; 23:4ADB
	ret
.l4ADC ; 23:4ADC
	farcall MailSrvDel_DeleteAllRun
	ld a, [wTimerEnable]
	bit 4, a
	jp z, .l4B03
	ld a, $00
	ld a, $01
	ld b, $02
	farcall MailDisconnect_Screen
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei
	jr .l4B1A

.l4B03 ; 23:4B03
	; [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4AA6-4B4A by apply_coverage --split
	ld a, $00
	ld a, $01
	ld b, $02
	farcall MailDisconnect_ScreenNoTimer
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei

.l4B1A ; 23:4B1A
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 4AA6-4B4A by apply_coverage
	; --split [executed in 3 scenarios]
	farcall CommTime_TimerAIsNonZero
	cp a, $00
	jr nz, .l4B28

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4AA6-4B4A by apply_coverage --split
	ld a, h
	or a, l
	jr z, .l4B36

.l4B28 ; 23:4B28
	; [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 4AA6-4B4A by apply_coverage
	; --split [executed in 3 scenarios]
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen
.l4B36 ; 23:4B36
	ld a, $01
	ld [wMailScreenMode], a
	farcall MailServerStatus_Screen
	xor a, a
	pop af
	farcall Palette_FadeOutToWhite
	ret

; ---- data $4B4A-$4B51 (7 bytes) [PROBABLE] 7-byte block copied to $D624 (WRAM1) by the loop at 23:4A2F (ld de,$4B4A ; ld b,$07 ; ld a,[de] ; ld [hli],a ...); the fields are not decoded

Data_MailSrvDel_DeleteAll_Confirm_SessionBlockTemplate:: ; 23:4B4A
Data_23_4B4A::
	db $03, $00, $00, $01, $24, $D5, $00

MailSrvDel_CheckAndDelete:: ; 23:4B51
Function_23_4B51::
	; [CONFIRMED] 55 insn(s); 55 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	xor a, a
	ld [wCommNoticeMode], a
	xor a, a
	ld [wCommNoticeGfxSet], a
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock
	ld de, Data_MailSrvDel_CheckAndDelete_SessionBlockTemplate
	ld b, $07
.loop ; 23:4B76
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .loop
	ld d, $01
	ld bc, wMailSessionBlock
	farcall ConnectDialog_Run
	inc b
	ret z
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock
	xor a, a
	ld [hli], a
	ld a, $FF
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	inc hl
	inc hl
	inc hl
	inc hl
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	farcall CommTime_Reset
	ld b, $02
	ld a, $00
	farcall MailConnect_Screen
	cp a, $FF
	jr z, .l4BC1
	cp a, $20
	jr z, .l4C01
	cp a, $80
	jr nz, .l4C1D

.l4BC1 ; 23:4BC1
	; [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 0;
	; entered by jrcc from 23:4BB7 (executed) [executed in 2 scenarios]
	ld a, [wMobileErrorCode]
	cp a, $17
	jp z, .l4BE7
	cp a, $20
	jp z, .l4BE7
	cp a, $21
	jp z, .l4BE7
	cp a, $23
	jp z, .l4BE7
	cp a, $24
	jp z, .l4BE7
	cp a, $26
	jp z, .l4BE7
	jp .l4C01

	; [HYPOTHESIS] unreachable jr $4C5D after the jp at 4BE2, twin of 4AA4-4AA6
	jr .l4C5D

.l4BE7 ; 23:4BE7
	; [PROBABLE] 19 insn(s) reached by static flow only; seeds: exec x19; min discovery hops 1;
	; entered by jpcc from 23:4BC6 (PROBABLE code) | 8 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 4BE7-4C1D by apply_coverage --split
	ld a, [wTimerEnable]
	bit 4, a
	jp z, .l4BF9
	ld b, $00
	farcall MailDisconnect_Screen
	jr .l4C01
.l4BF9 ; 23:4BF9
	ld b, $00
	farcall MailDisconnect_ScreenNoTimer

.l4C01 ; 23:4C01
	; [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 4BE7-4C1D by apply_coverage
	; --split [executed in 5 scenarios]
	farcall CommTime_TimerAIsNonZero
	or a, a
	jr nz, .l4C0E
	ld a, h
	or a, l
	jr z, .done
.l4C0E ; 23:4C0E
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen
.done ; 23:4C1C
	ret

.l4C1D ; 23:4C1D
	; [CONFIRMED] 17 insn(s); 17 executed (in up to 1/18 scenarios)
	farcall MailServerMgr_Run
	cp a, $80
	ld a, [wTimerEnable]
	bit 4, a
	jp z, .l4C46
	ld a, $00
	ld a, $01
	ld b, $02
	farcall MailDisconnect_Screen
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei
	jr .l4C5D

.l4C46 ; 23:4C46
	; [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 1;
	; entered by jpcc from 23:4C2A (executed) [executed in 1 scenarios]
	ld a, $00
	ld b, $02
	ld a, $01
	farcall MailDisconnect_ScreenNoTimer
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei

.l4C5D ; 23:4C5D
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	farcall CommTime_TimerAIsNonZero
	cp a, $00
	jr nz, .l4C6B

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 23:4C65 (executed)
	ld a, h
	or a, l
	jr z, .l4C79

.l4C6B ; 23:4C6B
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 1/18 scenarios)
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen
.l4C79 ; 23:4C79
	ld a, $02
	ld [wMailScreenMode], a
	farcall MailServerStatus_Screen
	xor a, a
	pop af
	farcall Palette_FadeOutToWhite
	ret

; ---- data $4C8D-$4C94 (7 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_MailSrvDel_CheckAndDelete_SessionBlockTemplate:: ; 23:4C8D
Data_23_4C8D::
	db $03, $00, $00, $01, $24, $D5, $00

MailSrvDel_DeleteAllRun:: ; 23:4C94
	; [CONFIRMED] 462 insn(s) reached by static flow only; seeds: exec x462; min discovery hops 6;
	; entered by far from 22:4BED (PROBABLE code) | 61 insn(s) executed; cut out of the PROBABLE
	; region 4C94-5028 by apply_coverage --split [executed in 4 scenarios]
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call MailSrvDel_ProgressInit
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock + $01
	ld a, $FF
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	inc hl
	inc hl
	inc hl
	inc hl
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, wSpriteSlot11
	ld de, Table_MailSrvDel_ProgressObject
	ld a, BANK(Table_MailSrvDel_ProgressObject)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, wSpriteSlot11
	call Sprite_SetPosition
	call MailSrvDel_MsgReading
	farcall Timer_ResetClockB
	farcall Pop3_StartLogin

MailSrvDel_DeleteAllRun_WaitLogin:: ; 23:4CF9
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	farcall Joypad_Update
	call MailSrvDel_DrawElapsedTime
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSrvDel_Cancelled
	farcall Pop3_LoginStatPoll
	cp a, $01
	jr z, MailSrvDel_DeleteAllRun_WaitLogin
	cp a, $FF
	jr nz, MailSrvDel_DeleteAllRun_GotMailCount

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C94-5028 by apply_coverage --split
	farcall MailSession_ShowCommError
	ld a, $80
	ret

MailSrvDel_DeleteAllRun_GotMailCount:: ; 23:4D2B
	; [CONFIRMED] 22 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage
	; --split [executed in 4 scenarios]
	ld d, h
	ld e, l
	push de
	ld a, d
	or a, e
	jp z, MailSrvDel_DeleteAllRun_CheckDone
	ld bc, $0000
	ld hl, $0001

MailSrvDel_DeleteAllRun_CheckLoop:: ; 23:4D39
	push bc
	push hl
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l4D81
	ld hl, wTimerAWarnFlags
	bit 0, [hl]
	jr nz, .l4D82
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l4D81

	; [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C94-5028 by apply_coverage --split
	jr nz, .l4D5D
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l4D81
.l4D5D ; 23:4D5D
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l4D6D
	ld hl, wTimerAWarnFlags
	bit 1, [hl]
	jr nz, .l4D81
	set 1, [hl]
.l4D6D ; 23:4D6D
	ld hl, wTimerAWarnFlags
	set 0, [hl]
	ld hl, wTimerAWarnMinute
	ld a, [hl]
	cp a, $45
	jr z, .l4D82
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l4D82

.l4D81 ; 23:4D81
	; [CONFIRMED] 31 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage
	; --split [executed in 4 scenarios]
	xor a, a
.l4D82 ; 23:4D82
	pop hl
	cp a, $00
	call nz, MailSrvDel_DeleteAllRun_TimeWarningPopupReading
	pop hl
	pop bc
	push bc
	push de
	push hl
	ld c, $00
	farcall Timer_ResetClockB
	ld a, $01
	farcall Pop3_StartTop
	pop hl
	pop de
	pop bc

MailSrvDel_DeleteAllRun_CheckPoll:: ; 23:4DA0
	push bc
	push de
	push hl
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSrvDel_DrawElapsedTime
	farcall Joypad_Update
	pop hl
	pop de
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jr z, .l4DC4

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C94-5028 by apply_coverage --split
	pop de
	jp MailSrvDel_Cancelled

.l4DC4 ; 23:4DC4
	; [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage
	; --split [executed in 4 scenarios]
	push bc
	push de
	push hl
	ld a, $01
	farcall Pop3_TopPoll
	cp a, $01
	jr nz, .l4DD8
	pop hl
	pop de
	pop bc
	jr MailSrvDel_DeleteAllRun_CheckPoll
.l4DD8 ; 23:4DD8
	cp a, $FF
	jr nz, .l4DE9

	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C94-5028 by apply_coverage --split
	pop hl
	pop de
	pop bc
	farcall MailSession_ShowCommError
	pop de
	ld a, $80
	ret

.l4DE9 ; 23:4DE9
	; [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage
	; --split [executed in 4 scenarios]
	ld a, b
	pop hl
	pop de
	pop bc
	cp a, $02
	jr nz, .skip

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C94-5028 by apply_coverage --split
	inc bc

.skip ; 23:4DF2
	; [CONFIRMED] 93 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage
	; --split [executed in 1 scenarios]
	inc hl
	dec de
	ld a, d
	or a, e
	jp nz, MailSrvDel_DeleteAllRun_CheckLoop
	ld e, c
	ld d, b

MailSrvDel_DeleteAllRun_CheckDone:: ; 23:4DFB
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock + $0B
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	xor a, a
	ld [hli], a
	ld [hli], a
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock + $01
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock + $0B
	ld a, [hli]
	xor a, $FF
	ld c, a
	ld a, [hli]
	xor a, $FF
	ld b, a
	inc bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, wMailSessionBlock + $05
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	add hl, bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, wMailSessionBlock + $05
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	ld e, l
	ld d, h
	ld a, d
	or a, e
	jr nz, .l4EB4
	ld hl, $0000
	xor a, a
	call SpriteCounter_StubA
	ld hl, $0000
	ld a, $FF
	call SpriteCounter_StubB
	call MailSrvDel_MsgNoMail
	ld hl, wSpriteSlot11
	ld de, Table_MailSrvDel_ProgressObject
	ld a, BANK(Table_MailSrvDel_ProgressObject)
	ld b, $01
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, wSpriteSlot11
	call Sprite_SetPosition
	ld a, $78
.loop ; 23:4E80
	push af
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	farcall Joypad_Update
	call MailSrvDel_DrawElapsedTime
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .skip

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C94-5028 by apply_coverage --split
	pop af
	ld a, $01
	push af

.skip ; 23:4E9F
	; [CONFIRMED] 27 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage
	; --split [executed in 1 scenarios]
	pop af
	dec a
	jr nz, .loop
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	xor a, a
	ret
.l4EB4 ; 23:4EB4
	ld hl, $0000

MailSrvDel_DeleteAllRun_DeleteLoop:: ; 23:4EB7
	push bc
	push hl
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l4F0A
	ld hl, wTimerAWarnFlags
	bit 0, [hl]
	jr nz, .l4F0B
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l4F0A

	; [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C94-5028 by apply_coverage --split
	jr nz, .l4EE6
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l4F0A
.l4EE6 ; 23:4EE6
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l4EF6
	ld hl, wTimerAWarnFlags
	bit 1, [hl]
	jr nz, .l4F0A
	set 1, [hl]
.l4EF6 ; 23:4EF6
	ld hl, wTimerAWarnFlags
	set 0, [hl]
	ld hl, wTimerAWarnMinute
	ld a, [hl]
	cp a, $45
	jr z, .l4F0B
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l4F0B

.l4F0A ; 23:4F0A
	; [CONFIRMED] 40 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage
	; --split [executed in 4 scenarios]
	xor a, a
.l4F0B ; 23:4F0B
	pop hl
	cp a, $00
	call nz, MailSrvDel_DeleteAllRun_TimeWarningPopup
	farcall Joypad_Update
	call MailSrvDel_DrawElapsedTime
	pop hl
	pop bc
	xor a, a
	call SpriteCounter_StubA
	inc hl
	call MailSrvDel_DrawProgressText
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, wMailSessionBlock + $05
	ld a, [bc]
	inc bc
	ld l, a
	ld a, [bc]
	ld h, a
	ld a, $FF
	call SpriteCounter_StubB
	pop hl
	push hl
	push hl
	ld c, $00
	farcall Timer_ResetClockB
	ld a, $01
	farcall Pop3_StartTop

MailSrvDel_DeleteAllRun_TopPoll:: ; 23:4F4B
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSrvDel_DrawElapsedTime
	farcall Joypad_Update
	ldh a, [hJoyHeld]
	and a, $02
	jr z, .l4F69

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C94-5028 by apply_coverage --split
	pop hl
	pop hl
	jr MailSrvDel_DeleteAllRun_Cancel

.l4F69 ; 23:4F69
	; [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage
	; --split [executed in 4 scenarios]
	ld a, $01
	farcall Pop3_TopPoll
	cp a, $01
	jr z, MailSrvDel_DeleteAllRun_TopPoll
	cp a, $FF
	jr nz, .l4F7E

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C94-5028 by apply_coverage --split
	pop hl
	pop hl
	jp MailSrvDel_DeleteAllRun_Error

.l4F7E ; 23:4F7E
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage
	; --split [executed in 4 scenarios]
	pop hl
	ld a, b
	cp a, $02
	jr nz, MailSrvDel_DeleteAllRun_SendDele

	; [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C94-5028 by apply_coverage --split
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock + $0D
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	inc bc
	ld a, b
	ld [hld], a
	ld a, c
	ld [hl], a
	pop hl
	pop hl
	jp MailSrvDel_DeleteAllRun_NextMail

MailSrvDel_DeleteAllRun_SendDele:: ; 23:4F9C
	; [CONFIRMED] 26 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage
	; --split [executed in 4 scenarios]
	push bc
	push hl
	ld b, $3C
.loop ; 23:4FA0
	push bc
	call VBlank_Wait
	call MailSrvDel_DrawElapsedTime
	pop bc
	dec b
	jr nz, .loop
	pop hl
	pop bc
	farcall Timer_ResetClockB
	ld a, $01
	farcall Pop3_StartDele
	pop hl

MailSrvDel_DeleteAllRun_DelePoll:: ; 23:4FBC
	push hl
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	farcall Joypad_Update
	call MailSrvDel_DrawElapsedTime
	pop hl
	ldh a, [hJoyPressed]
	and a, $02
	jr z, MailSrvDel_DeleteAllRun_DelePollResult

MailSrvDel_DeleteAllRun_Cancel:: ; 23:4FD8
Label_23_4FD8::
	; [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C94-5028 by apply_coverage --split
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, wMailSessionBlock + $05
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	dec bc
	dec de
	ld a, e
	ld [bc], a
	inc bc
	ld a, d
	ld [bc], a
	jp MailSrvDel_Cancelled

MailSrvDel_DeleteAllRun_DelePollResult:: ; 23:4FF0
Label_23_4FF0::
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage
	; --split [executed in 4 scenarios]
	push hl
	ld a, $01
	farcall Pop3_DelePoll
	pop hl
	cp a, $01
	jr z, MailSrvDel_DeleteAllRun_DelePoll
	cp a, $FF
	jr nz, MailSrvDel_DeleteAllRun_CountDeleted

MailSrvDel_DeleteAllRun_Error:: ; 23:5002
	; [PROBABLE] 27 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C94-5028 by apply_coverage --split
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, wMailSessionBlock + $03
	ld a, l
	ld [bc], a
	inc bc
	ld a, h
	ld [bc], a
	inc bc
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	dec bc
	dec de
	ld a, e
	ld [bc], a
	inc bc
	ld a, d
	ld [bc], a
	pop hl
	farcall MailSession_ShowCommError
	ld a, $80
	ret

	; [HYPOTHESIS] function body that starts after ret at 5027: push hl; ld a,1; ldh [$8D],a; ldh
	; [$70],a; increments the 16-bit counter at $D629 and falls into the next function (503F) - the
	; CONFIRMED-flow tail; exact twin of 540D-5424 [verifier: no entry proven (no caller, no valid
	; table word, never executed): decode chain alone is not proof -> HYPOTHESIS]
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, wMailSessionBlock + $05
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	dec bc
	inc de
	ld a, e
	ld [bc], a
	inc bc
	ld a, d
	ld [bc], a
	pop hl

MailSrvDel_DeleteAllRun_CountDeleted:: ; 23:503F
Label_23_503F::
	; [CONFIRMED] 463 insn(s) reached by static flow only; seeds: exec x455, site x8; min discovery
	; hops 0; entered by jrcc from 23:5000 (PROBABLE code) | 60 insn(s) executed; cut out of the
	; PROBABLE region 503F-540D by apply_coverage --split [executed in 4 scenarios]
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, wMailSessionBlock + $03
	ld a, [bc]
	ld l, a
	inc bc
	ld a, [bc]
	ld h, a
	dec bc
	inc hl
	ld a, l
	ld [bc], a
	inc bc
	ld a, h
	ld [bc], a
	inc bc
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	dec bc
	dec de
	ld a, e
	ld [bc], a
	inc bc
	ld a, d
	ld [bc], a
	pop hl

MailSrvDel_DeleteAllRun_NextMail:: ; 23:5063
	ld a, d
	or a, e
	jp nz, MailSrvDel_DeleteAllRun_DeleteLoop
	xor a, a
	call SpriteCounter_StubA
	ld hl, $0000
	ld a, $FF
	call SpriteCounter_StubB
	farcall Sprite_UpdateAll
	call MailSrvDel_MsgAllDeleted
	ld hl, wSpriteSlot11
	ld de, Table_MailSrvDel_ProgressObject
	ld a, BANK(Table_MailSrvDel_ProgressObject)
	ld b, $01
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, wSpriteSlot11
	call Sprite_SetPosition
	ld a, $78
.loop ; 23:5098
	push af
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	farcall Joypad_Update
	call MailSrvDel_DrawElapsedTime
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .skip

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 503F-540D by apply_coverage --split
	pop af
	ld a, $01
	push af

.skip ; 23:50B7
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 503F-540D by apply_coverage
	; --split [executed in 4 scenarios]
	pop af
	dec a
	jr nz, .loop
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

MailSrvDel_DeleteAllRun_TimeWarningPopup:: ; 23:50CC
Function_23_50CC::
	; [PROBABLE] 104 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 503F-540D by apply_coverage --split
	push af
	push bc
	push de
	push hl
	farcall Sprites_SaveSlotsToBank3
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	farcall CommNotice_ShowDialogMode1
	push af
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	pop af
	inc a
	jr z, .l512D
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call MailSrvDel_ProgressInit
	farcall Sprites_RestoreSlotsFromBank3
	pop hl
	pop de
	pop bc
	pop af
	ret
.l512D ; 23:512D
	pop hl
	pop de
	pop bc
	pop af
	pop af
	pop hl
	pop bc
	ld a, $80
	ret

MailSrvDel_DeleteAllRun_TimeWarningPopupReading:: ; 23:5137
Function_23_5137::
	push af
	push bc
	push de
	push hl
	farcall Sprites_SaveSlotsToBank3
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	farcall CommNotice_ShowDialogMode1
	push af
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	pop af
	inc a
	jr z, .l519B
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call MailSrvDel_ProgressInit
	call MailSrvDel_MsgReading
	farcall Sprites_RestoreSlotsFromBank3
	pop hl
	pop de
	pop bc
	pop af
	ret
.l519B ; 23:519B
	pop hl
	pop de
	pop bc
	pop af
	pop af
	pop hl
	pop bc
	pop de
	ld a, $80
	ret

	farcall Timer_ResetClockB
	ld de, $C0A9 ; raw: dead load: unreachable code after a ret
	farcall CommNotice_ShowDialogMode0
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	ld a, $80
	ret

MailSrvDel_DeleteCompletelyRun:: ; 23:51C7
	; [CONFIRMED] 61 insn(s) executed; cut out of the PROBABLE region 503F-540D by apply_coverage
	; --split [executed in 1 scenarios]
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call MailSrvDel_ProgressInit
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock + $01
	ld a, $FF
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	inc hl
	inc hl
	inc hl
	inc hl
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, wSpriteSlot11
	ld de, Table_MailSrvDel_ProgressObject
	ld a, BANK(Table_MailSrvDel_ProgressObject)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, wSpriteSlot11
	call Sprite_SetPosition
	call MailSrvDel_MsgReading
	farcall Timer_ResetClockB
	farcall Pop3_StartLogin

MailSrvDel_DeleteCompletelyRun_WaitLogin:: ; 23:522C
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	farcall Joypad_Update
	call MailSrvDel_DrawElapsedTime
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSrvDel_Cancelled
	farcall Pop3_LoginStatPoll
	cp a, $01
	jr z, MailSrvDel_DeleteCompletelyRun_WaitLogin
	cp a, $FF
	jr nz, MailSrvDel_DeleteCompletelyRun_GotMailCount

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 503F-540D by apply_coverage --split
	farcall MailSession_ShowCommError
	ld a, $80
	ret

MailSrvDel_DeleteCompletelyRun_GotMailCount:: ; 23:525E
	; [CONFIRMED] 67 insn(s) executed; cut out of the PROBABLE region 503F-540D by apply_coverage
	; --split [executed in 1 scenarios]
	ld d, h
	ld e, l
	push de
	ld a, d
	or a, e
	jr z, .l5268
	ld de, $0000
.l5268 ; 23:5268
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock + $0B
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	xor a, a
	ld [hli], a
	ld [hli], a
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock + $01
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock + $0B
	ld a, [hli]
	xor a, $FF
	ld c, a
	ld a, [hli]
	xor a, $FF
	ld b, a
	inc bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, wMailSessionBlock + $05
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	add hl, bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, wMailSessionBlock + $05
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	ld e, l
	ld d, h
	ld a, d
	or a, e
	jr nz, .l5321

	; [PROBABLE] 37 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 503F-540D by apply_coverage --split
	ld hl, $0000
	xor a, a
	call SpriteCounter_StubA
	ld hl, $0000
	ld a, $FF
	call SpriteCounter_StubB
	call MailSrvDel_MsgNoMail
	ld hl, wSpriteSlot11
	ld de, Table_MailSrvDel_ProgressObject
	ld a, BANK(Table_MailSrvDel_ProgressObject)
	ld b, $01
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, wSpriteSlot11
	call Sprite_SetPosition
	ld a, $78
.loop ; 23:52ED
	push af
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	farcall Joypad_Update
	call MailSrvDel_DrawElapsedTime
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .l530C
	pop af
	ld a, $01
	push af
.l530C ; 23:530C
	pop af
	dec a
	jr nz, .loop
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

.l5321 ; 23:5321
	; [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 503F-540D by apply_coverage
	; --split [executed in 1 scenarios]
	ld hl, $0000

MailSrvDel_DeleteCompletelyRun_DeleteLoop:: ; 23:5324
	push bc
	push hl
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l5377
	ld hl, wTimerAWarnFlags
	bit 0, [hl]
	jr nz, .l5378
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l5377

	; [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 503F-540D by apply_coverage --split
	jr nz, .l5353
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l5377
.l5353 ; 23:5353
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l5363
	ld hl, wTimerAWarnFlags
	bit 1, [hl]
	jr nz, .l5377
	set 1, [hl]
.l5363 ; 23:5363
	ld hl, wTimerAWarnFlags
	set 0, [hl]
	ld hl, wTimerAWarnMinute
	ld a, [hl]
	cp a, $45
	jr z, .l5378
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l5378

.l5377 ; 23:5377
	; [CONFIRMED] 28 insn(s) executed; cut out of the PROBABLE region 503F-540D by apply_coverage
	; --split [executed in 1 scenarios]
	xor a, a
.l5378 ; 23:5378
	pop hl
	cp a, $00
	call nz, MailSrvDel_DeleteCompletelyRun_TimeWarningPopup
	farcall Joypad_Update
	call MailSrvDel_DrawElapsedTime
	pop hl
	pop bc
	xor a, a
	call SpriteCounter_StubA
	inc hl
	call MailSrvDel_DrawProgressText
	push hl
	farcall Timer_ResetClockB
	ld a, $01
	farcall Pop3_StartDele
	pop hl

MailSrvDel_DeleteCompletelyRun_DelePoll:: ; 23:53A1
	push hl
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	farcall Joypad_Update
	call MailSrvDel_DrawElapsedTime
	pop hl
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l53D5

	; [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 503F-540D by apply_coverage --split
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, wMailSessionBlock + $05
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	dec bc
	dec de
	ld a, e
	ld [bc], a
	inc bc
	ld a, d
	ld [bc], a
	jp MailSrvDel_Cancelled

.l53D5 ; 23:53D5
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 503F-540D by apply_coverage
	; --split [executed in 1 scenarios]
	push hl
	ld a, $01
	farcall Pop3_DelePoll
	pop hl
	cp a, $01
	jr z, MailSrvDel_DeleteCompletelyRun_DelePoll
	cp a, $FF
	jr nz, MailSrvDel_DeleteCompletelyRun_NextMail

	; [PROBABLE] 27 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 503F-540D by apply_coverage --split
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, wMailSessionBlock + $03
	ld a, l
	ld [bc], a
	inc bc
	ld a, h
	ld [bc], a
	inc bc
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	dec bc
	dec de
	ld a, e
	ld [bc], a
	inc bc
	ld a, d
	ld [bc], a
	pop hl
	farcall MailSession_ShowCommError
	ld a, $80
	ret

	; [HYPOTHESIS] function body that starts after ret at 540C: increments the 16-bit counter at
	; $D629 and falls into 5424; exact byte twin of 5028-503F [verifier: no entry proven (no caller,
	; no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS]
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, wMailSessionBlock + $05
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	dec bc
	inc de
	ld a, e
	ld [bc], a
	inc bc
	ld a, d
	ld [bc], a
	pop hl

MailSrvDel_DeleteCompletelyRun_NextMail:: ; 23:5424
	; [CONFIRMED] 505 insn(s) reached by static flow only; seeds: exec x497, site x8; min discovery
	; hops 0; entered by jrcc from 23:53E5 (PROBABLE code) | 60 insn(s) executed; cut out of the
	; PROBABLE region 5424-581E by apply_coverage --split [executed in 1 scenarios]
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, wMailSessionBlock + $03
	ld a, [bc]
	ld l, a
	inc bc
	ld a, [bc]
	ld h, a
	dec bc
	inc hl
	ld a, l
	ld [bc], a
	inc bc
	ld a, h
	ld [bc], a
	inc bc
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	dec bc
	dec de
	ld a, e
	ld [bc], a
	inc bc
	ld a, d
	ld [bc], a
	pop hl
	ld a, d
	or a, e
	jp nz, MailSrvDel_DeleteCompletelyRun_DeleteLoop
	xor a, a
	call SpriteCounter_StubA
	ld hl, $0000
	ld a, $FF
	call SpriteCounter_StubB
	farcall Sprite_UpdateAll
	call MailSrvDel_MsgAllDeleted
	ld hl, wSpriteSlot11
	ld de, Table_MailSrvDel_ProgressObject
	ld a, BANK(Table_MailSrvDel_ProgressObject)
	ld b, $01
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, wSpriteSlot11
	call Sprite_SetPosition
	ld a, $78
.loop ; 23:547D
	push af
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	farcall Joypad_Update
	call MailSrvDel_DrawElapsedTime
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .skip

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5424-581E by apply_coverage --split
	pop af
	ld a, $01
	push af

.skip ; 23:549C
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 5424-581E by apply_coverage
	; --split [executed in 1 scenarios]
	pop af
	dec a
	jr nz, .loop
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

MailSrvDel_DeleteCompletelyRun_TimeWarningPopup:: ; 23:54B1
Function_23_54B1::
	; [PROBABLE] 119 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5424-581E by apply_coverage --split
	push af
	push bc
	push de
	push hl
	farcall Sprites_SaveSlotsToBank3
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	farcall CommNotice_ShowDialogMode1
	push af
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	pop af
	inc a
	jr z, .l5512
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call MailSrvDel_ProgressInit
	farcall Sprites_RestoreSlotsFromBank3
	pop hl
	pop de
	pop bc
	pop af
	ret
.l5512 ; 23:5512
	pop hl
	pop de
	pop bc
	pop af
	pop af
	pop hl
	pop bc
	ld a, $80
	ret

	farcall Timer_ResetClockB
	ld de, $C0A9 ; raw: dead load: DE is never read
	farcall CommNotice_ShowDialogMode0
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	ld a, $80
	ret

MailSrvDel_Cancelled:: ; 23:553D
	push bc
	push de
	push hl
	di
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	ei
	pop hl
	pop de
	pop bc
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, wMailSessionBlock + $03
	ld a, l
	ld [bc], a
	inc bc
	ld a, h
	ld [bc], a
	inc bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, wMailSessionBlock + $01
	ld a, $FF
	ld [bc], a
	inc bc
	ld [bc], a
	inc bc
	ld [bc], a
	inc bc
	ld [bc], a
	inc bc
	ld [bc], a
	inc bc
	ld [bc], a
	pop hl
	call MailSrvDel_MsgBlank
	ld hl, wSpriteSlot11
	ld de, Table_MailSrvDel_ProgressObject
	ld a, BANK(Table_MailSrvDel_ProgressObject)
	ld b, $01
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, wSpriteSlot11
	call Sprite_SetPosition
	farcall Timer_ResetClockB
	ld de, $C0A9 ; raw: dead load: DE is never read
	ld a, $B4
	ld a, $01
.loop ; 23:55A1
	push af
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	pop af
	dec a
	jr nz, .loop
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ld a, $80
	ret
