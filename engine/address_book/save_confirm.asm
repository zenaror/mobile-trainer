; engine/address_book/save_confirm.asm
; bank 2A, $6F95-$75A0 (1547 bytes); pinned by layout.link
; address-book 'save entry?' confirmation screen

SECTION "engine/address_book/save_confirm", ROMX

AddrBook_SaveConfirm:: ; 2A:6F95
	; [CONFIRMED] 135 insn(s) reached by static flow only; seeds: exec x135; min discovery hops 2;
	; entered by far from 2F:7F2A (PROBABLE code) [executed in 1 scenarios]
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
	call AddrBook_SaveConfirm_InitScreen
	ld d, $0F
.wait_confirm_delay ; 2A:6FBA
	push bc
	push de
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop de
	pop bc
	dec d
	jp nz, .repeat_confirm_delay
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
	jr nz, .l7034
	push bc
	push de
	play_sfx SFX_SAVE
	pop de
	pop bc
	push bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	call AddrBook_StoreEditBufferToSlot
	xor a, a
	ret
.l7034 ; 2A:7034
	push bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, $FF
	ret
.repeat_confirm_delay ; 2A:7048
	jp .wait_confirm_delay

AddrBook_StoreEditBufferToSlot:: ; 2A:704B
	push af
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wAbookListState
	ld a, [hl]
	ld c, a
	ld b, $00
	sla c
	ld hl, Table_AddrBook_SlotAddrs_Store
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
	ld de, wEditNameBuf
.store_name_bytes ; 2A:7080
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .store_name_bytes
	pop hl
	ld de, $0010
	add hl, de
	ld b, $40
	ld de, wEditAddressBuf
.store_address_bytes ; 2A:7090
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .store_address_bytes
	farcall SramCheck_Bank1Commit
	pop bc
	pop af
	ret

; ---- words $709F-$70AB (12 bytes) [PROBABLE] SRAM address table (6 words $A69D..$A82D (step $50)): the code indexes it by 2*n and loads hl=[table+2n] as the base of a save/record slot in SRAM ($A000-$BFFF); ld hl,$709F at 2A:705B. Values are SRAM addresses, not ROM pointers

Table_AddrBook_SlotAddrs_Store:: ; 2A:709F
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

