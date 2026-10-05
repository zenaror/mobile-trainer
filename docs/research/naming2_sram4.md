# SRAM names pass 4 (sram4): bank-qualified names for the raw SRAM operands

> Status: **reference (current)** for the names and the symbolized operands it lists.  Follows [`naming2_ram3.md`](naming2_ram3.md) (banked variable `wKbdSlideDeltaRow`, the bank-1 variable page) and the
> bank-qualified names of the earlier passes (`ram/banked.asm`).  Manifests: [`analysis/naming2/sram4_names.tsv`](../../analysis/naming2/sram4_names.tsv) and
> [`analysis/naming2/sram4_sites.tsv`](../../analysis/naming2/sram4_sites.tsv); verification by three independent readers: [`naming2_verify_sram4.md`](naming2_verify_sram4.md); tool:
> `tools/apply_banked_names.py` (`--check` audits the overlapping names).

## 1. Result

| item | count |
|---|---|
| bank-qualified names added to `ram/banked.asm` | 85 (63 CONFIRMED, 22 PROBABLE; SRAM bank 0: 11, bank 1: 42, bank 2: 17, bank 3: 15; 52 arrays, 17 bytes, 14 structs, 2 words) |
| raw operands (`ld hl\|de\|bc, $XXXX`) replaced by a name | 349 in 52 files (189 site rows, each with the proof of the bank); `name + $XX` where the operand lies inside a larger object |
| operands converted by hand | 3 in `smtp.asm` (one operand in two banks inside one function), 12 uses of five neutral names (`ld a, [sSram_B010]` ...), the two `dw $B014, $B025, $B036` tables |
| existing declaration corrected | `sSram_MailRecords` size 3868 -> 3612 (12 x $12D; the profile name starts at $AF40) |
| overlap audit | `python3 tools/apply_banked_names.py --check`: 141 names, 98 overlapping pairs, 0 errors, 0 notes |
| ROM | byte-identical (`make`: `RESULT: IDENTICAL`; `sym-check`, `tidy_comments --check`, `localize_labels --check`, `tree_check`, the overlay and banked audits and the tool tests pass); a scan of the diff shows every changed source line is a name-for-number substitution |

## 2. Method

The raw operands (about 360 lines `ld hl|de|bc, $A000-$BFFF`) were split by address into three packages: A (`$B000-$BFFF`: the settings page in bank 1, the browser page buffer and the POP3 blocks in
bank 3), B (`$A000-$A5FF`: mail drafts and records, the page list, the adapter configuration image and the registration and password-change scratch, the network work area) and C (`$A600-$AFFF`: help script variables,
tutorial gates, saved password, address book, checksum blocks, menu cursor memory, browser history, profile).  Each package was written by an executor in a private copy: for every operand the **bank at the site** was proven
(the select just before the access, `ld a, <bank> ; ldh [hSRAMBank], a ; ld [rRAMB], a`, or the A argument of `ReadByteFar`/`WriteByteFar`, or a caller that selects it, checked by a ROM scan for every caller), the object
(size, kind, writers, readers) was re-derived from the code, and the natural traces (`analysis/coverage_union.tsv`, `traces/detail/*/dataaccess.tsv` byte ranges, `traces/mbc_writes_*.tsv` bank writes) were compared with it.
An independent reader then re-derived every row.  The tool counts the lines per (file, operand), refuses a wrong count, and builds and compares the ROM.

## 3. The 85 names

| name | bank:address | size | kind | status |
|---|---|---|---|---|
| `sSaveBank0Page0` | S0:$A000 | 4096 | struct | CONFIRMED |
| `sMailDraft_ToAddress` | S0:$A000 | 64 | array | CONFIRMED |
| `sMailDraft_Body` | S0:$A040 | 192 | array | CONFIRMED |
| `sMailDraft_Subject` | S0:$A100 | 20 | array | CONFIRMED |
| `sMailDraft_ToName` | S0:$A114 | 16 | array | CONFIRMED |
| `sMailRecord1` | S0:$A251 | 301 | struct | CONFIRMED |
| `sMailRecord2` | S0:$A37E | 301 | struct | CONFIRMED |
| `sMailRecord3` | S0:$A4AB | 301 | struct | CONFIRMED |
| `sMailRecord4` | S0:$A5D8 | 301 | struct | CONFIRMED |
| `sProfileName` | S0:$AF40 | 16 | array | CONFIRMED |
| `sProfileAddress` | S0:$AF50 | 64 | array | CONFIRMED |
| `sPageList` | S1:$A000 | 1668 | struct | CONFIRMED |
| `sPageList_Titles` | S1:$A000 | 132 | array | CONFIRMED |
| `sPageList_Urls` | S1:$A084 | 1536 | array | CONFIRMED |
| `sChecksum3Block1` | S1:$A684 | 16 | array | CONFIRMED |
| `sHelpScriptVars` | S1:$A684 | 16 | array | CONFIRMED |
| `sHelpSeenMail` | S1:$A686 | 1 | byte | PROBABLE |
| `sHelpSeenAddressBook` | S1:$A687 | 1 | byte | PROBABLE |
| `sHelpSeenHomepage` | S1:$A688 | 1 | byte | PROBABLE |
| `sHelpSeenPageList` | S1:$A689 | 1 | byte | PROBABLE |
| `sAbookSlots` | S1:$A69D | 480 | array | CONFIRMED |
| `sChecksum3Block2` | S1:$A87D | 56 | struct | CONFIRMED |
| `sSavedPasswordLen` | S1:$A880 | 1 | byte | CONFIRMED |
| `sTutorialGateHomepage` | S1:$A881 | 1 | byte | CONFIRMED |
| `sSavedPasswordText` | S1:$A88D | 8 | array | CONFIRMED |
| `sTutorialGateMailMenu` | S1:$A89A | 1 | byte | CONFIRMED |
| `sTutorialGateTopMenu` | S1:$A89B | 1 | byte | CONFIRMED |
| `sChecksum3Sum` | S1:$A8B5 | 2 | word | CONFIRMED |
| `sMenuCursorMemory` | S1:$A8B7 | 32 | array | PROBABLE |
| `sBrowserStartMenuCursor` | S1:$A8B7 | 1 | byte | CONFIRMED |
| `sMailMenuCursor` | S1:$A8B8 | 1 | byte | CONFIRMED |
| `sTopMenuCursor` | S1:$A8B9 | 1 | byte | CONFIRMED |
| `sSramCheckBank1Sum` | S1:$A8D7 | 2 | word | CONFIRMED |
| `sSaveCheckBlockTag` | S1:$A9E4 | 4 | array | CONFIRMED |
| `sSaveCheckStateBlock` | S1:$A9E8 | 16 | struct | CONFIRMED |
| `sCommTimeTotal` | S1:$A9F8 | 4 | array | PROBABLE |
| `sBrowserHistory` | S1:$AA00 | 1536 | array | CONFIRMED |
| `sSettingsPage` | S1:$B000 | 256 | struct | CONFIRMED |
| `sSettingsRegistrationProgress` | S1:$B010 | 1 | byte | CONFIRMED |
| `sSettingsAdapterType` | S1:$B011 | 1 | byte | PROBABLE |
| `sSettingsDialNumbers` | S1:$B014 | 51 | array | CONFIRMED |
| `sSettingsMailAddress` | S1:$B047 | 25 | array | PROBABLE |
| `sSettingsLoginId` | S1:$B066 | 11 | array | CONFIRMED |
| `sSettingsMailLocalPart` | S1:$B071 | 9 | array | CONFIRMED |
| `sSettingsMailSubdomain` | S1:$B07A | 5 | array | CONFIRMED |
| `sSettingsPassword` | S1:$B07F | 9 | array | CONFIRMED |
| `sSettingsSavePasswordFlag` | S1:$B088 | 1 | byte | CONFIRMED |
| `sSettingsHiddenAtRegistration` | S1:$B089 | 1 | byte | PROBABLE |
| `sSettingsManualNumbersFlag` | S1:$B08A | 1 | byte | PROBABLE |
| `sSettingsNumberInternet` | S1:$B08B | 17 | array | PROBABLE |
| `sSettingsNumberSelfPage` | S1:$B09C | 17 | array | PROBABLE |
| `sSettingsNumberComment` | S1:$B0AD | 17 | array | CONFIRMED |
| `sSettingsBackup` | S1:$B100 | 256 | struct | CONFIRMED |
| `sConfigImage` | S2:$A000 | 192 | struct | CONFIRMED |
| `sConfigRegState` | S2:$A002 | 1 | byte | PROBABLE |
| `sConfigLoginId` | S2:$A00C | 32 | array | CONFIRMED |
| `sConfigMailAddress` | S2:$A02C | 30 | array | CONFIRMED |
| `sConfigSmtpServer` | S2:$A04A | 20 | array | CONFIRMED |
| `sConfigPopServer` | S2:$A05E | 20 | array | CONFIRMED |
| `sConfigDial0Number` | S2:$A076 | 8 | array | CONFIRMED |
| `sConfigDial0Text` | S2:$A07E | 16 | array | CONFIRMED |
| `sConfigDial1Number` | S2:$A08E | 8 | array | CONFIRMED |
| `sConfigDial1Text` | S2:$A096 | 16 | array | CONFIRMED |
| `sConfigDial2Number` | S2:$A0A6 | 8 | array | CONFIRMED |
| `sConfigDial2Text` | S2:$A0AE | 16 | array | CONFIRMED |
| `sConfigImagePad` | S2:$A0C0 | 64 | array | PROBABLE |
| `sRegVerify_ApiArgs` | S2:$A100 | 59 | array | PROBABLE |
| `sRegVerify_LoginId` | S2:$A200 | 33 | array | CONFIRMED |
| `sRegVerify_DialSlots` | S2:$A222 | 102 | array | CONFIRMED |
| `sRegVerify_MailAddress` | S2:$A244 | 31 | array | CONFIRMED |
| `sNetWorkPage` | S3:$A000 | 4096 | array | PROBABLE |
| `sSmtp_HeaderText` | S3:$A100 | 3840 | array | CONFIRMED |
| `sNetStartUrl` | S3:$A100 | 256 | array | PROBABLE |
| `sPwdChg_ApiArgs` | S3:$A100 | 37 | array | PROBABLE |
| `sPwdChg_LoginId` | S3:$A200 | 33 | array | CONFIRMED |
| `sPwdChg_PostBody` | S3:$A363 | 75 | array | PROBABLE |
| `sPwdChg_HttpUrl` | S3:$A463 | 982 | array | PROBABLE |
| `sBrowserPageBuf` | S3:$B000 | 4096 | array | CONFIRMED |
| `sBrowserFramePreview` | S3:$B000 | 2048 | struct | PROBABLE |
| `sPop3RetrBodyPtrLen` | S3:$B009 | 4 | struct | CONFIRMED |
| `sPop3TopSummary` | S3:$B400 | 256 | struct | CONFIRMED |
| `sPop3TopSubject` | S3:$B410 | 26 | array | CONFIRMED |
| `sPop3TopSourceLabel` | S3:$B430 | 20 | array | PROBABLE |
| `sPop3TopSenderName` | S3:$B450 | 16 | array | CONFIRMED |
| `sPop3TopSenderAddress` | S3:$B470 | 64 | array | CONFIRMED |

The settings page fields (`sSettings*`, bank 1 `$B010-$B0BE`) tile exactly (sizes sum to `$AF`) and match the `TextBuf_Init` capacities of the matching WRAM buffers; the mail address field is a `$1F` slot of which 25 bytes are the
longest address the code builds (`B060-B065` spare).  The adapter configuration image (`sConfigImage`, bank 2) has the layout the SDK reads (magic "MA" at +0, login id +`$0C`, mail address +`$2C`, SMTP host +`$4A`, POP host +`$5E`,
the three dial numbers and texts, checksum of `$BE` bytes at +`$BE`).

## 4. Overlays

Bank 3 `$A000-$BFFF` (and bank 2 `$A000-$A2FF`) are scratch areas that unrelated code reuses: the HTTP receive buffer (`sBrowserPageBuf`, a chain of `[len16][body]` records closed by a zero word), the SMTP envelope and header
text, the POP3 parse and summary blocks, the password-change buffers, the registration verify scratch.  Each subsystem gets its own names, so the ranges overlap; STYLE.md (section 4, "Overlay names in banked memory") accepts an
overlapping pair when no source file mentions both, when one is the container of the other (a `struct`, or an umbrella name whose `DEF` comment says `container`: `sNetWorkPage`, `sMenuCursorMemory`, `sHelpScriptVars`,
`sSram_MailRecords`, `sVarPage`), or when the `DEF` comment of one says `overlay:` and names the other (the one phase overlay inside a file: `sRegVerify_DialSlots` and `sRegVerify_MailAddress`).  All 98 overlapping pairs of
`ram/banked.asm` meet one of the three; every overlapping name says `overlay:` and lists the others.  `sBrowserFramePreview` is the weakest name (dead code, PROBABLE: its root routine has no caller).

## 5. What the pass corrects in earlier notes

* **`sSram_MailRecords` size.**  `ram/banked.asm` said 3868; 12 records of `$12D` bytes are 3612 (`$E1C`) and end at `$AF3F`: `$AF40` is the profile name (`ram/sram.asm` already said 3612).  Fixed.
* **Bank 3 `$B000`** is the browser page buffer, not a variable-length record list of `.bmp` file names (`sram_layout.md`): `Browser_WrapImageInHtml` only prepends a wrapper HTML record to a BMP reply.  `B400-B4FF` is the POP3 TOP summary
  and `B009-B00C` the pointer and length that the mail library writes for a RETR body.
* **`B011` (adapter type)** is not "read back decoded" (`68:4430-446C`): its only reader, `Settings_GetAdapterType`, has no reference and never ran.  `B047-B065` is a `$1F` slot, not the extent of the address.
* **Bank 2.**  `A100-A1FF` is not "cleared by `68:4260-4281`": `Config_ClearSramMirror` clears `A000-A0FF` (the configuration image and its `$FF` pad); `A100-A11D` is the registration verify argument block and `A200-A287` its outputs
  (MobileAPI `$0E`, `$0C`, `$10`).  Bank 2 and 3 are wiped completely at every browser session start (`Browser_ClearCaches`), so `sConfigImage` and `sRegVerify_*` are volatile scratch too.
