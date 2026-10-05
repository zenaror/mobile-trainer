; engine/settings/usage_time.asm
; bank 67, $60BA-$626F (437 bytes); pinned by layout.link
; usage time view (CGI request, login body)

SECTION "engine/settings/usage_time", ROMX

UsageTime_Run:: ; 67:60BA
Function_67_60BA::
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	xor a, a
	ld [wManualNumbersFlag], a
	ld a, $13
	farcall Notice_ShowPage
	or a, a
	ret z
	call UsageTime_Request
	or a, a
	jr z, .l60DD
	cp a, $02
	jr z, .l60F9

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 67:60D0 (executed)
	ld a, $02
	ld b, $00
	farcall Account_ResultPage
	ret

.l60DD ; 67:60DD
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 1/18 scenarios)
	farcall OnlineTimer_HasElapsed
	or a, a
	jr z, .l60FF
	ld a, $02
	ld b, $01
	farcall Account_ResultPage
	ld a, $14
	farcall Notice_ShowPage
	ret
.l60F9 ; 67:60F9
	ld a, [wRam_C28E]
	or a, a
	jr z, UsageTime_Run
.l60FF ; 67:60FF
	ld a, $14
	farcall Notice_ShowPage
	ret

	; [PROBABLE] 7 insn(s) reached by static flow only; seeds: site x7; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall OnlineTimer_HasElapsed
	or a, a
	jr z, .l60FF
	ld a, $02
	ld b, $02
	farcall Account_ResultPage
	ret

PasswordPrompt_Ask:: ; 67:611C
Function_67_611C::
	; [CONFIRMED] 67 insn(s); 67 executed (in up to 3/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wManualNumbersFlag]
	add a, $02
	farcall Account_ActionConfirmPage
	or a, a
	jr z, .l616F
	cp a, $02
	jr z, .l616F
	ld hl, $DED4
	farcall Wram3_ClearByte
	xor a, a
	farcall Account_PasswordEntryScreen
	or a, a
	jr z, PasswordPrompt_Ask
	ld hl, $DED4
	ld de, $DECB
	farcall Wram3_CopyString
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $DECB
	ld de, $C220
	call CopyString
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, $01
	ret
.l616F ; 67:616F
	xor a, a
	ret

UsageTime_Request:: ; 67:6171
	farcall Browser_BeginSession
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld hl, sNetWorkPage
	ld bc, $2000
	call FillBytes
	ld hl, Net_UsageTimeCgiUrl
	ld de, sNetStartUrl
	call CopyString
	ld de, $C28F
	farcall Dial_CopySelectedNumber
	ld a, $02
	farcall CommPanel_SetVariant
	ld bc, $0001
	ld d, $00
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	farcall Browser_LoadUrlFromSramBank3
	ld a, [wBrowserFetchResult]
	cp a, $02
	jr z, .l61CF
	or a, a
	jr nz, .l61CD

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 67:61C8 (executed)
	ld a, $01
	ret

.l61CD ; 67:61CD
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios)
	xor a, a
	ret
.l61CF ; 67:61CF
	ld a, $02
	ret

; ---- data $61D2-$6205 (51 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Net_UsageTimeCgiUrl:: ; 67:61D2
Data_67_61D2::
	db $68, $74, $74, $70, $3A, $2F, $2F, $6D, $67, $62, $2E, $64, $69, $6F, $6E, $2E
	db $6E, $65, $2E, $6A, $70, $2F, $63, $67, $69, $2D, $62, $69, $6E, $2F, $6D, $67
	db $62, $2F, $64, $61, $61, $5F, $67, $62, $5F, $6A, $69, $6B, $61, $6E, $2E, $63
	db $67, $69, $00

Net_BuildLoginPostBody:: ; 67:6205
Function_67_6205::
	; [CONFIRMED] 27 insn(s); 27 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, Net_PppIdKeyDup
	ld de, sNetWorkPage
	call CopyString
	ld hl, $C1E0
	ld de, sNetWorkPage
	call StringAppend
	ld hl, $624E
	ld de, sNetWorkPage
	call StringAppend
	ld hl, $DECB
	ld de, sNetWorkPage
	call StringAppend
	ld hl, sNetWorkPage
	call StringLength
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- data $6246-$624E (8 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 6246-6257 by higher-priority evidence]

Net_PppIdKeyDup:: ; 67:6246
Data_67_6246::
	db $50, $50, $50, $5F, $49, $44, $3D, $00

; ---- text $624E-$626F (33 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
Net_PasswdKeyDup:: ; 67:624E
String_67_624E::
	db "&PASSWD=", 0

Net_DebugLoginBody:: ; 67:6257
	db "PPP_ID=1002&PASSWD=itoh", 0
POPC
