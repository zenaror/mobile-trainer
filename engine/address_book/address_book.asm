; engine/address_book/address_book.asm
; bank 2F, $7EBF-$7FAC (237 bytes); pinned by layout.link
; Abook_Run entry and slot loader, slot address table

SECTION "engine/address_book/address_book", ROMX

; ---- code $7EBF-$7EFC (61 bytes) [CONFIRMED] 35 insn(s); 35 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Abook_Run:: ; 2F:7EBF
Function_2F_7EBF::
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D726
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hl], a

Label_2F_7ECC:: ; 2F:7ECC
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D726
	ld a, [hli]
	ld c, a
	inc hl
	ld a, [hld]
	ld b, a
	ld a, [hl]
	farcall AbookList_Run
	push af
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D727
	xor a, a
	ld [hl], a
	pop af
	call Abook_LoadSlotToBuffers
	ld d, $FF
	pop af
	cp a, $FF
	ret z
	cp a, $00
	jr z, Label_2F_7F08

; ---- code $7EFC-$7F04 (8 bytes) [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0; fall-through of the jrcc at 2F:7EFA (executed) | 4 insn(s) executed; cut out of the PROBABLE region 7EFC-7F08 by apply_coverage --split [executed in 4 scenarios]
	cp a, $01
	jr z, Label_2F_7F3B
	cp a, $02
	jr z, Label_2F_7F08

; ---- code $7F04-$7F08 (4 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7EFC-7F08 by apply_coverage --split
	cp a, $03
	jr z, Label_2F_7ECC

; ---- code $7F08-$7F0B (3 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)

Label_2F_7F08:: ; 2F:7F08
	xor a, a
	jr Label_2F_7F0D

; ---- code $7F0B-$7F0D (2 bytes) [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 2; entered by jrcc from 2F:7F24 (PROBABLE code) [executed in 2 scenarios]

Label_2F_7F0B:: ; 2F:7F0B
	ld a, $01

; ---- code $7F0D-$7F13 (6 bytes) [CONFIRMED] 1 insn(s); 1 executed (in up to 1/18 scenarios)

Label_2F_7F0D:: ; 2F:7F0D
	farcall AbookAddr_Edit

; ---- code $7F13-$7F3A (39 bytes) [CONFIRMED] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 0; entry not recorded [executed in 1 scenarios]
	cp a, $FF
	jr z, Label_2F_7F4E
	xor a, a
	jr Label_2F_7F1C

Label_2F_7F1A:: ; 2F:7F1A
	ld a, $01

Label_2F_7F1C:: ; 2F:7F1C
	farcall AbookName_Edit
	cp a, $FF
	jr z, Label_2F_7F0B
	ld d, $00
	ld b, d
	push bc
	farcall AddrBook_SaveConfirm
	pop bc
	inc b
	jr z, Label_2F_7F4E
	cp a, $00
	jr z, Label_2F_7ECC
	jr Label_2F_7F1A

; ---- data $7F3A-$7F3B (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_7F3A:: ; 2F:7F3A
	db $C9

; ---- code $7F3B-$7F47 (12 bytes) [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 1; entered by jrcc from 2F:7EFE (PROBABLE code) | 6 insn(s) executed; cut out of the PROBABLE region 7F3B-7F4D by apply_coverage --split [executed in 3 scenarios]

Label_2F_7F3B:: ; 2F:7F3B
	ld b, d
	push bc
	farcall AbookView_Run
	pop bc
	inc b
	jr z, Label_2F_7F4E

; ---- code $7F47-$7F4D (6 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7F3B-7F4D by apply_coverage --split
	cp a, $00
	jr z, Label_2F_7ECC
	jr Label_2F_7F1A

; ---- data $7F4D-$7F4E (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_7F4D:: ; 2F:7F4D
	db $C9

; ---- code $7F4E-$7F5D (15 bytes) [CONFIRMED] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 1; entered by jrcc from 2F:7F15 (PROBABLE code) | upgraded by classifier 6: all 7 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)

Label_2F_7F4E:: ; 2F:7F4E
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D727
	ld a, $01
	ld [hl], a
	jp Label_2F_7ECC

; ---- code $7F5D-$7FA0 (67 bytes) [CONFIRMED] 42 insn(s); 42 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

Abook_LoadSlotToBuffers:: ; 2F:7F5D
Function_2F_7F5D::
	push af
	push bc
	ld b, $00
	sla c
	ld hl, Abook_SlotAddrTable7
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld h, d
	ld l, e
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld b, $10
	ld de, $D514

Label_2F_7F87:: ; 2F:7F87
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2F_7F87
	pop hl
	ld de, $0010
	add hl, de
	ld b, $40
	ld de, $D4C0

Label_2F_7F97:: ; 2F:7F97
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2F_7F97
	pop bc
	pop af
	ret

; ---- words $7FA0-$7FAC (12 bytes) [PROBABLE] 6 SRAM record addresses $A69D..$A82D, constant stride $50 (80), verified arithmetic progression; indexed table read with entry 0 read by executed code (Data_2F_7FA0 CONFIRMED)

Abook_SlotAddrTable7:: ; 2F:7FA0
Table_2F_7FA0::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D
