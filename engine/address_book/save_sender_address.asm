; engine/address_book/save_sender_address.asm
; bank 2A, $4000-$4AA0 (2720 bytes); pinned by layout.link
; save-the-sender-address screen (pick a slot for a received mail's sender)

SECTION "engine/address_book/save_sender_address", ROMX

; ---- code $4000-$4214 (532 bytes) [CONFIRMED] 231 insn(s) reached by static flow only; seeds: exec x231; min discovery hops 10; entered by far from 2B:659F (PROBABLE code) [executed in 1 scenarios]

SaveSenderAddr_Menu:: ; 2A:4000
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
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
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_2A_4079
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

Label_2A_4058:: ; 2A:4058
	push bc
	farcall Function_00_0956
	call Function_00_0464
	pop bc
	dec b
	jr nz, Label_2A_4058
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	pop bc
	ld c, b
	xor a, a
	ret

Label_2A_4079:: ; 2A:4079
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_2A_40A8
	push bc
	push de

Label_2A_4081:: ; 2A:4081
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
	push bc
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	pop bc
	ld c, b
	ld a, $FF
	ret

Label_2A_40A8:: ; 2A:40A8
	ldh a, [hJoyPressedRepeat]
	and a, $40
	call nz, SaveSenderAddr_CursorUp
	ldh a, [hJoyPressedRepeat]
	and a, $80
	call nz, SaveSenderAddr_CursorDown
	ld d, $10
	jp SaveSenderAddr_Menu_Loop

SaveSenderAddr_CursorDown:: ; 2A:40BB
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
	ld d, c
	inc c
	ld a, c
	cp a, $06
	jr nz, Label_2A_40D8
	ld c, $00

Label_2A_40D8:: ; 2A:40D8
	ld a, d
	call SaveSenderAddr_MoveNameHighlight
	call SaveSenderAddr_RefreshSlotIcons
	ret

SaveSenderAddr_CursorUp:: ; 2A:40E0
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
	ld d, c
	dec c
	ld a, c
	cp a, $FF
	jr nz, Label_2A_40FD
	ld c, $05

Label_2A_40FD:: ; 2A:40FD
	ld a, d
	call SaveSenderAddr_MoveNameHighlight
	call SaveSenderAddr_RefreshSlotIcons
	ret

SaveSenderAddr_InitScreen:: ; 2A:4105
	push bc
	farcall Function_00_09B6
	farcall Function_00_0956
	farcall TextTiles_ClearBuffers
	ld bc, $0040
	ld de, $D840
	ld hl, Palette_AddrBook_Obj
	ld a, $2C
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_SaveSenderAddr_Bg
	ld a, $2A
	farcall Palette_LoadToBuffer
	ld de, $9301
	ld hl, Gfx_SaveSenderAddr_Tiles9300
	ld a, $2A
	ld b, $95
	ld c, $23
	farcall Function_00_0749
	ld de, $8000
	ld hl, Data_28_4BD0
	ld a, $28
	ld b, $92
	ld c, $40
	farcall Function_00_0749
	ld de, $8400
	ld hl, Data_28_4FD0
	ld a, $28
	ld b, $95
	ld c, $20
	farcall Function_00_0749
	ld bc, $1214
	ld de, $D000
	ld hl, Data_SaveSenderAddr_TilemapAttr
	ld a, $2A
	farcall Function_00_08EA
	ldh a, [rLCDC]
	call Function_00_082C
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
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0006
	call Function_00_20E8
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

; ---- code $422C-$4274 (72 bytes) [CONFIRMED] 45 insn(s) reached by static flow only; seeds: exec x45; min discovery hops 11; entered by call from 2A:4046 (PROBABLE code) [executed in 1 scenarios]

SaveSenderAddr_DrawSlotNames:: ; 2A:422C
	push bc
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ld d, $06

Label_2A_423E:: ; 2A:423E
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

Label_2A_4257:: ; 2A:4257
	dec b
	jr z, Label_2A_425E
	add a, $0C
	jr Label_2A_4257

Label_2A_425E:: ; 2A:425E
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
	jr nz, Label_2A_423E
	pop bc
	ret

; ---- words $4274-$4280 (12 bytes) [PROBABLE] SRAM address table (6 words $A69D..$A82D (step $50)): the code indexes it by 2*n and loads hl=[table+2n] as the base of a save/record slot in SRAM ($A000-$BFFF); ld hl,$4274 at 2A:4246 (index e*2 then ld e,[hl]; ld h,[hl]). Values are SRAM addresses, not ROM pointers

Table_SaveSenderAddr_SlotAddrs_DrawNames:: ; 2A:4274
Table_2A_4274::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

; ---- code $4280-$4306 (134 bytes) [CONFIRMED] 78 insn(s) reached by static flow only; seeds: exec x78; min discovery hops 11; entered by call from 2A:404D (PROBABLE code) [executed in 4 scenarios]

SaveSenderAddr_MoveNameHighlight:: ; 2A:4280
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
	jr z, Label_2A_42C3
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

Label_2A_42AC:: ; 2A:42AC
	dec b
	jr z, Label_2A_42B3
	add a, $0C
	jr Label_2A_42AC

Label_2A_42B3:: ; 2A:42B3
	add a, $10
	ld d, a
	ld b, $03
	ld c, $00
	farcall AddrBook_DrawSlotName
	pop bc
	jr Label_2A_42C3

Label_2A_42C3:: ; 2A:42C3
	ld a, c
	cp a, $FF
	jr z, Label_2A_42F6
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

Label_2A_42DF:: ; 2A:42DF
	dec b
	jr z, Label_2A_42E6
	add a, $0C
	jr Label_2A_42DF

Label_2A_42E6:: ; 2A:42E6
	add a, $10
	ld d, a
	ld b, $00
	ld c, $01
	farcall AddrBook_DrawSlotName
	pop hl
	jr Label_2A_42F6

Label_2A_42F6:: ; 2A:42F6
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

; ---- code $4312-$445F (333 bytes) [CONFIRMED] 189 insn(s) reached by static flow only; seeds: exec x189; min discovery hops 11; entered by call from 2A:403E (PROBABLE code) [executed in 4 scenarios]

SaveSenderAddr_SaveToSlot:: ; 2A:4312
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
	jr z, Label_2A_43A5
	push bc
	farcall Sprites_SaveSlotsToBank3
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $B0
	ld [wSpriteSlots + 33], a
	ld [wSpriteSlots + 49], a
	ld [wSpriteSlots + 65], a
	ld [wSpriteSlots + 81], a
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
	jr z, Label_2A_43A5
	ld a, $FF
	ret

Label_2A_43A5:: ; 2A:43A5
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0032
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
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

Label_2A_43E7:: ; 2A:43E7
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
	jr nz, Label_2A_43E7
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

Label_2A_4440:: ; 2A:4440
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
	jr nz, Label_2A_4440
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

; ---- code $4483-$44A9 (38 bytes) [CONFIRMED] 432 insn(s) reached by static flow only; seeds: exec x432; min discovery hops 11; entered by call from 2A:41C4 (PROBABLE code) | 17 insn(s) executed; cut out of the PROBABLE region 4483-483B by apply_coverage --split [executed in 5 scenarios]

SaveSenderAddr_DrawSenderName:: ; 2A:4483
	ld a, $10
	ld [wTextCellsLeft], a

Label_2A_4488:: ; 2A:4488
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2A_4527
	cp a, $0D
	jr z, Label_2A_450C
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2A_44EA
	ld a, [wTextCellsLeft]
	cp a, $01
	jr nz, Label_2A_44AD

; ---- code $44A9-$44AD (4 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4483-483B by apply_coverage --split
	pop af
	jp Label_2A_4527

; ---- code $44AD-$44EA (61 bytes) [CONFIRMED] 35 insn(s) executed; cut out of the PROBABLE region 4483-483B by apply_coverage --split [executed in 5 scenarios]

Label_2A_44AD:: ; 2A:44AD
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
	call SaveSenderAddr_DrawSenderName_BlitGlyphAdvance
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
	jr z, Label_2A_4527
	jr Label_2A_4488

; ---- code $44EA-$4527 (61 bytes) [PROBABLE] 30 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4483-483B by apply_coverage --split

Label_2A_44EA:: ; 2A:44EA
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
	call SaveSenderAddr_DrawSenderName_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2A_4527
	jp Label_2A_4488

Label_2A_450C:: ; 2A:450C
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
	call SaveSenderAddr_DrawSenderName_BlitBlankAdvance

; ---- code $4527-$483B (788 bytes) [CONFIRMED] 348 insn(s) executed; cut out of the PROBABLE region 4483-483B by apply_coverage --split [executed in 1 scenarios]

Label_2A_4527:: ; 2A:4527
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc

Label_2A_4538:: ; 2A:4538
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call SaveSenderAddr_DrawSenderName_BlitBlankAdvance
	jr Label_2A_4538

SaveSenderAddr_DrawSenderName_BlitGlyphAdvance:: ; 2A:4547
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

SaveSenderAddr_DrawSenderName_BlitBlankAdvance:: ; 2A:455B
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

SaveSenderAddr_RefreshSlotIcons:: ; 2A:4573
	push bc
	inc c
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push bc
	ld hl, $DA70
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $00
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, Label_2A_45A7
	ld hl, $DA70
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2A_45A7:: ; 2A:45A7
	pop bc
	push bc
	ld hl, $DA60
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $01
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, Label_2A_45D3
	ld hl, $DA60
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2A_45D3:: ; 2A:45D3
	pop bc
	push bc
	ld hl, $DA50
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $02
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, Label_2A_45FF
	ld hl, $DA50
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2A_45FF:: ; 2A:45FF
	pop bc
	push bc
	ld hl, $DA40
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $03
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, Label_2A_462B
	ld hl, $DA40
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2A_462B:: ; 2A:462B
	pop bc
	push bc
	ld hl, $DA30
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $04
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, Label_2A_4657
	ld hl, $DA30
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2A_4657:: ; 2A:4657
	pop bc
	push bc
	ld hl, $DA20
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $05
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, Label_2A_4683
	ld hl, $DA20
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2A_4683:: ; 2A:4683
	pop bc
	pop bc
	ld a, c
	cp a, $00
	jp z, Label_2A_47BD
	dec a
	jp z, Label_2A_46A3
	dec a
	jp z, Label_2A_46D2
	dec a
	jp z, Label_2A_4701
	dec a
	jp z, Label_2A_4730
	dec a
	jp z, Label_2A_475F
	dec a
	jp z, Label_2A_478E

Label_2A_46A3:: ; 2A:46A3
	push bc
	ld hl, $DA70
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $00
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, Label_2A_46CE
	ld hl, $DA70
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2A_46CE:: ; 2A:46CE
	pop bc
	jp Label_2A_47BD

Label_2A_46D2:: ; 2A:46D2
	push bc
	ld hl, $DA60
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $01
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, Label_2A_46FD
	ld hl, $DA60
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2A_46FD:: ; 2A:46FD
	pop bc
	jp Label_2A_47BD

Label_2A_4701:: ; 2A:4701
	push bc
	ld hl, $DA50
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $02
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, Label_2A_472C
	ld hl, $DA50
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2A_472C:: ; 2A:472C
	pop bc
	jp Label_2A_47BD

Label_2A_4730:: ; 2A:4730
	push bc
	ld hl, $DA40
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $03
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, Label_2A_475B
	ld hl, $DA40
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2A_475B:: ; 2A:475B
	pop bc
	jp Label_2A_47BD

Label_2A_475F:: ; 2A:475F
	push bc
	ld hl, $DA30
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $04
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, Label_2A_478A
	ld hl, $DA30
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2A_478A:: ; 2A:478A
	pop bc
	jp Label_2A_47BD

Label_2A_478E:: ; 2A:478E
	push bc
	ld hl, $DA20
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $05
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, Label_2A_47B9
	ld hl, $DA20
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2A_47B9:: ; 2A:47B9
	pop bc
	jp Label_2A_47BD

Label_2A_47BD:: ; 2A:47BD
	ld a, $18
	ld [wSpriteSlots + 16], a
	ld a, $10
	ld [wSpriteSlots + 17], a
	ld a, $28
	ld [wSpriteSlots + 112], a
	ld a, $10
	ld [wSpriteSlots + 113], a
	ld a, $34
	ld [wSpriteSlots + 96], a
	ld a, $10
	ld [wSpriteSlots + 97], a
	ld a, $40
	ld [wSpriteSlots + 80], a
	ld a, $10
	ld [wSpriteSlots + 81], a
	ld a, $4C
	ld [wSpriteSlots + 64], a
	ld a, $10
	ld [wSpriteSlots + 65], a
	ld a, $58
	ld [wSpriteSlots + 48], a
	ld a, $10
	ld [wSpriteSlots + 49], a
	ld a, $64
	ld [wSpriteSlots + 32], a
	ld a, $10
	ld [wSpriteSlots + 33], a
	pop bc
	ldh a, [hJoyPressed]
	and a, $C0
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
	jr z, Label_2A_4837
	ld a, $00
	pop bc
	ret

Label_2A_4837:: ; 2A:4837
	ld a, $FF
	pop bc
	ret

; ---- words $483B-$4847 (12 bytes) [PROBABLE] SRAM address table (6 words $A69D..$A82D (step $50)): the code indexes it by 2*n and loads hl=[table+2n] as the base of a save/record slot in SRAM ($A000-$BFFF); ld hl,$483B at 2A:4821. Values are SRAM addresses, not ROM pointers

Table_SaveSenderAddr_SlotAddrs_IsUsed:: ; 2A:483B
Table_2A_483B::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

; ---- code $4847-$4988 (321 bytes) [CONFIRMED] 187 insn(s) reached by static flow only; seeds: exec x187; min discovery hops 12; entered by callcc from 2A:4808 (PROBABLE code) | 118 insn(s) executed; cut out of the PROBABLE region 4847-4A3D by apply_coverage --split [executed in 1 scenarios]

SaveSenderAddr_CursorMoveEffect:: ; 2A:4847
	push bc
	ld a, c
	cp a, $00
	jp z, Label_2A_4867
	cp a, $01
	jp z, Label_2A_489C
	cp a, $02
	jp z, Label_2A_48D1
	cp a, $03
	jp z, Label_2A_4906
	cp a, $04
	jp z, Label_2A_493B
	cp a, $05
	jp z, Label_2A_4970

Label_2A_4867:: ; 2A:4867
	ld hl, $DA70
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld a, $00
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, Label_2A_488F
	ld hl, $DA70
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2A_488F:: ; 2A:488F
	ld a, $28
	ld [wSpriteSlots + 112], a
	ld a, $10
	ld [wSpriteSlots + 113], a
	jp Label_2A_49A5

Label_2A_489C:: ; 2A:489C
	ld hl, $DA60
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld a, $01
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, Label_2A_48C4
	ld hl, $DA60
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2A_48C4:: ; 2A:48C4
	ld a, $34
	ld [wSpriteSlots + 96], a
	ld a, $10
	ld [wSpriteSlots + 97], a
	jp Label_2A_49A5

Label_2A_48D1:: ; 2A:48D1
	ld hl, $DA50
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld a, $02
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, Label_2A_48F9
	ld hl, $DA50
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2A_48F9:: ; 2A:48F9
	ld a, $40
	ld [wSpriteSlots + 80], a
	ld a, $10
	ld [wSpriteSlots + 81], a
	jp Label_2A_49A5

Label_2A_4906:: ; 2A:4906
	ld hl, $DA40
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld a, $03
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, Label_2A_492E
	ld hl, $DA40
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2A_492E:: ; 2A:492E
	ld a, $4C
	ld [wSpriteSlots + 64], a
	ld a, $10
	ld [wSpriteSlots + 65], a
	jp Label_2A_49A5

Label_2A_493B:: ; 2A:493B
	ld hl, $DA30
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld a, $04
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, Label_2A_4963
	ld hl, $DA30
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2A_4963:: ; 2A:4963
	ld a, $58
	ld [wSpriteSlots + 48], a
	ld a, $10
	ld [wSpriteSlots + 49], a
	jp Label_2A_49A5

Label_2A_4970:: ; 2A:4970
	ld hl, $DA20
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld a, $05
	call SaveSenderAddr_IsSlotUsed
	inc a
	jr z, Label_2A_4998

; ---- code $4988-$4998 (16 bytes) [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4847-4A3D by apply_coverage --split
	ld hl, $DA20
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

; ---- code $4998-$4A3D (165 bytes) [CONFIRMED] 64 insn(s) executed; cut out of the PROBABLE region 4847-4A3D by apply_coverage --split [executed in 4 scenarios]

Label_2A_4998:: ; 2A:4998
	ld a, $64
	ld [wSpriteSlots + 32], a
	ld a, $10
	ld [wSpriteSlots + 33], a
	jp Label_2A_49A5

Label_2A_49A5:: ; 2A:49A5
	ld b, $1E
	ld b, $01

Label_2A_49A9:: ; 2A:49A9
	push bc
	farcall Function_00_0956
	farcall Joypad_Update
	call Function_00_0464
	pop bc
	ldh a, [hJoyHeld]
	and a, $C0
	jr nz, Label_2A_49C3
	dec b
	jr nz, Label_2A_49A9

Label_2A_49C3:: ; 2A:49C3
	pop bc
	ret

SaveSenderAddr_LoadCaption:: ; 2A:49C5
	push bc
	push de
	ld hl, String_SaveSenderAddr_Caption
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $2A
	ld bc, $D280
	ld de, $D3C0
	farcall TextTiles_RenderLine
	ld hl, $4A6F
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $2A
	ld bc, $D500
	ld de, $D640
	farcall TextTiles_RenderLine
	ld hl, $4A78
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $2A
	ld bc, $D780
	ld de, $D8C0
	farcall TextTiles_RenderLine
	ld hl, $4A81
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $2A
	ld bc, $DA00
	ld de, $DB40
	farcall TextTiles_RenderLine
	ld hl, $4A8A
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $2A
	ld bc, $DC80
	ld de, $DDC0
	farcall TextTiles_RenderLine
	pop de
	pop bc
	ret

; ---- text $4A3D-$4A66 (41 bytes) [PROBABLE] text: 6 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated) [clipped from 4A3D-4A93 by higher-priority evidence]

String_2A_4A3D:: ; 2A:4A3D
	db $81, $40, $81, $40, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $F0, $81, $40, $82, $B9, $82, $F1, $82, $BD, $82, $AD, $82, $B5, $82, $C4, $82, $AD, $82, $BE, $82, $B3 ; "　　アドレスを　せんたくしてくださ"
	db $82, $A2, $81, $40, $81, $40, $00 ; "い　　"

; ---- ptrtable $4A66-$4A6C (6 bytes) [PROBABLE] code-pointer table, 3 entries: 3/3 words hit own-bank code starts (start is the operand of ld r16); 0/3 targets executed

String_SaveSenderAddr_Caption:: ; 2A:4A66
Table_2A_4A66::
	dw Label_2A_4081
	dw Label_2A_5A83
	dw Label_2A_5B81

; ---- text $4A6C-$4A93 (39 bytes) [PROBABLE] text: 6 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated) [clipped from 4A3D-4A93 by higher-priority evidence]

String_2A_4A6C:: ; 2A:4A6C
	db $83, $75, $00 ; "ブ"
	db $82, $B7, $82, $E9, $82, $CE, $82, $B5, $00 ; "するばし"
	db $82, $E5, $82, $F0, $81, $40, $82, $A6, $00 ; "ょを　え"
	db $82, $E7, $82, $F1, $82, $C5, $82, $AD, $00 ; "らんでく"
	db $82, $BE, $82, $B3, $82, $A2, $81, $40, $00 ; "ださい　"

; ---- zero $4A93-$4AA0 (13 bytes) [PROBABLE] 13 bytes of $00 between the last string and the tiles at 4AA0 (padding)
	ds $D, $00
