; audio/music/music_0e.asm
; bank 05, $4000-$4232 (562 bytes); pinned by layout.link
; song id 0E

SECTION "audio/music/music_0e", ROMX

; ---- data $4000-$4024 (36 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_4000:: ; 05:4000
	sound_volume $7F
	sound_pitch_add $00
Data_05_4004:: ; 05:4004
	sound_tempo $3B
	sound_instrument $29
	sound_cmd_C5 $14
	sound_cmd_C3 $28
	sound_cmd_C4 $20
	sound_note 48, $48, $13
	sound_wait 60
	sound_note 12, $46
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_note 60, $43
	sound_wait 12
	sound_wait 60
	sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $40
	sound_wait 12
	sound_note 60, $41
	sound_wait 12
	sound_wait 60

; ---- data $4024-$4047 (35 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4024:: ; 05:4024
	sound_note 12, $46
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_note 72, $43
	sound_wait 12
	sound_wait 96
	sound_note 48, $48
	sound_wait 60
	sound_note 12, $46
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_note 60, $43
	sound_wait 12
	sound_wait 60
	sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $40
	sound_wait 12
	sound_note 84, $41
	sound_wait 12
	sound_wait 96
	sound_wait 96
	sound_jump Data_05_4004
Data_05_4046:: ; 05:4046
	sound_end

; ---- data $4047-$4090 (73 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_4047:: ; 05:4047
	sound_volume $7F
	sound_pitch_add $00
Data_05_404B:: ; 05:404B
	sound_instrument $06
	sound_wait 12
	sound_note 4, $45, $0C
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $41, $0C
	sound_wait 12
	sound_rs sound_note 4, $4A
	sound_wait 12
	sound_rs sound_note 4, $46
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $48, $0C
	sound_wait 12
Data_05_406E:: ; 05:406E
	sound_wait 12
	sound_note 4, $3C, $0C
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $48, $0C
	sound_wait 12
	sound_rs sound_note 4, $43
	sound_wait 12
	sound_rs sound_note 4, $48
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4C, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $46, $0C
	sound_wait 12
	sound_ret

; ---- data $4090-$40FF (111 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4090:: ; 05:4090
	sound_note 4, $45, $0C
	sound_wait 12
	sound_rs sound_note 4, $41
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $48, $0C
	sound_wait 12
	sound_rs sound_note 4, $4A
	sound_wait 12
	sound_rs sound_note 4, $46
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $43, $0C
	sound_wait 12
	sound_ret
Data_05_40B3:: ; 05:40B3
	sound_wait 12
	sound_note 4, $3C, $0C
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $48, $0C
	sound_wait 12
	sound_rs sound_note 4, $46
	sound_wait 24
	sound_instrument $04
	sound_note 12, $4C, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $43, $0C
	sound_wait 12
	sound_ret
	sound_wait 12
	sound_rs sound_note 4, $45
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $41, $0C
	sound_wait 12
	sound_rs sound_note 4, $4A
	sound_wait 12
	sound_rs sound_note 4, $46
	sound_wait 12
	sound_instrument $04
	sound_note 12, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 4, $48, $0C
	sound_wait 12
	sound_call Data_05_406E
	sound_call Data_05_4090
	sound_call Data_05_40B3
	sound_jump Data_05_404B
Data_05_40FE:: ; 05:40FE
	sound_end

; ---- data $40FF-$4139 (58 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_40FF:: ; 05:40FF
	sound_volume $7F
	sound_pitch_add $00
Data_05_4103:: ; 05:4103
	sound_instrument $08
	sound_note 24, $2D, $1F
	sound_wait 24
	sound_instrument $09
	sound_note 12, $45, $15
	sound_wait 12
	sound_instrument $08
	sound_note 12, $2E, $1F
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_instrument $09
	sound_note 12, $46, $15
	sound_wait 24
	sound_ret
Data_05_411E:: ; 05:411E
	sound_instrument $08
	sound_note 24, $30, $1F
	sound_wait 24
	sound_instrument $09
	sound_note 12, $46, $15
	sound_wait 12
	sound_instrument $08
	sound_note 12, $24, $1F
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_instrument $09
	sound_note 12, $43, $15
	sound_wait 24
	sound_ret

; ---- data $4139-$4167 (46 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_4139:: ; 05:4139
	sound_instrument $08
	sound_note 24, $26, $1F
	sound_wait 24
	sound_instrument $09
	sound_note 12, $45, $15
	sound_wait 12
	sound_instrument $08
	sound_note 12, $2B, $1F
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_instrument $09
	sound_note 12, $46, $15
	sound_wait 24
	sound_ret
	sound_call Data_05_411E
	sound_call Data_05_4103
	sound_call Data_05_411E
	sound_call Data_05_4139
	sound_call Data_05_411E
	sound_jump Data_05_4103
Data_05_4166:: ; 05:4166
	sound_end

; ---- data $4167-$41D0 (105 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_4167:: ; 05:4167
	sound_volume $7F
	sound_pitch_add $00
Data_05_416B:: ; 05:416B
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 6, $27, $11
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 6, $27, $11
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6, $27, $11
	sound_wait 12
	sound_rs sound_note 6, $2A, $0B
	sound_wait 6
	sound_note 3, $24
	sound_wait 6
	sound_cmd_C1 $20
	sound_note 6, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 3
	sound_wait 6
Data_05_419F:: ; 05:419F
	sound_note 6, $27, $11
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 6, $27, $11
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6, $27, $11
	sound_wait 12
	sound_rs sound_note 6, $2A, $0B
	sound_wait 6
	sound_note 3, $24
	sound_wait 6
	sound_cmd_C1 $20
	sound_note 6, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 3

; ---- data $41D0-$4218 (72 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_41D0:: ; 05:41D0
	sound_wait 6
	sound_ret
	sound_call Data_05_419F
Data_05_41D5:: ; 05:41D5
	sound_note 6, $27, $11
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 6, $27, $11
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6, $27, $11
	sound_wait 12
	sound_rs sound_note 6, $2A, $0B
	sound_wait 6
	sound_note 3, $24
	sound_wait 6
	sound_cmd_C1 $20
	sound_note 6, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6
	sound_wait 6
	sound_ret
	sound_call Data_05_419F
	sound_call Data_05_419F
	sound_call Data_05_419F
	sound_call Data_05_41D5
	sound_jump Data_05_416B
Data_05_4217:: ; 05:4217
	sound_end

; ---- data $4218-$421A (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 421A (12 words = NN*(KK+1)); the byte before (4217) is $B1

Data_05_4218:: ; 05:4218
	sound_stream_header 4, 2

; ---- words $421A-$4232 (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 4218 [v4: bytes 421A-4222 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_421A:: ; 05:421A
	dw Data_05_4000, Data_05_4047, Data_05_40FF, Data_05_4167 ; track stream pointers (read by the driver)
	dw Data_05_4004, Data_05_404B, Data_05_4103, Data_05_416B ; not read by the driver: target of each track's final sound_jump
	dw Data_05_4046, Data_05_40FE, Data_05_4166, Data_05_4217 ; not read by the driver: address after each track's final sound_jump
