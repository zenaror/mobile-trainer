; home/gfx_upload.asm
; bank 00, $0749-$0956 (525 bytes); pinned by layout.link
; HDMA start, screen-buffer upload to VRAM, tilemap rectangle copies, buffer clear

SECTION "home/gfx_upload", ROM0

Gfx_StartHDMA:: ; 00:0749
Function_00_0749::
	; [CONFIRMED] general-purpose HDMA start (rHDMA5=C-1, bit7=0): A=source bank (region by H),
	; HL=source, DE=dest (E bit0 = VRAM bank via rVBK/FFF4, E&$F0 = low dest byte), C=number of
	; 16-byte blocks, B=LY limit: waits until LY>=$91 and LY<B, else waits for the next VBlank;
	; returns A=bank
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
	jr z, .l0773
.loop ; 00:076A
	ldh a, [rLY]
	cp a, $91
	jr c, .loop
	cp a, b
	jr nc, .l077A
.l0773 ; 00:0773
	ld a, c
	ldh [rHDMA5], a
	inc c
	ldh a, [hFarBank]
	ret
.l077A ; 00:077A
	ldh a, [rLY]
	cp a, $91
	jr nc, .l077A
	ldh a, [hFarBank]
	call BankSwitch_H
	jr .loop

Gfx_StartHDMAWithService:: ; 00:0787
Function_00_0787::
	; [CONFIRMED] variant of 0749 that calls the frame service (0392) while waiting
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
	jr z, .l07B1
.loop ; 00:07A8
	ldh a, [rLY]
	cp a, $91
	jr c, .loop
	cp a, b
	jr nc, .l07BB
.l07B1 ; 00:07B1
	ld a, c
	ldh [rHDMA5], a
	inc c
	call Sound_FrameService
	ldh a, [hFarBank]
	ret
.l07BB ; 00:07BB
	ldh a, [rLY]
	cp a, $91
	jr nc, .l07BB
	call Sound_FrameService
	ldh a, [hFarBank]
	call BankSwitch_H
	jr .loop

Gfx_UploadBgMapBuffersDi:: ; 00:07CB
Function_00_07CB::
	; [CONFIRMED] uploads the first $240 bytes (18 rows) of each of the two 1 KiB screen buffers of
	; WRAM bank 7 to VRAM with two HDMA transfers (0749, B=$95, C=$24 blocks of 16 bytes): D000 ->
	; VRAM bank 0, D400 -> VRAM bank 1, map $9800 or $9C00 selected by A bit3; di before the wait, ei
	; + frame service after [reached via inferred links; raw refs 31] [executed in 37 scenarios]
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
	call Gfx_WaitForFrameTop
	ld b, $95
	ld c, $24
	ld hl, wScreenTileMap
	xor a, a
	call Gfx_StartHDMA
	inc e
	ld b, $95
	ld c, $24
	ld hl, wScreenAttrMap
	xor a, a
	call Gfx_StartHDMA
	ei
	call Sound_FrameService
	ret

Gfx_UploadWinMapBuffersDi:: ; 00:07FB
Function_00_07FB::
	; [PROBABLE] uploads the first $240 bytes (18 rows) of each of the two 1 KiB screen buffers of
	; WRAM bank 7 to VRAM with two HDMA transfers (0749, B=$95, C=$24 blocks of 16 bytes): D000 ->
	; VRAM bank 0, D400 -> VRAM bank 1, map $9800 or $9C00 selected by A bit6; di before the wait, ei
	; + frame service after [candidate; raw refs 17]
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
	call Gfx_WaitForFrameTop
	ld b, $95
	ld c, $24
	ld hl, wScreenTileMap
	xor a, a
	call Gfx_StartHDMA
	inc e
	ld b, $95
	ld c, $24
	ld hl, wScreenAttrMap
	xor a, a
	call Gfx_StartHDMA
	ei
	call Sound_FrameService
	ret

Gfx_UploadBgMapBuffers:: ; 00:082C
Function_00_082C::
	; [CONFIRMED] uploads the first $240 bytes (18 rows) of each of the two 1 KiB screen buffers of
	; WRAM bank 7 to VRAM with two HDMA transfers (0749, B=$95, C=$24 blocks of 16 bytes): D000 ->
	; VRAM bank 0, D400 -> VRAM bank 1, map $9800 or $9C00 selected by A bit3; no di, ei + frame
	; service after
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
	call Gfx_WaitForFrameTop
	ld b, $95
	ld c, $24
	ld hl, wScreenTileMap
	xor a, a
	call Gfx_StartHDMA
	inc e
	ld b, $95
	ld c, $24
	ld hl, wScreenAttrMap
	xor a, a
	call Gfx_StartHDMA
	ei
	call Sound_FrameService
	ret

Gfx_UploadBgMapBuffersNoService:: ; 00:085B
Function_00_085B::
	; [CONFIRMED] uploads the first $240 bytes (18 rows) of each of the two 1 KiB screen buffers of
	; WRAM bank 7 to VRAM with two HDMA transfers (0749, B=$95, C=$24 blocks of 16 bytes): D000 ->
	; VRAM bank 0, D400 -> VRAM bank 1, map $9800 or $9C00 selected by A bit3; no di, ei + ret (no
	; frame service) [reached via inferred links; raw refs 7] [executed in 7 scenarios]
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
	call Gfx_WaitForFrameTop
	ld b, $95
	ld c, $24
	ld hl, wScreenTileMap
	xor a, a
	call Gfx_StartHDMA
	inc e
	ld b, $95
	ld c, $24
	ld hl, wScreenAttrMap
	xor a, a
	call Gfx_StartHDMA
	ei
	ret

Gfx_UploadWinMapBuffers:: ; 00:0887
Function_00_0887::
	; [CONFIRMED] uploads the first $240 bytes (18 rows) of each of the two 1 KiB screen buffers of
	; WRAM bank 7 to VRAM with two HDMA transfers (0749, B=$95, C=$24 blocks of 16 bytes): D000 ->
	; VRAM bank 0, D400 -> VRAM bank 1, map $9800 or $9C00 selected by A bit6; no di, ei + frame
	; service after [reached via inferred links; raw refs 1] [executed in 15 scenarios]
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
	call Gfx_WaitForFrameTop
	ld b, $95
	ld c, $24
	ld hl, wScreenTileMap
	xor a, a
	call Gfx_StartHDMA
	inc e
	ld b, $95
	ld c, $24
	ld hl, wScreenAttrMap
	xor a, a
	call Gfx_StartHDMA
	ei
	call Sound_FrameService
	ret

Gfx_WaitForFrameTop:: ; 00:08B7
Function_00_08B7::
	; [CONFIRMED] if LCD on: waits until LY < $87 (i.e. rides out VBlank/late lines, ei while
	; waiting) so an HDMA transfer started afterwards fits in VBlank
	ldh a, [rLCDC]
	bit 7, a
	ret z
.l08BC ; 00:08BC
	ldh a, [rLY]
	cp a, $87
	ret c
.l08C1 ; 00:08C1
	ldh a, [rLY]
	cp a, $91
	jr nc, .l08C1
	ei
	jr .l08BC

Tilemap_CopyRectAndAttrSplitSrc:: ; 00:08CA
Function_00_08CA::
	; [PROBABLE] copy B rows of C bytes from [HL] (bank A) into the WRAM bank 7 buffer at DE (row
	; stride 32), twice: second pass HL+=$400, DE+=$400 [candidate; raw refs 7]
	call BankSwitch_H
	ld a, $07
	call BankSwitch_D
	ld a, c
	ldh [hRam_FFB0], a
	push bc
	push de
	push hl
	call Tilemap_CopyRect
	pop hl
	pop de
	pop bc
	ld a, h
	add a, $04
	ld h, a
	ld a, d
	add a, $04
	ld d, a
	call Tilemap_CopyRect
	ret

Tilemap_CopyRectAndAttr:: ; 00:08EA
Function_00_08EA::
	; [CONFIRMED] like 08CA but the second pass continues with the same source pointer
	call BankSwitch_H
	ld a, $07
	call BankSwitch_D
	ld a, c
	ldh [hRam_FFB0], a
	push bc
	push de
	call Tilemap_CopyRect
	pop de
	pop bc
	ld a, d
	add a, $04
	ld d, a
	call Tilemap_CopyRect
	ret

Tilemap_CopyRect:: ; 00:0904
Function_00_0904::
	; [CONFIRMED] rectangle copy: B rows x C bytes from [HL] to [DE], DE row stride 32 (uses FFB0 as
	; row length)
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Tilemap_CopyRect
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
	jr nz, Tilemap_CopyRect
	ret

Tilemap_ApplyMaskRect:: ; 00:091C
Function_00_091C::
	; [CONFIRMED] rectangle AND/OR: for B rows x C bytes: [HL] = ([HL] & D) | E, HL row stride 32
	; (bank A) [reached via inferred links; raw refs 1] [executed in 36 scenarios]
	call BankSwitch_H
	ld a, c
	ldh [hRam_FFB0], a
.loop ; 00:0922
	ld a, [hl]
	and a, d
	or a, e
	ld [hli], a
	dec c
	jr nz, .loop
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
	jr nz, .loop
	ret

Tilemap_ClearBuffers:: ; 00:093B
Function_00_093B::
	; [PROBABLE] clears the two 1 KiB screen buffers D000-D3FF and D400-D7FF of WRAM bank 7
	; [candidate; raw refs 6]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wScreenTileMap
	ld bc, $0400
	xor a, a
	call FillBytes
	ld hl, wScreenAttrMap
	ld bc, $0400
	xor a, a
	call FillBytes
	ret
