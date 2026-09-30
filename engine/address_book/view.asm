; engine/address_book/view.asm
; bank 2F, $5098-$57F2 (1882 bytes); pinned by layout.link
; address book entry view screen, store entry to SRAM

SECTION "engine/address_book/view", ROMX

; ---- code $5098-$50D3 (59 bytes) [CONFIRMED] 26 insn(s) reached by static flow only; seeds: exec x26; min discovery hops 2; entered by far from 2F:7F3D (PROBABLE code) | upgraded by classifier 6: all 26 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)

AbookView_Run:: ; 2F:5098
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $10
	ld [wStatSplitLine], a
	ld a, $0B
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call AbookView_SetupScreen
	ld d, $3C

Label_2F_50BD:: ; 2F:50BD
	push bc
	push de
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop de
	pop bc
	dec d
	jr Label_2F_5136

; ---- code $50D3-$50ED (26 bytes) [PROBABLE] 16 insn(s) (push bc ; ld de,$020B ; push af ; ldh a,[$FF70] ... ldh [$FF8D],a ; ldh [$FF70],a ; pop af ; push de ; pop de) falling into the code at 50ED; well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS
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

; ---- code $50ED-$5136 (73 bytes) [PROBABLE] 102 insn(s) reached by static flow only; seeds: exec x23, site x79; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code | 31 insn(s) never executed in the traced runs; cut out of the PROBABLE region 50ED-51B5 by apply_coverage --split
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
	jr nz, Label_2F_5122
	push bc
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	pop bc
	call Abook_StoreEntryToSram
	xor a, a
	ret

Label_2F_5122:: ; 2F:5122
	push bc
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, $FF
	ret

; ---- code $5136-$5167 (49 bytes) [CONFIRMED] 23 insn(s) executed; cut out of the PROBABLE region 50ED-51B5 by apply_coverage --split [executed in 3 scenarios]

Label_2F_5136:: ; 2F:5136
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_2F_5164
	push bc
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
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, $FF
	ret

Label_2F_5164:: ; 2F:5164
	jp Label_2F_50BD

; ---- code $5167-$51B5 (78 bytes) [PROBABLE] 48 insn(s) never executed in the traced runs; cut out of the PROBABLE region 50ED-51B5 by apply_coverage --split

Abook_StoreEntryToSram:: ; 2F:5167
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

Label_2F_519C:: ; 2F:519C
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, Label_2F_519C
	pop hl
	ld de, $0010
	add hl, de
	ld b, $40
	ld de, $D4C0

Label_2F_51AC:: ; 2F:51AC
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, Label_2F_51AC
	pop bc
	pop af
	ret

; ---- words $51B5-$51C1 (12 bytes) [PROBABLE] 6 SRAM record addresses $A69D..$A82D, constant stride $50 (80), verified arithmetic progression; indexed table read with 2F:5178 (sla c; ld hl,$51B5; add hl,bc)

Abook_SlotAddrTable4:: ; 2F:51B5
Table_2F_51B5::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

; ---- code $51C1-$52B6 (245 bytes) [CONFIRMED] 172 insn(s) reached by static flow only; seeds: exec x172; min discovery hops 3; entered by call from 2F:50B8 (PROBABLE code) | 81 insn(s) executed; cut out of the PROBABLE region 51C1-5383 by apply_coverage --split [executed in 3 scenarios]

