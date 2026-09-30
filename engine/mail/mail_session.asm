; engine/mail/mail_session.asm
; bank 26, $4000-$5067 (4199 bytes); pinned by layout.link
; mail transfer session runner and time-warning checks

SECTION "engine/mail/mail_session", ROMX

MailSession_Run:: ; 26:4000
Function_26_4000::
	; [CONFIRMED] 27 insn(s); 27 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D637
	xor a, a
	ld [de], a
	xor a, a
	ld [wMailScreenMode], a
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
	call MailSession_InitScreen
	farcall Mail_OutboxIsEmpty
	inc a
	jp z, .l4043

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jpcc at 26:4039 (executed) [executed in 5 scenarios]
	ld a, $40
	call MailSession_ShowMsgSending
	jr .l4048

.l4043 ; 26:4043
	; [CONFIRMED] 27 insn(s); 27 executed (in up to 1/18 scenarios)
	ld a, $40
	call MailSession_ShowMsgReceiving
.l4048 ; 26:4048
	ld hl, $DA80
	ld de, $7030
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7100
	ld hl, $DA80
	call Sprite_SetPosition
	ld hl, $DA30
	ld de, $7A30
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $28E0
	ld hl, $DA30
	call Sprite_SetPosition
	farcall Mail_OutboxIsEmpty
	inc a
	jr nz, .l4095
	ld hl, $DA40
	ld de, $7A40
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	jr .l40A5

.l4095 ; 26:4095
	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1;
	; entered by jrcc from 26:4081 (executed) [executed in 5 scenarios]
	ld hl, $DA40
	ld de, $7A50
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot

.l40A5 ; 26:40A5
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 1/18 scenarios)
	ld de, $28D1
	ld hl, $DA40
	call Sprite_SetPosition
	ld b, $00
.loop ; 26:40B0
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
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l40E8

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 26:40DE (executed) [executed in 2 scenarios]
	ld b, $01
	ld a, [wMailScreenMode]
	jp MailSession_Cancel

.l40E8 ; 26:40E8
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 1/18 scenarios)
	ld a, [wSpriteSlots + 49]
	cp a, $3F
	jr z, .l40F3
	cp a, $40
	jr nz, .loop
.l40F3 ; 26:40F3
	push bc
	ld hl, $DA30
	ld de, MailSession_ObjTable_6F20
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2840
	ld hl, $DA30
	call Sprite_SetPosition
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	farcall Mail_OutboxIsEmpty
	inc a
	jp z, MailSession_ReceivePhase

MailSession_SendPhase:: ; 26:412C
	; [CONFIRMED] 289 insn(s) reached by static flow only; seeds: exec x289; min discovery hops 0;
	; fall-through of the jpcc at 26:4129 (executed) | 288 insn(s) executed; cut out of the PROBABLE
	; region 412C-443B by apply_coverage --split [executed in 1 scenarios]
	farcall Timer_ResetClockB
	farcall Smtp_StartHelo
.l4138 ; 26:4138
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	farcall Smtp_HeloPoll
	cp a, $01
	jr z, .l4138
	cp a, $FF
	jr nz, .l4163
.l4163 ; 26:4163
	ld hl, $DA50
	ld de, $6F70
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $28D0
	ld hl, $DA50
	call Sprite_SetPosition
.l417C ; 26:417C
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlots + 81]
	dec a
	ld [wSpriteSlots + 81], a
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	ld a, [wSpriteSlots + 81]
	cp a, $58
	jr z, .l41B1
	cp a, $57
	jr nz, .l417C
.l41B1 ; 26:41B1
	ld hl, $DA50
	ld de, $6F90
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2857
	ld hl, $DA50
	call Sprite_SetPosition
	ld c, $0F
.l41CC ; 26:41CC
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	dec c
	jr nz, .l41CC
	ld hl, $DA30
	ld de, $6F40
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld de, $2840
	ld hl, $DA30
	call Sprite_SetPosition
	ld hl, $DA50
	ld de, $6F80
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld de, $2857
	ld hl, $DA50
	call Sprite_SetPosition
	ld hl, $DA40
	ld de, $7A40
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2830
	ld hl, $DA40
	call Sprite_SetPosition
	ld c, $14
