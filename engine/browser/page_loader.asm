; engine/browser/page_loader.asm
; bank 4C, $4000-$46B8 (1720 bytes); pinned by layout.link
; Browser_LoadPage: URL -> connect -> HTTP GET -> scan/layout

SECTION "engine/browser/page_loader", ROMX

; ---- code $4000-$4010 (16 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 4/18 scenarios); entry proven: target of an executed call/far call

Browser_LoadPage:: ; 4C:4000
Function_4C_4000::
	ld hl, $C380
	farcall HtmlUrl_GetSchemeId
	cp a, $FF
	jr z, Browser_LoadPage_Fail
	call JumpTableInline

; ---- ptrtable $4010-$4016 (6 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4C:400D: 3 entries; end = first entry target

Table_4C_4010:: ; 4C:4010
	dw Browser_LoadPage_Fail
	dw Browser_LoadPage_Http
	dw Label_4C_4016

; ---- code $4016-$404D (55 bytes) [PROBABLE] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 1; entered by table from 4C:400D (executed)

Label_4C_4016:: ; 4C:4016
	ret

Label_4C_4017:: ; 4C:4017
	farcall Mobile_FetchResult

Label_4C_401D:: ; 4C:401D
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [wMobileResultDetail]
	ld [wRam_C273], a
	ld a, [wMobileResultDetail + 1]
	ld [wRam_C274], a
	ld a, [wMobileResultCode]
	ld [wMobileErrorCode], a
	ld a, $09
	ld [wRam_C26E], a
	xor a, a
	ld [wRam_C26F], a
	farcall Palette_FadeOutToWhite
	farcall Function_00_09B6
	jp Label_4C_40E4

; ---- code $404D-$406F (34 bytes) [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)

Browser_LoadPage_Fail:: ; 4C:404D
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [wMobileResultDetail]
	ld [wRam_C273], a
	ld a, [wMobileResultDetail + 1]
	ld [wRam_C274], a
	ld a, [wMobileResultCode]
	ld [wMobileErrorCode], a
	farcall Browser_MapErrorToResult
	and a, $80
	jr z, Label_4C_40D3

; ---- code $406F-$4076 (7 bytes) [CONFIRMED] 31 insn(s) reached by static flow only; seeds: exec x31; min discovery hops 0; fall-through of the jrcc at 4C:406D (executed) | 3 insn(s) executed; cut out of the PROBABLE region 406F-40D3 by apply_coverage --split [executed in 1 scenarios]
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_4C_40B4

; ---- code $4076-$40B4 (62 bytes) [PROBABLE] 18 insn(s) never executed in the traced runs; cut out of the PROBABLE region 406F-40D3 by apply_coverage --split
	farcall Mobile_BeginDisconnect

Label_4C_407C:: ; 4C:407C
	farcall Mobile_DisconnectPoll
	or a, a
	jr z, Label_4C_40D3
	cp a, $FF
	jp z, Label_4C_4095
	ld a, $00
	farcall CommProgress_Step
	jp Label_4C_407C

Label_4C_4095:: ; 4C:4095
	farcall Mobile_BeginCancel

Label_4C_409B:: ; 4C:409B
	farcall Mobile_CancelPoll
	or a, a
	jr z, Label_4C_40D3
	cp a, $FF
	jp z, Label_4C_40D3
	ld a, $00
	farcall CommProgress_Step
	jp Label_4C_409B

; ---- code $40B4-$40BC (8 bytes) [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 406F-40D3 by apply_coverage --split [executed in 1 scenarios]

Label_4C_40B4:: ; 4C:40B4
	ld a, [wTimerEnable]
	bit 1, a
	jp z, Label_4C_40C2

; ---- code $40BC-$40C2 (6 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 406F-40D3 by apply_coverage --split
	farcall Mobile_FetchResult

; ---- code $40C2-$40D3 (17 bytes) [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 406F-40D3 by apply_coverage --split [executed in 1 scenarios]

Label_4C_40C2:: ; 4C:40C2
	ld a, $36
	farcall MobileAPI
	ld a, $09
	ld [wRam_C26E], a
	xor a, a
	ld [wRam_C26F], a

; ---- code $40D3-$40DB (8 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)

Label_4C_40D3:: ; 4C:40D3
	ld a, [wTimerEnable]
	bit 4, a
	jp nz, Label_4C_40E4

; ---- code $40DB-$40E4 (9 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jpcc at 4C:40D8 (executed) [executed in 1 scenarios]
	ld a, $09
	ld [wRam_C26E], a
	xor a, a
	ld [wRam_C26F], a

; ---- code $40E4-$4111 (45 bytes) [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)

Label_4C_40E4:: ; 4C:40E4
	farcall Function_68_73DD
	ld a, [wCommSessionKind]
	xor a, $01
	ld [wRam_C1D0], a
	ld a, [wCommSessionKind]
	ld [wRam_C1D1], a
	farcall Mobile_ShowLastError
	farcall Function_4E_4866
	farcall Function_00_09B6
	ld a, [wMobileErrorCode]
	cp a, $33
	jr nz, Label_4C_4123

; ---- code $4111-$4123 (18 bytes) [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0; fall-through of the jrcc at 4C:410F (executed)
	ld a, [wRam_C274]
	cp a, $01
	jr nz, Label_4C_4123
	ld a, [wRam_C273]
	cp a, $01
	jr z, Label_4C_4132
	cp a, $02
	jr z, Label_4C_4132

; ---- code $4123-$4132 (15 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)

Label_4C_4123:: ; 4C:4123
	ld a, [wMobileErrorCode]
	farcall Browser_MapErrorToResult
	and a, $7F
	ld [wBrowserFetchResult], a
	ret

; ---- code $4132-$4138 (6 bytes) [PROBABLE] 110 insn(s) reached by static flow only; seeds: exec x110; min discovery hops 1; entered by jrcc from 4C:411D (PROBABLE code) | 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4132-4251 by apply_coverage --split

Label_4C_4132:: ; 4C:4132
	ld a, $00
	ld [wBrowserFetchResult], a
	ret

; ---- code $4138-$41D4 (156 bytes) [CONFIRMED] 55 insn(s) executed; cut out of the PROBABLE region 4132-4251 by apply_coverage --split [executed in 3 scenarios]

Label_4C_4138:: ; 4C:4138
	farcall Mobile_BeginCancel

Label_4C_413E:: ; 4C:413E
	farcall Mobile_CancelPoll
	or a, a
	jr z, Label_4C_4157
	cp a, $FF
	jp z, Label_4C_401D
	ld a, $00
	farcall CommProgress_Step
	jp Label_4C_413E

Label_4C_4157:: ; 4C:4157
	ld a, $01
	farcall CommProgress_Step
	or a, a
	jr nz, Label_4C_4157
	ld a, $09
	ld [wRam_C26E], a
	xor a, a
	ld [wRam_C26F], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	farcall Function_00_09B6
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

Label_4C_418F:: ; 4C:418F
	farcall Mobile_StopPoll
	or a, a
	jr z, Label_4C_41A8
	cp a, $FF
	jp z, Browser_LoadPage_Fail
	ld a, $00
	farcall CommProgress_Step
	jp Label_4C_418F

Label_4C_41A8:: ; 4C:41A8
	ld a, [wBrowserFetchActive]
	or a, a
	jr z, Label_4C_41FB
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_4C_41F3
	farcall Mobile_BeginDisconnect

Label_4C_41BB:: ; 4C:41BB
	farcall Mobile_DisconnectPoll
	or a, a
	jr z, Label_4C_41FB
	cp a, $FF
	jp z, Label_4C_41D4
	ld a, $00
	farcall CommProgress_Step
	jp Label_4C_41BB

; ---- code $41D4-$41FB (39 bytes) [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4132-4251 by apply_coverage --split

Label_4C_41D4:: ; 4C:41D4
	farcall Mobile_BeginCancel

Label_4C_41DA:: ; 4C:41DA
	farcall Mobile_CancelPoll
	or a, a
	jr z, Label_4C_41FB
	cp a, $FF
	jp z, Label_4C_41FB
	ld a, $00
	farcall CommProgress_Step
	jp Label_4C_41DA

Label_4C_41F3:: ; 4C:41F3
	ld a, $36
	farcall MobileAPI

; ---- code $41FB-$421F (36 bytes) [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 4132-4251 by apply_coverage --split [executed in 2 scenarios]

Label_4C_41FB:: ; 4C:41FB
	ld a, $01
	farcall CommProgress_Step
	or a, a
	jr nz, Label_4C_41FB
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_4C_424C
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_4C_424D
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_4C_424C

; ---- code $421F-$424C (45 bytes) [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4132-4251 by apply_coverage --split
	jr nz, Label_4C_4228
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_4C_424C

Label_4C_4228:: ; 4C:4228
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_4C_4238
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_4C_424C
	set 1, [hl]

Label_4C_4238:: ; 4C:4238
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_4C_424D
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_4C_424D

; ---- code $424C-$4251 (5 bytes) [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 4132-4251 by apply_coverage --split [executed in 3 scenarios]

Label_4C_424C:: ; 4C:424C
	xor a, a

Label_4C_424D:: ; 4C:424D
	pop hl
	or a, a
	jr nz, Label_4C_427F

; ---- code $4251-$4274 (35 bytes) [CONFIRMED] 14 insn(s); 14 executed (in up to 2/18 scenarios)

Label_4C_4251:: ; 4C:4251
	ld a, [wTimerEnable]
	bit 4, a
	jp nz, Label_4C_4262
	ld a, $09
	ld [wRam_C26E], a
	xor a, a
	ld [wRam_C26F], a

Label_4C_4262:: ; 4C:4262
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	farcall Function_00_09B6
	ld a, $02
	ld [wBrowserFetchResult], a
	ret

; ---- code $4274-$4291 (29 bytes) [PROBABLE] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 4; entered by jrcc from 4C:427D (PROBABLE code)

Label_4C_4274:: ; 4C:4274
	ld a, $01
	farcall CommProgress_Step
	or a, a
	jr nz, Label_4C_4274

Label_4C_427F:: ; 4C:427F
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	farcall Function_00_09B6
	ld a, $06
	ld [wBrowserFetchResult], a
	ret

; ---- code $4291-$42F3 (98 bytes) [CONFIRMED] 28 insn(s); 28 executed (in up to 4/18 scenarios)

Browser_LoadPage_Http:: ; 4C:4291
	ld de, $D400
	ld hl, $C380
	ld bc, $0100
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call CopyBytes
	ld a, [wBrowserNavigating]
	or a, a
	jr z, Label_4C_42B5
	farcall Browser_HistoryPush
	farcall PageCache_Push

Label_4C_42B5:: ; 4C:42B5
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_4C_42E1
	bit 1, a
	jp nz, Label_4C_4017
	farcall Palette_FadeOutToWhite
	farcall Function_00_09B6
	ld a, $01
	farcall CommProgress_Init
	ld a, $00
	farcall CommProgress_Step
	jp Browser_LoadPage_Request

Label_4C_42E1:: ; 4C:42E1
	farcall Palette_FadeOutToWhite
	farcall Function_00_09B6
	ld a, [wCommSessionKind]
	call JumpTableInline

; ---- ptrtable $42F3-$42F7 (4 bytes) [CONFIRMED] inline table of `call $0545` (JumpTableInline) at 4C:42F0: 2 entries; end pinned by the executed instruction at 42F7; every byte read as data in a trace

Table_4C_42F3:: ; 4C:42F3
	dw Label_4C_42F7
	dw Label_4C_4312

; ---- code $42F7-$430A (19 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)

Label_4C_42F7:: ; 4C:42F7
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

; ---- code $4312-$44E2 (464 bytes) [CONFIRMED] 181 insn(s); 181 executed (in up to 3/18 scenarios)

Label_4C_4312:: ; 4C:4312
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
	ld [wRam_C26E], a
	xor a, a
	ld [wRam_C26F], a
	farcall Mobile_SessionInit

Label_4C_435F:: ; 4C:435F
	farcall Mobile_ConnectPoll
	or a, a
	jr z, Label_4C_437D
	cp a, $FF
	jp z, Browser_LoadPage_Fail
	ld a, $00
	farcall CommProgress_Step
	cp a, $02
	jp z, Label_4C_4138
	jp Label_4C_435F

Label_4C_437D:: ; 4C:437D
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [wRam_C2C4]
	ld c, a
	or a, a
	jr nz, Label_4C_439B
	ld de, $C240
	farcall Function_00_1586

Label_4C_439B:: ; 4C:439B
	ld hl, $C220
	farcall Mobile_BeginConnect

Label_4C_43A4:: ; 4C:43A4
	farcall Mobile_ConnectPoll
	or a, a
	jr z, Label_4C_43C2
	cp a, $FF
	jp z, Browser_LoadPage_Fail
	ld a, $00
	farcall CommProgress_Step
	cp a, $02
	jp z, Label_4C_4138
	jp Label_4C_43A4

Label_4C_43C2:: ; 4C:43C2
	ld a, $01
	ld [wCommSessionActive], a
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a

Browser_LoadPage_Request:: ; 4C:43CD
	call Function_00_0392
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
	call Function_00_0392
	ld a, [wRam_C2C5]
	ld c, a
	ld a, [wRam_C2C6]
	or a, c
	jr z, Label_4C_4467
	ld a, c
	ld a, $00
	ld [wRam_C240], a
	ld a, $A0
	ld [wRam_C241], a
	call Function_00_0392
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld bc, $1000
	ld hl, $B000
	ld a, $03
	call BankSwitch_H
	xor a, a
	call FillBytes
	call Function_00_0392
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
	ld de, $B000
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

Label_4C_4467:: ; 4C:4467
	call Function_00_0392
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld bc, $1000
	ld hl, $B000
	ld a, $03
	call BankSwitch_H
	xor a, a
	call FillBytes
	call Function_00_0392
	call Url_StripFragment
	ld a, $05
	ld [wCommTimeoutMinutes], a
	ld hl, $C266
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, $C380
	ld de, $B000
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
	jr z, Label_4C_44E2
	xor a, a
	jr Label_4C_44E4

; ---- code $44E2-$44E4 (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1; entered by jrcc from 4C:44DD (executed)

Label_4C_44E2:: ; 4C:44E2
	ld a, $FF

; ---- code $44E4-$4501 (29 bytes) [CONFIRMED] 14 insn(s); 14 executed (in up to 2/18 scenarios)

Label_4C_44E4:: ; 4C:44E4
	or a, a
	jp nz, Label_4C_458B

Label_4C_44E8:: ; 4C:44E8
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_4C_452E
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_4C_452F
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_4C_452E

; ---- code $4501-$450A (9 bytes) [CONFIRMED] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 0; fall-through of the jrcc at 4C:44FF (executed) | 4 insn(s) executed; cut out of the PROBABLE region 4501-452E by apply_coverage --split [executed in 2 scenarios]
	jr nz, Label_4C_450A
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_4C_452E

; ---- code $450A-$452E (36 bytes) [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4501-452E by apply_coverage --split

Label_4C_450A:: ; 4C:450A
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_4C_451A
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_4C_452E
	set 1, [hl]

Label_4C_451A:: ; 4C:451A
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_4C_452F
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_4C_452F

; ---- code $452E-$457D (79 bytes) [CONFIRMED] 28 insn(s); 28 executed (in up to 2/18 scenarios)

Label_4C_452E:: ; 4C:452E
	xor a, a

Label_4C_452F:: ; 4C:452F
	pop hl
	or a, a
	jp nz, Label_4C_417D
	jp Browser_LoadPage_WaitReply

Label_4C_4537:: ; 4C:4537
	farcall Browser_WrapImageInHtml
	or a, a
	jr nz, Label_4C_4577
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld de, $B000
	ld hl, $B000
	ld bc, $1000
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	farcall Charset_ConvertPage
	farcall Html_ScanPage
	ld a, [wHtmlFlags]
	and a, $01
	jr z, Label_4C_4577
	farcall Browser_FetchInlineImages

Label_4C_4577:: ; 4C:4577
	ld a, [wBrowserFetchResult]
	call JumpTableInline

; ---- ptrtable $457D-$458B (14 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4C:457A: 7 entries; end is a heuristic guess (words stay plausible code pointers)

Table_4C_457D:: ; 4C:457D
	dw Label_4C_460D
	dw Label_4C_417D
	dw Label_4C_417D
	dw Browser_LoadPage_Fail
	dw Browser_LoadPage_Fail
	dw Browser_LoadPage_Fail
	dw Label_4C_417D

; ---- code $458B-$460D (130 bytes) [PROBABLE] 55 insn(s) reached by static flow only; seeds: exec x55; min discovery hops 1; entered by jpcc from 4C:44E5 (executed)

Label_4C_458B:: ; 4C:458B
	ld a, [wTimerEnable]
	bit 0, a
	jp z, Label_4C_44E8
	farcall Mobile_BeginStop

Label_4C_4599:: ; 4C:4599
	farcall Mobile_StopPoll
	or a, a
	jr z, Label_4C_45B2
	cp a, $FF
	jp z, Browser_LoadPage_Fail
	ld a, $00
	farcall CommProgress_Step
	jp Label_4C_4599

Label_4C_45B2:: ; 4C:45B2
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_4C_45F8
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_4C_45F9
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_4C_45F8
	jr nz, Label_4C_45D4
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_4C_45F8

Label_4C_45D4:: ; 4C:45D4
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_4C_45E4
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_4C_45F8
	set 1, [hl]

Label_4C_45E4:: ; 4C:45E4
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_4C_45F9
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_4C_45F9

Label_4C_45F8:: ; 4C:45F8
	xor a, a

Label_4C_45F9:: ; 4C:45F9
	pop hl
	or a, a
	jp nz, Label_4C_4274
	ld a, $26
	ld [wMobileResultCode], a
	xor a, a
	ld [wMobileResultDetail], a
	ld [wMobileResultDetail + 1], a
	jp Browser_LoadPage_Fail

; ---- code $460D-$4614 (7 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)

Label_4C_460D:: ; 4C:460D
	ld a, [wCommSessionKind]
	cp a, $01
	jr nz, Label_4C_4622

; ---- code $4614-$4622 (14 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 4C:4612 (executed) [executed in 1 scenarios]
	farcall Html_ParsePage
	ld a, [wBrowserFetchResult]
	cp a, $04
	jp z, Browser_LoadPage_Fail

; ---- code $4622-$4657 (53 bytes) [CONFIRMED] 22 insn(s); 22 executed (in up to 1/18 scenarios)

Label_4C_4622:: ; 4C:4622
	ld a, $01
	farcall CommProgress_Step
	or a, a
	jr nz, Label_4C_4622
	ld a, [wCommSessionKind]
	cp a, $01
	jr z, Label_4C_463A
	farcall Html_ParsePage

Label_4C_463A:: ; 4C:463A
	xor a, a
	ld [wBrowserFetchResult], a
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_4C_4684
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_4C_4685
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_4C_4684

; ---- code $4657-$4660 (9 bytes) [CONFIRMED] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 0; fall-through of the jrcc at 4C:4655 (executed) | 4 insn(s) executed; cut out of the PROBABLE region 4657-4684 by apply_coverage --split [executed in 2 scenarios]
	jr nz, Label_4C_4660
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_4C_4684

; ---- code $4660-$4684 (36 bytes) [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4657-4684 by apply_coverage --split

Label_4C_4660:: ; 4C:4660
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_4C_4670
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_4C_4684
	set 1, [hl]

Label_4C_4670:: ; 4C:4670
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_4C_4685
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_4C_4685

; ---- code $4684-$4692 (14 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)

Label_4C_4684:: ; 4C:4684
	xor a, a

Label_4C_4685:: ; 4C:4685
	pop hl
	or a, a
	jp nz, Label_4C_427F
	ld a, [wTimerEnable]
	bit 4, a
	jp nz, Label_4C_469B

; ---- code $4692-$469B (9 bytes) [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jpcc at 4C:468F (executed)
	ld a, $09
	ld [wRam_C26E], a
	xor a, a
	ld [wRam_C26F], a

; ---- code $469B-$46A0 (5 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)

Label_4C_469B:: ; 4C:469B
	ld a, [wRam_C1DC]
	or a, a
	ret z

; ---- code $46A0-$46A6 (6 bytes) [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the retcc at 4C:469F (executed) [executed in 1 scenarios]
	ld a, $0C
	ld [wRam_C1DC], a
	ret

; ---- code $46A6-$46B8 (18 bytes) [CONFIRMED] 14 insn(s); 14 executed (in up to 3/18 scenarios); entry proven: target of an executed call/far call (part of region $46A6-$46C0)

Url_StripFragment:: ; 4C:46A6
Function_4C_46A6::
	call Function_00_0392
	ld hl, $C380

Label_4C_46AC:: ; 4C:46AC
	ld a, [hli]
	cp a, $23
	jr z, Label_4C_46B4
	or a, a
	jr nz, Label_4C_46AC

Label_4C_46B4:: ; 4C:46B4
	dec hl
	xor a, a
	ld [hli], a
	ret
