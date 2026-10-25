# Bank 7F tiles are an exact MailAddr OBJ HDMA byte copy

## Conclusion

It does not establish which copy came first, whether the 7F span was generated from the 2D source, or whether `7F:7830` is ever loaded or displayed.

The current owner is `gfx/mail/address_obj_hdma_bytes_copy_bank7f.asm`, with
label `Gfx_MailAddr_ObjHDMABytesCopy_7F_7830`. The name describes an exact
byte duplicate without asserting its provenance direction or consumer.

## Transfer boundary at 2D:7880

`MailAddr_SetupScreen` in `engine/mail/address_editor.asm` loads `HL=7880`,
`A=BANK(Gfx_MailAddr_ObjTiles)` (`2D`), and `C=2D`. The generic upload helper
uses 16-byte blocks, so this call transfers `0x2D * 16 = 720` bytes from
`2D:7880` to VRAM bank 0 at `$8000`. The first 192 bytes end at `2D:7940`;
the next 528 are `Gfx_MailAddr_ObjHDMALoadTail` and end at `2D:7B50`. Thus
the existing source label's CONFIRMED status and the exact transfer extent
are supported; only 240 bytes of the tail are correlated with initialized
frames in the audited call chain.

The Japanese build remains byte-identical to the protected ROM. The path/name
change keeps all payload bytes unchanged; source, catalog, PNG-rule and layout
references are reconciled. Static transfer setup is not evidence that every
byte is displayed, and the absence of a reviewed reader is not a universal
proof of unused data. English and ZIP-derived overlays were not consulted.
