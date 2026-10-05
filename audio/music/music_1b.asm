; audio/music/music_1b.asm
; bank 05, $60E9-$60F9 (16 bytes); pinned by layout.link
; song id 1B (one track)

SECTION "audio/music/music_1b", ROMX

; ---- data $60E9-$60F5 (12 bytes) [CONFIRMED] read as data by executed code (in up to 14/18 scenarios); content: sound stream bytes, decoded (docs/research/audio_format.md)

SoundSong1B_Track0:: ; 05:60E9
Data_05_60E9::
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $00
	sound_note 1, $7F, $00
	sound_end

; ---- data $60F5-$60F7 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 60F7 (1 words = NN*(KK+1)); the byte before (60F4) is $B1 [v4: bytes 60F5-60F6 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

SoundSong1B_Header:: ; 05:60F5
Data_05_60F5::
	sound_stream_header 1, 0

; ---- words $60F7-$60F9 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 60F5 [v4: bytes 60F7-60F9 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_60F7:: ; 05:60F7
	dw SoundSong1B_Track0 ; track stream pointers (read by the driver)
