# RAM reference 2 (ram2): adversarial reference

For each of the 49 names all accesses were listed: the symbolic name, the old neutral name and the literal `$C26F`-style forms (`ld hl,$C26F` and friends), plus a scan for multi-byte accesses (`ld hl,$C0D4`, `$C2AD`, `$C1B2`...) that could overlap the address.

## Result

Of the 49 upheld rows, **9 carry a wrong or incomplete sentence in the evidence column** (section 2; the conclusion stays), and the pass left **a stale-annotation defect in the
tree** (section 3).  Stated honestly: the attempt to refute the names failed on the points that decide them.

Points checked against the brief:

* **Overlay windows.**  `C0D4-C1CF` is cleared by `ld hl,$C0D4 ; ld bc,$00FC ; call FillBytes` at the start of each of 13 screens (TopMenu, MailMenu, HelpMenu, HelpScript,   MobileDictionary, ConnectDialog, CommNotice, CommErr, StartChoice, NonCgb, three debug screens), so every byte in it is per-screen.

For each of the 22 named bytes inside it   (`C0D5 C0D7 C0DB-C0E1 C12E C14E C14F C177-C179 C1A8 C1A9 C1AB C1B0 C1B1 C1CD`) no second screen accesses the address, directly or through a base pointer (`ld hl,$C0D4` only   as the clear; the connect dialog buffers `C1B2..C1CB` end before `C1CD`).

* **HRAM overlays.**  `FFD8-FFDD` are accessed only in bank 74 (executed in up to 16 scenarios) with one meaning throughout (parser init clears them, `<ul>/<ol>/<li>/<hr>/<a>` write   them, `Html_Layout_PlaceLine/GetLimitsAtY` read them).

**`wTimerAWarnFlags`.** (1) "cleared by CommNotice_ShowDialogMode0/1 `res 0,[hl]` after the dialog": the clear is executed **before** the dialog (`res 0,[hl]`, then the two    mode bytes, then `farcall CommNotice_ShowDialog`), at 6 sites (`CommNotice_ShowDialogMode0/1`, `Registration_Verify_OnTimeLimit`, `Browser_ConnectionNotice`, `Label_4E_5107`,    `Function_5C_546F`, `Label_67_5D00`).  (2) "tested first so a raised warning is not re-raised": when bit0 is already set the test does not return 0: it jumps to the common exit with    `A = wTimerEnable` (non-zero, bit 4 was just tested), so the caller takes the time-limit path again.

In the ask mode the timeout goes to    50:4301 (`ld a,0 ; ret`: no sound, cursor not consulted) while A returns `[C0D4] xor 1`; `CommNotice_ShowDialog` treats 0 as the disconnect result, so the 10 s timeout in the ask    variant is the disconnect answer. c.

**`wTimerAExtra`.** The reader that copies it to `hRam_FFB3` is `Label_27_4EEB` (mail send/receive, 27), not `CommTime_DrawSummaryScreen`; the other readers are the two dead    number printers (22:48CD, 23:47BC).

**`wKbdRunArgB`.** "every caller passes B=1 (8 sites)": 7 of the 13 `farcall Kbd_Run` sites set `ld b,$01` (`name_editor`, `profile_editor`, both `address_editor`,    `mail_title_entry`, both in `body_editor`); the other 6 (`phone_number_entry`, `login_id_entry`, `phone_comment_entry`, `password_entry`, `mail_address_entry`,    `connect_dialog`) load only C and leave B as it comes from `Sprite_UpdateAll`.

**`wKbdNeighbourFlagsB`.** Bits 3-0 are tested as well (per direction, `Kbd_StoreStickyRow` / `Kbd_ClearStickyRow`); bits 7-4 select the column action.

**`wBrowserDialSlotPlus1`.** "meaning of 0 not shown": `Mobile_BeginConnect` stores C in `wMobileTaskArgs`; `Mobile_ConnectPoll` (54:40B7) takes the **guest login**    (`String_Mobile_GuestLogin`, number from `Dial_CopySelectedNumber` in C240) when it is 0 and otherwise calls `Dial_SelectEntryFromList` with **value - 1**.  "slot + 1"    is therefore demonstrated for the relayed byte. g.

**`hHtmlAlignAdjust`.** "two's complement of the text width": the value stored by `Html_Tag_Hr` (74:4D44) is the complement of the remainder HL left by the divide-by-12 loop    (the rule is drawn from `$83E6` glyph cells of 12 px), not of the width; the consumer description is right. h.

**`wTimerAWarnMinute`/`Flags`.** Minor: the "session starts" also include the disconnect paths (`Comm_Disconnect`, `Comm_EndOffline`, `Function_4C_47C4`) that store `$09` and 0. i.

**`wCommNoticeMode`/`GfxSet`.** `Label_4C_40E4` and `Browser_Menu_AdapterError` set the two bytes before `Mobile_ShowLastError`, but `CommErr_ShowScreen` never reads them    (its `C0D8` is zero after the screen-entry fill); the stores serve the later `CommNotice_ShowDialog`.

## 4. Observation on a pre-pass name (not among the 49)

`hTextY` (FFBC, PROBABLE, "text cursor Y") and `hTextX` (FFBD/FFBE, "text cursor X") are overlaid in bank 74: `Html_Tag_A` stores the 16-bit pending-run position as
`hRam_FFBB` (lo) + `hTextY` (hi) (74:4B6D-4B7B) and `Html_Layout_AppendRecord` uses `hTextX+1` with `hRam_FFBF` as a record counter.  The pass itself documents both reuses
but leaves the names.  They hold for the text engine outside bank 74 only; a comment on the `DEF` lines would be honest.  The pass was right not to name `FFB8-FFBF`,
`FFC0-FFC9`, `FFD6`, `FFDF`, `FFE0` semantically (the HYPOTHESIS rows stay HYPOTHESIS; `hHtmlLinkCount` for FFDF in particular would contradict `hBrowserSelectedLink`'s
"previous value" role recorded by g5).
