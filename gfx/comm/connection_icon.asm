; gfx/comm/connection_icon.asm
; bank 69, $4152-$4C46 (2804 bytes); pinned by layout.link
; connection icon tiles, palettes, object tables

SECTION "gfx/comm/connection_icon", ROMX

; ---- gfx $4152-$4160 (14 bytes) [PROBABLE] tiles-2bpp: heuristic: 49 coherent tiles (hsim2=0.735 vsim2=0.659, 3 blank) parity 1; 993/1008 bytes also covered by call-site blocks [clipped from 4151-4541 by higher-priority evidence]

Data_69_4152:: ; 69:4152
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- gfx $4160-$4560 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 69:4124: hl=$4160 a=$69 c=$40 de=$8200 (dest VRAM $8200, vbank=0)

ConnIcon_Tiles0:: ; 69:4160
Data_69_4160::
	INCBIN "gfx/comm/connection_icon/conn_icon_tiles0.2bpp"

; ---- gfx $4560-$4760 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 69:4136: hl=$4560 a=$69 c=$20 de=$8600 (dest VRAM $8600, vbank=0)

ConnIcon_Tiles1:: ; 69:4560
Data_69_4560::
	INCBIN "gfx/comm/connection_icon/conn_icon_tiles1.2bpp"

; ---- data $4760-$4778 (24 bytes) [PROBABLE] 3 RGB555 palettes of 4 colours (00 00 4A 29 B5 56 FF 7F = grey ramp; bit15 clear). Previous 168-word palette claim for 4760-48B0 was wrong beyond 4778: the bytes from 4778 are the animation table below

ConnIcon_Palettes:: ; 69:4760
Palette_69_4760::
	INCLUDE "gfx/comm/connection_icon/conn_icon_palettes.pal"

; ---- ptrtable $4778-$4794 (28 bytes) [PROBABLE] 7 entries x 4 bytes = 2 pointers each, table passed as DE to init_object_from_table (00:0A82) at 4E:6057 (a=$69): entry index B&7F is read by 00:0AB8, word0 -> slot+2/3 (pointer list of frames), word1 -> slot+8/9 (count + 2-byte pairs). Every target lands on a record boundary of the parse below (tiles 4778-4C46 exactly)

ConnIcon_ObjTable:: ; 69:4778
Table_69_4778::
	sprite_object_entry ConnIcon_Anim1Frames, ConnIcon_Anim1Script ; entry 0
	sprite_object_entry ConnIcon_Anim1Frames, ConnIcon_Anim1Script ; entry 1
	sprite_object_entry ConnIcon_Anim2Frames, ConnIcon_Anim2Script ; entry 2
	sprite_object_entry ConnIcon_Anim3Frames, ConnIcon_Anim3Script ; entry 3
	sprite_object_entry ConnIcon_Anim4Frames, ConnIcon_ObjAnimData ; entry 4
	sprite_object_entry ConnIcon_Anim5Frames, ConnIcon_Anim5Script ; entry 5
	sprite_object_entry ConnIcon_Anim6Frames, ConnIcon_Anim6Script ; entry 6

; ---- ptrtable $4794-$47A4 (16 bytes) [PROBABLE] list of 8 frame pointers (word0 of Table_69_4778 entries); each target is a count-prefixed OAM record

ConnIcon_Anim1Frames:: ; 69:4794
Table_69_4794::
	sprite_frame_table ConnIcon_Anim1Frame0, ConnIcon_Anim1Frame1, ConnIcon_Anim1Frame2, ConnIcon_Anim1Frame3
	sprite_frame_table ConnIcon_Anim1Frame4, ConnIcon_Anim1Frame5, ConnIcon_Anim1Frame6, ConnIcon_Anim1Frame7

; ---- data $47A4-$47C1 (29 bytes) [PROBABLE] sprite frame record: count=7 then 7 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim1Frame0:: ; 69:47A4
Data_69_47A4::
	sprite_frame 7
	sprite_oam 1, 8, $21, 5
	sprite_oam 1, 16, $22, 6
	sprite_oam 9, 8, $31, 5
	sprite_oam 9, 16, $32, 6
	sprite_oam 17, 0, $40, 6
	sprite_oam 17, 8, $41, 6
	sprite_oam 17, 16, $42, 6

; ---- data $47C1-$47E2 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim1Frame1:: ; 69:47C1
Data_69_47C1::
	sprite_frame 8
	sprite_oam 1, 8, $24, 5
	sprite_oam 1, 16, $25, 5
	sprite_oam 9, 0, $33, 6
	sprite_oam 9, 8, $34, 5
	sprite_oam 9, 16, $35, 5
	sprite_oam 17, 0, $43, 6
	sprite_oam 17, 8, $44, 6
	sprite_oam 17, 16, $45, 6

; ---- data $47E2-$4803 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim1Frame2:: ; 69:47E2
Data_69_47E2::
	sprite_frame 8
	sprite_oam 1, 8, $27, 5
	sprite_oam 1, 16, $28, 5
	sprite_oam 9, 0, $36, 5
	sprite_oam 9, 8, $37, 5
	sprite_oam 9, 16, $38, 5
	sprite_oam 17, 0, $46, 6
	sprite_oam 17, 8, $47, 6
	sprite_oam 17, 16, $48, 6

; ---- data $4803-$4824 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim1Frame3:: ; 69:4803
Data_69_4803::
	sprite_frame 8
	sprite_oam 1, 8, $24, 5
	sprite_oam 1, 16, $25, 5
	sprite_oam 9, 0, $33, 6
	sprite_oam 9, 8, $34, 5
	sprite_oam 9, 16, $35, 5
	sprite_oam 17, 0, $49, 6
	sprite_oam 17, 8, $4A, 6
	sprite_oam 17, 16, $4B, 6

; ---- data $4824-$4841 (29 bytes) [PROBABLE] sprite frame record: count=7 then 7 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim1Frame4:: ; 69:4824
Data_69_4824::
	sprite_frame 7
	sprite_oam 1, 8, $21, 5
	sprite_oam 1, 16, $22, 6
	sprite_oam 9, 8, $31, 5
	sprite_oam 9, 16, $32, 6
	sprite_oam 17, 0, $40, 6
	sprite_oam 17, 8, $41, 6
	sprite_oam 17, 16, $42, 6

; ---- data $4841-$4862 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim1Frame5:: ; 69:4841
Data_69_4841::
	sprite_frame 8
	sprite_oam 1, 8, $24, 5
	sprite_oam 1, 16, $25, 5
	sprite_oam 9, 0, $33, 6
	sprite_oam 9, 16, $35, 5
	sprite_oam 17, 0, $43, 6
	sprite_oam 17, 8, $44, 6
	sprite_oam 17, 16, $45, 6
	sprite_oam 9, 8, $2F, 5

; ---- data $4862-$4887 (37 bytes) [PROBABLE] sprite frame record: count=9 then 9 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim1Frame6:: ; 69:4862
Data_69_4862::
	sprite_frame 9
	sprite_oam 1, 0, $26, 5
	sprite_oam 1, 8, $27, 5
	sprite_oam 1, 16, $28, 5
	sprite_oam 9, 0, $36, 5
	sprite_oam 9, 16, $38, 5
	sprite_oam 17, 0, $46, 6
	sprite_oam 17, 8, $47, 6
	sprite_oam 17, 16, $48, 6
	sprite_oam 9, 8, $3F, 5

; ---- data $4887-$48AC (37 bytes) [PROBABLE] sprite frame record: count=9 then 9 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim1Frame7:: ; 69:4887
Data_69_4887::
	sprite_frame 9
	sprite_oam 1, 0, $23, 5
	sprite_oam 1, 8, $24, 5
	sprite_oam 1, 16, $25, 5
	sprite_oam 9, 0, $33, 6
	sprite_oam 9, 16, $35, 5
	sprite_oam 17, 0, $43, 6
	sprite_oam 17, 8, $44, 6
	sprite_oam 17, 16, $45, 6
	sprite_oam 9, 8, $2F, 5

; ---- data $48AC-$48B5 (9 bytes) [PROBABLE] count=4 then 4 x 2-byte pairs; word1 of an entry of Table_69_4778 (read via 00:0AB8 at +1..)

ConnIcon_Anim1Script:: ; 69:48AC
Data_69_48AC::
	sprite_anim 4
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
	sprite_anim_step 2, 8
	sprite_anim_step 3, 8

; ---- ptrtable $48B5-$48C5 (16 bytes) [PROBABLE] list of 8 frame pointers (word0 of Table_69_4778 entries); each target is a count-prefixed OAM record

