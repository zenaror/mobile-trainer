; engine/text/canvas.asm
; bank 7F, $41EA-$4C78 (2702 bytes); pinned by layout.link
; glyph colour remap, blit into the tile canvas, VRAM upload, GDMA helper, dotted line glyph

SECTION "engine/text/canvas", ROMX

Canvas_RemapGlyphColors:: ; 7F:41EA
	; [CONFIRMED] 43 insn(s); 43 executed (in up to 14/18 scenarios) (part of region $41C5-$4202)
	push hl
	sla c
	sla c
	sla c
	sla b
	ld a, b
	add a, c
	ld c, a
	ld b, $00
	ld hl, Canvas_RemapTable
	add hl, bc
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld h, a
	ld l, b
	jp hl

Label_7F_4202:: ; 7F:4202
	; [PROBABLE] entry 0 of the 16-word jump table 7F:42A3 (target $4202): pop hl ; ret (handler
	; that only cleans the stack)
	pop hl
	ret

Label_7F_4204:: ; 7F:4204
	; [CONFIRMED] 32 insn(s); 32 executed (in up to 6/18 scenarios)
	ld b, $0C
	pop hl
	xor a, a
.loop ; 7F:4208
	inc hl
	ld [hli], a
	dec b
	jr nz, .loop
	ret

Label_7F_420E:: ; 7F:420E
	ld b, $0C
	pop hl
	xor a, a
.loop ; 7F:4212
	ld [hli], a
	inc hl
	dec b
	jr nz, .loop
	ret

Label_7F_4218:: ; 7F:4218
	pop hl
	ret

Label_7F_421A:: ; 7F:421A
	ld b, $0C
	pop hl
	xor a, a
.loop ; 7F:421E
	ld a, $FC
	ld [hli], a
	ld c, a
	ld a, [hld]
	xor a, c
	ld [hli], a
	xor a, a
	ld [hli], a
	dec b
	jr nz, .loop
	ret

Label_7F_422B:: ; 7F:422B
	; [PROBABLE] 24 insn(s) reached by static flow only; seeds: table x24; min discovery hops 0; run
	; starts at an entry of the code-pointer table at 7F:42A5
	pop hl
	ret

Label_7F_422D:: ; 7F:422D
	ld b, $0C
	pop hl
	xor a, a
.loop ; 7F:4231
	ld a, $FC
	ld [hli], a
	ld c, a
	ld a, [hld]
	xor a, c
	ld [hli], a
	ld a, $FC
	ld [hli], a
	dec b
	jr nz, .loop
	ret

Label_7F_423F:: ; 7F:423F
	ld b, $0C
	pop hl
	ld a, $FC
.loop ; 7F:4244
	ld [hli], a
	inc hl
	dec b
	jr nz, .loop
	ret

Label_7F_424A:: ; 7F:424A
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)
	ld b, $0C
	pop hl
.loop ; 7F:424D
	ld a, [hli]
	ld c, a
	ld a, $FC
	xor a, c
	ld [hld], a
	xor a, a
	ld [hli], a
	inc hl
	dec b
	jr nz, .loop
	ret

Label_7F_425A:: ; 7F:425A
	; [PROBABLE] 21 insn(s) reached by static flow only; seeds: table x21; min discovery hops 0; run
	; starts at an entry of the code-pointer table at 7F:42A5
	ld b, $0C
	pop hl
.loop ; 7F:425D
	ld a, [hli]
	ld c, a
	ld a, $FC
	ld a, [hl]
	xor a, c
	ld [hli], a
	dec b
	jr nz, .loop
	ret

Label_7F_4268:: ; 7F:4268
	pop hl
	ret

Label_7F_426A:: ; 7F:426A
	ld b, $0C
	pop hl
	ld a, $FC
.loop ; 7F:426F
	inc hl
	ld [hli], a
	dec b
	jr nz, .loop
	ret

Label_7F_4275:: ; 7F:4275
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 9/18 scenarios)
	ld b, $0C
	pop hl
.loop ; 7F:4278
	ld a, $FC
	ld [hli], a
	ld c, a
	ld a, [hld]
	xor a, c
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .loop
	ret

Label_7F_4284:: ; 7F:4284
	; [PROBABLE] 25 insn(s) reached by static flow only; seeds: table x25; min discovery hops 0; run
	; starts at an entry of the code-pointer table at 7F:42A5
	ld b, $0C
	pop hl
.loop ; 7F:4287
	ld a, $FC
	ld [hli], a
	ld c, a
	ld a, [hl]
	xor a, c
	ld [hli], a
	dec b
	jr nz, .loop
	ret

