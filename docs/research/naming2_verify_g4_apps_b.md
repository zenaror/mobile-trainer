# Naming pass 2, group g4_apps_b: adversarial verification

Verifier's note on `analysis/naming2/g4_apps_b_renames.tsv` (233 applied rows, `docs/research/naming2_g4_apps_b.md`).  Every name was tried to be refuted against the ROM source, `build/mobile_trainer.sym`
(private copy, built SHA-256 OK), the ROM bytes, `analysis/coverage_union.tsv`, `traces/detail/*/dataaccess.tsv` and the RAM notes.  Corrections are in
`analysis/naming2/verify_g4_apps_b_fixes.tsv` (5 rows; applied in a private copy with `tools/apply_renames.py --strict`: 5 applied, 0 refused, `make` SHA-256 OK
`6d802e66...6570`, `sym_check` OK).  The manifest rows themselves are untouched.

## Result

| verdict | count | rows |
|---|---|---|
| upheld | 227 | all other rows (of which 9 carry a wrong or stale sentence in the evidence column, section 3; the name and status stay) |
| renamed | 5 | `Tilemap_AndOrRectCopy`, `Sram_SnapshotBootCounters`, `Sram_BuildCounterBlock`, `ConnIcon_GetFramePos`, `Data_Dialog_Msg0202` |
| status lowered | 1 | `Settings_IsRegistrationStarted` (PROBABLE to HYPOTHESIS, name kept; section 2) |
| refuted outright | 0 | |

Depth: every row got a mechanical check (label exists, address/bytes, pointer or call linkage, status against coverage).  Code was read at the label for all 55 function rows, all 31 inline
dispatch tables, all 60 dictionary entries, all 36 dialog records, the 14 menu strings, the 8 attribute maps, both bank 50 tile-set variants, the bank 51 summary A/B blocks and the ConnIcon/CommNotice
frame lists.

## 1. What was checked

### (a) Functions and tables

| name | verdict | reason |
|---|---|---|
| `Mailbox_IsRecordClosedEnvelope` | upheld | code at 25:5848 returns `$FF` only for record byte 0 == 1 (SRAM bank 0, 12-entry table stride `$12D`); 8 callers choose object 26:7BA0 instead of 26:7BB0 (`naming_g2` reads 7BA0 as the closed envelope).  "unread" is correctly not claimed.  PROBABLE is right |
| `MailBody_BlitBlankCellAdvance` | upheld | differs from `MailBody_BlitGlyphAdvance` only by preset B=2 C=0; both call sites follow `Glyph_LoadAscii` of `$20` |
| `Sram_VerifyChecksum3ResetOnMismatch` | upheld | body equals `Sram_VerifyChecksum3` plus `call Sram_ResetChecksum3Areas`; unreferenced; PROBABLE is the ceiling |
| `Tilemap_AndOrRectCopy` | **renamed** | the 31 bytes equal ROM0 `Tilemap_ApplyMaskRect` (00:091C, verified byte for byte) which does `[HL]=([HL]&D)\|E` in place, nothing is copied; the twin already has a name, so `Tilemap_ApplyMaskRect_48_4A8C` (STYLE.md rule for duplicates) |
| `Browser_HistoryPushFrom` / `Browser_HistoryUndoPush` | upheld | `Browser_HistoryPush` falls into it (`ld hl,$D500 ; ld a,6`); ring of 6 at `$AA00+A9FE*$100`, count `A9FF` capped at 6; the undo decrements `A9FD/A9FC` (mod 3) and `A9FF/A9FE` (mod 6); one caller (`page_view.asm:366`, GoBack result 0) |
| `Browser_FrameStylePreview_Run/_LoadGraphics/_RevealStep`, `Browser_ReloadFrameTilemap`, `Data_Browser_FrameWipeGroups` | upheld | the run code loads `hRam_FFD0/1=$41E0`, `RevealStep` walks the `$FFFF`-ended groups; A stores `style\|$80` into `wBrowserFrameStyle` and `sSram_A9EF` and returns 1, B restores it and returns 0 (file is `frame_style_chooser.asm`; "Preview" under-states but is true).  All unreferenced and only forced-executed; the entry of `_Run` is HYPOTHESIS in the source, PROBABLE is the ceiling |
| `Sram_SnapshotBootCounters` | **renamed** | called from `Startup_Run`, executed in 63 scenarios, proven; but `A9F0-A9F3` are never written anywhere in the ROM (`ram/sram.asm`: w=0), so "counters" is not shown (the manifest note itself says their meaning is unknown).  New name `Sram_SnapshotA9F0PairsAtBoot` states the copy |
| `Sram_BuildCounterBlock` | **renamed** | unreferenced, source header HYPOTHESIS; the demonstrated content is the 16-bit differences against the boot snapshot: `Sram_BuildA9F0DeltaBlock` |
| `Sram_CountMobileError12Or26` | upheld | code compares `wMobileErrorCode` with `$12`/`$26` and increments `A9E3`; 2 callers |
| `ConnIcon_GetFramePos` | **renamed** | reads word `+$19` of the descriptor of `wBrowserFrameStyle` (browser frame style); the same pass named `ConnIcon_Anim1..6Frames` (animation frame lists), so "Frame" clashed; `ConnIcon_GetBrowserFramePos` |
| `Palette_CaptureAnd*`, `Palette_FadeIn/OutBlackSlow`, `Palette_Fade*ObjPalSlow` (8) | upheld | same bodies as the executed white fades with `bc=$0000` (black) or `wPalFadeMode=3`; steps `$F0`/`$10` (slow) vs `$E0`/`$20`; `PalFade_Start_ModeTable` targets confirm mode 3 = 4 colours at `$D970/$D9F0`.  The two "reached only by fall-through" names are correct (no reference, entered from the capture prologue) |
| `Smtp_MeasureField/_CopyFieldToWork/_CopyDisplayName/_MeasureBody` | upheld | `Smtp_StartMailFrom` callers around `" ("`, `String_Mail_CloseParen` (copy of at most 16 bytes), `$A040` body staging (`sram_layout.md`: `A040-A0FF`, `$C0`); the two measure routines are the same loop, only the store to `wRam_C245` differs |
| `Mail_SplitFromHeader`, `Mail_ScanAndCheckGameMail` | upheld | `(`-branch and no-bracket branch executed (12 scenarios), the `<>` branch is not (correctly PROBABLE); `Text_HalfToFullWidth` call present; selectors 1 and 2 of the mail library are `Mail_ScanHeaders`/`Mail_CheckGameMail` (`lib/mobile/mail.asm:130`) |
| `Mail_CopyClampedEllipsis`, `Mail_SkipToDigit`, `Mail_SkipSpaces`, `Mail_CountDigits` | upheld, CONFIRMED stands | executed in 12 scenarios (2009/804/268/134 hits); the ellipsis branch was taken (`Data_Text_Ellipsis2` read as data in 6 scenarios); caller counts in the evidence match |
| `Mail_ApplyTimezoneOffset` | upheld | see section 3 (it also adds 9 hours) |
| `Kbd_UpdateSticky`, `Kbd_Store/ClearStickyCol/Row`, `Kbd_TypeNeedsExtraPalette`, `Kbd_TypeHidesOnKey82/83` | upheld | table bytes match the evidence (6EE1: types 5-10; 6F0D: 5,6,8,9; 6F23: 5-9); uses in `Kbd_Open`/`Kbd_Run_ButtonA` match |
| `Kbd_ClearSticky` | upheld, evidence wrong | see section 3 |
| `Comm_ClearSessionActive`, `Screen_FadeOutAndResetObjWindow`, `Sram_WipeBanks2And3`, `TextEntry_InsertMaskedString`, `Settings_GetAdapterType`, `Account_*` (7) | upheld | mechanics read from the code and the twins (`Account_*_UpdateOkState`, `Settings_StoreAdapterType`, `Sram_WipeAllBanks`); the SRAM addresses of the three "changed" twins line up with the bits of `wSettingsFieldMask` (B066 bit 0, B071/B07A bit 1, B07F bit 2) |
| `Settings_IsRegistrationStarted` | status lowered | see section 2 |
| 31 inline dispatch tables | upheld | each label sits exactly 3 bytes after a `call JumpTableInline` (`$0545`) or `call JoypadDispatch` (`$056A`) (checked on the ROM bytes); owner function, selector and handler lists match the code for `Browser_LoadPage_SchemeTable`, `_SessionKindTable`, `Browser_LoadAndDispatch_ResultTable`, `Browser_PageView_Enter/GoBack/OpenMenu_DialogResultTable`, `Browser_Menu_*PromptTable`, `PalFade_Start/Step_ModeTable`, `Browser_StartMenuLoop_ResultTable`, `Kbd_LoadPageGraphics_TypeTable` (11 words, first target = end), `Dialog_SetupCursorByType_TypeTable`, `BrowserMenu_RunTwoItem_*` |
| 12 CONFIRMED tables | upheld | dataaccess traces read every byte for 11; for `Account_ResultPage_InputTable` only entries 0 and 4 (section 3) |
| `Table_6A_64B1` (HYPOTHESIS row) | confirmed off by one | ROM bytes `9B 64 6A D3 64 E6 64`: `64B2 = $6A` is the bank byte, pairs start at `64B3`; the `dw $6A64` at `64B1` is wrong.  Correctly left neutral |

