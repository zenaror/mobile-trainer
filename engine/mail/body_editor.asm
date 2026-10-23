; engine/mail/body_editor.asm
; bank 2D, $4722-$5AC0 (5022 bytes); pinned by layout.link
; mail body editor with kana keyboard, text-tile buffer helpers

SECTION "engine/mail/body_editor", ROMX

MailBody_Edit:: ; 2D:4722

	; [CONFIRMED] 39 insn(s); 39 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call MailBody_SetupScreen
	call MailBody_ProbeLastRow
	ld d, $07
.step_down_loop ; 2D:474A
	push de
	call MailBody_CursorDownStep
	pop de
	dec d
	jr nz, .step_down_loop
	ld d, $18
.step_right_loop ; 2D:4754
	push de
	call MailBody_CursorRightStep
	pop de
	dec d
	jr nz, .step_right_loop
.update_and_poll ; 2D:475C
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	call MailBody_PlaceCursorSprites
	ldh a, [hJoyPressed]
	and a, PADF_A
	jp z, .check_cancel_button
	call MailBody_KeyboardLoop

.check_keyboard_result ; 2D:477A
	; [CONFIRMED] 107 insn(s) reached by static flow only; seeds: exec x107; min discovery hops 0;
	; fall-through of the call at 2D:4777 (executed) | 2 insn(s) executed; cut out of the PROBABLE
	; region 477A-485F by apply_coverage --split [executed in 3 scenarios]
	cp a, $06
	jp nz, .check_keyboard_result_04

	; [PROBABLE] 58 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 477A-485F by apply_coverage --split
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailComposeMode]
	dec a
	jr nz, .check_second_mode
	ld de, $0200
	jr .show_selected_dialog
.check_second_mode ; 2D:4791
	dec a
	jr nz, .use_dialog_020f
	ld de, $0211
	jr .show_selected_dialog
.use_dialog_020f ; 2D:4799
	ld de, $020F
.show_selected_dialog ; 2D:479C
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push de
	pop de
	farcall Dialog_Show
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	pop bc
	dec a
	jp nz, .reopen_keyboard
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailComposeMode]
	dec a
	jr nz, .l47E0
	jr .fade_out_return_zero
.l47E0 ; 2D:47E0
	dec a
	jr nz, .fade_out_return_zero
	jr .fade_out_return_zero
.fade_out_return_zero ; 2D:47E5
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

.check_keyboard_result_04 ; 2D:47F3
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 477A-485F by apply_coverage
	; --split [executed in 3 scenarios]
	cp a, $04
	jr nz, .check_keyboard_result_05

	; [PROBABLE] 38 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 477A-485F by apply_coverage --split
	push bc
	ld de, $0202
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push de
	pop de
	farcall Dialog_Show
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	pop bc
	dec a
	jr nz, .reopen_keyboard
	farcall MailDraft_SaveToSram
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ld a, $01
	ret

.check_keyboard_result_05 ; 2D:4847
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 477A-485F by apply_coverage
	; --split [executed in 3 scenarios]
	cp a, $05
	jp nz, .update_and_poll

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 477A-485F by apply_coverage --split
	farcall Palette_FadeOutToWhite
	ld a, $B0
	ldh [rWX], a
	farcall MailBody_ViewScreen
	jp MailBody_Edit

	; [PROBABLE] fall-through of the preceding PROBABLE code region (ld [hli],a ; ld b,a ends
	; without a terminator): jp $475C
	jp .update_and_poll

.reopen_keyboard ; 2D:4862
	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 2;
	; entered by jpcc from 2D:47CF (PROBABLE code)
	call MailBody_KeyboardLoop
	jp .check_keyboard_result

.check_cancel_button ; 2D:4868
	; [CONFIRMED] 51 insn(s); 51 executed (in up to 2/18 scenarios)
	ldh a, [hJoyPressed]
	and a, PADF_B
	jr z, .handle_direction_buttons
	push bc
	push de
	play_sfx SFX_CANCEL
	pop de
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret
.handle_direction_buttons ; 2D:4894
	ldh a, [hJoyPressedRepeat]
	and a, PADF_LEFT
	call nz, MailBody_CursorLeft
	ldh a, [hJoyPressedRepeat]
	and a, PADF_RIGHT
	call nz, MailBody_CursorRight
	ldh a, [hJoyPressedRepeat]
	and a, PADF_UP
	call nz, MailBody_CursorUp
	ldh a, [hJoyPressedRepeat]
	and a, PADF_DOWN
	call nz, MailBody_CursorDown
	jp .update_and_poll

MailBody_CursorLeft:: ; 2D:48B3
	push bc
	push de
	play_sfx SFX_TEXT_CURSOR_MOVE
	pop de
	pop bc
	inc c
	dec c
	jr nz, .decrement_column
	inc b
	dec b
	ret z

	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0;
	; fall-through of the retcc at 2D:48CD (executed) | 4 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 48CE-48DA by apply_coverage --split
	dec b
	call MailBody_GetCharPtr
	ld c, e
	ret

.decrement_column ; 2D:48D4
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 48CE-48DA by apply_coverage
	; --split [executed in 1 scenarios]
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

MailBody_CursorRight:: ; 2D:48DA

	; [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push de
	play_sfx SFX_TEXT_CURSOR_MOVE
	pop de
	pop bc

MailBody_CursorRightStep:: ; 2D:48EE
	ld a, b
	cp a, $07
	jr nz, .check_column_zero

	; [PROBABLE] 16 insn(s) reached by static flow only; seeds: exec x16; min discovery hops 0;
	; fall-through of the jrcc at 2D:48F1 (executed)
	ld a, c
	cp a, $0C
	ret z
	cp a, $0B
	jr nz, .check_column_zero
	call MailBody_GetCharPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $00
	ret z
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

.check_column_zero ; 2D:490E
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 2/18 scenarios)
	inc c
	dec c
	jr nz, .check_char_before_advance
	call MailBody_GetCharPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $00
	ret z

.check_char_before_advance ; 2D:491F
	; [CONFIRMED] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 0;
	; entered by jrcc from 2D:4910 (executed) | 5 insn(s) executed; cut out of the PROBABLE region
	; 491F-4942 by apply_coverage --split [executed in 2 scenarios]
	call MailBody_GetCharPtr
	cp a, $FF
	ret z
	cp a, $0D
	jr nz, .increment_column

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 491F-4942 by apply_coverage --split
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

