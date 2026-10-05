; engine/address_book/address_picker.asm
; bank 2C, $56F2-$6730 (4158 bytes); pinned by layout.link
; address picker (choose one of six slots while writing a mail), shared slot-name helpers

SECTION "engine/address_book/address_picker", ROMX

; ---- words $56F2-$56FE (12 bytes) [CONFIRMED] 6 SRAM record addresses $A69D..$A82D, stride $50 (verified arithmetic progression); byte-identical to the tables of 2F:51B5 etc.; the region was already CONFIRMED as read by executed code

Table_AddrPick_SlotAddrs:: ; 2C:56F2
Table_2C_56F2::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

AddrPick_Menu:: ; 2C:56FE
Function_2C_56FE::
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $10
	ld [wStatSplitLine], a
	ld a, $0A
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call AddrPick_InitScreen

AddrPick_Menu_Loop:: ; 2C:5721
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .l5768

	; [CONFIRMED] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 0;
	; fall-through of the jrcc at 2C:5736 (executed) | 13 insn(s) executed; cut out of the PROBABLE
	; region 5738-5768 by apply_coverage --split [executed in 3 scenarios]
	push bc
	call AddrPick_LoadSelection
	pop bc
	dec a
	jr nz, .l5768
	ld a, c
	cp a, $00
	jr z, .l5757
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ld a, $01
	ret

.l5757 ; 2C:5757
	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5738-5768 by apply_coverage --split
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

.l5768 ; 2C:5768
	; [CONFIRMED] 28 insn(s); 28 executed (in up to 1/18 scenarios)
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l5794
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
	ld a, $FF
	ret
.l5794 ; 2C:5794
	ldh a, [hJoyPressedRepeat]
	and a, $40
	call nz, AddrPick_CursorUp
	ldh a, [hJoyPressedRepeat]
	and a, $80
	call nz, AddrPick_CursorDown
	ld d, $10
	jp AddrPick_Menu_Loop

AddrPick_CursorDown:: ; 2C:57A7
	; [CONFIRMED] 160 insn(s) reached by static flow only; seeds: exec x160; min discovery hops 1;
	; entered by callcc from 2C:579F (executed) | 56 insn(s) executed; cut out of the PROBABLE
	; region 57A7-58AC by apply_coverage --split [executed in 1 scenarios]
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld d, c
	inc c
	ld a, c
	cp a, $07
	jr nz, .skip
	ld c, $01
.skip ; 2C:57C4
	ld a, d
	call AddrPick_MoveNameHighlight
	call AddrPick_RefreshSlotIcons
	ret

AddrPick_CursorUp:: ; 2C:57CC
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld d, c
	dec c
	ld a, c
	cp a, $00
	jr nz, .skip
	ld c, $06
.skip ; 2C:57E9
	ld a, d
	call AddrPick_MoveNameHighlight
	call AddrPick_RefreshSlotIcons
	ret

AddrPick_LoadSelection:: ; 2C:57F1
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, c
	cp a, $00
	jr nz, .l5821

	; [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 57A7-58AC by apply_coverage --split
	ld b, $40
	ld hl, $D4C0
.l580F ; 2C:580F
	xor a, a
	ld [hli], a
	dec b
	jr nz, .l580F
	ld b, $10
	ld hl, $D514
.l5819 ; 2C:5819
	xor a, a
	ld [hli], a
	dec b
	jr nz, .l5819
	ld a, $01
	ret

.l5821 ; 2C:5821
	; [CONFIRMED] 39 insn(s) executed; cut out of the PROBABLE region 57A7-58AC by apply_coverage
	; --split [executed in 3 scenarios]
	push bc
	dec c
	ld hl, Table_AddrPick_SlotAddrs
	sla c
	ld b, $00
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, $0010
	add hl, de
	pop bc
	ld b, $40
	ld de, $D4C0
	ld a, [hl]
	cp a, $00
	jr nz, .l5854
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	xor a, a
	ret
.l5854 ; 2C:5854
	ld a, [hli]
	ld [de], a
	cp a, $00
	jr z, .l5860
	inc de
	dec b
	jr nz, .l5854

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 57A7-58AC by apply_coverage --split
	jr .l5866

.l5860 ; 2C:5860
	; [CONFIRMED] 50 insn(s) executed; cut out of the PROBABLE region 57A7-58AC by apply_coverage
	; --split [executed in 1 scenarios]
	xor a, a
	ld [de], a
	inc de
	dec b
	jr nz, .l5860
.l5866 ; 2C:5866
	push bc
	dec c
	ld hl, Table_AddrPick_SlotAddrs
	sla c
	ld b, $00
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, $0000
	add hl, de
	pop bc
	ld b, $10
	ld de, $D514
.l587E ; 2C:587E
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr z, .l588A
	dec b
	jr nz, .l587E
	jr .l5895
.l588A ; 2C:588A
	ld a, b
	cp a, $00
	jr z, .l5895
	xor a, a
	ld [de], a
	inc de
	dec b
	jr nz, .l588A
.l5895 ; 2C:5895
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
	ld a, $01
	ret

AddrPick_InitScreen:: ; 2C:58AC
Function_2C_58AC::
	; [CONFIRMED] 129 insn(s); 129 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	ld bc, $0040
	ld de, $D840
	ld hl, Palette_AddrBook_Obj
	ld a, $2C
	farcall Palette_LoadToBuffer
	call VBlank_Wait
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_AddrPick_Bg
	ld a, $2C
	farcall Palette_LoadToBuffer
	call VBlank_Wait
	ld de, $8F00
	ld hl, Gfx_AddrBook_Tiles8F00
	ld a, $2C
	ld b, $98
	ld c, $09
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld de, $9301
	ld hl, Gfx_AddrPick_Tiles9300Vb1
	ld a, $2C
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld de, $9701
	ld hl, Gfx_AddrPick_Tiles9700Vb1
	ld a, $2C
	ld b, $97
	ld c, $10
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld de, $8000
	ld hl, Gfx_AddrBookShared_Tiles8000
	ld a, $28
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld de, $8400
	ld hl, Gfx_AddrBookShared_Tiles8400
	ld a, $28
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld bc, $1214
	ld de, $D000
	ld hl, Data_AddrPick_TilemapAttr
	ld a, $2C
	farcall Tilemap_CopyRectAndAttr
	call VBlank_Wait
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	call VBlank_Wait
	call AddrPick_LoadCaption
	call VBlank_Wait
	call AddrBook_UploadTextTiles
	call VBlank_Wait
	call AddrPick_InitListAttrs
	call VBlank_Wait
	ld bc, $0000
	ld a, $02
	ld c, $01
	call AddrPick_MoveNameHighlight
	call VBlank_Wait
	ld a, $03
	ld c, $01
	call AddrPick_MoveNameHighlight
	call VBlank_Wait
	ld a, $04
	ld c, $01
	call AddrPick_MoveNameHighlight
	call VBlank_Wait
	ld a, $05
	ld c, $01
	call AddrPick_MoveNameHighlight
	call VBlank_Wait
	ld a, $06
	ld c, $01
	call AddrPick_MoveNameHighlight
	call VBlank_Wait
	ld a, $01
	ld c, $01
	call AddrPick_MoveNameHighlight
	call VBlank_Wait
	ld c, $01
	ld a, $80
	ldh [hJoyPressed], a
	call AddrPick_RefreshSlotIcons
	call VBlank_Wait
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
	ld a, $0A
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
	ld bc, $0006
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	pop bc
	ld c, $01
	xor a, a
	ld [wTextEditGoalColumn], a
	ret

AddrPick_RefreshSlotIcons_2C_5A12:: ; 2C:5A12
Function_2C_5A12::
	; [PROBABLE] 10 insn(s): register setup (push bc; ld a,7; ldh [$FF8D]...; ld hl,$DA70; ld
	; de,$7220; ld a,$2C; ld b,1) falling into the FarCall site at 2C:5A25; well-formed instruction
	; chain (clean decode, all direct targets land on instruction starts, lands exactly on the next
	; code region); no direct caller/table entry found: entry HYPOTHESIS
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push bc
	ld hl, $DA70
	ld de, $7220
	ld a, $2C
	ld b, $01

	; [PROBABLE] 619 insn(s) reached by static flow only; seeds: exec x327, site x292; min discovery
	; hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with
	; decoded code
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $00
	call AddrPick_TestSlotEmpty_2C_5CA3
	inc a
	jr z, .l5A45
	ld hl, $DA70
	ld de, $7230
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l5A45 ; 2C:5A45
	pop bc
	push bc
	ld hl, $DA60
	ld de, $7220
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $01
	call AddrPick_TestSlotEmpty_2C_5CA3
	inc a
	jr z, .l5A71
	ld hl, $DA60
	ld de, $7230
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l5A71 ; 2C:5A71
	pop bc
	push bc
	ld hl, $DA50
	ld de, $7220
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $02
	call AddrPick_TestSlotEmpty_2C_5CA3
	inc a
	jr z, .l5A9D
	ld hl, $DA50
	ld de, $7230
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l5A9D ; 2C:5A9D
	pop bc
	push bc
	ld hl, $DA40
	ld de, $7220
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $03
	call AddrPick_TestSlotEmpty_2C_5CA3
	inc a
	jr z, .l5AC9
	ld hl, $DA40
	ld de, $7230
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l5AC9 ; 2C:5AC9
	pop bc
	push bc
	ld hl, $DA30
	ld de, $7220
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $04
	call AddrPick_TestSlotEmpty_2C_5CA3
	inc a
	jr z, .l5AF5
	ld hl, $DA30
	ld de, $7230
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l5AF5 ; 2C:5AF5
	pop bc
	push bc
	ld hl, $DA20
	ld de, $7220
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $05
	call AddrPick_TestSlotEmpty_2C_5CA3
	inc a
	jr z, .l5B21
	ld hl, $DA20
	ld de, $7230
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l5B21 ; 2C:5B21
	pop bc
	pop bc
	ld a, c
	cp a, $00
	jp z, .l5C5B
	dec a
	jp z, .l5B41
	dec a
	jp z, .l5B70
	dec a
	jp z, .l5B9F
	dec a
	jp z, .l5BCE
	dec a
	jp z, .l5BFD
	dec a
	jp z, .l5C2C
.l5B41 ; 2C:5B41
	push bc
	ld hl, $DA70
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $00
	call AddrPick_TestSlotEmpty_2C_5CA3
	inc a
	jr z, .l5B6C
	ld hl, $DA70
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l5B6C ; 2C:5B6C
	pop bc
	jp .l5C5B
.l5B70 ; 2C:5B70
	push bc
	ld hl, $DA60
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $01
	call AddrPick_TestSlotEmpty_2C_5CA3
	inc a
	jr z, .l5B9B
	ld hl, $DA60
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l5B9B ; 2C:5B9B
	pop bc
	jp .l5C5B
.l5B9F ; 2C:5B9F
	push bc
	ld hl, $DA50
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $02
	call AddrPick_TestSlotEmpty_2C_5CA3
	inc a
	jr z, .l5BCA
	ld hl, $DA50
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l5BCA ; 2C:5BCA
	pop bc
	jp .l5C5B
.l5BCE ; 2C:5BCE
	push bc
	ld hl, $DA40
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $03
	call AddrPick_TestSlotEmpty_2C_5CA3
	inc a
	jr z, .l5BF9
	ld hl, $DA40
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l5BF9 ; 2C:5BF9
	pop bc
	jp .l5C5B
.l5BFD ; 2C:5BFD
	push bc
	ld hl, $DA30
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $04
	call AddrPick_TestSlotEmpty_2C_5CA3
	inc a
	jr z, .l5C28
	ld hl, $DA30
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l5C28 ; 2C:5C28
	pop bc
	jp .l5C5B
.l5C2C ; 2C:5C2C
	push bc
	ld hl, $DA20
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $05
	call AddrPick_TestSlotEmpty_2C_5CA3
	inc a
	jr z, .l5C57
	ld hl, $DA20
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l5C57 ; 2C:5C57
	pop bc
	jp .l5C5B
.l5C5B ; 2C:5C5B
	ld a, $18
	ld [wSpriteSlots + 16], a
	ld a, $10
	ld [wSpriteSlots + 17], a
	ld a, $30
	ld [wSpriteSlots + 112], a
	ld a, $0D
	ld [wSpriteSlots + 113], a
	ld a, $3C
	ld [wSpriteSlots + 96], a
	ld a, $0D
	ld [wSpriteSlots + 97], a
	ld a, $48
	ld [wSpriteSlots + 80], a
	ld a, $0D
	ld [wSpriteSlots + 81], a
	ld a, $54
	ld [wSpriteSlots + 64], a
	ld a, $0D
	ld [wSpriteSlots + 65], a
	ld a, $60
	ld [wSpriteSlots + 48], a
	ld a, $0D
	ld [wSpriteSlots + 49], a
	ld a, $6C
	ld [wSpriteSlots + 32], a
	ld a, $0D
	ld [wSpriteSlots + 33], a
	pop bc
	ret

AddrPick_TestSlotEmpty_2C_5CA3:: ; 2C:5CA3
Function_2C_5CA3::
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
	ld hl, Table_AddrPick_SlotAddrs
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld hl, $0010
	add hl, de
	ld a, [hl]
	cp a, $00
	jr z, .l5CCE
	ld a, $00
	pop bc
	ret
.l5CCE ; 2C:5CCE
	ld a, $FF
	pop bc
	ret

Function_2C_5CD2:: ; 2C:5CD2
	push af
	push bc
	di
	ld a, $01
	ldh [rVBK], a
	ld hl, $9866
.loop ; 2C:5CDC
	ldh a, [rLY]
	cp a, $90
	jr nz, .loop
	ld a, $08
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $9886
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, $04
	ld hl, $98C6
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $98E6
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $9906
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $9926
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $9946
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $9966
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $9986
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $99A6
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $99C6
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ei
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D466
	ld a, $08
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $D486
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, $04
	ld hl, $D4C6
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $D4E6
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $D506
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $D526
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $D546
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $D566
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $D586
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $D5A6
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $D5C6
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	pop bc
	pop af
	ret

AddrPick_InitListAttrs:: ; 2C:5E51
Function_2C_5E51::
	; [CONFIRMED] 299 insn(s); 299 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
	push bc
	ld hl, $9866
	di
	ld a, $01
	ldh [rVBK], a
.loop ; 2C:5E5B
	ldh a, [rLY]
	cp a, $90
	jr nz, .loop
	ld a, $00
	ld hl, $98C6
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $98E6
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $9906
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $9926
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $9946
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $9966
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $9986
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $99A6
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $99C6
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ei
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D466
	ld a, $0C
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $D486
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, $00
	ld hl, $D4C6
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $D4E6
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $D506
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $D526
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $D546
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $D566
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $D586
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $D5A6
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $D5C6
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	pop bc
	pop af
	ret

AddrPick_MoveNameHighlight_X28_2C_5FB1:: ; 2C:5FB1
Function_2C_5FB1::
	; [PROBABLE] 80 insn(s): complete SRAM-access routine (push af; ld a,1; ldh [$FF8C],a; ld
	; [$4000],a; ld a,$0A ... xor a; ldh [$FFF5],a; ld [$0000],a; pop af; ret); well-formed
	; instruction chain (clean decode, all direct targets land on instruction starts, lands exactly
	; on the next code region); no direct caller/table entry found: entry HYPOTHESIS
	push af
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	push bc
	dec a
	dec c
	cp a, $FF
	jr z, .l5FF1
	push bc
	push af
	ld e, a
	sla e
	ld d, $00
	ld hl, Table_AddrPick_SlotAddrs
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
.l5FDF ; 2C:5FDF
	dec b
	jr z, .l5FE6
	add a, $0C
	jr .l5FDF
.l5FE6 ; 2C:5FE6
	ld d, a
	ld b, $03
	ld c, $00
	call AddrBook_DrawSlotName
	pop bc
	jr .l5FF4
.l5FF1 ; 2C:5FF1
	call AddrPick_InitListAttrs
.l5FF4 ; 2C:5FF4
	ld a, c
	cp a, $FF
	jr z, .l6022
	push bc
	ld e, c
	sla e
	ld d, $00
	ld hl, Table_AddrPick_SlotAddrs
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
.l6010 ; 2C:6010
	dec b
	jr z, .l6017
	add a, $0C
	jr .l6010
.l6017 ; 2C:6017
	ld d, a
	ld b, $00
	ld c, $01
	call AddrBook_DrawSlotName
	pop hl
	jr .l6025
.l6022 ; 2C:6022
	call Function_2C_5CD2
.l6025 ; 2C:6025
	call AddrBook_UploadTextTiles
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ret

AddrPick_MoveNameHighlight:: ; 2C:6032
Function_2C_6032::
	; [CONFIRMED] 40 insn(s); 40 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	push bc
	dec a
	dec c
	cp a, $FF
	jr z, .l6072
	push bc
	push af
	ld e, a
	sla e
	ld d, $00
	ld hl, Table_AddrPick_SlotAddrs
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	pop af
	ld de, $0030
	ld b, a
	xor a, a
	inc b
.l6060 ; 2C:6060
	dec b
	jr z, .l6067
	add a, $0C
	jr .l6060
.l6067 ; 2C:6067
	ld d, a
	ld b, $03
	ld c, $00
	call AddrBook_DrawSlotName
	pop bc
	jr .l6075

.l6072 ; 2C:6072
	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by jrcc from 2C:6047 (executed)
	call AddrPick_InitListAttrs

.l6075 ; 2C:6075
	; [CONFIRMED] 22 insn(s); 22 executed (in up to 1/18 scenarios)
	ld a, c
	cp a, $FF
	jr z, .l60A3
	push bc
	ld e, c
	sla e
	ld d, $00
	ld hl, Table_AddrPick_SlotAddrs
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	pop bc
	push hl
	ld de, $0030
	ld b, c
	xor a, a
	inc b
.l6091 ; 2C:6091
	dec b
	jr z, .l6098

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 2C:6092 (executed) [executed in 2 scenarios]
	add a, $0C
	jr .l6091

.l6098 ; 2C:6098
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)
	ld d, a
	ld b, $00
	ld c, $01
	call AddrBook_DrawSlotName
	pop hl
	jr .l60A6

.l60A3 ; 2C:60A3
	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by jrcc from 2C:6078 (executed)
	call Function_2C_5CD2

.l60A6 ; 2C:60A6
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 1/18 scenarios)
	call AddrBook_UploadTextTiles
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ret

Function_2C_60B3:: ; 2C:60B3
	; [PROBABLE] 102 insn(s): complete SRAM-access routine (same prologue/epilogue as 2C:5FB1);
	; well-formed instruction chain (clean decode, all direct targets land on instruction starts,
	; lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS
	push bc
	push af
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	xor a, a
	ld d, $06
.l60C7 ; 2C:60C7
	push af
	push de
	push bc
	push af
	ld e, a
	sla e
	ld d, $00
	ld hl, Table_AddrPick_SlotAddrs
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
.l60E0 ; 2C:60E0
	dec b
	jr z, .l60E7
	add a, $0C
	jr .l60E0
.l60E7 ; 2C:60E7
	ld d, a
	ld b, $03
	ld c, $00
	call AddrBook_DrawSlotName
	pop bc
	pop de
	pop af
	inc a
	dec d
	jr nz, .l60C7
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ret

	push bc
	push af
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	xor a, a
	ld d, $06
.l6114 ; 2C:6114
	push af
	push de
	push bc
	push af
	ld e, a
	sla e
	ld d, $00
	ld hl, Table_AddrPick_SlotAddrs
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	pop af
	ld de, $0030
	ld b, a
	xor a, a
	inc b
.l612D ; 2C:612D
	dec b
	jr z, .l6134
	add a, $0C
	jr .l612D
.l6134 ; 2C:6134
	ld d, a
	ld b, $03
	ld c, $00
	call AddrBook_DrawSlotName
	pop bc
	pop de
	pop af
	inc a
	dec d
	jr nz, .l6114
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ret

AddrBook_DrawSlotName:: ; 2C:614D
Function_2C_614D::
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $10
	ld [wTextCellsLeft], a
.l6152 ; 2C:6152
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [hli]
	cp a, $00
	jr z, .l61D9

	; [CONFIRMED] 61 insn(s) reached by static flow only; seeds: exec x61; min discovery hops 0;
	; fall-through of the jrcc at 2C:6163 (executed) | 7 insn(s) executed; cut out of the PROBABLE
	; region 6165-61D9 by apply_coverage --split [executed in 8 scenarios]
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l61B7
	ld a, [wTextCellsLeft]
	cp a, $01
	jr nz, .l617A

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6165-61D9 by apply_coverage --split
	pop af
	jp .l61D9

.l617A ; 2C:617A
	; [CONFIRMED] 35 insn(s) executed; cut out of the PROBABLE region 6165-61D9 by apply_coverage
	; --split [executed in 8 scenarios]
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
	call AddrBook_DrawSlotName_BlitGlyphAdvance
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
	jr z, .l61D9
	jr .l6152

.l61B7 ; 2C:61B7
	; [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6165-61D9 by apply_coverage --split
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
	call AddrBook_DrawSlotName_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l61D9
	jp .l6152

.l61D9 ; 2C:61D9
	; [CONFIRMED] 45 insn(s); 45 executed (in up to 2/18 scenarios)
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
.l61EA ; 2C:61EA
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AddrBook_DrawSlotName_BlitGlyphAdvance
	jr .l61EA

AddrBook_DrawSlotName_BlitGlyphAdvance:: ; 2C:61F9
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

AddrPick_RefreshSlotIcons:: ; 2C:620D
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push bc
	ld hl, $DA70
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $00
	call AddrPick_IsSlotUsed
	inc a
	jr z, .l6240

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2C:622E (executed) [executed in 3 scenarios]
	ld hl, $DA70
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot

.l6240 ; 2C:6240
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 1/18 scenarios)
	pop bc
	push bc
	ld hl, $DA60
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $01
	call AddrPick_IsSlotUsed
	inc a
	jr z, .l626C

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2C:625A (executed) [executed in 2 scenarios]
	ld hl, $DA60
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot

.l626C ; 2C:626C
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 1/18 scenarios)
	pop bc
	push bc
	ld hl, $DA50
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $02
	call AddrPick_IsSlotUsed
	inc a
	jr z, .l6298

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2C:6286 (executed) [executed in 2 scenarios]
	ld hl, $DA50
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot

.l6298 ; 2C:6298
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 1/18 scenarios)
	pop bc
	push bc
	ld hl, $DA40
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $03
	call AddrPick_IsSlotUsed
	inc a
	jr z, .l62C4

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2C:62B2 (executed) [executed in 1 scenarios]
	ld hl, $DA40
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot

.l62C4 ; 2C:62C4
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 1/18 scenarios)
	pop bc
	push bc
	ld hl, $DA30
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $04
	call AddrPick_IsSlotUsed
	inc a
	jr z, .l62F0

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2C:62DE (executed) [executed in 2 scenarios]
	ld hl, $DA30
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot

.l62F0 ; 2C:62F0
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 1/18 scenarios)
	pop bc
	push bc
	ld hl, $DA20
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $05
	call AddrPick_IsSlotUsed
	inc a
	jr z, .l631C

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2C:630A (executed) [executed in 2 scenarios]
	ld hl, $DA20
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot

.l631C ; 2C:631C
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	pop bc
	pop bc
	ld a, c
	cp a, $00
	jp z, .l6456
	dec a
	jp z, .l633C

	; [CONFIRMED] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 0;
	; fall-through of the jpcc at 2C:6325 (executed) [executed in 3 scenarios]
	dec a
	jp z, .l636B
	dec a
	jp z, .l639A
	dec a
	jp z, .l63C9
	dec a
	jp z, .l63F8
	dec a
	jp z, .l6427

