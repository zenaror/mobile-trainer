; engine/settings/phone_comment_entry.asm
; bank 67, $4924-$4C73 (847 bytes); pinned by layout.link
; phone comment keyboard entry

SECTION "engine/settings/phone_comment_entry", ROMX

PhoneComment_KeyboardRun:: ; 67:4924
	; [CONFIRMED] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 5;
	; entered by far from 65:4563 (PROBABLE code) [executed in 1 scenarios]
	call PhoneComment_KeyboardSetup
	farcall Palette_FadeInFromWhite
	call PhoneComment_KeyboardLoop
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	ld a, [wPhoneComment_Result]
	ret

PhoneComment_ClearStoredBitIfEdited:: ; 67:4940
Function_67_4940::
	; [HYPOTHESIS] function with no found entry (no call/jp/table word/far pointer/ld r16 to $4940
	; anywhere in the ROM); linear decode is legal ($4940-$49A8), all direct targets are known code
	; starts, sibling of the function at 424A: reads SRAM $B0AD via 14EA/1509, clears bit $20 of
	; $C278; ends with ret. Sits after a ret between PROBABLE/CONFIRMED functions of the same style
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, sSettingsNumberComment
	ld de, wRam_C28F
	call DecodeXorA5
	ld hl, wRam_C28F
	ld de, $DEFF
	call CompareString
	or a, a
	jr z, .l498A
	ld a, [wSettingsFieldMask]
	ld b, a
	ld a, $20
	xor a, $FF
	and a, b
	ld [wSettingsFieldMask], a
.l498A ; 67:498A
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ret

PhoneComment_KeyboardSetup:: ; 67:49A8
	; [CONFIRMED] 190 insn(s) reached by static flow only; seeds: exec x190; min discovery hops 6;
	; entered by call from 67:4924 (PROBABLE code) | 87 insn(s) executed; cut out of the PROBABLE
	; region 49A8-4BC2 by apply_coverage --split [executed in 1 scenarios]
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	xor a, a
	ld [wPhoneComment_Result], a
	ld [wPhoneComment_OkFlag], a
	ld hl, $DE80
	ld b, $11
	farcall TextBuf_Init
	ld hl, $DE80
	ld de, $DEFF
	farcall TextEntry_InsertString
	call PhoneComment_UpdateNonEmptyFlag
	ld de, $8801
	ld hl, Data_5E_4000
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Data_5E_4400
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_PhoneKeypadAndComment_Tiles9000Vb1
	ld a, $4A
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_PhoneKeypadAndComment_Tiles9400Vb1
	ld a, $4A
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Data_5E_4D00
	ld a, $5E
	farcall Palette_LoadToBuffer
	ld bc, $0514
	ld de, wScreenTileMap
	ld hl, Tilemap_PhoneComment
	ld a, $4A
	farcall Tilemap_CopyRectAndAttr
	ld a, $03
	ld hl, $DE83
	call PhoneComment_PrintText
	call PhoneComment_UploadTextTiles
	call PhoneComment_BuildTextMap
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld a, $03
	ld b, $02
	farcall Kbd_Open
	ld hl, wSpriteSlot0
	ld de, $4D30
	ld a, $5F
	ld b, $81
	farcall Sprite_InitSlot
	ld d, $20
	ld e, $10
	ld hl, $DE80
	farcall TextEntry_UpdateCursorSprite
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $01
	jr c, .l4A8B
	ret
.l4A8B ; 67:4A8B
	farcall Kbd_ShowMarkerSprite
	farcall Sprite_UpdateAll
	ret

PhoneComment_KeyboardLoop:: ; 67:4A98
	farcall Sprite_UpdateAll
	ld a, [wPhoneComment_OkFlag]
	ld c, a
	farcall Kbd_Run
	cp a, $01
	jr z, .l4ABD
	cp a, $02
	jr z, .l4B0E
	cp a, $07
	jp z, .l4B47
	cp a, $08
	jp z, .l4B7F

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 49A8-4BC2 by apply_coverage --split
	jp .l4BB2

.l4ABD ; 67:4ABD
	; [CONFIRMED] 29 insn(s) executed; cut out of the PROBABLE region 49A8-4BC2 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, [wKeyboardCharLo]
	ld hl, $DE80
	ld d, a
	farcall TextBuf_AppendChar
	or a, a
	jr nz, .l4ADF
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	jr .l4AEF
.l4ADF ; 67:4ADF
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
.l4AEF ; 67:4AEF
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $01
	jr c, .l4B05
	farcall Kbd_HideMarkerSprite
	jp .l4B97

.l4B05 ; 67:4B05
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 49A8-4BC2 by apply_coverage --split
	farcall Kbd_ShowMarkerSprite
	jp .l4B97

.l4B0E ; 67:4B0E
	; [CONFIRMED] 18 insn(s) executed; cut out of the PROBABLE region 49A8-4BC2 by apply_coverage
	; --split [executed in 2 scenarios]
	ld hl, $DE80
	farcall TextBuf_DeleteLast
	or a, a
	jr nz, .l4B7F
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0039
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $01
	jr c, .l4B3F
	farcall Kbd_HideMarkerSprite
	jr .l4B97

.l4B3F ; 67:4B3F
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 49A8-4BC2 by apply_coverage --split
	farcall Kbd_ShowMarkerSprite
	jr .l4B97

.l4B47 ; 67:4B47
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 49A8-4BC2 by apply_coverage
	; --split [executed in 3 scenarios]
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $01
	jr nc, .l4B66

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 49A8-4BC2 by apply_coverage --split
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	jr .l4BB2

.l4B66 ; 67:4B66
	; [CONFIRMED] 38 insn(s) executed; cut out of the PROBABLE region 49A8-4BC2 by apply_coverage
	; --split [executed in 1 scenarios]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	call PhoneComment_StoreResult
	ld a, $01
	ld [wPhoneComment_Result], a
	ret
.l4B7F ; 67:4B7F
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	call PhoneComment_StoreResult
	xor a, a
	ld [wPhoneComment_Result], a
	ret
.l4B97 ; 67:4B97
	ld d, $20
	ld e, $10
	ld hl, $DE80
	farcall TextEntry_UpdateCursorSprite
	ld a, $03
	ld hl, $DE83
	call PhoneComment_PrintText
	call PhoneComment_UploadTextTiles
	call PhoneComment_UpdateFullFlag
.l4BB2 ; 67:4BB2
	jp PhoneComment_KeyboardLoop

PhoneComment_StoreResult:: ; 67:4BB5
	ld hl, $DE80
	ld de, $DEFF
	farcall TextEntry_CopyText
	ret

PhoneComment_UpdateStoredFlag:: ; 67:4BC2
Function_67_4BC2::
	; [HYPOTHESIS] function with no found entry (no call/jp/table word/far pointer/ld r16 to $4BC2
	; anywhere in the ROM); linear decode is legal ($4BC2-$4BD5), all direct targets are known code
	; starts, tests bit $20 of [$C278] and sets [$C27D]=0/1; ends with ret. Sits after a ret between
	; PROBABLE/CONFIRMED functions of the same style
	ld a, [wSettingsFieldMask]
	and a, $20
	jr nz, .l4BCF
	ld a, $00
	ld [wPhoneComment_OkFlag], a
	ret
.l4BCF ; 67:4BCF
	ld a, $01
	ld [wPhoneComment_OkFlag], a
	ret

PhoneComment_UpdateFullFlag:: ; 67:4BD5
	; [CONFIRMED] 370 insn(s) reached by static flow only; seeds: exec x370; min discovery hops 4;
	; entered by call from 67:4BAF (PROBABLE code) | 246 insn(s) executed; cut out of the PROBABLE
	; region 4BD5-4F68 by apply_coverage --split [executed in 1 scenarios] (part of region
	; $4BD5-$4E56)
	ld hl, $DE80
	farcall TextBuf_GetFree
	or a, a
	jr z, .l4BE7
	ld a, $00
	ld [wPhoneComment_OkFlag], a
	ret
.l4BE7 ; 67:4BE7
	ld a, $01
	ld [wPhoneComment_OkFlag], a
	ret

PhoneComment_UpdateNonEmptyFlag:: ; 67:4BED
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $01
	jr nc, .l4C00
	ld a, $00
	ld [wPhoneComment_OkFlag], a
	ret
.l4C00 ; 67:4C00
	ld a, $01
	ld [wPhoneComment_OkFlag], a
	ret

PhoneComment_BuildTextMap:: ; 67:4C06
	ld hl, wScreenTileMap + $44
	ld de, $0000
	ld bc, $020C
	farcall Tilemap_FillAscendingWithAttr
	ret

PhoneComment_PrintText:: ; 67:4C16
	push hl
	push af
	ld de, $FFFF
	ld hl, $0204
	ld bc, $020C
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $15
	ldh [hTextY], a
	ld a, $20
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $10
	ldh [hRam_FFC0], a
	ld a, $20
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextBox_LineStartXHi], a
	ld a, $20
	ldh [hTextBox_MaxLineY], a
	ld a, $80
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hTextBox_LineAdvance], a
	ld a, $0C
	ldh [hRam_FFC7], a
	pop af
	pop hl
	ld a, $03
	call TextEngine_Run
	ret

PhoneComment_UploadTextTiles:: ; 67:4C63
	ld de, $9000
	ld hl, $0204
	ld bc, $020C
	farcall TileCanvas_UploadRect
	ret
