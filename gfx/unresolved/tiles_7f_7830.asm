; gfx/unresolved/tiles_7f_7830.asm
; bank 7F, $7830-$7B00 (720 bytes); extent is fixed by layout.link.
; No symbolic reference or load address for $7830 was found in the reviewed source.
; The image alone does not establish its intended consumer or role.

SECTION "gfx/unresolved/tiles_7f_7830", ROMX

; 45 tiles, 2bpp. Keep the bank/address label until a consumer is demonstrated.
Tiles_7F_7830:: ; 7F:7830
	INCBIN "gfx/unresolved/tiles_7f_7830/tiles_7830.2bpp"
