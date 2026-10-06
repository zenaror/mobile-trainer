; gfx/unreferenced/page_list_prototype.asm
; bank 7F, $62B0-$70FD (3661 bytes); pinned by layout.link
; tiles, tilemap, palettes, object tables of the prototype

SECTION "gfx/unreferenced/page_list_prototype", ROMX

; ---- gfx $62B0-$66B0 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 7F:5233: hl=$62B0 a=$7F c=$40 de=$9001 (dest VRAM $9000, vbank=1) [call sites not executed in the 64 natural scenarios (analysis/coverage_union.tsv)]

PageListProto_Tiles_62B0:: ; 7F:62B0
Data_7F_62B0::
	INCBIN "gfx/unreferenced/page_list_prototype/tiles_62b0.2bpp"

; ---- gfx $66B0-$67D0 (288 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 7F:5245: hl=$66B0 a=$7F c=$12 de=$9401 (dest VRAM $9400, vbank=1) [call sites not executed in the 64 natural scenarios (analysis/coverage_union.tsv)]

PageListProto_Tiles_66B0:: ; 7F:66B0
Data_7F_66B0::
	INCBIN "gfx/unreferenced/page_list_prototype/tiles_66b0.2bpp"

; ---- data $67D0-$6AA0 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 7F:5281: hl=$67D0 a=$7F b=18 rows c=20 cols (tiles then attrs) de=$D000 [call sites not executed in the 64 natural scenarios (analysis/coverage_union.tsv)]

PageListProto_Tilemap_67D0:: ; 7F:67D0
Data_7F_67D0::
	INCBIN "gfx/unreferenced/page_list_prototype/tilemap_67d0.tilemap"
	INCBIN "gfx/unreferenced/page_list_prototype/tilemap_67d0.attrmap"

; ---- data $6AA0-$6AE0 (64 bytes) [PROBABLE] 8 RGB555 palettes of 4 colours (64 bytes, bit15 clear): follows the tilemap+attr block 67D0-6AA0 (0x2D0) exactly and is loaded with ld hl,$6AA0 at 7F:52A4 (same tiles/tilemap/palette layout as banks 41-47)

PageListProto_BgPalette:: ; 7F:6AA0
Palette_7F_6AA0::
	INCLUDE "gfx/unreferenced/page_list_prototype/palette_6aa0.pal"

; ---- gfx $6AE0-$6D70 (656 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 7F:5257: hl=$6AE0 a=$7F c=$29 de=$8000 (dest VRAM $8000, vbank=0) [call sites not executed in the 64 natural scenarios (analysis/coverage_union.tsv)]

PageListProto_Tiles_6AE0:: ; 7F:6AE0
Data_7F_6AE0::
	INCBIN "gfx/unreferenced/page_list_prototype/tiles_6ae0.2bpp"

; ---- data $6D70-$6DB0 (64 bytes) [PROBABLE] 8 RGB555 palettes of 4 colours (64 bytes, all words < $8000), loaded with ld hl,$6D70 at 7F:5293; follows the tile block 6AE0-6D70 (41 tiles, HDMA c=$29)

PageListProto_ObjPalette:: ; 7F:6D70
Palette_7F_6D70::
	INCLUDE "gfx/unreferenced/page_list_prototype/palette_6d70.pal"

; ---- words $6DB0-$6E50 (160 bytes) [PROBABLE] 10 object tables of 4 entries x 2 words (6DB0 ... 6E40, 16 bytes each, every entry repeated) read by init_object_from_table (00:0A82, de=$6DB0..$6E40 a=$7F, call sites 7F:5267 549B 54E5 5BE0 ...); all 80 words point into the animation block 6E50-70FD

PageListProto_ObjTable:: ; 7F:6DB0
Table_7F_6DB0::
	sprite_object_entry PageListProto_ObjAnimData, SpriteScript_7F_6E76 ; entry 0
	sprite_object_entry PageListProto_ObjAnimData, SpriteScript_7F_6E76 ; entry 1
	sprite_object_entry PageListProto_ObjAnimData, SpriteScript_7F_6E76 ; entry 2
	sprite_object_entry PageListProto_ObjAnimData, SpriteScript_7F_6E76 ; entry 3
PageListProto_ObjTable_Entry4:: ; 7F:6DC0
	sprite_object_entry SpriteFrameTable_7F_6E7B, SpriteScript_7F_6EC7 ; entry 4
	sprite_object_entry SpriteFrameTable_7F_6E7B, SpriteScript_7F_6EC7 ; entry 5
	sprite_object_entry SpriteFrameTable_7F_6E7B, SpriteScript_7F_6EC7 ; entry 6
	sprite_object_entry SpriteFrameTable_7F_6E7B, SpriteScript_7F_6EC7 ; entry 7
PageListProto_ObjTable_Entry8:: ; 7F:6DD0
	sprite_object_entry SpriteFrameTable_7F_6ED0, SpriteScript_7F_6EF6 ; entry 8
	sprite_object_entry SpriteFrameTable_7F_6ED0, SpriteScript_7F_6EF6 ; entry 9
	sprite_object_entry SpriteFrameTable_7F_6ED0, SpriteScript_7F_6EF6 ; entry 10
	sprite_object_entry SpriteFrameTable_7F_6ED0, SpriteScript_7F_6EF6 ; entry 11
PageListProto_ObjTable_Entry12:: ; 7F:6DE0
	sprite_object_entry SpriteFrameTable_7F_6EFB, SpriteScript_7F_6F0E ; entry 12
	sprite_object_entry SpriteFrameTable_7F_6EFB, SpriteScript_7F_6F0E ; entry 13
	sprite_object_entry SpriteFrameTable_7F_6EFB, SpriteScript_7F_6F0E ; entry 14
	sprite_object_entry SpriteFrameTable_7F_6EFB, SpriteScript_7F_6F0E ; entry 15
PageListProto_ObjTable_Entry16:: ; 7F:6DF0
	sprite_object_entry SpriteFrameTable_7F_6F11, SpriteScript_7F_6F24 ; entry 16
	sprite_object_entry SpriteFrameTable_7F_6F11, SpriteScript_7F_6F24 ; entry 17
	sprite_object_entry SpriteFrameTable_7F_6F11, SpriteScript_7F_6F24 ; entry 18
	sprite_object_entry SpriteFrameTable_7F_6F11, SpriteScript_7F_6F24 ; entry 19
PageListProto_ObjTable_Entry20:: ; 7F:6E00
	sprite_object_entry SpriteFrameTable_7F_6F27, SpriteScript_7F_6F5D ; entry 20
	sprite_object_entry SpriteFrameTable_7F_6F27, SpriteScript_7F_6F5D ; entry 21
	sprite_object_entry SpriteFrameTable_7F_6F27, SpriteScript_7F_6F5D ; entry 22
	sprite_object_entry SpriteFrameTable_7F_6F27, SpriteScript_7F_6F5D ; entry 23
PageListProto_ObjTable_Entry24:: ; 7F:6E10
	sprite_object_entry SpriteFrameTable_7F_6F62, SpriteScript_7F_6F98 ; entry 24
	sprite_object_entry SpriteFrameTable_7F_6F62, SpriteScript_7F_6F98 ; entry 25
	sprite_object_entry SpriteFrameTable_7F_6F62, SpriteScript_7F_6F98 ; entry 26
	sprite_object_entry SpriteFrameTable_7F_6F62, SpriteScript_7F_6F98 ; entry 27
PageListProto_ObjTable_Entry28:: ; 7F:6E20
	sprite_object_entry SpriteFrameTable_7F_6F9D, SpriteScript_7F_6FC3 ; entry 28
	sprite_object_entry SpriteFrameTable_7F_6F9D, SpriteScript_7F_6FC3 ; entry 29
	sprite_object_entry SpriteFrameTable_7F_6F9D, SpriteScript_7F_6FC3 ; entry 30
	sprite_object_entry SpriteFrameTable_7F_6F9D, SpriteScript_7F_6FC3 ; entry 31
PageListProto_ObjTable_Entry32:: ; 7F:6E30
	sprite_object_entry SpriteFrameTable_7F_6FC8, SpriteScript_7F_704D ; entry 32
	sprite_object_entry SpriteFrameTable_7F_6FC8, SpriteScript_7F_704D ; entry 33
	sprite_object_entry SpriteFrameTable_7F_6FC8, SpriteScript_7F_704D ; entry 34
	sprite_object_entry SpriteFrameTable_7F_6FC8, SpriteScript_7F_704D ; entry 35
PageListProto_ObjTable_Entry36:: ; 7F:6E40
	sprite_object_entry SpriteFrameTable_7F_705C, SpriteScript_7F_70E1 ; entry 36
	sprite_object_entry SpriteFrameTable_7F_705C, SpriteScript_7F_70E1 ; entry 37
	sprite_object_entry SpriteFrameTable_7F_705C, SpriteScript_7F_70E1 ; entry 38
	sprite_object_entry SpriteFrameTable_7F_705C, SpriteScript_7F_70E1 ; entry 39

; ---- data $6E50-$70FD (685 bytes) [PROBABLE] animation descriptors / sprite lists reached from the object tables 7F:6DB0-6E50 (same format as bank 72:786C-7A1F: sprite list = count + count*(y,x,tile,attr), descriptors 02 00 .. dw dw)

PageListProto_ObjAnimData:: ; 7F:6E50
Data_7F_6E50::
	sprite_frame_table SpriteFrame_7F_6E54, SpriteFrame_7F_6E65
SpriteFrame_7F_6E54:: ; 7F:6E54
	sprite_frame 4
	sprite_oam 0, 0, $28, 4
	sprite_oam 0, 12, $28, OAMF_XFLIP | 4
	sprite_oam 12, 0, $28, OAMF_YFLIP | 4
	sprite_oam 12, 12, $28, OAMF_YFLIP | OAMF_XFLIP | 4
SpriteFrame_7F_6E65:: ; 7F:6E65
	sprite_frame 4
	sprite_oam -1, -1, $28, 4
	sprite_oam -1, 13, $28, OAMF_XFLIP | 4
	sprite_oam 13, -1, $28, OAMF_YFLIP | 4
	sprite_oam 13, 13, $28, OAMF_YFLIP | OAMF_XFLIP | 4
SpriteScript_7F_6E76:: ; 7F:6E76
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
SpriteFrameTable_7F_6E7B:: ; 7F:6E7B
	sprite_frame_table SpriteFrame_7F_6E83, SpriteFrame_7F_6E94, SpriteFrame_7F_6EA5, SpriteFrame_7F_6EB6
SpriteFrame_7F_6E83:: ; 7F:6E83
	sprite_frame 4
	sprite_oam 0, 0, $02, 0
	sprite_oam 8, 0, $12, 0
	sprite_oam 0, 8, $02, OAMF_XFLIP
	sprite_oam 8, 8, $12, OAMF_XFLIP
SpriteFrame_7F_6E94:: ; 7F:6E94
	sprite_frame 4
	sprite_oam 0, 0, $04, 0
	sprite_oam 8, 0, $14, 0
	sprite_oam 0, 8, $04, OAMF_XFLIP
	sprite_oam 8, 8, $14, OAMF_XFLIP
SpriteFrame_7F_6EA5:: ; 7F:6EA5
	sprite_frame 4
	sprite_oam 0, 0, $02, 0
	sprite_oam 8, 0, $12, 0
	sprite_oam 0, 8, $02, OAMF_XFLIP
	sprite_oam 8, 8, $12, OAMF_XFLIP
SpriteFrame_7F_6EB6:: ; 7F:6EB6
	sprite_frame 4
	sprite_oam 0, 0, $05, 0
	sprite_oam 8, 0, $15, 0
	sprite_oam 0, 8, $05, OAMF_XFLIP
	sprite_oam 8, 8, $15, OAMF_XFLIP
SpriteScript_7F_6EC7:: ; 7F:6EC7
	sprite_anim 4
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
	sprite_anim_step 2, 8
	sprite_anim_step 3, 8
SpriteFrameTable_7F_6ED0:: ; 7F:6ED0
	sprite_frame_table SpriteFrame_7F_6ED4, SpriteFrame_7F_6EE5
SpriteFrame_7F_6ED4:: ; 7F:6ED4
	sprite_frame 4
	sprite_oam 0, 0, $03, 0
	sprite_oam 8, 0, $13, 0
	sprite_oam 0, 8, $03, OAMF_XFLIP
	sprite_oam 8, 8, $13, OAMF_XFLIP
SpriteFrame_7F_6EE5:: ; 7F:6EE5
	sprite_frame 4
	sprite_oam 0, 0, $01, 0
	sprite_oam 8, 0, $11, 0
	sprite_oam 0, 8, $01, OAMF_XFLIP
	sprite_oam 8, 8, $11, OAMF_XFLIP
SpriteScript_7F_6EF6:: ; 7F:6EF6
	sprite_anim 2
	sprite_anim_step 0, 23
	sprite_anim_step 1, 23
SpriteFrameTable_7F_6EFB:: ; 7F:6EFB
	sprite_frame_table SpriteFrame_7F_6EFD
SpriteFrame_7F_6EFD:: ; 7F:6EFD
	sprite_frame 4
	sprite_oam 0, 0, $00, 1
	sprite_oam 8, 0, $10, 1
	sprite_oam 0, 8, $00, OAMF_XFLIP | 1
	sprite_oam 8, 8, $10, OAMF_XFLIP | 1
SpriteScript_7F_6F0E:: ; 7F:6F0E
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_7F_6F11:: ; 7F:6F11
	sprite_frame_table SpriteFrame_7F_6F13
SpriteFrame_7F_6F13:: ; 7F:6F13
	sprite_frame 4
	sprite_oam 0, 0, $01, 1
	sprite_oam 8, 0, $11, 1
	sprite_oam 0, 8, $01, OAMF_XFLIP | 1
	sprite_oam 8, 8, $11, OAMF_XFLIP | 1
SpriteScript_7F_6F24:: ; 7F:6F24
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_7F_6F27:: ; 7F:6F27
	sprite_frame_table SpriteFrame_7F_6F2B, SpriteFrame_7F_6F44
SpriteFrame_7F_6F2B:: ; 7F:6F2B
	sprite_frame 6
	sprite_oam 0, 0, $0C, 4
	sprite_oam 0, 8, $0D, 4
	sprite_oam 8, 0, $1C, 4
	sprite_oam 8, 8, $1D, 4
	sprite_oam 0, 16, $0E, 4
	sprite_oam 8, 16, $1E, 4
SpriteFrame_7F_6F44:: ; 7F:6F44
	sprite_frame 6
	sprite_oam -1, 0, $0C, 4
	sprite_oam -1, 8, $0D, 4
	sprite_oam 7, 0, $1C, 4
	sprite_oam 7, 8, $1D, 4
	sprite_oam -1, 16, $0E, 4
	sprite_oam 7, 16, $1E, 4
SpriteScript_7F_6F5D:: ; 7F:6F5D
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
SpriteFrameTable_7F_6F62:: ; 7F:6F62
	sprite_frame_table SpriteFrame_7F_6F66, SpriteFrame_7F_6F7F
SpriteFrame_7F_6F66:: ; 7F:6F66
	sprite_frame 6
	sprite_oam 0, 0, $0F, 4
	sprite_oam 8, 0, $1F, 4
	sprite_oam 0, 8, $20, 4
	sprite_oam 0, 16, $21, 4
	sprite_oam 8, 8, $22, 4
	sprite_oam 8, 16, $23, 4
SpriteFrame_7F_6F7F:: ; 7F:6F7F
	sprite_frame 6
	sprite_oam -1, 0, $0F, 4
	sprite_oam 7, 0, $1F, 4
	sprite_oam -1, 8, $20, 4
	sprite_oam -1, 16, $21, 4
	sprite_oam 7, 8, $22, 4
	sprite_oam 7, 16, $23, 4
SpriteScript_7F_6F98:: ; 7F:6F98
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
SpriteFrameTable_7F_6F9D:: ; 7F:6F9D
	sprite_frame_table SpriteFrame_7F_6FA1, SpriteFrame_7F_6FB2
SpriteFrame_7F_6FA1:: ; 7F:6FA1
	sprite_frame 4
	sprite_oam 0, 0, $24, 4
	sprite_oam 0, 8, $25, 4
	sprite_oam 8, 0, $26, 4
	sprite_oam 8, 8, $27, 4
SpriteFrame_7F_6FB2:: ; 7F:6FB2
	sprite_frame 4
	sprite_oam -1, 0, $24, 4
	sprite_oam -1, 8, $25, 4
	sprite_oam 7, 0, $26, 4
	sprite_oam 7, 8, $27, 4
SpriteScript_7F_6FC3:: ; 7F:6FC3
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
SpriteFrameTable_7F_6FC8:: ; 7F:6FC8
	sprite_frame_table SpriteFrame_7F_6FD6, SpriteFrame_7F_6FE7, SpriteFrame_7F_6FF8, SpriteFrame_7F_7009
	sprite_frame_table SpriteFrame_7F_701A, SpriteFrame_7F_702B, SpriteFrame_7F_703C
SpriteFrame_7F_6FD6:: ; 7F:6FD6
	sprite_frame 4
	sprite_oam 0, 0, $03, 0
	sprite_oam 8, 0, $13, 0
	sprite_oam 0, 8, $03, OAMF_XFLIP
	sprite_oam 8, 8, $13, OAMF_XFLIP
SpriteFrame_7F_6FE7:: ; 7F:6FE7
	sprite_frame 4
	sprite_oam 0, 0, $03, 0
	sprite_oam 8, 0, $13, 0
	sprite_oam 0, 8, $0B, OAMF_XFLIP
	sprite_oam 8, 8, $1B, OAMF_XFLIP
SpriteFrame_7F_6FF8:: ; 7F:6FF8
	sprite_frame 4
	sprite_oam 0, 0, $03, 0
	sprite_oam 8, 0, $13, 0
	sprite_oam 0, 8, $0A, OAMF_XFLIP
	sprite_oam 8, 8, $1A, OAMF_XFLIP
SpriteFrame_7F_7009:: ; 7F:7009
	sprite_frame 4
	sprite_oam 0, 0, $03, 0
	sprite_oam 8, 0, $13, 0
	sprite_oam 0, 8, $09, OAMF_XFLIP
	sprite_oam 8, 8, $19, OAMF_XFLIP
SpriteFrame_7F_701A:: ; 7F:701A
	sprite_frame 4
	sprite_oam 0, 8, $08, OAMF_XFLIP
	sprite_oam 8, 8, $18, OAMF_XFLIP
	sprite_oam 0, 0, $03, 0
	sprite_oam 8, 0, $13, 0
SpriteFrame_7F_702B:: ; 7F:702B
	sprite_frame 4
	sprite_oam 0, 8, $06, OAMF_XFLIP
	sprite_oam 0, 0, $07, OAMF_XFLIP
	sprite_oam 8, 8, $16, OAMF_XFLIP
	sprite_oam 8, 0, $17, OAMF_XFLIP
SpriteFrame_7F_703C:: ; 7F:703C
	sprite_frame 4
	sprite_oam 0, 0, $02, 0
	sprite_oam 8, 0, $12, 0
	sprite_oam 0, 8, $02, OAMF_XFLIP
	sprite_oam 8, 8, $12, OAMF_XFLIP
SpriteScript_7F_704D:: ; 7F:704D
	sprite_anim 7
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
	sprite_anim_step 2, 8
	sprite_anim_step 3, 8
	sprite_anim_step 4, 8
	sprite_anim_step 5, 8
	sprite_anim_step 6, 8
SpriteFrameTable_7F_705C:: ; 7F:705C
	sprite_frame_table SpriteFrame_7F_706A, SpriteFrame_7F_707B, SpriteFrame_7F_708C, SpriteFrame_7F_709D
	sprite_frame_table SpriteFrame_7F_70AE, SpriteFrame_7F_70BF, SpriteFrame_7F_70D0
SpriteFrame_7F_706A:: ; 7F:706A
	sprite_frame 4
	sprite_oam 0, 0, $02, 0
	sprite_oam 8, 0, $12, 0
	sprite_oam 0, 8, $02, OAMF_XFLIP
	sprite_oam 8, 8, $12, OAMF_XFLIP
SpriteFrame_7F_707B:: ; 7F:707B
	sprite_frame 4
	sprite_oam 0, 0, $06, 0
	sprite_oam 0, 8, $07, 0
	sprite_oam 8, 0, $16, 0
	sprite_oam 8, 8, $17, 0
SpriteFrame_7F_708C:: ; 7F:708C
	sprite_frame 4
	sprite_oam 0, 0, $08, 0
	sprite_oam 8, 0, $18, 0
	sprite_oam 0, 8, $03, OAMF_XFLIP
	sprite_oam 8, 8, $13, OAMF_XFLIP
SpriteFrame_7F_709D:: ; 7F:709D
	sprite_frame 4
	sprite_oam 0, 0, $09, 0
	sprite_oam 8, 0, $19, 0
	sprite_oam 0, 8, $03, OAMF_XFLIP
	sprite_oam 8, 8, $13, OAMF_XFLIP
SpriteFrame_7F_70AE:: ; 7F:70AE
	sprite_frame 4
	sprite_oam 0, 0, $0A, 0
	sprite_oam 8, 0, $1A, 0
	sprite_oam 0, 8, $03, OAMF_XFLIP
	sprite_oam 8, 8, $13, OAMF_XFLIP
SpriteFrame_7F_70BF:: ; 7F:70BF
	sprite_frame 4
	sprite_oam 0, 0, $0B, 0
	sprite_oam 8, 0, $1B, 0
	sprite_oam 0, 8, $03, OAMF_XFLIP
	sprite_oam 8, 8, $13, OAMF_XFLIP
SpriteFrame_7F_70D0:: ; 7F:70D0
	sprite_frame 4
	sprite_oam 0, 0, $03, 0
	sprite_oam 8, 0, $13, 0
	sprite_oam 0, 8, $03, OAMF_XFLIP
	sprite_oam 8, 8, $13, OAMF_XFLIP
SpriteScript_7F_70E1:: ; 7F:70E1
	sprite_anim 7
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
	sprite_anim_step 2, 8
	sprite_anim_step 3, 8
	sprite_anim_step 4, 8
	sprite_anim_step 5, 8
	sprite_anim_step 6, 8
	db $06, $00, $08, $01, $08, $02, $08, $03, $08, $04, $08, $05, $08 ; not reached by any walked sprite chain
