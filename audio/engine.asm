; audio/engine.asm
; bank 04, $4000-$5044 (4164 bytes); pinned by layout.link
; sound driver code and its command/parameter jump tables

SECTION "audio/engine", ROMX

SoundDrv_Init:: ; 04:4000
	; [CONFIRMED] 81 insn(s); 81 executed (in up to 18/18 scenarios)
	ld a, $FF
	ld [wBank4State], a
	ld a, [wBank4SavedBankLo]
	push af
	ld a, [wBank4SavedBankHi]
	push af
	ld hl, $D001
	ld b, $3F
	xor a, a
.l4013 ; 04:4013
	ld [hli], a
	dec b
	jr nz, .l4013
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
.l4043 ; 04:4043
	ld [hl], a
	add hl, de
	dec b
	jr nz, .l4043
	xor a, a
	ld b, $04
	ld de, $0018
	ld hl, $D220
.l4051 ; 04:4051
	ld [hl], a
	add hl, de
	dec b
	jr nz, .l4051
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
	jp Bank4_RestoreCallerBank

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

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 04:409D (executed) | forced execution: 5/5 instruction starts ran
	; in forced_debug (traces/forced/, not natural evidence; status unchanged)
	call SoundDrv_SelectSfxTracks
.loop ; 04:40A2
	call SoundDrv_ApplyTrackUpdates
	call SoundDrv_NextTrack
	jr nz, .loop
	jr SoundDrv_MusicPhase

SoundDrv_SfxTickLoop:: ; 04:40AC
	; [CONFIRMED] 86 insn(s); 86 executed (in up to 18/18 scenarios)
	ld [hld], a
	ld [hl], b
	call SoundDrv_SelectAllChannels
.l40B1 ; 04:40B1
	call SoundDrv_ServiceChannelSfx
	call SoundDrv_NextChannel
	jr nz, .l40B1
	call SoundDrv_SelectSfxTracks
.l40BC ; 04:40BC
	call SoundDrv_StepTrack
	call SoundDrv_NextTrack
	jr nz, .l40BC
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
.loop ; 04:40EB
	call SoundDrv_ApplyTrackUpdates
	call SoundDrv_NextTrack
	jr nz, .loop
	jr SoundDrv_ChannelPhase

SoundDrv_MusicTickLoop:: ; 04:40F5
	ld [hld], a
	ld [hl], b
	call SoundDrv_SelectAllChannels
.l40FA ; 04:40FA
	call SoundDrv_ServiceChannelMusic
	call SoundDrv_NextChannel
	jr nz, .l40FA
	call SoundDrv_SelectMusicTracks
.l4105 ; 04:4105
	call SoundDrv_StepTrack
	call SoundDrv_NextTrack
	jr nz, .l4105
	ld hl, $D00D
	ld a, [hli]
	sub a, $4A
	ld b, a
	ld a, [hl]
	sbc a, $00
	jr nc, SoundDrv_MusicTickLoop

SoundDrv_ChannelPhase:: ; 04:4119
	call SoundDrv_SelectAllChannels
.l411C ; 04:411C
	call SoundDrv_UpdateChannel
	call SoundDrv_NextChannel
	jr nz, .l411C
	ld a, [wSoundDrv_TickDivider]
	and a, a
	jr nz, .skip
	ld a, $0F
.skip ; 04:412C
	dec a
	ld [wSoundDrv_TickDivider], a
	ld c, $08
	ld de, $003C
	ld hl, $D040
.l4138 ; 04:4138
	ld a, [hl]
	and a, $F8
	ld [hl], a
	rla
	rr b
	add hl, de
	dec c
	jr nz, .l4138
	ld a, b
	ld [wSoundDrv_ActiveMask], a
	pop de
	pop bc
	jp Bank4_GateLeave

SoundDrv_SelectSfxTracks:: ; 04:414C
	ld de, $D040
	ld a, $04
	jr SoundDrv_SetTrackIterator

SoundDrv_SelectMusicTracks:: ; 04:4153
	ld de, $D130
	ld a, $04
	jr SoundDrv_SetTrackIterator

SoundDrv_SelectAllTracks:: ; 04:415A
Function_04_415A::
	; [HYPOTHESIS] sibling of the executed entries 414C/4153 (ld de,imm ; ld a,imm ; shared tail
	; 415F): decodes to ld de,$D040 ; ld a,$08 and lands exactly on the executed tail 415F; no
	; caller or table entry found anywhere in the ROM, so entry unproven
	ld de, $D040
	ld a, $08

SoundDrv_SetTrackIterator:: ; 04:415F
	; [CONFIRMED] 67 insn(s); 67 executed (in up to 18/18 scenarios)
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

	; [PROBABLE] 37 insn(s) reached by static flow only; seeds: exec x37; min discovery hops 0;
	; fall-through of the jrcc at 04:41CD (executed)
	ld b, a
	sub a, $04
	jr nc, .l4216
	cpl
	inc a
	ld [wRam_D00F], a
	ld hl, $D040
	ld a, b
	and a, a
	jr z, .l41E7
	ld de, $003C
.l41E3 ; 04:41E3
	add hl, de
	dec b
	jr nz, .l41E3
.l41E7 ; 04:41E7
	ld a, l
	ld [wRam_D010], a
	ld a, h
	ld [wRam_D011], a
	jr .l41F9
.l41F1 ; 04:41F1
	ld a, [wRam_D010]
	ld l, a
	ld a, [wRam_D011]
	ld h, a
