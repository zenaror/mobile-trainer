; lib/mobile/main.asm
; bank 75, $4000-$7F46 (16198 bytes); pinned by layout.link
; Mobile Adapter GB SDK (= Crystal bank 44 lib/mobile/main.asm): API dispatch, serial/timer pump, state machine, protocols, MD5, Base64

SECTION "lib/mobile/main", ROMX

MobileSDK_CopyBytes:: ; 75:4000
Function_75_4000::
	; [CONFIRMED] 76 insn(s); 76 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, MobileSDK_CopyBytes
	ret

MobileSDK_CopyString:: ; 75:4007
	ld a, [hli]
	ld [de], a
	or a, a
	ret z
	inc de
	inc bc
	jr MobileSDK_CopyString

MobileSDK_CopyStringLen:: ; 75:400F
	push bc
	ld c, $00
	ld b, a
	dec b
.loop ; 75:4014
	ld a, [hli]
	ld [de], a
	or a, a
	jr z, .l4020
	inc de
	inc c
	dec b
	jr nz, .loop
	xor a, a
	ld [de], a
.l4020 ; 75:4020
	ld a, c
	pop bc
	add a, c
	ld c, a
	ld a, b
	adc a, $00
	ld b, a
	ret

Mobile_ResetReceivePacketBuffer:: ; 75:4029
	xor a, a
	ld hl, $C8D7
	ld [hli], a
	ld [hl], a
	ret

MobileSDK_ApiDispatch:: ; 75:4030
	push de
	ld a, [wMobileAPIIndex]
	cp a, $0C
	jr z, .l4047
	cp a, $0E
	jr z, .l4047
	cp a, $10
	jr z, .l4047
	xor a, a
	ld [wMobileSDK_ConfigCached], a
	ld a, [wMobileAPIIndex]
.l4047 ; 75:4047
	ld d, $00
	ld e, a
	ld hl, MobileSDK_ApiTable
	add hl, de
	ld a, [hli]
	ld [wMobileAPIIndex], a
	ld a, [hl]
	pop de
	ld hl, $018D
	push hl
	ld h, a
	ld a, [wMobileAPIIndex]
	ld l, a
	push hl
	ld a, $35
	cp a, l
	jr nz, .skip
	ld a, $42
	cp a, h
.skip ; 75:4066
	call nz, MobileSDK_WaitStatusPoll
	ld hl, $C823
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

; ---- ptrtable $4070-$40B4 (68 bytes) [PROBABLE] code-pointer table, 34 entries: 34/34 words hit own-bank code starts (start is the operand of ld r16); 18/34 targets executed

MobileSDK_ApiTable:: ; 75:4070
Table_75_4070::
	dw MobileAPI_PollResult
	dw MobileAPI_Init
	dw MobileAPI_WriteConfig
	dw MobileAPI_ConnectIsp
	dw MobileAPI_Dial
	dw MobileAPI_Disconnect
	dw MobileAPI_ReadDialSlots
	dw MobileAPI_ReadLoginId
	dw MobileAPI_ReadMailAddress
	dw MobileAPI_WaitForCall
	dw MobileAPI_SmtpConnect
	dw MobileAPI_SmtpMailFrom
	dw MobileAPI_SmtpData
	dw MobileAPI_SmtpQuit
	dw MobileAPI_Pop3Quit
	dw MobileAPI_Pop3Login
	dw MobileAPI_Pop3Stat
	dw MobileAPI_Pop3List
	dw MobileAPI_Pop3Retr
	dw MobileAPI_Pop3Dele
	dw MobileAPI_Pop3Top
	dw MobileAPI_HttpGet
	dw MobileAPI_HttpPost
	dw MobileAPI_PeerSend
	dw MobileAPI_SetTimer
	dw MobileAPI_TelephoneStatus
	dw MobileAPI_Abort
	dw MobileAPI_Reset
	dw MobileAPI_ReadConfig
	dw MobileAPI_PeerReceive
	dw Label_75_561D
	dw MobileAPI_ConnectIspDns
	dw MobileAPI_InitAlias
	dw MobileAPI_TelephoneStatusAlias

MobileSDK_WaitStatusPoll:: ; 75:40B4
Function_75_40B4::
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
.loop ; 75:40B5
	di
	ld a, [wMobileSDK_SerialPhase]
	ld b, a
	ld a, [wMobileSDK_RxStage]
	ld c, a
	ld a, [wMobileFlags]
	ei
	or a, a
	bit 0, a
	jr z, .l40DA

	; [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 0;
	; fall-through of the jrcc at 75:40C5 (executed) | 3 insn(s) executed; cut out of the PROBABLE
	; region 40C7-40DA by apply_coverage --split [executed in 9 scenarios]
	ld a, b
	or a, a
	jr nz, .loop

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 40C7-40DA by apply_coverage --split
	ld a, c
	cp a, $04
	jr z, .loop
	xor a, a
	ld [wMobileSDK_ErrorCode], a
	ld hl, $C69F
	set 1, [hl]
	scf

.l40DA ; 75:40DA
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 18/18 scenarios)
	pop bc
	ret

MobileAPI_SetTimer:: ; 75:40DC
	xor a, a
	ldh [rTAC], a
	ld e, c
	ld b, a
	ld hl, MobileSDK_TimingTable
	add hl, bc
	ld c, [hl]
	inc hl
	ldh a, [rKEY1]
	bit 7, a
	jr nz, .l40F9

	; [PROBABLE] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0;
	; fall-through of the jrcc at 75:40EB (executed)
	ld a, e
	sra c
	ld a, e
	cp a, $04
	jr nc, .l40F9
	ld de, $000F
	add hl, de

.l40F9 ; 75:40F9
	; [CONFIRMED] 18 insn(s); 18 executed (in up to 18/18 scenarios)
	ld a, c
	ldh [rTMA], a
	ldh [rTIMA], a
	ld a, [hli]
	ld [wMobileSDK_TimeoutReload], a
	ld [wMobileSDK_TimeoutCounter + 1], a
	ld a, [hl]
	ld [wMobileSDK_TimeoutReload + 1], a
	ld [wMobileSDK_TimeoutCounter], a
	ld c, $07
	ld a, $02
	ldh [c], a
	ld a, $06
	ldh [c], a
	ret

MobileAPI_PollResult:: ; 75:4115
	ld hl, $C69F
	bit 1, [hl]
	jr nz, .l4120

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 75:411A (executed)
	xor a, a
	ld l, a
	ld h, a
	ret

.l4120 ; 75:4120
	; [CONFIRMED] 25 insn(s); 25 executed (in up to 4/18 scenarios)
	res 1, [hl]
	ld a, [wMobileSDK_ErrorCode]
	ld e, a
	cp a, $22
	jr z, .l416A
	cp a, $23
	jr z, .l416A
	cp a, $25
	jr z, .l416A
	cp a, $26
	jr z, .l418E
	cp a, $24
	jr z, .l41A4
	cp a, $30
	jp z, .l41F7
	cp a, $31
	jp z, .l420C
	cp a, $32
	jr z, .l41A4
	cp a, $33
	jr z, .l41A4
	swap a
	and a, $0F
	cp a, $01
	jr z, .l416A

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:4152 (executed) [executed in 6 scenarios]
	cp a, $00
	jr z, .l415D

.l4158 ; 75:4158
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 4/18 scenarios)
	ld hl, $0000
.l415B ; 75:415B
	ld a, e
	ret

.l415D ; 75:415D
	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1;
	; entered by jrcc from 75:4156 (PROBABLE code)
	ld a, e
	add a, $15
	ld e, a
	xor a, a
	ld hl, $C6B0
	ld [hli], a
	ld [hl], a
	ld hl, $C69F

.l416A ; 75:416A
	; [CONFIRMED] 18 insn(s); 18 executed (in up to 2/18 scenarios)
	xor a, a
	ld [wMobileSDK_ConnectionFlag], a
	ld [hl], a
	ld [wMobileSDK_PhaseCode], a
	inc a
	ld [wMobileSDK_State], a
	ld hl, $C6C1
	res 0, [hl]
	res 5, [hl]
	ld hl, $C9E4
	xor a, a
	ld [hli], a
	inc a
	ld [hl], a
	call MobileSDK_StopLink
	ld a, $15
	cp a, e
	jr nz, .l4158

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 1;
	; fall-through of the jrcc at 75:418A (executed)
	jr .l41D6
.l418E ; 75:418E
	ld a, [wTimerEnable]
	bit 4, a
	ld a, $01
	jr z, .l416A
	ld a, $02
	ld [wMobileSDK_State], a
	ld a, [wMobileSDK_PrevPhaseCode]
	ld [wMobileSDK_PhaseCode], a
	jr .l4158

.l41A4 ; 75:41A4
	; [CONFIRMED] 33 insn(s); 33 executed (in up to 2/18 scenarios)
	res 0, [hl]
	ld hl, $C6C1
	res 5, [hl]
	ld hl, $C69F
	res 7, [hl]
	res 6, [hl]
	set 5, [hl]
	xor a, a
	ld [wMobileSDK_ConnectionFlag], a
	ld [wMobileSDK_OpenTcpRetries], a
	ld a, $02
	ld [wMobileSDK_State], a
	ld a, $04
	ld [wMobileSDK_PhaseCode], a
	ld a, e
	cp a, $32
	jr z, .l41D6
	cp a, $33
	jr z, .l41D6
	cp a, $30
	jr z, .l41D6
	cp a, $31
	jr nz, .l4158
.l41D6 ; 75:41D6
	ld hl, $C6B0
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $32
	cp a, e
	jp nz, .l415B
	ld a, $03
	cp a, h
	jp nz, .l415B

	; [CONFIRMED] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 0;
	; fall-through of the jpcc at 75:41E5 (executed) [executed in 1 scenarios]
	dec a
	cp a, l
	jr z, .l41F1
	dec a
	cp a, l
	jp nz, .l415B
.l41F1 ; 75:41F1
	ld bc, $C71F
	jp .l415B
.l41F7 ; 75:41F7
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $A4
	jr z, .l41A4
	ld a, $03
	ld [wMobileSDK_State], a
	ld hl, $C6B0
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp .l415B
.l420C ; 75:420C
	ld a, [wMobileSDK_ErrorInfo]
	cp a, $02
	jr z, .l41A4
	cp a, $03
	jr z, .l41A4
	ld a, $04
	ld [wMobileSDK_State], a
	ld hl, $C6B0
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp .l415B

MobileSDK_ErrBusy:: ; 75:4225
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 3/18 scenarios)
	ld a, $21

MobileSDK_SetErrorEvent:: ; 75:4227
	ld [wMobileSDK_ErrorCode], a
	ld hl, $C69F
	set 1, [hl]
	ret

MobileSDK_ErrBadArg:: ; 75:4230
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x2, mobile x1; min discovery
	; hops 0; entered by jp from 75:43D8 (PROBABLE code)
	ld a, $20
	jr MobileSDK_SetErrorEvent

MobileAPI_InitAlias:: ; 75:4234
	nop

MobileAPI_Init:: ; 75:4235
	; [CONFIRMED] 44 insn(s); 44 executed (in up to 18/18 scenarios)
	ld a, [wMobileAPIIndex]
	push af
	push bc
	push hl
	xor a, a
	ldh [rTAC], a
	ldh a, [rIF]
	and a, $1B
	ldh [rIF], a
	call Mobile_ResetReceivePacketBuffer
	ld bc, $0450
	ld hl, $C69F
.loop ; 75:424D
	xor a, a
	ld [hli], a
	dec bc
	ld a, c
	or a, b
	jr nz, .loop
	ld a, [wMobileFlags]
	set 6, a
	ld [wMobileFlags], a
	pop hl
	ld a, l
	ldh [hROMBankLo], a
	ld a, h
	ldh [hROMBankHi], a
	pop bc
	ld hl, $C820
	ld a, c
	ld [hli], a
	ld a, b
	ld [hl], a
	ld hl, $C70D
	ld a, e
	ld [hli], a
	ld [hl], d
	xor a, a
	ld [wMobileSDK_RetryCount], a
	ld c, $0C
	call MobileAPI_SetTimer
	call MobileSDK_StartIdlePolling
	pop af
	cp a, $34
	jr nz, .l4286

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:4280 (executed)
	ld a, $2B
	jr .l4288

.l4286 ; 75:4286
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 18/18 scenarios)
	ld a, $0A
.l4288 ; 75:4288
	ld [wMobileSDK_State], a
	jp MobileSDK_SetBusy

MobileAPI_WriteConfig:: ; 75:428E
	ld a, [wTimerEnable]
	bit 1, a
	jr z, .l42A3

	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 75:4293 (executed)
	ld a, [wMobileSDK_ErrorCode]
	cp a, $14
	jr z, .l42B0
	cp a, $25
	jr z, .l42B0
	ld a, [wTimerEnable]

.l42A3 ; 75:42A3
	; [CONFIRMED] 39 insn(s); 39 executed (in up to 4/18 scenarios)
	bit 0, a
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_State]
	cp a, $01
	jp nz, MobileSDK_ErrBusy
.l42B0 ; 75:42B0
	xor a, a
	ldh [rTAC], a
	xor a, a
	ld [wMobileSDK_RetryCount], a
	ld a, l
	ld b, h
	ld hl, $C71F
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
	ld a, [wMobileSDK_TimingOffset]
	ld c, a
	call MobileAPI_SetTimer
	ld hl, $C6C8
	ld a, $11
	ld [hli], a
	ld a, $C7
	ld [hl], a
	ld de, $C9E4
	ld b, $05
	ld hl, $6059
	call MobileSDK_CopyBytes
	ld a, [wMobileSDK_Window + 2]
	ld c, a
	or a, a
	jr z, .l42EF
	cp a, $80
	jr nc, .l42EF

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:42E9 (executed)
	ld c, $80
	jr .l42F1

.l42EF ; 75:42EF
	; [CONFIRMED] 75 insn(s); 75 executed (in up to 17/18 scenarios)
	ld a, $80
.l42F1 ; 75:42F1
	ld b, a
	inc a
	ld [de], a
	inc de
	ld a, $80
	add a, c
	ld hl, $C721
	ld [hli], a
	ld a, [hl]
	ld [de], a
	inc de
	add a, $80
	ld [hl], a
	ld hl, $C71F
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld c, b
	call MobileSDK_CopyBytes
	ld a, l
	ld [wMobileSDK_Window], a
	ld a, h
	ld [wMobileSDK_Window + 1], a
	ld b, c
	inc b
	call Mobile_PacketBuildFooter
	call MobileSDK_StartIdlePolling
	ld a, $2E
	ld [wMobileSDK_State], a
	ld hl, $C69F
	res 1, [hl]
	set 0, [hl]
	ret

MobileAPI_ReadConfig:: ; 75:4329
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, MobileSDK_ErrBusy
	bit 0, a
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_State]
	cp a, $01
	jp nz, MobileSDK_ErrBusy
	xor a, a
	ldh [rTAC], a
	ld [wMobileSDK_RetryCount], a
	ld hl, $C71F
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld hl, $C6C8
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
	ld a, [wMobileSDK_TimingOffset]
	ld c, a
	call MobileAPI_SetTimer
	ld de, $C9E4
	ld b, $06
	ld hl, $6041
	call MobileSDK_CopyBytes
	ld a, [wMobileSDK_Window + 3]
	ld [de], a
	inc de
	ld a, [wMobileSDK_Window + 2]
	ld c, a
	or a, a
	jr z, .l437C
	cp a, $80
	jr nc, .l437C

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:4376 (executed)
	ld c, $80
	jr .l437E

.l437C ; 75:437C
	; [CONFIRMED] 25 insn(s); 25 executed (in up to 18/18 scenarios)
	ld a, $80
.l437E ; 75:437E
	ld [de], a
	inc de
	ld b, $02
	call Mobile_PacketBuildFooter
	call MobileSDK_StartIdlePolling
	ld a, $2D
	ld [wMobileSDK_State], a
	jp MobileSDK_SetBusy

MobileSDK_EnableSerialTimerIrq:: ; 75:4390
	ld c, $FF
	ldh a, [c]
	or a, $0C
	ldh [c], a
	ret

MobileSDK_ValidateStringLen:: ; 75:4397
	ld b, $00
.loop ; 75:4399
	inc b
	jr z, .l43A0
	ld a, [hli]
	or a, a
	jr nz, .loop
.l43A0 ; 75:43A0
	ld a, b
	cp a, c
	jr nc, .l43A7
	cp a, $02
	ret

.l43A7 ; 75:43A7
	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by jrcc from 75:43A2 (executed)
	scf
	ret

MobileAPI_ConnectIspDns:: ; 75:43A9
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 7/18 scenarios)
	ld de, $C6D5
	ld b, $08
	call MobileSDK_CopyBytes

MobileAPI_ConnectIsp:: ; 75:43B1
	ld a, [wTimerEnable]
	bit 0, a
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_State]
	cp a, $01
	jp nz, MobileSDK_ErrBusy
	push hl
	ld c, $15
	call MobileSDK_ValidateStringLen
	jr c, .l43D7
	ld c, $22
	call MobileSDK_ValidateStringLen
	jr c, .l43D7
	ld c, $12
	call MobileSDK_ValidateStringLen
	jr nc, .l43DB

.l43D7 ; 75:43D7
	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; entered by jrcc from 75:43C7 (executed)
	pop hl
	jp MobileSDK_ErrBadArg

.l43DB ; 75:43DB
	; [CONFIRMED] 48 insn(s); 48 executed (in up to 18/18 scenarios)
	xor a, a
	ldh [rTAC], a
	ld [wMobileSDK_ConnectionFlag], a
	ld [wRam_C819], a
	ld a, [wMobileSDK_TimingOffset]
	ld c, a
	call MobileAPI_SetTimer
	ld hl, $C6C8
	ld a, $1F
	ld [hli], a
	ld a, $C7
	ld [hl], a
	call Mobile_DialTelephone
	push hl
	ld b, a
	call Mobile_PacketBuildFooter
	ld b, $05
	ld hl, $6032
	ld de, $CA11
	call MobileSDK_CopyBytes
	inc de
	inc de
	pop hl
	ld bc, $0000
	call MobileSDK_CopyString
	ld a, c
	ld [wMobileSDK_PacketBuffer + 51], a
	ld [wMobileSDK_Substep], a
	push de
	inc de
	ld bc, $0000
	ld a, $20
	call MobileSDK_CopyStringLen
	ld l, e
	ld h, d
	pop de
	ld a, c
	ld [de], a
	ld a, [wMobileSDK_Substep]
	add a, c
	add a, $0A
	ld [wMobileSDK_PacketBuffer + 50], a
	call MobileSDK_StartIdlePolling
	ld a, $0B
	ld [wMobileSDK_State], a

MobileSDK_SetBusy:: ; 75:4437
	ld hl, $C69F
	set 0, [hl]
	ret

MobileAPI_Dial:: ; 75:443D
	; [PROBABLE] 37 insn(s) reached by static flow only; seeds: mobile x37; min discovery hops 0;
	; run starts at SDK/API table entry api08 (analysis/mobile_candidates.json)
	ld a, [wTimerEnable]
	bit 0, a
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_State]
	cp a, $01
	jp nz, MobileSDK_ErrBusy
	push hl
	ld c, $15
	call MobileSDK_ValidateStringLen
	jr nc, .l4459
	pop hl
	jp MobileSDK_ErrBadArg
.l4459 ; 75:4459
	xor a, a
	ldh [rTAC], a
	ld [wRam_C819], a
	ld a, [wMobileSDK_TimingOffset]
	ld c, a
	call MobileAPI_SetTimer
	ld hl, $C82C
	ld a, $20
	ld [hli], a
	ld a, $C7
	ld [hli], a
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $FF
	ld [wMobileSDK_ResultPointer], a
	call Mobile_DialTelephone
	ld b, a
	call Mobile_PacketBuildFooter
	call MobileSDK_StartIdlePolling
	ld a, $0C
	ld [wMobileSDK_State], a
	jr MobileSDK_SetBusy

Mobile_DialTelephone:: ; 75:448A
Function_75_448A::
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 7/18 scenarios); entry proven: target of an
	; executed call/far call
	ld de, $C9E4
	ld hl, $6018
	ld b, $06
	call MobileSDK_CopyBytes
	pop bc
	pop hl
	push bc
	ld a, [wMobileSDK_AdapterType]
	cp a, $8C
	jr c, .l44A3

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:449D (executed)
	ld a, $03
	jr .l44A6

.l44A3 ; 75:44A3
	; [CONFIRMED] 45 insn(s); 45 executed (in up to 18/18 scenarios)
	ld a, [wMobileSDK_DialAdapterByte]
.l44A6 ; 75:44A6
	ld [de], a
	inc de
	ld bc, $0001
	ld a, $14
	call MobileSDK_CopyStringLen
	ld a, c
	ld [wMobileSDK_PacketBuffer + 5], a
	ret

MobileSDK_StartIdlePolling:: ; 75:44B5
	xor a, a
	ld [wMobileSDK_SendCommandID], a
	call MobileSDK_EnableSerialTimerIrq
	xor a, a
	ld [wMobileSDK_Substep], a
	ld de, $0001
	ld hl, $5FFB
	ld b, $01
	jp Mobile_PacketSendBytes

MobileAPI_Disconnect:: ; 75:44CB
	ld a, [wTimerEnable]
	bit 0, a
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_State]
	cp a, $04
	jr z, .l452B
	cp a, $03
	jr z, .l452B
	cp a, $02
	jp nz, MobileSDK_ErrBusy
	ld hl, $C6C1
	bit 4, [hl]
	jr nz, .l450C
	ld a, $02
	ld [wMobileSDK_Substep], a
	ld a, $A2
	ld [wMobileSDK_SendCommandID], a
	ld de, $000A
	ld hl, $6037
	ld b, $05
	call Mobile_PacketSendBytes
.loop ; 75:44FF
	ld a, $0E
	ld [wMobileSDK_State], a
	ld hl, $C69F
	set 0, [hl]
	res 3, [hl]
	ret

.l450C ; 75:450C
	; [PROBABLE] 15 insn(s) reached by static flow only; seeds: exec x15; min discovery hops 1;
	; entered by jrcc from 75:44E8 (executed)
	ld a, [wMobileSDK_PhaseCode]
	or a, a
	jr nz, .l4524
	ld a, $01
	ld [wMobileSDK_State], a
	ld hl, $C6C1
	res 4, [hl]
	ld hl, $C69F
	ld a, [hl]
	and a, $17
	ld [hl], a
	ret
.l4524 ; 75:4524
	ld a, $02
	ld [wMobileSDK_Substep], a
	jr .loop

.l452B ; 75:452B
	; [CONFIRMED] 39 insn(s); 39 executed (in up to 7/18 scenarios)
	call Function_75_673A
	xor a, a
	ld [wMobileSDK_Substep], a
	ld de, $CA04
	ld hl, MobilePacket_TransferData
	ld b, $06
	call MobileSDK_CopyBytes
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	ld b, $01
	call Mobile_PacketBuildFooter
	ld de, $C9E4
	ld hl, MobilePacket_TransferData
	ld b, $05
	call MobileSDK_CopyBytes
	ld a, $07
	ld [de], a
	inc de
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	ld bc, $0001
	ld hl, $60BC
	call MobileSDK_CopyString
	ld b, c
	call Mobile_PacketBuildFooter
	ld a, $95
	ld [wMobileSDK_SendCommandID], a
	ld hl, $C9E4
	ld b, $05
	call Mobile_PacketSendBytes
	ld a, $0E
	ld [wMobileSDK_State], a
	jp MobileSDK_SetBusy

MobileAPI_ReadDialSlots:: ; 75:457D
	ld b, $25
	call MobileSDK_StartConfigRead
	or a, a
	jp nz, MobileSDK_ExportDialSlots

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jpcc at 75:4583 (executed)
	ret

MobileAPI_ReadLoginId:: ; 75:4587
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 8/18 scenarios)
	ld b, $26
	call MobileSDK_StartConfigRead
	or a, a
	jp nz, MobileSDK_ExportLoginId
	ret

MobileAPI_ReadMailAddress:: ; 75:4591
	ld b, $27
	call MobileSDK_StartConfigRead
	or a, a
	jp nz, MobileSDK_ExportMailAddress

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jpcc at 75:4597 (executed)
	ret

MobileSDK_StartConfigRead:: ; 75:459B
Function_75_459B::
	; [CONFIRMED] 32 insn(s); 32 executed (in up to 8/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wTimerEnable]
	bit 0, a
	jr nz, .l45DE
	ld a, [wMobileSDK_State]
	cp a, $01
	jr nz, .l45DE
	ld a, [wMobileSDK_ConfigCached]
	or a, a
	ret nz
	ld a, b
	ld [wRam_C9D3], a
	xor a, a
	ldh [rTAC], a
	ld a, e
	ld [wMobileSDK_ResultPointer], a
	ld a, d
	ld [wMobileSDK_ResultPointer + 1], a
	xor a, a
	ld [wMobileSDK_RetryCount], a
	ld a, [wMobileSDK_TimingOffset]
	ld c, a
	call MobileAPI_SetTimer
	ld hl, $C6C8
	ld a, $1F
	ld [hli], a
	ld a, $C7
	ld [hl], a
	call MobileSDK_StartIdlePolling
	ld a, [wRam_C9D3]
	ld [wMobileSDK_State], a
	xor a, a
	jp MobileSDK_SetBusy

.l45DE ; 75:45DE
	; [PROBABLE] 29 insn(s) reached by static flow only; seeds: exec x2, mobile x27; min discovery
	; hops 0; entered by jrcc from 75:45A0 (executed)
	pop hl
	jp MobileSDK_ErrBusy

MobileAPI_WaitForCall:: ; 75:45E2
	ld a, [wTimerEnable]
	bit 0, a
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_State]
	cp a, $01
	jp nz, MobileSDK_ErrBusy
	xor a, a
	ldh [rTAC], a
	ld a, [wMobileSDK_TimingOffset]
	ld c, a
	call MobileAPI_SetTimer
	ld hl, $C82C
	ld a, $20
	ld [hli], a
	ld a, $C7
	ld [hli], a
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $FF
	ld [wMobileSDK_ResultPointer], a
	call MobileSDK_StartIdlePolling
	ld a, $0D
	ld [wMobileSDK_State], a
	jp MobileSDK_SetBusy

MobileSDK_DnsAndTcpOpen:: ; 75:461A
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 7/18 scenarios)
	ld b, $15
	ld [wMobileSDK_ResultPointer], a
	or a, a
	jr z, .l462A
	dec a
	jr z, .l4631
	dec a
	jp z, .l46C6

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jpcc at 75:4626 (executed) | 1 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 4629-4631 by apply_coverage --split
	ret

.l462A ; 75:462A
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 4629-4631 by apply_coverage
	; --split [executed in 7 scenarios]
	ld a, $19
	ld hl, $C6DD
	jr .l4636

.l4631 ; 75:4631
	; [CONFIRMED] 44 insn(s); 44 executed (in up to 7/18 scenarios)
	ld a, $6E
	ld hl, $C6F1
.l4636 ; 75:4636
	push hl
	push bc
	ld [wMobileSDK_PacketBuffer + 91], a
	ld hl, $C6C8
	ld a, $3A
	ld [hli], a
	ld a, $CA
	ld [hl], a
	xor a, a
	ld [wMobileSDK_PacketBuffer + 90], a
	ld [wMobileSDK_Substep], a
	ld [wMobileSDK_OpenTcpRetries], a
	ld de, $CA34
	ld hl, MobilePacket_OpenTCPConnection
	ld b, $06
	call MobileSDK_CopyBytes
	ld de, $C9E4
	ld hl, $605E
	ld b, $05
	call MobileSDK_CopyBytes
	pop bc
	pop hl
	push de
	inc de
	ld a, b
	ld bc, $0000
	call MobileSDK_CopyStringLen
	ld a, c
	pop hl
	ld [hl], a
	ld b, c
	call Mobile_PacketBuildFooter
	ld a, [wMobileSDK_ResultPointer]
	cp a, $02
	jr nz, .l46B1
	ld a, [wMobileSDK_ReceivePacketBuffer + 128]
	or a, a
	jr z, .l46B1
	ld hl, $C832
	ld a, [hli]
	cp a, $99
	jr nz, .l46B1

	; [PROBABLE] 17 insn(s) reached by static flow only; seeds: exec x17; min discovery hops 0;
	; fall-through of the jrcc at 75:4689 (executed)
	ld a, [hli]
	cp a, $66
	jr nz, .l46B1
	ld a, [hli]
	cp a, $23
	jr nz, .l46B1
	ld a, $02
	ld [wMobileSDK_ResultPointer], a
	dec a
	ld [wMobileSDK_Substep], a
	ld a, $A3
	ld de, $0010
	ld hl, $C832
	call Mobile_PacketSendExpect
	ld a, $0F
	ld [wMobileSDK_State], a
	jp MobileSDK_SetBusy

.l46B1 ; 75:46B1
	; [CONFIRMED] 34 insn(s); 34 executed (in up to 7/18 scenarios)
	ld hl, $C9E4
	ld a, $A8
	ld [wMobileSDK_SendCommandID], a
	ld b, $05
	call Mobile_PacketSendBytes
	ld a, $0F
	ld [wMobileSDK_State], a
	jp MobileSDK_SetBusy
.l46C6 ; 75:46C6
	ld b, $50
	ld hl, $C715
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $0007
	add hl, de
	ld de, $C79E
.loop ; 75:46D5
	ld a, [hli]
	ld [de], a
	cp a, $2F
	jr z, .l46DF
	inc de
	dec b
	jr nz, .loop
.l46DF ; 75:46DF
	xor a, a
	ld [de], a
	dec hl
	ld a, l
	ld [wMobileSDK_HttpRequestPointer], a
	ld a, h
	ld [wMobileSDK_HttpRequestPointer + 1], a
	ld hl, $C79E
	ld a, $50
	ld b, $40
	jp .l4636

MobileAPI_SmtpConnect:: ; 75:46F4
	; [CONFIRMED] 197 insn(s) reached by static flow only; seeds: mobile x197; min discovery hops 0;
	; run starts at SDK/API table entry api14 (analysis/mobile_candidates.json) | 13 insn(s)
	; executed; cut out of the PROBABLE region 46F4-48A8 by apply_coverage --split [executed in 7
	; scenarios]
	ld a, [wTimerEnable]
	bit 0, a
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_State]
	cp a, $02
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_ConnectionFlag]
	or a, a
	jp nz, MobileSDK_ErrBusy
	push hl
	ld c, $20
	call MobileSDK_ValidateStringLen
	jr nc, .l4717

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 46F4-48A8 by apply_coverage --split
	pop hl
	jp MobileSDK_ErrBadArg

.l4717 ; 75:4717
	; [CONFIRMED] 109 insn(s) executed; cut out of the PROBABLE region 46F4-48A8 by apply_coverage
	; --split [executed in 5 scenarios]
	xor a, a
	ld [wMobileSDK_Substep], a
	ld de, $CA44
	ld hl, MobilePacket_TransferData
	ld b, $06
	call MobileSDK_CopyBytes
	ld de, $CA54
	ld hl, MobilePacket_TransferData
	ld b, $05
	call MobileSDK_CopyBytes
	inc de
	inc de
	ld bc, $0001
	ld hl, MobileStr_Helo
	call MobileSDK_CopyString
	pop hl
	push hl
	ld b, $FF
.loop ; 75:4740
	inc b
	ld a, [hli]
	or a, a
	jr z, .l4749
	cp a, $40
	jr nz, .loop
.l4749 ; 75:4749
	ld a, c
	add a, b
	add a, $02
	ld [wMobileSDK_PacketBuffer + 117], a
	pop hl
	call MobileSDK_CopyBytes
	call MobileSDK_AppendCrLf
	ld a, $00
	jp MobileSDK_DnsAndTcpOpen

MobileAPI_SmtpMailFrom:: ; 75:475C
	ld a, [wTimerEnable]
	bit 0, a
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_State]
	cp a, $03
	jp nz, MobileSDK_ErrBusy
	ld a, [wRam_C827]
	or a, a
	jp nz, MobileSDK_ErrBusy
	push hl
.l4774 ; 75:4774
	ld a, [hli]
	or a, a
	jr nz, .l4774
	ld a, [hl]
	or a, a
	jp z, .l4800
	pop hl
	push hl
	ld c, $20
	call MobileSDK_ValidateStringLen
	jr c, .l4800
.l4786 ; 75:4786
	ld c, $81
	call MobileSDK_ValidateStringLen
	jr c, .l4800
	xor a, a
	cp a, [hl]
	jr nz, .l4786
	call Function_75_673A
	xor a, a
	ld [wMobileSDK_Substep], a
	ld de, $C9E4
	ld hl, MobilePacket_TransferData
	ld b, $06
	call MobileSDK_CopyBytes
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	ld b, $01
	call Mobile_PacketBuildFooter
	ld de, $C9F0
	ld hl, MobilePacket_TransferData
	ld b, $05
	call MobileSDK_CopyBytes
	ld de, $C9F6
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	ld bc, $0001
	ld de, $C9F7
	ld hl, MobileStr_MailFrom
	call MobileSDK_CopyString
	pop hl
	call MobileSDK_CopyString
	ld a, $3E
	ld [de], a
	inc de
	inc c
	ld a, l
	ld [wMobileSDK_DataPointer], a
	ld a, h
	ld [wMobileSDK_DataPointer + 1], a
	call MobileSDK_AppendCrLf
	ld a, c
	ld [wMobileSDK_PacketBuffer + 17], a
	ld b, c
	call Mobile_PacketBuildFooter
	ld a, $95
	ld [wMobileSDK_SendCommandID], a
	ld hl, $C9F0
	ld d, $00
	ld e, c
	ld b, $05
	call Mobile_PacketSendBytes
	ld a, $15
	ld [wMobileSDK_State], a
	jp MobileSDK_SetBusy

.l4800 ; 75:4800
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 46F4-48A8 by apply_coverage --split
	pop hl
	jp MobileSDK_ErrBadArg

MobileAPI_SmtpData:: ; 75:4804
	; [CONFIRMED] 71 insn(s) executed; cut out of the PROBABLE region 46F4-48A8 by apply_coverage
	; --split [executed in 5 scenarios]
	ld a, [wTimerEnable]
	bit 0, a
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_State]
	cp a, $03
	jp nz, MobileSDK_ErrBusy
	ld a, [wRam_C827]
	or a, a
	jp z, MobileSDK_ErrBusy
	ld a, c
	or a, b
	jp z, MobileSDK_ErrBadArg
	ld a, l
	ld [wMobileSDK_DataPointer], a
	ld a, h
	ld [wMobileSDK_DataPointer + 1], a
	ld hl, $C71D
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, d
	ld [wMobileSDK_ResultPointer + 1], a
	call Function_75_673A
	ld hl, $C827
	ld a, [hl]
	and a, $01
	xor a, $01
	ld [wMobileSDK_Substep], a
	inc [hl]
	ld de, $C9E4
	ld hl, MobilePacket_TransferData
	ld b, $06
	call MobileSDK_CopyBytes
	ld de, $C9EA
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	ld b, $01
	call Mobile_PacketBuildFooter
	ld de, $CA7A
	ld hl, MobilePacket_TransferData
	ld b, $05
	call MobileSDK_CopyBytes
	ld de, $CA80
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	ld a, [wMobileSDK_Substep]
	or a, a
	jr nz, .l4896
	ld bc, $0001
	ld de, $CA81
	ld hl, MobileStr_Data
	call MobileSDK_CopyString
	ld a, c
	ld [wMobileSDK_PacketBuffer + 155], a
	ld b, c
	call Mobile_PacketBuildFooter
	ld a, $95
	ld [wMobileSDK_SendCommandID], a
	ld de, $0011
	ld hl, $CA7A
	ld b, $05
	call Mobile_PacketSendBytes
.l4896 ; 75:4896
	ld a, $16
	ld [wMobileSDK_State], a
	jp MobileSDK_SetBusy

MobileAPI_SmtpQuit:: ; 75:489E
	ld a, [wMobileSDK_State]
	cp a, $03
	jp nz, MobileSDK_ErrBusy
	jr MobileSDK_SendQuit

MobileAPI_Pop3Quit:: ; 75:48A8
	; [CONFIRMED] 59 insn(s); 59 executed (in up to 5/18 scenarios)
	ld a, [wMobileSDK_State]
	cp a, $04
	jp nz, MobileSDK_ErrBusy

MobileSDK_SendQuit:: ; 75:48B0
	ld hl, $C69F
	bit 0, [hl]
	jp nz, MobileSDK_ErrBusy
	call Function_75_673A
	xor a, a
	ld [wMobileSDK_Substep], a
	ld de, $CA04
	ld hl, MobilePacket_TransferData
	ld b, $06
	call MobileSDK_CopyBytes
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	ld b, $01
	call Mobile_PacketBuildFooter
	ld de, $C9E4
	ld hl, MobilePacket_TransferData
	ld b, $05
	call MobileSDK_CopyBytes
	ld a, $07
	ld [de], a
	inc de
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	ld bc, $0001
	ld hl, $60BC
	call MobileSDK_CopyString
	ld b, c
	call Mobile_PacketBuildFooter
	ld a, $95
	ld [wMobileSDK_SendCommandID], a
	ld hl, $C9E4
	ld b, $05
	call Mobile_PacketSendBytes
	ld a, $17
	ld [wMobileSDK_State], a
	jp MobileSDK_SetBusy

MobileAPI_Pop3Login:: ; 75:490A
	ld a, [wTimerEnable]
	bit 0, a
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_State]
	cp a, $02
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_ConnectionFlag]
	or a, a
	jp nz, MobileSDK_ErrBusy
	xor a, a
	ld [wMobileSDK_Substep], a
	push hl
	ld c, $20
	call MobileSDK_ValidateStringLen
	jr c, .l4934
	ld c, $22
	call MobileSDK_ValidateStringLen
	jr nc, .l4938

.l4934 ; 75:4934
	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; entered by jrcc from 75:492B (executed)
	pop hl
	jp MobileSDK_ErrBadArg

.l4938 ; 75:4938
	; [CONFIRMED] 87 insn(s); 87 executed (in up to 5/18 scenarios)
	ld de, $CA44
	ld hl, MobilePacket_TransferData
	ld b, $05
	call MobileSDK_CopyBytes
	inc de
	inc de
	ld hl, $60C3
	call MobileSDK_CopyString
	pop hl
	push hl
	ld b, $FF
.l494F ; 75:494F
	inc b
	ld a, [hli]
	or a, a
	jr z, .l4958
	cp a, $40
	jr nz, .l494F
.l4958 ; 75:4958
	ld a, b
	add a, $06
	ld c, a
	ld [wMobileSDK_PacketBuffer + 101], a
	pop hl
	ld de, $CA50
	call MobileSDK_CopyBytes
.l4966 ; 75:4966
	ld a, [hli]
	or a, a
	jr nz, .l4966
	call MobileSDK_AppendCrLf
	ld a, c
	ld [wMobileSDK_PacketBuffer + 101], a
	ld bc, $0006
	ld de, $CA90
	ld a, $20
	call MobileSDK_CopyStringLen
	call MobileSDK_AppendCrLf
	ld a, c
	ld [wMobileSDK_PacketBuffer + 165], a
	ld de, $CA84
	ld hl, MobilePacket_TransferData
	ld b, $05
	call MobileSDK_CopyBytes
	ld de, $CA8B
	ld hl, $60C9
	ld b, $05
	call MobileSDK_CopyBytes
	ld de, $CA64
	ld hl, MobilePacket_TransferData
	ld b, $06
	call MobileSDK_CopyBytes
	ld a, $01
	jp MobileSDK_DnsAndTcpOpen

MobileAPI_Pop3Stat:: ; 75:49A9
	ld hl, $C69F
	bit 0, [hl]
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_State]
	cp a, $04
	jp nz, MobileSDK_ErrBusy
	ld a, e
	ld [wMobileSDK_ResultPointer], a
	ld a, d
	ld [wMobileSDK_ResultPointer + 1], a
	xor a, a
	ld [wMobileSDK_Substep], a
	call MobileSDK_ResetRxWindow
	ld de, $C9E4
	ld hl, MobilePacket_TransferData
	ld b, $05
	call MobileSDK_CopyBytes
	ld a, $07
	ld [de], a
	inc de
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	ld bc, $0001
	ld hl, $60CF
	call MobileSDK_CopyString
	ld b, c
	call Mobile_PacketBuildFooter
	ld a, $95
	ld [wMobileSDK_SendCommandID], a
	ld hl, $C9E4
	ld b, $05
	call Mobile_PacketSendBytes
	ld a, $18
	ld [wMobileSDK_State], a
	jp MobileSDK_SetBusy

MobileAPI_Pop3List:: ; 75:49FE
	; [PROBABLE] 552 insn(s) reached by static flow only; seeds: mobile x552; min discovery hops 0;
	; run starts at SDK/API table entry api22 (analysis/mobile_candidates.json) | 43 insn(s) never
	; executed in the traced runs; cut out of the PROBABLE region 49FE-4DE2 by apply_coverage
	; --split
	ld a, [wTimerEnable]
	bit 0, a
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_State]
	cp a, $04
	jp nz, MobileSDK_ErrBusy
	xor a, a
	ld [wMobileSDK_Substep], a
	ld a, e
	ld [wMobileSDK_ResultPointer], a
	ld a, d
	ld [wMobileSDK_ResultPointer + 1], a
	ld a, l
	or a, h
	jp z, MobileSDK_ErrBadArg
	push hl
	call MobileSDK_ResetRxWindow
	ld de, $C9E4
	ld hl, MobilePacket_TransferData
	ld b, $05
	call MobileSDK_CopyBytes
	ld a, $0D
	ld [de], a
	inc de
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	ld bc, $0001
	ld hl, $60D6
	call MobileSDK_CopyString
	ld de, $C9F0
	pop hl
	call MobileSDK_FormatMessageNumber
	ld b, c
	call Mobile_PacketBuildFooter
	ld a, $95
	ld [wMobileSDK_SendCommandID], a
	ld hl, $C9E4
	ld b, $05
	call Mobile_PacketSendBytes
	ld a, $1D
	ld [wMobileSDK_State], a
	jp MobileSDK_SetBusy

MobileAPI_Pop3Retr:: ; 75:4A60
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 49FE-4DE2 by apply_coverage
	; --split [executed in 7 scenarios]
	ld a, [wTimerEnable]
	bit 2, a
	jr z, .l4A72

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 49FE-4DE2 by apply_coverage --split
	ld a, [wMobileSDK_State]
	cp a, $1A
	jp nz, MobileSDK_ErrBusy
	jp MobileSDK_Pop3RxBodyChunk

.l4A72 ; 75:4A72
	; [CONFIRMED] 73 insn(s) executed; cut out of the PROBABLE region 49FE-4DE2 by apply_coverage
	; --split [executed in 7 scenarios]
	bit 0, a
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_State]
	cp a, $04
	jp nz, MobileSDK_ErrBusy
	ld a, l
	or a, h
	jp z, MobileSDK_ErrBadArg
	ld a, l
	ld [wMobileSDK_ResultPointer], a
	ld a, h
	ld [wMobileSDK_ResultPointer + 1], a
	ld hl, $C6C6
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	inc de
	inc de
	dec bc
	dec bc
	ld hl, $C82C
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, b
	ld [hl], a
	ld hl, $C6C8
	ld a, $1F
	ld [hli], a
	ld a, $C7
	ld [hli], a
	ld a, $80
	ld [hli], a
	xor a, a
	ld [hli], a
	xor a, a
	ld [hli], a
	ld [hli], a
	xor a, a
	ld [wMobileSDK_Substep], a
	ld de, $C9E4
	ld hl, MobilePacket_TransferData
	ld b, $05
	call MobileSDK_CopyBytes
	ld a, $0D
	ld [de], a
	inc de
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	ld bc, $0001
	ld hl, $60E3
	call MobileSDK_CopyString
	ld de, $C9F0
	ld hl, $C70D
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call MobileSDK_FormatMessageNumber
	ld b, c
	call Mobile_PacketBuildFooter
	ld a, $95
	ld [wMobileSDK_SendCommandID], a
	ld hl, $C9E4
	ld b, $05
	call Mobile_PacketSendBytes
	ld a, $1A
	ld [wMobileSDK_State], a
	jp MobileSDK_SetBusy

MobileSDK_Pop3RxBodyChunk:: ; 75:4AF9
	; [PROBABLE] 197 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 49FE-4DE2 by apply_coverage --split
	ld hl, $C6C6
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	inc de
	inc de
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld e, [hl]
	ld a, b
	or a, c
	ld [wMobileSDK_ResultPointer], a
	ld [wMobileSDK_ResultPointer + 1], a
	jr z, .l4B61
	dec bc
	dec bc
	ld a, [wRam_C830]
	or a, a
	jp nz, .l4BDA
	ld a, [wRam_C831]
	or a, a
	jr z, .l4B21
	ld e, a
.l4B21 ; 75:4B21
	xor a, a
	ld [wRam_C831], a
	cp a, b
	jr nz, .l4B61
	ld a, e
	cp a, c
	jr c, .l4B61
	push bc
	sub a, c
	ld [hl], a
	ld b, c
	ld hl, $C6CC
	ld a, [wRam_C830]
	add a, c
	ld [hli], a
	ld a, b
	adc a, $00
	ld [hl], a
	xor a, a
	ld [wRam_C830], a
	ld hl, $C8DC
	ld a, [hli]
	inc hl
	sub a, e
	dec a
	ld e, a
	ld d, $00
	add hl, de
	ld a, [wMobileSDK_DestPointer]
	ld e, a
	ld a, [wMobileSDK_DestPointer + 1]
	ld d, a
	call MobileSDK_CopyBytes
	pop bc
	ld hl, $C6C6
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	ld [hli], a
	ld [hl], b
	ret
.l4B61 ; 75:4B61
	ld a, c
	sub a, e
	ld c, a
	ld a, b
	sbc a, $00
	ld b, a
	ld a, c
	ld [hli], a
	ld [hl], b
	ld hl, $C6CC
	ld a, [wRam_C830]
	add a, e
	ld [hli], a
	ld a, $00
	adc a, $00
	ld [hl], a
	xor a, a
	ld [wRam_C830], a
	ld a, [wMobileSDK_ResultPointer]
	or a, a
	jr z, .l4BA0
	ld b, e
	ld hl, $C8DC
	ld a, [hli]
	inc hl
	sub a, e
	dec a
	ld e, a
	ld d, $00
	add hl, de
	ld a, [wMobileSDK_DestPointer]
	ld e, a
	ld a, [wMobileSDK_DestPointer + 1]
	ld d, a
	call MobileSDK_CopyBytes
	ld hl, $C6C8
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
.l4BA0 ; 75:4BA0
	call MobileSDK_ReplyEndOfMultiline
	jr z, .l4BC0
	di
	ld hl, $C69F
	res 2, [hl]
	ld a, $01
	ld [wMobileSDK_Substep], a
	ld de, $000B
	ld a, $95
	ld [wMobileSDK_SendCommandID], a
	ld hl, $CA64
	ld b, $05
	jp Mobile_PacketSendBytes
.l4BC0 ; 75:4BC0
	ld a, $04
	ld [wMobileSDK_State], a
	ld hl, $C69F
	res 0, [hl]
	res 2, [hl]
	ld hl, $C6C6
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, $C6CC
	ld b, $02
	jp MobileSDK_CopyBytes
.l4BDA ; 75:4BDA
	ld e, a
	xor a, a
	cp a, b
	jr nz, .l4C0A
	ld a, e
	cp a, c
	jr c, .l4C0A
	ld b, c
	ld hl, $C830
	ld a, [hl]
	sub a, c
	ld [hl], a
	ld a, $80
	sub a, e
	ld e, a
	ld d, $00
	ld hl, $C71F
	add hl, de
	ld a, [wMobileSDK_DestPointer]
	ld e, a
	ld a, [wMobileSDK_DestPointer + 1]
	ld d, a
	call MobileSDK_CopyBytes
	ld hl, $C6C6
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	ld [hli], a
	xor a, a
	ld [hl], a
	ret
.l4C0A ; 75:4C0A
	push hl
	push bc
	ld a, [wRam_C830]
	ld b, a
	ld a, $80
	sub a, e
	ld e, a
	ld d, $00
	ld hl, $C71F
	add hl, de
	ld a, [wMobileSDK_DestPointer]
	ld e, a
	ld a, [wMobileSDK_DestPointer + 1]
	ld d, a
	call MobileSDK_CopyBytes
	ld a, e
	ld [wMobileSDK_DestPointer], a
	ld a, d
	ld [wMobileSDK_DestPointer + 1], a
	pop bc
	ld a, [wRam_C830]
	ld e, a
	ld a, c
	sub a, e
	ld c, a
	ld a, b
	sbc a, $00
	ld b, a
	ld a, [wRam_C831]
	ld e, a
	pop hl
	jp .l4B21

MobileAPI_Pop3Dele:: ; 75:4C41
	; [CONFIRMED] 46 insn(s) executed; cut out of the PROBABLE region 49FE-4DE2 by apply_coverage
	; --split [executed in 14 scenarios]
	ld a, [wTimerEnable]
	bit 0, a
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_State]
	cp a, $04
	jp nz, MobileSDK_ErrBusy
	ld a, l
	or a, h
	jp z, MobileSDK_ErrBadArg
	ld a, l
	ld [wMobileSDK_ResultPointer], a
	ld a, h
	ld [wMobileSDK_ResultPointer + 1], a
	call MobileSDK_ResetRxWindow
	ld de, $C9E4
	ld hl, MobilePacket_TransferData
	ld b, $05
	call MobileSDK_CopyBytes
	ld a, $0D
	ld [de], a
	inc de
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	ld bc, $0001
	ld hl, $60F0
	call MobileSDK_CopyString
	ld de, $C9F0
	ld hl, $C70D
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call MobileSDK_FormatMessageNumber
	ld b, c
	call Mobile_PacketBuildFooter
	ld a, $95
	ld [wMobileSDK_SendCommandID], a
	ld hl, $C9E4
	ld b, $05
	call Mobile_PacketSendBytes
	ld a, $1B
	ld [wMobileSDK_State], a
	jp MobileSDK_SetBusy

MobileAPI_Pop3Top:: ; 75:4CA3
	ld a, [wTimerEnable]
	bit 2, a
	jr z, .l4CB5

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 49FE-4DE2 by apply_coverage --split
	ld a, [wMobileSDK_State]
	cp a, $1C
	jp nz, MobileSDK_ErrBusy
	jp MobileSDK_Pop3RxBodyChunk

.l4CB5 ; 75:4CB5
	; [CONFIRMED] 80 insn(s) executed; cut out of the PROBABLE region 49FE-4DE2 by apply_coverage
	; --split [executed in 17 scenarios]
	bit 0, a
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_State]
	cp a, $04
	jp nz, MobileSDK_ErrBusy
	ld a, l
	or a, h
	jp z, MobileSDK_ErrBadArg
	ld a, l
	ld [wMobileSDK_ResultPointer], a
	ld a, h
	ld [wMobileSDK_ResultPointer + 1], a
	ld hl, $C6C6
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	inc de
	inc de
	dec bc
	dec bc
	ld hl, $C82C
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, b
	ld [hl], a
	ld hl, $C6C8
	ld a, $1F
	ld [hli], a
	ld a, $C7
	ld [hli], a
	ld a, $80
	ld [hli], a
	xor a, a
	ld [hli], a
	xor a, a
	ld [hli], a
	ld [hli], a
	xor a, a
	ld [wMobileSDK_Substep], a
	ld de, $C9E4
	ld hl, MobilePacket_TransferData
	ld b, $05
	call MobileSDK_CopyBytes
	ld a, $0E
	ld [de], a
	inc de
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	ld bc, $0001
	ld hl, $60FD
	call MobileSDK_CopyString
	ld de, $C9EF
	ld hl, $C70D
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call MobileSDK_FormatMessageNumber
	ld b, c
	call Mobile_PacketBuildFooter
	ld a, $95
	ld [wMobileSDK_SendCommandID], a
	ld hl, $C9E4
	ld b, $05
	call Mobile_PacketSendBytes
	ld a, $1C
	ld [wMobileSDK_State], a
	jp MobileSDK_SetBusy

MobileSDK_FormatMessageNumber:: ; 75:4D3C
	push bc
	push de
	ld b, $00
.l4D40 ; 75:4D40
	ld a, $27
	cp a, h
	jr c, .l4D4E
	jr nz, .l4D57

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 49FE-4DE2 by apply_coverage --split
	ld a, $10
	cp a, l
	jr z, .l4D4E
	jr nc, .l4D57
.l4D4E ; 75:4D4E
	inc b
	ld a, b
	ld bc, $D8F0
	add hl, bc
	ld b, a
	jr .l4D40

.l4D57 ; 75:4D57
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 49FE-4DE2 by apply_coverage
	; --split [executed in 18 scenarios]
	ld a, $30
	or a, b
	ld [de], a
	inc de
	ld b, $00
.l4D5E ; 75:4D5E
	ld a, $03
	cp a, h
	jr c, .l4D6C
	jr nz, .l4D75

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 49FE-4DE2 by apply_coverage --split
	ld a, $E8
	cp a, l
	jr z, .l4D6C
	jr nc, .l4D75
.l4D6C ; 75:4D6C
	inc b
	ld a, b
	ld bc, $FC18
	add hl, bc
	ld b, a
	jr .l4D5E

.l4D75 ; 75:4D75
	; [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 49FE-4DE2 by apply_coverage
	; --split [executed in 18 scenarios]
	ld a, $30
	or a, b
	ld [de], a
	inc de
	ld b, $00
.l4D7C ; 75:4D7C
	ld a, $00
	cp a, h
	jr nz, .l4D88
	ld a, $64
	cp a, l
	jr z, .l4D88
	jr nc, .l4D91

.l4D88 ; 75:4D88
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 49FE-4DE2 by apply_coverage --split
	inc b
	ld a, b
	ld bc, $FF9C
	add hl, bc
	ld b, a
	jr .l4D7C

.l4D91 ; 75:4D91
	; [CONFIRMED] 29 insn(s) executed; cut out of the PROBABLE region 49FE-4DE2 by apply_coverage
	; --split [executed in 3 scenarios]
	ld a, $30
	or a, b
	ld [de], a
	inc de
	ld b, $00
	ld a, l
.l4D99 ; 75:4D99
	cp a, $0A
	jr c, .l4DA2
	sub a, $0A
	inc b
	jr .l4D99
.l4DA2 ; 75:4DA2
	ld l, a
	ld a, $30
	or a, b
	ld [de], a
	inc de
	ld a, $30
	or a, l
	ld [de], a
	pop de
	ld l, e
	ld h, d
	ld b, $05
.l4DB1 ; 75:4DB1
	ld a, [hl]
	cp a, $30
	jr nz, .l4DBC
	inc hl
	dec b
	jr nz, .l4DB1

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 49FE-4DE2 by apply_coverage --split
	jr .l4DDA

.l4DBC ; 75:4DBC
	; [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 49FE-4DE2 by apply_coverage
	; --split [executed in 18 scenarios]
	ld a, $05
	cp a, b
	jr z, .l4DDA
	sub a, b
	ld c, a
	ld a, [wMobileSDK_PacketBuffer + 5]
	sub a, c
	ld c, a
	ld [wMobileSDK_PacketBuffer + 5], a
	push hl
	ld b, $01
.l4DCE ; 75:4DCE
	inc b
	ld a, [hli]
	cp a, $0D
	jr nz, .l4DCE
	pop hl
	call MobileSDK_CopyBytes
	pop hl
	ret

.l4DDA ; 75:4DDA
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 49FE-4DE2 by apply_coverage --split
	pop bc
.l4DDB ; 75:4DDB
	ld a, [de]
	inc de
	cp a, $0A
	jr nz, .l4DDB
	ret

MobileAPI_HttpGet:: ; 75:4DE2
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 2/18 scenarios)
	ld a, [wTimerEnable]
	bit 2, a
	ld a, [wMobileSDK_State]
	jr z, .l4E05

	; [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 75:4DEA (executed) | 2 insn(s) executed; cut out of the PROBABLE
	; region 4DEC-4E05 by apply_coverage --split [executed in 2 scenarios]
	cp a, $13
	jp z, MobileSDK_HttpReadBody

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4DEC-4E05 by apply_coverage --split
	cp a, $1F
	jp z, MobileSDK_HttpReadBody
	cp a, $21
	jp z, MobileSDK_HttpReadBody
	jp MobileSDK_ErrBusy
.l4DFE ; 75:4DFE
	pop hl
.l4DFF ; 75:4DFF
	pop hl
	pop hl
	pop hl
.l4E02 ; 75:4E02
	jp MobileSDK_ErrBadArg

.l4E05 ; 75:4E05
	; [CONFIRMED] 35 insn(s); 35 executed (in up to 2/18 scenarios)
	cp a, $02
	jp nz, MobileSDK_ErrBusy
	ld a, [wTimerEnable]
	bit 0, a
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_ConnectionFlag]
	or a, a
	jp nz, MobileSDK_ErrBusy
	ld a, l
	ld [wRam_C852], a
	ld a, h
	ld [wRam_C853], a
	xor a, a
	ld [wMobileSDK_HttpParseState], a
	ld [wMobileSDK_ContentLengthDigits], a
	ld [wRam_C827], a
	ld [wRam_C830], a
	ld a, [hli]
	ld [wMobileSDK_HttpDatePtr], a
	ld a, [hli]
	ld [wMobileSDK_HttpDatePtr + 1], a
	inc hl
	inc hl
	ld a, l
	ld [wRam_C81E], a
	ld a, h
	ld [wRam_C81F], a
	dec hl
	dec hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $1F
	cp a, l
	jr nz, .l4E4F

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 75:4E48 (executed)
	ld a, $C7
	cp a, h
	jr z, .l4E02

.l4E4F ; 75:4E4F
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 2/18 scenarios)
	push hl
	push de
	push bc
	push hl
	ld b, $07
	ld de, MobileStr_HttpPrefix
.l4E58 ; 75:4E58
	ld a, [de]
	inc de
	cp a, [hl]
	jr nz, .l4DFE
	inc hl
	dec b
	jr nz, .l4E58
	push hl
	ld b, $23
	ld c, $00
	ld de, MobileStr_UrlUpload
.l4E69 ; 75:4E69
	ld a, [de]
	inc de
	cp a, [hl]
	jr nz, .l4E75
	inc hl
	dec b
	jr nz, .l4E69

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:4E70 (executed)
	pop hl
	jr .l4DFE

.l4E75 ; 75:4E75
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 2/18 scenarios)
	pop hl
	push hl
	ld b, $24
	ld c, $00
	ld de, MobileStr_UrlRanking
.l4E7E ; 75:4E7E
	ld a, [de]
	inc de
	cp a, [hl]
	jr nz, .l4E8B
	inc hl
	dec b
	jr nz, .l4E7E

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:4E85 (executed)
	pop hl
	jp .l4DFE

.l4E8B ; 75:4E8B
	; [CONFIRMED] 47 insn(s); 47 executed (in up to 2/18 scenarios)
	pop hl
	push hl
	ld b, $24
	ld c, $00
	ld de, MobileStr_UrlUtility
.l4E94 ; 75:4E94
	ld a, [de]
	inc de
	cp a, [hl]
	jr nz, .l4EA7
	inc hl
	dec b
	jr nz, .l4E94
	pop hl
	ld a, $01
	ld [wRam_C827], a
	ld c, $01
	jr .l4EB8
.l4EA7 ; 75:4EA7
	pop hl
	ld b, $25
	ld c, $00
	ld de, $4FB9
.l4EAF ; 75:4EAF
	ld a, [de]
	inc de
	cp a, [hl]
	jr nz, .l4ED0
	inc hl
	dec b
	jr nz, .l4EAF
.l4EB8 ; 75:4EB8
	ld hl, $C81E
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld c, $12
	call MobileSDK_ValidateStringLen
	jp c, .l4DFE
	ld c, $12
	call MobileSDK_ValidateStringLen
	jp c, .l4DFE
	ld c, $01
.l4ED0 ; 75:4ED0
	ld a, c
	ld [wRam_C82C], a
	ld [wMobileSDK_ReceivePacketBuffer + 128], a
	pop hl
	call MobileSDK_UrlMeasurePath
	ld a, b
	cp a, $04
	jr c, .l4EE8

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 75:4EDE (executed)
	jp nz, .l4DFF
	xor a, a
	or a, c
	jp nz, .l4DFF

.l4EE8 ; 75:4EE8
	; [CONFIRMED] 48 insn(s); 48 executed (in up to 2/18 scenarios)
	ld hl, $C828
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	pop bc
	pop de
	pop hl
	ld a, l
	ld [wMobileSDK_HttpRequestPointer], a
	ld a, h
	ld [wMobileSDK_HttpRequestPointer + 1], a
	ld hl, $C711
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	inc hl
	inc hl
	xor a, a
	ld [wRam_C831], a

MobileSDK_HttpConnect:: ; 75:4F0C
	ld hl, $C6D2
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or a, h
	jr z, .skip
	xor a, a
	ld [hl], a
.skip ; 75:4F17
	ld hl, $C82E
	xor a, a
	ld [hli], a
	ld [hl], a
	ld hl, $C705
	ld a, [hli]
	or a, [hl]
	inc hl
	or a, [hl]
	inc hl
	or a, [hl]
	jr nz, .l4F2D
	ld a, $02
	jp MobileSDK_DnsAndTcpOpen

.l4F2D ; 75:4F2D
	; [PROBABLE] 56 insn(s) reached by static flow only; seeds: exec x56; min discovery hops 1;
	; entered by jrcc from 75:4F26 (executed)
	ld a, $02
	ld [wMobileSDK_ResultPointer], a
	ld a, $1F
	ld [wMobileSDK_PacketBuffer + 10], a
	ld a, $90
	ld [wMobileSDK_PacketBuffer + 11], a
	ld a, $01
	ld [wMobileSDK_Substep], a
	ld de, $C9E4
	ld hl, MobilePacket_OpenTCPConnection
	ld b, $06
	call MobileSDK_CopyBytes
	ld hl, $C705
	ld b, $04
	call MobileSDK_CopyBytes
	inc de
	inc de
	ld b, $06
	call Mobile_PacketBuildFooter
	ld a, [wMobileSDK_ReceivePacketBuffer + 128]
	or a, a
	jr z, .l4F9A
	ld hl, $C832
	ld a, [hli]
	cp a, $99
	jr nz, .l4F8F
	ld a, [hli]
	cp a, $66
	jr nz, .l4F8F
	ld a, [hli]
	cp a, $23
	jr nz, .l4F8F
	ld a, $02
	ld [wMobileSDK_ResultPointer], a
	dec a
	ld [wMobileSDK_Substep], a
	ld a, $A3
	ld de, $0010
	ld hl, $C832
	call Mobile_PacketSendExpect
	ld a, $0F
	ld [wMobileSDK_State], a
	jp MobileSDK_SetBusy
.l4F8F ; 75:4F8F
	ld hl, $C9E4
	ld de, $C832
	ld b, $10
	call MobileSDK_CopyBytes
.l4F9A ; 75:4F9A
	ld de, $0010
	ld hl, $C9E4
	ld a, $A3
	ld [wMobileSDK_SendCommandID], a
	ld b, $05
	call Mobile_PacketSendBytes
	ld a, $0F
	ld [wMobileSDK_State], a
	jp MobileSDK_SetBusy

; ---- text $4FB2-$4FDE (44 bytes) [CONFIRMED] "http://gameboy.datacenter.ne.jp/cgb/download" (ASCII, no terminator, verified by hand); ASCII URL text without terminator (used with fixed lengths); loaded by ld de,imm at 75:4E55/4E66/4E7B/4E91/4EAC and 75:5260/5272/5288; the part after "http://" (4FB9) is also addressed on its own; bytes 4FB2-4FD3, 4FDE-4FFD and 5001-5043 were read as data by executed code

MobileStr_HttpPrefix:: ; 75:4FB2
String_75_4FB2::
	db $68, $74, $74, $70, $3A, $2F, $2F ; "http://"

MobileStr_UrlDownload:: ; 75:4FB9
	db $67, $61, $6D, $65, $62, $6F, $79, $2E, $64, $61, $74, $61, $63, $65, $6E, $74, $65, $72, $2E, $6E, $65, $2E, $6A, $70, $2F, $63, $67, $62, $2F, $64, $6F, $77, $6E, $6C ; "gameboy.datacenter.ne.jp/cgb/downl"
	db $6F, $61, $64 ; "oad"

; ---- text $4FDE-$5001 (35 bytes) [CONFIRMED] "gameboy.datacenter.ne.jp/cgb/upload" (ASCII, no terminator, verified by hand); ASCII URL text without terminator (used with fixed lengths); loaded by ld de,imm at 75:4E55/4E66/4E7B/4E91/4EAC and 75:5260/5272/5288; the part after "http://" (4FB9) is also addressed on its own; bytes 4FB2-4FD3, 4FDE-4FFD and 5001-5043 were read as data by executed code

MobileStr_UrlUpload:: ; 75:4FDE
String_75_4FDE::
	db $67, $61, $6D, $65, $62, $6F, $79, $2E, $64, $61, $74, $61, $63, $65, $6E, $74, $65, $72, $2E, $6E, $65, $2E, $6A, $70, $2F, $63, $67, $62, $2F, $75, $70, $6C, $6F, $61 ; "gameboy.datacenter.ne.jp/cgb/uploa"
	db $64 ; "d"

; ---- text $5001-$5025 (36 bytes) [CONFIRMED] "gameboy.datacenter.ne.jp/cgb/utility" (ASCII, no terminator, verified by hand); ASCII URL text without terminator (used with fixed lengths); loaded by ld de,imm at 75:4E55/4E66/4E7B/4E91/4EAC and 75:5260/5272/5288; the part after "http://" (4FB9) is also addressed on its own; bytes 4FB2-4FD3, 4FDE-4FFD and 5001-5043 were read as data by executed code

MobileStr_UrlUtility:: ; 75:5001
String_75_5001::
	db $67, $61, $6D, $65, $62, $6F, $79, $2E, $64, $61, $74, $61, $63, $65, $6E, $74, $65, $72, $2E, $6E, $65, $2E, $6A, $70, $2F, $63, $67, $62, $2F, $75, $74, $69, $6C, $69 ; "gameboy.datacenter.ne.jp/cgb/utili"
	db $74, $79 ; "ty"

; ---- text $5025-$5049 (36 bytes) [CONFIRMED] "gameboy.datacenter.ne.jp/cgb/ranking" (ASCII, no terminator, verified by hand); ASCII URL text without terminator (used with fixed lengths); loaded by ld de,imm at 75:4E55/4E66/4E7B/4E91/4EAC and 75:5260/5272/5288; the part after "http://" (4FB9) is also addressed on its own; bytes 4FB2-4FD3, 4FDE-4FFD and 5001-5043 were read as data by executed code

MobileStr_UrlRanking:: ; 75:5025
String_75_5025::
	db $67, $61, $6D, $65, $62, $6F, $79, $2E, $64, $61, $74, $61, $63, $65, $6E, $74, $65, $72, $2E, $6E, $65, $2E, $6A, $70, $2F, $63, $67, $62, $2F, $72, $61, $6E, $6B, $69 ; "gameboy.datacenter.ne.jp/cgb/ranki"
	db $6E, $67 ; "ng"

MobileSDK_HttpReadBody:: ; 75:5049
	; [CONFIRMED] 127 insn(s) reached by static flow only; seeds: exec x127; min discovery hops 1;
	; entered by jpcc from 75:4DEE (PROBABLE code) | 19 insn(s) executed; cut out of the PROBABLE
	; region 5049-5118 by apply_coverage --split [executed in 2 scenarios]
	ld hl, $C6C6
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	inc de
	inc de
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld e, [hl]
	ld a, b
	or a, c
	ld [wMobileSDK_ResultPointer], a
	ld [wMobileSDK_ResultPointer + 1], a
	dec bc
	dec bc
	jp z, Label_75_51CF

	; [PROBABLE] 108 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5049-5118 by apply_coverage --split
	ld a, [wRam_C82E]
	or a, a
	call nz, Function_75_5164
	xor a, a
	cp a, e
	jp z, .l50F0
	xor a, a
	cp a, b
	jr nz, .l50B1
	ld a, e
	cp a, c
	jr c, .l50B1
	push bc
	sub a, c
	ld [hl], a
	ld b, c
	ld hl, $C6CC
	ld a, c
	ld [hli], a
	xor a, a
	ld [hl], a
	ld hl, $C8DC
	ld a, [hli]
	inc hl
	sub a, e
	dec a
	ld e, a
	ld d, $00
	add hl, de
	ld a, [wMobileSDK_DestPointer]
	ld e, a
	ld a, [wMobileSDK_DestPointer + 1]
	ld d, a
	call MobileSDK_CopyBytes
	pop bc
	ld a, [wRam_C82E]
	ld l, a
	ld h, $00
	add hl, bc
	ld c, l
	ld b, h
	xor a, a
	ld [wRam_C82E], a
	ld hl, $C6C6
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	ld [hli], a
	ld [hl], b
	ret
.l50B1 ; 75:50B1
	ld a, c
	sub a, e
	ld c, a
	ld a, b
	sbc a, $00
	ld b, a
	ld a, c
	ld [hli], a
	ld [hl], b
	ld hl, $C6CC
	ld a, [wRam_C82E]
	add a, e
	ld [hli], a
	ld a, $00
	adc a, $00
	ld [hl], a
	xor a, a
	ld [wRam_C82E], a
	ld a, [wMobileSDK_ResultPointer]
	or a, a
	jr z, .l50F0
	ld b, e
	ld hl, $C8DC
	ld a, [hli]
	inc hl
	sub a, e
	dec a
	ld e, a
	ld d, $00
	add hl, de
	ld a, [wMobileSDK_DestPointer]
	ld e, a
	ld a, [wMobileSDK_DestPointer + 1]
	ld d, a
	call MobileSDK_CopyBytes
	ld hl, $C6C8
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
.l50F0 ; 75:50F0
	di
	ld a, $02
	ld [wMobileSDK_HttpParseState], a
	ld hl, $C69F
	res 2, [hl]
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $9F
	jr z, .l5149
	ld de, $000B
	ld a, $95
	ld [wMobileSDK_SendCommandID], a
	ld hl, $C9E4
	ld b, $05
	call Mobile_PacketSendBytes
	ld a, $01
	ld [wMobileSDK_Substep], a
	ret

	; [PROBABLE] 22 insn(s): complete routine ending in jp $5F0B (ld hl,$C6C6 ; ld a,[hli] ; ld
	; h,[hl] ; ld l,a ... ld a,$A3 ; ld de,$0010 ; ld hl,$C832 ; jp $5F0B); follows a ret;
	; well-formed instruction chain (clean decode, all direct targets land on instruction starts,
	; lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS
	ld hl, $C6C6
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMobileSDK_ReceivedLength]
	ld [hli], a
	ld a, [wMobileSDK_ReceivedLength + 1]
	ld [hl], a
	ld hl, $C82C
	inc [hl]
	ld a, $0F
	ld [wMobileSDK_State], a
	ld a, $01
	ld [wMobileSDK_Substep], a
	ld a, [wMobileSDK_ConnectionFlag]
	ld [wMobileSDK_ResultPointer], a
	xor a, a
	ld [wMobileSDK_HttpParseState], a
	ld a, $A3
	ld de, $0010
	ld hl, $C832
	jp Mobile_PacketSendExpect

.l5149 ; 75:5149
	; [PROBABLE] 90 insn(s) reached by static flow only; seeds: exec x90; min discovery hops 2;
	; entered by jrcc from 75:5100 (PROBABLE code) | 85 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 5149-51DC by apply_coverage --split
	res 0, [hl]
	ld hl, $C6C6
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMobileSDK_ReceivedLength]
	ld [hli], a
	ld a, [wMobileSDK_ReceivedLength + 1]
	ld [hl], a
	ld a, $02
	ld [wMobileSDK_State], a
	xor a, a
	ld [wMobileSDK_ConnectionFlag], a
	ei
	ret

Function_75_5164:: ; 75:5164
	ld e, a
	xor a, a
	cp a, b
	jr nz, .l516D
	ld a, c
	cp a, e
	jr c, .l51A7
.l516D ; 75:516D
	push hl
	push bc
	ld b, e
	ld c, e
	ld a, [wRam_C830]
	sub a, e
	ld e, a
	ld d, $00
	ld hl, $C71F
	add hl, de
	ld a, [wMobileSDK_DestPointer]
	ld e, a
	ld a, [wMobileSDK_DestPointer + 1]
	ld d, a
	call MobileSDK_CopyBytes
	ld hl, $C6C8
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
	ld e, c
	ld a, c
	ld hl, $C6CC
	ld [hli], a
	xor a, a
	ld [hl], a
	pop bc
	ld a, c
	sub a, e
	ld c, a
	ld a, b
	sbc a, $00
	ld b, a
	ld a, [wRam_C82F]
	ld [wMobileSDK_DestRemaining], a
	ld e, a
	pop hl
	ret
.l51A7 ; 75:51A7
	ld a, e
	sub a, c
	ld [wRam_C82E], a
	ld a, [wRam_C830]
	sub a, e
	ld e, a
	ld d, $00
	ld hl, $C71F
	add hl, de
	ld a, [wMobileSDK_DestPointer]
	ld e, a
	ld a, [wMobileSDK_DestPointer + 1]
	ld d, a
	ld b, c
	call MobileSDK_CopyBytes
	ld hl, $C6C6
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	ld [hli], a
	xor a, a
	ld [hl], a
	pop af
	ret

Label_75_51CF:: ; 75:51CF
	; [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 5149-51DC by apply_coverage
	; --split [executed in 2 scenarios]
	ld hl, $C69F
	res 2, [hl]
	ld a, $06
	ld [wMobileSDK_Substep], a
	jp Mobile_CloseTcpConnection

MobileSDK_UrlMeasurePath:: ; 75:51DC
Function_75_51DC::
	; [CONFIRMED] 73 insn(s); 73 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push hl
	ld hl, $C705
	ld a, [hli]
	or a, [hl]
	inc hl
	or a, [hl]
	inc hl
	or a, [hl]
	pop hl
	jr nz, .l51F3
	ld de, $0007
	add hl, de
.l51ED ; 75:51ED
	ld a, [hli]
	cp a, $2F
	jr nz, .l51ED
	dec hl
.l51F3 ; 75:51F3
	ld bc, $FFFF
.l51F6 ; 75:51F6
	ld a, [hli]
	inc bc
	or a, a
	jr nz, .l51F6
	ld hl, $C719
	ld a, c
	ld [hli], a
	ld a, b
	ld [hl], a
	ret

MobileAPI_HttpPost:: ; 75:5203
	ld a, [wTimerEnable]
	bit 2, a
	ld a, [wMobileSDK_State]
	jp nz, Label_75_53F7
	cp a, $02
	jp nz, MobileSDK_ErrBusy
	ld a, [wTimerEnable]
	bit 0, a
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_ConnectionFlag]
	or a, a
	jp nz, MobileSDK_ErrBusy
	xor a, a
	ld [wMobileSDK_HttpParseState], a
	ld [wRam_C827], a
	ld [wRam_C830], a
	push hl
	push de
	push bc
	push hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, l
	ld [wRam_C852], a
	ld a, h
	ld [wRam_C853], a
	ld a, [hli]
	ld [wMobileSDK_HttpDatePtr], a
	ld a, [hli]
	ld [wMobileSDK_HttpDatePtr + 1], a
	inc hl
	inc hl
	ld a, l
	ld [wRam_C81E], a
	ld a, h
	ld [wRam_C81F], a
	dec hl
	dec hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $1F
	cp a, l
	jr nz, .l525E

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 75:5256 (executed)
	ld a, $C7
	cp a, h
	jp z, Label_75_5404

.l525E ; 75:525E
	; [CONFIRMED] 17 insn(s); 17 executed (in up to 1/18 scenarios)
	ld b, $07
	ld de, MobileStr_HttpPrefix
.l5263 ; 75:5263
	ld a, [de]
	inc de
	cp a, [hl]
	jp nz, Label_75_5404
	inc hl
	dec b
	jr nz, .l5263
	push hl
	ld b, $25
	ld c, $00
	ld de, $4FB9
.l5275 ; 75:5275
	ld a, [de]
	inc de
	cp a, [hl]
	jr nz, .l5282

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 75:5278 (executed)
	inc hl
	dec b
	jr nz, .l5275
	pop hl
	jp Label_75_5404

.l5282 ; 75:5282
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)
	pop hl
	push hl
	ld b, $24
	ld c, $00
	ld de, MobileStr_UrlRanking
.l528B ; 75:528B
	ld a, [de]
	inc de
	cp a, [hl]
	jr nz, .l529C

	; [PROBABLE] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0;
	; fall-through of the jrcc at 75:528E (executed)
	inc hl
	dec b
	jr nz, .l528B
	ld a, $02
	ld [wRam_C827], a
	pop hl
	jr .l52AD

.l529C ; 75:529C
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 1/18 scenarios)
	pop hl
	ld b, $23
	ld c, $00
	ld de, MobileStr_UrlUpload
.l52A4 ; 75:52A4
	ld a, [de]
	inc de
	cp a, [hl]
	jr nz, .l52D9

	; [PROBABLE] 27 insn(s) reached by static flow only; seeds: exec x27; min discovery hops 0;
	; fall-through of the jrcc at 75:52A7 (executed)
	inc hl
	dec b
	jr nz, .l52A4
.l52AD ; 75:52AD
	ld a, [hli]
	or a, a
	jr nz, .l52AD
.l52B1 ; 75:52B1
	ld a, [hld]
	cp a, $2F
	jr nz, .l52B1
	inc hl
	inc hl
	ld a, [hl]
	cp a, $30
	jr c, .l52D9
	cp a, $3A
	jr nc, .l52D9
	ld hl, $C81E
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld c, $12
	call MobileSDK_ValidateStringLen
	jp c, Label_75_5404
	ld c, $12
	call MobileSDK_ValidateStringLen
	jp c, Label_75_5404
	ld c, $01

.l52D9 ; 75:52D9
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 1/18 scenarios)
	ld a, c
	ld [wRam_C82C], a
	ld [wMobileSDK_ReceivePacketBuffer + 128], a
	pop hl
	ld de, $0006
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call MobileSDK_UrlMeasurePath
	ld a, b
	cp a, $04
	jr c, .l52F8

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1;
	; fall-through of the jrcc at 75:52EE (executed)
	jp nz, Label_75_5405
	xor a, a
	or a, c
	jp nz, Label_75_5405

.l52F8 ; 75:52F8
	; [CONFIRMED] 59 insn(s); 59 executed (in up to 1/18 scenarios)
	pop bc
	pop de
	pop hl
	ld a, l
	ld [wMobileSDK_HttpRequestPointer], a
	ld a, h
	ld [wMobileSDK_HttpRequestPointer + 1], a
	ld hl, $C711
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	inc hl
	inc hl
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
	call MobileSDK_FormatContentLength
	ld hl, $C715
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld [wRam_C847], a
	ld a, [hli]
	ld [wRam_C848], a
	ld a, [hli]
	ld [wRam_C849], a
	ld a, [hli]
	ld [wRam_C84A], a
	inc hl
	inc hl
	ld a, [hli]
	ld [wMobileSDK_HttpRequestPointer], a
	ld a, [hl]
	ld [wMobileSDK_HttpRequestPointer + 1], a
	ld a, [wRam_C82C]
	xor a, $01
	ld [wRam_C831], a
	jp MobileSDK_HttpConnect

MobileSDK_FormatContentLength:: ; 75:5342
	ld hl, $C715
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	xor a, a
	ld [wMobileSDK_Window + 73], a
.l5351 ; 75:5351
	ld de, $8AD0
	add hl, de
	jr nc, .l535B

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:5355 (executed)
	add a, $03
	jr .l5351

.l535B ; 75:535B
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)
	ld de, $7530
	add hl, de
.l535F ; 75:535F
	ld de, $D8F0
	add hl, de
	jr nc, .l5368

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:5363 (executed)
	inc a
	jr .l535F

.l5368 ; 75:5368
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	ld de, $2710
	add hl, de
	ld [wMobileSDK_Window + 70], a
	xor a, a
.l5370 ; 75:5370
	ld de, $F448
	add hl, de
	jr nc, .l537A

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:5374 (executed)
	add a, $30
	jr .l5370

.l537A ; 75:537A
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)
	ld de, $0BB8
	add hl, de
.l537E ; 75:537E
	ld de, $FC18
	add hl, de
	jr nc, .l5388

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:5382 (executed)
	add a, $10
	jr .l537E

.l5388 ; 75:5388
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)
	ld de, $03E8
	add hl, de
.l538C ; 75:538C
	ld de, $FED4
	add hl, de
	jr nc, .l5396

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:5390 (executed)
	add a, $03
	jr .l538C

.l5396 ; 75:5396
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)
	ld de, $012C
	add hl, de
.l539A ; 75:539A
	ld de, $FF9C
	add hl, de
	jr nc, .l53A3

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:539E (executed)
	inc a
	jr .l539A

.l53A3 ; 75:53A3
	; [CONFIRMED] 49 insn(s); 49 executed (in up to 1/18 scenarios)
	ld de, $0064
	add hl, de
	ld [wMobileSDK_Window + 71], a
	xor a, a
.l53AB ; 75:53AB
	ld de, $FFE2
	add hl, de
	jr nc, .l53B5
	add a, $30
	jr .l53AB
.l53B5 ; 75:53B5
	ld de, $001E
	add hl, de
.l53B9 ; 75:53B9
	ld de, $FFF6
	add hl, de
	jr nc, .l53C3
	add a, $10
	jr .l53B9
.l53C3 ; 75:53C3
	ld de, $000A
	add hl, de
	add a, l
	ld [wMobileSDK_Window + 72], a
	ld de, $C842
	ld hl, $C765
	ld a, [hli]
	or a, $30
	ld [de], a
	inc de
	ld a, [hl]
	swap a
	and a, $0F
	or a, $30
	ld [de], a
	inc de
	ld a, [hli]
	and a, $0F
	or a, $30
	ld [de], a
	inc de
	ld a, [hl]
	swap a
	and a, $0F
	or a, $30
	ld [de], a
	inc de
	ld a, [hl]
	and a, $0F
	or a, $30
	ld [de], a
	inc de
	ret

Label_75_53F7:: ; 75:53F7
	; [PROBABLE] 224 insn(s) reached by static flow only; seeds: exec x10, mobile x214; min
	; discovery hops 0; entered by jpcc from 75:520B (executed)
	cp a, $14
	jp z, MobileSDK_HttpReadBody
	cp a, $24
	jp z, MobileSDK_HttpReadBody
	jp MobileSDK_ErrBusy

Label_75_5404:: ; 75:5404
	pop hl

Label_75_5405:: ; 75:5405
	pop hl
	pop hl
	pop hl
	jp MobileSDK_ErrBadArg

MobileAPI_PeerSend:: ; 75:540B
	ld a, [wMobileFlags]
	bit 4, a
	jr z, .l5488
	bit 7, a
	jr nz, .l5488
	ld a, [wTimerEnable]
	bit 0, a
	jr nz, .l5488
.loop ; 75:541D
	ld a, [wMobileSDK_SerialPhase]
	or a, a
	jr nz, .loop
	di
	ld a, [wTimerEnable]
	bit 3, a
	jr nz, .l5484
	ld a, [wMobileSDK_PhaseCode]
	or a, a
	jr nz, .l543F
	ld hl, $C69F
	set 1, [hl]
	ld a, $23
	ld [wMobileSDK_ErrorCode], a
	ld a, $FF
	ei
	ret
.l543F ; 75:543F
	xor a, a
	ld [wMobileSDK_Substep], a
	push hl
	ld hl, $C6C8
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld de, $C9E4
	ld hl, MobilePacket_TransferData
	ld b, $05
	call MobileSDK_CopyBytes
	pop hl
	ld a, [hli]
	or a, a
	jr z, .l548E
	cp a, $81
	jr nc, .l548E
	ld c, a
	inc a
	inc a
	ld [de], a
	inc de
	ld a, $FF
	ld [de], a
	inc de
	ld a, c
	ld [de], a
	inc de
	ld b, c
	call MobileSDK_CopyBytes
	ld b, c
	inc b
	inc b
	call Mobile_PacketBuildFooter
	ld hl, $C6C1
	set 7, [hl]
	ld hl, $C69F
	set 0, [hl]
	ld a, $00
	ei
	ret
.l5484 ; 75:5484
	ei
	ld a, $01
	ret
.l5488 ; 75:5488
	call MobileSDK_ErrBusy
	ld a, $FF
	ret
.l548E ; 75:548E
	ei
	call MobileSDK_ErrBadArg
	ld a, $FF
	ret

MobileAPI_PeerReceive:: ; 75:5495
	ld a, [wMobileFlags]
	bit 4, a
	jp z, MobileSDK_ErrBusy
	ld a, [wTimerEnable]
	bit 0, a
	jp nz, MobileSDK_ErrBusy
	bit 3, a
	jp z, MobileSDK_ErrBusy
	ld e, l
	ld d, h
	ld a, [wRam_C82F]
	or a, a
	jr nz, .l5510
	ld a, [wRam_C830]
	ld c, a
	ld b, $00
	ld hl, $C8DD
	add hl, bc
	ld a, [hli]
	or a, a
	jr z, .l54C4
	cp a, $81
	jr c, .l54C6
.l54C4 ; 75:54C4
	ld a, $80
.l54C6 ; 75:54C6
	ld b, a
	inc c
	add a, c
	ld [wRam_C830], a
	ld a, [wRam_C831]
	dec a
	sub a, b
	ld c, a
	ld [wRam_C831], a
	ld a, b
	ld [de], a
	inc de
	call MobileSDK_CopyBytes
.l54DB ; 75:54DB
	xor a, a
	or a, c
	jr nz, .l54E5
	ld hl, $C69F
	res 3, [hl]
	ret
.l54E5 ; 75:54E5
	ld a, [hli]
	or a, a
	jr z, .l54ED
	cp a, $81
	jr c, .l54EF
.l54ED ; 75:54ED
	ld a, $80
.l54EF ; 75:54EF
	cp a, c
	ret c
	ld [wRam_C82E], a
	dec c
	ld a, c
	or a, a
	jr z, .l5509
	ld [wRam_C82F], a
	ld b, a
	ld de, $C71F
	call MobileSDK_CopyBytes
.l5503 ; 75:5503
	ld hl, $C69F
	res 3, [hl]
	ret
.l5509 ; 75:5509
	ld a, $FF
	ld [wRam_C82F], a
	jr .l5503
.l5510 ; 75:5510
	cp a, $FF
	jr nz, .skip
	xor a, a
.skip ; 75:5515
	ld b, a
	ld a, [wRam_C82E]
	sub a, b
	ld c, a
	ld hl, $C71F
	ld a, [wRam_C82E]
	ld [de], a
	inc de
	ld a, b
	or a, a
	jr z, .l552A
	call MobileSDK_CopyBytes
.l552A ; 75:552A
	ld hl, $C8DE
	ld b, c
	call MobileSDK_CopyBytes
	push hl
	ld a, c
	inc a
	ld [wRam_C830], a
	ld b, a
	ld a, [wMobileSDK_ReceivePacketBuffer + 3]
	sub a, b
	ld [wRam_C831], a
	ld c, a
	xor a, a
	ld hl, $C82E
	ld [hli], a
	ld [hl], a
	pop hl
	jr .l54DB

MobileAPI_TelephoneStatusAlias:: ; 75:5549
	nop

MobileAPI_TelephoneStatus:: ; 75:554A
	ld hl, $C69F
	bit 0, [hl]
	jp nz, MobileSDK_ErrBusy
	ld a, [wMobileSDK_State]
	cp a, $05
	jp nc, MobileSDK_ErrBusy
	ld [wMobileSDK_SavedState], a
	ld a, e
	ld [wMobileSDK_ResultPointer], a
	ld a, d
	ld [wMobileSDK_ResultPointer + 1], a
	ld a, [wMobileSDK_PhaseCode]
	cp a, $02
	jr c, .l558B
	xor a, a
	ld [wMobileSDK_Substep], a
	ld a, $97
	ld hl, $6028
	call Mobile_PacketSendEmptyBody
.loop ; 75:5578
	ld a, [wMobileAPIIndex]
	cp a, $49
	jr nz, .l5583
	ld a, $2C
	jr .l5585
.l5583 ; 75:5583
	ld a, $1E
.l5585 ; 75:5585
	ld [wMobileSDK_State], a
	jp MobileSDK_SetBusy
.l558B ; 75:558B
	xor a, a
	ldh [rTAC], a
	ld a, [wMobileSDK_TimingOffset]
	ld c, a
	call MobileAPI_SetTimer
	call MobileSDK_StartIdlePolling
	ld a, $01
	ld [wMobileSDK_Substep], a
	jr .loop

MobileAPI_Abort:: ; 75:559F
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 1/18 scenarios)
	ld hl, $C709
	ld a, [hl]
	cp a, $01
	jp z, MobileSDK_ErrBusy
	cp a, $2A
	jp z, MobileSDK_ErrBusy
	ld a, [wMobileSDK_SerialPhase]
	bit 1, a
	jr nz, .l55B8
	ld a, $2A
	jr Label_75_55ED

.l55B8 ; 75:55B8
	; [CONFIRMED] 27 insn(s) reached by static flow only; seeds: exec x27; min discovery hops 1;
	; entered by jrcc from 75:55B2 (executed) | 3 insn(s) executed; cut out of the PROBABLE region
	; 55B8-55ED by apply_coverage --split [executed in 2 scenarios]
	ld a, [wMobileSDK_SendCommandID]
	cp a, $92
	jr nz, .l55E6

	; [PROBABLE] 19 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 55B8-55ED by apply_coverage --split
	ld a, $2A
	ld b, $00
	di
	ld [hli], a
	ld [hl], b
	ld hl, $C6C1
	res 5, [hl]
	res 0, [hl]
	xor a, a
	ld [wMobileSDK_RxStage], a
	ld [wMobileSDK_SerialPhase], a
	ld a, $08
	ld [wMobileSDK_PhaseCode], a
	call Mobile_ResetReceivePacketBuffer
	call Function_75_565C
	ld hl, $C69F
	set 0, [hl]
	ei
	ret

.l55E6 ; 75:55E6
	; [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 55B8-55ED by apply_coverage
	; --split [executed in 2 scenarios]
	ld a, $2A
	ld [hli], a
	ld a, $01
	ld [hl], a
	ret

Label_75_55ED:: ; 75:55ED
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios)
	di
	push af
	cp a, $2A
	jr z, .l5607

	; [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0;
	; fall-through of the jrcc at 75:55F1 (executed) | 4 insn(s) executed; cut out of the PROBABLE
	; region 55F3-5607 by apply_coverage --split [executed in 1 scenarios]
	ld a, [wMobileSDK_ConnectionFlag]
	or a, a
	ld a, [wMobileSDK_ReceivePacketBuffer]
	jr z, .l5616

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 55F3-5607 by apply_coverage --split
	cp a, $9F
	jr z, .l561A
	cp a, $A4
	jr z, .l561A
.loop ; 75:5604
	call Mobile_CloseTcpConnection

.l5607 ; 75:5607
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	ld hl, $C69F
	set 0, [hl]
	ld a, $01
	ld [wMobileSDK_Substep], a
	pop af
	ld [wMobileSDK_State], a
	ret

.l5616 ; 75:5616
	; [CONFIRMED] 20 insn(s) reached by static flow only; seeds: exec x4, mobile x16; min discovery
	; hops 0; entered by jrcc from 75:55FA (PROBABLE code) [executed in 1 scenarios]
	cp a, $A3
	jr z, .loop
.l561A ; 75:561A
	ei
	jr .l5607

Label_75_561D:: ; 75:561D
	ld hl, $C709
	ld a, [hl]
	dec a
	jp z, MobileSDK_ErrBusy
	dec a
	jp z, MobileSDK_ErrBusy
	ld a, [wMobileSDK_SerialPhase]
	or a, a
	jr nz, .l5633
	ld a, $28
	jr Label_75_55ED
.l5633 ; 75:5633
	ld a, $28
	ld b, $02
	ld [hli], a
	ld [hl], b
	ret

MobileAPI_Reset:: ; 75:563A
	; [CONFIRMED] 18 insn(s); 18 executed (in up to 18/18 scenarios)
	ld a, [wMobileSDK_State]
	cp a, $01
	jp nz, MobileSDK_ErrBusy
	xor a, a
	ld hl, $C9E4
	ld [hli], a
	ld [hl], a
	call MobileSDK_StopLink
	call Mobile_ResetReceivePacketBuffer
	ld bc, $0450
	ld hl, $C6A0
.loop ; 75:5654
	xor a, a
	ld [hli], a
	dec bc
	ld a, c
	or a, b
	jr nz, .loop
	ret

Function_75_565C:: ; 75:565C
	; [PROBABLE] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 3;
	; entered by call from 75:55DC (PROBABLE code)
	ld hl, $C6B5
	xor a, a
	ld [hli], a
	ld a, [wMobileSDK_TimeoutReload]
	ld b, a
	ld a, [wMobileSDK_AdapterType]
	ld a, b
	srl a
	srl a
	add a, b
	add a, b
	ld [hl], a
	ret

MobileSDK_RxStoreByte:: ; 75:5671
Function_75_5671::
	; [CONFIRMED] 37 insn(s); 37 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, $C8D7
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [wMobileSDK_SendCommandID]
	cp a, $FF
	jr z, .l5686
	ld a, [wMobileFlags]
	bit 0, a
	jr z, .l5689
.l5686 ; 75:5686
	ld hl, $C8CC
.l5689 ; 75:5689
	add hl, de
	ld [hl], c
	inc de
	ld hl, $C8D7
	ld a, e
	ld [hli], a
	ld [hl], d
	ret

MobileSDK_StopLink:: ; 75:5693
	xor a, a
	ldh [rTAC], a
	ld c, $FF
	ldh a, [c]
	and a, $F3
	ldh [c], a
	ld a, [wMobileSDK_PacketBuffer + 1]
	ld [wMobileSDK_State], a
	ld a, [wMobileSDK_PacketBuffer]
	ld c, a
	ld hl, $C69F
	ld a, [hl]
	or a, c
	ld [hl], a
	ret

MobileSDK_FinishToIdle:: ; 75:56AD
	ld a, $01
	jr MobileSDK_SetFinalState

MobileSDK_FinishWithError:: ; 75:56B1
	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 2;
	; entered by jp from 75:6249 (PROBABLE code)
	set 1, [hl]
	ld a, [wMobileSDK_State]

MobileSDK_SetFinalState:: ; 75:56B6
	; [CONFIRMED] 67 insn(s); 67 executed (in up to 18/18 scenarios)
	ld [wMobileSDK_PacketBuffer + 1], a
	ld hl, $C6B5
	xor a, a
	ld [hli], a
	ld a, [wMobileSDK_TimeoutReload]
	rla
	ld [hl], a
	ld hl, $C69F
	ld a, [hl]
	ld b, a
	and a, $0D
	ld [hl], a
	ld a, $02
	and a, b
	ld [wMobileSDK_PacketBuffer], a
	ret

MobileSDK_SerialReceive:: ; 75:56D2
	ld a, [wMobileSDK_SerialPhase]
	rrca
	jp nc, MobileSDK_SerialRxExit
	rrca
	jp c, MobileSDK_RxStageDispatch
	ld hl, $C6A1
	ld a, [hli]
	ld d, [hl]
	ld e, a
	dec de
	ld a, d
	ld [hld], a
	ld a, e
	ld [hl], a
	cp a, $02
	jp nc, MobileSDK_SerialRxExit
	ld a, d
	or a, a
	jp nz, MobileSDK_SerialRxExit
	ld hl, $C6A8
	add hl, de
	ldh a, [rSB]
	ld [hl], a
	ld a, $A8
	cp a, l
	jp nz, MobileSDK_SerialRxExit
	ld a, [wMobileSDK_SendCommandID]
	cp a, $FF
	jr z, .l5723
	ld a, $F2
	cp a, [hl]
	jp z, MobileSDK_TxRetryLimit10
	dec a
	cp a, [hl]
	jp z, MobileSDK_TxRetryLimit3
	dec a
	cp a, [hl]
	jp z, MobileSDK_TxRetryLimit3
	ld a, [wMobileSDK_PhaseCode]
	cp a, $01
	jr nz, .l5723
	ld a, [wRam_C6A6]
	or a, a
	jr z, .l5785
.l5723 ; 75:5723
	ld a, [wMobileSDK_SendCommandID]
	cp a, $FF
	jr z, .l573D
	cp a, $EE
	jr z, .l5734
	cp a, $9F
	jr nz, .l5734

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 75:5730 (executed)
	ld a, $95

.l5734 ; 75:5734
	; [CONFIRMED] 38 insn(s); 38 executed (in up to 18/18 scenarios)
	cp a, [hl]
	jr nz, Label_75_57A7
	ld a, [wMobileSDK_AdapterType]
	or a, a
	jr z, .l573D
.l573D ; 75:573D
	xor a, a
	ld [wMobileSDK_RetryCount], a
	ld a, $03
	ld [wMobileSDK_SerialPhase], a
	xor a, a
	ld hl, $C6AA
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $C6BF
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld hl, $C6B5
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, [wMobileFlags]
	bit 0, a
	jr z, .l5764
	ld a, $0B
	jr .l5781
.l5764 ; 75:5764
	ld a, [wMobileSDK_SendCommandID]
	cp a, $FF
	jr z, .l577B
	cp a, $92
	jr z, .l577F
	cp a, $A3
	jr z, .l577F
	cp a, $A8
	jr z, .l577F
	ld a, $20
	jr .l5781

.l577B ; 75:577B
	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by jrcc from 75:5769 (executed)
	ld a, $03
	jr .l5781

.l577F ; 75:577F
	; [CONFIRMED] 22 insn(s); 22 executed (in up to 18/18 scenarios)
	ld a, $60
.l5781 ; 75:5781
	ld [hl], a
	jp MobileSDK_SerialRxExit
.l5785 ; 75:5785
	xor a, a
	ld [wMobileSDK_SerialPhase], a

Label_75_5789:: ; 75:5789
	ld hl, $C6C0
	ld a, [hld]
	ld e, a
	ld a, [hl]
	dec a
	ld b, $03
.loop ; 75:5792
	or a, a
	rra
	rr e
	dec b
	jr nz, .loop
	or a, a
	inc a
	ld hl, $C6B6
	ld [hld], a
	ld [hl], e
	jp MobileSDK_SerialRxExit

MobileSDK_TxRetryLimit10:: ; 75:57A3
	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by jpcc from 75:5709 (executed)
	ld b, $0A
	jr MobileSDK_TxRetryCheck

Label_75_57A7:: ; 75:57A7
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 2/18 scenarios)
	xor a, a
	ld [hli], a
	ld [hl], a
	jp MobileSDK_SerialRxExit

MobileSDK_TxRetryLimit3:: ; 75:57AD
	; [PROBABLE] 35 insn(s) reached by static flow only; seeds: exec x35; min discovery hops 1;
	; entered by jpcc from 75:570E (executed)
	ld b, $03

MobileSDK_TxRetryCheck:: ; 75:57AF
	ld hl, $C6C1
	set 3, [hl]
	ld hl, $C6B5
	ld a, [wMobileSDK_TimeoutReload + 1]
	ld [hli], a
	ld a, [wMobileSDK_TimeoutReload]
	ld [hl], a
	xor a, a
	ld [wMobileSDK_SerialPhase], a
	ld hl, $C6B9
	inc [hl]
	ld a, b
	cp a, [hl]
	jp nc, MobileSDK_SerialRxExit
	xor a, a
	ld hl, $C6A6
	ld [hli], a
	ld [wMobileSDK_SerialPhase], a
	ld a, $06
	ld [hl], a
	ld hl, $C69F
	set 1, [hl]
	ld a, $15
	ld [wMobileSDK_ErrorCode], a
	ld hl, $C6B0
	ld a, [wMobileSDK_AckBytes]
	and a, $0F
	cp a, $02
	jr nz, .skip
	inc a
.skip ; 75:57EE
	ld [hli], a
	xor a, a
	ld [hl], a
	jp MobileSDK_SerialRxExit

MobileSDK_RxStageDispatch:: ; 75:57F4
	; [CONFIRMED] 25 insn(s); 25 executed (in up to 17/18 scenarios)
	ld a, [wMobileSDK_RxStage]
	or a, a
	jr z, .l5804
	dec a
	jr z, MobileSDK_RxHeaderByte
	dec a
	jp z, MobileSDK_RxDataByte
	jp MobileSDK_RxTrailerByte
.l5804 ; 75:5804
	ld hl, $C6AA
	ld a, [hl]
	or a, a
	jr nz, .l580F
	ld b, $99
	jr .l5811
.l580F ; 75:580F
	ld b, $66
.l5811 ; 75:5811
	ldh a, [rSB]
	cp a, b
	jr z, .l584C
	cp a, $D2
	jr nz, .l5823
	xor a, a
	ld [wRam_C84B], a
.l581E ; 75:581E
	xor a, a
	ld [hl], a
	jp MobileSDK_SerialRxExit

.l5823 ; 75:5823
	; [CONFIRMED] 19 insn(s) reached by static flow only; seeds: exec x19; min discovery hops 1;
	; entered by jrcc from 75:5818 (executed) [executed in 1 scenarios]
	ld a, [wRam_C84B]
	inc a
	ld [wRam_C84B], a
	cp a, $14
	jr c, .l581E
	ld a, $06
	ld [wMobileSDK_PhaseCode], a
	ld a, $10
	ld [wMobileSDK_ErrorCode], a
	xor a, a
	ld [wMobileSDK_SerialPhase], a
	ld hl, $C6C1
	res 0, [hl]
	ld hl, $C69F
	ld a, [hl]
	set 1, a
	and a, $0F
	ld [hl], a
	jr MobileSDK_SerialRxExit

.l584C ; 75:584C
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 17/18 scenarios)
	inc [hl]
	ld a, $02
	cp a, [hl]
	jr nz, MobileSDK_SerialRxExit
	xor a, a
	ld [hli], a
	inc [hl]
	ld hl, $C6B2
	ld b, $03
.l585A ; 75:585A
	ld [hli], a
	dec b
	jr nz, .l585A
	ld a, [wMobileFlags]
	bit 4, a
	jr z, .l5870

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 75:5863 (executed)
	ld b, a
	ld a, [wTimerEnable]
	bit 3, a
	jr nz, .l5870
	jp Label_75_5789

.l5870 ; 75:5870
	; [CONFIRMED] 41 insn(s); 41 executed (in up to 17/18 scenarios)
	ld a, [wMobileSDK_TimeoutReload + 1]
	ld [hli], a
	ld a, [wMobileSDK_TimeoutReload]
	ld [hl], a
	jr MobileSDK_SerialRxExit

MobileSDK_RxHeaderByte:: ; 75:587A
	call MobileSDK_RxAddChecksum
	ld a, $04
	cp a, [hl]
	jr nz, MobileSDK_SerialRxExit
	xor a, a
	ld [hli], a
	ldh a, [rSB]
	ld [wMobileSDK_RxLength], a
	inc [hl]
	or a, a
	jr nz, MobileSDK_SerialRxExit
	inc [hl]
	jr MobileSDK_SerialRxExit

MobileSDK_RxDataByte:: ; 75:5890
	call MobileSDK_RxAddChecksum
	ld a, [wMobileSDK_RxLength]
	cp a, [hl]
	jr nz, MobileSDK_SerialRxExit
	xor a, a
	ld [hli], a
	inc [hl]
	jr MobileSDK_SerialRxExit

MobileSDK_RxTrailerByte:: ; 75:589E
	ldh a, [rSB]
	ld c, a
	call MobileSDK_RxStoreByte
	ld hl, $C6AA
	inc [hl]
	ld a, $02
	cp a, [hl]
	jr c, .l58C0
	ld a, [wMobileSDK_RxIndex]
	add a, $B1
	ld e, a
	ld d, $C6
	ld a, [de]
	cp a, c
	jr z, MobileSDK_SerialRxExit

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 75:58B7 (executed)
	ld a, $01
	ld [wMobileSDK_RxChecksumError], a
	jr MobileSDK_SerialRxExit

.l58C0 ; 75:58C0
	; [CONFIRMED] 94 insn(s); 94 executed (in up to 18/18 scenarios)
	ld a, $04
	cp a, [hl]
	jr nz, MobileSDK_SerialRxExit
	xor a, a
	ld [hli], a
	inc [hl]

MobileSDK_SerialRxExit:: ; 75:58C8
	ld hl, $C6C1
	res 1, [hl]
	ret

MobileSDK_RxAddChecksum:: ; 75:58CE
	ldh a, [rSB]
	ld c, a
	ld b, $00
	ld hl, $C6B2
	ld a, [hli]
	ld l, [hl]
	ld h, a
	add hl, bc
	ld a, h
	ld [wMobileSDK_PacketChecksum], a
	ld a, l
	ld [wMobileSDK_PacketChecksum + 1], a
	call MobileSDK_RxStoreByte
	ld hl, $C6AA
	inc [hl]
	ret

MobileSDK_TimerTick:: ; 75:58EA
	ld a, [wMobileSDK_RxStage]
	cp a, $04
	call z, MobileSDK_RxPacketComplete
	call MobileSDK_StateDispatch
	ld hl, $C6A7
	ld a, [hli]
	cp a, $02
	jr c, .l5933
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	and a, b
	cp a, $FF
	jr z, .l590A
	ld a, c
	or a, b
	jr nz, .l5933
.l590A ; 75:590A
	ld hl, $C6A7
	ld a, $06
	cp a, [hl]
	jp z, MobileSDK_TimerTickExit
	ld [hl], a
	ld a, $10
	ld [wMobileSDK_ErrorCode], a
	xor a, a
	ld [wMobileSDK_SerialPhase], a
	ld hl, $C6C1
	res 0, [hl]
	ld hl, $C69F
	ld a, [hl]
	and a, $0F
	or a, $02
	ld [hl], a
	ld a, $10
	ld [wMobileSDK_ErrorCode], a
	jp MobileSDK_TimerTickExit
.l5933 ; 75:5933
	ld a, [wMobileSDK_SerialPhase]
	cp a, $01
	jp z, MobileSDK_TxNextByte
	cp a, $03
	jp z, MobileSDK_TickReceiving
	ld a, [wMobileSDK_PhaseCode]
	cp a, $01
	jp c, MobileSDK_TimerTickExit
	ld hl, $C6B5
	dec [hl]
	jp nz, MobileSDK_TimerTickExit
	inc hl
	dec [hl]
	jp nz, MobileSDK_TimerTickExit
	ld hl, $C6A7
	ld a, [wMobileFlags]
	bit 3, a
	jp nz, MobileSDK_ResendPacket
	bit 4, a
	jr nz, .l59A8
	ld a, [hl]
	cp a, $01
	jp z, MobileSDK_SendBeginSession
	cp a, $0A
	jr z, .l5990
	cp a, $08
	jr z, .l5989
	ld a, [wMobileSDK_State]
	cp a, $2A
	jr z, .l599D
	cp a, $0D
	jr nz, .l5983

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 75:597A (executed)
	ld a, [wMobileSDK_Substep]
	cp a, $04
	jr nc, .l59A8

.l5983 ; 75:5983
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 4/18 scenarios)
	call MobileSDK_PollAdapterStatus
	jp MobileSDK_TimerTickExit

.l5989 ; 75:5989
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 75:596F (executed)
	ld a, [wMobileSDK_PrevPhaseCode]
	ld [hl], a
	jp MobileSDK_TimerTickExit

.l5990 ; 75:5990
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 17/18 scenarios)
	xor a, a
	ld [hl], a
	ld hl, $C69F
	res 0, [hl]
	call MobileSDK_StopLink
	jp MobileSDK_TimerTickExit

.l599D ; 75:599D
	; [CONFIRMED] 41 insn(s) reached by static flow only; seeds: exec x41; min discovery hops 1;
	; entered by jrcc from 75:5976 (executed) | 5 insn(s) executed; cut out of the PROBABLE region
	; 599D-59FC by apply_coverage --split [executed in 5 scenarios]
	xor a, a
	ld [hl], a
	ld [wTimerEnable], a
	call MobileSDK_StopLink
	jp MobileSDK_TimerTickExit

.l59A8 ; 75:59A8
	; [PROBABLE] 36 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 599D-59FC by apply_coverage --split
	ld b, a
	ld [hl], a
	or a, a
	jp z, MobileSDK_TimerTickExit
	ld a, [wMobileFlags]
	bit 7, a
	jr nz, .l59CA
.loop ; 75:59B5
	ld a, [wTimerEnable]
	bit 3, a
	jr nz, .l5983
	ld de, $000B
	ld hl, $606D
	ld a, $95
	call Mobile_PacketSendExpect
	jp MobileSDK_TimerTickExit
.l59CA ; 75:59CA
	ld a, [wTimerEnable]
	bit 3, a
	jr nz, .l59E9
	ld a, [wMobileSDK_PacketBuffer + 5]
	add a, $0A
	ld e, a
	ld d, $00
	ld a, $95
	ld [wMobileSDK_SendCommandID], a
	ld hl, $C9E4
	ld b, $05
	call Mobile_PacketSendBytes
	jp MobileSDK_TimerTickExit
.l59E9 ; 75:59E9
	ld hl, $C69F
	set 1, [hl]
	res 0, [hl]
	ld hl, $C6C1
	res 7, [hl]
	ld a, $21
	ld [wMobileSDK_ErrorCode], a
	jr .loop

MobileSDK_SendBeginSession:: ; 75:59FC
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 18/18 scenarios)
	ld a, $90
	ld [wMobileSDK_SendCommandID], a
	ld [wMobileSDK_AckBytes], a
	ld b, $05
	ld de, $0012
	ld hl, $5FFC
	call Mobile_PacketSendBytes
	ld a, $01
	ld [wRam_C6A6], a
	jp MobileSDK_TimerTickExit

MobileSDK_ResendPacket:: ; 75:5A17
	; [CONFIRMED] 17 insn(s) reached by static flow only; seeds: exec x17; min discovery hops 1;
	; entered by jpcc from 75:595C (executed) [executed in 3 scenarios]
	ld a, [hl]
	cp a, $06
	jp z, MobileSDK_TimerTickExit
	ld hl, $C6C1
	res 3, [hl]
	res 0, [hl]
	ld hl, $C6BA
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld b, $05
	call Mobile_PacketSendBytes
	jp MobileSDK_TimerTickExit

MobileSDK_TickReceiving:: ; 75:5A36
	; [CONFIRMED] 17 insn(s); 17 executed (in up to 17/18 scenarios)
	ld hl, $C6AB
	ld a, [hld]
	or a, a
	jr z, MobileSDK_TickResponseWait
	cp a, $03
	jr nz, MobileSDK_TxIdlePollByte
	ld a, [hl]
	cp a, $02
	jr z, MobileSDK_TxAckFirstByte
	cp a, $03
	jr z, MobileSDK_TxAckRxPacket

MobileSDK_TxIdlePollByte:: ; 75:5A4A
	ld a, $4B

MobileSDK_TxByte:: ; 75:5A4C
	ldh [rSB], a
	jp MobileSDK_StartTransfer

MobileSDK_TickResponseWait:: ; 75:5A51
	ld hl, $C6B5
	dec [hl]
	jr nz, MobileSDK_TxIdlePollByte

	; [CONFIRMED] 52 insn(s) reached by static flow only; seeds: exec x52; min discovery hops 0;
	; fall-through of the jrcc at 75:5A55 (executed) | 15 insn(s) executed; cut out of the PROBABLE
	; region 5A57-5AC3 by apply_coverage --split [executed in 5 scenarios]
	inc hl
	dec [hl]
	jr nz, MobileSDK_TxIdlePollByte
	inc hl
	dec [hl]
	jr z, .l5A6D
	ld hl, $C6BF
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld hl, $C6B5
	ld [hli], a
	ld a, d
	ld [hli], a
	jr MobileSDK_TxIdlePollByte

.l5A6D ; 75:5A6D
	; [PROBABLE] 37 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5A57-5AC3 by apply_coverage --split
	di
	ld a, [wMobileSDK_State]
	cp a, $2A
	jr z, .l5AB2
	ld hl, $C84F
	inc [hl]
	ld a, [hl]
	cp a, $01
	jr z, .l5A9B
	ld hl, $C6C1
	res 5, [hl]
	res 0, [hl]
	ld hl, $C69F
	res 4, [hl]
	ld a, $00
	ld [wMobileSDK_PrevPhaseCode], a
	ld a, $29
	ld [wMobileSDK_State], a
	ld a, $01
	ld [wRam_C6A6], a
	jr .l5AB2
.l5A9B ; 75:5A9B
	ld a, $29
	ld [wMobileSDK_State], a
	xor a, a
	ld [wRam_C6A6], a
	ld [wMobileSDK_Substep], a
	ld [wMobileSDK_RxStage], a
	ld [wMobileSDK_SerialPhase], a
	ld a, $08
	ld [wMobileSDK_PhaseCode], a
.l5AB2 ; 75:5AB2
	call Mobile_ResetReceivePacketBuffer
	call Function_75_565C
	ld hl, $C6C1
	res 5, [hl]
	res 0, [hl]
	ei
	jp MobileSDK_TimerTickExit

MobileSDK_TxAckFirstByte:: ; 75:5AC3
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 17/18 scenarios)
	ld a, $80
	jr MobileSDK_TxByte

MobileSDK_TxAckRxPacket:: ; 75:5AC7
	ld a, [wMobileSDK_RxChecksumError]
	or a, a
	jr nz, .l5AD5
	ld a, [wMobileSDK_ReceivePacketBuffer]
	xor a, $80
	jp MobileSDK_TxByte

.l5AD5 ; 75:5AD5
	; [PROBABLE] 42 insn(s) reached by static flow only; seeds: exec x42; min discovery hops 1;
	; entered by jrcc from 75:5ACB (executed)
	ld hl, $C6B9
	inc [hl]
	ld a, $03
	cp a, [hl]
	jr z, .l5B08
	call Mobile_ResetReceivePacketBuffer
	ld a, $03
	ld [wMobileSDK_SerialPhase], a
	xor a, a
	ld hl, $C6AA
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, $C6B5
	ld a, [wMobileSDK_TimeoutReload + 1]
	ld [hli], a
	ld a, [wMobileSDK_TimeoutReload]
	ld [hli], a
	ld a, [wMobileFlags]
	bit 0, a
	jr z, .l5B03
	ld a, $0B
	jr .l5B05
.l5B03 ; 75:5B03
	ld a, $20
.l5B05 ; 75:5B05
	ld [hli], a
	jr .l5B26
.l5B08 ; 75:5B08
	ld hl, $C6A6
	xor a, a
	ld [hli], a
	ld [wMobileSDK_SerialPhase], a
	ld a, $06
	ld [hl], a
	ld hl, $C69F
	set 1, [hl]
	ld a, $15
	ld [wMobileSDK_ErrorCode], a
	ld a, $02
	ld [wMobileSDK_ErrorInfo], a
	xor a, a
	ld [wMobileSDK_ErrorInfo + 1], a
.l5B26 ; 75:5B26
	ld a, $F1
	jp MobileSDK_TxByte

MobileSDK_TxNextByte:: ; 75:5B2B
	; [CONFIRMED] 135 insn(s); 135 executed (in up to 18/18 scenarios)
	ld hl, $C6A3
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld a, [de]
	ldh [rSB], a
	inc de
	ld a, d
	ld [hld], a
	ld [hl], e

MobileSDK_StartTransfer:: ; 75:5B38
	ld hl, $C6C1
	set 1, [hl]
	ld a, $03
	ldh [rSC], a
	ld a, $83
	ldh [rSC], a

MobileSDK_TimerTickExit:: ; 75:5B45
	ret

MobileSDK_RxPacketComplete:: ; 75:5B46
	xor a, a
	ld [wMobileSDK_RetryCount], a
	ld [wMobileSDK_RxStage], a
	ld hl, $C84E
	ld [hli], a
	ld [hl], a
	ld [wMobileSDK_SerialPhase], a
	ld hl, $C6C1
	res 5, [hl]
	bit 0, [hl]
	jr z, .l5B63
	ld a, [wMobileSDK_ReceivePacketBufferAlt]
	jr .l5B66
.l5B63 ; 75:5B63
	ld a, [wMobileSDK_ReceivePacketBuffer]
.l5B66 ; 75:5B66
	cp a, $9F
	jr nz, .skip
	ld a, $95
.skip ; 75:5B6C
	ld b, a
	ld hl, $5E31
	push hl
	cp a, $EE
	jp z, Mobile_GetErrorCode
	ld a, [wMobileSDK_SendCommandID]
	cp a, $FF
	jp z, MobileSDK_RestorePhaseCode
	cp a, $95
	jp z, MobileSDK_RxTransferData
	cp a, $A8
	jp z, MobileSDK_RxDnsReply
	cp a, $A3
	jr z, MobileSDK_RxOpenTcpReply
	cp a, $A4
	jr z, MobileSDK_RxOpenTcpReply
	cp a, $93
	jr z, MobileSDK_RxHangUpReply
	cp a, $99
	jr z, MobileSDK_RxReadConfigReply
	cp a, $9A
	jr z, MobileSDK_RxWriteConfigReply
	cp a, $97
	jp z, MobileSDK_RxTelephoneStatus
	cp a, $A1
	jr z, MobileSDK_RxIspLoginReply
	cp a, $A2
	jr z, MobileSDK_RxIspLogoutReply
	cp a, $90
	jp z, Mobile_ParseResponse_BeginSession
	cp a, $94
	jp z, MobileSDK_RxDialReply
	cp a, $92
	jp z, MobileSDK_RxDialReply
	ld hl, $C6C1
	res 0, [hl]
	ld a, $0A
	ld [wMobileSDK_PhaseCode], a
	xor a, a
	ld [wMobileSDK_SerialPhase], a
	ret

MobileSDK_RxOpenTcpReply:: ; 75:5BC7
	ld a, [wMobileSDK_ReceivePacketBuffer + 4]
	ld [wMobileSDK_ConnectionId], a
	ld a, $04
	ld [wMobileSDK_PhaseCode], a
	ret

MobileSDK_RxIspLogoutReply:: ; 75:5BD3
	ld a, $03
	ld [wMobileSDK_PhaseCode], a
	ret

MobileSDK_RxIspLoginReply:: ; 75:5BD9
	ld a, $04
	ld [wMobileSDK_PhaseCode], a
	ld de, $C6C2
	ld hl, $C8DD
	ld b, $04
	jp MobileSDK_CopyBytes

MobileSDK_RxHangUpReply:: ; 75:5BE9
	ld a, $02
	ld [wMobileSDK_PhaseCode], a
	ld hl, $C6C1
	res 4, [hl]
	ld hl, $C69F
	res 4, [hl]
	ret

MobileSDK_RxReadConfigReply:: ; 75:5BF9
	ld hl, $C6C8
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $C8DC
	ld a, [hli]
	dec a
	ld b, a
	inc hl
	call MobileSDK_CopyBytes
	ld a, $02
	ld [wMobileSDK_PhaseCode], a
	ret

MobileSDK_RxWriteConfigReply:: ; 75:5C0F
	ld de, $C711
	ld hl, $C8DD
	ld b, $02
	call MobileSDK_CopyBytes
	ld a, $02
	ld [wMobileSDK_PhaseCode], a
	ret

MobileSDK_RxTransferData:: ; 75:5C20
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $9F
	jp z, MobileSDK_RxFinish
	ld a, [wMobileSDK_ResultPointer + 1]
	ld b, a
	ld a, [wMobileSDK_ResultPointer]
	or a, b
	jp z, MobileSDK_RxFinish
	ld hl, $C6CA
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld a, [wMobileSDK_ReceivePacketBuffer + 3]
	dec a
	jp z, MobileSDK_RxFinish
	ld c, a
	ld a, [wMobileFlags]
	bit 4, a
	jp z, MobileSDK_RxCopyToDest

	; [PROBABLE] 71 insn(s) reached by static flow only; seeds: exec x71; min discovery hops 0;
	; fall-through of the jpcc at 75:5C46 (executed)
	ld a, [wRam_C82F]
	or a, a
	jr nz, .l5C92
	ld a, [wMobileSDK_ReceivePacketBuffer + 5]
	or a, a
	jr z, .l5C59
	cp a, $81
	jr c, .l5C5B
.l5C59 ; 75:5C59
	ld a, $80
.l5C5B ; 75:5C5B
	ld b, a
	ld a, [wMobileSDK_ReceivePacketBuffer + 3]
	dec a
	dec a
	cp a, b
	jr c, .l5C77
.loop ; 75:5C64
	ld hl, $C69F
	set 3, [hl]
	ld hl, $C830
	ld a, $01
	ld [hli], a
	ld a, [wMobileSDK_ReceivePacketBuffer + 3]
	dec a
	ld [hl], a
	jp MobileSDK_RxFinish
.l5C77 ; 75:5C77
	ld hl, $C82F
	or a, a
	jr z, .l5C8C
	ld [hld], a
	ld [hl], b
	ld b, a
	ld hl, $C8DF
	ld de, $C71F
	call MobileSDK_CopyBytes
	jp MobileSDK_RxFinish
.l5C8C ; 75:5C8C
	ld a, $FF
	ld [hld], a
	ld [hl], b
	jr MobileSDK_RxFinish
.l5C92 ; 75:5C92
	cp a, $FF
	jr nz, .l5CA6
	ld hl, $C82E
	ld a, [hli]
	ld b, a
	ld a, [wMobileSDK_ReceivePacketBuffer + 3]
	dec a
	cp a, b
	jr nc, .loop
	jr z, .loop
	xor a, a
	ld [hl], a
.l5CA6 ; 75:5CA6
	ld hl, $C82E
	ld a, [hli]
	sub a, [hl]
	ld b, a
	ld a, [wMobileSDK_ReceivePacketBuffer + 3]
	dec a
	cp a, b
	jr nc, .loop
	jr z, .loop
	ld b, a
	ld l, [hl]
	ld h, $00
	add a, l
	ld [wRam_C82F], a
	ld de, $C71F
	add hl, de
	ld e, l
	ld d, h
	ld hl, $C8DE
	call MobileSDK_CopyBytes
	jr MobileSDK_RxFinish

MobileSDK_RxCopyToDest:: ; 75:5CCB
	; [CONFIRMED] 48 insn(s); 48 executed (in up to 6/18 scenarios)
	xor a, a
	cp a, d
	jr nz, .l5CE3
	ld a, c
	cp a, e
	jr c, .l5CE3
	jr z, .l5CE3
	ld a, [wTimerEnable]
	set 2, a
	ld [wTimerEnable], a
	ld a, c
	sub a, e
	ld c, e
	ld e, a
	jr .l5CEA
.l5CE3 ; 75:5CE3
	ld a, e
	sub a, c
	ld e, a
	ld a, d
	sbc a, $00
	ld d, a
.l5CEA ; 75:5CEA
	ld a, d
	ld [hld], a
	ld [hl], e
	ld a, [wMobileSDK_DestPointer]
	ld e, a
	ld a, [wMobileSDK_DestPointer + 1]
	ld d, a
	ld hl, $C8DE
	ld a, c
	or a, a
	jr z, MobileSDK_RxFinish
	ld b, a
	call MobileSDK_CopyBytes
	ld hl, $C6C8
	ld a, e
	ld [hli], a
	ld [hl], d
	ld de, $0003
	add hl, de
	ld a, [hl]
	add a, c
	ld [hli], a
	jr nc, MobileSDK_RxFinish
	inc [hl]

MobileSDK_RxFinish:: ; 75:5D10
	ld a, [wMobileFlags]
	bit 4, a
	jr z, .l5D25

	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 75:5D15 (executed)
	bit 7, a
	jr z, .l5D25
	ld hl, $C6C1
	res 7, [hl]
	ld hl, $C69F
	res 0, [hl]

.l5D25 ; 75:5D25
	; [CONFIRMED] 35 insn(s); 35 executed (in up to 17/18 scenarios)
	ld a, [wMobileSDK_PrevPhaseCode]
	ld [wMobileSDK_PhaseCode], a
	ret

MobileSDK_RxDnsReply:: ; 75:5D2C
	ld a, [wMobileSDK_DestPointer]
	ld e, a
	ld a, [wMobileSDK_DestPointer + 1]
	ld d, a
	ld hl, $C8DD
	ld b, $04
	call MobileSDK_CopyBytes
	ld a, $04
	ld [wMobileSDK_PhaseCode], a
	ret

Mobile_ParseResponse_BeginSession:: ; 75:5D42
	ld de, $C8DC
	ld hl, $6001
	ld b, $09
.loop ; 75:5D4A
	ld a, [de]
	inc de
	cp a, [hl]
	jr nz, .l5D53
	inc hl
	dec b
	jr nz, .loop
.l5D53 ; 75:5D53
	ld a, b
	or a, a
	jr nz, .l5D62
	ld a, [wMobileSDK_ReceivePacketBuffer + 14]
	cp a, $80
	jr c, .l5D6B
	cp a, $90
	jr nc, .l5D6B
.l5D62 ; 75:5D62
	ld [wMobileSDK_AdapterType], a
	ld a, $02
	ld [wMobileSDK_PhaseCode], a
	ret

.l5D6B ; 75:5D6B
	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by jrcc from 75:5D5C (executed)
	xor a, a
	jr .l5D62

MobileSDK_RxDialReply:: ; 75:5D6E
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 7/18 scenarios)
	ld a, $03
	ld [wMobileSDK_PhaseCode], a
	ld hl, $C69F
	set 4, [hl]
	ret

MobileSDK_RxTelephoneStatus:: ; 75:5D79
	ld hl, $C6C1
	bit 0, [hl]
	jr z, .l5DC9
	ld a, [wMobileSDK_PrevPhaseCode]
	ld [wMobileSDK_PhaseCode], a
	ld a, [wMobileSDK_ReceivePacketBufferAlt + 4]
	ld b, a
	call MobileSDK_MapTelephoneStatus
	call MobileSDK_SetTelephoneStatusClass
	res 0, [hl]
	ld a, b
	cp a, $07
	jr z, .l5DB2
	or a, a
	ret nz

	; [PROBABLE] 22 insn(s) reached by static flow only; seeds: exec x22; min discovery hops 0;
	; fall-through of the retcc at 75:5D98 (executed)
	ld hl, $C69F
	res 4, [hl]
	set 1, [hl]
	ld a, [wMobileFlags]
	bit 4, a
	jr nz, .l5DC4
	ld a, $23
	ld [wMobileSDK_ErrorCode], a
	ld a, $06
	ld [wMobileSDK_PhaseCode], a
	ret
.l5DB2 ; 75:5DB2
	ld hl, $C69F
	res 4, [hl]
	set 1, [hl]
	ld a, $11
	ld [wMobileSDK_ErrorCode], a
	ld a, $06
	ld [wMobileSDK_PhaseCode], a
	ret
.l5DC4 ; 75:5DC4
	xor a, a
	ld [wMobileSDK_PhaseCode], a
	ret

.l5DC9 ; 75:5DC9
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 7/18 scenarios)
	ld hl, $C70D
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMobileSDK_ReceivePacketBuffer + 4]
	ld b, a
	call MobileSDK_MapTelephoneStatus
	call MobileSDK_SetTelephoneStatusClass
	ld a, b
	ld [hl], a
	ld a, [wMobileSDK_PrevPhaseCode]
	ld [wMobileSDK_PhaseCode], a
	ret

MobileSDK_MapTelephoneStatus:: ; 75:5DE2
	cp a, $FF
	jr z, .l5DF0
	or a, a
	ret z
	cp a, $04
	jr z, .l5DF3

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 75:5DEA (executed)
	cp a, $05
	jr z, .l5E1B
.l5DF0 ; 75:5DF0
	ld b, $07
	ret

.l5DF3 ; 75:5DF3
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 4/18 scenarios)
	ld b, $05
	ld a, [wMobileFlags]
	bit 0, a
	jr z, .l5E01
	ld a, [wMobileSDK_State]
	jr .l5E04

.l5E01 ; 75:5E01
	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by jrcc from 75:5DFA (executed)
	ld a, [wMobileSDK_SavedState]

.l5E04 ; 75:5E04
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 4/18 scenarios)
	cp a, $04
	ret z
	cp a, $1C
	ret z
	cp a, $1A
	ret z
	dec b
	cp a, $03
	ret z
	ld b, $01
	ld a, [wMobileFlags]
	bit 4, a
	ret z

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the retcc at 75:5E18 (executed)
	inc b
	ret
.l5E1B ; 75:5E1B
	ld b, $03
	ret

MobileSDK_SetTelephoneStatusClass:: ; 75:5E1E
Function_75_5E1E::
	; [CONFIRMED] 29 insn(s); 29 executed (in up to 17/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, b
	and a, $07
	rrca
	rrca
	rrca
	push hl
	ld l, a
	ld a, [wTimerEnable]
	and a, $1F
	or a, l
	ld [wTimerEnable], a
	pop hl
	ret

Function_75_5E31:: ; 75:5E31
	jp Mobile_ResetReceivePacketBuffer

Mobile_GetErrorCode:: ; 75:5E34
	ld a, [wMobileSDK_SendCommandID]
	cp a, $FF
	jp z, MobileSDK_RestorePhaseCode
	ld a, [wMobileSDK_State]
	cp a, $0D
	jr z, .l5E51
	cp a, $2A
	jr z, .l5E51
	ld a, $06
	ld [wMobileSDK_PhaseCode], a
	ld hl, $C69F
	set 1, [hl]
.l5E51 ; 75:5E51
	ld a, [wMobileFlags]
	bit 0, a
	jr z, .l5E5D

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:5E56 (executed)
	ld hl, $C8D0
	jr .l5E60

.l5E5D ; 75:5E5D
	; [CONFIRMED] 23 insn(s); 23 executed (in up to 1/18 scenarios)
	ld hl, $C8DD
.l5E60 ; 75:5E60
	ld a, [hli]
	ld [wMobileSDK_ErrorCommand], a
	cp a, $10
	jr z, .l5E91
	cp a, $12
	jr z, .l5E95
	cp a, $13
	jr z, .l5EAA
	cp a, $15
	jr z, .l5EB7
	cp a, $19
	jr z, .l5EE5
	cp a, $21
	jr z, .l5EE9
	cp a, $22
	jr z, .l5EAA
	cp a, $23
	jr z, .l5EED
	cp a, $24
	jr z, .l5EF6
	cp a, $28
	jr z, .l5EF2

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 75:5E8A (executed)
	ld a, [hl]

.loop ; 75:5E8D
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)
	ld [wMobileSDK_ErrorCode], a
	ret

.l5E91 ; 75:5E91
	; [PROBABLE] 47 insn(s) reached by static flow only; seeds: exec x47; min discovery hops 1;
	; entered by jrcc from 75:5E66 (executed) | 2 insn(s) never executed in the traced runs; cut out
	; of the PROBABLE region 5E91-5EF2 by apply_coverage --split
	ld a, $10
	jr .loop

.l5E95 ; 75:5E95
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 5E91-5EF2 by apply_coverage
	; --split [executed in 2 scenarios]
	ld a, [hl]
	or a, $00
	jr z, .l5EA6
	cp a, $02
	jr z, .l5EA2
	ld a, $13
	jr .loop

.l5EA2 ; 75:5EA2
	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5E91-5EF2 by apply_coverage --split
	ld a, $17
	jr .loop
.l5EA6 ; 75:5EA6
	ld a, $12
	jr .loop
.l5EAA ; 75:5EAA
	ld hl, $C69F
	res 1, [hl]
	res 4, [hl]
	ld a, $02
	ld [wMobileSDK_PhaseCode], a
	ret

.l5EB7 ; 75:5EB7
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 5E91-5EF2 by apply_coverage
	; --split [executed in 6 scenarios]
	ld a, [hl]
	cp a, $01
	jr nz, .l5EDC

	; [PROBABLE] 15 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5E91-5EF2 by apply_coverage --split
	ld a, [wMobileFlags]
	bit 4, a
	jr z, .l5EDC
	res 4, a
	ld [wMobileFlags], a
	ld hl, $C69F
	ld a, [hl]
	and a, $0F
	or a, $02
	ld [hl], a
	ld a, $23
	ld [wMobileSDK_ErrorCode], a
	ld a, $06
	ld [wMobileSDK_PhaseCode], a
	ret

.l5EDC ; 75:5EDC
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 5E91-5EF2 by apply_coverage
	; --split [executed in 6 scenarios]
	ld hl, $C6C1
	res 5, [hl]
	ld a, $24
	jr .loop

.l5EE5 ; 75:5EE5
	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5E91-5EF2 by apply_coverage --split
	ld a, $14
	jr .loop
.l5EE9 ; 75:5EE9
	ld a, $22
	jr .loop

.l5EED ; 75:5EED
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 5E91-5EF2 by apply_coverage
	; --split [executed in 4 scenarios]
	ld hl, $C69F
	res 1, [hl]

.l5EF2 ; 75:5EF2
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)
	ld a, $24
	jr .loop

.l5EF6 ; 75:5EF6
	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1;
	; entered by jrcc from 75:5E86 (executed)
	ld hl, $C69F
	res 1, [hl]
	ld a, $03
	ld [wMobileSDK_PhaseCode], a
	ret

MobileSDK_RestorePhaseCode:: ; 75:5F01
	ld a, [wMobileSDK_PrevPhaseCode]
	ld [wMobileSDK_PhaseCode], a
	ret

Mobile_PacketSendEmptyBody:: ; 75:5F08
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 18/18 scenarios)
	ld de, $000A

Mobile_PacketSendExpect:: ; 75:5F0B
	ld [wMobileSDK_SendCommandID], a
	ld b, $05

Mobile_PacketSendBytes:: ; 75:5F10
	call MobileSDK_WaitStatusPoll
	ret c
	ld a, [wMobileSDK_SerialPhase]
	cp a, $00
	jr z, .l5F20

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 75:5F19 (executed)
	call MobileSDK_ErrBusy
	scf
	ret

.l5F20 ; 75:5F20
	; [CONFIRMED] 86 insn(s); 86 executed (in up to 18/18 scenarios)
	ldh a, [rSC]
	and a, $80
	jr nz, .l5F20
	di
	ld a, [wMobileSDK_SendCommandID]
	cp a, $FF
	jr z, .l5F3E
	ld a, l
	ld [wMobileSDK_ResendPointer], a
	ld a, h
	ld [wMobileSDK_ResendPointer + 1], a
	ld a, e
	ld [wMobileSDK_ResendSize], a
	ld a, d
	ld [wMobileSDK_ResendSize + 1], a
.l5F3E ; 75:5F3E
	ld a, e
	ld [wMobileSDK_TxRemaining], a
	ld a, d
	ld [wMobileSDK_TxRemaining + 1], a
	ld a, l
	ld [wMobileSDK_TxPointer], a
	ld a, h
	ld [wMobileSDK_TxPointer + 1], a
	ld hl, $C6A7
	ld a, [hl]
	cp a, b
	jr z, .skip
	ld [wMobileSDK_PrevPhaseCode], a
.skip ; 75:5F58
	ld a, b
	ld [wMobileSDK_PhaseCode], a
	xor a, a
	ld [wRam_C6A6], a
	ld a, $01
	ld [wMobileSDK_SerialPhase], a
	ld hl, $C6C1
	set 5, [hl]
	ei
	ret

Mobile_PacketBuildFooter:: ; 75:5F6C
	push de
	ld hl, $0000
	ld c, b
	xor a, a
	cp a, b
	jr z, .l5F7A
.l5F75 ; 75:5F75
	call Function_75_5F96
	jr nz, .l5F75
.l5F7A ; 75:5F7A
	ld b, $04
.l5F7C ; 75:5F7C
	call Function_75_5F96
	jr nz, .l5F7C
	ld e, l
	ld d, h
	ld hl, $000A
	add hl, bc
	ld c, l
	ld b, h
	pop hl
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, $80
	ld [hli], a
	xor a, a
	ld [hl], a
	ld e, c
	ld d, b
	ret

Function_75_5F96:: ; 75:5F96
	dec de
	ld a, [de]
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	dec b
	ret

MobileSDK_PollAdapterStatus:: ; 75:5FA0
	ld hl, $C6C1
	bit 0, [hl]
	ret nz
	ld a, [wMobileSDK_PhaseCode]
	cp a, $02
	jr c, .l5FD4
	cp a, $05
	jr z, .l5FD4
	cp a, $06
	jr nz, .l5FD6

	; [PROBABLE] 17 insn(s) reached by static flow only; seeds: exec x17; min discovery hops 0;
	; fall-through of the jrcc at 75:5FB3 (executed)
	ld a, [wMobileSDK_ErrorCode]
	cp a, $22
	jr z, .l5FD4
	cp a, $23
	jr z, .l5FD4
	cp a, $26
	jr z, .l5FD4
	swap a
	and a, $0F
	cp a, $01
	jr z, .l5FD4
	cp a, $00
	jr z, .l5FD4
	cp a, $08
	jr nz, .l5FD6
.l5FD4 ; 75:5FD4
	scf
	ret

.l5FD6 ; 75:5FD6
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 4/18 scenarios)
	ld b, $05
	ld hl, $C6BE
	ld a, [hl]
	cp a, $FF
	jr z, .l5FF2
	ld a, $97
	ld [hl], a
	ld hl, $6028
	ld de, $000A
	call Mobile_PacketSendBytes
	ld hl, $C6C1
	set 0, [hl]
	ret

.l5FF2 ; 75:5FF2
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 75:5FDE (executed)
	ld hl, $5FFC
	ld de, $0012
	jp Mobile_PacketSendBytes

; ---- data $5FFB-$6063 (104 bytes) [CONFIRMED] read as data by executed code (in up to 18/18 scenarios); content class unknown

MobilePacket_Idle:: ; 75:5FFB
Data_75_5FFB::
	db $4B

MobilePacket_BeginSession:: ; 75:5FFC
	db $99, $66, $10, $00, $00, $08, $4E, $49, $4E, $54, $45, $4E, $44, $4F, $02, $77
	db $80, $00

MobilePacket_EndSession:: ; 75:600E
	db $99, $66, $11, $00, $00, $00, $00, $11, $80, $00

MobilePacket_DialTelephone:: ; 75:6018
	db $99, $66, $12, $00, $00, $00

MobilePacket_HangUpTelephone:: ; 75:601E
	db $99, $66, $13, $00, $00, $00, $00, $13, $80, $00

MobilePacket_TelephoneStatus:: ; 75:6028
	db $99, $66, $17, $00, $00, $00, $00, $17, $80, $00

MobilePacket_ISPLogin:: ; 75:6032
	db $99, $66, $21, $00, $00

MobilePacket_ISPLogout:: ; 75:6037
	db $99, $66, $22, $00, $00, $00, $00, $22, $80, $00

MobilePacket_ReadConfigurationDataPart1:: ; 75:6041
	db $99, $66, $19, $00, $00, $02, $00, $60, $00, $7B, $80, $00

MobilePacket_ReadConfigurationDataPart2:: ; 75:604D
	db $99, $66, $19, $00, $00, $02, $60, $60, $00, $DB, $80, $00

MobilePacket_WriteConfigurationData:: ; 75:6059
	db $99, $66, $1A, $00, $00

MobilePacket_DNSQuery:: ; 75:605E
	db $99, $66, $28, $00, $00

; ---- data $6063-$606D (10 bytes) [PROBABLE] Mobile Adapter packet template: magic 99 66, command $14, len 0, checksum $0014 (= sum of cmd..payload, verified), device byte $80, $00; passed to 75:5F08 (ld a,$94 ; ld hl,$6063 ; jp $5F08) at 75:63C6 (static-reached, never executed) | verifier: downgraded from CONFIRMED, no trace reads any byte of 6063-606D (the reads stop at 6063 and resume at 606D); the packet structure and checksum are verified by hand but nothing was executed

MobilePacket_WaitForTelephoneCall:: ; 75:6063
Data_75_6063::
	db $99, $66, $14, $00, $00, $00, $00, $14, $80, $00

; ---- data $606D-$6073 (6 bytes) [CONFIRMED] read as data by executed code (in 11 of the trace scenarios): first 6 bytes of the packet template that continues at 6073: magic 99 66, command $15, pad 00, length 00 01

MobilePacket_TransferData:: ; 75:606D
Data_75_606D::
	db $99, $66, $15, $00, $00, $01

; ---- data $6073-$6078 (5 bytes) [PROBABLE] tail of the 11-byte Mobile Adapter packet template 606D-6078: payload $FF, checksum $0115 (= sum of cmd..payload, verified by hand), $80 $00; no trace reads these 5 bytes (verifier: split from the CONFIRMED-read head)

Data_75_6073:: ; 75:6073
	db $FF, $01, $15, $80, $00

; ---- data $6078-$6084 (12 bytes) [CONFIRMED] read as data by executed code (in up to 7/18 scenarios); content class unknown

MobilePacket_OpenTCPConnection:: ; 75:6078
Data_75_6078::
	db $99, $66, $23, $00, $00, $06

MobilePacket_CloseTCPConnection:: ; 75:607E
	db $99, $66, $24, $00, $00, $01

; ---- data $6084-$6099 (21 bytes) [PROBABLE] 21-byte byte table (7 triples ec 14 c9 / e4 0f 0e / e0 0c 53 / c4 07 94 / b0 05 ee / ec 10 b4 / e4 0c dd); indexed by bc via 75:40E1 (ld hl,$6084 ; add hl,bc ; ld c,[hl] ; inc hl ...); meaning unresolved

MobileSDK_TimingTable:: ; 75:6084
Data_75_6084::
	db $EC, $14, $C9, $E4, $0F, $0E, $E0, $0C, $53, $C4, $07, $94, $B0, $05, $EE, $EC
	db $10, $B4, $E4, $0C, $DD

; ---- text $6099-$609F (6 bytes) [PROBABLE] NUL-terminated ASCII "HELO " (SMTP command) passed in HL to the string sender 75:4007 at 75:4736 (ld hl,$6099)

MobileStr_Helo:: ; 75:6099
String_75_6099::
	db $48, $45, $4C, $4F, $20, $00 ; "HELO "

; ---- text $609F-$60B5 (22 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

MobileStr_MailFrom:: ; 75:609F
String_75_609F::
	db $4D, $41, $49, $4C, $20, $46, $52, $4F, $4D, $3A, $3C, $00 ; "MAIL FROM:<"

MobileStr_RcptTo:: ; 75:60AB
	db $52, $43, $50, $54, $20, $54, $4F, $3A, $3C, $00 ; "RCPT TO:<"

; ---- text $60B5-$611C (103 bytes) [CONFIRMED] NUL-terminated ASCII POP3/SMTP/HTTP command strings: "DATA" CRLF, "QUIT" CRLF, "USER ", "PASS ", "STAT" CRLF, "LIST 00000" CRLF, "RETR 00000" CRLF, "DELE 00000" CRLF, "TOP 00000 0" CRLF, "GET ", " HTTP/1.0" CRLF; passed to 75:4007 by 75:4878 (DATA), 75:4A3A/4ACE/4C78/4D11 (LIST/RETR/DELE/TOP) ...

MobileStr_Data:: ; 75:60B5
String_75_60B5::
	db $44, $41, $54, $41, $0D, $0A, $00 ; "DATA<$0D><$0A>"

MobileStr_Quit:: ; 75:60BC
	db $51, $55, $49, $54, $0D, $0A, $00 ; "QUIT<$0D><$0A>"

MobileStr_User:: ; 75:60C3
	db $55, $53, $45, $52, $20, $00 ; "USER "

MobileStr_Pass:: ; 75:60C9
	db $50, $41, $53, $53, $20, $00 ; "PASS "

MobileStr_Stat:: ; 75:60CF
	db $53, $54, $41, $54, $0D, $0A, $00 ; "STAT<$0D><$0A>"

MobileStr_List:: ; 75:60D6
	db $4C, $49, $53, $54, $20, $30, $30, $30, $30, $30, $0D, $0A, $00 ; "LIST 00000<$0D><$0A>"

MobileStr_Retr:: ; 75:60E3
	db $52, $45, $54, $52, $20, $30, $30, $30, $30, $30, $0D, $0A, $00 ; "RETR 00000<$0D><$0A>"

MobileStr_Dele:: ; 75:60F0
	db $44, $45, $4C, $45, $20, $30, $30, $30, $30, $30, $0D, $0A, $00 ; "DELE 00000<$0D><$0A>"

MobileStr_Top:: ; 75:60FD
	db $54, $4F, $50, $20, $30, $30, $30, $30, $30, $20, $30, $0D, $0A, $00 ; "TOP 00000 0<$0D><$0A>"

MobileStr_HttpGetMethod:: ; 75:610B
	db $47, $45, $54, $20, $00 ; "GET "

MobileStr_HttpVersion:: ; 75:6110
	db $20, $48, $54, $54, $50, $2F, $31, $2E, $30, $0D, $0A, $00 ; " HTTP/1.0<$0D><$0A>"

; ---- text $611C-$612D (17 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

MobileStr_UserAgent:: ; 75:611C
String_75_611C::
	db $55, $73, $65, $72, $2D, $41, $67, $65, $6E, $74, $3A, $20, $43, $47, $42, $2D, $00 ; "User-Agent: CGB-"

; ---- data $612D-$6138 (11 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 610B-6149 by higher-priority evidence]

MobileStr_CrLfCrLf:: ; 75:612D
Data_75_612D::
	db $0D, $0A, $0D, $0A, $00

MobileStr_HttpPostMethod:: ; 75:6132
	db $50, $4F, $53, $54, $20, $00

; ---- text $6138-$6149 (17 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

MobileStr_ContentLength:: ; 75:6138
String_75_6138::
	db $43, $6F, $6E, $74, $65, $6E, $74, $2D, $4C, $65, $6E, $67, $74, $68, $3A, $20, $00 ; "Content-Length: "

MobileSDK_StateDispatch:: ; 75:6149
Function_75_6149::
	; [CONFIRMED] 32 insn(s); 32 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wMobileFlags]
	bit 5, a
	ret nz
	ld a, [wMobileSDK_State]
	cp a, $0A
	ret c
	ld c, a
	cp a, $0D
	jr z, .l6182
	cp a, $0F
	jr z, .l6191
	cp a, $29
	jr z, .l6170
	cp a, $2A
	jr z, .l6170
	cp a, $28
	jr z, .l6170
.loop ; 75:616A
	ld a, [wMobileSDK_PhaseCode]
	cp a, $06
	ret z
.l6170 ; 75:6170
	ld b, $00
	sla c
	ld hl, $6193
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld hl, $C70A
	inc [hl]
	ld a, [hl]
	ret

.l6182 ; 75:6182
	; [PROBABLE] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 1;
	; entered by jrcc from 75:6158 (executed)
	ld c, a
	ld a, [wMobileSDK_Substep]
	cp a, $01
	jr nz, .loop
	ld hl, $C69F
	res 1, [hl]
	jr .l6170

.l6191 ; 75:6191
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 7/18 scenarios)
	ld c, a
	ld a, [wMobileSDK_ErrorCode]
	cp a, $24
	jr nz, .loop
	ld a, [wMobileSDK_Substep]
	cp a, $01
	jr nz, .loop

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 75:619E (executed) [executed in 3 scenarios]
	ld hl, $C69F
	res 1, [hl]
	jr .l6170

; ---- ptrtable $61A7-$61F1 (74 bytes) [PROBABLE] code-pointer table, 37 entries: 37/37 words hit own-bank code starts (dense run of code pointers); 22/37 targets executed

MobileSDK_StateTable:: ; 75:61A7
Table_75_61A7::
	dw MobileState_IdentifyAdapter
	dw MobileState_ConnectIsp
	dw MobileState_Dial
	dw MobileState_WaitForCall
	dw MobileState_Disconnect
	dw MobileState_OpenTcp
	dw MobileState_ReturnToConnected
	dw MobileState_SmtpGreeting
	dw MobileState_Pop3Login
	dw MobileState_HttpExchange
	dw MobileState_HttpExchange
	dw MobileState_SmtpRecipients
	dw MobileState_SmtpData
	dw MobileState_SessionQuit
	dw MobileState_Pop3Stat
	dw MobileState_Pop3List
	dw MobileState_Pop3Retrieve
	dw MobileState_Pop3Dele
	dw MobileState_Pop3Retrieve
	dw MobileState_Pop3List
	dw MobileState_TelephoneStatus
	dw MobileState_HttpExchange
	dw MobileState_HttpExchange
	dw MobileState_HttpExchange
	dw MobileState_HttpExchange
	dw MobileState_HttpExchange
	dw MobileState_HttpExchange
	dw MobileState_ReadConfigExport
	dw MobileState_ReadConfigExport
	dw MobileState_ReadConfigExport
	dw MobileState_Cancel
	dw MobileState_Timeout
	dw MobileState_Abort
	dw MobileState_IdentifyAdapter
	dw MobileState_TelephoneStatus
	dw MobileState_ReadConfig
	dw MobileState_WriteConfig

MobileState_IdentifyAdapter:: ; 75:61F1
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 17/18 scenarios)
	dec a
	jr z, .l61F9
	dec a
	jr z, .l620B
	dec [hl]
	ret
.l61F9 ; 75:61F9
	ld a, [wMobileSDK_AdapterType]
	or a, a
	jr z, .l6201
	jr Mobile_EndSession

.l6201 ; 75:6201
	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1;
	; entered by jrcc from 75:61FD (executed)
	ld a, $10
	call MobileSDK_EnterErrorState
	res 0, [hl]
	set 1, [hl]
	ret

.l620B ; 75:620B
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 17/18 scenarios)
	ld hl, $C70D
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMobileSDK_AdapterType]
	cp a, $88
	jr c, .l6244
	sub a, $88
	ld [hl], a
	cp a, $04
	jr c, .l6221

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 75:621D (executed)
	ld a, $03

.l6221 ; 75:6221
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 17/18 scenarios)
	cp a, $03
	jr nz, .l6226

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 75:6223 (executed)
	dec a

.l6226 ; 75:6226
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 17/18 scenarios)
	ld b, a
	ld a, $04
	sub a, b
	ld d, a
	rlca
	add a, d
	ld c, a
	xor a, a
	cp a, b
	jr z, .l6235

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:6230 (executed)
	ld a, $03
	xor a, b

.l6235 ; 75:6235
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 17/18 scenarios)
	ld hl, $C710
	ld [hld], a
	ld [hl], c
	ld a, [wMobileSDK_State]
	cp a, $0A
	jr nz, MobileSDK_ResetToIdle
	jp MobileSDK_FinishToIdle

.l6244 ; 75:6244
	; [PROBABLE] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 1;
	; entered by jrcc from 75:6216 (executed) | 9 insn(s) never executed in the traced runs; cut out
	; of the PROBABLE region 6244-6264 by apply_coverage --split
	ld a, $10
	call MobileSDK_EnterErrorState
	jp MobileSDK_FinishWithError

MobileSDK_ResetToIdle:: ; 75:624C
	xor a, a
	ld [wTimerEnable], a
	ld [wMobileSDK_PhaseCode], a
	inc a
	ld [wMobileSDK_State], a
	ret

MobileSDK_EnterErrorState:: ; 75:6258
	; [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 6244-6264 by apply_coverage
	; --split [executed in 1 scenarios]
	ld [wMobileSDK_ErrorCode], a
	ld a, $05
	ld [wMobileSDK_State], a
	ld hl, $C69F
	ret

Mobile_EndSession:: ; 75:6264
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 17/18 scenarios)
	ld a, $91
	ld hl, $600E
	jp Mobile_PacketSendEmptyBody

MobileState_ConnectIsp:: ; 75:626C
	dec a
	jr z, .l6287
	dec a
	jr z, .l628D
	dec a
	jr z, .l629C
	dec a
	jp z, .l630F
	dec a
	jp z, .l632C
	dec a
	jp z, .l633B

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jpcc at 75:627E (executed)
	dec a
	jp z, .l6348
	dec [hl]
	ret

.l6287 ; 75:6287
	; [CONFIRMED] 59 insn(s); 59 executed (in up to 7/18 scenarios)
	ld hl, $6041
	jp Mobile_PacketSendReadConfig
.l628D ; 75:628D
	ld hl, $C6C8
	ld a, $7F
	ld [hli], a
	ld a, $C7
	ld [hli], a
	ld hl, $604D
	jp Mobile_PacketSendReadConfig
.l629C ; 75:629C
	ld hl, $C71F
	ld a, [hli]
	cp a, $4D
	jr nz, .l62FB
	ld a, [hld]
	cp a, $41
	jr nz, .l62FB
	ld b, $BE
	ld de, $0000
.loop ; 75:62AE
	ld a, [hli]
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	dec b
	jr nz, .loop
	ld a, [hli]
	cp a, d
	jr nz, .l6302
	ld a, [hl]
	cp a, e
	jr nz, .l6302
	ld a, [wMobileSDK_DnsServers]
	or a, a
	jr z, .l62CB
	ld de, $C6DD
	jr .l62D6
.l62CB ; 75:62CB
	ld hl, $C723
	ld de, $C6D5
	ld b, $08
	call MobileSDK_CopyBytes
.l62D6 ; 75:62D6
	ld hl, $C769
	ld b, $2C
	call MobileSDK_CopyBytes
	ld a, [wMobileSDK_PacketBuffer + 50]
	ld c, a
	sub a, $08
	ld e, a
	ld d, $00
	ld hl, $CA17
	add hl, de
	ld e, l
	ld d, h
	ld hl, $C6D5
	ld b, $08
	call MobileSDK_CopyBytes
	ld b, c
	call Mobile_PacketBuildFooter
	jr Mobile_PacketSendTelephoneStatus

.l62FB ; 75:62FB
	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1;
	; entered by jrcc from 75:62A2 (executed)
	ld a, $25
	ld [wRam_C711], a
	jr .l6307
.l6302 ; 75:6302
	ld a, $14
	ld [wRam_C711], a
.l6307 ; 75:6307
	ld a, $06
	ld [wMobileSDK_Substep], a
	jp Mobile_EndSession

.l630F ; 75:630F
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 7/18 scenarios)
	ld a, [wTimerEnable]
	and a, $E0
	jr nz, .l631A
	ld b, $92
	jr Mobile_PacketSendBuffered

.l631A ; 75:631A
	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1;
	; entered by jrcc from 75:6314 (executed)
	cp a, $E0
	ld a, $11
	jr z, .skip
	inc a
.skip ; 75:6321
	ld [wRam_C711], a
	ld a, $06
	ld [wMobileSDK_Substep], a
	jp Mobile_EndSession

.l632C ; 75:632C
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 7/18 scenarios)
	ld d, a
	ld a, [wMobileSDK_PacketBuffer + 50]
	add a, $0A
	ld e, a
	ld hl, $CA11
	ld a, $A1
	jp Mobile_PacketSendExpect
.l633B ; 75:633B
	ld a, $02
	ld [wMobileSDK_State], a
	ld hl, $C69F
	res 0, [hl]
	set 5, [hl]
	ret

.l6348 ; 75:6348
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jpcc from 75:6282 (PROBABLE code)
	ld a, [wRam_C711]
	call MobileSDK_EnterErrorState
	jp MobileSDK_FinishWithError

Mobile_PacketSendBuffered:: ; 75:6351
	; [CONFIRMED] 18 insn(s); 18 executed (in up to 17/18 scenarios)
	ld a, [wMobileSDK_PacketBuffer + 5]
	add a, $0A
	ld e, a
	ld d, $00
	ld hl, $C9E4
	ld a, b
	jp Mobile_PacketSendExpect

Mobile_PacketSendTelephoneStatus:: ; 75:6360
	ld hl, $C70D
	ld a, $1F
	ld [hli], a
	ld a, $C7
	ld [hl], a
	ld a, $97
	ld hl, $6028
	jp Mobile_PacketSendEmptyBody

Mobile_PacketSendReadConfig:: ; 75:6371
	ld a, $99
	ld de, $000C
	jp Mobile_PacketSendExpect

MobileState_Dial:: ; 75:6379
	; [PROBABLE] 54 insn(s) reached by static flow only; seeds: mobile x54; min discovery hops 0;
	; run starts at SDK/API table entry state0C (analysis/mobile_candidates.json)
	dec a
	jr z, Mobile_PacketSendTelephoneStatus
	dec a
	jr z, .l6387
	dec a
	jr z, .l63A1
	dec a
	jr z, .l63B3
	dec [hl]
	ret
.l6387 ; 75:6387
	ld a, [wTimerEnable]
	and a, $E0
	jr nz, .l6392
	ld b, $92
	jr Mobile_PacketSendBuffered
.l6392 ; 75:6392
	cp a, $E0
	ld a, $11
	jr z, .skip
	inc a
.skip ; 75:6399
	ld a, $03
	ld [wMobileSDK_Substep], a
	jp Mobile_EndSession
.l63A1 ; 75:63A1
	ld hl, $C6C1
	set 4, [hl]
	ld a, $02
	ld [wMobileSDK_State], a
	ld hl, $C69F
	res 0, [hl]
	set 6, [hl]
	ret
.l63B3 ; 75:63B3
	ld a, [wRam_C711]
	call MobileSDK_EnterErrorState
	jp MobileSDK_FinishWithError

MobileState_WaitForCall:: ; 75:63BC
	dec a
	jr z, .l63C4
	dec a
	jr z, .l63CC
	ret
.loop ; 75:63C3
	dec [hl]
.l63C4 ; 75:63C4
	ld a, $94
	ld hl, $6063
	jp Mobile_PacketSendEmptyBody
.l63CC ; 75:63CC
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $EE
	jr z, .loop
	ld hl, $C6C1
	set 4, [hl]
	ld a, $02
	ld [wMobileSDK_State], a
	ld hl, $C69F
	res 0, [hl]
	set 6, [hl]
	set 5, [hl]
	ret

MobileState_Disconnect:: ; 75:63E7
	; [CONFIRMED] 17 insn(s); 17 executed (in up to 6/18 scenarios)
	dec a
	jr z, .l63F8
	dec a
	jr z, .l6410
	dec a
	jr z, .l641C
	dec a
	jr z, .l6424
	dec a
	jr z, .l6427
	dec [hl]
	ret
.l63F8 ; 75:63F8
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $9F
	jr z, .l640E
	call MobileSDK_ReplyLineComplete
	jr z, .l640E

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 75:6402 (executed) | upgraded by classifier 6: all 4 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $C70A
	dec [hl]
	ld hl, $CA04
	jp Mobile_PacketSendTransferData

.l640E ; 75:640E
	; [CONFIRMED] 35 insn(s); 35 executed (in up to 6/18 scenarios)
	jr Mobile_CloseTcpConnection
.l6410 ; 75:6410
	xor a, a
	ld [wMobileSDK_ConnectionFlag], a
	ld a, $A2
	ld hl, $6037
	jp Mobile_PacketSendEmptyBody
.l641C ; 75:641C
	ld a, $93
	ld hl, $601E
	jp Mobile_PacketSendEmptyBody
.l6424 ; 75:6424
	jp Mobile_EndSession
.l6427 ; 75:6427
	ld hl, $C6C1
	res 4, [hl]
	ld hl, $C69F
	ld a, [hl]
	and a, $0F
	ld [hl], a
	jp MobileSDK_FinishToIdle

Mobile_CloseTcpConnection:: ; 75:6436
	ld a, $03
	ld [wMobileSDK_PhaseCode], a
	ld de, $C9E4
	ld hl, $607E
	ld b, $06
	call MobileSDK_CopyBytes
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	inc b
	call Mobile_PacketBuildFooter
	ld a, $A4
	ld hl, $C9E4
	jp Mobile_PacketSendExpect

MobileState_OpenTcp:: ; 75:6457
	dec a
	jr z, .l645E
	dec a
	jr z, .l649C

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 75:645B (executed)
	ret

.l645E ; 75:645E
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 6/18 scenarios)
	ld b, $06
	ld de, $CA40
	call Mobile_PacketBuildFooter
	ld a, [wMobileSDK_ResultPointer]
	inc a
	cp a, $03
	jr nz, .l6491
	ld a, [wMobileSDK_ReceivePacketBuffer + 128]
	or a, a
	jr z, .l6491
	ld hl, $C832
	ld a, [hli]
	cp a, $99
	jr nz, .l6486

	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 75:647A (executed)
	ld a, [hli]
	cp a, $66
	jr nz, .l6486
	ld a, [hli]
	cp a, $23
	jr z, .l6491

.l6486 ; 75:6486
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 6/18 scenarios)
	ld hl, $CA34
	ld de, $C832
	ld b, $10
	call MobileSDK_CopyBytes
.l6491 ; 75:6491
	ld a, $A3
	ld de, $0010
	ld hl, $CA34
	jp Mobile_PacketSendExpect
.l649C ; 75:649C
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $A3
	jr z, .l64D4

	; [CONFIRMED] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 0;
	; fall-through of the jrcc at 75:64A1 (executed) [executed in 3 scenarios]
	ld a, [wMobileFlags]
	bit 3, a
	jr z, .l64B1
	dec [hl]
	ld a, $03
	ld [wMobileSDK_PhaseCode], a
	ret
.l64B1 ; 75:64B1
	ld a, [wMobileSDK_OpenTcpRetries]
	cp a, $05
	jr c, .l64BE
	ld hl, $C69F
	set 1, [hl]
	ret
.l64BE ; 75:64BE
	dec [hl]
	ld hl, $C84C
	inc [hl]
	ld hl, $C6C1
	set 3, [hl]
	ld hl, $C6B5
	ld a, [wMobileSDK_TimeoutReload + 1]
	ld [hli], a
	ld a, [wMobileSDK_TimeoutReload]
	ld [hl], a
	ret

.l64D4 ; 75:64D4
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 6/18 scenarios)
	xor a, a
	ld [wMobileSDK_OpenTcpRetries], a
	ld a, [wMobileSDK_ResultPointer]
	inc a
	ld [wMobileSDK_ConnectionFlag], a
	dec a

Label_75_64E0:: ; 75:64E0
	jp z, MobileSDK_SmtpOpened
	dec a
	jp z, MobileSDK_Pop3Opened
	dec a
	jp z, MobileSDK_HttpOpened

	; [PROBABLE] 42 insn(s) reached by static flow only; seeds: exec x42; min discovery hops 0;
	; fall-through of the jpcc at 75:64E8 (executed)
	dec a
	jp z, Label_75_656C
	call MobileSDK_HttpPrepareRequestPackets
	push de
	ld de, $C71F
	ld hl, $C6C6
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, $01
	ld [wMobileSDK_ResultPointer], a
	ld a, $FA
	ld [hli], a
	xor a, a
	ld [hli], a
	xor a, a
	ld [hli], a
	ld [hli], a
	pop de
	ld a, $01
	ld [wRam_C831], a
	call MobileSDK_HttpCopyMethod
	ld a, $05
	ld [wMobileSDK_Substep], a
	call MobileSDK_HttpSendRequestPacket
	ld a, [wMobileSDK_ContentLengthDigits]
	or a, a
	jr z, .l6527
	ld a, $01
.l6527 ; 75:6527
	add a, $23
	ld [wMobileSDK_State], a
	ld a, [wRam_C827]
	cp a, $02
	jr nz, .l6537
	xor a, a
	ld [wMobileSDK_ContentLengthDigits], a
.l6537 ; 75:6537
	jp Label_75_65C5

MobileSDK_HttpSendRequestPacket:: ; 75:653A
Function_75_653A::
	; [CONFIRMED] 21 insn(s); 21 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld b, $FA
	ld hl, $C71F
	xor a, a
.loop ; 75:6540
	ld [hli], a
	dec b
	jr nz, .loop
	ld a, [wMobileSDK_HttpRequestPointer]
	ld [wMobileSDK_DataPointer], a
	ld a, [wMobileSDK_HttpRequestPointer + 1]
	ld [wMobileSDK_DataPointer + 1], a
	ld a, [wRam_C719]
	ld [wMobileSDK_DataLength], a
	ld a, [wRam_C71A]
	ld [wMobileSDK_DataLength + 1], a
	ld a, c
	ld [wMobileSDK_PacketBuffer + 17], a
	ld b, c
	call Mobile_PacketBuildFooter
	ld a, $95
	ld hl, $C9F0
	jp Mobile_PacketSendExpect

Label_75_656C:: ; 75:656C
	; [PROBABLE] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 1;
	; entered by jpcc from 75:64EC (PROBABLE code)
	call MobileSDK_HttpPrepareRequestPackets
	ld a, [wMobileSDK_PacketBuffer + 19]
	and a, $01
	or a, a
	jr nz, .l6583
	ld a, [wRam_C827]
	cp a, $02
	jr nz, .l6583
	ld a, $01
	ld [wRam_C831], a
.l6583 ; 75:6583
	call MobileSDK_HttpCopyMethod
	ld a, $05
	ld [wMobileSDK_Substep], a
	call MobileSDK_HttpSendRequestPacket
	ld a, [wMobileSDK_ContentLengthDigits]
	or a, a
	jr z, .skip
	ld a, $01
.skip ; 75:6596
	add a, $21
	ld [wMobileSDK_State], a
	jr Label_75_65C5

MobileSDK_HttpOpened:: ; 75:659D
	; [CONFIRMED] 72 insn(s); 72 executed (in up to 2/18 scenarios)
	call MobileSDK_HttpPrepareRequestPackets
	call MobileSDK_HttpCopyMethod
	ld a, $05
	ld [wMobileSDK_Substep], a
	call MobileSDK_HttpSendRequestPacket
	ld a, [wRam_C82C]
	ld b, a
	ld a, [wRam_C831]
	and a, $01
	add a, $13
	bit 0, b
	jr z, .l65C2
	sub a, $13
	add a, $1F
	dec b
	sla b
	add a, b
.l65C2 ; 75:65C2
	ld [wMobileSDK_State], a

Label_75_65C5:: ; 75:65C5
	ld hl, $C69F
	set 0, [hl]
	res 2, [hl]
	ret

MobileSDK_HttpPrepareRequestPackets:: ; 75:65CD
	ld hl, $C711
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld a, [wRam_C831]
	and a, $01
	xor a, $01
	ld [wMobileSDK_Substep], a
	ld hl, $C6C6
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	inc de
	inc de
	ld a, $1F
	ld [hli], a
	ld a, $C7
	ld [hli], a
	dec bc
	dec bc
	ld a, $FA
	ld [hli], a
	ld a, $00
	ld [hli], a
	xor a, a
	ld [hli], a
	ld [hli], a
	ld de, $C9E4
	ld hl, MobilePacket_TransferData
	ld b, $06
	call MobileSDK_CopyBytes
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	ld b, $01
	call Mobile_PacketBuildFooter
	ld de, $C9F0
	ld hl, MobilePacket_TransferData
	ld b, $05
	call MobileSDK_CopyBytes
	inc de
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	ret

MobileSDK_SmtpOpened:: ; 75:6622
	; [CONFIRMED] 23 insn(s) reached by static flow only; seeds: exec x23; min discovery hops 1;
	; entered by jpcc from 75:64E0 (executed) | upgraded by classifier 6: all 23 instruction starts
	; of the region are in analysis/coverage_union.tsv (executed in a trace)
	xor a, a
	ld [wMobileSDK_Substep], a
	ld a, [wMobileSDK_ConnectionId]
	ld [wMobileSDK_PacketBuffer + 118], a
	ld de, $CA4A
	ld [de], a
	inc de
	ld b, $01
	call Mobile_PacketBuildFooter
	call Function_75_673A
	ld a, [wMobileSDK_PacketBuffer + 117]
	ld b, a
	ld de, $CA5A
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	call Mobile_PacketBuildFooter
	ld hl, $CA44
	call Mobile_PacketSendTransferData
	ld a, $11
	ld [wMobileSDK_State], a

Label_75_6654:: ; 75:6654
	; [CONFIRMED] 61 insn(s); 61 executed (in up to 4/18 scenarios)
	ld hl, $C69F
	set 0, [hl]
	ret

MobileSDK_Pop3Opened:: ; 75:665A
	xor a, a
	ld [wMobileSDK_Substep], a
	ld a, [wMobileSDK_ConnectionId]
	ld [wMobileSDK_PacketBuffer + 102], a
	ld [wMobileSDK_PacketBuffer + 166], a
	ld de, $CA6A
	ld [de], a
	inc de
	ld b, $01
	call Mobile_PacketBuildFooter
	call Function_75_673A
	ld a, [wMobileSDK_PacketBuffer + 165]
	ld b, a
	ld de, $CA8A
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	call Mobile_PacketBuildFooter
	ld a, [wMobileSDK_PacketBuffer + 101]
	ld b, a
	ld de, $CA4A
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	call Mobile_PacketBuildFooter
	ld hl, $CA64
	call Mobile_PacketSendTransferData
	ld a, $12
	ld [wMobileSDK_State], a
	jr Label_75_6654

MobileSDK_HttpCopyMethod:: ; 75:66A1
	ld bc, $0001
	ld hl, $610B
	ld a, [wRam_C831]
	or a, a
	call nz, MobileSDK_HttpSelectPost
	call MobileSDK_CopyString
	ret

MobileSDK_HttpSelectPost:: ; 75:66B2
	ld hl, $6132
	ret

MobileSDK_HttpCopyVersion:: ; 75:66B6
	ld hl, $6110
	jp MobileSDK_CopyString

MobileSDK_HttpUserAgentLine:: ; 75:66BC
	ld hl, MobileStr_UserAgent
	call MobileSDK_CopyString
	ld hl, $013F
	ld b, $04
	call MobileSDK_CopyBytes
	ld a, $2D
	ld [de], a
	inc de
	ld a, [$014C]
	and a, $F0
	swap a
	cp a, $0A
	jr c, .l66DD

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:66D7 (executed)
	add a, $57
	jr .l66DF

.l66DD ; 75:66DD
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 2/18 scenarios)
	or a, $30
.l66DF ; 75:66DF
	ld [de], a
	inc de
	ld a, [$014C]
	and a, $0F
	cp a, $0A
	jr c, .l66EE

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:66E8 (executed)
	add a, $37
	jr .l66F0

.l66EE ; 75:66EE
	; [CONFIRMED] 37 insn(s); 37 executed (in up to 2/18 scenarios)
	or a, $30
.l66F0 ; 75:66F0
	ld [de], a
	inc de
	ld a, $07
	add a, c
	ld c, a
	ld hl, MobileStr_CrLfCrLf
	jp MobileSDK_CopyString

MobileSDK_HttpContentLengthLine:: ; 75:66FC
	xor a, a
	ld [wMobileSDK_Substep], a
	ld hl, MobileStr_ContentLength
	call MobileSDK_CopyString
	ld hl, $C842
	ld b, $05
.loop ; 75:670B
	ld a, [hl]
	cp a, $30
	jr nz, .l6717
	inc hl
	dec b
	ld a, $01
	cp a, b
	jr nz, .loop
.l6717 ; 75:6717
	push bc
	call MobileSDK_CopyBytes
	ld a, $0D
	ld [de], a
	inc de
	ld a, $0A
	ld [de], a
	inc de
	pop bc
	ld a, b
	add a, $02
	add a, c
	ld c, a
	or a, c
	ret

MobileState_ReturnToConnected:: ; 75:672B
	; [PROBABLE] 7 insn(s) reached by static flow only; seeds: mobile x7; min discovery hops 0; run
	; starts at SDK/API table entry state10 (analysis/mobile_candidates.json)
	xor a, a
	ld [wMobileSDK_ConnectionId], a
	ld a, $02
	ld [wMobileSDK_State], a
	ld hl, $C69F
	res 0, [hl]
	ret

Function_75_673A:: ; 75:673A
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $FF
	ld [wMobileSDK_ResultPointer], a

MobileSDK_ResetRxWindow:: ; 75:673F
	push hl
	ld hl, $C6CB
	xor a, a
	ld [hld], a
	ld a, $FF
	ld [hld], a
	ld a, $C7
	ld [hld], a
	ld a, $1F
	ld [hl], a
	pop hl
	ret

MobileState_SmtpGreeting:: ; 75:6750
	; [CONFIRMED] 68 insn(s) reached by static flow only; seeds: mobile x68; min discovery hops 0;
	; run starts at SDK/API table entry state11 (analysis/mobile_candidates.json) | 6 insn(s)
	; executed; cut out of the PROBABLE region 6750-67DB by apply_coverage --split [executed in 1
	; scenarios]
	dec a
	jr z, .l6768
	dec a
	jr z, .l67A5
	dec a
	jr z, .l675A

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6750-67DB by apply_coverage --split
	ret

.l675A ; 75:675A
	; [CONFIRMED] 61 insn(s) executed; cut out of the PROBABLE region 6750-67DB by apply_coverage
	; --split [executed in 1 scenarios]
	xor a, a
	ld [wMobileSDK_ConnectionFlag], a
	ld a, $30
	call MobileSDK_EnterErrorState
	set 1, [hl]
	res 0, [hl]
	ret
.l6768 ; 75:6768
	call MobileSDK_ReplyLineComplete
	jr nz, .l6790
	ld hl, $C71F
	call MobileSDK_ParseReplyCode
	ld a, $02
	cp a, d
	jr nz, .l67CD
	ld a, $20
	cp a, e
	jr nz, .l67CD
	call Function_75_673A
	ld a, [wMobileSDK_PacketBuffer + 117]
	add a, $0A
	ld e, a
	ld d, $00
	ld a, $95
	ld hl, $CA54
	jp Mobile_PacketSendExpect
.l6790 ; 75:6790
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $9F
	jr z, MobileSDK_SmtpConnectionLost
	ld hl, $C70A
	dec [hl]
	xor a, a
	ld [wMobileSDK_ReceivePacketBuffer + 3], a
	ld hl, $CA44
	jp Mobile_PacketSendTransferData
.l67A5 ; 75:67A5
	call MobileSDK_ReplyLineComplete
	jr nz, .l6790
	ld hl, $C71F
	call MobileSDK_ParseReplyCode
	ld a, $02
	cp a, d
	jr nz, .l67CD
	ld a, $50
	cp a, e
	jr nz, .l67CD
	ld a, $03
	ld [wMobileSDK_State], a
	ld hl, $C69F
	ld a, [hl]
	and a, $D6
	or a, $80
	ld [hl], a
	xor a, a
	ld [wRam_C827], a
	ret
.l67CD ; 75:67CD
	ld hl, $C6B0
	ld a, e
	ld [hli], a
	ld [hl], d
	ld a, $02
	ld [wMobileSDK_Substep], a
	jp Mobile_CloseTcpConnection

Mobile_PacketSendTransferData:: ; 75:67DB
Function_75_67DB::
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld de, $000B
	ld a, $95
	jp Mobile_PacketSendExpect

MobileSDK_SmtpConnectionLost:: ; 75:67E3
	; [PROBABLE] 11 insn(s) reached by static flow only; seeds: mobile x11; min discovery hops 2;
	; entered by jrcc from 75:6795 (PROBABLE code)
	ld hl, $C6B0
	xor a, a
	ld [hli], a
	ld [hl], a
	xor a, a
	ld [wMobileSDK_ConnectionFlag], a
	ld a, $30
	call MobileSDK_EnterErrorState
	set 1, [hl]
	res 0, [hl]
	ret

MobileSDK_ReplyLineComplete:: ; 75:67F7
Function_75_67F7::
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	call MobileSDK_TrackReplyTail
	ld hl, $C6D1

Label_75_67FD:: ; 75:67FD
	ld a, [hli]
	cp a, $0D
	ret nz
	ld a, [hl]
	cp a, $0A
	ret nz
	ld a, $20
	ld [hl], a
	ret

MobileSDK_ReplyEndOfMultiline:: ; 75:6809
	; [CONFIRMED] 12 insn(s) reached by static flow only; seeds: mobile x12; min discovery hops 3;
	; entered by call from 75:4BA0 (PROBABLE code) | upgraded by classifier 6: all 12 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	call MobileSDK_TrackReplyTail
	ld hl, $C6CE
	ld a, [hli]
	cp a, $0D
	ret nz
	ld a, [hli]
	cp a, $0A
	ret nz
	ld a, [hli]
	cp a, $2E
	ret nz
	jr Label_75_67FD

MobileSDK_TrackReplyTail:: ; 75:681D
Function_75_681D::
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push de
	ld hl, $C8DC
	ld a, [hl]
	dec a
	jr z, .l6843
	ld c, a
	cp a, $05
	jr nc, .l6846

	; [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 0;
	; fall-through of the jrcc at 75:6829 (executed) [executed in 1 scenarios]
	ld a, $05
	sub a, c
	ld b, a
	ld e, c
	ld d, $00
	ld hl, $C6CE
	add hl, de
	ld de, $C6CE
	call MobileSDK_CopyBytes
	ld hl, $C8DE
	ld b, c

.loop ; 75:6840
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 4/18 scenarios)
	call MobileSDK_CopyBytes
.l6843 ; 75:6843
	pop de
	pop bc
	ret
.l6846 ; 75:6846
	sub a, $05
	ld c, a
	ld b, $00
	ld hl, $C8DE
	add hl, bc
	ld b, $05
	ld de, $C6CE
	jr .loop

MobileState_SmtpRecipients:: ; 75:6856
	; [CONFIRMED] 72 insn(s) reached by static flow only; seeds: mobile x72; min discovery hops 0;
	; run starts at SDK/API table entry state15 (analysis/mobile_candidates.json) | 2 insn(s)
	; executed; cut out of the PROBABLE region 6856-68E9 by apply_coverage --split [executed in 5
	; scenarios]
	dec a
	jr z, .l685A

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6856-68E9 by apply_coverage --split
	ret

.l685A ; 75:685A
	; [CONFIRMED] 69 insn(s) executed; cut out of the PROBABLE region 6856-68E9 by apply_coverage
	; --split [executed in 1 scenarios]
	call MobileSDK_ReplyLineComplete
	jr nz, .l68C1
	ld hl, $C71F
	ld a, [hli]
	cp a, $32
	jr nz, MobileSDK_ServerReplyError
	ld a, [hli]
	cp a, $35
	jr nz, MobileSDK_ServerReplyError
	call Function_75_673A
	ld hl, $C71B
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	or a, a
	jr z, .l68B3
	push hl
	ld hl, $C70A
	dec [hl]
	ld bc, $0001
	ld de, $C9F7
	ld hl, $60AB
	call MobileSDK_CopyString
	pop hl
	ld a, $80
	call MobileSDK_CopyStringLen
	ld a, $3E
	ld [de], a
	inc de
	inc c
	ld a, l
	ld [wMobileSDK_DataPointer], a
	ld a, h
	ld [wMobileSDK_DataPointer + 1], a
	call MobileSDK_AppendCrLf
	ld a, c
	ld [wMobileSDK_PacketBuffer + 17], a
	ld b, c
	call Mobile_PacketBuildFooter
	ld hl, $C9F0
	ld d, $00
	ld e, c
	ld a, $95
	jp Mobile_PacketSendExpect
.l68B3 ; 75:68B3
	ld a, $03
	ld [wMobileSDK_State], a
	call MobileSDK_ClearBusyAndPending
	ld a, $01
	ld [wRam_C827], a
	ret
.l68C1 ; 75:68C1
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $9F
	jp z, MobileSDK_SmtpConnectionLost
	ld hl, $C70A
	dec [hl]
	ld hl, $C9E4
	jp Mobile_PacketSendTransferData

MobileSDK_ServerReplyError:: ; 75:68D3
	ld hl, $C71F
	call MobileSDK_ParseReplyCode
	ld hl, $C6B0
	ld a, e
	ld [hli], a
	ld [hl], d
	ld a, $30
	call MobileSDK_EnterErrorState
	set 1, [hl]
	res 0, [hl]
	ret

MobileSDK_ClearBusyAndPending:: ; 75:68E9
Function_75_68E9::
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, $C69F
	res 0, [hl]
	res 2, [hl]
	ret

MobileState_SmtpData:: ; 75:68F1
	; [CONFIRMED] 62 insn(s) reached by static flow only; seeds: mobile x62; min discovery hops 0;
	; run starts at SDK/API table entry state16 (analysis/mobile_candidates.json) | 6 insn(s)
	; executed; cut out of the PROBABLE region 68F1-6974 by apply_coverage --split [executed in 5
	; scenarios]
	dec a
	jr z, .l695D
	dec a
	jr z, .l68FB
	dec a
	jr z, .l6929

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 68F1-6974 by apply_coverage --split
	ret

.l68FB ; 75:68FB
	; [CONFIRMED] 55 insn(s) executed; cut out of the PROBABLE region 68F1-6974 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $9F
	jp z, MobileSDK_SmtpConnectionLost
	call MobileSDK_HttpSendBodyChunk
	ld a, [wMobileSDK_ResultPointer + 1]
	or a, a
	jr nz, .l6917
	ld a, $03
	ld [wMobileSDK_State], a
	ld hl, $C69F
	res 0, [hl]
	ret
.l6917 ; 75:6917
	call Function_75_673A
	ld de, $C9E9
	ld a, $01
	ld [de], a
	inc de
	inc de
	ld b, $01
	call Mobile_PacketBuildFooter
	jr .l6957
.l6929 ; 75:6929
	call MobileSDK_ReplyLineComplete
	jr nz, .l6953
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $9F
	jp z, MobileSDK_SmtpConnectionLost
	ld hl, $C71F
	call MobileSDK_ParseReplyCode
	ld a, d
	cp a, $02
	jr nz, .l6971
	ld a, e
	cp a, $50
	jr nz, .l6971
	ld a, $03
	ld [wMobileSDK_State], a
	call MobileSDK_ClearBusyAndPending
	xor a, a
	ld [wRam_C827], a
	ret
.l6953 ; 75:6953
	ld hl, $C70A
	dec [hl]
.l6957 ; 75:6957
	ld hl, $C9E4
	jp Mobile_PacketSendTransferData
.l695D ; 75:695D
	call MobileSDK_ReplyLineComplete
	jr nz, .l6953
	ld hl, $C71F
	call MobileSDK_ParseReplyCode
	ld a, d
	cp a, $03
	jr nz, .l6971
	ld a, e
	cp a, $54
	ret z
.l6971 ; 75:6971
	jp MobileSDK_ServerReplyError

MobileSDK_AppendCrLf:: ; 75:6974
Function_75_6974::
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 5/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $0D
	ld [de], a
	inc de
	inc c
	ld a, $0A
	ld [de], a
	inc de
	inc c
	ret

MobileState_SessionQuit:: ; 75:697F
	dec a
	jr z, .l6986
	dec a
	jr z, .l699F

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 75:6983 (executed)
	ret

.l6986 ; 75:6986
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 2/18 scenarios)
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $9F
	jr z, .l699C
	call MobileSDK_ReplyLineComplete
	jr z, .l699C

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 75:6990 (executed) | upgraded by classifier 6: all 4 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $C70A
	dec [hl]
	ld hl, $CA04
	jp Mobile_PacketSendTransferData

.l699C ; 75:699C
	; [CONFIRMED] 16 insn(s); 16 executed (in up to 4/18 scenarios)
	jp Mobile_CloseTcpConnection
.l699F ; 75:699F
	xor a, a
	ld [wMobileSDK_ConnectionFlag], a
	ld a, $02
	ld [wMobileSDK_State], a
	ld hl, $C69F
	res 0, [hl]
	res 7, [hl]
	set 5, [hl]
	ret

MobileState_Pop3Login:: ; 75:69B2
	dec a
	jr z, .l69C0
	dec a
	jr z, .l69DF
	dec a
	jr z, .l69FD

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 75:69B9 (executed) | 2 insn(s) executed; cut out of the PROBABLE
	; region 69BB-69C0 by apply_coverage --split [executed in 3 scenarios]
	dec a
	jp z, .l6A33

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 69BB-69C0 by apply_coverage --split
	ret

.l69C0 ; 75:69C0
	; [CONFIRMED] 36 insn(s); 36 executed (in up to 4/18 scenarios)
	call MobileSDK_ReplyLineComplete
	jr nz, .l6A14
	ld a, [wMobileSDK_Window]
	cp a, $2B
	jr nz, .l6A25
	call Function_75_673A
	ld a, [wMobileSDK_PacketBuffer + 101]
	add a, $0A
	ld e, a
	ld d, $00
	ld a, $95
	ld hl, $CA44
	jp Mobile_PacketSendExpect
.l69DF ; 75:69DF
	ld d, a
	call MobileSDK_ReplyLineComplete
	jr nz, .l6A14
	ld a, [wMobileSDK_Window]
	cp a, $2B
	jr nz, .l6A25
	call Function_75_673A
	ld a, [wMobileSDK_PacketBuffer + 165]
	add a, $0A
	ld e, a
	ld a, $95
	ld hl, $CA84
	jp Mobile_PacketSendExpect
.l69FD ; 75:69FD
	call MobileSDK_ReplyLineComplete
	jr nz, .l6A14
	ld a, [wMobileSDK_Window]
	cp a, $2B
	jr nz, .l6A25
	ld a, $04
	ld [wMobileSDK_State], a
	call MobileSDK_ClearBusyAndPending
	set 7, [hl]
	ret

.l6A14 ; 75:6A14
	; [CONFIRMED] 42 insn(s) reached by static flow only; seeds: exec x42; min discovery hops 1;
	; entered by jrcc from 75:69C3 (executed) | 31 insn(s) executed; cut out of the PROBABLE region
	; 6A14-6A6C by apply_coverage --split [executed in 2 scenarios]
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $9F
	jr z, MobileSDK_Pop3ConnectionLost
	ld hl, $C70A
	dec [hl]
	ld hl, $CA64
	jp Mobile_PacketSendTransferData
.l6A25 ; 75:6A25
	ld a, [wMobileSDK_Substep]
	ld [wMobileSDK_PacketBuffer + 32], a
	ld a, $03
	ld [wMobileSDK_Substep], a
	jp Mobile_CloseTcpConnection
.l6A33 ; 75:6A33
	xor a, a
	ld [wMobileSDK_ConnectionFlag], a
	ld de, $0002
	ld a, [wMobileSDK_PacketBuffer + 32]
	cp a, $01
	jr z, MobileSDK_Pop3ReplyError
	inc de

MobileSDK_Pop3ReplyError:: ; 75:6A42
	ld hl, $C69F
	set 1, [hl]
	res 0, [hl]
	ld hl, $C6AF
	ld a, $31
	ld [hli], a
	ld a, e
	ld [hli], a
	ld [hl], d
	ld a, $05
	ld [wMobileSDK_State], a
	ret

MobileSDK_Pop3ConnectionLost:: ; 75:6A58
	; [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6A14-6A6C by apply_coverage --split
	ld hl, $C6B0
	xor a, a
	ld [hli], a
	ld [hl], a
	xor a, a
	ld [wMobileSDK_ConnectionFlag], a
	ld a, $31
	call MobileSDK_EnterErrorState
	set 1, [hl]
	res 0, [hl]
	ret

MobileState_Pop3Stat:: ; 75:6A6C
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 2/18 scenarios)
	dec a
	jr z, .l6A70

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 75:6A6D (executed)
	ret

.l6A70 ; 75:6A70
	; [CONFIRMED] 35 insn(s); 35 executed (in up to 2/18 scenarios)
	call MobileSDK_ReplyLineComplete
	jr nz, .l6AAB
	ld hl, $C71F
	ld a, [hli]
	cp a, $2B
	jr nz, .l6ABC
.loop ; 75:6A7D
	ld a, [hli]
	cp a, $20
	jr nz, .loop
	call MobileSDK_ParseDecimal
	ld a, [wMobileSDK_ResultPointer]
	ld c, a
	ld a, [wMobileSDK_ResultPointer + 1]
	ld b, a
	ld a, e
	ld [bc], a
	inc bc
	ld a, d
	ld [bc], a
	call MobileSDK_ParseDecimal
	ld hl, $C70D
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, $04
	ld [wMobileSDK_State], a
	jp MobileSDK_ClearBusyAndPending

.l6AAB ; 75:6AAB
	; [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 1;
	; entered by jrcc from 75:6A73 (executed) [executed in 1 scenarios]
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $9F
	jr z, MobileSDK_Pop3ConnectionLost
	ld hl, $C70A
	dec [hl]
	ld hl, $CA64
	jp Mobile_PacketSendTransferData
.l6ABC ; 75:6ABC
	ld de, $0005
	jp MobileSDK_Pop3ReplyError

MobileSDK_ParseDecimal:: ; 75:6AC2
Function_75_6AC2::
	; [CONFIRMED] 79 insn(s); 79 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wRam_C711]
	push af
	ld a, [wRam_C712]
	push af
	ld a, [wRam_C713]
	push af
	ld bc, $0000
	ld de, $0000
.loop ; 75:6AD4
	ld a, [hli]
	cp a, $0D
	jr z, .l6B1A
	cp a, $20
	jr z, .l6B1A
	and a, $0F
	ld b, a
	sla e
	rl d
	rl c
	ld a, e
	ld [wRam_C711], a
	ld a, d
	ld [wRam_C712], a
	ld a, c
	ld [wRam_C713], a
	sla e
	rl d
	rl c
	sla e
	rl d
	rl c
	ld a, [wRam_C711]
	add a, e
	ld e, a
	ld a, [wRam_C712]
	adc a, d
	ld d, a
	ld a, [wRam_C713]
	adc a, c
	ld c, a
	ld a, b
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	ld a, $00
	adc a, c
	ld c, a
	jr .loop
.l6B1A ; 75:6B1A
	pop af
	ld [wRam_C713], a
	pop af
	ld [wRam_C712], a
	pop af
	ld [wRam_C711], a
	ret

MobileSDK_ParseReplyCode:: ; 75:6B27
	ld a, [wRam_C711]
	push af
	ld a, [wRam_C712]
	push af
	ld a, [wRam_C713]
	push af
	ld bc, $0300
	ld de, $C711
	call Function_75_6B76
	call nc, Function_75_6B76
	call nc, Function_75_6B76
	dec hl
.loop ; 75:6B43
	ld a, [hli]
	cp a, $0D
	jr z, .l6B4C
	cp a, $20
	jr nz, .loop
.l6B4C ; 75:6B4C
	push hl
	ld hl, $C711
	ld de, $0000
	ld a, b
	or a, a
	jr z, .l6B5F

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 75:6B55 (executed)
	dec a
	jr z, .l6B61
	dec a
	jr z, .l6B65
	jr .l6B68

.l6B5F ; 75:6B5F
	; [CONFIRMED] 26 insn(s); 26 executed (in up to 2/18 scenarios)
	ld a, [hli]
	ld d, a
.l6B61 ; 75:6B61
	ld a, [hli]
	swap a
	ld e, a
.l6B65 ; 75:6B65
	ld a, [hli]
	or a, e
	ld e, a
.l6B68 ; 75:6B68
	pop hl
	pop af
	ld [wRam_C713], a
	pop af
	ld [wRam_C712], a
	pop af
	ld [wRam_C711], a
	ret

Function_75_6B76:: ; 75:6B76
	ld a, [hli]
	cp a, $30
	jr c, .l6B85
	cp a, $3A
	jr nc, .l6B85
	and a, $0F
	ld [de], a
	inc de
	dec b
	ret

.l6B85 ; 75:6B85
	; [PROBABLE] 238 insn(s) reached by static flow only; seeds: exec x2, mobile x236; min discovery
	; hops 0; entered by jrcc from 75:6B79 (executed) | 40 insn(s) never executed in the traced
	; runs; cut out of the PROBABLE region 6B85-6D49 by apply_coverage --split
	scf
	ret

MobileState_Pop3List:: ; 75:6B87
	dec a
	jr z, .l6B8B
	ret
.l6B8B ; 75:6B8B
	call MobileSDK_ReplyLineComplete
	jr nz, .l6BB9
	ld hl, $C71F
	ld a, [hli]
	cp a, $2B
	jr nz, .l6BCB
.l6B98 ; 75:6B98
	ld a, [hli]
	cp a, $20
	jr nz, .l6B98
.l6B9D ; 75:6B9D
	ld a, [hli]
	cp a, $20
	jr nz, .l6B9D
	call MobileSDK_ParseDecimal
	ld hl, $C70D
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, $04
	ld [wMobileSDK_State], a
	jp MobileSDK_ClearBusyAndPending
.l6BB9 ; 75:6BB9
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $9F
	jp z, MobileSDK_Pop3ConnectionLost
	ld hl, $C70A
	dec [hl]
	ld hl, $CA64
	jp Mobile_PacketSendTransferData
.l6BCB ; 75:6BCB
	ld de, $0004
	jp MobileSDK_Pop3ReplyError

MobileState_Pop3Dele:: ; 75:6BD1
	; [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 6B85-6D49 by apply_coverage
	; --split [executed in 14 scenarios]
	dec a
	jr z, .l6BD5
	ret
.l6BD5 ; 75:6BD5
	call MobileSDK_ReplyLineComplete
	jr nz, .l6BEA
	ld hl, $C71F
	ld a, [hli]
	cp a, $2B
	jr nz, .l6BFC
	ld a, $04
	ld [wMobileSDK_State], a
	jp MobileSDK_ClearBusyAndPending
.l6BEA ; 75:6BEA
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $9F
	jp z, MobileSDK_Pop3ConnectionLost
	ld hl, $C70A
	dec [hl]
	ld hl, $CA64
	jp Mobile_PacketSendTransferData

.l6BFC ; 75:6BFC
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6B85-6D49 by apply_coverage --split
	ld de, $0004
	jp MobileSDK_Pop3ReplyError

MobileState_Pop3Retrieve:: ; 75:6C02
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 6B85-6D49 by apply_coverage
	; --split [executed in 16 scenarios]
	dec a
	jr z, .l6C0D
	dec a
	jp z, .l6CF1

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6B85-6D49 by apply_coverage --split
	dec a
	ret nz
	dec [hl]
	ret

.l6C0D ; 75:6C0D
	; [CONFIRMED] 35 insn(s) executed; cut out of the PROBABLE region 6B85-6D49 by apply_coverage
	; --split [executed in 2 scenarios]
	ld a, [wMobileSDK_Window]
	cp a, $2D
	jr nz, .l6C19
	call MobileSDK_ReplyLineComplete
	jr z, .l6C21
.l6C19 ; 75:6C19
	ld a, [wTimerEnable]
	bit 2, a
	jp z, .l6D05
.l6C21 ; 75:6C21
	ld hl, $C70A
	inc [hl]
	ld hl, $C71F
	ld a, [hli]
	cp a, $2B
	jp nz, .l6D36
	ld b, $7F
.loop ; 75:6C30
	ld a, [hli]
	dec b
	cp a, $0A
	jr nz, .loop
	push hl
	ld hl, $C82C
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, b
	ld [wMobileSDK_ReceivedLength], a
	ld a, [hli]
	ld h, [hl]
	sub a, b
	ld l, a
	ld a, h
	sbc a, $00
	ld h, a
	jr nc, .l6C6C

	; [PROBABLE] 22 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6B85-6D49 by apply_coverage --split
	cp a, $FF
	jr nz, .l6C6C
	ld hl, $C82E
	ld a, [hli]
	ld c, a
	inc hl
	ld a, b
	sub a, c
	ld [hli], a
	ld a, [wMobileSDK_DestRemaining]
	ld [hl], a
	ld hl, $C6C6
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	ld [hli], a
	xor a, a
	ld [hl], a
	pop hl
	ld b, c
	jp MobileSDK_CopyBytes

.l6C6C ; 75:6C6C
	; [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 6B85-6D49 by apply_coverage
	; --split [executed in 16 scenarios]
	ld [wRam_C830], a
	ld a, [wMobileSDK_DestRemaining]
	ld c, a
	ld [wRam_C831], a
	push hl
	ld a, l
	sub a, c
	ld l, a
	ld a, h
	sbc a, $00
	ld h, a
	jr nc, .l6CB5

	; [PROBABLE] 32 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6B85-6D49 by apply_coverage --split
	cp a, $FF
	jr nz, .l6CB5
	ld a, c
	ld [wMobileSDK_ReceivePacketBuffer + 1], a
	ld a, [wMobileSDK_ReceivePacketBuffer + 3]
	sub a, c
	pop hl
	ld c, l
	pop hl
	push af
	call MobileSDK_CopyBytes
	pop af
	push de
	ld hl, $C8DD
	ld e, a
	ld d, $00
	add hl, de
	pop de
	ld b, c
	call MobileSDK_CopyBytes
	ld a, [wMobileSDK_ReceivePacketBuffer + 1]
	sub a, c
	ld [wRam_C831], a
	ld hl, $C6C6
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wRam_C82E]
	ld [hli], a
	xor a, a
	ld [hl], a
	ret

.l6CB5 ; 75:6CB5
	; [CONFIRMED] 34 insn(s) executed; cut out of the PROBABLE region 6B85-6D49 by apply_coverage
	; --split [executed in 16 scenarios]
	ld [wRam_C831], a
	ld a, l
	ld [wMobileSDK_DestRemaining], a
	ld a, h
	ld [wMobileSDK_DestRemaining + 1], a
	pop hl
	pop hl
	call MobileSDK_CopyBytes
	ld a, [wMobileSDK_ReceivePacketBuffer + 3]
	sub a, c
	push de
	ld hl, $C8DD
	ld e, a
	ld d, $00
	add hl, de
	pop de
	ld b, c
	call MobileSDK_CopyBytes
	ld a, [wMobileSDK_ReceivedLength]
	add a, c
	ld [wMobileSDK_ReceivedLength], a
	ld a, [wMobileSDK_ReceivedLength + 1]
	adc a, $00
	ld [wMobileSDK_ReceivedLength + 1], a
	ld hl, $C6C8
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
	ld hl, $C69F
	res 2, [hl]
.l6CF1 ; 75:6CF1
	ld a, [wTimerEnable]
	bit 2, a
	jr z, .l6D00

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6B85-6D49 by apply_coverage --split
	ld a, $02
	ld [wMobileSDK_Substep], a
	jp .l6D1F

.l6D00 ; 75:6D00
	; [CONFIRMED] 31 insn(s) executed; cut out of the PROBABLE region 6B85-6D49 by apply_coverage
	; --split [executed in 1 scenarios]
	call MobileSDK_ReplyEndOfMultiline
	jr z, .l6D17
.l6D05 ; 75:6D05
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $9F
	jp z, MobileSDK_Pop3ConnectionLost
	ld hl, $C70A
	dec [hl]
	ld hl, $CA64
	jp Mobile_PacketSendTransferData
.l6D17 ; 75:6D17
	ld a, $04
	ld [wMobileSDK_State], a
	call MobileSDK_ClearBusyAndPending
.l6D1F ; 75:6D1F
	ld a, [wMobileSDK_ResultPointer]
	ld l, a
	ld a, [wMobileSDK_ResultPointer + 1]
	or a, l
	ret z
	ld hl, $C6C6
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, $C6CC
	ld b, $02
	jp MobileSDK_CopyBytes
.l6D36 ; 75:6D36
	ld a, [wMobileSDK_State]
	cp a, $1A
	jr nz, .l6D43
	ld de, $0004
	jp MobileSDK_Pop3ReplyError
.l6D43 ; 75:6D43
	ld de, $0004
	jp MobileSDK_Pop3ReplyError

MobileState_HttpExchange:: ; 75:6D49
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 2/18 scenarios)
	dec a
	jr z, Label_75_6D9D
	dec a
	jr z, Label_75_6DB5
	dec a
	jp z, Label_75_6E5C
	dec a
	jr z, Label_75_6D63
	dec a
	jp z, MobileSDK_HttpBuildRequest
	dec a
	jp z, Label_75_73BE

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jpcc at 75:6D5B (executed) [executed in 1 scenarios]
	dec a
	jp Label_75_6E5C

; ---- data $6D62-$6D63 (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_75_6D62:: ; 75:6D62
	db $C9

Label_75_6D63:: ; 75:6D63
	; [CONFIRMED] 31 insn(s) reached by static flow only; seeds: exec x31; min discovery hops 1;
	; entered by jrcc from 75:6D54 (executed) | 9 insn(s) executed; cut out of the PROBABLE region
	; 6D63-6D9D by apply_coverage --split [executed in 2 scenarios]
	ld a, [wMobileSDK_State]
	cp a, $23
	jr z, .l6D83
	cp a, $1F
	jr z, .l6D76
	cp a, $20
	jr z, .l6D83
	cp a, $22
	jr nz, .l6D98

.l6D76 ; 75:6D76
	; [PROBABLE] 19 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6D63-6D9D by apply_coverage --split
	ld hl, $C828
	ld a, [hli]
	cp a, $01
	jr nz, .l6D98
	ld a, [hl]
	cp a, $04
	jr nz, .l6D98
.l6D83 ; 75:6D83
	ld hl, $C70D
	xor a, a
	ld [hli], a
	ld [hl], a
	ld hl, $C6CA
	ld [hli], a
	ld [hl], a
	ld hl, $C69F
	res 2, [hl]
	ld hl, $C70A
	dec [hl]
	dec [hl]

.l6D98 ; 75:6D98
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 6D63-6D9D by apply_coverage
	; --split [executed in 2 scenarios]
	ld hl, $C70A
	dec [hl]
	ret

Label_75_6D9D:: ; 75:6D9D
	; [CONFIRMED] 44 insn(s); 44 executed (in up to 2/18 scenarios)
	call MobileSDK_HttpSendBodyChunk
	ld de, $C9E4
	ld hl, MobilePacket_TransferData
	ld b, $06
	call MobileSDK_CopyBytes
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	ld b, $01
	call Mobile_PacketBuildFooter

Label_75_6DB5:: ; 75:6DB5
	ld a, [wTimerEnable]
	bit 2, a
	jr z, .l6DC1
	ld a, $03
	ld [hl], a
	jr .l6DD7
.l6DC1 ; 75:6DC1
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $9F
	jr z, .l6DD7
	ld hl, $C70A
	dec [hl]
	ld de, $000B
	ld hl, $C9E4
	ld b, $05
	jp Mobile_PacketSendBytes
.l6DD7 ; 75:6DD7
	ld a, [wMobileSDK_HttpParseState]
	cp a, $02
	jr nc, .l6E08
	call MobileSDK_HttpParseResponseHeaders
	bit 2, a
	ret nz
	cp a, $03
	jr z, .l6E4E
	cp a, $01
	jr nz, .l6E08
	ld a, [wMobileSDK_State]
	cp a, $1F
	jr z, .l6DF7
	cp a, $20
	jr nz, .l6E08
.l6DF7 ; 75:6DF7
	ld hl, $C828
	ld a, [hli]
	cp a, $01
	jr nz, .l6E08

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 75:6DFD (executed)
	ld a, $04
	cp a, [hl]
	jr nz, .l6E08
	xor a, a
	ld [wRam_C82D], a

.l6E08 ; 75:6E08
	; [CONFIRMED] 22 insn(s); 22 executed (in up to 2/18 scenarios)
	ld a, [wMobileSDK_ResultPointer]
	ld l, a
	ld a, [wMobileSDK_ResultPointer + 1]
	or a, l
	ret z
	ld a, [wMobileSDK_State]
	cp a, $13
	jr z, .l6E37
	cp a, $14
	jr z, .l6E37
	cp a, $20
	ret z
	cp a, $22
	ret z
	cp a, $23
	ret z
	cp a, $1F
	jr nz, .l6E37
	ld hl, $C828
	ld a, [hli]
	cp a, $00
	ret nz

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the retcc at 75:6E2F (executed)
	ld a, $02
	cp a, [hl]
	ret nz
	ld a, [wMobileSDK_State]

.l6E37 ; 75:6E37
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 2/18 scenarios)
	cp a, $24
	jr nz, .l6E40

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:6E39 (executed)
	ld hl, $C717
	jr .l6E43

.l6E40 ; 75:6E40
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 2/18 scenarios)
	ld hl, $C6C6
.l6E43 ; 75:6E43
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, $C6CC
	ld b, $02
	jp MobileSDK_CopyBytes

.l6E4E ; 75:6E4E
	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 1;
	; entered by jrcc from 75:6DE6 (executed)
	ld hl, $C69F
	set 1, [hl]
	res 0, [hl]
	ld de, $C828
	ld a, $24
	jr Label_75_6EAB

Label_75_6E5C:: ; 75:6E5C
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 2/18 scenarios)
	ld a, [wMobileSDK_State]
	cp a, $1F
	jr z, Label_75_6EBC
	cp a, $20
	jr z, Label_75_6EBC
	ld a, [wRam_C827]
	cp a, $01
	jr z, .l6E7B
	ld a, [wMobileSDK_State]
	cp a, $21
	jp z, Label_75_6F00
	cp a, $22
	jp z, Label_75_6F00
.l6E7B ; 75:6E7B
	ld a, [wRam_C82D]
	or a, a
	jp z, Label_75_6F53

Label_75_6E82:: ; 75:6E82
	ld hl, $C829
	ld a, [hld]
	cp a, $03
	jr nz, Label_75_6E95

	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 75:6E88 (executed) [executed in 1 scenarios]
	ld a, [hl]
	or a, a
	jr z, Label_75_6E95
	cp a, $03
	jr nc, Label_75_6E95
	call MobileSDK_HttpBuildRedirectUrl

Label_75_6E95:: ; 75:6E95
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 1/18 scenarios)
	ld hl, $C69F
	set 1, [hl]
	res 0, [hl]
	ld de, $C828
	ld a, [wRam_C82D]
	cp a, $01
	ld a, $32
	jr z, Label_75_6EAB

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 75:6EA6 (executed) [executed in 1 scenarios]
	inc de
	inc de
	inc a

Label_75_6EAB:: ; 75:6EAB
	; [CONFIRMED] 16 insn(s); 16 executed (in up to 1/18 scenarios)
	ld [wMobileSDK_ErrorCode], a
	ld hl, $C6B0
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	ld a, $05
	ld [wMobileSDK_State], a
	ret

Label_75_6EBC:: ; 75:6EBC
	ld hl, $C828
	ld a, [hli]
	ld h, [hl]
	ld l, a
	cp a, $00
	jr nz, .l6ED7

	; [PROBABLE] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0;
	; fall-through of the jrcc at 75:6EC4 (executed)
	ld a, $02
	cp a, h
	jr nz, .l6ED7
	ld a, [wMobileSDK_GbStatus]
	ld b, a
	ld a, [wMobileSDK_GbStatus + 1]
	or a, b
	jr nz, Label_75_6E82
	jr Label_75_6F53

