; engine/browser/page_render.asm
; bank 4E, $5204-$5B69 (2405 bytes); pinned by layout.link
; title bar, page rendering, link selection, element drawing

SECTION "engine/browser/page_render", ROMX

Browser_DrawTitleBar:: ; 4E:5204
Function_4E_5204::
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ldh a, [hPageHeaderPtr]
	ld l, a
	ldh a, [hPageHeaderPtr + 1]
	ld h, a
	or a, l
	ret z
	ldh a, [hPageHeaderPtr + 2]
	call BankSwitch_H
	ld a, [hl]
	or a, a
	jr nz, .l5225

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 4E:5213 (executed) [executed in 2 scenarios]
	ld hl, wBrowserPageUrl
	ld a, $06
	call BankSwitch_H
	farcall Browser_MakeShortTitle
	jr .l522E

.l5225 ; 4E:5225
	; [CONFIRMED] 32 insn(s); 32 executed (in up to 2/18 scenarios)
	ld de, wHtmlTitleBuf
	ld bc, $0016
	call CopyBytes
.l522E ; 4E:522E
	farcall Browser_ClearTitleArea
	ld a, $03
	ldh [hTextBox_ColorSelB], a
	ld a, $00
	ldh [hTextBox_ColorSelC], a
	ld a, $82
	ldh [hTextY], a
	ldh [hRam_FFC0], a
	ld a, $8F
	ldh [hRam_FFC3], a
	ld a, $84
	ldh [hTextBox_RightLimitX], a
	ld a, $10
	ldh [hTextX], a
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextX + 1], a
	ldh [hTextBox_LineStartXHi], a
	ldh [hRam_FFC5], a
	ld a, $FF
	ldh [hTextBox_LineAdvance], a
	ld a, $06
	ldh [hRam_FFC7], a
	call Sound_FrameService
	ld hl, wHtmlTitleBuf
	xor a, a
	farcall TextEngine_Run
	farcall Browser_UploadTitleCanvas
	ret

Browser_MakeShortTitle:: ; 4E:5274
	; [CONFIRMED] 76 insn(s) reached by static flow only; seeds: exec x76; min discovery hops 1;
	; entered by far from 4E:521D (PROBABLE code) | 11 insn(s) executed; cut out of the PROBABLE
	; region 5274-52E7 by apply_coverage --split [executed in 2 scenarios]
	push hl
	xor a, a
	ld c, a
	ld b, a
	ld e, a
	ld d, a
.loop ; 4E:527A
	ld a, [hli]
	or a, a
	jr z, .l52D5
	cp a, $81
	jr c, .l5296

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5274-52E7 by apply_coverage --split
	cp a, $A0
	jr c, .l5297
	cp a, $E0
	jr c, .l5296
	cp a, $F0
	jr c, .l5297
	cp a, $F8
	jr c, .l5296
	cp a, $FA
	jr c, .l5297

.l5296 ; 4E:5296
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 5274-52E7 by apply_coverage
	; --split [executed in 2 scenarios]
	or a, a
.l5297 ; 4E:5297
	jp c, .l52A5
	ld a, c
	cp a, $13
	jr nc, .l52B2
	ld d, e
	ld e, b
	ld b, c
	inc c
	jr .loop

.l52A5 ; 4E:52A5
	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5274-52E7 by apply_coverage --split
	ld a, c
	cp a, $13
	jr nc, .l52B2
	ld a, [hli]
	ld d, e
	ld e, b
	ld b, c
	inc c
	inc c
	jr .loop

.l52B2 ; 4E:52B2
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 5274-52E7 by apply_coverage
	; --split [executed in 2 scenarios]
	ld a, b
	cp a, $13
	jr c, .l52BD

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5274-52E7 by apply_coverage --split
	ld a, e
	cp a, $13
	jr c, .l52BD
	ld a, d

