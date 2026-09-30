; gfx/mail/body_view.asm
; bank 28, $42C0-$4BD0 (2320 bytes); pinned by layout.link
; body view tiles, tilemap, palettes, object table

SECTION "gfx/mail/body_view", ROMX

; ---- gfx $42C0-$44D0 (528 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 28:4088: hl=$42C0 a=$28 c=$21 de=$9301 (dest VRAM $9300, vbank=1)

MailBody_Tiles_42C0:: ; 28:42C0
Data_28_42C0::
	INCBIN "gfx/mail/body_view/mail_body_tiles_42c0.2bpp"

; ---- gfx $44D0-$4550 (128 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 28:409A: hl=$44D0 a=$28 c=$08 de=$8000 (dest VRAM $8000, vbank=0)

MailBody_Tiles_44D0:: ; 28:44D0
Data_28_44D0::
	INCBIN "gfx/mail/body_view/mail_body_tiles_44d0.2bpp"

; ---- data $4550-$4820 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2B:7C08: hl=$4550 a=$28 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Tilemap_MailView_BodyPage:: ; 28:4550
Data_28_4550::
	INCBIN "gfx/mail/body_view/tilemap_4550.tilemap"
	INCBIN "gfx/mail/body_view/tilemap_4550.attrmap"

; ---- data $4820-$4AF0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 28:40AB: hl=$4820 a=$28 b=18 rows c=20 cols (tiles then attrs) de=$D000

MailBody_Tilemap:: ; 28:4820
Data_28_4820::
	INCBIN "gfx/mail/body_view/mail_body_tilemap.tilemap"
	INCBIN "gfx/mail/body_view/mail_body_tilemap.attrmap"

; ---- data $4AF0-$4B70 (128 bytes) [PROBABLE] 16 palettes x 4 RGB555 words (0x80 bytes, all bit15 clear) directly after the tilemap 4820-4AF0; read by executed code in 1/18 scenarios

MailBody_BgPalette:: ; 28:4AF0
Palette_28_4AF0::
	INCLUDE "gfx/mail/body_view/mail_body_bg_palette.pal"

MailBody_ObjPalette:: ; 28:4B30
	INCLUDE "gfx/mail/body_view/mail_body_obj_palette.pal"

; ---- words $4B70-$4B80 (16 bytes) [PROBABLE] 1 rows of 16 bytes = 4 identical 4-byte object-table entries (ptr to frame table, ptr to script); every pointer lands on a frame-table/script start found by the sequential sweep of 4B70-4BA6 (28:4B70-4BA6); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs [v4: bytes 4B74-4B78 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

MailBody_ObjTable:: ; 28:4B70
Table_28_4B70::
	dw MailBody_28_ObjAnimData, $4BA3, MailBody_28_ObjAnimData, $4BA3, MailBody_28_ObjAnimData, $4BA3, MailBody_28_ObjAnimData, $4BA3

; ---- data $4B80-$4BA6 (38 bytes) [PROBABLE] 1 object record(s): 1 frame tables, 1 frames, 1 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 28:4B70-4BA6 [v4: bytes 4B80-4BA6 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

MailBody_28_ObjAnimData:: ; 28:4B80
Data_28_4B80::
	db $82, $4B, $08, $00, $00, $00, $00, $00, $08, $01, $00, $00, $10, $02, $00, $00
	db $18, $03, $00, $08, $00, $04, $00, $08, $08, $05, $00, $08, $10, $06, $00, $08
	db $18, $07, $00, $01, $00, $04

; ---- data $4BA6-$4BC2 (28 bytes) [HYPOTHESIS] UNCLASSIFIED 28 bytes: decodes to a clean routine (ld b,$90 / ld hl,$C000 / clear / ld a,7 ldh [8D],a ldh [70],a / ld hl,$DA00 fill $FF x256 / ret) but no call/jp/far-pointer/table reference to 28:4BA6 was found; follows the object script at 4BA3-4BA6 [g4: left unclassified]

Data_28_4BA6:: ; 28:4BA6
	db $06, $90, $21, $00, $C0, $AF, $22, $05, $20, $FC, $3E, $07, $E0, $8D, $E0, $70
	db $06, $00, $21, $00, $DA, $3E, $FF, $22, $05, $20, $FC, $C9

; ---- zero $4BC2-$4BD0 (14 bytes) [PROBABLE] 14 zero bytes padding after the ret at 4BC1
	ds $E, $00
