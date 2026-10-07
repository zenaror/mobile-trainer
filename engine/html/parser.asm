; engine/html/parser.asm
; bank 74, $4165-$44A0 (827 bytes); pinned by layout.link
; Html_ParsePage/ScanPage/ParseSource

SECTION "engine/html/parser", ROMX

Html_MetaResultToError:: ; 74:4165
Function_74_4165::
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wHtmlMetaRCode
	ld bc, Html_ResultCodePtrs
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	call Html_MatchKeyword
	cp a, $00
	jp z, Html_MetaResultToError_NoError

	; [PROBABLE] 63 insn(s) reached by static flow only; seeds: exec x63; min discovery hops 0;
	; fall-through of the jpcc at 74:417C (executed)
	cp a, $02
	jp z, Html_MetaResultToError_NoError
	ld hl, wHtmlMetaDCode
	xor a, a
	ldh [hRam_FFB0], a
	ldh [hRam_FFB1], a
	ldh [hHtmlMeta_HexByte2], a
	ldh [hHtmlMeta_HexByte3], a

Html_MetaResultToError_HexLoop:: ; 74:4190
	ld a, [hli]
	or a, a
	jp z, Html_MetaResultToError_SetError
	cp a, $30
	jr c, Html_MetaResultToError_HexLoop
	cp a, $3A
	jr c, .l41B5
	cp a, $41
	jr c, Html_MetaResultToError_HexLoop
	cp a, $47
	jr c, .l41B1
	cp a, $61
	jr c, Html_MetaResultToError_HexLoop
	cp a, $67
	jr nc, Html_MetaResultToError_HexLoop
	sub a, $61
	jr .l41B7
.l41B1 ; 74:41B1
	sub a, $41
	jr .l41B7
.l41B5 ; 74:41B5
	sub a, $30
.l41B7 ; 74:41B7
	ld c, a
	ldh a, [hHtmlMeta_HexByte0]
	swap a
	ld b, a
	and a, $F0
	or a, c
	ldh [hHtmlMeta_HexByte0], a
	ld a, b
	and a, $0F
	ld c, a
	ldh a, [hHtmlMeta_HexByte1]
	swap a
	ld b, a
	and a, $F0
	or a, c
	ldh [hHtmlMeta_HexByte1], a
	ld a, b
	and a, $0F
	ld c, a
	ldh a, [hHtmlMeta_HexByte2]
	swap a
	ld b, a
	and a, $F0
	or a, c
	ldh [hHtmlMeta_HexByte2], a
	ld a, b
	and a, $0F
	ld c, a
	ldh a, [hHtmlMeta_HexByte3]
	swap a
	ld b, a
	and a, $F0
	or a, c
	ldh [hHtmlMeta_HexByte3], a
	jp Html_MetaResultToError_HexLoop

Html_MetaResultToError_NoError:: ; 74:41EF
Label_74_41EF::
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 2/18 scenarios)
	ld a, $00
	ret

Html_MetaResultToError_SetError:: ; 74:41F2
Label_74_41F2::
	; [PROBABLE] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 1;
	; entered by jpcc from 74:4192 (PROBABLE code)
	ld a, $04
	ld [wBrowserFetchResult], a
	ld a, $40
	ld [wMobileResultCode], a
	ldh a, [hHtmlMeta_HexByte0]
	ld [wMobileResultDetail], a
	ldh a, [hHtmlMeta_HexByte1]
	ld [wMobileResultDetail + 1], a
	ret

Html_ParsePage:: ; 74:4207
Function_74_4207::
	; [CONFIRMED] 114 insn(s); 114 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld bc, $0000
	ld de, $0000
	farcall Browser_SetScroll
	ld bc, $0090
	ld de, $0060
	farcall Browser_SetViewport
	xor a, a
	ld [wHtmlScanOnly], a
	ld a, $00
	ldh [hPageHeaderPtr], a
	ldh [hHtml_PageHeader], a
	ld a, $D0
	ldh [hPageHeaderPtr + 1], a
	ldh [hHtml_PageHeaderHi], a
	ld a, $04
	ldh [hPageHeaderPtr + 2], a
	ldh [hHtml_PageBank], a
	ld de, wHtmlTextStream
	ld a, $05
	ldh [hTextX], a
	ld hl, sBrowserPageBuf
	ld a, $03
	farcall Html_ParseSource
	farcall Html_LoadPageImages
	farcall Html_MetaResultToError
	ret

Html_ScanPage:: ; 74:4254
	ld bc, $0000
	ld de, $0000
	farcall Browser_SetScroll
	ld bc, $0090
	ld de, $0060
	farcall Browser_SetViewport
	ld a, $FF
	ld [wHtmlScanOnly], a
	ld a, $00
	ldh [hPageHeaderPtr], a
	ldh [hHtml_PageHeader], a
	ld a, $D0
	ldh [hPageHeaderPtr + 1], a
	ldh [hHtml_PageHeaderHi], a
	ld a, $04
	ldh [hPageHeaderPtr + 2], a
	ldh [hHtml_PageBank], a
	ld de, wHtmlTextStream
	ld a, $05
	ldh [hTextX], a
	ld hl, sBrowserPageBuf
	ld a, $03
	farcall Html_ParseSource
	ret

Html_ParseSource:: ; 74:4296
	ldh [hHtml_SourceBank], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push hl
	ld a, $06
	ld hl, $D300 ; raw: clears $0100 bytes from $D300 of bank 6: the three meta values and the page title record, not one name
	ld bc, $0100
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	call FillBytes
	call Sound_FrameService
	ldh a, [hHtml_PageHeader]
	ld l, a
	ldh a, [hHtml_PageHeaderHi]
	ld h, a
	ldh a, [hHtml_PageBank]
	call BankSwitch_H
	ld bc, $1000
	xor a, a
	call FillBytes
	call Sound_FrameService
	pop hl
	ld a, e
	ldh [hHtml_RunStartLo], a
	ld a, d
	ldh [hTextY], a
	ldh a, [hTextX]
	call BankSwitch_D
	push hl
	ld h, d
	ld l, e
	ld bc, $1000
	xor a, a
	call FillBytes
	call Sound_FrameService
	farcall Html_InitParser
	farcall Html_LinkTable_Init
	farcall Html_Layout_Init
	pop hl
	push de
	ldh a, [hHtml_SourceBank]
	farcall Html_NextResourceRecord
	pop de
	ldh a, [hTextX]
	call BankSwitch_D
	ld a, $20
	ldh [hHtml_LastChar], a

Html_ParseSource_Loop:: ; 74:4307
	call Sound_FrameService
	ld a, [hli]
	or a, a
	jp z, Html_ParseSource_End
	cp a, $21
	jr c, .l4359
	cp a, $3C
	jp z, Html_ParseSource_Tag
	cp a, $26
	jr z, Html_ParseSource_Entity
	ldh [hHtml_LastChar], a
	cp a, $81
	jr c, .l4336
	cp a, $A0
	jr c, .l4337

	; [PROBABLE] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0;
	; fall-through of the jrcc at 74:4324 (executed) | 8 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 4326-4337 by apply_coverage --split
	cp a, $E0
	jr c, .l4336
	cp a, $F0
	jr c, .l4337
	cp a, $F8
	jr c, .l4336
	cp a, $FA
	jr c, .l4337

.l4336 ; 74:4336
	; [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 4326-4337 by apply_coverage
	; --split [executed in 9 scenarios]
	or a, a

.l4337 ; 74:4337
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios)
	jr nc, .l434C
	inc de
	inc de
	ld a, $E0
	cp a, d
	dec de
	dec de
	jp z, Html_ParseSource_End
	ldh a, [hHtml_LastChar]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	jr Html_ParseSource_Loop

.l434C ; 74:434C
	; [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 1;
	; entered by jrcc from 74:4337 (executed) [executed in 4 scenarios]
	inc de
	ld a, $E0
	cp a, d
	dec de
	jr z, Html_ParseSource_End
	ldh a, [hHtml_LastChar]
	ld [de], a
	inc de
	jr Html_ParseSource_Loop

.l4359 ; 74:4359
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 2/18 scenarios)
	ld c, a
	ld a, [wHtmlFlags]
	and a, $08
	jr z, .l4374

	; [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0;
	; fall-through of the jrcc at 74:435F (executed) [executed in 1 scenarios]
	ld a, c
	cp a, $0D
	jp z, Html_ParseSource_PreCR
	cp a, $0A
	jp z, Html_ParseSource_PreLineBreak
	cp a, $09
	jr z, .l4385
	ld c, $20
	jr .l4385

.l4374 ; 74:4374
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 2/18 scenarios)
	ld a, [hli]
	or a, a
	jr z, Html_ParseSource_End
	cp a, $21
	jr c, .l4374
	dec hl
	ldh a, [hHtml_LastChar]
	cp a, $20
	jr z, Html_ParseSource_Loop
	ld c, $20
.l4385 ; 74:4385
	inc de
	ld a, $E0
	cp a, d
	dec de
	jr z, Html_ParseSource_End
	ld a, c
	ld [de], a
	inc de
	jp Html_ParseSource_Loop

Html_ParseSource_Entity:: ; 74:4392
	; [CONFIRMED] 29 insn(s) reached by static flow only; seeds: exec x29; min discovery hops 1;
	; entered by jrcc from 74:431A (executed) [executed in 1 scenarios]
	ld a, l
	ldh [hHtml_MatchRestart], a
	ld a, h
	ldh [hHtml_MatchRestartHi], a
	ld bc, Html_EntityPtrs
	push de
	call Html_MatchKeyword
	pop de
	or a, a
	jr z, .l43BA
	ldh [hHtml_LastChar], a
	inc de
	ld a, $E0
	cp a, d
	dec de
	jr z, Html_ParseSource_End
	ldh a, [hHtml_LastChar]
	ld [de], a
	inc de
	ld a, [hli]
	cp a, $3B
	jp z, Html_ParseSource_Loop
	dec hl
	jp Html_ParseSource_Loop
.l43BA ; 74:43BA
	ldh a, [hHtml_MatchRestart]
	ld l, a
	ldh a, [hHtml_MatchRestartHi]
	ld h, a
	jp Html_ParseSource_Loop

	; [HYPOTHESIS] single 'pop hl' (e1) after the unconditional 'jp $4307' at 74:43C0; no
	; branch/pointer targets 43C3 (tgt scan of all code regions + word scan), so unreachable; falls
	; into the executed 43C4 (target of 13 jz/jp)
	pop hl

Html_ParseSource_End:: ; 74:43C4
	; [CONFIRMED] 81 insn(s); 81 executed (in up to 2/18 scenarios)
	call Sound_FrameService
	farcall Html_Layout_WrapRun
	farcall Html_Layout_ClearAllFloats
	ldh a, [hHtml_PageHeader]
	ld l, a
	ldh a, [hHtml_PageHeaderHi]
	ld h, a
	ld bc, $0015
	add hl, bc
	ldh a, [hHtml_PageBank]
	call BankSwitch_H
	ldh a, [hTextX + 1]
	ld [hli], a
	ldh a, [hHtml_RecordCountHi]
	ld [hli], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hHtmlLayout_LineY]
	ld c, a
	ldh a, [hHtmlLayout_LineYHi]
	ld b, a
	ld hl, $FFA0
	add hl, bc
	bit 7, h
	jr z, .skip
	ld hl, $0000
.skip ; 74:43FF
	ld a, l
	ldh [hViewScrollMax], a
	ld a, h
	ldh [hViewScrollMax + 1], a
	ret

Html_ParseSource_Tag:: ; 74:4406
	dec de
	ld a, [de]
	cp a, $20
	jr z, .l440D
	inc de
.l440D ; 74:440D
	ld a, [hl]
	ldh [hHtml_TagFirstChar], a
	cp a, $2F
	jr nz, .l4415
	inc hl
.l4415 ; 74:4415
	ld a, l
	ldh [hHtml_MatchRestart], a
	ld a, h
	ldh [hHtml_MatchRestartHi], a
	inc de
	ld a, $E0
	cp a, d
	dec de
	jp z, Html_ParseSource_End
	xor a, a
	ld [de], a
	ldh a, [hHtml_TitleStart]
	ld c, a
	ldh a, [hHtml_TitleStartHi]
	or a, c
	jp nz, Html_ParseSource_TitleTag
	ld bc, Html_TagPtrs
	push de
	call Html_MatchKeyword
	pop de
	or a, a
	jr nz, Html_DispatchTag

Html_ParseSource_Tag_Ignore:: ; 74:4439
Label_74_4439::
	ldh a, [hHtml_MatchRestart]
	ld l, a
	ldh a, [hHtml_MatchRestartHi]
	ld h, a

Html_ParseSource_Tag_Done:: ; 74:443F
Label_74_443F::
	ldh a, [hHtml_SourceBank]
	call BankSwitch_H
	ldh a, [hTextX]
	call BankSwitch_D

Html_ParseSource_Tag_SkipToEnd:: ; 74:4449
Label_74_4449::
	ld a, $20
	ldh [hHtml_LastChar], a
.loop ; 74:444D
	ld a, [hli]
	or a, a
	jp z, Html_ParseSource_End
	cp a, $3E
	jp z, Html_ParseSource_Loop
	cp a, $81
	jr c, .l446F

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 0;
	; fall-through of the jrcc at 74:4459 (executed)
	cp a, $A0
	jr c, .l4470
	cp a, $E0
	jr c, .l446F
	cp a, $F0
	jr c, .l4470
	cp a, $F8
	jr c, .l446F
	cp a, $FA
	jr c, .l4470

.l446F ; 74:446F
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 2/18 scenarios)
	or a, a
.l4470 ; 74:4470
	jp nc, .l4477

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jpcc at 74:4470 (executed)
	ld a, [hli]
	jp .loop

.l4477 ; 74:4477
	; [CONFIRMED] 26 insn(s); 26 executed (in up to 2/18 scenarios)
	dec hl
	ld bc, Html_NoKeywords
	call Html_ScanAttributes
	jp .loop

Html_DispatchTag:: ; 74:4481
	cp a, $0F
	jr z, .l4490
	ld b, a
	ld a, [hl]
	cp a, $3E
	jr z, .l448F
	cp a, $21
	jr nc, Html_ParseSource_Tag_SkipToEnd
.l448F ; 74:448F
	ld a, b
.l4490 ; 74:4490
	add a, a
	push hl
	add a, $A0
	ld l, a
	ld a, $00
	adc a, $44
	ld h, a
	ld a, [hli]
	ld b, [hl]
	ld c, a
	pop hl
	push bc
	ret