.l4239 ; 26:4239
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	dec c
	jr nz, .l4239
	ld hl, $DA60
	ld de, $6FD0
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $234B
	ld hl, $DA60
	call Sprite_SetPosition
	di
	farcall Sprite_UpdateAll
	ei
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
	ld a, $02
	ld [hli], a
	farcall Timer_ResetClockB
	farcall Smtp_StartMailFrom
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0043
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
.l42A6 ; 26:42A6
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	farcall Joypad_Update
	call MailSession_UpdateTimerDisplay
	farcall Smtp_DataPoll
	cp a, $FF
	jr z, .l42D6
	push af
	ldh a, [hJoyHeld]
	and a, $02
	jr z, .l42CF
	pop af
	jp MailSession_Cancel
.l42CF ; 26:42CF
	pop af
	cp a, $01
	jr z, .l42A6
	jr .l4308
.l42D6 ; 26:42D6
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
	ld a, $FF
	ld [hli], a
	farcall Timer_ResetClockB
	farcall Smtp_StartQuit
	call MailSession_ShowCommErrorNoWindow
	ld a, [wMobileResultCode]
	cp a, $26
	jr z, .l42FC
	cp a, $30
	jr nz, .l4305
.l42FC ; 26:42FC
	call MailSession_InitScreen
	call MailSession_ShowMsgReceiving
	jp MailSession_ReceivePhase
.l4305 ; 26:4305
	ld a, $80
	ret
.l4308 ; 26:4308
	farcall Timer_ResetClockB
	farcall Smtp_StartQuit
.l4314 ; 26:4314
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	farcall Smtp_QuitPoll
	cp a, $01
	jr z, .l4314
	farcall MailDraft_Clear
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
	ld a, $01
	ld [hli], a
	ld c, $3C
.l434F ; 26:434F
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	dec c
	jr nz, .l434F
	ld hl, $DA30
	ld de, MailSession_ObjTable_6F20
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2840
	ld hl, $DA30
	call Sprite_SetPosition
	ld hl, $DA50
	ld de, $6FA0
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld de, $2857
	ld hl, $DA50
	call Sprite_SetPosition
	ld hl, $DA60
	ld de, $6FD0
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2257
	ld hl, $DA60
	call Sprite_SetPosition
	ld c, $3C
.l43BC ; 26:43BC
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	dec c
	jr nz, .l43BC
	ld hl, $DA50
	ld de, $7AE0
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2857
	ld hl, $DA50
	call Sprite_SetPosition
	ld de, $1FE0
	ld hl, $DA60
	call Sprite_SetPosition
.l43FE ; 26:43FE
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlots + 81]
	inc a
	ld [wSpriteSlots + 81], a
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	ld a, [wSpriteSlots + 81]
	cp a, $D1
	jr z, .l4433
	cp a, $D0
	jr nz, .l43FE
.l4433 ; 26:4433
	call MailSession_CheckTimeWarning
	inc a
	jp nz, MailSession_ReceivePhase

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 412C-443B by apply_coverage --split
	ret

	; [PROBABLE] head of an object-init sequence: ld hl,$DA50 / ld de,$7A70 / ld a,$27 / ld b,$81,
	; decode chain falls through exactly into the site-validated far call at 4445 (`call $06D1`,
	; inline 0A82:00 = init_object_from_table); previous byte is a ret; entry unproven (no
	; call/jp/far-pointer/word reference found)
	ld hl, $DA50
	ld de, $7A70
	ld a, $27
	ld b, $81

	; [PROBABLE] 67 insn(s) reached by static flow only; seeds: site x67; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	ld de, $2847
	ld hl, $DA50
	call Sprite_SetPosition
	ld b, $3C
.l4456 ; 26:4456
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	pop bc
	dec b
	jr nz, .l4456
	ld de, $28E0
	ld hl, $DA50
	call Sprite_SetPosition
	ld hl, $DA40
	ld de, $7A40
	ld a, $27
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2857
	ld hl, $DA40
	call Sprite_SetPosition
