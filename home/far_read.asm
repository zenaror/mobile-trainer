; home/far_read.asm
; bank 00, $1620-$16A2 (130 bytes); pinned by layout.link
; ReadByteFar and far copy

SECTION "home/far_read", ROM0

ReadByteFar:: ; 00:1620
	; [CONFIRMED] A=bank, HL=address: returns [HL++] read from the right bank/region (ROM: FF8A;
	; SRAM: enables SRAM around the read; WRAM: FF8D); restores the previous bank [reached via
	; inferred links; raw refs 92] | 53 insn(s) executed; cut out of the PROBABLE region 1620-1686
	; by apply_coverage --split [executed in 29 scenarios]
	bit 7, h
	jr z, .l1669
	bit 6, h
	jr z, .l163E
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret
.l163E ; 00:163E
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [hli]
	ld [wRam_C12E], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ld a, [wRam_C12E]
	ret
.l1669 ; 00:1669
	or a, a
	jr z, .l1684
	ldh [hScratchA], a
	ldh a, [hROMBankLo]
	push af
	ldh a, [hScratchA]
	ldh [hROMBankLo], a
	ld [$2100], a
	ld a, [hli]
	ldh [hScratchA], a
	pop af
	ldh [hROMBankLo], a
	ld [$2100], a
	ldh a, [hScratchA]
	ret

.l1684 ; 00:1684
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1620-1686 by apply_coverage --split
	ld a, [hli]
	ret

ReadBytesFar:: ; 00:1686
Function_00_1686::
	; [PROBABLE] copy E bytes from far HL (bank D, region by H) to [BC++]; restores only the ROM
	; bank [candidate; raw refs 1]
	ldh [hScratchA], a
	ldh a, [hROMBankLo]
	push af
	ldh a, [hScratchA]
	ld a, d
	call BankSwitch_H
.loop ; 00:1691
	ld a, [hli]
	ld [bc], a
	inc bc
	dec e
	jr nz, .loop
	ldh [hScratchA], a
	pop af
	ldh [hROMBankLo], a
	ld [$2100], a
	ldh a, [hScratchA]
	ret
