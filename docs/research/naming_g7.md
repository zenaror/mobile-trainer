# reference g7: banks 68, 69, 6B, 6C, 70, 72, 73

## 1. Subsystem map

| bank | what it is | entry points (callers) | main data |
|---|---|---|---|
| 68 | **account / registration / settings library** for the DION registration wizard (banks 65/67) and the settings menu (7C:7D5D): persistent settings page in SRAM bank 1, adapter-config mirror in SRAM bank 2, keyboard entry screens for login id / mail address / password, confirm and result pages, the "connecting to DION" panel, the delete-registration flow, the settings menu | 65:4000 wizard (`Settings_GetRegistrationProgress` 68:4870, `Account_*` screens), 7C:7D57 (`SettingsMenu_Run` 68:4F9E), 7C:7DFF (`Registration_DeleteFlow` 68:7951), 67:* (network/settings screens use `CommPanel_*`, `Account_PasswordEntryScreen`) | SRAM B000 page, four default adapter images 68:67E0.., WRAM3 `$DE80-$DFC2` buffers |
| 72 | **message box (dialog) service** and the two **browser menus** | `Dialog_Show` 72:4015 (mail/address-book banks 22-2F, 7C, 7F, 50), `Dialog_ShowMonitored` 72:4000 (browser 4E), `BrowserMenu_*` (4E:4D16-4D52) | `Dialog_ListTable` 72:502B (4 lists, 69 message records; 73 pointer words with the 4 list heads), window gfx |
| 70 | **scrolling panorama scene** shown while a homepage session communicates (3 kinds of state machines) | 4C:46B8/46D6 dispatch on `wRam_C2C3 == 0` | 9 tile blocks, 14x32 panorama map, 8 text boxes, animation tables |
| 69 | **connection icon sprite** (animation + tile set choice) | 4E:49CA/4EA1 (browser page screen), per-frame refresh from the dialog/browser wait loops | 2 tile sets (69/51), 7-entry object table |
| 73 | **browser start choice** screen (ホームページ / ページリスト) | 4F:468F (`Function_4F_4668`, from 7C:7BA3) | 5 tile blocks, button maps, globe animation |
| 6C | **help menu + help/tutorial script player** | 7C:7BAE (`HelpMenu_Run`), 48:49A9-4A69 (first-run pages through `HelpScript_Run`) | script bytecode from 6C:4809 with "second convention" single-byte kana text, 31-entry picture table |
| 6B | **non-CGB screen** ("このカートリッジはゲームボーイカラー せんようです") | 00:02A6 (Boot when hBootA != $11) | 128 baked glyph tiles + 32x18 map |

### 2.1 Settings page in SRAM bank 1 (`B000-B0FD`, backup `B100`, XOR `$A5` fields)

| SRAM | size | field |
| --- | --- | --- |
| B000 | 16 | magic `MOBILE TRAINER00` (`Settings_MagicString` 68:4000) |
| B010 | 1 | registration progress 1/2/3 (started / fields entered / complete) |
| B011 | 1 | adapter type (copy of `$C271`) |
| B012 | 1 | hidden-mode flag (B+SELECT+RIGHT) |
| B013 | 1 | selected dial entry 0..2 |
| B014/B025/B036 | 3 x 17 | dial strings of the three entries |
| B047 | 31 | registered mail address |
| B066/B071/B07A/B07F | 11/9/5/9 | login id ('g' + 9 chars), mail local part, mail sub-domain, password |
| B088/B089/B08A | 1 each | save-password flag, hidden mode at registration, manual numbers |
| B08B/B09C/B0AD | 3 x 17 | manual phone number 1, number 2, comment |
| B0BE | 1 | bit mask of stored fields (1 id, 2 mail, 4 password, 8/$10/$20 numbers) |
| B0FE/B0FF | 2 | LE sum of B000-B0FD |

### 2.3 Text entry and account screens

