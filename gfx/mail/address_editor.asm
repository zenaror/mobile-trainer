; gfx/mail/address_editor.asm
; bank 2D, $7120-$7E60 (3392 bytes); pinned by layout.link
; address editor tiles, tilemap, palette

SECTION "gfx/mail/address_editor", ROMX

; ---- data $7120-$7940 (2080 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); kind tiles from the label name [clipped from 7120-7E50 by higher-priority evidence]

Gfx_MailAddr_Tiles:: ; 2D:7120

	; kind (tiles) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/mail/address_editor/mail_addr_tiles.2bpp"

Gfx_MailAddr_Tiles9700Vb1:: ; 2D:7520
	; kind (tiles) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/mail/address_editor/mail_addr_tiles_9700_vb1.2bpp"

Gfx_MailAddr_Tiles8800Vb0:: ; 2D:75D0
	; kind (tiles) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/mail/address_editor/mail_addr_tiles_8800_vb0.2bpp"

Gfx_MailAddr_ObjTiles:: ; 2D:7880
	; kind (tiles) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/mail/address_editor/mail_addr_obj_tiles.2bpp"

; ---- gfx $7940-$7B50 (528 bytes) [CONFIRMED] tail of MailAddr's OBJ-tile HDMA load from $7880 to VRAM bank 0 $80C0-$82CF; static setup associates 240 bytes with initialized frames, while 288 bytes are transfer-only in this call chain

Gfx_MailAddr_ObjHDMALoadTail:: ; 2D:7940
	INCBIN "gfx/mail/address_editor/mail_addr_obj_hdma_load_tail.2bpp"

; ---- data $7B50-$7E20 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2D:6916: hl=$7B50 a=$2D b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_MailAddr:: ; 2D:7B50

	INCBIN "gfx/mail/address_editor/mail_addr.tilemap"
	INCBIN "gfx/mail/address_editor/mail_addr.attrmap"

; ---- data $7E20-$7E60 (64 bytes) [PROBABLE] palette-rgb555: heuristic: 32 RGB555 words as 8 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Palette_MailAddr_Bg:: ; 2D:7E20

	INCLUDE "gfx/mail/address_editor/mail_addr_bg.pal"
