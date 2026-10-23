; engine/sram/integrity_check.asm
; bank 22, $4EF0-$5110 (544 bytes); pinned by layout.link
; SramCheck_*: SRAM bank 0 mirrored-page checksum and bank 1 block checksum library

SECTION "engine/sram/integrity_check", ROMX

SramCheck_Bank0PageSum:: ; 22:4EF0

	; [CONFIRMED] 127 insn(s); 127 executed (in up to 17/18 scenarios); entry proven: target of an
	; executed call/far call
	and a, $01
	swap a
	add a, $A0
	ld h, a
	ld l, $00
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld de, $0000
	ld bc, $0FFE
.sum_page_bytes ; 22:4F0D
	ld a, [hli]
	add a, e
	ld e, a
	jr nc, .decrement_bytes_remaining
	inc d
.decrement_bytes_remaining ; 22:4F13
	dec bc
	ld a, b
	or a, c
	jr nz, .sum_page_bytes
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld h, a
	ld l, b
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

SramCheck_Bank0StorePageSum:: ; 22:4F24
	and a, $01
	swap a
	add a, $AF
	ld h, a
	ld l, $FE
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

SramCheck_CompareDEHL:: ; 22:4F46
	ld a, h
	cp a, d
	jr nz, .mismatch
	ld a, l
	cp a, e
	jr nz, .mismatch
	xor a, a
	ret
.mismatch ; 22:4F50
	ld a, $FF
	ret

SramCheck_Bank0ClearPage:: ; 22:4F53
	and a, $01
	swap a
	add a, $A0
	ld h, a
	ld l, $00
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld bc, $1000
.clear_page_bytes ; 22:4F6D
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .clear_page_bytes
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

SramCheck_Bank0CopyPage:: ; 22:4F7B
	and a, $01
	swap a
	add a, $A0
	ld h, a
	ld l, $00
	xor a, $10
	ld d, a
	ld e, $00
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld bc, $1000
.copy_page_bytes ; 22:4F9A
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or a, c
	jr nz, .copy_page_bytes
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

SramCheck_VerifyAndRepairAll:: ; 22:4FA9
	push af
	push bc
	push de
	push hl
	ld a, $00
	call SramCheck_Bank0PageSum
	call SramCheck_CompareDEHL
	inc a
	jr nz, SramCheck_MirrorPage0
	ld a, $01
	call SramCheck_Bank0PageSum
	call SramCheck_CompareDEHL
	inc a
	jr nz, SramCheck_RestorePage0
	ld a, $00
	call SramCheck_Bank0ClearPage
	ld a, $01
	call SramCheck_Bank0ClearPage
	jr SramCheck_VerifyAndRepairAll_Bank1Check

SramCheck_RestorePage0:: ; 22:4FCF
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 22:4FC1 (executed)
	ld a, $01
	call SramCheck_Bank0CopyPage
	jr SramCheck_VerifyAndRepairAll_Bank1Check

SramCheck_MirrorPage0:: ; 22:4FD6
	; [CONFIRMED] 29 insn(s); 29 executed (in up to 12/18 scenarios)
	ld a, $00
	call SramCheck_Bank0CopyPage

SramCheck_VerifyAndRepairAll_Bank1Check:: ; 22:4FDB
	pop hl
	pop de
	pop bc
	pop af
	push af
	push bc
	push de
	push hl
	call SramCheck_Bank1BlockSum
	call SramCheck_CompareDEHL2
	inc a
	jr nz, .pop_hl_de_bc_af_and_return
	call SramCheck_Bank1ClearBlock
	jr .pop_hl_de_bc_af_and_return
.pop_hl_de_bc_af_and_return ; 22:4FF1
	pop hl
	pop de
	pop bc
	pop af
	ret