.l448B ; 26:448B
	ldh a, [rSCX]
	dec a
	ldh [rSCX], a
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .l448B
.l44AC ; 26:44AC
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
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ld a, [wSpriteSlots + 49]
	cp a, $C0
	jr nz, .l44AC
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	ld a, $FF
	ret

MailSession_ReceivePhase:: ; 26:44F5
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)
	call MailSession_ClearMsg
	ld hl, $DA30
	ld de, $733B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, $DA30
	call Sprite_SetPosition
	farcall Mail_OutboxIsEmpty
	inc a
	jp z, .l4536

	; [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0;
	; fall-through of the jpcc at 26:4518 (executed) [executed in 1 scenarios]
	ld hl, $DA40
	ld de, $73DB
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2700
	ld hl, $DA40
	call Sprite_SetPosition
	jr .l454F

.l4536 ; 26:4536
	; [CONFIRMED] 33 insn(s); 33 executed (in up to 1/18 scenarios)
	ld hl, $DA40
	ld de, $73BB
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, $DA40
	call Sprite_SetPosition
.l454F ; 26:454F
	ld hl, $DA50
	ld de, $73AB
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $0050
	ld hl, $DA50
	call Sprite_SetPosition
	call MailSession_ShowMsgReceiving
	farcall Timer_ResetClockB
	farcall Pop3_StartLogin
.loop ; 26:4577
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	farcall Pop3_LoginStatPoll
	cp a, $01
	jr z, .loop
	cp a, $FF
	jr nz, .l45AE

	; [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0;
	; fall-through of the jrcc at 26:459E (executed) [executed in 1 scenarios]
	call MailSession_ShowCommError
	ld a, b
	cp a, $31
	jr nz, .l45AB
	ld a, $7F
	ret
.l45AB ; 26:45AB
	ld a, $7F
	ret

.l45AE ; 26:45AE
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)
	ld d, h
	ld e, l
	push de
	ld a, d
	or a, e
	jp z, Label_26_4636

	; [CONFIRMED] 72 insn(s) reached by static flow only; seeds: exec x72; min discovery hops 0;
	; fall-through of the jpcc at 26:45B3 (executed) | 9 insn(s) executed; cut out of the PROBABLE
	; region 45B6-4636 by apply_coverage --split [executed in 10 scenarios]
	ld bc, $0000
	ld hl, $0001

MailSession_ScanMailsLoop:: ; 26:45BC
	push bc
	push hl
	call MailSession_CheckTimeWarningRecv
	pop hl
	pop bc
	inc a
	jr nz, .l45C8

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 45B6-4636 by apply_coverage --split
	pop de
	ret

.l45C8 ; 26:45C8
	; [CONFIRMED] 53 insn(s) executed; cut out of the PROBABLE region 45B6-4636 by apply_coverage
	; --split [executed in 2 scenarios]
	push bc
	push de
	push hl
	ld c, $00
	farcall Timer_ResetClockB
	ld a, $FF
	farcall Pop3_StartTop
	pop hl
	pop de
	pop bc
.loop ; 26:45DE
	push bc
	push de
	push hl
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop hl
	pop de
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jr z, .l4602
	pop de
	jp MailSession_Cancel
.l4602 ; 26:4602
	push bc
	push de
	push hl
	ld a, $FF
	farcall Pop3_TopPoll
	cp a, $01
	jr nz, .l4616
	pop hl
	pop de
	pop bc
	jr .loop
.l4616 ; 26:4616
	cp a, $FF
	jr nz, .l4624
	pop hl
	pop de
	pop bc
	call MailSession_ShowCommError
	pop de
	ld a, $80
	ret
.l4624 ; 26:4624
	ld a, b
	pop hl
	pop de
	pop bc
	cp a, $02
	jr nz, .skip

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 45B6-4636 by apply_coverage --split
	inc bc

.skip ; 26:462D
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 45B6-4636 by apply_coverage
	; --split [executed in 8 scenarios]
	inc hl
	dec de
	ld a, d
	or a, e
	jp nz, MailSession_ScanMailsLoop
	ld e, c
	ld d, b

Label_26_4636:: ; 26:4636
	; [CONFIRMED] 104 insn(s); 104 executed (in up to 1/18 scenarios)
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
	call MailSession_CheckTimeWarning
	inc a
	ret z
.l465E ; 26:465E
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlots + 81]
	dec a
	ld [wSpriteSlots + 81], a
	call VBlank_Wait
	di
	farcall Sprite_UpdateAll
	ei
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSpriteSlots + 81]
	cp a, $01
	jr z, .l4699
	cp a, $00
	jr nz, .l465E
.l4699 ; 26:4699
	ld hl, $DA50
	ld de, $739B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $0100
	ld hl, $DA50
	call Sprite_SetPosition
	ld c, $1E
.l46B4 ; 26:46B4
	call MailSession_PollAdapterError
	jp z, MailSession_ShowCommError
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	dec c
	jr nz, .l46B4
	call MailSession_ClearMsg
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
	ld e, l
	ld d, h
	ld a, d
	or a, e
	jp z, MailSession_NoMailOrFull

	; [CONFIRMED] 438 insn(s) reached by static flow only; seeds: exec x438; min discovery hops 4;
	; fall-through of the jpcc at 26:4702 (executed) | 118 insn(s) executed; cut out of the PROBABLE
	; region 4705-4A8A by apply_coverage --split [executed in 1 scenarios]
	push de
	di
	farcall Mailbox_CountRecords
	ei
	ld a, d
	pop de
	cp a, $0C
	jp z, MailSession_NoMailOrFull
	ld hl, $0000
	ld bc, $0000

MailSession_ReceiveMailsLoop:: ; 26:471B
	push bc
	push de
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D625
	ld a, c
	ld [de], a
	inc de
	ld a, b
	xor a, a
	ld [de], a
	inc de
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	inc de
	pop hl
	pop de
	pop bc
	call Function_26_5106
	dec a
	jp z, .l49FF
	call MailSession_CheckTimeWarning
	inc a
	ret z
	push bc
	push de
	push hl
	ld hl, $DA30
	ld de, MailSession_ObjTable_72FB
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $0100
	ld hl, $DA30
	call Sprite_SetPosition
	call MailSession_SetReceivedCountSprite
	ld de, $0000
	ld hl, $DA40
	call Sprite_SetPosition
	ld hl, $DA50
	ld de, $739B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $0100
	ld hl, $DA50
	call Sprite_SetPosition
	pop hl
	pop de
	pop bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push hl
	ld hl, $D629
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	pop hl
	push hl
	inc hl
	call MailSession_DrawMailCounts
	pop hl
	inc hl
	push de
	push bc
	push hl
	push bc
	push de
	push hl
	ld c, $00
	farcall Timer_ResetClockB
	ld a, $FF
	farcall Pop3_StartTop
	pop hl
	pop de
	pop bc
.l47B6 ; 26:47B6
	push bc
	push de
	push hl
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop hl
	pop de
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jr z, .l47DC
	pop hl
	pop de
	pop bc
	jp MailSession_Cancel
.l47DC ; 26:47DC
	ld a, $FF
	farcall Pop3_TopPoll
	cp a, $01
	jr z, .l47B6
	cp a, $FF
	jr nz, .l47F5

	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4705-4A8A by apply_coverage --split
	pop hl
	pop de
	pop bc
	call MailSession_ShowCommError
	ld a, $80
	ret

.l47F5 ; 26:47F5
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4705-4A8A by apply_coverage
	; --split [executed in 7 scenarios]
	ld a, b
	pop hl
	pop bc
	dec a
	jp z, .l493D
	dec a
	jp nz, .l4819

	; [PROBABLE] 18 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4705-4A8A by apply_coverage --split
	push bc
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
	pop bc
	jp .l493D

.l4819 ; 26:4819
	; [CONFIRMED] 61 insn(s) executed; cut out of the PROBABLE region 4705-4A8A by apply_coverage
	; --split [executed in 7 scenarios]
	inc bc
	push bc
	push de
	push hl
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $003C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld hl, $DA30
	ld de, $734B
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, $DA30
	call Sprite_SetPosition
	ld hl, $DA50
	ld de, $737B
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, $DA50
	call Sprite_SetPosition
	call MailSession_SetNextReceivedCountSprite
	ld de, $0700
	ld hl, $DA60
	call Sprite_SetPosition
	ld c, $3C
	ld c, $04
