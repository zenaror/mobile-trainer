; audio/music/music_0c.asm
; bank 04, $7BF3-$7DBC (457 bytes); pinned by layout.link
; song id 0C

SECTION "audio/music/music_0c", ROMX

; ---- data $7BF3-$7DBC (457 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; command semantics not decoded (part of region $574D-$7E8C)

Data_04_7BF3:: ; 04:7BF3
	sound_volume $7F
	sound_pitch_add $00
Data_04_7BF7:: ; 04:7BF7
	sound_tempo $47
	sound_instrument $02
	sound_note 5, $49, $15
	sound_wait 12
	sound_rs sound_note_mod 5, $08
	sound_wait 24
	sound_note 5, $44, $15
	sound_wait 12
	sound_rs sound_note_mod 5, $08
	sound_wait 24
	sound_note 12, $47, $15
	sound_wait 12
	sound_note 5, $46
	sound_wait 12
	sound_note_mod 5, $08
	sound_wait 36
	sound_note 5, $42, $15
	sound_wait 12
	sound_note 12, $43
	sound_wait 12
	sound_note 5, $44
	sound_wait 12
	sound_note 12, $43
	sound_wait 12
	sound_note 5, $44
	sound_wait 12
	sound_rs sound_note 5, $49
	sound_wait 12
	sound_note_mod 5, $08
	sound_wait 24
	sound_note 5, $44, $15
	sound_wait 12
	sound_rs sound_note_mod 5, $08
	sound_wait 24
	sound_note 12, $47, $15
	sound_wait 12
	sound_note 5, $46
	sound_wait 12
	sound_note_mod 5, $08
	sound_wait 60
	sound_note 5, $44, $15
	sound_wait 12
	sound_note 12
	sound_wait 12
	sound_note_mod 12, $08
	sound_wait 12
	sound_jump Data_04_7BF7
Data_04_7C42:: ; 04:7C42
	sound_end
Data_04_7C43:: ; 04:7C43
	sound_volume $7F
	sound_pitch_add $00
Data_04_7C47:: ; 04:7C47
	sound_instrument $06
	sound_note 5, $44, $13
	sound_wait 12
	sound_instrument $04
	sound_note 5, $5C, $0C
	sound_wait 12
	sound_note 12
	sound_wait 12
	sound_instrument $06
	sound_note 5, $3D, $13
	sound_wait 12
	sound_instrument $04
	sound_note 5, $5C, $0C
	sound_wait 12
	sound_note 5
	sound_wait 12
	sound_instrument $06
	sound_note 12, $41, $13
	sound_wait 12
	sound_note 5, $40
	sound_wait 12
	sound_wait 12
	sound_instrument $04
	sound_note 5, $5C, $0C
	sound_wait 12
	sound_note 12
	sound_wait 12
	sound_instrument $06
	sound_note 5, $3A, $13
	sound_wait 12
	sound_note 12, $3B
	sound_wait 12
	sound_note 5, $3C
	sound_wait 12
	sound_note 12, $3B
	sound_wait 12
	sound_note 5, $3C
	sound_wait 12
	sound_rs sound_note 5, $41
	sound_wait 12
	sound_instrument $04
	sound_note 5, $5C, $0C
	sound_wait 12
	sound_note 12
	sound_wait 12
	sound_instrument $06
	sound_note 5, $3D, $13
	sound_wait 12
	sound_instrument $04
	sound_note 5, $5C, $0C
	sound_wait 12
	sound_note 5
	sound_wait 12
	sound_instrument $06
	sound_note 12, $41, $13
	sound_wait 12
	sound_note 5, $40
	sound_wait 12
	sound_wait 12
	sound_instrument $04
	sound_note 5, $5C, $0C
	sound_wait 12
	sound_note 12
	sound_wait 36
	sound_instrument $06
	sound_note 5, $3C, $13
	sound_wait 12
	sound_note 12
	sound_wait 24
	sound_jump Data_04_7C47
Data_04_7CBC:: ; 04:7CBC
	sound_end
Data_04_7CBD:: ; 04:7CBD
	sound_volume $7F
	sound_pitch_add $00
Data_04_7CC1:: ; 04:7CC1
	sound_instrument $08
	sound_note 12, $25, $1F
	sound_wait 12
	sound_note 6, $2C
	sound_wait 12
	sound_rs sound_note 6, $31
	sound_wait 12
	sound_rs sound_note 6, $2F
	sound_wait 24
	sound_rs sound_note 6, $2C
	sound_wait 24
	sound_rs sound_note 6, $2A
	sound_wait 12
	sound_wait 36
	sound_rs sound_note 6, $31
	sound_wait 12
	sound_note 12, $2B
	sound_wait 12
	sound_note 6, $2C
	sound_wait 12
	sound_note 12, $2B
	sound_wait 12
	sound_note 6, $2C
	sound_wait 12
	sound_note 12, $25
	sound_wait 12
	sound_note 6, $2C
	sound_wait 12
	sound_rs sound_note 6, $31
	sound_wait 12
	sound_rs sound_note 6, $2F
	sound_wait 24
	sound_rs sound_note 6, $2C
	sound_wait 24
	sound_rs sound_note 6, $2A
	sound_wait 12
	sound_wait 60
	sound_rs sound_note 6, $32
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_jump Data_04_7CC1
Data_04_7CF7:: ; 04:7CF7
	sound_end
Data_04_7CF8:: ; 04:7CF8
	sound_volume $7F
	sound_pitch_add $00
Data_04_7CFC:: ; 04:7CFC
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 6, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_cmd_C1 $28
	sound_note 6, $25, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 6, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_cmd_C1 $28
	sound_note 6, $25, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 3
	sound_wait 12
	sound_note 6, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_cmd_C1 $28
	sound_note 6, $25, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 6, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 3
	sound_wait 12
	sound_cmd_C1 $28
	sound_note 6, $25, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 6, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_cmd_C1 $28
	sound_note 6, $25, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 6, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_cmd_C1 $28
	sound_note 6, $25, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 3
	sound_wait 12
	sound_note 6, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_cmd_C1 $28
	sound_note 6, $25, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 6, $27, $10
	sound_wait 12
	sound_note 3, $24, $0B
	sound_wait 12
	sound_note 3
	sound_wait 12
	sound_cmd_C1 $28
	sound_note 6, $25, $0E
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 12, $24, $0D
	sound_wait 12
	sound_jump Data_04_7CFC
Data_04_7DA1:: ; 04:7DA1
	sound_end
Data_04_7DA2:: ; 04:7DA2
	sound_stream_header 4, 2
	dw Data_04_7BF3, Data_04_7C43, Data_04_7CBD, Data_04_7CF8 ; track stream pointers (read by the driver)
	dw Data_04_7BF7, Data_04_7C47, Data_04_7CC1, Data_04_7CFC ; not read by the driver: target of each track's final sound_jump
	dw Data_04_7C42, Data_04_7CBC, Data_04_7CF7, Data_04_7DA1 ; not read by the driver: address after each track's final sound_jump
