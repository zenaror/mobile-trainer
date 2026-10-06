; engine/mail/received_mail_grid.asm
; bank 2B, $53C3-$59C0 (1533 bytes); pinned by layout.link
; 12-cell received-mail grid screen (unused)

SECTION "engine/mail/received_mail_grid", ROMX

MailGrid_Screen:: ; 2B:53C3
	; [HYPOTHESIS] 'call $5448' (cd 48 54) directly after the animation block, falling into the
	; PROBABLE code at 53C6; no branch/pointer to 53C3 found; target 5448 is a code instruction
	; start | forced execution: 1/1 instruction starts ran in forced_screens (traces/forced/, not
	; natural evidence; status unchanged)
	call MailGrid_InitScreen

.loop ; 2B:53C6
	; [PROBABLE] 268 insn(s) reached by static flow only; seeds: site x268; min discovery hops 0;
	; entered by jr from 2B:541E (PROBABLE code) | forced execution: 236/268 instruction starts ran
	; in forced_screens (traces/forced/, not natural evidence; status unchanged)
	push bc
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_Update
	pop bc
	call MailGrid_PlaceCursorSprite
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .l53F3
	push bc
	farcall Palette_FadeOutToWhite
	pop bc
	push bc
	farcall MailView_SenderPage
	pop bc
	jp MailDraft_Menu
.l53F3 ; 2B:53F3
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l5402
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret
.l5402 ; 2B:5402
	ldh a, [hJoyPressedRepeat]
	and a, $20
	call nz, MailGrid_CursorLeft
	ldh a, [hJoyPressedRepeat]
	and a, $10
	call nz, MailGrid_CursorRight
	ldh a, [hJoyPressedRepeat]
	and a, $40
	call nz, MailGrid_CursorUp
	ldh a, [hJoyPressedRepeat]
	and a, $80
	call nz, MailGrid_CursorDown
	jr .loop

MailGrid_CursorLeft:: ; 2B:5420
	ld a, c
	cp a, $00
	ret z
	dec c
	call MailGrid_ShowCellDetails
	ret

MailGrid_CursorRight:: ; 2B:5429
	ld a, c
	cp a, $0B
	ret z
	inc c
	call MailGrid_ShowCellDetails
	ret

MailGrid_CursorUp:: ; 2B:5432
	ld a, c
	cp a, $04
	ret c
	sub a, $04
	ld c, a
	call MailGrid_ShowCellDetails
	ret

MailGrid_CursorDown:: ; 2B:543D
	ld a, c
	cp a, $08
	ret nc
	add a, $04
	ld c, a
	call MailGrid_ShowCellDetails
	ret

