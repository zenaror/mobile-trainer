# reference 2, data: adversarial reference of the sprite-data family

## 1. The formats, re-derived from the ROM0 sprite engine (independent of the pass's text)

`home/sprites.asm`, read instruction by instruction:

* `Sprite_InitSlot` (00:0A82): `A` = ROM bank of *everything* (stored at slot+0E, `ld [$2100],a` before the table is read), `HL` = slot, `DE` = object table, `B` = entry id.

* `Sprite_LoadObjectEntry` (00:0AB8): entry = `DE + 4*(B & $7F)` (bit 7 is stored in slot+0F and only read when the script ends).

* `Sprite_StepAndDrawSlot` (00:0AE8): script = `db n ; n x (frame index, delay)`; next index compared with `n` (wraps to 0 unless bit 7 of slot+0F).

Record address = `[frame table + 2*frame index]`,   record = `db n ; n x (y, x, tile, attribute)` (loop 00:0B9D adds slot Y+16 / X+8).

This is exactly the pass's model (`<Table> entry = {frame table ptr, script ptr}`, `1+4n` records, `1+2n` scripts).  Additional fact the pass does not state: the entry id is the *only* thing that selects
(frame table, script); in every table of the ROM the pair is 1:1 (no frame table is used with two scripts, no script with two frame tables, no record shared by two frame tables, no address with two roles).

**Power of the check**: moving `TopMenu_Anim1Frames` and `PageList_Anim0Script` by +1 in a copy of the symbol file gives exactly those two mismatches.

`ld de,$4D30` with `A=$5F` (Kbd) and `Label_57_4566` loading bank-56 sprites from bank-57 code are the two cases where code bank and table bank differ; both were resolved with `A`, not with the code's bank.

### The flaw: `BrowserMenu_Cursor`

The full site list has 13 sites: the menu routines `BrowserMenu_OpenTwoItem/OpenThreeItem` (entry 1, `B=$81`) and `DrawItemTwo/DrawItemThree` (variable `B`, offset 0), and **9 sites in bank 4E (`scrollbar.asm`)** with `A=$72`: `Browser_DrawScrollIndicators` (entries 6, 9, 11), `Browser_ShowUpArrow` (5, 8, 10) and `Browser_LoadScrollbarGfx` (`ld de,$7858` = table+48; entries 13, 15, 16).

The stem `BrowserMenu_Cursor` therefore names the screen of one sibling for blocks that another sibling loads.

* **E1** `AdapterCheck_ObjTableAndAnimData` (4A:68D0): the evidence says "first 16 bytes are the 4-byte entries (entry 0 zero, entries 1..3 = 68D8/690C 68E0/68E9 68F2/690B)".  Only **entry 1** (68D8/690C) is an entry
  (`AdapterCheck_DrawScreen` loads `B=$81`); bytes 68D8-68DF are the frame table of entry 1 (four words 68E0, 68E9, 68F2, 690B), i.e. "entries 2 and 3" are its words.  Chain read from the ROM: records 68E0/68E9
  (count 2, 9 bytes each), 68F2 (count 6, 25 bytes), 690B (count 0, 1 byte), script 690C (`04: (0,$14)(1,$14)(2,$14)(3,$14)`, all indices < 4).  The name and PROBABLE stand; the assertion `ents[1:] all inside` in the generator proves nothing more than the word values.
* **E2** `ConfirmPages_ObjTable` and `SettingsMenu_ObjTable`: evidence "1 entries of which 0 distinct" counts the label extent (4 bytes = the null entry 0).  The table has 2 entries and the only one ever loaded (7 and 1 sites,
  `B=$81`) is entry 1, in the following neutral groups `Data_4A_4004` (47 bytes: entry, 2-word frame table, records, script) and `Data_4A_583C`, which stay unnamed.  Suggestion (not applied): `ConfirmPages_ObjEntryAndAnimData` /
  `SettingsMenu_ObjEntryAndAnimData` in the style of the AdapterCheck block.
* **E3** The region-level statement "a group that holds several structures and starts with animation data" is right for all 33 `_ObjAnimData` blocks, but part of the blocks is not reached from any entry (e.g. `MailServerMgr_ObjAnimData_2E_7720`:
  146 non-zero bytes, items at 2E:7710..77F8 that no entry points to; `AddrBookShared_ObjAnimData`: one 3-byte script at 28:5433; 9 blocks with 2-146 unreached non-zero bytes, listed by `tools/sprite_chain_check.py -v`).  Consistent
  with dead sprites; the names only say "reached from the table" and stay.

None lowered, none raised.  All 486 rows stay PROBABLE (static evidence only: no row has an executed load of the *sprite* structure cited; the chain itself is verified against the ROM bytes).  Nothing was promoted.
