; gfx/address_book/address_picker.asm
; bank 2C, $6730-$741C (3308 bytes); pinned by layout.link
; picker tiles, tilemap, palettes, slot icon animation tables

SECTION "gfx/address_book/address_picker", ROMX

; ---- gfx $6730-$6B30 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2C:5907: hl=$6730 a=$2C c=$40 de=$9301 (dest VRAM $9300, vbank=1)

Gfx_AddrPick_Tiles9300:: ; 2C:6730
Data_2C_6730::
	INCBIN "gfx/address_book/address_picker/addr_pick_tiles9300.2bpp"

; ---- gfx $6B30-$6C30 (256 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2C:591C: hl=$6B30 a=$2C c=$10 de=$9701 (dest VRAM $9700, vbank=1)

Gfx_AddrPick_Tiles9700:: ; 2C:6B30
Data_2C_6B30::
	INCBIN "gfx/address_book/address_picker/addr_pick_tiles9700.2bpp"

; ---- gfx $6C30-$6CC0 (144 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2C:58F2: hl=$6C30 a=$2C c=$09 de=$8F00 (dest VRAM $8F00, vbank=0)

Gfx_AddrBook_Tiles8F00:: ; 2C:6C30
Data_2C_6C30::
	INCBIN "gfx/address_book/address_picker/addr_book_tiles8f00.2bpp"

; ---- data $6CC0-$6F90 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2C:595A: hl=$6CC0 a=$2C b=18 rows c=20 cols (tiles then attrs) de=$D000

Data_AddrPick_TilemapAttr:: ; 2C:6CC0
Data_2C_6CC0::
	INCBIN "gfx/address_book/address_picker/data_addr_pick_tilemap_attr.tilemap"
	INCBIN "gfx/address_book/address_picker/data_addr_pick_tilemap_attr.attrmap"

; ---- data $6F90-$6F9E (14 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 6730-6FD0 by higher-priority evidence]

Palette_AddrPick_Bg:: ; 2C:6F90
Data_2C_6F90::
	INCLUDE "gfx/address_book/address_picker/addr_pick_bg.pal"

; ---- data $6F9E-$6FCE (48 bytes) [PROBABLE] palette-rgb555: heuristic: 24 RGB555 words as 6 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Data_2C_6F9E:: ; 2C:6F9E
	INCLUDE "gfx/address_book/address_picker/palette_6f9e.pal"

; ---- data $6FCE-$6FD0 (2 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 6730-6FD0 by higher-priority evidence]

Data_2C_6FCE:: ; 2C:6FCE
	db $FF, $7F

; ---- gfx $6FD0-$71D0 (512 bytes) [PROBABLE] 32 tiles (512 bytes) between the palette blocks 6F90 and 71D0; pixel coherence h=0.744 v=0.595; rendered and inspected (sprite/object art); no loader call found

Tiles_2C_6FD0:: ; 2C:6FD0
	INCBIN "gfx/address_book/address_picker/tiles_6fd0.2bpp"

; ---- data $71D0-$7210 (64 bytes) [CONFIRMED] 64-byte CGB palette block (8 x 4 RGB555 words, bit15 clear): copied by FarCall 4F:4000 (CopyBytes wrapper, bc=$40) to WRAM $D840 at 2C:58C9 (also 2A:4123, 2F:45FB). Replaces the mapper heuristic palette region 71EA-7262 (its tail is really the object table below)

Palette_AddrBook_Obj:: ; 2C:71D0
Palette_2C_71D0::
	INCLUDE "gfx/address_book/address_picker/addr_book_obj.pal"

; ---- ptrtable $7210-$7260 (80 bytes) [PROBABLE] 40 words, all inside $7260-$7422 of the same bank (animation/OAM frame data); tables of 4-byte entries (2 words) addressed by ld de,imm before FarCall 00:0A82 (init_object_from_table: reads the 4-byte entry number B&$7F of the table at DE); each 16-byte table = 4 identical-pair entries; caller 2C:5A1E ld de,$7220 (a=$2C b=$01)

Table_AddrSlotIcon_Anims:: ; 2C:7210
Table_2C_7210::
	dw AddrSlotIcon_ObjAnimData_2C_7260
	dw $728E
	dw AddrSlotIcon_ObjAnimData_2C_7260
	dw $728E
	dw AddrSlotIcon_ObjAnimData_2C_7260
	dw $728E
	dw AddrSlotIcon_ObjAnimData_2C_7260
	dw $728E
	dw $7291
	dw $72A4
	dw $7291
	dw $72A4
	dw $7291
	dw $72A4
	dw $7291
	dw $72A4
	dw $72A7
	dw $72BA
	dw $72A7
	dw $72BA
	dw $72A7
	dw $72BA
	dw $72A7
	dw $72BA
	dw $72BD
	dw $7354
	dw $72BD
	dw $7354
	dw $72BD
	dw $7354
	dw $72BD
	dw $7354
	dw $735F
	dw $740E
	dw $735F
	dw $740E
	dw $735F
	dw $740E
	dw $735F
	dw $740E

; ---- data $7260-$7355 (245 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; first target of Table_2C_7210 (7260: dw 7264, dw 7279, then the frames) up to the CONFIRMED-read data at 7355

AddrSlotIcon_ObjAnimData_2C_7260:: ; 2C:7260
Data_2C_7260::
	db $64, $72, $79, $72, $05, $FE, $01, $00, $00, $FE, $09, $01, $00, $FE, $11, $02
	db $00, $06, $06, $03, $00, $06, $0E, $04, $00, $05, $FE, $01, $00, $00, $FE, $09
	db $01, $00, $FE, $11, $02, $00, $06, $06, $03, $00, $06, $0E, $04, $00, $01, $00
	db $04, $93, $72, $04, $00, $08, $0D, $00, $00, $10, $0E, $00, $08, $08, $2E, $00
	db $08, $10, $2F, $00, $01, $00, $04, $A9, $72, $04, $00, $08, $01, $00, $00, $10
	db $02, $00, $08, $08, $03, $00, $08, $10, $04, $00, $01, $00, $04, $C7, $72, $D8
	db $72, $F9, $72, $1A, $73, $3B, $73, $04, $00, $08, $0D, $00, $00, $10, $0E, $00
	db $08, $08, $2E, $00, $08, $10, $2F, $00, $08, $01, $08, $22, $00, $01, $10, $23
	db $00, $09, $10, $1F, $00, $09, $08, $0F, $00, $03, $08, $42, $02, $03, $10, $42
	db $02, $0B, $08, $43, $02, $0B, $10, $43, $02, $08, $F9, $09, $24, $02, $F9, $11
	db $25, $02, $01, $09, $26, $02, $01, $11, $27, $02, $03, $09, $42, $02, $03, $11
	db $42, $02, $04, $09, $42, $02, $04, $11, $42, $02, $08, $FB, $05, $28, $02, $FB
	db $0D, $29, $02, $FB, $15, $2A, $02, $03, $05, $2B, $02, $03, $0D, $2C, $02, $03
	db $15, $2D, $02, $04, $08, $42, $02, $04, $10, $42, $02, $06, $FD, $05, $19, $02
	db $FD, $0D, $1A, $02, $FD, $15, $1B, $02, $05, $05, $1C, $02, $05, $0D, $1D, $02
	db $05, $15, $1E, $02, $05

; ---- data $7355-$7357 (2 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_2C_7355:: ; 2C:7355
	db $00, $05

; ---- data $7357-$741C (197 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; ends with the group 01 00 04 right before the code at 741C

AddrSlotIcon_ObjAnimData_2C_7357:: ; 2C:7357
Data_2C_7357::
	db $01, $05, $02, $05, $03, $03, $04, $12, $69, $73, $7A, $73, $9B, $73, $BC, $73
	db $E9, $73, $04, $00, $08, $01, $00, $00, $10, $02, $00, $08, $08, $03, $00, $08
	db $10, $04, $00, $08, $01, $08, $05, $00, $01, $10, $06, $00, $09, $08, $07, $00
	db $09, $10, $08, $00, $03, $08, $42, $02, $03, $10, $42, $02, $0B, $08, $43, $02
	db $0B, $10, $43, $02, $08, $01, $09, $26, $02, $01, $11, $27, $02, $F9, $09, $20
	db $02, $F9, $11, $21, $02, $03, $09, $42, $02, $03, $11, $42, $02, $04, $09, $42
	db $02, $04, $11, $42, $02, $0B, $03, $05, $2B, $02, $03, $0D, $2C, $02, $03, $15
	db $2D, $02, $FB, $05, $30, $02, $FB, $0D, $31, $02, $FB, $15, $32, $02, $F3, $05
	db $33, $02, $F3, $0D, $34, $02, $F3, $15, $35, $02, $04, $08, $42, $02, $04, $10
	db $42, $02, $09, $F6, $05, $10, $02, $F6, $0D, $11, $02, $F6, $15, $12, $02, $FE
	db $05, $13, $02, $FE, $0D, $14, $02, $FE, $15, $15, $02, $06, $05, $16, $02, $06
	db $0D, $17, $02, $06, $15, $18, $02, $05, $00, $05, $01, $05, $02, $05, $03, $03
	db $04, $12, $01, $00, $04
