; audio/music/music_06.asm
; bank 04, $683C-$6B54 (792 bytes); pinned by layout.link
; song id 06

SECTION "audio/music/music_06", ROMX

; ---- data $683C-$6B54 (792 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; command semantics not decoded (part of region $574D-$7E8C)

Data_04_683C:: ; 04:683C
	sound_volume $7F
	sound_pitch_add $00
Data_04_6840:: ; 04:6840
	sound_tempo $24
	sound_instrument $53
	sound_note 8, $4A, $1C
	sound_wait 12
	sound_note 3
	sound_wait 12
	sound_note_mod 2, $1A
	sound_wait 6
	sound_note_mod 3, $1C
	sound_wait 12
	sound_note 14
	sound_wait 18
	sound_note 3
	sound_wait 12
	sound_note_mod 2, $1A
	sound_wait 6
	sound_note_mod 3, $1C
	sound_wait 12
	sound_note 14
	sound_wait 6
	sound_wait 12
	sound_note 3
	sound_wait 12
	sound_note_mod 2, $1A
	sound_wait 6
	sound_note_mod 3, $1C
	sound_wait 12
	sound_note 3, $4C
	sound_wait 12
	sound_rs sound_note 3, $4A
	sound_wait 12
	sound_rs sound_note 3, $48
	sound_wait 12
	sound_note 12, $47
	sound_wait 18
	sound_note 8, $48
	sound_wait 12
	sound_note 3
	sound_wait 12
	sound_note_mod 2, $1A
	sound_wait 6
	sound_note_mod 3, $1C
	sound_wait 12
	sound_note 2
	sound_wait 12
	sound_note 3
	sound_wait 12
	sound_note 12, $47
	sound_wait 12
	sound_note 6, $48
	sound_wait 6
	sound_note 12, $4A
	sound_wait 12
	sound_note 3, $48
	sound_wait 12
	sound_note 3
	sound_wait 12
	sound_note 3, $45
	sound_wait 12
	sound_rs sound_note 3, $48
	sound_wait 30
	sound_note 24, $4A
	sound_wait 30
	sound_jump Data_04_6840
Data_04_6897:: ; 04:6897
	sound_end
Data_04_6898:: ; 04:6898
	sound_volume $7F
	sound_pitch_add $00
Data_04_689C:: ; 04:689C
	sound_instrument $05
	sound_note 6, $53, $0B
	sound_wait 12
	sound_instrument $06
	sound_note 4, $47, $11
	sound_wait 18
	sound_note 4
	sound_wait 12
	sound_instrument $05
	sound_note 6, $52, $0B
	sound_wait 6
	sound_instrument $06
	sound_note 4, $46, $11
	sound_wait 18
	sound_note 4
	sound_wait 18
	sound_note 4
	sound_wait 6
	sound_instrument $05
	sound_note 6, $51, $0B
	sound_wait 6
	sound_wait 12
	sound_instrument $06
	sound_note 4, $45, $11
	sound_wait 18
	sound_note 4
	sound_wait 12
	sound_instrument $05
	sound_note 4, $53, $0B
	sound_wait 6
	sound_instrument $06
	sound_note 4, $44, $11
	sound_wait 6
	sound_instrument $05
	sound_note 4, $50, $0B
	sound_wait 12
	sound_instrument $06
	sound_note 4, $45, $11
	sound_wait 12
	sound_instrument $05
	sound_note 6, $4A, $0B
	sound_wait 6
	sound_instrument $06
	sound_note 12, $47, $11
	sound_wait 12
	sound_instrument $05
	sound_note 6, $51, $0B
	sound_wait 12
	sound_instrument $06
	sound_note 4, $45, $11
	sound_wait 12
	sound_instrument $05
	sound_note 4, $50, $0B
	sound_wait 6
	sound_instrument $06
	sound_note 4, $44, $11
	sound_wait 12
	sound_instrument $05
	sound_note 4, $4F, $0B
	sound_wait 6
	sound_instrument $06
	sound_note 4, $43, $11
	sound_wait 18
	sound_instrument $06
	sound_note 12, $3E, $0B
	sound_wait 12
	sound_note 6, $40
	sound_wait 6
	sound_note 12, $41
	sound_wait 12
	sound_note 4, $40
	sound_wait 12
	sound_instrument $06
	sound_note 5, $43, $11
	sound_wait 12
	sound_rs sound_note 5, $3F
	sound_wait 12
	sound_note 4, $43
	sound_wait 30
	sound_note 12, $45
	sound_wait 30
	sound_jump Data_04_689C
Data_04_6931:: ; 04:6931
	sound_end
Data_04_6932:: ; 04:6932
	sound_volume $7F
	sound_pitch_add $00
Data_04_6936:: ; 04:6936
	sound_instrument $20
	sound_note 12, $2B, $1D
	sound_wait 12
	sound_instrument $02
	sound_note 4, $4F, $11
	sound_wait 6
	sound_instrument $20
	sound_note 4, $32, $1D
	sound_wait 6
	sound_note 6
	sound_wait 6
	sound_instrument $02
	sound_note 4, $4F, $11
	sound_wait 12
	sound_instrument $20
	sound_note 18, $2A, $1D
	sound_wait 6
	sound_instrument $02
	sound_note 4, $4E, $11
	sound_wait 18
	sound_note 4
	sound_wait 18
	sound_note 4
	sound_wait 6
	sound_instrument $20
	sound_note 6, $2A, $1D
	sound_wait 6
	sound_note 12, $29
	sound_wait 12
	sound_instrument $02
	sound_note 4, $4D, $11
	sound_wait 6
	sound_instrument $20
	sound_note 4, $32, $1D
	sound_wait 6
	sound_note 6
	sound_wait 6
	sound_instrument $02
	sound_note 4, $4D, $11
	sound_wait 12
	sound_instrument $20
	sound_note 6, $28, $1D
	sound_wait 6
	sound_instrument $02
	sound_note 4, $4C, $11
	sound_wait 12
	sound_instrument $20
	sound_note 6, $2A, $1D
	sound_wait 6
	sound_instrument $02
	sound_note 4, $4E, $11
	sound_wait 12
	sound_instrument $20
	sound_note 6, $2C, $1D
	sound_wait 6
	sound_instrument $02
	sound_note 12, $50, $11
	sound_wait 12
	sound_instrument $20
	sound_note 12, $2D, $1D
	sound_wait 12
	sound_instrument $02
	sound_note 4, $4C, $11
	sound_wait 6
	sound_instrument $20
	sound_note 4, $2D, $1D
	sound_wait 6
	sound_note 6, $2C
	sound_wait 6
	sound_instrument $02
	sound_note 4, $4B, $11
	sound_wait 12
	sound_instrument $20
	sound_note 6, $2B, $1D
	sound_wait 6
	sound_instrument $02
	sound_note 4, $4A, $11
	sound_wait 18
	sound_instrument $20
	sound_note 6, $26, $1D
	sound_wait 6
	sound_rs sound_note 6, $2B
	sound_wait 6
	sound_rs sound_note 6, $2D
	sound_wait 6
	sound_note 12, $2F
	sound_wait 12
	sound_note 4, $30
	sound_wait 12
	sound_instrument $02
	sound_note 5, $4C, $11
	sound_wait 12
	sound_rs sound_note 5, $4D
	sound_wait 12
	sound_note 4, $4C
	sound_wait 30
	sound_note 12, $4E
	sound_wait 12
	sound_instrument $20
	sound_note 6, $26, $1D
	sound_wait 6
	sound_rs sound_note 6, $28
	sound_wait 6
	sound_rs sound_note 6, $2A
	sound_wait 6
	sound_jump Data_04_6936
Data_04_69F3:: ; 04:69F3
	sound_end
Data_04_69F4:: ; 04:69F4
	sound_volume $7F
	sound_pitch_add $00
Data_04_69F8:: ; 04:69F8
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 3, $27, $11
	sound_wait 6
	sound_note 2, $24, $0B
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 3, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $27, $11
	sound_wait 6
	sound_note 2, $24, $0B
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 3, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 2, $24, $0B
	sound_wait 6
	sound_note 2
	sound_wait 6
	sound_note 3, $27, $11
	sound_wait 6
	sound_note 2, $24, $0B
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 3, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $27, $11
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 2, $24, $0B
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 3, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 2, $24, $0B
	sound_wait 6
	sound_note 3, $27, $11
	sound_wait 6
	sound_note 2, $24, $0B
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 3, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $27, $11
	sound_wait 6
	sound_note 2, $24, $0B
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 3, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 2, $24, $0B
	sound_wait 6
	sound_note 2
	sound_wait 6
	sound_note 3, $27, $11
	sound_wait 6
	sound_note 2, $24, $0B
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 3, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $27, $11
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 2, $24, $0B
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 3, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 6, $24, $0D
	sound_wait 6
	sound_note 3, $27, $11
	sound_wait 6
	sound_note 2, $24, $0B
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 3, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $27, $11
	sound_wait 6
	sound_note 2, $24, $0B
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 3, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 2, $24, $0B
	sound_wait 6
	sound_note 2
	sound_wait 6
	sound_note 3, $27, $11
	sound_wait 6
	sound_note 2, $24, $0B
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 3, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $27, $11
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 2, $24, $0B
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 3, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 2, $24, $0B
	sound_wait 6
	sound_note 3, $27, $11
	sound_wait 6
	sound_note 2, $24, $0B
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 3, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $27, $11
	sound_wait 6
	sound_note 2, $24, $0B
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 3, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 2, $24, $0B
	sound_wait 6
	sound_note 2
	sound_wait 6
	sound_note 2
	sound_wait 6
	sound_note 2
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 3, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 2, $24, $0B
	sound_wait 6
	sound_note 2
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 3, $2F, $0F
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $27, $11
	sound_wait 6
	sound_note 6, $24, $0D
	sound_wait 6
	sound_jump Data_04_69F8
Data_04_6B39:: ; 04:6B39
	sound_end
Data_04_6B3A:: ; 04:6B3A
	sound_stream_header 4, 2
	dw Data_04_683C, Data_04_6898, Data_04_6932, Data_04_69F4 ; track stream pointers (read by the driver)
	dw Data_04_6840, Data_04_689C, Data_04_6936, Data_04_69F8 ; not read by the driver: target of each track's final sound_jump
	dw Data_04_6897, Data_04_6931, Data_04_69F3, Data_04_6B39 ; not read by the driver: address after each track's final sound_jump
