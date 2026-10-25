# Japanese inline BMP record bounds (2026-10-25)

Status: **CONFIRMED static contract; malformed-record safety remains unproven**.
Source revision: `4ecacbb1a949cf54f595e81903bb3f26eebdd44d`. Protected ROM SHA-256:
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
This is a source-flow review only; no ROM, assembly, build, emulator or hardware
execution was involved.

## Record and caller flow

`Html_Layout_AppendImageRecord` (`engine/html/layout.asm:91-112`) stores the
`hHtml_ImageData` pointer and image bank in the type-4 layout record. The image
pointer is the nested HTTP response record's 16-bit length field:

1. `Html_Tag_Img` scans the outer SRAM3 resource records. On a matching name it
   saves the cursor immediately after the name NUL (`engine/html/tags.asm:1640-1668`).
2. `Browser_FetchInlineImages` writes the fetched URL at that cursor, advances
   `wBrowserRxPtr` to the URL's terminating NUL, and passes that address and
   remaining SRAM3 capacity to `Http_StartGet` (`engine/browser/inline_images.asm:89-103,126-143`).
3. The maintained SDK HTTP receive path writes a 16-bit response length at the
   supplied base, with response bytes following it; see
   `docs/research/japanese_mobile_sdk_output_destinations_20261024.md`.
4. During image loading, `Html_LoadPageImages` loads the saved pointer and calls
   `Html_NextResourceRecord` (`engine/html/layout.asm:258-266`). That helper reads
   the nested length, returns `HL = record_start + 2` (the BMP start), and
   `DE = record_start + 2 + declared_length` (the declared end).
5. `Bmp_ConvertToTiles` receives both values. At entry it saves `HL` to scratch,
   validates it, then `pop de` restores the original `HL` into `DE`
   (`engine/browser/inline_image_blit.asm:128-139`). The caller's declared end
   pointer is discarded. No later comparison checks the converter's read end
   against that record end.

Thus a size exists and is used to locate the record end, but the bound does not
reach the bitmap conversion logic. This is more precise than saying the source
does not carry a record length at all.

## Converter source interval

For the bottom-up path, `Bmp_ParseHeader` loads the 16-bit pixel-offset field
and `Bmp_Validate` returns `HL = bitmap_base + pixel_offset`. The converter
decrements that pointer four times, writes four conversion-metadata bytes at
`bitmap_base + pixel_offset - 4 .. -1` (raster size low/high, row stride,
12-pixel-aligned height), then restores the pointer to the pixel offset before
the row loop. The size validator permits width `W=0..144` and height
`H=1..96`; the parser requires the upper width/height bytes to match its
accepted forms. The reader and output canvas use different row strides. Define:

```text
row_bytes = ceil(W / 8) = (W + 7) >> 3
input_stride = align_up(row_bytes, 4)
canvas_width = align_up(W, 12)
canvas_height = align_up(H, 12)
canvas_stride = align_up(ceil(canvas_width / 8), 4)
source_start = bitmap_base + pixel_offset
source_read_end_exclusive = source_start + (H - 1) * input_stride + row_bytes
canvas_extent = canvas_stride * canvas_height
```

The interval is the union of `H` row reads, each `row_bytes` long and separated
by `input_stride`. It is not necessarily contiguous when row padding exists.
`Bmp_ConvertToTiles` uses `CopyBytes` at `51:7251-7266` for each row. Before
that loop it stores `canvas_extent` as the copy/fill count and computes the
canvas stride at `51:7190-7212`; the loop destination uses that stride while
the source cursor uses `input_stride`. The top-down accepted flag takes an
early success return before metadata writes and the row loop. The parser does
not require `pixel_offset >= 4`, and no code compares the source reads or the
four metadata writes with the nested length returned in `DE`.

At the validator's maximum width and height, `row_bytes=18`,
`input_stride=20`, `canvas_stride=20`, `canvas_height=96`, and the final source
byte is at relative offset `pixel_offset+1917` (exclusive end
`pixel_offset+1918`), assuming nonwrapping address arithmetic and the selected
bottom-up path. The canvas extent is 1920 bytes. Before the row loop, the code
checks whether the 16-bit result of `bitmap_base + pixel_offset + canvas_extent`
has a high byte below `$C0`; there is no carry check. For ordinary nonwrapping
page-buffer addresses, this keeps the computed raster below the SRAM-window
boundary, but it is not a payload-length check. The metadata writes also lack
a lower-bound check for `pixel_offset >= 4`.

The accepted zero-width case has a separate exact consequence. It produces
`row_bytes=input_stride=canvas_stride=canvas_extent=0`. `FillBytes` and
`CopyBytes` interpret a zero count with `B=0` as 256 bytes, but the bottom-up
row loop's destination remains at `$D000` because its stride is zero; the
`D >= $D000` loop condition therefore never exits. The early top-down return
does not enter that loop. This is **CONFIRMED static conditional behavior** of
a header accepted by `Bmp_CheckSize`; it is not evidence that a server supplies
such an image or that the UI reaches it in a real session.

## Distinguish the other two copies

The previously cited `CopyBytes` at `51:73A1` and `51:73AB`
(`engine/browser/inline_image_blit.asm:535,541`) are output-patch operations.
The first conditionally copies an existing output span into `wTileStage3`; the
second copies the completed stage to a caller-derived output pointer. They are
not the direct BMP row read, which is the `CopyBytes` at `51:7251`
(`engine/browser/inline_image_blit.asm:266`). The maintained branch checks the
high byte of the wrapped output end against `$C000`, and the staging array is
`$900` bytes while the maximum nonzero canvas extent is `$780` bytes. The
exact declared-record end is still not checked.

## Finding and boundary

**CONFIRMED:** the natural HTML image path supplies a nested response-length
record, and `Html_NextResourceRecord` computes its end. The BMP converter drops
that end pointer. It derives the pixel-row interval and four preceding
metadata-write bytes from header fields, and checks the high end against the
SRAM window at `$C000`; it never checks those accesses against the declared BMP
payload length. The static contract is now resolved: callers rely on a valid,
sufficiently long BMP record with at least four bytes preceding pixel data;
zero-width bottom-up records hang in the converter if they pass validation.

**Not established:** whether an external Mobile Adapter/network response can
naturally supply a short or internally inconsistent image while still passing
the header checks; whether the SDK always enforces the declared response size;
or how the hardware behaves at an out-of-record SRAM read. No malformed-network
fixture or native hardware trace was available in this pass. Therefore do not
call the path safe for truncated/corrupt records and do not describe the
conditional out-of-record reads as a demonstrated exploit or natural behavior.

## Reproduction points

The claims above can be rechecked directly at the listed source locations. The
relevant maintained call chain is
`Html_Tag_Img -> Html_Layout_AppendImageRecord -> Html_LoadPageImages -> Html_NextResourceRecord -> Bmp_ConvertToTiles`.
No generated scan artifact is required. `git diff --check` is the applicable
documentation-only validation for this note.
