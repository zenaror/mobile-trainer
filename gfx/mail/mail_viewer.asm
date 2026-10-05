; gfx/mail/mail_viewer.asm
; bank 2B, $6DD0-$7B02 (3378 bytes); pinned by layout.link
; viewer tiles, tilemap, palettes, animation tables

SECTION "gfx/mail/mail_viewer", ROMX

; ---- gfx $6DD0-$71D0 (1024 bytes) [CONFIRMED] 64 tiles: 'ld de,$9001 ; ld hl,$6DD0 ; ld a,$2B ; ld c,$40 ; call FarCall -> 00:0749 (HDMA rom->vram)' at 2B:6620-6631; merges the former zero-run / UNCLASSIFIED fragments (blank rows are tile content) [every byte read as data in 9 scenario(s)]

Gfx_MailView_Tiles9000Vb1:: ; 2B:6DD0
Tiles_2B_6DD0::
	INCBIN "gfx/mail/mail_viewer/mail_view_tiles9000.2bpp"

; ---- gfx $71D0-$73D0 (512 bytes) [PROBABLE] 32 tiles: 'ld de,$9401 ; ld hl,$71D0 ; ld a,$2B ; ld c,$20 ; HDMA' at 2B:6635-6646; ends where the tilemap+attr block at 73D0 begins

Gfx_MailView_Tiles9400Vb1:: ; 2B:71D0
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
	sprite_object_entry MailView_Anim0Frames, MailView_Anim0Script ; entry 0
	sprite_object_entry MailView_Anim0Frames, MailView_Anim0Script ; entry 1
	sprite_object_entry MailView_Anim0Frames, MailView_Anim0Script ; entry 2
	sprite_object_entry MailView_Anim0Frames, MailView_Anim0Script ; entry 3
	sprite_object_entry MailView_Anim4Frames, MailView_Anim4Script ; entry 4
	sprite_object_entry MailView_Anim4Frames, MailView_Anim4Script ; entry 5
	sprite_object_entry MailView_Anim4Frames, MailView_Anim4Script ; entry 6
	sprite_object_entry MailView_Anim4Frames, MailView_Anim4Script ; entry 7
	sprite_object_entry MailView_Anim8Frames, MailView_Anim8Script ; entry 8
	sprite_object_entry MailView_Anim8Frames, MailView_Anim8Script ; entry 9
	sprite_object_entry MailView_Anim8Frames, MailView_Anim8Script ; entry 10
	sprite_object_entry MailView_Anim8Frames, MailView_Anim8Script ; entry 11
	sprite_object_entry MailView_Anim12Frames, MailView_Anim12Script ; entry 12
	sprite_object_entry MailView_Anim12Frames, MailView_Anim12Script ; entry 13
	sprite_object_entry MailView_Anim12Frames, MailView_Anim12Script ; entry 14
	sprite_object_entry MailView_Anim12Frames, MailView_Anim12Script ; entry 15
	sprite_object_entry MailView_Anim16Frames, MailView_Anim16Script ; entry 16
	sprite_object_entry MailView_Anim16Frames, MailView_Anim16Script ; entry 17
	sprite_object_entry MailView_Anim16Frames, MailView_Anim16Script ; entry 18
	sprite_object_entry MailView_Anim16Frames, MailView_Anim16Script ; entry 19
	sprite_object_entry MailView_Anim20Frames, MailView_Anim20Script ; entry 20
	sprite_object_entry MailView_Anim20Frames, MailView_Anim20Script ; entry 21
	sprite_object_entry MailView_Anim20Frames, MailView_Anim20Script ; entry 22
	sprite_object_entry MailView_Anim20Frames, MailView_Anim20Script ; entry 23
	sprite_object_entry MailView_Anim24Frames, MailView_Anim24Script ; entry 24
	sprite_object_entry MailView_Anim24Frames, MailView_Anim24Script ; entry 25
	sprite_object_entry MailView_Anim24Frames, MailView_Anim24Script ; entry 26
	sprite_object_entry MailView_Anim24Frames, MailView_Anim24Script ; entry 27
	sprite_object_entry MailView_Anim28Frames, MailView_Anim28Script ; entry 28
	sprite_object_entry MailView_Anim28Frames, MailView_Anim28Script ; entry 29
	sprite_object_entry MailView_Anim28Frames, MailView_Anim28Script ; entry 30
	sprite_object_entry MailView_Anim28Frames, MailView_Anim28Script ; entry 31

