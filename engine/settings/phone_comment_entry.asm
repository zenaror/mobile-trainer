; engine/settings/phone_comment_entry.asm
; bank 67, $4924-$4C73 (847 bytes); pinned by layout.link
; phone comment keyboard entry

SECTION "engine/settings/phone_comment_entry", ROMX

; ---- code $4924-$4940 (28 bytes) [CONFIRMED] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 5; entered by far from 65:4563 (PROBABLE code) [executed in 1 scenarios]

PhoneComment_KeyboardRun:: ; 67:4924
	call PhoneComment_KeyboardSetup
	farcall Palette_FadeInFromWhite
	call PhoneComment_KeyboardLoop
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	ld a, [wRam_C27C]
	ret

; ---- code $4940-$49A8 (104 bytes) [HYPOTHESIS] function with no found entry (no call/jp/table word/far pointer/ld r16 to $4940 anywhere in the ROM); linear decode is legal ($4940-$49A8), all direct targets are known code starts, sibling of the function at 424A: reads SRAM $B0AD via 14EA/1509, clears bit $20 of $C278; ends with ret. Sits after a ret between PROBABLE/CONFIRMED functions of the same style

Function_67_4940:: ; 67:4940
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
	ld hl, $B0AD
	ld de, $C28F
	call DecodeXorA5
	ld hl, $C28F
	ld de, $DEFF
	call CompareString
	or a, a
	jr z, Label_67_498A
	ld a, [wSettingsFieldMask]
	ld b, a
	ld a, $20
	xor a, $FF
	and a, b
	ld [wSettingsFieldMask], a

Label_67_498A:: ; 67:498A
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

; ---- code $49A8-$4ABA (274 bytes) [CONFIRMED] 190 insn(s) reached by static flow only; seeds: exec x190; min discovery hops 6; entered by call from 67:4924 (PROBABLE code) | 87 insn(s) executed; cut out of the PROBABLE region 49A8-4BC2 by apply_coverage --split [executed in 1 scenarios]

PhoneComment_KeyboardSetup:: ; 67:49A8
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Function_00_09B6
	xor a, a
	ld [wRam_C27C], a
	ld [wRam_C27D], a
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
	farcall Function_00_0787
	ld de, $8C01
	ld hl, Data_5E_4400
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_4A_6920
	ld a, $4A
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_4A_6D20
	ld a, $4A
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, Data_5E_4D00
	ld a, $5E
	farcall Palette_LoadToBuffer
	ld bc, $0514
	ld de, $D000
	ld hl, Data_4A_72B0
	ld a, $4A
	farcall Function_00_08EA
	ld a, $03
	ld hl, $DE83
	call PhoneComment_PrintText
	call PhoneComment_UploadTextTiles
	call PhoneComment_BuildTextMap
	ldh a, [rLCDC]
	call Function_00_082C
	ld a, $03
	ld b, $02
	farcall Kbd_Open
	ld hl, $DA00
	ld de, $4D30
	ld a, $5F
	ld b, $81
	farcall Function_00_0A82
	ld d, $20
	ld e, $10
	ld hl, $DE80
	farcall TextEntry_UpdateCursorSprite
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $01
	jr c, Label_67_4A8B
	ret

Label_67_4A8B:: ; 67:4A8B
	farcall Kbd_ShowMarkerSprite
	farcall Function_00_0956
	ret

PhoneComment_KeyboardLoop:: ; 67:4A98
	farcall Function_00_0956
	ld a, [wRam_C27D]
	ld c, a
	farcall Kbd_Run
	cp a, $01
	jr z, Label_67_4ABD
	cp a, $02
	jr z, Label_67_4B0E
	cp a, $07
	jp z, Label_67_4B47
	cp a, $08
	jp z, Label_67_4B7F

; ---- code $4ABA-$4ABD (3 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 49A8-4BC2 by apply_coverage --split
	jp Label_67_4BB2

; ---- code $4ABD-$4B05 (72 bytes) [CONFIRMED] 29 insn(s) executed; cut out of the PROBABLE region 49A8-4BC2 by apply_coverage --split [executed in 1 scenarios]

Label_67_4ABD:: ; 67:4ABD
	ld a, [wKeyboardCharLo]
	ld hl, $DE80
	ld d, a
	farcall TextBuf_AppendChar
	or a, a
	jr nz, Label_67_4ADF
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	jr Label_67_4AEF

Label_67_4ADF:: ; 67:4ADF
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a

Label_67_4AEF:: ; 67:4AEF
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $01
	jr c, Label_67_4B05
	farcall Kbd_HideMarkerSprite
	jp Label_67_4B97

; ---- code $4B05-$4B0E (9 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 49A8-4BC2 by apply_coverage --split

Label_67_4B05:: ; 67:4B05
	farcall Kbd_ShowMarkerSprite
	jp Label_67_4B97

; ---- code $4B0E-$4B3F (49 bytes) [CONFIRMED] 18 insn(s) executed; cut out of the PROBABLE region 49A8-4BC2 by apply_coverage --split [executed in 2 scenarios]

Label_67_4B0E:: ; 67:4B0E
	ld hl, $DE80
	farcall TextBuf_DeleteLast
	or a, a
	jr nz, Label_67_4B7F
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0039
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $01
	jr c, Label_67_4B3F
	farcall Kbd_HideMarkerSprite
	jr Label_67_4B97

; ---- code $4B3F-$4B47 (8 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 49A8-4BC2 by apply_coverage --split

Label_67_4B3F:: ; 67:4B3F
	farcall Kbd_ShowMarkerSprite
	jr Label_67_4B97

; ---- code $4B47-$4B54 (13 bytes) [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 49A8-4BC2 by apply_coverage --split [executed in 3 scenarios]

Label_67_4B47:: ; 67:4B47
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $01
	jr nc, Label_67_4B66

; ---- code $4B54-$4B66 (18 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 49A8-4BC2 by apply_coverage --split
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	jr Label_67_4BB2

; ---- code $4B66-$4BC2 (92 bytes) [CONFIRMED] 38 insn(s) executed; cut out of the PROBABLE region 49A8-4BC2 by apply_coverage --split [executed in 1 scenarios]

Label_67_4B66:: ; 67:4B66
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	call PhoneComment_StoreResult
	ld a, $01
	ld [wRam_C27C], a
	ret

Label_67_4B7F:: ; 67:4B7F
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	call PhoneComment_StoreResult
	xor a, a
	ld [wRam_C27C], a
	ret

Label_67_4B97:: ; 67:4B97
	ld d, $20
	ld e, $10
	ld hl, $DE80
	farcall TextEntry_UpdateCursorSprite
	ld a, $03
	ld hl, $DE83
	call PhoneComment_PrintText
	call PhoneComment_UploadTextTiles
	call PhoneComment_UpdateFullFlag

Label_67_4BB2:: ; 67:4BB2
	jp PhoneComment_KeyboardLoop

PhoneComment_StoreResult:: ; 67:4BB5
	ld hl, $DE80
	ld de, $DEFF
	farcall TextEntry_CopyText
	ret

; ---- code $4BC2-$4BD5 (19 bytes) [HYPOTHESIS] function with no found entry (no call/jp/table word/far pointer/ld r16 to $4BC2 anywhere in the ROM); linear decode is legal ($4BC2-$4BD5), all direct targets are known code starts, tests bit $20 of [$C278] and sets [$C27D]=0/1; ends with ret. Sits after a ret between PROBABLE/CONFIRMED functions of the same style

Function_67_4BC2:: ; 67:4BC2
	ld a, [wSettingsFieldMask]
	and a, $20
	jr nz, Label_67_4BCF
	ld a, $00
	ld [wRam_C27D], a
	ret

Label_67_4BCF:: ; 67:4BCF
	ld a, $01
	ld [wRam_C27D], a
	ret

; ---- code $4BD5-$4C73 (158 bytes) [CONFIRMED] 370 insn(s) reached by static flow only; seeds: exec x370; min discovery hops 4; entered by call from 67:4BAF (PROBABLE code) | 246 insn(s) executed; cut out of the PROBABLE region 4BD5-4F68 by apply_coverage --split [executed in 1 scenarios] (part of region $4BD5-$4E56)

PhoneComment_UpdateFullFlag:: ; 67:4BD5
	ld hl, $DE80
	farcall TextBuf_GetFree
	or a, a
	jr z, Label_67_4BE7
	ld a, $00
	ld [wRam_C27D], a
	ret

Label_67_4BE7:: ; 67:4BE7
	ld a, $01
	ld [wRam_C27D], a
	ret

PhoneComment_UpdateNonEmptyFlag:: ; 67:4BED
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $01
	jr nc, Label_67_4C00
	ld a, $00
	ld [wRam_C27D], a
	ret

Label_67_4C00:: ; 67:4C00
	ld a, $01
	ld [wRam_C27D], a
	ret

PhoneComment_BuildTextMap:: ; 67:4C06
	ld hl, $D044
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
	ldh [hRam_FFBA], a
	ld a, $03
	ldh [hRam_FFBB], a
	ld a, $15
	ldh [hTextY], a
	ld a, $20
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $10
	ldh [hRam_FFC0], a
	ld a, $20
	ldh [hRam_FFC1], a
	ld a, $00
	ldh [hRam_FFC2], a
	ld a, $20
	ldh [hRam_FFC3], a
	ld a, $80
	ldh [hRam_FFC4], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hRam_FFC6], a
	ld a, $0C
	ldh [hRam_FFC7], a
	pop af
	pop hl
	ld a, $03
	call Function_00_0ED3
	ret

PhoneComment_UploadTextTiles:: ; 67:4C63
	ld de, $9000
	ld hl, $0204
	ld bc, $020C
	farcall TileCanvas_UploadRect
	ret
