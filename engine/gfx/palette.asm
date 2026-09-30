; engine/gfx/palette.asm
; bank 4F, $4000-$4572 (1394 bytes); pinned by layout.link
; palette staging buffer, hardware upload/dump, timed fades to/from white

SECTION "engine/gfx/palette", ROMX

Palette_LoadToBuffer:: ; 4F:4000
Function_4F_4000::
	; [CONFIRMED] 247 insn(s); 247 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
	ldh [hFarBank], a
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call FarCall_Inline16
	dw $050C
	ret

Palette_ReadHardwareToBuffer:: ; 4F:400E
	push hl
	ld bc, $2000
	call Palette_ReadHardwareBlock
	pop hl
	ld bc, $0040
	add hl, bc
	ld bc, $2080
	call Palette_ReadHardwareBlock
	ret

Palette_ReadHardwareBlock:: ; 4F:4021
	bit 7, c
	jr nz, .l4037
.l4025 ; 4F:4025
	ld a, c
	ldh [rBCPS], a
	inc c
	ldh a, [rBCPD]
	ld [hli], a
	ld a, c
	ldh [rBCPS], a
	inc c
	ldh a, [rBCPD]
	ld [hli], a
	dec b
	jr nz, .l4025
	ret
.l4037 ; 4F:4037
	res 7, c
.l4039 ; 4F:4039
	ld a, c
	ldh [rOCPS], a
	inc c
	ldh a, [rOCPD]
	ld [hli], a
	ld a, c
	ldh [rOCPS], a
	inc c
	ldh a, [rOCPD]
	ld [hli], a
	dec b
	jr nz, .l4039
	ret

Palette_UploadBuffer:: ; 4F:404B
	push hl
	ld bc, $0800
	call Palette_UploadBlock
	pop hl
	ld bc, $0040
	add hl, bc
	ld bc, $0880
	call Palette_UploadBlock
	ret

Palette_UploadBlock:: ; 4F:405E
	ld a, c
	or a, $80
	bit 7, c
	jr nz, .l406B
	ldh [rBCPS], a
	ld c, $69
	jr .l406F
.l406B ; 4F:406B
	ldh [rOCPS], a
	ld c, $6B
.l406F ; 4F:406F
	ld a, [hli]
	ldh [c], a
	ld a, [hli]
	ldh [c], a
	ld a, [hli]
	ldh [c], a
	ld a, [hli]
	ldh [c], a
	ld a, [hli]
	ldh [c], a
	ld a, [hli]
	ldh [c], a
	ld a, [hli]
	ldh [c], a
	ld a, [hli]
	ldh [c], a
	dec b
	jr nz, .l406F
	ret

PalFade_BlendColor:: ; 4F:4083
	ld hl, $D980
	add hl, de
	ld a, [hli]
	ld c, a
	ld a, [hl]
	or a, c
	jp z, .l411C
	ld a, [hli]
	or a, a
	jp nz, .l4131
	push bc
	ld hl, $D880
	add hl, de
	ld a, [hl]
	and a, $1F
	ldh [hRam_FFB0], a
	ld a, [hli]
	and a, $E0
	swap a
	rra
	ld b, a
	ld a, [hl]
	and a, $03
	swap a
	rra
	or a, b
	ldh [hRam_FFB1], a
	ld a, [hli]
	and a, $7C
	rra
	rra
	ldh [hRam_FFB2], a
	ld hl, $D900
	add hl, de
	ld a, [hl]
	and a, $1F
	ldh [hRam_FFB3], a
	ld a, [hli]
	and a, $E0
	swap a
	rra
	ld b, a
	ld a, [hl]
	and a, $03
	swap a
	rra
	or a, b
	ldh [hRam_FFB4], a
	ld a, [hli]
	and a, $7C
	rra
	rra
	ldh [hRam_FFB5], a
	push de
	ldh a, [hRam_FFB3]
	ld b, a
	ldh a, [hRam_FFB0]
	call PalFade_ScaledDelta
	ldh a, [hRam_FFB0]
	sub a, h
	and a, $1F
	ldh [hRam_FFB0], a
	ldh a, [hRam_FFB4]
	ld b, a
	ldh a, [hRam_FFB1]
	call PalFade_ScaledDelta
	ldh a, [hRam_FFB1]
	sub a, h
	ld h, a
	and a, $07
	swap a
	rla
	ld l, a
	ldh a, [hRam_FFB0]
	or a, l
	ldh [hRam_FFB0], a
	ld a, h
	and a, $18
	rla
	swap a
	ldh [hRam_FFB1], a
	ldh a, [hRam_FFB5]
	ld b, a
	ldh a, [hRam_FFB2]
	call PalFade_ScaledDelta
	ldh a, [hRam_FFB2]
	sub a, h
	and a, $1F
	rla
	rla
	ld l, a
	ldh a, [hRam_FFB1]
	or a, l
	ldh [hRam_FFB1], a
	pop de
	pop bc
	jr .l4126
