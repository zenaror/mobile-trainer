; engine/mail/mail_title_entry.asm
; bank 2C, $4000-$4A30 (2608 bytes); pinned by layout.link
; mail title (subject) entry with the kana keyboard

SECTION "engine/mail/mail_title_entry", ROMX

MailTitle_Entry:: ; 2C:4000
Function_2C_4000::
	; [CONFIRMED] 33 insn(s); 33 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
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
	pop af
	push af
	call MailTitle_InitScreen
	ld d, $0A
.loop ; 2C:4028
	push de
	call MailTitle_MoveCursorRight
	pop de
	dec d
	jr nz, .loop
	pop af
	cp a, $01
	jr nz, MailTitle_Entry_ClampColumn
	call MailTitle_KeyboardLoop
	jp MailTitle_Entry_AfterKeyboard

MailTitle_Entry_ClampColumn:: ; 2C:403B
Label_2C_403B::
	ld a, c
	cp a, $0B
	jr nz, MailTitle_Entry_Loop

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 2C:403E (executed)
	ld c, $0A

MailTitle_Entry_Loop:: ; 2C:4042
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 2/18 scenarios)
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	call MailTitle_PlaceTextCursor
	ldh a, [hJoyPressed]
	and a, PADF_A
	jr z, MailTitle_Entry_CheckButtonB
	call MailTitle_OpenKeyboard

MailTitle_Entry_AfterKeyboard:: ; 2C:405F
Label_2C_405F::
	cp a, $07
	jr nz, MailTitle_Entry_CheckButtonB
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ld a, $07
	ldh [rWX], a
	ld a, $90
	ldh [rWY], a
	xor a, a
	ret

MailTitle_Entry_CheckButtonB:: ; 2C:407C
Label_2C_407C::
	ldh a, [hJoyPressed]
	and a, PADF_B
	jr z, .l40C1

	; [CONFIRMED] 25 insn(s) reached by static flow only; seeds: exec x25; min discovery hops 0;
	; fall-through of the jrcc at 2C:4080 (executed) [executed in 1 scenarios]
	push bc
	push de
	play_sfx SFX_CANCEL
	pop de
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	ld a, $90
	ldh [rWY], a
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	ld a, $FF
	ret

.l40C1 ; 2C:40C1
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)
	ldh a, [hJoyPressedRepeat]
	and a, PADF_LEFT
	call nz, MailTitle_CursorLeft
	ldh a, [hJoyPressedRepeat]
	and a, PADF_RIGHT
	call nz, MailTitle_CursorRight
	ld d, $10
	jp MailTitle_Entry_ClampColumn

MailTitle_CursorLeft:: ; 2C:40D4
	; [CONFIRMED] 38 insn(s) reached by static flow only; seeds: exec x38; min discovery hops 1;
	; entered by callcc from 2C:40C5 (executed) | 18 insn(s) executed; cut out of the PROBABLE
	; region 40D4-410F by apply_coverage --split [executed in 3 scenarios]
	push bc
	push de
	play_sfx SFX_TEXT_CURSOR_MOVE
	pop de
	pop bc
	inc c
	dec c
	jr nz, .l40F5
	inc b
	dec b
	ret z

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 40D4-410F by apply_coverage --split
	dec b
	call MailTitle_CharPtr
	ld c, e
	ret

.l40F5 ; 2C:40F5
	; [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 40D4-410F by apply_coverage
	; --split [executed in 3 scenarios]
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

MailTitle_CursorRight:: ; 2C:40FB
	push bc
	push de
	play_sfx SFX_TEXT_CURSOR_MOVE
	pop de
	pop bc

MailTitle_MoveCursorRight:: ; 2C:410F
Function_2C_410F::
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, b
	cp a, $07
	jr nz, .l4118

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; fall-through of the jrcc at 2C:4112 (executed)
	ld a, c
	cp a, $0B
	ret z

.l4118 ; 2C:4118
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios)
	inc c
	dec c
	jr nz, .l4129
	call MailTitle_CharPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $00
	ret z
.l4129 ; 2C:4129
	call MailTitle_CharPtr
	cp a, $FF
	ret z
	cp a, $0D
	jr nz, .l413B

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1;
	; fall-through of the jrcc at 2C:4131 (executed)
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

