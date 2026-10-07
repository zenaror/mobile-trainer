# Original browser five-frame animation

CONFIRMED original consumer73:6265-62AA selects five tile-index rectangles followed by their five BG attribute rectangles. Each frame is5 rows x7 columns (35 bytes); maps occupy447F-452E175 and attributes452E-45DD175. The32 instruction/macro starts are independently decoded from69 ROM bytes and have natural execution evidence; the paired-copy farcall at6290 has1315 hits across19 scenarios.

| Frame | Map interval | Attribute interval | Natural whole / union |
| --- | --- | --- | --- |
| 0 | 447F-44A2 | 452E-4551 | 19 / 19 |
| 1 | 44A2-44C5 | 4551-4574 | 19 / 19 |
| 2 | 44C5-44E8 | 4574-4597 | 18 / 18 |
| 3 | 44E8-450B | 4597-45BA | 18 / 18 |
| 4 | 450B-452E | 45BA-45DD | 18 / 18 |

The source pointer is447F + index35; the attribute pointer adds175, BC0507 and bank73 are explicit. Helper00:16A2 selects ROM73 and WRAM7, preserving dimensions/destination for a second copy0400 bytes higher. Copy00:0904 reads consecutive source bytes and advances destination rows by32. Staging startsD0C1 for tile indices andD4C1 for attributes, buffer rows6-10/column1. Uploader00:082C sends the576-byte map buffers to9800 or9C00 according to caller LCDC bit3, using VRAM banks0/1. These fixed rectangles fit wholly inside that window. The frame byte starts zero within the252-byte screen wipe, increments after drawing and wraps after index4; the draw counter reloads25. No arbitrary damaged-index safety is asserted.

Both175-byte semantic arrays and the complete350 bytes have18 whole/19 union natural reads. monkey_camp_allfull reads frames0/1 only; it cannot count as a whole-array observation. Data reads and instruction coverage are aggregate original scenario evidence, not an isolated transaction/video or new hardware test.

The old177-byte physical header at447F-4530 contains all175 tile-index bytes and the first2 attribute bytes. Its emitted db statements remain unchanged; the header now states the mixed format. The old alleged tile asset4530-45E0176 contains the remaining173 attributes and3 raw bytes with no natural reads. Its physical header stays PROBABLE, explicitly bounding CONFIRMED attributes173 while retaining the tail's purpose as HYPOTHESIS. No tail meaning or whole176 confidence is inferred from its zero values. Existing Data_73_4530 remains at offset2 inside the attribute family;25 attribute db rows (first5 bytes, then24 rows x7) and one raw3 row preserve all176 bytes with no new alias.

The historical176-byte .2bpp and its PNG remain unchanged. Exactly one existing asset row and PNG-rules row receive a comment prefix; original text and TSV line counts remain preserved. Unlike palette99, this row emits a tile make target. Pure extraction of mk_text proves that precisely the target-list line and PNG_SIZE rule are removed from gfx/png.mk. No frozen generator or regen runs. Active totals become947 assets /607576 ROM bytes, including405 tile sheets /346672 bytes and143 palettes /11504 bytes. Unrelated frozen bootstrap tables and statuses remain historical.

Fresh actual baseline6df4a11 follows published/fresh sprite99. Full original archive/source/assets and69 natural traces precede this scoped candidate. The24 physical headers remain22 CONFIRMED/2 PROBABLE, distinct from semantic partitions. All289 TSVs,649 active file/line records and1947 broad colon locators are reaudited; none targets this source, so25 extra source lines require zero locator updates. Existing labels and full symbols must stay exact.

KEEP: unread49E0-4DE01024 remains a PROBABLE tile heuristic without an established consumer; unread animation tail3 and7441 zero bytes at62EF-8000 have no confirmed purpose. Remaining button rectangles and optional unexecuted code are separate passes. This corrects a bounded original asset interpretation, not whole-bank semantic closure, new runtime/hardware evidence or English assets/layout.
