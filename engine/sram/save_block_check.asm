; engine/sram/save_block_check.asm
; bank 4E, $4658-$488D (565 bytes); pinned by layout.link
; boot counters, Browser_BeginSession, SaveCheck_* (SRAM bank 1 block checksum), error counter

SECTION "engine/sram/save_block_check", ROMX

Sram_SnapshotA9F0PairsAtBoot:: ; 4E:4658
Function_4E_4658::
	; [CONFIRMED] 17 insn(s); 17 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [sSaveCheckStateBlock + $0A]
	ld [sSaveCheckStateBlock + $0E], a
	ld a, [sSaveCheckStateBlock + $0B]
	ld [sSaveCheckStateBlock + $0F], a
	ld a, [sSaveCheckStateBlock + $08]
	ld [sSaveCheckStateBlock + $0C], a
	ld a, [sSaveCheckStateBlock + $09]
	ld [sSaveCheckStateBlock + $0D], a
	ld a, [sBrowserFrameStyle]
	and a, $7F
	jr nz, .skip

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 4E:4683 (executed) [executed in 1 scenarios]
	ld a, $01

.skip ; 4E:4687
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 18/18 scenarios)
	ld [sBrowserFrameStyle], a
	xor a, a
	ld [sMobileError12Or26Count], a
	ld [sCommTimeTotal], a
	ld [sCommTimeTotal + $01], a
	ld [sCommTimeTotal + $02], a
	ld [sCommTimeTotal + $03], a
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
	ld a, [sBrowserFrameStyle]
	and a, $7F
	jr nz, .skip

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 4E:46B6 (executed)
	ld a, $01

.skip ; 4E:46BA
	; [CONFIRMED] 50 insn(s); 50 executed (in up to 12/18 scenarios)
	ld [sBrowserFrameStyle], a
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
	ld hl, sSaveCheckStateBlock
	ld bc, $0010
	call SaveCheck_Sum16
	ld a, [sSaveCheckStateBlock + $02]
	cp a, e
	jr nz, .l4730
	ld a, [sSaveCheckStateBlock + $03]
	cp a, d
	jr nz, .l4730
	ld de, $0000
	ld hl, sPageList
	ld bc, $0684
	call SaveCheck_Sum16
	ld hl, sSaveCheckBlockTag
	ld bc, $0004
	call SaveCheck_Sum16
	ld a, [sSaveCheckBlockTag + $02]
	cp a, e
	jr nz, .l4730
	ld a, [sSaveCheckBlockTag + $03]
	cp a, d
	jr nz, .l4730
	ld a, [sBrowserFrameStyle]
	and a, $7F
	or a, a
	jr z, .l4730
	cp a, $1B
	jr nc, .l4730
	ld a, [sSaveCheckValidFlag]
	or a, a
	jr z, .l4730
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ret

.l4730 ; 4E:4730
	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1;
	; entered by jrcc from 4E:46ED (executed)
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $FF
	ret

SaveCheck_Sum16:: ; 4E:4739
Function_4E_4739::
	; [CONFIRMED] 81 insn(s); 81 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
	call Sound_FrameService
.loop ; 4E:473C
	ld a, [hli]
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	dec bc
	ld a, b
	or a, c
	jr nz, .loop
	ret