ConnIcon_Anim2Frames:: ; 69:48B5
Table_69_48B5::
	sprite_frame_table ConnIcon_Anim2Frame0, ConnIcon_Anim2Frame1, ConnIcon_Anim2Frame2, ConnIcon_Anim2Frame3
	sprite_frame_table ConnIcon_Anim2Frame4, ConnIcon_Anim2Frame5, ConnIcon_Anim2Frame6, ConnIcon_Anim2Frame7

; ---- data $48C5-$48E2 (29 bytes) [PROBABLE] sprite frame record: count=7 then 7 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim2Frame0:: ; 69:48C5
Data_69_48C5::
	sprite_frame 7
	sprite_oam 1, 8, $21, 5
	sprite_oam 1, 16, $22, 6
	sprite_oam 9, 8, $31, 5
	sprite_oam 9, 16, $32, 6
	sprite_oam 17, 0, $40, 6
	sprite_oam 17, 8, $41, 6
	sprite_oam 17, 16, $42, 6

; ---- data $48E2-$4903 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim2Frame1:: ; 69:48E2
Data_69_48E2::
	sprite_frame 8
	sprite_oam 1, 8, $24, 5
	sprite_oam 1, 16, $25, 5
	sprite_oam 9, 0, $33, 6
	sprite_oam 9, 8, $34, 5
	sprite_oam 9, 16, $35, 5
	sprite_oam 17, 0, $43, 6
	sprite_oam 17, 8, $44, 6
	sprite_oam 17, 16, $45, 6

; ---- data $4903-$4924 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim2Frame2:: ; 69:4903
Data_69_4903::
	sprite_frame 8
	sprite_oam 1, 8, $27, 5
	sprite_oam 1, 16, $28, 5
	sprite_oam 9, 0, $36, 5
	sprite_oam 9, 8, $37, 5
	sprite_oam 9, 16, $38, 5
	sprite_oam 17, 0, $46, 6
	sprite_oam 17, 8, $47, 6
	sprite_oam 17, 16, $48, 6

; ---- data $4924-$4945 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim2Frame3:: ; 69:4924
Data_69_4924::
	sprite_frame 8
	sprite_oam 1, 8, $24, 5
	sprite_oam 1, 16, $25, 5
	sprite_oam 9, 0, $33, 6
	sprite_oam 9, 8, $34, 5
	sprite_oam 9, 16, $35, 5
	sprite_oam 17, 0, $49, 6
	sprite_oam 17, 8, $4A, 6
	sprite_oam 17, 16, $4B, 6

; ---- data $4945-$4962 (29 bytes) [PROBABLE] sprite frame record: count=7 then 7 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim2Frame4:: ; 69:4945
Data_69_4945::
	sprite_frame 7
	sprite_oam 1, 8, $21, 5
	sprite_oam 1, 16, $22, 6
	sprite_oam 9, 8, $31, 5
	sprite_oam 9, 16, $32, 6
	sprite_oam 17, 0, $40, 6
	sprite_oam 17, 8, $41, 6
	sprite_oam 17, 16, $42, 6

; ---- data $4962-$4983 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim2Frame5:: ; 69:4962
Data_69_4962::
	sprite_frame 8
	sprite_oam 1, 8, $24, 5
	sprite_oam 1, 16, $25, 5
	sprite_oam 9, 0, $33, 6
	sprite_oam 9, 16, $35, 5
	sprite_oam 17, 0, $43, 6
	sprite_oam 17, 8, $44, 6
	sprite_oam 17, 16, $45, 6
	sprite_oam 9, 8, $2F, 5

; ---- data $4983-$49A8 (37 bytes) [PROBABLE] sprite frame record: count=9 then 9 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim2Frame6:: ; 69:4983
Data_69_4983::
	sprite_frame 9
	sprite_oam 1, 0, $26, 5
	sprite_oam 1, 8, $27, 5
	sprite_oam 1, 16, $28, 5
	sprite_oam 9, 0, $36, 5
	sprite_oam 9, 16, $38, 5
	sprite_oam 17, 0, $46, 6
	sprite_oam 17, 8, $47, 6
	sprite_oam 17, 16, $48, 6
	sprite_oam 9, 8, $3F, 5

; ---- data $49A8-$49CD (37 bytes) [PROBABLE] sprite frame record: count=9 then 9 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim2Frame7:: ; 69:49A8
Data_69_49A8::
	sprite_frame 9
	sprite_oam 1, 0, $23, 5
	sprite_oam 1, 8, $24, 5
	sprite_oam 1, 16, $25, 5
	sprite_oam 9, 0, $33, 6
	sprite_oam 9, 16, $35, 5
	sprite_oam 17, 0, $43, 6
	sprite_oam 17, 8, $44, 6
	sprite_oam 17, 16, $45, 6
	sprite_oam 9, 8, $2F, 5

; ---- data $49CD-$49DE (17 bytes) [PROBABLE] count=8 then 8 x 2-byte pairs; word1 of an entry of Table_69_4778 (read via 00:0AB8 at +1..)

ConnIcon_Anim2Script:: ; 69:49CD
Data_69_49CD::
	sprite_anim 8
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
	sprite_anim_step 2, 8
	sprite_anim_step 3, 8
	sprite_anim_step 0, 8
	sprite_anim_step 5, 8
	sprite_anim_step 6, 8
	sprite_anim_step 7, 8

; ---- ptrtable $49DE-$49E0 (2 bytes) [PROBABLE] list of 1 frame pointers (word0 of Table_69_4778 entries); each target is a count-prefixed OAM record

ConnIcon_Anim3Frames:: ; 69:49DE
Table_69_49DE::
	sprite_frame_table ConnIcon_Anim3Frame0

; ---- data $49E0-$4A01 (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim3Frame0:: ; 69:49E0
Data_69_49E0::
	sprite_frame 8
	sprite_oam 1, 0, $2C, 5
	sprite_oam 1, 8, $2D, 5
	sprite_oam 9, 0, $3C, 5
	sprite_oam 9, 8, $3D, 5
	sprite_oam 9, 16, $3E, 5
	sprite_oam 17, 0, $40, 6
	sprite_oam 17, 8, $41, 6
	sprite_oam 17, 16, $42, 6

; ---- data $4A01-$4A05 (4 bytes) [PROBABLE] count=1 then 1 x 2-byte pairs; word1 of an entry of Table_69_4778 (read via 00:0AB8 at +1..) (+1 unreferenced trailing byte(s) 00 kept with this record)

ConnIcon_Anim3Script:: ; 69:4A01
Data_69_4A01::
	sprite_anim 1
	sprite_anim_step 0, 5
	db $00

; ---- ptrtable $4A05-$4A0B (6 bytes) [PROBABLE] list of 3 frame pointers (word0 of Table_69_4778 entries); each target is a count-prefixed OAM record

ConnIcon_Anim6Frames:: ; 69:4A05
Table_69_4A05::
	sprite_frame_table ConnIcon_Anim6Frame0, ConnIcon_Anim6Frame1, ConnIcon_Anim6Frame2

; ---- data $4A0B-$4A2C (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim6Frame0:: ; 69:4A0B
Data_69_4A0B::
	sprite_frame 8
	sprite_oam 1, 0, $2C, 5
	sprite_oam 1, 8, $2D, 5
	sprite_oam 9, 0, $3C, 5
	sprite_oam 9, 8, $3D, 5
	sprite_oam 9, 16, $3E, 5
	sprite_oam 17, 0, $4C, 6
	sprite_oam 17, 8, $4D, 6
	sprite_oam 17, 16, $4E, 6

; ---- data $4A2C-$4A49 (29 bytes) [PROBABLE] sprite frame record: count=7 then 7 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim6Frame1:: ; 69:4A2C
Data_69_4A2C::
	sprite_frame 7
	sprite_oam 17, 0, $4C, 6
	sprite_oam 17, 8, $4D, 6
	sprite_oam 17, 16, $4E, 6
	sprite_oam 1, 8, $4F, 5
	sprite_oam 9, 0, $55, 5
	sprite_oam 9, 8, $56, 5
	sprite_oam 9, 16, $57, 5

; ---- data $4A49-$4A6A (33 bytes) [PROBABLE] sprite frame record: count=8 then 8 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim6Frame2:: ; 69:4A49
Data_69_4A49::
	sprite_frame 8
	sprite_oam 17, 0, $4C, 6
	sprite_oam 17, 8, $4D, 6
	sprite_oam 17, 16, $4E, 6
	sprite_oam 1, 0, $50, 5
	sprite_oam 1, 8, $51, 5
	sprite_oam 9, 0, $58, 5
	sprite_oam 9, 8, $59, 5
	sprite_oam 9, 16, $5A, 5

; ---- data $4A6A-$4A73 (9 bytes) [PROBABLE] count=4 then 4 x 2-byte pairs; word1 of an entry of Table_69_4778 (read via 00:0AB8 at +1..)

ConnIcon_Anim6Script:: ; 69:4A6A
Data_69_4A6A::
	sprite_anim 4
	sprite_anim_step 0, 8
	sprite_anim_step 1, 20
	sprite_anim_step 0, 8
	sprite_anim_step 2, 20

; ---- ptrtable $4A73-$4A7B (8 bytes) [PROBABLE] list of 4 frame pointers (word0 of Table_69_4778 entries); each target is a count-prefixed OAM record

ConnIcon_Anim4Frames:: ; 69:4A73
Table_69_4A73::
	sprite_frame_table ConnIcon_Anim4Frame0, ConnIcon_Anim4Frame1, ConnIcon_Anim4Frame2, ConnIcon_Anim4Frame3

; ---- data $4A7B-$4AC4 (73 bytes) [PROBABLE] sprite frame record: count=18 then 18 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim4Frame0:: ; 69:4A7B
Data_69_4A7B::
	sprite_frame 18
	sprite_oam 0, 0, $20, 5
	sprite_oam 0, 8, $21, 5
	sprite_oam 0, 16, $22, 5
	sprite_oam 8, 0, $30, 5
	sprite_oam 8, 8, $31, 5
	sprite_oam 8, 16, $32, 5
	sprite_oam 16, 0, $40, 5
	sprite_oam 16, 8, $41, 5
	sprite_oam 16, 16, $42, 5
	sprite_oam 0, 0, $2C, 6
	sprite_oam 0, 8, $2D, 6
	sprite_oam 0, 16, $2E, 6
	sprite_oam 8, 0, $3C, 6
	sprite_oam 8, 8, $3D, 6
	sprite_oam 8, 16, $3E, 6
	sprite_oam 16, 0, $4C, 6
	sprite_oam 16, 8, $4D, 6
	sprite_oam 16, 16, $4E, 6

; ---- data $4AC4-$4B0D (73 bytes) [PROBABLE] sprite frame record: count=18 then 18 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim4Frame1:: ; 69:4AC4
Data_69_4AC4::
	sprite_frame 18
	sprite_oam 0, 0, $23, 5
	sprite_oam 0, 8, $24, 5
	sprite_oam 0, 16, $25, 5
	sprite_oam 8, 0, $33, 5
	sprite_oam 8, 8, $34, 5
	sprite_oam 8, 16, $35, 5
	sprite_oam 16, 0, $43, 5
	sprite_oam 16, 8, $44, 5
	sprite_oam 16, 16, $45, 5
	sprite_oam 0, 0, $2C, 6
	sprite_oam 0, 8, $2D, 6
	sprite_oam 0, 16, $2E, 6
	sprite_oam 8, 0, $3C, 6
	sprite_oam 8, 8, $3D, 6
	sprite_oam 8, 16, $3E, 6
	sprite_oam 16, 0, $4C, 6
	sprite_oam 16, 8, $4D, 6
	sprite_oam 16, 16, $4E, 6

; ---- data $4B0D-$4B56 (73 bytes) [PROBABLE] sprite frame record: count=18 then 18 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim4Frame2:: ; 69:4B0D
Data_69_4B0D::
	sprite_frame 18
	sprite_oam 0, 0, $26, 5
	sprite_oam 0, 8, $27, 5
	sprite_oam 0, 16, $28, 5
	sprite_oam 8, 0, $36, 5
	sprite_oam 8, 8, $37, 5
	sprite_oam 8, 16, $38, 5
	sprite_oam 16, 0, $46, 5
	sprite_oam 16, 8, $47, 5
	sprite_oam 16, 16, $48, 5
	sprite_oam 0, 0, $2C, 6
	sprite_oam 0, 8, $2D, 6
	sprite_oam 0, 16, $2E, 6
	sprite_oam 8, 0, $3C, 6
	sprite_oam 8, 8, $3D, 6
	sprite_oam 8, 16, $3E, 6
	sprite_oam 16, 0, $4C, 6
	sprite_oam 16, 8, $4D, 6
	sprite_oam 16, 16, $4E, 6

; ---- data $4B56-$4B9F (73 bytes) [PROBABLE] sprite frame record: count=18 then 18 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim4Frame3:: ; 69:4B56
Data_69_4B56::
	sprite_frame 18
	sprite_oam 0, 0, $29, 5
	sprite_oam 0, 8, $2A, 5
	sprite_oam 0, 16, $2B, 5
	sprite_oam 8, 0, $39, 5
	sprite_oam 8, 8, $3A, 5
	sprite_oam 8, 16, $3B, 5
	sprite_oam 16, 0, $49, 5
	sprite_oam 16, 8, $4A, 5
	sprite_oam 16, 16, $4B, 5
	sprite_oam 0, 0, $2C, 6
	sprite_oam 0, 8, $2D, 6
	sprite_oam 0, 16, $2E, 6
	sprite_oam 8, 0, $3C, 6
	sprite_oam 8, 8, $3D, 6
	sprite_oam 8, 16, $3E, 6
	sprite_oam 16, 0, $4C, 6
	sprite_oam 16, 8, $4D, 6
	sprite_oam 16, 16, $4E, 6

; ---- data $4B9F-$4BAB (12 bytes) [PROBABLE] count=4 then 4 x 2-byte pairs; word1 of an entry of Table_69_4778 (read via 00:0AB8 at +1..) (+3 unreferenced trailing byte(s) 010004 kept with this record)

ConnIcon_ObjAnimData:: ; 69:4B9F
Data_69_4B9F::
	sprite_anim 4
	sprite_anim_step 0, 12
	sprite_anim_step 1, 12
	sprite_anim_step 2, 12
	sprite_anim_step 3, 12
	db $01, $00, $04 ; not reached by any walked sprite chain

; ---- ptrtable $4BAB-$4BAF (4 bytes) [PROBABLE] list of 2 frame pointers (word0 of Table_69_4778 entries); each target is a count-prefixed OAM record

ConnIcon_Anim5Frames:: ; 69:4BAB
Table_69_4BAB::
	sprite_frame_table ConnIcon_Anim5Frame0, ConnIcon_Anim5Frame1

; ---- data $4BAF-$4BF8 (73 bytes) [PROBABLE] sprite frame record: count=18 then 18 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim5Frame0:: ; 69:4BAF
Data_69_4BAF::
	sprite_frame 18
	sprite_oam 1, 0, $20, 5
	sprite_oam 1, 8, $21, 5
	sprite_oam 1, 16, $22, 5
	sprite_oam 9, 0, $30, 5
	sprite_oam 9, 8, $31, 5
	sprite_oam 9, 16, $32, 5
	sprite_oam 17, 0, $40, 5
	sprite_oam 17, 8, $41, 5
	sprite_oam 17, 16, $42, 5
	sprite_oam 1, 0, $2C, 6
	sprite_oam 1, 8, $2D, 6
	sprite_oam 1, 16, $2E, 6
	sprite_oam 9, 0, $3C, 6
	sprite_oam 9, 8, $3D, 6
	sprite_oam 9, 16, $3E, 6
	sprite_oam 17, 0, $4C, 6
	sprite_oam 17, 8, $4D, 6
	sprite_oam 17, 16, $4E, 6

; ---- data $4BF8-$4C41 (73 bytes) [PROBABLE] sprite frame record: count=18 then 18 x 4 bytes (y,x,tile,attr-like: 3rd/4th byte e.g. 21 05); referenced from a Table_69 frame list

ConnIcon_Anim5Frame1:: ; 69:4BF8
Data_69_4BF8::
	sprite_frame 18
	sprite_oam 0, 0, $20, 5
	sprite_oam 0, 8, $21, 5
	sprite_oam 0, 16, $22, 5
	sprite_oam 8, 0, $30, 5
	sprite_oam 8, 8, $31, 5
	sprite_oam 8, 16, $32, 5
	sprite_oam 16, 0, $40, 5
	sprite_oam 16, 8, $41, 5
	sprite_oam 16, 16, $42, 5
	sprite_oam 0, 0, $2C, 6
	sprite_oam 0, 8, $2D, 6
	sprite_oam 0, 16, $2E, 6
	sprite_oam 8, 0, $3C, 6
	sprite_oam 8, 8, $3D, 6
	sprite_oam 8, 16, $3E, 6
	sprite_oam 16, 0, $4C, 6
	sprite_oam 16, 8, $4D, 6
	sprite_oam 16, 16, $4E, 6

; ---- data $4C41-$4C46 (5 bytes) [PROBABLE] count=2 then 2 x 2-byte pairs; word1 of an entry of Table_69_4778 (read via 00:0AB8 at +1..)

ConnIcon_Anim5Script:: ; 69:4C41
Data_69_4C41::
	sprite_anim 2
	sprite_anim_step 0, 20
	sprite_anim_step 1, 20
