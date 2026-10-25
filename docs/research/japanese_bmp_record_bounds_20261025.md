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

For positive widths, the interval is the union of H row reads, each
row_bytes long and separated by input_stride. It is not necessarily contiguous
when row padding exists. Bmp_ConvertToTiles uses CopyBytes at 51:7251-7266 for
each row. Before that loop it stores canvas_extent as the copy/fill count and
computes the canvas stride at 51:7190-7212; the loop destination uses that
stride while the source cursor uses input_stride. Width zero is exceptional:
its computed copy count is BC=0, and CopyBytes at 00:050C copies 256 bytes for
BC=0 with B=0. The row source pointer is restored after each copy and its
computed stride is zero, so the same 256-byte source span is read repeatedly
while the mainline loop does not return.

The top-down accepted flag returns before palette reads, metadata writes and
the row loop. Bottom-up conversion reads eight palette bytes at an address
derived from the 16-bit DIB-size field, writes $FF to BMP body offsets 23..25,
and writes four conversion bytes at bitmap_base+pixel_offset-4..-1. None of
these reads or writes is compared with the nested length returned in DE.

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

## Exhaustive accepted-dimension and declared-length classes

**Correction (2026-10-25 follow-up):** recounting the parser's indexed reads
shows that the fixed header offsets are 0, 1, 10..13, 18..33, and 46..49.
The previous version of this note was one byte high in the width/field read
range and two bytes high in the final range; it overstated the parser-only
containment minimum as 52 bytes. It is
**50 bytes** (highest read offset 49). This is only a header-read threshold,
not a complete converter-read bound or a guarantee that field values pass.
The size validator accepts 145 width values (W=0..144) and 96 height values
(H=1..96), giving 13,920 accepted dimension pairs after the header predicates.

For bottom-up images, let P be the 16-bit pixel offset, R=ceil(W/8), and S be
the 16-bit value read from BMP offsets 14..15. The pixel-row span fits a
nonwrapping declared record of length L iff
P + (H-1)*align_up(R,4) + R <= L. Separately, Bmp_ConvertToTiles passes the
pointer at BMP offset 14 plus S to Bmp_ColorSum twice; each call consumes four
bytes, so the palette-read interval is [14+S,22+S). For the common S=40
header this is bytes 54..61 and needs L>=62. The parser does not bound S, so
for positive widths the complete bottom-up containment condition is
L >= max(50, 22+S, P + (H-1)*align_up(R,4) + R), with P>=4 to contain
the metadata writes, subject to the nonwrapping-file-offset model. For width
zero, each loop iteration copies 256 bytes from the same restored source
address P; keeping that per-iteration read in the record requires P+256<=L
and P>=4, but the loop does not complete.

Before those row reads, the converter also writes $FF to BMP offsets
23..25. Its four conversion metadata bytes go to P-4..P-1: P<4 places these
writes before the BMP record; P>=4 keeps them at or after the record start.
For positive widths, P plus the nonzero row span contains the upper edge of
the four-byte metadata write; P>=4 is still required for its lower edge. For
W=0, the repeated 256-byte copy condition also contains its upper edge. The
three fixed writes are inside the record whenever L>=50. No runtime check
enforces these read or write bounds.

| Computed row bytes R | Accepted W | Source stride | Span at H=1 / W0 iteration | Span at H=96 / W0 union |
|---:|:---:|---:|---:|---:|
| 0 | 0 | 0 | 256 | 256 (same span repeated; no return) |
| 1 | 1–8 | 4 | 1 | 381 |
| 2 | 9–16 | 4 | 2 | 382 |
| 3 | 17–24 | 4 | 3 | 383 |
| 4 | 25–32 | 4 | 4 | 384 |
| 5 | 33–40 | 8 | 5 | 765 |
| 6 | 41–48 | 8 | 6 | 766 |
| 7 | 49–56 | 8 | 7 | 767 |
| 8 | 57–64 | 8 | 8 | 768 |
| 9 | 65–72 | 12 | 9 | 1149 |
| 10 | 73–80 | 12 | 10 | 1150 |
| 11 | 81–88 | 12 | 11 | 1151 |
| 12 | 89–96 | 12 | 12 | 1152 |
| 13 | 97–104 | 16 | 13 | 1533 |
| 14 | 105–112 | 16 | 14 | 1534 |
| 15 | 113–120 | 16 | 15 | 1535 |
| 16 | 121–128 | 16 | 16 | 1536 |
| 17 | 129–136 | 20 | 17 | 1917 |
| 18 | 137–144 | 20 | 18 | 1918 |

