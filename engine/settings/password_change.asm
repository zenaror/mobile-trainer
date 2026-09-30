; engine/settings/password_change.asm
; bank 67, $58CD-$5F66 (1689 bytes); pinned by layout.link
; password change flow, its CGI request body, network strings

SECTION "engine/settings/password_change", ROMX

; ---- code $58CD-$5931 (100 bytes) [CONFIRMED] 30 insn(s); 30 executed (in up to 4/18 scenarios); entry proven: target of an executed call/far call

PasswordChange_Run:: ; 67:58CD
Function_67_58CD::
	farcall Function_68_4282

Label_67_58D3:: ; 67:58D3
	ld a, $0F
	farcall Notice_ShowPage
	or a, a
	ret z

Label_67_58DD:: ; 67:58DD
	ld a, $10
	farcall Notice_ShowPage
	or a, a
	jr z, Label_67_58D3

Label_67_58E8:: ; 67:58E8
	ld hl, $DED4
	farcall Wram3_ClearByte
	ld a, $02
	farcall Account_PasswordEntryScreen
	or a, a
	jr z, Label_67_58DD
	ld hl, $DED4
	ld de, $DEB9
	farcall Wram3_CopyString

Label_67_5908:: ; 67:5908
	ld hl, $DED4
	farcall Wram3_ClearByte
	ld a, $03
	farcall Account_PasswordEntryScreen
	or a, a
	jr z, Label_67_58E8
	ld hl, $DED4
	ld de, $DECB
	farcall Wram3_CopyString
	farcall Password_CompareEntries
	or a, a
	jr nz, Label_67_593E