.l52BD ; 4E:52BD
	; [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 5274-52E7 by apply_coverage
	; --split [executed in 2 scenarios]
	ld de, wHtmlTitleBuf
	pop hl
	ld c, a
	ld b, $00
	push bc
	call CopyBytes
	pop bc
	ld a, $81
	ld [de], a
	inc de
	ld a, $63
	ld [de], a
	inc de
	inc bc
	inc bc
	jr .l52E4

.l52D5 ; 4E:52D5
	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5274-52E7 by apply_coverage --split
	ld de, wHtmlTitleBuf
	pop hl
	ld a, c
	or a, a
	jr z, .l52E4
	ld b, $00
	push bc
	call CopyBytes
	pop bc

.l52E4 ; 4E:52E4
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 5274-52E7 by apply_coverage
	; --split [executed in 2 scenarios]
	xor a, a
	ld [de], a
	ret

Browser_RenderPage:: ; 4E:52E7
Function_4E_52E7::
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	farcall Browser_DrawTitleBar
	farcall Browser_ClearBodyArea
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wBrowserPageUrl
.l52FC ; 4E:52FC
	ld a, [hli]
	cp a, $23
	jr z, .l5306
	or a, a
	jr nz, .l52FC
	jr .l532B

.l5306 ; 4E:5306
	; [CONFIRMED] 23 insn(s) reached by static flow only; seeds: exec x23; min discovery hops 1;
	; entered by jrcc from 4E:52FF (executed) | 12 insn(s) executed; cut out of the PROBABLE region
	; 5306-532B by apply_coverage --split [executed in 1 scenarios]
	ld de, wAttrUrlBuf
	dec hl
.l530A ; 4E:530A
	ld a, [hli]
	ld [de], a
	inc de
	or a, a
	jr nz, .l530A
	ld hl, wAttrUrlBuf
	ld bc, wHtmlLinkPtrList
	call Browser_FindAnchor
	or a, a
	jr z, .l532B

	; [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5306-532B by apply_coverage --split
	ld hl, wHtmlLinkPtrList + $02
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	dec hl
	ld a, [hld]
	ldh [hViewY + 1], a
	ld a, [hld]
	ldh [hViewY], a

.l532B ; 4E:532B
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)
	ld bc, $0090
	ld de, $0060
	farcall Browser_SetViewport
	farcall Browser_DrawVisibleElements
	farcall Browser_UploadBodyCanvas
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffersDi
	jp Browser_DrawScrollIndicators

Browser_FindAnchor:: ; 4E:534B
	; [CONFIRMED] 46 insn(s) reached by static flow only; seeds: exec x46; min discovery hops 2;
	; entered by call from 4E:5316 (PROBABLE code) | 26 insn(s) executed; cut out of the PROBABLE
	; region 534B-5390 by apply_coverage --split [executed in 1 scenarios]
	ld a, l
	ldh [hPageRender_AnchorStart], a
	ld a, h
	ldh [hPageRender_AnchorStartHi], a
	ld de, $FFFF

Browser_FindAnchor_NextEntry:: ; 4E:5354
Label_4E_5354::
	inc de
	ld a, d
	or a, a
	jr nz, Browser_FindAnchor_Overflow
	push de
	ld a, [bc]
	inc bc
	ld e, a
	ld a, [bc]
	inc bc
	ld d, a
	or a, e
	jr z, Browser_FindAnchor_Done
	push bc
	ld b, $00
.loop ; 4E:5366
	inc b
	jr z, Browser_FindAnchor_Mismatch
	ld a, [de]
	inc de
	cp a, $41
	jr c, .l5375

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 534B-5390 by apply_coverage --split
	cp a, $5B
	jr nc, .l5375
	add a, $20

.l5375 ; 4E:5375
	; [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 534B-5390 by apply_coverage
	; --split [executed in 1 scenarios]
	ld c, a
	ld a, [hli]
	or a, a
	jr z, .l538A
	cp a, $41
	jr c, .l5384

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 534B-5390 by apply_coverage --split
	cp a, $5B
	jr nc, .l5384
	add a, $20

.l5384 ; 4E:5384
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 534B-5390 by apply_coverage
	; --split [executed in 1 scenarios]
	cp a, c
	jr z, .loop
	pop bc
	jr Browser_FindAnchor_Mismatch

.l538A ; 4E:538A
	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 534B-5390 by apply_coverage --split
	sub a, c
	pop bc
	jr z, Browser_FindAnchor_Found
	jr Browser_FindAnchor_Mismatch

; ---- data $5390-$5391 (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint) | observed: single $C1 (pop bc) that would fall into the PROBABLE code at 5391; the two preceding paths jr $5391 (5388, 538E) skip it and no branch to 5390 was found in the decoded code; left unclassified

Data_4E_5390:: ; 4E:5390
	db $C1

Browser_FindAnchor_Mismatch:: ; 4E:5391
Label_4E_5391::
	; [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 3;
	; entered by jrcc from 4E:5367 (PROBABLE code) | 6 insn(s) executed; cut out of the PROBABLE
	; region 5391-53A1 by apply_coverage --split [executed in 1 scenarios]
	pop de
	ldh a, [hPageRender_AnchorStart]
	ld l, a
	ldh a, [hPageRender_AnchorStartHi]
	ld h, a
	jr Browser_FindAnchor_NextEntry

Browser_FindAnchor_Found:: ; 4E:539A
Label_4E_539A::
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5391-53A1 by apply_coverage --split
	inc a

Browser_FindAnchor_Done:: ; 4E:539B
Label_4E_539B::
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 5391-53A1 by apply_coverage
	; --split [executed in 1 scenarios]
	pop de
	ret

Browser_FindAnchor_Overflow:: ; 4E:539D
Label_4E_539D::
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5391-53A1 by apply_coverage --split
	ld de, $FFFF
	ret

Browser_ScrollUpLine:: ; 4E:53A1
Function_4E_53A1::
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ldh a, [hViewY]
	ld c, a
	ldh a, [hViewY + 1]
	ld b, a
	or a, c
	ret z

	; [CONFIRMED] 56 insn(s) reached by static flow only; seeds: exec x56; min discovery hops 0;
	; fall-through of the retcc at 4E:53A8 (executed) [executed in 2 scenarios]
	ld a, c
	sub a, $0C
	ldh [hViewY], a
	ld a, b
	sbc a, $00
	ldh [hViewY + 1], a
	ld bc, $0090
	ld de, $000C
	farcall Browser_SetViewport
	xor a, a
	ldh [hBrowserDrawYOffset], a
	ldh [hBrowserDrawYOffset + 1], a
	farcall Browser_ShiftCanvasDown
	farcall Browser_DrawVisibleElements
	ret

Browser_ScrollDownLine:: ; 4E:53D1
	ldh a, [hViewScrollMax]
	ld c, a
	ldh a, [hViewScrollMax + 1]
	or a, c
	ret z
	ldh a, [hViewY]
	ld c, a
	ldh a, [hViewY + 1]
	ld b, a
	ldh a, [hViewScrollMax]
	sub a, c
	ld e, a
	ldh a, [hViewScrollMax + 1]
	sbc a, b
	ld d, a
	ret c
	ld a, c
	add a, $60
	ldh [hViewY], a
	ld a, b
	adc a, $00
	ldh [hViewY + 1], a
	ld bc, $0090
	ld de, $000C
	farcall Browser_SetViewport
	ld a, $54
	ldh [hBrowserDrawYOffset], a
	ld a, $00
	ldh [hBrowserDrawYOffset + 1], a
	farcall Browser_ShiftCanvasUp
	farcall Browser_DrawVisibleElements
	ldh a, [hViewY]
	sub a, $54
	ldh [hViewY], a
	ldh a, [hViewY + 1]
	sbc a, $00
	ldh [hViewY + 1], a
	xor a, a
	ldh [hBrowserDrawYOffset], a
	ldh [hBrowserDrawYOffset + 1], a
	ret

Browser_SetScroll:: ; 4E:5423
Function_4E_5423::
	; [CONFIRMED] 266 insn(s); 266 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, c
	ldh [hViewX], a
	ld a, b
	ldh [hViewX + 1], a
	ld a, e
	ldh [hViewY], a
	ld a, d
	ldh [hViewY + 1], a
	xor a, a
	ldh [hBrowserDrawYOffset], a
	ldh [hBrowserDrawYOffset + 1], a
	ret

Browser_SetViewport:: ; 4E:5435
	ldh a, [hViewX]
	add a, c
	ldh [hViewRight], a
	ldh a, [hViewX + 1]
	adc a, b
	ldh [hViewRight + 1], a
	ldh a, [hViewY]
	add a, e
	ldh [hViewBottom], a
	ldh a, [hViewY + 1]
	adc a, d
	ldh [hViewBottom + 1], a
	ret

Browser_RedrawLinkById:: ; 4E:544A
	ldh [hPageRender_WantedLink], a
	ld bc, $0090
	ld de, $0060
	farcall Browser_SetViewport
	ldh a, [hPageHeaderPtr]
	ld l, a
	ldh a, [hPageHeaderPtr + 1]
	ld h, a
	or a, l
	ret z
	ld d, h
	ld e, l
	ld bc, $0015
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	ld a, b
	or a, c
	ret z
	ld hl, $0020
	add hl, de
	xor a, a
	ldh [hRam_FFB0], a
.loop ; 4E:547D
	call Sound_FrameService
	push bc
	push hl
	ld bc, $0009
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, c
	and a, $03
	cp a, $01
	jr nz, .l5505
	ld a, b
	ldh [hPageRender_SearchLinkId], a
	pop hl
	push hl
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewRight]
	sub a, c
	ld c, a
	ldh a, [hViewRight + 1]
	sbc a, b
	jp c, .l5505
	or a, c
	jp z, .l5505
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewBottom]
	sub a, c
	ld c, a
	ldh a, [hViewBottom + 1]
	sbc a, b
	jp c, .l5505
	or a, c
	jp z, .l5505
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewX]
	sub a, c
	ldh a, [hViewX + 1]
	sbc a, b
	jp nc, .l5505
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewY]
	sub a, c
	ldh a, [hViewY + 1]
	sbc a, b
	jp nc, .l5505
	ldh a, [hPageRender_WantedLink]
	ld b, a
	ldh a, [hPageRender_SearchLinkId]
	cp a, b
	jr nz, .l5505
	pop hl
	push hl
	ldh a, [hPageRender_WantedLink]
	push af
	call Browser_DrawElement
	pop af
	ldh [hPageRender_WantedLink], a
.l5505 ; 4E:5505
	pop hl
	ld bc, $0010
	add hl, bc
	pop bc
	dec bc
	ld a, b
	or a, c
	jp nz, .loop
	ret

Browser_FindLinkElement:: ; 4E:5512
	ldh [hPageRender_WantedLink], a
	ld bc, $0090
	ld de, $0060
	farcall Browser_SetViewport
	ldh a, [hPageHeaderPtr]
	ld l, a
	ldh a, [hPageHeaderPtr + 1]
	ld h, a
	or a, l
	ret z
	ld d, h
	ld e, l
	ld bc, $0015
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	ld a, b
	or a, c
	ret z
	ld hl, $0020
	add hl, de
	xor a, a
	ldh [hRam_FFB0], a
.loop ; 4E:5545
	call Sound_FrameService
	push bc
	push hl
	ld bc, $0009
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, c
	and a, $03
	cp a, $01
	jr nz, .l55D5
	ld a, b
	ldh [hPageRender_SearchLinkId], a
	pop hl
	push hl
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewRight]
	sub a, c
	ld c, a
	ldh a, [hViewRight + 1]
	sbc a, b
	jp c, .l55D5
	or a, c
	jp z, .l55D5
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewBottom]
	sub a, c
	ld c, a
	ldh a, [hViewBottom + 1]
	sbc a, b
	jp c, .l55D5
	or a, c
	jp z, .l55D5
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewX]
	sub a, c
	ldh a, [hViewX + 1]
	sbc a, b
	jp nc, .l55D5
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewY]
	sub a, c
	ldh a, [hViewY + 1]
	sbc a, b
	jp nc, .l55D5
	ldh a, [hPageRender_WantedLink]
	or a, a
	jr z, .l55D1
	cp a, $FF
	jr z, .l55CC
	ld b, a
	ldh a, [hPageRender_SearchLinkId]
	cp a, b
	jr nz, .l55D5
	pop hl
	pop bc
	ret

.l55CC ; 4E:55CC
	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 1;
	; entered by jrcc from 4E:55C1 (executed)
	ldh a, [hPageRender_SearchLinkId]
	pop hl
	pop bc
	ret
.l55D1 ; 4E:55D1
	ldh a, [hPageRender_SearchLinkId]
	ldh [hRam_FFB0], a

.l55D5 ; 4E:55D5
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)
	pop hl
	ld bc, $0010
	add hl, bc
	pop bc
	dec bc
	ld a, b
	or a, c
	jp nz, .loop

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jpcc at 4E:55DE (executed)
	ldh a, [hPageRender_WantedLink]
	or a, a
	ret z
	ldh a, [hRam_FFB0]
	ret

Browser_FindVisibleLink:: ; 4E:55E8
Function_4E_55E8::
	; [CONFIRMED] 125 insn(s); 125 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ldh [hPageRender_WantedLink], a
	ld bc, $0090
	ld de, $0060
	farcall Browser_SetViewport
	ldh a, [hPageHeaderPtr]
	ld l, a
	ldh a, [hPageHeaderPtr + 1]
	ld h, a
	or a, l
	ret z
	ld d, h
	ld e, l
	ld bc, $0015
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	ld a, b
	or a, c
	ret z
	ld hl, $0020
	add hl, de
	xor a, a
	ldh [hRam_FFB0], a
	ldh [hPageRender_OffscreenLinkId], a
.loop ; 4E:561D
	call Sound_FrameService
	push bc
	push hl
	ld bc, $0009
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, c
	and a, $03
	cp a, $01
	jp nz, .l56CC
	ld a, b
	ldh [hPageRender_SearchLinkId], a
	pop hl
	push hl
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewRight]
	sub a, c
	ld c, a
	ldh a, [hViewRight + 1]
	sbc a, b
	jp c, .l56BC
	or a, c
	jp z, .l56BC
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewBottom]
	sub a, c
	ld c, a
	ldh a, [hViewBottom + 1]
	sbc a, b
	jp c, .l56BC
	or a, c
	jp z, .l56BC
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewX]
	sub a, c
	ldh a, [hViewX + 1]
	sbc a, b
	jp nc, .l56BC
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewY]
	sub a, c
	ldh a, [hViewY + 1]
	sbc a, b
	jp nc, .l56BC
	ldh a, [hPageRender_OffscreenLinkId]
	ld b, a
	ldh a, [hPageRender_SearchLinkId]
	cp a, b
	jr z, .l56C9
	ldh a, [hPageRender_WantedLink]
	or a, a
	jr z, .l56B6
	cp a, $FF
	jr z, .l56AE
	ld b, a
	ldh a, [hPageRender_SearchLinkId]
	cp a, b
	jr nz, .l56CC
	ldh [hRam_FFB0], a
	jr .l56CC
.l56AE ; 4E:56AE
	ldh a, [hPageRender_SearchLinkId]
	ldh [hRam_FFB0], a
	ldh [hPageRender_WantedLink], a
	jr .l56CC

.l56B6 ; 4E:56B6
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 4E:569E (executed)
	ldh a, [hPageRender_SearchLinkId]
	ldh [hRam_FFB0], a
	jr .l56CC

.l56BC ; 4E:56BC
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 1/18 scenarios)
	ldh a, [hPageRender_SearchLinkId]
	or a, a
	jr z, .l56CC
	ldh [hPageRender_OffscreenLinkId], a
	ld b, a
	ldh a, [hRam_FFB0]
	cp a, b
	jr nz, .l56CC

.l56C9 ; 4E:56C9
	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by jrcc from 4E:5699 (executed) [executed in 1 scenarios]
	xor a, a
	ldh [hRam_FFB0], a

.l56CC ; 4E:56CC
	; [CONFIRMED] 21 insn(s); 21 executed (in up to 2/18 scenarios)
	pop hl
	ld bc, $0010
	add hl, bc
	pop bc
	dec bc
	ld a, b
	or a, c
	jp nz, .loop
	ldh a, [hRam_FFB0]
	ret

Browser_SelectPrevLink:: ; 4E:56DB
	ldh a, [hBrowserSelectedLink]
	ldh [hPageRender_PrevLink], a
	dec a
	jr z, .l56E8
	call Browser_FindVisibleLink
	or a, a
	jr nz, .l56F6
