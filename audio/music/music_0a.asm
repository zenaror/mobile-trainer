; audio/music/music_0a.asm
; bank 04, $77E9-$79A4 (443 bytes); pinned by layout.link
; song id 0A

SECTION "audio/music/music_0a", ROMX

; ---- data $77E9-$79A4 (443 bytes) [PROBABLE] sound bytecode streams of the bank-04 songs (addresses from the song table at 551D land in this range; commands like BF 7F BD 00 BC 3D, B3/B2/B1 + 16-bit stream pointer, DB xx, note bytes 83-8C..); merged from many mapper pieces incl. the false code-pointer tables at 78C8 and 797C (words inside the bytecode, e.g. B3 59 78 B2 59 78) and the 1-6 byte holes that were bytes never read in the traces; commands decoded (docs/research/audio_format.md) (part of region $574D-$7E8C)

SoundSong0A_Track0:: ; 04:77E9
Data_04_77E9::
	sound_volume $7F
	sound_pitch_add $00
	sound_tempo $42
	sound_instrument $4D
	sound_vibrato_depth $18
	sound_vibrato_delay $28
	sound_note 48, $45, $1A
	sound_wait 48
	sound_note 24, $48
	sound_wait 24
SoundSong0A_Track0_Loop:: ; 04:77FC
Data_04_77FC::
	sound_note 48, $4C, $1A
	sound_wait 48
	sound_note 24, $51
	sound_wait 24
	sound_ret
	sound_note 84, $4F
	sound_wait 72
	sound_wait 72
SoundSong0A_Track0_Sub1:: ; 04:7808
Data_04_7808::
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
	sound_call SoundSong0A_Track0_Sub1
	sound_call SoundSong0A_Track0_Loop
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
	sound_call SoundSong0A_Track0_Sub1
	sound_jump SoundSong0A_Track0_Loop
SoundSong0A_Track0_AfterJump:: ; 04:7844
Data_04_7844::
	sound_end
SoundSong0A_Track1:: ; 04:7845
Data_04_7845::
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
SoundSong0A_Track1_Loop:: ; 04:7859
Data_04_7859::
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
SoundSong0A_Track1_Sub1:: ; 04:7868
Data_04_7868::
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
	sound_call SoundSong0A_Track1_Sub1
SoundSong0A_Track1_Sub2:: ; 04:787A
Data_04_787A::
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
	sound_call SoundSong0A_Track1_Sub2
SoundSong0A_Track1_Sub3:: ; 04:788C
Data_04_788C::
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
	sound_call SoundSong0A_Track1_Loop
	sound_call SoundSong0A_Track1_Loop
	sound_call SoundSong0A_Track1_Sub1
	sound_call SoundSong0A_Track1_Sub1
	sound_call SoundSong0A_Track1_Sub2
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
	sound_call SoundSong0A_Track1_Sub3
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
	sound_call SoundSong0A_Track1_Loop
	sound_jump SoundSong0A_Track1_Loop
SoundSong0A_Track1_AfterJump:: ; 04:78DB
Data_04_78DB::
	sound_end
SoundSong0A_Track2:: ; 04:78DC
Data_04_78DC::
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
SoundSong0A_Track2_Loop:: ; 04:78EF
Data_04_78EF::
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
SoundSong0A_Track2_Sub1:: ; 04:78FE
Data_04_78FE::
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
SoundSong0A_Track2_Sub2:: ; 04:790D
Data_04_790D::
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
SoundSong0A_Track2_Sub3:: ; 04:791C
Data_04_791C::
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
SoundSong0A_Track2_Sub4:: ; 04:7937
Data_04_7937::
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
	sound_call SoundSong0A_Track2_Loop
	sound_call SoundSong0A_Track2_Sub1
	sound_call SoundSong0A_Track2_Sub2
	sound_call SoundSong0A_Track2_Sub3
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
	sound_call SoundSong0A_Track2_Sub4
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
	sound_call SoundSong0A_Track2_Loop
	sound_jump SoundSong0A_Track2_Loop
SoundSong0A_Track2_AfterJump:: ; 04:798F
Data_04_798F::
	sound_end
SoundSong0A_Header:: ; 04:7990
Data_04_7990::
	sound_stream_header 3, 2
	dw SoundSong0A_Track0, SoundSong0A_Track1, SoundSong0A_Track2 ; track stream pointers (read by the driver)
	dw SoundSong0A_Track0_Loop, SoundSong0A_Track1_Loop, SoundSong0A_Track2_Loop ; not read by the driver: target of each track's final sound_jump
	; not read by the driver: address after each track's final sound_jump
	dw SoundSong0A_Track0_AfterJump, SoundSong0A_Track1_AfterJump
	dw SoundSong0A_Track2_AfterJump
