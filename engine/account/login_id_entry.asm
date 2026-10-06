; engine/account/login_id_entry.asm
; bank 68, $5296-$571D (1159 bytes); pinned by layout.link
; login ID entry screen and intro page

SECTION "engine/account/login_id_entry", ROMX

Account_LoginIdEntryScreen:: ; 68:5296
Function_68_5296::
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 3/18 scenarios); entry proven: target of an
	; executed call/far call
	call Account_LoginIdEntry_Setup
	farcall Palette_FadeInFromWhite
	call Account_LoginIdEntry_InputLoop
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	ld a, [wLoginIdEntry_Result]
	ret

Account_LoginId_ClearFlagIfChanged:: ; 68:52B2
Function_68_52B2::
	; [HYPOTHESIS] complete ret-terminated function (51 insn): SRAM enable/bank-1 select, copies
	; with call $14EA / $1509 and clears a flag bit in [$C278] (xor $FF/and); the routine at 5739 is
	; its twin; entry not proven [verifier: no entry proven (no caller, no valid table word, never
	; executed): decode chain alone is not proof -> HYPOTHESIS]
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
	ld hl, sSettingsLoginId
	ld de, wRam_C28F
	call DecodeXorA5
	ld hl, wRam_C28F
	ld de, wAcctLoginId
	call CompareString
	or a, a
	jr z, .l52FC
	ld a, [wSettingsFieldMask]
	ld b, a
	ld a, $01
	xor a, $FF
	and a, b
	ld [wSettingsFieldMask], a
.l52FC ; 68:52FC
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

Account_LoginIdEntry_Setup:: ; 68:531A
Function_68_531A::
	; [CONFIRMED] 74 insn(s); 74 executed (in up to 3/18 scenarios); entry proven: target of an
	; executed call/far call
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	xor a, a
	ld [wLoginIdEntry_Result], a
	ld hl, wTextEntryBuf
	ld b, $0A
	farcall TextBuf_Init
	ld hl, wTextEntryBuf
	ld de, wAcctLoginId + $01
	call TextEntry_InsertString
	call Account_LoginIdEntry_UpdateOkState
	ld de, $8801
	ld hl, Data_5E_4000
	ld a, BANK(Data_5E_4000)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Data_5E_4400
	ld a, BANK(Data_5E_4400)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_Account_LoginIdEntry_Tiles9000Vb1
	ld a, BANK(Gfx_Account_LoginIdEntry_Tiles9000Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_Account_LoginIdEntry_Tiles9400Vb1
	ld a, BANK(Gfx_Account_LoginIdEntry_Tiles9400Vb1)
	ld b, $97
	ld c, $10
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Data_5E_4D00
	ld a, BANK(Data_5E_4D00)
	farcall Palette_LoadToBuffer
	ld bc, $0514
	ld de, wScreenTileMap
	ld hl, Tilemap_Account_LoginIdEntry
	ld a, BANK(Tilemap_Account_LoginIdEntry)
	farcall Tilemap_CopyRectAndAttr
	ld a, $03
	ld hl, wTextEntryBuf + $03
	call Account_LoginId_PrintField
	call Account_LoginId_UploadTextTiles
	call Account_LoginId_BuildTextMap
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld a, $00
	ld b, $02
	farcall Kbd_Open
	ld hl, wSpriteSlot0
	ld de, Kbd_ObjTable_Entry14
	ld a, BANK(Kbd_ObjTable_Entry14)
	ld b, $81
	farcall Sprite_InitSlot
	ld d, $38
	ld e, $10
	ld hl, wTextEntryBuf
	farcall TextEntry_UpdateCursorSprite
	ld hl, wTextEntryBuf
	farcall TextBuf_GetLength
	cp a, $09
	jr c, .l53F7
	ret
.l53F7 ; 68:53F7
	farcall Kbd_ShowMarkerSprite
	farcall Sprite_UpdateAll
	ret

Account_LoginIdEntry_OkStateFromMask:: ; 68:5404
Function_68_5404::
	; [HYPOTHESIS] complete function: [$C278] bit0 -> [$C27D] = 0/1, ret; twin of 58E8-58FB (bit1 ->
	; [$C27E]); entry not proven [verifier: no entry proven (no caller, no valid table word, never
	; executed): decode chain alone is not proof -> HYPOTHESIS]
	ld a, [wSettingsFieldMask]
	and a, $01
	jr nz, .l5411
	ld a, $00
	ld [wLoginIdEntry_OkFlag], a
	ret
.l5411 ; 68:5411
	ld a, $01
	ld [wLoginIdEntry_OkFlag], a
	ret

Account_LoginIdEntry_UpdateOkState:: ; 68:5417
Function_68_5417::
	; [CONFIRMED] 22 insn(s); 22 executed (in up to 3/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, wTextEntryBuf
	farcall TextBuf_GetFree
	or a, a
	jr z, .l5429
	ld a, $00
	ld [wLoginIdEntry_OkFlag], a
	ret
.l5429 ; 68:5429
	ld a, $01
	ld [wLoginIdEntry_OkFlag], a
	ret

Account_LoginIdEntry_InputLoop:: ; 68:542F
	farcall Sprite_UpdateAll
	ld a, [wLoginIdEntry_OkFlag]
	ld c, a
	farcall Kbd_Run
	cp a, $01
	jr z, .l5454
	cp a, $02
	jr z, .l54A5
	cp a, $07
	jp z, .l54DE
	cp a, $08
	jp z, .l5516

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jpcc at 68:544E (executed)
	jp .l5549

.l5454 ; 68:5454
	; [CONFIRMED] 47 insn(s); 47 executed (in up to 3/18 scenarios)
	ld a, [wKeyboardCharLo]
	ld hl, wTextEntryBuf
	ld d, a
	farcall TextBuf_AppendChar
	or a, a
	jr nz, .l5476
	play_sfx SFX_CHAR_ENTERED
	jr .l5486
.l5476 ; 68:5476
	play_sfx SFX_REJECT
.l5486 ; 68:5486
	ld hl, wTextEntryBuf
	farcall TextBuf_GetLength
	cp a, $09
	jr c, .l549C
	farcall Kbd_HideMarkerSprite
	jp .l552E
.l549C ; 68:549C
	farcall Kbd_ShowMarkerSprite
	jp .l552E
.l54A5 ; 68:54A5
	ld hl, wTextEntryBuf
	farcall TextBuf_DeleteLast
	or a, a
	jr nz, .l5516
	play_sfx SFX_CHAR_ERASED
	ld hl, wTextEntryBuf
	farcall TextBuf_GetLength
	cp a, $09
	jr c, .l54D6

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 68:54CC (executed)
	farcall Kbd_HideMarkerSprite
	jr .l552E

.l54D6 ; 68:54D6
	; [CONFIRMED] 239 insn(s); 239 executed (in up to 3/18 scenarios) (part of region $54D6-$5739)
	farcall Kbd_ShowMarkerSprite
	jr .l552E
.l54DE ; 68:54DE
	ld hl, wTextEntryBuf
	farcall TextBuf_GetLength
	cp a, $09
	jr nc, .l54FD
	play_sfx SFX_REJECT
	jr .l5549
.l54FD ; 68:54FD
	play_sfx SFX_CONFIRM
	call Account_CommitLoginId
	ld a, $01
	ld [wLoginIdEntry_Result], a
	ret
.l5516 ; 68:5516
	play_sfx SFX_CANCEL
	call Account_CommitLoginId
	xor a, a
	ld [wLoginIdEntry_Result], a
	ret
.l552E ; 68:552E
	ld d, $38
	ld e, $10
	ld hl, wTextEntryBuf
	farcall TextEntry_UpdateCursorSprite
	ld a, $03
	ld hl, wTextEntryBuf + $03
	call Account_LoginId_PrintField
	call Account_LoginId_UploadTextTiles
	call Account_LoginIdEntry_UpdateOkState
.l5549 ; 68:5549
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
	ld hl, wTextEntryBuf
	ld de, wAcctLoginId + $01
	farcall TextEntry_CopyText
	ret

Account_LoginId_BuildTextMap:: ; 68:5574
	ld hl, wScreenTileMap + $47
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
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $15
	ldh [hTextY], a
	ld a, $38
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $10
	ldh [hRam_FFC0], a
	ld a, $38
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextBox_LineStartXHi], a
	ld a, $20
	ldh [hTextBox_MaxLineY], a
	ld a, $70
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hTextBox_LineAdvance], a
	ld a, $0C
	ldh [hRam_FFC7], a
	pop af
	pop hl
	ld a, $03
	call TextEngine_Run
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
.loop ; 68:55EA
	call VBlank_WaitAndService
	farcall Joypad_Update
	ldh a, [hJoyPressedRepeat]
	bit PADB_A, a
	jr nz, .l55FF
	bit PADB_B, a
	jr nz, .l5613
	jr .loop
