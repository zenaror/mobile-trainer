; engine/input/joypad.asm
; bank 7D, $7B7C-$7C12 (150 bytes); pinned by layout.link
; joypad poll and repeat timing

SECTION "engine/input/joypad", ROMX

Joypad_ReadRaw:: ; 7D:7B7C
Function_7D_7B7C::
	; [CONFIRMED] 57 insn(s); 57 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $20
	ldh [rP1], a
	ldh a, [rP1]
	ldh a, [rP1]
	and a, $0F
	swap a
	ld b, a
	ld a, $10
	ldh [rP1], a
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	and a, $0F
	or a, b
	xor a, $FF
	ld b, a
	ld a, $30
	ldh [rP1], a
	ret

Joypad_UpdateIdleFrames:: ; 7D:7BA4
	ldh a, [hJoyHeld]
	or a, a
	jr z, .skip
	xor a, a
	ld [wJoyIdleFrames], a
.skip ; 7D:7BAD
	ld a, [wJoyIdleFrames]
	inc a
	jr z, .done
	ld [wJoyIdleFrames], a
.done ; 7D:7BB6
	ret

Joypad_Update:: ; 7D:7BB7
	push bc
	push de
	push hl
	call Joypad_UpdateUnsaved
	pop hl
	pop de
	pop bc
	ret

Joypad_UpdateUnsaved:: ; 7D:7BC1
	call Joypad_ReadRaw
	ldh a, [hJoyHeld]
	xor a, b
	and a, b
	ldh [hJoyPressed], a
	ld a, b
	ldh [hJoyHeld], a
	ld hl, $C2E5
	ld c, $08
	ld e, $00
.loop ; 7D:7BD4
	ld a, [wJoyRepeatDelay]
	rl b
	jr nc, .l7BE4
	ccf
	ld a, [hl]
	dec a
	jr nz, .l7BE4

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 7D:7BDE (executed) [executed in 1 scenarios]
	scf
	ld a, [wJoyRepeatInterval]

.l7BE4 ; 7D:7BE4
	; [CONFIRMED] 26 insn(s); 26 executed (in up to 18/18 scenarios)
	ld [hli], a
	rl e
	dec c
	jr nz, .loop
	ldh a, [hJoyPressed]
	or a, e
	ldh [hJoyPressedRepeat], a
	ret

Joypad_Init:: ; 7D:7BF0
	xor a, a
	ldh [hJoyHeld], a
	ldh [hJoyPressed], a
	ldh [hRam_FFA7], a
	ldh [hJoyPressedRepeat], a
	ld [wJoyIdleFrames], a
	ld b, $14
	ld c, $02

Joypad_SetRepeatTiming:: ; 7D:7C00
	ld a, c
	ld [wJoyRepeatInterval], a
	ld a, b
	ld [wJoyRepeatDelay], a
	ld hl, $C2E5
	ld b, $08
.loop ; 7D:7C0D
	ld [hli], a
	dec b
	jr nz, .loop
	ret
