# Naming pass 2, data: consumers of the neutral DATA labels

Third naming pass over labels that still carried neutral names after `naming_g1.md` .. `naming_g8.md` and the four code/data manifests of `naming2_g1_home.md` .. `naming2_g4_apps_b.md`:
the neutral **data** labels (`Data_/Table_/String_/Tiles_/Tilemap_/Palette_/Font_ + _BB_AAAA`) that are not aliases of a semantic name.  The pass names a block only when
a **named consumer** is found *and* the structure of the block is shown by how the code walks it or by the region header (at least two independent pieces).
Deliverables: the manifest [`analysis/naming2/data2_renames.tsv`](../../analysis/naming2/data2_renames.tsv) (795 rows: 203 CONFIRMED, 577 PROBABLE, 15 HYPOTHESIS; format
`old new kind status evidence`, HYPOTHESIS rows keep `new == old` and are not applied) and the helper [`tools/data_consumers.py`](../../tools/data_consumers.py), which *generates*
the manifest (deterministic; two runs give identical bytes).  No `.asm` file was edited here.

Check done on a private copy of the tree: `python3 tools/apply_renames.py --manifest analysis/naming2/data2_renames.tsv --strict` prints `795 row(s): 780 applied, 0 refused`,
`SHA-256 OK 6d802e66...76570`, `sym_check OK`; a second run is a no-op (`780 already applied`); `make` still says `RESULT: IDENTICAL`.  Every `old` is defined exactly once as `Old::`
(795/795), every `new` is unique and absent from the tree (780/780; labels, `DEF`s, RAM, the other manifests), every alias sits at the address encoded in the old name (`sym_check`).

Status words as in `STYLE.md`.  Here CONFIRMED means: every load site used for the name is a row of `config/xrefs.tsv` that `tools/xref_infer.py` itself marks CONFIRMED (the load
was executed and the target bytes were read in the same scenario), or the region header of the block is CONFIRMED for the same reason.  Everything that rests on static evidence only
(sprite structure checked against the ROM bytes, tables read by a routine that is not proven executed, blocks reached through tables) is PROBABLE; nothing is promoted by the
names of the consumers alone.

## Inventory and result

The tool finds **1,696 neutral data groups** (a group = one address, all of whose labels are neutral): Data 1,154, Table 215, String 142, Tiles 64, Tilemap 50, Palette 40,
Font 27, Attrmap 4.  (The task brief quotes about 1,190 + 265 + 200 + 205 labels; those counts include the neutral aliases of already-named blocks, this one does not.)

| result | groups |
|---|---:|
| renamed (applied rows) | 780 (Data 597, Table 121, Font 27, Tilemap 16, Palette 9, String 7, Tiles 3) |
| HYPOTHESIS rows (not applied) | 15 |
| left neutral | 901 |

Applied rows by family (C / P = CONFIRMED / PROBABLE):

| family | rows | C | P | rule |
|---|---:|---:|---:|---|
| A1 tile blocks loaded by `Gfx_StartHDMA[WithService]` | 135 | 129 | 6 | `Gfx_<Screen>_Tiles<VRAM>[Vb1]` |
| A2 tilemap+attribute blocks loaded by `Tilemap_CopyRectAndAttr[Ptr]` | 46 | 44 | 2 | `Tilemap_<Screen>[_BB_AAAA]` |
| A3 palettes loaded by `Palette_LoadToBuffer` | 18 | 17 | 1 | `Palette_<Screen>_Bg|Obj[n]` |
| B1 object-table roots (new names) | 11 | 0 | 11 | `<Screen>_ObjTable` |
| B2 frame tables | 106 | 0 | 106 | `<Stem>_Anim<N>Frames` |
| B3 frame records | 223 | 0 | 223 | `<Stem>_Anim<N>Frame<k>` / `...Frame<k>To<m>` |
| B4 animation scripts | 112 | 0 | 112 | `<Stem>_Anim<N>Script` |
| B5 blocks holding several sprite structures | 34 | 0 | 34 | `<Stem>_ObjAnimData[_BB_AAAA]` |
| C keyboard tables (per-type flags, offsets, neighbour records, page-loader tables) | 25 | 0 | 25 | `Table_Kbd_*`, `Data_Kbd_T<n>_NeighbourRecords` |
| D1 fonts (27 glyph runs, 6 JIS banks, the 6x12 ASCII font) | 34 | 1 | 33 | `Font_GlyphRun_<SJIS>`, `GlyphFont_*` |
| D2 tilemaps reached through named word tables | 15 | 8 | 7 | `Tilemap_CommScene_TextBox<i>`, `Tilemap_SettingsPhone_*` |
| D3 individual small tables and scripts: dialog slide scripts 5, session-block templates 5, char-pair tables 4, blank help strings 3, attribute/caption blocks, item-string bank byte, connect-dialog messages 4 | 21 | 4 | 17 | `Data_Dialog_Open_SlideScripts`, `Data_<routine>_SessionBlockTemplate`, `Table_<routine>_CharPairs`, ... |
| **total** | **780** | **203** | **577** | |

