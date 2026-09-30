; home/mobile.asm
; bank 00, $0150-$0278 (296 bytes); pinned by layout.link
; MobileAPI/ReturnMobileAPI shims, Int_Serial, Int_Timer (jump into bank 75), 0247 wrapper into bank 0F

SECTION "home/mobile", ROM0

MobileAPI:: ; 00:0150
	; [CONFIRMED] API entry with index in A (cp 2; args in HL/BC): stores A->C825, HL->C823/C824; if
	; A==2 also FF8A/FF8B<-HL (the bank pushed below, i.e. restored on return) and C820/21<-BC; sets
	; bit6 of C6C1; saves the current 16-bit ROM bank (FF8A/FF8B) on the stack, switches to bank 75
	; and jp 75:4030. Structurally identical to pokecrystal home MobileAPI (75:4030 = _MobileAPI,
	; which pushes $018D as its return address) [reached via inferred links; raw refs 54] [executed
	; in 41 scenarios]
	cp a, $02
	ld [wMobileAPIIndex], a
	ld a, l
	ld [wRam_C823], a
	ld a, h
	ld [wRam_C824], a
	jr nz, .l016B
	ldh [hROMBankHi], a
	ld a, l
	ldh [hROMBankLo], a
	ld hl, $C820
	ld a, c
	ld [hli], a
	ld a, b
	ld [hl], a
.l016B ; 00:016B
	ld hl, $C6C1
	set 6, [hl]
	ld hl, $FF8A
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld hl, $FF8A
	ld a, $75
	ld [hli], a
	ld a, $00
	ld [hl], a
	ld a, $75
	ld [rROMB0], a
	ld a, $00
	ld [rROMB1], a
	jp MobileSDK_ApiDispatch

ReturnMobileAPI:: ; 00:018D
	; [CONFIRMED] return path of MobileAPI: 75:4054-4057 pushes $018D before dispatching; saves A/HL
	; to C823-C825, pops saved ROM bank -> FF8A/FF8B + MBC, res 6,[C6C1], reloads HL/A, ret
	; [candidate; no static referrer] [executed in 41 scenarios]
	ld [wRam_C823], a
	ld a, l
	ld [wRam_C824], a
	ld a, h
	ld [wMobileAPIIndex], a
	pop de
	ld hl, $FF8A
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
	ld a, e
	ld [rROMB0], a
	ld a, d
	ld [rROMB1], a
	ld hl, $C6C1
	res 6, [hl]
	ld hl, $C824
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wRam_C823]
	ret

Int_Serial:: ; 00:01B7
	; [CONFIRMED] serial interrupt handler (RAM vector CBFA -> jp $01B7): push af/bc/de/hl; save
	; 16-bit ROM bank; switch to bank 75; call 75:56D2; restore bank; reti. Same shape as
	; pokecrystal MobileReceive
	push af
	push bc
	push de
	push hl
	ld hl, $FF8A
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld hl, $FF8A
	ld a, $75
	ld [hli], a
	ld a, $00
	ld [hl], a
	ld a, $75
	ld [rROMB0], a
	ld a, $00
	ld [rROMB1], a
	call MobileSDK_SerialReceive
	pop de
	ld hl, $FF8A
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
	ld a, e
	ld [rROMB0], a
	ld a, d
	ld [rROMB1], a
	pop hl
	pop de
	pop bc
	pop af
	reti

Int_Timer:: ; 00:01ED
	; [CONFIRMED] timer interrupt handler (RAM vector CBF7 -> jp $01ED): TAC=0; IF&=$1B; if
	; [C709]==0 return at once (01FE jr z,$0242: TIMA/TAC are NOT restarted, the timer stays
	; stopped); else, unless C6C1.bit1 or rSC.bit7 is set (then the bank-75 call is skipped,
	; 0205/020B jr nz,$023A), save ROM bank, call 75:58EA, restore; finally TIMA=TMA and TAC=6
	; (enable, clock select 10 = 65536 Hz, doubled to 131072 Hz in the CGB double-speed mode that
	; Boot selects). Same shape as pokecrystal MobileTimer
	push af
	push bc
	push de
	push hl
	xor a, a
	ldh [rTAC], a
	ldh a, [rIF]
	and a, $1B
	ldh [rIF], a
	ld a, [wMobileSDK_State]
	or a, a
	jr z, .l0242
	ld a, [wMobileFlags]
	bit 1, a
	jr nz, .l023A
	ldh a, [rSC]
	and a, $80
	jr nz, .l023A
	ld hl, $FF8A
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld hl, $FF8A
	ld a, $75
	ld [hli], a
	ld a, $00
	ld [hl], a
	ld a, $75
	ld [rROMB0], a
	ld a, $00
	ld [rROMB1], a
	call MobileSDK_TimerTick
	pop de
	ld hl, $FF8A
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
	ld a, e
	ld [rROMB0], a
	ld a, d
	ld [rROMB1], a
.l023A ; 00:023A
	ldh a, [rTMA]
	ldh [rTIMA], a
	ld a, $06
	ldh [rTAC], a
.l0242 ; 00:0242
	pop hl
	pop de
	pop bc
	pop af
	reti

Function_00_0247:: ; 00:0247
	; [CONFIRMED] wrapper: saves A to D002, pushes 16-bit ROM bank (FF8A/8B), selects bank 000F,
	; calls 0F:4247, restores bank and A. No static caller found [reached via inferred links; raw
	; refs 6] [executed in 9 scenarios]
	ld [wMail_Selector], a
	ldh a, [hROMBankLo]
	ld l, a
	ldh a, [hROMBankHi]
	ld h, a
	push hl
	ld hl, $000F
	ld a, l
	ldh [hROMBankLo], a
	ld a, h
	ldh [hROMBankHi], a
	ld a, l
	ld [$2100], a
	ld a, h
	ld [rROMB1], a
	call Mail_Dispatch
	pop de
	ld a, e
	ldh [hROMBankLo], a
	ld a, d
	ldh [hROMBankHi], a
	ld a, e
	ld [$2100], a
	ld a, d
	ld [rROMB1], a
	ld a, [wMail_Selector]
	ret
