; audio/wave_samples.asm
; bank 04, $547D-$551D (160 bytes); pinned by layout.link
; Table_SoundDrv_WavePatterns

SECTION "audio/wave_samples", ROMX

; ---- data $547D-$551D (160 bytes) [PROBABLE] 10 CGB wave-RAM patterns x 16 bytes (32 4-bit samples each: 00 11 23 56 89 AC DE EF FF EE DC A9 86 53 21 10 ; 01 23 45 ... ; FF FF 00.. pulse shapes ; ...); 547D+160 = 551D = start of the song table

Table_SoundDrv_WavePatterns:: ; 04:547D
Data_04_547D::
	db $00, $11, $23, $56, $89, $AC, $DE, $EF, $FF, $EE, $DC, $A9, $86, $53, $21, $10
	db $01, $23, $45, $67, $89, $AB, $CD, $EF, $FE, $DC, $BA, $98, $76, $54, $32, $10
	db $FF, $EE, $DD, $CC, $BB, $AA, $99, $88, $77, $66, $55, $44, $33, $22, $11, $00
	db $FE, $DC, $BA, $99, $88, $88, $88, $88, $77, $77, $77, $77, $66, $54, $32, $10
	db $FF, $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $FF, $FF, $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $FF, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $13, $57, $88, $88, $9A, $CE, $FF, $FF, $ED, $B9, $88, $88, $75, $31, $00
	db $00, $00, $48, $88, $88, $88, $BF, $FF, $FF, $FF, $B8, $88, $88, $88, $40, $00
