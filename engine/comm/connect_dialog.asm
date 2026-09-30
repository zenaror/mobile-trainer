; engine/comm/connect_dialog.asm
; bank 57, $4000-$47A6 (1958 bytes); pinned by layout.link
; modal connect dialog: run, per-frame handler, mode enter/leave

SECTION "engine/comm/connect_dialog", ROMX

; ---- code $4000-$4126 (294 bytes) [CONFIRMED] 124 insn(s); 124 executed (in up to 6/18 scenarios); entry proven: target of an executed call/far call

ConnectDialog_Run:: ; 57:4000
Function_57_4000::
	push bc
	push de
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4
	call FillBytes
	farcall Function_48_48BB
	pop de
	pop bc
	ld a, d
	ld [wConnectDialogArgBank], a
	ld a, c
	ld [wConnectDialogArgPtr], a
	ld a, b
	ld [wConnectDialogArgPtr + 1], a
	ld h, b
	ld l, c
	ld a, d
	call ReadByteFar
	ld [wRam_C0D8], a

ConnectDialog_Run_LoadMode:: ; 57:4029
	ldh a, [rLCDC]
	and a, $FF
	or a, $60
	ldh [rLCDC], a
	xor a, a
	ldh [rSCX], a
	ldh [rSCY], a
	ld a, $07
	ldh [rWX], a
	ld a, $90
	ldh [rWY], a
	farcall Function_00_09B6

ConnectDialog_Run_EnterMode:: ; 57:4044
	ld a, $01
	ld [wRam_C0E5], a
	call ConnectDialog_DrawScreen
	call ConnectDialog_EnterMode
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0012
	call Function_00_20E8
	pop af
	ldh [rSVBK], a

ConnectDialog_Run_FrameLoop:: ; 57:405F
	call ConnectDialog_HandleFrame
	or a, a
	jr nz, ConnectDialog_Run_ModeChanged
	jp ConnectDialog_Run_FrameLoop

ConnectDialog_Run_ModeChanged:: ; 57:4068
	call ConnectDialog_LeaveMode
	farcall Function_00_0956
	ld a, [wRam_C0D8]
	or a, a
	jr z, ConnectDialog_Run_Cancel
	cp a, $10
	jr z, ConnectDialog_Run_Accept
	cp a, $05
	jr nc, Label_57_4082
	jp ConnectDialog_Run_LoadMode

Label_57_4082:: ; 57:4082
	ld a, [wRam_C0E6]
	cp a, $05
	jp nc, ConnectDialog_Run_EnterMode
	jp ConnectDialog_Run_LoadMode

ConnectDialog_Run_Cancel:: ; 57:408D
	farcall Palette_FadeOutToWhite
	ld b, $FF
	ret

ConnectDialog_Run_Accept:: ; 57:4096
	farcall Palette_FadeOutToWhite
	ld a, [wConnectDialogArgPtr]
	ld l, a
	ld a, [wConnectDialogArgPtr + 1]
	ld h, a
	ld a, [wConnectDialogArgBank]
	ld d, a
	inc hl
	inc hl
	inc hl
	call ReadByteFar
	ld [wRam_C10E], a
	ld a, d
	call ReadByteFar
	ld e, a
	ld a, d
	call ReadByteFar
	ld h, a
	ld l, e
	ld de, $C1B2
	ld a, [wConnectDialogTextLen]
	ld c, a

Label_57_40C3:: ; 57:40C3
	ld a, [de]
	inc de
	ld b, a
	ld a, [wRam_C10E]
	farcall WriteByteFar
	dec c
	jr nz, Label_57_40C3
	ld b, $00
	ld a, [wRam_C10E]
	farcall WriteByteFar
	ld b, $00
	ret

ConnectDialog_HandleFrame:: ; 57:40E0
	ld a, [wRam_C0D8]
	cp a, $06
	jp z, ConnectDialog_Input_Keyboard
	farcall Function_00_0956
	call Function_00_044B
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	ldh a, [hJoyPressedRepeat]
	or a, a
	ret z
	ld b, a
	ld a, [wRam_C0D8]
	cp a, $02
	jr c, Label_57_412A
	jp z, Label_57_4189
	cp a, $04
	jp c, ConnectDialog_Input_ConnectConfirm
	jp z, ConnectDialog_Input_ConnectConfirm
	cp a, $06
	jp c, ConnectDialog_Input_PasswordPrompt
	cp a, $08
	jp c, ConnectDialog_Input_SaveConfirm
	jp z, ConnectDialog_Input_PasswordSaved
	cp a, $0A
	jp c, ConnectDialog_Input_StoredPassword

; ---- code $4126-$4129 (3 bytes) [CONFIRMED] 78 insn(s) reached by static flow only; seeds: exec x78; min discovery hops 0; fall-through of the jpcc at 57:4123 (executed) | 1 insn(s) executed; cut out of the PROBABLE region 4126-41CA by apply_coverage --split [executed in 6 scenarios]
	jp z, ConnectDialog_Input_ForgetConfirm

; ---- code $4129-$41CA (161 bytes) [PROBABLE] 77 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4126-41CA by apply_coverage --split
	ret

Label_57_412A:: ; 57:412A
	bit 5, b
	jr nz, Label_57_415C
	bit 4, b
	jr nz, Label_57_415C
	ldh a, [hJoyPressed]
	bit 0, a
	jr nz, Label_57_413E
	bit 1, a
	jr nz, Label_57_4150
	xor a, a
	ret

Label_57_413E:: ; 57:413E
	ld a, $00
	call ConnectDialog_PlayButtonSfx
	ld a, [wRam_C0E5]
	cp a, $01
	jr nz, Label_57_4150
	ld a, $02
	ld [wRam_C0D6], a
	ret

Label_57_4150:: ; 57:4150
	ld a, $01
	call ConnectDialog_PlayButtonSfx
	xor a, a
	ld [wRam_C0D6], a
	ld a, $01
	ret

Label_57_415C:: ; 57:415C
	ld a, [wRam_C0E5]
	xor a, $03
	ld [wRam_C0E5], a
	ld de, $7828
	cp a, $01
	jr z, Label_57_416E
	ld de, $7858

Label_57_416E:: ; 57:416E
	ld hl, $DA40
	farcall Function_00_0A65
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	xor a, a
	ret

Label_57_4189:: ; 57:4189
	bit 5, b
	jr nz, Label_57_415C
	bit 4, b
	jr nz, Label_57_415C
	ldh a, [hJoyPressed]
	bit 0, a
	jr nz, Label_57_419D
	bit 1, a
	jr nz, Label_57_41BF
	xor a, a
	ret

Label_57_419D:: ; 57:419D
	ld a, $00
	call ConnectDialog_PlayButtonSfx
	ld a, [wRam_C0E5]
	cp a, $01
	jr nz, Label_57_41BF
	ld a, $01
	ld hl, $A880
	call ReadByteFar
	ld b, $05
	or a, a
	jr z, Label_57_41B8
	ld b, $09

Label_57_41B8:: ; 57:41B8
	ld a, b
	ld [wRam_C0D6], a
	ld a, $01
	ret

Label_57_41BF:: ; 57:41BF
	ld a, $01
	call ConnectDialog_PlayButtonSfx
	ld a, $01
	ld [wRam_C0D6], a
	ret

; ---- code $41CA-$4237 (109 bytes) [CONFIRMED] 51 insn(s); 51 executed (in up to 6/18 scenarios)

ConnectDialog_Input_ConnectConfirm:: ; 57:41CA
	bit 5, b
	jr nz, Label_57_420A
	bit 4, b
	jr nz, Label_57_420A
	ldh a, [hJoyPressed]
	bit 0, a
	jr nz, Label_57_41DE
	bit 1, a
	jr nz, Label_57_41FE
	xor a, a
	ret

Label_57_41DE:: ; 57:41DE
	ld a, $00
	call ConnectDialog_PlayButtonSfx
	ld a, [wRam_C0E5]
	cp a, $01
	jr nz, Label_57_4203
	ld a, $01
	ld hl, $A880
	call ReadByteFar
	ld b, $05
	or a, a
	jr z, Label_57_41F9
	ld b, $09

Label_57_41F9:: ; 57:41F9
	ld a, b
	ld [wRam_C0D6], a
	ret

Label_57_41FE:: ; 57:41FE
	ld a, $01
	call ConnectDialog_PlayButtonSfx

Label_57_4203:: ; 57:4203
	xor a, a
	ld [wRam_C0D6], a
	ld a, $01
	ret

