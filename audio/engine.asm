; audio/engine.asm
; bank 04, $4000-$5044 (4164 bytes); pinned by layout.link
; sound driver code and its command/parameter jump tables

SECTION "audio/engine", ROMX

; ---- code $4000-$409F (159 bytes) [CONFIRMED] 81 insn(s); 81 executed (in up to 18/18 scenarios)

SoundDrv_Init:: ; 04:4000
	ld a, $FF
	ld [wBank4State], a
	ld a, [wBank4SavedBankLo]
	push af
	ld a, [wBank4SavedBankHi]
	push af
	ld hl, $D001
	ld b, $3F
	xor a, a

Label_04_4013:: ; 04:4013
	ld [hli], a
	dec b
	jr nz, Label_04_4013
	pop af
	ld [wBank4SavedBankHi], a
	pop af
	ld [wBank4SavedBankLo], a
	ld a, $4A
	ld [wSoundDrv_SfxTempo], a
	ld [wSoundDrv_SfxTempoStep], a
	ld [wSoundDrv_MusicTempo], a
	ld [wSoundDrv_MusicTempoStep], a
	ld a, $40
	ld [wSoundDrv_SfxTempoScale], a
	ld [wSoundDrv_MusicTempoScale], a
	ld a, $FF
	ld [wSoundDrv_WaveCache], a
	xor a, a
	ld b, $08
	ld de, $003C
	ld hl, $D040

Label_04_4043:: ; 04:4043
	ld [hl], a
	add hl, de
	dec b
	jr nz, Label_04_4043
	xor a, a
	ld b, $04
	ld de, $0018
	ld hl, $D220

Label_04_4051:: ; 04:4051
	ld [hl], a
	add hl, de
	dec b
	jr nz, Label_04_4051
	ld a, $80
	ldh [rNR52], a
	ld a, $00
	ldh [rNR51], a
	ld a, $08
	ldh [rNR12], a
	ldh [rNR22], a
	ldh [rNR42], a
	ld a, $80
	ldh [rNR14], a
	ldh [rNR24], a
	ldh [rNR44], a
	ld a, $00
	ldh [rNR30], a
	ld a, $FF
	ldh [rNR51], a
	ld a, $77
	ldh [rNR50], a
	ld a, $00
	ld [wBank4State], a
	jp Function_00_210B

SoundDrv_FrameTick:: ; 04:4082
	push bc
	push de
	call SoundDrv_UpdateFade
	ld hl, $D000
	set 5, [hl]
	ld hl, $D007
	ld a, [hli]
	add a, [hl]
	ld [hli], a
	ld a, $00
	adc a, [hl]
	ld [hld], a
	ld a, [hli]
	sub a, $4A
	ld b, a
	ld a, [hl]
	sbc a, $00
	jr nc, SoundDrv_SfxTickLoop

; ---- code $409F-$40AC (13 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 04:409D (executed) | forced execution: 5/5 instruction starts ran in forced_debug (traces/forced/, not natural evidence; status unchanged)
	call SoundDrv_SelectSfxTracks

Label_04_40A2:: ; 04:40A2
	call SoundDrv_ApplyTrackUpdates
	call SoundDrv_NextTrack
	jr nz, Label_04_40A2
	jr SoundDrv_MusicPhase

; ---- code $40AC-$415A (174 bytes) [CONFIRMED] 86 insn(s); 86 executed (in up to 18/18 scenarios)

SoundDrv_SfxTickLoop:: ; 04:40AC
	ld [hld], a
	ld [hl], b
	call SoundDrv_SelectAllChannels

Label_04_40B1:: ; 04:40B1
	call SoundDrv_ServiceChannelSfx
	call SoundDrv_NextChannel
	jr nz, Label_04_40B1
	call SoundDrv_SelectSfxTracks

Label_04_40BC:: ; 04:40BC
	call SoundDrv_StepTrack
	call SoundDrv_NextTrack
	jr nz, Label_04_40BC
	ld hl, $D008
	ld a, [hli]
	sub a, $4A
	ld b, a
	ld a, [hl]
	sbc a, $00
	jr nc, SoundDrv_SfxTickLoop

SoundDrv_MusicPhase:: ; 04:40D0
	ld hl, $D000
	res 5, [hl]
	ld hl, $D00C
	ld a, [hli]
	add a, [hl]
	ld [hli], a
	ld a, $00
	adc a, [hl]
	ld [hld], a
	ld a, [hli]
	sub a, $4A
	ld b, a
	ld a, [hl]
	sbc a, $00
	jr nc, SoundDrv_MusicTickLoop
	call SoundDrv_SelectMusicTracks

Label_04_40EB:: ; 04:40EB
	call SoundDrv_ApplyTrackUpdates
	call SoundDrv_NextTrack
	jr nz, Label_04_40EB
	jr SoundDrv_ChannelPhase

SoundDrv_MusicTickLoop:: ; 04:40F5
	ld [hld], a
	ld [hl], b
	call SoundDrv_SelectAllChannels

Label_04_40FA:: ; 04:40FA
	call SoundDrv_ServiceChannelMusic
	call SoundDrv_NextChannel
	jr nz, Label_04_40FA
	call SoundDrv_SelectMusicTracks

Label_04_4105:: ; 04:4105
	call SoundDrv_StepTrack
	call SoundDrv_NextTrack
	jr nz, Label_04_4105
	ld hl, $D00D
	ld a, [hli]
	sub a, $4A
	ld b, a
	ld a, [hl]
	sbc a, $00
	jr nc, SoundDrv_MusicTickLoop

SoundDrv_ChannelPhase:: ; 04:4119
	call SoundDrv_SelectAllChannels

Label_04_411C:: ; 04:411C
	call SoundDrv_UpdateChannel
	call SoundDrv_NextChannel
	jr nz, Label_04_411C
	ld a, [wSoundDrv_TickDivider]
	and a, a
	jr nz, Label_04_412C
	ld a, $0F

Label_04_412C:: ; 04:412C
	dec a
	ld [wSoundDrv_TickDivider], a
	ld c, $08
	ld de, $003C
	ld hl, $D040

Label_04_4138:: ; 04:4138
	ld a, [hl]
	and a, $F8
	ld [hl], a
	rla
	rr b
	add hl, de
	dec c
	jr nz, Label_04_4138
	ld a, b
	ld [wSoundDrv_ActiveMask], a
	pop de
	pop bc
	jp Function_00_2141

SoundDrv_SelectSfxTracks:: ; 04:414C
	ld de, $D040
	ld a, $04
	jr SoundDrv_SetTrackIterator

SoundDrv_SelectMusicTracks:: ; 04:4153
	ld de, $D130
	ld a, $04
	jr SoundDrv_SetTrackIterator

; ---- code $415A-$415F (5 bytes) [HYPOTHESIS] sibling of the executed entries 414C/4153 (ld de,imm ; ld a,imm ; shared tail 415F): decodes to ld de,$D040 ; ld a,$08 and lands exactly on the executed tail 415F; no caller or table entry found anywhere in the ROM, so entry unproven

Function_04_415A:: ; 04:415A
	ld de, $D040
	ld a, $08

; ---- code $415F-$41CF (112 bytes) [CONFIRMED] 67 insn(s); 67 executed (in up to 18/18 scenarios)

SoundDrv_SetTrackIterator:: ; 04:415F
	ld hl, $D00F
	ld [hli], a
	ld a, e
	ld [hli], a
	ld [hl], d
	ret

SoundDrv_NextTrack:: ; 04:4167
	ld hl, $D00F
	dec [hl]
	ret z
	inc hl
	ld a, $3C
	add a, [hl]
	ld [hli], a
	ld a, $00
	adc a, [hl]
	ld [hl], a
	rra
	ret

SoundDrv_SelectChannel1:: ; 04:4177
	ld de, $D220
	ld a, $01
	ld c, $12
	jr SoundDrv_SetChannelIterator

SoundDrv_SelectChannel2:: ; 04:4180
	ld de, $D238
	ld a, $01
	ld c, $17
	jr SoundDrv_SetChannelIterator

SoundDrv_SelectChannel3:: ; 04:4189
	ld de, $D250
	ld a, $01
	ld c, $1C
	jr SoundDrv_SetChannelIterator

SoundDrv_SelectChannel4:: ; 04:4192
	ld de, $D268
	ld a, $01
	ld c, $21
	jr SoundDrv_SetChannelIterator

SoundDrv_SelectAllChannels:: ; 04:419B
	ld de, $D220
	ld a, $04
	ld c, $12

SoundDrv_SetChannelIterator:: ; 04:41A2
	ld hl, $D012
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hl], c
	ret

SoundDrv_NextChannel:: ; 04:41AC
	ld hl, $D012
	dec [hl]
	ret z
	inc hl
	ld a, $18
	add a, [hl]
	ld [hli], a
	ld a, $00
	adc a, [hl]
	ld [hli], a
	ld a, [hl]
	add a, $05
	ld [hl], a
	rra
	ret

SoundDrv_PlaySfx:: ; 04:41C0
	ld a, b
	or a, c
	jp z, SoundDrv_StopAllSfx
	call SoundDrv_LoadSongHeader
	ld a, [wSoundDrv_HeaderFlags]
	bit 7, a
	jr nz, SoundDrv_PlaySfxAllTracks

; ---- code $41CF-$4219 (74 bytes) [PROBABLE] 37 insn(s) reached by static flow only; seeds: exec x37; min discovery hops 0; fall-through of the jrcc at 04:41CD (executed)
	ld b, a
	sub a, $04
	jr nc, Label_04_4216
	cpl
	inc a
	ld [wRam_D00F], a
	ld hl, $D040
	ld a, b
	and a, a
	jr z, Label_04_41E7
	ld de, $003C

Label_04_41E3:: ; 04:41E3
	add hl, de
	dec b
	jr nz, Label_04_41E3

Label_04_41E7:: ; 04:41E7
	ld a, l
	ld [wRam_D010], a
	ld a, h
	ld [wRam_D011], a
	jr Label_04_41F9

Label_04_41F1:: ; 04:41F1
	ld a, [wRam_D010]
	ld l, a
	ld a, [wRam_D011]
	ld h, a

Label_04_41F9:: ; 04:41F9
	bit 7, [hl]
	jr z, Label_04_420C
	ld bc, $0008
	add hl, bc
	ld a, [wRam_D03E]
	cp a, [hl]
	jr nc, Label_04_420C
	call SoundDrv_NextHeaderTrack
	jr Label_04_420F

Label_04_420C:: ; 04:420C
	call SoundDrv_StartTrack

