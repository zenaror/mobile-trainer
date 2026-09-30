; audio/music/music_1b.asm
; bank 05, $60E9-$60F9 (16 bytes); pinned by layout.link
; song id 1B (one track)

SECTION "audio/music/music_1b", ROMX

; ---- data $60E9-$60F5 (12 bytes) [CONFIRMED] read as data by executed code (in up to 14/18 scenarios); content class unknown

Data_05_60E9:: ; 05:60E9
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $00, $D0, $7F, $00, $B1

; ---- data $60F5-$60F7 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 60F7 (1 words = NN*(KK+1)); the byte before (60F4) is $B1 [v4: bytes 60F5-60F6 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_60F5:: ; 05:60F5
	db $01, $00

; ---- words $60F7-$60F9 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 60F5 [v4: bytes 60F7-60F9 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_60F7:: ; 05:60F7
	dw Data_05_60E9
