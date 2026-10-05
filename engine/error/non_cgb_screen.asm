; engine/error/non_cgb_screen.asm
; bank 6B, $4C80-$4D20 (160 bytes); pinned by layout.link
; non-CGB error screen and BGP fade

SECTION "engine/error/non_cgb_screen", ROMX

NonCgb_ErrorScreen:: ; 6B:4C80
	; [CONFIRMED] 75 insn(s) reached by static flow only; seeds: exec x75; min discovery hops 1;
	; entered by call from 00:02A9 (PROBABLE code) [executed in 1 scenarios]
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4
	call FillBytes
	ld a, $14
	ld [wNonCgb_FadeTimer], a
	call LCDOff
	ldh a, [rLCDC]
	and a, $9F
	ldh [rLCDC], a
	xor a, a
	ldh [rSCX], a
	ldh [rSCY], a
	ld a, $07
	ldh [rWX], a
	ld a, $90
	ldh [rWY], a
	ld a, $00
	and a, $01
	ldh [hVRAMBank], a
	ldh [rVBK], a
	ld bc, $0800
	ld de, $8800
	ld hl, $4480
	call CopyBytes
	ld bc, $0240
	ld de, $9800
	ld hl, $4000
	call CopyBytes
	ld a, $00
	ldh [rBGP], a
	ld a, $81
	ldh [rLCDC], a
	di
	ldh a, [rIE]
	and a, $E1
	or a, $01
	ldh [rIE], a
	ld a, $C3
	ld [wVBlankVector], a
	ld a, $1F
	ld [wVBlankVector + 1], a
	ld a, $4D
	ld [wVBlankVector + 2], a
	ei
.l4CE6 ; 6B:4CE6
	halt
.l4CE7 ; 6B:4CE7
	ldh a, [rLY]
	cp a, $91
	jr nz, .l4CE7
	call NonCgb_FadeStep
	or a, a
	jr nz, .l4CE6
.l4CF3 ; 6B:4CF3
	halt
	jr .l4CF3

NonCgb_FadeStep:: ; 6B:4CF6
	ld hl, wNonCgb_FadeTimer
	dec [hl]
	ret nz
	ld [hl], $14
	ld a, [wNonCgb_FadeIndex]
	ld hl, NonCgb_BgpFadeTable
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hl]
	ldh [rBGP], a
	ld a, [wNonCgb_FadeIndex]
	inc a
	ld [wNonCgb_FadeIndex], a
	cp a, $04
	ld a, $00
	ret z
	ld a, $FF
	ret

; ---- data $4D1B-$4D1F (4 bytes) [PROBABLE] 4-byte BGP fade table 00 40 90 E4 read by the non-CGB screen routine 4CF6 (ld hl,$4D1B at 6B:4D00 ; add a,l ; ld a,[hl] ; ldh [rBGP],a ; index [C0E8] incremented and compared with 4, so entries 0-3 are used); the byte after it ($D9 at 4D1F) is executed as `reti`, see the next region [round 3: split from the former 5-byte data region 4D1B-4D20 read as `00 40 90 E4 D9`]

NonCgb_BgpFadeTable:: ; 6B:4D1B
Data_6B_4D1B::
	db $00, $40, $90, $E4

	; [CONFIRMED] 1 insn (`reti`, $D9) executed by scenario noncgb_boot (register A = $01 at start):
	; the target of the VBlank stub `jp $4D1F` that NonCgb_ErrorScreen installs (the byte also
	; follows the 4-entry BGP fade table); found by apply_coverage as an executed start outside
	; every code region [executed in 1 scenarios]
	reti
