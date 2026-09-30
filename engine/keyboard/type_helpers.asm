; engine/keyboard/type_helpers.asm
; bank 55, $6E94-$7082 (494 bytes); pinned by layout.link
; keyboard type predicates, marker sprite, input mode load/save

SECTION "engine/keyboard/type_helpers", ROMX

; ---- code $6E94-$6E9F (11 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 11/18 scenarios); entry proven: target of an executed call/far call

Kbd_TypeHasPages:: ; 55:6E94
Function_55_6E94::
	ld hl, Data_55_6E9F
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ret

; ---- data $6E9F-$6EAA (11 bytes) [PROBABLE] zero/short bytes of the keyboard page tables between text rows; part of the run 6E9F-6EAA that executed code reads piecewise [split by classify_g2]

Data_55_6E9F:: ; 55:6E9F
	db $00, $00, $00, $00, $00, $00, $01, $01, $01, $00, $00

; ---- code $6EAA-$6EB5 (11 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 7/18 scenarios); entry proven: target of an executed call/far call

Function_55_6EAA:: ; 55:6EAA
	ld hl, Data_55_6EB5
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ret

; ---- data $6EB5-$6EC0 (11 bytes) [PROBABLE] zero/short bytes of the keyboard page tables between text rows; part of the run 6EB5-6EC0 that executed code reads piecewise [split by classify_g2]

Data_55_6EB5:: ; 55:6EB5
	db $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01

; ---- code $6EC0-$6ECB (11 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 11/18 scenarios); entry proven: target of an executed call/far call

Function_55_6EC0:: ; 55:6EC0
	ld hl, Data_55_6ECB
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ret

; ---- data $6ECB-$6ED6 (11 bytes) [PROBABLE] zero/short bytes of the keyboard page tables between text rows; part of the run 6ECB-6ED6 that executed code reads piecewise [split by classify_g2]

Data_55_6ECB:: ; 55:6ECB
	db $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00

; ---- code $6ED6-$6EE1 (11 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 11/18 scenarios); entry proven: target of an executed call/far call

Function_55_6ED6:: ; 55:6ED6
	ld hl, Data_55_6EE1
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ret

; ---- data $6EE1-$6EEC (11 bytes) [PROBABLE] zero/short bytes of the keyboard page tables between text rows; part of the run 6EE1-6EEC that executed code reads piecewise [split by classify_g2]

Data_55_6EE1:: ; 55:6EE1
	db $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01

; ---- code $6EEC-$6EF7 (11 bytes) [PROBABLE] lookup routine ld hl,$6EF7 ; add a,l ; ld l,a ; ld a,0 ; adc a,h ; ld h,a ; ld a,[hl] ; ret: byte-exact sibling of the executed routines at 6E94/6EAA/6EC0/6ED6/6F02/6F18 (each followed by its 11-byte table); called by call $6EEC at 55:5DF8 [verifier: entry evidence = fixed-stride periodicity: the executed siblings 6ED6 and 6F02 sit exactly $16 bytes (8-insn routine + 11-byte table) either side of 6EEC, all with identical code bytes except the base operand; the caller 55:5DF8 is itself HYPOTHESIS]

Function_55_6EEC:: ; 55:6EEC
	ld hl, Data_55_6EF7
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ret

; ---- data $6EF7-$6F02 (11 bytes) [PROBABLE] 11-byte lookup table addressed by ld hl,$6EF7 in the routine 6EEC (the executed sibling routines each index an 11-byte table of zeros and ones the same way)

Data_55_6EF7:: ; 55:6EF7
	db $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01

; ---- code $6F02-$6F0D (11 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 9/18 scenarios); entry proven: target of an executed call/far call

Function_55_6F02:: ; 55:6F02
	ld hl, Data_55_6F0D
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ret

; ---- data $6F0D-$6F18 (11 bytes) [PROBABLE] zero/short bytes of the keyboard page tables between text rows; part of the run 6F0D-6F18 that executed code reads piecewise [split by classify_g2]

Data_55_6F0D:: ; 55:6F0D
	db $00, $00, $00, $00, $00, $01, $01, $00, $01, $01, $00

; ---- code $6F18-$6F23 (11 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 4/18 scenarios); entry proven: target of an executed call/far call

Function_55_6F18:: ; 55:6F18
	ld hl, Data_55_6F23
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ret

; ---- data $6F23-$6F2E (11 bytes) [PROBABLE] zero/short bytes of the keyboard page tables between text rows; part of the run 6F23-6F2E that executed code reads piecewise [split by classify_g2]

Data_55_6F23:: ; 55:6F23
	db $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $00

; ---- code $6F2E-$6F3B (13 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 12/18 scenarios); entry proven: target of an executed call/far call

Kbd_TypeWaitsWithService:: ; 55:6F2E
Function_55_6F2E::
	push hl
	ld hl, Data_55_6F3B
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	pop hl
	ret

