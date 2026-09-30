# Naming pass g7: banks 68, 69, 6B, 6C, 70, 72, 73

> **Historical note.** Written when the source was one generated `src/bankNN.asm` per bank with generic `Label_BB_AAAA` labels.  In the current tree (`home/ engine/ data/ gfx/ audio/ lib/`) a `Label_BB_AAAA` that is only used inside its own function is a local label of that function (`.lAAAA`, `AAAA` = the address, or `.loop`/`.done`/`.skip`); one referenced from elsewhere keeps its global name; `Function_BB_AAAA`, `Data_BB_AAAA`, ... are unchanged, and where a semantic name was adopted the neutral name often remains as an alias label under it.  **Addresses (`bank:addr`) remain valid**: find the code with `grep -rn '; BB:AAAA' --include=*.asm .` or in `build/mobile_trainer.sym`.  Commands of the frozen bootstrap pipeline quoted here (`make regen`, `make verify`, `make tree*`, `tools/gen_asm.py ...`) no longer apply to the source (`gen_asm.py` only runs into a temp dir, `make legacy-check`); see `README.md`, "History", and `docs/README.md`. RAM names quoted here (`wRam_XXXX`, `sSram_XXXX`, `hRam_FFXX`) are the neutral names of `ram/*.asm`; where a semantic name was adopted, its `DEF` line there says `replaces wRam_XXXX`.

Scope: the seven banks named by pass 7/8.  Outputs: `config/symbols/bank{68,69,6B,6C,70,72,73}.tsv` (347 rows: functions, tables,
data blocks, labels, HYPOTHESIS rows that keep the generic name) and `analysis/naming/ram_g7.tsv` (67 RAM/SRAM proposals, not loaded by the
generator).  Everything rebuilds byte-identically (`python3 tools/gen_asm.py verify` on a copy of `config/` with these files: IDENTICAL).

Evidence vocabulary as everywhere: CONFIRMED (bytes/trace/rendered screen cited), PROBABLE (>= 2 independent pieces), HYPOTHESIS (an idea
recorded under the generic name, nothing asserted).  Addresses are `bank:addr` CPU addresses; "call site" addresses are the address of the
`call $06D1` (farcall) instruction, as printed by the tooling used for the check (see section 9).

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

## 2. Bank 68

### 2.1 Settings page in SRAM bank 1 (`B000-B0FD`, backup `B100`, XOR `$A5` fields)

Layout established from the store/load pairs `Settings_StoreStringField` (68:4A4A), `Settings_LoadAccountToWram` (68:4C69), `Settings_InitPage`
(68:4785) and the wizard call sites in bank 65:

| SRAM | size | field | evidence |
|---|---|---|---|
| B000 | 16 | magic `MOBILE TRAINER00` (`Settings_MagicString` 68:4000) | 68:4950 compares, 68:4785/4847 write |
| B010 | 1 | registration progress 1/2/3 (started / fields entered / complete) | 68:4A4A/4B48 -> 1, 68:4C2B -> 2, 68:43B9 -> 3; read by 68:4870, 65:4123 |
| B011 | 1 | adapter type (copy of `$C271`) | 68:43F4 |
| B012 | 1 | hidden-mode flag (B+SELECT+RIGHT) | 68:44FC/453B, 68:4FC0 |
| B013 | 1 | selected dial entry 0..2 | 68:4499/44D0, 00:15E7 |
| B014/B025/B036 | 3 x 17 | dial strings of the three entries | 00:161A table, 68:4608 |
| B047 | 31 | registered mail address | 68:4735, 68:41E9 |
| B066/B071/B07A/B07F | 11/9/5/9 | login id ('g' + 9 chars), mail local part, mail sub-domain, password | 65:4498-4601 store, 68:4C69 load |
| B088/B089/B08A | 1 each | save-password flag, hidden mode at registration, manual numbers | 65:442F, 65:42EB, 65:44F4 |
| B08B/B09C/B0AD | 3 x 17 | manual phone number 1, number 2, comment | 65:4544-4574 |
| B0BE | 1 | bit mask of stored fields (1 id, 2 mail, 4 password, 8/$10/$20 numbers) | 68:4A4A ORs it |
| B0FE/B0FF | 2 | LE sum of B000-B0FD | `Settings_UpdateChecksumAndBackup` 68:49B6 (also copies the page to B100) |

`Settings_VerifyAndRepair` (68:48DE) returns 0 ok / 1 restored from the backup / 2 no valid page but at least one magic present / 3 both magics bad;
`Settings_GetRegistrationProgress` (68:4870) turns that into 0 (blank), 1 (damaged) or 2/3/4 (= B010 + 1) for the startup code in 65:4000
(the other namers call the same values `Startup_*JumpTable` indices).  Quirk: the string-skip loop `Function_68_4495` has no `ret`; it falls into
`Settings_SetSelectedDialEntry`, so `Dial_SelectEntryFromList` (68:4469) also stores B as the selected entry as a side effect.

### 2.2 Adapter configuration image (SRAM bank 2 `A000`, `$C0` bytes, big-endian sum at `A0BE`)

`Config_BuildImageFromAccount` (68:6CF0) copies the default image for the adapter type (`Config_DefaultImageTable` 68:67D8 indexed by
`wRam_C271`; images 0/1 `DION PDC/CDMAONE`, 2/3 `DION DDI-POCKET`), then writes login id -> `+0C`, mail address -> `+2C`, `mail.<sub>.dion.ne.jp`
-> `+4A`, `pop.<sub>.dion.ne.jp` -> `+5E` (prefixes `Config_HostPrefixStrings` 68:6E03, suffix `Config_DionDomainSuffix` 68:6E0E) and, in manual mode,
number 1 -> `+76` (BCD, `PhoneNumber_PackBcd` 68:409A) and comment -> `+7E`.  The image is written to the adapter with MobileAPI `$04` by
`Registration_WriteConfigToAdapter` (screen 'アダプタ登録中 / 設定情報を登録中です', 65:4661) and verified online by
`Registration_VerifyAndFinalizeOnline` (65:467C): API `$0E/$0C/$10` read login id / dial slots (3 numbers + ID strings) / mail address, `$06` ISP login, `$1E` POP login (the `register`
trace shows `USER 11111111` / `PASS aZ01` on the fake server), `$0A` hang up, then `A002 |= $80` and a second `$04` write.
`Registration_DeleteExecute` (68:7B9A, '削除中 / 登録情報を削除中です') writes the cleared image and calls `Sram_WipeAllBanks` (68:42E4).
`wRam_C271` is the adapter type (BeginSession device byte minus `$88`, stored by the SDK through the pointer passed as DE to MobileAPI `$02`, 75:620B-6216).

### 2.3 Text entry and account screens

Edit buffers are WRAM3 `{capacity, free slots, count, chars...}` (`TextBuf_*` in bank 67 by pass 6; `DE80`, second one `DE94`).  The three keyboard screens
share one shape: `Setup` (gfx + `TextEntry_InsertString` preload), `UpdateOkState` (C27D/C27E = OK-enabled flag for the keyboard poll 55:5C8F), `InputLoop`
(insert 20AC bc=$38/$31, delete $39, OK $2C / back $2E), print-field helpers (Y=$15) and a commit function.

| screen | function | fields | rules seen |
|---|---|---|---|
| login id | `Account_LoginIdEntryScreen` 68:5296 | `DEA0` = `'g'` + 9 chars | OK when the 9-char buffer is full |
| mail address | `Account_MailAddressEntryScreen` 68:571D | local part `DEAB` (8), sub-domain `DEB4` (4) | sub-domain >= 3 chars; `Account_BuildMailAddress` gives `local@sub.dion.ne.jp` |
| password | `Account_PasswordEntryScreen` 68:5D00 (mode 0 enter, 1 again; 4 tile maps) | `DEB9` (8) | `Account_PasswordIsValid` = >= 4 chars with a digit and a letter (message 65:5389) |
| confirm | `Account_ConfirmScreen` 68:61F7 (manual twin 68:6435, never executed) | shows `DEA0`, `DFAA` | title 「次の情報をモバイルアダプタGBに登録します」, よろしいですか？ [はい][いいえ]; 1 proceed, 2 redo, 0 back |
| intro pages | `Account_{LoginId,Mail,Password}IntroPage` 68:55E1/5BC4/60BB | messages 0,1,2 of `PromptText_Table` (65:567F) | A -> 1, B -> 0 |
| action page | `Account_ActionConfirmPage` 68:6E1A | message `{4,11,12,13}` = verify registration / change password / usage time / usage fee | 2 buttons |
| result page | `Account_ResultPage` 68:766E | messages `{5,14,15,16}` plus 17 (error) / 18 (interrupted) | `Account_ResultPage_DrawTimeDigits` shows online time digits |

Message table `PromptText_Table` = 65:567F (20 entries, used through `Function_00_153D`): 0 login id prompt, 1 mail address prompt, 2 password prompt, 3 do not unplug the adapter,
4 verifying the registered information, 5 registration confirmed, 6/7 deletion warnings, 8 choose menu, 9 choose phone number input method, 10 number changed,
11 change password, 12 look at usage time, 13 look at usage fee, 14-16 finished pages, 17 communication failed, 18 interrupted, 19 password-saving notice.