.l411C ; 4F:411C
	ld hl, $D880
	add hl, de
	ld a, [hli]
	ldh [hRam_FFB0], a
	ld a, [hli]
	ldh [hRam_FFB1], a
.l4126 ; 4F:4126
	ld hl, $D800
	add hl, de
	ldh a, [hRam_FFB0]
	ld [hli], a
	ldh a, [hRam_FFB1]
	ld [hli], a
	ret
.l4131 ; 4F:4131
	ld hl, $D900
	add hl, de
	ld a, [hli]
	ldh [hRam_FFB0], a
	ld a, [hli]
	ldh [hRam_FFB1], a
	ld hl, $D800
	add hl, de
	ldh a, [hRam_FFB0]
	ld [hli], a
	ldh a, [hRam_FFB1]
	ld [hli], a
	ret

PalFade_ScaledDelta:: ; 4F:4146
	sub a, b
	jr nc, PalFade_Mul8x8
	cpl
	inc a
	call PalFade_Mul8x8
	ld a, h
	cpl
	inc a
	ld h, a
	ret

PalFade_Mul8x8:: ; 4F:4153
	ld hl, $0000
	ld e, c
	ld d, l
	ld b, $08
.loop ; 4F:415A
	rrca
	jr nc, .skip
	add hl, de
.skip ; 4F:415E
	sla e
	rl d
	dec b
	jr nz, .loop
	ret

PalFade_Start:: ; 4F:4166
	ld [wPalFadeStep], a
	bit 7, a
	jr nz, .l417E
	ld a, c
	ld [wTextCellsLeft], a
	ld a, b
	ld [wRam_C2EF], a
	xor a, a
	ld [wPalFadeProgress], a
	ld [wPalFadeProgress + 1], a
	jr .l418E
.l417E ; 4F:417E
	ld a, c
	ld [wTextCellsLeft], a
	ld a, b
	ld [wRam_C2EF], a
	xor a, a
	ld [wPalFadeProgress], a
	inc a
	ld [wPalFadeProgress + 1], a
.l418E ; 4F:418E
	ld a, [wPalFadeMode]
	call JumpTableInline

