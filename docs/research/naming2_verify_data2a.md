# Naming pass 2, data2: adversarial verification of the graphics and table share (data2a)

Scope: 294 applied rows of `analysis/naming2/data2_renames.tsv` (naming pass `naming2_data2.md`), the **graphics and table families**:
135 tile blocks `Gfx_<Screen>_Tiles<VRAM>[Vb1]`, 61 tilemaps (46 loaded by `Tilemap_CopyRectAndAttr[Ptr]`, 15 reached through word tables), 18 palettes, 25 keyboard tables,
34 fonts (27 `Font_GlyphRun_*`, 6 `GlyphFont_Jis12x12_*`, `GlyphFont_Ascii6x12`), 21 small tables (session-block templates, char-pair tables, dialog/browser slide scripts, ...).
The sprite families (object tables, frame tables, records, scripts) belong to the other share (`naming2_verify_data2b.md`).
Fixes: [`analysis/naming2/verify_data2a_fixes.tsv`](../../analysis/naming2/verify_data2a_fixes.tsv) (7 renames; in a private copy of the tree
`python3 tools/apply_renames.py --manifest analysis/naming2/verify_data2a_fixes.tsv --strict` prints `7 row(s): 7 applied, 0 refused` and `SHA-256 OK 6d802e66...76570, sym_check OK`).
Verifier stance: try to refute every name; the evidence column was not trusted, the code at the label and the ROM bytes were re-read.

## Method

* **Loader arguments recomputed independently** (a script written for this check, not the pass's tool): for each of the 135 tile blocks every `ld hl,<label>` in the source (all
  `.asm`, label and alias) was followed to its call; `de`, `a`, `c` come from the `ld` instructions of the same straight-line window. Destination = `$8000 | (d & $1F) << 8 | (e & $F0)`,
  VRAM bank = `e & 1`, bytes = `c * 16` (this is what `Gfx_StartHDMA[WithService]` 00:0749/0787 does with `rHDMA3/4/5`, `rVBK`; read there). Compared with `Tiles<VRAM>[Vb1]`, with
  the bank in the old name (`a`) and with the size of the block in `config/regions/`. Result: **0 mismatches in address, bank or VRAM bank over 147 load sites**.
* **Dynamic cross-check of the loads**: `traces/detail/*/hwregs.tsv` aggregates the `rHDMA1..5` writes of the 64 scenarios. For every one of the 147 sites the five values derived from
  the arguments (`h`, `l`, `d`, `e & $F0`, `c - 1`) occur together in at least one scenario (also for the two raw-immediate loads `ld hl,$6100` / `$5EC0`). This is weak evidence
  (value sets, not pairs) but independent of the static derivation.
* **Execution**: every load site of a CONFIRMED row was looked up in `analysis/coverage_union.tsv` (executed, count, scenarios); every tilemap and palette block was looked up in
  the ROM-read ranges of `traces/detail/*/dataaccess.tsv` (the copy loops read the bytes with the CPU). Tile blocks go through HDMA and have no CPU reads.
* **Consumers**: every reference (and every raw `ld hl,<imm>` with `a` = bank before an HDMA / `Tilemap_CopyRectAndAttr[Ptr]` / `Palette_LoadToBuffer` call) was mapped to the block that contains
  it, start or interior; the set of enclosing routines was compared with the screen token of the name.
* **Palettes**: `Palette_UploadBuffer` (4F:404B) is called with `hl=$D800` (8 palettes, `rBCPS`) and adds `$40` for `rOCPS`; so `$D800+8n` = BG palette n, `$D840+8n` = OBJ palette n.
  The index in `Palette_*_Bg6` (`de=$D830`), `..._Obj4` (`de=$D860`), `..._Bg1` (`de=$D808`) and the Bg/Obj polarity of all 18 rows were recomputed from `de`: all correct. Every palette is
  valid RGB555 (all words < $8000).
* **Tilemaps**: rows x cols from `bc` (`B` rows, `C` cols; `Tilemap_CopyRect` 00:0904), size `2*rows*cols` = tiles then attributes (attributes go to `DE+$400`, `Tilemap_CopyRectAndAttr`
  00:08EA; the `Ptr` variant 00:16A2 takes the attribute source from `[$C10E]`). All 61 extents agree with the block extent, except `..._ConnectConfirm_56_526A` (label block 86 bytes, load 80, the
  pass noted it).
* **Fonts**: `Glyph_KuTenAddr` (7F:40B9) arithmetic was re-implemented (bank = `GlyphFont_RowBankTable[ku-1]`, address = `$4000 + ((ku - RowFirst[ku-1])*94 + ten-1)*18`; 18 bytes = 12x12 bits
  packed, unpacked by `Glyph_UnpackWideHalves` 00:0E32 in groups of 3 bytes = 2 rows) and the glyphs of JIS characters picked from every bank were **rendered and looked at**
  (PNG). `Font_BlitGlyph8x16` (48:4748) lookup was re-read (descending keys, first key <= code wins, `16*(code-key)` bytes) and all 27 runs were rendered in key order.
* **Block placement**: the `; BB:AAAA` comment of every label, the address in the old name and the address in the `INCBIN` file name of 244 labels were compared (0 off-by-one).
* Private build of the unmodified tree: `RESULT: IDENTICAL`.

## Result

| family | rows | upheld (name) | renamed | refuted | status raised | status lowered |
|---|---:|---:|---:|---:|---:|---:|
| tile blocks `Gfx_*` | 135 | 135 | 0 | 0 | 5 (see below) | 0 |
| tilemaps | 61 | 61 | 0 | 0 | 7 | 1 |
| palettes | 18 | 18 | 0 | 0 | 1 | 0 |
| keyboard tables | 25 | 25 | 0 | 0 | 4 | 0 |
| fonts | 34 | 34 | 0 | 0 | 25 | 0 |
| small tables | 21 | 14 | 7 | 0 | 1 | 0 |
| **total** | **294** | **287** | **7** | **0** | **43** | **1** |

No name was refuted outright; 7 were replaced by more honest ones (the consumer or structure part of the name was wrong), no address, bank, polarity, Bg/Obj or VRAM-bank error was found in the
graphics families. Status: the pass under-claimed (43 rows have execution / read evidence that the pass did not use), it over-claimed once.

## Renames (in `verify_data2a_fixes.tsv`)

| old | new | why |
|---|---|---|
| `Data_HelpMenu_ItemStringBank` | `Table_HelpMenu_LockedItemTicker` (PROBABLE) | The evidence says `HelpMenu_ShowItemText` reads the byte with `ld a,[hl]`; there is no such read. The label is passed **as HL** to `Ticker_Start` (48:42D4), which reads the first byte with `ReadByteFar` (text bank, `wTickerTextBank`) and then indexes 4-byte entries with `B`: the label is the base of a ticker table ([bank byte][entries 6A:6652..6672]). The routine picks this table instead of `$64B2` (same layout, byte 6A then d3 64 e6 64) when `HelpMenu_ItemIsLocked` returns `$FF`, and its strings are the `????` placeholders. The 1-byte label extent is unchanged (entries stay in the neutral `Table_6A_6652/665E/666A`). Byte 6A:6651 is read in 3 scenarios, so the locked branch ran. |
| `Data_Dialog_Open_SlideScripts` | `Data_Dialog_OpenAndOpenTall_SlideScripts` | The second script (`$43A4`) is loaded by `Dialog_OpenTall` (72:41D8, dialog.asm:338, `rWY` compare `$38`), not by `Dialog_Open` (first script, `rWY` compare `$48`). Both call `Dialog_SlideIn`. CONFIRMED stays (all 6 bytes read in 17 scenarios). |
| `Data_Dialog_Close_SlideScripts` | `Data_Dialog_CloseAndCloseTall_SlideScripts` | same: `$4575` (dialog.asm:599) is in `Dialog_CloseTall`; `Dialog_Close` loads the label. |
| `Table_Profile_ApplyVu_CharPairs`, `Table_MailTitle_ApplyVu_CharPairs`, `Table_MailBody_ApplyDakutenU_CharPairs`, `Table_AbookName_ApplyDakutenU_CharPairs` | `..._LoopPairs` (PROBABLE) | The four routines are byte-identical code (checked): they load `B,C` from the 5 bytes `82 A4 82 A4 00` two at a time until a first byte of 0, but **B and C are never compared with the text**: the test is hard-wired (`cp $83` on `[HL]`, `cp $45` on `[HL+1]`, then `ld [hl],$94`, i.e. `8345 -> 8394`); `HL` is saved and restored around every iteration, after a match the pair is popped and discarded. The table only sets an iteration count of 2. "CharPairs" asserted compared character pairs, which nothing shows. "Two-byte entries, 0 terminator" is what the code proves, hence `LoopPairs`. The byte identity of the four copies is true (compared). |

