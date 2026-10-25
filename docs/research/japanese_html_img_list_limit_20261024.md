# HTML image-list capacity boundary (2026-10-24)

## Result

The scan pass can append 256 distinct image URLs to `wHtmlImageUrlList` at
`W4:DE00`. The pointer words occupy `DE00–DFFF`. On the 256th insertion,
`Html_StringTable_Add` writes a zero word at `E000–E001` before storing the
pointer at `DFFE–DFFF`. In the Game Boy echo map, `E000–E001` aliases
`W0:C000–C001`, the first two bytes of `wShadowOAM`. The 257th distinct URL
reaches the `DE=FFFF` return from `Html_StringTable_Find` and is not appended.
This is a bounded writer with a real out-of-allocation side effect; the
previous `at most 255` comment was wrong. It is not a global claim about
arbitrary corrupted state.

## Original-ROM emulator observation

Scenario `html_img_list_257_short` ran the immutable Japanese ROM in the
project's mGBA tracer with the ordinary homepage button macro and synthetic
fake HTTP. The page contains 257 distinct ASCII `src` values and is 3,612
bytes; the response remains inside the browser's accepted resource-prefix
window. No ROM/RAM forcing or modified ROM was used.

The trace records:

* 257 entries through `Html_Tag_Img` scan-only dispatch (`74:4F09`),
  256 successful URL-copy returns (`74:5AF3`), and one saturation return at
  `74:5B4B` for the 257th distinct URL.
* At frame 5102, writes from `74:5ABA` and `74:5ABC` to `E000` and `E001`.
  These addresses alias `C000` and `C001`, outside the declared `DE00–DFFF`
  array.
* `Browser_FetchInlineImages` starts after parsing. The fake service receives
  the page plus 31 image requests (32 HTTP responses including the page).
  The next resource-chain capacity check takes the existing exit path at
  `4C:4AD6`; this bounds what this input fetched before the SRAM buffer guard.

This is an mGBA observation with a synthetic server, not console/hardware
evidence. It confirms the parser's natural browser path reaches the table
boundary and that the 257th URL is rejected. It does not establish a lasting
visual/OAM effect from zeroing the two bytes: two frames later the observed
`Sprite_ClearShadowOAM` loop at `00:0A12` clears `C000–C09F`. A transient
display effect between the out-of-array write and that clear was not captured.

## Reproduction and retained evidence

The exact fixture, macro, resolved inputs, tracer outputs and memory watch are
retained under `jp-html-img-list-limit-20261024` (review artifact). The decisive run is
`RUN257_short/`; `RUN/` is the 256-tag partial-fetch comparison and `RUN257/`
is the longer-page control that crossed the earlier resource guard. Preserve
these differing cases together; they explain why identical tag-count inputs
can have different fetch outcomes.

Identity pins:

* Original ROM: SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
* Tracer: SHA-256 `bcfc16de9e07a8acb81b52e4f843ab0cf2beba6e26a1a134e25a3e6f714dc280`.
* `libmgba.so.0.11.0`: SHA-256 `b44dfd7edb816fefa892c10dc2563d5d4bbe871d68702a8dcc3dde2532959719`.
* 3,612-byte page: SHA-256 `e0d617499a06e99d33097d5c0d9d14719974e9e9735bd007962fc21cb737bf83`.

The run command is captured in `RUN_INPUTS.json`; outputs and input hashes are
in `RESULT.json`. The run did not execute the translation, alter the original
ROM, or change graphics/assets.

## Implication for the HTML helper matrix

The 28 generic HTML/browser pointer rows are no longer one undifferentiated
unknown. Their ordinary initialized paths can be grouped by the explicit
producers in `Html_ParsePage` / `Html_ScanPage`, the bounded page-record
allocator, and the `sBrowserPageBuf` resource chain. The image URL-list rows
must additionally retain the 256/257 boundary above. Other malformed
resource chains, corrupted live HRAM, and the previously reproduced BMP
conversion failure remain separate cases; no blanket safety claim follows.

| Owners and row counts | Producer contract for the listed `BankSwitch_*` site(s) |
|---|---|
| `Html_ParseSource` (2), `Html_ParseSource_Tag_Done` (2), `Html_CountListItems_Tag_Done` (2), `Html_StoreTitle` (1), `Html_Tag_Hr` (1) — 8 | The page entry installs header `D000/W4`, text stream `D000/W5`, and source resource in `B000/S3`. The corresponding source-bank restores use `hHtml_SourceBank=3`; text destinations use `hTextX=5`; header accesses use `hHtml_PageBank=4`. Parser/tag scan stops at the zero terminator and the `D000–DFFF` text-stream boundary. This is the initialized page path, not arbitrary direct calls or corrupted pointers. |
| `Html_Layout_ClearAllFloats` (2), `Html_Layout_EndLine` (3), `Html_Layout_WrapRun` (3), `Html_Layout_CloseRunRecord` (1) — 9 | Source reads restore bank 3; text stream reads/writes select bank 5 from `hTextX`; layout-record writes select bank 4 from `hHtml_PageBank`. `Html_Layout_Init` starts records at `D020`; the finite append recurrence saturates at next `DFF0` and count 253. `wHtmlScanOnly` exits before layout reads/writes. The reproduced failed-BMP unwind remains an explicit exception for its two loader rows, already recorded in the helper matrix. |
| `Browser_FetchInlineImages` (4), `Html_NextResourceRecord` (1), `Html_Tag_Img` (3) — 8 | Page and image resource records are in `S3:B000–BFFF`; `Html_NextResourceRecord` advances by `2+length`. Scan-only URL strings are allocated in `W4:D020–DCFD`, and pointers are read from `W4:DE00`. The browser's high-byte capacity guard bounds accepted resource-prefix positions to `B000–BEFC` for this initialized path. The separate 256/257 table boundary above is confirmed and must not be described as an in-array terminator. |
| `Browser_DrawElement_Text` (2), `Browser_DrawElement_Bitmap` (1) — 3 | Visible records are read from `W4` and are created by the parser's bounded record allocator. The `+D` data-bank byte is written by the two `Html_Layout_AppendRecord` call paths: text runs use bank 5, image records use bank 3, and successful conversion rewrites the pointer/bank while keeping the record in W4. The bitmap site follows the loader's image-record selector; the reproduced zero-return failure path is the known corrupted-stack exception. |

These grouped contracts retire the 28 rows as **ordinary-path bounds**, with
the two image-loader failure rows kept split into successful conversion and
the observed corrupt unwind. They do not prove that malformed remote pages,
arbitrary direct entries, or damaged scratch state are safe. The new 257-URL
scenario is a positive counterexample to treating the normal scan path as
globally bounded by its declared 512-byte list allocation.
