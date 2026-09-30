; engine/debug/error_screen_test.asm
; bank 19, $4980-$4D99 (1049 bytes); pinned by layout.link
; error-screen tester (unreferenced screen)

SECTION "engine/debug/error_screen_test", ROMX

Debug_ErrorScreenTest:: ; 19:4980
	; [PROBABLE] function start after a palette block: xor a / ld bc,$00FC / ld hl,$C0D4 / call
	; $04D8 (same as 19:4000), chain ends exactly at the site-validated far call at 498A; entry
	; unproven | forced execution: 4/4 instruction starts ran in forced_debug (traces/forced/, not
	; natural evidence; status unchanged)
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4
	call FillBytes

	; [PROBABLE] 123 insn(s) reached by static flow only; seeds: site x123; min discovery hops 0;
	; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code |
	; forced execution: 123/123 instruction starts ran in forced_debug (traces/forced/, not natural
	; evidence; status unchanged)
	farcall Function_48_48BB

Label_19_4990:: ; 19:4990
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
	ld hl, Palette_DebugScreens
	ld a, $19
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
	call DebugErrorTest_LoadHelpText
	call DebugErrorTest_DrawValues
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	farcall Palette_FadeInFromWhite

DebugErrorTest_Loop:: ; 19:4AEB
	call Function_00_044B
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $4AFD-$4B07 (10 bytes) [PROBABLE] inline table of `call $056A` (JoypadDispatch) at 19:4AFA: 5 entries; fixed length (5 words) by the routine

Table_DebugErrorTest_Buttons:: ; 19:4AFD
Table_19_4AFD::
	dw DebugErrorTest_OnA
	dw Label_19_4B3B
	dw DebugErrorTest_Exit
	dw Label_19_4B47
	dw DebugErrorTest_Idle

DebugErrorTest_Idle:: ; 19:4B07
	; [PROBABLE] 119 insn(s) reached by static flow only; seeds: site x119; min discovery hops 0;
	; entered by table from 19:4AFA (PROBABLE code) | forced execution: 100/119 instruction starts
	; ran in forced_debug (traces/forced/, not natural evidence; status unchanged)
	call DebugErrorTest_UpdateHoldTimer
	ldh a, [hJoyPressedRepeat]
	call DebugErrorTest_HandleDpad
	jp DebugErrorTest_Loop

DebugErrorTest_OnA:: ; 19:4B12
	farcall Palette_FadeOutToWhite
	ld a, [wRam_C0E5]
	ld l, a
	ld a, [wRam_C0D6]
	ld h, a
	ld a, [wRam_C0D4]
	push af
	push hl
	farcall CommErr_ShowScreen
	pop hl
	pop af
	ld [wRam_C0D4], a
	ld a, l
	ld [wRam_C0E5], a
	ld a, h
	ld [wRam_C0D6], a
	jp Label_19_4990

Label_19_4B3B:: ; 19:4B3B
	jp DebugErrorTest_Loop

DebugErrorTest_Exit:: ; 19:4B3E
	farcall Palette_FadeOutToWhite
	ld a, $01
	ret

Label_19_4B47:: ; 19:4B47
	jp DebugErrorTest_Loop

DebugErrorTest_HandleDpad:: ; 19:4B4A
	bit 6, a
	jr nz, .l4B5B
	bit 7, a
	jr nz, .l4B77
	bit 4, a
	jr nz, .l4BB1
	bit 5, a
	jr nz, .l4B93
	ret
.l4B5B ; 19:4B5B
	ldh a, [hJoyHeld]
	bit 1, a
	jr nz, .l4B6C
	ld a, [wRam_C0D6]
	inc a
	ld [wRam_C0D6], a
	call DebugErrorTest_DrawValues
	ret
.l4B6C ; 19:4B6C
	ld a, [wRam_C0D4]
	inc a
	ld [wRam_C0D4], a
	call DebugErrorTest_DrawValues
	ret
.l4B77 ; 19:4B77
	ldh a, [hJoyHeld]
	bit 1, a
	jr nz, .l4B88
	ld a, [wRam_C0D6]
	dec a
	ld [wRam_C0D6], a
	call DebugErrorTest_DrawValues
	ret
.l4B88 ; 19:4B88
	ld a, [wRam_C0D4]
	dec a
	ld [wRam_C0D4], a
	call DebugErrorTest_DrawValues
	ret
.l4B93 ; 19:4B93
	ld a, [wRam_C0E7]
	cp a, $3C
	jr nc, .l4BA5
	ld a, [wRam_C0E5]
	dec a
	ld [wRam_C0E5], a
	call DebugErrorTest_DrawValues
	ret
.l4BA5 ; 19:4BA5
	ld a, [wRam_C0E5]
	sub a, $04
	ld [wRam_C0E5], a
	call DebugErrorTest_DrawValues
	ret
.l4BB1 ; 19:4BB1
	ld a, [wRam_C0E7]
	cp a, $3C
	jr nc, .l4BC3
	ld a, [wRam_C0E5]
	inc a
	ld [wRam_C0E5], a
	call DebugErrorTest_DrawValues
	ret
.l4BC3 ; 19:4BC3
	ld a, [wRam_C0E5]
	add a, $04
	ld [wRam_C0E5], a
	call DebugErrorTest_DrawValues
	ret

DebugErrorTest_LoadHelpText:: ; 19:4BCF
	ld hl, $4C1F
	ld de, $D000
	ld bc, $0010
	ld a, $03
	ldh [hRam_FFB0], a
	ld a, $19
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

; ---- text $4C1F-$4C74 (85 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_DebugErrorTest_Help:: ; 19:4C1F
String_19_4C1F::
	db "Ａ：エラー　Ｂ＋↑↓：しゅるい　　　　　Ｓｅｌ：ＥＮＤ", $0D, $0A
	db "　↑↓（←→）：Ｎｕｍｂｅｒ", 0
POPC

DebugErrorTest_DrawValues:: ; 19:4C74
	; [PROBABLE] 147 insn(s) reached by static flow only; seeds: site x147; min discovery hops 4;
	; entered by call from 19:4AD7 (PROBABLE code) | forced execution: 147/147 instruction starts
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
	ld a, [wRam_C0D4]
	ld b, a
	swap a
	and a, $0F
	add a, a
	ld hl, Data_DebugErrorTest_HexChars
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
	ld hl, Data_DebugErrorTest_HexChars
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
	ld a, [wRam_C0D6]
	ld b, a
	swap a
	and a, $0F
	add a, a
	ld hl, Data_DebugErrorTest_HexChars
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
	ld hl, Data_DebugErrorTest_HexChars
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
	ld hl, Data_DebugErrorTest_HexChars
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
	ld hl, Data_DebugErrorTest_HexChars
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

; ---- data $4D5E-$4D7E (32 bytes) [PROBABLE] 16 Shift-JIS full-width characters 0-9 A-F (82 4F..82 58, 82 60..82 65), no NUL: hex-digit lookup table indexed by `ld hl,$4D5E ; add a,a ; add a,l` at 6 sites (19:4CA6, 4CB9, 4CD1, 4CE4, 4CFC, 4D0F)

Data_DebugErrorTest_HexChars:: ; 19:4D5E
Data_19_4D5E::
	db $82, $4F, $82, $50, $82, $51, $82, $52, $82, $53, $82, $54, $82, $55, $82, $56
	db $82, $57, $82, $58, $82, $60, $82, $61, $82, $62, $82, $63, $82, $64, $82, $65

DebugErrorTest_UpdateHoldTimer:: ; 19:4D7E
	; [PROBABLE] 14 insn(s) reached by static flow only; seeds: site x14; min discovery hops 2;
	; entered by call from 19:4B07 (PROBABLE code) | forced execution: 14/14 instruction starts ran
	; in forced_debug (traces/forced/, not natural evidence; status unchanged)
	ld a, [wRam_C0E8]
	ld b, a
	ldh a, [hJoyHeld]
	cp a, b
	jr z, .l4D8F
	ld [wRam_C0E8], a
	xor a, a
	ld [wRam_C0E7], a
	ret
.l4D8F ; 19:4D8F
	ld a, [wRam_C0E7]
	add a, $01
	ret c
	ld [wRam_C0E7], a
	ret
