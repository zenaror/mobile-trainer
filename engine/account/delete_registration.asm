; engine/account/delete_registration.asm
; bank 68, $7951-$7D8D (1084 bytes); pinned by layout.link
; delete-registration flow

SECTION "engine/account/delete_registration", ROMX

Registration_DeleteFlow:: ; 68:7951
Function_68_7951::
	; [CONFIRMED] 26 insn(s); 26 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $08
	farcall Notice_ShowPage
	or a, a
	jr z, .l798F
.l795C ; 68:795C
	ld a, $09
	farcall Notice_ShowPage
	or a, a
	jr z, Registration_DeleteFlow
.l7967 ; 68:7967
	xor a, a
	call Registration_DeleteConfirmPage
	or a, a
	jr z, .l795C
	cp a, $02
	jr z, .l7990
	ld a, $01
	call Registration_DeleteConfirmPage
	or a, a
	jr z, .l7967
	cp a, $02
	jr z, .l7990
	farcall Registration_DeleteExecute
	or a, a
	jr z, .l7999
	ld a, $0B
	farcall Notice_ShowPage
.l798F ; 68:798F
	ret

.l7990 ; 68:7990
	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1;
	; entered by jrcc from 68:7970 (executed) | 3 insn(s) executed; cut out of the PROBABLE region
	; 7990-799A by apply_coverage --split [executed in 7 scenarios]
	ld a, $0A
	farcall Notice_ShowPage
	ret

.l7999 ; 68:7999
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7990-799A by apply_coverage --split
	ret

Registration_DeleteConfirmPage:: ; 68:799A
Function_68_799A::
	; [CONFIRMED] 105 insn(s); 105 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld [wDeleteConfirm_Variant], a
	call Registration_DeleteConfirm_Setup
	farcall Palette_FadeInFromWhite
	call Registration_DeleteConfirm_InputLoop
	push af
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	pop af
	ret

