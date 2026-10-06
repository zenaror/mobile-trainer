; audio/music/music_12.asm
; bank 05, $4A2F-$4CA1 (626 bytes); pinned by layout.link
; song id 12

SECTION "audio/music/music_12", ROMX

; ---- data $4A2F-$4B30 (257 bytes) [CONFIRMED] read as data by executed code (in up to 6/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong12_Track0:: ; 05:4A2F
Data_05_4A2F::
	sound_volume $7F
	sound_pitch_add $00
SoundSong12_Track0_Loop:: ; 05:4A33
Data_05_4A33::
	sound_tempo $39
	sound_instrument $08
	sound_note 2, $4F, $10
	sound_wait 6
	sound_instrument $0B
	sound_note 4, $47, $16
	sound_wait 6
	sound_instrument $08
	sound_note 2, $5B, $10
	sound_wait 6
	sound_rs sound_note 2, $58
	sound_wait 6
	sound_instrument $0B
	sound_note 4, $47, $16
	sound_wait 6
	sound_instrument $08
	sound_note 2, $5B, $10
	sound_wait 6
	sound_rs sound_note 2, $54
	sound_wait 6
	sound_instrument $0B
	sound_note 4, $46, $16
	sound_wait 6
	sound_instrument $08
	sound_note 2, $59, $10
	sound_wait 6
	sound_rs sound_note 2, $4D
	sound_wait 6
	sound_instrument $0B
	sound_note 4, $46, $16
	sound_wait 6
	sound_instrument $08
	sound_note 2, $59, $10
	sound_wait 6
	sound_rs sound_note 2, $54
	sound_wait 6
	sound_rs sound_note 2, $4D
	sound_wait 6
	sound_instrument $0B
	sound_note 4, $46, $16
	sound_wait 6
	sound_instrument $08
	sound_note 2, $59, $10
	sound_wait 6
SoundSong12_Track0_Sub1:: ; 05:4A81
Data_05_4A81::
	sound_instrument $0B
	sound_note 4, $47, $16
	sound_wait 6
	sound_instrument $08
	sound_note 2, $5B, $10
	sound_wait 6
	sound_rs sound_note 2, $58
	sound_wait 6
	sound_rs sound_note 2, $5B
	sound_wait 6
	sound_instrument $0B
	sound_note 4, $47, $16
	sound_wait 6
	sound_instrument $08
	sound_note 2, $54, $10
	sound_wait 6
	sound_rs sound_note 2, $5B
	sound_wait 6
	sound_instrument $0B
	sound_note 4, $48, $16
	sound_wait 6
	sound_instrument $08
	sound_note 2, $58, $10
	sound_wait 6
	sound_rs sound_note 2, $50
	sound_wait 6
	sound_instrument $0B
	sound_note 4, $48, $16
	sound_wait 6
	sound_instrument $08
	sound_note 2, $5C, $10
	sound_wait 6
	sound_rs sound_note 2, $59
	sound_wait 6
	sound_instrument $0B
	sound_note 4, $48, $16
	sound_wait 6
	sound_instrument $08
	sound_note 2, $55, $10
	sound_wait 6
	sound_rs sound_note 2, $59
	sound_wait 6
	sound_ret
SoundSong12_Track0_Sub2:: ; 05:4ACA
Data_05_4ACA::
	sound_note 2, $4F, $10
	sound_wait 6
	sound_instrument $0B
	sound_note 4, $47, $16
	sound_wait 6
	sound_instrument $08
	sound_note 2, $5B, $10
	sound_wait 6
	sound_rs sound_note 2, $58
	sound_wait 6
	sound_instrument $0B
	sound_note 4, $47, $16
	sound_wait 6
	sound_instrument $08
	sound_note 2, $5B, $10
	sound_wait 6
	sound_rs sound_note 2, $54
	sound_wait 6
	sound_instrument $0B
	sound_note 4, $46, $16
	sound_wait 6
	sound_instrument $08
	sound_note 2, $59, $10
	sound_wait 6
	sound_rs sound_note 2, $4D
	sound_wait 6
	sound_instrument $0B
	sound_note 4, $46, $16
	sound_wait 6
	sound_instrument $08
	sound_note 2, $59, $10
	sound_wait 6
	sound_rs sound_note 2, $54
	sound_wait 6
	sound_rs sound_note 2, $4D
	sound_wait 6
	sound_instrument $0B
	sound_note 4, $46, $16
	sound_wait 6
	sound_instrument $08
	sound_note 2, $59, $10
	sound_wait 6
	sound_ret
	sound_call SoundSong12_Track0_Sub1
	sound_call SoundSong12_Track0_Sub2
	sound_call SoundSong12_Track0_Sub1
	sound_call SoundSong12_Track0_Sub2
	sound_instrument $0B
	sound_note 4, $47, $16
	sound_wait 42
	sound_rs sound_note 4, $48
	sound_wait 18
	sound_note 4
	sound_wait 18
	sound_note 4
	sound_wait 18
	sound_jump SoundSong12_Track0_Loop

; ---- data $4B30-$4B31 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md

SoundSong12_Track0_AfterJump:: ; 05:4B30
Data_05_4B30::
	sound_end

; ---- data $4B31-$4B7B (74 bytes) [CONFIRMED] read as data by executed code (in up to 6/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong12_Track1:: ; 05:4B31
Data_05_4B31::
	sound_volume $7F
	sound_pitch_add $00
SoundSong12_Track1_Loop:: ; 05:4B35
Data_05_4B35::
	sound_instrument $06
	sound_wait 6
	sound_note 4, $40, $15
	sound_wait 18
	sound_note 4
	sound_wait 18
	sound_note 4, $3F
	sound_wait 18
	sound_note 4
	sound_wait 24
	sound_note 4
	sound_wait 12
SoundSong12_Track1_Sub1:: ; 05:4B45
Data_05_4B45::
	sound_note 4, $40, $15
	sound_wait 24
	sound_note 4
	sound_wait 18
	sound_note 4, $41
	sound_wait 18
	sound_note 4
	sound_wait 18
	sound_note 4
	sound_wait 18
	sound_ret
SoundSong12_Track1_Sub2:: ; 05:4B53
Data_05_4B53::
	sound_wait 6
	sound_note 4, $40, $15
	sound_wait 18
	sound_note 4
	sound_wait 18
	sound_note 4, $3F
	sound_wait 18
	sound_note 4
	sound_wait 24
	sound_note 4
	sound_wait 12
	sound_ret
	sound_call SoundSong12_Track1_Sub1
	sound_call SoundSong12_Track1_Sub2
	sound_call SoundSong12_Track1_Sub1
	sound_call SoundSong12_Track1_Sub2
	sound_note 4, $40, $15
	sound_wait 42
	sound_rs sound_note 4, $41
	sound_wait 18
	sound_note 4
	sound_wait 18
	sound_note 4
	sound_wait 18
	sound_jump SoundSong12_Track1_Loop

; ---- data $4B7B-$4B7C (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md

SoundSong12_Track1_AfterJump:: ; 05:4B7B
Data_05_4B7B::
	sound_end

; ---- data $4B7C-$4BD9 (93 bytes) [CONFIRMED] read as data by executed code (in up to 6/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong12_Track2:: ; 05:4B7C
Data_05_4B7C::
	sound_volume $7F
	sound_pitch_add $00
SoundSong12_Track2_Loop:: ; 05:4B80
Data_05_4B80::
	sound_instrument $21
	sound_note 12, $24, $15
	sound_wait 18
	sound_note 6
	sound_wait 6
	sound_note 6, $30
	sound_wait 30
	sound_rs sound_note 6, $29
	sound_wait 12
	sound_note 4
	sound_wait 12
	sound_note 6, $27
	sound_wait 6
	sound_note 12, $29
	sound_wait 12
SoundSong12_Track2_Sub1:: ; 05:4B95
Data_05_4B95::
	sound_note 12, $24, $15
	sound_wait 18
	sound_note 6
	sound_wait 6
	sound_note 6, $30
	sound_wait 30
	sound_rs sound_note 6, $31
	sound_wait 12
	sound_note 4
	sound_wait 12
	sound_note 6, $2C
	sound_wait 6
	sound_note 12, $25
	sound_wait 12
	sound_ret
SoundSong12_Track2_Sub2:: ; 05:4BA9
Data_05_4BA9::
	sound_note 12, $24, $15
	sound_wait 18
	sound_note 6
	sound_wait 6
	sound_note 6, $30
	sound_wait 30
	sound_rs sound_note 6, $29
	sound_wait 12
	sound_note 4
	sound_wait 12
	sound_note 6, $27
	sound_wait 6
	sound_note 12, $29
	sound_wait 12
	sound_ret
	sound_call SoundSong12_Track2_Sub1
	sound_call SoundSong12_Track2_Sub2
	sound_call SoundSong12_Track2_Sub1
	sound_call SoundSong12_Track2_Sub2
	sound_note 12, $24, $15
	sound_wait 66
	sound_note 4, $31
	sound_wait 12
	sound_note 6, $2C
	sound_wait 6
	sound_note 12, $25
	sound_wait 12
	sound_jump SoundSong12_Track2_Loop

; ---- data $4BD9-$4BDA (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md

SoundSong12_Track2_AfterJump:: ; 05:4BD9
Data_05_4BD9::
	sound_end

; ---- data $4BDA-$4C86 (172 bytes) [CONFIRMED] read as data by executed code (in up to 6/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong12_Track3:: ; 05:4BDA
Data_05_4BDA::
	sound_volume $7F
	sound_pitch_add $00
SoundSong12_Track3_Loop:: ; 05:4BDE
Data_05_4BDE::
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 4, $27, $11
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note_vol 12, $0D
	sound_wait 12
	sound_note 6, $2A, $0F
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_pitch_bend $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 4, $27, $11
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note_vol 12, $0D
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 6, $2A, $0F
	sound_wait 6
SoundSong12_Track3_Sub1:: ; 05:4C1E
Data_05_4C1E::
	sound_note 4, $27, $11
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note_vol 12, $0D
	sound_wait 12
	sound_note 6, $2A, $0F
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_pitch_bend $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 4, $27, $11
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note_vol 12, $0D
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 6, $2A, $0F
	sound_wait 6
	sound_ret
	sound_call SoundSong12_Track3_Sub1
	sound_call SoundSong12_Track3_Sub1
	sound_call SoundSong12_Track3_Sub1
	sound_call SoundSong12_Track3_Sub1
	sound_call SoundSong12_Track3_Sub1
	sound_note 4, $27, $11
	sound_wait 48
	sound_note 3, $2E, $03
	sound_wait 6
	sound_rs sound_note_vol 3, $06
	sound_wait 6
	sound_rs sound_note_vol 3, $09
	sound_wait 6
	sound_rs sound_note_vol 3, $0C
	sound_wait 6
	sound_rs sound_note_vol 3, $0F
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 6, $2D
	sound_wait 6
	sound_rs sound_note 6, $2C
	sound_wait 6
	sound_jump SoundSong12_Track3_Loop

; ---- data $4C86-$4C87 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md

SoundSong12_Track3_AfterJump:: ; 05:4C86
Data_05_4C86::
	sound_end

; ---- data $4C87-$4C89 (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 4C89 (12 words = NN*(KK+1)); the byte before (4C86) is $B1

SoundSong12_Header:: ; 05:4C87
Data_05_4C87::
	sound_stream_header 4, 2

; ---- words $4C89-$4CA1 (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 4C87 [v4: bytes 4C89-4C91 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

SoundSong12_TrackPtrs:: ; 05:4C89
Table_05_4C89::
	dw SoundSong12_Track0, SoundSong12_Track1, SoundSong12_Track2, SoundSong12_Track3 ; track stream pointers (read by the driver)
	dw SoundSong12_Track0_Loop, SoundSong12_Track1_Loop, SoundSong12_Track2_Loop, SoundSong12_Track3_Loop ; not read by the driver: target of each track's final sound_jump
	dw SoundSong12_Track0_AfterJump, SoundSong12_Track1_AfterJump, SoundSong12_Track2_AfterJump, SoundSong12_Track3_AfterJump ; not read by the driver: address after each track's final sound_jump
