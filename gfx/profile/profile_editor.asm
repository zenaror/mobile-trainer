; gfx/profile/profile_editor.asm
; bank 2A, $6300-$6F95 (3221 bytes); pinned by layout.link
; profile editor tiles, tilemap, palette, animation table

SECTION "gfx/profile/profile_editor", ROMX

; ---- data $6300-$6B40 (2112 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 6300-6E50 by higher-priority evidence]

Gfx_Profile_Tiles9300:: ; 2A:6300
Data_2A_6300::
	; kind (tiles) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/profile/profile_editor/profile_tiles9300.2bpp"

Gfx_Profile_Tiles9700:: ; 2A:6700
	; kind (tiles) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/profile/profile_editor/profile_tiles9700.2bpp"

Gfx_Profile_Tiles8800:: ; 2A:6800
	; kind (tiles) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/profile/profile_editor/profile_tiles8800.2bpp"

; ---- data $6B40-$6E10 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2A:5856: hl=$6B40 a=$2A b=18 rows c=20 cols (tiles then attrs) de=$D000

Data_Profile_TilemapAttr:: ; 2A:6B40
Data_2A_6B40::
	INCBIN "gfx/profile/profile_editor/data_profile_tilemap_attr.tilemap"
	INCBIN "gfx/profile/profile_editor/data_profile_tilemap_attr.attrmap"

; ---- data $6E10-$6E50 (64 bytes) [PROBABLE] 64 bytes = 32 RGB555 words (bit15 clear) right after the tilemap+attr block 6B40-6E10 (6B40+$2D0); previous data was cut into a CONFIRMED read fragment 6E10-6E30 and a clipped heuristic palette 6E30-6EB0

Palette_Profile_Bg:: ; 2A:6E10
Palette_2A_6E10::
	INCLUDE "gfx/profile/profile_editor/profile_bg.pal"

; ---- words $6E50-$6EA0 (80 bytes) [PROBABLE] animation entry table: 20 entries of 4 bytes (frame-table pointer, script pointer), each animation repeated 4x; format of the sprite-slot initialiser 00:0A82/0AB8 (entry at DE+4*(A&$7F) -> slot[2..3] frame table, slot[6..7] script)

Table_Profile_Anims:: ; 2A:6E50
Table_2A_6E50::
	dw Table_2A_6EA0, Data_2A_6ECE, Table_2A_6EA0, Data_2A_6ECE, Table_2A_6EA0, Data_2A_6ECE, Table_2A_6EA0, Data_2A_6ECE
	dw Table_2A_6ED3, Data_2A_6F01, Table_2A_6ED3, Data_2A_6F01, Table_2A_6ED3, Data_2A_6F01, Table_2A_6ED3, Data_2A_6F01
	dw Table_2A_6F06, Data_2A_6F3C, Table_2A_6F06, Data_2A_6F3C, Table_2A_6F06, Data_2A_6F3C, Table_2A_6F06, Data_2A_6F3C
	dw Table_2A_6F41, Data_2A_6F77, Table_2A_6F41, Data_2A_6F77, Table_2A_6F41, Data_2A_6F77, Table_2A_6F41, Data_2A_6F77
	dw Table_2A_6F7C, Data_2A_6F92, Table_2A_6F7C, Data_2A_6F92, Table_2A_6F7C, Data_2A_6F92, Table_2A_6F7C, Data_2A_6F92

; ---- words $6EA0-$6EA4 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $6EA4, $6EB9 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2A_6EA0:: ; 2A:6EA0
	dw Data_2A_6EA4, Data_2A_6EB9

; ---- data $6EA4-$6EB9 (21 bytes) [PROBABLE] OAM frame: count=5 then 5 x (y,x,tile,attr) = 21 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6EA4:: ; 2A:6EA4
	db $05, $06, $03, $04, $01, $07, $0C, $02, $01, $07, $14, $03, $01, $FF, $0C, $07
	db $01, $FF, $14, $08, $01

; ---- data $6EB9-$6ECE (21 bytes) [PROBABLE] OAM frame: count=5 then 5 x (y,x,tile,attr) = 21 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6EB9:: ; 2A:6EB9
	db $05, $06, $04, $04, $01, $08, $0C, $02, $01, $08, $14, $03, $01, $00, $0C, $07
	db $01, $00, $14, $08, $01

; ---- data $6ECE-$6ED3 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2a 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2A_6ECE:: ; 2A:6ECE
	db $02, $00, $2A, $01, $08

; ---- words $6ED3-$6ED7 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $6ED7, $6EEC to OAM frames (extent = lowest target); referenced by an animation entry

Table_2A_6ED3:: ; 2A:6ED3
	dw Data_2A_6ED7, Data_2A_6EEC

; ---- data $6ED7-$6EEC (21 bytes) [PROBABLE] OAM frame: count=5 then 5 x (y,x,tile,attr) = 21 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6ED7:: ; 2A:6ED7
	db $05, $06, $03, $04, $01, $07, $0C, $00, $01, $07, $14, $01, $01, $FF, $0C, $05
	db $01, $FF, $14, $06, $01

; ---- data $6EEC-$6F01 (21 bytes) [PROBABLE] OAM frame: count=5 then 5 x (y,x,tile,attr) = 21 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6EEC:: ; 2A:6EEC
	db $05, $06, $04, $04, $01, $08, $0C, $00, $01, $08, $14, $01, $01, $00, $0C, $05
	db $01, $00, $14, $06, $01

; ---- data $6F01-$6F06 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2a 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2A_6F01:: ; 2A:6F01
	db $02, $00, $2A, $01, $08

; ---- words $6F06-$6F0A (4 bytes) [PROBABLE] frame table: 2 pointer(s) $6F0A, $6F23 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2A_6F06:: ; 2A:6F06
	dw Data_2A_6F0A, Data_2A_6F23

; ---- data $6F0A-$6F23 (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6F0A:: ; 2A:6F0A
	db $06, $FF, $05, $00, $02, $FF, $0D, $01, $02, $FF, $15, $02, $02, $07, $05, $03
	db $02, $07, $0D, $04, $02, $07, $15, $05, $02

; ---- data $6F23-$6F3C (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6F23:: ; 2A:6F23
	db $06, $FE, $05, $00, $02, $FE, $0D, $01, $02, $FE, $15, $02, $02, $06, $05, $03
	db $02, $06, $0D, $04, $02, $06, $15, $05, $02

; ---- data $6F3C-$6F41 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 08 01 23), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2A_6F3C:: ; 2A:6F3C
	db $02, $00, $08, $01, $23

; ---- words $6F41-$6F45 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $6F45, $6F5E to OAM frames (extent = lowest target); referenced by an animation entry

Table_2A_6F41:: ; 2A:6F41
	dw Data_2A_6F45, Data_2A_6F5E

; ---- data $6F45-$6F5E (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6F45:: ; 2A:6F45
	db $06, $FF, $05, $00, $02, $FF, $0D, $01, $02, $FF, $15, $02, $02, $07, $05, $03
	db $02, $07, $0D, $04, $02, $07, $15, $05, $02

; ---- data $6F5E-$6F77 (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6F5E:: ; 2A:6F5E
	db $06, $FE, $05, $00, $02, $FE, $0D, $01, $02, $FE, $15, $02, $02, $06, $05, $03
	db $02, $06, $0D, $04, $02, $06, $15, $05, $02

; ---- data $6F77-$6F7C (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 08 01 23), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2A_6F77:: ; 2A:6F77
	db $02, $00, $08, $01, $23

; ---- words $6F7C-$6F80 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $6F80, $6F91 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2A_6F7C:: ; 2A:6F7C
	dw Data_2A_6F80, Data_2A_6F91

; ---- data $6F80-$6F91 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6F80:: ; 2A:6F80
	db $04, $DD, $40, $2C, $23, $1C, $40, $2C, $23, $DD, $B8, $2C, $23, $1C, $B8, $2C
	db $23

; ---- data $6F91-$6F92 (1 bytes) [PROBABLE] OAM frame: count=0 then 0 x (y,x,tile,attr) = 1 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_6F91:: ; 2A:6F91
	db $00

; ---- data $6F92-$6F95 (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 04), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2A_6F92:: ; 2A:6F92
	db $01, $00, $04
