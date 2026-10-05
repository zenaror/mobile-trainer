; home/vblank.asm
; bank 00, $0392-$04D8 (326 bytes); pinned by layout.link
; frame service, Int_VBlank, VBlank waits, RAM interrupt stub installer

SECTION "home/vblank", ROM0

Sound_FrameService:: ; 00:0392
Function_00_0392::
	; [CONFIRMED] frame service, at most once per frame: skips if C2BF!=0, sets C2BF=1 (Int_VBlank
	; clears it), saves BC/DE/HL and the WRAM bank, rSVBK=1 (FF8D is not updated), call 04:4082
	; through stub 20A6 (the stub returns A=$FF without entering bank 04 when D000 bit7 is already
	; set, 2125; D000 is uninitialised at the first call from Boot/LCDOff, so whether 04:4082 runs
	; then depends on power-on WRAM), restores. The first 4 instructions (FFFC compare) have no
	; effect. Called from the wait loops (14 call sites in ROM0) and from other banks (173 raw call
	; patterns)
	push af
	ldh a, [hFramesWithoutService]
	cp a, $01
	jr c, .skip
	nop
.skip ; 00:039A
	ld a, [wFrameServiceRan]
	or a, a
	jr nz, .l03B8
	ld a, $01
	ld [wFrameServiceRan], a
	push bc
	push de
	push hl
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_FrameTick
	pop af
	ldh [rSVBK], a
	pop hl
	pop de
	pop bc
.l03B8 ; 00:03B8
	pop af
	ret

Int_VBlank:: ; 00:03BA
	; [CONFIRMED] VBlank interrupt handler (RAM vector CBF1 -> jp $03BA): unless [C2F5]!=0 run OAM
	; DMA (call $FF80); increments the saturating VBlank counter C2DF; advances two
	; frame/second/minute clocks (C2D4-C2D6 gated by C69F.bit4: at 70 minutes minutes:=60 and
	; C26F.bit1 is cleared; C266-C268 gated by C69F.bit0: minutes saturate at [C26D]); updates
	; FFFC/C2BF; reti
	push af
	ld a, [wOAMDMASuppress]
	or a, a
	jr nz, .l03C4
	call OAMDMARoutine
.l03C4 ; 00:03C4
	push bc
	push de
	push hl
	ld a, [wVBlankFlag]
	inc a
	jr z, .l03D0
	ld [wVBlankFlag], a
.l03D0 ; 00:03D0
	ld a, [wTimerEnable]
	bit 4, a
	ld a, $01
	jr nz, .l03DA
	xor a, a
.l03DA ; 00:03DA
	ld hl, wTimerAFrames
	add a, [hl]
	cp a, $3C
	jr c, .l0400
	xor a, a
	ld [hli], a
	ld a, $01
	add a, [hl]
	cp a, $3C
	jr c, .l0400
	xor a, a
	ld [hli], a
	ld a, $01
	add a, [hl]
	cp a, $46
	jr c, .l0400
	push hl
	ld hl, wTimerAWarnFlags
	res 1, [hl]
	pop hl
	ld a, $3C
	ld [hld], a
	xor a, a
	ld [hld], a
.l0400 ; 00:0400
	ld [hl], a
	ld a, [wTimerEnable]
	bit 0, a
	ld a, $01
	jr nz, .l040B
	xor a, a
.l040B ; 00:040B
	ld hl, wTimerBFrames
	add a, [hl]
	cp a, $3C
	jr c, .l042E
	xor a, a
	ld [hli], a
	ld a, $01
	add a, [hl]
	cp a, $3C
	jr c, .l042E
	xor a, a
	ld [hli], a
	ld a, [wCommTimeoutMinutes]
	ld c, a
	ld a, $01
	add a, [hl]
	cp a, c
	jr c, .l042E
	ld a, [wCommTimeoutMinutes]
	ld [hld], a
	xor a, a
	ld [hld], a
.l042E ; 00:042E
	ld [hl], a
	ld a, [wFrameServiceRan]
	or a, a
	jr nz, .l0440
	ldh a, [hFramesWithoutService]
	inc a
	ldh [hFramesWithoutService], a
	xor a, a
	ld [wFrameServiceRan], a
	jr .l0446
.l0440 ; 00:0440
	xor a, a
	ldh [hFramesWithoutService], a
	ld [wFrameServiceRan], a
.l0446 ; 00:0446
	pop hl
	pop de
	pop bc
	pop af
	reti

VBlank_WaitAndService:: ; 00:044B
Function_00_044B::
	; [CONFIRMED] wait for VBlank then run the frame service: if LCD on {ei; halt} until C2DF!=0;
	; clear C2DF; call 0392
	push af
	ldh a, [rLCDC]
	bit 7, a
	jr z, .l045B
	ei
.loop ; 00:0453
	halt
	nop
	ld a, [wVBlankFlag]
	and a, a
	jr z, .loop
.l045B ; 00:045B
	xor a, a
	ld [wVBlankFlag], a
	call Sound_FrameService
	pop af
	ret

VBlank_Wait:: ; 00:0464
Function_00_0464::
	; [CONFIRMED] wait for VBlank flag only (ei; halt until C2DF!=0; clear C2DF); no frame service.
	; Most referenced helper of the ROM (401 raw call sites) [reached via inferred links; raw refs
	; 404] [executed in 32 scenarios]
	push af
	ldh a, [rLCDC]
	bit 7, a
	jr z, .l0474
	ei
.loop ; 00:046C
	halt
	nop
	ld a, [wVBlankFlag]
	and a, a
	jr z, .loop
.l0474 ; 00:0474
	xor a, a
	ld [wVBlankFlag], a
	pop af
	ret

VBlank_WaitStartDI:: ; 00:047A
Function_00_047A::
	; [CONFIRMED] wait for VBlank; returns with IME=0 right after the VBlank interrupt (LY>=$90); if
	; woken late (LY<$90) clears the flag, calls 0392 and waits again
	push af
	ldh a, [rLCDC]
	bit 7, a
	jr z, .l0491
.loop ; 00:0481
	ei
	halt
	nop
	di
	ld a, [wVBlankFlag]
	and a, a
	jr z, .loop
	ldh a, [rLY]
	cp a, $90
	jr c, .l0497
.l0491 ; 00:0491
	xor a, a
	ld [wVBlankFlag], a
	pop af
	ret
.l0497 ; 00:0497
	xor a, a
	ld [wVBlankFlag], a
	call Sound_FrameService
	jr .loop

Int_InstallRamVectors:: ; 00:04A0
Function_00_04A0::
	; [CONFIRMED] installs the RAM interrupt stubs: CBF1=jp $03BA, CBF4=reti, CBF7=jp $01ED, CBFA=jp
	; $01B7, CBFD=reti (bytes written one by one; verified on interpreter) [reached via inferred
	; links; raw refs 12] [executed in 41 scenarios]
	ld a, $C3
	ld [wVBlankVector], a
	ld a, $BA
	ld [wVBlankVector + 1], a
	ld a, $03
	ld [wVBlankVector + 2], a
	ld a, $D9
	ld [wLcdStatVector], a
	ld a, $D9
	ld [wJoypadVector], a
	ld a, $C3
	ld [wTimerVector], a
	ld a, $ED
	ld [wTimerVector + 1], a
	ld a, $01
	ld [wTimerVector + 2], a
	ld a, $C3
	ld [wSerialVector], a
	ld a, $B7
	ld [wSerialVector + 1], a
	ld a, $01
	ld [wSerialVector + 2], a
	ret
