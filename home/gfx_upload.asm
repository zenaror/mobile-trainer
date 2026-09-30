; home/gfx_upload.asm
; bank 00, $0749-$0956 (525 bytes); pinned by layout.link
; HDMA start, screen-buffer upload to VRAM, tilemap rectangle copies, buffer clear

SECTION "home/gfx_upload", ROM0

; ---- code $0749-$0787 (62 bytes) [CONFIRMED] general-purpose HDMA start (rHDMA5=C-1, bit7=0): A=source bank (region by H), HL=source, DE=dest (E bit0 = VRAM bank via rVBK/FFF4, E&$F0 = low dest byte), C=number of 16-byte blocks, B=LY limit: waits until LY>=$91 and LY<B, else waits for the next VBlank; returns A=bank

Function_00_0749:: ; 00:0749
	ldh [hFarBank], a
	call BankSwitch_H
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	and a, $F0
	ldh [rHDMA4], a
	ld a, e
	and a, $01
	ldh [hVRAMBank], a
	ldh [rVBK], a
	dec c
	ldh a, [rLCDC]
	bit 7, a
	jr z, Label_00_0773

Label_00_076A:: ; 00:076A
	ldh a, [rLY]
	cp a, $91
	jr c, Label_00_076A
	cp a, b
	jr nc, Label_00_077A

Label_00_0773:: ; 00:0773
	ld a, c
	ldh [rHDMA5], a
	inc c
	ldh a, [hFarBank]
	ret

Label_00_077A:: ; 00:077A
	ldh a, [rLY]
	cp a, $91
	jr nc, Label_00_077A
	ldh a, [hFarBank]
	call BankSwitch_H
	jr Label_00_076A

; ---- code $0787-$07CB (68 bytes) [CONFIRMED] variant of 0749 that calls the frame service (0392) while waiting

Function_00_0787:: ; 00:0787
	ldh [hFarBank], a
	call BankSwitch_H
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	and a, $F0
	ldh [rHDMA4], a
	ld a, e
	and a, $01
	ldh [hVRAMBank], a
	ldh [rVBK], a
	dec c
	ldh a, [rLCDC]
	bit 7, a
	jr z, Label_00_07B1

Label_00_07A8:: ; 00:07A8
	ldh a, [rLY]
	cp a, $91
	jr c, Label_00_07A8
	cp a, b
	jr nc, Label_00_07BB

Label_00_07B1:: ; 00:07B1
	ld a, c
	ldh [rHDMA5], a
	inc c
	call Function_00_0392
	ldh a, [hFarBank]
	ret

Label_00_07BB:: ; 00:07BB
	ldh a, [rLY]
	cp a, $91
	jr nc, Label_00_07BB
	call Function_00_0392
	ldh a, [hFarBank]
	call BankSwitch_H
	jr Label_00_07A8

; ---- code $07CB-$07FB (48 bytes) [CONFIRMED] uploads the two 1 KiB screen buffers of WRAM bank 7 to VRAM with two HDMA transfers (0749, B=$95, C=$24 blocks): D000 -> VRAM bank 0, D400 -> VRAM bank 1, map $9800 or $9C00 selected by A bit3; di before the wait, ei + frame service after [reached via inferred links; raw refs 31] [executed in 37 scenarios]

Function_00_07CB:: ; 00:07CB
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	and a, $08
	rrca
	add a, $98
	ld d, a
	ld e, $00
	di
	call Function_00_08B7
	ld b, $95
	ld c, $24
	ld hl, $D000
	xor a, a
	call Function_00_0749
	inc e
	ld b, $95
	ld c, $24
	ld hl, $D400
	xor a, a
	call Function_00_0749
	ei
	call Function_00_0392
	ret

; ---- code $07FB-$082C (49 bytes) [PROBABLE] uploads the two 1 KiB screen buffers of WRAM bank 7 to VRAM with two HDMA transfers (0749, B=$95, C=$24 blocks): D000 -> VRAM bank 0, D400 -> VRAM bank 1, map $9800 or $9C00 selected by A bit6; di before the wait, ei + frame service after [candidate; raw refs 17]

Function_00_07FB:: ; 00:07FB
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	and a, $40
	swap a
	add a, $98
	ld d, a
	ld e, $00
	di
	call Function_00_08B7
	ld b, $95
	ld c, $24
	ld hl, $D000
	xor a, a
	call Function_00_0749
	inc e
	ld b, $95
	ld c, $24
	ld hl, $D400
	xor a, a
	call Function_00_0749
	ei
	call Function_00_0392
	ret

; ---- code $082C-$085B (47 bytes) [CONFIRMED] uploads the two 1 KiB screen buffers of WRAM bank 7 to VRAM with two HDMA transfers (0749, B=$95, C=$24 blocks): D000 -> VRAM bank 0, D400 -> VRAM bank 1, map $9800 or $9C00 selected by A bit3; no di, ei + frame service after

