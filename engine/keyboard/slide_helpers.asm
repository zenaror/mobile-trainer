; engine/keyboard/slide_helpers.asm
; bank 7F, $70FD-$7271 (372 bytes); pinned by layout.link
; KbdSlide_* prepare/step hooks for the keyboard slide

SECTION "engine/keyboard/slide_helpers", ROMX

KbdSlide_InPrepMode6:: ; 7F:70FD
Function_7F_70FD::
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld d, $00
	ld a, [wSpriteSlots + 16]
	sub a, $0D
	jr z, .l7112

.loop ; 7F:710D
	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 7F:710B (executed) [executed in 1 scenarios]
	inc d
	sub a, $0C
	jr nz, .loop

.l7112 ; 7F:7112
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)
	ld e, $00
	pop af
	ret

KbdSlide_InStepMode6:: ; 7F:7116
	farcall ScrollSplit_StepUp3
	push de
	farcall Sprite_UpdateAll
	pop de
	ret

KbdSlide_OutPrepMode6:: ; 7F:7125
	push af
	ld d, $00
	ld a, [wSplitScrollY]
	cp a, $00
	jr z, .l7136

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 7F:712D (executed) [executed in 2 scenarios]
	ld d, $01
.loop ; 7F:7131
	inc d
	sub a, $0C
	jr nz, .loop

.l7136 ; 7F:7136
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios)
	ld e, $00
	pop af
	ret

KbdSlide_OutStepMode6:: ; 7F:713A
	farcall ScrollSplit_StepDown3
	push de
	farcall Sprite_UpdateAll
	pop de
	ret

KbdSlide_InPrepMode8:: ; 7F:7149
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wKbdSlideDeltaRow]
	cp a, $00
	jr z, .l715F

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 7F:7155 (executed) [upgraded PROBABLE->CONFIRMED by the
	; classify_g1 pass: every instruction start of the region appears in
	; analysis/coverage_union.tsv]
	ld e, $00
	ld a, [wKbdSlideDeltaRow]
	ld d, a
	jr .l7163

.l715F ; 7F:715F
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 2/18 scenarios)
	ld e, $00
	ld d, $04
.l7163 ; 7F:7163
	pop af
	ret

KbdSlide_InStepMode8:: ; 7F:7165
	push af
	push de
	pop de
	farcall ScrollSplit_StepUp4
	push de
	farcall Sprite_UpdateAll
	pop de
	pop af
	ret

KbdSlide_OutPrepMode8:: ; 7F:7178
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wKbdSlideDeltaRow]
	cp a, $00
	jr z, .l718E

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 7F:7184 (executed) [upgraded PROBABLE->CONFIRMED by the
	; classify_g1 pass: every instruction start of the region appears in
	; analysis/coverage_union.tsv]
	ld e, $00
	ld a, [wKbdSlideDeltaRow]
	ld d, a
	jr .l7192

.l718E ; 7F:718E
	; [CONFIRMED] 85 insn(s); 85 executed (in up to 3/18 scenarios)
	ld e, $00
	ld d, $04
.l7192 ; 7F:7192
	pop af
	ret

KbdSlide_OutStepMode8:: ; 7F:7194
	push af
	push de
	pop de
	farcall ScrollSplit_StepDown4
	push de
	farcall Sprite_UpdateAll
	pop de
	pop af
	ret

KbdSlide_InPrepMode9:: ; 7F:71A7
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wKbdSlideDeltaRow]
	cp a, $00
	jr z, .l71BD
	ld e, $00
	ld a, [wKbdSlideDeltaRow]
	ld d, a
	jr .l71C1
.l71BD ; 7F:71BD
	ld e, $00
	ld d, $05
.l71C1 ; 7F:71C1
	pop af
	ret

KbdSlide_InStepMode9:: ; 7F:71C3
	push af
	push de
	pop de
	farcall ScrollSplit_StepUp4
	push de
	farcall Sprite_UpdateAll
	pop de
	pop af
	ret

KbdSlide_OutPrepMode9:: ; 7F:71D6
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wKbdSlideDeltaRow]
	cp a, $00
	jr z, .l71EC
	ld e, $00
	ld a, [wKbdSlideDeltaRow]
	ld d, a
	jr .l71F0
.l71EC ; 7F:71EC
	ld e, $00
	ld d, $05
.l71F0 ; 7F:71F0
	pop af
	ret

KbdSlide_OutStepMode9:: ; 7F:71F2
	push af
	push de
	pop de
	farcall ScrollSplit_StepDown4
	push de
	farcall Sprite_UpdateAll
	pop de
	pop af
	ret

KbdSlide_InPrepMode7:: ; 7F:7205
	push af
	ld e, $00
	ld d, $08
	pop af
	ret

KbdSlide_InStepMode7:: ; 7F:720C
	push af
	farcall ScrollSplit_StepUp4
	push de
	farcall Sprite_UpdateAll
	pop de
	pop af
	ret

KbdSlide_OutPrepMode7:: ; 7F:721D
	push af
	ld e, $00
	ld d, $08
	pop af
	ret

KbdSlide_OutStepMode7:: ; 7F:7224
	push af
	farcall ScrollSplit_StepDown4
	push de
	farcall Sprite_UpdateAll
	pop de
	pop af
	ret

	; [PROBABLE] two functions in the family of the executed 7F:721D/7224: 7235-723B (push af ; ld
	; e,0 ; ld d,9 ; pop af ; ret; same shape as 721D with d=8) and the first byte (push af) of the
	; function 723C-7253 whose body is the validated far-call region 723D-7253; no caller found
	; (7F:721D/7224 are far-called from 55:6490/64F5), entry unproven
	push af
	ld e, $00
	ld d, $09
	pop af
	ret

	push af

	; [PROBABLE] 7 insn(s) reached by static flow only; seeds: site x7; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall ScrollSplit_StepUp4
	push de
	farcall ScrollSplit_SetCursorSpritesY
	farcall Sprite_UpdateAll
	pop de
	pop af
	ret

	; [PROBABLE] twin of 7F:7235: push af ; ld e,0 ; ld d,9 ; pop af ; ret + first byte (push af) of
	; the function 725A-7271 (body = far-call region 725B-7271); entry unproven
	push af
	ld e, $00
	ld d, $09
	pop af
	ret

	push af

	; [PROBABLE] 7 insn(s) reached by static flow only; seeds: site x7; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall ScrollSplit_StepDown4
	push de
	farcall ScrollSplit_SetCursorSpritesY
	farcall Sprite_UpdateAll
	pop de
	pop af
	ret
