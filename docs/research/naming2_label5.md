# Naming pass 5 (label5): the neutral `Label_<bank>_<addr>` jump targets

> Status: **reference (current)** for the names it adopts.  Manifests: [`analysis/naming2/label5_renames_pkgA.tsv`](../../analysis/naming2/label5_renames_pkgA.tsv), `..._pkgB.tsv`, `..._pkgC.tsv`, `..._pkgD.tsv`,
> `..._pkgE.tsv`, `..._pkgE_twins.tsv` and [`label5_renames_sprites.tsv`](../../analysis/naming2/label5_renames_sprites.tsv) (applied with `tools/apply_renames.py`, kind `label`; the corrections of the independent readers are
> already in them); verification: [`naming2_verify_label5.md`](naming2_verify_label5.md).  Scope: the `Label_<bank>_<addr>` labels that were still neutral after pass 4 and `localize_labels` (438 global ones).

## 1. Result

| item | count |
|---|---|
| neutral `Label_` definitions before the pass | 438 |
| rows in the manifests | 416 (package A 33, B 100, C 108, D 114, E 55 + 6 dead-twin rows) |
| names applied | **410** (313 CONFIRMED, 97 PROBABLE) |
| HYPOTHESIS records (new name == old name, never applied) | 6 (`Label_04_49B6`, `Label_04_49CD`, `Label_4C_4016`, `Label_4E_58AB`, `Label_2B_57CB`, `Label_27_4EEB`) |
| neutral `Label_` definitions left | 7: the six records above and `Label_55_5F29` (reached only by dead code) |
| labels that stopped existing | 12 spurious labels removed (nine `Label_68_5B6C..5B8C`, three `Label_2A_4081/5A83/5B81`: mistyped tables) and 9 more turned local; 9 manifest rows of package E became moot |
| code references renamed | 744 (A 80, B 147, C 157, D 268, E 83 + 9 twins), plus 36 code and 5 comment references in the sprite renames; the old neutral name stays as an alias label below every new one |
| other renames | 20 (the comm scene sprite labels that said `Text`, section 4) |
| ROM | byte-identical (`make`: `RESULT: IDENTICAL`; `sym-check`, `tidy_comments --check`, `localize_labels --check`, `tree_check`, `sprite_chain_check`, `conventions-check` and the tool tests pass) |

## 2. Method

Five packages by area, each written by an executor in a private copy and then attacked by independent readers with a fresh brief (the same standard as [`naming2_verify_fn4.md`](naming2_verify_fn4.md)): **A** core, account, settings, audio, gfx,
text (42 labels); **B** Mobile SDK, comm, error screens (100); **C** debug error test, dialogs, registration, keyboard, startup (108); **D** browser and HTML (114); **E** mail, address book, profile editors, mail server (73).  For every label
the executor read the code, every reference (jumps, calls, `dw` table words, farcalls, raw `jp $XXXX`, a byte scan of the whole ROM) and the function around it; hit counts come from `analysis/coverage_union.tsv` (64 natural scenarios), never from
the old source comments (they are from smaller trace sets); a role seen only in code that never ran is PROBABLE; a label reached only by unreferenced code with no executed twin stays neutral.  Many rows carry a replay in a CPU-only SM83
interpreter; replays support a reading and never raise a status.  The readers of C and E were started by the coordinator (two each); the executors of A, B and D started their own (one, four and three), whose results are in their reports.

## 3. Conventions

* Handlers reached through `JoypadDispatch` are `<Screen>_OnA/_OnB/_OnSelect/_OnStart/_Idle`; a handler that is only a `jp` back to the loop is `<Screen>_Ignore<Button>` (or `_Ignore` when two words share one label).  The mapping of the five words
  (A, B, Select, Start, none) is CONFIRMED (`home/jump_table.asm`): a D-pad-only press also gives word 4, so `_Idle` means "none of A, B, Select, Start".
* Roles inside a function: `F_Loop`, `F_Done`, `F_Retry`, `F_Exit...`, `F_<Handler>`; a handler reached only through a table of unproven purpose carries the dispatch index (`Kind0_State...`, `Substep4`), not a guessed meaning.
* A dead twin of live code carries the live name plus the position (`CommTime_Summary_FrameLoop_27_4FC0`), the in-file precedent for dead copies (STYLE.md section 4).
* The editors of the address book, the mail title and the profile are copies of one multi-line editor template and use the same role words (`_AfterKeyboard`, `_CheckButtonB`, `_GetCharPtr_{Found,NoChar,Newline}`,
  `_InsertChar_{CheckRow,NextRow,Reject,Insert}`).

