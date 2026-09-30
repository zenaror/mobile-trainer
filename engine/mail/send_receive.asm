; engine/mail/send_receive.asm
; bank 27, $4000-$5060 (4192 bytes); pinned by layout.link
; mail send/receive orchestration, connect and disconnect screens, comm-time screen

SECTION "engine/mail/send_receive", ROMX

; ---- code $4000-$407B (123 bytes) [CONFIRMED] 61 insn(s); 61 executed (in up to 4/18 scenarios); entry proven: target of an executed call/far call

MailSendRecv_Main:: ; 27:4000
Function_27_4000::
	ld a, $01
	ld [wRam_C1D0], a
	xor a, a
	ld [wRam_C1D1], a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
	ld de, MailSendRecv_RequestTemplate
	ld b, $07

Label_27_4017:: ; 27:4017
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, Label_27_4017
	farcall Mailbox_CountRecords
	ld a, $0C
	sub a, d
	ld [wMailSessionBlock + 6], a
	xor a, a
	ld [wMailSessionBlock + 7], a
	ld d, $01
	ld bc, $D624
	farcall ConnectDialog_Run
	inc b
	ret z
	farcall Mailbox_CountRecords
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
	ld a, d
	ld [hli], a
	ld a, $FF
	ld [hli], a
	ld [hli], a
	xor a, a
	ld [hli], a
	ld [hli], a
	farcall CommTime_Reset
	ld a, $00
	ld b, $00
	farcall MailConnect_Screen
	cp a, $FF
	jr z, Label_27_407B
	cp a, $20
	jr z, Label_27_40BB
	cp a, $80
	jr nz, Label_27_40D7

