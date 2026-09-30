; engine/mail/mail_session.asm
; bank 26, $4000-$5067 (4199 bytes); pinned by layout.link
; mail transfer session runner and time-warning checks

SECTION "engine/mail/mail_session", ROMX

; ---- code $4000-$403C (60 bytes) [CONFIRMED] 27 insn(s); 27 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

MailSession_Run:: ; 26:4000
Function_26_4000::
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
	jp z, Label_26_4043

; ---- code $403C-$4043 (7 bytes) [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jpcc at 26:4039 (executed) [executed in 5 scenarios]
	ld a, $40
	call MailSession_ShowMsgSending
	jr Label_26_4048

; ---- code $4043-$4095 (82 bytes) [CONFIRMED] 27 insn(s); 27 executed (in up to 1/18 scenarios)

Label_26_4043:: ; 26:4043
	ld a, $40
	call MailSession_ShowMsgReceiving

Label_26_4048:: ; 26:4048
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
	ld de, $28E0
	ld hl, $DA30
	call Function_00_0A65
	farcall Mail_OutboxIsEmpty
	inc a
	jr nz, Label_26_4095
	ld hl, $DA40
	ld de, $7A40
	ld a, $27
	ld b, $81
	farcall Function_00_0A82
	jr Label_26_40A5

; ---- code $4095-$40A5 (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1; entered by jrcc from 26:4081 (executed) [executed in 5 scenarios]

Label_26_4095:: ; 26:4095
	ld hl, $DA40
	ld de, $7A50
	ld a, $27
	ld b, $81
	farcall Function_00_0A82

; ---- code $40A5-$40E0 (59 bytes) [CONFIRMED] 24 insn(s); 24 executed (in up to 1/18 scenarios)

Label_26_40A5:: ; 26:40A5
	ld de, $28D1
	ld hl, $DA40
	call Function_00_0A65
	ld b, $00

Label_26_40B0:: ; 26:40B0
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
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_26_40E8

; ---- code $40E0-$40E8 (8 bytes) [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 26:40DE (executed) [executed in 2 scenarios]
	ld b, $01
	ld a, [wMailScreenMode]
	jp MailSession_Cancel

; ---- code $40E8-$412C (68 bytes) [CONFIRMED] 24 insn(s); 24 executed (in up to 1/18 scenarios)

Label_26_40E8:: ; 26:40E8
	ld a, [wSpriteSlots + 49]
	cp a, $3F
	jr z, Label_26_40F3
	cp a, $40
	jr nz, Label_26_40B0

Label_26_40F3:: ; 26:40F3
	push bc
	ld hl, $DA30
	ld de, MailSession_ObjTable_6F20
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $2840
	ld hl, $DA30
	call Function_00_0A65
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	farcall Mail_OutboxIsEmpty
	inc a
	jp z, MailSession_ReceivePhase

; ---- code $412C-$443A (782 bytes) [CONFIRMED] 289 insn(s) reached by static flow only; seeds: exec x289; min discovery hops 0; fall-through of the jpcc at 26:4129 (executed) | 288 insn(s) executed; cut out of the PROBABLE region 412C-443B by apply_coverage --split [executed in 1 scenarios]

MailSession_SendPhase:: ; 26:412C
	farcall Timer_ResetClockB
	farcall Smtp_StartHelo

Label_26_4138:: ; 26:4138
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	farcall Smtp_HeloPoll
	cp a, $01
	jr z, Label_26_4138
	cp a, $FF
	jr nz, Label_26_4163

Label_26_4163:: ; 26:4163
	ld hl, $DA50
	ld de, $6F70
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $28D0
	ld hl, $DA50
	call Function_00_0A65

Label_26_417C:: ; 26:417C
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlots + 81]
	dec a
	ld [wSpriteSlots + 81], a
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	ld a, [wSpriteSlots + 81]
	cp a, $58
	jr z, Label_26_41B1
	cp a, $57
	jr nz, Label_26_417C

Label_26_41B1:: ; 26:41B1
	ld hl, $DA50
	ld de, $6F90
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $2857
	ld hl, $DA50
	call Function_00_0A65
	ld c, $0F

Label_26_41CC:: ; 26:41CC
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	dec c
	jr nz, Label_26_41CC
	ld hl, $DA30
	ld de, $6F40
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld de, $2840
	ld hl, $DA30
	call Function_00_0A65
	ld hl, $DA50
	ld de, $6F80
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld de, $2857
	ld hl, $DA50
	call Function_00_0A65
	ld hl, $DA40
	ld de, $7A40
	ld a, $27
	ld b, $81
	farcall Function_00_0A82
	ld de, $2830
	ld hl, $DA40
	call Function_00_0A65
	ld c, $14

Label_26_4239:: ; 26:4239
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	dec c
	jr nz, Label_26_4239
	ld hl, $DA60
	ld de, $6FD0
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $234B
	ld hl, $DA60
	call Function_00_0A65
	di
	farcall Function_00_0956
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
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc

Label_26_42A6:: ; 26:42A6
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	farcall Joypad_Update
	call MailSession_UpdateTimerDisplay
	farcall Smtp_DataPoll
	cp a, $FF
	jr z, Label_26_42D6
	push af
	ldh a, [hJoyHeld]
	and a, $02
	jr z, Label_26_42CF
	pop af
	jp MailSession_Cancel

Label_26_42CF:: ; 26:42CF
	pop af
	cp a, $01
	jr z, Label_26_42A6
	jr Label_26_4308

Label_26_42D6:: ; 26:42D6
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
	jr z, Label_26_42FC
	cp a, $30
	jr nz, Label_26_4305

Label_26_42FC:: ; 26:42FC
	call MailSession_InitScreen
	call MailSession_ShowMsgReceiving
	jp MailSession_ReceivePhase

Label_26_4305:: ; 26:4305
	ld a, $80
	ret

Label_26_4308:: ; 26:4308
	farcall Timer_ResetClockB
	farcall Smtp_StartQuit

Label_26_4314:: ; 26:4314
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	farcall Smtp_QuitPoll
	cp a, $01
	jr z, Label_26_4314
	farcall MailDraft_Clear
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
	ld a, $01
	ld [hli], a
	ld c, $3C

Label_26_434F:: ; 26:434F
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	dec c
	jr nz, Label_26_434F
	ld hl, $DA30
	ld de, MailSession_ObjTable_6F20
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $2840
	ld hl, $DA30
	call Function_00_0A65
	ld hl, $DA50
	ld de, $6FA0
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld de, $2857
	ld hl, $DA50
	call Function_00_0A65
	ld hl, $DA60
	ld de, $6FD0
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $2257
	ld hl, $DA60
	call Function_00_0A65
	ld c, $3C

Label_26_43BC:: ; 26:43BC
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	dec c
	jr nz, Label_26_43BC
	ld hl, $DA50
	ld de, $7AE0
	ld a, $27
	ld b, $81
	farcall Function_00_0A82
	ld de, $2857
	ld hl, $DA50
	call Function_00_0A65
	ld de, $1FE0
	ld hl, $DA60
	call Function_00_0A65

Label_26_43FE:: ; 26:43FE
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlots + 81]
	inc a
	ld [wSpriteSlots + 81], a
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	ld a, [wSpriteSlots + 81]
	cp a, $D1
	jr z, Label_26_4433
	cp a, $D0
	jr nz, Label_26_43FE

Label_26_4433:: ; 26:4433
	call MailSession_CheckTimeWarning
	inc a
	jp nz, MailSession_ReceivePhase

; ---- code $443A-$443B (1 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 412C-443B by apply_coverage --split
	ret

; ---- code $443B-$4445 (10 bytes) [PROBABLE] head of an object-init sequence: ld hl,$DA50 / ld de,$7A70 / ld a,$27 / ld b,$81, decode chain falls through exactly into the site-validated far call at 4445 (`call $06D1`, inline 0A82:00 = init_object_from_table); previous byte is a ret; entry unproven (no call/jp/far-pointer/word reference found)
	ld hl, $DA50
	ld de, $7A70
	ld a, $27
	ld b, $81

; ---- code $4445-$44F5 (176 bytes) [PROBABLE] 67 insn(s) reached by static flow only; seeds: site x67; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Function_00_0A82
	ld de, $2847
	ld hl, $DA50
	call Function_00_0A65
	ld b, $3C

Label_26_4456:: ; 26:4456
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	pop bc
	dec b
	jr nz, Label_26_4456
	ld de, $28E0
	ld hl, $DA50
	call Function_00_0A65
	ld hl, $DA40
	ld de, $7A40
	ld a, $27
	ld b, $81
	farcall Function_00_0A82
	ld de, $2857
	ld hl, $DA40
	call Function_00_0A65

Label_26_448B:: ; 26:448B
	ldh a, [rSCX]
	dec a
	ldh [rSCX], a
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_26_448B

Label_26_44AC:: ; 26:44AC
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
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ld a, [wSpriteSlots + 49]
	cp a, $C0
	jr nz, Label_26_44AC
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	ld a, $FF
	ret

; ---- code $44F5-$451B (38 bytes) [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)

MailSession_ReceivePhase:: ; 26:44F5
	call MailSession_ClearMsg
	ld hl, $DA30
	ld de, $733B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DA30
	call Function_00_0A65
	farcall Mail_OutboxIsEmpty
	inc a
	jp z, Label_26_4536

; ---- code $451B-$4536 (27 bytes) [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0; fall-through of the jpcc at 26:4518 (executed) [executed in 1 scenarios]
	ld hl, $DA40
	ld de, $73DB
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $2700
	ld hl, $DA40
	call Function_00_0A65
	jr Label_26_454F

; ---- code $4536-$45A0 (106 bytes) [CONFIRMED] 33 insn(s); 33 executed (in up to 1/18 scenarios)

Label_26_4536:: ; 26:4536
	ld hl, $DA40
	ld de, $73BB
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DA40
	call Function_00_0A65

Label_26_454F:: ; 26:454F
	ld hl, $DA50
	ld de, $73AB
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $0050
	ld hl, $DA50
	call Function_00_0A65
	call MailSession_ShowMsgReceiving
	farcall Timer_ResetClockB
	farcall Pop3_StartLogin

Label_26_4577:: ; 26:4577
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	farcall Pop3_LoginStatPoll
	cp a, $01
	jr z, Label_26_4577
	cp a, $FF
	jr nz, Label_26_45AE

; ---- code $45A0-$45AE (14 bytes) [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0; fall-through of the jrcc at 26:459E (executed) [executed in 1 scenarios]
	call MailSession_ShowCommError
	ld a, b
	cp a, $31
	jr nz, Label_26_45AB
	ld a, $7F
	ret

Label_26_45AB:: ; 26:45AB
	ld a, $7F
	ret

; ---- code $45AE-$45B6 (8 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)

Label_26_45AE:: ; 26:45AE
	ld d, h
	ld e, l
	push de
	ld a, d
	or a, e
	jp z, Label_26_4636

; ---- code $45B6-$45C6 (16 bytes) [CONFIRMED] 72 insn(s) reached by static flow only; seeds: exec x72; min discovery hops 0; fall-through of the jpcc at 26:45B3 (executed) | 9 insn(s) executed; cut out of the PROBABLE region 45B6-4636 by apply_coverage --split [executed in 10 scenarios]
	ld bc, $0000
	ld hl, $0001

MailSession_ScanMailsLoop:: ; 26:45BC
	push bc
	push hl
	call MailSession_CheckTimeWarningRecv
	pop hl
	pop bc
	inc a
	jr nz, Label_26_45C8

; ---- code $45C6-$45C8 (2 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 45B6-4636 by apply_coverage --split
	pop de
	ret

; ---- code $45C8-$462C (100 bytes) [CONFIRMED] 53 insn(s) executed; cut out of the PROBABLE region 45B6-4636 by apply_coverage --split [executed in 2 scenarios]

Label_26_45C8:: ; 26:45C8
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

Label_26_45DE:: ; 26:45DE
	push bc
	push de
	push hl
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop hl
	pop de
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jr z, Label_26_4602
	pop de
	jp MailSession_Cancel

Label_26_4602:: ; 26:4602
	push bc
	push de
	push hl
	ld a, $FF
	farcall Pop3_TopPoll
	cp a, $01
	jr nz, Label_26_4616
	pop hl
	pop de
	pop bc
	jr Label_26_45DE

Label_26_4616:: ; 26:4616
	cp a, $FF
	jr nz, Label_26_4624
	pop hl
	pop de
	pop bc
	call MailSession_ShowCommError
	pop de
	ld a, $80
	ret

Label_26_4624:: ; 26:4624
	ld a, b
	pop hl
	pop de
	pop bc
	cp a, $02
	jr nz, Label_26_462D

; ---- code $462C-$462D (1 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 45B6-4636 by apply_coverage --split
	inc bc

; ---- code $462D-$4636 (9 bytes) [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 45B6-4636 by apply_coverage --split [executed in 8 scenarios]

Label_26_462D:: ; 26:462D
	inc hl
	dec de
	ld a, d
	or a, e
	jp nz, MailSession_ScanMailsLoop
	ld e, c
	ld d, b

; ---- code $4636-$4705 (207 bytes) [CONFIRMED] 104 insn(s); 104 executed (in up to 1/18 scenarios)

Label_26_4636:: ; 26:4636
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

Label_26_465E:: ; 26:465E
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, [wSpriteSlots + 81]
	dec a
	ld [wSpriteSlots + 81], a
	call Function_00_0464
	di
	farcall Function_00_0956
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
	jr z, Label_26_4699
	cp a, $00
	jr nz, Label_26_465E

Label_26_4699:: ; 26:4699
	ld hl, $DA50
	ld de, $739B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $0100
	ld hl, $DA50
	call Function_00_0A65
	ld c, $1E

Label_26_46B4:: ; 26:46B4
	call MailSession_PollAdapterError
	jp z, MailSession_ShowCommError
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	dec c
	jr nz, Label_26_46B4
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

; ---- code $4705-$47EC (231 bytes) [CONFIRMED] 438 insn(s) reached by static flow only; seeds: exec x438; min discovery hops 4; fall-through of the jpcc at 26:4702 (executed) | 118 insn(s) executed; cut out of the PROBABLE region 4705-4A8A by apply_coverage --split [executed in 1 scenarios]
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
	jp z, Label_26_49FF
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
	farcall Function_00_0A82
	ld de, $0100
	ld hl, $DA30
	call Function_00_0A65
	call Function_26_4C94
	ld de, $0000
	ld hl, $DA40
	call Function_00_0A65
	ld hl, $DA50
	ld de, $739B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $0100
	ld hl, $DA50
	call Function_00_0A65
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

Label_26_47B6:: ; 26:47B6
	push bc
	push de
	push hl
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop hl
	pop de
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jr z, Label_26_47DC
	pop hl
	pop de
	pop bc
	jp MailSession_Cancel

Label_26_47DC:: ; 26:47DC
	ld a, $FF
	farcall Pop3_TopPoll
	cp a, $01
	jr z, Label_26_47B6
	cp a, $FF
	jr nz, Label_26_47F5

; ---- code $47EC-$47F5 (9 bytes) [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4705-4A8A by apply_coverage --split
	pop hl
	pop de
	pop bc
	call MailSession_ShowCommError
	ld a, $80
	ret

; ---- code $47F5-$4800 (11 bytes) [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4705-4A8A by apply_coverage --split [executed in 7 scenarios]

Label_26_47F5:: ; 26:47F5
	ld a, b
	pop hl
	pop bc
	dec a
	jp z, Label_26_493D
	dec a
	jp nz, Label_26_4819

; ---- code $4800-$4819 (25 bytes) [PROBABLE] 18 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4705-4A8A by apply_coverage --split
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
	jp Label_26_493D

; ---- code $4819-$48B4 (155 bytes) [CONFIRMED] 61 insn(s) executed; cut out of the PROBABLE region 4705-4A8A by apply_coverage --split [executed in 7 scenarios]

Label_26_4819:: ; 26:4819
	inc bc
	push bc
	push de
	push hl
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $003C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld hl, $DA30
	ld de, $734B
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DA30
	call Function_00_0A65
	ld hl, $DA50
	ld de, $737B
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DA50
	call Function_00_0A65
	call Function_26_4DAB
	ld de, $0700
	ld hl, $DA60
	call Function_00_0A65
	ld c, $3C
	ld c, $04

Label_26_486F:: ; 26:486F
	call MailSession_PollAdapterError
	jp z, MailSession_ShowCommError
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
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
	jr z, Label_26_48BB

; ---- code $48B4-$48BB (7 bytes) [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4705-4A8A by apply_coverage --split
	pop hl
	pop de
	pop bc
	pop de
	jp MailSession_Cancel

; ---- code $48BB-$495A (159 bytes) [CONFIRMED] 82 insn(s) executed; cut out of the PROBABLE region 4705-4A8A by apply_coverage --split [executed in 1 scenarios]

Label_26_48BB:: ; 26:48BB
	dec c
	jp nz, Label_26_486F
	pop hl
	pop de
	pop bc
	push bc
	push hl
	farcall Timer_ResetClockB
	ld a, $FF
	farcall Pop3_StartRetr

Label_26_48D2:: ; 26:48D2
	push bc
	push de
	push hl
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop hl
	pop de
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jr z, Label_26_48F8
	pop hl
	pop bc
	pop de
	jp MailSession_Cancel

Label_26_48F8:: ; 26:48F8
	ld a, $FF
	farcall Pop3_RetrPoll
	cp a, $01
	jr z, Label_26_48D2
	cp a, $FF
	jr nz, Label_26_4911
	pop hl
	pop bc
	pop de
	call MailSession_ShowCommError
	ld a, $80
	ret

Label_26_4911:: ; 26:4911
	ld de, $0080
	ld hl, $DA60
	call Function_00_0A65
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
	jp z, Label_26_49FF
	push de

Label_26_493D:: ; 26:493D
	pop de
	push bc
	push de
	push hl
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_26_4987
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_26_4988
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_26_4987

; ---- code $495A-$4987 (45 bytes) [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4705-4A8A by apply_coverage --split
	jr nz, Label_26_4963
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_26_4987

Label_26_4963:: ; 26:4963
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_26_4973
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_26_4987
	set 1, [hl]

Label_26_4973:: ; 26:4973
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_26_4988
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_26_4988

; ---- code $4987-$498D (6 bytes) [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 4705-4A8A by apply_coverage --split [executed in 5 scenarios]

Label_26_4987:: ; 26:4987
	xor a, a

Label_26_4988:: ; 26:4988
	pop hl
	cp a, $00
	jr z, Label_26_49F2

; ---- code $498D-$49F2 (101 bytes) [PROBABLE] 46 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4705-4A8A by apply_coverage --split
	farcall Sprites_SaveSlotsToBank3
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	farcall Function_7F_6218
	inc a
	jr z, Label_26_49C2
	call MailSession_InitScreen
	farcall Sprites_RestoreSlotsFromBank3
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	jp Label_26_49F2

Label_26_49C2:: ; 26:49C2
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_26_49D0
	ld a, $00
	ld b, $00
	jr Label_26_49D4

Label_26_49D0:: ; 26:49D0
	ld a, $00
	ld b, $00

Label_26_49D4:: ; 26:49D4
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

; ---- code $49F2-$4A8A (152 bytes) [CONFIRMED] 70 insn(s) executed; cut out of the PROBABLE region 4705-4A8A by apply_coverage --split [executed in 2 scenarios]

Label_26_49F2:: ; 26:49F2
	pop hl
	pop de
	pop bc
	ld a, h
	cp a, d
	jp nz, MailSession_ReceiveMailsLoop
	ld a, l
	cp a, e
	jp nz, MailSession_ReceiveMailsLoop

Label_26_49FF:: ; 26:49FF
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
	jr nz, Label_26_4A1E
	jp MailSession_NoMailOrFull

Label_26_4A1E:: ; 26:4A1E
	call MailSession_ShowMsgReceived
	ld hl, $DA30
	ld de, $735B
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DA30
	call Function_00_0A65
	call Function_26_4C94
	ld de, $0000
	ld hl, $DA40
	call Function_00_0A65
	ld hl, $DA50
	ld de, $736B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DA50
	call Function_00_0A65
	ld c, $3C

Label_26_4A61:: ; 26:4A61
	call MailSession_PollAdapterError
	jp z, MailSession_ShowCommError
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	dec c
	jr nz, Label_26_4A61
	jp MailSession_Finish

; ---- code $4A8A-$4A99 (15 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 1/18 scenarios)

MailSession_NoMailOrFull:: ; 26:4A8A
	push de
	di
	farcall Mailbox_CountRecords
	ei
	ld a, d
	pop de
	cp a, $0C
	jr nz, Label_26_4A9E

; ---- code $4A99-$4A9E (5 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 26:4A97 (executed)
	call MailSession_ShowMsgCannotReceive
	jr Label_26_4AA1

; ---- code $4A9E-$4BDF (321 bytes) [CONFIRMED] 125 insn(s); 125 executed (in up to 1/18 scenarios)

Label_26_4A9E:: ; 26:4A9E
	call MailSession_ShowMsgNoMail

Label_26_4AA1:: ; 26:4AA1
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0042
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld hl, $DA30
	ld de, $734B
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DA30
	call Function_00_0A65
	ld hl, $DA50
	ld de, $737B
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DA50
	call Function_00_0A65
	ld hl, $DA60
	ld de, $73FB
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $1000
	ld hl, $DA60
	call Function_00_0A65
	ld c, $09

Label_26_4B02:: ; 26:4B02
	call MailSession_PollAdapterError
	jp z, MailSession_ShowCommError
	push bc
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
	di
	farcall Function_00_0956
	ei
	call Function_00_0464
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
	jr nz, Label_26_4B02
	ld de, $0080
	ld hl, $DA60
	call Function_00_0A65

MailSession_Finish:: ; 26:4B54
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $003D
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld hl, $DA30
	ld de, $732B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DA30
	call Function_00_0A65
	ld hl, $DA50
	ld de, $738B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DA50
	call Function_00_0A65

Label_26_4B9A:: ; 26:4B9A
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
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	ld a, [wSpriteSlots + 49]
	cp a, $E1
	jr z, Label_26_4BD5
	cp a, $E0
	jr nz, Label_26_4B9A

Label_26_4BD5:: ; 26:4BD5
	farcall Mail_OutboxIsEmpty
	inc a
	jp z, Label_26_4BF1

; ---- code $4BDF-$4BF1 (18 bytes) [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0; fall-through of the jpcc at 26:4BDC (executed) [executed in 1 scenarios]
	ld hl, $DA40
	ld de, $73EB
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	jr Label_26_4C01

; ---- code $4BF1-$4C0F (30 bytes) [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)

Label_26_4BF1:: ; 26:4BF1
	ld hl, $DA40
	ld de, $73CB
	ld a, $28
	ld b, $81
	farcall Function_00_0A82

Label_26_4C01:: ; 26:4C01
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D625
	ld a, [hli]
	cp a, $00
	jr z, Label_26_4C1F

; ---- code $4C0F-$4C1F (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 26:4C0D (executed) [executed in 2 scenarios]
	ld hl, $DA40
	ld de, $73EB
	ld a, $28
	ld b, $81
	farcall Function_00_0A82

; ---- code $4C1F-$4C94 (117 bytes) [CONFIRMED] 43 insn(s); 43 executed (in up to 1/18 scenarios)

Label_26_4C1F:: ; 26:4C1F
	ld de, $0000
	ld hl, $DA40
	call Function_00_0A65
	ld hl, $DA50
	ld de, $738B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DA50
	call Function_00_0A65

Label_26_4C41:: ; 26:4C41
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
	farcall Function_00_0956
	ei
	call Function_00_0464
	call MailSession_UpdateTimerDisplay
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, MailSession_Cancel
	ld a, [wSpriteSlots + 65]
	cp a, $91
	jr z, Label_26_4C83
	cp a, $90
	jr nz, Label_26_4C41

Label_26_4C83:: ; 26:4C83
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

; ---- code $4C94-$4DBA (294 bytes) [CONFIRMED] 215 insn(s) reached by static flow only; seeds: exec x215; min discovery hops 5; entered by call from 26:475F (PROBABLE code) | 115 insn(s) executed; cut out of the PROBABLE region 4C94-4EC3 by apply_coverage --split [executed in 1 scenarios]

Function_26_4C94:: ; 26:4C94
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D625
	ld a, [hli]
	cp a, $00
	jr nz, Label_26_4CB3
	ld hl, $DA40
	ld de, $73BB
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4CB3:: ; 26:4CB3
	cp a, $01
	jr nz, Label_26_4CC8
	ld hl, $DA40
	ld de, $74CB
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4CC8:: ; 26:4CC8
	cp a, $02
	jr nz, Label_26_4CDD
	ld hl, $DA40
	ld de, $74DB
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4CDD:: ; 26:4CDD
	cp a, $03
	jr nz, Label_26_4CF2
	ld hl, $DA40
	ld de, $74EB
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4CF2:: ; 26:4CF2
	cp a, $04
	jr nz, Label_26_4D07
	ld hl, $DA40
	ld de, $74FB
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4D07:: ; 26:4D07
	cp a, $05
	jr nz, Label_26_4D1C
	ld hl, $DA40
	ld de, $750B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4D1C:: ; 26:4D1C
	cp a, $06
	jr nz, Label_26_4D31
	ld hl, $DA40
	ld de, $751B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4D31:: ; 26:4D31
	cp a, $07
	jr nz, Label_26_4D46
	ld hl, $DA40
	ld de, $752B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4D46:: ; 26:4D46
	cp a, $08
	jr nz, Label_26_4D5B
	ld hl, $DA40
	ld de, $753B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4D5B:: ; 26:4D5B
	cp a, $09
	jr nz, Label_26_4D70
	ld hl, $DA40
	ld de, $754B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4D70:: ; 26:4D70
	cp a, $0A
	jr nz, Label_26_4D85
	ld hl, $DA40
	ld de, $755B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4D85:: ; 26:4D85
	cp a, $0B
	jr nz, Label_26_4D9A
	ld hl, $DA40
	ld de, $756B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4D9A:: ; 26:4D9A
	ld hl, $DA40
	ld de, $757B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Function_26_4DAB:: ; 26:4DAB
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D625
	ld a, [hli]
	inc a
	cp a, $00
	jr nz, Label_26_4DCB

; ---- code $4DBA-$4DCB (17 bytes) [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C94-4EC3 by apply_coverage --split
	ld hl, $DA60
	ld de, $73FB
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

; ---- code $4DCB-$4EC3 (248 bytes) [CONFIRMED] 94 insn(s) executed; cut out of the PROBABLE region 4C94-4EC3 by apply_coverage --split [executed in 1 scenarios]

Label_26_4DCB:: ; 26:4DCB
	cp a, $01
	jr nz, Label_26_4DE0
	ld hl, $DA60
	ld de, $740B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4DE0:: ; 26:4DE0
	cp a, $02
	jr nz, Label_26_4DF5
	ld hl, $DA60
	ld de, $741B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4DF5:: ; 26:4DF5
	cp a, $03
	jr nz, Label_26_4E0A
	ld hl, $DA60
	ld de, $742B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4E0A:: ; 26:4E0A
	cp a, $04
	jr nz, Label_26_4E1F
	ld hl, $DA60
	ld de, $743B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4E1F:: ; 26:4E1F
	cp a, $05
	jr nz, Label_26_4E34
	ld hl, $DA60
	ld de, $744B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4E34:: ; 26:4E34
	cp a, $06
	jr nz, Label_26_4E49
	ld hl, $DA60
	ld de, $745B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4E49:: ; 26:4E49
	cp a, $07
	jr nz, Label_26_4E5E
	ld hl, $DA60
	ld de, $746B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4E5E:: ; 26:4E5E
	cp a, $08
	jr nz, Label_26_4E73
	ld hl, $DA60
	ld de, $747B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4E73:: ; 26:4E73
	cp a, $09
	jr nz, Label_26_4E88
	ld hl, $DA60
	ld de, $748B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4E88:: ; 26:4E88
	cp a, $0A
	jr nz, Label_26_4E9D
	ld hl, $DA60
	ld de, $749B
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4E9D:: ; 26:4E9D
	cp a, $0B
	jr nz, Label_26_4EB2
	ld hl, $DA60
	ld de, $74AB
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

Label_26_4EB2:: ; 26:4EB2
	ld hl, $DA60
	ld de, $74BB
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ret

; ---- code $4EC3-$4EE0 (29 bytes) [CONFIRMED] 16 insn(s); 16 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

MailSession_CheckTimeWarning:: ; 26:4EC3
Function_26_4EC3::
	push af
	push bc
	push de
	push hl
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_26_4F0D
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_26_4F0E
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_26_4F0D

; ---- code $4EE0-$4F0D (45 bytes) [PROBABLE] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 0; fall-through of the jrcc at 26:4EDE (executed)
	jr nz, Label_26_4EE9
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_26_4F0D

Label_26_4EE9:: ; 26:4EE9
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_26_4EF9
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_26_4F0D
	set 1, [hl]

Label_26_4EF9:: ; 26:4EF9
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_26_4F0E
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_26_4F0E

; ---- code $4F0D-$4F13 (6 bytes) [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios)

Label_26_4F0D:: ; 26:4F0D
	xor a, a

Label_26_4F0E:: ; 26:4F0E
	pop hl
	cp a, $00
	jr z, Label_26_4F65

; ---- code $4F13-$4F65 (82 bytes) [PROBABLE] 28 insn(s) reached by static flow only; seeds: exec x28; min discovery hops 0; fall-through of the jrcc at 26:4F11 (executed)
	farcall Sprites_SaveSlotsToBank3
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeOutToWhite
	farcall Function_7F_6218
	inc a
	jr z, Label_26_4F6B
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
	farcall Function_00_0956
	ei
	call Function_00_0464

; ---- code $4F65-$4F6B (6 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)

Label_26_4F65:: ; 26:4F65
	pop hl
	pop de
	pop bc
	pop af
	xor a, a
	ret

; ---- code $4F6B-$4F7B (16 bytes) [PROBABLE] 110 insn(s) reached by static flow only; seeds: exec x110; min discovery hops 1; entered by jrcc from 26:4F2F (PROBABLE code) | 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4F6B-5062 by apply_coverage --split

Label_26_4F6B:: ; 26:4F6B
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	pop hl
	pop de
	pop bc
	pop af
	ld a, $FF
	ret

; ---- code $4F7B-$4F98 (29 bytes) [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 4F6B-5062 by apply_coverage --split [executed in 10 scenarios]

MailSession_CheckTimeWarningRecv:: ; 26:4F7B
	push af
	push bc
	push de
	push hl
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_26_4FC5
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_26_4FC6
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_26_4FC5

; ---- code $4F98-$4FC5 (45 bytes) [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4F6B-5062 by apply_coverage --split
	jr nz, Label_26_4FA1
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_26_4FC5

Label_26_4FA1:: ; 26:4FA1
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_26_4FB1
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_26_4FC5
	set 1, [hl]

Label_26_4FB1:: ; 26:4FB1
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_26_4FC6
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_26_4FC6

; ---- code $4FC5-$4FCB (6 bytes) [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 4F6B-5062 by apply_coverage --split [executed in 10 scenarios]

Label_26_4FC5:: ; 26:4FC5
	xor a, a

Label_26_4FC6:: ; 26:4FC6
	pop hl
	cp a, $00
	jr z, Label_26_5026

; ---- code $4FCB-$5026 (91 bytes) [PROBABLE] 32 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4F6B-5062 by apply_coverage --split
	farcall Sprites_SaveSlotsToBank3
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeOutToWhite
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	farcall Function_7F_6218
	inc a
	jr z, Label_26_502C
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
	farcall Function_00_0956
	ei
	call Function_00_0464

; ---- code $5026-$502C (6 bytes) [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 4F6B-5062 by apply_coverage --split [executed in 10 scenarios]

Label_26_5026:: ; 26:5026
	pop hl
	pop de
	pop bc
	pop af
	xor a, a
	ret

; ---- code $502C-$503C (16 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4F6B-5062 by apply_coverage --split

Label_26_502C:: ; 26:502C
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	pop hl
	pop de
	pop bc
	pop af
	ld a, $FF
	ret

; ---- code $503C-$5062 (38 bytes) [CONFIRMED] 15 insn(s) executed; cut out of the PROBABLE region 4F6B-5062 by apply_coverage --split [executed in 6 scenarios]

MailSession_Cancel:: ; 26:503C
	farcall Stat_DisableScrollSplit
	call Function_00_0464
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
