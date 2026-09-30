; audio/notes.asm
; bank 04, $5044-$51DD (409 bytes); pinned by layout.link
; Table_SoundDrv_Durations and Table_SoundDrv_NoteFreq

SECTION "audio/notes", ROMX

; ---- data $5044-$5075 (49 bytes) [PROBABLE] 49-byte lookup table: 00..18 step 1 (25 values) then 1C 1E 20 24 28 2A 2C 30 34 36 38 3C 40 42 44 48 4C 4E 50 54 58 5A 5C 60 (step pattern 2,2,4,4 repeating); the mapper had 5068-5074 as a word table (false positive) and 8 executed-read pieces with 1-byte unread holes; all were entries of this one table. Field meaning unknown

Table_SoundDrv_Durations:: ; 04:5044
Data_04_5044::
	db $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F
	db $10, $11, $12, $13, $14, $15, $16, $17, $18, $1C, $1E, $20, $24, $28, $2A, $2C
	db $30, $34, $36, $38, $3C, $40, $42, $44, $48, $4C, $4E, $50, $54, $58, $5A, $5C
	db $60

; ---- data $5075-$51DD (360 bytes) [PROBABLE] sound note table: 120 records x 3 bytes = little-endian 11-bit GB frequency (002C 009D 0107 016B 01C9 0223 0277 02C7 0312 0358 039B 03DA 0416 044E ... 07FE, non-decreasing over all 120 entries (strictly increasing up to entry 88, then the values 07F4-07FE repeat: the 11-bit period saturates), matches the equal-tempered GB period table: 002C = 65.4 Hz = C2, 12 entries per octave) followed by one byte (70 6A 64 5F 59 54 50 ... decreasing per note, meaning unknown); 5075+120*3 = 51DD = start of the next table; executed reads of 5074-51DD in up to 17/18 scenarios

Table_SoundDrv_NoteFreq:: ; 04:5075
Data_04_5075::
	db $2C, $00, $70, $9D, $00, $6A, $07, $01, $64, $6B, $01, $5F, $C9, $01, $59, $23
	db $02, $54, $77, $02, $50, $C7, $02, $4B, $12, $03, $47, $58, $03, $43, $9B, $03
	db $3F, $DA, $03, $3C, $16, $04, $38, $4E, $04, $35, $83, $04, $32, $B5, $04, $30
	db $E4, $04, $2D, $11, $05, $2A, $3B, $05, $28, $63, $05, $26, $89, $05, $24, $AC
	db $05, $22, $CD, $05, $20, $ED, $05, $1E, $0B, $06, $1C, $27, $06, $1B, $42, $06
	db $19, $5B, $06, $18, $72, $06, $16, $89, $06, $15, $9E, $06, $14, $B2, $06, $13
	db $C4, $06, $12, $D6, $06, $11, $E7, $06, $10, $F6, $06, $0F, $05, $07, $0E, $14
	db $07, $0D, $21, $07, $0D, $2D, $07, $0C, $39, $07, $0B, $44, $07, $0B, $4F, $07
	db $0A, $59, $07, $09, $62, $07, $09, $6B, $07, $08, $73, $07, $08, $7B, $07, $08
	db $83, $07, $07, $8A, $07, $07, $90, $07, $06, $97, $07, $06, $9D, $07, $06, $A2
	db $07, $05, $A7, $07, $05, $AC, $07, $05, $B1, $07, $04, $B5, $07, $04, $BA, $07
	db $04, $BE, $07, $04, $C1, $07, $04, $C5, $07, $03, $C8, $07, $03, $CB, $07, $03
	db $CE, $07, $03, $D1, $07, $03, $D4, $07, $03, $D6, $07, $02, $D9, $07, $02, $DB
	db $07, $02, $DD, $07, $02, $DF, $07, $02, $E1, $07, $02, $E2, $07, $02, $E4, $07
	db $02, $E6, $07, $01, $E8, $07, $01, $E9, $07, $01, $EA, $07, $01, $EB, $07, $01
	db $EC, $07, $01, $ED, $07, $01, $EE, $07, $01, $EF, $07, $01, $F0, $07, $01, $F1
	db $07, $01, $F2, $07, $01, $F3, $07, $01, $F4, $07, $01, $F4, $07, $01, $F5, $07
	db $01, $F6, $07, $01, $F6, $07, $01, $F7, $07, $01, $F7, $07, $01, $F8, $07, $01
	db $F8, $07, $01, $F9, $07, $01, $F9, $07, $01, $F9, $07, $01, $FA, $07, $01, $FA
	db $07, $01, $FA, $07, $01, $FB, $07, $01, $FB, $07, $01, $FB, $07, $01, $FC, $07
	db $01, $FC, $07, $01, $FC, $07, $01, $FC, $07, $01, $FD, $07, $01, $FD, $07, $01
	db $FD, $07, $01, $FD, $07, $01, $FD, $07, $01, $FD, $07, $01, $FE, $07, $01, $FE
	db $07, $01, $FE, $07, $01, $FE, $07, $01