## 4. Decisions taken while integrating

* **Debug error test** (`DebugErrorTest_*`, package C rows 1-3): the screen is unreferenced code that only the forced runs execute; the reader of part B asked for HYPOTHESIS, the reader of part A for PROBABLE.  Kept PROBABLE, like the nine older names
  of the same screen and the aliases of the debug screens; the two bare `jp loop` handlers are `_IgnoreB` and `_IgnoreStart`, not `_OnB/_OnStart`.
* **Sound driver** (`Label_04_49B6`, `Label_04_49CD`): the executor named them `SoundDrv_CmdStoreTrack1E` and `SoundDrv_ParamTrackWord27` (they state only the store, like the accepted `SoundDrv_ExtSetTrack27/28`).  The verified audio ruling
  (`audio2_renames.tsv`, `audio2_verify_static.md` V2.2: the byte or word is read nowhere, so the effect is not demonstrated) keeps them neutral: HYPOTHESIS records with the proposed names in the evidence.
* **Mistyped tables.**  The ten words at `68:793D` are pointers into ROM bank `$4B` (`Table_4B_5B68 + 4 * digit`, the digit records read by `Account_ResultPage_DrawTimeDigits`), not bank-68 code pointers: the table is written with the label
  and the nine labels it created inside `Account_MailDomain_PrintField` are removed.  The "pointer table" at `2A:4A66` is the caption "　セーブ" plus four strings: retyped as text, its three labels removed (nothing ever referenced them); `localize_labels`
  then turned nine labels of the profile and save-sender code local (their nine package E rows became moot; the roles survive as comments).
* **Stray dead fragments.**  Seven blocks typed as `UNCLASSIFIED` data between code (`0C 0D 20 02` = `inc c ; dec c ; jr nz, NoChar` in the three GetCharPtr copies; the 13-byte `ld a, 1 ; ldh [hWRAMBank], a ; ldh [rSVBK], a ; ld a, [hl] ; cp $0D ; cp $00 ;
  jr z, ...` in two InsertChar copies; a `ret nz`; a `pop af ; cp 1 ; jr z`) are dead code that follows an unconditional jump, nothing references it, none ran: retyped as code with a HYPOTHESIS comment.  Their `Data_` labels had split the functions, which is why about 30 of
  the package E labels were global at all.
* **Dead twin of the summary screen** (`27:4FC0-4FFA` is `51:4199-41D3` byte for byte except 5 table words, 4 `jp` operands and the last byte): named after its live twin (package B) plus the position.
* **Comm scene sprites.**  The objects of `CommScene_TextObjTable` are sprites (a two-frame walking figure, an "@" icon, a burst), not text: the table, its five frame and script tables, the seven frame records and the routines `SetSpritePair` /
  `PlaceSpritePair` are renamed `Sprite` (20 rows, `label5_renames_sprites.tsv`; the preview PNG and the three preview tables follow, and `docs/TRANSLATION.md` no longer cites the table as text).  The `CommScene_TextBox*` labels are real text boxes and stay.
* **Tables.**  The three state tables of `CommScene_RunState` had been cut into five fragments, one of them without a label (`dw $40D9`): now `CommScene_Kind0/1/2_StateTable` (all 24 handlers ran; 23,644 + 9,672 + 6,129 hits = the 39,445 dispatches).  The two
  `ConnIcon` tables are CONFIRMED (3,716 dispatches = the sum of six handlers; 184,406 = 184,262 + 142 + 2).
* **Two lone-`ret` slots** (`Label_4C_4016`, `Label_4E_58AB`) stay neutral: no shipped data can select them, and a selected slot at `4C:4016` would end `Browser_LoadPage` itself, so a plain no-op name would mislead.

## 5. What the pass corrects in earlier notes

* **`JoypadDispatch`** (`home/jump_table.asm`): the button order A, B, Select, Start, none was PROBABLE; now CONFIRMED by 501 (site, word, scenario) triples whose input scripts press the claimed button (0 violations) plus the `hJoyHeld` tests of `dynamic_tracing` 9.3.
* `wPalFadeMode` is not "always 0 in executed code" (`ram/wram.asm`, `naming_g5.md`): `Palette_FadeOutMasked` stores 1 and the mode-1 handler of `PalFade_Step` ran 944 times; mode 2 is never stored; mode 3 only by two caller-less fades.  `PalFade_Start` fills OBJ palette 6 entries 56-59
  while `PalFade_Step` blends colours 48-51 only (replay).
