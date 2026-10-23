; gfx/mail/address_obj_hdma_bytes_copy_bank7f.asm
; bank 7F, $7830-$7B00 (720 bytes); pinned by layout.link
; exact byte copy of the MailAddr OBJ HDMA sequence; use of this copy is unknown

SECTION "gfx/mail/address_obj_hdma_bytes_copy_bank7f", ROMX

Gfx_MailAddr_ObjHDMABytesCopy_7F_7830:: ; 7F:7830
	; [CONFIRMED] exact 720-byte match for the concatenated MailAddr OBJ HDMA source at 2D:7880-$7B50.
	; This confirms byte identity only, not copy direction or a loader/consumer for the 7F copy.
	INCBIN "gfx/mail/address_obj_hdma_bytes_copy_bank7f/mail_addr_obj_hdma_bytes_copy_7f_7830.2bpp"
