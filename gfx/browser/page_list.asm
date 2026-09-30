; gfx/browser/page_list.asm
; bank 24, $5400-$6BF0 (6128 bytes); pinned by layout.link
; page list tiles, tilemaps, palettes, object tables

SECTION "gfx/browser/page_list", ROMX

; ---- gfx $5400-$55D0 (464 bytes) [PROBABLE] 2bpp tiles by coherence: 29 non-blank tiles, mean adjacent-pixel similarity h=0.67 v=0.50 (random data ~0.25-0.35); part of the 1024-byte block 5400-5800 uploaded by Function_00_0749 (general HDMA start: hl=$5400 a=$24 c=$40 de=$9301) at 24:432C; call site never executed in a trace

PageList_Tiles_5400:: ; 24:5400
Tiles_24_5400::
	INCBIN "gfx/browser/page_list/page_list_tiles_5400.2bpp"

; ---- gfx $55D0-$5810 (576 bytes) [PROBABLE] tiles-2bpp: heuristic: 33 coherent tiles (hsim2=0.738 vsim2=0.702, 1 blank) parity 0

Data_24_55D0:: ; 24:55D0
	INCBIN "gfx/browser/page_list/tiles_55d0.2bpp"

PageList_Tiles_5800:: ; 24:5800
	INCBIN "gfx/browser/page_list/page_list_tiles_5800.2bpp"

; ---- gfx $5810-$58B0 (160 bytes) [PROBABLE] 2bpp tiles by coherence: 9 non-blank tiles, mean adjacent-pixel similarity h=0.72 v=0.79 (random data ~0.25-0.35); part of the 256-byte block 5800-5900 uploaded by Function_00_0749 (hl=$5800 a=$24 c=$10 de=$9701) at 24:4341; call site never executed

Tiles_24_5810:: ; 24:5810
	INCBIN "gfx/browser/page_list/tiles_5810.2bpp"

; ---- zero $58B0-$5900 (80 bytes) [HYPOTHESIS] padding? run of 80 x $00 in unclassified bytes
	ds $50, $00

; ---- data $5900-$5BD0 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 24:43A7: hl=$5900 a=$24 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

PageList_Tilemap_5900:: ; 24:5900
Data_24_5900::
	INCBIN "gfx/browser/page_list/page_list_tilemap_5900.tilemap"
	INCBIN "gfx/browser/page_list/page_list_tilemap_5900.attrmap"

; ---- data $5BD0-$5EA0 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 24:43C9: hl=$5BD0 a=$24 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

PageList_Tilemap_5BD0:: ; 24:5BD0
Data_24_5BD0::
	INCBIN "gfx/browser/page_list/page_list_tilemap_5bd0.tilemap"
	INCBIN "gfx/browser/page_list/page_list_tilemap_5bd0.attrmap"

; ---- data $5EA0-$5EE0 (64 bytes) [PROBABLE] 64-byte RGB555 palette block copied by Function_4F_4000 (-> 00:050C copy; hl=$5EA0 a=$24 bc=$0040 de=$D800, WRAM7 BG palette buffer) at 24:4393; call site never executed; replaces the mapper palette guess 5EC6-5EDE

PageList_BgPalette:: ; 24:5EA0
Palette_24_5EA0::
	INCLUDE "gfx/browser/page_list/page_list_bg_palette.pal"

; ---- gfx $5EE0-$5EF1 (17 bytes) [PROBABLE] 2bpp tiles (too few non-blank tiles to score); first bytes of the 1024-byte block 5EE0-62E0 uploaded by Function_00_0749 (hl=$5EE0 a=$24 c=$40 de=$8000) at 24:4356; call site never executed

PageList_Tiles_5EE0:: ; 24:5EE0
Tiles_24_5EE0::
	db $FF, $FF, $FF, $8A, $FF, $FF, $FF, $8B, $FF, $FA, $FB, $F7, $F5, $8D, $F8, $F8
	db $BE

; ---- gfx $5EF1-$6301 (1040 bytes) [PROBABLE] tiles-2bpp: heuristic: 45 coherent tiles (hsim2=0.655 vsim2=0.638, 7 blank) parity 1

Data_24_5EF1:: ; 24:5EF1
	INCBIN "gfx/browser/page_list/tiles_5ef1.2bpp"
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

PageList_Tiles_62E0:: ; 24:62E0
	db $5A, $7F, $52, $77, $52, $77, $52, $77, $5A, $7F, $26, $3F, $1A, $1B, $02, $03
	db $80, $FF, $80, $FF, $80, $FF, $80, $FF, $80, $FF, $B0, $FF, $B0, $DF, $80, $FF
	db $50

; ---- gfx $6301-$63D0 (207 bytes) [PROBABLE] 2bpp tiles by coherence: 12 non-blank tiles, mean adjacent-pixel similarity h=0.49 v=0.75 (random data ~0.25-0.35); inside block 62E0-64E0 uploaded by Function_00_0749 (hl=$62E0 a=$24 c=$20 de=$8400) at 24:436B; call site never executed

Tiles_24_6301:: ; 24:6301
	INCBIN "gfx/browser/page_list/tiles_6301.2bpp"
	db $FA, $06, $FA, $06, $FA, $06, $FA, $07, $FB, $05, $FB, $07, $FB, $06, $FA

; ---- zero $63D0-$63E0 (16 bytes) [HYPOTHESIS] padding? run of 16 x $00 in unclassified bytes
	ds $10, $00

; ---- gfx $63E0-$64E0 (256 bytes) [PROBABLE] 2bpp tiles by coherence: 15 non-blank tiles, mean adjacent-pixel similarity h=0.61 v=0.72 (random data ~0.25-0.35); inside block 62E0-64E0 uploaded by Function_00_0749 (hl=$62E0 a=$24 c=$20 de=$8400) at 24:436B; call site never executed

Tiles_24_63E0:: ; 24:63E0
	INCBIN "gfx/browser/page_list/tiles_63e0.2bpp"

; ---- data $64E0-$6520 (64 bytes) [PROBABLE] 64-byte RGB555 palette block copied by Function_4F_4000 (hl=$64E0 a=$24 bc=$0040 de=$D840, WRAM7 OBJ palette buffer) at 24:437F; call site never executed; replaces the mapper guess 64DC-65EC (136 words) which swallowed the sprite tables below

PageList_ObjPalette:: ; 24:64E0
Palette_24_64E0::
	INCLUDE "gfx/browser/page_list/page_list_obj_palette.pal"

; ---- data $6520-$6530 (16 bytes) [HYPOTHESIS] 16 bytes = 4 x the pair $6E50/$6E76; same 4x-repeated row shape as the object-table rows at 6530+, but the targets fall inside tile data (6BF0-6FF0) so it is not one of them; meaning unknown

Data_24_6520:: ; 24:6520
	db $50, $6E, $76, $6E, $50, $6E, $76, $6E, $50, $6E, $76, $6E, $50, $6E, $76, $6E

; ---- words $6530-$65C0 (144 bytes) [PROBABLE] sprite object table: 4-byte entries (frame-table ptr, animation-script ptr) indexed by B&7F, the layout read by init_object_from_table 00:0A82/00:0AB8; rows of 16 bytes = the same entry repeated 4 times; base $6530 is passed as de with a=$24 at call sites listed in analysis/gfx_candidates.tsv (object-table); entries 65C0/667A 65C0/667A 65C0/667A 65C0/667A