; ---- words $7920-$7924 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $7924, $7955 to OAM frames (extent = lowest target); referenced by an animation entry

MailView_Anim0Frames:: ; 2B:7920
Table_2B_7920::
	sprite_frame_table MailView_Anim0Frame0, MailView_Anim0Frame1

; ---- data $7924-$7955 (49 bytes) [PROBABLE] OAM frame: count=12 then 12 x (y,x,tile,attr) = 49 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim0Frame0:: ; 2B:7924
Data_2B_7924::
	sprite_frame 12
	sprite_oam 16, 0, $09, 2
	sprite_oam 16, 8, $0A, 2
	sprite_oam 16, 16, $0B, 2
	sprite_oam 16, 0, $06, 4
	sprite_oam 16, 8, $07, 4
	sprite_oam 16, 16, $08, 4
	sprite_oam 8, 0, $03, 4
	sprite_oam 8, 8, $04, 4
	sprite_oam 8, 16, $05, 4
	sprite_oam 0, 0, $00, 4
	sprite_oam 0, 8, $01, 4
	sprite_oam 0, 16, $02, 4

; ---- data $7955-$7986 (49 bytes) [PROBABLE] OAM frame: count=12 then 12 x (y,x,tile,attr) = 49 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim0Frame1:: ; 2B:7955
Data_2B_7955::
	sprite_frame 12
	sprite_oam 16, 0, $06, 2
	sprite_oam 16, 8, $07, 2
	sprite_oam 16, 16, $08, 2
	sprite_oam 0, 0, $29, 4
	sprite_oam 0, 8, $2A, 4
	sprite_oam 0, 16, $2B, 4
	sprite_oam 8, 0, $00, 4
	sprite_oam 8, 8, $01, 4
	sprite_oam 8, 16, $02, 4
	sprite_oam 16, 0, $26, 4
	sprite_oam 16, 8, $27, 4
	sprite_oam 16, 16, $28, 4

; ---- data $7986-$7989 (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 2e), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailView_Anim0Script:: ; 2B:7986
Data_2B_7986::
	sprite_anim 1
	sprite_anim_step 0, 46

; ---- words $7989-$798D (4 bytes) [PROBABLE] frame table: 2 pointer(s) $798D, $799A to OAM frames (extent = lowest target); referenced by an animation entry

MailView_Anim4Frames:: ; 2B:7989
Table_2B_7989::
	sprite_frame_table MailView_Anim4Frame0, MailView_Anim4Frame1

