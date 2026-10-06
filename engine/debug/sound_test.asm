; engine/debug/sound_test.asm
; bank 1B, $4000-$446B (1131 bytes); pinned by layout.link
; sound test screen (unreferenced) with its own palette

SECTION "engine/debug/sound_test", ROMX

; ---- data $4000-$4040 (64 bytes) [PROBABLE] palette-rgb555: heuristic: 32 RGB555 words as 8 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Palette_DebugScreens1B:: ; 1B:4000
Data_1B_4000::
	db $00, $00, $1B, $25, $9F, $51, $FF, $7F, $FF, $7F, $4A, $29, $B5, $56, $00, $00
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F

SoundTest_Run:: ; 1B:4040
	; [HYPOTHESIS] function head xor a ; ld bc,$00FC ; ld hl,$C0D4 ; call $04D8 (fill) that falls
	; exactly into the raw far-call site at 404A (PROBABLE code); right after the data block
	; 4000-4040; entry not located, no caller/table word anywhere (downgraded PROBABLE -> HYPOTHESIS
	; by the adversarial verifier, same class as 04:415A and 7C:7D8B: bytes that merely lead into
	; code are not proven code) | forced execution: 4/4 instruction starts ran in forced_debug
	; (traces/forced/, not natural evidence; status unchanged)
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4 ; raw: start of the 252-byte per-screen window wipe
	call FillBytes

	; [PROBABLE] 125 insn(s) reached by static flow only; seeds: site x125; min discovery hops 0;
	; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code |
	; forced execution: 125/125 instruction starts ran in forced_debug (traces/forced/, not natural
	; evidence; status unchanged)
	farcall Stub_Nop_48_48BB
	call LCDOff
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
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage3
	ld bc, $0800
	xor a, a
	call FillBytes
	ld de, $8000
	ld hl, wTileStage3
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8400
	ld hl, wTileStage3
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8800
	ld hl, wTileStage3
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C00
	ld hl, wTileStage3
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9000
	ld hl, wTileStage3
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, wTileStage3
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8001
	ld hl, wTileStage3
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8401
	ld hl, wTileStage3
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8801
	ld hl, wTileStage3
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, wTileStage3
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, wTileStage3
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, wTileStage3
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_DebugScreens1B
	ld a, $1B
	farcall Palette_LoadToBuffer
	ld a, $80
	ld bc, $0400
	ld hl, wScreenTileMap
	call FillBytes
	ld hl, wScreenAttrMap
	ld bc, $1214
	ld de, $0009
	xor a, a
	farcall Tilemap_ApplyMaskRect
	ld a, $80
	ld bc, $0810
	ld de, $F001
	ld hl, wScreenTileMap + $142
	farcall Tilemap_FillRectSequential
	call SoundTest_LoadHelpText
	call SoundTest_DrawNumber
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	farcall Sprite_UpdateAll
	call LCDOn
	farcall Palette_FadeInFromWhite

SoundTest_Loop:: ; 1B:41B1
	call VBlank_WaitAndService
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $41C3-$41CD (10 bytes) [PROBABLE] inline table of `call $056A` (JoypadDispatch) at 1B:41C0: 5 entries; fixed length (5 words) by the routine

Table_SoundTest_Buttons:: ; 1B:41C3
Table_1B_41C3::
	dw SoundTest_OnA
	dw SoundTest_OnB
	dw SoundTest_OnSelect
	dw SoundTest_OnStart
	dw SoundTest_Idle

SoundTest_Idle:: ; 1B:41CD
	; [PROBABLE] 148 insn(s) reached by static flow only; seeds: site x148; min discovery hops 0;
	; entered by table from 1B:41C0 (PROBABLE code) | forced execution: 130/148 instruction starts
	; ran in forced_debug (traces/forced/, not natural evidence; status unchanged)
	call SoundTest_UpdateHoldTimer
	ldh a, [hJoyPressedRepeat]
	call SoundTest_HandleDpad
	jp SoundTest_Loop

SoundTest_OnA:: ; 1B:41D8
	ld a, [wSoundTest_NumberLo]
	ld c, a
	ld a, [wSoundTest_NumberHi]
	ld b, a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_PlayMusic
	pop af
	ldh [rSVBK], a
	jp SoundTest_Loop

SoundTest_OnB:: ; 1B:41F0
	ld a, [wSoundTest_NumberLo]
	ld c, a
	ld a, [wSoundTest_NumberHi]
	ld b, a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	jp SoundTest_Loop

SoundTest_OnSelect:: ; 1B:4208
	ld bc, $0000
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_PauseMusic
	pop af
	ldh [rSVBK], a
	ld bc, $0000
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_StopSfxById
	pop af
	ldh [rSVBK], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_FrameTick
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutToWhite
	ld a, $01
	ret

SoundTest_OnStart:: ; 1B:423E
	ld bc, $0000
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_PauseMusic
	pop af
	ldh [rSVBK], a
	ld bc, $0000
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_StopSfxById
	pop af
	ldh [rSVBK], a
	jp SoundTest_Loop

SoundTest_HandleDpad:: ; 1B:4261
	bit 6, a
	jr nz, .l4272
	bit 7, a
	jr nz, .l427D
	bit 4, a
	jr nz, .l42A6
	bit 5, a
	jr nz, .l4288
	ret