.l56E8 ; 4E:56E8
	farcall Browser_ScrollUpLine
	ldh a, [hBrowserSelectedLink]
	dec a
	jr z, .l570D

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 4E:56F1 (executed)
	call Browser_FindVisibleLink

.l56F6 ; 4E:56F6
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	or a, a
	jp z, .l56FF
	ldh [hBrowserSelectedLink], a
	call Browser_RedrawLinkById
.l56FF ; 4E:56FF
	ldh a, [hPageRender_PrevLink]
	or a, a
	jr z, .l570D

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 4E:5702 (executed) [executed in 2 scenarios]
	call Browser_FindVisibleLink
	or a, a
	jr z, .l570D
	call Browser_RedrawLinkById

.l570D ; 4E:570D
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)
	farcall Browser_UploadBodyCanvas
	jp Browser_DrawScrollIndicators

Browser_SelectNextLink:: ; 4E:5716
	ldh a, [hBrowserSelectedLink]
	ldh [hPageRender_PrevLink], a
	inc a
	call Browser_FindVisibleLink
	or a, a
	jr nz, .l572D

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 4E:571F (executed) [executed in 6 scenarios]
	farcall Browser_ScrollDownLine
	ldh a, [hBrowserSelectedLink]
	inc a
	call Browser_FindVisibleLink

.l572D ; 4E:572D
	; [CONFIRMED] 125 insn(s); 125 executed (in up to 2/18 scenarios)
	or a, a
	jp z, .l5736
	ldh [hBrowserSelectedLink], a
	call Browser_RedrawLinkById
.l5736 ; 4E:5736
	ldh a, [hPageRender_PrevLink]
	or a, a
	jr z, .l5744
	call Browser_FindVisibleLink
	or a, a
	jr z, .l5744
	call Browser_RedrawLinkById
.l5744 ; 4E:5744
	farcall Browser_UploadBodyCanvas
	jp Browser_DrawScrollIndicators

Browser_DrawVisibleElements:: ; 4E:574D
	ldh a, [hPageHeaderPtr]
	ld l, a
	ldh a, [hPageHeaderPtr + 1]
	ld h, a
	or a, l
	ret z
	ld d, h
	ld e, l
	ld bc, $0015
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	ld a, b
	or a, c
	ret z
	ld hl, $0020
	add hl, de
.loop ; 4E:576F
	call Sound_FrameService
	push bc
	push hl
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewRight]
	sub a, c
	ld c, a
	ldh a, [hViewRight + 1]
	sbc a, b
	jp c, .l57CF
	or a, c
	jp z, .l57CF
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewBottom]
	sub a, c
	ld c, a
	ldh a, [hViewBottom + 1]
	sbc a, b
	jp c, .l57CF
	or a, c
	jp z, .l57CF
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewX]
	sub a, c
	ldh a, [hViewX + 1]
	sbc a, b
	jp nc, .l57CF
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewY]
	sub a, c
	ldh a, [hViewY + 1]
	sbc a, b
	jp nc, .l57CF
	pop hl
	push hl
	call Browser_DrawElement
.l57CF ; 4E:57CF
	pop hl
	ld bc, $0010
	add hl, bc
	pop bc
	dec bc
	ld a, b
	or a, c
	jp nz, .loop
	ret

Browser_DrawElement:: ; 4E:57DC
	call Sound_FrameService
	ld bc, $0006
	push hl
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	pop hl
	ldh a, [hViewBottom]
	sub a, c
	ldh a, [hViewBottom + 1]
	sbc a, b
	jr nc, .l5800

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 4E:57F8 (executed) [executed in 1 scenarios]
	ldh a, [hViewBottom]
	ld c, a
	ldh a, [hViewBottom + 1]
	ld b, a

.l5800 ; 4E:5800
	; [CONFIRMED] 33 insn(s); 33 executed (in up to 2/18 scenarios)
	ldh a, [hViewY]
	ld e, a
	ld a, c
	sub a, e
	ldh [hPageRender_ElemBottom], a
	ldh a, [hViewY + 1]
	ld e, a
	ld a, b
	sbc a, e
	ldh [hPageRender_ElemBottomHi], a
	ld bc, $0004
	push hl
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	pop hl
	ldh a, [hViewRight]
	sub a, c
	ldh a, [hViewRight + 1]
	sbc a, b
	jr c, .l5831
	ld a, c
	ldh [hPageRender_ElemRight], a
	ld a, b
	ldh [hPageRender_ElemRightHi], a
	jr .l5839

.l5831 ; 4E:5831
	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1;
	; entered by jrcc from 4E:5827 (executed)
	ldh a, [hViewRight]
	ldh [hPageRender_ElemRight], a
	ldh a, [hViewRight + 1]
	ldh [hPageRender_ElemRightHi], a

.l5839 ; 4E:5839
	; [CONFIRMED] 69 insn(s); 69 executed (in up to 2/18 scenarios)
	ld bc, $0000
	push hl
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	pop hl
	ldh a, [hViewX]
	ld e, a
	ld a, c
	sub a, e
	ldh [hPageRender_ElemX], a
	ldh a, [hViewX + 1]
	ld e, a
	ld a, b
	sbc a, e
	ldh [hPageRender_ElemXHi], a
	ld bc, $0002
	push hl
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	pop hl
	ldh a, [hViewY]
	ld e, a
	ld a, c
	sub a, e
	ldh [hPageRender_ElemY], a
	ldh a, [hViewY + 1]
	ld e, a
	ld a, b
	sbc a, e
	ldh [hPageRender_ElemYHi], a
	ld bc, $0008
	push hl
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	pop hl
	ld d, h
	ld e, l
	ld b, $00
	ld hl, Table_Browser_ElementDrawHandlers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- ptrtable $589B-$58AB (16 bytes) [PROBABLE] code-pointer table, 8 entries: 1/8 words hit known code starts (dispatch idiom `ld a,[hli] ; ld h,[hl] ; ld l,a ; jp hl` at 4E:589A, base from `ld hl,$589B`; end = cfg inline-table rule, HYPOTHESIS for the exact length); 1/8 targets executed

Table_Browser_ElementDrawHandlers:: ; 4E:589B
Table_4E_589B::
	dw Label_4E_58AB
	dw Browser_DrawElement_Text
	dw Label_4E_58AB
	dw Label_4E_58AB
	dw Browser_DrawElement_Bitmap
	dw Browser_DrawElement_Bitmap
	dw Label_4E_58AB
	dw Label_4E_58AB
Browser_DrawElement_ReturnOnly:: ; [PROBABLE] table-target operation: RET only; entry unobserved.
Label_4E_58AB:: ; 4E:58AB
	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: table x1; min discovery hops 0; run
	; starts at an entry of the code-pointer table at 4E:589B
	ret

Browser_DrawElement_Text:: ; 4E:58AC
	; [CONFIRMED] 55 insn(s); 55 executed (in up to 2/18 scenarios)
	ld h, d
	ld l, e
	ld bc, $0009
	push hl
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	pop hl
	ld a, b
	ldh [hPageRender_ElemLinkId], a
	ld a, c
	ldh [hPageRender_ElemFlags], a
	and a, $03
	cp a, $01
	jr z, .l58DB
	cp a, $02
	jr z, .l58F7
	ld a, $03
	ldh [hTextBox_ColorSelB], a
	ld a, $00
	ldh [hTextBox_ColorSelC], a
	jr .l58FF
.l58DB ; 4E:58DB
	ldh a, [hBrowserSelectedLink]
	ld b, a
	ldh a, [hPageRender_ElemLinkId]
	cp a, b
	jr z, .l58ED
	ld a, $02
	ldh [hTextBox_ColorSelB], a
	ld a, $00
	ldh [hTextBox_ColorSelC], a
	jr .l58FF
.l58ED ; 4E:58ED
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $02
	ldh [hTextBox_ColorSelC], a
	jr .l58FF
.l58F7 ; 4E:58F7
	ld a, $01
	ldh [hTextBox_ColorSelB], a
	ld a, $00
	ldh [hTextBox_ColorSelC], a
.l58FF ; 4E:58FF
	ldh a, [hPageRender_ElemFlags]
	and a, $30
	cp a, $20
	jr z, .l590D
	cp a, $30
	jr z, .l593E
	jr .l594A

.l590D ; 4E:590D
	; [PROBABLE] 40 insn(s) reached by static flow only; seeds: exec x40; min discovery hops 1;
	; entered by jrcc from 4E:5905 (executed)
	ldh a, [hPageRender_ElemY]
	ld c, a
	ldh a, [hPageRender_ElemYHi]
	ld b, a
	ldh a, [hPageRender_ElemBottom]
	sub a, c
	ld c, a
	ldh a, [hPageRender_ElemBottomHi]
	sbc a, b
	ld b, a
	bit 7, b
	jr z, .l5926
	dec bc
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
.l5926 ; 4E:5926
	srl b
	rr c
	ldh a, [hPageRender_ElemY]
	add a, c
	ld c, a
	ldh a, [hPageRender_ElemYHi]
	adc a, b
	ld b, a
	ld a, c
	sub a, $0C
	ldh [hPageRender_ElemY], a
	ld a, b
	sbc a, $00
	ldh [hPageRender_ElemYHi], a
	jr .l594A
.l593E ; 4E:593E
	ldh a, [hPageRender_ElemBottom]
	sub a, $0C
	ldh [hPageRender_ElemY], a
	ldh a, [hPageRender_ElemBottomHi]
	sbc a, $00
	ldh [hPageRender_ElemYHi], a

.l594A ; 4E:594A
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 2/18 scenarios)
	ld bc, $000B
	push hl
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	pop hl
	ldh a, [hRam_FFB0]
	ldh [hPageRender_TextBank], a
	ld h, b
	ld l, c
.loop ; 4E:5963
	ldh a, [hPageRender_ElemYHi]
	bit 7, a
	jr z, .l5993

	; [PROBABLE] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 0;
	; fall-through of the jrcc at 4E:5967 (executed)
	ldh a, [hPageRender_ElemX]
	ld e, a
	ldh a, [hPageRender_ElemXHi]
	ld d, a
	ldh a, [hPageRender_ElemRight]
	ld c, a
	ldh a, [hPageRender_ElemRightHi]
	ld b, a
	ldh a, [hPageRender_TextBank]
	call Text_MeasureFit
	ld a, b
	or a, c
	jp z, .done
	ldh a, [hPageRender_ElemY]
	add a, $0C
	ldh [hPageRender_ElemY], a
	ldh a, [hPageRender_ElemYHi]
	adc a, $00
	ldh [hPageRender_ElemYHi], a
	ld a, [hli]
	cp a, $0D
	jr z, .loop
	dec hl
	jr .loop

.l5993 ; 4E:5993
	; [CONFIRMED] 25 insn(s); 25 executed (in up to 2/18 scenarios)
	ldh a, [hPageRender_ElemY]
	ld e, a
	ldh a, [hPageRender_ElemYHi]
	ld d, a
	ldh a, [hPageRender_ElemBottom]
	sub a, e
	ldh a, [hPageRender_ElemBottomHi]
	sbc a, d
	jp c, .done
	ldh a, [hPageRender_ElemBottom]
	sub a, e
	jp z, .done
	ldh a, [hPageRender_ElemX]
	ld e, a
	ldh a, [hPageRender_ElemXHi]
	ld d, a
	ldh a, [hPageRender_ElemRight]
	ld c, a
	ldh a, [hPageRender_ElemRightHi]
	ld b, a
	ldh a, [hPageRender_ElemFlags]
	and a, $0C
	ldh [hPageRender_LineShiftX], a
	ldh [hRam_FFB3], a
	jr z, .l59F4

	; [PROBABLE] 34 insn(s) reached by static flow only; seeds: exec x34; min discovery hops 0;
	; fall-through of the jrcc at 4E:59BC (executed)
	push hl
	ldh a, [hPageRender_TextBank]
	call Text_MeasureFit
	ldh a, [hPageRender_ElemRight]
	sub a, e
	ldh [hPageRender_LineShiftX], a
	ld e, a
	ldh a, [hPageRender_ElemRightHi]
	sbc a, d
	ldh [hRam_FFB3], a
	or a, e
	pop de
	jr z, .l59F9
	ld h, d
	ld l, e
	ldh a, [hPageRender_LineShiftX]
	ld e, a
	ldh a, [hPageRender_ElemFlags]
	and a, $0C
	cp a, $04
	jr z, .skip
	srl e
	ld a, e
	ldh [hPageRender_LineShiftX], a
.skip ; 4E:59E5
	ldh a, [hPageRender_ElemX]
	add a, e
	ld e, a
	ldh a, [hPageRender_ElemXHi]
	adc a, $00
	ld d, a
	ldh a, [hPageRender_ElemRight]
	ld c, a
	ldh a, [hPageRender_ElemRightHi]
	ld b, a

.l59F4 ; 4E:59F4
	; [CONFIRMED] 66 insn(s); 66 executed (in up to 2/18 scenarios)
	ldh a, [hPageRender_TextBank]
	call Text_MeasureFit
.l59F9 ; 4E:59F9
	ld a, b
	or a, c
	jr z, .done
	push hl
	dec bc
	ld a, c
	cpl
	ld e, a
	ld a, b
	cpl
	ld d, a
	add hl, de
	inc bc
	ld de, wHtmlTitleBuf
	ldh a, [hPageRender_TextBank]
	call BankSwitch_H
	call CopyBytes
	xor a, a
	ld [de], a
	ldh a, [hPageRender_LineShiftX]
	ld c, a
	ldh a, [hPageRender_ElemX]
	add a, c
	add a, $08
	ldh [hTextX], a
	ldh [hTextBox_LineStartX], a
	ldh a, [hPageRender_ElemXHi]
	adc a, $00
	ldh [hTextX + 1], a
	ldh [hTextBox_LineStartXHi], a
	ldh a, [hBrowserDrawYOffset]
	ld c, a
	ldh a, [hPageRender_ElemY]
	add a, c
	ldh [hTextY], a
	ldh [hRam_FFC0], a
	ld a, $8F
	ldh [hRam_FFC3], a
	ld a, $9F
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $06
	ldh [hRam_FFC7], a
	ld a, $FF
	ldh [hTextBox_LineAdvance], a
	ld hl, wHtmlTitleBuf
	xor a, a
	farcall TextEngine_Run
	pop hl
	ldh a, [hPageRender_ElemY]
	add a, $0C
	ldh [hPageRender_ElemY], a
	ldh a, [hPageRender_ElemYHi]
	adc a, $00
	ldh [hPageRender_ElemYHi], a
	ldh a, [hPageRender_TextBank]
	call BankSwitch_H
	ld a, [hli]
	cp a, $0D
	jp z, .loop
	dec hl
	jp .loop
.done ; 4E:5A6C
	ret

