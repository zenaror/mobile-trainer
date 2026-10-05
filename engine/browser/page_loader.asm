; engine/browser/page_loader.asm
; bank 4C, $4000-$46B8 (1720 bytes); pinned by layout.link
; Browser_LoadPage: URL -> connect -> HTTP GET -> scan/layout

SECTION "engine/browser/page_loader", ROMX

Browser_LoadPage:: ; 4C:4000
Function_4C_4000::
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, $C380
	farcall HtmlUrl_GetSchemeId
	cp a, $FF
	jr z, Browser_LoadPage_Fail
	call JumpTableInline

; ---- ptrtable $4010-$4016 (6 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4C:400D: 3 entries; end = first entry target

Browser_LoadPage_SchemeTable:: ; 4C:4010
Table_4C_4010::
	dw Browser_LoadPage_Fail
	dw Browser_LoadPage_Http
	dw Label_4C_4016

Label_4C_4016:: ; 4C:4016
	; [PROBABLE] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 1;
	; entered by table from 4C:400D (executed)
	ret

Label_4C_4017:: ; 4C:4017
	farcall Mobile_FetchResult

Label_4C_401D:: ; 4C:401D
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [wMobileResultDetail]
	ld [wMobileErrorDetail], a
	ld a, [wMobileResultDetail + 1]
	ld [wMobileErrorDetailHi], a
	ld a, [wMobileResultCode]
	ld [wMobileErrorCode], a
	ld a, $09
	ld [wTimerAWarnMinute], a
	xor a, a
	ld [wTimerAWarnFlags], a
	farcall Palette_FadeOutToWhite
	farcall Sprite_ResetAll
	jp Label_4C_40E4

Browser_LoadPage_Fail:: ; 4C:404D
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [wMobileResultDetail]
	ld [wMobileErrorDetail], a
	ld a, [wMobileResultDetail + 1]
	ld [wMobileErrorDetailHi], a
	ld a, [wMobileResultCode]
	ld [wMobileErrorCode], a
	farcall Browser_MapErrorToResult
	and a, $80
	jr z, .l40D3

	; [CONFIRMED] 31 insn(s) reached by static flow only; seeds: exec x31; min discovery hops 0;
	; fall-through of the jrcc at 4C:406D (executed) | 3 insn(s) executed; cut out of the PROBABLE
	; region 406F-40D3 by apply_coverage --split [executed in 1 scenarios]
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l40B4

	; [PROBABLE] 18 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 406F-40D3 by apply_coverage --split
	farcall Mobile_BeginDisconnect
.l407C ; 4C:407C
	farcall Mobile_DisconnectPoll
	or a, a
	jr z, .l40D3
	cp a, $FF
	jp z, .l4095
	ld a, $00
	farcall CommProgress_Step
	jp .l407C
.l4095 ; 4C:4095
	farcall Mobile_BeginCancel
.l409B ; 4C:409B
	farcall Mobile_CancelPoll
	or a, a
	jr z, .l40D3
	cp a, $FF
	jp z, .l40D3
	ld a, $00
	farcall CommProgress_Step
	jp .l409B

.l40B4 ; 4C:40B4
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 406F-40D3 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, [wTimerEnable]
	bit 1, a
	jp z, .l40C2

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 406F-40D3 by apply_coverage --split
	farcall Mobile_FetchResult

.l40C2 ; 4C:40C2
	; [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 406F-40D3 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $36
	farcall MobileAPI
	ld a, $09
	ld [wTimerAWarnMinute], a
	xor a, a
	ld [wTimerAWarnFlags], a

.l40D3 ; 4C:40D3
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ld a, [wTimerEnable]
	bit 4, a
	jp nz, Label_4C_40E4

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jpcc at 4C:40D8 (executed) [executed in 1 scenarios]
	ld a, $09
	ld [wTimerAWarnMinute], a
	xor a, a
	ld [wTimerAWarnFlags], a

Label_4C_40E4:: ; 4C:40E4
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)
	farcall Screen_FadeOutAndResetObjWindow
	ld a, [wCommSessionKind]
	xor a, $01
	ld [wCommNoticeMode], a
	ld a, [wCommSessionKind]
	ld [wCommNoticeGfxSet], a
	farcall Mobile_ShowLastError
	farcall Sram_CountMobileError12Or26
	farcall Sprite_ResetAll
	ld a, [wMobileErrorCode]
	cp a, $33
	jr nz, .l4123

	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0;
	; fall-through of the jrcc at 4C:410F (executed)
	ld a, [wMobileErrorDetailHi]
	cp a, $01
	jr nz, .l4123
	ld a, [wMobileErrorDetail]
	cp a, $01
	jr z, .l4132
	cp a, $02
	jr z, .l4132

.l4123 ; 4C:4123
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)
	ld a, [wMobileErrorCode]
	farcall Browser_MapErrorToResult
	and a, $7F
	ld [wBrowserFetchResult], a
	ret