PageList_ObjTable:: ; 24:6530
Table_24_6530::
	dw PageList_Anim0Frames, PageList_Anim0Script, PageList_Anim0Frames, PageList_Anim0Script, PageList_Anim0Frames, PageList_Anim0Script, PageList_Anim0Frames, PageList_Anim0Script
	dw PageList_Anim4Frames, PageList_Anim4Script, PageList_Anim4Frames, PageList_Anim4Script, PageList_Anim4Frames, PageList_Anim4Script, PageList_Anim4Frames, PageList_Anim4Script
	dw PageList_Anim8Frames, PageList_Anim8Script, PageList_Anim8Frames, PageList_Anim8Script, PageList_Anim8Frames, PageList_Anim8Script, PageList_Anim8Frames, PageList_Anim8Script
	dw PageList_Anim12Frames, PageList_Anim12Script, PageList_Anim12Frames, PageList_Anim12Script, PageList_Anim12Frames, PageList_Anim12Script, PageList_Anim12Frames, PageList_Anim12Script
	dw PageList_Anim16Frames, PageList_Anim16Script, PageList_Anim16Frames, PageList_Anim16Script, PageList_Anim16Frames, PageList_Anim16Script, PageList_Anim16Frames, PageList_Anim16Script
	dw PageList_Anim20Frames, PageList_Anim20Script, PageList_Anim20Frames, PageList_Anim20Script, PageList_Anim20Frames, PageList_Anim20Script, PageList_Anim20Frames, PageList_Anim20Script
	dw PageList_Anim24Frames, PageList_Anim24Script, PageList_Anim24Frames, PageList_Anim24Script, PageList_Anim24Frames, PageList_Anim24Script, PageList_Anim24Frames, PageList_Anim24Script
	dw PageList_Anim28Frames, PageList_Anim28Script, PageList_Anim28Frames, PageList_Anim28Script, PageList_Anim28Frames, PageList_Anim28Script, PageList_Anim28Frames, PageList_Anim28Script
	dw PageList_Anim32Frames, PageList_Anim32Script, PageList_Anim32Frames, PageList_Anim32Script, PageList_Anim32Frames, PageList_Anim32Script, PageList_Anim32Frames, PageList_Anim32Script

; ---- words $65C0-$65CC (12 bytes) [PROBABLE] sprite frame table: 6 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

PageList_Anim0Frames:: ; 24:65C0
Table_24_65C0::
	dw PageList_Anim0Frame0, PageList_Anim0Frame1, PageList_Anim0Frame2, PageList_Anim0Frame3, PageList_Anim0Frame4, PageList_Anim0Frame5

; ---- data $65CC-$65D9 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim0Frame0:: ; 24:65CC
Data_24_65CC::
	db $03, $00, $00, $33, $01, $00, $08, $34, $01, $00, $10, $35, $01

; ---- data $65D9-$65F2 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim0Frame1:: ; 24:65D9
Data_24_65D9::
	db $06, $F8, $00, $43, $01, $F8, $08, $44, $01, $F8, $10, $45, $01, $00, $00, $53
	db $01, $00, $08, $54, $01, $00, $10, $55, $01

; ---- data $65F2-$6617 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim0Frame2:: ; 24:65F2
Data_24_65F2::
	db $09, $F0, $00, $36, $01, $F0, $08, $37, $01, $F0, $10, $38, $01, $F8, $00, $46
	db $01, $F8, $08, $47, $01, $F8, $10, $48, $01, $00, $00, $56, $01, $00, $08, $57
	db $01, $00, $10, $58, $01

