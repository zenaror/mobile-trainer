; engine/text/text_tiles.asm
; bank 48, $4000-$4223 (547 bytes); pinned by layout.link
; Divide8, TextTiles_RenderLine/RenderGrid (8x16 text to tile buffers)

SECTION "engine/text/text_tiles", ROMX

; ---- code $4000-$41EC (492 bytes) [CONFIRMED] 309 insn(s); 309 executed (in up to 12/18 scenarios); entry proven: target of an executed call/far call

Divide8:: ; 48:4000
Function_48_4000::
	push de
	push hl
	ld e, c
	ld d, $00
	ld l, $00

Label_48_4007:: ; 48:4007
	bit 7, c
	jr nz, Label_48_4012
	sla c
	jr z, Label_48_4039
	inc d
	jr Label_48_4007

Label_48_4012:: ; 48:4012
	ld h, d

Label_48_4013:: ; 48:4013
	ld c, e
	ld d, h
	inc d
	dec d
	jr z, Label_48_401E

Label_48_4019:: ; 48:4019
	sla c
	dec d
	jr nz, Label_48_4019

Label_48_401E:: ; 48:401E
	ld a, b
	cp a, c
	jr c, Label_48_4033
	sub a, c
	ld b, a
	ld c, $01
	ld d, h
	inc d
	dec d
	jr z, Label_48_4030

Label_48_402B:: ; 48:402B
	sla c
	dec d
	jr nz, Label_48_402B

Label_48_4030:: ; 48:4030
	ld a, l
	or a, c
	ld l, a

Label_48_4033:: ; 48:4033
	dec h
	ld a, h
	cp a, $FF
	jr nz, Label_48_4013

Label_48_4039:: ; 48:4039
	ld c, b
	ld b, l
	pop hl
	pop de
	ret

TextTiles_RenderLine:: ; 48:403E
	ldh [hRam_FFBB], a
	ld a, c
	ldh [hRam_FFB2], a
	ld a, b
	ldh [hRam_FFB3], a
	ld a, e
	ldh [hRam_FFB4], a
	ld a, d
	ldh [hRam_FFB5], a

Label_48_404C:: ; 48:404C
	ldh a, [hRam_FFBB]
	call ReadByteFar
	or a, a
	jr z, Label_48_409C
	ld b, a
	ldh a, [hRam_FFBB]
	call ReadByteFar
	or a, a
	jr z, Label_48_409C
	push hl
	ld c, a
	ldh a, [hRam_FFB0]
	ld l, a
	ld h, $00
	push hl
	push de
	push hl
	ldh a, [hRam_FFB2]
	ld l, a
	ldh a, [hRam_FFB3]
	ld h, a
	push hl
	push bc
	farcall Font_BlitGlyph8x16
	add sp, 10
	pop hl
	ldh a, [hRam_FFB4]
	add a, $10
	ld e, a
	ldh [hRam_FFB4], a
	jr nc, Label_48_4086
	ldh a, [hRam_FFB5]
	inc a
	ldh [hRam_FFB5], a

Label_48_4086:: ; 48:4086
	ldh a, [hRam_FFB2]
	add a, $10
	ld c, a
	ldh [hRam_FFB2], a
	jr nc, Label_48_4094
	ldh a, [hRam_FFB3]
	inc a
	ldh [hRam_FFB3], a

Label_48_4094:: ; 48:4094
	ldh a, [hRam_FFB5]
	ld d, a
	ldh a, [hRam_FFB3]
	ld b, a
	jr Label_48_404C

Label_48_409C:: ; 48:409C
	ldh a, [hRam_FFB2]
	ld c, a
	ldh a, [hRam_FFB3]
	ld b, a
	ldh a, [hRam_FFB4]
	ld e, a
	ldh a, [hRam_FFB5]
	ld d, a
	ret

TextTiles_RenderGrid:: ; 48:40A9
	ld [wTextGridStrBank], a
	ldh a, [hRam_FFB0]
	ld [wTextGridWramBank], a
	ld a, c
	ld [wTextGridWidth], a
	ld a, e
	ld [wRam_C16D], a
	ld a, d
	ld [wRam_C16E], a
	ld a, b
	ld [wTextGridStartCol], a
	ld [wTextGridColumn], a

Label_48_40C4:: ; 48:40C4
	push hl
	swap a
	ld l, a
	and a, $0F
	ld h, a
	ld a, l
	and a, $F0
	ld l, a
	add hl, de
	ld d, h
	ld e, l
	pop hl

Label_48_40D3:: ; 48:40D3
	ld a, [wTextGridStrBank]
	call ReadByteFar
	or a, a
	jr z, Label_48_4159
	cp a, $0D
	jr z, Label_48_4141
	ld b, a
	ld a, [wTextGridStrBank]
	call ReadByteFar
	or a, a
	jr z, Label_48_4159
	push de
	push hl
	ld c, a
	ld a, [wTextGridWramBank]
	ld l, a
	ld h, $00
	push hl
	ld a, [wTextGridWidth]
	swap a
	ld h, d
	ld l, e
	ld e, a
	and a, $0F
	ld d, a
	ld a, e
	and a, $F0
	ld e, a
	add hl, de
	push hl
	ld a, l
	sub a, e
	ld e, a
	ld a, h
	sbc a, d
	ld d, a
	ld a, [wTextGridWramBank]
	ld l, a
	ld h, $00
	push hl
	push de
	push bc
	farcall Font_BlitGlyph8x16
	add sp, 10
	pop hl
	pop de
	ld a, $10
	add a, e
	ld e, a
	ld a, d
	adc a, $00
	ld d, a
	ld a, [wTextGridWidth]
	ld b, a
	ld a, [wTextGridColumn]
	inc a
	cp a, b
	ld [wTextGridColumn], a
	jr nz, Label_48_40D3
	ld a, [wTextGridStartCol]
	ld [wTextGridColumn], a
	ld b, a
	ld a, [wTextGridWidth]
	add a, b
	jr Label_48_40C4

Label_48_4141:: ; 48:4141
	inc hl
	ld a, [wTextGridColumn]
	ld b, a
	ld a, [wTextGridWidth]
	ld c, a
	sub a, b
	ld b, a
	ld a, [wTextGridStartCol]
	ld [wTextGridColumn], a
	add a, b
	ld b, a
	ld a, c
	add a, b
	jp Label_48_40C4

Label_48_4159:: ; 48:4159
	ret

TextTiles_RenderGridRows:: ; 48:415A
	ldh [hRam_FFBB], a
	ld a, e
	ldh [hRam_FFB6], a
	ld a, d
	ldh [hRam_FFB7], a
	ld a, b
	ldh [hRam_FFB5], a
	ldh [hRam_FFB8], a
	ld a, c
	ldh [hRam_FFB4], a
	swap a
	ld c, a
	and a, $F0
	ldh [hRam_FFB9], a
	ld a, c
	and a, $0F
	ldh [hRam_FFBA], a
	push hl
	push de
	ldh a, [hRam_FFB4]
	swap a
	ld l, a
	and a, $0F
	ld h, a
	ld a, l
	and a, $F0
	ld l, a
	ld d, h
	ld e, l
	ldh a, [hRam_FFB1]
	call Multiply8x16
	pop de
	add hl, de
	ld d, h
	ld e, l
	ldh a, [hRam_FFB8]

Label_48_4191:: ; 48:4191
	swap a
	ld l, a
	and a, $0F
	ld h, a
	ld a, l
	and a, $F0
	ld l, a
	add hl, de
	ld d, h
	ld e, l
	pop hl

Label_48_419F:: ; 48:419F
	ldh a, [hRam_FFBB]
	call ReadByteFar
	or a, a
	jp z, Label_48_4222
	cp a, $0D
	jr z, Label_48_4202
	ld b, a
	ldh a, [hRam_FFBB]
	call ReadByteFar
	or a, a
	jr z, Label_48_4222
	push de
	push hl
	ld c, a
	ldh a, [hRam_FFB0]
	ld l, a
	ld h, $00
	push hl
	ldh a, [hRam_FFB9]
	add a, e
	ld l, a
	ldh a, [hRam_FFBA]
	adc a, d
	ld h, a
	push hl
	ldh a, [hRam_FFB0]
	ld l, a
	ld h, $00
	push hl
	push de
	push bc
	farcall Font_BlitGlyph8x16
	add sp, 10
	pop hl
	pop de
	ld a, $10
	add a, e
	ld e, a
	ld a, d
	adc a, $00
	ld d, a
	ldh a, [hRam_FFB4]
	ld b, a
	ldh a, [hRam_FFB8]
	inc a
	cp a, b
	ldh [hRam_FFB8], a
	jr nz, Label_48_419F

; ---- code $41EC-$4222 (54 bytes) [PROBABLE] 36 insn(s) reached by static flow only; seeds: exec x36; min discovery hops 0; fall-through of the jrcc at 48:41EA (executed)
	ldh a, [hRam_FFB1]
	inc a
	ldh [hRam_FFB1], a
	ld b, a
	ldh a, [hRam_FFB2]
	cp a, b
	jr z, Label_48_4222
	ldh a, [hRam_FFB5]
	ldh [hRam_FFB8], a
	ld b, a
	ldh a, [hRam_FFB4]
	add a, b
	push hl
	jr Label_48_4191

Label_48_4202:: ; 48:4202
	ldh a, [hRam_FFB1]
	inc a
	ldh [hRam_FFB1], a
	ld b, a
	ldh a, [hRam_FFB2]
	cp a, b
	jr z, Label_48_4222
	inc hl
	ldh a, [hRam_FFB8]
	ld b, a
	ldh a, [hRam_FFB4]
	ld c, a
	sub a, b
	ld b, a
	ldh a, [hRam_FFB5]
	ldh [hRam_FFB8], a
	add a, b
	ld b, a
	ld a, c
	add a, b
	push hl
	jp Label_48_4191

; ---- code $4222-$4223 (1 bytes) [CONFIRMED] 481 insn(s); 481 executed (in up to 12/18 scenarios) (part of region $4222-$4615)

Label_48_4222:: ; 48:4222
	ret
