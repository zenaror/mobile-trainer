; engine/mail/send_receive.asm
; bank 27, $4000-$5060 (4192 bytes); pinned by layout.link
; mail send/receive orchestration, connect and disconnect screens, comm-time screen

SECTION "engine/mail/send_receive", ROMX

MailSendRecv_Main:: ; 27:4000
Function_27_4000::
	; [CONFIRMED] 61 insn(s); 61 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $01
	ld [wCommNoticeMode], a
	xor a, a
	ld [wCommNoticeGfxSet], a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock
	ld de, MailSendRecv_RequestTemplate
	ld b, $07
.loop ; 27:4017
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .loop
	farcall Mailbox_CountRecords
	ld a, $0C
	sub a, d
	ld [wMailSessionBlock + 6], a
	xor a, a
	ld [wMailSessionBlock + 7], a
	ld d, $01
	ld bc, wMailSessionBlock
	farcall ConnectDialog_Run
	inc b
	ret z
	farcall Mailbox_CountRecords
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
	jr z, .l407B
	cp a, $20
	jr z, MailSendRecv_Main_EndNoSession
	cp a, $80
	jr nz, MailSendRecv_Main_RunSession

.l407B ; 27:407B
	; [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 0;
	; entered by jrcc from 27:4071 (executed) [executed in 2 scenarios]
	ld a, [wMobileErrorCode]
	cp a, $17
	jp z, MailSendRecv_Main_ErrorDisconnect
	cp a, $20
	jp z, MailSendRecv_Main_ErrorDisconnect
	cp a, $21
	jp z, MailSendRecv_Main_ErrorDisconnect
	cp a, $23
	jp z, MailSendRecv_Main_ErrorDisconnect
	cp a, $24
	jp z, MailSendRecv_Main_ErrorDisconnect
	cp a, $26
	jp z, MailSendRecv_Main_ErrorDisconnect
	jp MailSendRecv_Main_EndNoSession

; ---- data $409F-$40A1 (2 bytes) [HYPOTHESIS] UNCLASSIFIED 2 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_27_409F:: ; 27:409F
	db $18, $5E

MailSendRecv_Main_ErrorDisconnect:: ; 27:40A1
Label_27_40A1::
	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1;
	; entered by jpcc from 27:4080 (PROBABLE code)
	ld a, [wTimerEnable]
	bit 4, a
	jp z, .l40B3
	ld b, $00
	farcall MailDisconnect_Screen
	jr MailSendRecv_Main_EndNoSession
.l40B3 ; 27:40B3
	ld b, $00
	farcall MailDisconnect_ScreenNoTimer

MailSendRecv_Main_EndNoSession:: ; 27:40BB
Label_27_40BB::
	; [CONFIRMED] 21 insn(s); 21 executed (in up to 2/18 scenarios)
	farcall CommTime_TimerAIsNonZero
	or a, a
	jr nz, .l40C8
	ld a, h
	or a, l
	jr z, .done
.l40C8 ; 27:40C8
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen
.done ; 27:40D6
	ret

MailSendRecv_Main_RunSession:: ; 27:40D7
Label_27_40D7::
	farcall MailSession_Run
	cp a, $80
	cp a, $7F
	ld a, [wTimerEnable]
	bit 4, a
	jp z, .l40F5
	ld a, $01
	ld b, $00
	farcall MailDisconnect_Screen
	jr .l40FF

.l40F5 ; 27:40F5
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jpcc from 27:40E6 (executed)
	ld a, $01
	ld b, $00
	farcall MailDisconnect_ScreenNoTimer

.l40FF ; 27:40FF
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)
	xor a, a
	ld [wCommSessionActive], a
	farcall CommTime_TimerAIsNonZero
	or a, a
	jr nz, .l4110

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 27:410A (executed)
	ld a, h
	or a, l
	jr z, .l411E

.l4110 ; 27:4110
	; [CONFIRMED] 29 insn(s); 29 executed (in up to 1/18 scenarios)
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen
.l411E ; 27:411E
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
	jr z, .l4156
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
	jr z, .l4156

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 27:414D (executed) [executed in 1 scenarios]
	ld a, [wMailSessionBlock + 3]
	inc a
	ld [wMailSessionBlock + 3], a

