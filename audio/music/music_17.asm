; audio/music/music_17.asm
; bank 05, $54E3-$5AF6 (1555 bytes); pinned by layout.link
; song id 17

SECTION "audio/music/music_17", ROMX

; ---- data $54E3-$5617 (308 bytes) [CONFIRMED] read as data by executed code (in up to 12/18 scenarios); content class unknown

SoundSong17_Track0:: ; 05:54E3
Data_05_54E3::
	sound_volume $7F
	sound_pitch_add $00
Data_05_54E7:: ; 05:54E7
	sound_tempo $36
	sound_instrument $01
	sound_vibrato_depth $18
	sound_vibrato_rate $20
	sound_vibrato_delay $16
	sound_note 12, $44, $13
	sound_wait 12
	sound_note 5, $49
	sound_wait 12
	sound_note 6, $48
	sound_wait 6
	sound_note 5, $46
	sound_wait 12
	sound_note 24, $44
	sound_wait 54
Data_05_5501:: ; 05:5501
	sound_wait 36
	sound_note 5, $44, $13
	sound_wait 12
	sound_note 12, $42
	sound_wait 12
	sound_note 5, $41
	sound_wait 12
	sound_note 12, $42
	sound_wait 12
	sound_note 5, $3F
	sound_wait 12
	sound_ret
Data_05_5513:: ; 05:5513
	sound_pitch_bend $28
	sound_note 18, $41, $13
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 17
	sound_note 6, $44
	sound_wait 78
	sound_ret
	sound_call Data_05_5501
Data_05_5523:: ; 05:5523
	sound_pitch_bend $28
	sound_note 18, $41, $13
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 17
	sound_note 5, $3D
	sound_wait 18
	sound_note 12, $38
	sound_wait 12
	sound_note 18, $3A
	sound_wait 18
	sound_note 6, $3D
	sound_wait 18
	sound_note 12, $3F
	sound_wait 12
	sound_ret
Data_05_553C:: ; 05:553C
	sound_wait 12
	sound_note 12, $38, $13
	sound_wait 24
	sound_rs sound_note 12, $42
	sound_wait 24
	sound_note 12
	sound_wait 12
	sound_note 12, $41
	sound_wait 12
	sound_rs sound_note 12, $3F
	sound_wait 12
	sound_ret
	sound_note 24, $3D
	sound_wait 96
