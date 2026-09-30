; gfx/mail_server/delete_progress.asm
; bank 23, $6FD7-$7F30 (3929 bytes); pinned by layout.link
; progress screen tiles, tilemap, palettes, sprite counter digit and object tables

SECTION "gfx/mail_server/delete_progress", ROMX

; ---- zero $6FD7-$6FE0 (9 bytes) [PROBABLE] 0x00 padding between the last function of the bank and the tile block at $6FE0
	ds $9, $00

; ---- gfx $6FE0-$73E0 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 23:5616: hl=$6FE0 a=$23 c=$40 de=$9001 (dest VRAM $9000, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_MailSrvDelProgress_Tiles0:: ; 23:6FE0
Data_23_6FE0::
	INCBIN "gfx/mail_server/delete_progress/mail_srv_del_progress_tiles0.2bpp"

; ---- gfx $73E0-$74E0 (256 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 23:5628: hl=$73E0 a=$23 c=$10 de=$9401 (dest VRAM $9400, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_MailSrvDelProgress_Tiles1:: ; 23:73E0
Data_23_73E0::
	INCBIN "gfx/mail_server/delete_progress/mail_srv_del_progress_tiles1.2bpp"

; ---- gfx $74E0-$7640 (352 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 23:563A: hl=$74E0 a=$23 c=$16 de=$8000 (dest VRAM $8000, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_MailSrvDelProgress_Tiles2:: ; 23:74E0
Data_23_74E0::
	INCBIN "gfx/mail_server/delete_progress/mail_srv_del_progress_tiles2.2bpp"

; ---- data $7640-$7910 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 23:564B: hl=$7640 a=$23 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Tilemap_MailSrvDelProgress_Screen:: ; 23:7640
Data_23_7640::
	INCBIN "gfx/mail_server/delete_progress/mail_srv_del_progress_screen.tilemap"
	INCBIN "gfx/mail_server/delete_progress/mail_srv_del_progress_screen.attrmap"

; ---- data $7910-$7950 (64 bytes) [PROBABLE] 64-byte RGB555 palette block copied by Function_4F_4000 (hl=$7910 a=$23 bc=$0040 de=$D800) at 23:55F3; call site never executed; replaces the mapper palette guess 7910-7A3F which swallowed the object tables

Palette_MailSrvDelProgress_Bg:: ; 23:7910
Palette_23_7910::
	INCLUDE "gfx/mail_server/delete_progress/mail_srv_del_progress_bg.pal"

; ---- data $7950-$7990 (64 bytes) [PROBABLE] 64-byte RGB555 palette block copied by Function_4F_4000 (hl=$7950 a=$23 bc=$0040 de=$D840) at 23:5604; call site never executed

Palette_MailSrvDelProgress_Obj:: ; 23:7950
Palette_23_7950::
	INCLUDE "gfx/mail_server/delete_progress/mail_srv_del_progress_obj.pal"

; ---- words $7990-$7AE0 (336 bytes) [PROBABLE] sprite object table: 4-byte entries (frame-table ptr, animation-script ptr) indexed by B&7F, the layout read by init_object_from_table 00:0A82/00:0AB8; rows of 16 bytes = the same entry repeated 4 times; base $7990 is passed as de with a=$23 at call sites listed in analysis/gfx_candidates.tsv (object-table); entries 7AE0/7AE7 7AE0/7AE7 7AE0/7AE7 7AE0/7AE7

Table_SpriteCounter_Digits:: ; 23:7990
Table_23_7990::
	dw SpriteCounter_Digits_Anim0Frames, SpriteCounter_Digits_Anim0Script, SpriteCounter_Digits_Anim0Frames, SpriteCounter_Digits_Anim0Script, SpriteCounter_Digits_Anim0Frames, SpriteCounter_Digits_Anim0Script, SpriteCounter_Digits_Anim0Frames, SpriteCounter_Digits_Anim0Script
	dw SpriteCounter_Digits_Anim4Frames, SpriteCounter_Digits_Anim4Script, SpriteCounter_Digits_Anim4Frames, SpriteCounter_Digits_Anim4Script, SpriteCounter_Digits_Anim4Frames, SpriteCounter_Digits_Anim4Script, SpriteCounter_Digits_Anim4Frames, SpriteCounter_Digits_Anim4Script
	dw SpriteCounter_Digits_Anim8Frames, SpriteCounter_Digits_Anim8Script, SpriteCounter_Digits_Anim8Frames, SpriteCounter_Digits_Anim8Script, SpriteCounter_Digits_Anim8Frames, SpriteCounter_Digits_Anim8Script, SpriteCounter_Digits_Anim8Frames, SpriteCounter_Digits_Anim8Script
	dw SpriteCounter_Digits_Anim12Frames, SpriteCounter_Digits_Anim12Script, SpriteCounter_Digits_Anim12Frames, SpriteCounter_Digits_Anim12Script, SpriteCounter_Digits_Anim12Frames, SpriteCounter_Digits_Anim12Script, SpriteCounter_Digits_Anim12Frames, SpriteCounter_Digits_Anim12Script
	dw SpriteCounter_Digits_Anim16Frames, SpriteCounter_Digits_Anim16Script, SpriteCounter_Digits_Anim16Frames, SpriteCounter_Digits_Anim16Script, SpriteCounter_Digits_Anim16Frames, SpriteCounter_Digits_Anim16Script, SpriteCounter_Digits_Anim16Frames, SpriteCounter_Digits_Anim16Script
	dw SpriteCounter_Digits_Anim20Frames, SpriteCounter_Digits_Anim20Script, SpriteCounter_Digits_Anim20Frames, SpriteCounter_Digits_Anim20Script, SpriteCounter_Digits_Anim20Frames, SpriteCounter_Digits_Anim20Script, SpriteCounter_Digits_Anim20Frames, SpriteCounter_Digits_Anim20Script
	dw SpriteCounter_Digits_Anim24Frames, SpriteCounter_Digits_Anim24Script, SpriteCounter_Digits_Anim24Frames, SpriteCounter_Digits_Anim24Script, SpriteCounter_Digits_Anim24Frames, SpriteCounter_Digits_Anim24Script, SpriteCounter_Digits_Anim24Frames, SpriteCounter_Digits_Anim24Script
	dw SpriteCounter_Digits_Anim28Frames, SpriteCounter_Digits_Anim28Script, SpriteCounter_Digits_Anim28Frames, SpriteCounter_Digits_Anim28Script, SpriteCounter_Digits_Anim28Frames, SpriteCounter_Digits_Anim28Script, SpriteCounter_Digits_Anim28Frames, SpriteCounter_Digits_Anim28Script
	dw SpriteCounter_Digits_Anim32Frames, SpriteCounter_Digits_Anim32Script, SpriteCounter_Digits_Anim32Frames, SpriteCounter_Digits_Anim32Script, SpriteCounter_Digits_Anim32Frames, SpriteCounter_Digits_Anim32Script, SpriteCounter_Digits_Anim32Frames, SpriteCounter_Digits_Anim32Script
	dw SpriteCounter_Digits_Anim36Frames, SpriteCounter_Digits_Anim36Script, SpriteCounter_Digits_Anim36Frames, SpriteCounter_Digits_Anim36Script, SpriteCounter_Digits_Anim36Frames, SpriteCounter_Digits_Anim36Script, SpriteCounter_Digits_Anim36Frames, SpriteCounter_Digits_Anim36Script
	dw SpriteCounter_Digits_Anim40Frames, SpriteCounter_Digits_Anim40Script, SpriteCounter_Digits_Anim40Frames, SpriteCounter_Digits_Anim40Script, SpriteCounter_Digits_Anim40Frames, SpriteCounter_Digits_Anim40Script, SpriteCounter_Digits_Anim40Frames, SpriteCounter_Digits_Anim40Script
	dw SpriteCounter_Digits_Anim44Frames, SpriteCounter_Digits_Anim44Script, SpriteCounter_Digits_Anim44Frames, SpriteCounter_Digits_Anim44Script, SpriteCounter_Digits_Anim44Frames, SpriteCounter_Digits_Anim44Script, SpriteCounter_Digits_Anim44Frames, SpriteCounter_Digits_Anim44Script
	dw SpriteCounter_Digits_Anim48Frames, SpriteCounter_Digits_Anim48Script, SpriteCounter_Digits_Anim48Frames, SpriteCounter_Digits_Anim48Script, SpriteCounter_Digits_Anim48Frames, SpriteCounter_Digits_Anim48Script, SpriteCounter_Digits_Anim48Frames, SpriteCounter_Digits_Anim48Script
	dw SpriteCounter_Digits_Anim52Frames, SpriteCounter_Digits_Anim52Script, SpriteCounter_Digits_Anim52Frames, SpriteCounter_Digits_Anim52Script, SpriteCounter_Digits_Anim52Frames, SpriteCounter_Digits_Anim52Script, SpriteCounter_Digits_Anim52Frames, SpriteCounter_Digits_Anim52Script
	dw SpriteCounter_Digits_Anim56Frames, SpriteCounter_Digits_Anim56Script, SpriteCounter_Digits_Anim56Frames, SpriteCounter_Digits_Anim56Script, SpriteCounter_Digits_Anim56Frames, SpriteCounter_Digits_Anim56Script, SpriteCounter_Digits_Anim56Frames, SpriteCounter_Digits_Anim56Script
	dw SpriteCounter_Digits_Anim60Frames, SpriteCounter_Digits_Anim60Script, SpriteCounter_Digits_Anim60Frames, SpriteCounter_Digits_Anim60Script, SpriteCounter_Digits_Anim60Frames, SpriteCounter_Digits_Anim60Script, SpriteCounter_Digits_Anim60Frames, SpriteCounter_Digits_Anim60Script
	dw SpriteCounter_Digits_Anim64Frames, SpriteCounter_Digits_Anim64Script, SpriteCounter_Digits_Anim64Frames, SpriteCounter_Digits_Anim64Script, SpriteCounter_Digits_Anim64Frames, SpriteCounter_Digits_Anim64Script, SpriteCounter_Digits_Anim64Frames, SpriteCounter_Digits_Anim64Script
	dw SpriteCounter_Digits_Anim68Frames, SpriteCounter_Digits_Anim68Script, SpriteCounter_Digits_Anim68Frames, SpriteCounter_Digits_Anim68Script, SpriteCounter_Digits_Anim68Frames, SpriteCounter_Digits_Anim68Script, SpriteCounter_Digits_Anim68Frames, SpriteCounter_Digits_Anim68Script
	dw SpriteCounter_Digits_Anim72Frames, SpriteCounter_Digits_Anim72Script, SpriteCounter_Digits_Anim72Frames, SpriteCounter_Digits_Anim72Script, SpriteCounter_Digits_Anim72Frames, SpriteCounter_Digits_Anim72Script, SpriteCounter_Digits_Anim72Frames, SpriteCounter_Digits_Anim72Script
	dw SpriteCounter_Digits_Anim76Frames, SpriteCounter_Digits_Anim76Script, SpriteCounter_Digits_Anim76Frames, SpriteCounter_Digits_Anim76Script, SpriteCounter_Digits_Anim76Frames, SpriteCounter_Digits_Anim76Script, SpriteCounter_Digits_Anim76Frames, SpriteCounter_Digits_Anim76Script

Table_MailSrvDel_ProgressObject:: ; 23:7AD0
	dw MailSrvDel_ProgressObject_Anim0Frames, MailSrvDel_ProgressObject_Anim0Script, MailSrvDel_ProgressObject_Anim0Frames, MailSrvDel_ProgressObject_Anim0Script, MailSrvDel_ProgressObject_Anim0Frames, MailSrvDel_ProgressObject_Anim0Script, MailSrvDel_ProgressObject_Anim0Frames, MailSrvDel_ProgressObject_Anim0Script

; ---- words $7AE0-$7AE2 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim0Frames:: ; 23:7AE0
Table_23_7AE0::
	dw SpriteCounter_Digits_Anim0Frame0

; ---- data $7AE2-$7AE7 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim0Frame0:: ; 23:7AE2
Data_23_7AE2::
	db $01, $FD, $0D, $00, $00

; ---- data $7AE7-$7AEA (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim0Script:: ; 23:7AE7
Data_23_7AE7::
	db $01, $00, $04

; ---- words $7AEA-$7AEC (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim4Frames:: ; 23:7AEA
Table_23_7AEA::
	dw SpriteCounter_Digits_Anim4Frame0

; ---- data $7AEC-$7AF1 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim4Frame0:: ; 23:7AEC
Data_23_7AEC::
	db $01, $FD, $0D, $01, $00

; ---- data $7AF1-$7AF4 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim4Script:: ; 23:7AF1
Data_23_7AF1::
	db $01, $00, $04

; ---- words $7AF4-$7AF6 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim8Frames:: ; 23:7AF4
Table_23_7AF4::
	dw SpriteCounter_Digits_Anim8Frame0

; ---- data $7AF6-$7AFB (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim8Frame0:: ; 23:7AF6
Data_23_7AF6::
	db $01, $FD, $0D, $02, $00

; ---- data $7AFB-$7AFE (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim8Script:: ; 23:7AFB
Data_23_7AFB::
	db $01, $00, $04

; ---- words $7AFE-$7B00 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim12Frames:: ; 23:7AFE
Table_23_7AFE::
	dw SpriteCounter_Digits_Anim12Frame0

; ---- data $7B00-$7B05 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim12Frame0:: ; 23:7B00
Data_23_7B00::
	db $01, $FD, $0D, $03, $00

; ---- data $7B05-$7B08 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim12Script:: ; 23:7B05
Data_23_7B05::
	db $01, $00, $04

; ---- words $7B08-$7B0A (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim16Frames:: ; 23:7B08
Table_23_7B08::
	dw SpriteCounter_Digits_Anim16Frame0

; ---- data $7B0A-$7B0F (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim16Frame0:: ; 23:7B0A
Data_23_7B0A::
	db $01, $FD, $0D, $04, $00

; ---- data $7B0F-$7B12 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim16Script:: ; 23:7B0F
Data_23_7B0F::
	db $01, $00, $04

; ---- words $7B12-$7B14 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim20Frames:: ; 23:7B12
Table_23_7B12::
	dw SpriteCounter_Digits_Anim20Frame0

; ---- data $7B14-$7B19 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim20Frame0:: ; 23:7B14
Data_23_7B14::
	db $01, $FD, $0D, $05, $00

; ---- data $7B19-$7B1C (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim20Script:: ; 23:7B19
Data_23_7B19::
	db $01, $00, $04

; ---- words $7B1C-$7B1E (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim24Frames:: ; 23:7B1C
Table_23_7B1C::
	dw SpriteCounter_Digits_Anim24Frame0

; ---- data $7B1E-$7B23 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim24Frame0:: ; 23:7B1E
Data_23_7B1E::
	db $01, $FD, $0D, $06, $00

; ---- data $7B23-$7B26 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim24Script:: ; 23:7B23
Data_23_7B23::
	db $01, $00, $04

; ---- words $7B26-$7B28 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim28Frames:: ; 23:7B26
Table_23_7B26::
	dw SpriteCounter_Digits_Anim28Frame0

; ---- data $7B28-$7B2D (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim28Frame0:: ; 23:7B28
Data_23_7B28::
	db $01, $FD, $0D, $07, $00

; ---- data $7B2D-$7B30 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim28Script:: ; 23:7B2D
Data_23_7B2D::
	db $01, $00, $04

; ---- words $7B30-$7B32 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim32Frames:: ; 23:7B30
Table_23_7B30::
	dw SpriteCounter_Digits_Anim32Frame0

; ---- data $7B32-$7B37 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim32Frame0:: ; 23:7B32
Data_23_7B32::
	db $01, $FD, $0D, $08, $00

; ---- data $7B37-$7B3A (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim32Script:: ; 23:7B37
Data_23_7B37::
	db $01, $00, $04

; ---- words $7B3A-$7B3C (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim36Frames:: ; 23:7B3A
Table_23_7B3A::
	dw SpriteCounter_Digits_Anim36Frame0

; ---- data $7B3C-$7B41 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim36Frame0:: ; 23:7B3C
Data_23_7B3C::
	db $01, $FD, $0D, $09, $00

; ---- data $7B41-$7B44 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim36Script:: ; 23:7B41
Data_23_7B41::
	db $01, $00, $04

; ---- words $7B44-$7B46 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim40Frames:: ; 23:7B44
Table_23_7B44::
	dw SpriteCounter_Digits_Anim40Frame0

; ---- data $7B46-$7B4B (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim40Frame0:: ; 23:7B46
Data_23_7B46::
	db $01, $05, $0D, $00, $00

; ---- data $7B4B-$7B4E (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim40Script:: ; 23:7B4B
Data_23_7B4B::
	db $01, $00, $04

; ---- words $7B4E-$7B50 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim44Frames:: ; 23:7B4E
Table_23_7B4E::
	dw SpriteCounter_Digits_Anim44Frame0

; ---- data $7B50-$7B55 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim44Frame0:: ; 23:7B50
Data_23_7B50::
	db $01, $05, $0D, $01, $00

; ---- data $7B55-$7B58 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim44Script:: ; 23:7B55
Data_23_7B55::
	db $01, $00, $04

; ---- words $7B58-$7B5A (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim48Frames:: ; 23:7B58
Table_23_7B58::
	dw SpriteCounter_Digits_Anim48Frame0

; ---- data $7B5A-$7B5F (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim48Frame0:: ; 23:7B5A
Data_23_7B5A::
	db $01, $05, $0D, $02, $00

; ---- data $7B5F-$7B62 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim48Script:: ; 23:7B5F
Data_23_7B5F::
	db $01, $00, $04

; ---- words $7B62-$7B64 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim52Frames:: ; 23:7B62
Table_23_7B62::
	dw SpriteCounter_Digits_Anim52Frame0

; ---- data $7B64-$7B69 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim52Frame0:: ; 23:7B64
Data_23_7B64::
	db $01, $05, $0D, $03, $00

; ---- data $7B69-$7B6C (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim52Script:: ; 23:7B69
Data_23_7B69::
	db $01, $00, $04

; ---- words $7B6C-$7B6E (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim56Frames:: ; 23:7B6C
Table_23_7B6C::
	dw SpriteCounter_Digits_Anim56Frame0

; ---- data $7B6E-$7B73 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim56Frame0:: ; 23:7B6E
Data_23_7B6E::
	db $01, $05, $0D, $04, $00

; ---- data $7B73-$7B76 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim56Script:: ; 23:7B73
Data_23_7B73::
	db $01, $00, $04

; ---- words $7B76-$7B78 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim60Frames:: ; 23:7B76
Table_23_7B76::
	dw SpriteCounter_Digits_Anim60Frame0

; ---- data $7B78-$7B7D (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim60Frame0:: ; 23:7B78
Data_23_7B78::
	db $01, $05, $0D, $05, $00

; ---- data $7B7D-$7B80 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim60Script:: ; 23:7B7D
Data_23_7B7D::
	db $01, $00, $04

; ---- words $7B80-$7B82 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim64Frames:: ; 23:7B80
Table_23_7B80::
	dw SpriteCounter_Digits_Anim64Frame0

; ---- data $7B82-$7B87 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim64Frame0:: ; 23:7B82
Data_23_7B82::
	db $01, $05, $0D, $06, $00

; ---- data $7B87-$7B8A (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim64Script:: ; 23:7B87
Data_23_7B87::
	db $01, $00, $04

; ---- words $7B8A-$7B8C (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim68Frames:: ; 23:7B8A
Table_23_7B8A::
	dw SpriteCounter_Digits_Anim68Frame0

; ---- data $7B8C-$7B91 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim68Frame0:: ; 23:7B8C
Data_23_7B8C::
	db $01, $05, $0D, $07, $00

; ---- data $7B91-$7B94 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim68Script:: ; 23:7B91
Data_23_7B91::
	db $01, $00, $04

; ---- words $7B94-$7B96 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim72Frames:: ; 23:7B94
Table_23_7B94::
	dw SpriteCounter_Digits_Anim72Frame0

; ---- data $7B96-$7B9B (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim72Frame0:: ; 23:7B96
Data_23_7B96::
	db $01, $05, $0D, $08, $00

; ---- data $7B9B-$7B9E (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim72Script:: ; 23:7B9B
Data_23_7B9B::
	db $01, $00, $04

; ---- words $7B9E-$7BA0 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

SpriteCounter_Digits_Anim76Frames:: ; 23:7B9E
Table_23_7B9E::
	dw SpriteCounter_Digits_Anim76Frame0

; ---- data $7BA0-$7BA5 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

SpriteCounter_Digits_Anim76Frame0:: ; 23:7BA0
Data_23_7BA0::
	db $01, $05, $0D, $09, $00

; ---- data $7BA5-$7BA8 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

SpriteCounter_Digits_Anim76Script:: ; 23:7BA5
Data_23_7BA5::
	db $01, $00, $04

; ---- words $7BA8-$7BAC (4 bytes) [PROBABLE] sprite frame table: 2 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

MailSrvDel_ProgressObject_Anim0Frames:: ; 23:7BA8
Table_23_7BA8::
	dw MailSrvDel_ProgressObject_Anim0Frame0, MailSrvDel_ProgressObject_Anim0Frame1

; ---- data $7BAC-$7BD5 (41 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 10 piece(s); length tiles exactly against the frame-table pointers

MailSrvDel_ProgressObject_Anim0Frame0:: ; 23:7BAC
Data_23_7BAC::
	db $0A, $32, $48, $0A, $01, $32, $50, $0B, $01, $3A, $48, $0C, $01, $3A, $50, $0D
	db $01, $42, $48, $0E, $01, $42, $50, $0F, $01, $26, $48, $10, $02, $26, $50, $11
	db $02, $2E, $48, $12, $02, $2E, $50, $13, $02

; ---- data $7BD5-$7BFE (41 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 10 piece(s); length tiles exactly against the frame-table pointers

MailSrvDel_ProgressObject_Anim0Frame1:: ; 23:7BD5
Data_23_7BD5::
	db $0A, $32, $48, $0A, $01, $32, $50, $0B, $01, $3A, $48, $0C, $01, $3A, $50, $0D
	db $01, $42, $48, $0E, $01, $42, $50, $0F, $01, $2D, $43, $14, $02, $25, $43, $15
	db $02, $2D, $54, $14, $22, $25, $54, $15, $22

; ---- data $7BFE-$7C03 (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:20 1:29

MailSrvDel_ProgressObject_Anim0Script:: ; 23:7BFE
Data_23_7BFE::
	db $02, $00, $14, $01, $1D

; ---- data $7C03-$7F30 (813 bytes) [HYPOTHESIS] tilemap/attribute-like index data (all bytes < $40, 20-byte rows of runs of $11/$2F/$08/$10 and small ascending index runs 08-0F/18-1F/02-07/12-17); the mapper called 7C01-7E81 "tiles-2bpp" (coherence 0.66/0.88) but repeated-byte runs give that score to tilemaps as well and no loader references these bytes; extent 7E81-7F30 (previously unclassified) continues the same pattern (the $08 fill is an attribute-map pattern) - purpose unknown

Data_23_7C03:: ; 23:7C03
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11
	db $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11
	db $11, $2F, $2F, $2F, $2F, $2F, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F, $20, $21
	db $22, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $18, $19, $1A, $1B, $1C, $1D
	db $1E, $1F, $30, $31, $32, $2F, $2F, $2F, $2F, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $02, $03, $04, $05, $06, $07, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $12, $13, $14, $15, $16
	db $17, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11
	db $11, $11, $11, $11, $11, $11, $11, $11, $11, $2F, $2F, $2F, $2F, $2F, $08, $09
	db $0A, $0B, $0C, $0D, $23, $21, $25, $27, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $2F
	db $2F, $2F, $18, $19, $1A, $1B, $1C, $1D, $24, $31, $26, $28, $2F, $2F, $2F, $2F
	db $2F, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02
	db $03, $04, $05, $06, $07, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $12, $13, $14, $15, $16, $17, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $11, $11, $11
	db $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11
	db $11, $2F, $2F, $2F, $2F, $2F, $08, $09, $0A, $0B, $29, $2B, $2D, $0E, $0F, $20
	db $21, $22, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $18, $19, $1A, $1B, $2A, $2C
	db $2E, $1E, $1F, $30, $31, $32, $2F, $2F, $2F, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $02, $03, $04, $05, $06, $07, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $12, $13, $14, $15, $16
	db $17, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11
	db $11, $11, $11, $11, $11, $11, $11, $11, $11, $2F, $2F, $2F, $2F, $2F, $08, $09
	db $0A, $0B, $29, $2B, $2D, $23, $21, $25, $27, $2F, $2F, $2F, $2F, $2F, $2F, $2F
	db $2F, $2F, $18, $19, $1A, $1B, $2A, $2C, $2E, $24, $31, $26, $28, $2F, $2F, $2F
	db $2F, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02
	db $03, $04, $05, $06, $07, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $12, $13, $14, $15, $16, $17, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
