; engine/browser/page_view.asm
; bank 4E, $49A1-$5204 (2147 bytes); pinned by layout.link
; page view: enter, input loop, follow link, back, menu

SECTION "engine/browser/page_view", ROMX

; ---- code $49A1-$49F5 (84 bytes) [CONFIRMED] 26 insn(s); 26 executed (in up to 1/18 scenarios)

Browser_PageView_Enter:: ; 4E:49A1
	farcall Function_00_09B6
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
	farcall Function_00_0956
	farcall Palette_FadeInFromWhite
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jr z, Label_4E_49F5
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0014
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	jr Label_4E_4A05

; ---- code $49F5-$4A05 (16 bytes) [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1; entered by jrcc from 4E:49E1 (executed) [executed in 1 scenarios]

Label_4E_49F5:: ; 4E:49F5
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $001C
	call Function_00_20E8
	pop af
	ldh [rSVBK], a

; ---- code $4A05-$4A0B (6 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)

Label_4E_4A05:: ; 4E:4A05
	ld a, [wRam_C1DC]
	or a, a
	jr z, Label_4E_4A43

; ---- code $4A0B-$4A37 (44 bytes) [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 0; fall-through of the jrcc at 4E:4A09 (executed) [executed in 3 scenarios]
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	ld de, $18A0
	ld hl, $DA90
	call Function_00_0A65
	ld hl, $DAB0
	call Function_00_09E6
	ld a, [wRam_C1DC]
	ld d, $01
	ld e, a
	farcall Dialog_ShowMonitored
	farcall Browser_DrawScrollIndicators
	ldh a, [hDialogResult]
	call JumpTableInline

; ---- ptrtable $4A37-$4A43 (12 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4E:4A34: 6 entries; end pinned by the executed instruction at 4A43

Table_4E_4A37:: ; 4E:4A37
	dw Label_4E_4A43
	dw Label_4E_4A43
	dw Label_4E_4A43
	dw Browser_Menu_LinkLost
	dw Browser_ConnectionNotice
	dw Browser_Menu_AdapterError

; ---- code $4A43-$4A85 (66 bytes) [CONFIRMED] 28 insn(s); 28 executed (in up to 1/18 scenarios)

Label_4E_4A43:: ; 4E:4A43
	ld b, $14
	ld c, $01
	farcall Joypad_SetRepeatTiming
	xor a, a
	ld [wRam_C1DC], a
	ldh [hDialogResult], a
	ld a, $01
	ld [wHtmlFlags], a

Browser_PageView_Loop:: ; 4E:4A58
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jr z, Label_4E_4AB8
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Browser_Menu_AdapterError
	bit 4, a
	jp z, Browser_Menu_LinkLost
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_4E_4AB2
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_4E_4AB3
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_4E_4AB2

; ---- code $4A85-$4A95 (16 bytes) [CONFIRMED] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 0; fall-through of the jrcc at 4E:4A83 (executed) | 7 insn(s) executed; cut out of the PROBABLE region 4A85-4AB2 by apply_coverage --split [executed in 1 scenarios]
	jr nz, Label_4E_4A8E
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_4E_4AB2

Label_4E_4A8E:: ; 4E:4A8E
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_4E_4A9E

; ---- code $4A95-$4A9E (9 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4A85-4AB2 by apply_coverage --split
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_4E_4AB2
	set 1, [hl]

; ---- code $4A9E-$4AB2 (20 bytes) [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 4A85-4AB2 by apply_coverage --split [executed in 1 scenarios]

Label_4E_4A9E:: ; 4E:4A9E
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_4E_4AB3
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_4E_4AB3

; ---- code $4AB2-$4AE2 (48 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 1/18 scenarios)

Label_4E_4AB2:: ; 4E:4AB2
	xor a, a

Label_4E_4AB3:: ; 4E:4AB3
	pop hl
	or a, a
	jp nz, Browser_ConnectionNotice

Label_4E_4AB8:: ; 4E:4AB8
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	farcall Function_00_0956
	farcall Browser_DrawCommTimer
	farcall ConnIcon_LoadGraphicsIfRequested
	call Function_00_044B
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $4AE2-$4AEC (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 4E:4ADF: 5 entries; fixed length (5 words) by the routine; every byte read as data in a trace

Table_4E_4AE2:: ; 4E:4AE2
	dw Browser_PageView_FollowLink
	dw Browser_PageView_GoBack
	dw Label_4E_4B0B
	dw Browser_PageView_OpenMenu
	dw Label_4E_4AEC

; ---- code $4AEC-$4AF9 (13 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)

Label_4E_4AEC:: ; 4E:4AEC
	ldh a, [hJoyPressedRepeat]
	bit 6, a
	jr nz, Label_4E_4AF9
	bit 7, a
	jr nz, Label_4E_4B02
	jp Browser_PageView_Loop

; ---- code $4AF9-$4B02 (9 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1; entered by jrcc from 4E:4AF0 (executed) [executed in 1 scenarios]

Label_4E_4AF9:: ; 4E:4AF9
	farcall Browser_SelectPrevLink
	jp Browser_PageView_Loop

; ---- code $4B02-$4B7E (124 bytes) [CONFIRMED] 51 insn(s); 51 executed (in up to 1/18 scenarios)

Label_4E_4B02:: ; 4E:4B02
	farcall Browser_SelectNextLink
	jp Browser_PageView_Loop

Label_4E_4B0B:: ; 4E:4B0B
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
	call Function_00_0392
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
	call Function_00_20AC
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

Table_4E_4B7E:: ; 4E:4B7E
	dw Label_4E_4BAA
	dw Label_4E_4B8C
	dw Label_4E_4B8C
	dw Label_4E_5082
	dw Label_4E_5040
	dw Label_4E_5088
	dw Label_4E_5107

; ---- code $4B8C-$4BAA (30 bytes) [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1; entered by table from 4E:4B7B (executed) [executed in 2 scenarios]

Label_4E_4B8C:: ; 4E:4B8C
	ld de, $C380
	xor a, a
	farcall Browser_HistoryPop
	ld bc, $1000
	ld de, $B000
	ld a, $03
	farcall PageCache_Pop
	farcall Html_ParsePage

; ---- code $4BAA-$4BF2 (72 bytes) [CONFIRMED] 28 insn(s); 28 executed (in up to 1/18 scenarios)

Label_4E_4BAA:: ; 4E:4BAA
	jp Browser_PageView_Enter

Browser_PageView_GoBack:: ; 4E:4BAD
	call Function_00_0392
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
	jp z, Label_4E_4CB2
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $003F
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld bc, $1000
	ld de, $B000
	ld a, $03
	farcall PageCache_Pop
	or a, a
	jp nz, Label_4E_4C8B

; ---- code $4BF2-$4C49 (87 bytes) [PROBABLE] 28 insn(s) reached by static flow only; seeds: exec x28; min discovery hops 0; fall-through of the jpcc at 4E:4BEF (executed)
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $C380
	ld de, $D500
	ld bc, $0100
	call CopyBytes
	ld hl, $D500
	ld a, $06
	farcall Function_4C_4B81
	ld hl, $D400
	ld a, $06
	farcall Function_4C_4B81
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

Table_4E_4C49:: ; 4E:4C49
	dw Label_4E_4C78
	dw Label_4E_4C57
	dw Label_4E_4C57
	dw Label_4E_5082
	dw Label_4E_5040
	dw Label_4E_5088
	dw Label_4E_5107

; ---- code $4C57-$4C8B (52 bytes) [PROBABLE] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 1; entered by table from 4E:4C46 (PROBABLE code)

Label_4E_4C57:: ; 4E:4C57
	ld de, $C380
	xor a, a
	farcall Browser_HistoryPop
	ld bc, $1000
	ld de, $B000
	ld a, $03
	farcall PageCache_Pop
	farcall Html_ParsePage
	jp Browser_PageView_Enter

Label_4E_4C78:: ; 4E:4C78
	ld de, $C380
	xor a, a
	farcall Browser_HistoryPop
	farcall Function_4C_4D6F
	jp Browser_PageView_Enter

; ---- code $4C8B-$4CDF (84 bytes) [CONFIRMED] 24 insn(s); 24 executed (in up to 1/18 scenarios)

Label_4E_4C8B:: ; 4E:4C8B
	farcall Palette_FadeOutToWhite
	farcall Function_00_09B6
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0080
	ld de, $D800
	ld hl, $D880
	call CopyBytes
	farcall Html_ParsePage
	jp Browser_PageView_Enter

Label_4E_4CB2:: ; 4E:4CB2
	ld de, $18A0
	ld hl, $DA90
	call Function_00_0A65
	ld hl, $DAB0
	call Function_00_09E6
	ld de, $0113
	farcall Dialog_ShowMonitored
	ld b, $14
	ld c, $01
	farcall Joypad_SetRepeatTiming
	farcall Browser_DrawScrollIndicators
	ldh a, [hDialogResult]
	call JumpTableInline

; ---- ptrtable $4CDF-$4CEB (12 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4E:4CDC: 6 entries; end pinned by the executed instruction at 4CEB

Table_4E_4CDF:: ; 4E:4CDF
	dw Browser_PageView_Loop
	dw Browser_PageView_Loop
	dw Browser_PageView_Loop
	dw Browser_Menu_LinkLost
	dw Browser_ConnectionNotice
	dw Browser_Menu_AdapterError

; ---- code $4CEB-$4D04 (25 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios)

Browser_PageView_OpenMenu:: ; 4E:4CEB
	xor a, a
	ldh [hDialogResult], a

Label_4E_4CEE:: ; 4E:4CEE
	ld de, $18A0
	ld hl, $DA90
	call Function_00_0A65
	ld hl, $DAB0
	call Function_00_09E6
	ld a, [wCommSessionKind]
	cp a, $01
	jr nz, Label_4E_4D24

; ---- code $4D04-$4D24 (32 bytes) [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 4E:4D02 (executed) [executed in 1 scenarios]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0034
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ldh a, [hDialogResult]
	farcall BrowserMenu_OpenTwoItem
	farcall BrowserMenu_RunTwoItem
	jr Label_4E_4D42

; ---- code $4D24-$4D6D (73 bytes) [CONFIRMED] 26 insn(s); 26 executed (in up to 1/18 scenarios)

Label_4E_4D24:: ; 4E:4D24
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0034
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ldh a, [hDialogResult]
	farcall BrowserMenu_OpenThreeItem
	farcall BrowserMenu_RunThreeItem

Label_4E_4D42:: ; 4E:4D42
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0035
	call Function_00_20AC
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

Table_4E_4D6D:: ; 4E:4D6D
	dw Browser_PageView_Loop
	dw Browser_Menu_PageList
	dw Browser_Menu_DisconnectPrompt
	dw Browser_Menu_EndPrompt
	dw Browser_Menu_LinkLost
	dw Browser_ConnectionNotice
	dw Browser_Menu_AdapterError

; ---- code $4D7B-$4DE4 (105 bytes) [CONFIRMED] 92 insn(s) reached by static flow only; seeds: exec x92; min discovery hops 1; entered by table from 4E:4D6A (executed) | 39 insn(s) executed; cut out of the PROBABLE region 4D7B-4E60 by apply_coverage --split [executed in 2 scenarios]

Browser_Menu_PageList:: ; 4E:4D7B
	farcall Palette_FadeOutToWhite
	farcall Function_00_09B6
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
	jr z, Label_4E_4E17
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Browser_Menu_AdapterError
	bit 4, a
	jp z, Browser_Menu_LinkLost
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_4E_4E11
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_4E_4E12
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_4E_4E11

; ---- code $4DE4-$4E11 (45 bytes) [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4D7B-4E60 by apply_coverage --split
	jr nz, Label_4E_4DED
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_4E_4E11

Label_4E_4DED:: ; 4E:4DED
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_4E_4DFD
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_4E_4E11
	set 1, [hl]

Label_4E_4DFD:: ; 4E:4DFD
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_4E_4E12
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_4E_4E12

; ---- code $4E11-$4E60 (79 bytes) [CONFIRMED] 32 insn(s) executed; cut out of the PROBABLE region 4D7B-4E60 by apply_coverage --split [executed in 2 scenarios]

Label_4E_4E11:: ; 4E:4E11
	xor a, a

Label_4E_4E12:: ; 4E:4E12
	pop hl
	or a, a
	jp nz, Browser_ConnectionNotice

Label_4E_4E17:: ; 4E:4E17
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	push de
	push hl
	farcall Palette_FadeOutToWhite
	farcall Function_00_09B6
	farcall SaveCheck_Update
	pop hl
	pop de
	ld a, e
	or a, d
	or a, l
	or a, h
	jr z, Label_4E_4E8F
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

Table_4E_4E60:: ; 4E:4E60
	dw Label_4E_4E8C
	dw Label_4E_4E6E
	dw Label_4E_4E6E
	dw Label_4E_5082
	dw Label_4E_5040
	dw Label_4E_5088
	dw Label_4E_5107

; ---- code $4E6E-$4E8C (30 bytes) [PROBABLE] 54 insn(s) reached by static flow only; seeds: exec x54; min discovery hops 1; entered by table from 4E:4E5D (PROBABLE code) | 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4E6E-4F1A by apply_coverage --split

Label_4E_4E6E:: ; 4E:4E6E
	ld de, $C380
	xor a, a
	farcall Browser_HistoryPop
	ld bc, $1000
	ld de, $B000
	ld a, $03
	farcall PageCache_Pop
	farcall Html_ParsePage

; ---- code $4E8C-$4ED6 (74 bytes) [CONFIRMED] 22 insn(s) executed; cut out of the PROBABLE region 4E6E-4F1A by apply_coverage --split [executed in 1 scenarios]

Label_4E_4E8C:: ; 4E:4E8C
	jp Browser_PageView_Enter

Label_4E_4E8F:: ; 4E:4E8F
	farcall Function_00_09B6
	farcall Browser_LoadFrameGraphics
	farcall Browser_RenderPage
	farcall ConnIcon_Init
	farcall Function_00_0956
	farcall Palette_FadeInFromWhite
	ld b, $14
	ld c, $01
	farcall Joypad_SetRepeatTiming
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jr z, Label_4E_4ED6
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0014
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	jr Label_4E_4EE6

; ---- code $4ED6-$4EE6 (16 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4E6E-4F1A by apply_coverage --split

Label_4E_4ED6:: ; 4E:4ED6
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $001C
	call Function_00_20E8
	pop af
	ldh [rSVBK], a

; ---- code $4EE6-$4F1A (52 bytes) [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 4E6E-4F1A by apply_coverage --split [executed in 1 scenarios]

Label_4E_4EE6:: ; 4E:4EE6
	ld a, $00
	ldh [hDialogResult], a
	jp Label_4E_4CEE

Browser_Menu_DisconnectPrompt:: ; 4E:4EED
	ld de, $18A0
	ld hl, $DA90
	call Function_00_0A65
	ld hl, $DAB0
	call Function_00_09E6
	ld de, $0101
	farcall Dialog_ShowMonitored
	ld b, $14
	ld c, $01
	farcall Joypad_SetRepeatTiming
	farcall Browser_DrawScrollIndicators
	ldh a, [hDialogResult]
	call JumpTableInline

; ---- ptrtable $4F1A-$4F26 (12 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4E:4F17: 6 entries; end = first entry target

Table_4E_4F1A:: ; 4E:4F1A
	dw Label_4E_4F26
	dw Browser_Menu_DisconnectDo
	dw Label_4E_4F26
	dw Browser_Menu_LinkLost
	dw Browser_ConnectionNotice
	dw Browser_Menu_AdapterError

; ---- code $4F26-$4F32 (12 bytes) [CONFIRMED] 44 insn(s) reached by static flow only; seeds: exec x44; min discovery hops 1; entered by table from 4E:4F17 (PROBABLE code) | 5 insn(s) executed; cut out of the PROBABLE region 4F26-4FB7 by apply_coverage --split [executed in 1 scenarios]

Label_4E_4F26:: ; 4E:4F26
	ld a, $01
	ldh [hDialogResult], a
	ld a, [wCommSessionKind]
	cp a, $01
	jp nz, Label_4E_4CEE

; ---- code $4F32-$4F39 (7 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4F26-4FB7 by apply_coverage --split
	ld a, $00
	ldh [hDialogResult], a
	jp Label_4E_4CEE

; ---- code $4F39-$4F9A (97 bytes) [CONFIRMED] 28 insn(s) executed; cut out of the PROBABLE region 4F26-4FB7 by apply_coverage --split [executed in 1 scenarios]

Browser_Menu_DisconnectDo:: ; 4E:4F39
	xor a, a
	ld [wBrowserFetchResult], a
	ld de, $18A0
	ld hl, $DA90
	call Function_00_0A65
	ld hl, $DAB0
	call Function_00_09E6
	ld de, $010F
	farcall Dialog_Open
	farcall Comm_Disconnect
	farcall Palette_FadeOutToWhite
	farcall Function_00_09B6
	farcall Dialog_Close
	farcall CommTime_ShowSummary
	ld a, $0B
	ld [wRam_C1DC], a
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	jp Browser_PageView_Enter

Browser_Menu_EndPrompt:: ; 4E:4F81
	ld de, $18A0
	ld hl, $DA90
	call Function_00_0A65
	ld hl, $DAB0
	call Function_00_09E6
	ld de, $0105
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, Label_4E_4F9C

; ---- code $4F9A-$4F9C (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4F26-4FB7 by apply_coverage --split
	ld e, $14

; ---- code $4F9C-$4FB7 (27 bytes) [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4F26-4FB7 by apply_coverage --split [executed in 1 scenarios]

Label_4E_4F9C:: ; 4E:4F9C
	farcall Dialog_ShowMonitored
	ld b, $14
	ld c, $01
	farcall Joypad_SetRepeatTiming
	farcall Browser_DrawScrollIndicators
	ldh a, [hDialogResult]
	call JumpTableInline

; ---- ptrtable $4FB7-$4FC3 (12 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4E:4FB4: 6 entries; end = first entry target

Table_4E_4FB7:: ; 4E:4FB7
	dw Label_4E_4FC3
	dw Browser_Menu_EndDo
	dw Label_4E_4FC3
	dw Browser_Menu_LinkLost
	dw Browser_ConnectionNotice
	dw Browser_Menu_AdapterError

; ---- code $4FC3-$4FD6 (19 bytes) [PROBABLE] 17 insn(s) reached by static flow only; seeds: exec x17; min discovery hops 2; entered by table from 4E:4FB4 (PROBABLE code) | 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4FC3-4FF6 by apply_coverage --split

Label_4E_4FC3:: ; 4E:4FC3
	ld a, $02
	ldh [hDialogResult], a
	ld a, [wCommSessionKind]
	cp a, $01
	jp nz, Label_4E_4CEE
	ld a, $01
	ldh [hDialogResult], a
	jp Label_4E_4CEE

; ---- code $4FD6-$4FEE (24 bytes) [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4FC3-4FF6 by apply_coverage --split [executed in 1 scenarios]

Browser_Menu_EndDo:: ; 4E:4FD6
	xor a, a
	ld [wBrowserFetchResult], a
	farcall Palette_FadeOutToWhite
	farcall Function_00_09B6
	ld a, [wTimerEnable]
	bit 4, a
	jp nz, Label_4E_4FF6

; ---- code $4FEE-$4FF6 (8 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4FC3-4FF6 by apply_coverage --split
	farcall Comm_EndOffline
	jr Browser_Leave_Summary

; ---- code $4FF6-$5003 (13 bytes) [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios)

Label_4E_4FF6:: ; 4E:4FF6
	farcall Comm_DisconnectWithProgress

Browser_Leave_Summary:: ; 4E:4FFC
	ld a, [wCommSessionKind]
	cp a, $01
	jr z, Browser_Leave_Return

; ---- code $5003-$5009 (6 bytes) [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 4E:5001 (executed) [executed in 3 scenarios]
	farcall CommTime_ShowSummary

; ---- code $5009-$501F (22 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 3/18 scenarios)

Browser_Leave_Return:: ; 4E:5009
	farcall Function_00_09B6
	xor a, a
	ld [wBrowserNavigating], a
	ldh [hRam_FFA7], a
	ldh a, [hDialogResult]
	ret

Browser_Leave_OnError:: ; 4E:5018
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, Label_4E_4FF6

; ---- code $501F-$5040 (33 bytes) [PROBABLE] 157 insn(s) reached by static flow only; seeds: exec x157; min discovery hops 0; fall-through of the jrcc at 4E:501D (executed) | 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region 501F-5204 by apply_coverage --split
	ld a, [wTimerEnable]
	bit 1, a
	jp z, Label_4E_502D
	farcall Mobile_FetchResult

Label_4E_502D:: ; 4E:502D
	ld a, $36
	farcall MobileAPI
	ld a, $09
	ld [wRam_C26E], a
	xor a, a
	ld [wRam_C26F], a
	jr Browser_Leave_Summary

; ---- code $5040-$504F (15 bytes) [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 501F-5204 by apply_coverage --split [executed in 1 scenarios]

Label_4E_5040:: ; 4E:5040
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, Label_4E_5068
	ld a, [wTimerEnable]
	bit 1, a
	jp z, Label_4E_5055

; ---- code $504F-$5055 (6 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 501F-5204 by apply_coverage --split
	farcall Mobile_FetchResult

; ---- code $5055-$5068 (19 bytes) [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 501F-5204 by apply_coverage --split [executed in 1 scenarios]

Label_4E_5055:: ; 4E:5055
	ld a, $36
	farcall MobileAPI
	ld a, $09
	ld [wRam_C26E], a
	xor a, a
	ld [wRam_C26F], a
	jr Label_4E_506E

; ---- code $5068-$506E (6 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 501F-5204 by apply_coverage --split

Label_4E_5068:: ; 4E:5068
	farcall Comm_DisconnectWithProgress

; ---- code $506E-$5088 (26 bytes) [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 501F-5204 by apply_coverage --split [executed in 1 scenarios]

Label_4E_506E:: ; 4E:506E
	farcall CommTime_ShowSummary
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jr z, Label_4E_5082
	ld a, $10
	ld [wRam_C1DC], a
	jr Label_4E_509D

Label_4E_5082:: ; 4E:5082
	xor a, a
	ld [wRam_C1DC], a
	jr Label_4E_509D

; ---- code $5088-$509D (21 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 501F-5204 by apply_coverage --split

Label_4E_5088:: ; 4E:5088
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_4E_5096
	ld a, $11
	ld [wRam_C1DC], a
	jr Label_4E_509D

Label_4E_5096:: ; 4E:5096
	ld a, $10
	ld [wRam_C1DC], a
	jr Label_4E_509D

; ---- code $509D-$5107 (106 bytes) [CONFIRMED] 33 insn(s) executed; cut out of the PROBABLE region 501F-5204 by apply_coverage --split [executed in 1 scenarios]

Label_4E_509D:: ; 4E:509D
	ld de, $C380
	xor a, a
	farcall Browser_HistoryPop
	ld bc, $1000
	ld de, $B000
	ld a, $03
	farcall PageCache_Pop
	farcall Html_ParsePage
	jp Browser_PageView_Enter

Browser_ConnectionNotice:: ; 4E:50BE
	farcall Palette_FadeOutToWhite
	farcall Function_00_09B6
	ld a, [wCommSessionKind]
	xor a, $01
	ld [wRam_C1D0], a
	ld a, [wCommSessionKind]
	ld [wRam_C1D1], a
	ld hl, $C26F
	res 0, [hl]
	farcall CommNotice_ShowDialog
	or a, a
	jr z, Label_4E_50EC
	farcall CommTime_ShowSummary

Label_4E_50EC:: ; 4E:50EC
	xor a, a
	ld [wRam_C1DC], a
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	bit 4, a
	jp nz, Label_4E_5104
	ld a, $09
	ld [wRam_C26E], a
	xor a, a
	ld [wRam_C26F], a

Label_4E_5104:: ; 4E:5104
	jp Browser_PageView_Enter

; ---- code $5107-$5204 (253 bytes) [PROBABLE] 79 insn(s) never executed in the traced runs; cut out of the PROBABLE region 501F-5204 by apply_coverage --split

Label_4E_5107:: ; 4E:5107
	xor a, a
	ld [wRam_C1DC], a
	ld a, [wCommSessionKind]
	xor a, $01
	ld [wRam_C1D0], a
	ld a, [wCommSessionKind]
	ld [wRam_C1D1], a
	ld hl, $C26F
	res 0, [hl]
	farcall CommNotice_ShowDialog
	or a, a
	jr z, Label_4E_512D
	farcall CommTime_ShowSummary

Label_4E_512D:: ; 4E:512D
	ld de, $C380
	xor a, a
	farcall Browser_HistoryPop
	ld bc, $1000
	ld de, $B000
	ld a, $03
	farcall PageCache_Pop
	farcall Html_ParsePage
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	bit 4, a
	jp nz, Label_4E_515F
	ld a, $09
	ld [wRam_C26E], a
	xor a, a
	ld [wRam_C26F], a

Label_4E_515F:: ; 4E:515F
	jp Browser_PageView_Enter

Browser_Menu_LinkLost:: ; 4E:5162
	ld a, $09
	ld [wRam_C26E], a
	xor a, a
	ld [wRam_C26F], a
	xor a, a
	ld [wBrowserFetchResult], a
	ld de, $18A0
	ld hl, $DA90
	call Function_00_0A65
	ld hl, $DAB0
	call Function_00_09E6
	ld de, $0110
	farcall Dialog_ShowMonitored
	farcall Palette_FadeOutToWhite
	farcall Function_00_09B6
	farcall CommTime_ShowSummary
	xor a, a
	ld [wRam_C1DC], a
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	jp Browser_PageView_Enter

Browser_Menu_AdapterError:: ; 4E:51A6
	farcall Mobile_FetchResult
	ld a, [wMobileResultDetail]
	ld [wRam_C273], a
	ld a, [wMobileResultDetail + 1]
	ld [wRam_C274], a
	ld a, [wMobileResultCode]
	ld [wMobileErrorCode], a
	xor a, a
	ld [wBrowserFetchResult], a
	ld a, [wCommSessionKind]
	xor a, $01
	ld [wRam_C1D0], a
	ld a, [wCommSessionKind]
	ld [wRam_C1D1], a
	farcall Palette_FadeOutToWhite
	farcall Function_00_09B6
	farcall Function_4E_4866
	farcall Mobile_ShowLastError
	ld a, $09
	ld [wRam_C26E], a
	xor a, a
	ld [wRam_C26F], a
	farcall CommTime_ShowSummary
	xor a, a
	ld [wRam_C1DC], a
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	jp Browser_PageView_Enter