## Status corrections (the manifest rows were not edited; source comments carry no per-name status)

### Raised PROBABLE -> CONFIRMED (evidence that the pass did not use)

| names | evidence |
|---|---|
| `Gfx_Account_ConfirmManualScreen_Tiles9000Vb1`, `Palette_Account_ConfirmManualScreen_Bg`, `Tilemap_Account_ConfirmManualScreen` | `Account_ConfirmManualScreen_Setup` (68:6451) and its sites 68:6491 / 64B8 / 64DA are in `coverage_union.tsv` (10 executions, 2 scenarios, first `monkey_camp_hidman`); the 720 tilemap bytes and the 64 palette bytes are read in `dataaccess.tsv`. `config/xrefs.tsv` still marks the three rows PROBABLE (older trace set). |
| `Gfx_Account_ConfirmScreens_Tiles8800Vb1`, `..._Tiles8C00Vb1` | both load sites are executed: 68:622F / 6241 (`Account_ConfirmScreen_Setup`) and 68:646D / 647F (`Account_ConfirmManualScreen_Setup`, see above). |
| `Gfx_Kbd_T78_Page3_Tiles8800Vb1`, `Gfx_Kbd_T6_Page3_Tiles8800Vb1` | raw immediates `ld hl,$6100` / `$5EC0` (55:6A32, 55:691F) with `ld a,$62` / `$66`, `de=$8801`, `c=$40`: executed in 5 and 3 scenarios (`coverage_union.tsv`), the same handlers that load the two CONFIRMED sibling blocks. The region headers still say "never executed". |
| `Tilemap_SettingsPhone_ChoiceMenu_Entry0..3`, `Tilemap_SettingsPhone_SlotMenu_Tab0`, `Tab1` | the 140 / 80 bytes of each block are read in `dataaccess.tsv` (scenarios `settings_phone`, `fuzz_register`, `register_hidden*`, `monkey_camp_*`); the loaders are executed. `Tab2` was never read: stays PROBABLE. |
| `GlyphFont_Jis12x12_7A`, `GlyphFont_Jis12x12_7B` | 13 and 39 distinct ROM-read ranges in 34 scenarios, **all 18-byte aligned** (`(start-$4000) % 18 == 0`, length multiple of 18), the addresses are the ones `Glyph_KuTenAddr` computes; rendered glyphs of rows 34-51 are the expected kanji. `_76` (JIS part), `_77`, `_78`, `_79` are never read in any trace: stay PROBABLE (arithmetic + rendering only; rendering was checked for all six banks). |
| 23 of 27 `Font_GlyphRun_*` (all except `8168`, `817E`, `8189`, `818F`) | ROM bytes read in 1..50 scenarios inside the run (`dataaccess.tsv`); the table lookup loop (48:4777) is executed; every run was rendered and matches the Shift-JIS symbols of its key (punctuation, digits, Latin, hiragana, katakana; see notes). The four never-read runs also render correctly but are static only: stay PROBABLE. |
| `Data_BrowserMenu_OpenTwoItem_SlideScript` | the manifest says the load site was not executed; the 13 bytes are read in scenario `settings_cgi` (`dataaccess.tsv`), i.e. the script reader ran. |
| `Table_Kbd_T6_PageLoaders_Page3`, `Table_Kbd_T78_PageLoaders_Page3`, `Table_Kbd_T6_PageLoaders`, `Table_Kbd_T78_PageLoaders` | the dispatch `ld hl,<table> ; add a,a ... ld a,[hli] ; ld h,[hl] ; ld l,a ; jp hl` is executed (55:6858 / 696B, reads 100% of the words in 10 / 20 scenarios); `Label_55_691C` / `6A2F` have no other reference and are executed (3 / 5 scenarios), so the fourth word is read and jumped through. |

