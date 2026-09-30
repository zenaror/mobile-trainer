; engine/gfx/tile_canvas.asm
; bank 4F, $4572-$4668 (246 bytes); pinned by layout.link
; tile canvas upload/fill, tilemap ascending fill

SECTION "engine/gfx/tile_canvas", ROMX

; ---- code $4572-$4668 (246 bytes) [CONFIRMED] 184 insn(s); 184 executed (in up to 12/18 scenarios); entry proven: target of an executed call/far call (part of region $4572-$4671)

TileCanvas_UploadRect:: ; 4F:4572
Function_4F_4572::
	push bc
	ld b, $FF
	ld a, c
	add a, $09

Label_4F_4578:: ; 4F:4578
	inc b
	sub a, $0A
	jr nc, Label_4F_4578
	ld a, $99
	sub a, b
	ldh [hRam_FFB1], a
	pop bc

Label_4F_4583:: ; 4F:4583
	call Function_00_0392
	push hl
	push de
	push bc
	ld a, h
	cp a, $0C
	ld b, $02
	jr c, Label_4F_4595
	ld b, $03
	sub a, $0C
	ld h, a

Label_4F_4595:: ; 4F:4595
	add a, a
	add a, a
	add a, h
	add a, a
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, $00
	ld h, a
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, h
	add a, $D0
	ld h, a
	ld a, b
	ldh [hRam_FFB0], a
	ldh a, [hRam_FFB1]
	ld b, a
	ldh a, [hRam_FFB0]
	call Function_00_0787
	pop bc
	pop de
	ld l, c
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ld d, h
	ld e, l
	pop hl
	inc h
	dec b
	jr nz, Label_4F_4583
	ret

Tilemap_FillAscendingWithAttr:: ; 4F:45C6
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a

Label_4F_45D3:: ; 4F:45D3
	call Function_00_0392
	push bc

Label_4F_45D7:: ; 4F:45D7
	ld a, h
	add a, $04
	ld h, a
	ld [hl], d
	sub a, $04
	ld h, a
	ld a, e
	ld [hli], a
	inc a
	jr nz, Label_4F_45E6
	set 3, d

Label_4F_45E6:: ; 4F:45E6
	ld e, a
	dec c
	jr nz, Label_4F_45D7
	pop bc
	ld a, c
	xor a, $1F
	inc a
	and a, $1F
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	dec b
	jr nz, Label_4F_45D3
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

TileCanvas_FillRect:: ; 4F:4604
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]

Label_4F_460B:: ; 4F:460B
	push hl
	push bc
	ld a, h
	cp a, $0C
	ld b, $02
	jr c, Label_4F_4619
	ld b, $03
	sub a, $0C
	ld h, a

Label_4F_4619:: ; 4F:4619
	add a, a
	add a, a
	add a, h
	add a, a
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, $00
	ld h, a
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, h
	add a, $D0
	ld h, a
	ld a, b
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call Function_00_0392

Label_4F_4635:: ; 4F:4635
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	dec c
	jr nz, Label_4F_4635
	pop bc
	pop hl
	inc h
	dec b
	jr nz, Label_4F_460B
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret
