; gfx/address_book/address_picker.asm
; bank 2C, $6730-$741C (3308 bytes); pinned by layout.link
; picker tiles, tilemap, palettes, slot icon animation tables

SECTION "gfx/address_book/address_picker", ROMX

; ---- gfx $6730-$6B30 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2C:5907: hl=$6730 a=$2C c=$40 de=$9301 (dest VRAM $9300, vbank=1)

Gfx_AddrPick_Tiles9300Vb1:: ; 2C:6730

	INCBIN "gfx/address_book/address_picker/addr_pick_tiles9300.2bpp"

; ---- gfx $6B30-$6C30 (256 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2C:591C: hl=$6B30 a=$2C c=$10 de=$9701 (dest VRAM $9700, vbank=1)

Gfx_AddrPick_Tiles9700Vb1:: ; 2C:6B30

	INCBIN "gfx/address_book/address_picker/addr_pick_tiles9700.2bpp"

; ---- gfx $6C30-$6CC0 (144 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2C:58F2: hl=$6C30 a=$2C c=$09 de=$8F00 (dest VRAM $8F00, vbank=0)

Gfx_AddrBook_Tiles8F00:: ; 2C:6C30

	INCBIN "gfx/address_book/address_picker/addr_book_tiles8f00.2bpp"

; ---- data $6CC0-$6F90 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2C:595A: hl=$6CC0 a=$2C b=18 rows c=20 cols (tiles then attrs) de=$D000

Data_AddrPick_TilemapAttr:: ; 2C:6CC0

	INCBIN "gfx/address_book/address_picker/data_addr_pick_tilemap_attr.tilemap"
	INCBIN "gfx/address_book/address_picker/data_addr_pick_tilemap_attr.attrmap"

; ---- data $6F90-$6FD0 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/address_book/address_picker.asm:276, call 2C:58DD executed 12 hits in 7 scenarios (analysis/coverage_union.tsv))

Palette_AddrPick_Bg:: ; 2C:6F90

	INCLUDE "gfx/address_book/address_picker/addr_pick_bg.pal"

; ---- gfx $6FD0-$71D0 (512 bytes) [PROBABLE] 32 tiles (512 bytes) between the palette blocks 6F90 and 71D0; pixel coherence h=0.744 v=0.595; rendered and inspected (sprite/object art); no loader call found

AddrPick_CandidateTiles_6FD0:: ; 2C:6FD0
	INCBIN "gfx/address_book/address_picker/addr_pick_candidate_tiles_6fd0.2bpp"

; ---- data $71D0-$7210 (64 bytes) [CONFIRMED] 64-byte CGB palette block (8 x 4 RGB555 words, bit15 clear): copied by FarCall 4F:4000 (CopyBytes wrapper, bc=$40) to WRAM $D840 at 2C:58C9 (also 2A:4123, 2F:45FB). Replaces the mapper heuristic palette region 71EA-7262 (its tail is really the object table below)

Palette_AddrBook_Obj:: ; 2C:71D0

	INCLUDE "gfx/address_book/address_picker/addr_book_obj.pal"

; ---- ptrtable $7210-$7260 (80 bytes) [PROBABLE] 40 words, all inside $7260-$7422 of the same bank (animation/OAM frame data); tables of 4-byte entries (2 words) addressed by ld de,imm before FarCall 00:0A82 (init_object_from_table: Sprite_LoadObjectEntry (00:0AB8) selects DE + 4*(B&$3F); bit 7 of the original id separately controls repeat behavior); each 16-byte table = 4 identical-pair entries; caller 2C:5A1E ld de,$7220 (a=$2C b=$01)

Table_AddrSlotIcon_Anims:: ; 2C:7210

	sprite_object_entry AddrSlotIcon_Entries0To3_FramePointers, AddrSlotIcon_Entries0To3_AnimScript ; entry 0
	sprite_object_entry AddrSlotIcon_Entries0To3_FramePointers, AddrSlotIcon_Entries0To3_AnimScript ; entry 1
	sprite_object_entry AddrSlotIcon_Entries0To3_FramePointers, AddrSlotIcon_Entries0To3_AnimScript ; entry 2
	sprite_object_entry AddrSlotIcon_Entries0To3_FramePointers, AddrSlotIcon_Entries0To3_AnimScript ; entry 3
Table_AddrSlotIcon_Anims_Entry4:: ; 2C:7220
	sprite_object_entry AddrSlotIcon_Entry4_FramePointers, AddrSlotIcon_Entry4_AnimScript ; entry 4
	sprite_object_entry AddrSlotIcon_Entry4_FramePointers, AddrSlotIcon_Entry4_AnimScript ; entry 5
	sprite_object_entry AddrSlotIcon_Entry4_FramePointers, AddrSlotIcon_Entry4_AnimScript ; entry 6
	sprite_object_entry AddrSlotIcon_Entry4_FramePointers, AddrSlotIcon_Entry4_AnimScript ; entry 7
Table_AddrSlotIcon_Anims_Entry8:: ; 2C:7230
	sprite_object_entry AddrSlotIcon_Entry8_FramePointers, AddrSlotIcon_Entry8_AnimScript ; entry 8
	sprite_object_entry AddrSlotIcon_Entry8_FramePointers, AddrSlotIcon_Entry8_AnimScript ; entry 9
	sprite_object_entry AddrSlotIcon_Entry8_FramePointers, AddrSlotIcon_Entry8_AnimScript ; entry 10
	sprite_object_entry AddrSlotIcon_Entry8_FramePointers, AddrSlotIcon_Entry8_AnimScript ; entry 11
Table_AddrSlotIcon_Anims_Entry12:: ; 2C:7240
	sprite_object_entry AddrSlotIcon_Entry12_FramePointers, AddrSlotIcon_AnimScript ; entry 12
	sprite_object_entry AddrSlotIcon_Entry12_FramePointers, AddrSlotIcon_AnimScript ; entry 13
	sprite_object_entry AddrSlotIcon_Entry12_FramePointers, AddrSlotIcon_AnimScript ; entry 14
	sprite_object_entry AddrSlotIcon_Entry12_FramePointers, AddrSlotIcon_AnimScript ; entry 15
Table_AddrSlotIcon_Anims_Entry16:: ; 2C:7250
	sprite_object_entry AddrSlotIcon_Entry16_FramePointers, AddrSlotIcon_Entry16_AnimScript ; entry 16
	sprite_object_entry AddrSlotIcon_Entry16_FramePointers, AddrSlotIcon_Entry16_AnimScript ; entry 17
	sprite_object_entry AddrSlotIcon_Entry16_FramePointers, AddrSlotIcon_Entry16_AnimScript ; entry 18
	sprite_object_entry AddrSlotIcon_Entry16_FramePointers, AddrSlotIcon_Entry16_AnimScript ; entry 19

; ---- data $7260-$7355 (245 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; first target of Table_AddrSlotIcon_Anims (7260: dw 7264, dw 7279, then the frames) up to the CONFIRMED-read data at 7355

AddrSlotIcon_Entries0To3_FramePointers:: ; 2C:7260

	sprite_frame_table AddrSlotIcon_Entries0To3_Frame0, AddrSlotIcon_Entries0To3_Frame1
AddrSlotIcon_Entries0To3_Frame0:: ; 2C:7264
	sprite_frame 5
	sprite_oam -2, 1, $00, 0
	sprite_oam -2, 9, $01, 0
	sprite_oam -2, 17, $02, 0
	sprite_oam 6, 6, $03, 0
	sprite_oam 6, 14, $04, 0
AddrSlotIcon_Entries0To3_Frame1:: ; 2C:7279
	sprite_frame 5
	sprite_oam -2, 1, $00, 0
	sprite_oam -2, 9, $01, 0
	sprite_oam -2, 17, $02, 0
	sprite_oam 6, 6, $03, 0
	sprite_oam 6, 14, $04, 0
AddrSlotIcon_Entries0To3_AnimScript:: ; 2C:728E
	sprite_anim 1
	sprite_anim_step 0, 4
AddrSlotIcon_Entry4_FramePointers:: ; 2C:7291
	sprite_frame_table AddrSlotIcon_Entry4_Frame0
AddrSlotIcon_Entry4_Frame0:: ; 2C:7293
	sprite_frame 4
	sprite_oam 0, 8, $0D, 0
	sprite_oam 0, 16, $0E, 0
	sprite_oam 8, 8, $2E, 0
	sprite_oam 8, 16, $2F, 0
AddrSlotIcon_Entry4_AnimScript:: ; 2C:72A4
	sprite_anim 1
	sprite_anim_step 0, 4
AddrSlotIcon_Entry8_FramePointers:: ; 2C:72A7
	sprite_frame_table AddrSlotIcon_Entry8_Frame0
AddrSlotIcon_Entry8_Frame0:: ; 2C:72A9
	sprite_frame 4
	sprite_oam 0, 8, $01, 0
	sprite_oam 0, 16, $02, 0
	sprite_oam 8, 8, $03, 0
	sprite_oam 8, 16, $04, 0
AddrSlotIcon_Entry8_AnimScript:: ; 2C:72BA
	sprite_anim 1
	sprite_anim_step 0, 4
AddrSlotIcon_Entry12_FramePointers:: ; 2C:72BD
	sprite_frame_table AddrSlotIcon_Entry12_Frame0, AddrSlotIcon_Entry12_Frame1, AddrSlotIcon_Entry12_Frame2, AddrSlotIcon_Entry12_Frame3
	sprite_frame_table AddrSlotIcon_Entry12_Frame4
AddrSlotIcon_Entry12_Frame0:: ; 2C:72C7
	sprite_frame 4
	sprite_oam 0, 8, $0D, 0
	sprite_oam 0, 16, $0E, 0
	sprite_oam 8, 8, $2E, 0
	sprite_oam 8, 16, $2F, 0
AddrSlotIcon_Entry12_Frame1:: ; 2C:72D8
	sprite_frame 8
	sprite_oam 1, 8, $22, 0
	sprite_oam 1, 16, $23, 0
	sprite_oam 9, 16, $1F, 0
	sprite_oam 9, 8, $0F, 0
	sprite_oam 3, 8, $42, 2
	sprite_oam 3, 16, $42, 2
	sprite_oam 11, 8, $43, 2
	sprite_oam 11, 16, $43, 2
AddrSlotIcon_Entry12_Frame2:: ; 2C:72F9
	sprite_frame 8
	sprite_oam -7, 9, $24, 2
	sprite_oam -7, 17, $25, 2
	sprite_oam 1, 9, $26, 2
	sprite_oam 1, 17, $27, 2
	sprite_oam 3, 9, $42, 2
	sprite_oam 3, 17, $42, 2
	sprite_oam 4, 9, $42, 2
	sprite_oam 4, 17, $42, 2
AddrSlotIcon_Entry12_Frame3:: ; 2C:731A
	sprite_frame 8
	sprite_oam -5, 5, $28, 2
	sprite_oam -5, 13, $29, 2
	sprite_oam -5, 21, $2A, 2
	sprite_oam 3, 5, $2B, 2
	sprite_oam 3, 13, $2C, 2
	sprite_oam 3, 21, $2D, 2
	sprite_oam 4, 8, $42, 2
	sprite_oam 4, 16, $42, 2
AddrSlotIcon_Entry12_Frame4:: ; 2C:733B
	sprite_frame 6
	sprite_oam -3, 5, $19, 2
	sprite_oam -3, 13, $1A, 2
	sprite_oam -3, 21, $1B, 2
	sprite_oam 5, 5, $1C, 2
	sprite_oam 5, 13, $1D, 2
	sprite_oam 5, 21, $1E, 2
AddrSlotIcon_AnimScript:: ; 2C:7354
	db $05 ; sprite script kept as db: the item crosses the end of its block

; ---- sprite script step $7355-$7357 (2 bytes) [CONFIRMED] first frame/delay pair read by Sprite_LoadObjectEntry

AddrSlotIcon_AnimScript_FirstStep:: ; 2C:7355
	db $00, $05

; ---- data $7357-$741C (197 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; ends with the group 01 00 04 right before the code at 741C

AddrSlotIcon_ObjAnimData_2C_7357:: ; 2C:7357

	db $01, $05, $02, $05, $03, $03, $04, $12 ; not reached by any walked sprite chain
AddrSlotIcon_Entry16_FramePointers:: ; 2C:735F
	sprite_frame_table AddrSlotIcon_Entry16_Frame0, AddrSlotIcon_Entry16_Frame1, AddrSlotIcon_Entry16_Frame2, AddrSlotIcon_Entry16_Frame3
	sprite_frame_table AddrSlotIcon_Entry16_Frame4
AddrSlotIcon_Entry16_Frame0:: ; 2C:7369
	sprite_frame 4
	sprite_oam 0, 8, $01, 0
	sprite_oam 0, 16, $02, 0
	sprite_oam 8, 8, $03, 0
	sprite_oam 8, 16, $04, 0
AddrSlotIcon_Entry16_Frame1:: ; 2C:737A
	sprite_frame 8
	sprite_oam 1, 8, $05, 0
	sprite_oam 1, 16, $06, 0
	sprite_oam 9, 8, $07, 0
	sprite_oam 9, 16, $08, 0
	sprite_oam 3, 8, $42, 2
	sprite_oam 3, 16, $42, 2
	sprite_oam 11, 8, $43, 2
	sprite_oam 11, 16, $43, 2
AddrSlotIcon_Entry16_Frame2:: ; 2C:739B
	sprite_frame 8
	sprite_oam 1, 9, $26, 2
	sprite_oam 1, 17, $27, 2
	sprite_oam -7, 9, $20, 2
	sprite_oam -7, 17, $21, 2
	sprite_oam 3, 9, $42, 2
	sprite_oam 3, 17, $42, 2
	sprite_oam 4, 9, $42, 2
	sprite_oam 4, 17, $42, 2
AddrSlotIcon_Entry16_Frame3:: ; 2C:73BC
	sprite_frame 11
	sprite_oam 3, 5, $2B, 2
	sprite_oam 3, 13, $2C, 2
	sprite_oam 3, 21, $2D, 2
	sprite_oam -5, 5, $30, 2
	sprite_oam -5, 13, $31, 2
	sprite_oam -5, 21, $32, 2
	sprite_oam -13, 5, $33, 2
	sprite_oam -13, 13, $34, 2
	sprite_oam -13, 21, $35, 2
	sprite_oam 4, 8, $42, 2
	sprite_oam 4, 16, $42, 2
AddrSlotIcon_Entry16_Frame4:: ; 2C:73E9
	sprite_frame 9
	sprite_oam -10, 5, $10, 2
	sprite_oam -10, 13, $11, 2
	sprite_oam -10, 21, $12, 2
	sprite_oam -2, 5, $13, 2
	sprite_oam -2, 13, $14, 2
	sprite_oam -2, 21, $15, 2
	sprite_oam 6, 5, $16, 2
	sprite_oam 6, 13, $17, 2
	sprite_oam 6, 21, $18, 2
AddrSlotIcon_Entry16_AnimScript:: ; 2C:740E
	sprite_anim 5
	sprite_anim_step 0, 5
	sprite_anim_step 1, 5
	sprite_anim_step 2, 5
	sprite_anim_step 3, 3
	sprite_anim_step 4, 18
	db $01, $00, $04 ; not reached by any walked sprite chain
