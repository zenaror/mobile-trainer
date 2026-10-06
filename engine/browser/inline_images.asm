; engine/browser/inline_images.asm
; bank 4C, $4840-$4B54 (788 bytes); pinned by layout.link
; Browser_FetchInlineImages

SECTION "engine/browser/inline_images", ROMX

Browser_FetchInlineImages:: ; 4C:4840
	; [CONFIRMED] 67 insn(s); 67 executed (in up to 1/18 scenarios) (part of region $482A-$48B6)
	ld a, $00
	ldh [hInlineImages_UrlList], a
	ld a, $DE
	ldh [hInlineImages_UrlListHi], a
	ld a, $04
	ldh [hInlineImages_UrlBank], a
	ld de, wAttrUrlBuf
	ld hl, wBrowserPageUrl
	ld bc, $0100
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call CopyBytes
	call Sound_FrameService
	ld de, wHtmlImageBaseUrl
	ld hl, wAttrUrlBuf
	ld bc, $0100
	ld a, $04
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call CopyBytes
	ld a, $00
	ld [wBrowserFetchResult], a
.l4878 ; 4C:4878
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
	call Sound_FrameService
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

	; [CONFIRMED] 314 insn(s) reached by static flow only; seeds: exec x314; min discovery hops 0;
	; fall-through of the retcc at 4C:48B5 (executed) | 90 insn(s) executed; cut out of the PROBABLE
	; region 48B6-4B54 by apply_coverage --split [executed in 3 scenarios]
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
	ld a, $FC
	sub a, l
	ld a, $BF
	sbc a, h
	jp z, .l4AD5
	bit 7, a
	jp nz, .l4AD5
	ld a, [wBrowserRxBank]
	call BankSwitch_H
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
.l48DF ; 4C:48DF
	ld a, [de]
	ld [hli], a
	inc de
	or a, a
	jr nz, .l48DF
	ld a, l
	ld [wBrowserRxPtr], a
	ld a, h
	ld [wBrowserRxPtr + 1], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop hl
	ld de, wHtmlImageBaseUrl
	ld a, $04
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	farcall HtmlUrl_Resolve
	ld hl, wAttrUrlBuf
	farcall HtmlUrl_NormalizePath
	call Url_StripFragment
	ld a, $05
	ld [wCommTimeoutMinutes], a
	ld hl, wTimerBFrames
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hl], a
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
	jp z, .l4AD6
	bit 7, a
	jp nz, .l4AD6
	ld b, a
	ld a, [wBrowserRxBank]
	ldh [hSRAMBank], a
	ld [rRAMB], a
	farcall Http_StartGet
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
.l4952 ; 4C:4952
	farcall Http_Poll
	or a, a
	jr z, .l49CF
	cp a, $FF
	jp z, .l4A58
	ld a, $00
	farcall CommProgress_Step
	cp a, $02
	jp z, .l4AE2
	ld a, [wCommTimeoutMinutes]
	ld b, a
	ld a, [wTimerBMinutes]
	cp a, b
	jr z, .l497A
	xor a, a
	jr .l497C

.l497A ; 4C:497A
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 48B6-4B54 by apply_coverage --split
	ld a, $FF

.l497C ; 4C:497C
	; [CONFIRMED] 14 insn(s) executed; cut out of the PROBABLE region 48B6-4B54 by apply_coverage
	; --split [executed in 3 scenarios]
	or a, a
	jp nz, .l4A25
