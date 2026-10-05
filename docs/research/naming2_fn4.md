# Naming pass 4 (fn4): the residual neutral `Function_*` labels

> Status: **reference (current)** for the names it adopts.  Manifests: [`analysis/naming2/fn4_renames.tsv`](../../analysis/naming2/fn4_renames.tsv) and the follow-up
> [`fn4b_renames.tsv`](../../analysis/naming2/fn4b_renames.tsv) (two layout functions) (applied with `tools/apply_renames.py`, kind `function`); independent verification: [`naming2_verify_fn4.md`](naming2_verify_fn4.md), whose corrections are already in the manifest
> ([`analysis/naming2/verify_fn4_fixes.tsv`](../../analysis/naming2/verify_fn4_fixes.tsv) lists the changed rows).  Scope: the `Function_<bank>_<addr>` labels that were still neutral after
> naming pass 2 (59 of them).  Neutral labels of other kinds (`Label_`, `Data_`, ...) are not part of this pass.

## 1. Result

| item | count |
|---|---|
| neutral `Function_*` labels before the pass | 59 |
| rows in the manifests | 33 (31 in `fn4_renames.tsv`, 2 in `fn4b_renames.tsv`) |
| names applied | **32** (14 CONFIRMED, 18 PROBABLE) |
| HYPOTHESIS record (new name == old name, never applied) | 1 (`Function_24_42B0`) |
| labels left neutral | 27 (the 26 without a row and `Function_24_42B0`), section 4 |
| references rewritten | 69 in code, in 29 files; 32 alias labels kept (the old neutral name stays below the new one) |
| ROM | byte-identical (`SHA-256 OK 6d802e66...`, `sym_check OK`, `make` prints `RESULT: IDENTICAL`) |

