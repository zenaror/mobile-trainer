; engine/sram/checksum3.asm
; bank 48, $4899-$498C (243 bytes); pinned by layout.link
; SRAM checksum 3 (verify/compute/reset/update) and the patched-out 48BB hook

SECTION "engine/sram/checksum3", ROMX

; ---- code $4899-$48B8 (31 bytes) [CONFIRMED] 19 insn(s); 19 executed (in up to 12/18 scenarios); entry proven: target of an executed call/far call

Sram_VerifyChecksum3:: ; 48:4899
Function_48_4899::
	call Sram_ComputeChecksum3
	ld a, $01
	ld hl, $A8B5
	call ReadByteFar
	ld b, a
	ld a, $01
	ld hl, $A8B6
	call ReadByteFar
	ld h, a
	ld l, b
	ld a, l
	sub a, e
	ld l, a
	ld a, h
	sbc a, d
	ld h, a
	ld a, h
	or a, l
	ret z

; ---- code $48B8-$48BB (3 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the retcc at 48:48B7 (executed) [executed in 1 scenarios]
	ld a, $FF
	ret

; ---- code $48BB-$48BC (1 bytes) [CONFIRMED] 1 insn(s); 1 executed (in up to 15/18 scenarios); entry proven: target of an executed call/far call

Function_48_48BB:: ; 48:48BB
	ret

; ---- code $48BC-$48E1 (37 bytes) [HYPOTHESIS] unreferenced function (no call/ptr to 48BC in the ROM) right after the executed one-instruction Function_48_48BB (ret); sibling of Function_48_4899: call $48E1; compare 16-bit value at $A8B5/$A8B6 via call $1620; extra call $4920; ld a,$FF; ret. All call targets (48E1, 1620, 4920) are known code starts

Function_48_48BC:: ; 48:48BC
	call Sram_ComputeChecksum3
	ld a, $01
	ld hl, $A8B5
	call ReadByteFar
	ld b, a
	ld a, $01
	ld hl, $A8B6
	call ReadByteFar
	ld h, a
	ld l, b
	ld a, l
	sub a, e
	ld l, a
	ld a, h
	sbc a, d
	ld h, a
	ld a, h
	or a, l
	ret z
	call Sram_ResetChecksum3Areas
	ld a, $FF
	ret

; ---- code $48E1-$48F7 (22 bytes) [CONFIRMED] 12 insn(s); 12 executed (in up to 17/18 scenarios); entry proven: target of an executed call/far call

Sram_ComputeChecksum3:: ; 48:48E1
Function_48_48E1::
	xor a, a
	ld [wSramChecksum3Carries], a
	ld hl, $A684
	ld d, $01
	ld c, $10
	ld e, $00

Label_48_48EE:: ; 48:48EE
	ld a, d
	call ReadByteFar
	ld b, a
	add a, e
	ld e, a
	jr nc, Label_48_48FE

; ---- code $48F7-$48FE (7 bytes) [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 48:48F5 (executed) [executed in 1 scenarios]
	ld a, [wSramChecksum3Carries]
	inc a
	ld [wSramChecksum3Carries], a

; ---- code $48FE-$498C (142 bytes) [CONFIRMED] 84 insn(s); 84 executed (in up to 17/18 scenarios) (part of region $48FE-$49A3)

Label_48_48FE:: ; 48:48FE
	dec c
	jr nz, Label_48_48EE
	ld hl, $A87D
	ld d, $01
	ld c, $38

Label_48_4908:: ; 48:4908
	ld a, d
	call ReadByteFar
	ld b, a
	add a, e
	ld e, a
	jr nc, Label_48_4918
	ld a, [wSramChecksum3Carries]
	inc a
	ld [wSramChecksum3Carries], a

Label_48_4918:: ; 48:4918
	dec c
	jr nz, Label_48_4908
	ld a, [wSramChecksum3Carries]
	ld d, a
	ret

Sram_ResetChecksum3Areas:: ; 48:4920
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, $A684
	xor a, a
	ld c, $10

Label_48_493B:: ; 48:493B
	ld [hli], a
	dec c
	jr nz, Label_48_493B
	ld hl, $A87D
	ld c, $38

Label_48_4944:: ; 48:4944
	ld [hli], a
	dec c
	jr nz, Label_48_4944
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	call Sram_UpdateChecksum3
	ret

Sram_UpdateChecksum3:: ; 48:495C
	call Sram_ComputeChecksum3
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, $A8B5
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ret
