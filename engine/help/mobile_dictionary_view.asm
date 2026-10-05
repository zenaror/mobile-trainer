; engine/help/mobile_dictionary_view.asm
; bank 4C, $4F56-$52DF (905 bytes); pinned by layout.link
; mobile dictionary page viewer (MobileDictView_*)

SECTION "engine/help/mobile_dictionary_view", ROMX

MobileDictView_Show:: ; 4C:4F56
Function_4C_4F56::
	; [CONFIRMED] 48 insn(s); 48 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld [wRam_C2DC], a
	call Url_StripFragment
	ld hl, wAttrUrlBuf
	farcall HtmlStore_BuildPageUrl
	xor a, a
	ld [wBrowserNavigating], a
	farcall MobileDictView_LoadEntry
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $DA00
	ld bc, $0600
	xor a, a
	ld [wDictHistoryCount], a
	ld [wDictHistoryHead], a
	call FillBytes
	ld a, $FF
	ld [wBrowserScrollbarEnable], a
	ld a, $02
	ld [wBrowserFrameStyle], a
	farcall Browser_LoadFrameGraphics

MobileDictView_Show_RenderPage:: ; 4C:4F95
Label_4C_4F95::
	ld bc, $0000
	ld de, $0000
	farcall Browser_SetScroll
	ld a, $00
	ldh [hBrowserSelectedLink], a
	ld hl, wSpriteSlot10
	call Sprite_ClearSlot
	ld hl, wSpriteSlot11
	call Sprite_ClearSlot
	xor a, a
	ld [wConnIconState], a
	ld [wConnIconGfxRequest], a
	ld hl, wSpriteSlot8
	call Sprite_ClearSlot
	farcall Browser_RenderPage
	ld b, $14
	ld c, $01
	farcall Joypad_SetRepeatTiming
	farcall Sprite_UpdateAll
	farcall Palette_FadeInFromWhite
	xor a, a
	ldh [hDialogResult], a

MobileDictView_Show_InputLoop:: ; 4C:4FDD
Label_4C_4FDD::
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $4FF5-$4FFF (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 4C:4FF2: 5 entries; fixed length (5 words) by the routine; every byte read as data in a trace

MobileDictView_InputTable:: ; 4C:4FF5
Table_4C_4FF5::
	dw MobileDictView_OnA
	dw MobileDictView_OnB
	dw MobileDictView_OnSelect
	dw MobileDictView_IgnoreStart
	dw MobileDictView_Idle

MobileDictView_Idle:: ; 4C:4FFF
Label_4C_4FFF::
	; [CONFIRMED] 215 insn(s); 215 executed (in up to 1/18 scenarios)
	ldh a, [hJoyPressedRepeat]
	bit 6, a
	jr nz, .l500C
	bit 7, a
	jr nz, .l5015
	jp MobileDictView_Show_InputLoop
.l500C ; 4C:500C
	farcall Browser_SelectPrevLink
	jp MobileDictView_Show_InputLoop
.l5015 ; 4C:5015
	farcall Browser_SelectNextLink
	jp MobileDictView_Show_InputLoop

MobileDictView_OnA:: ; 4C:501E
Label_4C_501E::
	ldh a, [hBrowserSelectedLink]
	or a, a
	jp z, MobileDictView_Show_InputLoop
	cp a, $FF
	jp z, MobileDictView_Show_InputLoop
	farcall Browser_FindLinkElement
	or a, a
	jp z, MobileDictView_Show_InputLoop
	ld bc, $000E
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, $00
	ld hl, $D600
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	ld de, $D500
	farcall HtmlUrl_Resolve
	ld hl, wAttrUrlBuf
	farcall HtmlUrl_NormalizePath
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $003E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, $01
	ld [wBrowserNavigating], a
	farcall MobileDictView_LoadEntry
	farcall Palette_FadeOutToWhite
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0080
	ld de, wPaletteBufBg
	ld hl, $D880
	call CopyBytes
	jp MobileDictView_Show_RenderPage

MobileDictView_OnB:: ; 4C:509A
Label_4C_509A::
	ld de, wAttrUrlBuf
	xor a, a
	farcall MobileDictView_HistoryPop
	or a, a
	jp z, MobileDictView_Show_Exit
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $003F
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	xor a, a
	ld [wBrowserNavigating], a
	farcall MobileDictView_LoadEntry
	farcall Palette_FadeOutToWhite
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0080
	ld de, wPaletteBufBg
	ld hl, $D880
	call CopyBytes
	jp MobileDictView_Show_RenderPage

MobileDictView_IgnoreStart:: ; 4C:50DD
Label_4C_50DD::
	jp MobileDictView_Show_InputLoop

MobileDictView_OnSelect:: ; 4C:50E0
Label_4C_50E0::
	xor a, a
	ldh [hDialogResult], a

MobileDictView_Show_Exit:: ; 4C:50E3
Label_4C_50E3::
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld bc, $000F
	farcall Sprite_WaitFrames
	farcall Palette_FadeOutToWhite
	farcall Sprite_ResetAll
	xor a, a
	ld [wBrowserNavigating], a
	ldh [hRam_FFA7], a
	ldh a, [hDialogResult]
	ret

Sprite_WaitFrames:: ; 4C:5111
	push bc
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	pop bc
	dec bc
	ld a, c
	or a, b
	jr nz, Sprite_WaitFrames
	ret

MobileDictView_LoadEntry:: ; 4C:5122
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld bc, $1000
	ld hl, sBrowserPageBuf
	ld a, $03
	call BankSwitch_H
	xor a, a
	call FillBytes
	call Sound_FrameService
	ld a, [wBrowserNavigating]
	or a, a
	jr z, .l5147
	farcall MobileDictView_HistoryPush
.l5147 ; 4C:5147
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wAttrUrlBuf
	ld de, $D500
	ld bc, $0100
	call CopyBytes
	ld hl, wAttrUrlBuf
	ld de, sBrowserPageBuf
	ld bc, $0FFC
	ld a, e
	ld [wBrowserRxPtr], a
	ld a, d
	ld [wBrowserRxPtr + 1], a
	ld a, $03
	ld [wBrowserRxBank], a
	farcall HtmlStore_LoadPage
	call Sound_FrameService
	farcall Browser_WrapImageInHtml
	or a, a
	jr nz, .l5194
	farcall Html_ScanPage
	ld a, [wHtmlFlags]
	and a, $01
	jr z, .l5194
	farcall MobileDictView_LoadImages
.l5194 ; 4C:5194
	farcall Html_ParsePage
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

MobileDictView_LoadImages:: ; 4C:51A1
	ld a, $00
	ldh [hInlineImages_UrlList], a
	ld a, $DE
	ldh [hInlineImages_UrlListHi], a
	ld a, $04
	ldh [hInlineImages_UrlBank], a
	ld de, wAttrUrlBuf
	ld hl, $D500
	ld bc, $0100
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call CopyBytes
	ld de, $DD00
	ld hl, wAttrUrlBuf
	ld bc, $0100
	ld a, $04
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call CopyBytes
.l51D1 ; 4C:51D1
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [wBrowserRxPtr]
	ld l, a
	ld a, [wBrowserRxPtr + 1]
	ld h, a
	ld a, [wBrowserRxBank]
	farcall Html_NextResourceRecord
	inc de
	inc de
	ld a, e
	ldh [hInlineImages_ListEnd], a
	ld a, d
	ldh [hInlineImages_ListEndHi], a
	xor a, a
	ld [de], a
	inc de
	ld [de], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hInlineImages_UrlList]
	ld l, a
	ldh a, [hInlineImages_UrlListHi]
	ld h, a
	ldh a, [hInlineImages_UrlBank]
	call BankSwitch_H
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	or a, e
	ret z

	; [PROBABLE] 49 insn(s) reached by static flow only; seeds: exec x49; min discovery hops 0;
	; fall-through of the retcc at 4C:520B (executed)
	ld a, l
	ldh [hInlineImages_UrlList], a
	ld a, h
	ldh [hInlineImages_UrlListHi], a
	inc de
	push de
	ldh a, [hInlineImages_ListEnd]
	ld l, a
	ldh a, [hInlineImages_ListEndHi]
	ld h, a
	ld a, [wBrowserRxBank]
	call BankSwitch_H
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
.l5227 ; 4C:5227
	ld a, [de]
	ld [hli], a
	inc de
	or a, a
	jr nz, .l5227
	ld a, l
	ld [wBrowserRxPtr], a
	ld a, h
	ld [wBrowserRxPtr + 1], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop hl
	ld de, $DD00
	farcall HtmlUrl_Resolve
	ld hl, wAttrUrlBuf
	farcall HtmlUrl_NormalizePath
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, wAttrUrlBuf
	ld a, [wBrowserRxPtr]
	ld e, a
	ld a, [wBrowserRxPtr + 1]
	ld d, a
	ld a, $FC
	sub a, e
	ld c, a
	ld a, $BF
	sbc a, d
	ld b, a
	ld a, [wBrowserRxBank]
	farcall HtmlStore_LoadPage
	jp .l51D1

MobileDictView_HistoryPush:: ; 4C:5274
Function_4C_5274::
	; [CONFIRMED] 22 insn(s); 22 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, $D500
	ld a, $06
	call BankSwitch_H
	ld a, [wDictHistoryHead]
	ld d, a
	ld e, $00
	srl d
	rr e
	ld a, d
	add a, $DA
	ld d, a
	ld bc, $0080
	call CopyBytes
	ld a, [wDictHistoryCount]
	cp a, $06
	jr nc, .l5298
	inc a
.l5298 ; 4C:5298
	ld [wDictHistoryCount], a
	ld a, [wDictHistoryHead]
	inc a
	cp a, $06
	jr c, .l52A4

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 4C:52A1 (executed) [executed in 3 scenarios]
	xor a, a

.l52A4 ; 4C:52A4
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 1/18 scenarios)
	ld [wDictHistoryHead], a
	ret

MobileDictView_HistoryPop:: ; 4C:52A8
	push de
	call BankSwitch_D
	xor a, a
	ld [de], a
	ld a, [wDictHistoryCount]
	or a, a
	jr z, .l52DC
	dec a
	ld [wDictHistoryCount], a
	ld a, [wDictHistoryHead]
	dec a
	cp a, $06
	jr c, .skip

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 4C:52BE (executed) [executed in 2 scenarios]
	ld a, $05

.skip ; 4C:52C2
	; [CONFIRMED] 16 insn(s); 16 executed (in up to 1/18 scenarios)
	ld [wDictHistoryHead], a
	ld h, a
	ld l, $00
	srl h
	rr l
	ld a, h
	add a, $DA
	ld h, a
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0080
	call CopyBytes
.l52DC ; 4C:52DC
	pop de
	ld a, [de]
	ret
