; audio/music/music_15.asm
; bank 05, $50BC-$5174 (184 bytes); pinned by layout.link
; song id 15

SECTION "audio/music/music_15", ROMX

; ---- data $50BC-$516A (174 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong15_Track0:: ; 05:50BC
Data_05_50BC::
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $46
	sound_instrument $00
	sound_note 6, $44, $16
	sound_wait 6
	sound_note 4, $50
	sound_wait 12
	sound_note 6, $42
	sound_wait 6
	sound_note 4, $4E
	sound_wait 12
	sound_note 3, $40
	sound_wait 3
	sound_note 3, $4C, $11
	sound_wait 3
	sound_rs sound_note 3, $40
	sound_wait 3
	sound_note 3, $4C, $0F
	sound_wait 3
	sound_rs sound_note 3, $40
	sound_wait 3
	sound_rs sound_note 3, $4C
	sound_wait 3
	sound_note 3, $40, $0D
	sound_wait 3
	sound_rs sound_note 3, $4C
	sound_wait 3
	sound_rs sound_note 3, $40
	sound_wait 3
	sound_note 3, $4C, $0B
	sound_wait 3
	sound_rs sound_note 3, $40
	sound_wait 3
	sound_rs sound_note 3, $4C
	sound_wait 3
	sound_end
SoundSong15_Track1:: ; 05:50F3
Data_05_50F3::
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $05
	sound_note 6, $4A, $12
	sound_wait 6
	sound_note 4, $56
	sound_wait 12
	sound_note 6, $48
	sound_wait 6
	sound_note 4, $54
	sound_wait 12
	sound_note 3, $46
	sound_wait 3
	sound_note 3, $52, $0E
	sound_wait 3
	sound_rs sound_note 3, $46
	sound_wait 3
	sound_note 3, $52, $0C
	sound_wait 3
	sound_rs sound_note 3, $46
	sound_wait 3
	sound_rs sound_note 3, $52
	sound_wait 3
	sound_note 3, $46, $0A
	sound_wait 3
	sound_rs sound_note 3, $52
	sound_wait 3
	sound_rs sound_note 3, $46
	sound_wait 3
	sound_note 3, $52, $08
	sound_wait 3
	sound_rs sound_note 3, $46
	sound_wait 3
	sound_rs sound_note 3, $52
	sound_wait 3
	sound_end
SoundSong15_Track2:: ; 05:5128
Data_05_5128::
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $08
	sound_note 6, $34, $1F
	sound_wait 6
	sound_note 4, $28
	sound_wait 12
	sound_note 6, $32
	sound_wait 6
	sound_note 4, $26
	sound_wait 12
	sound_note 6, $30
	sound_wait 6
	sound_note 30, $24
	sound_wait 30
	sound_end
SoundSong15_Track3:: ; 05:5142
Data_05_5142::
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 4, $2C, $0F
	sound_wait 6
	sound_rs sound_note 4, $2D
	sound_wait 6
	sound_note 4, $24, $09
	sound_wait 6
	sound_rs sound_note 4, $2C, $0F
	sound_wait 6
	sound_rs sound_note 4, $2D
	sound_wait 6
	sound_note 4, $24, $09
	sound_wait 6
	sound_rs sound_note 4, $2C, $0F
	sound_wait 6
	sound_note 4
	sound_wait 6
	sound_note_vol 4, $0D
	sound_wait 6
	sound_rs sound_note_vol 4, $0B
	sound_wait 6
	sound_rs sound_note_vol 4, $09
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 4
	sound_end

; ---- data $516A-$516C (2 bytes) [PROBABLE] header NN=04 KK=00 of the channel-pointer table at 516C (4 words = NN*(KK+1)); the byte before (5169) is $B1 [v4: bytes 516A-516B were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

SoundSong15_Header:: ; 05:516A
Data_05_516A::
	sound_stream_header 4, 0

; ---- words $516C-$5174 (8 bytes) [PROBABLE] 4 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 516A [v4: bytes 516C-5174 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_516C:: ; 05:516C
	dw SoundSong15_Track0, SoundSong15_Track1, SoundSong15_Track2, SoundSong15_Track3 ; track stream pointers (read by the driver)