Label_04_420F:: ; 04:420F
	jr z, Label_04_4216
	call SoundDrv_NextTrack
	jr nz, Label_04_41F1

Label_04_4216:: ; 04:4216
	jp Function_00_2141

; ---- code $4219-$424E (53 bytes) [CONFIRMED] 23 insn(s); 23 executed (in up to 17/18 scenarios)

SoundDrv_PlaySfxAllTracks:: ; 04:4219
	call SoundDrv_SelectSfxTracks
	ld a, $01
	ld [wSoundDrv_ReqDE + 1], a
	xor a, a
	ld [wSoundDrv_ReqDE], a

Label_04_4225:: ; 04:4225
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	bit 7, [hl]
	jr nz, Label_04_4241
	call SoundDrv_StartTrack
	jr z, Label_04_4284
	ld a, [wSoundDrv_ReqDE + 1]
	ld b, a
	ld a, [wSoundDrv_ReqDE]
	or a, b
	ld [wSoundDrv_ReqDE], a

Label_04_4241:: ; 04:4241
	ld a, [wSoundDrv_ReqDE + 1]
	sla a
	ld [wSoundDrv_ReqDE + 1], a
	call SoundDrv_NextTrack
	jr nz, Label_04_4225

; ---- code $424E-$4284 (54 bytes) [CONFIRMED] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 0; fall-through of the jrcc at 04:424C (executed) [executed in 6 scenarios]
	call SoundDrv_SelectSfxTracks
	ld a, $01
	ld [wSoundDrv_ReqDE + 1], a

Label_04_4256:: ; 04:4256
	ld a, [wSoundDrv_ReqDE + 1]
	ld b, a
	ld a, [wSoundDrv_ReqDE]
	and a, b
	jr nz, Label_04_4277
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld bc, $0008
	add hl, bc
	ld a, [wSoundDrv_HeaderPriority]
	cp a, [hl]
	jr c, Label_04_4277
	call SoundDrv_StartTrack
	jr z, Label_04_4284

Label_04_4277:: ; 04:4277
	ld a, [wSoundDrv_ReqDE + 1]
	sla a
	ld [wSoundDrv_ReqDE + 1], a
	call SoundDrv_NextTrack
	jr nz, Label_04_4256

; ---- code $4284-$42AC (40 bytes) [CONFIRMED] 18 insn(s); 18 executed (in up to 18/18 scenarios)

Label_04_4284:: ; 04:4284
	jp Function_00_2141

SoundDrv_PlayMusic:: ; 04:4287
	ld a, b
	or a, c
	jp z, SoundDrv_PauseMusic
	ld a, c
	ld [wSoundDrv_MusicId], a
	ld a, b
	ld [wSoundDrv_MusicId + 1], a
	xor a, a
	ld [wSoundDrv_FadeSpeed], a
	xor a, a
	ld [wSoundDrv_MusicPaused], a
	call SoundDrv_LoadSongHeader
	call SoundDrv_SelectMusicTracks

Label_04_42A2:: ; 04:42A2
	call SoundDrv_StartTrack
	jr z, Label_04_42B8
	call SoundDrv_NextTrack
	jr nz, Label_04_42A2

