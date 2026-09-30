; engine/settings/phone_number_entry.asm
; bank 67, $4000-$4631 (1585 bytes); pinned by layout.link
; settings dispatcher entry and the phone keypad entry screen

SECTION "engine/settings/phone_number_entry", ROMX

SettingsPhone_Run:: ; 67:4000
	; [CONFIRMED] 127 insn(s) reached by static flow only; seeds: exec x127; min discovery hops 2;
	; entered by jpcc from 67:4125 (PROBABLE code) | 19 insn(s) executed; cut out of the PROBABLE
	; region 4000-4156 by apply_coverage --split [executed in 2 scenarios]
	call SettingsPhone_ResetTopCursor
	call SettingsPhone_ResetSlotCursor
	call SettingsPhone_ResetMethodCursor
	xor a, a
	ld [wManualNumbersFlag], a
	farcall Account_ClearWorkBuffers
	farcall Config_ClearSramMirror
	farcall SettingsPhone_ReadAdapterConfig
	or a, a
	jp z, .l414D
	farcall Config_LoadMirrorToWram
.l4029 ; 67:4029
	ld a, $00
	farcall SettingsPhone_ChoiceMenu
	or a, a
	jp z, .done
	cp a, $01
	jr z, .l4041
	cp a, $02
	jp z, .l4046

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4000-4156 by apply_coverage --split
	jp .done

.l4041 ; 67:4041
	; [CONFIRMED] 49 insn(s) executed; cut out of the PROBABLE region 4000-4156 by apply_coverage
	; --split [executed in 1 scenarios]
	call SettingsPhone_ResetSlotCursor
	jr .l4086
.l4046 ; 67:4046
	farcall Settings_GetSelectedDialEntry
	ld a, b
	ld hl, $BF03
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
	jp z, .l412A
.l4086 ; 67:4086
	call SettingsPhone_ClearEntryBuffers
	xor a, a
	farcall SettingsPhone_SlotMenu
	or a, a
	jr z, .l4029
	dec a
	ld [wRam_C283], a
	call SettingsPhone_ResetMethodCursor
.l409A ; 67:409A
	ld a, $01
	farcall SettingsPhone_ChoiceMenu
	or a, a
	jr z, .l4086
	cp a, $01
	jr z, .l40B0
	cp a, $02
	jr z, .l40D3

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4000-4156 by apply_coverage --split
	jp .done

.l40B0 ; 67:40B0
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 4000-4156 by apply_coverage
	; --split [executed in 1 scenarios]
	farcall Dial_LoadDefaultsForAdapterType
	ld a, [wRam_C283]
	farcall SettingsPhone_ConfirmScreen
	or a, a
	jr z, .l40CE
	cp a, $02
	jp z, .l414D
	ld a, $01
	ld [wManualNumbersFlag], a
	jr .l4112

.l40CE ; 67:40CE
	; [CONFIRMED] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4000-4156 by apply_coverage --split [executed in 1 scenarios]
	call SettingsPhone_ClearEntryBuffers
	jr .l409A

.l40D3 ; 67:40D3
	; [CONFIRMED] 30 insn(s) executed; cut out of the PROBABLE region 4000-4156 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $0C
	farcall Notice_ShowPage
	or a, a
	jr z, .l409A
.l40DE ; 67:40DE
	ld a, $00
	farcall PhoneKeypad_Run
	or a, a
	jr z, .l40D3
.l40E9 ; 67:40E9
	ld a, $01
	farcall PhoneKeypad_Run
	or a, a
	jr z, .l40DE
.l40F4 ; 67:40F4
	farcall PhoneComment_KeyboardRun
	or a, a
	jr z, .l40E9
	ld a, [wRam_C283]
	farcall SettingsPhone_ConfirmScreen
	or a, a
	jr z, .l40F4
	cp a, $02
	jr z, .l414D
	ld a, $01
	ld [wManualNumbersFlag], a
.l4112 ; 67:4112
	ld a, [wRam_C283]
	farcall SettingsPhone_WriteAdapterConfig
	or a, a
	jr z, .l414D
	farcall SettingsPhone_ContinuePrompt
	or a, a
	jp nz, SettingsPhone_Run

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4000-4156 by apply_coverage --split
	jr .done