The other keyboard tables (`*_ByType`, cursor/marker positions, neighbour records ...) are also read in many scenarios, but their names contain interpretation that the reads do not prove (what
the flag means, which axis), so no status change is proposed: the mechanical part (what the code does with the bytes) is CONFIRMED by execution, the semantic part of the name stays PROBABLE.

### Lowered

| name | manifest | corrected | reason |
|---|---|---|---|
| `Tilemap_CommScene_TextBox7` | CONFIRMED | PROBABLE | `CommScene_ShowTextBox` (70:4803) indexes `CommScene_TextBoxMaps` with A; the blocks `TextBox0..6` are read in the 64 scenarios (`dataaccess.tsv`, scenarios `browser_*`, `fuzz_browser*`, `monkey_camp_*`), `TextBox7` (70:74F0-7590) is never read; the index mapping is static (`dw`), the 160-byte 20x4 content was never observed. |

## Upheld: what was checked per family

**Tile blocks (135)**. Every name's VRAM address, `Vb1` and the bank of the old name agree with the loader immediates (table of all 135 in the private script output, not repeated here).
Screen tokens agree with the enclosing routines of the load sites, with the shared cases checked one by one (`AddrBookShared`: `AbookList_SetupScreen`, `AddrPick_InitScreen` = `Function_2C_58AC`, `SaveSenderAddr_InitScreen`,
no other bank-28 loader of these two blocks; `PhoneKeypadAndComment`; `ConnectDialog_PasswordEntryAndSaveConfirm`; `Account_ConfirmScreens`; `Registration_Delete` whose block is also entered by
`Registration_DeleteExecute_Setup` at interior offsets; `Kbd_T*` = entries of `Kbd_LoadPageGraphics_TypeTable` 55:66D9, indexed by `wKbdType`, read in `Kbd_LoadPageGraphics` 55:66C6: type 1 -> 6704, 4 -> 6755, 5 -> 679F,
6 -> 6858 (page dispatch by `wKbdPage`), 7 and 8 -> 696B, 9 -> 6A7E, 10 -> 6AC9; the page index in `Page<i>` is the index in `Table_Kbd_T6/T78_PageLoaders`). Raw-immediate loads that start exactly at one of
these blocks: only the two Page3 blocks above. Interior loads were listed (`Gfx_SettingsPhone_ChoiceMenu_Tiles8000Vb1` is also entered at +$110 by the same routine; `Gfx_PageListProto_Tiles9580Vb1`: see notes).
Rendered samples (`TopMenu` 8000, `Kbd_T4` 8800, `Notice` 9000, `CommScene` 8000, `SettingsMenu` 8000): picture tiles, keyboard glyphs, digits and kanji labels, a cursor arrow; nothing contradicts the names.
`ConnIcon_Request2`: `ConnIcon_LoadGraphicsIfRequested` (69:40D1) indexes `ConnIcon_GfxTable` with `wConnIconGfxRequest` via `JumpTableInline` (00:0545, index from 0), entry 2 = `Label_69_40E0`: correct.