; ---- code $42AC-$42AE (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 04:42AA (executed)
	jr Label_04_42BD

; ---- code $42AE-$42C0 (18 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 18/18 scenarios)

Label_04_42AE:: ; 04:42AE
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	xor a, a
	ld [hl], a

Label_04_42B8:: ; 04:42B8
	call SoundDrv_NextTrack
	jr nz, Label_04_42AE

Label_04_42BD:: ; 04:42BD
	jp Function_00_2141

; ---- code $42C0-$42D6 (22 bytes) [PROBABLE] entry: ROM0 stub 00:20B8 (call 2116 ; jp 04:42C0). Adversarial check: no `call`/`jp` to $20B8 exists anywhere in the ROM (the '14 raw refs' of the ROM0 stub note are bare word occurrences of B8 20, none preceded by a call/jp opcode), so the stub itself has no known caller; the entry rests on the ROM0 stub of the same shape as the executed stub 20C4 plus exact tiling between CONFIRMED code (42AE-42C0 and 42D6-42EC); clean decode to a terminator, no illegal opcodes, targets inside the bank

SoundDrv_PlayMusicIfNotPlaying:: ; 04:42C0
	ld a, [wRam_D01B]
	cp a, c
	jr nz, SoundDrv_PlayMusic
	ld a, [wRam_D01C]
	cp a, b
	jr nz, SoundDrv_PlayMusic
	ld a, [wRam_D024]
	and a, $F0
	jr z, SoundDrv_PlayMusic
	jp Function_00_2141

; ---- code $42D6-$42EC (22 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 18/18 scenarios)

SoundDrv_PlayMusicOrResume:: ; 04:42D6
	ld a, [wSoundDrv_MusicId]
	cp a, c
	jr nz, SoundDrv_PlayMusic
	ld a, [wSoundDrv_MusicId + 1]
	cp a, b
	jr nz, SoundDrv_PlayMusic
	ld a, [wSoundDrv_ActiveMask]
	and a, $F0
	jr z, SoundDrv_ResumeMusic
	jp Function_00_2141

; ---- code $42EC-$430A (30 bytes) [PROBABLE] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 1; entered by jrcc from 04:42E7 (executed)

SoundDrv_ResumeMusic:: ; 04:42EC
	xor a, a
	ld [wRam_D025], a
	call SoundDrv_SelectMusicTracks

Label_04_42F3:: ; 04:42F3
	ld a, [wRam_D010]
	ld l, a
	ld a, [wRam_D011]
	ld h, a
	ld a, [hl]
	and a, $60
	jr z, Label_04_4302
	set 7, [hl]

Label_04_4302:: ; 04:4302
	call SoundDrv_NextTrack
	jr nz, Label_04_42F3
	jp Function_00_2141

; ---- code $430A-$4313 (9 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 18/18 scenarios); entry proven: target of an executed call/far call

SoundDrv_LoadSongHeader:: ; 04:430A
Function_04_430A::
	ld a, b
	ld [wSoundDrv_ReqBC + 1], a
	cp a, $00
	ld a, c
	jr z, Label_04_4319

; ---- code $4313-$4319 (6 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 04:4311 (executed) | forced execution: 3/3 instruction starts ran in forced_debug (traces/forced/, not natural evidence; status unchanged)
	jr c, Label_04_431D

Label_04_4315:: ; 04:4315
	pop hl
	jp Function_00_2141

; ---- code $4319-$43DC (195 bytes) [CONFIRMED] 135 insn(s); 135 executed (in up to 18/18 scenarios)

Label_04_4319:: ; 04:4319
	cp a, $47
	jr nc, Label_04_4315

Label_04_431D:: ; 04:431D
	ld [wSoundDrv_ReqBC], a
	ld l, c
	ld h, b
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, $5515
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld [wBank4ReadBank], a
	ld a, [hli]
	ld [wBank4ReadBank + 1], a
	ld a, [hli]
	ld [wSoundDrv_HeaderPriority], a
	ld a, [hli]
	ld [wSoundDrv_HeaderFlags], a
	ld a, [hl]
	ld [wSoundDrv_HeaderTrackCount], a
	inc de
	inc de
	ld a, e
	ld [wSoundDrv_HeaderPtr], a
	ld a, d
	ld [wSoundDrv_HeaderPtr + 1], a
	ret

SoundDrv_StartTrack:: ; 04:434C
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld a, $A0
	ld [hli], a
	inc hl
	ld a, [wSoundDrv_HeaderPtr]
	ld [hli], a
	ld a, [wSoundDrv_HeaderPtr + 1]
	ld [hli], a
	ld a, [wBank4ReadBank]
	ld [hli], a
	ld a, [wBank4ReadBank + 1]
	ld [hli], a
	ld a, [wSoundDrv_ReqBC]
	ld [hli], a
	ld a, [wSoundDrv_ReqBC + 1]
	ld [hli], a
	ld a, [wSoundDrv_HeaderPriority]
	ld [hli], a

SoundDrv_NextHeaderTrack:: ; 04:4374
	ld hl, $D03C
	dec [hl]
	ret z
	ld hl, $D017
	ld a, $02
	add a, [hl]
	ld [hli], a
	ld a, $00
	adc a, [hl]
	ld [hl], a
	rra
	ret

SoundDrv_InitTrackRuntime:: ; 04:4386
	ld a, $C0
	ld [hli], a
	xor a, a
	ld [hli], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld [wBank4ReadBank], a
	ld a, [hld]
	ld [wBank4ReadBank + 1], a
	dec hl
	call Function_00_216F
	ld a, b
	ld [hld], a
	ld [hl], c
	ld bc, $0007
	add hl, bc
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, $FF
	ld [hli], a
	ld [hli], a
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, $FF
	ld [hli], a
	ld a, $40
	ld [hli], a
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, $02
	ld [hli], a
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, $17
	ld [hli], a
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, $FF
	ld [hli], a
	ret

; ---- code $43DC-$4429 (77 bytes) [PROBABLE] 39 insn(s) reached by static flow only; seeds: exec x10, site x29; min discovery hops 1; entered by jp from 00:20C1 (PROBABLE code) | forced execution: 13/39 instruction starts ran in forced_debug (traces/forced/, not natural evidence; status unchanged)

SoundDrv_StopSfxById:: ; 04:43DC
	ld a, b
	or a, c
	jp z, SoundDrv_StopAllSfx
	ld a, c
	ld [wRam_D038], a
	ld a, b
	ld [wRam_D039], a
	call SoundDrv_SelectSfxTracks

Label_04_43EC:: ; 04:43EC
	ld a, [wRam_D010]
	ld c, a
	ld a, [wRam_D011]
	ld b, a
	ld a, [bc]
	bit 7, a
	jr z, Label_04_440C
	ld hl, $0006
	add hl, bc
	ld a, [wRam_D038]
	cp a, [hl]
	jr nz, Label_04_440C
	inc hl
	ld a, [wRam_D039]
	cp a, [hl]
	jr nz, Label_04_440C
	xor a, a
	ld [bc], a

Label_04_440C:: ; 04:440C
	call SoundDrv_NextTrack
	jr nz, Label_04_43EC
	jp Function_00_2141

SoundDrv_StopAllSfx:: ; 04:4414
	call SoundDrv_SelectSfxTracks

Label_04_4417:: ; 04:4417
	ld a, [wRam_D010]
	ld l, a
	ld a, [wRam_D011]
	ld h, a
	xor a, a
	ld [hl], a
	call SoundDrv_NextTrack
	jr nz, Label_04_4417
	jp Function_00_2141

; ---- code $4429-$442F (6 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 18/18 scenarios)

SoundDrv_PauseMusic:: ; 04:4429
	call SoundDrv_PauseMusicCore
	jp Function_00_2141

; ---- code $442F-$4433 (4 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1; entered by jpcc from 04:454D (PROBABLE code)

SoundDrv_FadeFinished:: ; 04:442F
	xor a, a
	ld [wSoundDrv_FadeSpeed], a

; ---- code $4433-$444B (24 bytes) [CONFIRMED] 11 insn(s); 11 executed (in up to 18/18 scenarios); entry proven: target of an executed call/far call

SoundDrv_PauseMusicCore:: ; 04:4433
Function_04_4433::
	ld a, $FF
	ld [wSoundDrv_MusicPaused], a
	call SoundDrv_SelectMusicTracks

Label_04_443B:: ; 04:443B
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	res 7, [hl]
	call SoundDrv_NextTrack
	jr nz, Label_04_443B
	ret

; ---- code $444B-$445C (17 bytes) [PROBABLE] entry: ROM0 stub 00:20D0 (call 2116 ; jp 04:444B; no call/jp to $20D0 found in the ROM, stub has no known caller); reads [D024] nibbles into D/E, jp 2141 (bank-04 routine exit)

SoundDrv_GetActiveMasks:: ; 04:444B
	ld a, [wRam_D024]
	and a, $0F
	ld d, a
	ld a, [wRam_D024]
	and a, $F0
	swap a
	ld e, a
	jp Function_00_2141

; ---- code $445C-$449B (63 bytes) [PROBABLE] entry: ROM0 stub 00:20E2 (call 2116 ; jp 04:445C; no call/jp to $20E2 found in the ROM, stub has no known caller); indexes the WRAM record table at 449B with [bc]=4499+2a, ends with jp 2141

SoundDrv_GetPlayingId:: ; 04:445C
	and a, a
	jr nz, Label_04_4470
	ld a, [wRam_D024]
	and a, $F0
	jr z, Label_04_4474
	ld a, [wRam_D01B]
	ld c, a
	ld a, [wRam_D01C]
	ld b, a
	jr Label_04_4498

Label_04_4470:: ; 04:4470
	cp a, $05
	jr c, Label_04_4479

Label_04_4474:: ; 04:4474
	ld bc, $0000
	jr Label_04_4498

Label_04_4479:: ; 04:4479
	ld bc, $4499
	sla a
	add a, c
	ld c, a
	ld a, $00
	adc a, b
	ld b, a
	ld a, [bc]
	ld l, a
	inc bc
	ld a, [bc]
	ld h, a
	ld bc, $0000
	bit 7, [hl]
	jr z, Label_04_4498
	ld bc, $0006
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a

Label_04_4498:: ; 04:4498
	jp Function_00_2141

; ---- words $449B-$44A3 (8 bytes) [PROBABLE] 4 WRAM record addresses D040,D07C,D0B8,D0F4 (stride $3C = the 8 x $3C-byte records cleared at D040 by 04:4000); read by the code at 4479 (ld bc,$4499 ; sla a ; add a,c ; ld a,[bc]) with index 1-4 (index 0 would be the operand of the jp $2141 at 4498)

Table_SoundDrv_SfxTrackPtrs:: ; 04:449B
Data_04_449B::
	dw $D040, $D07C, $D0B8, $D0F4

; ---- ptrtable $44A3-$44B1 (14 bytes) [PROBABLE] 7 code pointers (4819 4840 4947 4962 4991 4908 49CD), base loaded by ld bc,$44A3 at 04:44C9 then jp 45CD (jump-table dispatcher: sla a ; add a,c ; ... ; jp hl); all 7 targets decode cleanly

Table_SoundDrv_ParamHandlers:: ; 04:44A3
Table_04_44A3::
	dw SoundDrv_ParamTempoScale
	dw Label_04_4840
	dw SoundDrv_ParamVolumeScale
	dw Label_04_4962
	dw Label_04_4991
	dw Label_04_4908
	dw Label_04_49CD

; ---- code $44B1-$44B7 (6 bytes) [PROBABLE] entry: ROM0 stub 00:20D6 (call 2116 ; jp 04:44B1; no call/jp to $20D6 found in the ROM, stub has no known caller): call 44B7 ; jp 2141

SoundDrv_SetTrackParam:: ; 04:44B1
	call SoundDrv_SetTrackParamCore
	jp Function_00_2141

; ---- code $44B7-$44CF (24 bytes) [PROBABLE] 17 insn(s) reached by static flow only; seeds: exec x17; min discovery hops 1; entered by jp from 04:4557 (PROBABLE code)

SoundDrv_SetTrackParamCore:: ; 04:44B7
	cp a, $07
	ret nc
	push af
	ld hl, $D038
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	xor a, a
	ld [hl], a
	pop af
	ld bc, Table_SoundDrv_ParamHandlers
	jp SoundDrv_JumpTable

; ---- code $44CF-$453A (107 bytes) [PROBABLE] target of 4 jp $44CF at 04:4912/496D/4952/4994 (code entered through jump-table entries) and contains the entry 452C of ROM0 stub 00:20DC (no call/jp to $20DC found in the ROM); clean decode, ends with jp 2141

SoundDrv_SetTrackFieldByte:: ; 04:44CF
	call SoundDrv_BuildTrackMask

Label_04_44D2:: ; 04:44D2
	rrc d
	jr nc, Label_04_44E6
	bit 7, [hl]
	jr z, Label_04_44E6
	ld a, [wRam_D03C]
	or a, [hl]
	ld [hl], a
	push hl
	add hl, bc
	ld a, [wRam_D039]
	ld [hl], a
	pop hl

Label_04_44E6:: ; 04:44E6
	call SoundDrv_NextTrackRecord
	jr nz, Label_04_44D2
	ret

SoundDrv_SetTrackFieldWord:: ; 04:44EC
	call SoundDrv_BuildTrackMask

Label_04_44EF:: ; 04:44EF
	rrc d
	jr nc, Label_04_4507
	bit 7, [hl]
	jr z, Label_04_4507
	ld a, [wRam_D03C]
	or a, [hl]
	ld [hl], a
	push hl
	add hl, bc
	ld a, [wRam_D038]
	ld [hli], a
	ld a, [wRam_D039]
	ld [hld], a
	pop hl

Label_04_4507:: ; 04:4507
	call SoundDrv_NextTrackRecord
	jr nz, Label_04_44EF
	ret

SoundDrv_BuildTrackMask:: ; 04:450D
	ld a, [wRam_D03B]
	and a, $0F
	ld d, a
	ld a, [wRam_D03A]
	swap a
	and a, $F0
	or a, d
	ld d, a
	ld e, $08
	ld hl, $D040
	ret

SoundDrv_NextTrackRecord:: ; 04:4522
	ld a, $3C
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	dec e
	ret

SoundDrv_StartFadeOut:: ; 04:452C
	ld [wRam_D020], a
	ld [wRam_D021], a
	ld a, $40
	ld [wRam_D022], a
	jp Function_00_2141

; ---- code $453A-$4544 (10 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 18/18 scenarios); entry proven: target of an executed call/far call

SoundDrv_UpdateFade:: ; 04:453A
Function_04_453A::
	ld a, [wSoundDrv_MusicPaused]
	and a, a
	ret nz
	ld a, [wSoundDrv_FadeSpeed]
	and a, a
	ret z

; ---- code $4544-$455A (22 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the retcc at 04:4543 (executed)
	ld hl, $D021
	dec [hl]
	ret nz
	ld [hli], a
	ld a, [hl]
	sub a, $04
	jp c, SoundDrv_FadeFinished
	ld [hl], a
	ld b, a
	ld a, $02
	ld de, $00FF
	jp SoundDrv_SetTrackParamCore

; ---- code $455A-$4621 (199 bytes) [CONFIRMED] 120 insn(s); 120 executed (in up to 18/18 scenarios); entry proven: target of an executed call/far call

SoundDrv_ApplyTrackUpdates:: ; 04:455A
Function_04_455A::
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld a, [hl]
	cp a, $C0
	ret c
	ld [wSoundDrv_UpdateFlags], a
	jp SoundDrv_ComputeTrackOutput

SoundDrv_StepTrack:: ; 04:456C
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld a, [hl]
	bit 7, a
	ret z
	bit 6, a
	jr nz, Label_04_4582
	push hl
	call SoundDrv_InitTrackRuntime
	pop hl
	ld a, [hl]

Label_04_4582:: ; 04:4582
	ld [wSoundDrv_UpdateFlags], a
	inc hl
	ld a, [hl]
	and a, a
	jr z, Label_04_458E
	dec [hl]
	inc hl
	jr Label_04_45E6

Label_04_458E:: ; 04:458E
	inc hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld [wBank4ReadBank], a
	ld a, [hl]
	ld [wBank4ReadBank + 1], a

SoundDrv_ReadNextCommand:: ; 04:459B
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld bc, $0011
	add hl, bc
	call Function_00_216F
	bit 7, c
	jr nz, Label_04_45B6
	ld a, c
	ld [wSoundDrv_StreamByte], a
	dec de
	ld a, [hl]
	jr Label_04_45C0

Label_04_45B6:: ; 04:45B6
	ld a, b
	ld [wSoundDrv_StreamByte], a
	ld a, c
	cp a, $BE
	jr c, Label_04_45C0
	ld [hl], a

Label_04_45C0:: ; 04:45C0
	cp a, $D0
	jp nc, SoundDrv_CmdNote
	sub a, $B1
	jp c, SoundDrv_CmdRest
	ld bc, Table_SoundDrv_Commands

SoundDrv_JumpTable:: ; 04:45CD
	sla a
	add a, c
	ld c, a
	ld a, $00
	adc a, b
	ld b, a
	ld a, [bc]
	ld l, a
	inc bc
	ld a, [bc]
	ld h, a
	jp hl

SoundDrv_CmdEnd:: ; 04:45DB
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	xor a, a
	ld [hli], a
	ret

Label_04_45E6:: ; 04:45E6
	ld bc, $0029
	add hl, bc
	ld a, [hl]
	and a, a
	jr z, Label_04_45F7
	dec [hl]
	ld bc, $FFF5
	add hl, bc
	ld a, $40
	jr Label_04_45FD

Label_04_45F7:: ; 04:45F7
	ld bc, $FFF4
	add hl, bc
	ld a, [hli]
	add a, [hl]

Label_04_45FD:: ; 04:45FD
	ld [hl], a
	sla a
	jr nc, Label_04_4603
	cpl

Label_04_4603:: ; 04:4603
	ld [wRam_D01E], a
	ld bc, $0001
	add hl, bc
	ld a, [hli]
	add a, [hl]
	jr z, Label_04_4623
	ld c, a
	ld a, [wRam_D01E]
	ld b, a
	push hl
	push bc
	call SoundDrv_Mul8x8
	pop bc
	ld b, h
	pop hl
	inc hl
	ld a, [hli]
	cp a, $00
	jr z, Label_04_462E

; ---- code $4621-$4623 (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 04:461F (executed)
	jr Label_04_465D

; ---- code $4623-$462C (9 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 17/18 scenarios)

Label_04_4623:: ; 04:4623
	ld bc, $0000
	inc hl
	ld a, [hli]
	cp a, $00
	jr z, Label_04_4640

; ---- code $462C-$462E (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 04:462A (executed)
	jr Label_04_465D

; ---- code $462E-$46AC (126 bytes) [CONFIRMED] 80 insn(s); 80 executed (in up to 17/18 scenarios)

Label_04_462E:: ; 04:462E
	ld a, b
	srl c
	sub a, c
	ld c, a
	ld a, $00
	sbc a, a
	sla c
	rla
	sla c
	rla
	sla c
	rla
	ld b, a

Label_04_4640:: ; 04:4640
	ld a, c
	cp a, [hl]
	jr z, Label_04_464D
	ld a, [wSoundDrv_UpdateFlags]
	set 2, a
	ld [wSoundDrv_UpdateFlags], a
	ld [hl], c

Label_04_464D:: ; 04:464D
	inc hl
	ld a, b
	cp a, [hl]
	jr z, Label_04_465B
	ld a, [wSoundDrv_UpdateFlags]
	set 2, a
	ld [wSoundDrv_UpdateFlags], a
	ld [hl], b

Label_04_465B:: ; 04:465B
	jr Label_04_465D

Label_04_465D:: ; 04:465D
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld a, [wSoundDrv_UpdateFlags]

SoundDrv_ComputeTrackOutput:: ; 04:4668
	bit 2, a
	jr z, Label_04_46A8
	ld bc, $001D
	add hl, bc
	ld e, [hl]
	ld a, $00
	sla e
	sbc a, a
	ld d, a
	ld bc, $FFFE
	add hl, bc
	ld a, [hli]
	add a, e
	ld e, a
	ld a, [hld]
	adc a, d
	ld d, a
	ld bc, $FFF8
	add hl, bc
	ld a, [hli]
	add a, e
	ld e, a
	ld a, [hld]
	adc a, d
	ld d, a
	ld bc, $0010
	add hl, bc
	ld a, [hli]
	cp a, $00
	jr nz, Label_04_469A
	ld a, [hli]
	add a, e
	ld e, a
	ld a, [hld]
	adc a, d
	ld d, a

Label_04_469A:: ; 04:469A
	ld bc, $0008
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d
	ld bc, $FFD3
	add hl, bc
	ld a, [wSoundDrv_UpdateFlags]

Label_04_46A8:: ; 04:46A8
	bit 0, a
	jr z, Label_04_46BF

; ---- code $46AC-$46BF (19 bytes) [PROBABLE] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 0; fall-through of the jrcc at 04:46AA (executed)
	ld bc, $0017
	add hl, bc
	ld a, [hli]
	add a, [hl]
	ld e, a
	ld bc, $0016
	add hl, bc
	ld [hl], e
	ld bc, $FFD2
	add hl, bc
	ld a, [wSoundDrv_UpdateFlags]

; ---- code $46BF-$46E8 (41 bytes) [CONFIRMED] 24 insn(s); 24 executed (in up to 17/18 scenarios)

Label_04_46BF:: ; 04:46BF
	bit 1, a
	jr z, Label_04_46E6
	ld bc, $0015
	add hl, bc
	ld a, [hli]
	ld b, a
	ld c, [hl]
	call SoundDrv_MulNibbles
	add a, $0F
	and a, $F0
	cp a, $40
	jr c, Label_04_46D7
	ld a, $FF

Label_04_46D7:: ; 04:46D7
	rlca
	rlca
	ld e, a
	ld bc, $0019
	add hl, bc
	ld [hl], e
	ld bc, $FFD1
	add hl, bc
	ld a, [wSoundDrv_UpdateFlags]

Label_04_46E6:: ; 04:46E6
	ld [hl], a
	ret

; ---- ptrtable $46E8-$4726 (62 bytes) [PROBABLE] 31 code pointers (jump table of the dispatcher 04:45CD, base ld bc,$46E8 at 04:45CA; executed reads cover 46E8-46F0 and 4708-4712); every word is a code entry that decodes cleanly (45DB 479B 4777 47A3 47C5 4A24 45DB 47E3 483A 484E 492A 4955 4896 48D5 48EC 4925 4970 4984 4997 49B6 ...); merged from mapper pieces 46E8/46F0/46F8/4706/4708/4712/4722

Table_SoundDrv_Commands:: ; 04:46E8
Table_04_46E8::
	dw SoundDrv_CmdEnd
	dw SoundDrv_CmdJump
	dw SoundDrv_CmdCall
	dw SoundDrv_CmdReturn
	dw SoundDrv_CmdRepeat
	dw Label_04_4A24
	dw Label_04_4A24
	dw Label_04_4A24
	dw SoundDrv_CmdEnd
	dw SoundDrv_CmdEnd
	dw SoundDrv_CmdEnd
	dw SoundDrv_CmdSetTempo
	dw Label_04_483A
	dw SoundDrv_CmdSetInstrument
	dw SoundDrv_CmdSetVolume
	dw Label_04_4955
	dw Label_04_4896
	dw Label_04_48D5
	dw Label_04_48EC
	dw Label_04_4925
	dw Label_04_4970
	dw Label_04_4984
	dw Label_04_4A24
	dw Label_04_4A24
	dw Label_04_4997
	dw Label_04_49B6
	dw Label_04_4A24
	dw SoundDrv_CmdEnd
	dw SoundDrv_CmdExtended
	dw Label_04_4A27
	dw Label_04_4B66

; ---- ptrtable $4726-$473E (24 bytes) [PROBABLE] 12 code pointers, base ld bc,$4726 at 04:4750 then jp 45CD; ends at the code region 473E; targets 45DB 49D3 49E2 49FF 4A1A 4A1F 49C3 49C8 4A24 4A24 49D8 49DD all decode cleanly

Table_SoundDrv_ExtCommands:: ; 04:4726
Table_04_4726::
	dw SoundDrv_CmdEnd
	dw Label_04_49D3
	dw Label_04_49E2
	dw Label_04_49FF
	dw Label_04_4A1A
	dw Label_04_4A1F
	dw Label_04_49C3
	dw Label_04_49C8
	dw Label_04_4A24
	dw Label_04_4A24
	dw Label_04_49D8
	dw Label_04_49DD

; ---- code $473E-$4756 (24 bytes) [PROBABLE] 11 insn(s) reached by static flow only; seeds: table x11; min discovery hops 0; run starts at an entry of the code-pointer table at 04:46E8

SoundDrv_CmdExtended:: ; 04:473E
	ld a, [wSoundDrv_StreamByte]
	inc de
	cp a, $0C
	jp nc, SoundDrv_CmdEnd
	ld b, a
	call Function_00_215E
	ld a, c
	ld [wSoundDrv_StreamByte], a
	ld a, b
	ld bc, Table_SoundDrv_ExtCommands
	jp SoundDrv_JumpTable

; ---- code $4756-$47C5 (111 bytes) [CONFIRMED] 70 insn(s); 70 executed (in up to 17/18 scenarios)

SoundDrv_CmdRest:: ; 04:4756
	add a, $31
	jp z, SoundDrv_ReadNextCommand
	add a, $44
	ld l, a
	ld a, $00
	adc a, $50
	ld h, a
	ld b, [hl]
	dec b
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	inc hl
	ld a, b
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hld], a
	jp Label_04_45E6

SoundDrv_CmdCall:: ; 04:4777
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld bc, $0026
	add hl, bc
	ld a, [hl]
	cp a, $0A
	jp nc, SoundDrv_CmdEnd
	inc a
	inc a
	ld [hl], a
	ld c, a
	ld b, $00
	add hl, bc
	ld bc, $000A
	add hl, bc
	inc de
	inc de
	ld a, e
	ld [hli], a
	ld [hl], d
	dec de
	dec de

SoundDrv_CmdJump:: ; 04:479B
	call Function_00_216F
	ld e, c
	ld d, b
	jp SoundDrv_ReadNextCommand

SoundDrv_CmdReturn:: ; 04:47A3
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld bc, $0026
	add hl, bc
	ld a, [hl]
	and a, a
	jp z, SoundDrv_ReadNextCommand
	dec a
	dec a
	ld [hl], a
	ld c, a
	ld b, $00
	add hl, bc
	ld bc, $000C
	add hl, bc
	ld a, [hli]
	ld e, a
	ld d, [hl]
	jp SoundDrv_ReadNextCommand

; ---- code $47C5-$47E3 (30 bytes) [PROBABLE] 18 insn(s) reached by static flow only; seeds: table x18; min discovery hops 0; run starts at an entry of the code-pointer table at 04:46E8

SoundDrv_CmdRepeat:: ; 04:47C5
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld bc, $0029
	add hl, bc
	ld a, [wSoundDrv_StreamByte]
	inc de
	and a, a
	jr z, SoundDrv_CmdJump
	inc [hl]
	cp a, [hl]
	jr nz, SoundDrv_CmdJump
	xor a, a
	ld [hl], a
	inc de
	inc de
	jp SoundDrv_ReadNextCommand

; ---- code $47E3-$4808 (37 bytes) [CONFIRMED] 19 insn(s); 19 executed (in up to 18/18 scenarios)

SoundDrv_CmdSetTempo:: ; 04:47E3
	ld hl, $D000
	bit 5, [hl]
	ld hl, $D00A
	jr z, Label_04_47F0
	ld hl, $D005

Label_04_47F0:: ; 04:47F0
	ld a, [wSoundDrv_StreamByte]
	inc de
	ld [hl], a
	call SoundDrv_UpdateTempoStep
	jp SoundDrv_ReadNextCommand

SoundDrv_UpdateTempoStep:: ; 04:47FB
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	push hl
	call SoundDrv_Mul8x8
	ld a, h
	cp a, $40
	jr c, Label_04_480C

; ---- code $4808-$480C (4 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 04:4806 (executed)
	ld a, $3F
	ld l, $FF

; ---- code $480C-$4815 (9 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 18/18 scenarios)

Label_04_480C:: ; 04:480C
	sla l
	rla
	sla l
	rla
	and a, a
	jr nz, Label_04_4816

; ---- code $4815-$4816 (1 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 04:4813 (executed)
	inc a

; ---- code $4816-$4819 (3 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 18/18 scenarios)

Label_04_4816:: ; 04:4816
	pop hl
	ld [hl], a
	ret

; ---- code $4819-$483A (33 bytes) [PROBABLE] validated entry 4819 of jump table Table_04_44A3 (index 0); clean decode to a terminator

SoundDrv_ParamTempoScale:: ; 04:4819
	ld a, [wRam_D03B]
	and a, a
	jr z, Label_04_4829
	ld hl, $D006
	ld a, [wRam_D039]
	ld [hld], a
	call SoundDrv_UpdateTempoStep

Label_04_4829:: ; 04:4829
	ld a, [wRam_D03A]
	and a, a
	jr z, Label_04_4839
	ld hl, $D00B
	ld a, [wRam_D039]
	ld [hld], a
	call SoundDrv_UpdateTempoStep

Label_04_4839:: ; 04:4839
	ret

; ---- code $483A-$4840 (6 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 18/18 scenarios)

Label_04_483A:: ; 04:483A
	ld bc, $0012
	jp Label_04_4973

; ---- code $4840-$484E (14 bytes) [PROBABLE] validated entry 4840 of jump table Table_04_44A3 (index 1); clean decode to a terminator

Label_04_4840:: ; 04:4840
	ld a, [wRam_D03C]
	set 2, a
	ld [wRam_D03C], a
	ld bc, $0013
	jp SoundDrv_SetTrackFieldWord

; ---- code $484E-$4901 (179 bytes) [CONFIRMED] 108 insn(s); 108 executed (in up to 18/18 scenarios)

SoundDrv_CmdSetInstrument:: ; 04:484E
	ld a, [wSoundDrv_StreamByte]
	inc de
	cp a, $64
	jr z, Label_04_487E
	call SoundDrv_GetInstrumentPtr
	ld a, [wSoundDrv_TrackPtr]
	add a, $0C
	ld c, a
	ld a, [wSoundDrv_TrackPtr + 1]
	adc a, $00
	ld b, a
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [bc], a
	ld a, [wSoundDrv_UpdateFlags]
	res 4, a
	ld [wSoundDrv_UpdateFlags], a
	jp SoundDrv_ReadNextCommand

Label_04_487E:: ; 04:487E
	ld a, [wSoundDrv_UpdateFlags]
	set 4, a
	ld [wSoundDrv_UpdateFlags], a
	jp SoundDrv_ReadNextCommand

SoundDrv_GetInstrumentPtr:: ; 04:4889
	ld l, a
	ld h, $00
	add hl, hl
	ld c, l
	ld b, h
	add hl, hl
	add hl, bc
	ld bc, $51DD
	add hl, bc
	ret

Label_04_4896:: ; 04:4896
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld bc, $0019
	add hl, bc
	ld a, [wSoundDrv_StreamByte]
	inc de
	rlca
	sub a, $80
	ld [hli], a
	ld b, a
	ld a, [hli]
	ld c, a

Label_04_48AD:: ; 04:48AD
	push hl
	sla b
	jr c, Label_04_48B9
	call SoundDrv_Mul8x8
	ld c, l
	ld b, h
	jr Label_04_48C6

Label_04_48B9:: ; 04:48B9
	ld a, b
	cpl
	ld b, a
	call SoundDrv_Mul8x8
	dec hl
	ld a, l
	cpl
	ld c, a
	ld a, h
	cpl
	ld b, a

Label_04_48C6:: ; 04:48C6
	pop hl
	ld a, c
	ld [hli], a
	ld [hl], b
	ld a, [wSoundDrv_UpdateFlags]
	set 2, a
	ld [wSoundDrv_UpdateFlags], a
	jp SoundDrv_ReadNextCommand

Label_04_48D5:: ; 04:48D5
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld bc, $001A
	add hl, bc
	ld a, [wSoundDrv_StreamByte]
	inc de
	ld [hld], a
	ld c, a
	ld a, [hli]
	ld b, a
	inc hl
	jr Label_04_48AD

Label_04_48EC:: ; 04:48EC
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld bc, $001F
	add hl, bc
	ld a, [wSoundDrv_StreamByte]
	inc de
	ld [hli], a
	sla a
	jr nz, Label_04_4905

; ---- code $4901-$4905 (4 bytes) [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 04:48FF (executed)
	ccf
	rra
	rra
	ld [hl], a

; ---- code $4905-$4908 (3 bytes) [CONFIRMED] 1 insn(s); 1 executed (in up to 17/18 scenarios)

Label_04_4905:: ; 04:4905
	jp SoundDrv_ReadNextCommand

; ---- code $4908-$4925 (29 bytes) [PROBABLE] validated entry 4908 of jump table Table_04_44A3; clean decode to a terminator

Label_04_4908:: ; 04:4908
	ld a, [wRam_D039]
	sla a
	jr z, Label_04_4915
	ld bc, $001F
	jp SoundDrv_SetTrackFieldByte

Label_04_4915:: ; 04:4915
	rra
	ld [wRam_D038], a
	rra
	xor a, $40
	ld [wRam_D039], a
	ld bc, $001F
	jp SoundDrv_SetTrackFieldWord

; ---- code $4925-$4947 (34 bytes) [CONFIRMED] 16 insn(s); 16 executed (in up to 18/18 scenarios)

Label_04_4925:: ; 04:4925
	ld bc, $002A
	jr Label_04_4973

SoundDrv_CmdSetVolume:: ; 04:492A
	ld a, [wSoundDrv_UpdateFlags]
	set 1, a
	ld [wSoundDrv_UpdateFlags], a
	ld bc, $0015
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	add hl, bc
	ld a, [wSoundDrv_StreamByte]
	inc de
	rlca
	ld [hl], a
	jp SoundDrv_ReadNextCommand

; ---- code $4947-$4955 (14 bytes) [PROBABLE] validated entry 4947 of jump table Table_04_44A3; clean decode to a terminator

SoundDrv_ParamVolumeScale:: ; 04:4947
	ld a, [wRam_D03C]
	set 1, a
	ld [wRam_D03C], a
	ld bc, $0016
	jp SoundDrv_SetTrackFieldByte

; ---- code $4955-$4962 (13 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: table x5; min discovery hops 0; run starts at an entry of the code-pointer table at 04:46E8

Label_04_4955:: ; 04:4955
	ld a, [wRam_D019]
	set 0, a
	ld [wRam_D019], a
	ld bc, $0017
	jr Label_04_49A2

; ---- code $4962-$4970 (14 bytes) [PROBABLE] validated entry 4962 of jump table Table_04_44A3; clean decode to a terminator

Label_04_4962:: ; 04:4962
	ld a, [wRam_D03C]
	set 0, a
	ld [wRam_D03C], a
	ld bc, $0018
	jp SoundDrv_SetTrackFieldByte

; ---- code $4970-$4984 (20 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 18/18 scenarios)

Label_04_4970:: ; 04:4970
	ld bc, $0021

Label_04_4973:: ; 04:4973
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	add hl, bc
	ld a, [wSoundDrv_StreamByte]
	inc de
	ld [hl], a
	jp SoundDrv_ReadNextCommand

; ---- code $4984-$4991 (13 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: table x5; min discovery hops 0; run starts at an entry of the code-pointer table at 04:46E8

Label_04_4984:: ; 04:4984
	ld a, [wSoundDrv_UpdateFlags]
	or a, $07
	ld [wSoundDrv_UpdateFlags], a
	ld bc, $0023
	jr Label_04_4973

; ---- code $4991-$4997 (6 bytes) [PROBABLE] validated entry 4991 of jump table Table_04_44A3; clean decode to a terminator

Label_04_4991:: ; 04:4991
	ld bc, $0022
	jp SoundDrv_SetTrackFieldByte

; ---- code $4997-$49C3 (44 bytes) [PROBABLE] 20 insn(s) reached by static flow only; seeds: table x20; min discovery hops 0; run starts at an entry of the code-pointer table at 04:46E8

Label_04_4997:: ; 04:4997
	ld a, [wRam_D019]
	set 2, a
	ld [wRam_D019], a
	ld bc, $001D

Label_04_49A2:: ; 04:49A2
	ld a, [wRam_D010]
	ld l, a
	ld a, [wRam_D011]
	ld h, a
	add hl, bc
	ld a, [wRam_D01F]
	inc de
	rlca
	sub a, $80
	ld [hl], a
	jp SoundDrv_ReadNextCommand

Label_04_49B6:: ; 04:49B6
	ld a, [wSoundDrv_UpdateFlags]
	set 2, a
	ld [wSoundDrv_UpdateFlags], a
	ld bc, $001E
	jr Label_04_4973

; ---- code $49C3-$4A24 (97 bytes) [PROBABLE] entries 49C3/49C8/49CD/49D3/49D8/49DD/49E2/49FF/4A1A/4A1F are words of the jump tables Table_04_44A3 and Table_04_46E8/4726; clean decode to a terminator at 4A24

Label_04_49C3:: ; 04:49C3
	ld bc, $0027
	jr Label_04_4973

Label_04_49C8:: ; 04:49C8
	ld bc, $0028
	jr Label_04_4973

Label_04_49CD:: ; 04:49CD
	ld bc, $0027
	jp SoundDrv_SetTrackFieldWord

Label_04_49D3:: ; 04:49D3
	ld bc, $000C
	jr Label_04_4973

Label_04_49D8:: ; 04:49D8
	ld bc, $000D
	jr Label_04_4973

Label_04_49DD:: ; 04:49DD
	ld bc, $000E
	jr Label_04_4973

Label_04_49E2:: ; 04:49E2
	ld bc, $000F

Label_04_49E5:: ; 04:49E5
	ld a, [wRam_D010]
	ld l, a
	ld a, [wRam_D011]
	ld h, a
	add hl, bc
	ld a, [wRam_D01F]
	inc de
	swap a
	and a, $F0
	ld b, a
	ld a, [hl]
	and a, $0F
	or a, b
	ld [hl], a
	jp SoundDrv_ReadNextCommand

Label_04_49FF:: ; 04:49FF
	ld bc, $000F

Label_04_4A02:: ; 04:4A02
	ld a, [wRam_D010]
	ld l, a
	ld a, [wRam_D011]
	ld h, a
	add hl, bc
	ld a, [wRam_D01F]
	inc de
	and a, $0F
	ld b, a
	ld a, [hl]
	and a, $F0
	or a, b
	ld [hl], a
	jp SoundDrv_ReadNextCommand

Label_04_4A1A:: ; 04:4A1A
	ld bc, $0010
	jr Label_04_49E5

Label_04_4A1F:: ; 04:4A1F
	ld bc, $0010
	jr Label_04_4A02

; ---- code $4A24-$4A27 (3 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: table x1; min discovery hops 0; run starts at an entry of the code-pointer table at 04:46E8

Label_04_4A24:: ; 04:4A24
	jp SoundDrv_CmdEnd

; ---- code $4A27-$4A5C (53 bytes) [CONFIRMED] 29 insn(s); 29 executed (in up to 18/18 scenarios)

Label_04_4A27:: ; 04:4A27
	ld b, $00
	jr Label_04_4A36

SoundDrv_CmdNote:: ; 04:4A2B
	sub a, $CF
	add a, $44
	ld l, a
	ld a, $00
	adc a, $50
	ld h, a
	ld b, [hl]

Label_04_4A36:: ; 04:4A36
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld a, b
	ld bc, $000B
	add hl, bc
	ld [hld], a
	ld b, $00
	ld a, [wSoundDrv_StreamByte]
	jr Label_04_4A50

Label_04_4A4B:: ; 04:4A4B
	inc de
	call Function_00_215E
	ld a, c

Label_04_4A50:: ; 04:4A50
	bit 7, a
	jr nz, SoundDrv_StartNote
	cp a, $24
	jr nc, Label_04_4A69
	cp a, $20
	jr c, Label_04_4A73

; ---- code $4A5C-$4A69 (13 bytes) [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0; fall-through of the jrcc at 04:4A5A (executed)
	bit 5, b
	jr nz, SoundDrv_StartNote
	set 5, b
	sub a, $20
	inc hl
	add a, [hl]
	ld [hld], a
	jr Label_04_4A4B

; ---- code $4A69-$4B66 (253 bytes) [CONFIRMED] 155 insn(s); 155 executed (in up to 18/18 scenarios)

Label_04_4A69:: ; 04:4A69
	bit 7, b
	jr nz, SoundDrv_StartNote
	set 7, b
	dec hl
	ld [hli], a
	jr Label_04_4A4B

Label_04_4A73:: ; 04:4A73
	bit 6, b
	jr nz, SoundDrv_StartNote
	set 6, b
	rlca
	rlca
	rlca
	or a, $07
	ld [hl], a
	jr Label_04_4A4B

SoundDrv_StartNote:: ; 04:4A81
	push de
	dec hl
	ld a, [hl]
	ld bc, $0009
	add hl, bc
	add a, [hl]
	ld [wSoundDrv_ReqDE], a
	ld [wSoundDrv_ReqDE + 1], a
	ld bc, $0018
	add hl, bc
	ld a, [hli]
	ld [hld], a
	ld bc, $FFE2
	add hl, bc
	ld a, [wSoundDrv_UpdateFlags]
	bit 4, a
	jr z, Label_04_4ABE
	push hl
	ld e, l
	ld d, h
	ld a, [wSoundDrv_ReqDE]
	add a, $40
	call SoundDrv_GetInstrumentPtr
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, [hl]
	ld [wSoundDrv_ReqDE + 1], a
	pop hl

Label_04_4ABE:: ; 04:4ABE
	ld a, [hl]
	cp a, $10
	jr nc, Label_04_4AD1
	cp a, $08
	jr nc, Label_04_4ACC
	call SoundDrv_SelectChannel1
	jr Label_04_4ADD

Label_04_4ACC:: ; 04:4ACC
	call SoundDrv_SelectChannel2
	jr Label_04_4ADD

Label_04_4AD1:: ; 04:4AD1
	cp a, $40
	jr nc, Label_04_4ADA
	call SoundDrv_SelectChannel3
	jr Label_04_4ADD

Label_04_4ADA:: ; 04:4ADA
	call SoundDrv_SelectChannel4

Label_04_4ADD:: ; 04:4ADD
	ld a, [wSoundDrv_TrackCount]
	ld hl, $D000
	bit 5, [hl]
	jr z, Label_04_4AE9
	set 7, a

Label_04_4AE9:: ; 04:4AE9
	ld [wSoundDrv_ReqBC + 1], a
	ld e, a
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld bc, $0008
	add hl, bc
	ld a, [hl]
	ld [wSoundDrv_ReqBC], a
	ld d, a
	ld a, [wSoundDrv_ChannelPtr]
	ld l, a
	ld a, [wSoundDrv_ChannelPtr + 1]
	ld h, a
	ld a, [hli]
	and a, a
	jr z, Label_04_4B1A
	bit 5, a
	jr nz, Label_04_4B10
	jr Label_04_4B1A

Label_04_4B10:: ; 04:4B10
	ld a, [hli]
	cp a, d
	jr c, Label_04_4B1A
	jr nz, Label_04_4B62
	ld a, e
	cp a, [hl]
	jr c, Label_04_4B62

Label_04_4B1A:: ; 04:4B1A
	call SoundDrv_SilenceChannel
	ld a, [wSoundDrv_TrackPtr]
	ld e, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld d, a
	ld a, [wSoundDrv_ChannelPtr]
	ld l, a
	ld a, [wSoundDrv_ChannelPtr + 1]
	ld h, a
	ld a, $F0
	ld [hli], a
	ld a, [wSoundDrv_ReqBC]
	ld [hli], a
	ld a, [wSoundDrv_ReqBC + 1]
	ld [hli], a
	ld a, [wSoundDrv_ReqDE]
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, $0A
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	xor a, a
	ld [hli], a
	ld a, [wSoundDrv_ReqDE + 1]
	ld [hl], a

Label_04_4B62:: ; 04:4B62
	pop de
	jp SoundDrv_ReadNextCommand

; ---- code $4B66-$4B79 (19 bytes) [CONFIRMED] 53 insn(s) reached by static flow only; seeds: table x53; min discovery hops 0; run starts at an entry of the code-pointer table at 04:46E8 | 9 insn(s) executed; cut out of the PROBABLE region 4B66-4BC9 by apply_coverage --split [executed in 7 scenarios]

Label_04_4B66:: ; 04:4B66
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld bc, $0009
	add hl, bc
	ld a, [wSoundDrv_StreamByte]
	bit 7, a
	jr nz, Label_04_4B7F

; ---- code $4B79-$4B7F (6 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4B66-4BC9 by apply_coverage --split
	cp a, $24
	jr c, Label_04_4B7F
	inc de
	ld [hl], a

; ---- code $4B7F-$4B96 (23 bytes) [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 4B66-4BC9 by apply_coverage --split [executed in 7 scenarios]

Label_04_4B7F:: ; 04:4B7F
	ld a, [hl]
	ld bc, $0009
	add hl, bc
	add a, [hl]
	ld [wSoundDrv_ReqDE], a
	push de
	call SoundDrv_SelectAllChannels
	ld a, [wSoundDrv_TrackCount]
	ld hl, $D000
	bit 5, [hl]
	jr z, Label_04_4B98

; ---- code $4B96-$4B98 (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4B66-4BC9 by apply_coverage --split
	set 7, a

; ---- code $4B98-$4BC9 (49 bytes) [CONFIRMED] 28 insn(s) executed; cut out of the PROBABLE region 4B66-4BC9 by apply_coverage --split [executed in 7 scenarios]

Label_04_4B98:: ; 04:4B98
	ld e, a
	ld a, [wSoundDrv_ReqDE]
	ld d, a

Label_04_4B9D:: ; 04:4B9D
	ld a, [wSoundDrv_ChannelPtr]
	ld l, a
	ld a, [wSoundDrv_ChannelPtr + 1]
	ld h, a
	ld a, [hli]
	bit 5, a
	jr z, Label_04_4BC0
	inc hl
	ld a, [hli]
	cp a, e
	jr nz, Label_04_4BC0
	ld a, [hl]
	cp a, d
	jr nz, Label_04_4BC0
	ld bc, $0004
	add hl, bc
	ld a, [hl]
	and a, a
	jr nz, Label_04_4BC0
	call SoundDrv_NoteGateExpired
	jr Label_04_4BC5

Label_04_4BC0:: ; 04:4BC0
	call SoundDrv_NextChannel
	jr nz, Label_04_4B9D

Label_04_4BC5:: ; 04:4BC5
	pop de
	jp SoundDrv_ReadNextCommand

; ---- code $4BC9-$4C5C (147 bytes) [CONFIRMED] 90 insn(s); 90 executed (in up to 18/18 scenarios); entry proven: target of an executed call/far call

SoundDrv_ServiceChannelSfx:: ; 04:4BC9
Function_04_4BC9::
	ld a, [wSoundDrv_ChannelPtr]
	ld l, a
	ld a, [wSoundDrv_ChannelPtr + 1]
	ld h, a
	bit 7, [hl]
	ret z
	inc hl
	inc hl
	bit 7, [hl]
	ret z
	jr Label_04_4BEB

SoundDrv_ServiceChannelMusic:: ; 04:4BDB
	ld a, [wSoundDrv_ChannelPtr]
	ld l, a
	ld a, [wSoundDrv_ChannelPtr + 1]
	ld h, a
	bit 7, [hl]
	ret z
	inc hl
	inc hl
	bit 7, [hl]
	ret nz

Label_04_4BEB:: ; 04:4BEB
	inc hl
	inc hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $C0
	jr c, Label_04_4C0B
	inc hl
	ld a, [hl]
	and a, a
	ret z
	dec [hl]
	ret nz

SoundDrv_NoteGateExpired:: ; 04:4BFC
	ld bc, $FFF9
	add hl, bc
	ld a, [hl]
	bit 6, a
	jr nz, Label_04_4C0F
	or a, $50
	and a, $DF
	ld [hl], a
	ret

Label_04_4C0B:: ; 04:4C0B
	ld bc, $FFFA
	add hl, bc

Label_04_4C0F:: ; 04:4C0F
	xor a, a
	ld [hl], a
	jp SoundDrv_SilenceChannel

SoundDrv_UpdateChannel:: ; 04:4C14
	ld a, [wSoundDrv_ChannelPtr]
	ld l, a
	ld a, [wSoundDrv_ChannelPtr + 1]
	ld h, a
	ld a, [hl]
	bit 7, a
	ret z
	ld b, a
	push hl
	ld de, $0004
	add hl, de
	ld a, [hli]
	ld [wSoundDrv_TrackPtr], a
	ld e, a
	ld a, [hli]
	ld [wSoundDrv_TrackPtr + 1], a
	ld d, a
	ld a, [de]
	cp a, $C0
	jr nc, Label_04_4C38
	pop hl
	jr Label_04_4C0F

Label_04_4C38:: ; 04:4C38
	ld [wSoundDrv_UpdateFlags], a
	bit 6, b
	jr nz, Label_04_4C5F
	ld de, $000C
	add hl, de
	ld a, [wSoundDrv_TickDivider]
	and a, a
	jr nz, Label_04_4C4A
	inc [hl]

Label_04_4C4A:: ; 04:4C4A
	inc [hl]
	pop hl
	bit 5, b
	jr z, Label_04_4C57
	bit 4, b
	jr nz, Label_04_4CAE
	jp Label_04_4D02

Label_04_4C57:: ; 04:4C57
	bit 4, b
	jp nz, Label_04_4D3B

; ---- code $4C5C-$4C5F (3 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jpcc at 04:4C59 (executed)
	jp Label_04_4D89

; ---- code $4C5F-$4CD2 (115 bytes) [CONFIRMED] 66 insn(s); 66 executed (in up to 17/18 scenarios)

Label_04_4C5F:: ; 04:4C5F
	pop hl
	res 6, [hl]
	bit 5, [hl]
	jr z, Label_04_4C8F
	push hl
	call SoundDrv_WriteChannelParams
	pop hl
	ld a, [wSoundDrv_UpdateFlags]
	or a, $07
	ld [wSoundDrv_UpdateFlags], a
	call Function_04_4DDF
	ld bc, $000B
	add hl, bc
	ld a, [hl]
	ld bc, $0006
	add hl, bc
	swap a
	cpl
	rrca
	and a, $07
	jr z, Label_04_4CD3
	or a, $08
	ld [hli], a
	xor a, a
	ld [hli], a
	jp Label_04_4DB6

Label_04_4C8F:: ; 04:4C8F
	ld bc, $000C
	add hl, bc
	ld b, [hl]
	ld de, $0005
	add hl, de
	ld a, [hl]
	and a, $F0
	jp z, Label_04_4D54
	ld c, a
	ld a, b
	cpl
	rrca
	and a, $07
	jp z, Label_04_4D54
	or a, c
	ld [hli], a
	xor a, a
	ld [hli], a
	jp Label_04_4DAE

Label_04_4CAE:: ; 04:4CAE
	ld a, [wSoundDrv_UpdateFlags]
	bit 1, a
	call nz, Function_04_4DDF
	ld bc, $0011
	add hl, bc
	ld a, [hli]
	and a, $07
	dec a
	cp a, [hl]
	jr nc, Label_04_4CCC
	xor a, a
	ld [hld], a
	ld a, [hl]
	add a, $10
	jr c, Label_04_4CD3
	call Function_04_4E34
	ld [hli], a

Label_04_4CCC:: ; 04:4CCC
	dec hl
	ld a, [hld]
	cp a, [hl]
	jp c, Label_04_4D9D

; ---- code $4CD2-$4CD3 (1 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jpcc at 04:4CCF (executed)
	inc hl

; ---- code $4CD3-$4D53 (128 bytes) [CONFIRMED] 79 insn(s); 79 executed (in up to 17/18 scenarios)

Label_04_4CD3:: ; 04:4CD3
	ld bc, $FFFA
	add hl, bc
	ld b, [hl]
	ld de, $0005
	add hl, de
	ld c, [hl]
	push bc
	ld bc, $FFF0
	add hl, bc
	res 4, [hl]
	call Function_04_4E04
	ld d, a
	ld bc, $0011
	add hl, bc
	pop bc
	ld a, b
	cpl
	rrca
	and a, $07
	jr nz, Label_04_4CFB
	call Function_04_4DD3
	jr z, Label_04_4D54
	ld a, d
	ld c, d

Label_04_4CFB:: ; 04:4CFB
	or a, c
	ld [hli], a
	xor a, a
	ld [hli], a
	jp Label_04_4DAE

Label_04_4D02:: ; 04:4D02
	ld a, [wSoundDrv_UpdateFlags]
	bit 1, a
	call nz, Function_04_4E04
	ld bc, $0011
	add hl, bc
	ld a, [hli]
	and a, $07
	jr z, Label_04_4D34
	dec a
	cp a, [hl]
	jr nc, Label_04_4D22
	xor a, a
	ld [hld], a
	ld a, [hl]
	sub a, $10
	jr c, Label_04_4D2A
	call Function_04_4E34
	ld [hli], a

Label_04_4D22:: ; 04:4D22
	dec hl
	dec hl
	ld a, [hli]
	or a, $0F
	cp a, [hl]
	jr c, Label_04_4D9D

Label_04_4D2A:: ; 04:4D2A
	call Function_04_4DD3
	jr z, Label_04_4D54
	dec hl

Label_04_4D30:: ; 04:4D30
	ld a, [hli]
	ld [hl], a
	jr Label_04_4DAE

Label_04_4D34:: ; 04:4D34
	dec hl
	ld a, [hld]
	xor a, [hl]
	jr nz, Label_04_4D30
	jr Label_04_4DB6

Label_04_4D3B:: ; 04:4D3B
	ld bc, $0011
	add hl, bc
	ld a, [hli]
	and a, $07
	dec a
	cp a, [hl]
	jr nc, Label_04_4D9D
	xor a, a
	ld [hld], a
	ld a, [hl]
	sub a, $10
	jr c, Label_04_4D54
	call Function_04_4E34
	ld [hl], a
	jr Label_04_4D9D

; ---- code $4D53-$4D54 (1 bytes) [HYPOTHESIS] dec hl ($2B) directly before the executed 4D54 (push hl); the previous region ends with an unconditional jr and no branch to 4D53 was found, so the entry is unproven (same class as the single-instruction holes of bank 2D)
	dec hl

; ---- code $4D54-$4D72 (30 bytes) [CONFIRMED] 20 insn(s); 20 executed (in up to 17/18 scenarios)

Label_04_4D54:: ; 04:4D54
	push hl
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld bc, $002F
	add hl, bc
	ld b, [hl]
	ld de, $FFF8
	add hl, de
	ld a, [hli]
	ld c, a
	ld d, [hl]
	pop hl
	ld a, b
	and a, a
	jr z, Label_04_4D90
	ld a, c
	and a, a
	jr z, Label_04_4D90

; ---- code $4D72-$4D90 (30 bytes) [PROBABLE] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 0; fall-through of the jrcc at 04:4D70 (executed)
	ld a, d
	and a, a
	jr z, Label_04_4D90
	call SoundDrv_MulNibbles
	add a, $0F
	and a, $F0
	ld [hli], a
	ld [hl], d
	ld bc, $FFEE
	add hl, bc
	ld a, [hl]
	and a, $8F
	ld [hl], a
	jr Label_04_4DAE

Label_04_4D89:: ; 04:4D89
	ld bc, $0012
	add hl, bc
	dec [hl]
	jr nz, Label_04_4DB6

; ---- code $4D90-$4E72 (226 bytes) [CONFIRMED] 122 insn(s); 122 executed (in up to 17/18 scenarios)

Label_04_4D90:: ; 04:4D90
	ld a, [wSoundDrv_ChannelPtr]
	ld l, a
	ld a, [wSoundDrv_ChannelPtr + 1]
	ld h, a
	xor a, a
	ld [hl], a
	jp SoundDrv_SilenceChannel

Label_04_4D9D:: ; 04:4D9D
	ld a, [wSoundDrv_ChannelReg]
	cp a, $1C
	jr z, Label_04_4DB6
	ld a, [wSoundDrv_UpdateFlags]
	res 1, a
	ld [wSoundDrv_UpdateFlags], a
	jr Label_04_4DB6

Label_04_4DAE:: ; 04:4DAE
	ld a, [wSoundDrv_UpdateFlags]
	set 1, a
	ld [wSoundDrv_UpdateFlags], a

Label_04_4DB6:: ; 04:4DB6
	ld a, [wSoundDrv_UpdateFlags]
	bit 2, a
	jr z, Label_04_4DC3
	call SoundDrv_WriteChannelPitch
	ld a, [wSoundDrv_UpdateFlags]

Label_04_4DC3:: ; 04:4DC3
	bit 0, a
	jr z, Label_04_4DCD
	call SoundDrv_WriteChannelPan
	ld a, [wSoundDrv_UpdateFlags]

Label_04_4DCD:: ; 04:4DCD
	bit 1, a
	ret z
	jp SoundDrv_WriteChannelVolume

Function_04_4DD3:: ; 04:4DD3
	ld bc, $FFFB
	add hl, bc
	ld a, [hl]
	ld bc, $0005
	add hl, bc
	and a, $F0
	ret

Function_04_4DDF:: ; 04:4DDF
	push hl
	ld bc, $0006
	add hl, bc
	ld c, [hl]
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld de, $002F
	add hl, de
	ld b, [hl]
	call SoundDrv_MulNibbles
	add a, $0F
	and a, $F0
	pop hl
	ld de, $0010
	add hl, de
	ld [hl], a
	ld de, $FFF0
	add hl, de
	ret

Function_04_4E04:: ; 04:4E04
	push hl
	ld bc, $000C
	add hl, bc
	ld b, [hl]
	ld de, $FFFA
	add hl, de
	ld c, [hl]
	call SoundDrv_MulNibbles
	add a, $0F
	ld c, a
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld de, $002F
	add hl, de
	ld b, [hl]
	call SoundDrv_MulNibbles
	add a, $0F
	and a, $F0
	pop hl
	ld de, $0010
	add hl, de
	ld [hl], a
	ld de, $FFF0
	add hl, de
	ret

Function_04_4E34:: ; 04:4E34
	ld b, a
	ld a, [wSoundDrv_ChannelReg]
	cp a, $1C
	ld a, b
	ret nz
	xor a, [hl]
	and a, $C0
	jr z, Label_04_4E49
	ld a, [wSoundDrv_UpdateFlags]
	set 1, a
	ld [wSoundDrv_UpdateFlags], a

Label_04_4E49:: ; 04:4E49
	ld a, b
	ret

SoundDrv_WriteChannelParams:: ; 04:4E4B
	ld a, [wSoundDrv_ChannelPtr]
	ld l, a
	ld a, [wSoundDrv_ChannelPtr + 1]
	ld h, a
	ld bc, $0008
	add hl, bc
	ld a, [wSoundDrv_ChannelReg]
	ld c, a
	cp a, $1C
	jr c, Label_04_4E7D
	jr z, Label_04_4E9B
	ld a, [hli]
	rlca
	rlca
	rlca
	and a, $08
	ld b, a
	inc c
	ldh a, [c]
	and a, $F7
	or a, b
	ldh [c], a
	ld a, [hl]
	and a, a
	jr z, Label_04_4E78

; ---- code $4E72-$4E78 (6 bytes) [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 04:4E70 (executed)
	cpl
	inc a
	ldh [rNR41], a
	ld a, $40

; ---- code $4E78-$4E87 (15 bytes) [CONFIRMED] 11 insn(s); 11 executed (in up to 17/18 scenarios)

Label_04_4E78:: ; 04:4E78
	or a, $80
	ldh [rNR44], a
	ret

Label_04_4E7D:: ; 04:4E7D
	ld a, [hli]
	rrca
	rrca
	and a, $C0
	ld b, a
	ld a, [hli]
	and a, a
	jr z, Label_04_4E8F

; ---- code $4E87-$4E8F (8 bytes) [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0; fall-through of the jrcc at 04:4E85 (executed)
	cpl
	inc a
	and a, $3F
	or a, b
	ld b, a
	ld a, $40

; ---- code $4E8F-$4EA3 (20 bytes) [CONFIRMED] 18 insn(s); 18 executed (in up to 17/18 scenarios)

Label_04_4E8F:: ; 04:4E8F
	inc c
	inc c
	ldh [c], a
	dec c
	dec c
	dec c
	ld a, b
	ldh [c], a
	dec c
	ld a, [hl]
	ldh [c], a
	ret

Label_04_4E9B:: ; 04:4E9B
	ld a, [hli]
	sub a, $10
	ld b, a
	ld a, [hl]
	and a, a
	jr z, Label_04_4EA9

; ---- code $4EA3-$4EA9 (6 bytes) [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 04:4EA1 (executed)
	cpl
	inc a
	ldh [rNR31], a
	ld a, $40

; ---- code $4EA9-$4F13 (106 bytes) [CONFIRMED] 66 insn(s); 66 executed (in up to 17/18 scenarios)

Label_04_4EA9:: ; 04:4EA9
	ldh [rNR34], a
	ld a, [wSoundDrv_WaveCache]
	cp a, b
	ret z
	ld a, b
	ld [wSoundDrv_WaveCache], a
	ld l, b
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, $547D
	add hl, bc
	ld c, $30
	ld b, $10

Label_04_4EC3:: ; 04:4EC3
	ld a, [hli]
	ldh [c], a
	inc c
	dec b
	jr nz, Label_04_4EC3
	ret

SoundDrv_WriteChannelPitch:: ; 04:4ECA
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld bc, $002C
	add hl, bc
	ld a, [hli]
	ld c, a
	ld b, [hl]
	ld a, [wSoundDrv_ChannelPtr]
	ld l, a
	ld a, [wSoundDrv_ChannelPtr + 1]
	ld h, a
	ld de, $000E
	add hl, de
	ld a, [hl]
	add a, b
	ld b, a
	ld a, [wSoundDrv_ChannelReg]
	cp a, $1C
	jr c, Label_04_4EF5
	jr nz, Label_04_4F2D
	ld a, b
	add a, $0C
	ld b, a

Label_04_4EF5:: ; 04:4EF5
	push hl
	ld a, b
	call SoundDrv_NoteToIndex
	ld b, a
	call SoundDrv_Mul8x8
	ld bc, $00FF
	add hl, bc
	ld l, h
	ld h, $00
	add hl, de
	ld a, [wSoundDrv_ChannelReg]
	ld c, a
	inc c
	ld a, l
	ldh [c], a
	inc c
	ldh a, [c]
	and a, $40
	jr z, Label_04_4F17

; ---- code $4F13-$4F17 (4 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 04:4F11 (executed)
	or a, h
	ldh [c], a
	jr Label_04_4F24

; ---- code $4F17-$4F82 (107 bytes) [CONFIRMED] 65 insn(s); 65 executed (in up to 17/18 scenarios)

Label_04_4F17:: ; 04:4F17
	or a, h
	ldh [c], a
	ld b, a
	ld a, [wSoundDrv_ChannelReg]
	ld c, a
	dec c
	ldh a, [c]
	and a, $C0
	ldh [c], a
	ld a, b

Label_04_4F24:: ; 04:4F24
	pop hl
	ld bc, $0005
	add hl, bc
	or a, $80
	ld [hl], a
	ret

Label_04_4F2D:: ; 04:4F2D
	ld c, a
	inc c
	ld a, b
	sub a, $0D
	cpl
	ld b, a
	and a, $03
	ld d, a
	ld a, b
	cp a, $C0
	jr c, Label_04_4F44
	and a, $3C
	rlca
	rlca
	or a, d
	or a, $04
	ld d, a

Label_04_4F44:: ; 04:4F44
	ldh a, [c]
	and a, $08
	or a, d
	ldh [c], a
	inc c
	ldh a, [c]
	or a, $80
	ldh [c], a
	ret

SoundDrv_WriteChannelPan:: ; 04:4F4F
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld bc, $002E
	add hl, bc
	ld a, [wSoundDrv_ChannelReg]
	cp a, $17
	jr c, Label_04_4F6D
	jr z, Label_04_4F72
	cp a, $21
	jr c, Label_04_4F77
	ld de, $7788
	jr Label_04_4F7A

Label_04_4F6D:: ; 04:4F6D
	ld de, $EE11
	jr Label_04_4F7A

Label_04_4F72:: ; 04:4F72
	ld de, $DD22
	jr Label_04_4F7A

Label_04_4F77:: ; 04:4F77
	ld de, $BB44

Label_04_4F7A:: ; 04:4F7A
	bit 7, [hl]
	jr nz, Label_04_4F86
	bit 6, [hl]
	jr z, Label_04_4F90

; ---- code $4F82-$4F90 (14 bytes) [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0; fall-through of the jrcc at 04:4F80 (executed)
	ld a, $0F
	jr Label_04_4F8E

Label_04_4F86:: ; 04:4F86
	bit 6, [hl]
	jr nz, Label_04_4F90
	ld a, $F0
	jr Label_04_4F8E

Label_04_4F8E:: ; 04:4F8E
	and a, e
	ld e, a

; ---- code $4F90-$4FEE (94 bytes) [CONFIRMED] 63 insn(s); 63 executed (in up to 18/18 scenarios)

Label_04_4F90:: ; 04:4F90
	ld c, $25
	ldh a, [c]
	and a, d
	or a, e
	ldh [c], a
	ret

SoundDrv_WriteChannelVolume:: ; 04:4F97
	ld a, [wSoundDrv_ChannelPtr]
	ld l, a
	ld a, [wSoundDrv_ChannelPtr + 1]
	ld h, a
	ld bc, $0011
	add hl, bc
	ld a, [hli]
	ld b, a
	ld a, [wSoundDrv_ChannelReg]
	ld c, a
	cp a, $1C
	jr c, Label_04_4FB8
	jr z, Label_04_4FC0
	ld a, b
	ldh [c], a
	ldh a, [rNR44]
	or a, $80
	ldh [rNR44], a
	ret

Label_04_4FB8:: ; 04:4FB8
	ld a, b
	ldh [c], a
	inc c
	inc c
	inc hl
	ld a, [hl]
	ldh [c], a
	ret

Label_04_4FC0:: ; 04:4FC0
	ld a, b
	sub a, $40
	xor a, $C0
	rrca
	ldh [c], a
	ldh a, [rNR30]
	rla
	ret c
	ld a, $80
	ldh [rNR30], a
	inc hl
	ld a, [hl]
	ldh [rNR34], a
	ret

SoundDrv_SilenceChannel:: ; 04:4FD4
	ld a, [wSoundDrv_ChannelReg]
	ld c, a
	cp a, $1C
	jr z, Label_04_4FE5
	ld a, $08
	ldh [c], a
	inc c
	inc c
	ld a, $80
	ldh [c], a
	ret

Label_04_4FE5:: ; 04:4FE5
	ld a, $00
	ldh [rNR30], a
	ret

SoundDrv_NoteToIndex:: ; 04:4FEA
	sub a, $24
	jr nc, Label_04_4FEF

; ---- code $4FEE-$4FEF (1 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 04:4FEC (executed)
	xor a, a

; ---- code $4FEF-$4FF3 (4 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 17/18 scenarios)

Label_04_4FEF:: ; 04:4FEF
	cp a, $78
	jr c, SoundDrv_LookupFrequency

; ---- code $4FF3-$4FF5 (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 04:4FF1 (executed)
	ld a, $77

; ---- code $4FF5-$5044 (79 bytes) [CONFIRMED] 61 insn(s); 61 executed (in up to 18/18 scenarios)

SoundDrv_LookupFrequency:: ; 04:4FF5
	ld d, $00
	ld e, a
	add a, e
	add a, e
	rl d
	ld e, a
	ld hl, Table_SoundDrv_NoteFreq
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ret

SoundDrv_Mul8x8:: ; 04:5007
	ld h, b
	ld l, $00
	ld b, l
	add hl, hl
	jr nc, Label_04_500F
	add hl, bc

Label_04_500F:: ; 04:500F
	add hl, hl
	jr nc, Label_04_5013
	add hl, bc

Label_04_5013:: ; 04:5013
	add hl, hl
	jr nc, Label_04_5017
	add hl, bc

Label_04_5017:: ; 04:5017
	add hl, hl
	jr nc, Label_04_501B
	add hl, bc

Label_04_501B:: ; 04:501B
	add hl, hl
	jr nc, Label_04_501F
	add hl, bc

Label_04_501F:: ; 04:501F
	add hl, hl
	jr nc, Label_04_5023
	add hl, bc

Label_04_5023:: ; 04:5023
	add hl, hl
	jr nc, Label_04_5027
	add hl, bc

Label_04_5027:: ; 04:5027
	add hl, hl
	ret nc
	add hl, bc
	ret

SoundDrv_MulNibbles:: ; 04:502B
	ld a, c
	and a, $F0
	swap a
	ld c, a
	ld a, b
	and a, $F0
	add a, a
	jr nc, Label_04_5038
	add a, c

Label_04_5038:: ; 04:5038
	add a, a
	jr nc, Label_04_503C
	add a, c

Label_04_503C:: ; 04:503C
	add a, a
	jr nc, Label_04_5040
	add a, c

Label_04_5040:: ; 04:5040
	add a, a
	ret nc
	add a, c
	ret
