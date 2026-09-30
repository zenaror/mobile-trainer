; home/sprites.asm
; bank 00, $0956-$0BD4 (638 bytes); pinned by layout.link
; 14-slot sprite-object engine, shadow OAM helpers, 0BBD map-offset to pixel helper

SECTION "home/sprites", ROM0

Sprite_UpdateAll:: ; 00:0956
Function_00_0956::
	; [CONFIRMED] sprite-object engine pass: sets C2F5=1 (no OAM DMA), clears shadow OAM C000-C09F
	; (0A09), walks the 14 slots at D:DA00 (16 bytes each, WRAM bank 7) writing OAM entries from
	; C004, C2F3=next OAM ptr, C2F5=0
	ld a, $01
	ld [wOAMDMASuppress], a
	call Sprite_ClearShadowOAM
	push af
	push bc
	push de
	push hl
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $C004
	ld hl, $DA00
	ld b, $0E
.loop ; 00:0977
	push bc
	push hl
	ld bc, $0003
	add hl, bc
	ld a, [hl]
	ld c, $0B
	add hl, bc
	ld b, a
	ld a, [hli]
	cp a, $FF
	jr z, .l098D
	or a, a
	jr z, .l098D
	call BankSwitch_B
.l098D ; 00:098D
	pop hl
	push hl
	call Sprite_StepAndDrawSlot
	pop hl
	ld bc, $0010
	add hl, bc
	pop bc
	dec b
	jr nz, .loop
	ld a, e
	ld [wShadowOAMNextOffset], a
	xor a, a
	ldh [hSpriteSlideOffsetX], a
	ldh [hSpriteSlideOffsetY], a
	xor a, a
	ld [wOAMDMASuppress], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	pop hl
	pop de
	pop bc
	pop af
	ret

Sprite_ResetAll:: ; 00:09B6
Function_00_09B6::
	; [CONFIRMED] sprite engine reset: clears C000-C09F, FFF0=FFF1=0 and fills the 14 slots
	; DA00-DADF with $FF
	call Sprite_ClearShadowOAM
	push af
	push bc
	push hl
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [hSpriteSlideOffsetX], a
	ldh [hSpriteSlideOffsetY], a
	ld hl, $DA00
	ld bc, $00E0
	ld a, $FF
	call FillBytes
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	pop hl
	pop bc
	pop af
	ret

Sprite_ClearSlot:: ; 00:09E6
Function_00_09E6::
	; [CONFIRMED] fill 16 bytes at HL (one sprite slot) with $FF in WRAM bank 7 [reached via
	; inferred links; raw refs 50] [executed in 31 scenarios]
	push af
	push bc
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0010
	ld a, $FF
	call FillBytes
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	pop bc
	pop af
	ret

Sprite_ClearShadowOAM:: ; 00:0A09
Function_00_0A09::
	; [CONFIRMED] clears the shadow OAM buffer C000-C09F (160 bytes)
	push af
	push bc
	push hl
	ld b, $A0
	ld hl, $C000
	xor a, a
.loop ; 00:0A12
	ld [hli], a
	dec b
	jr nz, .loop
	pop hl
	pop bc
	pop af
	ret

Sprite_HookAddSlideOffset:: ; 00:0A1A
Function_00_0A1A::
	; [CONFIRMED] adds FFF1 (lo) / FFF0 (hi) to the 16-bit word at [HL] [candidate; raw refs 28]
	; [executed in 18 scenarios]
	push bc
	ldh a, [hSpriteSlideOffsetY]
	ld c, a
	ld a, [hl]
	add a, c
	ld [hli], a
	ld c, a
	ldh a, [hSpriteSlideOffsetX]
	ld b, a
	ld a, [hl]
	add a, b
	ld [hld], a
	pop bc
	ret

Function_00_0A2A:: ; 00:0A2A
	; [PROBABLE] stores DE at [HL],[HL+1] in WRAM bank 7 (preserves A) [candidate; raw refs 4]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Sprite_SetHook:: ; 00:0A45
Function_00_0A45::
	; [CONFIRMED] stores E,D,A at [HL..HL+2] in WRAM bank 7 [reached via inferred links; raw refs
	; 28] [executed in 18 scenarios]
	ldh [hRam_FFB0], a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ldh a, [hRam_FFB0]
	ld [hli], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Sprite_SetPosition:: ; 00:0A65
Function_00_0A65::
	; [CONFIRMED] stores D,E (big-endian) at [HL],[HL+1] in WRAM bank 7; most referenced helper of
	; the sprite code (520 raw call sites)
	push af
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, d
	ld [hli], a
	ld a, e
	ld [hld], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	pop af
	ret

Sprite_InitSlot:: ; 00:0A82
Function_00_0A82::
	; [CONFIRMED] initialise sprite slot HL: zero 16 bytes, slot+0E=A(bank), then fill the fields
	; from the animation table at DE via 0AB8
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	push bc
	push hl
	ldh [hScratchA], a
	ldh [hROMBankLo], a
	ld [$2100], a
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0010
	xor a, a
	call FillBytes
	pop hl
	push hl
	ld bc, $000E
	add hl, bc
	ldh a, [hScratchA]
	ld [hli], a
	pop hl
	pop bc
	ld a, b
	call Sprite_LoadObjectEntry
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Sprite_LoadObjectEntry:: ; 00:0AB8
Function_00_0AB8::
	; [CONFIRMED] fills slot fields from the 4-byte table entry at DE+4*(A&$7F) (used by 0A82)
	inc hl
	inc hl
	push af
	and a, $7F
	add a, a
	add a, a
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	push hl
	inc hl
	inc hl
	ld a, [de]
	ld [hli], a
	ld c, a
	inc de
	ld a, [de]
	ld [hli], a
	ld b, a
	xor a, a
	ld [hli], a
	ld [hli], a
	dec a
	ld [hli], a
	inc bc
	pop hl
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
	ld bc, $0009
	add hl, bc
	pop af
	ld [hli], a
	ret

Sprite_StepAndDrawSlot:: ; 00:0AE8
Function_00_0AE8::
	; [CONFIRMED] per-slot animation step + OAM writer (layout inferred, HYPOTHESIS): slot [0]=Y
	; [1]=X [2..3]=frame table ptr [4]=frame index ($FF none) [5]=delay [6..7]=script ptr [8]=script
	; index [9..A]=OR/AND attr masks [B..D]=hook (addr16, bank; called via push-return trick to
	; 0B54) [F]=active. Emits (Y,X,tile,attr) tuples at DE (OAM shadow)
	push de
	push hl
	ld de, $000F
	add hl, de
	ld a, [hl]
	cp a, $FF
	jr z, .l0B36
	or a, a
	jr z, .l0B36
	ld de, $FFF6
	add hl, de
	ld a, [hl]
	or a, a
	jr z, .l0B02
	dec a
	ld [hl], a
	jr nz, .l0B36
.l0B02 ; 00:0B02
	inc hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	or a, e
	jr z, .l0B36
	ld a, [de]
	ld b, a
	inc de
	push hl
	ld a, [hl]
	inc a
	cp a, b
	jr c, .l0B23
	xor a, a
	ld bc, $0007
	add hl, bc
	bit 7, [hl]
	jr nz, .l0B23
	ld [hli], a
	pop hl
	ld [hld], a
	ld [hld], a
	ld [hld], a
	jr .l0B36
.l0B23 ; 00:0B23
	pop hl
	ld [hl], a
	ld l, a
	ld h, $00
	add hl, hl
	add hl, de
	ld a, [hli]
	ld c, a
	ld a, [hli]
	pop hl
	push hl
	ld de, $0005
	add hl, de
	ld [hld], a
	ld a, c
	ld [hld], a
.l0B36 ; 00:0B36
	pop hl
	push hl
	ld de, $000B
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	cp a, $FF
	jr z, .l0B71
	call BankSwitch_D
	or a, e
	or a, d
	jr z, .l0B71
	pop hl
	push hl
	ld bc, $0B54
	push bc
	push de
	ret

	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop hl
	push hl
	ld de, $0003
	add hl, de
	ld a, [hl]
	ld de, $000B
	add hl, de
	ld d, a
	ld a, [hli]
	cp a, $FF
	jr z, .l0B71
	or a, a
	jr z, .l0B71
	call BankSwitch_D
.l0B71 ; 00:0B71
	pop hl
	pop de
	push de
	push hl
	ld de, $0009
	add hl, de
	ld a, [hli]
	ldh [hRam_FFB0], a
	ld a, [hli]
	ldh [hRam_FFB1], a
	pop hl
	ld a, [hli]
	add a, $10
	ld c, a
	ld a, [hli]
	add a, $08
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	cp a, $FF
	jr z, .l0BBB
	ld l, a
	ld h, $00
	add hl, hl
	add hl, de
	pop de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	or a, a
	ret z
.loop ; 00:0B9D
	push af
	ld a, [hli]
	add a, c
	ld [de], a
	inc de
	ld a, [hli]
	add a, b
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	push bc
	ldh a, [hRam_FFB0]
	ld b, a
	ldh a, [hRam_FFB1]
	ld c, a
	ld a, [hli]
	and a, c
	or a, b
	ld [de], a
	pop bc
	inc de
	pop af
	dec a
	jr nz, .loop
	ret
.l0BBB ; 00:0BBB
	pop de
	ret

Tilemap_OffsetToPixelXY:: ; 00:0BBD
Function_00_0BBD::
	; [PROBABLE] HL = BG map offset -> C = (L&31)*8 (x pixel), B = ((HL>>5)&31)*8 (y pixel);
	; verified on interpreter [candidate; raw refs 5]
	ld a, l
	and a, $1F
	rla
	rla
	rla
	ld c, a
	ld a, l
	and a, $E0
	rra
	rra
	ld b, a
	ld a, h
	and a, $03
	swap a
	rla
	rla
	or a, b
	ld b, a
	ret
