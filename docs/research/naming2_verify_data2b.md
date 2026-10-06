# Naming pass 2, data: adversarial verification of the sprite-data family

Scope: the 486 sprite rows of `analysis/naming2/data2_renames.tsv` (all PROBABLE): 11 new `<Screen>_ObjTable` roots + `AdapterCheck_ObjTableAndAnimData`, 106 `_Anim<N>Frames`, 223
`_Anim<N>Frame<k>[To<m>]`, 112 `_Anim<N>Script`, 33 `_ObjAnimData*`; plus the 30 roots that were already named and the 10 pre-existing `Anim`/`ObjAnimData` names of the same tables
(511 names in all).  Private copy: `scratchpad/verify_data2b/`; the real tree was not touched (only the three deliverables are added).

Result: **one naming flaw found** (the stem `BrowserMenu_Cursor`, 9 renames in `analysis/naming2/verify_data2b_fixes.tsv`), 3 evidence errors, 0 status lowerings; the
remaining 477 sprite rows and all other roots are upheld.  **No systematic flaw**: no scheme is off by one, every name is at the exact start of the structure its chain reaches.
`python3 tools/apply_renames.py --manifest analysis/naming2/verify_data2b_fixes.tsv --strict` in the private copy: `9 applied, 0 refused`, `SHA-256 OK 6d802e66...76570`, `sym_check OK`;
the checker run again after the renames: 0 mismatches.

## 1. The formats, re-derived from the ROM0 sprite engine (independent of the pass's text)

`home/sprites.asm`, read instruction by instruction:

* `Sprite_InitSlot` (00:0A82): `A` = ROM bank of *everything* (stored at slot+0E, `ld [$2100],a` before the table is read), `HL` = slot, `DE` = object table, `B` = entry id.
  **There is no bank byte in the table**: frame table, records and script are pointers into the same bank `A`.  The bank is therefore part of a root's identity (same address in another bank = other block).
* `Sprite_LoadObjectEntry` (00:0AB8): entry = `DE + 4*(B & $7F)` (bit 7 is stored in slot+0F and only read when the script ends).  Word 0 -> slot+2/3 (frame-table pointer),
  word 1 -> slot+6/7 (script pointer); then `inc bc` past the script's count byte and `script[1], script[2]` (first frame index, first delay) -> slot+4/5.
* `Sprite_StepAndDrawSlot` (00:0AE8): script = `db n ; n x (frame index, delay)`; next index compared with `n` (wraps to 0 unless bit 7 of slot+0F).  Record address = `[frame table + 2*frame index]`,
  record = `db n ; n x (y, x, tile, attribute)` (loop 00:0B9D adds slot Y+16 / X+8).  **The frame table has no length field**; its length is only implied (by the records that follow it and by the script indices).

This is exactly the pass's model (`<Table> entry = {frame table ptr, script ptr}`, `1+4n` records, `1+2n` scripts).  Additional fact the pass does not state: the entry id is the *only* thing that selects
(frame table, script); in every table of the ROM the pair is 1:1 (no frame table is used with two scripts, no script with two frame tables, no record shared by two frame tables, no address with two roles).

## 2. Method and statistics (`tools/sprite_chain_check.py`, new, deterministic)

1. **Sites**: every `call|farcall Sprite_InitSlot` in the source (712) resolved from the preceding straight-line window (`ld de,X`, `ld a,$BB`, `ld b,..`).  712 = the number of
   `CD xx xx 82 0A 00` patterns (`call FARCALL_FN ; dw $0A82 ; db 00`) in the ROM.  For all sites with a label operand the label's bank equals `A` (0 bank mismatches); every resolved (bank, address)
   is also a possible `ld a,imm8` / `ld de,imm16` pair before a far call in the ROM bytes.  The sites resolve to **49 roots**: 46 with a semantic name (the pass's 30 + 11 new ones, plus `Objects_Title`, `Table_DebugFlags_Objects`, `Table_MailMenu_Objects`, `CommErr_ObjTable`,
   `BrowserStart_ObjTable`... whose children are not named) and 3 neutral ones (`Data_5D_7200` (since the graphics retyping the interior of `Tilemap_Registration_WriteConfig_5D_7048`; the label no longer exists) and `Data_6A_6448` are interior immediates into tile/data groups, `Table_6A_72BB`).
2. **Walk** (reading the reference ROM `Mobile Trainer (Japan).gbc`, not the source): the entries of a root are the run of plausible 4-byte entries from the label (the label's extent is *not*
   used: `ConfirmPages_ObjTable` and `SettingsMenu_ObjTable` are labelled over their null entry 0 only, the real entry 1 is in the next group), cut at the next root and at the lowest pointer target after the table.
   The table end coincides with a symbol boundary in 35 of the 46 semantic roots (the others end at the end of their section, in zero padding).
   Result: **920 entries (901 non-null, 288 distinct (frame table, script) pairs) on the 46 semantic roots**; over all 49 roots **289 frame tables, 289 scripts, 547 records**.
3. **Frame-table length**: the distance to its first record (tables are followed directly by their first record), cross-checked with the highest frame index of the scripts paired with it.
   **0 violations** (every script frame index < the frame-table length), for all 289 tables, matching the pass's "0 violations" claim (its "880 combinations" for 41 roots is of the same order as my 901 non-null
   entries on 46 roots; not recomputed per root).
4. **Names**: every symbol `<Stem>_Anim<N>Frames|Frame<k>[To<m>]|Script`, `*_ObjAnimData*`, `*_ObjTable` (511) checked against the walk: address equality, extent (frame table = 2 x words,
   record = 1+4n, script = 1+2n followed only by zero bytes, `FrameKToM` tiles exactly), `N` = an entry index that reaches the block, `k` = the *first* frame index that uses the record, no block reached by two roots
   but named after one, the root of an `ObjTable` name is loaded by a site, the stem is related to the root's names.
   **Result: 0 mismatches in 511 names** (114 frame tables, 223 records, 112 scripts, 36 ObjAnimData-type blocks, 26 root names).  Suffixes that embed an address (`_72_786E`, `_2C_7357`, ...) equal the symbol address in all
   cases; `MailSession_6F20_ObjAnimData` / `_72FB_` embed the address of the *root* (`MailSession_ObjTable_6F20`), not of the block (by design, worth knowing).
5. **Power of the check**: moving `TopMenu_Anim1Frames` and `PageList_Anim0Script` by +1 in a copy of the symbol file gives exactly those two mismatches.  The evidence column of the manifest was
   also re-checked mechanically for all 441 frame-table/record/script rows (counts, lengths, "frame k of table T" pointers, "entry j of root R" pointers read from the ROM): 0 errors.
6. **Consumers** of the 41 roots: complete site lists (not only the pass's accepted sites) with the entry each site loads (`B & $7F` + interior offset / 4), see section 4.

## 3. Numbering and sharing

* `N` is the entry index; `k` the frame index.  Consistent everywhere, but two facts make the numbers less informative than they look (PROBABLE, no change needed):
  * In 23 of the 49 roots (203 aligned rows; e.g. `SpriteCounter_Digits`, `PageList`, `MailResult`, `MailBody_29`, `Profile`, `MailDraftMenu`, `MailView`, `MailGrid`, `Mailbox`, `MailConnect`, `AddrBookShared`) the entries come in rows of **four identical entries**
    (`Anim0` = entries 0-3, `Anim4` = entries 4-7, ...).  The name carries the first entry of the row; the code loads the row through `ld de,table+16*row ... B=$81` = the row's entry **4r+1**, never `4r`.
    So `MailResult_Anim4Frames` is used as entry 5, not 4.  Not wrong (the four entries are identical), but `Anim<N>` should not be read as "the id the code passes".
  * `ConnIcon_Anim1*` (pre-existing names) covers entries 0 and 1.
* Blocks shared between **roots** (different screens): none (0 of 511).  Blocks shared between entries of one root: the identical-entry rows above (and `ConnIcon_Anim1`); always named after the first entry, as the pass's note says.
* No frame record is shared by two frame tables (the pass's note "none found" is right).
* 54 named rows are only reached through entries for which no site loads an immediate `B` (and the root has no variable-`B` site): `SpriteCounter_Digits_Anim40..76` (30 rows; rows 10-19 of the digit table,
  only rows 0-9 are loaded), `MailBody_29_Anim32/36` (8), `Profile_Anim0/4/16` (12), `MailView_Anim4` (4).  The structure names are exact; that these entries belong to the stem's screen rests on the root
  alone (PROBABLE is right, no CONFIRMED possible).  For `Kbd_*` (21 rows) and `ConnIcon_*` (37 rows) the root has variable-`B` sites, so the same statement cannot be made either way.

## 4. Roots and their consumers (bank byte verified for every site)

The 11 roots named by this pass (sites = Sprite_InitSlot calls resolved to the root; "A" = bank argument, equals the bank of the label in every case):

| root | bank:addr | sites | consumers (complete list) | verdict |
|---|---|---:|---|---|
| `TopMenu_ObjTable` | 1E:656F | 12 | `TopMenu_Run`, `TopMenu_LoadPanel`, `TopMenu_InitItemSprites`; A=$1E; entries 1-6 | upheld |
| `Kbd_ObjTable` | 5F:4CF8 | 15 | `Kbd_Open/Run/UpdateCursorSprite/TypePickerLoop/ShowMarkerSprite/ShowPageIndicator/UpdatePickerSprites` + the hosts `Account_LoginIdEntry/MailAddressEntry/PasswordEntry_Setup`, `PhoneComment_KeyboardSetup`, `PhoneKeypad_Setup` (raw `$4D30` = entry 15, A=$5F) | upheld (the hosts load the keyboard's own entry) |
| `ConnectDialog_ObjTable` | 56:79B8 | 11 | `ConnectDialog_Draw_ConnectConfirm/_PasswordEntry`, `_Keyboard_AppendChar/EraseChar`, `_ObjHook_Caret`, `Label_57_4566/45BC` (bank-57 code of connect_dialog.asm, A=$56) | upheld |
| `ConfirmPages_ObjTable` | 4A:4000 | 7 | 7 confirm-page setups (`Account_*Confirm*`, `PwSaveConfirm`, `Registration_DeleteConfirm`, `SettingsPhone_ConfirmScreen/ContinuePrompt`), all `B=$81` = entry 1 | upheld; label covers only the null entry 0 |
| `AddrBookShared_ObjTable` | 28:5210 | 73 | `AbookList_*`, `AddrPick_*`, `SaveSenderAddr_*`, `Label_2F_4131` (list.asm:210); entries 4-16 via `ld de,table+16k`, B=1 | upheld |
| `MailServerDeleteMethod_ObjTable` | 28:6E80 | 16 | `MailSrvDel_MenuInit/MenuSelect/Confirm/ConfirmSelect` + the four `MailSrvDelHidden_*` twins; all entry 1 or 5 | upheld (the gfx of the same flow already uses this stem) |
| `SettingsMenu_ObjTable` | 4A:5838 | 1 | `SettingsMenu_StateInit`, B=$81 | upheld; label covers only the null entry 0 |
| `SettingsPhone_ChoiceMenu_ObjTable` | 4D:5D10 | 1 | `SettingsPhone_ChoiceMenu_Setup`, B=$81 | upheld |
| `SettingsPhone_SlotMenu_ObjTable` | 4D:7960 | 1 | `SettingsPhone_SlotMenu_Setup`, B=$81 | upheld |
| `CommPanel_ObjTable` | 71:4FB8 | 1 | `CommPanel_StateDraw`, B=$81 | upheld |
| `Registration_DeleteExecute_ObjTable` | 71:6F38 | 1 | `Registration_DeleteExecute_Setup`, B=$81 | upheld |
| `AdapterCheck_ObjTableAndAnimData` | 4A:68D0 | 1 | `AdapterCheck_DrawScreen`, B=$81 (entry 1 = 68D8/690C) | upheld; evidence text wrong (E1) |

The bank byte matters: e.g. `ld de,$4D30` with `A=$5F` (Kbd) and `Label_57_4566` loading bank-56 sprites from bank-57 code are the two cases where code bank and table bank differ; both were resolved with `A`, not with the
code's bank.  No raw-immediate site resolved to a root in a bank different from its `A`.

The 30 roots named earlier (children named by this pass): stems checked against the complete consumer lists.  Upheld: `PageList`, `MailResult`, `Profile`, `MailDraftMenu`, `MailGrid`, `CommNotice`, `CommScene`,
`CommScene_Text`, `CommPanel`, `ConnIcon`, `MailSrvDel_ProgressObject`, `SpriteCounter_Digits`, `TextCursor`, `AddrSlotIcon`, `Mailbox`, `AddrScreenUnused`, `DebugFlags`, `MailServerMgr`, `Abook_ButtonCursor`, `Abook_ViewCursor`,
`PageListProto`, `NoAdapter`, `BrowserStart`, `Dialog_Cursor`.  Notes without change (stem broader or narrower than a literal reading, but every consumer is in the same screen family of the earlier, already verified root name):
`MailConnect` (27:7A10) is loaded by the connect, disconnect and session-send routines (`MailConnect_*`, `MailDisconnect_*`, `MailSession_Run/SendPhase`); `MailBody_28` (28:4B70) is loaded by the mail text view
(`MailBody_InitScreen`) and by viewer page 2 (`MailView_BodyPage_InitScreen`); `MailView` (2B:78A0) is used by the sender page only (`MailView_SenderPage_InitScreen`, `Function_2B_687C`).

### The flaw: `BrowserMenu_Cursor`

`72:7828` (17 entries) was named `BrowserMenu_CursorObjTable` by `naming_g7`/`config/symbols/bank72.tsv` from three menu call sites ("menu cursor sprites, used at 72:64C6, 72:6802, 72:66BE").  The full site list has 13 sites: the menu routines
`BrowserMenu_OpenTwoItem/OpenThreeItem` (entry 1, `B=$81`) and `DrawItemTwo/DrawItemThree` (variable `B`, offset 0), and **9 sites in bank 4E (`scrollbar.asm`)** with `A=$72`: `Browser_DrawScrollIndicators` (entries 6, 9, 11),
`Browser_ShowUpArrow` (5, 8, 10) and `Browser_LoadScrollbarGfx` (`ld de,$7858` = table+48; entries 13, 15, 16).  Seven of the eight `_ObjAnimData` blocks and `Anim12Frames` are reached only by entries whose direct consumers are
these scroll routines (786E, 7880, 7894, 78F5, 795B, 79A0, 7A04; entries 12-16, 8-9, 5/7, 2/6, 3/4/10, 11); only `78CA` (entries 0/1) has menu-routine consumers.  The stem `BrowserMenu_Cursor` therefore names
the screen of one sibling for blocks that another sibling loads.  **Renamed** to `BrowserShared_*` (root, `Anim12Frames`, 7 blocks; precedent `AddrBookShared_ObjTable`); `BrowserMenu_Cursor_ObjAnimData_72_78CA` stays (its only direct consumers are the menu routines).
The earlier note's claim of a "menu cursor table" was incomplete, not invented: the contradiction is recorded in the fixes file and here, the old names remain in the git history.

## 5. Evidence errors (names upheld)

* **E1** `AdapterCheck_ObjTableAndAnimData` (4A:68D0): the evidence says "first 16 bytes are the 4-byte entries (entry 0 zero, entries 1..3 = 68D8/690C 68E0/68E9 68F2/690B)".  Only **entry 1** (68D8/690C) is an entry
  (`AdapterCheck_DrawScreen` loads `B=$81`); bytes 68D8-68DF are the frame table of entry 1 (four words 68E0, 68E9, 68F2, 690B), i.e. "entries 2 and 3" are its words.  Chain read from the ROM: records 68E0/68E9
  (count 2, 9 bytes each), 68F2 (count 6, 25 bytes), 690B (count 0, 1 byte), script 690C (`04: (0,$14)(1,$14)(2,$14)(3,$14)`, all indices < 4).  The name and PROBABLE stand; the assertion `ents[1:] all inside` in the generator proves nothing more than the word values.
* **E2** `ConfirmPages_ObjTable` and `SettingsMenu_ObjTable`: evidence "1 entries of which 0 distinct" counts the label extent (4 bytes = the null entry 0).  The table has 2 entries and the only one ever loaded (7 and 1 sites,
  `B=$81`) is entry 1, in the following neutral groups `Data_4A_4004` (47 bytes: entry, 2-word frame table, records, script) and `Data_4A_583C`, which stay unnamed.  Suggestion (not applied): `ConfirmPages_ObjEntryAndAnimData` /
  `SettingsMenu_ObjEntryAndAnimData` in the style of the AdapterCheck block.
* **E3** The region-level statement "a group that holds several structures and starts with animation data" is right for all 33 `_ObjAnimData` blocks, but part of the blocks is not reached from any entry (e.g. `MailServerMgr_ObjAnimData_2E_7720`:
  146 non-zero bytes, items at 2E:7710..77F8 that no entry points to; `AddrBookShared_ObjAnimData`: one 3-byte script at 28:5433; 9 blocks with 2-146 unreached non-zero bytes, listed by `tools/sprite_chain_check.py -v`).  Consistent
  with dead sprites; the names only say "reached from the table" and stay.

## 6. Sampled names (random, seed 20260930, 3 per family; each read byte by byte)

| name | bank:addr | bytes read and chain | verdict |
|---|---|---|---|
| `MailBody_29_Anim36Frames` | 29:64C9 | root 29:6350 entry 36 = `c9 64 ef 64`; words `64CD 64DE` (4 bytes = group); records count 4 (17 bytes) at 64CD and 64DE; script 64EF `02: (0,$2E)(1,8)` | upheld |
| `MailView_Anim28Frames` | 2B:7A97 | root 2B:78A0 entry 28 = `97 7a fd 7a`; words `7A9B 7ACC`; two records of count 12 (49 bytes) | upheld |
| `MailBody_29_Anim4Frames` | 29:6419 | root 29:6350 entry 4 (table+16) -> words `641D 6422` (4 bytes = group); records at 641D/6422 (count 1, 5 bytes each); shared by entries 4-7 | upheld |
| `ConnIcon_Anim1Frame5` | 69:4841 | frame table 4794 (8 words), word 5 = 4841; count 8 -> 33 bytes = group; entries 0 and 1 share the table | upheld |
| `PageList_Anim0Frame4` | 24:663C | frame table 65C0 (6 words), word 4 = 663C; count 9 -> 37 bytes | upheld |
| `Kbd_Anim5Frame0` | 5F:4E03 | root 5F:4CF8 entry 5 = `01 4e 20 4e`; frame table 4E01 has one word 4E03; record count 7 (29 bytes = group) | upheld |
| `MailResult_Anim12Script` | 24:7CA1 | `xxd` of 24:7B50: entry 12 = `96 7c a1 7c`; table 7C96 -> word 7C98 (count 2, 9 bytes) then script `01 00 04`; entries 12-15 identical | upheld (entry row of four) |
| `CommNotice_Anim0Script` | 50:6CE6 | root 50:6D16 entry 0 = `c0 6c e6 6c`; script `02 00 2e 01 08` (0 <-> frame 0 for $2E, 1 for 8) | upheld |
| `Profile_Anim16Script` | 2A:6F92 | root 2A:6E50 entries 16-19 identical; script `01 00 04` | upheld (no direct consumer, see section 3) |
| `Mailbox_ObjAnimData` | 26:7BE0 | entries 0-3 of 26:7B00 = `e0 7b 06 7c` (frame table 7BE0 = start of the block, script 7C06 inside it); the block begins with that frame table (`e4 7b f5 7b`, two records of count 4); coverage 353 of 1056 bytes, the remaining bytes are zero | upheld |
| `BrowserShared_ObjAnimData_72_7880` (was `BrowserMenu_Cursor_...`) | 72:7880 | 20 bytes = 2 items: ft word 7882, record (1: y0 x0 tile $FF attr 7), script `01 00 04`; ft word 788C...; entries 15/16 | renamed (stem) |
| `MailConnect_ObjAnimData_27_7BA5` | 27:7BA5 | 28 bytes = 2 items (ft word, 9-byte record count 2, 3-byte script) exactly covered by entries of 27:7A10 | upheld |

Not sampled but individually decoded: all 11 new roots (table bytes, consumers, bank), `AdapterCheck_ObjTableAndAnimData`, `BrowserShared_*`.

## 7. Status corrections

None lowered, none raised.  All 486 rows stay PROBABLE (static evidence only: no row has an executed load of the *sprite* structure cited; the chain itself is verified against the ROM bytes).  Nothing was promoted.

## Reproduce

```
make
python3 tools/sprite_chain_check.py -v                     # 0 mismatches; -v lists the informational notes
python3 tools/sprite_chain_check.py --explain MailResult_Anim12Script Kbd_Anim5Frame0
python3 tools/apply_renames.py --manifest analysis/naming2/verify_data2b_fixes.tsv --strict     # in a private copy
```
