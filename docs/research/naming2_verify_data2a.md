# reference 2, data2: adversarial reference of the graphics and table share (data2a)

## Result

| old | new | why |
|---|---|---|
| `Data_HelpMenu_ItemStringBank` | `Table_HelpMenu_LockedItemTicker` (PROBABLE) | The evidence says `HelpMenu_ShowItemText` reads the byte with `ld a,[hl]`; there is no such read. The label is passed **as HL** to `Ticker_Start` (48:42D4), which reads the first byte with `ReadByteFar` (text bank, `wTickerTextBank`) and then indexes 4-byte entries with `B`: the label is the base of a ticker table ([bank byte][entries 6A:6652..6672]). The routine picks this table instead of `$64B2` (same layout, byte 6A then d3 64 e6 64) when `HelpMenu_ItemIsLocked` returns `$FF`, and its strings are the `????` placeholders. The 1-byte label extent is unchanged (entries stay in the neutral `Table_6A_6652/665E/666A`). Byte 6A:6651 is read in 3 scenarios, so the locked branch ran. |
| `Data_Dialog_Open_SlideScripts` | `Data_Dialog_OpenAndOpenTall_SlideScripts` | The second script (`$43A4`) is loaded by `Dialog_OpenTall` (72:41D8, dialog.asm:338, `rWY` compare `$38`), not by `Dialog_Open` (first script, `rWY` compare `$48`). Both call `Dialog_SlideIn`. CONFIRMED stays (all 6 bytes read in 17 scenarios). |
| `Data_Dialog_Close_SlideScripts` | `Data_Dialog_CloseAndCloseTall_SlideScripts` | same: `$4575` (dialog.asm:599) is in `Dialog_CloseTall`; `Dialog_Close` loads the label. |
| `Table_Profile_ApplyVu_CharPairs`, `Table_MailTitle_ApplyVu_CharPairs`, `Table_MailBody_ApplyDakutenU_CharPairs`, `Table_AbookName_ApplyDakutenU_CharPairs` | `..._LoopPairs` (PROBABLE) | The four routines are byte-identical code (checked): they load `B,C` from the 5 bytes `82 A4 82 A4 00` two at a time until a first byte of 0, but **B and C are never compared with the text**: the test is hard-wired (`cp $83` on `[HL]`, `cp $45` on `[HL+1]`, then `ld [hl],$94`, i.e. `8345 -> 8394`); `HL` is saved and restored around every iteration, after a match the pair is popped and discarded. The table only sets an iteration count of 2. "CharPairs" asserted compared character pairs, which nothing shows. "Two-byte entries, 0 terminator" is what the code proves, hence `LoopPairs`. The byte identity of the four copies is true (compared). |

The other keyboard tables (`*_ByType`, cursor/marker positions, neighbour records ...) are also read in many scenarios, but their names contain interpretation that the reads do not prove (what
the flag means, which axis), so no status change is proposed: the mechanical part (what the code does with the bytes) is CONFIRMED by execution, the semantic part of the name stays PROBABLE.

## Upheld: what was checked per family

Screen tokens agree with the enclosing routines of the load sites, with the shared cases checked one by one (`AddrBookShared`: `AbookList_SetupScreen`, `AddrPick_InitScreen` = `Function_2C_58AC`, `SaveSenderAddr_InitScreen`, no other bank-28 loader of these two blocks; `PhoneKeypadAndComment`; `ConnectDialog_PasswordEntryAndSaveConfirm`; `Account_ConfirmScreens`; `Registration_Delete` whose block is also entered by `Registration_DeleteExecute_Setup` at interior offsets; `Kbd_T*` = entries of `Kbd_LoadPageGraphics_TypeTable` 55:66D9, indexed by `wKbdType`, read in `Kbd_LoadPageGraphics` 55:66C6: type 1 -> 6704, 4 -> 6755, 5 -> 679F, 6 -> 6858 (page dispatch by `wKbdPage`), 7 and 8 -> 696B, 9 -> 6A7E, 10 -> 6AC9; the page index in `Page<i>` is the index in `Table_Kbd_T6/T78_PageLoaders`).

Interior loads were listed (`Gfx_SettingsPhone_ChoiceMenu_Tiles8000Vb1` is also entered at +$110 by the same routine; `Gfx_PageListProto_Tiles9580Vb1`: see notes).

Rendered samples (`TopMenu` 8000, `Kbd_T4` 8800, `Notice` 9000, `CommScene` 8000, `SettingsMenu` 8000): picture tiles, keyboard glyphs, digits and kanji labels, a cursor arrow; nothing contradicts the names.

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

## Observations that are not errors of this pass

* **Blocks longer than their loaded range / loaded range longer than their block** (name = start of the load; not wrong): `Gfx_Profile_Tiles8000` (label block 32 bytes, load 672 = up to `Palette_Profile_Obj` at 26:7AC0),   `Gfx_AbookAddr_Tiles8800` (load 800, block 752, spills 48 bytes into the following tilemap), `Gfx_CommScene_Tiles9400Vb1` (load 1024, block 512: the second half is palette and tilemap, as the region header notes), and   the same over-read for `Gfx_Account_ActionConfirmPage_Tiles9400Vb1` (palette at +$320 and tilemap at +$360 lie inside the 1024 loaded bytes), `Gfx_Account_LoginIdIntro_Tiles9400Vb1`, `Gfx_AdapterCheck_Tiles9400Vb1`,   `Gfx_CommPanel_Tiles9400Vb1`, `Gfx_SettingsPhone_ContinuePrompt_*`: the HDMA length is larger than the tile data, the tail bytes are copied to VRAM but are not tiles.

* `Gfx_PageListProto_Tiles9580Vb1` (52:4080, PROBABLE): `PageListProto_ShowMessage` loads **four** 640-byte alternatives (4080, 4380, 4680, 4980) to the same `$9581`; the block is the default/case-3 one and three sets lie inside its 2944-byte   region.

* `Palette_HelpMenu_Bg`, `Palette_Registration_Delete_Bg`, `Palette_BrowserMenu_Bg6`: the label block (8 / 8 / 6 bytes) is shorter than the load (64 / 64 / 16); the rest is covered by other labels.

* `wMailSessionBlock` (`ram/banked.asm`, PROBABLE) documents `+0` as "send result (0, 1, 2, $FF)", but the template copied there by the delete flows starts with `$03`.

* The Profile tiles load `$9701` from `ld hl,$6700` and `$8800` from `$6800` with raw immediates (interior of `Data_2A_6300`); not part of this share.

## Open questions left as they were

* The semantic part of the keyboard helper names (`NeedsExtraPalette`, `HidesOnKey82/83`, `WaitsWithService`, `GetSlideTargetY`) rests on the helper names of earlier passes; the tables only follow them.
* The content of the neighbour records (4 direction bytes + 2 flag bytes per cell is what `Kbd_MoveCursor` reads; the cell numbering is not decoded).
* `Font_GlyphRun_83BF` holds placeholder boxes; which codes of `$83BF..$83C3` the game emits was not traced.
