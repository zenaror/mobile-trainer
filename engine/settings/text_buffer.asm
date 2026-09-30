; engine/settings/text_buffer.asm
; bank 67, $6731-$685F (302 bytes); pinned by layout.link
; TextBuf text entry buffer library

SECTION "engine/settings/text_buffer", ROMX

; ---- code $6731-$67DB (170 bytes) [CONFIRMED] 166 insn(s); 166 executed (in up to 7/18 scenarios); entry proven: target of an executed call/far call (part of region $66C2-$67DB)

TextBuf_Init:: ; 67:6731
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, b
	ld [hli], a
	dec a
	ld [hli], a
	xor a, a
	ld [hli], a
	ld [hl], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

TextBuf_AppendChar:: ; 67:674F
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	inc hl
	ld a, [hl]
	or a, a
	jr z, Label_67_678D
	dec a
	ld [hli], a
	ld a, [hl]
	inc a
	ld [hli], a
	dec a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	push de
	push hl
	ld b, $00

Label_67_6771:: ; 67:6771
	inc b
	ld a, [hli]
	or a, a
	jr nz, Label_67_6771
	ld d, h
	ld e, l
	dec hl

Label_67_6779:: ; 67:6779
	ld a, [hld]
	ld [de], a
	dec de
	dec b
	jr nz, Label_67_6779
	pop hl
	pop de
	ld [hl], d
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	xor a, a
	ret

Label_67_678D:: ; 67:678D
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, $01
	ret

TextBuf_DeleteLast:: ; 67:6799
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	inc hl
	push hl
	inc hl
	ld a, [hli]
	or a, a
	jr z, Label_67_67CE
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld d, h
	ld e, l
	dec de

Label_67_67B6:: ; 67:67B6
	ld a, [hld]
	ld [de], a
	dec de
	or a, a
	jr nz, Label_67_67B6
	pop hl
	ld a, [hl]
	inc a
	ld [hli], a
	ld a, [hl]
	dec a
	ld [hl], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	xor a, a
	ret

Label_67_67CE:: ; 67:67CE
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	pop hl
	ld a, $01
	ret

; ---- code $67DB-$6807 (44 bytes) [HYPOTHESIS] function with no found entry (no call/jp/table word/far pointer/ld r16 to $67DB anywhere in the ROM); linear decode is legal ($67DB-$6807), all direct targets are known code starts, saves ROMX/WRAM bank state, inc hl x2, decrements the byte at [hl+2] if non-zero, returns a=0/1; ends with ret. Sits after a ret between PROBABLE/CONFIRMED functions of the same style

Function_67_67DB:: ; 67:67DB
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	inc hl
	inc hl
	ld a, [hl]
	or a, a
	jr z, Label_67_67FB
	dec a
	ld [hl], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	xor a, a
	ret

Label_67_67FB:: ; 67:67FB
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, $01
	ret

; ---- code $6807-$685F (88 bytes) [CONFIRMED] 56 insn(s); 56 executed (in up to 7/18 scenarios); entry proven: target of an executed call/far call

TextBuf_GetCount:: ; 67:6807
Function_67_6807::
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $02
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld b, [hl]
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, b
	ret

TextBuf_GetFree:: ; 67:6828
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	inc hl
	ld b, [hl]
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, b
	ret

TextBuf_GetLength:: ; 67:6842
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld b, [hl]
	sub a, b
	dec a
	ld b, a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, b
	ret
