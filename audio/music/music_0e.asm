; audio/music/music_0e.asm
; bank 05, $4000-$4232 (562 bytes); pinned by layout.link
; song id 0E

SECTION "audio/music/music_0e", ROMX

; ---- data $4000-$4024 (36 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong0E_Track0:: ; 05:4000
Data_05_4000::
	sound_volume $7F
	sound_pitch_add $00
SoundSong0E_Track0_Loop:: ; 05:4004
Data_05_4004::
	sound_tempo $3B
	sound_instrument $29
	sound_vibrato_depth $14
	sound_vibrato_rate $28
	sound_vibrato_delay $20
	sound_note 48, $48, $13
	sound_wait 60
	sound_note 12, $46
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_note 60, $43
	sound_wait 12
	sound_wait 60
	sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $40
	sound_wait 12
	sound_note 60, $41
	sound_wait 12
	sound_wait 60

; ---- data $4024-$4047 (35 bytes) [PROBABLE] interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md; read as data by executed code in up to 14 of 69 natural scenarios (34 of 35 bytes; traces/detail)

Data_05_4024:: ; 05:4024
	sound_note 12, $46
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_note 72, $43
	sound_wait 12
	sound_wait 96
	sound_note 48, $48
	sound_wait 60
	sound_note 12, $46
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_note 60, $43
	sound_wait 12
	sound_wait 60
	sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $40
	sound_wait 12
	sound_note 84, $41
	sound_wait 12
	sound_wait 96
	sound_wait 96
	sound_jump SoundSong0E_Track0_Loop
SoundSong0E_Track0_AfterJump:: ; 05:4046
Data_05_4046::
	sound_end

; ---- data $4047-$4090 (73 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong0E_Track1:: ; 05:4047
Data_05_4047::
	sound_volume $7F
	sound_pitch_add $00
SoundSong0E_Track1_Loop:: ; 05:404B
Data_05_404B::
	sound_instrument $06
	sound_wait 12
	sound_note 4, $45, $0C
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $41, $0C
	sound_wait 12
	sound_rs sound_note 4, $4A
	sound_wait 12
	sound_rs sound_note 4, $46
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $48, $0C
	sound_wait 12
SoundSong0E_Track1_Sub1:: ; 05:406E
Data_05_406E::
	sound_wait 12
	sound_note 4, $3C, $0C
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $48, $0C
	sound_wait 12
	sound_rs sound_note 4, $43
	sound_wait 12
	sound_rs sound_note 4, $48
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4C, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $46, $0C
	sound_wait 12
	sound_ret

; ---- data $4090-$40FF (111 bytes) [PROBABLE] interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md; read as data by executed code in up to 14 of 69 natural scenarios (110 of 111 bytes; traces/detail)

SoundSong0E_Track1_Sub2:: ; 05:4090
Data_05_4090::
	sound_note 4, $45, $0C
	sound_wait 12
	sound_rs sound_note 4, $41
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $48, $0C
	sound_wait 12
	sound_rs sound_note 4, $4A
	sound_wait 12
	sound_rs sound_note 4, $46
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $43, $0C
	sound_wait 12
	sound_ret
SoundSong0E_Track1_Sub3:: ; 05:40B3
Data_05_40B3::
	sound_wait 12
	sound_note 4, $3C, $0C
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $48, $0C
	sound_wait 12
	sound_rs sound_note 4, $46
	sound_wait 24
	sound_instrument $04
	sound_note 12, $4C, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $43, $0C
	sound_wait 12
	sound_ret
	sound_wait 12
	sound_rs sound_note 4, $45
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $41, $0C
	sound_wait 12
	sound_rs sound_note 4, $4A
	sound_wait 12
	sound_rs sound_note 4, $46
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $48, $0C
	sound_wait 12
	sound_call SoundSong0E_Track1_Sub1
	sound_call SoundSong0E_Track1_Sub2
	sound_call SoundSong0E_Track1_Sub3
	sound_jump SoundSong0E_Track1_Loop
SoundSong0E_Track1_AfterJump:: ; 05:40FE
Data_05_40FE::
	sound_end

; ---- data $40FF-$4139 (58 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong0E_Track2:: ; 05:40FF
Data_05_40FF::
	sound_volume $7F
	sound_pitch_add $00
SoundSong0E_Track2_Loop:: ; 05:4103
Data_05_4103::
	sound_instrument $08
	sound_note 24, $2D, $1F
	sound_wait 24
	sound_instrument $09
	sound_note 12, $45, $15
	sound_wait 12
	sound_instrument $08
	sound_note 12, $2E, $1F
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_instrument $09
	sound_note 12, $46, $15
	sound_wait 24
	sound_ret
SoundSong0E_Track2_Sub1:: ; 05:411E
Data_05_411E::
	sound_instrument $08
	sound_note 24, $30, $1F
	sound_wait 24
	sound_instrument $09
	sound_note 12, $46, $15
	sound_wait 12
	sound_instrument $08
	sound_note 12, $24, $1F
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_instrument $09
	sound_note 12, $43, $15
	sound_wait 24
	sound_ret

; ---- data $4139-$4167 (46 bytes) [PROBABLE] interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md; read as data by executed code in up to 14 of 69 natural scenarios (45 of 46 bytes; traces/detail)

SoundSong0E_Track2_Sub2:: ; 05:4139
Data_05_4139::
	sound_instrument $08
	sound_note 24, $26, $1F
	sound_wait 24
	sound_instrument $09
	sound_note 12, $45, $15
	sound_wait 12
	sound_instrument $08
	sound_note 12, $2B, $1F
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_instrument $09
	sound_note 12, $46, $15
	sound_wait 24
	sound_ret
	sound_call SoundSong0E_Track2_Sub1
	sound_call SoundSong0E_Track2_Loop
	sound_call SoundSong0E_Track2_Sub1
	sound_call SoundSong0E_Track2_Sub2
	sound_call SoundSong0E_Track2_Sub1
	sound_jump SoundSong0E_Track2_Loop
SoundSong0E_Track2_AfterJump:: ; 05:4166
Data_05_4166::
	sound_end

; ---- data $4167-$41D0 (105 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong0E_Track3:: ; 05:4167
Data_05_4167::
	sound_volume $7F
	sound_pitch_add $00
SoundSong0E_Track3_Loop:: ; 05:416B
Data_05_416B::
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 6, $27, $11
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 6, $27, $11
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6, $27, $11
	sound_wait 12
	sound_rs sound_note 6, $2A, $0B
	sound_wait 6
	sound_note 3, $24
	sound_wait 6
	sound_pitch_bend $20
	sound_note 6, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 3
	sound_wait 6
SoundSong0E_Track3_Sub1:: ; 05:419F
Data_05_419F::
	sound_note 6, $27, $11
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 6, $27, $11
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6, $27, $11
	sound_wait 12
	sound_rs sound_note 6, $2A, $0B
	sound_wait 6
	sound_note 3, $24
	sound_wait 6
	sound_pitch_bend $20
	sound_note 6, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 3

; ---- data $41D0-$4218 (72 bytes) [PROBABLE] interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md; read as data by executed code in up to 14 of 69 natural scenarios (71 of 72 bytes; traces/detail)

Data_05_41D0:: ; 05:41D0
	sound_wait 6
	sound_ret
	sound_call SoundSong0E_Track3_Sub1
SoundSong0E_Track3_Sub2:: ; 05:41D5
Data_05_41D5::
	sound_note 6, $27, $11
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 6, $27, $11
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6, $27, $11
	sound_wait 12
	sound_rs sound_note 6, $2A, $0B
	sound_wait 6
	sound_note 3, $24
	sound_wait 6
	sound_pitch_bend $20
	sound_note 6, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6
	sound_wait 6
	sound_ret
	sound_call SoundSong0E_Track3_Sub1
	sound_call SoundSong0E_Track3_Sub1
	sound_call SoundSong0E_Track3_Sub1
	sound_call SoundSong0E_Track3_Sub2
	sound_jump SoundSong0E_Track3_Loop
SoundSong0E_Track3_AfterJump:: ; 05:4217
Data_05_4217::
	sound_end

; ---- data $4218-$421A (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 421A (12 words = NN*(KK+1)); the byte before (4217) is $B1

SoundSong0E_Header:: ; 05:4218
Data_05_4218::
	sound_stream_header 4, 2

; ---- words $421A-$4232 (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 4218 [v4: bytes 421A-4222 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

SoundSong0E_TrackPtrs:: ; 05:421A
Table_05_421A::
	dw SoundSong0E_Track0, SoundSong0E_Track1, SoundSong0E_Track2, SoundSong0E_Track3 ; track stream pointers (read by the driver)
	; not read by the driver: target of each track's final sound_jump
	dw SoundSong0E_Track0_Loop, SoundSong0E_Track1_Loop
	dw SoundSong0E_Track2_Loop, SoundSong0E_Track3_Loop
	; not read by the driver: address after each track's final sound_jump
	dw SoundSong0E_Track0_AfterJump, SoundSong0E_Track1_AfterJump
	dw SoundSong0E_Track2_AfterJump, SoundSong0E_Track3_AfterJump
