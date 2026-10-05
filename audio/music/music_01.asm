; audio/music/music_01.asm
; bank 04, $574D-$58C6 (377 bytes); pinned by layout.link
; song id 01 (ids 1E-28 reuse its header)

SECTION "audio/music/music_01", ROMX

; ---- data $574D-$58C6 (377 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; command semantics not decoded (part of region $574D-$7E8C)

SoundSong01_Track0:: ; 04:574D
Data_04_574D::
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $3D
	sound_instrument $52
	sound_vibrato_depth $0F
	sound_vibrato_rate $2A
	sound_vibrato_delay $1A
	sound_wait 12
	sound_note 6, $48, $1A
	sound_wait 6
	sound_rs sound_note 6, $47
	sound_wait 6
	sound_rs sound_note 6, $48
	sound_wait 6
	sound_note 5, $4D
	sound_wait 12
	sound_rs sound_note 5, $4B
	sound_wait 12
	sound_note 5
	sound_wait 12
	sound_note 6, $4A
	sound_wait 6
	sound_note 12, $48
	sound_wait 12
	sound_rs sound_note 12, $46
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_note 6, $46
	sound_wait 6
	sound_note 48, $48
	sound_wait 54
	sound_note 6, $46
	sound_wait 6
	sound_rs sound_note 6, $4A
	sound_wait 6
	sound_rs sound_note 6, $4D
	sound_wait 6
	sound_rs sound_note 6, $52
	sound_wait 6
	sound_note 8, $54
	sound_wait 8
	sound_end
SoundSong01_Track1:: ; 04:5788
Data_04_5788::
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $06
	sound_note 5, $45, $12
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 12
	sound_note 5, $48, $12
	sound_wait 6
	sound_instrument $04
	sound_note 6, $4D, $15
	sound_wait 6
	sound_instrument $06
	sound_note 5, $45, $12
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_note 5, $43, $12
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_note 5, $46, $12
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_note 5, $3F, $12
	sound_wait 6
	sound_instrument $04
	sound_note 8, $4B, $15
	sound_wait 12
	sound_instrument $06
	sound_note 5, $46, $12
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_note 5, $45, $12
	sound_wait 6
	sound_rs sound_note_vol 5, $03
	sound_wait 6
	sound_note 5, $48, $12
	sound_wait 6
	sound_rs sound_note 5, $41
	sound_wait 6
	sound_note_vol 5, $03
	sound_wait 6
	sound_note 5, $45, $12
	sound_wait 6
	sound_instrument $05
	sound_note 12, $4D, $10
	sound_wait 12
	sound_note 6, $4F
	sound_wait 6
	sound_note 18, $50
	sound_wait 18
	sound_instrument $06
	sound_note 6, $3E, $12
	sound_wait 6
	sound_rs sound_note 6, $41
	sound_wait 6
	sound_rs sound_note 6, $46
	sound_wait 6
	sound_rs sound_note 6, $4A
	sound_wait 6
	sound_note 8, $4C
	sound_wait 8
	sound_end
SoundSong01_Track2:: ; 04:57F3
Data_04_57F3::
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $20
	sound_note 8, $29, $1D
	sound_wait 18
	sound_note 6, $35
	sound_wait 6
	sound_instrument $20
	sound_note 6, $45, $15
	sound_wait 12
	sound_instrument $20
	sound_note 6, $29, $1D
	sound_wait 12
	sound_note 8, $27
	sound_wait 18
	sound_note 6, $33
	sound_wait 6
	sound_instrument $20
	sound_note 8, $43, $15
	sound_wait 12
	sound_instrument $20
	sound_note 6, $27, $1D
	sound_wait 12
	sound_note 8, $29
	sound_wait 18
	sound_note 6, $35
	sound_wait 18
	sound_note 8, $2C
	sound_wait 18
	sound_note 6, $38
	sound_wait 18
	sound_rs sound_note 6, $2E
	sound_wait 12
	sound_rs sound_note 6, $3A
	sound_wait 12
	sound_note 8, $30
	sound_wait 8
	sound_end
SoundSong01_Track3:: ; 04:5832
Data_04_5832::
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 4, $27, $11
	sound_wait 6
	sound_note 6, $2A, $0B
	sound_wait 6
	sound_note 4, $24
	sound_wait 6
	sound_note 4
	sound_wait 6
	sound_pitch_bend $28
	sound_note 4, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 4, $24, $0B
	sound_wait 6
	sound_note 4
	sound_wait 6
	sound_note 4, $27, $11
	sound_wait 6
	sound_rs sound_note 4, $24, $0B
	sound_wait 6
	sound_note 6, $2A
	sound_wait 6
	sound_note 4, $27, $11
	sound_wait 6
	sound_rs sound_note 4, $24, $0B
	sound_wait 6
	sound_pitch_bend $28
	sound_note 4, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 4, $24, $0B
	sound_wait 6
	sound_rs sound_note 4, $27, $11
	sound_wait 6
	sound_note 6, $2A, $0B
	sound_wait 6
	sound_note 4, $27, $11
	sound_wait 6
	sound_note 6, $2A, $0B
	sound_wait 6
	sound_note 4, $24
	sound_wait 6
	sound_note 4
	sound_wait 6
	sound_pitch_bend $28
	sound_note 4, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 4, $24, $0B
	sound_wait 6
	sound_note 4
	sound_wait 6
	sound_note 4, $27, $11
	sound_wait 6
	sound_rs sound_note 4, $24, $0B
	sound_wait 6
	sound_note 6, $2A
	sound_wait 6
	sound_note 4, $27, $11
	sound_wait 6
	sound_rs sound_note 4, $24, $0B
	sound_wait 6
	sound_pitch_bend $28
	sound_note 4, $2F, $0F
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 4, $24, $0B
	sound_wait 6
	sound_note 4
	sound_wait 6
	sound_note 4, $27, $11
	sound_wait 6
	sound_note 6
	sound_wait 6
	sound_end
SoundSong01_Header:: ; 04:58BC
Data_04_58BC::
	sound_stream_header 4, 0
	dw SoundSong01_Track0, SoundSong01_Track1, SoundSong01_Track2, SoundSong01_Track3 ; track stream pointers (read by the driver)
