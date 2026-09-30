; engine/account/mail_address_entry.asm
; bank 68, $571D-$5D00 (1507 bytes); pinned by layout.link
; mail address entry screen and intro page

SECTION "engine/account/mail_address_entry", ROMX

; ---- code $571D-$5739 (28 bytes) [CONFIRMED] 239 insn(s); 239 executed (in up to 3/18 scenarios) (part of region $54D6-$5739)

Account_MailAddressEntryScreen:: ; 68:571D
	call Account_MailAddressEntry_Setup
	farcall Palette_FadeInFromWhite
	call Account_MailAddressEntry_InputLoop
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	ld a, [wRam_C27C]
	ret

; ---- code $5739-$57B6 (125 bytes) [HYPOTHESIS] complete ret-terminated function (59 insn), twin of 52B2-531A (same SRAM/[$C278] logic with $B071/$B07A); entry not proven. [verifier: retracted the earlier claim that the words $5770/$5798 of the table at 528C enter this range: that table is indexed and passed to a far call with a=$4A (68:5283), so its words are pointers into bank 4A, and $5770 would lie inside the operand of `ld de,$DEAB` here anyway]

Function_68_5739:: ; 68:5739
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
	ld hl, $B071
	ld de, $C28F
	call DecodeXorA5
	ld hl, $C28F
	ld de, $DEAB
	call CompareString
	or a, a
	jr nz, Label_68_578C
	ld hl, $B07A
	ld de, $C28F
	call DecodeXorA5
	ld hl, $C28F
	ld de, $DEB4
	call CompareString
	or a, a
	jr z, Label_68_5798

Label_68_578C:: ; 68:578C
	ld a, [wSettingsFieldMask]
	ld b, a
	ld a, $02
	xor a, $FF
	and a, b
	ld [wSettingsFieldMask], a

Label_68_5798:: ; 68:5798
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

; ---- code $57B6-$58E8 (306 bytes) [CONFIRMED] 99 insn(s); 99 executed (in up to 3/18 scenarios); entry proven: target of an executed call/far call

Account_MailAddressEntry_Setup:: ; 68:57B6
Function_68_57B6::
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Function_00_09B6
	xor a, a
	ld [wRam_C27C], a
	ld [wRam_C27D], a
	ld hl, $DE80
	ld b, $09
	farcall TextBuf_Init
	ld hl, $DE94
	ld b, $05
	farcall TextBuf_Init
	ld hl, $DE80
	ld de, $DEAB
	call TextEntry_InsertString
	ld hl, $DE94
	ld de, $DEB4
	call TextEntry_InsertString
	call Account_MailAddressEntry_CheckDomainLen
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
	ld hl, Data_5E_5800
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_5E_5C00
	ld a, $5E
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
	ld hl, Data_5E_6000
	ld a, $5E
	farcall Function_00_08EA
	ld a, $03
	ld hl, $DE83
	call Account_MailLocal_PrintField
	ld a, $03
	ld hl, $DE97
	call Account_MailDomain_PrintField
	call Account_MailLocal_UploadTextTiles
	call Account_MailDomain_UploadTextTiles
	call Account_MailAddress_BuildTextMap
	ldh a, [rLCDC]
	call Function_00_082C
	ld a, $01
	ld b, $02
	farcall Kbd_Open
	ld hl, $DA00
	ld de, $4D30
	ld a, $5F
	ld b, $81
	farcall Function_00_0A82
	ld hl, $DE94
	farcall TextBuf_GetLength
	or a, a
	jr nz, Label_68_58BB
	ld hl, $DE80
	farcall TextBuf_GetFree
	or a, a
	jr z, Label_68_58BB
	ld d, $08
	ld e, $10
	ld hl, $DE80
	jr Label_68_58C7

Label_68_58BB:: ; 68:58BB
	ld a, $01
	ld [wRam_C27D], a
	ld d, $40
	ld e, $10
	ld hl, $DE94

Label_68_58C7:: ; 68:58C7
	farcall TextEntry_UpdateCursorSprite
	ld hl, $DE94
	farcall TextBuf_GetLength
	cp a, $03
	jr c, Label_68_58DB
	ret

Label_68_58DB:: ; 68:58DB
	farcall Kbd_ShowMarkerSprite
	farcall Function_00_0956
	ret

; ---- code $58E8-$58FB (19 bytes) [HYPOTHESIS] complete function: [$C278] bit1 -> [$C27E] = 0/1, ret; twin of 5404-5417; entry not proven [verifier: no entry proven (no caller, no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS]

Function_68_58E8:: ; 68:58E8
	ld a, [wSettingsFieldMask]
	and a, $02
	jr nz, Label_68_58F5
	ld a, $00
	ld [wRam_C27E], a
	ret

Label_68_58F5:: ; 68:58F5
	ld a, $01
	ld [wRam_C27E], a
	ret

; ---- code $58FB-$59A8 (173 bytes) [CONFIRMED] 68 insn(s); 68 executed (in up to 3/18 scenarios); entry proven: target of an executed call/far call

Account_MailAddressEntry_UpdateOkState:: ; 68:58FB
Function_68_58FB::
	ld hl, $DE94
	farcall TextBuf_GetFree
	or a, a
	jr z, Label_68_590D
	ld a, $00
	ld [wRam_C27E], a
	ret

Label_68_590D:: ; 68:590D
	ld a, $01
	ld [wRam_C27E], a
	ret

Account_MailAddressEntry_CheckDomainLen:: ; 68:5913
	ld hl, $DE94
	farcall TextBuf_GetLength
	cp a, $03
	jr nc, Label_68_5926
	ld a, $00
	ld [wRam_C27E], a
	ret

Label_68_5926:: ; 68:5926
	ld a, $01
	ld [wRam_C27E], a
	ret

Account_MailAddressEntry_InputLoop:: ; 68:592C
	farcall Function_00_0956
	ld a, [wRam_C27E]
	ld c, a
	farcall Kbd_Run
	cp a, $01
	jr z, Label_68_5952
	cp a, $02
	jp z, Label_68_59D7
	cp a, $07
	jp z, Label_68_5A42
	cp a, $08
	jp z, Label_68_5A7D
	jp Label_68_5AB0

Label_68_5952:: ; 68:5952
	ld a, [wKeyboardCharLo]
	ld d, a
	ld a, [wRam_C27D]
	or a, a
	jr nz, Label_68_598A
	ld hl, $DE80
	farcall TextBuf_AppendChar
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld hl, $DE80
	farcall TextBuf_GetFree
	or a, a
	jp nz, Label_68_5A95
	ld a, $01
	ld [wRam_C27D], a
	jp Label_68_5A95

Label_68_598A:: ; 68:598A
	ld hl, $DE94
	farcall TextBuf_AppendChar
	or a, a
	jr nz, Label_68_59A8
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	jr Label_68_59B8

; ---- code $59A8-$59B8 (16 bytes) [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1; entered by jrcc from 68:5994 (executed) [executed in 1 scenarios]

Label_68_59A8:: ; 68:59A8
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a

; ---- code $59B8-$5A2E (118 bytes) [CONFIRMED] 42 insn(s); 42 executed (in up to 3/18 scenarios)

Label_68_59B8:: ; 68:59B8
	ld hl, $DE94
	farcall TextBuf_GetLength
	cp a, $03
	jr c, Label_68_59CE
	farcall Kbd_HideMarkerSprite
	jp Label_68_5AA2

Label_68_59CE:: ; 68:59CE
	farcall Kbd_ShowMarkerSprite
	jp Label_68_5AA2

Label_68_59D7:: ; 68:59D7
	ld a, [wRam_C27D]
	or a, a
	jr nz, Label_68_59FD
	ld hl, $DE80
	farcall TextBuf_DeleteLast
	or a, a
	jp nz, Label_68_5A7D
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0039
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	jp Label_68_5A95

Label_68_59FD:: ; 68:59FD
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0039
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld hl, $DE94
	farcall TextBuf_DeleteLast
	or a, a
	jr nz, Label_68_5A36
	ld hl, $DE94
	farcall TextBuf_GetLength
	cp a, $03
	jr c, Label_68_5A2E
	farcall Kbd_HideMarkerSprite
	jr Label_68_5AA2

; ---- code $5A2E-$5A36 (8 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1; entered by jrcc from 68:5A24 (executed) [executed in 1 scenarios]

Label_68_5A2E:: ; 68:5A2E
	farcall Kbd_ShowMarkerSprite
	jr Label_68_5AA2

; ---- code $5A36-$5D00 (714 bytes) [CONFIRMED] 297 insn(s); 297 executed (in up to 7/18 scenarios) (part of region $5A36-$5D2F)

Label_68_5A36:: ; 68:5A36
	xor a, a
	ld [wRam_C27D], a
	farcall Kbd_ShowMarkerSprite
	jr Label_68_59D7

Label_68_5A42:: ; 68:5A42
	ld hl, $DE94
	farcall TextBuf_GetLength
	cp a, $03
	jr nc, Label_68_5A61
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	jr Label_68_5AB0

Label_68_5A61:: ; 68:5A61
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	call Account_CommitMailFields
	call Account_BuildMailAddress
	ld a, $01
	ld [wRam_C27C], a
	ret

Label_68_5A7D:: ; 68:5A7D
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	call Account_CommitMailFields
	xor a, a
	ld [wRam_C27C], a
	ret

Label_68_5A95:: ; 68:5A95
	ld a, $03
	ld hl, $DE83
	call Account_MailLocal_PrintField
	call Account_MailLocal_UploadTextTiles
	jr Label_68_5AB0

Label_68_5AA2:: ; 68:5AA2
	ld a, $03
	ld hl, $DE97
	call Account_MailDomain_PrintField
	call Account_MailDomain_UploadTextTiles
	call Account_MailAddressEntry_UpdateOkState

Label_68_5AB0:: ; 68:5AB0
	ld a, [wRam_C27D]
	or a, a
	jr nz, Label_68_5AC6
	ld d, $08
	ld e, $10
	ld hl, $DE80
	farcall TextEntry_UpdateCursorSprite
	jp Account_MailAddressEntry_InputLoop

Label_68_5AC6:: ; 68:5AC6
	ld d, $40
	ld e, $10
	ld hl, $DE94
	farcall TextEntry_UpdateCursorSprite
	jp Account_MailAddressEntry_InputLoop

Account_CommitMailFields:: ; 68:5AD6
	ld hl, $DE80
	ld de, $DEAB
	farcall TextEntry_CopyText
	ld hl, $DE94
	ld de, $DEB4
	farcall TextEntry_CopyText
	ret

Account_MailAddress_BuildTextMap:: ; 68:5AEF
	ld hl, $D041
	ld de, $0000
	ld bc, $0206
	farcall Tilemap_FillAscendingWithAttr
	ld hl, $D048
	ld de, $0010
	ld bc, $0203
	farcall Tilemap_FillAscendingWithAttr
	ret

Account_MailLocal_PrintField:: ; 68:5B0E
	push hl
	push af
	ld de, $FFFF
	ld hl, $0201
	ld bc, $0206
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hRam_FFBA], a
	ld a, $03
	ldh [hRam_FFBB], a
	ld a, $15
	ldh [hTextY], a
	ld a, $08
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $10
	ldh [hRam_FFC0], a
	ld a, $08
	ldh [hRam_FFC1], a
	ld a, $00
	ldh [hRam_FFC2], a
	ld a, $20
	ldh [hRam_FFC3], a
	ld a, $38
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

Account_MailDomain_PrintField:: ; 68:5B59
	push hl
	push af
	ld de, $FFFF
	ld hl, $0208
	ld bc, $0203
	farcall TileCanvas_FillRect
	ld a, $00

Label_68_5B6C:: ; 68:5B6C
	ldh [hRam_FFBA], a
	ld a, $03

Label_68_5B70:: ; 68:5B70
	ldh [hRam_FFBB], a
	ld a, $15

Label_68_5B74:: ; 68:5B74
	ldh [hTextY], a
	ld a, $40

Label_68_5B78:: ; 68:5B78
	ldh [hTextX], a
	ld a, $00

Label_68_5B7C:: ; 68:5B7C
	ldh [hTextX + 1], a
	ld a, $10

Label_68_5B80:: ; 68:5B80
	ldh [hRam_FFC0], a
	ld a, $40

Label_68_5B84:: ; 68:5B84
	ldh [hRam_FFC1], a
	ld a, $00

Label_68_5B88:: ; 68:5B88
	ldh [hRam_FFC2], a
	ld a, $20

Label_68_5B8C:: ; 68:5B8C
	ldh [hRam_FFC3], a
	ld a, $58
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

Account_MailLocal_UploadTextTiles:: ; 68:5BA4
	ld de, $9000
	ld hl, $0201
	ld bc, $0206
	farcall TileCanvas_UploadRect
	ret

Account_MailDomain_UploadTextTiles:: ; 68:5BB4
	ld de, $9100
	ld hl, $0208
	ld bc, $0203
	farcall TileCanvas_UploadRect
	ret

Account_MailIntroPage:: ; 68:5BC4
	call Account_MailIntro_Draw
	farcall Palette_FadeInFromWhite

Label_68_5BCD:: ; 68:5BCD
	call Function_00_044B
	farcall Joypad_Update
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, Label_68_5BE2
	bit 1, a
	jr nz, Label_68_5BF6
	jr Label_68_5BCD

Label_68_5BE2:: ; 68:5BE2
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, $01
	jr Label_68_5C09

Label_68_5BF6:: ; 68:5BF6
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	xor a, a
	jr Label_68_5C09

Label_68_5C09:: ; 68:5C09
	push af
	farcall Palette_FadeOutToWhite
	pop af
	ret

Account_MailIntro_Draw:: ; 68:5C12
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Function_00_09B6
	ld de, $9001
	ld hl, Data_5E_60D0
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_5E_64D0
	ld a, $5E
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
	ld hl, Data_5E_68D0
	ld a, $5E
	farcall Function_00_08EA
	call Account_MailIntro_PrintMessage
	ldh a, [rLCDC]
	call Function_00_082C
	ret

Account_MailIntro_PrintMessage:: ; 68:5C71
	ld a, $01
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
