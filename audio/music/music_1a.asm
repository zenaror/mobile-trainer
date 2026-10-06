; audio/music/music_1a.asm
; bank 05, $5DCF-$60E9 (794 bytes); pinned by layout.link
; song id 1A

SECTION "audio/music/music_1a", ROMX

; ---- data $5DCF-$5E23 (84 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong1A_Track0:: ; 05:5DCF
Data_05_5DCF::
	sound_volume $7F
	sound_pitch_add $00
SoundSong1A_Track0_Loop:: ; 05:5DD3
Data_05_5DD3::
	sound_tempo $39
	sound_instrument $52
	sound_vibrato_depth $10
	sound_vibrato_rate $20
	sound_vibrato_delay $1E
	sound_note 60, $47, $18
	sound_wait 60
	sound_note 12, $49, $19
	sound_wait 12
	sound_note 8, $47
	sound_wait 12
	sound_note 72
	sound_wait 12
	sound_wait 60
	sound_note 12, $49
	sound_wait 12
	sound_rs sound_note 12, $4B
	sound_wait 12
	sound_note 72, $4C
	sound_wait 12
	sound_wait 60
	sound_note 12, $4B
	sound_wait 12
	sound_rs sound_note 12, $49
	sound_wait 12
	sound_note 36, $4B
	sound_wait 12
	sound_wait 24
	sound_note 12, $4C
	sound_wait 12
	sound_rs sound_note 12, $4B
	sound_wait 24
	sound_rs sound_note 12, $49
	sound_wait 24
	sound_note 72, $47
	sound_wait 12
	sound_wait 60
	sound_note 12, $49
	sound_wait 12
	sound_rs sound_note 12, $4B
	sound_wait 12
	sound_note 48, $49
	sound_wait 12
	sound_wait 36
	sound_note 36, $44
	sound_wait 36
	sound_note 24, $49
	sound_wait 24
	sound_note 60, $47
	sound_wait 60
	sound_note 12, $44
	sound_wait 12
	sound_rs sound_note 12, $46
	sound_wait 12
	sound_note 36, $47
	sound_wait 12
	sound_wait 24

; ---- data $5E23-$5E37 (20 bytes) [PROBABLE] interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md; read as data by executed code in up to 7 of 69 natural scenarios (19 of 20 bytes; traces/detail)

Data_05_5E23:: ; 05:5E23
	sound_note 24, $46
	sound_wait 24
	sound_note 12, $44
	sound_wait 12
	sound_note 24, $46
	sound_wait 24
	sound_note 0, $47
	sound_wait 12
	sound_wait 96
	sound_wait 60
	sound_note_off
	sound_wait 36
	sound_jump SoundSong1A_Track0_Loop
SoundSong1A_Track0_AfterJump:: ; 05:5E36
Data_05_5E36::
	sound_end

; ---- data $5E37-$5F67 (304 bytes) [PROBABLE] read as data by executed code (in up to 1/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md) | block boundary $5F09 removed (it cut a command in two; its label Data_05_5F09 was not referenced); the second part was: data $5F09-$5F67 (94 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md (status of the merged block lowered to the weaker of the two parts)

SoundSong1A_Track1:: ; 05:5E37
Data_05_5E37::
	sound_volume $7F
	sound_pitch_add $00
SoundSong1A_Track1_Loop:: ; 05:5E3B
Data_05_5E3B::
	sound_instrument $05
	sound_note 24, $44, $0C
	sound_wait 24
	sound_instrument $04
	sound_note 12, $4C, $12
	sound_wait 12
	sound_instrument $05
	sound_note 24, $40, $0C
	sound_wait 24
	sound_note 12, $47
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4C, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $3B, $0C
	sound_wait 12
	sound_rs sound_note 12, $42
	sound_wait 12
	sound_rs sound_note 12, $3B
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4B, $12
	sound_wait 12
	sound_instrument $05
	sound_note 24, $42, $0C
	sound_wait 24
	sound_note 12, $47
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4E, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $42, $0C
	sound_wait 12
	sound_note 24, $44
	sound_wait 24
	sound_instrument $04
	sound_note 12, $49, $12
	sound_wait 12
	sound_instrument $05
	sound_note 24, $40, $0C
	sound_wait 24
	sound_note 12, $49
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4C, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $42, $0C
	sound_wait 12
	sound_rs sound_note 12, $47
	sound_wait 12
	sound_rs sound_note 12, $3F
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4E, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $47, $0C
	sound_wait 24
	sound_rs sound_note 12, $46
	sound_wait 24
	sound_instrument $05
	sound_note 36, $44
	sound_wait 12
	sound_wait 24
	sound_instrument $04
	sound_note 12, $4B, $12
	sound_wait 12
	sound_instrument $05
	sound_note 24, $3F, $0C
	sound_wait 24
	sound_note 12, $47
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4B, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $3B, $0C
	sound_wait 12
	sound_note 24, $3D
	sound_wait 24
	sound_instrument $04
	sound_note 12, $4D, $12
	sound_wait 12
	sound_instrument $05
	sound_note 24, $41, $0C
	sound_wait 24
	sound_note 12, $49
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4D, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $41, $0C
	sound_wait 12
	sound_note 24, $44
	sound_wait 24
	sound_instrument $04
	sound_note 12, $4C, $12
	sound_wait 12
	sound_instrument $05
	sound_note 24, $40, $0C
	sound_wait 24
	sound_note 12, $38
	sound_wait 12
	sound_instrument $04
	sound_note 12, $47, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $3B, $0C
	sound_wait 12
	sound_note 24, $44
	sound_wait 24
	sound_instrument $04
	sound_note 12, $4C, $12
	sound_wait 12
	sound_instrument $05
	sound_note 24, $40, $0C
	sound_wait 24
	sound_note 12, $49
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4C, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $40, $0C
	sound_wait 12
	sound_rs sound_note 12, $47
	sound_wait 12
	sound_rs sound_note 12, $3D
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4C, $12
	sound_wait 12
	sound_instrument $05
	sound_note 24, $40, $0C
	sound_wait 24
	sound_note 12, $45
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4C, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $3D, $0C
	sound_wait 12
	sound_rs sound_note 12, $3F
	sound_wait 12
	sound_rs sound_note 12, $3B
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4B, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $40, $0C
	sound_wait 24
	sound_rs sound_note 12, $42
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4E, $12
	sound_wait 12
	sound_instrument $05
	sound_note 12, $3B, $0C
	sound_wait 12
	sound_jump SoundSong1A_Track1_Loop
SoundSong1A_Track1_AfterJump:: ; 05:5F66
Data_05_5F66::
	sound_end

; ---- data $5F67-$602A (195 bytes) [PROBABLE] read as data by executed code (in up to 1/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md) | block boundary $5FF1 removed (it cut a command in two; its label Data_05_5FF1 was not referenced); the second part was: data $5FF1-$602A (57 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md (status of the merged block lowered to the weaker of the two parts)

SoundSong1A_Track2:: ; 05:5F67
Data_05_5F67::
	sound_volume $7F
	sound_pitch_add $00
SoundSong1A_Track2_Loop:: ; 05:5F6B
Data_05_5F6B::
	sound_instrument $20
	sound_note 24, $28, $19
	sound_wait 24
	sound_note 12, $44, $12
	sound_wait 12
	sound_note 8, $2F, $19
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_note 12, $44, $12
	sound_wait 12
	sound_rs sound_note 12, $34, $19
	sound_wait 12
	sound_note 24, $33
	sound_wait 24
	sound_note 12, $42, $12
	sound_wait 12
	sound_note 8, $2F, $19
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_note 12, $47, $12
	sound_wait 24
	sound_note 24, $31, $19
	sound_wait 24
	sound_note 12, $40, $12
	sound_wait 12
	sound_note 8, $2A, $19
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_note 24, $46, $12
	sound_wait 12
	sound_note 12, $2A
	sound_wait 12
	sound_note 36, $2F, $19
	sound_wait 24
	sound_note 12, $42, $12
	sound_wait 12
	sound_rs sound_note 12, $2F, $19
	sound_wait 24
	sound_rs sound_note 12, $2E
	sound_wait 24
	sound_note 36, $2C
	sound_wait 12
	sound_wait 24
	sound_note 12, $44, $12
	sound_wait 12
	sound_note 8, $33, $19
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_note 12, $44, $12
	sound_wait 12
	sound_rs sound_note 12, $2C, $19
	sound_wait 12
	sound_note 24, $31
	sound_wait 24
	sound_note 12, $44, $12
	sound_wait 12
	sound_note 8, $2C, $19
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_note 12, $44, $12
	sound_wait 24
	sound_note 24, $2A, $19
	sound_wait 24
	sound_note 12, $44, $12
	sound_wait 12
	sound_note 8, $2A, $19
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_note 12, $40, $12
	sound_wait 12
	sound_rs sound_note 12, $25, $19
	sound_wait 12
	sound_note 24, $2A
	sound_wait 24
	sound_note 12, $44, $12
	sound_wait 12
	sound_note 8, $36, $19
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_note 12, $44, $12
	sound_wait 24
	sound_note 24, $2F, $19
	sound_wait 24
	sound_note 12, $45, $12
	sound_wait 12
	sound_note 8, $2A, $19
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_note 12, $45, $12
	sound_wait 12
	sound_rs sound_note 12, $2A, $19
	sound_wait 12
	sound_note 24, $2F
	sound_wait 24
	sound_note 12, $42, $12
	sound_wait 12
	sound_rs sound_note 12, $31, $19
	sound_wait 24
	sound_rs sound_note 12, $33
	sound_wait 12
	sound_note 12, $47, $12
	sound_wait 24
	sound_jump SoundSong1A_Track2_Loop
SoundSong1A_Track2_AfterJump:: ; 05:6029
Data_05_6029::
	sound_end

; ---- data $602A-$609A (112 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong1A_Track3:: ; 05:602A
Data_05_602A::
	sound_volume $7F
	sound_pitch_add $00
SoundSong1A_Track3_Loop:: ; 05:602E
Data_05_602E::
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 6, $27, $0F
	sound_wait 12
	sound_note 4, $24, $0B
	sound_wait 12
	sound_pitch_bend $28
	sound_note 6, $2F, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 6, $27, $0F
	sound_wait 6
	sound_note 4, $24, $09
	sound_wait 6
	sound_note 6, $27, $0F
	sound_wait 12
	sound_note 4, $24, $0B
	sound_wait 12
	sound_pitch_bend $28
	sound_note 6, $2F, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 12, $24
	sound_wait 12
SoundSong1A_Track3_Sub1:: ; 05:605D
Data_05_605D::
	sound_note 6, $27, $0F
	sound_wait 12
	sound_note 4, $24, $0B
	sound_wait 12
	sound_pitch_bend $28
	sound_note 6, $2F, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 6, $27, $0F
	sound_wait 6
	sound_note 4, $24, $09
	sound_wait 6
	sound_note 6, $27, $0F
	sound_wait 12
	sound_note 4, $24, $0B
	sound_wait 12
	sound_pitch_bend $28
	sound_note 6, $2F, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 12, $24
	sound_wait 12
	sound_ret
	sound_call SoundSong1A_Track3_Sub1
	sound_call SoundSong1A_Track3_Sub1
	sound_call SoundSong1A_Track3_Sub1
	sound_call SoundSong1A_Track3_Sub1
	sound_call SoundSong1A_Track3_Sub1

; ---- data $609A-$60CF (53 bytes) [PROBABLE] interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md; read as data by executed code in up to 7 of 69 natural scenarios (52 of 53 bytes; traces/detail)

Data_05_609A:: ; 05:609A
	sound_call SoundSong1A_Track3_Sub1
	sound_call SoundSong1A_Track3_Sub1
	sound_note 6, $27, $0F
	sound_wait 12
	sound_note 4, $24, $0B
	sound_wait 12
	sound_pitch_bend $28
	sound_note 6, $2F, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 4, $24, $0B
	sound_wait 12
	sound_note 6, $27, $0F
	sound_wait 12
	sound_pitch_bend $28
	sound_note 6, $2F, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_rs sound_pitch_bend $28
	sound_note 6
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 12, $24
	sound_wait 12
	sound_jump SoundSong1A_Track3_Loop
SoundSong1A_Track3_AfterJump:: ; 05:60CE
Data_05_60CE::
	sound_end

; ---- data $60CF-$60D1 (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 60D1 (12 words = NN*(KK+1)); the byte before (60CE) is $B1

SoundSong1A_Header:: ; 05:60CF
Data_05_60CF::
	sound_stream_header 4, 2

; ---- words $60D1-$60E9 (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 60CF [v4: bytes 60D1-60D9 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

SoundSong1A_TrackPtrs:: ; 05:60D1
Table_05_60D1::
	dw SoundSong1A_Track0, SoundSong1A_Track1, SoundSong1A_Track2, SoundSong1A_Track3 ; track stream pointers (read by the driver)
	dw SoundSong1A_Track0_Loop, SoundSong1A_Track1_Loop, SoundSong1A_Track2_Loop, SoundSong1A_Track3_Loop ; not read by the driver: target of each track's final sound_jump
	dw SoundSong1A_Track0_AfterJump, SoundSong1A_Track1_AfterJump, SoundSong1A_Track2_AfterJump, SoundSong1A_Track3_AfterJump ; not read by the driver: address after each track's final sound_jump
