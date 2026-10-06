; gfx/account/screens_bank5d.asm
; bank 5D, $4800-$7360 (11104 bytes); pinned by layout.link
; account screens art loaded by bank 68

SECTION "gfx/account/screens_bank5d", ROMX

; ---- gfx $4800-$4C00 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:5DFD: hl=$4800 a=$5D c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Account_PasswordEntry_Tiles9000Vb1:: ; 5D:4800
Data_5D_4800::
	INCBIN "gfx/account/screens_bank5d/tiles_4800.2bpp"

; ---- gfx $4C00-$5000 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:5E0F: hl=$4C00 a=$5D c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_Account_PasswordEntry_Tiles9400Vb1:: ; 5D:4C00
Data_5D_4C00::
	INCBIN "gfx/account/screens_bank5d/tiles_4c00.2bpp"

; ---- data $5000-$5320 (800 bytes) [CONFIRMED] read as data by executed code (in up to 7/18 scenarios); content class unknown [clipped from 4000-7318 by higher-priority evidence]

Data_5D_5000:: ; 5D:5000
	db $6F, $6F, $6F, $6F, $26, $27, $28, $29, $2A, $4E, $4F, $60, $61, $62, $63, $64
	db $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $36, $37, $38, $39, $3A, $5E, $5F, $70
	db $71, $72, $73, $74, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $00
	db $00, $00, $00, $00, $00, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F
	db $6F, $6F, $6F, $00, $00, $00, $00, $00, $00, $6F, $6F, $6F, $6F, $6F, $6F, $6F
	db $6F, $6F, $6F, $6F, $6F, $6F, $6F, $75, $76, $76, $76, $76, $75, $6F, $6F, $6F
	db $6F, $6F, $6F, $6F, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $10, $10, $10, $10, $10, $10, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $10, $10, $10, $10, $10, $10, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $0B, $0B, $0B, $0B, $0B
	db $2B, $09, $09, $09, $09, $09, $09, $09, $6F, $43, $44, $45, $46, $47, $48, $49
	db $4A, $4B, $4C, $4D, $4E, $4F, $60, $61, $62, $63, $64, $6F, $6F, $53, $54, $55
	db $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F, $70, $71, $72, $73, $74, $6F
	db $6F, $6F, $6F, $6F, $6F, $6F, $6F, $00, $00, $00, $00, $00, $00, $6F, $6F, $6F
	db $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $00, $00, $00, $00, $00
	db $00, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $75
	db $76, $76, $76, $76, $75, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $10, $10, $10, $10, $10
	db $10, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $10
	db $10, $10, $10, $10, $10, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $0B, $0B, $0B, $0B, $0B, $2B, $09, $09, $09, $09, $09, $09, $09
	db $6F, $65, $66, $67, $68, $45, $26, $27, $28, $29, $2A, $2B, $2C, $2D, $2E, $2F
	db $40, $41, $42, $6F, $6F, $6A, $6B, $6C, $6D, $55, $36, $37, $38, $39, $3A, $3B
	db $3C, $3D, $3E, $3F, $50, $51, $52, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $00
	db $00, $00, $00, $00, $00, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F
	db $6F, $6F, $6F, $00, $00, $00, $00, $00, $00, $6F, $6F, $6F, $6F, $6F, $6F, $6F
	db $6F, $6F, $6F, $6F, $6F, $6F, $6F, $75, $76, $76, $76, $76, $75, $6F, $6F, $6F
	db $6F, $6F, $6F, $6F, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $10, $10, $10, $10, $10, $10, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $10, $10, $10, $10, $10, $10, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $0B, $0B, $0B, $0B, $0B
	db $2B, $09, $09, $09, $09, $09, $09, $09, $6F, $6F, $69, $2D, $42, $26, $27, $28
	db $29, $2A, $2B, $2C, $2D, $2E, $2F, $40, $41, $42, $6F, $6F, $6F, $6F, $6E, $3D
	db $52, $36, $37, $38, $39, $3A, $3B, $3C, $3D, $3E, $3F, $50, $51, $52, $6F, $6F
	db $6F, $6F, $6F, $6F, $6F, $6F, $6F, $00, $00, $00, $00, $00, $00, $6F, $6F, $6F
	db $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $00, $00, $00, $00, $00
	db $00, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $75
	db $76, $76, $76, $76, $75, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $10, $10, $10, $10, $10
	db $10, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $10
	db $10, $10, $10, $10, $10, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $0B, $0B, $0B, $0B, $0B, $2B, $09, $09, $09, $09, $09, $09, $09