**Tilemaps (61), palettes (18)**: sizes, destinations (`$D000`, `$D200`, `$D240`, `$D0E4`: the WRAM buffer the Gfx_UploadBgMapBuffers* routines push to VRAM), Bg/Obj and palette index as above.
`Tilemap_ConnectDialog_ConnectConfirm_56_526A` with `Tilemap_CopyRectAndAttrPtr`: the attribute source written to `$C10E/F` is `$5292` = `$526A + $28` (20x2 tiles = 40 bytes, then the attributes): consistent.
The six tilemaps of the Help menu that the pass deliberately skipped were not revisited.

**Fonts (34)**. All six JIS banks verified by rendering (`亜` 7D:4000, `日` 7B:60D6, `本` 7A:4426, `涸` 78:48DC, `團` 79:4048, `罍` 77:4024, `錙` 76:4000, `堯` 76:610C, ...): the address arithmetic reproduces the right glyph in
each bank. Rows 79-84 fit the 6 rows of bank 76 (6*94*18 = 10152 = `$67A8-$4000`); the table continues to row 87 but JIS X 0208 ends at row 84. `GlyphFont_Ascii6x12`: `Glyph_AsciiAddr` (7F:400E) =
`$67A8 + (c-$20)*12`, A=$76, 96*12 = 1152 = block; rendered: "Hello, World! 0123456789 @abc~\" shows `¥` for `\` and `‾` for `~` as the charmap says. The 27 runs: key order, pointers and
glyph counts agree with the ROM table (rendered: 8140 punctuation, 814F `^ ‾ _`, 815B long-vowel mark, 815E `/`, 8160 `~`, 8162 `|…`, 8165 quotes, 8168 closing quote, 8169 parentheses,
816D brackets, 8175 corner/lenticular brackets and `+ -`, 817E `x`, 8180 `÷ =`, 8183 `< >`, 8189 `♂ ♀`, 818F `¥ $`, 8193 `% # & * @`, 8199 `☆ ★ ○ ●`, 819E `◇ ◆ □ ■ △ ▲`, 81A6 `※ 〒 → ← ↑ ↓`, 81F4 `♪`,
824F digits, 8260 A-Z, 8281 a-z, 829F hiragana, 8340 katakana). **Note**: the five glyphs of `Font_GlyphRun_83BF` are dotted-box placeholders, not Greek letters; the name only carries the key, which is what the
evidence supports, so it stays (no claim about the content should be added).

**Keyboard tables (25)**. `Table_Kbd_NeighbourRecords` (55:4A42) has 10 words (types 0..9; types 7 and 8 share one block: same word twice), record = 6 bytes: `Kbd_MoveCursor` (55:5F66) indexes `cell*6`, reads bytes 0..3
by direction (`wKbdNeighbourCell`) and bytes 4, 5 as `wKbdNeighbourFlagsA/B`; block sizes 324/432/432/540x6 tile exactly up to 5BA2. `Table_Kbd_CursorSpriteOrigin`: `ld a,[hli] ; ld b,[hl] ; ld c,a` then
`E = row*16 + C`, `D = col*8 + B`: byte 0 is the vertical and byte 1 the horizontal origin. `Table_Kbd_PickerTabTilePtrs`: three pointers `$6A90 $6D10 $6F90` (bank `$66`, `de=$8801`, `c=$28` = 640 bytes: the three blocks tile up
to 66:7210). `Table_Kbd_TypeHasPages_ByType` (types 6, 7, 8) agrees with the page-dispatch table entries (6, 7, 8) independently of the helper name.

