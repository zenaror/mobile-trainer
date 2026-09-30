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
	ld hl, $C0D4
	call FillBytes

	; [PROBABLE] 125 insn(s) reached by static flow only; seeds: site x125; min discovery hops 0;
	; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code |
	; forced execution: 125/125 instruction starts ran in forced_debug (traces/forced/, not natural
	; evidence; status unchanged)
	farcall Function_48_48BB
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
	farcall Function_00_09B6
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $0800
	xor a, a
	call FillBytes
	ld de, $8000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8400
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8800
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C00
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9400
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8001
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8401
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8801
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_DebugScreens1B
	ld a, $1B
	farcall Palette_LoadToBuffer
	ld a, $80
	ld bc, $0400
	ld hl, $D000
	call FillBytes
	ld hl, $D400
	ld bc, $1214
	ld de, $0009
	xor a, a
	farcall Function_00_091C
	ld a, $80
	ld bc, $0810
	ld de, $F001
	ld hl, $D142
	farcall Tilemap_FillRectSequential
	call SoundTest_LoadHelpText
	call SoundTest_DrawNumber
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	call LCDOn
	farcall Palette_FadeInFromWhite

SoundTest_Loop:: ; 1B:41B1
	call Function_00_044B
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
	ld a, [wRam_C0E5]
	ld c, a
	ld a, [wRam_C0D6]
	ld b, a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20B2
	pop af
	ldh [rSVBK], a
	jp SoundTest_Loop

SoundTest_OnB:: ; 1B:41F0
	ld a, [wRam_C0E5]
	ld c, a
	ld a, [wRam_C0D6]
	ld b, a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	jp SoundTest_Loop

SoundTest_OnSelect:: ; 1B:4208
	ld bc, $0000
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20C4
	pop af
	ldh [rSVBK], a
	ld bc, $0000
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20BE
	pop af
	ldh [rSVBK], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20A6
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
	call Function_00_20C4
	pop af
	ldh [rSVBK], a
	ld bc, $0000
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20BE
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
	ld a, [wRam_C0D6]
	inc a
	ld [wRam_C0D6], a
	call SoundTest_DrawNumber
	ret
.l427D ; 1B:427D
	ld a, [wRam_C0D6]
	dec a
	ld [wRam_C0D6], a
	call SoundTest_DrawNumber
	ret
.l4288 ; 1B:4288
	ld a, [wRam_C0E7]
	cp a, $3C
	jr nc, .l429A
	ld a, [wRam_C0E5]
	dec a
	ld [wRam_C0E5], a
	call SoundTest_DrawNumber
	ret
.l429A ; 1B:429A
	ld a, [wRam_C0E5]
	sub a, $04
	ld [wRam_C0E5], a
	call SoundTest_DrawNumber
	ret
.l42A6 ; 1B:42A6
	ld a, [wRam_C0E7]
	cp a, $3C
	jr nc, .l42B8
	ld a, [wRam_C0E5]
	inc a
	ld [wRam_C0E5], a
	call SoundTest_DrawNumber
	ret
.l42B8 ; 1B:42B8
	ld a, [wRam_C0E5]
	add a, $04
	ld [wRam_C0E5], a
	call SoundTest_DrawNumber
	ret

SoundTest_LoadHelpText:: ; 1B:42C4
	ld hl, $4314
	ld de, $D000
	ld bc, $0010
	ld a, $03
	ldh [hRam_FFB0], a
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
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C00
	ld hl, $D400
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- text $4314-$4371 (93 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_SoundTest_Help:: ; 1B:4314
String_1B_4314::
	db $81, $40, $82, $60, $81, $46, $82, $6C, $82, $74, $82, $72, $82, $68, $82, $62, $81, $40, $82, $61, $81, $46, $82, $72, $82, $6E, $82, $74, $82, $6D, $82, $63, $82, $72 ; "　Ａ：ＭＵＳＩＣ　Ｂ：ＳＯＵＮＤＳ"
	db $82, $94, $82, $81, $81, $46, $82, $72, $82, $73, $82, $6E, $82, $6F, $81, $40, $82, $72, $82, $85, $82, $8C, $81, $46, $82, $64, $82, $6D, $82, $63, $81, $40, $81, $AA ; "ｔａ：ＳＴＯＰ　Ｓｅｌ：ＥＮＤ　↑"
	db $81, $AB, $81, $69, $81, $A9, $81, $A8, $81, $6A, $81, $46, $82, $6D, $82, $95, $82, $8D, $82, $82, $82, $85, $82, $92, $00 ; "↓（←→）：Ｎｕｍｂｅｒ"

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
	ld hl, $D000
	ld bc, $0400
	xor a, a
	call FillBytes
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D000
	ld a, $81
	ld [de], a
	inc de
	ld a, $79
	ld [de], a
	inc de
	ld a, [wRam_C0D6]
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
	ld a, [wRam_C0E5]
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
	ld de, $D000
	ld bc, $0010
	ld a, $03
	ldh [hRam_FFB0], a
	ld a, $02
	farcall TextTiles_RenderGrid
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $8E00
	ld hl, $D000
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- text $4430-$4450 (32 bytes) [PROBABLE] 16 fullwidth Shift-JIS characters "０１２３４５６７８９ＡＢＣＤＥＦ" (82 4F..82 58, 82 60..82 65), 2 bytes each, no NUL: hex-digit glyph table loaded by many `ld hl,$4430` (1B:43A2, 43B5, 43CD, 43E0 ...) in the preceding routine

String_SoundTest_HexChars:: ; 1B:4430
String_1B_4430::
	db $82, $4F, $82, $50, $82, $51, $82, $52, $82, $53, $82, $54, $82, $55, $82, $56, $82, $57, $82, $58, $82, $60, $82, $61, $82, $62, $82, $63, $82, $64, $82, $65 ; "０１２３４５６７８９ＡＢＣＤＥＦ"

SoundTest_UpdateHoldTimer:: ; 1B:4450
	; [PROBABLE] 14 insn(s) reached by static flow only; seeds: site x14; min discovery hops 2;
	; entered by call from 1B:41CD (PROBABLE code) | forced execution: 14/14 instruction starts ran
	; in forced_debug (traces/forced/, not natural evidence; status unchanged)
	ld a, [wRam_C0E8]
	ld b, a
	ldh a, [hJoyHeld]
	cp a, b
	jr z, .l4461
	ld [wRam_C0E8], a
	xor a, a
	ld [wRam_C0E7], a
	ret
.l4461 ; 1B:4461
	ld a, [wRam_C0E7]
	add a, $01
	ret c
	ld [wRam_C0E7], a
	ret