; ---- code $407B-$409F (36 bytes) [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 0; entered by jrcc from 27:4071 (executed) [executed in 2 scenarios]

Label_27_407B:: ; 27:407B
	ld a, [wMobileErrorCode]
	cp a, $17
	jp z, Label_27_40A1
	cp a, $20
	jp z, Label_27_40A1
	cp a, $21
	jp z, Label_27_40A1
	cp a, $23
	jp z, Label_27_40A1
	cp a, $24
	jp z, Label_27_40A1
	cp a, $26
	jp z, Label_27_40A1
	jp Label_27_40BB

; ---- data $409F-$40A1 (2 bytes) [HYPOTHESIS] UNCLASSIFIED 2 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_27_409F:: ; 27:409F
	db $18, $5E

; ---- code $40A1-$40BB (26 bytes) [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1; entered by jpcc from 27:4080 (PROBABLE code)

Label_27_40A1:: ; 27:40A1
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_27_40B3
	ld b, $00
	farcall MailDisconnect_Screen
	jr Label_27_40BB

Label_27_40B3:: ; 27:40B3
	ld b, $00
	farcall MailDisconnect_ScreenNoTimer

; ---- code $40BB-$40F5 (58 bytes) [CONFIRMED] 21 insn(s); 21 executed (in up to 2/18 scenarios)

Label_27_40BB:: ; 27:40BB
	farcall CommTime_TimerAIsNonZero
	or a, a
	jr nz, Label_27_40C8
	ld a, h
	or a, l
	jr z, Label_27_40D6

Label_27_40C8:: ; 27:40C8
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen

Label_27_40D6:: ; 27:40D6
	ret

Label_27_40D7:: ; 27:40D7
	farcall MailSession_Run
	cp a, $80
	cp a, $7F
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_27_40F5
	ld a, $01
	ld b, $00
	farcall MailDisconnect_Screen
	jr Label_27_40FF

; ---- code $40F5-$40FF (10 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1; entered by jpcc from 27:40E6 (executed)

Label_27_40F5:: ; 27:40F5
	ld a, $01
	ld b, $00
	farcall MailDisconnect_ScreenNoTimer

; ---- code $40FF-$410C (13 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)

Label_27_40FF:: ; 27:40FF
	xor a, a
	ld [wCommSessionActive], a
	farcall CommTime_TimerAIsNonZero
	or a, a
	jr nz, Label_27_4110

; ---- code $410C-$4110 (4 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 27:410A (executed)
	ld a, h
	or a, l
	jr z, Label_27_411E

; ---- code $4110-$414F (63 bytes) [CONFIRMED] 29 insn(s); 29 executed (in up to 1/18 scenarios)

Label_27_4110:: ; 27:4110
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen

Label_27_411E:: ; 27:411E
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei
	farcall Mailbox_CountRecords
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailSessionBlock + 1]
	cp a, $FF
	jr z, Label_27_4156
	ld b, a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailCountAtStart]
	ld c, a
	ld a, d
	sub a, c
	ld [wMailSessionBlock + 1], a
	cp a, b
	jr z, Label_27_4156

; ---- code $414F-$4156 (7 bytes) [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 27:414D (executed) [executed in 1 scenarios]
	ld a, [wMailSessionBlock + 3]
	inc a
	ld [wMailSessionBlock + 3], a

; ---- code $4156-$4166 (16 bytes) [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios)

Label_27_4156:: ; 27:4156
	farcall MailResult_Screen
	xor a, a
	ld [wMailScreenMode], a
	farcall MailServerStatus_Screen

; ---- code $4166-$417A (20 bytes) [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0; entry not recorded [executed in 2 scenarios]
	cp a, $FF
	ret z
	ld bc, $0000
	ld a, $00
	ld [wMailScreenMode], a
	ld d, $FF
	farcall Mailbox_Main
	ret

; ---- data $417A-$4181 (7 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

MailSendRecv_RequestTemplate:: ; 27:417A
Data_27_417A::
	db $04, $00, $00, $01, $24, $D5, $04

; ---- code $4181-$41BC (59 bytes) [PROBABLE] 24 insn(s) reached by static flow only; seeds: site x24; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Mobile_BeginCancel

Label_27_4187:: ; 27:4187
	farcall Mobile_CancelPoll
	cp a, $01
	jr z, Label_27_4187
	cp a, $FF
	jr z, Label_27_4195

Label_27_4195:: ; 27:4195
	farcall CommTime_TimerAIsNonZero
	or a, a
	jr nz, Label_27_41A2
	ld a, h
	or a, l
	jr z, Label_27_41B0

Label_27_41A2:: ; 27:41A2
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen

Label_27_41B0:: ; 27:41B0
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei
	ret

; ---- code $41BC-$41DB (31 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 4/18 scenarios); entry proven: target of an executed call/far call

Mail_OutboxIsEmpty:: ; 27:41BC
Function_27_41BC::
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, $A000
	ld a, [hl]
	cp a, $00
	jr nz, Label_27_41DB
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $FF
	ret

; ---- code $41DB-$41E3 (8 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1; entered by jrcc from 27:41D0 (executed) | upgraded by classifier 6: all 5 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)

Label_27_41DB:: ; 27:41DB
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ret

; ---- code $41E3-$41F5 (18 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 4/18 scenarios); entry proven: target of an executed call/far call

MailConnect_Screen:: ; 27:41E3
Function_27_41E3::
	ld a, $00
	push af
	ld a, b
	cp a, $00
	jr nz, Label_27_41F1
	xor a, a
	ld [wMailScreenMode], a
	jr Label_27_4201

Label_27_41F1:: ; 27:41F1
	cp a, $01
	jr nz, Label_27_41FC

; ---- code $41F5-$41FC (7 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 27:41F3 (executed)
	ld a, $01
	ld [wMailScreenMode], a
	jr Label_27_4201

; ---- code $41FC-$427C (128 bytes) [CONFIRMED] 53 insn(s); 53 executed (in up to 4/18 scenarios)

Label_27_41FC:: ; 27:41FC
	ld a, $02
	ld [wMailScreenMode], a

Label_27_4201:: ; 27:4201
	pop af
	call MailConnect_InitScreen
	push bc
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000B
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	pop bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, $09
	ld hl, $D524
	ld de, $C0A0

Label_27_4225:: ; 27:4225
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_27_4225
	ld hl, $DA80
	ld de, $7030
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $7100
	ld hl, $DA80
	call Function_00_0A65
	ld hl, $DA30
	ld de, $7A30
	ld a, $27
	ld b, $81
	farcall Function_00_0A82
	ld de, $2FE0
	ld hl, $DA30
	call Function_00_0A65
	ld a, [wMailScreenMode]
	cp a, $00
	jr nz, Label_27_4297
	call Mail_OutboxIsEmpty
	inc a
	jr nz, Label_27_427C
	ld hl, $DA40
	ld de, $7A40
	ld a, $27
	ld b, $81
	farcall Function_00_0A82
	jr Label_27_428C

; ---- code $427C-$428C (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1; entered by jrcc from 27:4268 (executed) | upgraded by classifier 6: all 5 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)

Label_27_427C:: ; 27:427C
	ld hl, $DA40
	ld de, $7A50
	ld a, $27
	ld b, $81
	farcall Function_00_0A82

; ---- code $428C-$429B (15 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 3/18 scenarios)

Label_27_428C:: ; 27:428C
	ld de, $2FD0
	ld hl, $DA40
	call Function_00_0A65
	jr Label_27_42CF

Label_27_4297:: ; 27:4297
	cp a, $01
	jr nz, Label_27_42B6

; ---- code $429B-$42B6 (27 bytes) [PROBABLE] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0; fall-through of the jrcc at 27:4299 (executed)
	ld hl, $DA40
	ld de, $7AA0
	ld a, $27
	ld b, $81
	farcall Function_00_0A82
	ld de, $2FD0
	ld hl, $DA40
	call Function_00_0A65
	jr Label_27_42CF

; ---- code $42B6-$438A (212 bytes) [CONFIRMED] 86 insn(s); 86 executed (in up to 4/18 scenarios)

Label_27_42B6:: ; 27:42B6
	ld hl, $DA30
	ld de, $7AC0
	ld a, $27
	ld b, $81
	farcall Function_00_0A82
	ld de, $2FE0
	ld hl, $DA30
	call Function_00_0A65

Label_27_42CF:: ; 27:42CF
	farcall Session_ResetCounters
	farcall Timer_ResetClockB
	farcall Stub_Nop_7F_61FC
	xor a, a
	ld [wCommSessionActive], a
	ld hl, $C2D2
	ld [hli], a
	ld [hl], a
	ld hl, $C2D4
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $09
	ld [wRam_C26E], a
	xor a, a
	ld [wRam_C26F], a
	ld de, $C0A9
	farcall Mobile_SessionInit
	ld b, $00

MailConnect_Screen_Loop:: ; 27:4305
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlots + 49]
	inc a
	ld [wSpriteSlots + 49], a
	ld a, [wSpriteSlots + 65]
	inc a
	ld [wSpriteSlots + 65], a
	di
	farcall Function_00_0956
	ei
	call Function_00_044B
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_27_4334
	ld b, $01

Label_27_4334:: ; 27:4334
	call MailConnect_PollAdapterError
	jp z, MailConnect_ShowError
	ld a, [wSpriteSlots + 49]
	cp a, $47
	jr nz, MailConnect_Screen_Loop

Label_27_4341:: ; 27:4341
	ld a, b
	cp a, $01
	jp z, Label_27_44E1
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	ldh a, [rSCX]
	inc a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20A6
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_27_4374
	ld b, $01

Label_27_4374:: ; 27:4374
	call MailConnect_PollAdapterError
	jp z, MailConnect_ShowError
	push bc
	farcall Mobile_ConnectPoll
	pop bc
	cp a, $01
	jr z, Label_27_4341
	cp a, $FF
	jr nz, Label_27_4393

; ---- code $438A-$4393 (9 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 27:4388 (executed)
	farcall MailSession_ShowCommError
	ld a, $80
	ret

; ---- code $4393-$43E4 (81 bytes) [CONFIRMED] 34 insn(s); 34 executed (in up to 2/18 scenarios)

Label_27_4393:: ; 27:4393
	push bc
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	farcall Settings_GetSelectedDialEntry
	inc b
	ld c, b
	farcall Timer_ResetClockB
	ld hl, $C0A0
	farcall Mobile_BeginConnect
	pop bc

Label_27_43B3:: ; 27:43B3
	ld a, b
	cp a, $01
	jp z, Label_27_44E1
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	ldh a, [rSCX]
	inc a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20A6
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_27_43E6

; ---- code $43E4-$43E6 (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 27:43E2 (executed)
	ld b, $01

; ---- code $43E6-$43F6 (16 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 2/18 scenarios)

Label_27_43E6:: ; 27:43E6
	push bc
	farcall Mobile_ConnectPoll
	pop bc
	cp a, $01
	jr z, Label_27_43B3
	cp a, $FF
	jr nz, Label_27_43FF

; ---- code $43F6-$43FF (9 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 27:43F4 (executed)
	farcall MailSession_ShowCommError
	ld a, $80
	ret

; ---- code $43FF-$4589 (394 bytes) [CONFIRMED] 164 insn(s); 164 executed (in up to 2/18 scenarios)

Label_27_43FF:: ; 27:43FF
	ld a, $01
	ld [wCommSessionActive], a
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002F
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld bc, $0514
	ld de, $D000
	ld hl, MailConnect_WinMsg_Connected
	ld a, $27
	farcall Function_00_08EA
	ld a, $40
	farcall Function_00_0887
	ld hl, $DA50
	ld de, $7A70
	ld a, $27
	ld b, $81
	farcall Function_00_0A82
	ld de, $2F47
	ld hl, $DA50
	call Function_00_0A65
	ld c, $1E

Label_27_444C:: ; 27:444C
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	ldh a, [rSCX]
	inc a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20A6
	pop af
	ldh [rSVBK], a
	pop bc
	dec c
	jr nz, Label_27_444C
	ld de, $2FD0
	ld hl, $DA50
	call Function_00_0A65
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0044
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc

Label_27_448B:: ; 27:448B
	call MailConnect_PollAdapterError
	jp z, MailConnect_ShowError
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlots + 49]
	inc a
	inc a
	ld [wSpriteSlots + 49], a
	ld a, [wSpriteSlots + 65]
	inc a
	inc a
	ld [wSpriteSlots + 65], a
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	ldh a, [rSCX]
	inc a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20A6
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	pop bc
	ld a, [wSpriteSlots + 49]
	cp a, $A7
	jr c, Label_27_448B
	farcall Palette_FadeOutToWhite
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	xor a, a
	ret

Label_27_44E1:: ; 27:44E1
	call Function_00_0464
	ld bc, $0514
	ld de, $D000
	ld hl, MailConnect_WinMsg_Cancelling
	ld a, $27
	farcall Function_00_08EA
	ld a, $40
	farcall Function_00_0887
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002F
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld hl, $DA50
	ld de, $7A70
	ld a, $27
	ld b, $81
	farcall Function_00_0A82
	ld de, $2F47
	ld hl, $DA50
	call Function_00_0A65
	ld b, $3C

Label_27_452C:: ; 27:452C
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_044B
	pop bc
	dec b
	jr nz, Label_27_452C
	farcall Timer_ResetClockB
	farcall Mobile_BeginCancel
	ld de, $2FE0
	ld hl, $DA50
	call Function_00_0A65
	ld hl, $DA30
	ld de, $6F30
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $2F47
	ld hl, $DA30
	call Function_00_0A65
	ld a, [wMailScreenMode]
	cp a, $00
	jr nz, Label_27_45A4
	call Mail_OutboxIsEmpty
	inc a
	jr nz, Label_27_4589
	ld hl, $DA40
	ld de, $7020
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	jr Label_27_4599

; ---- code $4589-$4599 (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1; entered by jrcc from 27:4575 (executed) [executed in 4 scenarios]

Label_27_4589:: ; 27:4589
	ld hl, $DA40
	ld de, $7A60
	ld a, $27
	ld b, $81
	farcall Function_00_0A82

; ---- code $4599-$45A4 (11 bytes) [CONFIRMED] 4 insn(s); 4 executed (in up to 2/18 scenarios)

Label_27_4599:: ; 27:4599
	ld de, $2F57
	ld hl, $DA40
	call Function_00_0A65
	jr Label_27_45DC

; ---- code $45A4-$45A8 (4 bytes) [CONFIRMED] 19 insn(s) reached by static flow only; seeds: exec x19; min discovery hops 1; entered by jrcc from 27:456F (executed) | 2 insn(s) executed; cut out of the PROBABLE region 45A4-45DC by apply_coverage --split [executed in 8 scenarios]

Label_27_45A4:: ; 27:45A4
	cp a, $01
	jr nz, Label_27_45C3

; ---- code $45A8-$45C3 (27 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 45A4-45DC by apply_coverage --split
	ld hl, $DA40
	ld de, $7AB0
	ld a, $27
	ld b, $81
	farcall Function_00_0A82
	ld de, $2F57
	ld hl, $DA40
	call Function_00_0A65
	jr Label_27_45DC

; ---- code $45C3-$45DC (25 bytes) [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 45A4-45DC by apply_coverage --split [executed in 8 scenarios]

Label_27_45C3:: ; 27:45C3
	ld hl, $DA30
	ld de, $7AD0
	ld a, $27
	ld b, $81
	farcall Function_00_0A82
	ld de, $2F47
	ld hl, $DA30
	call Function_00_0A65

; ---- code $45DC-$46A0 (196 bytes) [CONFIRMED] 86 insn(s); 86 executed (in up to 2/18 scenarios)

Label_27_45DC:: ; 27:45DC
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	ldh a, [rSCX]
	dec a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20A6
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	pop bc
	farcall Mobile_CancelPoll
	cp a, $01
	jr z, Label_27_45DC
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0045
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld de, $71D0
	ld hl, $DA80
	call Function_00_0A65
	ld bc, $0514
	ld de, $D000
	ld hl, MailConnect_WinMsg_Cancelled
	ld a, $27
	farcall Function_00_08EA
	ld a, $40
	farcall Function_00_0887

Label_27_4641:: ; 27:4641
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlots + 49]
	dec a
	ld [wSpriteSlots + 49], a
	ld a, [wSpriteSlots + 65]
	dec a
	ld [wSpriteSlots + 65], a
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	ldh a, [rSCX]
	dec a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20A6
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	pop bc
	ld a, [wSpriteSlots + 49]
	cp a, $C0
	jr nz, Label_27_4641
	farcall Palette_FadeOutToWhite
	ld a, $D0
	ldh [rWY], a
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	ld b, $78

Label_27_4693:: ; 27:4693
	push bc
	call Function_00_044B
	pop bc
	dec b
	jr nz, Label_27_4693
	ld a, $FF
	ld a, $20
	ret

; ---- data $46A0-$46A1 (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_27_46A0:: ; 27:46A0
	db $C9

; ---- code $46A1-$46DF (62 bytes) [PROBABLE] 26 insn(s) reached by static flow only; seeds: site x26; min discovery hops 0; entered by jr from 27:46DD (PROBABLE code)

Label_27_46A1:: ; 27:46A1
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_044B
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_27_46C8
	farcall Palette_FadeOutToWhite
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	xor a, a
	ret

Label_27_46C8:: ; 27:46C8
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_27_46DD
	farcall Palette_FadeOutToWhite
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	ld a, $FF
	ret

Label_27_46DD:: ; 27:46DD
	jr Label_27_46A1

; ---- data $46DF-$46E5 (6 bytes) [HYPOTHESIS] UNCLASSIFIED 6 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_27_46DF:: ; 27:46DF
	db $CD, $47, $47, $CA, $E5, $46

; ---- code $46E5-$4747 (98 bytes) [CONFIRMED] 32 insn(s) reached by static flow only; seeds: exec x32; min discovery hops 1; entered by jpcc from 27:4337 (executed) [executed in 4 scenarios]

MailConnect_ShowError:: ; 27:46E5
	ld a, [wMobileResultDetail]
	ld [wRam_C273], a
	ld a, [wMobileResultDetail + 1]
	ld [wRam_C274], a
	ld a, [wMobileResultCode]
	ld [wMobileErrorCode], a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld a, $07
	ldh [rWX], a
	call Function_00_044B
	farcall Palette_FadeOutToWhite
	farcall Timer_ResetClockB
	ld de, $C0A9
	farcall Mobile_BeginDisconnect

Label_27_471A:: ; 27:471A
	farcall Mobile_DisconnectPoll
	cp a, $01
	jr z, Label_27_471A
	farcall Mobile_BeginCancel

Label_27_472A:: ; 27:472A
	farcall Mobile_CancelPoll
	cp a, $01
	jr z, Label_27_472A
	cp a, $FF
	jr z, Label_27_4738

Label_27_4738:: ; 27:4738
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	farcall Mobile_ShowLastError
	ld a, $80
	ret

; ---- code $4747-$4751 (10 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 4/18 scenarios); entry proven: target of an executed call/far call

MailConnect_PollAdapterError:: ; 27:4747
Function_27_4747::
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, Label_27_4751
	xor a, a
	inc a
	ret

; ---- code $4751-$4768 (23 bytes) [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 1; entered by jrcc from 27:474C (executed) [executed in 4 scenarios]

Label_27_4751:: ; 27:4751
	push bc
	push de
	push hl
	ld a, $07
	ldh [rWX], a
	call Function_00_044B
	farcall Mobile_FetchResult
	pop hl
	pop de
	pop bc
	ld a, $FF
	inc a
	ret

; ---- code $4768-$477A (18 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailDisconnect_Screen:: ; 27:4768
Function_27_4768::
	ld a, $01
	push af
	ld a, b
	cp a, $00
	jr nz, Label_27_4776
	xor a, a
	ld [wMailScreenMode], a
	jr Label_27_4786

Label_27_4776:: ; 27:4776
	cp a, $01
	jr nz, Label_27_4781

; ---- code $477A-$4781 (7 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 27:4778 (executed)
	ld a, $01
	ld [wMailScreenMode], a
	jr Label_27_4786

; ---- code $4781-$4812 (145 bytes) [CONFIRMED] 55 insn(s); 55 executed (in up to 2/18 scenarios)

Label_27_4781:: ; 27:4781
	ld a, $02
	ld [wMailScreenMode], a

Label_27_4786:: ; 27:4786
	pop af
	call MailConnect_InitScreen
	push bc
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000B
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	pop bc
	ld bc, $0514
	ld de, $D000
	ld hl, MailDisconnect_WinMsg_Ending
	ld a, $27
	farcall Function_00_08EA
	ld a, $40
	farcall Function_00_0887
	ld hl, $DA80
	ld de, $7030
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $7100
	ld hl, $DA80
	call Function_00_0A65
	ld hl, $DA30
	ld de, $6F30
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $2F48
	ld hl, $DA30
	call Function_00_0A65
	ld a, [wMailScreenMode]
	cp a, $00
	jr nz, Label_27_4831
	call Mail_OutboxIsEmpty
	inc a
	jr nz, Label_27_4816
	ld hl, $DA40
	ld de, $7020
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D625
	ld a, [hli]
	cp a, $00
	jr z, Label_27_4826

; ---- code $4812-$4826 (20 bytes) [CONFIRMED] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0; fall-through of the jrcc at 27:4810 (executed) | upgraded by classifier 6: all 7 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	cp a, $FF
	jr z, Label_27_4826

Label_27_4816:: ; 27:4816
	ld hl, $DA40
	ld de, $7A60
	ld a, $27
	ld b, $81
	farcall Function_00_0A82

; ---- code $4826-$4835 (15 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)

Label_27_4826:: ; 27:4826
	ld de, $2F58
	ld hl, $DA40
	call Function_00_0A65
	jr Label_27_4869

Label_27_4831:: ; 27:4831
	cp a, $01
	jr nz, Label_27_4850

; ---- code $4835-$4850 (27 bytes) [PROBABLE] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0; fall-through of the jrcc at 27:4833 (executed)
	ld hl, $DA40
	ld de, $7AB0
	ld a, $27
	ld b, $81
	farcall Function_00_0A82
	ld de, $2F58
	ld hl, $DA40
	call Function_00_0A65
	jr Label_27_4869

; ---- code $4850-$48E6 (150 bytes) [CONFIRMED] 63 insn(s); 63 executed (in up to 2/18 scenarios)

Label_27_4850:: ; 27:4850
	ld hl, $DA30
	ld de, $7AD0
	ld a, $27
	ld b, $81
	farcall Function_00_0A82
	ld de, $2F48
	ld hl, $DA30
	call Function_00_0A65

Label_27_4869:: ; 27:4869
	farcall Timer_ResetClockB
	ld de, $C0A9
	farcall Mobile_BeginDisconnect
	ld b, $00

Label_27_487A:: ; 27:487A
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlots + 49]
	dec a
	ld [wSpriteSlots + 49], a
	ld a, [wSpriteSlots + 65]
	dec a
	ld [wSpriteSlots + 65], a
	di
	farcall Function_00_0956
	ei
	call Function_00_044B
	pop bc
	ld a, [wSpriteSlots + 49]
	cp a, $47
	jr nz, Label_27_487A
	ld de, $012C

Label_27_48A5:: ; 27:48A5
	push de
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	ldh a, [rSCX]
	dec a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20A6
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	pop bc
	pop de
	dec de
	ld a, d
	or a, e
	push de
	farcall Mobile_DisconnectPoll
	pop de
	cp a, $01
	jr z, Label_27_48A5
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, Label_27_48EA
	bit 0, a
	jr z, Label_27_48EA

; ---- code $48E6-$48EA (4 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 27:48E4 (executed) [executed in 2 scenarios]
	ld a, $01
	jr z, Label_27_48A5

; ---- code $48EA-$49B0 (198 bytes) [CONFIRMED] 83 insn(s); 83 executed (in up to 2/18 scenarios)

Label_27_48EA:: ; 27:48EA
	farcall Timer_ResetClockB
	farcall Mobile_BeginCancel

Label_27_48F6:: ; 27:48F6
	push de
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	ldh a, [rSCX]
	dec a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20A6
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	farcall Mobile_CancelPoll
	pop bc
	pop de
	cp a, $01
	jp z, Label_27_48F6
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0045
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld de, $71D0
	ld hl, $DA80
	call Function_00_0A65
	ld bc, $0514
	ld de, $D000
	ld hl, MailDisconnect_WinMsg_Ended
	ld a, $27
	farcall Function_00_08EA
	ld a, $40
	farcall Function_00_0887

Label_27_495E:: ; 27:495E
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlots + 49]
	dec a
	ld [wSpriteSlots + 49], a
	ld a, [wSpriteSlots + 65]
	dec a
	ld [wSpriteSlots + 65], a
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	ldh a, [rSCX]
	dec a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20A6
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	pop bc
	ld a, [wSpriteSlots + 49]
	cp a, $D0
	jr nz, Label_27_495E
	farcall Palette_FadeOutToWhite
	ld a, $D0
	ldh [rWY], a
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	xor a, a
	ret

; ---- code $49B0-$49C0 (16 bytes) [CONFIRMED] 199 insn(s) reached by static flow only; seeds: exec x199; min discovery hops 7; entered by far from 22:4BCB (PROBABLE code) | 8 insn(s) executed; cut out of the PROBABLE region 49B0-4B95 by apply_coverage --split [executed in 1 scenarios]

MailDisconnect_ScreenNoTimer:: ; 27:49B0
	ld a, [wTimerEnable]
	bit 4, a
	jp nz, MailDisconnect_Screen
	ld a, $01
	push af
	ld a, b
	cp a, $00
	jr nz, Label_27_49C6

; ---- code $49C0-$49C6 (6 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 49B0-4B95 by apply_coverage --split
	xor a, a
	ld [wMailScreenMode], a
	jr Label_27_49D6

; ---- code $49C6-$49CA (4 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 49B0-4B95 by apply_coverage --split [executed in 1 scenarios]

Label_27_49C6:: ; 27:49C6
	cp a, $01
	jr nz, Label_27_49D1

; ---- code $49CA-$49D1 (7 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 49B0-4B95 by apply_coverage --split
	ld a, $01
	ld [wMailScreenMode], a
	jr Label_27_49D6

; ---- code $49D1-$4A3E (109 bytes) [CONFIRMED] 40 insn(s) executed; cut out of the PROBABLE region 49B0-4B95 by apply_coverage --split [executed in 1 scenarios]

Label_27_49D1:: ; 27:49D1
	ld a, $02
	ld [wMailScreenMode], a

Label_27_49D6:: ; 27:49D6
	pop af
	call MailConnect_InitScreen
	push bc
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000B
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	pop bc
	ld bc, $0514
	ld de, $D000
	ld hl, MailDisconnect_WinMsg_Ending
	ld a, $27
	farcall Function_00_08EA
	ld a, $40
	farcall Function_00_0887
	ld hl, $DA80
	ld de, $7030
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $7100
	ld hl, $DA80
	call Function_00_0A65
	ld hl, $DA30
	ld de, $6F30
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $2F48
	ld hl, $DA30
	call Function_00_0A65
	ld a, [wMailScreenMode]
	cp a, $00
	jr nz, Label_27_4A81

; ---- code $4A3E-$4A81 (67 bytes) [PROBABLE] 26 insn(s) never executed in the traced runs; cut out of the PROBABLE region 49B0-4B95 by apply_coverage --split
	call Mail_OutboxIsEmpty
	inc a
	jr nz, Label_27_4A66
	ld hl, $DA40
	ld de, $7020
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D625
	ld a, [hli]
	cp a, $00
	jr z, Label_27_4A76
	cp a, $FF
	jr z, Label_27_4A76

Label_27_4A66:: ; 27:4A66
	ld hl, $DA40
	ld de, $7A60
	ld a, $27
	ld b, $81
	farcall Function_00_0A82

Label_27_4A76:: ; 27:4A76
	ld de, $2F58
	ld hl, $DA40
	call Function_00_0A65
	jr Label_27_4AB9

; ---- code $4A81-$4A85 (4 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 49B0-4B95 by apply_coverage --split [executed in 1 scenarios]

Label_27_4A81:: ; 27:4A81
	cp a, $01
	jr nz, Label_27_4AA0

; ---- code $4A85-$4AA0 (27 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 49B0-4B95 by apply_coverage --split
	ld hl, $DA40
	ld de, $7AB0
	ld a, $27
	ld b, $81
	farcall Function_00_0A82
	ld de, $2F58
	ld hl, $DA40
	call Function_00_0A65
	jr Label_27_4AB9

; ---- code $4AA0-$4B95 (245 bytes) [CONFIRMED] 106 insn(s) executed; cut out of the PROBABLE region 49B0-4B95 by apply_coverage --split [executed in 1 scenarios]

Label_27_4AA0:: ; 27:4AA0
	ld hl, $DA30
	ld de, $7AD0
	ld a, $27
	ld b, $81
	farcall Function_00_0A82
	ld de, $2F48
	ld hl, $DA30
	call Function_00_0A65

Label_27_4AB9:: ; 27:4AB9
	ld b, $00

Label_27_4ABB:: ; 27:4ABB
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlots + 49]
	dec a
	ld [wSpriteSlots + 49], a
	ld a, [wSpriteSlots + 65]
	dec a
	ld [wSpriteSlots + 65], a
	di
	farcall Function_00_0956
	ei
	call Function_00_044B
	pop bc
	ld a, [wSpriteSlots + 49]
	cp a, $47
	jr nz, Label_27_4ABB
	ld b, $3C

Label_27_4AE5:: ; 27:4AE5
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	ldh a, [rSCX]
	dec a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20A6
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	pop bc
	dec b
	jr nz, Label_27_4AE5
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0045
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld de, $71D0
	ld hl, $DA80
	call Function_00_0A65
	ld bc, $0514
	ld de, $D000
	ld hl, MailDisconnect_WinMsg_Ended
	ld a, $27
	farcall Function_00_08EA
	ld a, $40
	farcall Function_00_0887

Label_27_4B43:: ; 27:4B43
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlots + 49]
	dec a
	ld [wSpriteSlots + 49], a
	ld a, [wSpriteSlots + 65]
	dec a
	ld [wSpriteSlots + 65], a
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	ldh a, [rSCX]
	dec a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20A6
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	pop bc
	ld a, [wSpriteSlots + 49]
	cp a, $D0
	jr nz, Label_27_4B43
	farcall Palette_FadeOutToWhite
	ld a, $D0
	ldh [rWY], a
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	xor a, a
	ret

; ---- code $4B95-$4D06 (369 bytes) [CONFIRMED] 122 insn(s); 122 executed (in up to 4/18 scenarios); entry proven: target of an executed call/far call

MailConnect_InitScreen:: ; 27:4B95
Function_27_4B95::
	push bc
	push af
	farcall Function_00_09B6
	farcall Function_00_0956
	farcall LCDOff
	pop af
	pop bc
	push bc
	push af
	ld bc, $0040
	ld de, $D840
	ld hl, $7520
	ld a, $27
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D800
	ld hl, MailConnect_BgPalette
	ld a, $27
	farcall Palette_LoadToBuffer
	ld de, $8001
	ld hl, MailConnect_Tiles_5060
	ld a, $27
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8401
	ld hl, MailConnect_Tiles_5460
	ld a, $27
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8800
	ld hl, MailConnect_Tiles_5E60
	ld a, $27
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C00
	ld hl, MailConnect_Tiles_6260
	ld a, $27
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9000
	ld hl, MailConnect_Tiles_6660
	ld a, $27
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ld de, $9001
	ld hl, MailConnect_Tiles_5860
	ld a, $27
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, MailConnect_Tiles_5C60
	ld a, $27
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ld de, $8000
	ld hl, MailConnect_Tiles_6860
	ld a, $27
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8400
	ld hl, MailConnect_Tiles_6C60
	ld a, $27
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $1220
	ld de, $D000
	ld hl, MailConnect_Tilemap
	ld a, $27
	farcall Function_00_08EA
	ld bc, $0040
	ld de, $D840
	ld hl, $7520
	ld a, $27
	farcall Palette_LoadToBuffer
	ldh a, [rLCDC]
	call Function_00_082C
	pop af
	dec a
	jr z, Label_27_4CAF
	ld bc, $0514
	ld de, $D000
	ld hl, MailConnect_WinMsg_Connecting
	ld a, $27
	farcall Function_00_08EA
	jr Label_27_4CC0

Label_27_4CAF:: ; 27:4CAF
	ld bc, $0514
	ld de, $D000
	ld hl, MailDisconnect_WinMsg_Ending
	ld a, $27
	farcall Function_00_08EA

Label_27_4CC0:: ; 27:4CC0
	ld a, $40
	farcall Function_00_0887
	ld hl, $DA10
	ld de, MailConnect_ObjTable
	ld a, $27
	ld b, $81
	farcall Function_00_0A82
	ld de, $1800
	ld hl, $DA10
	call Function_00_0A65
	ld hl, $DA20
	ld de, $7A20
	ld a, $27
	ld b, $81
	farcall Function_00_0A82
	ld de, $1888
	ld hl, $DA20
	call Function_00_0A65
	di
	farcall Function_00_0956
	ei
	pop bc
	jp Label_27_4D31

; ---- code $4D06-$4D19 (19 bytes) [PROBABLE] 9 insn(s): function prologue (ldh [$FFF2],a ; ldh a,[$FF8D] ; push af ; ... ld a,7 ; ldh [$FF8D],a ; ldh [$FF70],a ; call $047A ; ld hl,$D800) falling into the code at 4D19; well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call Function_00_047A
	ld hl, $D800

; ---- code $4D19-$4D31 (24 bytes) [PROBABLE] 10 insn(s) reached by static flow only; seeds: site x10; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Palette_UploadBuffer
	ei
	call Function_00_0392
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh a, [rLCDC]
	call Function_00_082C

; ---- code $4D31-$4D4E (29 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 4/18 scenarios)

Label_27_4D31:: ; 27:4D31
	ld a, $70
	ldh [rWY], a
	farcall LCDOn
	ldh a, [rLCDC]
	or a, $64
	ldh [rLCDC], a
	call Function_00_0464
	farcall Palette_FadeInFromWhite
	ld bc, $0000
	ret

; ---- code $4D4E-$4D51 (3 bytes) [PROBABLE] 1 insn (call $4D81) falling into the code at 4D51; well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS
	call CommTime_DrawHMSScreen

; ---- code $4D51-$4D81 (48 bytes) [PROBABLE] 18 insn(s) reached by static flow only; seeds: site x18; min discovery hops 0; entered by jr from 27:4D7F (PROBABLE code)

Label_27_4D51:: ; 27:4D51
	push bc
	farcall Function_00_0956
	call Function_00_044B
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_27_4D70
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

Label_27_4D70:: ; 27:4D70
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_27_4D7F
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

Label_27_4D7F:: ; 27:4D7F
	jr Label_27_4D51

; ---- code $4D81-$4D87 (6 bytes) [PROBABLE] 5 insn(s) (xor a ; ldh [$FF43],a ; push de ; push bc ; push af) falling into the code at 4D87; entered by call $4D81 from 27:4D4E (this classification)

CommTime_DrawHMSScreen:: ; 27:4D81
	xor a, a
	ldh [rSCX], a
	push de
	push bc
	push af

; ---- code $4D87-$4EC0 (313 bytes) [PROBABLE] 128 insn(s) reached by static flow only; seeds: site x128; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Function_00_09B6
	farcall Function_00_0956
	farcall LCDOff
	pop af
	pop bc
	pop de
	push de
	push bc
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_29_5AD0
	ld a, $29
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D840
	ld hl, $7520
	ld a, $27
	farcall Palette_LoadToBuffer
	ld de, $9001
	ld hl, Data_29_5400
	ld a, $29
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $1214
	ld de, $D000
	ld hl, Data_29_5800
	ld a, $29
	farcall Function_00_08EA
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call Function_00_047A
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Function_00_0392
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh a, [rLCDC]
	call Function_00_082C
	pop bc
	pop de
	push bc
	push de
	ld l, b
	ld h, $00
	ld de, $000A
	farcall Divide16
	xor a, a
	ldh [rVBK], a
	ld a, l
	add a, $20
	ld [$9902], a
	add a, $10
	ld [$9922], a
	ld a, e
	add a, $20
	ld [$9903], a
	add a, $10
	ld [$9923], a
	ld a, $01
	ldh [rVBK], a
	ld a, $08
	ld [$9902], a
	ld [$9922], a
	ld [$9903], a
	ld [$9923], a
	pop de
	pop bc
	push bc
	push de
	ld l, c
	ld h, $00
	ld de, $000A
	farcall Divide16
	xor a, a
	ldh [rVBK], a
	ld a, l
	add a, $20
	ld [$9907], a
	add a, $10
	ld [$9927], a
	ld a, e
	add a, $20
	ld [$9908], a
	add a, $10
	ld [$9928], a
	ld a, $01
	ldh [rVBK], a
	ld a, $08
	ld [$9907], a
	ld [$9927], a
	ld [$9908], a
	ld [$9928], a
	pop de
	pop bc
	ld l, d
	ld h, $00
	ld de, $000A
	farcall Divide16
	xor a, a
	ldh [rVBK], a
	ld a, l
	add a, $20
	ld [$990B], a
	add a, $10
	ld [$992B], a
	ld a, e
	add a, $20
	ld [$990C], a
	add a, $10
	ld [$992C], a
	ld a, $01
	ldh [rVBK], a
	ld a, $08
	ld [$990B], a
	ld [$992B], a
	ld [$990C], a
	ld [$992C], a
	jp Label_27_4EEB

; ---- code $4EC0-$4ED3 (19 bytes) [PROBABLE] 9 insn(s): same prologue as 27:4D06 (WRAM7 switch, call $047A, ld hl,$D800) falling into the code at 4ED3; well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS

Function_27_4EC0:: ; 27:4EC0
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call Function_00_047A
	ld hl, $D800

; ---- code $4ED3-$4EF5 (34 bytes) [PROBABLE] 13 insn(s) reached by static flow only; seeds: site x13; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Palette_UploadBuffer
	ei
	call Function_00_0392
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh a, [rLCDC]
	call Function_00_082C

Label_27_4EEB:: ; 27:4EEB
	farcall LCDOn
	ld bc, $0000
	ret

; ---- code $4EF5-$4F0B (22 bytes) [PROBABLE] 11 insn(s) (call $05BD ; ldh a,[rLCDC] ; and $9F ; ldh [rLCDC],a ; xor a ; ldh [rSCX],a ; ldh [rSCY],a ; ld a,7 ; ldh [rOBP...],a ; ld a,$90 ; ldh [rWY],a) falling into the code at 4F0B; well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS
	call LCDOff
	ldh a, [rLCDC]
	and a, $9F
	ldh [rLCDC], a
	xor a, a
	ldh [rSCX], a
	ldh [rSCY], a
	ld a, $07
	ldh [rWX], a
	ld a, $90
	ldh [rWY], a

; ---- code $4F0B-$4FD8 (205 bytes) [PROBABLE] 72 insn(s) reached by static flow only; seeds: site x72; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Function_00_09B6
	ld de, $9001
	ld hl, Data_51_4DB0
	ld a, $51
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_51_51B0
	ld a, $51
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, Data_51_5880
	ld a, $51
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_CommTime_SummaryB
	ld a, $51
	farcall Function_00_08EA
	ld a, [wTimerAFrames]
	ldh [hRam_FFB0], a
	ld a, [wTimerASeconds]
	ldh [hRam_FFB1], a
	ld a, [wTimerAMinutes]
	ldh [hRam_FFB2], a
	ld a, [wRam_C2D7]
	ldh [hRam_FFB3], a
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D164
	ldh a, [hRam_FFB2]
	ld l, a
	ld h, $00
	sub a, $3C
	jr c, Label_27_4F84
	ld hl, $003B
	ld a, $3B
	ldh [hRam_FFB1], a

Label_27_4F84:: ; 27:4F84
	xor a, a
	ldh [hRam_FFB4], a
	ld bc, $FF9C
	call Function_27_4FFB
	ld bc, $FFF6
	call Function_27_4FFB
	ld a, l
	call Function_27_5021
	ld de, $D169
	ldh a, [hRam_FFB1]
	ld l, a
	ld h, $00
	xor a, a
	ldh [hRam_FFB4], a
	ld bc, $FFF6
	call Function_27_4FFB
	ld a, l
	call Function_27_5021
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	farcall Palette_FadeInFromWhite
	xor a, a
	ldh [hDialogResult], a

Label_27_4FC0:: ; 27:4FC0
	farcall Function_00_0956
	call Function_00_044B
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $4FD8-$4FE2 (10 bytes) [PROBABLE] inline table of `call $056A` (JoypadDispatch) at 27:4FD5: 5 entries; fixed length (5 words) by the routine

Table_27_4FD8:: ; 27:4FD8
	dw Label_27_4FE2
	dw Label_27_4FE5
	dw Label_27_4FE8
	dw Label_27_4FEB
	dw Label_27_4FC0

; ---- code $4FE2-$5048 (102 bytes) [PROBABLE] 63 insn(s) reached by static flow only; seeds: site x63; min discovery hops 0; entered by table from 27:4FD5 (PROBABLE code)

Label_27_4FE2:: ; 27:4FE2
	jp Label_27_4FEE

Label_27_4FE5:: ; 27:4FE5
	jp Label_27_4FC0

Label_27_4FE8:: ; 27:4FE8
	jp Label_27_4FC0

Label_27_4FEB:: ; 27:4FEB
	jp Label_27_4FC0

Label_27_4FEE:: ; 27:4FEE
	farcall Palette_FadeOutToWhite
	farcall Function_00_09B6
	ret

Function_27_4FFB:: ; 27:4FFB
	inc a
	add hl, bc
	bit 7, h
	jr z, Function_27_4FFB
	dec a
	jr nz, Label_27_500B
	ldh a, [hRam_FFB4]
	or a, a
	jr z, Label_27_5016
	ld a, $00

Label_27_500B:: ; 27:500B
	push bc
	push hl
	call Function_27_5021
	pop hl
	pop bc
	ld a, $FF
	ldh [hRam_FFB4], a

Label_27_5016:: ; 27:5016
	inc de
	dec bc
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	add hl, bc
	xor a, a
	ret

Function_27_5021:: ; 27:5021
	push bc
	push de
	ld h, d
	ld l, e
	add a, a
	add a, $48
	ld e, a
	ld a, $00
	adc a, $50
	ld d, a
	ld a, [de]
	ld [hl], a
	inc de
	ld bc, $0400
	add hl, bc
	ld a, $08
	ld [hl], a
	ld bc, $FC20
	add hl, bc
	ld a, [de]
	ld [hl], a
	ld bc, $0400
	add hl, bc
	ld a, $08
	ld [hl], a
	pop de
	pop bc
	ret

; ---- data $5048-$505C (20 bytes) [HYPOTHESIS] 20 bytes = 10 pairs of tile indices (67 77 68 78 69 79 69 6F 6A 7A 6B 7B 6C 7C 6D 7D 6E 7E 6E 7F; second byte = first + $10 in 9 of 10 pairs) following the ret at 27:5047: probably one 20-column tilemap row (rows elsewhere are padded to 24 bytes with 4 zero bytes, as here); no reference found. Splits the mapper heuristic gfx region 5051-5060

Data_27_5048:: ; 27:5048
	db $67, $77, $68, $78, $69, $79, $69, $6F, $6A, $7A, $6B, $7B, $6C, $7C, $6D, $7D
	db $6E, $7E, $6E, $7F

; ---- zero $505C-$5060 (4 bytes) [PROBABLE] 4 zero bytes: row padding (20 + 4 = 24) before the aligned tile block at 27:5060
	ds $4, $00
