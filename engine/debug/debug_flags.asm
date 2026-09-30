; engine/debug/debug_flags.asm
; bank 19, $4000-$4980 (2432 bytes); pinned by layout.link
; DEBUG MODE flag editor (unreferenced screen) and the palette shared with the other debug screens

SECTION "engine/debug/debug_flags", ROMX

DebugFlags_Run:: ; 19:4000
	; [PROBABLE] start of bank: xor a / ld bc,$00FC / ld hl,$C0D4 / call $04D8 (same prologue as
	; 19:4980), decode chain ends exactly at the site-validated inline far call `call $06D1` at
	; 400A; entry unproven (no caller found) | forced execution: 4/4 instruction starts ran in
	; forced_debug (traces/forced/, not natural evidence; status unchanged)
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4
	call FillBytes

	; [PROBABLE] 142 insn(s) reached by static flow only; seeds: site x142; min discovery hops 0;
	; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code |
	; forced execution: 142/142 instruction starts ran in forced_debug (traces/forced/, not natural
	; evidence; status unchanged)
	farcall Function_48_48BB
	ld a, $02
	ld [wRam_C0D8], a
	call LCDOff
	ldh a, [rLCDC]
	and a, $9F
	or a, $60
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
	ld hl, $D000
	ld bc, $0800
	xor a, a
	call FillBytes
	ld de, $8000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8400
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8800
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C00
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8001
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8401
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8801
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wRam_D800], a
	ld [wRam_D801], a
	ld a, $7F
	ld [wRam_D806], a
	ld a, $7F
	ld [wRam_D807], a
	ld hl, $DA10
	ld de, Table_DebugFlags_Objects
	ld a, $19
	ld b, $00
	farcall Sprite_InitSlot
	ld de, $80A0
	ld hl, $DA10
	call Sprite_SetPosition
	ld a, $80
	ld bc, $0400
	ld hl, $D000
	call FillBytes
	ld hl, $D400
	ld bc, $1214
	ld de, $0008
	xor a, a
	farcall Tilemap_ApplyMaskRect
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld a, $80
	ld bc, $1010
	ld de, $1000
	ld hl, $D002
	farcall Tilemap_FillRectSequential
	call DebugFlags_LoadHelpText
	call DebugFlags_DrawEntryName
	ldh a, [rLCDC]
	call Gfx_UploadWinMapBuffers
	farcall Sprite_UpdateAll
	call LCDOn
	farcall Palette_FadeInFromWhite
	call DebugFlags_SlideIn

DebugFlags_Loop:: ; 19:4199
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $41B1-$41BB (10 bytes) [PROBABLE] inline table of `call $056A` (JoypadDispatch) at 19:41AE: 5 entries; fixed length (5 words) by the routine

Table_DebugFlags_Buttons:: ; 19:41B1
Table_19_41B1::
	dw DebugFlags_OnA
	dw DebugFlags_Exit
	dw DebugFlags_Exit
	dw DebugFlags_OnStart
	dw DebugFlags_Idle

DebugFlags_Idle:: ; 19:41BB
	; [PROBABLE] 330 insn(s) reached by static flow only; seeds: site x330; min discovery hops 0;
	; entered by table from 19:41AE (PROBABLE code) | forced execution: 235/330 instruction starts
	; ran in forced_debug (traces/forced/, not natural evidence; status unchanged)
	call DebugFlags_PlaceCursor
	call DebugFlags_UpdateHoldTimer
	ldh a, [hJoyPressedRepeat]
	and a, $F0
	call nz, DebugFlags_HandleDpad
	jp DebugFlags_Loop

DebugFlags_OnA:: ; 19:41CB
	ld a, [wRam_C0D8]
	cp a, $01
	jp z, .l41D8
	cp a, $02
	jp z, .l4234
.l41D8 ; 19:41D8
	ld a, [wRam_C0D4]
	ld bc, $8000
	or a, a
	jr z, .l41E8
.l41E1 ; 19:41E1
	srl b
	rr c
	dec a
	jr nz, .l41E1
.l41E8 ; 19:41E8
	ld a, [wRam_C0E5]
	ld hl, Table_DebugFlags_Entries
	add a, a
	inc a
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or a, h
	jr z, .l420D
	ld a, $01
	call ReadByteFar
	dec hl
	xor a, b
	ld b, a
	ld a, $01
	farcall WriteByteFar