SramCheck_Bank0Status:: ; 22:4FF6
	push bc
	push de
	push hl
	ld a, $00
	call SramCheck_Bank0PageSum
	call SramCheck_CompareDEHL
	inc a
	jr nz, .l5017

	; [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0;
	; fall-through of the jrcc at 22:5002 (executed) [executed in 1 scenarios]
	ld a, $01
	call SramCheck_Bank0PageSum
	call SramCheck_CompareDEHL
	inc a
	jr nz, .l5013
	ld a, $FF
	jr .pop_hl_de_bc_and_return
.l5013 ; 22:5013
	ld a, $00
	jr .pop_hl_de_bc_and_return

.l5017 ; 22:5017
	; [CONFIRMED] 59 insn(s); 59 executed (in up to 12/18 scenarios)
	ld a, $01
.pop_hl_de_bc_and_return ; 22:5019
	pop hl
	pop de
	pop bc
	ret

SramCheck_Bank0Commit:: ; 22:501D
	push af
	push bc
	push de
	push hl
	ld a, $00
	call SramCheck_Bank0PageSum
	ld a, $00
	call SramCheck_Bank0StorePageSum
	ld a, $00
	call SramCheck_Bank0CopyPage
	pop hl
	pop de
	pop bc
	pop af
	ret

SramCheck_Bank1BlockSum:: ; 22:5035
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, sPageList
	ld de, $0000
	ld bc, $0684
.sum_page_list ; 22:504C
	ld a, [hli]
	add a, e
	ld e, a
	jr nc, .l5052
	inc d
.l5052 ; 22:5052
	dec bc
	ld a, b
	or a, c
	jr nz, .sum_page_list
	ld hl, sAbookSlots
	ld bc, $01E0
.sum_address_book_slots ; 22:505D
	ld a, [hli]
	add a, e
	ld e, a
	jr nc, .l5063
	inc d
.l5063 ; 22:5063
	dec bc
	ld a, b
	or a, c
	jr nz, .sum_address_book_slots
	ld hl, sSramCheckBank1Sum
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld h, a
	ld l, b
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

SramCheck_Bank1StoreSum:: ; 22:5077
	; [CONFIRMED] 15 insn(s) reached by static flow only; seeds: exec x15; min discovery hops 7;
	; entered by call from 22:5103 (PROBABLE code) [executed in 4 scenarios]
	ld hl, sSramCheckBank1Sum
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

SramCheck_CompareDEHL2:: ; 22:5093

	; [CONFIRMED] 3 insn(s); 3 executed (in up to 6/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, h
	cp a, d
	jr nz, .mismatch

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 22:5095 (executed) [executed in 1 scenarios]
	ld a, l
	cp a, e
	jr nz, .mismatch
	xor a, a
	ret

.mismatch ; 22:509D
	; [CONFIRMED] 28 insn(s); 28 executed (in up to 6/18 scenarios)
	ld a, $FF
	ret

SramCheck_Bank1ClearBlock:: ; 22:50A0
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, sPageList
	ld bc, $0684
.clear_page_list ; 22:50B4
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .clear_page_list
	ld hl, sAbookSlots
	ld bc, $01E0
.clear_address_book_slots ; 22:50C1
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .clear_address_book_slots
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

SramCheck_VerifyBank1_ClearOnMismatch:: ; 22:50CF
	; [HYPOTHESIS] Complete unreferenced operation: sums and compares the Bank1 page-list/address
	; records, clears both on mismatch, then restores AF/BC/DE/HL. Exact extent [50CF,50E6); no
	; caller/pointer is known. Its behavior is static; entry and natural reachability remain unknown.
	push af
	push bc
	push de
	push hl
	call SramCheck_Bank1BlockSum
	call SramCheck_CompareDEHL2
	inc a
	jr nz, .pop_hl_de_bc_af_and_return
	call SramCheck_Bank1ClearBlock
	jr .pop_hl_de_bc_af_and_return
.pop_hl_de_bc_af_and_return ; 22:50E1
	pop hl
	pop de
	pop bc
	pop af
	ret

SramCheck_VerifyBank1_ReturnStatus:: ; 22:50E6
	; [HYPOTHESIS] Complete unreferenced operation: returns $01 when the Bank1 page-list/address
	; checksum matches, otherwise $FF. Exact extent [50E6,50FC); no caller/pointer is known. Its
	; behavior is static; entry and natural reachability remain unknown.
	push bc
	push de
	push hl
	call SramCheck_Bank1BlockSum
	call SramCheck_CompareDEHL2
	inc a
	jr nz, .return_match
	ld a, $FF
	jr .pop_hl_de_bc_and_return
.return_match ; 22:50F6
	ld a, $01
.pop_hl_de_bc_and_return ; 22:50F8
	pop hl
	pop de
	pop bc
	ret

SramCheck_Bank1Commit:: ; 22:50FC
	; [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 6;
	; entered by far from 24:4D56 (PROBABLE code) [executed in 4 scenarios]
	push af
	push bc
	push de
	push hl
	call SramCheck_Bank1BlockSum
	call SramCheck_Bank1StoreSum
	pop hl
	pop de
	pop bc
	pop af
	ret

; ---- zero $510B-$5110 (5 bytes) [PROBABLE] 5 bytes of $00 between the last code and the data at 5110 (padding)
	ds $5, $00