; ---- data $798D-$799A (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim4Frame0:: ; 2B:798D
Data_2B_798D::
	sprite_frame 3
	sprite_oam 16, 0, $0C, 2
	sprite_oam 16, 8, $0D, 2
	sprite_oam 16, 16, $0E, 2

; ---- data $799A-$79A7 (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim4Frame1:: ; 2B:799A
Data_2B_799A::
	sprite_frame 3
	sprite_oam 16, 0, $09, 2
	sprite_oam 16, 8, $0A, 2
	sprite_oam 16, 16, $0B, 2

; ---- data $79A7-$79AA (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 2e), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailView_Anim4Script:: ; 2B:79A7
Data_2B_79A7::
	sprite_anim 1
	sprite_anim_step 0, 46

; ---- words $79AA-$79AE (4 bytes) [PROBABLE] frame table: 2 pointer(s) $79AE, $79BF to OAM frames (extent = lowest target); referenced by an animation entry

MailView_Anim12Frames:: ; 2B:79AA
Table_2B_79AA::
	sprite_frame_table MailView_Anim12Frame0, MailView_Anim12Frame1

; ---- data $79AE-$79BF (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim12Frame0:: ; 2B:79AE
Data_2B_79AE::
	sprite_frame 4
	sprite_oam -11, 8, $0C, 1
	sprite_oam -11, 16, $0D, 1
	sprite_oam -3, 8, $0E, 1
	sprite_oam -3, 16, $0F, 1

; ---- data $79BF-$79D0 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim12Frame1:: ; 2B:79BF
Data_2B_79BF::
	sprite_frame 4
	sprite_oam -12, 8, $0C, 1
	sprite_oam -12, 16, $0D, 1
	sprite_oam -4, 8, $0E, 1
	sprite_oam -4, 16, $0F, 1

; ---- data $79D0-$79D5 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailView_Anim12Script:: ; 2B:79D0
Data_2B_79D0::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $79D5-$79D9 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $79D9, $79F2 to OAM frames (extent = lowest target); referenced by an animation entry

MailView_Anim16Frames:: ; 2B:79D5
Table_2B_79D5::
	sprite_frame_table MailView_Anim16Frame0, MailView_Anim16Frame1

; ---- data $79D9-$79F2 (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim16Frame0:: ; 2B:79D9
Data_2B_79D9::
	sprite_frame 6
	sprite_oam -11, 4, $00, 1
	sprite_oam -11, 12, $01, 1
	sprite_oam -11, 20, $02, 1
	sprite_oam -3, 4, $10, 1
	sprite_oam -3, 12, $11, 1
	sprite_oam -3, 20, $12, 1

; ---- data $79F2-$7A0B (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim16Frame1:: ; 2B:79F2
Data_2B_79F2::
	sprite_frame 6
	sprite_oam -12, 4, $00, 1
	sprite_oam -12, 12, $01, 1
	sprite_oam -12, 20, $02, 1
	sprite_oam -4, 4, $10, 1
	sprite_oam -4, 12, $11, 1
	sprite_oam -4, 20, $12, 1

; ---- data $7A0B-$7A10 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailView_Anim16Script:: ; 2B:7A0B
Data_2B_7A0B::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $7A10-$7A14 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $7A14, $7A2D to OAM frames (extent = lowest target); referenced by an animation entry

MailView_Anim20Frames:: ; 2B:7A10
Table_2B_7A10::
	sprite_frame_table MailView_Anim20Frame0, MailView_Anim20Frame1

; ---- data $7A14-$7A2D (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim20Frame0:: ; 2B:7A14
Data_2B_7A14::
	sprite_frame 6
	sprite_oam -11, 5, $03, 1
	sprite_oam -11, 13, $04, 1
	sprite_oam -11, 21, $05, 1
	sprite_oam -3, 5, $13, 1
	sprite_oam -3, 13, $14, 1
	sprite_oam -3, 21, $15, 1

; ---- data $7A2D-$7A46 (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim20Frame1:: ; 2B:7A2D
Data_2B_7A2D::
	sprite_frame 6
	sprite_oam -12, 5, $03, 1
	sprite_oam -12, 13, $04, 1
	sprite_oam -12, 21, $05, 1
	sprite_oam -4, 5, $13, 1
	sprite_oam -4, 13, $14, 1
	sprite_oam -4, 21, $15, 1

; ---- data $7A46-$7A4B (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailView_Anim20Script:: ; 2B:7A46
Data_2B_7A46::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $7A4B-$7A4F (4 bytes) [PROBABLE] frame table: 2 pointer(s) $7A4F, $7A60 to OAM frames (extent = lowest target); referenced by an animation entry

MailView_Anim8Frames:: ; 2B:7A4B
Table_2B_7A4B::
	sprite_frame_table MailView_Anim8Frame0, MailView_Anim8Frame1

; ---- data $7A4F-$7A60 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim8Frame0:: ; 2B:7A4F
Data_2B_7A4F::
	sprite_frame 4
	sprite_oam 5, 5, $16, 2
	sprite_oam 5, 19, $16, OAMF_XFLIP | 2
	sprite_oam 19, 5, $16, OAMF_YFLIP | 2
	sprite_oam 19, 19, $16, OAMF_YFLIP | OAMF_XFLIP | 2

; ---- data $7A60-$7A71 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim8Frame1:: ; 2B:7A60
Data_2B_7A60::
	sprite_frame 4
	sprite_oam 4, 4, $16, 2
	sprite_oam 4, 20, $16, OAMF_XFLIP | 2
	sprite_oam 20, 4, $16, OAMF_YFLIP | 2
	sprite_oam 20, 20, $16, OAMF_YFLIP | OAMF_XFLIP | 2

; ---- data $7A71-$7A76 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailView_Anim8Script:: ; 2B:7A71
Data_2B_7A71::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $7A76-$7A7A (4 bytes) [PROBABLE] frame table: 2 pointer(s) $7A7A, $7A93 to OAM frames (extent = lowest target); referenced by an animation entry

MailView_Anim24Frames:: ; 2B:7A76
Table_2B_7A76::
	sprite_frame_table MailView_Anim24Frame0, MailView_Anim24Frame1

; ---- data $7A7A-$7A93 (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim24Frame0:: ; 2B:7A7A
Data_2B_7A7A::
	sprite_frame 6
	sprite_oam 0, 0, $10, 3
	sprite_oam 0, 8, $11, 3
	sprite_oam 0, 16, $12, 3
	sprite_oam 8, 0, $13, 3
	sprite_oam 8, 8, $14, 3
	sprite_oam 8, 16, $15, 3

; ---- data $7A93-$7A94 (1 bytes) [PROBABLE] OAM frame: count=0 then 0 x (y,x,tile,attr) = 1 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim24Frame1:: ; 2B:7A93
Data_2B_7A93::
	sprite_frame 0

; ---- data $7A94-$7A97 (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 2e), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailView_Anim24Script:: ; 2B:7A94
Data_2B_7A94::
	sprite_anim 1
	sprite_anim_step 0, 46

; ---- words $7A97-$7A9B (4 bytes) [PROBABLE] frame table: 2 pointer(s) $7A9B, $7ACC to OAM frames (extent = lowest target); referenced by an animation entry

MailView_Anim28Frames:: ; 2B:7A97
Table_2B_7A97::
	sprite_frame_table MailView_Anim28Frame0, MailView_Anim28Frame1

; ---- data $7A9B-$7ACC (49 bytes) [PROBABLE] OAM frame: count=12 then 12 x (y,x,tile,attr) = 49 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim28Frame0:: ; 2B:7A9B
Data_2B_7A9B::
	sprite_frame 12
	sprite_oam -11, 13, $2D, 1
	sprite_oam -11, 21, $2E, 1
	sprite_oam -3, 13, $30, 1
	sprite_oam -3, 21, $31, 1
	sprite_oam -11, 5, $2C, 1
	sprite_oam -3, 5, $2F, 1
	sprite_oam -11, 5, $1D, 1
	sprite_oam -11, 13, $1E, 1
	sprite_oam -11, 21, $1F, 1
	sprite_oam -3, 5, $20, 1
	sprite_oam -3, 13, $21, 1
	sprite_oam -3, 21, $22, 1

; ---- data $7ACC-$7AFD (49 bytes) [PROBABLE] OAM frame: count=12 then 12 x (y,x,tile,attr) = 49 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailView_Anim28Frame1:: ; 2B:7ACC
Data_2B_7ACC::
	sprite_frame 12
	sprite_oam -12, 13, $2D, 1
	sprite_oam -12, 21, $2E, 1
	sprite_oam -4, 13, $30, 1
	sprite_oam -4, 21, $31, 1
	sprite_oam -12, 5, $2C, 1
	sprite_oam -4, 5, $2F, 1
	sprite_oam -12, 5, $1D, 1
	sprite_oam -12, 13, $1E, 1
	sprite_oam -12, 21, $1F, 1
	sprite_oam -4, 5, $20, 1
	sprite_oam -4, 13, $21, 1
	sprite_oam -4, 21, $22, 1

; ---- data $7AFD-$7B02 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailView_Anim28Script:: ; 2B:7AFD
Data_2B_7AFD::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
