; engine/browser/page_loader.asm
; bank 4C, $4000-$46B8 (1720 bytes); pinned by layout.link
; Browser_LoadPage: URL -> connect -> HTTP GET -> scan/layout

SECTION "engine/browser/page_loader", ROMX

Browser_LoadPage:: ; 4C:4000

	; [CONFIRMED] 5 insn(s); 5 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, wAttrUrlBuf
	farcall HtmlUrl_GetSchemeId
	cp a, $FF
	jr z, Browser_LoadPage_Fail
	call JumpTableInline

; ---- ptrtable $4010-$4016 (6 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4C:400D: 3 entries; end = first entry target

Browser_LoadPage_SchemeTable:: ; 4C:4010
	dw Browser_LoadPage_Fail
	dw Browser_LoadPage_Http
	dw Browser_LoadPage_ReturnOnly
Browser_LoadPage_ReturnOnly:: ; [PROBABLE] table-target operation: RET only; entry unobserved.
	; [PROBABLE] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 1;
	; entered by table from 4C:400D (executed)
	ret

Browser_LoadPage_OnAdapterError:: ; 4C:4017
	farcall Mobile_FetchResult

Browser_LoadPage_FailNoDisconnect:: ; 4C:401D
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
	jp Browser_LoadPage_ShowError

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
.poll_disconnect ; 4C:407C
	farcall Mobile_DisconnectPoll
	or a, a
	jr z, .l40D3
	cp a, $FF
	jp z, .begin_cancel
	ld a, $00
	farcall CommProgress_Step
	jp .poll_disconnect
.begin_cancel ; 4C:4095
	farcall Mobile_BeginCancel
.poll_cancel ; 4C:409B
	farcall Mobile_CancelPoll
	or a, a
	jr z, .l40D3
	cp a, $FF
	jp z, .l40D3
	ld a, $00
	farcall CommProgress_Step
	jp .poll_cancel

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
	jp nz, Browser_LoadPage_ShowError

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jpcc at 4C:40D8 (executed) [executed in 1 scenarios]
	ld a, $09
	ld [wTimerAWarnMinute], a
	xor a, a
	ld [wTimerAWarnFlags], a

Browser_LoadPage_ShowError:: ; 4C:40E4
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
	jr z, .clear_fetch_result_and_return
	cp a, $02
	jr z, .clear_fetch_result_and_return

.l4123 ; 4C:4123
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)
	ld a, [wMobileErrorCode]
	farcall Browser_MapErrorToResult
	and a, $7F
	ld [wBrowserFetchResult], a
	ret

.clear_fetch_result_and_return ; 4C:4132
	; [PROBABLE] 110 insn(s) reached by static flow only; seeds: exec x110; min discovery hops 1;
	; entered by jrcc from 4C:411D (PROBABLE code) | 3 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 4132-4251 by apply_coverage --split
	ld a, $00
	ld [wBrowserFetchResult], a
	ret

Browser_LoadPage_CancelConnect:: ; 4C:4138
	; [CONFIRMED] 55 insn(s) executed; cut out of the PROBABLE region 4132-4251 by apply_coverage
	; --split [executed in 3 scenarios]
	farcall Mobile_BeginCancel
.poll_cancel ; 4C:413E
	farcall Mobile_CancelPoll
	or a, a
	jr z, .step_progress_until_zero
	cp a, $FF
	jp z, Browser_LoadPage_FailNoDisconnect
	ld a, $00
	farcall CommProgress_Step
	jp .poll_cancel
.step_progress_until_zero ; 4C:4157
	ld a, $01
	farcall CommProgress_Step
	or a, a
	jr nz, .step_progress_until_zero
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

Browser_LoadPage_StopRequest:: ; 4C:417D
	ld a, $05
	ld [wCommTimeoutMinutes], a
	ld hl, wTimerBFrames
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	farcall Mobile_BeginStop
.poll_stop ; 4C:418F
	farcall Mobile_StopPoll
	or a, a
	jr z, .l41A8
	cp a, $FF
	jp z, Browser_LoadPage_Fail
	ld a, $00
	farcall CommProgress_Step
	jp .poll_stop
.l41A8 ; 4C:41A8
	ld a, [wBrowserFetchActive]
	or a, a
	jr z, .step_progress_until_zero
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l41F3
	farcall Mobile_BeginDisconnect
.poll_disconnect ; 4C:41BB
	farcall Mobile_DisconnectPoll
	or a, a
	jr z, .step_progress_until_zero
	cp a, $FF
	jp z, .begin_cancel
	ld a, $00
	farcall CommProgress_Step
	jp .poll_disconnect

