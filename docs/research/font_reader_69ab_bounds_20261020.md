# Bank 48 glyph-reader bounds at 69AB

## Result

The 32 bytes at `48:69AB–69CA` are all zero and are read by `Font_BlitGlyph8x16` for a bounded set of input pairs under its normal bank, stack, and control-flow assumptions.

## Static reader and real table values

`Font_BlitGlyph8x16` (`48:4748`, source
`engine/text/font_8x16.asm:53–99`) scans the 27-entry descending
`Font_GlyphRunTable` and computes a 16-byte source offset from the low byte of
the requested pair. For each low byte `$82` and `$83`, 124 high-byte values
(`$84..$FF`) select one of the two halves:

| Pair family | Selected physical range | Offset calculation |
|---|---|---|
| `$84 82` through `$FF 82` | `48:69AB–69BA` | `$5D7B + $C3 * 16 = $69AB` |
| `$84 83` through `$FF 83` | `48:69BB–69CA` | `$5D7B + $C4 * 16 = $69BB` |

## Relation to the declared run

The keyboard supplies actual table values `$FF82` and `$FF83`: `data/keyboard/pages.asm` maps page 0 cells `$34` and `$31` to bytes at `55:40AE` and `55:40A8`.

`Kbd_FetchCell` (`engine/keyboard/keyboard.asm:521–558`) stores the pair; the preview passes a high byte of `$FF` unchanged (`keyboard.asm:2270–2320`) to the font reader.

The ordinary keyboard entries `$FF82` and `$FF83` pass through the preview to the font reader; the reader compares the low byte against the first real table key `$83BF` and computes offsets `$C30` and `$C40`.

## Direct read-PC witness

A later GDB hardware-watchpoint capture directly attributed one read in the previously aggregated `48:69AB` range.

The source byte at `48:69AB` is `$00` in the immutable ROM.

In the original ROM, the callsite immediately before that return is `55:6C59`; its six bytes are `CD D1 06 48 47 48`, i.e.

Together, the runtime return-stack entry, current callee PC, and original callsite bytes confirm the caller chain for this exact event: `Kbd_DrawGlyphPreview` → `Font_BlitGlyph8x16` → read at `48:69AB`.