.l486F ; 26:486F
	call MailSession_PollAdapterError
	jp z, MailSession_ShowCommError
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSpriteSlots + 96]
	dec a
	ld [wSpriteSlots + 96], a
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jr z, .l48BB

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4705-4A8A by apply_coverage --split
	pop hl
	pop de
	pop bc
	pop de
	jp MailSession_Cancel

.l48BB ; 26:48BB
	; [CONFIRMED] 82 insn(s) executed; cut out of the PROBABLE region 4705-4A8A by apply_coverage
	; --split [executed in 1 scenarios]
	dec c
	jp nz, .l486F
	pop hl
	pop de
	pop bc
	push bc
	push hl
	farcall Timer_ResetClockB
	ld a, $FF
	farcall Pop3_StartRetr
.l48D2 ; 26:48D2
	push bc
	push de
	push hl
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop hl
	pop de
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jr z, .l48F8
	pop hl
	pop bc
	pop de
	jp MailSession_Cancel
.l48F8 ; 26:48F8
	ld a, $FF
	farcall Pop3_RetrPoll
	cp a, $01
	jr z, .l48D2
	cp a, $FF
	jr nz, .l4911
	pop hl
	pop bc
	pop de
	call MailSession_ShowCommError
	ld a, $80
	ret
.l4911 ; 26:4911
	ld de, $0080
	ld hl, $DA60
	call Sprite_SetPosition
	pop hl
	pop bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push hl
	ld hl, $D625
	ld a, c
	ld [hli], a
	ld a, b
	xor a, a
	ld [hli], a
	pop hl
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailCountAtStart]
	add a, c
	cp a, $0C
	jp z, .l49FF
	push de
.l493D ; 26:493D
	pop de
	push bc
	push de
	push hl
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l4987
	ld hl, $C26F
	bit 0, [hl]
	jr nz, .l4988
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l4987

	; [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4705-4A8A by apply_coverage --split
	jr nz, .l4963
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l4987
.l4963 ; 26:4963
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, .l4973
	ld hl, $C26F
	bit 1, [hl]
	jr nz, .l4987
	set 1, [hl]
.l4973 ; 26:4973
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, .l4988
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l4988

.l4987 ; 26:4987
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 4705-4A8A by apply_coverage
	; --split [executed in 5 scenarios]
	xor a, a
.l4988 ; 26:4988
	pop hl
	cp a, $00
	jr z, .l49F2

	; [PROBABLE] 46 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4705-4A8A by apply_coverage --split
	farcall Sprites_SaveSlotsToBank3
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	farcall CommNotice_ShowDialogMode1
	inc a
	jr z, .l49C2
	call MailSession_InitScreen
	farcall Sprites_RestoreSlotsFromBank3
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	jp .l49F2
.l49C2 ; 26:49C2
	ld a, [wTimerEnable]
	bit 4, a
	jp z, .l49D0
	ld a, $00
	ld b, $00
	jr .l49D4
.l49D0 ; 26:49D0
	ld a, $00
	ld b, $00
.l49D4 ; 26:49D4
	pop hl
	pop de
	pop bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push hl
	push de
	ld d, h
	ld e, l
	ld hl, $D625
	ld a, c
	ld [hli], a
	ld a, b
	xor a, a
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	pop de
	pop hl
	ld a, $7F
	ret

.l49F2 ; 26:49F2
	; [CONFIRMED] 70 insn(s) executed; cut out of the PROBABLE region 4705-4A8A by apply_coverage
	; --split [executed in 2 scenarios]
	pop hl
	pop de
	pop bc
	ld a, h
	cp a, d
	jp nz, MailSession_ReceiveMailsLoop
	ld a, l
	cp a, e
	jp nz, MailSession_ReceiveMailsLoop
.l49FF ; 26:49FF
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push hl
	push de
	ld d, h
	ld e, l
	ld hl, $D625
	ld a, c
	ld [hli], a
	ld a, b
	xor a, a
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	pop de
	pop hl
	ld a, b
	or a, c
	jr nz, .l4A1E
	jp MailSession_NoMailOrFull
.l4A1E ; 26:4A1E
	call MailSession_ShowMsgReceived
	ld hl, $DA30
	ld de, $735B
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, $DA30
	call Sprite_SetPosition
	call MailSession_SetReceivedCountSprite
	ld de, $0000
	ld hl, $DA40
	call Sprite_SetPosition
	ld hl, $DA50
	ld de, $736B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, $DA50
	call Sprite_SetPosition
	ld c, $3C
.l4A61 ; 26:4A61
	call MailSession_PollAdapterError
	jp z, MailSession_ShowCommError
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	dec c
	jr nz, .l4A61
	jp MailSession_Finish

MailSession_NoMailOrFull:: ; 26:4A8A
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 1/18 scenarios)
	push de
	di
	farcall Mailbox_CountRecords
	ei
	ld a, d
	pop de
	cp a, $0C
	jr nz, .l4A9E

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 26:4A97 (executed)
	call MailSession_ShowMsgCannotReceive
	jr .l4AA1

.l4A9E ; 26:4A9E
	; [CONFIRMED] 125 insn(s); 125 executed (in up to 1/18 scenarios)
	call MailSession_ShowMsgNoMail
.l4AA1 ; 26:4AA1
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0042
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld hl, $DA30
	ld de, $734B
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, $DA30
	call Sprite_SetPosition
	ld hl, $DA50
	ld de, $737B
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, $DA50
	call Sprite_SetPosition
	ld hl, $DA60
	ld de, $73FB
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1000
	ld hl, $DA60
	call Sprite_SetPosition
	ld c, $09
.loop ; 26:4B02
	call MailSession_PollAdapterError
	jp z, MailSession_ShowCommError
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSpriteSlots + 96]
	dec a
	ld [wSpriteSlots + 96], a
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	dec c
	jr nz, .loop
	ld de, $0080
	ld hl, $DA60
	call Sprite_SetPosition

MailSession_Finish:: ; 26:4B54
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $003D
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld hl, $DA30
	ld de, $732B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, $DA30
	call Sprite_SetPosition
	ld hl, $DA50
	ld de, $738B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, $DA50
	call Sprite_SetPosition
.l4B9A ; 26:4B9A
	call MailSession_PollAdapterError
	jp z, MailSession_ShowCommError
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlots + 49]
	dec a
	ld [wSpriteSlots + 49], a
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	ld a, [wSpriteSlots + 49]
	cp a, $E1
	jr z, .l4BD5
	cp a, $E0
	jr nz, .l4B9A
.l4BD5 ; 26:4BD5
	farcall Mail_OutboxIsEmpty
	inc a
	jp z, .l4BF1

	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jpcc at 26:4BDC (executed) [executed in 1 scenarios]
	ld hl, $DA40
	ld de, $73EB
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	jr .l4C01

.l4BF1 ; 26:4BF1
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)
	ld hl, $DA40
	ld de, $73CB
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
.l4C01 ; 26:4C01
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D625
	ld a, [hli]
	cp a, $00
	jr z, .l4C1F

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 26:4C0D (executed) [executed in 2 scenarios]
	ld hl, $DA40
	ld de, $73EB
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot

.l4C1F ; 26:4C1F
	; [CONFIRMED] 43 insn(s); 43 executed (in up to 1/18 scenarios)
	ld de, $0000
	ld hl, $DA40
	call Sprite_SetPosition
	ld hl, $DA50
	ld de, $738B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, $DA50
	call Sprite_SetPosition
.l4C41 ; 26:4C41
	call MailSession_PollAdapterError
	jp z, MailSession_ShowCommError
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
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	ld a, [wSpriteSlots + 65]
	cp a, $91
	jr z, .l4C83
	cp a, $90
	jr nz, .l4C41
.l4C83 ; 26:4C83
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

MailSession_SetReceivedCountSprite:: ; 26:4C94
Function_26_4C94::
	; [CONFIRMED] 215 insn(s) reached by static flow only; seeds: exec x215; min discovery hops 5;
	; entered by call from 26:475F (PROBABLE code) | 115 insn(s) executed; cut out of the PROBABLE
	; region 4C94-4EC3 by apply_coverage --split [executed in 1 scenarios]
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D625
	ld a, [hli]
	cp a, $00
	jr nz, .l4CB3
	ld hl, $DA40
	ld de, $73BB
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4CB3 ; 26:4CB3
	cp a, $01
	jr nz, .l4CC8
	ld hl, $DA40
	ld de, $74CB
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4CC8 ; 26:4CC8
	cp a, $02
	jr nz, .l4CDD
	ld hl, $DA40
	ld de, $74DB
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4CDD ; 26:4CDD
	cp a, $03
	jr nz, .l4CF2
	ld hl, $DA40
	ld de, $74EB
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4CF2 ; 26:4CF2
	cp a, $04
	jr nz, .l4D07
	ld hl, $DA40
	ld de, $74FB
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4D07 ; 26:4D07
	cp a, $05
	jr nz, .l4D1C
	ld hl, $DA40
	ld de, $750B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4D1C ; 26:4D1C
	cp a, $06
	jr nz, .l4D31
	ld hl, $DA40
	ld de, $751B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4D31 ; 26:4D31
	cp a, $07
	jr nz, .l4D46
	ld hl, $DA40
	ld de, $752B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4D46 ; 26:4D46
	cp a, $08
	jr nz, .l4D5B
	ld hl, $DA40
	ld de, $753B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4D5B ; 26:4D5B
	cp a, $09
	jr nz, .l4D70
	ld hl, $DA40
	ld de, $754B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4D70 ; 26:4D70
	cp a, $0A
	jr nz, .l4D85
	ld hl, $DA40
	ld de, $755B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4D85 ; 26:4D85
	cp a, $0B
	jr nz, .l4D9A
	ld hl, $DA40
	ld de, $756B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4D9A ; 26:4D9A
	ld hl, $DA40
	ld de, $757B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret

MailSession_SetNextReceivedCountSprite:: ; 26:4DAB
Function_26_4DAB::
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D625
	ld a, [hli]
	inc a
	cp a, $00
	jr nz, .l4DCB

	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C94-4EC3 by apply_coverage --split
	ld hl, $DA60
	ld de, $73FB
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret

.l4DCB ; 26:4DCB
	; [CONFIRMED] 94 insn(s) executed; cut out of the PROBABLE region 4C94-4EC3 by apply_coverage
	; --split [executed in 1 scenarios]
	cp a, $01
	jr nz, .l4DE0
	ld hl, $DA60
	ld de, $740B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4DE0 ; 26:4DE0
	cp a, $02
	jr nz, .l4DF5
	ld hl, $DA60
	ld de, $741B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4DF5 ; 26:4DF5
	cp a, $03
	jr nz, .l4E0A
	ld hl, $DA60
	ld de, $742B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4E0A ; 26:4E0A
	cp a, $04
	jr nz, .l4E1F
	ld hl, $DA60
	ld de, $743B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4E1F ; 26:4E1F
	cp a, $05
	jr nz, .l4E34
	ld hl, $DA60
	ld de, $744B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4E34 ; 26:4E34
	cp a, $06
	jr nz, .l4E49
	ld hl, $DA60
	ld de, $745B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4E49 ; 26:4E49
	cp a, $07
	jr nz, .l4E5E
	ld hl, $DA60
	ld de, $746B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4E5E ; 26:4E5E
	cp a, $08
	jr nz, .l4E73
	ld hl, $DA60
	ld de, $747B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4E73 ; 26:4E73
	cp a, $09
	jr nz, .l4E88
	ld hl, $DA60
	ld de, $748B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4E88 ; 26:4E88
	cp a, $0A
	jr nz, .l4E9D
	ld hl, $DA60
	ld de, $749B
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4E9D ; 26:4E9D
	cp a, $0B
	jr nz, .l4EB2
	ld hl, $DA60
	ld de, $74AB
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret
.l4EB2 ; 26:4EB2
	ld hl, $DA60
	ld de, $74BB
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ret

