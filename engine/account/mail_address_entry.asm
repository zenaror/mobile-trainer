; engine/account/mail_address_entry.asm
; bank 68, $571D-$5D00 (1507 bytes); pinned by layout.link
; mail address entry screen and intro page

SECTION "engine/account/mail_address_entry", ROMX

Account_MailAddressEntryScreen:: ; 68:571D
	; [CONFIRMED] 239 insn(s); 239 executed (in up to 3/18 scenarios) (part of region $54D6-$5739)
	call Account_MailAddressEntry_Setup
	farcall Palette_FadeInFromWhite
	call Account_MailAddressEntry_InputLoop
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	ld a, [wMailAddressEntry_Result]
	ret

Account_MailAddress_ClearFlagIfChanged:: ; 68:5739
Function_68_5739::
	; [HYPOTHESIS] complete ret-terminated function (59 insn), twin of 52B2-531A (same SRAM/[$C278]
	; logic with $B071/$B07A); entry not proven. [verifier: retracted the earlier claim that the
	; words $5770/$5798 of the table at 528C enter this range: that table is indexed and passed to a
	; far call with a=$4A (68:5283), so its words are pointers into bank 4A, and $5770 would lie
	; inside the operand of `ld de,$DEAB` here anyway]
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
	jr nz, .l578C
	ld hl, $B07A
	ld de, $C28F
	call DecodeXorA5
	ld hl, $C28F
	ld de, $DEB4
	call CompareString
	or a, a
	jr z, .l5798
.l578C ; 68:578C
	ld a, [wSettingsFieldMask]
	ld b, a
	ld a, $02
	xor a, $FF
	and a, b
	ld [wSettingsFieldMask], a
.l5798 ; 68:5798
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

Account_MailAddressEntry_Setup:: ; 68:57B6
Function_68_57B6::
	; [CONFIRMED] 99 insn(s); 99 executed (in up to 3/18 scenarios); entry proven: target of an
	; executed call/far call
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	xor a, a
	ld [wMailAddressEntry_Result], a
	ld [wMailAddressEntry_Field], a
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
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Data_5E_4400
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_Account_MailAddressEntry_Tiles9000Vb1
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_Account_MailAddressEntry_Tiles9400Vb1
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, $D800
	ld hl, Data_5E_4D00
	ld a, $5E
	farcall Palette_LoadToBuffer
	ld bc, $0514
	ld de, $D000
	ld hl, Tilemap_Account_MailAddressEntry
	ld a, $5E
	farcall Tilemap_CopyRectAndAttr
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
	call Gfx_UploadBgMapBuffers
	ld a, $01
	ld b, $02
	farcall Kbd_Open
	ld hl, $DA00
	ld de, $4D30
	ld a, $5F
	ld b, $81
	farcall Sprite_InitSlot
	ld hl, $DE94
	farcall TextBuf_GetLength
	or a, a
	jr nz, .l58BB
	ld hl, $DE80
	farcall TextBuf_GetFree
	or a, a
	jr z, .l58BB
	ld d, $08
	ld e, $10
	ld hl, $DE80
	jr .l58C7
.l58BB ; 68:58BB
	ld a, $01
	ld [wMailAddressEntry_Field], a
	ld d, $40
	ld e, $10
	ld hl, $DE94
.l58C7 ; 68:58C7
	farcall TextEntry_UpdateCursorSprite
	ld hl, $DE94
	farcall TextBuf_GetLength
	cp a, $03
	jr c, .l58DB
	ret
.l58DB ; 68:58DB
	farcall Kbd_ShowMarkerSprite
	farcall Sprite_UpdateAll
	ret

Account_MailAddressEntry_OkStateFromMask:: ; 68:58E8
Function_68_58E8::
	; [HYPOTHESIS] complete function: [$C278] bit1 -> [$C27E] = 0/1, ret; twin of 5404-5417; entry
	; not proven [verifier: no entry proven (no caller, no valid table word, never executed): decode
	; chain alone is not proof -> HYPOTHESIS]
	ld a, [wSettingsFieldMask]
	and a, $02
	jr nz, .l58F5
	ld a, $00
	ld [wMailAddressEntry_OkFlag], a
	ret