Sprite data is the bulk (486 rows): the roughly 240 animation blocks that `naming2_g3_apps_a.md` listed under "Gaps" (loaded "by raw immediate `ld de,$6350`") turned out to be
reachable from 41 object tables by pointer chains (entry -> frame table -> records, entry -> script), so the immediate-to-label mapping is needed only for the handful of roots.

## Method

All of it is in `tools/data_consumers.py` (docstring = specification); `python3 tools/data_consumers.py --manifest M --inventory I --stats` regenerates everything from the tree plus
`build/mobile_trainer.sym`, the frozen region model and `config/xrefs.tsv`.

1. **Sites (immediate -> label, resolved by script).**  Every `ld bc|de|hl, imm16` in a `code` region (decoder and region model of `tools/xref_infer.py`) whose value is the address of a
   neutral data group, or lies inside one (an *interior* immediate), plus the `imm` rows of `config/xrefs.tsv`, is a candidate.  The target bank comes from the routine's own bank,
   from `ld a,$BB` / `farcall` within +-12 instructions, or from the xrefs row.  Statistics: **830 candidate immediates** (367 at a block start, 463 inside a block) ->
   **476 accepted** (tiles 189, tilemap 79, palette 64, object table 144) and 354 rejected (numbers that only look like addresses, other loaders, bank mismatch).  Of the 303
   accepted block-start sites 300 were already proven by `xrefs.tsv`; the raw-immediate scan adds 3 sites and 2 blocks (`Data_62_6100`, `Data_66_5EC0`), its main value is the
   *interior* immediates (next section).  221 groups have at least one accepted block-start site; 62 distinct named routines are the consumers.
2. **Load shape.**  For a site the straight-line window is walked (7 instructions back, forward to the first call, into the next decoded region when a blank line of the source
   splits the routine) and the last immediates of a/b/c/bc/de/hl are collected; the first call is the loader.  A site counts only when it has one of four shapes and the bank in `a`
   equals the bank of the target: `hl=label,a=bank,c=n,de=dest -> Gfx_StartHDMA[WithService]` (tiles, `n*16` bytes to VRAM `dest&$FFF0`, bank `dest&1`);
   `hl,a,bc=rows*cols,de -> Tilemap_CopyRectAndAttr[Ptr]`; `hl,a,bc=n,de=$D800..$D87F -> Palette_LoadToBuffer` (the staging buffer `$D800` = 8 BG palettes, `$D840` = 8 OBJ palettes:
   `Palette_UploadBuffer` 4F:404B copies `$D800` to BG palette RAM and `$D840` to OBJ palette RAM); `de=label,a=bank,hl=slot -> Sprite_InitSlot`.
3. **Screen token.**  The consumer is the enclosing *named* routine; the screen token is its name without the verb component (`Setup`, `Draw`, `InitScreen`, `StateInit`,
   `MenuInit`, ...).  The consumers of *all* sites of a block, block-start and interior, must agree: one token, or an explicit family (`FAMILY` in the tool: `AddrBookShared`,
   `PhoneKeypadAndComment`, `Account_ConfirmScreens`, `ConfirmPages`, `MailServerDeleteMethod`, ...), or the keyboard rule (one `Kbd_*` token plus screens that host the keyboard).
   Otherwise the block gets a HYPOTHESIS row.  Loaders that sit in neutral `Label_55_xxxx` jump targets of the keyboard page loader are attributed through the dispatch tables
   (`Kbd_LoadPageGraphics_TypeTable` by `wKbdType`; for types 6 and 7/8 a second dispatch by `wKbdPage`): `Gfx_Kbd_T6_Page2_Tiles8C00Vb1`.  `Table_Kbd_PagePointers` (55:4014)
   lists four text pages for type 6 (`Data_Kbd_Page_T6_*`) and four for types 7/8 (`Data_Kbd_Page_T78_*`), as many as the two loader tables have, and both are selected by `wKbdPage`;
   the names nevertheless carry only the page *index*, the pairing of graphics page and text page is not claimed.
