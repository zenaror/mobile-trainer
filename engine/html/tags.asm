; engine/html/tags.asm
; bank 74, $44A0-$4F4F (2735 bytes); pinned by layout.link
; tag handler table and Html_Tag_* handlers

SECTION "engine/html/tags", ROMX

; ---- ptrtable $44A0-$44C4 (36 bytes) [CONFIRMED] 18-word jump table indexed by the HTML tag id: dispatcher at 74:4490-449F (add a,a; add a,$A0; ld l,a; adc a,$44; ld h,a; ld a,[hli]; ld b,[hl]; ld c,a; push bc; ret) - executed in the homepage/monkey traces, which read entries 44A2-44BE as data; all 18 targets are instruction starts of code regions: $4439, $4623, $44C4, $462E, $464A, $4718, $472E, $4B98, $4CA6, $4DF9, $4A91, $4A32, $47AA, $4867, $493F, $45D9, $4698, $4666

Html_TagHandlerTable:: ; 74:44A0
Table_74_44A0::
	dw Html_ParseSource_Tag_Ignore
	dw Html_Tag_Html
	dw Html_Tag_Title
	dw Html_Tag_Head
	dw Html_Tag_Body
	dw Html_Tag_Center
	dw Html_Tag_Div
	dw Html_Tag_Br
	dw Html_Tag_Hr
	dw Html_Tag_Img
	dw Html_Tag_A
	dw Html_Tag_B
	dw Html_Tag_Ul
	dw Html_Tag_Ol
	dw Html_Tag_Li
	dw Html_Tag_Comment
	dw Html_Tag_Meta
	dw Html_Tag_Pre

Html_Tag_Title:: ; 74:44C4
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 2/18 scenarios)
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jp z, Html_ParseSource_Tag_Ignore
	ld a, e
	ldh [hHtml_TitleStart], a
	ld a, d
	ldh [hHtml_TitleStartHi], a
	jp Html_ParseSource_Tag_Ignore

Html_ParseSource_TitleTag:: ; 74:44D4
	ld bc, Html_TitleTagPtrs
	push de
	call Html_MatchKeyword
	pop de
	or a, a
	jr z, .l44EB
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jr nz, .l44EB
	call Html_StoreTitle
	jp Html_ParseSource_Tag_Ignore

.l44EB ; 74:44EB
	; [PROBABLE] 40 insn(s) reached by static flow only; seeds: exec x40; min discovery hops 1;
	; entered by jrcc from 74:44DD (executed)
	ld a, $3C
	ld [de], a
	inc de
	ldh a, [hHtml_MatchRestart]
	ld l, a
	ldh a, [hHtml_MatchRestartHi]
	ld h, a
.loop ; 74:44F5
	call Sound_FrameService
	inc de
	inc de
	ld a, $E0
	cp a, d
	dec de
	dec de
	jp z, Html_ParseSource_End
	ld a, [hli]
	ld [de], a
	inc de
	or a, a
	jp z, Html_ParseSource_End
	cp a, $3E
	jp z, Html_ParseSource_Loop
	cp a, $81
	jr c, .l4526
	cp a, $A0
	jr c, .l4527
	cp a, $E0
	jr c, .l4526
	cp a, $F0
	jr c, .l4527
	cp a, $F8
	jr c, .l4526
	cp a, $FA
	jr c, .l4527
.l4526 ; 74:4526
	or a, a
.l4527 ; 74:4527
	jp nc, .loop
	ld a, [hli]
	ld [de], a
	inc de
	jp .loop

Html_StoreTitle:: ; 74:4530
Function_74_4530::
	; [CONFIRMED] 28 insn(s); 28 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ldh a, [hHtml_PageHeader]
	ld l, a
	ldh a, [hHtml_PageHeaderHi]
	ld h, a
	ldh a, [hHtml_PageBank]
	call BankSwitch_H
	ld a, [hl]
	or a, a
	ret nz
	ldh a, [hHtml_TitleStart]
	ld l, a
	ldh a, [hHtml_TitleStartHi]
	ld h, a
	ldh a, [hTextX]
	call BankSwitch_H
	push hl
	xor a, a
	ld c, a
	ld b, a
	ld e, a
	ld d, a
.loop ; 74:454F
	ld a, [hli]
	or a, a
	jr z, .l45AA
	cp a, $81
	jr c, .l456B
	cp a, $A0
	jr c, .l456C

	; [PROBABLE] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0;
	; fall-through of the jrcc at 74:4559 (executed) | 8 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 455B-456C by apply_coverage --split
	cp a, $E0
	jr c, .l456B
	cp a, $F0
	jr c, .l456C
	cp a, $F8
	jr c, .l456B
	cp a, $FA
	jr c, .l456C

.l456B ; 74:456B
	; [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 455B-456C by apply_coverage
	; --split [executed in 3 scenarios]
	or a, a

.l456C ; 74:456C
	; [CONFIRMED] 1 insn(s); 1 executed (in up to 2/18 scenarios)
	jp c, .l457A

	; [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0;
	; fall-through of the jpcc at 74:456C (executed) [executed in 1 scenarios]
	ld a, c
	cp a, $13
	jr nc, .l4587
	ld d, e
	ld e, b
	ld b, c
	inc c
	jr .loop

.l457A ; 74:457A
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 2/18 scenarios)
	ld a, c
	cp a, $13
	jr nc, .l4587
	ld a, [hli]
	ld d, e
	ld e, b
	ld b, c
	inc c
	inc c
	jr .loop

.l4587 ; 74:4587
	; [CONFIRMED] 23 insn(s) reached by static flow only; seeds: exec x23; min discovery hops 1;
	; entered by jrcc from 74:457D (executed) | 3 insn(s) executed; cut out of the PROBABLE region
	; 4587-45AA by apply_coverage --split [executed in 3 scenarios]
	ld a, b
	cp a, $13
	jr c, .l4592

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4587-45AA by apply_coverage --split
	ld a, e
	cp a, $13
	jr c, .l4592
	ld a, d

.l4592 ; 74:4592
	; [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 4587-45AA by apply_coverage
	; --split [executed in 3 scenarios]
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
	jr .l45B9

.l45AA ; 74:45AA
	; [CONFIRMED] 28 insn(s); 28 executed (in up to 2/18 scenarios)
	ld de, wHtmlTitleBuf
	pop hl
	ld a, c
	or a, a
	jr z, .l45B9
	ld b, $00
	push bc
	call CopyBytes
	pop bc
.l45B9 ; 74:45B9
	xor a, a
	ld [de], a
	ld hl, wHtmlTitleBuf
	ldh a, [hHtml_PageHeader]
	ld e, a
	ldh a, [hHtml_PageHeaderHi]
	ld d, a
	ldh a, [hHtml_PageBank]
	call BankSwitch_D
	inc bc
	call CopyBytes
	ldh a, [hHtml_TitleStart]
	ld e, a
	ldh a, [hHtml_TitleStartHi]
	ld d, a
	xor a, a
	ldh [hHtml_TitleStart], a
	ldh [hHtml_TitleStartHi], a
	ret

Html_Tag_Comment:: ; 74:45D9
	; [CONFIRMED] 39 insn(s) reached by static flow only; seeds: table x39; min discovery hops 0;
	; run starts at an entry of the code-pointer table at 74:44A0 | 11 insn(s) executed; cut out of
	; the PROBABLE region 45D9-4623 by apply_coverage --split [executed in 1 scenarios]
	ld a, [hli]
.l45DA ; 74:45DA
	or a, a
	jp z, Html_ParseSource_End
	cp a, $2D
	jr z, .l4604
	cp a, $3E
	jr z, .l461C
	cp a, $81
	jr c, .l45FE
	cp a, $A0
	jr c, .l45FF

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 45D9-4623 by apply_coverage --split
	cp a, $E0
	jr c, .l45FE
	cp a, $F0
	jr c, .l45FF
	cp a, $F8
	jr c, .l45FE
	cp a, $FA
	jr c, .l45FF

.l45FE ; 74:45FE
	; [CONFIRMED] 20 insn(s) executed; cut out of the PROBABLE region 45D9-4623 by apply_coverage
	; --split [executed in 1 scenarios]
	or a, a
.l45FF ; 74:45FF
	jr nc, Html_Tag_Comment
	ld a, [hli]
	jr Html_Tag_Comment
.l4604 ; 74:4604
	ld a, [hli]
	cp a, $2D
	jr nz, .l45DA
.l4609 ; 74:4609
	call Sound_FrameService
	ld a, [hli]
	or a, a
	jp z, Html_ParseSource_End
	cp a, $2D
	jr nz, .l4609
	ld a, [hli]
	cp a, $2D
	jr nz, .l4609
	jr Html_Tag_Comment
.l461C ; 74:461C
	ld a, $20
	ldh [hHtml_LastChar], a
	jp Html_ParseSource_Loop

Html_Tag_Html:: ; 74:4623
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios)
	ld a, [wHtmlFlags]
	or a, $01
	ld [wHtmlFlags], a
	jp Html_ParseSource_Tag_Ignore

Html_Tag_Head:: ; 74:462E
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jr z, .l463F
	ld a, [wHtmlFlags]
	or a, $02
	ld [wHtmlFlags], a
	jp Html_ParseSource_Tag_Ignore
.l463F ; 74:463F
	ld a, [wHtmlFlags]
	and a, $FD
	ld [wHtmlFlags], a
	jp Html_ParseSource_Tag_Ignore

Html_Tag_Body:: ; 74:464A
	; [PROBABLE] 83 insn(s) reached by static flow only; seeds: site x72, table x11; min discovery
	; hops 0; run starts at an entry of the code-pointer table at 74:44A0 | 11 insn(s) never
	; executed in the traced runs; cut out of the PROBABLE region 464A-4718 by apply_coverage
	; --split
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jr z, .l465B
	ld a, [wHtmlFlags]
	or a, $04
	ld [wHtmlFlags], a
	jp Html_ParseSource_Tag_Ignore
.l465B ; 74:465B
	ld a, [wHtmlFlags]
	and a, $FB
	ld [wHtmlFlags], a
	jp Html_ParseSource_Tag_Ignore

Html_Tag_Pre:: ; 74:4666
	; [CONFIRMED] 30 insn(s) executed; cut out of the PROBABLE region 464A-4718 by apply_coverage
	; --split [executed in 4 scenarios]
	farcall Html_Layout_WrapRun
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jr z, .l4683
	farcall Html_Layout_EndLine
	ld a, [wHtmlFlags]
	or a, $08
	ld [wHtmlFlags], a
	jp Html_ParseSource_Tag_Done
.l4683 ; 74:4683
	ld a, $0C
	ldh [hHtmlLayout_HeightBelow], a
	farcall Html_Layout_EndLine
	ld a, [wHtmlFlags]
	and a, $F7
	ld [wHtmlFlags], a
	jp Html_ParseSource_Tag_Done

Html_Tag_Meta:: ; 74:4698
	farcall Html_Layout_WrapRun
	farcall Html_Layout_EndLine
	ld a, [wHtmlFlags]
	and a, $02
	jp z, Html_ParseSource_Tag_Done
	ld bc, Html_MetaAttrPtrs
	call Html_ScanAttributes
	cp a, $01
	jr z, .l46C1
	cp a, $02
	jr z, .l46DE
	cp a, $03
	jr z, .l46FB
	jp Html_ParseSource_Tag_Done

.l46C1 ; 74:46C1
	; [PROBABLE] 42 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 464A-4718 by apply_coverage --split
	push hl
	push de
	ld hl, wAttrUrlBuf
	ld de, wHtmlMetaPppId
	ld bc, $0040
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call CopyBytes
	xor a, a
	ld [wHtmlMetaPppId + $3F], a
	pop de
	pop hl
	jp Html_ParseSource_Tag_Done
.l46DE ; 74:46DE
	push hl
	push de
	ld hl, wAttrUrlBuf
	ld de, wHtmlMetaRCode
	ld bc, $0040
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call CopyBytes
	xor a, a
	ld [wHtmlMetaRCode + $3F], a
	pop de
	pop hl
	jp Html_ParseSource_Tag_Done
.l46FB ; 74:46FB
	push hl
	push de
	ld hl, wAttrUrlBuf
	ld de, wHtmlMetaDCode
	ld bc, $0040
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call CopyBytes
	xor a, a
	ld [wHtmlMetaDCode + $3F], a
	pop de
	pop hl
	jp Html_ParseSource_Tag_Done

Html_Tag_Center:: ; 74:4718
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	farcall Html_Layout_WrapRun
	farcall Html_Layout_EndLine
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jr z, Html_AlignStack_Pop
	ld b, $08
	jr Html_AlignStack_Push

Html_Tag_Div:: ; 74:472E
	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: site x5; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	; [executed in 2 scenarios]
	farcall Html_Layout_WrapRun
	farcall Html_Layout_EndLine
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jr nz, Html_Tag_Div_ParseAlign

Html_AlignStack_Pop:: ; 74:4740
Label_74_4740::
	; [CONFIRMED] 17 insn(s); 17 executed (in up to 1/18 scenarios)
	ld a, [wHtmlAlignSp]
	ld [wHtmlAlign], a
	or a, a
	jp z, Html_ParseSource_Tag_Done
	push hl
	ld h, $D0
	ld l, a
	dec hl
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	ld [wHtmlAlign], a
	ld a, l
	ld [wHtmlAlignSp], a
	pop hl
	jp Html_ParseSource_Tag_Done

Html_Tag_Div_ParseAlign:: ; 74:4761
Label_74_4761::
	; [CONFIRMED] 20 insn(s) reached by static flow only; seeds: site x20; min discovery hops 1;
	; entered by jrcc from 74:473E (PROBABLE code) [executed in 1 scenarios]
	ld bc, Html_AlignAttrPtrs
	call Html_ScanAttributes
	or a, a
	jp z, Html_ParseSource_Tag_Done
	push de
	push hl
	ld hl, wAttrUrlBuf
	ld bc, Html_AlignValuePtrs
	ld a, l
	ldh [hHtml_MatchRestart], a
	ld a, h
	ldh [hHtml_MatchRestartHi], a
	call Html_MatchKeyword
	pop hl
	pop de
	or a, a
	jp z, Html_ParseSource_Tag_Done
	and a, $0C
	jp z, Html_ParseSource_Tag_Done
	ld b, a

Html_AlignStack_Push:: ; 74:4788
Label_74_4788::
	; [CONFIRMED] 71 insn(s); 71 executed (in up to 1/18 scenarios)
	ld a, [wHtmlAlignSp]
	cp a, $FF
	jp z, Html_ParseSource_Tag_Done
	push hl
	ld h, $D0
	ld l, a
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wHtmlAlign]
	ld [hli], a
	ld a, l
	ld [wHtmlAlignSp], a
	ld a, b
	ld [wHtmlAlign], a
	pop hl
	jp Html_ParseSource_Tag_Done

Html_Tag_Ul:: ; 74:47AA
	farcall Html_Layout_FlushListItem
	farcall Html_Layout_ListBlockBreak
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jr z, .l47F9
	push hl
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wHtmlListDepth]
	cp a, $FF
	jr z, .l47E0
	ld c, a
	ld b, $00
	inc a
	ld [wHtmlListDepth], a
	ld hl, wHtmlListStack
	add hl, bc
	add hl, bc
	ld a, [wHtmlListCounter]
	ld [hli], a
	ld a, [wHtmlListCounter + 1]
	or a, $80
	ld [hli], a
.l47E0 ; 74:47E0
	pop hl
	ld a, $00
	ld [wHtmlListCounter], a
	ld a, $3F
	ld [wHtmlListCounter + 1], a
	ldh a, [hHtmlListIndent]
	add a, $0C
	jp c, Html_ParseSource_Tag_Done
	ldh [hHtmlListIndent], a
	ldh [hHtmlLineIndent], a
	jp Html_ParseSource_Tag_Done
.l47F9 ; 74:47F9
	push hl
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wHtmlListDepth]
	dec a
	cp a, $FF
	jr z, .l4853
.loop ; 74:4808
	ld [wHtmlListDepth], a
	ld c, a
	ld b, $00
	ld hl, wHtmlListStack
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld c, a
	ld b, [hl]
	bit 7, b
	jr nz, .l4840

	; [PROBABLE] 20 insn(s) reached by static flow only; seeds: exec x20; min discovery hops 0;
	; fall-through of the jrcc at 74:4818 (executed)
	ld c, $0C
	bit 6, b
	jr z, .l4822
	ld c, $12
.l4822 ; 74:4822
	ldh a, [hHtmlListIndent]
	sub a, c
	jr nc, .l4828
	xor a, a
.l4828 ; 74:4828
	ldh [hHtmlListIndent], a
	ldh [hHtmlLineIndent], a
	ld a, [wHtmlListDepth]
	dec a
	cp a, $FF
	jr nz, .loop
	ld a, $01
	ld [wHtmlListDepth], a
	ld a, c
	ldh [hHtmlListIndent], a
	ldh [hHtmlLineIndent], a
	jr .l4853

.l4840 ; 74:4840
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	ld a, c
	ld [wHtmlListCounter], a
	ld a, b
	ld [wHtmlListCounter + 1], a
	ldh a, [hHtmlListIndent]
	sub a, $0C
	jr nc, .l484F

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 74:484C (executed)
	xor a, a

.l484F ; 74:484F
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios)
	ldh [hHtmlListIndent], a
	ldh [hHtmlLineIndent], a
.l4853 ; 74:4853
	ld a, [wHtmlListDepth]
	or a, a
	jr nz, .l4863
	ld a, $0C
	ldh [hHtmlLayout_HeightBelow], a
	farcall Html_Layout_EndLine
.l4863 ; 74:4863
	pop hl
	jp Html_ParseSource_Tag_Done

Html_Tag_Ol:: ; 74:4867
	; [CONFIRMED] 104 insn(s) reached by static flow only; seeds: site x104; min discovery hops 0;
	; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code |
	; 66 insn(s) executed; cut out of the PROBABLE region 4867-493F by apply_coverage --split
	; [executed in 1 scenarios]
	farcall Html_Layout_FlushListItem
	farcall Html_Layout_ListBlockBreak
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jr z, .l48D0
	farcall Html_CountListItems
	push hl
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wHtmlListDepth]
	cp a, $FF
	jr z, .l48AE
	ld c, a
	ld b, $00
	inc a
	ld [wHtmlListDepth], a
	ld hl, wHtmlListStack
	add hl, bc
	add hl, bc
	ld c, $00
	ldh a, [hHtmlCount_ListItems]
	cp a, $0A
	jr c, .l48A3
	ld c, $40
.l48A3 ; 74:48A3
	ld a, [wHtmlListCounter]
	ld [hli], a
	ld a, [wHtmlListCounter + 1]
	and a, $7F
	or a, c
	ld [hli], a
.l48AE ; 74:48AE
	pop hl
	ld c, $0C
	ldh a, [hHtmlCount_ListItems]
	cp a, $0A
	jr c, .l48B9
	ld c, $12
.l48B9 ; 74:48B9
	ld a, $01
	ld [wHtmlListCounter], a
	ld a, $00
	ld [wHtmlListCounter + 1], a
	ldh a, [hHtmlListIndent]
	add a, c
	jp c, Html_ParseSource_Tag_Done
	ldh [hHtmlListIndent], a
	ldh [hHtmlLineIndent], a
	jp Html_ParseSource_Tag_Done
.l48D0 ; 74:48D0
	push hl
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wHtmlListDepth]
	dec a
	cp a, $FF
	jr z, .l492B
.loop ; 74:48DF
	ld [wHtmlListDepth], a
	ld c, a
	ld b, $00
	ld hl, wHtmlListStack
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld c, a
	ld b, [hl]
	bit 7, b
	jr z, .l4911

	; [PROBABLE] 16 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4867-493F by apply_coverage --split
	ldh a, [hHtmlListIndent]
	sub a, $0C
	jr nc, .l48F8
	xor a, a
.l48F8 ; 74:48F8
	ldh [hHtmlListIndent], a
	ldh [hHtmlLineIndent], a
	ld a, [wHtmlListDepth]
	dec a
	cp a, $FF
	jr nz, .loop
	ld a, $01
	ld [wHtmlListDepth], a
	ld a, $0C
	ldh [hHtmlListIndent], a
	ldh [hHtmlLineIndent], a
	jr .l492B

.l4911 ; 74:4911
	; [CONFIRMED] 22 insn(s) executed; cut out of the PROBABLE region 4867-493F by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, c
	ld [wHtmlListCounter], a
	ld a, b
	ld [wHtmlListCounter + 1], a
	ld c, $0C
	bit 6, b
	jr z, .l4921
	ld c, $12
.l4921 ; 74:4921
	ldh a, [hHtmlListIndent]
	sub a, c
	jr nc, .l4927
	xor a, a
.l4927 ; 74:4927
	ldh [hHtmlListIndent], a
	ldh [hHtmlLineIndent], a
.l492B ; 74:492B
	ld a, [wHtmlListDepth]
	or a, a
	jr nz, .l493B
	ld a, $0C
	ldh [hHtmlLayout_HeightBelow], a
	farcall Html_Layout_EndLine
.l493B ; 74:493B
	pop hl
	jp Html_ParseSource_Tag_Done

Html_Tag_Li:: ; 74:493F
	; [CONFIRMED] 41 insn(s); 41 executed (in up to 1/18 scenarios)
	farcall Html_Layout_FlushListItem
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jr z, Html_Tag_Li_Close
	ld a, [wHtmlListCounter]
	ld c, a
	ld a, [wHtmlListCounter + 1]
	and a, $3F
	ld b, a
	cp a, $3F
	jr nz, Html_Tag_Li_Number

Html_Tag_Li_Bullet:: ; 74:4959
Label_74_4959::
	inc de
	inc de
	ld a, $E0
	cp a, d
	dec de
	dec de
	jp z, .l4973
	ld a, $95
	add a, c
	ld c, a
	ld a, $49
	adc a, $00
	ld b, a
	ld a, [bc]
	ld [de], a
	inc de
	inc bc
	ld a, [bc]
	ld [de], a
	inc de
.l4973 ; 74:4973
	ldh a, [hHtmlLineIndent]
	sub a, $0C
	jr nc, .skip
	xor a, a
.skip ; 74:497A
	ldh [hHtmlLineIndent], a
	ld a, e
	ld [wRam_C331], a
	ld a, d
	ld [wRam_C331], a
	jp Html_ParseSource_Tag_Done

Html_Tag_Li_Close:: ; 74:4987
Label_74_4987::
	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 1;
	; entered by jrcc from 74:4949 (executed)
	ldh a, [hHtmlListIndent]
	ldh [hHtmlLineIndent], a
	xor a, a
	ld [wRam_C331], a
	ld [wRam_C331], a
	jp Html_ParseSource_Tag_Done