.l41F9 ; 04:41F9
	bit 7, [hl]
	jr z, .l420C
	ld bc, $0008
	add hl, bc
	ld a, [wRam_D03E]
	cp a, [hl]
	jr nc, .l420C
	call SoundDrv_NextHeaderTrack
	jr .l420F
.l420C ; 04:420C
	call SoundDrv_StartTrack
.l420F ; 04:420F
	jr z, .l4216
	call SoundDrv_NextTrack
	jr nz, .l41F1
.l4216 ; 04:4216
	jp Bank4_GateLeave

SoundDrv_PlaySfxAllTracks:: ; 04:4219
	; [CONFIRMED] 23 insn(s); 23 executed (in up to 17/18 scenarios)
	call SoundDrv_SelectSfxTracks
	ld a, $01
	ld [wSoundDrv_ReqDE + 1], a
	xor a, a
	ld [wSoundDrv_ReqDE], a
.l4225 ; 04:4225
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	bit 7, [hl]
	jr nz, .l4241
	call SoundDrv_StartTrack
	jr z, .l4284
	ld a, [wSoundDrv_ReqDE + 1]
	ld b, a
	ld a, [wSoundDrv_ReqDE]
	or a, b
	ld [wSoundDrv_ReqDE], a
.l4241 ; 04:4241
	ld a, [wSoundDrv_ReqDE + 1]
	sla a
	ld [wSoundDrv_ReqDE + 1], a
	call SoundDrv_NextTrack
	jr nz, .l4225

	; [CONFIRMED] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 0;
	; fall-through of the jrcc at 04:424C (executed) [executed in 6 scenarios]
	call SoundDrv_SelectSfxTracks
	ld a, $01
	ld [wSoundDrv_ReqDE + 1], a
.l4256 ; 04:4256
	ld a, [wSoundDrv_ReqDE + 1]
	ld b, a
	ld a, [wSoundDrv_ReqDE]
	and a, b
	jr nz, .l4277
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld bc, $0008
	add hl, bc
	ld a, [wSoundDrv_HeaderPriority]
	cp a, [hl]
	jr c, .l4277
	call SoundDrv_StartTrack
	jr z, .l4284
.l4277 ; 04:4277
	ld a, [wSoundDrv_ReqDE + 1]
	sla a
	ld [wSoundDrv_ReqDE + 1], a
	call SoundDrv_NextTrack
	jr nz, .l4256

.l4284 ; 04:4284
	; [CONFIRMED] 18 insn(s); 18 executed (in up to 18/18 scenarios)
	jp Bank4_GateLeave

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
.l42A2 ; 04:42A2
	call SoundDrv_StartTrack
	jr z, .l42B8
	call SoundDrv_NextTrack
	jr nz, .l42A2

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 04:42AA (executed)
	jr .l42BD

.l42AE ; 04:42AE
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 18/18 scenarios)
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	xor a, a
	ld [hl], a
.l42B8 ; 04:42B8
	call SoundDrv_NextTrack
	jr nz, .l42AE
.l42BD ; 04:42BD
	jp Bank4_GateLeave

SoundDrv_PlayMusicIfNotPlaying:: ; 04:42C0
	; [PROBABLE] entry: ROM0 stub 00:20B8 (call 2116 ; jp 04:42C0). Adversarial check: no
	; `call`/`jp` to $20B8 exists anywhere in the ROM (the '14 raw refs' of the ROM0 stub note are
	; bare word occurrences of B8 20, none preceded by a call/jp opcode), so the stub itself has no
	; known caller; the entry rests on the ROM0 stub of the same shape as the executed stub 20C4
	; plus exact tiling between CONFIRMED code (42AE-42C0 and 42D6-42EC); clean decode to a
	; terminator, no illegal opcodes, targets inside the bank
	ld a, [wRam_D01B]
	cp a, c
	jr nz, SoundDrv_PlayMusic
	ld a, [wRam_D01C]
	cp a, b
	jr nz, SoundDrv_PlayMusic
	ld a, [wRam_D024]
	and a, $F0
	jr z, SoundDrv_PlayMusic
	jp Bank4_GateLeave

SoundDrv_PlayMusicOrResume:: ; 04:42D6
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 18/18 scenarios)
	ld a, [wSoundDrv_MusicId]
	cp a, c
	jr nz, SoundDrv_PlayMusic
	ld a, [wSoundDrv_MusicId + 1]
	cp a, b
	jr nz, SoundDrv_PlayMusic
	ld a, [wSoundDrv_ActiveMask]
	and a, $F0
	jr z, SoundDrv_ResumeMusic
	jp Bank4_GateLeave

SoundDrv_ResumeMusic:: ; 04:42EC
	; [PROBABLE] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 1;
	; entered by jrcc from 04:42E7 (executed)
	xor a, a
	ld [wRam_D025], a
	call SoundDrv_SelectMusicTracks
.loop ; 04:42F3
	ld a, [wRam_D010]
	ld l, a
	ld a, [wRam_D011]
	ld h, a
	ld a, [hl]
	and a, $60
	jr z, .skip
	set 7, [hl]
.skip ; 04:4302
	call SoundDrv_NextTrack
	jr nz, .loop
	jp Bank4_GateLeave

SoundDrv_LoadSongHeader:: ; 04:430A
Function_04_430A::
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, b
	ld [wSoundDrv_ReqBC + 1], a
	cp a, $00
	ld a, c
	jr z, .l4319

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 04:4311 (executed) | forced execution: 3/3 instruction starts ran
	; in forced_debug (traces/forced/, not natural evidence; status unchanged)
	jr c, .l431D
