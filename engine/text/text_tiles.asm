; engine/text/text_tiles.asm
; bank 48, $4000-$4223 (547 bytes); pinned by layout.link
; Divide8, TextTiles_RenderLine/RenderGrid (8x16 text to tile buffers)

SECTION "engine/text/text_tiles", ROMX

Divide8:: ; 48:4000
Function_48_4000::
	; [CONFIRMED] 309 insn(s); 309 executed (in up to 12/18 scenarios); entry proven: target of an
	; executed call/far call
	push de
	push hl
	ld e, c
	ld d, $00
	ld l, $00
.l4007 ; 48:4007
	bit 7, c
	jr nz, .l4012
	sla c
	jr z, .l4039
	inc d
	jr .l4007
.l4012 ; 48:4012
	ld h, d
.l4013 ; 48:4013
	ld c, e
	ld d, h
	inc d
	dec d
	jr z, .l401E
.l4019 ; 48:4019
	sla c
	dec d
	jr nz, .l4019
.l401E ; 48:401E
	ld a, b
	cp a, c
	jr c, .l4033
	sub a, c
	ld b, a
	ld c, $01
	ld d, h
	inc d
	dec d
	jr z, .l4030
.l402B ; 48:402B
	sla c
	dec d
	jr nz, .l402B
.l4030 ; 48:4030
	ld a, l
	or a, c
	ld l, a
.l4033 ; 48:4033
	dec h
	ld a, h
	cp a, $FF
	jr nz, .l4013
.l4039 ; 48:4039
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
.loop ; 48:404C
	ldh a, [hRam_FFBB]
	call ReadByteFar
	or a, a
	jr z, .l409C
	ld b, a
	ldh a, [hRam_FFBB]
	call ReadByteFar
	or a, a
	jr z, .l409C
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
	jr nc, .l4086
	ldh a, [hRam_FFB5]
	inc a
	ldh [hRam_FFB5], a
.l4086 ; 48:4086
	ldh a, [hRam_FFB2]
	add a, $10
	ld c, a
	ldh [hRam_FFB2], a
	jr nc, .l4094
	ldh a, [hRam_FFB3]
	inc a
	ldh [hRam_FFB3], a
.l4094 ; 48:4094
	ldh a, [hRam_FFB5]
	ld d, a
	ldh a, [hRam_FFB3]
	ld b, a
	jr .loop
.l409C ; 48:409C
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
.l40C4 ; 48:40C4
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
.l40D3 ; 48:40D3
	ld a, [wTextGridStrBank]
	call ReadByteFar
	or a, a
	jr z, .done
	cp a, $0D
	jr z, .l4141
	ld b, a
	ld a, [wTextGridStrBank]
	call ReadByteFar
	or a, a
	jr z, .done
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
	jr nz, .l40D3
	ld a, [wTextGridStartCol]
	ld [wTextGridColumn], a
	ld b, a
	ld a, [wTextGridWidth]
	add a, b
	jr .l40C4
.l4141 ; 48:4141
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
	jp .l40C4
.done ; 48:4159
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
.l4191 ; 48:4191
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
.l419F ; 48:419F
	ldh a, [hRam_FFBB]
	call ReadByteFar
	or a, a
	jp z, .done
	cp a, $0D
	jr z, .l4202
	ld b, a
	ldh a, [hRam_FFBB]
	call ReadByteFar
	or a, a
	jr z, .done
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
	jr nz, .l419F

	; [PROBABLE] 36 insn(s) reached by static flow only; seeds: exec x36; min discovery hops 0;
	; fall-through of the jrcc at 48:41EA (executed)
	ldh a, [hRam_FFB1]
	inc a
	ldh [hRam_FFB1], a
	ld b, a
	ldh a, [hRam_FFB2]
	cp a, b
	jr z, .done
	ldh a, [hRam_FFB5]
	ldh [hRam_FFB8], a
	ld b, a
	ldh a, [hRam_FFB4]
	add a, b
	push hl
	jr .l4191
.l4202 ; 48:4202
	ldh a, [hRam_FFB1]
	inc a
	ldh [hRam_FFB1], a
	ld b, a
	ldh a, [hRam_FFB2]
	cp a, b
	jr z, .done
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
	jp .l4191

.done ; 48:4222
	; [CONFIRMED] 481 insn(s); 481 executed (in up to 12/18 scenarios) (part of region $4222-$4615)
	ret
