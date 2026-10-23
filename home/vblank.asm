; home/vblank.asm
; bank 00, $0392-$04D8 (326 bytes); pinned by layout.link
; frame service, Int_VBlank, VBlank waits, RAM interrupt stub installer

SECTION "home/vblank", ROM0

Sound_FrameService:: ; 00:0392
	; Historical address alias retired; proper operation name retained.
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
	jr c, .check_frame_service_flag
	nop
.check_frame_service_flag ; 00:039A
	ld a, [wFrameServiceRan]
	or a, a
	jr nz, .pop_af_and_return
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
.pop_af_and_return ; 00:03B8
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
	jr nz, .save_registers_and_increment_vblank_flag
	call OAMDMARoutine
.save_registers_and_increment_vblank_flag ; 00:03C4
	push bc
	push de
	push hl
	ld a, [wVBlankFlag]
	inc a
	jr z, .derive_timer_a_increment_from_bit4
	ld [wVBlankFlag], a
.derive_timer_a_increment_from_bit4 ; 00:03D0
	ld a, [wTimerEnable]
	bit 4, a
	ld a, $01
	jr nz, .advance_timer_a
	xor a, a
.advance_timer_a ; 00:03DA
	ld hl, wTimerAFrames
	add a, [hl]
	cp a, $3C
	jr c, .store_timer_a_and_check_timer_b_enable
	xor a, a
	ld [hli], a
	ld a, $01
	add a, [hl]
	cp a, $3C
	jr c, .store_timer_a_and_check_timer_b_enable
	xor a, a
	ld [hli], a
	ld a, $01
	add a, [hl]
	cp a, $46
	jr c, .store_timer_a_and_check_timer_b_enable
	push hl
	ld hl, wTimerAWarnFlags
	res 1, [hl]
	pop hl
	ld a, $3C
	ld [hld], a
	xor a, a
	ld [hld], a
.store_timer_a_and_check_timer_b_enable ; 00:0400
	ld [hl], a
	ld a, [wTimerEnable]
	bit 0, a
	ld a, $01
	jr nz, .advance_timer_b
	xor a, a
.advance_timer_b ; 00:040B
	ld hl, wTimerBFrames
	add a, [hl]
	cp a, $3C
	jr c, .store_timer_b_and_check_frame_service
	xor a, a
	ld [hli], a
	ld a, $01
	add a, [hl]
	cp a, $3C
	jr c, .store_timer_b_and_check_frame_service
	xor a, a
	ld [hli], a
	ld a, [wCommTimeoutMinutes]
	ld c, a
	ld a, $01
	add a, [hl]
	cp a, c
	jr c, .store_timer_b_and_check_frame_service
	ld a, [wCommTimeoutMinutes]
	ld [hld], a
	xor a, a
	ld [hld], a
.store_timer_b_and_check_frame_service ; 00:042E
	ld [hl], a
	ld a, [wFrameServiceRan]
	or a, a
	jr nz, .clear_missed_service_count
	ldh a, [hFramesWithoutService]
	inc a
	ldh [hFramesWithoutService], a
	xor a, a
	ld [wFrameServiceRan], a
	jr .pop_registers_and_reti
.clear_missed_service_count ; 00:0440
	xor a, a
	ldh [hFramesWithoutService], a
	ld [wFrameServiceRan], a
.pop_registers_and_reti ; 00:0446
	pop hl
	pop de
	pop bc
	pop af
	reti

VBlank_WaitAndService:: ; 00:044B
	; Historical address alias retired; proper operation name retained.
	; [CONFIRMED] wait for VBlank then run the frame service: if LCD on {ei; halt} until C2DF!=0;
	; clear C2DF; call 0392
	push af
	ldh a, [rLCDC]
	bit 7, a
	jr z, .clear_vblank_flag_and_service
	ei
.wait_for_vblank_flag ; 00:0453
	halt
	nop
	ld a, [wVBlankFlag]
	and a, a
	jr z, .wait_for_vblank_flag
.clear_vblank_flag_and_service ; 00:045B
	xor a, a
	ld [wVBlankFlag], a
	call Sound_FrameService
	pop af
	ret

VBlank_Wait:: ; 00:0464
	; Historical address alias retired; proper operation name retained.
	; [CONFIRMED] wait for VBlank flag only (ei; halt until C2DF!=0; clear C2DF); no frame service.
	; Most referenced helper of the ROM (401 raw call sites) [reached via inferred links; raw refs
	; 404] [executed in 32 scenarios]
	push af
	ldh a, [rLCDC]
	bit 7, a
	jr z, .clear_vblank_flag_and_return
	ei
.wait_for_vblank_flag ; 00:046C
	halt
	nop
	ld a, [wVBlankFlag]
	and a, a
	jr z, .wait_for_vblank_flag
.clear_vblank_flag_and_return ; 00:0474
	xor a, a
	ld [wVBlankFlag], a
	pop af
	ret

VBlank_WaitStartDI:: ; 00:047A
	; Historical address alias retired; proper operation name retained.
	; [CONFIRMED] completed LCD-on wait: return IME=0, LY>=$90; late wakes retry.
	; LCD-off exit skips EI/HALT/DI and keeps incoming IME absent interference.
	push af
	ldh a, [rLCDC]
	bit 7, a
	jr z, .clear_vblank_flag_and_return
.wait_for_vblank_start ; 00:0481
	ei
	halt
	nop
	di
	ld a, [wVBlankFlag]
	and a, a
	jr z, .wait_for_vblank_start
	ldh a, [rLY]
	cp a, $90
	jr c, .clear_vblank_flag_and_retry_service
.clear_vblank_flag_and_return ; 00:0491
	xor a, a
	ld [wVBlankFlag], a
	pop af
	ret
.clear_vblank_flag_and_retry_service ; 00:0497
	xor a, a
	ld [wVBlankFlag], a
	call Sound_FrameService
	jr .wait_for_vblank_start

Int_InstallRamVectors:: ; 00:04A0
	; Historical address alias retired; proper operation name retained.
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