.l4272 ; 1B:4272
	ld a, [wSoundTest_NumberHi]
	inc a
	ld [wSoundTest_NumberHi], a
	call SoundTest_DrawNumber
	ret
.l427D ; 1B:427D
	ld a, [wSoundTest_NumberHi]
	dec a
	ld [wSoundTest_NumberHi], a
	call SoundTest_DrawNumber
	ret
.l4288 ; 1B:4288
	ld a, [wSoundTest_HoldCounter]
	cp a, $3C
	jr nc, .l429A
	ld a, [wSoundTest_NumberLo]
	dec a
	ld [wSoundTest_NumberLo], a
	call SoundTest_DrawNumber
	ret
.l429A ; 1B:429A
	ld a, [wSoundTest_NumberLo]
	sub a, $04
	ld [wSoundTest_NumberLo], a
	call SoundTest_DrawNumber
	ret
.l42A6 ; 1B:42A6
	ld a, [wSoundTest_HoldCounter]
	cp a, $3C
	jr nc, .l42B8
	ld a, [wSoundTest_NumberLo]
	inc a
	ld [wSoundTest_NumberLo], a
	call SoundTest_DrawNumber
	ret
.l42B8 ; 1B:42B8
	ld a, [wSoundTest_NumberLo]
	add a, $04
	ld [wSoundTest_NumberLo], a
	call SoundTest_DrawNumber
	ret

SoundTest_LoadHelpText:: ; 1B:42C4
	ld hl, $4314
	ld de, wTileStage3
	ld bc, $0010
	ld a, $03
	ldh [hTextTiles_DestBank], a
	ld a, $1B
	farcall TextTiles_RenderGrid
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $8800
	ld hl, wTileStage3
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C00
	ld hl, wTileStage3 + $400
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- text $4314-$4371 (93 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_SoundTest_Help:: ; 1B:4314
String_1B_4314::
	db "　Ａ：ＭＵＳＩＣ　Ｂ：ＳＯＵＮＤＳｔａ：ＳＴＯＰ　Ｓｅｌ：ＥＮＤ　↑↓（←→）：Ｎｕｍｂｅｒ", 0
POPC

SoundTest_DrawNumber:: ; 1B:4371
	; [PROBABLE] 115 insn(s) reached by static flow only; seeds: site x115; min discovery hops 4;
	; entered by call from 1B:419A (PROBABLE code) | forced execution: 115/115 instruction starts
	; ran in forced_debug (traces/forced/, not natural evidence; status unchanged)
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage3
	ld bc, $0400
	xor a, a
	call FillBytes
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D000 ; raw: string scratch of bank 2 (Shift-JIS text built here, rendered by TextTiles_RenderGrid with A = 2), not tile staging
	ld a, $81
	ld [de], a
	inc de
	ld a, $79
	ld [de], a
	inc de
	ld a, [wSoundTest_NumberHi]
	ld b, a
	swap a
	and a, $0F
	add a, a
	ld hl, String_SoundTest_HexChars
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, b
	and a, $0F
	add a, a
	ld hl, String_SoundTest_HexChars
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [wSoundTest_NumberLo]
	ld b, a
	swap a
	and a, $0F
	add a, a
	ld hl, String_SoundTest_HexChars
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, b
	and a, $0F
	add a, a
	ld hl, String_SoundTest_HexChars
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, $81
	ld [de], a
	inc de
	ld a, $7A
	ld [de], a
	inc de
	xor a, a
	ld [de], a
	ld hl, $D000
	ld de, wTileStage3
	ld bc, $0010
	ld a, $03
	ldh [hTextTiles_DestBank], a
	ld a, $02
	farcall TextTiles_RenderGrid
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $8E00
	ld hl, wTileStage3
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- text $4430-$4450 (32 bytes) [PROBABLE] 16 fullwidth Shift-JIS characters "０１２３４５６７８９ＡＢＣＤＥＦ" (82 4F..82 58, 82 60..82 65), 2 bytes each, no NUL: hex-digit glyph table loaded by many `ld hl,$4430` (1B:43A2, 43B5, 43CD, 43E0 ...) in the preceding routine

PUSHC sjis
String_SoundTest_HexChars:: ; 1B:4430
String_1B_4430::
	db "０１２３４５６７８９ＡＢＣＤＥＦ"
POPC

SoundTest_UpdateHoldTimer:: ; 1B:4450
	; [PROBABLE] 14 insn(s) reached by static flow only; seeds: site x14; min discovery hops 2;
	; entered by call from 1B:41CD (PROBABLE code) | forced execution: 14/14 instruction starts ran
	; in forced_debug (traces/forced/, not natural evidence; status unchanged)
	ld a, [wSoundTest_PrevHeld]
	ld b, a
	ldh a, [hJoyHeld]
	cp a, b
	jr z, .l4461
	ld [wSoundTest_PrevHeld], a
	xor a, a
	ld [wSoundTest_HoldCounter], a
	ret
.l4461 ; 1B:4461
	ld a, [wSoundTest_HoldCounter]
	add a, $01
	ret c
	ld [wSoundTest_HoldCounter], a
	ret
