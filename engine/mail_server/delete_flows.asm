; engine/mail_server/delete_flows.asm
; bank 23, $4A06-$55C3 (3005 bytes); pinned by layout.link
; delete-all / check-and-delete transactions (login, TOP/DELE loops), cancel path

SECTION "engine/mail_server/delete_flows", ROMX

; ---- code $4A06-$4A80 (122 bytes) [CONFIRMED] 60 insn(s) executed; cut out of the PROBABLE region 4986-4AA4 by apply_coverage --split [executed in 3 scenarios]

MailSrvDel_DeleteAll:: ; 23:4A06
	ld a, $01
	ld [wRam_C1D0], a
	xor a, a
	ld [wRam_C1D1], a
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite

MailSrvDel_DeleteAll_Confirm:: ; 23:4A1E
	call MailSrvDel_Confirm
	inc a
	jr nz, Label_23_4A26
	dec a
	ret

Label_23_4A26:: ; 23:4A26
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
	ld de, Data_23_4B4A
	ld b, $07

Label_23_4A34:: ; 23:4A34
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, Label_23_4A34
	ld d, $01
	ld bc, $D624
	farcall ConnectDialog_Run
	inc b
	jr z, MailSrvDel_DeleteAll_Confirm
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
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
	jr z, Label_23_4A80
	cp a, $20
	jr z, Label_23_4AC0
	cp a, $80
	jr nz, Label_23_4ADC

; ---- code $4A80-$4AA4 (36 bytes) [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4986-4AA4 by apply_coverage --split

Label_23_4A80:: ; 23:4A80
	ld a, [wMobileErrorCode]
	cp a, $17
	jp z, Label_23_4AA6
	cp a, $20
	jp z, Label_23_4AA6
	cp a, $21
	jp z, Label_23_4AA6
	cp a, $23
	jp z, Label_23_4AA6
	cp a, $24
	jp z, Label_23_4AA6
	cp a, $26
	jp z, Label_23_4AA6
	jp Label_23_4AC0

; ---- code $4AA4-$4AA6 (2 bytes) [HYPOTHESIS] unreachable jr $4B1A (target is an instruction start of the code region 4AA6-4B4A) after the jp at 4AA1; twin of 4BE5-4BE7 (jr $4C5D) in the parallel routine; nothing branches here
	jr Label_23_4B1A

; ---- code $4AA6-$4AC0 (26 bytes) [PROBABLE] 63 insn(s) reached by static flow only; seeds: exec x63; min discovery hops 3; entered by jpcc from 23:4A85 (PROBABLE code) | 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4AA6-4B4A by apply_coverage --split

Label_23_4AA6:: ; 23:4AA6
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_23_4AB8
	ld b, $00
	farcall MailDisconnect_Screen
	jr Label_23_4AC0

Label_23_4AB8:: ; 23:4AB8
	ld b, $00
	farcall MailDisconnect_ScreenNoTimer

; ---- code $4AC0-$4B03 (67 bytes) [CONFIRMED] 27 insn(s) executed; cut out of the PROBABLE region 4AA6-4B4A by apply_coverage --split [executed in 3 scenarios]

Label_23_4AC0:: ; 23:4AC0
	farcall CommTime_TimerAIsNonZero
	or a, a
	jr nz, Label_23_4ACD
	ld a, h
	or a, l
	jr z, Label_23_4ADB

Label_23_4ACD:: ; 23:4ACD
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen

Label_23_4ADB:: ; 23:4ADB
	ret

Label_23_4ADC:: ; 23:4ADC
	farcall MailSrvDel_DeleteAllRun
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_23_4B03
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
	jr Label_23_4B1A

; ---- code $4B03-$4B1A (23 bytes) [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4AA6-4B4A by apply_coverage --split

Label_23_4B03:: ; 23:4B03
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

; ---- code $4B1A-$4B24 (10 bytes) [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 4AA6-4B4A by apply_coverage --split [executed in 3 scenarios]

Label_23_4B1A:: ; 23:4B1A
	farcall CommTime_TimerAIsNonZero
	cp a, $00
	jr nz, Label_23_4B28

; ---- code $4B24-$4B28 (4 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4AA6-4B4A by apply_coverage --split
	ld a, h
	or a, l
	jr z, Label_23_4B36

; ---- code $4B28-$4B4A (34 bytes) [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 4AA6-4B4A by apply_coverage --split [executed in 3 scenarios]

Label_23_4B28:: ; 23:4B28
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen

Label_23_4B36:: ; 23:4B36
	ld a, $01
	ld [wMailScreenMode], a
	farcall MailServerStatus_Screen
	xor a, a
	pop af
	farcall Palette_FadeOutToWhite
	ret

; ---- data $4B4A-$4B51 (7 bytes) [PROBABLE] 7-byte block copied to $D624 (WRAM1) by the loop at 23:4A2F (ld de,$4B4A ; ld b,$07 ; ld a,[de] ; ld [hli],a ...); the fields are not decoded

Data_23_4B4A:: ; 23:4B4A
	db $03, $00, $00, $01, $24, $D5, $00

; ---- code $4B51-$4BC1 (112 bytes) [CONFIRMED] 55 insn(s); 55 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

MailSrvDel_CheckAndDelete:: ; 23:4B51
Function_23_4B51::
	xor a, a
	ld [wRam_C1D0], a
	xor a, a
	ld [wRam_C1D1], a
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
	ld de, Data_23_4C8D
	ld b, $07

Label_23_4B76:: ; 23:4B76
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, Label_23_4B76
	ld d, $01
	ld bc, $D624
	farcall ConnectDialog_Run
	inc b
	ret z
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
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
	jr z, Label_23_4BC1
	cp a, $20
	jr z, Label_23_4C01
	cp a, $80
	jr nz, Label_23_4C1D

; ---- code $4BC1-$4BE5 (36 bytes) [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 0; entered by jrcc from 23:4BB7 (executed) [executed in 2 scenarios]

Label_23_4BC1:: ; 23:4BC1
	ld a, [wMobileErrorCode]
	cp a, $17
	jp z, Label_23_4BE7
	cp a, $20
	jp z, Label_23_4BE7
	cp a, $21
	jp z, Label_23_4BE7
	cp a, $23
	jp z, Label_23_4BE7
	cp a, $24
	jp z, Label_23_4BE7
	cp a, $26
	jp z, Label_23_4BE7
	jp Label_23_4C01

; ---- code $4BE5-$4BE7 (2 bytes) [HYPOTHESIS] unreachable jr $4C5D after the jp at 4BE2, twin of 4AA4-4AA6
	jr Label_23_4C5D

; ---- code $4BE7-$4C01 (26 bytes) [PROBABLE] 19 insn(s) reached by static flow only; seeds: exec x19; min discovery hops 1; entered by jpcc from 23:4BC6 (PROBABLE code) | 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4BE7-4C1D by apply_coverage --split

Label_23_4BE7:: ; 23:4BE7
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_23_4BF9
	ld b, $00
	farcall MailDisconnect_Screen
	jr Label_23_4C01

Label_23_4BF9:: ; 23:4BF9
	ld b, $00
	farcall MailDisconnect_ScreenNoTimer

; ---- code $4C01-$4C1D (28 bytes) [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 4BE7-4C1D by apply_coverage --split [executed in 5 scenarios]

Label_23_4C01:: ; 23:4C01
	farcall CommTime_TimerAIsNonZero
	or a, a
	jr nz, Label_23_4C0E
	ld a, h
	or a, l
	jr z, Label_23_4C1C

Label_23_4C0E:: ; 23:4C0E
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen

Label_23_4C1C:: ; 23:4C1C
	ret

; ---- code $4C1D-$4C46 (41 bytes) [CONFIRMED] 17 insn(s); 17 executed (in up to 1/18 scenarios)

Label_23_4C1D:: ; 23:4C1D
	farcall MailServerMgr_Run
	cp a, $80
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_23_4C46
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
	jr Label_23_4C5D

; ---- code $4C46-$4C5D (23 bytes) [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 1; entered by jpcc from 23:4C2A (executed) [executed in 1 scenarios]

Label_23_4C46:: ; 23:4C46
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

; ---- code $4C5D-$4C67 (10 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)

Label_23_4C5D:: ; 23:4C5D
	farcall CommTime_TimerAIsNonZero
	cp a, $00
	jr nz, Label_23_4C6B

; ---- code $4C67-$4C6B (4 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 23:4C65 (executed)
	ld a, h
	or a, l
	jr z, Label_23_4C79

; ---- code $4C6B-$4C8D (34 bytes) [CONFIRMED] 11 insn(s); 11 executed (in up to 1/18 scenarios)

Label_23_4C6B:: ; 23:4C6B
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen

Label_23_4C79:: ; 23:4C79
	ld a, $02
	ld [wMailScreenMode], a
	farcall MailServerStatus_Screen
	xor a, a
	pop af
	farcall Palette_FadeOutToWhite
	ret

; ---- data $4C8D-$4C94 (7 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_23_4C8D:: ; 23:4C8D
	db $03, $00, $00, $01, $24, $D5, $00

; ---- code $4C94-$4D22 (142 bytes) [CONFIRMED] 462 insn(s) reached by static flow only; seeds: exec x462; min discovery hops 6; entered by far from 22:4BED (PROBABLE code) | 61 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split [executed in 4 scenarios]

MailSrvDel_DeleteAllRun:: ; 23:4C94
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call MailSrvDel_ProgressInit
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D625
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
	ld hl, $DAB0
	ld de, $7AD0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DAB0
	call Function_00_0A65
	call MailSrvDel_MsgReading
	farcall Timer_ResetClockB
	farcall Pop3_StartLogin

MailSrvDel_DeleteAllRun_WaitLogin:: ; 23:4CF9
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
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

; ---- code $4D22-$4D2B (9 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split
	farcall MailSession_ShowCommError
	ld a, $80
	ret

; ---- code $4D2B-$4D54 (41 bytes) [CONFIRMED] 22 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split [executed in 4 scenarios]

MailSrvDel_DeleteAllRun_GotMailCount:: ; 23:4D2B
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
	jr z, Label_23_4D81
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_23_4D82
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_23_4D81

; ---- code $4D54-$4D81 (45 bytes) [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split
	jr nz, Label_23_4D5D
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_23_4D81

Label_23_4D5D:: ; 23:4D5D
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_23_4D6D
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_23_4D81
	set 1, [hl]

Label_23_4D6D:: ; 23:4D6D
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_23_4D82
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_23_4D82

; ---- code $4D81-$4DC0 (63 bytes) [CONFIRMED] 31 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split [executed in 4 scenarios]

Label_23_4D81:: ; 23:4D81
	xor a, a

Label_23_4D82:: ; 23:4D82
	pop hl
	cp a, $00
	call nz, Function_23_5137
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
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSrvDel_DrawElapsedTime
	farcall Joypad_Update
	pop hl
	pop de
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jr z, Label_23_4DC4

; ---- code $4DC0-$4DC4 (4 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split
	pop de
	jp MailSrvDel_Cancelled

; ---- code $4DC4-$4DDC (24 bytes) [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split [executed in 4 scenarios]

Label_23_4DC4:: ; 23:4DC4
	push bc
	push de
	push hl
	ld a, $01
	farcall Pop3_TopPoll
	cp a, $01
	jr nz, Label_23_4DD8
	pop hl
	pop de
	pop bc
	jr MailSrvDel_DeleteAllRun_CheckPoll

Label_23_4DD8:: ; 23:4DD8
	cp a, $FF
	jr nz, Label_23_4DE9

; ---- code $4DDC-$4DE9 (13 bytes) [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split
	pop hl
	pop de
	pop bc
	farcall MailSession_ShowCommError
	pop de
	ld a, $80
	ret

; ---- code $4DE9-$4DF1 (8 bytes) [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split [executed in 4 scenarios]

Label_23_4DE9:: ; 23:4DE9
	ld a, b
	pop hl
	pop de
	pop bc
	cp a, $02
	jr nz, Label_23_4DF2

; ---- code $4DF1-$4DF2 (1 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split
	inc bc

; ---- code $4DF2-$4E9B (169 bytes) [CONFIRMED] 93 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split [executed in 1 scenarios]

Label_23_4DF2:: ; 23:4DF2
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
	ld hl, $D62F
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
	ld hl, $D625
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
	ld hl, $D62F
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
	ld de, $D629
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	add hl, bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D629
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	ld e, l
	ld d, h
	ld a, d
	or a, e
	jr nz, Label_23_4EB4
	ld hl, $0000
	xor a, a
	call SpriteCounter_StubA
	ld hl, $0000
	ld a, $FF
	call SpriteCounter_StubB
	call MailSrvDel_MsgNoMail
	ld hl, $DAB0
	ld de, $7AD0
	ld a, $23
	ld b, $01
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DAB0
	call Function_00_0A65
	ld a, $78

Label_23_4E80:: ; 23:4E80
	push af
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	farcall Joypad_Update
	call MailSrvDel_DrawElapsedTime
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_23_4E9F

; ---- code $4E9B-$4E9F (4 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split
	pop af
	ld a, $01
	push af

; ---- code $4E9F-$4EDD (62 bytes) [CONFIRMED] 27 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split [executed in 1 scenarios]

Label_23_4E9F:: ; 23:4E9F
	pop af
	dec a
	jr nz, Label_23_4E80
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

Label_23_4EB4:: ; 23:4EB4
	ld hl, $0000

MailSrvDel_DeleteAllRun_DeleteLoop:: ; 23:4EB7
	push bc
	push hl
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_23_4F0A
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_23_4F0B
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_23_4F0A

; ---- code $4EDD-$4F0A (45 bytes) [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split
	jr nz, Label_23_4EE6
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_23_4F0A

Label_23_4EE6:: ; 23:4EE6
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_23_4EF6
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_23_4F0A
	set 1, [hl]

Label_23_4EF6:: ; 23:4EF6
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_23_4F0B
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_23_4F0B

; ---- code $4F0A-$4F65 (91 bytes) [CONFIRMED] 40 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split [executed in 4 scenarios]

Label_23_4F0A:: ; 23:4F0A
	xor a, a

Label_23_4F0B:: ; 23:4F0B
	pop hl
	cp a, $00
	call nz, Function_23_50CC
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
	ld bc, $D629
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
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSrvDel_DrawElapsedTime
	farcall Joypad_Update
	ldh a, [hJoyHeld]
	and a, $02
	jr z, Label_23_4F69

; ---- code $4F65-$4F69 (4 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split
	pop hl
	pop hl
	jr Label_23_4FD8

; ---- code $4F69-$4F79 (16 bytes) [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split [executed in 4 scenarios]

Label_23_4F69:: ; 23:4F69
	ld a, $01
	farcall Pop3_TopPoll
	cp a, $01
	jr z, MailSrvDel_DeleteAllRun_TopPoll
	cp a, $FF
	jr nz, Label_23_4F7E

; ---- code $4F79-$4F7E (5 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split
	pop hl
	pop hl
	jp MailSrvDel_DeleteAllRun_Error

; ---- code $4F7E-$4F84 (6 bytes) [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split [executed in 4 scenarios]

Label_23_4F7E:: ; 23:4F7E
	pop hl
	ld a, b
	cp a, $02
	jr nz, MailSrvDel_DeleteAllRun_SendDele

; ---- code $4F84-$4F9C (24 bytes) [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D631
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

; ---- code $4F9C-$4FD8 (60 bytes) [CONFIRMED] 26 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split [executed in 4 scenarios]

MailSrvDel_DeleteAllRun_SendDele:: ; 23:4F9C
	push bc
	push hl
	ld b, $3C

Label_23_4FA0:: ; 23:4FA0
	push bc
	call Function_00_0464
	call MailSrvDel_DrawElapsedTime
	pop bc
	dec b
	jr nz, Label_23_4FA0
	pop hl
	pop bc
	farcall Timer_ResetClockB
	ld a, $01
	farcall Pop3_StartDele
	pop hl

MailSrvDel_DeleteAllRun_DelePoll:: ; 23:4FBC
	push hl
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	farcall Joypad_Update
	call MailSrvDel_DrawElapsedTime
	pop hl
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_23_4FF0

; ---- code $4FD8-$4FF0 (24 bytes) [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split

Label_23_4FD8:: ; 23:4FD8
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $D629
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

; ---- code $4FF0-$5002 (18 bytes) [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split [executed in 4 scenarios]

Label_23_4FF0:: ; 23:4FF0
	push hl
	ld a, $01
	farcall Pop3_DelePoll
	pop hl
	cp a, $01
	jr z, MailSrvDel_DeleteAllRun_DelePoll
	cp a, $FF
	jr nz, Label_23_503F

; ---- code $5002-$5028 (38 bytes) [PROBABLE] 27 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C94-5028 by apply_coverage --split

MailSrvDel_DeleteAllRun_Error:: ; 23:5002
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $D627
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

; ---- code $5028-$503F (23 bytes) [HYPOTHESIS] function body that starts after ret at 5027: push hl; ld a,1; ldh [$8D],a; ldh [$70],a; increments the 16-bit counter at $D629 and falls into the next function (503F) - the CONFIRMED-flow tail; exact twin of 540D-5424 [verifier: no entry proven (no caller, no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS]
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $D629
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

; ---- code $503F-$50B3 (116 bytes) [CONFIRMED] 463 insn(s) reached by static flow only; seeds: exec x455, site x8; min discovery hops 0; entered by jrcc from 23:5000 (PROBABLE code) | 60 insn(s) executed; cut out of the PROBABLE region 503F-540D by apply_coverage --split [executed in 4 scenarios]

Label_23_503F:: ; 23:503F
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $D627
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
	farcall Function_00_0956
	call MailSrvDel_MsgAllDeleted
	ld hl, $DAB0
	ld de, $7AD0
	ld a, $23
	ld b, $01
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DAB0
	call Function_00_0A65
	ld a, $78

Label_23_5098:: ; 23:5098
	push af
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	farcall Joypad_Update
	call MailSrvDel_DrawElapsedTime
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_23_50B7

; ---- code $50B3-$50B7 (4 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 503F-540D by apply_coverage --split
	pop af
	ld a, $01
	push af

; ---- code $50B7-$50CC (21 bytes) [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 503F-540D by apply_coverage --split [executed in 4 scenarios]

Label_23_50B7:: ; 23:50B7
	pop af
	dec a
	jr nz, Label_23_5098
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

; ---- code $50CC-$51C7 (251 bytes) [PROBABLE] 104 insn(s) never executed in the traced runs; cut out of the PROBABLE region 503F-540D by apply_coverage --split

Function_23_50CC:: ; 23:50CC
	push af
	push bc
	push de
	push hl
	farcall Sprites_SaveSlotsToBank3
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeOutToWhite
	farcall Function_7F_6218
	push af
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeOutToWhite
	pop af
	inc a
	jr z, Label_23_512D
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
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

Label_23_512D:: ; 23:512D
	pop hl
	pop de
	pop bc
	pop af
	pop af
	pop hl
	pop bc
	ld a, $80
	ret

Function_23_5137:: ; 23:5137
	push af
	push bc
	push de
	push hl
	farcall Sprites_SaveSlotsToBank3
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeOutToWhite
	farcall Function_7F_6218
	push af
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeOutToWhite
	pop af
	inc a
	jr z, Label_23_519B
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
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

Label_23_519B:: ; 23:519B
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
	ld de, $C0A9
	farcall Function_7F_6235
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeOutToWhite
	ld a, $80
	ret

; ---- code $51C7-$5255 (142 bytes) [CONFIRMED] 61 insn(s) executed; cut out of the PROBABLE region 503F-540D by apply_coverage --split [executed in 1 scenarios]

MailSrvDel_DeleteCompletelyRun:: ; 23:51C7
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call MailSrvDel_ProgressInit
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D625
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
	ld hl, $DAB0
	ld de, $7AD0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DAB0
	call Function_00_0A65
	call MailSrvDel_MsgReading
	farcall Timer_ResetClockB
	farcall Pop3_StartLogin

MailSrvDel_DeleteCompletelyRun_WaitLogin:: ; 23:522C
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
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

; ---- code $5255-$525E (9 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 503F-540D by apply_coverage --split
	farcall MailSession_ShowCommError
	ld a, $80
	ret

; ---- code $525E-$52C0 (98 bytes) [CONFIRMED] 67 insn(s) executed; cut out of the PROBABLE region 503F-540D by apply_coverage --split [executed in 1 scenarios]

MailSrvDel_DeleteCompletelyRun_GotMailCount:: ; 23:525E
	ld d, h
	ld e, l
	push de
	ld a, d
	or a, e
	jr z, Label_23_5268
	ld de, $0000

Label_23_5268:: ; 23:5268
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D62F
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
	ld hl, $D625
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
	ld hl, $D62F
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
	ld de, $D629
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	add hl, bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D629
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	ld e, l
	ld d, h
	ld a, d
	or a, e
	jr nz, Label_23_5321

; ---- code $52C0-$5321 (97 bytes) [PROBABLE] 37 insn(s) never executed in the traced runs; cut out of the PROBABLE region 503F-540D by apply_coverage --split
	ld hl, $0000
	xor a, a
	call SpriteCounter_StubA
	ld hl, $0000
	ld a, $FF
	call SpriteCounter_StubB
	call MailSrvDel_MsgNoMail
	ld hl, $DAB0
	ld de, $7AD0
	ld a, $23
	ld b, $01
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DAB0
	call Function_00_0A65
	ld a, $78

Label_23_52ED:: ; 23:52ED
	push af
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	farcall Joypad_Update
	call MailSrvDel_DrawElapsedTime
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_23_530C
	pop af
	ld a, $01
	push af

Label_23_530C:: ; 23:530C
	pop af
	dec a
	jr nz, Label_23_52ED
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

; ---- code $5321-$534A (41 bytes) [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 503F-540D by apply_coverage --split [executed in 1 scenarios]

Label_23_5321:: ; 23:5321
	ld hl, $0000

MailSrvDel_DeleteCompletelyRun_DeleteLoop:: ; 23:5324
	push bc
	push hl
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_23_5377
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_23_5378
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_23_5377

; ---- code $534A-$5377 (45 bytes) [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region 503F-540D by apply_coverage --split
	jr nz, Label_23_5353
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_23_5377

Label_23_5353:: ; 23:5353
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_23_5363
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_23_5377
	set 1, [hl]

Label_23_5363:: ; 23:5363
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_23_5378
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_23_5378

; ---- code $5377-$53BD (70 bytes) [CONFIRMED] 28 insn(s) executed; cut out of the PROBABLE region 503F-540D by apply_coverage --split [executed in 1 scenarios]

Label_23_5377:: ; 23:5377
	xor a, a

Label_23_5378:: ; 23:5378
	pop hl
	cp a, $00
	call nz, Function_23_54B1
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
	farcall Function_00_0956
	ei
	call Function_00_0464
	farcall Joypad_Update
	call MailSrvDel_DrawElapsedTime
	pop hl
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_23_53D5

; ---- code $53BD-$53D5 (24 bytes) [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region 503F-540D by apply_coverage --split
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $D629
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

; ---- code $53D5-$53E7 (18 bytes) [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 503F-540D by apply_coverage --split [executed in 1 scenarios]

Label_23_53D5:: ; 23:53D5
	push hl
	ld a, $01
	farcall Pop3_DelePoll
	pop hl
	cp a, $01
	jr z, MailSrvDel_DeleteCompletelyRun_DelePoll
	cp a, $FF
	jr nz, MailSrvDel_DeleteCompletelyRun_NextMail

; ---- code $53E7-$540D (38 bytes) [PROBABLE] 27 insn(s) never executed in the traced runs; cut out of the PROBABLE region 503F-540D by apply_coverage --split
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $D627
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

; ---- code $540D-$5424 (23 bytes) [HYPOTHESIS] function body that starts after ret at 540C: increments the 16-bit counter at $D629 and falls into 5424; exact byte twin of 5028-503F [verifier: no entry proven (no caller, no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS]
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $D629
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

; ---- code $5424-$5498 (116 bytes) [CONFIRMED] 505 insn(s) reached by static flow only; seeds: exec x497, site x8; min discovery hops 0; entered by jrcc from 23:53E5 (PROBABLE code) | 60 insn(s) executed; cut out of the PROBABLE region 5424-581E by apply_coverage --split [executed in 1 scenarios]

MailSrvDel_DeleteCompletelyRun_NextMail:: ; 23:5424
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $D627
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
	farcall Function_00_0956
	call MailSrvDel_MsgAllDeleted
	ld hl, $DAB0
	ld de, $7AD0
	ld a, $23
	ld b, $01
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DAB0
	call Function_00_0A65
	ld a, $78

Label_23_547D:: ; 23:547D
	push af
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	farcall Joypad_Update
	call MailSrvDel_DrawElapsedTime
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_23_549C

; ---- code $5498-$549C (4 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5424-581E by apply_coverage --split
	pop af
	ld a, $01
	push af

; ---- code $549C-$54B1 (21 bytes) [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 5424-581E by apply_coverage --split [executed in 1 scenarios]

Label_23_549C:: ; 23:549C
	pop af
	dec a
	jr nz, Label_23_547D
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

; ---- code $54B1-$55C3 (274 bytes) [PROBABLE] 119 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5424-581E by apply_coverage --split

Function_23_54B1:: ; 23:54B1
	push af
	push bc
	push de
	push hl
	farcall Sprites_SaveSlotsToBank3
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeOutToWhite
	farcall Function_7F_6218
	push af
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeOutToWhite
	pop af
	inc a
	jr z, Label_23_5512
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
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

Label_23_5512:: ; 23:5512
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
	ld de, $C0A9
	farcall Function_7F_6235
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeOutToWhite
	ld a, $80
	ret

MailSrvDel_Cancelled:: ; 23:553D
	push bc
	push de
	push hl
	di
	farcall Function_00_09B6
	farcall Function_00_0956
	ei
	pop hl
	pop de
	pop bc
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $D627
	ld a, l
	ld [bc], a
	inc bc
	ld a, h
	ld [bc], a
	inc bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $D625
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
	ld hl, $DAB0
	ld de, $7AD0
	ld a, $23
	ld b, $01
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DAB0
	call Function_00_0A65
	farcall Timer_ResetClockB
	ld de, $C0A9
	ld a, $B4
	ld a, $01

Label_23_55A1:: ; 23:55A1
	push af
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	pop af
	dec a
	jr nz, Label_23_55A1
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	ld a, $80
	ret
