; audio/instruments.asm
; bank 04, $51DD-$547D (672 bytes); pinned by layout.link
; Table_SoundDrv_Instruments

SECTION "audio/instruments", ROMX

; ---- data $51DD-$547D (672 bytes) [CONFIRMED] Table_SoundDrv_Instruments: 112 records of 6 bytes (layout and field evidence: docs/research/audio_format.md section 6); records $00-$63 are selected by sound_instrument, $64-$6F by the per-note mode (record = pitch + $40; the data plays pitches $24-$2F there) | superseded note: [PROBABLE] sound instrument/envelope table: 112 records x 6 bytes (first byte 0B/09/0A/00/01/02/11/14/... , 00, 00, NRx2-like byte FB/FD/..., 7F/6F/4F/FF..., last byte $3C constant (the unread byte of each record in traces) except the last 10 records); the 1-byte unread holes of the mapper were this constant; executed reads in up to 18/18 scenarios; 51DD+112*6 = 547D = start of the wave table

Table_SoundDrv_Instruments:: ; 04:51DD
Data_04_51DD::
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $00: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 1, 0, $FB, $6F, $3C ; id $01: attack -, decay 2, sustain 6, release -
	sound_instr_pulse2 2, 0, $FD, $4F, $3C ; id $02: attack -, decay 1, sustain 4, release -
	sound_instr_pulse2 2, 0, $FB, $7C, $3C ; id $03: attack -, decay 2, sustain 7, release 1
	sound_instr_pulse1 0, 0, $00, $FD, $4F, $3C ; id $04: attack -, decay 1, sustain 4, release -
	sound_instr_pulse1 1, 0, $00, $FA, $6F, $3C ; id $05: attack -, decay 2, sustain 6, release -
	sound_instr_pulse1 2, 0, $00, $FC, $6F, $3C ; id $06: attack -, decay 1, sustain 6, release -
	sound_instr_pulse1 0, 0, $00, $FF, $FF, $3C ; id $07: attack -, decay -, sustain F, release -
	sound_instr_wave 1, 0, $FF, $FF, $3C ; id $08: attack -, decay -, sustain F, release -
	sound_instr_wave 4, 0, $FD, $6F, $3C ; id $09: attack -, decay 1, sustain 6, release -
	sound_instr_pulse1 3, 0, $00, $ED, $0F, $3C ; id $0A: attack -, decay 1, sustain 0, release -
	sound_instr_wave 7, 0, $FD, $0F, $3C ; id $0B: attack -, decay 1, sustain 0, release -
	sound_instr_wave 5, 0, $FF, $FF, $3C ; id $0C: attack -, decay -, sustain F, release -
	sound_instr_noise 0, 0, $FD, $4F, $3C ; id $0D: attack -, decay 1, sustain 4, release -
	sound_instr_wave 4, 0, $F6, $CF, $3C ; id $0E: attack -, decay 4, sustain C, release -
	sound_instr_wave 0, 0, $E8, $AF, $3C ; id $0F: attack -, decay 3, sustain A, release -
	sound_instr_noise 0, 0, $FD, $0F, $3C ; id $10: attack -, decay 1, sustain 0, release -
	sound_instr_noise 1, 0, $FD, $0F, $3C ; id $11: attack -, decay 1, sustain 0, release -
	sound_instr_noise 0, 0, $FD, $0E, $3C ; id $12: attack -, decay 1, sustain 0, release -
	sound_instr_noise 0, 0, $EC, $0F, $3C ; id $13: attack -, decay 1, sustain 0, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $14: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $15: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $16: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $17: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $18: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $19: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $1A: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $1B: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $1C: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $1D: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 2, 0, $E4, $0F, $3C ; id $1E: attack -, decay 5, sustain 0, release -
	sound_instr_pulse2 1, 0, $FA, $4F, $3C ; id $1F: attack -, decay 2, sustain 4, release -
	sound_instr_pulse2 0, 0, $FD, $4F, $3C ; id $20: attack -, decay 1, sustain 4, release -
	sound_instr_pulse2 1, 0, $FF, $FF, $3C ; id $21: attack -, decay -, sustain F, release -
	sound_instr_pulse2 3, 0, $EB, $6F, $3C ; id $22: attack -, decay 2, sustain 6, release -
	sound_instr_pulse2 2, 0, $EC, $8F, $3C ; id $23: attack -, decay 1, sustain 8, release -
	sound_instr_pulse2 3, 0, $F1, $0F, $3C ; id $24: attack -, decay 7, sustain 0, release -
	sound_instr_pulse2 1, 0, $F6, $CF, $3C ; id $25: attack -, decay 4, sustain C, release -
	sound_instr_pulse2 2, 0, $FD, $4F, $3C ; id $26: attack -, decay 1, sustain 4, release -
	sound_instr_pulse2 2, 0, $EC, $5F, $3C ; id $27: attack -, decay 1, sustain 5, release -
	sound_instr_pulse2 0, 0, $FF, $FF, $3C ; id $28: attack -, decay -, sustain F, release -
	sound_instr_pulse2 3, 0, $E7, $6F, $3C ; id $29: attack -, decay 4, sustain 6, release -
	sound_instr_pulse2 3, 0, $E7, $AF, $3C ; id $2A: attack -, decay 4, sustain A, release -
	sound_instr_pulse2 2, 0, $EB, $6F, $3C ; id $2B: attack -, decay 2, sustain 6, release -
	sound_instr_pulse2 3, 0, $FF, $FF, $3C ; id $2C: attack -, decay -, sustain F, release -
	sound_instr_pulse2 2, 0, $EB, $7F, $3C ; id $2D: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 2, 0, $FF, $FF, $3C ; id $2E: attack -, decay -, sustain F, release -
	sound_instr_pulse2 1, 0, $FA, $5F, $3C ; id $2F: attack -, decay 2, sustain 5, release -
	sound_instr_pulse2 2, 0, $FD, $6F, $3C ; id $30: attack -, decay 1, sustain 6, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $31: attack -, decay 2, sustain 7, release -
	sound_instr_pulse1 2, 0, $00, $FC, $CF, $3C ; id $32: attack -, decay 1, sustain C, release -
	sound_instr_pulse1 1, 0, $00, $EB, $2F, $3C ; id $33: attack -, decay 2, sustain 2, release -
	sound_instr_pulse1 2, 0, $00, $FD, $4F, $3C ; id $34: attack -, decay 1, sustain 4, release -
	sound_instr_pulse1 2, 0, $00, $FB, $6D, $3C ; id $35: attack -, decay 2, sustain 6, release 1
	sound_instr_pulse1 0, 0, $00, $E8, $9F, $3C ; id $36: attack -, decay 3, sustain 9, release -
	sound_instr_pulse1 2, 0, $00, $EB, $5F, $3C ; id $37: attack -, decay 2, sustain 5, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $38: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $39: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $3A: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $3B: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $3C: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $3D: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $3E: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $3F: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $40: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $41: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $42: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $43: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $44: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $45: attack -, decay 2, sustain 7, release -
	sound_instr_wave 7, 0, $FD, $CF, $3C ; id $46: attack -, decay 1, sustain C, release -
	sound_instr_wave 1, 0, $FD, $0F, $3C ; id $47: attack -, decay 1, sustain 0, release -
	sound_instr_wave 0, 0, $FF, $FF, $3C ; id $48: attack -, decay -, sustain F, release -
	sound_instr_wave 0, 0, $F6, $0F, $3C ; id $49: attack -, decay 4, sustain 0, release -
	sound_instr_wave 3, 0, $E8, $9F, $3C ; id $4A: attack -, decay 3, sustain 9, release -
	sound_instr_wave 0, 0, $A3, $0F, $3C ; id $4B: attack 2, decay 6, sustain 0, release -
	sound_instr_wave 7, 0, $FD, $6F, $3C ; id $4C: attack -, decay 1, sustain 6, release -
	sound_instr_wave 8, 0, $E0, $DF, $3C ; id $4D: attack -, decay 7, sustain D, release -
	sound_instr_wave 8, 0, $E6, $6F, $3C ; id $4E: attack -, decay 4, sustain 6, release -
	sound_instr_wave 5, 0, $FB, $6F, $3C ; id $4F: attack -, decay 2, sustain 6, release -
	sound_instr_wave 8, 0, $FF, $FF, $3C ; id $50: attack -, decay -, sustain F, release -
	sound_instr_wave 7, 0, $FF, $FF, $3C ; id $51: attack -, decay -, sustain F, release -
	sound_instr_wave 9, 0, $E8, $DF, $3C ; id $52: attack -, decay 3, sustain D, release -
	sound_instr_wave 9, 0, $F8, $CF, $3C ; id $53: attack -, decay 3, sustain C, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $54: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $55: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $56: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $57: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $58: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $59: attack -, decay 2, sustain 7, release -
	sound_instr_noise 1, 0, $FF, $FF, $3C ; id $5A: attack -, decay -, sustain F, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $5B: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $5C: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $5D: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $5E: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $5F: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $60: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $61: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $62: attack -, decay 2, sustain 7, release -
	sound_instr_pulse2 3, 0, $FB, $7F, $3C ; id $63: attack -, decay 2, sustain 7, release -
	sound_instr_noise 0, 0, $FD, $1F, $5F ; id $64 = per-note record of pitch $24: attack -, decay 1, sustain 1, release -
	sound_instr_noise 0, 0, $ED, $6F, $43 ; id $65 = per-note record of pitch $25: attack -, decay 1, sustain 6, release -
	sound_instr_noise 1, 0, $FD, $2F, $41 ; id $66 = per-note record of pitch $26: attack -, decay 1, sustain 2, release -
	sound_instr_noise 1, 0, $ED, $2F, $35 ; id $67 = per-note record of pitch $27: attack -, decay 1, sustain 2, release -
	sound_instr_noise 1, 0, $CF, $FA, $3C ; id $68 = per-note record of pitch $28: attack 1, decay -, sustain F, release 2
	sound_instr_noise 1, 0, $FD, $0F, $40 ; id $69 = per-note record of pitch $29: attack -, decay 1, sustain 0, release -
	sound_instr_noise 1, 0, $EC, $6F, $48 ; id $6A = per-note record of pitch $2A: attack -, decay 1, sustain 6, release -
	sound_instr_noise 0, 0, $FC, $4F, $5B ; id $6B = per-note record of pitch $2B: attack -, decay 1, sustain 4, release -
	sound_instr_noise 1, 0, $FC, $AF, $3E ; id $6C = per-note record of pitch $2C: attack -, decay 1, sustain A, release -
	sound_instr_noise 1, 0, $FC, $AF, $43 ; id $6D = per-note record of pitch $2D: attack -, decay 1, sustain A, release -
	sound_instr_noise 1, 0, $FC, $AF, $48 ; id $6E = per-note record of pitch $2E: attack -, decay 1, sustain A, release -
	sound_instr_noise 0, 0, $ED, $6F, $43 ; id $6F = per-note record of pitch $2F: attack -, decay 1, sustain 6, release -