### 2.4 Settings menu (モバイルせってい)

`SettingsMenu_Run` (68:4F9E) reads the hidden flag (`Settings_GetHiddenModeFlag`), runs four states through `SettingsMenu_StateTable` and returns 0 (B) or the item 1..4
(5 with the hidden flag = 電話番号の変更).  The 7C:7D60 table maps items 1-4 to 67:58CD (change password), 67:60BA (usage time), 67:626F (usage fee),
68:7951 (delete registration) and 5 to 67:4000 (change phone number).  Cursor persisted in SRAM `BF01`.

### 2.5 Communication panel

`CommPanel_Init/Step` (68:7405/7413) implement the 'DIONに接続中' panel (rendered from 71:4C98: title 「DIONに接続中」 and a '!注意' box holding message 3).  It is used by the
registration verify states, the 67 network screens, and by 4C:46B8/46D6 when `wRam_C2C3 == 1` (settings CGI page session).  Phase (C287) 0..2 and variant (C28B) pick the
caption `Table_68_764C[phase][variant]` -> `CommPanel_CaptionMaps` (bank-71 maps, 8 captions; the caption tiles are not among the blocks loaded by state 0, their text is HYPOTHESIS).
B cancels only when the variant is non-zero and the phase is not 2.

## 3. Bank 72: dialogs and browser menus

Record format of `Dialog_ListTable` (72:502B): four list pointers, then message pointers of list 1 (23, browser/phone texts) and list 2 (44, mail and address-book texts); lists 0 and 3 are one
blank record.  A record is `$86, type, default, line1(32 bytes)+00, line2+00 [, line3+00]` with 16 full-width characters per line.  Type 0/3 = no button, 1/4 = OK button,
2/5 = yes/no, 3-5 = 3-line window.  `Dialog_Open(D=list, E=index)` slides the window up (WY `$90 -> $48` or `$38`), `Dialog_WaitInput*` returns `hFFF6` (0 = B, 1/2 = first/second choice),
`Dialog_Close` slides it away.  The monitored variant additionally reports 3 (link lost), 4 (online-time warning), 5 (adapter error) when the dialog was opened while online (`wRam_C2CC`).
Browser menus: 2-item (`BrowserMenu_OpenTwoItem`, hang up / return to top menu, settings CGI session) and 3-item (page list / hang up / end homepage, homepage session); results feed the tables at 4E:4D6D.

## 4. Banks 69, 70, 73, 6B, 6C (short)

* **69**: `ConnIcon_*`; state `wRam_C2CE` (0..5, variants 3..5 started when `wRam_C2C3 == 1`, the settings CGI session) picks animations 1/2/4/5/6 of `ConnIcon_ObjTable` through `Function_4E_604C` depending on `wTimerEnable` bit4 (online);
  `wRam_C2CF` requests one of two tile sets (bank 69 or 51).
* **70**: `CommScene_*`: kinds 0/1/2 (`wRam_C27D`), states `wRam_C27C`, background scroll `wRam_C2A8` (copied to rSCX), sprite text arrows and eight 20x4 text boxes; the map is a panorama of
  landmarks (mountains, a torii-like gate, skyscrapers, a pyramid) - the bank-27 pass calls the mail-session equivalent 'world panorama'.  Never entered from the mail flows in the traces.
* **73**: `Browser_StartChoiceScreen` shows a rotating globe with a satellite (`BrowserStart_AnimFrames`, rendered) and two buttons; result 1/2 stored in SRAM `A8B7`.
* **6B**: rendered text 「【モバイルトレーナー】 このカートリッジは ゲームボーイカラー せんようです。 ゲームボーイカラーで しようしてください。」; VBlank vector `jp $4D1F` targets the `$D9` (reti) stored right after the four BGP values of `NonCgb_BgpFadeTable` (not a fifth table entry).
* **6C**: help menu (page 1 = 4 items, sub-menus of 2 and 3 items; items 2/3 are locked until the help-progress flags `A686-A689` are set), item 4 = `MobileDict_Run` (1A:4000, the mobile dictionary).
  Script ops at page level: 0 end, 3 text page, 4 jump, 5 set C0E6, 6 jump when skipping, 7/8 set skip target, `$10` set flag `A684+n`, `$18`/`$19` branch on flags; char level:
  bit7 = glyph byte (single-byte kana mapped through `HelpScript_SingleByteToSjis`), 0 page end, 1 newline, 2 style/speed, 3 caption string, 4 wait.

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

## 9. How the evidence was checked

