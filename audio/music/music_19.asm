; audio/music/music_19.asm
; bank 05, $5B06-$5DCF (713 bytes); pinned by layout.link
; song id 19

SECTION "audio/music/music_19", ROMX

; ---- data $5B06-$5B6D (103 bytes) [PROBABLE] read as data by executed code (in up to 18/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md) | block boundary $5B34 removed (it cut a command in two; its label Data_05_5B34 was not referenced); the second part was: data $5B34-$5B6D (57 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md (status of the merged block lowered to the weaker of the two parts)

SoundSong19_Track0:: ; 05:5B06
Data_05_5B06::
	sound_volume $7F
	sound_pitch_add $00
SoundSong19_Track0_Loop:: ; 05:5B0A
Data_05_5B0A::
	sound_tempo $2A
	sound_instrument $00
	sound_wait 8
	sound_note 4, $48, $12
	sound_wait 12
	sound_rs sound_note 4, $47
	sound_wait 4
	sound_note 8, $49
	sound_wait 8
	sound_note 4, $48
	sound_wait 4
	sound_note 8, $46
	sound_wait 8
	sound_note 4, $45
	sound_wait 4
	sound_rs sound_note 4, $48
	sound_wait 12
	sound_note 8
	sound_wait 8
	sound_note 12, $46
	sound_wait 28
	sound_wait 8
	sound_note 4, $44
	sound_wait 12
	sound_note 8
	sound_wait 4
	sound_note 4, $43
	sound_wait 12
	sound_note 4
	sound_wait 12
	sound_note 4, $41
	sound_wait 12
	sound_note 8, $3E
	sound_wait 8
	sound_note 12, $3F
	sound_wait 28
	sound_wait 8
	sound_note 4, $48
	sound_wait 12
	sound_rs sound_note 4, $47
	sound_wait 4
	sound_note 8, $49
	sound_wait 8
	sound_note 4, $48
	sound_wait 4
	sound_note 8, $46
	sound_wait 8
	sound_note 4, $45
	sound_wait 4
	sound_rs sound_note 4, $48
	sound_wait 12
	sound_note 8, $46
	sound_wait 8
	sound_note 12, $4D
	sound_wait 16
	sound_note 8, $41
	sound_wait 8
	sound_note 4, $42
	sound_wait 4
	sound_rs sound_note 4, $43
	sound_wait 20
	sound_rs sound_note 4, $3F
	sound_wait 4
	sound_note 8, $43
	sound_wait 8
	sound_note 4, $48
	sound_wait 12
	sound_note 12, $44
	sound_wait 52
	sound_jump SoundSong19_Track0_Loop
SoundSong19_Track0_AfterJump:: ; 05:5B6C
Data_05_5B6C::
	sound_end

; ---- data $5B6D-$5C4C (223 bytes) [PROBABLE] read as data by executed code (in up to 2/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md) | block boundary $5BCB removed (it cut a command in two; its label Data_05_5BCB was not referenced); the second part was: data $5BCB-$5C4C (129 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md (status of the merged block lowered to the weaker of the two parts)

SoundSong19_Track1:: ; 05:5B6D
Data_05_5B6D::
	sound_volume $7F
	sound_pitch_add $00
SoundSong19_Track1_Loop:: ; 05:5B71
Data_05_5B71::
	sound_instrument $05
	sound_wait 8
	sound_note 4, $3F, $0C
	sound_wait 4
	sound_instrument $04
	sound_note 5, $4B, $13
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 4, $3E, $0C
	sound_wait 4
	sound_note 8, $41
	sound_wait 8
	sound_note 4, $3F
	sound_wait 4
	sound_instrument $04
	sound_note 5, $44, $13
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 4, $3C, $0C
	sound_wait 4
	sound_rs sound_note 4, $3F
	sound_wait 12
	sound_instrument $04
	sound_note 5, $4A, $13
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 12, $3E, $0C
	sound_wait 16
	sound_instrument $04
	sound_note 5, $41, $13
	sound_wait 6
	sound_instrument $05
	sound_wait 6
	sound_wait 8
	sound_note 4, $3D, $0C
	sound_wait 4
	sound_instrument $04
	sound_note 5, $49, $13
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 4, $3D, $0C
	sound_wait 4
	sound_note 4
	sound_wait 12
	sound_instrument $04
	sound_note 5, $49, $13
	sound_wait 6
	sound_instrument $05
	sound_wait 6
	sound_note 4, $3C, $0C
	sound_wait 12
	sound_instrument $04
	sound_note 5, $48, $13
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 12, $3C, $0C
	sound_wait 16
	sound_instrument $04
	sound_note 5, $3F, $13
	sound_wait 6
	sound_instrument $05
	sound_wait 6
	sound_wait 8
	sound_note_vol 4, $0C
	sound_wait 4
	sound_instrument $04
	sound_note 5, $4B, $13
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 4, $3E, $0C
	sound_wait 4
	sound_note 8, $41
	sound_wait 8
	sound_note 4, $3F
	sound_wait 4
	sound_instrument $04
	sound_note 5, $44, $13
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 4, $3C, $0C
	sound_wait 4
	sound_rs sound_note 4, $3F
	sound_wait 12
	sound_instrument $04
	sound_note 5, $4A, $13
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 12, $46, $0C
	sound_wait 16
	sound_instrument $04
	sound_note 5, $41, $13
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 4, $3E, $0C
	sound_wait 4
	sound_rs sound_note 4, $3F
	sound_wait 12
	sound_instrument $04
	sound_note 5, $49, $13
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 4, $37, $0C
	sound_wait 4
	sound_note 8, $3F
	sound_wait 8
	sound_note 4
	sound_wait 4
	sound_instrument $04
	sound_note 5, $49, $13
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 12, $3C, $0C
	sound_wait 52
	sound_jump SoundSong19_Track1_Loop
SoundSong19_Track1_AfterJump:: ; 05:5C4B
Data_05_5C4B::
	sound_end

; ---- data $5C4C-$5D14 (200 bytes) [PROBABLE] read as data by executed code (in up to 2/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md) | block boundary $5C9E removed (it cut a command in two; its label Data_05_5C9E was not referenced); the second part was: data $5C9E-$5D14 (118 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md (status of the merged block lowered to the weaker of the two parts)

SoundSong19_Track2:: ; 05:5C4C
Data_05_5C4C::
	sound_volume $7F
	sound_pitch_add $F4
SoundSong19_Track2_Loop:: ; 05:5C50
Data_05_5C50::
	sound_instrument $08
	sound_note 6, $38, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 5, $50, $13
	sound_wait 6
	sound_instrument $08
	sound_wait 6
	sound_note 6, $33, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 5, $48, $13
	sound_wait 6
	sound_instrument $08
	sound_wait 6
	sound_note 6, $3A, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 5, $4D, $13
	sound_wait 6
	sound_instrument $08
	sound_wait 6
	sound_note 6, $35, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 5, $44, $13
	sound_wait 6
	sound_instrument $08
	sound_wait 6
	sound_note 6, $3F, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 5, $4B, $13
	sound_wait 6
	sound_instrument $08
	sound_wait 6
	sound_note 6, $33, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 5, $4B, $13
	sound_wait 6
	sound_instrument $08
	sound_wait 6
	sound_note 6, $38, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 5, $4B, $13
	sound_wait 6
	sound_instrument $08
	sound_wait 6
	sound_note 6, $33, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 5, $44, $13
	sound_wait 6
	sound_instrument $08
	sound_wait 6
	sound_note 6, $38, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 4, $50, $13
	sound_wait 6
	sound_instrument $08
	sound_wait 6
	sound_note 6, $33, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 4, $48, $13
	sound_wait 6
	sound_instrument $08
	sound_wait 6
	sound_note 6, $3A, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 4, $4D, $13
	sound_wait 6
	sound_instrument $08
	sound_wait 6
	sound_note 6, $35, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 4, $44, $13
	sound_wait 6
	sound_instrument $08
	sound_wait 6
	sound_note 6, $3F, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 5, $4F, $13
	sound_wait 6
	sound_instrument $08
	sound_wait 6
	sound_note 6, $33, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 5, $4F, $13
	sound_wait 12
	sound_instrument $08
	sound_note 5, $44
	sound_wait 12
	sound_note 6, $33, $1F
	sound_wait 12
	sound_rs sound_note 6, $2C
	sound_wait 24
	sound_jump SoundSong19_Track2_Loop
SoundSong19_Track2_AfterJump:: ; 05:5D13
Data_05_5D13::
	sound_end

; ---- data $5D14-$5DB5 (161 bytes) [PROBABLE] read as data by executed code (in up to 2/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md) | block boundary $5D69 removed (it cut a command in two; its label Data_05_5D69 was not referenced); the second part was: data $5D69-$5DB5 (76 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md (status of the merged block lowered to the weaker of the two parts)

SoundSong19_Track3:: ; 05:5D14
Data_05_5D14::
	sound_volume $7F
	sound_pitch_add $00
SoundSong19_Track3_Loop:: ; 05:5D18
Data_05_5D18::
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 4, $27, $0F
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 4, $27, $0F
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
SoundSong19_Track3_Sub1:: ; 05:5D4E
Data_05_5D4E::
	sound_note 4, $27, $0F
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 4, $27, $0F
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_ret
	sound_call SoundSong19_Track3_Sub1
	sound_note 4, $27, $0F
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 4, $27, $0F
	sound_wait 24
	sound_jump SoundSong19_Track3_Loop
SoundSong19_Track3_AfterJump:: ; 05:5DB4
Data_05_5DB4::
	sound_end

; ---- data $5DB5-$5DB7 (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 5DB7 (12 words = NN*(KK+1)); the byte before (5DB4) is $B1

SoundSong19_Header:: ; 05:5DB5
Data_05_5DB5::
	sound_stream_header 4, 2

; ---- words $5DB7-$5DCF (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 5DB5 [v4: bytes 5DB7-5DBF were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

SoundSong19_TrackPtrs:: ; 05:5DB7
Table_05_5DB7::
	dw SoundSong19_Track0, SoundSong19_Track1, SoundSong19_Track2, SoundSong19_Track3 ; track stream pointers (read by the driver)
	dw SoundSong19_Track0_Loop, SoundSong19_Track1_Loop, SoundSong19_Track2_Loop, SoundSong19_Track3_Loop ; not read by the driver: target of each track's final sound_jump
	dw SoundSong19_Track0_AfterJump, SoundSong19_Track1_AfterJump, SoundSong19_Track2_AfterJump, SoundSong19_Track3_AfterJump ; not read by the driver: address after each track's final sound_jump