.l4156 ; 27:4156
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios)
	farcall MailResult_Screen
	xor a, a
	ld [wMailScreenMode], a
	farcall MailServerStatus_Screen

	; [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0; entry
	; not recorded [executed in 2 scenarios]
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

	; [PROBABLE] 24 insn(s) reached by static flow only; seeds: site x24; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Mobile_BeginCancel
.loop ; 27:4187
	farcall Mobile_CancelPoll
	cp a, $01
	jr z, .loop
	cp a, $FF
	jr z, .l4195
.l4195 ; 27:4195
	farcall CommTime_TimerAIsNonZero
	or a, a
	jr nz, .l41A2
	ld a, h
	or a, l
	jr z, .l41B0
.l41A2 ; 27:41A2
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen
.l41B0 ; 27:41B0
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei
	ret

Mail_OutboxIsEmpty:: ; 27:41BC
Function_27_41BC::
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, sMailDraft_ToAddress
	ld a, [hl]
	cp a, $00
	jr nz, .l41DB
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $FF
	ret

.l41DB ; 27:41DB
	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1;
	; entered by jrcc from 27:41D0 (executed) | upgraded by classifier 6: all 5 instruction starts
	; of the region are in analysis/coverage_union.tsv (executed in a trace)
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ret

MailConnect_Screen:: ; 27:41E3
Function_27_41E3::
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $00
	push af
	ld a, b
	cp a, $00
	jr nz, .l41F1
	xor a, a
	ld [wMailScreenMode], a
	jr .l4201
.l41F1 ; 27:41F1
	cp a, $01
	jr nz, .l41FC

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 27:41F3 (executed)
	ld a, $01
	ld [wMailScreenMode], a
	jr .l4201

.l41FC ; 27:41FC
	; [CONFIRMED] 53 insn(s); 53 executed (in up to 4/18 scenarios)
	ld a, $02
	ld [wMailScreenMode], a
.l4201 ; 27:4201
	pop af
	call MailConnect_InitScreen
	push bc
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000B
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	pop bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, $09
	ld hl, wMailTextScratch
	ld de, $C0A0 ; raw: scratch: 9 bytes copied from $D524, not a glyph
.loop ; 27:4225
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ld hl, wSpriteSlot8
	ld de, $7030
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7100
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	ld hl, wSpriteSlot3
	ld de, $7A30
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2FE0
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ld a, [wMailScreenMode]
	cp a, $00
	jr nz, .l4297
	call Mail_OutboxIsEmpty
	inc a
	jr nz, .l427C
	ld hl, wSpriteSlot4
	ld de, $7A40
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	jr .l428C

.l427C ; 27:427C
	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1;
	; entered by jrcc from 27:4268 (executed) | upgraded by classifier 6: all 5 instruction starts
	; of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, wSpriteSlot4
	ld de, $7A50
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot

.l428C ; 27:428C
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 3/18 scenarios)
	ld de, $2FD0
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	jr .l42CF
.l4297 ; 27:4297
	cp a, $01
	jr nz, .l42B6

	; [PROBABLE] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0;
	; fall-through of the jrcc at 27:4299 (executed)
	ld hl, wSpriteSlot4
	ld de, $7AA0
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2FD0
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	jr .l42CF

.l42B6 ; 27:42B6
	; [CONFIRMED] 86 insn(s); 86 executed (in up to 4/18 scenarios)
	ld hl, wSpriteSlot3
	ld de, $7AC0
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2FE0
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
.l42CF ; 27:42CF
	farcall Session_ResetCounters
	farcall Timer_ResetClockB
	farcall Stub_Nop_7F_61FC
	xor a, a
	ld [wCommSessionActive], a
	ld hl, wBrowserTimerLastSec
	ld [hli], a
	ld [hl], a
	ld hl, wTimerAFrames
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $09
	ld [wTimerAWarnMinute], a
	xor a, a
	ld [wTimerAWarnFlags], a
	ld de, $C0A9 ; raw: dead load: Mobile_SessionInit loads DE itself
	farcall Mobile_SessionInit
	ld b, $00

MailConnect_Screen_Loop:: ; 27:4305
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlot3 + $01]
	inc a
	ld [wSpriteSlot3 + $01], a
	ld a, [wSpriteSlot4 + $01]
	inc a
	ld [wSpriteSlot4 + $01], a
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_WaitAndService
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l4334
	ld b, $01
.l4334 ; 27:4334
	call MailConnect_PollAdapterError
	jp z, MailConnect_ShowError
	ld a, [wSpriteSlot3 + $01]
	cp a, $47
	jr nz, MailConnect_Screen_Loop
.l4341 ; 27:4341
	ld a, b
	cp a, $01
	jp z, .l44E1
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	ldh a, [rSCX]
	inc a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_FrameTick
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l4374
	ld b, $01
.l4374 ; 27:4374
	call MailConnect_PollAdapterError
	jp z, MailConnect_ShowError
	push bc
	farcall Mobile_ConnectPoll
	pop bc
	cp a, $01
	jr z, .l4341
	cp a, $FF
	jr nz, .l4393

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 27:4388 (executed)
	farcall MailSession_ShowCommError
	ld a, $80
	ret

