; gfx/bank60.asm
; bank 60, $4000-$7AE8 (15080 bytes); pinned by layout.link
; UI frames, glyph and sprite tiles; no loader found

SECTION "gfx/bank60", ROMX

; ---- data $4000-$4360 (864 bytes) [CONFIRMED] read as data by executed code (in up to 8/18 scenarios); content class unknown [clipped from 4000-4D80 by higher-priority evidence]

Data_60_4000:: ; 60:4000
	db $FF, $FF, $80, $C0, $83, $B4, $81, $B4, $83, $B4, $81, $84, $B0, $B8, $B8, $BF
	db $FF, $FF, $00, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $00, $00, $FF
	db $FF, $FF, $00, $00, $F9, $04, $E1, $14, $F0, $0B, $C0, $14, $00, $00, $00, $FF
	db $FF, $FF, $00, $00, $CC, $22, $08, $A7, $08, $A2, $00, $B7, $00, $00, $00, $FF
	db $FF, $FF, $00, $00, $20, $9D, $E0, $14, $09, $A4, $12, $49, $00, $00, $00, $FF
	db $F8, $FF, $04, $07, $1E, $C3, $1F, $41, $3F, $80, $1F, $40, $00, $00, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $03, $FF, $81, $FF, $C0, $7F, $20, $3F, $10, $FF
	db $00, $FF, $00, $FF, $01, $FE, $FB, $FD, $F6, $FB, $ED, $F6, $7B, $EC, $37, $E8
	db $FF, $FF, $FF, $FF, $DF, $3F, $EF, $DE, $CE, $2D, $EB, $0D, $ED, $0B, $EE, $0B
	db $FF, $FF, $FF, $FF, $7F, $80, $BE, $7F, $DF, $E0, $7F, $80, $E3, $00, $C9, $1C
	db $FF, $FF, $FF, $FF, $7F, $FF, $BF, $3F, $5F, $9F, $EF, $1F, $EF, $0F, $EF, $0F
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $BF, $BF, $AF, $B0, $B0, $AF, $B6, $A9, $B1, $AE, $B6, $A9, $B0, $AF, $BF, $A0
	db $FF, $FF, $FF, $00, $00, $FF, $7A, $85, $AD, $52, $B3, $4C, $00, $FF, $FF, $00
	db $FF, $FF, $FF, $00, $7F, $FF, $44, $C4, $6C, $EC, $45, $C5, $7F, $FF, $FF, $00
	db $FF, $FF, $FF, $00, $FF, $FF, $C4, $C4, $44, $D7, $24, $A4, $FF, $FF, $FF, $00
	db $FF, $FF, $FF, $00, $FF, $FF, $CD, $CD, $4C, $6C, $64, $65, $FF, $FF, $FF, $00
	db $FF, $FF, $FF, $00, $FF, $FF, $FF, $FF, $FF, $FF, $7F, $7F, $FE, $FF, $F8, $1F
	db $F8, $FF, $F4, $0F, $FE, $F7, $F8, $FF, $E0, $FF, $80, $FF, $01, $FF, $07, $FF
	db $1D, $E1, $03, $F1, $07, $FD, $07, $FD, $1F, $FD, $7F, $FD, $FF, $FD, $FF, $FD
	db $EF, $0A, $EB, $0C, $EC, $0E, $EF, $0F, $EF, $0F, $EF, $0F, $EF, $0F, $EF, $0C
	db $DC, $1D, $BC, $3D, $7A, $7D, $F7, $FA, $EF, $F4, $BF, $C8, $DE, $30, $7D, $E0
	db $EF, $0F, $EF, $0F, $EF, $1F, $DF, $1F, $9F, $3F, $3F, $7F, $7F, $FF, $EF, $1F
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $BF, $A6, $BD, $A2, $BF, $A6, $A0, $B0, $B0, $AF, $B7, $AD, $B7, $A9, $B7, $AC
	db $FF, $DB, $FF, $DB, $FF, $D9, $00, $00, $7F, $87, $7C, $A4, $7E, $A6, $7C, $A5
	db $FF, $36, $FF, $B2, $FF, $36, $00, $00, $FF, $FF, $28, $E8, $28, $AA, $BC, $BD
	db $FF, $E5, $FF, $62, $E7, $82, $08, $10, $C3, $C3, $B9, $FD, $98, $9A, $88, $A8
	db $FF, $F2, $FF, $A5, $F0, $80, $00, $0F, $FF, $FF, $06, $A7, $11, $55, $B2, $BB
	db $E0, $FF, $80, $FF, $80, $FF, $60, $FF, $F8, $FF, $7E, $7F, $1F, $9F, $7F, $7F
	db $1F, $FF, $3F, $FF, $7F, $FF, $1F, $FF, $07, $FF, $01, $FF, $80, $FF, $E0, $FF
	db $FF, $FD, $FF, $FD, $FF, $FD, $FD, $FE, $FE, $FF, $FF, $FF, $7F, $FF, $0F, $FF
	db $E5, $0B, $E6, $0B, $E2, $0B, $48, $9D, $1C, $3E, $FF, $FF, $FD, $FE, $FE, $F9
	db $FF, $87, $FF, $00, $FF, $00, $FF, $00, $00, $00, $FF, $FF, $FB, $07, $E9, $F3
	db $F7, $EF, $F7, $07, $F7, $07, $EF, $0F, $1F, $1F, $DC, $E1, $F8, $DE, $FE, $C0
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $B0, $AF, $B7, $AB, $B7, $AF, $B7, $AF, $B0, $AF, $B7, $AB, $B7, $AF, $B7, $AF
	db $78, $87, $7B, $A7, $78, $A7, $7B, $A7, $78, $87, $7C, $A4, $7E, $A6, $7D, $A5
	db $00, $FF, $45, $FF, $64, $FF, $55, $FF, $00, $FF, $B1, $B1, $AC, $AC, $9A, $9A
	db $00, $FF, $76, $FF, $25, $FF, $35, $FF, $00, $FF, $44, $44, $B5, $B5, $AA, $AA
	db $00, $FF, $30, $FF, $28, $FF, $60, $FF, $00, $FF, $73, $73, $09, $09, $72, $72
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $FF, $FF, $FF, $AB, $AB
	db $18, $FF, $0E, $F7, $0C, $F7, $08, $FF, $10, $FF, $E0, $FF, $C1, $FF, $83, $FF
	db $07, $FF, $0F, $FF, $1F, $FF, $3F, $FF, $7F, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $F6, $FB, $FB, $F4, $F6, $F0, $F0, $F9, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FD, $01, $1D, $01, $05, $E9, $C5, $E9, $8F, $91, $59, $23, $73, $07, $87, $8F
	db $80, $C0, $77, $B8, $F1, $40, $6E, $0E, $1D, $9E, $E2, $F1, $E1, $EE, $EF, $E0
	db $3F, $7F, $9F, $3F, $DF, $1F, $5F, $9F, $5F, $9F, $FF, $1F, $9F, $3F, $3F, $7F
	db $B0, $AF, $B7, $AB, $B7, $AF, $B7, $AF, $B0, $AF, $AF, $B0, $BF, $BF, $BF, $80
	db $7F, $87, $7C, $A4, $7C, $A4, $7E, $A6, $7F, $87, $FF, $00, $FF, $FF, $F0, $0F
	db $FF, $FF, $25, $25, $44, $D5, $45, $55, $FF, $FF, $FF, $00, $FF, $FF, $3F, $C0
	db $FF, $FF, $55, $D5, $15, $15, $7E, $7E, $C3, $C3, $CB, $10, $E7, $E7, $81, $7E
	db $FF, $FF, $8D, $8D, $24, $AC, $6C, $6D, $FF, $FF, $FF, $00, $FF, $FF, $FC, $03
	db $FF, $FF, $8A, $8B, $84, $C7, $58, $5F, $FF, $FF, $FF, $00, $FF, $FF, $0F, $F0

