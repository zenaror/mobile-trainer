; engine/text/canvas.asm
; bank 7F, $41EA-$4C78 (2702 bytes); pinned by layout.link
; glyph colour remap, blit into the tile canvas, VRAM upload, GDMA helper, dotted line glyph

SECTION "engine/text/canvas", ROMX

; ---- code $41EA-$4202 (24 bytes) [CONFIRMED] 43 insn(s); 43 executed (in up to 14/18 scenarios) (part of region $41C5-$4202)

Canvas_RemapGlyphColors:: ; 7F:41EA
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

; ---- code $4202-$4204 (2 bytes) [PROBABLE] entry 0 of the 16-word jump table 7F:42A3 (target $4202): pop hl ; ret (handler that only cleans the stack)

Label_7F_4202:: ; 7F:4202
	pop hl
	ret

; ---- code $4204-$422B (39 bytes) [CONFIRMED] 32 insn(s); 32 executed (in up to 6/18 scenarios)

Label_7F_4204:: ; 7F:4204
	ld b, $0C
	pop hl
	xor a, a

Label_7F_4208:: ; 7F:4208
	inc hl
	ld [hli], a
	dec b
	jr nz, Label_7F_4208
	ret

Label_7F_420E:: ; 7F:420E
	ld b, $0C
	pop hl
	xor a, a

Label_7F_4212:: ; 7F:4212
	ld [hli], a
	inc hl
	dec b
	jr nz, Label_7F_4212
	ret

Label_7F_4218:: ; 7F:4218
	pop hl
	ret

Label_7F_421A:: ; 7F:421A
	ld b, $0C
	pop hl
	xor a, a

Label_7F_421E:: ; 7F:421E
	ld a, $FC
	ld [hli], a
	ld c, a
	ld a, [hld]
	xor a, c
	ld [hli], a
	xor a, a
	ld [hli], a
	dec b
	jr nz, Label_7F_421E
	ret

; ---- code $422B-$424A (31 bytes) [PROBABLE] 24 insn(s) reached by static flow only; seeds: table x24; min discovery hops 0; run starts at an entry of the code-pointer table at 7F:42A5

Label_7F_422B:: ; 7F:422B
	pop hl
	ret

Label_7F_422D:: ; 7F:422D
	ld b, $0C
	pop hl
	xor a, a

Label_7F_4231:: ; 7F:4231
	ld a, $FC
	ld [hli], a
	ld c, a
	ld a, [hld]
	xor a, c
	ld [hli], a
	ld a, $FC
	ld [hli], a
	dec b
	jr nz, Label_7F_4231
	ret

Label_7F_423F:: ; 7F:423F
	ld b, $0C
	pop hl
	ld a, $FC

Label_7F_4244:: ; 7F:4244
	ld [hli], a
	inc hl
	dec b
	jr nz, Label_7F_4244
	ret

; ---- code $424A-$425A (16 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)

Label_7F_424A:: ; 7F:424A
	ld b, $0C
	pop hl

Label_7F_424D:: ; 7F:424D
	ld a, [hli]
	ld c, a
	ld a, $FC
	xor a, c
	ld [hld], a
	xor a, a
	ld [hli], a
	inc hl
	dec b
	jr nz, Label_7F_424D
	ret

; ---- code $425A-$4275 (27 bytes) [PROBABLE] 21 insn(s) reached by static flow only; seeds: table x21; min discovery hops 0; run starts at an entry of the code-pointer table at 7F:42A5

Label_7F_425A:: ; 7F:425A
	ld b, $0C
	pop hl

Label_7F_425D:: ; 7F:425D
	ld a, [hli]
	ld c, a
	ld a, $FC
	ld a, [hl]
	xor a, c
	ld [hli], a
	dec b
	jr nz, Label_7F_425D
	ret

Label_7F_4268:: ; 7F:4268
	pop hl
	ret

Label_7F_426A:: ; 7F:426A
	ld b, $0C
	pop hl
	ld a, $FC

Label_7F_426F:: ; 7F:426F
	inc hl
	ld [hli], a
	dec b
	jr nz, Label_7F_426F
	ret

; ---- code $4275-$4284 (15 bytes) [CONFIRMED] 12 insn(s); 12 executed (in up to 9/18 scenarios)

Label_7F_4275:: ; 7F:4275
	ld b, $0C
	pop hl

Label_7F_4278:: ; 7F:4278
	ld a, $FC
	ld [hli], a
	ld c, a
	ld a, [hld]
	xor a, c
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, Label_7F_4278
	ret

; ---- code $4284-$42A3 (31 bytes) [PROBABLE] 25 insn(s) reached by static flow only; seeds: table x25; min discovery hops 0; run starts at an entry of the code-pointer table at 7F:42A5

Label_7F_4284:: ; 7F:4284
	ld b, $0C
	pop hl

Label_7F_4287:: ; 7F:4287
	ld a, $FC
	ld [hli], a
	ld c, a
	ld a, [hl]
	xor a, c
	ld [hli], a
	dec b
	jr nz, Label_7F_4287
	ret

Label_7F_4292:: ; 7F:4292
	ld b, $0C
	pop hl

Label_7F_4295:: ; 7F:4295
	ld a, [hli]
	ld c, a
	ld a, $FC
	ld [hld], a
	xor a, c
	ld [hli], a
	inc hl
	dec b
	jr nz, Label_7F_4295
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

; ---- code $42C3-$4354 (145 bytes) [CONFIRMED] 92 insn(s); 92 executed (in up to 14/18 scenarios); entry proven: target of an executed call/far call

Canvas_BlitGlyph:: ; 7F:42C3
Function_7F_42C3::
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

Label_7F_42E1:: ; 7F:42E1
	dec d
	jr z, Label_7F_42E7
	add hl, bc
	jr Label_7F_42E1

Label_7F_42E7:: ; 7F:42E7
	sla a
	add a, l
	ld l, a
	ld a, h
	cp a, $DF
	jr c, Label_7F_42F9
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

Label_7F_42F9:: ; 7F:42F9
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

Label_7F_4330:: ; 7F:4330
	dec c
	jr z, Label_7F_4339
	srl a
	rr b
	jr Label_7F_4330

Label_7F_4339:: ; 7F:4339
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
	jr nz, Label_7F_4368

