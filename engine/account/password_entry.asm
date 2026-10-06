; engine/account/password_entry.asm
; bank 68, $5D00-$61F7 (1271 bytes); pinned by layout.link
; password entry screen, validity check and intro page

SECTION "engine/account/password_entry", ROMX

Account_PasswordEntryScreen:: ; 68:5D00
	; [CONFIRMED] 297 insn(s); 297 executed (in up to 7/18 scenarios) (part of region $5A36-$5D2F)
	ld [wPasswordEntry_Variant], a
	call Account_PasswordEntry_Setup
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0009
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	call Account_PasswordEntry_InputLoop
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	ld a, [wPasswordEntry_Result]
	ret

Function_68_5D2F:: ; 68:5D2F
	; [HYPOTHESIS] complete ret-terminated function (54 insn) between proven code; entry not proven
	; [verifier: no entry proven (no caller, no valid table word, never executed): decode chain
	; alone is not proof -> HYPOTHESIS]
	ret

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
	ld hl, sSettingsPassword
	ld de, wRam_C28F
	call DecodeXorA5
	ld hl, wRam_C28F
	ld de, wAcctPasswordEntry
	call CompareString
	or a, a
	jr z, .l5D7E
	xor a, a
	ld [wRam_C279], a
	ld a, [wSettingsFieldMask]
	ld b, a
	ld a, $04
	xor a, $FF
	and a, b
	ld [wSettingsFieldMask], a
.l5D7E ; 68:5D7E
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

Account_PasswordEntry_Setup:: ; 68:5D9C
Function_68_5D9C::
	; [CONFIRMED] 86 insn(s); 86 executed (in up to 7/18 scenarios); entry proven: target of an
	; executed call/far call
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	xor a, a
	ld [wPasswordEntry_Result], a
	ld hl, wTextEntryBuf
	ld b, $09
	farcall TextBuf_Init
	ld hl, wTextEntryBuf
	ld de, wAcctPasswordEntry
	call TextEntry_InsertString
	call Account_PasswordEntry_UpdateOkState
	ld a, [wPasswordEntry_Variant]
	or a, a
	jr nz, .l5DCD