Label_7F_4292:: ; 7F:4292
	ld b, $0C
	pop hl
.loop ; 7F:4295
	ld a, [hli]
	ld c, a
	ld a, $FC
	ld [hld], a
	xor a, c
	ld [hli], a
	inc hl
	dec b
	jr nz, .loop
	ret

Label_7F_42A1:: ; 7F:42A1
	pop hl
	ret

; ---- ptrtable $42A3-$42C3 (32 bytes) [PROBABLE] little-endian word table, 16 entries, monotone=1.00, 0% of targets on string start/after NUL, targets $4202..$42A1; referenced by ld r16,$42A3 at 7F:41F8

Canvas_RemapTable:: ; 7F:42A3
Table_7F_42A3::
	dw Label_7F_4202
	dw Label_7F_4204
	dw Label_7F_420E
	dw Label_7F_4218
	dw Label_7F_421A
	dw Label_7F_422B
	dw Label_7F_422D
	dw Label_7F_423F
	dw Label_7F_424A
	dw Label_7F_425A
	dw Label_7F_4268
	dw Label_7F_426A
	dw Label_7F_4275
	dw Label_7F_4284
	dw Label_7F_4292
	dw Label_7F_42A1

Canvas_BlitGlyph:: ; 7F:42C3
Function_7F_42C3::
	; [CONFIRMED] 92 insn(s); 92 executed (in up to 14/18 scenarios); entry proven: target of an
	; executed call/far call
	push hl
	push de
	call Canvas_RemapGlyphColors
	pop de
	pop hl

Canvas_BlitGlyphNoRemap:: ; 7F:42CA
	push hl
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, d
	and a, $07
	srl d
	srl d
	srl d
	inc d
	ld hl, $D000
	ld bc, $0140
.l42E1 ; 7F:42E1
	dec d
	jr z, .l42E7
	add hl, bc
	jr .l42E1
.l42E7 ; 7F:42E7
	sla a
	add a, l
	ld l, a
	ld a, h
	cp a, $DF
	jr c, .l42F9
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
.l42F9 ; 7F:42F9
	ld a, e
	and a, $07
	ld d, $00
	sla e
	rl d
	srl e
	srl e
	srl e
	srl e
	swap e
	add hl, de
	push hl
	ld c, a
	ld b, $00
	ld hl, Canvas_BlitMaskCur
	add hl, bc
	ld a, [hl]
	ld [wGlyphMaskCur], a
	ld hl, Canvas_BlitMaskNext
	add hl, bc
	ld a, [hl]
	ld [wGlyphMaskNext], a
	pop hl
	pop de
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l4330 ; 7F:4330
	dec c
	jr z, .l4339
	srl a
	rr b
	jr .l4330
