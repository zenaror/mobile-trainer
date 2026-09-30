; engine/mail/body_view.asm
; bank 28, $4000-$42C0 (704 bytes); pinned by layout.link
; mail text view screen (letter paper, 8 lines)

SECTION "engine/mail/body_view", ROMX

; ---- code $4000-$4020 (32 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

MailBody_ViewScreen:: ; 28:4000
Function_28_4000::
	farcall Stat_EnableScrollSplit
	call MailBody_InitScreen

MailBody_ViewScreen_Loop:: ; 28:4009
	push bc
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_28_404C

; ---- code $4020-$404C (44 bytes) [CONFIRMED] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 0; fall-through of the jrcc at 28:401E (executed) [executed in 5 scenarios]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a

Label_28_4030:: ; 28:4030
	ldh a, [rLY]
	cp a, $50
	jr c, Label_28_4030
	cp a, $5A
	jr nc, Label_28_4030
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

; ---- code $404C-$422B (479 bytes) [CONFIRMED] 179 insn(s); 179 executed (in up to 1/18 scenarios)

Label_28_404C:: ; 28:404C
	jr MailBody_ViewScreen_Loop

MailBody_InitScreen:: ; 28:404E
	farcall Function_00_09B6
	farcall Function_00_0956
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
	farcall Function_00_0787
	ld de, $8000
	ld hl, MailBody_Tiles_44D0
	ld a, $28
	ld b, $98
	ld c, $08
	farcall Function_00_0787
	ld bc, $1214
	ld de, $D000
	ld hl, MailBody_Tilemap
	ld a, $28
	farcall Function_00_08EA
	ldh a, [rLCDC]
	call Function_00_082C
	ld hl, $DA10
	ld de, MailBody_ObjTable
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $0808
	ld hl, $DA10
	call Function_00_0A65
	ld b, $00
	farcall MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld de, $0008
	farcall MailBody_DrawTextLine
	ld b, $01
	farcall MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $0C
	ld e, $08
	farcall MailBody_DrawTextLine
	ld b, $02
	farcall MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $18
	ld e, $08
	farcall MailBody_DrawTextLine
	ld b, $03
	farcall MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $24
	ld e, $08
	farcall MailBody_DrawTextLine
	ld b, $04
	farcall MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $30
	ld e, $08
	farcall MailBody_DrawTextLine
	ld b, $05
	farcall MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $3C
	ld e, $08
	farcall MailBody_DrawTextLine
	ld b, $06
	farcall MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $48
	ld e, $08
	farcall MailBody_DrawTextLine
	ld b, $07
	farcall MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $54
	ld e, $08
	farcall MailBody_DrawTextLine
	farcall TextTiles_UploadBuffers
	farcall Stat_DisableScrollSplit
	call Function_00_044B
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
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	push bc
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0007
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ei
	pop bc
	ld bc, $0000
	ret

MailBody_DrawTextLine:: ; 28:41CB
	ld a, $18
	ld [wTextCellsLeft], a

Label_28_41D0:: ; 28:41D0
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_28_426B
	cp a, $0D
	jr z, Label_28_4250
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_28_422B
	pop af
	push bc
	push de
	push hl
	push af
	ld a, [hli]
	ld l, a
	pop af
	ld h, a
	ld bc, $C0A0
	ld de, $C0B8
	farcall Glyph_LoadWide
	pop hl
	pop de
	pop bc
	inc hl
	call MailBody_BlitGlyphAdvance
	push bc
	push de
	push hl
	ld hl, $C0B8
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
	jr z, Label_28_426B
	cp a, $01
	jr z, Label_28_426B
	jr Label_28_41D0

; ---- code $422B-$4250 (37 bytes) [PROBABLE] 32 insn(s) reached by static flow only; seeds: exec x32; min discovery hops 1; entered by jrcc from 28:41E8 (executed) | 19 insn(s) never executed in the traced runs; cut out of the PROBABLE region 422B-426B by apply_coverage --split

Label_28_422B:: ; 28:422B
	pop af
	push bc
	push de
	push hl
	ld b, a
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	call MailBody_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_28_426B
	cp a, $01
	jr z, Label_28_426B
	jr Label_28_41D0

; ---- code $4250-$426B (27 bytes) [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 422B-426B by apply_coverage --split [executed in 2 scenarios]

Label_28_4250:: ; 28:4250
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	call Function_28_429F

; ---- code $426B-$42B7 (76 bytes) [CONFIRMED] 42 insn(s); 42 executed (in up to 1/18 scenarios)

Label_28_426B:: ; 28:426B
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc

Label_28_427C:: ; 28:427C
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call Function_28_429F
	jr Label_28_427C

MailBody_BlitGlyphAdvance:: ; 28:428B
	push bc
	push de
	push hl
	ld hl, $C0A0
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

Function_28_429F:: ; 28:429F
	push bc
	push de
	push hl
	ld b, $02
	ld c, $00
	ld hl, $C0A0
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

; ---- zero $42B7-$42C0 (9 bytes) [PROBABLE] 9 zero bytes (padding after the ret at 42B6, before the tiles at 42C0)
	ds $9, $00