.l633C ; 2C:633C
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)
	push bc
	ld hl, $DA70
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $00
	call AddrPick_IsSlotUsed
	inc a
	jr z, .l6367

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2C:6355 (executed) [executed in 3 scenarios]
	ld hl, $DA70
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot

.l6367 ; 2C:6367
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)
	pop bc
	jp .l6456

.l636B ; 2C:636B
	; [CONFIRMED] 95 insn(s) reached by static flow only; seeds: exec x95; min discovery hops 1;
	; entered by jpcc from 2C:6329 (PROBABLE code) [executed in 1 scenarios]
	push bc
	ld hl, $DA60
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $01
	call AddrPick_IsSlotUsed
	inc a
	jr z, .l6396
	ld hl, $DA60
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l6396 ; 2C:6396
	pop bc
	jp .l6456
.l639A ; 2C:639A
	push bc
	ld hl, $DA50
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $02
	call AddrPick_IsSlotUsed
	inc a
	jr z, .l63C5
	ld hl, $DA50
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l63C5 ; 2C:63C5
	pop bc
	jp .l6456
.l63C9 ; 2C:63C9
	push bc
	ld hl, $DA40
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $03
	call AddrPick_IsSlotUsed
	inc a
	jr z, .l63F4
	ld hl, $DA40
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l63F4 ; 2C:63F4
	pop bc
	jp .l6456
.l63F8 ; 2C:63F8
	push bc
	ld hl, $DA30
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $04
	call AddrPick_IsSlotUsed
	inc a
	jr z, .l6423
	ld hl, $DA30
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l6423 ; 2C:6423
	pop bc
	jp .l6456
.l6427 ; 2C:6427
	push bc
	ld hl, $DA20
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $05
	call AddrPick_IsSlotUsed
	inc a
	jr z, .l6452
	ld hl, $DA20
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l6452 ; 2C:6452
	pop bc
	jp .l6456

.l6456 ; 2C:6456
	; [CONFIRMED] 56 insn(s); 56 executed (in up to 1/18 scenarios)
	ld a, $16
	ld [wSpriteSlots + 16], a
	ld a, $0E
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
	call nz, AddrPick_CursorMoveEffect
	ret

AddrPick_IsSlotUsed:: ; 2C:64A5
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
	ld hl, Table_AddrPick_SlotAddrs_Icons
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld hl, $0010
	add hl, de
	ld a, [hl]
	cp a, $00
	jr z, .l64D0

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 2C:64CA (executed) [executed in 3 scenarios]
	ld a, $00
	pop bc
	ret

.l64D0 ; 2C:64D0
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ld a, $FF
	pop bc
	ret

; ---- words $64D4-$64E0 (12 bytes) [CONFIRMED] 6 SRAM record addresses $A69D..$A82D, stride $50 (verified arithmetic progression); byte-identical to the tables of 2F:51B5 etc.; the region was already CONFIRMED as read by executed code

Table_AddrPick_SlotAddrs_Icons:: ; 2C:64D4
Table_2C_64D4::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

AddrPick_CursorMoveEffect:: ; 2C:64E0
Function_2C_64E0::
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	dec c
	ld a, c
	cp a, $00
	jp z, .l6501

	; [CONFIRMED] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 0;
	; fall-through of the jpcc at 2C:64E5 (executed) [executed in 3 scenarios]
	cp a, $01
	jp z, .l6536
	cp a, $02
	jp z, .l656B
	cp a, $03
	jp z, .l65A0
	cp a, $04
	jp z, .l65D5
	cp a, $05
	jp z, .l660A

.l6501 ; 2C:6501
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)
	ld hl, $DA70
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $00
	call AddrPick_IsSlotUsed
	inc a
	jr z, .l6529

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2C:6517 (executed) [executed in 3 scenarios]
	ld hl, $DA70
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot

.l6529 ; 2C:6529
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)
	ld a, $28
	ld [wSpriteSlots + 112], a
	ld a, $10
	ld [wSpriteSlots + 113], a
	jp .l663F

.l6536 ; 2C:6536
	; [CONFIRMED] 95 insn(s) reached by static flow only; seeds: exec x95; min discovery hops 1;
	; entered by jpcc from 2C:64EA (PROBABLE code) [executed in 1 scenarios]
	ld hl, $DA60
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $01
	call AddrPick_IsSlotUsed
	inc a
	jr z, .l655E
	ld hl, $DA60
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
.l655E ; 2C:655E
	ld a, $34
	ld [wSpriteSlots + 96], a
	ld a, $10
	ld [wSpriteSlots + 97], a
	jp .l663F
.l656B ; 2C:656B
	ld hl, $DA50
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $02
	call AddrPick_IsSlotUsed
	inc a
	jr z, .l6593
	ld hl, $DA50
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
.l6593 ; 2C:6593
	ld a, $40
	ld [wSpriteSlots + 80], a
	ld a, $10
	ld [wSpriteSlots + 81], a
	jp .l663F
.l65A0 ; 2C:65A0
	ld hl, $DA40
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $03
	call AddrPick_IsSlotUsed
	inc a
	jr z, .l65C8
	ld hl, $DA40
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
.l65C8 ; 2C:65C8
	ld a, $4C
	ld [wSpriteSlots + 64], a
	ld a, $10
	ld [wSpriteSlots + 65], a
	jp .l663F
.l65D5 ; 2C:65D5
	ld hl, $DA30
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $04
	call AddrPick_IsSlotUsed
	inc a
	jr z, .l65FD
	ld hl, $DA30
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
.l65FD ; 2C:65FD
	ld a, $58
	ld [wSpriteSlots + 48], a
	ld a, $10
	ld [wSpriteSlots + 49], a
	jp .l663F
.l660A ; 2C:660A
	ld hl, $DA20
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $05
	call AddrPick_IsSlotUsed
	inc a
	jr z, .l6632
	ld hl, $DA20
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
.l6632 ; 2C:6632
	ld a, $64
	ld [wSpriteSlots + 32], a
	ld a, $10
	ld [wSpriteSlots + 33], a
	jp .l663F

.l663F ; 2C:663F
	; [CONFIRMED] 95 insn(s); 95 executed (in up to 2/18 scenarios)
	ld b, $1E
	ld b, $01
.loop ; 2C:6643
	push bc
	farcall Sprite_UpdateAll
	farcall Joypad_Update
	call VBlank_Wait
	pop bc
	ldh a, [hJoyHeld]
	and a, $C0
	jr nz, .l665D
	dec b
	jr nz, .loop
.l665D ; 2C:665D
	pop bc
	ret

AddrBook_UploadTextTiles:: ; 2C:665F
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
	call Gfx_StartHDMAAtVBlank_2C_669D
	ld hl, $D400
	ld de, $9400
	ld c, $3F
	call Gfx_StartHDMAAtVBlank_2C_669D
	ld hl, $D800
	ld de, $8800
	ld c, $3F
	call Gfx_StartHDMAAtVBlank_2C_669D
	ld hl, $DC00
	ld de, $8C00
	ld c, $2F
	call Gfx_StartHDMAAtVBlank_2C_669D
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

Gfx_StartHDMAAtVBlank_2C_669D:: ; 2C:669D
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, $FF44
.l66AC ; 2C:66AC
	ld a, [de]
	cp a, $8F
	jr nz, .l66AC
	ld b, $91
.l66B3 ; 2C:66B3
	ld a, [de]
	cp a, b
	jr nz, .l66B3
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ret

AddrPick_LoadCaption:: ; 2C:66BD
	push bc
	push de
	ld e, $00
	ld d, $00
	sla e
	ld hl, Table_AddrPick_Captions
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $2C
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

; ---- data $6702-$6704 (2 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 6702-672D by higher-priority evidence]

Table_AddrPick_Captions:: ; 2C:6702
Data_2C_6702::
	db $04, $67

; ---- text $6704-$672D (41 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_AddrPick_Caption:: ; 2C:6704
String_2C_6704::
	db "　　アドレスを　せんたくしてください　　", 0
POPC

; ---- zero $672D-$6730 (3 bytes) [PROBABLE] all-zero padding before an aligned tile/data block (mapper hint: padding-like)
	ds $3, $00
