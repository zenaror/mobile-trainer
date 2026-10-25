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
threshold. The parser takes hBmp_Height from body byte 22, and sets this flag
when bytes 23, 24, and 25 are all $FF; the size check then requires the low
byte at 22 to be 1..96. If interpreted as a conventional signed 32-bit BMP
height, this accepts values -255..-160 rather than the usual -1..-96 range.
This is the ROM's predicate, not a claim that it implements standard BMP
height semantics.

On this branch, HL remains bitmap_base+P-4 when Bmp_ConvertToTiles returns A=1.
Html_LoadPageImages treats that as success and stores the returned pointer and
SRAM bank 3 in the image layout record. Since conversion metadata was skipped,
the four bytes at P-4..P-1 remain whatever the input supplied. For the synthetic
P=62 fixture below, that pointer is body+58, inside the second palette entry.

An initial synthetic mGBA/fake-network probe delivered a 64-byte response
with the top-down predicate, then reported no draw instructions through 20,000
frames. That probe replayed only the `browser_bookmarks` menu path; it did not
navigate through the `a.html` image and scroll its viewport into the image.
Its missing draw coverage was a scenario-coverage limitation, not evidence that
the accepted record could never reach a renderer. Preserve that bounded result
and its receipt at `.tmp/jp-bmp-topdown-20261025/`.

### Top-down conversion can reach the image renderer with crafted metadata

A follow-up replay used the `browser_pages` interaction sequence from the
existing `browser_bookmarks` save/config. The test page's `<img src="img_a.bmp">`
was unchanged; only that HTTP response was replaced by a synthetic 362-byte
BMP-like fixture: width 64, accepted raw height `20 FF FF FF`, pixel offset
`P=74`, 288 pixel bytes, and four deliberately constructed bytes at `P-4..P-1`
(`20 01 08 24`). These bytes encode the canvas metadata shape that the renderer
reads: the row stride at `P-2` is 8, and pixel rows start at `P`. This is a
conditional consumer contract established by source and tested fixture, not a
claim that a natural server supplies those bytes.

The fake server returned this fixture as HTTP 200 at frame 9345. The first
`Bmp_ConvertToTiles` entry and success return were at frame 9462. Row-copy code
for a later bottom-up image was not reached until frame 13710, after the
`img_a.bmp` path had already rendered. The browser bitmap dispatcher and
`Image_BlitToTileCanvas` first ran at frame 11065; each has four starts in the
scenario. The screenshot at frame 12102 shows the image area after drawing.
Thus a top-down record whose pre-pixel bytes satisfy the renderer's expected
metadata can pass through the maintained HTML image route and be blitted in the
instrumented emulator. The former no-render probe is superseded only as an
answer to whether *this directed page path* reaches the renderer.

Still **unproven**: whether any natural Mobile Trainer server/resource supplies
a top-down BMP with compatible pre-pixel bytes; whether an ordinary top-down
BMP renders correctly; and physical adapter/hardware behavior. Reproduction
inputs, hashes, coverage and screenshot are retained in
`.tmp/jp-bmp-topdown-render-20261025/`; audit script SHA-256
`8563b5a437e5db4a416ceb84e44b592e865cbbcf08996070c0cd978f40dee017`,
`RESULT_RENDER.json` SHA-256
`4ed9f6810854951c43259fef46aba78f91f7b5fab8bcef605b59a5f683c7d43e`.

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

### Public archive availability check (2026-10-25)

Queried the Internet Archive Wayback CDX for the exact homepage URL
`http://gameboy.datacenter.ne.jp/01/CGB-B9AJ/index.html`; it returned HTTP 200
with an empty capture list (`[]`). The Wayback availability API returned HTTP
200 with an empty `archived_snapshots` object for the same URL. A broader
prefix request for the game's path timed out, so it provides no result about
other pages or images. The request URLs, response bodies/statuses and hashes
are retained in `.tmp/jp-natural-bmp-archive-check-20261025/RESULT.json`
(SHA-256 `36be07dce2a9b36fc0c6f82cff3b8ebefc4949f64268944ee53dbe9337657cf1`).

