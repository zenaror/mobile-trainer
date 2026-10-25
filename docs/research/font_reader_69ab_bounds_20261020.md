# Bank 48 glyph-reader bounds at 69AB

## Result

At the original checkpoint, `Data_48_69AB` remained a neutral data label. The
32 bytes at `48:69AB–69CA` are all zero and are read by `Font_BlitGlyph8x16` for a bounded set of input
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
rendered output. The original audit therefore kept the symbol `Data_48_69AB`
neutral.

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
reserved area, or fallback. The current label names only the statically
demonstrated out-of-run reader source; object identity and intent remain
unknown. This note does not claim natural execution, rendered output, or
hardware behavior.

## Structural-name correction (2026-10-22)

An independent review expanded the private snapshot to include the exact
80-byte `INCBIN`, its source declaration, `layout.link`, the keyboard table,
preview/reader code, and the Japanese ROM. The `INCBIN` bytes at
`48:[5D7B,5DCB)` match the ROM. The ordinary keyboard entries `$FF82` and
`$FF83` pass through the preview to the font reader; the reader compares the
low byte against the first real table key `$83BF` and computes offsets `$C30`
and `$C40`. It reads exactly 16 bytes at `48:[69AB,69BB)` and 16 bytes at
`48:[69BB,69CB)`, outside the declared run. `layout.link` pins the 32 explicit
zero bytes at `48:[69AB,69CB)`; they also match the original ROM.

The source label is now `FontReader_OutOfRunSource_48_69AB`. This is a
structural description of the demonstrated reader relationship and declared
section boundary, not a claim that the original software intended a glyph,
fallback, reserved object, or safety behavior. The boundary is the current
reconstruction's declared `INCBIN` extent; it does not prove an original
object boundary. Natural execution, trace attribution, and rendered output
remain unproved. The rename changes no bytes or section placement.

## Direct read-PC witness (2026-10-23)

A later GDB hardware-watchpoint capture directly attributed one read in the
previously aggregated `48:69AB` range. In the ordinary-input `kbd_abook`
scenario (18,216 frames; no forced call), the watchpoint first observed
initialization of the tracer's `romRead[0x48]` bitmap, then watched the byte
for physical bank offset `0x29AB` (CPU address `0x69AB`). The trace emitted:

```text
ROM_READ bank=48 offset=29ab frame=4416 ins_pc=47d6 ins_bank=48 value=00
```

The tracer records `insPc` and `insBank` before each SM83 instruction; its
`hookLoad8` sets the watched read-bitmap byte only after the underlying ROM
read returns. The captured PC is therefore the instruction responsible for
this read: `48:47D6`, `ld a,[bc]`, in `Font_BlitGlyph8x16`. This confirms one
specific event corresponding to the earlier aggregate range, rather than
attributing every row in every historical trace. The source byte at
`48:69AB` is `$00` in the immutable ROM.

An expanded watchpoint run also captured `BC=69AB` at the read and the
tracer's shadow-stack return `PC=6C5C`, `SP=CFC9`. In the original ROM, the
callsite immediately before that return is `55:6C59`; its six bytes are
`CD D1 06 48 47 48`, i.e. `call 00:06D1` with inline target `48:4748`.
`55:6C59` is the `farcall Font_BlitGlyph8x16` in `Kbd_DrawGlyphPreview`.
Together, the runtime return-stack entry, current callee PC, and original
callsite bytes confirm the caller chain for this exact event:
`Kbd_DrawGlyphPreview` → `Font_BlitGlyph8x16` → read at `48:69AB`.

The run does not capture the font-code argument as passed to the reader or the
full ordered stream. It does not establish why the zero bytes are present,
their object identity or intent, rendered appearance, global reachability, or
hardware behavior. This is synthetic mGBA evidence using an ordinary input
fixture, not hardware evidence.

Reproduction artifacts and hashes are indexed by
`RESULT.json` (review artifact) (SHA-256
`6a14f72e2ac869ba0fe804b76544e3d16a095d7196cb4882fdd04a89c8abb3f5`). The
PC-only capture is retained there. The expanded stack/callsite evidence is in
`RESULT-caller.json` (review artifact) (SHA-256
`31c4ee024897b7cbc0ff4e27a77f01a2710880b96d0b46d1fd3c51f52234fe0d`); it
also pins the original ROM, fixture, tracer binary/source, loaded libmgba,
GDB command/log, callgraph and scenario outputs.