AbookView_SetupScreen:: ; 2F:51C1
	push bc
	farcall Function_00_09B6
	farcall Function_00_0956
	farcall TextTiles_ClearBuffers
	farcall LCDOff
	ld bc, $0040
	ld de, $D840
	ld hl, Palette_AddrBookEntry_Obj
	ld a, $2C
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_AddrBookEntry_Bg
	ld a, $2C
	farcall Palette_LoadToBuffer
	ld de, $9301
	ld hl, Data_29_5E50
	ld a, $29
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9701
	ld hl, Data_29_6250
	ld a, $29
	ld b, $98
	ld c, $04
	farcall Function_00_0787
	ld de, $8F00
	ld hl, Gfx_AddrBookEntry_Tiles8F00
	ld a, $2A
	ld b, $97
	ld c, $0E
	farcall Function_00_0787
	ld de, $8000
	ld hl, Gfx_AddrBookEntry_Tiles8000
	ld a, $2A
	ld b, $97
	ld c, $0B
	farcall Function_00_0787
	ld bc, $1214
	ld de, $D000
	ld hl, Data_AddrBookEntry_TilemapAttr
	ld a, $2C
	farcall Function_00_08EA
	ldh a, [rLCDC]
	call Function_00_082C
	farcall LCDOn
	ld hl, $DA10
	ld de, Table_Abook_ViewCursorAnims
	ld a, $2F
	ld b, $81
	farcall Function_00_0A82
	ld a, $20
	ld [wSpriteSlots + 16], a
	ld a, $08
	ld [wSpriteSlots + 17], a
	ld bc, $0000
	pop bc
	ld a, b
	cp a, $FF
	jr nz, Label_2F_52B6
	call AbookView_LoadAndDraw
	farcall Stat_DisableScrollSplit
	call Function_00_0464
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
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	ret

; ---- code $52B6-$52E9 (51 bytes) [PROBABLE] 20 insn(s) never executed in the traced runs; cut out of the PROBABLE region 51C1-5383 by apply_coverage --split

Label_2F_52B6:: ; 2F:52B6
	call AbookView_DrawFromBuffers
	farcall Stat_DisableScrollSplit
	call Function_00_0464
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
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	ret

; ---- code $52E9-$5383 (154 bytes) [CONFIRMED] 71 insn(s) executed; cut out of the PROBABLE region 51C1-5383 by apply_coverage --split [executed in 3 scenarios]

AbookView_LoadAndDraw:: ; 2F:52E9
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

Label_2F_5312:: ; 2F:5312
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2F_5312
	pop hl
	ld de, $0010
	add hl, de
	ld b, $40
	ld de, $D4C0

Label_2F_5322:: ; 2F:5322
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2F_5322
	pop bc
	push bc
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $0438
	ld hl, $D514
	call AbookView_DrawName
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $1438
	ld hl, $D4C0
	farcall AbookView_DrawAddrLine1
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $2008
	ld hl, $D4D0
	farcall AbookView_DrawAddrLine2
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $2C08
	ld hl, $D4E8
	farcall AbookView_DrawAddrLine3
	farcall AddrBook_UploadEntryTextTiles
	pop bc
	ret

; ---- words $5383-$538F (12 bytes) [PROBABLE] 6 SRAM record addresses $A69D..$A82D, constant stride $50 (80), verified arithmetic progression; indexed table read with 2F:52EE

Abook_SlotAddrTable5:: ; 2F:5383
Table_2F_5383::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

; ---- code $538F-$53E9 (90 bytes) [PROBABLE] 32 insn(s) reached by static flow only; seeds: exec x32; min discovery hops 5; entered by call from 2F:52B6 (PROBABLE code)

AbookView_DrawFromBuffers:: ; 2F:538F
	push bc
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $0438
	ld hl, $D514
	call AbookView_DrawName
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $1438
	ld hl, $D4C0
	farcall AbookView_DrawAddrLine1
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $2008
	ld hl, $D4D0
	farcall AbookView_DrawAddrLine2
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $2C08
	ld hl, $D4E8
	farcall AbookView_DrawAddrLine3
	farcall AddrBook_UploadEntryTextTiles
	pop bc
	ret

; ---- words $53E9-$53F5 (12 bytes) [PROBABLE] 6 SRAM record addresses $A69D..$A82D, constant stride $50 (80), verified arithmetic progression; indexed table read with no direct ld hl,imm found

Abook_SlotAddrTable6:: ; 2F:53E9
Table_2F_53E9::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

; ---- code $53F5-$5455 (96 bytes) [CONFIRMED] 500 insn(s) reached by static flow only; seeds: exec x500; min discovery hops 5; entered by call from 2F:5339 (PROBABLE code) | 51 insn(s) executed; cut out of the PROBABLE region 53F5-57A5 by apply_coverage --split [executed in 2 scenarios]

