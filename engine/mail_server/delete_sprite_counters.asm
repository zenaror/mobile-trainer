; engine/mail_server/delete_sprite_counters.asm
; bank 23, $58C4-$6D61 (5277 bytes); pinned by layout.link
; dead 5-digit sprite counter routines (entries replaced by ret; stubs still called)

SECTION "engine/mail_server/delete_sprite_counters", ROMX

SpriteCounter_StubA:: ; 23:58C4
Function_23_58C4::
	; [CONFIRMED] 1 insn(s); 1 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ret

SpriteCounter_A_DrawNumber:: ; 23:58C5
Function_23_58C5::
	; [HYPOTHESIS] function body starting after ret at 58C4; computes hl += -(word at $D631) (xor
	; $FF / inc bc / add hl,bc) and falls into the far call at 58E0; decode chain lands exactly on
	; the next region [verifier: no entry proven (no caller, no valid table word, never executed):
	; decode chain alone is not proof -> HYPOTHESIS] | forced execution: 18/18 instruction starts
	; ran in forced_dead (traces/forced/, not natural evidence; status unchanged)
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

	; [PROBABLE] 653 insn(s) reached by static flow only; seeds: site x653; min discovery hops 0;
	; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code |
	; forced execution: 74/653 instruction starts ran in forced_dead (traces/forced/, not natural
	; evidence; status unchanged)
	farcall Divide16
	ld a, h
	or a, l
	jp z, .l5925
	ld a, l
	push de
	call SpriteCounter_A_DrawDigit10000
	pop hl
	ld de, $03E8
	farcall Divide16
	ld a, l
	push de
	call SpriteCounter_A_DrawDigit1000
	pop hl
	ld de, $0064
	farcall Divide16
	ld a, l
	push de
	call SpriteCounter_A_DrawDigit100
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	push de
	call SpriteCounter_A_DrawDigit10
	pop hl
	ld a, l
	call SpriteCounter_A_DrawDigit1
	jp .l59AD
.l5925 ; 23:5925
	ld l, e
	ld h, d
	ld de, $03E8
	farcall Divide16
	ld a, h
	or a, l
	jp z, .l5960
	ld a, l
	push de
	call SpriteCounter_A_DrawDigit1000
	pop hl
	ld de, $0064
	farcall Divide16
	ld a, l
	push de
	call SpriteCounter_A_DrawDigit100
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	push de
	call SpriteCounter_A_DrawDigit10
	pop hl
	ld a, l
	call SpriteCounter_A_DrawDigit1
	jp .l59AD
.l5960 ; 23:5960
	ld l, e
	ld h, d
	ld de, $0064
	farcall Divide16
	ld a, h
	or a, l
	jp z, .l598C
	ld a, l
	push de
	call SpriteCounter_A_DrawDigit100
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	push de
	call SpriteCounter_A_DrawDigit10
	pop hl
	ld a, l
	call SpriteCounter_A_DrawDigit1
	jp .l59AD
.l598C ; 23:598C
	ld l, e
	ld h, d
	ld de, $000A
	farcall Divide16
	ld a, h
	or a, l
	jp z, .l59A9
	ld a, l
	push de
	call SpriteCounter_A_DrawDigit10
	pop hl
	ld a, l
	call SpriteCounter_A_DrawDigit1
	jp .l59AD
.l59A9 ; 23:59A9
	ld a, e
	call SpriteCounter_A_DrawDigit1
.l59AD ; 23:59AD
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

SpriteCounter_A_DrawDigit10000:: ; 23:59DA
Function_23_59DA::
	cp a, $00
	jr nz, .l59F8
	ld hl, $DA10
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret
.l59F8 ; 23:59F8
	cp a, $01
	jr nz, .l5A16
	ld hl, $DA10
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret
.l5A16 ; 23:5A16
	cp a, $02
	jr nz, .l5A34
	ld hl, $DA10
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret
.l5A34 ; 23:5A34
	cp a, $03
	jr nz, .l5A52
	ld hl, $DA10
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret
.l5A52 ; 23:5A52
	cp a, $04
	jr nz, .l5A70
	ld hl, $DA10
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret
.l5A70 ; 23:5A70
	cp a, $05
	jr nz, .l5A8E
	ld hl, $DA10
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret
.l5A8E ; 23:5A8E
	cp a, $06
	jr nz, .l5AAC
	ld hl, $DA10
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret
.l5AAC ; 23:5AAC
	cp a, $07
	jr nz, .l5ACA
	ld hl, $DA10
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret
.l5ACA ; 23:5ACA
	cp a, $08
	jr nz, .l5AE8
	ld hl, $DA10
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret
.l5AE8 ; 23:5AE8
	ld hl, $DA10
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret

SpriteCounter_A_DrawDigit1000:: ; 23:5B02
Function_23_5B02::
	cp a, $00
	jr nz, .l5B20
	ld hl, $DA20
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret
.l5B20 ; 23:5B20
	cp a, $01
	jr nz, .l5B3E
	ld hl, $DA20
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret
.l5B3E ; 23:5B3E
	cp a, $02
	jr nz, .l5B5C
	ld hl, $DA20
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret
.l5B5C ; 23:5B5C
	cp a, $03
	jr nz, .l5B7A
	ld hl, $DA20
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret
.l5B7A ; 23:5B7A
	cp a, $04
	jr nz, .l5B98
	ld hl, $DA20
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret
.l5B98 ; 23:5B98
	cp a, $05
	jr nz, .l5BB6
	ld hl, $DA20
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret
.l5BB6 ; 23:5BB6
	cp a, $06
	jr nz, .l5BD4
	ld hl, $DA20
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret
.l5BD4 ; 23:5BD4
	cp a, $07
	jr nz, .l5BF2
	ld hl, $DA20
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret
.l5BF2 ; 23:5BF2
	cp a, $08
	jr nz, .l5C10
	ld hl, $DA20
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret
.l5C10 ; 23:5C10
	ld hl, $DA20
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret

SpriteCounter_A_DrawDigit100:: ; 23:5C2A
Function_23_5C2A::
	cp a, $00
	jr nz, .l5C48
	ld hl, $DA30
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret
.l5C48 ; 23:5C48
	cp a, $01
	jr nz, .l5C66
	ld hl, $DA30
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret
.l5C66 ; 23:5C66
	cp a, $02
	jr nz, .l5C84
	ld hl, $DA30
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret
.l5C84 ; 23:5C84
	cp a, $03
	jr nz, .l5CA2
	ld hl, $DA30
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret
.l5CA2 ; 23:5CA2
	cp a, $04
	jr nz, .l5CC0
	ld hl, $DA30
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret
.l5CC0 ; 23:5CC0
	cp a, $05
	jr nz, .l5CDE
	ld hl, $DA30
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret
.l5CDE ; 23:5CDE
	cp a, $06
	jr nz, .l5CFC
	ld hl, $DA30
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret
.l5CFC ; 23:5CFC
	cp a, $07
	jr nz, .l5D1A
	ld hl, $DA30
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret
.l5D1A ; 23:5D1A
	cp a, $08
	jr nz, .l5D38
	ld hl, $DA30
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret
.l5D38 ; 23:5D38
	ld hl, $DA30
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret

SpriteCounter_A_DrawDigit10:: ; 23:5D52
Function_23_5D52::
	cp a, $00
	jr nz, .l5D70
	ld hl, $DA40
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret
.l5D70 ; 23:5D70
	cp a, $01
	jr nz, .l5D8E
	ld hl, $DA40
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret
.l5D8E ; 23:5D8E
	cp a, $02
	jr nz, .l5DAC
	ld hl, $DA40
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret
.l5DAC ; 23:5DAC
	cp a, $03
	jr nz, .l5DCA
	ld hl, $DA40
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret
.l5DCA ; 23:5DCA
	cp a, $04
	jr nz, .l5DE8
	ld hl, $DA40
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret
.l5DE8 ; 23:5DE8
	cp a, $05
	jr nz, .l5E06
	ld hl, $DA40
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret
.l5E06 ; 23:5E06
	cp a, $06
	jr nz, .l5E24
	ld hl, $DA40
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret
.l5E24 ; 23:5E24
	cp a, $07
	jr nz, .l5E42
	ld hl, $DA40
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret
.l5E42 ; 23:5E42
	cp a, $08
	jr nz, .l5E60
	ld hl, $DA40
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret
.l5E60 ; 23:5E60
	ld hl, $DA40
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret

SpriteCounter_A_DrawDigit1:: ; 23:5E7A
Function_23_5E7A::
	cp a, $00
	jr nz, .l5E98
	ld hl, $DA50
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
.l5E98 ; 23:5E98
	cp a, $01
	jr nz, .l5EB6
	ld hl, $DA50
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
.l5EB6 ; 23:5EB6
	cp a, $02
	jr nz, .l5ED4
	ld hl, $DA50
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
.l5ED4 ; 23:5ED4
	cp a, $03
	jr nz, .l5EF2
	ld hl, $DA50
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
.l5EF2 ; 23:5EF2
	cp a, $04
	jr nz, .l5F10
	ld hl, $DA50
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
.l5F10 ; 23:5F10
	cp a, $05
	jr nz, .l5F2E
	ld hl, $DA50
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
.l5F2E ; 23:5F2E
	cp a, $06
	jr nz, .l5F4C
	ld hl, $DA50
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
.l5F4C ; 23:5F4C
	cp a, $07
	jr nz, .l5F6A
	ld hl, $DA50
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
.l5F6A ; 23:5F6A
	cp a, $08
	jr nz, .l5F88
	ld hl, $DA50
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
.l5F88 ; 23:5F88
	ld hl, $DA50
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret

SpriteCounter_StubB:: ; 23:5FA2
Function_23_5FA2::
	; [CONFIRMED] 1 insn(s); 1 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ret

SpriteCounter_B_DrawNumber:: ; 23:5FA3
Function_23_5FA3::
	; [HYPOTHESIS] function starting after the ret pair 5FA1/5FA2; 20 insn (5 x ld de,$D048 ; ld
	; hl,$DAxx ; call $0A65 sprite-slot writes) falling through into the CONFIRMED far call at 5FD7
	; [verifier: no entry proven (no caller, no valid table word, never executed): decode chain
	; alone is not proof -> HYPOTHESIS] | forced execution: 20/20 instruction starts ran in
	; forced_dead (traces/forced/, not natural evidence; status unchanged)
	push hl
	push af
	push hl
	ld de, $D048
	ld hl, $DAA0
	call Sprite_SetPosition
	ld de, $D048
	ld hl, $DA90
	call Sprite_SetPosition
	ld de, $D048
	ld hl, $DA80
	call Sprite_SetPosition
	ld de, $D048
	ld hl, $DA70
	call Sprite_SetPosition
	ld de, $D048
	ld hl, $DA60
	call Sprite_SetPosition
	pop hl
	ld de, $2710

	; [PROBABLE] 654 insn(s) reached by static flow only; seeds: exec x1, site x653; min discovery
	; hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with
	; decoded code | 653 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5FD7-669A by apply_coverage --split | forced execution: 70/653 instruction starts ran in
	; forced_dead (traces/forced/, not natural evidence; status unchanged)
	farcall Divide16
	ld a, h
	or a, l
	jp z, .l601C
	ld a, l
	push de
	call SpriteCounter_B_DrawDigit10000
	pop hl
	ld de, $03E8
	farcall Divide16
	ld a, l
	push de
	call SpriteCounter_B_DrawDigit1000
	pop hl
	ld de, $0064
	farcall Divide16
	ld a, l
	push de
	call SpriteCounter_B_DrawDigit100
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	push de
	call SpriteCounter_B_DrawDigit10
	pop hl
	ld a, l
	call SpriteCounter_B_DrawDigit1
	jp .l60A4
.l601C ; 23:601C
	ld l, e
	ld h, d
	ld de, $03E8
	farcall Divide16
	ld a, h
	or a, l
	jp z, .l6057
	ld a, l
	push de
	call SpriteCounter_B_DrawDigit1000
	pop hl
	ld de, $0064
	farcall Divide16
	ld a, l
	push de
	call SpriteCounter_B_DrawDigit100
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	push de
	call SpriteCounter_B_DrawDigit10
	pop hl
	ld a, l
	call SpriteCounter_B_DrawDigit1
	jp .l60A4
.l6057 ; 23:6057
	ld l, e
	ld h, d
	ld de, $0064
	farcall Divide16
	ld a, h
	or a, l
	jp z, .l6083
	ld a, l
	push de
	call SpriteCounter_B_DrawDigit100
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	push de
	call SpriteCounter_B_DrawDigit10
	pop hl
	ld a, l
	call SpriteCounter_B_DrawDigit1
	jp .l60A4
.l6083 ; 23:6083
	ld l, e
	ld h, d
	ld de, $000A
	farcall Divide16
	ld a, h
	or a, l
	jp z, .l60A0
	ld a, l
	push de
	call SpriteCounter_B_DrawDigit10
	pop hl
	ld a, l
	call SpriteCounter_B_DrawDigit1
	jp .l60A4
.l60A0 ; 23:60A0
	ld a, e
	call SpriteCounter_B_DrawDigit1
.l60A4 ; 23:60A4
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

SpriteCounter_B_DrawDigit10000:: ; 23:60D1
Function_23_60D1::
	cp a, $00
	jr nz, .l60EF
	ld hl, $DA60
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, $DA60
	call Sprite_SetPosition
	ret
.l60EF ; 23:60EF
	cp a, $01
	jr nz, .l610D
	ld hl, $DA60
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, $DA60
	call Sprite_SetPosition
	ret
.l610D ; 23:610D
	cp a, $02
	jr nz, .l612B
	ld hl, $DA60
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, $DA60
	call Sprite_SetPosition
	ret
.l612B ; 23:612B
	cp a, $03
	jr nz, .l6149
	ld hl, $DA60
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, $DA60
	call Sprite_SetPosition
	ret
.l6149 ; 23:6149
	cp a, $04
	jr nz, .l6167
	ld hl, $DA60
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, $DA60
	call Sprite_SetPosition
	ret
.l6167 ; 23:6167
	cp a, $05
	jr nz, .l6185
	ld hl, $DA60
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, $DA60
	call Sprite_SetPosition
	ret
.l6185 ; 23:6185
	cp a, $06
	jr nz, .l61A3
	ld hl, $DA60
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, $DA60
	call Sprite_SetPosition
	ret
.l61A3 ; 23:61A3
	cp a, $07
	jr nz, .l61C1
	ld hl, $DA60
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, $DA60
	call Sprite_SetPosition
	ret
.l61C1 ; 23:61C1
	cp a, $08
	jr nz, .l61DF
	ld hl, $DA60
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, $DA60
	call Sprite_SetPosition
	ret
.l61DF ; 23:61DF
	ld hl, $DA60
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, $DA60
	call Sprite_SetPosition
	ret

SpriteCounter_B_DrawDigit1000:: ; 23:61F9
Function_23_61F9::
	cp a, $00
	jr nz, .l6217
	ld hl, $DA70
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, $DA70
	call Sprite_SetPosition
	ret
.l6217 ; 23:6217
	cp a, $01
	jr nz, .l6235
	ld hl, $DA70
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, $DA70
	call Sprite_SetPosition
	ret
.l6235 ; 23:6235
	cp a, $02
	jr nz, .l6253
	ld hl, $DA70
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, $DA70
	call Sprite_SetPosition
	ret
.l6253 ; 23:6253
	cp a, $03
	jr nz, .l6271
	ld hl, $DA70
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, $DA70
	call Sprite_SetPosition
	ret