* `CommPanel_StateTable` has 5 entries, not 4: the one-word `Table_68_744A` is state 4 (the only store of 4 into `wCommPanelState` is at `68:757D`).
* `naming2_ram2.md:113` and the `wRam_C273` row of `ram2_renames.tsv` list `Label_4C_4138` as a writer of the detail word `C274:C273`: the block (`Browser_LoadPage_CancelConnect`) has no such store; the stores are at `4C:4026/402C` and `4C:4056/405C`.
* `naming_sdk.md:237`: HTTP service index 3 (`75:656C`) is produced by the reconnect at `75:6F11` and by an unreferenced block (both never executed).  `naming_g7.md:139`: the comm scene kinds are connect (0), download (1) and disconnect (2); boxes 6 and 7 ("cancelling /
  cancelled") are shared by kinds 0 and 1.  The `config/symbols/bank75.tsv` ideas are refined: `51CF` is the BC = 0 close that `Http_Poll` triggers while bit 2 of `wTimerEnable` ("more reply data pending") is set (in the traces a page larger than the `$0FFC` buffer),
  `723E`/`727D` are overflows of the caller's buffer, `73BE` sends the request-path chunks (the POST body goes out in substep 1), `656C` sets states `$21/$22`.
* `naming_g8.md:445`: `Html_MetaResultToError_HexLoop` decodes `A-F` and `a-f` as 0-5 (`sub $41` without adding 10); never executed.  Menu items are numbered from 1 in `config/symbols/bank4E.tsv` and `naming_g5.md`; the new rows use the 0-based `hDialogResult`.
* `Html_Layout_ClearAllFloats` (section 5.4 of `naming2_ram3.md`): the same flaw (`FFC4` built as `hViewX + hHtmlLineIndent`, compared with `hViewX`) is in the `Html_Tag_Br_ClearLeft` and `Html_Tag_Br_ClearAll` tests; inside a list (indent `$0C`) clear=left and clear=all would
  never end (replay: 16,216 retries in 600,000 steps; with indent 0 one retry; clear=right is unaffected).  Still a HYPOTHESIS: the replays show the mechanism, not what the page of the 292,374-retry scenario contained.
* The generated `config/` notes that call `Table_68_793F` a code-pointer table, `CommScene_TextObjTable` a "text-box arrow and text sprites" table, or say a "not executed" `Registration_ManualPhoneEntry` (it ran 31 times in 2 scenarios) are stale (the config tables are frozen).

## 6. New quirks of the original ROM (all in never-executed code, by reading and CPU-only replay)

`Browser_FindAnchor`: a name of 255 bytes or more skips the `pop bc` and returns to `$0000` (254 characters work).  `Html_CountListItems_Pre`: `A` holds the dispatcher's `$E4`, not `hRam_FFB4`, so `</pre>` never ends pre mode in the counting pass.
`HtmlUrl_Resolve_EnsureHostSlash`: a `jr nz` with displacement 0 skips the character after the first `/`.  `HtmlUrl_Resolve_JoinToBase`: the `;`, `?` and `#` branches write the delimiter twice.  `Browser_MapErrorToResult`: code `$26` gives result 4 when
`wCommSessionKind` = 1, else 5; the `$33` error with detail `$0101/$0102` gives result 0.  `MailConnect_Screen` ends `ld a, $FF ; ld a, $20 ; ret`, so the `cp $FF` in `MailSendRecv_Main` can never be taken.  The row-capacity branch of the name and title editors
never runs because keyboard types 7, 8 and 9 have no newline cell (not by logic: stored data could reach it).  `frame_style_chooser.asm` writes `wConnIconState := $0C`, past the six-entry table of `ConnIcon_Refresh` (forced runs only).

## 7. Left

* The seven neutral labels above; `Function_*` (27), `Data_` (about 665), `String_`, `Table_` and graphics labels are other fronts.
* Semantic names for the scene kinds (`Kind0/1/2` to Connect / Download / Disconnect) and for the table-reached handlers of unexecuted branches (they state the dispatch index only).
* The old generator tags (`[CONFIRMED] ... executed in up to N/18 scenarios`) of the code blocks under the new labels were not refreshed against the 64-scenario coverage.
* `wRam_C0E2` / `wRam_C0E3` (top menu queued press) rest on code facts and could be raised from HYPOTHESIS.

## 8. Reproduce

`python3 tools/apply_renames.py --manifest analysis/naming2/label5_renames_pkgX.tsv --strict` for each package (a second run reports every row as `already applied`); `make` must print `RESULT: IDENTICAL` and `make sym-check`, `tools/tidy_comments.py --check`,
`tools/localize_labels.py --check`, `tools/tree_check.py`, `tools/sprite_chain_check.py` pass.
