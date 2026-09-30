# Naming pass 2, group g4_apps_b

Second naming round over the neutral labels (`Function_BB_AAAA`, `Data_`, `Table_`, `String_`, `Attrmap_`, `Palette_`) that the first round (`naming_g1` .. `naming_g8`, `naming_sdk`) left behind in the application banks:
19 1A 1B 1C 1D 1F 0E 48 4C 4E 4F 50 51 54 55 57 5C 5D 68 69 6B 6C 70 72 and the banks that no other group owns (1E, 25, 28, 4A 4B 4D, 6A, 71 ...).  Banks 00, 04, 0F, 22-24, 26, 27, 29-2F, 65, 67, 73-75, 7F belong to other groups.

Deliverable: `analysis/naming2/g4_apps_b_renames.tsv` (252 rows: `old_name new_name kind status evidence`).  HYPOTHESIS rows keep `new_name == old_name` and are not applied.  The manifest was applied in a private copy with `tools/apply_renames.py --strict`:
233 rows applied, 46 files changed, 233 alias labels added, `make` SHA-256 OK (ROM unchanged) and `sym_check` OK.

| status | functions | tables | data / gfx | strings | total |
|---|---|---|---|---|---|
| CONFIRMED | 4 | 12 | 1 | 35 | 52 |
| PROBABLE | 51 | 30 | 25 | 75 | 181 |
| HYPOTHESIS (kept neutral) | 14 | 5 | 0 | 0 | 19 |

All 69 neutral `Function_` labels of the scope were examined: 55 named, 14 left as HYPOTHESIS with an idea.  Names follow the bank's neighbours (`Mailbox_`, `Browser_`, `Kbd_`, `Smtp_`, `Mail_`, `Account_`, `Palette_`, `Sram_`, `ConnIcon_`); every name was checked against the whole tree, the RAM/const files and the other manifests in `analysis/naming2/` (no clash).  Method: code read, callers/callees, RAM names, tables, strings decoded through the charmap, `config/symbols/*.tsv` notes; the status rule is the one of `STYLE.md` section 1.  The names of unreferenced routines describe the mechanics (what is read, written, compared), not a purpose nobody has seen run.

## 1. Functions by subsystem