.l4393 ; 27:4393
	; [CONFIRMED] 34 insn(s); 34 executed (in up to 2/18 scenarios)
	push bc
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	farcall Settings_GetSelectedDialEntry
	inc b
	ld c, b
	farcall Timer_ResetClockB
	ld hl, $C0A0 ; raw: scratch: the password source of Mobile_BeginConnect, not a glyph
	farcall Mobile_BeginConnect
	pop bc
.l43B3 ; 27:43B3
	ld a, b
	cp a, $01
	jp z, .l44E1
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	ldh a, [rSCX]
	inc a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_FrameTick
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l43E6

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 27:43E2 (executed)
	ld b, $01

.l43E6 ; 27:43E6
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 2/18 scenarios)
	push bc
	farcall Mobile_ConnectPoll
	pop bc
	cp a, $01
	jr z, .l43B3
	cp a, $FF
	jr nz, .l43FF

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 27:43F4 (executed)
	farcall MailSession_ShowCommError
	ld a, $80
	ret

.l43FF ; 27:43FF
	; [CONFIRMED] 164 insn(s); 164 executed (in up to 2/18 scenarios)
	ld a, $01
	ld [wCommSessionActive], a
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002F
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld bc, $0514
	ld de, wScreenTileMap
	ld hl, MailConnect_WinMsg_Connected
	ld a, $27
	farcall Tilemap_CopyRectAndAttr
	ld a, $40
	farcall Gfx_UploadWinMapBuffers
	ld hl, wSpriteSlot5
	ld de, $7A70
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2F47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ld c, $1E
.l444C ; 27:444C
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	ldh a, [rSCX]
	inc a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_FrameTick
	pop af
	ldh [rSVBK], a
	pop bc
	dec c
	jr nz, .l444C
	ld de, $2FD0
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0044
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
.l448B ; 27:448B
	call MailConnect_PollAdapterError
	jp z, MailConnect_ShowError
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlot3 + $01]
	inc a
	inc a
	ld [wSpriteSlot3 + $01], a
	ld a, [wSpriteSlot4 + $01]
	inc a
	inc a
	ld [wSpriteSlot4 + $01], a
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	ldh a, [rSCX]
	inc a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_FrameTick
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	pop bc
	ld a, [wSpriteSlot3 + $01]
	cp a, $A7
	jr c, .l448B
	farcall Palette_FadeOutToWhite
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	xor a, a
	ret
.l44E1 ; 27:44E1
	call VBlank_Wait
	ld bc, $0514
	ld de, wScreenTileMap
	ld hl, MailConnect_WinMsg_Cancelling
	ld a, $27
	farcall Tilemap_CopyRectAndAttr
	ld a, $40
	farcall Gfx_UploadWinMapBuffers
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002F
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld hl, wSpriteSlot5
	ld de, $7A70
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2F47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ld b, $3C
.l452C ; 27:452C
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_WaitAndService
	pop bc
	dec b
	jr nz, .l452C
	farcall Timer_ResetClockB
	farcall Mobile_BeginCancel
	ld de, $2FE0
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ld hl, wSpriteSlot3
	ld de, $6F30
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2F47
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ld a, [wMailScreenMode]
	cp a, $00
	jr nz, .l45A4
	call Mail_OutboxIsEmpty
	inc a
	jr nz, .l4589
	ld hl, wSpriteSlot4
	ld de, $7020
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	jr .l4599

.l4589 ; 27:4589
	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1;
	; entered by jrcc from 27:4575 (executed) [executed in 4 scenarios]
	ld hl, wSpriteSlot4
	ld de, $7A60
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot

.l4599 ; 27:4599
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 2/18 scenarios)
	ld de, $2F57
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	jr .l45DC

.l45A4 ; 27:45A4
	; [CONFIRMED] 19 insn(s) reached by static flow only; seeds: exec x19; min discovery hops 1;
	; entered by jrcc from 27:456F (executed) | 2 insn(s) executed; cut out of the PROBABLE region
	; 45A4-45DC by apply_coverage --split [executed in 8 scenarios]
	cp a, $01
	jr nz, .l45C3

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 45A4-45DC by apply_coverage --split
	ld hl, wSpriteSlot4
	ld de, $7AB0
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2F57
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	jr .l45DC

.l45C3 ; 27:45C3
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 45A4-45DC by apply_coverage
	; --split [executed in 8 scenarios]
	ld hl, wSpriteSlot3
	ld de, $7AD0
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2F47
	ld hl, wSpriteSlot3
	call Sprite_SetPosition

