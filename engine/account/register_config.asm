; engine/account/register_config.asm
; bank 68, $6AE0-$6E1A (826 bytes); pinned by layout.link
; registration: write config to adapter, build config image from account

SECTION "engine/account/register_config", ROMX

Registration_WriteConfigToAdapter:: ; 68:6AE0
Function_68_6AE0::
	; [CONFIRMED] 106 insn(s); 106 executed (in up to 3/18 scenarios); entry proven: target of an
	; executed call/far call
	call Registration_WriteConfig_Setup
	farcall Palette_FadeInFromWhite
	call Registration_WriteConfig_RunState
	farcall Palette_FadeOutToWhite
	ld a, [wRegistrationWriteConfig_Result]
	ret

Registration_WriteConfig_Setup:: ; 68:6AF6
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	xor a, a
	ld [wRegistrationWriteConfig_Result], a
	ld [wRegistrationWriteConfig_State], a
	ld de, $8801
	ld hl, $6A00
	ld a, $5D
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_Registration_WriteConfig_Tiles9000Vb1
	ld a, BANK(Gfx_Registration_WriteConfig_Tiles9000Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8000
	ld hl, Gfx_Registration_WriteConfig_Tiles8000
	ld a, BANK(Gfx_Registration_WriteConfig_Tiles8000)
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, $7000
	ld a, $5D
	farcall Palette_LoadToBuffer
	ld bc, $0008
	ld de, wPaletteBufObj
	ld hl, $7040
	ld a, $5D
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, $7048
	ld a, $5D
	farcall Tilemap_CopyRectAndAttr
	call Registration_DoNotUnplugMessage
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld hl, wSpriteSlot0
	ld de, Table_5D_7318
	ld a, BANK(Table_5D_7318)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1838
	ld hl, wSpriteSlot0
	call Sprite_SetPosition
	ret

Registration_WriteConfig_RunState:: ; 68:6B98
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSpriteSlot0 + $04]
	ld b, a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, b
	or a, a
	jr z, .l6BE0
	cp a, $02
	jr nz, .l6BE4
	ld a, [wRegistrationWriteConfig_SfxFlag]
	or a, a
	jr nz, .l6BE4
	play_sfx SFX_ADAPTER_ANIM
	ld a, $01
	ld [wRegistrationWriteConfig_SfxFlag], a
	jr .l6BE4
.l6BE0 ; 68:6BE0
	xor a, a
	ld [wRegistrationWriteConfig_SfxFlag], a