.l6ED7 ; 75:6ED7
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ld a, $01
	cp a, l
	jr nz, Label_75_6E82

	; [PROBABLE] 55 insn(s) reached by static flow only; seeds: exec x55; min discovery hops 0;
	; fall-through of the jrcc at 75:6EDA (executed)
	ld a, $04
	cp a, h
	jr nz, Label_75_6E82
	ld a, [wMobileSDK_ContentLengthDigits]
	or a, a
	jr nz, Label_75_6F11
	ld a, [wMobileSDK_ResultPointer]
	ld l, a
	ld a, [wMobileSDK_ResultPointer + 1]
	or a, l
	jr nz, Label_75_6F11
	ld a, $02
	ld [wMobileSDK_State], a
	xor a, a
	ld [wMobileSDK_ConnectionFlag], a
	ld hl, $C69F
	res 0, [hl]
	ret

Label_75_6F00:: ; 75:6F00
	ld hl, $C828
	ld a, [hli]
	ld h, [hl]
	ld l, a
	cp a, $00
	jp nz, Label_75_6E82
	ld a, $02
	cp a, h
	jp nz, Label_75_6E82

Label_75_6F11:: ; 75:6F11
	ld a, [wMobileSDK_GbStatus]
	ld b, a
	ld a, [wMobileSDK_GbStatus + 1]
	cp a, b
	jp nz, Label_75_6E82
	or a, a
	jr z, .l6F29
	cp a, $01
	jp nz, Label_75_6E82
	ld a, $01
	ld [wRam_C830], a
.l6F29 ; 75:6F29
	ld a, [wMobileSDK_Substep]
	cp a, $07
	jr z, Label_75_6F53
	ld hl, $C82C
	inc [hl]
	ld a, $0F
	ld [wMobileSDK_State], a
	ld a, $01
	ld [wMobileSDK_Substep], a
	ld a, [wMobileSDK_ConnectionFlag]
	ld [wMobileSDK_ResultPointer], a
	xor a, a
	ld [wMobileSDK_HttpParseState], a
	ld a, $A3
	ld de, $0010
	ld hl, $C832
	jp Mobile_PacketSendExpect

Label_75_6F53:: ; 75:6F53
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ld a, [wRam_C830]
	cp a, $01
	jr nz, .l6F68

	; [PROBABLE] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0;
	; fall-through of the jrcc at 75:6F58 (executed)
	ld a, $02
	ld [wRam_C82D], a
	ld hl, $C82A
	dec a
	ld [hli], a
	ld [hl], a
	jp Label_75_6E95

.l6F68 ; 75:6F68
	; [CONFIRMED] 35 insn(s); 35 executed (in up to 2/18 scenarios)
	ld a, $02
	ld [wMobileSDK_State], a
	xor a, a
	ld [wMobileSDK_ConnectionFlag], a
	ld hl, $C69F
	res 0, [hl]
	ret

MobileSDK_HttpParseResponseHeaders:: ; 75:6F77
	ld hl, $C826
	ld a, [hl]
	or a, a
	jr nz, .l6FA0
	inc [hl]
	ld hl, $C71F
	ld de, $0008
	add hl, de
.loop ; 75:6F86
	ld a, [hli]
	cp a, $20
	jr z, .loop
	dec hl
	ld d, $00
	cp a, $32
	jr z, .skip
	inc d
.skip ; 75:6F93
	ld a, d
	ld [wRam_C82D], a
	call MobileSDK_ParseReplyCode
	ld hl, $C828
	ld a, e
	ld [hli], a
	ld [hl], d
.l6FA0 ; 75:6FA0
	ld hl, $C71F
	ld a, [wMobileSDK_ReceivedLength]
	ld b, a
	or a, a
	jr nz, .l6FB7

	; [PROBABLE] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0;
	; fall-through of the jrcc at 75:6FA8 (executed)
	ld hl, $C828
	ld a, $00
	ld [hli], a
	ld [hl], a
	ld a, $01
	ld [wRam_C82D], a
	ret

.l6FB7 ; 75:6FB7
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 2/18 scenarios)
	call MobileSDK_HttpHdrDate
	call MobileSDK_HttpHdrGbStatus
	call MobileSDK_HttpHdrGbAuthId
	call MobileSDK_HttpHdrWwwAuthenticate
	call MobileSDK_HttpHdrUriHeader
	call MobileSDK_HttpHdrLocation
	push hl
	call MobileSDK_FindLineEnd
	jr c, .l6FE1
	pop de
	ld a, $0D
	cp a, [hl]
	jr z, .l6FDA
	ld a, $0A
	cp a, [hl]
	jr nz, .l6FB7
.l6FDA ; 75:6FDA
	ld hl, $C82D
	res 2, [hl]
	jr .l7006

.l6FE1 ; 75:6FE1
	; [PROBABLE] 19 insn(s) reached by static flow only; seeds: exec x19; min discovery hops 1;
	; entered by jrcc from 75:6FCD (executed)
	pop hl
	ld a, l
	cp a, $1F
	jr nz, .l7001
	ld a, h
	cp a, $C7
	jr nz, .l7001
	ld a, $01
	ld [wRam_C82D], a
	ld hl, $C828
	xor a, a
	ld [hli], a
	ld [hl], a
	ld a, $0D
	ld [wMobileSDK_Window + 248], a
	ld a, $0A
	ld [wMobileSDK_Window + 249], a
.l7001 ; 75:7001
	ld hl, $C82D
	set 2, [hl]

.l7006 ; 75:7006
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 2/18 scenarios)
	call Function_75_70A3
	ld a, [wRam_C82D]
	ret

MobileSDK_HttpHdrDate:: ; 75:700D
	ld de, $7039
	push hl
	call MobileSDK_MatchPrefixNoCase
	jr nc, .l7018
	pop hl
	ret

.l7018 ; 75:7018
	; [PROBABLE] 23 insn(s) reached by static flow only; seeds: exec x23; min discovery hops 1;
	; entered by jrcc from 75:7014 (executed)
	pop de
	push bc
	push de
	push hl
	ld b, $00
.loop ; 75:701E
	inc b
	ld a, [hli]
	cp a, $0A
	jr nz, .loop
	pop hl
	ld c, b
	ld a, [wMobileSDK_HttpDatePtr]
	ld e, a
	ld a, [wMobileSDK_HttpDatePtr + 1]
	ld d, a
	or a, e
	jr z, .l7036
	call MobileSDK_CopyBytes
	xor a, a
	ld [de], a
.l7036 ; 75:7036
	pop hl
	pop bc
	ret

; ---- text $7039-$7040 (7 bytes) [PROBABLE] NUL-terminated ASCII "date: " (7 bytes incl. NUL); follows the ret at 75:7038

String_75_7039:: ; 75:7039
	db $64, $61, $74, $65, $3A, $20, $00 ; "date: "

MobileSDK_HttpHdrGbStatus:: ; 75:7040
Function_75_7040::
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld de, MobileStr_HdrGbStatus
	push hl
	call MobileSDK_MatchPrefix
	jr nc, .l704B
	pop hl
	ret

.l704B ; 75:704B
	; [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1;
	; entered by jrcc from 75:7047 (executed) [executed in 1 scenarios]
	call MobileSDK_ParseReplyCode
	ld hl, $C82A
	ld a, e
	ld [hli], a
	ld [hl], d
	pop hl
	ld a, d
	or a, e
	ret z
	ld a, $02
	ld [wRam_C82D], a
	ret

MobileSDK_HttpHdrGbAuthId:: ; 75:705E
Function_75_705E::
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld de, MobileStr_HdrGbAuthId
	push hl
	call MobileSDK_MatchPrefix
	jr nc, .l7069
	pop hl
	ret

.l7069 ; 75:7069
	; [PROBABLE] 22 insn(s) reached by static flow only; seeds: exec x22; min discovery hops 1;
	; entered by jrcc from 75:7065 (executed)
	pop hl
	push bc
	push hl
	push hl
	ld b, $00
.loop ; 75:706F
	inc b
	ld a, [hli]
	cp a, $0A
	jr nz, .loop
	pop hl
	ld c, b
	ld de, $C9F6
	call MobileSDK_CopyBytes
	ld hl, $C9F6
	ld de, $C852
	ld b, c
	call MobileSDK_CopyBytes
	xor a, a
	ld [de], a
	pop hl
	pop bc
	ret

MobileSDK_HttpHdrWwwAuthenticate:: ; 75:708C
Function_75_708C::
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld de, $72F7
	push hl
	call MobileSDK_MatchPrefix
	jr nc, .l7097
	pop hl
	ret

.l7097 ; 75:7097
	; [CONFIRMED] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 1;
	; entered by jrcc from 75:7093 (executed) [executed in 1 scenarios]
	push bc
	ld de, $C852
	ld b, $30
	call MobileSDK_AuthBuildResponse
	pop bc
	pop hl
	ret

Function_75_70A3:: ; 75:70A3
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, $C71F
	ld a, [wMobileSDK_ReceivedLength]
	ld b, a
.loop ; 75:70AA
	call MobileSDK_FindLineEnd
	jp nc, .l70C1

	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0;
	; fall-through of the jpcc at 75:70AD (executed)
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $9F
	jp nz, Label_75_71E1
	push hl
	ld hl, $C82D
	res 2, [hl]
	pop hl
	jr MobileSDK_HttpBodyStart

.l70C1 ; 75:70C1
	; [CONFIRMED] 23 insn(s); 23 executed (in up to 2/18 scenarios)
	ld a, [hl]
	cp a, $0D
	jr z, .l70CC
	cp a, $0A
	jr z, MobileSDK_HttpBodyStart
	jr .loop
.l70CC ; 75:70CC
	inc hl

MobileSDK_HttpBodyStart:: ; 75:70CD
	inc hl
	push bc
	ld a, [wRam_C711]
	ld b, a
	ld a, [wRam_C712]
	or a, b
	pop bc
	jr z, .l70EB
	ld a, [wMobileSDK_State]
	cp a, $23
	jr z, .l70EB
	cp a, $20
	jr z, .l70EB
	cp a, $22
	jr z, .l70EB
	jr .l710E

.l70EB ; 75:70EB
	; [PROBABLE] 17 insn(s) reached by static flow only; seeds: exec x17; min discovery hops 1;
	; entered by jrcc from 75:70D8 (executed)
	xor a, a
	ld hl, $C70D
	ld [hli], a
	ld [hl], a
	ld hl, $C69F
	res 2, [hl]
	ld a, [wMobileSDK_State]
	cp a, $13
	jr z, .l7100
	cp a, $14
	ret nz
.l7100 ; 75:7100
	ld a, $06
	ld [wMobileSDK_Substep], a
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $9F
	ret z
	jp Mobile_CloseTcpConnection

.l710E ; 75:710E
	; [CONFIRMED] 16 insn(s); 16 executed (in up to 2/18 scenarios)
	ld a, [wMobileSDK_DestRemaining]
	ld c, a
	dec b
	dec b
	ld a, b
	ld [wMobileSDK_ReceivedLength], a
	jr z, .l7145
	ld a, [wRam_C712]
	ld d, a
	ld a, [wRam_C711]
	ld e, a
	dec de
	dec de
	xor a, a
	or a, d
	jr nz, .l712D

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 75:7126 (executed)
	ld a, e
	cp a, b
	jp c, Label_75_723E

.l712D ; 75:712D
	; [CONFIRMED] 34 insn(s); 34 executed (in up to 2/18 scenarios)
	ld a, e
	sub a, b
	ld [wMobileSDK_DestRemaining], a
	ld a, d
	sbc a, $00
	ld [wMobileSDK_DestRemaining + 1], a
	ld a, [wRam_C713]
	ld e, a
	ld a, [wRam_C714]
	ld d, a
	inc de
	inc de
	call MobileSDK_CopyBytes
.l7145 ; 75:7145
	ld a, [wMobileSDK_ReceivePacketBuffer]
	cp a, $9F
	jr z, .l7188
	ld a, [wMobileSDK_ReceivePacketBuffer + 3]
	or a, a
	jr z, .l7188
	ld l, c
	sub a, c
	ld c, a
	ld a, l
	ld hl, $C8DD
	add hl, bc
	ld b, a
	push de
	ld a, [wMobileSDK_DestRemaining]
	ld e, a
	ld a, [wMobileSDK_DestRemaining + 1]
	ld d, a
	xor a, a
	or a, d
	jr nz, .l716D

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 75:7166 (executed)
	ld a, e
	cp a, b
	jp c, Label_75_727D

.l716D ; 75:716D
	; [CONFIRMED] 37 insn(s); 37 executed (in up to 2/18 scenarios)
	pop de
	push hl
	ld hl, $C6CC
	ld a, [hl]
	add a, b
	ld [hli], a
	ld a, [hl]
	adc a, $00
	ld [hl], a
	ld c, b
	pop hl
	call MobileSDK_CopyBytes
	ld hl, $C6CA
	ld a, [hl]
	sub a, c
	ld [hli], a
	ld a, [hl]
	sbc a, $00
	ld [hl], a
.l7188 ; 75:7188
	ld hl, $C6C8
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
	ld hl, $C69F
	res 2, [hl]
	ld a, $01
	ld [wMobileSDK_Substep], a
	ld a, $02
	ld [wMobileSDK_HttpParseState], a
	ret

MobileSDK_HttpHdrUriHeader:: ; 75:719F
	ld de, MobileStr_HdrUriHeader
	push hl
	call MobileSDK_MatchPrefix
	jr nc, .l71AA
	pop hl
	ret

.l71AA ; 75:71AA
	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 1;
	; entered by jrcc from 75:71A6 (executed)
	pop de
	push bc
	push de
	push hl
	ld b, $00
.loop ; 75:71B0
	inc b
	ld a, [hli]
	cp a, $0A
	jr nz, .loop
	jr MobileSDK_HttpStoreHeaderValue

MobileSDK_HttpHdrLocation:: ; 75:71B8
Function_75_71B8::
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld de, $7344
	push hl
	call MobileSDK_MatchPrefix
	jr nc, .l71C3
	pop hl
	ret

.l71C3 ; 75:71C3
	; [CONFIRMED] 133 insn(s) reached by static flow only; seeds: exec x133; min discovery hops 1;
	; entered by jrcc from 75:71BF (executed) | 23 insn(s) executed; cut out of the PROBABLE region
	; 71C3-72A0 by apply_coverage --split [executed in 3 scenarios]
	pop de
	push bc
	push de
	push hl
	ld b, $00
.loop ; 75:71C9
	inc b
	ld a, [hli]
	cp a, $0A
	jr nz, .loop

MobileSDK_HttpStoreHeaderValue:: ; 75:71CF
	pop hl
	ld c, b
	ld de, $C9F4
	ld a, b
	ld [de], a
	inc de
	dec b
	dec b
	call MobileSDK_CopyBytes
	xor a, a
	ld [de], a
	pop hl
	pop bc
	ret

Label_75_71E1:: ; 75:71E1
	; [PROBABLE] 110 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 71C3-72A0 by apply_coverage --split
	ld hl, $C818
	ld de, $C71F
	ld b, $00
	ld c, b
	ld a, [hl]
	cp a, $0A
	jr z, .l71FC
.l71EF ; 75:71EF
	ld a, [hld]
	inc b
	cp a, $0A
	jr nz, .l71EF
	inc hl
	inc hl
	dec b
	ld c, b
	call MobileSDK_CopyBytes
.l71FC ; 75:71FC
	ld a, [wMobileSDK_DestRemaining]
	ld b, a
	add a, c
	ld c, a
	push bc
	ld a, $FF
	sub a, b
	ld c, a
	ld b, $00
	ld hl, $C8DD
	add hl, bc
	pop bc
	call MobileSDK_CopyBytes
	ld a, c
	ld [wMobileSDK_ReceivedLength], a
	ld a, $FA
	sub a, c
	ld [wMobileSDK_DestRemaining], a
	ld hl, $C6C8
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
	ld l, e
	ld h, d
	ld de, $C819
.l7227 ; 75:7227
	xor a, a
	ld [hli], a
	ld a, l
	cp a, e
	jr nz, .l7227
	ld a, d
	cp a, h
	jr nz, .l7227
	ld hl, $C69F
	res 2, [hl]
	ld hl, $C70A
	dec [hl]
	dec [hl]
	ld a, $04
	ret

Label_75_723E:: ; 75:723E
	ld a, b
	sub a, e
	ld [wRam_C82E], a
	ld a, [wTimerEnable]
	bit 2, a
	ld a, c
	jr nz, .skip
	xor a, a
.skip ; 75:724C
	ld [wRam_C82F], a
	ld b, e
	ld c, e
	ld a, [wRam_C713]
	ld e, a
	ld a, [wRam_C714]
	ld d, a
	inc de
	inc de
	call MobileSDK_CopyBytes
	ld a, [wRam_C82E]
	ld [wRam_C830], a
	ld b, a
	ld de, $C71F
	call MobileSDK_CopyBytes
	ld hl, $C6CC
	ld a, c
	ld [hli], a
	xor a, a
	ld [hl], a
	ld hl, $C69F
	set 2, [hl]
	ld a, $03
	ld [wMobileSDK_Substep], a
	ret

Label_75_727D:: ; 75:727D
	ld a, b
	sub a, e
	ld [wRam_C82F], a
	ld [wMobileSDK_DestRemaining], a
	ld b, e
	ld c, e
	pop de
	call MobileSDK_CopyBytes
	ld hl, $C6CC
	ld a, c
	add a, [hl]
	ld [hli], a
	ld a, $00
	adc a, [hl]
	ld [hl], a
	ld hl, $C69F
	set 2, [hl]
	ld a, $03
	ld [wMobileSDK_Substep], a
	ret

MobileSDK_FindLineEnd:: ; 75:72A0
Function_75_72A0::
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	dec b
	ld a, [hli]
	cp a, $0A
	ret z
	xor a, a
	or a, b
	jr nz, MobileSDK_FindLineEnd

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:72A7 (executed)
	scf
	ret

MobileSDK_MatchPrefix:: ; 75:72AB
Function_75_72AB::
	; [CONFIRMED] 41 insn(s); 41 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld c, $00
.loop ; 75:72AD
	ld a, [de]
	inc de
	or a, a
	ret z
	xor a, [hl]
	inc hl
	or a, c
	ld c, a
	jr z, .loop
	scf
	ret

MobileSDK_MatchPrefixNoCase:: ; 75:72B9
	ld c, $00
	push hl
	ld l, e
	ld h, d
	pop de
.loop ; 75:72BF
	ld a, [de]
	inc de
	call MobileSDK_ToLower
	xor a, [hl]
	inc hl
	or a, c
	ld c, a
	xor a, a
	cp a, [hl]
	jr z, .l72D0
	cp a, c
	jr z, .loop
	scf
.l72D0 ; 75:72D0
	push hl
	ld l, e
	ld h, d
	pop de
	ret

MobileSDK_ToLower:: ; 75:72D5
	cp a, $41
	ret c
	cp a, $5B
	ret nc
	or a, $20
	ret

; ---- text $72DE-$72EA (12 bytes) [PROBABLE] NUL-terminated ASCII "Gb-Status: " (HTTP header name)

MobileStr_HdrGbStatus:: ; 75:72DE
String_75_72DE::
	db $47, $62, $2D, $53, $74, $61, $74, $75, $73, $3A, $20, $00 ; "Gb-Status: "

; ---- text $72EA-$7315 (43 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

MobileStr_HdrGbAuthId:: ; 75:72EA
String_75_72EA::
	db $47, $62, $2D, $41, $75, $74, $68, $2D, $49, $44, $3A, $20, $00 ; "Gb-Auth-ID: "

MobileStr_HdrWwwAuthenticate:: ; 75:72F7
	db $57, $57, $57, $2D, $41, $75, $74, $68, $65, $6E, $74, $69, $63, $61, $74, $65, $3A, $20, $47, $42, $30, $30, $20, $6E, $61, $6D, $65, $3D, $22, $00 ; "WWW-Authenticate: GB00 name=\""

; ---- text $7315-$7337 (34 bytes) [PROBABLE] NUL-terminated ASCII "Content-Type: application/x-cgb" CRLF; passed in HL to 75:4007 at 75:7362 (ld hl,$7315)

MobileStr_HdrContentTypeCgb:: ; 75:7315
String_75_7315::
	db $43, $6F, $6E, $74, $65, $6E, $74, $2D, $54, $79, $70, $65, $3A, $20, $61, $70, $70, $6C, $69, $63, $61, $74, $69, $6F, $6E, $2F, $78, $2D, $63, $67, $62, $0D, $0A, $00 ; "Content-Type: application/x-cgb<$0D><$0A>"

; ---- text $7337-$734F (24 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

MobileStr_HdrUriHeader:: ; 75:7337
String_75_7337::
	db $55, $52, $49, $2D, $68, $65, $61, $64, $65, $72, $3A, $20, $00 ; "URI-header: "

MobileStr_HdrLocation:: ; 75:7344
	db $4C, $6F, $63, $61, $74, $69, $6F, $6E, $3A, $20, $00 ; "Location: "

MobileSDK_HttpBuildRequest:: ; 75:734F
	; [PROBABLE] 38 insn(s) reached by static flow only; seeds: exec x38; min discovery hops 1;
	; entered by jpcc from 75:6D57 (executed)
	ld a, $01
	ld [wMobileSDK_Substep], a
	ld de, $C9F6
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	ld bc, $0001
	call MobileSDK_HttpCopyVersion
	ld hl, MobileStr_HdrContentTypeCgb
	ld a, [wMobileSDK_ContentLengthDigits]
	or a, a
	call nz, MobileSDK_CopyString
	ld a, [wMobileSDK_State]
	cp a, $22
	jr nz, .l737C
	ld a, [wRam_C827]
	cp a, $02
	jr nz, .l7389
	jr .l7380
.l737C ; 75:737C
	cp a, $24
	jr nz, .l7389
.l7380 ; 75:7380
	ld a, [wMobileSDK_ContentLengthDigits]
	or a, a
	jr z, .l73A2
	call MobileSDK_HttpAddContentLength
.l7389 ; 75:7389
	ld hl, $C852
	call MobileSDK_CopyString
	call MobileSDK_HttpUserAgentLine
	ld a, c
	ld [wMobileSDK_PacketBuffer + 17], a
	ld b, c
	call Mobile_PacketBuildFooter
	ld a, $95
	ld hl, $C9F0
	jp Mobile_PacketSendExpect
.l73A2 ; 75:73A2
	ld hl, MobileStr_ContentLengthZero
	call MobileSDK_CopyString
	jr .l7389

; ---- text $73AA-$73BE (20 bytes) [PROBABLE] NUL-terminated ASCII "Content-Length: 0" CRLF; ld hl,$73AA at 75:73A2 followed by call $4007

MobileStr_ContentLengthZero:: ; 75:73AA
String_75_73AA::
	db $43, $6F, $6E, $74, $65, $6E, $74, $2D, $4C, $65, $6E, $67, $74, $68, $3A, $20, $30, $0D, $0A, $00 ; "Content-Length: 0<$0D><$0A>"

Label_75_73BE:: ; 75:73BE
	; [CONFIRMED] 48 insn(s); 48 executed (in up to 2/18 scenarios)
	call MobileSDK_HttpSendBodyChunk
	ld a, $01
	ld [wMobileSDK_Substep], a
	ld de, $C9E4
	ld hl, MobilePacket_TransferData
	ld b, $06
	call MobileSDK_CopyBytes
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	ld b, $01
	call Mobile_PacketBuildFooter
	ld de, $C9F0
	ld hl, MobilePacket_TransferData
	ld b, $06
	call MobileSDK_CopyBytes
	ld a, [wMobileSDK_ConnectionFlag]
	cp a, $03
	jp nz, MobileSDK_HttpBuildRequest
	ld de, $C9F6
	ld a, [wMobileSDK_ConnectionId]
	ld [de], a
	inc de
	ld bc, $0001
	call MobileSDK_HttpCopyVersion
	ld a, [wRam_C831]
	or a, a
	call nz, MobileSDK_HttpAddContentLength
	call MobileSDK_HttpUserAgentLine
	ld a, c
	ld [wMobileSDK_PacketBuffer + 17], a
	ld b, c
	call Mobile_PacketBuildFooter
	ld a, $95
	ld hl, $C9F0
	jp Mobile_PacketSendExpect

MobileSDK_HttpAddContentLength:: ; 75:7416
	call MobileSDK_HttpContentLengthLine
	xor a, a
	ld [wMobileSDK_Substep], a
	ld a, [wRam_C847]
	ld [wMobileSDK_DataPointer], a
	ld a, [wRam_C848]
	ld [wMobileSDK_DataPointer + 1], a
	ld a, [wRam_C849]
	ld [wMobileSDK_DataLength], a
	ld a, [wRam_C84A]
	ld [wMobileSDK_DataLength + 1], a
	ret

MobileSDK_HttpBuildRedirectUrl:: ; 75:7436
	; [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1;
	; entered by call from 75:6E92 (PROBABLE code) [executed in 1 scenarios]
	ld hl, $C9F4
	ld de, $C71F
	ld a, [hli]
	ld b, a
	call MobileSDK_CopyBytes
	xor a, a
	ld [de], a
	ret

MobileSDK_HttpSendBodyChunk:: ; 75:7444
Function_75_7444::
	; [CONFIRMED] 23 insn(s); 23 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, $C71E
	ld a, [hld]
	ld b, a
	ld a, [hld]
	ld c, a
	ld a, b
	or a, c
	ret z
	pop hl
	ld hl, $FF02
	add hl, bc
	jr c, .l7458
	xor a, a
	ld l, a
	ld h, a
.l7458 ; 75:7458
	ld e, l
	ld d, h
	ld hl, $C71E
	ld a, d
	ld [hld], a
	ld a, e
	ld [hld], a
	jr nc, .l7465

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 75:7461 (executed) [executed in 2 scenarios]
	ld c, $FE

.l7465 ; 75:7465
	; [CONFIRMED] 21 insn(s); 21 executed (in up to 2/18 scenarios)
	ld a, [hld]
	ld l, [hl]
	ld h, a
	ld a, c
	inc a
	ld [wMobileSDK_PacketBuffer + 5], a
	ld de, $C9EB
	ld b, c
	call MobileSDK_CopyBytes
	ld a, l
	ld [wMobileSDK_DataPointer], a
	ld a, h
	ld [wMobileSDK_DataPointer + 1], a
	ld b, c
	inc b
	call Mobile_PacketBuildFooter
	ld hl, $C70A
	dec [hl]
	ld hl, $C9E4
	ld a, $95
	jp Mobile_PacketSendExpect

MobileState_TelephoneStatus:: ; 75:748D
	; [PROBABLE] 39 insn(s) reached by static flow only; seeds: mobile x39; min discovery hops 0;
	; run starts at SDK/API table entry state1E (analysis/mobile_candidates.json)
	dec a
	jr z, .l749B
	dec a
	jr z, .l74B6
	dec a
	jr z, .l74BE
	dec a
	jr z, .l74D0
	dec [hl]
	ret
.l749B ; 75:749B
	ld a, [wMobileSDK_ReceivePacketBuffer + 4]
	cp a, $00
	jr z, .l74B2
	cp a, $FF
	jr z, .l74B2
	ld a, [wMobileSDK_SavedState]
	ld [wMobileSDK_State], a
	ld hl, $C69F
	res 0, [hl]
	ret
.l74B2 ; 75:74B2
	inc [hl]
	inc [hl]
	jr .l74BE
.l74B6 ; 75:74B6
	ld a, $97
	ld hl, $6028
	jp Mobile_PacketSendEmptyBody
.l74BE ; 75:74BE
	ld hl, $C70D
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMobileSDK_ReceivePacketBuffer + 6]
	cp a, $F0
	jr c, .skip
	set 7, [hl]
.skip ; 75:74CD
	jp Mobile_EndSession
.l74D0 ; 75:74D0
	ld a, [wMobileSDK_State]
	cp a, $1E
	jp nz, MobileSDK_ResetToIdle
	jp MobileSDK_FinishToIdle

MobileState_ReadConfigExport:: ; 75:74DB
	; [CONFIRMED] 54 insn(s); 54 executed (in up to 8/18 scenarios)
	dec a
	jr z, .l74E9
	dec a
	jr z, .l74EF
	dec a
	jr z, .l74FE
	dec a
	jr z, .l7501
	dec [hl]
	ret
.l74E9 ; 75:74E9
	ld hl, $6041
	jp Mobile_PacketSendReadConfig
.l74EF ; 75:74EF
	ld hl, $C6C8
	ld a, $7F
	ld [hli], a
	ld a, $C7
	ld [hli], a
	ld hl, $604D
	jp Mobile_PacketSendReadConfig
.l74FE ; 75:74FE
	jp Mobile_EndSession
.l7501 ; 75:7501
	ld hl, $C71F
	ld a, [hli]
	cp a, $4D
	jr nz, .l7548
	ld a, [hld]
	cp a, $41
	jr nz, .l7548
	ld b, $BE
	ld de, $0000
.loop ; 75:7513
	ld a, [hli]
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	dec b
	jr nz, .loop
	ld a, [hli]
	cp a, d
	jr nz, .l754C
	ld a, [hl]
	cp a, e
	jr nz, .l754C
	ld a, [wMobileSDK_ResultPointer]
	ld e, a
	ld a, [wMobileSDK_ResultPointer + 1]
	ld d, a
	ld hl, $7540
	push hl
	ld a, [wMobileSDK_State]
	cp a, $25
	jr z, MobileSDK_ExportDialSlots
	cp a, $26
	jr z, MobileSDK_ExportLoginId

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:753A (executed)
	cp a, $27
	jr z, MobileSDK_ExportMailAddress

	; [CONFIRMED] 3 insn(s); 3 executed (in up to 8/18 scenarios)
	ld a, $01
	ld [wMobileSDK_ConfigCached], a
	jp MobileSDK_FinishToIdle

.l7548 ; 75:7548
	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1;
	; entered by jrcc from 75:7507 (executed)
	ld a, $25
	jr .l754E
.l754C ; 75:754C
	ld a, $14
.l754E ; 75:754E
	call MobileSDK_EnterErrorState
	jp MobileSDK_FinishWithError

MobileSDK_ClearBuffer:: ; 75:7554
Function_75_7554::
	; [CONFIRMED] 73 insn(s); 73 executed (in up to 8/18 scenarios); entry proven: target of an
	; executed call/far call
	push de
	ld l, e
	ld h, d
	xor a, a
	ld [hl], a
	inc de
	call MobileSDK_CopyBytes
	pop de
	ret

MobileSDK_ExportLoginId:: ; 75:755F
	ld b, $20
	call MobileSDK_ClearBuffer
	ld a, $21
	ld hl, $C72B
	call MobileSDK_CopyStringLen
	xor a, a
	ld [de], a
	ret

MobileSDK_ExportMailAddress:: ; 75:756F
	ld b, $1E
	call MobileSDK_ClearBuffer
	ld a, $1F
	ld hl, $C74B
	jp MobileSDK_CopyStringLen

MobileSDK_ExportDialSlots:: ; 75:757C
	ld b, $65
	call MobileSDK_ClearBuffer
	ld hl, $C795
	call MobileSDK_BcdPhoneToAscii
	ld a, $11
	ld hl, $C79D
	call MobileSDK_CopyStringLen
	inc de
	ld hl, $C7AD
	call MobileSDK_BcdPhoneToAscii
	ld a, $11
	ld hl, $C7B5
	call MobileSDK_CopyStringLen
	inc de
	ld hl, $C7C5
	call MobileSDK_BcdPhoneToAscii
	ld a, $11
	ld hl, $C7CD
	jp MobileSDK_CopyStringLen

MobileSDK_BcdPhoneToAscii:: ; 75:75AD
	ld b, $08
.loop ; 75:75AF
	ld a, [hl]
	swap a
	and a, $0F
	cp a, $0F
	jr z, .l75DE
	or a, $30
	cp a, $3A
	call z, MobileSDK_DialCharHash
	cp a, $3B
	call z, MobileSDK_DialCharStar
	ld [de], a
	inc de
	ld a, [hli]
	and a, $0F
	cp a, $0F
	jr z, .l75DE
	or a, $30
	cp a, $3A
	call z, MobileSDK_DialCharHash
	cp a, $3B
	call z, MobileSDK_DialCharStar
	ld [de], a
	inc de
	dec b
	jr nz, .loop
.l75DE ; 75:75DE
	xor a, a
	ld [de], a
	inc de
	ret

MobileSDK_DialCharHash:: ; 75:75E2
	ld a, $23
	ret

MobileSDK_DialCharStar:: ; 75:75E5
	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by callcc from 75:75C1 (executed)
	ld a, $2A
	ret

MobileState_WriteConfig:: ; 75:75E8
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 4/18 scenarios)
	dec a
	jr z, .l75F6
	dec a
	jr z, .l75FB
	dec a
	jr z, .l762E
	dec a
	jr z, .l7631
	dec [hl]
	ret
.l75F6 ; 75:75F6
	ld b, $9A
	jp Mobile_PacketSendBuffered
.l75FB ; 75:75FB
	ld a, [wMobileSDK_Window + 2]
	or a, a
	jr nz, .l7604

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:75FF (executed)
	inc [hl]
	jr .l762E

.l7604 ; 75:7604
	; [CONFIRMED] 43 insn(s); 43 executed (in up to 17/18 scenarios)
	ld de, $C9E9
	ld c, a
	inc a
	ld [de], a
	inc de
	ld a, $80
	ld [de], a
	inc de
	ld hl, $C71F
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld b, c
	call MobileSDK_CopyBytes
	ld b, c
	inc b
	call Mobile_PacketBuildFooter
	ld a, [wMobileSDK_PacketBuffer + 5]
	add a, $0A
	ld e, a
	ld d, $00
	ld a, $9A
	ld hl, $C9E4
	jp Mobile_PacketSendExpect
.l762E ; 75:762E
	jp Mobile_EndSession
.l7631 ; 75:7631
	jp MobileSDK_FinishToIdle

MobileState_ReadConfig:: ; 75:7634
	dec a
	jr z, .l7642
	dec a
	jr z, .l7648
	dec a
	jr z, .l767D
	dec a
	jr z, .l7680
	dec [hl]
	ret
.l7642 ; 75:7642
	ld hl, $C9E4
	jp Mobile_PacketSendReadConfig
.l7648 ; 75:7648
	ld a, [wMobileSDK_Window + 2]
	or a, a
	jr z, .l7655
	cp a, $81
	jr nc, .l7655

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 75:7650 (executed)
	inc [hl]
	jr .l767D

.l7655 ; 75:7655
	; [CONFIRMED] 23 insn(s); 23 executed (in up to 17/18 scenarios)
	ld hl, $C9EB
	sub a, $80
	ld [hld], a
	ld a, $80
	ld [hl], a
	ld de, $C9EC
	ld b, $02
	call Mobile_PacketBuildFooter
	ld hl, $C71F
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $0080
	add hl, de
	ld e, h
	ld a, l
	ld hl, $C6C8
	ld [hli], a
	ld [hl], e
	ld hl, $C9E4
	jp Mobile_PacketSendReadConfig
.l767D ; 75:767D
	jp Mobile_EndSession
.l7680 ; 75:7680
	jp MobileSDK_FinishToIdle

MobileSDK_AuthBuildResponse:: ; 75:7683
	; [CONFIRMED] 507 insn(s) reached by static flow only; seeds: exec x507; min discovery hops 2;
	; entered by call from 75:709D (PROBABLE code) | 33 insn(s) executed; cut out of the PROBABLE
	; region 7683-7A17 by apply_coverage --split [executed in 1 scenarios]
	xor a, a
	ld [wMobileSDK_PacketBuffer + 225], a
	ld a, l
	ld [wMobileSDK_PacketBuffer + 192], a
	ld a, h
	ld [wMobileSDK_PacketBuffer + 193], a
	ld hl, $CAA6
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, b
	ld [hli], a
	ld hl, $CAA4
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $CA04
	ld b, $30
	ld c, b
	call MobileSDK_CopyBytes
	ld hl, $C81E
	ld a, [hli]
	ld h, [hl]
	ld l, a
.l76AD ; 75:76AD
	ld a, [hli]
	or a, a
	jr nz, .l76AD
	call MobileSDK_CopyString
	ld a, $37
	cp a, c
	inc a
	jr nc, .l76C1

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7683-7A17 by apply_coverage --split
	ld a, $02
	ld [wMobileSDK_PacketBuffer + 225], a
	ld a, $78

.l76C1 ; 75:76C1
	; [CONFIRMED] 72 insn(s) executed; cut out of the PROBABLE region 7683-7A17 by apply_coverage
	; --split [executed in 1 scenarios]
	sub a, c
	ld b, a
	ld a, $80
	ld [de], a
	inc de
	xor a, a
.l76C8 ; 75:76C8
	dec b
	jr z, .l76CF
	ld [de], a
	inc de
	jr .l76C8
.l76CF ; 75:76CF
	or a, a
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	ld a, c
	ld [de], a
	inc de
	ld a, b
	ld [de], a
	inc de
	ld l, e
	ld h, d
	ld b, $06
	xor a, a
.l76E7 ; 75:76E7
	ld [hli], a
	dec b
	jr nz, .l76E7
	ld de, $CA84
	ld hl, MobileSDK_Md5InitConstants
	ld b, $10
	call MobileSDK_CopyBytes
.l76F6 ; 75:76F6
	ld hl, $CAA9
	ld a, $50
	ld [hli], a
	ld a, $7B
	ld [hl], a
	ld hl, $CAAB
	ld a, $32
	ld [hli], a
	ld a, $7A
	ld [hl], a
	ld hl, $CA84
	ld de, $CAB5
	ld b, $10
	call MobileSDK_CopyBytes
.l7713 ; 75:7713
	ld hl, $CAAB
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld c, a
	push hl
	call MobileSDK_Md5Round
	ld hl, $CA94
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $CA9C
	call MobileSDK_Md5Add32
	pop hl
	ld a, [hli]
	ld d, [hl]
	inc hl
	ld e, a
	push hl
	ld a, [wMobileSDK_PacketBuffer + 225]
	bit 0, a
	jr z, .l773E

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7683-7A17 by apply_coverage --split
	ld hl, $0040
	add hl, de
	ld e, l
	ld d, h

.l773E ; 75:773E
	; [CONFIRMED] 60 insn(s) executed; cut out of the PROBABLE region 7683-7A17 by apply_coverage
	; --split [executed in 1 scenarios]
	ld hl, $CA04
	add hl, de
	ld e, l
	ld d, h
	ld hl, $CA9C
	call MobileSDK_Md5Add32
	ld hl, $CAA9
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $CA9C
	call MobileSDK_Md5Add32
	pop hl
	ld a, [hli]
	ld b, a
	ld a, l
	ld [wMobileSDK_PacketBuffer + 199], a
	ld a, h
	ld [wMobileSDK_PacketBuffer + 200], a
	ld hl, $CA9C
	call MobileSDK_Md5Rol32
	ld hl, $CA96
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $CA9C
	call MobileSDK_Md5Add32
	ld hl, $CA94
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $CA9C
	ld b, $04
	call MobileSDK_CopyBytes
	ld hl, $CAA9
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, h
	ld [wMobileSDK_PacketBuffer + 198], a
	ld a, l
	ld [wMobileSDK_PacketBuffer + 197], a
	cp a, $50
	jp nz, .l7713
	ld de, $CAB5
	ld hl, $CA84
	call MobileSDK_Md5Add32
	ld de, $CAB9
	call MobileSDK_Md5Add32
	ld de, $CABD
	call MobileSDK_Md5Add32
	ld de, $CAC1
	call MobileSDK_Md5Add32
	ld hl, $CAC5
	bit 1, [hl]
	jr z, .l77BE

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7683-7A17 by apply_coverage --split
	dec [hl]
	jp .l76F6

.l77BE ; 75:77BE
	; [CONFIRMED] 333 insn(s) executed; cut out of the PROBABLE region 7683-7A17 by apply_coverage
	; --split [executed in 1 scenarios]
	ld hl, $CA04
	ld de, $CA34
	ld bc, $0030
	call MobileSDK_Base64Decode
	ld hl, $CAA6
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, MobileStr_Authorization
	call MobileSDK_CopyString
	ld hl, $CA34
	ld bc, $0020
	call MobileSDK_Base64Encode
	ld a, l
	ld [wMobileSDK_PacketBuffer + 194], a
	ld a, h
	ld [wMobileSDK_PacketBuffer + 195], a
	ld b, $12
	ld hl, $CA34
	ld de, $CA04
.l77EF ; 75:77EF
	ld a, $40
	and a, [hl]
	rlca
	ld c, a
	ld a, [hli]
	bit 4, a
	jr z, .l77FB
	set 6, c
.l77FB ; 75:77FB
	bit 2, a
	jr z, .l7801
	set 5, c
.l7801 ; 75:7801
	bit 0, a
	jr z, .l7807
	set 4, c
.l7807 ; 75:7807
	ld a, [hli]
	bit 6, a
	jr z, .l780E
	set 3, c
.l780E ; 75:780E
	bit 4, a
	jr z, .l7814
	set 2, c
.l7814 ; 75:7814
	bit 2, a
	jr z, .l781A
	set 1, c
.l781A ; 75:781A
	bit 0, a
	jr z, .l7820
	set 0, c
.l7820 ; 75:7820
	ld a, c
	ld [de], a
	inc de
	dec b
	jr nz, .l77EF
	ld b, $12
	ld hl, $CA57
	ld de, $CA27
.l782E ; 75:782E
	ld a, $02
	and a, [hl]
	rrca
	ld c, a
	ld a, [hld]
	bit 3, a
	jr z, .l783A
	set 1, c
.l783A ; 75:783A
	bit 5, a
	jr z, .l7840
	set 2, c
.l7840 ; 75:7840
	bit 7, a
	jr z, .l7846
	set 3, c
.l7846 ; 75:7846
	ld a, [hld]
	bit 1, a
	jr z, .l784D
	set 4, c
.l784D ; 75:784D
	bit 3, a
	jr z, .l7853
	set 5, c
.l7853 ; 75:7853
	bit 5, a
	jr z, .l7859
	set 6, c
.l7859 ; 75:7859
	bit 7, a
	jr z, .l785F
	set 7, c
.l785F ; 75:785F
	ld a, c
	ld [de], a
	dec de
	dec b
	jr nz, .l782E
	ld b, $10
	ld de, $CA34
	ld hl, $CA84
	call MobileSDK_CopyBytes
	ld bc, $0010
	ld hl, $C81E
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call MobileSDK_CopyString
	ld a, $24
	sub a, c
	ld b, a
	ld l, e
	ld h, d
	ld a, $FF
.l7884 ; 75:7884
	ld [hli], a
	dec b
	jr nz, .l7884
	xor a, a
	ld [hl], a
	ld b, $24
	ld hl, $CA04
	ld de, $CA34
.l7892 ; 75:7892
	ld a, [de]
	inc de
	xor a, [hl]
	ld c, $00
	bit 0, a
	jr z, .l789D
	set 3, c
.l789D ; 75:789D
	bit 3, a
	jr z, .l78A3
	set 6, c
.l78A3 ; 75:78A3
	bit 6, a
	jr z, .l78A9
	set 0, c
.l78A9 ; 75:78A9
	and a, $B6
	or a, c
	ld [hli], a
	dec b
	jr nz, .l7892
	ld hl, $CAA6
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $CA04
	ld bc, $0024
	call MobileSDK_Base64Encode
	ld a, $22
	ld [hli], a
	ld a, $0D
	ld [hli], a
	ld a, $0A
	ld [hli], a
	xor a, a
	ld [hl], a
	ret

MobileSDK_Md5Round:: ; 75:78CB
	call MobileSDK_Md5LoadStatePtrs
	ld a, c
	and a, $F0
	swap a
	or a, a
	jr z, MobileSDK_Md5FuncF
	dec a
	jr z, MobileSDK_Md5FuncG
	dec a
	jp z, MobileSDK_Md5FuncH
	jp MobileSDK_Md5FuncI

MobileSDK_Md5LoadStatePtrs:: ; 75:78E0
	and a, $0F
	ld e, a
	ld d, $00
	ld hl, MobileSDK_Md5StatePtrTable
	add hl, de
	ld de, $CA94
	ld b, $08
	jp MobileSDK_CopyBytes

MobileSDK_Md5FuncF:: ; 75:78F1
	ld hl, $CA96
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $CA9C
	ld b, $04
	call MobileSDK_CopyBytes
	ld hl, $CA98
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $CA9C
	call MobileSDK_Md5And32
	ld hl, $CA96
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $CAA0
	ld b, $04
	call MobileSDK_CopyBytes
	ld hl, $CAA0
	call MobileSDK_Md5Not32
	ld hl, $CA9A
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $CAA0
	call MobileSDK_Md5And32
	ld hl, $CA9C
	ld de, $CAA0
	call MobileSDK_Md5Or32
	ret

MobileSDK_Md5FuncG:: ; 75:7935
	ld hl, $CA96
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $CA9C
	ld b, $04
	call MobileSDK_CopyBytes
	ld hl, $CA9A
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $CA9C
	call MobileSDK_Md5And32
	ld hl, $CA9A
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $CAA0
	ld b, $04
	call MobileSDK_CopyBytes
	ld hl, $CAA0
	call MobileSDK_Md5Not32
	ld hl, $CA98
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $CAA0
	call MobileSDK_Md5And32
	ld hl, $CA9C
	ld de, $CAA0
	call MobileSDK_Md5Or32
	ret

MobileSDK_Md5FuncH:: ; 75:7979
	ld hl, $CA96
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $CA9C
	ld b, $04
	call MobileSDK_CopyBytes
	ld hl, $CA98
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $CA9C
	call MobileSDK_Md5Xor32
	ld hl, $CA9A
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $CA9C
	call MobileSDK_Md5Xor32
	ret

MobileSDK_Md5FuncI:: ; 75:79A0
	ld hl, $CA9A
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $CA9C
	ld b, $04
	call MobileSDK_CopyBytes
	ld hl, $CA9C
	call MobileSDK_Md5Not32
	ld hl, $CA96
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $CA9C
	call MobileSDK_Md5Or32
	ld hl, $CA98
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $CA9C
	call MobileSDK_Md5Xor32
	ret

MobileSDK_Md5And32:: ; 75:79CD
	ld b, $04
.loop ; 75:79CF
	ld a, [de]
	inc de
	and a, [hl]
	ld [hli], a
	dec b
	jr nz, .loop
	ret

MobileSDK_Md5Or32:: ; 75:79D7
	ld b, $04
.loop ; 75:79D9
	ld a, [de]
	inc de
	or a, [hl]
	ld [hli], a
	dec b
	jr nz, .loop
	ret

MobileSDK_Md5Not32:: ; 75:79E1
	ld b, $04
.loop ; 75:79E3
	ld a, [hl]
	cpl
	ld [hli], a
	dec b
	jr nz, .loop
	ret

MobileSDK_Md5Xor32:: ; 75:79EA
	ld b, $04
.loop ; 75:79EC
	ld a, [de]
	inc de
	xor a, [hl]
	ld [hli], a
	dec b
	jr nz, .loop
	ret

MobileSDK_Md5Add32:: ; 75:79F4
	ld a, [de]
	inc de
	add a, [hl]
	ld [hli], a
	ld b, $03
.loop ; 75:79FA
	ld a, [de]
	inc de
	adc a, [hl]
	ld [hli], a
	dec b
	jr nz, .loop
	ret

MobileSDK_Md5Rol32:: ; 75:7A02
	or a, a
	push hl
	ld a, [hli]
	rla
	ld a, [hl]
	rla
	ld [hli], a
	ld a, [hl]
	rla
	ld [hli], a
	ld a, [hl]
	rla
	ld [hl], a
	pop hl
	ld a, [hl]
	rla
	ld [hl], a
	dec b
	jr nz, MobileSDK_Md5Rol32
	ret

; ---- text $7A17-$7A32 (27 bytes) [PROBABLE] NUL-terminated ASCII 'Authorization: GB00 name="' (HTTP header); passed in HL to 75:4007 at 75:77D0 (ld hl,$7A17)

MobileStr_Authorization:: ; 75:7A17
String_75_7A17::
	db $41, $75, $74, $68, $6F, $72, $69, $7A, $61, $74, $69, $6F, $6E, $3A, $20, $47, $42, $30, $30, $20, $6E, $61, $6D, $65, $3D, $22, $00 ; "Authorization: GB00 name=\""

; ---- data $7A32-$7B32 (256 bytes) [PROBABLE] 256 bytes MD5 per-step parameter table: 4-byte records whose first field cycles the RFC 1321 shift amounts 7,12,17,22 / 5,9,14,20 / 4,11,16,23 / 6,10,15,21 (verified), a round/rotation nibble pair ($06/$04/$02/$00 | $10.. | $20.. | $30..) and a message-word offset; exact record framing (starts at 7A35 after 3 zero bytes) not verified; sits right before the MD5 constants

MobileSDK_Md5StepTable:: ; 75:7A32
Table_75_7A32::
	db $00, $00, $00, $07, $06, $04, $00, $0C, $04, $08, $00, $11, $02, $0C, $00, $16
	db $00, $10, $00, $07, $06, $14, $00, $0C, $04, $18, $00, $11, $02, $1C, $00, $16
	db $00, $20, $00, $07, $06, $24, $00, $0C, $04, $28, $00, $11, $02, $2C, $00, $16
	db $00, $30, $00, $07, $06, $34, $00, $0C, $04, $38, $00, $11, $02, $3C, $00, $16
	db $10, $04, $00, $05, $16, $18, $00, $09, $14, $2C, $00, $0E, $12, $00, $00, $14
	db $10, $14, $00, $05, $16, $28, $00, $09, $14, $3C, $00, $0E, $12, $10, $00, $14
	db $10, $24, $00, $05, $16, $38, $00, $09, $14, $0C, $00, $0E, $12, $20, $00, $14
	db $10, $34, $00, $05, $16, $08, $00, $09, $14, $1C, $00, $0E, $12, $30, $00, $14
	db $20, $14, $00, $04, $26, $20, $00, $0B, $24, $2C, $00, $10, $22, $38, $00, $17
	db $20, $04, $00, $04, $26, $10, $00, $0B, $24, $1C, $00, $10, $22, $28, $00, $17
	db $20, $34, $00, $04, $26, $00, $00, $0B, $24, $0C, $00, $10, $22, $18, $00, $17
	db $20, $24, $00, $04, $26, $30, $00, $0B, $24, $3C, $00, $10, $22, $08, $00, $17
	db $30, $00, $00, $06, $36, $1C, $00, $0A, $34, $38, $00, $0F, $32, $14, $00, $15
	db $30, $30, $00, $06, $36, $0C, $00, $0A, $34, $28, $00, $0F, $32, $04, $00, $15
	db $30, $20, $00, $06, $36, $3C, $00, $0A, $34, $18, $00, $0F, $32, $34, $00, $15
	db $30, $10, $00, $06, $36, $2C, $00, $0A, $34, $08, $00, $0F, $32, $24, $00, $15

; ---- data $7B32-$7B40 (14 bytes) [PROBABLE] 14 bytes = 7 words (CA84 CA88 CA8C CA90 CA84 CA88 CA8C): rotating pointer list to the MD5 state words in WRAM; 8-byte windows (offset = index & $0F) are copied to $CA94 by 75:78E5 (ld hl,$7B32 ; add hl,de ; ld de,$CA94 ; ld b,8 ; jp $4000)

MobileSDK_Md5StatePtrTable:: ; 75:7B32
Table_75_7B32::
	db $84, $CA, $88, $CA, $8C, $CA, $90, $CA, $84, $CA, $88, $CA, $8C, $CA

; ---- data $7B40-$7B50 (16 bytes) [CONFIRMED] MD5 initial state A,B,C,D = 67452301 EFCDAB89 98BADCFE 10325476 stored little-endian (byte-exact RFC 1321 constants); copied (16 bytes) to WRAM $CA84 by 75:76EE (ld de,$CA84 ; ld hl,$7B40 ; ld b,$10 ; call $4000)

MobileSDK_Md5InitConstants:: ; 75:7B40
Data_75_7B40::
	db $01, $23, $45, $67, $89, $AB, $CD, $EF, $FE, $DC, $BA, $98, $76, $54, $32, $10

; ---- data $7B50-$7C50 (256 bytes) [CONFIRMED] MD5 constant table T[1..64] = floor(2^32 x abs(sin(i))) as 64 little-endian dwords (byte-exact match computed with Python math.sin; first entries D76AA478 E8C7B756 242070DB C1BDCEEE)

MobileSDK_Md5KTable:: ; 75:7B50
Table_75_7B50::
	db $78, $A4, $6A, $D7, $56, $B7, $C7, $E8, $DB, $70, $20, $24, $EE, $CE, $BD, $C1
	db $AF, $0F, $7C, $F5, $2A, $C6, $87, $47, $13, $46, $30, $A8, $01, $95, $46, $FD
	db $D8, $98, $80, $69, $AF, $F7, $44, $8B, $B1, $5B, $FF, $FF, $BE, $D7, $5C, $89
	db $22, $11, $90, $6B, $93, $71, $98, $FD, $8E, $43, $79, $A6, $21, $08, $B4, $49
	db $62, $25, $1E, $F6, $40, $B3, $40, $C0, $51, $5A, $5E, $26, $AA, $C7, $B6, $E9
	db $5D, $10, $2F, $D6, $53, $14, $44, $02, $81, $E6, $A1, $D8, $C8, $FB, $D3, $E7
	db $E6, $CD, $E1, $21, $D6, $07, $37, $C3, $87, $0D, $D5, $F4, $ED, $14, $5A, $45
	db $05, $E9, $E3, $A9, $F8, $A3, $EF, $FC, $D9, $02, $6F, $67, $8A, $4C, $2A, $8D
	db $42, $39, $FA, $FF, $81, $F6, $71, $87, $22, $61, $9D, $6D, $0C, $38, $E5, $FD
	db $44, $EA, $BE, $A4, $A9, $CF, $DE, $4B, $60, $4B, $BB, $F6, $70, $BC, $BF, $BE
	db $C6, $7E, $9B, $28, $FA, $27, $A1, $EA, $85, $30, $EF, $D4, $05, $1D, $88, $04
	db $39, $D0, $D4, $D9, $E5, $99, $DB, $E6, $F8, $7C, $A2, $1F, $65, $56, $AC, $C4
	db $44, $22, $29, $F4, $97, $FF, $2A, $43, $A7, $23, $94, $AB, $39, $A0, $93, $FC
	db $C3, $59, $5B, $65, $92, $CC, $0C, $8F, $7D, $F4, $EF, $FF, $D1, $5D, $84, $85
	db $4F, $7E, $A8, $6F, $E0, $E6, $2C, $FE, $14, $43, $01, $A3, $A1, $11, $08, $4E
	db $82, $7E, $53, $F7, $35, $F2, $3A, $BD, $BB, $D2, $D7, $2A, $91, $D3, $86, $EB

MobileSDK_Base64Encode:: ; 75:7C50
	; [CONFIRMED] 347 insn(s) reached by static flow only; seeds: exec x289, mobile x58; min
	; discovery hops 0; entered by call from 75:77DC (PROBABLE code) | 183 insn(s) executed; cut out
	; of the PROBABLE region 7C50-7E89 by apply_coverage --split [executed in 1 scenarios]
	ld a, c
	ld [wMobileSDK_PacketBuffer + 201], a
	ld a, b
	ld [wMobileSDK_PacketBuffer + 202], a
	ld c, e
	ld b, d
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	xor a, a
	ld [wMobileSDK_PacketBuffer + 207], a
.l7C62 ; 75:7C62
	ld b, $03
	push hl
	ld hl, $CAAF
.l7C68 ; 75:7C68
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .l7C68
	ld a, [wMobileSDK_PacketBuffer + 201]
	ld c, a
	ld a, [wMobileSDK_PacketBuffer + 202]
	ld b, a
	xor a, a
	or a, b
	jr nz, .l7C91
	ld a, $02
	cp a, c
	jr c, .l7C91
	push hl
	dec hl
	ld a, c
	ld [wMobileSDK_PacketBuffer + 207], a
.l7C85 ; 75:7C85
	xor a, a
	ld [hld], a
	inc c
	ld a, $03
	cp a, c
	jr nz, .l7C85
	pop hl
	ld bc, $0003
.l7C91 ; 75:7C91
	dec bc
	dec bc
	dec bc
	ld a, c
	ld [wMobileSDK_PacketBuffer + 201], a
	ld a, b
	ld [wMobileSDK_PacketBuffer + 202], a
	push de
	dec hl
	ld c, [hl]
	dec hl
	ld b, [hl]
	dec hl
	ld a, [hl]
	ld d, a
	srl a
	srl a
	ld [hli], a
	ld a, $03
	and a, d
	ld d, a
	ld a, $F0
	and a, b
	or a, d
	swap a
	ld [hli], a
	ld a, $0F
	and a, b
	ld d, a
	ld a, c
	and a, $C0
	or a, d
	rlca
	rlca
	ld [hli], a
	ld a, $3F
	and a, c
	ld [hld], a
	dec hl
	dec hl
	pop de
	ld b, h
	ld c, l
	pop hl
	ld a, [bc]
	inc bc
	call MobileSDK_Base64EncodeChar
	ld [hli], a
	ld a, [bc]
	inc bc
	call MobileSDK_Base64EncodeChar
	ld [hli], a
	ld a, [bc]
	inc bc
	call MobileSDK_Base64EncodeChar
	ld [hli], a
	ld a, [bc]
	inc bc
	call MobileSDK_Base64EncodeChar
	ld [hli], a
	ld a, [wMobileSDK_PacketBuffer + 201]
	cp a, $00
	jp nz, .l7C62
	ld a, [wMobileSDK_PacketBuffer + 202]
	cp a, $00
	jp nz, .l7C62
	ld a, [wMobileSDK_PacketBuffer + 207]
	cp a, $00
	jr z, .l7D05
	push hl
	dec hl
	ld b, a
.l7CFB ; 75:7CFB
	ld a, $3D
	ld [hld], a
	inc b
	ld a, $03
	cp a, b
	jr nz, .l7CFB
	pop hl
.l7D05 ; 75:7D05
	ld a, $00
	ld [hl], a
	ret

MobileSDK_Base64EncodeChar:: ; 75:7D09
	cp a, $1A
	jr c, .l7D1C
	cp a, $34
	jr c, .l7D1F
	cp a, $3E
	jr c, .l7D22
	cp a, $3E
	jr z, .l7D25
	ld a, $2F
	ret
.l7D1C ; 75:7D1C
	add a, $41
	ret
.l7D1F ; 75:7D1F
	add a, $47
	ret
.l7D22 ; 75:7D22
	sub a, $04
	ret
.l7D25 ; 75:7D25
	ld a, $2B
	ret

MobileSDK_Base64Decode:: ; 75:7D28
	ld a, c
	ld [wMobileSDK_PacketBuffer + 201], a
	ld a, b
	ld [wMobileSDK_PacketBuffer + 202], a
	ld c, e
	ld b, d
	ld e, l
	ld d, h
	ld l, c
	ld h, b
.l7D36 ; 75:7D36
	ld a, [wMobileSDK_PacketBuffer + 202]
	or a, a
	jr nz, .l7D44
	ld a, [wMobileSDK_PacketBuffer + 201]
	cp a, $04
	jp c, Label_75_7DE8
.l7D44 ; 75:7D44
	ld b, $04
	push hl
	ld hl, $CAAF
.l7D4A ; 75:7D4A
	ld a, [de]
	inc de
	call Function_75_7DBC
	ld [hli], a
	dec b
	jr nz, .l7D4A
	ld a, [wMobileSDK_PacketBuffer + 201]
	ld c, a
	ld a, [wMobileSDK_PacketBuffer + 202]
	ld b, a
	dec bc
	dec bc
	dec bc
	dec bc
	ld a, b
	or a, c
	jr z, .l7D70
.l7D63 ; 75:7D63
	ld a, [de]
	cp a, $0D
	jr z, .l7D6C
	cp a, $0A
	jr nz, .l7D70

.l7D6C ; 75:7D6C
	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7C50-7E89 by apply_coverage --split
	inc de
	dec bc
	jr .l7D63

.l7D70 ; 75:7D70
	; [CONFIRMED] 51 insn(s) executed; cut out of the PROBABLE region 7C50-7E89 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, c
	ld [wMobileSDK_PacketBuffer + 201], a
	ld a, b
	ld [wMobileSDK_PacketBuffer + 202], a
	push de
	dec hl
	ld d, [hl]
	dec hl
	ld c, [hl]
	dec hl
	ld b, [hl]
	dec hl
	ld a, [hl]
	sla b
	sla b
	sla b
	rla
	sla b
	rla
	ld [hli], a
	ld [hl], b
	inc hl
	rrc c
	rrc c
	ld [hl], c
	dec hl
	ld a, $0F
	and a, c
	or a, [hl]
	ld [hli], a
	ld a, [hli]
	and a, $C0
	or a, [hl]
	dec hl
	ld [hld], a
	dec hl
	pop de
	ld b, h
	ld c, l
	pop hl
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
	ld a, [wMobileSDK_PacketBuffer + 201]
	or a, a
	jr nz, .l7D36

	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7C50-7E89 by apply_coverage --split
	ld a, [wMobileSDK_PacketBuffer + 202]
	or a, a
	jp nz, .l7D36
	xor a, a
	ld [hl], a
	ret

Function_75_7DBC:: ; 75:7DBC
	; [CONFIRMED] 28 insn(s) executed; cut out of the PROBABLE region 7C50-7E89 by apply_coverage
	; --split [executed in 1 scenarios]
	cp a, $2B
	jr c, .l7DE6
	jr z, Label_75_7DF3
	cp a, $2F
	jr c, .l7DE6
	jr z, Label_75_7DF6
	cp a, $30
	jr c, .l7DE6
	cp a, $3A
	jr c, Label_75_7DF9
	cp a, $3D
	jr c, .l7DE6
	jr z, Label_75_7DFC
	cp a, $41
	jr c, .l7DE6
	cp a, $5B
	jr c, Label_75_7DFE
	cp a, $61
	jr c, .l7DE6
	cp a, $7B
	jr c, Label_75_7E01
.l7DE6 ; 75:7DE6
	pop hl
	pop hl

Label_75_7DE8:: ; 75:7DE8
	ld hl, $C69F
	set 1, [hl]
	ld a, $20
	ld [wMobileSDK_ErrorCode], a
	ret

Label_75_7DF3:: ; 75:7DF3
	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7C50-7E89 by apply_coverage --split
	ld a, $3E
	ret

Label_75_7DF6:: ; 75:7DF6
	ld a, $3F
	ret

Label_75_7DF9:: ; 75:7DF9
	add a, $04
	ret

Label_75_7DFC:: ; 75:7DFC
	xor a, a
	ret

Label_75_7DFE:: ; 75:7DFE
	sub a, $41
	ret

Label_75_7E01:: ; 75:7E01
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 7C50-7E89 by apply_coverage
	; --split [executed in 1 scenarios]
	sub a, $47
	ret

MobileState_Cancel:: ; 75:7E04
	dec a
	jr z, .l7E11
	dec a
	jr z, .l7E47
	dec a
	jr z, .l7E6A
	dec a
	jr z, .l7E72

	; [PROBABLE] 16 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7C50-7E89 by apply_coverage --split
	ret
.l7E11 ; 75:7E11
	ld a, [wMobileSDK_PhaseCode]
	cp a, $08
	jr nz, .l7E1A
.l7E18 ; 75:7E18
	dec [hl]
	ret
.l7E1A ; 75:7E1A
	xor a, a
	ld [wMobileSDK_ConnectionFlag], a
	ld a, $02
	ld [wMobileSDK_State], a
	ld hl, $C69F
	ld a, [hl]
	and a, $10
	set 5, a
	ld [hl], a
	jp MobileSDK_ResumeIdlePolling

.l7E2F ; 75:7E2F
	; [CONFIRMED] 34 insn(s) executed; cut out of the PROBABLE region 7C50-7E89 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, [wMobileSDK_ConnectionFlag]
	or a, a
	ld a, [wMobileSDK_ReceivePacketBuffer]
	jr z, .l7E43
	cp a, $9F
	jr z, .l7E47
	cp a, $A4
	jr z, .l7E47
.l7E40 ; 75:7E40
	jp Mobile_CloseTcpConnection
.l7E43 ; 75:7E43
	cp a, $A3
	jr z, .l7E40
.l7E47 ; 75:7E47
	xor a, a
	ld [wMobileSDK_ConnectionFlag], a
	ld [wMobileSDK_SendCommandID], a
	ld a, $02
	ld [wMobileSDK_State], a
	ld a, $03
	ld [wMobileSDK_PhaseCode], a
	ld hl, $C69F
	ld a, [hl]
	and a, $10
	set 5, a
	ld [hl], a
	ld hl, $C6C1
	bit 0, [hl]
	call z, MobileSDK_PollAdapterStatus
	ret
.l7E6A ; 75:7E6A
	ld a, [wMobileSDK_PhaseCode]
	cp a, $08
	jr z, .l7E18
	ret
.l7E72 ; 75:7E72
	ld a, $01
	ld [wMobileSDK_Substep], a
	jp .l7E2F

MobileSDK_ResumeIdlePolling:: ; 75:7E7A
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7C50-7E89 by apply_coverage --split
	ld a, $FF
	ld [wMobileSDK_SendCommandID], a
	ld hl, $C6C1
	res 5, [hl]
	res 0, [hl]
	jp MobileSDK_PollAdapterStatus

Function_75_7E89:: ; 75:7E89
	; [PROBABLE] 27 insn(s): complete routine (ld hl,$C6C1 ; ld a,[hl] ; push af ; res 3,[hl] ; res
	; 0,[hl] ... bit 0,a ; ret z ; ld hl,$C6C1 ; set 0,[hl] ; ret) falling into the code at 7EB4;
	; well-formed instruction chain (clean decode, all direct targets land on instruction starts,
	; lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS
	ld hl, $C6C1
	ld a, [hl]
	push af
	res 3, [hl]
	res 0, [hl]
	ld hl, $C6BA
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	ld a, [hld]
	dec hl
	xor a, $80
	ld [wMobileSDK_SendCommandID], a
	ld b, $05
	call Mobile_PacketSendBytes
	pop af
	bit 0, a
	ret z
	ld hl, $C6C1
	set 0, [hl]
	ret

MobileState_Timeout:: ; 75:7EB4
	; [PROBABLE] 38 insn(s) reached by static flow only; seeds: mobile x38; min discovery hops 0;
	; run starts at SDK/API table entry state29 (analysis/mobile_candidates.json)
	dec a
	jr z, .l7EBC
	dec a
	jr z, .l7EC5
	dec [hl]
	ret
.l7EBC ; 75:7EBC
	ld a, [wMobileSDK_PhaseCode]
	cp a, $08
	jr nz, MobileSDK_ResumeIdlePolling
	dec [hl]
	ret
.l7EC5 ; 75:7EC5
	ld a, $26
	call MobileSDK_EnterErrorState
	ld a, $2A
	ld [wMobileSDK_State], a
	ld hl, $C6C0
	ld a, [hld]
	ld h, [hl]
	ld l, a
	ld e, l
	ld d, h
	add hl, de
	add hl, de
	ld e, l
	ld d, h
	ld hl, $C6B5
	ld e, a
	ld [hli], a
	ld a, d
	ld [hl], a
	xor a, a
	ld [wMobileSDK_SerialPhase], a
	ld hl, $C9E4
	ld a, $02
	ld [hli], a
	dec a
	ld [hl], a
	ret

MobileState_Abort:: ; 75:7EEF
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)
	dec a
	jr z, .l7EF7
	dec a
	jr z, .l7F11
	dec [hl]
	ret

.l7EF7 ; 75:7EF7
	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1;
	; entered by jrcc from 75:7EF0 (executed)
	ld a, [wMobileSDK_PhaseCode]
	cp a, $08
	jr nz, .l7F00
	dec [hl]
	ret
.l7F00 ; 75:7F00
	xor a, a
	ld [wMobileSDK_ReceivePacketBuffer], a
	ld [wMobileSDK_ReceivePacketBufferAlt], a
	ld a, [wMobileSDK_SendCommandID]
	cp a, $91
	jr z, .l7F11
	jp MobileSDK_ResumeIdlePolling

.l7F11 ; 75:7F11
	; [CONFIRMED] 34 insn(s); 34 executed (in up to 1/18 scenarios)
	xor a, a
	ld [wMobileSDK_ConnectionFlag], a
	ld hl, $C69F
	set 0, [hl]
	ld hl, $C6C1
	xor a, a
	ld [hl], a
	xor a, a
	ld [wMobileSDK_RxStage], a
	xor a, a
	ld [wMobileSDK_PacketBuffer], a
	ld hl, $C6C0
	ld a, [hld]
	ld h, [hl]
	ld l, a
	ld e, l
	ld d, h
	add hl, de
	add hl, de
	ld e, l
	ld d, h
	ld hl, $C6B5
	ld e, a
	ld [hli], a
	ld a, d
	ld [hl], a
	xor a, a
	ld [wMobileSDK_SerialPhase], a
	ld hl, $C9E4
	xor a, a
	ld [hli], a
	inc a
	ld [hl], a
	ret
