# Bank 7F tiles are an exact MailAddr OBJ HDMA byte copy (2026-10-23)

## Conclusion

The 720 bytes at physical `7F:7830–7B00` are exactly equal to the
concatenation of the MailAddr OBJ HDMA source sequence at `2D:7880–7B50`.
This is **CONFIRMED byte identity**. It does not establish which copy came
first, whether the 7F span was generated from the 2D source, or whether
`7F:7830` is ever loaded or displayed. The maintained Japanese source has no
symbolic load for the 7F copy, and the reviewed natural trace data has no read
inside its physical interval; these are bounded negative searches, not a proof
of universal non-use.

The current owner is `gfx/mail/address_obj_hdma_bytes_copy_bank7f.asm`, with
label `Gfx_MailAddr_ObjHDMABytesCopy_7F_7830`. The name describes an exact
byte duplicate without asserting its provenance direction or consumer.

## Reproducible byte evidence

Target ROM: `Mobile Trainer (Japan).gbc`, 2,097,152 bytes, SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
Physical offset is `bank * 0x4000 + address - 0x4000`.

| Range | Bytes | SHA-256 |
|---|---:|---|
| `7F:7830–7B00` (offset `0x1FF830`) | 720 | `3c54d00cdd422fa54238b4a50bbb7020b0c88efe39e92fdd111b75d6db336758` |
| `2D:7880–7940` | 192 | `ad8ce16bd36df3841f6f9e7a3d184d3ca0dc0e9740e80d91204609a3fed3b700` |
| `2D:7940–7B50` | 528 | `c938b9927040205d4877aace6460753083534d28b0394e85a4a85d37c1f92744` |
| concatenated `2D:7880–7B50` | 720 | `3c54d00cdd422fa54238b4a50bbb7020b0c88efe39e92fdd111b75d6db336758` |

The full-byte comparison returned true with zero differing offsets. Existing
`.2bpp` binaries at all three locations match their respective original-ROM
spans. An independent read-only reviewer reproduced the identity and accepted
the byte-copy name with the usage limitation above.

## Transfer boundary at 2D:7880

`MailAddr_SetupScreen` in `engine/mail/address_editor.asm` loads `HL=7880`,
`A=BANK(Gfx_MailAddr_ObjTiles)` (`2D`), and `C=2D`. The generic upload helper
uses 16-byte blocks, so this call transfers `0x2D * 16 = 720` bytes from
`2D:7880` to VRAM bank 0 at `$8000`. The first 192 bytes end at `2D:7940`;
the next 528 are `Gfx_MailAddr_ObjHDMALoadTail` and end at `2D:7B50`. Thus
the existing source label's CONFIRMED status and the exact transfer extent
are supported; only 240 bytes of the tail are correlated with initialized
frames in the audited call chain.

## Validation and limits

The Japanese build remains byte-identical to the protected ROM. The path/name
change keeps all payload bytes unchanged; source, catalog, PNG-rule and layout
references are reconciled. Static transfer setup is not evidence that every
byte is displayed, and the absence of a reviewed reader is not a universal
proof of unused data. English and ZIP-derived overlays were not consulted.
