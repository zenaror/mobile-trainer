; home/gfx_upload.asm
; bank 00, $0749-$0956 (525 bytes); pinned by layout.link
; HDMA start, screen-buffer upload to VRAM, tilemap rectangle copies, buffer clear

SECTION "home/gfx_upload", ROM0

Gfx_StartHDMA:: ; 00:0749
	; Historical address alias retired; proper operation name retained.
	; [CONFIRMED] rHDMA5=C-1; general-purpose mode only for C=$01..$80 (no bit7 mask).
	; A=source bank by H; HL=source, DE=dest; E bit0 selects VRAM bank, E&$F0 low dest.
	; LCD-on wait requires $91<=LY<B; LCD-off skips wait. C counts 16-byte blocks.
	; Returns A=bank; arbitrary C/B values do not gain a general transfer guarantee.
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
	jr z, .StartTransfer
.wait_for_ly_at_least_91 ; 00:076A
	ldh a, [rLY]
	cp a, $91
	jr c, .wait_for_ly_at_least_91
	cp a, b
	jr nc, .WaitForLyBelow91
.StartTransfer ; 00:0773
	ld a, c
	ldh [rHDMA5], a
	inc c
	ldh a, [hFarBank]
	ret
.WaitForLyBelow91 ; 00:077A
	ldh a, [rLY]
	cp a, $91
	jr nc, .WaitForLyBelow91
	ldh a, [hFarBank]
	call BankSwitch_H
	jr .wait_for_ly_at_least_91

Gfx_StartHDMAWithService:: ; 00:0787
	; Historical address alias retired; proper operation name retained.
	; [CONFIRMED] 0749 domain (C=$01..$80; LCD-on $91<=LY<B), with frame service.
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
	jr z, .StartTransfer
.wait_for_ly_at_least_91 ; 00:07A8
	ldh a, [rLY]
	cp a, $91
	jr c, .wait_for_ly_at_least_91
	cp a, b
	jr nc, .WaitForLyBelow91
.StartTransfer ; 00:07B1
	ld a, c
	ldh [rHDMA5], a
	inc c
	call Sound_FrameService
	ldh a, [hFarBank]
	ret
.WaitForLyBelow91 ; 00:07BB
	ldh a, [rLY]
	cp a, $91
	jr nc, .WaitForLyBelow91
	call Sound_FrameService
	ldh a, [hFarBank]
	call BankSwitch_H
	jr .wait_for_ly_at_least_91

Gfx_UploadBgMapBuffersDi:: ; 00:07CB
	; Historical address alias retired; proper operation name retained.
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
	; Historical address alias retired; proper operation name retained.
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
	; Historical address alias retired; proper operation name retained.
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
	; Historical address alias retired; proper operation name retained.
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
	; Historical address alias retired; proper operation name retained.
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
	; Historical address alias retired; proper operation name retained.
	; [CONFIRMED] if LCD on: waits until LY < $87 (i.e. rides out VBlank/late lines, ei while
	; waiting) so an HDMA transfer started afterwards fits in VBlank
	ldh a, [rLCDC]
	bit 7, a
	ret z
.check_ly_below_87 ; 00:08BC
	ldh a, [rLY]
	cp a, $87
	ret c
.wait_ly_below_91 ; 00:08C1
	ldh a, [rLY]
	cp a, $91
	jr nc, .wait_ly_below_91
	ei
	jr .check_ly_below_87

Tilemap_CopyRectAndAttrSplitSrc:: ; 00:08CA
	; Historical address alias retired; proper operation name retained.
	; [PROBABLE] copy B rows of C bytes from [HL] (bank A) into the WRAM bank 7 buffer at DE (row
	; stride 32), twice: second pass HL+=$400, DE+=$400 [candidate; raw refs 7]
	call BankSwitch_H
	ld a, $07
	call BankSwitch_D
	ld a, c
	ldh [hTilemapRect_Width], a
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
	; Historical address alias retired; proper operation name retained.
	; [CONFIRMED] like 08CA but the second pass continues with the same source pointer
	call BankSwitch_H
	ld a, $07
	call BankSwitch_D
	ld a, c
	ldh [hTilemapRect_Width], a
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
	; Historical address alias retired; proper operation name retained.
	; [CONFIRMED] rectangle copy: B rows x C bytes from [HL] to [DE], DE row stride 32 (uses FFB0 as
	; row length)
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Tilemap_CopyRect
	ldh a, [hTilemapRect_Width]
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
	; Historical address alias retired; proper operation name retained.
	; [CONFIRMED] for B rows x C bytes: [HL] = ([HL] & D) | E. Next-row advance is ceil(C/32)*32
	; for C=1..255 (32 only for widths 1..32); C=0 processes 256 bytes and advances 256, and B=0
	; wraps to 256 rows. Bank A selects the HL region; [reached via inferred links; raw refs 1]
	; [executed in 36 scenarios]
	call BankSwitch_H
	ld a, c
	ldh [hTilemapRect_Width], a
.mask_tilemap_cell ; 00:0922
	ld a, [hl]
	and a, d
	or a, e
	ld [hli], a
	dec c
	jr nz, .mask_tilemap_cell
	ldh a, [hTilemapRect_Width]
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
	jr nz, .mask_tilemap_cell
	ret

Tilemap_ClearBuffers:: ; 00:093B
	; Historical address alias retired; proper operation name retained.
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
