; engine/browser/scrollbar.asm
; bank 4E, $5B69-$5FB9 (1104 bytes); pinned by layout.link
; canvas shifting, scroll bar, scroll indicators, arrows

SECTION "engine/browser/scrollbar", ROMX

Browser_ShiftCanvasUp:: ; 4E:5B69
	; [CONFIRMED] 272 insn(s) executed; cut out of the PROBABLE region 5A6D-5CB6 by apply_coverage
	; --split [executed in 1 scenarios] (part of region $5B59-$5CB6)
	ld de, $D000
	ld hl, $D148
	ld b, $13
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
.l5B77 ; 4E:5B77
	push bc
	push de
	push hl
	ld b, $0A
.l5B7C ; 4E:5B7C
	call Sound_FrameService
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, $30
	add a, l
	ld l, a
	ld a, $01
	adc a, h
	ld h, a
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, $30
	add a, e
	ld e, a
	ld a, $01
	adc a, d
	ld d, a
	dec b
	jr nz, .l5B7C
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	pop hl
	pop de
	pop bc
	ld a, $10
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, $10
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	dec b
	jp nz, .l5B77
	call Sound_FrameService
	ld hl, $DC88
	ld de, $0008
	ld b, $14
	xor a, a
.l5BFD ; 4E:5BFD
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	add hl, de
	dec b
	jr nz, .l5BFD
	ld bc, $0140
	call FillBytes
	ret

Browser_ShiftCanvasDown:: ; 4E:5C10
	ld hl, $DC87
	ld de, $DDCF
	ld b, $13
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
.l5C1E ; 4E:5C1E
	push bc
	push de
	push hl
	ld b, $0A
.l5C23 ; 4E:5C23
	call Sound_FrameService
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, $D0
	add a, l
	ld l, a
	ld a, $FE
	adc a, h
	ld h, a
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, $D0
	add a, e
	ld e, a
	ld a, $FE
	adc a, d
	ld d, a
	dec b
	jr nz, .l5C23
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	pop hl
	pop de
	pop bc
	ld a, $10
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, $10
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	dec b
	jp nz, .l5C1E
	call Sound_FrameService
	ld hl, $D000
	ld bc, $0140
	xor a, a
	call FillBytes
	ld b, $14
	ld de, $0008
.l5CA9 ; 4E:5CA9
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	add hl, de
	dec b
	jr nz, .l5CA9
	ret

Browser_LoadScrollbarGfx:: ; 4E:5CB6
Function_4E_5CB6::
	; [CONFIRMED] 42 insn(s); 42 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wCommSessionKind]
	cp a, $01
	jr z, .l5D32
	ld a, [wBrowserFrameStyle]
	cp a, $02
	jr z, .l5CFB
	ld de, $8FF0
	ld hl, Gfx_BrowserScrollbar_Tiles8FF0_47_4080
	ld a, $47
	ld b, $98
	ld c, $01
	farcall Gfx_StartHDMAWithService
	ld de, $97D0
	ld hl, Gfx_BrowserScrollbar_Tiles97D0_47_4090
	ld a, $47
	ld b, $98
	ld c, $03
	farcall Gfx_StartHDMAWithService
	ld hl, wSpriteSlot9
	ld de, $7858
	ld a, $72
	ld b, $83
	farcall Sprite_InitSlot
	jp .l5D66
.l5CFB ; 4E:5CFB
	ld de, $8FF0
	ld hl, Gfx_BrowserScrollbar_Tiles8FF0_47_40C0
	ld a, $47
	ld b, $98
	ld c, $01
	farcall Gfx_StartHDMAWithService
	ld de, $97D0
	ld hl, Gfx_BrowserScrollbar_Tiles97D0_47_40D0
	ld a, $47
	ld b, $98
	ld c, $03
	farcall Gfx_StartHDMAWithService
	ld hl, wSpriteSlot9
	ld de, $7858
	ld a, $72
	ld b, $84
	farcall Sprite_InitSlot
	jp .l5D66