.begin_cancel ; 4C:41D4
	; [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4132-4251 by apply_coverage --split
	farcall Mobile_BeginCancel
.poll_cancel ; 4C:41DA
	farcall Mobile_CancelPoll
	or a, a
	jr z, .step_progress_until_zero
	cp a, $FF
	jp z, .step_progress_until_zero
	ld a, $00
	farcall CommProgress_Step
	jp .poll_cancel
.l41F3 ; 4C:41F3
	ld a, $36
	farcall MobileAPI

.step_progress_until_zero ; 4C:41FB
	; [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 4132-4251 by apply_coverage
	; --split [executed in 2 scenarios]
	ld a, $01
	farcall CommProgress_Step
	or a, a
	jr nz, .step_progress_until_zero
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .clear_warning_result
	ld hl, wTimerAWarnFlags
	bit 0, [hl]
	jr nz, .l424D
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .clear_warning_result

	; [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4132-4251 by apply_coverage --split
	jr nz, .l4228
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .clear_warning_result
.l4228 ; 4C:4228
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l4238
	ld hl, wTimerAWarnFlags
	bit 1, [hl]
	jr nz, .clear_warning_result
	set 1, [hl]
.l4238 ; 4C:4238
	ld hl, wTimerAWarnFlags
	set 0, [hl]
	ld hl, wTimerAWarnMinute
	ld a, [hl]
	cp a, $45
	jr z, .l424D
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l424D

.clear_warning_result ; 4C:424C
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 4132-4251 by apply_coverage
	; --split [executed in 3 scenarios]
	xor a, a
.l424D ; 4C:424D
	pop hl
	or a, a
	jr nz, Browser_LoadPage_ExitConnectionNotice

Browser_LoadPage_ExitCancelled:: ; 4C:4251
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

Browser_LoadPage_ExitConnectionNotice_FinishProgress:: ; 4C:4274
	; [PROBABLE] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 4;
	; entered by jrcc from 4C:427D (PROBABLE code)
	ld a, $01
	farcall CommProgress_Step
	or a, a
	jr nz, Browser_LoadPage_ExitConnectionNotice_FinishProgress

Browser_LoadPage_ExitConnectionNotice:: ; 4C:427F
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	farcall Sprite_ResetAll
	ld a, $06
	ld [wBrowserFetchResult], a
	ret

Browser_LoadPage_Http:: ; 4C:4291
	; [CONFIRMED] 28 insn(s); 28 executed (in up to 4/18 scenarios)
	ld de, wBrowserUrlSave
	ld hl, wAttrUrlBuf
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
	jp nz, Browser_LoadPage_OnAdapterError
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
	dw Browser_LoadPage_AskConnect
	dw Browser_LoadPage_AskPassword

Browser_LoadPage_AskConnect:: ; 4C:42F7
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	ld d, $4C
	ld bc, Data_BrowserLoadPage_ConnectDialogArgs
	farcall ConnectDialog_Run
	ld a, b
	or a, a
	jp nz, Browser_LoadPage_ExitCancelled
	jp Browser_LoadPage_Connect

; ---- data $430A-$4312 (8 bytes) [PROBABLE] bounded ConnectDialog_Run argument storage
; Passed as D=$4C, BC=$430A at 4C:42F7; the far call is at 4C:42FC.
; Mode +0 read in 19/69 scenarios; destination +3..5 read in 18/69, via ReadByteFar.
; Bytes +1..2 and +6..7 remain unread; generic mode4's +6 input is unentered for this object.
; WriteByteFar ignores the bank argument for this fixed-WRAM destination (H=$C2); no sentinel.

Data_BrowserLoadPage_ConnectDialogArgs:: ; 4C:430A
	db $03 ; initial dialog mode
	db $00, $00 ; uninterpreted, unread bytes +1..2
	db $F0 ; destination bank argument; ignored on the fixed-WRAM write path
	dw $C220 ; little-endian destination consumed by ConnectDialog_Run_Accept
	db $00, $00 ; unread +6..7; the generic mode4 input at +6 is not entered here

Browser_LoadPage_AskPassword:: ; 4C:4312
	; [CONFIRMED] 181 insn(s); 181 executed (in up to 3/18 scenarios)
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	farcall PasswordPrompt_Ask
	or a, a
	jp z, Browser_LoadPage_ExitCancelled
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
	ld hl, wBrowserTimerLastSec
	ld [hli], a
	ld [hl], a
	ld hl, wTimerAFrames
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $09
	ld [wTimerAWarnMinute], a
	xor a, a
	ld [wTimerAWarnFlags], a
	farcall Mobile_SessionInit
.poll_connect_after_session_init ; 4C:435F
	farcall Mobile_ConnectPoll
	or a, a
	jr z, .l437D
	cp a, $FF
	jp z, Browser_LoadPage_Fail
	ld a, $00
	farcall CommProgress_Step
	cp a, $02
	jp z, Browser_LoadPage_CancelConnect
	jp .poll_connect_after_session_init
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
	ld de, wRam_C240
	farcall Dial_CopySelectedNumber
.l439B ; 4C:439B
	ld hl, wMobilePassword
	farcall Mobile_BeginConnect
.poll_connect_after_begin_connect ; 4C:43A4
	farcall Mobile_ConnectPoll
	or a, a
	jr z, .l43C2
	cp a, $FF
	jp z, Browser_LoadPage_Fail
	ld a, $00
	farcall CommProgress_Step
	cp a, $02
	jp z, Browser_LoadPage_CancelConnect
	jp .poll_connect_after_begin_connect
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
	ld de, wAttrUrlBuf
	ld hl, wBrowserUrlSave
	ld bc, $0100
	call CopyBytes
	ld de, wBrowserPageUrl
	ld hl, wBrowserUrlSave
	ld bc, $0100
	call CopyBytes
	call Sound_FrameService
	ld a, [wBrowserLoginPostFlagLo]
	ld c, a
	ld a, [wBrowserLoginPostFlagHi]
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
	ld [wBrowserPost_BodyLengthLo], a
	ld a, b
	ld [wRam_C243], a
	ld a, $05
	ld [wCommTimeoutMinutes], a
	ld hl, wTimerBFrames
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wAttrUrlBuf
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
	ld hl, wTimerBFrames
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wAttrUrlBuf
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
	jr z, Browser_LoadPage_WaitReply_ReplyComplete
	cp a, $FF
	jp z, Browser_LoadPage_Fail
	ld a, $00
	farcall CommProgress_Step
	cp a, $02
	jp z, Browser_LoadPage_StopRequest
	ld a, [wCommTimeoutMinutes]
	ld b, a
	ld a, [wTimerBMinutes]
	cp a, b
	jr z, .set_a_ff_for_timeout_check
	xor a, a
	jr .l44E4

.set_a_ff_for_timeout_check ; 4C:44E2
	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by jrcc from 4C:44DD (executed)
	ld a, $FF

.l44E4 ; 4C:44E4
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 2/18 scenarios)
	or a, a
	jp nz, Browser_LoadPage_WaitReply_TimeoutError

Browser_LoadPage_WaitReply_CheckWarning:: ; 4C:44E8
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .clear_warning_result
	ld hl, wTimerAWarnFlags
	bit 0, [hl]
	jr nz, .l452F
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .clear_warning_result

	; [CONFIRMED] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 0;
	; fall-through of the jrcc at 4C:44FF (executed) | 4 insn(s) executed; cut out of the PROBABLE
	; region 4501-452E by apply_coverage --split [executed in 2 scenarios]
	jr nz, .l450A
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .clear_warning_result

.l450A ; 4C:450A
	; [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4501-452E by apply_coverage --split
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l451A
	ld hl, wTimerAWarnFlags
	bit 1, [hl]
	jr nz, .clear_warning_result
	set 1, [hl]
.l451A ; 4C:451A
	ld hl, wTimerAWarnFlags
	set 0, [hl]
	ld hl, wTimerAWarnMinute
	ld a, [hl]
	cp a, $45
	jr z, .l452F
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l452F

.clear_warning_result ; 4C:452E
	; [CONFIRMED] 28 insn(s); 28 executed (in up to 2/18 scenarios)
	xor a, a
.l452F ; 4C:452F
	pop hl
	or a, a
	jp nz, Browser_LoadPage_StopRequest
	jp Browser_LoadPage_WaitReply

Browser_LoadPage_WaitReply_ReplyComplete:: ; 4C:4537
	farcall Browser_WrapImageInHtml
	or a, a
	jr nz, .dispatch_fetch_result
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
	jr z, .dispatch_fetch_result
	farcall Browser_FetchInlineImages
.dispatch_fetch_result ; 4C:4577
	ld a, [wBrowserFetchResult]
	call JumpTableInline

; ---- ptrtable $457D-$458B (14 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4C:457A: 7 entries; end is a heuristic guess (words stay plausible code pointers)

Browser_LoadPage_WaitReply_ResultTable:: ; 4C:457D
	dw Browser_LoadPage_WaitReply_ResultOk
	dw Browser_LoadPage_StopRequest
	dw Browser_LoadPage_StopRequest
	dw Browser_LoadPage_Fail
	dw Browser_LoadPage_Fail
	dw Browser_LoadPage_Fail
	dw Browser_LoadPage_StopRequest

Browser_LoadPage_WaitReply_TimeoutError:: ; 4C:458B
	; [PROBABLE] 55 insn(s) reached by static flow only; seeds: exec x55; min discovery hops 1;
	; entered by jpcc from 4C:44E5 (executed)
	ld a, [wTimerEnable]
	bit 0, a
	jp z, Browser_LoadPage_WaitReply_CheckWarning
	farcall Mobile_BeginStop
.poll_stop ; 4C:4599
	farcall Mobile_StopPoll
	or a, a
	jr z, .l45B2
	cp a, $FF
	jp z, Browser_LoadPage_Fail
	ld a, $00
	farcall CommProgress_Step
	jp .poll_stop
.l45B2 ; 4C:45B2
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .clear_warning_result
	ld hl, wTimerAWarnFlags
	bit 0, [hl]
	jr nz, .l45F9
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .clear_warning_result
	jr nz, .l45D4
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .clear_warning_result
.l45D4 ; 4C:45D4
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l45E4
	ld hl, wTimerAWarnFlags
	bit 1, [hl]
	jr nz, .clear_warning_result
	set 1, [hl]
.l45E4 ; 4C:45E4
	ld hl, wTimerAWarnFlags
	set 0, [hl]
	ld hl, wTimerAWarnMinute
	ld a, [hl]
	cp a, $45
	jr z, .l45F9
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l45F9
.clear_warning_result ; 4C:45F8
	xor a, a
.l45F9 ; 4C:45F9
	pop hl
	or a, a
	jp nz, Browser_LoadPage_ExitConnectionNotice_FinishProgress
	ld a, $26
	ld [wMobileResultCode], a
	xor a, a
	ld [wMobileResultDetail], a
	ld [wMobileResultDetail + 1], a
	jp Browser_LoadPage_Fail

Browser_LoadPage_WaitReply_ResultOk:: ; 4C:460D
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ld a, [wCommSessionKind]
	cp a, $01
	jr nz, .step_progress_until_zero

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 4C:4612 (executed) [executed in 1 scenarios]
	farcall Html_ParsePage
	ld a, [wBrowserFetchResult]
	cp a, $04
	jp z, Browser_LoadPage_Fail

.step_progress_until_zero ; 4C:4622
	; [CONFIRMED] 22 insn(s); 22 executed (in up to 1/18 scenarios)
	ld a, $01
	farcall CommProgress_Step
	or a, a
	jr nz, .step_progress_until_zero
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
	jr z, .clear_warning_result
	ld hl, wTimerAWarnFlags
	bit 0, [hl]
	jr nz, .l4685
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .clear_warning_result

	; [CONFIRMED] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 0;
	; fall-through of the jrcc at 4C:4655 (executed) | 4 insn(s) executed; cut out of the PROBABLE
	; region 4657-4684 by apply_coverage --split [executed in 2 scenarios]
	jr nz, .l4660
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .clear_warning_result

.l4660 ; 4C:4660
	; [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4657-4684 by apply_coverage --split
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l4670
	ld hl, wTimerAWarnFlags
	bit 1, [hl]
	jr nz, .clear_warning_result
	set 1, [hl]
.l4670 ; 4C:4670
	ld hl, wTimerAWarnFlags
	set 0, [hl]
	ld hl, wTimerAWarnMinute
	ld a, [hl]
	cp a, $45
	jr z, .l4685
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l4685

.clear_warning_result ; 4C:4684
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	xor a, a
.l4685 ; 4C:4685
	pop hl
	or a, a
	jp nz, Browser_LoadPage_ExitConnectionNotice
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

	; [CONFIRMED] 14 insn(s); 14 executed (in up to 3/18 scenarios); entry proven: target of an
	; executed call/far call (part of region $46A6-$46C0)
	call Sound_FrameService
	ld hl, wAttrUrlBuf
.scan_for_fragment_or_nul ; 4C:46AC
	ld a, [hli]
	cp a, $23
	jr z, .terminate_at_fragment_or_nul
	or a, a
	jr nz, .scan_for_fragment_or_nul
.terminate_at_fragment_or_nul ; 4C:46B4
	dec hl
	xor a, a
	ld [hli], a
	ret
