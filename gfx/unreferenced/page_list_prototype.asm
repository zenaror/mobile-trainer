; gfx/unreferenced/page_list_prototype.asm
; bank 7F, $62B0-$70FD (3661 bytes); pinned by layout.link
; tiles, tilemap, palettes, object tables of the prototype

SECTION "gfx/unreferenced/page_list_prototype", ROMX

; ---- gfx $62B0-$66B0 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 7F:5233: hl=$62B0 a=$7F c=$40 de=$9001 (dest VRAM $9000, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_7F_62B0:: ; 7F:62B0
	INCBIN "gfx/unreferenced/page_list_prototype/tiles_62b0.2bpp"

; ---- gfx $66B0-$67D0 (288 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 7F:5245: hl=$66B0 a=$7F c=$12 de=$9401 (dest VRAM $9400, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_7F_66B0:: ; 7F:66B0
	INCBIN "gfx/unreferenced/page_list_prototype/tiles_66b0.2bpp"

; ---- data $67D0-$6AA0 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 7F:5281: hl=$67D0 a=$7F b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Data_7F_67D0:: ; 7F:67D0
	INCBIN "gfx/unreferenced/page_list_prototype/tilemap_67d0.tilemap"
	INCBIN "gfx/unreferenced/page_list_prototype/tilemap_67d0.attrmap"

; ---- data $6AA0-$6AE0 (64 bytes) [PROBABLE] 8 RGB555 palettes of 4 colours (64 bytes, bit15 clear): follows the tilemap+attr block 67D0-6AA0 (0x2D0) exactly and is loaded with ld hl,$6AA0 at 7F:52A4 (same tiles/tilemap/palette layout as banks 41-47)

Palette_7F_6AA0:: ; 7F:6AA0
	INCLUDE "gfx/unreferenced/page_list_prototype/palette_6aa0.pal"

; ---- gfx $6AE0-$6D70 (656 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 7F:5257: hl=$6AE0 a=$7F c=$29 de=$8000 (dest VRAM $8000, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

Data_7F_6AE0:: ; 7F:6AE0
	INCBIN "gfx/unreferenced/page_list_prototype/tiles_6ae0.2bpp"

; ---- data $6D70-$6DB0 (64 bytes) [PROBABLE] 8 RGB555 palettes of 4 colours (64 bytes, all words < $8000), loaded with ld hl,$6D70 at 7F:5293; follows the tile block 6AE0-6D70 (41 tiles, HDMA c=$29)

Palette_7F_6D70:: ; 7F:6D70
	INCLUDE "gfx/unreferenced/page_list_prototype/palette_6d70.pal"

; ---- words $6DB0-$6E50 (160 bytes) [PROBABLE] 10 object tables of 4 entries x 2 words (6DB0 ... 6E40, 16 bytes each, every entry repeated) read by init_object_from_table (00:0A82, de=$6DB0..$6E40 a=$7F, call sites 7F:5267 549B 54E5 5BE0 ...); all 80 words point into the animation block 6E50-70FD

Table_7F_6DB0:: ; 7F:6DB0
	dw Data_7F_6E50, $6E76, Data_7F_6E50, $6E76, Data_7F_6E50, $6E76, Data_7F_6E50, $6E76
	dw $6E7B, $6EC7, $6E7B, $6EC7, $6E7B, $6EC7, $6E7B, $6EC7
	dw $6ED0, $6EF6, $6ED0, $6EF6, $6ED0, $6EF6, $6ED0, $6EF6
	dw $6EFB, $6F0E, $6EFB, $6F0E, $6EFB, $6F0E, $6EFB, $6F0E
	dw $6F11, $6F24, $6F11, $6F24, $6F11, $6F24, $6F11, $6F24
	dw $6F27, $6F5D, $6F27, $6F5D, $6F27, $6F5D, $6F27, $6F5D
	dw $6F62, $6F98, $6F62, $6F98, $6F62, $6F98, $6F62, $6F98
	dw $6F9D, $6FC3, $6F9D, $6FC3, $6F9D, $6FC3, $6F9D, $6FC3
	dw $6FC8, $704D, $6FC8, $704D, $6FC8, $704D, $6FC8, $704D
	dw $705C, $70E1, $705C, $70E1, $705C, $70E1, $705C, $70E1

; ---- data $6E50-$70FD (685 bytes) [PROBABLE] animation descriptors / sprite lists reached from the object tables 7F:6DB0-6E50 (same format as bank 72:786C-7A1F: sprite list = count + count*(y,x,tile,attr), descriptors 02 00 .. dw dw)

Data_7F_6E50:: ; 7F:6E50
	db $54, $6E, $65, $6E, $04, $00, $00, $28, $04, $00, $0C, $28, $24, $0C, $00, $28
	db $44, $0C, $0C, $28, $64, $04, $FF, $FF, $28, $04, $FF, $0D, $28, $24, $0D, $FF
	db $28, $44, $0D, $0D, $28, $64, $02, $00, $2E, $01, $08, $83, $6E, $94, $6E, $A5
	db $6E, $B6, $6E, $04, $00, $00, $02, $00, $08, $00, $12, $00, $00, $08, $02, $20
	db $08, $08, $12, $20, $04, $00, $00, $04, $00, $08, $00, $14, $00, $00, $08, $04
	db $20, $08, $08, $14, $20, $04, $00, $00, $02, $00, $08, $00, $12, $00, $00, $08
	db $02, $20, $08, $08, $12, $20, $04, $00, $00, $05, $00, $08, $00, $15, $00, $00
	db $08, $05, $20, $08, $08, $15, $20, $04, $00, $08, $01, $08, $02, $08, $03, $08
	db $D4, $6E, $E5, $6E, $04, $00, $00, $03, $00, $08, $00, $13, $00, $00, $08, $03
	db $20, $08, $08, $13, $20, $04, $00, $00, $01, $00, $08, $00, $11, $00, $00, $08
	db $01, $20, $08, $08, $11, $20, $02, $00, $17, $01, $17, $FD, $6E, $04, $00, $00
	db $00, $01, $08, $00, $10, $01, $00, $08, $00, $21, $08, $08, $10, $21, $01, $00
	db $04, $13, $6F, $04, $00, $00, $01, $01, $08, $00, $11, $01, $00, $08, $01, $21
	db $08, $08, $11, $21, $01, $00, $04, $2B, $6F, $44, $6F, $06, $00, $00, $0C, $04
	db $00, $08, $0D, $04, $08, $00, $1C, $04, $08, $08, $1D, $04, $00, $10, $0E, $04
	db $08, $10, $1E, $04, $06, $FF, $00, $0C, $04, $FF, $08, $0D, $04, $07, $00, $1C
	db $04, $07, $08, $1D, $04, $FF, $10, $0E, $04, $07, $10, $1E, $04, $02, $00, $2E
	db $01, $08, $66, $6F, $7F, $6F, $06, $00, $00, $0F, $04, $08, $00, $1F, $04, $00
	db $08, $20, $04, $00, $10, $21, $04, $08, $08, $22, $04, $08, $10, $23, $04, $06
	db $FF, $00, $0F, $04, $07, $00, $1F, $04, $FF, $08, $20, $04, $FF, $10, $21, $04
	db $07, $08, $22, $04, $07, $10, $23, $04, $02, $00, $2E, $01, $08, $A1, $6F, $B2
	db $6F, $04, $00, $00, $24, $04, $00, $08, $25, $04, $08, $00, $26, $04, $08, $08
	db $27, $04, $04, $FF, $00, $24, $04, $FF, $08, $25, $04, $07, $00, $26, $04, $07
	db $08, $27, $04, $02, $00, $2E, $01, $08, $D6, $6F, $E7, $6F, $F8, $6F, $09, $70
	db $1A, $70, $2B, $70, $3C, $70, $04, $00, $00, $03, $00, $08, $00, $13, $00, $00
	db $08, $03, $20, $08, $08, $13, $20, $04, $00, $00, $03, $00, $08, $00, $13, $00
	db $00, $08, $0B, $20, $08, $08, $1B, $20, $04, $00, $00, $03, $00, $08, $00, $13
	db $00, $00, $08, $0A, $20, $08, $08, $1A, $20, $04, $00, $00, $03, $00, $08, $00
	db $13, $00, $00, $08, $09, $20, $08, $08, $19, $20, $04, $00, $08, $08, $20, $08
	db $08, $18, $20, $00, $00, $03, $00, $08, $00, $13, $00, $04, $00, $08, $06, $20
	db $00, $00, $07, $20, $08, $08, $16, $20, $08, $00, $17, $20, $04, $00, $00, $02
	db $00, $08, $00, $12, $00, $00, $08, $02, $20, $08, $08, $12, $20, $07, $00, $08
	db $01, $08, $02, $08, $03, $08, $04, $08, $05, $08, $06, $08, $6A, $70, $7B, $70
	db $8C, $70, $9D, $70, $AE, $70, $BF, $70, $D0, $70, $04, $00, $00, $02, $00, $08
	db $00, $12, $00, $00, $08, $02, $20, $08, $08, $12, $20, $04, $00, $00, $06, $00
	db $00, $08, $07, $00, $08, $00, $16, $00, $08, $08, $17, $00, $04, $00, $00, $08
	db $00, $08, $00, $18, $00, $00, $08, $03, $20, $08, $08, $13, $20, $04, $00, $00
	db $09, $00, $08, $00, $19, $00, $00, $08, $03, $20, $08, $08, $13, $20, $04, $00
	db $00, $0A, $00, $08, $00, $1A, $00, $00, $08, $03, $20, $08, $08, $13, $20, $04
	db $00, $00, $0B, $00, $08, $00, $1B, $00, $00, $08, $03, $20, $08, $08, $13, $20
	db $04, $00, $00, $03, $00, $08, $00, $13, $00, $00, $08, $03, $20, $08, $08, $13
	db $20, $07, $00, $08, $01, $08, $02, $08, $03, $08, $04, $08, $05, $08, $06, $08
	db $06, $00, $08, $01, $08, $02, $08, $03, $08, $04, $08, $05, $08
