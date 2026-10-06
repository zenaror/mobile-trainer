; gfx/mailbox/mailbox.asm
; bank 25, $5A10-$6F30 (5408 bytes); pinned by layout.link
; mailbox tiles, tilemaps, palettes

SECTION "gfx/mailbox/mailbox", ROMX

; ---- gfx $5A10-$5E10 (1024 bytes) [CONFIRMED] 64 tiles: executed 00:0749 HDMA load at 25:4B5C (hl=$5A10 a=$25 c=$40 de=$9301 = VRAM bank 1 $9300); loader semantic documented in boot_and_home.md

Mailbox_Tiles_5A10:: ; 25:5A10
Tiles_25_5A10::
	INCBIN "gfx/mailbox/mailbox/mailbox_tiles_5a10.2bpp"

; ---- gfx $5E10-$5F10 (256 bytes) [CONFIRMED] 16 tiles: executed 00:0749 HDMA load at 25:4B71 (hl=$5E10 a=$25 c=$10 de=$9701 = VRAM bank 1 $9700)

Mailbox_Tiles_5E10:: ; 25:5E10
Tiles_25_5E10::
	INCBIN "gfx/mailbox/mailbox/mailbox_tiles_5e10.2bpp"

; ---- gfx $5F10-$6310 (1024 bytes) [PROBABLE] 64 tiles: 00:0749 HDMA load at 25:4C04 (hl=$5F10 a=$25 c=$40 de=$9301, VRAM bank 1 $9300); the call site is static-reached code (PROBABLE), same layout as the executed 25:4B5C load; tile art coherence h=0.566 v=0.564 over 64 tiles

Mailbox_Tiles_5F10:: ; 25:5F10
Tiles_25_5F10::
	INCBIN "gfx/mailbox/mailbox/mailbox_tiles_5f10.2bpp"

; ---- gfx $6310-$6410 (256 bytes) [PROBABLE] 16 tiles: 00:0749 HDMA load at 25:4C19 (hl=$6310 a=$25 c=$10 de=$9701, VRAM bank 1 $9700); static-reached site; ends exactly where the tilemap load 25:6410 starts

Mailbox_Tiles_6310:: ; 25:6310
Tiles_25_6310::
	INCBIN "gfx/mailbox/mailbox/mailbox_tiles_6310.2bpp"

; ---- data $6410-$66E0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 25:4BC4: hl=$6410 a=$25 b=18 rows c=20 cols (tiles then attrs) de=$D000

Mailbox_Tilemap_Normal:: ; 25:6410
Data_25_6410::
	INCBIN "gfx/mailbox/mailbox/mailbox_tilemap_normal.tilemap"
	INCBIN "gfx/mailbox/mailbox/mailbox_tilemap_normal.attrmap"

; ---- data $66E0-$69B0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 25:4C6C: hl=$66E0 a=$25 b=18 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 52 hits in 3 scenarios (analysis/coverage_union.tsv)]

Mailbox_Tilemap_DeleteSelect:: ; 25:66E0
Data_25_66E0::
	INCBIN "gfx/mailbox/mailbox/mailbox_tilemap_delete_select.tilemap"
	INCBIN "gfx/mailbox/mailbox/mailbox_tilemap_delete_select.attrmap"

; ---- data $69B0-$69F0 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/mail/mailbox_screen.asm:23, call 25:4B33 executed 69 hits in 11 scenarios (analysis/coverage_union.tsv)); +$00 bc=$40 into wPaletteBufBg (engine/mail/mailbox_screen.asm:81, call 25:4BDB executed 52 hits in 3 scenarios (analysis/coverage_union.tsv)); +$00 bc=$40 into wPaletteBufBg (engine/mail/mailbox_screen.asm:137, call 25:4C80 executed 121 hits in 12 scenarios (analysis/coverage_union.tsv))

Mailbox_BgPalette:: ; 25:69B0
Data_25_69B0::
	INCLUDE "gfx/mailbox/mailbox/mailbox_bg_palette.pal"

; ---- data $69F0-$6AC8 (216 bytes) [PROBABLE] palette-rgb555: heuristic: 116 RGB555 words as 29 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance) [the rest of the block; a palette array that the code reads was cut out of it; the label and the asset of what is left say tiles]