; ---- data $6617-$663C (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim0Frame3:: ; 24:6617
Data_24_6617::
	db $09, $F0, $00, $39, $01, $F0, $08, $3A, $01, $F0, $10, $3B, $01, $F8, $00, $49
	db $01, $F8, $08, $4A, $01, $F8, $10, $4B, $01, $00, $00, $59, $01, $00, $08, $5A
	db $01, $00, $10, $5B, $01

; ---- data $663C-$6661 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim0Frame4:: ; 24:663C
Data_24_663C::
	db $09, $F0, $00, $3C, $01, $F0, $08, $3D, $01, $F0, $10, $3E, $01, $F8, $00, $4C
	db $01, $F8, $08, $4D, $01, $F8, $10, $4E, $01, $00, $00, $5C, $01, $00, $08, $5D
	db $01, $00, $10, $5E, $01

; ---- data $6661-$667A (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim0Frame5:: ; 24:6661
Data_24_6661::
	db $06, $F8, $00, $43, $01, $F8, $08, $44, $01, $F8, $10, $45, $01, $00, $00, $53
	db $01, $00, $08, $54, $01, $00, $10, $55, $01

; ---- data $667A-$6685 (11 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 5 step(s), (frame,delay) pairs: 0:5 1:2 2:4 3:5 4:5

PageList_Anim0Script:: ; 24:667A
Data_24_667A::
	db $05, $00, $05, $01, $02, $02, $04, $03, $05, $04, $05

; ---- zero $6685-$6686 (1 bytes) [PROBABLE] alignment padding byte(s) between sprite script and the following word table (frame tables sit at even addresses)
	ds $1, $00

; ---- words $6686-$6688 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

PageList_Anim8Frames:: ; 24:6686
Table_24_6686::
	dw PageList_Anim8Frame0

; ---- data $6688-$6695 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim8Frame0:: ; 24:6688
Data_24_6688::
	db $03, $00, $00, $33, $01, $00, $08, $34, $01, $00, $10, $35, $01

; ---- data $6695-$6698 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

PageList_Anim8Script:: ; 24:6695
Data_24_6695::
	db $01, $00, $04

; ---- words $6698-$66A4 (12 bytes) [PROBABLE] sprite frame table: 6 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

PageList_Anim4Frames:: ; 24:6698
Table_24_6698::
	dw PageList_Anim4Frame0, PageList_Anim4Frame1, PageList_Anim4Frame2, PageList_Anim4Frame3, PageList_Anim4Frame4, PageList_Anim4Frame5

; ---- data $66A4-$66B1 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim4Frame0:: ; 24:66A4
Data_24_66A4::
	db $03, $00, $00, $06, $00, $00, $08, $07, $00, $00, $10, $08, $00

; ---- data $66B1-$66CA (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim4Frame1:: ; 24:66B1
Data_24_66B1::
	db $06, $F8, $00, $16, $00, $F8, $08, $17, $00, $F8, $10, $18, $00, $00, $00, $26
	db $00, $00, $08, $27, $00, $00, $10, $28, $00

; ---- data $66CA-$66EF (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim4Frame2:: ; 24:66CA
Data_24_66CA::
	db $09, $F0, $00, $09, $00, $F0, $08, $0A, $00, $F0, $10, $0B, $00, $F8, $00, $19
	db $00, $F8, $08, $1A, $00, $F8, $10, $1B, $00, $00, $00, $29, $00, $00, $08, $2A
	db $00, $00, $10, $2B, $00

; ---- data $66EF-$6714 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim4Frame3:: ; 24:66EF
Data_24_66EF::
	db $09, $F0, $00, $0C, $00, $F0, $08, $0D, $00, $F0, $10, $0E, $00, $F8, $00, $1C
	db $00, $F8, $08, $1D, $00, $F8, $10, $1E, $00, $00, $00, $2C, $00, $00, $08, $2D
	db $00, $00, $10, $2E, $00

; ---- data $6714-$6739 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim4Frame4:: ; 24:6714
Data_24_6714::
	db $09, $F0, $00, $30, $00, $F0, $08, $31, $00, $F0, $10, $32, $00, $F8, $00, $40
	db $00, $F8, $08, $41, $00, $F8, $10, $42, $00, $00, $00, $50, $00, $00, $08, $51
	db $00, $00, $10, $52, $00

; ---- data $6739-$6752 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim4Frame5:: ; 24:6739
Data_24_6739::
	db $06, $F8, $00, $16, $00, $F8, $08, $17, $00, $F8, $10, $18, $00, $00, $00, $26
	db $00, $00, $08, $27, $00, $00, $10, $28, $00

; ---- data $6752-$675D (11 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 5 step(s), (frame,delay) pairs: 0:5 1:3 2:5 3:3 4:5

PageList_Anim4Script:: ; 24:6752
Data_24_6752::
	db $05, $00, $05, $01, $03, $02, $05, $03, $03, $04, $05

; ---- zero $675D-$675E (1 bytes) [PROBABLE] alignment padding byte(s) between sprite script and the following word table (frame tables sit at even addresses)
	ds $1, $00

; ---- words $675E-$6760 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

PageList_Anim12Frames:: ; 24:675E
Table_24_675E::
	dw PageList_Anim12Frame0

; ---- data $6760-$676D (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim12Frame0:: ; 24:6760
Data_24_6760::
	db $03, $00, $00, $06, $00, $00, $08, $07, $00, $00, $10, $08, $00

; ---- data $676D-$6770 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

PageList_Anim12Script:: ; 24:676D
Data_24_676D::
	db $01, $00, $04

; ---- words $6770-$677E (14 bytes) [PROBABLE] sprite frame table: 7 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

PageList_Anim28Frames:: ; 24:6770
Table_24_6770::
	dw PageList_Anim28Frame0, PageList_Anim28Frame1, PageList_Anim28Frame2, PageList_Anim28Frame3, PageList_Anim28Frame4, PageList_Anim28Frame5, PageList_Anim28Frame6

; ---- data $677E-$67A3 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim28Frame0:: ; 24:677E
Data_24_677E::
	db $09, $F0, $00, $30, $00, $F0, $08, $31, $00, $F0, $10, $32, $00, $F8, $00, $40
	db $00, $F8, $08, $41, $00, $F8, $10, $42, $00, $00, $00, $50, $00, $00, $08, $51
	db $00, $00, $10, $52, $00

; ---- data $67A3-$67C8 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim28Frame1:: ; 24:67A3
Data_24_67A3::
	db $09, $F0, $00, $09, $00, $F0, $08, $0A, $00, $F0, $10, $0B, $00, $F8, $00, $19
	db $00, $F8, $08, $1A, $00, $F8, $10, $1B, $00, $00, $00, $29, $00, $00, $08, $2A
	db $00, $00, $10, $2B, $00

; ---- data $67C8-$67D5 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim28Frame2:: ; 24:67C8
Data_24_67C8::
	db $03, $00, $00, $33, $01, $00, $08, $34, $01, $00, $10, $35, $01

; ---- data $67D5-$67EE (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim28Frame3:: ; 24:67D5
Data_24_67D5::
	db $06, $F8, $00, $43, $01, $F8, $08, $44, $01, $F8, $10, $45, $01, $00, $00, $53
	db $01, $00, $08, $54, $01, $00, $10, $55, $01

; ---- data $67EE-$6813 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim28Frame4:: ; 24:67EE
Data_24_67EE::
	db $09, $F0, $00, $36, $01, $F0, $08, $37, $01, $F0, $10, $38, $01, $F8, $00, $46
	db $01, $F8, $08, $47, $01, $F8, $10, $48, $01, $00, $00, $56, $01, $00, $08, $57
	db $01, $00, $10, $58, $01

; ---- data $6813-$6838 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim28Frame5:: ; 24:6813
Data_24_6813::
	db $09, $F0, $00, $39, $01, $F0, $08, $3A, $01, $F0, $10, $3B, $01, $F8, $00, $49
	db $01, $F8, $08, $4A, $01, $F8, $10, $4B, $01, $00, $00, $59, $01, $00, $08, $5A
	db $01, $00, $10, $5B, $01

; ---- data $6838-$685D (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim28Frame6:: ; 24:6838
Data_24_6838::
	db $09, $F0, $00, $3C, $01, $F0, $08, $3D, $01, $F0, $10, $3E, $01, $F8, $00, $4C
	db $01, $F8, $08, $4D, $01, $F8, $10, $4E, $01, $00, $00, $5C, $01, $00, $08, $5D
	db $01, $00, $10, $5E, $01

; ---- data $685D-$686C (15 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 7 step(s), (frame,delay) pairs: 0:5 1:8 2:10 3:8 4:8 5:8 6:5

PageList_Anim28Script:: ; 24:685D
Data_24_685D::
	db $07, $00, $05, $01, $08, $02, $0A, $03, $08, $04, $08, $05, $08, $06, $05

; ---- zero $686C-$686D (1 bytes) [PROBABLE] alignment padding byte(s) between sprite script and the following word table (frame tables sit at even addresses)
	ds $1, $00

; ---- words $686D-$687D (16 bytes) [PROBABLE] sprite frame table: 8 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

PageList_Anim32Frames:: ; 24:686D
Table_24_686D::
	dw PageList_Anim32Frame0, PageList_Anim32Frame1, PageList_Anim32Frame2, PageList_Anim32Frame3, PageList_Anim32Frame4, PageList_Anim32Frame5, PageList_Anim32Frame6, PageList_Anim32Frame7

; ---- data $687D-$68A2 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim32Frame0:: ; 24:687D
Data_24_687D::
	db $09, $F0, $00, $3C, $01, $F0, $08, $3D, $01, $F0, $10, $3E, $01, $F8, $00, $4C
	db $01, $F8, $08, $4D, $01, $F8, $10, $4E, $01, $00, $00, $5C, $01, $00, $08, $5D
	db $01, $00, $10, $5E, $01

; ---- data $68A2-$68C7 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim32Frame1:: ; 24:68A2
Data_24_68A2::
	db $09, $F0, $00, $39, $01, $F0, $08, $3A, $01, $F0, $10, $3B, $01, $F8, $00, $49
	db $01, $F8, $08, $4A, $01, $F8, $10, $4B, $01, $00, $00, $59, $01, $00, $08, $5A
	db $01, $00, $10, $5B, $01

; ---- data $68C7-$68E0 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim32Frame2:: ; 24:68C7
Data_24_68C7::
	db $06, $F8, $00, $43, $01, $F8, $08, $44, $01, $F8, $10, $45, $01, $00, $00, $53
	db $01, $00, $08, $54, $01, $00, $10, $55, $01

; ---- data $68E0-$68ED (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim32Frame3:: ; 24:68E0
Data_24_68E0::
	db $03, $00, $00, $06, $00, $00, $08, $07, $00, $00, $10, $08, $00

; ---- data $68ED-$6906 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim32Frame4:: ; 24:68ED
Data_24_68ED::
	db $06, $F8, $00, $16, $00, $F8, $08, $17, $00, $F8, $10, $18, $00, $00, $00, $26
	db $00, $00, $08, $27, $00, $00, $10, $28, $00

; ---- data $6906-$692B (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim32Frame5:: ; 24:6906
Data_24_6906::
	db $09, $F0, $00, $09, $00, $F0, $08, $0A, $00, $F0, $10, $0B, $00, $F8, $00, $19
	db $00, $F8, $08, $1A, $00, $F8, $10, $1B, $00, $00, $00, $29, $00, $00, $08, $2A
	db $00, $00, $10, $2B, $00

; ---- data $692B-$6950 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim32Frame6:: ; 24:692B
Data_24_692B::
	db $09, $F0, $00, $0C, $00, $F0, $08, $0D, $00, $F0, $10, $0E, $00, $F8, $00, $1C
	db $00, $F8, $08, $1D, $00, $F8, $10, $1E, $00, $00, $00, $2C, $00, $00, $08, $2D
	db $00, $00, $10, $2E, $00

; ---- data $6950-$6975 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim32Frame7:: ; 24:6950
Data_24_6950::
	db $09, $F0, $00, $30, $00, $F0, $08, $31, $00, $F0, $10, $32, $00, $F8, $00, $40
	db $00, $F8, $08, $41, $00, $F8, $10, $42, $00, $00, $00, $50, $00, $00, $08, $51
	db $00, $00, $10, $52, $00

; ---- data $6975-$6986 (17 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 8 step(s), (frame,delay) pairs: 0:5 1:8 2:8 3:10 4:8 5:8 6:8 7:5

PageList_Anim32Script:: ; 24:6975
Data_24_6975::
	db $08, $00, $05, $01, $08, $02, $08, $03, $0A, $04, $08, $05, $08, $06, $08, $07
	db $05

; ---- data $6986-$6995 (15 bytes) [HYPOTHESIS] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 7 step(s), (frame,delay) pairs: 0:48 1:5 2:5 3:5 4:5 5:5 6:48; not named by a known object-table row: found because the gap between neighbours equals exactly this script (+ pad)

Data_24_6986:: ; 24:6986
	db $07, $00, $30, $01, $05, $02, $05, $03, $05, $04, $05, $05, $05, $06, $30

; ---- words $6995-$69A1 (12 bytes) [PROBABLE] sprite frame table: 6 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_6995:: ; 24:6995
	dw Data_24_69A1, Data_24_69AE, Data_24_69C7, Data_24_69EC, Data_24_6A11, Data_24_6A36

; ---- data $69A1-$69AE (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Data_24_69A1:: ; 24:69A1
	db $03, $00, $00, $33, $01, $00, $08, $34, $01, $00, $10, $35, $01

; ---- data $69AE-$69C7 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_24_69AE:: ; 24:69AE
	db $06, $F8, $00, $43, $01, $F8, $08, $44, $01, $F8, $10, $45, $01, $00, $00, $53
	db $01, $00, $08, $54, $01, $00, $10, $55, $01

; ---- data $69C7-$69EC (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_69C7:: ; 24:69C7
	db $09, $F0, $00, $36, $01, $F0, $08, $37, $01, $F0, $10, $38, $01, $F8, $00, $46
	db $01, $F8, $08, $47, $01, $F8, $10, $48, $01, $00, $00, $56, $01, $00, $08, $57
	db $01, $00, $10, $58, $01

; ---- data $69EC-$6A11 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_69EC:: ; 24:69EC
	db $09, $F0, $00, $39, $01, $F0, $08, $3A, $01, $F0, $10, $3B, $01, $F8, $00, $49
	db $01, $F8, $08, $4A, $01, $F8, $10, $4B, $01, $00, $00, $59, $01, $00, $08, $5A
	db $01, $00, $10, $5B, $01

; ---- data $6A11-$6A36 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_6A11:: ; 24:6A11
	db $09, $F0, $00, $3C, $01, $F0, $08, $3D, $01, $F0, $10, $3E, $01, $F8, $00, $4C
	db $01, $F8, $08, $4D, $01, $F8, $10, $4E, $01, $00, $00, $5C, $01, $00, $08, $5D
	db $01, $00, $10, $5E, $01

; ---- data $6A36-$6A4F (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_24_6A36:: ; 24:6A36
	db $06, $F8, $00, $43, $01, $F8, $08, $44, $01, $F8, $10, $45, $01, $00, $00, $53
	db $01, $00, $08, $54, $01, $00, $10, $55, $01

; ---- data $6A4F-$6A56 (7 bytes) [HYPOTHESIS] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 3 step(s), (frame,delay) pairs: 4:5 1:5 0:5; not named by a known object-table row: found because the gap between neighbours equals exactly this script (+ pad)

Data_24_6A4F:: ; 24:6A4F
	db $03, $04, $05, $01, $05, $00, $05

; ---- zero $6A56-$6A57 (1 bytes) [PROBABLE] alignment padding byte(s) between sprite script and the following word table (frame tables sit at even addresses)
	ds $1, $00

; ---- words $6A57-$6A63 (12 bytes) [PROBABLE] sprite frame table: 6 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_6A57:: ; 24:6A57
	dw Data_24_6A63, Data_24_6A70, Data_24_6A89, Data_24_6AAE, Data_24_6AD3, Data_24_6AF8

; ---- data $6A63-$6A70 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Data_24_6A63:: ; 24:6A63
	db $03, $00, $00, $06, $00, $00, $08, $07, $00, $00, $10, $08, $00

; ---- data $6A70-$6A89 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_24_6A70:: ; 24:6A70
	db $06, $F8, $00, $16, $00, $F8, $08, $17, $00, $F8, $10, $18, $00, $00, $00, $26
	db $00, $00, $08, $27, $00, $00, $10, $28, $00

; ---- data $6A89-$6AAE (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_6A89:: ; 24:6A89
	db $09, $F0, $00, $09, $00, $F0, $08, $0A, $00, $F0, $10, $0B, $00, $F8, $00, $19
	db $00, $F8, $08, $1A, $00, $F8, $10, $1B, $00, $00, $00, $29, $00, $00, $08, $2A
	db $00, $00, $10, $2B, $00

; ---- data $6AAE-$6AD3 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_6AAE:: ; 24:6AAE
	db $09, $F0, $00, $0C, $00, $F0, $08, $0D, $00, $F0, $10, $0E, $00, $F8, $00, $1C
	db $00, $F8, $08, $1D, $00, $F8, $10, $1E, $00, $00, $00, $2C, $00, $00, $08, $2D
	db $00, $00, $10, $2E, $00

; ---- data $6AD3-$6AF8 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Data_24_6AD3:: ; 24:6AD3
	db $09, $F0, $00, $30, $00, $F0, $08, $31, $00, $F0, $10, $32, $00, $F8, $00, $40
	db $00, $F8, $08, $41, $00, $F8, $10, $42, $00, $00, $00, $50, $00, $00, $08, $51
	db $00, $00, $10, $52, $00

; ---- data $6AF8-$6B11 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Data_24_6AF8:: ; 24:6AF8
	db $06, $F8, $00, $16, $00, $F8, $08, $17, $00, $F8, $10, $18, $00, $00, $00, $26
	db $00, $00, $08, $27, $00, $00, $10, $28, $00

; ---- data $6B11-$6B18 (7 bytes) [HYPOTHESIS] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 3 step(s), (frame,delay) pairs: 4:5 5:5 0:5; not named by a known object-table row: found because the gap between neighbours equals exactly this script (+ pad)

Data_24_6B11:: ; 24:6B11
	db $03, $04, $05, $05, $05, $00, $05

; ---- zero $6B18-$6B19 (1 bytes) [PROBABLE] alignment padding byte(s) between sprite script and the following word table (frame tables sit at even addresses)
	ds $1, $00

; ---- words $6B19-$6B1D (4 bytes) [PROBABLE] sprite frame table: 2 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

PageList_Anim16Frames:: ; 24:6B19
Table_24_6B19::
	dw PageList_Anim16Frame0, PageList_Anim16Frame1

; ---- data $6B1D-$6B3A (29 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 7 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim16Frame0:: ; 24:6B1D
Data_24_6B1D::
	db $07, $0B, $00, $03, $44, $0B, $0C, $03, $64, $FF, $00, $03, $04, $FF, $0C, $03
	db $24, $F6, $FF, $00, $04, $F6, $07, $01, $04, $F6, $0F, $02, $04

; ---- data $6B3A-$6B57 (29 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 7 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim16Frame1:: ; 24:6B3A
Data_24_6B3A::
	db $07, $0C, $FF, $03, $44, $0C, $0D, $03, $64, $FE, $FF, $03, $04, $FE, $0D, $03
	db $24, $F6, $FF, $00, $04, $F6, $07, $01, $04, $F6, $0F, $02, $04

; ---- data $6B57-$6B5C (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:46 1:8

PageList_Anim16Script:: ; 24:6B57
Data_24_6B57::
	db $02, $00, $2E, $01, $08

; ---- words $6B5C-$6B60 (4 bytes) [PROBABLE] sprite frame table: 2 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

PageList_Anim20Frames:: ; 24:6B5C
Table_24_6B5C::
	dw PageList_Anim20Frame0, PageList_Anim20Frame1

; ---- data $6B60-$6B7D (29 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 7 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim20Frame0:: ; 24:6B60
Data_24_6B60::
	db $07, $0B, $00, $03, $44, $0B, $0C, $03, $64, $FF, $00, $03, $04, $FF, $0C, $03
	db $24, $F6, $FE, $10, $04, $F6, $06, $11, $04, $F6, $0E, $12, $04

; ---- data $6B7D-$6B9A (29 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 7 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim20Frame1:: ; 24:6B7D
Data_24_6B7D::
	db $07, $0C, $FF, $03, $44, $0C, $0D, $03, $64, $FE, $FF, $03, $04, $FE, $0D, $03
	db $24, $F6, $FE, $10, $04, $F6, $06, $11, $04, $F6, $0E, $12, $04

; ---- data $6B9A-$6B9F (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:46 1:8

PageList_Anim20Script:: ; 24:6B9A
Data_24_6B9A::
	db $02, $00, $2E, $01, $08

; ---- words $6B9F-$6BA3 (4 bytes) [PROBABLE] sprite frame table: 2 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

PageList_Anim24Frames:: ; 24:6B9F
Table_24_6B9F::
	dw PageList_Anim24Frame0, PageList_Anim24Frame1

; ---- data $6BA3-$6BC0 (29 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 7 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim24Frame0:: ; 24:6BA3
Data_24_6BA3::
	db $07, $0B, $00, $03, $44, $0B, $0C, $03, $64, $FF, $00, $03, $04, $FF, $0C, $03
	db $24, $F6, $FE, $20, $04, $F6, $06, $21, $04, $F6, $0E, $22, $04

; ---- data $6BC0-$6BDD (29 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 7 piece(s); length tiles exactly against the frame-table pointers

PageList_Anim24Frame1:: ; 24:6BC0
Data_24_6BC0::
	db $07, $0C, $FF, $03, $44, $0C, $0D, $03, $64, $FE, $FF, $03, $04, $FE, $0D, $03
	db $24, $F6, $FE, $20, $04, $F6, $06, $21, $04, $F6, $0E, $22, $04

; ---- data $6BDD-$6BE2 (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:46 1:8

PageList_Anim24Script:: ; 24:6BDD
Data_24_6BDD::
	db $02, $00, $2E, $01, $08

; ---- zero $6BE2-$6BF0 (14 bytes) [PROBABLE] 0x00 padding after the last sprite script of the 6530 block, before the tile block at 6BF0
	ds $E, $00