**Small tables (21)**. `SessionBlockTemplate` x5: the 7 bytes `03 00 00 01 24 D5 00` are identical in all five (compared), copied to `$D624` with `SVBK=1` and passed as `BC` with `D=1` to `ConnectDialog_Run` (checked in `delete_flows.asm`).
`Data_Abook_HelpBoxAttrBlocks`: `AbookList_SetHelpBoxAttr` (2F:4CA7) copies 20 bytes of the selected block to VRAM bank 1 `$99C0/$99E0` (BG attributes, `rVBK=1`) and to WRAM `$D5C0/$D5E0`. `Data_CommPanel_CaptionSetRecords`:
`CommPanel_DrawCaption` (68:7611) takes `[set + wCommPanelVariant]` as an index into `CommPanel_CaptionMaps` (8 maps of 4x12, stride $60, bank $71): correct. `String_MailServerMgr_HelpBlank0/4/5`: `MailServerMgr_ShowChoiceHelp` indexes with `A+1`,
so A = $FF selects string 0 (the blank one); the names are table indices. `String_ConnectDialog_Messages`: 6 strings (count verified in the source), `ConnectDialog_Draw_ConnectConfirm` renders the first with raw `ld hl,$4000`. `Data_BrowserMenu_*_SlideScript`: 12 x `$04` then `$80`, same reader as
the dialog scripts; `OpenThreeItem` and `Close` read in 6 / 7 scenarios.

## Evidence errors (name and status unaffected unless listed above)

| row | claim in the manifest | what the tree shows |
|---|---|---|
| `Data_Dialog_Open_SlideScripts` / `Close_SlideScripts` | both scripts loaded by `Dialog_Open` / `Dialog_Close` | the second one is loaded by `Dialog_OpenTall` / `Dialog_CloseTall` (renamed) |
| `Data_HelpMenu_ItemStringBank` | `HelpMenu_ShowItemText` reads it with `ld a,[hl]` | no such instruction; HL is passed to `Ticker_Start` (renamed) |
| `Table_*_ApplyVu/ApplyDakutenU_CharPairs` | entries are character pairs | `B,C` are not used (renamed) |
| `Tilemap_SettingsPhone_ChoiceMenu_Entry0..3` | "index = [wRam_C27D]" | `SettingsPhone_ChoiceMenu_LoadTilemap` (67:48F0) uses `C27D + 2` when `wRam_C27E != 0`, so the index is `C27D + 2*(C27E != 0)`; the entry numbers are table indices and stay correct |
| `Table_Kbd_PickerSpritePositions` | "two lists of 3 positions ... each passed to `Sprite_SetPosition`" | the table supplies only `E` (one coordinate); `D` is the immediate `$66` / `$5D`. The name says positions; it holds one coordinate of them (kept, the axis is not proven: `Sprite_SetPosition` stores D at +0 and E at +1, the cursor code writes the row-based value to +0) |
| `Data_Kbd_T78_NeighbourRecords` | "entryies 7 and 8" | typo; the facts are right |
| `Gfx_*` (37 rows, source block headers) | `[verifier: call site never executed in a trace -> PROBABLE]` | 34 of these rows are CONFIRMED in the manifest and their sites are in `coverage_union.tsv` (e.g. `Gfx_SettingsPhone_ChoiceMenu_Tiles8000Vb1`: 67:4780, 46 hits, 6 scenarios); the header comments in `gfx/**/*.asm` and `config/regions/` are stale (older 18-scenario trace set). Not edited here. |
| `Data_Kbd_*_NeighbourRecords` | block "tiles" as sized `$144,$1B0,...` | true, but `Data_Kbd_T0_NeighbourRecords` is mostly zeros and only 22% of its bytes (T0..T3: 15-24%) are read in any trace; "54 records" is an extent, not an observation |

## Observations that are not errors of this pass

* **Blocks longer than their loaded range / loaded range longer than their block** (name = start of the load; not wrong): `Gfx_Profile_Tiles8000` (label block 32 bytes, load 672 = up to `Palette_Profile_Obj` at 26:7AC0),
  `Gfx_AbookAddr_Tiles8800` (load 800, block 752, spills 48 bytes into the following tilemap), `Gfx_CommScene_Tiles9400Vb1` (load 1024, block 512: the second half is palette and tilemap, as the region header notes), and
  the same over-read for `Gfx_Account_ActionConfirmPage_Tiles9400Vb1` (palette at +$320 and tilemap at +$360 lie inside the 1024 loaded bytes), `Gfx_Account_LoginIdIntro_Tiles9400Vb1`, `Gfx_AdapterCheck_Tiles9400Vb1`,
  `Gfx_CommPanel_Tiles9400Vb1`, `Gfx_SettingsPhone_ContinuePrompt_*`: the HDMA length is larger than the tile data, the tail bytes are copied to VRAM but are not tiles.