.l5D32 ; 4E:5D32
	; [CONFIRMED] 17 insn(s) reached by static flow only; seeds: exec x17; min discovery hops 1;
	; entered by jrcc from 4E:5CBB (executed) [executed in 2 scenarios]
	ld de, $8FF0
	ld hl, Gfx_BrowserScrollbar_Tiles8FF0_47_4000
	ld a, $47
	ld b, $98
	ld c, $01
	farcall Gfx_StartHDMAWithService
	ld de, $97D0
	ld hl, Gfx_BrowserScrollbar_Tiles97D0_47_4010
	ld a, $47
	ld b, $98
	ld c, $03
	farcall Gfx_StartHDMAWithService
	ld hl, wSpriteSlot9
	ld de, $7858
	ld a, $72
	ld b, $81
	farcall Sprite_InitSlot

.l5D66 ; 4E:5D66
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 2/18 scenarios)
	ld de, $18A0
	ld hl, wSpriteSlot9
	call Sprite_SetPosition
	ret

Browser_ReloadFrameTilemap:: ; 4E:5D70
Function_4E_5D70::
	; [PROBABLE] function head whose 23 insn decode cleanly and end with ld bc,$1214 ; ld de,$D000
	; right before the PROBABLE far-call site at 5D93 (call $06D1 -> 00:08EA copy_tilemap_rect_pair,
	; b=18 rows c=20 cols); hl comes from the screen-descriptor table 4E:654B (+6), like the
	; executed code 4E:5D93; contiguous with the code region at 5D93; no external caller found
	ld a, [wBrowserFrameStyle]
	push bc
	and a, $7F
	ld c, a
	ld b, $00
	ld hl, Table_Browser_FrameDescriptors
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0006
	add hl, bc
	pop bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, b
	ld l, c
	ld bc, $1214
	ld de, wScreenTileMap

	; [PROBABLE] 59 insn(s) reached by static flow only; seeds: site x59; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Tilemap_CopyRectAndAttr
	ld a, [wBrowserFrameStyle]
	push bc
	and a, $7F
	ld c, a
	ld b, $00
	ld hl, Table_Browser_FrameDescriptors
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $000F
	add hl, bc
	pop bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld bc, $0512
	ld de, $0020
	farcall Tilemap_FillAscendingWithAttr
	pop hl
	ld bc, $00A0
	add hl, bc
	ld bc, $0712
	ld de, $0080
	farcall Tilemap_FillAscendingWithAttr
	ld a, [wBrowserFrameStyle]
	push bc
	and a, $7F
	ld c, a
	ld b, $00
	ld hl, Table_Browser_FrameDescriptors
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0011
	add hl, bc
	pop bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld bc, $010F
	ld de, $0100
	farcall Tilemap_FillAscendingWithAttr
	pop hl
	ld bc, $0020
	add hl, bc
	ld bc, $010F
	ld de, $010F
	farcall Tilemap_FillAscendingWithAttr
	ld de, $18A0
	ld hl, wSpriteSlot9
	call Sprite_SetPosition
	ret

Browser_DrawScrollbarTrack:: ; 4E:5E11
Function_4E_5E11::
	; [CONFIRMED] 175 insn(s); 175 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wBrowserScrollbarEnable]
	or a, a
	ret z
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wBrowserFrameStyle]
	push bc
	and a, $7F
	ld c, a
	ld b, $00
	ld hl, Table_Browser_FrameDescriptors
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $001B
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push de
	ld l, e
	ld h, d
	ld de, $0020
	ld c, $0A
	ld a, $7D
	ld [hl], a
	add hl, de
	inc a
.l5E43 ; 4E:5E43
	ld [hl], a
	add hl, de
	dec c
	jr nz, .l5E43
	inc a
	ld [hl], a
	pop hl
	ld de, $0400
	add hl, de
	ld c, $0C
	ld a, $05
	ld de, $0020
.l5E56 ; 4E:5E56
	ld [hl], a
	add hl, de
	dec c
	jr nz, .l5E56

