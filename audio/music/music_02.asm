; audio/music/music_02.asm
; bank 04, $58C6-$5CD9 (1043 bytes); pinned by layout.link
; song id 02

SECTION "audio/music/music_02", ROMX

; ---- data $58C6-$5CD9 (1043 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; command semantics not decoded (part of region $574D-$7E8C)

Data_04_58C6:: ; 04:58C6
	sound_volume $7F
	sound_pitch_add $00
Data_04_58CA:: ; 04:58CA
	sound_tempo $4F
	sound_instrument $00
	sound_wait 24
	sound_note 3, $3F, $13
	sound_wait 3
	sound_note 9, $40, $14
	sound_wait 9
	sound_rs sound_note 9, $3F
	sound_wait 12
	sound_note 6, $40
	sound_wait 12
	sound_note 18, $41
	sound_wait 24
	sound_rs sound_note 18, $43
	sound_wait 12
	sound_wait 12
	sound_rs sound_note 18, $3C
	sound_wait 24
	sound_rs sound_note 18, $3E
	sound_wait 36
	sound_rs sound_note 18, $3C
	sound_wait 24
	sound_rs sound_note 18, $3F
	sound_wait 24
	sound_rs sound_note 18, $3C
	sound_wait 24
	sound_note 6
	sound_wait 12
	sound_note 18, $3E
	sound_wait 24
	sound_note 54, $3C
	sound_wait 12
	sound_wait 96
	sound_wait 24
	sound_note 3, $3F, $13
	sound_wait 3
	sound_note 9, $40, $14
	sound_wait 9
	sound_rs sound_note 9, $3F
	sound_wait 12
	sound_note 6, $40
	sound_wait 12
	sound_note 18, $43
	sound_wait 24
	sound_rs sound_note 18, $47
	sound_wait 12
	sound_wait 12
	sound_rs sound_note 18, $45
	sound_wait 24
	sound_rs sound_note 18, $43
	sound_wait 36
	sound_rs sound_note 18, $40
	sound_wait 24
	sound_note 18
	sound_wait 24
	sound_note 18, $3C
	sound_wait 24
	sound_note 6
	sound_wait 12
	sound_note 18, $39
	sound_wait 24
	sound_note 54, $3E
	sound_wait 12
	sound_wait 48
	sound_instrument $01
	sound_note 6, $43, $13
	sound_wait 6
	sound_rs sound_note 6, $4A, $0D
	sound_wait 6
	sound_rs sound_note 6, $4D
	sound_wait 6
	sound_rs sound_note 6, $51
	sound_wait 6
	sound_note 4, $46, $13
	sound_wait 4
	sound_rs sound_note 4, $4F, $0D
	sound_wait 4
	sound_rs sound_note 4, $52
	sound_wait 4
	sound_rs sound_note 4, $55
	sound_wait 4
	sound_rs sound_note 4, $59
	sound_wait 4
	sound_rs sound_note 4, $5C
	sound_wait 4
	sound_jump Data_04_58CA
Data_04_593C:: ; 04:593C
	sound_end
Data_04_593D:: ; 04:593D
	sound_volume $7F
	sound_pitch_add $00
Data_04_5941:: ; 04:5941
	sound_instrument $04
	sound_note 3, $4F, $0A
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_rs sound_note 3, $58
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_note 6, $48, $18
	sound_wait 6
	sound_note 3, $58, $0A
	sound_wait 6
	sound_rs sound_note 3, $4F
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_rs sound_note 3, $58
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_rs sound_note 3, $5B
	sound_wait 6
	sound_rs sound_note 3, $58
	sound_wait 6
	sound_note 6, $48, $18
	sound_wait 6
	sound_note 3, $5B, $0A
	sound_wait 6
	sound_rs sound_note 3, $58
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_rs sound_note 3, $4F
	sound_wait 6
	sound_rs sound_note 3, $52
	sound_wait 6
	sound_rs sound_note 3, $58
	sound_wait 6
	sound_rs sound_note 3, $52
	sound_wait 6
	sound_rs sound_note 3, $60
	sound_wait 6
	sound_rs sound_note 3, $58
	sound_wait 6
	sound_rs sound_note 3, $4F
	sound_wait 6
	sound_rs sound_note 3, $52
	sound_wait 6
	sound_rs sound_note 3, $58
	sound_wait 6
	sound_rs sound_note 3, $52
	sound_wait 6
	sound_note 6, $48, $18
	sound_wait 6
	sound_note 2, $58, $0A
	sound_wait 6
	sound_note 12, $48, $18
	sound_wait 12
	sound_note 3, $58, $0A
	sound_wait 6
	sound_rs sound_note 3, $52
	sound_wait 6
	sound_rs sound_note 3, $51
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_rs sound_note 3, $57
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_note 6, $48, $18
	sound_wait 6
	sound_note 3, $57, $0A
	sound_wait 6
	sound_rs sound_note 3, $51
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_rs sound_note 3, $57
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_rs sound_note 3, $5D
	sound_wait 6
	sound_rs sound_note 3, $57
	sound_wait 6
	sound_note 6, $48, $18
	sound_wait 6
	sound_note 3, $5D, $0A
	sound_wait 6
	sound_rs sound_note 3, $57
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_rs sound_note 3, $51
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_rs sound_note 3, $57
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_rs sound_note 3, $5D
	sound_wait 6
	sound_rs sound_note 3, $57
	sound_wait 6
	sound_rs sound_note 3, $51
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_rs sound_note 3, $57
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_note 6, $48, $18
	sound_wait 6
	sound_note 2, $57, $0A
	sound_wait 6
	sound_note 12, $48, $18
	sound_wait 12
	sound_note 3, $57, $0A
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_rs sound_note 3, $4F
	sound_wait 6
	sound_rs sound_note 3, $53
	sound_wait 6
	sound_rs sound_note 3, $58
	sound_wait 6
	sound_rs sound_note 3, $53
	sound_wait 6
	sound_note 6, $47, $18
	sound_wait 6
	sound_note 3, $58, $0A
	sound_wait 6
	sound_rs sound_note 3, $4F
	sound_wait 6
	sound_rs sound_note 3, $53
	sound_wait 6
	sound_rs sound_note 3, $58
	sound_wait 6
	sound_rs sound_note 3, $53
	sound_wait 6
	sound_rs sound_note 3, $5B
	sound_wait 6
	sound_rs sound_note 3, $58
	sound_wait 6
	sound_note 6, $47, $18
	sound_wait 6
	sound_note 3, $5B, $0A
	sound_wait 6
	sound_rs sound_note 3, $58
	sound_wait 6
	sound_rs sound_note 3, $55
	sound_wait 6
	sound_rs sound_note 3, $51
	sound_wait 6
	sound_rs sound_note 3, $55
	sound_wait 6
	sound_rs sound_note 3, $58
	sound_wait 6
	sound_rs sound_note 3, $55
	sound_wait 6
	sound_rs sound_note 3, $5D
	sound_wait 6
	sound_rs sound_note 3, $58
	sound_wait 6
	sound_rs sound_note 3, $51
	sound_wait 6
	sound_rs sound_note 3, $55
	sound_wait 6
	sound_rs sound_note 3, $58
	sound_wait 6
	sound_rs sound_note 3, $55
	sound_wait 6
	sound_note 6, $49, $18
	sound_wait 6
	sound_note 2, $58, $0A
	sound_wait 6
	sound_note 12, $49, $18
	sound_wait 12
	sound_note 3, $58, $0A
	sound_wait 6
	sound_rs sound_note 3, $49
	sound_wait 6
	sound_note 2, $51
	sound_wait 6
	sound_note 3, $54
	sound_wait 6
	sound_rs sound_note 3, $5A
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_note 6, $48, $18
	sound_wait 6
	sound_note 3, $54, $0A
	sound_wait 6
	sound_rs sound_note 3, $51
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_rs sound_note 3, $5A
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_rs sound_note 3, $5D
	sound_wait 6
	sound_rs sound_note 3, $5A
	sound_wait 6
	sound_note 6, $48, $18
	sound_wait 6
	sound_note 3, $5D, $0A
	sound_wait 6
	sound_rs sound_note 3, $5A
	sound_wait 6
	sound_rs sound_note 3, $54
	sound_wait 6
	sound_rs sound_note 3, $4F
	sound_wait 6
	sound_rs sound_note 3, $53
	sound_wait 6
	sound_rs sound_note 3, $56
	sound_wait 6
	sound_rs sound_note 3, $53
	sound_wait 6
	sound_rs sound_note 3, $5B
	sound_wait 6
	sound_rs sound_note 3, $56
	sound_wait 6
	sound_rs sound_note 3, $4F
	sound_wait 6
	sound_rs sound_note 3, $53
	sound_wait 6
	sound_instrument $05
	sound_note 6, $3B, $13
	sound_wait 6
	sound_rs sound_note 6, $43, $0D
	sound_wait 6
	sound_rs sound_note 6, $45
	sound_wait 6
	sound_rs sound_note 6, $48
	sound_wait 6
	sound_note 4, $3F, $13
	sound_wait 4
	sound_rs sound_note 4, $46, $0D
	sound_wait 4
	sound_rs sound_note 4, $4B
	sound_wait 4
	sound_rs sound_note 4, $4D
	sound_wait 4
	sound_rs sound_note 4, $50
	sound_wait 4
	sound_rs sound_note 4, $55
	sound_wait 4
	sound_jump Data_04_5941
Data_04_5A88:: ; 04:5A88
	sound_end
Data_04_5A89:: ; 04:5A89
	sound_volume $7F
	sound_pitch_add $00
Data_04_5A8D:: ; 04:5A8D
	sound_instrument $08
	sound_note 24, $24, $1F
	sound_wait 24
	sound_instrument $09
	sound_note 6, $40, $18
	sound_wait 12
	sound_instrument $08
	sound_note 4, $2B, $1F
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_instrument $09
	sound_note 12, $40, $18
	sound_wait 12
	sound_instrument $08
	sound_note 24, $30, $1F
	sound_wait 12
	sound_wait 12
	sound_note 6, $2E
	sound_wait 12
	sound_note 36, $30
	sound_wait 36
	sound_instrument $09
	sound_note 6, $40, $18
	sound_wait 12
	sound_note 12
	sound_wait 12
	sound_instrument $08
	sound_note 12, $28, $1F
	sound_wait 12
	sound_note 24, $29
	sound_wait 24
	sound_instrument $09
	sound_note 6, $3F, $18
	sound_wait 12
	sound_instrument $08
	sound_note 4, $30, $1F
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_instrument $09
	sound_note 12, $3F, $18
	sound_wait 12
	sound_instrument $08
	sound_note 24, $35, $1F
	sound_wait 12
	sound_wait 12
	sound_note 6, $33
	sound_wait 12
	sound_note 36, $35
	sound_wait 36
	sound_instrument $09
	sound_note 6, $3F, $18
	sound_wait 12
	sound_note 12
	sound_wait 12
	sound_instrument $08
	sound_note 12, $30, $1F
	sound_wait 12
	sound_instrument $08
	sound_note 24, $28
	sound_wait 24
	sound_instrument $09
	sound_note 6, $40, $18
	sound_wait 12
	sound_instrument $08
	sound_note 4, $2F, $1F
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_instrument $09
	sound_note 12, $40, $18
	sound_wait 12
	sound_instrument $08
	sound_note 24, $2D, $1F
	sound_wait 12
	sound_wait 12
	sound_note 6, $28
	sound_wait 12
	sound_note 36
	sound_wait 36
	sound_instrument $09
	sound_note 6, $40, $18
	sound_wait 12
	sound_note 12
	sound_wait 12
	sound_instrument $08
	sound_note 12, $2D, $1F
	sound_wait 12
	sound_note 24, $26
	sound_wait 24
	sound_instrument $09
	sound_note 6, $42, $18
	sound_wait 12
	sound_instrument $08
	sound_note 4, $2D, $1F
	sound_wait 12
	sound_note 24
	sound_wait 24
	sound_instrument $09
	sound_note 12, $42, $18
	sound_wait 12
	sound_instrument $08
	sound_note 24, $2B, $1F
	sound_wait 12
	sound_wait 12
	sound_note 6, $26
	sound_wait 12
	sound_note 36, $2B
	sound_wait 36
	sound_note 12, $29
	sound_wait 12
	sound_rs sound_note 12, $27
	sound_wait 12
	sound_rs sound_note 12, $25
	sound_wait 12
	sound_jump Data_04_5A8D
Data_04_5B55:: ; 04:5B55
	sound_end
Data_04_5B56:: ; 04:5B56
	sound_volume $7F
	sound_pitch_add $00
Data_04_5B5A:: ; 04:5B5A
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 6, $27, $15
	sound_wait 6
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 6, $25, $12
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 6, $27, $15
	sound_wait 6
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 6, $25, $12
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 6, $27, $15
	sound_wait 6
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 3
	sound_wait 6
Data_04_5B9A:: ; 04:5B9A
	sound_note 6, $27, $15
	sound_wait 6
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 6, $27, $15
	sound_wait 6
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 6, $25, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $24, $0C
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 6, $25, $12
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 6, $27, $15
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 6, $25, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_ret
Data_04_5BDE:: ; 04:5BDE
	sound_note 6, $27, $15
	sound_wait 6
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 6, $25, $12
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 6, $27, $15
	sound_wait 6
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 6, $25, $12
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 6, $27, $15
	sound_wait 6
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_ret
	sound_note 6, $27, $15
	sound_wait 6
	sound_note 3, $24, $0C
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 6, $25, $12
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 6, $27, $15
	sound_wait 6
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 6, $25, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_rs sound_cmd_C1 $28
	sound_note_mod 6, $12
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $24, $0C
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 6, $25, $12
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 6, $27, $15
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 6, $25, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_call Data_04_5BDE
	sound_call Data_04_5B9A
	sound_call Data_04_5BDE
	sound_note 6, $27, $15
	sound_wait 6
	sound_note 3, $24, $0C
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 6, $25, $12
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 4, $27, $15
	sound_wait 6
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_cmd_C1 $28
	sound_note 6, $25, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_rs sound_cmd_C1 $28
	sound_note_mod 6, $12
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 5
	sound_note 3, $24, $0C
	sound_wait 6
	sound_note 4, $26
	sound_wait 4
	sound_note 4
	sound_wait 4
	sound_note 4
	sound_wait 4
	sound_note 4
	sound_wait 4
	sound_note 4
	sound_wait 4
	sound_note 4
	sound_wait 4
	sound_jump Data_04_5B5A
Data_04_5CBE:: ; 04:5CBE
	sound_end
Data_04_5CBF:: ; 04:5CBF
	sound_stream_header 4, 2
	dw Data_04_58C6, Data_04_593D, Data_04_5A89, Data_04_5B56 ; track stream pointers (read by the driver)
	dw Data_04_58CA, Data_04_5941, Data_04_5A8D, Data_04_5B5A ; not read by the driver: target of each track's final sound_jump
	dw Data_04_593C, Data_04_5A88, Data_04_5B55, Data_04_5CBE ; not read by the driver: address after each track's final sound_jump
