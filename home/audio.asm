; home/audio.asm
; bank 00, $20A0-$2183 (227 bytes); pinned by layout.link
; bank 04 gateway: 13 stubs, re-entrancy guard, bank save/restore, far byte readers; pinned at org $20A0

SECTION "home/audio", ROM0

Function_00_20A0:: ; 00:20A0
	; [CONFIRMED] stub: call 20EE (select ROM bank 4 and remember previous) ; jp 04:4000. Called
	; once from Boot with SVBK=1
	call Function_00_20EE
	jp SoundDrv_Init

Function_00_20A6:: ; 00:20A6
	; [CONFIRMED] stub: call 2129 (re-entrancy guard) ; jp 04:4082. Called from the frame service
	; 0392
	call Function_00_2129
	jp SoundDrv_FrameTick

Function_00_20AC:: ; 00:20AC
	; [CONFIRMED] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx
	call Function_00_2116
	jp SoundDrv_PlaySfx

Function_00_20B2:: ; 00:20B2
	; [CONFIRMED] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [reached via inferred
	; links; raw refs 65] [executed in 34 scenarios]
	call Function_00_2116
	jp SoundDrv_PlayMusic

Function_00_20B8:: ; 00:20B8
	; [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 14]
	call Function_00_2116
	jp SoundDrv_PlayMusicIfNotPlaying

Function_00_20BE:: ; 00:20BE
	; [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 3] |
	; forced execution: 2/2 instruction starts ran in forced_debug (traces/forced/, not natural
	; evidence; status unchanged)
	call Function_00_2116
	jp SoundDrv_StopSfxById

Function_00_20C4:: ; 00:20C4
	; [CONFIRMED] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx
	call Function_00_2116
	jp SoundDrv_PauseMusic

Function_00_20CA:: ; 00:20CA
	; [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 10]
	call Function_00_2116
	jp SoundDrv_ResumeMusic

Function_00_20D0:: ; 00:20D0
	; [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; no static
	; referrer]
	call Function_00_2116
	jp SoundDrv_GetActiveMasks

Function_00_20D6:: ; 00:20D6
	; [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 3]
	call Function_00_2116
	jp SoundDrv_SetTrackParam

Function_00_20DC:: ; 00:20DC
	; [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; no static
	; referrer]
	call Function_00_2116
	jp SoundDrv_StartFadeOut

Function_00_20E2:: ; 00:20E2
	; [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 1]
	call Function_00_2116
	jp SoundDrv_GetPlayingId

Function_00_20E8:: ; 00:20E8
	; [CONFIRMED] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE;
	; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx
	call Function_00_2116
	jp SoundDrv_PlayMusicOrResume

Function_00_20EE:: ; 00:20EE
	; [CONFIRMED] saves ROM bank hi/lo (FF8B->D002, FF8A->D001), selects ROM bank 4 (hi=0, lo=4 via
	; [2000]); 20F8/20FF are the shared restore-bank-4 tail
	ldh a, [hROMBankHi]
	ld [wBank4SavedBankHi], a
	ldh a, [hROMBankLo]
	ld [wBank4SavedBankLo], a

Bank4_Restore:: ; 00:20F8
	ld a, $00
	call Function_00_2105
	ld a, $04

Bank4_SetLo:: ; 00:20FF
	ldh [hROMBankLo], a
	ld [rROMB0], a
	ret

Function_00_2105:: ; 00:2105
	; [CONFIRMED] ROM bank hi byte: FF8B <- A, [$3000] <- A
	ldh [hROMBankHi], a
	ld [rROMB1], a
	ret

Function_00_210B:: ; 00:210B
	; [CONFIRMED] restores the ROM bank saved at D001/D002 [reached via inferred links; raw refs 10]
	; [executed in 41 scenarios]
	ld a, [wBank4SavedBankHi]
	call Function_00_2105
	ld a, [wBank4SavedBankLo]
	jr Bank4_SetLo

Function_00_2116:: ; 00:2116
	; [CONFIRMED] stub guard used by 20AC..20EB: see stubs. D000 is banked WRAM: the guard state
	; lives in whichever WRAM bank is selected at the call (Boot and 0392 select bank 1 first)
	ld hl, $D000
	bit 7, [hl]
	jr nz, Label_00_2125

Label_00_211D:: ; 00:211D
	set 7, [hl]
	push af
	call Function_00_20EE
	pop af
	ret

Label_00_2125:: ; 00:2125
	pop hl
	ld a, $FF
	ret

Function_00_2129:: ; 00:2129
	; [CONFIRMED] stub guard used by 20A6: if bank-4 already active (D000.bit7) and not pending,
	; sets D000.bit6 and saves the return address at D003/D004 (deferred call); else returns A=$FF
	ld hl, $D000
	bit 7, [hl]
	jr z, Label_00_211D
	bit 6, [hl]
	jr nz, Label_00_2125
	set 6, [hl]
	pop hl
	ld a, h
	ld [wBank4DeferredCall + 1], a
	ld a, l
	ld [wBank4DeferredCall], a
	xor a, a
	ret

Function_00_2141:: ; 00:2141
	; [CONFIRMED] return from bank 04: if D000.bit6 clear restore bank and clear bit7; else re-queue
	; the deferred stub address from D003/D004 (ret jumps to it) and clear bit6. 15 call sites in
	; bank 04 [reached via inferred links; raw refs 29] [executed in 1 scenarios]
	ld hl, $D000
	bit 6, [hl]
	jr nz, .l214F
	call Function_00_210B
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

Function_00_215E:: ; 00:215E
	; [CONFIRMED] reads C=[DE] from ROM bank ([D027]:[D026]) then returns to bank 4 (20F8); 9-bit
	; bank number [reached via inferred links; raw refs 7] [executed in 41 scenarios]
	ld a, [wBank4ReadBank + 1]
	call Function_00_2105
	ld a, [wBank4ReadBank]
	call Bank4_SetLo
	ld a, [de]
	ld c, a
	jp Bank4_Restore

Function_00_216F:: ; 00:216F
	; [CONFIRMED] like 215E but reads C=[DE], B=[DE+1] [reached via inferred links; raw refs 9]
	; [executed in 41 scenarios]
	ld a, [wBank4ReadBank + 1]
	call Function_00_2105
	ld a, [wBank4ReadBank]
	call Bank4_SetLo
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a
	jp Bank4_Restore