4. **Sprite structure.**  `Sprite_LoadObjectEntry` (00:0AB8) reads word0/word1 of the 4-byte entry `DE + 4*(A&$7F)` as frame-table and script pointer; `Sprite_StepAndDrawSlot`
   (00:0AE8) adds `2*frame index` to the frame-table pointer, reads a record (`count`, then `count` x (y, x, tile, attribute) added to the slot position, loop at 00:0B9D) and takes the
   frame index / delay pairs of the script (`count`, then pairs).  The tool parses the object table, reads the targets **from the ROM bytes** and names a block only when it tiles
   exactly: table extent = `2 x words`, record = `1 + 4*count`, script = `1 + 2*count` (up to 3 trailing or padding bytes of the region are reported in the note);
   a group that holds several structures and starts with animation data is `<Stem>_ObjAnimData`.  Independent check run for the whole pass: for all 880 (entry, frame table, script)
   combinations of the 41 roots every frame index of the script is smaller than the length of the frame table (0 violations).  `<N>` is the entry index, or the number of an
   existing `..._Anim<N>Frames` name (`ConnIcon_Anim1Frames`, `CommNotice_Anim0Frames`).  Roots: 30 already named (`MailResult_ObjTable`, `Table_Profile_Anims`, ...) and 11 named here
   (`TopMenu_ObjTable`, `Kbd_ObjTable`, `ConnectDialog_ObjTable`, `ConfirmPages_ObjTable`, `AddrBookShared_ObjTable`, `MailServerDeleteMethod_ObjTable`, `SettingsMenu_ObjTable`,
   `SettingsPhone_ChoiceMenu_ObjTable`, `SettingsPhone_SlotMenu_ObjTable`, `CommPanel_ObjTable`, `Registration_DeleteExecute_ObjTable`; Sprite_InitSlot sites of named routines).
5. **Individual tables** (`rules_manual`): each row cites the routine that reads the table and the access pattern; byte contents are asserted in the code (a wrong assumption stops the run).
6. **Names** follow the neighbours of each family: graphics `Gfx_<Screen>_Tiles<VRAM>` (`STYLE.md`; `Vb1` for VRAM bank 1 as in `Gfx_CommNotice_B_Tiles9000Vb1`; a collision or a
   block uploaded to different addresses gets `_BB_AAAA`), sprite blocks prefix-first as in `ConnIcon_Anim1Frames` / `PageListProto_ObjAnimData`, tables `Table_<Subsystem>_<What>`.

## What the evidence looks like (examples)

| old | new | status | evidence in short |
|---|---|---|---|
| `Data_1E_49A0` | `Gfx_TopMenu_Tiles8000` | CONFIRMED | `TopMenu_Run+51`: `hl=label a=$1E c=$40 de=$8000 -> Gfx_StartHDMAWithService`, 1024 bytes; xrefs row CONFIRMED (executed, target read) |
| `Palette_1E_62E0` | `Palette_TopMenu_Obj` | CONFIRMED | `TopMenu_Run+104`: `bc=$0040 de=$D840 -> Palette_LoadToBuffer`; `$D840` = OBJ half of the buffer |
| `Data_5F_4000` | `Gfx_Kbd_T9_Tiles8800Vb1` | CONFIRMED | loaded by `Label_55_6A7E`, entry 9 of `Kbd_LoadPageGraphics_TypeTable` (indexed by `wKbdType`); `de=$8801` |
| `Data_28_4BD0` | `Gfx_AddrBookShared_Tiles8000` | CONFIRMED | three consumers with the same arguments: `AbookList_SetupScreen`, `AddrPick_InitScreen`, `SaveSenderAddr_InitScreen` |
| `Palette_26_7AC0` | `Palette_Profile_Obj` | CONFIRMED | `Profile_InitScreen`: `ld hl,Palette_26_7AC0 ; a=$26 ; bc=$40 ; de=$D840`, next to `Palette_Profile_Bg` for `$D800` |
| `Tilemap_4D_5B6C` | `Tilemap_SettingsPhone_ChoiceMenu_Entry1` | PROBABLE | word 1 of `SettingsPhone_ChoiceMenu_TilemapTable` (numeric words, bank from `ld a,$4D`); the loader indexes it by `[wRam_C27D]`; 140 bytes = 14x5x2 |
| `Table_24_7C36` | `MailResult_Anim4Frames` | PROBABLE | word0 of entry 4 of the named `MailResult_ObjTable`; 1 word -> record; extent 2 bytes; script frame indices fit |
| `Data_69_48C5` | `ConnIcon_Anim2Frame0` | PROBABLE | record 0 of the named `ConnIcon_Anim2Frames`; count 7 -> 29 bytes = the group |
| `Data_55_6E9F` | `Table_Kbd_TypeHasPages_ByType` | PROBABLE | `Kbd_TypeHasPages`: `ld hl,table ; add a,l ... ld a,[hl] ; ret`, A = keyboard type; 11 bytes = the 11 types |
| `Data_55_62A0` | `Table_Kbd_CursorSpriteOrigin` | PROBABLE | `Kbd_UpdateCursorSprite` 55:6190: `[table+2*wKbdType]` -> C, B; `wKbdCursorSpriteY = row*16 + C`, `wKbdCursorSpriteX = col*8 + B` |
| `Data_72_43A1` | `Data_Dialog_Open_SlideScripts` | CONFIRMED | two 3-byte scripts (`48 00 80`, `58 00 80`) loaded by `Dialog_Open` (`$43A1` and raw `$43A4`) before `farcall Dialog_SlideIn`, reader stops at `$80` |
| `Font_48_5BEB` | `Font_GlyphRun_818F` | PROBABLE | record 11 of `Font_GlyphRunTable` (key `$818F`, bank `$48`, pointer `$5BEB`); 2 glyphs x 16 bytes |
| `Data_7B_4000` | `GlyphFont_Jis12x12_7B` | PROBABLE | `GlyphFont_RowBankTable` maps JIS rows 34-42 to bank `7B`; 9 x 94 x 18 = 15,228 bytes = the block |
| `Data_76_67A8` | `GlyphFont_Ascii6x12` | CONFIRMED | `Glyph_AsciiAddr` returns `$67A8 + (c-$20)*12`, A=`$76`; 96 x 12 = 1,152 bytes = the block |
| `Data_23_4B4A` | `Data_MailSrvDel_DeleteAll_Confirm_SessionBlockTemplate` | PROBABLE | 7 bytes copied to `$D624` (`wMailSessionBlock`) by the loop in `MailSrvDel_DeleteAll_Confirm`, then `farcall ConnectDialog_Run`; five byte-identical copies, fields not decoded |

## Sharing, interior loads and other traps (what the verifiers of the earlier passes found, applied here)

* **Interior immediates decide sharing.**  A block that is entered at a row (`ld de,$5220` = `Table_28_5210 + 16`) belongs to its other consumers as well.  This changed or blocked
  names: `Table_28_5210` is `AddrBookShared_ObjTable`, not `AbookList_...` (also entered by `SaveSenderAddr_RefreshSlotIcons`, 6 sites); `Table_28_6E80` joins the delete-menu *and*
  delete-confirm routines (`MailServerDeleteMethod_ObjTable`); `Palette_5F_4CD0` (first 16 bytes loaded by `Kbd_Open`, interior parts by the seven confirm pages) and `Data_5F_49D0` (eight
  consumers) stay neutral; `Data_5E_4D00` (eight screens) and `Data_5E_4000/4400` stay neutral.  Without this pass `Palette_Kbd_Bg6` would have been a wrong, over-specific name.
* **Twin claims** are made only for bytes, and only after comparing all of them (`SessionBlockTemplate` x5, `CharPairs` x4, the `Data_54_*` descriptors).  No code-twin is claimed.
* **Addresses**: every name is attached to the exact start of the group (the old name encodes it; `sym_check` agrees); interior immediates never name the block they point into.
* **Dual use** is reported, not resolved: `Data_4D_5510` is loaded as a palette (`bc=$40 de=$D800`, executed) *and* as 768 bytes of tiles (`c=$30 de=$9401`, executed); its first 16
  bytes are valid RGB555 words (`0000 0000 0000 7FFF 0000 414A 4273 7FFF`) and from +$30 on it looks like tilemap indices, so the tile typing of the header is doubtful
  (HYPOTHESIS row).  `Data_70_6490/6690/6890` (CommScene): the pool 6490-6C90 is uploaded in overlapping pieces (512 and 1024 bytes) to different VRAM addresses, so no VRAM-address
  name is supported (HYPOTHESIS rows).
* **A typed-as-tiles block that is an object table**: `Data_4A_68D0` (80 bytes, header `tiles-2bpp: heuristic`) is the `de` of `Sprite_InitSlot` in `AdapterCheck_DrawScreen`; its first
  16 bytes are four 4-byte entries whose pointers all fall inside the block.  Named `AdapterCheck_ObjTableAndAnimData` (PROBABLE) with the contradiction written into the row; the
  region header is unchanged.
* **Blocks that straddle**: a multi-structure block is named `_ObjAnimData` only when it starts with animation data (one entry target is its first byte, or its header says
  animation/sprite/object).  `Data_73_5E38` (palette tail + records, `naming2_g2` HYPOTHESIS), `Data_73_5EC0` (starts inside a script) and `Data_72_4E44` are therefore left alone.

## Corrections to earlier notes

* `naming2_g3_apps_a.md`/`g3_apps_a_renames.tsv` left `Palette_26_7AC0` as HYPOTHESIS ("more than one consumer: Profile_* and bank 27 `ld de,$7AC0`").  The bank-27 immediate is
  `Sprite_InitSlot` with `A=$27` (an object table in bank 27), not a load of 26:7AC0; the only consumer is `Profile_InitScreen`.  Named here (`Palette_Profile_Obj`, CONFIRMED).
* `g4_apps_b_renames.tsv` ideas for `Table_55_6869` (`..._Type6PageTable`) and `Table_55_697C` (`..._Type9PageTable`): the dispatch through `Kbd_LoadPageGraphics_TypeTable` shows
  that the handler of `Table_55_697C` (`Label_55_696B`) serves **types 7 and 8**; type 9 is `Label_55_6A7E`.  Named `Table_Kbd_T6_PageLoaders` / `Table_Kbd_T78_PageLoaders`; the
  fourth word of each (`Table_55_686F`, `Table_55_6982`) is kept as a separate row (`..._Page3`) because the labels are separate in the source, the address adjacency is the evidence.
* `naming2_g3` (Gaps) "about 240 sprite blocks ... consumers load them by raw immediate": see the section above; the mapping is by pointer chains, verified against the ROM bytes.

## Left neutral, and why (901 groups + 15 HYPOTHESIS rows)

| why | groups | notes |
|---|---:|---|
| no static reference at all | 572 | Data 290, String 104, Table 66, Tiles 52, Palette 30, Tilemap 26, Attrmap 4: the never-executed picture banks 41-47, the tile areas of banks 58/5B/60 (no load site), font rows, padding, interior parts of larger blocks, object-table roots with no accepted load site (`Table_29_6290`: only a `ld hl,$6290` in bank 2D whose bank is not shown; the bank-70 animation tables `Table_70_4832/4C5C/4DBB/5272`: no immediate at all) |
| referenced only by `dw` words of other neutral or unnamed tables | 248 | the frame tables, records and scripts below such roots, message continuation lines of the dialog pointer table, keyboard page rows |
| a load site exists but the consumer is a neutral routine, or the shape is not one of the four | 81 | `Function_24_42B0`, `Label_54_4A12`, `Function_2B_6CF5`, the bank-54 descriptors (`Data_54_475A/4C35/4C3D/4C44/4FC3/4FCB`, HYPOTHESIS rows: copied to `$C240`, fields not decoded), `Function_55_6EAA/6EC0/6EEC` (their 11-byte per-type tables `Data_55_6EB5/6ECB/6EF7` stay neutral), loose raw-immediate false positives (`Table_2A_5220`, `Tilemap_47_65A0`, `Data_4C_430A`) |

Explicitly skipped families: the split string fragments (`String_24_4B21..4BC3`, the continuation lines of the 72:502B dialog records, the keyboard page rows `String_55_*`, the bank-6C
help-script message records); the `Data_` blocks "read as data by executed code, class unknown" without a consumer; the six HelpMenu box tilemaps `Tilemap_6A_4870..4DD4` (two are
loaded by `HelpMenu_ShowPage` through offsets into the block, the roles of the others are not shown); `Table_70_40B3/40C7` (code-pointer tables below `CommScene_KindTable`,
dispatch semantics not decoded); `BrowserMenu_TwoItemRecords` / `ThreeItemRecords` children (the string words are caption-like, the record layout `dw,db,dw,dw` is only partly decoded).

## Gaps and open questions

* Screen tokens come from the names that earlier passes gave the consumer routines; if one of those is renamed, the `Gfx_/Tilemap_/Palette_` names derived from it should follow.
* The sprite names say where a block sits in the structure (`Anim<N>`), not what it shows; `N` is the entry index of the object table, whose meaning (object id / state) is per screen and
  not decoded.  A frame record that two frame tables share is named after the first table that references it (none found in this pass).
* `Table_Kbd_*_ByType` tables have one byte per keyboard type 0..10; the meaning of the flags is only what the helper's name says.
* The banks 41-47 picture blocks and the bank-70 animation tables need a consumer search through the pointer tables that index them.

## Reproduce

```
make
python3 tools/data_consumers.py --manifest analysis/naming2/data2_renames.tsv --inventory /tmp/data2_inventory.tsv --stats   # regenerates the manifest, byte-identical
python3 tools/apply_renames.py --manifest analysis/naming2/data2_renames.tsv --strict                                          # in a private copy; SHA-256 must stay OK
```