.increment_column ; 2D:4931
	; [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 491F-4942 by apply_coverage
	; --split [executed in 2 scenarios]
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $0C
	cp a, c
	ret nz

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 491F-4942 by apply_coverage --split
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

MailBody_CursorUp:: ; 2D:4942

	; [CONFIRMED] 16 insn(s); 16 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push de
	play_sfx SFX_TEXT_CURSOR_MOVE
	pop de
	pop bc
	inc b
	dec b
	jr nz, .move_to_previous_row
	ret

.move_to_previous_row ; 2D:495B
	; [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1;
	; entered by jrcc from 2D:4958 (executed) | 6 insn(s) executed; cut out of the PROBABLE region
	; 495B-4968 by apply_coverage --split [executed in 1 scenarios]
	dec b
	call MailBody_GetCharPtr
	ld a, [wTextEditGoalColumn]
	ld c, a
	cp a, e
	jr c, .column_selected

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 495B-4968 by apply_coverage --split
	ld c, e

.column_selected ; 2D:4967
	; [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 495B-4968 by apply_coverage
	; --split [executed in 1 scenarios]
	ret

MailBody_CursorDown:: ; 2D:4968

	; [CONFIRMED] 21 insn(s); 21 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push de
	play_sfx SFX_TEXT_CURSOR_MOVE
	pop de
	pop bc

MailBody_CursorDownStep:: ; 2D:497C
	ld a, $07
	cp a, b
	ret z
	inc b
	call MailBody_GetRowPtr
	dec b
	ld a, d
	cp a, $FF
	ret z

	; [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 0;
	; fall-through of the retcc at 2D:4988 (executed) | 5 insn(s) executed; cut out of the PROBABLE
	; region 4989-499E by apply_coverage --split [executed in 1 scenarios]
	inc b
	ld a, [wTextEditGoalColumn]
	ld c, a
	cp a, e
	jr c, .column_selected

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4989-499E by apply_coverage --split
	ld c, e
	ld a, $07
	cp a, b
	ret nz
	ld a, [wTextEditGoalColumn]
	cp a, $0C
	ret nz
	ld c, a

.column_selected ; 2D:499D
	; [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 4989-499E by apply_coverage
	; --split [executed in 1 scenarios]
	ret

MailBody_SetupScreen:: ; 2D:499E

	; [CONFIRMED] 148 insn(s); 148 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	call TextTiles_ClearBuffers
	farcall LCDOff
	ld de, $9301
	ld hl, Gfx_MailBody_Tiles
	ld a, BANK(Gfx_MailBody_Tiles)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMA
	ld de, $9701
	ld hl, Gfx_MailBody_Tiles9700Vb1
	ld a, BANK(Gfx_MailBody_Tiles9700Vb1)
	ld b, $97
	ld c, $10
	farcall Gfx_StartHDMA
	ld de, $8000
	ld hl, Gfx_MailBody_ObjTiles
	ld a, BANK(Gfx_MailBody_ObjTiles)
	ld b, $94
	ld c, $2A
	farcall Gfx_StartHDMA
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, Palette_MailBody_Obj
	ld a, BANK(Palette_MailBody_Obj)
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_MailBody_Bg
	ld a, BANK(Palette_MailBody_Bg)
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_MailBody
	ld a, BANK(Tilemap_MailBody)
	farcall Tilemap_CopyRectAndAttr
	ld hl, wSpriteSlot1
	ld de, Table_TextCursor_ObjTables_Entry8
	ld a, BANK(Table_TextCursor_ObjTables_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1414
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld hl, wSpriteSlot2
	ld de, Table_TextCursor_ObjTables_Entry4
	ld a, BANK(Table_TextCursor_ObjTables_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1414
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	farcall LCDOn
	call TextTiles_UploadBuffers
	ld b, $00
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld de, $0008
	call MailBody_DrawRow
	ld b, $01
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $0C
	ld e, $08
	call MailBody_DrawRow
	ld b, $02
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $18
	ld e, $08
	call MailBody_DrawRow
	ld b, $03
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $24
	ld e, $08
	call MailBody_DrawRow
	ld b, $04
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $30
	ld e, $08
	call MailBody_DrawRow
	ld b, $05
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $3C
	ld e, $08
	call MailBody_DrawRow
	ld b, $06
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $48
	ld e, $08
	call MailBody_DrawRow
	ld b, $07
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $54
	ld e, $08
	call MailBody_DrawRow
	call TextTiles_UploadBuffers
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0005
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeInFromWhite
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	ld bc, $0000
	xor a, a
	ld [wTextEditGoalColumn], a
	ret

	; [HYPOTHESIS] push bc before the raw far-call site 4B2E; the previous region ends with ret so
	; 4B2D would be a function entry; no caller found
	push bc

	; [PROBABLE] 140 insn(s) reached by static flow only; seeds: site x140; min discovery hops 0;
	; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Stat_EnableScrollSplit
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	call TextTiles_ClearBuffers
	call TextTiles_UploadBuffers
	farcall LCDOff
	ld de, $9301
	ld hl, Gfx_MailBody_Tiles
	ld a, BANK(Gfx_MailBody_Tiles)
	ld b, $93
	ld c, $3C
	farcall Gfx_StartHDMAWithService
	ld de, $8000
	ld hl, Gfx_MailBody_ObjTiles
	ld a, BANK(Gfx_MailBody_ObjTiles)
	ld b, $94
	ld c, $2A
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, Palette_MailBody_Obj
	ld a, BANK(Palette_MailBody_Obj)
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_MailBody_Bg
	ld a, BANK(Palette_MailBody_Bg)
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_MailBody
	ld a, BANK(Tilemap_MailBody)
	farcall Tilemap_CopyRectAndAttr
	ld hl, wSpriteSlot1
	ld de, Table_TextCursor_ObjTables_Entry8
	ld a, BANK(Table_TextCursor_ObjTables_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1414
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld hl, wSpriteSlot2
	ld de, Table_TextCursor_ObjTables_Entry4
	ld a, BANK(Table_TextCursor_ObjTables_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1414
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call VBlank_WaitStartDI
	ld hl, wPaletteBufBg
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	ld a, $06
	ld b, $02
	ld a, $0A
	ld b, $00
	ld c, $01
	pop bc
	farcall LCDOn
	call TextTiles_UploadBuffers
	ld b, $00
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld de, $0008
	call MailBody_DrawRow
	ld b, $01
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $0C
	ld e, $08
	call MailBody_DrawRow
	ld b, $02
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $18
	ld e, $08
	call MailBody_DrawRow
	ld b, $03
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $24
	ld e, $08
	call MailBody_DrawRow
	ld b, $04
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $30
	ld e, $08
	call MailBody_DrawRow
	ld b, $05
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $3C
	ld e, $08
	call MailBody_DrawRow
	ld b, $06
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $48
	ld e, $08
	call MailBody_DrawRow
	ld b, $07
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $54
	ld e, $08
	call MailBody_DrawRow
	call TextTiles_UploadBuffers
	ld bc, $0000
	xor a, a
	ld [wTextEditGoalColumn], a
	pop bc
	ret

MailBody_PlaceCursorSprites:: ; 2D:4CA5

	; [CONFIRMED] 9 insn(s); 9 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	inc b
	inc c
	ld a, $0D
.accumulate_row_offset ; 2D:4CB0
	dec b
	jr z, .store_scroll_adjusted_y

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 2D:4CB1 (executed) [executed in 4 scenarios]
	add a, $0C
	jr .accumulate_row_offset

.store_scroll_adjusted_y ; 2D:4CB7
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 2/18 scenarios)
	ld d, a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, d
	sub a, e
	ld [wSpriteSlot1], a
	ld [wSpriteSlot2], a
	ld a, $08
.accumulate_column_offset ; 2D:4CC6
	dec c
	jr z, .store_cursor_x
	add a, $0C
	jr .accumulate_column_offset
.store_cursor_x ; 2D:4CCD
	ld [wSpriteSlot1 + $01], a
	ld [wSpriteSlot2 + $01], a
	pop bc
	ldh a, [hJoyHeld]
	cp a, $00
	ret z
	ret

	; [PROBABLE] compare chain push bc ; ld a,b ; cp 0 ; jp z,$4D04 ; cp 1 ; jp z,$4D24 ... cp 7 ;
	; jp z,$4DE4 followed by the default block at 4D04 (ld hl,$DA40 ; ld de,$6350 ; ld a,$29 ; ld
	; b,$81 ; call FarCall 00:0A82 ...): its 8 jp z targets land exactly on the starts of the 8
	; ten-byte holes below + 4D04 and each is followed by a raw far-call site; entry of the chain
	; not located
	push bc
	ld a, b
	cp a, $00
	jp z, .init_slot4_base_entry0
	cp a, $01
	jp z, .init_slot4_base_entry4
	cp a, $02
	jp z, .init_slot4_base_entry8
	cp a, $03
	jp z, .init_slot4_base_entry12
	cp a, $04
	jp z, .init_slot4_base_entry16
	cp a, $05
	jp z, .init_slot4_base_entry20
	cp a, $06
	jp z, .init_slot4_base_entry24
	cp a, $07
	jp z, .init_slot4_base_entry28
.init_slot4_base_entry0 ; 2D:4D04
	ld hl, wSpriteSlot4
	ld de, Table_MailBody_ObjectEntries
	ld a, BANK(Table_MailBody_ObjectEntries)
	ld b, $81

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: site x10; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	xor a, a
	ld [wSpriteSlots + 65], a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, $13
	sub a, e
	ld [wSpriteSlots + 64], a
	pop bc
	ret

.init_slot4_base_entry4 ; 2D:4D24
	; [PROBABLE] block target of the jp z chain at 2D:4CDA (ld hl,$DA40 ; ld de,$63x0 ; ld a,$29 ;
	; ld b,$81) that falls into the far-call site (call 00:0A82, init_object_from_table) right after
	ld hl, wSpriteSlot4
	ld de, Table_MailBody_ObjectEntries_Entry4
	ld a, BANK(Table_MailBody_ObjectEntries_Entry4)
	ld b, $81

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: site x10; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	xor a, a
	ld [wSpriteSlots + 65], a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, $1F
	sub a, e
	ld [wSpriteSlots + 64], a
	pop bc
	ret

.init_slot4_base_entry8 ; 2D:4D44
	; [PROBABLE] block target of the jp z chain at 2D:4CDA (ld hl,$DA40 ; ld de,$63x0 ; ld a,$29 ;
	; ld b,$81) that falls into the far-call site (call 00:0A82, init_object_from_table) right after
	ld hl, wSpriteSlot4
	ld de, Table_MailBody_ObjectEntries_Entry8
	ld a, BANK(Table_MailBody_ObjectEntries_Entry8)
	ld b, $81

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: site x10; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	xor a, a
	ld [wSpriteSlots + 65], a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, $2B
	sub a, e
	ld [wSpriteSlots + 64], a
	pop bc
	ret

.init_slot4_base_entry12 ; 2D:4D64
	; [PROBABLE] block target of the jp z chain at 2D:4CDA (ld hl,$DA40 ; ld de,$63x0 ; ld a,$29 ;
	; ld b,$81) that falls into the far-call site (call 00:0A82, init_object_from_table) right after
	ld hl, wSpriteSlot4
	ld de, Table_MailBody_ObjectEntries_Entry12
	ld a, BANK(Table_MailBody_ObjectEntries_Entry12)
	ld b, $81

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: site x10; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	xor a, a
	ld [wSpriteSlots + 65], a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, $37
	sub a, e
	ld [wSpriteSlots + 64], a
	pop bc
	ret

.init_slot4_base_entry16 ; 2D:4D84
	; [PROBABLE] block target of the jp z chain at 2D:4CDA (ld hl,$DA40 ; ld de,$63x0 ; ld a,$29 ;
	; ld b,$81) that falls into the far-call site (call 00:0A82, init_object_from_table) right after
	ld hl, wSpriteSlot4
	ld de, Table_MailBody_ObjectEntries_Entry16
	ld a, BANK(Table_MailBody_ObjectEntries_Entry16)
	ld b, $81

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: site x10; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	xor a, a
	ld [wSpriteSlots + 65], a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, $43
	sub a, e
	ld [wSpriteSlots + 64], a
	pop bc
	ret

.init_slot4_base_entry20 ; 2D:4DA4
	; [PROBABLE] block target of the jp z chain at 2D:4CDA (ld hl,$DA40 ; ld de,$63x0 ; ld a,$29 ;
	; ld b,$81) that falls into the far-call site (call 00:0A82, init_object_from_table) right after
	ld hl, wSpriteSlot4
	ld de, Table_MailBody_ObjectEntries_Entry20
	ld a, BANK(Table_MailBody_ObjectEntries_Entry20)
	ld b, $81

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: site x10; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	xor a, a
	ld [wSpriteSlots + 65], a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, $4F
	sub a, e
	ld [wSpriteSlots + 64], a
	pop bc
	ret

.init_slot4_base_entry24 ; 2D:4DC4
	; [PROBABLE] block target of the jp z chain at 2D:4CDA (ld hl,$DA40 ; ld de,$63x0 ; ld a,$29 ;
	; ld b,$81) that falls into the far-call site (call 00:0A82, init_object_from_table) right after
	ld hl, wSpriteSlot4
	ld de, Table_MailBody_ObjectEntries_Entry24
	ld a, BANK(Table_MailBody_ObjectEntries_Entry24)
	ld b, $81

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: site x10; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	xor a, a
	ld [wSpriteSlots + 65], a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, $5B
	sub a, e
	ld [wSpriteSlots + 64], a
	pop bc
	ret

.init_slot4_base_entry28 ; 2D:4DE4
	; [PROBABLE] block target of the jp z chain at 2D:4CDA (ld hl,$DA40 ; ld de,$63x0 ; ld a,$29 ;
	; ld b,$81) that falls into the far-call site (call 00:0A82, init_object_from_table) right after
	ld hl, wSpriteSlot4
	ld de, Table_MailBody_ObjectEntries_Entry28
	ld a, BANK(Table_MailBody_ObjectEntries_Entry28)
	ld b, $81

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: site x10; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	xor a, a
	ld [wSpriteSlots + 65], a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, $67
	sub a, e
	ld [wSpriteSlots + 64], a
	pop bc
	ret

	; [HYPOTHESIS] pop bc ; ret - epilogue after the last block of the 4CDA chain; no reference
	; found
	pop bc
	ret

TextTiles_ClearBuffers:: ; 2D:4E06

	; [CONFIRMED] 35 insn(s); 35 executed (in up to 7/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage2
	ld bc, $1000
.clear_stage2_loop ; 2D:4E12
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .clear_stage2_loop
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage3
	ld bc, $0780
.clear_stage3_loop ; 2D:4E25
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .clear_stage3_loop
	ret

MailBody_ClearBuffer:: ; 2D:4E2D
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wEditBodyBuf
	ld b, $C0
.clear_body_byte ; 2D:4E38
	xor a, a
	ld [hli], a
	dec b
	jr nz, .clear_body_byte
	xor a, a
	ld [rRAMG], a
	ret
MailBody_LocateCell:: ; 2D:4E42 [PROBABLE] mail-body row/cell locator; entry unproved
	; [PROBABLE] Domain role from pair editors; ABI in typing_2d_4e42_4e54_stack_scan.md.
	; [PROBABLE] WRAM1; ordinary completion clears RAMG, preserves helper AF/input BC; WRAM1 stays.
	; [PROBABLE] D400 two-byte cells; prior rows end at CR/12 cells; width precedes NUL.
	; [PROBABLE] RET4E72 skips POP BC: PC=saved entry BC; SP=entry SP, real return stays.
	; [HYPOTHESIS] Entry/caller domain/early-RET intent unproved; normal exit yields A/E/HL and BC.
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call MailBody_LocateCellInMappedWram
	push af
	xor a, a
	ld [rRAMG], a
	pop af
	pop bc
	ret
MailBody_LocateCellInMappedWram:: ; 2D:4E54 [PROBABLE] body locator; caller supplies WRAM mapping
	; [PROBABLE] E=distance, not row length; early RET targets saved BC; no bounds guarantee.
	push bc
	ld hl, wEditBodyBuf
	inc b
.advance_row_count ; 2D:4E59
	dec b
	jr z, .start_column_scan
	ld d, $0C
.scan_row_cells ; 2D:4E5E
	ld a, [hli]
	inc hl
	cp a, $0D
	jr z, .advance_row_count
	dec d
	jr z, .advance_row_count
	cp a, $00
	jr nz, .scan_row_cells
	ld a, $FF
	ld e, $FF
	ld hl, $FFFF
	ret
.start_column_scan ; 2D:4E73
	ld e, c
	inc c
.scan_column_cells ; 2D:4E75
	dec c
	jr z, .return_cell_distance
	ld a, [hl]
	cp a, $0D
	jr z, .return_cell_distance
	inc hl
	inc hl
	cp a, $00
	jr nz, .scan_column_cells
	dec hl
	dec hl
.return_cell_distance ; 2D:4E85
	ld a, e
	sub a, c
	ld c, a
	ld a, [hl]
	ld e, c
	pop bc
	ret

MailBody_GetCharPtr:: ; 2D:4E8C

	; [CONFIRMED] 21 insn(s); 21 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	call MailBody_GetRowPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $FF
	cp a, d
	jr z, .return_ff
	inc c
	ld a, [hl]
.seek_character_pair ; 2D:4E9D
	dec c
	jr z, .restore_bc_return
	inc hl
	inc hl
	ld a, [hl]
	cp a, $00
	jr z, .return_ff
	ld a, [hl]
	cp a, $0D
	jr z, .return_cr
	jr .seek_character_pair

	; [HYPOTHESIS] inc c ; dec c ; jr nz,$4EB4 - unreached alternative tail before the executed pop
	; bc ; ret at 4EB2 (same 4-byte pattern also at 6CCD)
	inc c
	dec c
	jr nz, .return_ff

.restore_bc_return ; 2D:4EB2
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)
	pop bc
	ret
.return_ff ; 2D:4EB4
	ld a, $FF
	ld d, $FF
	pop bc
	ret

.return_cr ; 2D:4EBA
	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1;
	; entered by jrcc from 2D:4EAA (executed) [executed in 3 scenarios]
	ld a, $0D
	ld d, $FF
	pop bc
	ret

MailBody_GetRowPtr:: ; 2D:4EC0

	; [CONFIRMED] 20 insn(s); 20 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wEditBodyBuf
	inc b
.start_row_scan ; 2D:4ECB
	ld d, $00
	ld e, $0C
	dec b
	jr z, .check_row_scan_result
.scan_row_cells ; 2D:4ED2
	ld d, $FF
	ld a, [hl]
	cp a, $00
	jr z, .check_row_scan_result
	inc hl
	inc hl
	cp a, $0D
	jr z, .start_row_scan
	dec e
	jr nz, .scan_row_cells

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 2D:4EE0 (executed) [executed in 4 scenarios]
	jr .start_row_scan

.check_row_scan_result ; 2D:4EE4
	; [CONFIRMED] 29 insn(s); 29 executed (in up to 2/18 scenarios)
	ld a, $FF
	cp a, d
	jr z, .clear_ramg_return
	ld e, $00
	push hl
.count_row_cells ; 2D:4EEC
	ld a, [hli]
	inc hl
	cp a, $00
	jr z, .restore_row_pointer
	cp a, $0D
	jr z, .restore_row_pointer
	inc e
	ld a, $0B
	cp a, e
	jr nz, .count_row_cells
.restore_row_pointer ; 2D:4EFC
	pop hl
.clear_ramg_return ; 2D:4EFD
	xor a, a
	ld [rRAMG], a
	pop bc
	ret

MailBody_ProbeLastRow:: ; 2D:4F03

	; [CONFIRMED] Entry/missing-row path probes row7: 45 natural hits in 10 scenarios.
	; A=1 when absent; remaining results stay PROBABLE below. Both callers ignore A.
	push bc
	ld b, $07
	call MailBody_GetRowPtr
	ld a, $FF
	cp a, d
	jr nz, .check_eleven_cells
	ld a, $01
	pop bc
	ret

.check_eleven_cells ; 2D:4F12
	; [PROBABLE] 19 insn(s) reached by static flow only; seeds: exec x19; min discovery hops 1;
	; entered by jrcc from 2D:4F0C (executed)
	ld a, $0B
	cp a, e
	jr nz, .return_zero
	ld b, $07
	ld c, $0B
	call MailBody_GetCharPtr
	inc d
	jr nz, .clear_ramg_return_ff
	xor a, a
	pop bc
	ret
.clear_ramg_return_ff ; 2D:4F24
	xor a, a
	ld [rRAMG], a
	ld a, $FF
	pop bc
	ret
.return_zero ; 2D:4F2C
	xor a, a
	pop bc
	ret

MailBody_DrawRow:: ; 2D:4F2F

	; [CONFIRMED] 51 insn(s); 51 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $18
	ld [wTextCellsLeft], a
.read_next_row_byte ; 2D:4F34
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .load_dotted_line_glyph
	cp a, $0D
	jr z, .draw_7f_for_cr
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .call_ascii_glyph_loader
	pop af
	push bc
	push de
	push hl
	push af
	ld a, [hli]
	ld l, a
	pop af
	ld h, a
	ld bc, wGlyphBufLeft
	ld de, wGlyphBufRight
	farcall Glyph_LoadWide
	pop hl
	pop de
	pop bc
	inc hl
	call MailBody_DrawRow_Glyph
	push bc
	push de
	push hl
	ld hl, wGlyphBufRight
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ld a, [wTextCellsLeft]
	dec a
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .load_dotted_line_glyph
	cp a, $01
	jr z, .load_dotted_line_glyph
	jr .read_next_row_byte

.call_ascii_glyph_loader ; 2D:4F8F
	; [PROBABLE] 32 insn(s) reached by static flow only; seeds: exec x32; min discovery hops 1;
	; entered by jrcc from 2D:4F4C (executed) | 19 insn(s) never executed in the traced runs; cut
	; out of the PROBABLE region 4F8F-4FCF by apply_coverage --split
	pop af
	push bc
	push de
	push hl
	ld b, a
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	call MailBody_DrawRow_Glyph
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .load_dotted_line_glyph
	cp a, $01
	jr z, .load_dotted_line_glyph
	jr .read_next_row_byte

.draw_7f_for_cr ; 2D:4FB4
	; [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 4F8F-4FCF by apply_coverage
	; --split [executed in 5 scenarios]
	push bc
	push de
	push hl
	ld b, $7F
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	call MailBody_DrawRow_Pad

.load_dotted_line_glyph ; 2D:4FCF
	; [CONFIRMED] 119 insn(s); 119 executed (in up to 5/18 scenarios)
	push bc
	push de
	push hl
	farcall Glyph_LoadDottedLine
	pop hl
	pop de
	pop bc
.pad_remaining_cells ; 2D:4FDB
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call MailBody_DrawRow_Pad
	jr .pad_remaining_cells

MailBody_DrawRow_Glyph:: ; 2D:4FEA
	push bc
	push de
	push hl
	ld hl, wGlyphBufLeft
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

MailBody_DrawRow_Pad:: ; 2D:4FFE
	push bc
	push de
	push hl
	ld b, $02
	ld c, $00
	ld hl, wGlyphBufLeft
	farcall Canvas_BlitGlyphNoRemap
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

TextTiles_UploadBuffers:: ; 2D:5016
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, wTileStage2
	ld de, $9000
	ld c, $3F
	call TextTiles_HdmaBlock
	ld hl, wTileStage2 + $400
	ld de, $9400
	ld c, $3F
	call TextTiles_HdmaBlock
	ld hl, wTileStage2 + $800
	ld de, $8800
	ld c, $3F
	call TextTiles_HdmaBlock
	ld hl, wTileStage2 + $C00
	ld de, $8C00
	ld c, $3F
	call TextTiles_HdmaBlock
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

TextTiles_HdmaBlock:: ; 2D:5054
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, rLY
.wait_ly_8f ; 2D:5063
	ld a, [de]
	cp a, $8F
	jr nz, .wait_ly_8f
	di
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wStatSplitLine]
	ldh [rLYC], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rSCY], a
	ld b, $91
.wait_ly_91 ; 2D:5081
	ld a, [de]
	cp a, b
	jr nz, .wait_ly_91
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ei
	ret

MailBody_GetRowFill:: ; 2D:508C
	push bc
	call MailBody_GetRowPtr
	ld b, $00
.count_row_cells ; 2D:5092
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	inc hl
	cp a, $0D
	jr z, .classify_cell_count
	cp a, $00
	jr z, .classify_cell_count
	inc b
	jr .count_row_cells
.classify_cell_count ; 2D:50A5
	ld d, $00
	ld a, b
	cp a, $00
	jr nz, .check_twelve_cells

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 2D:50AA (executed) [executed in 4 scenarios]
	ld d, $FF

.check_twelve_cells ; 2D:50AE
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 2/18 scenarios)
	cp a, $0C
	jr nc, .return_d_one
	pop bc
	ret

.return_d_one ; 2D:50B4
	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 2D:50B0 (executed) [executed in 4 scenarios]
	ld d, $01
	pop bc
	ret

MailBody_InsertChar:: ; 2D:50B8

	; [CONFIRMED] 7 insn(s); 7 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push de
	push bc
	ld b, $07
	ld c, $00
	call MailBody_GetRowPtr
	inc d
	jr z, .begin_char_insertion

	; [CONFIRMED] 38 insn(s) reached by static flow only; seeds: exec x38; min discovery hops 0;
	; fall-through of the jrcc at 2D:50C2 (executed) | 10 insn(s) executed; cut out of the PROBABLE
	; region 50C4-5102 by apply_coverage --split [executed in 1 scenarios]
	pop bc
	push bc
	ld c, $0B
.probe_row_column_0b ; 2D:50C8
	call MailBody_GetCharPtr
	inc d
	jr nz, .check_cr_or_row_eight
	ld a, e
	cp a, $0B
	jr z, .check_row_seven
	jr .begin_char_insertion

.check_row_seven ; 2D:50D5
	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 50C4-5102 by apply_coverage --split
	ld a, $07
	cp a, b
	jr nz, .play_reject_restore_return
	jr .begin_char_insertion

.check_cr_or_row_eight ; 2D:50DC
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 50C4-5102 by apply_coverage
	; --split [executed in 1 scenarios]
	cp a, $0D
	jr z, .play_reject_restore_return
	ld a, $08
	cp a, b
	jr z, .play_reject_restore_return
	inc b
	ld a, $08
	cp a, b
	jr nz, .probe_row_column_0b

.play_reject_restore_return ; 2D:50EB
	; [PROBABLE] 15 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 50C4-5102 by apply_coverage --split
	push bc
	push de
	play_sfx SFX_REJECT
	pop de
	pop bc
	pop bc
	pop de
	ret

.begin_char_insertion ; 2D:5102
	; [CONFIRMED] 92 insn(s); 92 executed (in up to 2/18 scenarios)
	push bc
	push de
	play_sfx SFX_CHAR_ENTERED
	pop de
	pop bc
	pop bc
	pop de
	push de
	push bc
	push bc
	ld hl, wSpriteSlot1
	ld de, Table_TextCursor_ObjTables_Entry12
	ld a, BANK(Table_TextCursor_ObjTables_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	call MailBody_PlaceCursorSprites
	ld d, $14
.wait_input_or_countdown ; 2D:5131
	push bc
	push de
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, PADF_A
	cp a, $00
	jr nz, .reset_repeat_restore_cursor
	ldh a, [hJoyHeld]
	and a, PADF_DPAD
	jr nz, .reset_repeat_restore_cursor
	dec d
	jr nz, .wait_input_or_countdown
.reset_repeat_restore_cursor ; 2D:5155
	farcall Joypad_ClearAndResetRepeat
	ld hl, wSpriteSlot1
	ld de, Table_TextCursor_ObjTables_Entry8
	ld a, BANK(Table_TextCursor_ObjTables_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	pop de
	push de
	call MailBody_GetCharPtr
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push de
	push hl
	ld de, wEditBodyBuf + $BE
	ld bc, wEditBodyBuf + $BC
.compare_shift_destination ; 2D:5181
	ld a, d
	cp a, h
	jr nz, .shift_pair_backward
	ld a, e
	cp a, l
	jr z, .store_inserted_pair
.shift_pair_backward ; 2D:5189
	ld a, [bc]
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [de], a
	dec bc
	dec bc
	dec de
	dec de
	jr .compare_shift_destination
.store_inserted_pair ; 2D:5195
	pop hl
	pop de
	pop bc
	ld a, d
	ld [hli], a
	ld a, e
	ld [hl], a
	xor a, a
	ld [rRAMG], a
	push bc
	call MailBody_RedrawFromRow
	pop bc
	ld a, b
	cp a, $07
	jr nz, .check_char_before_advance

	; [CONFIRMED] 16 insn(s) reached by static flow only; seeds: exec x16; min discovery hops 0;
	; fall-through of the jrcc at 2D:51A8 (executed) | 5 insn(s) executed; cut out of the PROBABLE
	; region 51AA-51C5 by apply_coverage --split [executed in 1 scenarios]
	ld a, c
	cp a, $0C
	ret z
	cp a, $0B
	jr nz, .check_char_before_advance

	; [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 51AA-51C5 by apply_coverage --split
	call MailBody_GetCharPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $00
	ret z
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

.check_char_before_advance ; 2D:51C5
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 2/18 scenarios)
	call MailBody_GetCharPtr
	cp a, $FF
	jr z, .cursor_advance_complete
	cp a, $0D
	jr nz, .increment_column

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2D:51CE (executed)
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	jr .cursor_advance_complete

.increment_column ; 2D:51D9
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $0C
	cp a, c
	jr nz, .cursor_advance_complete

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 2D:51E1 (executed) [executed in 4 scenarios]
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a

.cursor_advance_complete ; 2D:51EA
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)
	ret

MailBody_RedrawFromRow:: ; 2D:51EB
	ld c, $0B
.redraw_until_row_boundary ; 2D:51ED
	call MailBody_RedrawRow
	call MailBody_GetRowFill
	inc d
	jr z, .redraw_following_rows
	dec d
	jr z, .upload_buffers_return

	; [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 0;
	; fall-through of the jrcc at 2D:51F7 (executed) [executed in 4 scenarios]
	inc b
	ld a, b
	cp a, $08
	jr z, .upload_buffers_return
	jr .redraw_until_row_boundary
.redraw_following_rows ; 2D:5201
	inc b
	ld a, b
	cp a, $08
	jr z, .upload_buffers_return
	call MailBody_RedrawRow
	jr .redraw_following_rows

.upload_buffers_return ; 2D:520C
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 2/18 scenarios)
	call TextTiles_UploadBuffers
	ret

MailBody_RedrawRow:: ; 2D:5210
	push bc
	push bc
	call MailBody_GetRowPtr
	pop bc
	xor a, a
	inc b
.accumulate_row_tile_offset ; 2D:5218
	dec b
	jr z, .draw_at_row_offset

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 2D:5219 (executed) [executed in 4 scenarios]
	add a, $0C
	jr .accumulate_row_tile_offset

.draw_at_row_offset ; 2D:521F
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 2/18 scenarios)
	ld d, a
	ld b, $03
	ld c, $00
	ld e, $08
	call MailBody_DrawRow
	pop bc
	ret

MailBody_InsertNewline:: ; 2D:522B
	; [CONFIRMED] 168 insn(s) reached by static flow only; seeds: exec x168; min discovery hops 2;
	; entered by call from 2D:5761 (PROBABLE code) | 143 insn(s) executed; cut out of the PROBABLE
	; region 522B-535C by apply_coverage --split [executed in 1 scenarios]
	push de
	push bc
	ld b, $07
	ld c, $00
	call MailBody_GetRowPtr
	inc d
	jr z, .begin_newline_insertion
	pop bc
	push bc
	ld a, $07
	cp a, b
	jr z, .play_reject_return_ff
	ld a, [hl]
	cp a, $00
	jr z, .begin_newline_insertion
.play_reject_return_ff ; 2D:5243
	push bc
	push de
	play_sfx SFX_REJECT
	pop de
	pop bc
	pop bc
	pop de
	ld a, $FF
	ret
.begin_newline_insertion ; 2D:525C
	push bc
	push de
	play_sfx $003B
	pop de
	pop bc
	pop bc
	pop de
	push de
	call MailBody_GetCharPtr
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push de
	push hl
	ld de, wEditBodyBuf + $BE
	ld bc, wEditBodyBuf + $BC
.shift_character_pair_backward ; 2D:5286
	ld a, d
	cp a, h
	jr nz, .shift_pair_backward
	ld a, e
	cp a, l
	jr z, .store_0d_0a_pair
.shift_pair_backward ; 2D:528E
	ld a, [bc]
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [de], a
	dec bc
	dec bc
	dec de
	dec de
	jr .shift_character_pair_backward
.store_0d_0a_pair ; 2D:529A
	pop hl
	pop de
	pop bc
	ld a, $0D
	ld [hli], a
	ld a, $0A
	ld [hl], a
	xor a, a
	ld [rRAMG], a
	push bc
	ld b, $00
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld de, $0008
	call MailBody_DrawRow
	ld b, $01
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $0C
	ld e, $08
	call MailBody_DrawRow
	ld b, $02
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $18
	ld e, $08
	call MailBody_DrawRow
	ld b, $03
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $24
	ld e, $08
	call MailBody_DrawRow
	ld b, $04
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $30
	ld e, $08
	call MailBody_DrawRow
	ld b, $05
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $3C
	ld e, $08
	call MailBody_DrawRow
	ld b, $06
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $48
	ld e, $08
	call MailBody_DrawRow
	ld b, $07
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $54
	ld e, $08
	call MailBody_DrawRow
	call TextTiles_UploadBuffers
	pop bc
	ld a, b
	cp a, $07
	jr nz, .check_char_before_advance

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 522B-535C by apply_coverage --split
	ld a, c
	cp a, $0B
	jr z, .return_zero

.check_char_before_advance ; 2D:5335
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 522B-535C by apply_coverage
	; --split [executed in 5 scenarios]
	call MailBody_GetCharPtr
	cp a, $FF
	jr z, .return_zero
	cp a, $0D
	jr nz, .increment_column
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	jr .return_zero

.increment_column ; 2D:5349
	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 522B-535C by apply_coverage --split
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $0C
	cp a, c
	jr nz, .return_zero
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a

.return_zero ; 2D:535A
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 522B-535C by apply_coverage
	; --split [executed in 5 scenarios]
	xor a, a
	ret

MailBody_Backspace:: ; 2D:535C

	; [CONFIRMED] 30 insn(s); 30 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push de
	push bc
	push bc
	push de
	play_sfx SFX_CHAR_ERASED
	pop de
	pop bc
	push bc
	ld hl, wSpriteSlot1
	ld de, Table_TextCursor_ObjTables_Entry16
	ld a, BANK(Table_TextCursor_ObjTables_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	push bc
	dec b
	ld c, $0B
	call MailBody_GetCharPtr
	pop bc
	push bc
	inc c
	dec c
	jr nz, .decrement_preview_column

	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 2D:538F (executed) [executed in 2 scenarios]
	ld a, b
	cp a, $00
	jr z, .place_preview_cursor
	dec b
	ld c, e
	inc c

.decrement_preview_column ; 2D:5399
	; [CONFIRMED] 30 insn(s); 30 executed (in up to 1/18 scenarios)
	dec c
.place_preview_cursor ; 2D:539A
	call MailBody_PlaceCursorSprites
	pop bc
	ld d, $14
.wait_backspace_repeat ; 2D:53A0
	push bc
	push de
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, PADF_B
	cp a, $00
	jr nz, .reset_repeat_restore_cursor
	ldh a, [hJoyHeld]
	and a, PADF_DPAD
	jr nz, .reset_repeat_restore_cursor
	dec d
	jr nz, .wait_backspace_repeat
.reset_repeat_restore_cursor ; 2D:53C4
	farcall Joypad_ClearAndResetRepeat
	ld hl, wSpriteSlot1
	ld de, Table_TextCursor_ObjTables_Entry8
	ld a, BANK(Table_TextCursor_ObjTables_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	inc c
	dec c
	jr nz, .decrement_column

	; [CONFIRMED] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0;
	; fall-through of the jrcc at 2D:53DD (executed) [executed in 2 scenarios]
	inc b
	dec b
	jr z, .locate_pair_to_remove
	dec b
	call MailBody_GetCharPtr
	ld c, e
	jr .locate_pair_to_remove

.decrement_column ; 2D:53EA
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 1/18 scenarios)
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a
.locate_pair_to_remove ; 2D:53EF
	call MailBody_GetCharPtr
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push de
	push hl
	pop bc
	push hl
	inc bc
	inc bc
	ld e, $00
	ld a, [hl]
	cp a, $0D
	jr nz, .compare_shift_limit

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 2D:5405 (executed) [executed in 1 scenarios]
	ld e, $01

.compare_shift_limit ; 2D:5409
	; [CONFIRMED] 35 insn(s); 35 executed (in up to 1/18 scenarios)
	ld a, $BE
	cp a, l
	jr nz, .shift_pair_forward
	ld a, $D4
	cp a, h
	jr z, .zero_tail_pair
.shift_pair_forward ; 2D:5413
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
	inc bc
	jr .compare_shift_limit
.zero_tail_pair ; 2D:541B
	xor a, a
	ld [hli], a
	ld [hli], a
	ld a, e
	pop hl
	pop de
	pop bc
	ld e, a
	xor a, a
	ld [rRAMG], a
	push bc
	call MailBody_RedrawAfterBackspace
	pop bc
	ret

MailBody_RedrawAfterBackspace:: ; 2D:542D
	dec e
	jr z, .redraw_current_row
	ld c, $0B
.redraw_shifted_rows ; 2D:5432
	call MailBody_RedrawRow
	call MailBody_GetCharPtr
	ld a, e
	cp a, $0B
	jr nz, .check_row_fill

	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 2D:543B (executed) [executed in 2 scenarios]
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $0D
	jr z, .redraw_following_rows

.check_row_fill ; 2D:5448
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)
	call MailBody_GetRowFill
	inc d
	jr z, .upload_buffers_return
	dec d
	jr z, .upload_buffers_return

	; [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0;
	; fall-through of the jrcc at 2D:544F (executed) [executed in 1 scenarios]
	ld c, $0B
	inc b
	ld a, b
	cp a, $08
	jr z, .upload_buffers_return
	jr .redraw_shifted_rows
.redraw_current_row ; 2D:545B
	call MailBody_RedrawRow
.redraw_following_rows ; 2D:545E
	inc b
	ld a, b
	cp a, $08
	jr z, .upload_buffers_return
	call MailBody_RedrawRow
	jr .redraw_following_rows

.upload_buffers_return ; 2D:5469
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)
	call TextTiles_UploadBuffers
	ret

MailBody_ApplyDakuten:: ; 2D:546D
	; [CONFIRMED] 64 insn(s) reached by static flow only; seeds: exec x64; min discovery hops 1;
	; entered by call from 2D:5702 (PROBABLE code) | 50 insn(s) executed; cut out of the PROBABLE
	; region 546D-54D2 by apply_coverage --split [executed in 1 scenarios]
	call MailBody_GetCharPtr
	ld a, $00
	cp a, l
	jr nz, .scan_previous_pair
	ld a, $D4
	cp a, h
	jp z, .return_at_buffer_start
.scan_previous_pair ; 2D:547B
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, MailBody_DakutenKanaList
.match_dakuten_pair ; 2D:5487
	ld a, [de]
	inc de
	cp a, $00
	jr z, .clear_sram_flags_return
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, b
	jr nz, .next_candidate_pair
	ld a, [hl]
	cp a, c
	jr nz, .next_candidate_pair
	inc a
	ld [hl], a
	push bc
	push de
	play_sfx SFX_CHAR_ENTERED
	xor a, a
	ld [wKeyboardCharLo], a
	pop de
	pop bc
	pop hl
	pop bc
	ld a, c
	cp a, $00
	jr nz, .redraw_current_and_following

	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 546D-54D2 by apply_coverage --split
	dec b
	call MailBody_RedrawRow
	inc b
	push bc
	call MailBody_RedrawFromRow
	pop bc
	ret

.redraw_current_and_following ; 2D:54C6
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 546D-54D2 by apply_coverage
	; --split [executed in 1 scenarios]
	call MailBody_RedrawRow
	push bc
	call MailBody_RedrawFromRow
	pop bc
	ret
.next_candidate_pair ; 2D:54CF
	pop hl
	jr .match_dakuten_pair

	; [HYPOTHESIS] SRAM-disable epilogue xor a ; ldh [$F5],a ; ld [$0000],a ; pop bc ; ret (same 8
	; bytes at 54D2/55A1/5642); the previous region ends with an unconditional jr so no path reaches
	; it; no reference found
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.clear_sram_flags_return ; 2D:54DA
	; [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 2;
	; entered by jrcc from 2D:548B (PROBABLE code) [executed in 1 scenarios]
	push bc
	push de
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret
.return_at_buffer_start ; 2D:54E6
	push bc
	push de
	pop de
	pop bc
	ret

; ---- text $54EB-$553C (81 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailBody_DakutenKanaList:: ; 2D:54EB
	db "かきくけこさしすせそたちつてとはひふへほカキクケコサシスセソタチツテトハヒフヘホ", 0
POPC

	; [HYPOTHESIS] single ret between a text run and MailBody_ApplyDakutenU; no reference found
	ret

MailBody_ApplyDakutenU:: ; 2D:553D
	; [CONFIRMED] 62 insn(s) reached by static flow only; seeds: exec x62; min discovery hops 1;
	; entered by call from 2D:570C (PROBABLE code) | 48 insn(s) executed; cut out of the PROBABLE
	; region 553D-55A1 by apply_coverage --split [executed in 1 scenarios]
	call MailBody_GetCharPtr
	ld a, $00
	cp a, l
	jr nz, .scan_previous_pair
	ld a, $D4
	cp a, h
	jp z, .reject_at_buffer_start
.scan_previous_pair ; 2D:554B
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, Table_MailBody_ApplyDakutenU_LoopPairs
.read_u_table_pair ; 2D:5557
	ld a, [de]
	inc de
	cp a, $00
	jr z, .reject_clear_sram_flags
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, $83
	jr nz, .next_table_pair
	ld a, [hl]
	cp a, $45
	jr nz, .next_table_pair
	ld a, $94
	ld [hl], a
	push bc
	push de
	play_sfx SFX_CHAR_ENTERED
	pop de
	pop bc
	pop hl
	pop bc
	ld a, c
	cp a, $00
	jr nz, .redraw_current_and_following

	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 553D-55A1 by apply_coverage --split
	dec b
	call MailBody_RedrawRow
	inc b
	push bc
	call MailBody_RedrawFromRow
	pop bc
	ret

.redraw_current_and_following ; 2D:5595
	; [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 553D-55A1 by apply_coverage
	; --split [executed in 1 scenarios]
	call MailBody_RedrawRow
	push bc
	call MailBody_RedrawFromRow
	pop bc
	ret

.next_table_pair ; 2D:559E
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 553D-55A1 by apply_coverage --split
	pop hl
	jr .read_u_table_pair

	; [HYPOTHESIS] SRAM-disable epilogue xor a ; ldh [$F5],a ; ld [$0000],a ; pop bc ; ret (same 8
	; bytes at 54D2/55A1/5642); the previous region ends with an unconditional jr so no path reaches
	; it; no reference found
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.reject_clear_sram_flags ; 2D:55A9
	; [PROBABLE] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 2;
	; entered by jrcc from 2D:555B (PROBABLE code) | 17 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 55A9-55DA by apply_coverage --split
	push bc
	push de
	play_sfx SFX_REJECT
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.reject_at_buffer_start ; 2D:55C5
	; [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 55A9-55DA by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	push de
	play_sfx SFX_REJECT
	pop de
	pop bc
	ret

; ---- data $55DA-$55DF (5 bytes) [PROBABLE] 2-byte entries terminated by $00: 82 A4 82 A4 00 (Shift-JIS lead/trail pairs); read by the loop of MailBody_ApplyDakutenU (ld de,$55DA ; ld a,[de] ; inc de ; cp $00 ; jr z ...)
; kept as raw bytes: the bytes read as Shift-JIS/ASCII text, but the header does not say `text` (executed-read data of unknown content class, or unclassified), so not provably a string

Table_MailBody_ApplyDakutenU_LoopPairs:: ; 2D:55DA
	db $82, $A4, $82, $A4, $00

	; [HYPOTHESIS] single ret ($C9) after the terminator of Table_MailBody_ApplyDakutenU_LoopPairs; no reference found
	ret

MailBody_ApplyHandakuten:: ; 2D:55E0
	; [CONFIRMED] 63 insn(s) reached by static flow only; seeds: exec x63; min discovery hops 1;
	; entered by call from 2D:571F (PROBABLE code) | 4 insn(s) executed; cut out of the PROBABLE
	; region 55E0-5642 by apply_coverage --split [executed in 2 scenarios]
	call MailBody_GetCharPtr
	ld a, $00
	cp a, l
	jr nz, .scan_previous_pair

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 55E0-5642 by apply_coverage --split
	ld a, $D4
	cp a, h
	jp z, .reject_at_buffer_start

.scan_previous_pair ; 2D:55EE
	; [CONFIRMED] 42 insn(s) executed; cut out of the PROBABLE region 55E0-5642 by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, MailBody_HandakutenKanaList
.match_handakuten_pair ; 2D:55FA
	ld a, [de]
	inc de
	cp a, $00
	jr z, .reject_clear_sram_flags
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, b
	jr nz, .next_candidate_pair
	ld a, [hl]
	cp a, c
	jr nz, .next_candidate_pair
	inc a
	inc a
	ld [hl], a
	push bc
	push de
	play_sfx SFX_CHAR_ENTERED
	pop de
	pop bc
	pop hl
	pop bc
	ld a, c
	cp a, $00
	jr nz, .redraw_current_and_following

	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 55E0-5642 by apply_coverage --split
	dec b
	call MailBody_RedrawRow
	inc b
	push bc
	call MailBody_RedrawFromRow
	pop bc
	ret

.redraw_current_and_following ; 2D:5636
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 55E0-5642 by apply_coverage
	; --split [executed in 1 scenarios]
	call MailBody_RedrawRow
	push bc
	call MailBody_RedrawFromRow
	pop bc
	ret
.next_candidate_pair ; 2D:563F
	pop hl
	jr .match_handakuten_pair

	; [HYPOTHESIS] SRAM-disable epilogue xor a ; ldh [$F5],a ; ld [$0000],a ; pop bc ; ret (same 8
	; bytes at 54D2/55A1/5642); the previous region ends with an unconditional jr so no path reaches
	; it; no reference found
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.reject_clear_sram_flags ; 2D:564A
	; [CONFIRMED] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 2;
	; entered by jrcc from 2D:55FE (PROBABLE code) | 17 insn(s) executed; cut out of the PROBABLE
	; region 564A-567B by apply_coverage --split [executed in 1 scenarios]
	push bc
	push de
	play_sfx SFX_REJECT
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.reject_at_buffer_start ; 2D:5666
	; [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 564A-567B by apply_coverage --split
	push bc
	push de
	play_sfx SFX_REJECT
	pop de
	pop bc
	ret

; ---- text $567B-$5690 (21 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailBody_HandakutenKanaList:: ; 2D:567B
	db "はひふへほハヒフヘホ", 0
POPC

	; [HYPOTHESIS] single ret between a text run and MailBody_KeyboardLoop; no reference found
	ret

MailBody_KeyboardLoop:: ; 2D:5691

	; [CONFIRMED] 51 insn(s); 51 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, $06
	ld b, $00
	farcall Kbd_Open
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	pop bc
.run_keyboard ; 2D:56C6
	push bc
	call MailBody_PlaceCursorSprites
	farcall Sprite_UpdateAll
	ld b, $01
	ld c, $00
	farcall Kbd_Run
	pop bc
	cp a, $00
	jr z, .run_keyboard
	cp a, $09
	ret z
	cp a, $02
	jr z, .check_before_backspace
	cp a, $03
	jr z, .insert_newline
	cp a, $07
	jp z, .prepare_keyboard_0a_c00
	cp a, $08
	jp z, .reset_scroll_return
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, .check_char_814b

	; [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0;
	; fall-through of the jrcc at 2D:56F9 (executed) [executed in 1 scenarios]
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, .check_char_814b
	call MailBody_ApplyDakuten
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, .run_keyboard
	call MailBody_ApplyDakutenU
	jr .run_keyboard

.check_char_814b ; 2D:5711
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)
	ld a, [wKeyboardCharLo]
	cp a, $4B
	jr nz, .insert_keyboard_char

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2D:5716 (executed) [executed in 2 scenarios]
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, .insert_keyboard_char
	call MailBody_ApplyHandakuten
	jr .run_keyboard

.insert_keyboard_char ; 2D:5724
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 2/18 scenarios)
	ld a, [wKeyboardCharLo]
	ld e, a
	ld a, [wKeyboardCharHi]
	ld d, a
	ld a, b
	push af
	call MailBody_InsertChar
	pop af
	cp a, b
	jr nz, .check_scroll_addition
	jr .run_keyboard
.check_before_backspace ; 2D:5737
	call MailBody_GetLength
	cp a, $00
	jr nz, .backspace

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 2D:573C (executed) [executed in 2 scenarios]
	ld a, b
	or a, c
	jr z, .hide_keyboard_reset_scroll

.backspace ; 2D:5742
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	ld a, b
	push af
	call MailBody_Backspace
	pop af
	cp a, b
	jr nz, .check_scroll_subtraction
	jp .run_keyboard

	; [HYPOTHESIS] single ret after a jp; no reference found
	ret

.hide_keyboard_reset_scroll ; 2D:574F
	; [CONFIRMED] 31 insn(s) reached by static flow only; seeds: exec x31; min discovery hops 1;
	; entered by jrcc from 2D:5740 (PROBABLE code) [executed in 1 scenarios]
	push bc
	farcall Kbd_Hide
	xor a, a
	ld [wTextEditGoalColumn], a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	pop bc
	ret
.insert_newline ; 2D:5761
	call MailBody_InsertNewline
	inc a
	jp z, .run_keyboard
.check_scroll_addition ; 2D:5768
	ld a, b
	cp a, $01
	jp z, .run_keyboard
	cp a, $07
	jp z, .run_keyboard
	cp a, $08
	jp z, .run_keyboard
	ld a, [wSplitScrollY]
	add a, $0C
	ld [wSplitScrollY], a
	jp .run_keyboard
.check_scroll_subtraction ; 2D:5783
	ld a, b
	cp a, $00
	jp z, .run_keyboard
	cp a, $06
	jp z, .run_keyboard
	ld a, [wSplitScrollY]
	sub a, $0C
	ld [wSplitScrollY], a
	jp .run_keyboard

	; [HYPOTHESIS] single ret after a jp; no reference found
	ret

.prepare_keyboard_0a_c00 ; 2D:579A
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 2/18 scenarios)
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	push bc
	call MailBody_PlaceCursorSprites
	pop bc
	push bc
	ld a, b
	cp a, $06
	jr z, .position_cursors_14d0_c00
	cp a, $07
	jr nz, .open_keyboard_0a_c00

.position_cursors_14d0_c00 ; 2D:57AF
	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; entered by jrcc from 2D:57A9 (executed) [executed in 1 scenarios]
	ld de, $14D0
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld de, $14D0
	ld hl, wSpriteSlot2
	call Sprite_SetPosition

.open_keyboard_0a_c00 ; 2D:57C1
	; [CONFIRMED] 43 insn(s); 43 executed (in up to 2/18 scenarios)
	ld a, $0A
	ld b, $00
	ld c, $00
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Kbd_Open
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	pop bc
.run_keyboard_0a ; 2D:57F7
	push bc
	farcall Sprite_UpdateAll
	ld b, $01
	ld c, $00
	farcall Kbd_Run
	pop bc
	cp a, $04
	jr z, .handle_result_04
	cp a, $05
	jp z, .handle_result_05
	cp a, $06
	jp z, .handle_result_06
	cp a, $09
	jp z, .reload_restart_keyboard

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jpcc at 2D:5819 (executed)
	jr .run_keyboard_0a

.reload_restart_keyboard ; 2D:581E
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 2/18 scenarios)
	push af
	push bc
	push de
	push hl
	call MailBody_ReloadTiles
	pop hl
	pop de
	pop bc
	pop af
	jp MailBody_KeyboardLoop
.handle_result_04 ; 2D:582C
	push af
	push bc
	push de
	push hl
	call MailBody_ReloadTiles
	pop hl
	pop de
	pop bc
	pop af
	push bc
	farcall Sprites_SaveSlotsToBank3
	xor a, a
	cp a, b
	jr z, .show_dialog_0202

	; [CONFIRMED] 15 insn(s) reached by static flow only; seeds: exec x15; min discovery hops 0;
	; fall-through of the jrcc at 2D:5840 (executed) [executed in 1 scenarios]
	inc a
	cp a, b
	jr z, .show_dialog_0202
	inc a
	cp a, b
	jr z, .show_dialog_0202
	inc a
	cp a, b
	jr z, .show_dialog_0202
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $D0
	ld [wSpriteSlot1 + $01], a
	ld [wSpriteSlot2 + $01], a

.show_dialog_0202 ; 2D:585C
	; [CONFIRMED] 53 insn(s); 53 executed (in up to 2/18 scenarios)
	ld de, $0202
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push de
	pop de
	farcall Dialog_Show
	push af
	farcall Sprites_RestoreSlotsFromBank3
	pop af
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	pop bc
	dec a
	jr nz, .reload_retry_0a_c00
	farcall MailDraft_SaveToSram
	push bc
	push de
	play_sfx SFX_SAVE
	pop de
	pop bc
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	pop af
	ld a, $FF
	ld a, $01
	ret

.reload_retry_0a_c00 ; 2D:58C8
	; [CONFIRMED] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 1;
	; entered by jrcc from 2D:589A (executed) [executed in 2 scenarios]
	push af
	push bc
	push de
	push hl
	call MailBody_ReloadTiles
	pop hl
	pop de
	pop bc
	pop af
	jp .prepare_keyboard_0a_c00

	; [HYPOTHESIS] jp $5691 after a jp; no reference found
	jp MailBody_KeyboardLoop

.reload_prepare_0a_c02 ; 2D:58D9
	; [CONFIRMED] 98 insn(s) reached by static flow only; seeds: exec x98; min discovery hops 1;
	; entered by jpcc from 2D:5A38 (executed) | 21 insn(s) executed; cut out of the PROBABLE region
	; 58D9-59AD by apply_coverage --split [executed in 2 scenarios]
	push af
	push bc
	push de
	push hl
	call MailBody_ReloadTiles
	pop hl
	pop de
	pop bc
	pop af
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	push bc
	call MailBody_PlaceCursorSprites
	pop bc
	push bc
	ld a, b
	cp a, $06
	jr z, .position_cursors_14d0_c02
	cp a, $07
	jr nz, .open_keyboard_0a_c02

.position_cursors_14d0_c02 ; 2D:58F9
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 58D9-59AD by apply_coverage --split
	ld de, $14D0
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld de, $14D0
	ld hl, wSpriteSlot2
	call Sprite_SetPosition

.open_keyboard_0a_c02 ; 2D:590B
	; [CONFIRMED] 18 insn(s) executed; cut out of the PROBABLE region 58D9-59AD by apply_coverage
	; --split [executed in 2 scenarios]
	ld a, $0A
	ld b, $00
	ld c, $02
	farcall Kbd_Open
	pop bc
	jp .run_keyboard_0a
.prepare_keyboard_0a_c01 ; 2D:591B
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	push bc
	call MailBody_PlaceCursorSprites
	pop bc
	push bc
	ld a, b
	cp a, $06
	jr z, .position_cursors_14d0_c01
	cp a, $07
	jr nz, .open_keyboard_0a_c01

.position_cursors_14d0_c01 ; 2D:5930
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 58D9-59AD by apply_coverage --split
	ld de, $14D0
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld de, $14D0
	ld hl, wSpriteSlot2
	call Sprite_SetPosition

.open_keyboard_0a_c01 ; 2D:5942
	; [CONFIRMED] 47 insn(s) executed; cut out of the PROBABLE region 58D9-59AD by apply_coverage
	; --split [executed in 2 scenarios]
	ld a, $0A
	ld b, $00
	ld c, $01
	farcall Kbd_Open
	pop bc
	jp .run_keyboard_0a
.handle_result_05 ; 2D:5952
	push af
	push bc
	push de
	push hl
	call MailBody_ReloadTiles
	pop hl
	pop de
	pop bc
	pop af
	push bc
	farcall Kbd_Hide
.wait_ly_50_to_59 ; 2D:5964
	ldh a, [rLY]
	cp a, $50
	jr c, .wait_ly_50_to_59
	cp a, $5A
	jr nc, .wait_ly_50_to_59
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ld a, $B0
	ldh [rWX], a
	farcall MailBody_ViewScreen
	pop bc
	push bc
	farcall Stat_EnableScrollSplit
	call MailBody_SetupScreen
	push bc
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0005
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	pop bc
	call MailBody_ProbeLastRow
	pop bc
	jp .prepare_keyboard_0a_c01

	; [HYPOTHESIS] jp $56C6 ; ret after a jp; no reference found
	jp .run_keyboard

	ret

.handle_result_06 ; 2D:59B1
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 1/18 scenarios)
	push af
	push bc
	push de
	push hl
	call MailBody_ReloadTiles
	pop hl
	pop de
	pop bc
	pop af
	push bc
	farcall Sprites_SaveSlotsToBank3
	xor a, a
	cp a, b
	jr z, .select_mode_dialog

	; [CONFIRMED] 15 insn(s) reached by static flow only; seeds: exec x15; min discovery hops 0;
	; fall-through of the jrcc at 2D:59C5 (executed) [executed in 1 scenarios]
	inc a
	cp a, b
	jr z, .select_mode_dialog
	inc a
	cp a, b
	jr z, .select_mode_dialog
	inc a
	cp a, b
	jr z, .select_mode_dialog
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $D0
	ld [wSpriteSlot1 + $01], a
	ld [wSpriteSlot2 + $01], a

.select_mode_dialog ; 2D:59E1
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 1/18 scenarios)
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailComposeMode]
	dec a
	jr nz, .check_second_mode
	ld de, $0200
	jr .show_selected_dialog

.check_second_mode ; 2D:59F2
	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1;
	; entered by jrcc from 2D:59EB (executed)
	dec a
	jr nz, .use_dialog_020f
	ld de, $0211
	jr .show_selected_dialog
.use_dialog_020f ; 2D:59FA
	ld de, $020F

.show_selected_dialog ; 2D:59FD
	; [CONFIRMED] 40 insn(s); 40 executed (in up to 1/18 scenarios)
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push de
	pop de
	farcall Dialog_Show
	push af
	farcall Sprites_RestoreSlotsFromBank3
	pop af
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	pop bc
	dec a
	jp nz, .reload_prepare_0a_c02
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailComposeMode]
	dec a
	jr nz, .l5A49
	jr .fade_out_return_zero

.l5A49 ; 2D:5A49
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 2D:5A45 (executed)
	dec a
	jr nz, .fade_out_return_zero
	jr .fade_out_return_zero

.fade_out_return_zero ; 2D:5A4E
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop af
	xor a, a
	ret

	; [HYPOTHESIS] push bc before the raw far-call site 5A61; previous region ends with ret; no
	; caller found
	push bc

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x6, site x6; min discovery hops
	; 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded
	; code
	farcall Kbd_Hide
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	pop bc
	ret
.reset_scroll_return ; 2D:5A6F
	push bc
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	pop bc
	ret

	; [HYPOTHESIS] ret ; jr $5A79 (self-loop filler) after a ret; no reference found
	ret
.self_loop ; 2D:5A79
	jr .self_loop

MailBody_GetLength:: ; 2D:5A7B

	; [CONFIRMED] 18 insn(s); 18 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push hl
	push de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wEditBodyBuf
	ld d, $00
.count_body_bytes ; 2D:5A88
	ld a, [hli]
	cp a, $00
	jr z, .return_count
	inc d
	ld a, $C0
	cp a, d
	jr nz, .count_body_bytes
.return_count ; 2D:5A93
	ld a, d
	pop de
	pop hl
	ret

	; [HYPOTHESIS] single ret after a ret; no reference found
	ret

MailBody_ReloadTiles:: ; 2D:5A98

	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld de, $9301
	ld hl, Gfx_MailBody_Tiles
	ld a, BANK(Gfx_MailBody_Tiles)
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMA
	ld de, $9501
	ld hl, Gfx_MailBody_Tiles + $200 ; 2D:5CC0
	ld a, BANK(Gfx_MailBody_Tiles)
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMA
	ret

; ---- zero $5ABD-$5AC0 (3 bytes) [PROBABLE] 3 bytes $00 padding to the 16-byte tile alignment before the tile block at 5AC0
	ds $3, $00
