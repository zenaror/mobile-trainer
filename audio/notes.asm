; audio/notes.asm
; bank 04, $5044-$51DD (409 bytes); pinned by layout.link
; Table_SoundDrv_Durations and Table_SoundDrv_NoteFreq

SECTION "audio/notes", ROMX

; ---- data $5044-$5075 (49 bytes) [CONFIRMED] Table_SoundDrv_Durations: 49 bytes, the ticks of a wait (index = opcode - $80) or the gate time of a note (index = opcode - $CF); read by the wait handler 04:4756 and by SoundDrv_CmdNote 04:4A2B; 00..18 step 1, then 1C 1E 20 24 28 2A 2C 30 34 36 38 3C 40 42 44 48 4C 4E 50 54 58 5A 5C 60 | superseded note: [PROBABLE] 49-byte lookup table: 00..18 step 1 (25 values) then 1C 1E 20 24 28 2A 2C 30 34 36 38 3C 40 42 44 48 4C 4E 50 54 58 5A 5C 60 (step pattern 2,2,4,4 repeating); the mapper had 5068-5074 as a word table (false positive) and 8 executed-read pieces with 1-byte unread holes; all were entries of this one table. Field meaning unknown

Table_SoundDrv_Durations:: ; 04:5044
Data_04_5044::
	sound_durations 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ; index $00-$0F
	sound_durations 16, 17, 18, 19, 20, 21, 22, 23, 24, 28, 30, 32, 36, 40, 42, 44 ; index $10-$1F
	sound_durations 48, 52, 54, 56, 60, 64, 66, 68, 72, 76, 78, 80, 84, 88, 90, 92 ; index $20-$2F
	sound_durations 96 ; index $30-$30

; ---- data $5075-$51DD (360 bytes) [CONFIRMED] Table_SoundDrv_NoteFreq: 120 records of 3 bytes (dw 11-bit period, db step), index = pitch byte - $24 (SoundDrv_NoteToIndex 04:4FEA), one semitone per record; SoundDrv_WriteChannelPitch 04:4ECA adds step * (fraction of the pitch offset) / 256 to the period; every period is within 1 of the equal-tempered value of MIDI note 36 + index (A4 = 440 Hz; $002C = 65.4 Hz = C2) and step is the next period minus this one, within 1 | superseded note: [PROBABLE] sound note table: 120 records x 3 bytes = little-endian 11-bit GB frequency (002C 009D 0107 016B 01C9 0223 0277 02C7 0312 0358 039B 03DA 0416 044E ... 07FE, non-decreasing over all 120 entries (strictly increasing up to entry 88, then the values 07F4-07FE repeat: the 11-bit period saturates), matches the equal-tempered GB period table: 002C = 65.4 Hz = C2, 12 entries per octave) followed by one byte (70 6A 64 5F 59 54 50 ... decreasing per note, meaning unknown); 5075+120*3 = 51DD = start of the next table; executed reads of 5074-51DD in up to 17/18 scenarios

Table_SoundDrv_NoteFreq:: ; 04:5075
Data_04_5075::
	sound_note_freq $002C, $70 ; pitch $24 C2
	sound_note_freq $009D, $6A ; pitch $25 C#2
	sound_note_freq $0107, $64 ; pitch $26 D2
	sound_note_freq $016B, $5F ; pitch $27 D#2
	sound_note_freq $01C9, $59 ; pitch $28 E2
	sound_note_freq $0223, $54 ; pitch $29 F2
	sound_note_freq $0277, $50 ; pitch $2A F#2
	sound_note_freq $02C7, $4B ; pitch $2B G2
	sound_note_freq $0312, $47 ; pitch $2C G#2
	sound_note_freq $0358, $43 ; pitch $2D A2
	sound_note_freq $039B, $3F ; pitch $2E A#2
	sound_note_freq $03DA, $3C ; pitch $2F B2
	sound_note_freq $0416, $38 ; pitch $30 C3
	sound_note_freq $044E, $35 ; pitch $31 C#3
	sound_note_freq $0483, $32 ; pitch $32 D3
	sound_note_freq $04B5, $30 ; pitch $33 D#3
	sound_note_freq $04E4, $2D ; pitch $34 E3
	sound_note_freq $0511, $2A ; pitch $35 F3
	sound_note_freq $053B, $28 ; pitch $36 F#3
	sound_note_freq $0563, $26 ; pitch $37 G3
	sound_note_freq $0589, $24 ; pitch $38 G#3
	sound_note_freq $05AC, $22 ; pitch $39 A3
	sound_note_freq $05CD, $20 ; pitch $3A A#3
	sound_note_freq $05ED, $1E ; pitch $3B B3
	sound_note_freq $060B, $1C ; pitch $3C C4
	sound_note_freq $0627, $1B ; pitch $3D C#4
	sound_note_freq $0642, $19 ; pitch $3E D4
	sound_note_freq $065B, $18 ; pitch $3F D#4
	sound_note_freq $0672, $16 ; pitch $40 E4
	sound_note_freq $0689, $15 ; pitch $41 F4
	sound_note_freq $069E, $14 ; pitch $42 F#4
	sound_note_freq $06B2, $13 ; pitch $43 G4
	sound_note_freq $06C4, $12 ; pitch $44 G#4
	sound_note_freq $06D6, $11 ; pitch $45 A4
	sound_note_freq $06E7, $10 ; pitch $46 A#4
	sound_note_freq $06F6, $0F ; pitch $47 B4
	sound_note_freq $0705, $0E ; pitch $48 C5
	sound_note_freq $0714, $0D ; pitch $49 C#5
	sound_note_freq $0721, $0D ; pitch $4A D5
	sound_note_freq $072D, $0C ; pitch $4B D#5
	sound_note_freq $0739, $0B ; pitch $4C E5
	sound_note_freq $0744, $0B ; pitch $4D F5
	sound_note_freq $074F, $0A ; pitch $4E F#5
	sound_note_freq $0759, $09 ; pitch $4F G5
	sound_note_freq $0762, $09 ; pitch $50 G#5
	sound_note_freq $076B, $08 ; pitch $51 A5
	sound_note_freq $0773, $08 ; pitch $52 A#5
	sound_note_freq $077B, $08 ; pitch $53 B5
	sound_note_freq $0783, $07 ; pitch $54 C6
	sound_note_freq $078A, $07 ; pitch $55 C#6
	sound_note_freq $0790, $06 ; pitch $56 D6
	sound_note_freq $0797, $06 ; pitch $57 D#6
	sound_note_freq $079D, $06 ; pitch $58 E6
	sound_note_freq $07A2, $05 ; pitch $59 F6
	sound_note_freq $07A7, $05 ; pitch $5A F#6
	sound_note_freq $07AC, $05 ; pitch $5B G6
	sound_note_freq $07B1, $04 ; pitch $5C G#6
	sound_note_freq $07B5, $04 ; pitch $5D A6
	sound_note_freq $07BA, $04 ; pitch $5E A#6
	sound_note_freq $07BE, $04 ; pitch $5F B6
	sound_note_freq $07C1, $04 ; pitch $60 C7
	sound_note_freq $07C5, $03 ; pitch $61 C#7
	sound_note_freq $07C8, $03 ; pitch $62 D7
	sound_note_freq $07CB, $03 ; pitch $63 D#7
	sound_note_freq $07CE, $03 ; pitch $64 E7
	sound_note_freq $07D1, $03 ; pitch $65 F7
	sound_note_freq $07D4, $03 ; pitch $66 F#7
	sound_note_freq $07D6, $02 ; pitch $67 G7
	sound_note_freq $07D9, $02 ; pitch $68 G#7
	sound_note_freq $07DB, $02 ; pitch $69 A7
	sound_note_freq $07DD, $02 ; pitch $6A A#7
	sound_note_freq $07DF, $02 ; pitch $6B B7
	sound_note_freq $07E1, $02 ; pitch $6C C8
	sound_note_freq $07E2, $02 ; pitch $6D C#8
	sound_note_freq $07E4, $02 ; pitch $6E D8
	sound_note_freq $07E6, $01 ; pitch $6F D#8
	sound_note_freq $07E8, $01 ; pitch $70 E8
	sound_note_freq $07E9, $01 ; pitch $71 F8
	sound_note_freq $07EA, $01 ; pitch $72 F#8
	sound_note_freq $07EB, $01 ; pitch $73 G8
	sound_note_freq $07EC, $01 ; pitch $74 G#8
	sound_note_freq $07ED, $01 ; pitch $75 A8
	sound_note_freq $07EE, $01 ; pitch $76 A#8
	sound_note_freq $07EF, $01 ; pitch $77 B8
	sound_note_freq $07F0, $01 ; pitch $78 C9
	sound_note_freq $07F1, $01 ; pitch $79 C#9
	sound_note_freq $07F2, $01 ; pitch $7A D9
	sound_note_freq $07F3, $01 ; pitch $7B D#9
	sound_note_freq $07F4, $01 ; pitch $7C E9
	sound_note_freq $07F4, $01 ; pitch $7D F9
	sound_note_freq $07F5, $01 ; pitch $7E F#9
	sound_note_freq $07F6, $01 ; pitch $7F G9
	sound_note_freq $07F6, $01 ; pitch $80 G#9
	sound_note_freq $07F7, $01 ; pitch $81 A9
	sound_note_freq $07F7, $01 ; pitch $82 A#9
	sound_note_freq $07F8, $01 ; pitch $83 B9
	sound_note_freq $07F8, $01 ; pitch $84 C10
	sound_note_freq $07F9, $01 ; pitch $85 C#10
	sound_note_freq $07F9, $01 ; pitch $86 D10
	sound_note_freq $07F9, $01 ; pitch $87 D#10
	sound_note_freq $07FA, $01 ; pitch $88 E10
	sound_note_freq $07FA, $01 ; pitch $89 F10
	sound_note_freq $07FA, $01 ; pitch $8A F#10
	sound_note_freq $07FB, $01 ; pitch $8B G10
	sound_note_freq $07FB, $01 ; pitch $8C G#10
	sound_note_freq $07FB, $01 ; pitch $8D A10
	sound_note_freq $07FC, $01 ; pitch $8E A#10
	sound_note_freq $07FC, $01 ; pitch $8F B10
	sound_note_freq $07FC, $01 ; pitch $90 C11
	sound_note_freq $07FC, $01 ; pitch $91 C#11
	sound_note_freq $07FD, $01 ; pitch $92 D11
	sound_note_freq $07FD, $01 ; pitch $93 D#11
	sound_note_freq $07FD, $01 ; pitch $94 E11
	sound_note_freq $07FD, $01 ; pitch $95 F11
	sound_note_freq $07FD, $01 ; pitch $96 F#11
	sound_note_freq $07FD, $01 ; pitch $97 G11
	sound_note_freq $07FE, $01 ; pitch $98 G#11
	sound_note_freq $07FE, $01 ; pitch $99 A11
	sound_note_freq $07FE, $01 ; pitch $9A A#11
	sound_note_freq $07FE, $01 ; pitch $9B B11
