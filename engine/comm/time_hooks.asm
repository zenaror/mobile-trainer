; engine/comm/time_hooks.asm
; bank 7F, $61FC-$624F (83 bytes); pinned by layout.link
; Stub_Nop, Timer_ResetClockB, time-warning dialog wrappers

SECTION "engine/comm/time_hooks", ROMX

; ---- code $61FC-$620C (16 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 4/18 scenarios); entry proven: target of an executed call/far call

Stub_Nop_7F_61FC:: ; 7F:61FC
Function_7F_61FC::
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

; ---- code $620C-$6218 (12 bytes) [HYPOTHESIS] complete function (ld a,[$C26B] ; cp $1E ; jr c ; ld a,$FF ; ret ; xor a ; ret) directly before the PROBABLE far-entry 7F:6218; no caller/pointer found, entry unproven
	ld a, [$C26B]
	cp a, $1E
	jr c, Label_7F_6216
	ld a, $FF
	ret

Label_7F_6216:: ; 7F:6216
	xor a, a
	ret

; ---- code $6218-$6233 (27 bytes) [CONFIRMED] 23 insn(s) reached by static flow only; seeds: exec x13, site x10; min discovery hops 0; entered by far from 23:50E5 (PROBABLE code) | 11 insn(s) executed; cut out of the PROBABLE region 6218-624F by apply_coverage --split [executed in 1 scenarios]

Function_7F_6218:: ; 7F:6218
	ld hl, $C26F
	res 0, [hl]
	ld a, $01
	ld [wRam_C1D0], a
	xor a, a
	ld [wRam_C1D1], a
	farcall CommNotice_ShowDialog
	cp a, $00
	jr z, Label_7F_6233
	ld a, $FF
	ret

; ---- code $6233-$624F (28 bytes) [PROBABLE] 12 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6218-624F by apply_coverage --split

Label_7F_6233:: ; 7F:6233
	xor a, a
	ret

Function_7F_6235:: ; 7F:6235
	ld hl, $C26F
	res 0, [hl]
	ld a, $00
	ld [wRam_C1D0], a
	xor a, a
	ld [wRam_C1D1], a
	farcall CommNotice_ShowDialog
	ld a, $FF
	call Stub_Nop_7F_61FC
	ret
