; audio/music/music_11.asm
; bank 05, $4700-$4A2F (815 bytes); pinned by layout.link
; song id 11

SECTION "audio/music/music_11", ROMX

; ---- data $4700-$4766 (102 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong11_Track0:: ; 05:4700
Data_05_4700::
	sound_volume $7F
	sound_pitch_add $00
SoundSong11_Track0_Loop:: ; 05:4704
Data_05_4704::
	sound_tempo $47
	sound_instrument $24
	sound_vibrato_depth $18
	sound_vibrato_rate $1C
	sound_vibrato_delay $20
	sound_note 96, $43, $13
	sound_wait 96
SoundSong11_Track0_Sub1:: ; 05:4712
Data_05_4712::
	sound_note 36, $46, $13
	sound_wait 36
	sound_rs sound_note 36, $44
	sound_wait 36
	sound_rs sound_note 36, $43
	sound_wait 24
	sound_ret
	sound_note 96, $41
	sound_wait 84
	sound_instrument $20
	sound_note 4, $44, $10
	sound_wait 6
	sound_rs sound_note 4, $50
	sound_wait 6
	sound_rs sound_note 4, $55
	sound_wait 6
	sound_note_vol 4, $06
	sound_wait 6
	sound_note 4, $49, $10
	sound_wait 6
	sound_rs sound_note_vol 4, $06
	sound_wait 6
	sound_note 4, $4D, $10
	sound_wait 6
	sound_rs sound_note_vol 4, $06
	sound_wait 6
	sound_note 4, $54, $10
	sound_wait 6
	sound_rs sound_note_vol 4, $06
	sound_wait 6
	sound_note 4, $49, $10
	sound_wait 6
	sound_rs sound_note_vol 4, $06
	sound_wait 6
	sound_note 4, $4D, $10
	sound_wait 6
	sound_rs sound_note_vol 4, $06
	sound_wait 6
	sound_note 4, $50, $10
	sound_wait 6
	sound_rs sound_note_vol 4, $06
	sound_wait 6
	sound_note 4, $49, $10
	sound_wait 6
	sound_rs sound_note_vol 4, $06
	sound_wait 6
	sound_instrument $24
	sound_note 96, $43, $13
	sound_wait 96
	sound_call SoundSong11_Track0_Sub1
	sound_note 0, $42, $13
	sound_wait 96
	sound_wait 96
	sound_jump SoundSong11_Track0_Loop

; ---- data $4766-$4769 (3 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md

SoundSong11_Track0_AfterJump:: ; 05:4766
Data_05_4766::
	sound_note_off $42
	sound_end

; ---- data $4769-$48D3 (362 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong11_Track1:: ; 05:4769
Data_05_4769::
	sound_volume $7F
	sound_pitch_add $00
SoundSong11_Track1_Loop:: ; 05:476D
Data_05_476D::
	sound_instrument $06
	sound_note 4, $3F, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $43, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_instrument $04
	sound_note 12, $46, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $3F, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $4B, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $43, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_instrument $04
	sound_note 12, $46, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $43, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
SoundSong11_Track1_Sub1:: ; 05:47A3
Data_05_47A3::
	sound_wait 12
	sound_note 4, $46, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_instrument $04
	sound_note 12, $3F, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $43, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $4B, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $3F, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_instrument $04
	sound_note 12, $46, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $4B, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_ret
	sound_note 4, $3D, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $41, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_instrument $04
	sound_note 12, $44, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $41, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $49, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $41, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_instrument $04
	sound_note 12, $44, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $3D, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_wait 12
	sound_note 4, $41, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_instrument $04
	sound_note 12, $44, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $41, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $49, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $3D, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_instrument $04
	sound_note 12, $49, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $41, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $3F, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $43, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_instrument $04
	sound_note 12, $46, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $3F, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $4B, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $43, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_instrument $04
	sound_note 12, $46, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $43, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_call SoundSong11_Track1_Sub1
	sound_note 4, $3E, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $42, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_instrument $04
	sound_note 12, $45, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $42, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $4A, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $42, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_instrument $04
	sound_note 12, $45, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $3E, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_wait 12
	sound_note 4, $42, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_instrument $04
	sound_note 12, $45, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $42, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $4A, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $3E, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_instrument $04
	sound_note 12, $4A, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $42, $11
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_jump SoundSong11_Track1_Loop

; ---- data $48D3-$48D4 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md

SoundSong11_Track1_AfterJump:: ; 05:48D3
Data_05_48D3::
	sound_end

; ---- data $48D4-$4990 (188 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong11_Track2:: ; 05:48D4
Data_05_48D4::
	sound_volume $7F
	sound_pitch_add $00
SoundSong11_Track2_Loop:: ; 05:48D8
Data_05_48D8::
	sound_instrument $08
	sound_note 24, $27, $1D
	sound_wait 24
	sound_instrument $09
	sound_note 12, $3F, $15
	sound_wait 12
	sound_instrument $08
	sound_note 6, $2E, $1D
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_instrument $09
	sound_note 12, $3F, $15
	sound_wait 24
	sound_ret
SoundSong11_Track2_Sub1:: ; 05:48F3
Data_05_48F3::
	sound_instrument $08
	sound_note 3, $52, $13
	sound_wait 6
	sound_rs sound_note 3, $5B
	sound_wait 6
	sound_rs sound_note 3, $4F
	sound_wait 6
	sound_rs sound_note 3, $57
	sound_wait 6
	sound_instrument $09
	sound_note 12, $37, $15
	sound_wait 12
	sound_instrument $08
	sound_note 3, $4F, $13
	sound_wait 6
	sound_rs sound_note 3, $57
	sound_wait 6
	sound_rs sound_note 3, $4B
	sound_wait 6
	sound_rs sound_note 3, $52
	sound_wait 6
	sound_rs sound_note 3, $46
	sound_wait 6
	sound_rs sound_note 3, $4F
	sound_wait 6
	sound_instrument $09
	sound_note 12, $3F, $15
	sound_wait 12
	sound_instrument $08
	sound_note 12, $33, $1D
	sound_wait 12
	sound_ret
	sound_note 24, $31
	sound_wait 24
	sound_instrument $09
	sound_note 12, $3D, $15
	sound_wait 12
	sound_instrument $08
	sound_note 6, $2C, $1D
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_instrument $09
	sound_note 12, $3D, $15
	sound_wait 24
	sound_wait 12
	sound_instrument $08
	sound_note 8, $31, $1D
	sound_wait 12
	sound_instrument $09
	sound_note 12, $3D, $15
	sound_wait 12
	sound_instrument $08
	sound_note 8, $31, $1D
	sound_wait 24
	sound_note 12
	sound_wait 12
	sound_instrument $09
	sound_note 12, $41, $15
	sound_wait 24
	sound_call SoundSong11_Track2_Loop
	sound_call SoundSong11_Track2_Sub1
	sound_note 24, $32, $1D
	sound_wait 24
	sound_instrument $09
	sound_note 12, $3E, $15
	sound_wait 12
	sound_instrument $08
	sound_note 6, $2D, $1D
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_instrument $09
	sound_note 12, $3E, $15
	sound_wait 24
	sound_wait 12
	sound_instrument $08
	sound_note 8, $32, $1D
	sound_wait 12
	sound_instrument $09
	sound_note 12, $3E, $15
	sound_wait 12
	sound_instrument $08
	sound_note 8, $32, $1D
	sound_wait 24
	sound_note 12
	sound_wait 12
	sound_instrument $09
	sound_note 12, $42, $15
	sound_wait 24
	sound_jump SoundSong11_Track2_Loop

; ---- data $4990-$4991 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md

SoundSong11_Track2_AfterJump:: ; 05:4990
Data_05_4990::
	sound_end

; ---- data $4991-$4A14 (131 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong11_Track3:: ; 05:4991
Data_05_4991::
	sound_volume $7F
	sound_pitch_add $00
SoundSong11_Track3_Loop:: ; 05:4995
Data_05_4995::
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 6, $27, $11
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 32
	sound_wait 3
	sound_note 6, $27, $11
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 12
SoundSong11_Track3_Sub1:: ; 05:49BA
Data_05_49BA::
	sound_note 6, $27, $11
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 32
	sound_wait 3
	sound_note 6, $27, $11
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 12
	sound_ret
	sound_call SoundSong11_Track3_Sub1
SoundSong11_Track3_Sub2:: ; 05:49E1
Data_05_49E1::
	sound_note 6, $27, $11
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 32
	sound_wait 3
	sound_note 6, $27, $11
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 12, $24, $0B
	sound_wait 12
	sound_ret
	sound_call SoundSong11_Track3_Sub1
	sound_call SoundSong11_Track3_Sub1
	sound_call SoundSong11_Track3_Sub1
	sound_call SoundSong11_Track3_Sub2
	sound_jump SoundSong11_Track3_Loop

; ---- data $4A14-$4A15 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md

SoundSong11_Track3_AfterJump:: ; 05:4A14
Data_05_4A14::
	sound_end

; ---- data $4A15-$4A17 (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 4A17 (12 words = NN*(KK+1)); the byte before (4A14) is $B1

SoundSong11_Header:: ; 05:4A15
Data_05_4A15::
	sound_stream_header 4, 2

; ---- words $4A17-$4A2F (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 4A15 [v4: bytes 4A17-4A1F were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

SoundSong11_TrackPtrs:: ; 05:4A17
Table_05_4A17::
	dw SoundSong11_Track0, SoundSong11_Track1, SoundSong11_Track2, SoundSong11_Track3 ; track stream pointers (read by the driver)
	dw SoundSong11_Track0_Loop, SoundSong11_Track1_Loop, SoundSong11_Track2_Loop, SoundSong11_Track3_Loop ; not read by the driver: target of each track's final sound_jump
	dw SoundSong11_Track0_AfterJump, SoundSong11_Track1_AfterJump, SoundSong11_Track2_AfterJump, SoundSong11_Track3_AfterJump ; not read by the driver: address after each track's final sound_jump
