# Three shared graphics sources named by their readers (ROM unchanged)

> Status: **reference (current)**. Follow-up to the neutral instruction census, independently reviewed before application.

| Original alias | Semantic name | Demonstrated role |
|---|---|---|
| `Data_5F_49D0` | `Gfx_SharedPanels_Vram8000Vb1` | Eight keyboard/confirmation callers copy the complete 768-byte source to VRAM8000, bank1. |
| `Palette_5F_4CD0` | `Palette_SharedPanels_BgObj` | The exact 40-byte RGB555 block supplies BG6..7 and OBJ5..7. |
| `Data_71_4300` | `Gfx_CommPanel_SharedVramSource` | A shared source contributes to two overlapping uploads with different destinations. |

All three names are CONFIRMED for these source/load roles. All 36 instruction operands and eighteen consumer farcalls match the immutable ROM, including complete register vectors and selected-bank consumers. All consumers have existing natural coverage. Names do not claim a new content class, one visual screen, final displayed pixels, PPU behavior or hardware validation. Old aliases, binary paths and section boundaries remain intact.

The eight first-block readers use source5F:49D0..4CD0, C=$30 sixteen-byte blocks, DE=$8001, yielding VRAM8000/VB1. The name describes every reader across the keyboard and confirmation setup paths, rather than attributing a shared block to one screen.

The palette comprises twenty original RGB555 words, privately reconstructed from the RGB source with every bit15 clear. The keyboard reads +0, sixteen bytes, into W7:D830 (BG6..7). Eight callers read +$10, twenty-four bytes, into W7:D868 (OBJ5..7). The nine naturally executed bank-aware consumers cover the whole40-byte block; the object table begins immediately at5F:4CF8 without overlap. The header and asset status are explicitly changed from PROBABLE to CONFIRMED using these exact layout and natural-reader proofs. No neighbouring sprite-table or padding confidence is promoted. The historical mapper had guessed a palette ending at $4D1C, overlapping the object table beginning at $4CF8; the exact 40-byte proof fixes the end at $4CF8 and preserves that correction rather than treating the old boundary as valid.

For71:4300..4500, the numeric window4200..4500 uploads to8800/VB1 at68:7468, contributing this block at8900..8B00. The symbolic +$190 window starts4490 and ends4890, uploading to9000/VB1 at68:747A. It reads $70 bytes from this block and $390 from the next4500 block. Both calls have56hits in16existing scenarios. A global name specifying one destination would misdescribe the shared block. The +$190 expression and both source divisions are preserved; this naming pass does not infer tile format from HDMA.

Active metadata changes are21label cells (18preview operands and3asset labels), one palette-confidence cell and three worklist rows. No active source-line locator refers to either definition file after an insertion, and no manual context is invalidated: ramop9 remains156already/0skipped, ramop10 remains300/0. Historical naming records are left as snapshots.

The same strict instruction census falls from45names/136operands to **42names/100operands**:32groups pending, nine explicit keeps and one partly named mixed-consumer group. The separate structured-data macro is outside this count. No new natural scenario, replay, emulator capture, PPU or hardware test was run, and no ROM byte or asset payload changes.

The old71:4300header listed one read. It now records both demonstrated requests, distinguishing the whole-block contribution in the first from the partial tail in the second. The71:4500header correctly describes one clipped request and is unchanged. This corrects reader metadata and preserves the inherited content classification.
