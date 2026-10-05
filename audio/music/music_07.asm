; audio/music/music_07.asm
; bank 04, $6B54-$7093 (1343 bytes); pinned by layout.link
; song id 07

SECTION "audio/music/music_07", ROMX

; ---- data $6B54-$7093 (1343 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; commands decoded (docs/research/audio_format.md) (part of region $574D-$7E8C)

SoundSong07_Track0:: ; 04:6B54
Data_04_6B54::
	sound_volume $7F
	sound_pitch_add $00
Data_04_6B58:: ; 04:6B58
	sound_tempo $24
	sound_instrument $00
	sound_vibrato_depth $18
	sound_vibrato_rate $30
	sound_vibrato_delay $10
	sound_wait 12
	sound_note 8, $46, $16
	sound_wait 8
	sound_note 4, $45
	sound_wait 4
	sound_rs sound_note 4, $46
	sound_wait 8
	sound_note 4
	sound_wait 12
	sound_note 10, $49
	sound_wait 16
	sound_note 30, $3D
	sound_wait 36
Data_04_6B74:: ; 04:6B74
	sound_wait 12
	sound_note 8, $4B, $16
	sound_wait 8
	sound_note 4, $3F
	sound_wait 4
	sound_rs sound_note 4, $4B
	sound_wait 8
	sound_note 4
	sound_wait 12
	sound_note 16
	sound_wait 24
	sound_note 10, $49
	sound_wait 16
	sound_note 12, $47
	sound_wait 12
	sound_ret
	sound_wait 12
	sound_note 6, $46
	sound_wait 12
	sound_note 8, $42
	sound_wait 8
	sound_note 4, $3F
	sound_wait 12
	sound_note 10, $46
	sound_wait 16
	sound_note 8
	sound_wait 12
	sound_note 8, $42
	sound_wait 12
	sound_rs sound_note 8, $3F
	sound_wait 12
	sound_note 6, $41
	sound_wait 12
	sound_note 6
	sound_wait 12
	sound_note 8
	sound_wait 8
	sound_note 4, $42
	sound_wait 12
	sound_note 40, $44
	sound_wait 52
	sound_wait 12
	sound_note 8, $46
	sound_wait 8
	sound_note 4, $45
	sound_wait 4
	sound_rs sound_note 4, $46
	sound_wait 8
	sound_note 4
	sound_wait 12
	sound_note 10, $49
	sound_wait 16
	sound_note 30, $3D
	sound_wait 36
	sound_call Data_04_6B74
	sound_wait 12
	sound_note 6, $46, $16
	sound_wait 12
	sound_note 8, $42
	sound_wait 8
	sound_note 4, $3F
	sound_wait 12
	sound_note 10, $49
	sound_wait 16
	sound_note 8
	sound_wait 12
	sound_note 8, $46
	sound_wait 12
	sound_note 8
	sound_wait 12
	sound_note 6, $42
	sound_wait 44
	sound_instrument $25
	sound_note 4, $4C
	sound_wait 4
	sound_note 2, $44, $0F
	sound_wait 2
	sound_rs sound_note 2, $4C
	sound_wait 2
	sound_rs sound_note 2, $44
	sound_wait 2
	sound_rs sound_note 2, $4C
	sound_wait 2
	sound_rs sound_note 2, $44
	sound_wait 2
	sound_rs sound_note 2, $4C
	sound_wait 2
	sound_note 2, $44, $0D
	sound_wait 2
	sound_rs sound_note 2, $4C
	sound_wait 2
	sound_rs sound_note 2, $44
	sound_wait 2
	sound_rs sound_note 2, $4C
	sound_wait 2
	sound_rs sound_note 2, $44
	sound_wait 2
	sound_rs sound_note 2, $4C
	sound_wait 2
	sound_note 2, $44, $0B
	sound_wait 2
	sound_rs sound_note 2, $4C
	sound_wait 2
	sound_rs sound_note 2, $44
	sound_wait 2
	sound_rs sound_note 2, $4C
	sound_wait 2
	sound_rs sound_note 2, $44
	sound_wait 2
	sound_rs sound_note 2, $4C
	sound_wait 2
	sound_note 2, $44, $09
	sound_wait 2
	sound_rs sound_note 2, $4C
	sound_wait 2
	sound_rs sound_note 2, $44
	sound_wait 2
	sound_rs sound_note 2, $4C
	sound_wait 2
	sound_rs sound_note 2, $44
	sound_wait 2
	sound_rs sound_note 2, $4C
	sound_wait 2
	sound_jump Data_04_6B58
Data_04_6C16:: ; 04:6C16
	sound_end
SoundSong07_Track1:: ; 04:6C17
Data_04_6C17::
	sound_volume $7F
	sound_pitch_add $00
Data_04_6C1B:: ; 04:6C1B
	sound_instrument $08
	sound_note 4, $42, $0E
	sound_wait 12
	sound_instrument $09
	sound_note 6, $4E, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $39, $0E
	sound_wait 4
	sound_note 8, $3A
	sound_wait 8
	sound_note 4, $3D
	sound_wait 4
	sound_instrument $09
	sound_note 6, $4E, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $42, $0E
	sound_wait 16
	sound_instrument $09
	sound_note 6, $4E, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $3D, $0E
	sound_wait 4
	sound_instrument $09
	sound_note 6, $4D, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $41, $0E
	sound_wait 4
	sound_instrument $09
	sound_note 6, $4C, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $47, $0E
	sound_wait 4
Data_04_6C63:: ; 04:6C63
	sound_wait 12
	sound_instrument $09
	sound_note 6, $4F, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $43, $0E
	sound_wait 4
	sound_note 8, $46
	sound_wait 4
	sound_note 4, $3F
	sound_wait 4
	sound_rs sound_note 4, $46
	sound_wait 4
	sound_instrument $09
	sound_note 6, $4F, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $46, $0E
	sound_wait 16
	sound_instrument $09
	sound_note 6, $4F, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $43, $0E
	sound_wait 16
	sound_instrument $09
	sound_note 6, $4F, $15
	sound_wait 12
	sound_ret
	sound_instrument $08
	sound_note 4, $46, $0E
	sound_wait 12
	sound_instrument $09
	sound_note 6, $4E, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $3C, $0E
	sound_wait 4
	sound_note 8, $3B
	sound_wait 8
	sound_note 4, $3C
	sound_wait 4
	sound_instrument $09
	sound_note 6, $4E, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $3F, $0E
	sound_wait 4
	sound_note 8, $3E
	sound_wait 8
	sound_note 4, $3F
	sound_wait 4
	sound_instrument $09
	sound_note 6, $4E, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $42, $0E
	sound_wait 12
	sound_rs sound_note 4, $41
	sound_wait 4
	sound_instrument $09
	sound_note 6, $4E, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $3F, $0E
	sound_wait 4
	sound_instrument $09
	sound_note 6, $50, $15
	sound_wait 56
	sound_instrument $08
	sound_note 3, $41, $0E
	sound_wait 4
	sound_instrument $09
	sound_note 6, $47, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $3D, $0E
	sound_wait 4
	sound_instrument $09
	sound_note 6, $46, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $3B, $0E
	sound_wait 4
	sound_instrument $09
	sound_note 6, $44, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $3B, $0E
	sound_wait 4
	sound_rs sound_note 4, $42
	sound_wait 12
	sound_instrument $09
	sound_note 6, $4E, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $39, $0E
	sound_wait 4
	sound_note 8, $3A
	sound_wait 8
	sound_note 4, $3D
	sound_wait 4
	sound_instrument $09
	sound_note 6, $4E, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $42, $0E
	sound_wait 16
	sound_instrument $09
	sound_note 6, $4E, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $3D, $0E
	sound_wait 4
	sound_instrument $09
	sound_note 6, $4D, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $41, $0E
	sound_wait 4
	sound_instrument $09
	sound_note 6, $4C, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $47, $0E
	sound_wait 4
	sound_call Data_04_6C63
	sound_instrument $08
	sound_note 4, $46, $0E
	sound_wait 12
	sound_instrument $09
	sound_note 6, $4E, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $3C, $0E
	sound_wait 4
	sound_note 8, $3B
	sound_wait 8
	sound_note 4, $3C
	sound_wait 4
	sound_instrument $09
	sound_note 6, $4E, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $3C, $0E
	sound_wait 4
	sound_note 8, $3D
	sound_wait 8
	sound_note 4, $41
	sound_wait 4
	sound_instrument $09
	sound_note 6, $50, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $3D, $0E
	sound_wait 12
	sound_rs sound_note 4, $47
	sound_wait 4
	sound_instrument $09
	sound_note 6, $50, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $41, $0E
	sound_wait 4
	sound_instrument $08
	sound_note 4, $42
	sound_wait 12
	sound_instrument $09
	sound_note 6, $4E, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $42, $0E
	sound_wait 4
	sound_note 8, $3A
	sound_wait 8
	sound_note 4, $3D
	sound_wait 4
	sound_instrument $0E
	sound_note 6, $4E, $15
	sound_wait 8
	sound_note 4, $47, $16
	sound_wait 4
	sound_note 2, $41, $0F
	sound_wait 2
	sound_rs sound_note 2, $47
	sound_wait 2
	sound_rs sound_note 2, $41
	sound_wait 2
	sound_rs sound_note 2, $47
	sound_wait 2
	sound_rs sound_note 2, $41
	sound_wait 2
	sound_rs sound_note 2, $47
	sound_wait 2
	sound_note 2, $41, $0D
	sound_wait 2
	sound_rs sound_note 2, $47
	sound_wait 2
	sound_rs sound_note 2, $41
	sound_wait 2
	sound_rs sound_note 2, $47
	sound_wait 2
	sound_rs sound_note 2, $41
	sound_wait 2
	sound_rs sound_note 2, $47
	sound_wait 2
	sound_note 2, $41, $0B
	sound_wait 2
	sound_rs sound_note 2, $47
	sound_wait 2
	sound_rs sound_note 2, $41
	sound_wait 2
	sound_rs sound_note 2, $47
	sound_wait 2
	sound_rs sound_note 2, $41
	sound_wait 2
	sound_rs sound_note 2, $47
	sound_wait 2
	sound_note 2, $41, $09
	sound_wait 2
	sound_rs sound_note 2, $47
	sound_wait 2
	sound_rs sound_note 2, $41
	sound_wait 2
	sound_rs sound_note 2, $47
	sound_wait 2
	sound_rs sound_note 2, $41
	sound_wait 2
	sound_rs sound_note 2, $47
	sound_wait 2
	sound_jump Data_04_6C1B
Data_04_6DF2:: ; 04:6DF2
	sound_end
SoundSong07_Track2:: ; 04:6DF3
Data_04_6DF3::
	sound_volume $7F
	sound_pitch_add $00
Data_04_6DF7:: ; 04:6DF7
	sound_instrument $04
	sound_note 6, $2A, $1F
	sound_wait 12
	sound_rs sound_note 6, $46, $15
	sound_wait 8
	sound_note 4, $42, $13
	sound_wait 4
	sound_note 6, $25, $1F
	sound_wait 8
	sound_note 4, $3D, $13
	sound_wait 4
	sound_note 6, $46, $15
	sound_wait 12
	sound_rs sound_note 6, $2A, $1F
	sound_wait 12
	sound_rs sound_note 6, $46, $15
	sound_wait 8
	sound_rs sound_note 6, $3D, $13
	sound_wait 4
	sound_rs sound_note 6, $45, $15
	sound_wait 12
	sound_rs sound_note 6, $44
	sound_wait 12
Data_04_6E1E:: ; 04:6E1E
	sound_note 6, $27, $1F
	sound_wait 12
	sound_rs sound_note 6, $46, $15
	sound_wait 8
	sound_note 4, $43, $13
	sound_wait 4
	sound_note 6, $2E, $1F
	sound_wait 8
	sound_note 4, $3F, $13
	sound_wait 4
	sound_note 6, $46, $15
	sound_wait 12
	sound_rs sound_note 6, $33, $1F
	sound_wait 12
	sound_note 8, $46, $15
	sound_wait 8
	sound_note 4, $43, $13
	sound_wait 4
	sound_note 6, $27, $1F
	sound_wait 8
	sound_note 4, $3D, $13
	sound_wait 4
	sound_note 6, $46, $15
	sound_wait 8
	sound_note 4, $43, $13
	sound_wait 4
	sound_ret
	sound_note 6, $2C, $1F
	sound_wait 12
	sound_rs sound_note 6, $48, $15
	sound_wait 8
	sound_note 4, $44, $13
	sound_wait 4
	sound_note 6, $27, $1F
	sound_wait 8
	sound_note 4, $3F, $13
	sound_wait 4
	sound_note 6, $48, $15
	sound_wait 8
	sound_note 12, $2C, $1F
	sound_wait 16
	sound_note 6, $48, $15
	sound_wait 8
	sound_note 4, $44, $13
	sound_wait 4
	sound_note 5, $2E, $1F
	sound_wait 12
	sound_note 6, $30
	sound_wait 8
	sound_note 4, $3F, $13
	sound_wait 4
	sound_note 6, $31, $1F
	sound_wait 56
	sound_note 4
	sound_wait 4
	sound_note 6, $25
	sound_wait 12
	sound_rs sound_note 6, $27
	sound_wait 12
	sound_rs sound_note 6, $29
	sound_wait 12
	sound_rs sound_note 6, $2A
	sound_wait 12
	sound_note 6, $46, $15
	sound_wait 8
	sound_note 4, $42, $13
	sound_wait 4
	sound_note 6, $25, $1F
	sound_wait 8
	sound_note 4, $3D, $13
	sound_wait 4
	sound_note 6, $46, $15
	sound_wait 12
	sound_rs sound_note 6, $2A, $1F
	sound_wait 12
	sound_rs sound_note 6, $46, $15
	sound_wait 8
	sound_rs sound_note 6, $3D, $13
	sound_wait 4
	sound_rs sound_note 6, $45, $15
	sound_wait 12
	sound_rs sound_note 6, $44
	sound_wait 12
	sound_call Data_04_6E1E
	sound_note 6, $2C, $1F
	sound_wait 12
	sound_rs sound_note 6, $48, $15
	sound_wait 8
	sound_note 4, $44, $13
	sound_wait 4
	sound_note 6, $27, $1F
	sound_wait 8
	sound_note 4, $3F, $13
	sound_wait 4
	sound_note 6, $48, $15
	sound_wait 8
	sound_note 12, $25, $1F
	sound_wait 16
	sound_note 6, $47, $15
	sound_wait 8
	sound_note 4, $44, $13
	sound_wait 4
	sound_note 5, $27, $1F
	sound_wait 12
	sound_note 6, $29
	sound_wait 8
	sound_note 4, $44, $13
	sound_wait 4
	sound_note 6, $2A, $1F
	sound_wait 12
	sound_rs sound_note 6, $46, $15
	sound_wait 8
	sound_note 4, $42, $13
	sound_wait 4
	sound_note 6, $25, $1F
	sound_wait 8
	sound_note 4, $3D, $13
	sound_wait 4
	sound_note 6, $46, $15
	sound_wait 8
	sound_rs sound_note 6, $31, $1F
	sound_wait 12
	sound_note 4
	sound_wait 4
	sound_note 6, $2F
	sound_wait 12
	sound_rs sound_note 6, $2E
	sound_wait 12
	sound_rs sound_note 6, $2C
	sound_wait 12
	sound_jump Data_04_6DF7
Data_04_6F07:: ; 04:6F07
	sound_end
SoundSong07_Track3:: ; 04:6F08
Data_04_6F08::
	sound_volume $7F
	sound_pitch_add $00
Data_04_6F0C:: ; 04:6F0C
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 4, $27, $11
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note_vol 12, $0D
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
Data_04_6F51:: ; 04:6F51
	sound_note 4, $27, $11
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
	sound_ret
	sound_call Data_04_6F51
	sound_note 4, $27, $11
	sound_wait 60
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 3
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 4
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 3
	sound_note 3, $24, $0B
	sound_wait 4
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 3
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 4, $27, $11
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 3
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
	sound_call Data_04_6F51
	sound_call Data_04_6F51
	sound_note 4, $27, $11
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 12
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 3
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 4
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 3
	sound_note 3, $24, $0B
	sound_wait 4
	sound_pitch_bend $28
	sound_note 4, $25, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 3
	sound_jump Data_04_6F0C
Data_04_7078:: ; 04:7078
	sound_end
SoundSong07_Header:: ; 04:7079
Data_04_7079::
	sound_stream_header 4, 2
	dw SoundSong07_Track0, SoundSong07_Track1, SoundSong07_Track2, SoundSong07_Track3 ; track stream pointers (read by the driver)
	dw Data_04_6B58, Data_04_6C1B, Data_04_6DF7, Data_04_6F0C ; not read by the driver: target of each track's final sound_jump
	dw Data_04_6C16, Data_04_6DF2, Data_04_6F07, Data_04_7078 ; not read by the driver: address after each track's final sound_jump
