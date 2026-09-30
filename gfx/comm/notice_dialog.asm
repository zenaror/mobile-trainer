; gfx/comm/notice_dialog.asm
; bank 50, $439A-$6D1E (10628 bytes); pinned by layout.link
; eight notice screen tilemaps, tiles, palettes, cursor animations

SECTION "gfx/comm/notice_dialog", ROMX

; ---- data $439A-$4502 (360 bytes) [PROBABLE] screen 1 of 8: 20x18 tile-id map (360 bytes); block address is entry 0 of Table_50_4244 (50:4254 indexes it by wRam_C1CD-1) and is copied by Function_00_08EA (bc=$1214: 18 rows x 20 bytes, dest stride 32) to $D000 (WRAM bank 7)

Tilemap_CommNotice_A_CutOver60:: ; 50:439A
Tilemap_50_439A::
	INCBIN "gfx/comm/notice_dialog/comm_notice_a_cut_over60.tilemap"

; ---- data $4502-$466A (360 bytes) [PROBABLE] attribute map paired with Tilemap_50_439A: 08EA's second call copies the following 20x18 block to dest+$0400 (=$D400); values ($08,$28,...) look like CGB BG attributes (bit3 tile VRAM bank, bit5 xflip) - meaning of the buffers HYPOTHESIS

Attrmap_50_4502:: ; 50:4502
	INCBIN "gfx/comm/notice_dialog/attrmap_4502.attrmap"

; ---- data $466A-$47D2 (360 bytes) [PROBABLE] screen 2 of 8: 20x18 tile-id map (360 bytes); block address is entry 1 of Table_50_4244 (50:4254 indexes it by wRam_C1CD-1) and is copied by Function_00_08EA (bc=$1214: 18 rows x 20 bytes, dest stride 32) to $D000 (WRAM bank 7)

Tilemap_CommNotice_A_AskOver60:: ; 50:466A
Tilemap_50_466A::
	INCBIN "gfx/comm/notice_dialog/comm_notice_a_ask_over60.tilemap"

; ---- data $47D2-$493A (360 bytes) [PROBABLE] attribute map paired with Tilemap_50_466A: 08EA's second call copies the following 20x18 block to dest+$0400 (=$D400); values ($08,$28,...) look like CGB BG attributes (bit3 tile VRAM bank, bit5 xflip) - meaning of the buffers HYPOTHESIS

Attrmap_50_47D2:: ; 50:47D2
	INCBIN "gfx/comm/notice_dialog/attrmap_47d2.attrmap"

; ---- data $493A-$4AA2 (360 bytes) [PROBABLE] screen 3 of 8: 20x18 tile-id map (360 bytes); block address is entry 2 of Table_50_4244 (50:4254 indexes it by wRam_C1CD-1) and is copied by Function_00_08EA (bc=$1214: 18 rows x 20 bytes, dest stride 32) to $D000 (WRAM bank 7)

Tilemap_CommNotice_A_CutSoon:: ; 50:493A
Tilemap_50_493A::
	INCBIN "gfx/comm/notice_dialog/comm_notice_a_cut_soon.tilemap"

; ---- data $4AA2-$4C0A (360 bytes) [PROBABLE] attribute map paired with Tilemap_50_493A: 08EA's second call copies the following 20x18 block to dest+$0400 (=$D400); values ($08,$28,...) look like CGB BG attributes (bit3 tile VRAM bank, bit5 xflip) - meaning of the buffers HYPOTHESIS

Attrmap_50_4AA2:: ; 50:4AA2
	INCBIN "gfx/comm/notice_dialog/attrmap_4aa2.attrmap"

; ---- data $4C0A-$4D72 (360 bytes) [CONFIRMED] screen 4 of 8: 20x18 tile-id map (360 bytes); block address is entry 3 of Table_50_4244 (50:4254 indexes it by wRam_C1CD-1) and is copied by Function_00_08EA (bc=$1214: 18 rows x 20 bytes, dest stride 32) to $D000 (WRAM bank 7) [verifier: CONFIRMED - executed data read: traces/detail/browser_pages/dataaccess.tsv 'rom_read 50 4C0A 4EDA' = exactly this tilemap + attrmap pair, and 'rom_read 50 4390 4392' = entry 3 of Table_50_438A, i.e. screen 4 was selected through Table_50_4244 entry 3 ($424A-424C read); the 360+360 split follows 00:08EA (b=$12 rows x c=$14, second copy at dest+$400)]

