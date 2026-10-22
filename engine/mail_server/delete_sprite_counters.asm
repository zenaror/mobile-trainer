; engine/mail_server/delete_sprite_counters.asm
; bank 23, $58C4-$6D61 (5277 bytes); pinned by layout.link
; dead 5-digit sprite counter routines (entries replaced by ret; stubs still called)

SECTION "engine/mail_server/delete_sprite_counters", ROMX

SpriteCounter_StubA:: ; 23:58C4

	; [CONFIRMED] 1 insn(s); 1 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ret

SpriteCounter_A_DrawNumber:: ; 23:58C5

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
	ld de, wMailSessionBlock + $0D
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
	jp z, .divide_by_1000
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
	jp .add_saved_a_to_slots
.divide_by_1000 ; 23:5925
	ld l, e
	ld h, d
	ld de, $03E8
	farcall Divide16
	ld a, h
	or a, l
	jp z, .divide_by_100
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
	jp .add_saved_a_to_slots
.divide_by_100 ; 23:5960
	ld l, e
	ld h, d
	ld de, $0064
	farcall Divide16
	ld a, h
	or a, l
	jp z, .divide_by_10
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
	jp .add_saved_a_to_slots
.divide_by_10 ; 23:598C
	ld l, e
	ld h, d
	ld de, $000A
	farcall Divide16
	ld a, h
	or a, l
	jp z, .draw_ones_from_e
	ld a, l
	push de
	call SpriteCounter_A_DrawDigit10
	pop hl
	ld a, l
	call SpriteCounter_A_DrawDigit1
	jp .add_saved_a_to_slots
.draw_ones_from_e ; 23:59A9
	ld a, e
	call SpriteCounter_A_DrawDigit1
.add_saved_a_to_slots ; 23:59AD
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld l, a
	ld a, [wSpriteSlot5]
	add a, l
	ld [wSpriteSlot5], a
	ld a, [wSpriteSlot4]
	add a, l
	ld [wSpriteSlot4], a
	ld a, [wSpriteSlot3]
	add a, l
	ld [wSpriteSlot3], a
	ld a, [wSpriteSlot2]
	add a, l
	ld [wSpriteSlot2], a
	ld a, [wSpriteSlot1]
	add a, l
	ld [wSpriteSlot1], a
	pop hl
	ret

SpriteCounter_A_DrawDigit10000:: ; 23:59DA

	cp a, $00
	jr nz, .check_value_1
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits
	ld a, BANK(Table_SpriteCounter_Digits)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret
.check_value_1 ; 23:59F8
	cp a, $01
	jr nz, .check_value_2
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits_Entry4
	ld a, BANK(Table_SpriteCounter_Digits_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret
.check_value_2 ; 23:5A16
	cp a, $02
	jr nz, .check_value_3
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits_Entry8
	ld a, BANK(Table_SpriteCounter_Digits_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret
.check_value_3 ; 23:5A34
	cp a, $03
	jr nz, .check_value_4
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits_Entry12
	ld a, BANK(Table_SpriteCounter_Digits_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret
.check_value_4 ; 23:5A52
	cp a, $04
	jr nz, .check_value_5
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits_Entry16
	ld a, BANK(Table_SpriteCounter_Digits_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret
.check_value_5 ; 23:5A70
	cp a, $05
	jr nz, .check_value_6
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits_Entry20
	ld a, BANK(Table_SpriteCounter_Digits_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret
.check_value_6 ; 23:5A8E
	cp a, $06
	jr nz, .check_value_7
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits_Entry24
	ld a, BANK(Table_SpriteCounter_Digits_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret
.check_value_7 ; 23:5AAC
	cp a, $07
	jr nz, .check_value_8
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits_Entry28
	ld a, BANK(Table_SpriteCounter_Digits_Entry28)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret
.check_value_8 ; 23:5ACA
	cp a, $08
	jr nz, .use_default_entry
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits_Entry32
	ld a, BANK(Table_SpriteCounter_Digits_Entry32)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret
.use_default_entry ; 23:5AE8
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits_Entry36
	ld a, BANK(Table_SpriteCounter_Digits_Entry36)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret

SpriteCounter_A_DrawDigit1000:: ; 23:5B02

	cp a, $00
	jr nz, .check_value_1
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits
	ld a, BANK(Table_SpriteCounter_Digits)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret
.check_value_1 ; 23:5B20
	cp a, $01
	jr nz, .check_value_2
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits_Entry4
	ld a, BANK(Table_SpriteCounter_Digits_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret
.check_value_2 ; 23:5B3E
	cp a, $02
	jr nz, .check_value_3
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits_Entry8
	ld a, BANK(Table_SpriteCounter_Digits_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret
.check_value_3 ; 23:5B5C
	cp a, $03
	jr nz, .check_value_4
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits_Entry12
	ld a, BANK(Table_SpriteCounter_Digits_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret
.check_value_4 ; 23:5B7A
	cp a, $04
	jr nz, .check_value_5
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits_Entry16
	ld a, BANK(Table_SpriteCounter_Digits_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret
.check_value_5 ; 23:5B98
	cp a, $05
	jr nz, .check_value_6
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits_Entry20
	ld a, BANK(Table_SpriteCounter_Digits_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret
.check_value_6 ; 23:5BB6
	cp a, $06
	jr nz, .check_value_7
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits_Entry24
	ld a, BANK(Table_SpriteCounter_Digits_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret
.check_value_7 ; 23:5BD4
	cp a, $07
	jr nz, .check_value_8
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits_Entry28
	ld a, BANK(Table_SpriteCounter_Digits_Entry28)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret
.check_value_8 ; 23:5BF2
	cp a, $08
	jr nz, .use_default_entry
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits_Entry32
	ld a, BANK(Table_SpriteCounter_Digits_Entry32)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret
.use_default_entry ; 23:5C10
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits_Entry36
	ld a, BANK(Table_SpriteCounter_Digits_Entry36)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret

SpriteCounter_A_DrawDigit100:: ; 23:5C2A

	cp a, $00
	jr nz, .check_value_1
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits
	ld a, BANK(Table_SpriteCounter_Digits)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret
.check_value_1 ; 23:5C48
	cp a, $01
	jr nz, .check_value_2
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits_Entry4
	ld a, BANK(Table_SpriteCounter_Digits_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret
.check_value_2 ; 23:5C66
	cp a, $02
	jr nz, .check_value_3
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits_Entry8
	ld a, BANK(Table_SpriteCounter_Digits_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret
.check_value_3 ; 23:5C84
	cp a, $03
	jr nz, .check_value_4
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits_Entry12
	ld a, BANK(Table_SpriteCounter_Digits_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret
.check_value_4 ; 23:5CA2
	cp a, $04
	jr nz, .check_value_5
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits_Entry16
	ld a, BANK(Table_SpriteCounter_Digits_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret
.check_value_5 ; 23:5CC0
	cp a, $05
	jr nz, .check_value_6
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits_Entry20
	ld a, BANK(Table_SpriteCounter_Digits_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret
.check_value_6 ; 23:5CDE
	cp a, $06
	jr nz, .check_value_7
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits_Entry24
	ld a, BANK(Table_SpriteCounter_Digits_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret
.check_value_7 ; 23:5CFC
	cp a, $07
	jr nz, .check_value_8
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits_Entry28
	ld a, BANK(Table_SpriteCounter_Digits_Entry28)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret
.check_value_8 ; 23:5D1A
	cp a, $08
	jr nz, .use_default_entry
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits_Entry32
	ld a, BANK(Table_SpriteCounter_Digits_Entry32)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret
.use_default_entry ; 23:5D38
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits_Entry36
	ld a, BANK(Table_SpriteCounter_Digits_Entry36)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret

SpriteCounter_A_DrawDigit10:: ; 23:5D52

	cp a, $00
	jr nz, .check_value_1
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits
	ld a, BANK(Table_SpriteCounter_Digits)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.check_value_1 ; 23:5D70
	cp a, $01
	jr nz, .check_value_2
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits_Entry4
	ld a, BANK(Table_SpriteCounter_Digits_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.check_value_2 ; 23:5D8E
	cp a, $02
	jr nz, .check_value_3
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits_Entry8
	ld a, BANK(Table_SpriteCounter_Digits_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.check_value_3 ; 23:5DAC
	cp a, $03
	jr nz, .check_value_4
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits_Entry12
	ld a, BANK(Table_SpriteCounter_Digits_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.check_value_4 ; 23:5DCA
	cp a, $04
	jr nz, .check_value_5
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits_Entry16
	ld a, BANK(Table_SpriteCounter_Digits_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.check_value_5 ; 23:5DE8
	cp a, $05
	jr nz, .check_value_6
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits_Entry20
	ld a, BANK(Table_SpriteCounter_Digits_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.check_value_6 ; 23:5E06
	cp a, $06
	jr nz, .check_value_7
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits_Entry24
	ld a, BANK(Table_SpriteCounter_Digits_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.check_value_7 ; 23:5E24
	cp a, $07
	jr nz, .check_value_8
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits_Entry28
	ld a, BANK(Table_SpriteCounter_Digits_Entry28)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.check_value_8 ; 23:5E42
	cp a, $08
	jr nz, .use_default_entry
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits_Entry32
	ld a, BANK(Table_SpriteCounter_Digits_Entry32)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.use_default_entry ; 23:5E60
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits_Entry36
	ld a, BANK(Table_SpriteCounter_Digits_Entry36)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret

SpriteCounter_A_DrawDigit1:: ; 23:5E7A

	cp a, $00
	jr nz, .check_value_1
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits
	ld a, BANK(Table_SpriteCounter_Digits)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
.check_value_1 ; 23:5E98
	cp a, $01
	jr nz, .check_value_2
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits_Entry4
	ld a, BANK(Table_SpriteCounter_Digits_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
.check_value_2 ; 23:5EB6
	cp a, $02
	jr nz, .check_value_3
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits_Entry8
	ld a, BANK(Table_SpriteCounter_Digits_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
.check_value_3 ; 23:5ED4
	cp a, $03
	jr nz, .check_value_4
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits_Entry12
	ld a, BANK(Table_SpriteCounter_Digits_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
.check_value_4 ; 23:5EF2
	cp a, $04
	jr nz, .check_value_5
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits_Entry16
	ld a, BANK(Table_SpriteCounter_Digits_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
.check_value_5 ; 23:5F10
	cp a, $05
	jr nz, .check_value_6
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits_Entry20
	ld a, BANK(Table_SpriteCounter_Digits_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
.check_value_6 ; 23:5F2E
	cp a, $06
	jr nz, .check_value_7
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits_Entry24
	ld a, BANK(Table_SpriteCounter_Digits_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
.check_value_7 ; 23:5F4C
	cp a, $07
	jr nz, .check_value_8
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits_Entry28
	ld a, BANK(Table_SpriteCounter_Digits_Entry28)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
.check_value_8 ; 23:5F6A
	cp a, $08
	jr nz, .use_default_entry
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits_Entry32
	ld a, BANK(Table_SpriteCounter_Digits_Entry32)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
.use_default_entry ; 23:5F88
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits_Entry36
	ld a, BANK(Table_SpriteCounter_Digits_Entry36)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret

SpriteCounter_StubB:: ; 23:5FA2

	; [CONFIRMED] 1 insn(s); 1 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ret

SpriteCounter_B_DrawNumber:: ; 23:5FA3

	; [HYPOTHESIS] function starting after the ret pair 5FA1/5FA2; 20 insn (5 x ld de,$D048 ; ld
	; hl,$DAxx ; call $0A65 sprite-slot writes) falling through into the CONFIRMED far call at 5FD7
	; [verifier: no entry proven (no caller, no valid table word, never executed): decode chain
	; alone is not proof -> HYPOTHESIS] | forced execution: 20/20 instruction starts ran in
	; forced_dead (traces/forced/, not natural evidence; status unchanged)
	push hl
	push af
	push hl
	ld de, $D048
	ld hl, wSpriteSlot10
	call Sprite_SetPosition
	ld de, $D048
	ld hl, wSpriteSlot9
	call Sprite_SetPosition
	ld de, $D048
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	ld de, $D048
	ld hl, wSpriteSlot7
	call Sprite_SetPosition
	ld de, $D048
	ld hl, wSpriteSlot6
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
	jp z, .divide_by_1000
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
	jp .add_saved_a_to_slots
.divide_by_1000 ; 23:601C
	ld l, e
	ld h, d
	ld de, $03E8
	farcall Divide16
	ld a, h
	or a, l
	jp z, .divide_by_100
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
	jp .add_saved_a_to_slots
.divide_by_100 ; 23:6057
	ld l, e
	ld h, d
	ld de, $0064
	farcall Divide16
	ld a, h
	or a, l
	jp z, .divide_by_10
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
	jp .add_saved_a_to_slots
.divide_by_10 ; 23:6083
	ld l, e
	ld h, d
	ld de, $000A
	farcall Divide16
	ld a, h
	or a, l
	jp z, .draw_ones_from_e
	ld a, l
	push de
	call SpriteCounter_B_DrawDigit10
	pop hl
	ld a, l
	call SpriteCounter_B_DrawDigit1
	jp .add_saved_a_to_slots
.draw_ones_from_e ; 23:60A0
	ld a, e
	call SpriteCounter_B_DrawDigit1
.add_saved_a_to_slots ; 23:60A4
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld l, a
	ld a, [wSpriteSlot10]
	add a, l
	ld [wSpriteSlot10], a
	ld a, [wSpriteSlot9]
	add a, l
	ld [wSpriteSlot9], a
	ld a, [wSpriteSlot8]
	add a, l
	ld [wSpriteSlot8], a
	ld a, [wSpriteSlot7]
	add a, l
	ld [wSpriteSlot7], a
	ld a, [wSpriteSlot6]
	add a, l
	ld [wSpriteSlot6], a
	pop hl
	ret

SpriteCounter_B_DrawDigit10000:: ; 23:60D1

	cp a, $00
	jr nz, .check_value_1
	ld hl, wSpriteSlot6
	ld de, Table_SpriteCounter_Digits
	ld a, BANK(Table_SpriteCounter_Digits)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, wSpriteSlot6
	call Sprite_SetPosition
	ret
.check_value_1 ; 23:60EF
	cp a, $01
	jr nz, .check_value_2
	ld hl, wSpriteSlot6
	ld de, Table_SpriteCounter_Digits_Entry4
	ld a, BANK(Table_SpriteCounter_Digits_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, wSpriteSlot6
	call Sprite_SetPosition
	ret
.check_value_2 ; 23:610D
	cp a, $02
	jr nz, .check_value_3
	ld hl, wSpriteSlot6
	ld de, Table_SpriteCounter_Digits_Entry8
	ld a, BANK(Table_SpriteCounter_Digits_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, wSpriteSlot6
	call Sprite_SetPosition
	ret
.check_value_3 ; 23:612B
	cp a, $03
	jr nz, .check_value_4
	ld hl, wSpriteSlot6
	ld de, Table_SpriteCounter_Digits_Entry12
	ld a, BANK(Table_SpriteCounter_Digits_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, wSpriteSlot6
	call Sprite_SetPosition
	ret
.check_value_4 ; 23:6149
	cp a, $04
	jr nz, .check_value_5
	ld hl, wSpriteSlot6
	ld de, Table_SpriteCounter_Digits_Entry16
	ld a, BANK(Table_SpriteCounter_Digits_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, wSpriteSlot6
	call Sprite_SetPosition
	ret
.check_value_5 ; 23:6167
	cp a, $05
	jr nz, .check_value_6
	ld hl, wSpriteSlot6
	ld de, Table_SpriteCounter_Digits_Entry20
	ld a, BANK(Table_SpriteCounter_Digits_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, wSpriteSlot6
	call Sprite_SetPosition
	ret
.check_value_6 ; 23:6185
	cp a, $06
	jr nz, .check_value_7
	ld hl, wSpriteSlot6
	ld de, Table_SpriteCounter_Digits_Entry24
	ld a, BANK(Table_SpriteCounter_Digits_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, wSpriteSlot6
	call Sprite_SetPosition
	ret
.check_value_7 ; 23:61A3
	cp a, $07
	jr nz, .check_value_8
	ld hl, wSpriteSlot6
	ld de, Table_SpriteCounter_Digits_Entry28
	ld a, BANK(Table_SpriteCounter_Digits_Entry28)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, wSpriteSlot6
	call Sprite_SetPosition
	ret
.check_value_8 ; 23:61C1
	cp a, $08
	jr nz, .use_default_entry
	ld hl, wSpriteSlot6
	ld de, Table_SpriteCounter_Digits_Entry32
	ld a, BANK(Table_SpriteCounter_Digits_Entry32)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, wSpriteSlot6
	call Sprite_SetPosition
	ret
.use_default_entry ; 23:61DF
	ld hl, wSpriteSlot6
	ld de, Table_SpriteCounter_Digits_Entry36
	ld a, BANK(Table_SpriteCounter_Digits_Entry36)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $642F
	ld hl, wSpriteSlot6
	call Sprite_SetPosition
	ret

SpriteCounter_B_DrawDigit1000:: ; 23:61F9

	cp a, $00
	jr nz, .check_value_1
	ld hl, wSpriteSlot7
	ld de, Table_SpriteCounter_Digits
	ld a, BANK(Table_SpriteCounter_Digits)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, wSpriteSlot7
	call Sprite_SetPosition
	ret
.check_value_1 ; 23:6217
	cp a, $01
	jr nz, .check_value_2
	ld hl, wSpriteSlot7
	ld de, Table_SpriteCounter_Digits_Entry4
	ld a, BANK(Table_SpriteCounter_Digits_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, wSpriteSlot7
	call Sprite_SetPosition
	ret
.check_value_2 ; 23:6235
	cp a, $02
	jr nz, .check_value_3
	ld hl, wSpriteSlot7
	ld de, Table_SpriteCounter_Digits_Entry8
	ld a, BANK(Table_SpriteCounter_Digits_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, wSpriteSlot7
	call Sprite_SetPosition
	ret
.check_value_3 ; 23:6253
	cp a, $03
	jr nz, .check_value_4
	ld hl, wSpriteSlot7
	ld de, Table_SpriteCounter_Digits_Entry12
	ld a, BANK(Table_SpriteCounter_Digits_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, wSpriteSlot7
	call Sprite_SetPosition
	ret
.check_value_4 ; 23:6271
	cp a, $04
	jr nz, .check_value_5
	ld hl, wSpriteSlot7
	ld de, Table_SpriteCounter_Digits_Entry16
	ld a, BANK(Table_SpriteCounter_Digits_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, wSpriteSlot7
	call Sprite_SetPosition
	ret
.check_value_5 ; 23:628F
	cp a, $05
	jr nz, .check_value_6
	ld hl, wSpriteSlot7
	ld de, Table_SpriteCounter_Digits_Entry20
	ld a, BANK(Table_SpriteCounter_Digits_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, wSpriteSlot7
	call Sprite_SetPosition
	ret
.check_value_6 ; 23:62AD
	cp a, $06
	jr nz, .check_value_7
	ld hl, wSpriteSlot7
	ld de, Table_SpriteCounter_Digits_Entry24
	ld a, BANK(Table_SpriteCounter_Digits_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, wSpriteSlot7
	call Sprite_SetPosition
	ret
.check_value_7 ; 23:62CB
	cp a, $07
	jr nz, .check_value_8
	ld hl, wSpriteSlot7
	ld de, Table_SpriteCounter_Digits_Entry28
	ld a, BANK(Table_SpriteCounter_Digits_Entry28)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, wSpriteSlot7
	call Sprite_SetPosition
	ret
.check_value_8 ; 23:62E9
	cp a, $08
	jr nz, .use_default_entry
	ld hl, wSpriteSlot7
	ld de, Table_SpriteCounter_Digits_Entry32
	ld a, BANK(Table_SpriteCounter_Digits_Entry32)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, wSpriteSlot7
	call Sprite_SetPosition
	ret
.use_default_entry ; 23:6307
	ld hl, wSpriteSlot7
	ld de, Table_SpriteCounter_Digits_Entry36
	ld a, BANK(Table_SpriteCounter_Digits_Entry36)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6435
	ld hl, wSpriteSlot7
	call Sprite_SetPosition
	ret

SpriteCounter_B_DrawDigit100:: ; 23:6321

	cp a, $00
	jr nz, .check_value_1
	ld hl, wSpriteSlot8
	ld de, Table_SpriteCounter_Digits
	ld a, BANK(Table_SpriteCounter_Digits)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	ret
.check_value_1 ; 23:633F
	cp a, $01
	jr nz, .check_value_2
	ld hl, wSpriteSlot8
	ld de, Table_SpriteCounter_Digits_Entry4
	ld a, BANK(Table_SpriteCounter_Digits_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	ret
.check_value_2 ; 23:635D
	cp a, $02
	jr nz, .check_value_3
	ld hl, wSpriteSlot8
	ld de, Table_SpriteCounter_Digits_Entry8
	ld a, BANK(Table_SpriteCounter_Digits_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	ret
.check_value_3 ; 23:637B
	cp a, $03
	jr nz, .check_value_4
	ld hl, wSpriteSlot8
	ld de, Table_SpriteCounter_Digits_Entry12
	ld a, BANK(Table_SpriteCounter_Digits_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	ret
.check_value_4 ; 23:6399
	cp a, $04
	jr nz, .check_value_5
	ld hl, wSpriteSlot8
	ld de, Table_SpriteCounter_Digits_Entry16
	ld a, BANK(Table_SpriteCounter_Digits_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	ret
.check_value_5 ; 23:63B7
	cp a, $05
	jr nz, .check_value_6
	ld hl, wSpriteSlot8
	ld de, Table_SpriteCounter_Digits_Entry20
	ld a, BANK(Table_SpriteCounter_Digits_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	ret
.check_value_6 ; 23:63D5
	cp a, $06
	jr nz, .check_value_7
	ld hl, wSpriteSlot8
	ld de, Table_SpriteCounter_Digits_Entry24
	ld a, BANK(Table_SpriteCounter_Digits_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	ret
.check_value_7 ; 23:63F3
	cp a, $07
	jr nz, .check_value_8
	ld hl, wSpriteSlot8
	ld de, Table_SpriteCounter_Digits_Entry28
	ld a, BANK(Table_SpriteCounter_Digits_Entry28)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	ret
.check_value_8 ; 23:6411
	cp a, $08
	jr nz, .use_default_entry
	ld hl, wSpriteSlot8
	ld de, Table_SpriteCounter_Digits_Entry32
	ld a, BANK(Table_SpriteCounter_Digits_Entry32)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	ret
.use_default_entry ; 23:642F
	ld hl, wSpriteSlot8
	ld de, Table_SpriteCounter_Digits_Entry36
	ld a, BANK(Table_SpriteCounter_Digits_Entry36)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $643B
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	ret

SpriteCounter_B_DrawDigit10:: ; 23:6449

	cp a, $00
	jr nz, .check_value_1
	ld hl, wSpriteSlot9
	ld de, Table_SpriteCounter_Digits
	ld a, BANK(Table_SpriteCounter_Digits)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, wSpriteSlot9
	call Sprite_SetPosition
	ret
.check_value_1 ; 23:6467
	cp a, $01
	jr nz, .check_value_2
	ld hl, wSpriteSlot9
	ld de, Table_SpriteCounter_Digits_Entry4
	ld a, BANK(Table_SpriteCounter_Digits_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, wSpriteSlot9
	call Sprite_SetPosition
	ret
.check_value_2 ; 23:6485
	cp a, $02
	jr nz, .check_value_3
	ld hl, wSpriteSlot9
	ld de, Table_SpriteCounter_Digits_Entry8
	ld a, BANK(Table_SpriteCounter_Digits_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, wSpriteSlot9
	call Sprite_SetPosition
	ret
.check_value_3 ; 23:64A3
	cp a, $03
	jr nz, .check_value_4
	ld hl, wSpriteSlot9
	ld de, Table_SpriteCounter_Digits_Entry12
	ld a, BANK(Table_SpriteCounter_Digits_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, wSpriteSlot9
	call Sprite_SetPosition
	ret
.check_value_4 ; 23:64C1
	cp a, $04
	jr nz, .check_value_5
	ld hl, wSpriteSlot9
	ld de, Table_SpriteCounter_Digits_Entry16
	ld a, BANK(Table_SpriteCounter_Digits_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, wSpriteSlot9
	call Sprite_SetPosition
	ret
.check_value_5 ; 23:64DF
	cp a, $05
	jr nz, .check_value_6
	ld hl, wSpriteSlot9
	ld de, Table_SpriteCounter_Digits_Entry20
	ld a, BANK(Table_SpriteCounter_Digits_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, wSpriteSlot9
	call Sprite_SetPosition
	ret
.check_value_6 ; 23:64FD
	cp a, $06
	jr nz, .check_value_7
	ld hl, wSpriteSlot9
	ld de, Table_SpriteCounter_Digits_Entry24
	ld a, BANK(Table_SpriteCounter_Digits_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, wSpriteSlot9
	call Sprite_SetPosition
	ret
.check_value_7 ; 23:651B
	cp a, $07
	jr nz, .check_value_8
	ld hl, wSpriteSlot9
	ld de, Table_SpriteCounter_Digits_Entry28
	ld a, BANK(Table_SpriteCounter_Digits_Entry28)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, wSpriteSlot9
	call Sprite_SetPosition
	ret
.check_value_8 ; 23:6539
	cp a, $08
	jr nz, .use_default_entry
	ld hl, wSpriteSlot9
	ld de, Table_SpriteCounter_Digits_Entry32
	ld a, BANK(Table_SpriteCounter_Digits_Entry32)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, wSpriteSlot9
	call Sprite_SetPosition
	ret
.use_default_entry ; 23:6557
	ld hl, wSpriteSlot9
	ld de, Table_SpriteCounter_Digits_Entry36
	ld a, BANK(Table_SpriteCounter_Digits_Entry36)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6441
	ld hl, wSpriteSlot9
	call Sprite_SetPosition
	ret

SpriteCounter_B_DrawDigit1:: ; 23:6571

	cp a, $00
	jr nz, .check_value_1
	ld hl, wSpriteSlot10
	ld de, Table_SpriteCounter_Digits
	ld a, BANK(Table_SpriteCounter_Digits)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, wSpriteSlot10
	call Sprite_SetPosition
	ret
.check_value_1 ; 23:658F
	cp a, $01
	jr nz, .check_value_2
	ld hl, wSpriteSlot10
	ld de, Table_SpriteCounter_Digits_Entry4
	ld a, BANK(Table_SpriteCounter_Digits_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, wSpriteSlot10
	call Sprite_SetPosition
	ret
.check_value_2 ; 23:65AD
	cp a, $02
	jr nz, .check_value_3
	ld hl, wSpriteSlot10
	ld de, Table_SpriteCounter_Digits_Entry8
	ld a, BANK(Table_SpriteCounter_Digits_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, wSpriteSlot10
	call Sprite_SetPosition
	ret
.check_value_3 ; 23:65CB
	cp a, $03
	jr nz, .check_value_4
	ld hl, wSpriteSlot10
	ld de, Table_SpriteCounter_Digits_Entry12
	ld a, BANK(Table_SpriteCounter_Digits_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, wSpriteSlot10
	call Sprite_SetPosition
	ret
.check_value_4 ; 23:65E9
	cp a, $04
	jr nz, .check_value_5
	ld hl, wSpriteSlot10
	ld de, Table_SpriteCounter_Digits_Entry16
	ld a, BANK(Table_SpriteCounter_Digits_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, wSpriteSlot10
	call Sprite_SetPosition
	ret
.check_value_5 ; 23:6607
	cp a, $05
	jr nz, .check_value_6
	ld hl, wSpriteSlot10
	ld de, Table_SpriteCounter_Digits_Entry20
	ld a, BANK(Table_SpriteCounter_Digits_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, wSpriteSlot10
	call Sprite_SetPosition
	ret
.check_value_6 ; 23:6625
	cp a, $06
	jr nz, .check_value_7
	ld hl, wSpriteSlot10
	ld de, Table_SpriteCounter_Digits_Entry24
	ld a, BANK(Table_SpriteCounter_Digits_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, wSpriteSlot10
	call Sprite_SetPosition
	ret
.check_value_7 ; 23:6643
	cp a, $07
	jr nz, .check_value_8
	ld hl, wSpriteSlot10
	ld de, Table_SpriteCounter_Digits_Entry28
	ld a, BANK(Table_SpriteCounter_Digits_Entry28)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, wSpriteSlot10
	call Sprite_SetPosition
	ret
.check_value_8 ; 23:6661
	cp a, $08
	jr nz, .use_default_entry
	ld hl, wSpriteSlot10
	ld de, Table_SpriteCounter_Digits_Entry32
	ld a, BANK(Table_SpriteCounter_Digits_Entry32)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, wSpriteSlot10
	call Sprite_SetPosition
	ret
.use_default_entry ; 23:667F
	ld hl, wSpriteSlot10
	ld de, Table_SpriteCounter_Digits_Entry36
	ld a, BANK(Table_SpriteCounter_Digits_Entry36)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6447
	ld hl, wSpriteSlot10
	call Sprite_SetPosition
	ret

SpriteCounter_StubC:: ; 23:6699
	; [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 5FD7-669A by apply_coverage
	; --split [executed in 7 scenarios]
	ret

SpriteCounter_C_DrawNumber:: ; 23:669A

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
	jp z, .divide_by_1000
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
	jp .add_saved_a_to_slots
.divide_by_1000 ; 23:66E4
	ld l, e
	ld h, d
	ld de, $03E8
	farcall Divide16
	ld a, h
	or a, l
	jp z, .divide_by_100
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
	jp .add_saved_a_to_slots
.divide_by_100 ; 23:671F
	ld l, e
	ld h, d
	ld de, $0064
	farcall Divide16
	ld a, h
	or a, l
	jp z, .divide_by_10
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
	jp .add_saved_a_to_slots
.divide_by_10 ; 23:674B
	ld l, e
	ld h, d
	ld de, $000A
	farcall Divide16
	ld a, h
	or a, l
	jp z, .draw_ones_from_e
	ld a, l
	push de
	call SpriteCounter_C_DrawDigit10
	pop hl
	ld a, l
	call SpriteCounter_C_DrawDigit1
	jp .add_saved_a_to_slots
.draw_ones_from_e ; 23:6768
	ld a, e
	call SpriteCounter_C_DrawDigit1
.add_saved_a_to_slots ; 23:676C
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld l, a
	ld a, [wSpriteSlot5]
	add a, l
	ld [wSpriteSlot5], a
	ld a, [wSpriteSlot4]
	add a, l
	ld [wSpriteSlot4], a
	ld a, [wSpriteSlot3]
	add a, l
	ld [wSpriteSlot3], a
	ld a, [wSpriteSlot2]
	add a, l
	ld [wSpriteSlot2], a
	ld a, [wSpriteSlot1]
	add a, l
	ld [wSpriteSlot1], a
	pop hl
	ret

SpriteCounter_C_DrawDigit10000:: ; 23:6799

	cp a, $00
	jr nz, .check_value_1
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits
	ld a, BANK(Table_SpriteCounter_Digits)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret
.check_value_1 ; 23:67B7
	cp a, $01
	jr nz, .check_value_2
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits_Entry4
	ld a, BANK(Table_SpriteCounter_Digits_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret
.check_value_2 ; 23:67D5
	cp a, $02
	jr nz, .check_value_3
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits_Entry8
	ld a, BANK(Table_SpriteCounter_Digits_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret
.check_value_3 ; 23:67F3
	cp a, $03
	jr nz, .check_value_4
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits_Entry12
	ld a, BANK(Table_SpriteCounter_Digits_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret
.check_value_4 ; 23:6811
	cp a, $04
	jr nz, .check_value_5
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits_Entry16
	ld a, BANK(Table_SpriteCounter_Digits_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret
.check_value_5 ; 23:682F
	cp a, $05
	jr nz, .check_value_6
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits_Entry20
	ld a, BANK(Table_SpriteCounter_Digits_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret
.check_value_6 ; 23:684D
	cp a, $06
	jr nz, .check_value_7
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits_Entry24
	ld a, BANK(Table_SpriteCounter_Digits_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret
.check_value_7 ; 23:686B
	cp a, $07
	jr nz, .check_value_8
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits_Entry28
	ld a, BANK(Table_SpriteCounter_Digits_Entry28)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret
.check_value_8 ; 23:6889
	cp a, $08
	jr nz, .use_default_entry
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits_Entry32
	ld a, BANK(Table_SpriteCounter_Digits_Entry32)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret
.use_default_entry ; 23:68A7
	ld hl, wSpriteSlot1
	ld de, Table_SpriteCounter_Digits_Entry36
	ld a, BANK(Table_SpriteCounter_Digits_Entry36)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A2F
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret

SpriteCounter_C_DrawDigit1000:: ; 23:68C1

	cp a, $00
	jr nz, .check_value_1
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits
	ld a, BANK(Table_SpriteCounter_Digits)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret
.check_value_1 ; 23:68DF
	cp a, $01
	jr nz, .check_value_2
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits_Entry4
	ld a, BANK(Table_SpriteCounter_Digits_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret
.check_value_2 ; 23:68FD
	cp a, $02
	jr nz, .check_value_3
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits_Entry8
	ld a, BANK(Table_SpriteCounter_Digits_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret
.check_value_3 ; 23:691B
	cp a, $03
	jr nz, .check_value_4
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits_Entry12
	ld a, BANK(Table_SpriteCounter_Digits_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret
.check_value_4 ; 23:6939
	cp a, $04
	jr nz, .check_value_5
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits_Entry16
	ld a, BANK(Table_SpriteCounter_Digits_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret
.check_value_5 ; 23:6957
	cp a, $05
	jr nz, .check_value_6
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits_Entry20
	ld a, BANK(Table_SpriteCounter_Digits_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret
.check_value_6 ; 23:6975
	cp a, $06
	jr nz, .check_value_7
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits_Entry24
	ld a, BANK(Table_SpriteCounter_Digits_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret
.check_value_7 ; 23:6993
	cp a, $07
	jr nz, .check_value_8
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits_Entry28
	ld a, BANK(Table_SpriteCounter_Digits_Entry28)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret
.check_value_8 ; 23:69B1
	cp a, $08
	jr nz, .use_default_entry
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits_Entry32
	ld a, BANK(Table_SpriteCounter_Digits_Entry32)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret
.use_default_entry ; 23:69CF
	ld hl, wSpriteSlot2
	ld de, Table_SpriteCounter_Digits_Entry36
	ld a, BANK(Table_SpriteCounter_Digits_Entry36)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A35
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ret

SpriteCounter_C_DrawDigit100:: ; 23:69E9

	cp a, $00
	jr nz, .check_value_1
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits
	ld a, BANK(Table_SpriteCounter_Digits)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret
.check_value_1 ; 23:6A07
	cp a, $01
	jr nz, .check_value_2
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits_Entry4
	ld a, BANK(Table_SpriteCounter_Digits_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret
.check_value_2 ; 23:6A25
	cp a, $02
	jr nz, .check_value_3
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits_Entry8
	ld a, BANK(Table_SpriteCounter_Digits_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret
.check_value_3 ; 23:6A43
	cp a, $03
	jr nz, .check_value_4
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits_Entry12
	ld a, BANK(Table_SpriteCounter_Digits_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret
.check_value_4 ; 23:6A61
	cp a, $04
	jr nz, .check_value_5
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits_Entry16
	ld a, BANK(Table_SpriteCounter_Digits_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret
.check_value_5 ; 23:6A7F
	cp a, $05
	jr nz, .check_value_6
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits_Entry20
	ld a, BANK(Table_SpriteCounter_Digits_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret
.check_value_6 ; 23:6A9D
	cp a, $06
	jr nz, .check_value_7
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits_Entry24
	ld a, BANK(Table_SpriteCounter_Digits_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret
.check_value_7 ; 23:6ABB
	cp a, $07
	jr nz, .check_value_8
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits_Entry28
	ld a, BANK(Table_SpriteCounter_Digits_Entry28)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret
.check_value_8 ; 23:6AD9
	cp a, $08
	jr nz, .use_default_entry
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits_Entry32
	ld a, BANK(Table_SpriteCounter_Digits_Entry32)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret
.use_default_entry ; 23:6AF7
	ld hl, wSpriteSlot3
	ld de, Table_SpriteCounter_Digits_Entry36
	ld a, BANK(Table_SpriteCounter_Digits_Entry36)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A3B
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ret

SpriteCounter_C_DrawDigit10:: ; 23:6B11

	cp a, $00
	jr nz, .check_value_1
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits
	ld a, BANK(Table_SpriteCounter_Digits)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.check_value_1 ; 23:6B2F
	cp a, $01
	jr nz, .check_value_2
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits_Entry4
	ld a, BANK(Table_SpriteCounter_Digits_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.check_value_2 ; 23:6B4D
	cp a, $02
	jr nz, .check_value_3
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits_Entry8
	ld a, BANK(Table_SpriteCounter_Digits_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.check_value_3 ; 23:6B6B
	cp a, $03
	jr nz, .check_value_4
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits_Entry12
	ld a, BANK(Table_SpriteCounter_Digits_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.check_value_4 ; 23:6B89
	cp a, $04
	jr nz, .check_value_5
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits_Entry16
	ld a, BANK(Table_SpriteCounter_Digits_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.check_value_5 ; 23:6BA7
	cp a, $05
	jr nz, .check_value_6
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits_Entry20
	ld a, BANK(Table_SpriteCounter_Digits_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.check_value_6 ; 23:6BC5
	cp a, $06
	jr nz, .check_value_7
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits_Entry24
	ld a, BANK(Table_SpriteCounter_Digits_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.check_value_7 ; 23:6BE3
	cp a, $07
	jr nz, .check_value_8
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits_Entry28
	ld a, BANK(Table_SpriteCounter_Digits_Entry28)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.check_value_8 ; 23:6C01
	cp a, $08
	jr nz, .use_default_entry
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits_Entry32
	ld a, BANK(Table_SpriteCounter_Digits_Entry32)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret
.use_default_entry ; 23:6C1F
	ld hl, wSpriteSlot4
	ld de, Table_SpriteCounter_Digits_Entry36
	ld a, BANK(Table_SpriteCounter_Digits_Entry36)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A41
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ret

SpriteCounter_C_DrawDigit1:: ; 23:6C39

	cp a, $00
	jr nz, .check_value_1
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits
	ld a, BANK(Table_SpriteCounter_Digits)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
.check_value_1 ; 23:6C57
	cp a, $01
	jr nz, .check_value_2
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits_Entry4
	ld a, BANK(Table_SpriteCounter_Digits_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
.check_value_2 ; 23:6C75
	cp a, $02
	jr nz, .check_value_3
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits_Entry8
	ld a, BANK(Table_SpriteCounter_Digits_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
.check_value_3 ; 23:6C93
	cp a, $03
	jr nz, .check_value_4
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits_Entry12
	ld a, BANK(Table_SpriteCounter_Digits_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
.check_value_4 ; 23:6CB1
	cp a, $04
	jr nz, .check_value_5
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits_Entry16
	ld a, BANK(Table_SpriteCounter_Digits_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
.check_value_5 ; 23:6CCF
	cp a, $05
	jr nz, .check_value_6
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits_Entry20
	ld a, BANK(Table_SpriteCounter_Digits_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
.check_value_6 ; 23:6CED
	cp a, $06
	jr nz, .check_value_7
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits_Entry24
	ld a, BANK(Table_SpriteCounter_Digits_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
.check_value_7 ; 23:6D0B
	cp a, $07
	jr nz, .check_value_8
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits_Entry28
	ld a, BANK(Table_SpriteCounter_Digits_Entry28)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
.check_value_8 ; 23:6D29
	cp a, $08
	jr nz, .use_default_entry
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits_Entry32
	ld a, BANK(Table_SpriteCounter_Digits_Entry32)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
.use_default_entry ; 23:6D47
	ld hl, wSpriteSlot5
	ld de, Table_SpriteCounter_Digits_Entry36
	ld a, BANK(Table_SpriteCounter_Digits_Entry36)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $5A47
	ld hl, wSpriteSlot5
	call Sprite_SetPosition
	ret
