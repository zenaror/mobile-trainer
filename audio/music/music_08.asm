; audio/music/music_08.asm
; bank 04, $7093-$745F (972 bytes); pinned by layout.link
; song id 08

SECTION "audio/music/music_08", ROMX

; ---- data $7093-$745F (972 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; commands decoded (docs/research/audio_format.md) (part of region $574D-$7E8C)

SoundSong08_Track0:: ; 04:7093
Data_04_7093::
	sound_volume $7F
	sound_pitch_add $00
Data_04_7097:: ; 04:7097
	sound_tempo $39
	sound_instrument $2C
	sound_vibrato_depth $14
	sound_vibrato_rate $1E
	sound_vibrato_delay $12
	sound_wait 12
	sound_note 4, $4D, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $50, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $55, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_rs sound_note_vol 4, $02
	sound_wait 12
	sound_note 4, $54, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_rs sound_note_vol 4, $02
	sound_wait 12
	sound_note 4, $52, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $54, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_rs sound_note_vol 4, $02
	sound_wait 24
	sound_note 4, $50, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_rs sound_note_vol 4, $02
	sound_wait 48
	sound_wait 12
	sound_note 4, $4D, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $59, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $57, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_rs sound_note_vol 4, $02
	sound_wait 12
	sound_note 4, $52, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_rs sound_note_vol 4, $02
	sound_wait 12
	sound_note 4, $55, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $54, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_rs sound_note_vol 4, $02
	sound_wait 84
	sound_wait 12
	sound_note 4, $4D, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $50, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $55, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_rs sound_note_vol 4, $02
	sound_wait 12
	sound_note 4, $54, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_rs sound_note_vol 4, $02
	sound_wait 12
	sound_note 4, $52, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $54, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_rs sound_note_vol 4, $02
	sound_wait 12
	sound_note 4, $50, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $5C, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_rs sound_note_vol 4, $02
	sound_wait 24
	sound_note 4, $50, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $52, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $55, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $54, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $4B, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_note 4, $4D, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_rs sound_note_vol 4, $02
	sound_wait 12
	sound_note 4, $4F, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_rs sound_note_vol 4, $02
	sound_wait 12
	sound_note 4, $50, $0F
	sound_wait 6
	sound_rs sound_note_vol 4, $07
	sound_wait 6
	sound_rs sound_note_vol 4, $02
	sound_wait 96
	sound_jump Data_04_7097
Data_04_7171:: ; 04:7171
	sound_end
SoundSong08_Track1:: ; 04:7172
Data_04_7172::
	sound_volume $7F
	sound_pitch_add $00
Data_04_7176:: ; 04:7176
	sound_instrument $06
	sound_note 5, $31, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_note 5, $3D, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $04
	sound_note 8, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 5, $44, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 18
	sound_note 5, $3D, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $04
	sound_note 8, $44, $15
	sound_wait 12
	sound_instrument $06
	sound_note 5, $49, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $06
	sound_wait 12
	sound_note 5, $3C, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $04
	sound_note 8, $44, $15
	sound_wait 12
	sound_instrument $06
	sound_note 5, $48, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 18
	sound_note 5, $3F, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $04
	sound_note 8, $4B, $15
	sound_wait 12
	sound_instrument $06
	sound_note 5, $3F, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $06
	sound_note 5, $31, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_note 5, $3D, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $04
	sound_note 8, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 5, $33, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 18
	sound_note 5, $43, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $04
	sound_note 8, $46, $15
	sound_wait 12
	sound_instrument $06
	sound_note 5, $49, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $06
	sound_note 5, $38, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_note 5, $3C, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $04
	sound_note 8, $48, $15
	sound_wait 12
	sound_instrument $06
	sound_note 5, $46, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 18
	sound_note 5, $44, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $04
	sound_note 8, $4E, $15
	sound_wait 12
	sound_instrument $06
	sound_note 5, $3C, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $06
	sound_note 5, $35, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_note 5, $3D, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $04
	sound_note 8, $4D, $15
	sound_wait 12
	sound_instrument $06
	sound_note 5, $41, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 18
	sound_note 5, $44, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $04
	sound_note_vol 8, $15
	sound_wait 12
	sound_instrument $06
	sound_note 5, $3D, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $06
	sound_note 5, $33, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_note 5, $3C, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $04
	sound_note 8, $44, $15
	sound_wait 12
	sound_instrument $06
	sound_note 5, $41, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 30
	sound_instrument $04
	sound_wait 12
	sound_rs sound_instrument $06
	sound_wait 12
	sound_rs sound_instrument $06
	sound_note 5, $33, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_note 5, $3A, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $04
	sound_note 8, $44, $15
	sound_wait 12
	sound_instrument $06
	sound_note_vol 5, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 18
	sound_note 5, $43, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $04
	sound_note 8, $46, $15
	sound_wait 12
	sound_instrument $06
	sound_wait 12
	sound_wait 12
	sound_note 5, $3F, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $04
	sound_note 8, $48, $15
	sound_wait 12
	sound_instrument $06
	sound_note 5, $46, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 18
	sound_note 5, $44, $0F
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_instrument $04
	sound_note 8, $50, $15
	sound_wait 12
	sound_instrument $06
	sound_note 5, $3F, $13
	sound_wait 6
	sound_rs sound_note_vol 5, $07
	sound_wait 6
	sound_jump Data_04_7176
Data_04_72D6:: ; 04:72D6
	sound_end
SoundSong08_Track2:: ; 04:72D7
Data_04_72D7::
	sound_volume $7F
	sound_pitch_add $00
Data_04_72DB:: ; 04:72DB
	sound_instrument $08
	sound_note 6, $31, $1F
	sound_wait 24
	sound_instrument $09
	sound_note 8, $55, $15
	sound_wait 12
	sound_instrument $08
	sound_note 6, $2C, $1F
	sound_wait 12
	sound_note 6
	sound_wait 24
	sound_instrument $09
	sound_note 8, $4D, $15
	sound_wait 24
	sound_ret
	sound_instrument $08
	sound_note 6, $30, $1F
	sound_wait 24
	sound_instrument $09
	sound_note 8, $4B, $15
	sound_wait 12
	sound_instrument $08
	sound_note 6, $2C, $1F
	sound_wait 12
	sound_note 6
	sound_wait 24
	sound_instrument $09
	sound_note 8, $54, $15
	sound_wait 12
	sound_instrument $08
	sound_note 6, $33, $1F
	sound_wait 12
	sound_instrument $08
	sound_note 6, $31
	sound_wait 24
	sound_instrument $09
	sound_note 8, $55, $15
	sound_wait 12
	sound_instrument $08
	sound_note 6, $2C, $1F
	sound_wait 12
	sound_rs sound_note 6, $33
	sound_wait 24
	sound_instrument $09
	sound_note 8, $4F, $15
	sound_wait 24
	sound_instrument $08
	sound_note 6, $2C, $1F
	sound_wait 24
	sound_instrument $09
	sound_note 8, $50, $15
	sound_wait 12
	sound_instrument $08
	sound_note 6, $33, $1F
	sound_wait 12
	sound_note 6
	sound_wait 24
	sound_instrument $09
	sound_note 8, $57, $15
	sound_wait 12
	sound_instrument $08
	sound_note 6, $2C, $1F
	sound_wait 12
	sound_call Data_04_72DB
	sound_instrument $08
	sound_note 6, $30, $1F
	sound_wait 24
	sound_instrument $09
	sound_note 8, $4B, $15
	sound_wait 12
	sound_instrument $08
	sound_note 6, $31, $1F
	sound_wait 60
	sound_rs sound_note 6, $33
	sound_wait 24
	sound_instrument $09
	sound_note 8, $4D, $15
	sound_wait 12
	sound_instrument $08
	sound_note 6, $27, $1F
	sound_wait 12
	sound_note 6
	sound_wait 24
	sound_instrument $09
	sound_note 8, $4F, $15
	sound_wait 12
	sound_instrument $08
	sound_wait 12
	sound_rs sound_instrument $08
	sound_note 6, $2C, $1F
	sound_wait 24
	sound_instrument $09
	sound_note 8, $50, $15
	sound_wait 12
	sound_instrument $08
	sound_note 6, $2C, $1F
	sound_wait 12
	sound_note 6
	sound_wait 24
	sound_instrument $09
	sound_note 8, $57, $15
	sound_wait 12
	sound_instrument $08
	sound_wait 12
	sound_jump Data_04_72DB
Data_04_739C:: ; 04:739C
	sound_end
SoundSong08_Track3:: ; 04:739D
Data_04_739D::
	sound_volume $7F
	sound_pitch_add $00
Data_04_73A1:: ; 04:73A1
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 5, $27, $10
	sound_wait 12
	sound_rs sound_note 5, $24, $0A
	sound_wait 12
	sound_pitch_bend $28
	sound_note 5, $25, $0E
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 5, $27, $10
	sound_wait 12
	sound_note 5
	sound_wait 12
	sound_note 5, $24, $0A
	sound_wait 12
	sound_pitch_bend $28
	sound_note 5, $25, $0E
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 5, $24, $0A
	sound_wait 12
Data_04_73CA:: ; 04:73CA
	sound_note 5, $27, $10
	sound_wait 12
	sound_rs sound_note 5, $24, $0A
	sound_wait 12
	sound_pitch_bend $28
	sound_note 5, $25, $0E
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 5, $27, $10
	sound_wait 12
	sound_note 5
	sound_wait 12
	sound_note 5, $24, $0A
	sound_wait 12
	sound_pitch_bend $28
	sound_note 5, $25, $0E
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 5, $24, $0A
	sound_wait 12
	sound_ret
	sound_call Data_04_73CA
	sound_call Data_04_73CA
	sound_call Data_04_73CA
	sound_note 5, $27, $10
	sound_wait 12
	sound_rs sound_note 5, $24, $0A
	sound_wait 12
	sound_pitch_bend $28
	sound_note 5, $25, $0E
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 5, $24, $0A
	sound_wait 36
	sound_pitch_bend $28
	sound_wait 1
	sound_rs sound_pitch_bend $40
	sound_wait 23
	sound_call Data_04_73CA
	sound_note 5, $27, $10
	sound_wait 12
	sound_rs sound_note 5, $24, $0A
	sound_wait 12
	sound_pitch_bend $28
	sound_note 5, $25, $0E
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 5, $24, $0A
	sound_wait 12
	sound_rs sound_note 5, $27, $10
	sound_wait 12
	sound_pitch_bend $28
	sound_note 5, $25, $0E
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_rs sound_pitch_bend $28
	sound_note 5
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 5, $24, $0A
	sound_wait 12
	sound_jump Data_04_73A1
Data_04_7444:: ; 04:7444
	sound_end
SoundSong08_Header:: ; 04:7445
Data_04_7445::
	sound_stream_header 4, 2
	dw SoundSong08_Track0, SoundSong08_Track1, SoundSong08_Track2, SoundSong08_Track3 ; track stream pointers (read by the driver)
	dw Data_04_7097, Data_04_7176, Data_04_72DB, Data_04_73A1 ; not read by the driver: target of each track's final sound_jump
	dw Data_04_7171, Data_04_72D6, Data_04_739C, Data_04_7444 ; not read by the driver: address after each track's final sound_jump
