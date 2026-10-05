; engine/gfx/tilemap_fill.asm
; bank 48, $4679-$46C6 (77 bytes); pinned by layout.link
; Tilemap_FillRectSequential

SECTION "engine/gfx/tilemap_fill", ROMX

Tilemap_FillRectSequential:: ; 48:4679
	; [CONFIRMED] 141 insn(s); 141 executed (in up to 14/18 scenarios) (part of region $462A-$4744)
	ld [wTilemapFill_StartTile], a
	ld a, $07
	ld [wTilemapFill_WramBank], a
	ld a, [wTilemapFill_StartTile]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld [wTilemapFill_StartTile], a
	ld a, [wTilemapFill_WramBank]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push de
	push hl
	ld a, [wTilemapFill_StartTile]
	ld d, b
.l469B ; 48:469B
	ld e, c
.l469C ; 48:469C
	ld [hli], a
	inc a
	dec e
	jr nz, .l469C
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
	jr nz, .l469B
	pop hl
	ld de, $0400
	add hl, de
	pop de
	xor a, a
	farcall Tilemap_ApplyMaskRect
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret
