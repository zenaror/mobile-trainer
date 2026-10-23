; engine/main/main_program.asm
; bank 1C, $4000-$4033 (51 bytes); pinned by layout.link
; Main_Run and the title-choice jump table

SECTION "engine/main/main_program", ROMX

Main_Run:: ; 1C:4000

	; [CONFIRMED] 4 insn(s); 4 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
	farcall Startup_Run
	xor a, a

Main_TitleLoop:: ; 1C:4007
	farcall Title_Run
	call JumpTableInline

; ---- ptrtable $4010-$4016 (6 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 1C:400D: 3 entries; end is a heuristic guess (words stay plausible code pointers)

Table_Main_TitleChoices:: ; 1C:4010
	dw Main_TitleChoiceNone
	dw Main_TitleChoiceStart
	dw Main_TitleChoiceSettings

Main_TitleChoices_JumpToLoop:: ; 1C:4016 [PROBABLE]
	; [CONFIRMED] JP Main_TitleLoop encodes C3 07 40; [PROBABLE] dispatch-tail role follows the inline table as in navigation loops. Not observed executing.
	jp Main_TitleLoop

Main_TitleChoiceNone:: ; 1C:4019
	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by table from 1C:400D (executed)
	jp Main_TitleLoop

; ---- data $401C-$401D (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_Main_CandidateRetOpcode_401C:: ; 1C:401C
	db $C9

Main_TitleChoiceStart:: ; 1C:401D
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 12/18 scenarios)
	farcall Nav_TitleStart
	ld a, $01
	jp Main_TitleLoop

Main_TitleChoiceSettings:: ; 1C:4028
	farcall Nav_TitleMobileSettings
	ld a, $01
	jp Main_TitleLoop
