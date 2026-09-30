; engine/sram/write_byte_far.asm
; bank 48, $4616-$4679 (99 bytes); pinned by layout.link
; WriteByteFar (SRAM write that refreshes checksum 3)

SECTION "engine/sram/write_byte_far", ROMX

; ---- code $4616-$4629 (19 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 14/18 scenarios); entry proven: target of an executed call/far call

WriteByteFar:: ; 48:4616
Function_48_4616::
	ld [wRam_C12E], a
	ld a, h
	cp a, $A0
	ret c
	cp a, $C0
	jr c, Label_48_462A
	cp a, $D0
	jr c, Label_48_465C
	cp a, $E0
	jr c, Label_48_465F

; ---- code $4629-$462A (1 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 48:4627 (executed)
	ret

; ---- code $462A-$4679 (79 bytes) [CONFIRMED] 141 insn(s); 141 executed (in up to 14/18 scenarios) (part of region $462A-$4744)

Label_48_462A:: ; 48:462A
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, [wRam_C12E]
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld [hl], b
	inc hl
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	push bc
	push de
	push hl
	call Sram_UpdateChecksum3
	pop hl
	pop de
	pop bc
	ret

Label_48_465C:: ; 48:465C
	ld a, b
	ld [hli], a
	ret

Label_48_465F:: ; 48:465F
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, [wRam_C12E]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld [hl], b
	inc hl
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret
