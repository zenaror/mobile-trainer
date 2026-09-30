; engine/browser/session_start.asm
; bank 4E, $488D-$49A1 (276 bytes); pinned by layout.link
; home page / staged URL / SRAM URL session starters

SECTION "engine/browser/session_start", ROMX

Browser_LoadUrlFromSramBank3:: ; 4E:488D
	; [CONFIRMED] 48 insn(s); 48 executed (in up to 3/18 scenarios) (part of region $4886-$4904)
	ld a, c
	ld [wRam_C2C5], a
	ld a, b
	ld [wRam_C2C6], a
	ld a, d
	ld [wRam_C2C4], a
	ld a, $01
	ld [wCommSessionKind], a
	ld a, $00
	ld [wBrowserFrameStyle], a
	ld a, $FF
	ld [wBrowserScrollbarEnable], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, $A100
	ld de, $C380
	farcall CopyString
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	jp Browser_LoadAndDispatch

Browser_LoadHomePage:: ; 4E:48CB
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall Settings_GetSelectedDialEntry
	ld a, b
	inc a
	ld [wRam_C2C4], a
	xor a, a
	ld [wRam_C2C5], a
	ld [wRam_C2C6], a
	ld a, $01
	ld [wBrowserFrameStyle], a
	ld a, $FF
	ld [wBrowserScrollbarEnable], a
	farcall Joypad_UpdateUnsaved
	ld hl, String_Browser_HomeUrl
	ld de, $C380
	farcall CopyString
	jp Browser_LoadAndDispatch

; ---- data $4904-$493B (55 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

String_Browser_HomeUrl:: ; 4E:4904
Data_4E_4904::
	db $68, $74, $74, $70, $3A, $2F, $2F, $67, $61, $6D, $65, $62, $6F, $79, $2E, $64
	db $61, $74, $61, $63, $65, $6E, $74, $65, $72, $2E, $6E, $65, $2E, $6A, $70, $2F
	db $30, $31, $2F, $43, $47, $42, $2D, $42, $39, $41, $4A, $2F, $69, $6E, $64, $65
	db $78, $2E, $68, $74, $6D, $6C, $00

Browser_LoadStagedUrl:: ; 4E:493B
	; [CONFIRMED] 15 insn(s) reached by static flow only; seeds: exec x15; min discovery hops 2;
	; entered by far from 4F:470E (PROBABLE code) [executed in 1 scenarios]
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall Settings_GetSelectedDialEntry
	ld a, b
	inc a
	ld [wRam_C2C4], a
	xor a, a
	ld [wRam_C2C5], a
	ld [wRam_C2C6], a
	ld a, $01
	ld [wBrowserFrameStyle], a
	ld a, $FF
	ld [wBrowserScrollbarEnable], a
	jp Browser_LoadAndDispatch

Browser_LoadAndDispatch:: ; 4E:4962
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 4/18 scenarios)
	farcall Browser_ClearCaches
	farcall Browser_HistoryReset
	xor a, a
	ld [wBrowserFetchResult], a
	ld [wBrowserNavigating], a
	ld [wRam_C1DC], a
	ld a, $01
	ld [wBrowserFetchActive], a
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	farcall Browser_LoadPage
	xor a, a
	ld [wBrowserFetchActive], a
	ld a, [wBrowserFetchResult]
	call JumpTableInline

; ---- ptrtable $4993-$49A1 (14 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4E:4990: 7 entries; end pinned by the executed instruction at 49A1

Browser_LoadAndDispatch_ResultTable:: ; 4E:4993
Table_4E_4993::
	dw Browser_PageView_Enter
	dw Browser_Leave_Return
	dw Browser_Leave_Return
	dw Browser_Leave_OnError
	dw Browser_Leave_OnError
	dw Browser_Leave_OnError
	dw Browser_Leave_OnError
