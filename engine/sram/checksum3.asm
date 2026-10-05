; engine/sram/checksum3.asm
; bank 48, $4899-$498C (243 bytes); pinned by layout.link
; SRAM checksum 3 (verify/compute/reset/update) and the one-ret stub Stub_Nop_48_48BB (13 farcall sites at screen entries)

SECTION "engine/sram/checksum3", ROMX

Sram_VerifyChecksum3:: ; 48:4899
Function_48_4899::
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 12/18 scenarios); entry proven: target of an
	; executed call/far call
	call Sram_ComputeChecksum3
	ld a, $01
	ld hl, sChecksum3Sum
	call ReadByteFar
	ld b, a
	ld a, $01
	ld hl, sChecksum3Sum + $01
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

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the retcc at 48:48B7 (executed) [executed in 1 scenarios]
	ld a, $FF
	ret

Stub_Nop_48_48BB:: ; 48:48BB
Function_48_48BB::
	; [CONFIRMED] 1 insn(s); 1 executed (in up to 15/18 scenarios); entry proven: target of an
	; executed call/far call
	ret

Sram_VerifyChecksum3ResetOnMismatch:: ; 48:48BC
Function_48_48BC::
	; [HYPOTHESIS] unreferenced function (no call/ptr to 48BC in the ROM) right after the executed
	; one-instruction Function_48_48BB (ret); sibling of Function_48_4899: call $48E1; compare
	; 16-bit value at $A8B5/$A8B6 via call $1620; extra call $4920; ld a,$FF; ret. All call targets
	; (48E1, 1620, 4920) are known code starts
	call Sram_ComputeChecksum3
	ld a, $01
	ld hl, sChecksum3Sum
	call ReadByteFar
	ld b, a
	ld a, $01
	ld hl, sChecksum3Sum + $01
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

Sram_ComputeChecksum3:: ; 48:48E1
Function_48_48E1::
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 17/18 scenarios); entry proven: target of an
	; executed call/far call
	xor a, a
	ld [wSramChecksum3Carries], a
	ld hl, sChecksum3Block1
	ld d, $01
	ld c, $10
	ld e, $00
.l48EE ; 48:48EE
	ld a, d
	call ReadByteFar
	ld b, a
	add a, e
	ld e, a
	jr nc, .l48FE

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 48:48F5 (executed) [executed in 1 scenarios]
	ld a, [wSramChecksum3Carries]
	inc a
	ld [wSramChecksum3Carries], a

.l48FE ; 48:48FE
	; [CONFIRMED] 84 insn(s); 84 executed (in up to 17/18 scenarios) (part of region $48FE-$49A3)
	dec c
	jr nz, .l48EE
	ld hl, sChecksum3Block2
	ld d, $01
	ld c, $38
.l4908 ; 48:4908
	ld a, d
	call ReadByteFar
	ld b, a
	add a, e
	ld e, a
	jr nc, .l4918
	ld a, [wSramChecksum3Carries]
	inc a
	ld [wSramChecksum3Carries], a
.l4918 ; 48:4918
	dec c
	jr nz, .l4908
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
	ld hl, sChecksum3Block1
	xor a, a
	ld c, $10
.l493B ; 48:493B
	ld [hli], a
	dec c
	jr nz, .l493B
	ld hl, sChecksum3Block2
	ld c, $38
.l4944 ; 48:4944
	ld [hli], a
	dec c
	jr nz, .l4944
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
	ld hl, sChecksum3Sum
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
