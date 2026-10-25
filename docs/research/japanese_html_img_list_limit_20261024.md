# HTML image-list capacity boundary

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

It does not establish a lasting visual/OAM effect from zeroing the two bytes: two frames later the observed `Sprite_ClearShadowOAM` loop at `00:0A12` clears `C000–C09F`.

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
