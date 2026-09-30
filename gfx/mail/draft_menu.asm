; gfx/mail/draft_menu.asm
; bank 2B, $4880-$53C3 (2883 bytes); pinned by layout.link
; draft menu tiles, tilemap, palettes, animation tables

SECTION "gfx/mail/draft_menu", ROMX

; ---- gfx $4880-$4B50 (720 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2B:4265: hl=$4880 a=$2B c=$2D de=$9301 (dest VRAM $9300, vbank=1)

Gfx_MailDraftMenu_Tiles9300:: ; 2B:4880
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

; ---- words $51D0-$5240 (112 bytes) [PROBABLE] animation entry table: 28 entries of 4 bytes (frame-table pointer, script pointer), each animation repeated 4x; format of the sprite-slot initialiser 00:0A82/0AB8 (entry at DE+4*(A&$7F) -> slot[2..3] frame table, slot[6..7] script)

Table_MailDraftMenu_Anims:: ; 2B:51D0
Table_2B_51D0::
	dw MailDraftMenu_Anim0Frames, MailDraftMenu_Anim0Script, MailDraftMenu_Anim0Frames, MailDraftMenu_Anim0Script, MailDraftMenu_Anim0Frames, MailDraftMenu_Anim0Script, MailDraftMenu_Anim0Frames, MailDraftMenu_Anim0Script
	dw MailDraftMenu_Anim4Frames, MailDraftMenu_Anim4Script, MailDraftMenu_Anim4Frames, MailDraftMenu_Anim4Script, MailDraftMenu_Anim4Frames, MailDraftMenu_Anim4Script, MailDraftMenu_Anim4Frames, MailDraftMenu_Anim4Script
	dw MailDraftMenu_Anim8Frames, MailDraftMenu_Anim8Script, MailDraftMenu_Anim8Frames, MailDraftMenu_Anim8Script, MailDraftMenu_Anim8Frames, MailDraftMenu_Anim8Script, MailDraftMenu_Anim8Frames, MailDraftMenu_Anim8Script
	dw MailDraftMenu_Anim12Frames, MailDraftMenu_Anim12Script, MailDraftMenu_Anim12Frames, MailDraftMenu_Anim12Script, MailDraftMenu_Anim12Frames, MailDraftMenu_Anim12Script, MailDraftMenu_Anim12Frames, MailDraftMenu_Anim12Script
	dw MailDraftMenu_Anim16Frames, MailDraftMenu_Anim16Script, MailDraftMenu_Anim16Frames, MailDraftMenu_Anim16Script, MailDraftMenu_Anim16Frames, MailDraftMenu_Anim16Script, MailDraftMenu_Anim16Frames, MailDraftMenu_Anim16Script
	dw MailDraftMenu_Anim20Frames, MailDraftMenu_Anim20Script, MailDraftMenu_Anim20Frames, MailDraftMenu_Anim20Script, MailDraftMenu_Anim20Frames, MailDraftMenu_Anim20Script, MailDraftMenu_Anim20Frames, MailDraftMenu_Anim20Script
	dw MailDraftMenu_Anim24Frames, MailDraftMenu_Anim24Script, MailDraftMenu_Anim24Frames, MailDraftMenu_Anim24Script, MailDraftMenu_Anim24Frames, MailDraftMenu_Anim24Script, MailDraftMenu_Anim24Frames, MailDraftMenu_Anim24Script

; ---- words $5240-$5244 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $5244, $5269 to OAM frames (extent = lowest target); referenced by an animation entry

MailDraftMenu_Anim24Frames:: ; 2B:5240
Table_2B_5240::
	dw MailDraftMenu_Anim24Frame0, MailDraftMenu_Anim24Frame1

; ---- data $5244-$5269 (37 bytes) [PROBABLE] OAM frame: count=9 then 9 x (y,x,tile,attr) = 37 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim24Frame0:: ; 2B:5244
Data_2B_5244::
	db $09, $00, $00, $1A, $03, $00, $08, $1B, $03, $00, $10, $1C, $03, $00, $18, $1D
	db $03, $08, $00, $2A, $03, $08, $08, $2B, $03, $08, $10, $2C, $03, $08, $18, $2D
	db $03, $08, $20, $2E, $03

; ---- data $5269-$526A (1 bytes) [PROBABLE] OAM frame: count=0 then 0 x (y,x,tile,attr) = 1 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim24Frame1:: ; 2B:5269
Data_2B_5269::
	db $00

; ---- data $526A-$526D (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 2e), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailDraftMenu_Anim24Script:: ; 2B:526A
Data_2B_526A::
	db $01, $00, $2E

; ---- words $526D-$5271 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $5271, $5282 to OAM frames (extent = lowest target); referenced by an animation entry

MailDraftMenu_Anim8Frames:: ; 2B:526D
Table_2B_526D::
	dw MailDraftMenu_Anim8Frame0, MailDraftMenu_Anim8Frame1

; ---- data $5271-$5282 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim8Frame0:: ; 2B:5271
Data_2B_5271::
	db $04, $06, $06, $0F, $01, $06, $12, $0F, $21, $12, $06, $0F, $41, $12, $12, $0F
	db $61

; ---- data $5282-$5293 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim8Frame1:: ; 2B:5282
Data_2B_5282::
	db $04, $05, $05, $0F, $01, $05, $13, $0F, $21, $13, $05, $0F, $41, $13, $13, $0F
	db $61

; ---- data $5293-$5298 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailDraftMenu_Anim8Script:: ; 2B:5293
Data_2B_5293::
	db $02, $00, $2E, $01, $08

; ---- words $5298-$529C (4 bytes) [PROBABLE] frame table: 2 pointer(s) $529C, $52A9 to OAM frames (extent = lowest target); referenced by an animation entry

MailDraftMenu_Anim12Frames:: ; 2B:5298
Table_2B_5298::
	dw MailDraftMenu_Anim12Frame0, MailDraftMenu_Anim12Frame1

; ---- data $529C-$52A9 (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim12Frame0:: ; 2B:529C
Data_2B_529C::
	db $03, $FD, $04, $00, $01, $FD, $0C, $01, $01, $FD, $14, $02, $01

; ---- data $52A9-$52B6 (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim12Frame1:: ; 2B:52A9
Data_2B_52A9::
	db $03, $FD, $04, $00, $01, $FD, $0C, $01, $01, $FD, $14, $02, $01

; ---- data $52B6-$52BB (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailDraftMenu_Anim12Script:: ; 2B:52B6
Data_2B_52B6::
	db $02, $00, $2E, $01, $08

; ---- words $52BB-$52BF (4 bytes) [PROBABLE] frame table: 2 pointer(s) $52BF, $52CC to OAM frames (extent = lowest target); referenced by an animation entry

MailDraftMenu_Anim16Frames:: ; 2B:52BB
Table_2B_52BB::
	dw MailDraftMenu_Anim16Frame0, MailDraftMenu_Anim16Frame1

; ---- data $52BF-$52CC (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim16Frame0:: ; 2B:52BF
Data_2B_52BF::
	db $03, $FD, $04, $10, $01, $FD, $0C, $11, $01, $FD, $14, $12, $01

; ---- data $52CC-$52D9 (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim16Frame1:: ; 2B:52CC
Data_2B_52CC::
	db $03, $FD, $04, $10, $01, $FD, $0C, $11, $01, $FD, $14, $12, $01

; ---- data $52D9-$52DE (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailDraftMenu_Anim16Script:: ; 2B:52D9
Data_2B_52D9::
	db $02, $00, $2E, $01, $08

; ---- words $52DE-$52E2 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $52E2, $52EF to OAM frames (extent = lowest target); referenced by an animation entry

MailDraftMenu_Anim20Frames:: ; 2B:52DE
Table_2B_52DE::
	dw MailDraftMenu_Anim20Frame0, MailDraftMenu_Anim20Frame1

; ---- data $52E2-$52EF (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim20Frame0:: ; 2B:52E2
Data_2B_52E2::
	db $03, $FD, $04, $03, $01, $FD, $0C, $04, $01, $FD, $14, $05, $01

; ---- data $52EF-$52FC (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim20Frame1:: ; 2B:52EF
Data_2B_52EF::
	db $03, $FD, $04, $03, $01, $FD, $0C, $04, $01, $FD, $14, $05, $01

; ---- data $52FC-$5301 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailDraftMenu_Anim20Script:: ; 2B:52FC
Data_2B_52FC::
	db $02, $00, $2E, $01, $08

; ---- words $5301-$5305 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $5305, $5336 to OAM frames (extent = lowest target); referenced by an animation entry

MailDraftMenu_Anim0Frames:: ; 2B:5301
Table_2B_5301::
	dw MailDraftMenu_Anim0Frame0, MailDraftMenu_Anim0Frame1

; ---- data $5305-$5336 (49 bytes) [PROBABLE] OAM frame: count=12 then 12 x (y,x,tile,attr) = 49 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim0Frame0:: ; 2B:5305
Data_2B_5305::
	db $0C, $10, $00, $09, $02, $10, $08, $0A, $02, $10, $10, $0B, $02, $08, $00, $06
	db $03, $08, $08, $07, $03, $08, $10, $08, $03, $10, $00, $16, $03, $10, $08, $17
	db $03, $10, $10, $18, $03, $00, $00, $13, $03, $00, $08, $14, $03, $00, $10, $15
	db $03

; ---- data $5336-$5367 (49 bytes) [PROBABLE] OAM frame: count=12 then 12 x (y,x,tile,attr) = 49 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim0Frame1:: ; 2B:5336
Data_2B_5336::
	db $0C, $10, $00, $09, $02, $10, $08, $0A, $02, $10, $10, $0B, $02, $00, $00, $13
	db $04, $00, $08, $14, $04, $00, $10, $15, $04, $08, $00, $26, $04, $08, $08, $27
	db $04, $08, $10, $28, $04, $10, $00, $29, $04, $10, $08, $2A, $04, $10, $10, $2B
	db $04

; ---- data $5367-$536A (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 2e), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailDraftMenu_Anim0Script:: ; 2B:5367
Data_2B_5367::
	db $01, $00, $2E

; ---- words $536A-$536E (4 bytes) [PROBABLE] frame table: 2 pointer(s) $536E, $5397 to OAM frames (extent = lowest target); referenced by an animation entry

MailDraftMenu_Anim4Frames:: ; 2B:536A
Table_2B_536A::
	dw MailDraftMenu_Anim4Frame0, MailDraftMenu_Anim4Frame1

; ---- data $536E-$5397 (41 bytes) [PROBABLE] OAM frame: count=10 then 10 x (y,x,tile,attr) = 41 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim4Frame0:: ; 2B:536E
Data_2B_536E::
	db $0A, $00, $00, $23, $00, $00, $08, $24, $00, $00, $10, $25, $00, $08, $00, $26
	db $00, $08, $08, $27, $00, $08, $10, $28, $00, $10, $00, $0C, $02, $10, $08, $0D
	db $02, $10, $10, $0E, $02, $10, $08, $29, $00

; ---- data $5397-$53C0 (41 bytes) [PROBABLE] OAM frame: count=10 then 10 x (y,x,tile,attr) = 41 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

MailDraftMenu_Anim4Frame1:: ; 2B:5397
Data_2B_5397::
	db $0A, $10, $00, $0C, $02, $10, $08, $0D, $02, $10, $10, $0E, $02, $00, $00, $2C
	db $00, $00, $08, $2D, $00, $00, $10, $2E, $00, $08, $00, $30, $00, $08, $08, $31
	db $00, $08, $10, $32, $00, $10, $08, $2F, $00

; ---- data $53C0-$53C3 (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 2e), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

MailDraftMenu_Anim4Script:: ; 2B:53C0
Data_2B_53C0::
	db $01, $00, $2E