* `Gfx_PageListProto_Tiles9580Vb1` (52:4080, PROBABLE): `PageListProto_ShowMessage` loads **four** 640-byte alternatives (4080, 4380, 4680, 4980) to the same `$9581`; the block is the default/case-3 one and three sets lie inside its 2944-byte
  region. The name is right for this set; a reader may take it for the only set.
* `Palette_HelpMenu_Bg`, `Palette_Registration_Delete_Bg`, `Palette_BrowserMenu_Bg6`: the label block (8 / 8 / 6 bytes) is shorter than the load (64 / 64 / 16); the rest is covered by other labels. `Palette_ConnectDialog_Bg` (192 bytes) is entered at +64 and +128 by
  the other ConnectDialog states (8 sites, 7 of them interior); the name is the family, not one state.
* `wMailSessionBlock` (`ram/banked.asm`, PROBABLE) documents `+0` as "send result (0, 1, 2, $FF)", but the template copied there by the delete flows starts with `$03`. Either `+0` is also an input (request kind) or the field
  description is incomplete; the template name only uses the block's name and does not depend on this.
* **Older `Tiles<VRAM>` names without `Vb1`** (outside this share, loaded with `e` odd = VRAM bank 1, so the name suggests bank 0): `Gfx_AbookName_Tiles9300/9700`, `Gfx_AbookView_Tiles9300/9700`, `Gfx_AddrPick_Tiles9300/9700`,
  `Gfx_AddrSaveConfirm_Tiles9300/9700`, `Gfx_AddrScreenUnused_Tiles9300`, `Gfx_CommTimeHMS_Tiles9000`, `Gfx_MailDraftMenu_Tiles9300`, `Gfx_MailGrid_Tiles9000/9400`, `Gfx_MailTitle_Tiles9300`, `Gfx_MailView_Tiles9000/9400`,
  `Gfx_Profile_Tiles9300`, `Gfx_SaveSenderAddr_Tiles9300` (18 names; dest recomputed from `de`, e.g. `Profile_InitScreen`: `ld de,$9301`). The address part is correct, the `Vb1` convention of this pass is not applied to them. Not
  renamed here (another pass owns them; `STYLE.md` does not mention `Vb1`).
* The Profile tiles load `$9701` from `ld hl,$6700` and `$8800` from `$6800` with raw immediates (interior of `Data_2A_6300`); not part of this share.

## Open questions left as they were

* The semantic part of the keyboard helper names (`NeedsExtraPalette`, `HidesOnKey82/83`, `WaitsWithService`, `GetSlideTargetY`) rests on the helper names of earlier passes; the tables only follow them.
* The content of the neighbour records (4 direction bytes + 2 flag bytes per cell is what `Kbd_MoveCursor` reads; the cell numbering is not decoded).
* `Font_GlyphRun_83BF` holds placeholder boxes; which codes of `$83BF..$83C3` the game emits was not traced.

## Reproduce

```
# private copy: rsync -a --exclude .git --exclude traces --exclude build ./ <scratch>/ ; copy 'Mobile Trainer (Japan).gbc' ; make
python3 tools/apply_renames.py --manifest analysis/naming2/verify_data2a_fixes.tsv --strict     # 7 applied, SHA-256 OK, sym_check OK
```
The checking scripts (loader recomputation, HDMA register cross-check, coverage and ROM-read lookup, glyph/run rendering) were throw-away files in the scratch directory and are not part of the repository.
