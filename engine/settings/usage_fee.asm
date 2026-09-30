; engine/settings/usage_fee.asm
; bank 67, $626F-$6369 (250 bytes); pinned by layout.link
; usage fee view (CGI request)

SECTION "engine/settings/usage_fee", ROMX

; ---- code $626F-$628B (28 bytes) [CONFIRMED] 11 insn(s); 11 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

UsageFee_Run:: ; 67:626F
Function_67_626F::
	ld a, $01
	ld [wManualNumbersFlag], a

Label_67_6274:: ; 67:6274
	ld a, $15
	farcall Notice_ShowPage
	or a, a
	ret z
	farcall UsageFee_Request
	or a, a
	jr z, Label_67_6296
	cp a, $02
	jr z, Label_67_62B2

; ---- code $628B-$6296 (11 bytes) [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 67:6289 (executed)
	ld a, $03
	ld b, $00
	farcall Account_ResultPage
	ret

; ---- code $6296-$62B8 (34 bytes) [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)

Label_67_6296:: ; 67:6296
	farcall OnlineTimer_HasElapsed
	or a, a
	jr z, Label_67_62B8
	ld a, $03
	ld b, $01
	farcall Account_ResultPage
	ld a, $16
	farcall Notice_ShowPage
	ret

Label_67_62B2:: ; 67:62B2
	ld a, [wRam_C28E]
	or a, a
	jr z, Label_67_6274

; ---- code $62B8-$62C1 (9 bytes) [CONFIRMED] 10 insn(s) reached by static flow only; seeds: exec x3, site x7; min discovery hops 0; entered by jrcc from 67:629D (executed) | 3 insn(s) executed; cut out of the PROBABLE region 62B8-62D5 by apply_coverage --split [executed in 5 scenarios]

Label_67_62B8:: ; 67:62B8
	ld a, $16
	farcall Notice_ShowPage
	ret

; ---- code $62C1-$62D5 (20 bytes) [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region 62B8-62D5 by apply_coverage --split
	farcall OnlineTimer_HasElapsed
	or a, a
	jr z, Label_67_62B8
	ld a, $03
	ld b, $02
	farcall Account_ResultPage
	ret

; ---- code $62D5-$6325 (80 bytes) [CONFIRMED] 30 insn(s); 30 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

UsageFee_Request:: ; 67:62D5
Function_67_62D5::
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
	ld hl, $A000
	ld bc, $2000
	call FillBytes
	ld hl, Net_UsageFeeUrl
	ld de, $A100
	call CopyString
	ld a, $03
	farcall CommPanel_SetVariant
	ld bc, $0000
	ld d, $01
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	farcall Browser_LoadUrlFromSramBank3
	ld a, [wBrowserFetchResult]
	cp a, $02
	jr z, Label_67_632A
	or a, a
	jr nz, Label_67_6328

; ---- code $6325-$6328 (3 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 67:6323 (executed)
	ld a, $01
	ret

; ---- code $6328-$632D (5 bytes) [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios)

Label_67_6328:: ; 67:6328
	xor a, a
	ret

Label_67_632A:: ; 67:632A
	ld a, $02
	ret

; ---- data $632D-$6369 (60 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Net_UsageFeeUrl:: ; 67:632D
Data_67_632D::
	db $68, $74, $74, $70, $3A, $2F, $2F, $67, $61, $6D, $65, $62, $6F, $79, $2E, $64
	db $61, $74, $61, $63, $65, $6E, $74, $65, $72, $2E, $6E, $65, $2E, $6A, $70, $2F
	db $63, $67, $62, $2F, $75, $74, $69, $6C, $69, $74, $79, $3F, $72, $65, $71, $75
	db $65, $73, $74, $3D, $73, $75, $6D, $6D, $61, $72, $79, $00
