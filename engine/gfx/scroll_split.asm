; engine/gfx/scroll_split.asm
; bank 7F, $7271-$7830 (1471 bytes); pinned by layout.link
; STAT scroll split enable/disable, GDMA at VBlank, scroll step routines and tables

SECTION "engine/gfx/scroll_split", ROMX

Stat_EnableScrollSplit:: ; 7F:7271
Function_7F_7271::
	; [CONFIRMED] 67 insn(s); 67 executed (in up to 7/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
	push bc
	push de
	push hl
	pop hl
	pop de
	pop bc
	pop af
	ldh a, [rIE]
	push af
	di
	ld a, $C3
	ld [wLcdStatVector], a
	ld a, $93
	ld [wLcdStatVector + 1], a
	ld a, $0E
	ld [wLcdStatVector + 2], a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
.loop ; 7F:7297
	ldh a, [rLY]
	cp a, $64
	jr nz, .loop
	ld a, $44
	ldh [rSTAT], a
	xor a, a
	ldh [rLYC], a
	ld [wSplitScrollY], a
	xor a, a
	ldh [rIF], a
	pop af
	or a, $03
	ldh [rIE], a
	ret

Stat_DisableScrollSplit:: ; 7F:72B0
	ldh a, [rIE]
	push af
	di
	ld a, $D9
	ld [wLcdStatVector], a
	xor a, a
	ldh [rIF], a
	pop af
	and a, $FD
	ldh [rIE], a
	ret

Gfx_GdmaAtVBlankNoDi:: ; 7F:72C2
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, $FF44
.l72D1 ; 7F:72D1
	ld a, [de]
	cp a, $8F
	jr nz, .l72D1
	ld b, $91
.l72D8 ; 7F:72D8
	ld a, [de]
	cp a, b
	jr nz, .l72D8
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ret

	; [PROBABLE] function 72E2-730D (push bc ; ldh a,[$FF70] ... step [$DA31] toward d by 8 ... far
	; call 00:0956 ; pop bc ; ret) whose tail is the validated far-call site region 7306; entry
	; unproven
	push bc
	ldh a, [rSVBK]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wSpriteSlots + 48], a
	ld a, [wSpriteSlots + 49]
	cp a, d
	jr z, .l72FE
	jr c, .l72FC
	sub a, $08
	jr .l72FE
.l72FC ; 7F:72FC
	add a, $08
.l72FE ; 7F:72FE
	ld [wSpriteSlots + 49], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: site x3; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_UpdateAll
	pop bc
	ret

	; [PROBABLE] twin of 7F:72E2 with step 12 and [$DA51]: function 730E-7339, tail = validated
	; far-call site region 7332; entry unproven
	push bc
	ldh a, [rSVBK]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wSpriteSlots + 80], a
	ld a, [wSpriteSlots + 81]
	cp a, d
	jr z, .l732A
	jr c, .l7328
	sub a, $0C
	jr .l732A
.l7328 ; 7F:7328
	add a, $0C
.l732A ; 7F:732A
	ld [wSpriteSlots + 81], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: site x3; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_UpdateAll
	pop bc
	ret

ScrollSplit_StepUp3:: ; 7F:733A
Function_7F_733A::
	; [CONFIRMED] 35 insn(s); 35 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld hl, ScrollSplit_StepUp3Ptrs
	ld c, d
	sla c
	ld b, $00
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld l, e
	ld h, $00
	add hl, bc
	ld a, [hl]
	ld b, a
	di
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSplitScrollY]
	add a, b
	ld [wSplitScrollY], a
	ei
	ld a, [wSpriteSlots + 64]
	sub a, b
	ld [wSpriteSlots + 64], a
	ld a, [wSpriteSlots + 32]
	sub a, b
	ld [wSpriteSlots + 32], a
	ld a, [wSpriteSlots + 16]
	sub a, b
	ld [wSpriteSlots + 16], a
	inc e
	pop bc
	ret

; ---- words $7375-$7385 (16 bytes) [PROBABLE] 8 x dw row pointers (7385, 7399, 73AD, 73C1, 73D5, 73E9, 73FD, 7411) of the executed function 7F:733A (ld hl,$7375 ; c=2*d ; add hl,bc ; ld a,[hli] ; ld c,a ; ld b,[hl]); the first entry is CONFIRMED read data

ScrollSplit_StepUp3Ptrs:: ; 7F:7375
Table_7F_7375::
	dw ScrollSplit_StepUp3Deltas, $7399, $73AD, $73C1, $73D5, $73E9, $73FD, $7411

; ---- data $7385-$7425 (160 bytes) [PROBABLE] 8 rows of 20 bytes (stride $14) of per-step values indexed [row d][column e] by the scroll-step function 7F:733A (ld hl,$7375 ; c=2*d ; ... ld a,[hli] ; ld c,a ; ld b,[hl] ; ld l,e ; ld h,0 ; add hl,bc ; ld a,[hl] ; b = value subtracted from [$DA10/DA20/DA30/DA40] and added to [$C0D3]); the 12/8 row pointers of the table partition the block exactly up to the next function; 8 x 20 = 160 bytes end exactly at the next function 7F:7425

