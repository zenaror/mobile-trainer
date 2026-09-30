; engine/sram/save_block_check.asm
; bank 4E, $4658-$488D (565 bytes); pinned by layout.link
; boot counters, Browser_BeginSession, SaveCheck_* (SRAM bank 1 block checksum), error counter

SECTION "engine/sram/save_block_check", ROMX

; ---- code $4658-$4685 (45 bytes) [CONFIRMED] 17 insn(s); 17 executed (in up to 18/18 scenarios); entry proven: target of an executed call/far call

Function_4E_4658:: ; 4E:4658
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [sSram_A9F2]
	ld [sSram_A9F6], a
	ld a, [sSram_A9F3]
	ld [sSram_A9F7], a
	ld a, [sSram_A9F0]
	ld [sSram_A9F4], a
	ld a, [sSram_A9F1]
	ld [sSram_A9F5], a
	ld a, [sSram_A9EF]
	and a, $7F
	jr nz, Label_4E_4687

; ---- code $4685-$4687 (2 bytes) [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 4E:4683 (executed) [executed in 1 scenarios]
	ld a, $01

; ---- code $4687-$46B8 (49 bytes) [CONFIRMED] 20 insn(s); 20 executed (in up to 18/18 scenarios)

Label_4E_4687:: ; 4E:4687
	ld [sSram_A9EF], a
	xor a, a
	ld [sSram_A9E3], a
	ld [sSram_A9F8], a
	ld [sSram_A9F9], a
	ld [sSram_A9FA], a
	ld [sSram_A9FB], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	jp SaveCheck_Update

Browser_BeginSession:: ; 4E:46A3
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [sSram_A9EF]
	and a, $7F
	jr nz, Label_4E_46BA

; ---- code $46B8-$46BA (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 4E:46B6 (executed)
	ld a, $01

; ---- code $46BA-$4730 (118 bytes) [CONFIRMED] 50 insn(s); 50 executed (in up to 12/18 scenarios)

Label_4E_46BA:: ; 4E:46BA
	ld [sSram_A9EF], a
	ld [wBrowserFrameStyle], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	farcall CommTime_Reset
	jp SaveCheck_Update

SaveCheck_Verify:: ; 4E:46CF
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld de, $0000
	ld hl, $A9E8
	ld bc, $0010
	call SaveCheck_Sum16
	ld a, [sSram_A9EA]
	cp a, e
	jr nz, Label_4E_4730
	ld a, [sSram_A9EB]
	cp a, d
	jr nz, Label_4E_4730
	ld de, $0000
	ld hl, $A000
	ld bc, $0684
	call SaveCheck_Sum16
	ld hl, $A9E4
	ld bc, $0004
	call SaveCheck_Sum16
	ld a, [sSram_A9E6]
	cp a, e
	jr nz, Label_4E_4730
	ld a, [sSram_A9E7]
	cp a, d
	jr nz, Label_4E_4730
	ld a, [sSram_A9EF]
	and a, $7F
	or a, a
	jr z, Label_4E_4730
	cp a, $1B
	jr nc, Label_4E_4730
	ld a, [sSram_A9EC]
	or a, a
	jr z, Label_4E_4730
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ret

; ---- code $4730-$4739 (9 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1; entered by jrcc from 4E:46ED (executed)

Label_4E_4730:: ; 4E:4730
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $FF
	ret

; ---- code $4739-$47EB (178 bytes) [CONFIRMED] 81 insn(s); 81 executed (in up to 18/18 scenarios); entry proven: target of an executed call/far call

SaveCheck_Sum16:: ; 4E:4739
Function_4E_4739::
	call Function_00_0392

Label_4E_473C:: ; 4E:473C
	ld a, [hli]
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_4E_473C
	ret

SaveCheck_ResetBlock:: ; 4E:4749
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, $A9E8
	ld bc, $0010
	xor a, a
	call FillBytes
	xor a, a
	ld [sSram_A9EA], a
	ld [sSram_A9EB], a
	cpl
	ld [sSram_A9E8], a
	ld [sSram_A9E9], a
	ld a, $01
	ld [sSram_A9EC], a
	ld [sSram_A9EF], a
	ld hl, $A000
	ld bc, $0684
	xor a, a
	call FillBytes
	xor a, a
	ld [sSram_A9E6], a
	ld [sSram_A9E7], a
	cpl
	ld [sSram_A9E4], a
	ld [sSram_A9E5], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a

SaveCheck_Update:: ; 4E:4795
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld de, $0000
	ld hl, $A9E8
	ld bc, $0010
	call SaveCheck_Sum16
	ld a, e
	ld [sSram_A9EA], a
	cpl
	ld [sSram_A9E8], a
	ld a, d
	ld [sSram_A9EB], a
	cpl
	ld [sSram_A9E9], a
	ld de, $0000
	ld hl, $A000
	ld bc, $0684
	call SaveCheck_Sum16
	ld hl, $A9E4
	ld bc, $0004
	call SaveCheck_Sum16
	ld a, e
	ld [sSram_A9E6], a
	cpl
	ld [sSram_A9E4], a
	ld a, d
	ld [sSram_A9E7], a
	cpl
	ld [sSram_A9E5], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

; ---- code $47EB-$4866 (123 bytes) [HYPOTHESIS] complete function: SRAM enable ($0A -> [$0000] via hFFF5), copies a record from SRAM $A9F0-$A9FB/$A9E3/$A9EC/C69F/C2C2 into [hl], SRAM disable, ret; 68 insn, the only direct target (jr) lands on an instruction start, ends exactly at the executed function 4E:4866 right after the CONFIRMED function 4E:4739; same SRAM-record style as 4E:417C; no caller/pointer found in the ROM (search for far calls, ld r16 and words), entry unproven

Function_4E_47EB:: ; 4E:47EB
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push bc
	push de
	call BankSwitch_H
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld d, h
	ld e, l
	ld a, [sSram_A9F2]
	ld [hli], a
	ld a, [sSram_A9F3]
	ld [hli], a
	ld a, [sSram_A9F0]
	ld [hli], a
	ld a, [sSram_A9F1]
	ld [hli], a
	ld a, [sSram_A9F6]
	ld c, a
	ld a, [sSram_A9F2]
	sub a, c
	ld [hli], a
	ld a, [sSram_A9F7]
	ld b, a
	ld a, [sSram_A9F3]
	sbc a, b
	ld [hli], a
	ld a, [sSram_A9F4]
	ld c, a
	ld a, [sSram_A9F0]
	sub a, c
	ld [hli], a
	ld a, [sSram_A9F5]
	ld b, a
	ld a, [sSram_A9F1]
	sbc a, b
	ld [hli], a
	ld a, [wBrowserFrameStyle]
	and a, $80
	ld [hli], a
	ld a, [sSram_A9E3]
	ld [hli], a
	ld a, [sSram_A9EC]
	ld [hli], a
	ld a, [wTimerEnable]
	and a, $10
	ld [hli], a
	ld a, [sSram_A9F8]
	ld [hli], a
	ld a, [sSram_A9F9]
	ld [hli], a
	ld a, [sSram_A9FA]
	ld [hli], a
	ld a, [sSram_A9FB]
	ld [hli], a
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

; ---- code $4866-$487F (25 bytes) [CONFIRMED] 11 insn(s); 11 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

Function_4E_4866:: ; 4E:4866
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [wMobileErrorCode]
	cp a, $12
	jr z, Label_4E_487F
	cp a, $26
	jr nz, Label_4E_4886

; ---- code $487F-$4886 (7 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; entered by jrcc from 4E:4879 (executed)

Label_4E_487F:: ; 4E:487F
	ld a, [sSram_A9E3]
	inc a
	ld [sSram_A9E3], a

; ---- code $4886-$488D (7 bytes) [CONFIRMED] 48 insn(s); 48 executed (in up to 3/18 scenarios) (part of region $4886-$4904)

Label_4E_4886:: ; 4E:4886
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret
