; engine/address_book/view.asm
; bank 2F, $5098-$57F2 (1882 bytes); pinned by layout.link
; address book entry view screen, store entry to SRAM

SECTION "engine/address_book/view", ROMX

AbookView_Run:: ; 2F:5098
	; [CONFIRMED] 26 insn(s) reached by static flow only; seeds: exec x26; min discovery hops 2;
	; entered by far from 2F:7F3D (PROBABLE code) | upgraded by classifier 6: all 26 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $10
	ld [wStatSplitLine], a
	ld a, $0B
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call AbookView_SetupScreen
	ld d, $3C
.loop ; 2F:50BD
	push bc
	push de
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop de
	pop bc
	dec d
	jr .l5136

	; [PROBABLE] 16 insn(s) (push bc ; ld de,$020B ; push af ; ldh a,[$FF70] ... ldh [$FF8D],a ; ldh
	; [$FF70],a ; pop af ; push de ; pop de) falling into the code at 50ED; well-formed instruction
	; chain (clean decode, all direct targets land on instruction starts, lands exactly on the next
	; code region); no direct caller/table entry found: entry HYPOTHESIS
	push bc
	ld de, $020B
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

	; [PROBABLE] 102 insn(s) reached by static flow only; seeds: exec x23, site x79; min discovery
	; hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with
	; decoded code | 31 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 50ED-51B5 by apply_coverage --split
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
	jr nz, .l5122
	push bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	call Abook_StoreEntryToSram
	xor a, a
	ret
.l5122 ; 2F:5122
	push bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, $FF
	ret

.l5136 ; 2F:5136
	; [CONFIRMED] 23 insn(s) executed; cut out of the PROBABLE region 50ED-51B5 by apply_coverage
	; --split [executed in 3 scenarios]
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l5164
	push bc
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, $FF
	ret
.l5164 ; 2F:5164
	jp .loop

Abook_StoreEntryToSram:: ; 2F:5167
	; [PROBABLE] 48 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 50ED-51B5 by apply_coverage --split
	push af
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D726
	ld a, [hl]
	ld c, a
	ld b, $00
	sla c
	ld hl, Abook_SlotAddrTable4
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld h, d
	ld l, e
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld b, $10
	ld de, $D514
.l519C ; 2F:519C
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .l519C
	pop hl
	ld de, $0010
	add hl, de
	ld b, $40
	ld de, $D4C0
.l51AC ; 2F:51AC
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .l51AC
	pop bc
	pop af
	ret

; ---- words $51B5-$51C1 (12 bytes) [PROBABLE] 6 SRAM record addresses $A69D..$A82D, constant stride $50 (80), verified arithmetic progression; indexed table read with 2F:5178 (sla c; ld hl,$51B5; add hl,bc)

Abook_SlotAddrTable4:: ; 2F:51B5
Table_2F_51B5::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

AbookView_SetupScreen:: ; 2F:51C1
	; [CONFIRMED] 172 insn(s) reached by static flow only; seeds: exec x172; min discovery hops 3;
	; entered by call from 2F:50B8 (PROBABLE code) | 81 insn(s) executed; cut out of the PROBABLE
	; region 51C1-5383 by apply_coverage --split [executed in 3 scenarios]
	push bc
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	farcall LCDOff
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, Palette_AddrBookEntry_Obj
	ld a, $2C
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_AddrBookEntry_Bg
	ld a, $2C
	farcall Palette_LoadToBuffer
	ld de, $9301
	ld hl, Gfx_AbookView_Tiles9300Vb1
	ld a, $29
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9701
	ld hl, Gfx_AbookView_Tiles9700Vb1
	ld a, $29
	ld b, $98
	ld c, $04
	farcall Gfx_StartHDMAWithService
	ld de, $8F00
	ld hl, Gfx_AddrBookEntry_Tiles8F00
	ld a, $2A
	ld b, $97
	ld c, $0E
	farcall Gfx_StartHDMAWithService
	ld de, $8000
	ld hl, Gfx_AddrBookEntry_Tiles8000
	ld a, $2A
	ld b, $97
	ld c, $0B
	farcall Gfx_StartHDMAWithService
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Data_AddrBookEntry_TilemapAttr
	ld a, $2C
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	farcall LCDOn
	ld hl, wSpriteSlot1
	ld de, Table_Abook_ViewCursorAnims
	ld a, $2F
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $20
	ld [wSpriteSlot1], a
	ld a, $08
	ld [wSpriteSlot1 + $01], a
	ld bc, $0000
	pop bc
	ld a, b
	cp a, $FF
	jr nz, .l52B6
	call AbookView_LoadAndDraw
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeInFromWhite
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $10
	ld [wStatSplitLine], a
	ld a, $0B
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	ret

.l52B6 ; 2F:52B6
	; [PROBABLE] 20 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 51C1-5383 by apply_coverage --split
	call AbookView_DrawFromBuffers
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeInFromWhite
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $10
	ld [wStatSplitLine], a
	ld a, $0B
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	ret

AbookView_LoadAndDraw:: ; 2F:52E9
	; [CONFIRMED] 71 insn(s) executed; cut out of the PROBABLE region 51C1-5383 by apply_coverage
	; --split [executed in 3 scenarios]
	push bc
	ld b, $00
	sla c
	ld hl, Abook_SlotAddrTable5
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld h, d
	ld l, e
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld b, $10
	ld de, $D514
.l5312 ; 2F:5312
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .l5312
	pop hl
	ld de, $0010
	add hl, de
	ld b, $40
	ld de, $D4C0
.l5322 ; 2F:5322
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .l5322
	pop bc
	push bc
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $0438
	ld hl, wEditNameBuf
	call AbookView_DrawName
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $1438
	ld hl, wEditAddressBuf
	farcall AbookView_DrawAddrLine1
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $2008
	ld hl, wEditAddressBuf + $10
	farcall AbookView_DrawAddrLine2
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $2C08
	ld hl, wEditAddressBuf + $28
	farcall AbookView_DrawAddrLine3
	farcall AddrBook_UploadEntryTextTiles
	pop bc
	ret

; ---- words $5383-$538F (12 bytes) [PROBABLE] 6 SRAM record addresses $A69D..$A82D, constant stride $50 (80), verified arithmetic progression; indexed table read with 2F:52EE

Abook_SlotAddrTable5:: ; 2F:5383
Table_2F_5383::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

AbookView_DrawFromBuffers:: ; 2F:538F
	; [PROBABLE] 32 insn(s) reached by static flow only; seeds: exec x32; min discovery hops 5;
	; entered by call from 2F:52B6 (PROBABLE code)
	push bc
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $0438
	ld hl, wEditNameBuf
	call AbookView_DrawName
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $1438
	ld hl, wEditAddressBuf
	farcall AbookView_DrawAddrLine1
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $2008
	ld hl, wEditAddressBuf + $10
	farcall AbookView_DrawAddrLine2
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $2C08
	ld hl, wEditAddressBuf + $28
	farcall AbookView_DrawAddrLine3
	farcall AddrBook_UploadEntryTextTiles
	pop bc
	ret

; ---- words $53E9-$53F5 (12 bytes) [PROBABLE] 6 SRAM record addresses $A69D..$A82D, constant stride $50 (80), verified arithmetic progression; indexed table read with no direct ld hl,imm found

Abook_SlotAddrTable6:: ; 2F:53E9
Table_2F_53E9::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

AbookView_DrawName:: ; 2F:53F5
	; [CONFIRMED] 500 insn(s) reached by static flow only; seeds: exec x500; min discovery hops 5;
	; entered by call from 2F:5339 (PROBABLE code) | 51 insn(s) executed; cut out of the PROBABLE
	; region 53F5-57A5 by apply_coverage --split [executed in 2 scenarios]
	ld a, $10
	ld [wTextCellsLeft], a
.l53FA ; 2F:53FA
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l5495
	cp a, $0D
	jr z, .l547A
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l5455
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
	call AbookView_DrawName_Glyph
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
	jr z, .l5495
	cp a, $01
	jr z, .l5495
	jr .l53FA

.l5455 ; 2F:5455
	; [PROBABLE] 32 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 53F5-57A5 by apply_coverage --split
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
	call AbookView_DrawName_Glyph
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l5495
	cp a, $01
	jr z, .l5495
	jr .l53FA
.l547A ; 2F:547A
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
	call AbookView_DrawName_Pad

.l5495 ; 2F:5495
	; [CONFIRMED] 56 insn(s) executed; cut out of the PROBABLE region 53F5-57A5 by apply_coverage
	; --split [executed in 2 scenarios]
	push bc
	push de
	push hl
	ld b, $20
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
.l54A6 ; 2F:54A6
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AbookView_DrawName_Pad
	jr .l54A6

AbookView_DrawName_Glyph:: ; 2F:54B5
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

AbookView_DrawName_Pad:: ; 2F:54C9
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

AbookView_DrawAddrLine1:: ; 2F:54E1
	ld a, $11
	ld [wTextCellsLeft], a
.l54E6 ; 2F:54E6
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l5581
	cp a, $0D
	jr z, .l5566
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l5541

	; [PROBABLE] 37 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 53F5-57A5 by apply_coverage --split
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
	call AbookView_DrawAddrLine1_Glyph
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
	jr z, .l5581
	cp a, $01
	jr z, .l5581
	jr .l54E6

