; gfx/mail/received_mail_grid.asm
; bank 2B, $59C0-$6482 (2754 bytes); pinned by layout.link
; grid screen tiles, tilemap, palettes, animation tables

SECTION "gfx/mail/received_mail_grid", ROMX

; ---- gfx $59C0-$5DC0 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2B:547D: hl=$59C0 a=$2B c=$40 de=$9001 (dest VRAM $9000, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_MailGrid_Tiles9000:: ; 2B:59C0
Data_2B_59C0::
	INCBIN "gfx/mail/received_mail_grid/mail_grid_tiles9000.2bpp"

; ---- gfx $5DC0-$5FF0 (560 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2B:548F: hl=$5DC0 a=$2B c=$23 de=$9401 (dest VRAM $9400, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_MailGrid_Tiles9400:: ; 2B:5DC0
Data_2B_5DC0::
	INCBIN "gfx/mail/received_mail_grid/mail_grid_tiles9400.2bpp"

; ---- data $5FF0-$62C0 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2B:54C3: hl=$5FF0 a=$2B b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Data_MailGrid_TilemapAttr:: ; 2B:5FF0
Data_2B_5FF0::
	INCBIN "gfx/mail/received_mail_grid/data_mail_grid_tilemap_attr.tilemap"
	INCBIN "gfx/mail/received_mail_grid/data_mail_grid_tilemap_attr.attrmap"

; ---- data $62C0-$6300 (64 bytes) [PROBABLE] CGB palette data (RGB555 words): heuristic: 40 RGB555 words as 10 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance) [clipped from 62C0-6310 by higher-priority proposals]

Palette_MailGrid_Bg:: ; 2B:62C0
Data_2B_62C0::
	INCLUDE "gfx/mail/received_mail_grid/mail_grid_bg.pal"

; ---- gfx $6300-$63F0 (240 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2B:54A1: hl=$6300 a=$2B c=$0F de=$8000 (dest VRAM $8000, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_MailGrid_Tiles8000:: ; 2B:6300
Data_2B_6300::
	INCBIN "gfx/mail/received_mail_grid/mail_grid_tiles8000.2bpp"

; ---- data $63F0-$6430 (64 bytes) [PROBABLE] 64 bytes = 32 RGB555 words (bit15 clear), loaded by 'ld hl,$63F0' at 2B:54AD (a=$2B); replaces the clipped 72-word heuristic region

Palette_MailGrid_Obj:: ; 2B:63F0
Palette_2B_63F0::
	INCLUDE "gfx/mail/received_mail_grid/mail_grid_obj.pal"

; ---- words $6430-$6440 (16 bytes) [PROBABLE] animation entry table: 4 entries of 4 bytes (frame-table pointer, script pointer), each animation repeated 4x; format of the sprite-slot initialiser 00:0A82/0AB8 (entry at DE+4*(A&$7F) -> slot[2..3] frame table, slot[6..7] script)

Table_MailGrid_Anims:: ; 2B:6430
Table_2B_6430::
	dw Table_2B_6440, Data_2B_647F, Table_2B_6440, Data_2B_647F, Table_2B_6440, Data_2B_647F, Table_2B_6440, Data_2B_647F

; ---- words $6440-$6442 (2 bytes) [PROBABLE] frame table: 1 pointer(s) $6442 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2B_6440:: ; 2B:6440
	dw Data_2B_6442

; ---- data $6442-$647F (61 bytes) [PROBABLE] OAM frame: count=15 then 15 x (y,x,tile,attr) = 61 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_6442:: ; 2B:6442
	db $0F, $02, $04, $00, $00, $02, $0C, $01, $00, $02, $14, $02, $00, $0A, $04, $03
	db $00, $0A, $0C, $04, $00, $0A, $14, $05, $00, $0A, $1C, $06, $00, $12, $04, $07
	db $00, $12, $0C, $08, $00, $12, $14, $09, $00, $12, $1C, $0A, $00, $1A, $04, $0B
	db $00, $1A, $0C, $0C, $00, $1A, $14, $0D, $00, $1A, $1C, $0E, $00

; ---- data $647F-$6482 (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 04), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2B_647F:: ; 2B:647F
	db $01, $00, $04