; ---- data $6F3B-$6F46 (11 bytes) [PROBABLE] zero/short bytes of the keyboard page tables between text rows; part of the run 6F3B-6F46 that executed code reads piecewise [split by classify_g2]

Data_55_6F3B:: ; 55:6F3B
	db $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00

; ---- code $6F46-$6F95 (79 bytes) [HYPOTHESIS] ret-terminated routine (decodes cleanly through 6F94): decrements [$C2B1], else calls $047A, advances [$C2B0] mod 4 and writes two colour bytes to BCPD (ldh [$6A]=$B2 / [c]=$6B) from the word table below; follows the 11-byte table of the previous routine like the other routines of this run [verifier: no entry proven (no caller, no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS]
	ld a, [wRam_C2B1]
	dec a
	or a, a
	jr z, Label_55_6F51
	ld [wRam_C2B1], a
	ret

Label_55_6F51:: ; 55:6F51
	call Function_00_047A
	ld a, [wRam_C2B0]
	inc a
	and a, $03
	ld [wRam_C2B0], a
	ld hl, $6F9D
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ld [wRam_C2B1], a
	ld a, [wRam_C2B0]
	add a, a
	ld hl, Data_55_6F95
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, $B2
	ldh [rOCPS], a
	ld c, $6B
	ld a, [hli]
	ldh [c], a
	ld a, [hl]
	ldh [c], a
	ei
	call Function_00_0392
	dec hl
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D872
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ret

; ---- data $6F95-$6FA1 (12 bytes) [HYPOTHESIS] 12 bytes: 4 RGB555 colours $7F54,$7FFF,$7F54,$7E12 at 6F95 (indexed by [$C2B0]*2 via `ld hl,$6F95`, written to BCPD) and 4 delay bytes $06,$0C,$06,$06 at 6F9D (`ld hl,$6F9D ; ld a,[hl]`); both operands land exactly on these addresses and the block ends at the executed code 6FA1, but the only reader is the HYPOTHESIS routine 6F46 [verifier: earlier note called all 12 bytes a colour table; status lowered]

Data_55_6F95:: ; 55:6F95
	db $54, $7F, $FF, $7F, $54, $7F, $12, $7E, $06, $0C, $06, $06

; ---- code $6FA1-$6FC7 (38 bytes) [CONFIRMED] 21 insn(s); 21 executed (in up to 3/18 scenarios); entry proven: target of an executed call/far call

Kbd_RejectSymbol:: ; 55:6FA1
Function_55_6FA1::
	ld a, [wKeyboardCharLo]
	ld b, a
	ld c, $00
	ld hl, Data_55_6FC7

Label_55_6FAA:: ; 55:6FAA
	ld a, [hli]
	or a, a
	jr z, Label_55_6FC5
	cp a, b
	jr z, Label_55_6FB3
	jr Label_55_6FAA

Label_55_6FB3:: ; 55:6FB3
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld c, $01

Label_55_6FC5:: ; 55:6FC5
	ld a, c
	ret

; ---- data $6FC7-$6FCD (6 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown

Data_55_6FC7:: ; 55:6FC7
	db $40, $2E, $2D, $5F, $2B, $00

; ---- code $6FCD-$6FF4 (39 bytes) [CONFIRMED] 19 insn(s); 19 executed (in up to 7/18 scenarios); entry proven: target of an executed call/far call

Kbd_ShowMarkerSprite:: ; 55:6FCD
Function_55_6FCD::
	ld hl, $DAD0
	ld de, $4D38
	ld a, $5F
	ld b, $81
	farcall Function_00_0A82
	ld a, [wKbdType]
	ld hl, Data_55_6FF4
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $DAD0
	call Function_00_0A65
	ret

; ---- data $6FF4-$7000 (12 bytes) [PROBABLE] zero/short bytes of the keyboard page tables between text rows; part of the run 6FF4-7000 that executed code reads piecewise [split by classify_g2]

Data_55_6FF4:: ; 55:6FF4
	db $88, $50, $88, $60, $88, $60, $88, $68, $88, $68, $88, $68

; ---- code $7000-$7082 (130 bytes) [CONFIRMED] 67 insn(s); 67 executed (in up to 11/18 scenarios); entry proven: target of an executed call/far call

Kbd_HideMarkerSprite:: ; 55:7000
Function_55_7000::
	ld hl, $DAD0
	call Function_00_09E6
	ret

Kbd_LoadInputMode:: ; 55:7007
	or a, a
	jr nz, Label_55_700E
	ld [wKbdInputMode], a
	ret

Label_55_700E:: ; 55:700E
	ld hl, $BF05
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
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
	ld a, [hl]
	ld b, a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ld a, b
	ld [wKbdInputMode], a
	ret

Kbd_SaveInputMode:: ; 55:7048
	ld a, [wKbdInputMode]
	ld hl, $BF05
	ld b, a
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
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
	ld a, b
	ld [hl], a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ret
