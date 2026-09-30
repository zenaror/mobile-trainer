; home/header.asm
; bank 00, $0000-$0150 (336 bytes); pinned by layout.link
; rst slots, interrupt vectors (jp to RAM stubs), entry jump, cartridge header; pinned at org $0000

SECTION "home/header", ROM0

; ---- code $0000-$0001 (1 bytes) [CONFIRMED] rst $00 slot: ret (never used as a call target in reached code)

Rst_00:: ; 00:0000
	ret

; ---- zero $0001-$0008 (7 bytes) [CONFIRMED] padding
	ds $7, $00

; ---- code $0008-$0009 (1 bytes) [CONFIRMED] rst $08 slot: ret (never used as a call target in reached code)

Rst_08:: ; 00:0008
	ret

; ---- zero $0009-$0010 (7 bytes) [CONFIRMED] padding
	ds $7, $00

; ---- code $0010-$0011 (1 bytes) [CONFIRMED] rst $10 slot: ret (never used as a call target in reached code)

Rst_10:: ; 00:0010
	ret

; ---- zero $0011-$0018 (7 bytes) [CONFIRMED] padding
	ds $7, $00

; ---- code $0018-$0019 (1 bytes) [CONFIRMED] rst $18 slot: ret (never used as a call target in reached code)

Rst_18:: ; 00:0018
	ret

; ---- zero $0019-$0020 (7 bytes) [CONFIRMED] padding
	ds $7, $00

; ---- code $0020-$0021 (1 bytes) [CONFIRMED] rst $20 slot: ret (never used as a call target in reached code)

Rst_20:: ; 00:0020
	ret

; ---- zero $0021-$0028 (7 bytes) [CONFIRMED] padding
	ds $7, $00

; ---- code $0028-$0029 (1 bytes) [CONFIRMED] rst $28 slot: ret (never used as a call target in reached code)

Rst_28:: ; 00:0028
	ret

; ---- zero $0029-$0030 (7 bytes) [CONFIRMED] padding
	ds $7, $00

; ---- code $0030-$0031 (1 bytes) [CONFIRMED] rst $30 slot: ret (never used as a call target in reached code)

Rst_30:: ; 00:0030
	ret

; ---- zero $0031-$0038 (7 bytes) [CONFIRMED] padding
	ds $7, $00

; ---- code $0038-$0039 (1 bytes) [CONFIRMED] rst $38 slot: ret (never used as a call target in reached code)

Rst_38:: ; 00:0038
	ret

; ---- zero $0039-$0040 (7 bytes) [CONFIRMED] padding
	ds $7, $00

; ---- code $0040-$0044 (4 bytes) [CONFIRMED] hardware vector: jp $CBF1 (RAM stub, see 00:04A0); reti

Vector_VBlank:: ; 00:0040
	jp $CBF1

	reti

; ---- zero $0044-$0048 (4 bytes) [CONFIRMED] padding
	ds $4, $00

; ---- code $0048-$004C (4 bytes) [CONFIRMED] hardware vector: jp $CBF4 (RAM stub, see 00:04A0); reti

Vector_STAT:: ; 00:0048
	jp $CBF4

	reti

; ---- zero $004C-$0050 (4 bytes) [CONFIRMED] padding
	ds $4, $00

; ---- code $0050-$0054 (4 bytes) [CONFIRMED] hardware vector: jp $CBF7 (RAM stub, see 00:04A0); reti

Vector_Timer:: ; 00:0050
	jp $CBF7

	reti

; ---- zero $0054-$0058 (4 bytes) [CONFIRMED] padding
	ds $4, $00

; ---- code $0058-$005C (4 bytes) [CONFIRMED] hardware vector: jp $CBFA (RAM stub, see 00:04A0); reti

Vector_Serial:: ; 00:0058
	jp $CBFA

	reti

; ---- zero $005C-$0060 (4 bytes) [CONFIRMED] padding
	ds $4, $00

; ---- code $0060-$0064 (4 bytes) [CONFIRMED] hardware vector: jp $CBFD (RAM stub, see 00:04A0); reti

Vector_Joypad:: ; 00:0060
	jp $CBFD

	reti

; ---- zero $0064-$0100 (156 bytes) [CONFIRMED] padding
	ds $9C, $00

; ---- code $0100-$0104 (4 bytes) [CONFIRMED] reset entry: nop ; jp $0278

Entry:: ; 00:0100
	nop
	jp Boot

; ---- data $0104-$0150 (76 bytes) [CONFIRMED] cartridge header 0104-014F (logo, title M-TRAINER, CGB-only, MBC5+RAM+BATTERY, checksums); see docs/ROM_INFO.md

Header:: ; 00:0104
	db $CE, $ED, $66, $66, $CC, $0D, $00, $0B, $03, $73, $00, $83, $00, $0C, $00, $0D
	db $00, $08, $11, $1F, $88, $89, $00, $0E, $DC, $CC, $6E, $E6, $DD, $DD, $D9, $99
	db $BB, $BB, $67, $63, $6E, $0E, $EC, $CC, $DD, $DC, $99, $9F, $BB, $B9, $33, $3E
	db $4D, $2D, $54, $52, $41, $49, $4E, $45, $52, $00, $00, $42, $39, $41, $4A, $C0
	db $30, $31, $00, $1B, $06, $03, $00, $33, $00, $DA, $5A, $C8
