; engine/mail/mail_viewer_body.asm
; bank 2B, $7B02-$7F44 (1090 bytes); pinned by layout.link
; received mail viewer, page 2 (body text)

SECTION "engine/mail/mail_viewer_body", ROMX

MailView_BodyPage:: ; 2B:7B02
	; [CONFIRMED] 268 insn(s) reached by static flow only; seeds: exec x268; min discovery hops 8;
	; entered by far from 2B:64E4 (PROBABLE code) [executed in 2 scenarios]
	push bc
	push bc
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
	pop bc
	call MailView_BodyPage_InitScreen
	pop bc
	ld c, b

MailView_BodyPage_Loop:: ; 2B:7B2A
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .l7B68
	push bc
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	xor a, a
	ret
.l7B68 ; 2B:7B68
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l7B99
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
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, $FF
	ret
.l7B99 ; 2B:7B99
	jr MailView_BodyPage_Loop

MailView_BodyPage_InitScreen:: ; 2B:7B9B
	push bc
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	call VBlank_Wait
	ld bc, $0040
	ld de, $D800
	ld hl, MailBody_BgPalette
	ld a, $28
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D840
	ld hl, $4B30
	ld a, $28
	farcall Palette_LoadToBuffer
	ld de, $9301
	ld hl, MailBody_Tiles_42C0
	ld a, $28
	ld b, $95
	ld c, $21
	farcall Gfx_StartHDMA
	call VBlank_Wait
	ld de, $8000
	ld hl, MailBody_Tiles_44D0
	ld a, $28
	ld b, $98
	ld c, $08
	farcall Gfx_StartHDMA
	call VBlank_Wait
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MailView_BodyPage
	ld a, $28
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	call VBlank_Wait
	ld hl, $DA10
	ld de, MailBody_ObjTable
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $0808
	ld hl, $DA10
	call Sprite_SetPosition
	pop bc
	push bc
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push bc
	ld c, b
	ld b, $00
	sla c
	ld hl, Table_MailView_BodyPage_RecAddrs
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld a, $02
	ld [hl], a
	farcall SramCheck_Bank0Commit
	call VBlank_Wait
	pop bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push bc
	ld c, b
	ld b, $00
	sla c
	ld hl, Table_MailView_BodyPage_RecAddrs
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld de, $0009
	add hl, de
	ld de, $D400
	ld b, $C0
.loop ; 2B:7C89
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	call VBlank_Wait
	ld b, $00
	call MailView_BodyPage_FindLine
	ld b, $03
	ld c, $00
	ld de, $0008
	call MailView_BodyPage_DrawTextLine24
	call VBlank_Wait
	ld b, $01
	call MailView_BodyPage_FindLine
	ld b, $03
	ld c, $00
	ld d, $0C
	ld e, $08
	call MailView_BodyPage_DrawTextLine24
	call VBlank_Wait
	ld b, $02
	call MailView_BodyPage_FindLine
	ld b, $03
	ld c, $00
	ld d, $18
	ld e, $08
	call MailView_BodyPage_DrawTextLine24
	call VBlank_Wait
	ld b, $03
	call MailView_BodyPage_FindLine
	ld b, $03
	ld c, $00
	ld d, $24
	ld e, $08
	call MailView_BodyPage_DrawTextLine24
	call VBlank_Wait
	ld b, $04
	call MailView_BodyPage_FindLine
	ld b, $03
	ld c, $00
	ld d, $30
	ld e, $08
	call MailView_BodyPage_DrawTextLine24
	call VBlank_Wait
	ld b, $05
	call MailView_BodyPage_FindLine
	ld b, $03
	ld c, $00
	ld d, $3C
	ld e, $08
	call MailView_BodyPage_DrawTextLine24
	call VBlank_Wait
	ld b, $06
	call MailView_BodyPage_FindLine
	ld b, $03
	ld c, $00
	ld d, $48
	ld e, $08
	call MailView_BodyPage_DrawTextLine24
	call VBlank_Wait
	ld b, $07
	call MailView_BodyPage_FindLine
	ld b, $03
	ld c, $00
	ld d, $54
	ld e, $08
	call MailView_BodyPage_DrawTextLine24
	call VBlank_Wait
	farcall MailView_BodyPage_UploadTextTiles
	farcall Stat_DisableScrollSplit
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
	ld bc, $0007
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	ld bc, $0000
	ret

; ---- words $7D7A-$7D92 (24 bytes) [PROBABLE] 12 words $A124..$AE13 (SRAM record bases); ld hl,$7D7A at 2B:7C45 and 7C76