; ---- data $4995-$4997 (2 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Html_ListBullet:: ; 74:4995
Data_74_4995::
	db $81, $45

Html_Tag_Li_Number:: ; 74:4997
Label_74_4997::
	; [CONFIRMED] 94 insn(s) reached by static flow only; seeds: exec x94; min discovery hops 1;
	; entered by jrcc from 74:4957 (executed) | 38 insn(s) executed; cut out of the PROBABLE region
	; 4997-4A32 by apply_coverage --split [executed in 5 scenarios]
	or a, c
	jr z, Html_Tag_Li_Bullet
	inc de
	inc de
	inc de
	inc de
	ld a, $E0
	cp a, d
	dec de
	dec de
	dec de
	dec de
	jp z, Html_ParseSource_Tag_Done
	push bc
	push hl
	ld h, b
	ld l, c
	ld bc, $FF9C
	ld a, $FF
.l49B1 ; 74:49B1
	inc a
	add hl, bc
	bit 7, h
	jr z, .l49B1
	ld bc, $0064
	add hl, bc
	or a, a
	jr nz, .l49D2
	ld bc, $FFF6
	ld a, $FF
.l49C3 ; 74:49C3
	inc a
	add hl, bc
	bit 7, h
	jr z, .l49C3
	ld bc, $000A
	add hl, bc
	or a, a
	jr nz, .l49EE
	jr .l49FB

.l49D2 ; 74:49D2
	; [PROBABLE] 16 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4997-4A32 by apply_coverage --split
	add a, $30
	ld [de], a
	inc de
	ldh a, [hHtmlLineIndent]
	sub a, $06
	jr nc, .l49DD
	xor a, a
.l49DD ; 74:49DD
	ldh [hHtmlLineIndent], a
	ld bc, $FFF6
	ld a, $FF
.l49E4 ; 74:49E4
	inc a
	add hl, bc
	bit 7, h
	jr z, .l49E4
	ld bc, $000A
	add hl, bc

.l49EE ; 74:49EE
	; [CONFIRMED] 25 insn(s) executed; cut out of the PROBABLE region 4997-4A32 by apply_coverage
	; --split [executed in 1 scenarios]
	add a, $30
	ld [de], a
	inc de
	ldh a, [hHtmlLineIndent]
	sub a, $06
	jr nc, .l49F9
	xor a, a
.l49F9 ; 74:49F9
	ldh [hHtmlLineIndent], a
.l49FB ; 74:49FB
	ld a, l
	add a, $30
	ld [de], a
	inc de
	ld a, $2E
	ld [de], a
	inc de
	pop hl
	ldh a, [hHtmlLineIndent]
	sub a, $0C
	jr nc, .l4A0C
	xor a, a
.l4A0C ; 74:4A0C
	ldh [hHtmlLineIndent], a
	pop bc
	ld a, c
	cp a, $63
	jr nz, .l4A19

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4997-4A32 by apply_coverage --split
	ld a, b
	cp a, $00
	jr z, .l4A27

.l4A19 ; 74:4A19
	; [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 4997-4A32 by apply_coverage
	; --split [executed in 5 scenarios]
	inc bc
	ld a, c
	ld [wHtmlListCounter], a
	ld a, [wHtmlListCounter + 1]
	and a, $C0
	or a, b
	ld [wHtmlListCounter + 1], a
.l4A27 ; 74:4A27
	ld a, e
	ld [wRam_C331], a
	ld a, d
	ld [wRam_C331], a
	jp Html_ParseSource_Tag_Done

Html_Tag_B:: ; 74:4A32
	; [CONFIRMED] 51 insn(s); 51 executed (in up to 2/18 scenarios)
	farcall Html_Layout_WrapRun
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jr nz, .l4A6D
	ld a, [wHtmlBoldCount]
	ld c, a
	ld a, [wHtmlBoldCount + 1]
	or a, c
	jp z, Html_ParseSource_Tag_Done
	ld a, [wHtmlBoldCount]
	sub a, $01
	ld [wHtmlBoldCount], a
	ld a, [wHtmlBoldCount + 1]
	sbc a, $00
	ld [wHtmlBoldCount + 1], a
	ldh a, [hHtml_RecordFlags]
	and a, $03
	cp a, $02
	jp nz, Html_ParseSource_Tag_Done
	ldh a, [hHtml_RecordFlags]
	and a, $FC
	or a, $00
	ldh [hHtml_RecordFlags], a
	jp Html_ParseSource_Tag_Done
.l4A6D ; 74:4A6D
	ld a, [wHtmlBoldCount]
	add a, $01
	ld [wHtmlBoldCount], a
	ld a, [wHtmlBoldCount + 1]
	adc a, $00
	ld [wHtmlBoldCount + 1], a
	ldh a, [hHtml_RecordFlags]
	and a, $03
	cp a, $01
	jp z, Html_ParseSource_Tag_Done
	ldh a, [hHtml_RecordFlags]
	and a, $FC
	or a, $02
	ldh [hHtml_RecordFlags], a
	jp Html_ParseSource_Tag_Done

Html_Tag_A:: ; 74:4A91
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jr nz, .l4AD5
	ldh a, [hHtmlLinkTextStart]
	ld c, a
	ldh a, [hHtmlLinkTextStartHi]
	ld b, a
	or a, c
	jr z, .l4AB8
	ld a, e
	cp a, c
	jr nz, .l4AB8

	; [PROBABLE] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 0;
	; fall-through of the jrcc at 74:4AA2 (executed)
	ld a, d
	cp a, b
	jr nz, .l4AB8
	ldh a, [hHtml_RecordFlags]
	and a, $03
	cp a, $01
	jp nz, .l4AB8
	ldh a, [hHtml_LinkNumber]
	dec a
	ldh [hHtml_LinkNumber], a
	jr .l4ABE

.l4AB8 ; 74:4AB8
	; [CONFIRMED] 17 insn(s); 17 executed (in up to 2/18 scenarios)
	farcall Html_Layout_WrapRun
.l4ABE ; 74:4ABE
	ldh a, [hHtml_RecordFlags]
	and a, $03
	cp a, $01
	jp nz, Html_ParseSource_Tag_Done
	ldh a, [hHtml_RecordFlags]
	and a, $FC
	ldh [hHtml_RecordFlags], a
	xor a, a
	ldh [hHtmlLinkTextStart], a
	ldh [hHtmlLinkTextStartHi], a
	jp Html_ParseSource_Tag_Done
.l4AD5 ; 74:4AD5
	farcall Html_Layout_WrapRun
	ld bc, Html_AnchorAttrPtrs
	call Html_ScanAttributes
	cp a, $01
	jr z, .l4B21

	; [CONFIRMED] 29 insn(s) reached by static flow only; seeds: exec x29; min discovery hops 0;
	; fall-through of the jrcc at 74:4AE3 (executed) [executed in 3 scenarios]
	cp a, $02
	jp nz, Html_ParseSource_Tag_Done
	push de
	push hl
	ld a, [wHtmlLinkHeapPtr]
	ld e, a
	ld a, [wHtmlLinkHeapPtr + 1]
	ld d, a
	cp a, $E0
	jp z, .l4B81
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $23
	ld [de], a
	ld hl, $DFFE ; raw: string limit of the link heap, two bytes below the end of wHtmlLinkHeap (the Y position of a #name follows the string), compared with the write pointer and never dereferenced
	ld bc, wHtmlLinkPtrList
	farcall Html_StringTable_Add
	or a, a
	jr nz, .l4B6D
	ldh a, [hHtmlLayout_LineY]
	ld [hli], a
	ldh a, [hHtmlLayout_LineYHi]
	ld [hli], a
	ld a, l
	ld [wHtmlLinkHeapPtr], a
	ld a, h
	ld [wHtmlLinkHeapPtr + 1], a
	jr .l4B6D

.l4B21 ; 74:4B21
	; [CONFIRMED] 49 insn(s); 49 executed (in up to 2/18 scenarios)
	ldh a, [hHtml_RecordFlags]
	and a, $FC
	or a, $01
	ldh [hHtml_RecordFlags], a
	ldh a, [hHtml_LinkNumber]
	inc a
	ldh [hHtml_LinkNumber], a
	push de
	push hl
	ld a, [wHtmlLinkHeapPtr]
	ld e, a
	ld a, [wHtmlLinkHeapPtr + 1]
	ld d, a
	cp a, $E0
	jr z, .l4B81
	push bc
	push de
	ld hl, wAttrUrlBuf
	farcall HtmlUrl_GetSchemeId
	pop de
	pop bc
	cp a, $FF
	jr z, .l4B81
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $2F
	ld [de], a
	ld hl, $DFFE ; raw: string limit of the link heap, two bytes below the end of wHtmlLinkHeap (the Y position of a #name follows the string), compared with the write pointer and never dereferenced
	ld bc, wHtmlLinkPtrList
	farcall Html_StringTable_Add
	or a, a
	jr nz, .l4B6D
	ld a, l
	ld [wHtmlLinkHeapPtr], a
	ld a, h
	ld [wHtmlLinkHeapPtr + 1], a
.l4B6D ; 74:4B6D
	ld a, d
	inc d
	jr z, .l4B81
	ld a, e
	ldh [hHtml_LinkTableIndex], a
	pop hl
	pop de
	ldh a, [hHtml_RunStartLo]
	ldh [hHtmlLinkTextStart], a
	ldh a, [hTextY]
	ldh [hHtmlLinkTextStartHi], a
	jp Html_ParseSource_Tag_Done

.l4B81 ; 74:4B81
	; [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 1;
	; entered by jrcc from 74:4B3A (executed) [executed in 1 scenarios]
	pop hl
	pop de
	ldh a, [hHtml_RecordFlags]
	and a, $FC
	ldh [hHtml_RecordFlags], a
	ldh a, [hHtml_LinkNumber]
	dec a
	ldh [hHtml_LinkNumber], a
	xor a, a
	ldh [hHtml_LinkTableIndex], a
	ldh [hHtmlLinkTextStart], a
	ldh [hHtmlLinkTextStartHi], a
	jp Html_ParseSource_Tag_Done

Html_Tag_Br:: ; 74:4B98
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 2/18 scenarios)
	ld bc, Html_BrAttrPtrs
	call Html_ScanAttributes
	or a, a
	jr z, .l4BB9

	; [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 0;
	; fall-through of the jrcc at 74:4B9F (executed) | 13 insn(s) executed; cut out of the PROBABLE
	; region 4BA1-4BB9 by apply_coverage --split [executed in 1 scenarios]
	push de
	push hl
	ld hl, wAttrUrlBuf
	ld bc, Html_ClearValuePtrs
	ld a, l
	ldh [hHtml_MatchRestart], a
	ld a, h
	ldh [hHtml_MatchRestartHi], a
	call Html_MatchKeyword
	pop hl
	pop de
	cp a, $04
	jr c, .l4BB9

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4BA1-4BB9 by apply_coverage --split
	xor a, a

.l4BB9 ; 74:4BB9
	; [CONFIRMED] 16 insn(s); 16 executed (in up to 2/18 scenarios)
	ld [wHtmlBrClear], a
	ldh a, [hHtml_RunStartLo]
	ld c, a
	ldh a, [hTextY]
	ld b, a
	ld a, e
	cp a, c
	jr nz, .l4BD8
	ld a, d
	cp a, b
	jr nz, .l4BD8
	ldh a, [hHtmlLayout_HeightAbove]
	ld c, a
	ldh a, [hHtmlLayout_HeightBelow]
	or a, c
	jr nz, .l4BD8

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 74:4BD0 (executed) [executed in 1 scenarios]
	ld a, $0C
	ldh [hHtmlLayout_HeightBelow], a
	jr Html_Tag_Br_EndLine

.l4BD8 ; 74:4BD8
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)
	farcall Html_Layout_WrapRun

Html_Tag_Br_EndLine:: ; 74:4BDE
Label_74_4BDE::
	farcall Html_Layout_EndLine
	push de
	push hl
	ld a, [wHtmlBrClear]
	call JumpTableInline

; ---- ptrtable $4BEC-$4BF4 (8 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 74:4BE9: 4 entries; end = first entry target

Html_BrClearJumpTable:: ; 74:4BEC
Table_74_4BEC::
	dw Html_Tag_Br_Done
	dw Html_Tag_Br_ClearLeft
	dw Html_Tag_Br_ClearRight
	dw Html_Tag_Br_ClearAll

Html_Tag_Br_ClearLeft:: ; 74:4BF4
Label_74_4BF4::
	; [CONFIRMED] 31 insn(s) reached by static flow only; seeds: exec x31; min discovery hops 1;
	; entered by table from 74:4BE9 (executed) [executed in 1 scenarios]
	; [CONFIRMED] a <br clear=left> inside a list never ends (scenario browser_brl: 67,805 calls, 67,803 retries through Html_Tag_Br_ClearRetry, blank screen, buttons do nothing;
	; controls in browser_brc: outside a list and after a closed list it runs twice and returns).  Same mechanism as Html_Layout_ClearAllFloats: the test compares
	; hHtmlLayout_CursorX with hViewX and GetLimitsAtY adds the indent of the list to it.
	ldh a, [hHtmlLayout_LineY]
	ld e, a
	ldh a, [hHtmlLayout_LineYHi]
	ld d, a
	farcall Html_Layout_GetLimitsAtY
	ldh a, [hViewX]
	ld e, a
	ldh a, [hViewX + 1]
	ld d, a
	ldh a, [hHtmlLayout_CursorX]
	cp a, e
	jr nz, Html_Tag_Br_ClearRetry
	ldh a, [hHtmlLayout_CursorXHi]
	cp a, d
	jr nz, Html_Tag_Br_ClearRetry
	jr Html_Tag_Br_Done

Html_Tag_Br_ClearRight:: ; 74:4C12
Label_74_4C12::
	ldh a, [hHtmlLayout_LineY]
	ld e, a
	ldh a, [hHtmlLayout_LineYHi]
	ld d, a
	farcall Html_Layout_GetLimitsAtY
	ldh a, [hViewRight]
	ld e, a
	ldh a, [hViewRight + 1]
	ld d, a
	ldh a, [hHtmlLayout_RightLimit]
	cp a, e
	jr nz, Html_Tag_Br_ClearRetry
	ldh a, [hHtmlLayout_RightLimitHi]
	cp a, d
	jr nz, Html_Tag_Br_ClearRetry

Html_Tag_Br_Done:: ; 74:4C2E
Label_74_4C2E::
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)
	pop hl
	pop de
	jp Html_ParseSource_Tag_Done

Html_Tag_Br_ClearAll:: ; 74:4C33
Label_74_4C33::
	; [CONFIRMED] 63 insn(s) reached by static flow only; seeds: exec x63; min discovery hops 1;
	; entered by table from 74:4BE9 (executed) | 25 insn(s) executed; cut out of the PROBABLE region
	; 4C33-4CA6 by apply_coverage --split [executed in 1 scenarios]
	; [CONFIRMED] a <br clear=all> inside a list never ends (scenario browser_bra: 67,777 calls, 67,776 retries; same mechanism as Html_Tag_Br_ClearLeft); <br clear=right> inside a list
	; (Html_Tag_Br_ClearRight) is not affected (browser_brc).
	ldh a, [hHtmlLayout_LineY]
	ld e, a
	ldh a, [hHtmlLayout_LineYHi]
	ld d, a
	farcall Html_Layout_GetLimitsAtY
	ldh a, [hViewX]
	ld e, a
	ldh a, [hViewX + 1]
	ld d, a
	ldh a, [hHtmlLayout_CursorX]
	cp a, e
	jr nz, Html_Tag_Br_ClearRetry
	ldh a, [hHtmlLayout_CursorXHi]
	cp a, d
	jr nz, Html_Tag_Br_ClearRetry
	ldh a, [hViewRight]
	ld e, a
	ldh a, [hViewRight + 1]
	ld d, a
	ldh a, [hHtmlLayout_RightLimit]
	cp a, e
	jr nz, Html_Tag_Br_ClearRetry
	ldh a, [hHtmlLayout_RightLimitHi]
	cp a, d
	jr z, Html_Tag_Br_Done

Html_Tag_Br_ClearRetry:: ; 74:4C5F
Label_74_4C5F::
	; [CONFIRMED] 7 insn(s) executed (browser_brl, browser_bra: the retry of a <br clear=left|all> inside a list, over 67,000 times each); cut out of the PROBABLE region
	; 4C33-4CA6 by apply_coverage --split
	pop hl
	pop de
	ld a, $0C
	ldh [hHtmlLayout_HeightBelow], a
	xor a, a
	ldh [hHtmlLayout_HeightAbove], a
	jp Html_Tag_Br_EndLine

Html_ParseSource_PreCR:: ; 74:4C6B
	; [CONFIRMED] 31 insn(s) executed; cut out of the PROBABLE region 4C33-4CA6 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, [hl]
	cp a, $0A
	jr nz, Html_ParseSource_PreLineBreak
	inc hl

Html_ParseSource_PreLineBreak:: ; 74:4C71
Label_74_4C71::
	ld a, l
	ldh [hHtml_MatchRestart], a
	ld a, h
	ldh [hHtml_MatchRestartHi], a
	ldh a, [hHtml_RunStartLo]
	ld c, a
	ldh a, [hTextY]
	ld b, a
	ld a, e
	cp a, c
	jr nz, .l4C93
	ld a, d
	cp a, b
	jr nz, .l4C93
	ldh a, [hHtmlLayout_HeightAbove]
	ld c, a
	ldh a, [hHtmlLayout_HeightBelow]
	or a, c
	jr nz, .l4C93
	ld a, $0C
	ldh [hHtmlLayout_HeightBelow], a
	jr .l4C99
.l4C93 ; 74:4C93
	farcall Html_Layout_WrapRun
.l4C99 ; 74:4C99
	farcall Html_Layout_EndLine
	ld a, $20
	ldh [hHtml_LastChar], a
	jp Html_ParseSource_Loop

Html_Tag_Hr:: ; 74:4CA6
	; [CONFIRMED] 22 insn(s); 22 executed (in up to 2/18 scenarios)
	farcall Html_Layout_WrapRun
	farcall Html_Layout_EndLine
	ld a, [wHtmlAlign]
	push af
	ldh a, [hViewX]
	ld c, a
	ldh a, [hViewRight]
	sub a, c
	ld c, a
	ldh a, [hViewX + 1]
	ld b, a
	ldh a, [hViewRight + 1]
	sbc a, b
	ld b, a
	push bc
	ld bc, Html_HrAttrPtrs
	call Html_ScanAttributes
	pop bc
	push hl
	push de
	or a, a
	jr z, .l4CF2

	; [CONFIRMED] 16 insn(s) reached by static flow only; seeds: exec x16; min discovery hops 0;
	; fall-through of the jrcc at 74:4CCF (executed) | 7 insn(s) executed; cut out of the PROBABLE
	; region 4CD1-4CF2 by apply_coverage --split [executed in 3 scenarios]
	push bc
	ld hl, wAttrUrlBuf
	farcall Html_ParseDecimal
	inc c
	dec c
	pop bc
	jr z, .l4CE2

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CD1-4CF2 by apply_coverage --split
	jr .l4CF2

.l4CE2 ; 74:4CE2
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 4CD1-4CF2 by apply_coverage
	; --split [executed in 1 scenarios]
	cp a, $25
	jr nz, .l4CF0
	farcall Multiply16
	ld b, h
	ld c, l
	jr .l4CF2
.l4CF0 ; 74:4CF0
	ld b, d
	ld c, e

.l4CF2 ; 74:4CF2
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 2/18 scenarios)
	push bc
	ldh a, [hHtmlLayout_LineY]
	ld e, a
	ldh a, [hHtmlLayout_LineYHi]
	ld d, a
	farcall Html_Layout_GetLimitsAtY
	ldh a, [hHtmlLayout_CursorX]
	ld c, a
	ldh a, [hHtmlLayout_RightLimit]
	sub a, c
	ldh [hHtmlTag_HrFreeWidth], a
	ldh a, [hHtmlLayout_CursorXHi]
	ld b, a
	ldh a, [hHtmlLayout_RightLimitHi]
	sbc a, b
	ldh [hHtmlTag_HrFreeWidthHi], a
	pop hl
	ldh a, [hHtmlTag_HrFreeWidth]
	sub a, l
	ldh a, [hHtmlTag_HrFreeWidthHi]
	sbc a, h
	ld de, $FFF4
	ld bc, $FFFF
	jr nc, .l4D24

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 74:4D1C (executed) [executed in 3 scenarios]
	ldh a, [hHtmlTag_HrFreeWidth]
	ld l, a
	ldh a, [hHtmlTag_HrFreeWidthHi]
	ld h, a

.l4D24 ; 74:4D24
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios)
	ld a, l
	or a, h
	jr z, .l4D2C
	inc bc
	add hl, de
	jr c, .l4D24
.l4D2C ; 74:4D2C
	push hl
	ld a, [wHtmlAlign]
	and a, $0C
	jr nz, .l4D40
	ld a, [wHtmlAlign]
	and a, $F3
	or a, $08
	ld [wHtmlAlign], a
	jr .l4D44

.l4D40 ; 74:4D40
	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by jrcc from 74:4D32 (executed)
	cp a, $0C
	jr z, .l4D4D

.l4D44 ; 74:4D44
	; [CONFIRMED] 77 insn(s); 77 executed (in up to 2/18 scenarios)
	dec hl
	ld a, l
	cpl
	ldh [hHtmlAlignAdjust], a
	ld a, h
	cpl
	ldh [hHtmlAlignAdjustHi], a
.l4D4D ; 74:4D4D
	pop hl
	ld de, $83E6
	add hl, de
	pop de
	ldh a, [hTextX]
	call BankSwitch_D
	inc c
	dec c
	jr z, .l4D73
.l4D5C ; 74:4D5C
	inc de
	inc de
	inc de
	ld a, $E0
	cp a, d
	dec de
	dec de
	dec de
	jp z, .l4D8E
	ld a, $83
	ld [de], a
	inc de
	ld a, $E6
	ld [de], a
	inc de
	dec c
	jr nz, .l4D5C
.l4D73 ; 74:4D73
	inc de
	inc de
	inc de
	ld a, $E0
	cp a, d
	dec de
	dec de
	dec de
	jp z, .l4D8E
	ld a, l
	cp a, $DB
	jr c, .l4D8E
	cp a, $E7
	jr nc, .l4D8E
	ld a, h
	ld [de], a
	inc de
	ld a, l
	ld [de], a
	inc de
.l4D8E ; 74:4D8E
	xor a, a
	ld [de], a
	inc de
	pop hl
	ldh a, [hHtml_RecordFlags]
	push af
	and a, $FC
	ldh [hHtml_RecordFlags], a
	farcall Html_Layout_WrapRun
	farcall Html_Layout_EndLine
	xor a, a
	ldh [hHtmlAlignAdjust], a
	ldh [hHtmlAlignAdjustHi], a
	pop af
	ldh [hHtml_RecordFlags], a
	pop af
	ld [wHtmlAlign], a
	ld a, $20
	ldh [hHtml_LastChar], a
.l4DB5 ; 74:4DB5
	ld a, [hli]
	or a, a
	jp z, Html_ParseSource_End
	cp a, $3E
	jr z, .l4DE8

	; [PROBABLE] 20 insn(s) reached by static flow only; seeds: exec x20; min discovery hops 0;
	; fall-through of the jrcc at 74:4DBC (executed)
	cp a, $81
	jr c, .l4DD6
	cp a, $A0
	jr c, .l4DD7
	cp a, $E0
	jr c, .l4DD6
	cp a, $F0
	jr c, .l4DD7
	cp a, $F8
	jr c, .l4DD6
	cp a, $FA
	jr c, .l4DD7
.l4DD6 ; 74:4DD6
	or a, a
.l4DD7 ; 74:4DD7
	jp nc, .l4DDE
	ld a, [hli]
	jp .l4DB5
.l4DDE ; 74:4DDE
	dec hl
	ld bc, Html_NoKeywords
	call Html_ScanAttributes
	jp .l4DB5

.l4DE8 ; 74:4DE8
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 2/18 scenarios)
	ld a, [hl]
	cp a, $0D
	jp nz, .skip
	inc hl
	ld a, [hl]
.skip ; 74:4DF0
	cp a, $0A
	jp nz, Html_ParseSource_Loop
	inc hl
	jp Html_ParseSource_Loop

Html_Tag_Img:: ; 74:4DF9
	; [CONFIRMED] 180 insn(s) reached by static flow only; seeds: site x164, table x16; min
	; discovery hops 0; run starts at an entry of the code-pointer table at 74:44A0 | 46 insn(s)
	; executed; cut out of the PROBABLE region 4DF9-4F4F by apply_coverage --split [executed in 2
	; scenarios]
	ld a, [wHtmlScanOnly]
	or a, a
	jp nz, .l4F09
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jp z, Html_ParseSource_Tag_Done
	xor a, a
	ldh [hHtml_ImageData], a
	ldh [hHtml_ImageDataHi], a
	ldh [hHtml_ImageBank], a
	ldh [hHtml_ImageAlign], a
	ldh [hBmp_Width], a
	ldh [hBmp_Height], a
.l4E14 ; 74:4E14
	ld bc, Html_ImgAttrPtrs
	call Html_ScanAttributes
	cp a, $01
	jp z, .l4E6B
	cp a, $02
	jp z, .l4EB1
	push de
	push hl
	ldh a, [hHtml_ImageData]
	ld l, a
	ldh a, [hHtml_ImageDataHi]
	ld h, a
	ldh a, [hHtml_ImageBank]
	or a, h
	or a, l
	jp z, .l4ECD
	ldh a, [hHtml_ImageBank]
	farcall Html_NextResourceRecord
	farcall Bmp_Validate
	or a, a
	jp z, .l4ECD
	pop hl
	pop de
	farcall Html_Layout_WrapRun
	push de
	push hl
	ldh a, [hHtml_RecordFlags]
	push af
	and a, $03
	ld c, a
	ldh a, [hHtml_ImageAlign]
	or a, a
	jr z, .l4E5D

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4DF9-4F4F by apply_coverage --split
	or a, c
	ldh [hHtml_RecordFlags], a

.l4E5D ; 74:4E5D
	; [CONFIRMED] 47 insn(s) executed; cut out of the PROBABLE region 4DF9-4F4F by apply_coverage
	; --split [executed in 1 scenarios]
	farcall Html_Layout_PlaceImage
	pop af
	ldh [hHtml_RecordFlags], a
	pop hl
	pop de
	jp Html_ParseSource_Tag_Done
.l4E6B ; 74:4E6B
	push hl
	push de
	ld hl, sBrowserPageBuf
.l4E70 ; 74:4E70
	ld a, $03
	farcall Html_NextResourceRecord
	inc de
	inc de
	ld a, [de]
	or a, a
	jr z, .l4E9E
	ld hl, wAttrUrlBuf
.l4E81 ; 74:4E81
	ld a, [hli]
	ld c, a
	ld a, [de]
	inc de
	or a, a
	jr z, .l4E94
	cp a, c
	jr z, .l4E81
.l4E8B ; 74:4E8B
	ld a, [de]
	inc de
	or a, a
	jr nz, .l4E8B
	ld h, d
	ld l, e
	jr .l4E70
.l4E94 ; 74:4E94
	ld a, e
	ldh [hHtml_ImageData], a
	ld a, d
	ldh [hHtml_ImageDataHi], a
	ld a, $03
	ldh [hHtml_ImageBank], a
.l4E9E ; 74:4E9E
	pop de
	pop hl
	ldh a, [hHtml_SourceBank]
	call BankSwitch_H
	ldh a, [hTextX]
	call BankSwitch_D
	ld a, $20
	ldh [hHtml_LastChar], a
	jp .l4E14

.l4EB1 ; 74:4EB1
	; [PROBABLE] 15 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4DF9-4F4F by apply_coverage --split
	push hl
	push de
	ld hl, wAttrUrlBuf
	ld bc, Html_AlignValuePtrs
	ld a, l
	ldh [hHtml_MatchRestart], a
	ld a, h
	ldh [hHtml_MatchRestartHi], a
	call Html_MatchKeyword
	or a, a
	jr z, .l4E9E
	cp a, $08
	jr z, .l4E9E
	ldh [hHtml_ImageAlign], a
	jr .l4E9E

.l4ECD ; 74:4ECD
	; [CONFIRMED] 28 insn(s) executed; cut out of the PROBABLE region 4DF9-4F4F by apply_coverage
	; --split [executed in 1 scenarios]
	pop hl
	pop de
	farcall Html_Layout_WrapRun
	ldh a, [hTextX]
	call BankSwitch_D
	inc de
	inc de
	ld a, $E0
	cp a, d
	dec de
	dec de
	jp z, .l4EEF
	ld a, $82
	ld [de], a
	inc de
	ld a, $45
	ld [de], a
	inc de
	xor a, a
	ld [de], a
	inc de
.l4EEF ; 74:4EEF
	ldh a, [hHtml_RecordFlags]
	push af
	and a, $03
	ld c, a
	ldh a, [hHtml_ImageAlign]
	or a, a
	jr z, .l4EFD

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4DF9-4F4F by apply_coverage --split
	or a, c
	ldh [hHtml_RecordFlags], a

.l4EFD ; 74:4EFD
	; [CONFIRMED] 40 insn(s) executed; cut out of the PROBABLE region 4DF9-4F4F by apply_coverage
	; --split [executed in 1 scenarios]
	farcall Html_Layout_WrapRun
	pop af
	ldh [hHtml_RecordFlags], a
	jp Html_ParseSource_Tag_Done
.l4F09 ; 74:4F09
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jp z, Html_ParseSource_Tag_Done
.l4F10 ; 74:4F10
	ld bc, Html_ImgAttrPtrs
	call Html_ScanAttributes
	or a, a
	jp z, Html_ParseSource_Tag_Done
	cp a, $01
	jp nz, .l4F10
	push hl
	push de
	ldh a, [hHtmlTag_ImgUrlHeap]
	ld e, a
	ldh a, [hHtmlTag_ImgUrlHeapHi]
	ld d, a
	ldh a, [hHtml_PageBank]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $2F
	ld [de], a
	ld hl, $DCFE ; raw: limit of the image URL heap of the scan pass (bank 4, one past the used area), never dereferenced
	ld bc, wHtmlImageUrlList
	farcall Html_StringTable_Add
	or a, a
	jr nz, .l4F45
	ld a, l
	ldh [hHtmlTag_ImgUrlHeap], a
	ld a, h
	ldh [hHtmlTag_ImgUrlHeapHi], a
.l4F45 ; 74:4F45
	ld a, d
	inc d
	jr z, .l4F4A
	ld a, e
.l4F4A ; 74:4F4A
	pop de
	pop hl
	jp .l4F10