MailSession_CheckTimeWarning:: ; 26:4EC3
Function_26_4EC3::
	; [CONFIRMED] 16 insn(s); 16 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
	push bc
	push de
	push hl
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l4F0D
	ld hl, $C26F
	bit 0, [hl]
	jr nz, .l4F0E
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l4F0D

	; [PROBABLE] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 0;
	; fall-through of the jrcc at 26:4EDE (executed)
	jr nz, .l4EE9
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l4F0D
.l4EE9 ; 26:4EE9
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, .l4EF9
	ld hl, $C26F
	bit 1, [hl]
	jr nz, .l4F0D
	set 1, [hl]
.l4EF9 ; 26:4EF9
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, .l4F0E
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l4F0E

.l4F0D ; 26:4F0D
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios)
	xor a, a
.l4F0E ; 26:4F0E
	pop hl
	cp a, $00
	jr z, .l4F65

	; [PROBABLE] 28 insn(s) reached by static flow only; seeds: exec x28; min discovery hops 0;
	; fall-through of the jrcc at 26:4F11 (executed)
	farcall Sprites_SaveSlotsToBank3
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	farcall CommNotice_ShowDialogMode1
	inc a
	jr z, .l4F6B
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
	call MailSession_InitScreen
	farcall Sprites_RestoreSlotsFromBank3
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait

.l4F65 ; 26:4F65
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)
	pop hl
	pop de
	pop bc
	pop af
	xor a, a
	ret

.l4F6B ; 26:4F6B
	; [PROBABLE] 110 insn(s) reached by static flow only; seeds: exec x110; min discovery hops 1;
	; entered by jrcc from 26:4F2F (PROBABLE code) | 8 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 4F6B-5062 by apply_coverage --split
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	pop hl
	pop de
	pop bc
	pop af
	ld a, $FF
	ret

MailSession_CheckTimeWarningRecv:: ; 26:4F7B
	; [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 4F6B-5062 by apply_coverage
	; --split [executed in 10 scenarios]
	push af
	push bc
	push de
	push hl
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l4FC5
	ld hl, $C26F
	bit 0, [hl]
	jr nz, .l4FC6
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l4FC5

	; [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4F6B-5062 by apply_coverage --split
	jr nz, .l4FA1
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l4FC5
.l4FA1 ; 26:4FA1
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, .l4FB1
	ld hl, $C26F
	bit 1, [hl]
	jr nz, .l4FC5
	set 1, [hl]
.l4FB1 ; 26:4FB1
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, .l4FC6
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l4FC6

.l4FC5 ; 26:4FC5
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 4F6B-5062 by apply_coverage
	; --split [executed in 10 scenarios]
	xor a, a
.l4FC6 ; 26:4FC6
	pop hl
	cp a, $00
	jr z, .l5026

	; [PROBABLE] 32 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4F6B-5062 by apply_coverage --split
	farcall Sprites_SaveSlotsToBank3
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	farcall CommNotice_ShowDialogMode1
	inc a
	jr z, .l502C
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
	call MailSession_InitScreen
	call MailSession_ShowMsgReceiving
	farcall Sprites_RestoreSlotsFromBank3
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait

.l5026 ; 26:5026
	; [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 4F6B-5062 by apply_coverage
	; --split [executed in 10 scenarios]
	pop hl
	pop de
	pop bc
	pop af
	xor a, a
	ret

.l502C ; 26:502C
	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4F6B-5062 by apply_coverage --split
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	pop hl
	pop de
	pop bc
	pop af
	ld a, $FF
	ret

MailSession_Cancel:: ; 26:503C
	; [CONFIRMED] 15 insn(s) executed; cut out of the PROBABLE region 4F6B-5062 by apply_coverage
	; --split [executed in 6 scenarios]
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D637
	ld a, $01
	ld [de], a
	ld a, $FF
	ld a, $7F
	ret

; ---- data $5062-$5067 (5 bytes) [HYPOTHESIS] UNCLASSIFIED 5 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint) [g4: complete self-contained decode ending in ret with no caller/table/far-pointer reference found, so left unclassified]

Data_26_5062:: ; 26:5062
	db $3E, $FF, $3E, $7F, $C9
