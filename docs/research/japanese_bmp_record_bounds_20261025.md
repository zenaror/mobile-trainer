# Japanese inline BMP record bounds (2026-10-25)

Status: **CONFIRMED record-bound omission; zero-width bottom-up mainline loop reproduced in synthetic mGBA**.
Source revision at initial review: `4ecacbb1a949cf54f595e81903bb3f26eebdd44d`; directed trace revision:
`669ad8aa4af7e0417cec7ece33d0e812496743c4`. Protected ROM SHA-256:
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
The initial finding was source-flow only. A later directed synthetic mGBA run
is recorded below; no hardware or external network was involved.

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

The earlier static inference is now confirmed for this accepted zero-width,
bottom-up case. A temporary instrumented trace observed at `51:729C`:
`A=$D0`, `F=$C0` (zero set, carry clear), `DE=$D000`, and
`hBmpConvert_RowStride=$00`. Executing `JR NC` then sets the next PC to
`51:7251`, re-entering the row loop with `DE` unchanged. The branch was
observed 1,346 times through frame 9,599; two additional samples were timer
interrupt dispatches to `$0050`. The trace reached its 9,600-frame budget while
the converter's mainline remained in this loop. Frame advancement and the
final PC do not mean the converter returned: final `75:6149` is
`MobileSDK_StateDispatch`, reached from `75:58F2` during adapter processing.
This confirms the conditional mainline hang in the synthetic mGBA scenario,
not native-hardware behavior or general malformed-record safety.

## Distinguish the other two copies

The previously cited `CopyBytes` at `51:73A1` and `51:73AB`
(`engine/browser/inline_image_blit.asm:535,541`) are output-patch operations.
The first conditionally copies an existing output span into `wTileStage3`; the
second copies the completed stage to a caller-derived output pointer. They are
not the direct BMP row read, which is the `CopyBytes` at `51:725D`
(`engine/browser/inline_image_blit.asm:266`). `51:7251` is the preceding
`Sound_FrameService` call inside the row loop. The maintained branch checks the
high byte of the wrapped output end against `$C000`, and the staging array is
`$900` bytes while the maximum nonzero canvas extent is `$780` bytes. The
exact declared-record end is still not checked.

## Finding and boundary

**CONFIRMED:** the natural HTML image path supplies a nested response-length
record, and `Html_NextResourceRecord` computes its end. The BMP converter drops
that end pointer. It derives the pixel-row interval and four preceding
metadata-write bytes from header fields, and checks the high end against the
SRAM window at `$C000`; it never checks those accesses against the declared BMP
payload length. The record-bound omission remains confirmed. The synthetic
trace confirms that the accepted zero-width bottom-up case loops on the
mainline; it does not test native hardware or general malformed responses. The
original run receipt is
`.tmp/jp-bmp-malformed-http-20261025/RESULT.json`; it records the fixture,
resolved input, parent save/config, harness, and result hashes. The register
and branch probe receipt is `.tmp/jp-bmp-malformed-http-20261025/PROBE.json`.

**Not established:** whether an external Mobile Adapter/network response can
naturally supply a short or internally inconsistent image while still passing
the header checks; whether the SDK always enforces the declared response size;
or how the hardware behaves at an out-of-record SRAM read. The fixture is
synthetic and the emulator is mGBA, not the native Mobile Adapter. Therefore do not
call the path safe for truncated/corrupt records and do not describe the
conditional out-of-record reads as a demonstrated exploit or natural behavior.

## Reproduction points

The static claims can be rechecked directly at the listed source locations. The
relevant maintained call chain is
`Html_Tag_Img -> Html_Layout_AppendImageRecord -> Html_LoadPageImages -> Html_NextResourceRecord -> Bmp_ConvertToTiles`.
The directed run used the canonical ROM and the existing `browser_bookmarks`
saved state/config, replayed the resolved natural input prefix through the
`a.html` image request, and replaced only `/img_a.bmp` with a copy of the
existing 318-byte BMP whose width field at offsets 18-21 was set to zero. It
used the fake network in the local mGBA trace harness; this is a synthetic
server response, not hardware or public-network behavior.

```sh
timeout 20s .cache/trace/mgba_trace --rom 'Mobile Trainer (Japan).gbc' \
  --scenario browser_zero_width --outdir .tmp/jp-bmp-malformed-http-20261025/out \
  --frames 9600 --input .tmp/jp-bmp-malformed-http-20261025/browser_zero_width.txt \
  --mobile on --net fake \
  --save-in .cache/trace/state/browser_bookmarks.sav \
  --mobile-config-in .cache/trace/state/browser_bookmarks.cfg \
  --shots .tmp/jp-bmp-malformed-http-20261025/out/shots \
  --web-map '*/index.html=.cache/trace/web/index.html' \
  --web-map '*/a.html=.cache/trace/web/a.html' \
  --web-map '*/img_a.bmp=.tmp/jp-bmp-malformed-http-20261025/fixtures/img_zero_width.bmp' \
  --web-map '*.html=.cache/trace/web/page.html'
```

Observed result: exit 0; 9,600 frames; 55,479,360 instructions; final PC
`75:6149` (SDK state dispatcher; not a return from the converter);
HTTP GET `/01/CGB-B9AJ/img_a.bmp` returned 200 with 318 bytes. Coverage entered
`51:7177`, `51:7251`, and `51:729C`; `51:7251 -> 00:0392` is the
`Sound_FrameService` edge, and `51:725D -> 00:050C` is the row `CopyBytes`
edge; each had 1,347 calls from frame 9,457. A second run with `--watch FFD4 --watch FFD6 --watch
FFD7 --watch C332 --watch C333 --watch C334 --watch C33F` recorded width 0,
height `$20`, bottom-up flag 0, converted-output row stride 0, and rounded
height `$24`. The instrumented branch probe then recorded 1,346 taken branches
from `51:729C` to `51:7251` with `DE=$D000`, `F=$C0`, and stride 0; two sampled
interrupts entered `$0050` and returned to the loop. Receipt `.tmp/jp-bmp-malformed-http-20261025/PROBE.json` pins the source, instrumented binary, run logs and hashes (SHA-256 `2edc3173eb1dfb90534861cf910867afc1a5e71944f284cbe1187bba2379635e`).

At source revision `669ad8aa4af7e0417cec7ece33d0e812496743c4`, SHA-256 values
were: ROM `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`;
harness `bcfc16de9e07a8acb81b52e4f843ab0cf2beba6e26a1a134e25a3e6f714dc280`;
zero-width fixture `c4894aaf0f1807b0b672ec0d98dab26fe9be883bb76adf2417a8175937c40380`;
resolved input `f19f18a9e0811789e0ec3834d3c9f93fe194ac5da722f999f13aebcc191759b7`;
parent save `3bab29651c18b77dc0b43028f9fa6225da9c23587cb02fe855ab8966a0cd9121`;
parent adapter config `45fdd476f1adf5c1d87aedaeda675d11f610ab7d7d056231f955aff71c4769ef`.
The full output-hash inventory is retained in `.tmp/jp-bmp-malformed-http-20261025/RESULT.json`
(SHA-256 `c7fad49c5b2e323a34eca9c3d89639898273585128f34206edb4a3756f56d165`).
`git diff --check` is the applicable documentation-only validation for this note.
