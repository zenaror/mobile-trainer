; audio/music/music_13.asm
; bank 05, $4CA1-$4D80 (223 bytes); pinned by layout.link
; song id 13

SECTION "audio/music/music_13", ROMX

; ---- data $4CA1-$4D76 (213 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

SoundSong13_Track0:: ; 05:4CA1
Data_05_4CA1::
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $37
	sound_instrument $01
	sound_note 4, $48, $16
	sound_wait 6
	sound_instrument $20
	sound_note 4, $57, $0D
	sound_wait 6
	sound_instrument $01
	sound_note 8, $48, $16
	sound_wait 12
	sound_note 4, $4A
	sound_wait 6
	sound_note 4
	sound_wait 6
	sound_instrument $20
	sound_note 4, $59, $0D
	sound_wait 6
	sound_instrument $01
	sound_note 6, $4B, $16
	sound_wait 6
	sound_rs sound_note_vol 6, $07
	sound_wait 6
	sound_instrument $20
	sound_note 6, $5B, $0D
	sound_wait 6
	sound_rs sound_note 6, $57
	sound_wait 6
	sound_note 8, $4F
	sound_wait 8
	sound_end
SoundSong13_Track1:: ; 05:4CD8
Data_05_4CD8::
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $05
	sound_note 4, $3F, $11
	sound_wait 6
	sound_instrument $04
	sound_note 4, $50, $0D
	sound_wait 6
	sound_instrument $05
	sound_note 8, $3F, $11
	sound_wait 12
	sound_note 4, $41
	sound_wait 6
	sound_note 4
	sound_wait 6
	sound_instrument $04
	sound_note 4, $52, $0D
	sound_wait 6
	sound_instrument $05
	sound_note 6, $43, $11
	sound_wait 6
	sound_rs sound_note_vol 6, $05
	sound_wait 6
	sound_instrument $04
	sound_note 6, $52, $0D
	sound_wait 6
	sound_rs sound_note 6, $4F
	sound_wait 6
	sound_note 8, $3F
	sound_wait 8
	sound_end
SoundSong13_Track2:: ; 05:4D0D
Data_05_4D0D::
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $08
	sound_note 6, $38, $1F
	sound_wait 6
	sound_rs sound_note 6, $2C
	sound_wait 6
	sound_note 12, $38
	sound_wait 12
	sound_note 6, $3A
	sound_wait 6
	sound_rs sound_note 6, $2E
	sound_wait 12
	sound_rs sound_note 6, $33
	sound_wait 12
	sound_rs sound_note 6, $2E
	sound_wait 6
	sound_rs sound_note 6, $2B
	sound_wait 6
	sound_note 8, $27
	sound_wait 8
	sound_end
SoundSong13_Track3:: ; 05:4D2B
Data_05_4D2B::
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 5, $27, $11
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_pitch_bend $28
	sound_note 5, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 5, $27, $11
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_pitch_bend $28
	sound_note 5, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 5, $27, $11
	sound_wait 6
	sound_pitch_bend $28
	sound_note 5, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 5, $27, $11
	sound_wait 6
	sound_pitch_bend $28
	sound_note 6, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_end

; ---- data $4D76-$4D78 (2 bytes) [PROBABLE] header NN=04 KK=00 of the channel-pointer table at 4D78 (4 words = NN*(KK+1)); the byte before (4D75) is $B1 [v4: bytes 4D76-4D77 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

SoundSong13_Header:: ; 05:4D76
Data_05_4D76::
	sound_stream_header 4, 0

; ---- words $4D78-$4D80 (8 bytes) [PROBABLE] 4 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 4D76 [v4: bytes 4D78-4D80 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_4D78:: ; 05:4D78
	dw SoundSong13_Track0, SoundSong13_Track1, SoundSong13_Track2, SoundSong13_Track3 ; track stream pointers (read by the driver)
