; engine/address_book/unreferenced_confirm_screen.asm
; bank 2C, $741C-$7740 (804 bytes); pinned by layout.link
; address confirmation screen with no caller (hypothesis)

SECTION "engine/address_book/unreferenced_confirm_screen", ROMX

AddrScreenUnused_Run:: ; 2C:741C
Function_2C_741C::
	; [PROBABLE] 2 insn(s) (call $746F ; ld b,$3C) falling into the validated code region 7421;
	; follows the frame data terminator 01 00 04; no direct entry found | forced execution: 2/2
	; instruction starts ran in forced_dead (traces/forced/, not natural evidence; status unchanged)
	call AddrScreenUnused_InitScreen
	ld b, $3C

.loop ; 2C:7421
	; [PROBABLE] 20 insn(s) reached by static flow only; seeds: site x20; min discovery hops 0;
	; entered by jrcc from 2C:7433 (PROBABLE code) | forced execution: 18/20 instruction starts ran
	; in forced_dead (traces/forced/, not natural evidence; status unchanged)
	push bc
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_Update
	pop bc
	dec b
	jr nz, .loop
	ld de, $0204
	push de
	pop de
	farcall Dialog_Show
	push af
	farcall Palette_FadeOutToWhite
	pop af
	dec a
	jr z, .l744E
	ld a, $FF
	ret
.l744E ; 2C:744E
	xor a, a
	ret

	; [PROBABLE] 3 insn(s) (ldh a,[$FFA5] ; and $01 ; jr z,$745E): button test whose sibling tests
	; 745E/746D are its jr z targets; well-formed instruction chain (clean decode, all direct
	; targets land on instruction starts, lands exactly on the next code region); no direct
	; caller/table entry found: entry HYPOTHESIS
	ldh a, [hJoyPressed]
	and a, PADF_A
	jr z, .l745E

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: site x3; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

.l745E ; 2C:745E
	; [PROBABLE] 3 insn(s) (ldh a,[$FFA5] ; and $02 ; jr z,$746D); entered by jr z from 2C:7454
	; (this classification)
	ldh a, [hJoyPressed]
	and a, PADF_B
	jr z, .l746D

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: site x3; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

.l746D ; 2C:746D
	; [PROBABLE] 1 insn (jr $7421); entered by jr z from 2C:7462 (this classification)
	jr .loop

AddrScreenUnused_InitScreen:: ; 2C:746F
Function_2C_746F::
	; [PROBABLE] 325 insn(s) reached by static flow only; seeds: site x325; min discovery hops 0;
	; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code |
	; forced execution: 151/325 instruction starts ran in forced_dead (traces/forced/, not natural
	; evidence; status unchanged)
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	farcall AddrBook_UploadTextTiles
	farcall LCDOff
	ld de, $9301
	ld hl, Gfx_AddrScreenUnused_Tiles9300Vb1
	ld a, BANK(Gfx_AddrScreenUnused_Tiles9300Vb1)
	ld b, $97
	ld c, $12
	farcall Gfx_StartHDMAWithService
	ld de, $8000
	ld hl, Gfx_AddrScreenUnused_Tiles8000
	ld a, BANK(Gfx_AddrScreenUnused_Tiles8000)
	ld b, $98
	ld c, $09
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_AddrScreenUnused_Bg
	ld a, BANK(Palette_AddrScreenUnused_Bg)
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_AddrScreenUnused_Screen
	ld a, BANK(Tilemap_AddrScreenUnused_Screen)
	farcall Tilemap_CopyRectAndAttr
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, Palette_AddrScreenUnused_Obj
	ld a, BANK(Palette_AddrScreenUnused_Obj)
	farcall Palette_LoadToBuffer
	ld hl, wSpriteSlot1
	ld de, Table_AddrScreenUnused_Objects
	ld a, BANK(Table_AddrScreenUnused_Objects)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1008
	ld hl, wSpriteSlot3
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
	farcall LCDOn
	ld bc, $0300
	ld de, $0420
	ld hl, wEditAddressBuf
	call AddrScreenUnused_DrawTextLine21
	ld bc, $0300
	ld de, $1008
	ld hl, wEditAddressBuf + $14
	call AddrScreenUnused_DrawTextLine25
	ld bc, $0300
	ld de, $1C08
	ld hl, wEditAddressBuf + $2C
	call AddrScreenUnused_DrawTextLine21
	farcall TextTiles_UploadBuffersShort
	ld bc, $0000
	ret

AddrScreenUnused_DrawTextLine21:: ; 2C:755C
Function_2C_755C::
	ld a, $15
	ld [wTextCellsLeft], a
.l7561 ; 2C:7561
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l75FC
	cp a, $0D
	jr z, .l75E1
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l75BC
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
	call AddrScreenUnused_DrawTextLine21_BlitGlyphAdvance
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
	jr z, .l75FC
	cp a, $01
	jr z, .l75FC
	jr .l7561
.l75BC ; 2C:75BC
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
	call AddrScreenUnused_DrawTextLine21_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l75FC
	cp a, $01
	jr z, .l75FC
	jr .l7561
.l75E1 ; 2C:75E1
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
	call AddrScreenUnused_DrawTextLine21_BlitBlankAdvance
.l75FC ; 2C:75FC
	push bc
	push de
	push hl
	ld b, $20
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
.l760D ; 2C:760D
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AddrScreenUnused_DrawTextLine21_BlitBlankAdvance
	jr .l760D

AddrScreenUnused_DrawTextLine21_BlitGlyphAdvance:: ; 2C:761C
Function_2C_761C::
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

AddrScreenUnused_DrawTextLine21_BlitBlankAdvance:: ; 2C:7630
Function_2C_7630::
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

AddrScreenUnused_DrawTextLine25:: ; 2C:7648
Function_2C_7648::
	ld a, $19
	ld [wTextCellsLeft], a
.l764D ; 2C:764D
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l76E8
	cp a, $0D
	jr z, .l76CD
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l76A8
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
	call AddrScreenUnused_DrawTextLine25_BlitGlyphAdvance
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
	jr z, .l76E8
	cp a, $01
	jr z, .l76E8
	jr .l764D
.l76A8 ; 2C:76A8
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
	call AddrScreenUnused_DrawTextLine25_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l76E8
	cp a, $01
	jr z, .l76E8
	jr .l764D
.l76CD ; 2C:76CD
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
	call AddrScreenUnused_DrawTextLine25_BlitBlankAdvance
.l76E8 ; 2C:76E8
	push bc
	push de
	push hl
	ld b, $20
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
.l76F9 ; 2C:76F9
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AddrScreenUnused_DrawTextLine25_BlitBlankAdvance
	jr .l76F9

AddrScreenUnused_DrawTextLine25_BlitGlyphAdvance:: ; 2C:7708
Function_2C_7708::
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

AddrScreenUnused_DrawTextLine25_BlitBlankAdvance:: ; 2C:771C
Function_2C_771C::
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

; ---- zero $7734-$7740 (12 bytes) [PROBABLE] all-zero padding before an aligned tile/data block (mapper hint: padding-like)
	ds $C, $00
