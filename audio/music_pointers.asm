; audio/music_pointers.asm
; bank 04, $551D-$574D (560 bytes); pinned by layout.link
; Table_SoundDrv_Songs (70 headers: stream word, bank word, priority, flags, track count)

SECTION "audio/music_pointers", ROMX

; ---- data $551D-$574D (560 bytes) [PROBABLE] song table: 70 records x 8 bytes = word address (58BC 5CBF 5EF4 60E8 ...), word ROM bank (0004 or 0005; 9-bit bank number as read by 00:215E/216F from D026/D027, per docs/research/boot_and_home.md), word $FFC8 (rarely $FFD2/$FFC9), word 0001-0004 (last byte $00 is the unread constant in traces); the 11 identical 58BC/0004 records and the bank-5 entries (4218 4540 46E6 ...) confirm the address+bank reading; 551D+560 = 574D = first sound bytecode

Table_SoundDrv_Songs:: ; 04:551D
Data_04_551D::
	sound_song Data_04_58BC, $C8, $FF, 4 ; id $01
	sound_song Data_04_5CBF, $C8, $FF, 4 ; id $02
	sound_song Data_04_5EF4, $C8, $FF, 4 ; id $03
	sound_song Data_04_60E8, $C8, $FF, 4 ; id $04
	sound_song Data_04_6822, $C8, $FF, 4 ; id $05
	sound_song Data_04_6B3A, $C8, $FF, 4 ; id $06
	sound_song Data_04_7079, $C8, $FF, 4 ; id $07
	sound_song Data_04_7445, $C8, $FF, 4 ; id $08
	sound_song Data_04_77CF, $C8, $FF, 4 ; id $09
	sound_song Data_04_7990, $C8, $FF, 3 ; id $0A
	sound_song Data_04_7BD9, $C8, $FF, 4 ; id $0B
	sound_song Data_04_7DA2, $C8, $FF, 4 ; id $0C
	sound_song Data_04_7E82, $C8, $FF, 4 ; id $0D
	sound_song Data_05_4218, $C8, $FF, 4 ; id $0E
	sound_song Data_05_4540, $C8, $FF, 4 ; id $0F
	sound_song Data_05_46E6, $C8, $FF, 4 ; id $10
	sound_song Data_05_4A15, $C8, $FF, 4 ; id $11
	sound_song Data_05_4C87, $C8, $FF, 4 ; id $12
	sound_song Data_05_4D76, $C8, $FF, 4 ; id $13
	sound_song Data_05_50A2, $C8, $FF, 4 ; id $14
	sound_song Data_05_516A, $C8, $FF, 4 ; id $15
	sound_song Data_05_54C9, $C8, $FF, 4 ; id $16
	sound_song Data_05_5ADC, $C8, $FF, 4 ; id $17
	sound_song Data_05_5B02, $C8, $FF, 1 ; id $18
	sound_song Data_05_5DB5, $C8, $FF, 4 ; id $19
	sound_song Data_05_60CF, $C8, $FF, 4 ; id $1A
	sound_song Data_05_60F5, $C8, $FF, 1 ; id $1B
	sound_song Data_05_62BC, $C8, $FF, 3 ; id $1C
	sound_song Data_05_6312, $C8, $FF, 3 ; id $1D
	sound_song Data_04_58BC, $C8, $FF, 4 ; id $1E
	sound_song Data_04_58BC, $C8, $FF, 4 ; id $1F
	sound_song Data_04_58BC, $C8, $FF, 4 ; id $20
	sound_song Data_04_58BC, $C8, $FF, 4 ; id $21
	sound_song Data_04_58BC, $C8, $FF, 4 ; id $22
	sound_song Data_04_58BC, $C8, $FF, 4 ; id $23
	sound_song Data_04_58BC, $C8, $FF, 4 ; id $24
	sound_song Data_04_58BC, $C8, $FF, 4 ; id $25
	sound_song Data_04_58BC, $C8, $FF, 4 ; id $26
	sound_song Data_04_58BC, $C8, $FF, 4 ; id $27
	sound_song Data_04_58BC, $C8, $FF, 4 ; id $28
	sound_song Data_05_632A, $C8, $FF, 1 ; id $29
	sound_song Data_05_634A, $C8, $FF, 1 ; id $2A
	sound_song Data_05_636A, $C8, $FF, 1 ; id $2B
	sound_song Data_05_638D, $C8, $FF, 1 ; id $2C
	sound_song Data_05_63B0, $C8, $FF, 1 ; id $2D
	sound_song Data_05_63FD, $C8, $FF, 1 ; id $2E
	sound_song Data_05_6410, $C8, $FF, 1 ; id $2F
	sound_song Data_05_643C, $D2, $FF, 2 ; id $30
	sound_song Data_05_645E, $D2, $FF, 2 ; id $31
	sound_song Data_05_64B3, $C8, $FF, 3 ; id $32
	sound_song Data_05_6506, $C8, $FF, 3 ; id $33
	sound_song Data_05_6544, $C8, $FF, 2 ; id $34
	sound_song Data_05_6568, $C9, $FF, 1 ; id $35
	sound_song Data_05_6580, $C8, $FF, 1 ; id $36
	sound_song Data_05_6595, $C8, $FF, 1 ; id $37
	sound_song Data_05_65C3, $C8, $FF, 1 ; id $38
	sound_song Data_05_65FD, $C8, $FF, 1 ; id $39
	sound_song Data_05_6612, $C8, $FF, 1 ; id $3A
	sound_song Data_05_662F, $C8, $FF, 1 ; id $3B
	sound_song Data_05_665B, $C8, $FF, 2 ; id $3C
	sound_song Data_05_66BF, $C8, $FF, 2 ; id $3D
	sound_song Data_05_66F2, $C8, $FF, 2 ; id $3E
	sound_song Data_05_6725, $C8, $FF, 2 ; id $3F
	sound_song Data_05_673C, $C8, $FF, 1 ; id $40
	sound_song Data_05_6751, $C8, $FF, 1 ; id $41
	sound_song Data_05_6789, $C8, $FF, 1 ; id $42
	sound_song Data_05_67B5, $C8, $FF, 2 ; id $43
	sound_song Data_05_6822, $C8, $FF, 2 ; id $44
	sound_song Data_05_689B, $C8, $FF, 2 ; id $45
	sound_song Data_05_68BD, $C8, $FF, 2 ; id $46