Label_57_420A:: ; 57:420A
	ld a, [wRam_C0E5]
	xor a, $03
	ld [wRam_C0E5], a
	ld de, $6828
	cp a, $01
	jr z, Label_57_421C
	ld de, $6858

Label_57_421C:: ; 57:421C
	ld hl, $DA40
	farcall Function_00_0A65
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	xor a, a
	ret

; ---- code $4237-$4265 (46 bytes) [CONFIRMED] 238 insn(s) reached by static flow only; seeds: exec x238; min discovery hops 1; entered by jpcc from 57:4116 (executed) | 22 insn(s) executed; cut out of the PROBABLE region 4237-4443 by apply_coverage --split [executed in 4 scenarios]

ConnectDialog_Input_PasswordPrompt:: ; 57:4237
	ldh a, [hJoyPressed]
	bit 0, a
	jr nz, Label_57_4243
	bit 1, a
	jr nz, Label_57_424E
	xor a, a
	ret

Label_57_4243:: ; 57:4243
	ld a, $00
	call ConnectDialog_PlayButtonSfx
	ld a, $06
	ld [wRam_C0D6], a
	ret

Label_57_424E:: ; 57:424E
	ld a, $01
	call ConnectDialog_PlayButtonSfx
	ld a, [wConnectDialogArgPtr]
	ld l, a
	ld a, [wConnectDialogArgPtr + 1]
	ld h, a
	ld a, [wConnectDialogArgBank]
	call ReadByteFar
	cp a, $03
	jr nc, Label_57_4267

; ---- code $4265-$4267 (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4237-4443 by apply_coverage --split
	ld a, $02

; ---- code $4267-$4297 (48 bytes) [CONFIRMED] 17 insn(s) executed; cut out of the PROBABLE region 4237-4443 by apply_coverage --split [executed in 4 scenarios]

Label_57_4267:: ; 57:4267
	ld [wRam_C0D6], a
	ret

ConnectDialog_Input_Keyboard:: ; 57:426B
	farcall Function_00_0956
	call ConnectDialog_ValidatePassword
	farcall Kbd_Run
	cp a, $01
	jr z, ConnectDialog_Keyboard_AppendChar
	cp a, $0A
	jp z, Label_57_4325
	cp a, $07
	jp z, Label_57_4333
	cp a, $09
	jp z, Label_57_4339
	cp a, $02
	jp z, ConnectDialog_Keyboard_EraseChar
	cp a, $08
	jp z, Label_57_4339

; ---- code $4297-$4299 (2 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4237-4443 by apply_coverage --split
	xor a, a
	ret

; ---- code $4299-$4443 (426 bytes) [CONFIRMED] 196 insn(s) executed; cut out of the PROBABLE region 4237-4443 by apply_coverage --split [executed in 1 scenarios]

ConnectDialog_Keyboard_AppendChar:: ; 57:4299
	ld a, [wConnectDialogTextLen]
	cp a, $08
	jr z, Label_57_430D
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld hl, $DA20
	ld de, Table_56_79B8
	ld a, $56
	ld b, $03
	farcall Function_00_0A82
	ld hl, $DA2B
	ld de, $52D8
	ld a, $57
	call Function_00_0A45
	call ConnectDialog_PlaceCaretSprites
	call ConnectDialog_DrawPasswordField
	ld a, $F0
	ld hl, $C2AD
	call ReadByteFar
	ld b, a
	ld hl, $C1B2
	ld a, [wConnectDialogTextLen]
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld [hl], b
	ld a, b
	farcall Text_HalfToFullWidth
	ld hl, $C1BA
	ld a, [wConnectDialogTextLen]
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld [hl], b
	inc hl
	ld [hl], c
	inc hl
	ld [hl], $00
	ld a, [wConnectDialogTextLen]
	inc a
	ld [wConnectDialogTextLen], a
	call ConnectDialog_RenderTypedChars
	xor a, a
	ret

Label_57_430D:: ; 57:430D
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	xor a, a
	ret

Label_57_431F:: ; 57:431F
	ld a, $05
	ld [wRam_C0D6], a
	ret

Label_57_4325:: ; 57:4325
	call ConnectDialog_ValidatePassword
	xor a, a
	or a, b
	ld a, $00
	ret z
	ld a, $07
	ld [wRam_C0D6], a
	ret

Label_57_4333:: ; 57:4333
	ld a, $10
	ld [wRam_C0D6], a
	ret

Label_57_4339:: ; 57:4339
	ld a, $05
	ld [wRam_C0D6], a
	ret

ConnectDialog_Keyboard_EraseChar:: ; 57:433F
	ld a, [wConnectDialogTextLen]
	or a, a
	jr z, Label_57_438E
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0039
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	call ConnectDialog_DrawPasswordField
	ld a, [wConnectDialogTextLen]
	dec a
	ld [wConnectDialogTextLen], a
	ld hl, $DA20
	ld de, Table_56_79B8
	ld a, $56
	ld b, $02
	farcall Function_00_0A82
	ld hl, $DA2B
	ld de, $52D8
	ld a, $57
	call Function_00_0A45
	call ConnectDialog_PlaceCaretSprites
	ld hl, $C1BA
	ld a, [wConnectDialogTextLen]
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld [hl], $00
	xor a, a
	ret

Label_57_438E:: ; 57:438E
	call ConnectDialog_DrawPasswordField
	xor a, a
	ld [wRam_C0E8], a
	ld hl, $DA20
	ld de, Table_56_79B8
	ld a, $56
	ld b, $81
	farcall Function_00_0A82
	ld hl, $DA2B
	ld de, $531E
	ld a, $57
	call Function_00_0A45
	call ConnectDialog_PlaceCaretSprites
	farcall Kbd_Hide
	jp Label_57_431F

ConnectDialog_Input_SaveConfirm:: ; 57:43BC
	bit 5, b
	jr nz, Label_57_43F4
	bit 4, b
	jr nz, Label_57_43F4
	ldh a, [hJoyPressed]
	bit 0, a
	jr nz, Label_57_43D0
	bit 1, a
	jr nz, Label_57_43E2
	xor a, a
	ret

Label_57_43D0:: ; 57:43D0
	ld a, $00
	call ConnectDialog_PlayButtonSfx
	ld a, [wRam_C0E5]
	cp a, $01
	jr nz, Label_57_43E2
	ld a, $08
	ld [wRam_C0D6], a
	ret

Label_57_43E2:: ; 57:43E2
	ld a, $01
	call ConnectDialog_PlayButtonSfx
	ld a, $02
	ld [wRam_C0E5], a
	ld a, $06
	ld [wRam_C0D6], a
	ld a, $01
	ret

Label_57_43F4:: ; 57:43F4
	ld a, [wRam_C0E5]
	xor a, $03
	ld [wRam_C0E5], a
	ld de, $7828
	cp a, $01
	jr z, Label_57_4406
	ld de, $7858

Label_57_4406:: ; 57:4406
	ld hl, $DA40
	farcall Function_00_0A65
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	xor a, a
	ret

ConnectDialog_Input_PasswordSaved:: ; 57:4421
	ldh a, [hJoyPressed]
	bit 0, a
	jr nz, Label_57_442D
	bit 1, a
	jr nz, Label_57_4438
	xor a, a
	ret

Label_57_442D:: ; 57:442D
	ld a, $00
	call ConnectDialog_PlayButtonSfx
	ld a, $10
	ld [wRam_C0D6], a
	ret

Label_57_4438:: ; 57:4438
	ld a, $01
	call ConnectDialog_PlayButtonSfx
	ld a, $07
	ld [wRam_C0D6], a
	ret

; ---- code $4443-$4475 (50 bytes) [CONFIRMED] 24 insn(s); 24 executed (in up to 5/18 scenarios)

ConnectDialog_Input_StoredPassword:: ; 57:4443
	ldh a, [hJoyPressed]
	bit 0, a
	jr nz, Label_57_4453
	bit 1, a
	jr nz, Label_57_445E
	bit 2, a
	jr nz, Label_57_447B
	xor a, a
	ret

Label_57_4453:: ; 57:4453
	ld a, $00
	call ConnectDialog_PlayButtonSfx
	ld a, $10
	ld [wRam_C0D6], a
	ret

Label_57_445E:: ; 57:445E
	ld a, $01
	call ConnectDialog_PlayButtonSfx
	ld a, [wConnectDialogArgPtr]
	ld l, a
	ld a, [wConnectDialogArgPtr + 1]
	ld h, a
	ld a, [wConnectDialogArgBank]
	call ReadByteFar
	cp a, $03
	jr nc, Label_57_4477

; ---- code $4475-$4477 (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 57:4473 (executed)
	ld a, $02

; ---- code $4477-$447B (4 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)

Label_57_4477:: ; 57:4477
	ld [wRam_C0D6], a
	ret

; ---- code $447B-$44E4 (105 bytes) [CONFIRMED] 48 insn(s) reached by static flow only; seeds: exec x48; min discovery hops 1; entered by jrcc from 57:444F (executed) [executed in 1 scenarios]

Label_57_447B:: ; 57:447B
	ld a, $0A
	ld [wRam_C0D6], a
	ret

ConnectDialog_Input_ForgetConfirm:: ; 57:4481
	bit 5, b
	jr nz, Label_57_44B7
	bit 4, b
	jr nz, Label_57_44B7
	ldh a, [hJoyPressed]
	bit 0, a
	jr nz, Label_57_4495
	bit 1, a
	jr nz, Label_57_44A7
	xor a, a
	ret

Label_57_4495:: ; 57:4495
	ld a, $00
	call ConnectDialog_PlayButtonSfx
	ld a, [wRam_C0E5]
	cp a, $01
	jr nz, Label_57_44A7
	ld a, $05
	ld [wRam_C0D6], a
	ret

Label_57_44A7:: ; 57:44A7
	ld a, $01
	call ConnectDialog_PlayButtonSfx
	ld a, $02
	ld [wRam_C0E5], a
	ld a, $09
	ld [wRam_C0D6], a
	ret

Label_57_44B7:: ; 57:44B7
	ld a, [wRam_C0E5]
	xor a, $03
	ld [wRam_C0E5], a
	ld de, $7828
	cp a, $01
	jr z, Label_57_44C9
	ld de, $7858

Label_57_44C9:: ; 57:44C9
	ld hl, $DA40
	farcall Function_00_0A65
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	xor a, a
	ret

; ---- code $44E4-$450B (39 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 6/18 scenarios); entry proven: target of an executed call/far call

ConnectDialog_EnterMode:: ; 57:44E4
Function_57_44E4::
	ld a, [wRam_C0D8]
	cp a, $02
	jr c, Label_57_450F
	jp z, Label_57_4510
	cp a, $04
	jp c, Label_57_4511
	jp z, Label_57_4512
	cp a, $06
	jp c, Label_57_4513
	jp z, ConnectDialog_Enter_Keyboard
	cp a, $08
	jp c, Label_57_4566
	jp z, ConnectDialog_Enter_PasswordSaved
	cp a, $0A
	jp c, ConnectDialog_Enter_StoredPassword

; ---- code $450B-$450E (3 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jpcc at 57:4508 (executed) | 1 insn(s) executed; cut out of the PROBABLE region 450B-4511 by apply_coverage --split [executed in 6 scenarios]
	jp z, Label_57_45BC

; ---- code $450E-$4511 (3 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 450B-4511 by apply_coverage --split
	ret

Label_57_450F:: ; 57:450F
	ret

Label_57_4510:: ; 57:4510
	ret

; ---- code $4511-$4513 (2 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 4/18 scenarios)

Label_57_4511:: ; 57:4511
	ret

Label_57_4512:: ; 57:4512
	ret

; ---- code $4513-$459A (135 bytes) [CONFIRMED] 56 insn(s) reached by static flow only; seeds: exec x56; min discovery hops 1; entered by jpcc from 57:44F8 (executed) [executed in 3 scenarios]

Label_57_4513:: ; 57:4513
	call ConnectDialog_DrawPasswordField
	ret

ConnectDialog_Enter_Keyboard:: ; 57:4517
	ld a, $09
	ld [wRam_C0F6], a
	di
	ld a, $44
	ldh [rSTAT], a
	ld a, $1A
	ldh [rLYC], a
	ld a, [wLcdStatVector]
	ld [wSavedLcdStatVector], a
	ld a, [wLcdStatVector + 1]
	ld [wSavedLcdStatVector + 1], a
	ld a, [wLcdStatVector + 2]
	ld [wSavedLcdStatVector + 2], a
	ld a, $C3
	ld [wLcdStatVector], a
	ld a, $DC
	ld [wLcdStatVector + 1], a
	ld a, $16
	ld [wLcdStatVector + 2], a
	ldh a, [rIE]
	or a, $02
	ldh [rIE], a
	xor a, a
	ldh [rIF], a
	ei
	ld hl, $DA2B
	ld de, $531E
	ld a, $57
	call Function_00_0A45
	ld a, $05
	ld b, $00
	farcall Kbd_Open
	ret

Label_57_4566:: ; 57:4566
	ld hl, $DA40
	ld de, Table_56_79B8
	ld a, $56
	ld b, $85
	farcall Function_00_0A82
	ld de, $7828
	ld hl, $DA40
	call Function_00_0A65
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0030
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

ConnectDialog_Enter_PasswordSaved:: ; 57:4590
	ld de, $C1B2
	ld a, [wConnectDialogTextLen]
	call SavedPassword_Store
	ret

; ---- code $459A-$45BC (34 bytes) [CONFIRMED] 16 insn(s); 16 executed (in up to 5/18 scenarios)

ConnectDialog_Enter_StoredPassword:: ; 57:459A
	ld a, $01
	ld hl, $A880
	call ReadByteFar
	ld [wConnectDialogTextLen], a
	ld c, a
	ld hl, $A88D
	ld de, $C1B2

Label_57_45AC:: ; 57:45AC
	ld a, $01
	call ReadByteFar
	xor a, $5A
	ld [de], a
	inc de
	dec c
	jr nz, Label_57_45AC
	call ConnectDialog_DrawPasswordField
	ret

; ---- code $45BC-$45E6 (42 bytes) [CONFIRMED] 17 insn(s) reached by static flow only; seeds: exec x17; min discovery hops 1; entered by jpcc from 57:450B (PROBABLE code) [executed in 4 scenarios]

Label_57_45BC:: ; 57:45BC
	ld hl, $DA40
	ld de, Table_56_79B8
	ld a, $56
	ld b, $85
	farcall Function_00_0A82
	ld de, $7828
	ld hl, $DA40
	call Function_00_0A65
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0030
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

; ---- code $45E6-$4618 (50 bytes) [CONFIRMED] 20 insn(s); 20 executed (in up to 6/18 scenarios); entry proven: target of an executed call/far call

ConnectDialog_LeaveMode:: ; 57:45E6
Function_57_45E6::
	ld a, [wRam_C0D8]
	ld [wRam_C0E6], a
	ld b, a
	ld a, [wRam_C0D6]
	ld [wRam_C0D8], a
	ld a, b
	cp a, $02
	jr c, Label_57_461C
	jp z, Label_57_4642
	cp a, $04
	jp c, Label_57_4668
	jp z, Label_57_468E
	cp a, $06
	jp c, Label_57_46B4
	jp z, ConnectDialog_Leave_Keyboard
	cp a, $08
	jp c, Label_57_4738
	jp z, ConnectDialog_Leave_PasswordSaved
	cp a, $0A
	jp c, Label_57_4771

; ---- code $4618-$461B (3 bytes) [CONFIRMED] 28 insn(s) reached by static flow only; seeds: exec x28; min discovery hops 0; fall-through of the jpcc at 57:4615 (executed) | 1 insn(s) executed; cut out of the PROBABLE region 4618-4668 by apply_coverage --split [executed in 6 scenarios]
	jp z, ConnectDialog_Leave_ForgetConfirm

; ---- code $461B-$4668 (77 bytes) [PROBABLE] 27 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4618-4668 by apply_coverage --split
	ret

Label_57_461C:: ; 57:461C
	ld a, [wRam_C0E5]
	dec a
	jr nz, Label_57_4632
	farcall Palette_FadeOutToWhite
	ld de, $00B4
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_57_4632:: ; 57:4632
	farcall Palette_FadeOutToWhite
	ld de, $00B4
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_57_4642:: ; 57:4642
	ld a, [wRam_C0E5]
	dec a
	jr nz, Label_57_4658
	farcall Palette_FadeOutToWhite
	ld de, $00B4
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_57_4658:: ; 57:4658
	farcall Palette_FadeOutToWhite
	ld de, $00B4
	ld hl, $DA40
	call Function_00_0A65
	ret

; ---- code $4668-$467E (22 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)

Label_57_4668:: ; 57:4668
	ld a, [wRam_C0E5]
	dec a
	jr nz, Label_57_467E
	farcall Palette_FadeOutToWhite
	ld de, $00B4
	ld hl, $DA40
	call Function_00_0A65
	ret

; ---- code $467E-$468E (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1; entered by jrcc from 57:466C (executed) [executed in 5 scenarios]

Label_57_467E:: ; 57:467E
	farcall Palette_FadeOutToWhite
	ld de, $00B4
	ld hl, $DA40
	call Function_00_0A65
	ret

; ---- code $468E-$46B4 (38 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 4/18 scenarios)

Label_57_468E:: ; 57:468E
	ld a, [wRam_C0E5]
	dec a
	jr nz, Label_57_46A4
	farcall Palette_FadeOutToWhite
	ld de, $00B4
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_57_46A4:: ; 57:46A4
	farcall Palette_FadeOutToWhite
	ld de, $00B4
	ld hl, $DA40
	call Function_00_0A65
	ret

; ---- code $46B4-$4771 (189 bytes) [CONFIRMED] 73 insn(s) reached by static flow only; seeds: exec x73; min discovery hops 1; entered by jpcc from 57:4605 (executed) [executed in 1 scenarios]

Label_57_46B4:: ; 57:46B4
	ld a, [wRam_C0D8]
	cp a, $06
	jr z, Label_57_46DF
	ld de, $00B4
	ld hl, $DA20
	call Function_00_0A65
	ld hl, $DA2B
	ld de, $0000
	ld a, $00
	call Function_00_0A45
	ld de, $00A0
	ld hl, $DA30
	call Function_00_0A65
	farcall Palette_FadeOutToWhite
	ret

Label_57_46DF:: ; 57:46DF
	ret

ConnectDialog_Leave_Keyboard:: ; 57:46E0
	farcall Kbd_HideInstant
	di
	ldh a, [rSTAT]
	and a, $87
	ldh [rSTAT], a
	ld hl, $CBF4
	ld a, [wSavedLcdStatVector]
	ld [hli], a
	ld a, [wSavedLcdStatVector + 1]
	ld [hli], a
	ld a, [wSavedLcdStatVector + 2]
	ld [hl], a
	ldh a, [rIE]
	and a, $FD
	ldh [rIE], a
	xor a, a
	ldh [rIF], a
	ldh [rSCY], a
	ei
	ld a, [wRam_C0D8]
	cp a, $05
	ret z
	ld de, $00B4
	ld hl, $DA20
	call Function_00_0A65
	ld hl, $DA2B
	ld de, $0000
	ld a, $00
	call Function_00_0A45
	ld de, $00B4
	ld hl, $DA30
	call Function_00_0A65
	ld a, [wRam_C0D8]
	cp a, $10
	ret nz
	farcall Palette_FadeOutToWhite
	ret

Label_57_4738:: ; 57:4738
	ld de, $00B4
	ld hl, $DA40
	call Function_00_0A65
	ld a, [wRam_C0E5]
	dec a
	jr nz, Label_57_474E
	farcall Palette_FadeOutToWhite
	ret

Label_57_474E:: ; 57:474E
	ret

ConnectDialog_Leave_PasswordSaved:: ; 57:474F
	ld a, [wRam_C0D8]
	cp a, $07
	jr z, Label_57_475D
	farcall Palette_FadeOutToWhite
	ret

Label_57_475D:: ; 57:475D
	farcall Palette_FadeOutToWhite
	ld b, $00
	ld a, $01
	ld hl, $A880
	farcall WriteByteFar
	ret

; ---- code $4771-$477E (13 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 5/18 scenarios)

Label_57_4771:: ; 57:4771
	ld a, [wRam_C0D8]
	cp a, $0A
	ret z
	farcall Palette_FadeOutToWhite
	ret

; ---- code $477E-$47A6 (40 bytes) [CONFIRMED] 15 insn(s) reached by static flow only; seeds: exec x15; min discovery hops 1; entered by jpcc from 57:4618 (PROBABLE code) [executed in 2 scenarios]

ConnectDialog_Leave_ForgetConfirm:: ; 57:477E
	ld de, $00B4
	ld hl, $DA40
	call Function_00_0A65
	ld a, [wRam_C0D8]
	cp a, $09
	jr z, Label_57_47A5
	xor a, a
	ld [wConnectDialogTextLen], a
	ld b, a
	ld a, $01
	ld hl, $A880
	farcall WriteByteFar
	farcall Palette_FadeOutToWhite
	ret

Label_57_47A5:: ; 57:47A5
	ret
