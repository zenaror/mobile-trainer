; gfx/mail/mail_viewer.asm
; bank 2B, $6DD0-$7B02 (3378 bytes); pinned by layout.link
; viewer tiles, tilemap, palettes, animation tables

SECTION "gfx/mail/mail_viewer", ROMX

; ---- gfx $6DD0-$71D0 (1024 bytes) [CONFIRMED] 64 tiles: 'ld de,$9001 ; ld hl,$6DD0 ; ld a,$2B ; ld c,$40 ; call FarCall -> 00:0749 (HDMA rom->vram)' at 2B:6620-6631; merges the former zero-run / UNCLASSIFIED fragments (blank rows are tile content) [every byte read as data in 9 scenario(s)]

Gfx_MailView_Tiles9000:: ; 2B:6DD0
Tiles_2B_6DD0::
	INCBIN "gfx/mail/mail_viewer/mail_view_tiles9000.2bpp"

; ---- gfx $71D0-$73D0 (512 bytes) [PROBABLE] 32 tiles: 'ld de,$9401 ; ld hl,$71D0 ; ld a,$2B ; ld c,$20 ; HDMA' at 2B:6635-6646; ends where the tilemap+attr block at 73D0 begins

Gfx_MailView_Tiles9400:: ; 2B:71D0
Tiles_2B_71D0::
	INCBIN "gfx/mail/mail_viewer/mail_view_tiles9400.2bpp"

; ---- data $73D0-$76A0 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2B:6655: hl=$73D0 a=$2B b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Data_MailView_TilemapAttr:: ; 2B:73D0
Data_2B_73D0::
	INCBIN "gfx/mail/mail_viewer/data_mail_view_tilemap_attr.tilemap"
	INCBIN "gfx/mail/mail_viewer/data_mail_view_tilemap_attr.attrmap"

; ---- data $76A0-$76E0 (64 bytes) [PROBABLE] 64 bytes = 32 RGB555 words (bit15 clear): 'ld bc,$0040 ; ld de,$D800 ; ld hl,$76A0 ; ld a,$2B ; far call 4F:4000' at 2B:65E3-65F3; the old heuristic region ran into tile data

Palette_MailView_Bg:: ; 2B:76A0
Palette_2B_76A0::
	INCLUDE "gfx/mail/mail_viewer/mail_view_bg.pal"

; ---- gfx $76E0-$7860 (384 bytes) [PROBABLE] 24 tiles: 'ld de,$8000 ; ld hl,$76E0 ; ld a,$2B ; ld c,$18 ; HDMA' at 2B:65F7-6608; includes the zero run at 7840-7860 (blank tiles)

Gfx_MailView_Tiles8000:: ; 2B:76E0
Tiles_2B_76E0::
	INCBIN "gfx/mail/mail_viewer/mail_view_tiles8000.2bpp"

; ---- data $7860-$78A0 (64 bytes) [PROBABLE] 64 bytes = 32 RGB555 words (bit15 clear): 'ld bc,$0040 ; ld de,$D840 ; ld hl,$7860 ; ld a,$2B ; far call 4F:4000' at 2B:660C-661C

Palette_MailView_Obj:: ; 2B:7860
Palette_2B_7860::
	INCLUDE "gfx/mail/mail_viewer/mail_view_obj.pal"

; ---- words $78A0-$7920 (128 bytes) [PROBABLE] animation entry table: 32 entries of 4 bytes (frame-table pointer, script pointer), each animation repeated 4x; format of the sprite-slot initialiser 00:0A82/0AB8 (entry at DE+4*(A&$7F) -> slot[2..3] frame table, slot[6..7] script)

