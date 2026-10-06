; home/far_helpers.asm
; bank 00, $1711-$1770 (95 bytes); pinned by layout.link
; bank-4F wrapper and far-to-far copy

SECTION "home/far_helpers", ROM0

Boot_ReinitRuntimeFar:: ; 00:1711
Function_00_1711::
	; [CONFIRMED] wrapper: preserves A, switches ROM bank to $4F, call 4F:47A5, restores
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

CopyBytesFarToFar:: ; 00:172D
Function_00_172D::
	; [PROBABLE] far-to-far copy of BC bytes: source (bank A, HL), destination bank in [C10E], DE;
	; staged through a 16-byte buffer at C10E [candidate; raw refs 7]
	ldh [hFarBlockCopy_SourceBank], a
	ld a, [wRam_C10E]
	ldh [hFarBlockCopy_DestBank], a
	inc c
	dec c
	jr z, .l1739
	inc b
.l1739 ; 00:1739
	push bc
	push de
	ld de, $C10E ; raw: base of a 16-byte buffer
	ld c, $10
	ldh a, [hFarBlockCopy_SourceBank]
	call BankSwitch_H
.l1745 ; 00:1745
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .l1745
	pop de
	push hl
	ld hl, $C10E ; raw: base of a 16-byte buffer
	ldh a, [hFarBlockCopy_DestBank]
	call BankSwitch_D
	ld c, $10
.l1757 ; 00:1757
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .l1757
	pop hl
	pop bc
	ld a, c
	sub a, $10
	ld c, a
	jr z, .l176B
	jr nc, .l1739
	dec b
	jr nz, .l1739
	ret
.l176B ; 00:176B
	ld a, b
	or a, a
	jr nz, .l1739
	ret