.l4132 ; 4C:4132
	; [PROBABLE] 110 insn(s) reached by static flow only; seeds: exec x110; min discovery hops 1;
	; entered by jrcc from 4C:411D (PROBABLE code) | 3 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 4132-4251 by apply_coverage --split
	ld a, $00
	ld [wBrowserFetchResult], a
	ret

Label_4C_4138:: ; 4C:4138
	; [CONFIRMED] 55 insn(s) executed; cut out of the PROBABLE region 4132-4251 by apply_coverage
	; --split [executed in 3 scenarios]
	farcall Mobile_BeginCancel
.loop ; 4C:413E
	farcall Mobile_CancelPoll
	or a, a
	jr z, .l4157
	cp a, $FF
	jp z, Label_4C_401D
	ld a, $00
	farcall CommProgress_Step
	jp .loop
.l4157 ; 4C:4157
	ld a, $01
	farcall CommProgress_Step
	or a, a
	jr nz, .l4157
	ld a, $09
	ld [wTimerAWarnMinute], a
	xor a, a
	ld [wTimerAWarnFlags], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	farcall Sprite_ResetAll
	ld a, $02
	ld [wBrowserFetchResult], a
	ret

Label_4C_417D:: ; 4C:417D
	ld a, $05
	ld [wCommTimeoutMinutes], a
	ld hl, $C266
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	farcall Mobile_BeginStop
.l418F ; 4C:418F
	farcall Mobile_StopPoll
	or a, a
	jr z, .l41A8
	cp a, $FF
	jp z, Browser_LoadPage_Fail
	ld a, $00
	farcall CommProgress_Step
	jp .l418F
.l41A8 ; 4C:41A8
	ld a, [wBrowserFetchActive]
	or a, a
	jr z, .l41FB
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l41F3
	farcall Mobile_BeginDisconnect
.l41BB ; 4C:41BB
	farcall Mobile_DisconnectPoll
	or a, a
	jr z, .l41FB
	cp a, $FF
	jp z, .l41D4
	ld a, $00
	farcall CommProgress_Step
	jp .l41BB

.l41D4 ; 4C:41D4
	; [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4132-4251 by apply_coverage --split
	farcall Mobile_BeginCancel
.l41DA ; 4C:41DA
	farcall Mobile_CancelPoll
	or a, a
	jr z, .l41FB
	cp a, $FF
	jp z, .l41FB
	ld a, $00
	farcall CommProgress_Step
	jp .l41DA
.l41F3 ; 4C:41F3
	ld a, $36
	farcall MobileAPI

.l41FB ; 4C:41FB
	; [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 4132-4251 by apply_coverage
	; --split [executed in 2 scenarios]
	ld a, $01
	farcall CommProgress_Step
	or a, a
	jr nz, .l41FB
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l424C
	ld hl, $C26F
	bit 0, [hl]
	jr nz, .l424D
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l424C

	; [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4132-4251 by apply_coverage --split
	jr nz, .l4228
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l424C
.l4228 ; 4C:4228
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l4238
	ld hl, $C26F
	bit 1, [hl]
	jr nz, .l424C
	set 1, [hl]
.l4238 ; 4C:4238
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, .l424D
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l424D

.l424C ; 4C:424C
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 4132-4251 by apply_coverage
	; --split [executed in 3 scenarios]
	xor a, a
.l424D ; 4C:424D
	pop hl
	or a, a
	jr nz, Label_4C_427F

Label_4C_4251:: ; 4C:4251
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 2/18 scenarios)
	ld a, [wTimerEnable]
	bit 4, a
	jp nz, .l4262
	ld a, $09
	ld [wTimerAWarnMinute], a
	xor a, a
	ld [wTimerAWarnFlags], a
.l4262 ; 4C:4262
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	farcall Sprite_ResetAll
	ld a, $02
	ld [wBrowserFetchResult], a
	ret

Label_4C_4274:: ; 4C:4274
	; [PROBABLE] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 4;
	; entered by jrcc from 4C:427D (PROBABLE code)
	ld a, $01
	farcall CommProgress_Step
	or a, a
	jr nz, Label_4C_4274

Label_4C_427F:: ; 4C:427F
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	farcall Sprite_ResetAll
	ld a, $06
	ld [wBrowserFetchResult], a
	ret

Browser_LoadPage_Http:: ; 4C:4291
	; [CONFIRMED] 28 insn(s); 28 executed (in up to 4/18 scenarios)
	ld de, $D400
	ld hl, $C380
	ld bc, $0100
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call CopyBytes
	ld a, [wBrowserNavigating]
	or a, a
	jr z, .l42B5
	farcall Browser_HistoryPush
	farcall PageCache_Push
.l42B5 ; 4C:42B5
	ld a, [wTimerEnable]
	bit 4, a
	jp z, .l42E1
	bit 1, a
	jp nz, Label_4C_4017
	farcall Palette_FadeOutToWhite
	farcall Sprite_ResetAll
	ld a, $01
	farcall CommProgress_Init
	ld a, $00
	farcall CommProgress_Step
	jp Browser_LoadPage_Request
.l42E1 ; 4C:42E1
	farcall Palette_FadeOutToWhite
	farcall Sprite_ResetAll
	ld a, [wCommSessionKind]
	call JumpTableInline

; ---- ptrtable $42F3-$42F7 (4 bytes) [CONFIRMED] inline table of `call $0545` (JumpTableInline) at 4C:42F0: 2 entries; end pinned by the executed instruction at 42F7; every byte read as data in a trace

Browser_LoadPage_SessionKindTable:: ; 4C:42F3
Table_4C_42F3::
	dw Label_4C_42F7
	dw Label_4C_4312

Label_4C_42F7:: ; 4C:42F7
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	ld d, $4C
	ld bc, $430A
	farcall ConnectDialog_Run
	ld a, b
	or a, a
	jp nz, Label_4C_4251
	jp Browser_LoadPage_Connect

; ---- data $430A-$4312 (8 bytes) [PROBABLE] contiguous data block 430A-4312: 4 bytes were read as data by executed code in mGBA traces (2 separate read ranges, e.g. 430A-430B,430D-4310) and 4 bytes between/around those reads were never read; the whole run is one table/buffer read by index (gaps unread in the traces); content class not decoded [merged from 4 regions by classify_g2]

Data_4C_430A:: ; 4C:430A
	db $03, $00, $00, $F0, $20, $C2, $00, $00

Label_4C_4312:: ; 4C:4312
	; [CONFIRMED] 181 insn(s); 181 executed (in up to 3/18 scenarios)
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	farcall PasswordPrompt_Ask
	or a, a
	jp z, Label_4C_4251
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a

Browser_LoadPage_Connect:: ; 4C:4330
	ld a, $00
	farcall CommProgress_Init
	ld a, $00
	farcall CommProgress_Step
	xor a, a
	ld [wCommSessionActive], a
	ld hl, $C2D2
	ld [hli], a
	ld [hl], a
	ld hl, $C2D4
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $09
	ld [wTimerAWarnMinute], a
	xor a, a
	ld [wTimerAWarnFlags], a
	farcall Mobile_SessionInit
.l435F ; 4C:435F
	farcall Mobile_ConnectPoll
	or a, a
	jr z, .l437D
	cp a, $FF
	jp z, Browser_LoadPage_Fail
	ld a, $00
	farcall CommProgress_Step
	cp a, $02
	jp z, Label_4C_4138
	jp .l435F
.l437D ; 4C:437D
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [wBrowserDialSlotPlus1]
	ld c, a
	or a, a
	jr nz, .l439B
	ld de, $C240
	farcall Dial_CopySelectedNumber
.l439B ; 4C:439B
	ld hl, $C220
	farcall Mobile_BeginConnect
.l43A4 ; 4C:43A4
	farcall Mobile_ConnectPoll
	or a, a
	jr z, .l43C2
	cp a, $FF
	jp z, Browser_LoadPage_Fail
	ld a, $00
	farcall CommProgress_Step
	cp a, $02
	jp z, Label_4C_4138
	jp .l43A4
.l43C2 ; 4C:43C2
	ld a, $01
	ld [wCommSessionActive], a
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a

Browser_LoadPage_Request:: ; 4C:43CD
	call Sound_FrameService
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $C380
	ld hl, $D400
	ld bc, $0100
	call CopyBytes
	ld de, $D500
	ld hl, $D400
	ld bc, $0100
	call CopyBytes
	call Sound_FrameService
	ld a, [wRam_C2C5]
	ld c, a
	ld a, [wRam_C2C6]
	or a, c
	jr z, .l4467
	ld a, c
	ld a, $00
	ld [wRam_C240], a
	ld a, $A0
	ld [wRam_C241], a
	call Sound_FrameService
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
	farcall Net_BuildLoginPostBody
	ld a, c
	ld [wRam_C242], a
	ld a, b
	ld [wRam_C243], a
	ld a, $05
	ld [wCommTimeoutMinutes], a
	ld hl, $C266
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, $C380
	ld de, sBrowserPageBuf
	ld a, e
	ld [wBrowserRxPtr], a
	ld a, d
	ld [wBrowserRxPtr + 1], a
	ld bc, $0FFC
	ld a, $03
	ld [wBrowserRxBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	farcall Http_StartPost
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	jp Browser_LoadPage_WaitReply
.l4467 ; 4C:4467
	call Sound_FrameService
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
	call Url_StripFragment
	ld a, $05
	ld [wCommTimeoutMinutes], a
	ld hl, $C266
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, $C380
	ld de, sBrowserPageBuf
	ld a, e
	ld [wBrowserRxPtr], a
	ld a, d
	ld [wBrowserRxPtr + 1], a
	ld bc, $0FFC
	ld a, $03
	ld [wBrowserRxBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	farcall Http_StartGet
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a

Browser_LoadPage_WaitReply:: ; 4C:44BA
	farcall Http_Poll
	or a, a
	jr z, Label_4C_4537
	cp a, $FF
	jp z, Browser_LoadPage_Fail
	ld a, $00
	farcall CommProgress_Step
	cp a, $02
	jp z, Label_4C_417D
	ld a, [wCommTimeoutMinutes]
	ld b, a
	ld a, [wTimerBMinutes]
	cp a, b
	jr z, .l44E2
	xor a, a
	jr .l44E4

.l44E2 ; 4C:44E2
	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by jrcc from 4C:44DD (executed)
	ld a, $FF

.l44E4 ; 4C:44E4
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 2/18 scenarios)
	or a, a
	jp nz, Label_4C_458B

Label_4C_44E8:: ; 4C:44E8
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l452E
	ld hl, $C26F
	bit 0, [hl]
	jr nz, .l452F
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l452E

	; [CONFIRMED] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 0;
	; fall-through of the jrcc at 4C:44FF (executed) | 4 insn(s) executed; cut out of the PROBABLE
	; region 4501-452E by apply_coverage --split [executed in 2 scenarios]
	jr nz, .l450A
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l452E

.l450A ; 4C:450A
	; [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4501-452E by apply_coverage --split
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l451A
	ld hl, $C26F
	bit 1, [hl]
	jr nz, .l452E
	set 1, [hl]
.l451A ; 4C:451A
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, .l452F
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l452F

.l452E ; 4C:452E
	; [CONFIRMED] 28 insn(s); 28 executed (in up to 2/18 scenarios)
	xor a, a
.l452F ; 4C:452F
	pop hl
	or a, a
	jp nz, Label_4C_417D
	jp Browser_LoadPage_WaitReply

Label_4C_4537:: ; 4C:4537
	farcall Browser_WrapImageInHtml
	or a, a
	jr nz, .l4577
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld de, sBrowserPageBuf
	ld hl, sBrowserPageBuf
	ld bc, $1000
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	farcall Charset_ConvertPage
	farcall Html_ScanPage
	ld a, [wHtmlFlags]
	and a, $01
	jr z, .l4577
	farcall Browser_FetchInlineImages
.l4577 ; 4C:4577
	ld a, [wBrowserFetchResult]
	call JumpTableInline

; ---- ptrtable $457D-$458B (14 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4C:457A: 7 entries; end is a heuristic guess (words stay plausible code pointers)

Browser_LoadPage_WaitReply_ResultTable:: ; 4C:457D
Table_4C_457D::
	dw Label_4C_460D
	dw Label_4C_417D
	dw Label_4C_417D
	dw Browser_LoadPage_Fail
	dw Browser_LoadPage_Fail
	dw Browser_LoadPage_Fail
	dw Label_4C_417D

Label_4C_458B:: ; 4C:458B
	; [PROBABLE] 55 insn(s) reached by static flow only; seeds: exec x55; min discovery hops 1;
	; entered by jpcc from 4C:44E5 (executed)
	ld a, [wTimerEnable]
	bit 0, a
	jp z, Label_4C_44E8
	farcall Mobile_BeginStop
.loop ; 4C:4599
	farcall Mobile_StopPoll
	or a, a
	jr z, .l45B2
	cp a, $FF
	jp z, Browser_LoadPage_Fail
	ld a, $00
	farcall CommProgress_Step
	jp .loop
.l45B2 ; 4C:45B2
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l45F8
	ld hl, $C26F
	bit 0, [hl]
	jr nz, .l45F9
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l45F8
	jr nz, .l45D4
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l45F8
.l45D4 ; 4C:45D4
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l45E4
	ld hl, $C26F
	bit 1, [hl]
	jr nz, .l45F8
	set 1, [hl]
.l45E4 ; 4C:45E4
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, .l45F9
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l45F9
.l45F8 ; 4C:45F8
	xor a, a
.l45F9 ; 4C:45F9
	pop hl
	or a, a
	jp nz, Label_4C_4274
	ld a, $26
	ld [wMobileResultCode], a
	xor a, a
	ld [wMobileResultDetail], a
	ld [wMobileResultDetail + 1], a
	jp Browser_LoadPage_Fail

Label_4C_460D:: ; 4C:460D
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ld a, [wCommSessionKind]
	cp a, $01
	jr nz, .l4622

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 4C:4612 (executed) [executed in 1 scenarios]
	farcall Html_ParsePage
	ld a, [wBrowserFetchResult]
	cp a, $04
	jp z, Browser_LoadPage_Fail

.l4622 ; 4C:4622
	; [CONFIRMED] 22 insn(s); 22 executed (in up to 1/18 scenarios)
	ld a, $01
	farcall CommProgress_Step
	or a, a
	jr nz, .l4622
	ld a, [wCommSessionKind]
	cp a, $01
	jr z, .l463A
	farcall Html_ParsePage
.l463A ; 4C:463A
	xor a, a
	ld [wBrowserFetchResult], a
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l4684
	ld hl, $C26F
	bit 0, [hl]
	jr nz, .l4685
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l4684

	; [CONFIRMED] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 0;
	; fall-through of the jrcc at 4C:4655 (executed) | 4 insn(s) executed; cut out of the PROBABLE
	; region 4657-4684 by apply_coverage --split [executed in 2 scenarios]
	jr nz, .l4660
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l4684

.l4660 ; 4C:4660
	; [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4657-4684 by apply_coverage --split
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l4670
	ld hl, $C26F
	bit 1, [hl]
	jr nz, .l4684
	set 1, [hl]
.l4670 ; 4C:4670
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, .l4685
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l4685

.l4684 ; 4C:4684
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	xor a, a
.l4685 ; 4C:4685
	pop hl
	or a, a
	jp nz, Label_4C_427F
	ld a, [wTimerEnable]
	bit 4, a
	jp nz, .l469B

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jpcc at 4C:468F (executed)
	ld a, $09
	ld [wTimerAWarnMinute], a
	xor a, a
	ld [wTimerAWarnFlags], a

.l469B ; 4C:469B
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ld a, [wBrowserPendingMessage]
	or a, a
	ret z

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the retcc at 4C:469F (executed) [executed in 1 scenarios]
	ld a, $0C
	ld [wBrowserPendingMessage], a
	ret

Url_StripFragment:: ; 4C:46A6
Function_4C_46A6::
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 3/18 scenarios); entry proven: target of an
	; executed call/far call (part of region $46A6-$46C0)
	call Sound_FrameService
	ld hl, $C380
.loop ; 4C:46AC
	ld a, [hli]
	cp a, $23
	jr z, .l46B4
	or a, a
	jr nz, .loop
.l46B4 ; 4C:46B4
	dec hl
	xor a, a
	ld [hli], a
	ret
