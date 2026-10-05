; engine/comm/time_hooks.asm
; bank 7F, $61FC-$624F (83 bytes); pinned by layout.link
; Stub_Nop, Timer_ResetClockB, time-warning dialog wrappers

SECTION "engine/comm/time_hooks", ROMX

Stub_Nop_7F_61FC:: ; 7F:61FC
Function_7F_61FC::
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
	pop af
	ret

Timer_ResetClockB:: ; 7F:61FF
	push af
	xor a, a
	ld [wTimerBFrames], a
	ld [wTimerBSeconds], a
	ld [wTimerBMinutes], a
	pop af
	ret

	; [HYPOTHESIS] complete function (ld a,[$C26B] ; cp $1E ; jr c ; ld a,$FF ; ret ; xor a ; ret)
	; directly before the PROBABLE far-entry 7F:6218; no caller/pointer found, entry unproven
	ld a, [$C26B]
	cp a, $1E
	jr c, .l6216
	ld a, $FF
	ret
.l6216 ; 7F:6216
	xor a, a
	ret

CommNotice_ShowDialogMode1:: ; 7F:6218
Function_7F_6218::
	; [CONFIRMED] 23 insn(s) reached by static flow only; seeds: exec x13, site x10; min discovery
	; hops 0; entered by far from 23:50E5 (PROBABLE code) | 11 insn(s) executed; cut out of the
	; PROBABLE region 6218-624F by apply_coverage --split [executed in 1 scenarios]
	ld hl, wTimerAWarnFlags
	res 0, [hl]
	ld a, $01
	ld [wCommNoticeMode], a
	xor a, a
	ld [wCommNoticeGfxSet], a
	farcall CommNotice_ShowDialog
	cp a, $00
	jr z, .l6233
	ld a, $FF
	ret

.l6233 ; 7F:6233
	; [PROBABLE] 12 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6218-624F by apply_coverage --split
	xor a, a
	ret

CommNotice_ShowDialogMode0:: ; 7F:6235
Function_7F_6235::
	ld hl, wTimerAWarnFlags
	res 0, [hl]
	ld a, $00
	ld [wCommNoticeMode], a
	xor a, a
	ld [wCommNoticeGfxSet], a
	farcall CommNotice_ShowDialog
	ld a, $FF
	call Stub_Nop_7F_61FC
	ret
