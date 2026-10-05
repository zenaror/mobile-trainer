# RAM naming pass 2 (ram2): WRAM0 and HRAM variables

> Status: **reference (current)** for the names it adopts.  Manifest: [`analysis/naming2/ram2_renames.tsv`](../../analysis/naming2/ram2_renames.tsv)
> (applied with `tools/apply_renames.py`, kind `const`).  Scope of this pass: the still-neutral names in `ram/wram.asm` at `$C000-$CFFF` (WRAM bank 0, bank independent) and in
> `ram/hram.asm` at `$FF80-$FFFE` (HRAM).  Banked addresses (`$D000-$DFFF`, SRAM `$A000-$BFFF`) are **not** renamed here (section 6).

## 1. Result

| item | count |
|---|---|
| neutral names in scope before the pass (`wRam_C...` 162 + `hRam_FF...` 55) | 217 (192 of them referenced symbolically in the source) |
| rows in the manifest | 79 |
| renames applied | **49** (14 CONFIRMED, 35 PROBABLE) |
| HYPOTHESIS rows (new name == old name, never applied; ideas and the reason they are not names) | 30 |
| neutral names left in scope | 168 (121 `wRam_C...`, 47 `hRam_FF...`) |
| references rewritten | 426 in code + 9 in comments, 46 files |
| ROM | byte-identical (`SHA-256 OK 6d802e66...`, `sym_check OK`) |

Verification, in a private copy of the tree (`rsync -a --exclude .git --exclude traces --exclude build`):

```
python3 tools/apply_renames.py --manifest analysis/naming2/ram2_renames.tsv --strict
apply_renames: verification: SHA-256 OK 6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570, sym_check OK
apply_renames: summary: 79 row(s): 49 applied, 0 already applied, 30 HYPOTHESIS (not applied), 0 below min-status, 0 refused/malformed
```

Self-checks done before applying: every `old_name` is defined exactly once (`DEF Old EQU` in `ram/*.asm`), the 49 new names are unique, legal, and do not collide with any
definition (three of them, `wMobileErrorDetail`, `wRegistrationStage`, `wSavePasswordFlag`, appear only inside the old `naming ideas in conflict` *comments* of `ram/wram.asm`,
which is what they were the unadopted ideas for).

## 2. Method

1. **Census and index.**  `analysis/ram_census.tsv` (accesses per address) plus a scratch script that indexes every symbolic use (`wRam_CXXX` / `hRam_FFXX`) in the `.asm` files with the
   enclosing *primary* label (alias labels skipped), the instruction and two lines of context.  Ranking by number of distinct **named** functions touching the byte: `hRam_FFB0` 122,
   `wRam_C27D` 104, `wRam_C27C` 96, `wRam_C0E5` 52, `hRam_FFB1` 42, `wRam_C27E` 42, `hRam_FFBA` 38 ...
2. **Reading.**  For the candidates every reader and writer was read in context (not only the `ld` line): values written, bit tests, loop bounds, what the consumer does with the value.
   Earlier naming notes (`naming_g1..g8.md`, `naming_sdk.md`, `naming2_*.md`, the `naming ideas in conflict` texts in `ram/*.asm`, `config/ram/census.tsv`) were used as *leads*, never as proof.
3. **Bar for a name.**  At least two independent pieces of evidence (e.g. written by X and tested by Y whose roles fix the meaning; a counter incremented in a loop with a known bound;
   a value copied to/from a hardware register or a named field).  Word/array claims only with >= 3 consistent accesses (sizes are *not* added to the `DEF` lines: the tool only renames).
4. **Overlay rule (new, see section 4).**  A byte that is demonstrably used with different meanings by different screens/subsystems gets **no** semantic name; the roles are recorded
   here and as HYPOTHESIS rows.  Exception: a byte inside an overlay window that only one screen uses (the top-menu cursor slide) is named with that screen's prefix.
5. **No trace was run for this pass.**  Execution counts quoted in the evidence come from the existing `[executed in N scenarios]` comments of the source and
   `analysis/coverage_union.tsv`; nothing here is based on a new emulator run.  Statuses follow STYLE.md: CONFIRMED = the code itself shows it (also for code executed in traces),
   PROBABLE = consistent reading with one inferred step (stated in the evidence column of the manifest).

**Limit of the rename tool (documented, not a defect of the pass).**  `apply_renames.py` rewrites identifiers.  Many functions access these bytes through a literal address
(`ld hl, $C26F` and friends) and therefore keep showing the number: `$C26F` 96 literal uses next to the symbol's 15, `$C26E` 35, `$C580` 21, `$C10E` 6.  Converting those literals
to names is a separate source edit (not byte-neutral to review automatically); it is not part of this manifest.

## 3. Names adopted (49)

Columns: address, old neutral name, new name, status, key evidence.  The full evidence (addresses, function names, values) is the last column of the manifest.

| addr | old | new | status | key evidence |
|---|---|---|---|---|
| `C26E` | `wRam_C26E` | `wTimerAWarnMinute` | PROBABLE | set to 9 at session starts, compared with wTimerAMinutes (+30 s) in a test copied 29 times, +$0A up to $45 on a hit; two earlier namers agree |
| `C26F` | `wRam_C26F` | `wTimerAWarnFlags` | PROBABLE | bit0 warning raised (set by the test, cleared by CommNotice_ShowDialogMode0/1), bit1 final warning done (cleared by Int_VBlank at 70 min) |
| `C273` | `wRam_C273` | `wMobileErrorDetail` | CONFIRMED | HL of MobileAPI($00) saved by Mobile_SaveLastResult, reloaded by Mobile_ShowLastError for CommErr_ShowScreen; 6 copy sites from wMobileResultDetail |
| `C274` | `wRam_C274` | `wMobileErrorDetailHi` | CONFIRMED | H byte of the same word; compared with 1/3 as class digit |
| `C277` | `wRam_C277` | `wRegistrationStage` | PROBABLE | SRAM1 B010 xor $A5 restricted to 1-3, read by Registration_Run to choose the resume path |
| `C27A` | `wRam_C27A` | `wSavePasswordFlag` | PROBABLE | from SRAM1 B088, set by the confirm screens, gates Registration_SavePassword, preset of PwSaveConfirm cursor |
| `C1D0` | `wRam_C1D0` | `wCommNoticeMode` | PROBABLE | first argument of CommNotice_ShowDialog (+1), Mode0/Mode1 wrappers store 0/1; selects the choice variant |
| `C1D1` | `wRam_C1D1` | `wCommNoticeGfxSet` | PROBABLE | second argument of CommNotice_ShowDialog; RunDialog loads tile set A when 0; = wCommSessionKind in browser flows |
| `C1CD` | `wRam_C1CD` | `wCommNoticeScreen` | PROBABLE | 1-8, indexes Table_CommNotice_Screens and Table_CommNotice_DigitCells |
| `C14E` | `wRam_C14E` | `wCommNoticeFrames` | PROBABLE | frame counter 0-59 of the notice input loop |
| `C14F` | `wRam_C14F` | `wCommNoticeSeconds` | PROBABLE | +1 per 60 frames; at 10 the dialog closes itself |
| `C12E` | `wRam_C12E` | `wFarAccessTemp` | CONFIRMED | temp byte of ReadByteFar (read byte) and WriteByteFar (bank argument) |
| `C2E3` | `wRam_C2E3` | `wJoySavedRepeatDelay` | CONFIRMED | saved wJoyRepeatDelay at 4 open sites, restored as B by 3 close sites (BrowserMenu_Close swaps B/C) |
| `C2E4` | `wRam_C2E4` | `wJoySavedRepeatInterval` | CONFIRMED | saved wJoyRepeatInterval, restored as C by 3 close sites |
| `C2A8` | `wRam_C2A8` | `wCommSceneScrollX` | CONFIRMED | copied to rSCX by CommScene_ApplyScrollFrame, stepped by ScrollIncrement/Decrement |
| `C2D7` | `wRam_C2D7` | `wTimerAExtra` | PROBABLE | 4th byte of the timer-A record, cleared with it, never advanced by Int_VBlank; unit unknown |
| `C2B3` | `wRam_C2B3` | `wKbdRunArgB` | CONFIRMED | B argument of Kbd_Run (default 1, used for type 5) |
| `C2B4` | `wRam_C2B4` | `wKbdRunArgC` | CONFIRMED | C argument of Kbd_Run (probably the OK flag, only the argument role is CONFIRMED) |
| `C2B6` | `wRam_C2B6` | `wKbdNeighbourCell` | PROBABLE | neighbour cell from the 6-byte Table_Kbd_NeighbourRecords record, becomes wKbdCursorCell |
| `C2B7` | `wRam_C2B7` | `wKbdNeighbourFlagsA` | PROBABLE | record byte 4, bits 7-4 per direction tested by the four DirTable handlers |
| `C2B8` | `wRam_C2B8` | `wKbdNeighbourFlagsB` | PROBABLE | record byte 5, bits 7-4 per direction tested by Kbd_UpdateSticky_Store/ClearDirTable |
| `C179` | `wRam_C179` | `wHelpScriptDelayCounter` | PROBABLE | frame countdown at the top of HelpScript_StepText |
| `C178` | `wRam_C178` | `wHelpScriptGlyphDelay` | PROBABLE | reload value of the countdown, default 6, set by opcodes $22-$2F |
| `C177` | `wRam_C177` | `wHelpScriptPictureId` | CONFIRMED | id of the picture shown; ShowPicture returns when equal, indexes the 5-byte PictureTable |
| `C1A8` | `wRam_C1A8` | `wHelpScriptColumn` | PROBABLE | glyph column of the text line, wraps at $10 |
| `C1A9` | `wRam_C1A9` | `wHelpScriptLineTile` | PROBABLE | tile index of the line start, +$20 per line |
| `C1AB` | `wRam_C1AB` | `wHelpScriptAdvanceMode` | PROBABLE | 0 normal, 1 A held, 2 B pressed (skip) |
| `C1B0` | `wRam_C1B0` | `wHelpScriptAltPtr` | PROBABLE | pointer set by opcode $08, loaded by the Select handler |
| `C1B1` | `wRam_C1B1` | `wHelpScriptAltPtrHi` | PROBABLE | high byte of the above |
| `C0DB` | `wRam_C0DB` | `wTopMenuCursorTargetX` | CONFIRMED | target x from Table_TopMenu_CursorTargets |
| `C0DC` | `wRam_C0DC` | `wTopMenuCursorTargetY` | CONFIRMED | target y from the same table |
| `C0D5` | `wRam_C0D5` | `wTopMenuCursorXFrac` | PROBABLE | fraction of the cursor x (8.8) in the top-menu slide |
| `C0D7` | `wRam_C0D7` | `wTopMenuCursorYFrac` | PROBABLE | fraction of the cursor y (8.8) |
| `C0DD` | `wRam_C0DD` | `wTopMenuCursorStepXHi` | PROBABLE | integer part of the x step (signed 8.8) |
| `C0DE` | `wRam_C0DE` | `wTopMenuCursorStepXLo` | PROBABLE | fraction of the x step |
| `C0E0` | `wRam_C0E0` | `wTopMenuCursorStepYLo` | PROBABLE | fraction of the y step |
| `C0E1` | `wRam_C0E1` | `wTopMenuCursorStepsLeft` | CONFIRMED | remaining frames of the slide |
| `C1DC` | `wRam_C1DC` | `wBrowserPendingMessage` | PROBABLE | message id for Dialog_ShowMonitored on re-entry of the page view; 0 none |
| `C2C4` | `wRam_C2C4` | `wBrowserDialSlotPlus1` | PROBABLE | dial slot + 1 (inc a after Settings_GetSelectedDialEntry), C argument of Mobile_BeginConnect |
| `C25E` | `wRam_C25E` | `wPop3SavedSramBank` | CONFIRMED | hSRAMBank saved by the POP3 starters, restored by the poll/finish |
| `C2F3` | `wRam_C2F3` | `wShadowOAMNextOffset` | CONFIRMED | next free shadow-OAM offset (Sprite_UpdateAll writes it, Browser_DrawCommTimer appends there) |
| `FFF0` | `hRam_FFF0` | `hSpriteSlideOffsetX` | PROBABLE | added to the sprite x by Sprite_HookAddSlideOffset; cleared each Sprite_UpdateAll |
| `FFF1` | `hRam_FFF1` | `hSpriteSlideOffsetY` | PROBABLE | added to the sprite y; stepped by Dialog_SlideIn/SlideOut with rWY |
| `FFD9` | `hRam_FFD9` | `hHtmlListIndent` | PROBABLE | list indent (+$0C/$12 per <ul>/<ol> level) of the HTML parser |
| `FFD8` | `hRam_FFD8` | `hHtmlLineIndent` | PROBABLE | indent applied to laid-out lines, copied from the list indent, added to the left limit |
| `FFDA` | `hRam_FFDA` | `hHtmlAlignAdjust` | PROBABLE | 16-bit negated text width used to centre/right-align a line (Html_Tag_Hr, PlaceLine) |
| `FFDB` | `hRam_FFDB` | `hHtmlAlignAdjustHi` | PROBABLE | high byte |
| `FFDC` | `hRam_FFDC` | `hHtmlLinkTextStart` | PROBABLE | pending text run position when <a href> opened; equal at </a> means empty link |
| `FFDD` | `hRam_FFDD` | `hHtmlLinkTextStartHi` | PROBABLE | high byte |

### Notes on individual names

* **Timer-A warning pair (`wTimerAWarnMinute/Flags`).**  The test that uses them is copy-pasted 29 times (27 outside the unreferenced page-list prototype) in 13 files (registration verify, browser page list/view/inline
  images/loader/menus, mail sessions, mail-server delete flows, password change, comm error screen, dialog): `bit 4,[wTimerEnable]` (timer A), `bit 0,[C26F]`, `cp` against `wTimerAMinutes`, `wTimerASeconds >= $1E`, then `bit 1` / `+$0A` / cap `$45`
  and `A=$FF`.  `Int_VBlank` (00:03BA) clears bit1 when timer A reaches 70 minutes (`cp $46`).  Two earlier namers (g2 `wConnWarnMinute`, g7 `wOnlineWarnMinute`) independently gave the same role
  but different names ("connection time" vs "online time"); the neutral `TimerA` form avoids deciding what timer A measures (still PROBABLE).
* **Error detail word (`wMobileErrorDetail`).**  Sits between `wMobileErrorCode` (C272) and `wMobileErrorExtra` (C275).  CONFIRMED because both ends are visible: stored from HL of `MobileAPI($00)` and
  reloaded into HL for `CommErr_ShowScreen` together with the error code.  Two callers (`Browser_LoadPage_Fail` and the block `4C:4026-402C`, `PasswordChange_State_WaitResponse`; an earlier version of this note named `Label_4C_4138`, which has no such store: naming pass 5) store four decoded ASCII-BCD digits of a server reply
  code into the same two bytes, so the word is "detail of the last failure", not always an API HL.  The `DEF` lines still say `size 1`; `C273/C274` is a word (hi byte named `...Hi`).
* **Help-script interpreter (bank 6C).**  All nine bytes are used only by `engine/help/help_script.asm` (single subsystem, no overlay): text stepper `HelpScript_StepText` 6C:6009, reader
  `Label_6C_5B47` 6C:5B47, input table `HelpScript_InputTable`.  Not named from the same code: `C176`, `C17B`, `C17C` (written by the opcode class $5x, never read), `C17A` (glyph plane-clear flag
  toggled by opcodes $20/$21: the effect is visible, the purpose is not), `C1AA` (+2 per line, never read), `C1AC` (last opcode, never read), `C0D9/C0DA` (waiting-arrow blink, in the overlay window).
* **Keyboard (bank 55).**  `wKbdRunArgB/C` are CONFIRMED as arguments (first instruction of `Kbd_Run` stores C, B is stored only for type 5).  Whether C is the "OK enabled" flag (g7) is PROBABLE
  only; hence the argument names.  `wKbdNeighbourFlagsA/B` take the record layout (bytes 0-3 neighbours L/R/U/D, bytes 4-5 flag bytes) from `naming_g5.md`; the code reads them as four
  bit tests each (bits 7-4), `A` when a move is computed, `B` when the sticky column/row is updated.
* **Top-menu cursor slide (bank 1F).**  Eight bytes of the `C0D4-C0E1` window are used only by `TopMenu_*`; they form a consistent fixed-point animation: position `C0D4:C0D5` (x, 8.8) and
  `C0D6:C0D7` (y, 8.8), per-frame step `C0DD:C0DE` / `C0DF:C0E0` (signed 8.8), frames left `C0E1`, target `C0DB` (x) / `C0DC` (y) loaded from `Table_TopMenu_CursorTargets`, direction bits in
  `C10E`.  `C0D4`, `C0D6` and `C0DF` (the integer parts) are **shared** with other screens and stay neutral, hence half of each pair is named (see section 4).
* **`wBrowserPendingMessage` (C1DC).**  22 writes, 4 reads, all in browser / HTTP / page-list code.  Read as the dialog message id by `Browser_PageView_Enter` (`Dialog_ShowMonitored`,
  D=1, E=[C1DC]) and as a stop flag by `Browser_FetchInlineImages`.  The value written by `Http_Poll` ($01) is not matched to a message text.
* **`wJoySaved*` and a quirk of the original.**  Four screens save `wJoyRepeatDelay/Interval` before switching to ($14,$04) and three restore them (B=delay, C=interval).  `BrowserMenu_Close`
  (72:6A6B) loads `B := [C2E4]`, `C := [C2E3]`, i.e. it restores the two values **swapped**.  This is what the ROM does (no rename is affected; the names follow the majority of four
  save and three restore sites).  Whether the original authors noticed is unknown.
* **HTML parser HRAM.**  `hHtmlListIndent/LineIndent/AlignAdjust/LinkTextStart` are used only by `engine/html/{tags,layout,count_pass}.asm` (bank 74), initialised by `Html_InitParser`.  The
  surrounding `FFB0-FFDF` bytes are not exclusive (section 4).  `hHtmlAlignAdjust` is the only one whose unit/sign is inferred: `Html_Tag_Hr` stores the two's complement of a width
  (`dec hl ; cpl ; cpl`) and the layout adds it to the free width before halving (centre) or using it whole (right).

## 4. Overlay windows: why most of the heavily used bytes stay neutral

The heaviest neutral names are *not* single variables.  Each of the following windows is shared by unrelated code that never runs at the same time, so one name per address would be false
for part of its users.  This was the reason the earlier passes left them alone (`naming_g7.md`: "C27C-C283, C0D4-C0FF (overlaid by banks 68/6C/70/73 at different times)"); this pass
verified it with the code and recorded the roles.

| window | what the evidence shows | left neutral |
|---|---|---|
| `C27C-C286` ("screen locals") | `C27C`: state index (Title_Run, CommScene), result returned in A (AdapterCheck_Run, SettingsPhone_ChoiceMenu/ConfirmScreen, Account_ActionConfirmPage), selected item (SettingsMenu_Run).  `C27D`: cursor (ActionConfirm, ConfirmScreen, SlotMenu, Title menu), state of the API state machines (AdapterCheck, PasswordChange_Communicate via `PasswordChange_StateTable`, Registration_Verify, SettingsPhone_*AdapterConfig), kind 0/1/2 in CommScene.  `C27E`: entry argument (ActionConfirm, ChoiceMenu, SlotMenu, PwSaveConfirm), OK-state flag (Account_*_UpdateOkState, PhoneKeypad_Update*Flag), idle counter (Title, Notice, CommScene).  `C27F-C286`: per screen (idle counter hi, page counter, API poll counter `C286`...) | yes (3 HYPOTHESIS rows, ideas `wScreenVar0..2`) |
| `C0D4-C0FF` ("menu locals") | `C0E5/C0E6` current/previous item in TopMenu, MailMenu, HelpMenu (same `ld a,[C0E5] ; ld [C0E6],a` before the D-pad change), BrowserStart, MobileDict; the same `C0E5` is the edited value in the debug sound test.  `C0E7/C0E8`: hold timer of the three debug screens (identical `*_UpdateHoldTimer` code), animation counters in TopMenu/MailMenu/BrowserStart.  `C0D4/C0D6/C0D8`: CommNotice arguments, ConnectDialog mode, HelpMenu page, debug entry, top-menu cursor x/y | yes, except the 8 TopMenu-only bytes |
| `C10E-C11D` | second source pointer of `Tilemap_CopyRectAndAttrPtr` (C10E/C10F, ~25 callers) **and** 16-byte staging buffer of `CopyBytesFarToFar` (+ destination bank in C10E) **and** counter in `Tilemap_FillRectSequential` **and** direction bits in `TopMenu_StartCursorMove` (already noted by `naming2_g1_home.md`) | yes (idea `wTilemapAttrSrc`) |
| `C580-C592` | `Mail_ParseDate` fields (BCD year hi/lo, month, day, hour, minute at C580-C585; timezone sign/hours/minutes C590-C592; the six bytes are copied to the mail record at +3) **inside** the generic SJIS/ISO-2022-JP staging buffer of the SMTP/POP3 code (cleared `$1A` bytes at 54:4E0F, `ld hl/de,$C580` in 15 more places) | yes (idea `wMailDateYearHi`...) |
| `C711-C713` (SDK) | scratch of `MobileSDK_ParseDecimal/ParseReplyCode`, error-code copy of `MobileState_ConnectIsp` (`$25/$14`), length bytes in `MobileSDK_HttpBodyStart` | yes |
| `C823-C825` | `MobileAPI` stores (L, H, index); `ReturnMobileAPI` re-uses the same three bytes as (A, L, H) | yes |
| `FFB0-FFE0` (HRAM scratch) | shared between the ROM0 text engine, the bank-74 HTML parser/layout, the bank-4E renderer, the bank-51 BMP loader and the 48/51 text helpers (`naming_g8.md` already warned).  Examples: `FFB9/FFBF` = text-engine string bank / nesting depth, but bank 74 keeps the page-header bank and a 16-bit record counter there; `FFC1-FFC6` = text box geometry for ~25 UI screens (`TextEngine_LineWrap`), HTML layout geometry in bank 74; `FFBA/FFBB` = glyph colour selectors B/C of `Canvas_BlitGlyph` (25 UI screens, `FFBB=$03` 33 times), page header bank / run pointer in bank 74; `FFBC` is already named `hTextY` but the parser stores the run pointer's high byte there | yes (HYPOTHESIS ideas for the text-engine roles; bytes exclusive to bank 74 were named) |

**Contradiction found (kept, not hidden).**  `ram/wram.asm` described `wRam_C711` as a "pending error code copy" (analysis/mobile_candidates.json); the code also uses it as the first byte of the
number scratch in `MobileSDK_ParseDecimal` and as a length byte in `MobileSDK_HttpBodyStart`.  Neither role alone is the byte's identity, so it stays neutral.  Likewise `hRam_FFDF` is the
parser's link counter in bank 74 and "previous selected link" in `Browser_SelectPrevLink/NextLink` (g5 named `hBrowserSelectedLink` = `FFDE`); `hRam_FFA7` has no writer that stores a non-zero value, so the
"injected button" idea in `ram/hram.asm` remains unsupported (recorded as a HYPOTHESIS row with that warning).

## 5. Unresolved / not named (with reason)

Top remaining neutral names by number of named functions using them:

| name | users | why neutral |
|---|---|---|
| `hRam_FFB0`, `FFB1`, `FFB2`, `FFB3`, `FFB4`, `FFB5` | 122 / 42 / 23 / 15 / 22 / 9 | multi-subsystem scratch: `FFB0` = width argument of `Tilemap_CopyRect`, bank temp of the text-engine `CallString`, layout record kind (bank 74), `CommTime_AddTimerA` result, palette mask (bank 6C); `FFB2` style bits of the HTML text (bank 74, renderer) and minutes in `CommTime` results |
| `wRam_C27C`, `C27D`, `C27E` | 96 / 104 / 42 | overlay (section 4) |
| `wRam_C0E5`, `C0E6`, `C0D4`, `C0D6`, `C0D8`, `C0E2` | 52 / 13 / 19 / 26 / 33 / 6 | overlay (section 4) |
| `hRam_FFC0-FFC9`, `FFCA-FFCF`, `FFD0-FFD7` | 30-40 each | text-engine box (25 UI screens) **and** HTML layout/renderer geometry, record pointer/count (`FFCA/CB` pointer, `FFCE/CF` count in `Html_Layout_AppendRecord`, re-used by `Browser_DrawElement` as screen coordinates), BMP size (`FFD6/D7`), inline-image state (`FFD0-FFD5`) |
| `hRam_FFBA`, `FFBB`, `FFB9`, `FFBF` | 38 / 33 / 11 / 7 | text-engine registers with a bank-74 overlay; roles recorded as HYPOTHESIS rows |
| `wRam_C10E`, `C10F` | 16 / 12 | overlay (section 4) |
| `wRam_C1AC`, `C176`, `C17A`, `C17B`, `C17C`, `C1AA`, `C0D9` | 1-5 | help-script bytes that are write-only or whose purpose the code does not show |
| `wRam_C240-C247`, `C250-C253`, `C25F` | 1-7 | bank-54 mail/POP3/SMTP parameter and scratch bytes: `C240` is also the base of the dial/DNS/mail argument buffers (`ld de,$C240` 42 times); no single role |
| `wRam_C2B0/B1`, `C2A2`, `C2DC`, `C1CC`, `C16D/C16E` | 1-3 | one or two accesses (or write-only), below the two-independent-pieces bar |
| `wRam_C2C5/C2C6` | 4 / 4 | 16-bit value set by the browser starters (0 for the home page, caller BC for the settings session) and only tested for zero before `Net_BuildLoginPostBody`; purpose not shown |
| `wRam_C2EF`, `C2EE`-overlay | 6 | `PalFade_Start` / `Palette_SetFadeTargetMasked` store B/C there although `C2EE` is named `wTextCellsLeft` for the text code: overlay |
| `wRam_C331-C333`, `C33F` | 3-11 | HTML parser (`Html_InitParser`, `Html_Layout_FlushListItem`) and BMP converter (`Bmp_ConvertToTiles`) share them |
| `wRam_C6A6`, `C711-C714`, `C719/C71A`, `C81E/C81F`, `C819`, `C820/C821`, `C823/C824`, `C827`, `C82C-C834`, `C847-C853`, `C9D3` | 1-17 | SDK bank-75 internals where the `wMobileSDK_*` layer stops; need a dedicated reading of `lib/mobile/main.asm` (e.g. `C81E/C81F` = request-struct pointer + 4 in `MobileAPI_HttpGet/Post`, role of the +4 word not shown) |

The HYPOTHESIS rows of the manifest (idea column only; nothing applied):

| addr | old | idea |
|---|---|---|
| `C27C` | `wRam_C27C` | `wScreenVar0` |
| `C27D` | `wRam_C27D` | `wScreenVar1` |
| `C27E` | `wRam_C27E` | `wScreenVar2` |
| `C0E5` | `wRam_C0E5` | `wMenuVar_Current` |
| `C0E6` | `wRam_C0E6` | `wMenuVar_Previous` |
| `C0E7` | `wRam_C0E7` | `wDebugHoldFrames` |
| `C0E8` | `wRam_C0E8` | `wDebugHeldButtons` |
| `C0D4` | `wRam_C0D4` | `wTopMenuCursorX` |
| `C0D6` | `wRam_C0D6` | `wTopMenuCursorY` |
| `C0DF` | `wRam_C0DF` | `wTopMenuCursorStepYHi` |
| `C10E` | `wRam_C10E` | `wTilemapAttrSrc` |
| `C10F` | `wRam_C10F` | `wTilemapAttrSrcHi` |
| `C0F6` | `wRam_C0F6` | `wTickerVramColumn` |
| `C580` | `wRam_C580` | `wMailDateYearHi` |
| `C711` | `wRam_C711` | `wMobileSDK_ParseTemp0` |
| `C823` | `wRam_C823` | `wMobileAPISavedHL` |
| `C28E` | `wRam_C28E` | `wScreenStateIndex` |
| `FFB9` | `hRam_FFB9` | `hTextEngineBank` |
| `FFBF` | `hRam_FFBF` | `hTextEngineDepth` |
| `FFC1` | `hRam_FFC1` | `hTextLineStartX` |
| `FFC3` | `hRam_FFC3` | `hTextBottomY` |
| `FFC4` | `hRam_FFC4` | `hTextRightX` |
| `FFC6` | `hRam_FFC6` | `hTextLineAdvance` |
| `FFBA` | `hRam_FFBA` | `hTextGlyphColorB` |
| `FFBB` | `hRam_FFBB` | `hTextGlyphColorC` |
| `FFDF` | `hRam_FFDF` | `hHtmlLinkCount` |
| `FFE0` | `hRam_FFE0` | `hHtmlLinkHeapOffset` |
| `FFD6` | `hRam_FFD6` | `hBmpWidth` |
| `FFA7` | `hRam_FFA7` | `hJoyInjectedButtons` |
| `D725` | `wRam_D725` | `wStatSplitParam2` |

## 6. Banked addresses skipped (bank dependent, handled by the bank-context layer)

`ram/wram.asm` still has 481 neutral `wRam_D...` names and `ram/sram.asm` 161 `sSram_...` names.  A CPU address in `$D000-$DFFF` or `$A000-$BFFF` is a different object in every WRAM/SRAM bank,
so none of them was renamed here (STYLE.md section 4 "RAM").  The most accessed ones (census reads+writes, `analysis/ram_census.tsv`; WRAM bank column from the census) for the bank-context pass:

| addr | census accesses | banks using it | note |
|---|---|---|---|
| `D824` | 97 | 13 banks, WRAM 1 | already `wStatIrqServiceFlag` in `ram/banked.asm` |
| `D725` | 83 | 15 banks, WRAM 1 | companion of `wStatSplitLine` (D724); idea `wStatSplitParam2` (HYPOTHESIS row) |
| `D724` | 77 | 16 banks, WRAM 1 | already `wStatSplitLine` |
| `D62A`, `D629`, `D625`, `D627`, `D628`, `D626`, `D624`, `D630-D632`, `D62F` | 50 / 49 / 38 / 34 / 32 / 27 / 33 / 21-30 | 6-7 mail banks (22,23,26,27,29,2E), WRAM 1 | a mail-composition block ($FF stores, 49 pointer uses for D62A); earlier proposals exist (`wMail_Boundary...`, marked "NOT applied (banked)") |
| `D019`, `D010`, `D011`, `D01F`, `D008`, `D007`, `D006` | 46 / 46 / 44 / 20 / 17 / 15 / 15 | banks 04, 0F (+19, 1B, 2E), WRAM 2 | mail library (bank 0F) state in WRAM bank 2 |
| `D524`, `D526`, `D525`, `D500`, `D514`, `D4C0`, `D400` | 35 / 20 / 15 / 26 / 25 / 24 / 18 | mail and address-book banks, WRAM 1/6/7 | mail list / buffer areas |
| `A000` | 16 | 13 banks | SRAM window base read with different banks |

Nothing else about them was analysed in this pass.

## 7. Reproduction

```
cd <private copy>            # rsync -a --exclude .git --exclude traces --exclude build ./ <copy>/
make                         # baseline, SHA-256 OK
python3 tools/apply_renames.py --manifest analysis/naming2/ram2_renames.tsv --strict
```

The manifest has one header line, one `#` comment line, 49 applied rows and 30 HYPOTHESIS rows; HYPOTHESIS rows start their evidence with `idea: <name> | ...`.

## 8. Follow-up (ram3)

`wRam_D725` (section 6, idea `wStatSplitParam2`) was named in [`naming2_ram3.md`](naming2_ram3.md): it is `wKbdSlideDeltaRow` in `ram/banked.asm` (WRAM bank 1, PROBABLE), the row index of the keyboard-slide delta tables.

The overlay windows of section 4 were then given **screen-local aliases** (`ram/overlays.asm`, 258 aliases of 67 bytes; [`naming2_ram3.md`](naming2_ram3.md) section 5, verified in
[`naming2_verify_ram3.md`](naming2_verify_ram3.md)).  The rule of section 4 stands (the neutral name is the only global name of the address); the table of section 4 is a first reading and some of
its rows are **corrected** by the aliases (and the idea row `FFE0 hHtmlLinkHeapOffset` of section 5 is wrong: `FFE0` is an index into the link pointer table): `C27C-C286` (`C27E:C27F` is a big-endian frame counter in the title screen, a little-endian record pointer in the notice pages; `C286` is a one-shot sound
latch, not an API poll counter), `C0D4-C0FF` (`C0E5/C0E6` are current/previous item in the top menu only; in the help and mail menus `C0E6` is the item to draw as normal; the browser start page has
`C0E5` only) and `C10E-C11D` (the "counter" in `Tilemap_FillRectSequential` is a constant `$07` and a start tile; the counter is in `Palette_FadeOutWithTicker`).  The ideas for `C0D4`, `C0D6`, `C0DF` (sections 3 and 5) are superseded by the aliases of the top menu.