Table_MailView_Anims:: ; 2B:78A0
Table_2B_78A0::
	dw MailView_Anim0Frames, MailView_Anim0Script, MailView_Anim0Frames, MailView_Anim0Script, MailView_Anim0Frames, MailView_Anim0Script, MailView_Anim0Frames, MailView_Anim0Script
	dw MailView_Anim4Frames, MailView_Anim4Script, MailView_Anim4Frames, MailView_Anim4Script, MailView_Anim4Frames, MailView_Anim4Script, MailView_Anim4Frames, MailView_Anim4Script
	dw MailView_Anim8Frames, MailView_Anim8Script, MailView_Anim8Frames, MailView_Anim8Script, MailView_Anim8Frames, MailView_Anim8Script, MailView_Anim8Frames, MailView_Anim8Script
	dw MailView_Anim12Frames, MailView_Anim12Script, MailView_Anim12Frames, MailView_Anim12Script, MailView_Anim12Frames, MailView_Anim12Script, MailView_Anim12Frames, MailView_Anim12Script
	dw MailView_Anim16Frames, MailView_Anim16Script, MailView_Anim16Frames, MailView_Anim16Script, MailView_Anim16Frames, MailView_Anim16Script, MailView_Anim16Frames, MailView_Anim16Script
	dw MailView_Anim20Frames, MailView_Anim20Script, MailView_Anim20Frames, MailView_Anim20Script, MailView_Anim20Frames, MailView_Anim20Script, MailView_Anim20Frames, MailView_Anim20Script
	dw MailView_Anim24Frames, MailView_Anim24Script, MailView_Anim24Frames, MailView_Anim24Script, MailView_Anim24Frames, MailView_Anim24Script, MailView_Anim24Frames, MailView_Anim24Script
	dw MailView_Anim28Frames, MailView_Anim28Script, MailView_Anim28Frames, MailView_Anim28Script, MailView_Anim28Frames, MailView_Anim28Script, MailView_Anim28Frames, MailView_Anim28Script

; ---- words $7920-$7924 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $7924, $7955 to OAM frames (extent = lowest target); referenced by an animation entry

MailView_Anim0Frames:: ; 2B:7920
Table_2B_7920::
	dw MailView_Anim0Frame0, MailView_Anim0Frame1

; ---- data $7924-$7955 (49 bytes) [PROBABLE] OAM frame: count=12 then 12 x (y,x,tile,attr) = 49 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim0Frame0:: ; 2B:7924
Data_2B_7924::
	db $0C, $10, $00, $09, $02, $10, $08, $0A, $02, $10, $10, $0B, $02, $10, $00, $06
	db $04, $10, $08, $07, $04, $10, $10, $08, $04, $08, $00, $03, $04, $08, $08, $04
	db $04, $08, $10, $05, $04, $00, $00, $00, $04, $00, $08, $01, $04, $00, $10, $02
	db $04

; ---- data $7955-$7986 (49 bytes) [PROBABLE] OAM frame: count=12 then 12 x (y,x,tile,attr) = 49 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim0Frame1:: ; 2B:7955
Data_2B_7955::
	db $0C, $10, $00, $06, $02, $10, $08, $07, $02, $10, $10, $08, $02, $00, $00, $29
	db $04, $00, $08, $2A, $04, $00, $10, $2B, $04, $08, $00, $00, $04, $08, $08, $01
	db $04, $08, $10, $02, $04, $10, $00, $26, $04, $10, $08, $27, $04, $10, $10, $28
	db $04

; ---- data $7986-$7989 (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 2e), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailView_Anim0Script:: ; 2B:7986
Data_2B_7986::
	db $01, $00, $2E

; ---- words $7989-$798D (4 bytes) [PROBABLE] frame table: 2 pointer(s) $798D, $799A to OAM frames (extent = lowest target); referenced by an animation entry

MailView_Anim4Frames:: ; 2B:7989
Table_2B_7989::
	dw MailView_Anim4Frame0, MailView_Anim4Frame1

