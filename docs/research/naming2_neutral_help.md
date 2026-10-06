# Help menu maps and selected object chains

> Status: **reference (current)**. Role, complete-unit boundaries and natural read coverage were reconstructed independently before proposal review. Original aliases and byte representations are preserved.

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

The labels describe source-consumer roles, not rendered colors or guessed visual identities. Page numbers, normal-item vs current-cursor selection, and slot ownership are derived from code and existing CONFIRMED scoped RAM roles. No name requires a PNG interpretation or hardware claim. All old aliases remain. Data_6A_72A0 stays neutral as the separate structured-data cohort; the completed indirect proof is recorded here, without adding a ninth rename.

## Complete instruction and consumer census

The eight names have24existing instruction operands:2 for64AE,4/2/2/4/2/2 for the six maps,6 for72BB. Six additional numeric base loads in help_menu.asm use the same existing map roots and were staged with separate exact guards. Thus30instruction spellings change, with8semantic aliases and no new data. Full source sites, original instruction bytes, selected-source-bank proof, and natural union counts were independently checked against the original ROM and natural coverage. The strict application accepts all eight rows after staging: 30 instruction spellings, eight aliases, no annotations. The additional six numeric substitutions were explicitly staged before the strict rename, not hidden in that24count.

| Map role | Locked consumer(s) | General indexed consumer |
|---|---|---|
| Page1 normal |6C:435A1hit/1scenario;439D104/10 |43F9535/11 |
| Page2 normal |44342/1 |4486186/9 |
| Page3 normal |44C114/2 |451368/4 |
| Page1 selected |457C0/0;45BF12/5 |461B388/12 |
| Page2 selected |46561/1 |46A8187/9 |
| Page3 selected |46E37/2 |473575/4 |

There are14map consumers,13naturally demonstrated. The unexecuted one is preserved as a statically proven bounded reader, not promoted to natural execution. Combined with4object InitSlot consumers,17of18consumers execute naturally. The six numeric base loads at6C:43DC/446D/44FA/45FE/468F/471C independently match the original ROM, with535/11,186/9,68/4,388/12,187/9,75/4respectively. Namespace collisions were excluded before application.

## Why the complete map objects and names are justified

The fixed INCBIN assets are each two packed10-column planes: tile bytes then attribute bytes. All twelve asset files have exact expected sizes and match their original bank6A byte windows, with hashes recorded. No type, boundary, path, dimensions or resource image is changed. This is a direct tilemap/attribute consumer proof, not classification inferred from HDMA.

Tilemap_CopyRectAndAttrPtr at00:16A2 selects source bank from A/HL, sets destination WRAM bank7 from DE, copies B rows of C bytes from the tile source, then reads the separately prepared C10E/C10F pointer and copies the same rectangle to DE+$0400. Tilemap_CopyRect at00:0904 consumes consecutive source bytes, with32-byte destination row pitch. Callers use C=10, tile destinations within wScreenTileMap and second destinations in wScreenAttrMap. A=$6A or BANK(oldMap) is explicitly passed at every consumer, after all source-offset arithmetic. The farcall restores caller ROM bank6C before the next source operation. C10E/C10F are fixed WRAM0 scoped caller/helper aliases; destination buffers and sprite slots are WRAM7. No cross-screen overlay meaning is generalized.

For page1, the ROM index table contains source offsets0,$28,$46,$6E (0,40,70,110) and destinations$49,$A9,$E9,$149. General item heights are4/3/4/3; these occupy the first140bytes of each210-byte plane. Locked variants use tile offsets$8C/$AA (140/170), heights3/4, and attribute pointers exactly tile+$D2. Hence all21rows and every content unit are accounted for, including the unexecuted selected locked-item2 variant. For pages2/3, offsets0,$1E cover two3-row items, and locked item2 uses+$3C, height3; attribute pointers are tile+$5A. This accounts for all nine rows of each90-byte plane.

The two destination/index records at6C:4525 and4747 contain identical first24bytes. Page dispatch compares wHelpMenu_Page to2/3 and otherwise uses the page1 family. Shipped setup/handlers give pages1..3 and item indices1..4 on page1 or1..2 on pages2/3. DrawItemNormal uses the explicit item argument wHelpMenu_NormalItem, which setup and the D-pad handler set; DrawItemSelected uses wHelpMenu_Cursor. Normal and selected labels therefore apply to every regular and locked variant in their source objects. No safety guarantee for arbitrary corrupted/out-of-range page/item arguments is claimed.

Natural data coverage reads every byte of five map pairs. The selected page1 map is missing precisely6A:4C08-4C26 and4CDA-4CF8 (end exclusive), the two30-byte planes of its locked-item2 variant. Its entire420-byte storage remains PROBABLE and both asset halves retain PROBABLE. The five other source headers and ten corresponding asset status cells are CONFIRMED for those exact ranges only. The adjacent8-byte zero run and every other asset/type status stay unchanged.

## 64AE: split object entry and classification conflict

Original bytes at6A:64AE-64B2 are30 63 9B 64, decoded as frame-table pointer$6330 and script pointer$649B. The first three bytes are the existing db in gfx/help/help_screens_a.asm. The last byte$64 is emitted by the first dw$6A64 in data/text/help_menu_ticker.asm at64B1. No four-byte macro is substituted, no neighboring word is split, and no section/link boundary is moved.

The sole root load/bank/selector sequence11 AE64 3E6A 0680 occurs at6C:4122. Sprite_InitSlot at6C:4129 executes411times/12scenarios, receives slot1, source bank6A and B=$80: entry0, looping enabled. The saved source bank is reselected during Sprite_UpdateAll's frame/script pass. Setup places the object using DE=$371F and repeatedly updates it from the HelpMenu input loop; no cursor/visual-object identity is guessed.

The frame table at6330 consists of nine words, ending6342. Frame records are6342,6363,6384,63A5,63C6,63E7,6408 (eight pieces each,33bytes),6429 (twelve pieces,49bytes, crossing6448),645A (sixteen pieces,65bytes). The nine-step script at649B is(0,4),(1,4),(2,4),(3,4),(4,4),(5,4),(6,6),(7,12),(8,12), ending64AE. Its maximum index8 and first-frame6342 jointly establish exactly nine frame pointers. The complete table/frames/script/entry cover6330-64B2 without gaps:386bytes, all naturally read, per-byte counts11-12scenarios. All four entry bytes were read12scenarios.

The previous header classified the 280-byte 6330-6448 region by a palette heuristic. Its palette-type asset row and RGB-word INCLUDE remain. The existing 140 RGB words emit 280 bytes matching the original ROM. That validates the representation, not a palette interpretation. The demonstrated sprite decoder consumes those same bytes as a frame table and frame records; its frame6429 continues through the first18raw bytes in the next region. The two raw 'not reached by any walked sprite chain' comments are refuted by this chain.

The source comments now record the correction explicitly, preserving the RGB include, palette asset path/type/PROBABLE status, raw db and all original boundaries. It records the legacy classification conflict rather than silently declaring all possible palette uses impossible. No exhaustive negative claim about unknown additional consumers is made. The neighboring ticker label64B1 is also historical one-byte-early representation: HelpMenu_ShowItemText passes64B2 to Ticker_Start, whose first ReadByteFar consumes the bank byte6A there, followed by string pairs. This reinforces the object entry's fourth-byte provenance; no ticker rename or rewrite is proposed.

## 72BB: complete slot2 chain and all three paths

Original entryA0 72 B6 72 points to frame table72A0 and script72B6. The table has two words at72A0-72A4; the records72A4-72AD and72AD-72B6 each contain two OAM pieces. Script pairs are(0,46),(1,8), count2. Table/records/script cover27bytes and the root adds4bytes:31bytes, all naturally read. Per-byte counts are28-30natural scenarios; all four root bytes were read30.

Original load/bank/selector pattern11 BB72 3E6A 0680 occurs exactly at6C:5D17,5D3E,5DAD. Consumers are OnA at5D1E (263/20), OnB at5D45 (292/11), TextFinished at5DB4 (317/29). Every path receives slot2 and B=$80; OnA/OnB subsequently set position with DE=$00AA and resume the script, while TextFinished's non-mode2 path sets DE=$7880 and resumes the frame loop. The mode2 path does not execute this initializer. A separate PROBABLE position-only routine61AC can also reposition slot2; it does not reference the root or change this demonstrated initialization chain. No claim based on its unexecuted behavior promotes the name.

The existing structured macros and neutral Data_6A_72A0 remain. Exact27-byte-chain and4-byte-entry header confidence are CONFIRMED from their existing natural read proof, without upgrading any neighboring resource or renaming the separate pending macro role.

Exactly five map pairs have complete natural byte reads and CONFIRMED storage; page1 selected storage retains PROBABLE for its 60 unread bytes. The 6330 palette classification remains a documented historical conflict, with its RGB include and catalog type/status unchanged. No new execution, replay, image identity or hardware evidence is claimed.