.l420D ; 19:420D
	ld a, [wRam_C0E5]
	ld hl, Table_DebugFlags_Entries
	add a, a
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $01
	call ReadByteFar
	dec hl
	xor a, c
	ld b, a
	ld a, $01
	farcall WriteByteFar
	call DebugFlags_DrawEntryName
	jp DebugFlags_Loop
.l4234 ; 19:4234
	ld a, [wRam_C0D4]
	ld hl, $2710
	or a, a
	jr z, .l4248
.l423D ; 19:423D
	push af
	ld de, $000A
	call Divide16
	pop af
	dec a
	jr nz, .l423D
.l4248 ; 19:4248
	push hl
	ld d, h
	ld e, l
	call DebugFlags_ReadValue
	ld h, b
	ld l, c
	call Divide16
	ld de, $000A
	call Divide16
	ld a, e
	cp a, $0A
	jr c, .skip
	sub a, $0A
.skip ; 19:4260
	cp a, $09
	jr nz, .l4281
	call DebugFlags_ReadValue
	ld d, b
	ld e, c
	pop hl
	ld b, h
	ld c, l
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, bc
	ld a, e
	sub a, l
	ld e, a
	ld a, d
	sbc a, h
	ld d, a
	ld h, d
	ld l, e
	call DebugFlags_WriteValue
	call DebugFlags_DrawEntryName
	jp DebugFlags_Loop
.l4281 ; 19:4281
	call DebugFlags_ReadValue
	ld h, b
	ld l, c
	pop de
	add hl, de
	ld d, h
	ld e, l
	jr c, .l4295
	call DebugFlags_EntryHasHighByte
	jr nz, .l4298
	ld a, d
	or a, a
	jr z, .l4298
.l4295 ; 19:4295
	ld de, $0000
.l4298 ; 19:4298
	call DebugFlags_WriteValue
	call DebugFlags_DrawEntryName
	jp DebugFlags_Loop

DebugFlags_Exit:: ; 19:42A1
	call DebugFlags_SlideOut
	farcall Palette_FadeOutToWhite
	farcall SaveCheck_Update
	farcall Settings_UpdateChecksumAndBackup
	ret

DebugFlags_OnStart:: ; 19:42B7
	ld a, [wRam_C0D8]
	inc a
	ld [wRam_C0D8], a
	cp a, $03
	jr nz, .skip
	ld a, $01
	ld [wRam_C0D8], a
.skip ; 19:42C7
	cp a, $00
	jp z, .l42FE
	cp a, $02
	jp z, .l430D
	call DebugFlags_EntryHasHighByte
	jr z, .l42EA
	ld de, $8010
	ld hl, $DA10
	call Sprite_SetPosition
	ld a, $00
	ld [wRam_C0D4], a
	call DebugFlags_DrawEntryName
	jp DebugFlags_Loop
.l42EA ; 19:42EA
	ld de, $8050
	ld hl, $DA10
	call Sprite_SetPosition
	ld a, $08
	ld [wRam_C0D4], a
	call DebugFlags_DrawEntryName
	jp DebugFlags_Loop
.l42FE ; 19:42FE
	ld de, $80A0
	ld hl, $DA10
	call Sprite_SetPosition
	call DebugFlags_DrawEntryName
	jp DebugFlags_Loop
.l430D ; 19:430D
	ld de, $80A0
	ld hl, $DA10
	call Sprite_SetPosition
	ld a, $00
	ld [wRam_C0D4], a
	call DebugFlags_DrawEntryName
	jp DebugFlags_Loop

DebugFlags_EntryHasHighByte:: ; 19:4321
	ld a, [wRam_C0E5]
	ld hl, Table_DebugFlags_Entries
	add a, a
	inc a
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	or a, [hl]
	ret

DebugFlags_HandleDpad:: ; 19:4333
	ld b, a
	ld a, [wRam_C0D8]
	cp a, $01
	jp z, .l43A0
	cp a, $02
	jp z, .l4341
.l4341 ; 19:4341
	bit 6, b
	jr nz, .l4354
	bit 7, b
	jr nz, .l4363
	bit 4, b
	jp nz, .l4392
	bit 5, b
	jp nz, .l4385
	ret
.l4354 ; 19:4354
	ld a, [wRam_C0E5]
	inc a
	cp a, $01
	ret z
	ld [wRam_C0E5], a
	call DebugFlags_DrawEntryName
	jr .l436F
.l4363 ; 19:4363
	ld a, [wRam_C0E5]
	or a, a
	ret z
	dec a
	ld [wRam_C0E5], a
	call DebugFlags_DrawEntryName
.l436F ; 19:436F
	call DebugFlags_EntryHasHighByte2
	ret nz
	ld a, [wRam_C0D8]
	cp a, $01
	ret nz
	ld a, [wRam_C0D4]
	cp a, $08
	ret nc
	ld a, $08
	ld [wRam_C0D4], a
	ret
.l4385 ; 19:4385
	ld a, [wRam_C0D4]
	or a, a
	ret z
	dec a
	ld [wRam_C0D4], a
	call DebugFlags_PlaceCursor
	ret
.l4392 ; 19:4392
	ld a, [wRam_C0D4]
	inc a
	cp a, $05
	ret z
	ld [wRam_C0D4], a
	call DebugFlags_PlaceCursor
	ret
.l43A0 ; 19:43A0
	bit 6, b
	jp nz, .l4354
	bit 7, b
	jp nz, .l4363
	bit 4, b
	jr nz, .l43C9
	bit 5, b
	jr nz, .l43B3
	ret
.l43B3 ; 19:43B3
	call DebugFlags_EntryHasHighByte2
	ld b, $00
	jr nz, .skip
	ld b, $08
.skip ; 19:43BC
	ld a, [wRam_C0D4]
	cp a, b
	ret z
	dec a
	ld [wRam_C0D4], a
	call DebugFlags_PlaceCursor
	ret
.l43C9 ; 19:43C9
	ld a, [wRam_C0D4]
	inc a
	cp a, $10
	ret z
	ld [wRam_C0D4], a
	call DebugFlags_PlaceCursor
	ret

DebugFlags_EntryHasHighByte2:: ; 19:43D7
	ld a, [wRam_C0E5]
	ld hl, Table_DebugFlags_Entries
	add a, a
	inc a
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	or a, [hl]
	ret

DebugFlags_LoadHelpText:: ; 19:43E9
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $0C00
	xor a, a
	call FillBytes
	ld hl, $447C
	ld de, $D000
	ld bc, $0010
	ld a, $03
	ldh [hRam_FFB0], a
	ld a, $19
	farcall TextTiles_RenderGrid
	ld de, $8800
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C00
	ld hl, $D400
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9000
	ld hl, $D800
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld hl, $452F
	ld de, $D000
	ld bc, $0010
	ld a, $03
	ldh [hRam_FFB0], a
	ld a, $19
	farcall TextTiles_RenderGrid
	ld de, $8000
	ld hl, $D000
	ld a, $00
	ld b, $98
	ld c, $01
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- text $447C-$452F (179 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_DebugFlags_Help:: ; 19:447C
String_19_447C::
	db "＝＝　ＤＥＢＵＧ　ＭＯＤＥ　＝＝　↑↓：えらぶ　　←→：カーソル　　　　　Ａ：へんこう", $0D, $0A
	db "　Ｓｔａ：　ＢＩＴ←→ＤＥＣ　　Ｓｅｌ／Ｂ：しゅうりょう", $0D, $0A
	db "－－－－－－－－－－－－－－－－", 0
POPC

; ---- text $452F-$4532 (3 bytes) [PROBABLE] 2-byte Shift-JIS char 81 A3 + NUL, right after the NUL of String_19_447C and before code at 4532

PUSHC sjis
String_19_452F:: ; 19:452F
	db "▲", 0
POPC

DebugFlags_DrawEntryName:: ; 19:4532
	; [PROBABLE] 365 insn(s) reached by static flow only; seeds: site x365; min discovery hops 4;
	; entered by call from 19:417F (PROBABLE code) | forced execution: 202/365 instruction starts
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
	ld a, [wRam_C0E5]
	ld hl, $4912
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $D000
	ld bc, $0010
	ld a, $03
	ldh [hRam_FFB0], a
	ld a, $19
	farcall TextTiles_RenderGrid
	ld de, $9400
	ld hl, $D000
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	call DebugFlags_DrawValue
	ret

DebugFlags_DrawValue:: ; 19:458A
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
	ld a, [wRam_C0D8]
	cp a, $01
	jp z, .l468F
	cp a, $02
	jp z, .l473E
	ld de, $D000
	ld a, $81
	ld [de], a
	inc de
	ld a, $79
	ld [de], a
	inc de
	ld a, $81
	ld [de], a
	inc de
	ld a, $90
	ld [de], a
	inc de
	ld a, [wRam_C0E5]
	ld hl, Table_DebugFlags_Entries
	add a, a
	inc a
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or a, h
	ld a, $00
	jr z, .l45E3
	ld a, $01
	call ReadByteFar
.l45E3 ; 19:45E3
	ld b, a
	swap a
	and a, $0F
	add a, a
	ld hl, String_DebugFlags_Chars
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
	ld hl, String_DebugFlags_Chars
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
	ld hl, Table_DebugFlags_Entries
	add a, a
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or a, h
	ld a, $00
	jr z, .l4626
	ld a, $01
	call ReadByteFar
.l4626 ; 19:4626
	ld b, a
	swap a
	and a, $0F
	add a, a
	ld hl, String_DebugFlags_Chars
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
	ld hl, String_DebugFlags_Chars
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
	ld bc, $0610
	ld a, $03
	ldh [hRam_FFB0], a
	ld a, $02
	farcall TextTiles_RenderGrid
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $9600
	ld hl, $D000
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
.l468F ; 19:468F
	ld de, $D000
	ld a, [wRam_C0E5]
	ld hl, Table_DebugFlags_Entries
	add a, a
	inc a
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or a, h
	jr z, .l46C9
	ld a, $01
	call ReadByteFar
	ld b, a
	ld c, $08
.l46AF ; 19:46AF
	rlc b
	ld a, b
	and a, $01
	add a, a
	ld hl, String_DebugFlags_Chars
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
	dec c
	jr nz, .l46AF
	jr .l46D4
.l46C9 ; 19:46C9
	ld hl, $47CE
	ld c, $10
.l46CE ; 19:46CE
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .l46CE
.l46D4 ; 19:46D4
	ld a, [wRam_C0E5]
	ld hl, Table_DebugFlags_Entries
	add a, a
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $01
	call ReadByteFar
	ld b, a
	ld c, $08
.l46ED ; 19:46ED
	rlc b
	ld a, b
	and a, $01
	add a, a
	ld hl, String_DebugFlags_Chars
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
	dec c
	jr nz, .l46ED
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
	ld de, $9600
	ld hl, $D000
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
.l473E ; 19:473E
	ld de, $D000
	ld hl, $47DE
	ld c, $0F
.l4746 ; 19:4746
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .l4746
	ld de, $D00A
	call DebugFlags_ReadValue
	ld h, b
	ld l, c
	ld b, d
	ld c, e
.l4756 ; 19:4756
	push bc
	ld de, $000A
	call Divide16
	pop bc
	push hl
	ld a, e
	add a, a
	ld hl, String_DebugFlags_Chars
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [bc], a
	dec bc
	dec bc
	dec bc
	pop hl
	ld a, h
	or a, l
	jr nz, .l4756
	ld hl, $D000
	ld de, $D000
	ld bc, $0610
	ld a, $03
	ldh [hRam_FFB0], a
	ld a, $02
	farcall TextTiles_RenderGrid
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $9600
	ld hl, $D000
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

; ---- text $47AE-$47ED (63 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_DebugFlags_Chars:: ; 19:47AE
String_19_47AE::
	db "０１２３４５６７８９ＡＢＣＤＥＦ－－－－－－－－【０００００】", 0
POPC

DebugFlags_PlaceCursor:: ; 19:47ED
	; [PROBABLE] 26 insn(s) reached by static flow only; seeds: site x26; min discovery hops 2;
	; entered by call from 19:41BB (PROBABLE code) | forced execution: 25/26 instruction starts ran
	; in forced_debug (traces/forced/, not natural evidence; status unchanged)
	ld a, [wRam_C0D8]
	cp a, $01
	jr z, .l47F9
	cp a, $02
	jr z, .l480B
	ret
.l47F9 ; 19:47F9
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wRam_C0D4]
	add a, a
	add a, a
	add a, a
	add a, $10
	ld [wSpriteSlots + 17], a
	ret
.l480B ; 19:480B
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wRam_C0D4]
	add a, a
	add a, a
	add a, a
	add a, $48
	ld [wSpriteSlots + 17], a
	ret

; ---- words $481D-$4821 (4 bytes) [PROBABLE] 1 object-table entries of 4 bytes (ptr to frame table, ptr to script; 0000 = unused); de=$481D a=$19 at 19:4136 (1 entry); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs

Table_DebugFlags_Objects:: ; 19:481D
Table_19_481D::
	dw DebugFlags_ObjAnimData, $4828

; ---- data $4821-$482B (10 bytes) [PROBABLE] 1 object record: frame table 4821 (word 4823), frame 4823 = 01 [00 00 00 01] (count 1, one OAM entry), script 4828 = 01 [00 04] (one pair); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs

DebugFlags_ObjAnimData:: ; 19:4821
Data_19_4821::
	db $23, $48, $01, $00, $00, $00, $01, $01, $00, $04

DebugFlags_SlideIn:: ; 19:482B
	; [PROBABLE] 121 insn(s) reached by static flow only; seeds: site x121; min discovery hops 0;
	; entered by call from 19:4196 (PROBABLE code) | forced execution: 115/121 instruction starts
	; ran in forced_debug (traces/forced/, not natural evidence; status unchanged)
	ld a, $99
	ld [wRam_C0E5], a
	ld a, $11
	ld [wRam_C0DF], a
.loop ; 19:4835
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	ld a, [wRam_C0DF]
	dec a
	ld b, $01
	jr z, .skip
	ld [wRam_C0DF], a
	ld b, a
.skip ; 19:484A
	ld a, [wRam_C0E5]
	sub a, b
	ld [wRam_C0E5], a
	ldh [rWY], a
	cp a, $00
	jr nz, .loop
	ret

DebugFlags_SlideOut:: ; 19:4858
	ld a, $00
	ld [wRam_C0E5], a
	ld a, $11
	ld [wRam_C0DF], a
.loop ; 19:4862
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	ld a, [wRam_C0DF]
	dec a
	ld b, $01
	jr z, .skip
	ld [wRam_C0DF], a
	ld b, a
.skip ; 19:4877
	ld a, [wRam_C0E5]
	add a, b
	ld [wRam_C0E5], a
	ldh [rWY], a
	cp a, $99
	jr nz, .loop
	ret

DebugFlags_UpdateHoldTimer:: ; 19:4885
	ld a, [wRam_C0E8]
	ld b, a
	ldh a, [hJoyHeld]
	cp a, b
	jr z, .l4896
	ld [wRam_C0E8], a
	xor a, a
	ld [wRam_C0E7], a
	ret
.l4896 ; 19:4896
	ld a, [wRam_C0E7]
	add a, $01
	ret c
	ld [wRam_C0E7], a
	ret

DebugFlags_ReadValue:: ; 19:48A0
	ld a, [wRam_C0E5]
	ld hl, Table_DebugFlags_Entries
	add a, a
	inc a
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or a, h
	ld b, $00
	jr z, .l48BD
	ld a, $01
	call ReadByteFar
	ld b, a
.l48BD ; 19:48BD
	ld a, [wRam_C0E5]
	ld hl, Table_DebugFlags_Entries
	add a, a
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $01
	call ReadByteFar
	ld c, a
	ret

DebugFlags_WriteValue:: ; 19:48D5
	ld a, [wRam_C0E5]
	ld hl, Table_DebugFlags_Entries
	add a, a
	inc a
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or a, h
	jr z, .l48F3
	ld a, $01
	ld b, d
	farcall WriteByteFar
.l48F3 ; 19:48F3
	ld a, [wRam_C0E5]
	ld hl, Table_DebugFlags_Entries
	add a, a
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $01
	ld b, e
	farcall WriteByteFar
	ret

; ---- data $490E-$4914 (6 bytes) [PROBABLE] 6-byte table (bf b0 00 00 14 49) addressed by `ld hl,$490E ; add a,a ; ... add a,l` at 12 sites in code of this bank (19:41EC, 4211, 4325, 43DB, 45CB, 460F, 4696, 46D8, 48A4, 48C1, 48D9, 48F7); the last word 4914 points at the string that follows; field meaning unknown [v4: entries are 4 bytes (word at +4a, or at +4a+2 in the `add a,a ; inc a ; add a,a` variant); with a=1 the accessed words 4912/4914/4916 would overlap String_19_4914, so the 6-byte extent is only the neighbour boundary and the field layout is HYPOTHESIS; entry 0 = (B0BF, 0000) where B0BF is an SRAM address passed to `ld a,1 ; call $1620`]

Table_DebugFlags_Entries:: ; 19:490E
Data_19_490E::
	db $BF, $B0, $00, $00, $14, $49

; ---- text $4914-$4933 (31 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_DebugFlags_Title:: ; 19:4914
String_19_4914::
	db "【サインアップデバッグフラグ】", 0
POPC

; ---- zero $4933-$4940 (13 bytes) [PROBABLE] zero padding between String_19_4914 and the palette block at 4940
	ds $D, $00

; ---- data $4940-$4980 (64 bytes) [PROBABLE] palette-rgb555: heuristic: 32 RGB555 words as 8 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Palette_DebugScreens:: ; 19:4940
Data_19_4940::
	db $00, $00, $1B, $25, $9F, $51, $FF, $7F, $FF, $7F, $4A, $29, $B5, $56, $00, $00
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
