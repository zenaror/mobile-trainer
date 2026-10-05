; engine/menus/top_menu.asm
; bank 1F, $4000-$4667 (1639 bytes); pinned by layout.link
; top menu (3 icons), cursor fly animation

SECTION "engine/menus/top_menu", ROMX

TopMenu_Run:: ; 1F:4000
Function_1F_4000::
	; [CONFIRMED] 170 insn(s); 170 executed (in up to 11/18 scenarios); entry proven: target of an
	; executed call/far call
	call Sound_FrameService
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4
	call FillBytes
	farcall Stub_Nop_48_48BB
	ld a, $01
	ld hl, $A8B9
	call ReadByteFar
	or a, a
	jr nz, .skip
	ld a, $01
.skip ; 1F:4020
	ld [wTopMenu_Cursor], a
	ld a, $01
	ld [wTopMenu_PrevCursor], a
	ld [wTopMenu_AnimCounter], a
	ld a, $28
	ld [wTopMenuCursorTargetY], a
	ld a, $0B
	ld [wTopMenuCursorTargetX], a
	ldh a, [rLCDC]
	and a, $9F
	ldh [rLCDC], a
	xor a, a
	ldh [rSCX], a
	ldh [rSCY], a
	ld a, $07
	ldh [rWX], a
	ld a, $90
	ldh [rWY], a
	farcall Sprite_ResetAll
	ld de, $8000
	ld hl, Gfx_TopMenu_Tiles8000
	ld a, $1E
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8400
	ld hl, Gfx_TopMenu_Tiles8400
	ld a, $1E
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8800
	ld hl, Gfx_TopMenu_Tiles8800
	ld a, $1E
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C00
	ld hl, Gfx_TopMenu_Tiles8C00
	ld a, $1E
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9000
	ld hl, Gfx_TopMenu_Tiles9000
	ld a, $1E
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_TopMenu_Tiles9000Vb1
	ld a, $1E
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_TopMenu_Tiles9400Vb1
	ld a, $1E
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_TopMenu_Bg
	ld a, $1E
	farcall Palette_LoadToBuffer
	ld bc, $1014
	ld de, $D000
	ld hl, Tilemap_TopMenu_1E_40D7
	ld a, $1E
	farcall Tilemap_CopyRectAndAttr
	ld hl, $DA50
	ld de, TopMenu_ObjTable
	ld a, $1E
	ld b, $85
	farcall Sprite_InitSlot
	ld bc, $0040
	ld de, $D840
	ld hl, Palette_TopMenu_Obj
	ld a, $1E
	farcall Palette_LoadToBuffer
	ld hl, $DA10
	ld de, TopMenu_ObjTable
	ld a, $1E
	ld b, $01
	farcall Sprite_InitSlot
	ld de, $191D
	ld hl, $DA10
	call Sprite_SetPosition
	ld hl, $DA20
	ld de, TopMenu_ObjTable
	ld a, $1E
	ld b, $02
	farcall Sprite_InitSlot
	ld de, $1676
	ld hl, $DA20
	call Sprite_SetPosition
	xor a, a
	ld [wSpriteSlots + 22], a
	ld [wSpriteSlots + 23], a
	ld [wSpriteSlots + 24], a
	ld [wSpriteSlots + 38], a
	ld [wSpriteSlots + 39], a
	ld [wSpriteSlots + 40], a
	call TopMenu_InitItemSprites
	ld a, $40
	ld bc, $0220
	ld de, $8000
	ld hl, $D200
	farcall Tilemap_FillRectSequential
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, $D000
	call FillBytes
	ld de, $9400
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	farcall Sprite_UpdateAll
	ldh a, [rLCDC]
	or a, $04
	ldh [rLCDC], a
	farcall Palette_FadeInFromWhite
	ld a, [wTopMenu_Cursor]
	dec a
	ld b, a
	ld hl, Data_TopMenu_StringIndexBank
	ld a, $1E
	farcall Ticker_Start
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0002
	call Sound_PlayMusic
	pop af
	ldh [rSVBK], a