Registration_DeleteConfirm_Setup:: ; 68:79B8
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	ld a, $01
	ld [wDeleteConfirm_Cursor], a
	ld a, [wDeleteConfirm_Variant]
	or a, a
	jr nz, .l7A0A
	ld de, $9001
	ld hl, Gfx_Registration_DeleteConfirm_Tiles9000Vb1
	ld a, BANK(Gfx_Registration_DeleteConfirm_Tiles9000Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_Registration_DeleteConfirm_Tiles9400Vb1
	ld a, BANK(Gfx_Registration_DeleteConfirm_Tiles9400Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_Registration_DeleteConfirm_71_66C8
	ld a, BANK(Tilemap_Registration_DeleteConfirm_71_66C8)
	farcall Tilemap_CopyRectAndAttr
	jr .l7A3F
.l7A0A ; 68:7A0A
	ld de, $9001
	ld hl, $59C0
	ld a, $71
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_Registration_Delete_Tiles9400Vb1
	ld a, BANK(Gfx_Registration_Delete_Tiles9400Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_Registration_DeleteConfirm_71_6998
	ld a, BANK(Tilemap_Registration_DeleteConfirm_71_6998)
	farcall Tilemap_CopyRectAndAttr
.l7A3F ; 68:7A3F
	ld de, $8001
	ld hl, Gfx_SharedPanels_Vram8000Vb1
	ld a, BANK(Gfx_SharedPanels_Vram8000Vb1)
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_Registration_Delete_Bg
	ld a, BANK(Palette_Registration_Delete_Bg)
	farcall Palette_LoadToBuffer
	ld bc, $0018
	ld de, wPaletteBufObj + $28
	ld hl, Palette_SharedPanels_BgObj + $10 ; 5F:4CE0
	ld a, BANK(Palette_SharedPanels_BgObj)
	farcall Palette_LoadToBuffer
	call Registration_DeleteConfirm_PrintMessage
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld hl, wSpriteSlot0
	ld de, ConfirmPages_ObjTable
	ld a, BANK(ConfirmPages_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	call Registration_DeleteConfirm_UpdateCursor
	ret

Registration_DeleteConfirm_InputLoop:: ; 68:7A8F
	farcall Sprite_UpdateAll
	farcall Joypad_Update
	call VBlank_WaitAndService
	ldh a, [hJoyPressedRepeat]
	bit PADB_A, a
	jr nz, .l7AB2
	bit PADB_B, a
	jr nz, .l7ACE
	bit PADB_LEFT, a
	jr nz, .l7AE0
	bit PADB_RIGHT, a
	jr nz, .l7AE0
	jr Registration_DeleteConfirm_InputLoop
.l7AB2 ; 68:7AB2
	play_sfx SFX_CONFIRM
	ld a, [wDeleteConfirm_Cursor]
	or a, a
	jr nz, .l7ACB
	ld a, $01
	ret

.l7ACB ; 68:7ACB
	; [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1;
	; entered by jrcc from 68:7AC6 (executed) [executed in 3 scenarios]
	ld a, $02
	ret
.l7ACE ; 68:7ACE
	play_sfx SFX_CANCEL
	xor a, a
	ret

.l7AE0 ; 68:7AE0
	; [CONFIRMED] 30 insn(s); 30 executed (in up to 1/18 scenarios)
	play_sfx SFX_CURSOR_MOVE
	ld a, [wDeleteConfirm_Cursor]
	ld b, $01
	xor a, b
	ld [wDeleteConfirm_Cursor], a
	call Registration_DeleteConfirm_UpdateCursor
	jr .l7AFE
.l7AFE ; 68:7AFE
	jp Registration_DeleteConfirm_InputLoop

Registration_DeleteConfirm_UpdateCursor:: ; 68:7B01
	ld a, [wDeleteConfirm_Cursor]
	add a, a
	ld hl, Registration_DeleteCursorPositions
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, wSpriteSlot0
	call Sprite_SetPosition
	ret

; ---- data $7B19-$7B1D (4 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Registration_DeleteCursorPositions:: ; 68:7B19
Data_68_7B19::
	db $28, $30, $58, $30

Registration_DeleteConfirm_PrintMessage:: ; 68:7B1D
Function_68_7B1D::
	; [CONFIRMED] 119 insn(s); 119 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld de, $FFFF
	ld hl, $0901
	ld bc, $0612
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $48
	ldh [hTextY], a
	ld a, $08
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $48
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
	ld a, [wDeleteConfirm_Variant]
	or a, a
	jr nz, .l7B70
	ld a, $06
	farcall PromptText_Load
	jr .l7B78
.l7B70 ; 68:7B70
	ld a, $07
	farcall PromptText_Load
.l7B78 ; 68:7B78
	call TextEngine_Run
	ld de, $9000
	ld hl, $0901
	ld bc, $0612
	farcall TileCanvas_UploadRect
	ld hl, wScreenTileMap + $121
	ld bc, $0612
	ld de, $0000
	farcall Tilemap_FillAscendingWithAttr
	ret

Registration_DeleteExecute:: ; 68:7B9A
	call Registration_DeleteExecute_Setup
	farcall Palette_FadeInFromWhite
	call Registration_DeleteExecute_RunState
	farcall Palette_FadeOutToWhite
	ld a, [wDeleteExecute_Result]
	ret

Registration_DeleteExecute_Setup:: ; 68:7BB0
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	xor a, a
	ld [wDeleteExecute_Result], a
	ld [wDeleteExecute_State], a
	ld de, $8801
	ld hl, $6180
	ld a, $71
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_Registration_DeleteExecute_Tiles9000Vb1
	ld a, BANK(Gfx_Registration_DeleteExecute_Tiles9000Vb1)
	ld b, $97
	ld c, $10
	farcall Gfx_StartHDMAWithService
	ld de, $8000
	ld hl, $6140
	ld a, $71
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_Registration_Delete_Bg
	ld a, BANK(Palette_Registration_Delete_Bg)
	farcall Palette_LoadToBuffer
	ld bc, $0008
	ld de, wPaletteBufObj
	ld hl, Palette_Registration_Delete_Obj
	ld a, BANK(Palette_Registration_Delete_Obj)
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_Registration_DeleteExecute
	ld a, BANK(Tilemap_Registration_DeleteExecute)
	farcall Tilemap_CopyRectAndAttr
	call Registration_DeleteExecute_PrintMessage
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld hl, wSpriteSlot0
	ld de, Registration_DeleteExecute_ObjTable
	ld a, BANK(Registration_DeleteExecute_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1C44
	ld hl, wSpriteSlot0
	call Sprite_SetPosition
	ret

Registration_DeleteExecute_RunState:: ; 68:7C52
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	ld a, [wDeleteExecute_State]
	add a, a
	add a, $6B
	ld l, a
	ld a, $7C
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- words $7C6B-$7C71 (6 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [retyped data->words by classify_g2: every word is an instruction start of a code region of this bank (jump/dispatch table)]

Registration_DeleteExecute_StateTable:: ; 68:7C6B
Table_68_7C6B::
	dw $7C71, $7C86, $7CBD

	; [CONFIRMED] 50 insn(s); 50 executed (in up to 1/18 scenarios)
	call Config_ClearSramMirror
	ld de, wMobileAdapterType
	ld hl, $0068
	ld a, $02
	call MobileAPI
	ld a, $01
	ld [wDeleteExecute_State], a
	jr Registration_DeleteExecute_RunState

	ld a, [wTimerEnable]
	bit 1, a
	jp nz, .l7CE8
	bit 0, a
	jp nz, Registration_DeleteExecute_RunState
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
	ld c, $C0
	ld hl, sConfigImage
	ld de, $0000
	ld a, $04
	call MobileAPI
	ld a, $02
	ld [wDeleteExecute_State], a
	jp Registration_DeleteExecute_RunState

	ld a, [wTimerEnable]
	bit 1, a
	jp nz, .l7CE8
	bit 0, a
	jp nz, Registration_DeleteExecute_RunState
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
	call Sram_WipeAllBanks
	ld a, $01
	ld [wDeleteExecute_Result], a
	ret

.l7CE8 ; 68:7CE8
	; [PROBABLE] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 1;
	; entered by jpcc from 68:7C8B (executed)
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	farcall Mobile_SaveLastResult
	farcall Palette_FadeOutToWhite
	farcall Mobile_ShowLastError
	ld a, $36
	call MobileAPI
	ld a, $0A
	farcall Notice_ShowPage
	xor a, a
	ld [wDeleteExecute_Result], a
	ret

Registration_DeleteExecute_PrintMessage:: ; 68:7D1C
Function_68_7D1C::
	; [CONFIRMED] 46 insn(s); 46 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $03
	farcall PromptText_Load
	push hl
	push af
	ld de, $FFFF
	ld hl, $0B01
	ld bc, $0612
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $58
	ldh [hTextY], a
	ld a, $08
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $58
	ldh [hRam_FFC0], a
	ld a, $08
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextBox_LineStartXHi], a
	ld a, $88
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
	ld hl, $0B01
	ld bc, $0612
	farcall TileCanvas_UploadRect
	ld hl, wScreenTileMap + $161
	ld bc, $0612
	ld de, $0000
	farcall Tilemap_FillAscendingWithAttr
	ret
