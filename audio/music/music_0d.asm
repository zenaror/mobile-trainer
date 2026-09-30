; audio/music/music_0d.asm
; bank 04, $7DBC-$7E8C (208 bytes); pinned by layout.link
; song id 0D

SECTION "audio/music/music_0d", ROMX

; ---- data $7DBC-$7E8C (208 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; command semantics not decoded (part of region $574D-$7E8C)

SoundSong0D_Track0:: ; 04:7DBC
Data_04_7DBC::
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $4A
	sound_instrument $02
	sound_note 6, $37, $16
	sound_wait 6
	sound_rs sound_note 6, $3A
	sound_wait 6
	sound_rs sound_note 6, $43
	sound_wait 6
	sound_rs sound_note 6, $41
	sound_wait 12
	sound_rs sound_note 6, $44
	sound_wait 12
	sound_rs sound_note 6, $49
	sound_wait 6
	sound_rs sound_note 6, $4B
	sound_wait 12
	sound_note 2, $4A, $0C
	sound_wait 2
	sound_rs sound_note 2, $48
	sound_wait 2
	sound_rs sound_note 2, $46
	sound_wait 2
	sound_rs sound_note 2, $44
	sound_wait 2
	sound_rs sound_note 2, $43
	sound_wait 2
	sound_rs sound_note 2, $41
	sound_wait 2
	sound_note 6, $3F, $16
	sound_wait 6
	sound_end
SoundSong0D_Track1:: ; 04:7DE7
Data_04_7DE7::
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $06
	sound_note 6, $2E, $15
	sound_wait 6
	sound_rs sound_note 6, $33
	sound_wait 6
	sound_rs sound_note 6, $3A
	sound_wait 6
	sound_rs sound_note 6, $38
	sound_wait 12
	sound_rs sound_note 6, $3D
	sound_wait 12
	sound_rs sound_note 6, $41
	sound_wait 6
	sound_rs sound_note 6, $43
	sound_wait 12
	sound_note 2, $41, $09
	sound_wait 2
	sound_rs sound_note 2, $3F
	sound_wait 2
	sound_rs sound_note 2, $3E
	sound_wait 2
	sound_rs sound_note 2, $3C
	sound_wait 2
	sound_rs sound_note 2, $3A
	sound_wait 2
	sound_rs sound_note 2, $38
	sound_wait 2
	sound_note 6, $37, $15
	sound_wait 6
	sound_end
SoundSong0D_Track2:: ; 04:7E10
Data_04_7E10::
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $08
	sound_pitch_bend_scale $0A
	sound_note 6, $27, $1F
	sound_wait 12
	sound_rs sound_note 6, $2B
	sound_wait 6
	sound_rs sound_note 6, $29
	sound_wait 12
	sound_rs sound_note 6, $2C
	sound_wait 18
	sound_rs sound_note 6, $2B
	sound_wait 6
	sound_instrument $47
	sound_pitch_bend $40
	sound_note 6, $58, $16
	sound_wait 1
	sound_pitch_bend $30
	sound_wait 2
	sound_rs sound_pitch_bend $20
	sound_wait 1
	sound_rs sound_pitch_bend $11
	sound_wait 2
	sound_rs sound_pitch_bend $40
	sound_note 6, $52
	sound_wait 1
	sound_pitch_bend $30
	sound_wait 2
	sound_rs sound_pitch_bend $20
	sound_wait 1
	sound_rs sound_pitch_bend $11
	sound_wait 2
	sound_rs sound_pitch_bend $40
	sound_note 6, $4E
	sound_wait 1
	sound_pitch_bend $30
	sound_wait 2
	sound_rs sound_pitch_bend $20
	sound_wait 1
	sound_rs sound_pitch_bend $11
	sound_wait 2
	sound_instrument $08
	sound_pitch_bend $40
	sound_note 6, $27, $1F
	sound_wait 6
	sound_end
SoundSong0D_Track3:: ; 04:7E52
Data_04_7E52::
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_pitch_bend $20
	sound_note 3, $27, $12
	sound_wait 6
	sound_rs sound_note 3, $24, $0B
	sound_wait 6
	sound_rs sound_note 3, $25, $10
	sound_wait 6
	sound_rs sound_note 3, $27, $12
	sound_wait 6
	sound_rs sound_note 3, $24, $0B
	sound_wait 6
	sound_rs sound_note 3, $25, $10
	sound_wait 6
	sound_rs sound_note 3, $24, $0B
	sound_wait 6
	sound_rs sound_note 3, $27, $12
	sound_wait 6
	sound_rs sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6, $2E
	sound_wait 6
	sound_rs sound_note 6, $2D
	sound_wait 6
	sound_rs sound_note 6, $2C
	sound_wait 6
	sound_note 3, $27, $12
	sound_wait 3
	sound_end
SoundSong0D_Header:: ; 04:7E82
Data_04_7E82::
	sound_stream_header 4, 0
	dw SoundSong0D_Track0, SoundSong0D_Track1, SoundSong0D_Track2, SoundSong0D_Track3 ; track stream pointers (read by the driver)
