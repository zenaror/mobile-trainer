# Three shared graphics sources named by their readers (ROM unchanged)

| Semantic name | Demonstrated role |
| --- | --- |
| `Gfx_SharedPanels_Vram8000Vb1` | Eight keyboard/confirmation callers copy the complete 768-byte source to VRAM8000, bank1. |
| `Palette_SharedPanels_BgObj` | The exact 40-byte RGB555 block supplies BG6..7 and OBJ5..7. |
| `Gfx_CommPanel_SharedVramSource` | A shared source contributes to two overlapping uploads with different destinations. |

Eight callers read +$10, twenty-four bytes, into W7:D868 (OBJ5..7).

The nine naturally executed bank-aware consumers cover the whole40-byte block; the object table begins immediately at5F:4CF8 without overlap.

For71:4300..4500, the numeric window4200..4500 uploads to8800/VB1 at68:7468, contributing this block at8900..8B00. The symbolic +$190 window starts4490 and ends4890, uploading to9000/VB1 at68:747A. It reads $70 bytes from this block and $390 from the next4500 block. Both calls have56hits in16existing scenarios. A global name specifying one destination would misdescribe the shared block. The +$190 expression and both source divisions are preserved; this naming pass does not infer tile format from HDMA.

The old71:4300header listed one read. It now records both demonstrated requests, distinguishing the whole-block contribution in the first from the partial tail in the second. The71:4500header correctly describes one clipped request and is unchanged. This corrects reader metadata and preserves the inherited content classification.
