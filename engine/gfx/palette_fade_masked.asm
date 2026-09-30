; engine/gfx/palette_fade_masked.asm
; bank 48, $44E0-$4616 (310 bytes); pinned by layout.link
; masked palette fades (only used by bank 6C)

SECTION "engine/gfx/palette_fade_masked", ROMX

; ---- code $44E0-$4615 (309 bytes) [CONFIRMED] 481 insn(s); 481 executed (in up to 12/18 scenarios) (part of region $4222-$4615)

Palette_FadeInMasked:: ; 48:44E0
	ldh [hRam_FFB0], a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0080
	ld de, $D880
	ld hl, $D800
	call CopyBytes
	ld bc, $0080
	ld de, $D900
	ld hl, $D800
	call CopyBytes
	ld a, $00
	ld [wPalFadeMode], a
	ld bc, $7FFF
	ld a, $E0
	call Palette_SetFadeTargetMasked
	farcall PalFade_Step
	call LCDOn

Label_48_451D:: ; 48:451D
	call Function_00_047A
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Function_00_0392
	farcall PalFade_Step
	or a, a
	jr nz, Label_48_451D
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Palette_FadeOutMasked:: ; 48:4540
	ldh [hRam_FFB0], a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0080
	ld de, $D880
	ld hl, $D800
	call CopyBytes
	ld bc, $0080
	ld de, $D900
	ld hl, $D800
	call CopyBytes
	ld a, $01
	ld [wPalFadeMode], a
	ld bc, $7FFF
	ld a, $20
	call Palette_SetFadeTargetMasked
	farcall PalFade_Step

Label_48_457A:: ; 48:457A
	call Function_00_047A
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Function_00_0392
	farcall PalFade_Step
	or a, a
	jr nz, Label_48_457A
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Palette_SetFadeTargetMasked:: ; 48:459D
	ld [wPalFadeStep], a
	bit 7, a
	jr nz, Label_48_45B5
	ld a, c
	ld [wTextCellsLeft], a
	ld a, b
	ld [wRam_C2EF], a
	xor a, a
	ld [wPalFadeProgress], a
	ld [wPalFadeProgress + 1], a
	jr Label_48_45C5

Label_48_45B5:: ; 48:45B5
	ld a, c
	ld [wTextCellsLeft], a
	ld a, b
	ld [wRam_C2EF], a
	xor a, a
	ld [wPalFadeProgress], a
	inc a
	ld [wPalFadeProgress + 1], a

Label_48_45C5:: ; 48:45C5
	ld de, $D980
	ld hl, $D900
	ld b, $40
	ld c, $04
	ld a, $01
	ldh [hRam_FFB1], a

Label_48_45D3:: ; 48:45D3
	push hl
	ldh a, [hRam_FFB0]
	ld hl, $FFB1
	and a, [hl]
	pop hl
	jr nz, Label_48_45F4
	inc hl
	inc hl
	xor a, a
	ld [de], a
	inc de
	ld [de], a
	inc de
	dec c
	jr nz, Label_48_45F0
	push hl
	ld c, $04
	ld hl, $FFB1
	sla [hl]
	pop hl

Label_48_45F0:: ; 48:45F0
	dec b
	jr nz, Label_48_45D3
	ret

Label_48_45F4:: ; 48:45F4
	ld a, [wTextCellsLeft]
	ld [hli], a
	ld a, [wRam_C2EF]
	ld [hli], a
	ld a, [wPalFadeProgress]
	ld [de], a
	inc de
	ld a, [wPalFadeProgress + 1]
	ld [de], a
	inc de
	dec c
	jr nz, Label_48_4612
	push hl
	ld c, $04
	ld hl, $FFB1
	sla [hl]
	pop hl

Label_48_4612:: ; 48:4612
	dec b
	jr nz, Label_48_45D3

; ---- code $4615-$4616 (1 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 48:4613 (executed)
	ret