* **Bank 3 password change.**  `A100` arguments, `A200` login id, `A263` date descriptor, `A363` POST body, `A463` URL (the settings_redirect trace writes `A463-A838`, 982 bytes: the size is a lower bound); `A000-A01F` and
  `A100-A1F5` in `mail_send` are the SMTP envelope and header text.
* **Bank 1 `A000`** is the page list (saved pages: six title slots of `$16` bytes, six URL slots of `$100`), no longer a HYPOTHESIS; the bank 0 draft staging (`A000` To address, `A040` body, `A100` subject, `A114` display name) is confirmed by the
  SMTP builder.
* **Bank 1 `$A600-$AFFF`.**  `A69D-A87C` is the address book (six slots of `$50`: name `$10`, mail address `$40`), `A684-A689` the help script variables (var 0 = id of the page being run; vars 2-5 the seen-topic flags), `A880/A88D` the saved
  password (XOR `$5A`), `A881/A89A/A89B` the tutorial gate counters (only completed passes increment; `$FF` is saturation, not a "disabled" state), `A8B7-A8D6` the menu cursor memory (zeroed at every boot; `A8C1` is only written, by a never-run path),
  `A9E4-A9EB` the checksum 4 block, `A9FC/A9FD` the page cache ring, `A9FE/A9FF` and `AA00-AFFF` the browser history ring (six entries of `$100`; depth saturates at 6, the wrap never ran).  The checksum-1 writer
  `SramCheck_Bank1StoreSum` (`22:5077`) did run (113 hits in 11 scenarios), contrary to the generated note.  `A9EF` is the browser frame style; `A9EE` (2-4 or `$0A-$0F` from `Random16`) and `A9ED` are touched only by never-run code.
* **Bank 0 `AF40/AF50`** are the profile display name (16) and own mail address (64), refreshed at every `Profile_Edit` entry.  The dead installer `SampleData_InstallNameAddressPair` (`2D:4635`, no caller, not even in the forced runs)
  selects bank **1** before writing them, so as written it fills history entry 5 (`sBrowserHistory + $540/$550`): a comment at the routine says so.  Side finding: the last iteration of `MailRecord_Delete` copies `$12D` bytes from
  `$AF40` into record 11 before it is zeroed (harmless).
* `naming_g7.md:113` says the help menu has sub-menus of 2 and 3 items: both have 2.  The names `sHelpProgress` and `sTutorialStep*` proposed by g7 are superseded by `sHelpSeen*` and `sTutorialGate*`.

## 6. Not converted, and why

* The tool replaces only `ld hl|de|bc, $XXXX` lines.  Direct accesses through the old neutral names (`ld a, [sSram_B010]`, 12 lines of five names) and the two `dw $B014, $B025, $B036` tables were converted by hand; the other `dw` tables of
  SRAM addresses (`adapter_config.asm` `$A076/$A07E`, `page_list.asm`, `page_list_prototype.asm`, the `$A124..$AE13` record tables in about 14 mail files) and the neutral `sSram_A9xx` direct accesses stay numeric.
* Data that spells a bank and an address keeps its numbers: `Data_54_4C35` and `Data_54_4FC3` (the mail library output descriptor `B000`, `$800`), `Table_PageCache_Slots` (`4C:4CEA`).
* Not SRAM (found by the census, left numeric): `$AFFF` x2 in `page_results.asm` (`$B000 - 1` arithmetic for `CopyBytesBackward`), `$AAAA` in `top_menu.asm` and `$B000` in `tidy.asm` (off-screen sprite positions), `$BB44` in `audio/engine.asm`
  (an `rNR51` mask pair).  The bank-wide wipes (`helpers.asm`, `clear_all_banks.asm`, `history_cache.asm`) use the constant `_SRAM` (`$A000`).
* Weak spots the readers listed: `sConfigImagePad` (inferred from the `$FF` fill and no reader), the Internet / self-page number labels (inferred from the screen print order), the sizes of `sPwdChg_ApiArgs`, `sPwdChg_PostBody`,
  `sRegVerify_ApiArgs` (derived maxima, above what the traces show), and the 22 PROBABLE names in general.

## 7. Reproduce

`python3 tools/apply_banked_names.py --names analysis/naming2/sram4_names.tsv --sites analysis/naming2/sram4_sites.tsv --tag ram4 --strict` (a second run reports every row as `already applied`); `python3 tools/apply_banked_names.py --check`
audits the overlaps; `python3 tools/test_banked_names.py` runs the 21 tests.  The hand edits are listed in section 1; the `DEF` comments of the overlapping names carry `container` or `overlay:`.