Table_MailView_BodyPage_RecAddrs:: ; 2B:7D7A
Table_2B_7D7A::
	dw $A124, $A251, $A37E, $A4AB, $A5D8, $A705, $A832, $A95F
	dw $AA8C, $ABB9, $ACE6, $AE13

MailView_BodyPage_UploadTextTiles:: ; 2B:7D92
	; [CONFIRMED] 235 insn(s) reached by static flow only; seeds: exec x235; min discovery hops 10;
	; entered by far from 2B:7D29 (PROBABLE code) [executed in 1 scenarios]
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	ld c, $3F
	call Gfx_StartHDMAAtVBlank_2B_7DD0
	ld hl, $D400
	ld de, $9400
	ld c, $3F
	call Gfx_StartHDMAAtVBlank_2B_7DD0
	ld hl, $D800
	ld de, $8800
	ld c, $3F
	call Gfx_StartHDMAAtVBlank_2B_7DD0
	ld hl, $DC00
	ld de, $8C00
	ld c, $3F
	call Gfx_StartHDMAAtVBlank_2B_7DD0
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

Gfx_StartHDMAAtVBlank_2B_7DD0:: ; 2B:7DD0
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, rLY
.l7DDF ; 2B:7DDF
	ld a, [de]
	cp a, $8F
	jr nz, .l7DDF
	di
	ld b, $91
.l7DE7 ; 2B:7DE7
	ld a, [de]
	cp a, b
	jr nz, .l7DE7
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ei
	ret

MailView_BodyPage_DrawTextLine24:: ; 2B:7DF2
	ld a, $18
	ld [wTextCellsLeft], a
.l7DF7 ; 2B:7DF7
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l7E94
	cp a, $0D
	jr z, .l7E79
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l7E57
	ld a, [wTextCellsLeft]
	dec a
	jr z, .l7E54
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
	call MailView_BodyPage_DrawTextLine24_BlitGlyphAdvance
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
	jr z, .l7E94
	jr .l7DF7
.l7E54 ; 2B:7E54
	pop af
	jr .l7E94
.l7E57 ; 2B:7E57
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
	call MailView_BodyPage_DrawTextLine24_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l7E94
	jp .l7DF7
.l7E79 ; 2B:7E79
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
	call MailView_BodyPage_DrawTextLine24_BlitBlankAdvance
.l7E94 ; 2B:7E94
	push bc
	push de
	push hl
	ld b, $20
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
.l7EA5 ; 2B:7EA5
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call MailView_BodyPage_DrawTextLine24_BlitBlankAdvance
	jr .l7EA5

MailView_BodyPage_DrawTextLine24_BlitGlyphAdvance:: ; 2B:7EB4
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

MailView_BodyPage_DrawTextLine24_BlitBlankAdvance:: ; 2B:7EC8
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

MailView_BodyPage_FindLine:: ; 2B:7EE0
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D400
	inc b
.l7EEB ; 2B:7EEB
	ld d, $00
	ld e, $18
	dec b
	jr z, .l7F25
.l7EF2 ; 2B:7EF2
	ld d, $FF
	ld a, [hl]
	farcall Glyph_IsSjisLeadByte
	dec a
	jr z, .l7F0F
	ld a, [hl]
	cp a, $00
	jr z, .l7F25
	inc hl
	inc hl
	cp a, $0D
	jr z, .l7EEB
	dec hl
	dec e
	jr nz, .l7EF2
	jr .l7EEB
.l7F0F ; 2B:7F0F
	ld a, e
	cp a, $01
	jr z, .l7EEB
	ld a, [hl]
	cp a, $00
	jr z, .l7F25
	inc hl
	inc hl
	cp a, $0D
	jr z, .l7EEB
	dec e
	dec e
	jr nz, .l7EF2
	jr .l7EEB
.l7F25 ; 2B:7F25
	ld a, $FF
	cp a, d
	jr z, .l7F3E
	ld e, $00
	push hl
.l7F2D ; 2B:7F2D
	ld a, [hli]
	inc hl
	cp a, $00
	jr z, .l7F3D
	cp a, $0D
	jr z, .l7F3D
	inc e
	ld a, $0B
	cp a, e
	jr nz, .l7F2D
.l7F3D ; 2B:7F3D
	pop hl
.l7F3E ; 2B:7F3E
	xor a, a
	ld [rRAMG], a
	pop bc
	ret
