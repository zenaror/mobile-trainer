; audio/wave_samples.asm
; bank 04, $547D-$551D (160 bytes); pinned by layout.link
; Table_SoundDrv_WavePatterns

SECTION "audio/wave_samples", ROMX

; ---- data $547D-$551D (160 bytes) [CONFIRMED] Table_SoundDrv_WavePatterns: 10 patterns of 16 bytes = 32 4-bit samples (high nibble first in wave RAM), copied unchanged to $FF30-$FF3F by SoundDrv_WriteChannelParams 04:4EB3-4EC8 for a wave-channel instrument (byte 0 - $10 = pattern) | superseded note: [PROBABLE] 10 CGB wave-RAM patterns x 16 bytes (32 4-bit samples each: 00 11 23 56 89 AC DE EF FF EE DC A9 86 53 21 10 ; 01 23 45 ... ; FF FF 00.. pulse shapes ; ...); 547D+160 = 551D = start of the song table

Table_SoundDrv_WavePatterns:: ; 04:547D
Data_04_547D::
	sound_wave_pattern \
		$0, $0, $1, $1, $2, $3, $5, $6, $8, $9, $A, $C, $D, $E, $E, $F, \
		$F, $F, $E, $E, $D, $C, $A, $9, $8, $6, $5, $3, $2, $1, $1, $0 ; wave 0 (instrument byte 0 = $10)
	sound_wave_pattern \
		$0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $A, $B, $C, $D, $E, $F, \
		$F, $E, $D, $C, $B, $A, $9, $8, $7, $6, $5, $4, $3, $2, $1, $0 ; wave 1 (instrument byte 0 = $11)
	sound_wave_pattern \
		$F, $F, $E, $E, $D, $D, $C, $C, $B, $B, $A, $A, $9, $9, $8, $8, \
		$7, $7, $6, $6, $5, $5, $4, $4, $3, $3, $2, $2, $1, $1, $0, $0 ; wave 2 (instrument byte 0 = $12)
	sound_wave_pattern \
		$F, $E, $D, $C, $B, $A, $9, $9, $8, $8, $8, $8, $8, $8, $8, $8, \
		$7, $7, $7, $7, $7, $7, $7, $7, $6, $6, $5, $4, $3, $2, $1, $0 ; wave 3 (instrument byte 0 = $13)
	sound_wave_pattern \
		$F, $F, $F, $F, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, \
		$0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0 ; wave 4 (instrument byte 0 = $14)
	sound_wave_pattern \
		$F, $F, $F, $F, $F, $F, $F, $F, $0, $0, $0, $0, $0, $0, $0, $0, \
		$0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0 ; wave 5 (instrument byte 0 = $15)
	sound_wave_pattern \
		$F, $F, $F, $F, $F, $F, $F, $F, $F, $F, $F, $F, $0, $0, $0, $0, \
		$0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0 ; wave 6 (instrument byte 0 = $16)
	sound_wave_pattern \
		$F, $F, $F, $F, $F, $F, $F, $F, $F, $F, $F, $F, $F, $F, $F, $F, \
		$0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0 ; wave 7 (instrument byte 0 = $17)
	sound_wave_pattern \
		$0, $0, $1, $3, $5, $7, $8, $8, $8, $8, $9, $A, $C, $E, $F, $F, \
		$F, $F, $E, $D, $B, $9, $8, $8, $8, $8, $7, $5, $3, $1, $0, $0 ; wave 8 (instrument byte 0 = $18)
	sound_wave_pattern \
		$0, $0, $0, $0, $4, $8, $8, $8, $8, $8, $8, $8, $B, $F, $F, $F, \
		$F, $F, $F, $F, $B, $8, $8, $8, $8, $8, $8, $8, $4, $0, $0, $0 ; wave 9 (instrument byte 0 = $19)