; ---- code $4354-$4368 (20 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 7F:4352 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_4368
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $4368-$4399 (49 bytes) [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)

Label_7F_4368:: ; 7F:4368
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

Label_7F_4375:: ; 7F:4375
	dec c
	jr z, Label_7F_437E
	srl a
	rr b
	jr Label_7F_4375

Label_7F_437E:: ; 7F:437E
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
	jr nz, Label_7F_43AD

; ---- code $4399-$43AD (20 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 7F:4397 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_43AD
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $43AD-$43DE (49 bytes) [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)

Label_7F_43AD:: ; 7F:43AD
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

Label_7F_43BA:: ; 7F:43BA
	dec c
	jr z, Label_7F_43C3
	srl a
	rr b
	jr Label_7F_43BA

Label_7F_43C3:: ; 7F:43C3
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
	jr nz, Label_7F_43F2

; ---- code $43DE-$43F2 (20 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 7F:43DC (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_43F2
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $43F2-$4423 (49 bytes) [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)

Label_7F_43F2:: ; 7F:43F2
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

Label_7F_43FF:: ; 7F:43FF
	dec c
	jr z, Label_7F_4408
	srl a
	rr b
	jr Label_7F_43FF

Label_7F_4408:: ; 7F:4408
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
	jr nz, Label_7F_4437

; ---- code $4423-$4437 (20 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 7F:4421 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_4437
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $4437-$4468 (49 bytes) [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)

Label_7F_4437:: ; 7F:4437
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

Label_7F_4444:: ; 7F:4444
	dec c
	jr z, Label_7F_444D
	srl a
	rr b
	jr Label_7F_4444

Label_7F_444D:: ; 7F:444D
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
	jr nz, Label_7F_447C

; ---- code $4468-$447C (20 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 7F:4466 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_447C
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $447C-$44B8 (60 bytes) [CONFIRMED] 43 insn(s); 43 executed (in up to 14/18 scenarios)

Label_7F_447C:: ; 7F:447C
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

Label_7F_4489:: ; 7F:4489
	dec c
	jr z, Label_7F_4492
	srl a
	rr b
	jr Label_7F_4489

Label_7F_4492:: ; 7F:4492
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
	jr nz, Label_7F_44C1
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_44C1

; ---- code $44B8-$44C1 (9 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 7F:44B6 (executed)
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $44C1-$44F2 (49 bytes) [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)

Label_7F_44C1:: ; 7F:44C1
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

Label_7F_44CE:: ; 7F:44CE
	dec c
	jr z, Label_7F_44D7
	srl a
	rr b
	jr Label_7F_44CE

Label_7F_44D7:: ; 7F:44D7
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
	jr nz, Label_7F_4506

; ---- code $44F2-$4506 (20 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 7F:44F0 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_4506
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $4506-$457C (118 bytes) [CONFIRMED] 84 insn(s); 84 executed (in up to 14/18 scenarios)

Label_7F_4506:: ; 7F:4506
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

Label_7F_4513:: ; 7F:4513
	dec c
	jr z, Label_7F_451C
	srl a
	rr b
	jr Label_7F_4513

Label_7F_451C:: ; 7F:451C
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
	jr nz, Label_7F_454B
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_454B
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

Label_7F_454B:: ; 7F:454B
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

Label_7F_4558:: ; 7F:4558
	dec c
	jr z, Label_7F_4561
	srl a
	rr b
	jr Label_7F_4558

Label_7F_4561:: ; 7F:4561
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
	jr nz, Label_7F_4590

; ---- code $457C-$4590 (20 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 7F:457A (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_4590
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $4590-$45CC (60 bytes) [CONFIRMED] 43 insn(s); 43 executed (in up to 14/18 scenarios)

Label_7F_4590:: ; 7F:4590
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

Label_7F_459D:: ; 7F:459D
	dec c
	jr z, Label_7F_45A6
	srl a
	rr b
	jr Label_7F_459D

Label_7F_45A6:: ; 7F:45A6
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
	jr nz, Label_7F_45D5
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_45D5

; ---- code $45CC-$45D5 (9 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 7F:45CA (executed) [executed in 2 scenarios]
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $45D5-$4606 (49 bytes) [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)

Label_7F_45D5:: ; 7F:45D5
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

Label_7F_45E2:: ; 7F:45E2
	dec c
	jr z, Label_7F_45EB
	srl a
	rr b
	jr Label_7F_45E2

Label_7F_45EB:: ; 7F:45EB
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
	jr nz, Label_7F_461A

; ---- code $4606-$461A (20 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 7F:4604 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_461A
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $461A-$4656 (60 bytes) [CONFIRMED] 43 insn(s); 43 executed (in up to 14/18 scenarios)

Label_7F_461A:: ; 7F:461A
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

Label_7F_4627:: ; 7F:4627
	dec c
	jr z, Label_7F_4630
	srl a
	rr b
	jr Label_7F_4627

Label_7F_4630:: ; 7F:4630
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
	jr nz, Label_7F_465F
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_465F

; ---- code $4656-$465F (9 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 7F:4654 (executed)
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $465F-$4690 (49 bytes) [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)

Label_7F_465F:: ; 7F:465F
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

Label_7F_466C:: ; 7F:466C
	dec c
	jr z, Label_7F_4675
	srl a
	rr b
	jr Label_7F_466C

Label_7F_4675:: ; 7F:4675
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
	jr nz, Label_7F_46A4

; ---- code $4690-$46A4 (20 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 7F:468E (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_46A4
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $46A4-$46D5 (49 bytes) [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)

Label_7F_46A4:: ; 7F:46A4
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

Label_7F_46B1:: ; 7F:46B1
	dec c
	jr z, Label_7F_46BA
	srl a
	rr b
	jr Label_7F_46B1

Label_7F_46BA:: ; 7F:46BA
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
	jr nz, Label_7F_46E9

; ---- code $46D5-$46E9 (20 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 7F:46D3 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_46E9
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $46E9-$471A (49 bytes) [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)

Label_7F_46E9:: ; 7F:46E9
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

Label_7F_46F6:: ; 7F:46F6
	dec c
	jr z, Label_7F_46FF
	srl a
	rr b
	jr Label_7F_46F6

Label_7F_46FF:: ; 7F:46FF
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
	jr nz, Label_7F_472E

; ---- code $471A-$472E (20 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 7F:4718 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_472E
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $472E-$47A4 (118 bytes) [CONFIRMED] 84 insn(s); 84 executed (in up to 14/18 scenarios)

Label_7F_472E:: ; 7F:472E
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

Label_7F_473B:: ; 7F:473B
	dec c
	jr z, Label_7F_4744
	srl a
	rr b
	jr Label_7F_473B

Label_7F_4744:: ; 7F:4744
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
	jr nz, Label_7F_4773
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_4773
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

Label_7F_4773:: ; 7F:4773
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

Label_7F_4780:: ; 7F:4780
	dec c
	jr z, Label_7F_4789
	srl a
	rr b
	jr Label_7F_4780

Label_7F_4789:: ; 7F:4789
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
	jr nz, Label_7F_47B8

; ---- code $47A4-$47B8 (20 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 7F:47A2 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_47B8
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $47B8-$47E9 (49 bytes) [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)

Label_7F_47B8:: ; 7F:47B8
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

Label_7F_47C5:: ; 7F:47C5
	dec c
	jr z, Label_7F_47CE
	srl a
	rr b
	jr Label_7F_47C5

Label_7F_47CE:: ; 7F:47CE
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
	jr nz, Label_7F_47FD

; ---- code $47E9-$47FD (20 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 7F:47E7 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_47FD
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $47FD-$482E (49 bytes) [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)

Label_7F_47FD:: ; 7F:47FD
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

Label_7F_480A:: ; 7F:480A
	dec c
	jr z, Label_7F_4813
	srl a
	rr b
	jr Label_7F_480A

Label_7F_4813:: ; 7F:4813
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
	jr nz, Label_7F_4842

; ---- code $482E-$4842 (20 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 7F:482C (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_4842
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $4842-$4873 (49 bytes) [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)

Label_7F_4842:: ; 7F:4842
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

Label_7F_484F:: ; 7F:484F
	dec c
	jr z, Label_7F_4858
	srl a
	rr b
	jr Label_7F_484F

Label_7F_4858:: ; 7F:4858
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
	jr nz, Label_7F_4887

; ---- code $4873-$4887 (20 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 7F:4871 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_4887
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $4887-$48B8 (49 bytes) [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)

Label_7F_4887:: ; 7F:4887
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

Label_7F_4894:: ; 7F:4894
	dec c
	jr z, Label_7F_489D
	srl a
	rr b
	jr Label_7F_4894

Label_7F_489D:: ; 7F:489D
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
	jr nz, Label_7F_48CC

; ---- code $48B8-$48CC (20 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 7F:48B6 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_48CC
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $48CC-$4908 (60 bytes) [CONFIRMED] 43 insn(s); 43 executed (in up to 14/18 scenarios)

Label_7F_48CC:: ; 7F:48CC
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

Label_7F_48D9:: ; 7F:48D9
	dec c
	jr z, Label_7F_48E2
	srl a
	rr b
	jr Label_7F_48D9

Label_7F_48E2:: ; 7F:48E2
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
	jr nz, Label_7F_4911
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_4911

; ---- code $4908-$4911 (9 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 7F:4906 (executed)
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $4911-$4942 (49 bytes) [CONFIRMED] 36 insn(s); 36 executed (in up to 14/18 scenarios)

Label_7F_4911:: ; 7F:4911
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

Label_7F_491E:: ; 7F:491E
	dec c
	jr z, Label_7F_4927
	srl a
	rr b
	jr Label_7F_491E

Label_7F_4927:: ; 7F:4927
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
	jr nz, Label_7F_4956

; ---- code $4942-$4956 (20 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 7F:4940 (executed)
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_4956
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

; ---- code $4956-$499C (70 bytes) [CONFIRMED] 49 insn(s); 49 executed (in up to 14/18 scenarios)

Label_7F_4956:: ; 7F:4956
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

Label_7F_4963:: ; 7F:4963
	dec c
	jr z, Label_7F_496C
	srl a
	rr b
	jr Label_7F_4963

Label_7F_496C:: ; 7F:496C
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
	jr nz, Label_7F_499B
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_499B
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

Label_7F_499B:: ; 7F:499B
	ret

; ---- data $499C-$49A5 (9 bytes) [PROBABLE] 9-byte mask table 03 81 C0 E0 F0 F8 FC FE FF indexed with c: ld hl,$499C ; add hl,bc ; ld a,[hl] ; ld [$C0D0],a at 7F:4311 (executed; near-identical clones of this reader in the PROBABLE code at 7F:49FA and 7F:4B03 read the table too; entries 0,2,4,6 = bytes 499C,499E,49A0,49A2 read in 14/18 scenarios); extent 9 = distance to the second table

Canvas_BlitMaskCur:: ; 7F:499C
Table_7F_499C::
	db $03, $81, $C0, $E0, $F0, $F8, $FC, $FE, $FF

; ---- data $49A5-$49AE (9 bytes) [PROBABLE] 9-byte mask table FF FF FF 7F 3F 1F 0F 07 03 read as ld hl,$49A5 ; add hl,bc ; ld a,[hl] ; ld [$C0D1],a at 7F:4319 (executed; entries 0,2,4,6 read; clones at 7F:4A02 and 7F:4B0B); pairs with Table_7F_499C

Canvas_BlitMaskNext:: ; 7F:49A5
Table_7F_49A5::
	db $FF, $FF, $FF, $7F, $3F, $1F, $0F, $07, $03

; ---- code $49AE-$4BBC (526 bytes) [PROBABLE] two complete glyph-blit functions of the family of the executed 7F:4956: 49AE-4AAE and 4AAF-4BBB (both start with push hl ; push de ; call $41EA (executed helper) and end with ret; 343 insn, 32 direct targets all land on instruction starts, decoding ends exactly at the PROBABLE code 4BBC); they use the mask tables 7F:499C/49A5 like 4956; 4AAF is referenced by no code word/call found, entries unproven [verifier: the absence of a caller is not evidence against: the executed sibling 7F:4956 has no static caller either; 7F:49F6-4A07 is an instruction-level clone of the executed reader 7F:430D-431E (push hl ; ld c,a ; ld b,0 ; ld hl,$499C ; add hl,bc ; ld a,[hl] ; ld [$C0D0],a ; ld hl,$49A5 ; ... ld [$C0D1],a; verified by decoding both); still no entry, so PROBABLE only through the family evidence]

Function_7F_49AE:: ; 7F:49AE
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

Label_7F_49CA:: ; 7F:49CA
	dec d
	jr z, Label_7F_49D0
	add hl, bc
	jr Label_7F_49CA

Label_7F_49D0:: ; 7F:49D0
	sla a
	add a, l
	ld l, a
	ld a, h
	cp a, $DF
	jr c, Label_7F_49E2
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

Label_7F_49E2:: ; 7F:49E2
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

Label_7F_4A0E:: ; 7F:4A0E
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

Label_7F_4A1C:: ; 7F:4A1C
	dec c
	jr z, Label_7F_4A25
	srl a
	rr b
	jr Label_7F_4A1C

Label_7F_4A25:: ; 7F:4A25
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
	jr nz, Label_7F_4A54
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_4A54
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

Label_7F_4A54:: ; 7F:4A54
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

Label_7F_4A61:: ; 7F:4A61
	dec c
	jr z, Label_7F_4A6A
	srl a
	rr b
	jr Label_7F_4A61

Label_7F_4A6A:: ; 7F:4A6A
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
	jr nz, Label_7F_4A99
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_4A99
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

Label_7F_4A99:: ; 7F:4A99
	pop bc
	ldh a, [rSVBK]
	dec a
	jr z, Label_7F_4AAA
	ld a, $D7
	cp a, h
	jr nz, Label_7F_4AAA
	ld a, $80
	cp a, l
	jr nz, Label_7F_4AAA
	ret

Label_7F_4AAA:: ; 7F:4AAA
	dec b
	jp nz, Label_7F_4A0E
	ret

Function_7F_4AAF:: ; 7F:4AAF
	push hl
	push de
	call Canvas_RemapGlyphColors
	pop de
	ld a, d
	push af
	cp a, $F0
	jr c, Label_7F_4ABD
	ld d, $00

Label_7F_4ABD:: ; 7F:4ABD
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

Label_7F_4AD3:: ; 7F:4AD3
	dec d
	jr z, Label_7F_4AD9
	add hl, bc
	jr Label_7F_4AD3

Label_7F_4AD9:: ; 7F:4AD9
	sla a
	add a, l
	ld l, a
	ld a, h
	cp a, $DF
	jr c, Label_7F_4AEB
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

Label_7F_4AEB:: ; 7F:4AEB
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
	jr c, Label_7F_4B2B
	ld b, a
	xor a, a
	sub a, b
	push af

Label_7F_4B20:: ; 7F:4B20
	inc de
	inc de
	dec a
	jr nz, Label_7F_4B20
	pop af
	ld b, a
	ld a, $0C
	sub a, b
	ld b, a

Label_7F_4B2B:: ; 7F:4B2B
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

Label_7F_4B39:: ; 7F:4B39
	dec c
	jr z, Label_7F_4B42
	srl a
	rr b
	jr Label_7F_4B39

Label_7F_4B42:: ; 7F:4B42
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
	jr nz, Label_7F_4B71
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_4B71
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

Label_7F_4B71:: ; 7F:4B71
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

Label_7F_4B7E:: ; 7F:4B7E
	dec c
	jr z, Label_7F_4B87
	srl a
	rr b
	jr Label_7F_4B7E

Label_7F_4B87:: ; 7F:4B87
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
	jr nz, Label_7F_4BB6
	push de
	ld de, $0130
	add hl, de
	pop de
	ld a, h
	cp a, $DF
	jr c, Label_7F_4BB6
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a

Label_7F_4BB6:: ; 7F:4BB6
	pop bc
	dec b
	jp nz, Label_7F_4B2B
	ret

; ---- code $4BBC-$4C42 (134 bytes) [PROBABLE] 65 insn(s) reached by static flow only; seeds: site x65; min discovery hops 6; entered by call from 7F:4D77 (PROBABLE code) | forced execution: 51/65 instruction starts ran in forced_screens (traces/forced/, not natural evidence; status unchanged)

Canvas_UploadToVram:: ; 7F:4BBC
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
	jr nz, Label_7F_4C0C
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

Label_7F_4C0C:: ; 7F:4C0C
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

Label_7F_4C2F:: ; 7F:4C2F
	ld a, [de]
	cp a, $8F
	jr nz, Label_7F_4C2F
	di
	ld b, $91

Label_7F_4C37:: ; 7F:4C37
	ld a, [de]
	cp a, b
	jr nz, Label_7F_4C37
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ei
	ret

; ---- code $4C42-$4C57 (21 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 5/18 scenarios); entry proven: target of an executed call/far call

Glyph_LoadDottedLine:: ; 7F:4C42
Function_7F_4C42::
	push bc
	push de
	push hl
	ld hl, Glyph_DottedLineData
	ld de, $C0A0
	ld b, $20

Label_7F_4C4D:: ; 7F:4C4D
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_7F_4C4D
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