.loop ; 04:4315
	pop hl
	jp Bank4_GateLeave

.l4319 ; 04:4319
	; [CONFIRMED] 135 insn(s); 135 executed (in up to 18/18 scenarios)
	cp a, $47
	jr nc, .loop
.l431D ; 04:431D
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
	call Bank4_ReadStreamWord
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

SoundDrv_StopSfxById:: ; 04:43DC
	; [PROBABLE] 39 insn(s) reached by static flow only; seeds: exec x10, site x29; min discovery
	; hops 1; entered by jp from 00:20C1 (PROBABLE code) | forced execution: 13/39 instruction
	; starts ran in forced_debug (traces/forced/, not natural evidence; status unchanged)
	ld a, b
	or a, c
	jp z, SoundDrv_StopAllSfx
	ld a, c
	ld [wRam_D038], a
	ld a, b
	ld [wRam_D039], a
	call SoundDrv_SelectSfxTracks
.loop ; 04:43EC
	ld a, [wRam_D010]
	ld c, a
	ld a, [wRam_D011]
	ld b, a
	ld a, [bc]
	bit 7, a
	jr z, .l440C
	ld hl, $0006
	add hl, bc
	ld a, [wRam_D038]
	cp a, [hl]
	jr nz, .l440C
	inc hl
	ld a, [wRam_D039]
	cp a, [hl]
	jr nz, .l440C
	xor a, a
	ld [bc], a
.l440C ; 04:440C
	call SoundDrv_NextTrack
	jr nz, .loop
	jp Bank4_GateLeave

SoundDrv_StopAllSfx:: ; 04:4414
	call SoundDrv_SelectSfxTracks
.loop ; 04:4417
	ld a, [wRam_D010]
	ld l, a
	ld a, [wRam_D011]
	ld h, a
	xor a, a
	ld [hl], a
	call SoundDrv_NextTrack
	jr nz, .loop
	jp Bank4_GateLeave

SoundDrv_PauseMusic:: ; 04:4429
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 18/18 scenarios)
	call SoundDrv_PauseMusicCore
	jp Bank4_GateLeave

SoundDrv_FadeFinished:: ; 04:442F
	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by jpcc from 04:454D (PROBABLE code)
	xor a, a
	ld [wSoundDrv_FadeSpeed], a

SoundDrv_PauseMusicCore:: ; 04:4433
Function_04_4433::
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $FF
	ld [wSoundDrv_MusicPaused], a
	call SoundDrv_SelectMusicTracks
.loop ; 04:443B
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	res 7, [hl]
	call SoundDrv_NextTrack
	jr nz, .loop
	ret

SoundDrv_GetActiveMasks:: ; 04:444B
	; [PROBABLE] entry: ROM0 stub 00:20D0 (call 2116 ; jp 04:444B; no call/jp to $20D0 found in the
	; ROM, stub has no known caller); reads [D024] nibbles into D/E, jp 2141 (bank-04 routine exit)
	ld a, [wRam_D024]
	and a, $0F
	ld d, a
	ld a, [wRam_D024]
	and a, $F0
	swap a
	ld e, a
	jp Bank4_GateLeave

SoundDrv_GetPlayingId:: ; 04:445C
	; [PROBABLE] entry: ROM0 stub 00:20E2 (call 2116 ; jp 04:445C; no call/jp to $20E2 found in the
	; ROM, stub has no known caller); indexes the WRAM record table at 449B with [bc]=4499+2a, ends
	; with jp 2141
	and a, a
	jr nz, .l4470
	ld a, [wRam_D024]
	and a, $F0
	jr z, .l4474
	ld a, [wRam_D01B]
	ld c, a
	ld a, [wRam_D01C]
	ld b, a
	jr .l4498
.l4470 ; 04:4470
	cp a, $05
	jr c, .l4479
.l4474 ; 04:4474
	ld bc, $0000
	jr .l4498
.l4479 ; 04:4479
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
	jr z, .l4498
	ld bc, $0006
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
.l4498 ; 04:4498
	jp Bank4_GateLeave

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

SoundDrv_SetTrackParam:: ; 04:44B1
	; [PROBABLE] entry: ROM0 stub 00:20D6 (call 2116 ; jp 04:44B1; no call/jp to $20D6 found in the
	; ROM, stub has no known caller): call 44B7 ; jp 2141
	call SoundDrv_SetTrackParamCore
	jp Bank4_GateLeave

SoundDrv_SetTrackParamCore:: ; 04:44B7
	; [PROBABLE] 17 insn(s) reached by static flow only; seeds: exec x17; min discovery hops 1;
	; entered by jp from 04:4557 (PROBABLE code)
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

SoundDrv_SetTrackFieldByte:: ; 04:44CF
	; [PROBABLE] target of 4 jp $44CF at 04:4912/496D/4952/4994 (code entered through jump-table
	; entries) and contains the entry 452C of ROM0 stub 00:20DC (no call/jp to $20DC found in the
	; ROM); clean decode, ends with jp 2141
	call SoundDrv_BuildTrackMask
.loop ; 04:44D2
	rrc d
	jr nc, .l44E6
	bit 7, [hl]
	jr z, .l44E6
	ld a, [wRam_D03C]
	or a, [hl]
	ld [hl], a
	push hl
	add hl, bc
	ld a, [wRam_D039]
	ld [hl], a
	pop hl
.l44E6 ; 04:44E6
	call SoundDrv_NextTrackRecord
	jr nz, .loop
	ret

SoundDrv_SetTrackFieldWord:: ; 04:44EC
	call SoundDrv_BuildTrackMask
.loop ; 04:44EF
	rrc d
	jr nc, .l4507
	bit 7, [hl]
	jr z, .l4507
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
.l4507 ; 04:4507
	call SoundDrv_NextTrackRecord
	jr nz, .loop
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
	jp Bank4_GateLeave

SoundDrv_UpdateFade:: ; 04:453A
Function_04_453A::
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wSoundDrv_MusicPaused]
	and a, a
	ret nz
	ld a, [wSoundDrv_FadeSpeed]
	and a, a
	ret z

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the retcc at 04:4543 (executed)
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

SoundDrv_ApplyTrackUpdates:: ; 04:455A
Function_04_455A::
	; [CONFIRMED] 120 insn(s); 120 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
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
	jr nz, .l4582
	push hl
	call SoundDrv_InitTrackRuntime
	pop hl
	ld a, [hl]
.l4582 ; 04:4582
	ld [wSoundDrv_UpdateFlags], a
	inc hl
	ld a, [hl]
	and a, a
	jr z, .l458E
	dec [hl]
	inc hl
	jr Label_04_45E6
.l458E ; 04:458E
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
	call Bank4_ReadStreamWord
	bit 7, c
	jr nz, .l45B6
	ld a, c
	ld [wSoundDrv_StreamByte], a
	dec de
	ld a, [hl]
	jr .l45C0
.l45B6 ; 04:45B6
	ld a, b
	ld [wSoundDrv_StreamByte], a
	ld a, c
	cp a, $BE
	jr c, .l45C0
	ld [hl], a
.l45C0 ; 04:45C0
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
	jr z, .l45F7
	dec [hl]
	ld bc, $FFF5
	add hl, bc
	ld a, $40
	jr .l45FD
.l45F7 ; 04:45F7
	ld bc, $FFF4
	add hl, bc
	ld a, [hli]
	add a, [hl]
.l45FD ; 04:45FD
	ld [hl], a
	sla a
	jr nc, .skip
	cpl
.skip ; 04:4603
	ld [wRam_D01E], a
	ld bc, $0001
	add hl, bc
	ld a, [hli]
	add a, [hl]
	jr z, .l4623
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
	jr z, .l462E

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 04:461F (executed)
	jr .l465D

.l4623 ; 04:4623
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 17/18 scenarios)
	ld bc, $0000
	inc hl
	ld a, [hli]
	cp a, $00
	jr z, .l4640

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 04:462A (executed)
	jr .l465D

.l462E ; 04:462E
	; [CONFIRMED] 80 insn(s); 80 executed (in up to 17/18 scenarios)
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
.l4640 ; 04:4640
	ld a, c
	cp a, [hl]
	jr z, .l464D
	ld a, [wSoundDrv_UpdateFlags]
	set 2, a
	ld [wSoundDrv_UpdateFlags], a
	ld [hl], c
.l464D ; 04:464D
	inc hl
	ld a, b
	cp a, [hl]
	jr z, .l465B
	ld a, [wSoundDrv_UpdateFlags]
	set 2, a
	ld [wSoundDrv_UpdateFlags], a
	ld [hl], b
.l465B ; 04:465B
	jr .l465D
.l465D ; 04:465D
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld a, [wSoundDrv_UpdateFlags]

SoundDrv_ComputeTrackOutput:: ; 04:4668
	bit 2, a
	jr z, .l46A8
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
	jr nz, .l469A
	ld a, [hli]
	add a, e
	ld e, a
	ld a, [hld]
	adc a, d
	ld d, a
.l469A ; 04:469A
	ld bc, $0008
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d
	ld bc, $FFD3
	add hl, bc
	ld a, [wSoundDrv_UpdateFlags]
.l46A8 ; 04:46A8
	bit 0, a
	jr z, .l46BF

	; [PROBABLE] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 0;
	; fall-through of the jrcc at 04:46AA (executed)
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

.l46BF ; 04:46BF
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 17/18 scenarios)
	bit 1, a
	jr z, .l46E6
	ld bc, $0015
	add hl, bc
	ld a, [hli]
	ld b, a
	ld c, [hl]
	call SoundDrv_MulNibbles
	add a, $0F
	and a, $F0
	cp a, $40
	jr c, .skip
	ld a, $FF
.skip ; 04:46D7
	rlca
	rlca
	ld e, a
	ld bc, $0019
	add hl, bc
	ld [hl], e
	ld bc, $FFD1
	add hl, bc
	ld a, [wSoundDrv_UpdateFlags]
.l46E6 ; 04:46E6
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

SoundDrv_CmdExtended:: ; 04:473E
	; [PROBABLE] 11 insn(s) reached by static flow only; seeds: table x11; min discovery hops 0; run
	; starts at an entry of the code-pointer table at 04:46E8
	ld a, [wSoundDrv_StreamByte]
	inc de
	cp a, $0C
	jp nc, SoundDrv_CmdEnd
	ld b, a
	call Bank4_ReadStreamByte
	ld a, c
	ld [wSoundDrv_StreamByte], a
	ld a, b
	ld bc, Table_SoundDrv_ExtCommands
	jp SoundDrv_JumpTable

SoundDrv_CmdRest:: ; 04:4756
	; [CONFIRMED] 70 insn(s); 70 executed (in up to 17/18 scenarios)
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
	call Bank4_ReadStreamWord
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

SoundDrv_CmdRepeat:: ; 04:47C5
	; [PROBABLE] 18 insn(s) reached by static flow only; seeds: table x18; min discovery hops 0; run
	; starts at an entry of the code-pointer table at 04:46E8
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

SoundDrv_CmdSetTempo:: ; 04:47E3
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 18/18 scenarios)
	ld hl, $D000
	bit 5, [hl]
	ld hl, $D00A
	jr z, .skip
	ld hl, $D005
.skip ; 04:47F0
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
	jr c, .l480C

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 04:4806 (executed)
	ld a, $3F
	ld l, $FF

.l480C ; 04:480C
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 18/18 scenarios)
	sla l
	rla
	sla l
	rla
	and a, a
	jr nz, .l4816

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 04:4813 (executed)
	inc a

.l4816 ; 04:4816
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 18/18 scenarios)
	pop hl
	ld [hl], a
	ret

SoundDrv_ParamTempoScale:: ; 04:4819
	; [PROBABLE] validated entry 4819 of jump table Table_04_44A3 (index 0); clean decode to a
	; terminator
	ld a, [wRam_D03B]
	and a, a
	jr z, .l4829
	ld hl, $D006
	ld a, [wRam_D039]
	ld [hld], a
	call SoundDrv_UpdateTempoStep
.l4829 ; 04:4829
	ld a, [wRam_D03A]
	and a, a
	jr z, .done
	ld hl, $D00B
	ld a, [wRam_D039]
	ld [hld], a
	call SoundDrv_UpdateTempoStep
.done ; 04:4839
	ret

Label_04_483A:: ; 04:483A
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 18/18 scenarios)
	ld bc, $0012
	jp Label_04_4973

Label_04_4840:: ; 04:4840
	; [PROBABLE] validated entry 4840 of jump table Table_04_44A3 (index 1); clean decode to a
	; terminator
	ld a, [wRam_D03C]
	set 2, a
	ld [wRam_D03C], a
	ld bc, $0013
	jp SoundDrv_SetTrackFieldWord

SoundDrv_CmdSetInstrument:: ; 04:484E
	; [CONFIRMED] 108 insn(s); 108 executed (in up to 18/18 scenarios)
	ld a, [wSoundDrv_StreamByte]
	inc de
	cp a, $64
	jr z, .l487E
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
.l487E ; 04:487E
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
	jr c, .l48B9
	call SoundDrv_Mul8x8
	ld c, l
	ld b, h
	jr .l48C6
.l48B9 ; 04:48B9
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
.l48C6 ; 04:48C6
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
	jr nz, .l4905

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 04:48FF (executed)
	ccf
	rra
	rra
	ld [hl], a

.l4905 ; 04:4905
	; [CONFIRMED] 1 insn(s); 1 executed (in up to 17/18 scenarios)
	jp SoundDrv_ReadNextCommand

Label_04_4908:: ; 04:4908
	; [PROBABLE] validated entry 4908 of jump table Table_04_44A3; clean decode to a terminator
	ld a, [wRam_D039]
	sla a
	jr z, .l4915
	ld bc, $001F
	jp SoundDrv_SetTrackFieldByte
.l4915 ; 04:4915
	rra
	ld [wRam_D038], a
	rra
	xor a, $40
	ld [wRam_D039], a
	ld bc, $001F
	jp SoundDrv_SetTrackFieldWord

Label_04_4925:: ; 04:4925
	; [CONFIRMED] 16 insn(s); 16 executed (in up to 18/18 scenarios)
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

SoundDrv_ParamVolumeScale:: ; 04:4947
	; [PROBABLE] validated entry 4947 of jump table Table_04_44A3; clean decode to a terminator
	ld a, [wRam_D03C]
	set 1, a
	ld [wRam_D03C], a
	ld bc, $0016
	jp SoundDrv_SetTrackFieldByte

Label_04_4955:: ; 04:4955
	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: table x5; min discovery hops 0; run
	; starts at an entry of the code-pointer table at 04:46E8
	ld a, [wRam_D019]
	set 0, a
	ld [wRam_D019], a
	ld bc, $0017
	jr Label_04_49A2

Label_04_4962:: ; 04:4962
	; [PROBABLE] validated entry 4962 of jump table Table_04_44A3; clean decode to a terminator
	ld a, [wRam_D03C]
	set 0, a
	ld [wRam_D03C], a
	ld bc, $0018
	jp SoundDrv_SetTrackFieldByte

Label_04_4970:: ; 04:4970
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 18/18 scenarios)
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

Label_04_4984:: ; 04:4984
	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: table x5; min discovery hops 0; run
	; starts at an entry of the code-pointer table at 04:46E8
	ld a, [wSoundDrv_UpdateFlags]
	or a, $07
	ld [wSoundDrv_UpdateFlags], a
	ld bc, $0023
	jr Label_04_4973

Label_04_4991:: ; 04:4991
	; [PROBABLE] validated entry 4991 of jump table Table_04_44A3; clean decode to a terminator
	ld bc, $0022
	jp SoundDrv_SetTrackFieldByte

Label_04_4997:: ; 04:4997
	; [PROBABLE] 20 insn(s) reached by static flow only; seeds: table x20; min discovery hops 0; run
	; starts at an entry of the code-pointer table at 04:46E8
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

Label_04_49C3:: ; 04:49C3
	; [PROBABLE] entries 49C3/49C8/49CD/49D3/49D8/49DD/49E2/49FF/4A1A/4A1F are words of the jump
	; tables Table_04_44A3 and Table_04_46E8/4726; clean decode to a terminator at 4A24
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

Label_04_4A24:: ; 04:4A24
	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: table x1; min discovery hops 0; run
	; starts at an entry of the code-pointer table at 04:46E8
	jp SoundDrv_CmdEnd

Label_04_4A27:: ; 04:4A27
	; [CONFIRMED] 29 insn(s); 29 executed (in up to 18/18 scenarios)
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
	jr .l4A50
.loop ; 04:4A4B
	inc de
	call Bank4_ReadStreamByte
	ld a, c
.l4A50 ; 04:4A50
	bit 7, a
	jr nz, SoundDrv_StartNote
	cp a, $24
	jr nc, .l4A69
	cp a, $20
	jr c, .l4A73

	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0;
	; fall-through of the jrcc at 04:4A5A (executed)
	bit 5, b
	jr nz, SoundDrv_StartNote
	set 5, b
	sub a, $20
	inc hl
	add a, [hl]
	ld [hld], a
	jr .loop

.l4A69 ; 04:4A69
	; [CONFIRMED] 155 insn(s); 155 executed (in up to 18/18 scenarios)
	bit 7, b
	jr nz, SoundDrv_StartNote
	set 7, b
	dec hl
	ld [hli], a
	jr .loop
.l4A73 ; 04:4A73
	bit 6, b
	jr nz, SoundDrv_StartNote
	set 6, b
	rlca
	rlca
	rlca
	or a, $07
	ld [hl], a
	jr .loop

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
	jr z, .l4ABE
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
.l4ABE ; 04:4ABE
	ld a, [hl]
	cp a, $10
	jr nc, .l4AD1
	cp a, $08
	jr nc, .l4ACC
	call SoundDrv_SelectChannel1
	jr .l4ADD
.l4ACC ; 04:4ACC
	call SoundDrv_SelectChannel2
	jr .l4ADD
.l4AD1 ; 04:4AD1
	cp a, $40
	jr nc, .l4ADA
	call SoundDrv_SelectChannel3
	jr .l4ADD
.l4ADA ; 04:4ADA
	call SoundDrv_SelectChannel4
.l4ADD ; 04:4ADD
	ld a, [wSoundDrv_TrackCount]
	ld hl, $D000
	bit 5, [hl]
	jr z, .skip
	set 7, a
.skip ; 04:4AE9
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
	jr z, .l4B1A
	bit 5, a
	jr nz, .l4B10
	jr .l4B1A
.l4B10 ; 04:4B10
	ld a, [hli]
	cp a, d
	jr c, .l4B1A
	jr nz, .l4B62
	ld a, e
	cp a, [hl]
	jr c, .l4B62
.l4B1A ; 04:4B1A
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
.l4B62 ; 04:4B62
	pop de
	jp SoundDrv_ReadNextCommand

Label_04_4B66:: ; 04:4B66
	; [CONFIRMED] 53 insn(s) reached by static flow only; seeds: table x53; min discovery hops 0;
	; run starts at an entry of the code-pointer table at 04:46E8 | 9 insn(s) executed; cut out of
	; the PROBABLE region 4B66-4BC9 by apply_coverage --split [executed in 7 scenarios]
	ld a, [wSoundDrv_TrackPtr]
	ld l, a
	ld a, [wSoundDrv_TrackPtr + 1]
	ld h, a
	ld bc, $0009
	add hl, bc
	ld a, [wSoundDrv_StreamByte]
	bit 7, a
	jr nz, .l4B7F

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4B66-4BC9 by apply_coverage --split
	cp a, $24
	jr c, .l4B7F
	inc de
	ld [hl], a

.l4B7F ; 04:4B7F
	; [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 4B66-4BC9 by apply_coverage
	; --split [executed in 7 scenarios]
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
	jr z, .skip

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4B66-4BC9 by apply_coverage --split
	set 7, a

.skip ; 04:4B98
	; [CONFIRMED] 28 insn(s) executed; cut out of the PROBABLE region 4B66-4BC9 by apply_coverage
	; --split [executed in 7 scenarios]
	ld e, a
	ld a, [wSoundDrv_ReqDE]
	ld d, a
.loop ; 04:4B9D
	ld a, [wSoundDrv_ChannelPtr]
	ld l, a
	ld a, [wSoundDrv_ChannelPtr + 1]
	ld h, a
	ld a, [hli]
	bit 5, a
	jr z, .l4BC0
	inc hl
	ld a, [hli]
	cp a, e
	jr nz, .l4BC0
	ld a, [hl]
	cp a, d
	jr nz, .l4BC0
	ld bc, $0004
	add hl, bc
	ld a, [hl]
	and a, a
	jr nz, .l4BC0
	call SoundDrv_NoteGateExpired
	jr .l4BC5
.l4BC0 ; 04:4BC0
	call SoundDrv_NextChannel
	jr nz, .loop
.l4BC5 ; 04:4BC5
	pop de
	jp SoundDrv_ReadNextCommand

SoundDrv_ServiceChannelSfx:: ; 04:4BC9
Function_04_4BC9::
	; [CONFIRMED] 90 insn(s); 90 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
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
	jr nc, .l4C38
	pop hl
	jr Label_04_4C0F
.l4C38 ; 04:4C38
	ld [wSoundDrv_UpdateFlags], a
	bit 6, b
	jr nz, .l4C5F
	ld de, $000C
	add hl, de
	ld a, [wSoundDrv_TickDivider]
	and a, a
	jr nz, .skip
	inc [hl]
.skip ; 04:4C4A
	inc [hl]
	pop hl
	bit 5, b
	jr z, .l4C57
	bit 4, b
	jr nz, .l4CAE
	jp .l4D02
.l4C57 ; 04:4C57
	bit 4, b
	jp nz, .l4D3B

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jpcc at 04:4C59 (executed)
	jp .l4D89

.l4C5F ; 04:4C5F
	; [CONFIRMED] 66 insn(s); 66 executed (in up to 17/18 scenarios)
	pop hl
	res 6, [hl]
	bit 5, [hl]
	jr z, .l4C8F
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
	jr z, .l4CD3
	or a, $08
	ld [hli], a
	xor a, a
	ld [hli], a
	jp .l4DB6
.l4C8F ; 04:4C8F
	ld bc, $000C
	add hl, bc
	ld b, [hl]
	ld de, $0005
	add hl, de
	ld a, [hl]
	and a, $F0
	jp z, .l4D54
	ld c, a
	ld a, b
	cpl
	rrca
	and a, $07
	jp z, .l4D54
	or a, c
	ld [hli], a
	xor a, a
	ld [hli], a
	jp .l4DAE
.l4CAE ; 04:4CAE
	ld a, [wSoundDrv_UpdateFlags]
	bit 1, a
	call nz, Function_04_4DDF
	ld bc, $0011
	add hl, bc
	ld a, [hli]
	and a, $07
	dec a
	cp a, [hl]
	jr nc, .l4CCC
	xor a, a
	ld [hld], a
	ld a, [hl]
	add a, $10
	jr c, .l4CD3
	call Function_04_4E34
	ld [hli], a
.l4CCC ; 04:4CCC
	dec hl
	ld a, [hld]
	cp a, [hl]
	jp c, .l4D9D

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jpcc at 04:4CCF (executed)
	inc hl

.l4CD3 ; 04:4CD3
	; [CONFIRMED] 79 insn(s); 79 executed (in up to 17/18 scenarios)
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
	jr nz, .l4CFB
	call Function_04_4DD3
	jr z, .l4D54
	ld a, d
	ld c, d
.l4CFB ; 04:4CFB
	or a, c
	ld [hli], a
	xor a, a
	ld [hli], a
	jp .l4DAE
.l4D02 ; 04:4D02
	ld a, [wSoundDrv_UpdateFlags]
	bit 1, a
	call nz, Function_04_4E04
	ld bc, $0011
	add hl, bc
	ld a, [hli]
	and a, $07
	jr z, .l4D34
	dec a
	cp a, [hl]
	jr nc, .l4D22
	xor a, a
	ld [hld], a
	ld a, [hl]
	sub a, $10
	jr c, .l4D2A
	call Function_04_4E34
	ld [hli], a
.l4D22 ; 04:4D22
	dec hl
	dec hl
	ld a, [hli]
	or a, $0F
	cp a, [hl]
	jr c, .l4D9D
.l4D2A ; 04:4D2A
	call Function_04_4DD3
	jr z, .l4D54
	dec hl
.loop ; 04:4D30
	ld a, [hli]
	ld [hl], a
	jr .l4DAE
.l4D34 ; 04:4D34
	dec hl
	ld a, [hld]
	xor a, [hl]
	jr nz, .loop
	jr .l4DB6
.l4D3B ; 04:4D3B
	ld bc, $0011
	add hl, bc
	ld a, [hli]
	and a, $07
	dec a
	cp a, [hl]
	jr nc, .l4D9D
	xor a, a
	ld [hld], a
	ld a, [hl]
	sub a, $10
	jr c, .l4D54
	call Function_04_4E34
	ld [hl], a
	jr .l4D9D

	; [HYPOTHESIS] dec hl ($2B) directly before the executed 4D54 (push hl); the previous region
	; ends with an unconditional jr and no branch to 4D53 was found, so the entry is unproven (same
	; class as the single-instruction holes of bank 2D)
	dec hl

.l4D54 ; 04:4D54
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 17/18 scenarios)
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
	jr z, .l4D90
	ld a, c
	and a, a
	jr z, .l4D90

	; [PROBABLE] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 0;
	; fall-through of the jrcc at 04:4D70 (executed)
	ld a, d
	and a, a
	jr z, .l4D90
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
	jr .l4DAE
.l4D89 ; 04:4D89
	ld bc, $0012
	add hl, bc
	dec [hl]
	jr nz, .l4DB6

.l4D90 ; 04:4D90
	; [CONFIRMED] 122 insn(s); 122 executed (in up to 17/18 scenarios)
	ld a, [wSoundDrv_ChannelPtr]
	ld l, a
	ld a, [wSoundDrv_ChannelPtr + 1]
	ld h, a
	xor a, a
	ld [hl], a
	jp SoundDrv_SilenceChannel
.l4D9D ; 04:4D9D
	ld a, [wSoundDrv_ChannelReg]
	cp a, $1C
	jr z, .l4DB6
	ld a, [wSoundDrv_UpdateFlags]
	res 1, a
	ld [wSoundDrv_UpdateFlags], a
	jr .l4DB6
.l4DAE ; 04:4DAE
	ld a, [wSoundDrv_UpdateFlags]
	set 1, a
	ld [wSoundDrv_UpdateFlags], a
.l4DB6 ; 04:4DB6
	ld a, [wSoundDrv_UpdateFlags]
	bit 2, a
	jr z, .l4DC3
	call SoundDrv_WriteChannelPitch
	ld a, [wSoundDrv_UpdateFlags]
.l4DC3 ; 04:4DC3
	bit 0, a
	jr z, .l4DCD
	call SoundDrv_WriteChannelPan
	ld a, [wSoundDrv_UpdateFlags]