ScrollSplit_StepUp3Deltas:: ; 7F:7385
Data_7F_7385::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $02, $01, $01
	db $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02, $02, $03, $02
	db $02, $02, $02, $02, $03, $02, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $03, $03, $04, $03, $03, $04, $03, $03, $04, $03, $03, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $04, $05, $04, $05, $04, $04, $04, $05, $04, $05, $04, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $05, $06, $05, $06, $05, $06, $05, $06
	db $05, $06, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $06, $05, $06
	db $05, $06, $05, $06, $05, $06, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00

ScrollSplit_StepUp4:: ; 7F:7425
Function_7F_7425::
	; [CONFIRMED] 38 insn(s); 38 executed (in up to 5/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld hl, ScrollSplit_StepUp4Ptrs
	ld c, d
	sla c
	ld b, $00
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld l, e
	ld h, $00
	add hl, bc
	ld a, [hl]
	ld b, a
	di
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSplitScrollY]
	add a, b
	ld [wSplitScrollY], a
	ei
	ld a, [wSpriteSlots + 64]
	sub a, b
	ld [wSpriteSlots + 64], a
	ld a, [wSpriteSlots + 32]
	sub a, b
	ld [wSpriteSlots + 32], a
	ld a, [wSpriteSlots + 16]
	sub a, b
	ld [wSpriteSlots + 16], a
	ld a, [wSpriteSlots + 48]
	sub a, b
	ld [wSpriteSlots + 48], a
	inc e
	pop bc
	ret

; ---- ptrtable $7467-$747F (24 bytes) [PROBABLE] little-endian word table, 12 entries, monotone=1.00, 75% of targets on string start/after NUL, targets $747F..$7564; referenced by ld r16,$7467 at 7F:7426

ScrollSplit_StepUp4Ptrs:: ; 7F:7467
Table_7F_7467::
	dw ScrollSplit_StepUp4Deltas
	dw $7493
	dw $74A7
	dw $74BB
	dw $74CF
	dw $74E3
	dw $74F7
	dw $750B
	dw $751F
	dw $7533
	dw $7550
	dw $7564

; ---- data $747F-$7578 (249 bytes) [PROBABLE] 12 rows of 20 bytes (stride $14) of per-step values indexed [row d][column e] by the scroll-step function 7F:7425 (ld hl,$7467 ; c=2*d ; ... ld a,[hli] ; ld c,a ; ld b,[hl] ; ld l,e ; ld h,0 ; add hl,bc ; ld a,[hl] ; b = value subtracted from [$DA10/DA20/DA30/DA40] and added to [$C0D3]); the 12/8 row pointers of the table partition the block exactly up to the next function (rows at 747F,7493,...,7533,7550,7564: the pointers of Table_7F_7467; 12 rows x 20 + a 9-byte gap between 7547 and 7550) ending exactly at the executed function 7F:7578

ScrollSplit_StepUp4Deltas:: ; 7F:747F
Data_7F_747F::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $02, $01, $01
	db $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02, $02, $03, $02
	db $02, $02, $02, $02, $03, $02, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $03, $03, $04, $03, $03, $04, $03, $03, $04, $03, $03, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $04, $04, $03, $04, $03, $04, $03, $04, $03, $04, $04, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $05, $06, $05, $06, $05, $06, $05, $06
	db $05, $06, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $06, $05, $06
	db $05, $06, $05, $06, $05, $06, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $05, $05, $05, $06, $05, $05, $05, $06, $05, $05, $05, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
	db $00, $00, $00, $00, $00, $00, $00, $00, $00

ScrollSplit_StepDown3:: ; 7F:7578
Function_7F_7578::
	; [CONFIRMED] 35 insn(s); 35 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld hl, ScrollSplit_StepDown3Ptrs
	ld c, d
	sla c
	ld b, $00
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld l, e
	ld h, $00
	add hl, bc
	ld a, [hl]
	ld b, a
	di
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSplitScrollY]
	sub a, b
	ld [wSplitScrollY], a
	ei
	ld a, [wSpriteSlots + 64]
	add a, b
	ld [wSpriteSlots + 64], a
	ld a, [wSpriteSlots + 32]
	add a, b
	ld [wSpriteSlots + 32], a
	ld a, [wSpriteSlots + 16]
	add a, b
	ld [wSpriteSlots + 16], a
	inc e
	pop bc
	ret

; ---- ptrtable $75B3-$75CB (24 bytes) [PROBABLE] 12 x dw row pointers (75CB, 75DF, ..., 767F, 769C, 76B0) of the executed function 7F:7578 (ld hl,$75B3 ; c=2*d ...); the first word is CONFIRMED read data