Function_00_082C:: ; 00:082C
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	and a, $08
	rrca
	add a, $98
	ld d, a
	ld e, $00
	call Function_00_08B7
	ld b, $95
	ld c, $24
	ld hl, $D000
	xor a, a
	call Function_00_0749
	inc e
	ld b, $95
	ld c, $24
	ld hl, $D400
	xor a, a
	call Function_00_0749
	ei
	call Function_00_0392
	ret

; ---- code $085B-$0887 (44 bytes) [CONFIRMED] uploads the two 1 KiB screen buffers of WRAM bank 7 to VRAM with two HDMA transfers (0749, B=$95, C=$24 blocks): D000 -> VRAM bank 0, D400 -> VRAM bank 1, map $9800 or $9C00 selected by A bit3; no di, ei + ret (no frame service) [reached via inferred links; raw refs 7] [executed in 7 scenarios]

Function_00_085B:: ; 00:085B
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	and a, $08
	rrca
	add a, $98
	ld d, a
	ld e, $00
	call Function_00_08B7
	ld b, $95
	ld c, $24
	ld hl, $D000
	xor a, a
	call Function_00_0749
	inc e
	ld b, $95
	ld c, $24
	ld hl, $D400
	xor a, a
	call Function_00_0749
	ei
	ret

; ---- code $0887-$08B7 (48 bytes) [CONFIRMED] uploads the two 1 KiB screen buffers of WRAM bank 7 to VRAM with two HDMA transfers (0749, B=$95, C=$24 blocks): D000 -> VRAM bank 0, D400 -> VRAM bank 1, map $9800 or $9C00 selected by A bit6; no di, ei + frame service after [reached via inferred links; raw refs 1] [executed in 15 scenarios]

Function_00_0887:: ; 00:0887
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	and a, $40
	swap a
	add a, $98
	ld d, a
	ld e, $00
	call Function_00_08B7
	ld b, $95
	ld c, $24
	ld hl, $D000
	xor a, a
	call Function_00_0749
	inc e
	ld b, $95
	ld c, $24
	ld hl, $D400
	xor a, a
	call Function_00_0749
	ei
	call Function_00_0392
	ret

; ---- code $08B7-$08CA (19 bytes) [CONFIRMED] if LCD on: waits until LY < $87 (i.e. rides out VBlank/late lines, ei while waiting) so an HDMA transfer started afterwards fits in VBlank

Function_00_08B7:: ; 00:08B7
	ldh a, [rLCDC]
	bit 7, a
	ret z

Label_00_08BC:: ; 00:08BC
	ldh a, [rLY]
	cp a, $87
	ret c

Label_00_08C1:: ; 00:08C1
	ldh a, [rLY]
	cp a, $91
	jr nc, Label_00_08C1
	ei
	jr Label_00_08BC

; ---- code $08CA-$08EA (32 bytes) [PROBABLE] copy B rows of C bytes from [HL] (bank A) into the WRAM bank 7 buffer at DE (row stride 32), twice: second pass HL+=$400, DE+=$400 [candidate; raw refs 7]

Function_00_08CA:: ; 00:08CA
	call BankSwitch_H
	ld a, $07
	call BankSwitch_D
	ld a, c
	ldh [hRam_FFB0], a
	push bc
	push de
	push hl
	call Function_00_0904
	pop hl
	pop de
	pop bc
	ld a, h
	add a, $04
	ld h, a
	ld a, d
	add a, $04
	ld d, a
	call Function_00_0904
	ret

; ---- code $08EA-$0904 (26 bytes) [CONFIRMED] like 08CA but the second pass continues with the same source pointer

Function_00_08EA:: ; 00:08EA
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
	ld a, d
	add a, $04
	ld d, a
	call Function_00_0904
	ret

; ---- code $0904-$091C (24 bytes) [CONFIRMED] rectangle copy: B rows x C bytes from [HL] to [DE], DE row stride 32 (uses FFB0 as row length)

Function_00_0904:: ; 00:0904
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Function_00_0904
	ldh a, [hRam_FFB0]
	ld c, a
	xor a, $1F
	inc a
	and a, $1F
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	dec b
	jr nz, Function_00_0904
	ret

; ---- code $091C-$093B (31 bytes) [CONFIRMED] rectangle AND/OR: for B rows x C bytes: [HL] = ([HL] & D) | E, HL row stride 32 (bank A) [reached via inferred links; raw refs 1] [executed in 36 scenarios]

Function_00_091C:: ; 00:091C
	call BankSwitch_H
	ld a, c
	ldh [hRam_FFB0], a

Label_00_0922:: ; 00:0922
	ld a, [hl]
	and a, d
	or a, e
	ld [hli], a
	dec c
	jr nz, Label_00_0922
	ldh a, [hRam_FFB0]
	ld c, a
	xor a, $1F
	inc a
	and a, $1F
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	dec b
	jr nz, Label_00_0922
	ret

; ---- code $093B-$0956 (27 bytes) [PROBABLE] clears the two 1 KiB screen buffers D000-D3FF and D400-D7FF of WRAM bank 7 [candidate; raw refs 6]

Function_00_093B:: ; 00:093B
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $0400
	xor a, a
	call FillBytes
	ld hl, $D400
	ld bc, $0400
	xor a, a
	call FillBytes
	ret
