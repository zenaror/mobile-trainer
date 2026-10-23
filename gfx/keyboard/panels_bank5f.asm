; gfx/keyboard/panels_bank5f.asm
; bank 5F, $4000-$6BD0 (11216 bytes); pinned by layout.link
; keyboard panels, tilemaps, object tables loaded by bank 55

SECTION "gfx/keyboard/panels_bank5f", ROMX

; ---- gfx $4000-$4400 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:6A8A: hl=$4000 a=$5F c=$40 de=$8801 (dest VRAM $8800, vbank=1)

Gfx_Kbd_T9_Tiles8800Vb1:: ; 5F:4000

	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type9_vram8800_vb1_tiles.2bpp"

; ---- gfx $4400-$4800 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:6A9C: hl=$4400 a=$5F c=$40 de=$8C01 (dest VRAM $8C00, vbank=1)

Gfx_Kbd_T9_Tiles8C00Vb1:: ; 5F:4400

	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type9_vram8c00_vb1_tiles.2bpp"

; ---- gfx $4800-$4810 (16 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:6AAE: hl=$4800 a=$5F c=$01 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Kbd_T9_Tiles9000Vb1:: ; 5F:4800

	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type9_vram9000_vb1_tiles.2bpp"

; ---- data $4810-$49C8 (440 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 55:6ABF: hl=$4810 a=$5F b=11 rows c=20 cols (tiles then attrs) de=$D240

Tilemap_Kbd_T9:: ; 5F:4810

	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type9_panel.tilemap"
	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type9_panel.attrmap"

; ---- zero $49C8-$49D0 (8 bytes) [PROBABLE] 0x00 padding at the end of the tilemap block, before the tile block at $49D0
	ds $8, $00

; ---- gfx $49D0-$4CD0 (768 bytes) [CONFIRMED] tiles-vram: 8 call site(s) (55:5C00 67:5184 67:5771 67:65B1); first: hdma_rom_to_vram at 55:5C00: hl=$49D0 a=$5F c=$30 de=$8001 (dest VRAM $8000, vbank=1)

Gfx_SharedPanels_Vram8000Vb1:: ; 5F:49D0
	INCBIN "gfx/keyboard/panels_bank5f/shared_keyboard_panel_vram8000_vb1_tiles.2bpp"

; ---- data $4CD0-$4CF8 (40 bytes) [CONFIRMED] RGB555 block: BG6..7 at +0 (16 bytes) and OBJ5..7 at
; +$10 (24 bytes). All nine bank-aware palette consumers ran naturally; the object table begins at
; $4CF8 without overlap. Exact ROM words and RGB source agree; no final-display or hardware claim.

Palette_SharedPanels_BgObj:: ; 5F:4CD0

	INCLUDE "gfx/keyboard/panels_bank5f/shared_panel_bg6_7_obj5_7_palettes.pal"

; ---- words $4CF8-$4D48 (80 bytes) [PROBABLE] sprite object table: 4-byte entries (frame-table ptr, animation-script ptr) indexed by B&7F, the layout read by init_object_from_table 00:0A82/00:0AB8; rows of 16 bytes = the same entry repeated 4 times; base $4CF8 is passed as de with a=$5F at call sites listed in analysis/gfx_candidates.tsv (object-table); entries 0000/0000 4D48/4D7E 4D9A/4DC0 0000/0000 4DE3/4DFE 4E01/4E20 4E23/4E42 4DC5/4DE0 0000/0000 4E45/4E54 4E57/4E66 4E69/4E78 4E7B/4E8A 4E8D/4E9C 0000/0000 4D83/4D95 0000/0000 4E9F/4EB2 0000/0000 4EB5/4EC8

Kbd_ObjTable:: ; 5F:4CF8

	sprite_object_entry 0, 0 ; entry 0
	sprite_object_entry Kbd_Anim1Frames, Kbd_Anim1Script ; entry 1
	sprite_object_entry Kbd_Anim2Frames, Kbd_Anim2Script ; entry 2
Kbd_ObjTable_Entry3:: ; 5F:4D04
	sprite_object_entry 0, 0 ; entry 3
	sprite_object_entry Kbd_Anim4Frames, Kbd_Anim4Script ; entry 4
	sprite_object_entry Kbd_Anim5Frames, Kbd_Anim5Script ; entry 5
	sprite_object_entry Kbd_Anim6Frames, Kbd_Anim6Script ; entry 6
	sprite_object_entry Kbd_Anim7Frames, Kbd_Anim7Script ; entry 7
Kbd_ObjTable_Entry8:: ; 5F:4D18
	sprite_object_entry 0, 0 ; entry 8
	sprite_object_entry Kbd_Anim9Frames, Kbd_Anim9Script ; entry 9
	sprite_object_entry Kbd_Anim10Frames, Kbd_Anim10Script ; entry 10
	sprite_object_entry Kbd_Anim11Frames, Kbd_Anim11Script ; entry 11
	sprite_object_entry Kbd_Anim12Frames, Kbd_Anim12Script ; entry 12
	sprite_object_entry Kbd_Anim13Frames, Kbd_Anim13Script ; entry 13
Kbd_ObjTable_Entry14:: ; 5F:4D30
	sprite_object_entry 0, 0 ; entry 14
	sprite_object_entry Kbd_Anim15Frames, Kbd_Anim15Script ; entry 15
Kbd_ObjTable_Entry16:: ; 5F:4D38
	sprite_object_entry 0, 0 ; entry 16
	sprite_object_entry Kbd_Anim17Frames, Kbd_Anim17Script ; entry 17
Kbd_ObjTable_Entry18:: ; 5F:4D40
	sprite_object_entry 0, 0 ; entry 18
	sprite_object_entry Kbd_Anim19Frames, Kbd_Anim19Script ; entry 19

; ---- words $4D48-$4D4C (4 bytes) [PROBABLE] sprite frame table: 2 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Kbd_Anim1Frames:: ; 5F:4D48

	sprite_frame_table Kbd_Anim1Frame0, Kbd_Anim1Frame1

; ---- data $4D4C-$4D65 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Kbd_Anim1Frame0:: ; 5F:4D4C
	sprite_frame 6
	sprite_oam -4, 1, $24, OAMF_BANK1 | 6
	sprite_oam 4, 1, $25, OAMF_BANK1 | 6
	sprite_oam -1, 0, $20, OAMF_BANK1 | 6
	sprite_oam -1, 8, $21, OAMF_BANK1 | 6
	sprite_oam 7, 0, $22, OAMF_BANK1 | 6
	sprite_oam 7, 8, $23, OAMF_BANK1 | 6

; ---- data $4D65-$4D7E (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Kbd_Anim1Frame1:: ; 5F:4D65
	sprite_frame 6
	sprite_oam -5, 1, $24, OAMF_BANK1 | 6
	sprite_oam 3, 1, $25, OAMF_BANK1 | 6
	sprite_oam -1, 0, $20, OAMF_BANK1 | 6
	sprite_oam -1, 8, $21, OAMF_BANK1 | 6
	sprite_oam 7, 0, $22, OAMF_BANK1 | 6
	sprite_oam 7, 8, $23, OAMF_BANK1 | 6

; ---- data $4D7E-$4D83 (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:46 1:8

Kbd_Anim1Script:: ; 5F:4D7E
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $4D83-$4D87 (4 bytes) [PROBABLE] sprite frame table: 2 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Kbd_Anim15Frames:: ; 5F:4D83

	sprite_frame_table Kbd_Anim15Frame0, Kbd_Anim15Frame1

; ---- data $4D87-$4D90 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

Kbd_Anim15Frame0:: ; 5F:4D87
	sprite_frame 2
	sprite_oam 0, 0, $26, OAMF_BANK1 | 7
	sprite_oam 8, 0, $27, OAMF_BANK1 | 7

; ---- data $4D90-$4D95 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Kbd_Anim15Frame1:: ; 5F:4D90
	sprite_frame 1
	sprite_oam 0, 0, $28, OAMF_BANK1 | 7

; ---- data $4D95-$4D9A (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:20 1:20

Kbd_Anim15Script:: ; 5F:4D95
	sprite_anim 2
	sprite_anim_step 0, 20
	sprite_anim_step 1, 20

; ---- words $4D9A-$4D9E (4 bytes) [PROBABLE] sprite frame table: 2 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Kbd_Anim2Frames:: ; 5F:4D9A

	sprite_frame_table Kbd_Anim2Frame0, Kbd_Anim2Frame1

; ---- data $4D9E-$4DAF (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

Kbd_Anim2Frame0:: ; 5F:4D9E
	sprite_frame 4
	sprite_oam 0, 0, $00, OAMF_BANK1 | 7
	sprite_oam 12, 0, $00, OAMF_YFLIP | OAMF_BANK1 | 7
	sprite_oam 0, 12, $00, OAMF_XFLIP | OAMF_BANK1 | 7
	sprite_oam 12, 12, $00, OAMF_YFLIP | OAMF_XFLIP | OAMF_BANK1 | 7

; ---- data $4DAF-$4DC0 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

Kbd_Anim2Frame1:: ; 5F:4DAF
	sprite_frame 4
	sprite_oam -1, -1, $00, OAMF_BANK1 | 7
	sprite_oam 13, -1, $00, OAMF_YFLIP | OAMF_BANK1 | 7
	sprite_oam -1, 13, $00, OAMF_XFLIP | OAMF_BANK1 | 7
	sprite_oam 13, 13, $00, OAMF_YFLIP | OAMF_XFLIP | OAMF_BANK1 | 7

; ---- data $4DC0-$4DC5 (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:46 1:8

Kbd_Anim2Script:: ; 5F:4DC0
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $4DC5-$4DC7 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Kbd_Anim7Frames:: ; 5F:4DC5

	sprite_frame_table Kbd_Anim7Frame0

; ---- data $4DC7-$4DE0 (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Kbd_Anim7Frame0:: ; 5F:4DC7
	sprite_frame 6
	sprite_oam 0, 0, $01, OAMF_BANK1 | 7
	sprite_oam 0, 8, $02, OAMF_BANK1 | 7
	sprite_oam 0, 16, $03, OAMF_BANK1 | 7
	sprite_oam 0, 24, $04, OAMF_BANK1 | 7
	sprite_oam 0, 32, $05, OAMF_BANK1 | 7
	sprite_oam 0, 40, $06, OAMF_BANK1 | 7

; ---- data $4DE0-$4DE3 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Kbd_Anim7Script:: ; 5F:4DE0
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $4DE3-$4DE5 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Kbd_Anim4Frames:: ; 5F:4DE3

	sprite_frame_table Kbd_Anim4Frame0

; ---- data $4DE5-$4DFE (25 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 6 piece(s); length tiles exactly against the frame-table pointers

Kbd_Anim4Frame0:: ; 5F:4DE5
	sprite_frame 6
	sprite_oam 0, 0, $01, OAMF_BANK1 | 7
	sprite_oam 0, 8, $02, OAMF_BANK1 | 7
	sprite_oam 0, 16, $03, OAMF_BANK1 | 7
	sprite_oam 0, 24, $04, OAMF_BANK1 | 7
	sprite_oam 0, 32, $07, OAMF_BANK1 | 7
	sprite_oam 0, 40, $08, OAMF_BANK1 | 7

; ---- data $4DFE-$4E01 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Kbd_Anim4Script:: ; 5F:4DFE
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $4E01-$4E03 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Kbd_Anim5Frames:: ; 5F:4E01

	sprite_frame_table Kbd_Anim5Frame0

; ---- data $4E03-$4E20 (29 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 7 piece(s); length tiles exactly against the frame-table pointers

Kbd_Anim5Frame0:: ; 5F:4E03
	sprite_frame 7
	sprite_oam 0, 0, $01, OAMF_BANK1 | 7
	sprite_oam 0, 8, $02, OAMF_BANK1 | 7
	sprite_oam 0, 16, $03, OAMF_BANK1 | 7
	sprite_oam 0, 24, $04, OAMF_BANK1 | 7
	sprite_oam 0, 32, $09, OAMF_BANK1 | 7
	sprite_oam 0, 40, $0A, OAMF_BANK1 | 7
	sprite_oam 0, 48, $0B, OAMF_BANK1 | 7

; ---- data $4E20-$4E23 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Kbd_Anim5Script:: ; 5F:4E20
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $4E23-$4E25 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Kbd_Anim6Frames:: ; 5F:4E23

	sprite_frame_table Kbd_Anim6Frame0

; ---- data $4E25-$4E42 (29 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 7 piece(s); length tiles exactly against the frame-table pointers

Kbd_Anim6Frame0:: ; 5F:4E25
	sprite_frame 7
	sprite_oam 0, 0, $01, OAMF_BANK1 | 7
	sprite_oam 0, 8, $02, OAMF_BANK1 | 7
	sprite_oam 0, 16, $03, OAMF_BANK1 | 7
	sprite_oam 0, 24, $04, OAMF_BANK1 | 7
	sprite_oam 0, 32, $0C, OAMF_BANK1 | 7
	sprite_oam 0, 40, $0D, OAMF_BANK1 | 7
	sprite_oam 0, 48, $0E, OAMF_BANK1 | 7

; ---- data $4E42-$4E45 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Kbd_Anim6Script:: ; 5F:4E42
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $4E45-$4E47 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Kbd_Anim9Frames:: ; 5F:4E45

	sprite_frame_table Kbd_Anim9Frame0

; ---- data $4E47-$4E54 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Kbd_Anim9Frame0:: ; 5F:4E47
	sprite_frame 3
	sprite_oam 0, 0, $15, OAMF_BANK1 | 7
	sprite_oam 0, 8, $16, OAMF_BANK1 | 7
	sprite_oam 0, 16, $17, OAMF_BANK1 | 7

; ---- data $4E54-$4E57 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:8

Kbd_Anim9Script:: ; 5F:4E54
	sprite_anim 1
	sprite_anim_step 0, 8

; ---- words $4E57-$4E59 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Kbd_Anim10Frames:: ; 5F:4E57

	sprite_frame_table Kbd_Anim10Frame0

; ---- data $4E59-$4E66 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Kbd_Anim10Frame0:: ; 5F:4E59
	sprite_frame 3
	sprite_oam 0, 0, $18, OAMF_BANK1 | 7
	sprite_oam 0, 8, $19, OAMF_BANK1 | 7
	sprite_oam 0, 16, $1A, OAMF_BANK1 | 7

; ---- data $4E66-$4E69 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:8

Kbd_Anim10Script:: ; 5F:4E66
	sprite_anim 1
	sprite_anim_step 0, 8

; ---- words $4E69-$4E6B (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Kbd_Anim11Frames:: ; 5F:4E69

	sprite_frame_table Kbd_Anim11Frame0

; ---- data $4E6B-$4E78 (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Kbd_Anim11Frame0:: ; 5F:4E6B
	sprite_frame 3
	sprite_oam 0, 0, $1B, OAMF_BANK1 | 7
	sprite_oam 0, 8, $1C, OAMF_BANK1 | 7
	sprite_oam 0, 16, $1D, OAMF_BANK1 | 7

; ---- data $4E78-$4E7B (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:8

Kbd_Anim11Script:: ; 5F:4E78
	sprite_anim 1
	sprite_anim_step 0, 8

; ---- words $4E7B-$4E7D (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Kbd_Anim12Frames:: ; 5F:4E7B

	sprite_frame_table Kbd_Anim12Frame0

; ---- data $4E7D-$4E8A (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Kbd_Anim12Frame0:: ; 5F:4E7D
	sprite_frame 3
	sprite_oam 0, 0, $0F, OAMF_BANK1 | 7
	sprite_oam 0, 8, $10, OAMF_BANK1 | 7
	sprite_oam 0, 16, $11, OAMF_BANK1 | 7

; ---- data $4E8A-$4E8D (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Kbd_Anim12Script:: ; 5F:4E8A
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $4E8D-$4E8F (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Kbd_Anim13Frames:: ; 5F:4E8D

	sprite_frame_table Kbd_Anim13Frame0

; ---- data $4E8F-$4E9C (13 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 3 piece(s); length tiles exactly against the frame-table pointers

Kbd_Anim13Frame0:: ; 5F:4E8F
	sprite_frame 3
	sprite_oam 0, 0, $12, OAMF_BANK1 | 7
	sprite_oam 0, 8, $13, OAMF_BANK1 | 7
	sprite_oam 0, 16, $14, OAMF_BANK1 | 7

; ---- data $4E9C-$4E9F (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Kbd_Anim13Script:: ; 5F:4E9C
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $4E9F-$4EA1 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Kbd_Anim17Frames:: ; 5F:4E9F

	sprite_frame_table Kbd_Anim17Frame0

; ---- data $4EA1-$4EB2 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

Kbd_Anim17Frame0:: ; 5F:4EA1
	sprite_frame 4
	sprite_oam 0, 0, $29, OAMF_BANK1 | 5
	sprite_oam 0, 8, $2A, OAMF_BANK1 | 5
	sprite_oam 8, 0, $2B, OAMF_BANK1 | 5
	sprite_oam 8, 8, $2C, OAMF_BANK1 | 5

; ---- data $4EB2-$4EB5 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Kbd_Anim17Script:: ; 5F:4EB2
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- words $4EB5-$4EB7 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Kbd_Anim19Frames:: ; 5F:4EB5

	sprite_frame_table Kbd_Anim19Frame0

; ---- data $4EB7-$4EC8 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

Kbd_Anim19Frame0:: ; 5F:4EB7
	sprite_frame 4
	sprite_oam 0, 0, $1E, OAMF_BANK1 | 5
	sprite_oam 0, 8, $1F, OAMF_BANK1 | 5
	sprite_oam 8, 0, $2E, OAMF_BANK1 | 5
	sprite_oam 8, 8, $2F, OAMF_BANK1 | 5

; ---- data $4EC8-$4ECB (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Kbd_Anim19Script:: ; 5F:4EC8
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- data $4ECB-$50D3 (520 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 55:66FA: hl=$4ECB a=$5F b=13 rows c=20 cols (tiles then attrs) de=$D240

Tilemap_Kbd_T0:: ; 5F:4ECB

	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type0_panel.tilemap"
	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type0_panel.attrmap"

; ---- data $50D3-$52DB (520 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 55:6721: hl=$50D3 a=$5F b=13 rows c=20 cols (tiles then attrs) de=$D240

Tilemap_Kbd_T1:: ; 5F:50D3

	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type1_panel.tilemap"
	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type1_panel.attrmap"

; ---- data $52DB-$54E3 (520 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 55:6795: hl=$52DB a=$5F b=13 rows c=20 cols (tiles then attrs) de=$D240

Tilemap_Kbd_T4:: ; 5F:52DB

	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type4_panel.tilemap"
	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type4_panel.attrmap"

; ---- data $54E3-$56EB (520 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 55:6736: hl=$54E3 a=$5F b=13 rows c=20 cols (tiles then attrs) de=$D240 [first call site executed: 63 hits in 3 scenarios (analysis/coverage_union.tsv)]

Tilemap_Kbd_T2:: ; 5F:54E3

	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type2_panel.tilemap"
	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type2_panel.attrmap"

; ---- data $56EB-$58F3 (520 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 55:674B: hl=$56EB a=$5F b=13 rows c=20 cols (tiles then attrs) de=$D240 [first call site executed: 13 hits in 3 scenarios (analysis/coverage_union.tsv)]

Tilemap_Kbd_T3:: ; 5F:56EB

	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type3_panel.tilemap"
	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type3_panel.attrmap"

; ---- zero $58F3-$5900 (13 bytes) [PROBABLE] 13 zero bytes fill the gap after Tilemap_Kbd_T3 and before the 16-byte-aligned T5 HDMA source at $5900; padding purpose is probable, with no named direct reader found

Padding_Kbd_T3ToT5_TileAlignment:: ; 5F:58F3
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- gfx $5900-$5D00 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:67AB: hl=$5900 a=$5F c=$40 de=$8801 (dest VRAM $8800, vbank=1) [first call site executed: 110 hits in 4 scenarios (analysis/coverage_union.tsv)]

Gfx_Kbd_T5_Tiles8800Vb1:: ; 5F:5900

	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type5_vram8800_vb1_tiles.2bpp"

; ---- gfx $5D00-$6100 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:67BD: hl=$5D00 a=$5F c=$40 de=$8C01 (dest VRAM $8C00, vbank=1) [first call site executed: 110 hits in 4 scenarios (analysis/coverage_union.tsv)]

Gfx_Kbd_T5_Tiles8C00Vb1:: ; 5F:5D00

	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type5_vram8c00_vb1_tiles.2bpp"

; ---- gfx $6100-$6200 (256 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 55:67CF: hl=$6100 a=$5F c=$10 de=$9001 (dest VRAM $9000, vbank=1) [first call site executed: 110 hits in 4 scenarios (analysis/coverage_union.tsv)]

Gfx_Kbd_T5_Tiles9000Vb1:: ; 5F:6100

	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type5_vram9000_vb1_tiles.2bpp"

; ---- zero $6200-$6980 (1920 bytes) [HYPOTHESIS] padding? run of 1920 x $00 in unclassified bytes
	ds $780, $00

; ---- data $6980-$69B0 (48 bytes) [HYPOTHESIS] 48 x $06 before the tilemap+attr block at 69B0; raw candidate HL=$6998 at 68:7A34 is loaded with bank A=$71 before Tilemap_CopyRectAndAttr, so it selects 71:6998, not this bank-5F span; no bank-5F read established, purpose unknown

Data_Kbd_Byte06Run_6980:: ; 5F:6980
	db $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
	db $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
	db $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06

; ---- data $69B0-$6BB8 (520 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 55:684E: hl=$69B0 a=$5F b=13 rows c=20 cols (tiles then attrs) de=$D240 [first call site executed: 110 hits in 4 scenarios (analysis/coverage_union.tsv)]

Tilemap_Kbd_T5:: ; 5F:69B0

	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type5_panel.tilemap"
	INCBIN "gfx/keyboard/panels_bank5f/keyboard_type5_panel.attrmap"

; ---- data $6BB8-$6BD0 (24 bytes) [PROBABLE] palette-rgb555: heuristic: 12 RGB555 words as 3 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Palette_Kbd_T5_Bg1:: ; 5F:6BB8

	INCLUDE "gfx/keyboard/panels_bank5f/keyboard_type5_bg1_bg6_7_palettes.pal"
