; engine/browser/page_view.asm
; bank 4E, $49A1-$5204 (2147 bytes); pinned by layout.link
; page view: enter, input loop, follow link, back, menu

SECTION "engine/browser/page_view", ROMX

Browser_PageView_Enter:: ; 4E:49A1
	; [CONFIRMED] 26 insn(s); 26 executed (in up to 1/18 scenarios)
	farcall Sprite_ResetAll
	farcall Browser_LoadFrameGraphics
	ld a, $00
	ldh [hBrowserSelectedLink], a
	ld bc, $0000
	ld de, $0000
	call Browser_SetScroll
	farcall Browser_RenderPage
	ld b, $14
	ld c, $01
	farcall Joypad_SetRepeatTiming
	farcall ConnIcon_Init
	farcall Sprite_UpdateAll
	farcall Palette_FadeInFromWhite
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jr z, .l49F5
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0014
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	jr .l4A05

.l49F5 ; 4E:49F5
	; [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1;
	; entered by jrcc from 4E:49E1 (executed) [executed in 1 scenarios]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $001C
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a

.l4A05 ; 4E:4A05
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ld a, [wBrowserPendingMessage]
	or a, a
	jr z, Browser_PageView_Enter_StartLoop

	; [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 0;
	; fall-through of the jrcc at 4E:4A09 (executed) [executed in 3 scenarios]
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	ld de, $18A0
	ld hl, $DA90
	call Sprite_SetPosition
	ld hl, $DAB0
	call Sprite_ClearSlot
	ld a, [wBrowserPendingMessage]
	ld d, $01
	ld e, a
	farcall Dialog_ShowMonitored
	farcall Browser_DrawScrollIndicators
	ldh a, [hDialogResult]
	call JumpTableInline

; ---- ptrtable $4A37-$4A43 (12 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4E:4A34: 6 entries; end pinned by the executed instruction at 4A43

Browser_PageView_Enter_DialogResultTable:: ; 4E:4A37
Table_4E_4A37::
	dw Browser_PageView_Enter_StartLoop
	dw Browser_PageView_Enter_StartLoop
	dw Browser_PageView_Enter_StartLoop
	dw Browser_Menu_LinkLost
	dw Browser_ConnectionNotice
	dw Browser_Menu_AdapterError

Browser_PageView_Enter_StartLoop:: ; 4E:4A43
Label_4E_4A43::
	; [CONFIRMED] 28 insn(s); 28 executed (in up to 1/18 scenarios)
	ld b, $14
	ld c, $01
	farcall Joypad_SetRepeatTiming
	xor a, a
	ld [wBrowserPendingMessage], a
	ldh [hDialogResult], a
	ld a, $01
	ld [wHtmlFlags], a

Browser_PageView_Loop:: ; 4E:4A58
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jr z, .l4AB8
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Browser_Menu_AdapterError
	bit 4, a
	jp z, Browser_Menu_LinkLost
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l4AB2
	ld hl, $C26F
	bit 0, [hl]
	jr nz, .l4AB3
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l4AB2

	; [CONFIRMED] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 0;
	; fall-through of the jrcc at 4E:4A83 (executed) | 7 insn(s) executed; cut out of the PROBABLE
	; region 4A85-4AB2 by apply_coverage --split [executed in 1 scenarios]
	jr nz, .l4A8E
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l4AB2
.l4A8E ; 4E:4A8E
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l4A9E

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4A85-4AB2 by apply_coverage --split
	ld hl, $C26F
	bit 1, [hl]
	jr nz, .l4AB2
	set 1, [hl]

.l4A9E ; 4E:4A9E
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 4A85-4AB2 by apply_coverage
	; --split [executed in 1 scenarios]
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, .l4AB3
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l4AB3

.l4AB2 ; 4E:4AB2
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 1/18 scenarios)
	xor a, a
.l4AB3 ; 4E:4AB3
	pop hl
	or a, a
	jp nz, Browser_ConnectionNotice
.l4AB8 ; 4E:4AB8
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	farcall Sprite_UpdateAll
	farcall Browser_DrawCommTimer
	farcall ConnIcon_LoadGraphicsIfRequested
	call VBlank_WaitAndService
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $4AE2-$4AEC (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 4E:4ADF: 5 entries; fixed length (5 words) by the routine; every byte read as data in a trace

Browser_PageView_InputTable:: ; 4E:4AE2
Table_4E_4AE2::
	dw Browser_PageView_FollowLink
	dw Browser_PageView_GoBack
	dw Browser_PageView_IgnoreSelect
	dw Browser_PageView_OpenMenu
	dw Browser_PageView_HandleDpad

Browser_PageView_HandleDpad:: ; 4E:4AEC
Label_4E_4AEC::
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)
	ldh a, [hJoyPressedRepeat]
	bit 6, a
	jr nz, .l4AF9
	bit 7, a
	jr nz, .l4B02
	jp Browser_PageView_Loop

.l4AF9 ; 4E:4AF9
	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by jrcc from 4E:4AF0 (executed) [executed in 1 scenarios]
	farcall Browser_SelectPrevLink
	jp Browser_PageView_Loop

.l4B02 ; 4E:4B02
	; [CONFIRMED] 51 insn(s); 51 executed (in up to 1/18 scenarios)
	farcall Browser_SelectNextLink
	jp Browser_PageView_Loop

Browser_PageView_IgnoreSelect:: ; 4E:4B0B
Label_4E_4B0B::
	jp Browser_PageView_Loop

Browser_PageView_FollowLink:: ; 4E:4B0E
	ldh a, [hBrowserSelectedLink]
	or a, a
	jp z, Browser_PageView_Loop
	cp a, $FF
	jp z, Browser_PageView_Loop
	farcall Browser_FindLinkElement
	or a, a
	jp z, Browser_PageView_Loop
	call Sound_FrameService
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
	ld hl, $C380
	farcall HtmlUrl_NormalizePath
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $003E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	ld a, $01
	ld [wBrowserNavigating], a
	farcall Browser_LoadPage
	ld a, [wBrowserFetchResult]
	call JumpTableInline

; ---- ptrtable $4B7E-$4B8C (14 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4E:4B7B: 7 entries; end = first entry target

Browser_PageView_FollowLink_ResultTable:: ; 4E:4B7E
Table_4E_4B7E::
	dw Browser_PageView_FollowLink_Loaded
	dw Browser_PageView_FollowLink_Restore
	dw Browser_PageView_FollowLink_Restore
	dw Browser_FetchResult3_ClearMessage
	dw Browser_FetchResult4_Disconnect
	dw Browser_FetchResult5_SetMessage
	dw Browser_FetchResult6_ConnectionNotice

Browser_PageView_FollowLink_Restore:: ; 4E:4B8C
Label_4E_4B8C::
	; [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1;
	; entered by table from 4E:4B7B (executed) [executed in 2 scenarios]
	ld de, $C380
	xor a, a
	farcall Browser_HistoryPop
	ld bc, $1000
	ld de, sBrowserPageBuf
	ld a, $03
	farcall PageCache_Pop
	farcall Html_ParsePage

Browser_PageView_FollowLink_Loaded:: ; 4E:4BAA
Label_4E_4BAA::
	; [CONFIRMED] 28 insn(s); 28 executed (in up to 1/18 scenarios)
	jp Browser_PageView_Enter

Browser_PageView_GoBack:: ; 4E:4BAD
	call Sound_FrameService
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D500
	ld de, $D400
	ld bc, $0100
	call CopyBytes
	ld de, $C380
	xor a, a
	farcall Browser_HistoryPop
	or a, a
	jp z, Browser_PageView_GoBack_NoHistory
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $003F
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld bc, $1000
	ld de, sBrowserPageBuf
	ld a, $03
	farcall PageCache_Pop
	or a, a
	jp nz, Browser_PageView_GoBack_FromCache

	; [PROBABLE] 28 insn(s) reached by static flow only; seeds: exec x28; min discovery hops 0;
	; fall-through of the jpcc at 4E:4BEF (executed)
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $C380
	ld de, $D500
	ld bc, $0100
	call CopyBytes
	ld hl, $D500
	ld a, $06
	farcall Browser_HistoryPushFrom
	ld hl, $D400
	ld a, $06
	farcall Browser_HistoryPushFrom
	farcall PageCache_Push
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D500
	ld de, $C380
	ld bc, $0100
	call CopyBytes
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	ld a, $00
	ld [wBrowserNavigating], a
	farcall Browser_LoadPage
	ld a, [wBrowserFetchResult]
	call JumpTableInline

; ---- ptrtable $4C49-$4C57 (14 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4E:4C46: 7 entries; end = first entry target

Browser_PageView_GoBack_ResultTable:: ; 4E:4C49
Table_4E_4C49::
	dw Browser_PageView_GoBack_Loaded
	dw Browser_PageView_GoBack_Restore
	dw Browser_PageView_GoBack_Restore
	dw Browser_FetchResult3_ClearMessage
	dw Browser_FetchResult4_Disconnect
	dw Browser_FetchResult5_SetMessage
	dw Browser_FetchResult6_ConnectionNotice

Browser_PageView_GoBack_Restore:: ; 4E:4C57
Label_4E_4C57::
	; [PROBABLE] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 1;
	; entered by table from 4E:4C46 (PROBABLE code)
	ld de, $C380
	xor a, a
	farcall Browser_HistoryPop
	ld bc, $1000
	ld de, sBrowserPageBuf
	ld a, $03
	farcall PageCache_Pop
	farcall Html_ParsePage
	jp Browser_PageView_Enter

Browser_PageView_GoBack_Loaded:: ; 4E:4C78
Label_4E_4C78::
	ld de, $C380
	xor a, a
	farcall Browser_HistoryPop
	farcall Browser_HistoryUndoPush
	jp Browser_PageView_Enter

Browser_PageView_GoBack_FromCache:: ; 4E:4C8B
Label_4E_4C8B::
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 1/18 scenarios)
	farcall Palette_FadeOutToWhite
	farcall Sprite_ResetAll
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0080
	ld de, $D800
	ld hl, $D880
	call CopyBytes
	farcall Html_ParsePage
	jp Browser_PageView_Enter

Browser_PageView_GoBack_NoHistory:: ; 4E:4CB2
Label_4E_4CB2::
	ld de, $18A0
	ld hl, $DA90
	call Sprite_SetPosition
	ld hl, $DAB0
	call Sprite_ClearSlot
	ld de, $0113
	farcall Dialog_ShowMonitored
	ld b, $14
	ld c, $01
	farcall Joypad_SetRepeatTiming
	farcall Browser_DrawScrollIndicators
	ldh a, [hDialogResult]
	call JumpTableInline

; ---- ptrtable $4CDF-$4CEB (12 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4E:4CDC: 6 entries; end pinned by the executed instruction at 4CEB

Browser_PageView_GoBack_DialogResultTable:: ; 4E:4CDF
Table_4E_4CDF::
	dw Browser_PageView_Loop
	dw Browser_PageView_Loop
	dw Browser_PageView_Loop
	dw Browser_Menu_LinkLost
	dw Browser_ConnectionNotice
	dw Browser_Menu_AdapterError

Browser_PageView_OpenMenu:: ; 4E:4CEB
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios)
	xor a, a
	ldh [hDialogResult], a

Browser_PageView_OpenMenu_Show:: ; 4E:4CEE
Label_4E_4CEE::
	ld de, $18A0
	ld hl, $DA90
	call Sprite_SetPosition
	ld hl, $DAB0
	call Sprite_ClearSlot
	ld a, [wCommSessionKind]
	cp a, $01
	jr nz, .l4D24

	; [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 4E:4D02 (executed) [executed in 1 scenarios]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0034
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ldh a, [hDialogResult]
	farcall BrowserMenu_OpenTwoItem
	farcall BrowserMenu_RunTwoItem
	jr .l4D42

.l4D24 ; 4E:4D24
	; [CONFIRMED] 26 insn(s); 26 executed (in up to 1/18 scenarios)
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0034
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ldh a, [hDialogResult]
	farcall BrowserMenu_OpenThreeItem
	farcall BrowserMenu_RunThreeItem
.l4D42 ; 4E:4D42
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0035
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	farcall BrowserMenu_Close
	ld b, $14
	ld c, $01
	farcall Joypad_SetRepeatTiming
	farcall Browser_DrawScrollIndicators
	ldh a, [hDialogResult]
	call JumpTableInline

; ---- ptrtable $4D6D-$4D7B (14 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4E:4D6A: 7 entries; end = first entry target

Browser_PageView_OpenMenu_DialogResultTable:: ; 4E:4D6D
Table_4E_4D6D::
	dw Browser_PageView_Loop
	dw Browser_Menu_PageList
	dw Browser_Menu_DisconnectPrompt
	dw Browser_Menu_EndPrompt
	dw Browser_Menu_LinkLost
	dw Browser_ConnectionNotice
	dw Browser_Menu_AdapterError

Browser_Menu_PageList:: ; 4E:4D7B
	; [CONFIRMED] 92 insn(s) reached by static flow only; seeds: exec x92; min discovery hops 1;
	; entered by table from 4E:4D6A (executed) | 39 insn(s) executed; cut out of the PROBABLE region
	; 4D7B-4E60 by apply_coverage --split [executed in 2 scenarios]
	farcall Palette_FadeOutToWhite
	farcall Sprite_ResetAll
	ld a, $04
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld de, $C380
	ld bc, $0014
	call CopyBytes
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $C380
	ld de, $D3C0
	ld bc, $0014
	call CopyBytes
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	farcall PageList_Main
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jr z, .l4E17
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Browser_Menu_AdapterError
	bit 4, a
	jp z, Browser_Menu_LinkLost
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l4E11
	ld hl, $C26F
	bit 0, [hl]
	jr nz, .l4E12
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l4E11

	; [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D7B-4E60 by apply_coverage --split
	jr nz, .l4DED
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l4E11
.l4DED ; 4E:4DED
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l4DFD
	ld hl, $C26F
	bit 1, [hl]
	jr nz, .l4E11
	set 1, [hl]
.l4DFD ; 4E:4DFD
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, .l4E12
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l4E12

.l4E11 ; 4E:4E11
	; [CONFIRMED] 32 insn(s) executed; cut out of the PROBABLE region 4D7B-4E60 by apply_coverage
	; --split [executed in 2 scenarios]
	xor a, a
.l4E12 ; 4E:4E12
	pop hl
	or a, a
	jp nz, Browser_ConnectionNotice
.l4E17 ; 4E:4E17
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	push de
	push hl
	farcall Palette_FadeOutToWhite
	farcall Sprite_ResetAll
	farcall SaveCheck_Update
	pop hl
	pop de
	ld a, e
	or a, d
	or a, l
	or a, h
	jr z, Browser_Menu_PageList_BackToMenu
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld de, $C380
	ld bc, $0100
	call CopyBytes
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ld [wBrowserNavigating], a
	farcall Browser_LoadPage
	ld a, [wBrowserFetchResult]
	call JumpTableInline

; ---- ptrtable $4E60-$4E6E (14 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4E:4E5D: 7 entries; end = first entry target

Browser_Menu_PageList_ResultTable:: ; 4E:4E60
Table_4E_4E60::
	dw Browser_Menu_PageList_Loaded
	dw Browser_Menu_PageList_Restore
	dw Browser_Menu_PageList_Restore
	dw Browser_FetchResult3_ClearMessage
	dw Browser_FetchResult4_Disconnect
	dw Browser_FetchResult5_SetMessage
	dw Browser_FetchResult6_ConnectionNotice

Browser_Menu_PageList_Restore:: ; 4E:4E6E
Label_4E_4E6E::
	; [PROBABLE] 54 insn(s) reached by static flow only; seeds: exec x54; min discovery hops 1;
	; entered by table from 4E:4E5D (PROBABLE code) | 8 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 4E6E-4F1A by apply_coverage --split
	ld de, $C380
	xor a, a
	farcall Browser_HistoryPop
	ld bc, $1000
	ld de, sBrowserPageBuf
	ld a, $03
	farcall PageCache_Pop
	farcall Html_ParsePage

Browser_Menu_PageList_Loaded:: ; 4E:4E8C
Label_4E_4E8C::
	; [CONFIRMED] 22 insn(s) executed; cut out of the PROBABLE region 4E6E-4F1A by apply_coverage
	; --split [executed in 1 scenarios]
	jp Browser_PageView_Enter

Browser_Menu_PageList_BackToMenu:: ; 4E:4E8F
Label_4E_4E8F::
	farcall Sprite_ResetAll
	farcall Browser_LoadFrameGraphics
	farcall Browser_RenderPage
	farcall ConnIcon_Init
	farcall Sprite_UpdateAll
	farcall Palette_FadeInFromWhite
	ld b, $14
	ld c, $01
	farcall Joypad_SetRepeatTiming
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jr z, .l4ED6
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0014
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	jr .l4EE6

.l4ED6 ; 4E:4ED6
	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4E6E-4F1A by apply_coverage --split
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $001C
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a

.l4EE6 ; 4E:4EE6
	; [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 4E6E-4F1A by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $00
	ldh [hDialogResult], a
	jp Browser_PageView_OpenMenu_Show

Browser_Menu_DisconnectPrompt:: ; 4E:4EED
	ld de, $18A0
	ld hl, $DA90
	call Sprite_SetPosition
	ld hl, $DAB0
	call Sprite_ClearSlot
	ld de, $0101
	farcall Dialog_ShowMonitored
	ld b, $14
	ld c, $01
	farcall Joypad_SetRepeatTiming
	farcall Browser_DrawScrollIndicators
	ldh a, [hDialogResult]
	call JumpTableInline

; ---- ptrtable $4F1A-$4F26 (12 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4E:4F17: 6 entries; end = first entry target

Browser_Menu_DisconnectPrompt_DialogResultTable:: ; 4E:4F1A
Table_4E_4F1A::
	dw Browser_Menu_DisconnectPrompt_BackToMenu
	dw Browser_Menu_DisconnectDo
	dw Browser_Menu_DisconnectPrompt_BackToMenu
	dw Browser_Menu_LinkLost
	dw Browser_ConnectionNotice
	dw Browser_Menu_AdapterError

Browser_Menu_DisconnectPrompt_BackToMenu:: ; 4E:4F26
Label_4E_4F26::
	; [CONFIRMED] 44 insn(s) reached by static flow only; seeds: exec x44; min discovery hops 1;
	; entered by table from 4E:4F17 (PROBABLE code) | 5 insn(s) executed; cut out of the PROBABLE
	; region 4F26-4FB7 by apply_coverage --split [executed in 1 scenarios]
	ld a, $01
	ldh [hDialogResult], a
	ld a, [wCommSessionKind]
	cp a, $01
	jp nz, Browser_PageView_OpenMenu_Show

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4F26-4FB7 by apply_coverage --split
	ld a, $00
	ldh [hDialogResult], a
	jp Browser_PageView_OpenMenu_Show

Browser_Menu_DisconnectDo:: ; 4E:4F39
	; [CONFIRMED] 28 insn(s) executed; cut out of the PROBABLE region 4F26-4FB7 by apply_coverage
	; --split [executed in 1 scenarios]
	xor a, a
	ld [wBrowserFetchResult], a
	ld de, $18A0
	ld hl, $DA90
	call Sprite_SetPosition
	ld hl, $DAB0
	call Sprite_ClearSlot
	ld de, $010F
	farcall Dialog_Open
	farcall Comm_Disconnect
	farcall Palette_FadeOutToWhite
	farcall Sprite_ResetAll
	farcall Dialog_Close
	farcall CommTime_ShowSummary
	ld a, $0B
	ld [wBrowserPendingMessage], a
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	jp Browser_PageView_Enter

Browser_Menu_EndPrompt:: ; 4E:4F81
	ld de, $18A0
	ld hl, $DA90
	call Sprite_SetPosition
	ld hl, $DAB0
	call Sprite_ClearSlot
	ld de, $0105
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, .skip

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4F26-4FB7 by apply_coverage --split
	ld e, $14

.skip ; 4E:4F9C
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4F26-4FB7 by apply_coverage
	; --split [executed in 1 scenarios]
	farcall Dialog_ShowMonitored
	ld b, $14
	ld c, $01
	farcall Joypad_SetRepeatTiming
	farcall Browser_DrawScrollIndicators
	ldh a, [hDialogResult]
	call JumpTableInline

; ---- ptrtable $4FB7-$4FC3 (12 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4E:4FB4: 6 entries; end = first entry target

Browser_Menu_EndPrompt_DialogResultTable:: ; 4E:4FB7
Table_4E_4FB7::
	dw Browser_Menu_EndPrompt_BackToMenu
	dw Browser_Menu_EndDo
	dw Browser_Menu_EndPrompt_BackToMenu
	dw Browser_Menu_LinkLost
	dw Browser_ConnectionNotice
	dw Browser_Menu_AdapterError

Browser_Menu_EndPrompt_BackToMenu:: ; 4E:4FC3
Label_4E_4FC3::
	; [PROBABLE] 17 insn(s) reached by static flow only; seeds: exec x17; min discovery hops 2;
	; entered by table from 4E:4FB4 (PROBABLE code) | 8 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 4FC3-4FF6 by apply_coverage --split
	ld a, $02
	ldh [hDialogResult], a
	ld a, [wCommSessionKind]
	cp a, $01
	jp nz, Browser_PageView_OpenMenu_Show
	ld a, $01
	ldh [hDialogResult], a
	jp Browser_PageView_OpenMenu_Show

Browser_Menu_EndDo:: ; 4E:4FD6
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4FC3-4FF6 by apply_coverage
	; --split [executed in 1 scenarios]
	xor a, a
	ld [wBrowserFetchResult], a
	farcall Palette_FadeOutToWhite
	farcall Sprite_ResetAll
	ld a, [wTimerEnable]
	bit 4, a
	jp nz, Browser_Leave_Disconnect

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4FC3-4FF6 by apply_coverage --split
	farcall Comm_EndOffline
	jr Browser_Leave_Summary

Browser_Leave_Disconnect:: ; 4E:4FF6
Label_4E_4FF6::
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios)
	farcall Comm_DisconnectWithProgress

Browser_Leave_Summary:: ; 4E:4FFC
	ld a, [wCommSessionKind]
	cp a, $01
	jr z, Browser_Leave_Return

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 4E:5001 (executed) [executed in 3 scenarios]
	farcall CommTime_ShowSummary

Browser_Leave_Return:: ; 4E:5009
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 3/18 scenarios)
	farcall Sprite_ResetAll
	xor a, a
	ld [wBrowserNavigating], a
	ldh [hRam_FFA7], a
	ldh a, [hDialogResult]
	ret

Browser_Leave_OnError:: ; 4E:5018
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, Browser_Leave_Disconnect

	; [PROBABLE] 157 insn(s) reached by static flow only; seeds: exec x157; min discovery hops 0;
	; fall-through of the jrcc at 4E:501D (executed) | 11 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 501F-5204 by apply_coverage --split
	ld a, [wTimerEnable]
	bit 1, a
	jp z, .l502D
	farcall Mobile_FetchResult
.l502D ; 4E:502D
	ld a, $36
	farcall MobileAPI
	ld a, $09
	ld [wTimerAWarnMinute], a
	xor a, a
	ld [wTimerAWarnFlags], a
	jr Browser_Leave_Summary

Browser_FetchResult4_Disconnect:: ; 4E:5040
Label_4E_5040::
	; [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 501F-5204 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, .l5068
	ld a, [wTimerEnable]
	bit 1, a
	jp z, .l5055

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 501F-5204 by apply_coverage --split
	farcall Mobile_FetchResult

.l5055 ; 4E:5055
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 501F-5204 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $36
	farcall MobileAPI
	ld a, $09
	ld [wTimerAWarnMinute], a
	xor a, a
	ld [wTimerAWarnFlags], a
	jr .l506E

.l5068 ; 4E:5068
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 501F-5204 by apply_coverage --split
	farcall Comm_DisconnectWithProgress

.l506E ; 4E:506E
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 501F-5204 by apply_coverage
	; --split [executed in 1 scenarios]
	farcall CommTime_ShowSummary
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jr z, Browser_FetchResult3_ClearMessage
	ld a, $10
	ld [wBrowserPendingMessage], a
	jr Browser_FetchResult_RestorePage

Browser_FetchResult3_ClearMessage:: ; 4E:5082
Label_4E_5082::
	xor a, a
	ld [wBrowserPendingMessage], a
	jr Browser_FetchResult_RestorePage

Browser_FetchResult5_SetMessage:: ; 4E:5088
Label_4E_5088::
	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 501F-5204 by apply_coverage --split
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l5096
	ld a, $11
	ld [wBrowserPendingMessage], a
	jr Browser_FetchResult_RestorePage
.l5096 ; 4E:5096
	ld a, $10
	ld [wBrowserPendingMessage], a
	jr Browser_FetchResult_RestorePage

Browser_FetchResult_RestorePage:: ; 4E:509D
Label_4E_509D::
	; [CONFIRMED] 33 insn(s) executed; cut out of the PROBABLE region 501F-5204 by apply_coverage
	; --split [executed in 1 scenarios]
	ld de, $C380
	xor a, a
	farcall Browser_HistoryPop
	ld bc, $1000
	ld de, sBrowserPageBuf
	ld a, $03
	farcall PageCache_Pop
	farcall Html_ParsePage
	jp Browser_PageView_Enter

Browser_ConnectionNotice:: ; 4E:50BE
	farcall Palette_FadeOutToWhite
	farcall Sprite_ResetAll
	ld a, [wCommSessionKind]
	xor a, $01
	ld [wCommNoticeMode], a
	ld a, [wCommSessionKind]
	ld [wCommNoticeGfxSet], a
	ld hl, $C26F
	res 0, [hl]
	farcall CommNotice_ShowDialog
	or a, a
	jr z, .l50EC
	farcall CommTime_ShowSummary
.l50EC ; 4E:50EC
	xor a, a
	ld [wBrowserPendingMessage], a
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	bit 4, a
	jp nz, .l5104
	ld a, $09
	ld [wTimerAWarnMinute], a
	xor a, a
	ld [wTimerAWarnFlags], a
.l5104 ; 4E:5104
	jp Browser_PageView_Enter

Browser_FetchResult6_ConnectionNotice:: ; 4E:5107
Label_4E_5107::
	; [PROBABLE] 79 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 501F-5204 by apply_coverage --split
	xor a, a
	ld [wBrowserPendingMessage], a
	ld a, [wCommSessionKind]
	xor a, $01
	ld [wCommNoticeMode], a
	ld a, [wCommSessionKind]
	ld [wCommNoticeGfxSet], a
	ld hl, $C26F
	res 0, [hl]
	farcall CommNotice_ShowDialog
	or a, a
	jr z, .l512D
	farcall CommTime_ShowSummary
.l512D ; 4E:512D
	ld de, $C380
	xor a, a
	farcall Browser_HistoryPop
	ld bc, $1000
	ld de, sBrowserPageBuf
	ld a, $03
	farcall PageCache_Pop
	farcall Html_ParsePage
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	bit 4, a
	jp nz, .l515F
	ld a, $09
	ld [wTimerAWarnMinute], a
	xor a, a
	ld [wTimerAWarnFlags], a
.l515F ; 4E:515F
	jp Browser_PageView_Enter

Browser_Menu_LinkLost:: ; 4E:5162
	ld a, $09
	ld [wTimerAWarnMinute], a
	xor a, a
	ld [wTimerAWarnFlags], a
	xor a, a
	ld [wBrowserFetchResult], a
	ld de, $18A0
	ld hl, $DA90
	call Sprite_SetPosition
	ld hl, $DAB0
	call Sprite_ClearSlot
	ld de, $0110
	farcall Dialog_ShowMonitored
	farcall Palette_FadeOutToWhite
	farcall Sprite_ResetAll
	farcall CommTime_ShowSummary
	xor a, a
	ld [wBrowserPendingMessage], a
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	jp Browser_PageView_Enter

Browser_Menu_AdapterError:: ; 4E:51A6
	farcall Mobile_FetchResult
	ld a, [wMobileResultDetail]
	ld [wMobileErrorDetail], a
	ld a, [wMobileResultDetail + 1]
	ld [wMobileErrorDetailHi], a
	ld a, [wMobileResultCode]
	ld [wMobileErrorCode], a
	xor a, a
	ld [wBrowserFetchResult], a
	ld a, [wCommSessionKind]
	xor a, $01
	ld [wCommNoticeMode], a
	ld a, [wCommSessionKind]
	ld [wCommNoticeGfxSet], a
	farcall Palette_FadeOutToWhite
	farcall Sprite_ResetAll
	farcall Sram_CountMobileError12Or26
	farcall Mobile_ShowLastError
	ld a, $09
	ld [wTimerAWarnMinute], a
	xor a, a
	ld [wTimerAWarnFlags], a
	farcall CommTime_ShowSummary
	xor a, a
	ld [wBrowserPendingMessage], a
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	jp Browser_PageView_Enter
