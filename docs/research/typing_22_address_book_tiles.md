# Original bank22 address-book tile family

CONFIRMED from original consumer instructions, bounded to ROM22:5CD0..66D0. The four requests in the complete bank2F AbookList_SetupScreen and AbookAddr_SetupScreen routines use ROM bank22 and Gfx_StartHDMA. The source ranges, sizes and destination words are:

| Request setup / call in bank2F | ROM22 source | Bytes | Destination word | VRAM destination | Natural whole / union |
|---|---|---:|---|---|---|
| 4597 / 45A3 | 5CD0..60D0 | 1024 | 9301 | bank1:9300 | 10 / 10 |
| 45A9 / 45B5 | 60D0..61D0 | 256 | 9701 | bank1:9700 | 10 / 10 |
| 6FAB / 6FB7 | 61D0..65D0 | 1024 | 9301 | bank1:9300 | 9 / 9 |
| 6FBD / 6FC9 | 65D0..66D0 | 256 | 9701 | bank1:9700 | 9 / 9 |

All four complete requests are 18 original bytes. Gfx_StartHDMA at home0749 uses E bit0 as the VRAM-bank flag, masks the destination low byte to a 16-byte boundary and writes C-1 to rHDMA5. C=40 or10 gives 1024 or256 bytes. B=92 or97 is the LY wait limit. The request uses direct transfer with bit7 clear; the routine name alone does not imply HBlank operation. BankSwitch_H at home0622 selects ROM bank22 because H is below80. Both complete caller routines, the bank-switch helper and transfer helper were mapped from the maintained source and compared with immutable ROM, including their branches. This does not generalize safety of the LCDC-off and wait/retry paths.

The list and editor each read 1280 bytes, or80 tiles. Together their disjoint sources form a 2560-byte family of160 tiles; this is a source-family count, not160 tiles displayed simultaneously. Across69 existing natural data-access traces, the whole family has9 whole/10 union scenarios, list1280 has10/10 and editor1280 has9/9. Whole means every byte within one scenario; union means all bytes across the stated cohort. These are aggregate original traces, not isolated transfer transactions or a new runtime or hardware test.

The maintained physical split is retained. Gfx_AddrBook_TilesBank22 begins at5CD0 and holds26 bytes: one complete16-byte tile plus the first10 bytes of the next tile. Data_22_5CEA remains at5CEA inside that tile. Its2534 bytes begin with the six completing bytes, followed by158 whole tiles. This continuation begins at tile phase10 and is not an independent aligned tile sheet. Its natural coverage is9 whole/10 union; the first26 bytes have10/10. The inherited RGB555 palette heuristic for the first26 bytes conflicts with the actual tile-pattern VRAM consumer and is corrected to CONFIRMED tile-family data.

Exactly two existing data headers change in place. Raw db rows, physical boundaries, labels, line counts, banked addresses and references are preserved. Both headers remain kind data. No graphics asset is created or exported, and no catalogue, PNG rule, generated make fragment or frozen configuration changes. The pure exporter classification stays None for both fragments, so the unaligned continuation is not exported as a standalone tile sheet.

The whole bank22 inventory covers five maintained owners,18 physical data headers,79 global spellings at56 addresses,90 local labels,209 maintained references and10 active assets. The bank contains1717 maintained instruction/macro units and1773 raw instruction starts;1157 raw starts occur in the natural code cohort. Source units and raw starts are different measures. This pass does not promote other code or data based on that aggregate.

Five naturally read PROBABLE text/template blocks at43E0,4515,4C5B,4DA6 and4EE9 remain separate bounded follow-ups. The CONFIRMED maintained object-palette header at5C90 and PROBABLE catalogue/README status disagree; its own64-byte consumer and16 whole/16 union data coverage warrant a separate status-only correction. This pass leaves those statuses unchanged.

KEEP includes the unread37-byte blank-string candidate,11-byte static decimal-template candidate, five literal-zero bytes at510B,6448 literal-zero bytes at66D0 and unresolved or unexecuted paths. No unused-code or padding purpose follows from the absence of natural reads. The ordered original queue continues through the remaining bounded bank22 passes and then25 and26. Whole-bank semantic completion is not asserted.
