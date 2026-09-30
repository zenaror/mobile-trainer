; home/audio.asm
; bank 00, $20A0-$2183 (227 bytes); pinned by layout.link
; bank 04 gateway: 13 stubs, re-entrancy guard, bank save/restore, far byte readers; pinned at org $20A0

SECTION "home/audio", ROM0

Sound_Init:: ; 00:20A0
Function_00_20A0::
	; [CONFIRMED] stub: call 20EE (select ROM bank 4 and remember previous) ; jp 04:4000. Called
	; once from Boot with SVBK=1
	call Bank4_SaveAndSelect
	jp SoundDrv_Init

Sound_FrameTick:: ; 00:20A6
Function_00_20A6::
	; [CONFIRMED] stub: call 2129 (re-entrancy guard) ; jp 04:4082. Called from the frame service
	; 0392
	call Bank4_GateEnterTick
	jp SoundDrv_FrameTick

Sound_PlaySfx:: ; 00:20AC
Function_00_20AC::
	; [CONFIRMED] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx
	call Bank4_GateEnter
	jp SoundDrv_PlaySfx

Sound_PlayMusic:: ; 00:20B2
Function_00_20B2::
	; [CONFIRMED] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [reached via inferred
	; links; raw refs 65] [executed in 34 scenarios]
	call Bank4_GateEnter
	jp SoundDrv_PlayMusic

Sound_PlayMusicIfNotPlaying:: ; 00:20B8
Function_00_20B8::
	; [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 14]
	call Bank4_GateEnter
	jp SoundDrv_PlayMusicIfNotPlaying

Sound_StopSfxById:: ; 00:20BE
Function_00_20BE::
	; [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 3] |
	; forced execution: 2/2 instruction starts ran in forced_debug (traces/forced/, not natural
	; evidence; status unchanged)
	call Bank4_GateEnter
	jp SoundDrv_StopSfxById

Sound_PauseMusic:: ; 00:20C4
Function_00_20C4::
	; [CONFIRMED] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx
	call Bank4_GateEnter
	jp SoundDrv_PauseMusic

Sound_ResumeMusic:: ; 00:20CA
Function_00_20CA::
	; [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 10]
	call Bank4_GateEnter
	jp SoundDrv_ResumeMusic

Sound_GetActiveMasks:: ; 00:20D0
Function_00_20D0::
	; [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; no static
	; referrer]
	call Bank4_GateEnter
	jp SoundDrv_GetActiveMasks

Sound_SetTrackParam:: ; 00:20D6
Function_00_20D6::
	; [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 3]
	call Bank4_GateEnter
	jp SoundDrv_SetTrackParam

Sound_StartFadeOut:: ; 00:20DC
Function_00_20DC::
	; [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; no static
	; referrer]
	call Bank4_GateEnter
	jp SoundDrv_StartFadeOut

Sound_GetPlayingId:: ; 00:20E2
Function_00_20E2::
	; [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 1]
	call Bank4_GateEnter
	jp SoundDrv_GetPlayingId

Sound_PlayMusicOrResume:: ; 00:20E8
Function_00_20E8::
	; [CONFIRMED] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx
	call Bank4_GateEnter
	jp SoundDrv_PlayMusicOrResume

Bank4_SaveAndSelect:: ; 00:20EE
Function_00_20EE::
	; [CONFIRMED] saves ROM bank hi/lo (FF8B->D002, FF8A->D001), selects ROM bank 4 (hi=0, lo=4 via
	; [2000]); 20F8/20FF are the shared restore-bank-4 tail
	ldh a, [hROMBankHi]
	ld [wBank4SavedBankHi], a
	ldh a, [hROMBankLo]
	ld [wBank4SavedBankLo], a

Bank4_Restore:: ; 00:20F8
	ld a, $00
	call Bank4_SetHi
	ld a, $04

Bank4_SetLo:: ; 00:20FF
	ldh [hROMBankLo], a
	ld [rROMB0], a
	ret

Bank4_SetHi:: ; 00:2105
Function_00_2105::
	; [CONFIRMED] ROM bank hi byte: FF8B <- A, [$3000] <- A
	ldh [hROMBankHi], a
	ld [rROMB1], a
	ret

Bank4_RestoreCallerBank:: ; 00:210B
Function_00_210B::
	; [CONFIRMED] restores the ROM bank saved at D001/D002 [reached via inferred links; raw refs 10]
	; [executed in 41 scenarios]
	ld a, [wBank4SavedBankHi]
	call Bank4_SetHi
	ld a, [wBank4SavedBankLo]
	jr Bank4_SetLo

Bank4_GateEnter:: ; 00:2116
Function_00_2116::
	; [CONFIRMED] stub guard used by 20AC..20EB: see stubs. D000 is banked WRAM: the guard state
	; lives in whichever WRAM bank is selected at the call (Boot and 0392 select bank 1 first)
	ld hl, $D000
	bit 7, [hl]
	jr nz, Bank4_GateReturnBusy

Bank4_GateSetBusy:: ; 00:211D
Label_00_211D::
	set 7, [hl]
	push af
	call Bank4_SaveAndSelect
	pop af
	ret

Bank4_GateReturnBusy:: ; 00:2125
Label_00_2125::
	pop hl
	ld a, $FF
	ret

Bank4_GateEnterTick:: ; 00:2129
Function_00_2129::
	; [CONFIRMED] stub guard used by 20A6: if bank-4 already active (D000.bit7) and not pending,
	; sets D000.bit6 and saves the return address at D003/D004 (deferred call); else returns A=$FF
	ld hl, $D000
	bit 7, [hl]
	jr z, Bank4_GateSetBusy
	bit 6, [hl]
	jr nz, Bank4_GateReturnBusy
	set 6, [hl]
	pop hl
	ld a, h
	ld [wBank4DeferredCall + 1], a
	ld a, l
	ld [wBank4DeferredCall], a
	xor a, a
	ret

Bank4_GateLeave:: ; 00:2141
Function_00_2141::
	; [CONFIRMED] return from bank 04: if D000.bit6 clear restore bank and clear bit7; else re-queue
	; the deferred stub address from D003/D004 (ret jumps to it) and clear bit6. 15 call sites in
	; bank 04 [reached via inferred links; raw refs 29] [executed in 1 scenarios]
	ld hl, $D000
	bit 6, [hl]
	jr nz, .l214F
	call Bank4_RestoreCallerBank
	res 7, [hl]
	xor a, a
	ret
.l214F ; 00:214F
	ld a, [wBank4DeferredCall + 1]
	ld h, a
	ld a, [wBank4DeferredCall]
	ld l, a
	push hl
	ld hl, $D000
	res 6, [hl]
	ret

SoundDrv_ReadStreamByte:: ; 00:215E
Function_00_215E::
	; [CONFIRMED] reads C=[DE] from ROM bank ([D027]:[D026]) then returns to bank 4 (20F8); 9-bit
	; bank number [reached via inferred links; raw refs 7] [executed in 41 scenarios]
	ld a, [wBank4ReadBank + 1]
	call Bank4_SetHi
	ld a, [wBank4ReadBank]
	call Bank4_SetLo
	ld a, [de]
	ld c, a
	jp Bank4_Restore

SoundDrv_ReadStreamWord:: ; 00:216F
Function_00_216F::
	; [CONFIRMED] like 215E but reads C=[DE], B=[DE+1] [reached via inferred links; raw refs 9]
	; [executed in 41 scenarios]
	ld a, [wBank4ReadBank + 1]
	call Bank4_SetHi
	ld a, [wBank4ReadBank]
	call Bank4_SetLo
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a
	jp Bank4_Restore
