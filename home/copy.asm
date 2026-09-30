; home/copy.asm
; bank 00, $04D8-$0540 (104 bytes); pinned by layout.link
; FillBytes/FillWords/CopyBytes/CopyBytesBackward

SECTION "home/copy", ROM0

; ---- code $04D8-$04EE (22 bytes) [CONFIRMED] fill BC bytes at HL with A (BC=0 fills 256 bytes when B=0); used to clear VRAM/WRAM/HRAM in Boot

FillBytes:: ; 00:04D8
	inc b
	dec b
	jr nz, Label_00_04E1

Label_00_04DC:: ; 00:04DC
	ld [hli], a
	dec c
	jr nz, Label_00_04DC
	ret

Label_00_04E1:: ; 00:04E1
	inc c
	dec c
	jr z, Label_00_04E6
	inc b

Label_00_04E6:: ; 00:04E6
	ld [hli], a
	dec c
	jr nz, Label_00_04E6
	dec b
	jr nz, Label_00_04E6
	ret

; ---- code $04EE-$050C (30 bytes) [PROBABLE] fill BC bytes at HL with the repeating 16-bit pattern E,D (2 bytes per step, BC counts bytes) [candidate; raw refs 16]

FillWords:: ; 00:04EE
	inc b
	dec b
	jr nz, Label_00_04FB

Label_00_04F2:: ; 00:04F2
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	dec c
	dec c
	jr nz, Label_00_04F2
	ret

Label_00_04FB:: ; 00:04FB
	inc c
	dec c
	jr z, Label_00_0500
	inc b

Label_00_0500:: ; 00:0500
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	dec c
	dec c
	jr nz, Label_00_0500
	dec b
	jr nz, Label_00_0500
	ret

; ---- code $050C-$0526 (26 bytes) [CONFIRMED] copy BC bytes from [HL++] to [DE++] (BC=0 with B=0 copies 256)

CopyBytes:: ; 00:050C
	inc b
	dec b
	jr nz, Label_00_0517

Label_00_0510:: ; 00:0510
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Label_00_0510
	ret

Label_00_0517:: ; 00:0517
	inc c
	dec c
	jr z, Label_00_051C
	inc b

Label_00_051C:: ; 00:051C
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Label_00_051C
	dec b
	jr nz, Label_00_051C
	ret

; ---- code $0526-$052A (4 bytes) [CONFIRMED] copy BC bytes from [HL--] to [DE--] [reached via inferred links; raw refs 43] | 3 insn(s) executed; cut out of the PROBABLE region 0526-0540 by apply_coverage --split [executed in 32 scenarios]

CopyBytesBackward:: ; 00:0526
	inc b
	dec b
	jr nz, Label_00_0531

; ---- code $052A-$0531 (7 bytes) [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region 0526-0540 by apply_coverage --split

Label_00_052A:: ; 00:052A
	ld a, [hld]
	ld [de], a
	dec de
	dec c
	jr nz, Label_00_052A
	ret

; ---- code $0531-$0540 (15 bytes) [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 0526-0540 by apply_coverage --split [executed in 32 scenarios]

Label_00_0531:: ; 00:0531
	inc c
	dec c
	jr z, Label_00_0536
	inc b

Label_00_0536:: ; 00:0536
	ld a, [hld]
	ld [de], a
	dec de
	dec c
	jr nz, Label_00_0536
	dec b
	jr nz, Label_00_0536
	ret