The top-down flag takes a distinct early success return after header parsing;
it skips the palette reads, the $FF writes, the four conversion metadata
writes, output-canvas construction, and pixel-row loop. Its converter-side
containment requirement is therefore the corrected 50-byte fixed-header
threshold. This documents control flow only; it does not establish that an
externally supplied top-down image is naturally produced or that success
yields a usable rendered image.

Width zero has R=0 and zero input/output stride, but CopyBytes copies 256
bytes for BC=0. The row source pointer is restored after each copy, so those
bytes come from P..P+255 repeatedly; the output-row pointer cannot advance
and the mainline loop does not return. Positive widths execute the finite H
row iterations; their row span is the table above plus P. The
dimension matrix from .tmp/jp-bmp-dimension-domain-20261025/audit.py remains
valid for positive-width row arithmetic, but its zero-width zero-copy model and
previous header-bound statement are superseded by the corrected indexed-read
audit in .tmp/jp-bmp-access-interval-recheck-20261025/. Audit script SHA-256
bb84a31a54ddd03a64e3a1b4927ebd27d8510ddea92dd1890c461a4afca473b4;
RESULT.json SHA-256 c5b8f21bfeff06e0f5dc53d232a96a43b11ddafdadac927ee9a00d38263fb999;
dimension_matrix.csv SHA-256 15a02a32f236630b52ffc58080593eb80a4a29078bf8a49b3b501c68b29baf81.
That audit records corrected header reads, palette reads, writes, and
address-wrap thresholds.
Neither matrix enumerates every
field-valid byte string. The palette and pixel formulas are separate intervals
and do not assume a valid external response or model 16-bit address wrap.

### 16-bit CPU address wrap and mapped regions

The nested BMP body resides in the SRAM3 page buffer, whose full address
window is B000..BFFF. Let B be its actual body pointer. The parser adds the
16-bit pixel offset P to HL with ordinary 16-bit wrap. For the full page
address envelope, P<=4000 cannot wrap the pixel start for any B; P=4001..4FFF
wraps only for the higher body addresses; and P>=5000 wraps for every possible
B. These thresholds follow from B+P modulo 65536, not from a payload-length
check. Before wrapping, offsets P=1000, 2000, 3000 and 4000 place the pixel
start respectively in C000..CFFF, D000..DFFF, E000..EFFF and F000..FFFF for
this full-page envelope. P=5000 wraps the start into 0000..0FFF. Those windows
no longer denote SRAM3; interpretation of banked/VRAM regions depends on the
live CGB and mapper state. The palette pointer similarly uses B+14+S modulo
65536. The address calculation audit is in
.tmp/jp-bmp-access-interval-recheck-20261025/RESULT.json; it uses the entire
page as a conservative envelope, not a claim that every address is a natural
nested-record start.

## Positive-width short-payload over-read

A second synthetic response separates the zero-width loop from the payload
bound question. The fixture is a 64-byte, valid-header, 1-bpp BMP with pixel
offset 62, width 1, height 32, bottom-up orientation, and only two payload
bytes (`AA 55`). Its `image_size` field says 128, but the actual BMP and nested
HTTP response length are 64 bytes. The ordinary browser replay returned this
64-byte response with HTTP 200 and entered `Bmp_ConvertToTiles`.

For width 1, the converter copies `ceil(1/8) = 1` byte per row and advances
the source by `align_up(1, 4) = 4` bytes. Its 32 row-read addresses relative to
the BMP start are therefore `62 + 4*n`, for `n=0..31`: 62, 66, ..., 186.
Only offset 62 is within the declared file; offsets 66 through 186 are 31
reads past the 64-byte record end. This is **CONFIRMED statically** for the
accepted bottom-up header and non-wrapping address arithmetic. The trace
coverage records 32 executions each at `51:725D` (row `CopyBytes`) and
`51:729C` (row completion), and the callgraph records 32 calls from
`51:725D` to `00:050C`. The retained data-access report merges SRAM reads by
range/bank; it does not identify each of these individual pixel addresses.
Thus runtime evidence confirms the converter path and row count in the
synthetic replay, while the exact out-of-record address set comes from the
source arithmetic, not a per-bus-access trace.

This fixture establishes an accepted short-payload case in the instrumented
mGBA/fake-network setup. It does not establish that a real Mobile Adapter or
external server can deliver the same inconsistent response, nor the values
returned by physical SRAM beyond the nested record. It is evidence of a
missing record-bound check and conditional out-of-record reads, not evidence
of a security exploit or of natural external-network behavior. The receipt
and all output hashes are in
`.tmp/jp-bmp-payload-overread-20261025/RESULT.json`.

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
