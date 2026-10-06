; engine/account/helpers.asm
; bank 68, $4000-$4785 (1925 bytes); pinned by layout.link
; session counters, phone number BCD, text entry helpers, mail address building, config mirror and dial entry helpers

SECTION "engine/account/helpers", ROMX

; ---- data $4000-$4010 (16 bytes) [CONFIRMED] read as data by executed code (in up to 18/18 scenarios); content class unknown

Settings_MagicString:: ; 68:4000
Data_68_4000::
	db $4D, $4F, $42, $49, $4C, $45, $20, $54, $52, $41, $49, $4E, $45, $52, $30, $30

Session_ResetCounters:: ; 68:4010
Function_68_4010::
	; [CONFIRMED] 40 insn(s); 40 executed (in up to 7/18 scenarios); entry proven: target of an
	; executed call/far call
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
	ret

Wram3_CopyString:: ; 68:4021
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call CopyString
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Wram3_ClearByte:: ; 68:403B
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [hl], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

PhoneNumber_UnpackBcd:: ; 68:4054
	; [CONFIRMED] 41 insn(s) reached by static flow only; seeds: exec x41; min discovery hops 6;
	; entered by call from 68:4666 (PROBABLE code) [executed in 2 scenarios]
	ld b, $00
.loop ; 68:4056
	ld a, b
	cp a, $08
	jr z, .l408B
	ld a, [hli]
	ld c, a
	swap a
	and a, $0F
	cp a, $0F
	jr z, .l408B
	push hl
	ld hl, Dial_KeyCharTable
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	pop hl
	ld [de], a
	inc de
	ld a, c
	and a, $0F
	cp a, $0F
	jr z, .l408B
	push hl
	ld hl, Dial_KeyCharTable
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	pop hl
	ld [de], a
	inc de
	inc b
	jr .loop
.l408B ; 68:408B
	xor a, a
	ld [de], a
	ret

; ---- text $408E-$409A (12 bytes) [PROBABLE] 12 ASCII bytes "0123456789#*" (not NUL-terminated: telephone dial keys), addressed by ld hl,$408E at 68:4066 and 68:407B

PUSHC sjis
Dial_KeyCharTable:: ; 68:408E
String_68_408E::
	db "0123456789#*"
POPC

PhoneNumber_PackBcd:: ; 68:409A
	; [CONFIRMED] 38 insn(s) reached by static flow only; seeds: exec x38; min discovery hops 1;
	; entered by far from 67:568C (PROBABLE code) | 15 insn(s) executed; cut out of the PROBABLE
	; region 409A-40D8 by apply_coverage --split [executed in 1 scenarios]
	ld b, $00
.loop ; 68:409C
	ld a, [hli]
	or a, a
	jr z, .l40AD
	cp a, $23
	jr z, .l40B1
	cp a, $2A
	jr z, .l40B5
	sub a, $30
	ld c, a
	jr .l40B7
.l40AD ; 68:40AD
	ld c, $0F
	jr .l40B7
.l40B1 ; 68:40B1
	ld c, $0A
	jr .l40B7

.l40B5 ; 68:40B5
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 409A-40D8 by apply_coverage --split
	ld c, $0B

.l40B7 ; 68:40B7
	; [CONFIRMED] 22 insn(s) executed; cut out of the PROBABLE region 409A-40D8 by apply_coverage
	; --split [executed in 3 scenarios]
	ld a, b
	or a, a
	jr nz, .l40CA
	ld b, $01
	ld a, c
	swap a
	and a, $F0
	ld [de], a
	ld a, c
	cp a, $0F
	jr z, .done
	jr .loop
.l40CA ; 68:40CA
	ld b, $00
	ld a, [de]
	or a, c
	ld [de], a
	inc de
	ld a, c
	cp a, $0F
	jr z, .done
	jr .loop
.done ; 68:40D7
	ret

TextEntry_UpdateCursorSprite:: ; 68:40D8
Function_68_40D8::
	; [CONFIRMED] 72 insn(s); 72 executed (in up to 7/18 scenarios); entry proven: target of an
	; executed call/far call
	farcall TextBuf_GetCount
	push de
	ld de, $0006
	call Multiply8x16
	pop de
	ld a, d
	add a, l
	ld d, e
	ld e, a
	ld hl, wSpriteSlot0
	call Sprite_SetPosition
	ret

OnlineTimer_HasElapsed:: ; 68:40F1
	xor a, a
	ld hl, wTimerAFrames
	ld b, [hl]
	inc hl
	or a, b
	ld b, [hl]
	inc hl
	or a, b
	ld b, [hl]
	inc hl
	or a, b
	ld b, [hl]
	or a, b
	ret

Comm_ClearSessionActive:: ; 68:4101
Function_68_4101::
	xor a, a
	ld [wCommSessionActive], a
	ret

Account_ClearWorkBuffers:: ; 68:4106
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0163
	ld hl, $DE80 ; raw: wipes $0163 bytes over wTextEntryBuf and the account fields, not only the first name
	call FillBytes
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

TextEntry_InsertString:: ; 68:4127
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, d
	ld c, e
.loop ; 68:4136
	ld a, [bc]
	or a, a
	jr z, .l4148
	inc bc
	push bc
	push hl
	ld d, a
	farcall TextBuf_AppendChar
	pop hl
	pop bc
	jr .loop
.l4148 ; 68:4148
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

TextEntry_InsertMaskedString:: ; 68:4152
Function_68_4152::
	; [HYPOTHESIS] function body after the ret at 4151 (ldh [$F2],a ; ldh a,[$8D] ; push af ; ... ld
	; a,3 ; ldh [$8D],a ; ldh [$70],a ; ld b,d ; ld c,e) that falls into the code at 4161 [verifier:
	; no entry proven (no caller, no valid table word, never executed): decode chain alone is not
	; proof -> HYPOTHESIS]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, d
	ld c, e

.loop ; 68:4161
	; [PROBABLE] 18 insn(s) reached by static flow only; seeds: site x18; min discovery hops 0;
	; entered by jr from 68:4173 (PROBABLE code)
	ld a, [bc]
	or a, a
	jr z, .l4175
	inc bc
	push bc
	push hl
	ld a, $2A
	ld d, a
	farcall TextBuf_AppendChar
	pop hl
	pop bc
	jr .loop
.l4175 ; 68:4175
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