Mailbox_Tiles_69F0:: ; 25:69F0
	; kind (tiles) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/mailbox/mailbox/mailbox_tiles_69f0.2bpp"
	db $3F, $00, $3F, $1E, $BF, $12, $FF, $12

; ---- data $6AC8-$6BD1 (265 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 69B0-7730 by higher-priority evidence]

Data_25_6AC8:: ; 25:6AC8
	db $FF, $42, $FD, $46, $FA, $8C, $DC, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $3F, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FF, $FF, $FF, $80, $FF, $BF
	db $E7, $BE, $E7, $BF, $FF, $BE, $FF, $BF, $00, $00, $FE, $FE, $FE, $02, $FE, $FA
	db $FE, $1A, $FE, $FA, $FE, $1A, $FE, $FA, $C0, $BF, $FF, $BF, $FF, $80, $FF, $FF
	db $00, $00, $00, $00, $00, $00, $00, $00, $07, $07, $FF, $FC, $FE, $81, $FE, $BD
	db $FE, $9D, $FE, $AD, $FE, $B1, $FE, $B5, $FF, $FF, $FF, $01, $03, $FD, $FB, $FD
	db $FB, $05, $FB, $FD, $FB, $05, $FB, $FD, $FE, $AD, $FE, $9D, $FE, $81, $FF, $FC
	db $07, $07, $00, $00, $00, $00, $00, $00, $FB, $05, $FB, $FD, $03, $FD, $FF, $01
	db $FF, $FF, $00, $00, $00, $00, $00, $00, $7E, $00, $7E, $3C, $FF, $08, $FE, $7F
	db $FF, $08, $77, $18, $6B, $31, $73, $00, $00, $00, $00, $00, $FF, $00, $FF, $F5
	db $FF, $45, $FF, $40, $FF, $F7, $FF, $00, $00, $00, $1E, $00, $3F, $0C, $7F, $12
	db $7F, $21, $73, $00, $01, $00, $00, $00, $70, $00, $71, $20, $7F, $20, $F7, $3A
	db $FF, $2A, $FF, $AA, $F5, $2E, $7E, $00, $F8, $00, $FC, $A8, $FC, $A8, $FC, $80
	db $DC, $88, $FC, $88, $F8, $74, $F8, $00, $77, $00, $7F, $22, $7F, $2F, $7F, $22
	db $77, $22, $7F, $22, $7D, $26, $7E, $00, $00

; ---- gfx $6BD1-$6E71 (672 bytes) [PROBABLE] tiles-2bpp: heuristic: 35 coherent tiles (hsim2=0.623 vsim2=0.562, 3 blank) parity 1

Data_25_6BD1:: ; 25:6BD1
	INCBIN "gfx/mailbox/mailbox/tiles_6bd1.2bpp"
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Mailbox_Tiles_6CF0:: ; 25:6CF0
	INCBIN "gfx/mailbox/mailbox/mailbox_tiles_6cf0.2bpp"
	db $00

; ---- data $6E71-$6EF0 (127 bytes) [CONFIRMED] palette-rgb555: heuristic: 63 RGB555 words as 63 words (the rest of a heuristic block; the palette array(s) that the code reads were cut out of it)

Data_25_6E71:: ; 25:6E71
	db $00, $38, $7D, $6C, $6D, $38, $7D, $6C, $6D, $6C, $6D, $38, $7D, $00, $00, $00
	db $00, $38, $7D, $6C, $6D, $6C, $6D, $3C, $7D, $0C, $8D, $38, $BD, $00, $00, $03
	db $01, $FF, $03, $FF, $FF, $FF, $FF, $00, $00, $FF, $FF, $FF, $00, $00, $00, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $00, $FF

; ---- data $6EF0-$6F30 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufObj (engine/mail/mailbox_screen.asm:29, call 25:4B47 executed 69 hits in 11 scenarios (analysis/coverage_union.tsv)); +$00 bc=$40 into wPaletteBufObj (engine/mail/mailbox_screen.asm:87, call 25:4BEF executed 52 hits in 3 scenarios (analysis/coverage_union.tsv)); +$00 bc=$40 into wPaletteBufObj (engine/mail/mailbox_screen.asm:143, call 25:4C94 executed 121 hits in 12 scenarios (analysis/coverage_union.tsv))

Mailbox_ObjPalette:: ; 25:6EF0
	INCLUDE "gfx/mailbox/mailbox/mailbox_obj_palette.pal"
