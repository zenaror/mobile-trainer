# Mail library, sound driver, mail screens, browser and HTML buffers (ramop10): independent reference

## 3. Reader of the mail library and the sound driver (R2): report

**Observations outside the diff.**  `wMail_Selector` (CONFIRMED) is scratch at 9 of its 11 uses (selector 1: lines 287, 316, 369, 373, 402, 404, 421; `Mail_FindHeader`: 649, 717): a `CAVEAT`.  `wSoundDrv_ReqDE` is scratch at 20 executed base sites (`audio/engine.asm:360-409, 1934-1966, 2038-2126`): a `CAVEAT`.  `Stat_ScrollSplitHandler` (00:0E93) restores the shadow from the real `rSVBK` read at entry: if it preempts a sound bracket it leaves `hWRAMBank = 1`; S1 and L5 are about the real register and are not affected, `keeps` proofs are conditional on shadow = real.
`frame_style_chooser.asm:285-302` has `dw Rst_08`, `ReturnMobileAPI`, `Mail_DispatchFar`, `MobileAPI`, `Int_Timer` for numbers: false references that a grep-based proof must discard.  The innermost-name rule would give any bank-5 `$D000-$D023` operand the library's field names whatever the file (nothing is left numeric now).

## 4. Reader of the mail screens (R3): report

`Glyph_IsSjisLeadByte` (7F:41A7) keeps the bank (no write, no call): not in the effect table.

The name is right: the load 25:4F56 runs under bank 2 (2 replays), the idiom is 25:4F5D, the first store 25:4F68 runs under bank 1.

* **F2** the `wMailInfo` `DEF` described spellings (`wEditBodyBuf + $06`, `+ $1B`, `wEditAddressBuf`) that never existed in the tree (the three loads were numeric `; raw` before the pass, `wMailInfo + $06/$C0/$1B` now).

* **F3** the `wMailTextScratch` `DEF` omitted a fifth use: the six 7-byte argument templates of `ConnectDialog_Run` (27:417A, 23:4B4A, 23:4C8D, 22:4C5B, 22:4DA6, 22:4EE9) carry the far pointer 01:D524 at `+3..+5`; `ConnectDialog_Run_Accept` (57:4096-40DA) copies `wConnectDialogTextLen` (0-8) characters and a NUL there with `WriteByteFar`; `MailConnect_Screen` (27:41E3) copies exactly 9 bytes from `$D524` to `$C0A0` (27:421F-4225), the password source of `Mobile_BeginConnect` (`send_receive.asm:509`).

Smaller points: three 29-byte strings, not two; the date source of 2E:5005 is `wMailInfo + 0`.

The roles of `+$0B` and `+$0D` are static only (22 natural replays: every non-boot store writes `$FF` or 0; the six increments have no row in `coverage_union.tsv`); executed and consistent: `+$0F`, the abort flag, the `+$11` save.

* **F5** `pop3_top.asm:217,422`: `Pop3_TopPoll` writes the four fields as `wMailInfo`, `wMailInfo + $06`, `wMailInfo + $1B` and, for the sender, `wEditAddressBuf` (54:49D4, 54:4BA2); the reader `tidy_screen.asm:429` spells the same bytes `wMailInfo + $C0`.

Dynamic: the staging happens in bank 1 only in `mail_server_full`, `_hidden2`, `_many` and `time_warnings`.

* **F6** optional: the six template words `db .., $01, $24, $D5, ..` could be `dw wMailTextScratch`; `$D526` is a written and read reply record number (`mailbox_screen.asm:1414,1449,1459`, `mail_viewer_sender.asm:1314,1347,1354`) and `$D525` is only written, the 8 neutral uses are blocked by the `CAVEAT` on purpose, a dedicated 1-byte name would let them be named.

All 215 loads decode to the same `ld rr, imm16` and the named operand has the old value (215/215).  177 sites have direct dereferences: at 175 the dataflow gives the claimed bank at every dereference (the other two are right: a dead routine entered right after the bank-1 idiom, and a site that needed `Glyph_IsSjisLeadByte` in the table);   138 of the 177 have observed masks at the dereference, all equal to the claimed bank, 0 contradictions.

The 38 call-consumer sites: 19 `TextTiles_RenderLine` with A = 1 at every call, 4 `MailGrid_*`, 6 `ConnectDialog_Run` (D = 1 right before BC in all six), 2 `CommTime_PutDigit`, 3 `MailServerMgr_DrawFieldText` (selects bank 1 on every pass), 4 dead loads.