Verification (in the real tree, after the verifier's corrections were merged into the manifest):

```
python3 tools/apply_renames.py --manifest analysis/naming2/fn4_renames.tsv --strict
apply_renames: verification: SHA-256 OK 6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570, sym_check OK
apply_renames: summary: 31 row(s): 30 applied, 0 already applied, 1 HYPOTHESIS (not applied), 0 below min-status, 0 refused/malformed; 28 file(s) changed, 63 code + 0 comment + 0 string reference(s) renamed, 30 alias(es) added
python3 tools/apply_renames.py --manifest analysis/naming2/fn4b_renames.tsv --strict      # the two layout rows, same checks
apply_renames: summary: 2 row(s): 2 applied, 0 refused; 1 file(s) changed, 6 code references renamed, 2 alias(es) added
```

`tools/tidy_comments.py --check`, `tools/localize_labels.py --check`, `tools/gfx_export.py check`, `tools/sprite_chain_check.py`, `tools/tree_check.py` and `tools/test_apply_renames.py` pass afterwards.

## 2. Method

1. **Census.**  A list of the 59 neutral labels with their reference count in the source, their execution count in `analysis/coverage_union.tsv` (64 natural scenarios; `coverage_forced.tsv` never counts), the
   status of the existing region comment and the file and line.  Twenty-six of them are executed, the others are unreferenced or only reached from dead code.
2. **Reading.**  For each label the code, every caller (raw address forms included) and the neighbours that it falls into or that fall into it.  A name is proposed only when the role is read from the code and
   the callers; the prefix is the subsystem of the neighbours (`TextEngine_`, `Mobile_`, `Kbd_`, `Abook_`, ...).  A function whose body is a lone `ret` is `Stub_Nop_<bank>_<addr>`, after the precedent
   `Stub_Nop_7F_61FC` (`engine/comm/time_hooks.asm`).
3. **Statuses** follow `STYLE.md` section 1: CONFIRMED = the code itself shows it and the code ran in the natural traces; PROBABLE = a consistent reading with one inferred step, or code that never ran
   naturally (never-executed code is capped at PROBABLE, a forced run does not raise it).
4. **Independent check.**  A reader with a fresh context re-derived every row from the code ([`naming2_verify_fn4.md`](naming2_verify_fn4.md)): 17 upheld, 12 corrected (two of them renamed), 1 downgraded, 1 retracted; the two layout rows proposed afterwards were checked the same way (section 8 of that note: both corrected, one renamed).

## 3. The 32 applied names

Stubs (a single `ret`; the name says what the body does and nothing about why it is empty):

| label | name | status | note |
|---|---|---|---|
| `Function_68_4282` | `Stub_Nop_68_4282` | CONFIRMED | farcalled first thing in `PasswordChange_Run`; 175 hits in 13 scenarios |
| `Function_5C_5266` | `Stub_Nop_5C_5266` | CONFIRMED | `call nz` after a real D-pad test in `CommErr_ShowScreen_Idle`; taken 103 times |
| `Function_24_53FC` | `Stub_Nop_24_53FC` | PROBABLE | its only caller is the dead `call nz` of section 5; never executed |
| `Function_24_53FD` | `Stub_Nop_24_53FD` | CONFIRMED | called right after `PageList_ActionMenuInit`; 61 hits in 8 scenarios |
| `Function_48_48BB` | `Stub_Nop_48_48BB` | CONFIRMED | 13 farcall sites at screen entries (10 natural: 3,427 hits in 58 scenarios, 3 forced-only debug screens) |
| `Function_26_5343` | `Stub_Nop_26_5343` | CONFIRMED | first call of `MailSession_UpdateTimerDisplay`; 171,411 hits in 22 scenarios |
| `Function_2E_4EB1` | `Stub_Nop_2E_4EB1` | CONFIRMED | four sites in `tidy_screen.asm` after `Gfx_UploadBgMapBuffers`; 34 hits in 7 scenarios |
| `Function_7F_61E6` | `Stub_Nop_7F_61E6` | PROBABLE | twin of `Stub_Nop_24_53FC` in the unreferenced page-list prototype; never executed |
| `Function_7F_61E7` | `Stub_Nop_7F_61E7` | PROBABLE | twin of `Stub_Nop_24_53FD`; never executed |

Text engine (`home/text.asm`), the pieces of the glyph routines (each ends by falling into the next):

| label | name | status | note |
|---|---|---|---|
| `Function_00_1059` | `TextEngine_DrawWideGlyph_BlitLeft` | CONFIRMED | blits the left half (`$C0A0`) at (`hTextX`, `hTextY`) when `hTextX < $A0`; 185,150 hits |
| `Function_00_1079` | `TextEngine_DrawWideGlyph_BlitRight` | CONFIRMED | `hTextX += 6`, blits the right half (`$C0B8`); also the target of the clip jumps; 185,149 hits |
| `Function_00_10A3` | `TextEngine_DrawWideGlyph_AdvanceX` | CONFIRMED | `hTextX += 6` and `ret`; 185,147 hits |
| `Function_00_10C6` | `TextEngine_DrawNarrowGlyph_Blit` | CONFIRMED | blits the ASCII glyph (`$C0A0`) after `Glyph_LoadAscii`; 40,698 hits |
| `Function_00_10DB` | `TextEngine_DrawNarrowGlyph_AdvanceX` | CONFIRMED | `hTextX += 6` and `ret`; target of the clip jumps at `10B5` / `10BB`; 40,698 hits |

(No clip jump of either glyph path was ever taken in the traces: the clip conditions are code reading, the main path is demonstrated.)

Home and library:

| label | name | status | note |
|---|---|---|---|
| `Function_00_158D` | `Dial_CopySelectedNumber_AfterModeCheck` | CONFIRMED | return point of `farcall Settings_GetHiddenModeFlag` in `Dial_CopySelectedNumber`: default number table (flag 0) or the SRAM entry chosen by `sSettingsSelectedDialEntry`; 79 hits |
| `Function_00_032E` | `Boot_MainLoop_Repeat` | PROBABLE | `jp` back to `farcall Main_Run`; `Main_Run` never returns, so it never ran |
| `Function_00_14D1` | `CopyStringMax_ZeroSrcOnEmpty` | PROBABLE | entry variant of `CopyStringMax`: with BC = 0 it stores a `$00` at the *source* and returns; the four callers all pass BC = `$10`, so that branch cannot run from them |
| `Function_75_5E31` | `MobileSDK_RxDispatch_ResetBufferOnReturn` | CONFIRMED | its address is pushed as the return address before the reply handlers run (`75:5B6D` / `5B70`); every handler `ret` is at stack depth 0; 19,653 pushes and jumps |
| `Function_75_5F96` | `Mobile_PacketBuildFooter_SumByte` | CONFIRMED | loop body of the 16-bit byte sum of `Mobile_PacketBuildFooter` (backwards, B = bytes left); 166,194 hits |
| `Function_75_673A` | `MobileSDK_ResetRxWindowAndResultPtr` | PROBABLE | stores `$FF` at `C70D` (`wMobileSDK_ResultPointer`, a dual-use PROBABLE role) then falls into `MobileSDK_ResetRxWindow`; 340 hits in 26 scenarios |

HTML line layout (`engine/html/layout.asm`, bank 74; follow-up manifest `fn4b_renames.tsv`):

| label | name | status | note |
|---|---|---|---|
| `Function_74_55BE` | `Html_Layout_AddRecordToLine` | PROBABLE | accounts for the 16-byte record just appended (HL, preserved): at an empty line it first calls `Html_Layout_BeginLineAndPlaceFloats`; returns when bit 7 (pending) of `[HL+9]` is clear; `cursor hRam_FFC4:FFC5 += width` and merges the record height into the line's `hRam_FFC6` (extent above the baseline) / `hRam_FFC7` (below it) by the vertical-alignment bits (`and $30`); 11,694 hits in 16 scenarios on this path; the no-fit path and the `$10/$20/$30` tests never ran |
| `Function_74_57AD` | `Html_Layout_BeginLineAndPlaceFloats` | PROBABLE | called when the line is empty: `Html_Layout_GetLimitsAtY` puts the cursor back at the left limit, sets the right limit and zeroes `hRam_FFC6/FFC7` (the only effect ever seen: 4,481 hits), then walks the page's record list and places pending left (`$0C`) / right (`$04`) float records, clearing bit 7; the float code never ran (float records only come from `<img align=left\|right>`, which no traced page used) |

Screens:

| label | name | status | note |
|---|---|---|---|
| `Function_68_4495` | `Dial_SkipStringThenSetSelectedEntry` | PROBABLE | skips one NUL-terminated string and *falls into* `Settings_SetSelectedDialEntry` (68:4499), which is what persists the selection in `Dial_SelectEntryFromList`; never executed |
| `Function_2C_60B3` | `AddrPick_DrawSlotNames` | PROBABLE | draws the six slot names (E = `$28`); dead twin of the executed `SaveSenderAddr_DrawSlotNames` (2A:422C) |
| `Function_2C_5CD2` | `AddrPick_SetListAreaAttrs` | PROBABLE | writes BG attributes (`$08` tile bank 1, `$04` palette 4) into the list area, VRAM then WRAM 7; never executed |
| `Function_2F_4496` | `Abook_Clear16AtHlAndEditAddressBuf` | PROBABLE | zeroes 16 bytes at HL (the slot record + `$10` in SRAM that `Abook_ProbeSlot` left) and the 64 bytes of `wEditAddressBuf`; it does **not** clear `wEditNameBuf`; 14 hits in 8 scenarios |
| `Function_73_62D2` | `BrowserStart_DescIndex_AdjustItem1` | PROBABLE | sets the ticker entry index B to 5 when `wRam_C0F8` is non-zero (the flag is never written: vestigial) |
| `Function_73_62DA` | `BrowserStart_DescIndex_AdjustItem2` | PROBABLE | B = 6 when `wRam_C0F9` is non-zero (never written); never executed |
| `Function_73_62E2` | `BrowserStart_DescIndex_AdjustItem3` | PROBABLE | `inc b` when bit 7 of `sSram_A9ED` is set; never executed |
| `Function_55_6041` | `Kbd_AdjustColRowForSticky` | PROBABLE | keyboard type 1 / dir 0 / sticky row 3: `inc b`; type 3 / dir 2 / sticky column `$11`: `inc c`; 444 hits in 13 scenarios |
| `Function_65_481A` | `Startup_VerifySaveDataDeadVariant` | PROBABLE | dead variant of `Startup_VerifySaveData` (different first check, two stale `call $21A0` into zero padding); never executed |
| `Function_7F_4E85` | `Canvas_UploadToVramWrapper` | PROBABLE | `call Canvas_UploadToVram ; ret`; only caller is `Canvas_RunSampleDemo` (the text-canvas demo) |

## 4. Labels left neutral (27)

A neutral name is a claim of ignorance, not an error.  Unreferenced labels stay neutral unless they have an executed twin (the rule that kept `Function_24_42B0` neutral).

| label | where | refs | executed | note |
|---|---|---|---|---|
| `Function_24_42B0` | `engine/browser/page_list.asm:370` | 0 | never | HYPOTHESIS: copies the URL `http://www.goo.ne.jp/` to `$D500` and a Shift-JIS title (くーくー) to `$D3C0` in WRAM 6, the layout `PageList_SaveCurrentPage` reads; nothing in the ROM calls or points to it; the idea `PageList_CopyGooUrlAndTitle` is recorded, "Default" has no support |
| `Function_68_5D2F` | `engine/account/password_entry.asm:26` | 0 | never | unreferenced, body HYPOTHESIS |
| `Function_4E_6172` | `engine/browser/canvas.asm:100` | 0 | never | unreferenced, body HYPOTHESIS |
| `Function_73_6143` | `engine/browser/start_choice.asm:241` | 0 | never | unreferenced, body HYPOTHESIS (reads the never-written `wRam_C0F8`) |
| `Function_70_46A6` | `engine/comm/comm_scene.asm:915` | 0 | never | unreferenced, body HYPOTHESIS |
| `Function_29_5090` | `engine/gfx/unreferenced_palette_library.asm:7` | 1 | never | head of the unreferenced palette library, body HYPOTHESIS |
| `Function_29_511E` | `engine/gfx/unreferenced_palette_library.asm:133` | 1 | never | same file, only reached from the library |
| `Function_6C_61AC` | `engine/help/help_script.asm:1018` | 0 | never | unreferenced, PROBABLE body, no live twin |
| `Function_55_6EAA` | `engine/keyboard/type_helpers.asm:26` | 1 | 1,268 hits / 25 scenarios | keyboard-type predicate (table `Data_55_6EB5`: 1 for types 6-10), consulted by `Kbd_Run` only when `wKbdMode` = 2 to put the cursor on the OK cell; what decides that (the `wKbdMode` values, `Kbd_Run`'s C argument) is not understood, as in `naming2_g4_apps_b.md` |
| `Function_55_6EC0` | `engine/keyboard/type_helpers.asm:43` | 1 | 14,425 hits / 35 scenarios | the complementary predicate (table `Data_55_6ECB`: 1 for types 0-5), consulted when `Kbd_Run`'s C argument is non-zero; same reason |
| `Function_55_6EEC` | `engine/keyboard/type_helpers.asm:79` | 1 | never | predicate (table `Data_55_6EF7`: types 5-10); its only caller is the unexecuted HYPOTHESIS code at `55:5DF5` |
| `Function_2D_4E42` | `engine/mail/body_editor.asm:1038` | 0 | never | unreferenced wrapper (WRAM 1, calls `4E54`), PROBABLE |
| `Function_2D_4E54` | `engine/mail/body_editor.asm:1055` | 1 | never | scan of the `$D400` body buffer in 2-byte units for `$0D` / `$00`; its only caller is the dead `4E42` |
| `Function_2D_4F03` | `engine/mail/body_editor.asm:1208` | 2 | 45 hits / 10 scenarios | called right after `MailBody_SetupScreen` at the two editor entries; returns A = 1 when row 7 of the body has no row pointer, `$FF` when its last cell is used, else 0; neither caller uses A: role not determined |
| `Function_26_5106` | `engine/mail/mail_session_screen.asm:93` | 1 | 49 hits / 7 scenarios | called once (`mail_session.asm:873`); sums negated 16-bit fields of `wMailSessionBlock` and returns 0 unless they cancel; role not determined |
| `Function_2B_64F1` | `engine/mail/mail_viewer_sender.asm:61` | 0 | never | unreferenced, body HYPOTHESIS |
| `Function_2B_687C` | `engine/mail/mail_viewer_sender.asm:504` | 0 | never | unreferenced, body HYPOTHESIS |
| `Function_2B_6CF5` | `engine/mail/mail_viewer_sender.asm:1239` | 0 | never | unreferenced, body HYPOTHESIS |
| `Function_27_4EC0` | `engine/mail/send_receive.asm:1826` | 0 | never | unreferenced, PROBABLE body, no live twin |
| `Function_23_6D61` | `engine/mail_server/delete_messages.asm:7` | 0 | never | unreferenced, body HYPOTHESIS (entries replaced by `ret` around it) |
| `Function_2E_4EB2` | `engine/mail_server/tidy_screen.asm:395` | 0 | never | the bytes after `Stub_Nop_2E_4EB1`, unreferenced, body HYPOTHESIS |
| `Function_2E_4F9A` | `engine/mail_server/tidy_screen.asm:533` | 0 | never | unreferenced, body HYPOTHESIS |
| `Function_7C_7D8D` | `engine/main/navigation.asm:301` | 0 | never | runs the three `CommScene` kinds in turn and jumps to `Nav_MobileSettings_UsageFee`; unreferenced, no live twin |
| `Function_54_41C5` | `engine/mobile/connection.asm:271` | 0 | never | unreferenced, starts a mobile task (retries 3, kind 1, step 0), PROBABLE body |
| `Function_75_7E89` | `lib/mobile/main.asm:10069` | 0 | never | unreferenced, PROBABLE body |
| `Function_00_0D34` | `home/multiply_divide.asm:7` | 0 | never | unreferenced, PROBABLE body |
| `Function_00_0A2A` | `home/sprites.asm:166` | 0 | never | unreferenced, PROBABLE body |

## 5. What the pass found out (and corrected)

* **Two `call nz` that cannot be taken.**  `24:4D45` (`page_list.asm`) and `7F:5ADB` (`page_list_prototype.asm`) are `ldh a, [hJoyHeld]` followed by `call nz, Stub_Nop_...`.  LDH sets no flags, so Z is the one the
  preceding farcall leaves (`FarCall_Common` ends in `BankSwitch_H`, whose last flag write leaves Z = 1 for a ROM caller): the call is dead by construction.  `24:4D45` ran 38,854 times with 0 taken although
  the A button was pressed 151 times there; a replay of the real code with `hJoyHeld = $FF` gives Z = 1 and no call.  A tree-wide scan finds only these two sites that branch on farcall flags; both carry a comment now.
* **`Stub_Nop_48_48BB`** is the one-`ret` stub called by 13 farcall sites at screen entries (ten of them follow `FillBytes $C0D4, $FC`).  The older header said "patched-out hook"; nothing shows what was patched
  (the function after it, `Sram_VerifyChecksum3ResetOnMismatch`, starts with its own `call`, so the `ret` is an extra byte), the header now says "one-ret stub".
* **`BrowserStart_DescIndex_Adjust*` are vestigial in this ROM.**  B is the 4-byte entry index handed to `Ticker_Start` (`BrowserStart_StringTable` has two entries); `wRam_C0F8` / `wRam_C0F9` are only ever read,
  so B = 5 and 6 (and 4 from the third helper) would index outside the table; and `wRam_C0E5` is only 1 or 2 there, so "item 1" is the page-list choice and items 2 and 3 are never produced.
* **`Abook_Clear16AtHlAndEditAddressBuf`** does not clear the name buffer (`DE = $D514` is loaded and never used); the first reading of it as "clear the edit buffers" was wrong and is the reason the verifier renamed it.
* **`Startup_VerifySaveDataDeadVariant`**: both `call $21A0` land in the zero padding `00:2183-3FFF` (7,776 bytes from `$21A0`), stale code of another build; what they would write cannot be said.
* **`Dial_SkipStringThenSetSelectedEntry`** is a fall-through into `Settings_SetSelectedDialEntry` (68:4499), which has four other callers: a replay of `Dial_SelectEntryFromList` shows that the implicit store is
  what persists the selection (`$B013` decodes to B), so the name states it.
* **`CopyStringMax_ZeroSrcOnEmpty`**: the `BC = 0` branch exists only at entry and can not be reached from any of the four known callers (all pass `$0010`); a clearer name would be `..._ZeroSrcIfMaxZero`.
* **`MobileSDK_RxDispatch_ResetBufferOnReturn`**: a static stack-depth walk over `jp`/`jr` from the default path and the 13 handlers finds every reachable `ret` at depth 0 (seven of those `ret`s never ran, so for those
  the evidence is static).

## 6. The two layout functions (follow-up)

`Function_74_55BE` and `Function_74_57AD` are the central steps of the HTML line layout.  What the verified reading established (record layout, flags and line state; the HRAM names of these bytes are still neutral,
the overlay aliases of `hRam_FFC2-FFCF` are a separate step):

* **Records.**  16 bytes in the WRAM bank `hRam_FFBA`: `+4:+5` width, `+6` height, `+8` kind (1 text run, 4 image, 5 loaded image), `+9` flags: bit 7 = **pending** (set by `Html_Layout_AppendRecord`, cleared when the record is placed;
  `Html_Layout_GetLimitsAtY` ignores pending records), `and $0C` = horizontal alignment (`$04` right, `$08` centre, `$0C` left; floats are `$04` and `$0C`), `and $30` = vertical (`$10` top, `$20` middle, `$30` bottom).
  The encoding is confirmed by data, not only by code: the keyword table `Html_AlignValueNames` (`74:40C4`) maps right = `$04`, top = `$10`, centre = `$08`, middle = `$20`, left = `$0C`, bottom = `$30`.  Placement overwrites `+0..+7`
  with x, y, right edge and bottom.
* **Line state.**  `hRam_FFC2:FFC3` right limit, `hRam_FFC4:FFC5` cursor / left limit, `hRam_FFC6` extent above the baseline and `hRam_FFC7` below it (`Html_Layout_PlaceLine`: baseline = Y + FFC6, next line Y = Y + FFC6 + FFC7),
  `hRam_FFC8:FFC9` line Y.  In every traced run FFC6 was 0 and the whole line height sat in FFC7.
* **`Html_Layout_AddRecordToLine`** is called 11,694 times (74:54F1 3,681, 74:5505 2,156, 74:55BA 5,857; text runs are accounted twice, at append with width 0 and after `Html_Layout_CloseRunRecord` with the final width).
  "Wrap" or "Fit" would over-claim: by a replay on synthetic records, the no-fit path calls `Html_Layout_PlaceLine`, which places every pending record up to the one that overflows, itself included, so the retry returns at once.
* **`Html_Layout_BeginLineAndPlaceFloats`** is the only code that resets the cursor between lines (via `Html_Layout_GetLimitsAtY`), which is why the name starts with "BeginLine" and pairs with `Html_Layout_EndLine`; the
  float placement half never ran.  Float records can only come from `<img align=left>` / `align=right` (`Html_Tag_Img` at `74:4EB1` stores the alignment in `hRam_FFD5`, merged into `hRam_FFB2` at `74:4E5A` and `74:4EFA`; centre is
  deliberately skipped); `Html_Layout_ClearAllFloats` and `<br clear>` exist for them.

## 7. Reproduce

```bash
python3 tools/apply_renames.py --manifest analysis/naming2/fn4_renames.tsv --dry-run     # 31 rows: 30 to apply, 1 HYPOTHESIS
python3 tools/apply_renames.py --manifest analysis/naming2/fn4_renames.tsv --strict      # in a private copy first; SHA-256 must stay OK
python3 tools/apply_renames.py --manifest analysis/naming2/fn4b_renames.tsv --strict     # the two layout rows
```
