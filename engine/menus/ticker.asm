; engine/menus/ticker.asm
; bank 48, $4223-$44E0 (701 bytes); pinned by layout.link
; scrolling description ticker (Ticker_*)

SECTION "engine/menus/ticker", ROMX

Ticker_Update:: ; 48:4223
	; [CONFIRMED] 481 insn(s); 481 executed (in up to 12/18 scenarios) (part of region $4222-$4615)
	ld a, [wTickerPauseFrames]
	or a, a
	jr z, .l422E
	dec a
	ld [wTickerPauseFrames], a
	ret
.l422E ; 48:422E
	ld hl, wTickerFrameDivider
	dec [hl]
	ret nz
	ld [hl], $02
	ld a, [wTickerScrollX]
	and a, $01
	jr z, .l424F
	ld hl, wTickerStepCounter
	dec [hl]
	jr nz, .l424F
	ld a, [wTickerColumnCount]
	sla a
	sla a
	ld [hl], a
	ld a, $B4
	ld [wTickerPauseFrames], a
.l424F ; 48:424F
	ld a, [wTickerScrollX]
	inc a
	ld [wTickerScrollX], a
	dec a
	and a, $07
	ret nz
	ld a, [wRam_C0F6]
	add a, $16
	and a, $1F
	swap a
	ld e, a
	and a, $0F
	add a, $94
	ld d, a
	ld a, e
	and a, $F0
	ld e, a
	ld a, [wTickerSrcColumn]
	inc a
	swap a
	ld l, a
	and a, $0F
	add a, $D0
	ld h, a
	ld a, l
	and a, $F0
	ld l, a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push hl
	push de
	ld a, $00
	ld b, $98
	ld c, $01
	farcall Gfx_StartHDMAWithService
	call Sound_FrameService
	pop de
	pop hl
	ld a, d
	add a, $02
	ld d, a
	ld a, h
	add a, $04
	ld h, a
	ld a, $00
	ld b, $98
	ld c, $01
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, [wRam_C0F6]
	inc a
	and a, $1F
	ld [wRam_C0F6], a
	ld a, [wTickerSrcColumn]
	inc a
	ld [wTickerSrcColumn], a
	ld hl, wTickerColumnCount
	cp a, [hl]
	ret nz
	xor a, a
	ld [wTickerSrcColumn], a
	ret

Ticker_Start:: ; 48:42D4
	ld d, a
	call ReadByteFar
	ld [wTickerTextBank], a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, b
	add a, a
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, d
	call ReadByteFar
	ld [wTickerTitlePtr], a
	ld b, a
	ld a, d
	call ReadByteFar
	ld [wTickerTitlePtr + 1], a
	push hl
	ld h, a
	ld l, b
	ld c, $00
	ld a, [wTickerTextBank]
	ld e, a
.l4309 ; 48:4309
	ld a, e
	call ReadByteFar
	or a, a
	jr z, .l431A
	ld a, e
	call ReadByteFar
	or a, a
	jr z, .l431A
	inc c
	jr .l4309
.l431A ; 48:431A
	ld a, c
	sla a
	sla a
	ld b, a
	ld a, $50
	sub a, b
	ld [wTickerTitleX], a
	ld a, $14
	ld [wTickerSrcColumn], a
	ld a, d
	pop hl
	call ReadByteFar
	ld [wTickerTextPtr], a
	ld b, a
	ld a, d
	call ReadByteFar
	ld [wTickerTextPtr + 1], a
	ld h, a
	ld l, b
	ld c, $00
	ld a, [wTickerTextBank]
	ld e, a
.l4343 ; 48:4343
	ld a, e
	call ReadByteFar
	or a, a
	jr z, .l4354
	ld a, e
	call ReadByteFar
	or a, a
	jr z, .l4354
	inc c
	jr .l4343
