; home/audio.asm
; bank 00, $20A0-$2183 (227 bytes); pinned by layout.link
; bank 04 gateway: 13 stubs, re-entrancy guard, bank save/restore, far byte readers; pinned at org $20A0

SECTION "home/audio", ROM0

; ---- code $20A0-$20A6 (6 bytes) [CONFIRMED] stub: call 20EE (select ROM bank 4 and remember previous) ; jp 04:4000. Called once from Boot with SVBK=1

Function_00_20A0:: ; 00:20A0
	call Function_00_20EE
	jp SoundDrv_Init

; ---- code $20A6-$20AC (6 bytes) [CONFIRMED] stub: call 2129 (re-entrancy guard) ; jp 04:4082. Called from the frame service 0392

Function_00_20A6:: ; 00:20A6
	call Function_00_2129
	jp SoundDrv_FrameTick

; ---- code $20AC-$20B2 (6 bytes) [CONFIRMED] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx

Function_00_20AC:: ; 00:20AC
	call Function_00_2116
	jp SoundDrv_PlaySfx

; ---- code $20B2-$20B8 (6 bytes) [CONFIRMED] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [reached via inferred links; raw refs 65] [executed in 34 scenarios]

Function_00_20B2:: ; 00:20B2
	call Function_00_2116
	jp SoundDrv_PlayMusic

; ---- code $20B8-$20BE (6 bytes) [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 14]

Function_00_20B8:: ; 00:20B8
	call Function_00_2116
	jp SoundDrv_PlayMusicIfNotPlaying

; ---- code $20BE-$20C4 (6 bytes) [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 3] | forced execution: 2/2 instruction starts ran in forced_debug (traces/forced/, not natural evidence; status unchanged)

Function_00_20BE:: ; 00:20BE
	call Function_00_2116
	jp SoundDrv_StopSfxById

; ---- code $20C4-$20CA (6 bytes) [CONFIRMED] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx

Function_00_20C4:: ; 00:20C4
	call Function_00_2116
	jp SoundDrv_PauseMusic

; ---- code $20CA-$20D0 (6 bytes) [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 10]

Function_00_20CA:: ; 00:20CA
	call Function_00_2116
	jp SoundDrv_ResumeMusic

; ---- code $20D0-$20D6 (6 bytes) [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; no static referrer]

Function_00_20D0:: ; 00:20D0
	call Function_00_2116
	jp SoundDrv_GetActiveMasks

; ---- code $20D6-$20DC (6 bytes) [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 3]

Function_00_20D6:: ; 00:20D6
	call Function_00_2116
	jp SoundDrv_SetTrackParam

; ---- code $20DC-$20E2 (6 bytes) [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; no static referrer]

Function_00_20DC:: ; 00:20DC
	call Function_00_2116
	jp SoundDrv_StartFadeOut

; ---- code $20E2-$20E8 (6 bytes) [PROBABLE] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 1]

Function_00_20E2:: ; 00:20E2
	call Function_00_2116
	jp SoundDrv_GetPlayingId

; ---- code $20E8-$20EE (6 bytes) [CONFIRMED] stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx

Function_00_20E8:: ; 00:20E8
	call Function_00_2116
	jp SoundDrv_PlayMusicOrResume

; ---- code $20EE-$2105 (23 bytes) [CONFIRMED] saves ROM bank hi/lo (FF8B->D002, FF8A->D001), selects ROM bank 4 (hi=0, lo=4 via [2000]); 20F8/20FF are the shared restore-bank-4 tail

Function_00_20EE:: ; 00:20EE
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

; ---- code $2105-$210B (6 bytes) [CONFIRMED] ROM bank hi byte: FF8B <- A, [$3000] <- A

Function_00_2105:: ; 00:2105
	ldh [hROMBankHi], a
	ld [rROMB1], a
	ret

; ---- code $210B-$2116 (11 bytes) [CONFIRMED] restores the ROM bank saved at D001/D002 [reached via inferred links; raw refs 10] [executed in 41 scenarios]

Function_00_210B:: ; 00:210B
	ld a, [wBank4SavedBankHi]
	call Function_00_2105
	ld a, [wBank4SavedBankLo]
	jr Bank4_SetLo

; ---- code $2116-$2129 (19 bytes) [CONFIRMED] stub guard used by 20AC..20EB: see stubs. D000 is banked WRAM: the guard state lives in whichever WRAM bank is selected at the call (Boot and 0392 select bank 1 first)

Function_00_2116:: ; 00:2116
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

; ---- code $2129-$2141 (24 bytes) [CONFIRMED] stub guard used by 20A6: if bank-4 already active (D000.bit7) and not pending, sets D000.bit6 and saves the return address at D003/D004 (deferred call); else returns A=$FF

Function_00_2129:: ; 00:2129
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

; ---- code $2141-$215E (29 bytes) [CONFIRMED] return from bank 04: if D000.bit6 clear restore bank and clear bit7; else re-queue the deferred stub address from D003/D004 (ret jumps to it) and clear bit6. 15 call sites in bank 04 [reached via inferred links; raw refs 29] [executed in 1 scenarios]

Function_00_2141:: ; 00:2141
	ld hl, $D000
	bit 6, [hl]
	jr nz, Label_00_214F
	call Function_00_210B
	res 7, [hl]
	xor a, a
	ret

Label_00_214F:: ; 00:214F
	ld a, [wBank4DeferredCall + 1]
	ld h, a
	ld a, [wBank4DeferredCall]
	ld l, a
	push hl
	ld hl, $D000
	res 6, [hl]
	ret

; ---- code $215E-$216F (17 bytes) [CONFIRMED] reads C=[DE] from ROM bank ([D027]:[D026]) then returns to bank 4 (20F8); 9-bit bank number [reached via inferred links; raw refs 7] [executed in 41 scenarios]

Function_00_215E:: ; 00:215E
	ld a, [wBank4ReadBank + 1]
	call Function_00_2105
	ld a, [wBank4ReadBank]
	call Bank4_SetLo
	ld a, [de]
	ld c, a
	jp Bank4_Restore

; ---- code $216F-$2183 (20 bytes) [CONFIRMED] like 215E but reads C=[DE], B=[DE+1] [reached via inferred links; raw refs 9] [executed in 41 scenarios]

Function_00_216F:: ; 00:216F
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