.l6BE4 ; 68:6BE4
	ld a, [wRegistrationWriteConfig_State]
	add a, a
	add a, $F4
	ld l, a
	ld a, $6B
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- words $6BF4-$6BFA (6 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown [retyped data->words by classify_g2: every word is an instruction start of a code region of this bank (jump/dispatch table)]

Registration_WriteConfig_StateTable:: ; 68:6BF4
Table_68_6BF4::
	dw Registration_WriteConfig_StateInit, Registration_WriteConfig_StateWrite, Registration_WriteConfig_StateFinish

Registration_WriteConfig_StateInit:: ; 68:6BFA
	; [CONFIRMED] 40 insn(s); 40 executed (in up to 3/18 scenarios)
	ld de, wMobileAdapterType
	ld hl, $0068
	ld a, $02
	call MobileAPI
	ld a, $01
	ld [wRegistrationWriteConfig_State], a
	jr Registration_WriteConfig_RunState

Registration_WriteConfig_StateWrite:: ; 68:6C0C
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Registration_WriteConfig_OnAdapterError
	bit 0, a
	jp nz, Registration_WriteConfig_RunState
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $02
	ldh [hSRAMBank], a
	ld [rRAMB], a
	call Config_BuildImageFromAccount
	ld c, $C0
	ld hl, sConfigImage
	ld de, $0000
	ld a, $04
	call MobileAPI
	ld a, $02
	ld [wRegistrationWriteConfig_State], a
	jp Registration_WriteConfig_RunState

Registration_WriteConfig_StateFinish:: ; 68:6C3F
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Registration_WriteConfig_OnAdapterError
	bit 0, a
	jp nz, Registration_WriteConfig_RunState
	ld a, $36
	call MobileAPI
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ld [wRegistrationWriteConfig_Result], a
	ret

Registration_WriteConfig_OnAdapterError:: ; 68:6C5D
Label_68_6C5D::
	; [PROBABLE] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 1;
	; entered by jpcc from 68:6C11 (executed)
	farcall Mobile_SaveLastResult
	farcall Palette_FadeOutToWhite
	farcall Mobile_ShowLastError
	ld a, $36
	call MobileAPI
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ld [wRegistrationWriteConfig_Result], a
	ret

Registration_DoNotUnplugMessage:: ; 68:6C7F
Function_68_6C7F::
	; [CONFIRMED] 135 insn(s); 135 executed (in up to 3/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $03
	farcall PromptText_Load
	push hl
	push af
	ld de, $FFFF
	ld hl, $0B01
	ld bc, $0612
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $58
	ldh [hTextY], a
	ld a, $08
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $58
	ldh [hRam_FFC0], a
	ld a, $08
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextBox_LineStartXHi], a
	ld a, $88
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
	ld hl, $0B01
	ld bc, $0612
	farcall TileCanvas_UploadRect
	ld hl, wScreenTileMap + $161
	ld bc, $0612
	ld de, $0000
	farcall Tilemap_FillAscendingWithAttr
	ret

Config_BuildImageFromAccount:: ; 68:6CF0
	ld a, [sSram_A003]
	push af
	ld a, [wMobileAdapterType]
	ld hl, Config_DefaultImageTable
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $00C0
	ld de, sConfigImage
	call CopyBytes
	ld a, $FF
	ld bc, $0040
	ld hl, sConfigImagePad
	call FillBytes
	pop af
	ld [sSram_A003], a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, Config_HostPrefixStrings
	ld de, wAcctHostScratch
	call CopyString
	ld hl, wAcctMailSubdomain
	ld de, wAcctHostScratch
	call StringAppend
	ld hl, Config_DionDomainSuffix
	ld de, wAcctHostScratch
	call StringAppend
	ld hl, wAcctHostScratch
	ld de, sConfigPopServer
	ld bc, $0014
	call CopyStringMax
	ld hl, $6E08
	ld de, wAcctHostScratch
	call CopyString
	ld hl, wAcctMailSubdomain
	ld de, wAcctHostScratch
	call StringAppend
	ld hl, Config_DionDomainSuffix
	ld de, wAcctHostScratch
	call StringAppend
	ld hl, wAcctHostScratch
	ld de, sConfigSmtpServer
	ld bc, $0014
	call CopyStringMax
	ld hl, wAcctLoginId
	ld de, sConfigLoginId
	call CopyString
	ld hl, wAcctMailAddress
	ld de, sConfigMailAddress
	call CopyString
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [wMobileAdapterType]
	ld hl, Dial_DefaultNumberTable
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, sSettingsDialNumbers
	call EncodeXorA5
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ld a, [wManualNumbersFlag]
	or a, a
	jr z, .l6DF3

	; [CONFIRMED] 22 insn(s) reached by static flow only; seeds: exec x22; min discovery hops 0;
	; fall-through of the jrcc at 68:6DBB (executed) [executed in 2 scenarios]
	ld hl, wAcctNumberInternet
	ld de, sConfigDial0Number
	call PhoneNumber_PackBcd
	ld hl, wAcctNumberComment
	ld de, sConfigDial0Text
	ld bc, $0010
	call CopyStringMax
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, wAcctNumberSelfPage
	ld de, sSettingsDialNumbers
	call EncodeXorA5
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]

.l6DF3 ; 68:6DF3
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 3/18 scenarios)
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	farcall Config_MirrorUpdateChecksum
	ret

; ---- data $6E03-$6E0E (11 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown [clipped from 6E03-6E1A by higher-priority evidence]

Config_HostPrefixStrings:: ; 68:6E03
Data_68_6E03::
	db $70, $6F, $70, $2E, $00, $6D, $61, $69, $6C, $2E, $00

; ---- text $6E0E-$6E1A (12 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
Config_DionDomainSuffix:: ; 68:6E0E
String_68_6E0E::
	db ".dion.ne.jp", 0
POPC
