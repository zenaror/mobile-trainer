; home/multiply.asm
; bank 00, $0BD4-$0C0E (58 bytes); pinned by layout.link
; Multiply8x16 and helpers

SECTION "home/multiply", ROM0

Function_00_0BD4:: ; 00:0BD4
	; [PROBABLE] HL = A*E (calls 0BFC with D=0), preserves AF and DE [candidate; no static referrer]
	push af
	push de
	ld d, $00
	call Multiply8x16
	pop de
	pop af
	ret

Function_00_0BDE:: ; 00:0BDE
	; [PROBABLE] HL = BC*DE (calls 0BE8), preserves AF, BC, DE [candidate; raw refs 3]
	push af
	push bc
	push de
	call Multiply16
	pop de
	pop bc
	pop af
	ret

Multiply16:: ; 00:0BE8
	; [CONFIRMED] HL = BC * DE (low 16 bits); verified on interpreter [reached via inferred links;
	; raw refs 5] [executed in 21 scenarios]
	ld hl, $0000
	ld a, $10
.loop ; 00:0BED
	srl b
	rr c
	jr nc, .skip
	add hl, de
.skip ; 00:0BF4
	sla e
	rl d
	dec a
	jr nz, .loop
	ret

Multiply8x16:: ; 00:0BFC
	; [CONFIRMED] HL = A * DE (low 16 bits); verified on interpreter [reached via inferred links;
	; raw refs 12] [executed in 37 scenarios]
	ld hl, $0000
	ld b, $08
	or a, a
.loop ; 00:0C02
	rrca
	jr nc, .skip
	add hl, de
.skip ; 00:0C06
	sla e
	rl d
	dec b
	jr nz, .loop
	ret