.l4DCD ; 04:4DCD
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
	jr z, .skip
	ld a, [wSoundDrv_UpdateFlags]
	set 1, a
	ld [wSoundDrv_UpdateFlags], a
.skip ; 04:4E49
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
	jr c, .l4E7D
	jr z, .l4E9B
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
	jr z, .l4E78

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 04:4E70 (executed)
	cpl
	inc a
	ldh [rNR41], a
	ld a, $40

.l4E78 ; 04:4E78
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 17/18 scenarios)
	or a, $80
	ldh [rNR44], a
	ret
.l4E7D ; 04:4E7D
	ld a, [hli]
	rrca
	rrca
	and a, $C0
	ld b, a
	ld a, [hli]
	and a, a
	jr z, .l4E8F

	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 04:4E85 (executed)
	cpl
	inc a
	and a, $3F
	or a, b
	ld b, a
	ld a, $40

.l4E8F ; 04:4E8F
	; [CONFIRMED] 18 insn(s); 18 executed (in up to 17/18 scenarios)
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
.l4E9B ; 04:4E9B
	ld a, [hli]
	sub a, $10
	ld b, a
	ld a, [hl]
	and a, a
	jr z, .l4EA9

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 04:4EA1 (executed)
	cpl
	inc a
	ldh [rNR31], a
	ld a, $40

.l4EA9 ; 04:4EA9
	; [CONFIRMED] 66 insn(s); 66 executed (in up to 17/18 scenarios)
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
.loop ; 04:4EC3
	ld a, [hli]
	ldh [c], a
	inc c
	dec b
	jr nz, .loop
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
	jr c, .l4EF5
	jr nz, .l4F2D
	ld a, b
	add a, $0C
	ld b, a
.l4EF5 ; 04:4EF5
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
	jr z, .l4F17

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 04:4F11 (executed)
	or a, h
	ldh [c], a
	jr .l4F24

.l4F17 ; 04:4F17
	; [CONFIRMED] 65 insn(s); 65 executed (in up to 17/18 scenarios)
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
.l4F24 ; 04:4F24
	pop hl
	ld bc, $0005
	add hl, bc
	or a, $80
	ld [hl], a
	ret
.l4F2D ; 04:4F2D
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
	jr c, .l4F44
	and a, $3C
	rlca
	rlca
	or a, d
	or a, $04
	ld d, a
.l4F44 ; 04:4F44
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
	jr c, .l4F6D
	jr z, .l4F72
	cp a, $21
	jr c, .l4F77
	ld de, $7788
	jr .l4F7A
.l4F6D ; 04:4F6D
	ld de, $EE11
	jr .l4F7A
.l4F72 ; 04:4F72
	ld de, $DD22
	jr .l4F7A
.l4F77 ; 04:4F77
	ld de, $BB44
.l4F7A ; 04:4F7A
	bit 7, [hl]
	jr nz, .l4F86
	bit 6, [hl]
	jr z, .l4F90

	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0;
	; fall-through of the jrcc at 04:4F80 (executed)
	ld a, $0F
	jr .l4F8E
.l4F86 ; 04:4F86
	bit 6, [hl]
	jr nz, .l4F90
	ld a, $F0
	jr .l4F8E
.l4F8E ; 04:4F8E
	and a, e
	ld e, a

.l4F90 ; 04:4F90
	; [CONFIRMED] 63 insn(s); 63 executed (in up to 18/18 scenarios)
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
	jr c, .l4FB8
	jr z, .l4FC0
	ld a, b
	ldh [c], a
	ldh a, [rNR44]
	or a, $80
	ldh [rNR44], a
	ret
.l4FB8 ; 04:4FB8
	ld a, b
	ldh [c], a
	inc c
	inc c
	inc hl
	ld a, [hl]
	ldh [c], a
	ret
.l4FC0 ; 04:4FC0
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
	jr z, .l4FE5
	ld a, $08
	ldh [c], a
	inc c
	inc c
	ld a, $80
	ldh [c], a
	ret
.l4FE5 ; 04:4FE5
	ld a, $00
	ldh [rNR30], a
	ret

SoundDrv_NoteToIndex:: ; 04:4FEA
	sub a, $24
	jr nc, .skip

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 04:4FEC (executed)
	xor a, a

.skip ; 04:4FEF
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 17/18 scenarios)
	cp a, $78
	jr c, SoundDrv_LookupFrequency

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 04:4FF1 (executed)
	ld a, $77

SoundDrv_LookupFrequency:: ; 04:4FF5
	; [CONFIRMED] 61 insn(s); 61 executed (in up to 18/18 scenarios)
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
	jr nc, .l500F
	add hl, bc
.l500F ; 04:500F
	add hl, hl
	jr nc, .l5013
	add hl, bc
.l5013 ; 04:5013
	add hl, hl
	jr nc, .l5017
	add hl, bc
.l5017 ; 04:5017
	add hl, hl
	jr nc, .l501B
	add hl, bc
.l501B ; 04:501B
	add hl, hl
	jr nc, .l501F
	add hl, bc
.l501F ; 04:501F
	add hl, hl
	jr nc, .l5023
	add hl, bc
.l5023 ; 04:5023
	add hl, hl
	jr nc, .l5027
	add hl, bc
.l5027 ; 04:5027
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
	jr nc, .l5038
	add a, c
.l5038 ; 04:5038
	add a, a
	jr nc, .l503C
	add a, c
.l503C ; 04:503C
	add a, a
	jr nc, .l5040
	add a, c
.l5040 ; 04:5040
	add a, a
	ret nc
	add a, c
	ret