TextEntry_CopyText:: ; 68:417F
Function_68_417F::
	; [CONFIRMED] 44 insn(s); 44 executed (in up to 7/18 scenarios); entry proven: target of an
	; executed call/far call
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	inc hl
	inc hl
	inc hl
	call CopyString
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Account_BuildMailAddress:: ; 68:419C
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wAcctMailAddress], a
	ld hl, wAcctMailLocalPart
	ld de, wAcctMailAddress
	call CopyString
	ld hl, $41DB
	ld de, wAcctMailAddress
	call StringAppend
	ld hl, wAcctMailSubdomain
	ld de, wAcctMailAddress
	call StringAppend
	ld hl, $41DD
	ld de, wAcctMailAddress
	call StringAppend
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- data $41DB-$41DD (2 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown [clipped from 41DB-41E9 by higher-priority evidence]

Account_MailAtSign:: ; 68:41DB
Data_68_41DB::
	db $40, $00

; ---- text $41DD-$41E9 (12 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
Account_MailDomainSuffix:: ; 68:41DD
String_68_41DD::
	db ".dion.ne.jp", 0
POPC

Account_CopyMailAddressToFar:: ; 68:41E9
Function_68_41E9::
	; [CONFIRMED] 40 insn(s); 40 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld [wCopyMailAddressToFar_Bank], a
	ld a, l
	ld [wCopyMailAddressToFar_DestLo], a
	ld a, h
	ld [wCopyMailAddressToFar_DestHi], a
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, sSettingsMailAddress
	ld de, $C27F ; raw: base of the decoded mail-address string buffer, not the screen variable byte
	call DecodeXorA5
	ld a, [wCopyMailAddressToFar_DestLo]
	ld l, a
	ld a, [wCopyMailAddressToFar_DestHi]
	ld h, a
	ld a, [wCopyMailAddressToFar_Bank]
	call BankSwitch_H_Local
	ld hl, $C27F ; raw: base of the decoded mail-address string buffer, not the screen variable byte
	ld a, [wCopyMailAddressToFar_DestLo]
	ld e, a
	ld a, [wCopyMailAddressToFar_DestHi]
	ld d, a
	call CopyString
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ret

BankSwitch_H_Local:: ; 68:4239
	bit 7, h
	jr z, .l424C
	bit 6, h
	jr z, .l4246

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 68:423F (executed)
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

.l4246 ; 68:4246
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ret

.l424C ; 68:424C
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 68:423B (executed)
	ldh [hROMBankLo], a
	ld [$2100], a
	ret

Config_ClearSramMirror:: ; 68:4252
Function_68_4252::
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 6/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hSRAMBank], a
	ld [rRAMB], a
	xor a, a
	ld bc, $0100
	ld hl, sConfigImage
	call FillBytes
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

Stub_Nop_68_4282:: ; 68:4282
Function_68_4282::
	ret

Sram_WipeBanks2And3:: ; 68:4283
Function_68_4283::
	; [HYPOTHESIS] complete ret-terminated function (42 insn): enables SRAM ($0A to $0000 / hFFF5),
	; selects SRAM bank 2 then 3 ($4000 register) and clears $A000-$AFFF and $B000-$BFFF with call
	; $04D8 / $0392, then restores the banks; entry not proven [verifier: no entry proven (no
	; caller, no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS]
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hSRAMBank], a
	ld [rRAMB], a
	xor a, a
	ld hl, _SRAM
	ld bc, $1000
	call FillBytes
	call Sound_FrameService
	xor a, a
	ld hl, $B000
	ld bc, $1000
	call FillBytes
	call Sound_FrameService
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	xor a, a
	ld hl, _SRAM
	ld bc, $1000
	call FillBytes
	call Sound_FrameService
	xor a, a
	ld hl, $B000
	ld bc, $1000
	call FillBytes
	call Sound_FrameService
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

Sram_WipeAllBanks:: ; 68:42E4
Function_68_42E4::
	; [CONFIRMED] 70 insn(s); 70 executed (in up to 17/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld d, $00
.loop ; 68:42ED
	ld a, d
	ldh [hSRAMBank], a
	ld [rRAMB], a
	xor a, a
	ld hl, _SRAM
	ld bc, $1000
	call FillBytes
	call Sound_FrameService
	xor a, a
	ld hl, $B000
	ld bc, $1000
	call FillBytes
	call Sound_FrameService
	inc d
	ld a, d
	cp a, $04
	jr c, .loop
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

Config_MirrorIsRegistered:: ; 68:431A
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [sSram_A000]
	cp a, $4D
	jr nz, .l4365
	ld a, [sSram_A001]
	cp a, $41
	jr nz, .l4365
	ld a, [sSram_A002]
	cp a, $81
	jp nz, .l4365
	ld a, [sSram_A003]
	cp a, $00
	jr nz, .l4365
	call Config_MirrorChecksumOk
	or a, a
	jr z, .l4365
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ret
.l4365 ; 68:4365
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ret

Settings_IsRegistrationStarted:: ; 68:4377
Function_68_4377::
	; [HYPOTHESIS] complete ret-terminated function (34 insn): enables SRAM, selects bank 1, reads
	; [$B010] xor $A5 and returns 1 or 0 (SRAM validity check); entry not proven [verifier: no entry
	; proven (no caller, no valid table word, never executed): decode chain alone is not proof ->
	; HYPOTHESIS]
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [sSettingsRegistrationProgress]
	xor a, $A5
	or a, a
	jr z, .l43A7
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ret
.l43A7 ; 68:43A7
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ret

Settings_SetProgressState3:: ; 68:43B9
Function_68_43B9::
	; [CONFIRMED] 62 insn(s); 62 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, sSettingsRegistrationProgress
	ld a, $03
	xor a, $A5
	ld b, a
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, b
	ld [hl], a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ret

Settings_StoreAdapterType:: ; 68:43F4
	ld hl, sSettingsAdapterType
	ld a, [wMobileAdapterType]
	xor a, $A5
	ld b, a
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, b
	ld [hl], a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ret

Settings_GetAdapterType:: ; 68:4430
Function_68_4430::
	; [HYPOTHESIS] complete ret-terminated function (30 insn): ld hl,$B011 ... reads one SRAM byte
	; from bank 1 with the enable/bank save-restore sequence, returns b xor $A5; entry not proven
	; [verifier: no entry proven (no caller, no valid table word, never executed): decode chain
	; alone is not proof -> HYPOTHESIS]
	ld hl, sSettingsAdapterType
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [hl]
	ld b, a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ld a, b
	xor a, $A5
	ret

Dial_SelectEntryFromList:: ; 68:4469
Function_68_4469::
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld b, a
	ld d, h
	ld e, l
	or a, a
	ret z

	; [PROBABLE] 27 insn(s) reached by static flow only; seeds: exec x27; min discovery hops 0;
	; fall-through of the retcc at 68:446D (executed)
	call Dial_SkipStringThenSetSelectedEntry
	call Dial_SkipStringThenSetSelectedEntry
	ld a, b
	dec a
	jr z, .l4484
	dec a
	jr z, .l447E
	ld a, $FF
	ret
.l447E ; 68:447E
	call Dial_SkipStringThenSetSelectedEntry
	call Dial_SkipStringThenSetSelectedEntry
.l4484 ; 68:4484
	ld a, [hl]
	or a, a
	jr z, .l448A
	ld a, b
	ret
.l448A ; 68:448A
	ld h, d
	ld l, e
	push hl
	ld b, $00
	call Settings_SetSelectedDialEntry
	pop hl
	xor a, a
	ret

Dial_SkipStringThenSetSelectedEntry:: ; 68:4495
Function_68_4495::
	ld a, [hli]
	or a, a
	jr nz, Dial_SkipStringThenSetSelectedEntry

Settings_SetSelectedDialEntry:: ; 68:4499
Function_68_4499::
	; [CONFIRMED] 49 insn(s); 49 executed (in up to 3/18 scenarios); entry proven: target of an
	; executed call/far call
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, b
	xor a, $A5
	ld [sSettingsSelectedDialEntry], a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ret

Settings_GetSelectedDialEntry:: ; 68:44D0
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [sSettingsSelectedDialEntry]
	xor a, $A5
	ld b, a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ld a, b
	cp a, $03
	ret c

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the retcc at 68:44F8 (executed)
	xor a, a
	ld b, a
	ret

Settings_GetHiddenModeFlag:: ; 68:44FC
Function_68_44FC::
	; [CONFIRMED] 30 insn(s); 30 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [sSettingsHiddenMode]
	xor a, $A5
	ld b, a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ld a, b
	or a, a
	jr z, .skip

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 68:4534 (executed) [executed in 2 scenarios]
	ld a, $01
	ld b, a

.skip ; 68:4539
	; [CONFIRMED] 25 insn(s); 25 executed (in up to 4/18 scenarios)
	ld a, b
	ret

Settings_SetHiddenModeFlag:: ; 68:453B
	ld b, a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, b
	xor a, $A5
	ld [sSettingsHiddenMode], a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

Dial_EntryHasNumber:: ; 68:4568
	; [CONFIRMED] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 7;
	; entered by far from 67:4E4D (PROBABLE code) [executed in 2 scenarios]
	ld b, a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, b
	ld hl, Dial_EntryNumberBuffers
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld b, [hl]
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, b
	or a, a
	ret z
	ld a, $01
	ret

; ---- words $4594-$459A (6 bytes) [PROBABLE] 3 words wDialEntries + $00, $33, $66 (stride $33, WRAM3 addresses: bank 3 is selected at 68:4570-4574) addressed by ld hl,$4594 at 68:4577; extent bounded by the next code region

Dial_EntryNumberBuffers:: ; 68:4594
Table_68_4594::
	dw wDialEntries, wDialEntries + $33, wDialEntries + $66

Config_MirrorChecksumOk:: ; 68:459A
Function_68_459A::
	; [CONFIRMED] 40 insn(s); 40 executed (in up to 12/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, sConfigImage
	ld de, $0000
	ld b, $BE
.loop ; 68:45B7
	ld a, [hli]
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	dec b
	jr nz, .loop
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld a, b
	cp a, d
	jr nz, .l45DF
	ld a, c
	cp a, e
	jr nz, .l45DF
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ret

.l45DF ; 68:45DF
	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 1;
	; entered by jrcc from 68:45C6 (executed)
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ret

Config_MirrorUpdateChecksum:: ; 68:45F1
Function_68_45F1::
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 3/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, sConfigImage
	ld de, $0000
	ld b, $BE
.loop ; 68:45F9
	ld a, [hli]
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	dec b
	jp nz, .loop
	ld a, d
	ld [hli], a
	ld [hl], e
	ret

Config_LoadMirrorToWram:: ; 68:4608
	; [CONFIRMED] 136 insn(s) reached by static flow only; seeds: exec x136; min discovery hops 3;
	; entered by far from 67:4023 (PROBABLE code) [executed in 1 scenarios]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
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
	ld a, $02
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, sConfigLoginId
	ld de, wAcctLoginId
	call CopyString
	ld hl, sConfigMailAddress
	ld de, wAcctMailAddress
	call CopyString
	ld hl, sConfigDial0Text
	ld de, wDialEntries + $22
	ld bc, $0010
	call CopyStringMax_ZeroSrcOnEmpty
	ld hl, sConfigDial1Text
	ld de, wDialEntries + $55
	ld bc, $0010
	call CopyStringMax_ZeroSrcOnEmpty
	ld hl, sConfigDial2Text
	ld de, wDialEntries + $88
	ld bc, $0010
	call CopyStringMax_ZeroSrcOnEmpty
	ld hl, sConfigDial0Number
	ld de, wDialEntries
	call PhoneNumber_UnpackBcd
	ld hl, sConfigDial1Number
	ld de, wDialEntries + $33
	call PhoneNumber_UnpackBcd
	ld hl, sConfigDial2Number
	ld de, wDialEntries + $66
	call PhoneNumber_UnpackBcd
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, sSettingsDialNumbers
	ld de, wDialEntries + $11
	call DecodeXorA5
	ld hl, sSettingsDialNumbers + $11
	ld de, wDialEntries + $44
	call DecodeXorA5
	ld hl, sSettingsDialNumbers + $22
	ld de, wDialEntries + $77
	call DecodeXorA5
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Dial_LoadDefaultsForAdapterType:: ; 68:46C8
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMobileAdapterType]
	ld hl, Config_DefaultImageTable
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $0076
	add hl, de
	ld de, wAcctNumberInternet
	farcall PhoneNumber_UnpackBcd
	ld a, [wMobileAdapterType]
	ld hl, Dial_DefaultNumberTable
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wAcctNumberSelfPage
	farcall CopyString
	ld a, [wMobileAdapterType]
	ld hl, Config_DefaultImageTable
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $007E
	add hl, de
	ld de, wAcctNumberComment
	ld bc, $0010
	farcall CopyStringMax_ZeroSrcOnEmpty
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Settings_StoreMailAddress:: ; 68:4735
Function_68_4735::
	; [CONFIRMED] 132 insn(s); 132 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call (part of region $4735-$4842)
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, wAcctMailAddress
	ld de, sSettingsMailAddress
	call EncodeXorA5
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret
