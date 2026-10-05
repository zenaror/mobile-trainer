; audio/music/music_1c.asm
; bank 05, $60F9-$62D0 (471 bytes); pinned by layout.link
; song id 1C

SECTION "audio/music/music_1c", ROMX

; ---- data $60F9-$62BC (451 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); individual commands decoded (docs/research/audio_format.md); see docs/research/classify_g4.md

SoundSong1C_Track0:: ; 05:60F9
Data_05_60F9::
	sound_volume $7F
	sound_pitch_add $00
Data_05_60FD:: ; 05:60FD
	sound_tempo $30
	sound_instrument $00
	sound_wait 12
	sound_note 3, $45, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $05
	sound_wait 12
	sound_rs sound_note_vol 3, $11
	sound_wait 4
	sound_rs sound_note_vol 3, $05
	sound_wait 12
	sound_note 3, $41, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $05
	sound_wait 12
	sound_note 3, $43, $11
	sound_wait 4
	sound_rs sound_note_vol 3, $05
	sound_wait 12
	sound_rs sound_note_vol 3, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $05
	sound_wait 4
	sound_wait 12
	sound_note 3, $45, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $05
	sound_wait 12
	sound_rs sound_note_vol 3, $11
	sound_wait 4
	sound_rs sound_note_vol 3, $05
	sound_wait 12
	sound_note 3, $46, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $05
	sound_wait 12
	sound_note 3, $48, $11
	sound_wait 4
	sound_rs sound_note_vol 3, $05
	sound_wait 12
	sound_note 3, $43, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $05
	sound_wait 4
	sound_wait 12
	sound_note 3, $45, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $05
	sound_wait 12
	sound_rs sound_note_vol 3, $11
	sound_wait 4
	sound_rs sound_note_vol 3, $05
	sound_wait 12
	sound_note 3, $41, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $05
	sound_wait 12
	sound_note 3, $43, $11
	sound_wait 4
	sound_rs sound_note_vol 3, $05
	sound_wait 12
	sound_rs sound_note_vol 3, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $05
	sound_wait 4
	sound_wait 12
	sound_note 3, $41, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $05
	sound_wait 12
	sound_rs sound_note_vol 3, $11
	sound_wait 4
	sound_rs sound_note_vol 3, $05
	sound_wait 12
	sound_note 3, $46, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $05
	sound_wait 12
	sound_note 3, $45, $11
	sound_wait 4
	sound_rs sound_note_vol 3, $05
	sound_wait 12
	sound_note 3, $41, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $05
	sound_wait 4
	sound_jump Data_05_60FD
Data_05_6174:: ; 05:6174
	sound_end
SoundSong1C_Track1:: ; 05:6175
Data_05_6175::
	sound_volume $7F
	sound_pitch_add $00
