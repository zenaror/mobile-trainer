; audio/music/music_1d.asm
; bank 05, $62D0-$631A (74 bytes); pinned by layout.link
; song id 1D

SECTION "audio/music/music_1d", ROMX

; ---- data $62D0-$6312 (66 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

SoundSong1D_Track0:: ; 05:62D0
Data_05_62D0::
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $46
	sound_instrument $01
	sound_note 2, $57, $15
	sound_wait 4
	sound_rs sound_note 2, $4F
	sound_wait 4
	sound_rs sound_note 2, $52
	sound_wait 4
	sound_rs sound_note 2, $54
	sound_wait 4
	sound_rs sound_note 2, $4D
	sound_wait 4
	sound_rs sound_note 2, $51
	sound_wait 2
	sound_end
SoundSong1D_Track1:: ; 05:62E7
Data_05_62E7::
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $05
	sound_wait 8
	sound_note 2, $57, $04
	sound_wait 4
	sound_rs sound_note 2, $4F
	sound_wait 4
	sound_rs sound_note 2, $52
	sound_wait 4
	sound_rs sound_note 2, $54
	sound_wait 4
	sound_rs sound_note 2, $4D
	sound_wait 4
	sound_rs sound_note 2, $51
	sound_wait 2
	sound_end
SoundSong1D_Track2:: ; 05:62FD
Data_05_62FD::
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $08
	sound_note 2, $4F, $13
	sound_wait 4
	sound_rs sound_note 2, $48
	sound_wait 4
	sound_rs sound_note 2, $4B
	sound_wait 4
	sound_rs sound_note 2, $4D
	sound_wait 4
	sound_rs sound_note 2, $46
	sound_wait 4
	sound_rs sound_note 2, $4A
	sound_wait 2
	sound_end

; ---- data $6312-$6314 (2 bytes) [PROBABLE] header NN=03 KK=00 of the channel-pointer table at 6314 (3 words = NN*(KK+1)); the byte before (6311) is $B1

SoundSong1D_Header:: ; 05:6312
Data_05_6312::
	sound_stream_header 3, 0

; ---- words $6314-$631A (6 bytes) [PROBABLE] 3 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6312

Table_05_6314:: ; 05:6314
	dw SoundSong1D_Track0, SoundSong1D_Track1, SoundSong1D_Track2 ; track stream pointers (read by the driver)
