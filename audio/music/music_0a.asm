; audio/music/music_0a.asm
; bank 04, $77E9-$79A4 (443 bytes); pinned by layout.link
; song id 0A

SECTION "audio/music/music_0a", ROMX

; ---- data $77E9-$79A4 (443 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; command semantics not decoded (part of region $574D-$7E8C)

Data_04_77E9:: ; 04:77E9
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $42
	sound_instrument $4D
	sound_cmd_C5 $18
	sound_cmd_C4 $28
	sound_note 48, $45, $1A
	sound_wait 48
	sound_note 24, $48
	sound_wait 24
Data_04_77FC:: ; 04:77FC
	sound_note 48, $4C, $1A
	sound_wait 48
	sound_note 24, $51
	sound_wait 24
	sound_ret
	sound_note 84, $4F
	sound_wait 72
	sound_wait 72
Data_04_7808:: ; 04:7808
	sound_note 48, $45, $1A
	sound_wait 48
	sound_note 24, $48
	sound_wait 24
	sound_ret
	sound_note 48, $4A
	sound_wait 48
	sound_note 24, $4C
	sound_wait 24
	sound_note 48, $4F
	sound_wait 48
	sound_note 24, $4A
	sound_wait 24
	sound_note 48, $47
	sound_wait 48
	sound_note 24, $43
	sound_wait 24
	sound_call Data_04_7808
	sound_call Data_04_77FC
	sound_note 84, $4F, $1A
	sound_wait 72
	sound_wait 72
	sound_note 24, $54
	sound_wait 24
	sound_rs sound_note 24, $51
	sound_wait 24
	sound_rs sound_note 24, $4D
	sound_wait 24
	sound_note 48, $4C
	sound_wait 48
	sound_note 24, $4A
	sound_wait 24
	sound_note 84, $48
	sound_wait 72
	sound_wait 72
	sound_call Data_04_7808
	sound_jump Data_04_77FC
Data_04_7844:: ; 04:7844
	sound_end
Data_04_7845:: ; 04:7845
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $2B
	sound_note 12, $35, $10
	sound_wait 12
	sound_rs sound_note 12, $3C
	sound_wait 12
	sound_rs sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_rs sound_note 12, $48
	sound_wait 12
	sound_rs sound_note 12, $4C
	sound_wait 12
Data_04_7859:: ; 04:7859
	sound_note 12, $35, $10
	sound_wait 12
	sound_rs sound_note 12, $3C
	sound_wait 12
	sound_rs sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_rs sound_note 12, $48
	sound_wait 12
	sound_rs sound_note 12, $4C
	sound_wait 12
	sound_ret
Data_04_7868:: ; 04:7868
	sound_note 12, $34, $10
	sound_wait 12
	sound_rs sound_note 12, $3B
	sound_wait 12
	sound_rs sound_note 12, $40
	sound_wait 12
	sound_rs sound_note 12, $43
	sound_wait 12
	sound_rs sound_note 12, $47
	sound_wait 12
	sound_rs sound_note 12, $4A
	sound_wait 12
	sound_ret
	sound_call Data_04_7868
Data_04_787A:: ; 04:787A
	sound_note 12, $32, $10
	sound_wait 12
	sound_rs sound_note 12, $39
	sound_wait 12
	sound_rs sound_note 12, $3E
	sound_wait 12
	sound_rs sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_rs sound_note 12, $48
	sound_wait 12
	sound_ret
	sound_call Data_04_787A
Data_04_788C:: ; 04:788C
	sound_note 12, $30, $10
	sound_wait 12
	sound_rs sound_note 12, $37
	sound_wait 12
	sound_rs sound_note 12, $3C
	sound_wait 12
	sound_rs sound_note 12, $43
	sound_wait 12
	sound_rs sound_note 12, $47
	sound_wait 12
	sound_rs sound_note 12, $4A
	sound_wait 12
	sound_ret
	sound_rs sound_note 12, $30
	sound_wait 12
	sound_rs sound_note 12, $37
	sound_wait 12
	sound_rs sound_note 12, $3C
	sound_wait 12
	sound_rs sound_note 12, $40
	sound_wait 12
	sound_rs sound_note 12, $43
	sound_wait 12
	sound_rs sound_note 12, $47
	sound_wait 12
	sound_call Data_04_7859
	sound_call Data_04_7859
	sound_call Data_04_7868
	sound_call Data_04_7868
	sound_call Data_04_787A
	sound_note 12, $2B, $10
	sound_wait 12
	sound_rs sound_note 12, $37
	sound_wait 12
	sound_rs sound_note 12, $3E
	sound_wait 12
	sound_rs sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_rs sound_note 12, $48
	sound_wait 12
	sound_call Data_04_788C
	sound_note 12, $4F, $10
	sound_wait 12
	sound_rs sound_note 12, $4C
	sound_wait 12
	sound_rs sound_note 12, $4A
	sound_wait 12
	sound_rs sound_note 12, $47
	sound_wait 12
	sound_rs sound_note 12, $43
	sound_wait 12
	sound_rs sound_note 12, $4C
	sound_wait 12
	sound_call Data_04_7859
	sound_jump Data_04_7859
Data_04_78DB:: ; 04:78DB
	sound_end
Data_04_78DC:: ; 04:78DC
	sound_volume $7F
	sound_pitch_add $00
	sound_instrument $37
	sound_wait 12
	sound_note 12, $35, $0B
	sound_wait 12
	sound_rs sound_note 12, $3C
	sound_wait 12
	sound_rs sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_rs sound_note 12, $48
	sound_wait 12
Data_04_78EF:: ; 04:78EF
	sound_note 12, $4C, $0B
	sound_wait 12
	sound_rs sound_note 12, $35
	sound_wait 12
	sound_rs sound_note 12, $3C
	sound_wait 12
	sound_rs sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_rs sound_note 12, $48
	sound_wait 12
	sound_ret
Data_04_78FE:: ; 04:78FE
	sound_note 12, $4C, $0B
	sound_wait 12
	sound_rs sound_note 12, $34
	sound_wait 12
	sound_rs sound_note 12, $3B
	sound_wait 12
	sound_rs sound_note 12, $40
	sound_wait 12
	sound_rs sound_note 12, $43
	sound_wait 12
	sound_rs sound_note 12, $47
	sound_wait 12
	sound_ret
Data_04_790D:: ; 04:790D
	sound_note 12, $4A, $0B
	sound_wait 12
	sound_rs sound_note 12, $34
	sound_wait 12
	sound_rs sound_note 12, $3B
	sound_wait 12
	sound_rs sound_note 12, $40
	sound_wait 12
	sound_rs sound_note 12, $43
	sound_wait 12
	sound_rs sound_note 12, $47
	sound_wait 12
	sound_ret
Data_04_791C:: ; 04:791C
	sound_note 12, $4A, $0B
	sound_wait 12
	sound_rs sound_note 12, $32
	sound_wait 12
	sound_rs sound_note 12, $39
	sound_wait 12
	sound_rs sound_note 12, $3E
	sound_wait 12
	sound_rs sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_ret
	sound_rs sound_note 12, $48
	sound_wait 12
	sound_rs sound_note 12, $32
	sound_wait 12
	sound_rs sound_note 12, $39
	sound_wait 12
	sound_rs sound_note 12, $3E
	sound_wait 12
	sound_rs sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
Data_04_7937:: ; 04:7937
	sound_note 12, $48, $0B
	sound_wait 12
	sound_rs sound_note 12, $30
	sound_wait 12
	sound_rs sound_note 12, $37
	sound_wait 12
	sound_rs sound_note 12, $3C
	sound_wait 12
	sound_rs sound_note 12, $43
	sound_wait 12
	sound_rs sound_note 12, $47
	sound_wait 12
	sound_ret
	sound_rs sound_note 12, $4A
	sound_wait 12
	sound_rs sound_note 12, $30
	sound_wait 12
	sound_rs sound_note 12, $37
	sound_wait 12
	sound_rs sound_note 12, $3C
	sound_wait 12
	sound_rs sound_note 12, $40
	sound_wait 12
	sound_rs sound_note 12, $43
	sound_wait 12
	sound_rs sound_note 12, $47
	sound_wait 12
	sound_rs sound_note 12, $35
	sound_wait 12
	sound_rs sound_note 12, $3C
	sound_wait 12
	sound_rs sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_rs sound_note 12, $48
	sound_wait 12
	sound_call Data_04_78EF
	sound_call Data_04_78FE
	sound_call Data_04_790D
	sound_call Data_04_791C
	sound_note 12, $48, $0B
	sound_wait 12
	sound_rs sound_note 12, $2B
	sound_wait 12
	sound_rs sound_note 12, $37
	sound_wait 12
	sound_rs sound_note 12, $3E
	sound_wait 12
	sound_rs sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_call Data_04_7937
	sound_note 12, $4A, $0B
	sound_wait 12
	sound_rs sound_note 12, $4F
	sound_wait 12
	sound_rs sound_note 12, $4C
	sound_wait 12
	sound_rs sound_note 12, $4A
	sound_wait 12
	sound_rs sound_note 12, $47
	sound_wait 12
	sound_rs sound_note 12, $43
	sound_wait 12
	sound_call Data_04_78EF
	sound_jump Data_04_78EF
Data_04_798F:: ; 04:798F
	sound_end
Data_04_7990:: ; 04:7990
	sound_stream_header 3, 2
	dw Data_04_77E9, Data_04_7845, Data_04_78DC ; track stream pointers (read by the driver)
	dw Data_04_77FC, Data_04_7859, Data_04_78EF ; not read by the driver: target of each track's final sound_jump
	dw Data_04_7844, Data_04_78DB, Data_04_798F ; not read by the driver: address after each track's final sound_jump