ScrollSplit_StepDown3Ptrs:: ; 7F:75B3
Table_7F_75B3::
	dw ScrollSplit_StepDown3Deltas
	dw $75DF
	dw $75F3
	dw $7607
	dw $761B
	dw $762F
	dw $7643
	dw $7657
	dw $766B
	dw $767F
	dw $769C
	dw $76B0

; ---- data $75CB-$76C4 (249 bytes) [PROBABLE] 12 rows of 20 bytes (stride $14) of per-step values indexed [row d][column e] by the scroll-step function 7F:7578 (ld hl,$75B3 ; c=2*d ; ... ld a,[hli] ; ld c,a ; ld b,[hl] ; ld l,e ; ld h,0 ; add hl,bc ; ld a,[hl] ; b = value subtracted from [$DA10/DA20/DA30/DA40] and added to [$C0D3]); the 12/8 row pointers of the table partition the block exactly up to the next function; rows end exactly at the next function 7F:76C4

ScrollSplit_StepDown3Deltas:: ; 7F:75CB
Data_7F_75CB::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $02, $01, $01
	db $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02, $02, $03, $02
	db $02, $02, $02, $02, $03, $02, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $03, $03, $04, $03, $03, $04, $03, $03, $04, $03, $03, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $04, $05, $04, $05, $04, $04, $04, $05, $04, $05, $04, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $05, $06, $05, $06, $05, $06, $05, $06
	db $05, $06, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $06, $05, $06
	db $05, $06, $05, $06, $05, $06, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $05, $05, $05, $06, $05, $05, $05, $06, $05, $05, $05, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
	db $00, $00, $00, $00, $00, $00, $00, $00, $00

ScrollSplit_StepDown4:: ; 7F:76C4
Function_7F_76C4::
	; [CONFIRMED] 38 insn(s); 38 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld hl, ScrollSplit_StepDown4Ptrs
	ld c, d
	sla c
	ld b, $00
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld l, e
	ld h, $00
	add hl, bc
	ld a, [hl]
	ld b, a
	di
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSplitScrollY]
	sub a, b
	ld [wSplitScrollY], a
	ei
	ld a, [wSpriteSlots + 64]
	add a, b
	ld [wSpriteSlots + 64], a
	ld a, [wSpriteSlots + 32]
	add a, b
	ld [wSpriteSlots + 32], a
	ld a, [wSpriteSlots + 16]
	add a, b
	ld [wSpriteSlots + 16], a
	ld a, [wSpriteSlots + 48]
	add a, b
	ld [wSpriteSlots + 48], a
	inc e
	pop bc
	ret

; ---- ptrtable $7706-$771E (24 bytes) [PROBABLE] little-endian word table, 12 entries, monotone=1.00, 75% of targets on string start/after NUL, targets $771E..$7803; referenced by ld r16,$7706 at 7F:76C5

ScrollSplit_StepDown4Ptrs:: ; 7F:7706
Table_7F_7706::
	dw ScrollSplit_StepDown4Deltas
	dw $7732
	dw $7746
	dw $775A
	dw $776E
	dw $7782
	dw $7796
	dw $77AA
	dw $77BE
	dw $77D2
	dw $77EF
	dw $7803

; ---- data $771E-$7817 (249 bytes) [PROBABLE] 12 rows of 20 bytes (stride $14) of per-step values indexed [row d][column e] by the scroll-step function 7F:76C4 (ld hl,$7706 ; c=2*d ; ... ld a,[hli] ; ld c,a ; ld b,[hl] ; ld l,e ; ld h,0 ; add hl,bc ; ld a,[hl] ; b = value subtracted from [$DA10/DA20/DA30/DA40] and added to [$C0D3]); the 12/8 row pointers of the table partition the block exactly up to the next function; the pointers of Table_7F_7706 (771E .. 77D2, 77EF, 7803) end exactly at the code region 7817

ScrollSplit_StepDown4Deltas:: ; 7F:771E
Data_7F_771E::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $02, $01, $01
	db $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02, $02, $03, $02
	db $02, $02, $02, $02, $03, $02, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $03, $03, $04, $03, $03, $04, $03, $03, $04, $03, $03, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $04, $04, $03, $04, $03, $04, $03, $04, $03, $04, $04, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $05, $06, $05, $06, $05, $06, $05, $06
	db $05, $06, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $06, $05, $06
	db $05, $06, $05, $06, $05, $06, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $05, $05, $05, $06, $05, $05, $05, $06, $05, $05, $05, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
	db $00, $00, $00, $00, $00, $00, $00, $00, $00

ScrollSplit_SetCursorSpritesY:: ; 7F:7817
Function_7F_7817::
	; [PROBABLE] 14 insn(s) reached by static flow only; seeds: site x14; min discovery hops 1;
	; entered by far from 7F:7244 (PROBABLE code)
	push bc
	ld b, $00
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	inc c
	ld a, [wSplitScrollY]
	ld b, a
	ld a, $20
	sub a, b
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	pop bc
	ret
