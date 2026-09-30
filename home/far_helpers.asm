; home/far_helpers.asm
; bank 00, $1711-$1770 (95 bytes); pinned by layout.link
; bank-4F wrapper and far-to-far copy

SECTION "home/far_helpers", ROM0

; ---- code $1711-$172D (28 bytes) [CONFIRMED] wrapper: preserves A, switches ROM bank to $4F, call 4F:47A5, restores

Function_00_1711:: ; 00:1711
	ldh [hScratchA], a
	ldh a, [hROMBankLo]
	push af
	ldh a, [hScratchA]
	ld a, $4F
	ldh [hROMBankLo], a
	ld [$2100], a
	call Boot_ReinitRuntime
	ldh [hScratchA], a
	pop af
	ldh [hROMBankLo], a
	ld [$2100], a
	ldh a, [hScratchA]
	ret

; ---- code $172D-$1770 (67 bytes) [PROBABLE] far-to-far copy of BC bytes: source (bank A, HL), destination bank in [C10E], DE; staged through a 16-byte buffer at C10E [candidate; raw refs 7]

Function_00_172D:: ; 00:172D
	ldh [hRam_FFB1], a
	ld a, [wRam_C10E]
	ldh [hRam_FFB0], a
	inc c
	dec c
	jr z, Label_00_1739
	inc b

Label_00_1739:: ; 00:1739
	push bc
	push de
	ld de, $C10E
	ld c, $10
	ldh a, [hRam_FFB1]
	call BankSwitch_H

Label_00_1745:: ; 00:1745
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Label_00_1745
	pop de
	push hl
	ld hl, $C10E
	ldh a, [hRam_FFB0]
	call BankSwitch_D
	ld c, $10

Label_00_1757:: ; 00:1757
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Label_00_1757
	pop hl
	pop bc
	ld a, c
	sub a, $10
	ld c, a
	jr z, Label_00_176B
	jr nc, Label_00_1739
	dec b
	jr nz, Label_00_1739
	ret

Label_00_176B:: ; 00:176B
	ld a, b
	or a, a
	jr nz, Label_00_1739
	ret
