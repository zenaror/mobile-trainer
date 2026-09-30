; engine/mail_server/delete_sprite_counters.asm
; bank 23, $58C4-$6D61 (5277 bytes); pinned by layout.link
; dead 5-digit sprite counter routines (entries replaced by ret; stubs still called)

SECTION "engine/mail_server/delete_sprite_counters", ROMX

; ---- code $58C4-$58C5 (1 bytes) [CONFIRMED] 1 insn(s); 1 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

SpriteCounter_StubA:: ; 23:58C4
Function_23_58C4::
	ret

; ---- code $58C5-$58E0 (27 bytes) [HYPOTHESIS] function body starting after ret at 58C4; computes hl += -(word at $D631) (xor $FF / inc bc / add hl,bc) and falls into the far call at 58E0; decode chain lands exactly on the next region [verifier: no entry proven (no caller, no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS] | forced execution: 18/18 instruction starts ran in forced_dead (traces/forced/, not natural evidence; status unchanged)

Function_23_58C5:: ; 23:58C5
	push hl
	push af
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D631
	ld a, [de]
	xor a, $FF
	ld c, a
	inc de
	ld a, [de]
	xor a, $FF
	ld b, a
	inc bc
	add hl, bc
	pop bc
	ld de, $2710

; ---- code $58E0-$5FA2 (1730 bytes) [PROBABLE] 653 insn(s) reached by static flow only; seeds: site x653; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code | forced execution: 74/653 instruction starts ran in forced_dead (traces/forced/, not natural evidence; status unchanged)
	farcall Divide16
	ld a, h
	or a, l
	jp z, Label_23_5925
	ld a, l
	push de
	call Function_23_59DA
	pop hl
	ld de, $03E8
	farcall Divide16
	ld a, l
	push de
	call Function_23_5B02
	pop hl
	ld de, $0064
	farcall Divide16
	ld a, l
	push de
	call Function_23_5C2A
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	push de
	call Function_23_5D52
	pop hl
	ld a, l
	call Function_23_5E7A
	jp Label_23_59AD

Label_23_5925:: ; 23:5925
	ld l, e
	ld h, d
	ld de, $03E8
	farcall Divide16
	ld a, h
	or a, l
	jp z, Label_23_5960
	ld a, l
	push de
	call Function_23_5B02
	pop hl
	ld de, $0064
	farcall Divide16
	ld a, l
	push de
	call Function_23_5C2A
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	push de
	call Function_23_5D52
	pop hl
	ld a, l
	call Function_23_5E7A
	jp Label_23_59AD

Label_23_5960:: ; 23:5960
	ld l, e
	ld h, d
	ld de, $0064
	farcall Divide16
	ld a, h
	or a, l
	jp z, Label_23_598C
	ld a, l
	push de
	call Function_23_5C2A
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	push de
	call Function_23_5D52
	pop hl
	ld a, l
	call Function_23_5E7A
	jp Label_23_59AD

Label_23_598C:: ; 23:598C
	ld l, e
	ld h, d
	ld de, $000A
	farcall Divide16
	ld a, h
	or a, l
	jp z, Label_23_59A9
	ld a, l
	push de
	call Function_23_5D52
	pop hl
	ld a, l
	call Function_23_5E7A
	jp Label_23_59AD

Label_23_59A9:: ; 23:59A9
	ld a, e
	call Function_23_5E7A

Label_23_59AD:: ; 23:59AD
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld l, a
	ld a, [wSpriteSlots + 80]
	add a, l
	ld [wSpriteSlots + 80], a
	ld a, [wSpriteSlots + 64]
	add a, l
	ld [wSpriteSlots + 64], a
	ld a, [wSpriteSlots + 48]
	add a, l
	ld [wSpriteSlots + 48], a
	ld a, [wSpriteSlots + 32]
	add a, l
	ld [wSpriteSlots + 32], a
	ld a, [wSpriteSlots + 16]
	add a, l
	ld [wSpriteSlots + 16], a
	pop hl
	ret

Function_23_59DA:: ; 23:59DA
	cp a, $00
	jr nz, Label_23_59F8
	ld hl, $DA10
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Label_23_59F8:: ; 23:59F8
	cp a, $01
	jr nz, Label_23_5A16
	ld hl, $DA10
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Label_23_5A16:: ; 23:5A16
	cp a, $02
	jr nz, Label_23_5A34
	ld hl, $DA10
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Label_23_5A34:: ; 23:5A34
	cp a, $03
	jr nz, Label_23_5A52
	ld hl, $DA10
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Label_23_5A52:: ; 23:5A52
	cp a, $04
	jr nz, Label_23_5A70
	ld hl, $DA10
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Label_23_5A70:: ; 23:5A70
	cp a, $05
	jr nz, Label_23_5A8E
	ld hl, $DA10
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Label_23_5A8E:: ; 23:5A8E
	cp a, $06
	jr nz, Label_23_5AAC
	ld hl, $DA10
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Label_23_5AAC:: ; 23:5AAC
	cp a, $07
	jr nz, Label_23_5ACA
	ld hl, $DA10
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Label_23_5ACA:: ; 23:5ACA
	cp a, $08
	jr nz, Label_23_5AE8
	ld hl, $DA10
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Label_23_5AE8:: ; 23:5AE8
	ld hl, $DA10
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Function_23_5B02:: ; 23:5B02
	cp a, $00
	jr nz, Label_23_5B20
	ld hl, $DA20
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Label_23_5B20:: ; 23:5B20
	cp a, $01
	jr nz, Label_23_5B3E
	ld hl, $DA20
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Label_23_5B3E:: ; 23:5B3E
	cp a, $02
	jr nz, Label_23_5B5C
	ld hl, $DA20
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Label_23_5B5C:: ; 23:5B5C
	cp a, $03
	jr nz, Label_23_5B7A
	ld hl, $DA20
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Label_23_5B7A:: ; 23:5B7A
	cp a, $04
	jr nz, Label_23_5B98
	ld hl, $DA20
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Label_23_5B98:: ; 23:5B98
	cp a, $05
	jr nz, Label_23_5BB6
	ld hl, $DA20
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Label_23_5BB6:: ; 23:5BB6
	cp a, $06
	jr nz, Label_23_5BD4
	ld hl, $DA20
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Label_23_5BD4:: ; 23:5BD4
	cp a, $07
	jr nz, Label_23_5BF2
	ld hl, $DA20
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Label_23_5BF2:: ; 23:5BF2
	cp a, $08
	jr nz, Label_23_5C10
	ld hl, $DA20
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Label_23_5C10:: ; 23:5C10
	ld hl, $DA20
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Function_23_5C2A:: ; 23:5C2A
	cp a, $00
	jr nz, Label_23_5C48
	ld hl, $DA30
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Label_23_5C48:: ; 23:5C48
	cp a, $01
	jr nz, Label_23_5C66
	ld hl, $DA30
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Label_23_5C66:: ; 23:5C66
	cp a, $02
	jr nz, Label_23_5C84
	ld hl, $DA30
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Label_23_5C84:: ; 23:5C84
	cp a, $03
	jr nz, Label_23_5CA2
	ld hl, $DA30
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Label_23_5CA2:: ; 23:5CA2
	cp a, $04
	jr nz, Label_23_5CC0
	ld hl, $DA30
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Label_23_5CC0:: ; 23:5CC0
	cp a, $05
	jr nz, Label_23_5CDE
	ld hl, $DA30
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Label_23_5CDE:: ; 23:5CDE
	cp a, $06
	jr nz, Label_23_5CFC
	ld hl, $DA30
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Label_23_5CFC:: ; 23:5CFC
	cp a, $07
	jr nz, Label_23_5D1A
	ld hl, $DA30
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Label_23_5D1A:: ; 23:5D1A
	cp a, $08
	jr nz, Label_23_5D38
	ld hl, $DA30
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Label_23_5D38:: ; 23:5D38
	ld hl, $DA30
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Function_23_5D52:: ; 23:5D52
	cp a, $00
	jr nz, Label_23_5D70
	ld hl, $DA40
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_23_5D70:: ; 23:5D70
	cp a, $01
	jr nz, Label_23_5D8E
	ld hl, $DA40
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_23_5D8E:: ; 23:5D8E
	cp a, $02
	jr nz, Label_23_5DAC
	ld hl, $DA40
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_23_5DAC:: ; 23:5DAC
	cp a, $03
	jr nz, Label_23_5DCA
	ld hl, $DA40
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_23_5DCA:: ; 23:5DCA
	cp a, $04
	jr nz, Label_23_5DE8
	ld hl, $DA40
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_23_5DE8:: ; 23:5DE8
	cp a, $05
	jr nz, Label_23_5E06
	ld hl, $DA40
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_23_5E06:: ; 23:5E06
	cp a, $06
	jr nz, Label_23_5E24
	ld hl, $DA40
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_23_5E24:: ; 23:5E24
	cp a, $07
	jr nz, Label_23_5E42
	ld hl, $DA40
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_23_5E42:: ; 23:5E42
	cp a, $08
	jr nz, Label_23_5E60
	ld hl, $DA40
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_23_5E60:: ; 23:5E60
	ld hl, $DA40
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Function_23_5E7A:: ; 23:5E7A
	cp a, $00
	jr nz, Label_23_5E98
	ld hl, $DA50
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

Label_23_5E98:: ; 23:5E98
	cp a, $01
	jr nz, Label_23_5EB6
	ld hl, $DA50
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

Label_23_5EB6:: ; 23:5EB6
	cp a, $02
	jr nz, Label_23_5ED4
	ld hl, $DA50
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

Label_23_5ED4:: ; 23:5ED4
	cp a, $03
	jr nz, Label_23_5EF2
	ld hl, $DA50
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

Label_23_5EF2:: ; 23:5EF2
	cp a, $04
	jr nz, Label_23_5F10
	ld hl, $DA50
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

Label_23_5F10:: ; 23:5F10
	cp a, $05
	jr nz, Label_23_5F2E
	ld hl, $DA50
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

Label_23_5F2E:: ; 23:5F2E
	cp a, $06
	jr nz, Label_23_5F4C
	ld hl, $DA50
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

Label_23_5F4C:: ; 23:5F4C
	cp a, $07
	jr nz, Label_23_5F6A
	ld hl, $DA50
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

Label_23_5F6A:: ; 23:5F6A
	cp a, $08
	jr nz, Label_23_5F88
	ld hl, $DA50
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

Label_23_5F88:: ; 23:5F88
	ld hl, $DA50
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

; ---- code $5FA2-$5FA3 (1 bytes) [CONFIRMED] 1 insn(s); 1 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

SpriteCounter_StubB:: ; 23:5FA2
Function_23_5FA2::
	ret

; ---- code $5FA3-$5FD7 (52 bytes) [HYPOTHESIS] function starting after the ret pair 5FA1/5FA2; 20 insn (5 x ld de,$D048 ; ld hl,$DAxx ; call $0A65 sprite-slot writes) falling through into the CONFIRMED far call at 5FD7 [verifier: no entry proven (no caller, no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS] | forced execution: 20/20 instruction starts ran in forced_dead (traces/forced/, not natural evidence; status unchanged)

Function_23_5FA3:: ; 23:5FA3
	push hl
	push af
	push hl
	ld de, $D048
	ld hl, $DAA0
	call Function_00_0A65
	ld de, $D048
	ld hl, $DA90
	call Function_00_0A65
	ld de, $D048
	ld hl, $DA80
	call Function_00_0A65
	ld de, $D048
	ld hl, $DA70
	call Function_00_0A65
	ld de, $D048
	ld hl, $DA60
	call Function_00_0A65
	pop hl
	ld de, $2710

; ---- code $5FD7-$6699 (1730 bytes) [PROBABLE] 654 insn(s) reached by static flow only; seeds: exec x1, site x653; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code | 653 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5FD7-669A by apply_coverage --split | forced execution: 70/653 instruction starts ran in forced_dead (traces/forced/, not natural evidence; status unchanged)
	farcall Divide16
	ld a, h
	or a, l
	jp z, Label_23_601C
	ld a, l
	push de
	call Function_23_60D1
	pop hl
	ld de, $03E8
	farcall Divide16
	ld a, l
	push de
	call Function_23_61F9
	pop hl
	ld de, $0064
	farcall Divide16
	ld a, l
	push de
	call Function_23_6321
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	push de
	call Function_23_6449
	pop hl
	ld a, l
	call Function_23_6571
	jp Label_23_60A4

Label_23_601C:: ; 23:601C
	ld l, e
	ld h, d
	ld de, $03E8
	farcall Divide16
	ld a, h
	or a, l
	jp z, Label_23_6057
	ld a, l
	push de
	call Function_23_61F9
	pop hl
	ld de, $0064
	farcall Divide16
	ld a, l
	push de
	call Function_23_6321
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	push de
	call Function_23_6449
	pop hl
	ld a, l
	call Function_23_6571
	jp Label_23_60A4

Label_23_6057:: ; 23:6057
	ld l, e
	ld h, d
	ld de, $0064
	farcall Divide16
	ld a, h
	or a, l
	jp z, Label_23_6083
	ld a, l
	push de
	call Function_23_6321
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	push de
	call Function_23_6449
	pop hl
	ld a, l
	call Function_23_6571
	jp Label_23_60A4

Label_23_6083:: ; 23:6083
	ld l, e
	ld h, d
	ld de, $000A
	farcall Divide16
	ld a, h
	or a, l
	jp z, Label_23_60A0
	ld a, l
	push de
	call Function_23_6449
	pop hl
	ld a, l
	call Function_23_6571
	jp Label_23_60A4

Label_23_60A0:: ; 23:60A0
	ld a, e
	call Function_23_6571

Label_23_60A4:: ; 23:60A4
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld l, a
	ld a, [wSpriteSlots + 160]
	add a, l
	ld [wSpriteSlots + 160], a
	ld a, [wSpriteSlots + 144]
	add a, l
	ld [wSpriteSlots + 144], a
	ld a, [wSpriteSlots + 128]
	add a, l
	ld [wSpriteSlots + 128], a
	ld a, [wSpriteSlots + 112]
	add a, l
	ld [wSpriteSlots + 112], a
	ld a, [wSpriteSlots + 96]
	add a, l
	ld [wSpriteSlots + 96], a
	pop hl
	ret

Function_23_60D1:: ; 23:60D1
	cp a, $00
	jr nz, Label_23_60EF
	ld hl, $DA60
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $642F
	ld hl, $DA60
	call Function_00_0A65
	ret

Label_23_60EF:: ; 23:60EF
	cp a, $01
	jr nz, Label_23_610D
	ld hl, $DA60
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $642F
	ld hl, $DA60
	call Function_00_0A65
	ret

Label_23_610D:: ; 23:610D
	cp a, $02
	jr nz, Label_23_612B
	ld hl, $DA60
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $642F
	ld hl, $DA60
	call Function_00_0A65
	ret

Label_23_612B:: ; 23:612B
	cp a, $03
	jr nz, Label_23_6149
	ld hl, $DA60
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $642F
	ld hl, $DA60
	call Function_00_0A65
	ret

Label_23_6149:: ; 23:6149
	cp a, $04
	jr nz, Label_23_6167
	ld hl, $DA60
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $642F
	ld hl, $DA60
	call Function_00_0A65
	ret

Label_23_6167:: ; 23:6167
	cp a, $05
	jr nz, Label_23_6185
	ld hl, $DA60
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $642F
	ld hl, $DA60
	call Function_00_0A65
	ret

Label_23_6185:: ; 23:6185
	cp a, $06
	jr nz, Label_23_61A3
	ld hl, $DA60
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $642F
	ld hl, $DA60
	call Function_00_0A65
	ret

Label_23_61A3:: ; 23:61A3
	cp a, $07
	jr nz, Label_23_61C1
	ld hl, $DA60
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $642F
	ld hl, $DA60
	call Function_00_0A65
	ret

Label_23_61C1:: ; 23:61C1
	cp a, $08
	jr nz, Label_23_61DF
	ld hl, $DA60
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $642F
	ld hl, $DA60
	call Function_00_0A65
	ret

Label_23_61DF:: ; 23:61DF
	ld hl, $DA60
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $642F
	ld hl, $DA60
	call Function_00_0A65
	ret

Function_23_61F9:: ; 23:61F9
	cp a, $00
	jr nz, Label_23_6217
	ld hl, $DA70
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6435
	ld hl, $DA70
	call Function_00_0A65
	ret

Label_23_6217:: ; 23:6217
	cp a, $01
	jr nz, Label_23_6235
	ld hl, $DA70
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6435
	ld hl, $DA70
	call Function_00_0A65
	ret

Label_23_6235:: ; 23:6235
	cp a, $02
	jr nz, Label_23_6253
	ld hl, $DA70
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6435
	ld hl, $DA70
	call Function_00_0A65
	ret

Label_23_6253:: ; 23:6253
	cp a, $03
	jr nz, Label_23_6271
	ld hl, $DA70
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6435
	ld hl, $DA70
	call Function_00_0A65
	ret

Label_23_6271:: ; 23:6271
	cp a, $04
	jr nz, Label_23_628F
	ld hl, $DA70
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6435
	ld hl, $DA70
	call Function_00_0A65
	ret

Label_23_628F:: ; 23:628F
	cp a, $05
	jr nz, Label_23_62AD
	ld hl, $DA70
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6435
	ld hl, $DA70
	call Function_00_0A65
	ret

Label_23_62AD:: ; 23:62AD
	cp a, $06
	jr nz, Label_23_62CB
	ld hl, $DA70
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6435
	ld hl, $DA70
	call Function_00_0A65
	ret

Label_23_62CB:: ; 23:62CB
	cp a, $07
	jr nz, Label_23_62E9
	ld hl, $DA70
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6435
	ld hl, $DA70
	call Function_00_0A65
	ret

Label_23_62E9:: ; 23:62E9
	cp a, $08
	jr nz, Label_23_6307
	ld hl, $DA70
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6435
	ld hl, $DA70
	call Function_00_0A65
	ret

Label_23_6307:: ; 23:6307
	ld hl, $DA70
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6435
	ld hl, $DA70
	call Function_00_0A65
	ret

Function_23_6321:: ; 23:6321
	cp a, $00
	jr nz, Label_23_633F
	ld hl, $DA80
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $643B
	ld hl, $DA80
	call Function_00_0A65
	ret

Label_23_633F:: ; 23:633F
	cp a, $01
	jr nz, Label_23_635D
	ld hl, $DA80
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $643B
	ld hl, $DA80
	call Function_00_0A65
	ret

Label_23_635D:: ; 23:635D
	cp a, $02
	jr nz, Label_23_637B
	ld hl, $DA80
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $643B
	ld hl, $DA80
	call Function_00_0A65
	ret

Label_23_637B:: ; 23:637B
	cp a, $03
	jr nz, Label_23_6399
	ld hl, $DA80
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $643B
	ld hl, $DA80
	call Function_00_0A65
	ret

Label_23_6399:: ; 23:6399
	cp a, $04
	jr nz, Label_23_63B7
	ld hl, $DA80
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $643B
	ld hl, $DA80
	call Function_00_0A65
	ret

Label_23_63B7:: ; 23:63B7
	cp a, $05
	jr nz, Label_23_63D5
	ld hl, $DA80
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $643B
	ld hl, $DA80
	call Function_00_0A65
	ret

Label_23_63D5:: ; 23:63D5
	cp a, $06
	jr nz, Label_23_63F3
	ld hl, $DA80
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $643B
	ld hl, $DA80
	call Function_00_0A65
	ret

Label_23_63F3:: ; 23:63F3
	cp a, $07
	jr nz, Label_23_6411
	ld hl, $DA80
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $643B
	ld hl, $DA80
	call Function_00_0A65
	ret

Label_23_6411:: ; 23:6411
	cp a, $08
	jr nz, Label_23_642F
	ld hl, $DA80
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $643B
	ld hl, $DA80
	call Function_00_0A65
	ret

Label_23_642F:: ; 23:642F
	ld hl, $DA80
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $643B
	ld hl, $DA80
	call Function_00_0A65
	ret

Function_23_6449:: ; 23:6449
	cp a, $00
	jr nz, Label_23_6467
	ld hl, $DA90
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6441
	ld hl, $DA90
	call Function_00_0A65
	ret

Label_23_6467:: ; 23:6467
	cp a, $01
	jr nz, Label_23_6485
	ld hl, $DA90
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6441
	ld hl, $DA90
	call Function_00_0A65
	ret

Label_23_6485:: ; 23:6485
	cp a, $02
	jr nz, Label_23_64A3
	ld hl, $DA90
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6441
	ld hl, $DA90
	call Function_00_0A65
	ret

Label_23_64A3:: ; 23:64A3
	cp a, $03
	jr nz, Label_23_64C1
	ld hl, $DA90
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6441
	ld hl, $DA90
	call Function_00_0A65
	ret

Label_23_64C1:: ; 23:64C1
	cp a, $04
	jr nz, Label_23_64DF
	ld hl, $DA90
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6441
	ld hl, $DA90
	call Function_00_0A65
	ret

Label_23_64DF:: ; 23:64DF
	cp a, $05
	jr nz, Label_23_64FD
	ld hl, $DA90
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6441
	ld hl, $DA90
	call Function_00_0A65
	ret

Label_23_64FD:: ; 23:64FD
	cp a, $06
	jr nz, Label_23_651B
	ld hl, $DA90
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6441
	ld hl, $DA90
	call Function_00_0A65
	ret

Label_23_651B:: ; 23:651B
	cp a, $07
	jr nz, Label_23_6539
	ld hl, $DA90
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6441
	ld hl, $DA90
	call Function_00_0A65
	ret

Label_23_6539:: ; 23:6539
	cp a, $08
	jr nz, Label_23_6557
	ld hl, $DA90
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6441
	ld hl, $DA90
	call Function_00_0A65
	ret

Label_23_6557:: ; 23:6557
	ld hl, $DA90
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6441
	ld hl, $DA90
	call Function_00_0A65
	ret

Function_23_6571:: ; 23:6571
	cp a, $00
	jr nz, Label_23_658F
	ld hl, $DAA0
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6447
	ld hl, $DAA0
	call Function_00_0A65
	ret

Label_23_658F:: ; 23:658F
	cp a, $01
	jr nz, Label_23_65AD
	ld hl, $DAA0
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6447
	ld hl, $DAA0
	call Function_00_0A65
	ret

Label_23_65AD:: ; 23:65AD
	cp a, $02
	jr nz, Label_23_65CB
	ld hl, $DAA0
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6447
	ld hl, $DAA0
	call Function_00_0A65
	ret

Label_23_65CB:: ; 23:65CB
	cp a, $03
	jr nz, Label_23_65E9
	ld hl, $DAA0
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6447
	ld hl, $DAA0
	call Function_00_0A65
	ret

Label_23_65E9:: ; 23:65E9
	cp a, $04
	jr nz, Label_23_6607
	ld hl, $DAA0
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6447
	ld hl, $DAA0
	call Function_00_0A65
	ret

Label_23_6607:: ; 23:6607
	cp a, $05
	jr nz, Label_23_6625
	ld hl, $DAA0
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6447
	ld hl, $DAA0
	call Function_00_0A65
	ret

Label_23_6625:: ; 23:6625
	cp a, $06
	jr nz, Label_23_6643
	ld hl, $DAA0
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6447
	ld hl, $DAA0
	call Function_00_0A65
	ret

Label_23_6643:: ; 23:6643
	cp a, $07
	jr nz, Label_23_6661
	ld hl, $DAA0
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6447
	ld hl, $DAA0
	call Function_00_0A65
	ret

Label_23_6661:: ; 23:6661
	cp a, $08
	jr nz, Label_23_667F
	ld hl, $DAA0
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6447
	ld hl, $DAA0
	call Function_00_0A65
	ret

Label_23_667F:: ; 23:667F
	ld hl, $DAA0
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $6447
	ld hl, $DAA0
	call Function_00_0A65
	ret

; ---- code $6699-$669A (1 bytes) [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 5FD7-669A by apply_coverage --split [executed in 7 scenarios]

SpriteCounter_StubC:: ; 23:6699
	ret

; ---- code $669A-$669F (5 bytes) [HYPOTHESIS] push hl ; push af ; ld de,$2710 prologue after the ret pair 6698/6699, falls into the far call at 669F; twin of the longer 5FA3 function | forced execution: 3/3 instruction starts ran in forced_dead (traces/forced/, not natural evidence; status unchanged)

Function_23_669A:: ; 23:669A
	push hl
	push af
	ld de, $2710

; ---- code $669F-$6D61 (1730 bytes) [PROBABLE] 653 insn(s) reached by static flow only; seeds: site x653; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code | forced execution: 76/653 instruction starts ran in forced_dead (traces/forced/, not natural evidence; status unchanged)
	farcall Divide16
	ld a, h
	or a, l
	jp z, Label_23_66E4
	ld a, l
	push de
	call Function_23_6799
	pop hl
	ld de, $03E8
	farcall Divide16
	ld a, l
	push de
	call Function_23_68C1
	pop hl
	ld de, $0064
	farcall Divide16
	ld a, l
	push de
	call Function_23_69E9
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	push de
	call Function_23_6B11
	pop hl
	ld a, l
	call Function_23_6C39
	jp Label_23_676C

Label_23_66E4:: ; 23:66E4
	ld l, e
	ld h, d
	ld de, $03E8
	farcall Divide16
	ld a, h
	or a, l
	jp z, Label_23_671F
	ld a, l
	push de
	call Function_23_68C1
	pop hl
	ld de, $0064
	farcall Divide16
	ld a, l
	push de
	call Function_23_69E9
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	push de
	call Function_23_6B11
	pop hl
	ld a, l
	call Function_23_6C39
	jp Label_23_676C

Label_23_671F:: ; 23:671F
	ld l, e
	ld h, d
	ld de, $0064
	farcall Divide16
	ld a, h
	or a, l
	jp z, Label_23_674B
	ld a, l
	push de
	call Function_23_69E9
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	push de
	call Function_23_6B11
	pop hl
	ld a, l
	call Function_23_6C39
	jp Label_23_676C

Label_23_674B:: ; 23:674B
	ld l, e
	ld h, d
	ld de, $000A
	farcall Divide16
	ld a, h
	or a, l
	jp z, Label_23_6768
	ld a, l
	push de
	call Function_23_6B11
	pop hl
	ld a, l
	call Function_23_6C39
	jp Label_23_676C

Label_23_6768:: ; 23:6768
	ld a, e
	call Function_23_6C39

Label_23_676C:: ; 23:676C
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld l, a
	ld a, [wSpriteSlots + 80]
	add a, l
	ld [wSpriteSlots + 80], a
	ld a, [wSpriteSlots + 64]
	add a, l
	ld [wSpriteSlots + 64], a
	ld a, [wSpriteSlots + 48]
	add a, l
	ld [wSpriteSlots + 48], a
	ld a, [wSpriteSlots + 32]
	add a, l
	ld [wSpriteSlots + 32], a
	ld a, [wSpriteSlots + 16]
	add a, l
	ld [wSpriteSlots + 16], a
	pop hl
	ret

Function_23_6799:: ; 23:6799
	cp a, $00
	jr nz, Label_23_67B7
	ld hl, $DA10
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Label_23_67B7:: ; 23:67B7
	cp a, $01
	jr nz, Label_23_67D5
	ld hl, $DA10
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Label_23_67D5:: ; 23:67D5
	cp a, $02
	jr nz, Label_23_67F3
	ld hl, $DA10
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Label_23_67F3:: ; 23:67F3
	cp a, $03
	jr nz, Label_23_6811
	ld hl, $DA10
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Label_23_6811:: ; 23:6811
	cp a, $04
	jr nz, Label_23_682F
	ld hl, $DA10
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Label_23_682F:: ; 23:682F
	cp a, $05
	jr nz, Label_23_684D
	ld hl, $DA10
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Label_23_684D:: ; 23:684D
	cp a, $06
	jr nz, Label_23_686B
	ld hl, $DA10
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Label_23_686B:: ; 23:686B
	cp a, $07
	jr nz, Label_23_6889
	ld hl, $DA10
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Label_23_6889:: ; 23:6889
	cp a, $08
	jr nz, Label_23_68A7
	ld hl, $DA10
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Label_23_68A7:: ; 23:68A7
	ld hl, $DA10
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A2F
	ld hl, $DA10
	call Function_00_0A65
	ret

Function_23_68C1:: ; 23:68C1
	cp a, $00
	jr nz, Label_23_68DF
	ld hl, $DA20
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Label_23_68DF:: ; 23:68DF
	cp a, $01
	jr nz, Label_23_68FD
	ld hl, $DA20
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Label_23_68FD:: ; 23:68FD
	cp a, $02
	jr nz, Label_23_691B
	ld hl, $DA20
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Label_23_691B:: ; 23:691B
	cp a, $03
	jr nz, Label_23_6939
	ld hl, $DA20
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Label_23_6939:: ; 23:6939
	cp a, $04
	jr nz, Label_23_6957
	ld hl, $DA20
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Label_23_6957:: ; 23:6957
	cp a, $05
	jr nz, Label_23_6975
	ld hl, $DA20
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Label_23_6975:: ; 23:6975
	cp a, $06
	jr nz, Label_23_6993
	ld hl, $DA20
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Label_23_6993:: ; 23:6993
	cp a, $07
	jr nz, Label_23_69B1
	ld hl, $DA20
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Label_23_69B1:: ; 23:69B1
	cp a, $08
	jr nz, Label_23_69CF
	ld hl, $DA20
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Label_23_69CF:: ; 23:69CF
	ld hl, $DA20
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A35
	ld hl, $DA20
	call Function_00_0A65
	ret

Function_23_69E9:: ; 23:69E9
	cp a, $00
	jr nz, Label_23_6A07
	ld hl, $DA30
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Label_23_6A07:: ; 23:6A07
	cp a, $01
	jr nz, Label_23_6A25
	ld hl, $DA30
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Label_23_6A25:: ; 23:6A25
	cp a, $02
	jr nz, Label_23_6A43
	ld hl, $DA30
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Label_23_6A43:: ; 23:6A43
	cp a, $03
	jr nz, Label_23_6A61
	ld hl, $DA30
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Label_23_6A61:: ; 23:6A61
	cp a, $04
	jr nz, Label_23_6A7F
	ld hl, $DA30
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Label_23_6A7F:: ; 23:6A7F
	cp a, $05
	jr nz, Label_23_6A9D
	ld hl, $DA30
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Label_23_6A9D:: ; 23:6A9D
	cp a, $06
	jr nz, Label_23_6ABB
	ld hl, $DA30
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Label_23_6ABB:: ; 23:6ABB
	cp a, $07
	jr nz, Label_23_6AD9
	ld hl, $DA30
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Label_23_6AD9:: ; 23:6AD9
	cp a, $08
	jr nz, Label_23_6AF7
	ld hl, $DA30
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Label_23_6AF7:: ; 23:6AF7
	ld hl, $DA30
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A3B
	ld hl, $DA30
	call Function_00_0A65
	ret

Function_23_6B11:: ; 23:6B11
	cp a, $00
	jr nz, Label_23_6B2F
	ld hl, $DA40
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_23_6B2F:: ; 23:6B2F
	cp a, $01
	jr nz, Label_23_6B4D
	ld hl, $DA40
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_23_6B4D:: ; 23:6B4D
	cp a, $02
	jr nz, Label_23_6B6B
	ld hl, $DA40
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_23_6B6B:: ; 23:6B6B
	cp a, $03
	jr nz, Label_23_6B89
	ld hl, $DA40
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_23_6B89:: ; 23:6B89
	cp a, $04
	jr nz, Label_23_6BA7
	ld hl, $DA40
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_23_6BA7:: ; 23:6BA7
	cp a, $05
	jr nz, Label_23_6BC5
	ld hl, $DA40
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_23_6BC5:: ; 23:6BC5
	cp a, $06
	jr nz, Label_23_6BE3
	ld hl, $DA40
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_23_6BE3:: ; 23:6BE3
	cp a, $07
	jr nz, Label_23_6C01
	ld hl, $DA40
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_23_6C01:: ; 23:6C01
	cp a, $08
	jr nz, Label_23_6C1F
	ld hl, $DA40
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Label_23_6C1F:: ; 23:6C1F
	ld hl, $DA40
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A41
	ld hl, $DA40
	call Function_00_0A65
	ret

Function_23_6C39:: ; 23:6C39
	cp a, $00
	jr nz, Label_23_6C57
	ld hl, $DA50
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

Label_23_6C57:: ; 23:6C57
	cp a, $01
	jr nz, Label_23_6C75
	ld hl, $DA50
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

Label_23_6C75:: ; 23:6C75
	cp a, $02
	jr nz, Label_23_6C93
	ld hl, $DA50
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

Label_23_6C93:: ; 23:6C93
	cp a, $03
	jr nz, Label_23_6CB1
	ld hl, $DA50
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

Label_23_6CB1:: ; 23:6CB1
	cp a, $04
	jr nz, Label_23_6CCF
	ld hl, $DA50
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

Label_23_6CCF:: ; 23:6CCF
	cp a, $05
	jr nz, Label_23_6CED
	ld hl, $DA50
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

Label_23_6CED:: ; 23:6CED
	cp a, $06
	jr nz, Label_23_6D0B
	ld hl, $DA50
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

Label_23_6D0B:: ; 23:6D0B
	cp a, $07
	jr nz, Label_23_6D29
	ld hl, $DA50
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

Label_23_6D29:: ; 23:6D29
	cp a, $08
	jr nz, Label_23_6D47
	ld hl, $DA50
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret

Label_23_6D47:: ; 23:6D47
	ld hl, $DA50
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Function_00_0A82
	ld de, $5A47
	ld hl, $DA50
	call Function_00_0A65
	ret
