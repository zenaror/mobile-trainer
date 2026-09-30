; engine/gfx/tilemap_fill.asm
; bank 48, $4679-$46C6 (77 bytes); pinned by layout.link
; Tilemap_FillRectSequential

SECTION "engine/gfx/tilemap_fill", ROMX

; ---- code $4679-$46C6 (77 bytes) [CONFIRMED] 141 insn(s); 141 executed (in up to 14/18 scenarios) (part of region $462A-$4744)

Tilemap_FillRectSequential:: ; 48:4679
	ld [wRam_C10F], a
	ld a, $07
	ld [wRam_C10E], a
	ld a, [wRam_C10F]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld [wRam_C10F], a
	ld a, [wRam_C10E]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push de
	push hl
	ld a, [wRam_C10F]
	ld d, b

Label_48_469B:: ; 48:469B
	ld e, c

Label_48_469C:: ; 48:469C
	ld [hli], a
	inc a
	dec e
	jr nz, Label_48_469C
	push af
	ld a, $20
	sub a, c
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	pop af
	dec d
	jr nz, Label_48_469B
	pop hl
	ld de, $0400
	add hl, de
	pop de
	xor a, a
	farcall Function_00_091C
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret
