# SRAM names pass 4: independent reference of the three manifests (85 names, 189 site rows)

## 1. Result

| package | area | names | UPHELD | CORRECTED | site rows | UPHELD | CORRECTED | strict run of the corrected manifests (fresh copy of HEAD `7aa4f01`) |
|---|---|---|---|---|---|---|---|---|
| A | `$B000-$BFFF` (settings page, browser page buffer, POP3 blocks) | 24 | 18 | 6 | 57 | 56 | 1 | 24 names, 112 operands in 22 files, 0 refused |
| B | `$A000-$A5FF` (drafts, records, page list, config image, scratch) | 36 | 25 | 11 | 81 | 81 | 0 | 36 names, 134 operands in 25 files, 0 refused |
| C | `$A600-$AFFF` (help, gates, password, address book, checksums, history, profile) | 25 | 17 | 8 | 51 | 49 | 2 | 25 names, 103 operands in 20 files, 0 refused |

Bank per call site of the shared writers: proven in the callee, not at the call sites: `Settings_StoreStringField` (`68:4A4A`) selects WRAM bank 3 at `4A52-4A56` and SRAM bank 1 at `4A5F-4A63`, then `EncodeXorA5` writes through DE; `Settings_StoreByteField` (`68:4B48`) selects bank 1 at `4B5A-4B5E` and writes `ld [hl], a` at `4B69`; FarCall (`00:06D1`) preserves A and HL through the HRAM trampoline and does not touch BC or DE; all 18 farcall sites in `registration.asm` pass pointers that are bank 1 (StoreStringField: `4339` and `44A4` (B066, B = 1), `4359` and `44C4` (B071, B = 2), `4367` and `44D2` (B07A, B = 2), `4405` and `45FC` (B07F, B = 4), `453F` (B08B, B = `$08`), `4558` (B09C, B = `$10`), `456F` (B0AD, B = `$20`); StoreByteField: `42E3` and `4455` (B089, A = `wHiddenModeFlag`), `4427` and `461E` (B088, A = `wSavePasswordFlag`), `44ED`, `44FC` and `4511` (B08A)); all other sites select bank 1 inline or in their own wrapper.

`sSettingsMailAddress` size 25: UPHELD (PROBABLE): 25 is the proven maximum (`wAcctMailAddress` is 8+1+4+11+NUL, from the TextBuf capacities and `Account_BuildMailAddress` `68:419C`); 31 is the slot to B066, exactly the span `Settings_ClearFieldsKeepProgress` clears (`bc = $66` from B000); recommended: the DEF text says "slot `$1F`, `B060-B065` spare".

`sSettingsNumberInternet` / `sSettingsNumberSelfPage`: PROBABLE is right (`PrintAccount` `68:65EA` prints DEA0 (y = `$13`), DFAA (`$33`), DEDD (`$43`), DEEE (`$53`), DEFF (`$63`); the decoded labels on that screen are in order login id, mail, "for the Internet", "for the self page", comment; `PhoneKeypad_Run` A = 0 gives DEDD and A = 1 gives DEEE; the pairing of rows with labels is an inference); `sSettingsNumberComment` can stay CONFIRMED (its own entry screen `PhoneComment_KeyboardSetup` is titled "Enter a comment" and fills DEFF; the text also says "self-page comment", so a name like `sSettingsSelfPageComment` would be more precise: optional).

`sPop3RetrBodyPtrLen`: UPHELD: record of `Mail_ParseBody`, descriptor `Data_54_4FC3` = `03 | A002 | 03 | B000 | 0800`; single-part layout: B000 count, B001-B005 header-block record, B005-B006 header length, B007 type, B008 bank, B009-B00A pointer, B00B-B00C length, B00D zero terminator (matches the traces byte for byte); caveat: a first part with NAME= (type 3, `0F:4B4B`) would shift the pointer by 4 (the traces show this only for later parts).

POP3 TOP block (B400): fields +0 date (6 bytes), +`$10` subject (26 = the clear), +`$30` label (b = `$13` -> 20), +`$50` name (clamp `$10`), +`$70` address (clamp `$40`), +`$FF` flag, all re-derived; bank 3 holds at every `pop3_top.asm` site (`Pop3_StartTop` `54:494C-4950` selects it; `Mail_Dispatch`/`Mail_Return` restores around each library call); TOP does not use the library output stream (its first 8-byte blob is overwritten by the 7-byte blob before the only dispatch, selector 6).

Sites the tool cannot convert (12 direct lines of 5 neutral names, all bank 1 or 3, manually symbolizable): `sSram_B010`: `settings_page.asm:90` and `:114`, `helpers.asm:607` (dead); `sSram_B000` / `sSram_B001`: `page_results.asm:180` and `:182`; `charset_convert.asm:651/653` and `:719/721` (page-conversion code, bank 3 selected by the callers `4C:4557` and `67:5C5E`); `sSram_B450`: `pop3_top.asm:434`; `sSram_B4FF`: `pop3_top.asm:246` and `:445` (`sPop3TopSummary + $FF`); the two `dw $B014, $B025, $B036` tables (`far_string.asm:150`, `adapter_config.asm:468`): `dw sSettingsDialNumbers, sSettingsDialNumbers + $11, sSettingsDialNumbers + $22`.

`Table_PageCache_Slots` remains unresolved because its fourth slot is not indexed.

Limits: static reading of every site plus the `traces/detail/*/dataaccess.tsv` ranges (these do not record the PC, so the bank at each site rests on the code and on range-level agreement); no emulator; screen labels from `image_text_inventory.md`, not re-decoded from the images; the multipart library layout beyond the first part, and the type-3 case, were not re-derived; names outside this package and the SRAM bank 0/2 uses of `B000-BFFF` (mirror pages, page-cache slots) were not checked.

The reader's own recount of every `ld hl|de|bc, $A000-$A5FF` line covers 137 lines exactly once (81 rows + the unresolved row), counts match, and all 135 `(Lnnn)` / ROM-address pairs in the proofs match the reader's own probe table.

Support for the "title" reading: `Browser_Menu_PageList` `4E:4D7B` copies the `$14`-byte page title (WRAM4 `D000`) to `D3C0`, and `PageList_DrawAllTitles` `24:48C7` draws the slots.

* `sNetStartUrl`: the C380 buffer is not "copied by `Browser_LoadPage_Request` `4C:43D6`": `4C:4291` (`Browser_LoadPage_Http`) copies C380 -> D400 with bc = `$0100`; `4C:43D6` copies D400 back to C380 and to D500; strings seen are 60 and 51 bytes (traces A100-A13B and A100-A132).

* `sRegVerify_DialSlots`: "ID string" is wrong: the second string of each pair is the text field, the same as `sConfigDial*Text`; the strings are packed back to back (`ExportDialSlots` leaves DE at the NUL, then `inc de`), not fixed pairs; the `MobileAPI` `$10` result at A244 overwrites the block from +`$22` on, not "the tail"; the ISP number at A222 is untouched.

* `sPwdChg_ApiArgs`: the bank-3 restore is also in `PasswordChange_State_Finish` `67:5CC2`, not only Cleanup / Abort; the trailing "0" of the request descriptor is `00 00` = the two strings that follow the URL pointer (`MobileAPI_HttpGet` validates two strings at `75:4EB8`; `Http_StartPost` copies `C1E0` / `C220`).

* `sPwdChg_LoginId`: "read and write exactly A200-A220" is wrong: reads end at A21F (settings_cgi, settings_redirect, title_settings); only settings_redirect writes exactly A200-A220 (33 bytes).

* Not an error, an omission to consider: `Browser_ClearCaches` wipes banks 2 and 3 completely at every browser session start (`4E:4962` -> `4C:4C4E`); `Table_PageCache_Slots` (`4C:4CEA`) uses bank 2 `$A000-$BFFF` and bank 3 `$A000` as page-cache slots; traces show bank-2 bulk reads A000-AFFF / A000-BFFF in 7 scenarios; so `sConfigImage` and `sRegVerify_*` are volatile scratch too (the rows were not changed).

Method: every site read statically; in addition `traces/mbc_writes_*.tsv` lists the real RAMB writes (pc, value, frames): 53 of the 108 naturally executed site lines have a local select earlier in their function, and each such select (same pc, same value) appears in the traces of the scenarios where the site ran; the other 55 inherit the bank, and their callers are proven.

`Config_MirrorUpdateChecksum` `68:45F1`: the ROM scan finds exactly two farcalls (`68:6DFC`, `68:72F7`) and no other call, jp or pointer; `68:6DFC` is after `.l6DF3`, both bank-1 detours end in `pop af ; ld [rRAMB], a`, `Config_BuildImageFromAccount` has a single caller (call at `68:6C28`, after the bank-2 select at `68:6C20`); `68:72F7` is inside `Registration_Verify_StateWriteConfig`, bank 2 from `68:70C7` / `68:70CB`, seen in 7 scenarios.

`Config_ClearSramMirror` `68:4252`: bank 2 at `68:4260`, hl = `$A000`, bc = `$0100` (`68:4264` = 2 in 17 scenarios); `Config_MirrorChecksumOk` selects bank 2 itself at `68:45A8`.

`Smtp_StartMailFrom` has exactly three `$A000` lines in two banks: L137 (bank 0), L144 and L221 (bank 3); mail_send dynamics: `54:45FE` = 0, `54:460E` = 3, `54:462D` = 0, `54:4670` = 0, `54:46CF` = 3 (frames 3585-3586), then `54:47C6` = 0 at frame 3622; for `54:47B2` (`Smtp_DataPoll` step 1, bank 3): no RAMB write with a unique pc lies between frames 3586 and 3622, no `00:1660 val=03` ReadByteFar restore exists in the run; the wire log shows the header block after DATA, and bank 3 reads A100-A1F5 (a bank-0 read would have sent the draft subject).

POP3: `Mail_ScanAndCheckGameMail` has two callers (RetrPoll, TopPoll), both after `Pop3_Start*` selected bank 3; mail_receive writes bank 3 AFFF (L731).

Password change, registration verify and `Net_BuildLoginPostBody` inherit their banks (the ReadLoginId select `67:5AFB` = 3 has its restore at `67:5DE9`; `Config_ClearSramMirror` inside Cleanup restores 3, so bank 3 persisted through all states; `Net_BuildLoginPostBody` has a single caller, which calls `BankSwitch_H` with A = 3 at `4C:4413`; no cited select relies on `BankSwitch_H` with A = 0, which means "no change"; ReadByteFar selects bank A even for A = 0). 2.

`_SRAM`: all 9 sites are in multi-bank wipes: helpers L480 and L493 (explicit banks 2 and 3), L525 (loop 0..3), clear_all_banks x4 (banks 0-3), history_cache x2 (banks 2, 3); `_SRAM` = `DEF _SRAM EQU $A000` (`constants/hardware.inc:244`, standard landmark, unused until now), so the name is right.  usage_fee L80 / usage_time L113 as `sNetWorkPage`: acceptable (the bank is explicit and the pointer is the start of the work area initialised right after; only the fill (`$2000`) is larger than the declared 4096; `_SRAM` would be equally right and consistent with history_cache L190). 3.

`sSram_MailRecords` size 3868 is wrong: 12 x `$12D` = 3612 = `$E1C`, ending at `$AF3F` (AF40 is the profile name); evidence: the 12-word table `2D:417D`, the `MailRecord_Delete` zero-fill `ld hl, $AE13 ; bc = $012D`, 12 reads in `Mailbox_CountRecords`, MAILREC_COUNT/SIZE, and `ram/sram.asm` itself saying 3612; 3868 runs into the B000 mirror page; fix by hand in `ram/banked.asm` (the tool cannot edit existing DEFs).  sample_data: all 22 offsets are right (+0 header 9 bytes, +9 body, +`$C9` name, +`$D9` subject, +`$ED` address); bank 0 is selected at `2D:4195` (forced run only), and `SampleData_CopyString` does not touch the bank.

Sizes: ApiArgs 37, PostBody 75 and `sRegVerify_ApiArgs` 59 are derived maxima, above the observed 26 / 46 / 30, so honest as stated; `sNetStartUrl` 256 is the consumer buffer (observed 60 / 51); `sNetWorkPage` 4096 fits (the reply bc = `$0FFF` plus the terminator at `$AFFF`); `sPwdChg_HttpUrl` 52 was the one dishonest size (fixed to 982).

Suggested STYLE.md line: banked names may overlap: a field or element inside its struct/array name, or the views that different modules take of one time-shared scratch area (S2/S3 `$A000-$AFFF`: config image, registration and password-change scratch, SMTP/POP3 buffers, browser page cache); a view is used only in the files its DEF note lists, the umbrella name (`sNetWorkPage`) only for base pointers and whole-area wipes, and the note names the other names sharing the bytes (S2 is time-shared too, not only S3). 5.

`sram_layout.md` contradictions quoted: both TRUE (`Config_ClearSramMirror` clears `$A000-$A0FF` (bc = `$0100`, hl = `$A000`); settings_redirect writes exactly bank-2 `A000-A0FF`, and 7 scenarios write exactly `A000-A0FF`; the bank-1 six slots are the page list (titles `$16` + URLs `$100`)); others the doc needs: bank 2 `A100`/`A200-A287` are the `sRegVerify_*` scratch; bank 3 `A363`/`A463` are password-change buffers (A100 args, A200 login id, A263 date, A363 body, A463 URL); bank 3 `A000`/`A100` are the SMTP envelope, header and POP3 buffers.

One defect outside the manifests: `sSram_MailRecords` is declared `size 3868` in `ram/banked.asm` and must be 3612 (point 7).

`sSavedPasswordText` cites "57:45AC, 244 hits": `57:45AC` is the per-character loop (1,015 hits); 244 is the entry `57:459A/459C`. 4.

Gate rows: "$FF = gate disabled (no store of $FF found)" and "every pass increments": there is no constant store of $FF, but `inc a` reaches $FF after 255 completed passes, and then `cp $FF ; ret z` stops the counter for good: $FF is saturation, not a separate disabled state; only completed passes increment (an aborted page, B pressed on page 1, `HelpScript_Run` returns B = $FF, `ret nz`, leaves the counter unchanged); the mail row also reverses the order: `Nav_TitleStart` runs the top-menu gate first, then `Nav_MailMenu` the mail gate. 5.

`sAbookSlots`: tables are "in 2A/2F": `Abook_SlotAddrTable0-7` are all bank 2F; further copies are in 2A and 2C. 7.

`sBrowserHistory`: "ring" is stated without saying the wrap never ran (`4C:4BA8`, `4C:4BE7`, and the depth saturation at 6 never executed; the deepest pop read entry 1); CONFIRMED stays because push, pop and reset ran naturally (72, 79, 210 hits). 8.

The existing line `sSram_MailRecords ... size 3868` (point 7).

Nits, left UPHELD: `57:4795` writes 0 via `xor a ; ld b, a`, not `ld b, $00`; the A686 read in `ItemIsLocked` uses `or b`, not `or d`; the op-$19 handler ends at `6C:5C06`, not 5BF0.

`HelpMenu_ShowPage` decodes B as level = (B >> 3) + 1 and cursor = B & 7; the menu selection returns item + 8 at level 2 and item + $10 at level 3, so ids 1, 9, $0A, $11, $12 come from the menu; only the five gate sites in `48:498C-4A67` pass `$81`, `$89`, `$8A`, `$91`, `$92`; `HelpScript_Run` has no other callers.

Var 0 is tested by 11 ops: the ten at `6C:4809-4836` (id to topic start 483E, 4BC2, 51AA, 5433, 56F4) and `IF var0 == 09` at `6C:5172`, which skips the gate-only nickname page in menu mode; bit 7 is tested at `6C:5D6D` (SELECT handler): set jumps via `wHelpScriptAltPtr` to the topic's end block, clear restarts and returns B = 0.

The whole script `6C:4809-58C6` parses cleanly: 85 text pages, 90 op-06, 6 op-04, 5 op-08, END at 58C6; its only variable ops are those 11 IF and `STORE var1..5 = 1` once each (`6C:4BBC`, 51A4, 542D, 56EE, 58C0); vars 6-15 are never used; var 1 has no reader.

The flag-to-topic mapping rests on more than end-block position: each topic opens with an op-08 whose target is its own end block (483E -> 4BBC var 1 intro, 4BC2 -> 51A4 var 2 mail, 51AA -> 542D var 3 address book, 5433 -> 56EE var 4 home page, 56F4 -> 58C0 var 5 page list); the captions decode with the ROM's own glyph table to メール, アドレスちょう, ホームページ, ページリスト; the lock logic reads A686|A687 and A688|A689 exactly as described; was retained as PROBABLE in this static-only review; later natural ID `$09` and `$89` route captures confirm the topic association, including the `$A686` 0-to-1 transition on first use (see `mail_help_script_natural_route_20261023.md` and `mail_first_use_id89_natural_route_20261023.md`).

Caller counts: home 125 entries (87 increments), pages `$91` 39x and `$92` 12x; mail `$89` 4x, `$8A` 21x; top `$81` 11x.

`sAbookSlots` is 6 x `$50`: `Abook_StoreEntryToSram` copies `$10` from D514 to slot + 0 and `$40` from D4C0 to slot + `$10`; `Abook_ClearSlot` and `Abook_ProbeSlot` (114 hits / 9 scenarios) confirm; natural dynamic writes in slot-sized ranges: A69D-A6ED, A73D-A78D, A82D-A87D, whole A69D-A87D. 4.

Menu memory, checksums: A8B7-A8D6 is zeroed in `Startup_Run` at `65:4009` (663 hits / 63 scenarios); A8BA-A8C0 and A8C2-A8D6 have no absolute reference anywhere in the ROM; A8C1 has one write at `73:60FA` (timeout path, never ran) and no reader.

Checksum 4: A9E8+16 stores [~lo, ~hi, lo, hi] at A9E8-A9EB (E -> A9EA, ~E -> A9E8, D -> A9EB, ~D -> A9E9); A9E4 continues the sum over A000+`$684` plus A9E4+4; it is consistent only when the old check bytes sum to `$1FE` (ResetBlock sets that, then falls into Update).

Push copies `$100` bytes from WRAM bank 6 D500 (or HL passed to `PushFrom`) to `$AA00 + head * $100`, then advances head mod 6; pop does the reverse and returns the first byte in A (0 means empty); reset fills `AA00 + $600` and clears A9FE/A9FF; bank 1 everywhere.

Page cache: A9FC = write slot 0-2 (mod 3), A9FD = count 0-3, over `Table_PageCache_Slots` `4C:4CEA`; slots are `$A000`/2, `$B000`/2, `$A000`/3; the 4th triple `$B000`/3 is the live page store copied in and out; the wrap and saturation never ran naturally. 6.

Mail record sites: the arithmetic is right: `$AE13` = +`$CEF` (record 11); `$A6A1/$A6B1/$A6C5` = `$A5D8 + $C9/$D9/$ED` = +`$57D/$58D/$5A1`; bank 0 is selected at `2D:4195` and in `2D:4134`.  12 x `$12D` = 3612, so the object ends at `$AF3F`; the declared size 3868 is wrong: it spills over `sProfileName`/`sProfileAddress` and the bank-0 mirror page B000-B03F; dynamic proof: `MailRecord_Delete`'s last iteration reads `$12D` bytes from AF40, and deletion scenarios show bank-0 reads A000-B06C.

Cross-package: package B names `sMailRecord1-4` (`$A5D8`, size 301) and uses `sMailRecord4` for the header and body lines of the same sample routine; if B is merged, the three record-4 rows read better as `sMailRecord4 + $C9/$D9/$ED` (the reader left them as they are because that name does not exist in the repo yet). 8.

Unresolved rows: `$AFFF` x2 (`4C:4EE1`, `4C:4EE8`): `$B000 - 1` arithmetic for `CopyBytesBackward` in bank 3, executed once: not a variable (optional hand edit: `sSram_B000 - 1`, a neutral name already used in that routine); `$AAAA` (`1F:43E3`): D = E = `$AA` position for `Sprite_SetPosition`, not SRAM.

The reader could not tie "the A9ED/A9EF correction" to any statement in the manifests; its own reading: the doc row A9EF is accurate (bits 0-6 in 1..`$1A`, bit 7 unexamined by the checks); A9EF is also the browser frame style (`Browser_BeginSession` loads it into `wBrowserFrameStyle`, 244 hits; the never-run chooser at `4E:4191` stores style | `$80`); A9ED/A9EE are absent from the doc and used only by dead code.

Limits: static reading plus `coverage_union` and traces; no emulator run; ring wrap and the PasswordChange paths never ran naturally; the absolute-operand scan covers `ld a, [nn]`, `ld [nn], a` and `ld r16, nn` (computed accesses, history entries and address-book slots, rest on code reading); all 118 `BB:AAAA` citations were checked: instruction start or label, except `6C:56EE` and `6C:56F4`, which are correctly cited script data addresses; hit counts match `coverage_union` except the one in error 3; packages A/B rows were verified only for collision and overlap (no name collisions across A, B and C; the only overlap is containment: package B's `sSaveBank0Page0` contains `sProfileName` and `sProfileAddress`).
