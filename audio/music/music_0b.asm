; audio/music/music_0b.asm
; bank 04, $79A4-$7BF3 (591 bytes); pinned by layout.link
; song id 0B

SECTION "audio/music/music_0b", ROMX

; ---- data $79A4-$7BF3 (591 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; commands decoded (docs/research/audio_format.md) (part of region $574D-$7E8C)

SoundSong0B_Track0:: ; 04:79A4
Data_04_79A4::
	sound_volume $7F
	sound_pitch_add $00
Data_04_79A8:: ; 04:79A8
	sound_tempo $4E
	sound_instrument $00
	sound_wait 12
	sound_note 4, $47, $14
	sound_wait 12
	sound_rs sound_note 4, $42
	sound_wait 12
	sound_rs sound_note 4, $3B
	sound_wait 24
	sound_rs sound_note 4, $44
	sound_wait 12
	sound_rs sound_note 4, $42
	sound_wait 12
	sound_rs sound_note 4, $40
	sound_wait 12
	sound_wait 12
	sound_rs sound_note 4, $42
	sound_wait 12
	sound_rs sound_note 4, $47
	sound_wait 12
	sound_rs sound_note 4, $42
	sound_wait 12
	sound_note 12, $44
	sound_wait 12
	sound_note 4, $46
	sound_wait 12
	sound_rs sound_note 4, $47
	sound_wait 12
	sound_rs sound_note 4, $49
	sound_wait 12
	sound_wait 12
	sound_rs sound_note 4, $47
	sound_wait 12
	sound_rs sound_note 4, $42
	sound_wait 12
	sound_rs sound_note 4, $3B
	sound_wait 24
	sound_rs sound_note 4, $44
	sound_wait 12
	sound_rs sound_note 4, $42
	sound_wait 12
	sound_rs sound_note 4, $40
	sound_wait 12
	sound_note 12, $3F
	sound_wait 12
	sound_note 4, $3B
	sound_wait 12
	sound_note 12, $3D
	sound_wait 12
	sound_note 4, $3A
	sound_wait 12
	sound_note 12, $3B
	sound_wait 12
	sound_instrument $20
	sound_note 6, $3F, $11
	sound_wait 12
	sound_rs sound_note 6, $33
	sound_wait 24
	sound_jump Data_04_79A8
Data_04_79F3:: ; 04:79F3
	sound_end
SoundSong0B_Track1:: ; 04:79F4
Data_04_79F4::
	sound_volume $7F
	sound_pitch_add $00
Data_04_79F8:: ; 04:79F8
	sound_instrument $04
	sound_note 2, $4E, $09
	sound_wait 6
	sound_rs sound_note 2, $57
	sound_wait 6
	sound_note 6, $4B, $13
	sound_wait 6
	sound_note 2, $53, $09
	sound_wait 6
	sound_rs sound_note 2, $5A
	sound_wait 6
	sound_rs sound_note 2, $57
	sound_wait 6
	sound_note 6, $4B, $13
	sound_wait 6
	sound_note 2, $53, $09
	sound_wait 6
	sound_rs sound_note 2, $50
	sound_wait 6
	sound_rs sound_note 2, $58
	sound_wait 6
	sound_note 6, $4C, $13
	sound_wait 6
	sound_note 2, $53, $09
	sound_wait 6
	sound_rs sound_note 2, $5C
	sound_wait 6
	sound_rs sound_note 2, $58
	sound_wait 6
	sound_note 6, $4C, $13
	sound_wait 6
	sound_note 2, $53, $09
	sound_wait 6
	sound_rs sound_note 2, $4E
	sound_wait 6
	sound_rs sound_note 2, $57
	sound_wait 6
	sound_note 6, $4B, $13
	sound_wait 6
	sound_note 2, $53, $09
	sound_wait 6
	sound_rs sound_note 2, $5A
	sound_wait 6
	sound_rs sound_note 2, $57
	sound_wait 6
	sound_note 6, $4B, $13
	sound_wait 6
	sound_note 2, $53, $09
	sound_wait 6
	sound_note 12, $4C, $13
	sound_wait 12
	sound_note 6, $4E
	sound_wait 6
	sound_note 2, $52, $09
	sound_wait 6
	sound_note 6, $50, $13
	sound_wait 6
	sound_note 2, $53, $09
	sound_wait 6
	sound_note 6, $52, $13
	sound_wait 6
	sound_note 2, $55, $09
	sound_wait 6
	sound_rs sound_note 2, $4E
	sound_wait 6
	sound_rs sound_note 2, $57
	sound_wait 6
	sound_note 6, $4B, $13
	sound_wait 6
	sound_note 2, $53, $09
	sound_wait 6
	sound_rs sound_note 2, $5A
	sound_wait 6
	sound_rs sound_note 2, $57
	sound_wait 6
	sound_note 6, $4B, $13
	sound_wait 6
	sound_note 2, $53, $09
	sound_wait 6
	sound_rs sound_note 2, $50
	sound_wait 6
	sound_rs sound_note 2, $58
	sound_wait 6
	sound_note 6, $4C, $13
	sound_wait 6
	sound_note 2, $53, $09
	sound_wait 6
	sound_rs sound_note 2, $5C
	sound_wait 6
	sound_rs sound_note 2, $58
	sound_wait 6
	sound_note 6, $4C, $13
	sound_wait 6
	sound_note 2, $53, $09
	sound_wait 6
	sound_note 12, $4E, $13
	sound_wait 12
	sound_note 6, $4B
	sound_wait 6
	sound_note 2, $5A, $09
	sound_wait 6
	sound_note 12, $4C, $13
	sound_wait 12
	sound_note 6, $49
	sound_wait 6
	sound_note 2, $58, $09
	sound_wait 6
	sound_note 6, $4B, $13
	sound_wait 6
	sound_note 2, $5A, $09
	sound_wait 6
	sound_note 6, $47, $13
	sound_wait 6
	sound_note 2, $57, $09
	sound_wait 6
	sound_note 6, $3B, $13
	sound_wait 24
	sound_jump Data_04_79F8
Data_04_7ABC:: ; 04:7ABC
	sound_end
SoundSong0B_Track2:: ; 04:7ABD
Data_04_7ABD::
	sound_volume $7F
	sound_pitch_add $F4
Data_04_7AC1:: ; 04:7AC1
	sound_instrument $08
	sound_note 6, $2F, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 6, $4E, $13
	sound_wait 12
	sound_instrument $08
	sound_note 6, $36, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 6, $4E, $13
	sound_wait 12
	sound_instrument $08
	sound_note 6, $34, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 6, $50, $13
	sound_wait 12
	sound_instrument $08
	sound_note 6, $38, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 6, $50, $13
	sound_wait 12
	sound_instrument $08
	sound_note 6, $36, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 6, $4E, $13
	sound_wait 12
	sound_instrument $08
	sound_note 6, $2F, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 6, $4E, $13
	sound_wait 12
	sound_instrument $08
	sound_note 12, $31, $1F
	sound_wait 12
	sound_note 6, $33
	sound_wait 12
	sound_rs sound_note 6, $34
	sound_wait 12
	sound_rs sound_note 6, $36
	sound_wait 12
	sound_rs sound_note 6, $2F
	sound_wait 12
	sound_instrument $09
	sound_note 6, $4E, $13
	sound_wait 12
	sound_instrument $08
	sound_note 6, $36, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 6, $4E, $13
	sound_wait 12
	sound_instrument $08
	sound_note 6, $34, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 6, $50, $13
	sound_wait 12
	sound_instrument $08
	sound_note 6, $38, $1F
	sound_wait 12
	sound_instrument $09
	sound_note 6, $50, $13
	sound_wait 12
	sound_instrument $08
	sound_note 6, $36, $1F
	sound_wait 24
	sound_rs sound_note 6, $42
	sound_wait 24
	sound_instrument $09
	sound_note 6, $4E, $13
	sound_wait 12
	sound_instrument $08
	sound_note 6, $36, $1F
	sound_wait 12
	sound_rs sound_note 6, $2F
	sound_wait 24
	sound_jump Data_04_7AC1
Data_04_7B5B:: ; 04:7B5B
	sound_end
SoundSong0B_Track3:: ; 04:7B5C
Data_04_7B5C::
	sound_volume $7F
	sound_pitch_add $00
Data_04_7B60:: ; 04:7B60
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 6, $27, $12
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 6, $25, $10
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6, $2A
	sound_wait 6
	sound_note 3, $24
	sound_wait 6
	sound_note 3, $27, $12
	sound_wait 6
	sound_rs sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6, $27, $12
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6, $25, $10
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 3, $2A
	sound_wait 6
Data_04_7B98:: ; 04:7B98
	sound_note 6, $27, $12
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 6, $25, $10
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6, $2A
	sound_wait 6
	sound_note 3, $24
	sound_wait 6
	sound_note 3, $27, $12
	sound_wait 6
	sound_rs sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6, $27, $12
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 6, $25, $10
	sound_wait 6
	sound_note 3, $24, $0B
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 3, $2A
	sound_wait 6
	sound_ret
	sound_call Data_04_7B98
	sound_call Data_04_7B98
	sound_jump Data_04_7B60
Data_04_7BD8:: ; 04:7BD8
	sound_end
SoundSong0B_Header:: ; 04:7BD9
Data_04_7BD9::
	sound_stream_header 4, 2
	dw SoundSong0B_Track0, SoundSong0B_Track1, SoundSong0B_Track2, SoundSong0B_Track3 ; track stream pointers (read by the driver)
	dw Data_04_79A8, Data_04_79F8, Data_04_7AC1, Data_04_7B60 ; not read by the driver: target of each track's final sound_jump
	dw Data_04_79F3, Data_04_7ABC, Data_04_7B5B, Data_04_7BD8 ; not read by the driver: address after each track's final sound_jump