.l45DC ; 27:45DC
	; [CONFIRMED] 86 insn(s); 86 executed (in up to 2/18 scenarios)
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	ldh a, [rSCX]
	dec a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_FrameTick
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	pop bc
	farcall Mobile_CancelPoll
	cp a, $01
	jr z, .l45DC
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0045
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld de, $71D0
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	ld bc, $0514
	ld de, wScreenTileMap
	ld hl, MailConnect_WinMsg_Cancelled
	ld a, $27
	farcall Tilemap_CopyRectAndAttr
	ld a, $40
	farcall Gfx_UploadWinMapBuffers
.l4641 ; 27:4641
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlot3 + $01]
	dec a
	ld [wSpriteSlot3 + $01], a
	ld a, [wSpriteSlot4 + $01]
	dec a
	ld [wSpriteSlot4 + $01], a
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	ldh a, [rSCX]
	dec a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_FrameTick
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	pop bc
	ld a, [wSpriteSlot3 + $01]
	cp a, $C0
	jr nz, .l4641
	farcall Palette_FadeOutToWhite
	ld a, $D0
	ldh [rWY], a
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	ld b, $78
.l4693 ; 27:4693
	push bc
	call VBlank_WaitAndService
	pop bc
	dec b
	jr nz, .l4693
	ld a, $FF
	ld a, $20
	ret

; ---- data $46A0-$46A1 (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_27_46A0:: ; 27:46A0
	db $C9

.loop ; 27:46A1
	; [PROBABLE] 26 insn(s) reached by static flow only; seeds: site x26; min discovery hops 0;
	; entered by jr from 27:46DD (PROBABLE code)
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_WaitAndService
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .l46C8
	farcall Palette_FadeOutToWhite
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	xor a, a
	ret
.l46C8 ; 27:46C8
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l46DD
	farcall Palette_FadeOutToWhite
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	ld a, $FF
	ret
.l46DD ; 27:46DD
	jr .loop

; ---- data $46DF-$46E5 (6 bytes) [HYPOTHESIS] UNCLASSIFIED 6 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_27_46DF:: ; 27:46DF
	db $CD, $47, $47, $CA, $E5, $46

MailConnect_ShowError:: ; 27:46E5
	; [CONFIRMED] 32 insn(s) reached by static flow only; seeds: exec x32; min discovery hops 1;
	; entered by jpcc from 27:4337 (executed) [executed in 4 scenarios]
	ld a, [wMobileResultDetail]
	ld [wMobileErrorDetail], a
	ld a, [wMobileResultDetail + 1]
	ld [wMobileErrorDetailHi], a
	ld a, [wMobileResultCode]
	ld [wMobileErrorCode], a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld a, $07
	ldh [rWX], a
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	farcall Timer_ResetClockB
	ld de, $C0A9 ; raw: dead load: Mobile_BeginDisconnect loads DE itself
	farcall Mobile_BeginDisconnect
.l471A ; 27:471A
	farcall Mobile_DisconnectPoll
	cp a, $01
	jr z, .l471A
	farcall Mobile_BeginCancel
.l472A ; 27:472A
	farcall Mobile_CancelPoll
	cp a, $01
	jr z, .l472A
	cp a, $FF
	jr z, .l4738
.l4738 ; 27:4738
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	farcall Mobile_ShowLastError
	ld a, $80
	ret

MailConnect_PollAdapterError:: ; 27:4747
Function_27_4747::
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, .l4751
	xor a, a
	inc a
	ret

.l4751 ; 27:4751
	; [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 1;
	; entered by jrcc from 27:474C (executed) [executed in 4 scenarios]
	push bc
	push de
	push hl
	ld a, $07
	ldh [rWX], a
	call VBlank_WaitAndService
	farcall Mobile_FetchResult
	pop hl
	pop de
	pop bc
	ld a, $FF
	inc a
	ret

MailDisconnect_Screen:: ; 27:4768
Function_27_4768::
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $01
	push af
	ld a, b
	cp a, $00
	jr nz, .l4776
	xor a, a
	ld [wMailScreenMode], a
	jr .l4786
.l4776 ; 27:4776
	cp a, $01
	jr nz, .l4781

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 27:4778 (executed)
	ld a, $01
	ld [wMailScreenMode], a
	jr .l4786

.l4781 ; 27:4781
	; [CONFIRMED] 55 insn(s); 55 executed (in up to 2/18 scenarios)
	ld a, $02
	ld [wMailScreenMode], a
.l4786 ; 27:4786
	pop af
	call MailConnect_InitScreen
	push bc
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000B
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	pop bc
	ld bc, $0514
	ld de, wScreenTileMap
	ld hl, MailDisconnect_WinMsg_Ending
	ld a, $27
	farcall Tilemap_CopyRectAndAttr
	ld a, $40
	farcall Gfx_UploadWinMapBuffers
	ld hl, wSpriteSlot8
	ld de, $7030
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7100
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	ld hl, wSpriteSlot3
	ld de, $6F30
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2F48
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ld a, [wMailScreenMode]
	cp a, $00
	jr nz, .l4831
	call Mail_OutboxIsEmpty
	inc a
	jr nz, .l4816
	ld hl, wSpriteSlot4
	ld de, $7020
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock + $01
	ld a, [hli]
	cp a, $00
	jr z, .l4826

	; [CONFIRMED] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0;
	; fall-through of the jrcc at 27:4810 (executed) | upgraded by classifier 6: all 7 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	cp a, $FF
	jr z, .l4826
.l4816 ; 27:4816
	ld hl, wSpriteSlot4
	ld de, $7A60
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot

.l4826 ; 27:4826
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)
	ld de, $2F58
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	jr .l4869
.l4831 ; 27:4831
	cp a, $01
	jr nz, .l4850

	; [PROBABLE] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0;
	; fall-through of the jrcc at 27:4833 (executed)
	ld hl, wSpriteSlot4
	ld de, $7AB0
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2F58
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	jr .l4869

.l4850 ; 27:4850
	; [CONFIRMED] 63 insn(s); 63 executed (in up to 2/18 scenarios)
	ld hl, wSpriteSlot3
	ld de, $7AD0
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2F48
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
.l4869 ; 27:4869
	farcall Timer_ResetClockB
	ld de, $C0A9 ; raw: dead load: Mobile_BeginDisconnect loads DE itself
	farcall Mobile_BeginDisconnect
	ld b, $00
.l487A ; 27:487A
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlot3 + $01]
	dec a
	ld [wSpriteSlot3 + $01], a
	ld a, [wSpriteSlot4 + $01]
	dec a
	ld [wSpriteSlot4 + $01], a
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_WaitAndService
	pop bc
	ld a, [wSpriteSlot3 + $01]
	cp a, $47
	jr nz, .l487A
	ld de, $012C
