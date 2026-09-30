; audio/music/music_1d.asm
; bank 05, $62D0-$631A (74 bytes); pinned by layout.link
; song id 1D

SECTION "audio/music/music_1d", ROMX

; ---- data $62D0-$6312 (66 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_62D0:: ; 05:62D0
	db $BF, $7F, $BD, $00, $BC, $46, $BE, $01, $D1, $57, $15, $84, $4F, $84, $52, $84
	db $54, $84, $4D, $84, $51, $82, $B1, $BF, $7F, $BD, $00, $BE, $05, $88, $D1, $57
	db $04, $84, $4F, $84, $52, $84, $54, $84, $4D, $84, $51, $82, $B1, $BF, $7F, $BD
	db $00, $BE, $08, $D1, $4F, $13, $84, $48, $84, $4B, $84, $4D, $84, $46, $84, $4A
	db $82, $B1

; ---- data $6312-$6314 (2 bytes) [PROBABLE] header NN=03 KK=00 of the channel-pointer table at 6314 (3 words = NN*(KK+1)); the byte before (6311) is $B1

Data_05_6312:: ; 05:6312
	db $03, $00

; ---- words $6314-$631A (6 bytes) [PROBABLE] 3 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6312

Table_05_6314:: ; 05:6314
	dw Data_05_62D0, $62E7, $62FD
