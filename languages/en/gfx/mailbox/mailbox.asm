; gfx/mailbox/mailbox.asm
; bank 25, $5A10-$6F30 (5408 bytes); pinned by layout.link
; mailbox tiles, tilemaps, palettes

SECTION "gfx/mailbox/mailbox", ROMX

; ---- gfx $5A10-$5E10 (1024 bytes) [CONFIRMED] 64 tiles: executed 00:0749 HDMA load at 25:4B5C (hl=$5A10 a=$25 c=$40 de=$9301 = VRAM bank 1 $9300); loader semantic documented in boot_and_home.md

Mailbox_Tiles_5A10:: ; 25:5A10
	INCBIN "gfx/mailbox/mailbox/mailbox_tiles_5a10.2bpp"

; ---- gfx $5E10-$5F10 (256 bytes) [CONFIRMED] 16 tiles: executed 00:0749 HDMA load at 25:4B71 (hl=$5E10 a=$25 c=$10 de=$9701 = VRAM bank 1 $9700)

Mailbox_Tiles_5E10:: ; 25:5E10
	INCBIN "gfx/mailbox/mailbox/mailbox_tiles_5e10.2bpp"

; ---- gfx $5F10-$6310 (1024 bytes) [PROBABLE] 64 tiles: 00:0749 HDMA load at 25:4C04 (hl=$5F10 a=$25 c=$40 de=$9301, VRAM bank 1 $9300); the call site is static-reached code (PROBABLE), same layout as the executed 25:4B5C load; tile art coherence h=0.566 v=0.564 over 64 tiles

Mailbox_Tiles_5F10:: ; 25:5F10
	INCBIN "gfx/mailbox/mailbox/mailbox_tiles_5f10.2bpp"

; ---- gfx $6310-$6410 (256 bytes) [PROBABLE] 16 tiles: 00:0749 HDMA load at 25:4C19 (hl=$6310 a=$25 c=$10 de=$9701, VRAM bank 1 $9700); static-reached site; ends exactly where the tilemap load 25:6410 starts

Mailbox_Tiles_6310:: ; 25:6310
	INCBIN "gfx/mailbox/mailbox/mailbox_tiles_6310.2bpp"

; ---- data $6410-$66E0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 25:4BC4: hl=$6410 a=$25 b=18 rows c=20 cols (tiles then attrs) de=$D000

Mailbox_Tilemap_Normal:: ; 25:6410
	INCBIN "gfx/mailbox/mailbox/mailbox_tilemap_normal.tilemap"
	INCBIN "gfx/mailbox/mailbox/mailbox_tilemap_normal.attrmap"

; ---- data $66E0-$69B0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 25:4C6C: hl=$66E0 a=$25 b=18 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 52 hits in 3 scenarios (analysis/coverage_union.tsv)]

Mailbox_Tilemap_DeleteSelect:: ; 25:66E0
	INCBIN "gfx/mailbox/mailbox/mailbox_tilemap_delete_select.tilemap"
	INCBIN "gfx/mailbox/mailbox/mailbox_tilemap_delete_select.attrmap"

; ---- data $69B0-$69F0 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/mail/mailbox_screen.asm:23, call 25:4B33 executed 69 hits in 11 scenarios (analysis/coverage_union.tsv)); +$00 bc=$40 into wPaletteBufBg (engine/mail/mailbox_screen.asm:81, call 25:4BDB executed 52 hits in 3 scenarios (analysis/coverage_union.tsv)); +$00 bc=$40 into wPaletteBufBg (engine/mail/mailbox_screen.asm:137, call 25:4C80 executed 121 hits in 12 scenarios (analysis/coverage_union.tsv))

Mailbox_BgPalette:: ; 25:69B0
	INCLUDE "gfx/mailbox/mailbox/mailbox_bg_palette.pal"

; ---- gfx $69F0-$6CF0 (768 bytes) [CONFIRMED] 48 complete 2bpp tiles copied by static HDMA at 25:4B86 to VRAM0 $8000-$8300; the overlapping 25:4B9B transfer reloads $6A00-$6B00 at $8700-$8800; natural display is not established

Mailbox_Tiles_69F0:: ; 25:69F0
	INCBIN "gfx/mailbox/mailbox/mailbox_tiles_69f0.2bpp"

; ---- gfx $6CF0-$6EF0 (512 bytes) [CONFIRMED] 32 complete 2bpp tiles copied by static HDMA at 25:4BB0 to VRAM0 $8D00-$8F00; natural display is not established

Mailbox_Tiles_6CF0:: ; 25:6CF0
	INCBIN "gfx/mailbox/mailbox/mailbox_tiles_6cf0.2bpp"

; ---- data $6EF0-$6F30 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufObj (engine/mail/mailbox_screen.asm:29, call 25:4B47 executed 69 hits in 11 scenarios (analysis/coverage_union.tsv)); +$00 bc=$40 into wPaletteBufObj (engine/mail/mailbox_screen.asm:87, call 25:4BEF executed 52 hits in 3 scenarios (analysis/coverage_union.tsv)); +$00 bc=$40 into wPaletteBufObj (engine/mail/mailbox_screen.asm:143, call 25:4C94 executed 121 hits in 12 scenarios (analysis/coverage_union.tsv))

Mailbox_ObjPalette:: ; 25:6EF0
	INCLUDE "gfx/mailbox/mailbox/mailbox_obj_palette.pal"

; English asset bytes preserve the existing overlay; rendering and runtime remain UNVALIDATED.