MailGrid_InitScreen:: ; 2B:5448
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	farcall LCDOff
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_MailGrid_Bg
	ld a, BANK(Palette_MailGrid_Bg)
	farcall Palette_LoadToBuffer
	ld de, $9001
	ld hl, Gfx_MailGrid_Tiles9000Vb1
	ld a, BANK(Gfx_MailGrid_Tiles9000Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_MailGrid_Tiles9400Vb1
	ld a, BANK(Gfx_MailGrid_Tiles9400Vb1)
	ld b, $95
	ld c, $23
	farcall Gfx_StartHDMAWithService
	ld de, $8000
	ld hl, Gfx_MailGrid_Tiles8000
	ld a, BANK(Gfx_MailGrid_Tiles8000)
	ld b, $97
	ld c, $0F
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, Palette_MailGrid_Obj
	ld a, BANK(Palette_MailGrid_Obj)
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Data_MailGrid_TilemapAttr
	ld a, BANK(Data_MailGrid_TilemapAttr)
	farcall Tilemap_CopyRectAndAttr
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
	ld hl, wSpriteSlot1
	ld de, Table_MailGrid_Anims
	ld a, BANK(Table_MailGrid_Anims)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1404
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	call MailGrid_DrawCellIcons
	farcall LCDOn
	farcall TextTiles_UploadBuffers
	ld bc, $0000
	call MailGrid_ShowCellDetails
	ret

MailGrid_PlaceCursorSprite:: ; 2B:5523
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, c
	cp a, $00
	jr nz, .l553A
	ld de, $1404
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	pop bc
	ret
.l553A ; 2B:553A
	cp a, $01
	jr nz, .l5549
	ld de, $142C
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	pop bc
	ret
.l5549 ; 2B:5549
	cp a, $02
	jr nz, .l5558
	ld de, $1454
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	pop bc
	ret
.l5558 ; 2B:5558
	cp a, $03
	jr nz, .l5567
	ld de, $147C
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	pop bc
	ret
.l5567 ; 2B:5567
	cp a, $04
	jr nz, .l5576
	ld de, $3404
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	pop bc
	ret
.l5576 ; 2B:5576
	cp a, $05
	jr nz, .l5585
	ld de, $342C
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	pop bc
	ret
.l5585 ; 2B:5585
	cp a, $06
	jr nz, .l5594
	ld de, $3454
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	pop bc
	ret
.l5594 ; 2B:5594
	cp a, $07
	jr nz, .l55A3
	ld de, $347C
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	pop bc
	ret
.l55A3 ; 2B:55A3
	cp a, $08
	jr nz, .l55B2
	ld de, $5404
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	pop bc
	ret
.l55B2 ; 2B:55B2
	cp a, $09
	jr nz, .l55C1
	ld de, $542C
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	pop bc
	ret
.l55C1 ; 2B:55C1
	cp a, $0A
	jr nz, .l55D0
	ld de, $5454
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	pop bc
	ret
.l55D0 ; 2B:55D0
	cp a, $0B
	jr nz, .l55DF
	ld de, $547C
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	pop bc
	ret
.l55DF ; 2B:55DF
	pop bc
	ret

MailGrid_DrawCellIcons:: ; 2B:55E1
	ld c, $00
.loop ; 2B:55E3
	push bc
	sla c
	ld b, $00
	ld hl, Table_MailGrid_CellTilemapAddrs
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	push hl
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, Table_MailGrid_RecAddrs_Cells
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld a, [hl]
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	pop hl
	cp a, $01
	jr nz, .l561B
	call MailGrid_DrawCellIcon_Flag1
	xor a, a
.l561B ; 2B:561B
	cp a, $02
	jr nz, .l5623
	call MailGrid_DrawCellIcon_Flag2
	xor a, a
.l5623 ; 2B:5623
	pop bc
	inc c
	ld a, c
	cp a, $0C
	jr nz, .loop
	ret

; ---- words $562B-$5643 (24 bytes) [PROBABLE] 12 words $9861,$9866,$986B,$9870,$98E1,...,$9970 = VRAM tilemap ($9800-$9BFF) addresses of 12 cells; indexed by c*2 (ld hl,$562B at 2B:55E8 with sla c; add hl,bc) and loaded into hl

Table_MailGrid_CellTilemapAddrs:: ; 2B:562B
Table_2B_562B::
	dw $9861, $9866, $986B, $9870, $98E1, $98E6, $98EB, $98F0
	dw $9961, $9966, $996B, $9970

; ---- words $5643-$565B (24 bytes) [PROBABLE] 12 words $A124..$AE13 (step $12D) = SRAM record base addresses; ld hl,$5643 at 2B:5600 (index by 2*c)

Table_MailGrid_RecAddrs_Cells:: ; 2B:5643
Table_2B_5643::
	dw $A124, $A251, $A37E, $A4AB, $A5D8, $A705, $A832, $A95F
	dw $AA8C, $ABB9, $ACE6, $AE13

MailGrid_DrawCellIcon_Flag1:: ; 2B:565B
	; [PROBABLE] 246 insn(s) reached by static flow only; seeds: site x246; min discovery hops 1;
	; entered by call from 2B:5617 (PROBABLE code) | forced execution: 197/246 instruction starts
	; ran in forced_screens (traces/forced/, not natural evidence; status unchanged)
	xor a, a
	ldh [rVBK], a
	ld de, $0020
	push hl
	push hl
	ld a, $47
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	pop hl
	add hl, de
	push hl
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	pop hl
	add hl, de
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	pop hl
	ld a, $01
	ldh [rVBK], a
	push hl
	ld a, $0B
	ld [hli], a
	ld [hli], a
	ld [hli], a
	pop hl
	add hl, de
	push hl
	ld [hli], a
	ld [hli], a
	ld [hli], a
	pop hl
	add hl, de
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ret

MailGrid_DrawCellIcon_Flag2:: ; 2B:5693
	xor a, a
	ldh [rVBK], a
	ld de, $0020
	push hl
	push hl
	ld a, $50
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	pop hl
	add hl, de
	push hl
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	pop hl
	add hl, de
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	pop hl
	ld a, $01
	ldh [rVBK], a
	push hl
	ld a, $0B
	ld [hli], a
	ld [hli], a
	ld [hli], a
	pop hl
	add hl, de
	push hl
	ld [hli], a
	ld [hli], a
	ld [hli], a
	pop hl
	add hl, de
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ret

MailGrid_ShowCellDetails:: ; 2B:56CB
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push bc
	ld b, $00
	sla c
	ld hl, Table_MailGrid_RecAddrs_Details
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld a, [hl]
	dec a
	jr z, .l56F2
	dec a
	jr z, .l56F2
	jp Label_2B_57CB
.l56F2 ; 2B:56F2
	push bc
	ld b, $00
	sla c
	ld hl, Table_MailGrid_RecAddrs_Details
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld de, $0003
	add hl, de
	ld de, wMailTextScratch
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, $06
.l5710 ; 2B:5710
	ld a, [hl]
	swap a
	and a, $0F
	add a, $59
	ld [de], a
	inc de
	ld a, [hli]
	and a, $0F
	add a, $59
	ld [de], a
	inc de
	dec b
	jr nz, .l5710
	ld de, $99E1
	ld hl, wMailTextScratch
	xor a, a
	ldh [rVBK], a
	di
.l572D ; 2B:572D
	ldh a, [rLY]
	cp a, $90
	jr nz, .l572D
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ei
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, $00
	sla c
	ld hl, Table_MailGrid_RecAddrs_Details
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld de, $00C9
	add hl, de
	ld de, wMailTextScratch
	call MailGrid_CopyTextEllipsis
	ld bc, $0200
	ld de, $0408
	ld hl, wMailTextScratch
	call MailGrid_DrawTextLine12
	pop bc
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, $00
	sla c
	ld hl, Table_MailGrid_RecAddrs_Details
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld de, $00D9
	add hl, de
	ld de, wMailTextScratch
	call MailGrid_CopyTextEllipsis
	ld bc, $0200
	ld de, $0458
	ld hl, wMailTextScratch
	call MailGrid_DrawTextLine12
	call MailGrid_UploadTextTiles
	pop bc
	ret

; ---- text $57B5-$57CB (22 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_2B_57B5:: ; 2B:57B5
	db "そうしんしゃ", 0
	db "あそぼう", 0
POPC

Label_2B_57CB:: ; 2B:57CB
	; [PROBABLE] 35 insn(s) reached by static flow only; seeds: site x35; min discovery hops 2;
	; entered by jp from 2B:56EF (PROBABLE code) | forced execution: 35/35 instruction starts ran in
	; forced_screens (traces/forced/, not natural evidence; status unchanged)
	ld hl, $99E1
	di
.loop ; 2B:57CF
	ldh a, [rLY]
	cp a, $90
	jr nz, .loop
	ld a, $46
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	inc hl
	ld [hli], a
	ld [hli], a
	inc hl
	ld [hli], a
	ld [hli], a
	inc hl
	ld [hli], a
	ld [hli], a
	inc hl
	ld [hli], a
	ld [hli], a
	ei
	push bc
	ld bc, $0200
	ld de, $0408
	ld hl, String_2B_5807
	call MailGrid_DrawTextLine12
	ld bc, $0200
	ld de, $0458
	ld hl, String_2B_5807
	call MailGrid_DrawTextLine12
	call MailGrid_UploadTextTiles
	pop bc
	ret

	; [HYPOTHESIS] lone 'ret' (c9) after the ret at 2B:5805; nothing branches to 5806
	ret

; ---- text $5807-$5814 (13 bytes) [PROBABLE] Shift-JIS NUL-terminated string: 6 x 81 40 (full-width space) + NUL; sits between a ret and the SRAM table at 5814; no direct reference found (probably a blank-line string)

PUSHC sjis
String_2B_5807:: ; 2B:5807
	db "　　　　　　", 0
POPC

; ---- words $5814-$582C (24 bytes) [PROBABLE] 12 words $A124..$AE13 (SRAM record bases, step $12D); ld hl,$5814 at 2B:56DE, 56F7, 5766, 5791

Table_MailGrid_RecAddrs_Details:: ; 2B:5814
Table_2B_5814::
	dw $A124, $A251, $A37E, $A4AB, $A5D8, $A705, $A832, $A95F
	dw $AA8C, $ABB9, $ACE6, $AE13

MailGrid_CopyTextEllipsis:: ; 2B:582C
	; [PROBABLE] 225 insn(s) reached by static flow only; seeds: site x225; min discovery hops 0;
	; entered by call from 2B:5776 (PROBABLE code) | forced execution: 204/225 instruction starts
	; ran in forced_screens (traces/forced/, not natural evidence; status unchanged)
	push hl
	push de
	ld c, $00
	ld b, $0D
.l5832 ; 2B:5832
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr z, .l583E
	dec b
	jr nz, .l5832
	ld c, $01
.l583E ; 2B:583E
	pop hl
	pop de
	dec c
	ret nz
	ld b, $00
.l5844 ; 2B:5844
	ld a, [hli]
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l5876
	pop af
	ld a, b
	cp a, $08
	jr nz, .l5860
	inc hl
	ld a, $81
	ld [hli], a
	ld a, $63
	ld [hli], a
	xor a, a
	ld [hl], a
	jr .done
.l5860 ; 2B:5860
	ld a, b
	cp a, $09
	jr nz, .l5873
	dec hl
	ld a, $81
	ld [hli], a
	ld a, $63
	ld [hli], a
	ld a, $20
	ld [hli], a
	xor a, a
	ld [hl], a
	jr .done
.l5873 ; 2B:5873
	inc b
	inc hl
	push af
.l5876 ; 2B:5876
	pop af
	ld a, b
	cp a, $0A
	jr nz, .l5887
	dec hl
	ld a, $81
	ld [hli], a
	ld a, $63
	ld [hli], a
	xor a, a
	ld [hl], a
	jr .done
.l5887 ; 2B:5887
	inc b
	jr .l5844
.done ; 2B:588A
	ret

MailGrid_DrawTextLine12:: ; 2B:588B
	ld a, $0C
	ld [wTextCellsLeft], a
.l5890 ; 2B:5890
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l592B
	cp a, $0D
	jr z, .l5910
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l58EB
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
	call MailGrid_DrawTextLine12_BlitGlyphAdvance
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
	jr z, .l592B
	cp a, $01
	jr z, .l592B
	jr .l5890
.l58EB ; 2B:58EB
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
	call MailGrid_DrawTextLine12_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l592B
	cp a, $01
	jr z, .l592B
	jr .l5890
.l5910 ; 2B:5910
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
	call MailGrid_DrawTextLine12_BlitBlankAdvance
.l592B ; 2B:592B
	push bc
	push de
	push hl
	ld b, $20
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
.l593C ; 2B:593C
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call MailGrid_DrawTextLine12_BlitBlankAdvance
	jr .l593C

MailGrid_DrawTextLine12_BlitGlyphAdvance:: ; 2B:594B
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

MailGrid_DrawTextLine12_BlitBlankAdvance:: ; 2B:595F
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

MailGrid_UploadTextTiles:: ; 2B:5977
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
	call Gfx_StartHDMAAtVBlank_2B_5994
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

Gfx_StartHDMAAtVBlank_2B_5994:: ; 2B:5994
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, rLY
.l59A3 ; 2B:59A3
	ld a, [de]
	cp a, $8F
	jr nz, .l59A3
	ld b, $91
.l59AA ; 2B:59AA
	ld a, [de]
	cp a, b
	jr nz, .l59AA
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ret

; ---- zero $59B4-$59C0 (12 bytes) [PROBABLE] 12 bytes of $00 padding before the tiles at 59C0
	ds $C, $00
