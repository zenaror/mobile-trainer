; audio/music_pointers.asm
; bank 04, $551D-$574D (560 bytes); pinned by layout.link
; Table_SoundDrv_Songs (70 headers: stream word, bank word, priority, flags, track count)

SECTION "audio/music_pointers", ROMX

; ---- data $551D-$574D (560 bytes) [PROBABLE] song table: 70 records x 8 bytes = word address (58BC 5CBF 5EF4 60E8 ...), word ROM bank (0004 or 0005; 9-bit bank number as read by 00:215E/216F from D026/D027, per docs/research/boot_and_home.md), word $FFC8 (rarely $FFD2/$FFC9), word 0001-0004 (last byte $00 is the unread constant in traces); the 11 identical 58BC/0004 records and the bank-5 entries (4218 4540 46E6 ...) confirm the address+bank reading; 551D+560 = 574D = first sound bytecode

Table_SoundDrv_Songs:: ; 04:551D
Data_04_551D::
	sound_song SoundSong01_Header, $C8, $FF, 4 ; id $01
	sound_song SoundSong02_Header, $C8, $FF, 4 ; id $02
	sound_song SoundSong03_Header, $C8, $FF, 4 ; id $03
	sound_song SoundSong04_Header, $C8, $FF, 4 ; id $04
	sound_song SoundSong05_Header, $C8, $FF, 4 ; id $05
	sound_song SoundSong06_Header, $C8, $FF, 4 ; id $06
	sound_song SoundSong07_Header, $C8, $FF, 4 ; id $07
	sound_song SoundSong08_Header, $C8, $FF, 4 ; id $08
	sound_song SoundSong09_Header, $C8, $FF, 4 ; id $09
	sound_song SoundSong0A_Header, $C8, $FF, 3 ; id $0A
	sound_song SoundSong0B_Header, $C8, $FF, 4 ; id $0B
	sound_song SoundSong0C_Header, $C8, $FF, 4 ; id $0C
	sound_song SoundSong0D_Header, $C8, $FF, 4 ; id $0D
	sound_song SoundSong0E_Header, $C8, $FF, 4 ; id $0E
	sound_song SoundSong0F_Header, $C8, $FF, 4 ; id $0F
	sound_song SoundSong10_Header, $C8, $FF, 4 ; id $10
	sound_song SoundSong11_Header, $C8, $FF, 4 ; id $11
	sound_song SoundSong12_Header, $C8, $FF, 4 ; id $12
	sound_song SoundSong13_Header, $C8, $FF, 4 ; id $13
	sound_song SoundSong14_Header, $C8, $FF, 4 ; id $14
	sound_song SoundSong15_Header, $C8, $FF, 4 ; id $15
	sound_song SoundSong16_Header, $C8, $FF, 4 ; id $16
	sound_song SoundSong17_Header, $C8, $FF, 4 ; id $17
	sound_song SoundSong18_Header, $C8, $FF, 1 ; id $18
	sound_song SoundSong19_Header, $C8, $FF, 4 ; id $19
	sound_song SoundSong1A_Header, $C8, $FF, 4 ; id $1A
	sound_song SoundSong1B_Header, $C8, $FF, 1 ; id $1B
	sound_song SoundSong1C_Header, $C8, $FF, 3 ; id $1C
	sound_song SoundSong1D_Header, $C8, $FF, 3 ; id $1D
	sound_song SoundSong01_Header, $C8, $FF, 4 ; id $1E
	sound_song SoundSong01_Header, $C8, $FF, 4 ; id $1F
	sound_song SoundSong01_Header, $C8, $FF, 4 ; id $20
	sound_song SoundSong01_Header, $C8, $FF, 4 ; id $21
	sound_song SoundSong01_Header, $C8, $FF, 4 ; id $22
	sound_song SoundSong01_Header, $C8, $FF, 4 ; id $23
	sound_song SoundSong01_Header, $C8, $FF, 4 ; id $24
	sound_song SoundSong01_Header, $C8, $FF, 4 ; id $25
	sound_song SoundSong01_Header, $C8, $FF, 4 ; id $26
	sound_song SoundSong01_Header, $C8, $FF, 4 ; id $27
	sound_song SoundSong01_Header, $C8, $FF, 4 ; id $28
	sound_song SoundSfx29_Header, $C8, $FF, 1 ; id $29
	sound_song SoundSfx2A_Header, $C8, $FF, 1 ; id $2A
	sound_song SoundSfx2B_Header, $C8, $FF, 1 ; id $2B
	sound_song SoundSfx2C_Header, $C8, $FF, 1 ; id $2C
	sound_song SoundSfx2D_Header, $C8, $FF, 1 ; id $2D
	sound_song SoundSfx2E_Header, $C8, $FF, 1 ; id $2E
	sound_song SoundSfx2F_Header, $C8, $FF, 1 ; id $2F
	sound_song SoundSfx30_Header, $D2, $FF, 2 ; id $30
	sound_song SoundSfx31_Header, $D2, $FF, 2 ; id $31
	sound_song SoundSfx32_Header, $C8, $FF, 3 ; id $32
	sound_song SoundSfx33_Header, $C8, $FF, 3 ; id $33
	sound_song SoundSfx34_Header, $C8, $FF, 2 ; id $34
	sound_song SoundSfx35_Header, $C9, $FF, 1 ; id $35
	sound_song SoundSfx36_Header, $C8, $FF, 1 ; id $36
	sound_song SoundSfx37_Header, $C8, $FF, 1 ; id $37
	sound_song SoundSfx38_Header, $C8, $FF, 1 ; id $38
	sound_song SoundSfx39_Header, $C8, $FF, 1 ; id $39
	sound_song SoundSfx3A_Header, $C8, $FF, 1 ; id $3A
	sound_song SoundSfx3B_Header, $C8, $FF, 1 ; id $3B
	sound_song SoundSfx3C_Header, $C8, $FF, 2 ; id $3C
	sound_song SoundSfx3D_Header, $C8, $FF, 2 ; id $3D
	sound_song SoundSfx3E_Header, $C8, $FF, 2 ; id $3E
	sound_song SoundSfx3F_Header, $C8, $FF, 2 ; id $3F
	sound_song SoundSfx40_Header, $C8, $FF, 1 ; id $40
	sound_song SoundSfx41_Header, $C8, $FF, 1 ; id $41
	sound_song SoundSfx42_Header, $C8, $FF, 1 ; id $42
	sound_song SoundSfx43_Header, $C8, $FF, 2 ; id $43
	sound_song SoundSfx44_Header, $C8, $FF, 2 ; id $44
	sound_song SoundSfx45_Header, $C8, $FF, 2 ; id $45
	sound_song SoundSfx46_Header, $C8, $FF, 2 ; id $46