.l58F5 ; 68:58F5
	ld a, $01
	ld [wMailAddressEntry_OkFlag], a
	ret

Account_MailAddressEntry_UpdateOkState:: ; 68:58FB
Function_68_58FB::
	; [CONFIRMED] 68 insn(s); 68 executed (in up to 3/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, $DE94
	farcall TextBuf_GetFree
	or a, a
	jr z, .l590D
	ld a, $00
	ld [wMailAddressEntry_OkFlag], a
	ret
.l590D ; 68:590D
	ld a, $01
	ld [wMailAddressEntry_OkFlag], a
	ret

Account_MailAddressEntry_CheckDomainLen:: ; 68:5913
	ld hl, $DE94
	farcall TextBuf_GetLength
	cp a, $03
	jr nc, .l5926
	ld a, $00
	ld [wMailAddressEntry_OkFlag], a
	ret
.l5926 ; 68:5926
	ld a, $01
	ld [wMailAddressEntry_OkFlag], a
	ret

Account_MailAddressEntry_InputLoop:: ; 68:592C
	farcall Sprite_UpdateAll
	ld a, [wMailAddressEntry_OkFlag]
	ld c, a
	farcall Kbd_Run
	cp a, $01
	jr z, .l5952
	cp a, $02
	jp z, .l59D7
	cp a, $07
	jp z, .l5A42
	cp a, $08
	jp z, .l5A7D
	jp .l5AB0
.l5952 ; 68:5952
	ld a, [wKeyboardCharLo]
	ld d, a
	ld a, [wMailAddressEntry_Field]
	or a, a
	jr nz, .l598A
	ld hl, $DE80
	farcall TextBuf_AppendChar
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld hl, $DE80
	farcall TextBuf_GetFree
	or a, a
	jp nz, .l5A95
	ld a, $01
	ld [wMailAddressEntry_Field], a
	jp .l5A95
.l598A ; 68:598A
	ld hl, $DE94
	farcall TextBuf_AppendChar
	or a, a
	jr nz, .l59A8
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	jr .l59B8

.l59A8 ; 68:59A8
	; [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1;
	; entered by jrcc from 68:5994 (executed) [executed in 1 scenarios]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a

.l59B8 ; 68:59B8
	; [CONFIRMED] 42 insn(s); 42 executed (in up to 3/18 scenarios)
	ld hl, $DE94
	farcall TextBuf_GetLength
	cp a, $03
	jr c, .l59CE
	farcall Kbd_HideMarkerSprite
	jp .l5AA2
.l59CE ; 68:59CE
	farcall Kbd_ShowMarkerSprite
	jp .l5AA2
.l59D7 ; 68:59D7
	ld a, [wMailAddressEntry_Field]
	or a, a
	jr nz, .l59FD
	ld hl, $DE80
	farcall TextBuf_DeleteLast
	or a, a
	jp nz, .l5A7D
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0039
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	jp .l5A95
.l59FD ; 68:59FD
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0039
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld hl, $DE94
	farcall TextBuf_DeleteLast
	or a, a
	jr nz, .l5A36
	ld hl, $DE94
	farcall TextBuf_GetLength
	cp a, $03
	jr c, .l5A2E
	farcall Kbd_HideMarkerSprite
	jr .l5AA2

.l5A2E ; 68:5A2E
	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by jrcc from 68:5A24 (executed) [executed in 1 scenarios]
	farcall Kbd_ShowMarkerSprite
	jr .l5AA2

.l5A36 ; 68:5A36
	; [CONFIRMED] 297 insn(s); 297 executed (in up to 7/18 scenarios) (part of region $5A36-$5D2F)
	xor a, a
	ld [wMailAddressEntry_Field], a
	farcall Kbd_ShowMarkerSprite
	jr .l59D7
.l5A42 ; 68:5A42
	ld hl, $DE94
	farcall TextBuf_GetLength
	cp a, $03
	jr nc, .l5A61
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	jr .l5AB0
.l5A61 ; 68:5A61
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	call Account_CommitMailFields
	call Account_BuildMailAddress
	ld a, $01
	ld [wMailAddressEntry_Result], a
	ret
.l5A7D ; 68:5A7D
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	call Account_CommitMailFields
	xor a, a
	ld [wMailAddressEntry_Result], a
	ret
.l5A95 ; 68:5A95
	ld a, $03
	ld hl, $DE83
	call Account_MailLocal_PrintField
	call Account_MailLocal_UploadTextTiles
	jr .l5AB0
.l5AA2 ; 68:5AA2
	ld a, $03
	ld hl, $DE97
	call Account_MailDomain_PrintField
	call Account_MailDomain_UploadTextTiles
	call Account_MailAddressEntry_UpdateOkState
.l5AB0 ; 68:5AB0
	ld a, [wMailAddressEntry_Field]
	or a, a
	jr nz, .l5AC6
	ld d, $08
	ld e, $10
	ld hl, $DE80
	farcall TextEntry_UpdateCursorSprite
	jp Account_MailAddressEntry_InputLoop
.l5AC6 ; 68:5AC6
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
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $15
	ldh [hTextY], a
	ld a, $08
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $10
	ldh [hRam_FFC0], a
	ld a, $08
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextBox_LineStartXHi], a
	ld a, $20
	ldh [hTextBox_MaxLineY], a
	ld a, $38
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hTextBox_LineAdvance], a
	ld a, $0C
	ldh [hRam_FFC7], a
	pop af
	pop hl
	call TextEngine_Run
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
	ldh [hTextBox_ColorSelB], a
	ld a, $03

Label_68_5B70:: ; 68:5B70
	ldh [hTextBox_ColorSelC], a
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
	ldh [hTextBox_LineStartX], a
	ld a, $00

Label_68_5B88:: ; 68:5B88
	ldh [hTextBox_LineStartXHi], a
	ld a, $20

Label_68_5B8C:: ; 68:5B8C
	ldh [hTextBox_MaxLineY], a
	ld a, $58
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hTextBox_LineAdvance], a
	ld a, $0C
	ldh [hRam_FFC7], a
	pop af
	pop hl
	call TextEngine_Run
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
.loop ; 68:5BCD
	call VBlank_WaitAndService
	farcall Joypad_Update
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, .l5BE2
	bit 1, a
	jr nz, .l5BF6
	jr .loop
.l5BE2 ; 68:5BE2
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, $01
	jr .l5C09
.l5BF6 ; 68:5BF6
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	xor a, a
	jr .l5C09
.l5C09 ; 68:5C09
	push af
	farcall Palette_FadeOutToWhite
	pop af
	ret

Account_MailIntro_Draw:: ; 68:5C12
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	ld de, $9001
	ld hl, Gfx_Account_MailIntro_Tiles9000Vb1
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_Account_MailIntro_Tiles9400Vb1
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, $D800
	ld hl, Data_5E_4D00
	ld a, $5E
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_Account_MailIntro
	ld a, $5E
	farcall Tilemap_CopyRectAndAttr
	call Account_MailIntro_PrintMessage
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ret

Account_MailIntro_PrintMessage:: ; 68:5C71
	ld a, $01
	farcall PromptText_Load
	push hl
	push af
	ld de, $FFFF
	ld hl, $0701
	ld bc, $0812
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $38
	ldh [hTextY], a
	ld a, $08
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $38
	ldh [hRam_FFC0], a
	ld a, $08
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextBox_LineStartXHi], a
	ld a, $78
	ldh [hTextBox_MaxLineY], a
	ld a, $98
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hTextBox_LineAdvance], a
	ld a, $0C
	ldh [hRam_FFC7], a
	pop af
	pop hl
	call TextEngine_Run
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
