; engine/comm/notice_dialog.asm
; bank 50, $4000-$439A (922 bytes); pinned by layout.link
; connection-time notice dialog (continue? yes/no or alert)

SECTION "engine/comm/notice_dialog", ROMX

CommNotice_ShowDialog:: ; 50:4000
	; [CONFIRMED] 217 insn(s) reached by static flow only; seeds: exec x217; min discovery hops 1;
	; entered by far from 4E:50DD (PROBABLE code) | 99 insn(s) executed; cut out of the PROBABLE
	; region 4000-4244 by apply_coverage --split [executed in 2 scenarios]
	ld a, [wRam_C1D0]
	inc a
	ld b, a
	ld a, [wRam_C1D1]
	inc a
	ld c, a
	ldh a, [rLCDC]
	and a, $04
	push af
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	call CommNotice_RunDialog
	or a, a
	jr nz, .l4050
	farcall Sprite_ResetAll
	ld de, $010F
	farcall Dialog_Open
	farcall Comm_Disconnect
	farcall Dialog_Close
	ld de, $0110
	farcall Dialog_Show
	farcall Palette_FadeOutToWhite
	pop bc
	ldh a, [rLCDC]
	and a, $FB
	or a, b
	ldh [rLCDC], a
	ld a, $01
	ret
.l4050 ; 50:4050
	farcall Palette_FadeOutToWhite
	pop bc
	ldh a, [rLCDC]
	and a, $FB
	or a, b
	ldh [rLCDC], a
	ld a, $00
	ret

CommNotice_RunDialog:: ; 50:4061
	push bc
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4
	call FillBytes
	farcall Function_48_48BB
	pop bc
	ld a, c
	dec a
	ld [wRam_C0D6], a
	ld a, b
	dec a
	ld [wRam_C0D8], a
	ld a, $00
	ld [wRam_C0D4], a
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
	ld a, [wRam_C0D6]
	or a, a
	jp nz, .l4173
	ld de, $9000
	ld hl, Gfx_CommNotice_A_Tiles9000
	ld a, $50
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, Gfx_CommNotice_A_Tiles9400
	ld a, $50
	ld b, $96
	ld c, $1A
	farcall Gfx_StartHDMAWithService
	ld de, $8001
	ld hl, Gfx_CommNotice_A_Tiles8000Vb1
	ld a, $50
	ld b, $98
	ld c, $01
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_CommNotice_A_Tiles9000Vb1
	ld a, $50
	ld b, $94
	ld c, $32
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_CommNotice
	ld a, $50
	farcall Palette_LoadToBuffer
	ld a, [wRam_C0D8]
	or a, a
	jr nz, .l4129

	; [PROBABLE] 16 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4000-4244 by apply_coverage --split
	ld a, $F0
	ld hl, $C26E
	call ReadByteFar
	cp a, $3C
	jr c, .l4121
	ld a, $F0
	ld hl, $C2D6
	call ReadByteFar
	cp a, $3C
	jr c, .l4121
	ld a, $01
	ld [wRam_C1CD], a
	jp CommNotice_DrawScreenAndLoop
.l4121 ; 50:4121
	ld a, $03
	ld [wRam_C1CD], a
	jp CommNotice_DrawScreenAndLoop

