# Original browser descriptor 1

Only 4E:65A0–65BF changes representation and whole-storage confidence. The unit contains exactly 31 original bytes: five little-endian ROM address/bank triples, three WRAM7 map-destination words and five X/Y byte pairs. Existing semantic and neutral aliases remain at their original ROM addresses. The source uses existing dw/db statements and existing resource/RAM symbols; no macro, instruction, alias or shared descriptor refactor is added.

| Offset | Size | Original value | Consumer contract |
|---|---:|---|---|
| 00 | 3 | 47:4E50 | Two 400-byte BG transfers to VRAM bank 1 at 9000 and 9400 |
| 03 | 3 | 47:5B20 | BG palette; normal 40-byte copy and bounded preview subranges |
| 06 | 3 | 47:5850 | 20 by 18 tile bytes followed by 20 by 18 attribute bytes |
| 09 | 3 | 47:5650 | 200-byte sprite-tile transfer; existing tile base plus 0800 |
| 0C | 3 | 47:5B60 | OBJ palette; existing palette base plus 40, normal 40-byte copy |
| 0F | 2 | D061 | Body map destination, WRAM7 |
| 11 | 2 | D004 | Title map destination, WRAM7 |
| 13 | 2 | 48,10 | Up-arrow X,Y |
| 15 | 2 | 48,78 | Down-arrow X,Y |
| 17 | 2 | 70,80 | Timer X,Y before reader adds 08/10 |
| 19 | 2 | 08,00 | Connection-icon X,Y |
| 1B | 2 | D073 | Scrollbar map destination, WRAM7 |
| 1D | 2 | 98,18 | Scroll-thumb X,Y |

Numbers in the table are hexadecimal. Five bank bytes remain 47. Fixed and far resource loaders select the source ROM bank and restore the descriptor caller bank; palette/map routines establish WRAM7 for their destinations. Coordinate readers load X into E and Y into D; Sprite_SetPosition stores its separate fields in the required order. Coordinate pairs are not ROM pointers. Resource interior expressions explicitly retain their base bank.

The original 69-scenario corpus naturally reads all 31 bytes across 15 scenarios. Up-arrow fields appear in three scenarios and down-arrow fields in ten; remaining bytes occur in fifteen. Every field has a specific demonstrated format/consumer, supporting this bounded whole CONFIRMED header. No forced preview execution or sibling periodicity raises confidence. Unentered preview/getter code keeps its existing status.

The 27 physical descriptor-table words remain unchanged. All 21 maintained walks mask with 7F and use two additions; 17 read wBrowserFrameStyle and four hFramePreview_Style. There is no universal 27-slot clamp. Only table entry 1 selects this unit. Other four descriptors, the table, unknown6543, all bank47 assets and every asset status remain unchanged. New resource references do not promote the resources' whole-storage confidence.

The fresh scoped reference census includes three rows: the forward table entry and both definitions. Metadata audit covers 289 maintained TSVs, all 649 generic literal source locators and the owner schemas. Five screens.tsv tile_ops fields are context, not line numbers. Source representation adds 16 lines after the original aliases; every later label has an explicit line map. No maintained locator needs movement because its actual instruction is before the changed data. No blind delta or historical record rewrite is applied.

The independent complete bank4E inventory and corrected provenance annex preceded this bounded derivation. Source inputs come from immutable git archive 1782ec88. Current published English synchronization documentation remains byte-identical. A later coordinator documentation checkpoint needs a separate rebase receipt. This original reconstruction pass makes no English runtime, appearance or hardware claim. Privacy zero; no personal example records are reproduced.
