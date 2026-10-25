# Help menu maps and selected object chains

## Eight accepted roles

| Original name | Semantic name | Role status | Exact storage limits |
|---|---|---|---|
| Table_6A_64AE | Objects_HelpMenu | CONFIRMED | Logical four-byte entry64AE-64B2 spans three bytes in gfx source plus one neighboring byte; all four naturally read12scenarios. Existing representations/boundaries retained. |
| Tilemap_6A_4870 | Tilemap_HelpMenu_Page1_NormalItems | CONFIRMED |420bytes, two210-byte planes; all420naturally read. Exact storage header/asset statuses are CONFIRMED. |
| Tilemap_6A_4A14 | Tilemap_HelpMenu_Page2_NormalItems | CONFIRMED |180bytes, two90-byte planes; all180naturally read. Exact storage header/asset statuses are CONFIRMED. |
| Tilemap_6A_4AC8 | Tilemap_HelpMenu_Page3_NormalItems | CONFIRMED |180bytes, two90-byte planes; all180naturally read. Exact storage header/asset statuses are CONFIRMED. |
| Tilemap_6A_4B7C | Tilemap_HelpMenu_Page1_SelectedItems | CONFIRMED |420bytes, only360naturally read; locked-item2's tile30+attribute30 bytes remain PROBABLE. |
| Tilemap_6A_4D20 | Tilemap_HelpMenu_Page2_SelectedItems | CONFIRMED |180bytes, two90-byte planes; all180naturally read. Exact storage header/asset statuses are CONFIRMED. |
| Tilemap_6A_4DD4 | Tilemap_HelpMenu_Page3_SelectedItems | CONFIRMED |180bytes, two90-byte planes; all180naturally read. Exact storage header/asset statuses are CONFIRMED. |
| Table_6A_72BB | Objects_HelpScript_Slot2 | CONFIRMED |One four-byte entry, same object on OnA/OnB/TextFinished paths; selected27-byte frame/script chain and entry4bytes all naturally read. |

## Complete instruction and consumer census

| Map role | Locked consumer(s) | General indexed consumer |
|---|---|---|
| Page1 normal |6C:435A1hit/1scenario;439D104/10 |43F9535/11 |
| Page2 normal |44342/1 |4486186/9 |
| Page3 normal |44C114/2 |451368/4 |
| Page1 selected |457C0/0;45BF12/5 |461B388/12 |
| Page2 selected |46561/1 |46A8187/9 |
| Page3 selected |46E37/2 |473575/4 |

## 64AE: split object entry and classification conflict

The frame table at6330 consists of nine words, ending6342. Frame records are6342,6363,6384,63A5,63C6,63E7,6408 (eight pieces each,33bytes),6429 (twelve pieces,49bytes, crossing6448),645A (sixteen pieces,65bytes). The nine-step script at649B is(0,4),(1,4),(2,4),(3,4),(4,4),(5,4),(6,6),(7,12),(8,12), ending64AE. Its maximum index8 and first-frame6342 jointly establish exactly nine frame pointers. The complete table/frames/script/entry cover6330-64B2 without gaps:386bytes, all naturally read, per-byte counts11-12scenarios. All four entry bytes were read12scenarios.

The previous header classified the 280-byte 6330-6448 region by a palette heuristic. Its palette-type asset row and RGB-word INCLUDE remain. The existing 140 RGB words emit 280 bytes matching the original ROM. That validates the representation, not a palette interpretation. The demonstrated sprite decoder consumes those same bytes as a frame table and frame records; its frame6429 continues through the first18raw bytes in the next region. The two raw 'not reached by any walked sprite chain' comments are refuted by this chain.

HelpMenu_ShowItemText (6C:4763, farcall at4791) supplies the normal page/cursor index to Ticker_Start (48:42D4), whose ReadByteFar consumes that bank byte before selecting the pair.

Zero-based record4 (page2, item1) selects title$65A1 and body$65A8.

## 72BB: complete slot2 chain and all three paths

The table has two words at72A0-72A4; the records72A4-72AD and72AD-72B6 each contain two OAM pieces.

Original load/bank/selector pattern11 BB72 3E6A 0680 occurs exactly at6C:5D17,5D3E,5DAD.

Every path receives slot2 and B=$80; OnA/OnB subsequently set position with DE=$00AA and resume the script, while TextFinished's non-mode2 path sets DE=$7880 and resumes the frame loop.

The existing structured macros and neutral Data_6A_72A0 remain. Exact27-byte-chain and4-byte-entry header confidence are CONFIRMED from their existing natural read proof, without upgrading any neighboring resource or renaming the separate pending macro role.

## Mechanical frame-table alias at 6A:72A0

The mechanical alias `SpriteFrameTable_6A_72A0` describes the existing two-word table read through `Objects_HelpScript_Slot2`; `Data_6A_72A0` remains at the same address.

The legacy structured-data worklist row retains HYPOTHESIS while recording APPLIED_ALIAS, distinct from the already CONFIRMED byte ranges.

## Help-menu object data reclassified at 6A:6330

`gfx/help/help_screens_a.asm` now uses `SpriteFrameTable_HelpMenu`, `SpriteFrame_HelpMenu_00` through `_08`, and `SpriteScript_HelpMenu` with the shared sprite macros.

The first three object-entry bytes use `LOW`/`HIGH` expressions; the high script-pointer byte remains in `data/text/help_menu_ticker.asm` because the original source boundary is at 64B1.

`palette_6330.pal` and its palette catalogue/rule rows are removed.