TopMenu_Loop:: ; 1F:41D1
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $41E9-$41F3 (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 1F:41E6: 5 entries; fixed length (5 words) by the routine; every byte read as data in a trace

Table_TopMenu_Buttons:: ; 1F:41E9
Table_1F_41E9::
	dw TopMenu_OnA
	dw TopMenu_OnB
	dw TopMenu_IgnoreSelect
	dw TopMenu_IgnoreStart
	dw TopMenu_Idle

TopMenu_Idle:: ; 1F:41F3
	; [CONFIRMED] 36 insn(s); 36 executed (in up to 11/18 scenarios)
	farcall Ticker_Update
	call TopMenu_UpdateCursorMove
	ldh a, [hJoyPressed]
	and a, $F0
	call nz, TopMenu_HandleDpad
	call TopMenu_AnimatePanel
	ld a, [wTopMenu_SlideFlag]
	or a, a
	jp nz, TopMenu_Loop
	ld a, [wTopMenu_PendingAFlag]
	or a, a
	jp nz, TopMenu_OnA_Accept
	jp TopMenu_Loop

TopMenu_OnA:: ; 1F:4217
	ld a, [wTopMenu_SlideFlag]
	or a, a
	jr nz, TopMenu_OnA_QueueWhileMoving

TopMenu_OnA_Accept:: ; 1F:421D
Label_1F_421D::
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutWithTicker
	farcall Ticker_Stop
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	ld a, [wTopMenu_Cursor]
	ld b, a
	ld a, $01
	ld hl, $A8B9
	farcall WriteByteFar
	ld a, [wTopMenu_Cursor]
	ret

TopMenu_OnA_QueueWhileMoving:: ; 1F:4252
Label_1F_4252::
	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 1F:421B (executed) [executed in 5 scenarios]
	ld a, $01
	ld [wTopMenu_PendingAFlag], a
	jp TopMenu_Loop

TopMenu_OnB:: ; 1F:425A
	; [CONFIRMED] 111 insn(s); 111 executed (in up to 5/18 scenarios)
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutWithTicker
	farcall Ticker_Stop
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	ld b, $00
	ld a, $01
	ld hl, $A8B9
	farcall WriteByteFar
	xor a, a
	ret

TopMenu_IgnoreStart:: ; 1F:428B
Label_1F_428B::
	jp TopMenu_Loop

TopMenu_IgnoreSelect:: ; 1F:428E
Label_1F_428E::
	jp TopMenu_Loop

TopMenu_HandleDpad:: ; 1F:4291
	ld b, a
	ld a, [wTopMenu_SlideFlag]
	or a, a
	ret nz
	bit 4, b
	jr nz, .l42C5
	bit 6, b
	jr nz, .l42E5
	bit 7, b
	jp nz, .l4307
	ld a, [wTopMenu_Cursor]
	cp a, $01
	ret z
	ld [wTopMenu_PrevCursor], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002A
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	call TopMenu_LoadPanel
	ld a, $01
	jp TopMenu_SelectItem
.l42C5 ; 1F:42C5
	ld a, [wTopMenu_Cursor]
	cp a, $02
	ret z
	ld [wTopMenu_PrevCursor], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002A
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	call TopMenu_LoadPanel
	ld a, $02
	jr TopMenu_SelectItem
.l42E5 ; 1F:42E5
	ld a, [wTopMenu_Cursor]
	cp a, $03
	ret nz
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002B
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld hl, wTopMenu_PrevCursor
	ld b, [hl]
	ld [hl], a
	push bc
	call TopMenu_LoadPanel
	pop af
	jr TopMenu_SelectItem
.l4307 ; 1F:4307
	ld a, [wTopMenu_Cursor]
	cp a, $03
	ret z
	ld [wTopMenu_PrevCursor], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002B
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	call TopMenu_LoadPanel
	ld a, $03

TopMenu_SelectItem:: ; 1F:4325
	ld [wTopMenu_Cursor], a
	ld hl, Table_TopMenu_CursorTargets
	dec a
	sla a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld [wTopMenuCursorTargetY], a
	ld a, [hl]
	ld [wTopMenuCursorTargetX], a
	call TopMenu_StartCursorMove
	ld a, $01
	ld [wTopMenu_SlideFlag], a
	farcall Ticker_Stop
	ret

; ---- data $434B-$4351 (6 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

Table_TopMenu_CursorTargets:: ; 1F:434B
Data_1F_434B::
	db $28, $0B, $28, $51, $60, $2E

TopMenu_LoadPanel:: ; 1F:4351
Function_1F_4351::
	; [CONFIRMED] 196 insn(s); 196 executed (in up to 11/18 scenarios); entry proven: target of an
	; executed call/far call
	ld bc, $1014
	ld de, $D000
	ld hl, Tilemap_TopMenu_1E_40D7
	ld a, $1E
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld hl, $DA40
	ld de, TopMenu_ObjTable
	ld a, $1E
	ld b, $04
	farcall Sprite_InitSlot
	ld de, $4048
	ld hl, $DA40
	call Sprite_SetPosition
	xor a, a
	ld [wSpriteSlots + 70], a
	ld [wSpriteSlots + 71], a
	ld [wSpriteSlots + 72], a
	ld a, [wTopMenu_PrevCursor]
	dec a
	cp a, $01
	jr c, .l4396
	jp z, .l43BA
	ret
.l4396 ; 1F:4396
	ld hl, $DA10
	ld de, TopMenu_ObjTable
	ld a, $1E
	ld b, $01
	farcall Sprite_InitSlot
	ld de, $191D
	ld hl, $DA10
	call Sprite_SetPosition
	xor a, a
	ld [wSpriteSlots + 22], a
	ld [wSpriteSlots + 23], a
	ld [wSpriteSlots + 24], a
	ret
.l43BA ; 1F:43BA
	ld hl, $DA20
	ld de, TopMenu_ObjTable
	ld a, $1E
	ld b, $02
	farcall Sprite_InitSlot
	ld de, $1676
	ld hl, $DA20
	call Sprite_SetPosition
	ld hl, $DA30
	ld de, TopMenu_ObjTable
	ld a, $1E
	ld b, $03
	farcall Sprite_InitSlot
	ld de, $AAAA
	ld hl, $DA30
	call Sprite_SetPosition
	xor a, a
	ld [wSpriteSlots + 38], a
	ld [wSpriteSlots + 39], a
	ld [wSpriteSlots + 40], a
	ret

TopMenu_InitItemSprites:: ; 1F:43F7
	ld a, [wTopMenu_Cursor]
	cp a, $03
	jr z, .l4417
	ld hl, $DA40
	ld de, TopMenu_ObjTable
	ld a, $1E
	ld b, $06
	farcall Sprite_InitSlot
	ld de, $4848
	ld hl, $DA40
	call Sprite_SetPosition
.l4417 ; 1F:4417
	ld a, [wTopMenu_Cursor]
	dec a
	cp a, $01
	jr c, .l444F
	jp z, .l447C
	ld hl, $DA40
	ld de, TopMenu_ObjTable
	ld a, $1E
	ld b, $84
	farcall Sprite_InitSlot
	ld de, $4048
	ld hl, $DA40
	call Sprite_SetPosition
	ld a, $2E
	ld e, a
	ld [wTopMenu_CursorPosX], a
	ld a, $60
	ld d, a
	ld [wTopMenu_CursorPosY], a
	ld hl, $DA50
	call Sprite_SetPosition
	jr .l44C0
.l444F ; 1F:444F
	ld hl, $DA10
	ld de, TopMenu_ObjTable
	ld a, $1E
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $191D
	ld hl, $DA10
	call Sprite_SetPosition
	ld a, $0B
	ld e, a
	ld [wTopMenu_CursorPosX], a
	ld a, $28
	ld d, a
	ld [wTopMenu_CursorPosY], a
	ld hl, $DA50
	call Sprite_SetPosition
	jr .l44C0
.l447C ; 1F:447C
	ld hl, $DA20
	ld de, TopMenu_ObjTable
	ld a, $1E
	ld b, $82
	farcall Sprite_InitSlot
	ld de, $1676
	ld hl, $DA20
	call Sprite_SetPosition
	ld hl, $DA30
	ld de, TopMenu_ObjTable
	ld a, $1E
	ld b, $83
	farcall Sprite_InitSlot
	ld de, $1A6B
	ld hl, $DA30
	call Sprite_SetPosition
	ld a, $51
	ld e, a
	ld [wTopMenu_CursorPosX], a
	ld a, $28
	ld d, a
	ld [wTopMenu_CursorPosY], a
	ld hl, $DA50
	call Sprite_SetPosition
.l44C0 ; 1F:44C0
	xor a, a
	ld [wTopMenu_AnimFrame], a
	ld [wTopMenu_SlideFlag], a
	inc a
	ld [wTopMenu_AnimCounter], a
	farcall Sprite_UpdateAll
	call TopMenu_AnimatePanel
	ret

TopMenu_AnimatePanel:: ; 1F:44D5
	ld a, [wTopMenu_SlideFlag]
	or a, a
	ret nz
	ld hl, wTopMenu_AnimCounter
	dec [hl]
	ret nz
	ld [hl], $1E
	ld a, [wTopMenu_Cursor]
	dec a
	cp a, $01
	jr c, .l4503
	jp z, .l4532
	ld bc, $090C
	ld de, $D0E4
	ld hl, Tilemap_TopMenu_1E_48C1
	ld a, $1E
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ret
.l4503 ; 1F:4503
	ld a, [wTopMenu_AnimFrame]
	ld de, $00C6
	call Multiply8x16
	ld de, $4357
	add hl, de
	ld de, $D000
	ld a, $1E
	ld bc, $090B
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld a, [wTopMenu_AnimFrame]
	inc a
	ld [wTopMenu_AnimFrame], a
	cp a, $02
	ret nz
	xor a, a
	ld [wTopMenu_AnimFrame], a
	ret
.l4532 ; 1F:4532
	ld a, [wTopMenu_AnimFrame]
	ld de, $00C6
	call Multiply8x16
	ld de, $44E3
	add hl, de
	ld de, $D009
	ld a, $1E
	ld bc, $090B
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld a, [wTopMenu_AnimFrame]
	inc a
	ld [wTopMenu_AnimFrame], a
	cp a, $05
	ret nz

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the retcc at 1F:455B (executed) [executed in 2 scenarios]
	xor a, a
	ld [wTopMenu_AnimFrame], a
	ret

TopMenu_UpdateCursorMove:: ; 1F:4561
Function_1F_4561::
	; [CONFIRMED] 82 insn(s); 82 executed (in up to 11/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wTopMenuCursorStepsLeft]
	or a, a
	ret z
	dec a
	ld [wTopMenuCursorStepsLeft], a
	jr nz, .l458F
	call TopMenu_InitItemSprites
	ld a, [wTopMenu_Cursor]
	dec a
	ld b, a
	ld hl, Data_TopMenu_StringIndexBank
	ld a, $1E
	farcall Ticker_Start
	ld a, [wTopMenuCursorTargetX]
	ld [wTopMenu_CursorPosX], a
	ld e, a
	ld a, [wTopMenuCursorTargetY]
	ld [wTopMenu_CursorPosY], a
	ld d, a
	jr .l45C3
.l458F ; 1F:458F
	ld a, [wTopMenuCursorStepXHi]
	ld b, a
	ld a, [wTopMenuCursorStepXLo]
	ld c, a
	ld a, [wTopMenu_CursorPosX]
	ld h, a
	ld a, [wTopMenuCursorXFrac]
	ld l, a
	add hl, bc
	ld a, h
	ld [wTopMenu_CursorPosX], a
	ld a, l
	ld [wTopMenuCursorXFrac], a
	ld e, h
	ld a, [wTopMenu_CursorStepYHi]
	ld b, a
	ld a, [wTopMenuCursorStepYLo]
	ld c, a
	ld a, [wTopMenu_CursorPosY]
	ld h, a
	ld a, [wTopMenuCursorYFrac]
	ld l, a
	add hl, bc
	ld a, h
	ld [wTopMenu_CursorPosY], a
	ld a, l
	ld [wTopMenuCursorYFrac], a
	ld d, h
.l45C3 ; 1F:45C3
	ld hl, $DA50
	call Sprite_SetPosition
	ret

TopMenu_StartCursorMove:: ; 1F:45CA
	xor a, a
	ld [wTopMenu_DirFlags], a
	ld a, [wTopMenu_CursorPosX]
	ld b, a
	ld a, [wTopMenuCursorTargetX]
	sub a, b
	ld b, a
	jr nc, .l45E2
	xor a, $FF
	inc a
	ld b, a
	ld a, $01
	ld [wTopMenu_DirFlags], a
.l45E2 ; 1F:45E2
	ld a, [wTopMenu_CursorPosY]
	ld h, a
	ld a, [wTopMenuCursorTargetY]
	sub a, h
	ld h, a
	jr nc, .l45F9
	xor a, $FF
	inc a
	ld h, a
	ld a, [wTopMenu_DirFlags]
	or a, $02
	ld [wTopMenu_DirFlags], a
.l45F9 ; 1F:45F9
	ld a, h
	add a, b
	rr a
	srl a
	srl a
	jr nz, .skip

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 1F:4601 (executed)
	ld a, $01

.skip ; 1F:4605
	; [CONFIRMED] 46 insn(s); 46 executed (in up to 5/18 scenarios)
	ld l, a
	ld [wTopMenuCursorStepsLeft], a
	ld c, l
	farcall Divide8
	ld a, b
	ld [wTopMenuCursorStepXHi], a
	push hl
	ld e, l
	ld d, $00
	ld h, c
	ld l, $00
	call Divide16
	ld a, [wTopMenu_DirFlags]
	bit 0, a
	ld a, l
	ld [wTopMenuCursorStepXLo], a
	jr z, .l4637
	xor a, $FF
	inc a
	ld [wTopMenuCursorStepXLo], a
	ld a, [wTopMenuCursorStepXHi]
	xor a, $FF
	ld [wTopMenuCursorStepXHi], a
.l4637 ; 1F:4637
	pop hl
	ld b, h
	ld c, l
	farcall Divide8
	ld a, b
	ld [wTopMenu_CursorStepYHi], a
	ld e, l
	ld d, $00
	ld h, c
	ld l, $00
	call Divide16
	ld a, [wTopMenu_DirFlags]
	bit 1, a
	ld a, l
	ld [wTopMenuCursorStepYLo], a
	jr z, .done
	xor a, $FF
	inc a
	ld [wTopMenuCursorStepYLo], a
	ld a, [wTopMenu_CursorStepYHi]
	xor a, $FF
	ld [wTopMenu_CursorStepYHi], a
.done ; 1F:4666
	ret