Tilemap_CommNotice_A_AskSoon:: ; 50:4C0A
Tilemap_50_4C0A::
	INCBIN "gfx/comm/notice_dialog/comm_notice_a_ask_soon.tilemap"

; ---- data $4D72-$4EDA (360 bytes) [CONFIRMED] attribute map paired with Tilemap_50_4C0A: 08EA's second call copies the following 20x18 block to dest+$0400 (=$D400); values ($08,$28,...) look like CGB BG attributes (bit3 tile VRAM bank, bit5 xflip) - meaning of the buffers HYPOTHESIS [verifier: CONFIRMED - executed data read: traces/detail/browser_pages/dataaccess.tsv 'rom_read 50 4C0A 4EDA' = exactly this tilemap + attrmap pair, and 'rom_read 50 4390 4392' = entry 3 of Table_50_438A, i.e. screen 4 was selected through Table_50_4244 entry 3 ($424A-424C read); the 360+360 split follows 00:08EA (b=$12 rows x c=$14, second copy at dest+$400)]

Attrmap_50_4D72:: ; 50:4D72
	INCBIN "gfx/comm/notice_dialog/attrmap_4d72.attrmap"

; ---- data $4EDA-$5042 (360 bytes) [PROBABLE] screen 5 of 8: 20x18 tile-id map (360 bytes); block address is entry 4 of Table_50_4244 (50:4254 indexes it by wRam_C1CD-1) and is copied by Function_00_08EA (bc=$1214: 18 rows x 20 bytes, dest stride 32) to $D000 (WRAM bank 7)

Tilemap_CommNotice_B_CutOver60:: ; 50:4EDA
Tilemap_50_4EDA::
	INCBIN "gfx/comm/notice_dialog/comm_notice_b_cut_over60.tilemap"

; ---- data $5042-$51AA (360 bytes) [PROBABLE] attribute map paired with Tilemap_50_4EDA: 08EA's second call copies the following 20x18 block to dest+$0400 (=$D400); values ($08,$28,...) look like CGB BG attributes (bit3 tile VRAM bank, bit5 xflip) - meaning of the buffers HYPOTHESIS

Attrmap_50_5042:: ; 50:5042
	INCBIN "gfx/comm/notice_dialog/attrmap_5042.attrmap"

; ---- data $51AA-$5312 (360 bytes) [PROBABLE] screen 6 of 8: 20x18 tile-id map (360 bytes); block address is entry 5 of Table_50_4244 (50:4254 indexes it by wRam_C1CD-1) and is copied by Function_00_08EA (bc=$1214: 18 rows x 20 bytes, dest stride 32) to $D000 (WRAM bank 7)

Tilemap_CommNotice_B_AskOver60:: ; 50:51AA
Tilemap_50_51AA::
	INCBIN "gfx/comm/notice_dialog/comm_notice_b_ask_over60.tilemap"

; ---- data $5312-$547A (360 bytes) [PROBABLE] attribute map paired with Tilemap_50_51AA: 08EA's second call copies the following 20x18 block to dest+$0400 (=$D400); values ($08,$28,...) look like CGB BG attributes (bit3 tile VRAM bank, bit5 xflip) - meaning of the buffers HYPOTHESIS

Attrmap_50_5312:: ; 50:5312
	INCBIN "gfx/comm/notice_dialog/attrmap_5312.attrmap"

; ---- data $547A-$55E2 (360 bytes) [PROBABLE] screen 7 of 8: 20x18 tile-id map (360 bytes); block address is entry 6 of Table_50_4244 (50:4254 indexes it by wRam_C1CD-1) and is copied by Function_00_08EA (bc=$1214: 18 rows x 20 bytes, dest stride 32) to $D000 (WRAM bank 7)

Tilemap_CommNotice_B_CutSoon:: ; 50:547A
Tilemap_50_547A::
	INCBIN "gfx/comm/notice_dialog/comm_notice_b_cut_soon.tilemap"

; ---- data $55E2-$574A (360 bytes) [PROBABLE] attribute map paired with Tilemap_50_547A: 08EA's second call copies the following 20x18 block to dest+$0400 (=$D400); values ($08,$28,...) look like CGB BG attributes (bit3 tile VRAM bank, bit5 xflip) - meaning of the buffers HYPOTHESIS

Attrmap_50_55E2:: ; 50:55E2
	INCBIN "gfx/comm/notice_dialog/attrmap_55e2.attrmap"

; ---- data $574A-$58B2 (360 bytes) [PROBABLE] screen 8 of 8: 20x18 tile-id map (360 bytes); block address is entry 7 of Table_50_4244 (50:4254 indexes it by wRam_C1CD-1) and is copied by Function_00_08EA (bc=$1214: 18 rows x 20 bytes, dest stride 32) to $D000 (WRAM bank 7)

Tilemap_CommNotice_B_AskSoon:: ; 50:574A
Tilemap_50_574A::
	INCBIN "gfx/comm/notice_dialog/comm_notice_b_ask_soon.tilemap"

; ---- data $58B2-$5A1A (360 bytes) [PROBABLE] attribute map paired with Tilemap_50_574A: 08EA's second call copies the following 20x18 block to dest+$0400 (=$D400); values ($08,$28,...) look like CGB BG attributes (bit3 tile VRAM bank, bit5 xflip) - meaning of the buffers HYPOTHESIS

Attrmap_50_58B2:: ; 50:58B2
	INCBIN "gfx/comm/notice_dialog/attrmap_58b2.attrmap"

; ---- zero $5A1A-$5A20 (6 bytes) [PROBABLE] 6 bytes of $00 between the last attribute map (ends 5A1A) and the tiles loaded from 5A20 (padding)
	ds $6, $00

; ---- gfx $5A20-$5E20 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 50:40AE: hl=$5A20 a=$50 c=$40 de=$9000 (dest VRAM $9000, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

Data_50_5A20:: ; 50:5A20
	INCBIN "gfx/comm/notice_dialog/tiles_5a20.2bpp"

; ---- gfx $5E20-$5FC0 (416 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 50:40C0: hl=$5E20 a=$50 c=$1A de=$9400 (dest VRAM $9400, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

Data_50_5E20:: ; 50:5E20
	INCBIN "gfx/comm/notice_dialog/tiles_5e20.2bpp"

; ---- gfx $5FC0-$5FD0 (16 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 50:40D2: hl=$5FC0 a=$50 c=$01 de=$8001 (dest VRAM $8000, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_50_5FC0:: ; 50:5FC0
	INCBIN "gfx/comm/notice_dialog/tiles_5fc0.2bpp"

; ---- gfx $5FD0-$62F0 (800 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 50:40E4: hl=$5FD0 a=$50 c=$32 de=$9001 (dest VRAM $9000, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_50_5FD0:: ; 50:5FD0
	INCBIN "gfx/comm/notice_dialog/tiles_5fd0.2bpp"

; ---- gfx $62F0-$66F0 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 50:417F: hl=$62F0 a=$50 c=$40 de=$9000 (dest VRAM $9000, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

Data_50_62F0:: ; 50:62F0
	INCBIN "gfx/comm/notice_dialog/tiles_62f0.2bpp"

; ---- gfx $66F0-$6890 (416 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 50:4191: hl=$66F0 a=$50 c=$1A de=$9400 (dest VRAM $9400, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

Data_50_66F0:: ; 50:66F0
	INCBIN "gfx/comm/notice_dialog/tiles_66f0.2bpp"

; ---- gfx $6890-$68A0 (16 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 50:41A3: hl=$6890 a=$50 c=$01 de=$8001 (dest VRAM $8000, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_50_6890:: ; 50:6890
	INCBIN "gfx/comm/notice_dialog/tiles_6890.2bpp"

; ---- gfx $68A0-$6BC0 (800 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 50:41B5: hl=$68A0 a=$50 c=$32 de=$9001 (dest VRAM $9000, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_50_68A0:: ; 50:68A0
	INCBIN "gfx/comm/notice_dialog/tiles_68a0.2bpp"

; ---- data $6BC0-$6CC0 (256 bytes) [PROBABLE] 128 RGB555 words (bit15 clear in all, $7FFF white, 4-colour groups); far-call sites 50:40F5, 50:416A, 50:41C6 and 50:423B load $40 bytes each from $6BC0, $6C40, $6C00 and $6C80 (verifier: four sites cover all 256 bytes exactly) via 4F:4000 into $D800/$D840 (palette upload buffers - role of 4F:4000 not re-verified); replaces the clipped 1-byte gfx + 255-byte palette split

Palette_50_6BC0:: ; 50:6BC0
	INCLUDE "gfx/comm/notice_dialog/palette_6bc0.pal"

; ---- words $6CC0-$6CC4 (4 bytes) [PROBABLE] animation entry A frame-table: 2 word pointers to $6CC4/$6CD5 (the frame table pointed to by slot[2..3] loaded by 00:0AB8)

Table_50_6CC0:: ; 50:6CC0
	dw Data_50_6CC4, $6CD5

; ---- data $6CC4-$6CE6 (34 bytes) [PROBABLE] 2 sprite frames (17 bytes each): count=4 then 4x(y,x,tile,attr), e.g. ff ff 00 08 / 0b ff 00 48 / 0b 1b 00 68 / ff 1b 00 28 (attr bit6/5 = flips); matches the (Y,X,tile,attr) tuples the engine at 00:0AE8 emits

Data_50_6CC4:: ; 50:6CC4
	db $04, $FF, $FF, $00, $08, $0B, $FF, $00, $48, $0B, $1B, $00, $68, $FF, $1B, $00
	db $28, $04, $FE, $FE, $00, $08, $0C, $FE, $00, $48, $0C, $1C, $00, $68, $FE, $1C
	db $00, $28

; ---- data $6CE6-$6CEB (5 bytes) [HYPOTHESIS] 5-byte record referenced as 2nd word of animation entry 0 (Table_50_6D16); read through slot[6..7] by 00:0AB8 (bytes 1,2 copied to slot[9..A]); assumed animation script (02 00 2e 01 08)

Data_50_6CE6:: ; 50:6CE6
	db $02, $00, $2E, $01, $08

; ---- words $6CEB-$6CEF (4 bytes) [PROBABLE] animation entry B frame-table: pointers $6CEF/$6D00

Table_50_6CEB:: ; 50:6CEB
	dw Data_50_6CEF, $6D00

; ---- data $6CEF-$6D11 (34 bytes) [PROBABLE] 2 sprite frames (17 bytes each), same format as 6CC4 (count + 4x y,x,tile,attr)

Data_50_6CEF:: ; 50:6CEF
	db $04, $FF, $FF, $00, $08, $0B, $FF, $00, $48, $0B, $1B, $00, $68, $FF, $1B, $00
	db $28, $04, $FE, $FE, $00, $08, $0C, $FE, $00, $48, $0C, $1C, $00, $68, $FE, $1C
	db $00, $28

; ---- data $6D11-$6D16 (5 bytes) [HYPOTHESIS] 5-byte record, 2nd word of animation entry 1 (Table_50_6D16): 02 00 2e 01 08 identical to 6CE6

Data_50_6D11:: ; 50:6D11
	db $02, $00, $2E, $01, $08

; ---- words $6D16-$6D1E (8 bytes) [PROBABLE] animation table of 2 four-byte entries (frame-table ptr, script ptr): $6CC0,$6CE6 / $6CEB,$6D11; used as DE of 00:0A82 (sprite slot init: 4*(A&7F) indexed) at 50:4150 (ld de,$6D16 with b=$80) [00:0AB8 layout verified from ROM0 disassembly]

Table_50_6D16:: ; 50:6D16
	dw Table_50_6CC0, Data_50_6CE6, Table_50_6CEB, Data_50_6D11