SaveCheck_ResetBlock:: ; 4E:4749
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, sSaveCheckStateBlock
	ld bc, $0010
	xor a, a
	call FillBytes
	xor a, a
	ld [sSaveCheckStateBlock + $02], a
	ld [sSaveCheckStateBlock + $03], a
	cpl
	ld [sSaveCheckStateBlock], a
	ld [sSaveCheckStateBlock + $01], a
	ld a, $01
	ld [sSaveCheckValidFlag], a
	ld [sBrowserFrameStyle], a
	ld hl, sPageList
	ld bc, $0684
	xor a, a
	call FillBytes
	xor a, a
	ld [sSaveCheckBlockTag + $02], a
	ld [sSaveCheckBlockTag + $03], a
	cpl
	ld [sSaveCheckBlockTag], a
	ld [sSaveCheckBlockTag + $01], a
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
	ld hl, sSaveCheckStateBlock
	ld bc, $0010
	call SaveCheck_Sum16
	ld a, e
	ld [sSaveCheckStateBlock + $02], a
	cpl
	ld [sSaveCheckStateBlock], a
	ld a, d
	ld [sSaveCheckStateBlock + $03], a
	cpl
	ld [sSaveCheckStateBlock + $01], a
	ld de, $0000
	ld hl, sPageList
	ld bc, $0684
	call SaveCheck_Sum16
	ld hl, sSaveCheckBlockTag
	ld bc, $0004
	call SaveCheck_Sum16
	ld a, e
	ld [sSaveCheckBlockTag + $02], a
	cpl
	ld [sSaveCheckBlockTag], a
	ld a, d
	ld [sSaveCheckBlockTag + $03], a
	cpl
	ld [sSaveCheckBlockTag + $01], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

Sram_BuildA9F0DeltaBlock:: ; 4E:47EB
Function_4E_47EB::
	; [HYPOTHESIS] complete function: SRAM enable ($0A -> [$0000] via hFFF5), copies a record from
	; SRAM $A9F0-$A9FB/$A9E3/$A9EC/C69F/C2C2 into [hl], SRAM disable, ret; 68 insn, the only direct
	; target (jr) lands on an instruction start, ends exactly at the executed function 4E:4866 right
	; after the CONFIRMED function 4E:4739; same SRAM-record style as 4E:417C; no caller/pointer
	; found in the ROM (search for far calls, ld r16 and words), entry unproven
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
	ld a, [sSaveCheckStateBlock + $0A]
	ld [hli], a
	ld a, [sSaveCheckStateBlock + $0B]
	ld [hli], a
	ld a, [sSaveCheckStateBlock + $08]
	ld [hli], a
	ld a, [sSaveCheckStateBlock + $09]
	ld [hli], a
	ld a, [sSaveCheckStateBlock + $0E]
	ld c, a
	ld a, [sSaveCheckStateBlock + $0A]
	sub a, c
	ld [hli], a
	ld a, [sSaveCheckStateBlock + $0F]
	ld b, a
	ld a, [sSaveCheckStateBlock + $0B]
	sbc a, b
	ld [hli], a
	ld a, [sSaveCheckStateBlock + $0C]
	ld c, a
	ld a, [sSaveCheckStateBlock + $08]
	sub a, c
	ld [hli], a
	ld a, [sSaveCheckStateBlock + $0D]
	ld b, a
	ld a, [sSaveCheckStateBlock + $09]
	sbc a, b
	ld [hli], a
	ld a, [wBrowserFrameStyle]
	and a, $80
	ld [hli], a
	ld a, [sMobileError12Or26Count]
	ld [hli], a
	ld a, [sSaveCheckValidFlag]
	ld [hli], a
	ld a, [wTimerEnable]
	and a, $10
	ld [hli], a
	ld a, [sCommTimeTotal]
	ld [hli], a
	ld a, [sCommTimeTotal + $01]
	ld [hli], a
	ld a, [sCommTimeTotal + $02]
	ld [hli], a
	ld a, [sCommTimeTotal + $03]
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

Sram_CountMobileError12Or26:: ; 4E:4866
Function_4E_4866::
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [wMobileErrorCode]
	cp a, $12
	jr z, .l487F
	cp a, $26
	jr nz, .l4886

.l487F ; 4E:487F
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; entered by jrcc from 4E:4879 (executed)
	ld a, [sMobileError12Or26Count]
	inc a
	ld [sMobileError12Or26Count], a

.l4886 ; 4E:4886
	; [CONFIRMED] 48 insn(s); 48 executed (in up to 3/18 scenarios) (part of region $4886-$4904)
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret
