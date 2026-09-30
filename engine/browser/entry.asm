; engine/browser/entry.asm
; bank 4F, $4668-$4717 (175 bytes); pinned by layout.link
; Browser_Entry (home page / page list start)

SECTION "engine/browser/entry", ROMX

; ---- code $4668-$4671 (9 bytes) [CONFIRMED] 184 insn(s); 184 executed (in up to 12/18 scenarios); entry proven: target of an executed call/far call (part of region $4572-$4671)

Browser_Entry:: ; 4F:4668
	farcall SaveCheck_Verify
	or a, a
	jr z, Label_4F_4677

; ---- code $4671-$4677 (6 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 4F:466F (executed)
	farcall SaveCheck_ResetBlock

; ---- code $4677-$4689 (18 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 2/18 scenarios)

Label_4F_4677:: ; 4F:4677
	farcall Tutorial_GateHomepage
	xor a, a
	or a, b
	ret nz

Browser_StartMenuLoop:: ; 4F:4680
	farcall SaveCheck_Verify
	or a, a
	jr z, Label_4F_468F

; ---- code $4689-$468F (6 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 4F:4687 (executed)
	farcall SaveCheck_ResetBlock

; ---- code $468F-$4698 (9 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)

Label_4F_468F:: ; 4F:468F
	farcall Browser_StartChoiceScreen
	call JumpTableInline

; ---- ptrtable $4698-$46A4 (12 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4F:4695: 6 entries; end = first entry target

Table_4F_4698:: ; 4F:4698
	dw Label_4F_46A4
	dw Browser_StartHomePage
	dw Browser_StartPageListEntry
	dw Boot_ClearAndInit
	dw Boot_ClearAndInit
	dw Boot_ClearAndInit

; ---- code $46A4-$46A5 (1 bytes) [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1; entered by table from 4F:4695 (executed) [executed in 3 scenarios]

Label_4F_46A4:: ; 4F:46A4
	ret

; ---- code $46A5-$46B7 (18 bytes) [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios)

Browser_StartHomePage:: ; 4F:46A5
	farcall Browser_BeginSession
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	farcall Browser_LoadHomePage

; ---- code $46B7-$4717 (96 bytes) [CONFIRMED] 36 insn(s) reached by static flow only; seeds: exec x36; min discovery hops 0; entry not recorded [executed in 1 scenarios]
	jp Browser_StartMenuLoop

Browser_StartPageListEntry:: ; 4F:46BA
	farcall Browser_BeginSession
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wRam_D3C0], a
	ld [wRam_D500], a
	farcall PageList_Main
	push bc
	push de
	push hl
	farcall Palette_FadeOutToWhite
	farcall Function_00_09B6
	farcall SaveCheck_Update
	pop hl
	pop de
	pop bc
	ld a, e
	or a, d
	or a, l
	or a, h
	jp z, Browser_StartMenuLoop
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld de, $C380
	ld bc, $0100
	call CopyBytes
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	farcall Browser_LoadStagedUrl
	jp Browser_StartMenuLoop
