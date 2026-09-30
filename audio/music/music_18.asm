; audio/music/music_18.asm
; bank 05, $5AF6-$5B06 (16 bytes); pinned by layout.link
; song id 18 (one track)

SECTION "audio/music/music_18", ROMX

; ---- data $5AF6-$5B02 (12 bytes) [CONFIRMED] read as data by executed code (in up to 18/18 scenarios); content class unknown

SoundSong18_Track0:: ; 05:5AF6
Data_05_5AF6::
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $00
	sound_note 1, $7F, $00
	sound_end

; ---- data $5B02-$5B04 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 5B04 (1 words = NN*(KK+1)); the byte before (5B01) is $B1 [v4: bytes 5B02-5B03 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

SoundSong18_Header:: ; 05:5B02
Data_05_5B02::
	sound_stream_header 1, 0

; ---- words $5B04-$5B06 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 5B02 [v4: bytes 5B04-5B06 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_5B04:: ; 05:5B04
	dw SoundSong18_Track0 ; track stream pointers (read by the driver)