; ---- gfx $4360-$4455 (245 bytes) [PROBABLE] tile data: heuristic: 79 coherent tiles (hsim2=0.719 vsim2=0.686, 3 blank) parity 0 [clipped from 4360-48D0 by higher-priority proposals]

Data_60_4360:: ; 60:4360
	INCBIN "gfx/bank60/tiles_4360.2bpp"
	db $5E, $BF, $7F, $A7, $5E

; ---- gfx $4455-$48D0 (1147 bytes) [PROBABLE] tiles-2bpp: heuristic: 79 coherent tiles (hsim2=0.719 vsim2=0.686, 3 blank) parity 0 [clipped from 4360-48D0 by higher-priority evidence]

Data_60_4455:: ; 60:4455
	INCBIN "gfx/bank60/tiles_4455.2bpp"
	db $FF, $FF, $FF, $FF, $FF, $D5, $FF, $FF, $FF, $55, $FF

; ---- data $48D0-$4B50 (640 bytes) [CONFIRMED] read as data by executed code (in up to 8/18 scenarios); content class unknown [clipped from 4000-4D80 by higher-priority evidence]

Data_60_48D0:: ; 60:48D0
	db $FD, $FD, $F5, $FD, $FD, $FD, $55, $FD, $FD, $FD, $55, $FD, $FD, $FD, $55, $FD
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $F7, $F7, $F7, $F7, $F3, $F7, $F3, $F7, $F1, $F3, $F4, $F5, $F6, $F6, $F5, $F7
	db $9F, $FF, $0E, $FF, $0E, $FF, $9F, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $3E, $FF, $1C, $FF, $1C, $FF, $3E, $FF, $FF, $FF, $FF, $FF, $C0, $E0, $D0, $CF
	db $7C, $FF, $38, $FF, $38, $FF, $7C, $FF, $FF, $FF, $FF, $FF, $00, $00, $00, $FF
	db $F9, $FF, $70, $FF, $70, $FF, $F9, $FF, $FF, $FF, $FF, $FF, $00, $00, $01, $FE
	db $F3, $FF, $E1, $FF, $E1, $FF, $F3, $FF, $FF, $FF, $FF, $FF, $7F, $FF, $7F, $7F
	db $E7, $FF, $C3, $FF, $C3, $FF, $E7, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $CF, $FF, $87, $FF, $87, $FF, $CF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $9F, $FF, $0E, $FF, $0E, $FF, $9F, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $3E, $FF, $1C, $FF, $1C, $FF, $3E, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $7C, $FF, $38, $FF, $38, $FF, $7C, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $F9, $FF, $70, $FF, $70, $FF, $F9, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $F3, $FF, $E1, $FF, $E1, $FF, $F3, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $C7, $D8, $CF, $D0, $CF, $D0, $CF, $D0, $CF, $D0, $CF, $D0, $CE, $D1, $CF, $D1
	db $FF, $00, $FF, $00, $FF, $00, $EF, $1F, $BF, $7F, $6F, $F0, $F6, $CF, $AF, $DF
	db $FE, $01, $FF, $00, $FF, $00, $BF, $C0, $EF, $F0, $B7, $78, $DF, $F8, $AB, $DC
	db $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $0F, $AF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $CD, $D3, $CD, $D3, $CF, $D3, $CF, $D3, $CF, $D3, $CF, $D3, $CD, $D3, $CF, $D1
	db $DB, $BD, $77, $B9, $7F, $B1, $FF, $31, $F5, $3B, $DF, $3F, $6E, $9F, $FF, $80
	db $EF, $9C, $FF, $8C, $FF, $8C, $EB, $9C, $DB, $BC, $F7, $F8, $6F, $F0, $FF, $00
	db $7F, $7F, $60, $7F, $7F, $60, $60, $60, $7F, $7F, $7F, $7F, $7A, $7C, $7A, $7C
	db $FF, $FF, $55, $99, $55, $99, $55, $99, $55, $99, $55, $99, $50, $9F, $57, $98
	db $0F, $AF, $0A, $AC, $AA, $0C, $0A, $0C, $FA, $FC, $FA, $FC, $2A, $CC, $EA, $0C
	db $FF, $FF, $F8, $FF, $FF, $F8, $F8, $F8, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FE, $FF, $2E, $CF, $A8, $4F, $2E, $49, $A8, $C9, $AE, $CF, $AE, $CF, $1C, $CF
	db $BF, $3F, $BF, $3F, $0B, $F3, $FB, $03, $83, $03, $BF, $3F, $07, $E7, $C7, $33
	db $FC, $FF, $FF, $FC, $FC, $FC, $FF, $FF, $FC, $FF, $F9, $FE, $FA, $FC, $F9, $F9
	db $2F, $CF, $EF, $0B, $0F, $0B, $FD, $FB, $2F, $CD, $D7, $25, $17, $25, $D7, $E5
	db $FC, $F8, $F2, $FB, $FB, $F3, $E6, $F5, $F7, $E4, $CB, $EC, $EF, $C8, $9E, $DF

; ---- gfx $4B50-$4D80 (560 bytes) [PROBABLE] tiles-2bpp: heuristic: 33 coherent tiles (hsim2=0.759 vsim2=0.729, 0 blank) parity 0

Data_60_4B50:: ; 60:4B50
	INCBIN "gfx/bank60/tiles_4b50.2bpp"

; ---- data $4D80-$4DD0 (80 bytes) [HYPOTHESIS] run of 82 x $FF (padding?) in unclassified bytes

Data_60_4D80:: ; 60:4D80
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

; ---- gfx $4DD0-$5270 (1184 bytes) [PROBABLE] 74 tiles: 2bpp tile data (pixel coherence hsim=0.674 vsim=0.583); bank 60 is one tile sheet 4000-7A80 (rendered: UI frames, Japanese text glyphs, sprites) followed by the palette at 7A80; span sits between PROBABLE gfx blocks; no loader call found

Tiles_60_4DD0:: ; 60:4DD0
	INCBIN "gfx/bank60/tiles_4dd0.2bpp"

; ---- data $5270-$52C0 (80 bytes) [HYPOTHESIS] run of 80 x $FF (padding?) in unclassified bytes

Data_60_5270:: ; 60:5270
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

; ---- gfx $52C0-$52D0 (16 bytes) [HYPOTHESIS] 1 tiles: 2bpp tile data (pixel coherence hsim=0.357 vsim=0.786); bank 60 is one tile sheet 4000-7A80 (rendered: UI frames, Japanese text glyphs, sprites) followed by the palette at 7A80; span sits between PROBABLE gfx blocks; no loader call found

Tiles_60_52C0:: ; 60:52C0
	INCBIN "gfx/bank60/tiles_52c0.2bpp"

; ---- gfx $52D0-$5640 (880 bytes) [PROBABLE] tiles-2bpp: heuristic: 48 coherent tiles (hsim2=0.661 vsim2=0.678, 0 blank) parity 0

Data_60_52D0:: ; 60:52D0
	INCBIN "gfx/bank60/tiles_52d0.2bpp"

; ---- gfx $5640-$56F0 (176 bytes) [PROBABLE] 11 tiles: 2bpp tile data (pixel coherence hsim=0.769 vsim=0.438); bank 60 is one tile sheet 4000-7A80 (rendered: UI frames, Japanese text glyphs, sprites) followed by the palette at 7A80; span sits between PROBABLE gfx blocks; no loader call found

Tiles_60_5640:: ; 60:5640
	INCBIN "gfx/bank60/tiles_5640.2bpp"

; ---- data $56F0-$5740 (80 bytes) [HYPOTHESIS] run of 80 x $FF (padding?) in unclassified bytes

Data_60_56F0:: ; 60:56F0
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

; ---- gfx $5740-$57B0 (112 bytes) [HYPOTHESIS] 7 tiles: 2bpp tile data (pixel coherence hsim=0.658 vsim=0.607); bank 60 is one tile sheet 4000-7A80 (rendered: UI frames, Japanese text glyphs, sprites) followed by the palette at 7A80; span sits between PROBABLE gfx blocks; no loader call found

Tiles_60_5740:: ; 60:5740
	INCBIN "gfx/bank60/tiles_5740.2bpp"

; ---- data $57B0-$5800 (80 bytes) [HYPOTHESIS] run of 80 x $FF (padding?) in unclassified bytes

Data_60_57B0:: ; 60:57B0
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

; ---- gfx $5800-$5B00 (768 bytes) [PROBABLE] 48 tiles: 2bpp tile data (pixel coherence hsim=0.749 vsim=0.741); bank 60 is one tile sheet 4000-7A80 (rendered: UI frames, Japanese text glyphs, sprites) followed by the palette at 7A80; span sits between PROBABLE gfx blocks; no loader call found

Tiles_60_5800:: ; 60:5800
	INCBIN "gfx/bank60/tiles_5800.2bpp"

; ---- data $5B00-$5D50 (592 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 5B00-5F80 by higher-priority evidence]

Data_60_5B00:: ; 60:5B00
	db $C0, $F1, $80, $E0, $00, $C0, $00, $80, $00, $00, $00, $00, $0E, $00, $11, $0E
	db $30, $FB, $18, $FD, $0C, $7E, $06, $3F, $03, $1F, $01, $0F, $00, $07, $00, $03
	db $C6, $FF, $C6, $FF, $C6, $FF, $46, $7F, $06, $BF, $86, $DF, $C6, $EF, $66, $F7
	db $31, $FF, $31, $FF, $31, $FF, $31, $FF, $31, $FF, $31, $FF, $31, $FF, $31, $FF
	db $8C, $FF, $8C, $FF, $8C, $FF, $8C, $FF, $8C, $FF, $8C, $FF, $8C, $FF, $8C, $FF
	db $63, $FF, $63, $FF, $63, $FF, $63, $FF, $63, $FF, $63, $FF, $63, $FF, $63, $FF
	db $18, $FF, $18, $FF, $18, $FF, $18, $FF, $18, $FF, $18, $FF, $18, $FF, $18, $FF
	db $C6, $FF, $C6, $FF, $C6, $FF, $C6, $FF, $C6, $FF, $C6, $FF, $C6, $FF, $C6, $FF
	db $31, $FF, $31, $FF, $31, $FF, $31, $FF, $31, $FF, $31, $FF, $31, $FF, $31, $FF
	db $8C, $FF, $8C, $FF, $8C, $FF, $8C, $FF, $8C, $FF, $8C, $FF, $8C, $FF, $8C, $FF
	db $63, $FF, $63, $FF, $63, $FF, $63, $FF, $63, $FF, $63, $FF, $63, $FF, $63, $FF
	db $18, $FF, $18, $FF, $18, $FF, $18, $FF, $18, $FF, $18, $FF, $18, $FF, $18, $FF
	db $22, $1E, $45, $3C, $CB, $19, $C5, $05, $BE, $3E, $6F, $7F, $F7, $FF, $BB, $FF
	db $80, $01, $40, $00, $A0, $00, $D0, $80, $E8, $00, $74, $60, $BA, $90, $DD, $D8
	db $32, $FB, $19, $FD, $0C, $7E, $06, $3F, $03, $1F, $01, $0F, $00, $07, $00, $03
	db $31, $FF, $FF, $FF, $FF, $FF, $7F, $7F, $3F, $BF, $9F, $DF, $CF, $EF, $67, $F7
	db $8C, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $63, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $18, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $C6, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $31, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FE, $FF
	db $8C, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $5F, $BF
	db $63, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $18, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $17, $A7
	db $DD, $FF, $EE, $FF, $77, $FF, $BB, $FF, $DD, $FF, $EE, $FF, $F7, $FF, $7B, $7F
	db $EE, $E4, $F7, $F6, $7B, $F9, $BD, $FD, $DE, $FE, $EF, $FF, $77, $FF, $BB, $FF
	db $80, $01, $40, $00, $A0, $00, $D0, $80, $E8, $80, $54, $18, $A4, $B8, $44, $78
	db $33, $FB, $19, $FD, $0C, $7E, $06, $3F, $00, $1F, $00, $0F, $00, $0F, $00, $0F
	db $FF, $FF, $FF, $FF, $FF, $FF, $70, $7F, $FF, $30, $30, $B0, $3F, $BF, $FF, $3F
	db $5F, $9F, $5F, $9F, $5F, $9F, $05, $F9, $7D, $81, $41, $81, $5F, $9F, $5F, $9F
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $1F, $FF, $C3, $3B
	db $FF, $FF, $AF, $CF, $AF, $CF, $AF, $CF, $3F, $CF, $4F, $9F, $5F, $9F, $5F, $9F
	db $FD, $FE, $FC, $FE, $C0, $FE, $DE, $E1, $D1, $E2, $95, $E6, $BD, $C6, $AC, $CF
	db $9F, $5F, $1F, $5F, $1F, $5F, $7F, $9F, $1F, $3F, $7F, $7F, $F1, $3F, $BC, $33
	db $FF, $FF, $FF, $FF, $E2, $FC, $FE, $E0, $E0, $E0, $E2, $FC, $FE, $E0, $20, $A0
	db $17, $A5, $17, $A5, $B7, $05, $07, $05, $FF, $FD, $AF, $C9, $AF, $CB, $AF, $CB
	db $3D, $BF, $9E, $5F, $CF, $2F, $67, $97, $83, $73, $41, $2D, $2C, $12, $16, $09

; ---- gfx $5D50-$6010 (704 bytes) [PROBABLE] tiles-2bpp: heuristic: 40 coherent tiles (hsim2=0.705 vsim2=0.757, 0 blank) parity 0

Data_60_5D50:: ; 60:5D50
	INCBIN "gfx/bank60/tiles_5d50.2bpp"

