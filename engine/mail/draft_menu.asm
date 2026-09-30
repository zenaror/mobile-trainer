; engine/mail/draft_menu.asm
; bank 2B, $4000-$4880 (2176 bytes); pinned by layout.link
; menu of the saved draft (view/edit/delete) with caption strings

SECTION "engine/mail/draft_menu", ROMX

; ---- code $4000-$407B (123 bytes) [CONFIRMED] 52 insn(s); 52 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailDraft_Menu:: ; 2B:4000
Function_2B_4000::
	call Function_00_044B
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
	call Function_00_0464
	push bc
	call MailDraft_Menu_InitScreen
	pop bc

MailDraft_Menu_Loop:: ; 2B:402B
	push bc
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop bc
	call MailDraft_Menu_MoveCursorSprites
	ldh a, [hJoyPressed]
	and a, $01
	jp z, Label_2B_4194
	ld a, c
	cp a, $00
	jr nz, Label_2B_4080
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc

Label_2B_405F:: ; 2B:405F
	ldh a, [rLY]
	cp a, $50
	jr c, Label_2B_405F
	cp a, $5A
	jr nc, Label_2B_405F
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	farcall MailBody_ViewScreen

; ---- code $407B-$4080 (5 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; entry not recorded [executed in 3 scenarios]
	ld c, $00
	jp MailDraft_Menu

; ---- code $4080-$4084 (4 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)

Label_2B_4080:: ; 2B:4080
	cp a, $01
	jr nz, Label_2B_40A2

; ---- code $4084-$40A2 (30 bytes) [CONFIRMED] 16 insn(s) reached by static flow only; seeds: exec x16; min discovery hops 0; fall-through of the jrcc at 2B:4082 (executed) [executed in 1 scenarios]
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	call MailDraft_Edit
	cp a, $FF
	ld c, $01
	jp MailDraft_Menu

; ---- code $40A2-$4161 (191 bytes) [CONFIRMED] 75 insn(s); 75 executed (in up to 1/18 scenarios)

Label_2B_40A2:: ; 2B:40A2
	push bc
	farcall Sprites_SaveSlotsToBank3
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $FF
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 17], a
	ld [wSpriteSlots + 18], a
	ld [wSpriteSlots + 19], a
	ld [wSpriteSlots + 20], a
	ld [wSpriteSlots + 21], a
	ld [wSpriteSlots + 22], a
	ld [wSpriteSlots + 23], a
	ld [wSpriteSlots + 24], a
	ld [wSpriteSlots + 25], a
	ld [wSpriteSlots + 26], a
	ld [wSpriteSlots + 27], a
	ld [wSpriteSlots + 28], a
	ld [wSpriteSlots + 29], a
	ld [wSpriteSlots + 30], a
	ld [wSpriteSlots + 31], a
	ld [wSpriteSlots + 36], a
	ld [wSpriteSlots + 32], a
	ld [wSpriteSlots + 33], a
	ld [wSpriteSlots + 34], a
	ld [wSpriteSlots + 35], a
	ld [wSpriteSlots + 36], a
	ld [wSpriteSlots + 37], a
	ld [wSpriteSlots + 38], a
	ld [wSpriteSlots + 39], a
	ld [wSpriteSlots + 40], a
	ld [wSpriteSlots + 41], a
	ld [wSpriteSlots + 42], a
	ld [wSpriteSlots + 43], a
	ld [wSpriteSlots + 44], a
	ld [wSpriteSlots + 45], a
	ld [wSpriteSlots + 46], a
	ld [wSpriteSlots + 47], a
	farcall Function_00_0956
	ld de, $0209
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
	farcall Sprites_RestoreSlotsFromBank3
	farcall Function_00_0956
	pop af
	pop bc
	dec a
	jp nz, MailDraft_Menu_Loop

; ---- code $4161-$4194 (51 bytes) [CONFIRMED] 20 insn(s) reached by static flow only; seeds: exec x20; min discovery hops 0; fall-through of the jpcc at 2B:415E (executed) [executed in 1 scenarios]
	farcall MailDraft_Clear
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0033
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	farcall Function_00_0956
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	ret

; ---- code $4194-$4203 (111 bytes) [CONFIRMED] 60 insn(s); 60 executed (in up to 2/18 scenarios)

Label_2B_4194:: ; 2B:4194
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_2B_41BD
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

