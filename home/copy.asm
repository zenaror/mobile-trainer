; home/copy.asm
; bank 00, $04D8-$0540 (104 bytes); pinned by layout.link
; FillBytes/FillWords/CopyBytes/CopyBytesBackward

SECTION "home/copy", ROM0

FillBytes:: ; 00:04D8
	; [CONFIRMED] fill BC bytes at HL with A (BC=0 fills 256 bytes when B=0); used to clear
	; VRAM/WRAM/HRAM in Boot
	inc b
	dec b
	jr nz, .l04E1
.loop ; 00:04DC
	ld [hli], a
	dec c
	jr nz, .loop
	ret
.l04E1 ; 00:04E1
	inc c
	dec c
	jr z, .l04E6
	inc b
.l04E6 ; 00:04E6
	ld [hli], a
	dec c
	jr nz, .l04E6
	dec b
	jr nz, .l04E6
	ret

FillWords:: ; 00:04EE
	; [PROBABLE] fill BC bytes at HL with the repeating 16-bit pattern E,D (2 bytes per step, BC
	; counts bytes) [candidate; raw refs 16]
	inc b
	dec b
	jr nz, .l04FB
.loop ; 00:04F2
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	dec c
	dec c
	jr nz, .loop
	ret
.l04FB ; 00:04FB
	inc c
	dec c
	jr z, .l0500
	inc b
.l0500 ; 00:0500
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	dec c
	dec c
	jr nz, .l0500
	dec b
	jr nz, .l0500
	ret

CopyBytes:: ; 00:050C
	; [CONFIRMED] copy BC bytes from [HL++] to [DE++] (BC=0 with B=0 copies 256)
	inc b
	dec b
	jr nz, .l0517
.loop ; 00:0510
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret
.l0517 ; 00:0517
	inc c
	dec c
	jr z, .l051C
	inc b
.l051C ; 00:051C
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .l051C
	dec b
	jr nz, .l051C
	ret

CopyBytesBackward:: ; 00:0526
	; [CONFIRMED] copy BC bytes from [HL--] to [DE--] [reached via inferred links; raw refs 43] | 3
	; insn(s) executed; cut out of the PROBABLE region 0526-0540 by apply_coverage --split [executed
	; in 32 scenarios]
	inc b
	dec b
	jr nz, .l0531

.loop ; 00:052A
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 0526-0540 by apply_coverage --split
	ld a, [hld]
	ld [de], a
	dec de
	dec c
	jr nz, .loop
	ret

.l0531 ; 00:0531
	; [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 0526-0540 by apply_coverage
	; --split [executed in 32 scenarios]
	inc c
	dec c
	jr z, .l0536
	inc b
.l0536 ; 00:0536
	ld a, [hld]
	ld [de], a
	dec de
	dec c
	jr nz, .l0536
	dec b
	jr nz, .l0536
	ret