.l4354 ; 48:4354
	ld a, c
	add a, $15
	ld [wTickerColumnCount], a
	sla a
	sla a
	add a, $04
	ld [wTickerStepCounter], a
	ld a, $B4
	ld [wTickerPauseFrames], a
	ld a, $02
	ld [wTickerFrameDivider], a
	ld a, [wTickerTitleX]
	and a, $07
	ld b, a
	ld a, $08
	sub a, b
	push af
	call Ticker_Stop
	pop af
	ld [wTickerScrollX], a
	ld a, [wTickerTitleX]
	srl a
	srl a
	srl a
	inc a
	ld b, a
	ld a, [wTickerTitlePtr]
	ld l, a
	ld a, [wTickerTitlePtr + 1]
	ld h, a
	ld c, $40
	ld de, wTileStage2
	ld a, $02
	ldh [hTextTiles_DestBank], a
	dec a
	ldh [hTextTiles_GridRowEnd], a
	dec a
	ldh [hTextTiles_GridRow], a
	ld a, [wTickerTextBank]
	farcall TextTiles_RenderGridRows
	ld b, $15
	ld a, [wTickerTextPtr]
	ld l, a
	ld a, [wTickerTextPtr + 1]
	ld h, a
	ld c, $40
	ld de, wTileStage2
	ld a, $02
	ldh [hTextTiles_DestBank], a
	dec a
	ldh [hTextTiles_GridRowEnd], a
	dec a
	ldh [hTextTiles_GridRow], a
	ld a, [wTickerTextBank]
	farcall TextTiles_RenderGridRows
	ldh a, [rIE]
	and a, $02
	call z, Ticker_InstallRasterIrq
	xor a, a
	ld [wRam_C0F6], a
	call Sound_FrameService
	ld de, $9400
	ld hl, wTileStage2
	ld a, $00
	ld b, $97
	ld c, $14
	farcall Gfx_StartHDMAWithService
	call Sound_FrameService
	ld de, $9600
	ld hl, wTileStage2 + $400
	ld a, $00
	ld b, $97
	ld c, $14
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Ticker_InstallRasterIrq:: ; 48:440A
	di
	ld a, $08
	ldh [rSTAT], a
	ld a, $80
	ldh [rLYC], a
	ld a, [wLcdStatVector]
	ld [wSavedLcdStatVector], a
	ld a, [wLcdStatVector + 1]
	ld [wSavedLcdStatVector + 1], a
	ld a, [wLcdStatVector + 2]
	ld [wSavedLcdStatVector + 2], a
	ld a, [wVBlankVector]
	ld [wSavedVBlankVector], a
	ld a, [wVBlankVector + 1]
	ld [wSavedVBlankVector + 1], a
	ld a, [wVBlankVector + 2]
	ld [wSavedVBlankVector + 2], a
	ld a, $C3
	ld [wLcdStatVector], a
	ld a, $C4
	ld [wLcdStatVector + 1], a
	ld a, $16
	ld [wLcdStatVector + 2], a
	ld a, $C3
	ld [wVBlankVector], a
	ld a, $D4
	ld [wVBlankVector + 1], a
	ld a, $16
	ld [wVBlankVector + 2], a
	ldh a, [rIE]
	or a, $03
	ldh [rIE], a
	xor a, a
	ldh [rIF], a
	ei
	ret

Ticker_Stop:: ; 48:4460
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0800
	ld hl, wTileStage2
	call FillBytes
	call Sound_FrameService
	ld de, $9400
	ld hl, wTileStage2
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	call Sound_FrameService
	ld de, $9600
	ld hl, wTileStage2
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ldh a, [rIE]
	and a, $02
	jr z, .l44D6
	di
	ldh a, [rSTAT]
	and a, $87
	ldh [rSTAT], a
	ld hl, wLcdStatVector
	ld a, [wSavedLcdStatVector]
	ld [hli], a
	ld a, [wSavedLcdStatVector + 1]
	ld [hli], a
	ld a, [wSavedLcdStatVector + 2]
	ld [hl], a
	ld hl, wVBlankVector
	ld a, [wSavedVBlankVector]
	ld [hli], a
	ld a, [wSavedVBlankVector + 1]
	ld [hli], a
	ld a, [wSavedVBlankVector + 2]
	ld [hl], a
	ldh a, [rIE]
	and a, $FD
	ldh [rIE], a
	xor a, a
	ldh [rIF], a
	ei
.l44D6 ; 48:44D6
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret
