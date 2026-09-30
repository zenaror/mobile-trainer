; gfx/address_book/shared_tiles_bank28.asm
; bank 28, $4BD0-$54B0 (2272 bytes); pinned by layout.link
; address-book tiles/palette/tables stored in bank 28 (loaded by banks 2A, 2C, 2F)

SECTION "gfx/address_book/shared_tiles_bank28", ROMX

; ---- gfx $4BD0-$4FD0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2C:5931: hl=$4BD0 a=$28 c=$40 de=$8000 (dest VRAM $8000, vbank=0)

Data_28_4BD0:: ; 28:4BD0
	INCBIN "gfx/address_book/shared_tiles_bank28/tiles_4bd0.2bpp"

; ---- gfx $4FD0-$51D0 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2C:5946: hl=$4FD0 a=$28 c=$20 de=$8400 (dest VRAM $8400, vbank=0)

Data_28_4FD0:: ; 28:4FD0
	INCBIN "gfx/address_book/shared_tiles_bank28/tiles_4fd0.2bpp"

; ---- data $51D0-$5210 (64 bytes) [PROBABLE] 8 palettes x 4 RGB555 words (0x40 bytes, all bit15 clear; partly read by executed code) right before the object tables at 5210

Palette_28_51D0:: ; 28:51D0
	INCLUDE "gfx/address_book/shared_tiles_bank28/palette_51d0.pal"

; ---- words $5210-$5280 (112 bytes) [PROBABLE] 7 rows of 16 bytes = 4 identical 4-byte object-table entries (ptr to frame table, ptr to script); every pointer lands on a frame-table/script start found by the sequential sweep of 5210-54B0 (28:5210-54B0); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs [v4: bytes 5214-5218, 5224-5228, 5244-5248 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_28_5210:: ; 28:5210
	dw Data_28_5280, $52A6, Data_28_5280, $52A6, Data_28_5280, $52A6, Data_28_5280, $52A6
	dw $52AB, $52BE, $52AB, $52BE, $52AB, $52BE, $52AB, $52BE
	dw $52C1, $52D4, $52C1, $52D4, $52C1, $52D4, $52C1, $52D4
	dw $52D7, $536E, $52D7, $536E, $52D7, $536E, $52D7, $536E
	dw $5379, $5428, $5379, $5428, $5379, $5428, $5379, $5428
	dw $5436, $546C, $5436, $546C, $5436, $546C, $5436, $546C
	dw $546F, $54A5, $546F, $54A5, $546F, $54A5, $546F, $54A5

; ---- data $5280-$54B0 (560 bytes) [PROBABLE] 7 object record(s): 7 frame tables, 18 frames, 8 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 28:5210-54B0 [v4: bytes 5280-52C1, 52D7-5379 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_28_5280:: ; 28:5280
	db $84, $52, $95, $52, $04, $0A, $FE, $00, $42, $0A, $0A, $00, $62, $FE, $FE, $00
	db $02, $FE, $0A, $00, $22, $04, $0B, $FD, $00, $42, $0B, $0B, $00, $62, $FD, $FD
	db $00, $02, $FD, $0B, $00, $22, $02, $00, $40, $01, $08, $AD, $52, $04, $00, $08
	db $0D, $00, $00, $10, $0E, $00, $08, $08, $2E, $00, $08, $10, $2F, $00, $01, $00
	db $04, $C3, $52, $04, $00, $08, $01, $00, $00, $10, $02, $00, $08, $08, $03, $00
	db $08, $10, $04, $00, $01, $00, $04, $E1, $52, $F2, $52, $13, $53, $34, $53, $55
	db $53, $04, $00, $08, $0D, $00, $00, $10, $0E, $00, $08, $08, $2E, $00, $08, $10
	db $2F, $00, $08, $01, $08, $22, $00, $01, $10, $23, $00, $09, $10, $1F, $00, $09
	db $08, $0F, $00, $03, $08, $42, $02, $03, $10, $42, $02, $0B, $08, $43, $02, $0B
	db $10, $43, $02, $08, $F9, $09, $24, $02, $F9, $11, $25, $02, $01, $09, $26, $02
	db $01, $11, $27, $02, $03, $09, $42, $02, $03, $11, $42, $02, $04, $09, $42, $02
	db $04, $11, $42, $02, $08, $FB, $05, $28, $02, $FB, $0D, $29, $02, $FB, $15, $2A
	db $02, $03, $05, $2B, $02, $03, $0D, $2C, $02, $03, $15, $2D, $02, $04, $08, $42
	db $02, $04, $10, $42, $02, $06, $FD, $05, $19, $02, $FD, $0D, $1A, $02, $FD, $15
	db $1B, $02, $05, $05, $1C, $02, $05, $0D, $1D, $02, $05, $15, $1E, $02, $05, $00
	db $05, $01, $05, $02, $05, $03, $03, $04, $12, $83, $53, $94, $53, $B5, $53, $D6
	db $53, $03, $54, $04, $00, $08, $01, $00, $00, $10, $02, $00, $08, $08, $03, $00
	db $08, $10, $04, $00, $08, $01, $08, $05, $00, $01, $10, $06, $00, $09, $08, $07
	db $00, $09, $10, $08, $00, $03, $08, $42, $02, $03, $10, $42, $02, $0B, $08, $43
	db $02, $0B, $10, $43, $02, $08, $01, $09, $26, $02, $01, $11, $27, $02, $F9, $09
	db $20, $02, $F9, $11, $21, $02, $03, $09, $42, $02, $03, $11, $42, $02, $04, $09
	db $42, $02, $04, $11, $42, $02, $0B, $03, $05, $2B, $02, $03, $0D, $2C, $02, $03
	db $15, $2D, $02, $FB, $05, $30, $02, $FB, $0D, $31, $02, $FB, $15, $32, $02, $F3
	db $05, $33, $02, $F3, $0D, $34, $02, $F3, $15, $35, $02, $04, $08, $42, $02, $04
	db $10, $42, $02, $09, $F6, $05, $10, $02, $F6, $0D, $11, $02, $F6, $15, $12, $02
	db $FE, $05, $13, $02, $FE, $0D, $14, $02, $FE, $15, $15, $02, $06, $05, $16, $02
	db $06, $0D, $17, $02, $06, $15, $18, $02, $05, $00, $05, $01, $05, $02, $05, $03
	db $03, $04, $12, $01, $00, $04, $3A, $54, $4B, $54, $04, $00, $08, $0D, $00, $00
	db $10, $0E, $00, $08, $08, $2E, $00, $08, $10, $2F, $00, $08, $FB, $08, $36, $00
	db $FB, $10, $37, $00, $03, $08, $38, $00, $03, $10, $39, $00, $01, $08, $42, $02
	db $01, $10, $42, $02, $09, $08, $43, $02, $09, $10, $43, $02, $01, $00, $04, $73
	db $54, $94, $54, $08, $FB, $08, $09, $00, $FB, $10, $0A, $00, $03, $08, $0B, $00
	db $03, $10, $0C, $00, $01, $08, $42, $02, $01, $10, $42, $02, $09, $08, $43, $02
	db $09, $10, $43, $02, $04, $00, $08, $01, $00, $00, $10, $02, $00, $08, $08, $03
	db $00, $08, $10, $04, $00, $02, $00, $05, $01, $14, $00, $00, $00, $00, $00, $00