.l48A5 ; 27:48A5
	push de
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	ldh a, [rSCX]
	dec a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_FrameTick
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
	jr z, .l48A5
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, .l48EA
	bit 0, a
	jr z, .l48EA

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 27:48E4 (executed) [executed in 2 scenarios]
	ld a, $01
	jr z, .l48A5

.l48EA ; 27:48EA
	; [CONFIRMED] 83 insn(s); 83 executed (in up to 2/18 scenarios)
	farcall Timer_ResetClockB
	farcall Mobile_BeginCancel
.l48F6 ; 27:48F6
	push de
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	ldh a, [rSCX]
	dec a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_FrameTick
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	farcall Mobile_CancelPoll
	pop bc
	pop de
	cp a, $01
	jp z, .l48F6
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0045
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld de, $71D0
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	ld bc, $0514
	ld de, wScreenTileMap
	ld hl, MailDisconnect_WinMsg_Ended
	ld a, $27
	farcall Tilemap_CopyRectAndAttr
	ld a, $40
	farcall Gfx_UploadWinMapBuffers
.l495E ; 27:495E
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlot3 + $01]
	dec a
	ld [wSpriteSlot3 + $01], a
	ld a, [wSpriteSlot4 + $01]
	dec a
	ld [wSpriteSlot4 + $01], a
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	ldh a, [rSCX]
	dec a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_FrameTick
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	pop bc
	ld a, [wSpriteSlot3 + $01]
	cp a, $D0
	jr nz, .l495E
	farcall Palette_FadeOutToWhite
	ld a, $D0
	ldh [rWY], a
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	xor a, a
	ret

MailDisconnect_ScreenNoTimer:: ; 27:49B0
	; [CONFIRMED] 199 insn(s) reached by static flow only; seeds: exec x199; min discovery hops 7;
	; entered by far from 22:4BCB (PROBABLE code) | 8 insn(s) executed; cut out of the PROBABLE
	; region 49B0-4B95 by apply_coverage --split [executed in 1 scenarios]
	ld a, [wTimerEnable]
	bit 4, a
	jp nz, MailDisconnect_Screen
	ld a, $01
	push af
	ld a, b
	cp a, $00
	jr nz, .l49C6

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 49B0-4B95 by apply_coverage --split
	xor a, a
	ld [wMailScreenMode], a
	jr .l49D6

.l49C6 ; 27:49C6
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 49B0-4B95 by apply_coverage
	; --split [executed in 1 scenarios]
	cp a, $01
	jr nz, .l49D1

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 49B0-4B95 by apply_coverage --split
	ld a, $01
	ld [wMailScreenMode], a
	jr .l49D6

.l49D1 ; 27:49D1
	; [CONFIRMED] 40 insn(s) executed; cut out of the PROBABLE region 49B0-4B95 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $02
	ld [wMailScreenMode], a
