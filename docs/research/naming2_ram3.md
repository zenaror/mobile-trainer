# RAM and operand pass 3 (ram3)

> Status: **reference (current)** for the names and symbolized operands it lists.  Follows [`naming2_ram2.md`](naming2_ram2.md) (bank-independent WRAM0 / HRAM names) and closes two of
> its open items: the banked variable `wRam_D725` (section 6 of that note, idea `wStatSplitParam2`) and the bank-1 SRAM variable page.  Record of the operand decisions:
> [`analysis/naming2/rawptr1_sites.tsv`](../../analysis/naming2/rawptr1_sites.tsv).  Section 5 is the second step of the pass: the screen-local aliases of the overlay variables
> ([`analysis/naming2/overlay_aliases.tsv`](../../analysis/naming2/overlay_aliases.tsv), applied in [`ram/overlays.asm`](../../ram/overlays.asm)), verified by six independent readers in
> [`naming2_verify_ram3.md`](naming2_verify_ram3.md).

## 1. Result

| item | count |
|---|---|
| bank-qualified names added to `ram/banked.asm` | 5 (`wKbdSlideDeltaRow` in WRAM bank 1; `sVarPage`, `sTitleMenuCursor`, `sPhoneSlotMenuCursor`, `sKbdInputMode` in SRAM bank 1) |
| code references renamed to them | 83 (`wRam_D725`) + 16 raw SRAM operands |
| raw pointer operands replaced by the label at that address | 34 sites, 26 rules, 9 files |
| coincidences that stay numeric (the number is not a pointer) | 9 sites |
| screen-local aliases of overlay variables (section 5) | 258 aliases of 67 bytes (25 in WRAM0, 42 in HRAM): 204 CONFIRMED, 54 PROBABLE; 10 more rows are HYPOTHESIS records, never applied |
| code references renamed to the aliases | 2,070 in 71 files by the tool, plus 7 literal operands converted by hand |
| ROM | byte-identical (`make`: `RESULT: IDENTICAL`; `sym-check`, `tidy_comments --check`, `localize_labels --check`, `tree_check` pass) |

The neutral names `wRam_D725` and `sSram_BF00` / `BF03` / `BF05` stay defined in `ram/wram.asm` / `ram/sram.asm` (a neutral name never claims a bank); their comments now point at the
adopted bank-qualified name.

## 2. `wKbdSlideDeltaRow` ($D725, WRAM bank 1, PROBABLE)

Row index (register D) of the per-step delta tables used by the keyboard slide of types 8 and 9.

* **Readers.**  `KbdSlide_InPrepMode8` / `OutPrepMode8` / `InPrepMode9` / `OutPrepMode9` (`7F:7149`, `7178`, `71A7`, `71D6`; the "Mode" in their names is `wKbdType`) load `D` from it when it is non-zero and
  otherwise use a constant row (4 for type 8, 5 for type 9); `E` = 0.  `ScrollSplit_StepUp4` / `StepDown4` (`7F:7425`, `76C4`) then index `ScrollSplit_Step{Up,Down}4Ptrs[2*D]` and walk the row with `E`,
  adding each value to `wSplitScrollY` and subtracting it from the sprite slots.  Both branches of all four readers ran in natural scenarios (non-zero 11-23 hits each, zero 50-72).
* **The rows** (computed from the ROM, same in the Up and Down tables): totals 0, 0, 12, 24, 36, 40, 60, 60, 11, 18, 57, 66 pixels for rows 0-11, eleven steps each (row 9: eighteen).  Rows 2-4 and 6-7 are
  12 * (row - 1); the default rows 4 and 5 slide 36 and 40 px; rows 10 and 11 slide 57 and 66 px.
* **Writers.**  75 stores, all in WRAM bank 1 (63 CONFIRMED + 20 PROBABLE bank contexts in `config/ram_context.tsv`), always right next to `wStatSplitLine` before `Stat_EnableScrollSplit`: 62 store `0` (use the
  default), 5 store `$0A` (address editor, address picker, list) and 8 store `$0B` (name editor, view, save-confirm screens).
* Why PROBABLE: the status is the weaker of the name and the bank contexts (`ram/banked.asm` convention); the reader semantics are demonstrated.  `naming_g8.md` had the lead ("0 or the row index of the keyboard scroll
  tables"); `naming2_ram2.md` kept `wStatSplitParam2` as an idea because the address is banked.

## 3. The SRAM variable page `$BF00-$BFFF` (bank 1)

`Settings_ClearVariableBlock` (`68:4A0F`) zero-fills the page (`ld hl, $BF00 ; ld bc, $0100 ; call FillBytes` with bank 1 selected; 663 hits in 63 scenarios).  Only `BF00-BF05` are used, one byte each, always through the
inline bank-1 access wrapper (`ld a, $01 ; ldh [hSRAMBank], a ; ld [rRAMB], a` in the same block, so the bank of each address is S1):

| name | address | status | evidence |
|---|---|---|---|
| `sVarPage` | `$BF00` | CONFIRMED | the 256-byte block that `Settings_ClearVariableBlock` zero-fills |
| `sTitleMenuCursor` | `$BF00` | PROBABLE | remembered cursor of the title menu: stored from `wRam_C27D` at the exit of `Function_0E_4000` (which returns C27D + 1) and loaded back by `Title_StateLoadTitle` (53+ scenarios); replaces the g1 idea `sSram_TitleLastSelection` |
| `sVarSettingsMenuCursor` | `$BF01` | PROBABLE (already named) | settings-menu cursor |
| `sPhoneTopMenuCursor` | `$BF02` | PROBABLE (already named) | phone-number top-menu cursor |
| `sPhoneSlotMenuCursor` | `$BF03` | PROBABLE | remembered cursor of the dial-slot menu: `SettingsPhone_SlotMenu` stores `wSlotMenu_Cursor` (`wRam_C27D`) at exit and `SettingsPhone_SlotMenu_Setup` loads it; `67:404D` stores the selected dial entry in it and `SettingsPhone_ResetSlotCursor` clears it; adopts the g6 idea |
| `sPhoneMethodMenuCursor` | `$BF04` | PROBABLE (already named) | input-method menu cursor |
| `sKbdInputMode` | `$BF05` | CONFIRMED | persisted keyboard input mode: `Kbd_LoadInputMode` copies it into `wKbdInputMode` (1,473 hits in 31 scenarios; a call with A = 0 sets mode 0 without reading SRAM), `Kbd_SaveInputMode` writes it back (49 hits in 9) |

The 16 raw operands `ld hl, $BF0n` / `$B0BE` of these wrappers now use the names (`sSettingsFieldMask` at `$B0BE` was named already but still written as a number at three sites).

## 4. Raw pointer operands

An immediate `ld hl|de|bc, $XXXX` in the ROM pointer range (`$0150-$7FFF`) is a pointer only when something dereferences it or hands it to a routine that does.  A census over `home/`, `engine/`, `lib/` found 9,787 such
loads, 2,286 of them in the ROM range, and 43 whose number equals the address of a global label *in the same bank* (the 2,200-odd others point into unlabeled data or are constants).  Each of the 43 was read with its
consumer:

* **34 symbolized** (the consumer takes a pointer and the label is in the bank it reads): the attribute keyword tables of the HTML tags (`BC` for `Html_ScanAttributes`: `Html_NoKeywords`, `Html_MetaAttrPtrs`,
  `Html_AnchorAttrPtrs`, `Html_BrAttrPtrs`, `Html_HrAttrPtrs`), the three mail result texts, the mail object palette (`$7520`, bank 27), two settings word tables and one 3-byte table indexed by a screen variable, a page-list tile
  block, and 17 Mobile SDK packet templates and strings (`MobilePacket_*`, `MobileStr_*`, `Data_75_6063`).
* **9 kept numeric** because the number only coincides with the label: `ld de, $7828` (a position pair for `Sprite_SetPosition`, two sites, equal to `BrowserShared_ObjTable`), `ld hl, $4000` in
  `connect_dialog_screen.asm` (a pointer into bank `$56`, given in A for `TextTiles_RenderGrid`, not the file bank), `ld bc, $0684` (the byte count of the checksummed block `A000-A683`, five sites, equal to
  `Bank_InitState`) and `ld de, $1018` (a coordinate pair).

Raw SRAM operands (`ld hl, $A000` ... 376 of them, 121 distinct addresses, only 7 SRAM variables named) are a separate, larger front and are not part of this pass.

## 5. Screen-local aliases of the overlay variables

### 5.1 The rule

[`naming2_ram2.md`](naming2_ram2.md) left a family of bank-independent bytes with their neutral names because every screen reuses them with another meaning: `wRam_C27C-C28E` ("screen variables"),
`wRam_C0D4-C0FF` ("menu window"), `wRam_C10E/C10F`, `wRam_C1AA-C1AC`, and in HRAM `hRam_FFB0-FFE0` (HTML parser, layout, page renderer, text engine, text tiles: one byte, a different role per phase).
A global name for such a byte would be false everywhere but one place.  The pass keeps the neutral name as the only global name and adds a **screen-local alias**, a `DEF` of the same number in
[`ram/overlays.asm`](../../ram/overlays.asm), used only inside the source file(s) or function range (`path@LabelA..LabelB`) that its group header lists (STYLE.md, section 4, RAM).  An alias is the same
number as its base, so no byte of the ROM depends on it; its status is the evidence for the role *in that scope*.  A byte that one file uses for two things gets no alias for the whole file, only for the
function ranges where it has one meaning.  The tool is `tools/apply_overlay_aliases.py` (it refuses unsafe rows, builds, compares the SHA-256, runs `sym_check`, rolls back on failure; `--check` audits the file);
tests: `tools/test_overlay_aliases.py` (30).

### 5.2 Result

Six packages by area; each was written by an executor working in a private copy of the tree (every mention of every byte read in its context, every role tied to code and to the natural coverage union), then
re-derived and attacked by an independent reader with a fresh brief, and the corrections were merged ([`naming2_verify_ram3.md`](naming2_verify_ram3.md); the readers' correction rows:
[`analysis/naming2/verify_overlay_fixes.tsv`](../../analysis/naming2/verify_overlay_fixes.tsv)).

| package | area | rows | CONFIRMED | PROBABLE | HYPOTHESIS (not applied) |
|---|---|---|---|---|---|
| pilot | phone slot menu | 3 | 2 | 1 | 0 |
| 1 | comm scene, connect and notice dialogs, title, startup, error screens (WRAM0) | 37 | 27 | 8 | 2 |
| 2 | menus, help, browser start page, debug screens, tilemap helper (WRAM0) | 58 | 36 | 15 | 7 |
| 3 | settings and account screens (WRAM0) | 53 | 46 | 7 | 0 |
| 4 | HTML parser, layout, tags, count pass, page renderer, inline images (HRAM) | 72 | 59 | 13 | 0 |
| 5 | text engine, text tiles, charset conversion, small HRAM users (HRAM) | 45 | 34 | 10 | 1 |
| | total | 268 | 204 | 54 | 10 |

The 258 applied rows give 2,070 renamed references in 71 files (`engine/**` and `home/text.asm`); the 67 bytes carry between 1 and 23 aliases each (12 bytes have one; `wRam_C27C` has 23,
`wRam_C27D` 22, `wRam_C27E` 13, `hRam_FFB0` 11).  Seven raw operands that name an alias byte (`ld hl, $C0E7` in `top_menu`, `mail_menu`, `start_choice`, `non_cgb_screen`; `$C0E6` in `top_menu`; `$C0E5` in
`mobile_dictionary`; `$FFB0` in `password_entry`) were converted by hand to the alias, byte-neutral.  Whole-area operands (`ld hl, $C0D4` clears the menu window at every screen entry) and operands in
files that have no alias for that byte (`$C10E` in `palette_fade_ticker.asm` and `far_helpers.asm`, `$FFB1` in the palette fades) stay numeric.

### 5.3 What the pass corrects in `naming2_ram2.md` section 4

Each point was re-derived by the reader of the package (details and addresses in `naming2_verify_ram3.md`).

* **`C27C-C283`.**  The roles are per screen, as ram2 said, but the lead "C27E = idle counter low byte" is wrong: in the title screen C27E:C27F is a 16-bit *big-endian* frame counter
  (`0E:40CA-40E5`, C27E the high byte, compared with `$00B4` = 3 s; `Title_StateMenu` identical with `$2A30` = 3 min).  In `CommScene_Step` C27E is the argument and C27F the result (1 running, 2 B
  pressed, 0 finished).  In the notice pages C27E:C27F is a little-endian pointer to the six-byte page record (`$4BDE + 6 * page`, `65:48B4-48BD`) and C27C the page number.  C27C is also an entry
  argument (`Account_ResultPage` kind 0-4, `Registration_DeleteConfirmPage`) and the verify result of the registration flow; C27D an entry argument, an edited-field selector or a cancel flag
  depending on the screen; C27E a slot index 0-2 in the settings-phone screens.  `C280`/`C281` of the comm scene place two *sprites* (a walking figure and a blue "@" icon: `SpritePairX`,
  `SpritePairVariant`), not text: "TextObjTable" and "SetTextSprites" in the labels are a misnomer that a later pass can fix.
* **`C286` is not an "API poll counter".**  It is a one-shot latch of the adapter animation sound (`Sound_PlaySfx` bc = `$0046` plays once when frame index 2 of sprite slot 0 appears, the flag is
  cleared at frame 0); the code exists in four copies (`67:644E`, `67:5410`, `67:555C`, `68:6B98`), all constant stores, no increment.
* **`C28E` has two meanings:** the four-state machine of the settings menu (`$FF` = done) and the "No" flag written by `Account_ActionConfirmPage` (1 = second button, 0 = B) that `UsageTime_Run`
  and `UsageFee_Run` test after a cancelled fetch (the second button of the rendered tilemap is "iie").  **`C279` and `C27B` are written and never read** anywhere in the tree.
* **`C0E5`/`C0E6`.**  "Current / previous item" holds only for the top menu, and there the previous-cursor store is a quirk: the up handler (`1F:42EB-42FF`) pushes `hWRAMBank` and stores it into C0E6, which
  `LoadPanel` reads and ignores for a bank of 3 or more.  In `HelpMenu` and `MailMenu` the byte is the *item to draw as normal* (the argument of `DrawItemNormal`): `wHelpMenu_NormalItem`,
  `wMailMenu_NormalItem`.  The browser start page has C0E5 only, the mobile dictionary's C0E5 is the list scroll offset and it has no C0E6, and in the connect dialog C0E5 is the highlighted button
  (1-based, toggled by `xor 3`) and C0E6 the previous mode.
* **`C0D4/C0D6/C0D8`.**  A pixel cursor position in the top menu and the mobile dictionary; in the connect dialog C0D8 is the current mode and C0D6 the mode requested by the handlers
  (`ConnectDialog_LeaveMode` copies it); in the notice dialog C0D4 is the 0/1 choice cursor and C0D6/C0D8 are the tile-set and mode arguments.  **`C0E8`** in the connect dialog is a password-field
  redraw flag; **`C0F6`** is its raster-slide state (`00:16DC` sets SCY = 9 - old value and stores (WY - `$28`) / 8), not a ticker column; **`C0DF`** stays neutral (Y step high byte in the top menu, slide
  step in the debug screen).
* **`C10E/C10F`** are the attribute-source pointer of `Tilemap_CopyRectAndAttrPtr` (`00:16A2` copies the second rectangle to DE + `$0400`, VRAM bank 1; CONFIRMED in the help menu, the mail menu and
  the browser start page).  In `Tilemap_FillRectSequential` C10E is the constant `$07` (WRAM bank) and C10F the start tile: **not a counter**; the counter is in the next routine,
  `Palette_FadeOutWithTicker` (`48:46D3-46D5` stores 4, `48:470D` decrements).  `naming2_ram2.md:142` (current/previous item in the browser start page and the dictionary) and the C0D4/C0D6/C0DF ideas at
  lines 122-123 and 186-187 are superseded by the aliases; the "arrow blink" C0D9/C0DA exists only in the unreferenced routine `6C:61AC`.

### 5.4 Other findings (HRAM)

* **Page-wide, not per line.**  `FFCC:FFCD` has one writer (`Html_Layout_Init`) and `FFCE:FFCF` is incremented in lockstep with the record count by `AppendRecord`; nothing resets them per line (the walks
  average about 30 records).  `FFE0` is an *index* into the link pointer table at `$D600` (`$D600 + 2 * [record+$E]`), so the "+$E link heap position" of `naming_g8.md` and the idea row `FFE0
  hHtmlLinkHeapOffset` of ram2 are wrong.  `FFB0:FFB1` is the keyword-restart pointer in the HTML files but is clobbered by `Text_MeasureFit`, so the page renderer's wanted link id (`FFB1`) is saved around
  `Browser_DrawElement`.  `FFD6/FFD7` are the width and height of the bitmap being processed in every phase (header, rounded, record, converted, clipped, blit input): one cross-file alias, PROBABLE.
* **`hHtmlLayout_HeightAbove/Below` (`FFC6/FFC7`) stay PROBABLE:** the above/below split is read from branches that never ran naturally (`AddRecordToLine` `74:5617-561F`, `5651-5659`).  The function
  range stops before `Html_Layout_GetLimitsAtY`, the only user of the pair as scratch.
* **Possible endless retry (HYPOTHESIS, open).**  `Html_Layout_ClearAllFloats` (`74:5252`) compares `FFC4` with `hViewX`, but `GetLimitsAtY` sets `FFC4 = hViewX + hHtmlLineIndent`; the retry at `74:5293`
  ran 292,374 times in one natural scenario (`monkey_camp_rich`, 96% of the 303,337 `GetLimitsAtY` calls counted in the alias rows) against 612 in the other 15.  It looks like a loop that does not end when a page
  finishes inside an unclosed list.  The counts in the layout rows are real but not representative.  Nothing was changed.
* **Original program quirk (inference).**  The setup sequences of the text box store `FFC0 = hTextY - 3` and `FFC1 = hTextX`.  In the phone slot menu the first and third field do (`$48` for `hTextY = $4B`,
  `$68` for `$6B`); the second field (`hTextY = $5B`, `hTextX = $38`) stores `$38` to `FFC0` and `$58` to `FFC1` (`67:5017-501D`, `3E 38 E0 C0 3E 58 E0 C1`) where `$58` and `$38` would be expected, the two
  values swapped.  A field of at most 16 characters starting at x = `$38` cannot reach the right limit `$98`, so the swap is probably invisible (inference, not proof).
* **Cleanups found by the readers (one made, three open):** (1) `result_page.asm` `Account_DigitTilemapTable` / `Table_68_793F` (`68:793D-7951`): the ten words `$5B68, $5B6C ... $5B8C` are source addresses in ROM
  bank `$4B` (`ld a, $4B` before `farcall Tilemap_CopyRectAndAttr`, `68:78A0` and `78BE`), not bank-68 code pointers; the survey mislabelled them, which created nine spurious global labels
  `Label_68_5B6C..5B8C` inside `Account_MailDomain_PrintField`; the fix is numeric `dw` operands, then the labels can go.  (2) The header of `Data_51_740C` (`inline_image_blit.asm`) said "probably
  padding, not referenced", but never-executed code reads it as an all-ones mask (`ld a, [$740C]`, `51:75A0` and `51:765B`): **made**: the header is PROBABLE with that reading and the two
  reads use the label.  (3) `Html_Tag_A`: the drop label (`74:4B81`) is also reached from the `name=` branch,
  where it decrements `FFDF` although that branch never incremented it (never ran).  (4) `hEucJpToSjisStream_Byte` holds the lead byte; `..._LeadByte` would be more exact (optional).

### 5.5 Decisions taken while integrating

* One row `wRegistrationVerify_Result` with the scope of both files (packages 1 and 3 had the same alias for `comm_panel.asm`; the tool refuses a second row).
* Package 4's text-box rows in `page_render.asm` (`GlyphColorB/C`, `TextLeftX`, `TextRightX`, `TextLineStep`) were dropped in favour of package 5's `hTextBox_ColorSelB/C`, `LineStartX`, `RightLimitX`, `LineAdvance`,
  whose scopes now include `engine/browser/page_render.asm`: the same bytes, set before `TextEngine_Run` with the same roles (both readers checked every mention).
* The parser rows for `FFB0`, `FFB1`, `FFB3` (`hHtml_MatchRestart`, `hHtml_MatchRestartHi`, `hHtml_LastChar`) are the CONFIRMED rows of the tag files widened with `parser.asm@Html_ParsePage..`
  (`Html_MetaResultToError`, the first function, reuses the three bytes as a hex accumulator in code that never ran and stays neutral).  `hPageRender_WantedLink` uses the range
  `page_render.asm@Browser_RedrawLinkById..Browser_SelectPrevLink`.
* Renamed by the readers: `wCommScene_TextPosX/TextVariant` -> `SpritePairX/SpritePairVariant`; `wHelpMenu_PrevCursor` -> `wHelpMenu_NormalItem`; `wMailMenu_PrevCursor` -> `wMailMenu_NormalItem`.
* `wHelpScript_LineCounter` and `wHelpScript_LastOpcode` (`C1AA`, `C1AC`) are written and never read: demoted to HYPOTHESIS records (a name needs a writer and a reader; the reader of package 2 pointed out
  the tension with `naming2` section 2 point 3).
* Scopes widened on the readers' evidence: `hTextTiles_DestBank` to 17 more files (22 caller files, 105 `TextTiles_Render*` farcalls, each preceded by the `FFB0` store); `hInlineImages_*` to
  `mobile_dictionary_view.asm` (a copy of `Browser_FetchInlineImages`); `hHtmlCount_ListItems` to `tags.asm@Html_Tag_Ol..Html_Tag_Li`; `hTextTiles_GridRow`/`GridRowEnd` to `mobile_dictionary.asm`; `hBmp_Width`
  to `tags.asm@Html_Tag_Img..`.

### 5.6 Left for later

* `delete_registration.asm`, the debug-flags `C0E5` and the help-script `C0D9` use one byte for two things: resolvable with function ranges (nobody has written the rows).
* `hHtmlMeta_HexByte2` could be tightened to `parser.asm@Html_MetaResultToError..Html_ParsePage` with a `hHtmlMeta_HexByte3` for `FFB3` (never ran; optional).
* The write-only `FFB6/FFB7` of `text_tiles.asm` and `C279/C27B` stay neutral; the HYPOTHESIS rows are the list of ideas that need a reader.

## 6. Reproduce

The edits are text rewrites checked by the build; the decisions of section 4 are in `analysis/naming2/rawptr1_sites.tsv` (one row per rule, with the consumer as evidence and the nine coincidences marked `kept raw`).
`make` must print `RESULT: IDENTICAL` and `make sym-check` must pass after each of them.

The aliases of section 5 come from `analysis/naming2/overlay_aliases.tsv` (the merged and corrected manifest, `# ---- package N` sections) through
`python3 tools/apply_overlay_aliases.py --manifest analysis/naming2/overlay_aliases.tsv --strict` (a second run reports every row as `already applied`); `python3 tools/apply_overlay_aliases.py --check`
audits `ram/overlays.asm` (258 aliases, 0 errors, 0 notes).  The corrections of the six readers, as rows in the manifest format, are in `analysis/naming2/verify_overlay_fixes.tsv` (their merge is
described in section 5.5; the manifest already contains them).
