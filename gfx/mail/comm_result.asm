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
	sprite_object_entry MailResult_Anim0Frames, MailResult_Anim0Script ; entry 0
	sprite_object_entry MailResult_Anim0Frames, MailResult_Anim0Script ; entry 1
	sprite_object_entry MailResult_Anim0Frames, MailResult_Anim0Script ; entry 2
	sprite_object_entry MailResult_Anim0Frames, MailResult_Anim0Script ; entry 3
	sprite_object_entry MailResult_Anim4Frames, MailResult_Anim4Script ; entry 4
	sprite_object_entry MailResult_Anim4Frames, MailResult_Anim4Script ; entry 5
	sprite_object_entry MailResult_Anim4Frames, MailResult_Anim4Script ; entry 6
	sprite_object_entry MailResult_Anim4Frames, MailResult_Anim4Script ; entry 7
	sprite_object_entry MailResult_Anim8Frames, MailResult_Anim8Script ; entry 8
	sprite_object_entry MailResult_Anim8Frames, MailResult_Anim8Script ; entry 9
	sprite_object_entry MailResult_Anim8Frames, MailResult_Anim8Script ; entry 10
	sprite_object_entry MailResult_Anim8Frames, MailResult_Anim8Script ; entry 11
	sprite_object_entry MailResult_Anim12Frames, MailResult_Anim12Script ; entry 12
	sprite_object_entry MailResult_Anim12Frames, MailResult_Anim12Script ; entry 13
	sprite_object_entry MailResult_Anim12Frames, MailResult_Anim12Script ; entry 14
	sprite_object_entry MailResult_Anim12Frames, MailResult_Anim12Script ; entry 15
	sprite_object_entry MailResult_Anim16Frames, MailResult_Anim16Script ; entry 16
	sprite_object_entry MailResult_Anim16Frames, MailResult_Anim16Script ; entry 17
	sprite_object_entry MailResult_Anim16Frames, MailResult_Anim16Script ; entry 18
	sprite_object_entry MailResult_Anim16Frames, MailResult_Anim16Script ; entry 19
	sprite_object_entry MailResult_Anim20Frames, MailResult_Anim20Script ; entry 20
	sprite_object_entry MailResult_Anim20Frames, MailResult_Anim20Script ; entry 21
	sprite_object_entry MailResult_Anim20Frames, MailResult_Anim20Script ; entry 22
	sprite_object_entry MailResult_Anim20Frames, MailResult_Anim20Script ; entry 23
	sprite_object_entry MailResult_Anim24Frames, MailResult_Anim24Script ; entry 24
	sprite_object_entry MailResult_Anim24Frames, MailResult_Anim24Script ; entry 25
	sprite_object_entry MailResult_Anim24Frames, MailResult_Anim24Script ; entry 26
	sprite_object_entry MailResult_Anim24Frames, MailResult_Anim24Script ; entry 27
	sprite_object_entry MailResult_Anim28Frames, MailResult_Anim28Script ; entry 28
	sprite_object_entry MailResult_Anim28Frames, MailResult_Anim28Script ; entry 29
	sprite_object_entry MailResult_Anim28Frames, MailResult_Anim28Script ; entry 30
	sprite_object_entry MailResult_Anim28Frames, MailResult_Anim28Script ; entry 31
	sprite_object_entry MailResult_Anim32Frames, MailResult_Anim32Script ; entry 32
	sprite_object_entry MailResult_Anim32Frames, MailResult_Anim32Script ; entry 33
	sprite_object_entry MailResult_Anim32Frames, MailResult_Anim32Script ; entry 34
	sprite_object_entry MailResult_Anim32Frames, MailResult_Anim32Script ; entry 35
	sprite_object_entry MailResult_Anim36Frames, MailResult_Anim36Script ; entry 36
	sprite_object_entry MailResult_Anim36Frames, MailResult_Anim36Script ; entry 37
	sprite_object_entry MailResult_Anim36Frames, MailResult_Anim36Script ; entry 38
	sprite_object_entry MailResult_Anim36Frames, MailResult_Anim36Script ; entry 39
	sprite_object_entry MailResult_Anim40Frames, MailResult_Anim40Script ; entry 40
	sprite_object_entry MailResult_Anim40Frames, MailResult_Anim40Script ; entry 41
	sprite_object_entry MailResult_Anim40Frames, MailResult_Anim40Script ; entry 42
	sprite_object_entry MailResult_Anim40Frames, MailResult_Anim40Script ; entry 43
	sprite_object_entry MailResult_Anim44Frames, MailResult_Anim44Script ; entry 44
	sprite_object_entry MailResult_Anim44Frames, MailResult_Anim44Script ; entry 45
	sprite_object_entry MailResult_Anim44Frames, MailResult_Anim44Script ; entry 46
	sprite_object_entry MailResult_Anim44Frames, MailResult_Anim44Script ; entry 47
	sprite_object_entry MailResult_Anim48Frames, MailResult_Anim48Script ; entry 48
	sprite_object_entry MailResult_Anim48Frames, MailResult_Anim48Script ; entry 49
	sprite_object_entry MailResult_Anim48Frames, MailResult_Anim48Script ; entry 50
	sprite_object_entry MailResult_Anim48Frames, MailResult_Anim48Script ; entry 51
	sprite_object_entry MailResult_Anim52Frames, MailResult_Anim52Script ; entry 52
	sprite_object_entry MailResult_Anim52Frames, MailResult_Anim52Script ; entry 53
	sprite_object_entry MailResult_Anim52Frames, MailResult_Anim52Script ; entry 54
	sprite_object_entry MailResult_Anim52Frames, MailResult_Anim52Script ; entry 55