.l49D6 ; 27:49D6
	pop af
	call MailConnect_InitScreen
	push bc
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000B
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	pop bc
	ld bc, $0514
	ld de, wScreenTileMap
	ld hl, MailDisconnect_WinMsg_Ending
	ld a, $27
	farcall Tilemap_CopyRectAndAttr
	ld a, $40
	farcall Gfx_UploadWinMapBuffers
	ld hl, wSpriteSlot8
	ld de, $7030
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7100
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	ld hl, wSpriteSlot3
	ld de, $6F30
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2F48
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ld a, [wMailScreenMode]
	cp a, $00
	jr nz, .l4A81

	; [PROBABLE] 26 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 49B0-4B95 by apply_coverage --split
	call Mail_OutboxIsEmpty
	inc a
	jr nz, .l4A66
	ld hl, wSpriteSlot4
	ld de, $7020
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock + $01
	ld a, [hli]
	cp a, $00
	jr z, .l4A76
	cp a, $FF
	jr z, .l4A76
.l4A66 ; 27:4A66
	ld hl, wSpriteSlot4
	ld de, $7A60
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
.l4A76 ; 27:4A76
	ld de, $2F58
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	jr .l4AB9

.l4A81 ; 27:4A81
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 49B0-4B95 by apply_coverage
	; --split [executed in 1 scenarios]
	cp a, $01
	jr nz, .l4AA0

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 49B0-4B95 by apply_coverage --split
	ld hl, wSpriteSlot4
	ld de, $7AB0
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2F58
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	jr .l4AB9

.l4AA0 ; 27:4AA0
	; [CONFIRMED] 106 insn(s) executed; cut out of the PROBABLE region 49B0-4B95 by apply_coverage
	; --split [executed in 1 scenarios]
	ld hl, wSpriteSlot3
	ld de, $7AD0
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2F48
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
.l4AB9 ; 27:4AB9
	ld b, $00
.l4ABB ; 27:4ABB
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlot3 + $01]
	dec a
	ld [wSpriteSlot3 + $01], a
	ld a, [wSpriteSlot4 + $01]
	dec a
	ld [wSpriteSlot4 + $01], a
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_WaitAndService
	pop bc
	ld a, [wSpriteSlot3 + $01]
	cp a, $47
	jr nz, .l4ABB
	ld b, $3C
.l4AE5 ; 27:4AE5
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	ldh a, [rSCX]
	dec a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_FrameTick
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	pop bc
	dec b
	jr nz, .l4AE5
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0045
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld de, $71D0
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	ld bc, $0514
	ld de, wScreenTileMap
	ld hl, MailDisconnect_WinMsg_Ended
	ld a, $27
	farcall Tilemap_CopyRectAndAttr
	ld a, $40
	farcall Gfx_UploadWinMapBuffers
.l4B43 ; 27:4B43
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlot3 + $01]
	dec a
	ld [wSpriteSlot3 + $01], a
	ld a, [wSpriteSlot4 + $01]
	dec a
	ld [wSpriteSlot4 + $01], a
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	ldh a, [rSCX]
	dec a
	ldh [rSCX], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_FrameTick
	pop af
	ldh [rSVBK], a
	farcall Joypad_Update
	pop bc
	ld a, [wSpriteSlot3 + $01]
	cp a, $D0
	jr nz, .l4B43
	farcall Palette_FadeOutToWhite
	ld a, $D0
	ldh [rWY], a
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	xor a, a
	ret

MailConnect_InitScreen:: ; 27:4B95
Function_27_4B95::
	; [CONFIRMED] 122 insn(s); 122 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push af
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall LCDOff
	pop af
	pop bc
	push bc
	push af
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, MailScreens_ObjPalette_7520
	ld a, $27
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, MailConnect_BgPalette
	ld a, $27
	farcall Palette_LoadToBuffer
	ld de, $8001
	ld hl, MailConnect_Tiles_5060
	ld a, $27
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8401
	ld hl, MailConnect_Tiles_5460
	ld a, $27
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8800
	ld hl, MailConnect_Tiles_5E60
	ld a, $27
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C00
	ld hl, MailConnect_Tiles_6260
	ld a, $27
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9000
	ld hl, MailConnect_Tiles_6660
	ld a, $27
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, MailConnect_Tiles_5860
	ld a, $27
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, MailConnect_Tiles_5C60
	ld a, $27
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ld de, $8000
	ld hl, MailConnect_Tiles_6860
	ld a, $27
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8400
	ld hl, MailConnect_Tiles_6C60
	ld a, $27
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $1220
	ld de, wScreenTileMap
	ld hl, MailConnect_Tilemap
	ld a, $27
	farcall Tilemap_CopyRectAndAttr
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, MailScreens_ObjPalette_7520
	ld a, $27
	farcall Palette_LoadToBuffer
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	pop af
	dec a
	jr z, .l4CAF
	ld bc, $0514
	ld de, wScreenTileMap
	ld hl, MailConnect_WinMsg_Connecting
	ld a, $27
	farcall Tilemap_CopyRectAndAttr
	jr .l4CC0
