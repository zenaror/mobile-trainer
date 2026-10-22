# Bank 48 glyph-reader bounds at 69AB

## Result

`Data_48_69AB` remains a neutral data label. The 32 bytes at `48:69AB–69CA`
are all zero and are read by `Font_BlitGlyph8x16` for a bounded set of input
pairs under its normal bank, stack, and control-flow assumptions. The
independent review rejected splitting or renaming the range as a zero-glyph
fallback: that would turn a reader's output into an unsupported claim about
the stored object's identity or intended purpose.

The original ROM is 2 MiB with SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
The 32-byte range begins at physical offset `0x1229AB`; its SHA-256 is
`66687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f2925`.
Each 16-byte half is zero-filled (SHA-256
`374708fff7719dd5979ec875d56cd2286f6d3cf7ec317a3b25632aab28ec37bb`).

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

These are reader-selected ranges, not evidence of two originally intended
objects. The arithmetic and source selection are conditional static results;
they do not assert that every pair occurs in a real input or that the range is
an intentional fallback.

## Relation to the declared run

The selected addresses are outside the declared `Font_GlyphRun_83BF` section.
That run is exactly 80 bytes (`48:5D7B–5DCA`, end-exclusive `5DCB`), while the
reader adds `$C30` or `$C40` to its `$5D7B` base for low bytes `$82` or `$83`.
The resulting source spans are in the separate `zero_labels` section at
`48:69AB–69CA`; the linker layout pins that section at `$69AB`, and its current
32 bytes are explicit zero bytes. The function copies 16 source bytes for the
two preview destinations, so each of the two static input pairs selects one
complete 16-byte half. This confirms the reader's out-of-run source selection
for those inputs under the stated bank/stack/control-flow assumptions. It does
not establish that the bytes are a glyph, fallback, reserved object, or
intentional safety behavior, and it does not prove natural execution or
rendered output. Keep the symbol `Data_48_69AB` neutral.

The keyboard supplies actual table values `$FF82` and `$FF83`:
`data/keyboard/pages.asm` maps page 0 cells `$34` and `$31` to bytes at
`55:40AE` and `55:40A8`. `Kbd_FetchCell` (`engine/keyboard/keyboard.asm:521–558`)
stores the pair; the preview passes a high byte of `$FF` unchanged
(`keyboard.asm:2270–2320`) to the font reader. This establishes a real static
data path from keyboard table through preview to the two ranges, subject to
valid selection, stack state, bank mapping, and uninterrupted control flow. It
does not establish that the historical memory-read traces came from this
caller.

The 69 existing `traces/detail/*/dataaccess.tsv` files merge accesses by
bank/address and do not retain PC, arguments, order, or caller attribution.
The retained historical result is therefore **HYPOTHESIS** for attribution of
those individual trace reads and for any intended role such as blank glyph,
reserved area, or fallback. The current label stays neutral until that gap is
resolved. This note does not claim natural execution, rendered output, or
hardware behavior.