Browser_UpdateScrollThumb:: ; 4E:5E5B
	ld a, [wBrowserScrollbarEnable]
	or a, a
	ret z
	ld a, [wBrowserFrameStyle]
	push bc
	and a, $7F
	ld c, a
	ld b, $00
	ld hl, Table_Browser_FrameDescriptors
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $001D
	add hl, bc
	pop bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld hl, wSpriteSlot9
	ld de, $0058
	ld a, $07
	ldh [rSVBK], a
	push hl
	push bc
	ldh a, [hViewScrollMax]
	ld c, a
	ldh a, [hViewScrollMax + 1]
	ld b, a
	or a, c
	jr z, .l5EB9
	ldh a, [hViewY]
	ld l, a
	ldh a, [hViewY + 1]
	ld h, a
	call Multiply16x16to32
	ld d, h
	ld e, l
	ldh a, [hViewScrollMax]
	add a, $0C
	ld l, a
	ldh a, [hViewScrollMax + 1]
	adc a, $00
	ld h, a
	call Divide32by15
	pop bc
	pop hl
	ld a, b
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	jr nz, .l5EBB
	jr c, .l5EBB
	ld a, e
	ld [hli], a
	ld a, c
	ld [hli], a
	ret
.l5EB9 ; 4E:5EB9
	pop bc
	pop hl
.l5EBB ; 4E:5EBB
	ld a, $C0
	ld [hli], a
	ld [hli], a
	ret

Browser_DrawScrollIndicators:: ; 4E:5EC0
	ld de, $18A0
	ld hl, wSpriteSlot9
	call Sprite_SetPosition
	ld hl, wSpriteSlot10
	call Sprite_ClearSlot
	ld hl, wSpriteSlot11
	call Sprite_ClearSlot
	farcall Browser_UpdateScrollThumb
	ldh a, [hViewScrollMax]
	ld c, a
	ldh a, [hViewScrollMax + 1]
	or a, c
	ret z
	ldh a, [hViewY]
	ld c, a
	ldh a, [hViewY + 1]
	ld b, a
	or a, c
	push bc
	call nz, Browser_ShowUpArrow
	pop bc
	ldh a, [hViewScrollMax]
	sub a, c
	ld e, a
	ldh a, [hViewScrollMax + 1]
	sbc a, b
	ld d, a
	ret c
	ld a, [wCommSessionKind]
	cp a, $01
	jr z, .l5F34
	ld a, [wBrowserFrameStyle]
	cp a, $02
	jr z, .l5F46
	ld hl, wSpriteSlot11
	ld de, BrowserShared_ObjTable
	ld a, $72
	ld b, $86
	farcall Sprite_InitSlot
.loop ; 4E:5F15
	ld a, [wBrowserFrameStyle]
	push bc
	and a, $7F
	ld c, a
	ld b, $00
	ld hl, Table_Browser_FrameDescriptors
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0015
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, wSpriteSlot11
	jp Sprite_SetPosition

.l5F34 ; 4E:5F34
	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 1;
	; entered by jrcc from 4E:5EFC (executed) [executed in 1 scenarios]
	ld hl, wSpriteSlot11
	ld de, BrowserShared_ObjTable
	ld a, $72
	ld b, $89
	farcall Sprite_InitSlot
	jr .loop

.l5F46 ; 4E:5F46
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)
	ld hl, wSpriteSlot11
	ld de, BrowserShared_ObjTable
	ld a, $72
	ld b, $8B
	farcall Sprite_InitSlot
	jr .loop

Browser_ShowUpArrow:: ; 4E:5F58
	; [CONFIRMED] 42 insn(s) reached by static flow only; seeds: exec x42; min discovery hops 1;
	; entered by callcc from 4E:5EEA (executed) [executed in 1 scenarios]
	ld a, [wCommSessionKind]
	cp a, $01
	jr z, .l5F95
	ld a, [wBrowserFrameStyle]
	cp a, $02
	jr z, .l5FA7
	ld hl, wSpriteSlot10
	ld de, BrowserShared_ObjTable
	ld a, $72
	ld b, $85
	farcall Sprite_InitSlot
.loop ; 4E:5F76
	ld a, [wBrowserFrameStyle]
	push bc
	and a, $7F
	ld c, a
	ld b, $00
	ld hl, Table_Browser_FrameDescriptors
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0013
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, wSpriteSlot10
	jp Sprite_SetPosition
.l5F95 ; 4E:5F95
	ld hl, wSpriteSlot10
	ld de, BrowserShared_ObjTable
	ld a, $72
	ld b, $88
	farcall Sprite_InitSlot
	jr .loop
.l5FA7 ; 4E:5FA7
	ld hl, wSpriteSlot10
	ld de, BrowserShared_ObjTable
	ld a, $72
	ld b, $8A
	farcall Sprite_InitSlot
	jr .loop