; ---- code $5931-$593E (13 bytes) [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 67:592F (executed)
	ld a, $F0
	ld hl, $0010
	farcall CommErr_ShowScreen
	jr Label_67_58E8

; ---- code $593E-$5973 (53 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 3/18 scenarios)

Label_67_593E:: ; 67:593E
	ld hl, $DED4
	ld de, $DEC2
	farcall Wram3_CopyString
	ld hl, $DED4
	farcall Wram3_ClearByte
	ld a, $01
	farcall Account_PasswordEntryScreen
	or a, a
	jr z, Label_67_5908
	ld hl, $DED4
	ld de, $DECB
	farcall Wram3_CopyString
	farcall Password_CompareNewAndConfirm
	or a, a
	jr z, Label_67_5980

; ---- code $5973-$5980 (13 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 67:5971 (executed) [executed in 3 scenarios]
	ld a, $F0
	ld hl, $0010
	farcall CommErr_ShowScreen
	jr Label_67_5908

; ---- code $5980-$5996 (22 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)

Label_67_5980:: ; 67:5980
	ld a, $01
	farcall Account_ActionConfirmPage
	or a, a
	jp z, Label_67_5908
	cp a, $02
	jr z, Label_67_59E7
	call PasswordChange_Communicate
	or a, a
	jr z, Label_67_59CB

; ---- code $5996-$59CB (53 bytes) [PROBABLE] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 0; fall-through of the jrcc at 67:5994 (executed)
	cp a, $02
	jr z, Label_67_59F0
	ld a, $01
	ld b, $00
	farcall Account_ResultPage
	ld a, $01
	farcall PwSaveConfirm_Run
	cp a, $01
	jr z, Label_67_59BF
	ld b, $00
	ld a, $01
	ld hl, $A880
	farcall WriteByteFar
	jr Label_67_59C2

Label_67_59BF:: ; 67:59BF
	call PasswordChange_SaveNewPassword

Label_67_59C2:: ; 67:59C2
	ld a, $12
	farcall Notice_ShowPage
	ret

; ---- code $59CB-$59E7 (28 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)

Label_67_59CB:: ; 67:59CB
	farcall OnlineTimer_HasElapsed
	or a, a
	jr z, Label_67_59E7
	ld a, $01
	ld b, $01
	farcall Account_ResultPage
	ld a, $11
	farcall Notice_ShowPage
	ret

; ---- code $59E7-$5A3E (87 bytes) [PROBABLE] 34 insn(s) reached by static flow only; seeds: exec x34; min discovery hops 1; entered by jrcc from 67:598E (executed)

Label_67_59E7:: ; 67:59E7
	ld a, $11
	farcall Notice_ShowPage
	ret

Label_67_59F0:: ; 67:59F0
	farcall OnlineTimer_HasElapsed
	or a, a
	jr z, Label_67_59E7
	farcall OnlineTimer_HasElapsed
	or a, a
	jr z, Label_67_59E7
	ld a, $01
	ld b, $02
	farcall Account_ResultPage
	jr Label_67_59E7

PasswordChange_SaveNewPassword:: ; 67:5A0E
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $DEC2
	ld de, $C28F
	call CopyString
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld hl, $C28F
	call StringLength
	ld a, c
	ld de, $C28F
	farcall SavedPassword_Store
	ret

; ---- code $5A3E-$5A9E (96 bytes) [CONFIRMED] 42 insn(s); 42 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

PasswordChange_Communicate:: ; 67:5A3E
Function_67_5A3E::
	call PasswordChange_Communicate_Setup
	call PasswordChange_Communicate_Poll
	farcall Palette_FadeOutToWhite
	ld a, [wRam_C27C]
	ret

PasswordChange_Communicate_Setup:: ; 67:5A4E
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Function_00_09B6
	xor a, a
	ld [wRam_C27C], a
	ld [wRam_C27D], a
	ld a, $01
	farcall CommPanel_SetVariant
	xor a, a
	farcall CommPanel_Init
	ret

PasswordChange_Communicate_Poll:: ; 67:5A75
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

Label_67_5A8E:: ; 67:5A8E
	ld a, [wRam_C27D]
	add a, a
	add a, $9E
	ld l, a
	ld a, $5A
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- ptrtable $5A9E-$5AAA (12 bytes) [CONFIRMED] 6-word code-pointer table for the [$C27D] state dispatcher (67:5A8E-5A9D, jp hl): entries 0-4 executed; entry 5 ($5CC2) is used when [$C27D]=5 (67:5CB2-5CB4 sets it and jumps to 5A8E) and is an instruction start (xor a; call $06D1...). The 2 bytes that were UNCLASSIFIED at 5AA8 are this 6th entry

PasswordChange_StateTable:: ; 67:5A9E
Table_67_5A9E::
	dw PasswordChange_State_Init
	dw PasswordChange_State_ReadLoginId
	dw PasswordChange_State_Connect
	dw PasswordChange_State_SendRequest
	dw PasswordChange_State_WaitResponse
	dw PasswordChange_State_Finish

; ---- code $5AAA-$5BFD (339 bytes) [CONFIRMED] 140 insn(s); 140 executed (in up to 1/18 scenarios)

PasswordChange_State_Init:: ; 67:5AAA
	xor a, a
	ld b, $01
	farcall CommPanel_Step
	cp a, $02
	jp z, PasswordChange_Abort
	ld de, $C271
	ld hl, $0067
	ld a, $02
	call MobileAPI
	ld a, $01
	ld [wRam_C27D], a
	jr Label_67_5A8E

PasswordChange_State_ReadLoginId:: ; 67:5ACA
	xor a, a
	farcall CommPanel_Step
	cp a, $02
	jp z, PasswordChange_Abort
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Label_67_5D8D
	bit 0, a
	jp nz, Label_67_5A8E
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld de, $A200
	ld a, $0E
	call MobileAPI
	ld a, $02
	ld [wRam_C27D], a
	jp Label_67_5A8E

PasswordChange_State_Connect:: ; 67:5B0E
	xor a, a
	farcall CommPanel_Step
	cp a, $02
	jp z, PasswordChange_Abort
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Label_67_5D8D
	bit 0, a
	jp nz, Label_67_5A8E
	ld de, $DEEE
	farcall Function_00_1586
	ld de, $A100
	call Net_CopyDefaultDnsPair
	ld hl, $DEEE
	ld de, $A108
	call CopyString
	ld hl, $5E77
	call CopyString
	ld hl, $5E77
	call CopyString
	ld hl, $A100
	ld a, $3E
	call MobileAPI
	ld a, $03
	ld [wRam_C27D], a
	jp Label_67_5A8E

PasswordChange_State_SendRequest:: ; 67:5B5B
	xor a, a
	farcall CommPanel_Step
	cp a, $02
	jp z, PasswordChange_Abort
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Label_67_5D8D
	bit 0, a
	jp nz, Label_67_5A8E
	xor a, a
	ld hl, $B000
	ld bc, $1000
	call FillBytes
	ld hl, Net_PwdChgCgiUrl
	ld de, $A463
	call CopyString
	call PasswordChange_BuildRequestBody
	ld hl, $A100
	ld a, $63
	ld [hli], a
	ld a, $A3
	ld [hli], a
	push hl
	ld hl, $A363
	call StringLength
	pop hl
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, $63
	ld [hli], a
	ld a, $A2
	ld [hli], a
	ld a, $63
	ld [hli], a
	ld a, $A4
	ld [hli], a
	xor a, a
	ld [hli], a
	ld [hl], a
	ld a, $05
	ld [wCommTimeoutMinutes], a
	ld hl, $C266
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, $A100
	ld de, $B000
	ld bc, $1000
	ld a, $2C
	call MobileAPI
	ld a, $04
	ld [wRam_C27D], a
	ld a, $01
	farcall CommPanel_DrawCaption
	jp Label_67_5A8E

PasswordChange_State_WaitResponse:: ; 67:5BD8
	xor a, a
	farcall CommPanel_Step
	cp a, $02
	jp z, PasswordChange_Abort
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_67_5C2A
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_67_5C2B
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_67_5C2A

; ---- code $5BFD-$5C2A (45 bytes) [PROBABLE] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 0; fall-through of the jrcc at 67:5BFB (executed)
	jr nz, Label_67_5C06
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_67_5C2A

Label_67_5C06:: ; 67:5C06
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_67_5C16
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_67_5C2A
	set 1, [hl]

Label_67_5C16:: ; 67:5C16
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_67_5C2B
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_67_5C2B

; ---- code $5C2A-$5C3D (19 bytes) [CONFIRMED] 11 insn(s); 11 executed (in up to 1/18 scenarios)

Label_67_5C2A:: ; 67:5C2A
	xor a, a

Label_67_5C2B:: ; 67:5C2B
	pop hl
	or a, a
	jp nz, Label_67_5D00
	ld a, [wCommTimeoutMinutes]
	ld b, a
	ld a, [wTimerBMinutes]
	cp a, b
	jr z, Label_67_5C3D
	xor a, a
	jr Label_67_5C3F

; ---- code $5C3D-$5C3F (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1; entered by jrcc from 67:5C38 (executed)

Label_67_5C3D:: ; 67:5C3D
	ld a, $FF

; ---- code $5C3F-$5C50 (17 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)

Label_67_5C3F:: ; 67:5C3F
	or a, a
	jp nz, Label_67_5D18
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, PasswordChange_HandleHttpStatus
	bit 0, a
	jp nz, Label_67_5A8E

; ---- code $5C50-$5C81 (49 bytes) [CONFIRMED] 70 insn(s) reached by static flow only; seeds: exec x49, site x20, table x1; min discovery hops 0; fall-through of the jpcc at 67:5C4D (executed) | 18 insn(s) executed; cut out of the PROBABLE region 5C50-5CF4 by apply_coverage --split [executed in 1 scenarios]
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld de, $B000
	ld hl, $B000
	ld bc, $1000
	farcall Charset_ConvertPage
	farcall Html_ParsePage
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D340
	ld a, [hli]
	cp a, $4F
	jr nz, Label_67_5C88

; ---- code $5C81-$5C88 (7 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5C50-5CF4 by apply_coverage --split
	ld a, [hl]
	cp a, $4B
	jr nz, Label_67_5C88
	jr Label_67_5CAD

; ---- code $5C88-$5CAD (37 bytes) [CONFIRMED] 20 insn(s) executed; cut out of the PROBABLE region 5C50-5CF4 by apply_coverage --split [executed in 1 scenarios]

Label_67_5C88:: ; 67:5C88
	ld a, $40
	ld [wMobileErrorCode], a
	ld hl, $D380
	ld a, [hli]
	sub a, $30
	swap a
	ld b, a
	ld a, [hli]
	sub a, $30
	or a, b
	ld [wRam_C274], a
	ld a, [hli]
	sub a, $30
	swap a
	ld b, a
	ld a, [hl]
	sub a, $30
	or a, b
	ld [wRam_C273], a
	jp PasswordChange_Cleanup

; ---- code $5CAD-$5CF4 (71 bytes) [PROBABLE] 28 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5C50-5CF4 by apply_coverage --split

Label_67_5CAD:: ; 67:5CAD
	ld a, $0A
	call MobileAPI
	ld a, $05
	ld [wRam_C27D], a
	ld a, $02
	farcall CommPanel_DrawCaption
	jp Label_67_5A8E

PasswordChange_State_Finish:: ; 67:5CC2
	xor a, a
	farcall CommPanel_Step
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Label_67_5D8D
	bit 0, a
	jp nz, Label_67_5A8E
	ld a, $36
	call MobileAPI
	call Function_67_5CF4
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ld [wRam_C27C], a
	ret

; ---- code $5CF4-$5D00 (12 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

Function_67_5CF4:: ; 67:5CF4
	ld a, $01
	farcall CommPanel_Step
	or a, a
	jr nz, Function_67_5CF4
	ret

; ---- code $5D00-$5D26 (38 bytes) [PROBABLE] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 1; entered by jpcc from 67:5C2D (executed)

Label_67_5D00:: ; 67:5D00
	ld hl, $C26F
	res 0, [hl]
	ld a, $00
	ld [wRam_C1D0], a
	ld a, $01
	ld [wRam_C1D1], a
	farcall CommNotice_ShowDialog
	jp PasswordChange_Cleanup

Label_67_5D18:: ; 67:5D18
	ld a, $26
	ld [wMobileErrorCode], a
	xor a, a
	ld [wRam_C273], a
	ld [wRam_C274], a
	jr PasswordChange_Cleanup

; ---- code $5D26-$5D3A (20 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)

PasswordChange_HandleHttpStatus:: ; 67:5D26
	farcall Mobile_SaveLastResult
	ld a, [wMobileErrorCode]
	cp a, $32
	jr nz, PasswordChange_Cleanup
	ld a, [wRam_C274]
	cp a, $03
	jr nz, PasswordChange_Cleanup

; ---- code $5D3A-$5D8D (83 bytes) [CONFIRMED] 45 insn(s) reached by static flow only; seeds: exec x45; min discovery hops 0; fall-through of the jrcc at 67:5D38 (executed) | 43 insn(s) executed; cut out of the PROBABLE region 5D3A-5D99 by apply_coverage --split [executed in 1 scenarios]
	ld a, [wRam_C273]
	dec a
	jr z, PasswordChange_FollowRedirect
	dec a
	jr z, PasswordChange_FollowRedirect
	jr PasswordChange_Cleanup

PasswordChange_FollowRedirect:: ; 67:5D45
	ld a, $05
	ld [wCommTimeoutMinutes], a
	ld hl, $C266
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	xor a, a
	ld hl, $B000
	ld bc, $1000
	call FillBytes
	call HttpRedirect_ResolveUrl
	ld hl, $A100
	ld a, $63
	ld [hli], a
	ld a, $A2
	ld [hli], a
	ld a, $63
	ld [hli], a
	ld a, $A4
	ld [hli], a
	xor a, a
	ld [hli], a
	ld [hl], a
	ld a, $05
	ld [wCommTimeoutMinutes], a
	ld hl, $C266
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, $A100
	ld de, $B000
	ld bc, $1000
	ld a, $2A
	call MobileAPI
	jp Label_67_5A8E

; ---- code $5D8D-$5D99 (12 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5D3A-5D99 by apply_coverage --split

Label_67_5D8D:: ; 67:5D8D
	farcall Function_68_4101
	farcall Mobile_SaveLastResult

; ---- code $5D99-$5DAF (22 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 1/18 scenarios)

PasswordChange_Cleanup:: ; 67:5D99
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_67_5DCF
	ld a, $02
	farcall CommPanel_DrawCaption
	ld a, [wTimerEnable]
	bit 0, a
	jr z, Label_67_5DB6

; ---- code $5DAF-$5DB6 (7 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 2; fall-through of the jrcc at 67:5DAD (executed)
	ld a, $34
	call MobileAPI
	jr Label_67_5DBB

; ---- code $5DB6-$5DFE (72 bytes) [CONFIRMED] 26 insn(s); 26 executed (in up to 1/18 scenarios)

Label_67_5DB6:: ; 67:5DB6
	ld a, $0A
	call MobileAPI

Label_67_5DBB:: ; 67:5DBB
	xor a, a
	farcall CommPanel_Step
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Label_67_5DCF
	bit 0, a
	jp nz, Label_67_5DBB

Label_67_5DCF:: ; 67:5DCF
	call Function_67_5CF4
	farcall Palette_FadeOutToWhite
	farcall Mobile_ShowLastError
	farcall Config_ClearSramMirror
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
	xor a, a
	ld [wRam_C27C], a
	ret

; ---- code $5DFE-$5E43 (69 bytes) [PROBABLE] 25 insn(s) reached by static flow only; seeds: exec x25; min discovery hops 1; entered by jpcc from 67:5AB5 (executed)

PasswordChange_Abort:: ; 67:5DFE
	ld a, $34
	call MobileAPI

Label_67_5E03:: ; 67:5E03
	farcall Function_00_0956
	call Function_00_044B
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Label_67_5D8D
	bit 0, a
	jp nz, Label_67_5E03
	call Function_67_5CF4
	farcall Palette_FadeOutToWhite
	farcall Config_ClearSramMirror
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
	ld a, $02
	ld [wRam_C27C], a
	ret

; ---- data $5E43-$5E7D (58 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Net_PwdChgCgiUrl:: ; 67:5E43
Data_67_5E43::
	db $68, $74, $74, $70, $3A, $2F, $2F, $6D, $67, $62, $2E, $64, $69, $6F, $6E, $2E
	db $6E, $65, $2E, $6A, $70, $2F, $63, $67, $69, $2D, $62, $69, $6E, $2F, $6D, $67
	db $62, $2F, $64, $61, $61, $5F, $67, $62, $5F, $70, $77, $64, $63, $68, $67, $2E
	db $63, $67, $69, $00

Net_GuestString:: ; 67:5E77
	db $67, $75, $65, $73, $74, $00

; ---- code $5E7D-$5EB4 (55 bytes) [CONFIRMED] 19 insn(s); 19 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

PasswordChange_BuildRequestBody:: ; 67:5E7D
Function_67_5E7D::
	ld hl, Net_PppIdKey
	ld de, $A363
	call CopyString
	ld hl, $A200
	ld de, $A363
	call Function_00_14F3
	ld hl, $5EBC
	ld de, $A363
	call Function_00_14F3
	ld hl, $DEB9
	ld de, $A363
	call Function_00_14F3
	ld hl, $5EC5
	ld de, $A363
	call Function_00_14F3
	ld hl, $DEC2
	ld de, $A363
	call Function_00_14F3
	ret

; ---- data $5EB4-$5EBC (8 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 5EB4-5ED1 by higher-priority evidence]

Net_PppIdKey:: ; 67:5EB4
Data_67_5EB4::
	db $50, $50, $50, $5F, $49, $44, $3D, $00

; ---- text $5EBC-$5ED1 (21 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

Net_PasswdKey:: ; 67:5EBC
String_67_5EBC::
	db $26, $50, $41, $53, $53, $57, $44, $3D, $00 ; "&PASSWD="

Net_NewPasswdKey:: ; 67:5EC5
	db $26, $4E, $45, $57, $50, $41, $53, $53, $57, $44, $3D, $00 ; "&NEWPASSWD="

; ---- code $5ED1-$5ED8 (7 bytes) [HYPOTHESIS] xor a; ld [$C27C],a; ld [$C27D],a - start of an unreferenced function that follows the strings at 5EB4-5ED1 and runs into the far-call site at 5ED8 (PROBABLE code); no entry found

Function_67_5ED1:: ; 67:5ED1
	xor a, a
	ld [wRam_C27C], a
	ld [wRam_C27D], a

; ---- code $5ED8-$5F0A (50 bytes) [PROBABLE] 19 insn(s) reached by static flow only; seeds: site x19; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall AdapterCheck_DrawScreen
	farcall Palette_FadeInFromWhite
	call Function_67_5EF1
	farcall Palette_FadeOutToWhite
	ld a, [wRam_C27C]
	ret

Function_67_5EF1:: ; 67:5EF1
	farcall Function_00_0956
	call Function_00_044B
	ld a, [wRam_C27D]
	add a, a
	add a, $0A
	ld l, a
	ld a, $5F
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- ptrtable $5F0A-$5F0E (4 bytes) [PROBABLE] jump table of 2 words right after the 'jp hl' dispatcher (ld a,[$C27D]; add a,a; add a,$0A; ... ld a,[hli]; ld h,[hl]; ld l,a; jp hl) at 67:5F:5EFA-5F09; extent = first target (5F0E); targets $5F0E, $5F20 are instruction starts of the code that follows

Table_67_5F0A:: ; 67:5F0A
	dw Label_67_5F0E
	dw Label_67_5F20

; ---- code $5F0E-$5F38 (42 bytes) [PROBABLE] entered through Table_67_5F0A (state handlers indexed by [$C27D]); decode chain legal, all 2 table targets are instruction starts, ends in known code region at 5F38; not executed in traces

Label_67_5F0E:: ; 67:5F0E
	ld de, $C271
	ld hl, $0067
	ld a, $02
	call MobileAPI
	ld a, $01
	ld [wRam_C27D], a
	jr Function_67_5EF1

Label_67_5F20:: ; 67:5F20
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Label_67_5F38
	bit 0, a
	jp nz, Function_67_5EF1
	ld a, $36
	call MobileAPI
	ld a, $01
	ld [wRam_C27C], a
	ret

; ---- code $5F38-$5F54 (28 bytes) [PROBABLE] 8 insn(s) reached by static flow only; seeds: site x8; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code

Label_67_5F38:: ; 67:5F38
	farcall Mobile_SaveLastResult
	farcall Palette_FadeOutToWhite
	ld a, $36
	call MobileAPI
	farcall Mobile_ShowLastError
	xor a, a
	ld [wRam_C27C], a
	ret

; ---- code $5F54-$5F5E (10 bytes) [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

Net_CopyDefaultDnsPair:: ; 67:5F54
Function_67_5F54::
	ld hl, Net_DefaultDnsPair
	ld bc, $0008
	call CopyBytes
	ret

; ---- data $5F5E-$5F66 (8 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Net_DefaultDnsPair:: ; 67:5F5E
Data_67_5F5E::
	db $C0, $A8, $28, $02, $C0, $A8, $28, $02
