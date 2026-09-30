; engine/sprites/slot_backup.asm
; bank 7F, $624F-$62B0 (97 bytes); pinned by layout.link
; sprite slot save/restore to WRAM bank 3

SECTION "engine/sprites/slot_backup", ROMX

; ---- code $624F-$62A9 (90 bytes) [CONFIRMED] 60 insn(s); 60 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Sprites_SaveSlotsToBank3:: ; 7F:624F
Function_7F_624F::
	push af
	push bc
	push de
	push hl
	ldh a, [rSVBK]
	push af
	ld hl, $DA00
	ld de, $D900
	ld b, $00

Label_7F_625E:: ; 7F:625E
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	push af
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	dec b
	jr nz, Label_7F_625E
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop hl
	pop de
	pop bc
	pop af
	ret

Sprites_RestoreSlotsFromBank3:: ; 7F:627C
	push af
	push bc
	push de
	push hl
	ldh a, [rSVBK]
	push af
	ld de, $DA00
	ld hl, $D900
	ld b, $00

Label_7F_628B:: ; 7F:628B
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	dec b
	jr nz, Label_7F_628B
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop hl
	pop de
	pop bc
	pop af
	ret

; ---- zero $62A9-$62B0 (7 bytes) [PROBABLE] 7 x 00 between the ret of the executed function 7F:624F-62A9 and the tile block 7F:62B0
	ds $7, $00
