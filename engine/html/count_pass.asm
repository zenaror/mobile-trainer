; engine/html/count_pass.asm
; bank 74, $4F4F-$5252 (771 bytes); pinned by layout.link
; parser init and the list item counting pass

SECTION "engine/html/count_pass", ROMX

Html_InitParser:: ; 74:4F4F
Function_74_4F4F::
	; [CONFIRMED] 41 insn(s); 41 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	xor a, a
	ldh [hHtml_TitleStart], a
	ldh [hHtml_TitleStartHi], a
	ldh [hTextX + 1], a
	ldh [hHtml_RecordCountHi], a
	ldh [hHtml_LinkNumber], a
	ldh [hHtml_LinkTableIndex], a
	ld [wHtmlAlign], a
	ld [wHtmlAlignSp], a
	ldh [hHtmlAlignAdjust], a
	ldh [hHtmlAlignAdjustHi], a
	ld [wHtmlListDepth], a
	ldh [hHtmlLineIndent], a
	ldh [hHtmlListIndent], a
	ld [wHtmlListCounter], a
	ld [wHtmlListCounter + 1], a
	ld [wHtmlBoldCount], a
	ld [wHtmlBoldCount + 1], a
	ldh [hHtmlLinkTextStart], a
	ldh [hHtmlLinkTextStartHi], a
	ld [wRam_C331], a
	ld [wRam_C332], a
	ld [wHtmlFlags], a
	ldh [hRam_FFD0], a
	ldh [hRam_FFD1], a
	ldh [hHtmlCount_ListItems], a
	ldh [hHtmlCount_ListDepth], a
	ldh [hHtml_ImageData], a
	ldh [hHtml_ImageDataHi], a
	ldh [hHtml_ImageBank], a
	ldh [hHtml_ImageAlign], a
	ret

Html_Layout_FlushListItem:: ; 74:4F97
Function_74_4F97::
	ld a, [wRam_C331]
	ld c, a
	ld a, [wRam_C332]
	ld b, a
	or a, c
	jr z, .l4FB6
	ld a, e
	cp a, c
	jr nz, .l4FAA

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 74:4FA4 (executed)
	ld a, d
	cp a, b
	jr z, .l4FB6

.l4FAA ; 74:4FAA
	; [CONFIRMED] 29 insn(s); 29 executed (in up to 1/18 scenarios)
	farcall Html_Layout_WrapRun
	farcall Html_Layout_EndLine
.l4FB6 ; 74:4FB6
	xor a, a
	ld [wRam_C331], a
	ld [wRam_C332], a
	ret

Html_Layout_ListBlockBreak:: ; 74:4FBE
Function_74_4FBE::
	ldh a, [hHtml_RunStartLo]
	ld c, a
	ldh a, [hTextY]
	ld b, a
	ld a, e
	cp a, c
	jr nz, .l4FDB
	ld a, d
	cp a, b
	jr nz, .l4FDB
	ldh a, [hHtmlLayout_HeightAbove]
	ld c, a
	ldh a, [hHtmlLayout_HeightBelow]
	or a, c
	jr nz, .l4FDB
	farcall Html_Layout_WrapRun
	ret
.l4FDB ; 74:4FDB
	farcall Html_Layout_WrapRun
	farcall Html_Layout_EndLine
	ld a, $0C
	ldh [hHtmlLayout_HeightBelow], a
	farcall Html_Layout_EndLine
	ret

Html_CountListItems:: ; 74:4FF2
	; [CONFIRMED] 164 insn(s) reached by static flow only; seeds: site x164; min discovery hops 1;
	; entered by far from 74:4879 (PROBABLE code) | 21 insn(s) executed; cut out of the PROBABLE
	; region 4FF2-511A by apply_coverage --split [executed in 5 scenarios]
	push bc
	push de
	push hl
	xor a, a
	ldh [hHtmlCount_ListItems], a
	ldh [hHtmlCount_ListDepth], a

Html_CountListItems_Loop:: ; 74:4FFA
Label_74_4FFA::
	call Sound_FrameService
	ld a, [hli]
	or a, a
	jp z, Html_CountListItems_Done
	cp a, $21
	jr c, .l502F
	cp a, $3C
	jp z, Html_CountListItems_Tag
	cp a, $26
	jr z, .l5067
	ldh [hHtml_LastChar], a
	cp a, $81
	jr c, .l5029
	cp a, $A0
	jr c, .l502A

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4FF2-511A by apply_coverage --split
	cp a, $E0
	jr c, .l5029
	cp a, $F0
	jr c, .l502A
	cp a, $F8
	jr c, .l5029
	cp a, $FA
	jr c, .l502A

.l5029 ; 74:5029
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 4FF2-511A by apply_coverage
	; --split [executed in 5 scenarios]
	or a, a
.l502A ; 74:502A
	jr nc, Html_CountListItems_Loop
	ld a, [hli]
	jr Html_CountListItems_Loop
.l502F ; 74:502F
	ld c, a
	ld a, [wHtmlFlags]
	and a, $08
	jr z, .l504A

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4FF2-511A by apply_coverage --split
	ld a, c
	cp a, $0D
	jp z, .l505E
	cp a, $0A
	jp z, .l5064
	cp a, $09
	jr z, .l505B
	ld c, $20
	jr .l505B

.l504A ; 74:504A
	; [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 4FF2-511A by apply_coverage
	; --split [executed in 5 scenarios]
	ld a, [hli]
	or a, a
	jr z, Html_CountListItems_Done
	cp a, $21
	jr c, .l504A
	dec hl
	ldh a, [hHtml_LastChar]
	cp a, $20
	jr z, Html_CountListItems_Loop
	ld c, $20
.l505B ; 74:505B
	jp Html_CountListItems_Loop

.l505E ; 74:505E
	; [PROBABLE] 26 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4FF2-511A by apply_coverage --split
	ld a, [hl]
	cp a, $0A
	jr nz, .l5064
	inc hl
.l5064 ; 74:5064
	jp Html_CountListItems_Loop
.l5067 ; 74:5067
	ld a, l
	ldh [hHtml_MatchRestart], a
	ld a, h
	ldh [hHtml_MatchRestartHi], a
	ld bc, Html_EntityPtrs
	push de
	call Html_MatchKeyword
	pop de
	or a, a
	jr z, .l5084
	ldh [hHtml_LastChar], a
	ld a, [hli]
	cp a, $3B
	jp z, Html_CountListItems_Loop
	dec hl
	jp Html_CountListItems_Loop
.l5084 ; 74:5084
	ldh a, [hHtml_MatchRestart]
	ld l, a
	ldh a, [hHtml_MatchRestartHi]
	ld h, a
	jp Html_CountListItems_Loop

Html_CountListItems_Done:: ; 74:508D
Label_74_508D::
	; [CONFIRMED] 41 insn(s) executed; cut out of the PROBABLE region 4FF2-511A by apply_coverage
	; --split [executed in 4 scenarios]
	pop hl
	pop de
	pop bc
	ret

Html_CountListItems_Tag:: ; 74:5091
Label_74_5091::
	ld a, [hl]
	ldh [hHtml_TagFirstChar], a
	cp a, $2F
	jr nz, .skip
	inc hl
.skip ; 74:5099
	ld a, l
	ldh [hHtml_MatchRestart], a
	ld a, h
	ldh [hHtml_MatchRestartHi], a
	ldh a, [hHtml_TitleStart]
	ld c, a
	ldh a, [hHtml_TitleStartHi]
	or a, c
	jp nz, Html_CountListItems_InTitle
	ld bc, Html_TagPtrs
	push de
	call Html_MatchKeyword
	pop de
	or a, a
	jr nz, Html_CountListItems_Dispatch

Html_CountListItems_Tag_Ignore:: ; 74:50B3
Label_74_50B3::
	ldh a, [hHtml_MatchRestart]
	ld l, a
	ldh a, [hHtml_MatchRestartHi]
	ld h, a

Html_CountListItems_Tag_Done:: ; 74:50B9
Label_74_50B9::
	ldh a, [hHtml_SourceBank]
	call BankSwitch_H
	ldh a, [hTextX]
	call BankSwitch_D

Html_CountListItems_Tag_SkipToEnd:: ; 74:50C3
Label_74_50C3::
	ld a, $20
	ldh [hHtml_LastChar], a
.loop ; 74:50C7
	ld a, [hli]
	or a, a
	jp z, Html_CountListItems_Done
	cp a, $3E
	jp z, Html_CountListItems_Loop
	cp a, $81
	jr c, .l50E9

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4FF2-511A by apply_coverage --split
	cp a, $A0
	jr c, .l50EA
	cp a, $E0
	jr c, .l50E9
	cp a, $F0
	jr c, .l50EA
	cp a, $F8
	jr c, .l50E9
	cp a, $FA
	jr c, .l50EA

.l50E9 ; 74:50E9
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 4FF2-511A by apply_coverage
	; --split [executed in 4 scenarios]
	or a, a
.l50EA ; 74:50EA
	jp nc, .l50F1

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4FF2-511A by apply_coverage --split
	ld a, [hli]
	jp .loop

.l50F1 ; 74:50F1
	; [CONFIRMED] 26 insn(s) executed; cut out of the PROBABLE region 4FF2-511A by apply_coverage
	; --split [executed in 4 scenarios]
	dec hl
	ld bc, Html_NoKeywords
	call Html_ScanAttributes
	jp .loop

Html_CountListItems_Dispatch:: ; 74:50FB
Label_74_50FB::
	cp a, $0F
	jr z, .l510A
	ld b, a
	ld a, [hl]
	cp a, $3E
	jr z, .l5109
	cp a, $21
	jr nc, Html_CountListItems_Tag_SkipToEnd
.l5109 ; 74:5109
	ld a, b
.l510A ; 74:510A
	add a, a
	push hl
	add a, $1A
	ld l, a
	ld a, $00
	adc a, $51
	ld h, a
	ld a, [hli]
	ld b, [hl]
	ld c, a
	pop hl
	push bc
	ret

; ---- ptrtable $511A-$513E (36 bytes) [PROBABLE] 18-word jump table: dispatcher at 74:510A-5119 (add a,a; push hl; add a,$1A; ld l,a; ld a,0; adc a,$51; ld h,a; ld a,[hli]; ld b,[hl]; ld c,a; pop hl; push bc; ret), same idiom as Table_74_44A0; the dispatcher is executed: traces/detail/*/dataaccess.tsv (browser scenarios) list rom_read 74 512E-5130 and 5134-5138, i.e. entries 10 ($50B3), 13 ($521B) and 14 ($5238) were fetched by 74:5114; the table extent (18 words) is by analogy with Table_74_44A0, hence PROBABLE; all 18 targets are code instruction starts: $50B3, $50B3, $513E, $50B3, $50B3, $50B3, $50B3, $50B3, $50B3, $50B3, $50B3, $50B3, $51FE, $521B, $5238, $519A, $50B3, $51E4

Html_CountPassTagTable:: ; 74:511A
Table_74_511A::
	dw Html_CountListItems_Tag_Ignore
	dw Html_CountListItems_Tag_Ignore
	dw Html_CountListItems_Title
	dw Html_CountListItems_Tag_Ignore
	dw Html_CountListItems_Tag_Ignore
	dw Html_CountListItems_Tag_Ignore
	dw Html_CountListItems_Tag_Ignore
	dw Html_CountListItems_Tag_Ignore
	dw Html_CountListItems_Tag_Ignore
	dw Html_CountListItems_Tag_Ignore
	dw Html_CountListItems_Tag_Ignore
	dw Html_CountListItems_Tag_Ignore
	dw Html_CountListItems_Ul
	dw Html_CountListItems_Ol
	dw Html_CountListItems_Li
	dw Html_CountListItems_Comment
	dw Html_CountListItems_Tag_Ignore
	dw Html_CountListItems_Pre

Html_CountListItems_Title:: ; 74:513E
Label_74_513E::
	; [PROBABLE] 86 insn(s) reached by static flow only; seeds: site x39, table x47; min discovery
	; hops 0; run starts at an entry of the code-pointer table at 74:511A
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jp z, Html_CountListItems_Tag_Ignore
	ld a, e
	ldh [hHtml_TitleStart], a
	ld a, d
	ldh [hHtml_TitleStartHi], a
	jp Html_CountListItems_Tag_Ignore

Html_CountListItems_InTitle:: ; 74:514E
Label_74_514E::
	ld bc, Html_TitleTagPtrs
	push de
	call Html_MatchKeyword
	pop de
	or a, a
	jr z, .l5167
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jr nz, .l5167
	xor a, a
	ldh [hHtml_TitleStart], a
	ldh [hHtml_TitleStartHi], a
	jp Html_CountListItems_Tag_Ignore
.l5167 ; 74:5167
	ldh a, [hHtml_MatchRestart]
	ld l, a
	ldh a, [hHtml_MatchRestartHi]
	ld h, a
.loop ; 74:516D
	call Sound_FrameService
	ld a, [hli]
	or a, a
	jp z, Html_CountListItems_Done
	cp a, $3E
	jp z, Html_CountListItems_Loop
	cp a, $81
	jr c, .l5192
	cp a, $A0
	jr c, .l5193
	cp a, $E0
	jr c, .l5192
	cp a, $F0
	jr c, .l5193
	cp a, $F8
	jr c, .l5192
	cp a, $FA
	jr c, .l5193
.l5192 ; 74:5192
	or a, a
.l5193 ; 74:5193
	jp nc, .loop
	ld a, [hli]
	jp .loop

Html_CountListItems_Comment:: ; 74:519A
Label_74_519A::
	ld a, [hli]
.l519B ; 74:519B
	or a, a
	jp z, Html_CountListItems_Done
	cp a, $2D
	jr z, .l51C5
	cp a, $3E
	jr z, .l51DD
	cp a, $81
	jr c, .l51BF
	cp a, $A0
	jr c, .l51C0
	cp a, $E0
	jr c, .l51BF
	cp a, $F0
	jr c, .l51C0
	cp a, $F8
	jr c, .l51BF
	cp a, $FA
	jr c, .l51C0
.l51BF ; 74:51BF
	or a, a
.l51C0 ; 74:51C0
	jr nc, Html_CountListItems_Comment
	ld a, [hli]
	jr Html_CountListItems_Comment
.l51C5 ; 74:51C5
	ld a, [hli]
	cp a, $2D
	jr nz, .l519B
.l51CA ; 74:51CA
	call Sound_FrameService
	ld a, [hli]
	or a, a
	jp z, Html_CountListItems_Done
	cp a, $2D
	jr nz, .l51CA
	ld a, [hli]
	cp a, $2D
	jr nz, .l51CA
	jr Html_CountListItems_Comment
.l51DD ; 74:51DD
	ld a, $20
	ldh [hHtml_LastChar], a
	jp Html_CountListItems_Loop

Html_CountListItems_Pre:: ; 74:51E4
Label_74_51E4::
	; [PROBABLE] table entry 18 (last word) of Table_74_511A ($51E4) validated jump-table target;
	; decode chain cp $2F / jr z / ld a,[$C2C1] / or $08 ... jp $50B9 ends in unconditional jumps to
	; known code and lands exactly on the next code region 51FE (also a table target)
	cp a, $2F
	jr z, .l51F3
	ld a, [wHtmlFlags]
	or a, $08
	ld [wHtmlFlags], a
	jp Html_CountListItems_Tag_Done
.l51F3 ; 74:51F3
	ld a, [wHtmlFlags]
	and a, $F7
	ld [wHtmlFlags], a
	jp Html_CountListItems_Tag_Done

Html_CountListItems_Ul:: ; 74:51FE
Label_74_51FE::
	; [CONFIRMED] 40 insn(s) reached by static flow only; seeds: table x40; min discovery hops 0;
	; run starts at an entry of the code-pointer table at 74:511A [executed in 1 scenarios]
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jr z, .l520F
	ldh a, [hHtmlCount_ListDepth]
	inc a
	jp z, Html_CountListItems_Tag_Done
	ldh [hHtmlCount_ListDepth], a
	jp Html_CountListItems_Tag_Done
.l520F ; 74:520F
	ldh a, [hHtmlCount_ListDepth]
	or a, a
	jp z, Html_CountListItems_Tag_Done
	dec a
	ldh [hHtmlCount_ListDepth], a
	jp Html_CountListItems_Tag_Done

Html_CountListItems_Ol:: ; 74:521B
Label_74_521B::
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jr z, .l522C
	ldh a, [hHtmlCount_ListDepth]
	inc a
	jp z, Html_CountListItems_Tag_Done
	ldh [hHtmlCount_ListDepth], a
	jp Html_CountListItems_Tag_Done
.l522C ; 74:522C
	ldh a, [hHtmlCount_ListDepth]
	or a, a
	jp z, Html_CountListItems_Done
	dec a
	ldh [hHtmlCount_ListDepth], a
	jp Html_CountListItems_Tag_Done

Html_CountListItems_Li:: ; 74:5238
Label_74_5238::
	ldh a, [hHtml_TagFirstChar]
	cp a, $2F
	jp z, Html_CountListItems_Tag_Done
	ldh a, [hHtmlCount_ListDepth]
	or a, a
	jp nz, Html_CountListItems_Tag_Done
	ldh a, [hHtmlCount_ListItems]
	inc a
	ldh [hHtmlCount_ListItems], a
	cp a, $0A
	jp c, Html_CountListItems_Tag_Done
	jp Html_CountListItems_Done