.l413B ; 2C:413B
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $0C
	cp a, c
	ret nz

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the retcc at 2C:4143 (executed)
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

MailTitle_InitScreen:: ; 2C:414C
Function_2C_414C::
	; [CONFIRMED] 171 insn(s); 171 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	farcall TextTiles_UploadBuffers
	farcall LCDOff
	ld de, $9301
	ld hl, Gfx_MailTitle_Tiles9300Vb1
	ld a, BANK(Gfx_MailTitle_Tiles9300Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMA
	ld de, $8800
	ld hl, Gfx_MailTitle_Tiles8800
	ld a, BANK(Gfx_MailTitle_Tiles8800)
	ld b, $95
	ld c, $26
	farcall Gfx_StartHDMA
	ld de, $8000
	ld hl, Gfx_MailTitle_Tiles8000
	ld a, BANK(Gfx_MailTitle_Tiles8000)
	ld b, $94
	ld c, $2D
	farcall Gfx_StartHDMA
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, Palette_MailTitle_Obj
	ld a, BANK(Palette_MailTitle_Obj)
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_MailTitle_Bg
	ld a, BANK(Palette_MailTitle_Bg)
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Data_MailTitle_TilemapAttr
	ld a, BANK(Data_MailTitle_TilemapAttr)
	farcall Tilemap_CopyRectAndAttr
	ld hl, wSpriteSlot1
	ld de, Table_TextCursor_ObjTables_Entry8
	ld a, BANK(Table_TextCursor_ObjTables_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot2
	ld de, Table_TextCursor_ObjTables_Entry4
	ld a, BANK(Table_TextCursor_ObjTables_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $14D0
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ld a, $D0
	ld [wSpriteSlot3], a
	xor a, a
	ld [wSpriteSlot3 + $01], a
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	pop af
	push af
	dec a
	jr nz, .l4258
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
	ld a, $08
	ld b, $02
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
	ld a, $24
	ld [wSplitScrollY], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0004
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
.l4258 ; 2C:4258
	ld bc, $0000
	call MailTitle_PlaceTextCursor
	farcall LCDOn
	ld bc, $0000
	ld bc, $0300
	ld de, $0420
	ld hl, wEditSubjectBuf
	call MailTitle_DrawTextLine
	call MailTitle_UploadTextTiles
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0004
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	pop af
	dec a
	jr nz, .l42B4
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
	jr .l42E3
.l42B4 ; 2C:42B4
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
.l42E3 ; 2C:42E3
	ld bc, $0000
	xor a, a
	ld [wTextEditGoalColumn], a
	ret

MailTitle_PlaceTextCursor:: ; 2C:42EB
	push bc
	ld b, $00
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	inc b
	inc c
	ld a, $38
.l42F8 ; 2C:42F8
	dec b
	jr z, .l42FF

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 2C:42F9 (executed)
	add a, $0C
	jr .l42F8

.l42FF ; 2C:42FF
	; [CONFIRMED] 67 insn(s); 67 executed (in up to 2/18 scenarios)
	ld d, a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, d
	sub a, e
	ld [wSpriteSlot1], a
	ld [wSpriteSlot2], a
	ld a, $20
.l430E ; 2C:430E
	dec c
	jr z, .l4315
	add a, $0C
	jr .l430E
.l4315 ; 2C:4315
	ld [wSpriteSlot1 + $01], a
	ld [wSpriteSlot2 + $01], a
	pop bc
	ret

MailTitle_DrawTextLine:: ; 2C:431D
	ld a, $14
	ld [wTextCellsLeft], a
.l4322 ; 2C:4322
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l43BD
	cp a, $0D
	jr z, .l43A2
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l437D
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
	call MailTitle_DrawTextLine_BlitGlyphAdvance
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
	jr z, .l43BD
	cp a, $01
	jr z, .l43BD
	jr .l4322

.l437D ; 2C:437D
	; [PROBABLE] 32 insn(s) reached by static flow only; seeds: exec x32; min discovery hops 1;
	; entered by jrcc from 2C:433A (executed)
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
	call MailTitle_DrawTextLine_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l43BD
	cp a, $01
	jr z, .l43BD
	jr .l4322
.l43A2 ; 2C:43A2
	push bc
	push de
	push hl
	ld b, $3C
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	call MailTitle_DrawTextLine_BlitBlankAdvance

.l43BD ; 2C:43BD
	; [CONFIRMED] 96 insn(s); 96 executed (in up to 2/18 scenarios)
	push bc
	push de
	push hl
	farcall Glyph_LoadDottedLine
	pop hl
	pop de
	pop bc
.l43C9 ; 2C:43C9
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call MailTitle_DrawTextLine_BlitBlankAdvance
	jr .l43C9

MailTitle_DrawTextLine_BlitGlyphAdvance:: ; 2C:43D8
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

MailTitle_DrawTextLine_BlitBlankAdvance:: ; 2C:43EC
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

MailTitle_UploadTextTiles:: ; 2C:4404
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, wTileStage2
	ld de, $9000
	ld c, $27
	call Gfx_StartHDMAAtVBlank_2C_4421
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

Gfx_StartHDMAAtVBlank_2C_4421:: ; 2C:4421
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, rLY
.l4430 ; 2C:4430
	ld a, [de]
	cp a, $8F
	jr nz, .l4430
	ld b, $91
.l4437 ; 2C:4437
	ld a, [de]
	cp a, b
	jr nz, .l4437
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ret

MailTitle_CharPtr:: ; 2C:4441
	push bc
	call MailTitle_FindLine
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $FF
	cp a, d
	jr z, MailTitle_CharPtr_NoChar
	inc c
	ld a, [hl]
.loop ; 2C:4452
	dec c
	jr z, MailTitle_CharPtr_Found
	inc hl
	inc hl
	ld a, [hl]
	cp a, $00
	jr z, MailTitle_CharPtr_NoChar
	ld a, [hl]
	cp a, $0D
	jr z, MailTitle_CharPtr_Newline
	jr .loop

	; [HYPOTHESIS] dead code: follows an unconditional jump, nothing references it and it never ran;
	; decodes as `inc c ; dec c ; jr nz, NoChar` (the same bytes sit unlabeled in the body and
	; profile copies)
	inc c
	dec c
	jr nz, MailTitle_CharPtr_NoChar

MailTitle_CharPtr_Found:: ; 2C:4467
Label_2C_4467::
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)
	pop bc
	ret

MailTitle_CharPtr_NoChar:: ; 2C:4469
Label_2C_4469::
	ld a, $FF
	ld d, $FF
	pop bc
	ret

MailTitle_CharPtr_Newline:: ; 2C:446F
Label_2C_446F::
	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1;
	; entered by jrcc from 2C:445F (executed)
	ld a, $0D
	ld d, $FF
	pop bc
	ret

MailTitle_FindLine:: ; 2C:4475
Function_2C_4475::
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wEditSubjectBuf
	inc b
.l4480 ; 2C:4480
	ld d, $00
	ld e, $0C
	dec b
	jr z, .l4499
.l4487 ; 2C:4487
	ld d, $FF
	ld a, [hl]
	cp a, $00
	jr z, .l4499
	inc hl
	inc hl
	cp a, $0D
	jr z, .l4480
	dec e
	jr nz, .l4487

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 2C:4495 (executed) [executed in 1 scenarios]
	jr .l4480

.l4499 ; 2C:4499
	; [CONFIRMED] 27 insn(s); 27 executed (in up to 2/18 scenarios)
	ld a, $FF
	cp a, d
	jr z, .l44B2
	ld e, $00
	push hl
.l44A1 ; 2C:44A1
	ld a, [hli]
	inc hl
	cp a, $00
	jr z, .l44B1
	cp a, $0D
	jr z, .l44B1
	inc e
	ld a, $0B
	cp a, e
	jr nz, .l44A1
.l44B1 ; 2C:44B1
	pop hl
.l44B2 ; 2C:44B2
	xor a, a
	ld [rRAMG], a
	pop bc
	ret

MailTitle_InsertChar:: ; 2C:44B8
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wEditSubjectBuf + $12
	ld a, [hl]
	cp a, $00
	jr z, MailTitle_InsertChar_Insert

	; [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0;
	; fall-through of the jrcc at 2C:44C4 (executed) [executed in 3 scenarios]
	push bc
	push de
	play_sfx SFX_REJECT
	pop de
	pop bc
	ret

	; [HYPOTHESIS] dead code: a single `ret nz` in front of the Insert block; follows an
	; unconditional jump, nothing references it and it never ran
	ret nz

MailTitle_InsertChar_Insert:: ; 2C:44DC
Label_2C_44DC::
	; [CONFIRMED] 58 insn(s); 58 executed (in up to 2/18 scenarios)
	push de
	push bc
	push bc
	push de
	play_sfx SFX_CHAR_ENTERED
	pop de
	pop bc
	push bc
	ld hl, wSpriteSlot1
	ld de, Table_TextCursor_ObjTables_Entry12
	ld a, BANK(Table_TextCursor_ObjTables_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	call MailTitle_PlaceTextCursor
	ld d, $14
.loop ; 2C:4509
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
	jr nz, .l452D
	ldh a, [hJoyHeld]
	and a, PADF_DPAD
	jr nz, .l452D
	dec d
	jr nz, .loop
.l452D ; 2C:452D
	farcall Joypad_ClearAndResetRepeat
	ld hl, wSpriteSlot1
	ld de, Table_TextCursor_ObjTables_Entry8
	ld a, BANK(Table_TextCursor_ObjTables_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	push bc
	call MailTitle_PlaceTextCursor
	farcall Sprite_UpdateAll
	pop bc
	pop de
	push de
	push bc
	ld b, $07
	ld c, $00
	call MailTitle_FindLine
	inc d
	jr z, MailTitle_InsertChar_ShiftAndStore

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 0;
	; fall-through of the jrcc at 2C:455A (executed)
	pop bc
	push bc
	ld c, $0B

MailTitle_InsertChar_CheckRow:: ; 2C:4560
Label_2C_4560::
	call MailTitle_CharPtr
	inc d
	jr nz, MailTitle_InsertChar_NextRow
	ld a, e
	cp a, $0B
	jr z, MailTitle_InsertChar_Reject
	jr MailTitle_InsertChar_ShiftAndStore

	; [HYPOTHESIS] dead code: follows an unconditional jump, nothing references it and it never ran;
	; decodes as `ld a, 1 ; ldh [hWRAMBank], a ; ldh [rSVBK], a ; ld a, [hl] ; cp $0D ; cp $00 ; jr
	; z, MailTitle_InsertChar_ShiftAndStore`
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $0D
	cp a, $00
	jr z, MailTitle_InsertChar_ShiftAndStore

MailTitle_InsertChar_NextRow:: ; 2C:457A
Label_2C_457A::
	; [PROBABLE] 22 insn(s) reached by static flow only; seeds: exec x22; min discovery hops 1;
	; entered by jrcc from 2C:4564 (PROBABLE code)
	ld a, $08
	cp a, b
	jr z, MailTitle_InsertChar_Reject
	inc b
	ld a, $08
	cp a, b
	jr nz, MailTitle_InsertChar_CheckRow

MailTitle_InsertChar_Reject:: ; 2C:4585
Label_2C_4585::
	push bc
	push de
	play_sfx SFX_REJECT
	pop de
	pop bc
	pop bc
	pop de
	ret

MailTitle_InsertChar_ShiftAndStore:: ; 2C:459C
Label_2C_459C::
	; [CONFIRMED] 49 insn(s); 49 executed (in up to 2/18 scenarios)
	pop bc
	pop de
	push de
	call MailTitle_CharPtr
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push de
	push hl
	ld de, wEditSubjectBuf + $12
	ld bc, wEditSubjectBuf + $10
.loop ; 2C:45B2
	ld a, d
	cp a, h
	jr nz, .l45BA
	ld a, e
	cp a, l
	jr z, .l45C6
.l45BA ; 2C:45BA
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
	jr .loop
.l45C6 ; 2C:45C6
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
	ld bc, $0300
	ld de, $0420
	ld hl, wEditSubjectBuf
	call MailTitle_DrawTextLine
	call MailTitle_UploadTextTiles
	pop bc
	ld a, b
	cp a, $07
	jr nz, .l45EC

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 2C:45E5 (executed)
	ld a, c
	cp a, $0B
	jr z, .done

.l45EC ; 2C:45EC
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 2/18 scenarios)
	call MailTitle_CharPtr
	cp a, $FF
	jr z, .done
	cp a, $0D
	jr nz, .l4600

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2C:45F5 (executed)
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	jr .done

.l4600 ; 2C:4600
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $0C
	cp a, c
	jr nz, .done

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 2C:4608 (executed)
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a

.done ; 2C:4611
	; [CONFIRMED] 31 insn(s); 31 executed (in up to 2/18 scenarios)
	ret

MailTitle_DeleteChar:: ; 2C:4612
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
	call MailTitle_CharPtr
	pop bc
	push bc
	inc c
	dec c
	jr nz, .l464F

	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 2C:4645 (executed) | 3 insn(s) executed; cut out of the PROBABLE
	; region 4647-464F by apply_coverage --split [executed in 1 scenarios]
	ld a, b
	cp a, $00
	jr z, .l4650

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4647-464F by apply_coverage --split
	dec b
	ld c, e
	inc c

.l464F ; 2C:464F
	; [CONFIRMED] 30 insn(s); 30 executed (in up to 1/18 scenarios)
	dec c
.l4650 ; 2C:4650
	call MailTitle_PlaceTextCursor
	pop bc
	ld d, $14
.loop ; 2C:4656
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
	jr nz, .l467A
	ldh a, [hJoyHeld]
	and a, PADF_DPAD
	jr nz, .l467A
	dec d
	jr nz, .loop
.l467A ; 2C:467A
	farcall Joypad_ClearAndResetRepeat
	ld hl, wSpriteSlot1
	ld de, Table_TextCursor_ObjTables_Entry8
	ld a, BANK(Table_TextCursor_ObjTables_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	inc c
	dec c
	jr nz, .l46A0

	; [CONFIRMED] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0;
	; fall-through of the jrcc at 2C:4693 (executed) | 3 insn(s) executed; cut out of the PROBABLE
	; region 4695-46A0 by apply_coverage --split [executed in 1 scenarios]
	inc b
	dec b
	jr z, .l46A5

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4695-46A0 by apply_coverage --split
	dec b
	call MailTitle_CharPtr
	ld c, e
	jr .l46A5

.l46A0 ; 2C:46A0
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 1/18 scenarios)
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a
.l46A5 ; 2C:46A5
	call MailTitle_CharPtr
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
	jr nz, .l46BF

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 2C:46BB (executed)
	ld e, $01

.l46BF ; 2C:46BF
	; [CONFIRMED] 29 insn(s); 29 executed (in up to 1/18 scenarios)
	ld a, $12
	cp a, l
	jr nz, .l46C9
	ld a, $D5
	cp a, h
	jr z, .l46D1
.l46C9 ; 2C:46C9
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
	inc bc
	jr .l46BF
.l46D1 ; 2C:46D1
	xor a, a
	ld [hli], a
	ld [hli], a
	ld a, e
	pop hl
	pop de
	pop bc
	ld e, a
	push bc
	ld bc, $0300
	ld de, $0420
	ld hl, wEditSubjectBuf
	call MailTitle_DrawTextLine
	call MailTitle_UploadTextTiles
	pop bc
	ret

MailTitle_ApplyDakuten:: ; 2C:46EB
	; [CONFIRMED] 68 insn(s) reached by static flow only; seeds: exec x68; min discovery hops 1;
	; entered by call from 2C:49A9 (PROBABLE code) | 4 insn(s) executed; cut out of the PROBABLE
	; region 46EB-4760 by apply_coverage --split [executed in 1 scenarios]
	call MailTitle_CharPtr
	ld a, $00
	cp a, l
	jr nz, .l46F9

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 46EB-4760 by apply_coverage --split
	ld a, $D5
	cp a, h
	jp z, .l4774

.l46F9 ; 2C:46F9
	; [CONFIRMED] 43 insn(s) executed; cut out of the PROBABLE region 46EB-4760 by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, String_MailTitle_DakutenKana
.loop ; 2C:4705
	ld a, [de]
	inc de
	cp a, $00
	jr z, .l4768
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, b
	jr nz, .l475D
	ld a, [hl]
	cp a, c
	jr nz, .l475D
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
	jr nz, .l474B

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 46EB-4760 by apply_coverage --split
	push bc
	ld bc, $0300
	ld de, $0420
	ld hl, wEditSubjectBuf
	call MailTitle_DrawTextLine
	call MailTitle_UploadTextTiles
	pop bc
	ret

.l474B ; 2C:474B
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 46EB-4760 by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	ld bc, $0300
	ld de, $0420
	ld hl, wEditSubjectBuf
	call MailTitle_DrawTextLine
	call MailTitle_UploadTextTiles
	pop bc
	ret
.l475D ; 2C:475D
	pop hl
	jr .loop

	; [HYPOTHESIS] 5 insn(s) SRAM-disable epilogue (xor a ; ldh [$FFF5],a ; ld [$0000],a ; pop bc ;
	; ret), identical bytes to 2F:5F28/6007/60B8; follows an unconditional jr; well-formed
	; instruction chain (clean decode, all direct targets land on instruction starts, lands exactly
	; on the next code region); no direct caller/table entry found: entry HYPOTHESIS | verifier:
	; downgraded to HYPOTHESIS, no direct/far/table reference to this address exists anywhere in the
	; ROM (all-bank search for the address word) and it is not a fall-through of proven code, so it
	; is only bytes that decode cleanly
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.l4768 ; 2C:4768
	; [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 2;
	; entered by jrcc from 2C:4709 (PROBABLE code) | 9 insn(s) executed; cut out of the PROBABLE
	; region 4768-4779 by apply_coverage --split [executed in 1 scenarios]
	push bc
	push de
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.l4774 ; 2C:4774
	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4768-4779 by apply_coverage --split
	push bc
	push de
	pop de
	pop bc
	ret

; ---- text $4779-$47CA (81 bytes) [PROBABLE] NUL-terminated Shift-JIS string of 40 kana (rows that can take dakuten: かきくけこ さしすせそ たちつてと はひふへほ, then the katakana カ..ホ; 81 bytes + NUL at 47C9); ld de,$4779 at 2C:4702; identical bytes at 2F:5F41. Verified by decoding all 40 double-byte characters with cp932. Verifier fix: the former ptrtable Table_2C_47AF (47AF-47BD, "7/7 words hit code starts") was the katakana スセソタチツテト bytes 83 58 83 5A ... read as little-endian words, not pointers

PUSHC sjis
String_MailTitle_DakutenKana:: ; 2C:4779
String_2C_4779::
	db "かきくけこさしすせそたちつてとはひふへほカキクケコサシスセソタチツテトハヒフヘホ", 0
POPC

; ---- data $47CA-$47CB (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2C_47CA:: ; 2C:47CA
	db $C9

MailTitle_ApplyVu:: ; 2C:47CB
	; [CONFIRMED] 66 insn(s) reached by static flow only; seeds: exec x66; min discovery hops 1;
	; entered by call from 2C:49B3 (PROBABLE code) | 4 insn(s) executed; cut out of the PROBABLE
	; region 47CB-483F by apply_coverage --split [executed in 1 scenarios]
	call MailTitle_CharPtr
	ld a, $00
	cp a, l
	jr nz, .l47D9

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47CB-483F by apply_coverage --split
	ld a, $D5
	cp a, h
	jp z, .l4863

.l47D9 ; 2C:47D9
	; [CONFIRMED] 41 insn(s) executed; cut out of the PROBABLE region 47CB-483F by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, Table_MailTitle_ApplyVu_LoopPairs
.loop ; 2C:47E5
	ld a, [de]
	inc de
	cp a, $00
	jr z, .l4847
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, $83
	jr nz, .l483C
	ld a, [hl]
	cp a, $45
	jr nz, .l483C
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
	jr nz, .l482A

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47CB-483F by apply_coverage --split
	push bc
	ld bc, $0300
	ld de, $0420
	ld hl, wEditSubjectBuf
	call MailTitle_DrawTextLine
	call MailTitle_UploadTextTiles
	pop bc
	ret

.l482A ; 2C:482A
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 47CB-483F by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	ld bc, $0300
	ld de, $0420
	ld hl, wEditSubjectBuf
	call MailTitle_DrawTextLine
	call MailTitle_UploadTextTiles
	pop bc
	ret

.l483C ; 2C:483C
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47CB-483F by apply_coverage --split
	pop hl
	jr .loop

	; [HYPOTHESIS] 5 insn(s) SRAM-disable epilogue (xor a ; ldh [$FFF5],a ; ld [$0000],a ; pop bc ;
	; ret), identical bytes to 2F:5F28/6007/60B8; follows an unconditional jr; well-formed
	; instruction chain (clean decode, all direct targets land on instruction starts, lands exactly
	; on the next code region); no direct caller/table entry found: entry HYPOTHESIS | verifier:
	; downgraded to HYPOTHESIS, no direct/far/table reference to this address exists anywhere in the
	; ROM (all-bank search for the address word) and it is not a fall-through of proven code, so it
	; is only bytes that decode cleanly
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.l4847 ; 2C:4847
	; [PROBABLE] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 2;
	; entered by jrcc from 2C:47E9 (PROBABLE code)
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
.l4863 ; 2C:4863
	push bc
	push de
	play_sfx SFX_REJECT
	pop de
	pop bc
	ret

; ---- text $4878-$487D (5 bytes) [PROBABLE] NUL-terminated Shift-JIS string (82 A4 82 A4 00); read byte by byte by 2C:47E2 (ld de,$4878; ld a,[de]; inc de; cp $00; jr z); identical bytes at 2F:6040. The following $C9 (ret) stays unresolved in the next region

PUSHC sjis
Table_MailTitle_ApplyVu_LoopPairs:: ; 2C:4878
String_2C_4878::
	db "うう", 0
POPC

; ---- data $487D-$487E (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 byte $C9 (ret) between a string and code; no entry found

Data_2C_487D:: ; 2C:487D
	db $C9

MailTitle_ApplyHandakuten:: ; 2C:487E
	; [CONFIRMED] 67 insn(s) reached by static flow only; seeds: exec x67; min discovery hops 1;
	; entered by call from 2C:49C6 (PROBABLE code) | 4 insn(s) executed; cut out of the PROBABLE
	; region 487E-48F0 by apply_coverage --split [executed in 1 scenarios]
	call MailTitle_CharPtr
	ld a, $00
	cp a, l
	jr nz, .l488C

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 487E-48F0 by apply_coverage --split
	ld a, $D5
	cp a, h
	jp z, .l4914

.l488C ; 2C:488C
	; [CONFIRMED] 42 insn(s) executed; cut out of the PROBABLE region 487E-48F0 by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, String_MailTitle_HandakutenKana
.loop ; 2C:4898
	ld a, [de]
	inc de
	cp a, $00
	jr z, .l48F8
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, b
	jr nz, .l48ED
	ld a, [hl]
	cp a, c
	jr nz, .l48ED
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
	jr nz, .l48DB

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 487E-48F0 by apply_coverage --split
	push bc
	ld bc, $0300
	ld de, $0420
	ld hl, wEditSubjectBuf
	call MailTitle_DrawTextLine
	call MailTitle_UploadTextTiles
	pop bc
	ret

.l48DB ; 2C:48DB
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 487E-48F0 by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	ld bc, $0300
	ld de, $0420
	ld hl, wEditSubjectBuf
	call MailTitle_DrawTextLine
	call MailTitle_UploadTextTiles
	pop bc
	ret
.l48ED ; 2C:48ED
	pop hl
	jr .loop

	; [HYPOTHESIS] 5 insn(s) SRAM-disable epilogue (xor a ; ldh [$FFF5],a ; ld [$0000],a ; pop bc ;
	; ret), identical bytes to 2F:5F28/6007/60B8; follows an unconditional jr; well-formed
	; instruction chain (clean decode, all direct targets land on instruction starts, lands exactly
	; on the next code region); no direct caller/table entry found: entry HYPOTHESIS | verifier:
	; downgraded to HYPOTHESIS, no direct/far/table reference to this address exists anywhere in the
	; ROM (all-bank search for the address word) and it is not a fall-through of proven code, so it
	; is only bytes that decode cleanly
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.l48F8 ; 2C:48F8
	; [PROBABLE] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 2;
	; entered by jrcc from 2C:489C (PROBABLE code)
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
.l4914 ; 2C:4914
	push bc
	push de
	play_sfx SFX_REJECT
	pop de
	pop bc
	ret

; ---- text $4929-$493E (21 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MailTitle_HandakutenKana:: ; 2C:4929
String_2C_4929::
	db "はひふへほハヒフヘホ", 0
POPC

; ---- data $493E-$493F (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2C_493E:: ; 2C:493E
	db $C9

MailTitle_OpenKeyboard:: ; 2C:493F
Function_2C_493F::
	; [CONFIRMED] 49 insn(s); 49 executed (in up to 2/18 scenarios); entry proven: target of an
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
	ld a, $08
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

MailTitle_KeyboardLoop:: ; 2C:4972
	push bc
	call MailTitle_PlaceTextCursor
	ld d, $70
	farcall Sprite_UpdateAll
	ld b, $01
	ld c, $00
	farcall Kbd_Run
	pop bc
	cp a, $00
	jr z, MailTitle_KeyboardLoop
	cp a, $09
	ret z
	cp a, $02
	jr z, .l49D8
	cp a, $07
	ret z
	cp a, $08
	jr z, MailTitle_KeyboardLoop_HideKeyboard
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, .l49B8

	; [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0;
	; fall-through of the jrcc at 2C:49A0 (executed) [executed in 1 scenarios]
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, .l49B8
	call MailTitle_ApplyDakuten
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, MailTitle_KeyboardLoop
	call MailTitle_ApplyVu
	jr MailTitle_KeyboardLoop

.l49B8 ; 2C:49B8
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)
	ld a, [wKeyboardCharLo]
	cp a, $4B
	jr nz, .l49CB

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2C:49BD (executed) [executed in 1 scenarios]
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, .l49CB
	call MailTitle_ApplyHandakuten
	jr MailTitle_KeyboardLoop

.l49CB ; 2C:49CB
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 2/18 scenarios)
	ld a, [wKeyboardCharLo]
	ld e, a
	ld a, [wKeyboardCharHi]
	ld d, a
	call MailTitle_InsertChar
	jr MailTitle_KeyboardLoop
.l49D8 ; 2C:49D8
	call MailTitle_GetLength
	cp a, $00
	jr nz, .l49E3

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 2C:49DD (executed) [executed in 2 scenarios]
	ld a, b
	or a, c
	jr z, MailTitle_KeyboardLoop_HideKeyboard

.l49E3 ; 2C:49E3
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)
	call MailTitle_DeleteChar
	jr MailTitle_KeyboardLoop

; ---- data $49E8-$49E9 (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2C_49E8:: ; 2C:49E8
	db $C9

MailTitle_KeyboardLoop_HideKeyboard:: ; 2C:49E9
Label_2C_49E9::
	; [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 1;
	; entered by jrcc from 2C:4999 (executed) [executed in 2 scenarios]
	push bc
	farcall Kbd_Hide
	xor a, a
	ld [wTextEditGoalColumn], a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	farcall Joypad_Update
	pop bc
	ret

; ---- data $4A01-$4A05 (4 bytes) [HYPOTHESIS] UNCLASSIFIED 4 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2C_4A01:: ; 2C:4A01
	db $C3, $72, $49, $C9

MailTitle_GetLength:: ; 2C:4A05
Function_2C_4A05::
	; [CONFIRMED] 18 insn(s); 18 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push hl
	push de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wEditSubjectBuf
	ld d, $00
.loop ; 2C:4A12
	ld a, [hli]
	cp a, $00
	jr z, .l4A1D
	inc d
	ld a, $14
	cp a, d
	jr nz, .loop
.l4A1D ; 2C:4A1D
	ld a, d
	pop de
	pop hl
	ret

; ---- zero $4A21-$4A30 (15 bytes) [PROBABLE] all-zero padding before an aligned tile/data block (mapper hint: padding-like)
	ds $F, $00