.l5DCD ; 68:5DCD
	ld de, $8801
	ld hl, Gfx_Kbd_T4_Tiles8800Vb1
	ld a, BANK(Gfx_Kbd_T4_Tiles8800Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_Kbd_T4_Tiles8C00Vb1
	ld a, BANK(Gfx_Kbd_T4_Tiles8C00Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_Account_PasswordEntry_Tiles9000Vb1
	ld a, BANK(Gfx_Account_PasswordEntry_Tiles9000Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_Account_PasswordEntry_Tiles9400Vb1
	ld a, BANK(Gfx_Account_PasswordEntry_Tiles9400Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_SharedEntryUi_Bg
	ld a, BANK(Palette_SharedEntryUi_Bg)
	farcall Palette_LoadToBuffer
	ld a, [wPasswordEntry_Variant]
	ld hl, Account_PasswordEntryMaps
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0514
	ld de, wScreenTileMap
	ld a, $5D
	farcall Tilemap_CopyRectAndAttr
	ld a, $03
	ld hl, wTextEntryBuf + $03
	call Account_Password_PrintField
	call Account_Password_UploadTextTiles
	call Account_Password_BuildTextMap
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld a, $04
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
	call Account_PasswordIsValid
	or a, a
	jr z, .l5E85
	ret
.l5E85 ; 68:5E85
	farcall Kbd_ShowMarkerSprite
	farcall Sprite_UpdateAll
	ret

; ---- words $5E92-$5E9A (8 bytes) [PROBABLE] 4 words $5000,$50C8,$5190,$5258 (stride $C8) read with `ld hl,$5E92 ... ld a,[hli] ; ld h,[hl] ; ld l,a` at 68:5E29 and used as HL of the far call with a=$5D (68:5E3C, bc=$0514, de=$D000): pointers into BANK 5D data, NOT into bank 68 code [verifier: retyped ptrtable->words (the generator emitted `dw Label_68_5000`/`Label_68_50C8`, false references to bank-68 code); range trimmed from 5E92-5E9C by classify_g2, the 5th word $78FA was the operand of `ld a,[$C278]` at 5E9A]

Account_PasswordEntryMaps:: ; 68:5E92
Table_68_5E92::
	dw $5000, $50C8, $5190, $5258

Account_PasswordEntry_OkStateFromMask:: ; 68:5E9A
Function_68_5E9A::
	; [HYPOTHESIS] 8-insn routine ld a,[$C278] ; and 4 ; ... ld [$C27E],a ; ret ; call $5FE1 ; ld
	; [$C27E],a ; ret; the operand bytes `fa 78 c2` at 5E9A show the mapper's 5th table word ($78FA)
	; was never a word (the 4 real words 5E92-5E9A have stride $C8); entry not proven [verifier: no
	; caller/table word -> HYPOTHESIS]
	ld a, [wSettingsFieldMask]
	and a, $04
	jr nz, .l5EA7
	ld a, $00
	ld [wPasswordEntry_OkFlag], a
	ret
.l5EA7 ; 68:5EA7
	call Account_PasswordIsValid
	ld [wPasswordEntry_OkFlag], a
	ret

Account_PasswordEntry_UpdateOkState:: ; 68:5EAE
Function_68_5EAE::
	; [CONFIRMED] 22 insn(s); 22 executed (in up to 7/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, wTextEntryBuf
	farcall TextBuf_GetFree
	or a, a
	jr z, .l5EC0
	ld a, $00
	ld [wPasswordEntry_OkFlag], a
	ret
.l5EC0 ; 68:5EC0
	call Account_PasswordIsValid
	ld [wPasswordEntry_OkFlag], a
	ret

Account_PasswordEntry_InputLoop:: ; 68:5EC7
	farcall Sprite_UpdateAll
	ld a, [wPasswordEntry_OkFlag]
	ld c, a
	farcall Kbd_Run
	cp a, $01
	jr z, .l5EEC
	cp a, $02
	jr z, .l5F36
	cp a, $07
	jp z, .l5F68
	cp a, $08
	jp z, .l5FA2

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jpcc at 68:5EE6 (executed)
	jp .l5FDE

.l5EEC ; 68:5EEC
	; [CONFIRMED] 129 insn(s); 129 executed (in up to 7/18 scenarios)
	ld a, [wKeyboardCharLo]
	ld hl, wTextEntryBuf
	ld d, a
	farcall TextBuf_AppendChar
	or a, a
	jr nz, .l5F0E
	play_sfx SFX_CHAR_ENTERED
	jr .l5F1E
.l5F0E ; 68:5F0E
	play_sfx SFX_REJECT
.l5F1E ; 68:5F1E
	call Account_PasswordIsValid
	or a, a
	jr z, .l5F2D
	farcall Kbd_HideMarkerSprite
	jp .l5FC3
.l5F2D ; 68:5F2D
	farcall Kbd_ShowMarkerSprite
	jp .l5FC3
.l5F36 ; 68:5F36
	ld hl, wTextEntryBuf
	farcall TextBuf_DeleteLast
	or a, a
	jr nz, .l5FA2
	play_sfx SFX_CHAR_ERASED
	call Account_PasswordIsValid
	or a, a
	jr z, .l5F60
	farcall Kbd_HideMarkerSprite
	jr .l5FC3
.l5F60 ; 68:5F60
	farcall Kbd_ShowMarkerSprite
	jr .l5FC3
.l5F68 ; 68:5F68
	call Account_PasswordIsValid
	or a, a
	jr nz, .l5F80
	play_sfx SFX_REJECT
	jr .l5FDE
.l5F80 ; 68:5F80
	play_sfx SFX_CONFIRM
	ld hl, wTextEntryBuf
	ld de, wAcctPasswordEntry
	farcall TextEntry_CopyText
	ld a, $01
	ld [wPasswordEntry_Result], a
	ret
.l5FA2 ; 68:5FA2
	play_sfx SFX_CANCEL
	ld hl, wTextEntryBuf
	ld de, wAcctPasswordEntry
	farcall TextEntry_CopyText
	xor a, a
	ld [wPasswordEntry_Result], a
	ret
.l5FC3 ; 68:5FC3
	ld d, $38
	ld e, $10
	ld hl, wTextEntryBuf
	farcall TextEntry_UpdateCursorSprite
	ld a, $03
	ld hl, wTextEntryBuf + $03
	call Account_Password_PrintField
	call Account_Password_UploadTextTiles
	call Account_PasswordEntry_UpdateOkState
.l5FDE ; 68:5FDE
	jp Account_PasswordEntry_InputLoop

Account_PasswordIsValid:: ; 68:5FE1
	ld hl, wTextEntryBuf
	farcall TextBuf_GetLength
	cp a, $04
	jp c, .l604E
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [hPasswordEntry_HasDigit], a
	ldh [hPasswordEntry_HasLetter], a
	ld hl, wTextEntryBuf + $03
.loop ; 68:6004
	ld a, [hli]
	or a, a
	jr z, .l602E
	cp a, $30
	jr c, .loop
	cp a, $3A
	jr c, .l6022
	cp a, $41
	jr c, .loop
	cp a, $5B
	jr c, .l6028
	cp a, $61
	jr c, .loop
	cp a, $7B
	jr c, .l6028

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 68:601E (executed)
	jr .loop

.l6022 ; 68:6022
	; [CONFIRMED] 284 insn(s); 284 executed (in up to 7/18 scenarios) (part of region $6022-$6308)
	ld a, $01
	ldh [hPasswordEntry_HasDigit], a
	jr .loop
.l6028 ; 68:6028
	ld a, $01
	ldh [hPasswordEntry_HasLetter], a
	jr .loop
.l602E ; 68:602E
	ld hl, hPasswordEntry_HasDigit
	ld a, [hli]
	or a, a
	jr z, .l6045
	ld a, [hl]
	or a, a
	jr z, .l6045
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, $01
	ret
.l6045 ; 68:6045
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
.l604E ; 68:604E
	xor a, a
	ret

Account_Password_BuildTextMap:: ; 68:6050
	ld hl, wScreenTileMap + $47
	ld de, $0000
	ld bc, $0206
	farcall Tilemap_FillAscendingWithAttr
	ret

Account_Password_PrintField:: ; 68:6060
	push hl
	push af
	ld de, $FFFF
	ld hl, $0207
	ld bc, $0206
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
	ret

Account_Password_UploadTextTiles:: ; 68:60AB
	ld de, $9000
	ld hl, $0207
	ld bc, $0206
	farcall TileCanvas_UploadRect
	ret

Account_PasswordIntroPage:: ; 68:60BB
	call Account_PasswordIntro_Draw
	farcall Palette_FadeInFromWhite
.loop ; 68:60C4
	call VBlank_WaitAndService
	farcall Joypad_Update
	ldh a, [hJoyPressedRepeat]
	bit PADB_A, a
	jr nz, .l60D9
	bit PADB_B, a
	jr nz, .l60ED
	jr .loop
.l60D9 ; 68:60D9
	play_sfx SFX_CONFIRM
	ld a, $01
	jr .l6100
.l60ED ; 68:60ED
	play_sfx SFX_CANCEL
	xor a, a
	jr .l6100
.l6100 ; 68:6100
	push af
	farcall Palette_FadeOutToWhite
	pop af
	ret

Account_PasswordIntro_Draw:: ; 68:6109
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	ld de, $9001
	ld hl, Gfx_Account_PasswordIntro_Tiles9000Vb1
	ld a, BANK(Gfx_Account_PasswordIntro_Tiles9000Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_Account_PasswordIntro_Tiles9400Vb1
	ld a, BANK(Gfx_Account_PasswordIntro_Tiles9400Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_SharedEntryUi_Bg
	ld a, BANK(Palette_SharedEntryUi_Bg)
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_Account_PasswordIntro
	ld a, BANK(Tilemap_Account_PasswordIntro)
	farcall Tilemap_CopyRectAndAttr
	call Account_PasswordIntro_PrintMessage
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ret

Account_PasswordIntro_PrintMessage:: ; 68:6168
	ld a, $02
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