; ---- gfx $5320-$5720 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:6125: hl=$5320 a=$5D c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Account_PasswordIntro_Tiles9000Vb1:: ; 5D:5320
Data_5D_5320::
	INCBIN "gfx/account/screens_bank5d/tiles_5320.2bpp"

; ---- gfx $5720-$5B20 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:6137: hl=$5720 a=$5D c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_Account_PasswordIntro_Tiles9400Vb1:: ; 5D:5720
Data_5D_5720::
	INCBIN "gfx/account/screens_bank5d/tiles_5720.2bpp"

; ---- data $5B20-$5DF0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:6159: hl=$5B20 a=$5D b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Account_PasswordIntro:: ; 5D:5B20
Data_5D_5B20::
	INCBIN "gfx/account/screens_bank5d/tilemap_5b20.tilemap"
	INCBIN "gfx/account/screens_bank5d/tilemap_5b20.attrmap"

; ---- gfx $5DF0-$61F0 (1024 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (68:6238 68:6476); first: hdma_rom_to_vram at 68:6238: hl=$5DF0 a=$5D c=$40 de=$8801 (dest VRAM $8800, vbank=1)

Gfx_Account_ConfirmScreens_Tiles8800Vb1:: ; 5D:5DF0
Data_5D_5DF0::
	INCBIN "gfx/account/screens_bank5d/tiles_5df0.2bpp"

; ---- gfx $61F0-$63F0 (512 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (68:624A 68:6488); first: hdma_rom_to_vram at 68:624A: hl=$61F0 a=$5D c=$20 de=$8C01 (dest VRAM $8C00, vbank=1)

Gfx_Account_ConfirmScreens_Tiles8C00Vb1:: ; 5D:61F0
Data_5D_61F0::
	INCBIN "gfx/account/screens_bank5d/tiles_61f0.2bpp"

; ---- gfx $63F0-$65F0 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:625C: hl=$63F0 a=$5D c=$20 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Account_ConfirmScreen_Tiles9000Vb1:: ; 5D:63F0
Data_5D_63F0::
	INCBIN "gfx/account/screens_bank5d/tiles_63f0.2bpp"

; ---- data $65F0-$6630 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/account/confirm_screens.asm:54, call 68:627F executed 14 hits in 5 scenarios (analysis/coverage_union.tsv))

Palette_Account_ConfirmScreen_Bg:: ; 5D:65F0
Data_5D_65F0::
	INCLUDE "gfx/account/screens_bank5d/account_confirm_screen_bg.pal"

; ---- data $6630-$6900 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:62A1: hl=$6630 a=$5D b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Account_ConfirmScreen:: ; 5D:6630
Data_5D_6630::
	INCBIN "gfx/account/screens_bank5d/tilemap_6630.tilemap"
	INCBIN "gfx/account/screens_bank5d/tilemap_6630.attrmap"

; ---- gfx $6900-$6C00 (768 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:6B3D: hl=$6900 a=$5D c=$30 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_Registration_WriteConfig_Tiles8000:: ; 5D:6900
Data_5D_6900::
	INCBIN "gfx/account/screens_bank5d/tiles_6900.2bpp"

; ---- gfx $6C00-$6E00 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:6B19: hl=$6A00 a=$5D c=$40 de=$8801 (dest VRAM $8800, vbank=1) [clipped from 6A00-6E00 by higher-priority evidence]

Data_5D_6C00:: ; 5D:6C00
	INCBIN "gfx/account/screens_bank5d/tiles_6c00.2bpp"

; ---- gfx $6E00-$7000 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:6B2B: hl=$6E00 a=$5D c=$40 de=$9001 (dest VRAM $9000, vbank=1); the last $200 bytes of the old blob hold 2 palettes and the head of a tilemap pair; the blocks below type them by what the code reads, and the HDMA request that copies the tiles copies them into VRAM as well

Gfx_Registration_WriteConfig_Tiles9000Vb1:: ; 5D:6E00
Data_5D_6E00::
	INCBIN "gfx/account/screens_bank5d/tiles_6e00.2bpp"

; ---- data $7000-$7040 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/account/register_config.asm:48, call 68:6B4E executed 23 hits in 8 scenarios (analysis/coverage_union.tsv))

Palette_Registration_WriteConfig_Bg:: ; 5D:7000
	INCLUDE "gfx/account/screens_bank5d/registration_write_config_bg.pal"

; ---- data $7040-$7048 (8 bytes) [CONFIRMED] palette-rgb555: 4 colours (1 palettes) read by Palette_LoadToBuffer: +$00 bc=$08 into wPaletteBufObj (engine/account/register_config.asm:53, call 68:6B5F executed 23 hits in 8 scenarios (analysis/coverage_union.tsv))

Palette_Registration_WriteConfig_Obj:: ; 5D:7040
	INCLUDE "gfx/account/screens_bank5d/registration_write_config_obj.pal"

; ---- data $7048-$7318 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:6B70: hl=$7048 a=$5D b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Registration_WriteConfig_5D_7048:: ; 5D:7048
	INCBIN "gfx/account/screens_bank5d/registration_write_config_5d_7048.tilemap"
	INCBIN "gfx/account/screens_bank5d/registration_write_config_5d_7048.attrmap"

; ---- zero $7318-$731C (4 bytes) [PROBABLE] unread zero-pointer entry 0 of the
; object-table base; the known B=$81 caller selects entry 1 at $731C.
; No safe-sentinel claim: a zero script pointer is not validated by InitSlot.
Objects_Registration_WriteConfig:: ; 5D:7318
Table_5D_7318::
	ds $4, $00

; ---- data $731C-$735D (65 bytes) [CONFIRMED] selected object entry 1 and frame/script
; chain: pointers $7320/$7354, four frames with 2/2/6/0 OAM pieces, four script
; pairs (frames 0..3, delay 20). All 65 bytes naturally read in eight scenarios.
; Source bank $5D is saved by Sprite_InitSlot and reselected for frame/script reads.
Data_5D_731C:: ; 5D:731C
	sprite_object_entry SpriteFrameTable_5D_7320, SpriteScript_5D_7354 ; entry 1

SpriteFrameTable_5D_7320:: ; 5D:7320
	sprite_frame_table SpriteFrame_5D_7328, SpriteFrame_5D_7331, SpriteFrame_5D_733A, SpriteFrame_5D_7353
SpriteFrame_5D_7328:: ; 5D:7328
	sprite_frame 2
	sprite_oam 5, 12, $00, 0
	sprite_oam 6, 30, $01, 0
SpriteFrame_5D_7331:: ; 5D:7331
	sprite_frame 2
	sprite_oam 5, 5, $02, 0
	sprite_oam 6, 30, $03, 0
SpriteFrame_5D_733A:: ; 5D:733A
	sprite_frame 6
	sprite_oam 19, 5, $04, OAMF_YFLIP
	sprite_oam 19, 13, $05, OAMF_YFLIP
	sprite_oam 6, 30, $09, 0
	sprite_oam 11, 5, $06, OAMF_YFLIP
	sprite_oam 11, 13, $07, OAMF_YFLIP
	sprite_oam 3, 5, $08, OAMF_YFLIP
SpriteFrame_5D_7353:: ; 5D:7353
	sprite_frame 0
SpriteScript_5D_7354:: ; 5D:7354
	sprite_anim 4
	sprite_anim_step 0, 20
	sprite_anim_step 1, 20
	sprite_anim_step 2, 20
	sprite_anim_step 3, 20

; ---- zero $735D-$7360 (3 bytes) [PROBABLE] 3 x 00 (all bytes zero) between two read-data blocks
	ds $3, $00
