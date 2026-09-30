; engine/account/password_entry.asm
; bank 68, $5D00-$61F7 (1271 bytes); pinned by layout.link
; password entry screen, validity check and intro page

SECTION "engine/account/password_entry", ROMX

; ---- code $5D00-$5D2F (47 bytes) [CONFIRMED] 297 insn(s); 297 executed (in up to 7/18 scenarios) (part of region $5A36-$5D2F)

Account_PasswordEntryScreen:: ; 68:5D00
	ld [wRam_C27D], a
	call Account_PasswordEntry_Setup
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0009
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	call Account_PasswordEntry_InputLoop
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	ld a, [wRam_C27C]
	ret

; ---- code $5D2F-$5D9C (109 bytes) [HYPOTHESIS] complete ret-terminated function (54 insn) between proven code; entry not proven [verifier: no entry proven (no caller, no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS]

Function_68_5D2F:: ; 68:5D2F
	ret

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
	ld hl, $B07F
	ld de, $C28F
	call DecodeXorA5
	ld hl, $C28F
	ld de, $DED4
	call CompareString
	or a, a
	jr z, Label_68_5D7E
	xor a, a
	ld [wRam_C279], a
	ld a, [wSettingsFieldMask]
	ld b, a
	ld a, $04
	xor a, $FF
	and a, b
	ld [wSettingsFieldMask], a

Label_68_5D7E:: ; 68:5D7E
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

; ---- code $5D9C-$5E92 (246 bytes) [CONFIRMED] 86 insn(s); 86 executed (in up to 7/18 scenarios); entry proven: target of an executed call/far call

Account_PasswordEntry_Setup:: ; 68:5D9C
Function_68_5D9C::
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Function_00_09B6
	xor a, a
	ld [wRam_C27C], a
	ld hl, $DE80
	ld b, $09
	farcall TextBuf_Init
	ld hl, $DE80
	ld de, $DED4
	call TextEntry_InsertString
	call Account_PasswordEntry_UpdateOkState
	ld a, [wRam_C27D]
	or a, a
	jr nz, Label_68_5DCD

Label_68_5DCD:: ; 68:5DCD
	ld de, $8801
	ld hl, Data_5D_4000
	ld a, $5D
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, Data_5D_4400
	ld a, $5D
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_5D_4800
	ld a, $5D
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_5D_4C00
	ld a, $5D
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, Data_5E_4D00
	ld a, $5E
	farcall Palette_LoadToBuffer
	ld a, [wRam_C27D]
	ld hl, Account_PasswordEntryMaps
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0514
	ld de, $D000
	ld a, $5D
	farcall Function_00_08EA
	ld a, $03
	ld hl, $DE83
	call Account_Password_PrintField
	call Account_Password_UploadTextTiles
	call Account_Password_BuildTextMap
	ldh a, [rLCDC]
	call Function_00_082C
	ld a, $04
	ld b, $02
	farcall Kbd_Open
	ld hl, $DA00
	ld de, $4D30
	ld a, $5F
	ld b, $81
	farcall Function_00_0A82
	ld d, $38
	ld e, $10
	ld hl, $DE80
	farcall TextEntry_UpdateCursorSprite
	call Account_PasswordIsValid
	or a, a
	jr z, Label_68_5E85
	ret

Label_68_5E85:: ; 68:5E85
	farcall Kbd_ShowMarkerSprite
	farcall Function_00_0956
	ret

; ---- words $5E92-$5E9A (8 bytes) [PROBABLE] 4 words $5000,$50C8,$5190,$5258 (stride $C8) read with `ld hl,$5E92 ... ld a,[hli] ; ld h,[hl] ; ld l,a` at 68:5E29 and used as HL of the far call with a=$5D (68:5E3C, bc=$0514, de=$D000): pointers into BANK 5D data, NOT into bank 68 code [verifier: retyped ptrtable->words (the generator emitted `dw Label_68_5000`/`Label_68_50C8`, false references to bank-68 code); range trimmed from 5E92-5E9C by classify_g2, the 5th word $78FA was the operand of `ld a,[$C278]` at 5E9A]

Account_PasswordEntryMaps:: ; 68:5E92
Table_68_5E92::
	dw $5000, $50C8, $5190, $5258

; ---- code $5E9A-$5EAE (20 bytes) [HYPOTHESIS] 8-insn routine ld a,[$C278] ; and 4 ; ... ld [$C27E],a ; ret ; call $5FE1 ; ld [$C27E],a ; ret; the operand bytes `fa 78 c2` at 5E9A show the mapper's 5th table word ($78FA) was never a word (the 4 real words 5E92-5E9A have stride $C8); entry not proven [verifier: no caller/table word -> HYPOTHESIS]

Function_68_5E9A:: ; 68:5E9A
	ld a, [wSettingsFieldMask]
	and a, $04
	jr nz, Label_68_5EA7
	ld a, $00
	ld [wRam_C27E], a
	ret

Label_68_5EA7:: ; 68:5EA7
	call Account_PasswordIsValid
	ld [wRam_C27E], a
	ret

; ---- code $5EAE-$5EE9 (59 bytes) [CONFIRMED] 22 insn(s); 22 executed (in up to 7/18 scenarios); entry proven: target of an executed call/far call

Account_PasswordEntry_UpdateOkState:: ; 68:5EAE
Function_68_5EAE::
	ld hl, $DE80
	farcall TextBuf_GetFree
	or a, a
	jr z, Label_68_5EC0
	ld a, $00
	ld [wRam_C27E], a
	ret

Label_68_5EC0:: ; 68:5EC0
	call Account_PasswordIsValid
	ld [wRam_C27E], a
	ret

Account_PasswordEntry_InputLoop:: ; 68:5EC7
	farcall Function_00_0956
	ld a, [wRam_C27E]
	ld c, a
	farcall Kbd_Run
	cp a, $01
	jr z, Label_68_5EEC
	cp a, $02
	jr z, Label_68_5F36
	cp a, $07
	jp z, Label_68_5F68
	cp a, $08
	jp z, Label_68_5FA2

; ---- code $5EE9-$5EEC (3 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jpcc at 68:5EE6 (executed)
	jp Label_68_5FDE

; ---- code $5EEC-$6020 (308 bytes) [CONFIRMED] 129 insn(s); 129 executed (in up to 7/18 scenarios)

Label_68_5EEC:: ; 68:5EEC
	ld a, [wKeyboardCharLo]
	ld hl, $DE80
	ld d, a
	farcall TextBuf_AppendChar
	or a, a
	jr nz, Label_68_5F0E
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	jr Label_68_5F1E

Label_68_5F0E:: ; 68:5F0E
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a

Label_68_5F1E:: ; 68:5F1E
	call Account_PasswordIsValid
	or a, a
	jr z, Label_68_5F2D
	farcall Kbd_HideMarkerSprite
	jp Label_68_5FC3

Label_68_5F2D:: ; 68:5F2D
	farcall Kbd_ShowMarkerSprite
	jp Label_68_5FC3

Label_68_5F36:: ; 68:5F36
	ld hl, $DE80
	farcall TextBuf_DeleteLast
	or a, a
	jr nz, Label_68_5FA2
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0039
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	call Account_PasswordIsValid
	or a, a
	jr z, Label_68_5F60
	farcall Kbd_HideMarkerSprite
	jr Label_68_5FC3

Label_68_5F60:: ; 68:5F60
	farcall Kbd_ShowMarkerSprite
	jr Label_68_5FC3

Label_68_5F68:: ; 68:5F68
	call Account_PasswordIsValid
	or a, a
	jr nz, Label_68_5F80
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	jr Label_68_5FDE

Label_68_5F80:: ; 68:5F80
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld hl, $DE80
	ld de, $DED4
	farcall TextEntry_CopyText
	ld a, $01
	ld [wRam_C27C], a
	ret

Label_68_5FA2:: ; 68:5FA2
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld hl, $DE80
	ld de, $DED4
	farcall TextEntry_CopyText
	xor a, a
	ld [wRam_C27C], a
	ret

Label_68_5FC3:: ; 68:5FC3
	ld d, $38
	ld e, $10
	ld hl, $DE80
	farcall TextEntry_UpdateCursorSprite
	ld a, $03
	ld hl, $DE83
	call Account_Password_PrintField
	call Account_Password_UploadTextTiles
	call Account_PasswordEntry_UpdateOkState

Label_68_5FDE:: ; 68:5FDE
	jp Account_PasswordEntry_InputLoop

Account_PasswordIsValid:: ; 68:5FE1
	ld hl, $DE80
	farcall TextBuf_GetLength
	cp a, $04
	jp c, Label_68_604E
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [hRam_FFB0], a
	ldh [hRam_FFB1], a
	ld hl, $DE83

Label_68_6004:: ; 68:6004
	ld a, [hli]
	or a, a
	jr z, Label_68_602E
	cp a, $30
	jr c, Label_68_6004
	cp a, $3A
	jr c, Label_68_6022
	cp a, $41
	jr c, Label_68_6004
	cp a, $5B
	jr c, Label_68_6028
	cp a, $61
	jr c, Label_68_6004
	cp a, $7B
	jr c, Label_68_6028

; ---- code $6020-$6022 (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 68:601E (executed)
	jr Label_68_6004

; ---- code $6022-$61F7 (469 bytes) [CONFIRMED] 284 insn(s); 284 executed (in up to 7/18 scenarios) (part of region $6022-$6308)

Label_68_6022:: ; 68:6022
	ld a, $01
	ldh [hRam_FFB0], a
	jr Label_68_6004

Label_68_6028:: ; 68:6028
	ld a, $01
	ldh [hRam_FFB1], a
	jr Label_68_6004

Label_68_602E:: ; 68:602E
	ld hl, $FFB0
	ld a, [hli]
	or a, a
	jr z, Label_68_6045
	ld a, [hl]
	or a, a
	jr z, Label_68_6045
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, $01
	ret

Label_68_6045:: ; 68:6045
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]

Label_68_604E:: ; 68:604E
	xor a, a
	ret

Account_Password_BuildTextMap:: ; 68:6050
	ld hl, $D047
	ld de, $0000
	ld bc, $0206
	farcall Tilemap_FillAscendingWithAttr
	ret

Account_Password_PrintField:: ; 68:6060
	push hl
	push af
	ld de, $FFFF
	ld hl, $0207
	ld bc, $0206
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hRam_FFBA], a
	ld a, $03
	ldh [hRam_FFBB], a
	ld a, $15
	ldh [hTextY], a
	ld a, $38
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $10
	ldh [hRam_FFC0], a
	ld a, $38
	ldh [hRam_FFC1], a
	ld a, $00
	ldh [hRam_FFC2], a
	ld a, $20
	ldh [hRam_FFC3], a
	ld a, $98
	ldh [hRam_FFC4], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hRam_FFC6], a
	ld a, $0C
	ldh [hRam_FFC7], a
	pop af
	pop hl
	call Function_00_0ED3
	ret