.l4339 ; 7F:4339
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l4368

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 7F:4352 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l4368
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l4368 ; 7F:4368
	; [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l4375 ; 7F:4375
	dec c
	jr z, .l437E
	srl a
	rr b
	jr .l4375
.l437E ; 7F:437E
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l43AD

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 7F:4397 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l43AD
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l43AD ; 7F:43AD
	; [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l43BA ; 7F:43BA
	dec c
	jr z, .l43C3
	srl a
	rr b
	jr .l43BA
.l43C3 ; 7F:43C3
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l43F2

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 7F:43DC (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l43F2
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l43F2 ; 7F:43F2
	; [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l43FF ; 7F:43FF
	dec c
	jr z, .l4408
	srl a
	rr b
	jr .l43FF
.l4408 ; 7F:4408
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l4437

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 7F:4421 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l4437
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l4437 ; 7F:4437
	; [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l4444 ; 7F:4444
	dec c
	jr z, .l444D
	srl a
	rr b
	jr .l4444
.l444D ; 7F:444D
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l447C

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 7F:4466 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l447C
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l447C ; 7F:447C
	; [CONFIRMED] 43 insn(s); 43 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l4489 ; 7F:4489
	dec c
	jr z, .l4492
	srl a
	rr b
	jr .l4489
.l4492 ; 7F:4492
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l44C1
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l44C1

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 7F:44B6 (executed)
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l44C1 ; 7F:44C1
	; [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l44CE ; 7F:44CE
	dec c
	jr z, .l44D7
	srl a
	rr b
	jr .l44CE
.l44D7 ; 7F:44D7
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l4506

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 7F:44F0 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l4506
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l4506 ; 7F:4506
	; [CONFIRMED] 84 insn(s); 84 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l4513 ; 7F:4513
	dec c
	jr z, .l451C
	srl a
	rr b
	jr .l4513
.l451C ; 7F:451C
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l454B
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l454B
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
.l454B ; 7F:454B
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l4558 ; 7F:4558
	dec c
	jr z, .l4561
	srl a
	rr b
	jr .l4558
.l4561 ; 7F:4561
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l4590

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 7F:457A (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l4590
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l4590 ; 7F:4590
	; [CONFIRMED] 43 insn(s); 43 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l459D ; 7F:459D
	dec c
	jr z, .l45A6
	srl a
	rr b
	jr .l459D
.l45A6 ; 7F:45A6
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l45D5
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l45D5

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 7F:45CA (executed) [executed in 2 scenarios]
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l45D5 ; 7F:45D5
	; [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l45E2 ; 7F:45E2
	dec c
	jr z, .l45EB
	srl a
	rr b
	jr .l45E2
.l45EB ; 7F:45EB
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l461A

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 7F:4604 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l461A
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l461A ; 7F:461A
	; [CONFIRMED] 43 insn(s); 43 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l4627 ; 7F:4627
	dec c
	jr z, .l4630
	srl a
	rr b
	jr .l4627
.l4630 ; 7F:4630
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l465F
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l465F

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 7F:4654 (executed)
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l465F ; 7F:465F
	; [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l466C ; 7F:466C
	dec c
	jr z, .l4675
	srl a
	rr b
	jr .l466C
.l4675 ; 7F:4675
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l46A4

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 7F:468E (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l46A4
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l46A4 ; 7F:46A4
	; [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l46B1 ; 7F:46B1
	dec c
	jr z, .l46BA
	srl a
	rr b
	jr .l46B1
.l46BA ; 7F:46BA
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l46E9

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 7F:46D3 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l46E9
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l46E9 ; 7F:46E9
	; [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l46F6 ; 7F:46F6
	dec c
	jr z, .l46FF
	srl a
	rr b
	jr .l46F6
.l46FF ; 7F:46FF
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l472E

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 7F:4718 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l472E
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l472E ; 7F:472E
	; [CONFIRMED] 84 insn(s); 84 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l473B ; 7F:473B
	dec c
	jr z, .l4744
	srl a
	rr b
	jr .l473B
.l4744 ; 7F:4744
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l4773
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l4773
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
.l4773 ; 7F:4773
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l4780 ; 7F:4780
	dec c
	jr z, .l4789
	srl a
	rr b
	jr .l4780
.l4789 ; 7F:4789
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l47B8

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 7F:47A2 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l47B8
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l47B8 ; 7F:47B8
	; [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l47C5 ; 7F:47C5
	dec c
	jr z, .l47CE
	srl a
	rr b
	jr .l47C5
.l47CE ; 7F:47CE
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l47FD

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 7F:47E7 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l47FD
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l47FD ; 7F:47FD
	; [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l480A ; 7F:480A
	dec c
	jr z, .l4813
	srl a
	rr b
	jr .l480A
.l4813 ; 7F:4813
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l4842

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 7F:482C (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l4842
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l4842 ; 7F:4842
	; [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l484F ; 7F:484F
	dec c
	jr z, .l4858
	srl a
	rr b
	jr .l484F
.l4858 ; 7F:4858
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l4887

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 7F:4871 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l4887
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l4887 ; 7F:4887
	; [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l4894 ; 7F:4894
	dec c
	jr z, .l489D
	srl a
	rr b
	jr .l4894
.l489D ; 7F:489D
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l48CC

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 7F:48B6 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l48CC
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l48CC ; 7F:48CC
	; [CONFIRMED] 43 insn(s); 43 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l48D9 ; 7F:48D9
	dec c
	jr z, .l48E2
	srl a
	rr b
	jr .l48D9
.l48E2 ; 7F:48E2
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l4911
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l4911

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 7F:4906 (executed)
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l4911 ; 7F:4911
	; [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l491E ; 7F:491E
	dec c
	jr z, .l4927
	srl a
	rr b
	jr .l491E
.l4927 ; 7F:4927
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l4956

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 7F:4940 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l4956
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

.l4956 ; 7F:4956
	; [CONFIRMED] 49 insn(s); 49 executed (in up to 14/18 scenarios)
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l4963 ; 7F:4963
	dec c
	jr z, .l496C
	srl a
	rr b
	jr .l4963
.l496C ; 7F:496C
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .done
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .done
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
.done ; 7F:499B
	ret

; ---- data $499C-$49A5 (9 bytes) [PROBABLE] 9-byte mask table 03 81 C0 E0 F0 F8 FC FE FF indexed with c: ld hl,$499C ; add hl,bc ; ld a,[hl] ; ld [$C0D0],a at 7F:4311 (executed; near-identical clones of this reader in the PROBABLE code at 7F:49FA and 7F:4B03 read the table too; entries 0,2,4,6 = bytes 499C,499E,49A0,49A2 read in 14/18 scenarios); extent 9 = distance to the second table

Canvas_BlitMaskCur:: ; 7F:499C
Table_7F_499C::
	db $03, $81, $C0, $E0, $F0, $F8, $FC, $FE, $FF

; ---- data $49A5-$49AE (9 bytes) [PROBABLE] 9-byte mask table FF FF FF 7F 3F 1F 0F 07 03 read as ld hl,$49A5 ; add hl,bc ; ld a,[hl] ; ld [$C0D1],a at 7F:4319 (executed; entries 0,2,4,6 read; clones at 7F:4A02 and 7F:4B0B); pairs with Table_7F_499C

Canvas_BlitMaskNext:: ; 7F:49A5
Table_7F_49A5::
	db $FF, $FF, $FF, $7F, $3F, $1F, $0F, $07, $03

Function_7F_49AE:: ; 7F:49AE
	; [PROBABLE] two complete glyph-blit functions of the family of the executed 7F:4956: 49AE-4AAE
	; and 4AAF-4BBB (both start with push hl ; push de ; call $41EA (executed helper) and end with
	; ret; 343 insn, 32 direct targets all land on instruction starts, decoding ends exactly at the
	; PROBABLE code 4BBC); they use the mask tables 7F:499C/49A5 like 4956; 4AAF is referenced by no
	; code word/call found, entries unproven [verifier: the absence of a caller is not evidence
	; against: the executed sibling 7F:4956 has no static caller either; 7F:49F6-4A07 is an
	; instruction-level clone of the executed reader 7F:430D-431E (push hl ; ld c,a ; ld b,0 ; ld
	; hl,$499C ; add hl,bc ; ld a,[hl] ; ld [$C0D0],a ; ld hl,$49A5 ; ... ld [$C0D1],a; verified by
	; decoding both); still no entry, so PROBABLE only through the family evidence]
	push hl
	push de
	call Canvas_RemapGlyphColors
	pop de
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, d
	and a, $07
	srl d
	srl d
	srl d
	inc d
	ld hl, $D000
	ld bc, $0140
.l49CA ; 7F:49CA
	dec d
	jr z, .l49D0
	add hl, bc
	jr .l49CA
.l49D0 ; 7F:49D0
	sla a
	add a, l
	ld l, a
	ld a, h
	cp a, $DF
	jr c, .l49E2
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
.l49E2 ; 7F:49E2
	ld a, e
	and a, $07
	ld d, $00
	sla e
	rl d
	srl e
	srl e
	srl e
	srl e
	swap e
	add hl, de
	push hl
	ld c, a
	ld b, $00
	ld hl, Canvas_BlitMaskCur
	add hl, bc
	ld a, [hl]
	ld [wGlyphMaskCur], a
	ld hl, Canvas_BlitMaskNext
	add hl, bc
	ld a, [hl]
	ld [wGlyphMaskNext], a
	pop hl
	pop de
	ld b, $0C
.l4A0E ; 7F:4A0E
	push bc
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l4A1C ; 7F:4A1C
	dec c
	jr z, .l4A25
	srl a
	rr b
	jr .l4A1C
.l4A25 ; 7F:4A25
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l4A54
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l4A54
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
.l4A54 ; 7F:4A54
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l4A61 ; 7F:4A61
	dec c
	jr z, .l4A6A
	srl a
	rr b
	jr .l4A61
.l4A6A ; 7F:4A6A
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l4A99
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l4A99
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
.l4A99 ; 7F:4A99
	pop bc
	ldh a, [rSVBK]
	dec a
	jr z, .l4AAA
	ld a, $D7
	cp a, h
	jr nz, .l4AAA
	ld a, $80
	cp a, l
	jr nz, .l4AAA
	ret
.l4AAA ; 7F:4AAA
	dec b
	jp nz, .l4A0E
	ret

Function_7F_4AAF:: ; 7F:4AAF
	push hl
	push de
	call Canvas_RemapGlyphColors
	pop de
	ld a, d
	push af
	cp a, $F0
	jr c, .skip
	ld d, $00
.skip ; 7F:4ABD
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, d
	and a, $07
	srl d
	srl d
	srl d
	inc d
	ld hl, $D000
	ld bc, $0140
.l4AD3 ; 7F:4AD3
	dec d
	jr z, .l4AD9
	add hl, bc
	jr .l4AD3
.l4AD9 ; 7F:4AD9
	sla a
	add a, l
	ld l, a
	ld a, h
	cp a, $DF
	jr c, .l4AEB
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
.l4AEB ; 7F:4AEB
	ld a, e
	and a, $07
	ld d, $00
	sla e
	rl d
	srl e
	srl e
	srl e
	srl e
	swap e
	add hl, de
	push hl
	ld c, a
	ld b, $00
	ld hl, Canvas_BlitMaskCur
	add hl, bc
	ld a, [hl]
	ld [wGlyphMaskCur], a
	ld hl, Canvas_BlitMaskNext
	add hl, bc
	ld a, [hl]
	ld [wGlyphMaskNext], a
	pop hl
	pop de
	ld b, $0C
	pop af
	cp a, $F0
	jr c, .l4B2B
	ld b, a
	xor a, a
	sub a, b
	push af
.l4B20 ; 7F:4B20
	inc de
	inc de
	dec a
	jr nz, .l4B20
	pop af
	ld b, a
	ld a, $0C
	sub a, b
	ld b, a
.l4B2B ; 7F:4B2B
	push bc
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l4B39 ; 7F:4B39
	dec c
	jr z, .l4B42
	srl a
	rr b
	jr .l4B39
.l4B42 ; 7F:4B42
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l4B71
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l4B71
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
.l4B71 ; 7F:4B71
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	ld de, $0010
	add hl, de
	ld b, $00
	inc c
	ld e, c
.l4B7E ; 7F:4B7E
	dec c
	jr z, .l4B87
	srl a
	rr b
	jr .l4B7E
.l4B87 ; 7F:4B87
	ld c, a
	ld a, [wGlyphMaskNext]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	ld [hl], a
	ld a, c
	pop hl
	ld b, a
	ld a, [wGlyphMaskCur]
	ld d, a
	ld a, [hl]
	and a, d
	or a, b
	pop de
	pop bc
	ld [hli], a
	ld a, l
	and a, $0F
	jr nz, .l4BB6
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, .l4BB6
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
.l4BB6 ; 7F:4BB6
	pop bc
	dec b
	jp nz, .l4B2B
	ret

Canvas_UploadToVram:: ; 7F:4BBC
	; [PROBABLE] 65 insn(s) reached by static flow only; seeds: site x65; min discovery hops 6;
	; entered by call from 7F:4D77 (PROBABLE code) | forced execution: 51/65 instruction starts ran
	; in forced_screens (traces/forced/, not natural evidence; status unchanged)
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	ld c, $3F
	call Gfx_GdmaAtVBlank
	ld hl, $D400
	ld de, $9400
	ld c, $3F
	call Gfx_GdmaAtVBlank
	ld hl, $D800
	ld de, $8800
	ld c, $6F
	call Gfx_GdmaAtVBlank
	ld c, $77
	dec a
	jr nz, .l4C0C
	ld c, $53
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	call Gfx_GdmaAtVBlank
	ld c, $0F
	ld hl, $D540
	ld de, $9540
	call Gfx_GdmaAtVBlank
	ret
.l4C0C ; 7F:4C0C
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	call Gfx_GdmaAtVBlank
	ret

Gfx_GdmaAtVBlank:: ; 7F:4C20
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, $FF44
.l4C2F ; 7F:4C2F
	ld a, [de]
	cp a, $8F
	jr nz, .l4C2F
	di
	ld b, $91
.l4C37 ; 7F:4C37
	ld a, [de]
	cp a, b
	jr nz, .l4C37
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ei
	ret

Glyph_LoadDottedLine:: ; 7F:4C42
Function_7F_4C42::
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 5/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push de
	push hl
	ld hl, Glyph_DottedLineData
	ld de, $C0A0
	ld b, $20
.loop ; 7F:4C4D
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	pop hl
	pop de
	pop bc
	ret

; ---- data $4C57-$4C77 (32 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown

Glyph_DottedLineData:: ; 7F:4C57
Data_7F_4C57::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $33, $CC, $00, $00, $00, $00, $00, $00, $00, $00

; ---- data $4C77-$4C78 (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint) | observed: single $C9 (ret) between the 32-byte buffer 4C57-4C77 and the code at 4C78; a lone ret stub like 2E:4EB1 (which is called) is possible, but no caller/pointer was found; left unclassified

Data_7F_4C77:: ; 7F:4C77
	db $C9
