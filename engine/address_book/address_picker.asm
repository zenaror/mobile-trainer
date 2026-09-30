; engine/address_book/address_picker.asm
; bank 2C, $56F2-$6730 (4158 bytes); pinned by layout.link
; address picker (choose one of six slots while writing a mail), shared slot-name helpers

SECTION "engine/address_book/address_picker", ROMX

; ---- words $56F2-$56FE (12 bytes) [CONFIRMED] 6 SRAM record addresses $A69D..$A82D, stride $50 (verified arithmetic progression); byte-identical to the tables of 2F:51B5 etc.; the region was already CONFIRMED as read by executed code

Table_AddrPick_SlotAddrs:: ; 2C:56F2
Table_2C_56F2::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

; ---- code $56FE-$5738 (58 bytes) [CONFIRMED] 24 insn(s); 24 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

AddrPick_Menu:: ; 2C:56FE
Function_2C_56FE::
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
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_2C_5768

; ---- code $5738-$5757 (31 bytes) [CONFIRMED] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 0; fall-through of the jrcc at 2C:5736 (executed) | 13 insn(s) executed; cut out of the PROBABLE region 5738-5768 by apply_coverage --split [executed in 3 scenarios]
	push bc
	call AddrPick_LoadSelection
	pop bc
	dec a
	jr nz, Label_2C_5768
	ld a, c
	cp a, $00
	jr z, Label_2C_5757
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	ld a, $01
	ret

; ---- code $5757-$5768 (17 bytes) [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5738-5768 by apply_coverage --split

Label_2C_5757:: ; 2C:5757
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

; ---- code $5768-$57A7 (63 bytes) [CONFIRMED] 28 insn(s); 28 executed (in up to 1/18 scenarios)

Label_2C_5768:: ; 2C:5768
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_2C_5794
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
	ld a, $FF
	ret

Label_2C_5794:: ; 2C:5794
	ldh a, [hJoyPressedRepeat]
	and a, $40
	call nz, AddrPick_CursorUp
	ldh a, [hJoyPressedRepeat]
	and a, $80
	call nz, AddrPick_CursorDown
	ld d, $10
	jp AddrPick_Menu_Loop

; ---- code $57A7-$580A (99 bytes) [CONFIRMED] 160 insn(s) reached by static flow only; seeds: exec x160; min discovery hops 1; entered by callcc from 2C:579F (executed) | 56 insn(s) executed; cut out of the PROBABLE region 57A7-58AC by apply_coverage --split [executed in 1 scenarios]

AddrPick_CursorDown:: ; 2C:57A7
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
	cp a, $07
	jr nz, Label_2C_57C4
	ld c, $01

Label_2C_57C4:: ; 2C:57C4
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
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld d, c
	dec c
	ld a, c
	cp a, $00
	jr nz, Label_2C_57E9
	ld c, $06

Label_2C_57E9:: ; 2C:57E9
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
	jr nz, Label_2C_5821

; ---- code $580A-$5821 (23 bytes) [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region 57A7-58AC by apply_coverage --split
	ld b, $40
	ld hl, $D4C0

Label_2C_580F:: ; 2C:580F
	xor a, a
	ld [hli], a
	dec b
	jr nz, Label_2C_580F
	ld b, $10
	ld hl, $D514

Label_2C_5819:: ; 2C:5819
	xor a, a
	ld [hli], a
	dec b
	jr nz, Label_2C_5819
	ld a, $01
	ret

; ---- code $5821-$585E (61 bytes) [CONFIRMED] 39 insn(s) executed; cut out of the PROBABLE region 57A7-58AC by apply_coverage --split [executed in 3 scenarios]

Label_2C_5821:: ; 2C:5821
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
	jr nz, Label_2C_5854
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	xor a, a
	ret

Label_2C_5854:: ; 2C:5854
	ld a, [hli]
	ld [de], a
	cp a, $00
	jr z, Label_2C_5860
	inc de
	dec b
	jr nz, Label_2C_5854

; ---- code $585E-$5860 (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 57A7-58AC by apply_coverage --split
	jr Label_2C_5866

; ---- code $5860-$58AC (76 bytes) [CONFIRMED] 50 insn(s) executed; cut out of the PROBABLE region 57A7-58AC by apply_coverage --split [executed in 1 scenarios]

Label_2C_5860:: ; 2C:5860
	xor a, a
	ld [de], a
	inc de
	dec b
	jr nz, Label_2C_5860

Label_2C_5866:: ; 2C:5866
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

Label_2C_587E:: ; 2C:587E
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr z, Label_2C_588A
	dec b
	jr nz, Label_2C_587E
	jr Label_2C_5895

Label_2C_588A:: ; 2C:588A
	ld a, b
	cp a, $00
	jr z, Label_2C_5895
	xor a, a
	ld [de], a
	inc de
	dec b
	jr nz, Label_2C_588A

Label_2C_5895:: ; 2C:5895
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
	ld a, $01
	ret

; ---- code $58AC-$5A12 (358 bytes) [CONFIRMED] 129 insn(s); 129 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

AddrPick_InitScreen:: ; 2C:58AC
Function_2C_58AC::
	farcall Function_00_09B6
	farcall Function_00_0956
	farcall TextTiles_ClearBuffers
	ld bc, $0040
	ld de, $D840
	ld hl, Palette_AddrBook_Obj
	ld a, $2C
	farcall Palette_LoadToBuffer
	call Function_00_0464
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_AddrPick_Bg
	ld a, $2C
	farcall Palette_LoadToBuffer
	call Function_00_0464
	ld de, $8F00
	ld hl, Gfx_AddrBook_Tiles8F00
	ld a, $2C
	ld b, $98
	ld c, $09
	farcall Function_00_0787
	call Function_00_0464
	ld de, $9301
	ld hl, Gfx_AddrPick_Tiles9300
	ld a, $2C
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	call Function_00_0464
	ld de, $9701
	ld hl, Gfx_AddrPick_Tiles9700
	ld a, $2C
	ld b, $97
	ld c, $10
	farcall Function_00_0787
	call Function_00_0464
	ld de, $8000
	ld hl, Data_28_4BD0
	ld a, $28
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	call Function_00_0464
	ld de, $8400
	ld hl, Data_28_4FD0
	ld a, $28
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	call Function_00_0464
	ld bc, $1214
	ld de, $D000
	ld hl, Data_AddrPick_TilemapAttr
	ld a, $2C
	farcall Function_00_08EA
	call Function_00_0464
	ldh a, [rLCDC]
	call Function_00_082C
	call Function_00_0464
	call AddrPick_LoadCaption
	call Function_00_0464
	call AddrBook_UploadTextTiles
	call Function_00_0464
	call AddrPick_InitListAttrs
	call Function_00_0464
	ld bc, $0000
	ld a, $02
	ld c, $01
	call AddrPick_MoveNameHighlight
	call Function_00_0464
	ld a, $03
	ld c, $01
	call AddrPick_MoveNameHighlight
	call Function_00_0464
	ld a, $04
	ld c, $01
	call AddrPick_MoveNameHighlight
	call Function_00_0464
	ld a, $05
	ld c, $01
	call AddrPick_MoveNameHighlight
	call Function_00_0464
	ld a, $06
	ld c, $01
	call AddrPick_MoveNameHighlight
	call Function_00_0464
	ld a, $01
	ld c, $01
	call AddrPick_MoveNameHighlight
	call Function_00_0464
	ld c, $01
	ld a, $80
	ldh [hJoyPressed], a
	call AddrPick_RefreshSlotIcons
	call Function_00_0464
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
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ei
	pop bc
	ld c, $01
	xor a, a
	ld [wTextEditGoalColumn], a
	ret

; ---- code $5A12-$5A25 (19 bytes) [PROBABLE] 10 insn(s): register setup (push bc; ld a,7; ldh [$FF8D]...; ld hl,$DA70; ld de,$7220; ld a,$2C; ld b,1) falling into the FarCall site at 2C:5A25; well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS

Function_2C_5A12:: ; 2C:5A12
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

; ---- code $5A25-$5E51 (1068 bytes) [PROBABLE] 619 insn(s) reached by static flow only; seeds: exec x327, site x292; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $00
	call Function_2C_5CA3
	inc a
	jr z, Label_2C_5A45
	ld hl, $DA70
	ld de, $7230
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2C_5A45:: ; 2C:5A45
	pop bc
	push bc
	ld hl, $DA60
	ld de, $7220
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $01
	call Function_2C_5CA3
	inc a
	jr z, Label_2C_5A71
	ld hl, $DA60
	ld de, $7230
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2C_5A71:: ; 2C:5A71
	pop bc
	push bc
	ld hl, $DA50
	ld de, $7220
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $02
	call Function_2C_5CA3
	inc a
	jr z, Label_2C_5A9D
	ld hl, $DA50
	ld de, $7230
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2C_5A9D:: ; 2C:5A9D
	pop bc
	push bc
	ld hl, $DA40
	ld de, $7220
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $03
	call Function_2C_5CA3
	inc a
	jr z, Label_2C_5AC9
	ld hl, $DA40
	ld de, $7230
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2C_5AC9:: ; 2C:5AC9
	pop bc
	push bc
	ld hl, $DA30
	ld de, $7220
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $04
	call Function_2C_5CA3
	inc a
	jr z, Label_2C_5AF5
	ld hl, $DA30
	ld de, $7230
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2C_5AF5:: ; 2C:5AF5
	pop bc
	push bc
	ld hl, $DA20
	ld de, $7220
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $05
	call Function_2C_5CA3
	inc a
	jr z, Label_2C_5B21
	ld hl, $DA20
	ld de, $7230
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2C_5B21:: ; 2C:5B21
	pop bc
	pop bc
	ld a, c
	cp a, $00
	jp z, Label_2C_5C5B
	dec a
	jp z, Label_2C_5B41
	dec a
	jp z, Label_2C_5B70
	dec a
	jp z, Label_2C_5B9F
	dec a
	jp z, Label_2C_5BCE
	dec a
	jp z, Label_2C_5BFD
	dec a
	jp z, Label_2C_5C2C

Label_2C_5B41:: ; 2C:5B41
	push bc
	ld hl, $DA70
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $00
	call Function_2C_5CA3
	inc a
	jr z, Label_2C_5B6C
	ld hl, $DA70
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2C_5B6C:: ; 2C:5B6C
	pop bc
	jp Label_2C_5C5B

Label_2C_5B70:: ; 2C:5B70
	push bc
	ld hl, $DA60
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $01
	call Function_2C_5CA3
	inc a
	jr z, Label_2C_5B9B
	ld hl, $DA60
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2C_5B9B:: ; 2C:5B9B
	pop bc
	jp Label_2C_5C5B

Label_2C_5B9F:: ; 2C:5B9F
	push bc
	ld hl, $DA50
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $02
	call Function_2C_5CA3
	inc a
	jr z, Label_2C_5BCA
	ld hl, $DA50
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2C_5BCA:: ; 2C:5BCA
	pop bc
	jp Label_2C_5C5B

Label_2C_5BCE:: ; 2C:5BCE
	push bc
	ld hl, $DA40
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $03
	call Function_2C_5CA3
	inc a
	jr z, Label_2C_5BF9
	ld hl, $DA40
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2C_5BF9:: ; 2C:5BF9
	pop bc
	jp Label_2C_5C5B

Label_2C_5BFD:: ; 2C:5BFD
	push bc
	ld hl, $DA30
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $04
	call Function_2C_5CA3
	inc a
	jr z, Label_2C_5C28
	ld hl, $DA30
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2C_5C28:: ; 2C:5C28
	pop bc
	jp Label_2C_5C5B

Label_2C_5C2C:: ; 2C:5C2C
	push bc
	ld hl, $DA20
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $05
	call Function_2C_5CA3
	inc a
	jr z, Label_2C_5C57
	ld hl, $DA20
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2C_5C57:: ; 2C:5C57
	pop bc
	jp Label_2C_5C5B

Label_2C_5C5B:: ; 2C:5C5B
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

Function_2C_5CA3:: ; 2C:5CA3
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
	jr z, Label_2C_5CCE
	ld a, $00
	pop bc
	ret

Label_2C_5CCE:: ; 2C:5CCE
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

Label_2C_5CDC:: ; 2C:5CDC
	ldh a, [rLY]
	cp a, $90
	jr nz, Label_2C_5CDC
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

; ---- code $5E51-$5FB1 (352 bytes) [CONFIRMED] 299 insn(s); 299 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

AddrPick_InitListAttrs:: ; 2C:5E51
Function_2C_5E51::
	push af
	push bc
	ld hl, $9866
	di
	ld a, $01
	ldh [rVBK], a

Label_2C_5E5B:: ; 2C:5E5B
	ldh a, [rLY]
	cp a, $90
	jr nz, Label_2C_5E5B
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

; ---- code $5FB1-$6032 (129 bytes) [PROBABLE] 80 insn(s): complete SRAM-access routine (push af; ld a,1; ldh [$FF8C],a; ld [$4000],a; ld a,$0A ... xor a; ldh [$FFF5],a; ld [$0000],a; pop af; ret); well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS

Function_2C_5FB1:: ; 2C:5FB1
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
	jr z, Label_2C_5FF1
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

Label_2C_5FDF:: ; 2C:5FDF
	dec b
	jr z, Label_2C_5FE6
	add a, $0C
	jr Label_2C_5FDF

Label_2C_5FE6:: ; 2C:5FE6
	ld d, a
	ld b, $03
	ld c, $00
	call AddrBook_DrawSlotName
	pop bc
	jr Label_2C_5FF4

Label_2C_5FF1:: ; 2C:5FF1
	call AddrPick_InitListAttrs

Label_2C_5FF4:: ; 2C:5FF4
	ld a, c
	cp a, $FF
	jr z, Label_2C_6022
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

Label_2C_6010:: ; 2C:6010
	dec b
	jr z, Label_2C_6017
	add a, $0C
	jr Label_2C_6010

Label_2C_6017:: ; 2C:6017
	ld d, a
	ld b, $00
	ld c, $01
	call AddrBook_DrawSlotName
	pop hl
	jr Label_2C_6025

Label_2C_6022:: ; 2C:6022
	call Function_2C_5CD2

Label_2C_6025:: ; 2C:6025
	call AddrBook_UploadTextTiles
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ret

; ---- code $6032-$6072 (64 bytes) [CONFIRMED] 40 insn(s); 40 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

AddrPick_MoveNameHighlight:: ; 2C:6032
Function_2C_6032::
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
	jr z, Label_2C_6072
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

Label_2C_6060:: ; 2C:6060
	dec b
	jr z, Label_2C_6067
	add a, $0C
	jr Label_2C_6060

Label_2C_6067:: ; 2C:6067
	ld d, a
	ld b, $03
	ld c, $00
	call AddrBook_DrawSlotName
	pop bc
	jr Label_2C_6075

; ---- code $6072-$6075 (3 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1; entered by jrcc from 2C:6047 (executed)

Label_2C_6072:: ; 2C:6072
	call AddrPick_InitListAttrs

; ---- code $6075-$6094 (31 bytes) [CONFIRMED] 22 insn(s); 22 executed (in up to 1/18 scenarios)

Label_2C_6075:: ; 2C:6075
	ld a, c
	cp a, $FF
	jr z, Label_2C_60A3
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

Label_2C_6091:: ; 2C:6091
	dec b
	jr z, Label_2C_6098

; ---- code $6094-$6098 (4 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 2C:6092 (executed) [executed in 2 scenarios]
	add a, $0C
	jr Label_2C_6091

; ---- code $6098-$60A3 (11 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)

Label_2C_6098:: ; 2C:6098
	ld d, a
	ld b, $00
	ld c, $01
	call AddrBook_DrawSlotName
	pop hl
	jr Label_2C_60A6

; ---- code $60A3-$60A6 (3 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1; entered by jrcc from 2C:6078 (executed)

Label_2C_60A3:: ; 2C:60A3
	call Function_2C_5CD2

; ---- code $60A6-$60B3 (13 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 1/18 scenarios)

Label_2C_60A6:: ; 2C:60A6
	call AddrBook_UploadTextTiles
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ret

; ---- code $60B3-$614D (154 bytes) [PROBABLE] 102 insn(s): complete SRAM-access routine (same prologue/epilogue as 2C:5FB1); well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS

Function_2C_60B3:: ; 2C:60B3
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

Label_2C_60C7:: ; 2C:60C7
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

Label_2C_60E0:: ; 2C:60E0
	dec b
	jr z, Label_2C_60E7
	add a, $0C
	jr Label_2C_60E0

Label_2C_60E7:: ; 2C:60E7
	ld d, a
	ld b, $03
	ld c, $00
	call AddrBook_DrawSlotName
	pop bc
	pop de
	pop af
	inc a
	dec d
	jr nz, Label_2C_60C7
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

Label_2C_6114:: ; 2C:6114
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

Label_2C_612D:: ; 2C:612D
	dec b
	jr z, Label_2C_6134
	add a, $0C
	jr Label_2C_612D

Label_2C_6134:: ; 2C:6134
	ld d, a
	ld b, $03
	ld c, $00
	call AddrBook_DrawSlotName
	pop bc
	pop de
	pop af
	inc a
	dec d
	jr nz, Label_2C_6114
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ret

; ---- code $614D-$6165 (24 bytes) [CONFIRMED] 11 insn(s); 11 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

AddrBook_DrawSlotName:: ; 2C:614D
Function_2C_614D::
	ld a, $10
	ld [wTextCellsLeft], a

Label_2C_6152:: ; 2C:6152
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [hli]
	cp a, $00
	jr z, Label_2C_61D9

; ---- code $6165-$6176 (17 bytes) [CONFIRMED] 61 insn(s) reached by static flow only; seeds: exec x61; min discovery hops 0; fall-through of the jrcc at 2C:6163 (executed) | 7 insn(s) executed; cut out of the PROBABLE region 6165-61D9 by apply_coverage --split [executed in 8 scenarios]
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2C_61B7
	ld a, [wTextCellsLeft]
	cp a, $01
	jr nz, Label_2C_617A

; ---- code $6176-$617A (4 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6165-61D9 by apply_coverage --split
	pop af
	jp Label_2C_61D9

; ---- code $617A-$61B7 (61 bytes) [CONFIRMED] 35 insn(s) executed; cut out of the PROBABLE region 6165-61D9 by apply_coverage --split [executed in 8 scenarios]

Label_2C_617A:: ; 2C:617A
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
	jr z, Label_2C_61D9
	jr Label_2C_6152

; ---- code $61B7-$61D9 (34 bytes) [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6165-61D9 by apply_coverage --split

Label_2C_61B7:: ; 2C:61B7
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
	jr z, Label_2C_61D9
	jp Label_2C_6152

; ---- code $61D9-$6230 (87 bytes) [CONFIRMED] 45 insn(s); 45 executed (in up to 2/18 scenarios)

Label_2C_61D9:: ; 2C:61D9
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc

Label_2C_61EA:: ; 2C:61EA
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AddrBook_DrawSlotName_BlitGlyphAdvance
	jr Label_2C_61EA

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
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $00
	call AddrPick_IsSlotUsed
	inc a
	jr z, Label_2C_6240

; ---- code $6230-$6240 (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2C:622E (executed) [executed in 3 scenarios]
	ld hl, $DA70
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

; ---- code $6240-$625C (28 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 1/18 scenarios)

Label_2C_6240:: ; 2C:6240
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
	call AddrPick_IsSlotUsed
	inc a
	jr z, Label_2C_626C

; ---- code $625C-$626C (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2C:625A (executed) [executed in 2 scenarios]
	ld hl, $DA60
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

; ---- code $626C-$6288 (28 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 1/18 scenarios)

Label_2C_626C:: ; 2C:626C
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
	call AddrPick_IsSlotUsed
	inc a
	jr z, Label_2C_6298

; ---- code $6288-$6298 (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2C:6286 (executed) [executed in 2 scenarios]
	ld hl, $DA50
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

; ---- code $6298-$62B4 (28 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 1/18 scenarios)

Label_2C_6298:: ; 2C:6298
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
	call AddrPick_IsSlotUsed
	inc a
	jr z, Label_2C_62C4

; ---- code $62B4-$62C4 (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2C:62B2 (executed) [executed in 1 scenarios]
	ld hl, $DA40
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

; ---- code $62C4-$62E0 (28 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 1/18 scenarios)

Label_2C_62C4:: ; 2C:62C4
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
	call AddrPick_IsSlotUsed
	inc a
	jr z, Label_2C_62F0

; ---- code $62E0-$62F0 (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2C:62DE (executed) [executed in 2 scenarios]
	ld hl, $DA30
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

; ---- code $62F0-$630C (28 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 1/18 scenarios)

Label_2C_62F0:: ; 2C:62F0
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
	call AddrPick_IsSlotUsed
	inc a
	jr z, Label_2C_631C

; ---- code $630C-$631C (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2C:630A (executed) [executed in 2 scenarios]
	ld hl, $DA20
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

; ---- code $631C-$6328 (12 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)

Label_2C_631C:: ; 2C:631C
	pop bc
	pop bc
	ld a, c
	cp a, $00
	jp z, Label_2C_6456
	dec a
	jp z, Label_2C_633C

; ---- code $6328-$633C (20 bytes) [CONFIRMED] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 0; fall-through of the jpcc at 2C:6325 (executed) [executed in 3 scenarios]
	dec a
	jp z, Label_2C_636B
	dec a
	jp z, Label_2C_639A
	dec a
	jp z, Label_2C_63C9
	dec a
	jp z, Label_2C_63F8
	dec a
	jp z, Label_2C_6427

; ---- code $633C-$6357 (27 bytes) [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)

Label_2C_633C:: ; 2C:633C
	push bc
	ld hl, $DA70
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $00
	call AddrPick_IsSlotUsed
	inc a
	jr z, Label_2C_6367

; ---- code $6357-$6367 (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2C:6355 (executed) [executed in 3 scenarios]
	ld hl, $DA70
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

; ---- code $6367-$636B (4 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)

Label_2C_6367:: ; 2C:6367
	pop bc
	jp Label_2C_6456

; ---- code $636B-$6456 (235 bytes) [CONFIRMED] 95 insn(s) reached by static flow only; seeds: exec x95; min discovery hops 1; entered by jpcc from 2C:6329 (PROBABLE code) [executed in 1 scenarios]

Label_2C_636B:: ; 2C:636B
	push bc
	ld hl, $DA60
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $01
	call AddrPick_IsSlotUsed
	inc a
	jr z, Label_2C_6396
	ld hl, $DA60
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2C_6396:: ; 2C:6396
	pop bc
	jp Label_2C_6456

Label_2C_639A:: ; 2C:639A
	push bc
	ld hl, $DA50
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $02
	call AddrPick_IsSlotUsed
	inc a
	jr z, Label_2C_63C5
	ld hl, $DA50
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2C_63C5:: ; 2C:63C5
	pop bc
	jp Label_2C_6456

Label_2C_63C9:: ; 2C:63C9
	push bc
	ld hl, $DA40
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $03
	call AddrPick_IsSlotUsed
	inc a
	jr z, Label_2C_63F4
	ld hl, $DA40
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2C_63F4:: ; 2C:63F4
	pop bc
	jp Label_2C_6456

Label_2C_63F8:: ; 2C:63F8
	push bc
	ld hl, $DA30
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $04
	call AddrPick_IsSlotUsed
	inc a
	jr z, Label_2C_6423
	ld hl, $DA30
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2C_6423:: ; 2C:6423
	pop bc
	jp Label_2C_6456

Label_2C_6427:: ; 2C:6427
	push bc
	ld hl, $DA20
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $05
	call AddrPick_IsSlotUsed
	inc a
	jr z, Label_2C_6452
	ld hl, $DA20
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2C_6452:: ; 2C:6452
	pop bc
	jp Label_2C_6456

; ---- code $6456-$64CC (118 bytes) [CONFIRMED] 56 insn(s); 56 executed (in up to 1/18 scenarios)

Label_2C_6456:: ; 2C:6456
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
	jr z, Label_2C_64D0

; ---- code $64CC-$64D0 (4 bytes) [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 2C:64CA (executed) [executed in 3 scenarios]
	ld a, $00
	pop bc
	ret

; ---- code $64D0-$64D4 (4 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)

Label_2C_64D0:: ; 2C:64D0
	ld a, $FF
	pop bc
	ret

; ---- words $64D4-$64E0 (12 bytes) [CONFIRMED] 6 SRAM record addresses $A69D..$A82D, stride $50 (verified arithmetic progression); byte-identical to the tables of 2F:51B5 etc.; the region was already CONFIRMED as read by executed code

Table_AddrPick_SlotAddrs_Icons:: ; 2C:64D4
Table_2C_64D4::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

; ---- code $64E0-$64E8 (8 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

AddrPick_CursorMoveEffect:: ; 2C:64E0
Function_2C_64E0::
	push bc
	dec c
	ld a, c
	cp a, $00
	jp z, Label_2C_6501

; ---- code $64E8-$6501 (25 bytes) [CONFIRMED] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 0; fall-through of the jpcc at 2C:64E5 (executed) [executed in 3 scenarios]
	cp a, $01
	jp z, Label_2C_6536
	cp a, $02
	jp z, Label_2C_656B
	cp a, $03
	jp z, Label_2C_65A0
	cp a, $04
	jp z, Label_2C_65D5
	cp a, $05
	jp z, Label_2C_660A

; ---- code $6501-$6519 (24 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)

Label_2C_6501:: ; 2C:6501
	ld hl, $DA70
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld a, $00
	call AddrPick_IsSlotUsed
	inc a
	jr z, Label_2C_6529

; ---- code $6519-$6529 (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2C:6517 (executed) [executed in 3 scenarios]
	ld hl, $DA70
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

; ---- code $6529-$6536 (13 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)

Label_2C_6529:: ; 2C:6529
	ld a, $28
	ld [wSpriteSlots + 112], a
	ld a, $10
	ld [wSpriteSlots + 113], a
	jp Label_2C_663F

; ---- code $6536-$663F (265 bytes) [CONFIRMED] 95 insn(s) reached by static flow only; seeds: exec x95; min discovery hops 1; entered by jpcc from 2C:64EA (PROBABLE code) [executed in 1 scenarios]

Label_2C_6536:: ; 2C:6536
	ld hl, $DA60
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld a, $01
	call AddrPick_IsSlotUsed
	inc a
	jr z, Label_2C_655E
	ld hl, $DA60
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2C_655E:: ; 2C:655E
	ld a, $34
	ld [wSpriteSlots + 96], a
	ld a, $10
	ld [wSpriteSlots + 97], a
	jp Label_2C_663F

Label_2C_656B:: ; 2C:656B
	ld hl, $DA50
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld a, $02
	call AddrPick_IsSlotUsed
	inc a
	jr z, Label_2C_6593
	ld hl, $DA50
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2C_6593:: ; 2C:6593
	ld a, $40
	ld [wSpriteSlots + 80], a
	ld a, $10
	ld [wSpriteSlots + 81], a
	jp Label_2C_663F

Label_2C_65A0:: ; 2C:65A0
	ld hl, $DA40
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld a, $03
	call AddrPick_IsSlotUsed
	inc a
	jr z, Label_2C_65C8
	ld hl, $DA40
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2C_65C8:: ; 2C:65C8
	ld a, $4C
	ld [wSpriteSlots + 64], a
	ld a, $10
	ld [wSpriteSlots + 65], a
	jp Label_2C_663F

Label_2C_65D5:: ; 2C:65D5
	ld hl, $DA30
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld a, $04
	call AddrPick_IsSlotUsed
	inc a
	jr z, Label_2C_65FD
	ld hl, $DA30
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2C_65FD:: ; 2C:65FD
	ld a, $58
	ld [wSpriteSlots + 48], a
	ld a, $10
	ld [wSpriteSlots + 49], a
	jp Label_2C_663F

Label_2C_660A:: ; 2C:660A
	ld hl, $DA20
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld a, $05
	call AddrPick_IsSlotUsed
	inc a
	jr z, Label_2C_6632
	ld hl, $DA20
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2C_6632:: ; 2C:6632
	ld a, $64
	ld [wSpriteSlots + 32], a
	ld a, $10
	ld [wSpriteSlots + 33], a
	jp Label_2C_663F

; ---- code $663F-$6702 (195 bytes) [CONFIRMED] 95 insn(s); 95 executed (in up to 2/18 scenarios)

Label_2C_663F:: ; 2C:663F
	ld b, $1E
	ld b, $01

Label_2C_6643:: ; 2C:6643
	push bc
	farcall Function_00_0956
	farcall Joypad_Update
	call Function_00_0464
	pop bc
	ldh a, [hJoyHeld]
	and a, $C0
	jr nz, Label_2C_665D
	dec b
	jr nz, Label_2C_6643

Label_2C_665D:: ; 2C:665D
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

Label_2C_66AC:: ; 2C:66AC
	ld a, [de]
	cp a, $8F
	jr nz, Label_2C_66AC
	ld b, $91

Label_2C_66B3:: ; 2C:66B3
	ld a, [de]
	cp a, b
	jr nz, Label_2C_66B3
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

String_AddrPick_Caption:: ; 2C:6704
String_2C_6704::
	db $81, $40, $81, $40, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $F0, $81, $40, $82, $B9, $82, $F1, $82, $BD, $82, $AD, $82, $B5, $82, $C4, $82, $AD, $82, $BE, $82, $B3 ; "　　アドレスを　せんたくしてくださ"
	db $82, $A2, $81, $40, $81, $40, $00 ; "い　　"

; ---- zero $672D-$6730 (3 bytes) [PROBABLE] all-zero padding before an aligned tile/data block (mapper hint: padding-like)
	ds $3, $00