; ---- data $798D-$799A (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim4Frame0:: ; 2B:798D
Data_2B_798D::
	db $03, $10, $00, $0C, $02, $10, $08, $0D, $02, $10, $10, $0E, $02

; ---- data $799A-$79A7 (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim4Frame1:: ; 2B:799A
Data_2B_799A::
	db $03, $10, $00, $09, $02, $10, $08, $0A, $02, $10, $10, $0B, $02

; ---- data $79A7-$79AA (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 2e), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailView_Anim4Script:: ; 2B:79A7
Data_2B_79A7::
	db $01, $00, $2E

; ---- words $79AA-$79AE (4 bytes) [PROBABLE] frame table: 2 pointer(s) $79AE, $79BF to OAM frames (extent = lowest target); referenced by an animation entry

MailView_Anim12Frames:: ; 2B:79AA
Table_2B_79AA::
	dw MailView_Anim12Frame0, MailView_Anim12Frame1

; ---- data $79AE-$79BF (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim12Frame0:: ; 2B:79AE
Data_2B_79AE::
	db $04, $F5, $08, $0C, $01, $F5, $10, $0D, $01, $FD, $08, $0E, $01, $FD, $10, $0F
	db $01

; ---- data $79BF-$79D0 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim12Frame1:: ; 2B:79BF
Data_2B_79BF::
	db $04, $F4, $08, $0C, $01, $F4, $10, $0D, $01, $FC, $08, $0E, $01, $FC, $10, $0F
	db $01

; ---- data $79D0-$79D5 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailView_Anim12Script:: ; 2B:79D0
Data_2B_79D0::
	db $02, $00, $2E, $01, $08

; ---- words $79D5-$79D9 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $79D9, $79F2 to OAM frames (extent = lowest target); referenced by an animation entry

MailView_Anim16Frames:: ; 2B:79D5
Table_2B_79D5::
	dw MailView_Anim16Frame0, MailView_Anim16Frame1

; ---- data $79D9-$79F2 (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim16Frame0:: ; 2B:79D9
Data_2B_79D9::
	db $06, $F5, $04, $00, $01, $F5, $0C, $01, $01, $F5, $14, $02, $01, $FD, $04, $10
	db $01, $FD, $0C, $11, $01, $FD, $14, $12, $01

; ---- data $79F2-$7A0B (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim16Frame1:: ; 2B:79F2
Data_2B_79F2::
	db $06, $F4, $04, $00, $01, $F4, $0C, $01, $01, $F4, $14, $02, $01, $FC, $04, $10
	db $01, $FC, $0C, $11, $01, $FC, $14, $12, $01

; ---- data $7A0B-$7A10 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailView_Anim16Script:: ; 2B:7A0B
Data_2B_7A0B::
	db $02, $00, $2E, $01, $08

; ---- words $7A10-$7A14 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $7A14, $7A2D to OAM frames (extent = lowest target); referenced by an animation entry

MailView_Anim20Frames:: ; 2B:7A10
Table_2B_7A10::
	dw MailView_Anim20Frame0, MailView_Anim20Frame1

; ---- data $7A14-$7A2D (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim20Frame0:: ; 2B:7A14
Data_2B_7A14::
	db $06, $F5, $05, $03, $01, $F5, $0D, $04, $01, $F5, $15, $05, $01, $FD, $05, $13
	db $01, $FD, $0D, $14, $01, $FD, $15, $15, $01

; ---- data $7A2D-$7A46 (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim20Frame1:: ; 2B:7A2D
Data_2B_7A2D::
	db $06, $F4, $05, $03, $01, $F4, $0D, $04, $01, $F4, $15, $05, $01, $FC, $05, $13
	db $01, $FC, $0D, $14, $01, $FC, $15, $15, $01

; ---- data $7A46-$7A4B (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailView_Anim20Script:: ; 2B:7A46
Data_2B_7A46::
	db $02, $00, $2E, $01, $08

; ---- words $7A4B-$7A4F (4 bytes) [PROBABLE] frame table: 2 pointer(s) $7A4F, $7A60 to OAM frames (extent = lowest target); referenced by an animation entry

MailView_Anim8Frames:: ; 2B:7A4B
Table_2B_7A4B::
	dw MailView_Anim8Frame0, MailView_Anim8Frame1

; ---- data $7A4F-$7A60 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim8Frame0:: ; 2B:7A4F
Data_2B_7A4F::
	db $04, $05, $05, $16, $02, $05, $13, $16, $22, $13, $05, $16, $42, $13, $13, $16
	db $62

; ---- data $7A60-$7A71 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim8Frame1:: ; 2B:7A60
Data_2B_7A60::
	db $04, $04, $04, $16, $02, $04, $14, $16, $22, $14, $04, $16, $42, $14, $14, $16
	db $62

; ---- data $7A71-$7A76 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailView_Anim8Script:: ; 2B:7A71
Data_2B_7A71::
	db $02, $00, $2E, $01, $08

; ---- words $7A76-$7A7A (4 bytes) [PROBABLE] frame table: 2 pointer(s) $7A7A, $7A93 to OAM frames (extent = lowest target); referenced by an animation entry

MailView_Anim24Frames:: ; 2B:7A76
Table_2B_7A76::
	dw MailView_Anim24Frame0, MailView_Anim24Frame1

; ---- data $7A7A-$7A93 (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim24Frame0:: ; 2B:7A7A
Data_2B_7A7A::
	db $06, $00, $00, $10, $03, $00, $08, $11, $03, $00, $10, $12, $03, $08, $00, $13
	db $03, $08, $08, $14, $03, $08, $10, $15, $03

; ---- data $7A93-$7A94 (1 bytes) [PROBABLE] OAM frame: count=0 then 0 x (y,x,tile,attr) = 1 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim24Frame1:: ; 2B:7A93
Data_2B_7A93::
	db $00

; ---- data $7A94-$7A97 (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 2e), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailView_Anim24Script:: ; 2B:7A94
Data_2B_7A94::
	db $01, $00, $2E

; ---- words $7A97-$7A9B (4 bytes) [PROBABLE] frame table: 2 pointer(s) $7A9B, $7ACC to OAM frames (extent = lowest target); referenced by an animation entry

MailView_Anim28Frames:: ; 2B:7A97
Table_2B_7A97::
	dw MailView_Anim28Frame0, MailView_Anim28Frame1

; ---- data $7A9B-$7ACC (49 bytes) [PROBABLE] OAM frame: count=12 then 12 x (y,x,tile,attr) = 49 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim28Frame0:: ; 2B:7A9B
Data_2B_7A9B::
	db $0C, $F5, $0D, $2D, $01, $F5, $15, $2E, $01, $FD, $0D, $30, $01, $FD, $15, $31
	db $01, $F5, $05, $2C, $01, $FD, $05, $2F, $01, $F5, $05, $1D, $01, $F5, $0D, $1E
	db $01, $F5, $15, $1F, $01, $FD, $05, $20, $01, $FD, $0D, $21, $01, $FD, $15, $22
	db $01

; ---- data $7ACC-$7AFD (49 bytes) [PROBABLE] OAM frame: count=12 then 12 x (y,x,tile,attr) = 49 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim28Frame1:: ; 2B:7ACC
Data_2B_7ACC::
	db $0C, $F4, $0D, $2D, $01, $F4, $15, $2E, $01, $FC, $0D, $30, $01, $FC, $15, $31
	db $01, $F4, $05, $2C, $01, $FC, $05, $2F, $01, $F4, $05, $1D, $01, $F4, $0D, $1E
	db $01, $F4, $15, $1F, $01, $FC, $05, $20, $01, $FC, $0D, $21, $01, $FC, $15, $22
	db $01

; ---- data $7AFD-$7B02 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailView_Anim28Script:: ; 2B:7AFD
Data_2B_7AFD::
	db $02, $00, $2E, $01, $08
