; engine/startup/boot_stage2.asm
; bank 4F, $4717-$47FD (230 bytes); pinned by layout.link
; Boot_ClearAndInit, Boot_ReinitRuntime

SECTION "engine/startup/boot_stage2", ROMX

Boot_ClearAndInit:: ; 4F:4717
Function_4F_4717::
	; [CONFIRMED] 108 insn(s); 108 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
	di
	nop
	xor a, a
	ldh [rSCY], a
	ldh [rSCX], a
	ld a, $90
	ldh [rWY], a
	ld a, $A7
	ldh [rWX], a
	ld a, $E4
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a
	ld hl, $C000
	ld bc, $0AF0
	xor a, a
	call FillBytes
	ld hl, $FFA4
	ld bc, $005A
	xor a, a
	call FillBytes
	ld a, $01
	ldh [rVBK], a
	ld hl, $8000
	ld bc, $2000
	xor a, a
	call FillBytes
	ld d, $06
	ld e, $02
.loop ; 4F:4754
	ld a, e
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $1000
	xor a, a
	call FillBytes
	inc e
	dec d
	jr nz, .loop
	xor a, a
	ldh [rSVBK], a
	ldh [rVBK], a
	ld hl, $8000
	ld bc, $2000
	xor a, a
	call FillBytes
	ld a, $77
	ldh [rNR50], a
	ld a, $FF
	ldh [rNR51], a
	ld a, $80
	ldh [rNR52], a
	call Function_00_0684
	call Function_00_04A0
	call Function_00_059F
	xor a, a
	ld [wOAMDMASuppress], a
	farcall Joypad_Init
	call Function_00_0331
	ld a, $83
	ldh [rLCDC], a
	xor a, a
	ldh [rIF], a
	ld a, $01
	ldh [rIE], a
	ei
	halt
	nop
	ret

Boot_ReinitRuntime:: ; 4F:47A5
	ld a, $83
	ldh [rLCDC], a
	call Function_00_0331
	call Function_00_0392
	ld hl, $FFA4
	ld bc, $005A
	xor a, a
	call FillBytes
	ld hl, $C000
	ld bc, $0AF0
	xor a, a
	call FillBytes
	call Function_00_0392
	di
	nop
	call Function_00_0684
	call Function_00_04A0
	call Function_00_059F
	xor a, a
	ldh [rIF], a
	ld a, $01
	ldh [rIE], a
	ei
	nop
	ld d, $06
	ld e, $02
.loop ; 4F:47DE
	ld a, e
	ldh [rSVBK], a
	xor a, a
	ld hl, $D000
	ld bc, $1000
	call FillBytes
	call Function_00_0392
	inc e
	dec d
	jr nz, .loop
	xor a, a
	ld [wOAMDMASuppress], a
	farcall Joypad_Init
	ret
