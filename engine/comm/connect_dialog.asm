; engine/comm/connect_dialog.asm
; bank 57, $4000-$47A6 (1958 bytes); pinned by layout.link
; modal connect dialog: run, per-frame handler, mode enter/leave

SECTION "engine/comm/connect_dialog", ROMX

ConnectDialog_Run:: ; 57:4000
Function_57_4000::
	; [CONFIRMED] 124 insn(s); 124 executed (in up to 6/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push de
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4 ; raw: start of the 252-byte per-screen window wipe
	call FillBytes
	farcall Stub_Nop_48_48BB
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
	ld [wConnectDialog_Mode], a

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
	farcall Sprite_ResetAll

ConnectDialog_Run_EnterMode:: ; 57:4044
	ld a, $01
	ld [wConnectDialog_Cursor], a
	call ConnectDialog_DrawScreen
	call ConnectDialog_EnterMode
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0012
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a

ConnectDialog_Run_FrameLoop:: ; 57:405F
	call ConnectDialog_HandleFrame
	or a, a
	jr nz, ConnectDialog_Run_ModeChanged
	jp ConnectDialog_Run_FrameLoop

ConnectDialog_Run_ModeChanged:: ; 57:4068
	call ConnectDialog_LeaveMode
	farcall Sprite_UpdateAll
	ld a, [wConnectDialog_Mode]
	or a, a
	jr z, ConnectDialog_Run_Cancel
	cp a, $10
	jr z, ConnectDialog_Run_Accept
	cp a, $05
	jr nc, .l4082
	jp ConnectDialog_Run_LoadMode
.l4082 ; 57:4082
	ld a, [wConnectDialog_PrevMode]
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
	ld [wConnectDialog_DestBank], a
	ld a, d
	call ReadByteFar
	ld e, a
	ld a, d
	call ReadByteFar
	ld h, a
	ld l, e
	ld de, wConnectDialogText
	ld a, [wConnectDialogTextLen]
	ld c, a
.loop ; 57:40C3
	ld a, [de]
	inc de
	ld b, a
	ld a, [wConnectDialog_DestBank]
	farcall WriteByteFar
	dec c
	jr nz, .loop
	ld b, $00
	ld a, [wConnectDialog_DestBank]
	farcall WriteByteFar
	ld b, $00
	ret

ConnectDialog_HandleFrame:: ; 57:40E0
	ld a, [wConnectDialog_Mode]
	cp a, $06
	jp z, ConnectDialog_Input_Keyboard
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	ldh a, [hJoyPressedRepeat]
	or a, a
	ret z
	ld b, a
	ld a, [wConnectDialog_Mode]
	cp a, $02
	jr c, .l412A
	jp z, .l4189
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

	; [CONFIRMED] 78 insn(s) reached by static flow only; seeds: exec x78; min discovery hops 0;
	; fall-through of the jpcc at 57:4123 (executed) | 1 insn(s) executed; cut out of the PROBABLE
	; region 4126-41CA by apply_coverage --split [executed in 6 scenarios]
	jp z, ConnectDialog_Input_ForgetConfirm

	; [PROBABLE] 77 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4126-41CA by apply_coverage --split
	ret
.l412A ; 57:412A
	bit 5, b
	jr nz, .l415C
	bit 4, b
	jr nz, .l415C
	ldh a, [hJoyPressed]
	bit PADB_A, a
	jr nz, .l413E
	bit PADB_B, a
	jr nz, .l4150
	xor a, a
	ret
.l413E ; 57:413E
	ld a, $00
	call ConnectDialog_PlayButtonSfx
	ld a, [wConnectDialog_Cursor]
	cp a, $01
	jr nz, .l4150
	ld a, $02
	ld [wConnectDialog_NextMode], a
	ret
.l4150 ; 57:4150
	ld a, $01
	call ConnectDialog_PlayButtonSfx
	xor a, a
	ld [wConnectDialog_NextMode], a
	ld a, $01
	ret
.l415C ; 57:415C
	ld a, [wConnectDialog_Cursor]
	xor a, $03
	ld [wConnectDialog_Cursor], a
	ld de, $7828
	cp a, $01
	jr z, .l416E
	ld de, $7858
.l416E ; 57:416E
	ld hl, wSpriteSlot4
	farcall Sprite_SetPosition
	play_sfx SFX_CURSOR_MOVE
	xor a, a
	ret
.l4189 ; 57:4189
	bit 5, b
	jr nz, .l415C
	bit 4, b
	jr nz, .l415C
	ldh a, [hJoyPressed]
	bit PADB_A, a
	jr nz, .l419D
	bit PADB_B, a
	jr nz, .l41BF
	xor a, a
	ret
.l419D ; 57:419D
	ld a, $00
	call ConnectDialog_PlayButtonSfx
	ld a, [wConnectDialog_Cursor]
	cp a, $01
	jr nz, .l41BF
	ld a, $01
	ld hl, sSavedPasswordLen
	call ReadByteFar
	ld b, $05
	or a, a
	jr z, .l41B8
	ld b, $09
.l41B8 ; 57:41B8
	ld a, b
	ld [wConnectDialog_NextMode], a
	ld a, $01
	ret
.l41BF ; 57:41BF
	ld a, $01
	call ConnectDialog_PlayButtonSfx
	ld a, $01
	ld [wConnectDialog_NextMode], a
	ret

ConnectDialog_Input_ConnectConfirm:: ; 57:41CA
	; [CONFIRMED] 51 insn(s); 51 executed (in up to 6/18 scenarios)
	bit 5, b
	jr nz, .l420A
	bit 4, b
	jr nz, .l420A
	ldh a, [hJoyPressed]
	bit PADB_A, a
	jr nz, .l41DE
	bit PADB_B, a
	jr nz, .l41FE
	xor a, a
	ret
.l41DE ; 57:41DE
	ld a, $00
	call ConnectDialog_PlayButtonSfx
	ld a, [wConnectDialog_Cursor]
	cp a, $01
	jr nz, .l4203
	ld a, $01
	ld hl, sSavedPasswordLen
	call ReadByteFar
	ld b, $05
	or a, a
	jr z, .l41F9
	ld b, $09
.l41F9 ; 57:41F9
	ld a, b
	ld [wConnectDialog_NextMode], a
	ret
.l41FE ; 57:41FE
	ld a, $01
	call ConnectDialog_PlayButtonSfx
.l4203 ; 57:4203
	xor a, a
	ld [wConnectDialog_NextMode], a
	ld a, $01
	ret
.l420A ; 57:420A
	ld a, [wConnectDialog_Cursor]
	xor a, $03
	ld [wConnectDialog_Cursor], a
	ld de, $6828
	cp a, $01
	jr z, .l421C
	ld de, $6858
.l421C ; 57:421C
	ld hl, wSpriteSlot4
	farcall Sprite_SetPosition
	play_sfx SFX_CURSOR_MOVE
	xor a, a
	ret

ConnectDialog_Input_PasswordPrompt:: ; 57:4237
	; [CONFIRMED] 238 insn(s) reached by static flow only; seeds: exec x238; min discovery hops 1;
	; entered by jpcc from 57:4116 (executed) | 22 insn(s) executed; cut out of the PROBABLE region
	; 4237-4443 by apply_coverage --split [executed in 4 scenarios]
	ldh a, [hJoyPressed]
	bit PADB_A, a
	jr nz, .l4243
	bit PADB_B, a
	jr nz, .l424E
	xor a, a
	ret
.l4243 ; 57:4243
	ld a, $00
	call ConnectDialog_PlayButtonSfx
	ld a, $06
	ld [wConnectDialog_NextMode], a
	ret
.l424E ; 57:424E
	ld a, $01
	call ConnectDialog_PlayButtonSfx
	ld a, [wConnectDialogArgPtr]
	ld l, a
	ld a, [wConnectDialogArgPtr + 1]
	ld h, a
	ld a, [wConnectDialogArgBank]
	call ReadByteFar
	cp a, $03
	jr nc, .skip

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4237-4443 by apply_coverage --split
	ld a, $02

.skip ; 57:4267
	; [CONFIRMED] 17 insn(s) executed; cut out of the PROBABLE region 4237-4443 by apply_coverage
	; --split [executed in 4 scenarios]
	ld [wConnectDialog_NextMode], a
	ret

ConnectDialog_Input_Keyboard:: ; 57:426B
	farcall Sprite_UpdateAll
	call ConnectDialog_ValidatePassword
	farcall Kbd_Run
	cp a, $01
	jr z, ConnectDialog_Keyboard_AppendChar
	cp a, $0A
	jp z, ConnectDialog_Keyboard_ToSaveConfirmIfValid
	cp a, $07
	jp z, ConnectDialog_Keyboard_ToAccept
	cp a, $09
	jp z, ConnectDialog_Keyboard_ToPasswordPrompt
	cp a, $02
	jp z, ConnectDialog_Keyboard_EraseChar
	cp a, $08
	jp z, ConnectDialog_Keyboard_ToPasswordPrompt

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4237-4443 by apply_coverage --split
	xor a, a
	ret

ConnectDialog_Keyboard_AppendChar:: ; 57:4299
	; [CONFIRMED] 196 insn(s) executed; cut out of the PROBABLE region 4237-4443 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, [wConnectDialogTextLen]
	cp a, $08
	jr z, .l430D
	play_sfx SFX_CHAR_ENTERED
	ld hl, wSpriteSlot2
	ld de, ConnectDialog_ObjTable
	ld a, BANK(ConnectDialog_ObjTable)
	ld b, $03
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot2 + $0B
	ld de, ConnectDialog_ObjHook_Caret
	ld a, BANK(ConnectDialog_ObjHook_Caret)
	call Sprite_SetHook
	call ConnectDialog_PlaceCaretSprites
	call ConnectDialog_DrawPasswordField
	ld a, $F0
	ld hl, wKeyboardCharLo
	call ReadByteFar
	ld b, a
	ld hl, wConnectDialogText
	ld a, [wConnectDialogTextLen]
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld [hl], b
	ld a, b
	farcall Text_HalfToFullWidth
	ld hl, wConnectDialogGlyphs
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
.l430D ; 57:430D
	play_sfx SFX_REJECT
	xor a, a
	ret

ConnectDialog_Keyboard_EraseChar_ToPasswordPrompt:: ; 57:431F
Label_57_431F::
	ld a, $05
	ld [wConnectDialog_NextMode], a
	ret

ConnectDialog_Keyboard_ToSaveConfirmIfValid:: ; 57:4325
Label_57_4325::
	call ConnectDialog_ValidatePassword
	xor a, a
	or a, b
	ld a, $00
	ret z
	ld a, $07
	ld [wConnectDialog_NextMode], a
	ret

ConnectDialog_Keyboard_ToAccept:: ; 57:4333
Label_57_4333::
	ld a, $10
	ld [wConnectDialog_NextMode], a
	ret

ConnectDialog_Keyboard_ToPasswordPrompt:: ; 57:4339
Label_57_4339::
	ld a, $05
	ld [wConnectDialog_NextMode], a
	ret

ConnectDialog_Keyboard_EraseChar:: ; 57:433F
	ld a, [wConnectDialogTextLen]
	or a, a
	jr z, .l438E
	play_sfx SFX_CHAR_ERASED
	call ConnectDialog_DrawPasswordField
	ld a, [wConnectDialogTextLen]
	dec a
	ld [wConnectDialogTextLen], a
	ld hl, wSpriteSlot2
	ld de, ConnectDialog_ObjTable
	ld a, BANK(ConnectDialog_ObjTable)
	ld b, $02
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot2 + $0B
	ld de, ConnectDialog_ObjHook_Caret
	ld a, BANK(ConnectDialog_ObjHook_Caret)
	call Sprite_SetHook
	call ConnectDialog_PlaceCaretSprites
	ld hl, wConnectDialogGlyphs
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
.l438E ; 57:438E
	call ConnectDialog_DrawPasswordField
	xor a, a
	ld [wConnectDialog_FieldDirty], a
	ld hl, wSpriteSlot2
	ld de, ConnectDialog_ObjTable
	ld a, BANK(ConnectDialog_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot2 + $0B
	ld de, ConnectDialog_ObjHook_FollowRaster
	ld a, BANK(ConnectDialog_ObjHook_FollowRaster)
	call Sprite_SetHook
	call ConnectDialog_PlaceCaretSprites
	farcall Kbd_Hide
	jp ConnectDialog_Keyboard_EraseChar_ToPasswordPrompt

ConnectDialog_Input_SaveConfirm:: ; 57:43BC
	bit 5, b
	jr nz, .l43F4
	bit 4, b
	jr nz, .l43F4
	ldh a, [hJoyPressed]
	bit PADB_A, a
	jr nz, .l43D0
	bit PADB_B, a
	jr nz, .l43E2
	xor a, a
	ret
.l43D0 ; 57:43D0
	ld a, $00
	call ConnectDialog_PlayButtonSfx
	ld a, [wConnectDialog_Cursor]
	cp a, $01
	jr nz, .l43E2
	ld a, $08
	ld [wConnectDialog_NextMode], a
	ret
.l43E2 ; 57:43E2
	ld a, $01
	call ConnectDialog_PlayButtonSfx
	ld a, $02
	ld [wConnectDialog_Cursor], a
	ld a, $06
	ld [wConnectDialog_NextMode], a
	ld a, $01
	ret
.l43F4 ; 57:43F4
	ld a, [wConnectDialog_Cursor]
	xor a, $03
	ld [wConnectDialog_Cursor], a
	ld de, $7828
	cp a, $01
	jr z, .skip
	ld de, $7858
.skip ; 57:4406
	ld hl, wSpriteSlot4
	farcall Sprite_SetPosition
	play_sfx SFX_CURSOR_MOVE
	xor a, a
	ret

ConnectDialog_Input_PasswordSaved:: ; 57:4421
	ldh a, [hJoyPressed]
	bit PADB_A, a
	jr nz, .l442D
	bit PADB_B, a
	jr nz, .l4438
	xor a, a
	ret
.l442D ; 57:442D
	ld a, $00
	call ConnectDialog_PlayButtonSfx
	ld a, $10
	ld [wConnectDialog_NextMode], a
	ret
.l4438 ; 57:4438
	ld a, $01
	call ConnectDialog_PlayButtonSfx
	ld a, $07
	ld [wConnectDialog_NextMode], a
	ret

ConnectDialog_Input_StoredPassword:: ; 57:4443
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 5/18 scenarios)
	ldh a, [hJoyPressed]
	bit PADB_A, a
	jr nz, .l4453
	bit PADB_B, a
	jr nz, .l445E
	bit PADB_SELECT, a
	jr nz, .l447B
	xor a, a
	ret
.l4453 ; 57:4453
	ld a, $00
	call ConnectDialog_PlayButtonSfx
	ld a, $10
	ld [wConnectDialog_NextMode], a
	ret
.l445E ; 57:445E
	ld a, $01
	call ConnectDialog_PlayButtonSfx
	ld a, [wConnectDialogArgPtr]
	ld l, a
	ld a, [wConnectDialogArgPtr + 1]
	ld h, a
	ld a, [wConnectDialogArgBank]
	call ReadByteFar
	cp a, $03
	jr nc, .skip

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 57:4473 (executed)
	ld a, $02

.skip ; 57:4477
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)
	ld [wConnectDialog_NextMode], a
	ret

.l447B ; 57:447B
	; [CONFIRMED] 48 insn(s) reached by static flow only; seeds: exec x48; min discovery hops 1;
	; entered by jrcc from 57:444F (executed) [executed in 1 scenarios]
	ld a, $0A
	ld [wConnectDialog_NextMode], a
	ret

ConnectDialog_Input_ForgetConfirm:: ; 57:4481
	bit 5, b
	jr nz, .l44B7
	bit 4, b
	jr nz, .l44B7
	ldh a, [hJoyPressed]
	bit PADB_A, a
	jr nz, .l4495
	bit PADB_B, a
	jr nz, .l44A7
	xor a, a
	ret
.l4495 ; 57:4495
	ld a, $00
	call ConnectDialog_PlayButtonSfx
	ld a, [wConnectDialog_Cursor]
	cp a, $01
	jr nz, .l44A7
	ld a, $05
	ld [wConnectDialog_NextMode], a
	ret
.l44A7 ; 57:44A7
	ld a, $01
	call ConnectDialog_PlayButtonSfx
	ld a, $02
	ld [wConnectDialog_Cursor], a
	ld a, $09
	ld [wConnectDialog_NextMode], a
	ret
.l44B7 ; 57:44B7
	ld a, [wConnectDialog_Cursor]
	xor a, $03
	ld [wConnectDialog_Cursor], a
	ld de, $7828
	cp a, $01
	jr z, .skip
	ld de, $7858
.skip ; 57:44C9
	ld hl, wSpriteSlot4
	farcall Sprite_SetPosition
	play_sfx SFX_CURSOR_MOVE
	xor a, a
	ret

ConnectDialog_EnterMode:: ; 57:44E4
Function_57_44E4::
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 6/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wConnectDialog_Mode]
	cp a, $02
	jr c, .l450F
	jp z, .l4510
	cp a, $04
	jp c, .l4511
	jp z, .l4512
	cp a, $06
	jp c, .l4513
	jp z, ConnectDialog_Enter_Keyboard
	cp a, $08
	jp c, ConnectDialog_Enter_SaveConfirm
	jp z, ConnectDialog_Enter_PasswordSaved
	cp a, $0A
	jp c, ConnectDialog_Enter_StoredPassword

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jpcc at 57:4508 (executed) | 1 insn(s) executed; cut out of the PROBABLE
	; region 450B-4511 by apply_coverage --split [executed in 6 scenarios]
	jp z, ConnectDialog_Enter_ForgetConfirm

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 450B-4511 by apply_coverage --split
	ret
.l450F ; 57:450F
	ret
.l4510 ; 57:4510
	ret

.l4511 ; 57:4511
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 4/18 scenarios)
	ret
.l4512 ; 57:4512
	ret

.l4513 ; 57:4513
	; [CONFIRMED] 56 insn(s) reached by static flow only; seeds: exec x56; min discovery hops 1;
	; entered by jpcc from 57:44F8 (executed) [executed in 3 scenarios]
	call ConnectDialog_DrawPasswordField
	ret

ConnectDialog_Enter_Keyboard:: ; 57:4517
	ld a, $09
	ld [wConnectDialog_RasterOffset], a
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
	ld hl, wSpriteSlot2 + $0B
	ld de, ConnectDialog_ObjHook_FollowRaster
	ld a, BANK(ConnectDialog_ObjHook_FollowRaster)
	call Sprite_SetHook
	ld a, $05
	ld b, $00
	farcall Kbd_Open
	ret

ConnectDialog_Enter_SaveConfirm:: ; 57:4566
Label_57_4566::
	ld hl, wSpriteSlot4
	ld de, ConnectDialog_ObjTable
	ld a, BANK(ConnectDialog_ObjTable)
	ld b, $85
	farcall Sprite_InitSlot
	ld de, $7828
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	play_sfx SFX_DIALOG_OPEN
	ret

ConnectDialog_Enter_PasswordSaved:: ; 57:4590
	ld de, wConnectDialogText
	ld a, [wConnectDialogTextLen]
	call SavedPassword_Store
	ret

ConnectDialog_Enter_StoredPassword:: ; 57:459A
	; [CONFIRMED] 16 insn(s); 16 executed (in up to 5/18 scenarios)
	ld a, $01
	ld hl, sSavedPasswordLen
	call ReadByteFar
	ld [wConnectDialogTextLen], a
	ld c, a
	ld hl, sSavedPasswordText
	ld de, wConnectDialogText
.loop ; 57:45AC
	ld a, $01
	call ReadByteFar
	xor a, $5A
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	call ConnectDialog_DrawPasswordField
	ret

ConnectDialog_Enter_ForgetConfirm:: ; 57:45BC
Label_57_45BC::
	; [CONFIRMED] 17 insn(s) reached by static flow only; seeds: exec x17; min discovery hops 1;
	; entered by jpcc from 57:450B (PROBABLE code) [executed in 4 scenarios]
	ld hl, wSpriteSlot4
	ld de, ConnectDialog_ObjTable
	ld a, BANK(ConnectDialog_ObjTable)
	ld b, $85
	farcall Sprite_InitSlot
	ld de, $7828
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	play_sfx SFX_DIALOG_OPEN
	ret

ConnectDialog_LeaveMode:: ; 57:45E6
Function_57_45E6::
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 6/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wConnectDialog_Mode]
	ld [wConnectDialog_PrevMode], a
	ld b, a
	ld a, [wConnectDialog_NextMode]
	ld [wConnectDialog_Mode], a
	ld a, b
	cp a, $02
	jr c, .l461C
	jp z, .l4642
	cp a, $04
	jp c, .l4668
	jp z, .l468E
	cp a, $06
	jp c, .l46B4
	jp z, ConnectDialog_Leave_Keyboard
	cp a, $08
	jp c, ConnectDialog_Leave_SaveConfirm
	jp z, ConnectDialog_Leave_PasswordSaved
	cp a, $0A
	jp c, ConnectDialog_Leave_StoredPassword

	; [CONFIRMED] 28 insn(s) reached by static flow only; seeds: exec x28; min discovery hops 0;
	; fall-through of the jpcc at 57:4615 (executed) | 1 insn(s) executed; cut out of the PROBABLE
	; region 4618-4668 by apply_coverage --split [executed in 6 scenarios]
	jp z, ConnectDialog_Leave_ForgetConfirm

	; [PROBABLE] 27 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4618-4668 by apply_coverage --split
	ret
.l461C ; 57:461C
	ld a, [wConnectDialog_Cursor]
	dec a
	jr nz, .l4632
	farcall Palette_FadeOutToWhite
	ld de, $00B4
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.l4632 ; 57:4632
	farcall Palette_FadeOutToWhite
	ld de, $00B4
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.l4642 ; 57:4642
	ld a, [wConnectDialog_Cursor]
	dec a
	jr nz, .l4658
	farcall Palette_FadeOutToWhite
	ld de, $00B4
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.l4658 ; 57:4658
	farcall Palette_FadeOutToWhite
	ld de, $00B4
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret

.l4668 ; 57:4668
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)
	ld a, [wConnectDialog_Cursor]
	dec a
	jr nz, .l467E
	farcall Palette_FadeOutToWhite
	ld de, $00B4
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret

.l467E ; 57:467E
	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1;
	; entered by jrcc from 57:466C (executed) [executed in 5 scenarios]
	farcall Palette_FadeOutToWhite
	ld de, $00B4
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret

.l468E ; 57:468E
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 4/18 scenarios)
	ld a, [wConnectDialog_Cursor]
	dec a
	jr nz, .l46A4
	farcall Palette_FadeOutToWhite
	ld de, $00B4
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.l46A4 ; 57:46A4
	farcall Palette_FadeOutToWhite
	ld de, $00B4
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret

.l46B4 ; 57:46B4
	; [CONFIRMED] 73 insn(s) reached by static flow only; seeds: exec x73; min discovery hops 1;
	; entered by jpcc from 57:4605 (executed) [executed in 1 scenarios]
	ld a, [wConnectDialog_Mode]
	cp a, $06
	jr z, .done
	ld de, $00B4
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ld hl, wSpriteSlot2 + $0B
	ld de, $0000
	ld a, $00
	call Sprite_SetHook
	ld de, $00A0
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	farcall Palette_FadeOutToWhite
	ret
.done ; 57:46DF
	ret

ConnectDialog_Leave_Keyboard:: ; 57:46E0
	farcall Kbd_HideInstant
	di
	ldh a, [rSTAT]
	and a, $87
	ldh [rSTAT], a
	ld hl, wLcdStatVector
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
	ld a, [wConnectDialog_Mode]
	cp a, $05
	ret z
	ld de, $00B4
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ld hl, wSpriteSlot2 + $0B
	ld de, $0000
	ld a, $00
	call Sprite_SetHook
	ld de, $00B4
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ld a, [wConnectDialog_Mode]
	cp a, $10
	ret nz
	farcall Palette_FadeOutToWhite
	ret

ConnectDialog_Leave_SaveConfirm:: ; 57:4738
Label_57_4738::
	ld de, $00B4
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ld a, [wConnectDialog_Cursor]
	dec a
	jr nz, .done
	farcall Palette_FadeOutToWhite
	ret
.done ; 57:474E
	ret

ConnectDialog_Leave_PasswordSaved:: ; 57:474F
	ld a, [wConnectDialog_Mode]
	cp a, $07
	jr z, .l475D
	farcall Palette_FadeOutToWhite
	ret
.l475D ; 57:475D
	farcall Palette_FadeOutToWhite
	ld b, $00
	ld a, $01
	ld hl, sSavedPasswordLen
	farcall WriteByteFar
	ret

ConnectDialog_Leave_StoredPassword:: ; 57:4771
Label_57_4771::
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 5/18 scenarios)
	ld a, [wConnectDialog_Mode]
	cp a, $0A
	ret z
	farcall Palette_FadeOutToWhite
	ret

ConnectDialog_Leave_ForgetConfirm:: ; 57:477E
	; [CONFIRMED] 15 insn(s) reached by static flow only; seeds: exec x15; min discovery hops 1;
	; entered by jpcc from 57:4618 (PROBABLE code) [executed in 2 scenarios]
	ld de, $00B4
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ld a, [wConnectDialog_Mode]
	cp a, $09
	jr z, .done
	xor a, a
	ld [wConnectDialogTextLen], a
	ld b, a
	ld a, $01
	ld hl, sSavedPasswordLen
	farcall WriteByteFar
	farcall Palette_FadeOutToWhite
	ret
.done ; 57:47A5
	ret
