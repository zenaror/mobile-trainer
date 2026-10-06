; engine/address_book/save_sender_address.asm
; bank 2A, $4000-$4AA0 (2720 bytes); pinned by layout.link
; save-the-sender-address screen (pick a slot for a received mail's sender)

SECTION "engine/address_book/save_sender_address", ROMX

SaveSenderAddr_Menu:: ; 2A:4000
	; [CONFIRMED] 231 insn(s) reached by static flow only; seeds: exec x231; min discovery hops 10;
	; entered by far from 2B:659F (PROBABLE code) [executed in 1 scenarios]
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
	push bc
	farcall Stat_EnableScrollSplit
	di
	ei
	pop bc
	call SaveSenderAddr_InitScreen

SaveSenderAddr_Menu_Loop:: ; 2A:4027
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, PADF_A
	jr z, .l4079
	call SaveSenderAddr_SaveToSlot
	cp a, $FF
	jr z, SaveSenderAddr_Menu_Loop
	push bc
	call SaveSenderAddr_DrawSlotNames
	call SaveSenderAddr_RefreshSlotIcons
	ld a, c
	call SaveSenderAddr_MoveNameHighlight
	farcall AddrBook_UploadTextTiles
	ld b, $3C
.loop ; 2A:4058
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	pop bc
	dec b
	jr nz, .loop
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	ld c, b
	xor a, a
	ret
.l4079 ; 2A:4079
	ldh a, [hJoyPressed]
	and a, PADF_B
	jr z, .l40A8
	push bc
	push de
	play_sfx SFX_CANCEL
	pop de
	pop bc
	push bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	ld c, b
	ld a, $FF
	ret
.l40A8 ; 2A:40A8
	; D-pad part of the menu loop (3,605 hits in 6 scenarios): Up and Down repeats move the cursor through the six slots (SaveSenderAddr_CursorUp / CursorDown)
	ldh a, [hJoyPressedRepeat]
	and a, PADF_UP
	call nz, SaveSenderAddr_CursorUp
	ldh a, [hJoyPressedRepeat]
	and a, PADF_DOWN
	call nz, SaveSenderAddr_CursorDown
	ld d, $10
	jp SaveSenderAddr_Menu_Loop

SaveSenderAddr_CursorDown:: ; 2A:40BB
	push bc
	push de
	play_sfx SFX_CURSOR_MOVE
	pop de
	pop bc
	ld d, c
	inc c
	ld a, c
	cp a, $06
	jr nz, .skip
	ld c, $00
.skip ; 2A:40D8
	ld a, d
	call SaveSenderAddr_MoveNameHighlight
	call SaveSenderAddr_RefreshSlotIcons
	ret

SaveSenderAddr_CursorUp:: ; 2A:40E0
	push bc
	push de
	play_sfx SFX_CURSOR_MOVE
	pop de
	pop bc
	ld d, c
	dec c
	ld a, c
	cp a, $FF
	jr nz, .skip
	ld c, $05
.skip ; 2A:40FD
	ld a, d
	call SaveSenderAddr_MoveNameHighlight
	call SaveSenderAddr_RefreshSlotIcons
	ret

SaveSenderAddr_InitScreen:: ; 2A:4105
	push bc
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, Palette_AddrBook_Obj
	ld a, BANK(Palette_AddrBook_Obj)
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_SaveSenderAddr_Bg
	ld a, BANK(Palette_SaveSenderAddr_Bg)
	farcall Palette_LoadToBuffer
	ld de, $9301
	ld hl, Gfx_SaveSenderAddr_Tiles9300Vb1
	ld a, BANK(Gfx_SaveSenderAddr_Tiles9300Vb1)
	ld b, $95
	ld c, $23
	farcall Gfx_StartHDMA
	ld de, $8000
	ld hl, Gfx_AddrBookShared_Tiles8000
	ld a, BANK(Gfx_AddrBookShared_Tiles8000)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMA
	ld de, $8400
	ld hl, Gfx_AddrBookShared_Tiles8400
	ld a, BANK(Gfx_AddrBookShared_Tiles8400)
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMA
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Data_SaveSenderAddr_TilemapAttr
	ld a, BANK(Data_SaveSenderAddr_TilemapAttr)
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	call SaveSenderAddr_DrawSlotNames
	ld a, $40
	ldh [hJoyPressed], a
	ld c, $00
	call SaveSenderAddr_RefreshSlotIcons
	call SaveSenderAddr_LoadCaption
	ld a, $00
	ld c, $00
	call SaveSenderAddr_MoveNameHighlight
	pop bc
	push bc
	ld c, b
	ld b, $00
	sla c
	ld hl, Table_SaveSenderAddr_MailRecAddrs_Init
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld de, $00C9
	add hl, de
	ld bc, $0300
	ld de, $0220
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	call SaveSenderAddr_DrawSenderName
	pop bc
	push bc
	farcall AddrBook_UploadTextTiles
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeInFromWhite
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $15
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0006
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	pop bc
	ld c, $00
	ret

; ---- words $4214-$422C (24 bytes) [PROBABLE] SRAM address table (12 words $A124..$AE13 (step $12D)): the code indexes it by 2*n and loads hl=[table+2n] as the base of a save/record slot in SRAM ($A000-$BFFF); ld hl,$4214 at 2A:41A3 (index = c*2, ld hl,[hl]; then + $00C9). Values are SRAM addresses, not ROM pointers

Table_SaveSenderAddr_MailRecAddrs_Init:: ; 2A:4214
Table_2A_4214::
	dw $A124, $A251, $A37E, $A4AB, $A5D8, $A705, $A832, $A95F
	dw $AA8C, $ABB9, $ACE6, $AE13

SaveSenderAddr_DrawSlotNames:: ; 2A:422C
	; [CONFIRMED] 45 insn(s) reached by static flow only; seeds: exec x45; min discovery hops 11;
	; entered by call from 2A:4046 (PROBABLE code) [executed in 1 scenarios]
	push bc
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ld d, $06
.l423E ; 2A:423E
	push af
	push de
	push bc
	push af
	ld e, a
	sla e
	ld d, $00
	ld hl, Table_SaveSenderAddr_SlotAddrs_DrawNames
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	pop af
	ld de, $0028
	ld b, a
	xor a, a
	inc b
.l4257 ; 2A:4257
	dec b
	jr z, .l425E
	add a, $0C
	jr .l4257
.l425E ; 2A:425E
	add a, $10
	ld d, a
	ld b, $03
	ld c, $00
	farcall AddrBook_DrawSlotName
	pop bc
	pop de
	pop af
	inc a
	dec d
	jr nz, .l423E
	pop bc
	ret

; ---- words $4274-$4280 (12 bytes) [PROBABLE] SRAM address table (6 words $A69D..$A82D (step $50)): the code indexes it by 2*n and loads hl=[table+2n] as the base of a save/record slot in SRAM ($A000-$BFFF); ld hl,$4274 at 2A:4246 (index e*2 then ld e,[hl]; ld h,[hl]). Values are SRAM addresses, not ROM pointers

Table_SaveSenderAddr_SlotAddrs_DrawNames:: ; 2A:4274
Table_2A_4274::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

SaveSenderAddr_MoveNameHighlight:: ; 2A:4280
	; [CONFIRMED] 78 insn(s) reached by static flow only; seeds: exec x78; min discovery hops 11;
	; entered by call from 2A:404D (PROBABLE code) [executed in 4 scenarios]
	push af
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	push bc
	cp a, $FF
	jr z, .l42C3
	push bc
	push af
	ld e, a
	sla e
	ld d, $00
	ld hl, Table_SaveSenderAddr_SlotAddrs_Highlight
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	pop af
	ld de, $0028
	ld b, a
	xor a, a
	inc b
.l42AC ; 2A:42AC
	dec b
	jr z, .l42B3
	add a, $0C
	jr .l42AC
.l42B3 ; 2A:42B3
	add a, $10
	ld d, a
	ld b, $03
	ld c, $00
	farcall AddrBook_DrawSlotName
	pop bc
	jr .l42C3
.l42C3 ; 2A:42C3
	ld a, c
	cp a, $FF
	jr z, .l42F6
	push bc
	ld e, c
	sla e
	ld d, $00
	ld hl, Table_SaveSenderAddr_SlotAddrs_Highlight
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	pop bc
	push hl
	ld de, $0028
	ld b, c
	xor a, a
	inc b
.l42DF ; 2A:42DF
	dec b
	jr z, .l42E6
	add a, $0C
	jr .l42DF
.l42E6 ; 2A:42E6
	add a, $10
	ld d, a
	ld b, $00
	ld c, $01
	farcall AddrBook_DrawSlotName
	pop hl
	jr .l42F6
.l42F6 ; 2A:42F6
	farcall AddrBook_UploadTextTiles
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ret

; ---- words $4306-$4312 (12 bytes) [PROBABLE] SRAM address table (6 words $A69D..$A82D (step $50)): the code indexes it by 2*n and loads hl=[table+2n] as the base of a save/record slot in SRAM ($A000-$BFFF); ld hl,$4306 at 2A:429B and 2A:42CD. Values are SRAM addresses, not ROM pointers

Table_SaveSenderAddr_SlotAddrs_Highlight:: ; 2A:4306
Table_2A_4306::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

SaveSenderAddr_SaveToSlot:: ; 2A:4312
	; [CONFIRMED] 189 insn(s) reached by static flow only; seeds: exec x189; min discovery hops 11;
	; entered by call from 2A:403E (PROBABLE code) [executed in 4 scenarios]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push bc
	ld b, $00
	sla c
	ld hl, Table_SaveSenderAddr_SlotAddrs_Save
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, $0010
	add hl, de
	ld d, h
	ld e, l
	pop bc
	ld a, [de]
	cp a, $00
	jr z, .l43A5
	push bc
	farcall Sprites_SaveSlotsToBank3
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $B0
	ld [wSpriteSlot2 + $01], a
	ld [wSpriteSlot3 + $01], a
	ld [wSpriteSlot4 + $01], a
	ld [wSpriteSlot5 + $01], a
	ld de, $0208
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
	push af
	ld a, $10
	ld [wSpriteSlots + 33], a
	ld [wSpriteSlots + 49], a
	ld [wSpriteSlots + 65], a
	ld [wSpriteSlots + 81], a
	farcall Sprites_RestoreSlotsFromBank3
	pop af
	pop bc
	dec a
	jr z, .l43A5
	ld a, $FF
	ret
.l43A5 ; 2A:43A5
	push bc
	push de
	play_sfx SFX_SAVE
	pop de
	pop bc
	push bc
	ld c, b
	ld b, $00
	sla c
	ld hl, Table_SaveSenderAddr_MailRecAddrs_Save
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld de, $00C9
	add hl, de
	pop bc
	push hl
	push bc
	ld b, $00
	sla c
	ld hl, Table_SaveSenderAddr_SlotAddrs_Save
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	pop bc
	pop hl
	push bc
	ld b, $10
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
.l43E7 ; 2A:43E7
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [hli]
	ld c, a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, c
	ld [de], a
	inc de
	dec b
	jr nz, .l43E7
	pop bc
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push bc
	ld c, b
	ld b, $00
	sla c
	ld hl, Table_SaveSenderAddr_MailRecAddrs_Save
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld de, $00ED
	add hl, de
	pop bc
	push hl
	push bc
	ld b, $00
	sla c
	ld hl, Table_SaveSenderAddr_SlotAddrs_Save
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, $0010
	add hl, de
	ld d, h
	ld e, l
	pop bc
	pop hl
	push bc
	ld b, $40
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
.l4440 ; 2A:4440
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [hli]
	ld c, a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, c
	ld [de], a
	inc de
	dec b
	jr nz, .l4440
	pop bc
	farcall SramCheck_Bank1Commit
	xor a, a
	ret

; ---- words $445F-$446B (12 bytes) [PROBABLE] SRAM address table (6 words $A69D..$A82D (step $50)): the code indexes it by 2*n and loads hl=[table+2n] as the base of a save/record slot in SRAM ($A000-$BFFF); ld hl,$445F at 2A:4324, 43D2, 4425. Values are SRAM addresses, not ROM pointers

Table_SaveSenderAddr_SlotAddrs_Save:: ; 2A:445F
Table_2A_445F::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

; ---- words $446B-$4483 (24 bytes) [PROBABLE] SRAM address table (12 words $A124..$AE13 (step $12D)): the code indexes it by 2*n and loads hl=[table+2n] as the base of a save/record slot in SRAM ($A000-$BFFF); ld hl,$446B at 2A:43BE and 2A:4411. Values are SRAM addresses, not ROM pointers

Table_SaveSenderAddr_MailRecAddrs_Save:: ; 2A:446B
Table_2A_446B::
	dw $A124, $A251, $A37E, $A4AB, $A5D8, $A705, $A832, $A95F
	dw $AA8C, $ABB9, $ACE6, $AE13

SaveSenderAddr_DrawSenderName:: ; 2A:4483
	; [CONFIRMED] 432 insn(s) reached by static flow only; seeds: exec x432; min discovery hops 11;
	; entered by call from 2A:41C4 (PROBABLE code) | 17 insn(s) executed; cut out of the PROBABLE
	; region 4483-483B by apply_coverage --split [executed in 5 scenarios]
	ld a, $10
	ld [wTextCellsLeft], a
.l4488 ; 2A:4488
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l4527
	cp a, $0D
	jr z, .l450C
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l44EA
	ld a, [wTextCellsLeft]
	cp a, $01
	jr nz, .l44AD

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4483-483B by apply_coverage --split
	pop af
	jp .l4527

.l44AD ; 2A:44AD
	; [CONFIRMED] 35 insn(s) executed; cut out of the PROBABLE region 4483-483B by apply_coverage
	; --split [executed in 5 scenarios]
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
	call SaveSenderAddr_DrawSenderName_BlitGlyphAdvance
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
	jr z, .l4527
	jr .l4488

.l44EA ; 2A:44EA
	; [PROBABLE] 30 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4483-483B by apply_coverage --split
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
	call SaveSenderAddr_DrawSenderName_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l4527
	jp .l4488
.l450C ; 2A:450C
	push bc
	push de
	push hl
	ld b, $20
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	call SaveSenderAddr_DrawSenderName_BlitBlankAdvance

.l4527 ; 2A:4527
	; [CONFIRMED] 348 insn(s) executed; cut out of the PROBABLE region 4483-483B by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	push de
	push hl
	ld b, $20
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
.l4538 ; 2A:4538
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call SaveSenderAddr_DrawSenderName_BlitBlankAdvance
	jr .l4538

SaveSenderAddr_DrawSenderName_BlitGlyphAdvance:: ; 2A:4547
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

SaveSenderAddr_DrawSenderName_BlitBlankAdvance:: ; 2A:455B
	push bc
	push de
	push hl
	ld b, $02
	ld c, $00
	ld hl, wGlyphBufLeft
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

SaveSenderAddr_RefreshSlotIcons:: ; 2A:4573
	push bc
	inc c
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push bc
	ld hl, wSpriteSlot7
	ld de, AddrBookShared_ObjTable_Entry4
	ld a, BANK(AddrBookShared_ObjTable_Entry4)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $00
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, .l45A7
	ld hl, wSpriteSlot7
	ld de, AddrBookShared_ObjTable_Entry8
	ld a, BANK(AddrBookShared_ObjTable_Entry8)
	ld b, $01
	farcall Sprite_InitSlot
.l45A7 ; 2A:45A7
	pop bc
	push bc
	ld hl, wSpriteSlot6
	ld de, AddrBookShared_ObjTable_Entry4
	ld a, BANK(AddrBookShared_ObjTable_Entry4)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $01
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, .l45D3
	ld hl, wSpriteSlot6
	ld de, AddrBookShared_ObjTable_Entry8
	ld a, BANK(AddrBookShared_ObjTable_Entry8)
	ld b, $01
	farcall Sprite_InitSlot
.l45D3 ; 2A:45D3
	pop bc
	push bc
	ld hl, wSpriteSlot5
	ld de, AddrBookShared_ObjTable_Entry4
	ld a, BANK(AddrBookShared_ObjTable_Entry4)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $02
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, .l45FF
	ld hl, wSpriteSlot5
	ld de, AddrBookShared_ObjTable_Entry8
	ld a, BANK(AddrBookShared_ObjTable_Entry8)
	ld b, $01
	farcall Sprite_InitSlot
.l45FF ; 2A:45FF
	pop bc
	push bc
	ld hl, wSpriteSlot4
	ld de, AddrBookShared_ObjTable_Entry4
	ld a, BANK(AddrBookShared_ObjTable_Entry4)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $03
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, .l462B
	ld hl, wSpriteSlot4
	ld de, AddrBookShared_ObjTable_Entry8
	ld a, BANK(AddrBookShared_ObjTable_Entry8)
	ld b, $01
	farcall Sprite_InitSlot
.l462B ; 2A:462B
	pop bc
	push bc
	ld hl, wSpriteSlot3
	ld de, AddrBookShared_ObjTable_Entry4
	ld a, BANK(AddrBookShared_ObjTable_Entry4)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $04
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, .l4657
	ld hl, wSpriteSlot3
	ld de, AddrBookShared_ObjTable_Entry8
	ld a, BANK(AddrBookShared_ObjTable_Entry8)
	ld b, $01
	farcall Sprite_InitSlot
.l4657 ; 2A:4657
	pop bc
	push bc
	ld hl, wSpriteSlot2
	ld de, AddrBookShared_ObjTable_Entry4
	ld a, BANK(AddrBookShared_ObjTable_Entry4)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $05
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, .l4683
	ld hl, wSpriteSlot2
	ld de, AddrBookShared_ObjTable_Entry8
	ld a, BANK(AddrBookShared_ObjTable_Entry8)
	ld b, $01
	farcall Sprite_InitSlot
.l4683 ; 2A:4683
	pop bc
	pop bc
	ld a, c
	cp a, $00
	jp z, .l47BD
	dec a
	jp z, .l46A3
	dec a
	jp z, .l46D2
	dec a
	jp z, .l4701
	dec a
	jp z, .l4730
	dec a
	jp z, .l475F
	dec a
	jp z, .l478E
.l46A3 ; 2A:46A3
	push bc
	ld hl, wSpriteSlot7
	ld de, Table_AddrSlotIcon_Anims_Entry12
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $00
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, .l46CE
	ld hl, wSpriteSlot7
	ld de, Table_AddrSlotIcon_Anims_Entry16
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.l46CE ; 2A:46CE
	pop bc
	jp .l47BD
.l46D2 ; 2A:46D2
	push bc
	ld hl, wSpriteSlot6
	ld de, Table_AddrSlotIcon_Anims_Entry12
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $01
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, .l46FD
	ld hl, wSpriteSlot6
	ld de, Table_AddrSlotIcon_Anims_Entry16
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.l46FD ; 2A:46FD
	pop bc
	jp .l47BD
.l4701 ; 2A:4701
	push bc
	ld hl, wSpriteSlot5
	ld de, Table_AddrSlotIcon_Anims_Entry12
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $02
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, .l472C
	ld hl, wSpriteSlot5
	ld de, Table_AddrSlotIcon_Anims_Entry16
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.l472C ; 2A:472C
	pop bc
	jp .l47BD
.l4730 ; 2A:4730
	push bc
	ld hl, wSpriteSlot4
	ld de, Table_AddrSlotIcon_Anims_Entry12
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $03
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, .l475B
	ld hl, wSpriteSlot4
	ld de, Table_AddrSlotIcon_Anims_Entry16
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.l475B ; 2A:475B
	pop bc
	jp .l47BD
.l475F ; 2A:475F
	push bc
	ld hl, wSpriteSlot3
	ld de, Table_AddrSlotIcon_Anims_Entry12
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $04
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, .l478A
	ld hl, wSpriteSlot3
	ld de, Table_AddrSlotIcon_Anims_Entry16
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.l478A ; 2A:478A
	pop bc
	jp .l47BD
.l478E ; 2A:478E
	push bc
	ld hl, wSpriteSlot2
	ld de, Table_AddrSlotIcon_Anims_Entry12
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $05
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, .l47B9
	ld hl, wSpriteSlot2
	ld de, Table_AddrSlotIcon_Anims_Entry16
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.l47B9 ; 2A:47B9
	pop bc
	jp .l47BD
.l47BD ; 2A:47BD
	ld a, $18
	ld [wSpriteSlot1], a
	ld a, $10
	ld [wSpriteSlot1 + $01], a
	ld a, $28
	ld [wSpriteSlot7], a
	ld a, $10
	ld [wSpriteSlot7 + $01], a
	ld a, $34
	ld [wSpriteSlot6], a
	ld a, $10
	ld [wSpriteSlot6 + $01], a
	ld a, $40
	ld [wSpriteSlot5], a
	ld a, $10
	ld [wSpriteSlot5 + $01], a
	ld a, $4C
	ld [wSpriteSlot4], a
	ld a, $10
	ld [wSpriteSlot4 + $01], a
	ld a, $58
	ld [wSpriteSlot3], a
	ld a, $10
	ld [wSpriteSlot3 + $01], a
	ld a, $64
	ld [wSpriteSlot2], a
	ld a, $10
	ld [wSpriteSlot2 + $01], a
	pop bc
	ldh a, [hJoyPressed]
	and a, PADF_UP | PADF_DOWN
	call nz, SaveSenderAddr_CursorMoveEffect
	ret

SaveSenderAddr_IsSlotUsed:: ; 2A:480C
	push bc
	push af
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ld e, a
	sla e
	ld d, $00
	ld hl, Table_SaveSenderAddr_SlotAddrs_IsUsed
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld hl, $0010
	add hl, de
	ld a, [hl]
	cp a, $00
	jr z, .l4837
	ld a, $00
	pop bc
	ret
.l4837 ; 2A:4837
	ld a, $FF
	pop bc
	ret

; ---- words $483B-$4847 (12 bytes) [PROBABLE] SRAM address table (6 words $A69D..$A82D (step $50)): the code indexes it by 2*n and loads hl=[table+2n] as the base of a save/record slot in SRAM ($A000-$BFFF); ld hl,$483B at 2A:4821. Values are SRAM addresses, not ROM pointers

Table_SaveSenderAddr_SlotAddrs_IsUsed:: ; 2A:483B
Table_2A_483B::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

SaveSenderAddr_CursorMoveEffect:: ; 2A:4847
	; [CONFIRMED] 187 insn(s) reached by static flow only; seeds: exec x187; min discovery hops 12;
	; entered by callcc from 2A:4808 (PROBABLE code) | 118 insn(s) executed; cut out of the PROBABLE
	; region 4847-4A3D by apply_coverage --split [executed in 1 scenarios]
	push bc
	ld a, c
	cp a, $00
	jp z, .l4867
	cp a, $01
	jp z, .l489C
	cp a, $02
	jp z, .l48D1
	cp a, $03
	jp z, .l4906
	cp a, $04
	jp z, .l493B
	cp a, $05
	jp z, .l4970
.l4867 ; 2A:4867
	ld hl, wSpriteSlot7
	ld de, AddrBookShared_ObjTable_Entry12
	ld a, BANK(AddrBookShared_ObjTable_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $00
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, .l488F
	ld hl, wSpriteSlot7
	ld de, AddrBookShared_ObjTable_Entry16
	ld a, BANK(AddrBookShared_ObjTable_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.l488F ; 2A:488F
	ld a, $28
	ld [wSpriteSlot7], a
	ld a, $10
	ld [wSpriteSlot7 + $01], a
	jp .l49A5
.l489C ; 2A:489C
	ld hl, wSpriteSlot6
	ld de, AddrBookShared_ObjTable_Entry12
	ld a, BANK(AddrBookShared_ObjTable_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $01
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, .l48C4
	ld hl, wSpriteSlot6
	ld de, AddrBookShared_ObjTable_Entry16
	ld a, BANK(AddrBookShared_ObjTable_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.l48C4 ; 2A:48C4
	ld a, $34
	ld [wSpriteSlot6], a
	ld a, $10
	ld [wSpriteSlot6 + $01], a
	jp .l49A5
.l48D1 ; 2A:48D1
	ld hl, wSpriteSlot5
	ld de, AddrBookShared_ObjTable_Entry12
	ld a, BANK(AddrBookShared_ObjTable_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $02
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, .l48F9
	ld hl, wSpriteSlot5
	ld de, AddrBookShared_ObjTable_Entry16
	ld a, BANK(AddrBookShared_ObjTable_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.l48F9 ; 2A:48F9
	ld a, $40
	ld [wSpriteSlot5], a
	ld a, $10
	ld [wSpriteSlot5 + $01], a
	jp .l49A5
.l4906 ; 2A:4906
	ld hl, wSpriteSlot4
	ld de, AddrBookShared_ObjTable_Entry12
	ld a, BANK(AddrBookShared_ObjTable_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $03
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, .l492E
	ld hl, wSpriteSlot4
	ld de, AddrBookShared_ObjTable_Entry16
	ld a, BANK(AddrBookShared_ObjTable_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.l492E ; 2A:492E
	ld a, $4C
	ld [wSpriteSlot4], a
	ld a, $10
	ld [wSpriteSlot4 + $01], a
	jp .l49A5
.l493B ; 2A:493B
	ld hl, wSpriteSlot3
	ld de, AddrBookShared_ObjTable_Entry12
	ld a, BANK(AddrBookShared_ObjTable_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $04
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, .l4963
	ld hl, wSpriteSlot3
	ld de, AddrBookShared_ObjTable_Entry16
	ld a, BANK(AddrBookShared_ObjTable_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.l4963 ; 2A:4963
	ld a, $58
	ld [wSpriteSlot3], a
	ld a, $10
	ld [wSpriteSlot3 + $01], a
	jp .l49A5
.l4970 ; 2A:4970
	ld hl, wSpriteSlot2
	ld de, AddrBookShared_ObjTable_Entry12
	ld a, BANK(AddrBookShared_ObjTable_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $05
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, .l4998

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4847-4A3D by apply_coverage --split
	ld hl, wSpriteSlot2
	ld de, AddrBookShared_ObjTable_Entry16
	ld a, BANK(AddrBookShared_ObjTable_Entry16)
	ld b, $01
	farcall Sprite_InitSlot

.l4998 ; 2A:4998
	; [CONFIRMED] 64 insn(s) executed; cut out of the PROBABLE region 4847-4A3D by apply_coverage
	; --split [executed in 4 scenarios]
	ld a, $64
	ld [wSpriteSlot2], a
	ld a, $10
	ld [wSpriteSlot2 + $01], a
	jp .l49A5
.l49A5 ; 2A:49A5
	ld b, $1E
	ld b, $01
.loop ; 2A:49A9
	push bc
	farcall Sprite_UpdateAll
	farcall Joypad_Update
	call VBlank_Wait
	pop bc
	ldh a, [hJoyHeld]
	and a, PADF_UP | PADF_DOWN
	jr nz, .l49C3
	dec b
	jr nz, .loop
.l49C3 ; 2A:49C3
	pop bc
	ret

SaveSenderAddr_LoadCaption:: ; 2A:49C5
	push bc
	push de
	ld hl, String_SaveSenderAddr_Caption
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, BANK(String_SaveSenderAddr_Caption)
	ld bc, wTileStage2 + $280
	ld de, wTileStage2 + $3C0
	farcall TextTiles_RenderLine
	ld hl, $4A6F
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $2A
	ld bc, wTileStage2 + $500
	ld de, wTileStage2 + $640
	farcall TextTiles_RenderLine
	ld hl, $4A78
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $2A
	ld bc, wTileStage2 + $780
	ld de, wTileStage2 + $8C0
	farcall TextTiles_RenderLine
	ld hl, $4A81
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $2A
	ld bc, wTileStage2 + $A00
	ld de, wTileStage2 + $B40
	farcall TextTiles_RenderLine
	ld hl, $4A8A
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $2A
	ld bc, wTileStage2 + $C80
	ld de, wTileStage2 + $DC0
	farcall TextTiles_RenderLine
	pop de
	pop bc
	ret

; ---- text $4A3D-$4A66 (41 bytes) [PROBABLE] text: 6 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated) [clipped from 4A3D-4A93 by higher-priority evidence]

PUSHC sjis
String_2A_4A3D:: ; 2A:4A3D
	db "　　アドレスを　せんたくしてください　　", 0
POPC

; ---- text $4A66-$4A93 (45 bytes) [PROBABLE] text: the caption "　セーブ" (loaded by SaveSenderAddr_LoadCaption, 2A:49C7, 19 hits in 6 scenarios) and four more NUL terminated strings
; ("するばしょを　えらんでください　" in four pieces).  The survey had typed the first six bytes as a code-pointer table (dw $4081, $5A83, $5B81), which made three spurious labels in the middle of code
; (Label_2A_4081 here, Label_2A_5A83 and Label_2A_5B81 in profile_editor.asm: no instruction ever referenced them); they are gone

PUSHC sjis
String_SaveSenderAddr_Caption:: ; 2A:4A66
Table_2A_4A66::
	db "　セーブ", 0
	db "するばし", 0
	db "ょを　え", 0
	db "らんでく", 0
	db "ださい　", 0
POPC

; ---- zero $4A93-$4AA0 (13 bytes) [PROBABLE] 13 bytes of $00 between the last string and the tiles at 4AA0 (padding)
	ds $D, $00