| screen | function | fields | rules seen |
|---|---|---|---|
| login id | `Account_LoginIdEntryScreen` 68:5296 | `DEA0` = `'g'` + 9 chars | OK when the 9-char buffer is full |
| mail address | `Account_MailAddressEntryScreen` 68:571D | local part `DEAB` (8), sub-domain `DEB4` (4) | sub-domain >= 3 chars; `Account_BuildMailAddress` gives `local@sub.dion.ne.jp` |
| password | `Account_PasswordEntryScreen` 68:5D00 (mode 0 enter, 1 again; 4 tile maps) | `DEB9` (8) | `Account_PasswordIsValid` = >= 4 chars with a digit and a letter (message 65:5389) |
| confirm | `Account_ConfirmScreen` 68:61F7 (manual twin 68:6435, never executed) | shows `DEA0`, `DFAA` | title 「次の情報をモバイルアダプタGBに登録します」, よろしいですか？ [はい][いいえ]; 1 proceed, 2 redo, 0 back |
| intro pages | `Account_{LoginId,Mail,Password}IntroPage` 68:55E1/5BC4/60BB | messages 0,1,2 of `PromptText_Table` (65:567F) | A -> 1, B -> 0 |
| action page | `Account_ActionConfirmPage` 68:6E1A | message `{4,11,12,13}` = verify registration / change password / usage time / usage fee | 2 buttons |
| result page | `Account_ResultPage` 68:766E | messages `{5,14,15,16}` plus 17 (error) / 18 (interrupted) | `Account_ResultPage_DrawTimeDigits` shows online time digits |

## 5. Named RAM (see `analysis/naming/ram_g7.tsv`)

WRAM0: `wTimerBSeconds/Minutes`, `wCommTimeoutMinutes` (C26D, 5 -> error `$26`), `wOnlineWarnMinute/Flags` (C26E/F: 9, +10 up to `$45`), `wMobileAdapterType` (C271), `wMobileErrorCode/Info/Extra`
(C272-C276), `wRegistrationProgress` (C277), `wSettingsFieldMask` (C278), `wSavePasswordFlag` (C27A), `wHiddenModeFlag` (C28C), `wManualNumbersFlag` (C28D), `wCommPanel*` (C287-C28B),
`wCommSessionKind` (C2C3: 0 homepage/default, 1 settings CGI page), `wDialogOnlineSnapshot` (C2CC), `wDialogType` (C2CD), `wConnIconState/GfxRequest` (C2CE/F), `wTimerASeconds/Minutes` (C2D5/6),
`wHelpScriptPtr` (C173), `hDialogResult` (FFF6); WRAM bank 3 buffers (`DE80` ... `DFAA`); SRAM bank 1 settings fields, help flags `A684`, tutorial counters `A881/A89A/A89B`, `A8B7`.
Not named on purpose: the per-screen scratch `C27C-C283`, `C0D4-C0FF` (overlaid by banks 68/6C/70/73 at different times).

## 6. Hypotheses recorded under generic names

20 rows (14 in bank 68, 1 each in 6C and 70, 4 in 73), all keeping the generic name:

`Function_68_4152` (masked password insert), `4283` (wipe banks 2/3), `4377`/`4430` (read B010 / B011), `4495` (skip string without ret), `4101` (clears C2D1), `52B2`/`5739`/`5D2F`
and `5404`/`58E8`/`5E9A` (field-changed tests on `wRam_C278`, unreached), `73DD` (screen-off helper), `Function_6C_61AC` (blinking prompt), `Function_70_46A6` (random event on SRAM `A9ED/A9EE`),
`Function_73_6143` (two getters).

## 7. Open questions

1. Meaning of the eight `CommPanel_CaptionMaps` captions and of `wRam_C28B` values 1-3 (which operation each stands for).
2. Text of the help pages: single-byte kana ($A1-$DF) versus hiragana glyph identity, and the tile mapping of `$E0-$FF` (docs/research/text_encoding.md open item 1) - bank 6C is
   identified as its reader (`HelpScript_StepText`/`HelpScript_SingleByteToSjis`).
3. What `65:47EA` does with the saved password (57:541C, `SavedPassword_Store` by pass 6) and why `C27A` gates it.
4. Whether the kinds 0/1/2 of `CommScene_*` correspond to dialing / connected / hanging up (7C:7D8D shows them being played back-to-back in unreached code).
5. `Config_DefaultImage1/3` are byte-identical to 0/2: the four-image table may exist for adapter types blue/yellow/red/green; only PDC/CDMA and DDI-Pocket texts are seen.
6. Never-executed paths: `Dev_InstallTestConfig` (65:46E5), `Account_ConfirmManualScreen`, several `Registration_*` error tails.

