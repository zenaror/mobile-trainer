; gfx/account/screens_bank71.asm
; bank 71, $4000-$6F44 (12100 bytes); pinned by layout.link
; account screens art loaded by bank 68

SECTION "gfx/account/screens_bank71", ROMX

; ---- gfx $4000-$4300 (768 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:749E: hl=$4000 a=$71 c=$30 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_CommPanel_Tiles8000:: ; 71:4000
Data_71_4000::
	INCBIN "gfx/account/screens_bank71/tiles_4000.2bpp"

; ---- gfx $4300-$4500 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:7468: hl=$4200 a=$71 c=$30 de=$8801 (dest VRAM $8800, vbank=1) [clipped from 4200-4500 by higher-priority evidence]

Data_71_4300:: ; 71:4300
	INCBIN "gfx/account/screens_bank71/tiles_4300.2bpp"

; ---- gfx $4500-$4890 (912 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:747A: hl=$4490 a=$71 c=$40 de=$9001 (dest VRAM $9000, vbank=1) [clipped from 4490-4890 by higher-priority evidence]

Data_71_4500:: ; 71:4500
	INCBIN "gfx/account/screens_bank71/tiles_4500.2bpp"

; ---- gfx $4890-$4C90 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:748C: hl=$4890 a=$71 c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_CommPanel_Tiles9400Vb1:: ; 71:4890
Data_71_4890::
	INCBIN "gfx/account/screens_bank71/tiles_4890.2bpp"

; ---- data $4C90-$4C98 (8 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown [clipped from 4000-4FB8 by higher-priority evidence]

Palette_CommPanel_Obj:: ; 71:4C90
Data_71_4C90::
	db $ED, $7D, $4A, $55, $A6, $3C, $FF, $01

; ---- data $4C98-$4F68 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:74D1: hl=$4C98 a=$71 b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_CommPanel_71_4C98:: ; 71:4C98
Data_71_4C98::
	INCBIN "gfx/account/screens_bank71/tilemap_4c98.tilemap"
	INCBIN "gfx/account/screens_bank71/tilemap_4c98.attrmap"

; ---- data $4F68-$4FB8 (80 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:74F5: hl=$4F68 a=$71 b=2 rows c=20 cols (tiles then attrs) de=$D200

Tilemap_CommPanel_71_4F68:: ; 71:4F68
Data_71_4F68::
	INCBIN "gfx/account/screens_bank71/tilemap_4f68.tilemap"
	INCBIN "gfx/account/screens_bank71/tilemap_4f68.attrmap"

; ---- words $4FB8-$4FC0 (8 bytes) [PROBABLE] sprite object table: 4-byte entries (frame-table ptr, animation-script ptr) indexed by B&7F, the layout read by init_object_from_table 00:0A82/00:0AB8; entry 0 is unused (zero); base $4FB8 is passed as de with a=$71 at call sites listed in analysis/gfx_candidates.tsv (object-table); entries 0000/0000 4FC0/5031

CommPanel_ObjTable:: ; 71:4FB8
Table_71_4FB8::
	dw $0000, $0000, CommPanel_Anim1Frames, CommPanel_Anim1Script

; ---- words $4FC0-$4FC6 (6 bytes) [PROBABLE] sprite frame table: 3 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

CommPanel_Anim1Frames:: ; 71:4FC0
Table_71_4FC0::
	dw CommPanel_Anim1Frame0, CommPanel_Anim1Frame1, CommPanel_Anim1Frame2

; ---- data $4FC6-$4FE7 (33 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 8 piece(s); length tiles exactly against the frame-table pointers

CommPanel_Anim1Frame0:: ; 71:4FC6
Data_71_4FC6::
	db $08, $00, $00, $00, $00, $00, $08, $01, $00, $00, $10, $02, $00, $08, $00, $03
	db $00, $08, $08, $04, $00, $08, $10, $05, $00, $10, $08, $06, $00, $10, $10, $07
	db $00

; ---- data $4FE7-$500C (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

CommPanel_Anim1Frame1:: ; 71:4FE7
Data_71_4FE7::
	db $09, $00, $00, $08, $00, $00, $08, $09, $00, $00, $10, $0A, $00, $08, $00, $0B
	db $00, $08, $08, $0C, $00, $08, $10, $0D, $00, $10, $00, $0E, $00, $10, $08, $0F
	db $00, $10, $10, $10, $00

; ---- data $500C-$5031 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

CommPanel_Anim1Frame2:: ; 71:500C
Data_71_500C::
	db $09, $00, $00, $11, $00, $00, $08, $12, $00, $00, $10, $13, $00, $08, $00, $14
	db $00, $08, $08, $15, $00, $08, $10, $16, $00, $10, $00, $17, $00, $10, $08, $18
	db $00, $10, $10, $19, $00

; ---- data $5031-$5038 (7 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 3 step(s), (frame,delay) pairs: 0:30 1:30 2:30

CommPanel_Anim1Script:: ; 71:5031
Data_71_5031::
	db $03, $00, $1E, $01, $1E, $02, $1E

; ---- data $5038-$5098 (96 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown [range trimmed from 4FBC-5098 by classify_g2]

Data_71_5038:: ; 71:5038
	db $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $09, $0A, $0B, $0C
	db $0D, $0E, $0F, $24, $25, $A0, $A0, $A0, $19, $1A, $1B, $1C, $1D, $1E, $1F, $34
	db $35, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $0A, $0A, $0A, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A

; ---- data $5098-$5340 (680 bytes) [PROBABLE] contiguous data block 5098-5340: 288 bytes were read as data by executed code in mGBA traces (2 separate read ranges, e.g. 50F8-5158,51B8-5278) and 392 bytes between/around those reads were never read; the whole run is one table/buffer read by index (gaps unread in the traces); content class not decoded [merged from 5 regions by classify_g2]

Data_71_5098:: ; 71:5098
	db $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $26, $27, $28, $29
	db $2A, $2B, $2C, $2D, $2E, $25, $A0, $A0, $36, $37, $38, $39, $3A, $3B, $3C, $3D
	db $3E, $35, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $0A, $0A, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $2F, $40, $41, $42
	db $43, $44, $0B, $45, $46, $2D, $2E, $25, $3F, $50, $51, $52, $53, $54, $1B, $55
	db $56, $3D, $3E, $35, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $26, $27, $28, $29
	db $0C, $47, $48, $49, $2D, $2E, $25, $A0, $36, $37, $38, $39, $1C, $57, $58, $59
	db $3D, $3E, $35, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $0A, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $77, $78, $0B, $4A
	db $76, $41, $0E, $0F, $24, $25, $A0, $A0, $7A, $7B, $1B, $5A, $79, $51, $1E, $1F
	db $34, $35, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $0A, $0A, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $4B, $4C, $4D, $4E
	db $4F, $0B, $60, $61, $2D, $2E, $25, $A0, $5B, $5C, $5D, $5E, $5F, $1B, $70, $71
	db $3D, $3E, $35, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $0A, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $62, $63, $64, $65, $43, $44, $0B, $A0, $A0, $A0, $A0, $A0, $72, $73, $74, $75
	db $53, $54, $1B, $A0, $A0, $A0, $A0, $A0, $67, $68, $69, $6A, $4E, $4F, $2D, $2E
	db $25, $A0, $A0, $A0, $6C, $6D, $6E, $6F, $5E, $5F, $3D, $3E, $35, $A0, $A0, $A0
	db $09, $09, $09, $09, $09, $09, $09, $0A, $0A, $0A, $0A, $0A, $09, $09, $09, $09
	db $09, $09, $09, $0A, $0A, $0A, $0A, $0A, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $0A, $0A, $0A, $09, $09, $09, $09, $09, $09, $09, $09, $09, $0A, $0A, $0A
	db $62, $63, $66, $43, $44, $0B, $A0, $A0, $A0, $A0, $A0, $A0, $72, $73, $6B, $53
	db $54, $1B, $A0, $A0, $A0, $A0, $A0, $A0, $67, $68, $69, $6A, $4E, $4F, $2D, $2E
	db $25, $A0, $A0, $A0, $6C, $6D, $6E, $6F, $5E, $5F, $3D, $3E, $35, $A0, $A0, $A0
	db $09, $09, $09, $09, $09, $09, $0A, $0A, $0A, $0A, $0A, $0A, $09, $09, $09, $09
	db $09, $09, $0A, $0A, $0A, $0A, $0A, $0A, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $0A, $0A, $0A, $09, $09, $09, $09, $09, $09, $09, $09, $09, $0A, $0A, $0A
	db $00, $00, $00, $00, $00, $00, $00, $00

; ---- gfx $5340-$5740 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:79DF: hl=$5340 a=$71 c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Registration_DeleteConfirm_Tiles9000Vb1:: ; 71:5340
Data_71_5340::
	INCBIN "gfx/account/screens_bank71/tiles_5340.2bpp"

; ---- gfx $5740-$5B40 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:79F1: hl=$5740 a=$71 c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_Registration_DeleteConfirm_Tiles9400Vb1:: ; 71:5740
Data_71_5740::
	INCBIN "gfx/account/screens_bank71/tiles_5740.2bpp"

; ---- gfx $5B40-$5DC0 (640 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:7A16: hl=$59C0 a=$71 c=$40 de=$9001 (dest VRAM $9000, vbank=1) [clipped from 59C0-5DC0 by higher-priority evidence]

Data_71_5B40:: ; 71:5B40
	INCBIN "gfx/account/screens_bank71/tiles_5b40.2bpp"

; ---- gfx $5DC0-$61C0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:7A28: hl=$5DC0 a=$71 c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_Registration_Delete_Tiles9400Vb1:: ; 71:5DC0
Data_71_5DC0::
	INCBIN "gfx/account/screens_bank71/tiles_5dc0.2bpp"

; ---- gfx $61C0-$6440 (640 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:7BF7: hl=$6140 a=$71 c=$30 de=$8000 (dest VRAM $8000, vbank=0) [clipped from 6140-6440 by higher-priority evidence]

Data_71_61C0:: ; 71:61C0
	INCBIN "gfx/account/screens_bank71/tiles_61c0.2bpp"

; ---- gfx $6440-$6580 (320 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:7BD3: hl=$6180 a=$71 c=$40 de=$8801 (dest VRAM $8800, vbank=1) [clipped from 6180-6580 by higher-priority evidence]

Data_71_6440:: ; 71:6440
	INCBIN "gfx/account/screens_bank71/tiles_6440.2bpp"

; ---- gfx $6580-$6680 (256 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:7BE5: hl=$6580 a=$71 c=$10 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Registration_DeleteExecute_Tiles9000Vb1:: ; 71:6580
Data_71_6580::
	INCBIN "gfx/account/screens_bank71/tiles_6580.2bpp"

; ---- data $6680-$6688 (8 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 5340-6F38 by higher-priority evidence]

Palette_Registration_Delete_Bg:: ; 71:6680
Data_71_6680::
	db $00, $00, $00, $00, $00, $00, $FF, $7F

; ---- data $6688-$66A0 (24 bytes) [PROBABLE] palette-rgb555: heuristic: 12 RGB555 words as 3 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Data_71_6688:: ; 71:6688
	INCLUDE "gfx/account/screens_bank71/palette_6688.pal"

; ---- data $66A0-$66C1 (33 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 5340-6F38 by higher-priority evidence]

Data_71_66A0:: ; 71:66A0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $DF, $25, $A0, $3A, $FF, $7F, $00, $00
	db $00

; ---- gfx $66C1-$66C8 (7 bytes) [PROBABLE] tiles-2bpp: heuristic: 82 coherent tiles (hsim2=0.618 vsim2=0.845, 4 blank) parity 1; 1449/1456 bytes also covered by call-site blocks [clipped from 66C1-6C71 by higher-priority evidence]

Data_71_66C1:: ; 71:66C1
	db $7C, $FF, $7F, $FF, $01, $1F, $00

; ---- data $66C8-$6998 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:7A02: hl=$66C8 a=$71 b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Registration_DeleteConfirm_71_66C8:: ; 71:66C8
Data_71_66C8::
	INCBIN "gfx/account/screens_bank71/tilemap_66c8.tilemap"
	INCBIN "gfx/account/screens_bank71/tilemap_66c8.attrmap"

; ---- data $6998-$6C68 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:7A39: hl=$6998 a=$71 b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Registration_DeleteConfirm_71_6998:: ; 71:6998
Data_71_6998::
	INCBIN "gfx/account/screens_bank71/tilemap_6998.tilemap"
	INCBIN "gfx/account/screens_bank71/tilemap_6998.attrmap"

; ---- data $6C68-$6F38 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:7C2A: hl=$6C68 a=$71 b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Registration_DeleteExecute:: ; 71:6C68
Data_71_6C68::
	INCBIN "gfx/account/screens_bank71/tilemap_6c68.tilemap"
	INCBIN "gfx/account/screens_bank71/tilemap_6c68.attrmap"

; ---- words $6F38-$6F40 (8 bytes) [PROBABLE] sprite object table: 4-byte entries (frame-table ptr, animation-script ptr) indexed by B&7F, the layout read by init_object_from_table 00:0A82/00:0AB8; entry 0 is unused (zero); base $6F38 is passed as de with a=$71 at 68:7C3B (`ld hl,$DA00 ; ld de,$6F38 ; ld a,$71 ; ld b,$81 ; farcall 00:0A82`), entry 1 = 6F40/6F6A [verifier: replaces the mapper 'tiles-2bpp' guess; the pointer chain tiles 6F38-6F6F byte for byte]

Registration_DeleteExecute_ObjTable:: ; 71:6F38
Table_71_6F38::
	dw $0000, $0000, Registration_DeleteExecute_Anim1Frames, Registration_DeleteExecute_Anim1Script

; ---- words $6F40-$6F44 (4 bytes) [PROBABLE] sprite frame table: 2 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record ($6F44, $6F69); extent = (first record - table)/2

Registration_DeleteExecute_Anim1Frames:: ; 71:6F40
Table_71_6F40::
	dw Registration_DeleteExecute_Anim1Frame0, Registration_DeleteExecute_Anim1Frame1
