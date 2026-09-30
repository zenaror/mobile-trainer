; gfx/mail_server/delete_method_screen.asm
; bank 28, $5F20-$6F20 (4096 bytes); pinned by layout.link
; delete-method screen tiles, two tilemaps, palettes, object tables (loaded by banks 22/23)

SECTION "gfx/mail_server/delete_method_screen", ROMX

; ---- gfx $5F20-$6150 (560 bytes) [PROBABLE] tiles-vram: 2 call site(s) (22:4277 23:4226); first: hdma_rom_to_vram at 22:4277: hl=$5F20 a=$28 c=$23 de=$9301 (dest VRAM $9300, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

MailServerDeleteMethod_Tiles_5F20:: ; 28:5F20
Data_28_5F20::
	INCBIN "gfx/mail_server/delete_method_screen/mail_server_delete_method_tiles_5f20.2bpp"

; ---- gfx $6150-$6550 (1024 bytes) [PROBABLE] tiles-vram: 2 call site(s) (22:428C 23:423B); first: hdma_rom_to_vram at 22:428C: hl=$6150 a=$28 c=$40 de=$8800 (dest VRAM $8800, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

MailServerDeleteMethod_Tiles_6150:: ; 28:6150
Data_28_6150::
	INCBIN "gfx/mail_server/delete_method_screen/mail_server_delete_method_tiles_6150.2bpp"

; ---- gfx $6550-$67E0 (656 bytes) [PROBABLE] tiles-vram: 2 call site(s) (22:42A1 23:4250); first: hdma_rom_to_vram at 22:42A1: hl=$6550 a=$28 c=$29 de=$8C00 (dest VRAM $8C00, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

MailServerDeleteMethod_Tiles_6550:: ; 28:6550
Data_28_6550::
	INCBIN "gfx/mail_server/delete_method_screen/mail_server_delete_method_tiles_6550.2bpp"

; ---- gfx $67E0-$6860 (128 bytes) [PROBABLE] tiles-vram: 2 call site(s) (22:42B6 23:4265); first: hdma_rom_to_vram at 22:42B6: hl=$67E0 a=$28 c=$08 de=$8000 (dest VRAM $8000, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

MailServerDeleteMethod_Tiles_67E0:: ; 28:67E0
Data_28_67E0::
	INCBIN "gfx/mail_server/delete_method_screen/mail_server_delete_method_tiles_67e0.2bpp"

; ---- data $6860-$6B30 (720 bytes) [PROBABLE] tilemap+attr: 2 call site(s) (23:4172 23:4279); first: copy_tilemap_rect_pair at 23:4172: hl=$6860 a=$28 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

MailServerDeleteMethod_Tilemap_First:: ; 28:6860
Data_28_6860::
	INCBIN "gfx/mail_server/delete_method_screen/mail_server_delete_method_tilemap_first.tilemap"
	INCBIN "gfx/mail_server/delete_method_screen/mail_server_delete_method_tilemap_first.attrmap"

; ---- data $6B30-$6E00 (720 bytes) [PROBABLE] tilemap+attr: 2 call site(s) (23:41AD 23:42D0); first: copy_tilemap_rect_pair at 23:41AD: hl=$6B30 a=$28 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

MailServerDeleteMethod_Tilemap_Second:: ; 28:6B30
Data_28_6B30::
	INCBIN "gfx/mail_server/delete_method_screen/mail_server_delete_method_tilemap_second.tilemap"
	INCBIN "gfx/mail_server/delete_method_screen/mail_server_delete_method_tilemap_second.attrmap"

; ---- data $6E00-$6E80 (128 bytes) [PROBABLE] 16 palettes x 4 RGB555 words (0x80 bytes, all words bit15 clear) directly after the tilemap 6B30-6E00 (same tilemap 2D0 + palette 80 layout as bank 45); the mapper heuristic had extended it over the object table words at 6E80-6EA0 [v4: bytes 6E00-6E08 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

MailServerDeleteMethod_BgPalette:: ; 28:6E00
Palette_28_6E00::
	INCLUDE "gfx/mail_server/delete_method_screen/mail_server_delete_method_bg_palette.pal"

MailServerDeleteMethod_ObjPalette:: ; 28:6E40
	INCLUDE "gfx/mail_server/delete_method_screen/mail_server_delete_method_obj_palette.pal"

; ---- words $6E80-$6EA0 (32 bytes) [PROBABLE] 2 rows of 16 bytes = 4 identical 4-byte object-table entries (ptr to frame table, ptr to script); every pointer lands on a frame-table/script start found by the sequential sweep of 6E80-7A5D (28:6E80-7A5D); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs

MailServerDeleteMethod_ObjTable:: ; 28:6E80
Table_28_6E80::
	dw MailServerDeleteMethod_ObjAnimData, $6EC6, MailServerDeleteMethod_ObjAnimData, $6EC6, MailServerDeleteMethod_ObjAnimData, $6EC6, MailServerDeleteMethod_ObjAnimData, $6EC6
	dw $6ECB, $6F09, $6ECB, $6F09, $6ECB, $6F09, $6ECB, $6F09

; ---- data $6EA0-$6F20 (128 bytes) [PROBABLE] 2 object record(s): 2 frame tables, 4 frames, 3 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 28:6E80-7A5D [v4: bytes 6ECB-6F12 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

MailServerDeleteMethod_ObjAnimData:: ; 28:6EA0
Data_28_6EA0::
	db $A4, $6E, $B5, $6E, $04, $FE, $FE, $00, $00, $FE, $1A, $00, $20, $0A, $FE, $00
	db $40, $0A, $1A, $00, $60, $04, $FD, $FD, $00, $00, $FD, $1B, $00, $20, $0B, $FD
	db $00, $40, $0B, $1B, $00, $60, $02, $00, $2E, $01, $08, $CF, $6E, $EC, $6E, $07
	db $1D, $13, $00, $00, $1D, $1B, $01, $00, $25, $13, $02, $00, $25, $1B, $03, $00
	db $2D, $13, $04, $00, $2D, $1B, $05, $00, $1E, $20, $06, $00, $07, $1D, $13, $00
	db $00, $1D, $1B, $01, $00, $25, $13, $02, $00, $25, $1B, $03, $00, $2D, $13, $04
	db $00, $2D, $1B, $05, $00, $1D, $20, $07, $00, $04, $01, $07, $00, $07, $01, $07
	db $00, $78, $01, $00, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
