; home/vblank.asm
; bank 00, $0392-$04D8 (326 bytes); pinned by layout.link
; frame service, Int_VBlank, VBlank waits, RAM interrupt stub installer

SECTION "home/vblank", ROM0

; ---- code $0392-$03BA (40 bytes) [CONFIRMED] frame service, at most once per frame: skips if C2BF!=0, sets C2BF=1 (Int_VBlank clears it), saves BC/DE/HL and the WRAM bank, rSVBK=1 (FF8D is not updated), call 04:4082 through stub 20A6 (the stub returns A=$FF without entering bank 04 when D000 bit7 is already set, 2125; D000 is uninitialised at the first call from Boot/LCDOff, so whether 04:4082 runs then depends on power-on WRAM), restores. The first 4 instructions (FFFC compare) have no effect. Called from the wait loops (14 call sites in ROM0) and from other banks (173 raw call patterns)

Function_00_0392:: ; 00:0392
	push af
	ldh a, [hFramesWithoutService]
	cp a, $01
	jr c, Label_00_039A
	nop

Label_00_039A:: ; 00:039A
	ld a, [wFrameServiceRan]
	or a, a
	jr nz, Label_00_03B8
	ld a, $01
	ld [wFrameServiceRan], a
	push bc
	push de
	push hl
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20A6
	pop af
	ldh [rSVBK], a
	pop hl
	pop de
	pop bc

Label_00_03B8:: ; 00:03B8
	pop af
	ret

; ---- code $03BA-$044B (145 bytes) [CONFIRMED] VBlank interrupt handler (RAM vector CBF1 -> jp $03BA): unless [C2F5]!=0 run OAM DMA (call $FF80); increments the saturating VBlank counter C2DF; advances two frame/second/minute clocks (C2D4-C2D6 gated by C69F.bit4: at 70 minutes minutes:=60 and C26F.bit1 is cleared; C266-C268 gated by C69F.bit0: minutes saturate at [C26D]); updates FFFC/C2BF; reti

Int_VBlank:: ; 00:03BA
	push af
	ld a, [wOAMDMASuppress]
	or a, a
	jr nz, Label_00_03C4
	call OAMDMARoutine

Label_00_03C4:: ; 00:03C4
	push bc
	push de
	push hl
	ld a, [wVBlankFlag]
	inc a
	jr z, Label_00_03D0
	ld [wVBlankFlag], a

Label_00_03D0:: ; 00:03D0
	ld a, [wTimerEnable]
	bit 4, a
	ld a, $01
	jr nz, Label_00_03DA
	xor a, a

Label_00_03DA:: ; 00:03DA
	ld hl, $C2D4
	add a, [hl]
	cp a, $3C
	jr c, Label_00_0400
	xor a, a
	ld [hli], a
	ld a, $01
	add a, [hl]
	cp a, $3C
	jr c, Label_00_0400
	xor a, a
	ld [hli], a
	ld a, $01
	add a, [hl]
	cp a, $46
	jr c, Label_00_0400
	push hl
	ld hl, $C26F
	res 1, [hl]
	pop hl
	ld a, $3C
	ld [hld], a
	xor a, a
	ld [hld], a

Label_00_0400:: ; 00:0400
	ld [hl], a
	ld a, [wTimerEnable]
	bit 0, a
	ld a, $01
	jr nz, Label_00_040B
	xor a, a

Label_00_040B:: ; 00:040B
	ld hl, $C266
	add a, [hl]
	cp a, $3C
	jr c, Label_00_042E
	xor a, a
	ld [hli], a
	ld a, $01
	add a, [hl]
	cp a, $3C
	jr c, Label_00_042E
	xor a, a
	ld [hli], a
	ld a, [wCommTimeoutMinutes]
	ld c, a
	ld a, $01
	add a, [hl]
	cp a, c
	jr c, Label_00_042E
	ld a, [wCommTimeoutMinutes]
	ld [hld], a
	xor a, a
	ld [hld], a

Label_00_042E:: ; 00:042E
	ld [hl], a
	ld a, [wFrameServiceRan]
	or a, a
	jr nz, Label_00_0440
	ldh a, [hFramesWithoutService]
	inc a
	ldh [hFramesWithoutService], a
	xor a, a
	ld [wFrameServiceRan], a
	jr Label_00_0446

Label_00_0440:: ; 00:0440
	xor a, a
	ldh [hFramesWithoutService], a
	ld [wFrameServiceRan], a

Label_00_0446:: ; 00:0446
	pop hl
	pop de
	pop bc
	pop af
	reti

; ---- code $044B-$0464 (25 bytes) [CONFIRMED] wait for VBlank then run the frame service: if LCD on {ei; halt} until C2DF!=0; clear C2DF; call 0392

Function_00_044B:: ; 00:044B
	push af
	ldh a, [rLCDC]
	bit 7, a
	jr z, Label_00_045B
	ei

Label_00_0453:: ; 00:0453
	halt
	nop
	ld a, [wVBlankFlag]
	and a, a
	jr z, Label_00_0453

Label_00_045B:: ; 00:045B
	xor a, a
	ld [wVBlankFlag], a
	call Function_00_0392
	pop af
	ret

; ---- code $0464-$047A (22 bytes) [CONFIRMED] wait for VBlank flag only (ei; halt until C2DF!=0; clear C2DF); no frame service. Most referenced helper of the ROM (401 raw call sites) [reached via inferred links; raw refs 404] [executed in 32 scenarios]

Function_00_0464:: ; 00:0464
	push af
	ldh a, [rLCDC]
	bit 7, a
	jr z, Label_00_0474
	ei

Label_00_046C:: ; 00:046C
	halt
	nop
	ld a, [wVBlankFlag]
	and a, a
	jr z, Label_00_046C

Label_00_0474:: ; 00:0474
	xor a, a
	ld [wVBlankFlag], a
	pop af
	ret

; ---- code $047A-$04A0 (38 bytes) [CONFIRMED] wait for VBlank; returns with IME=0 right after the VBlank interrupt (LY>=$90); if woken late (LY<$90) clears the flag, calls 0392 and waits again

Function_00_047A:: ; 00:047A
	push af
	ldh a, [rLCDC]
	bit 7, a
	jr z, Label_00_0491

Label_00_0481:: ; 00:0481
	ei
	halt
	nop
	di
	ld a, [wVBlankFlag]
	and a, a
	jr z, Label_00_0481
	ldh a, [rLY]
	cp a, $90
	jr c, Label_00_0497

Label_00_0491:: ; 00:0491
	xor a, a
	ld [wVBlankFlag], a
	pop af
	ret

Label_00_0497:: ; 00:0497
	xor a, a
	ld [wVBlankFlag], a
	call Function_00_0392
	jr Label_00_0481

; ---- code $04A0-$04D8 (56 bytes) [CONFIRMED] installs the RAM interrupt stubs: CBF1=jp $03BA, CBF4=reti, CBF7=jp $01ED, CBFA=jp $01B7, CBFD=reti (bytes written one by one; verified on interpreter) [reached via inferred links; raw refs 12] [executed in 41 scenarios]

Function_00_04A0:: ; 00:04A0
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
