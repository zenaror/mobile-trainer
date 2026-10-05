; engine/account/registration_verify.asm
; bank 68, $7019-$733C (803 bytes); pinned by layout.link
; registration verify and finalize online

SECTION "engine/account/registration_verify", ROMX

Registration_VerifyAndFinalizeOnline:: ; 68:7019
	; [CONFIRMED] 47 insn(s); 47 executed (in up to 6/18 scenarios); entry proven: target of an
	; executed call/far call (part of region $7009-$7079)
	call Registration_Verify_Setup
	call Registration_Verify_RunState
	farcall Palette_FadeOutToWhite
	ld a, [wRegistrationVerify_Result]
	ret

Registration_Verify_Setup:: ; 68:7029
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	xor a, a
	ld [wRegistrationVerify_Result], a
	ld [wRegistrationVerify_State], a
	ld a, $00
	farcall CommPanel_SetVariant
	xor a, a
	farcall CommPanel_Init
	ret

Registration_Verify_RunState:: ; 68:7050
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
	ld [wTimerAWarnMinute], a
	xor a, a
	ld [wTimerAWarnFlags], a

Registration_Verify_RunState_Dispatch:: ; 68:7069
Label_68_7069::
	ld a, [wRegistrationVerify_State]
	add a, a
	add a, $79
	ld l, a
	ld a, $70
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- ptrtable $7079-$708D (20 bytes) [CONFIRMED] code-pointer table, 10 entries: 10/10 words hit own-bank code starts (survey pointer-table extent); 10/10 targets executed; every byte read as data in a trace

Registration_Verify_StateTable:: ; 68:7079
Table_68_7079::
	dw Registration_Verify_StateInit
	dw Registration_Verify_StateReadLoginId
	dw Registration_Verify_StateReadDialSlots
	dw Registration_Verify_StateReadMailAddress
	dw Registration_Verify_StateIspLogin
	dw Registration_Verify_StatePopLogin
	dw Registration_Verify_StateAfterPopLogin
	dw Registration_Verify_StateHangUp
	dw Registration_Verify_StateWriteConfig
	dw Registration_Verify_StateFinish

Registration_Verify_StateInit:: ; 68:708D
	; [CONFIRMED] 134 insn(s); 134 executed (in up to 3/18 scenarios)
	xor a, a
	farcall CommPanel_Step
	ld de, $C271
	ld hl, $0068
	ld a, $02
	call MobileAPI
	ld a, $01
	ld [wRegistrationVerify_State], a
	jr Registration_Verify_RunState_Dispatch

Registration_Verify_StateReadLoginId:: ; 68:70A6
	xor a, a
	farcall CommPanel_Step
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Registration_Verify_OnAdapterError
	bit 0, a
	jp nz, Registration_Verify_RunState_Dispatch
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld de, $A200
	ld a, $0E
	call MobileAPI
	ld a, $02
	ld [wRegistrationVerify_State], a
	jp Registration_Verify_RunState_Dispatch

Registration_Verify_StateReadDialSlots:: ; 68:70E5
	xor a, a
	farcall CommPanel_Step
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Registration_Verify_OnAdapterError
	bit 0, a
	jp nz, Registration_Verify_RunState_Dispatch
	ld de, $A222
	ld a, $0C
	call MobileAPI
	ld a, $03
	ld [wRegistrationVerify_State], a
	jp Registration_Verify_RunState_Dispatch

Registration_Verify_StateReadMailAddress:: ; 68:7109
	xor a, a
	farcall CommPanel_Step
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Registration_Verify_OnAdapterError
	bit 0, a
	jp nz, Registration_Verify_RunState_Dispatch
	ld de, $A244
	ld a, $10
	call MobileAPI
	ld a, $04
	ld [wRegistrationVerify_State], a
	jp Registration_Verify_RunState_Dispatch

Registration_Verify_StateIspLogin:: ; 68:712D
	xor a, a
	farcall CommPanel_Step
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Registration_Verify_OnAdapterError
	bit 0, a
	jp nz, Registration_Verify_RunState_Dispatch
	ld hl, $A222
	ld de, $A100
	call CopyString
	ld hl, $A200
	call CopyString
	ld hl, $DEB9
	call CopyString
	ld hl, $A100
	ld a, $06
	call MobileAPI
	ld a, $05
	ld [wRegistrationVerify_State], a
	jp Registration_Verify_RunState_Dispatch

Registration_Verify_StatePopLogin:: ; 68:7166
	xor a, a
	farcall CommPanel_Step
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Registration_Verify_OnAdapterError
	bit 0, a
	jp nz, Registration_Verify_RunState_Dispatch
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $A244
	ld de, $A100
	call CopyString
	ld hl, $DEB9
	call CopyString
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, $05
	ld [wCommTimeoutMinutes], a
	ld hl, $C266
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, $A100
	ld a, $1E
	call MobileAPI
	ld a, $06
	ld [wRegistrationVerify_State], a
	ld a, $01
	farcall CommPanel_DrawCaption
	jp Registration_Verify_RunState_Dispatch

