# Original bank22 address-book tile family

CONFIRMED from original consumer instructions, bounded to ROM22:5CD0..66D0. The four requests in the complete bank2F AbookList_SetupScreen and AbookAddr_SetupScreen routines use ROM bank22 and Gfx_StartHDMA. The source ranges, sizes and destination words are:

| Request setup / call in bank2F | ROM22 source | Bytes | Destination word | VRAM destination | Natural whole / union |
|---|---|---:|---|---|---|
| 4597 / 45A3 | 5CD0..60D0 | 1024 | 9301 | bank1:9300 | 10 / 10 |
| 45A9 / 45B5 | 60D0..61D0 | 256 | 9701 | bank1:9700 | 10 / 10 |
| 6FAB / 6FB7 | 61D0..65D0 | 1024 | 9301 | bank1:9300 | 9 / 9 |
| 6FBD / 6FC9 | 65D0..66D0 | 256 | 9701 | bank1:9700 | 9 / 9 |

All four complete requests are 18 original bytes. Gfx_StartHDMA at home0749 uses E bit0 as the VRAM-bank flag, masks the destination low byte to a 16-byte boundary and writes C-1 to rHDMA5. C=40 or10 gives 1024 or256 bytes. B=92 or97 is the LY wait limit. The request uses direct transfer with bit7 clear; the routine name alone does not imply HBlank operation. BankSwitch_H at home0622 selects ROM bank22 because H is below80. Both complete caller routines, the bank-switch helper and transfer helper were mapped from the maintained source and compared with immutable ROM, including their branches. This does not generalize safety of the LCDC-off and wait/retry paths.

Gfx_AddrBook_TilesBank22 begins at5CD0 and holds26 bytes: one complete16-byte tile plus the first10 bytes of the next tile.

`AddrBook_ListAndAddressGraphicsContinuation` begins at5CEA inside that tile.

The inherited RGB555 palette heuristic for the first26 bytes conflicts with the actual tile-pattern VRAM consumer and is corrected to CONFIRMED tile-family data.

In the earlier two-header typing pass, exactly two existing data headers changed in place. At that pass, raw db rows, physical boundaries, labels, line counts, banked addresses and references were preserved. Both headers remain kind data. No graphics asset was created or exported, and no catalogue, PNG rule, generated make fragment or frozen configuration changed. The current pure exporter plan still classifies both fragments as None, so the unaligned continuation is not exported as a standalone tile sheet.

## Complete 2bpp source export

Four natural calls in the address-book list/editor routines transfer the disjoint 1,024/256/1,024/256-byte ranges to VRAM bank 1.

`python3 tools/png_rules.py mk-check` accepted 994 rules and `python3 tools/gfx_export.py check` accepted 995 assets, including 425 exact tile PNGs.

KEEP includes the unread37-byte blank-string candidate,11-byte static decimal-template candidate, five literal-zero bytes at510B,6448 literal-zero bytes at66D0 and unresolved or unexecuted paths. No unused-code or padding purpose follows from the absence of natural reads. The ordered original queue continues through the remaining bounded bank22 passes and then25 and26. Whole-bank semantic completion is not asserted.