.l4CAF ; 27:4CAF
	ld bc, $0514
	ld de, wScreenTileMap
	ld hl, MailDisconnect_WinMsg_Ending
	ld a, $27
	farcall Tilemap_CopyRectAndAttr
.l4CC0 ; 27:4CC0
	ld a, $40
	farcall Gfx_UploadWinMapBuffers
	ld hl, wSpriteSlot1
	ld de, MailConnect_ObjTable
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1800
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld hl, wSpriteSlot2
	ld de, $7A20
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1888
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	di
	farcall Sprite_UpdateAll
	ei
	pop bc
	jp .l4D31

	; [PROBABLE] 9 insn(s): function prologue (ldh [$FFF2],a ; ldh a,[$FF8D] ; push af ; ... ld a,7
	; ; ldh [$FF8D],a ; ldh [$FF70],a ; call $047A ; ld hl,$D800) falling into the code at 4D19;
	; well-formed instruction chain (clean decode, all direct targets land on instruction starts,
	; lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call VBlank_WaitStartDI
	ld hl, wPaletteBufBg

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: site x10; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers

.l4D31 ; 27:4D31
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 4/18 scenarios)
	ld a, $70
	ldh [rWY], a
	farcall LCDOn
	ldh a, [rLCDC]
	or a, $64
	ldh [rLCDC], a
	call VBlank_Wait
	farcall Palette_FadeInFromWhite
	ld bc, $0000
	ret

	; [PROBABLE] 1 insn (call $4D81) falling into the code at 4D51; well-formed instruction chain
	; (clean decode, all direct targets land on instruction starts, lands exactly on the next code
	; region); no direct caller/table entry found: entry HYPOTHESIS
	call CommTime_DrawHMSScreen

.loop ; 27:4D51
	; [PROBABLE] 18 insn(s) reached by static flow only; seeds: site x18; min discovery hops 0;
	; entered by jr from 27:4D7F (PROBABLE code)
	push bc
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .l4D70
	farcall Palette_FadeOutToWhite
	xor a, a
	ret
.l4D70 ; 27:4D70
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l4D7F
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret
.l4D7F ; 27:4D7F
	jr .loop

CommTime_DrawHMSScreen:: ; 27:4D81
	; [PROBABLE] 5 insn(s) (xor a ; ldh [$FF43],a ; push de ; push bc ; push af) falling into the
	; code at 4D87; entered by call $4D81 from 27:4D4E (this classification)
	xor a, a
	ldh [rSCX], a
	push de
	push bc
	push af

	; [PROBABLE] 128 insn(s) reached by static flow only; seeds: site x128; min discovery hops 0;
	; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall LCDOff
	pop af
	pop bc
	pop de
	push de
	push bc
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_CommTimeHMS_Bg
	ld a, $29
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, MailScreens_ObjPalette_7520
	ld a, $27
	farcall Palette_LoadToBuffer
	ld de, $9001
	ld hl, Gfx_CommTimeHMS_Tiles9000Vb1
	ld a, $29
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_CommTimeHMS_Screen
	ld a, $29
	farcall Tilemap_CopyRectAndAttr
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call VBlank_WaitStartDI
	ld hl, wPaletteBufBg
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
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

Function_27_4EC0:: ; 27:4EC0
	; [PROBABLE] 9 insn(s): same prologue as 27:4D06 (WRAM7 switch, call $047A, ld hl,$D800) falling
	; into the code at 4ED3; well-formed instruction chain (clean decode, all direct targets land on
	; instruction starts, lands exactly on the next code region); no direct caller/table entry
	; found: entry HYPOTHESIS
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call VBlank_WaitStartDI
	ld hl, wPaletteBufBg

	; [PROBABLE] 13 insn(s) reached by static flow only; seeds: site x13; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers

Label_27_4EEB:: ; 27:4EEB
	farcall LCDOn
	ld bc, $0000
	ret

	; [PROBABLE] 11 insn(s) (call $05BD ; ldh a,[rLCDC] ; and $9F ; ldh [rLCDC],a ; xor a ; ldh
	; [rSCX],a ; ldh [rSCY],a ; ld a,7 ; ldh [rOBP...],a ; ld a,$90 ; ldh [rWY],a) falling into the
	; code at 4F0B; well-formed instruction chain (clean decode, all direct targets land on
	; instruction starts, lands exactly on the next code region); no direct caller/table entry
	; found: entry HYPOTHESIS
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

	; [PROBABLE] 72 insn(s) reached by static flow only; seeds: site x72; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_ResetAll
	ld de, $9001
	ld hl, Gfx_CommTime_SummaryB_Tiles9000Vb1
	ld a, $51
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_CommTime_SummaryB_Tiles9400Vb1
	ld a, $51
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_CommTime_SummaryB
	ld a, $51
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_CommTime_SummaryB
	ld a, $51
	farcall Tilemap_CopyRectAndAttr
	ld a, [wTimerAFrames]
	ldh [hRam_FFB0], a
	ld a, [wTimerASeconds]
	ldh [hRam_FFB1], a
	ld a, [wTimerAMinutes]
	ldh [hRam_FFB2], a
	ld a, [wTimerAExtra]
	ldh [hRam_FFB3], a
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, wScreenTileMap + $164
	ldh a, [hRam_FFB2]
	ld l, a
	ld h, $00
	sub a, $3C
	jr c, .skip
	ld hl, $003B
	ld a, $3B
	ldh [hRam_FFB1], a
.skip ; 27:4F84
	xor a, a
	ldh [hRam_FFB4], a
	ld bc, $FF9C
	call CommTime_DrawNumber_27_4FFB
	ld bc, $FFF6
	call CommTime_DrawNumber_27_4FFB
	ld a, l
	call CommTime_PutDigit_27_5021
	ld de, wScreenTileMap + $169
	ldh a, [hRam_FFB1]
	ld l, a
	ld h, $00
	xor a, a
	ldh [hRam_FFB4], a
	ld bc, $FFF6
	call CommTime_DrawNumber_27_4FFB
	ld a, l
	call CommTime_PutDigit_27_5021
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	farcall Sprite_UpdateAll
	farcall Palette_FadeInFromWhite
	xor a, a
	ldh [hDialogResult], a

CommTime_Summary_FrameLoop_27_4FC0:: ; 27:4FC0
Label_27_4FC0::
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $4FD8-$4FE2 (10 bytes) [PROBABLE] inline table of `call $056A` (JoypadDispatch) at 27:4FD5: 5 entries; fixed length (5 words) by the routine

Table_27_4FD8:: ; 27:4FD8
	dw CommTime_SummaryInput_ButtonA_27_4FE2
	dw CommTime_SummaryInput_IgnoreB_27_4FE5
	dw CommTime_SummaryInput_IgnoreSelect_27_4FE8
	dw CommTime_SummaryInput_IgnoreStart_27_4FEB
	dw CommTime_Summary_FrameLoop_27_4FC0

CommTime_SummaryInput_ButtonA_27_4FE2:: ; 27:4FE2
Label_27_4FE2::
	; [PROBABLE] 63 insn(s) reached by static flow only; seeds: site x63; min discovery hops 0;
	; entered by table from 27:4FD5 (PROBABLE code)
	jp CommTime_Summary_Close_27_4FEE

CommTime_SummaryInput_IgnoreB_27_4FE5:: ; 27:4FE5
Label_27_4FE5::
	jp CommTime_Summary_FrameLoop_27_4FC0

CommTime_SummaryInput_IgnoreSelect_27_4FE8:: ; 27:4FE8
Label_27_4FE8::
	jp CommTime_Summary_FrameLoop_27_4FC0

CommTime_SummaryInput_IgnoreStart_27_4FEB:: ; 27:4FEB
Label_27_4FEB::
	jp CommTime_Summary_FrameLoop_27_4FC0

CommTime_Summary_Close_27_4FEE:: ; 27:4FEE
Label_27_4FEE::
	farcall Palette_FadeOutToWhite
	farcall Sprite_ResetAll
	ret

CommTime_DrawNumber_27_4FFB:: ; 27:4FFB
Function_27_4FFB::
	inc a
	add hl, bc
	bit 7, h
	jr z, CommTime_DrawNumber_27_4FFB
	dec a
	jr nz, .l500B
	ldh a, [hRam_FFB4]
	or a, a
	jr z, .l5016
	ld a, $00
.l500B ; 27:500B
	push bc
	push hl
	call CommTime_PutDigit_27_5021
	pop hl
	pop bc
	ld a, $FF
	ldh [hRam_FFB4], a
.l5016 ; 27:5016
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

CommTime_PutDigit_27_5021:: ; 27:5021
Function_27_5021::
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

Table_CommTime_DigitTiles_27_5048:: ; 27:5048
Data_27_5048::
	db $67, $77, $68, $78, $69, $79, $69, $6F, $6A, $7A, $6B, $7B, $6C, $7C, $6D, $7D
	db $6E, $7E, $6E, $7F

; ---- zero $505C-$5060 (4 bytes) [PROBABLE] 4 zero bytes: row padding (20 + 4 = 24) before the aligned tile block at 27:5060
	ds $4, $00