; ---- ptrtable $4194-$41A4 (16 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4F:4191: 8 entries; end = first entry target

PalFade_Start_ModeTable:: ; 4F:4194
Table_4F_4194::
	dw Label_4F_41C2
	dw Label_4F_41B8
	dw Label_4F_41AE
	dw Label_4F_41A4
	dw Label_4F_41C2
	dw Label_4F_41C2
	dw Label_4F_41C2
	dw Label_4F_41C2

Label_4F_41A4:: ; 4F:41A4
	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1;
	; entered by table from 4F:4191 (executed)
	ld de, $D9F0
	ld hl, $D970
	ld b, $04
	jr Label_4F_41CA

Label_4F_41AE:: ; 4F:41AE
	ld de, $D9C0
	ld hl, $D940
	ld b, $20
	jr Label_4F_41CA

Label_4F_41B8:: ; 4F:41B8
	ld de, $D980
	ld hl, $D900
	ld b, $20
	jr Label_4F_41CA

Label_4F_41C2:: ; 4F:41C2
	; [CONFIRMED] 54 insn(s); 54 executed (in up to 18/18 scenarios)
	ld de, $D980
	ld hl, $D900
	ld b, $40

Label_4F_41CA:: ; 4F:41CA
	ld a, [wTextCellsLeft]
	ld [hli], a
	ld a, [wRam_C2EF]
	ld [hli], a
	ld a, [wPalFadeProgress]
	ld [de], a
	inc de
	ld a, [wPalFadeProgress + 1]
	ld [de], a
	inc de
	dec b
	jr nz, Label_4F_41CA
	ret

PalFade_Step:: ; 4F:41E0
	ld a, [wPalFadeStep]
	or a, a
	ret z
	ld c, a
	bit 7, a
	jr z, .l4213
	ld a, [wPalFadeProgress]
	add a, c
	jr c, .l420A
	ld a, [wPalFadeProgress + 1]
	add a, $FF
	jr z, .l4203
	xor a, a
	ld [wPalFadeProgress], a
	ld [wPalFadeProgress + 1], a
	ld [wPalFadeStep], a
	jr .l422D
.l4203 ; 4F:4203
	ld [wPalFadeProgress + 1], a
	ld a, [wPalFadeProgress]
	add a, c
.l420A ; 4F:420A
	ld [wPalFadeProgress], a
	xor a, a
	ld [wPalFadeProgress + 1], a
	jr .l422D
.l4213 ; 4F:4213
	ld a, [wPalFadeProgress]
	add a, c
	jr nc, .l4226
	xor a, a
	ld [wPalFadeProgress], a
	ld [wPalFadeStep], a
	inc a
	ld [wPalFadeProgress + 1], a
	jr .l422D
.l4226 ; 4F:4226
	ld [wPalFadeProgress], a
	xor a, a
	ld [wPalFadeProgress + 1], a
.l422D ; 4F:422D
	ld a, [wPalFadeMode]
	call JumpTableInline

; ---- ptrtable $4233-$4243 (16 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 4F:4230: 8 entries; end = first entry target

PalFade_Step_ModeTable:: ; 4F:4233
Table_4F_4233::
	dw Label_4F_4261
	dw Label_4F_4257
	dw Label_4F_424D
	dw Label_4F_4243
	dw Label_4F_4261
	dw Label_4F_4261
	dw Label_4F_4261
	dw Label_4F_4261

Label_4F_4243:: ; 4F:4243
	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1;
	; entered by table from 4F:4230 (executed)
	ld de, $0060
	ld hl, $D9F0
	ld b, $04
	jr Label_4F_4269

Label_4F_424D:: ; 4F:424D
	ld de, $0040
	ld hl, $D9C0
	ld b, $20
	jr Label_4F_4269

Label_4F_4257:: ; 4F:4257
	; [CONFIRMED] 31 insn(s); 31 executed (in up to 18/18 scenarios)
	ld de, $0000
	ld hl, $D980
	ld b, $20
	jr Label_4F_4269

Label_4F_4261:: ; 4F:4261
	ld de, $0000
	ld hl, $D980
	ld b, $40

Label_4F_4269:: ; 4F:4269
	push bc
	push de
	ld a, [wPalFadeProgress]
	ld e, a
	ld a, [wPalFadeProgress + 1]
	ld d, a
.l4273 ; 4F:4273
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	dec b
	jr nz, .l4273
	pop de
	pop bc
	call Sound_FrameService
.l427F ; 4F:427F
	call PalFade_BlendColor
	inc de
	inc de
	call Sound_FrameService
	dec b
	jr nz, .l427F
	ld a, $FF
	or a, a
	ret

Palette_CaptureAndFadeInFromWhite:: ; 4F:428E
Function_4F_428E::
	; [PROBABLE] function prologue (ldh [$FFF2],a / ldh a,[$FF8D] / push af / ... ld a,$07 / ldh
	; [$FF8D],a / ldh [$FF70],a ...), identical to the executed functions 4F:42B4/4370/4572; the
	; previous byte is a ret (function boundary) and the decode chain ends exactly at the next
	; region (site-validated inline far call `call $06D1`); no caller/table entry found (searched
	; far pointers, call/jp operands), so entry unproven
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call VBlank_WaitStartDI
	ld hl, $D800

	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: site x8; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Palette_ReadHardwareToBuffer
	ei
	call Sound_FrameService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]

Palette_FadeInFromWhite:: ; 4F:42B4
Function_4F_42B4::
	; [CONFIRMED] 62 insn(s); 62 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0080
	ld de, $D880
	ld hl, $D800
	call CopyBytes
	ld a, $00
	ld [wPalFadeMode], a
	ld bc, $7FFF
	ld a, $E0
	call PalFade_Start
	call PalFade_Step
	call LCDOn
.loop ; 4F:42E0
	call VBlank_WaitStartDI
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
	call PalFade_Step
	jr nz, .loop
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Palette_FadeInFromWhiteSlow:: ; 4F:42FF
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0080
	ld de, $D880
	ld hl, $D800
	call CopyBytes
	ld a, $00
	ld [wPalFadeMode], a
	ld bc, $7FFF
	ld a, $F0
	call PalFade_Start
	call PalFade_Step
	call LCDOn
.loop ; 4F:432B
	call VBlank_WaitStartDI
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
	call PalFade_Step
	jr nz, .loop
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Palette_CaptureAndFadeOutToWhite:: ; 4F:434A
Function_4F_434A::
	; [PROBABLE] function prologue (ldh [$FFF2],a / ldh a,[$FF8D] / push af / ... ld a,$07 / ldh
	; [$FF8D],a / ldh [$FF70],a ...), identical to the executed functions 4F:42B4/4370/4572; the
	; previous byte is a ret (function boundary) and the decode chain ends exactly at the next
	; region (site-validated inline far call `call $06D1`); no caller/table entry found (searched
	; far pointers, call/jp operands), so entry unproven
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call VBlank_WaitStartDI
	ld hl, $D800

	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: site x8; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Palette_ReadHardwareToBuffer
	ei
	call Sound_FrameService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]

