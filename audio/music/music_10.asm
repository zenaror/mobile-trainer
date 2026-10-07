; audio/music/music_10.asm
; bank 05, $455A-$4700 (422 bytes); pinned by layout.link
; song id 10

SECTION "audio/music/music_10", ROMX

; ---- data $455A-$45A4 (74 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong10_Track0:: ; 05:455A
Data_05_455A::
	sound_volume $7F
	sound_pitch_add $00
SoundSong10_Track0_Loop:: ; 05:455E
Data_05_455E::
	sound_tempo $48
	sound_instrument $27
	sound_vibrato_depth $0E
	sound_vibrato_rate $20
	sound_vibrato_delay $10
	sound_wait 24
	sound_pitch_bend $2C
	sound_note 16, $4C, $15
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 15
	sound_note 8, $45
	sound_wait 8
	sound_rs sound_note 8, $4C
	sound_wait 48
	sound_wait 24
	sound_pitch_bend $2C
	sound_note 16, $4E
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 15
	sound_note 8, $44
	sound_wait 8
	sound_rs sound_note 8, $4E
	sound_wait 48
	sound_wait 24
	sound_rs sound_note 8, $4C
	sound_wait 24
	sound_note 16
	sound_wait 16
	sound_note 8, $4E
	sound_wait 8
	sound_note 16, $50
	sound_wait 16
	sound_pitch_bend $2C
	sound_note 8, $51
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_wait 16
	sound_note 8, $50
	sound_wait 24
	sound_rs sound_note 8, $4C
	sound_wait 24
	sound_note 32, $4E
	sound_wait 32
	sound_jump SoundSong10_Track0_Loop

; ---- data $45A4-$45A5 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md

SoundSong10_Track0_AfterJump:: ; 05:45A4
Data_05_45A4::
	sound_end

; ---- data $45A5-$461A (117 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong10_Track1:: ; 05:45A5
Data_05_45A5::
	sound_volume $7F
	sound_pitch_add $00
SoundSong10_Track1_Loop:: ; 05:45A9
Data_05_45A9::
	sound_instrument $06
	sound_note 6, $40, $0E
	sound_wait 24
	sound_instrument $04
	sound_note 8, $3D, $15
	sound_wait 16
	sound_instrument $06
	sound_note_vol 6, $0E
	sound_wait 8
	sound_note 6, $49
	sound_wait 16
	sound_rs sound_note 6, $39
	sound_wait 8
	sound_instrument $04
	sound_note 8, $3D, $15
	sound_wait 24
	sound_instrument $06
	sound_note 6, $42, $0E
	sound_wait 24
	sound_instrument $04
	sound_note 8, $3F, $15
	sound_wait 16
	sound_instrument $06
	sound_note_vol 6, $0E
	sound_wait 8
	sound_note 6, $48
	sound_wait 16
	sound_rs sound_note 6, $38
	sound_wait 8
	sound_instrument $04
	sound_note 8, $3F, $15
	sound_wait 24
	sound_instrument $06
	sound_note 6, $44, $0E
	sound_wait 24
	sound_instrument $04
	sound_note_vol 8, $15
	sound_wait 16
	sound_instrument $06
	sound_note 6, $40, $0E
	sound_wait 8
	sound_rs sound_note 6, $49
	sound_wait 16
	sound_rs sound_note 6, $38
	sound_wait 8
	sound_instrument $04
	sound_note 8, $40, $15
	sound_wait 24
	sound_instrument $06
	sound_note 6, $42, $0E
	sound_wait 24
	sound_instrument $04
	sound_note_vol 8, $15
	sound_wait 16
	sound_instrument $06
	sound_note 6, $3E, $0E
	sound_wait 8
	sound_rs sound_note 6, $4A
	sound_wait 16
	sound_rs sound_note 6, $39
	sound_wait 8
	sound_instrument $04
	sound_note 24, $42, $15
	sound_wait 24
	sound_jump SoundSong10_Track1_Loop

; ---- data $461A-$461B (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md

SoundSong10_Track1_AfterJump:: ; 05:461A
Data_05_461A::
	sound_end

; ---- data $461B-$466C (81 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong10_Track2:: ; 05:461B
Data_05_461B::
	sound_volume $7F
	sound_pitch_add $F4
SoundSong10_Track2_Loop:: ; 05:461F
Data_05_461F::
	sound_instrument $09
	sound_note 8, $39, $1F
	sound_wait 24
	sound_rs sound_note 8, $51, $15
	sound_wait 16
	sound_rs sound_note 8, $34, $1F
	sound_wait 8
	sound_note 16, $39
	sound_wait 16
	sound_note 8
	sound_wait 8
	sound_note 8, $51, $15
	sound_wait 24
	sound_rs sound_note 8, $38, $1F
	sound_wait 24
	sound_rs sound_note 8, $54, $15
	sound_wait 16
	sound_rs sound_note 8, $33, $1F
	sound_wait 8
	sound_note 16, $38
	sound_wait 16
	sound_note 8
	sound_wait 8
	sound_note 8, $54, $15
	sound_wait 24
	sound_rs sound_note 8, $31, $1F
	sound_wait 24
	sound_rs sound_note 8, $55, $15
	sound_wait 16
	sound_rs sound_note 8, $38, $1F
	sound_wait 8
	sound_note 16, $31
	sound_wait 16
	sound_note 8
	sound_wait 8
	sound_note 8, $55
	sound_wait 24
	sound_rs sound_note 8, $2F
	sound_wait 24
	sound_note 8, $56, $15
	sound_wait 16
	sound_rs sound_note 8, $2F, $1F
	sound_wait 8
	sound_note 16, $34
	sound_wait 16
	sound_note 8
	sound_wait 8
	sound_note 24, $56, $15
	sound_wait 24
	sound_jump SoundSong10_Track2_Loop

; ---- data $466C-$466D (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md

SoundSong10_Track2_AfterJump:: ; 05:466C
Data_05_466C::
	sound_end

; ---- data $466D-$46E5 (120 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong10_Track3:: ; 05:466D
Data_05_466D::
	sound_volume $7F
	sound_pitch_add $00
SoundSong10_Track3_Loop:: ; 05:4671
Data_05_4671::
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 4, $27, $11
	sound_wait 24
	sound_note 6, $2F, $0F
	sound_wait 16
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 4, $27, $11
	sound_wait 16
	sound_note 4
	sound_wait 8
	sound_note 6, $2F, $0F
	sound_wait 16
	sound_note 4, $24, $0B
	sound_wait 8
	sound_rs sound_note 4, $27, $11
	sound_wait 24
	sound_note 6, $2F, $0F
	sound_wait 16
	sound_note 4, $27, $11
	sound_wait 8
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 8
	sound_note 4, $27, $11
	sound_wait 8
	sound_note 6, $2F, $0F
	sound_wait 16
	sound_note 8, $24, $0B
	sound_wait 8
	sound_note 4, $27, $11
	sound_wait 24
	sound_note 6, $2F, $0F
	sound_wait 16
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 4, $27, $11
	sound_wait 16
	sound_note 4
	sound_wait 8
	sound_note 6, $2F, $0F
	sound_wait 16
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 4, $27, $11
	sound_wait 24
	sound_note 6, $2F, $0F
	sound_wait 16
	sound_note 4, $27, $11
	sound_wait 8
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 8
	sound_note 4, $27, $11
	sound_wait 8
	sound_note 6, $2F, $0F
	sound_wait 16
	sound_note 8, $24, $0D
	sound_wait 8
	sound_jump SoundSong10_Track3_Loop

; ---- data $46E5-$46E6 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md

SoundSong10_Track3_AfterJump:: ; 05:46E5
Data_05_46E5::
	sound_end

; ---- data $46E6-$46E8 (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 46E8 (12 words = NN*(KK+1)); the byte before (46E5) is $B1

SoundSong10_Header:: ; 05:46E6
Data_05_46E6::
	sound_stream_header 4, 2

; ---- words $46E8-$4700 (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 46E6 [v4: bytes 46E8-46F0 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

SoundSong10_TrackPtrs:: ; 05:46E8
Table_05_46E8::
	dw SoundSong10_Track0, SoundSong10_Track1, SoundSong10_Track2, SoundSong10_Track3 ; track stream pointers (read by the driver)
	; not read by the driver: target of each track's final sound_jump
	dw SoundSong10_Track0_Loop, SoundSong10_Track1_Loop
	dw SoundSong10_Track2_Loop, SoundSong10_Track3_Loop
	; not read by the driver: address after each track's final sound_jump
	dw SoundSong10_Track0_AfterJump, SoundSong10_Track1_AfterJump
	dw SoundSong10_Track2_AfterJump, SoundSong10_Track3_AfterJump