.l412A ; 67:412A
	; [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 4000-4156 by apply_coverage
	; --split [executed in 2 scenarios]
	ld a, $01
	farcall SettingsPhone_SlotMenu
	or a, a
	jp z, .l4029
	dec a
	ld b, a
	farcall Settings_SetSelectedDialEntry
	farcall Settings_UpdateChecksumAndBackup
	ld a, $0D
	farcall Notice_ShowPage
.done ; 67:414C
	ret

.l414D ; 67:414D
	; [CONFIRMED] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4000-4156 by apply_coverage --split [executed in 1 scenarios]
	ld a, $0E
	farcall Notice_ShowPage
	ret

SettingsPhone_ResetTopCursor:: ; 67:4156
Function_67_4156::
	; [CONFIRMED] 90 insn(s); 90 executed (in up to 5/18 scenarios); entry proven: target of an
	; executed call/far call
	xor a, a
	ld hl, $BF02
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

SettingsPhone_ResetSlotCursor:: ; 67:418E
	xor a, a
	ld hl, $BF03
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

SettingsPhone_ResetMethodCursor:: ; 67:41C6
	xor a, a
	ld hl, $BF04
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

SettingsPhone_ClearEntryBuffers:: ; 67:41FE
	; [CONFIRMED] 31 insn(s) reached by static flow only; seeds: exec x31; min discovery hops 4;
	; entered by far from 65:429A (PROBABLE code) [executed in 1 scenarios]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0033
	ld hl, $DEDD
	call FillBytes
	ld a, [wSettingsFieldMask]
	ld b, a
	ld a, $28
	xor a, $FF
	and a, b
	ld [wSettingsFieldMask], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

PhoneKeypad_Run:: ; 67:422B
	ld [wRam_C27D], a
	call PhoneKeypad_Setup
	farcall Palette_FadeInFromWhite
	call PhoneKeypad_Loop
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	ld a, [wRam_C27C]
	ret

PhoneKeypad_ClearStoredBitsIfEdited:: ; 67:424A
Function_67_424A::
	; [HYPOTHESIS] function with no found entry (no call/jp/table word/far pointer/ld r16 to $424A
	; anywhere in the ROM); linear decode is legal ($424A-$431F), all direct targets are known code
	; starts, reads SRAM $B08B/$B09C via ROM0 helpers 14EA/1509 (bank/SRAM enable idiom ldh
	; [$FFF5]/[$FF8C]/[$FF8D] shared with the CONFIRMED code around it), clears bits $08/$10 of
	; $C278; ends with ret. Sits after a ret between PROBABLE/CONFIRMED functions of the same style
	; [verifier: the only ROM hits for its instruction starts are the ROM0 trampolines 00:20BB (jp
	; $42C0) and 00:20CD (jp $42EC) which jump into whatever bank is mapped; nothing calls those
	; trampolines (checked) and nothing shows bank 67, so it stays HYPOTHESIS] | forced execution:
	; 48/104 instruction starts ran in forced_dead (traces/forced/, not natural evidence; status
	; unchanged)
	ld a, [wRam_C27D]
	or a, a
	jr nz, .l42B7
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
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $B08B
	ld de, $C28F
	call DecodeXorA5
	ld hl, $C28F
	ld de, $DEDD
	call CompareString
	or a, a
	jr z, .l429A
	ld a, [wSettingsFieldMask]
	ld b, a
	ld a, $08
	xor a, $FF
	and a, b
	ld [wSettingsFieldMask], a
.l429A ; 67:429A
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
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
.l42B7 ; 67:42B7
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
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $B09C
	ld de, $C28F
	call DecodeXorA5
	ld hl, $C28F
	ld de, $DEEE
	call CompareString
	or a, a
	jr z, .l4301
	ld a, [wSettingsFieldMask]
	ld b, a
	ld a, $10
	xor a, $FF
	and a, b
	ld [wSettingsFieldMask], a
.l4301 ; 67:4301
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
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

PhoneKeypad_Setup:: ; 67:431F
	; [CONFIRMED] 211 insn(s) reached by static flow only; seeds: exec x211; min discovery hops 6;
	; entered by call from 67:422E (PROBABLE code) | 103 insn(s) executed; cut out of the PROBABLE
	; region 431F-4571 by apply_coverage --split [executed in 1 scenarios]
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	xor a, a
	ld [wRam_C27C], a
	ld [wRam_C27E], a
	ld hl, $DE80
	ld b, $11
	farcall TextBuf_Init
	ld a, [wRam_C27D]
	or a, a
	jr nz, .l4355
	ld hl, $DE80
	ld de, $DEDD
	farcall TextEntry_InsertString
	jr .l4361
.l4355 ; 67:4355
	ld hl, $DE80
	ld de, $DEEE
	farcall TextEntry_InsertString
.l4361 ; 67:4361
	call PhoneKeypad_UpdateNonEmptyFlag
	ld de, $8801
	ld hl, Data_5E_4000
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Data_5E_4400
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_PhoneKeypadAndComment_Tiles9000Vb1
	ld a, $4A
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_PhoneKeypadAndComment_Tiles9400Vb1
	ld a, $4A
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, $D800
	ld hl, Data_5E_4D00
	ld a, $5E
	farcall Palette_LoadToBuffer
	ld a, [wRam_C27D]
	or a, a
	jr nz, .l43D6
	ld bc, $0514
	ld de, $D000
	ld hl, Tilemap_PhoneKeypad_4A_7120
	ld a, $4A
	farcall Tilemap_CopyRectAndAttr
	jr .l43E7
.l43D6 ; 67:43D6
	ld bc, $0514
	ld de, $D000
	ld hl, Tilemap_PhoneKeypad_4A_71E8
	ld a, $4A
	farcall Tilemap_CopyRectAndAttr
.l43E7 ; 67:43E7
	ld a, $03
	ld hl, $DE83
	call PhoneKeypad_PrintText
	call PhoneKeypad_UploadTextTiles
	call PhoneKeypad_BuildTextMap
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld a, $02
	ld b, $02
	farcall Kbd_Open
	ld hl, $DA00
	ld de, $4D30
	ld a, $5F
	ld b, $81
	farcall Sprite_InitSlot
	ld d, $20
	ld e, $10
	ld hl, $DE80
	farcall TextEntry_UpdateCursorSprite
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $01
	jr c, .l442F
	ret
.l442F ; 67:442F
	farcall Kbd_ShowMarkerSprite
	farcall Sprite_UpdateAll
	ret

PhoneKeypad_Loop:: ; 67:443C
	farcall Sprite_UpdateAll
	ld a, [wRam_C27E]
	ld c, a
	farcall Kbd_Run
	cp a, $01
	jr z, .l4461
	cp a, $02
	jr z, .l44B2
	cp a, $07
	jp z, .l44EB
	cp a, $08
	jp z, .l4523

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 431F-4571 by apply_coverage --split
	jp .l4556

.l4461 ; 67:4461
	; [CONFIRMED] 15 insn(s) executed; cut out of the PROBABLE region 431F-4571 by apply_coverage
	; --split [executed in 3 scenarios]
	ld a, [wKeyboardCharLo]
	ld hl, $DE80
	ld d, a
	farcall TextBuf_AppendChar
	or a, a
	jr nz, .l4483
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	jr .l4493

.l4483 ; 67:4483
	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 431F-4571 by apply_coverage --split
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a

.l4493 ; 67:4493
	; [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 431F-4571 by apply_coverage
	; --split [executed in 3 scenarios]
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $01
	jr c, .l44A9
	farcall Kbd_HideMarkerSprite
	jp .l453B

.l44A9 ; 67:44A9
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 431F-4571 by apply_coverage --split
	farcall Kbd_ShowMarkerSprite
	jp .l453B

.l44B2 ; 67:44B2
	; [CONFIRMED] 76 insn(s) executed; cut out of the PROBABLE region 431F-4571 by apply_coverage
	; --split [executed in 1 scenarios]
	ld hl, $DE80
	farcall TextBuf_DeleteLast
	or a, a
	jr nz, .l4523
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0039
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $01
	jr c, .l44E3
	farcall Kbd_HideMarkerSprite
	jr .l453B
.l44E3 ; 67:44E3
	farcall Kbd_ShowMarkerSprite
	jr .l453B
.l44EB ; 67:44EB
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $01
	jr nc, .l450A
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	jr .l4556
.l450A ; 67:450A
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	call PhoneKeypad_StoreResult
	ld a, $01
	ld [wRam_C27C], a
	ret
.l4523 ; 67:4523
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	call PhoneKeypad_StoreResult
	xor a, a
	ld [wRam_C27C], a
	ret
.l453B ; 67:453B
	ld d, $20
	ld e, $10
	ld hl, $DE80
	farcall TextEntry_UpdateCursorSprite
	ld a, $03
	ld hl, $DE83
	call PhoneKeypad_PrintText
	call PhoneKeypad_UploadTextTiles
	call PhoneKeypad_UpdateFullFlag
.l4556 ; 67:4556
	jp PhoneKeypad_Loop

PhoneKeypad_StoreResult:: ; 67:4559
	ld hl, $DE80
	ld a, [wRam_C27D]
	or a, a
	jr nz, .l4567
	ld de, $DEDD
	jr .l456A
.l4567 ; 67:4567
	ld de, $DEEE
.l456A ; 67:456A
	farcall TextEntry_CopyText
	ret

PhoneKeypad_UpdateStoredFlag:: ; 67:4571
Function_67_4571::
	; [HYPOTHESIS] function with no found entry (no call/jp/table word/far pointer/ld r16 to $4571
	; anywhere in the ROM); linear decode is legal ($4571-$4593), all direct targets are known code
	; starts, tests [$C27D] and [$C278] bits $08/$10 and sets [$C27E]=0/1; ends with ret. Sits after
	; a ret between PROBABLE/CONFIRMED functions of the same style
	ld a, [wRam_C27D]
	or a, a
	jr nz, .l4580
	ld a, [wSettingsFieldMask]
	and a, $08
	jr nz, .l458D
	jr .l4587
.l4580 ; 67:4580
	ld a, [wSettingsFieldMask]
	and a, $10
	jr nz, .l458D
.l4587 ; 67:4587
	ld a, $00
	ld [wRam_C27E], a
	ret
.l458D ; 67:458D
	ld a, $01
	ld [wRam_C27E], a
	ret

PhoneKeypad_UpdateFullFlag:: ; 67:4593
	; [CONFIRMED] 285 insn(s) reached by static flow only; seeds: exec x285; min discovery hops 3;
	; entered by call from 67:4553 (PROBABLE code) | 7 insn(s) executed; cut out of the PROBABLE
	; region 4593-486D by apply_coverage --split [executed in 3 scenarios]
	ld hl, $DE80
	farcall TextBuf_GetFree
	or a, a
	jr z, .l45A5
	ld a, $00
	ld [wRam_C27E], a
	ret

.l45A5 ; 67:45A5
	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4593-486D by apply_coverage --split
	ld a, $01
	ld [wRam_C27E], a
	ret

PhoneKeypad_UpdateNonEmptyFlag:: ; 67:45AB
	; [CONFIRMED] 275 insn(s) executed; cut out of the PROBABLE region 4593-486D by apply_coverage
	; --split [executed in 1 scenarios] (part of region $45AB-$486D)
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $01
	jr nc, .l45BE
	ld a, $00
	ld [wRam_C27E], a
	ret
.l45BE ; 67:45BE
	ld a, $01
	ld [wRam_C27E], a
	ret

PhoneKeypad_BuildTextMap:: ; 67:45C4
	ld hl, $D044
	ld de, $0000
	ld bc, $020C
	farcall Tilemap_FillAscendingWithAttr
	ret

PhoneKeypad_PrintText:: ; 67:45D4
	push hl
	push af
	ld de, $FFFF
	ld hl, $0204
	ld bc, $020C
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hRam_FFBA], a
	ld a, $03
	ldh [hRam_FFBB], a
	ld a, $15
	ldh [hTextY], a
	ld a, $20
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $10
	ldh [hRam_FFC0], a
	ld a, $20
	ldh [hRam_FFC1], a
	ld a, $00
	ldh [hRam_FFC2], a
	ld a, $20
	ldh [hRam_FFC3], a
	ld a, $80
	ldh [hRam_FFC4], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hRam_FFC6], a
	ld a, $0C
	ldh [hRam_FFC7], a
	pop af
	pop hl
	ld a, $03
	call TextEngine_Run
	ret

PhoneKeypad_UploadTextTiles:: ; 67:4621
	ld de, $9000
	ld hl, $0204
	ld bc, $020C
	farcall TileCanvas_UploadRect
	ret
