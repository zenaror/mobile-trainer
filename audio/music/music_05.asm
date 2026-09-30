; audio/music/music_05.asm
; bank 04, $6102-$683C (1850 bytes); pinned by layout.link
; song id 05

SECTION "audio/music/music_05", ROMX

; ---- data $6102-$683C (1850 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; command semantics not decoded (part of region $574D-$7E8C)

Data_04_6102:: ; 04:6102
	sound_volume $7F
	sound_pitch_add $00
Data_04_6106:: ; 04:6106
	sound_tempo $2D
	sound_instrument $2F
	sound_cmd_C5 $0F
	sound_cmd_C3 $2A
	sound_cmd_C4 $1E
	sound_wait 12
	sound_note 8, $4A, $16
	sound_wait 20
	sound_note 4, $45
	sound_wait 12
	sound_note 16, $48
	sound_wait 16
	sound_note 12, $47
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_rs sound_note 12, $43
	sound_wait 12
Data_04_6122:: ; 04:6122
	sound_note 8, $42, $16
	sound_wait 8
	sound_note 4, $43
	sound_wait 4
	sound_note 8, $45
	sound_wait 8
	sound_note 42, $3E
	sound_wait 60
	sound_note 4
	sound_wait 4
	sound_note 8, $3D
	sound_wait 8
	sound_note 24, $3C
	sound_wait 4
	sound_ret
Data_04_6138:: ; 04:6138
	sound_wait 20
	sound_note 4, $43, $16
	sound_wait 16
	sound_note 24, $48
	sound_wait 24
	sound_note 12, $47
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_rs sound_note 12, $43
	sound_wait 12
	sound_ret
Data_04_6148:: ; 04:6148
	sound_note 18, $45, $16
	sound_wait 36
	sound_rs sound_note 18, $47
	sound_wait 36
	sound_note 16, $49
	sound_wait 24
	sound_ret
	sound_wait 12
	sound_note 8, $4A
	sound_wait 20
	sound_note 4, $45
	sound_wait 12
	sound_note 16, $48
	sound_wait 16
	sound_note 12, $47
	sound_wait 12
	sound_rs sound_note 12, $45
	sound_wait 12
	sound_rs sound_note 12, $43
	sound_wait 12
	sound_call Data_04_6122
	sound_call Data_04_6138
	sound_call Data_04_6148
	sound_note 12, $4A, $16
	sound_wait 12
	sound_instrument $2E
	sound_note_mod 4, $11
	sound_wait 8
	sound_rs sound_note_mod 4, $04
	sound_wait 8
	sound_rs sound_note_mod 4, $02
	sound_wait 4
	sound_note 4, $42, $11
	sound_wait 8
	sound_rs sound_note_mod 4, $04
	sound_wait 4
	sound_note 4, $48, $11
	sound_wait 4
	sound_rs sound_note 4, $42, $02
	sound_wait 4
	sound_rs sound_note 4, $48, $04
	sound_wait 8
	sound_rs sound_note_mod 4, $02
	sound_wait 36
Data_04_618B:: ; 04:618B
	sound_wait 12
	sound_note 4, $47, $11
	sound_wait 8
	sound_rs sound_note_mod 4, $04
	sound_wait 8
	sound_rs sound_note_mod 4, $02
	sound_wait 4
	sound_note 4, $3E, $11
	sound_wait 8
	sound_rs sound_note_mod 4, $04
	sound_wait 4
	sound_note 4, $45, $11
	sound_wait 4
	sound_rs sound_note 4, $3E, $02
	sound_wait 4
	sound_rs sound_note 4, $45, $04
	sound_wait 8
	sound_rs sound_note_mod 4, $02
	sound_wait 36
	sound_ret
Data_04_61A7:: ; 04:61A7
	sound_wait 12
	sound_note 4, $4A, $11
	sound_wait 8
	sound_rs sound_note_mod 4, $04
	sound_wait 8
	sound_rs sound_note_mod 4, $02
	sound_wait 4
	sound_note 4, $42, $11
	sound_wait 8
	sound_rs sound_note_mod 4, $04
	sound_wait 4
	sound_note 4, $48, $11
	sound_wait 4
	sound_rs sound_note 4, $42, $02
	sound_wait 4
	sound_rs sound_note 4, $48, $04
	sound_wait 8
	sound_rs sound_note_mod 4, $02
	sound_wait 36
	sound_ret
Data_04_61C3:: ; 04:61C3
	sound_wait 12
	sound_note 4, $47, $11
	sound_wait 8
	sound_rs sound_note_mod 4, $04
	sound_wait 8
	sound_rs sound_note_mod 4, $02
	sound_wait 4
	sound_note 4, $3E, $11
	sound_wait 8
	sound_rs sound_note_mod 4, $04
	sound_wait 4
	sound_note 4, $45, $11
	sound_wait 4
	sound_rs sound_note 4, $3E, $02
	sound_wait 4
	sound_rs sound_note 4, $45, $04
	sound_wait 8
	sound_rs sound_note 4, $40, $11
	sound_wait 8
	sound_rs sound_note_mod 4, $04
	sound_wait 4
	sound_note 4, $43, $11
	sound_wait 4
	sound_rs sound_note 4, $40, $02
	sound_wait 4
	sound_rs sound_note 4, $43, $04
	sound_wait 4
	sound_rs sound_note 4, $48, $11
	sound_wait 4
	sound_rs sound_note 4, $43, $02
	sound_wait 4
	sound_rs sound_note 4, $48, $04
	sound_wait 4
	sound_ret
	sound_call Data_04_61A7
	sound_call Data_04_618B
	sound_call Data_04_61A7
	sound_call Data_04_61C3
	sound_jump Data_04_6106
Data_04_6204:: ; 04:6204
	sound_end
Data_04_6205:: ; 04:6205
	sound_volume $7F
	sound_pitch_add $00
Data_04_6209:: ; 04:6209
	sound_instrument $05
	sound_wait 12
	sound_note 4, $42, $0C
	sound_wait 12
	sound_instrument $04
	sound_note 8, $56, $15
	sound_wait 8
	sound_instrument $05
	sound_note 4, $42, $0C
	sound_wait 16
	sound_note 18
	sound_wait 20
	sound_note 4
	sound_wait 4
	sound_instrument $04
	sound_note 8, $56, $15
	sound_wait 8
	sound_instrument $05
	sound_note 4, $42, $0C
	sound_wait 16
	sound_ret
Data_04_622D:: ; 04:622D
	sound_wait 12
	sound_note 4, $42, $0C
	sound_wait 12
	sound_instrument $04
	sound_note 8, $56, $15
	sound_wait 8
	sound_instrument $33
	sound_note 4, $58, $0C
	sound_wait 4
	sound_note 8, $5A
	sound_wait 8
	sound_note 24, $51
	sound_wait 24
	sound_instrument $05
	sound_note 4, $42
	sound_wait 4
	sound_instrument $04
	sound_note 8, $56, $15
	sound_wait 8
	sound_instrument $05
	sound_note 4, $42, $0E
	sound_wait 16
	sound_ret
Data_04_6256:: ; 04:6256
	sound_wait 12
	sound_note 4, $40, $0C
	sound_wait 12
	sound_instrument $04
	sound_note 8, $54, $15
	sound_wait 8
	sound_instrument $05
	sound_note 4, $40, $0C
	sound_wait 16
	sound_note 18
	sound_wait 20
	sound_note 4
	sound_wait 4
	sound_instrument $04
	sound_note 8, $54, $15
	sound_wait 8
	sound_instrument $05
	sound_note 4, $40, $0C
	sound_wait 16
	sound_ret
	sound_wait 12
	sound_rs sound_note 4, $41
	sound_wait 12
	sound_instrument $04
	sound_note 8, $54, $15
	sound_wait 8
	sound_instrument $05
	sound_note 4, $41, $0C
	sound_wait 16
	sound_instrument $04
	sound_note 8, $56, $15
	sound_wait 20
	sound_instrument $05
	sound_note 4, $43, $0C
	sound_wait 4
	sound_instrument $04
	sound_note 8, $58, $15
	sound_wait 8
	sound_instrument $05
	sound_note 4, $45, $0C
	sound_wait 4
	sound_instrument $04
	sound_note 4, $55, $0E
	sound_wait 4
	sound_rs sound_note 4, $58
	sound_wait 4
	sound_rs sound_note 4, $5D
	sound_wait 4
	sound_call Data_04_6209
	sound_call Data_04_622D
	sound_call Data_04_6256
	sound_wait 12
	sound_note 4, $41, $0C
	sound_wait 12
	sound_instrument $04
	sound_note 8, $54, $15
	sound_wait 8
	sound_instrument $05
	sound_note 4, $41, $0C
	sound_wait 16
	sound_instrument $04
	sound_note 8, $56, $15
	sound_wait 20
	sound_instrument $05
	sound_note 4, $43, $0C
	sound_wait 4
	sound_instrument $04
	sound_note 8, $58, $15
	sound_wait 8
	sound_instrument $05
	sound_note 4, $45, $0C
	sound_wait 16
Data_04_62DB:: ; 04:62DB
	sound_wait 12
	sound_note 4, $42, $0C
	sound_wait 12
	sound_instrument $04
	sound_note 8, $56, $15
	sound_wait 8
	sound_instrument $05
	sound_note 4, $39, $0C
	sound_wait 16
	sound_rs sound_note 4, $45
	sound_wait 20
	sound_note 4
	sound_wait 4
	sound_instrument $04
	sound_note 8, $54, $15
	sound_wait 8
	sound_instrument $05
	sound_wait 4
	sound_note 4, $45, $0C
	sound_wait 12
	sound_ret
Data_04_62FE:: ; 04:62FE
	sound_instrument $05
	sound_wait 12
	sound_note 4, $47, $0C
	sound_wait 12
	sound_instrument $04
	sound_note 8, $53, $15
	sound_wait 8
	sound_instrument $05
	sound_note 4, $47, $0C
	sound_wait 16
	sound_rs sound_note 4, $49
	sound_wait 20
	sound_note 4
	sound_wait 4
	sound_instrument $04
	sound_note 8, $54, $15
	sound_wait 8
	sound_instrument $05
	sound_wait 4
	sound_note 4, $49, $0C
	sound_wait 12
	sound_ret
Data_04_6323:: ; 04:6323
	sound_instrument $05
	sound_wait 12
	sound_note 4, $42, $0C
	sound_wait 12
	sound_instrument $04
	sound_note 8, $56, $15
	sound_wait 8
	sound_instrument $05
	sound_note 4, $42, $0C
	sound_wait 16
	sound_rs sound_note 4, $45
	sound_wait 20
	sound_note 4
	sound_wait 4
	sound_instrument $04
	sound_note 8, $54, $15
	sound_wait 8
	sound_instrument $05
	sound_wait 4
	sound_note 4, $45, $0C
	sound_wait 12
	sound_ret
	sound_call Data_04_62FE
	sound_call Data_04_62DB
	sound_call Data_04_62FE
	sound_call Data_04_6323
	sound_instrument $05
	sound_wait 12
	sound_note 4, $47, $0C
	sound_wait 12
	sound_instrument $04
	sound_note 8, $53, $15
	sound_wait 8
	sound_instrument $05
	sound_note 4, $47, $0C
	sound_wait 16
	sound_rs sound_note 4, $49
	sound_wait 20
	sound_note 4
	sound_wait 4
	sound_instrument $04
	sound_note 8, $54, $15
	sound_wait 8
	sound_instrument $05
	sound_note 4, $45, $0C
	sound_wait 4
	sound_instrument $04
	sound_note 4, $49, $0E
	sound_wait 4
	sound_rs sound_note 4, $58
	sound_wait 4
	sound_rs sound_note 4, $5D
	sound_wait 4
	sound_jump Data_04_6209
Data_04_6384:: ; 04:6384
	sound_end
Data_04_6385:: ; 04:6385
	sound_volume $7F
	sound_pitch_add $00
Data_04_6389:: ; 04:6389
	sound_instrument $08
	sound_cmd_C2 $0E
	sound_cmd_C1 $40
	sound_note 8, $26, $1F
	sound_wait 12
	sound_note 4, $39, $0C
	sound_wait 12
	sound_instrument $09
	sound_note 8, $4E, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $2D, $1F
	sound_wait 4
	sound_note 8, $30
	sound_wait 8
	sound_note 12, $32
	sound_wait 12
	sound_note 4, $30
	sound_wait 4
	sound_note 12, $32
	sound_wait 12
	sound_instrument $09
	sound_note 8, $4E, $15
	sound_wait 8
	sound_note 4, $39, $0C
	sound_wait 4
	sound_instrument $08
	sound_note 12, $2D, $1F
	sound_wait 12
Data_04_63BF:: ; 04:63BF
	sound_instrument $08
	sound_note 8, $26, $1F
	sound_wait 12
	sound_note 4, $39, $0C
	sound_wait 12
	sound_instrument $09
	sound_note 8, $4E, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $2D, $1F
	sound_wait 4
	sound_note 8, $30
	sound_wait 8
	sound_note 12, $32
	sound_wait 12
	sound_note 4, $30
	sound_wait 4
	sound_note 12, $32
	sound_wait 12
	sound_instrument $09
	sound_note 8, $4E, $15
	sound_wait 8
	sound_note 4, $39, $0C
	sound_wait 4
	sound_instrument $08
	sound_note 12, $2D, $1F
	sound_wait 12
	sound_ret
Data_04_63F2:: ; 04:63F2
	sound_instrument $08
	sound_note 8, $24, $1F
	sound_wait 12
	sound_note 4, $37, $0C
	sound_wait 12
	sound_instrument $09
	sound_note 8, $4C, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $2B, $1F
	sound_wait 4
	sound_note 8, $2E
	sound_wait 8
	sound_note 12, $30
	sound_wait 12
	sound_note 4, $2E
	sound_wait 4
	sound_note 12, $30
	sound_wait 12
	sound_instrument $09
	sound_note 8, $4C, $15
	sound_wait 8
	sound_note 4, $37, $0C
	sound_wait 4
	sound_instrument $08
	sound_note 12, $2B, $1F
	sound_wait 12
	sound_ret
	sound_instrument $08
	sound_note 8, $29
	sound_wait 12
	sound_note 4, $39, $0C
	sound_wait 12
	sound_instrument $09
	sound_note 8, $4D, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $29, $1F
	sound_wait 4
	sound_note 8
	sound_wait 8
	sound_note 4, $2B
	sound_wait 4
	sound_instrument $09
	sound_note 8, $4F, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $26, $1F
	sound_wait 4
	sound_note 12, $2B
	sound_wait 12
	sound_instrument $09
	sound_note 8, $51, $15
	sound_wait 8
	sound_note 4, $3D, $0C
	sound_wait 4
	sound_rs sound_note 4, $4C, $0E
	sound_wait 4
	sound_rs sound_note 4, $51
	sound_wait 4
	sound_rs sound_note 4, $55
	sound_wait 4
	sound_call Data_04_63BF
	sound_call Data_04_63BF
	sound_call Data_04_63F2
	sound_instrument $08
	sound_note 8, $29, $1F
	sound_wait 12
	sound_note 4, $39, $0C
	sound_wait 12
	sound_instrument $09
	sound_note 8, $4D, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $29, $1F
	sound_wait 4
	sound_note 8
	sound_wait 8
	sound_note 4, $2B
	sound_wait 4
	sound_instrument $09
	sound_note 8, $4F, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $26, $1F
	sound_wait 4
	sound_note 12, $2B
	sound_wait 12
	sound_instrument $09
	sound_note 8, $51, $15
	sound_wait 12
	sound_instrument $08
	sound_note 12, $2D, $1F
	sound_wait 12
	sound_note 6, $26
	sound_wait 12
	sound_instrument $51
	sound_note 4, $42, $0F
	sound_wait 8
	sound_instrument $08
	sound_note 4, $26, $1F
	sound_wait 4
	sound_instrument $09
	sound_note 8, $4E, $15
	sound_wait 8
	sound_instrument $51
	sound_note 4, $39, $0F
	sound_wait 4
	sound_instrument $08
	sound_note 6, $26, $1F
	sound_wait 8
	sound_instrument $51
	sound_note 4, $42, $0F
	sound_wait 4
	sound_instrument $4F
	sound_note 4, $3C, $0C
	sound_wait 12
	sound_instrument $08
	sound_note 6, $29, $1F
	sound_wait 8
	sound_instrument $4F
	sound_note 4, $3C, $0C
	sound_wait 4
	sound_instrument $09
	sound_note 8, $4B, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $29, $1F
	sound_wait 4
	sound_instrument $4F
	sound_note 4, $3C, $0C
	sound_wait 12
Data_04_64E9:: ; 04:64E9
	sound_instrument $08
	sound_note 6, $2B, $1F
	sound_wait 12
	sound_instrument $51
	sound_note 4, $3E, $0F
	sound_wait 8
	sound_instrument $08
	sound_note 4, $2B, $1F
	sound_wait 4
	sound_instrument $09
	sound_note 8, $4D, $15
	sound_wait 8
	sound_instrument $51
	sound_note 4, $37, $0F
	sound_wait 4
	sound_instrument $08
	sound_note 6, $2B, $1F
	sound_wait 8
	sound_instrument $51
	sound_note 4, $3D, $0F
	sound_wait 4
	sound_instrument $4F
	sound_note 8, $40, $0C
	sound_wait 8
	sound_instrument $08
	sound_note 6, $2D, $1F
	sound_wait 12
	sound_instrument $4F
	sound_note 4, $40, $0C
	sound_wait 4
	sound_instrument $09
	sound_note 8, $4C, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $2D, $1F
	sound_wait 4
	sound_instrument $4F
	sound_note 4, $40, $0C
	sound_wait 12
	sound_ret
Data_04_6538:: ; 04:6538
	sound_instrument $08
	sound_note 6, $26, $1F
	sound_wait 12
	sound_instrument $51
	sound_note 4, $42, $0F
	sound_wait 8
	sound_instrument $08
	sound_note 4, $26, $1F
	sound_wait 4
	sound_instrument $09
	sound_note 8, $4E, $15
	sound_wait 8
	sound_instrument $51
	sound_note 4, $39, $0F
	sound_wait 4
	sound_instrument $08
	sound_note 6, $26, $1F
	sound_wait 8
	sound_instrument $51
	sound_note 4, $42, $0F
	sound_wait 4
	sound_instrument $4F
	sound_note 4, $3C, $0C
	sound_wait 12
	sound_instrument $08
	sound_note 6, $29, $1F
	sound_wait 8
	sound_instrument $4F
	sound_note 4, $3C, $0C
	sound_wait 4
	sound_instrument $09
	sound_note 8, $4B, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $29, $1F
	sound_wait 4
	sound_instrument $4F
	sound_note 4, $3C, $0C
	sound_wait 12
	sound_ret
	sound_instrument $08
	sound_note 6, $2B, $1F
	sound_wait 12
	sound_instrument $51
	sound_note 4, $3E, $0F
	sound_wait 8
	sound_instrument $08
	sound_note 4, $2B, $1F
	sound_wait 4
	sound_instrument $09
	sound_note 8, $4D, $15
	sound_wait 8
	sound_instrument $51
	sound_note 4, $37, $0F
	sound_wait 4
	sound_instrument $08
	sound_note 6, $2B, $1F
	sound_wait 8
	sound_instrument $51
	sound_note 4, $3D, $0F
	sound_wait 4
	sound_instrument $4F
	sound_note 8, $40, $0C
	sound_wait 8
	sound_instrument $08
	sound_note 6, $2D, $1F
	sound_wait 4
	sound_instrument $51
	sound_note 4, $39, $0F
	sound_wait 8
	sound_instrument $4F
	sound_note 4, $40, $0C
	sound_wait 4
	sound_instrument $09
	sound_note 8, $4C, $15
	sound_wait 8
	sound_instrument $08
	sound_note 4, $2D, $1F
	sound_wait 4
	sound_instrument $51
	sound_note 4, $40, $0F
	sound_wait 12
	sound_call Data_04_6538
	sound_call Data_04_64E9
	sound_call Data_04_6538
	sound_instrument $08
	sound_note 6, $2B, $1F
	sound_wait 12
	sound_instrument $51
	sound_note 4, $3E, $0F
	sound_wait 8
	sound_instrument $08
	sound_note 4, $2B, $1F
	sound_wait 4
	sound_instrument $09
	sound_note 8, $4D, $15
	sound_wait 8
	sound_instrument $51
	sound_note 4, $37, $0F
	sound_wait 4
	sound_instrument $08
	sound_note 6, $2B, $1F
	sound_wait 8
	sound_instrument $51
	sound_note 4, $3D, $0F
	sound_wait 4
	sound_instrument $4F
	sound_note 8, $40, $0C
	sound_wait 8
	sound_instrument $08
	sound_note 6, $2D, $1F
	sound_wait 4
	sound_instrument $51
	sound_note 4, $39, $0F
	sound_wait 8
	sound_instrument $4F
	sound_note 4, $40, $0C
	sound_wait 4
	sound_instrument $09
	sound_note 8, $4C, $15
	sound_wait 8
	sound_note 4, $3D, $0C
	sound_wait 4
	sound_rs sound_note 4, $4C, $0E
	sound_wait 4
	sound_rs sound_note 4, $51
	sound_wait 4
	sound_rs sound_note 4, $54
	sound_wait 4
	sound_jump Data_04_6389
Data_04_663A:: ; 04:663A
	sound_end
Data_04_663B:: ; 04:663B
	sound_volume $7F
	sound_pitch_add $00
Data_04_663F:: ; 04:663F
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 4, $27, $11
	sound_wait 12
	sound_note 12, $2A, $0B
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 8
	sound_cmd_C1 $20
	sound_note 6, $25
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 3
	sound_note 3, $24
	sound_wait 8
	sound_note 3
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 8
	sound_cmd_C1 $20
	sound_note 4, $25, $0C
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 3
Data_04_667D:: ; 04:667D
	sound_note 4, $27, $11
	sound_wait 12
	sound_note 12, $2A, $0B
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 8
	sound_cmd_C1 $20
	sound_note 6, $25, $0C
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 3
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 4
	sound_ret
Data_04_66B5:: ; 04:66B5
	sound_note 4, $27, $11
	sound_wait 12
	sound_note 12, $2A, $0B
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 8
	sound_cmd_C1 $20
	sound_note 6, $25, $0C
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 3
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 8
	sound_cmd_C1 $20
	sound_note 4, $25, $0C
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 3
	sound_ret
Data_04_66F4:: ; 04:66F4
	sound_note 4, $27, $11
	sound_wait 12
	sound_note 12, $2A, $0B
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 8
	sound_cmd_C1 $20
	sound_note 4, $25, $0C
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 3
	sound_rs sound_cmd_C1 $20
	sound_note_mod 6, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 8
	sound_cmd_C1 $20
	sound_note 4, $25, $0C
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 3
	sound_rs sound_cmd_C1 $20
	sound_note_mod 6, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 4, $2E, $0D
	sound_wait 4
	sound_rs sound_note 4, $2D
	sound_wait 4
	sound_rs sound_note 4, $2C
	sound_wait 4
	sound_ret
	sound_call Data_04_66B5
	sound_call Data_04_667D
	sound_call Data_04_66B5
	sound_note 4, $27, $11
	sound_wait 12
	sound_note 12, $2A, $0B
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 8
	sound_cmd_C1 $20
	sound_note 4, $25, $0C
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 3
	sound_rs sound_cmd_C1 $20
	sound_note_mod 6, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 8
	sound_cmd_C1 $20
	sound_note 4, $25, $0C
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 3
	sound_rs sound_cmd_C1 $20
	sound_note_mod 6, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 4, $27, $11
	sound_wait 8
	sound_cmd_C1 $20
	sound_note 4, $25, $0C
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 3
	sound_call Data_04_66B5
	sound_call Data_04_667D
	sound_call Data_04_66B5
	sound_note 4, $27, $11
	sound_wait 12
	sound_note 12, $2A, $0B
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 8
	sound_cmd_C1 $20
	sound_note 4, $25, $0C
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 3
	sound_rs sound_cmd_C1 $20
	sound_note_mod 6, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 7
	sound_note 3, $24, $0B
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 8
	sound_cmd_C1 $20
	sound_note 4, $25, $0C
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 3
	sound_rs sound_cmd_C1 $20
	sound_note_mod 6, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 8
	sound_cmd_C1 $20
	sound_note 4, $25, $0C
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 3
	sound_note 4, $27, $11
	sound_wait 12
	sound_note 12, $2A, $0B
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 8
	sound_cmd_C1 $20
	sound_note 6, $25, $0C
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 3
	sound_note 3, $24, $0B
	sound_wait 8
	sound_note 3
	sound_wait 4
	sound_note 4, $27, $11
	sound_wait 12
	sound_cmd_C1 $20
	sound_note 6, $25, $10
	sound_wait 1
	sound_cmd_C1 $40
	sound_wait 11
	sound_note 3, $24, $0B
	sound_wait 12
	sound_call Data_04_667D
	sound_call Data_04_66B5
	sound_call Data_04_66F4
	sound_jump Data_04_663F
Data_04_6821:: ; 04:6821
	sound_end
Data_04_6822:: ; 04:6822
	sound_stream_header 4, 2
	dw Data_04_6102, Data_04_6205, Data_04_6385, Data_04_663B ; track stream pointers (read by the driver)
	dw Data_04_6106, Data_04_6209, Data_04_6389, Data_04_663F ; not read by the driver: target of each track's final sound_jump
	dw Data_04_6204, Data_04_6384, Data_04_663A, Data_04_6821 ; not read by the driver: address after each track's final sound_jump
