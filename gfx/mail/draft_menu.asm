; gfx/mail/draft_menu.asm
; bank 2B, $4880-$53C3 (2883 bytes); pinned by layout.link
; draft menu tiles, tilemap, palettes, animation tables

SECTION "gfx/mail/draft_menu", ROMX

; ---- gfx $4880-$4B50 (720 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2B:4265: hl=$4880 a=$2B c=$2D de=$9301 (dest VRAM $9300, vbank=1)

Gfx_MailDraftMenu_Tiles9300Vb1:: ; 2B:4880
Data_2B_4880::
	INCBIN "gfx/mail/draft_menu/mail_draft_menu_tiles9300.2bpp"

; ---- data $4B50-$4E20 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2B:4276: hl=$4B50 a=$2B b=18 rows c=20 cols (tiles then attrs) de=$D000

Data_MailDraftMenu_TilemapAttr:: ; 2B:4B50
Data_2B_4B50::
	INCBIN "gfx/mail/draft_menu/data_mail_draft_menu_tilemap_attr.tilemap"
	INCBIN "gfx/mail/draft_menu/data_mail_draft_menu_tilemap_attr.attrmap"

; ---- data $4E20-$4E60 (64 bytes) [PROBABLE] palette-rgb555: heuristic: 32 RGB555 words as 8 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Palette_MailDraftMenu_Bg:: ; 2B:4E20
Data_2B_4E20::
	INCLUDE "gfx/mail/draft_menu/mail_draft_menu_bg.pal"

; ---- gfx $4E60-$5190 (816 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2B:4242: hl=$4E60 a=$2B c=$33 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_MailDraftMenu_Tiles8000:: ; 2B:4E60
Data_2B_4E60::
	INCBIN "gfx/mail/draft_menu/mail_draft_menu_tiles8000.2bpp"

; ---- data $5190-$51D0 (64 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 4880-51D0 by higher-priority evidence]

Palette_MailDraftMenu_Obj:: ; 2B:5190
Data_2B_5190::
	INCLUDE "gfx/mail/draft_menu/mail_draft_menu_obj.pal"

; ---- words $51D0-$5240 (112 bytes) [PROBABLE] animation entry table: 28 entries of 4 bytes (frame-table pointer, script pointer), each animation repeated 4x; format of the sprite-slot initialiser 00:0A82/0AB8 (entry at DE+4*(A&$3F) -> slot[2..3] frame table, slot[6..7] script)

Table_MailDraftMenu_Anims:: ; 2B:51D0
Table_2B_51D0::
	sprite_object_entry MailDraftMenu_Anim0Frames, MailDraftMenu_Anim0Script ; entry 0
	sprite_object_entry MailDraftMenu_Anim0Frames, MailDraftMenu_Anim0Script ; entry 1
	sprite_object_entry MailDraftMenu_Anim0Frames, MailDraftMenu_Anim0Script ; entry 2
	sprite_object_entry MailDraftMenu_Anim0Frames, MailDraftMenu_Anim0Script ; entry 3
Table_MailDraftMenu_Anims_Entry4:: ; 2B:51E0
	sprite_object_entry MailDraftMenu_Anim4Frames, MailDraftMenu_Anim4Script ; entry 4
	sprite_object_entry MailDraftMenu_Anim4Frames, MailDraftMenu_Anim4Script ; entry 5
	sprite_object_entry MailDraftMenu_Anim4Frames, MailDraftMenu_Anim4Script ; entry 6
	sprite_object_entry MailDraftMenu_Anim4Frames, MailDraftMenu_Anim4Script ; entry 7
Table_MailDraftMenu_Anims_Entry8:: ; 2B:51F0
	sprite_object_entry MailDraftMenu_Anim8Frames, MailDraftMenu_Anim8Script ; entry 8
	sprite_object_entry MailDraftMenu_Anim8Frames, MailDraftMenu_Anim8Script ; entry 9
	sprite_object_entry MailDraftMenu_Anim8Frames, MailDraftMenu_Anim8Script ; entry 10
	sprite_object_entry MailDraftMenu_Anim8Frames, MailDraftMenu_Anim8Script ; entry 11
Table_MailDraftMenu_Anims_Entry12:: ; 2B:5200
	sprite_object_entry MailDraftMenu_Anim12Frames, MailDraftMenu_Anim12Script ; entry 12
	sprite_object_entry MailDraftMenu_Anim12Frames, MailDraftMenu_Anim12Script ; entry 13
	sprite_object_entry MailDraftMenu_Anim12Frames, MailDraftMenu_Anim12Script ; entry 14
	sprite_object_entry MailDraftMenu_Anim12Frames, MailDraftMenu_Anim12Script ; entry 15
Table_MailDraftMenu_Anims_Entry16:: ; 2B:5210
	sprite_object_entry MailDraftMenu_Anim16Frames, MailDraftMenu_Anim16Script ; entry 16
	sprite_object_entry MailDraftMenu_Anim16Frames, MailDraftMenu_Anim16Script ; entry 17
	sprite_object_entry MailDraftMenu_Anim16Frames, MailDraftMenu_Anim16Script ; entry 18
	sprite_object_entry MailDraftMenu_Anim16Frames, MailDraftMenu_Anim16Script ; entry 19
Table_MailDraftMenu_Anims_Entry20:: ; 2B:5220
	sprite_object_entry MailDraftMenu_Anim20Frames, MailDraftMenu_Anim20Script ; entry 20
	sprite_object_entry MailDraftMenu_Anim20Frames, MailDraftMenu_Anim20Script ; entry 21
	sprite_object_entry MailDraftMenu_Anim20Frames, MailDraftMenu_Anim20Script ; entry 22
	sprite_object_entry MailDraftMenu_Anim20Frames, MailDraftMenu_Anim20Script ; entry 23
Table_MailDraftMenu_Anims_Entry24:: ; 2B:5230
	sprite_object_entry MailDraftMenu_Anim24Frames, MailDraftMenu_Anim24Script ; entry 24
	sprite_object_entry MailDraftMenu_Anim24Frames, MailDraftMenu_Anim24Script ; entry 25
	sprite_object_entry MailDraftMenu_Anim24Frames, MailDraftMenu_Anim24Script ; entry 26
	sprite_object_entry MailDraftMenu_Anim24Frames, MailDraftMenu_Anim24Script ; entry 27

; ---- words $5240-$5244 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $5244, $5269 to OAM frames (extent = lowest target); referenced by an animation entry

MailDraftMenu_Anim24Frames:: ; 2B:5240
Table_2B_5240::
	sprite_frame_table MailDraftMenu_Anim24Frame0, MailDraftMenu_Anim24Frame1

; ---- data $5244-$5269 (37 bytes) [PROBABLE] OAM frame: count=9 then 9 x (y,x,tile,attr) = 37 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim24Frame0:: ; 2B:5244
Data_2B_5244::
	sprite_frame 9
	sprite_oam 0, 0, $1A, 3
	sprite_oam 0, 8, $1B, 3
	sprite_oam 0, 16, $1C, 3
	sprite_oam 0, 24, $1D, 3
	sprite_oam 8, 0, $2A, 3
	sprite_oam 8, 8, $2B, 3
	sprite_oam 8, 16, $2C, 3
	sprite_oam 8, 24, $2D, 3
	sprite_oam 8, 32, $2E, 3

; ---- data $5269-$526A (1 bytes) [PROBABLE] OAM frame: count=0 then 0 x (y,x,tile,attr) = 1 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim24Frame1:: ; 2B:5269
Data_2B_5269::
	sprite_frame 0

; ---- data $526A-$526D (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 2e), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailDraftMenu_Anim24Script:: ; 2B:526A
Data_2B_526A::
	sprite_anim 1
	sprite_anim_step 0, 46

; ---- words $526D-$5271 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $5271, $5282 to OAM frames (extent = lowest target); referenced by an animation entry

MailDraftMenu_Anim8Frames:: ; 2B:526D
Table_2B_526D::
	sprite_frame_table MailDraftMenu_Anim8Frame0, MailDraftMenu_Anim8Frame1

; ---- data $5271-$5282 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim8Frame0:: ; 2B:5271
Data_2B_5271::
	sprite_frame 4
	sprite_oam 6, 6, $0F, 1
	sprite_oam 6, 18, $0F, OAMF_XFLIP | 1
	sprite_oam 18, 6, $0F, OAMF_YFLIP | 1
	sprite_oam 18, 18, $0F, OAMF_YFLIP | OAMF_XFLIP | 1

; ---- data $5282-$5293 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim8Frame1:: ; 2B:5282
Data_2B_5282::
	sprite_frame 4
	sprite_oam 5, 5, $0F, 1
	sprite_oam 5, 19, $0F, OAMF_XFLIP | 1
	sprite_oam 19, 5, $0F, OAMF_YFLIP | 1
	sprite_oam 19, 19, $0F, OAMF_YFLIP | OAMF_XFLIP | 1

; ---- data $5293-$5298 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailDraftMenu_Anim8Script:: ; 2B:5293
Data_2B_5293::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $5298-$529C (4 bytes) [PROBABLE] frame table: 2 pointer(s) $529C, $52A9 to OAM frames (extent = lowest target); referenced by an animation entry

MailDraftMenu_Anim12Frames:: ; 2B:5298
Table_2B_5298::
	sprite_frame_table MailDraftMenu_Anim12Frame0, MailDraftMenu_Anim12Frame1

; ---- data $529C-$52A9 (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim12Frame0:: ; 2B:529C
Data_2B_529C::
	sprite_frame 3
	sprite_oam -3, 4, $00, 1
	sprite_oam -3, 12, $01, 1
	sprite_oam -3, 20, $02, 1

; ---- data $52A9-$52B6 (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim12Frame1:: ; 2B:52A9
Data_2B_52A9::
	sprite_frame 3
	sprite_oam -3, 4, $00, 1
	sprite_oam -3, 12, $01, 1
	sprite_oam -3, 20, $02, 1

; ---- data $52B6-$52BB (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailDraftMenu_Anim12Script:: ; 2B:52B6
Data_2B_52B6::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $52BB-$52BF (4 bytes) [PROBABLE] frame table: 2 pointer(s) $52BF, $52CC to OAM frames (extent = lowest target); referenced by an animation entry

MailDraftMenu_Anim16Frames:: ; 2B:52BB
Table_2B_52BB::
	sprite_frame_table MailDraftMenu_Anim16Frame0, MailDraftMenu_Anim16Frame1

; ---- data $52BF-$52CC (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim16Frame0:: ; 2B:52BF
Data_2B_52BF::
	sprite_frame 3
	sprite_oam -3, 4, $10, 1
	sprite_oam -3, 12, $11, 1
	sprite_oam -3, 20, $12, 1

; ---- data $52CC-$52D9 (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim16Frame1:: ; 2B:52CC
Data_2B_52CC::
	sprite_frame 3
	sprite_oam -3, 4, $10, 1
	sprite_oam -3, 12, $11, 1
	sprite_oam -3, 20, $12, 1

; ---- data $52D9-$52DE (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailDraftMenu_Anim16Script:: ; 2B:52D9
Data_2B_52D9::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $52DE-$52E2 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $52E2, $52EF to OAM frames (extent = lowest target); referenced by an animation entry

MailDraftMenu_Anim20Frames:: ; 2B:52DE
Table_2B_52DE::
	sprite_frame_table MailDraftMenu_Anim20Frame0, MailDraftMenu_Anim20Frame1

; ---- data $52E2-$52EF (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim20Frame0:: ; 2B:52E2
Data_2B_52E2::
	sprite_frame 3
	sprite_oam -3, 4, $03, 1
	sprite_oam -3, 12, $04, 1
	sprite_oam -3, 20, $05, 1

; ---- data $52EF-$52FC (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim20Frame1:: ; 2B:52EF
Data_2B_52EF::
	sprite_frame 3
	sprite_oam -3, 4, $03, 1
	sprite_oam -3, 12, $04, 1
	sprite_oam -3, 20, $05, 1

; ---- data $52FC-$5301 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailDraftMenu_Anim20Script:: ; 2B:52FC
Data_2B_52FC::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $5301-$5305 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $5305, $5336 to OAM frames (extent = lowest target); referenced by an animation entry

MailDraftMenu_Anim0Frames:: ; 2B:5301
Table_2B_5301::
	sprite_frame_table MailDraftMenu_Anim0Frame0, MailDraftMenu_Anim0Frame1

; ---- data $5305-$5336 (49 bytes) [PROBABLE] OAM frame: count=12 then 12 x (y,x,tile,attr) = 49 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim0Frame0:: ; 2B:5305
Data_2B_5305::
	sprite_frame 12
	sprite_oam 16, 0, $09, 2
	sprite_oam 16, 8, $0A, 2
	sprite_oam 16, 16, $0B, 2
	sprite_oam 8, 0, $06, 3
	sprite_oam 8, 8, $07, 3
	sprite_oam 8, 16, $08, 3
	sprite_oam 16, 0, $16, 3
	sprite_oam 16, 8, $17, 3
	sprite_oam 16, 16, $18, 3
	sprite_oam 0, 0, $13, 3
	sprite_oam 0, 8, $14, 3
	sprite_oam 0, 16, $15, 3

; ---- data $5336-$5367 (49 bytes) [PROBABLE] OAM frame: count=12 then 12 x (y,x,tile,attr) = 49 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim0Frame1:: ; 2B:5336
Data_2B_5336::
	sprite_frame 12
	sprite_oam 16, 0, $09, 2
	sprite_oam 16, 8, $0A, 2
	sprite_oam 16, 16, $0B, 2
	sprite_oam 0, 0, $13, 4
	sprite_oam 0, 8, $14, 4
	sprite_oam 0, 16, $15, 4
	sprite_oam 8, 0, $26, 4
	sprite_oam 8, 8, $27, 4
	sprite_oam 8, 16, $28, 4
	sprite_oam 16, 0, $29, 4
	sprite_oam 16, 8, $2A, 4
	sprite_oam 16, 16, $2B, 4

; ---- data $5367-$536A (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 2e), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailDraftMenu_Anim0Script:: ; 2B:5367
Data_2B_5367::
	sprite_anim 1
	sprite_anim_step 0, 46

; ---- words $536A-$536E (4 bytes) [PROBABLE] frame table: 2 pointer(s) $536E, $5397 to OAM frames (extent = lowest target); referenced by an animation entry

MailDraftMenu_Anim4Frames:: ; 2B:536A
Table_2B_536A::
	sprite_frame_table MailDraftMenu_Anim4Frame0, MailDraftMenu_Anim4Frame1

; ---- data $536E-$5397 (41 bytes) [PROBABLE] OAM frame: count=10 then 10 x (y,x,tile,attr) = 41 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim4Frame0:: ; 2B:536E
Data_2B_536E::
	sprite_frame 10
	sprite_oam 0, 0, $23, 0
	sprite_oam 0, 8, $24, 0
	sprite_oam 0, 16, $25, 0
	sprite_oam 8, 0, $26, 0
	sprite_oam 8, 8, $27, 0
	sprite_oam 8, 16, $28, 0
	sprite_oam 16, 0, $0C, 2
	sprite_oam 16, 8, $0D, 2
	sprite_oam 16, 16, $0E, 2
	sprite_oam 16, 8, $29, 0

; ---- data $5397-$53C0 (41 bytes) [PROBABLE] OAM frame: count=10 then 10 x (y,x,tile,attr) = 41 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim4Frame1:: ; 2B:5397
Data_2B_5397::
	sprite_frame 10
	sprite_oam 16, 0, $0C, 2
	sprite_oam 16, 8, $0D, 2
	sprite_oam 16, 16, $0E, 2
	sprite_oam 0, 0, $2C, 0
	sprite_oam 0, 8, $2D, 0
	sprite_oam 0, 16, $2E, 0
	sprite_oam 8, 0, $30, 0
	sprite_oam 8, 8, $31, 0
	sprite_oam 8, 16, $32, 0
	sprite_oam 16, 8, $2F, 0

; ---- data $53C0-$53C3 (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 2e), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailDraftMenu_Anim4Script:: ; 2B:53C0
Data_2B_53C0::
	sprite_anim 1
	sprite_anim_step 0, 46