AbookView_DrawName:: ; 2F:53F5
	ld a, $10
	ld [wTextCellsLeft], a

Label_2F_53FA:: ; 2F:53FA
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2F_5495
	cp a, $0D
	jr z, Label_2F_547A
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2F_5455
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
	call AbookView_DrawName_Glyph
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
	jr z, Label_2F_5495
	cp a, $01
	jr z, Label_2F_5495
	jr Label_2F_53FA

; ---- code $5455-$5495 (64 bytes) [PROBABLE] 32 insn(s) never executed in the traced runs; cut out of the PROBABLE region 53F5-57A5 by apply_coverage --split

Label_2F_5455:: ; 2F:5455
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
	call AbookView_DrawName_Glyph
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2F_5495
	cp a, $01
	jr z, Label_2F_5495
	jr Label_2F_53FA

Label_2F_547A:: ; 2F:547A
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
	call AbookView_DrawName_Pad

; ---- code $5495-$5500 (107 bytes) [CONFIRMED] 56 insn(s) executed; cut out of the PROBABLE region 53F5-57A5 by apply_coverage --split [executed in 2 scenarios]

Label_2F_5495:: ; 2F:5495
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc

Label_2F_54A6:: ; 2F:54A6
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AbookView_DrawName_Pad
	jr Label_2F_54A6

AbookView_DrawName_Glyph:: ; 2F:54B5
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

AbookView_DrawName_Pad:: ; 2F:54C9
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

AbookView_DrawAddrLine1:: ; 2F:54E1
	ld a, $11
	ld [wTextCellsLeft], a

Label_2F_54E6:: ; 2F:54E6
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2F_5581
	cp a, $0D
	jr z, Label_2F_5566
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2F_5541

; ---- code $5500-$5541 (65 bytes) [PROBABLE] 37 insn(s) never executed in the traced runs; cut out of the PROBABLE region 53F5-57A5 by apply_coverage --split
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
	call AbookView_DrawAddrLine1_Glyph
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
	jr z, Label_2F_5581
	cp a, $01
	jr z, Label_2F_5581
	jr Label_2F_54E6

; ---- code $5541-$5566 (37 bytes) [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 53F5-57A5 by apply_coverage --split [executed in 4 scenarios]

Label_2F_5541:: ; 2F:5541
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
	call AbookView_DrawAddrLine1_Glyph
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2F_5581
	cp a, $01
	jr z, Label_2F_5581
	jr Label_2F_54E6

; ---- code $5566-$5581 (27 bytes) [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region 53F5-57A5 by apply_coverage --split

Label_2F_5566:: ; 2F:5566
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
	call AbookView_DrawAddrLine1_Pad

; ---- code $5581-$55EC (107 bytes) [CONFIRMED] 56 insn(s) executed; cut out of the PROBABLE region 53F5-57A5 by apply_coverage --split [executed in 3 scenarios]

Label_2F_5581:: ; 2F:5581
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc

Label_2F_5592:: ; 2F:5592
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AbookView_DrawAddrLine1_Pad
	jr Label_2F_5592

AbookView_DrawAddrLine1_Glyph:: ; 2F:55A1
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

AbookView_DrawAddrLine1_Pad:: ; 2F:55B5
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

AbookView_DrawAddrLine2:: ; 2F:55CD
	ld a, $19
	ld [wTextCellsLeft], a

Label_2F_55D2:: ; 2F:55D2
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2F_566D
	cp a, $0D
	jr z, Label_2F_5652
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2F_562D

; ---- code $55EC-$562D (65 bytes) [PROBABLE] 37 insn(s) never executed in the traced runs; cut out of the PROBABLE region 53F5-57A5 by apply_coverage --split
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
	call AbookView_DrawAddrLine2_Glyph
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
	jr z, Label_2F_566D
	cp a, $01
	jr z, Label_2F_566D
	jr Label_2F_55D2

; ---- code $562D-$5652 (37 bytes) [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 53F5-57A5 by apply_coverage --split [executed in 3 scenarios]

Label_2F_562D:: ; 2F:562D
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
	call AbookView_DrawAddrLine2_Glyph
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2F_566D
	cp a, $01
	jr z, Label_2F_566D
	jr Label_2F_55D2

; ---- code $5652-$566D (27 bytes) [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region 53F5-57A5 by apply_coverage --split

Label_2F_5652:: ; 2F:5652
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
	call AbookView_DrawAddrLine2_Pad

; ---- code $566D-$56D8 (107 bytes) [CONFIRMED] 56 insn(s) executed; cut out of the PROBABLE region 53F5-57A5 by apply_coverage --split [executed in 1 scenarios]

Label_2F_566D:: ; 2F:566D
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc

Label_2F_567E:: ; 2F:567E
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AbookView_DrawAddrLine2_Pad
	jr Label_2F_567E

AbookView_DrawAddrLine2_Glyph:: ; 2F:568D
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

AbookView_DrawAddrLine2_Pad:: ; 2F:56A1
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

AbookView_DrawAddrLine3:: ; 2F:56B9
	ld a, $19
	ld [wTextCellsLeft], a

Label_2F_56BE:: ; 2F:56BE
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2F_5759
	cp a, $0D
	jr z, Label_2F_573E
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2F_5719

; ---- code $56D8-$5719 (65 bytes) [PROBABLE] 37 insn(s) never executed in the traced runs; cut out of the PROBABLE region 53F5-57A5 by apply_coverage --split
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
	call AbookView_DrawAddrLine3_Glyph
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
	jr z, Label_2F_5759
	cp a, $01
	jr z, Label_2F_5759
	jr Label_2F_56BE

; ---- code $5719-$573E (37 bytes) [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 53F5-57A5 by apply_coverage --split [executed in 1 scenarios]

Label_2F_5719:: ; 2F:5719
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
	call AbookView_DrawAddrLine3_Glyph
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2F_5759
	cp a, $01
	jr z, Label_2F_5759
	jr Label_2F_56BE

; ---- code $573E-$5759 (27 bytes) [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region 53F5-57A5 by apply_coverage --split

Label_2F_573E:: ; 2F:573E
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
	call AbookView_DrawAddrLine3_Pad

; ---- code $5759-$57A5 (76 bytes) [CONFIRMED] 42 insn(s) executed; cut out of the PROBABLE region 53F5-57A5 by apply_coverage --split [executed in 1 scenarios]

Label_2F_5759:: ; 2F:5759
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc

Label_2F_576A:: ; 2F:576A
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AbookView_DrawAddrLine3_Pad
	jr Label_2F_576A

AbookView_DrawAddrLine3_Glyph:: ; 2F:5779
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

AbookView_DrawAddrLine3_Pad:: ; 2F:578D
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

; ---- zero $57A5-$57B0 (11 bytes) [PROBABLE] 11 zero bytes of padding between a function and the object table at 57B0
	ds $B, $00

; ---- ptrtable $57B0-$57C0 (16 bytes) [PROBABLE] 8 words, all inside $57C0-$57F2 of the same bank (animation/OAM frame data); tables of 4-byte entries (2 words) addressed by ld de,imm before FarCall 00:0A82 (init_object_from_table: reads the 4-byte entry number B&$7F of the table at DE); each 16-byte table = 4 identical-pair entries; caller 2F:5263 ld de,$57B0 (a=$2F b=$81)

Table_Abook_ViewCursorAnims:: ; 2F:57B0
Table_2F_57B0::
	dw Data_2F_57C0
	dw $57EF
	dw Data_2F_57C0
	dw $57EF
	dw Data_2F_57C0
	dw $57EF
	dw Data_2F_57C0
	dw $57EF

; ---- data $57C0-$57F2 (50 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; target of the 57B0 table (57C0, 57EF)

Data_2F_57C0:: ; 2F:57C0
	db $C2, $57, $0B, $01, $05, $06, $02, $09, $FD, $07, $02, $09, $05, $08, $02, $11
	db $FD, $09, $02, $11, $05, $0A, $02, $1E, $00, $00, $01, $1E, $08, $01, $01, $26
	db $00, $02, $01, $26, $08, $03, $01, $2E, $00, $04, $01, $2E, $08, $05, $01, $01
	db $00, $04
