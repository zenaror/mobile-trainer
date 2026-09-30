; home/multiply.asm
; bank 00, $0BD4-$0C0E (58 bytes); pinned by layout.link
; Multiply8x16 and helpers

SECTION "home/multiply", ROM0

; ---- code $0BD4-$0BDE (10 bytes) [PROBABLE] HL = A*E (calls 0BFC with D=0), preserves AF and DE [candidate; no static referrer]

Function_00_0BD4:: ; 00:0BD4
	push af
	push de
	ld d, $00
	call Multiply8x16
	pop de
	pop af
	ret

; ---- code $0BDE-$0BE8 (10 bytes) [PROBABLE] HL = BC*DE (calls 0BE8), preserves AF, BC, DE [candidate; raw refs 3]

Function_00_0BDE:: ; 00:0BDE
	push af
	push bc
	push de
	call Multiply16
	pop de
	pop bc
	pop af
	ret

; ---- code $0BE8-$0BFC (20 bytes) [CONFIRMED] HL = BC * DE (low 16 bits); verified on interpreter [reached via inferred links; raw refs 5] [executed in 21 scenarios]

Multiply16:: ; 00:0BE8
	ld hl, $0000
	ld a, $10

Label_00_0BED:: ; 00:0BED
	srl b
	rr c
	jr nc, Label_00_0BF4
	add hl, de

Label_00_0BF4:: ; 00:0BF4
	sla e
	rl d
	dec a
	jr nz, Label_00_0BED
	ret

; ---- code $0BFC-$0C0E (18 bytes) [CONFIRMED] HL = A * DE (low 16 bits); verified on interpreter [reached via inferred links; raw refs 12] [executed in 37 scenarios]

Multiply8x16:: ; 00:0BFC
	ld hl, $0000
	ld b, $08
	or a, a

Label_00_0C02:: ; 00:0C02
	rrca
	jr nc, Label_00_0C06
	add hl, de

Label_00_0C06:: ; 00:0C06
	sla e
	rl d
	dec b
	jr nz, Label_00_0C02
	ret