### (b) Strings

| group | verdict | reason |
|---|---|---|
| `String_Dialog_Msg<id>` (35 + `Data_Dialog_Msg0202`) | upheld (one rename) | `Dialog_Open` (72:402A): `C=D`, `HL=Dialog_ListTable+2*D`, then `HL+=2*E` (D is zeroed first): id = list*256 + entry index of the `dw` inside the list.  I recomputed every label against its position in `dialog_messages.asm` (36/36 equal; `Msg0000` is list 0 entry 0 and list 3 entry 0 points at the same record, so `$0300` shares it).  Independent proof: the placeholder messages print their own number in decimal (`$0106` "１０６", `$0201` "２０１", `$020A` "２１０", `$0212` "２１８", `$0220` "２３２", `$0222` "２３４": list*100+entry).  Ten ids against caller and text: `$010F` "でんわをきっています" (`notice_dialog.asm`, before `Comm_Disconnect`), `$0110` "でんわがきれました" (after it), `$0113` "もどれるページが　ありません" (`Browser_PageView_GoBack`), `$0108` "ページのないようをけします" (`PageList_DeleteSlot`, 24:521E), `$0200` "かきかけのメールは　きえて..." (`MailCompose_ConfirmDiscard`), `$0202` "かいたメールを　セーブします" (`MailBody_Edit`), `$0206` "もらったメールを　けします" (`Mailbox_IconMenu_PressA`), `$0209` "かいたメールを　けします" (`MailDraft_Menu_Loop`), `$021F` "メールボックスがいっぱいで..." (`Nav_MailMenu_SendReceive`), `$0224` "ほかのソフトのメールがあります" (`MailServerStatus_Screen`).  Every label byte is `$86` with NUL before it.  13 of the 36 record starts were read in traces, the other 23 rest on the proven table arithmetic only; CONFIRMED is acceptable for the arithmetic (a disassembly fact), not for "someone displays it".  The `Data_` prefix of `Msg0202` (3 header bytes cut as data by the classifier) broke the `String_Dialog_Msg*` family: renamed |
| `String_MobileDict_Cat<NN>Entry<KK>` (60) | upheld | script over the ROM: category NN = pointer NN-1 of `Table_MobileDict_Categories` (`MobileDict_LoadPage` does `dec a ; add a,a` on `wRam_C0D4`, so categories are 1-based), entry KK = pointer KK of the category's list (count byte first, entries 0-based); 60/60 named labels match, e.g. Cat03 = サ row (サーバ, サイト, ...), Cat07 = マ row (メール ... モバイルホームページ), Cat11 = Latin/symbol words.  The eleven groups follow the kana rows plus one for Latin words, which also agrees with the 11 `Table_MobileDict_TabPositions` tabs.  Reads in traces cover the first entries only; PROBABLE is fine |
| `String_MailMenu_Title/Text<k>` (11) | upheld | `MailMenu` calls `Ticker_Start` with `B = wRam_C0E5-1` (cursor) and `HL = Data_MailMenu_StringIndexBank`; `Ticker_Start` reads the bank byte then pair `B` (`B*4 + HL`), so pair k = menu entry k: titles and texts match the menu (メールをかく, メールボックス, アドレスちょう, プロフィール, メールサーバ).  Pair 6 (`メールをかくにん`, `$4581/$4592`) is what entry 1 shows when a draft exists (`MailMenu_GetLabelIndexA`); it is unlabelled, correct |
| `String_TopMenu_Title0/Text0/Title2/Text2`, `Data_TopMenu_StringIndexBank`, `Table_TopMenu_Strings` | upheld | pairs `$400D/$4014`, `$4043/$4050` (verified inside the `Text0` block), `$409F/$40A6`; same `Ticker_Start` call with `B = wRam_C0E5-1` at `top_menu.asm:166/609` |

### (c) Inline jump tables (32 names)

All 31 call-fed tables: placement on the ROM bytes (table label = call address + 3), owner function by nearest primary label, selector by the instruction before the call, length by the words until the first handler (or
`JoypadDispatch`'s fixed 5).  Samples read in full: `Browser_PageView_GoBack_DialogResultTable` (message `$0113`, 6 words), `Browser_Menu_DisconnectPrompt_DialogResultTable` (message `$0101`: result 1 = yes), `PalFade_Step_ModeTable`,
`BrowserMenu_RunTwoItem_DialogResultTable` (`hDialogResult` doubles as the 2-item cursor), `Browser_StartMenuLoop_ResultTable`, `CommNotice_InputTable`, `Dialog_SetupCursorByType_TypeTable` (`wDialogType` = byte 1 of the `$86 aa bb` record header; types 0-5 occur in the records; type >= 3 goes to `Dialog_OpenTall`).  The `JoypadDispatch` order (A, B, Select, Start, none) is in `home/jump_table.asm`.  No table is misplaced; owners are right.

### (d) Graphics

| names | verdict | reason |
|---|---|---|
| 8 `Attrmap_CommNotice_*` | upheld | each label = tilemap label + `$168` (20x18) exactly; `Tilemap_CopyRectAndAttr` (00:08EA) continues with the same source pointer for the second pass at `dest+$0400` |
| `Gfx_CommNotice_A/B_Tiles*`, `Palette_CommNotice` | upheld | variant A = `wRam_C0D6==0` (`ld a,[wRam_C0D6] ; or a ; jp nz,.l4173` at 50:409B); tile counts (`c=$40/$1A/$01/$32`) and block sizes agree with the label distances (`$400/$1A0/$10/$320`); `Palette_CommNotice` = 4 x `$40` at `6BC0/6C00/6C40/6C80` by the four load sites.  The evidence says the A call sites never ran: wrong, they ran in 4 scenarios (section 3); the B branch did not |
| `Gfx_CommTime_SummaryA/B_*`, `Palette_CommTime_SummaryA/B` | upheld | `wCommSessionKind==1` selects A (`cp $01 ; jr z,.l40BF`); sizes `$400` per tile block, palette `$40`; B is also loaded by `send_receive.asm:1880-1898` (second site confirmed) |
| `ConnIcon_Anim1..6Frames`, `CommNotice_Anim0/1Frames`, `CommNotice_ObjTable` | upheld | `ConnIcon_ObjTable` words are `4794,48AC / 4794,48AC / 48B5,... / 49DE / 4A73 / 4BAB / 4A05`; entry N = B value passed to `ConnIcon_StartSprite` (B=1,2,6,4,5 seen, B=3 never); first target of each list = its end (8, 8, 1, 4, 2, 3 pointers; notice 2, 2).  For bank 50 the B path uses `ld de,$6D1A` (= entry 1) so `Anim1Frames` is the variant-B list |

## 2. Status corrections (name kept, manifest row untouched)

| name | manifest | should be | reason |
|---|---|---|---|
| `Settings_IsRegistrationStarted` | PROBABLE | HYPOTHESIS | unreferenced (source header HYPOTHESIS, entry unproven); only "`sSram_B010 xor $A5` is nonzero" is demonstrated.  "registration started" depends on the RAM proposal `sRegistrationStage`, which the RAM pass explicitly did not adopt, and the neighbour `Settings_SetProgressState3` calls the same byte "progress state" |

Rows where the manifest is conservative (could be raised, no change needed): `Kbd_ClearSticky` (executed, section 3), `Gfx_CommNotice_A_Tiles*` (the four A loads executed, 4 scenarios),
`String_TopMenu_Title0/Title2/Text2` (source already CONFIRMED: read in 11 scenarios).

Rows whose PROBABLE rests on unreferenced code whose source header still says HYPOTHESIS ("no entry proven"): `Sram_VerifyChecksum3ResetOnMismatch`, `Tilemap_ApplyMaskRect_48_4A8C`, `Sram_BuildA9F0DeltaBlock`,
`ConnIcon_GetBrowserFramePos`, `TextEntry_InsertMaskedString`, `Sram_WipeBanks2And3`, `Settings_GetAdapterType`, six `Account_*`, `Browser_FrameStylePreview_Run`.  PROBABLE is tolerable only because the decoded bodies are
coherent and three of them are byte-exact copies or twins of executed routines; none of them is executed.

## 3. Wrong or stale sentences in the evidence column (names and statuses stand)

* `Kbd_ClearSticky`: "unreferenced sibling" is false.  `Kbd_Open` calls it (`keyboard.asm:111`, 55:5C8B `call $617B`), executed 1676 times in 35 scenarios (`coverage_union.tsv`).  Only the two unlabelled single-store twins behind it are dead.
* `Gfx_CommNotice_A_Tiles9000/9400/8000Vb1/9000Vb1`: "call sites were never executed" is false for variant A (50:40A2-40F5 executed 4 times in 4 scenarios); variant B (50:4173...) is unexecuted.
* `Account_ResultPage_InputTable` (CONFIRMED): "every byte read in a trace" is false, only entries 0 and 4 are read (`771A-771C`, `7722-7724`).  The 5-word layout is fixed by the executed `JoypadDispatch`, so CONFIRMED stands.
* `CommProgress_Init_KindTable`, `CommProgress_Step_KindTable`: "the handlers run `CommScene_Init/Step`" only holds for kind 0; kind 1 runs `CommPanel_Init/Step`.
* `Mail_ApplyTimezoneOffset`: the evidence omits that after normalising a numeric `+/-hhmm` offset to UTC the code adds a fixed 9 hours (`add a,$09 ; daa` at 54:5287, Japan time); a header without `+`/`-` returns before that.  The name is still right, the purpose is broader.
* `Browser_LoadPage_SessionKindTable`: the table sits inside `Browser_LoadPage_Http` (nearest primary label), fine under the `Browser_LoadPage_` prefix.
* `Sram_SnapshotBootCounters` note "meaning of A9F0-A9F7 unknown, the name states only the copy-and-clear" contradicted the name; fixed by the rename.
* `String_Dialog_Msg0000`: list 3 entry 0 (`$0300`) points to the same record; the name covers `$0000` only.

## 4. Mechanical observations

* `Data_Browser_FrameWipeGroups` prints numbers such as `$0020`, `$0040`, `$0100` as `Rst_20`, `Vector_VBlank`, `Entry` (already noted by the group); the build is identical, but the label values would move if a ROM0 symbol moved.
* `Table_6A_64B1` is off by one byte as the group reported (bytes checked above); no other off-by-one was found (every dialog label starts on `$86` after a NUL, every dictionary entry on a string start, every frame list ends where its first frame starts, every
  attribute map starts exactly `$168` after its tilemap).
* Two names of the pass were found to carry a different meaning of "Frame" (`ConnIcon_GetFramePos` vs `ConnIcon_Anim*Frames`); fixed by the rename.