.l55FF ; 68:55FF
	play_sfx SFX_CONFIRM
	ld a, $01
	jr .l5626
.l5613 ; 68:5613
	play_sfx SFX_CANCEL
	xor a, a
	jr .l5626
.l5626 ; 68:5626
	push af
	farcall Palette_FadeOutToWhite
	pop af
	ret

Account_LoginIdIntro_Draw:: ; 68:562F
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	ld de, $9001
	ld hl, Gfx_Account_LoginIdIntro_Tiles9000Vb1
	ld a, BANK(Gfx_Account_LoginIdIntro_Tiles9000Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_Account_LoginIdIntro_Tiles9400Vb1
	ld a, BANK(Gfx_Account_LoginIdIntro_Tiles9400Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Data_5E_4D00
	ld a, BANK(Data_5E_4D00)
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, $5510
	ld a, $5E
	farcall Tilemap_CopyRectAndAttr
	call Account_LoginIdIntro_PrintMessage
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ret

Account_LoginIdIntro_PrintMessage:: ; 68:568E
	ld a, $00
	farcall PromptText_Load
	push hl
	push af
	ld de, $FFFF
	ld hl, $0701
	ld bc, $0812
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $38
	ldh [hTextY], a
	ld a, $08
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $38
	ldh [hRam_FFC0], a
	ld a, $08
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextBox_LineStartXHi], a
	ld a, $78
	ldh [hTextBox_MaxLineY], a
	ld a, $98
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hTextBox_LineAdvance], a
	ld a, $0C
	ldh [hRam_FFC7], a
	pop af
	pop hl
	call TextEngine_Run
	ld de, $9000
	ld hl, $0701
	ld bc, $0712
	farcall TileCanvas_UploadRect
	ld de, $8800
	ld hl, $0E01
	ld bc, $0112
	farcall TileCanvas_UploadRect
	ld hl, wScreenTileMap + $E1
	ld bc, $0712
	ld de, $0000
	farcall Tilemap_FillAscendingWithAttr
	ld hl, wScreenTileMap + $1C1
	ld bc, $0112
	ld de, $0080
	farcall Tilemap_FillAscendingWithAttr
	ret
