; engine/sram/integrity_check.asm
; bank 22, $4EF0-$5110 (544 bytes); pinned by layout.link
; SramCheck_*: SRAM bank 0 mirrored-page checksum and bank 1 block checksum library

SECTION "engine/sram/integrity_check", ROMX

; ---- code $4EF0-$4FCF (223 bytes) [CONFIRMED] 127 insn(s); 127 executed (in up to 17/18 scenarios); entry proven: target of an executed call/far call

SramCheck_Bank0PageSum:: ; 22:4EF0
Function_22_4EF0::
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

Label_22_4F0D:: ; 22:4F0D
	ld a, [hli]
	add a, e
	ld e, a
	jr nc, Label_22_4F13
	inc d

Label_22_4F13:: ; 22:4F13
	dec bc
	ld a, b
	or a, c
	jr nz, Label_22_4F0D
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
	jr nz, Label_22_4F50
	ld a, l
	cp a, e
	jr nz, Label_22_4F50
	xor a, a
	ret

Label_22_4F50:: ; 22:4F50
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

Label_22_4F6D:: ; 22:4F6D
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_22_4F6D
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

Label_22_4F9A:: ; 22:4F9A
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or a, c
	jr nz, Label_22_4F9A
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
	jr Label_22_4FDB

; ---- code $4FCF-$4FD6 (7 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1; entered by jrcc from 22:4FC1 (executed)

SramCheck_RestorePage0:: ; 22:4FCF
	ld a, $01
	call SramCheck_Bank0CopyPage
	jr Label_22_4FDB

; ---- code $4FD6-$5004 (46 bytes) [CONFIRMED] 29 insn(s); 29 executed (in up to 12/18 scenarios)

SramCheck_MirrorPage0:: ; 22:4FD6
	ld a, $00
	call SramCheck_Bank0CopyPage

Label_22_4FDB:: ; 22:4FDB
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
	jr nz, Label_22_4FF1
	call SramCheck_Bank1ClearBlock
	jr Label_22_4FF1

Label_22_4FF1:: ; 22:4FF1
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
	jr nz, Label_22_5017

; ---- code $5004-$5017 (19 bytes) [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0; fall-through of the jrcc at 22:5002 (executed) [executed in 1 scenarios]
	ld a, $01
	call SramCheck_Bank0PageSum
	call SramCheck_CompareDEHL
	inc a
	jr nz, Label_22_5013
	ld a, $FF
	jr Label_22_5019

Label_22_5013:: ; 22:5013
	ld a, $00
	jr Label_22_5019

; ---- code $5017-$5077 (96 bytes) [CONFIRMED] 59 insn(s); 59 executed (in up to 12/18 scenarios)

Label_22_5017:: ; 22:5017
	ld a, $01

Label_22_5019:: ; 22:5019
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
	ld hl, $A000
	ld de, $0000
	ld bc, $0684

Label_22_504C:: ; 22:504C
	ld a, [hli]
	add a, e
	ld e, a
	jr nc, Label_22_5052
	inc d

Label_22_5052:: ; 22:5052
	dec bc
	ld a, b
	or a, c
	jr nz, Label_22_504C
	ld hl, $A69D
	ld bc, $01E0

Label_22_505D:: ; 22:505D
	ld a, [hli]
	add a, e
	ld e, a
	jr nc, Label_22_5063
	inc d

Label_22_5063:: ; 22:5063
	dec bc
	ld a, b
	or a, c
	jr nz, Label_22_505D
	ld hl, $A8D7
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld h, a
	ld l, b
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

; ---- code $5077-$5093 (28 bytes) [CONFIRMED] 15 insn(s) reached by static flow only; seeds: exec x15; min discovery hops 7; entered by call from 22:5103 (PROBABLE code) [executed in 4 scenarios]

SramCheck_Bank1StoreSum:: ; 22:5077
	ld hl, $A8D7
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

; ---- code $5093-$5097 (4 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 6/18 scenarios); entry proven: target of an executed call/far call

SramCheck_CompareDEHL2:: ; 22:5093
Function_22_5093::
	ld a, h
	cp a, d
	jr nz, Label_22_509D

; ---- code $5097-$509D (6 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 22:5095 (executed) [executed in 1 scenarios]
	ld a, l
	cp a, e
	jr nz, Label_22_509D
	xor a, a
	ret

; ---- code $509D-$50CF (50 bytes) [CONFIRMED] 28 insn(s); 28 executed (in up to 6/18 scenarios)

Label_22_509D:: ; 22:509D
	ld a, $FF
	ret

SramCheck_Bank1ClearBlock:: ; 22:50A0
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, $A000
	ld bc, $0684

Label_22_50B4:: ; 22:50B4
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_22_50B4
	ld hl, $A69D
	ld bc, $01E0

Label_22_50C1:: ; 22:50C1
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_22_50C1
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

; ---- code $50CF-$50FC (45 bytes) [HYPOTHESIS] two unreferenced functions 50CF (push af..hl; call $5035; call $5093; inc a; jr nz; call $50A0; ... ret) and 50E6 (same skeleton returning a=$FF/$01), each ending in ret, directly before the far-entered 50FC (entered from 24:4D59) and after the CONFIRMED 509D; all 5 direct call targets are known code starts (5035,5093,50A0). No caller/pointer found in the ROM
	push af
	push bc
	push de
	push hl
	call SramCheck_Bank1BlockSum
	call SramCheck_CompareDEHL2
	inc a
	jr nz, Label_22_50E1
	call SramCheck_Bank1ClearBlock
	jr Label_22_50E1

Label_22_50E1:: ; 22:50E1
	pop hl
	pop de
	pop bc
	pop af
	ret

	push bc
	push de
	push hl
	call SramCheck_Bank1BlockSum
	call SramCheck_CompareDEHL2
	inc a
	jr nz, Label_22_50F6
	ld a, $FF
	jr Label_22_50F8

Label_22_50F6:: ; 22:50F6
	ld a, $01

Label_22_50F8:: ; 22:50F8
	pop hl
	pop de
	pop bc
	ret

; ---- code $50FC-$510B (15 bytes) [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 6; entered by far from 24:4D56 (PROBABLE code) [executed in 4 scenarios]

SramCheck_Bank1Commit:: ; 22:50FC
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
