; home/tilemap_copy.asm
; bank 00, $16A2-$16C4 (34 bytes); pinned by layout.link
; tilemap rectangle pair copy variant (second source from C10E)

SECTION "home/tilemap_copy", ROM0

Function_00_16A2:: ; 00:16A2
	; [CONFIRMED] like 08CA but the second source pointer comes from C10E/C10F [reached via inferred
	; links; raw refs 3] [executed in 27 scenarios]
	call BankSwitch_H
	ld a, $07
	call BankSwitch_D
	ld a, c
	ldh [hRam_FFB0], a
	push bc
	push de
	call Function_00_0904
	pop de
	pop bc
	ld a, [wRam_C10E]
	ld l, a
	ld a, [wRam_C10F]
	ld h, a
	ld a, d
	add a, $04
	ld d, a
	call Function_00_0904
	ret