; ---- gfx $6010-$6060 (80 bytes) [HYPOTHESIS] 5 tiles: 2bpp tile data (pixel coherence hsim=0.411 vsim=0.411); bank 60 is one tile sheet 4000-7A80 (rendered: UI frames, Japanese text glyphs, sprites) followed by the palette at 7A80; span sits between PROBABLE gfx blocks; no loader call found

Tiles_60_6010:: ; 60:6010
	INCBIN "gfx/bank60/tiles_6010.2bpp"

; ---- gfx $6060-$62B0 (592 bytes) [PROBABLE] tiles-2bpp: heuristic: 32 coherent tiles (hsim2=0.696 vsim2=0.706, 0 blank) parity 0

Data_60_6060:: ; 60:6060
	INCBIN "gfx/bank60/tiles_6060.2bpp"

; ---- gfx $62B0-$6470 (448 bytes) [PROBABLE] 28 tiles: 2bpp tile data (pixel coherence hsim=0.723 vsim=0.524); bank 60 is one tile sheet 4000-7A80 (rendered: UI frames, Japanese text glyphs, sprites) followed by the palette at 7A80; span sits between PROBABLE gfx blocks; no loader call found

Tiles_60_62B0:: ; 60:62B0
	INCBIN "gfx/bank60/tiles_62b0.2bpp"

; ---- data $6470-$64C0 (80 bytes) [HYPOTHESIS] run of 80 x $FF (padding?) in unclassified bytes

Data_60_6470:: ; 60:6470
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

; ---- gfx $64C0-$6530 (112 bytes) [HYPOTHESIS] 7 tiles: 2bpp tile data (pixel coherence hsim=0.699 vsim=0.63); bank 60 is one tile sheet 4000-7A80 (rendered: UI frames, Japanese text glyphs, sprites) followed by the palette at 7A80; span sits between PROBABLE gfx blocks; no loader call found

Tiles_60_64C0:: ; 60:64C0
	INCBIN "gfx/bank60/tiles_64c0.2bpp"

; ---- data $6530-$6580 (80 bytes) [HYPOTHESIS] run of 80 x $FF (padding?) in unclassified bytes

Data_60_6530:: ; 60:6530
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

; ---- gfx $6580-$6600 (128 bytes) [PROBABLE] 8 tiles: 2bpp tile data (pixel coherence hsim=0.636 vsim=0.576); bank 60 is one tile sheet 4000-7A80 (rendered: UI frames, Japanese text glyphs, sprites) followed by the palette at 7A80; span sits between PROBABLE gfx blocks; no loader call found

Tiles_60_6580:: ; 60:6580
	INCBIN "gfx/bank60/tiles_6580.2bpp"

; ---- data $6600-$6640 (64 bytes) [HYPOTHESIS] run of 64 x $FF (padding?) in unclassified bytes

Data_60_6600:: ; 60:6600
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

; ---- gfx $6640-$70A0 (2656 bytes) [PROBABLE] 166 tiles: 2bpp tile data (pixel coherence hsim=0.676 vsim=0.565); bank 60 is one tile sheet 4000-7A80 (rendered: UI frames, Japanese text glyphs, sprites) followed by the palette at 7A80; span sits between PROBABLE gfx blocks; no loader call found

Tiles_60_6640:: ; 60:6640
	INCBIN "gfx/bank60/tiles_6640.2bpp"

; ---- gfx $70A0-$76F0 (1616 bytes) [PROBABLE] tiles-2bpp: heuristic: 89 coherent tiles (hsim2=0.708 vsim2=0.660, 8 blank) parity 0

Data_60_70A0:: ; 60:70A0
	INCBIN "gfx/bank60/tiles_70a0.2bpp"

; ---- gfx $76F0-$7A80 (912 bytes) [PROBABLE] 57 tiles: 2bpp tile data (pixel coherence hsim=0.735 vsim=0.425); bank 60 is one tile sheet 4000-7A80 (rendered: UI frames, Japanese text glyphs, sprites) followed by the palette at 7A80; span sits between PROBABLE gfx blocks; no loader call found

Tiles_60_76F0:: ; 60:76F0
	INCBIN "gfx/bank60/tiles_76f0.2bpp"

; ---- data $7A80-$7AE8 (104 bytes) [PROBABLE] palette-rgb555: heuristic: 52 RGB555 words as 13 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Data_60_7A80:: ; 60:7A80
	INCLUDE "gfx/bank60/palette_7a80.pal"
