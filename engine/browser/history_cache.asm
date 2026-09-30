; engine/browser/history_cache.asm
; bank 4C, $4B54-$4DB2 (606 bytes); pinned by layout.link
; back-stack, page cache, long SRAM block copy

SECTION "engine/browser/history_cache", ROMX

Browser_HistoryReset:: ; 4C:4B54
Function_4C_4B54::
	; [CONFIRMED] 36 insn(s); 36 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, $AA00
	ld bc, $0600
	xor a, a
	ld [sSram_A9FF], a
	ld [sSram_A9FE], a
	call FillBytes
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	call Function_00_0392
	ret

Browser_HistoryPush:: ; 4C:4B7C
	ld hl, $D500
	ld a, $06

Function_4C_4B81:: ; 4C:4B81
	call BankSwitch_H
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [sSram_A9FE]
	add a, $AA
	ld d, a
	ld e, $00
	ld bc, $0100
	call CopyBytes
	ld a, [sSram_A9FE]
	inc a
	cp a, $06
	jr c, .l4BA9

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 4C:4BA6 (executed)
	xor a, a

.l4BA9 ; 4C:4BA9
	; [CONFIRMED] 30 insn(s); 30 executed (in up to 1/18 scenarios)
	ld [sSram_A9FE], a
	ld a, [sSram_A9FF]
	cp a, $06
	jr nc, .l4BB7
	inc a
	ld [sSram_A9FF], a
.l4BB7 ; 4C:4BB7
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	call Function_00_0392
	ret

Browser_HistoryPop:: ; 4C:4BC1
	push de
	call BankSwitch_D
	xor a, a
	ld [de], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [sSram_A9FF]
	or a, a
	jr z, .l4BF7
	dec a
	ld [sSram_A9FF], a
	ld a, [sSram_A9FE]
	dec a
	cp a, $06
	jr c, .skip

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 4C:4BE5 (executed)
	ld a, $05

.skip ; 4C:4BE9
	; [CONFIRMED] 55 insn(s); 55 executed (in up to 1/18 scenarios)
	ld [sSram_A9FE], a
	add a, $AA
	ld h, a
	ld l, $00
	ld bc, $0100
	call CopyBytes
.l4BF7 ; 4C:4BF7
	pop de
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	call Function_00_0392
	ld a, [de]
	ret

Sram_CopyLongBlock:: ; 4C:4C03
	call Function_00_0392
	push bc
	ld a, b
	cp a, $02
	jr c, .skip
	ld bc, $0200
.skip ; 4C:4C0F
	ldh a, [hRam_FFB0]
	call BankSwitch_H
	push bc
	push de
	ld de, $C380
	call CopyBytes
	pop de
	pop bc
	ldh a, [hRam_FFB1]
	call BankSwitch_D
	push hl
	ld hl, $C380
	call CopyBytes
	pop hl
	ld a, h
	sub a, $C0
	jr c, .l4C38
	add a, $A0
	ld h, a
	ldh a, [hRam_FFB0]
	inc a
	ldh [hRam_FFB0], a
.l4C38 ; 4C:4C38
	ld a, d
	sub a, $C0
	jr c, .l4C45
	add a, $A0
	ld d, a
	ldh a, [hRam_FFB1]
	inc a
	ldh [hRam_FFB1], a
.l4C45 ; 4C:4C45
	pop bc
	ld a, b
	sub a, $02
	ld b, a
	ret z
	jr nc, Sram_CopyLongBlock

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 4C:4C4B (executed)
	ret

Browser_ClearCaches:: ; 4C:4C4E
Function_4C_4C4E::
	; [CONFIRMED] 63 insn(s); 63 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	call Function_00_0392
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	xor a, a
	ld [sSram_A9FD], a
	ld [sSram_A9FC], a
	ld a, $02
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, $A000
	ld bc, $2000
	xor a, a
	call FillBytes
	call Function_00_0392
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, $A000
	ld bc, $2000
	xor a, a
	call FillBytes
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	call Function_00_0392
	ret

PageCache_Push:: ; 4C:4C95
	ld bc, $1000
	ld hl, $B000
	ld a, $03
	ldh [hRam_FFB0], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [sSram_A9FC]
	ld e, a
	ld d, $00
	push hl
	ld hl, Table_PageCache_Slots
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ldh [hRam_FFB1], a
	pop hl
	call Sram_CopyLongBlock
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [sSram_A9FC]
	inc a
	cp a, $03
	jr c, .l4CD5

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 4C:4CD2 (executed)
	xor a, a

.l4CD5 ; 4C:4CD5
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios)
	ld [sSram_A9FC], a
	ld a, [sSram_A9FD]
	cp a, $03
	jr nc, .l4CE3
	inc a
	ld [sSram_A9FD], a
.l4CE3 ; 4C:4CE3
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

; ---- data $4CEA-$4CF6 (12 bytes) [PROBABLE] 4 triples (addr lo, addr hi, SRAM bank number) = $A000/2, $B000/2, $A000/3, $B000/3 (SRAM window addresses with bank numbers 2 and 3); the first triple is read by executed code at 4CEA, the extent 12 bytes is inferred from the exact 3-byte spacing and the identical bank/address pattern

Table_PageCache_Slots:: ; 4C:4CEA
Table_4C_4CEA::
	db $00, $A0, $02, $00, $B0, $02, $00, $A0, $03, $00, $B0, $03

PageCache_Pop:: ; 4C:4CF6
Function_4C_4CF6::
	; [CONFIRMED] 18 insn(s); 18 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ldh [hRam_FFB1], a
	call Function_00_0392
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push bc
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [sSram_A9FD]
	or a, a
	jr z, .l4D66
	dec a
	ld [sSram_A9FD], a
	ld a, [sSram_A9FC]
	dec a
	cp a, $03
	jr c, .skip

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 4C:4D1A (executed)
	ld a, $02

.skip ; 4C:4D1E
	; [CONFIRMED] 40 insn(s); 40 executed (in up to 1/18 scenarios)
	ld [sSram_A9FC], a
	ldh [hRam_FFB0], a
	ldh a, [hRam_FFB1]
	ld h, d
	ld l, e
	call BankSwitch_H
	xor a, a
	call FillBytes
	call Function_00_0392
	push de
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $C380
	ld de, $D500
	ld bc, $0100
	call CopyBytes
	pop de
	ldh a, [hRam_FFB0]
	ld c, a
	ld b, $00
	ld hl, Table_PageCache_Slots
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	ld h, b
	ld l, c
	pop bc
	call Sram_CopyLongBlock
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $FF
	ret

.l4D66 ; 4C:4D66
	; [PROBABLE] 38 insn(s) reached by static flow only; seeds: exec x38; min discovery hops 1;
	; entered by jrcc from 4C:4D0E (executed)
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ret

Function_4C_4D6F:: ; 4C:4D6F
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [sSram_A9FD]
	or a, a
	jr z, .l4D94
	dec a
	ld [sSram_A9FD], a
	ld a, [sSram_A9FC]
	dec a
	cp a, $03
	jr c, .l4D91
	ld a, $02
.l4D91 ; 4C:4D91
	ld [sSram_A9FC], a
.l4D94 ; 4C:4D94
	ld a, [sSram_A9FF]
	or a, a
	jr z, .l4DAB
	dec a
	ld [sSram_A9FF], a
	ld a, [sSram_A9FE]
	dec a
	cp a, $06
	jr c, .l4DA8
	ld a, $05
.l4DA8 ; 4C:4DA8
	ld [sSram_A9FE], a
.l4DAB ; 4C:4DAB
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret
