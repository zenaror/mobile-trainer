; engine/main/main_program.asm
; bank 1C, $4000-$4033 (51 bytes); pinned by layout.link
; Main_Run and the title-choice jump table

SECTION "engine/main/main_program", ROMX

; ---- code $4000-$4010 (16 bytes) [CONFIRMED] 4 insn(s); 4 executed (in up to 18/18 scenarios); entry proven: target of an executed call/far call

Main_Run:: ; 1C:4000
Function_1C_4000::
	farcall Startup_Run
	xor a, a

Main_TitleLoop:: ; 1C:4007
	farcall Title_Run
	call JumpTableInline

; ---- ptrtable $4010-$4016 (6 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 1C:400D: 3 entries; end is a heuristic guess (words stay plausible code pointers)

Table_Main_TitleChoices:: ; 1C:4010
Table_1C_4010::
	dw Main_TitleChoiceNone
	dw Main_TitleChoiceStart
	dw Main_TitleChoiceSettings

; ---- data $4016-$4019 (3 bytes) [HYPOTHESIS] UNCLASSIFIED 3 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_1C_4016:: ; 1C:4016
	db $C3, $07, $40

; ---- code $4019-$401C (3 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1; entered by table from 1C:400D (executed)

Main_TitleChoiceNone:: ; 1C:4019
	jp Main_TitleLoop

; ---- data $401C-$401D (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_1C_401C:: ; 1C:401C
	db $C9

; ---- code $401D-$4033 (22 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 12/18 scenarios)

Main_TitleChoiceStart:: ; 1C:401D
	farcall Nav_TitleStart
	ld a, $01
	jp Main_TitleLoop

Main_TitleChoiceSettings:: ; 1C:4028
	farcall Nav_TitleMobileSettings
	ld a, $01
	jp Main_TitleLoop