Registration_Verify_StateAfterPopLogin:: ; 68:71C3
	xor a, a
	farcall CommPanel_Step
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l7210
	ld hl, $C26F
	bit 0, [hl]
	jr nz, .l7211
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l7210

	; [PROBABLE] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 0;
	; fall-through of the jrcc at 68:71E1 (executed)
	jr nz, .l71EC
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l7210
.l71EC ; 68:71EC
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l71FC
	ld hl, $C26F
	bit 1, [hl]
	jr nz, .l7210
	set 1, [hl]
.l71FC ; 68:71FC
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, .l7211
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l7211

.l7210 ; 68:7210
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 3/18 scenarios)
	xor a, a
.l7211 ; 68:7211
	pop hl
	or a, a
	jp nz, Registration_Verify_OnTimeLimit
	ld a, [wCommTimeoutMinutes]
	ld b, a
	ld a, [wTimerBMinutes]
	cp a, b
	jr z, .l7223
	xor a, a
	jr .l7225

.l7223 ; 68:7223
	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by jrcc from 68:721E (executed)
	ld a, $FF

.l7225 ; 68:7225
	; [CONFIRMED] 33 insn(s); 33 executed (in up to 3/18 scenarios)
	or a, a
	jp nz, Registration_Verify_OnTimeout
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Registration_Verify_OnAdapterError
	bit 0, a
	jp nz, Registration_Verify_RunState_Dispatch
	ld a, $05
	ld [wCommTimeoutMinutes], a
	ld hl, $C266
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $1C
	call MobileAPI
	ld a, $07
	ld [wRegistrationVerify_State], a
	jp Registration_Verify_RunState_Dispatch

Registration_Verify_StateHangUp:: ; 68:724F
	xor a, a
	farcall CommPanel_Step
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l729C
	ld hl, $C26F
	bit 0, [hl]
	jr nz, .l729D
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l729C

	; [PROBABLE] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 0;
	; fall-through of the jrcc at 68:726D (executed)
	jr nz, .l7278
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l729C
.l7278 ; 68:7278
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l7288
	ld hl, $C26F
	bit 1, [hl]
	jr nz, .l729C
	set 1, [hl]
.l7288 ; 68:7288
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, .l729D
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l729D

.l729C ; 68:729C
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 2/18 scenarios)
	xor a, a
.l729D ; 68:729D
	pop hl
	or a, a
	jp nz, Registration_Verify_OnTimeLimit
	ld a, [wCommTimeoutMinutes]
	ld b, a
	ld a, [wTimerBMinutes]
	cp a, b
	jr z, .l72AF
	xor a, a
	jr .l72B1

.l72AF ; 68:72AF
	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by jrcc from 68:72AA (executed)
	ld a, $FF

.l72B1 ; 68:72B1
	; [CONFIRMED] 37 insn(s); 37 executed (in up to 2/18 scenarios)
	or a, a
	jp nz, Registration_Verify_OnTimeout
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Registration_Verify_OnAdapterError
	bit 0, a
	jp nz, Registration_Verify_RunState_Dispatch
	ld a, $0A
	call MobileAPI
	ld a, $08
	ld [wRegistrationVerify_State], a
	ld a, $02
	farcall CommPanel_DrawCaption
	jp Registration_Verify_RunState_Dispatch

Registration_Verify_StateWriteConfig:: ; 68:72D7
	xor a, a
	farcall CommPanel_Step
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Registration_Verify_OnAdapterError
	bit 0, a
	jp nz, Registration_Verify_RunState_Dispatch
	ld hl, $A002
	ld a, [hl]
	set 7, a
	ld [hl], a
	ld hl, $A003
	xor a, a
	ld [hl], a
	farcall Config_MirrorUpdateChecksum
	ld c, $C0
	ld hl, $A000
	ld de, $0000
	ld a, $04
	call MobileAPI
	ld a, $09
	ld [wRegistrationVerify_State], a
	jp Registration_Verify_RunState_Dispatch

	; [HYPOTHESIS] single ret between two proven code regions (after the jp at 730F..); nothing
	; branches to it
	ret

Registration_Verify_StateFinish:: ; 68:7313
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 3/18 scenarios) (part of region $7313-$734D)
	xor a, a
	farcall CommPanel_Step
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Registration_Verify_OnAdapterError
	bit 0, a
	jp nz, Registration_Verify_RunState_Dispatch
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $36
	call MobileAPI
