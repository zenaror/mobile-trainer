# ROMX mapper writes and the following instruction fetch

| Physical source | Instruction bytes | Next fetch | Interpretation |
| --- | --- | --- | --- |
| 68:424E | EA 00 21 | 4251 | A ROM-bank change can replace the lexical Bank68 RET. |
| 29:510F | EA 00 20 | 5112 | A ROM-bank change can replace the lexical XOR A and remaining sequence. |
| 29:5113 | EA 00 30 | 5116 | A high-bank change can replace the lexical RET; reaching this store itself is conditional. |

## Observed RAM execution producers

| Starts | Producer and admissible code shape |
| --- | --- |
| FF80,FF82,FF84,FF86,FF87,FF89 | `OAMDMA_CopyToHram` copies exactly10 bytes from00:05AC. Six instructions implement DMA/wait/RET; no indirect target. |
| FFA8,FFAA,FFAD | `Bank_InitState` emits `LD A,imm; LD HL,imm16; JP imm16`; `home/farcall.asm` patches operand fields. Target provenance belongs to the inline/stack/register gateway contracts already under review, not to a new unknown RAM function. |
| CBF1 | Initial JP03BA, ticker JP16D4, or non-CGB JP4D1F; ticker also restores saved bytes. The non-CGB producer remains in Bank6B's fade/halt loop, with its local RETI at6B:4D1F. That proven entry now has the explicit label `NonCgb_VBlankHandler` and its installing bytes use LOW/HIGH of that label. |
| CBF4 | Initial/disabled RETI; named installers select ROM0 16C4 (ticker),16DC (connection dialog),0E93 (scroll split); restore paths copy the saved vector. |
| CBF7,CBFA | `Int_InstallRamVectors` emits JP01ED and JP01B7. |
| C133 | Ticker saves the three VBlank vector bytes here, then its ROM0 handler chains through this copy. The copied target inherits the saved-vector state. |

### All 18 named grid callsites

| Source site | Producer domain | Maximum destination byte |
| --- | --- | --- |
| `engine/comm/connect_dialog_screen.asm:123` | immutable direct ROM string | $D5BF |
| `engine/comm/connect_dialog_screen.asm:273` | immutable direct ROM string | $D37F |
| `engine/comm/connect_dialog_screen.asm:408` | immutable direct ROM string | $D37F |
| `engine/comm/connect_dialog_screen.asm:506` | immutable direct ROM string | $D5EF |
| `engine/comm/connect_dialog_screen.asm:637` | immutable direct ROM string | $D5CF |
| `engine/comm/connect_dialog_screen.asm:740` | immutable direct ROM string | $D5CF |
| `engine/comm/connect_dialog_screen.asm:830` | immutable direct ROM string | $D37F |
| `engine/comm/connect_dialog_screen.asm:1459` | bounded inspected dynamic producer | $D0FF |
| `engine/debug/debug_flags.asm:510` | immutable direct ROM string | $DBFF |
| `engine/debug/debug_flags.asm:535` | immutable direct ROM string | $D10F |
| `engine/debug/debug_flags.asm:596` | initialized debug index0 only | $D1EF |
| `engine/debug/debug_flags.asm:757` | bounded inspected dynamic producer | $D1CF |
| `engine/debug/debug_flags.asm:867` | bounded inspected dynamic producer | $D1FF |
| `engine/debug/debug_flags.asm:931` | bounded inspected dynamic producer | $D1CF |
| `engine/debug/error_screen_test.asm:275` | immutable direct ROM string | $D5DF |
| `engine/debug/error_screen_test.asm:445` | bounded inspected dynamic producer | $D17F |
| `engine/debug/sound_test.asm:312` | immutable direct ROM string | $D5DF |
| `engine/debug/sound_test.asm:449` | bounded inspected dynamic producer | $D15F |

## Header and record consumers: ten more region contracts

Five record accesses are AppendRecord, PlaceLine, BeginLineAndPlaceFloats, GetLimitsAtY, and the record-reference update loop inside Bmp_ConvertToTiles.

Bitmap data-pointer validity is a separate question; the helper inside Bmp_ConvertToTiles at this matrix row accesses the layout-record list, not the bitmap payload.

The header/count/list roles already documented in the HRAM aliases were reused, rather than rediscovered as unknown state.

Two Html_LoadPageImages helper rows deliberately remain open. Its kind4 path
pushes the record+0B pointer in addition to the loop's saved count and record.
A successful conversion pops that extra pointer before patching the record.
A zero return from Bmp_ConvertToTiles jumps directly to the common .l53D1 pops,
so the extra word is not removed first. With balanced converter/farcall returns,
the common pops consume record+0B as HL and record as BC; then HL+=10hex and BC--.
For example, saved count1 and recordD020 give next HL=D03B, BC=D01F and one extra
saved word1 on the stack. This immediately violates the normal record-walk
invariant. It is not valid to infer a bounded walk for that branch merely from
the original record count.

The current TSV therefore has **28** generic HTML/browser pointer rows, grouped into ordinary initialized producer domains in [`japanese_html_img_list_limit_20261024.md`](japanese_html_img_list_limit_20261024.md).

A conventional uncompressed1bpp BMP, width144,height1,pixel offset62, is82bytes
including its20-byte source row. It passes the inspected validator fields and
size limits. Conversion rounds the height to12 and allocates20*12=240pixel bytes.
At BMP baseBEFE, the capacity comparison computes BEFE+62+240=C02C and rejects,
although the original82-byte image ends atBF50 and fits the HTTP capacity0100
at its BEFC length prefix. Exhaustive dimension arithmetic finds608positive
width/height pairs in the accepted144x96 domain with this same fit/reject
relationship at that resource position; only144x1 was run.

The common image-loop continuation74:53D1 then executed765times.

## Postprocess length before walking page resources

The missing two bytes are produced by `Charset_Iso2022JpToSjis_Finish` on the
page conversion path. The page reply handler calls `Browser_WrapImageInHtml`
first, then `Charset_ConvertPage`, then `Html_ScanPage` and
`Browser_FetchInlineImages`. For the ISO-2022-JP subpath, conversion starts at
page+2, reserves output at+2, emits the converted payload, writes two zero bytes,
computes length from output-start through those terminators, and stores that
length in the page's first two bytes. Thus HTTPbody3824 becomes resource/page
length3826 when the converter preserves all body bytes. The observed postprocessed
prefix3826 is consistent with this source contract. This is a postprocessor result,
not a raw HTTP length; alternate Charset_DetectEncoding paths need their own
length delta. The exact input/output fields are visible at7E:7D19,7D66 and7E:7E4C.

## Confirmed natural BMP conversion-failure consequence

The static stack case at Html_LoadPageImages is now confirmed in an ordinary browser-driven mGBA run using the original ROM and synthetic fake HTTP.

The zero return at51:73CE is followed by the common loader continuation at74:53D1, exactly as the source predicts.

Consequently the two Html_LoadPageImages sites in the helper matrix must not retain a blanket valid-record traversal contract.