The Common Crawl index was also queried for six historical collection prefixes
and the exact homepage URL in two collections. The six prefix requests returned
HTTP 502/504 and both exact-URL requests returned HTTP 504, so those requests
yielded no archive records. Gateway failures are not evidence that Common Crawl
lacks captures. The responses are retained in
`.tmp/jp-commoncrawl-original-home-archive-check-20261025/RESULT.json`
(SHA-256 `07eb61de5fd0896fcd3d849784d7d3a88259c076dad50d806a1299ccb11fc468`)
and `EXACT_QUERIES.json` (SHA-256
`abcc72d6aa7f83ec62e230ea6f5e17eee570b951552bdc54f87ae33333a9bf4e`).

This is a current query of one public archive, not proof that no copy survives
elsewhere or that the historical service never returned image resources. A
published reverse-engineering account likewise reports that the exact former
homepage content is no longer available and describes the old URL as long
dead ([Edge of Emulation, “Mobile Adapter GB – Part 1”](https://shonumi.github.io/articles/art14.html)).
Consequently, a naturally served top-down BMP and its pre-pixel renderer
metadata remain unverified; the synthetic rendering result above is still the
only positive trace for that conditional path.

### Retained local BMP corpus

A bounded inventory of `.tmp/jp-bmp-*`, `traces/web/`, and
`.cache/trace/web/` found 45 BMP files representing 25 unique byte hashes:
five experimental fixtures, 20 project-generated fake-server fixtures, and
the 20 cached byte-identical copies. Provenance for the generated set is
explicit in `tools/trace/make_fixtures.py` (SHA-256
`b9645a2eced71530270685c6633489704c036f4b9258d04c2f9f93ce76e8f543`); it
generates bottom-up BMPs. Of the two synthetic BMPs that satisfy the ROM's
top-down header predicate, only `img_topdown_canvas.bmp` has the deliberately
constructed `P-4..P-1 = 20 01 08 24` renderer metadata and a positive rendered
trace. No file in this inventory has verified historical-server provenance.
The complete per-file paths, sizes, header fields, metadata bytes, and hashes
are in `.tmp/jp-bmp-natural-source-census-20261025/RESULT.json` (SHA-256
`218c94b71e3b01ee927bed57ae482c63197e1e52d40c5f745a16b442c779b5b7`).
This closes only the local corpus inventory; it cannot rule out historical
resources outside the checkout or other retained archives.

### Bottom-up converter `CopyBytes` intervals

A separate stack/register derivation closes the arithmetic at the two
bottom-up converter sinks (`engine/browser/inline_image_blit.asm:535` and
`:541`, ROM addresses `51:7383` and `51:73A5`). This does not prove that
natural records satisfy the bounds.

Let `P` be the BMP base, `O=word[P+0x0A]` the pixel offset,
`r=4*ceil(ceil(W/8)/4)` the original row stride,
`T=P+O+r*H` the end of the original bottom-up pixel rows,
`W'=12*ceil(W/12)`, `H'=12*ceil(H/12)`,
`t=4*ceil(ceil(W'/8)/4)`, and `N=t*H'` the converted raster size.
The scanner retains an aggregate `M`; all pointer arithmetic is 16-bit
modular unless a no-wrap condition is stated. For `W=1..144` and
`H=1..96`, `N` is `0x30..0x780`. Width zero passes the validator but its
zero-stride row loop does not normally reach these sinks.

| Sink | Read interval | Write interval | Exact caveat |
|---|---|---|---|
| First copy, source line 535 | `[T,T+K)` | `[0xD000+N,0xD000+N+K)` | `K=(M-N) mod 65536`; call is skipped only for `K=0`. Only if `M>=N` without wrap is `K=M-N` and the staging destination ends at `0xD000+M`. |
| Second copy, source line 541 | `[0xD000,0xD000+C(M))` | `[P+O,P+O+C(M))` | `C(M)=M` when `M!=0`; `C(0)=256` because `CopyBytes` treats `BC=0` as a 256-byte page when `B=0`. |
| Five following stores, lines 543–551 | — | `[P+O+C(M),P+O+C(M)+5)` | Writes five zero bytes without a separate capacity check. |

The initial capacity branch checks only the high byte of modular
`P+O+N` against `$C0`; it does not verify carry, the nested resource length,
the old length field, or space for the final five bytes. Scanner iterations
advance the aggregate by `u+5+Lnext` modulo 65536, where `u` is the URL length
before its NUL. URL termination, the next record's declared length and
monotonicity/no-wrap are not established by this scanner. Thus `M<=0xFFF`
alone does not bound the first copy: if `M<N`, `K` can become very large; if
`M=0`, the second copy transfers 256 bytes. Under the additional assumptions
`W>0`, `M>=N`, `M<=0xFFF` and no wrap, the first destination ends no later than
`0xDFFF`; it may still exceed the declared `0x900`-byte `wTileStage3` symbol.

The converter changes the previous length word from `Lold=word[P-2]` to
`Lnew=(O+N+2) mod 65536`, then propagates
`delta=(Lnew-Lold) mod 65536` through matching layout pointers. The byte
displacement of the moved suffix is `N-r*H`. To make those agree without
wrap, the input record must satisfy `Lold=O+r*H+2` (or an equivalent invariant
of its format). Neither `Bmp_ConvertToTiles` nor `Html_NextResourceRecord`
checks that relation. The exact stack landmarks, intervals, source hashes,
and unresolved producer conditions are retained in
`.tmp/jp-bmp-copybytes-stack-audit-20261025/RESULT.json` (SHA-256
`351ba34f82fc35d58c3bc0ea8d0d2814aaac5641a1e50dd325bbbc31f152725b`).
Classification: **CONFIRMED** for the instruction-level transforms and
modular interval formulas; **OPEN** for unconditional physical bounds and
natural-record invariants.

## Scanner aggregate invariant under a valid resource chain

The scanner's retained count is narrower than an arbitrary modular `M`.
After the row loop, it restores `BC=N`, copies that to `DE`, and begins the
following-record scan (`51:395-411`). The URL loop only increments `BC`; each
subsequent resource step adds five bytes and its 16-bit body length. It never
subtracts. `DE` is refreshed from `BC` only after the high-byte and projected
SRAM3-address checks at `51:402-410`. If a later step stops before that refresh,
the previous `DE` value is retained. Therefore, **conditional on a contained,
well-formed record chain and no 16-bit wrap**, the count passed to the two
`CopyBytes` calls satisfies `N <= M <= $0FFF`; the first copy cannot underflow
and its destination ends at `$D000+M <= $DFFF`. This is a source-derived
invariant under those preconditions, not proof that every server response meets
them. The maximum can exceed the declared `$0900`-byte `wTileStage3` symbol.

The scanner's accepted `DE` values also pass the projected end check based on
`F+9 = P+O+5`, which leaves the five final zero stores inside SRAM3. One exit
does not refresh `DE`: if the initial `M=N` scan stops before the first accepted
refresh, only the earlier `P+O+N < $C000` check applies; it does not reserve
five bytes. The exact final-store bound therefore remains open for that edge.
The scanner begins at `Q=T+2`; that is the next resource boundary only if
`Lold=O+r*H+2`. Until that record-length relation and the natural chain's
termination/containment are demonstrated, the conditional invariant cannot be
promoted to the actual historical inline-image route. Receipt
`.tmp/jp-bmp-scanner-aggregate-20261025/RESULT.json` (SHA-256
`6250e15714e6803f797bc6a74123a0a33f4d5119ffa687790985a07393af8d32`).
Classification: **CONFIRMED** for the accumulator and retained-register
algebra; **OPEN** for the natural-chain preconditions and first-iteration
five-store edge.

## HTML layout-record allocation bound (2026-10-25)

The parser clears the 4 KiB page store in WRAM bank 4 at `$D000`, reserves
`$00-$1F` for the header, and starts the layout-record list at `$D020`
(`engine/html/parser.asm:184-210`, `engine/html/layout.asm:297-324`). Each
record occupies 16 bytes. `Html_Layout_AppendRecord` advances the next pointer
by `$10`; if its high byte becomes `$E0`, it rolls that pointer back by `$10`
and still writes the record at the old address, but skips incrementing the
16-bit record count (`engine/html/layout.asm:569-650`).

Consequently, the counted list cannot exceed 253 records (`$FD0 / $10`):
record starts `$D020` through `$DFE0` are the counted range. The next attempted
append starts at `$DFF0`, computes `$E000`, rolls back to `$DFF0`, writes the
16-byte record through `$DFFF`, and leaves the count at 253. Further overflow
appends overwrite that same uncounted final slot. Walkers use the count, so
they do not include the overflow slot. This establishes a static storage bound
for the maintained layout allocator and its count-based walkers, including
the Bank 51 loop that searches the layout list (`engine/browser/inline_image_blit.asm:433-481`).

This does not settle the scanner's five trailing SRAM writes. The HTML page
allocator is in WRAM bank 4; BMP bodies are in SRAM bank 3. The two bounds are
independent. The first scanner exit can retain initial `M=N` after checking
only `P+O+N < $C000`, whereas the five writes require five bytes beginning at
the destination pointer to stay within the SRAM window. The existing source
does not establish that stronger condition for every natural response. Nor
does the layout count establish the still-missing body-length equation
`Lold=O+r*H+2`. No ROM source or runtime evidence was changed or added for
this conclusion; it is a static derivation from the maintained source at the
revision recorded in the receipt/handoff. Classification: **CONFIRMED** for
the allocator/count bound; **OPEN** for actual natural BMP chain/body bounds.

## HTTP body length and physical receive ceiling (2026-10-25)

The maintained inline-image route makes the resource length field precise.
`Browser_FetchInlineImages` passes `wBrowserRxPtr` (the cursor immediately
after the URL NUL, at the next record's 16-bit length word) as `DE` and passes
`BC = $BFFC - DE` to `Http_StartGet`. `MobileAPI_HttpGet` retains that base and
capacity. `MobileSDK_HttpPrepareRequestPackets` sets the HTTP result pointer to
the supplied base, starts body copies at base+2, and reserves those two bytes
by reducing the remaining capacity by two. `MobileSDK_HttpBodyStart` counts
copied response-body bytes after the HTTP headers; on completion the SDK writes
the accumulated `wMobileSDK_ReceivedLength` at the result pointer. Therefore
the nested record stores the body byte count, **excluding** the two-byte record
prefix. `Html_NextResourceRecord` returns body start at record+2 and end at
record+2+that count.

For this maintained inline-image caller, the SDK's capacity checks keep the
body interval within `[DE+2, $BFFC)`: the maximum body count is
`$BFFC-DE-2`. This is a confirmed receive-buffer ceiling, not a converter
payload validation. `Bmp_ConvertToTiles` still discards the `DE` end returned by
`Html_NextResourceRecord`, and does not compare palette, row, metadata, or copy
intervals against the recorded body length. Its `$C0` high-byte test on
`P+O+N` also has no carry check. Thus this pass closes the HTTP record-count
and ordinary receive-capacity questions, but not the natural BMP-length
relation, modular-wrap cases, scanner aggregate, or the five trailing stores.

In particular, the earlier conditional invariant
`Lold = O + r*H + 2` is not explained by the record prefix: `Lold` is the body
byte count. The source parser ignores the BMP file-size field, so the Japanese
ROM contains no enforced relation between HTTP body length and the BMP fields
used by the converter. A natural response with two trailing bytes could meet
the equation; the source alone does not show that the actual historical image
responses had them. See receipt `.tmp/jp-bmp-http-body-length-20261025/RESULT.json`
(SHA-256 `d7c405c9918ff22b46199f6c81e5574bca4524933e079dafef3a7035ea4670a9`).
Classification: **CONFIRMED** for record/body-count and receive-ceiling
semantics; **OPEN** for actual natural response lengths and converter bounds.

## Synthetic boundary witness for the five-byte tail (2026-10-25)

A second directed fake-HTTP run now reaches the converter's tail stores at the
top of SRAM3. The page route was entered through the original ROM; the local
adapter log records HTTP 200 for `/01/CGB-B9AJ/index.html` (30 bytes) and
`/01/CGB-B9AJ/x.bmp` (4,048 bytes). The synthetic bottom-up BMP has `W=144`,
`H=1`, pixel offset `$0EE0`, source stride 20, and converted extent 240. With
the fixture's postprocessed page length of 32, the observed BMP base is
`$B02C`; the converted pixel end is therefore `$B02C+$0EE0+240 = $BFFC`.

The instrumented CPU write trace records five zero stores from the converter:

| Store | Address | PC |
|---|---:|---:|
| 1 | `$BFFC` | `51:73B7` |
| 2 | `$BFFD` | `51:73B9` |
| 3 | `$BFFE` | `51:73BB` |
| 4 | `$BFFF` | `51:73BD` |
| 5 | `$C000` | `51:73BF` |

`$C000` is `wShadowOAM[0]` in `ram/wram.asm`. Thus the five-byte tail can
cross from the upper edge of the SRAM window into WRAM in this accepted,
synthetically constructed response. This is **CONFIRMED for the exact
synthetic mGBA scenario** and establishes that the converter has no effective
five-byte reservation at this boundary. It does not establish that a
historical Japanese page served such a BMP, that ordinary public responses can
reach these exact fields, or that the write causes a visible/gameplay effect.
The trace then records `00:0A12` writing zero to `$C000` in the same frame.
`home/sprites.asm:129-145` identifies that PC as the loop in
`Sprite_ClearShadowOAM`, which clears all 160 shadow-OAM bytes. In this run the
normal clear therefore rewrites the same byte to the same value; no persistent
change to `wShadowOAM[0]` is shown. The aggregated DMA log confirms regular
`$C0` OAM DMA, but does not establish exact same-frame DMA ordering.

The run receipt is
`.tmp/jp-bmp-tail-overflow-20261025/run2/RESULT.json` (SHA-256
`b38130f65b76b44a8a0464e36a398d53cc3732dce048a9d680dd870619e37222`). It pins
the ROM and harness, fixture inputs, adapter log, coverage and write-trace
hashes. The earlier failed fixture remains preserved separately; its
nonzero auxiliary BMP header fields were rejected before conversion.

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

The earlier `.tmp/jp-bmp-malformed-http-20261025/RESULT.json` (SHA-256
`c7fad49c5b2e323a34eca9c3d89639898273585128f34206edb4a3756f56d165`)
labels the scenario as a contradiction because the process exited at its frame
budget with `final_pc=0x1805`. That label is not supported by the same run's coverage:
it records 1,347 executions each at `51:7251` and `51:725D`, 1,346 at
`51:729C`, and 76,300 at `75:6149`. The frame-budget exit and asynchronous
dispatcher PC do not establish that the converter returned. Preserve the old
JSON as the historical receipt, but use its raw counts together with
`PROBE.json` and the `probe2` coverage/stats (coverage SHA-256
`7f07d78257dfd8a461af563bd86b02b181a55ce7b6f5702052bb712e26a74247`; stats
SHA-256 `fbf2d8b1802336bd1ef7f71551d7693120bcaf4b68390a4d3a45158ac2163827`)
for interpretation. This resolves the recorded trace conflict without
changing or deleting either artifact.

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


### Community archive BMP payloads (2026-10-25)

A commit-pinned public repository, [REONTeam/pages](https://github.com/REONTeam/pages), describes itself as an archive of pages from `gameboy.datacenter.ne.jp`. Its commit [`baeec2f1e4348c36384297810ba18a1c0d172236`](https://github.com/REONTeam/pages/commit/baeec2f1e4348c36384297810ba18a1c0d172236) is dated 2026-09-24 and says files were added based on “Echelon's latest dump”; it does not provide a direct server-capture manifest or identify capture dates for the image bytes. We therefore treat it as a reproducible community archive with dump lineage, not a primary packet capture.

The archived `Original Sitemap/01/CGB-B9AJ/index.html` (SHA-256 `7c987e8e61cf1f84188d8d8116a7f32f1f7f73af26f133dc55898afb41269934`) references `images/cl_02.bmp` and `images/hometitle_04.bmp`. The audit pinned all eight `.bmp` Git blob IDs and SHA-256 values in `.tmp/jp-archived-pages-bmp-20261025/RESULT.json`; every downloaded byte stream reproduces its commit's Git blob ID. Static reproduction of the maintained `Bmp_ParseHeader` / `Bmp_CheckSize` predicates found that only `other3.bmp`, `other4.bmp`, and `other5.bmp` pass the header and dimension checks. The two files referenced by the archived homepage are 144 pixels wide and encode standard top-down height `-48`; the ROM reads the height low byte as 208 and rejects it at the `<97` check. This is a concrete mismatch between standard BMP semantics and the ROM's byte-level predicate, not proof that the archived page files were never served.

Passing the parser and dimension predicates does not establish that the other three files render correctly: the top-down converter consumes pre-pixel bytes as renderer metadata. A directed mGBA follow-up served the exact archived homepage and both linked BMPs through the fake network for 53,180 frames. The ROM fetched the homepage (1,818 bytes) at frame 6,855, `hometitle_04.bmp` (1,026 bytes) at frame 6,987, and `cl_02.bmp` (1,022 bytes) at frame 7,061. Coverage records 34 entries each at `51:70E0` (`Bmp_Validate`), `51:70F4` (`Bmp_ParseHeader`), and `51:7161` (`Bmp_CheckSize`), first at frame 7,206; `51:7175–7176` is the size-rejection path. `Bmp_ConvertToTiles` at `51:7177` and the bitmap renderer/blitter were not executed. The run used the protected Japanese ROM, the saved browser state, mGBA and a fake network; it is not a live server, hardware, or general reachability proof. Thus the community archive yields exact dump-derived candidates and a positive real-ROM parser rejection route, but does not establish an original server response or close the natural BMP/render path. Reproduction script and full receipt: `.tmp/jp-archived-pages-bmp-20261025/audit.py` (SHA-256 `900ae3021b8f7cca55410b378e5810020f93a63f133bd093c23cd54b77064f26`), `.tmp/jp-archived-pages-bmp-20261025/audit_dynamic.py` (SHA-256 `6f82451ec25f784aa19a9abf48ed011e54387bc4f61d1c8e7da1c9171465054c`), and `RESULT.json` (SHA-256 `ad7bf32138bb860f3e2da2847e1a6ed3d8e80bf3af45a962194eab6f728328df`).

**Follow-up: accepted archived BMPs reach the bitmap blitter (2026-10-25).** A 160-file HTML/TXT census of the same pinned archive found a second BMP-referencing document, `Original Sitemap/01/CGB-B9AJ/today_mobile/today_mobile3 (v2).html` (2,802 bytes; SHA-256 `e2d0ccee4a49cc4513bd48e6364604e43fa672d36efc58c2a61d2cb80ff14800`; Git blob `863de0c9d36f2c263826fab92de21f522c669c23`). It references `other3.bmp`, `other4.bmp` and `other5.bmp`. The converter-layout audit finds the four bytes immediately before each pixel offset encode the expected raster-byte count, padded row width in bits and ROM row count: `other3` = `0x0180/64/48`; `other4` and `other5` = `0x0030/32/12`.

A directed 14,000-frame mGBA/fake-network replay served the exact archived page body **at the homepage URL by explicit web-map override** and then served the three exact archive BMP byte streams. This was not natural navigation to the archived `today_mobile3 (v2).html` URL. A separate commit-pinned graph census fetched all 19 HTML pages in this CGB-B9AJ archive subtree (zero fetch errors), resolved their relative `href`/`src` links, and found no inbound link to the v2 page; it is not reachable from the archived `index.html` by those links (10 HTML pages are reachable from that root). This closes the archive's relative-HTML-link route only; scripts, server redirects, external bookmarks, omitted pages, and historical navigation are outside the graph. Receipt `.tmp/jp-archived-pages-bmp-20261025/LINK_GRAPH.json` (SHA-256 `9826b8519403bf3ca7dc821b5def0a906ca9a5e0aed105a465e95f99b071faf9`), script `audit_v2_links.py`. HTTP responses were observed at frames 6,855, 7,042, 7,086 and 7,111. All three images reached `Bmp_ConvertToTiles` success (`51:7177`, six hits; top-down success `51:73CB`, six hits); the browser bitmap route reached `4E:5A6D`/`4E:5B59` and `Image_BlitToTileCanvas` at `51:740D` (four hits each, first frame 11,548). The size-rejection branch `51:7175–7176` did not execute in this run. A screenshot at frame 12,102 is retained. This confirms that these exact dump-derived bytes can pass the maintained converter and reach its bitmap blitter in this forced-page mGBA route. It does not confirm correct visible pixels, a natural URL/navigation path, original server delivery, source capture provenance, or hardware behavior.

The earlier homepage trace remains valid for its distinct two linked files, which are rejected by the ROM height predicate; the accepted route does not supersede that result. Reference census and converter metadata: `.tmp/jp-archived-pages-bmp-20261025/REFS.json` (SHA-256 `5bc978fb7b9caedf7e9f40afd038f5afd37a696868c026c9305905bee78a05e6`) and `METADATA.json` (SHA-256 `b9fb582e784a1649428c2e4c9f66d134abbc1993a1d979d34b265e771e549f7f`). Dynamic audit: `audit_dynamic_accepted.py` (SHA-256 `0d078a4b3ef3684a28f237c61ce1bfb4b0d92c9274db6a4b267ebebd22f98ae9`) and `ACCEPTED_RUN.json` (SHA-256 `4bf24684909ebc6904a95fba7eff97b15f62225e49cc8b6187b1e79d2da79753`).