Palette_FadeOutToWhite:: ; 4F:4370
Function_4F_4370::
	; [CONFIRMED] 60 insn(s); 60 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0080
	ld de, $D880
	ld hl, $D800
	call CopyBytes
	ld a, $00
	ld [wPalFadeMode], a
	ld bc, $7FFF
	ld a, $20
	call PalFade_Start
	call PalFade_Step
.loop ; 4F:4399
	call VBlank_WaitStartDI
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
	call PalFade_Step
	jr nz, .loop
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Palette_FadeOutToWhiteSlow:: ; 4F:43B8
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0080
	ld de, $D880
	ld hl, $D800
	call CopyBytes
	ld a, $00
	ld [wPalFadeMode], a
	ld bc, $7FFF
	ld a, $10
	call PalFade_Start
	call PalFade_Step
.loop ; 4F:43E1
	call VBlank_WaitStartDI
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
	call PalFade_Step
	jr nz, .loop
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Palette_CaptureAndFadeInFromBlackSlow:: ; 4F:4400
Function_4F_4400::
	; [PROBABLE] function prologue (ldh [$FFF2],a / ldh a,[$FF8D] / push af / ... ld a,$07 / ldh
	; [$FF8D],a / ldh [$FF70],a ...), identical to the executed functions 4F:42B4/4370/4572; the
	; previous byte is a ret (function boundary) and the decode chain ends exactly at the next
	; region (site-validated inline far call `call $06D1`); no caller/table entry found (searched
	; far pointers, call/jp operands), so entry unproven
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call VBlank_WaitStartDI
	ld hl, $D800

	; [PROBABLE] 39 insn(s) reached by static flow only; seeds: site x39; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Palette_ReadHardwareToBuffer
	ei
	call Sound_FrameService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]