Browser_DrawElement_Bitmap:: ; 4E:5A6D
	; [CONFIRMED] 416 insn(s) reached by static flow only; seeds: exec x265, site x5, table x146;
	; min discovery hops 0; run starts at an entry of the code-pointer table at 4E:589B | 28 insn(s)
	; executed; cut out of the PROBABLE region 5A6D-5CB6 by apply_coverage --split [executed in 1
	; scenarios]
	ld h, d
	ld l, e
	ld bc, $0009
	push hl
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	pop hl
	ld a, b
	ldh [hPageRender_ElemLinkId], a
	ld a, c
	ldh [hPageRender_ElemFlags], a
	and a, $03
	cp a, $01
	jr z, .l5A9A
	cp a, $02
	jr z, .l5AB2
	ld a, $03
	ldh [hPageRender_BitmapColors], a
	ldh [hRam_FFC3], a
	jr .l5AB8

.l5A9A ; 4E:5A9A
	; [PROBABLE] 16 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5A6D-5CB6 by apply_coverage --split
	ldh a, [hBrowserSelectedLink]
	ld b, a
	ldh a, [hPageRender_ElemLinkId]
	cp a, b
	jr z, .l5AAA
	ld a, $02
	ldh [hPageRender_BitmapColors], a
	ldh [hRam_FFC3], a
	jr .l5AB8
.l5AAA ; 4E:5AAA
	ld a, $20
	ldh [hPageRender_BitmapColors], a
	ldh [hRam_FFC3], a
	jr .l5AB8
.l5AB2 ; 4E:5AB2
	ld a, $01
	ldh [hPageRender_BitmapColors], a
	ldh [hRam_FFC3], a

.l5AB8 ; 4E:5AB8
	; [CONFIRMED] 67 insn(s) executed; cut out of the PROBABLE region 5A6D-5CB6 by apply_coverage
	; --split [executed in 1 scenarios]
	ldh a, [hBrowserDrawYOffset]
	ld c, a
	ldh a, [hBrowserDrawYOffset + 1]
	ld b, a
	ldh a, [hPageRender_ElemY]
	add a, c
	ldh [hPageRender_ElemY], a
	ldh a, [hPageRender_ElemYHi]
	adc a, b
	ldh [hPageRender_ElemYHi], a
	ldh a, [hPageRender_ElemBottom]
	add a, c
	ldh [hPageRender_ElemBottom], a
	ldh a, [hPageRender_ElemBottomHi]
	adc a, b
	ldh [hPageRender_ElemBottomHi], a
	ldh a, [hPageRender_ElemX]
	add a, $08
	ldh [hPageRender_ElemX], a
	ldh a, [hPageRender_ElemXHi]
	adc a, $00
	ldh [hPageRender_ElemXHi], a
	ldh a, [hPageRender_ElemRight]
	add a, $08
	ldh [hPageRender_ElemRight], a
	ldh a, [hPageRender_ElemRightHi]
	adc a, $00
	ldh [hPageRender_ElemRightHi], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld bc, $000B
	push hl
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	pop hl
	ld h, b
	ld l, c
	ldh a, [hRam_FFB0]
	call BankSwitch_H
	push hl
	inc hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ldh a, [hPageRender_ElemYHi]
	or a, a
	jr nz, .l5B26
	ld c, $00
	ldh a, [hPageRender_ElemY]
	ld e, a
	ldh a, [hPageRender_ElemBottom]
	sub a, e
	cp a, h
	jr c, .l5B22
	ld a, h
.l5B22 ; 4E:5B22
	ldh [hBmp_Height], a
	jr .l5B35

.l5B26 ; 4E:5B26
	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5A6D-5CB6 by apply_coverage --split
	ld e, $00
	ldh a, [hPageRender_ElemY]
	dec a
	cpl
	ld c, a
	ldh a, [hPageRender_ElemBottom]
	cp a, h
	jr c, .l5B33
	ld a, h
.l5B33 ; 4E:5B33
	ldh [hBmp_Height], a

.l5B35 ; 4E:5B35
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 5A6D-5CB6 by apply_coverage
	; --split [executed in 1 scenarios]
	ldh a, [hPageRender_ElemXHi]
	or a, a
	jr nz, .l5B4A
	ld b, $00
	ldh a, [hPageRender_ElemX]
	ld d, a
	ldh a, [hPageRender_ElemRight]
	sub a, d
	cp a, l
	jr c, .l5B46

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5A6D-5CB6 by apply_coverage --split
	ld a, l

.l5B46 ; 4E:5B46
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 5A6D-5CB6 by apply_coverage
	; --split [executed in 1 scenarios]
	ldh [hBmp_Width], a
	jr .l5B59

.l5B4A ; 4E:5B4A
	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5A6D-5CB6 by apply_coverage --split
	ld d, $00
	ldh a, [hPageRender_ElemX]
	dec a
	cpl
	ld b, a
	ldh a, [hPageRender_ElemRight]
	cp a, l
	jr c, .l5B57
	ld a, l
.l5B57 ; 4E:5B57
	ldh [hBmp_Width], a

.l5B59 ; 4E:5B59
	; [CONFIRMED] 272 insn(s) executed; cut out of the PROBABLE region 5A6D-5CB6 by apply_coverage
	; --split [executed in 1 scenarios] (part of region $5B59-$5CB6)
	pop hl
	ldh a, [hPageRender_BitmapColors]
	farcall Image_BlitToTileCanvas
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret
