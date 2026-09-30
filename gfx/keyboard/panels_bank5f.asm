; gfx/keyboard/panels_bank5f.asm
; bank 5F, $4000-$6BD0 (11216 bytes); pinned by layout.link
; keyboard panels, tilemaps, object tables loaded by bank 55

SECTION "gfx/keyboard/panels_bank5f", ROMX

; ---- gfx $4000-$4400 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:6A8A: hl=$4000 a=$5F c=$40 de=$8801 (dest VRAM $8800, vbank=1)

Data_5F_4000:: ; 5F:4000
	INCBIN "gfx/keyboard/panels_bank5f/tiles_4000.2bpp"

; ---- gfx $4400-$4800 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:6A9C: hl=$4400 a=$5F c=$40 de=$8C01 (dest VRAM $8C00, vbank=1)

Data_5F_4400:: ; 5F:4400
	INCBIN "gfx/keyboard/panels_bank5f/tiles_4400.2bpp"

; ---- gfx $4800-$4810 (16 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:6AAE: hl=$4800 a=$5F c=$01 de=$9001 (dest VRAM $9000, vbank=1)

Data_5F_4800:: ; 5F:4800
	INCBIN "gfx/keyboard/panels_bank5f/tiles_4800.2bpp"

; ---- data $4810-$49C8 (440 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 55:6ABF: hl=$4810 a=$5F b=11 rows c=20 cols (tiles then attrs) de=$D240

Data_5F_4810:: ; 5F:4810
	INCBIN "gfx/keyboard/panels_bank5f/tilemap_4810.tilemap"
	INCBIN "gfx/keyboard/panels_bank5f/tilemap_4810.attrmap"

; ---- zero $49C8-$49D0 (8 bytes) [PROBABLE] 0x00 padding at the end of the tilemap block, before the tile block at $49D0
	ds $8, $00

; ---- gfx $49D0-$4CD0 (768 bytes) [CONFIRMED] tiles-vram: 8 call site(s) (55:5C00 67:5184 67:5771 67:65B1); first: hdma_rom_to_vram at 55:5C00: hl=$49D0 a=$5F c=$30 de=$8001 (dest VRAM $8000, vbank=1)

Data_5F_49D0:: ; 5F:49D0
	INCBIN "gfx/keyboard/panels_bank5f/tiles_49d0.2bpp"

; ---- data $4CD0-$4CF8 (40 bytes) [PROBABLE] 40 bytes RGB555: two palette blocks copied by Function_4F_4000, hl=$4CD0 bc=$0010 de=$D830 and hl=$4CE0 bc=$0018 de=$D868 (loader calls at 55:5C2C, 55:5C11, 67:51A6 ...); replaces the mapper guess 4CD0-4D1C which overlapped the sprite tables

Palette_5F_4CD0:: ; 5F:4CD0
	INCLUDE "gfx/keyboard/panels_bank5f/palette_4cd0.pal"

; ---- words $4CF8-$4D48 (80 bytes) [PROBABLE] sprite object table: 4-byte entries (frame-table ptr, animation-script ptr) indexed by B&7F, the layout read by init_object_from_table 00:0A82/00:0AB8; rows of 16 bytes = the same entry repeated 4 times; base $4CF8 is passed as de with a=$5F at call sites listed in analysis/gfx_candidates.tsv (object-table); entries 0000/0000 4D48/4D7E 4D9A/4DC0 0000/0000 4DE3/4DFE 4E01/4E20 4E23/4E42 4DC5/4DE0 0000/0000 4E45/4E54 4E57/4E66 4E69/4E78 4E7B/4E8A 4E8D/4E9C 0000/0000 4D83/4D95 0000/0000 4E9F/4EB2 0000/0000 4EB5/4EC8

Table_5F_4CF8:: ; 5F:4CF8
	dw $0000, $0000, Table_5F_4D48, Data_5F_4D7E, Table_5F_4D9A, Data_5F_4DC0, $0000, $0000
	dw Table_5F_4DE3, Data_5F_4DFE, Table_5F_4E01, Data_5F_4E20, Table_5F_4E23, Data_5F_4E42, Table_5F_4DC5, Data_5F_4DE0
	dw $0000, $0000, Table_5F_4E45, Data_5F_4E54, Table_5F_4E57, Data_5F_4E66, Table_5F_4E69, Data_5F_4E78
	dw Table_5F_4E7B, Data_5F_4E8A, Table_5F_4E8D, Data_5F_4E9C, $0000, $0000, Table_5F_4D83, Data_5F_4D95
	dw $0000, $0000, Table_5F_4E9F, Data_5F_4EB2, $0000, $0000, Table_5F_4EB5, Data_5F_4EC8

; ---- words $4D48-$4D4C (4 bytes) [PROBABLE] sprite frame table: 2 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_5F_4D48:: ; 5F:4D48
	dw Data_5F_4D4C, Data_5F_4D65

; ---- data $4D4C-$4D65 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_5F_4D4C:: ; 5F:4D4C
	db $06, $FC, $01, $24, $0E, $04, $01, $25, $0E, $FF, $00, $20, $0E, $FF, $08, $21
	db $0E, $07, $00, $22, $0E, $07, $08, $23, $0E

; ---- data $4D65-$4D7E (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_5F_4D65:: ; 5F:4D65
	db $06, $FB, $01, $24, $0E, $03, $01, $25, $0E, $FF, $00, $20, $0E, $FF, $08, $21
	db $0E, $07, $00, $22, $0E, $07, $08, $23, $0E

; ---- data $4D7E-$4D83 (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:46 1:8

Data_5F_4D7E:: ; 5F:4D7E
	db $02, $00, $2E, $01, $08

; ---- words $4D83-$4D87 (4 bytes) [PROBABLE] sprite frame table: 2 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_5F_4D83:: ; 5F:4D83
	dw Data_5F_4D87, Data_5F_4D90

; ---- data $4D87-$4D90 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

Data_5F_4D87:: ; 5F:4D87
	db $02, $00, $00, $26, $0F, $08, $00, $27, $0F

; ---- data $4D90-$4D95 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_5F_4D90:: ; 5F:4D90
	db $01, $00, $00, $28, $0F

; ---- data $4D95-$4D9A (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:20 1:20

Data_5F_4D95:: ; 5F:4D95
	db $02, $00, $14, $01, $14

; ---- words $4D9A-$4D9E (4 bytes) [PROBABLE] sprite frame table: 2 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_5F_4D9A:: ; 5F:4D9A
	dw Data_5F_4D9E, Data_5F_4DAF

; ---- data $4D9E-$4DAF (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

Data_5F_4D9E:: ; 5F:4D9E
	db $04, $00, $00, $00, $0F, $0C, $00, $00, $4F, $00, $0C, $00, $2F, $0C, $0C, $00
	db $6F

; ---- data $4DAF-$4DC0 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

Data_5F_4DAF:: ; 5F:4DAF
	db $04, $FF, $FF, $00, $0F, $0D, $FF, $00, $4F, $FF, $0D, $00, $2F, $0D, $0D, $00
	db $6F

; ---- data $4DC0-$4DC5 (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:46 1:8

Data_5F_4DC0:: ; 5F:4DC0
	db $02, $00, $2E, $01, $08

; ---- words $4DC5-$4DC7 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_5F_4DC5:: ; 5F:4DC5
	dw Data_5F_4DC7

; ---- data $4DC7-$4DE0 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_5F_4DC7:: ; 5F:4DC7
	db $06, $00, $00, $01, $0F, $00, $08, $02, $0F, $00, $10, $03, $0F, $00, $18, $04
	db $0F, $00, $20, $05, $0F, $00, $28, $06, $0F

; ---- data $4DE0-$4DE3 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_5F_4DE0:: ; 5F:4DE0
	db $01, $00, $04

; ---- words $4DE3-$4DE5 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_5F_4DE3:: ; 5F:4DE3
	dw Data_5F_4DE5

; ---- data $4DE5-$4DFE (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_5F_4DE5:: ; 5F:4DE5
	db $06, $00, $00, $01, $0F, $00, $08, $02, $0F, $00, $10, $03, $0F, $00, $18, $04
	db $0F, $00, $20, $07, $0F, $00, $28, $08, $0F

; ---- data $4DFE-$4E01 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_5F_4DFE:: ; 5F:4DFE
	db $01, $00, $04

; ---- words $4E01-$4E03 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_5F_4E01:: ; 5F:4E01
	dw Data_5F_4E03

; ---- data $4E03-$4E20 (29 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 7 piece(s); length tiles exactly against the frame-table pointers

Data_5F_4E03:: ; 5F:4E03
	db $07, $00, $00, $01, $0F, $00, $08, $02, $0F, $00, $10, $03, $0F, $00, $18, $04
	db $0F, $00, $20, $09, $0F, $00, $28, $0A, $0F, $00, $30, $0B, $0F

; ---- data $4E20-$4E23 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_5F_4E20:: ; 5F:4E20
	db $01, $00, $04

; ---- words $4E23-$4E25 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_5F_4E23:: ; 5F:4E23
	dw Data_5F_4E25

; ---- data $4E25-$4E42 (29 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 7 piece(s); length tiles exactly against the frame-table pointers

Data_5F_4E25:: ; 5F:4E25
	db $07, $00, $00, $01, $0F, $00, $08, $02, $0F, $00, $10, $03, $0F, $00, $18, $04
	db $0F, $00, $20, $0C, $0F, $00, $28, $0D, $0F, $00, $30, $0E, $0F

; ---- data $4E42-$4E45 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_5F_4E42:: ; 5F:4E42
	db $01, $00, $04

; ---- words $4E45-$4E47 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_5F_4E45:: ; 5F:4E45
	dw Data_5F_4E47

; ---- data $4E47-$4E54 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Data_5F_4E47:: ; 5F:4E47
	db $03, $00, $00, $15, $0F, $00, $08, $16, $0F, $00, $10, $17, $0F

; ---- data $4E54-$4E57 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:8

Data_5F_4E54:: ; 5F:4E54
	db $01, $00, $08

; ---- words $4E57-$4E59 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_5F_4E57:: ; 5F:4E57
	dw Data_5F_4E59

; ---- data $4E59-$4E66 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Data_5F_4E59:: ; 5F:4E59
	db $03, $00, $00, $18, $0F, $00, $08, $19, $0F, $00, $10, $1A, $0F

; ---- data $4E66-$4E69 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:8

Data_5F_4E66:: ; 5F:4E66
	db $01, $00, $08

; ---- words $4E69-$4E6B (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_5F_4E69:: ; 5F:4E69
	dw Data_5F_4E6B

; ---- data $4E6B-$4E78 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Data_5F_4E6B:: ; 5F:4E6B
	db $03, $00, $00, $1B, $0F, $00, $08, $1C, $0F, $00, $10, $1D, $0F

; ---- data $4E78-$4E7B (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:8

Data_5F_4E78:: ; 5F:4E78
	db $01, $00, $08

; ---- words $4E7B-$4E7D (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_5F_4E7B:: ; 5F:4E7B
	dw Data_5F_4E7D

; ---- data $4E7D-$4E8A (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Data_5F_4E7D:: ; 5F:4E7D
	db $03, $00, $00, $0F, $0F, $00, $08, $10, $0F, $00, $10, $11, $0F

; ---- data $4E8A-$4E8D (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_5F_4E8A:: ; 5F:4E8A
	db $01, $00, $04

; ---- words $4E8D-$4E8F (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_5F_4E8D:: ; 5F:4E8D
	dw Data_5F_4E8F

; ---- data $4E8F-$4E9C (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Data_5F_4E8F:: ; 5F:4E8F
	db $03, $00, $00, $12, $0F, $00, $08, $13, $0F, $00, $10, $14, $0F

; ---- data $4E9C-$4E9F (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_5F_4E9C:: ; 5F:4E9C
	db $01, $00, $04

; ---- words $4E9F-$4EA1 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_5F_4E9F:: ; 5F:4E9F
	dw Data_5F_4EA1

; ---- data $4EA1-$4EB2 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

Data_5F_4EA1:: ; 5F:4EA1
	db $04, $00, $00, $29, $0D, $00, $08, $2A, $0D, $08, $00, $2B, $0D, $08, $08, $2C
	db $0D

; ---- data $4EB2-$4EB5 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_5F_4EB2:: ; 5F:4EB2
	db $01, $00, $04

; ---- words $4EB5-$4EB7 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_5F_4EB5:: ; 5F:4EB5
	dw Data_5F_4EB7

; ---- data $4EB7-$4EC8 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

Data_5F_4EB7:: ; 5F:4EB7
	db $04, $00, $00, $1E, $0D, $00, $08, $1F, $0D, $08, $00, $2E, $0D, $08, $08, $2F
	db $0D

; ---- data $4EC8-$4ECB (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_5F_4EC8:: ; 5F:4EC8
	db $01, $00, $04

; ---- data $4ECB-$50D3 (520 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 55:66FA: hl=$4ECB a=$5F b=13 rows c=20 cols (tiles then attrs) de=$D240

Data_5F_4ECB:: ; 5F:4ECB
	INCBIN "gfx/keyboard/panels_bank5f/tilemap_4ecb.tilemap"
	INCBIN "gfx/keyboard/panels_bank5f/tilemap_4ecb.attrmap"

; ---- data $50D3-$52DB (520 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 55:6721: hl=$50D3 a=$5F b=13 rows c=20 cols (tiles then attrs) de=$D240

Data_5F_50D3:: ; 5F:50D3
	INCBIN "gfx/keyboard/panels_bank5f/tilemap_50d3.tilemap"
	INCBIN "gfx/keyboard/panels_bank5f/tilemap_50d3.attrmap"

; ---- data $52DB-$54E3 (520 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 55:6795: hl=$52DB a=$5F b=13 rows c=20 cols (tiles then attrs) de=$D240

Data_5F_52DB:: ; 5F:52DB
	INCBIN "gfx/keyboard/panels_bank5f/tilemap_52db.tilemap"
	INCBIN "gfx/keyboard/panels_bank5f/tilemap_52db.attrmap"

; ---- data $54E3-$56EB (520 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 55:6736: hl=$54E3 a=$5F b=13 rows c=20 cols (tiles then attrs) de=$D240 [verifier: call site never executed in a trace -> PROBABLE]

Data_5F_54E3:: ; 5F:54E3
	INCBIN "gfx/keyboard/panels_bank5f/tilemap_54e3.tilemap"
	INCBIN "gfx/keyboard/panels_bank5f/tilemap_54e3.attrmap"

; ---- data $56EB-$58F3 (520 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 55:674B: hl=$56EB a=$5F b=13 rows c=20 cols (tiles then attrs) de=$D240 [verifier: call site never executed in a trace -> PROBABLE]

Data_5F_56EB:: ; 5F:56EB
	INCBIN "gfx/keyboard/panels_bank5f/tilemap_56eb.tilemap"
	INCBIN "gfx/keyboard/panels_bank5f/tilemap_56eb.attrmap"

; ---- gfx $58F3-$5900 (13 bytes) [PROBABLE] tiles-2bpp: heuristic: 139 coherent tiles (hsim2=0.738 vsim2=0.748, 0 blank) parity 0; 2259/2272 bytes also covered by call-site blocks [clipped from 5730-6010 by higher-priority evidence]

Data_5F_58F3:: ; 5F:58F3
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- gfx $5900-$5D00 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:67AB: hl=$5900 a=$5F c=$40 de=$8801 (dest VRAM $8800, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_5F_5900:: ; 5F:5900
	INCBIN "gfx/keyboard/panels_bank5f/tiles_5900.2bpp"

; ---- gfx $5D00-$6100 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:67BD: hl=$5D00 a=$5F c=$40 de=$8C01 (dest VRAM $8C00, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_5F_5D00:: ; 5F:5D00
	INCBIN "gfx/keyboard/panels_bank5f/tiles_5d00.2bpp"

; ---- gfx $6100-$6200 (256 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:67CF: hl=$6100 a=$5F c=$10 de=$9001 (dest VRAM $9000, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_5F_6100:: ; 5F:6100
	INCBIN "gfx/keyboard/panels_bank5f/tiles_6100.2bpp"

; ---- zero $6200-$6980 (1920 bytes) [HYPOTHESIS] padding? run of 1920 x $00 in unclassified bytes
	ds $780, $00

; ---- data $6980-$69B0 (48 bytes) [HYPOTHESIS] run of 48 x $06 directly before the tilemap+attr block at 69B0 (constant fill of the kind used in attribute maps); not referenced, purpose unknown

Data_5F_6980:: ; 5F:6980
	db $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
	db $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
	db $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06

; ---- data $69B0-$6BB8 (520 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 55:684E: hl=$69B0 a=$5F b=13 rows c=20 cols (tiles then attrs) de=$D240 [verifier: call site never executed in a trace -> PROBABLE]

Data_5F_69B0:: ; 5F:69B0
	INCBIN "gfx/keyboard/panels_bank5f/tilemap_69b0.tilemap"
	INCBIN "gfx/keyboard/panels_bank5f/tilemap_69b0.attrmap"

; ---- data $6BB8-$6BD0 (24 bytes) [PROBABLE] palette-rgb555: heuristic: 12 RGB555 words as 3 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Data_5F_6BB8:: ; 5F:6BB8
	INCLUDE "gfx/keyboard/panels_bank5f/palette_6bb8.pal"
