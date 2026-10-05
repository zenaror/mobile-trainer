; engine/profile/profile_editor.asm
; bank 2A, $5495-$6300 (3691 bytes); pinned by layout.link
; profile (nickname) editor with the kana keyboard

SECTION "engine/profile/profile_editor", ROMX

Profile_Edit:: ; 2A:5495
Function_2A_5495::
	; [CONFIRMED] 44 insn(s); 44 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld [wMailScreenMode], a
	call VBlank_WaitAndService
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $15
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call VBlank_Wait
	push bc
	ld a, $00
	ld hl, $AF50
	farcall Account_CopyMailAddressToFar
	farcall SramCheck_Bank0Commit
	pop bc
	call Profile_InitScreen
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D514
	ld a, [de]
	cp a, $00
	jr z, Label_2A_552A
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_PlaceTextCursor

Profile_Edit_Loop:: ; 2A:54FD
	ld a, c
	cp a, $09
	jr nz, .skip

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 2A:5500 (executed)
	ld c, $08

.skip ; 2A:5504
	; [CONFIRMED] 31 insn(s); 31 executed (in up to 2/18 scenarios)
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	call Profile_PlaceTextCursor
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $D0
	ld [wSpriteSlots + 33], a
	ldh a, [hJoyPressed]
	and a, $01
	jp z, Label_2A_56EC

Label_2A_552A:: ; 2A:552A
	push af
	push bc
	ld de, $40D0
	ld hl, $DA60
	call Sprite_SetPosition
	pop bc
	pop af
	call Profile_KeyboardLoop
	push af
	push bc
	ld de, $4000
	ld hl, $DA60
	call Sprite_SetPosition
	pop bc
	pop af
	cp a, $09
	jr nz, .l55AD

	; [PROBABLE] 52 insn(s) reached by static flow only; seeds: exec x52; min discovery hops 0;
	; fall-through of the jrcc at 2A:5549 (executed)
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D514
	ld a, [de]
	cp a, $00
	jp nz, .l5617
	push af
	push bc
	ld de, $40D0
	ld hl, $DA60
	call Sprite_SetPosition
	pop bc
	pop af
	push bc
	ld de, $0214
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push de
	pop de
	farcall Dialog_Show
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	pop bc
	push af
	push bc
	ld de, $4000
	ld hl, $DA60
	call Sprite_SetPosition
	pop bc
	pop af
	jp Label_2A_552A

.l55AD ; 2A:55AD
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios)
	cp a, $08
	jr z, .l55B6
	cp a, $07
	jp z, .l563D

.l55B6 ; 2A:55B6
	; [CONFIRMED] 72 insn(s) reached by static flow only; seeds: exec x72; min discovery hops 0;
	; entered by jrcc from 2A:55AF (executed) [executed in 1 scenarios]
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D514
	ld a, [de]
	cp a, $00
	jr nz, .l5617
	push af
	push bc
	ld de, $40D0
	ld hl, $DA60
	call Sprite_SetPosition
	pop bc
	pop af
	push bc
	ld de, $0214
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push de
	pop de
	farcall Dialog_Show
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	pop bc
	push af
	push bc
	ld de, $4000
	ld hl, $DA60
	call Sprite_SetPosition
	pop bc
	pop af
	jp Label_2A_552A
.l5617 ; 2A:5617
	push af
	push bc
	ld de, $40D0
	ld hl, $DA60
	call Sprite_SetPosition
	pop bc
	pop af
	push bc
	ld de, $020E
	pop bc
	push af
	push bc
	ld de, $4000
	ld hl, $DA60
	call Sprite_SetPosition
	pop bc
	pop af
	dec a
	call Profile_SaveToSram
	jp Profile_Edit_Loop

.l563D ; 2A:563D
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D514
	ld a, [de]
	cp a, $00
	jr nz, .l569E

	; [CONFIRMED] 45 insn(s) reached by static flow only; seeds: exec x45; min discovery hops 0;
	; fall-through of the jrcc at 2A:5649 (executed) [executed in 1 scenarios]
	push af
	push bc
	ld de, $40D0
	ld hl, $DA60
	call Sprite_SetPosition
	pop bc
	pop af
	push bc
	ld de, $0214
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push de
	pop de
	farcall Dialog_Show
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	pop bc
	push af
	push bc
	ld de, $4000
	ld hl, $DA60
	call Sprite_SetPosition
	pop bc
	pop af
	jp Label_2A_552A

.l569E ; 2A:569E
	; [CONFIRMED] 22 insn(s); 22 executed (in up to 1/18 scenarios)
	push af
	push bc
	ld de, $40D0
	ld hl, $DA60
	call Sprite_SetPosition
	pop bc
	pop af
	push bc
	ld de, $020E
	pop bc
	push af
	push bc
	ld de, $4000
	ld hl, $DA60
	call Sprite_SetPosition
	pop bc
	pop af
	dec a
	call Profile_SaveToSram
	ld a, [wMailScreenMode]
	dec a
	jp z, Label_2A_5706

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jpcc at 2A:56C5 (executed) [executed in 5 scenarios]
	jp Profile_Edit_Loop

	; [HYPOTHESIS] no branch/call/pointer to any address in $56CB-$56EC was found (tgt scan of all
	; code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen
	; code; linear decode is legal and continues exactly into the next region: call chain (call
	; $6257, 9 x call $577F, jp $54FD, call $62C5): all call targets are known code; directly after
	; the unconditional 'jp $54FD' at 2A:56C8
	call Profile_LoadAndDraw
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	jp Profile_Edit_Loop

	call Profile_SaveToSram

Label_2A_56EC:: ; 2A:56EC
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_2A_5731

	; [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 2A:56F0 (executed) [executed in 5 scenarios]
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc

Label_2A_5706:: ; 2A:5706
	; [CONFIRMED] 21 insn(s); 21 executed (in up to 1/18 scenarios)
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	ld a, $90
	ldh [rWY], a
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	call VBlank_Wait
	ld a, $FF
	ret

Label_2A_5731:: ; 2A:5731
	ldh a, [hJoyPressedRepeat]
	and a, $20
	call nz, Profile_CursorLeft
	ldh a, [hJoyPressedRepeat]
	and a, $10
	call nz, Profile_CursorRight
	ld d, $10
	jp Profile_Edit_Loop

Profile_CursorLeft:: ; 2A:5744
	; [CONFIRMED] 38 insn(s) reached by static flow only; seeds: exec x38; min discovery hops 1;
	; entered by callcc from 2A:5735 (executed) | 18 insn(s) executed; cut out of the PROBABLE
	; region 5744-577F by apply_coverage --split [executed in 1 scenarios]
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0036
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	inc c
	dec c
	jr nz, .l5765
	inc b
	dec b
	ret z

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5744-577F by apply_coverage --split
	dec b
	call $4441
	ld c, e
	ret

.l5765 ; 2A:5765
	; [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 5744-577F by apply_coverage
	; --split [executed in 2 scenarios]
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

Profile_CursorRight:: ; 2A:576B
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0036
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc

Profile_MoveCursorRight:: ; 2A:577F
Function_2A_577F::
	; [CONFIRMED] 1 insn(s); 1 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	jr .l578A

	; [HYPOTHESIS] no branch/call/pointer to any address in $5781-$578A was found (tgt scan of all
	; code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen
	; code; linear decode is legal and continues exactly into the next region: ld a,b; cp 7; jr nz;
	; ld a,c; cp 9; ret z - skipped by the unconditional 'jr $578A' at 2A:577F, falls into 578A
	ld a, b
	cp a, $07
	jr nz, .l578A
	ld a, c
	cp a, $09
	ret z

.l578A ; 2A:578A
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 1/18 scenarios)
	inc c
	dec c
	jr nz, .l579B
	call Profile_CharPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $00
	ret z
.l579B ; 2A:579B
	call Profile_CharPtr
	cp a, $FF
	ret z
	cp a, $0D
	jr nz, .l57AD

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2A:57A3 (executed)
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

.l57AD ; 2A:57AD
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $09
	cp a, c
	ret nz

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the retcc at 2A:57B5 (executed)
	ld c, $08
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

Profile_InitScreen:: ; 2A:57BD
Function_2A_57BD::
	; [CONFIRMED] 123 insn(s); 123 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	ld de, $9301
	ld hl, Gfx_Profile_Tiles9300Vb1
	ld a, $2A
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMA
	call VBlank_Wait
	ld de, $9701
	ld hl, $6700
	ld a, $2A
	ld b, $97
	ld c, $10
	farcall Gfx_StartHDMA
	call VBlank_Wait
	ld de, $8800
	ld hl, $6800
	ld a, $2A
	ld b, $93
	ld c, $34
	farcall Gfx_StartHDMA
	call VBlank_Wait
	ld de, $8000
	ld hl, Gfx_Profile_Tiles8000
	ld a, $26
	ld b, $94
	ld c, $2A
	farcall Gfx_StartHDMA
	call VBlank_Wait
	ld bc, $0040
	ld de, $D840
	ld hl, Palette_Profile_Obj
	ld a, $26
	farcall Palette_LoadToBuffer
	call VBlank_Wait
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_Profile_Bg
	ld a, $2A
	farcall Palette_LoadToBuffer
	call VBlank_Wait
	ld bc, $1214
	ld de, $D000
	ld hl, Data_Profile_TilemapAttr
	ld a, $2A
	farcall Tilemap_CopyRectAndAttr
	call VBlank_Wait
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	ld hl, $DA20
	ld de, $7B50
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	ld hl, $DA30
	ld de, $6E70
	ld a, $2A
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2000
	ld hl, $DA30
	call Sprite_SetPosition
	ld hl, $DA60
	ld de, $6E80
	ld a, $2A
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $4000
	ld hl, $DA60
	call Sprite_SetPosition
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld bc, $0000
	call Profile_PlaceTextCursor
	call Profile_LoadAndDraw
	call VBlank_Wait
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeInFromWhite
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $15
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000F
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	ld bc, $0000
	xor a, a
	ld [wTextEditGoalColumn], a
	ret

Profile_PlaceTextCursor:: ; 2A:590B
	push bc
	ld b, $00
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	inc b
	inc c
	ld a, $2C
.l5918 ; 2A:5918
	dec b
	jr z, .l591F

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 2A:5919 (executed)
	add a, $0C
	jr .l5918

.l591F ; 2A:591F
	; [CONFIRMED] 78 insn(s); 78 executed (in up to 2/18 scenarios)
	ld d, a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, d
	sub a, e
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	ld a, $38
.l592E ; 2A:592E
	dec c
	jr z, .l5935
	add a, $0C
	jr .l592E
.l5935 ; 2A:5935
	ld [wSpriteSlots + 17], a
	ld [wSpriteSlots + 33], a
	push af
	ld a, [wSplitScrollY]
	cp a, $00
	jr z, .skip
	ld a, $D0
	ld [wSpriteSlots + 33], a
.skip ; 2A:5948
	pop af
	pop bc
	ret

Profile_RedrawNickname:: ; 2A:594B
	ld a, $01
	call Profile_DrawNickname
	xor a, a
	ret

Profile_DrawNickname:: ; 2A:5952
	ld a, $10
	ld [wTextCellsLeft], a
.l5957 ; 2A:5957
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l59F4
	cp a, $0D
	jr z, .l59D9
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l59B3
	pop af
	push bc
	push de
	push hl
	push af
	ld a, [hli]
	ld l, a
	pop af
	ld h, a
	ld bc, $C0A0
	ld de, $C0B8
	farcall Glyph_LoadWide
	pop hl
	pop de
	pop bc
	inc hl
	call Profile_DrawNickname_BlitGlyphAdvance
	push bc
	push de
	push hl
	ld hl, $C0B8
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ld a, [wTextCellsLeft]
	dec a
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l59F4
	cp a, $01
	jr z, .l59F4
	jp .l5957

.l59B3 ; 2A:59B3
	; [PROBABLE] 32 insn(s) reached by static flow only; seeds: exec x32; min discovery hops 1;
	; entered by jrcc from 2A:596F (executed)
	pop af
	push bc
	push de
	push hl
	ld b, a
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	call Profile_DrawNickname_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l59F4
	cp a, $01
	jr z, .l59F4
	jp .l5957
.l59D9 ; 2A:59D9
	push bc
	push de
	push hl
	ld b, $3C
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	call Profile_DrawNickname_BlitBlankAdvance

.l59F4 ; 2A:59F4
	; [CONFIRMED] 54 insn(s); 54 executed (in up to 2/18 scenarios)
	push bc
	push de
	push hl
	farcall Glyph_LoadDottedLine
	pop hl
	pop de
	pop bc
.l5A00 ; 2A:5A00
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call Profile_DrawNickname_BlitBlankAdvance
	jr .l5A00

Profile_DrawNickname_BlitGlyphAdvance:: ; 2A:5A0F
	push bc
	push de
	push hl
	ld hl, $C0A0
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

Profile_DrawNickname_BlitBlankAdvance:: ; 2A:5A23
	push bc
	push de
	push hl
	ld b, $02
	ld c, $00
	ld hl, $C0A0
	farcall Canvas_BlitGlyphNoRemap
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

Profile_DrawAddressLine1:: ; 2A:5A3B
	ld a, $0A
	ld [wTextCellsLeft], a

Label_2A_5A40:: ; 2A:5A40
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2A_5ADB
	cp a, $0D
	jr z, Label_2A_5AC0
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2A_5A9B

	; [PROBABLE] 37 insn(s) reached by static flow only; seeds: exec x37; min discovery hops 0;
	; fall-through of the jrcc at 2A:5A58 (executed)
	pop af
	push bc
	push de
	push hl
	push af
	ld a, [hli]
	ld l, a
	pop af
	ld h, a
	ld bc, $C0A0
	ld de, $C0B8
	farcall Glyph_LoadWide
	pop hl
	pop de
	pop bc
	inc hl
	call Profile_DrawAddressLine1_BlitGlyphAdvance
	push bc
	push de
	push hl
	ld hl, $C0B8
	farcall Canvas_BlitGlyph
	pop hl

Label_2A_5A83:: ; 2A:5A83
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ld a, [wTextCellsLeft]
	dec a
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2A_5ADB
	cp a, $01
	jr z, Label_2A_5ADB
	jr Label_2A_5A40

Label_2A_5A9B:: ; 2A:5A9B
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 2/18 scenarios)
	pop af
	push bc
	push de
	push hl
	ld b, a
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	call Profile_DrawAddressLine1_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2A_5ADB
	cp a, $01
	jr z, Label_2A_5ADB
	jr Label_2A_5A40

Label_2A_5AC0:: ; 2A:5AC0
	; [PROBABLE] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 1;
	; entered by jrcc from 2A:5A4E (executed)
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	call Profile_DrawAddressLine1_BlitBlankAdvance

Label_2A_5ADB:: ; 2A:5ADB
	; [CONFIRMED] 56 insn(s); 56 executed (in up to 2/18 scenarios)
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
.loop ; 2A:5AEC
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call Profile_DrawAddressLine1_BlitBlankAdvance
	jr .loop

Profile_DrawAddressLine1_BlitGlyphAdvance:: ; 2A:5AFB
	push bc
	push de
	push hl
	ld hl, $C0A0
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

Profile_DrawAddressLine1_BlitBlankAdvance:: ; 2A:5B0F
	push bc
	push de
	push hl
	ld b, $02
	ld c, $00
	ld hl, $C0A0
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

Profile_DrawAddressLine2:: ; 2A:5B27
	ld a, $10
	ld [wTextCellsLeft], a

Label_2A_5B2C:: ; 2A:5B2C
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2A_5BC7
	cp a, $0D
	jr z, Label_2A_5BAC
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2A_5B87

	; [PROBABLE] 37 insn(s) reached by static flow only; seeds: exec x37; min discovery hops 0;
	; fall-through of the jrcc at 2A:5B44 (executed)
	pop af
	push bc
	push de
	push hl
	push af
	ld a, [hli]
	ld l, a
	pop af
	ld h, a
	ld bc, $C0A0
	ld de, $C0B8
	farcall Glyph_LoadWide
	pop hl
	pop de
	pop bc
	inc hl
	call Profile_DrawAddressLine2_BlitGlyphAdvance
	push bc
	push de
	push hl
	ld hl, $C0B8
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ld a, [wTextCellsLeft]
	dec a
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2A_5BC7

Label_2A_5B81:: ; 2A:5B81
	cp a, $01
	jr z, Label_2A_5BC7
	jr Label_2A_5B2C

Label_2A_5B87:: ; 2A:5B87
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 2/18 scenarios)
	pop af
	push bc
	push de
	push hl
	ld b, a
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	call Profile_DrawAddressLine2_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2A_5BC7
	cp a, $01
	jr z, Label_2A_5BC7
	jr Label_2A_5B2C

Label_2A_5BAC:: ; 2A:5BAC
	; [PROBABLE] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 1;
	; entered by jrcc from 2A:5B3A (executed)
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	call Profile_DrawAddressLine2_BlitBlankAdvance

Label_2A_5BC7:: ; 2A:5BC7
	; [CONFIRMED] 102 insn(s); 102 executed (in up to 2/18 scenarios)
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
.loop ; 2A:5BD8
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call Profile_DrawAddressLine2_BlitBlankAdvance
	jr .loop

Profile_DrawAddressLine2_BlitGlyphAdvance:: ; 2A:5BE7
	push bc
	push de
	push hl
	ld hl, $C0A0
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

Profile_DrawAddressLine2_BlitBlankAdvance:: ; 2A:5BFB
	push bc
	push de
	push hl
	ld b, $02
	ld c, $00
	ld hl, $C0A0
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

Profile_UploadTextTiles:: ; 2A:5C13
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	ld c, $3F
	call Gfx_StartHDMAAtVBlank_2A_5C3B
	ld hl, $D400
	ld de, $9400
	ld c, $37
	call Gfx_StartHDMAAtVBlank_2A_5C3B
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

Gfx_StartHDMAAtVBlank_2A_5C3B:: ; 2A:5C3B
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, $FF44
.l5C4A ; 2A:5C4A
	ld a, [de]
	cp a, $8F
	jr nz, .l5C4A
	ld b, $91
.l5C51 ; 2A:5C51
	ld a, [de]
	cp a, b
	jr nz, .l5C51
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ret

Profile_CharPtr:: ; 2A:5C5B
	push bc
	call Profile_FindLine
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $FF
	cp a, d
	jr z, .l5C83
	inc c
	ld a, [hl]
.loop ; 2A:5C6C
	dec c
	jr z, .l5C81
	inc hl
	inc hl
	ld a, [hl]
	cp a, $00
	jr z, .l5C83
	ld a, [hl]
	cp a, $0D
	jr z, .l5C89
	jr .loop

	; [HYPOTHESIS] no branch/call/pointer to any address in $5C7D-$5C81 was found (tgt scan of all
	; code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen
	; code; linear decode is legal and continues exactly into the next region: inc c; dec c; jr
	; nz,$5C83 - skipped by the unconditional 'jr $5C6C' at 2A:5C7B... falls into 5C81 (pop bc; ret)
	inc c
	dec c
	jr nz, .l5C83

.l5C81 ; 2A:5C81
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)
	pop bc
	ret
.l5C83 ; 2A:5C83
	ld a, $FF
	ld d, $FF
	pop bc
	ret

.l5C89 ; 2A:5C89
	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1;
	; entered by jrcc from 2A:5C79 (executed)
	ld a, $0D
	ld d, $FF
	pop bc
	ret

Profile_FindLine:: ; 2A:5C8F
Function_2A_5C8F::
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D514
	inc b
.l5C9A ; 2A:5C9A
	ld d, $00
	ld e, $0C
	dec b
	jr z, .l5CB3
.l5CA1 ; 2A:5CA1
	ld d, $FF
	ld a, [hl]
	cp a, $00
	jr z, .l5CB3
	inc hl
	inc hl
	cp a, $0D
	jr z, .l5C9A
	dec e
	jr nz, .l5CA1

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 2A:5CAF (executed)
	jr .l5C9A

.l5CB3 ; 2A:5CB3
	; [CONFIRMED] 27 insn(s); 27 executed (in up to 2/18 scenarios)
	ld a, $FF
	cp a, d
	jr z, .l5CCC
	ld e, $00
	push hl
.l5CBB ; 2A:5CBB
	ld a, [hli]
	inc hl
	cp a, $00
	jr z, .l5CCB
	cp a, $0D
	jr z, .l5CCB
	inc e
	ld a, $0B
	cp a, e
	jr nz, .l5CBB
.l5CCB ; 2A:5CCB
	pop hl
.l5CCC ; 2A:5CCC
	xor a, a
	ld [rRAMG], a
	pop bc
	ret

Profile_InsertChar:: ; 2A:5CD2
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D522
	ld a, [hl]
	cp a, $00
	jr z, .l5CF5

	; [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0;
	; fall-through of the jrcc at 2A:5CDE (executed) [executed in 5 scenarios]
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ret

.l5CF5 ; 2A:5CF5
	; [CONFIRMED] 54 insn(s); 54 executed (in up to 2/18 scenarios)
	push de
	push bc
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	push bc
	ld hl, $DA10
	ld de, $7B70
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	call Profile_PlaceTextCursor
	ld d, $14
.l5D22 ; 2A:5D22
	push bc
	push de
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $01
	jr nz, .l5D3E
	dec d
	jr nz, .l5D22
.l5D3E ; 2A:5D3E
	farcall Joypad_ClearAndResetRepeat
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	push bc
	call Profile_PlaceTextCursor
	farcall Sprite_UpdateAll
	pop bc
	pop de
	push de
	push bc
	ld b, $07
	ld c, $00
	call Profile_FindLine
	inc d
	jr z, .l5DAD

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 0;
	; fall-through of the jrcc at 2A:5D6B (executed)
	pop bc
	push bc
	ld c, $0B
.l5D71 ; 2A:5D71
	call Profile_CharPtr
	inc d
	jr nz, .l5D8B
	ld a, e
	cp a, $0B
	jr z, .l5D96
	jr .l5DAD

	; [HYPOTHESIS] no branch/call/pointer to any address in $5D7E-$5D8B was found (tgt scan of all
	; code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen
	; code; linear decode is legal and continues exactly into the next region: ld a,1; ldh [$8D],a;
	; ldh [$70],a; ld a,[hl]; cp $0D; cp 0; jr z,$5DAD - skipped by the unconditional 'jr $5DAD' at
	; 2A:5D7C, falls into 5D8B
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $0D
	cp a, $00
	jr z, .l5DAD

.l5D8B ; 2A:5D8B
	; [PROBABLE] 22 insn(s) reached by static flow only; seeds: exec x22; min discovery hops 1;
	; entered by jrcc from 2A:5D75 (PROBABLE code)
	ld a, $08
	cp a, b
	jr z, .l5D96
	inc b
	ld a, $08
	cp a, b
	jr nz, .l5D71
.l5D96 ; 2A:5D96
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop bc
	pop de
	ret

.l5DAD ; 2A:5DAD
	; [CONFIRMED] 49 insn(s); 49 executed (in up to 2/18 scenarios)
	pop bc
	pop de
	push de
	call Profile_CharPtr
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push de
	push hl
	ld de, $D522
	ld bc, $D520
.l5DC3 ; 2A:5DC3
	ld a, d
	cp a, h
	jr nz, .l5DCB
	ld a, e
	cp a, l
	jr z, .l5DD7
.l5DCB ; 2A:5DCB
	ld a, [bc]
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [de], a
	dec bc
	dec bc
	dec de
	dec de
	jr .l5DC3
.l5DD7 ; 2A:5DD7
	pop hl
	pop de
	pop bc
	ld a, d
	ld [hli], a
	ld a, e
	ld [hl], a
	xor a, a
	ld [rRAMG], a
	push bc
	ld bc, $0300
	ld de, $0000
	ld hl, $D514
	call Profile_RedrawNickname
	call Profile_UploadTextTiles
	pop bc
	ld a, b
	cp a, $07
	jr nz, .l5DFD

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 2A:5DF6 (executed)
	ld a, c
	cp a, $0B
	jr z, .done

.l5DFD ; 2A:5DFD
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 2/18 scenarios)
	call Profile_CharPtr
	cp a, $FF
	jr z, .done
	cp a, $0D
	jr nz, .l5E11

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2A:5E06 (executed)
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	jr .done

.l5E11 ; 2A:5E11
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $0C
	cp a, c
	jr nz, .done

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 2A:5E19 (executed)
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a

.done ; 2A:5E22
	; [CONFIRMED] 31 insn(s); 31 executed (in up to 2/18 scenarios)
	ret

Profile_DeleteChar:: ; 2A:5E23
	push de
	push bc
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0039
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	push bc
	ld hl, $DA10
	ld de, $7B80
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	push bc
	dec b
	ld c, $0B
	call Profile_CharPtr
	pop bc
	push bc
	inc c
	dec c
	jr nz, .l5E60

	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 2A:5E56 (executed) | 3 insn(s) executed; cut out of the PROBABLE
	; region 5E58-5E60 by apply_coverage --split [executed in 4 scenarios]
	ld a, b
	cp a, $00
	jr z, .l5E61

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5E58-5E60 by apply_coverage --split
	dec b
	ld c, e
	inc c

.l5E60 ; 2A:5E60
	; [CONFIRMED] 26 insn(s); 26 executed (in up to 1/18 scenarios)
	dec c
.l5E61 ; 2A:5E61
	call Profile_PlaceTextCursor
	pop bc
	ld d, $14
.loop ; 2A:5E67
	push bc
	push de
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $02
	jr nz, .l5E83
	dec d
	jr nz, .loop
.l5E83 ; 2A:5E83
	farcall Joypad_ClearAndResetRepeat
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	inc c
	dec c
	jr nz, .l5EA9

	; [CONFIRMED] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0;
	; fall-through of the jrcc at 2A:5E9C (executed) | 3 insn(s) executed; cut out of the PROBABLE
	; region 5E9E-5EA9 by apply_coverage --split [executed in 4 scenarios]
	inc b
	dec b
	jr z, .l5EAE

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5E9E-5EA9 by apply_coverage --split
	dec b
	call Profile_CharPtr
	ld c, e
	jr .l5EAE

.l5EA9 ; 2A:5EA9
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 1/18 scenarios)
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a
.l5EAE ; 2A:5EAE
	call Profile_CharPtr
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push de
	push hl
	pop bc
	push hl
	inc bc
	inc bc
	ld e, $00
	ld a, [hl]
	cp a, $0D
	jr nz, .l5EC8

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 2A:5EC4 (executed)
	ld e, $01

.l5EC8 ; 2A:5EC8
	; [CONFIRMED] 29 insn(s); 29 executed (in up to 1/18 scenarios)
	ld a, $22
	cp a, l
	jr nz, .l5ED2
	ld a, $D5
	cp a, h
	jr z, .l5EDA
.l5ED2 ; 2A:5ED2
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
	inc bc
	jr .l5EC8
.l5EDA ; 2A:5EDA
	xor a, a
	ld [hli], a
	ld [hli], a
	ld a, e
	pop hl
	pop de
	pop bc
	ld e, a
	push bc
	ld bc, $0300
	ld de, $0000
	ld hl, $D514
	call Profile_RedrawNickname
	call Profile_UploadTextTiles
	pop bc
	ret

Profile_ApplyDakuten:: ; 2A:5EF4
	; [CONFIRMED] 68 insn(s) reached by static flow only; seeds: exec x68; min discovery hops 1;
	; entered by call from 2A:61EA (PROBABLE code) | 50 insn(s) executed; cut out of the PROBABLE
	; region 5EF4-5F69 by apply_coverage --split [executed in 1 scenarios]
	call Profile_CharPtr
	ld a, $14
	cp a, l
	jr nz, .l5F02
	ld a, $D5
	cp a, h
	jp z, .l5F7D
.l5F02 ; 2A:5F02
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, String_Profile_DakutenKana
.loop ; 2A:5F0E
	ld a, [de]
	inc de
	cp a, $00
	jr z, .l5F71
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, b
	jr nz, .l5F66
	ld a, [hl]
	cp a, c
	jr nz, .l5F66
	inc a
	ld [hl], a
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	xor a, a
	ld [wKeyboardCharLo], a
	pop de
	pop bc
	pop hl
	pop bc
	ld a, c
	cp a, $00
	jr nz, .l5F54

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5EF4-5F69 by apply_coverage --split
	push bc
	ld bc, $0300
	ld de, $0000
	ld hl, $D514
	call Profile_RedrawNickname
	call Profile_UploadTextTiles
	pop bc
	ret

.l5F54 ; 2A:5F54
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 5EF4-5F69 by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	ld bc, $0300
	ld de, $0000
	ld hl, $D514
	call Profile_RedrawNickname
	call Profile_UploadTextTiles
	pop bc
	ret
.l5F66 ; 2A:5F66
	pop hl
	jr .loop

	; [HYPOTHESIS] no branch/call/pointer to any address in $5F69-$5F71 was found (tgt scan of all
	; code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen
	; code; linear decode is legal and continues exactly into the next region: xor a; ldh [$F5],a;
	; ld [$0000],a; pop bc; ret (SRAM-disable epilogue) - after the unconditional 'jr $5F0E' at
	; 2A:5F67
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.l5F71 ; 2A:5F71
	; [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 2;
	; entered by jrcc from 2A:5F12 (PROBABLE code) [executed in 1 scenarios]
	push bc
	push de
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret
.l5F7D ; 2A:5F7D
	push bc
	push de
	pop de
	pop bc
	ret

; ---- text $5F82-$5FD3 (81 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_Profile_DakutenKana:: ; 2A:5F82
String_2A_5F82::
	db "かきくけこさしすせそたちつてとはひふへほカキクケコサシスセソタチツテトハヒフヘホ", 0
POPC

	; [HYPOTHESIS] no branch/call/pointer to any address in $5FD3-$5FD4 was found (tgt scan of all
	; code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen
	; code; linear decode is legal and continues exactly into the next region: lone 'ret' (c9)
	; directly after a NUL-terminated string that follows the function ending before it
	ret

Profile_ApplyVu:: ; 2A:5FD4
	; [CONFIRMED] 66 insn(s) reached by static flow only; seeds: exec x66; min discovery hops 1;
	; entered by call from 2A:61F4 (PROBABLE code) | 48 insn(s) executed; cut out of the PROBABLE
	; region 5FD4-6048 by apply_coverage --split [executed in 1 scenarios]
	call Profile_CharPtr
	ld a, $14
	cp a, l
	jr nz, .l5FE2
	ld a, $D5
	cp a, h
	jp z, .l606C
.l5FE2 ; 2A:5FE2
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, Table_Profile_ApplyVu_LoopPairs
.loop ; 2A:5FEE
	ld a, [de]
	inc de
	cp a, $00
	jr z, .l6050
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, $83
	jr nz, .l6045
	ld a, [hl]
	cp a, $45
	jr nz, .l6045
	ld a, $94
	ld [hl], a
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop hl
	pop bc
	ld a, c
	cp a, $00
	jr nz, .l6033

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5FD4-6048 by apply_coverage --split
	push bc
	ld bc, $0300
	ld de, $0000
	ld hl, $D514
	call Profile_RedrawNickname
	call Profile_UploadTextTiles
	pop bc
	ret

.l6033 ; 2A:6033
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 5FD4-6048 by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	ld bc, $0300
	ld de, $0000
	ld hl, $D514
	call Profile_RedrawNickname
	call Profile_UploadTextTiles
	pop bc
	ret
.l6045 ; 2A:6045
	pop hl
	jr .loop

	; [HYPOTHESIS] no branch/call/pointer to any address in $6048-$6050 was found (tgt scan of all
	; code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen
	; code; linear decode is legal and continues exactly into the next region: xor a; ldh [$F5],a;
	; ld [$0000],a; pop bc; ret (SRAM-disable epilogue) - after the unconditional 'jr $5FEE'
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.l6050 ; 2A:6050
	; [CONFIRMED] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 2;
	; entered by jrcc from 2A:5FF2 (PROBABLE code) [executed in 1 scenarios]
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret
.l606C ; 2A:606C
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ret

; ---- text $6081-$6086 (5 bytes) [PROBABLE] Shift-JIS NUL-terminated string (2 x 82 A4 = full-width 'う' x2); address loaded by 'ld de,$6081' at 2A:5FEA

PUSHC sjis
Table_Profile_ApplyVu_LoopPairs:: ; 2A:6081
String_2A_6081::
	db "うう", 0
POPC

	; [HYPOTHESIS] lone 'ret' (c9) after the string at 6081, before the PROBABLE code at 6087;
	; nothing branches to it
	ret

Profile_ApplyHandakuten:: ; 2A:6087
	; [CONFIRMED] 67 insn(s) reached by static flow only; seeds: exec x67; min discovery hops 1;
	; entered by call from 2A:6208 (PROBABLE code) | 49 insn(s) executed; cut out of the PROBABLE
	; region 6087-60F9 by apply_coverage --split [executed in 1 scenarios]
	call Profile_CharPtr
	ld a, $14
	cp a, l
	jr nz, .l6095
	ld a, $D5
	cp a, h
	jp z, .l611D
.l6095 ; 2A:6095
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, String_Profile_HandakutenKana
.loop ; 2A:60A1
	ld a, [de]
	inc de
	cp a, $00
	jr z, .l6101
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, b
	jr nz, .l60F6
	ld a, [hl]
	cp a, c
	jr nz, .l60F6
	inc a
	inc a
	ld [hl], a
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop hl
	pop bc
	ld a, c
	cp a, $00
	jr nz, .l60E4

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6087-60F9 by apply_coverage --split
	push bc
	ld bc, $0300
	ld de, $0000
	ld hl, $D514
	call Profile_RedrawNickname
	call Profile_UploadTextTiles
	pop bc
	ret

.l60E4 ; 2A:60E4
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 6087-60F9 by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	ld bc, $0300
	ld de, $0000
	ld hl, $D514
	call Profile_RedrawNickname
	call Profile_UploadTextTiles
	pop bc
	ret
.l60F6 ; 2A:60F6
	pop hl
	jr .loop

	; [HYPOTHESIS] no branch/call/pointer to any address in $60F9-$6101 was found (tgt scan of all
	; code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen
	; code; linear decode is legal and continues exactly into the next region: xor a; ldh [$F5],a;
	; ld [$0000],a; pop bc; ret (SRAM-disable epilogue) - after the unconditional 'jr $60A1'
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.l6101 ; 2A:6101
	; [CONFIRMED] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 2;
	; entered by jrcc from 2A:60A5 (PROBABLE code) [executed in 1 scenarios]
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret
.l611D ; 2A:611D
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ret

; ---- text $6132-$6147 (21 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_Profile_HandakutenKana:: ; 2A:6132
String_2A_6132::
	db "はひふへほハヒフヘホ", 0
POPC

	; [HYPOTHESIS] no branch/call/pointer to any address in $6147-$6148 was found (tgt scan of all
	; code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen
	; code; linear decode is legal and continues exactly into the next region: lone 'ret' (c9)
	; directly after a NUL-terminated string
	ret

Profile_KeyboardLoop:: ; 2A:6148
Function_2A_6148::
	; [CONFIRMED] 78 insn(s); 78 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, $07
	farcall Kbd_Open
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	pop bc

Profile_KeyboardLoop_Poll:: ; 2A:617B
	push bc
	call Profile_PlaceTextCursor
	ld d, $70
	farcall Sprite_UpdateAll
	ld a, [wMailScreenMode]
	ld c, a
	ld b, $01
	farcall Kbd_Run
	pop bc
	cp a, $08
	jr z, .l619C
	cp a, $07
	jr nz, .l61CA
.l619C ; 2A:619C
	push af
	push bc
	push de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D514
	ld a, [de]
	cp a, $00
	jr z, .l61C0
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	call Profile_SaveToSram
.l61C0 ; 2A:61C0
	farcall Kbd_Hide
	pop de
	pop bc
	pop af
	ret
.l61CA ; 2A:61CA
	cp a, $00
	jr z, Profile_KeyboardLoop_Poll
	cp a, $09
	ret z
	cp a, $02
	jr z, .l621C
	cp a, $07
	ret z
	cp a, $08
	jr z, .l6223
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, .l61FA

	; [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0;
	; fall-through of the jrcc at 2A:61E1 (executed) [executed in 1 scenarios]
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, .l61FA
	call Profile_ApplyDakuten
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, Profile_KeyboardLoop_Poll
	call Profile_ApplyVu
	jp Profile_KeyboardLoop_Poll

.l61FA ; 2A:61FA
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)
	ld a, [wKeyboardCharLo]
	cp a, $4B
	jr nz, .l620E

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2A:61FF (executed) [executed in 2 scenarios]
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, .l620E
	call Profile_ApplyHandakuten
	jp Profile_KeyboardLoop_Poll

.l620E ; 2A:620E
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)
	ld a, [wKeyboardCharLo]
	ld e, a
	ld a, [wKeyboardCharHi]
	ld d, a
	call Profile_InsertChar
	jp Profile_KeyboardLoop_Poll
.l621C ; 2A:621C
	call Profile_DeleteChar
	jp Profile_KeyboardLoop_Poll

	; [HYPOTHESIS] no branch/call/pointer to any address in $6222-$6223 was found (tgt scan of all
	; code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen
	; code; linear decode is legal and continues exactly into the next region: lone 'ret' (c9) after
	; the unconditional 'jp $617B' at 2A:621F
	ret

.l6223 ; 2A:6223
	; [PROBABLE] 19 insn(s) reached by static flow only; seeds: exec x19; min discovery hops 1;
	; entered by jrcc from 2A:61DA (executed)
	push af
	push bc
	farcall Kbd_HideInstant
	xor a, a
	ld [wTextEditGoalColumn], a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	ld hl, $DA30
	ld de, $6E70
	ld a, $2A
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2000
	ld hl, $DA30
	call Sprite_SetPosition
	pop bc
	call Profile_PlaceTextCursor
	pop af
	ret

	; [HYPOTHESIS] no branch/call/pointer to any address in $6253-$6257 was found (tgt scan of all
	; code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen
	; code; linear decode is legal and continues exactly into the next region: jp $617B ; ret -
	; after the ret at 2A:6252
	jp Profile_KeyboardLoop_Poll

	ret

Profile_LoadAndDraw:: ; 2A:6257
Function_2A_6257::
	; [CONFIRMED] 81 insn(s); 81 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld b, $10
	ld hl, $AF40
	ld de, $D514
.l6274 ; 2A:6274
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .l6274
	ld b, $40
	ld hl, $AF50
	ld de, $D4C0
.l6282 ; 2A:6282
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .l6282
	pop bc
	push bc
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $0000
	ld hl, $D514
	call Profile_RedrawNickname
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $1000
	ld hl, $D4C0
	call Profile_DrawAddressLine1
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $1C00
	ld hl, $D4C9
	call Profile_DrawAddressLine2
	call Profile_UploadTextTiles
	pop bc
	ret

Profile_SaveToSram:: ; 2A:62C5
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld b, $10
	ld de, $AF40
	ld hl, $D514
.l62E2 ; 2A:62E2
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .l62E2
	ld b, $40
	ld de, $AF50
	ld hl, $D4C0
.l62F0 ; 2A:62F0
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .l62F0
	pop bc
	farcall SramCheck_Bank0Commit
	ret

; ---- zero $62FE-$6300 (2 bytes) [PROBABLE] 2 bytes of $00 alignment padding between the last ret and the data block at $6300
	ds $2, $00