Data_05_554E:: ; 05:554E
	sound_wait 78
	sound_instrument $20
	sound_note 6, $44, $13
	sound_wait 18
	sound_ret
	sound_instrument $01
	sound_vibrato_depth $18
	sound_vibrato_rate $20
	sound_vibrato_delay $16
	sound_note 12
	sound_wait 12
	sound_note 5, $49
	sound_wait 12
	sound_note 6, $48
	sound_wait 6
	sound_note 5, $46
	sound_wait 12
	sound_note 24, $44
	sound_wait 54
	sound_call Data_05_5501
	sound_call Data_05_5513
	sound_call Data_05_5501
	sound_call Data_05_5523
	sound_call Data_05_553C
	sound_note 24, $3D, $13
	sound_wait 96
	sound_call Data_05_554E
	sound_instrument $01
	sound_wait 12
	sound_pitch_bend $28
	sound_note 6, $46, $13
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 6, $45
	sound_wait 6
	sound_rs sound_note 6, $46
	sound_wait 6
	sound_note 5, $48
	sound_wait 12
	sound_note 6, $49
	sound_wait 12
	sound_note 6
	sound_wait 12
	sound_note 6, $48
	sound_wait 12
	sound_note 12, $46
	sound_wait 18
	sound_rs sound_note 12, $44
	sound_wait 18
	sound_rs sound_note 12, $46
	sound_wait 18
	sound_note 18, $3D
	sound_wait 30
	sound_note 6, $3F
	sound_wait 12
	sound_rs sound_note 6, $41
	sound_wait 12
	sound_note 12, $42
	sound_wait 6
	sound_wait 36
	sound_note 6
	sound_wait 12
	sound_pitch_bend $28
	sound_note 6
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 5, $41
	sound_wait 12
	sound_note 6, $3F
	sound_wait 12
	sound_note 12, $3D
	sound_wait 18
	sound_rs sound_note 12, $41
	sound_wait 24
	sound_rs sound_note 12, $42
	sound_wait 24
	sound_rs sound_note 12, $43
	sound_wait 18
	sound_note 18, $44
	sound_wait 30
	sound_wait 12
	sound_pitch_bend $28
	sound_note 6, $46
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 6, $45
	sound_wait 6
	sound_rs sound_note 6, $46
	sound_wait 6
	sound_note 5, $48
	sound_wait 12
	sound_note 6, $49
	sound_wait 12
	sound_note 6
	sound_wait 12
	sound_note 6, $48
	sound_wait 12
	sound_note 12, $46
	sound_wait 18
	sound_rs sound_note 12, $44
	sound_wait 18
	sound_rs sound_note 12, $46
	sound_wait 18
	sound_rs sound_note 12, $3D
	sound_wait 24
	sound_rs sound_note 12, $3F
	sound_wait 24
	sound_rs sound_note 12, $41
	sound_wait 12
	sound_wait 24
	sound_rs sound_note 12, $3A
	sound_wait 24
	sound_rs sound_note 12, $46
	sound_wait 18
	sound_rs sound_note 12, $3D
	sound_wait 18
	sound_note 8, $46
	sound_wait 12
	sound_note 72, $44
	sound_wait 96
	sound_wait 18
	sound_instrument $26
	sound_note_vol 3, $09
	sound_wait 12
	sound_note 3, $38
	sound_wait 18
	sound_rs sound_note 3, $44
	sound_wait 12
	sound_rs sound_note 3, $50
	sound_wait 12
	sound_rs sound_note 3, $44
	sound_wait 6
	sound_rs sound_note 3, $5C
	sound_wait 6
	sound_rs sound_note 3, $50
	sound_wait 6
	sound_rs sound_note 3, $38
	sound_wait 6
	sound_jump Data_05_54E7

; ---- data $5617-$5618 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_5617:: ; 05:5617
	sound_end

; ---- data $5618-$585A (578 bytes) [CONFIRMED] read as data by executed code (in up to 12/18 scenarios); content class unknown

SoundSong17_Track1:: ; 05:5618
Data_05_5618::
	sound_volume $7F
	sound_pitch_add $00
Data_05_561C:: ; 05:561C
	sound_instrument $06
	sound_note 6, $41, $0B
	sound_wait 12
	sound_rs sound_note 6, $44
	sound_wait 6
	sound_rs sound_note 6, $3D
	sound_wait 6
	sound_instrument $04
	sound_note 6, $4D, $12
	sound_wait 6
	sound_instrument $06
	sound_note 6, $41, $0B
	sound_wait 12
	sound_rs sound_note 6, $44
	sound_wait 12
	sound_rs sound_note 6, $49
	sound_wait 12
	sound_rs sound_note 6, $3D
	sound_wait 6
	sound_instrument $04
	sound_note 12, $4D, $12
	sound_wait 12
	sound_instrument $06
	sound_note 6, $44, $0B
	sound_wait 12
	sound_ret
Data_05_5645:: ; 05:5645
	sound_note 6, $46, $0B
	sound_wait 12
	sound_rs sound_note 6, $49
	sound_wait 6
	sound_rs sound_note 6, $42
	sound_wait 6
	sound_instrument $04
	sound_note 6, $4E, $12
	sound_wait 6
	sound_instrument $06
	sound_note 6, $46, $0B
	sound_wait 12
	sound_rs sound_note 6, $44
	sound_wait 12
	sound_rs sound_note 6, $3C
	sound_wait 12
	sound_rs sound_note 6, $3F
	sound_wait 6
	sound_instrument $04
	sound_note 12, $50, $12
	sound_wait 12
	sound_instrument $06
	sound_note 6, $44, $0B
	sound_wait 12
	sound_ret