`wMailTextScratch` 54 sites: nine template or message copies, seven digit adds, two reveal loops, nineteen `RenderLine` strings, thirteen date-digit sites, four grid texts; all are text, none the compose mode or the reply number (the byte accesses of `$D524` are exactly six stores and six loads, all `wMailComposeMode`).

`wMailSessionBlock` 48 sites by offset (+0 12, +5 1, +$0B 12, +$0D 15, +$0F 3, +$11 2, +$13 3), max used offset +$14 < 21; `wMailCountAtStart` is still a field of the container (`apply_banked_names --check`: "container and field", 0 errors); all 139 immediate accesses to `$D624-$D638` in the ROM are named.

* *The 10 rows*: `tidy_screen.asm:421,429,437` (2E:4ECB, 4EE2, 4EF9): loads and farcall under bank 1 (3 replays), `Pop3_TopPoll` 54:4B78, 4B87, 4B93, 4BA2 store date, label, subject and sender under bank 1; the seven `wEditBodyBuf` rows: loop `b = $C0` (`3204` is the `GetLength` limit), bank 1 observed (6, 5, 6, 7, 3, 2, 6 replays); `MailStaging_Clear` has one caller.

* *Sites left numeric*: `list.asm:716,726,746,789` right (DE never dereferenced), `mailbox_screen.asm:1354` right (`ld bc, $0124` wipes the whole staging area), `mail_viewer_sender.asm:1256` right (zero references in the ROM), `mail_session_screen.asm:1137` right (dead load of bank 2), `send_receive.asm:329` corrected (F3).

**False accepts, false names, tool bugs.**  No false accept among the 91 tool rows or the 117 by-hand rows.  False name at the site: `wEditAddressBuf` at `pop3_top.asm:217,422`.  Tool gap: `apply_manual_sites.py` accepts a row on a line that carries `; raw` and keeps the mark: refuse the row unless its disposition is `stays numeric`.

**Limits.**  The bank dataflow is the reader's own (no interrupts, no stale-shadow windows beyond the effect table; unknown calls reset the bank); dynamic evidence is the 41 bank-observed replays plus the reader's own replays of the 39 natural scenarios without the web (not the 25 browser, monkey and web ones) with write watches on a few addresses; roles ("number of mails found", the counters, "password") are interpretation (stores, reads, flows and values verified, not intent); not checked: `lib/mobile`, `audio`, scope B, the tool code, `pop3_top.asm` apart from the sender lines.  The reader did not open `engine/mail/sample_data.asm` and quotes no sample value.

| item | UPHELD | CORRECTED | DROPPED |
|---|---|---|---|
| names (14 `DEF`) | 12 (4 with wording fixes) | 2 (`wHtmlLinkHeap`, `wHtmlPage`) | 0 |
| statuses (11 CONFIRMED, 3 PROBABLE) | 14 of 14 | 0 | 0 |
| `wHtmlLinkPtrList` 1 to 512 | yes | | |
| consumer rules (12) | 11 | 0 | 1 (`TextTiles_RenderGrid hl wTileStage2`) |
| widened families (4), effect rows (3) | 4, 3 | 0 | 0 |
| by-hand rows `manual` (55) | 52 | 3 (`debug_flags.asm` 776, 886, 895) | 0 |
| `stays numeric` rows (24) | 24 decisions | 4 reasons reworded | 0 |
| changed lines of the 31 files (138) | 130 | 8 pointer operands | 0 |

**Defects.**
1. **False names by role, 8 operands, rule dropped.**  `wTileStage2` at `debug_flags.asm:753, 776, 863, 886, 895, 927`, `error_screen_test.asm:444`, `sound_test.asm:446`: HL or DE is the Shift-JIS string scratch of bank 2 (builders 19:468F, 19:473E; source of `farcall TextTiles_RenderGrid`, A = 2) and the tile destination of the same call is `wTileStage3` (`hTextTiles_DestBank = 3`).  ramop9 sent exactly these back to numeric with `; raw`; the tree was incoherent (`:633` raw, `:753` named, `:776` named with a raw mark saying "not tile staging").  Cause: the new rule (wrong by construction: HL is the source text; its only five uses are these) plus three by-hand rows.
   Tool bug, reproduced: `apply_manual_sites.py` does not look at `; raw`, and `apply_ram_operands.py --neutral` ignores it too (`entry.asm:75` marked raw: "1 use to rewrite").
2. **`wHtmlLinkHeap` extent wrong.**  The `DEF` said 2,046 bytes, "ends at `$DFFD`".  The ROM's own `Html_Tag_A` `#` branch (74:4AEA) run in the reader's emulator with `wHtmlLinkHeapPtr = $DFFB` and the name "a" writes `$DFFB = #`, `$DFFC = a`, `$DFFD = NUL`, `$DFFE-$DFFF` = Y position (74:4B11-4B16, no limit test) and leaves the pointer at `$E000` (full); `Html_StringTable_Add` writes the NUL of an overflowing string at the limit itself.  The object is `$D800-$DFFF`, 2,048 bytes; `$DFFE` is the string limit, two bytes below the end.
   The operand stays numeric (a value, only compared), but the raw comments at `tags.asm:1053` and `:1098` ("one past `wHtmlLinkHeap`") were wrong; the image heap limit `$DCFE` is right.
3. **`wHtmlPage` title length**: "up to 22 bytes" is 21: `Html_StoreTitle` (74:4530) run on 3-, 18-, 19-, 20-, 25- and 40-byte titles writes the last byte at `+$12, +$13, +$14, +$14, +$14, +$14`; `+$15` is the record count word, and the 22-byte reads (4E:5204, 24:4F14) include its low byte.
4. **Evidence sentences** (statuses unchanged): `wBrowserPageUrl` "observed bank 6 only at every instruction named" is false for 4E:5215 (bank 4) and 24:4F14 (banks 1, 2, 5, 6); `wBrowserUrlSave`: 4C:43CD is entered under bank 7, and the undo path is taken when `PageCache_Pop` returns 0 (no cached copy, 4E:4BEE-4BEF), not "cannot be loaded"; `wHtmlMetaDCode`: the error detail only for r_code `ng`; `wHtmlAlignStack`: "no `ld hl, $D000` operand exists" is false.
5. **Raw reasons wrong (decisions right)**: `dev_test_config.asm:92,95,111` say "no caller, bank not shown": `Dev_WriteTestConfigImage` is called at 68:4DCF by `Dev_InstallTestConfig` (`farcall` at `registration.asm:679`) after the bank 6 idiom at 68:4DC3, so `$D000` of bank 6 is `wHtmlAlignStack` there, a second role the `DEF` did not disclose; `unreferenced_palette_library.asm:295`: bank 1 is shown (29:520D), the real reason is that no name covers `$DBD0` of bank 1.
6. **By-hand text slips**: `tags.asm` rows 531 and 564 say 10 scenarios (8), 649 and 695 say 4 (5), row 1053 "never ran" (77 executions in 3 scenarios, only absent from the 41 replays); `settings_menu.asm:366` "not seen executed" (96 executions in 3 scenarios); the `CommTime_*_27_*` "byte-for-byte twin" differs in 4 bytes (the call target and the digit table address; the effect is unchanged).
7. **Missed site**: `engine/comm/notice_dialog.asm:480` `Table_CommNotice_DigitCells` (50:438A), eight words `$D0A3, $D083, $D0E4, $D0C4` twice = `wScreenTileMap + $A3/$83/$E4/$C4`: read at 50:4360, dereferenced by `ld [hl], a` at 50:4381 and 50:4388, observed bank 7 only (4 scenarios); the only caller 50:4254 starts with `farcall Tilemap_CopyRectAndAttr` (sets bank 7), then `Sprite_SetPosition` (keeps), `ReadByteFar`, `Divide8` (pure): nameable like the 12 words of ramop9.
8. **Recommendation**: the `BankSwitch_H` family `.*` is wider than its proof (A = 6 covers only the page URL); narrowed to `wBrowserPageUrl`.  Remarks: `wHtmlLinkPtrList` holds 255 entries and the terminator (the 256th entry's terminator lands on `$D800-$D801`, emulated), the same for `wHtmlImageUrlList` (`$E000-$E001`).

Load differs from dereference by design: `inline_images.asm:16` (load bank 4, idiom ends 4C:4859, 6), `:23` (6 to 4C:486E, 4), `mobile_dictionary_view.asm:272` (4C:51BA, 6) and `:278` (4C:51CC, 4), `page_loader.asm:356` (mask 1367, idiom 4C:429E, 6), `page_list.asm:1162` (load 2; `PageList_DrawTextLine` selects 6 at 24:4951 on every character), `page_render.asm:25` (A = 6 at `BankSwitch_H`), `parser.asm:136/164`.

* *Count or value*: none among the 117 (`page_results.asm:59` is the HL load, `ld bc, $FFFF` is line 60 unchanged; `page_list.asm:2335` `c = 0` = 256 = the size exactly); `dialog.asm:414,422,454` are Y,X pairs for `Sprite_SetPosition`.

* *Extents*: every copy, loop and HDMA count checked against the object size: 0 overruns (`bc = $100` on 256-byte objects, `$40` on the 64-byte meta buffers, `$14` within 22, `$1000` on the stream, HDMA `$16/$1A` blocks inside the 1 KiB maps).
