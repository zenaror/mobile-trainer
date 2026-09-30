; gfx/mail/comm_result.asm
; bank 24, $6BF0-$7D48 (4440 bytes); pinned by layout.link
; tiles/tilemap/palettes/objects of the communication result and server status screens (loaded by bank 29)

SECTION "gfx/mail/comm_result", ROMX

; ---- gfx $6BF0-$6FF0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 29:40D3: hl=$6BF0 a=$24 c=$40 de=$8801 (dest VRAM $8800, vbank=1)

MailResult_Tiles_6BF0:: ; 24:6BF0
Data_24_6BF0::
	INCBIN "gfx/mail/comm_result/mail_result_tiles_6bf0.2bpp"

; ---- gfx $6FF0-$73F0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 29:40E5: hl=$6FF0 a=$24 c=$40 de=$8C01 (dest VRAM $8C00, vbank=1)

MailResult_Tiles_6FF0:: ; 24:6FF0
Data_24_6FF0::
	INCBIN "gfx/mail/comm_result/mail_result_tiles_6ff0.2bpp"

; ---- gfx $73F0-$7490 (160 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 29:40F7: hl=$73F0 a=$24 c=$0A de=$9001 (dest VRAM $9000, vbank=1)

MailResult_Tiles_73F0:: ; 24:73F0
Data_24_73F0::
	INCBIN "gfx/mail/comm_result/mail_result_tiles_73f0.2bpp"

; ---- gfx $7490-$7790 (768 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 29:4109: hl=$7490 a=$24 c=$30 de=$8000 (dest VRAM $8000, vbank=0)

MailResult_Tiles_7490:: ; 24:7490
Data_24_7490::
	INCBIN "gfx/mail/comm_result/mail_result_tiles_7490.2bpp"

; ---- data $7790-$7A60 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 29:411A: hl=$7790 a=$24 b=18 rows c=20 cols (tiles then attrs) de=$D000

MailResult_Tilemap:: ; 24:7790
Data_24_7790::
	INCBIN "gfx/mail/comm_result/mail_result_tilemap.tilemap"
	INCBIN "gfx/mail/comm_result/mail_result_tilemap.attrmap"

; ---- data $7A60-$7AA0 (64 bytes) [PROBABLE] 64-byte RGB555 palette block copied by Function_4F_4000 (hl=$7A60 a=$24 bc=$0040) from 29:40B0 / 29:40C1 / 29:463E; the call sites 29:40B0/29:40C1/29:463E ARE in analysis/coverage_union.tsv (executed; earlier 'never executed' used the old 18-scenario union) - status kept PROBABLE; the mapper palette guess 7A60-7C38 wrongly extended over the object tables

MailResult_BgPalette:: ; 24:7A60
Palette_24_7A60::
	INCLUDE "gfx/mail/comm_result/mail_result_bg_palette.pal"

; ---- data $7AA0-$7AE0 (64 bytes) [PROBABLE] 64-byte RGB555 palette block copied by Function_4F_4000 (hl=$7AA0 a=$24 bc=$0040) from 29:40B0 / 29:40C1 / 29:463E; the call sites 29:40B0/29:40C1/29:463E ARE in analysis/coverage_union.tsv (executed; earlier 'never executed' used the old 18-scenario union) - status kept PROBABLE; the mapper palette guess 7A60-7C38 wrongly extended over the object tables

MailResult_ObjPalette:: ; 24:7AA0
Palette_24_7AA0::
	INCLUDE "gfx/mail/comm_result/mail_result_obj_palette.pal"

; ---- data $7AE0-$7B20 (64 bytes) [PROBABLE] 64-byte RGB555 palette block copied by Function_4F_4000 (hl=$7AE0 a=$24 bc=$0040) from 29:40B0 / 29:40C1 / 29:463E; the call sites 29:40B0/29:40C1/29:463E ARE in analysis/coverage_union.tsv (executed) and traces/detail dataaccess records rom_read 24:7AE0-7B20 (this block read as data by executed code); earlier 'never executed' was stale - status kept PROBABLE; the mapper palette guess 7A60-7C38 wrongly extended over the object tables

MailServerStatus_BgPalette:: ; 24:7AE0
Palette_24_7AE0::
	INCLUDE "gfx/mail/comm_result/mail_server_status_bg_palette.pal"

; ---- words $7B20-$7C00 (224 bytes) [PROBABLE] sprite object table: 4-byte entries (frame-table ptr, animation-script ptr) indexed by B&7F, the layout read by init_object_from_table 00:0A82/00:0AB8; rows of 16 bytes = the same entry repeated 4 times; base $7B20 is passed as de with a=$24 at call sites listed in analysis/gfx_candidates.tsv (object-table); entries 7C00/7C33 7C00/7C33 7C00/7C33 7C00/7C33

MailResult_ObjTable:: ; 24:7B20
Table_24_7B20::
	dw MailResult_Anim0Frames, MailResult_Anim0Script, MailResult_Anim0Frames, MailResult_Anim0Script, MailResult_Anim0Frames, MailResult_Anim0Script, MailResult_Anim0Frames, MailResult_Anim0Script
	dw MailResult_Anim4Frames, MailResult_Anim4Script, MailResult_Anim4Frames, MailResult_Anim4Script, MailResult_Anim4Frames, MailResult_Anim4Script, MailResult_Anim4Frames, MailResult_Anim4Script
	dw MailResult_Anim8Frames, MailResult_Anim8Script, MailResult_Anim8Frames, MailResult_Anim8Script, MailResult_Anim8Frames, MailResult_Anim8Script, MailResult_Anim8Frames, MailResult_Anim8Script
	dw MailResult_Anim12Frames, MailResult_Anim12Script, MailResult_Anim12Frames, MailResult_Anim12Script, MailResult_Anim12Frames, MailResult_Anim12Script, MailResult_Anim12Frames, MailResult_Anim12Script
	dw MailResult_Anim16Frames, MailResult_Anim16Script, MailResult_Anim16Frames, MailResult_Anim16Script, MailResult_Anim16Frames, MailResult_Anim16Script, MailResult_Anim16Frames, MailResult_Anim16Script
	dw MailResult_Anim20Frames, MailResult_Anim20Script, MailResult_Anim20Frames, MailResult_Anim20Script, MailResult_Anim20Frames, MailResult_Anim20Script, MailResult_Anim20Frames, MailResult_Anim20Script
	dw MailResult_Anim24Frames, MailResult_Anim24Script, MailResult_Anim24Frames, MailResult_Anim24Script, MailResult_Anim24Frames, MailResult_Anim24Script, MailResult_Anim24Frames, MailResult_Anim24Script
	dw MailResult_Anim28Frames, MailResult_Anim28Script, MailResult_Anim28Frames, MailResult_Anim28Script, MailResult_Anim28Frames, MailResult_Anim28Script, MailResult_Anim28Frames, MailResult_Anim28Script
	dw MailResult_Anim32Frames, MailResult_Anim32Script, MailResult_Anim32Frames, MailResult_Anim32Script, MailResult_Anim32Frames, MailResult_Anim32Script, MailResult_Anim32Frames, MailResult_Anim32Script
	dw MailResult_Anim36Frames, MailResult_Anim36Script, MailResult_Anim36Frames, MailResult_Anim36Script, MailResult_Anim36Frames, MailResult_Anim36Script, MailResult_Anim36Frames, MailResult_Anim36Script
	dw MailResult_Anim40Frames, MailResult_Anim40Script, MailResult_Anim40Frames, MailResult_Anim40Script, MailResult_Anim40Frames, MailResult_Anim40Script, MailResult_Anim40Frames, MailResult_Anim40Script
	dw MailResult_Anim44Frames, MailResult_Anim44Script, MailResult_Anim44Frames, MailResult_Anim44Script, MailResult_Anim44Frames, MailResult_Anim44Script, MailResult_Anim44Frames, MailResult_Anim44Script
	dw MailResult_Anim48Frames, MailResult_Anim48Script, MailResult_Anim48Frames, MailResult_Anim48Script, MailResult_Anim48Frames, MailResult_Anim48Script, MailResult_Anim48Frames, MailResult_Anim48Script
	dw MailResult_Anim52Frames, MailResult_Anim52Script, MailResult_Anim52Frames, MailResult_Anim52Script, MailResult_Anim52Frames, MailResult_Anim52Script, MailResult_Anim52Frames, MailResult_Anim52Script

; ---- words $7C00-$7C02 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim0Frames:: ; 24:7C00
Table_24_7C00::
	dw MailResult_Anim0Frame0

; ---- data $7C02-$7C33 (49 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 12 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim0Frame0:: ; 24:7C02
Data_24_7C02::
	db $0C, $50, $38, $0A, $01, $50, $40, $0B, $01, $50, $48, $0C, $01, $50, $50, $0D
	db $01, $50, $58, $0E, $01, $50, $60, $0F, $01, $58, $38, $1A, $01, $58, $40, $1B
	db $01, $58, $48, $1C, $01, $58, $50, $1D, $01, $58, $58, $1E, $01, $58, $60, $1F
	db $01

; ---- data $7C33-$7C36 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim0Script:: ; 24:7C33
Data_24_7C33::
	db $01, $00, $04

; ---- words $7C36-$7C38 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim4Frames:: ; 24:7C36
Table_24_7C36::
	dw MailResult_Anim4Frame0

; ---- data $7C38-$7C85 (77 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 19 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim4Frame0:: ; 24:7C38
Data_24_7C38::
	db $13, $F0, $28, $20, $02, $F0, $30, $21, $02, $F0, $38, $22, $03, $F0, $40, $23
	db $03, $F8, $28, $24, $02, $F8, $30, $25, $02, $F8, $38, $26, $03, $F8, $40, $27
	db $03, $00, $28, $28, $02, $00, $30, $29, $02, $27, $28, $2A, $02, $27, $30, $2B
	db $02, $27, $38, $2C, $02, $27, $40, $2D, $02, $2F, $30, $2E, $02, $2F, $38, $2F
	db $02, $1F, $2B, $20, $03, $1F, $33, $21, $03, $1F, $3B, $22, $03

; ---- data $7C85-$7C88 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim4Script:: ; 24:7C85
Data_24_7C85::
	db $01, $00, $04

; ---- words $7C88-$7C8A (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim8Frames:: ; 24:7C88
Table_24_7C88::
	dw MailResult_Anim8Frame0

; ---- data $7C8A-$7C93 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim8Frame0:: ; 24:7C8A
Data_24_7C8A::
	db $02, $38, $E8, $01, $00, $40, $E8, $11, $00

; ---- data $7C93-$7C96 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim8Script:: ; 24:7C93
Data_24_7C93::
	db $01, $00, $04

; ---- words $7C96-$7C98 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim12Frames:: ; 24:7C96
Table_24_7C96::
	dw MailResult_Anim12Frame0

; ---- data $7C98-$7CA1 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim12Frame0:: ; 24:7C98
Data_24_7C98::
	db $02, $38, $E8, $02, $00, $40, $E8, $12, $00

; ---- data $7CA1-$7CA4 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim12Script:: ; 24:7CA1
Data_24_7CA1::
	db $01, $00, $04

; ---- words $7CA4-$7CA6 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim16Frames:: ; 24:7CA4
Table_24_7CA4::
	dw MailResult_Anim16Frame0

; ---- data $7CA6-$7CAF (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim16Frame0:: ; 24:7CA6
Data_24_7CA6::
	db $02, $38, $E8, $03, $00, $40, $E8, $13, $00

; ---- data $7CAF-$7CB2 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim16Script:: ; 24:7CAF
Data_24_7CAF::
	db $01, $00, $04

; ---- words $7CB2-$7CB4 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim20Frames:: ; 24:7CB2
Table_24_7CB2::
	dw MailResult_Anim20Frame0

; ---- data $7CB4-$7CBD (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim20Frame0:: ; 24:7CB4
Data_24_7CB4::
	db $02, $38, $E8, $04, $00, $40, $E8, $14, $00

; ---- data $7CBD-$7CC0 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim20Script:: ; 24:7CBD
Data_24_7CBD::
	db $01, $00, $04

; ---- words $7CC0-$7CC2 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim24Frames:: ; 24:7CC0
Table_24_7CC0::
	dw MailResult_Anim24Frame0

; ---- data $7CC2-$7CCB (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim24Frame0:: ; 24:7CC2
Data_24_7CC2::
	db $02, $38, $E8, $05, $00, $40, $E8, $15, $00

; ---- data $7CCB-$7CCE (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim24Script:: ; 24:7CCB
Data_24_7CCB::
	db $01, $00, $04

; ---- words $7CCE-$7CD0 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim28Frames:: ; 24:7CCE
Table_24_7CCE::
	dw MailResult_Anim28Frame0

; ---- data $7CD0-$7CD9 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim28Frame0:: ; 24:7CD0
Data_24_7CD0::
	db $02, $38, $E8, $06, $00, $40, $E8, $16, $00

; ---- data $7CD9-$7CDC (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim28Script:: ; 24:7CD9
Data_24_7CD9::
	db $01, $00, $04

; ---- words $7CDC-$7CDE (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim32Frames:: ; 24:7CDC
Table_24_7CDC::
	dw MailResult_Anim32Frame0

; ---- data $7CDE-$7CE7 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim32Frame0:: ; 24:7CDE
Data_24_7CDE::
	db $02, $38, $E8, $07, $00, $40, $E8, $17, $00

; ---- data $7CE7-$7CEA (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim32Script:: ; 24:7CE7
Data_24_7CE7::
	db $01, $00, $04

; ---- words $7CEA-$7CEC (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim36Frames:: ; 24:7CEA
Table_24_7CEA::
	dw MailResult_Anim36Frame0

; ---- data $7CEC-$7CF5 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim36Frame0:: ; 24:7CEC
Data_24_7CEC::
	db $02, $38, $E8, $08, $00, $40, $E8, $18, $00

; ---- data $7CF5-$7CF8 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim36Script:: ; 24:7CF5
Data_24_7CF5::
	db $01, $00, $04

; ---- words $7CF8-$7CFA (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim40Frames:: ; 24:7CF8
Table_24_7CF8::
	dw MailResult_Anim40Frame0

; ---- data $7CFA-$7D03 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim40Frame0:: ; 24:7CFA
Data_24_7CFA::
	db $02, $38, $E8, $09, $00, $40, $E8, $19, $00

; ---- data $7D03-$7D06 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim40Script:: ; 24:7D03
Data_24_7D03::
	db $01, $00, $04

; ---- words $7D06-$7D08 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim44Frames:: ; 24:7D06
Table_24_7D06::
	dw MailResult_Anim44Frame0

; ---- data $7D08-$7D19 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim44Frame0:: ; 24:7D08
Data_24_7D08::
	db $04, $38, $E0, $01, $00, $40, $E0, $11, $00, $38, $E8, $00, $00, $40, $E8, $10
	db $00

; ---- data $7D19-$7D1C (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim44Script:: ; 24:7D19
Data_24_7D19::
	db $01, $00, $04

; ---- words $7D1C-$7D1E (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim48Frames:: ; 24:7D1C
Table_24_7D1C::
	dw MailResult_Anim48Frame0

; ---- data $7D1E-$7D2F (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim48Frame0:: ; 24:7D1E
Data_24_7D1E::
	db $04, $38, $E0, $01, $00, $40, $E0, $11, $00, $38, $E8, $01, $00, $40, $E8, $11
	db $00

; ---- data $7D2F-$7D32 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim48Script:: ; 24:7D2F
Data_24_7D2F::
	db $01, $00, $04

; ---- words $7D32-$7D34 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim52Frames:: ; 24:7D32
Table_24_7D32::
	dw MailResult_Anim52Frame0

; ---- data $7D34-$7D45 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim52Frame0:: ; 24:7D34
Data_24_7D34::
	db $04, $38, $E0, $01, $00, $40, $E0, $11, $00, $38, $E8, $02, $00, $40, $E8, $12
	db $00

; ---- data $7D45-$7D48 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim52Script:: ; 24:7D45
Data_24_7D45::
	db $01, $00, $04