Data_05_566C:: ; 05:566C
	sound_note 6, $41, $0B
	sound_wait 12
	sound_rs sound_note 6, $44
	sound_wait 6
	sound_rs sound_note 6, $3D
	sound_wait 6
	sound_instrument $04
	sound_note 6, $4D, $12
	sound_wait 6
	sound_instrument $06
	sound_note 6, $41, $0B
	sound_wait 12
	sound_rs sound_note 6, $44
	sound_wait 12
	sound_rs sound_note 6, $49
	sound_wait 12
	sound_rs sound_note 6, $41
	sound_wait 6
	sound_instrument $04
	sound_note 12, $4D, $12
	sound_wait 12
	sound_instrument $06
	sound_note 6, $49, $0B
	sound_wait 12
	sound_ret
Data_05_5693:: ; 05:5693
	sound_note 6, $46, $0B
	sound_wait 12
	sound_rs sound_note 6, $3D
	sound_wait 12
	sound_instrument $04
	sound_note 6, $4E, $12
	sound_wait 6
	sound_instrument $06
	sound_note 6, $46, $0B
	sound_wait 12
	sound_rs sound_note 6, $44
	sound_wait 12
	sound_rs sound_note 6, $3C
	sound_wait 12
	sound_rs sound_note 6, $3F
	sound_wait 6
	sound_instrument $04
	sound_note 12, $50, $12
	sound_wait 12
	sound_instrument $06
	sound_note 6, $44, $0B
	sound_wait 12
	sound_ret
Data_05_56B8:: ; 05:56B8
	sound_note 6, $41, $0B
	sound_wait 12
	sound_rs sound_note 6, $46
	sound_wait 12
	sound_instrument $04
	sound_note 6, $4D, $12
	sound_wait 6
	sound_instrument $06
	sound_note 6, $3D, $0B
	sound_wait 12
	sound_rs sound_note 6, $42
	sound_wait 12
	sound_rs sound_note 6, $46
	sound_wait 12
	sound_rs sound_note 6, $3A
	sound_wait 6
	sound_instrument $04
	sound_note 12, $4E, $12
	sound_wait 12
	sound_instrument $06
	sound_note 6, $44, $0B
	sound_wait 12
	sound_ret
Data_05_56DD:: ; 05:56DD
	sound_note 6, $48, $0B
	sound_wait 12
	sound_rs sound_note 6, $3F
	sound_wait 12
	sound_instrument $04
	sound_note 6, $50, $12
	sound_wait 6
	sound_instrument $06
	sound_note 6, $42, $0B
	sound_wait 6
	sound_instrument $04
	sound_note 12, $52, $12
	sound_wait 24
	sound_note 12
	sound_wait 12
	sound_note 12, $50
	sound_wait 12
	sound_rs sound_note 12, $4E
	sound_wait 12
	sound_ret
Data_05_56FD:: ; 05:56FD
	sound_instrument $06
	sound_note 6, $44, $0B
	sound_wait 12
	sound_rs sound_note 6, $49
	sound_wait 12
	sound_instrument $04
	sound_note 6, $4D, $12
	sound_wait 6
	sound_instrument $06
	sound_note 6, $3D, $0B
	sound_wait 12
	sound_rs sound_note 6, $47
	sound_wait 12
	sound_rs sound_note 6, $3B
	sound_wait 12
	sound_rs sound_note 6, $40
	sound_wait 6
	sound_instrument $04
	sound_note 12, $4C, $12
	sound_wait 12
	sound_instrument $06
	sound_note 6, $44, $0B
	sound_wait 12
	sound_ret
	sound_rs sound_note 6, $46
	sound_wait 12
	sound_rs sound_note 6, $49
	sound_wait 6
	sound_rs sound_note 6, $3D
	sound_wait 6
	sound_instrument $04
	sound_note 6, $4E, $12
	sound_wait 6
	sound_instrument $06
	sound_note 6, $46, $0B
	sound_wait 12
	sound_rs sound_note 6, $48
	sound_wait 12
	sound_rs sound_note 6, $3C
	sound_wait 12
	sound_rs sound_note 6, $3F
	sound_wait 6
	sound_instrument $04
	sound_note 12, $50, $12
	sound_wait 12
	sound_instrument $06
	sound_note 6, $42, $0B
	sound_wait 6
	sound_rs sound_note 6, $3F
	sound_wait 6
	sound_call Data_05_561C
	sound_call Data_05_5645
	sound_call Data_05_566C
	sound_call Data_05_5693
	sound_call Data_05_56B8
	sound_call Data_05_56DD
	sound_call Data_05_56FD
	sound_note 6, $46, $0B
	sound_wait 12
	sound_rs sound_note 6, $49
	sound_wait 6
	sound_rs sound_note 6, $3D
	sound_wait 6
	sound_instrument $04
	sound_note 6, $4E, $12
	sound_wait 6
	sound_instrument $06
	sound_note 6, $46, $0B
	sound_wait 12
	sound_rs sound_note 6, $48
	sound_wait 12
	sound_rs sound_note 6, $3C
	sound_wait 12
	sound_rs sound_note 6, $3F
	sound_wait 6
	sound_instrument $04
	sound_note 12, $50, $12
	sound_wait 12
	sound_instrument $06
	sound_note 6, $43, $0B
	sound_wait 6
	sound_rs sound_note 6, $37
	sound_wait 6
Data_05_5787:: ; 05:5787
	sound_note 6, $42, $0B
	sound_wait 12
	sound_rs sound_note 6, $49
	sound_wait 12
	sound_instrument $04
	sound_note 6, $4E, $12
	sound_wait 6
	sound_instrument $06
	sound_note 6, $3D, $0B
	sound_wait 12
	sound_rs sound_note 6, $46
	sound_wait 12
	sound_rs sound_note 6, $3D
	sound_wait 12
	sound_rs sound_note 6, $40
	sound_wait 6
	sound_instrument $04
	sound_note 12, $4E, $12
	sound_wait 12
	sound_instrument $06
	sound_note 6, $49, $0B
	sound_wait 12
	sound_ret
Data_05_57AC:: ; 05:57AC
	sound_note 6, $48, $0B
	sound_wait 12
	sound_rs sound_note 6, $3F
	sound_wait 12
	sound_instrument $04
	sound_note 6, $4D, $12
	sound_wait 6
	sound_instrument $06
	sound_note 6, $48, $0B
	sound_wait 12
	sound_rs sound_note 6, $46
	sound_wait 12
	sound_rs sound_note 6, $49
	sound_wait 12
	sound_rs sound_note 6, $3D
	sound_wait 6
	sound_instrument $04
	sound_note 12, $52, $12
	sound_wait 12
	sound_instrument $06
	sound_note 6, $41, $0B
	sound_wait 12
	sound_ret
	sound_rs sound_note 6, $46
	sound_wait 12
	sound_note 6, $3F, $0C
	sound_wait 12
	sound_instrument $04
	sound_note 6, $4B, $12
	sound_wait 6
	sound_instrument $06
	sound_note 6, $46, $0B
	sound_wait 12
	sound_rs sound_note 6, $44
	sound_wait 12
	sound_rs sound_note 6, $48
	sound_wait 12
	sound_rs sound_note 6, $3C
	sound_wait 6
	sound_instrument $04
	sound_note 12, $50, $12
	sound_wait 12
	sound_instrument $06
	sound_note 6, $42, $0B
	sound_wait 12
	sound_instrument $04
	sound_note 12, $49, $12
	sound_wait 24
	sound_rs sound_note 12, $4B
	sound_wait 24
	sound_rs sound_note 12, $4C
	sound_wait 18
	sound_note 6, $4D
	sound_wait 12
	sound_instrument $06
	sound_note 6, $44, $0B
	sound_wait 6
	sound_rs sound_note 6, $3D
	sound_wait 12
	sound_call Data_05_5787
	sound_call Data_05_57AC
	sound_note 6, $43, $0B
	sound_wait 12
	sound_rs sound_note 6, $46
	sound_wait 12
	sound_instrument $04
	sound_note 6, $49, $12
	sound_wait 6
	sound_instrument $06
	sound_note 6, $3D, $0B
	sound_wait 12
	sound_rs sound_note 6, $4B
	sound_wait 12
	sound_rs sound_note 6, $43
	sound_wait 12
	sound_rs sound_note 6, $46
	sound_wait 6
	sound_instrument $04
	sound_note 12, $4D, $12
	sound_wait 12
	sound_instrument $06
	sound_note 6, $3F, $0B
	sound_wait 12
	sound_rs sound_note 6, $44
	sound_wait 12
	sound_rs sound_note 6, $48
	sound_wait 12
	sound_instrument $04
	sound_note 6, $50, $12
	sound_wait 6
	sound_instrument $06
	sound_note 6, $3F, $0B
	sound_wait 12
	sound_rs sound_note 6, $4B
	sound_wait 12
	sound_rs sound_note 6, $42
	sound_wait 12
	sound_rs sound_note 6, $48
	sound_wait 6
	sound_instrument $04
	sound_note 6, $50, $12
	sound_wait 12
	sound_instrument $06
	sound_note 6, $3F, $0B
	sound_wait 12
	sound_wait 96
	sound_jump Data_05_561C

