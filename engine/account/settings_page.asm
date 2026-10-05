; engine/account/settings_page.asm
; bank 68, $4785-$4DB4 (1583 bytes); pinned by layout.link
; settings page in SRAM bank 1 (init, verify/repair, checksum, field stores, account load)

SECTION "engine/account/settings_page", ROMX

Settings_InitPage:: ; 68:4785
	; [CONFIRMED] 132 insn(s); 132 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call (part of region $4735-$4842)
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
	ld hl, sSettingsPage
	ld bc, $0200
	ld a, $A5
	call FillBytes
	ld hl, Settings_MagicString
	ld de, sSettingsPage
	ld bc, $0010
	call CopyBytes
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
	ld hl, sSettingsSavePasswordFlag
	ld a, $01
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
	call Settings_UpdateChecksumAndBackup
	ret

Settings_ClearFieldsKeepProgress:: ; 68:480A
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
	ld a, [sSettingsRegistrationProgress]
	ld b, a
	push bc
	ld hl, sSettingsPage
	ld bc, $0066
	ld a, $A5
	call FillBytes
	pop bc
	ld a, b
	xor a, $A5
	cp a, $01
	jr z, .l4847
	cp a, $02
	jr z, .l4847

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 68:4840 (executed)
	cp a, $03
	jr z, .l4847
	xor a, a

.l4847 ; 68:4847
	; [CONFIRMED] 64 insn(s); 64 executed (in up to 18/18 scenarios)
	xor a, $A5
	ld [sSettingsRegistrationProgress], a
	ld hl, Settings_MagicString
	ld de, sSettingsPage
	ld bc, $0010
	call CopyBytes
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
	call Settings_UpdateChecksumAndBackup
	ret

Settings_GetRegistrationProgress:: ; 68:4870
	call Settings_VerifyAndRepair
	add a, a
	add a, $D6
	ld l, a
	ld a, $48
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

	ld hl, sSettingsRegistrationProgress
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
	cp a, $01
	jr z, .l48C8
	cp a, $02
	jr z, .l48CB
	cp a, $03
	jr z, .l48CE

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 68:48C2 (executed)
	xor a, a
	ret

	; [HYPOTHESIS] xor a ; ret stub between the arms of the switch at 48B8-48D0 (returns 0); nothing
	; branches to it
	xor a, a
	ret

.l48C8 ; 68:48C8
	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by jrcc from 68:48BA (executed) [executed in 2 scenarios]
	ld a, $02
	ret

.l48CB ; 68:48CB
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 12/18 scenarios)
	ld a, $03
	ret
.l48CE ; 68:48CE
	ld a, $04
	ret

	; [PROBABLE] ld a,1 ; ret: entry proven by a table word - the 4-word code-pointer table at
	; 68:48D6 ($4880,$4880,$48D1,$48D4) holds $48D1; sits after the last arm of the switch at
	; 48B8-48D0
	ld a, $01
	ret

	; [CONFIRMED] 2 insn(s); 2 executed (in up to 5/18 scenarios)
	xor a, a
	ret

; ---- words $48D6-$48DE (8 bytes) [PROBABLE] contiguous data block 48D6-48DE: 4 bytes were read as data by executed code in mGBA traces (2 separate read ranges, e.g. 48D6-48D8,48DC-48DE) and 4 bytes between/around those reads were never read; the whole run is one table/buffer read by index (gaps unread in the traces); content class not decoded [merged from 3 regions by classify_g2] [retyped data->words by classify_g2: every word is an instruction start of a code region of this bank (jump/dispatch table)]

Settings_ProgressJumpTable:: ; 68:48D6
Table_68_48D6::
	dw $4880, $4880, $48D1, $48D4

Settings_VerifyAndRepair:: ; 68:48DE
Function_68_48DE::
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, sSettingsPage
	call Settings_CheckPageMagicAndSum
	or a, a
	jr z, .l48ED
	cp a, $01
	jr z, .l48F3
	jr .l4940
.l48ED ; 68:48ED
	call Settings_UpdateChecksumAndBackup
	ld a, $00
	ret

.l48F3 ; 68:48F3
	; [CONFIRMED] 37 insn(s) reached by static flow only; seeds: exec x37; min discovery hops 1;
	; entered by jrcc from 68:48E9 (executed) | 4 insn(s) executed; cut out of the PROBABLE region
	; 48F3-4940 by apply_coverage --split [executed in 1 scenarios]
	ld hl, sSettingsBackup
	call Settings_CheckPageMagicAndSum
	or a, a
	jr z, .l48FE

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 48F3-4940 by apply_coverage --split
	jr .l493D

.l48FE ; 68:48FE
	; [CONFIRMED] 30 insn(s) executed; cut out of the PROBABLE region 48F3-4940 by apply_coverage
	; --split [executed in 1 scenarios]
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
	ld hl, sSettingsBackup
	ld de, sSettingsPage
	ld bc, $0100
	call CopyBytes
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
	ld a, $01
	ret

.l493D ; 68:493D
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 48F3-4940 by apply_coverage --split
	ld a, $02
	ret

.l4940 ; 68:4940
	; [CONFIRMED] 48 insn(s); 48 executed (in up to 18/18 scenarios)
	ld hl, sSettingsBackup
	call Settings_CheckPageMagicAndSum
	or a, a
	jr z, .l48FE
	cp a, $01
	jr z, .l493D
	ld a, $03
	ret

Settings_CheckPageMagicAndSum:: ; 68:4950
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
	push hl
	ld bc, $00FE
	call Checksum16_Sum
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, b
	cp a, d
	jr nz, .l498E
	ld a, c
	cp a, e
	jr nz, .l498E
	pop hl
	ld de, Settings_MagicString
	ld b, $10
	call CompareStringN
	or a, a
	jr nz, .l499E
	ld b, $00
	jr .l49A0
.l498E ; 68:498E
	pop hl
	ld de, Settings_MagicString
	ld b, $10
	call CompareStringN
	or a, a
	jr nz, .l499E

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 68:4998 (executed) [executed in 1 scenarios]
	ld b, $01
	jr .l49A0

.l499E ; 68:499E
	; [CONFIRMED] 528 insn(s); 528 executed (in up to 18/18 scenarios)
	ld b, $02
.l49A0 ; 68:49A0
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
	ret

Settings_UpdateChecksumAndBackup:: ; 68:49B6
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
	ld hl, sSettingsPage
	ld bc, $00FE
	call Checksum16_Sum
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, sSettingsPage
	ld de, sSettingsBackup
	ld bc, $0100
	call CopyBytes
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

Checksum16_Sum:: ; 68:49FF
	ld de, $0000
.loop ; 68:4A02
	ld a, [hli]
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	dec bc
	ld a, c
	or a, b
	jr nz, .loop
	ret

Settings_ClearVariableBlock:: ; 68:4A0F
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
	xor a, a
	ld hl, sVarPage
	ld bc, $0100
	call FillBytes
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

Settings_StoreStringField:: ; 68:4A4A
	push bc
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
	call EncodeXorA5
	ld a, [sSettingsFieldMask]
	or a, b
	ld [sSettingsFieldMask], a
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
	ld hl, sSettingsRegistrationProgress
	ld a, $01
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
	ld hl, sSettingsFieldMask
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
	pop bc
	or a, b
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
	call Settings_UpdateChecksumAndBackup
	ret

Settings_StoreByteField:: ; 68:4B48
	push bc
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
	ld hl, sSettingsRegistrationProgress
	ld a, $01
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
	ld hl, sSettingsFieldMask
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
	pop bc
	or a, b
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
	call Settings_UpdateChecksumAndBackup
	ret

Settings_SetProgressState2:: ; 68:4C2B
	ld hl, sSettingsRegistrationProgress
	ld a, $02
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
	call Settings_UpdateChecksumAndBackup
	ret

Settings_LoadAccountToWram:: ; 68:4C69
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
	ld hl, sSettingsLoginId
	ld de, $DEA0
	call DecodeXorA5
	ld hl, sSettingsMailLocalPart
	ld de, $DEAB
	call DecodeXorA5
	ld hl, sSettingsMailSubdomain
	ld de, $DEB4
	call DecodeXorA5
	ld hl, sSettingsPassword
	ld de, $DEB9
	call DecodeXorA5
	ld hl, sSettingsPassword
	ld de, $DECB
	call DecodeXorA5
	ld hl, sSettingsNumberInternet
	ld de, $DEDD
	call DecodeXorA5
	ld hl, sSettingsNumberSelfPage
	ld de, $DEEE
	call DecodeXorA5
	ld hl, sSettingsNumberComment
	ld de, $DEFF
	call DecodeXorA5
	ld hl, sSettingsSavePasswordFlag
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
	ld [wSavePasswordFlag], a
	ld hl, sSettingsManualNumbersFlag
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
	ld [sPhoneMethodMenuCursor], a
	ld [wManualNumbersFlag], a
	ld hl, sSettingsHiddenAtRegistration
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
	ld [wHiddenModeFlag], a
	call Account_BuildMailAddress
	ld a, $01
	ld [wRam_C279], a
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
