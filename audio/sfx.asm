; audio/sfx.asm
; bank 05, $631A-$68C3 (1449 bytes); pinned by layout.link
; sound effects, ids 29-46 (30 headers end-to-end)

SECTION "audio/sfx", ROMX

; ---- data $631A-$632A (16 bytes) [CONFIRMED] read as data by executed code (in up to 14/18 scenarios); content class unknown

Data_05_631A:: ; 05:631A
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $06, $D0, $58, $0E, $81, $5D, $18, $81, $B1

; ---- data $632A-$632C (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 632C (1 words = NN*(KK+1)); the byte before (6329) is $B1 [v4: bytes 632A-632B were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_632A:: ; 05:632A
	db $01, $00

; ---- words $632C-$632E (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 632A [v4: bytes 632C-632E were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_632C:: ; 05:632C
	dw Data_05_631A

; ---- data $632E-$634A (28 bytes) [CONFIRMED] read as data by executed code (in up to 14/18 scenarios); content class unknown

Data_05_632E:: ; 05:632E
	db $BF, $7F, $BD, $00, $BC, $4A, $C5, $48, $C2, $0C, $C3, $40, $C1, $40, $DD, $39
	db $0E, $8E, $BE, $06, $D0, $58, $11, $81, $5D, $18, $81, $B1

; ---- data $634A-$634C (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 634C (1 words = NN*(KK+1)); the byte before (6349) is $B1 [v4: bytes 634A-634B were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_634A:: ; 05:634A
	db $01, $00

; ---- words $634C-$634E (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 634A [v4: bytes 634C-634E were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_634C:: ; 05:634C
	dw Data_05_632E

; ---- data $634E-$636A (28 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

Data_05_634E:: ; 05:634E
	db $BF, $7F, $BD, $00, $BC, $4A, $C5, $48, $C2, $0C, $C3, $40, $C1, $40, $DF, $39
	db $0E, $90, $BE, $06, $D0, $58, $11, $81, $5D, $18, $81, $B1

; ---- data $636A-$636C (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 636C (1 words = NN*(KK+1)); the byte before (6369) is $B1 [v4: bytes 636A-636B were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_636A:: ; 05:636A
	db $01, $00

; ---- words $636C-$636E (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 636A [v4: bytes 636C-636E were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_636C:: ; 05:636C
	dw Data_05_634E

; ---- data $636E-$638D (31 bytes) [CONFIRMED] read as data by executed code (in up to 17/18 scenarios); content class unknown

Data_05_636E:: ; 05:636E
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $06, $C2, $0C, $C1, $39, $D1, $53, $17, $81
	db $C1, $33, $83, $40, $D3, $63, $81, $C1, $4B, $81, $57, $81, $63, $81, $B1

; ---- data $638D-$638F (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 638F (1 words = NN*(KK+1)); the byte before (638C) is $B1 [v4: bytes 638D-638E were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_638D:: ; 05:638D
	db $01, $00

; ---- words $638F-$6391 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 638D [v4: bytes 638F-6391 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_638F:: ; 05:638F
	dw Data_05_636E

; ---- data $6391-$63B0 (31 bytes) [CONFIRMED] read as data by executed code (in up to 17/18 scenarios); content class unknown

Data_05_6391:: ; 05:6391
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $06, $C2, $0C, $C1, $39, $D1, $53, $17, $81
	db $C1, $33, $83, $40, $D3, $63, $81, $C1, $4B, $81, $57, $81, $63, $81, $B1

; ---- data $63B0-$63B2 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 63B2 (1 words = NN*(KK+1)); the byte before (63AF) is $B1 [v4: bytes 63B0-63B1 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_63B0:: ; 05:63B0
	db $01, $00

; ---- words $63B2-$63B4 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 63B0 [v4: bytes 63B2-63B4 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_63B2:: ; 05:63B2
	dw Data_05_6391

; ---- data $63B4-$63FD (73 bytes) [CONFIRMED] read as data by executed code (in up to 11/18 scenarios); content class unknown

Data_05_63B4:: ; 05:63B4
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $0A, $C2, $30, $C1, $40, $D5, $39, $18, $81
	db $C1, $47, $81, $4F, $81, $57, $81, $5F, $81, $67, $81, $40, $D5, $36, $81, $C1
	db $47, $81, $4F, $81, $57, $81, $5F, $81, $67, $81, $40, $D5, $32, $81, $C1, $47
	db $81, $4F, $81, $57, $81, $5F, $81, $67, $81, $40, $D5, $2D, $81, $C1, $47, $81
	db $4F, $81, $57, $81, $5F, $81, $67, $81, $B1

; ---- data $63FD-$63FF (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 63FF (1 words = NN*(KK+1)); the byte before (63FC) is $B1 [v4: bytes 63FD-63FE were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_63FD:: ; 05:63FD
	db $01, $00

; ---- words $63FF-$6401 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 63FD [v4: bytes 63FF-6401 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_63FF:: ; 05:63FF
	dw Data_05_63B4

; ---- data $6401-$6410 (15 bytes) [CONFIRMED] read as data by executed code (in up to 11/18 scenarios); content class unknown

Data_05_6401:: ; 05:6401
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $08, $D2, $6A, $1D, $8A, $D2, $83, $B1

; ---- data $6410-$6412 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 6412 (1 words = NN*(KK+1)); the byte before (640F) is $B1 [v4: bytes 6410-6411 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_6410:: ; 05:6410
	db $01, $00

; ---- words $6412-$6414 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6410 [v4: bytes 6412-6414 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_6412:: ; 05:6412
	dw Data_05_6401

; ---- data $6414-$643C (40 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown

Data_05_6414:: ; 05:6414
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $04, $D3, $5E, $13, $84, $5A, $84, $5E, $84
	db $5A, $84, $61, $84, $B1, $BF, $7F, $BD, $00, $BE, $09, $D3, $55, $13, $84, $52
	db $84, $55, $84, $52, $84, $5A, $84, $B1

; ---- data $643C-$643E (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 643E (2 words = NN*(KK+1)); the byte before (643B) is $B1 [v4: bytes 643C-643D were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_643C:: ; 05:643C
	db $02, $00

; ---- words $643E-$6442 (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 643C [v4: bytes 643E-6442 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_643E:: ; 05:643E
	dw Data_05_6414, $6429

; ---- data $6442-$645E (28 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown

Data_05_6442:: ; 05:6442
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $28, $D3, $36, $16, $88, $DB, $8C, $B1, $BF
	db $7F, $BD, $00, $BE, $07, $D3, $35, $16, $88, $DB, $8C, $B1

; ---- data $645E-$6460 (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 6460 (2 words = NN*(KK+1)); the byte before (645D) is $B1 [v4: bytes 645E-645F were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_645E:: ; 05:645E
	db $02, $00

; ---- words $6460-$6464 (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 645E [v4: bytes 6460-6464 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_6460:: ; 05:6460
	dw Data_05_6442, $6451

; ---- data $6464-$64B3 (79 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown

Data_05_6464:: ; 05:6464
	db $BF, $7F, $BD, $00, $BC, $4A, $83, $BE, $06, $D3, $52, $0F, $84, $56, $84, $59
	db $84, $56, $84, $59, $84, $5C, $84, $60, $84, $B1, $BF, $7F, $BD, $00, $83, $BE
	db $0B, $D3, $4A, $0F, $84, $4D, $84, $52, $84, $4D, $84, $52, $84, $56, $84, $59
	db $84, $B1, $BF, $7F, $BD, $00, $BE, $02, $C2, $0C, $C1, $39, $D1, $53, $18, $81
	db $C1, $33, $83, $40, $D3, $63, $81, $C1, $4B, $81, $57, $81, $63, $81, $B1

; ---- data $64B3-$64B5 (2 bytes) [PROBABLE] header NN=03 KK=00 of the channel-pointer table at 64B5 (3 words = NN*(KK+1)); the byte before (64B2) is $B1 [v4: bytes 64B3-64B4 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_64B3:: ; 05:64B3
	db $03, $00

; ---- words $64B5-$64BB (6 bytes) [PROBABLE] 3 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 64B3 [v4: bytes 64B5-64BB were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_64B5:: ; 05:64B5
	dw Data_05_6464, $647E, $6496

; ---- data $64BB-$6506 (75 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_64BB:: ; 05:64BB
	db $BF, $7F, $BD, $00, $BC, $4A, $83, $BE, $06, $D3, $53, $0F, $84, $51, $84, $4E
	db $84, $4B, $84, $49, $84, $47, $84, $B1, $BF, $7F, $BD, $00, $83, $BE, $0B, $D3
	db $4B, $0F, $84, $49, $84, $45, $84, $42, $84, $40, $84, $3F, $84, $B1, $BF, $7F
	db $BD, $00, $BE, $02, $C2, $0C, $C1, $39, $D1, $53, $18, $81, $C1, $33, $83, $40
	db $D3, $63, $81, $C1, $4B, $81, $57, $81, $63, $81, $B1

; ---- data $6506-$6508 (2 bytes) [PROBABLE] header NN=03 KK=00 of the channel-pointer table at 6508 (3 words = NN*(KK+1)); the byte before (6505) is $B1

Data_05_6506:: ; 05:6506
	db $03, $00

; ---- words $6508-$650E (6 bytes) [PROBABLE] 3 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6506

Table_05_6508:: ; 05:6508
	dw Data_05_64BB, $64D3, $64E9

; ---- data $650E-$6544 (54 bytes) [CONFIRMED] read as data by executed code (in up to 6/18 scenarios); content class unknown

Data_05_650E:: ; 05:650E
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $11, $C2, $30, $C1, $40, $D5, $31, $18, $81
	db $C1, $47, $82, $4F, $81, $57, $84, $40, $81, $BE, $10, $DB, $47, $82, $C1, $47
	db $83, $4F, $81, $57, $82, $5F, $82, $67, $82, $B1, $BF, $7F, $BD, $00, $BE, $05
	db $89, $DB, $64, $13, $8C, $B1

; ---- data $6544-$6546 (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 6546 (2 words = NN*(KK+1)); the byte before (6543) is $B1 [v4: bytes 6544-6545 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_6544:: ; 05:6544
	db $02, $00

; ---- words $6546-$654A (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6544 [v4: bytes 6546-654A were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_6546:: ; 05:6546
	dw Data_05_650E, $6538

; ---- data $654A-$6568 (30 bytes) [CONFIRMED] read as data by executed code (in up to 6/18 scenarios); content class unknown

Data_05_654A:: ; 05:654A
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $11, $C2, $1C, $C1, $40, $DD, $45, $18, $82
	db $C1, $38, $82, $30, $82, $28, $82, $20, $82, $18, $82, $11, $82, $B1

; ---- data $6568-$656A (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 656A (1 words = NN*(KK+1)); the byte before (6567) is $B1 [v4: bytes 6568-6569 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_6568:: ; 05:6568
	db $01, $00

; ---- words $656A-$656C (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6568 [v4: bytes 656A-656C were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_656A:: ; 05:656A
	dw Data_05_654A

; ---- data $656C-$6580 (20 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown

Data_05_656C:: ; 05:656C
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $05, $C2, $30, $C1, $40, $D1, $53, $13, $81
	db $C1, $4F, $81, $B1

; ---- data $6580-$6582 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 6582 (1 words = NN*(KK+1)); the byte before (657F) is $B1 [v4: bytes 6580-6581 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_6580:: ; 05:6580
	db $01, $00

; ---- words $6582-$6584 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6580 [v4: bytes 6582-6584 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_6582:: ; 05:6582
	dw Data_05_656C

; ---- data $6584-$6595 (17 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_6584:: ; 05:6584
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $05, $C2, $30, $C1, $30, $D0, $56, $13, $81
	db $B1

; ---- data $6595-$6597 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 6597 (1 words = NN*(KK+1)); the byte before (6594) is $B1

Data_05_6595:: ; 05:6595
	db $01, $00

; ---- words $6597-$6599 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6595

Table_05_6597:: ; 05:6597
	dw Data_05_6584

; ---- data $6599-$65C3 (42 bytes) [CONFIRMED] read as data by executed code (in up to 10/18 scenarios); content class unknown

Data_05_6599:: ; 05:6599
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $10, $C2, $30, $C1, $40, $D5, $45, $18, $81
	db $C1, $3C, $81, $38, $81, $34, $81, $30, $81, $2C, $8A, $BE, $05, $C1, $40, $D3
	db $56, $81, $C1, $47, $81, $4F, $81, $57, $81, $B1

; ---- data $65C3-$65C5 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 65C5 (1 words = NN*(KK+1)); the byte before (65C2) is $B1 [v4: bytes 65C3-65C4 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_65C3:: ; 05:65C3
	db $01, $00

; ---- words $65C5-$65C7 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 65C3 [v4: bytes 65C5-65C7 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_65C5:: ; 05:65C5
	dw Data_05_6599

; ---- data $65C7-$65FD (54 bytes) [CONFIRMED] read as data by executed code (in up to 10/18 scenarios); content class unknown

Data_05_65C7:: ; 05:65C7
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $12, $C2, $1A, $C1, $40, $D0, $40, $0E, $81
	db $C1, $38, $D2, $5B, $18, $82, $C1, $30, $83, $40, $D0, $40, $0E, $81, $C1, $38
	db $D2, $5B, $18, $82, $C1, $30, $83, $40, $D0, $40, $0E, $81, $C1, $38, $D2, $5B
	db $18, $82, $C1, $30, $81, $B1

; ---- data $65FD-$65FF (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 65FF (1 words = NN*(KK+1)); the byte before (65FC) is $B1 [v4: bytes 65FD-65FE were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_65FD:: ; 05:65FD
	db $01, $00

; ---- words $65FF-$6601 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 65FD [v4: bytes 65FF-6601 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_65FF:: ; 05:65FF
	dw Data_05_65C7

; ---- data $6601-$6612 (17 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown

Data_05_6601:: ; 05:6601
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $06, $D1, $5D, $13, $82, $5A, $82, $61, $82
	db $B1

; ---- data $6612-$6614 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 6614 (1 words = NN*(KK+1)); the byte before (6611) is $B1 [v4: bytes 6612-6613 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_6612:: ; 05:6612
	db $01, $00

; ---- words $6614-$6616 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6612 [v4: bytes 6614-6616 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_6614:: ; 05:6614
	dw Data_05_6601

; ---- data $6616-$662F (25 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_6616:: ; 05:6616
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $32, $C2, $30, $C1, $40, $8F, $D9, $51, $18
	db $81, $C1, $34, $81, $28, $81, $1C, $87, $B1

; ---- data $662F-$6631 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 6631 (1 words = NN*(KK+1)); the byte before (662E) is $B1

Data_05_662F:: ; 05:662F
	db $01, $00

; ---- words $6631-$6633 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 662F

Table_05_6631:: ; 05:6631
	dw Data_05_6616

; ---- data $6633-$665B (40 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_6633:: ; 05:6633
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $04, $D5, $54, $14, $86, $59, $86, $58, $86
	db $5B, $86, $60, $86, $B1, $BF, $7F, $BD, $00, $BE, $20, $D5, $4C, $14, $86, $52
	db $86, $4F, $86, $54, $86, $58, $86, $B1

; ---- data $665B-$665D (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 665D (2 words = NN*(KK+1)); the byte before (665A) is $B1

Data_05_665B:: ; 05:665B
	db $02, $00

; ---- words $665D-$6661 (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 665B

Table_05_665D:: ; 05:665D
	dw Data_05_6633, $6648

; ---- data $6661-$66BF (94 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_05_6661:: ; 05:6661
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $4A, $C5, $30, $C2, $04, $C3, $40, $C1, $33
	db $D2, $51, $17, $81, $C1, $40, $82, $D3, $13, $81, $C1, $4F, $81, $5F, $81, $6E
	db $84, $33, $E1, $4D, $17, $8E, $C1, $40, $81, $46, $81, $4C, $81, $52, $81, $B1
	db $BF, $7F, $BD, $00, $BE, $36, $C5, $30, $C2, $04, $C3, $40, $C1, $33, $D2, $4C
	db $15, $81, $C1, $40, $82, $D3, $11, $81, $C1, $4F, $81, $5F, $81, $6E, $84, $33
	db $E1, $48, $15, $8E, $C1, $40, $81, $46, $81, $4C, $81, $52, $81, $B1

; ---- data $66BF-$66C1 (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 66C1 (2 words = NN*(KK+1)); the byte before (66BE) is $B1 [v4: bytes 66BF-66C0 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_66BF:: ; 05:66BF
	db $02, $00

; ---- words $66C1-$66C5 (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 66BF [v4: bytes 66C1-66C5 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_66C1:: ; 05:66C1
	dw Data_05_6661, $6691

; ---- data $66C5-$66F2 (45 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_66C5:: ; 05:66C5
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $02, $D3, $46, $14, $85, $4A, $85, $4D, $85
	db $4B, $85, $50, $85, $52, $84, $B1, $BF, $7F, $BD, $00, $85, $BE, $06, $D3, $46
	db $09, $85, $4A, $85, $4D, $85, $4B, $85, $50, $85, $52, $84, $B1

; ---- data $66F2-$66F4 (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 66F4 (2 words = NN*(KK+1)); the byte before (66F1) is $B1 [v4: bytes 66F2-66F3 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_66F2:: ; 05:66F2
	db $02, $00

; ---- words $66F4-$66F8 (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 66F2 [v4: bytes 66F4-66F8 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_66F4:: ; 05:66F4
	dw Data_05_66C5, $66DC

; ---- data $66F8-$6725 (45 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_05_66F8:: ; 05:66F8
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $02, $D3, $4E, $14, $85, $4C, $85, $47, $85
	db $46, $85, $49, $85, $42, $84, $B1, $BF, $7F, $BD, $00, $85, $BE, $06, $D3, $4E
	db $09, $85, $4C, $85, $47, $85, $46, $85, $49, $85, $42, $84, $B1

; ---- data $6725-$6727 (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 6727 (2 words = NN*(KK+1)); the byte before (6724) is $B1 [v4: bytes 6725-6726 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_6725:: ; 05:6725
	db $02, $00

; ---- words $6727-$672B (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6725 [v4: bytes 6727-672B were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_6727:: ; 05:6727
	dw Data_05_66F8, $670F

; ---- data $672B-$673C (17 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

Data_05_672B:: ; 05:672B
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $08, $D3, $59, $16, $84, $56, $84, $5E, $84
	db $B1

; ---- data $673C-$673E (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 673E (1 words = NN*(KK+1)); the byte before (673B) is $B1 [v4: bytes 673C-673D were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_673C:: ; 05:673C
	db $01, $00

; ---- words $673E-$6740 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 673C [v4: bytes 673E-6740 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_673E:: ; 05:673E
	dw Data_05_672B

; ---- data $6740-$6751 (17 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

Data_05_6740:: ; 05:6740
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $08, $D3, $5C, $16, $84, $56, $84, $52, $84
	db $B1

; ---- data $6751-$6753 (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 6753 (1 words = NN*(KK+1)); the byte before (6750) is $B1 [v4: bytes 6751-6752 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_6751:: ; 05:6751
	db $01, $00

; ---- words $6753-$6755 (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6751 [v4: bytes 6753-6755 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_6753:: ; 05:6753
	dw Data_05_6740

; ---- data $6755-$6789 (52 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown

Data_05_6755:: ; 05:6755
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $4B, $C2, $2A, $C1, $40, $E1, $34, $1B, $81
	db $C1, $43, $81, $47, $81, $4A, $81, $4E, $81, $51, $81, $55, $81, $58, $81, $5C
	db $81, $5F, $81, $63, $81, $66, $81, $6A, $81, $6E, $81, $71, $81, $75, $81, $78
	db $81, $7C, $81, $B1

; ---- data $6789-$678B (2 bytes) [PROBABLE] header NN=01 KK=00 of the channel-pointer table at 678B (1 words = NN*(KK+1)); the byte before (6788) is $B1 [v4: bytes 6789-678A were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_6789:: ; 05:6789
	db $01, $00

; ---- words $678B-$678D (2 bytes) [PROBABLE] 1 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6789 [v4: bytes 678B-678D were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_678B:: ; 05:678B
	dw Data_05_6755

; ---- data $678D-$67B5 (40 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_678D:: ; 05:678D
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $04, $D5, $54, $14, $86, $59, $86, $58, $86
	db $5B, $86, $60, $86, $B1, $BF, $7F, $BD, $00, $BE, $20, $D5, $4C, $14, $86, $52
	db $86, $4F, $86, $54, $86, $58, $86, $B1

; ---- data $67B5-$67B7 (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 67B7 (2 words = NN*(KK+1)); the byte before (67B4) is $B1

Data_05_67B5:: ; 05:67B5
	db $02, $00

; ---- words $67B7-$67BB (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 67B5

Table_05_67B7:: ; 05:67B7
	dw Data_05_678D, $67A2

; ---- data $67BB-$6822 (103 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown

Data_05_67BB:: ; 05:67BB
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $02, $D2, $52, $13, $83, $53, $11, $83, $54
	db $83, $55, $83, $D2, $56, $0F, $83, $57, $83, $58, $83, $D2, $59, $0D, $83, $5A
	db $83, $5B, $83, $D2, $5C, $0B, $83, $5D, $83, $5E, $83, $D2, $5F, $09, $83, $60
	db $83, $61, $83, $B1, $BF, $7F, $BD, $00, $86, $BE, $06, $D2, $52, $0F, $83, $53
	db $0D, $83, $54, $83, $55, $83, $D2, $56, $0B, $83, $57, $83, $58, $83, $D2, $59
	db $09, $83, $5A, $83, $5B, $83, $D2, $5C, $07, $83, $5D, $83, $5E, $83, $D2, $5F
	db $05, $83, $60, $83, $61, $83, $B1

; ---- data $6822-$6824 (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 6824 (2 words = NN*(KK+1)); the byte before (6821) is $B1 [v4: bytes 6822-6823 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_6822:: ; 05:6822
	db $02, $00

; ---- words $6824-$6828 (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 6822 [v4: bytes 6824-6828 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_6824:: ; 05:6824
	dw Data_05_67BB, $67EF

; ---- data $6828-$689B (115 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

Data_05_6828:: ; 05:6828
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $02, $D2, $5F, $13, $83, $5E, $11, $83, $5D
	db $83, $5C, $83, $D2, $5B, $0F, $83, $5A, $83, $59, $83, $D2, $58, $0D, $83, $57
	db $83, $56, $83, $55, $83, $D2, $54, $0B, $83, $53, $83, $52, $83, $51, $83, $D2
	db $50, $09, $83, $4F, $83, $4E, $83, $4D, $83, $B1, $BF, $7F, $BD, $00, $BE, $06
	db $86, $D2, $5F, $0F, $83, $5E, $0D, $83, $5D, $83, $5C, $83, $D2, $5B, $0B, $83
	db $5A, $83, $59, $83, $D2, $58, $09, $83, $57, $83, $56, $83, $55, $83, $D2, $54
	db $07, $83, $53, $83, $52, $83, $51, $83, $D2, $50, $05, $83, $4F, $83, $4E, $83
	db $4D, $83, $B1

; ---- data $689B-$689D (2 bytes) [PROBABLE] header NN=02 KK=00 of the channel-pointer table at 689D (2 words = NN*(KK+1)); the byte before (689A) is $B1 [v4: bytes 689B-689C were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_05_689B:: ; 05:689B
	db $02, $00

; ---- words $689D-$68A1 (4 bytes) [PROBABLE] 2 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 689B [v4: bytes 689D-68A1 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_689D:: ; 05:689D
	dw Data_05_6828, $6862

; ---- data $68A1-$68BE (29 bytes) [CONFIRMED] read as data by executed code (in up to 17/18 scenarios); content class unknown

Data_05_68A1:: ; 05:68A1
	db $BF, $7F, $BD, $00, $BC, $4A, $BE, $08, $D2, $59, $1D, $88, $D2, $83, $B1, $BF
	db $7F, $BD, $00, $BE, $06, $D2, $60, $0B, $88, $D2, $83, $B1, $02

; ---- data $68BE-$68BF (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_68BE:: ; 05:68BE
	db $00

; ---- data $68BF-$68C3 (4 bytes) [CONFIRMED] read as data by executed code (in up to 17/18 scenarios); content class unknown [v4: this is the 46th channel-pointer table (header b1 02 00 at 68BC, referenced by the song-table entry 04:5740 -> 68BD): 2 words A1 68 B0 68 = track starts 68A1 and 68B0 (both bf 7f bd); kept as data because it is CONFIRMED-read and has no following track]

Data_05_68BF:: ; 05:68BF
	db $A1, $68, $B0, $68