.l4129 ; 50:4129
	; [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 4000-4244 by apply_coverage
	; --split [executed in 4 scenarios]
	ld a, $F0
	ld hl, $C26E
	call ReadByteFar
	cp a, $3C
	jr c, .l4148

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4000-4244 by apply_coverage --split
	ld a, $F0
	ld hl, $C2D6
	call ReadByteFar
	cp a, $3C
	jr c, .l4148
	ld a, $02
	ld [wRam_C1CD], a
	jr .l414F

.l4148 ; 50:4148
	; [CONFIRMED] 14 insn(s) executed; cut out of the PROBABLE region 4000-4244 by apply_coverage
	; --split [executed in 4 scenarios]
	ld a, $04
	ld [wRam_C1CD], a
	jr .l414F
.l414F ; 50:414F
	ld hl, $DA10
	ld de, CommNotice_ObjTable
	ld a, $50
	ld b, $80
	farcall Sprite_InitSlot
	ld bc, $0040
	ld de, $D840
	ld hl, $6C40
	ld a, $50
	farcall Palette_LoadToBuffer
	jp CommNotice_DrawScreenAndLoop

.l4173 ; 50:4173
	; [PROBABLE] 75 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4000-4244 by apply_coverage --split
	ld de, $9000
	ld hl, Gfx_CommNotice_B_Tiles9000
	ld a, $50
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, Gfx_CommNotice_B_Tiles9400
	ld a, $50
	ld b, $96
	ld c, $1A
	farcall Gfx_StartHDMAWithService
	ld de, $8001
	ld hl, Gfx_CommNotice_B_Tiles8000Vb1
	ld a, $50
	ld b, $98
	ld c, $01
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_CommNotice_B_Tiles9000Vb1
	ld a, $50
	ld b, $94
	ld c, $32
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, $D800
	ld hl, $6C00
	ld a, $50
	farcall Palette_LoadToBuffer
	ld a, [wRam_C0D8]
	or a, a
	jr nz, .l41FA
	ld a, $F0
	ld hl, $C26E
	call ReadByteFar
	cp a, $3C
	jr c, .l41F2
	ld a, $F0
	ld hl, $C2D6
	call ReadByteFar
	cp a, $3C
	jr c, .l41F2
	ld a, $05
	ld [wRam_C1CD], a
	jp CommNotice_DrawScreenAndLoop
.l41F2 ; 50:41F2
	ld a, $07
	ld [wRam_C1CD], a
	jp CommNotice_DrawScreenAndLoop
.l41FA ; 50:41FA
	ld a, $F0
	ld hl, $C26E
	call ReadByteFar
	cp a, $3C
	jr c, .l4219
	ld a, $F0
	ld hl, $C2D6
	call ReadByteFar
	cp a, $3C
	jr c, .l4219
	ld a, $06
	ld [wRam_C1CD], a
	jr .l4220
.l4219 ; 50:4219
	ld a, $08
	ld [wRam_C1CD], a
	jr .l4220
.l4220 ; 50:4220
	ld hl, $DA10
	ld de, $6D1A
	ld a, $50
	ld b, $80
	farcall Sprite_InitSlot
	ld bc, $0040
	ld de, $D840
	ld hl, $6C80
	ld a, $50
	farcall Palette_LoadToBuffer
	jp CommNotice_DrawScreenAndLoop

; ---- ptrtable $4244-$4254 (16 bytes) [PROBABLE] little-endian word table, 8 entries, monotone=1.00, 0% of targets on string start/after NUL, targets $439A..$574A; referenced by ld r16,$4244 at 50:4259; verifier: dropped first entry (operand of the preceding jp/call at 4241)

Table_CommNotice_Screens:: ; 50:4244
Table_50_4244::
	dw Tilemap_CommNotice_A_CutOver60
	dw Tilemap_CommNotice_A_AskOver60
	dw Tilemap_CommNotice_A_CutSoon
	dw Tilemap_CommNotice_A_AskSoon
	dw Tilemap_CommNotice_B_CutOver60
	dw Tilemap_CommNotice_B_AskOver60
	dw Tilemap_CommNotice_B_CutSoon
	dw Tilemap_CommNotice_B_AskSoon

CommNotice_DrawScreenAndLoop:: ; 50:4254
	; [CONFIRMED] 34 insn(s) reached by static flow only; seeds: exec x34; min discovery hops 3;
	; entered by jp from 50:411E (PROBABLE code) [executed in 1 scenarios]
	ld a, [wRam_C1CD]
	dec a
	add a, a
	ld hl, Table_CommNotice_Screens
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $D000
	ld bc, $1214
	ld a, $50
	farcall Tilemap_CopyRectAndAttr
	call CommNotice_DrawChoiceCursor
	call CommNotice_DrawMinuteDigit
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	farcall Sprite_UpdateAll
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $001D
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a

Label_50_429A:: ; 50:429A
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $42AC-$42B6 (10 bytes) [PROBABLE] inline table of `call $056A` (JoypadDispatch) at 50:42A9: 5 entries; fixed length (5 words) by the routine

CommNotice_InputTable:: ; 50:42AC
Table_50_42AC::
	dw Label_50_42EB
	dw Label_50_430A
	dw Label_50_430A
	dw Label_50_430A
	dw Label_50_42B6

Label_50_42B6:: ; 50:42B6
	; [CONFIRMED] 109 insn(s) reached by static flow only; seeds: exec x109; min discovery hops 4;
	; entered by table from 50:42A9 (PROBABLE code) | 18 insn(s) executed; cut out of the PROBABLE
	; region 42B6-438A by apply_coverage --split [executed in 4 scenarios]
	ldh a, [hJoyPressedRepeat]
	and a, $F0
	call nz, CommNotice_HandleLeftRight
	ld a, [wRam_C14E]
	inc a
	ld [wRam_C14E], a
	cp a, $3C
	jp nz, Label_50_429A
	xor a, a
	ld [wRam_C14E], a
	ld a, [wRam_C14F]
	inc a
	ld [wRam_C14F], a
	ld b, a
	ld a, [wRam_C0D8]
	or a, a
	ld a, b
	jp nz, .l42E4

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 42B6-438A by apply_coverage --split
	cp a, $0A
	jr z, Label_50_42EB
	jp Label_50_429A

.l42E4 ; 50:42E4
	; [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 42B6-438A by apply_coverage
	; --split [executed in 2 scenarios]
	cp a, $0A
	jr z, Label_50_4301
	jp Label_50_429A

Label_50_42EB:: ; 50:42EB
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, [wRam_C0D8]
	or a, a
	jr nz, Label_50_4304

Label_50_4301:: ; 50:4301
	ld a, $00
	ret

Label_50_4304:: ; 50:4304
	ld a, [wRam_C0D4]
	xor a, $01
	ret

Label_50_430A:: ; 50:430A
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 42B6-438A by apply_coverage --split
	jr Label_50_429A

CommNotice_HandleLeftRight:: ; 50:430C
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 42B6-438A by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, [wRam_C0D8]
	or a, a
	ret z
	ldh a, [hJoyPressedRepeat]
	bit 4, a
	jr nz, .l431C
	bit 5, a
	jr nz, .l431C
	ret

.l431C ; 50:431C
	; [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 42B6-438A by apply_coverage --split
	ld a, [wRam_C0D4]
	xor a, $01
	ld [wRam_C0D4], a
	call CommNotice_DrawChoiceCursor
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ret

CommNotice_DrawChoiceCursor:: ; 50:4338
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 42B6-438A by apply_coverage
	; --split [executed in 4 scenarios]
	ld a, [wRam_C0D4]
	or a, a
	jr nz, .l4348
	ld de, $6727
	ld hl, $DA10
	call Sprite_SetPosition
	ret

.l4348 ; 50:4348
	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 42B6-438A by apply_coverage --split
	ld de, $6757
	ld hl, $DA10
	call Sprite_SetPosition
	ret

CommNotice_DrawMinuteDigit:: ; 50:4352
	; [CONFIRMED] 35 insn(s) executed; cut out of the PROBABLE region 42B6-438A by apply_coverage
	; --split [executed in 4 scenarios]
	ld a, [wRam_C1CD]
	dec a
	add a, a
	ld hl, Table_CommNotice_DigitCells
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld a, $F0
	ld hl, $C26E
	call ReadByteFar
	inc a
	ld b, a
	ld c, $0A
	farcall Divide8
	ld a, b
	dec a
	dec a
	pop hl
	cp a, $07
	ret nc
	ld b, a
	ld a, $26
	add a, b
	ld [hl], a
	ld de, $0020
	add hl, de
	add a, $06
	ld [hl], a
	ret

; ---- words $438A-$439A (16 bytes) [PROBABLE] 8 WRAM tilemap-buffer addresses ($D0A3,$D083,$D0E4,$D0C4 twice) indexed by (wRam_C1CD-1)*2 at 50:4352 (ld hl,$438A; word read); the code writes a tile id ($26+n) through it and the row below (+$20). Values are WRAM addresses, not ROM pointers.

Table_CommNotice_DigitCells:: ; 50:438A
Table_50_438A::
	dw $D0A3, $D083, $D0E4, $D0C4, $D0A3, $D083, $D0E4, $D0C4