* **Mailbox and mail body (25, 28).**  `Mailbox_IsRecordClosedEnvelope` (25:5848) returns `$FF` iff byte 0 of the SRAM mail record is 1 and its eight callers use that to choose the closed-envelope sprite; "unread" stays unproven (the name says only what the sprite choice is).  `MailBody_BlitBlankCellAdvance` (28:429F) is the padding twin of `MailBody_BlitGlyphAdvance`.
* **Bank 48.**  `Function_48_4A8C` is byte-identical (31 bytes, compared with `baserom.gbc`) to ROM0 `Function_00_091C`: `Tilemap_AndOrRectCopy`, unreferenced.  `Function_48_48BC` is an unreferenced variant of `Sram_VerifyChecksum3` that also resets the areas: `Sram_VerifyChecksum3ResetOnMismatch`.  `Function_48_48BB` (a bare `ret` far-called from 14 screen entries) stays neutral.
* **Browser (4C, 4E).**  History/cache: `Browser_HistoryPushFrom` (the body `Browser_HistoryPush` falls into; HL/A select the buffer), `Browser_HistoryUndoPush` (undoes one push of the 6-entry history ring and the 3-slot page cache).  The whole unreferenced "frame style" code of bank 4E forms one unit: `Browser_FrameStylePreview_Run` (draws a frame style, A saves it in SRAM `A9EF`, B restores the old one), `_LoadGraphics` (twin of `Browser_LoadFrameGraphics` that snapshots the map to SRAM bank 3), `_RevealStep` (reads the snapshot back along `Data_Browser_FrameWipeGroups`, a diagonal reveal), plus `Browser_ReloadFrameTilemap`.  Never executed naturally; the names rest on the code, not on a trace.
* **SRAM block helpers (4E).**  `Sram_SnapshotBootCounters` (boot, all scenarios), `Sram_BuildCounterBlock`, `Sram_CountMobileError12Or26` (`$26` is the command timeout forced at 68:7364).  `A9F8-A9FB` is where `CommTime_ShowSummary` stores `wCommTimeTotal`; the meaning of `A9F0-A9F7` is still unknown, so the names state only the copy/count/clear.
* **Palette fades (4F).**  Eight unreferenced helpers: four "capture the live palette, then fall into the fade" prologues (`Palette_CaptureAnd...`), two black fades (`Palette_FadeInFromBlackSlow`, `Palette_FadeOutToBlackSlow`, same shape as the white `...Slow` pair with target `$0000`) and two one-OBJ-palette fades (`wPalFadeMode` 3).
* **Mail transport (54).**  SMTP header helpers (`Smtp_MeasureField`, `Smtp_CopyFieldToWork`, `Smtp_CopyDisplayName`, `Smtp_MeasureBody`), POP3 (`Mail_SplitFromHeader`, `Mail_CopyClampedEllipsis`, `Mail_ScanAndCheckGameMail` = mail-library selectors 1 and 2 on the SRAM-bank-3 mail), date parser helpers (`Mail_SkipToDigit`, `Mail_SkipSpaces`, `Mail_CountDigits`, `Mail_ApplyTimezoneOffset`).
* **Keyboard (55).**  The remembered-position logic of `Kbd_MoveCursor` (`Kbd_UpdateSticky` and the four store/clear handlers reached through `Kbd_UpdateSticky_StoreDirTable` / `_ClearDirTable`, named from `wKbdStickyCol/Row`) and three of the six keyboard-type predicates (`Kbd_TypeNeedsExtraPalette`, `Kbd_TypeHidesOnKey82/83`).  `Function_55_6EAA/6EC0/6EEC` (cursor-on-OK-cell flags, one unreferenced) stay neutral: the flags they return depend on `wRam_C2B4` and the `wKbdMode` values, which are not understood.
* **Account/settings (68).**  Confirmation screen helpers (`Account_ConfirmManualScreen_BuildTextMap/UploadTextTiles`, executed, same shape as the sibling screen's), the unreferenced "changed / OK state" twins of the three entry screens (`Account_LoginId_ClearFlagIfChanged`, `..._OkStateFromMask`, ...), getters/setters of the settings page (`Settings_GetAdapterType`, `Settings_IsRegistrationStarted`), `Sram_WipeBanks2And3`, `TextEntry_InsertMaskedString`, `Comm_ClearSessionActive`, `Screen_FadeOutAndResetObjWindow`.  `Function_68_5D2F` is only a `ret`; the password twin starts unlabelled behind it.
* **Left neutral on purpose (HYPOTHESIS rows).**  Bare hooks (`48:48BB`, `5C:5266`, `68:4282`), `Function_68_4495` (skip-string routine without `ret` that falls into `Settings_SetSelectedDialEntry`, so every call also stores B: probably a source quirk), `54:41C5`, `4E:6172`, `55:6041`, `6C:61AC` (sprite bob, prompt arrow is a guess), `70:46A6` (random roll over SRAM `A9ED/A9EE`), `7C:7D8D` (unreferenced CommScene demo chain).

## 2. Tables and data

* **Inline dispatch tables (32 names).**  Every `call JumpTableInline` / `call JoypadDispatch` table whose selector is known is named after its function and selector: `<Func>_InputTable` (joypad: A B Select Start D-pad), `<Func>_ResultTable` (`wBrowserFetchResult`), `<Func>_DialogResultTable` (`hDialogResult`), `<Func>_KindTable` (`wCommSessionKind`), `PalFade_Start/Step_ModeTable` (`wPalFadeMode`), `Kbd_*_DirTable` (`wKbdMoveDirection`).  The browser state machine is now readable as tables (page view, go back, follow link, menus).  Tables whose end is a heuristic in the source comment are PROBABLE.
* **Connection-icon / notice animations.**  `ConnIcon_Anim1..6Frames` are word 0 of the entries of `ConnIcon_ObjTable` (B&$7F, as passed by the 69:40xx state setters; entry 0 shares the list with entry 1, nobody passes B=3); `CommNotice_ObjTable` and its two frame tables follow the same structure.
* **Bank 50/51 graphics.**  The eight notice attribute maps take the name of the tilemap they pair with; the two tile sets are `A` (`wRam_C0D6==0`) and `B`; the time summary has two screens (`Summary A` for `wCommSessionKind==1`, `B` otherwise) with their tiles and palettes.  Tile names carry the VRAM destination (`Tiles9000`, `Tiles9400`, `Tiles8000Vb1` ...).
* **Strings.**  `String_MobileDict_Cat<NN>Entry<KK>` (60 labels, from the category pointer tables behind `MobileDict_LoadPage`), `String_MailMenu_Title/Text<k>` and `String_TopMenu_*` (ticker pairs), `String_Dialog_Msg<id>` (36 labels): `Dialog_Open` indexes `Dialog_ListTable` with `DE = list<<8 | entry`, so the id of a message is fixed by its position; it matches the ids seen in callers and text (`$0110` "でんわがきれました", `$0113` "もどれるページが　ありません", `$0206` delete-mail prompt, `$021F` mailbox full).  Only labels that are a table target are named; records inside a labelled block stay unlabelled.

## 3. Findings worth keeping

* `Table_6A_64B1` is off by one byte: `HelpMenu_ShowItemText` passes `HL=$64B2` (locked items: `Data_6A_6651`) and `A=$6A`, i.e. the text-bank byte is at `$64B2` and the pairs start at `$64B3`; the source label (and its first `dw`, which reads `$6A64`) starts one byte early.  Left as a HYPOTHESIS row.
* `Data_4E_41E0` (and similar tables) print numbers such as `$0020`, `$0040`, `$0100` as ROM0 symbols (`Rst_20`, `Vector_VBlank`, `Entry`): the disassembler turned equal values into labels.  Harmless for the build, misleading for a reader.
* `Function_48_4A8C` = `Function_00_091C` (31 identical bytes): another private copy of a ROM0 routine inside a bank (see also the masked palette fades of bank 48).

## 4. Gaps (not named, with reason)

* **Bank 05 audio** (`Table_05_*`, 45 tables, 163 `Data_05_*`): per-song/per-sfx channel tables; naming needs the song/sfx identity, which no pass has fixed.
* **Keyboard pages (55)**: `String_55_*` / `Data_55_*` are rows inside the named `Data_Kbd_Page_*` blocks, and `Table_55_6869/686F`, `697C/6982` are split halves of one table; a row-by-row naming would be guesswork on the page layout.
* **Bank 70 comm scene** (94 `Data_70_*`, 26 `Table_70_*`) and its graphics (`gfx/comm/comm_scene.asm`): the scene kinds are not understood; `Table_70_40B3..40D3` are clipped pieces of `CommScene_KindTable`.
* **Bank 69 frame records** (`Data_69_*`, 33): OAM frames of `ConnIcon_Anim*Frames`; only the frame lists were named.
* **Bank 72 messages**: the unlabelled records between the named message labels and the 35 `String_72_*` labels that are not a table target (second lines of a record) stay neutral; `Data_72_*` (22) not examined.
* **Graphics tile blocks of banks 5D, 4A, 4B, 4D, 71, 5F, 58, 5B, 60-62, 66** (mostly `Data_*` of loaded tiles): the screen identity is settled for 50/51 only.
* **Keyboard type predicates** `55:6EAA/6EC0/6EEC`, the `ld hl,...` blobs of bank 54 (`Data_54_4C35/4C3D/4C44/4FC3/4FCB/475A/4764`, mail-library argument blocks) and `Data_4C_430A`: structure not decoded.
* **`Label_BB_AAAA` globals** of the scope (jump-table targets and fall-through pieces, none is called): left alone.
