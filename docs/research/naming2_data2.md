# reference 2, data: consumers of the neutral DATA labels

## Inventory and result

Applied rows by family (C / P = CONFIRMED / PROBABLE):

The target bank comes from the routine's own bank,    from `ld a,$BB` / `farcall` within +-12 instructions, or from the xrefs row.

A site counts only when it has one of four shapes and the bank in `a`    equals the bank of the target: `hl=label,a=bank,c=n,de=dest -> Gfx_StartHDMA[WithService]` (tiles, `n*16` bytes to VRAM `dest&$FFF0`, bank `dest&1`);    `hl,a,bc=rows*cols,de -> Tilemap_CopyRectAndAttr[Ptr]`; `hl,a,bc=n,de=$D800..$D87F -> Palette_LoadToBuffer` (the staging buffer `$D800` = 8 BG palettes, `$D840` = 8 OBJ palettes:    `Palette_UploadBuffer` 4F:404B copies `$D800` to BG palette RAM and `$D840` to OBJ palette RAM); `de=label,a=bank,hl=slot -> Sprite_InitSlot`. 3.

**Sprite structure.**  `Sprite_LoadObjectEntry` (00:0AB8) reads word0/word1 of the 4-byte entry `DE + 4*(A&$7F)` as frame-table and script pointer; `Sprite_StepAndDrawSlot`    (00:0AE8) adds `2*frame index` to the frame-table pointer, reads a record (`count`, then `count` x (y, x, tile, attribute) added to the slot position, loop at 00:0B9D) and takes the    frame index / delay pairs of the script (`count`, then pairs).

**Individual tables** (`rules_manual`): each row cites the routine that reads the table and the access pattern; byte contents are asserted in the code (a wrong assumption stops the run). 6.

**Names** follow the neighbours of each family: graphics `Gfx_<Screen>_Tiles<VRAM>` (`STYLE.md`; `Vb1` for VRAM bank 1 as in `Gfx_CommNotice_B_Tiles9000Vb1`; a collision or a    block uploaded to different addresses gets `_BB_AAAA`), sprite blocks prefix-first as in `ConnIcon_Anim1Frames` / `PageListProto_ObjAnimData`, tables `Table_<Subsystem>_<What>`.

| old | new | status |
| --- | --- | --- |
| `Data_1E_49A0` | `Gfx_TopMenu_Tiles8000` | CONFIRMED |
| `Palette_1E_62E0` | `Palette_TopMenu_Obj` | CONFIRMED |
| `Data_5F_4000` | `Gfx_Kbd_T9_Tiles8800Vb1` | CONFIRMED |
| `Data_28_4BD0` | `Gfx_AddrBookShared_Tiles8000` | CONFIRMED |
| `Palette_26_7AC0` | `Palette_Profile_Obj` | CONFIRMED |
| `Tilemap_4D_5B6C` | `Tilemap_SettingsPhone_ChoiceMenu_Entry1` | PROBABLE |
| `Table_24_7C36` | `MailResult_Anim4Frames` | PROBABLE |
| `Data_69_48C5` | `ConnIcon_Anim2Frame0` | PROBABLE |
| `Data_55_6E9F` | `Table_Kbd_TypeHasPages_ByType` | PROBABLE |
| `Data_55_62A0` | `Table_Kbd_CursorSpriteOrigin` | PROBABLE |
| `Data_72_43A1` | `Data_Dialog_Open_SlideScripts` | CONFIRMED |
| `Font_48_5BEB` | `Font_GlyphRun_818F` | PROBABLE |
| `Data_7B_4000` | `GlyphFont_Jis12x12_7B` | PROBABLE |
| `Data_76_67A8` | `GlyphFont_Ascii6x12` | CONFIRMED |
| `Data_23_4B4A` | `Data_MailSrvDel_DeleteAll_Confirm_SessionBlockTemplate` | PROBABLE |

* **Addresses**: every name is attached to the exact start of the group (the old name encodes it; `sym_check` agrees); interior immediates never name the block they point into.

* **Dual use** is reported, not resolved: `Data_4D_5510` is loaded as a palette (`bc=$40 de=$D800`, executed) *and* as 768 bytes of tiles (`c=$30 de=$9401`, executed); its first 16   bytes are valid RGB555 words (`0000 0000 0000 7FFF 0000 414A 4273 7FFF`) and from +$30 on it looks like tilemap indices, so the tile typing of the header is doubtful   (HYPOTHESIS row).

`Data_70_6490/6690/6890` (CommScene): the pool 6490-6C90 is uploaded in overlapping pieces (512 and 1024 bytes) to different VRAM addresses, so no VRAM-address   name is supported (HYPOTHESIS rows).

* **A typed-as-tiles block that is an object table**: `Data_4A_68D0` (80 bytes, header `tiles-2bpp: heuristic`) is the `de` of `Sprite_InitSlot` in `AdapterCheck_DrawScreen`; its first   16 bytes are four 4-byte entries whose pointers all fall inside the block.

Named `AdapterCheck_ObjTableAndAnimData` (PROBABLE) with the contradiction written into the row; the   region header is unchanged.

`Data_73_5E38` (palette tail + records, `naming2_g2` HYPOTHESIS), `Data_73_5EC0` (starts inside a script) and `Data_72_4E44` are therefore left alone.

* `naming2_g3_apps_a.md`/`g3_apps_a_renames.tsv` left `Palette_26_7AC0` as HYPOTHESIS ("more than one consumer: Profile_* and bank 27 `ld de,$7AC0`").  The bank-27 immediate is
  `Sprite_InitSlot` with `A=$27` (an object table in bank 27), not a load of 26:7AC0; the only consumer is `Profile_InitScreen`.  Named here (`Palette_Profile_Obj`, CONFIRMED).
* `g4_apps_b_renames.tsv` ideas for `Table_55_6869` (`..._Type6PageTable`) and `Table_55_697C` (`..._Type9PageTable`): the dispatch through `Kbd_LoadPageGraphics_TypeTable` shows
  that the handler of `Table_55_697C` (`Label_55_696B`) serves **types 7 and 8**; type 9 is `Label_55_6A7E`.  Named `Table_Kbd_T6_PageLoaders` / `Table_Kbd_T78_PageLoaders`; the
  fourth word of each (`Table_55_686F`, `Table_55_6982`) is kept as a separate row (`..._Page3`) because the labels are separate in the source, the address adjacency is the evidence.
* `naming2_g3` (Gaps) "about 240 sprite blocks ... consumers load them by raw immediate": see the section above; the mapping is by pointer chains, verified against the ROM bytes.

## Left neutral, and why (901 groups + 15 HYPOTHESIS rows)

Explicitly skipped families: the split string fragments (`String_24_4B21..4BC3`, the continuation lines of the 72:502B dialog records, the keyboard page rows `String_55_*`, the bank-6C
help-script message records); the `Data_` blocks "read as data by executed code, class unknown" without a consumer; the six HelpMenu box tilemaps `Tilemap_6A_4870..4DD4` (two are
loaded by `HelpMenu_ShowPage` through offsets into the block, the roles of the others are not shown); `Table_70_40B3/40C7` (code-pointer tables below `CommScene_KindTable`,
dispatch semantics not decoded); `BrowserMenu_TwoItemRecords` / `ThreeItemRecords` children (the string words are caption-like, the record layout `dw,db,dw,dw` is only partly decoded).

## Gaps and open questions

* `Table_Kbd_*_ByType` tables have one byte per keyboard type 0..10; the meaning of the flags is only what the helper's name says.

Each row was re-read at its load site: the `de` immediate is `$9301`, `$9701`, `$9001` or `$9401` and the address in the name equals `de & $FFF0`.

`gfx/assets.tsv` (status column of 153 asset rows) and `gfx/README.md` (regenerated by `tools/gfx_export.py readme`, which also fixed older drift of its text and of the "Still `db`" table) follow the headers.