.l5541 ; 2F:5541
	; [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 53F5-57A5 by apply_coverage
	; --split [executed in 4 scenarios]
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
	call AbookView_DrawAddrLine1_Glyph
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l5581
	cp a, $01
	jr z, .l5581
	jr .l54E6

.l5566 ; 2F:5566
	; [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 53F5-57A5 by apply_coverage --split
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
	call AbookView_DrawAddrLine1_Pad

.l5581 ; 2F:5581
	; [CONFIRMED] 56 insn(s) executed; cut out of the PROBABLE region 53F5-57A5 by apply_coverage
	; --split [executed in 3 scenarios]
	push bc
	push de
	push hl
	ld b, $20
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
.l5592 ; 2F:5592
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AbookView_DrawAddrLine1_Pad
	jr .l5592

AbookView_DrawAddrLine1_Glyph:: ; 2F:55A1
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

AbookView_DrawAddrLine1_Pad:: ; 2F:55B5
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

AbookView_DrawAddrLine2:: ; 2F:55CD
	ld a, $19
	ld [wTextCellsLeft], a
.l55D2 ; 2F:55D2
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l566D
	cp a, $0D
	jr z, .l5652
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l562D

	; [PROBABLE] 37 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 53F5-57A5 by apply_coverage --split
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
	call AbookView_DrawAddrLine2_Glyph
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
	jr z, .l566D
	cp a, $01
	jr z, .l566D
	jr .l55D2

.l562D ; 2F:562D
	; [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 53F5-57A5 by apply_coverage
	; --split [executed in 3 scenarios]
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
	call AbookView_DrawAddrLine2_Glyph
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l566D
	cp a, $01
	jr z, .l566D
	jr .l55D2

.l5652 ; 2F:5652
	; [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 53F5-57A5 by apply_coverage --split
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
	call AbookView_DrawAddrLine2_Pad

.l566D ; 2F:566D
	; [CONFIRMED] 56 insn(s) executed; cut out of the PROBABLE region 53F5-57A5 by apply_coverage
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
.l567E ; 2F:567E
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AbookView_DrawAddrLine2_Pad
	jr .l567E

AbookView_DrawAddrLine2_Glyph:: ; 2F:568D
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

AbookView_DrawAddrLine2_Pad:: ; 2F:56A1
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

AbookView_DrawAddrLine3:: ; 2F:56B9
	ld a, $19
	ld [wTextCellsLeft], a
.l56BE ; 2F:56BE
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l5759
	cp a, $0D
	jr z, .l573E
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l5719

	; [PROBABLE] 37 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 53F5-57A5 by apply_coverage --split
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
	call AbookView_DrawAddrLine3_Glyph
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
	jr z, .l5759
	cp a, $01
	jr z, .l5759
	jr .l56BE

.l5719 ; 2F:5719
	; [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 53F5-57A5 by apply_coverage
	; --split [executed in 1 scenarios]
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
	call AbookView_DrawAddrLine3_Glyph
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l5759
	cp a, $01
	jr z, .l5759
	jr .l56BE

.l573E ; 2F:573E
	; [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 53F5-57A5 by apply_coverage --split
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
	call AbookView_DrawAddrLine3_Pad

.l5759 ; 2F:5759
	; [CONFIRMED] 42 insn(s) executed; cut out of the PROBABLE region 53F5-57A5 by apply_coverage
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
.l576A ; 2F:576A
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AbookView_DrawAddrLine3_Pad
	jr .l576A

AbookView_DrawAddrLine3_Glyph:: ; 2F:5779
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

AbookView_DrawAddrLine3_Pad:: ; 2F:578D
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

; ---- zero $57A5-$57B0 (11 bytes) [PROBABLE] 11 zero bytes of padding between a function and the object table at 57B0
	ds $B, $00

; ---- ptrtable $57B0-$57C0 (16 bytes) [PROBABLE] 8 words, all inside $57C0-$57F2 of the same bank (animation/OAM frame data); tables of 4-byte entries (2 words) addressed by ld de,imm before FarCall 00:0A82 (init_object_from_table: reads the 4-byte entry number B&$7F of the table at DE); each 16-byte table = 4 identical-pair entries; caller 2F:5263 ld de,$57B0 (a=$2F b=$81)

Table_Abook_ViewCursorAnims:: ; 2F:57B0
Table_2F_57B0::
	sprite_object_entry Abook_ViewCursor_ObjAnimData, SpriteScript_2F_57EF ; entry 0
	sprite_object_entry Abook_ViewCursor_ObjAnimData, SpriteScript_2F_57EF ; entry 1
	sprite_object_entry Abook_ViewCursor_ObjAnimData, SpriteScript_2F_57EF ; entry 2
	sprite_object_entry Abook_ViewCursor_ObjAnimData, SpriteScript_2F_57EF ; entry 3

; ---- data $57C0-$57F2 (50 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; target of the 57B0 table (57C0, 57EF)

Abook_ViewCursor_ObjAnimData:: ; 2F:57C0
Data_2F_57C0::
	sprite_frame_table SpriteFrame_2F_57C2
SpriteFrame_2F_57C2:: ; 2F:57C2
	sprite_frame 11
	sprite_oam 1, 5, $06, 2
	sprite_oam 9, -3, $07, 2
	sprite_oam 9, 5, $08, 2
	sprite_oam 17, -3, $09, 2
	sprite_oam 17, 5, $0A, 2
	sprite_oam 30, 0, $00, 1
	sprite_oam 30, 8, $01, 1
	sprite_oam 38, 0, $02, 1
	sprite_oam 38, 8, $03, 1
	sprite_oam 46, 0, $04, 1
	sprite_oam 46, 8, $05, 1
SpriteScript_2F_57EF:: ; 2F:57EF
	sprite_anim 1
	sprite_anim_step 0, 4