Label_2B_41BD:: ; 2B:41BD
	ldh a, [hJoyPressedRepeat]
	and a, $20
	jr z, Label_2B_41E3
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	dec c
	ld a, c
	cp a, $FF
	jr nz, Label_2B_41DF
	ld c, $02

Label_2B_41DF:: ; 2B:41DF
	ld a, c
	call MailDraft_Menu_SetCaption

Label_2B_41E3:: ; 2B:41E3
	ldh a, [hJoyPressedRepeat]
	and a, $10
	jr z, Label_2B_4209
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	inc c
	ld a, c
	cp a, $03
	jr nz, Label_2B_4205

; ---- code $4203-$4205 (2 bytes) [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 2B:4201 (executed) [executed in 2 scenarios]
	ld c, $00

; ---- code $4205-$42F3 (238 bytes) [CONFIRMED] 76 insn(s); 76 executed (in up to 2/18 scenarios)

Label_2B_4205:: ; 2B:4205
	ld a, c
	call MailDraft_Menu_SetCaption

Label_2B_4209:: ; 2B:4209
	jp MailDraft_Menu_Loop

MailDraft_Menu_InitScreen:: ; 2B:420C
	push bc
	farcall Function_00_09B6
	farcall Function_00_0956
	farcall TextTiles_ClearBuffers
	farcall MailDraft_LoadFromSram
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_MailDraftMenu_Bg
	ld a, $2B
	farcall Palette_LoadToBuffer
	ld de, $8000
	ld hl, Gfx_MailDraftMenu_Tiles8000
	ld a, $2B
	ld b, $93
	ld c, $33
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D840
	ld hl, Palette_MailDraftMenu_Obj
	ld a, $2B
	farcall Palette_LoadToBuffer
	ld de, $9301
	ld hl, Gfx_MailDraftMenu_Tiles9300
	ld a, $2B
	ld b, $94
	ld c, $2D
	farcall Function_00_0787
	ld bc, $1214
	ld de, $D000
	ld hl, Data_MailDraftMenu_TilemapAttr
	ld a, $2B
	farcall Function_00_08EA
	ldh a, [rLCDC]
	call Function_00_082C
	ld hl, $DA30
	ld de, Table_MailDraftMenu_Anims
	ld a, $2B
	ld b, $81
	farcall Function_00_0A82
	ld de, $1008
	ld hl, $DA30
	call Function_00_0A65
	ld hl, $DA40
	ld de, $51E0
	ld a, $2B
	ld b, $81
	farcall Function_00_0A82
	ld de, $3008
	ld hl, $DA40
	call Function_00_0A65
	ld hl, $DA10
	ld de, $51F0
	ld a, $2B
	ld b, $81
	farcall Function_00_0A82
	ld de, $68D0
	ld hl, $DA10
	call Function_00_0A65
	ld hl, $DA20
	ld de, $5200
	ld a, $2B
	ld b, $81
	farcall Function_00_0A82
	ld de, $68D0
	ld hl, $DA20
	call Function_00_0A65
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D514
	ld a, [hl]
	cp a, $00
	jr z, Label_2B_430C

; ---- code $42F3-$430C (25 bytes) [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0; fall-through of the jrcc at 2B:42F1 (executed) [executed in 2 scenarios]
	ld hl, $DA60
	ld de, $5230
	ld a, $2B
	ld b, $00
	farcall Function_00_0A82
	ld de, $0068
	ld hl, $DA60
	call Function_00_0A65

; ---- code $430C-$441F (275 bytes) [CONFIRMED] 110 insn(s); 110 executed (in up to 2/18 scenarios)

Label_2B_430C:: ; 2B:430C
	pop bc
	ld a, c
	call MailDraft_Menu_SetCaption
	ld bc, $0300
	ld d, $14
	ld e, $20
	ld hl, $D500
	call MailDraft_DrawTextLine21
	ld bc, $0300
	ld d, $02
	ld e, $08
	ld hl, $D514
	call MailDraft_DrawTextLine17
	ld bc, $0300
	ld d, $24
	ld e, $20
	ld hl, $D4C0
	call MailDraft_DrawTextLine21
	ld bc, $0300
	ld d, $30
	ld e, $08
	ld hl, $D4D4
	call MailDraft_DrawTextLine25
	ld bc, $0300
	ld d, $3C
	ld e, $08
	ld hl, $D4EC
	call MailDraft_DrawTextLine21
	call MailDraft_UploadTextTiles
	farcall Function_00_0956
	call Function_00_0464
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

MailDraft_Menu_MoveCursorSprites:: ; 2B:43A5
	push bc
	ld a, c
	cp a, $00
	jr nz, Label_2B_43CF
	ld de, $6810
	ld hl, $DA10
	call Function_00_0A65
	ld hl, $DA20
	ld de, $5200
	ld a, $2B
	ld b, $81
	farcall Function_00_0A82
	ld de, $6810
	ld hl, $DA20
	call Function_00_0A65
	pop bc
	ret

Label_2B_43CF:: ; 2B:43CF
	cp a, $01
	jr nz, Label_2B_43F7
	ld de, $6840
	ld hl, $DA10
	call Function_00_0A65
	ld hl, $DA20
	ld de, $5210
	ld a, $2B
	ld b, $81
	farcall Function_00_0A82
	ld de, $6840
	ld hl, $DA20
	call Function_00_0A65
	pop bc
	ret

Label_2B_43F7:: ; 2B:43F7
	cp a, $02
	jr nz, Label_2B_441F
	ld de, $6870
	ld hl, $DA10
	call Function_00_0A65
	ld hl, $DA20
	ld de, $5220
	ld a, $2B
	ld b, $81
	farcall Function_00_0A82
	ld de, $6870
	ld hl, $DA20
	call Function_00_0A65
	pop bc
	ret

; ---- code $441F-$4421 (2 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1; entered by jrcc from 2B:43F9 (executed) | forced execution: 2/2 instruction starts ran in forced_screens (traces/forced/, not natural evidence; status unchanged)

Label_2B_441F:: ; 2B:441F
	pop bc
	ret

; ---- code $4421-$44A6 (133 bytes) [CONFIRMED] 70 insn(s); 70 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailDraft_DrawTextLine21:: ; 2B:4421
Function_2B_4421::
	ld a, $15
	ld [wTextCellsLeft], a

Label_2B_4426:: ; 2B:4426
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2B_44C1
	cp a, $0D
	jr z, Label_2B_44A6
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2B_4481
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
	call MailDraft_DrawTextLine21_BlitGlyphAdvance
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
	jr z, Label_2B_44C1
	cp a, $01
	jr z, Label_2B_44C1
	jr Label_2B_4426

Label_2B_4481:: ; 2B:4481
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
	call MailDraft_DrawTextLine21_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2B_44C1
	cp a, $01
	jr z, Label_2B_44C1
	jr Label_2B_4426

; ---- code $44A6-$44C1 (27 bytes) [PROBABLE] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 1; entered by jrcc from 2B:4434 (executed)

Label_2B_44A6:: ; 2B:44A6
	push bc
	push de
	push hl
	ld b, $3C
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	call MailDraft_DrawTextLine21_BlitBlankAdvance

; ---- code $44C1-$451E (93 bytes) [CONFIRMED] 50 insn(s); 50 executed (in up to 2/18 scenarios)

Label_2B_44C1:: ; 2B:44C1
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc

Label_2B_44D2:: ; 2B:44D2
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call MailDraft_DrawTextLine21_BlitBlankAdvance
	jr Label_2B_44D2

MailDraft_DrawTextLine21_BlitGlyphAdvance:: ; 2B:44E1
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

MailDraft_DrawTextLine21_BlitBlankAdvance:: ; 2B:44F5
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

MailDraft_DrawTextLine25:: ; 2B:450D
	ld a, $19
	ld [wTextCellsLeft], a

Label_2B_4512:: ; 2B:4512
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2B_45AD

; ---- code $451E-$452C (14 bytes) [CONFIRMED] 75 insn(s) reached by static flow only; seeds: exec x75; min discovery hops 0; fall-through of the jpcc at 2B:451B (executed) | 6 insn(s) executed; cut out of the PROBABLE region 451E-45AD by apply_coverage --split [executed in 1 scenarios]
	cp a, $0D
	jr z, Label_2B_4592
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2B_456D

; ---- code $452C-$456D (65 bytes) [PROBABLE] 37 insn(s) never executed in the traced runs; cut out of the PROBABLE region 451E-45AD by apply_coverage --split
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
	call MailDraft_DrawTextLine25_BlitGlyphAdvance
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
	jr z, Label_2B_45AD
	cp a, $01
	jr z, Label_2B_45AD
	jr Label_2B_4512

; ---- code $456D-$4592 (37 bytes) [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 451E-45AD by apply_coverage --split [executed in 1 scenarios]

Label_2B_456D:: ; 2B:456D
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
	call MailDraft_DrawTextLine25_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2B_45AD
	cp a, $01
	jr z, Label_2B_45AD
	jr Label_2B_4512

; ---- code $4592-$45AD (27 bytes) [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region 451E-45AD by apply_coverage --split

Label_2B_4592:: ; 2B:4592
	push bc
	push de
	push hl
	ld b, $3C
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	call MailDraft_DrawTextLine25_BlitBlankAdvance

; ---- code $45AD-$45CD (32 bytes) [CONFIRMED] 16 insn(s); 16 executed (in up to 2/18 scenarios)

Label_2B_45AD:: ; 2B:45AD
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc

Label_2B_45BE:: ; 2B:45BE
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call MailDraft_DrawTextLine25_BlitBlankAdvance
	jr Label_2B_45BE

; ---- code $45CD-$45E1 (20 bytes) [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1; entered by call from 2B:4545 (PROBABLE code) [executed in 1 scenarios]

MailDraft_DrawTextLine25_BlitGlyphAdvance:: ; 2B:45CD
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

; ---- code $45E1-$460A (41 bytes) [CONFIRMED] 22 insn(s); 22 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailDraft_DrawTextLine25_BlitBlankAdvance:: ; 2B:45E1
Function_2B_45E1::
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

MailDraft_DrawTextLine17:: ; 2B:45F9
	ld a, $11
	ld [wTextCellsLeft], a

Label_2B_45FE:: ; 2B:45FE
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2B_4699

; ---- code $460A-$4659 (79 bytes) [CONFIRMED] 75 insn(s) reached by static flow only; seeds: exec x75; min discovery hops 0; fall-through of the jpcc at 2B:4607 (executed) | 43 insn(s) executed; cut out of the PROBABLE region 460A-4699 by apply_coverage --split [executed in 4 scenarios]
	cp a, $0D
	jr z, Label_2B_467E
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2B_4659
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
	call MailDraft_DrawTextLine17_BlitGlyphAdvance
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
	jr z, Label_2B_4699
	cp a, $01
	jr z, Label_2B_4699
	jr Label_2B_45FE

; ---- code $4659-$4699 (64 bytes) [PROBABLE] 32 insn(s) never executed in the traced runs; cut out of the PROBABLE region 460A-4699 by apply_coverage --split

Label_2B_4659:: ; 2B:4659
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
	call MailDraft_DrawTextLine17_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2B_4699
	cp a, $01
	jr z, Label_2B_4699
	jr Label_2B_45FE

Label_2B_467E:: ; 2B:467E
	push bc
	push de
	push hl
	ld b, $3C
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	call MailDraft_DrawTextLine17_BlitBlankAdvance

; ---- code $4699-$46B9 (32 bytes) [CONFIRMED] 16 insn(s); 16 executed (in up to 2/18 scenarios)

Label_2B_4699:: ; 2B:4699
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc

Label_2B_46AA:: ; 2B:46AA
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call MailDraft_DrawTextLine17_BlitBlankAdvance
	jr Label_2B_46AA

; ---- code $46B9-$46CD (20 bytes) [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1; entered by call from 2B:4631 (PROBABLE code) [executed in 2 scenarios]

MailDraft_DrawTextLine17_BlitGlyphAdvance:: ; 2B:46B9
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

; ---- code $46CD-$4743 (118 bytes) [CONFIRMED] 61 insn(s); 61 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailDraft_DrawTextLine17_BlitBlankAdvance:: ; 2B:46CD
Function_2B_46CD::
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

MailDraft_UploadTextTiles:: ; 2B:46E5
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
	call Gfx_StartHDMAAtVBlank_2B_4723
	ld hl, $D400
	ld de, $9400
	ld c, $3F
	call Gfx_StartHDMAAtVBlank_2B_4723
	ld hl, $D800
	ld de, $8800
	ld c, $3F
	call Gfx_StartHDMAAtVBlank_2B_4723
	ld hl, $DC00
	ld de, $8C00
	ld c, $3F
	call Gfx_StartHDMAAtVBlank_2B_4723
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

Gfx_StartHDMAAtVBlank_2B_4723:: ; 2B:4723
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, $FF44

Label_2B_4732:: ; 2B:4732
	ld a, [de]
	cp a, $8F
	jr nz, Label_2B_4732
	ld b, $91

Label_2B_4739:: ; 2B:4739
	ld a, [de]
	cp a, b
	jr nz, Label_2B_4739
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ret

; ---- code $4743-$478B (72 bytes) [CONFIRMED] 28 insn(s) reached by static flow only; seeds: exec x28; min discovery hops 1; entered by call from 2B:4098 (PROBABLE code) [executed in 1 scenarios]

MailDraft_Edit:: ; 2B:4743
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $02
	ld [wMailComposeMode], a
	xor a, a
	jr Label_2B_475F

Label_2B_475D:: ; 2B:475D
	ld a, $01

Label_2B_475F:: ; 2B:475F
	farcall MailAddr_Edit
	cp a, $FF
	jr z, Label_2B_4788
	xor a, a
	jr Label_2B_476E

Label_2B_476C:: ; 2B:476C
	ld a, $01

Label_2B_476E:: ; 2B:476E
	farcall MailTitle_Entry
	cp a, $FF
	jr z, Label_2B_475D
	farcall MailBody_Edit
	cp a, $FF
	jr z, Label_2B_476C
	cp a, $00
	jr z, Label_2B_4788
	pop af
	ret

Label_2B_4788:: ; 2B:4788
	ld a, $FF
	ret

; ---- code $478B-$47D0 (69 bytes) [CONFIRMED] 35 insn(s); 35 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailDraft_Menu_SetCaption:: ; 2B:478B
Function_2B_478B::
	push bc
	push de
	inc a
	ld e, a
	ld d, $00
	sla e
	ld hl, Table_MailDraftMenu_Captions
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $2B
	ld bc, $DB40
	ld de, $DC80
	farcall TextTiles_RenderLine
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $DB40
	ld de, $8B40
	ld c, $27
	farcall Gfx_StartHDMAAtVBlank
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop de
	pop bc
	ret

; ---- ptrtable $47D0-$47D8 (8 bytes) [PROBABLE] 4 pointers $47D8, $4801, $482A, $4853 to the 4 NUL-terminated strings of String_2B_47D8 (each string starts right after a NUL, spacing $29); bytes 47D2-47D8 are read as data by executed code (2/18 scenarios)

Table_MailDraftMenu_Captions:: ; 2B:47D0
Table_2B_47D0::
	dw String_MailDraftMenu_CaptionConfirm
	dw String_MailDraftMenu_CaptionView
	dw String_MailDraftMenu_CaptionEdit
	dw String_MailDraftMenu_CaptionDelete

; ---- text $47D8-$487C (164 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_MailDraftMenu_CaptionConfirm:: ; 2B:47D8
String_2B_47D8::
	db $81, $40, $81, $40, $82, $A9, $82, $A2, $82, $BD, $83, $81, $81, $5B, $83, $8B, $82, $F0, $81, $40, $82, $A9, $82, $AD, $82, $C9, $82, $F1, $82, $B5, $82, $DC, $82, $B7 ; "　　かいたメールを　かくにんします"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

String_MailDraftMenu_CaptionView:: ; 2B:4801
	db $81, $40, $82, $A9, $82, $A2, $82, $BD, $83, $81, $81, $5B, $83, $8B, $82, $F0, $81, $40, $82, $DD, $82, $E9, $82, $B1, $82, $C6, $82, $AA, $82, $C5, $82, $AB, $82, $DC ; "　かいたメールを　みることができま"
	db $82, $B7, $81, $40, $81, $40, $00 ; "す　　"

String_MailDraftMenu_CaptionEdit:: ; 2B:482A
	db $81, $40, $81, $40, $81, $40, $82, $A9, $82, $A2, $82, $BD, $83, $81, $81, $5B, $83, $8B, $82, $F0, $81, $40, $82, $C8, $82, $A8, $82, $B5, $82, $DC, $82, $B7, $81, $40 ; "　　　かいたメールを　なおします　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

String_MailDraftMenu_CaptionDelete:: ; 2B:4853
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $A9, $82, $A2, $82, $BD, $83, $81, $81, $5B, $83, $8B, $82, $F0, $81, $40, $82, $AF, $82, $B5, $82, $DC, $82, $B7, $81, $40 ; "　　　　かいたメールを　けします　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

; ---- zero $487C-$4880 (4 bytes) [PROBABLE] 4 bytes of $00 after the last string, before the tiles at 4880
	ds $4, $00