Account_Password_UploadTextTiles:: ; 68:60AB
	ld de, $9000
	ld hl, $0207
	ld bc, $0206
	farcall TileCanvas_UploadRect
	ret

Account_PasswordIntroPage:: ; 68:60BB
	call Account_PasswordIntro_Draw
	farcall Palette_FadeInFromWhite

Label_68_60C4:: ; 68:60C4
	call Function_00_044B
	farcall Joypad_Update
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, Label_68_60D9
	bit 1, a
	jr nz, Label_68_60ED
	jr Label_68_60C4

Label_68_60D9:: ; 68:60D9
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, $01
	jr Label_68_6100

Label_68_60ED:: ; 68:60ED
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	xor a, a
	jr Label_68_6100

Label_68_6100:: ; 68:6100
	push af
	farcall Palette_FadeOutToWhite
	pop af
	ret

Account_PasswordIntro_Draw:: ; 68:6109
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Function_00_09B6
	ld de, $9001
	ld hl, Data_5D_5320
	ld a, $5D
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_5D_5720
	ld a, $5D
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, Data_5E_4D00
	ld a, $5E
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, Data_5D_5B20
	ld a, $5D
	farcall Function_00_08EA
	call Account_PasswordIntro_PrintMessage
	ldh a, [rLCDC]
	call Function_00_082C
	ret

Account_PasswordIntro_PrintMessage:: ; 68:6168
	ld a, $02
	farcall Function_00_153D
	push hl
	push af
	ld de, $FFFF
	ld hl, $0701
	ld bc, $0812
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hRam_FFBA], a
	ld a, $03
	ldh [hRam_FFBB], a
	ld a, $38
	ldh [hTextY], a
	ld a, $08
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $38
	ldh [hRam_FFC0], a
	ld a, $08
	ldh [hRam_FFC1], a
	ld a, $00
	ldh [hRam_FFC2], a
	ld a, $78
	ldh [hRam_FFC3], a
	ld a, $98
	ldh [hRam_FFC4], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hRam_FFC6], a
	ld a, $0C
	ldh [hRam_FFC7], a
	pop af
	pop hl
	call Function_00_0ED3
	ld de, $9000
	ld hl, $0701
	ld bc, $0712
	farcall TileCanvas_UploadRect
	ld de, $8800
	ld hl, $0E01
	ld bc, $0112
	farcall TileCanvas_UploadRect
	ld hl, $D0E1
	ld bc, $0712
	ld de, $0000
	farcall Tilemap_FillAscendingWithAttr
	ld hl, $D1C1
	ld bc, $0112
	ld de, $0080
	farcall Tilemap_FillAscendingWithAttr
	ret