; ---- words $7C00-$7C02 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim0Frames:: ; 24:7C00
Table_24_7C00::
	sprite_frame_table MailResult_Anim0Frame0

; ---- data $7C02-$7C33 (49 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 12 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim0Frame0:: ; 24:7C02
Data_24_7C02::
	sprite_frame 12
	sprite_oam 80, 56, $0A, 1
	sprite_oam 80, 64, $0B, 1
	sprite_oam 80, 72, $0C, 1
	sprite_oam 80, 80, $0D, 1
	sprite_oam 80, 88, $0E, 1
	sprite_oam 80, 96, $0F, 1
	sprite_oam 88, 56, $1A, 1
	sprite_oam 88, 64, $1B, 1
	sprite_oam 88, 72, $1C, 1
	sprite_oam 88, 80, $1D, 1
	sprite_oam 88, 88, $1E, 1
	sprite_oam 88, 96, $1F, 1

; ---- data $7C33-$7C36 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim0Script:: ; 24:7C33
Data_24_7C33::
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $7C36-$7C38 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim4Frames:: ; 24:7C36
Table_24_7C36::
	sprite_frame_table MailResult_Anim4Frame0

; ---- data $7C38-$7C85 (77 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 19 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim4Frame0:: ; 24:7C38
Data_24_7C38::
	sprite_frame 19
	sprite_oam -16, 40, $20, 2
	sprite_oam -16, 48, $21, 2
	sprite_oam -16, 56, $22, 3
	sprite_oam -16, 64, $23, 3
	sprite_oam -8, 40, $24, 2
	sprite_oam -8, 48, $25, 2
	sprite_oam -8, 56, $26, 3
	sprite_oam -8, 64, $27, 3
	sprite_oam 0, 40, $28, 2
	sprite_oam 0, 48, $29, 2
	sprite_oam 39, 40, $2A, 2
	sprite_oam 39, 48, $2B, 2
	sprite_oam 39, 56, $2C, 2
	sprite_oam 39, 64, $2D, 2
	sprite_oam 47, 48, $2E, 2
	sprite_oam 47, 56, $2F, 2
	sprite_oam 31, 43, $20, 3
	sprite_oam 31, 51, $21, 3
	sprite_oam 31, 59, $22, 3

; ---- data $7C85-$7C88 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim4Script:: ; 24:7C85
Data_24_7C85::
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $7C88-$7C8A (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim8Frames:: ; 24:7C88
Table_24_7C88::
	sprite_frame_table MailResult_Anim8Frame0

; ---- data $7C8A-$7C93 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim8Frame0:: ; 24:7C8A
Data_24_7C8A::
	sprite_frame 2
	sprite_oam 56, -24, $01, 0
	sprite_oam 64, -24, $11, 0

; ---- data $7C93-$7C96 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim8Script:: ; 24:7C93
Data_24_7C93::
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $7C96-$7C98 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim12Frames:: ; 24:7C96
Table_24_7C96::
	sprite_frame_table MailResult_Anim12Frame0

; ---- data $7C98-$7CA1 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim12Frame0:: ; 24:7C98
Data_24_7C98::
	sprite_frame 2
	sprite_oam 56, -24, $02, 0
	sprite_oam 64, -24, $12, 0

; ---- data $7CA1-$7CA4 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim12Script:: ; 24:7CA1
Data_24_7CA1::
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $7CA4-$7CA6 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim16Frames:: ; 24:7CA4
Table_24_7CA4::
	sprite_frame_table MailResult_Anim16Frame0

; ---- data $7CA6-$7CAF (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim16Frame0:: ; 24:7CA6
Data_24_7CA6::
	sprite_frame 2
	sprite_oam 56, -24, $03, 0
	sprite_oam 64, -24, $13, 0

; ---- data $7CAF-$7CB2 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim16Script:: ; 24:7CAF
Data_24_7CAF::
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $7CB2-$7CB4 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim20Frames:: ; 24:7CB2
Table_24_7CB2::
	sprite_frame_table MailResult_Anim20Frame0

; ---- data $7CB4-$7CBD (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim20Frame0:: ; 24:7CB4
Data_24_7CB4::
	sprite_frame 2
	sprite_oam 56, -24, $04, 0
	sprite_oam 64, -24, $14, 0

; ---- data $7CBD-$7CC0 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim20Script:: ; 24:7CBD
Data_24_7CBD::
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $7CC0-$7CC2 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim24Frames:: ; 24:7CC0
Table_24_7CC0::
	sprite_frame_table MailResult_Anim24Frame0

; ---- data $7CC2-$7CCB (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim24Frame0:: ; 24:7CC2
Data_24_7CC2::
	sprite_frame 2
	sprite_oam 56, -24, $05, 0
	sprite_oam 64, -24, $15, 0

; ---- data $7CCB-$7CCE (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim24Script:: ; 24:7CCB
Data_24_7CCB::
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $7CCE-$7CD0 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim28Frames:: ; 24:7CCE
Table_24_7CCE::
	sprite_frame_table MailResult_Anim28Frame0

; ---- data $7CD0-$7CD9 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim28Frame0:: ; 24:7CD0
Data_24_7CD0::
	sprite_frame 2
	sprite_oam 56, -24, $06, 0
	sprite_oam 64, -24, $16, 0

; ---- data $7CD9-$7CDC (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim28Script:: ; 24:7CD9
Data_24_7CD9::
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $7CDC-$7CDE (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim32Frames:: ; 24:7CDC
Table_24_7CDC::
	sprite_frame_table MailResult_Anim32Frame0

; ---- data $7CDE-$7CE7 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim32Frame0:: ; 24:7CDE
Data_24_7CDE::
	sprite_frame 2
	sprite_oam 56, -24, $07, 0
	sprite_oam 64, -24, $17, 0

; ---- data $7CE7-$7CEA (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim32Script:: ; 24:7CE7
Data_24_7CE7::
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $7CEA-$7CEC (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim36Frames:: ; 24:7CEA
Table_24_7CEA::
	sprite_frame_table MailResult_Anim36Frame0

; ---- data $7CEC-$7CF5 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim36Frame0:: ; 24:7CEC
Data_24_7CEC::
	sprite_frame 2
	sprite_oam 56, -24, $08, 0
	sprite_oam 64, -24, $18, 0

; ---- data $7CF5-$7CF8 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim36Script:: ; 24:7CF5
Data_24_7CF5::
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $7CF8-$7CFA (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim40Frames:: ; 24:7CF8
Table_24_7CF8::
	sprite_frame_table MailResult_Anim40Frame0

; ---- data $7CFA-$7D03 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim40Frame0:: ; 24:7CFA
Data_24_7CFA::
	sprite_frame 2
	sprite_oam 56, -24, $09, 0
	sprite_oam 64, -24, $19, 0

; ---- data $7D03-$7D06 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim40Script:: ; 24:7D03
Data_24_7D03::
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $7D06-$7D08 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim44Frames:: ; 24:7D06
Table_24_7D06::
	sprite_frame_table MailResult_Anim44Frame0

; ---- data $7D08-$7D19 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim44Frame0:: ; 24:7D08
Data_24_7D08::
	sprite_frame 4
	sprite_oam 56, -32, $01, 0
	sprite_oam 64, -32, $11, 0
	sprite_oam 56, -24, $00, 0
	sprite_oam 64, -24, $10, 0

; ---- data $7D19-$7D1C (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim44Script:: ; 24:7D19
Data_24_7D19::
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $7D1C-$7D1E (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim48Frames:: ; 24:7D1C
Table_24_7D1C::
	sprite_frame_table MailResult_Anim48Frame0

; ---- data $7D1E-$7D2F (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim48Frame0:: ; 24:7D1E
Data_24_7D1E::
	sprite_frame 4
	sprite_oam 56, -32, $01, 0
	sprite_oam 64, -32, $11, 0
	sprite_oam 56, -24, $01, 0
	sprite_oam 64, -24, $11, 0

; ---- data $7D2F-$7D32 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim48Script:: ; 24:7D2F
Data_24_7D2F::
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $7D32-$7D34 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailResult_Anim52Frames:: ; 24:7D32
Table_24_7D32::
	sprite_frame_table MailResult_Anim52Frame0

; ---- data $7D34-$7D45 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

MailResult_Anim52Frame0:: ; 24:7D34
Data_24_7D34::
	sprite_frame 4
	sprite_oam 56, -32, $01, 0
	sprite_oam 64, -32, $11, 0
	sprite_oam 56, -24, $02, 0
	sprite_oam 64, -24, $12, 0

; ---- data $7D45-$7D48 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

MailResult_Anim52Script:: ; 24:7D45
Data_24_7D45::
	sprite_anim 1
	sprite_anim_step 0, 4
