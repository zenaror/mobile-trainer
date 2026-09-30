; gfx/top_menu/top_menu.asm
; bank 1E, $40D7-$658B (9396 bytes); pinned by layout.link
; top menu tilemaps, tiles, palettes, object tables (loaded by bank 1F)

SECTION "gfx/top_menu/top_menu", ROMX

; ---- data $40D7-$4357 (640 bytes) [CONFIRMED] tilemap+attr: 2 call site(s) (1F:40E8 1F:435C); first: copy_tilemap_rect_pair at 1F:40E8: hl=$40D7 a=$1E b=16 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_TopMenu_1E_40D7:: ; 1E:40D7
Data_1E_40D7::
	INCBIN "gfx/top_menu/top_menu/tilemap_40d7.tilemap"
	INCBIN "gfx/top_menu/top_menu/tilemap_40d7.attrmap"

; ---- data $4357-$48C1 (1386 bytes) [PROBABLE] contiguous data block 4357-48C1: 990 bytes were read as data by executed code in mGBA traces (1 separate read ranges, e.g. 4357-4735) and 396 bytes between/around those reads were never read; the whole run is one table/buffer read by index (gaps unread in the traces); content class not decoded [merged from 2 regions by classify_g2]

Data_1E_4357:: ; 1E:4357
	db $04, $05, $05, $05, $05, $05, $05, $05, $05, $05, $07, $12, $80, $03, $82, $89
	db $8B, $8D, $03, $03, $03, $16, $12, $84, $86, $88, $8F, $91, $93, $95, $97, $03
	db $16, $12, $8A, $8C, $8E, $99, $9B, $9D, $9D, $9F, $03, $16, $12, $90, $92, $94
	db $83, $85, $87, $9D, $9F, $03, $16, $12, $1D, $1E, $1F, $20, $21, $22, $23, $24
	db $25, $16, $12, $26, $27, $28, $29, $2A, $2B, $2C, $2D, $2E, $16, $12, $2F, $30
	db $31, $32, $33, $34, $35, $36, $37, $16, $13, $14, $14, $14, $14, $0D, $18, $18
	db $18, $18, $0B, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $29, $09, $03
	db $09, $03, $02, $02, $02, $09, $09, $09, $29, $09, $03, $03, $03, $02, $02, $02
	db $02, $02, $09, $29, $09, $03, $03, $03, $02, $02, $02, $02, $02, $09, $29, $09
	db $03, $03, $03, $03, $03, $03, $02, $02, $09, $29, $09, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $29, $09, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $29
	db $09, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $29, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $29, $04, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $07, $12, $03, $03, $82, $A0, $A2, $A4, $03, $03, $03, $16, $12, $96, $98, $9A
	db $A6, $A8, $AA, $95, $97, $03, $16, $12, $9C, $9E, $81, $99, $9B, $9D, $9D, $9F
	db $03, $16, $12, $90, $92, $94, $83, $85, $87, $9D, $9F, $03, $16, $12, $1D, $1E
	db $1F, $20, $21, $22, $23, $24, $25, $16, $12, $26, $27, $28, $29, $2A, $2B, $2C
	db $2D, $2E, $16, $12, $2F, $30, $31, $32, $33, $34, $35, $36, $37, $16, $13, $14
	db $14, $14, $14, $0D, $18, $18, $18, $18, $0B, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $29, $09, $09, $09, $03, $02, $02, $02, $09, $09, $09, $29, $09
	db $03, $03, $03, $02, $02, $02, $02, $02, $09, $29, $09, $03, $03, $03, $02, $02
	db $02, $02, $02, $09, $29, $09, $03, $03, $03, $03, $03, $03, $02, $02, $09, $29
	db $09, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $29, $09, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $29, $09, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $29, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $29, $07, $05, $05, $05
	db $05, $05, $05, $05, $05, $05, $04, $16, $AC, $AE, $B0, $B2, $B4, $F3, $F5, $03
	db $03, $12, $16, $B6, $B8, $BA, $BC, $BE, $F7, $F9, $03, $03, $12, $16, $A1, $A3
	db $A5, $A7, $A9, $03, $03, $03, $03, $12, $16, $AB, $AD, $AF, $B1, $B3, $03, $03
	db $03, $03, $12, $16, $38, $39, $3A, $3B, $3C, $3D, $3E, $3F, $40, $12, $16, $41
	db $42, $43, $44, $45, $46, $47, $48, $49, $12, $16, $4A, $4B, $4C, $4D, $4E, $4F
	db $50, $51, $52, $12, $0B, $18, $18, $18, $18, $0D, $14, $14, $14, $14, $13, $09
	db $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $09, $05, $05, $05, $05, $05
	db $04, $04, $29, $29, $29, $09, $05, $05, $05, $05, $05, $04, $04, $29, $29, $29
	db $09, $05, $05, $05, $05, $05, $09, $09, $29, $29, $29, $09, $05, $05, $05, $05
	db $05, $09, $09, $29, $29, $29, $09, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	db $29, $09, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $29, $09, $0C, $0C, $0C
	db $0C, $0C, $0C, $0C, $0C, $0C, $29, $09, $29, $29, $29, $29, $29, $29, $29, $29
	db $29, $29, $07, $05, $05, $05, $05, $05, $05, $05, $05, $05, $04, $16, $B5, $B7
	db $B9, $BB, $03, $FB, $F5, $03, $03, $12, $16, $B6, $BD, $BF, $C0, $C2, $FD, $FF
	db $03, $03, $12, $16, $C4, $C6, $C8, $CA, $CC, $03, $03, $03, $03, $12, $16, $CE
	db $D0, $D2, $D4, $D6, $03, $03, $03, $03, $12, $16, $38, $39, $3A, $3B, $3C, $3D
	db $3E, $3F, $40, $12, $16, $41, $42, $43, $44, $45, $46, $47, $48, $49, $12, $16
	db $4A, $4B, $4C, $4D, $4E, $4F, $50, $51, $52, $12, $0B, $18, $18, $18, $18, $0D
	db $14, $14, $14, $14, $13, $09, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29
	db $09, $05, $05, $05, $05, $29, $04, $04, $29, $29, $29, $09, $05, $05, $05, $05
	db $05, $04, $04, $29, $29, $29, $09, $05, $05, $05, $05, $05, $09, $09, $09, $29
	db $29, $09, $05, $05, $05, $05, $05, $29, $09, $09, $29, $29, $09, $0C, $0C, $0C
	db $0C, $0C, $0C, $0C, $0C, $0C, $29, $09, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	db $0C, $29, $09, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $29, $09, $29, $29
	db $29, $29, $29, $29, $29, $29, $29, $29, $07, $05, $05, $05, $05, $05, $05, $05
	db $05, $05, $04, $16, $B5, $B7, $D8, $DA, $03, $01, $F5, $03, $03, $12, $16, $B6
	db $DC, $DE, $C1, $C3, $02, $03, $03, $03, $12, $16, $C5, $C7, $C9, $CB, $CD, $03
	db $03, $03, $03, $12, $16, $CE, $CF, $D1, $D3, $D5, $03, $03, $03, $03, $12, $16
	db $38, $39, $3A, $3B, $3C, $3D, $3E, $3F, $40, $12, $16, $41, $42, $43, $44, $45
	db $46, $47, $48, $49, $12, $16, $4A, $4B, $4C, $4D, $4E, $4F, $50, $51, $52, $12
	db $0B, $18, $18, $18, $18, $0D, $14, $14, $14, $14, $13, $09, $29, $29, $29, $29
	db $29, $29, $29, $29, $29, $29, $09, $05, $05, $05, $05, $29, $04, $04, $29, $29
	db $29, $09, $05, $05, $05, $05, $05, $04, $04, $29, $29, $29, $09, $05, $05, $05
	db $05, $05, $29, $29, $29, $29, $29, $09, $05, $05, $05, $05, $05, $29, $29, $29
	db $29, $29, $09, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $29, $09, $0C, $0C
	db $0C, $0C, $0C, $0C, $0C, $0C, $0C, $29, $09, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	db $0C, $0C, $29, $09, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $07, $05
	db $05, $05, $05, $05, $05, $05, $05, $05, $04, $16, $AC, $AE, $D7, $D9, $03, $01
	db $F5, $03, $03, $12, $16, $B6, $DB, $DD, $DF, $E0, $02, $03, $03, $03, $12, $16
	db $A1, $E4, $E6, $E8, $EA, $03, $03, $03, $03, $12, $16, $AB, $EC, $EE, $F0, $F2
	db $03, $03, $03, $03, $12, $16, $38, $39, $3A, $3B, $3C, $3D, $3E, $3F, $40, $12
	db $16, $41, $42, $43, $44, $45, $46, $47, $48, $49, $12, $16, $4A, $4B, $4C, $4D
	db $4E, $4F, $50, $51, $52, $12, $0B, $18, $18, $18, $18, $0D, $14, $14, $14, $14
	db $13, $09, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $09, $05, $05, $05
	db $05, $29, $04, $04, $29, $29, $29, $09, $05, $05, $05, $05, $05, $04, $04, $29
	db $29, $29, $09, $05, $05, $05, $05, $05, $29, $29, $29, $29, $29, $09, $05, $05
	db $05, $05, $05, $29, $29, $29, $29, $29, $09, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	db $0C, $0C, $29, $09, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $29, $09, $0C
	db $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $29, $09, $29, $29, $29, $29, $29, $29
	db $29, $29, $29, $29, $07, $05, $05, $05, $05, $05, $05, $05, $05, $05, $04, $16
	db $B5, $B7, $F4, $F6, $03, $FB, $F5, $03, $03, $12, $16, $B6, $F8, $FA, $FC, $FE
	db $FD, $FF, $03, $03, $12, $16, $E1, $E3, $E5, $E7, $E9, $03, $03, $03, $03, $12
	db $16, $CE, $EB, $ED, $EF, $F1, $03, $03, $03, $03, $12, $16, $38, $39, $3A, $3B
	db $3C, $3D, $3E, $3F, $40, $12, $16, $41, $42, $43, $44, $45, $46, $47, $48, $49
	db $12, $16, $4A, $4B, $4C, $4D, $4E, $4F, $50, $51, $52, $12, $0B, $18, $18, $18
	db $18, $0D, $14, $14, $14, $14, $13, $09, $29, $29, $29, $29, $29, $29, $29, $29
	db $29, $29, $09, $05, $05, $05, $05, $29, $04, $04, $29, $29, $29, $09, $05, $05
	db $05, $05, $05, $04, $04, $29, $29, $29, $09, $05, $05, $05, $05, $05, $29, $29
	db $29, $29, $29, $09, $05, $05, $05, $05, $05, $29, $29, $29, $29, $29, $09, $0C
	db $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $29, $09, $0C, $0C, $0C, $0C, $0C, $0C
	db $0C, $0C, $0C, $29, $09, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $29, $09
	db $29, $29, $29, $29, $29, $29, $29, $29, $29, $29

; ---- data $48C1-$4999 (216 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 1F:44F7: hl=$48C1 a=$1E b=9 rows c=12 cols (tiles then attrs) de=$D0E4

Tilemap_TopMenu_1E_48C1:: ; 1E:48C1
Data_1E_48C1::
	INCBIN "gfx/top_menu/top_menu/tilemap_48c1.tilemap"
	INCBIN "gfx/top_menu/top_menu/tilemap_48c1.attrmap"

; ---- zero $4999-$49A0 (7 bytes) [PROBABLE] 0x00 padding between the tilemap block ending at $4999 and the tile block at $49A0
	ds $7, $00

; ---- gfx $49A0-$4DA0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1F:405A: hl=$49A0 a=$1E c=$40 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_TopMenu_Tiles8000:: ; 1E:49A0
Data_1E_49A0::
	INCBIN "gfx/top_menu/top_menu/tiles_49a0.2bpp"

; ---- gfx $4DA0-$51A0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1F:406C: hl=$4DA0 a=$1E c=$40 de=$8400 (dest VRAM $8400, vbank=0)

Gfx_TopMenu_Tiles8400:: ; 1E:4DA0
Data_1E_4DA0::
	INCBIN "gfx/top_menu/top_menu/tiles_4da0.2bpp"

; ---- gfx $51A0-$55A0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1F:407E: hl=$51A0 a=$1E c=$40 de=$8800 (dest VRAM $8800, vbank=0)

Gfx_TopMenu_Tiles8800:: ; 1E:51A0
Data_1E_51A0::
	INCBIN "gfx/top_menu/top_menu/tiles_51a0.2bpp"

; ---- gfx $55A0-$59A0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1F:4090: hl=$55A0 a=$1E c=$40 de=$8C00 (dest VRAM $8C00, vbank=0)

Gfx_TopMenu_Tiles8C00:: ; 1E:55A0
Data_1E_55A0::
	INCBIN "gfx/top_menu/top_menu/tiles_55a0.2bpp"

; ---- gfx $59A0-$5BA0 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1F:40A2: hl=$59A0 a=$1E c=$20 de=$9000 (dest VRAM $9000, vbank=0)

Gfx_TopMenu_Tiles9000:: ; 1E:59A0
Data_1E_59A0::
	INCBIN "gfx/top_menu/top_menu/tiles_59a0.2bpp"

; ---- gfx $5BA0-$5FA0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1F:40B4: hl=$5BA0 a=$1E c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_TopMenu_Tiles9000Vb1:: ; 1E:5BA0
Data_1E_5BA0::
	INCBIN "gfx/top_menu/top_menu/tiles_5ba0.2bpp"

; ---- gfx $5FA0-$62A0 (768 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1F:40C6: hl=$5FA0 a=$1E c=$30 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_TopMenu_Tiles9400Vb1:: ; 1E:5FA0
Data_1E_5FA0::
	INCBIN "gfx/top_menu/top_menu/tiles_5fa0.2bpp"

; ---- data $62A0-$62E0 (64 bytes) [PROBABLE] 64-byte RGB555 palette block copied by Function_4F_4000 (hl=$62A0 a=$1E bc=$0040 de=$D800) at 1F:40D7; the call site 1F:40D7 IS in analysis/coverage_union.tsv (executed; the earlier 'never executed' used the old 18-scenario union) - status kept PROBABLE because the palette role of the $D800 buffer is not independently demonstrated; replaces the mapper palette guess 62A0-6360 which swallowed the first sprite records

Palette_TopMenu_Bg:: ; 1E:62A0
Palette_1E_62A0::
	INCLUDE "gfx/top_menu/top_menu/palette_62a0.pal"

; ---- data $62E0-$6320 (64 bytes) [PROBABLE] 64-byte RGB555 palette block copied by Function_4F_4000 (hl=$62E0 a=$1E bc=$0040 de=$D840) at 1F:4109; the call site 1F:4109 IS in analysis/coverage_union.tsv (executed; earlier 'never executed' was based on the old 18-scenario union) - status kept PROBABLE; replaces the mapper palette guess 62A0-6360 which swallowed the first sprite records

Palette_TopMenu_Obj:: ; 1E:62E0
Palette_1E_62E0::
	INCLUDE "gfx/top_menu/top_menu/palette_62e0.pal"

; ---- words $6320-$6332 (18 bytes) [PROBABLE] sprite frame table: 9 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

TopMenu_Anim1Frames:: ; 1E:6320
Table_1E_6320::
	sprite_frame_table TopMenu_Anim1Frame0, TopMenu_Anim1Frame1, TopMenu_Anim1Frame2, TopMenu_Anim1Frame3
	sprite_frame_table TopMenu_Anim1Frame4, TopMenu_Anim1Frame5, TopMenu_Anim1Frame6, TopMenu_Anim1Frame7
	sprite_frame_table TopMenu_Anim1Frame8

; ---- data $6332-$633F (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim1Frame0:: ; 1E:6332
Data_1E_6332::
	sprite_frame 3
	sprite_oam 0, 0, $00, 2
	sprite_oam 0, 8, $02, 2
	sprite_oam 0, 16, $04, 2

; ---- data $633F-$634C (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim1Frame1:: ; 1E:633F
Data_1E_633F::
	sprite_frame 3
	sprite_oam 0, 0, $06, 2
	sprite_oam 0, 8, $08, 2
	sprite_oam 0, 16, $0A, 2

; ---- data $634C-$6359 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim1Frame2:: ; 1E:634C
Data_1E_634C::
	sprite_frame 3
	sprite_oam 0, 0, $0C, 2
	sprite_oam 0, 8, $0E, 2
	sprite_oam 0, 16, $10, 2

; ---- data $6359-$6366 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim1Frame3:: ; 1E:6359
Data_1E_6359::
	sprite_frame 3
	sprite_oam -14, 16, $00, 2
	sprite_oam -14, 24, $02, 2
	sprite_oam -14, 32, $04, 2

; ---- data $6366-$6373 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim1Frame4:: ; 1E:6366
Data_1E_6366::
	sprite_frame 3
	sprite_oam -12, 20, $06, 2
	sprite_oam -12, 28, $08, 2
	sprite_oam -12, 36, $0A, 2

; ---- data $6373-$6380 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim1Frame5:: ; 1E:6373
Data_1E_6373::
	sprite_frame 3
	sprite_oam -14, 24, $0C, 2
	sprite_oam -14, 32, $0E, 2
	sprite_oam -14, 40, $10, 2

; ---- data $6380-$638D (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim1Frame6:: ; 1E:6380
Data_1E_6380::
	sprite_frame 3
	sprite_oam -12, 28, $00, 2
	sprite_oam -12, 36, $02, 2
	sprite_oam -12, 44, $04, 2

; ---- data $638D-$639A (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim1Frame7:: ; 1E:638D
Data_1E_638D::
	sprite_frame 3
	sprite_oam -14, 32, $06, 2
	sprite_oam -14, 40, $08, 2
	sprite_oam -14, 48, $0A, 2

; ---- data $639A-$63A7 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim1Frame8:: ; 1E:639A
Data_1E_639A::
	sprite_frame 3
	sprite_oam -12, 36, $0C, 2
	sprite_oam -12, 44, $0E, 2
	sprite_oam -12, 52, $10, 2

; ---- data $63A7-$63BA (19 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 9 step(s), (frame,delay) pairs: 0:8 1:8 2:8 3:8 4:8 5:8 6:8 7:8 8:8

TopMenu_Anim1Script:: ; 1E:63A7
Data_1E_63A7::
	sprite_anim 9
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
	sprite_anim_step 2, 8
	sprite_anim_step 3, 8
	sprite_anim_step 4, 8
	sprite_anim_step 5, 8
	sprite_anim_step 6, 8
	sprite_anim_step 7, 8
	sprite_anim_step 8, 8

; ---- words $63BA-$63BE (4 bytes) [PROBABLE] sprite frame table: 2 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

TopMenu_Anim2Frames:: ; 1E:63BA
Table_1E_63BA::
	sprite_frame_table TopMenu_Anim2Frame0, TopMenu_Anim2Frame1

; ---- data $63BE-$63DB (29 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 7 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim2Frame0:: ; 1E:63BE
Data_1E_63BE::
	sprite_frame 7
	sprite_oam 0, 0, $12, 3
	sprite_oam 0, 8, $14, 3
	sprite_oam 0, 16, $16, 3
	sprite_oam 0, 24, $18, 3
	sprite_oam 16, 8, $34, 3
	sprite_oam 16, 16, $36, 3
	sprite_oam 16, 24, $38, 3

; ---- data $63DB-$63F8 (29 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 7 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim2Frame1:: ; 1E:63DB
Data_1E_63DB::
	sprite_frame 7
	sprite_oam -1, 0, $12, 3
	sprite_oam -1, 8, $14, 3
	sprite_oam -1, 16, $16, 3
	sprite_oam -1, 24, $18, 3
	sprite_oam 15, 8, $34, 3
	sprite_oam 15, 16, $36, 3
	sprite_oam 15, 24, $38, 3

; ---- data $63F8-$63FD (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:20 1:20

TopMenu_Anim2Script:: ; 1E:63F8
Data_1E_63F8::
	sprite_anim 2
	sprite_anim_step 0, 20
	sprite_anim_step 1, 20

; ---- words $63FD-$640B (14 bytes) [PROBABLE] sprite frame table: 7 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

TopMenu_Anim3Frames:: ; 1E:63FD
Table_1E_63FD::
	sprite_frame_table TopMenu_Anim3Frame0, TopMenu_Anim3Frame1, TopMenu_Anim3Frame2, TopMenu_Anim3Frame3
	sprite_frame_table TopMenu_Anim3Frame4, TopMenu_Anim3Frame5, TopMenu_Anim3Frame6

; ---- data $640B-$6414 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim3Frame0:: ; 1E:640B
Data_1E_640B::
	sprite_frame 2
	sprite_oam 0, 0, $3A, 5
	sprite_oam 0, 8, $3C, 5

; ---- data $6414-$641D (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim3Frame1:: ; 1E:6414
Data_1E_6414::
	sprite_frame 2
	sprite_oam 0, -8, $5A, 5
	sprite_oam 0, 0, $5C, 5

; ---- data $641D-$6422 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim3Frame2:: ; 1E:641D
Data_1E_641D::
	sprite_frame 1
	sprite_oam 0, -8, $58, 5

; ---- data $6422-$642B (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim3Frame3:: ; 1E:6422
Data_1E_6422::
	sprite_frame 2
	sprite_oam -8, -16, $54, 5
	sprite_oam -8, -8, $56, 5

; ---- data $642B-$6430 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim3Frame4:: ; 1E:642B
Data_1E_642B::
	sprite_frame 1
	sprite_oam -8, -24, $5E, 5

; ---- data $6430-$6435 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim3Frame5:: ; 1E:6430
Data_1E_6430::
	sprite_frame 1
	sprite_oam -14, -24, $3E, 5

; ---- data $6435-$6436 (1 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 0 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim3Frame6:: ; 1E:6435
Data_1E_6435::
	sprite_frame 0

; ---- data $6436-$6445 (15 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 7 step(s), (frame,delay) pairs: 0:6 1:6 2:6 3:6 4:6 5:6 6:30

TopMenu_Anim3Script:: ; 1E:6436
Data_1E_6436::
	sprite_anim 7
	sprite_anim_step 0, 6
	sprite_anim_step 1, 6
	sprite_anim_step 2, 6
	sprite_anim_step 3, 6
	sprite_anim_step 4, 6
	sprite_anim_step 5, 6
	sprite_anim_step 6, 30

; ---- data $6445-$6450 (11 bytes) [HYPOTHESIS] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 5 step(s), (frame,delay) pairs: 0:5 1:5 2:5 3:5 4:5; not named by a known object-table row: found because the gap between neighbours equals exactly this script (+ pad)

Data_1E_6445:: ; 1E:6445
	db $05, $00, $05, $01, $05, $02, $05, $03, $05, $04, $05

; ---- words $6450-$6462 (18 bytes) [PROBABLE] sprite frame table: 9 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

TopMenu_Anim4Frames:: ; 1E:6450
Table_1E_6450::
	sprite_frame_table TopMenu_Anim4Frame0, TopMenu_Anim4Frame1, TopMenu_Anim4Frame2, TopMenu_Anim4Frame3
	sprite_frame_table TopMenu_Anim4Frame4, TopMenu_Anim4Frame5, TopMenu_Anim4Frame6, TopMenu_Anim4Frame7
	sprite_frame_table TopMenu_Anim4Frame8

; ---- data $6462-$6473 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim4Frame0:: ; 1E:6462
Data_1E_6462::
	sprite_frame 4
	sprite_oam 0, 0, $20, 4
	sprite_oam 0, 8, $22, 4
	sprite_oam 16, 0, $40, 4
	sprite_oam 16, 8, $42, 4

; ---- data $6473-$6484 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim4Frame1:: ; 1E:6473
Data_1E_6473::
	sprite_frame 4
	sprite_oam 0, 0, $24, 4
	sprite_oam 0, 8, $26, 4
	sprite_oam 16, 0, $44, 4
	sprite_oam 16, 8, $46, 4

; ---- data $6484-$6495 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim4Frame2:: ; 1E:6484
Data_1E_6484::
	sprite_frame 4
	sprite_oam 0, 0, $28, 4
	sprite_oam 0, 8, $2A, 4
	sprite_oam 16, 0, $48, 4
	sprite_oam 16, 8, $4A, 4

; ---- data $6495-$64A6 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim4Frame3:: ; 1E:6495
Data_1E_6495::
	sprite_frame 4
	sprite_oam 0, 0, $2C, 4
	sprite_oam 0, 8, $2E, 4
	sprite_oam 16, 0, $4C, 4
	sprite_oam 16, 8, $4E, 4

; ---- data $64A6-$64B7 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim4Frame4:: ; 1E:64A6
Data_1E_64A6::
	sprite_frame 4
	sprite_oam 0, 0, $24, 4
	sprite_oam 0, 8, $26, 4
	sprite_oam 16, 0, $44, 4
	sprite_oam 16, 8, $46, 4

; ---- data $64B7-$64C8 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim4Frame5:: ; 1E:64B7
Data_1E_64B7::
	sprite_frame 4
	sprite_oam 0, 0, $30, 4
	sprite_oam 0, 8, $32, 4
	sprite_oam 16, 0, $50, 4
	sprite_oam 16, 8, $52, 4

; ---- data $64C8-$64D9 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim4Frame6:: ; 1E:64C8
Data_1E_64C8::
	sprite_frame 4
	sprite_oam 0, 0, $20, 4
	sprite_oam 0, 8, $22, 4
	sprite_oam 16, 0, $40, 4
	sprite_oam 16, 8, $42, 4

; ---- data $64D9-$64F2 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim4Frame7:: ; 1E:64D9
Data_1E_64D9::
	sprite_frame 6
	sprite_oam 0, 16, $1E, 4
	sprite_oam 0, -8, $1E, 4
	sprite_oam 0, 0, $20, 4
	sprite_oam 0, 8, $22, 4
	sprite_oam 16, 0, $40, 4
	sprite_oam 16, 8, $42, 4

; ---- data $64F2-$6513 (33 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 8 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim4Frame8:: ; 1E:64F2
Data_1E_64F2::
	sprite_frame 8
	sprite_oam 0, 16, $1E, 4
	sprite_oam 0, -8, $1E, 4
	sprite_oam 3, -16, $1E, 4
	sprite_oam 3, 24, $1E, 4
	sprite_oam 0, 0, $20, 4
	sprite_oam 0, 8, $22, 4
	sprite_oam 16, 0, $40, 4
	sprite_oam 16, 8, $42, 4

; ---- data $6513-$6526 (19 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 9 step(s), (frame,delay) pairs: 0:5 1:5 2:5 3:5 4:5 5:5 6:5 7:10 8:10

TopMenu_Anim4Script:: ; 1E:6513
Data_1E_6513::
	sprite_anim 9
	sprite_anim_step 0, 5
	sprite_anim_step 1, 5
	sprite_anim_step 2, 5
	sprite_anim_step 3, 5
	sprite_anim_step 4, 5
	sprite_anim_step 5, 5
	sprite_anim_step 6, 5
	sprite_anim_step 7, 10
	sprite_anim_step 8, 10

; ---- words $6526-$652A (4 bytes) [PROBABLE] sprite frame table: 2 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

TopMenu_Anim5Frames:: ; 1E:6526
Table_1E_6526::
	sprite_frame_table TopMenu_Anim5Frame0, TopMenu_Anim5Frame1

; ---- data $652A-$653B (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim5Frame0:: ; 1E:652A
Data_1E_652A::
	sprite_frame 4
	sprite_oam -3, -1, $1A, 1
	sprite_oam 12, -1, $1A, OAMF_YFLIP | 1
	sprite_oam -3, 61, $1A, OAMF_XFLIP | 1
	sprite_oam 12, 61, $1A, OAMF_YFLIP | OAMF_XFLIP | 1

; ---- data $653B-$654C (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim5Frame1:: ; 1E:653B
Data_1E_653B::
	sprite_frame 4
	sprite_oam -4, -2, $1C, 1
	sprite_oam 12, -2, $1C, OAMF_YFLIP | 1
	sprite_oam -4, 62, $1C, OAMF_XFLIP | 1
	sprite_oam 12, 62, $1C, OAMF_YFLIP | OAMF_XFLIP | 1

; ---- data $654C-$6551 (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:10 1:10

TopMenu_Anim5Script:: ; 1E:654C
Data_1E_654C::
	sprite_anim 2
	sprite_anim_step 0, 10
	sprite_anim_step 1, 10

; ---- data $6551-$6554 (3 bytes) [HYPOTHESIS] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4; not named by a known object-table row: found because the gap between neighbours equals exactly this script (+ pad)

Data_1E_6551:: ; 1E:6551
	db $01, $00, $04

; ---- data $6554-$6559 (5 bytes) [HYPOTHESIS] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:20 1:20; not named by a known object-table row: found because the gap between neighbours equals exactly this script (+ pad)

Data_1E_6554:: ; 1E:6554
	db $02, $00, $14, $01, $14

; ---- words $6559-$655B (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

TopMenu_Anim6Frames:: ; 1E:6559
Table_1E_6559::
	sprite_frame_table TopMenu_Anim6Frame0

; ---- data $655B-$656C (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

TopMenu_Anim6Frame0:: ; 1E:655B
Data_1E_655B::
	sprite_frame 4
	sprite_oam 8, 0, $40, 4
	sprite_oam 8, 8, $42, 4
	sprite_oam 0, 0, $60, 4
	sprite_oam 0, 8, $62, 4

; ---- data $656C-$656F (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

TopMenu_Anim6Script:: ; 1E:656C
Data_1E_656C::
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $656F-$658B (28 bytes) [PROBABLE] sprite object table: 4-byte entries (frame-table ptr, animation-script ptr) indexed by B&7F, the layout read by init_object_from_table 00:0A82/00:0AB8; entry 0 is unused (zero); base $656F is passed as de with a=$1E at call sites listed in analysis/gfx_candidates.tsv (object-table); entries 0000/0000 6320/63A7 63BA/63F8 63FD/6436 6450/6513 6526/654C 6559/656C

TopMenu_ObjTable:: ; 1E:656F
Table_1E_656F::
	sprite_object_entry 0, 0 ; entry 0
	sprite_object_entry TopMenu_Anim1Frames, TopMenu_Anim1Script ; entry 1
	sprite_object_entry TopMenu_Anim2Frames, TopMenu_Anim2Script ; entry 2
	sprite_object_entry TopMenu_Anim3Frames, TopMenu_Anim3Script ; entry 3
	sprite_object_entry TopMenu_Anim4Frames, TopMenu_Anim4Script ; entry 4
	sprite_object_entry TopMenu_Anim5Frames, TopMenu_Anim5Script ; entry 5
	sprite_object_entry TopMenu_Anim6Frames, TopMenu_Anim6Script ; entry 6
