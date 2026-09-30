; engine/account/login_id_entry.asm
; bank 68, $5296-$571D (1159 bytes); pinned by layout.link
; login ID entry screen and intro page

SECTION "engine/account/login_id_entry", ROMX

; ---- code $5296-$52B2 (28 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 3/18 scenarios); entry proven: target of an executed call/far call

Account_LoginIdEntryScreen:: ; 68:5296
Function_68_5296::
	call Account_LoginIdEntry_Setup
	farcall Palette_FadeInFromWhite
	call Account_LoginIdEntry_InputLoop
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	ld a, [wRam_C27C]
	ret

; ---- code $52B2-$531A (104 bytes) [HYPOTHESIS] complete ret-terminated function (51 insn): SRAM enable/bank-1 select, copies with call $14EA / $1509 and clears a flag bit in [$C278] (xor $FF/and); the routine at 5739 is its twin; entry not proven [verifier: no entry proven (no caller, no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS]

Function_68_52B2:: ; 68:52B2
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
	ld hl, $B066
	ld de, $C28F
	call DecodeXorA5
	ld hl, $C28F
	ld de, $DEA0
	call CompareString
	or a, a
	jr z, Label_68_52FC
	ld a, [wSettingsFieldMask]
	ld b, a
	ld a, $01
	xor a, $FF
	and a, b
	ld [wSettingsFieldMask], a

Label_68_52FC:: ; 68:52FC
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

; ---- code $531A-$5404 (234 bytes) [CONFIRMED] 74 insn(s); 74 executed (in up to 3/18 scenarios); entry proven: target of an executed call/far call

Account_LoginIdEntry_Setup:: ; 68:531A
Function_68_531A::
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Function_00_09B6
	xor a, a
	ld [wRam_C27C], a
	ld hl, $DE80
	ld b, $0A
	farcall TextBuf_Init
	ld hl, $DE80
	ld de, $DEA1
	call TextEntry_InsertString
	call Account_LoginIdEntry_UpdateOkState
	ld de, $8801
	ld hl, Data_5E_4000
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, Data_5E_4400
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_5E_4800
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_5E_4C00
	ld a, $5E
	ld b, $97
	ld c, $10
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, Data_5E_4D00
	ld a, $5E
	farcall Palette_LoadToBuffer
	ld bc, $0514
	ld de, $D000
	ld hl, Data_5E_4D40
	ld a, $5E
	farcall Function_00_08EA
	ld a, $03
	ld hl, $DE83
	call Account_LoginId_PrintField
	call Account_LoginId_UploadTextTiles
	call Account_LoginId_BuildTextMap
	ldh a, [rLCDC]
	call Function_00_082C
	ld a, $00
	ld b, $02
	farcall Kbd_Open
	ld hl, $DA00
	ld de, $4D30
	ld a, $5F
	ld b, $81
	farcall Function_00_0A82
	ld d, $38
	ld e, $10
	ld hl, $DE80
	farcall TextEntry_UpdateCursorSprite
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $09
	jr c, Label_68_53F7
	ret

Label_68_53F7:: ; 68:53F7
	farcall Kbd_ShowMarkerSprite
	farcall Function_00_0956
	ret

; ---- code $5404-$5417 (19 bytes) [HYPOTHESIS] complete function: [$C278] bit0 -> [$C27D] = 0/1, ret; twin of 58E8-58FB (bit1 -> [$C27E]); entry not proven [verifier: no entry proven (no caller, no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS]

Function_68_5404:: ; 68:5404
	ld a, [wSettingsFieldMask]
	and a, $01
	jr nz, Label_68_5411
	ld a, $00
	ld [wRam_C27D], a
	ret

Label_68_5411:: ; 68:5411
	ld a, $01
	ld [wRam_C27D], a
	ret

; ---- code $5417-$5451 (58 bytes) [CONFIRMED] 22 insn(s); 22 executed (in up to 3/18 scenarios); entry proven: target of an executed call/far call

Account_LoginIdEntry_UpdateOkState:: ; 68:5417
Function_68_5417::
	ld hl, $DE80
	farcall TextBuf_GetFree
	or a, a
	jr z, Label_68_5429
	ld a, $00
	ld [wRam_C27D], a
	ret

Label_68_5429:: ; 68:5429
	ld a, $01
	ld [wRam_C27D], a
	ret

Account_LoginIdEntry_InputLoop:: ; 68:542F
	farcall Function_00_0956
	ld a, [wRam_C27D]
	ld c, a
	farcall Kbd_Run
	cp a, $01
	jr z, Label_68_5454
	cp a, $02
	jr z, Label_68_54A5
	cp a, $07
	jp z, Label_68_54DE
	cp a, $08
	jp z, Label_68_5516

; ---- code $5451-$5454 (3 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jpcc at 68:544E (executed)
	jp Label_68_5549

; ---- code $5454-$54CE (122 bytes) [CONFIRMED] 47 insn(s); 47 executed (in up to 3/18 scenarios)

Label_68_5454:: ; 68:5454
	ld a, [wKeyboardCharLo]
	ld hl, $DE80
	ld d, a
	farcall TextBuf_AppendChar
	or a, a
	jr nz, Label_68_5476
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	jr Label_68_5486

Label_68_5476:: ; 68:5476
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a

Label_68_5486:: ; 68:5486
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $09
	jr c, Label_68_549C
	farcall Kbd_HideMarkerSprite
	jp Label_68_552E

Label_68_549C:: ; 68:549C
	farcall Kbd_ShowMarkerSprite
	jp Label_68_552E

Label_68_54A5:: ; 68:54A5
	ld hl, $DE80
	farcall TextBuf_DeleteLast
	or a, a
	jr nz, Label_68_5516
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0039
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $09
	jr c, Label_68_54D6

; ---- code $54CE-$54D6 (8 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 68:54CC (executed)
	farcall Kbd_HideMarkerSprite
	jr Label_68_552E

; ---- code $54D6-$571D (583 bytes) [CONFIRMED] 239 insn(s); 239 executed (in up to 3/18 scenarios) (part of region $54D6-$5739)

Label_68_54D6:: ; 68:54D6
	farcall Kbd_ShowMarkerSprite
	jr Label_68_552E

Label_68_54DE:: ; 68:54DE
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $09
	jr nc, Label_68_54FD
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	jr Label_68_5549

Label_68_54FD:: ; 68:54FD
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	call Account_CommitLoginId
	ld a, $01
	ld [wRam_C27C], a
	ret

Label_68_5516:: ; 68:5516
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	call Account_CommitLoginId
	xor a, a
	ld [wRam_C27C], a
	ret

Label_68_552E:: ; 68:552E
	ld d, $38
	ld e, $10
	ld hl, $DE80
	farcall TextEntry_UpdateCursorSprite
	ld a, $03
	ld hl, $DE83
	call Account_LoginId_PrintField
	call Account_LoginId_UploadTextTiles
	call Account_LoginIdEntry_UpdateOkState

Label_68_5549:: ; 68:5549
	jp Account_LoginIdEntry_InputLoop

Account_CommitLoginId:: ; 68:554C
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $67
	ld [wAcctLoginId], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld hl, $DE80
	ld de, $DEA1
	farcall TextEntry_CopyText
	ret

Account_LoginId_BuildTextMap:: ; 68:5574
	ld hl, $D047
	ld de, $0000
	ld bc, $0207
	farcall Tilemap_FillAscendingWithAttr
	ret

Account_LoginId_PrintField:: ; 68:5584
	push hl
	push af
	ld de, $FFFF
	ld hl, $0207
	ld bc, $0207
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hRam_FFBA], a
	ld a, $03
	ldh [hRam_FFBB], a
	ld a, $15
	ldh [hTextY], a
	ld a, $38
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $10
	ldh [hRam_FFC0], a
	ld a, $38
	ldh [hRam_FFC1], a
	ld a, $00
	ldh [hRam_FFC2], a
	ld a, $20
	ldh [hRam_FFC3], a
	ld a, $70
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
	call Function_00_0ED3
	ret

Account_LoginId_UploadTextTiles:: ; 68:55D1
	ld de, $9000
	ld hl, $0207
	ld bc, $0207
	farcall TileCanvas_UploadRect
	ret

Account_LoginIdIntroPage:: ; 68:55E1
	call Account_LoginIdIntro_Draw
	farcall Palette_FadeInFromWhite

Label_68_55EA:: ; 68:55EA
	call Function_00_044B
	farcall Joypad_Update
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, Label_68_55FF
	bit 1, a
	jr nz, Label_68_5613
	jr Label_68_55EA

Label_68_55FF:: ; 68:55FF
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, $01
	jr Label_68_5626

Label_68_5613:: ; 68:5613
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	xor a, a
	jr Label_68_5626

Label_68_5626:: ; 68:5626
	push af
	farcall Palette_FadeOutToWhite
	pop af
	ret

Account_LoginIdIntro_Draw:: ; 68:562F
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Function_00_09B6
	ld de, $9001
	ld hl, Data_5E_4E10
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_5E_5210
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, Data_5E_4D00
	ld a, $5E
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, $5510
	ld a, $5E
	farcall Function_00_08EA
	call Account_LoginIdIntro_PrintMessage
	ldh a, [rLCDC]
	call Function_00_082C
	ret

Account_LoginIdIntro_PrintMessage:: ; 68:568E
	ld a, $00
	farcall Function_00_153D
	push hl
	push af
	ld de, $FFFF
	ld hl, $0701
	ld bc, $0812
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hRam_FFBA], a
	ld a, $03
	ldh [hRam_FFBB], a
	ld a, $38
	ldh [hTextY], a
	ld a, $08
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $38
	ldh [hRam_FFC0], a
	ld a, $08
	ldh [hRam_FFC1], a
	ld a, $00
	ldh [hRam_FFC2], a
	ld a, $78
	ldh [hRam_FFC3], a
	ld a, $98
	ldh [hRam_FFC4], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hRam_FFC6], a
	ld a, $0C
	ldh [hRam_FFC7], a
	pop af
	pop hl
	call Function_00_0ED3
	ld de, $9000
	ld hl, $0701
	ld bc, $0712
	farcall TileCanvas_UploadRect
	ld de, $8800
	ld hl, $0E01
	ld bc, $0112
	farcall TileCanvas_UploadRect
	ld hl, $D0E1
	ld bc, $0712
	ld de, $0000
	farcall Tilemap_FillAscendingWithAttr
	ld hl, $D1C1
	ld bc, $0112
	ld de, $0080
	farcall Tilemap_FillAscendingWithAttr
	ret