.l4980 ; 4C:4980
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l49C6
	ld hl, wTimerAWarnFlags
	bit 0, [hl]
	jr nz, .l49C7
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l49C6

	; [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 48B6-4B54 by apply_coverage --split
	jr nz, .l49A2
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l49C6
.l49A2 ; 4C:49A2
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l49B2
	ld hl, wTimerAWarnFlags
	bit 1, [hl]
	jr nz, .l49C6
	set 1, [hl]
.l49B2 ; 4C:49B2
	ld hl, wTimerAWarnFlags
	set 0, [hl]
	ld hl, wTimerAWarnMinute
	ld a, [hl]
	cp a, $45
	jr z, .l49C7
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l49C7

.l49C6 ; 4C:49C6
	; [CONFIRMED] 17 insn(s) executed; cut out of the PROBABLE region 48B6-4B54 by apply_coverage
	; --split [executed in 2 scenarios]
	xor a, a
.l49C7 ; 4C:49C7
	pop hl
	or a, a
	jp nz, .l4AE2
	jp .l4952
.l49CF ; 4C:49CF
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l4A15
	ld hl, wTimerAWarnFlags
	bit 0, [hl]
	jr nz, .l4A16
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l4A15

	; [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 48B6-4B54 by apply_coverage --split
	jr nz, .l49F1
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l4A15
.l49F1 ; 4C:49F1
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l4A01
	ld hl, wTimerAWarnFlags
	bit 1, [hl]
	jr nz, .l4A15
	set 1, [hl]
.l4A01 ; 4C:4A01
	ld hl, wTimerAWarnFlags
	set 0, [hl]
	ld hl, wTimerAWarnMinute
	ld a, [hl]
	cp a, $45
	jr z, .l4A16
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l4A16

.l4A15 ; 4C:4A15
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 48B6-4B54 by apply_coverage
	; --split [executed in 2 scenarios]
	xor a, a
.l4A16 ; 4C:4A16
	pop hl
	or a, a
	jp nz, .l4B4E
	ld a, [wBrowserPendingMessage]
	or a, a
	jp nz, .l4AD6
	jp .l4878

.l4A25 ; 4C:4A25
	; [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 48B6-4B54 by apply_coverage --split
	ld a, [wTimerEnable]
	bit 0, a
	jp z, .l4980
	farcall Mobile_BeginStop
.l4A33 ; 4C:4A33
	farcall Mobile_StopPoll
	or a, a
	jr z, .l4A4C
	cp a, $FF
	jp z, .l4A58
	ld a, $00
	farcall CommProgress_Step
	jp .l4A33
.l4A4C ; 4C:4A4C
	ld a, $26
	ld [wMobileResultCode], a
	xor a, a
	ld [wMobileResultDetail], a
	ld [wMobileResultDetail + 1], a

.l4A58 ; 4C:4A58
	; [CONFIRMED] 28 insn(s) executed; cut out of the PROBABLE region 48B6-4B54 by apply_coverage
	; --split [executed in 1 scenarios]
	ldh a, [hInlineImages_ListEnd]
	ld e, a
	ldh a, [hInlineImages_ListEndHi]
	ld d, a
	ld a, [wBrowserRxBank]
	call BankSwitch_D
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ld [de], a
	inc de
	ld [de], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l4ABB
	ld hl, wTimerAWarnFlags
	bit 0, [hl]
	jr nz, .l4ABC
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l4ABB

	; [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 48B6-4B54 by apply_coverage --split
	jr nz, .l4A97
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l4ABB
.l4A97 ; 4C:4A97
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l4AA7
	ld hl, wTimerAWarnFlags
	bit 1, [hl]
	jr nz, .l4ABB
	set 1, [hl]
.l4AA7 ; 4C:4AA7
	ld hl, wTimerAWarnFlags
	set 0, [hl]
	ld hl, wTimerAWarnMinute
	ld a, [hl]
	cp a, $45
	jr z, .l4ABC
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l4ABC

.l4ABB ; 4C:4ABB
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 48B6-4B54 by apply_coverage
	; --split [executed in 1 scenarios]
	xor a, a
.l4ABC ; 4C:4ABC
	pop hl
	or a, a
	jp nz, .l4B4E
	ld a, [wMobileResultCode]
	cp a, $24
	jp z, .l4878
	cp a, $32
	jp z, .l4878

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 48B6-4B54 by apply_coverage --split
	ld a, $03
	ld [wBrowserFetchResult], a
	jr .l4AE7
.l4AD5 ; 4C:4AD5
	pop de
.l4AD6 ; 4C:4AD6
	ld a, $00
	ld [wBrowserFetchResult], a
	ld a, $01
	ld [wBrowserPendingMessage], a
	jr .l4AE7

.l4AE2 ; 4C:4AE2
	; [CONFIRMED] 30 insn(s) executed; cut out of the PROBABLE region 48B6-4B54 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $02
	ld [wBrowserFetchResult], a
.l4AE7 ; 4C:4AE7
	ldh a, [hInlineImages_ListEnd]
	ld e, a
	ldh a, [hInlineImages_ListEndHi]
	ld d, a
	ld a, [wBrowserRxBank]
	call BankSwitch_D
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ld [de], a
	inc de
	ld [de], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l4B4A
	ld hl, wTimerAWarnFlags
	bit 0, [hl]
	jr nz, .l4B4B
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l4B4A

	; [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 48B6-4B54 by apply_coverage --split
	jr nz, .l4B26
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l4B4A
.l4B26 ; 4C:4B26
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l4B36
	ld hl, wTimerAWarnFlags
	bit 1, [hl]
	jr nz, .l4B4A
	set 1, [hl]
.l4B36 ; 4C:4B36
	ld hl, wTimerAWarnFlags
	set 0, [hl]
	ld hl, wTimerAWarnMinute
	ld a, [hl]
	cp a, $45
	jr z, .l4B4B
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l4B4B

.l4B4A ; 4C:4B4A
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 48B6-4B54 by apply_coverage
	; --split [executed in 1 scenarios]
	xor a, a
.l4B4B ; 4C:4B4B
	pop hl
	or a, a
	ret z

.l4B4E ; 4C:4B4E
	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 48B6-4B54 by apply_coverage --split
	ld a, $06
	ld [wBrowserPendingMessage], a
	ret