Data_05_6179:: ; 05:6179
	sound_instrument $04
	sound_note 6, $29, $19
	sound_wait 12
	sound_instrument $05
	sound_note 3, $3C, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $04
	sound_wait 4
	sound_instrument $04
	sound_note 6, $29, $19
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 3, $3C, $11
	sound_wait 4
	sound_rs sound_note_vol 3, $04
	sound_wait 6
	sound_instrument $04
	sound_wait 2
	sound_note 6, $2E, $19
	sound_wait 4
	sound_instrument $05
	sound_note 3, $39, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $04
	sound_wait 4
	sound_instrument $04
	sound_note 6, $30, $19
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 3, $3A, $11
	sound_wait 4
	sound_rs sound_note_vol 3, $04
	sound_wait 6
	sound_instrument $04
	sound_wait 2
	sound_note 6, $30, $19
	sound_wait 4
	sound_instrument $05
	sound_note 3, $3A, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $04
	sound_wait 4
	sound_ret
	sound_instrument $04
	sound_note 6, $29, $19
	sound_wait 12
	sound_instrument $05
	sound_note 3, $3C, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $04
	sound_wait 4
	sound_instrument $04
	sound_note 6, $29, $19
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 3, $3C, $11
	sound_wait 4
	sound_rs sound_note_vol 3, $04
	sound_wait 6
	sound_instrument $04
	sound_wait 2
	sound_note 6, $2E, $19
	sound_wait 4
	sound_instrument $05
	sound_note 3, $3D, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $04
	sound_wait 4
	sound_instrument $04
	sound_note 6, $30, $19
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 3, $3F, $11
	sound_wait 4
	sound_rs sound_note_vol 3, $04
	sound_wait 6
	sound_instrument $04
	sound_wait 2
	sound_note 6, $24, $19
	sound_wait 4
	sound_instrument $05
	sound_note 3, $3A, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $04
	sound_wait 4
	sound_call Data_05_6179
	sound_instrument $04
	sound_note 6, $2E, $19
	sound_wait 12
	sound_instrument $05
	sound_note 3, $3A, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $04
	sound_wait 4
	sound_instrument $04
	sound_note 6, $2E, $19
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 3, $3A, $11
	sound_wait 4
	sound_rs sound_note_vol 3, $04
	sound_wait 6
	sound_instrument $04
	sound_wait 2
	sound_note 6, $30, $19
	sound_wait 4
	sound_instrument $05
	sound_note 3, $3D, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $04
	sound_wait 4
	sound_instrument $04
	sound_note 6, $24, $19
	sound_wait 6
	sound_instrument $05
	sound_wait 2
	sound_note 3, $3C, $11
	sound_wait 4
	sound_rs sound_note_vol 3, $04
	sound_wait 6
	sound_instrument $04
	sound_wait 2
	sound_note 6, $30, $19
	sound_wait 4
	sound_instrument $05
	sound_note 3, $3A, $11
	sound_wait 8
	sound_rs sound_note_vol 3, $04
	sound_wait 4
	sound_jump Data_05_6179
Data_05_625E:: ; 05:625E
	sound_end
SoundSong1C_Track2:: ; 05:625F
Data_05_625F::
	sound_volume $7F
	sound_pitch_add $00
Data_05_6263:: ; 05:6263
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 4, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 4, $2F, $0E
	sound_wait 12
	sound_rs sound_note 4, $2A
	sound_wait 8
	sound_rs sound_note 4, $2F
	sound_wait 4
	sound_note 4, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 4, $2F, $0E
	sound_wait 8
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 3
	sound_wait 8
	sound_note 3, $2A, $0E
	sound_wait 4
Data_05_628B:: ; 05:628B
	sound_note 4, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 4, $2F, $0E
	sound_wait 12
	sound_rs sound_note 4, $2A
	sound_wait 8
	sound_rs sound_note 4, $2F
	sound_wait 4
	sound_note 4, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 4, $2F, $0E
	sound_wait 8
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 3
	sound_wait 8
	sound_note 3, $2A, $0E
	sound_wait 4
	sound_ret
	sound_call Data_05_628B
	sound_call Data_05_628B
	sound_jump Data_05_6263
Data_05_62BB:: ; 05:62BB
	sound_end

; ---- data $62BC-$62BE (2 bytes) [PROBABLE] header NN=03 KK=02 of the channel-pointer table at 62BE (9 words = NN*(KK+1)); the byte before (62BB) is $B1

SoundSong1C_Header:: ; 05:62BC
Data_05_62BC::
	sound_stream_header 3, 2

; ---- words $62BE-$62D0 (18 bytes) [PROBABLE] 9 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 62BC

Table_05_62BE:: ; 05:62BE
	dw SoundSong1C_Track0, SoundSong1C_Track1, SoundSong1C_Track2 ; track stream pointers (read by the driver)
	dw Data_05_60FD, Data_05_6179, Data_05_6263 ; not read by the driver: target of each track's final sound_jump
	dw Data_05_6174, Data_05_625E, Data_05_62BB ; not read by the driver: address after each track's final sound_jump
