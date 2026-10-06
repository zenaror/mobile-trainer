; audio/music/music_0f.asm
; bank 05, $4232-$455A (808 bytes); pinned by layout.link
; song id 0F

SECTION "audio/music/music_0f", ROMX

; ---- data $4232-$42E7 (181 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong0F_Track0:: ; 05:4232
Data_05_4232::
	sound_volume $7F
	sound_pitch_add $00
SoundSong0F_Track0_Loop:: ; 05:4236
Data_05_4236::
	sound_tempo $46
	sound_instrument $02
	sound_wait 24
	sound_note 4, $4A, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_note 4, $4B, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_note 4, $4D, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 30
	sound_note 4, $4F, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_note 4, $4D, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 12
	sound_note 4, $46, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 12
	sound_rs sound_note_vol 4, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 42
	sound_rs sound_note_vol 4, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_note 4, $4B, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 30
	sound_note 4, $4A, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 18
	sound_note 4, $46, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_note 4, $43, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_note 4, $41, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_wait 60
	sound_note 4, $42, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_note 4, $44, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_note 4, $46, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_wait 60
	sound_note 4, $48, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_note 4, $49, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_note 4, $48, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_wait 12
	sound_note 4, $44, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 18
	sound_note 4, $50, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 18
	sound_note 4, $4E, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_note 4, $4D, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_note 4, $4E, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_wait 24
	sound_note 4, $46, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_note 4, $49, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 18
	sound_note 4, $4B, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 18
	sound_note 4, $4D, $13
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_wait 96
	sound_jump SoundSong0F_Track0_Loop

; ---- data $42E7-$42E8 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md

SoundSong0F_Track0_AfterJump:: ; 05:42E7
Data_05_42E7::
	sound_end

; ---- data $42E8-$43AE (198 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong0F_Track1:: ; 05:42E8
Data_05_42E8::
	sound_volume $7F
	sound_pitch_add $00
SoundSong0F_Track1_Loop:: ; 05:42EC
Data_05_42EC::
	sound_instrument $04
	sound_wait 24
	sound_note 8, $4A, $15
	sound_wait 12
	sound_instrument $34
	sound_note_vol 4, $05
	sound_wait 12
	sound_note 4, $4B
	sound_wait 12
	sound_rs sound_note 4, $4D
	sound_wait 12
	sound_instrument $04
	sound_note 8, $46, $15
	sound_wait 12
	sound_instrument $34
	sound_wait 12
	sound_note 4, $4F, $05
	sound_wait 12
	sound_rs sound_note 4, $4D
	sound_wait 12
	sound_instrument $04
	sound_note 8, $43, $15
	sound_wait 12
	sound_instrument $34
	sound_wait 12
	sound_note 4, $46, $05
	sound_wait 24
	sound_instrument $04
	sound_note_vol 8, $15
	sound_wait 12
	sound_instrument $34
	sound_wait 12
	sound_note_vol 4, $05
	sound_wait 12
	sound_note 4, $4B
	sound_wait 12
	sound_instrument $04
	sound_note 8, $46, $15
	sound_wait 12
	sound_instrument $34
	sound_wait 12
	sound_note 4, $4A, $05
	sound_wait 24
	sound_instrument $04
	sound_note 8, $43, $15
	sound_wait 12
	sound_instrument $34
	sound_wait 12
	sound_note 4, $41, $05
	sound_wait 24
	sound_instrument $04
	sound_note_vol 8, $15
	sound_wait 12
	sound_instrument $34
	sound_wait 36
	sound_rs sound_instrument $04
	sound_note 8, $46
	sound_wait 12
	sound_instrument $34
	sound_note 4, $44, $05
	sound_wait 12
	sound_rs sound_note 4, $46
	sound_wait 24
	sound_instrument $04
	sound_note_vol 8, $15
	sound_wait 12
	sound_instrument $34
	sound_wait 36
	sound_rs sound_instrument $04
	sound_note 8, $44
	sound_wait 12
	sound_instrument $34
	sound_note 4, $49, $05
	sound_wait 12
	sound_rs sound_note 4, $48
	sound_wait 24
	sound_instrument $04
	sound_note_vol 8, $15
	sound_wait 12
	sound_instrument $34
	sound_wait 12
	sound_note 4, $50, $05
	sound_wait 24
	sound_instrument $04
	sound_note 8, $44, $15
	sound_wait 12
	sound_instrument $34
	sound_note 4, $4D, $05
	sound_wait 12
	sound_rs sound_note 4, $4E
	sound_wait 24
	sound_instrument $04
	sound_note 8, $42, $15
	sound_wait 12
	sound_instrument $34
	sound_note 4, $46, $05
	sound_wait 12
	sound_rs sound_note 4, $49
	sound_wait 24
	sound_instrument $04
	sound_note 8, $46, $15
	sound_wait 12
	sound_instrument $34
	sound_wait 12
	sound_note 4, $4D, $05
	sound_wait 24
	sound_instrument $04
	sound_note 8, $46, $15
	sound_wait 12
	sound_instrument $34
	sound_wait 36
	sound_rs sound_instrument $04
	sound_note 8, $48
	sound_wait 24
	sound_jump SoundSong0F_Track1_Loop

; ---- data $43AE-$43AF (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md

SoundSong0F_Track1_AfterJump:: ; 05:43AE
Data_05_43AE::
	sound_end

; ---- data $43AF-$44BF (272 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong0F_Track2:: ; 05:43AF
Data_05_43AF::
	sound_volume $7F
	sound_pitch_add $F4
SoundSong0F_Track2_Loop:: ; 05:43B3
Data_05_43B3::
	sound_instrument $08
	sound_note 8, $2E, $1F
	sound_wait 24
	sound_instrument $09
	sound_note 8, $5E, $15
	sound_wait 12
	sound_instrument $08
	sound_note 8, $35, $1F
	sound_wait 12
	sound_rs sound_note 8, $2E
	sound_wait 12
	sound_note 8
	sound_wait 12
	sound_instrument $09
	sound_note 8, $59, $15
	sound_wait 12
	sound_instrument $08
	sound_note 8, $39, $1F
	sound_wait 12
	sound_instrument $08
	sound_note 8, $37
	sound_wait 24
	sound_instrument $09
	sound_note 8, $56, $15
	sound_wait 12
	sound_instrument $08
	sound_note 8, $32, $1F
	sound_wait 12
	sound_rs sound_note 8, $37
	sound_wait 12
	sound_note 8
	sound_wait 12
	sound_instrument $09
	sound_note 8, $5B, $15
	sound_wait 12
	sound_instrument $08
	sound_note 8, $35, $1F
	sound_wait 12
	sound_instrument $08
	sound_note 8, $33
	sound_wait 24
	sound_instrument $09
	sound_note 8, $5B, $15
	sound_wait 12
	sound_instrument $08
	sound_note 8, $33, $1F
	sound_wait 12
	sound_rs sound_note 8, $35
	sound_wait 12
	sound_note 8
	sound_wait 12
	sound_instrument $09
	sound_note 8, $57, $15
	sound_wait 12
	sound_instrument $08
	sound_note 8, $35, $1F
	sound_wait 12
	sound_instrument $08
	sound_note 8, $2E
	sound_wait 24
	sound_instrument $09
	sound_note 8, $56, $15
	sound_wait 12
	sound_instrument $08
	sound_note 8, $35, $1F
	sound_wait 12
	sound_rs sound_note 8, $2E
	sound_wait 12
	sound_note 8
	sound_wait 12
	sound_instrument $09
	sound_note 8, $59, $15
	sound_wait 12
	sound_instrument $08
	sound_note 8, $38, $1F
	sound_wait 12
	sound_instrument $08
	sound_note 8, $36
	sound_wait 24
	sound_instrument $09
	sound_note 8, $5A, $15
	sound_wait 12
	sound_instrument $08
	sound_note 8, $31, $1F
	sound_wait 12
	sound_rs sound_note 8, $38
	sound_wait 12
	sound_note 8
	sound_wait 12
	sound_instrument $09
	sound_note 8, $57, $15
	sound_wait 12
	sound_instrument $08
	sound_note 8, $36, $1F
	sound_wait 12
	sound_instrument $08
	sound_note 8, $35
	sound_wait 24
	sound_instrument $09
	sound_note 8, $5C, $15
	sound_wait 12
	sound_instrument $08
	sound_note 8, $35, $1F
	sound_wait 12
	sound_rs sound_note 8, $3A
	sound_wait 12
	sound_note 8
	sound_wait 12
	sound_instrument $09
	sound_note 8, $56, $15
	sound_wait 12
	sound_instrument $08
	sound_note 8, $2E, $1F
	sound_wait 12
	sound_instrument $08
	sound_note 8, $33
	sound_wait 24
	sound_instrument $09
	sound_note 8, $57, $15
	sound_wait 12
	sound_instrument $08
	sound_note 8, $2E, $1F
	sound_wait 12
	sound_rs sound_note 8, $33
	sound_wait 12
	sound_note 8
	sound_wait 12
	sound_instrument $09
	sound_note 8, $5A, $15
	sound_wait 12
	sound_instrument $08
	sound_note 8, $33, $1F
	sound_wait 12
	sound_instrument $08
	sound_note 8, $35
	sound_wait 24
	sound_instrument $09
	sound_note 8, $5B, $15
	sound_wait 12
	sound_instrument $08
	sound_note 8, $30, $1F
	sound_wait 12
	sound_rs sound_note 8, $35
	sound_wait 12
	sound_note 8
	sound_wait 12
	sound_instrument $09
	sound_note 8, $5D, $15
	sound_wait 12
	sound_instrument $08
	sound_note 8, $35, $1F
	sound_wait 12
	sound_jump SoundSong0F_Track2_Loop

; ---- data $44BF-$44C0 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md

SoundSong0F_Track2_AfterJump:: ; 05:44BF
Data_05_44BF::
	sound_end

; ---- data $44C0-$4535 (117 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong0F_Track3:: ; 05:44C0
Data_05_44C0::
	sound_volume $7F
	sound_pitch_add $00
SoundSong0F_Track3_Loop:: ; 05:44C4
Data_05_44C4::
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 4, $27, $11
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 6, $25, $10
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6, $2A, $0C
	sound_wait 6
	sound_note 4, $27, $11
	sound_wait 6
	sound_note 4
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 4, $27, $11
	sound_wait 12
	sound_note 6, $25, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6
	sound_wait 6
	sound_ret
SoundSong0F_Track3_Sub1:: ; 05:44F3
Data_05_44F3::
	sound_note 4, $27, $11
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 6, $25, $10
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6, $2A, $0C
	sound_wait 6
	sound_note 4, $27, $11
	sound_wait 6
	sound_note 4
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 4, $27, $11
	sound_wait 12
	sound_note 6, $25, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6
	sound_wait 6
	sound_ret
	sound_call SoundSong0F_Track3_Sub1
	sound_call SoundSong0F_Track3_Sub1
	sound_call SoundSong0F_Track3_Sub1
	sound_call SoundSong0F_Track3_Sub1
	sound_call SoundSong0F_Track3_Sub1
	sound_call SoundSong0F_Track3_Loop
	sound_jump SoundSong0F_Track3_Loop

; ---- data $4535-$4540 (11 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md

SoundSong0F_Track3_AfterJump:: ; 05:4535
Data_05_4535::
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 4, $27, $11
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 3
	sound_end

; ---- data $4540-$4542 (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 4542 (12 words = NN*(KK+1)); the byte before (453F) is $B1

SoundSong0F_Header:: ; 05:4540
Data_05_4540::
	sound_stream_header 4, 2

; ---- words $4542-$455A (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 4540 [v4: bytes 4542-454A were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

SoundSong0F_TrackPtrs:: ; 05:4542
Table_05_4542::
	dw SoundSong0F_Track0, SoundSong0F_Track1, SoundSong0F_Track2, SoundSong0F_Track3 ; track stream pointers (read by the driver)
	; not read by the driver: target of each track's final sound_jump
	dw SoundSong0F_Track0_Loop, SoundSong0F_Track1_Loop
	dw SoundSong0F_Track2_Loop, SoundSong0F_Track3_Loop
	; not read by the driver: address after each track's final sound_jump
	dw SoundSong0F_Track0_AfterJump, SoundSong0F_Track1_AfterJump
	dw SoundSong0F_Track2_AfterJump, SoundSong0F_Track3_AfterJump