* All `bank:addr` citations in the symbol/RAM files were checked to be instruction starts (or inside a data region) with a script that decodes every code region of `config/regions` (farcall aware), and caller
  lists were regenerated from the decoded `call`/`farcall` sites; the semantic claims were re-read against the disassembly.
* Screens were rendered from ROM tiles/tilemaps (bank 6B non-CGB screen, 72/73/70/71/5D/4A blocks): the texts quoted above (`DIONに接続中`, `アダプタ登録中`, `削除中`, `次の情報をモバイルアダプタGBに登録します`,
  the non-CGB message, the globe, the panorama, the books of the help menu) come from those renderings; the working images are in the session scratchpad only.
* Trace support: `traces/coverage_*.tsv` (which scenarios execute each entry point) and `traces/detail/register/adapter.log` (USER/PASS, EEPROM read/write), `traces/inputs/register.macro`.

## 10. Adversarial verification (post-review corrections)

A second pass re-derived 35 names (25 widely called or CONFIRMED ones plus 10 others across the seven banks) from the code, the ROM bytes, `traces/coverage_*.tsv`,
`config/ram` and the neighbouring namers' files, and re-rendered the 6B, 70, 71 (connect panel and delete screen), 5D (confirm and write-config screens) and 73 screens.
Upheld without change: the SRAM bank 1 settings-page routines, the bank 2 config image and its checksum, the default images/number strings, the dialog service (record format
decoded again for all 69 records), the two browser menus, the `wRam_C2C3` session kind (4E:488D sets 1 for the CGI pages, 4E:48CB/493B set 0 for the homepage), the account entry/confirm/result
screens (message table decoded), the DION connect panel, the browser start choice and its globe, the help menu entry (`Nav_TopMenu_Help` calls `HelpMenu_Run`), the non-CGB screen.

Corrections made in this pass:

* **Retracted** `CommScene_ClearBackground` (70:4638): it does not clear anything.  It HDMA-uploads the WRAM7 buffers `$D000`/`$D400` (the panorama map that
  `CommScene_LoadGraphics` has just copied there, source bank argument 0 = WRAM) to the BG map `$9800`; renamed `CommScene_UploadBackgroundMap`.
* Renamed the label `Registration_Verify_StateReadNumber` (68:70E5) to `Registration_Verify_StateReadDialSlots`: MobileAPI `$0C` is `MobileAPI_ReadDialSlots` in the SDK (3 dial numbers + ID strings).
* `Settings_VerifyAndRepair`: result 2 is "no valid page but at least one magic present" (primary sum bad and backup invalid, or primary magic bad and backup sum bad), not "both checksums bad".
* Edit buffer header is `{capacity, free slots, count}` (`TextBuf_GetCount` = `[buf+2]`), not a separate cursor index (text is only appended at the end).
* `NonCgb_BgpFadeTable` holds four BGP values; the fifth byte `$D9` is the reti target of the VBlank stub.  `NonCgb_Tilemap` is a 32x18 map, not 18x32.
* Bank 69: states 3..5 of `ConnIcon_StateTable` are started when `wRam_C2C3 == 1` (settings CGI session), not "page-list variants"; `ConnIcon_Tiles1` is all zero; the rendered frames of
  `ConnIcon_Tiles0` are a small figure on a mound, so `ConnIcon` means "the sprite whose animation follows the online flag", not a plug/phone glyph.
* Bank 70: `wRam_C283` is set to 1 only for kinds != 0 that are online; the panorama shows mountains, a torii-like gate, skyscrapers and a pyramid (no pagoda).
* Bank 6C: help menu entry 4 is `MobileDict_Run` (named by the bank-1A pass), the A686-A689 flags are help-progress flags; `Table_65_567F` is now `PromptText_Table`.
* Counts: 347 rows, of which 20 (not 25) are HYPOTHESIS rows; the dialog table holds 69 message records (73 words with the four list heads).

Still open for the orchestrator (not edited here): the parallel RAM proposals of other passes at the same addresses differ in name and sometimes size
(`C26E/C26F` g2 `wConnWarn*` vs `wOnlineWarn*`, `C272/C273` g2/g6, `C277/C27A` g6 `wRegistrationStage`/`wRegSavePasswordChoice`, `DE80` g6 `wTextEntryBuf`,
`DEDD/DEEE/DEFF` g6 `wPhoneNumber*`, `DF10` g6 `wPhoneSlotFields` (153 bytes) vs g7 `wDialEntry0Number` (17), `B010` g6 `sRegistrationStage`); keep one name each.  `Dev_InstallTestConfig`
is statically unreachable (it follows the never-returning notice page 4 in `Registration_Aborted`), so its role name rests on the canned test strings only.