Palette_FadeInFromBlackSlow:: ; 4F:4426
Function_4F_4426::
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0080
	ld de, $D880
	ld hl, $D800
	call CopyBytes
	ld a, $00
	ld [wPalFadeMode], a
	ld bc, $0000
	ld a, $F0
	call PalFade_Start
	call PalFade_Step
	call LCDOn
.loop ; 4F:4452
	call VBlank_WaitStartDI
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
	call PalFade_Step
	jr nz, .loop
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Palette_CaptureAndFadeOutToBlackSlow:: ; 4F:4471
Function_4F_4471::
	; [PROBABLE] function prologue (ldh [$FFF2],a / ldh a,[$FF8D] / push af / ... ld a,$07 / ldh
	; [$FF8D],a / ldh [$FF70],a ...), identical to the executed functions 4F:42B4/4370/4572; the
	; previous byte is a ret (function boundary) and the decode chain ends exactly at the next
	; region (site-validated inline far call `call $06D1`); no caller/table entry found (searched
	; far pointers, call/jp operands), so entry unproven
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call VBlank_WaitStartDI
	ld hl, $D800

	; [PROBABLE] 38 insn(s) reached by static flow only; seeds: site x38; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Palette_ReadHardwareToBuffer
	ei
	call Sound_FrameService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]

Palette_FadeOutToBlackSlow:: ; 4F:4497
Function_4F_4497::
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0080
	ld de, $D880
	ld hl, $D800
	call CopyBytes
	ld a, $00
	ld [wPalFadeMode], a
	ld bc, $0000
	ld a, $10
	call PalFade_Start
	call PalFade_Step
.loop ; 4F:44C0
	call VBlank_WaitStartDI
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
	call PalFade_Step
	jr nz, .loop
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Palette_FadeInFromWhiteObjPalSlow:: ; 4F:44DF
Function_4F_44DF::
	; [PROBABLE] function prologue (ldh [$FFF2],a / ldh a,[$FF8D] / push af / ... ld a,$07 / ldh
	; [$FF8D],a / ldh [$FF70],a ...), identical to the executed functions 4F:42B4/4370/4572; the
	; previous byte is a ret (function boundary) and the decode chain ends exactly at the next
	; region (site-validated inline far call `call $06D1`); no caller/table entry found (searched
	; far pointers, call/jp operands), so entry unproven
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0080
	ld de, $D880
	ld hl, $D800
	call CopyBytes
	ld a, $03
	ld [wPalFadeMode], a
	ld bc, $7FFF
	ld a, $F0
	call PalFade_Start
	call PalFade_Step
	call LCDOn

.loop ; 4F:450B
	; [PROBABLE] 13 insn(s) reached by static flow only; seeds: site x13; min discovery hops 0;
	; entered by jrcc from 4F:451E (PROBABLE code)
	call VBlank_WaitStartDI
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
	call PalFade_Step
	jr nz, .loop
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Palette_FadeOutToWhiteObjPalSlow:: ; 4F:452A
Function_4F_452A::
	; [PROBABLE] function prologue (ldh [$FFF2],a / ldh a,[$FF8D] / push af / ... ld a,$07 / ldh
	; [$FF8D],a / ldh [$FF70],a ...), identical to the executed functions 4F:42B4/4370/4572; the
	; previous byte is a ret (function boundary) and the decode chain ends exactly at the next
	; region (site-validated inline far call `call $06D1`); no caller/table entry found (searched
	; far pointers, call/jp operands), so entry unproven
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0080
	ld de, $D880
	ld hl, $D800
	call CopyBytes
	ld a, $03
	ld [wPalFadeMode], a
	ld bc, $7FFF
	ld a, $10
	call PalFade_Start
	call PalFade_Step

.loop ; 4F:4553
	; [PROBABLE] 13 insn(s) reached by static flow only; seeds: site x13; min discovery hops 0;
	; entered by jrcc from 4F:4566 (PROBABLE code)
	call VBlank_WaitStartDI
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
	call PalFade_Step
	jr nz, .loop
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret
