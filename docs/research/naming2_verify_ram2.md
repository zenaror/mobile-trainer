# RAM naming pass 2 (ram2): adversarial verification

Verifier's note on `analysis/naming2/ram2_renames.tsv` (49 applied rows, `docs/research/naming2_ram2.md`).  Every applied name was tried to be refuted against the source tree
(private copy, `make` SHA-256 OK `6d802e66...6570`), `analysis/coverage_union.tsv`, `home/jump_table.asm`, `home/sprites.asm`, `engine/input/joypad.asm` and the earlier RAM notes
(`ram_names_reconciliation.md`, `naming_g5/g6/g8.md`).  For each of the 49 names all accesses were listed: the symbolic name, the old neutral name and the literal `$C26F`-style
forms (`ld hl,$C26F` and friends), plus a scan for multi-byte accesses (`ld hl,$C0D4`, `$C2AD`, `$C1B2`...) that could overlap the address.
Correction manifest: `analysis/naming2/verify_ram2_fixes.tsv` is **empty** (header and one comment line): no name had to be changed.  Checked in the private copy:
`python3 tools/apply_renames.py --manifest analysis/naming2/verify_ram2_fixes.tsv --strict` -> `0 row(s) ... nothing to change (no-op)`, exit 0; the unmodified tree builds
`RESULT: IDENTICAL`.

## Result

| verdict | count |
|---|---|
| upheld (name and status) | 49 |
| renamed | 0 |
| status lowered | 0 |
| refuted | 0 |

Of the 49 upheld rows, **9 carry a wrong or incomplete sentence in the evidence column** (section 2; the conclusion stays), and the pass left **a stale-annotation defect in the
tree** (section 3).  Stated honestly: the attempt to refute the names failed on the points that decide them.

Points checked against the brief:

* **>= 2 independent pieces of evidence.**  Met for all 49 (writer/reader pairs with known roles, a hardware-register copy, an argument relayed to a named routine, or a loop with
  a fixed bound).  The weakest are `wTimerAExtra` (layout only) and `hSpriteSlideOffsetX` (never written with a non-zero value); both names claim no more than that.
* **Execution.**  All 49 have executed accessing instructions in `coverage_union.tsv` (the number of scenarios is 4 at the least: `wCommNoticeFrames/Seconds/Screen`).  The 14
  CONFIRMED rows all have a disassembly fact plus execution (details below); none depends on code that never ran.
* **Overlay windows.**  `C0D4-C1CF` is cleared by `ld hl,$C0D4 ; ld bc,$00FC ; call FillBytes` at the start of each of 13 screens (TopMenu, MailMenu, HelpMenu, HelpScript,
  MobileDictionary, ConnectDialog, CommNotice, CommErr, StartChoice, NonCgb, three debug screens), so every byte in it is per-screen.  For each of the 22 named bytes inside it
  (`C0D5 C0D7 C0DB-C0E1 C12E C14E C14F C177-C179 C1A8 C1A9 C1AB C1B0 C1B1 C1CD`) no second screen accesses the address, directly or through a base pointer (`ld hl,$C0D4` only
  as the clear; the connect dialog buffers `C1B2..C1CB` end before `C1CD`).  The single-screen exception rule of the pass is therefore sound.
* **HRAM overlays.**  `FFD8-FFDD` are accessed only in bank 74 (executed in up to 16 scenarios) with one meaning throughout (parser init clears them, `<ul>/<ol>/<li>/<hr>/<a>` write
  them, `Html_Layout_PlaceLine/GetLimitsAtY` read them).  `FFF0/FFF1` are accessed only by `home/sprites.asm` and `Dialog_SlideIn/Out` (72).  Neither overlaps the documented
  text-engine/HTML overlays (`FFB8-FFBF`, `FFC0-FFC9`, `FFD6`, which the pass correctly left as HYPOTHESIS).  See section 4 for a problem in a **pre-pass** name.
* **Neighbours and other passes.**  No contradiction with `ram/banked.asm`, `ram_names_reconciliation.md` or `naming_g*.md`: the two earlier namers of `C26E/C26F/C277/C27A`
  are consistent with the chosen names; `wMobileErrorDetail` is consistent with `wMobileErrorCode/Extra` (C272/C275) and `wMobileResultCode/Detail` (C1DD-C1DF).

## 1. Verdict per name

| name | verdict | reason |
|---|---|---|
| `wTimerAWarnMinute` C26E | upheld PROBABLE | the test (29 copies) compares `wTimerAMinutes` with it and seconds with `$1E`; on a hit `+= $0A` up to `$45`; every session start stores `$09`; `CommNotice_RunDialog` reads it (`>= $3C`, `CommNotice_DrawMinuteDigit` derives the digit from it).  What timer A measures stays PROBABLE, hence the neutral word TimerA |
| `wTimerAWarnFlags` C26F | upheld PROBABLE | bit0 = notice due, bit1 = final notice done (VBlank clears it at 70 min); evidence sentences corrected in section 2 (2a) |
| `wMobileErrorDetail` / `Hi` C273/C274 | upheld CONFIRMED | `Mobile_SaveLastResult` (HL of `MobileAPI($00)`) -> `Mobile_ShowLastError` loads HL -> `CommErr_ShowScreen` stores H/L in `wCommErrCodeHi/Lo`; 6 copy sites from `wMobileResultDetail`; executed (104 loads of `Mobile_ShowLastError`, 20 scenarios).  The password flow (code `$40`/`$32` with BCD digits, `PasswordChange_HandleHttpStatus` tests Hi==3, Lo 1/2) uses the pair as a reply-code word in the same way.  "Detail" is a neutral word for the second code word; the data flow is what is CONFIRMED |
| `wRegistrationStage` C277 | upheld PROBABLE | SRAM1 `B010` xor `$A5` (only 1-3 kept) read by `Registration_Run` to pick the resume path; `B010` is written with progress states 2 and 3 by `Settings_SetProgressState2/3` (state 2 in `Registration_Communicate` 65:4642, state 3 after `Registration_VerifyAndFinalizeOnline`), which the pass did not cite and which supports "progress of the registration".  The meaning of the individual values stays unknown |
| `wSavePasswordFlag` C27A | upheld PROBABLE | `Label_65_4410`/`Label_65_4607` turn the `PwSaveConfirm_Run` result (0 back, 1 yes, 2 no) into 1/0, store it in SRAM1 `B088`, `Registration_Communicate` gates `Registration_SavePassword` on it, `PwSaveConfirm_Setup` presets the cursor with it (xor 1).  The screen text (`naming_g6`: "save the password, is that OK?  yes/no") makes the role direct; CONFIRMED would be defensible |
| `wCommNoticeMode` C1D0 | upheld PROBABLE | first argument of `CommNotice_ShowDialog` (B := +1, `RunDialog` stores -1 in C0D8; 0 = cut notice without choice, non-zero = ask variant with the yes/no cursor; table names `*_Cut*`/`*_Ask*`) |
| `wCommNoticeGfxSet` C1D1 | upheld PROBABLE | second argument (C0D6); `RunDialog` loads tile set A when 0, else B and selects screens 1-4 vs 5-8; equals `wCommSessionKind` in the browser flows |
| `wCommNoticeScreen` C1CD | upheld PROBABLE | 8 stores by `RunDialog`, indexes `Table_CommNotice_Screens` and `Table_CommNotice_DigitCells`; no other user |
| `wCommNoticeFrames` C14E | upheld PROBABLE | incremented once per pass of the wait loop (one `VBlank_WaitAndService`), wrap at `$3C`; `JoypadDispatch` dispatches on the newly pressed button, so the counter misses only the frames of a new B/Select/Start press: a frame counter for practical purposes |
| `wCommNoticeSeconds` C14F | upheld PROBABLE | +1 per 60 passes, closes at 10; evidence sentence corrected in section 2 (2b) |
| `wFarAccessTemp` C12E | upheld CONFIRMED | `ReadByteFar` parks the byte read while SRAM is disabled and reloads it into A; `WriteByteFar` parks its bank argument and reloads it; 5 accesses, executed in up to 62 scenarios.  "Temp" claims nothing more (the two functions store different kinds of data in it) |
| `wJoySavedRepeatDelay` C2E3 | upheld CONFIRMED | re-verified against `Joypad_SetRepeatTiming` (B -> `wJoyRepeatDelay`, C -> `wJoyRepeatInterval`) and the counter logic of `Joypad_UpdateUnsaved` (reload with Delay while released or at the first press, with Interval after a repeat event): Delay/Interval are right, so the two "Saved" bytes are right.  `BrowserMenu_Close` (72:6A6B, executed 17x) loads B from C2E4 and C from C2E3: the swap is real in the source (both opens store interval to C2E4 and delay to C2E3) |
| `wJoySavedRepeatInterval` C2E4 | upheld CONFIRMED | as above |
| `wCommSceneScrollX` C2A8 | upheld CONFIRMED | `CommScene_ApplyScrollFrame` copies it to `rSCX` (39 443 executions, 13 scenarios), Increment/Decrement step it, LoadGraphics/Teardown clear it; C2A9 only written |
| `wTimerAExtra` C2D7 | upheld PROBABLE | `CommTime_TimerAIsNonZero` (51:4239, executed 355x) ORs all four bytes C2D4-C2D7, `CommTime_Reset`/`ShowSummary` clear four; `Int_VBlank` never advances C2D7 and `CommTime_AddTimerA` adds only three bytes (the total C2D8-C2DB has the same unused 4th byte).  No read of C2D7 is executed in any trace; layout is the whole basis, and the name claims nothing else.  Evidence correction in 2c |
| `wKbdRunArgB` C2B3 | upheld CONFIRMED | argument role only (default 1, B only when `wKbdType`==5), executed 14 476x in 35 scenarios; evidence correction in 2d |
| `wKbdRunArgC` C2B4 | upheld CONFIRMED | argument role only (first instruction of `Kbd_Run`; `ld c` is the source), executed in 35 scenarios; the `OK enabled` reading is correctly left out of the name |
| `wKbdNeighbourCell` C2B6 | upheld PROBABLE | byte `[direction]` of the 6-byte neighbour record becomes the new cell in `Kbd_MoveCursor_DirTable` |
| `wKbdNeighbourFlagsA` C2B7 | upheld PROBABLE | record byte 4; bits 7-4 tested one per direction by the four direction handlers |
| `wKbdNeighbourFlagsB` C2B8 | upheld PROBABLE | record byte 5; evidence incomplete, section 2e |
| `wHelpScriptDelayCounter` C179 | upheld PROBABLE | `dec` with `ret nz` at the entry of `HelpScript_StepText`, opcodes `$4x` add an operand, reload from the glyph delay after each glyph (6C:6183) |
| `wHelpScriptGlyphDelay` C178 | upheld PROBABLE | default 6 at page start, changed by opcodes `$22-$2F`, reloaded after each glyph (opcode `$20/$21` set C17A instead) |
| `wHelpScriptPictureId` C177 | upheld CONFIRMED | `HelpScript_ShowPicture`: `cp` with the argument and `ret z`, stores the new id, `(id-1)*5` indexes the picture table; old id 0 skips the fade-out (0 = none shown); executed 610x, 27 scenarios; cleared by the screen-entry fill |
| `wHelpScriptColumn` C1A8 | upheld PROBABLE | +1 per drawn glyph, wrap at `$10` (executed in 2 scenarios), cleared on a line break; with the line tile it forms the tile index whose x16 is the buffer offset for `Font_BlitGlyph8x16` |
| `wHelpScriptLineTile` C1A9 | upheld PROBABLE | +`$20` per line (16 glyphs x 2 tiles; bottom half at +`$100`); cleared at page start |
| `wHelpScriptAdvanceMode` C1AB | upheld PROBABLE | 0/1/2 from A released/held and B (handlers 5D09/5D30 of `HelpScript_InputTable`); mode 2 skips drawing and ends with sound `$2E` and `B=$FF` |
| `wHelpScriptAltPtr` / `Hi` C1B0/C1B1 | upheld PROBABLE | opcode `$08` stores HL + 16-bit operand (a relative target); the Select handler (`Label_6C_5D5A`, index 2 of the input table) copies it into `wHelpScriptPtr` when SRAM1 `A684` bit7 is set, otherwise reloads the restart pointer |
| `wTopMenuCursorTargetX` C0DB | upheld CONFIRMED | `Sprite_SetPosition` stores D at slot byte 0 and the OAM writer adds `$10` to slot byte 0 (OAM Y) and `$08` to byte 1 (OAM X): D = y, E = x is therefore a fact, not a convention; second byte of `Table_TopMenu_CursorTargets` -> X |
| `wTopMenuCursorTargetY` C0DC | upheld CONFIRMED | as above; first byte -> Y; init `$28`/`$0B` |
| `wTopMenuCursorXFrac` C0D5 / `YFrac` C0D7 | upheld PROBABLE | low byte of the 16-bit sum `[C0D4:C0D5] + [C0DD:C0DE]` (H is the pixel, L the fraction: `ld h,[C0D4] ; ld l,[C0D5] ; add hl,bc`); only `TopMenu_UpdateCursorMove` |
| `wTopMenuCursorStepXHi` C0DD / `StepXLo` C0DE / `StepYLo` C0E0 | upheld PROBABLE | computed by `TopMenu_StartCursorMove` (Divide8 quotient / Divide16 fraction, both negated for the left/up direction using the bits of C10E) and added by `TopMenu_UpdateCursorMove` |
| `wTopMenuCursorStepsLeft` C0E1 | upheld CONFIRMED | `max(1, (|dx|+|dy|)/8)` (the `add ; rr a ; srl ; srl` sequence), decremented per frame (71 943 executions), 0 snaps to the target; `TopMenu_*` functions are called only from `top_menu.asm` |
| `wBrowserPendingMessage` C1DC | upheld PROBABLE | read as the message index (E, D=1) of `Dialog_ShowMonitored` in `Browser_PageView_Enter` when non-zero, then dispatch on `hDialogResult` (table 4E:4A37), cleared at 4E:4A4E and at session start; the 22 writers are error/disconnect paths; 4 reads, all counted |
| `wBrowserDialSlotPlus1` C2C4 | upheld PROBABLE | stronger than the pass states, section 2f; PROBABLE remains because the two callers of `Browser_LoadUrlFromSramBank3` pass `D`=1/0 and what slot 0 of the list is stays open |
| `wPop3SavedSramBank` C25E | upheld CONFIRMED | `ldh a,[hSRAMBank] ; ld [C25E],a` in `Pop3_StartRetr/StartTop` before bank 3 is selected, restored in `Pop3_RetrPoll` and `Label_54_4BC6`; 4 executed accesses, up to 17 scenarios |
| `wShadowOAMNextOffset` C2F3 | upheld CONFIRMED | `Sprite_UpdateAll` stores `e` (low byte of the OAM write pointer after the last slot; 2 572 992 executions), `Browser_DrawCommTimer` uses it as the low byte of the shadow OAM destination with H=`$C0`, the frame-style chooser sets 4 |
| `hSpriteSlideOffsetX` FFF0 | upheld PROBABLE | `Sprite_HookAddSlideOffset` adds FFF1 to slot byte 0 (Y, shown above) and FFF0 to byte 1 (X); never written with a non-zero value, so "X" is fixed by the hook's byte order only; the 3 audio hits of `$FFF0` are the constant -16 (`ld bc,$FFF0`), not accesses |
| `hSpriteSlideOffsetY` FFF1 | upheld PROBABLE | as above, plus `Dialog_SlideIn/Out` step it in lock-step with the window (`rWY`); the byte-order fact makes the Y assignment firmer than the pass states |
| `hHtmlListIndent` FFD9 | upheld PROBABLE | `Html_Tag_Ul/Ol` add `$0C` and subtract it again (`$12` for one Ol variant), cleared by `Html_InitParser`; `Html_Layout_PlaceLine` restores `hHtmlLineIndent` from it after each placed line |
| `hHtmlLineIndent` FFD8 | upheld PROBABLE | added to the left limit by `Html_Layout_GetLimitsAtY` (FFC4 = `hViewX` + FFD8) and reduced by the bullet/number width (`$0C`, `$06` per digit) in `Html_Tag_Li`, so the first line of a list item hangs; strongest of the HTML names |
| `hHtmlAlignAdjust` FFDA / `Hi` FFDB | upheld PROBABLE | written only by `Html_Tag_Hr`, added by `Html_Layout_PlaceLine` to the free width before the centre/right shift, cleared after `EndLine`; evidence correction 2g |
| `hHtmlLinkTextStart` FFDC / `Hi` FFDD | upheld PROBABLE | `Html_Tag_A` stores the pending-run position at `<a href>` and compares it with DE at `</a>`; equal and style bit0 -> the link is dropped |

## 2. Corrections to the evidence column (names and statuses unchanged)

a. **`wTimerAWarnFlags`.** (1) "cleared by CommNotice_ShowDialogMode0/1 `res 0,[hl]` after the dialog": the clear is executed **before** the dialog (`res 0,[hl]`, then the two
   mode bytes, then `farcall CommNotice_ShowDialog`), at 6 sites (`CommNotice_ShowDialogMode0/1`, `Registration_Verify_OnTimeLimit`, `Browser_ConnectionNotice`, `Label_4E_5107`,
   `Function_5C_546F`, `Label_67_5D00`).  (2) "tested first so a raised warning is not re-raised": when bit0 is already set the test does not return 0: it jumps to the common exit with
   `A = wTimerEnable` (non-zero, bit 4 was just tested), so the caller takes the time-limit path again.  Bit0 is "notice due / not yet handled", cleared when the dialog is about to be
   shown; the name is unaffected.
b. **`wCommNoticeSeconds`.** "closes by itself with the same result as the A button" holds only for the no-choice mode (both go to 50:42EB).  In the ask mode the timeout goes to
   50:4301 (`ld a,0 ; ret`: no sound, cursor not consulted) while A returns `[C0D4] xor 1`; `CommNotice_ShowDialog` treats 0 as the disconnect result, so the 10 s timeout in the ask
   variant is the disconnect answer.
c. **`wTimerAExtra`.** The reader that copies it to `hRam_FFB3` is `Label_27_4EEB` (mail send/receive, 27), not `CommTime_DrawSummaryScreen`; the other readers are the two dead
   number printers (22:48CD, 23:47BC).  None of these reads is executed in a trace; the executed evidence is the four-byte OR in `CommTime_TimerAIsNonZero` and the clears.
d. **`wKbdRunArgB`.** "every caller passes B=1 (8 sites)": 7 of the 13 `farcall Kbd_Run` sites set `ld b,$01` (`name_editor`, `profile_editor`, both `address_editor`,
   `mail_title_entry`, both in `body_editor`); the other 6 (`phone_number_entry`, `login_id_entry`, `phone_comment_entry`, `password_entry`, `mail_address_entry`,
   `connect_dialog`) load only C and leave B as it comes from `Sprite_UpdateAll`.  Harmless for the role (B matters only for `wKbdType`==5), but the sentence is wrong.
e. **`wKbdNeighbourFlagsB`.** Bits 3-0 are tested as well (per direction, `Kbd_StoreStickyRow` / `Kbd_ClearStickyRow`); bits 7-4 select the column action.  Both nibbles are per
   direction.
f. **`wBrowserDialSlotPlus1`.** "meaning of 0 not shown": `Mobile_BeginConnect` stores C in `wMobileTaskArgs`; `Mobile_ConnectPoll` (54:40B7) takes the **guest login**
   (`String_Mobile_GuestLogin`, number from `Dial_CopySelectedNumber` in C240) when it is 0 and otherwise calls `Dial_SelectEntryFromList` with **value - 1**.  "slot + 1"
   is therefore demonstrated for the relayed byte.
g. **`hHtmlAlignAdjust`.** "two's complement of the text width": the value stored by `Html_Tag_Hr` (74:4D44) is the complement of the remainder HL left by the divide-by-12 loop
   (the rule is drawn from `$83E6` glyph cells of 12 px), not of the width; the consumer description is right.
h. **`wTimerAWarnMinute`/`Flags`.** Minor: the "session starts" also include the disconnect paths (`Comm_Disconnect`, `Comm_EndOffline`, `Function_4C_47C4`) that store `$09` and 0.
i. **`wCommNoticeMode`/`GfxSet`.** `Label_4C_40E4` and `Browser_Menu_AdapterError` set the two bytes before `Mobile_ShowLastError`, but `CommErr_ShowScreen` never reads them
   (its `C0D8` is zero after the screen-entry fill); the stores serve the later `CommNotice_ShowDialog`.  No change.

## 3. Defects in the tree left by the pass (outside the 49 names, for whoever applies the next tool run)

* **Stale status annotation.**  All 49 `DEF` lines in `ram/wram.asm` / `ram/hram.asm` still carry the status word **HYPOTHESIS** (STYLE.md section 1: "the status word after
  `size N ...` in the `DEF` line's comment"), although the manifest statuses are CONFIRMED (14) / PROBABLE (35).  Six of them (`wTimerAWarnMinute`, `wTimerAWarnFlags`,
  `wMobileErrorDetail`, `wMobileErrorDetailHi`, `wRegistrationStage`, `wSavePasswordFlag`) still say "naming ideas in conflict, none adopted", which is now false.  `apply_renames.py`
  does not touch these comments for `const` rows (no `--annotate`).  Not edited here (outside the two files of this task).
* **No alias for the old neutral names.**  The old `wRam_C...`/`hRam_FF...` names no longer resolve anywhere in the tree (0 references, no `DEF` alias; the alias rule of
  STYLE.md applies to labels).  Older documents (`naming2_g3_apps_a.md`, `naming_g1.md`) still quote them.  Informational.
* **Literal accesses.**  The pass documents it: 96 literal uses of `$C26F` and 35 of `$C26E` remain next to the symbolic ones.  Every such literal was included in this verification
  and none contradicts a name.

## 4. Observation on a pre-pass name (not among the 49)

`hTextY` (FFBC, PROBABLE, "text cursor Y") and `hTextX` (FFBD/FFBE, "text cursor X") are overlaid in bank 74: `Html_Tag_A` stores the 16-bit pending-run position as
`hRam_FFBB` (lo) + `hTextY` (hi) (74:4B6D-4B7B) and `Html_Layout_AppendRecord` uses `hTextX+1` with `hRam_FFBF` as a record counter.  The pass itself documents both reuses
but leaves the names.  They hold for the text engine outside bank 74 only; a comment on the `DEF` lines would be honest.  The pass was right not to name `FFB8-FFBF`,
`FFC0-FFC9`, `FFD6`, `FFDF`, `FFE0` semantically (the HYPOTHESIS rows stay HYPOTHESIS; `hHtmlLinkCount` for FFDF in particular would contradict `hBrowserSelectedLink`'s
"previous value" role recorded by g5).
