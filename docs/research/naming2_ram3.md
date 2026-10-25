# RAM and operand pass 3 (ram3)

## 3. The SRAM variable page `$BF00-$BFFF` (bank 1)

| name | address | status |
| --- | --- | --- |
| `sVarPage` | `$BF00` | CONFIRMED |
| `sTitleMenuCursor` | `$BF00` | PROBABLE |
| `sVarSettingsMenuCursor` | `$BF01` | PROBABLE (already named) |
| `sPhoneTopMenuCursor` | `$BF02` | PROBABLE (already named) |
| `sPhoneSlotMenuCursor` | `$BF03` | PROBABLE |
| `sPhoneMethodMenuCursor` | `$BF04` | PROBABLE (already named) |
| `sKbdInputMode` | `$BF05` | CONFIRMED |

## 4. Raw pointer operands

* **34 symbolized** (the consumer takes a pointer and the label is in the bank it reads): the attribute keyword tables of the HTML tags (`BC` for `Html_ScanAttributes`: `Html_NoKeywords`, `Html_MetaAttrPtrs`,
  `Html_AnchorAttrPtrs`, `Html_BrAttrPtrs`, `Html_HrAttrPtrs`), the three mail result texts, the mail object palette (`$7520`, bank 27), two settings word tables and one 3-byte table indexed by a screen variable, a page-list tile
  block, and 17 Mobile SDK packet templates and strings (`MobilePacket_*`, `MobileStr_*`, `Data_75_6063`).
* **9 kept numeric** because the number only coincides with the label: `ld de, $7828` (a position pair for `Sprite_SetPosition`, two sites, equal to `BrowserShared_ObjTable`), `ld hl, $4000` in
  `connect_dialog_screen.asm` (a pointer into bank `$56`, given in A for `TextTiles_RenderGrid`, not the file bank), `ld bc, $0684` (the byte count of the checksummed block `A000-A683`, five sites, equal to
  `Bank_InitState`) and `ld de, $1018` (a coordinate pair).

### 5.1 The rule

The pass keeps the neutral name as the only global name and adds a **screen-local alias**, a `DEF` of the same number in [`ram/overlays.asm`](../../ram/overlays.asm), used only inside the source file(s) or function range (`path@LabelA..LabelB`) that its group header lists (STYLE.md, section 4, RAM).

### 5.2 Result

| package | area | rows | CONFIRMED | PROBABLE | HYPOTHESIS (not applied) |
|---|---|---|---|---|---|
| pilot | phone slot menu | 3 | 2 | 1 | 0 |
| 1 | comm scene, connect and notice dialogs, title, startup, error screens (WRAM0) | 37 | 27 | 8 | 2 |
| 2 | menus, help, browser start page, debug screens, tilemap helper (WRAM0) | 58 | 36 | 15 | 7 |
| 3 | settings and account screens (WRAM0) | 53 | 46 | 7 | 0 |
| 4 | HTML parser, layout, tags, count pass, page renderer, inline images (HRAM) | 72 | 59 | 13 | 0 |
| 5 | text engine, text tiles, charset conversion, small HRAM users (HRAM) | 45 | 34 | 10 | 1 |
| | total | 268 | 204 | 54 | 10 |

Seven raw operands that name an alias byte (`ld hl, $C0E7` in `top_menu`, `mail_menu`, `start_choice`, `non_cgb_screen`; `$C0E6` in `top_menu`; `$C0E5` in `mobile_dictionary`; `$FFB0` in `password_entry`) were converted by hand to the alias, byte-neutral.

Whole-area operands (`ld hl, $C0D4` clears the menu window at every screen entry) and operands in files that have no alias for that byte (`$C10E` in `palette_fade_ticker.asm` and `far_helpers.asm`, `$FFB1` in the palette fades) stay numeric.

### 5.3 What the pass corrects in `naming2_ram2.md` section 4

Each point was re-derived by the reader of the package (details and addresses in `naming2_verify_ram3.md`).

* **`C27C-C283`.**  The roles are per screen, as ram2 said, but the lead "C27E = idle counter low byte" is wrong: in the title screen C27E:C27F is a 16-bit *big-endian* frame counter   (`0E:40CA-40E5`, C27E the high byte, compared with `$00B4` = 3 s; `Title_StateMenu` identical with `$2A30` = 3 min).

In the notice pages C27E:C27F is a little-endian pointer to the six-byte page record (`$4BDE + 6 * page`, `65:48B4-48BD`) and C27C the page number.

C27C is also an entry   argument (`Account_ResultPage` kind 0-4, `Registration_DeleteConfirmPage`) and the verify result of the registration flow; C27D an entry argument, an edited-field selector a cancel flag   depending on the screen; C27E a slot index 0-2 in the settings-phone screens.

* **`C286` is not an "API poll counter".**  It is a one-shot latch of the adapter animation sound (`Sound_PlaySfx` bc = `$0046` plays once when frame index 2 of sprite slot 0 appears, the flag is   cleared at frame 0); the code exists in four copies (`67:644E`, `67:5410`, `67:555C`, `68:6B98`), all constant stores, no increment.

* **`C0E5`/`C0E6`.**  "Current / previous item" holds only for the top menu, and there the previous-cursor store is a quirk: the up handler (`1F:42EB-42FF`) pushes `hWRAMBank` and stores it into C0E6, which   `LoadPanel` reads and ignores for a bank of 3 or more.

In `HelpMenu` and `MailMenu` the byte is the *item to draw as normal* (the argument of `DrawItemNormal`): `wHelpMenu_NormalItem`,   `wMailMenu_NormalItem`.

