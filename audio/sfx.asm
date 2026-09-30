; audio/sfx.asm
; bank 05, $631A-$68C3 (1449 bytes); pinned by layout.link
; sound effects, ids 29-46 (30 headers end-to-end)

SECTION "audio/sfx", ROMX

; ---- data $631A-$632A (16 bytes) [CONFIRMED] read as data by executed code (in up to 14/18 scenarios); content class unknown

Data_05_631A:: ; 05:631A
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $06
	sound_note 1, $58, $0E
	sound_wait 1
	sound_rs sound_note 1, $5D, $18
	sound_wait 1
	sound_end

; ---- data $632A-$632C (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 632C (1 words = NN*(KK+1)); the byte before (6329) is $B1 [v4: bytes 632A-632B were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_632A:: ; 05:632A
	sound_stream_header 1, 0

; ---- words $632C-$632E (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 632A [v4: bytes 632C-632E were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_632C:: ; 05:632C
	dw Data_05_631A ; track stream pointers (read by the driver)

; ---- data $632E-$634A (28 bytes) [CONFIRMED] read as data by executed code (in up to 14/18 scenarios); content class unknown

Data_05_632E:: ; 05:632E
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_cmd_C5 $48
	sound_cmd_C2 $0C
	sound_cmd_C3 $40
	sound_cmd_C1 $40
	sound_note 14, $39, $0E
	sound_wait 14
	sound_instrument $06
	sound_note 1, $58, $11
	sound_wait 1
	sound_rs sound_note 1, $5D, $18
	sound_wait 1
	sound_end

; ---- data $634A-$634C (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 634C (1 words = NN*(KK+1)); the byte before (6349) is $B1 [v4: bytes 634A-634B were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_634A:: ; 05:634A
	sound_stream_header 1, 0

; ---- words $634C-$634E (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 634A [v4: bytes 634C-634E were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_634C:: ; 05:634C
	dw Data_05_632E ; track stream pointers (read by the driver)

; ---- data $634E-$636A (28 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

Data_05_634E:: ; 05:634E
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_cmd_C5 $48
	sound_cmd_C2 $0C
	sound_cmd_C3 $40
	sound_cmd_C1 $40
	sound_note 16, $39, $0E
	sound_wait 16
	sound_instrument $06
	sound_note 1, $58, $11
	sound_wait 1
	sound_rs sound_note 1, $5D, $18
	sound_wait 1
	sound_end

; ---- data $636A-$636C (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 636C (1 words = NN*(KK+1)); the byte before (6369) is $B1 [v4: bytes 636A-636B were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_636A:: ; 05:636A
	sound_stream_header 1, 0

; ---- words $636C-$636E (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 636A [v4: bytes 636C-636E were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_636C:: ; 05:636C
	dw Data_05_634E ; track stream pointers (read by the driver)

; ---- data $636E-$638D (31 bytes) [CONFIRMED] read as data by executed code (in up to 17/18 scenarios); content class unknown

Data_05_636E:: ; 05:636E
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $06
	sound_cmd_C2 $0C
	sound_cmd_C1 $39
	sound_note 2, $53, $17
	sound_wait 1
	sound_cmd_C1 $33
	sound_wait 3
	sound_rs sound_cmd_C1 $40
	sound_note 4, $63
	sound_wait 1
	sound_cmd_C1 $4B
	sound_wait 1
	sound_rs sound_cmd_C1 $57
	sound_wait 1
	sound_rs sound_cmd_C1 $63
	sound_wait 1
	sound_end

; ---- data $638D-$638F (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 638F (1 words = NN*(KK+1)); the byte before (638C) is $B1 [v4: bytes 638D-638E were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_638D:: ; 05:638D
	sound_stream_header 1, 0

; ---- words $638F-$6391 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 638D [v4: bytes 638F-6391 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_638F:: ; 05:638F
	dw Data_05_636E ; track stream pointers (read by the driver)

; ---- data $6391-$63B0 (31 bytes) [CONFIRMED] read as data by executed code (in up to 17/18 scenarios); content class unknown

Data_05_6391:: ; 05:6391
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $06
	sound_cmd_C2 $0C
	sound_cmd_C1 $39
	sound_note 2, $53, $17
	sound_wait 1
	sound_cmd_C1 $33
	sound_wait 3
	sound_rs sound_cmd_C1 $40
	sound_note 4, $63
	sound_wait 1
	sound_cmd_C1 $4B
	sound_wait 1
	sound_rs sound_cmd_C1 $57
	sound_wait 1
	sound_rs sound_cmd_C1 $63
	sound_wait 1
	sound_end

; ---- data $63B0-$63B2 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 63B2 (1 words = NN*(KK+1)); the byte before (63AF) is $B1 [v4: bytes 63B0-63B1 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_63B0:: ; 05:63B0
	sound_stream_header 1, 0

; ---- words $63B2-$63B4 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 63B0 [v4: bytes 63B2-63B4 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_63B2:: ; 05:63B2
	dw Data_05_6391 ; track stream pointers (read by the driver)

; ---- data $63B4-$63FD (73 bytes) [CONFIRMED] read as data by executed code (in up to 11/18 scenarios); content class unknown

Data_05_63B4:: ; 05:63B4
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $0A
	sound_cmd_C2 $30
	sound_cmd_C1 $40
	sound_note 6, $39, $18
	sound_wait 1
	sound_cmd_C1 $47
	sound_wait 1
	sound_rs sound_cmd_C1 $4F
	sound_wait 1
	sound_rs sound_cmd_C1 $57
	sound_wait 1
	sound_rs sound_cmd_C1 $5F
	sound_wait 1
	sound_rs sound_cmd_C1 $67
	sound_wait 1
	sound_rs sound_cmd_C1 $40
	sound_note 6, $36
	sound_wait 1
	sound_cmd_C1 $47
	sound_wait 1
	sound_rs sound_cmd_C1 $4F
	sound_wait 1
	sound_rs sound_cmd_C1 $57
	sound_wait 1
	sound_rs sound_cmd_C1 $5F
	sound_wait 1
	sound_rs sound_cmd_C1 $67
	sound_wait 1
	sound_rs sound_cmd_C1 $40
	sound_note 6, $32
	sound_wait 1
	sound_cmd_C1 $47
	sound_wait 1
	sound_rs sound_cmd_C1 $4F
	sound_wait 1
	sound_rs sound_cmd_C1 $57
	sound_wait 1
	sound_rs sound_cmd_C1 $5F
	sound_wait 1
	sound_rs sound_cmd_C1 $67
	sound_wait 1
	sound_rs sound_cmd_C1 $40
	sound_note 6, $2D
	sound_wait 1
	sound_cmd_C1 $47
	sound_wait 1
	sound_rs sound_cmd_C1 $4F
	sound_wait 1
	sound_rs sound_cmd_C1 $57
	sound_wait 1
	sound_rs sound_cmd_C1 $5F
	sound_wait 1
	sound_rs sound_cmd_C1 $67
	sound_wait 1
	sound_end

; ---- data $63FD-$63FF (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 63FF (1 words = NN*(KK+1)); the byte before (63FC) is $B1 [v4: bytes 63FD-63FE were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_63FD:: ; 05:63FD
	sound_stream_header 1, 0

; ---- words $63FF-$6401 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 63FD [v4: bytes 63FF-6401 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_63FF:: ; 05:63FF
	dw Data_05_63B4 ; track stream pointers (read by the driver)

; ---- data $6401-$6410 (15 bytes) [CONFIRMED] read as data by executed code (in up to 11/18 scenarios); content class unknown

Data_05_6401:: ; 05:6401
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $08
	sound_note 3, $6A, $1D
	sound_wait 10
	sound_note 3
	sound_wait 3
	sound_end

; ---- data $6410-$6412 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 6412 (1 words = NN*(KK+1)); the byte before (640F) is $B1 [v4: bytes 6410-6411 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_6410:: ; 05:6410
	sound_stream_header 1, 0

; ---- words $6412-$6414 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6410 [v4: bytes 6412-6414 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_6412:: ; 05:6412
	dw Data_05_6401 ; track stream pointers (read by the driver)

; ---- data $6414-$643C (40 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown

Data_05_6414:: ; 05:6414
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $04
	sound_note 4, $5E, $13
	sound_wait 4
	sound_rs sound_note 4, $5A
	sound_wait 4
	sound_rs sound_note 4, $5E
	sound_wait 4
	sound_rs sound_note 4, $5A
	sound_wait 4
	sound_rs sound_note 4, $61
	sound_wait 4
	sound_end
Data_05_6429:: ; 05:6429
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $09
	sound_note 4, $55, $13
	sound_wait 4
	sound_rs sound_note 4, $52
	sound_wait 4
	sound_rs sound_note 4, $55
	sound_wait 4
	sound_rs sound_note 4, $52
	sound_wait 4
	sound_rs sound_note 4, $5A
	sound_wait 4
	sound_end

; ---- data $643C-$643E (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 643E (2 words = NN*(KK+1)); the byte before (643B) is $B1 [v4: bytes 643C-643D were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_643C:: ; 05:643C
	sound_stream_header 2, 0

; ---- words $643E-$6442 (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 643C [v4: bytes 643E-6442 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_643E:: ; 05:643E
	dw Data_05_6414, Data_05_6429 ; track stream pointers (read by the driver)

; ---- data $6442-$645E (28 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown

Data_05_6442:: ; 05:6442
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $28
	sound_note 4, $36, $16
	sound_wait 8
	sound_note 12
	sound_wait 12
	sound_end
Data_05_6451:: ; 05:6451
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $07
	sound_note 4, $35, $16
	sound_wait 8
	sound_note 12
	sound_wait 12
	sound_end

; ---- data $645E-$6460 (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 6460 (2 words = NN*(KK+1)); the byte before (645D) is $B1 [v4: bytes 645E-645F were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_645E:: ; 05:645E
	sound_stream_header 2, 0

; ---- words $6460-$6464 (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 645E [v4: bytes 6460-6464 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_6460:: ; 05:6460
	dw Data_05_6442, Data_05_6451 ; track stream pointers (read by the driver)

; ---- data $6464-$64B3 (79 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown

Data_05_6464:: ; 05:6464
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_wait 3
	sound_instrument $06
	sound_note 4, $52, $0F
	sound_wait 4
	sound_rs sound_note 4, $56
	sound_wait 4
	sound_rs sound_note 4, $59
	sound_wait 4
	sound_rs sound_note 4, $56
	sound_wait 4
	sound_rs sound_note 4, $59
	sound_wait 4
	sound_rs sound_note 4, $5C
	sound_wait 4
	sound_rs sound_note 4, $60
	sound_wait 4
	sound_end
Data_05_647E:: ; 05:647E
	sound_volume $7F
	sound_pitch_add $00
	sound_wait 3
	sound_instrument $0B
	sound_note 4, $4A, $0F
	sound_wait 4
	sound_rs sound_note 4, $4D
	sound_wait 4
	sound_rs sound_note 4, $52
	sound_wait 4
	sound_rs sound_note 4, $4D
	sound_wait 4
	sound_rs sound_note 4, $52
	sound_wait 4
	sound_rs sound_note 4, $56
	sound_wait 4
	sound_rs sound_note 4, $59
	sound_wait 4
	sound_end
Data_05_6496:: ; 05:6496
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $02
	sound_cmd_C2 $0C
	sound_cmd_C1 $39
	sound_note 2, $53, $18
	sound_wait 1
	sound_cmd_C1 $33
	sound_wait 3
	sound_rs sound_cmd_C1 $40
	sound_note 4, $63
	sound_wait 1
	sound_cmd_C1 $4B
	sound_wait 1
	sound_rs sound_cmd_C1 $57
	sound_wait 1
	sound_rs sound_cmd_C1 $63
	sound_wait 1
	sound_end

; ---- data $64B3-$64B5 (2 bytes) [PROBABLE] header NN=03 KK=00 of the channel-pointer table at 64B5 (3 words = NN*(KK+1)); the byte before (64B2) is $B1 [v4: bytes 64B3-64B4 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_64B3:: ; 05:64B3
	sound_stream_header 3, 0

; ---- words $64B5-$64BB (6 bytes) [PROBABLE] 3 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 64B3 [v4: bytes 64B5-64BB were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_64B5:: ; 05:64B5
	dw Data_05_6464, Data_05_647E, Data_05_6496 ; track stream pointers (read by the driver)

; ---- data $64BB-$6506 (75 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_64BB:: ; 05:64BB
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_wait 3
	sound_instrument $06
	sound_note 4, $53, $0F
	sound_wait 4
	sound_rs sound_note 4, $51
	sound_wait 4
	sound_rs sound_note 4, $4E
	sound_wait 4
	sound_rs sound_note 4, $4B
	sound_wait 4
	sound_rs sound_note 4, $49
	sound_wait 4
	sound_rs sound_note 4, $47
	sound_wait 4
	sound_end
Data_05_64D3:: ; 05:64D3
	sound_volume $7F
	sound_pitch_add $00
	sound_wait 3
	sound_instrument $0B
	sound_note 4, $4B, $0F
	sound_wait 4
	sound_rs sound_note 4, $49
	sound_wait 4
	sound_rs sound_note 4, $45
	sound_wait 4
	sound_rs sound_note 4, $42
	sound_wait 4
	sound_rs sound_note 4, $40
	sound_wait 4
	sound_rs sound_note 4, $3F
	sound_wait 4
	sound_end
Data_05_64E9:: ; 05:64E9
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $02
	sound_cmd_C2 $0C
	sound_cmd_C1 $39
	sound_note 2, $53, $18
	sound_wait 1
	sound_cmd_C1 $33
	sound_wait 3
	sound_rs sound_cmd_C1 $40
	sound_note 4, $63
	sound_wait 1
	sound_cmd_C1 $4B
	sound_wait 1
	sound_rs sound_cmd_C1 $57
	sound_wait 1
	sound_rs sound_cmd_C1 $63
	sound_wait 1
	sound_end

; ---- data $6506-$6508 (2 bytes) [PROBABLE] header NN=03 KK=00 of the channel-pointer table at 6508 (3 words = NN*(KK+1)); the byte before (6505) is $B1

Data_05_6506:: ; 05:6506
	sound_stream_header 3, 0

; ---- words $6508-$650E (6 bytes) [PROBABLE] 3 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6506

Table_05_6508:: ; 05:6508
	dw Data_05_64BB, Data_05_64D3, Data_05_64E9 ; track stream pointers (read by the driver)

; ---- data $650E-$6544 (54 bytes) [CONFIRMED] read as data by executed code (in up to 6/18 scenarios); content class unknown

Data_05_650E:: ; 05:650E
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $11
	sound_cmd_C2 $30
	sound_cmd_C1 $40
	sound_note 6, $31, $18
	sound_wait 1
	sound_cmd_C1 $47
	sound_wait 2
	sound_rs sound_cmd_C1 $4F
	sound_wait 1
	sound_rs sound_cmd_C1 $57
	sound_wait 4
	sound_rs sound_cmd_C1 $40
	sound_wait 1
	sound_instrument $10
	sound_note 12, $47
	sound_wait 2
	sound_cmd_C1 $47
	sound_wait 3
	sound_rs sound_cmd_C1 $4F
	sound_wait 1
	sound_rs sound_cmd_C1 $57
	sound_wait 2
	sound_rs sound_cmd_C1 $5F
	sound_wait 2
	sound_rs sound_cmd_C1 $67
	sound_wait 2
	sound_end
Data_05_6538:: ; 05:6538
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $05
	sound_wait 9
	sound_note 12, $64, $13
	sound_wait 12
	sound_end

; ---- data $6544-$6546 (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 6546 (2 words = NN*(KK+1)); the byte before (6543) is $B1 [v4: bytes 6544-6545 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_6544:: ; 05:6544
	sound_stream_header 2, 0

; ---- words $6546-$654A (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6544 [v4: bytes 6546-654A were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_6546:: ; 05:6546
	dw Data_05_650E, Data_05_6538 ; track stream pointers (read by the driver)

; ---- data $654A-$6568 (30 bytes) [CONFIRMED] read as data by executed code (in up to 6/18 scenarios); content class unknown

Data_05_654A:: ; 05:654A
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $11
	sound_cmd_C2 $1C
	sound_cmd_C1 $40
	sound_note 14, $45, $18
	sound_wait 2
	sound_cmd_C1 $38
	sound_wait 2
	sound_rs sound_cmd_C1 $30
	sound_wait 2
	sound_rs sound_cmd_C1 $28
	sound_wait 2
	sound_rs sound_cmd_C1 $20
	sound_wait 2
	sound_rs sound_cmd_C1 $18
	sound_wait 2
	sound_rs sound_cmd_C1 $11
	sound_wait 2
	sound_end

; ---- data $6568-$656A (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 656A (1 words = NN*(KK+1)); the byte before (6567) is $B1 [v4: bytes 6568-6569 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_6568:: ; 05:6568
	sound_stream_header 1, 0

; ---- words $656A-$656C (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6568 [v4: bytes 656A-656C were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_656A:: ; 05:656A
	dw Data_05_654A ; track stream pointers (read by the driver)

; ---- data $656C-$6580 (20 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown

Data_05_656C:: ; 05:656C
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $05
	sound_cmd_C2 $30
	sound_cmd_C1 $40
	sound_note 2, $53, $13
	sound_wait 1
	sound_cmd_C1 $4F
	sound_wait 1
	sound_end

; ---- data $6580-$6582 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 6582 (1 words = NN*(KK+1)); the byte before (657F) is $B1 [v4: bytes 6580-6581 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_6580:: ; 05:6580
	sound_stream_header 1, 0

; ---- words $6582-$6584 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6580 [v4: bytes 6582-6584 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_6582:: ; 05:6582
	dw Data_05_656C ; track stream pointers (read by the driver)

; ---- data $6584-$6595 (17 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_6584:: ; 05:6584
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $05
	sound_cmd_C2 $30
	sound_cmd_C1 $30
	sound_note 1, $56, $13
	sound_wait 1
	sound_end

; ---- data $6595-$6597 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 6597 (1 words = NN*(KK+1)); the byte before (6594) is $B1

Data_05_6595:: ; 05:6595
	sound_stream_header 1, 0

; ---- words $6597-$6599 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6595

Table_05_6597:: ; 05:6597
	dw Data_05_6584 ; track stream pointers (read by the driver)

; ---- data $6599-$65C3 (42 bytes) [CONFIRMED] read as data by executed code (in up to 10/18 scenarios); content class unknown

Data_05_6599:: ; 05:6599
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $10
	sound_cmd_C2 $30
	sound_cmd_C1 $40
	sound_note 6, $45, $18
	sound_wait 1
	sound_cmd_C1 $3C
	sound_wait 1
	sound_rs sound_cmd_C1 $38
	sound_wait 1
	sound_rs sound_cmd_C1 $34
	sound_wait 1
	sound_rs sound_cmd_C1 $30
	sound_wait 1
	sound_rs sound_cmd_C1 $2C
	sound_wait 10
	sound_instrument $05
	sound_cmd_C1 $40
	sound_note 4, $56
	sound_wait 1
	sound_cmd_C1 $47
	sound_wait 1
	sound_rs sound_cmd_C1 $4F
	sound_wait 1
	sound_rs sound_cmd_C1 $57
	sound_wait 1
	sound_end

; ---- data $65C3-$65C5 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 65C5 (1 words = NN*(KK+1)); the byte before (65C2) is $B1 [v4: bytes 65C3-65C4 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_65C3:: ; 05:65C3
	sound_stream_header 1, 0

; ---- words $65C5-$65C7 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 65C3 [v4: bytes 65C5-65C7 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_65C5:: ; 05:65C5
	dw Data_05_6599 ; track stream pointers (read by the driver)

; ---- data $65C7-$65FD (54 bytes) [CONFIRMED] read as data by executed code (in up to 10/18 scenarios); content class unknown

Data_05_65C7:: ; 05:65C7
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $12
	sound_cmd_C2 $1A
	sound_cmd_C1 $40
	sound_note 1, $40, $0E
	sound_wait 1
	sound_cmd_C1 $38
	sound_note 3, $5B, $18
	sound_wait 2
	sound_cmd_C1 $30
	sound_wait 3
	sound_rs sound_cmd_C1 $40
	sound_note 1, $40, $0E
	sound_wait 1
	sound_cmd_C1 $38
	sound_note 3, $5B, $18
	sound_wait 2
	sound_cmd_C1 $30
	sound_wait 3
	sound_rs sound_cmd_C1 $40
	sound_note 1, $40, $0E
	sound_wait 1
	sound_cmd_C1 $38
	sound_note 3, $5B, $18
	sound_wait 2
	sound_cmd_C1 $30
	sound_wait 1
	sound_end

; ---- data $65FD-$65FF (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 65FF (1 words = NN*(KK+1)); the byte before (65FC) is $B1 [v4: bytes 65FD-65FE were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_65FD:: ; 05:65FD
	sound_stream_header 1, 0

; ---- words $65FF-$6601 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 65FD [v4: bytes 65FF-6601 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_65FF:: ; 05:65FF
	dw Data_05_65C7 ; track stream pointers (read by the driver)

; ---- data $6601-$6612 (17 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown

Data_05_6601:: ; 05:6601
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $06
	sound_note 2, $5D, $13
	sound_wait 2
	sound_rs sound_note 2, $5A
	sound_wait 2
	sound_rs sound_note 2, $61
	sound_wait 2
	sound_end

; ---- data $6612-$6614 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 6614 (1 words = NN*(KK+1)); the byte before (6611) is $B1 [v4: bytes 6612-6613 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_6612:: ; 05:6612
	sound_stream_header 1, 0

; ---- words $6614-$6616 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6612 [v4: bytes 6614-6616 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_6614:: ; 05:6614
	dw Data_05_6601 ; track stream pointers (read by the driver)

; ---- data $6616-$662F (25 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_6616:: ; 05:6616
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $32
	sound_cmd_C2 $30
	sound_cmd_C1 $40
	sound_wait 15
	sound_note 10, $51, $18
	sound_wait 1
	sound_cmd_C1 $34
	sound_wait 1
	sound_rs sound_cmd_C1 $28
	sound_wait 1
	sound_rs sound_cmd_C1 $1C
	sound_wait 7
	sound_end

; ---- data $662F-$6631 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 6631 (1 words = NN*(KK+1)); the byte before (662E) is $B1

Data_05_662F:: ; 05:662F
	sound_stream_header 1, 0

; ---- words $6631-$6633 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 662F

Table_05_6631:: ; 05:6631
	dw Data_05_6616 ; track stream pointers (read by the driver)

; ---- data $6633-$665B (40 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_6633:: ; 05:6633
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $04
	sound_note 6, $54, $14
	sound_wait 6
	sound_rs sound_note 6, $59
	sound_wait 6
	sound_rs sound_note 6, $58
	sound_wait 6
	sound_rs sound_note 6, $5B
	sound_wait 6
	sound_rs sound_note 6, $60
	sound_wait 6
	sound_end
Data_05_6648:: ; 05:6648
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $20
	sound_note 6, $4C, $14
	sound_wait 6
	sound_rs sound_note 6, $52
	sound_wait 6
	sound_rs sound_note 6, $4F
	sound_wait 6
	sound_rs sound_note 6, $54
	sound_wait 6
	sound_rs sound_note 6, $58
	sound_wait 6
	sound_end

; ---- data $665B-$665D (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 665D (2 words = NN*(KK+1)); the byte before (665A) is $B1

Data_05_665B:: ; 05:665B
	sound_stream_header 2, 0

; ---- words $665D-$6661 (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 665B

Table_05_665D:: ; 05:665D
	dw Data_05_6633, Data_05_6648 ; track stream pointers (read by the driver)

; ---- data $6661-$66BF (94 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_6661:: ; 05:6661
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $4A
	sound_cmd_C5 $30
	sound_cmd_C2 $04
	sound_cmd_C3 $40
	sound_cmd_C1 $33
	sound_note 3, $51, $17
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 2
	sound_note_mod 4, $13
	sound_wait 1
	sound_cmd_C1 $4F
	sound_wait 1
	sound_rs sound_cmd_C1 $5F
	sound_wait 1
	sound_rs sound_cmd_C1 $6E
	sound_wait 4
	sound_rs sound_cmd_C1 $33
	sound_note 18, $4D, $17
	sound_wait 14
	sound_cmd_C1 $40
	sound_wait 1
	sound_rs sound_cmd_C1 $46
	sound_wait 1
	sound_rs sound_cmd_C1 $4C
	sound_wait 1
	sound_rs sound_cmd_C1 $52
	sound_wait 1
	sound_end
Data_05_6691:: ; 05:6691
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $36
	sound_cmd_C5 $30
	sound_cmd_C2 $04
	sound_cmd_C3 $40
	sound_cmd_C1 $33
	sound_note 3, $4C, $15
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 2
	sound_note_mod 4, $11
	sound_wait 1
	sound_cmd_C1 $4F
	sound_wait 1
	sound_rs sound_cmd_C1 $5F
	sound_wait 1
	sound_rs sound_cmd_C1 $6E
	sound_wait 4
	sound_rs sound_cmd_C1 $33
	sound_note 18, $48, $15
	sound_wait 14
	sound_cmd_C1 $40
	sound_wait 1
	sound_rs sound_cmd_C1 $46
	sound_wait 1
	sound_rs sound_cmd_C1 $4C
	sound_wait 1
	sound_rs sound_cmd_C1 $52
	sound_wait 1
	sound_end

; ---- data $66BF-$66C1 (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 66C1 (2 words = NN*(KK+1)); the byte before (66BE) is $B1 [v4: bytes 66BF-66C0 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_66BF:: ; 05:66BF
	sound_stream_header 2, 0

; ---- words $66C1-$66C5 (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 66BF [v4: bytes 66C1-66C5 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_66C1:: ; 05:66C1
	dw Data_05_6661, Data_05_6691 ; track stream pointers (read by the driver)

; ---- data $66C5-$66F2 (45 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_66C5:: ; 05:66C5
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $02
	sound_note 4, $46, $14
	sound_wait 5
	sound_rs sound_note 4, $4A
	sound_wait 5
	sound_rs sound_note 4, $4D
	sound_wait 5
	sound_rs sound_note 4, $4B
	sound_wait 5
	sound_rs sound_note 4, $50
	sound_wait 5
	sound_rs sound_note 4, $52
	sound_wait 4
	sound_end
Data_05_66DC:: ; 05:66DC
	sound_volume $7F
	sound_pitch_add $00
	sound_wait 5
	sound_instrument $06
	sound_note 4, $46, $09
	sound_wait 5
	sound_rs sound_note 4, $4A
	sound_wait 5
	sound_rs sound_note 4, $4D
	sound_wait 5
	sound_rs sound_note 4, $4B
	sound_wait 5
	sound_rs sound_note 4, $50
	sound_wait 5
	sound_rs sound_note 4, $52
	sound_wait 4
	sound_end

; ---- data $66F2-$66F4 (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 66F4 (2 words = NN*(KK+1)); the byte before (66F1) is $B1 [v4: bytes 66F2-66F3 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_66F2:: ; 05:66F2
	sound_stream_header 2, 0

; ---- words $66F4-$66F8 (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 66F2 [v4: bytes 66F4-66F8 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_66F4:: ; 05:66F4
	dw Data_05_66C5, Data_05_66DC ; track stream pointers (read by the driver)

; ---- data $66F8-$6725 (45 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_66F8:: ; 05:66F8
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $02
	sound_note 4, $4E, $14
	sound_wait 5
	sound_rs sound_note 4, $4C
	sound_wait 5
	sound_rs sound_note 4, $47
	sound_wait 5
	sound_rs sound_note 4, $46
	sound_wait 5
	sound_rs sound_note 4, $49
	sound_wait 5
	sound_rs sound_note 4, $42
	sound_wait 4
	sound_end
Data_05_670F:: ; 05:670F
	sound_volume $7F
	sound_pitch_add $00
	sound_wait 5
	sound_instrument $06
	sound_note 4, $4E, $09
	sound_wait 5
	sound_rs sound_note 4, $4C
	sound_wait 5
	sound_rs sound_note 4, $47
	sound_wait 5
	sound_rs sound_note 4, $46
	sound_wait 5
	sound_rs sound_note 4, $49
	sound_wait 5
	sound_rs sound_note 4, $42
	sound_wait 4
	sound_end

; ---- data $6725-$6727 (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 6727 (2 words = NN*(KK+1)); the byte before (6724) is $B1 [v4: bytes 6725-6726 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_6725:: ; 05:6725
	sound_stream_header 2, 0

; ---- words $6727-$672B (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6725 [v4: bytes 6727-672B were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_6727:: ; 05:6727
	dw Data_05_66F8, Data_05_670F ; track stream pointers (read by the driver)

; ---- data $672B-$673C (17 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

Data_05_672B:: ; 05:672B
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $08
	sound_note 4, $59, $16
	sound_wait 4
	sound_rs sound_note 4, $56
	sound_wait 4
	sound_rs sound_note 4, $5E
	sound_wait 4
	sound_end

; ---- data $673C-$673E (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 673E (1 words = NN*(KK+1)); the byte before (673B) is $B1 [v4: bytes 673C-673D were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_673C:: ; 05:673C
	sound_stream_header 1, 0

; ---- words $673E-$6740 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 673C [v4: bytes 673E-6740 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_673E:: ; 05:673E
	dw Data_05_672B ; track stream pointers (read by the driver)

; ---- data $6740-$6751 (17 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

Data_05_6740:: ; 05:6740
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $08
	sound_note 4, $5C, $16
	sound_wait 4
	sound_rs sound_note 4, $56
	sound_wait 4
	sound_rs sound_note 4, $52
	sound_wait 4
	sound_end

; ---- data $6751-$6753 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 6753 (1 words = NN*(KK+1)); the byte before (6750) is $B1 [v4: bytes 6751-6752 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_6751:: ; 05:6751
	sound_stream_header 1, 0

; ---- words $6753-$6755 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6751 [v4: bytes 6753-6755 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_6753:: ; 05:6753
	dw Data_05_6740 ; track stream pointers (read by the driver)

; ---- data $6755-$6789 (52 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown

Data_05_6755:: ; 05:6755
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $4B
	sound_cmd_C2 $2A
	sound_cmd_C1 $40
	sound_note 18, $34, $1B
	sound_wait 1
	sound_cmd_C1 $43
	sound_wait 1
	sound_rs sound_cmd_C1 $47
	sound_wait 1
	sound_rs sound_cmd_C1 $4A
	sound_wait 1
	sound_rs sound_cmd_C1 $4E
	sound_wait 1
	sound_rs sound_cmd_C1 $51
	sound_wait 1
	sound_rs sound_cmd_C1 $55
	sound_wait 1
	sound_rs sound_cmd_C1 $58
	sound_wait 1
	sound_rs sound_cmd_C1 $5C
	sound_wait 1
	sound_rs sound_cmd_C1 $5F
	sound_wait 1
	sound_rs sound_cmd_C1 $63
	sound_wait 1
	sound_rs sound_cmd_C1 $66
	sound_wait 1
	sound_rs sound_cmd_C1 $6A
	sound_wait 1
	sound_rs sound_cmd_C1 $6E
	sound_wait 1
	sound_rs sound_cmd_C1 $71
	sound_wait 1
	sound_rs sound_cmd_C1 $75
	sound_wait 1
	sound_rs sound_cmd_C1 $78
	sound_wait 1
	sound_rs sound_cmd_C1 $7C
	sound_wait 1
	sound_end

; ---- data $6789-$678B (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 678B (1 words = NN*(KK+1)); the byte before (6788) is $B1 [v4: bytes 6789-678A were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_6789:: ; 05:6789
	sound_stream_header 1, 0

; ---- words $678B-$678D (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6789 [v4: bytes 678B-678D were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_678B:: ; 05:678B
	dw Data_05_6755 ; track stream pointers (read by the driver)

; ---- data $678D-$67B5 (40 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_678D:: ; 05:678D
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $04
	sound_note 6, $54, $14
	sound_wait 6
	sound_rs sound_note 6, $59
	sound_wait 6
	sound_rs sound_note 6, $58
	sound_wait 6
	sound_rs sound_note 6, $5B
	sound_wait 6
	sound_rs sound_note 6, $60
	sound_wait 6
	sound_end
Data_05_67A2:: ; 05:67A2
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $20
	sound_note 6, $4C, $14
	sound_wait 6
	sound_rs sound_note 6, $52
	sound_wait 6
	sound_rs sound_note 6, $4F
	sound_wait 6
	sound_rs sound_note 6, $54
	sound_wait 6
	sound_rs sound_note 6, $58
	sound_wait 6
	sound_end

; ---- data $67B5-$67B7 (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 67B7 (2 words = NN*(KK+1)); the byte before (67B4) is $B1

Data_05_67B5:: ; 05:67B5
	sound_stream_header 2, 0

; ---- words $67B7-$67BB (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 67B5

Table_05_67B7:: ; 05:67B7
	dw Data_05_678D, Data_05_67A2 ; track stream pointers (read by the driver)

; ---- data $67BB-$6822 (103 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown

Data_05_67BB:: ; 05:67BB
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $02
	sound_note 3, $52, $13
	sound_wait 3
	sound_rs sound_note 3, $53, $11
	sound_wait 3
	sound_rs sound_note 3, $54
	sound_wait 3
	sound_rs sound_note 3, $55
	sound_wait 3
	sound_note 3, $56, $0F
	sound_wait 3
	sound_rs sound_note 3, $57
	sound_wait 3
	sound_rs sound_note 3, $58
	sound_wait 3
	sound_note 3, $59, $0D
	sound_wait 3
	sound_rs sound_note 3, $5A
	sound_wait 3
	sound_rs sound_note 3, $5B
	sound_wait 3
	sound_note 3, $5C, $0B
	sound_wait 3
	sound_rs sound_note 3, $5D
	sound_wait 3
	sound_rs sound_note 3, $5E
	sound_wait 3
	sound_note 3, $5F, $09
	sound_wait 3
	sound_rs sound_note 3, $60
	sound_wait 3
	sound_rs sound_note 3, $61
	sound_wait 3
	sound_end
Data_05_67EF:: ; 05:67EF
	sound_volume $7F
	sound_pitch_add $00
	sound_wait 6
	sound_instrument $06
	sound_note 3, $52, $0F
	sound_wait 3
	sound_rs sound_note 3, $53, $0D
	sound_wait 3
	sound_rs sound_note 3, $54
	sound_wait 3
	sound_rs sound_note 3, $55
	sound_wait 3
	sound_note 3, $56, $0B
	sound_wait 3
	sound_rs sound_note 3, $57
	sound_wait 3
	sound_rs sound_note 3, $58
	sound_wait 3
	sound_note 3, $59, $09
	sound_wait 3
	sound_rs sound_note 3, $5A
	sound_wait 3
	sound_rs sound_note 3, $5B
	sound_wait 3
	sound_note 3, $5C, $07
	sound_wait 3
	sound_rs sound_note 3, $5D
	sound_wait 3
	sound_rs sound_note 3, $5E
	sound_wait 3
	sound_note 3, $5F, $05
	sound_wait 3
	sound_rs sound_note 3, $60
	sound_wait 3
	sound_rs sound_note 3, $61
	sound_wait 3
	sound_end

; ---- data $6822-$6824 (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 6824 (2 words = NN*(KK+1)); the byte before (6821) is $B1 [v4: bytes 6822-6823 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_6822:: ; 05:6822
	sound_stream_header 2, 0

; ---- words $6824-$6828 (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6822 [v4: bytes 6824-6828 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_6824:: ; 05:6824
	dw Data_05_67BB, Data_05_67EF ; track stream pointers (read by the driver)

; ---- data $6828-$689B (115 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

Data_05_6828:: ; 05:6828
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $02
	sound_note 3, $5F, $13
	sound_wait 3
	sound_rs sound_note 3, $5E, $11
	sound_wait 3
	sound_rs sound_note 3, $5D
	sound_wait 3
	sound_rs sound_note 3, $5C
	sound_wait 3
	sound_note 3, $5B, $0F
	sound_wait 3
	sound_rs sound_note 3, $5A
	sound_wait 3
	sound_rs sound_note 3, $59
	sound_wait 3
	sound_note 3, $58, $0D
	sound_wait 3
	sound_rs sound_note 3, $57
	sound_wait 3
	sound_rs sound_note 3, $56
	sound_wait 3
	sound_rs sound_note 3, $55
	sound_wait 3
	sound_note 3, $54, $0B
	sound_wait 3
	sound_rs sound_note 3, $53
	sound_wait 3
	sound_rs sound_note 3, $52
	sound_wait 3
	sound_rs sound_note 3, $51
	sound_wait 3
	sound_note 3, $50, $09
	sound_wait 3
	sound_rs sound_note 3, $4F
	sound_wait 3
	sound_rs sound_note 3, $4E
	sound_wait 3
	sound_rs sound_note 3, $4D
	sound_wait 3
	sound_end
Data_05_6862:: ; 05:6862
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $06
	sound_wait 6
	sound_note 3, $5F, $0F
	sound_wait 3
	sound_rs sound_note 3, $5E, $0D
	sound_wait 3
	sound_rs sound_note 3, $5D
	sound_wait 3
	sound_rs sound_note 3, $5C
	sound_wait 3
	sound_note 3, $5B, $0B
	sound_wait 3
	sound_rs sound_note 3, $5A
	sound_wait 3
	sound_rs sound_note 3, $59
	sound_wait 3
	sound_note 3, $58, $09
	sound_wait 3
	sound_rs sound_note 3, $57
	sound_wait 3
	sound_rs sound_note 3, $56
	sound_wait 3
	sound_rs sound_note 3, $55
	sound_wait 3
	sound_note 3, $54, $07
	sound_wait 3
	sound_rs sound_note 3, $53
	sound_wait 3
	sound_rs sound_note 3, $52
	sound_wait 3
	sound_rs sound_note 3, $51
	sound_wait 3
	sound_note 3, $50, $05
	sound_wait 3
	sound_rs sound_note 3, $4F
	sound_wait 3
	sound_rs sound_note 3, $4E
	sound_wait 3
	sound_rs sound_note 3, $4D
	sound_wait 3
	sound_end

; ---- data $689B-$689D (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 689D (2 words = NN*(KK+1)); the byte before (689A) is $B1 [v4: bytes 689B-689C were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_689B:: ; 05:689B
	sound_stream_header 2, 0

; ---- words $689D-$68A1 (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 689B [v4: bytes 689D-68A1 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_689D:: ; 05:689D
	dw Data_05_6828, Data_05_6862 ; track stream pointers (read by the driver)

; ---- data $68A1-$68BE (29 bytes) [CONFIRMED] read as data by executed code (in up to 17/18 scenarios); content class unknown

Data_05_68A1:: ; 05:68A1
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $08
	sound_note 3, $59, $1D
	sound_wait 8
	sound_note 3
	sound_wait 3
	sound_end
Data_05_68B0:: ; 05:68B0
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $06
	sound_note 3, $60, $0B
	sound_wait 8
	sound_note 3
	sound_wait 3
	sound_end
Data_05_68BD:: ; 05:68BD
	db $02 ; start of `sound_stream_header 2, 0`; a label lies inside this command

; ---- data $68BE-$68BF (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_68BE:: ; 05:68BE
	db $00 ; rest of `sound_stream_header 2, 0`

; ---- data $68BF-$68C3 (4 bytes) [CONFIRMED] read as data by executed code (in up to 17/18 scenarios); content class unknown [v4: this is the 46th channel-pointer table (header b1 02 00 at 68BC, referenced by the song-table entry 04:5740 -> 68BD): 2 words A1 68 B0 68 = track starts 68A1 and 68B0 (both bf 7f bd); kept as data because it is CONFIRMED-read and has no following track]

Data_05_68BF:: ; 05:68BF
	dw Data_05_68A1, Data_05_68B0 ; track stream pointers (read by the driver)
