; engine/gfx/palette_fade_ticker.asm
; bank 48, $46C6-$4728 (98 bytes); pinned by layout.link
; Palette_FadeOutWithTicker

SECTION "engine/gfx/palette_fade_ticker", ROMX

Palette_FadeOutWithTicker:: ; 48:46C6
	; [CONFIRMED] 141 insn(s); 141 executed (in up to 14/18 scenarios) (part of region $462A-$4744)
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $04
	ld [wPaletteTicker_StepFrames], a
	ld bc, $0080
	ld de, wPaletteFadeFrom
	ld hl, wPaletteBufBg
	call CopyBytes
	ld a, $00
	ld [wPalFadeMode], a
	ld bc, $7FFF
	ld a, $30
	farcall PalFade_Start
	farcall PalFade_Step
.loop ; 48:46FA
	call VBlank_WaitStartDI
	ld hl, wPaletteBufBg
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
	call Ticker_Update
	ld hl, wPaletteTicker_StepFrames
	dec [hl]
	jr nz, .loop
	ld [hl], $04
	farcall PalFade_Step
	or a, a
	jr nz, .loop
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret
