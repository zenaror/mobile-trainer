; engine/comm/time_hooks.asm
; bank 7F, $61FC-$624F (83 bytes); pinned by layout.link
; Stack_PushPopAFAndReturn, Timer_ResetClockB, timer check, time-warning dialog wrappers

SECTION "engine/comm/time_hooks", ROMX

Stack_PushPopAFAndReturn:: ; 7F:61FC

	; [CONFIRMED] entry proven historically; exactly PUSH AF / POP AF / RET (7F:61FC-61FE).
	; Writes SP-1/-2; AF restore needs visible writable stack. Old 10 insns include 61FF.
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

TimerB_IsAtLeast30Minutes:: ; 7F:620C
	; [HYPOTHESIS] complete bounded comparison operation: returns $00 when wTimerBMinutes < 30 and $FF
	; otherwise. The 12-byte sequence ends at 6218; no caller/pointer is known, so standalone
	; function entry and reachability remain unproven.
	ld a, [$C26B]
	cp a, $1E
	jr c, .return_zero
	ld a, $FF
	ret
.return_zero ; 7F:6216
	xor a, a
	ret

CommNotice_ShowDialogMode1:: ; 7F:6218

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
	jr z, .return_zero
	ld a, $FF
	ret

.return_zero ; 7F:6233
	; [PROBABLE] 12 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6218-624F by apply_coverage --split
	xor a, a
	ret

CommNotice_ShowDialogMode0:: ; 7F:6235

	ld hl, wTimerAWarnFlags
	res 0, [hl]
	ld a, $00
	ld [wCommNoticeMode], a
	xor a, a
	ld [wCommNoticeGfxSet], a
	farcall CommNotice_ShowDialog
	ld a, $FF
	call Stack_PushPopAFAndReturn
	ret