* **`C0D4/C0D6/C0D8`.**  A pixel cursor position in the top menu and the mobile dictionary; in the connect dialog C0D8 is the current mode and C0D6 the mode requested by the handlers   (`ConnectDialog_LeaveMode` copies it); in the notice dialog C0D4 is the 0/1 choice cursor and C0D6/C0D8 are the tile-set and mode arguments.

**`C0E8`** in the connect dialog is a password-field   redraw flag; **`C0F6`** is its raster-slide state (`00:16DC` sets SCY = 9 - old value and stores (WY - `$28`) / 8), not a ticker column; **`C0DF`** stays neutral (Y step high byte in the top menu, slide   step in the debug screen).

* **`C10E/C10F`** are the attribute-source pointer of `Tilemap_CopyRectAndAttrPtr` (`00:16A2` copies the second rectangle to DE + `$0400`, VRAM bank 1; CONFIRMED in the help menu, the mail menu and   the browser start page).

In `Tilemap_FillRectSequential` C10E is the constant `$07` (WRAM bank) and C10F the start tile: **not a counter**; the counter is in the next routine,   `Palette_FadeOutWithTicker` (`48:46D3-46D5` stores 4, `48:470D` decrements).

### 5.4 Other findings (HRAM)

* **Page-wide, not per line.**  `FFCC:FFCD` has one writer (`Html_Layout_Init`) and `FFCE:FFCF` is incremented in lockstep with the record count by `AppendRecord`; nothing resets them per line (the walks   average about 30 records).

`FFE0` is an *index* into the link pointer table at `$D600` (`$D600 + 2 * [record+$E]`), so the "+$E link heap position" of `naming_g8.md` and the idea row `FFE0   hHtmlLinkHeapOffset` of ram2 are wrong.

`FFB0:FFB1` is the keyword-restart pointer in the HTML files but is clobbered by `Text_MeasureFit`, so the page renderer's wanted link id (`FFB1`) is saved around   `Browser_DrawElement`.

* **`hHtmlLayout_HeightAbove/Below` (`FFC6/FFC7`) stay PROBABLE:** the above/below split is read from branches that never ran naturally (`AddRecordToLine` `74:5617-561F`, `5651-5659`).

In the phone slot menu the first and third field do (`$48` for `hTextY = $4B`,   `$68` for `$6B`); the second field (`hTextY = $5B`, `hTextX = $38`) stores `$38` to `FFC0` and `$58` to `FFC1` (`67:5017-501D`, `3E 38 E0 C0 3E 58 E0 C1`) where `$58` and `$38` would be expected, the two   values swapped.

A field of at most 16 characters starting at x = `$38` cannot reach the right limit `$98`, so the swap is probably invisible (inference, not proof).

* **Cleanups found by the readers (one made, three open):** (1) `result_page.asm` `Account_DigitTilemapTable` / `Table_68_793F` (`68:793D-7951`): the ten words `$5B68, $5B6C ... $5B8C` are source addresses in ROM   bank `$4B` (`ld a, $4B` before `farcall Tilemap_CopyRectAndAttr`, `68:78A0` and `78BE`), not bank-68 code pointers; the survey mislabelled them, which created nine spurious global labels   `Label_68_5B6C..5B8C` inside `Account_MailDomain_PrintField`; the fix is numeric `dw` operands, then the labels can go.  (2) The header of `Data_51_740C` (`inline_image_blit.asm`) said "probably   padding, not referenced", but never-executed code reads it as an all-ones mask (`ld a, [$740C]`, `51:75A0` and `51:765B`): **made**: the header is PROBABLE with that reading and the two   reads use the label.  (3) `Html_Tag_A`: the drop label (`74:4B81`) is also reached from the `name=` branch,   where it decrements `FFDF` although that branch never incremented it (never ran).  (4) `hEucJpToSjisStream_Byte` holds the lead byte; `..._LeadByte` would be more exact (optional).

### 5.5 Decisions taken while integrating

* The parser rows for `FFB0`, `FFB1`, `FFB3` (`hHtml_MatchRestart`, `hHtml_MatchRestartHi`, `hHtml_LastChar`) are the CONFIRMED rows of the tag files widened with `parser.asm@Html_ParsePage..`   (`Html_MetaResultToError`, the first function, reuses the three bytes as a hex accumulator in code that never ran and stays neutral).

* `wHelpScript_LineCounter` and `wHelpScript_LastOpcode` (`C1AA`, `C1AC`) are written and never read: demoted to HYPOTHESIS records (a name needs a writer and a reader; the reader of package 2 pointed out   the tension with `naming2` section 2 point 3).

* Scopes widened on the readers' evidence: `hTextTiles_DestBank` to 17 more files (22 caller files, 105 `TextTiles_Render*` farcalls, each preceded by the `FFB0` store); `hInlineImages_*` to   `mobile_dictionary_view.asm` (a copy of `Browser_FetchInlineImages`); `hHtmlCount_ListItems` to `tags.asm@Html_Tag_Ol..Html_Tag_Li`; `hTextTiles_GridRow`/`GridRowEnd` to `mobile_dictionary.asm`; `hBmp_Width`   to `tags.asm@Html_Tag_Img..`.

### 5.6 Left for later

* `delete_registration.asm`, the debug-flags `C0E5` and the help-script `C0D9` use one byte for two things: resolvable with function ranges (nobody has written the rows).
* `hHtmlMeta_HexByte2` could be tightened to `parser.asm@Html_MetaResultToError..Html_ParsePage` with a `hHtmlMeta_HexByte3` for `FFB3` (never ran; optional).
* The write-only `FFB6/FFB7` of `text_tiles.asm` and `C279/C27B` stay neutral; the HYPOTHESIS rows are the list of ideas that need a reader.