AddrBook_SaveConfirm_InitScreen:: ; 2A:70AB
	; [CONFIRMED] 148 insn(s) reached by static flow only; seeds: exec x148; min discovery hops 3;
	; entered by call from 2A:6FB5 (PROBABLE code) | 37 insn(s) executed; cut out of the PROBABLE
	; region 70AB-7221 by apply_coverage --split [executed in 4 scenarios]
	push bc
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	farcall LCDOff
	xor a, a
	ldh [rSCY], a
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_AddrSaveConfirm_Bg
	ld a, BANK(Palette_AddrSaveConfirm_Bg)
	farcall Palette_LoadToBuffer
	ld de, $9301
	ld hl, Gfx_AddrSaveConfirm_Tiles9300Vb1
	ld a, BANK(Gfx_AddrSaveConfirm_Tiles9300Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9701
	ld hl, Gfx_AddrSaveConfirm_Tiles9700Vb1
	ld a, BANK(Gfx_AddrSaveConfirm_Tiles9700Vb1)
	ld b, $98
	ld c, $04
	farcall Gfx_StartHDMAWithService
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Data_AddrSaveConfirm_TilemapAttr
	ld a, BANK(Data_AddrSaveConfirm_TilemapAttr)
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	farcall LCDOn
	ld bc, $0000
	pop bc
	ld a, b
	cp a, $FF
	jr nz, .l7154

	; [PROBABLE] 20 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 70AB-7221 by apply_coverage --split
	call AddrBook_SaveConfirm_DrawSlot
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

.l7154 ; 2A:7154
	; [CONFIRMED] 20 insn(s) executed; cut out of the PROBABLE region 70AB-7221 by apply_coverage
	; --split [executed in 4 scenarios]
	call AddrBook_SaveConfirm_DrawEditBuffer
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

AddrBook_SaveConfirm_DrawSlot:: ; 2A:7187
	; [PROBABLE] 71 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 70AB-7221 by apply_coverage --split
	push bc
	ld b, $00
	sla c
	ld hl, Table_AddrBook_SlotAddrs_SaveConfirm
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
	ld de, wEditNameBuf
.copy_name_bytes ; 2A:71B0
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copy_name_bytes
	pop hl
	ld de, $0010
	add hl, de
	ld b, $40
	ld de, wEditAddressBuf
.copy_address_bytes ; 2A:71C0
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copy_address_bytes
	pop bc
	push bc
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $0438
	ld hl, wEditNameBuf
	call AddrBook_SaveConfirm_DrawTextLine16
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

; ---- words $7221-$722D (12 bytes) [PROBABLE] SRAM address table (6 words $A69D..$A82D (step $50)): the code indexes it by 2*n and loads hl=[table+2n] as the base of a save/record slot in SRAM ($A000-$BFFF); ld hl,$7221 at 2A:718B. Values are SRAM addresses, not ROM pointers

Table_AddrBook_SlotAddrs_SaveConfirm:: ; 2A:7221
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

AddrBook_SaveConfirm_DrawEditBuffer:: ; 2A:722D
	; [CONFIRMED] 32 insn(s) reached by static flow only; seeds: exec x32; min discovery hops 5;
	; entered by call from 2A:7154 (PROBABLE code) [executed in 1 scenarios]
	push bc
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $0438
	ld hl, wEditNameBuf
	call AddrBook_SaveConfirm_DrawTextLine16
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

; ---- words $7287-$7293 (12 bytes) [HYPOTHESIS] six SRAM-address words byte-identical to the used table at $7221; no code reference to this copy found, so its purpose/use is unknown

AddrBook_CandidateSramSlotAddressTable_7287:: ; 2A:7287
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

AddrBook_UploadEntryTextTiles:: ; 2A:7293
	; [CONFIRMED] 148 insn(s) reached by static flow only; seeds: exec x148; min discovery hops 5;
	; entered by far from 2A:7219 (PROBABLE code) | 74 insn(s) executed; cut out of the PROBABLE
	; region 7293-73BB by apply_coverage --split [executed in 2 scenarios]
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, wTileStage2
	ld de, $9000
	ld c, $3F
	farcall Gfx_StartHDMAAtVBlank_2A_5C3B
	ld hl, wTileStage2 + $400
	ld de, $9400
	ld c, $3F
	farcall Gfx_StartHDMAAtVBlank_2A_5C3B
	ld hl, wTileStage2 + $800
	ld de, $8800
	ld c, $0F
	farcall Gfx_StartHDMAAtVBlank_2A_5C3B
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

AddrBook_SaveConfirm_DrawTextLine16:: ; 2A:72CF
	ld a, $10
	ld [wTextCellsLeft], a
.read_next_char ; 2A:72D4
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .load_space_glyph_for_padding
	cp a, $0D
	jr z, .l7354
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .draw_ascii_char
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
	call AddrBook_SaveConfirm_DrawTextLine16_BlitGlyphAdvance
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
	jr z, .load_space_glyph_for_padding
	cp a, $01
	jr z, .load_space_glyph_for_padding
	jr .read_next_char

.draw_ascii_char ; 2A:732F
	; [PROBABLE] 32 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7293-73BB by apply_coverage --split
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
	call AddrBook_SaveConfirm_DrawTextLine16_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .load_space_glyph_for_padding
	cp a, $01
	jr z, .load_space_glyph_for_padding
	jr .read_next_char
.l7354 ; 2A:7354
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
	call AddrBook_SaveConfirm_DrawTextLine16_BlitBlankAdvance

.load_space_glyph_for_padding ; 2A:736F
	; [CONFIRMED] 42 insn(s) executed; cut out of the PROBABLE region 7293-73BB by apply_coverage
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
.pad_remaining_cells ; 2A:7380
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AddrBook_SaveConfirm_DrawTextLine16_BlitBlankAdvance
	jr .pad_remaining_cells

AddrBook_SaveConfirm_DrawTextLine16_BlitGlyphAdvance:: ; 2A:738F
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

AddrBook_SaveConfirm_DrawTextLine16_BlitBlankAdvance:: ; 2A:73A3
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

AddrBook_SaveConfirm_DrawTextLine17:: ; 2A:73BB

	; [HYPOTHESIS] no branch/call/pointer to any address in $73BB-$73C0 was found (tgt scan of all
	; code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen
	; code; linear decode is legal and continues exactly into the next region: ld a,$11 ; ld
	; [$C2EE],a - 2-instruction prologue that falls into the next PROBABLE code region, after the
	; ret at 2A:73BA
	ld a, $11
	ld [wTextCellsLeft], a

.read_next_char ; 2A:73C0
	; [PROBABLE] 123 insn(s) reached by static flow only; seeds: site x123; min discovery hops 0;
	; entered by jr from 2A:7419 (PROBABLE code)
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .load_space_glyph_for_padding
	cp a, $0D
	jr z, .l7440
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .draw_ascii_char
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
	call AddrBook_SaveConfirm_DrawTextLine17_BlitGlyphAdvance
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
	jr z, .load_space_glyph_for_padding
	cp a, $01
	jr z, .load_space_glyph_for_padding
	jr .read_next_char
.draw_ascii_char ; 2A:741B
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
	call AddrBook_SaveConfirm_DrawTextLine17_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .load_space_glyph_for_padding
	cp a, $01
	jr z, .load_space_glyph_for_padding
	jr .read_next_char
.l7440 ; 2A:7440
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
	call AddrBook_SaveConfirm_DrawTextLine17_BlitBlankAdvance
.load_space_glyph_for_padding ; 2A:745B
	push bc
	push de
	push hl
	ld b, $20
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
.pad_remaining_cells ; 2A:746C
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AddrBook_SaveConfirm_DrawTextLine17_BlitBlankAdvance
	jr .pad_remaining_cells

AddrBook_SaveConfirm_DrawTextLine17_BlitGlyphAdvance:: ; 2A:747B

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

AddrBook_SaveConfirm_DrawTextLine17_BlitBlankAdvance:: ; 2A:748F

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

AddrBook_SaveConfirm_DrawTextLine25:: ; 2A:74A7

	; [HYPOTHESIS] no branch/call/pointer to any address in $74A7-$74AC was found (tgt scan of all
	; code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen
	; code; linear decode is legal and continues exactly into the next region: ld a,$19 ; ld
	; [$C2EE],a - 2-instruction prologue that falls into the next PROBABLE code region, after the
	; ret at 2A:74A6
	ld a, $19
	ld [wTextCellsLeft], a

.read_next_char ; 2A:74AC
	; [PROBABLE] 123 insn(s) reached by static flow only; seeds: site x123; min discovery hops 0;
	; entered by jr from 2A:7505 (PROBABLE code)
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .load_space_glyph_for_padding
	cp a, $0D
	jr z, .l752C
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .draw_ascii_char
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
	call AddrBook_SaveConfirm_DrawTextLine25_BlitGlyphAdvance
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
	jr z, .load_space_glyph_for_padding
	cp a, $01
	jr z, .load_space_glyph_for_padding
	jr .read_next_char
.draw_ascii_char ; 2A:7507
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
	call AddrBook_SaveConfirm_DrawTextLine25_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .load_space_glyph_for_padding
	cp a, $01
	jr z, .load_space_glyph_for_padding
	jr .read_next_char
.l752C ; 2A:752C
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
	call AddrBook_SaveConfirm_DrawTextLine25_BlitBlankAdvance
.load_space_glyph_for_padding ; 2A:7547
	push bc
	push de
	push hl
	ld b, $20
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
.pad_remaining_cells ; 2A:7558
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AddrBook_SaveConfirm_DrawTextLine25_BlitBlankAdvance
	jr .pad_remaining_cells

AddrBook_SaveConfirm_DrawTextLine25_BlitGlyphAdvance:: ; 2A:7567

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

AddrBook_SaveConfirm_DrawTextLine25_BlitBlankAdvance:: ; 2A:757B

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

; ---- zero $7593-$75A0 (13 bytes) [PROBABLE] 13 bytes of $00 padding after the ret at 7592, before the palette at 75A0
	ds $D, $00