; ---- data $585A-$585B (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_585A:: ; 05:585A
	sound_end

; ---- data $585B-$5997 (316 bytes) [CONFIRMED] read as data by executed code (in up to 12/18 scenarios); content class unknown

SoundSong17_Track2:: ; 05:585B
Data_05_585B::
	sound_volume $7F
	sound_pitch_add $00
Data_05_585F:: ; 05:585F
	sound_instrument $09
	sound_note 6, $25, $1B
	sound_wait 24
	sound_rs sound_note 6, $44, $12
	sound_wait 18
	sound_rs sound_note 6, $29, $1B
	sound_wait 18
	sound_note 6
	sound_wait 12
	sound_note 12, $44, $12
	sound_wait 12
	sound_rs sound_note 12, $29, $1B
	sound_wait 12
Data_05_5874:: ; 05:5874
	sound_note 6, $2A, $1B
	sound_wait 24
	sound_rs sound_note 6, $46, $12
	sound_wait 18
	sound_rs sound_note 6, $2C, $1B
	sound_wait 18
	sound_note 6
	sound_wait 12
	sound_note 12, $48, $12
	sound_wait 12
	sound_rs sound_note 12, $2C, $1B
	sound_wait 12
	sound_ret
Data_05_5888:: ; 05:5888
	sound_note 6, $25, $1B
	sound_wait 24
	sound_rs sound_note 6, $44, $12
	sound_wait 18
	sound_rs sound_note 6, $29, $1B
	sound_wait 18
	sound_note 6
	sound_wait 12
	sound_note 12, $44, $12
	sound_wait 12
	sound_rs sound_note 12, $29, $1B
	sound_wait 12
	sound_ret
	sound_call Data_05_5874
Data_05_589F:: ; 05:589F
	sound_note 6, $2E, $1B
	sound_wait 24
	sound_rs sound_note 6, $46, $12
	sound_wait 18
	sound_rs sound_note 6, $27, $1B
	sound_wait 18
	sound_note 6
	sound_wait 12
	sound_note 12, $46, $12
	sound_wait 12
	sound_note 6, $2C, $1B
	sound_wait 12
	sound_ret
Data_05_58B4:: ; 05:58B4
	sound_wait 12
	sound_note 6, $2C, $1B
	sound_wait 12
	sound_rs sound_note 6, $48, $12
	sound_wait 12
	sound_rs sound_note 6, $2A, $1B
	sound_wait 24
	sound_note 12
	sound_wait 12
	sound_note 12, $29
	sound_wait 12
	sound_rs sound_note 12, $27
	sound_wait 12
	sound_ret
Data_05_58C7:: ; 05:58C7
	sound_note 6, $25, $1B
	sound_wait 24
	sound_rs sound_note 6, $44, $12
	sound_wait 18
	sound_rs sound_note 6, $28, $1B
	sound_wait 18
	sound_note 6
	sound_wait 12
	sound_note 12, $44, $12
	sound_wait 12
	sound_rs sound_note 12, $28, $1B
	sound_wait 12
	sound_ret
	sound_call Data_05_5874
	sound_call Data_05_5888
	sound_call Data_05_5874
	sound_call Data_05_5888
	sound_call Data_05_5874
	sound_call Data_05_589F
	sound_call Data_05_58B4
	sound_call Data_05_58C7
	sound_note 6, $2A, $1B
	sound_wait 24
	sound_rs sound_note 6, $46, $12
	sound_wait 18
	sound_rs sound_note 6, $2C, $1B
	sound_wait 18
	sound_note 6
	sound_wait 12
	sound_note 12, $48, $12
	sound_wait 12
	sound_rs sound_note 12, $2B, $1B
	sound_wait 12
Data_05_5906:: ; 05:5906
	sound_note 6, $2A, $1B
	sound_wait 24
	sound_rs sound_note 6, $46, $12
	sound_wait 18
	sound_rs sound_note 6, $2A, $1B
	sound_wait 18
	sound_note 6
	sound_wait 12
	sound_note 12, $46, $12
	sound_wait 12
	sound_rs sound_note 12, $2A, $1B
	sound_wait 12
	sound_ret
Data_05_591A:: ; 05:591A
	sound_note 6, $29, $1B
	sound_wait 24
	sound_rs sound_note 6, $44, $12
	sound_wait 18
	sound_rs sound_note 6, $2E, $1B
	sound_wait 18
	sound_note 6
	sound_wait 12
	sound_note 12, $49, $12
	sound_wait 12
	sound_rs sound_note 12, $2E, $1B
	sound_wait 12
	sound_ret
	sound_note 6, $27
	sound_wait 24
	sound_note 6, $42, $12
	sound_wait 18
	sound_rs sound_note 6, $2C, $1B
	sound_wait 18
	sound_note 6
	sound_wait 12
	sound_note 12, $48, $12
	sound_wait 12
	sound_rs sound_note 12, $2C, $1B
	sound_wait 12
	sound_note 6, $25
	sound_wait 24
	sound_note 12, $27
	sound_wait 24
	sound_rs sound_note 12, $28
	sound_wait 18
	sound_note 6, $29
	sound_wait 18
	sound_note 12, $25
	sound_wait 12
	sound_call Data_05_5906
	sound_call Data_05_591A
	sound_note 6, $27, $1B
	sound_wait 24
	sound_rs sound_note 6, $43, $12
	sound_wait 18
	sound_rs sound_note 6, $27, $1B
	sound_wait 18
	sound_note 6
	sound_wait 12
	sound_note 12, $46, $12
	sound_wait 12
	sound_rs sound_note 12, $27, $1B
	sound_wait 12
	sound_note 6, $2C
	sound_wait 24
	sound_note 6, $48, $12
	sound_wait 18
	sound_rs sound_note 6, $2C, $1B
	sound_wait 18
	sound_note 6
	sound_wait 12
	sound_note 12, $48, $12
	sound_wait 12
	sound_rs sound_note 12, $27, $1B
	sound_wait 12
	sound_note 6, $2C
	sound_wait 12
	sound_instrument $46
	sound_note 3, $44, $13
	sound_wait 12
	sound_rs sound_note 3, $38
	sound_wait 18
	sound_rs sound_note 3, $44
	sound_wait 12
	sound_rs sound_note 3, $50
	sound_wait 12
	sound_rs sound_note 3, $44
	sound_wait 6
	sound_rs sound_note 3, $5C
	sound_wait 6
	sound_rs sound_note 3, $50
	sound_wait 6
	sound_rs sound_note 3, $38
	sound_wait 6
	sound_rs sound_note 3, $44
	sound_wait 6
	sound_jump Data_05_585F

; ---- data $5997-$5998 (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_5997:: ; 05:5997
	sound_end

; ---- data $5998-$5ADB (323 bytes) [CONFIRMED] read as data by executed code (in up to 12/18 scenarios); content class unknown

SoundSong17_Track3:: ; 05:5998
Data_05_5998::
	sound_volume $7F
	sound_pitch_add $00
Data_05_599C:: ; 05:599C
	sound_instrument SOUND_INSTRUMENT_PER_NOTE
	sound_note 4, $27, $0F
	sound_wait 6
	sound_note 3, $24, $0A
	sound_wait 6
	sound_note_vol 12, $0C
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0A
	sound_wait 6
	sound_pitch_bend $20
	sound_note 6, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 3, $24, $0A
	sound_wait 6
	sound_note 6, $2A
	sound_wait 6
	sound_note 4, $27, $0F
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 3, $24, $0A
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 6
	sound_wait 6
Data_05_59DB:: ; 05:59DB
	sound_note 4, $27, $0F
	sound_wait 6
	sound_note 3, $24, $0A
	sound_wait 6
	sound_note_vol 12, $0C
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0A
	sound_wait 6
	sound_pitch_bend $20
	sound_note 6, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 3, $24, $0A
	sound_wait 6
	sound_note 6, $2A
	sound_wait 6
	sound_note 4, $27, $0F
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 3, $24, $0A
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 6
	sound_wait 6
	sound_ret
	sound_call Data_05_59DB
	sound_call Data_05_59DB
	sound_call Data_05_59DB
	sound_call Data_05_59DB
	sound_call Data_05_59DB
Data_05_5A28:: ; 05:5A28
	sound_note 4, $27, $0F
	sound_wait 6
	sound_note 3, $24, $0A
	sound_wait 6
	sound_note_vol 12, $0C
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0A
	sound_wait 6
	sound_pitch_bend $20
	sound_note 6, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 4, $24, $0A
	sound_wait 6
	sound_pitch_bend $20
	sound_note 6, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 4, $27, $0F
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 3, $24, $0A
	sound_wait 6
	sound_note 3
	sound_wait 6
	sound_note 6, $2A
	sound_wait 6
	sound_ret
	sound_call Data_05_59DB
	sound_call Data_05_59DB
	sound_call Data_05_59DB
	sound_call Data_05_59DB
	sound_call Data_05_59DB
	sound_call Data_05_59DB
	sound_call Data_05_59DB
	sound_call Data_05_5A28
	sound_call Data_05_59DB
	sound_call Data_05_59DB
	sound_call Data_05_59DB
	sound_call Data_05_5A28
	sound_call Data_05_59DB
	sound_call Data_05_59DB
	sound_call Data_05_59DB
	sound_call Data_05_59DB
	sound_note 4, $27, $0F
	sound_wait 6
	sound_note 3, $24, $0A
	sound_wait 6
	sound_note_vol 12, $0C
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 11
	sound_note 3, $24, $0A
	sound_wait 6
	sound_pitch_bend $20
	sound_note 6, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 4, $24, $0A
	sound_wait 6
	sound_pitch_bend $20
	sound_note 6, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 5
	sound_note 4, $27, $0F
	sound_wait 12
	sound_pitch_bend $20
	sound_note 6, $25, $0D
	sound_wait 1
	sound_pitch_bend $40
	sound_wait 23
	sound_jump Data_05_599C

; ---- data $5ADB-$5ADC (1 bytes) [PROBABLE] unread interior of the song/track byte stream 05:4000-68C3 (track bodies start with bf 7f bd; channel tables are b1 NN KK + words); content of individual commands unknown; see docs/research/classify_g4.md

Data_05_5ADB:: ; 05:5ADB
	sound_end

; ---- data $5ADC-$5ADE (2 bytes) [PROBABLE] header NN=04 KK=02 of the channel-pointer table at 5ADE (12 words = NN*(KK+1)); the byte before (5ADB) is $B1

SoundSong17_Header:: ; 05:5ADC
Data_05_5ADC::
	sound_stream_header 4, 2

; ---- words $5ADE-$5AF6 (24 bytes) [PROBABLE] 12 in-bank pointers (all inside 05:4000-68C3); the block after the table starts with bf 7f bd; header at 5ADC [v4: bytes 5ADE-5AE6 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_05_5ADE:: ; 05:5ADE
	dw SoundSong17_Track0, SoundSong17_Track1, SoundSong17_Track2, SoundSong17_Track3 ; track stream pointers (read by the driver)
	dw Data_05_54E7, Data_05_561C, Data_05_585F, Data_05_599C ; not read by the driver: target of each track's final sound_jump
	dw Data_05_5617, Data_05_585A, Data_05_5997, Data_05_5ADB ; not read by the driver: address after each track's final sound_jump