## 8. Observations for the region tables (not edited here)

* `Table_68_793F` (ptrtable) holds bank-4B tile addresses (`$5B6C..`), not own-bank code pointers; it is the tail of the 10-word digit table `Account_DigitTilemapTable` (68:793D).
* `Table_68_528C`, `Table_68_5E92`, `Table_68_659A`, `Table_68_635C` are word tables of bank-4A/5D pointers or (Y,X) pairs, correctly `words`.
* `6B:4000` (tilemap) is typed `zero`/`gfx`: the whole `$240` bytes at `6B:4000` are the BG map and `6B:4480-4C80` the tiles (rows 3-15 of the map hold the non-zero bytes).
* `72:7828` (`BrowserMenu_CursorObjTable`) is a real object table (17 four-byte entries); the immediates `ld de,$7828/$7858` at 72:45D2-46E0 are (Y=$78, X=$28/$58) coordinates, not pointers.
* `72:4E28`/`4E38` and `73:5DE0`/`5E20` are palette copies (`$10`/`$08`/`$40` bytes to `$D830/$D860/$D800/$D840`) inside larger regions.

A second pass re-derived 35 names (25 widely called or CONFIRMED ones plus 10 others across the seven banks) from the code, the ROM bytes, `traces/coverage_*.tsv`,
`config/ram` and the neighbouring namers' files, and re-rendered the 6B, 70, 71 (connect panel and delete screen), 5D (confirm and write-config screens) and 73 screens.
Upheld without change: the SRAM bank 1 settings-page routines, the bank 2 config image and its checksum, the default images/number strings, the dialog service (record format
decoded again for all 69 records), the two browser menus, the `wRam_C2C3` session kind (4E:488D sets 1 for the CGI pages, 4E:48CB/493B set 0 for the homepage), the account entry/confirm/result
screens (message table decoded), the DION connect panel, the browser start choice and its globe, the help menu entry (`Nav_TopMenu_Help` calls `HelpMenu_Run`), the non-CGB screen.

* Edit buffer header is `{capacity, free slots, count}` (`TextBuf_GetCount` = `[buf+2]`), not a separate cursor index (text is only appended at the end).

* `NonCgb_BgpFadeTable` holds four BGP values; the fifth byte `$D9` is the reti target of the VBlank stub.

* Bank 69: states 3..5 of `ConnIcon_StateTable` are started when `wRam_C2C3 == 1` (settings CGI session), not "page-list variants"; `ConnIcon_Tiles1` is all zero; the rendered frames of   `ConnIcon_Tiles0` are a small figure on a mound, so `ConnIcon` means "the sprite whose animation follows the online flag", not a plug/phone glyph.

* Bank 70: `wRam_C283` is set to 1 only for kinds != 0 that are online; the panorama shows mountains, a torii-like gate, skyscrapers and a pyramid (no pagoda).

* Bank 6C: help menu entry 4 is `MobileDict_Run` (named by the bank-1A pass), the A686-A689 flags are help-progress flags; `Table_65_567F` is now `PromptText_Table`.

Still open for the orchestrator (not edited here): the parallel RAM proposals of other passes at the same addresses differ in name and sometimes size
(`C26E/C26F` g2 `wConnWarn*` vs `wOnlineWarn*`, `C272/C273` g2/g6, `C277/C27A` g6 `wRegistrationStage`/`wRegSavePasswordChoice`, `DE80` g6 `wTextEntryBuf`,
`DEDD/DEEE/DEFF` g6 `wPhoneNumber*`, `DF10` g6 `wPhoneSlotFields` (153 bytes) vs g7 `wDialEntry0Number` (17), `B010` g6 `sRegistrationStage`); keep one name each.  `Dev_InstallTestConfig`
is statically unreachable (it follows the never-returning notice page 4 in `Registration_Aborted`), so its role name rests on the canned test strings only.