.l6271 ; 23:6271
	cp a, $04
	jr nz, .l628F
	ld hl, $DA70
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, $DA70
	call Sprite_SetPosition
	ret
.l628F ; 23:628F
	cp a, $05
	jr nz, .l62AD
	ld hl, $DA70
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, $DA70
	call Sprite_SetPosition
	ret
.l62AD ; 23:62AD
	cp a, $06
	jr nz, .l62CB
	ld hl, $DA70
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, $DA70
	call Sprite_SetPosition
	ret
.l62CB ; 23:62CB
	cp a, $07
	jr nz, .l62E9
	ld hl, $DA70
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, $DA70
	call Sprite_SetPosition
	ret
.l62E9 ; 23:62E9
	cp a, $08
	jr nz, .l6307
	ld hl, $DA70
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, $DA70
	call Sprite_SetPosition
	ret
.l6307 ; 23:6307
	ld hl, $DA70
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, $DA70
	call Sprite_SetPosition
	ret

SpriteCounter_B_DrawDigit100:: ; 23:6321
Function_23_6321::
	cp a, $00
	jr nz, .l633F
	ld hl, $DA80
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, $DA80
	call Sprite_SetPosition
	ret
.l633F ; 23:633F
	cp a, $01
	jr nz, .l635D
	ld hl, $DA80
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, $DA80
	call Sprite_SetPosition
	ret
.l635D ; 23:635D
	cp a, $02
	jr nz, .l637B
	ld hl, $DA80
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, $DA80
	call Sprite_SetPosition
	ret
.l637B ; 23:637B
	cp a, $03
	jr nz, .l6399
	ld hl, $DA80
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, $DA80
	call Sprite_SetPosition
	ret
.l6399 ; 23:6399
	cp a, $04
	jr nz, .l63B7
	ld hl, $DA80
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, $DA80
	call Sprite_SetPosition
	ret
.l63B7 ; 23:63B7
	cp a, $05
	jr nz, .l63D5
	ld hl, $DA80
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, $DA80
	call Sprite_SetPosition
	ret
.l63D5 ; 23:63D5
	cp a, $06
	jr nz, .l63F3
	ld hl, $DA80
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, $DA80
	call Sprite_SetPosition
	ret
.l63F3 ; 23:63F3
	cp a, $07
	jr nz, .l6411
	ld hl, $DA80
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, $DA80
	call Sprite_SetPosition
	ret
.l6411 ; 23:6411
	cp a, $08
	jr nz, .l642F
	ld hl, $DA80
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, $DA80
	call Sprite_SetPosition
	ret
.l642F ; 23:642F
	ld hl, $DA80
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, $DA80
	call Sprite_SetPosition
	ret

SpriteCounter_B_DrawDigit10:: ; 23:6449
Function_23_6449::
	cp a, $00
	jr nz, .l6467
	ld hl, $DA90
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, $DA90
	call Sprite_SetPosition
	ret
.l6467 ; 23:6467
	cp a, $01
	jr nz, .l6485
	ld hl, $DA90
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, $DA90
	call Sprite_SetPosition
	ret
.l6485 ; 23:6485
	cp a, $02
	jr nz, .l64A3
	ld hl, $DA90
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, $DA90
	call Sprite_SetPosition
	ret
.l64A3 ; 23:64A3
	cp a, $03
	jr nz, .l64C1
	ld hl, $DA90
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, $DA90
	call Sprite_SetPosition
	ret
.l64C1 ; 23:64C1
	cp a, $04
	jr nz, .l64DF
	ld hl, $DA90
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, $DA90
	call Sprite_SetPosition
	ret
.l64DF ; 23:64DF
	cp a, $05
	jr nz, .l64FD
	ld hl, $DA90
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, $DA90
	call Sprite_SetPosition
	ret
.l64FD ; 23:64FD
	cp a, $06
	jr nz, .l651B
	ld hl, $DA90
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, $DA90
	call Sprite_SetPosition
	ret
.l651B ; 23:651B
	cp a, $07
	jr nz, .l6539
	ld hl, $DA90
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, $DA90
	call Sprite_SetPosition
	ret
.l6539 ; 23:6539
	cp a, $08
	jr nz, .l6557
	ld hl, $DA90
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, $DA90
	call Sprite_SetPosition
	ret
.l6557 ; 23:6557
	ld hl, $DA90
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, $DA90
	call Sprite_SetPosition
	ret

SpriteCounter_B_DrawDigit1:: ; 23:6571
Function_23_6571::
	cp a, $00
	jr nz, .l658F
	ld hl, $DAA0
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, $DAA0
	call Sprite_SetPosition
	ret
.l658F ; 23:658F
	cp a, $01
	jr nz, .l65AD
	ld hl, $DAA0
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, $DAA0
	call Sprite_SetPosition
	ret
.l65AD ; 23:65AD
	cp a, $02
	jr nz, .l65CB
	ld hl, $DAA0
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, $DAA0
	call Sprite_SetPosition
	ret
.l65CB ; 23:65CB
	cp a, $03
	jr nz, .l65E9
	ld hl, $DAA0
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, $DAA0
	call Sprite_SetPosition
	ret
.l65E9 ; 23:65E9
	cp a, $04
	jr nz, .l6607
	ld hl, $DAA0
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, $DAA0
	call Sprite_SetPosition
	ret
.l6607 ; 23:6607
	cp a, $05
	jr nz, .l6625
	ld hl, $DAA0
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, $DAA0
	call Sprite_SetPosition
	ret
.l6625 ; 23:6625
	cp a, $06
	jr nz, .l6643
	ld hl, $DAA0
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, $DAA0
	call Sprite_SetPosition
	ret
.l6643 ; 23:6643
	cp a, $07
	jr nz, .l6661
	ld hl, $DAA0
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, $DAA0
	call Sprite_SetPosition
	ret
.l6661 ; 23:6661
	cp a, $08
	jr nz, .l667F
	ld hl, $DAA0
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, $DAA0
	call Sprite_SetPosition
	ret
.l667F ; 23:667F
	ld hl, $DAA0
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, $DAA0
	call Sprite_SetPosition
	ret

SpriteCounter_StubC:: ; 23:6699
	; [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 5FD7-669A by apply_coverage
	; --split [executed in 7 scenarios]
	ret

SpriteCounter_C_DrawNumber:: ; 23:669A
Function_23_669A::
	; [HYPOTHESIS] push hl ; push af ; ld de,$2710 prologue after the ret pair 6698/6699, falls into
	; the far call at 669F; twin of the longer 5FA3 function | forced execution: 3/3 instruction
	; starts ran in forced_dead (traces/forced/, not natural evidence; status unchanged)
	push hl
	push af
	ld de, $2710

	; [PROBABLE] 653 insn(s) reached by static flow only; seeds: site x653; min discovery hops 0;
	; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code |
	; forced execution: 76/653 instruction starts ran in forced_dead (traces/forced/, not natural
	; evidence; status unchanged)
	farcall Divide16
	ld a, h
	or a, l
	jp z, .l66E4
	ld a, l
	push de
	call SpriteCounter_C_DrawDigit10000
	pop hl
	ld de, $03E8
	farcall Divide16
	ld a, l
	push de
	call SpriteCounter_C_DrawDigit1000
	pop hl
	ld de, $0064
	farcall Divide16
	ld a, l
	push de
	call SpriteCounter_C_DrawDigit100
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	push de
	call SpriteCounter_C_DrawDigit10
	pop hl
	ld a, l
	call SpriteCounter_C_DrawDigit1
	jp .l676C
.l66E4 ; 23:66E4
	ld l, e
	ld h, d
	ld de, $03E8
	farcall Divide16
	ld a, h
	or a, l
	jp z, .l671F
	ld a, l
	push de
	call SpriteCounter_C_DrawDigit1000
	pop hl
	ld de, $0064
	farcall Divide16
	ld a, l
	push de
	call SpriteCounter_C_DrawDigit100
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	push de
	call SpriteCounter_C_DrawDigit10
	pop hl
	ld a, l
	call SpriteCounter_C_DrawDigit1
	jp .l676C
.l671F ; 23:671F
	ld l, e
	ld h, d
	ld de, $0064
	farcall Divide16
	ld a, h
	or a, l
	jp z, .l674B
	ld a, l
	push de
	call SpriteCounter_C_DrawDigit100
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	push de
	call SpriteCounter_C_DrawDigit10
	pop hl
	ld a, l
	call SpriteCounter_C_DrawDigit1
	jp .l676C
.l674B ; 23:674B
	ld l, e
	ld h, d
	ld de, $000A
	farcall Divide16
	ld a, h
	or a, l
	jp z, .l6768
	ld a, l
	push de
	call SpriteCounter_C_DrawDigit10
	pop hl
	ld a, l
	call SpriteCounter_C_DrawDigit1
	jp .l676C
.l6768 ; 23:6768
	ld a, e
	call SpriteCounter_C_DrawDigit1
.l676C ; 23:676C
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

SpriteCounter_C_DrawDigit10000:: ; 23:6799
Function_23_6799::
	cp a, $00
	jr nz, .l67B7
	ld hl, $DA10
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret
.l67B7 ; 23:67B7
	cp a, $01
	jr nz, .l67D5
	ld hl, $DA10
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret
.l67D5 ; 23:67D5
	cp a, $02
	jr nz, .l67F3
	ld hl, $DA10
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret
.l67F3 ; 23:67F3
	cp a, $03
	jr nz, .l6811
	ld hl, $DA10
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret
.l6811 ; 23:6811
	cp a, $04
	jr nz, .l682F
	ld hl, $DA10
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret
.l682F ; 23:682F
	cp a, $05
	jr nz, .l684D
	ld hl, $DA10
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret
.l684D ; 23:684D
	cp a, $06
	jr nz, .l686B
	ld hl, $DA10
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret
.l686B ; 23:686B
	cp a, $07
	jr nz, .l6889
	ld hl, $DA10
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret
.l6889 ; 23:6889
	cp a, $08
	jr nz, .l68A7
	ld hl, $DA10
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret
.l68A7 ; 23:68A7
	ld hl, $DA10
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, $DA10
	call Sprite_SetPosition
	ret

SpriteCounter_C_DrawDigit1000:: ; 23:68C1
Function_23_68C1::
	cp a, $00
	jr nz, .l68DF
	ld hl, $DA20
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret
.l68DF ; 23:68DF
	cp a, $01
	jr nz, .l68FD
	ld hl, $DA20
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret
.l68FD ; 23:68FD
	cp a, $02
	jr nz, .l691B
	ld hl, $DA20
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret
.l691B ; 23:691B
	cp a, $03
	jr nz, .l6939
	ld hl, $DA20
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret
.l6939 ; 23:6939
	cp a, $04
	jr nz, .l6957
	ld hl, $DA20
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret
.l6957 ; 23:6957
	cp a, $05
	jr nz, .l6975
	ld hl, $DA20
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret
.l6975 ; 23:6975
	cp a, $06
	jr nz, .l6993
	ld hl, $DA20
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret
.l6993 ; 23:6993
	cp a, $07
	jr nz, .l69B1
	ld hl, $DA20
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret
.l69B1 ; 23:69B1
	cp a, $08
	jr nz, .l69CF
	ld hl, $DA20
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret
.l69CF ; 23:69CF
	ld hl, $DA20
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, $DA20
	call Sprite_SetPosition
	ret

SpriteCounter_C_DrawDigit100:: ; 23:69E9
Function_23_69E9::
	cp a, $00
	jr nz, .l6A07
	ld hl, $DA30
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret
.l6A07 ; 23:6A07
	cp a, $01
	jr nz, .l6A25
	ld hl, $DA30
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret
.l6A25 ; 23:6A25
	cp a, $02
	jr nz, .l6A43
	ld hl, $DA30
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret
.l6A43 ; 23:6A43
	cp a, $03
	jr nz, .l6A61
	ld hl, $DA30
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret
.l6A61 ; 23:6A61
	cp a, $04
	jr nz, .l6A7F
	ld hl, $DA30
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret
.l6A7F ; 23:6A7F
	cp a, $05
	jr nz, .l6A9D
	ld hl, $DA30
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret
.l6A9D ; 23:6A9D
	cp a, $06
	jr nz, .l6ABB
	ld hl, $DA30
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret
.l6ABB ; 23:6ABB
	cp a, $07
	jr nz, .l6AD9
	ld hl, $DA30
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret
.l6AD9 ; 23:6AD9
	cp a, $08
	jr nz, .l6AF7
	ld hl, $DA30
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret
.l6AF7 ; 23:6AF7
	ld hl, $DA30
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, $DA30
	call Sprite_SetPosition
	ret

SpriteCounter_C_DrawDigit10:: ; 23:6B11
Function_23_6B11::
	cp a, $00
	jr nz, .l6B2F
	ld hl, $DA40
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret
.l6B2F ; 23:6B2F
	cp a, $01
	jr nz, .l6B4D
	ld hl, $DA40
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret
.l6B4D ; 23:6B4D
	cp a, $02
	jr nz, .l6B6B
	ld hl, $DA40
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret
.l6B6B ; 23:6B6B
	cp a, $03
	jr nz, .l6B89
	ld hl, $DA40
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret
.l6B89 ; 23:6B89
	cp a, $04
	jr nz, .l6BA7
	ld hl, $DA40
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret
.l6BA7 ; 23:6BA7
	cp a, $05
	jr nz, .l6BC5
	ld hl, $DA40
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret
.l6BC5 ; 23:6BC5
	cp a, $06
	jr nz, .l6BE3
	ld hl, $DA40
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret
.l6BE3 ; 23:6BE3
	cp a, $07
	jr nz, .l6C01
	ld hl, $DA40
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret
.l6C01 ; 23:6C01
	cp a, $08
	jr nz, .l6C1F
	ld hl, $DA40
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret
.l6C1F ; 23:6C1F
	ld hl, $DA40
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, $DA40
	call Sprite_SetPosition
	ret

SpriteCounter_C_DrawDigit1:: ; 23:6C39
Function_23_6C39::
	cp a, $00
	jr nz, .l6C57
	ld hl, $DA50
	ld de, Table_SpriteCounter_Digits
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
.l6C57 ; 23:6C57
	cp a, $01
	jr nz, .l6C75
	ld hl, $DA50
	ld de, $79A0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
.l6C75 ; 23:6C75
	cp a, $02
	jr nz, .l6C93
	ld hl, $DA50
	ld de, $79B0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
.l6C93 ; 23:6C93
	cp a, $03
	jr nz, .l6CB1
	ld hl, $DA50
	ld de, $79C0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
.l6CB1 ; 23:6CB1
	cp a, $04
	jr nz, .l6CCF
	ld hl, $DA50
	ld de, $79D0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
.l6CCF ; 23:6CCF
	cp a, $05
	jr nz, .l6CED
	ld hl, $DA50
	ld de, $79E0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
.l6CED ; 23:6CED
	cp a, $06
	jr nz, .l6D0B
	ld hl, $DA50
	ld de, $79F0
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
.l6D0B ; 23:6D0B
	cp a, $07
	jr nz, .l6D29
	ld hl, $DA50
	ld de, $7A00
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
.l6D29 ; 23:6D29
	cp a, $08
	jr nz, .l6D47
	ld hl, $DA50
	ld de, $7A10
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
.l6D47 ; 23:6D47
	ld hl, $DA50
	ld de, $7A20
	ld a, $23
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, $DA50
	call Sprite_SetPosition
	ret
