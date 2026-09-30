# Naming pass 2, group 3 (apps A): banks 04 22 23 24 26 27 29 2A 2B 2C 2D 2E 2F

Second naming pass over the labels that still carried neutral names after `naming_g1.md` .. `naming_g4.md`.  Deliverable: the rename manifest
[`analysis/naming2/g3_apps_a_renames.tsv`](../../analysis/naming2/g3_apps_a_renames.tsv) (142 rows: 18 CONFIRMED, 83 PROBABLE, 41 HYPOTHESIS; `old new kind status evidence`, HYPOTHESIS rows keep
`new == old` and are not applied).  No `.asm` file was edited here.  Check done on a private copy of the tree: all 101 non-HYPOTHESIS renames applied by whole-word replacement over `**/*.asm`, `make` prints
`SHA-256 OK ... RESULT: IDENTICAL`.  Every `old` exists exactly once as `Old::`, every `new` is absent from the tree (labels, `DEF`s, RAM) and from the other manifests in `analysis/naming2/`.

Status words as in `STYLE.md`: a name is semantic only with at least two independent pieces of evidence (what it calls plus what it touches, a byte/instruction-identical twin of a named routine,
a caller context, a trace).  Code that never ran is never CONFIRMED by itself; the only CONFIRMED rows here are executed or byte-identical to executed code.

## Method

1. Targets: 91 non-alias `Function_BB_AAAA` (plus the neutral `Data_/Table_/String_/Tiles_/Palette_/Label_` of the same banks that are not aliases of a semantic label).
2. **Twin fingerprint** (script kept in the scratchpad, not committed): every global block of the tree is reduced to its instruction list with 16-bit operands and symbol names wildcarded and
   compared with every named block (exact match and `difflib` ratio).  This found the routines the earlier passes could only call "twin of ..." and gave the bulk of the new names: the ROM contains many
   copies of the same library routines (HDMA at VBlank, draw-text-line with N cells, decimal formatter, time-warning popup), often in dead form.
3. Callers/callees from the source (`grep` of the whole tree), coverage of the entry in `analysis/coverage_union.tsv`, calls in `traces/detail/*/callgraph.tsv`, `config/symbols/*.tsv` notes.
4. Naming rules: prefix of the neighbouring names of the same file (`SoundDrv_`, `MailSrvDel_`, `MailSrvDelHidden_`, `MailSession_`, `AddrBook_SaveConfirm_`, `Abook_Run_`, `CommTime_`, `MailServerMgr_` ...); a copy
   of an already named routine that lives in another subsystem gets the original name plus `_BB_AAAA` (precedent `Gfx_StartHDMAAtVBlank_2C_669D`) when the subsystem is the same, or a bank-local prefix
   when the copy belongs to another screen; dead code that belongs to a region with no caller gets an `...Unused_` prefix in the subsystem part so that the name cannot be mistaken for a live screen.

## Results per bank

| bank | subsystem | named | notes |
|---|---|---|---|
| 04 | sound engine | 1 function, 12 command labels as HYPOTHESIS | `SoundDrv_SelectAllTracks` (04:415A): third sibling of `SelectSfxTracks`/`SelectMusicTracks` (`ld de,$D040 ; ld a,8` into `SoundDrv_SetTrackIterator`), no caller.  The four volume/envelope helpers 4DD3/4DDF/4E04/4E34 of `SoundDrv_UpdateChannel` stay neutral: they multiply nibbles (`SoundDrv_MulNibbles`) with track+$2F and write channel+$10 but the field meanings are not decoded.  The 12 jump-table handlers `Label_04_483A..4B66` are listed with their opcode (`$B1 + index` of `Table_SoundDrv_Commands`, mapping checked against `$BC` tempo = index 11, `$BE` instrument = 13, `$BF` volume = 14) as documentation, not named |
| 22, 23 | mail-server delete menus | 4 + 4 functions (dead three-number print), 3 time-warning popups, 1 message, 18 sprite-counter routines, 2 strings | see below |
| 24 | browser page list | none | `Function_24_42B0` (copies the goo.ne.jp URL string to WRAM6 buffers, never executed, buffers unproven) and the two empty `ret` hooks stay neutral |
| 26 | mail session | 4 functions | `MailSession_SetReceivedCountSprite`/`SetNextReceivedCountSprite` (26:4C94/4DAB, executed in 7 mail_receive-type scenarios), `MailSession_ShowMsgSent`/`ShowMsgReceiveDone` (26:571F/5763, instruction-identical to `ShowMsgSending`, strings already named) |
| 27 | send/receive | 2 functions, 1 table | `CommTime_DrawNumber_27_4FFB`, `CommTime_PutDigit_27_5021`, `Table_CommTime_DigitTiles_27_5048`: the unreferenced variant of the communication-time summary screen carries byte-identical copies of the bank-51 number drawer and its 20-byte digit-tile pair table |
| 29 | unreferenced palette library (29:5090-5376) | 8 functions | `PalLibUnused_*`: wait for LY=$90, VBlank IRQ off/on, read/write the 64+64 palette bytes through `rBCPS/rBCPD/rOCPS/rOCPD` into `$DBD0`, fade one step toward white/black, fill buffer from a block.  Hardware behaviour is unambiguous in the code, but the library has no caller and never ran, so all are PROBABLE and the prefix says "unused" |
| 2A | address-book save-confirm screen | 6 functions | dead 17- and 25-cell text line drawers and their glyph/blank helpers, instruction-identical to `AddrBook_SaveConfirm_DrawTextLine16` and its helpers |
| 2B | mail draft / viewer | none | three dead near-twins (64F1, 687C, 6CF5) stay HYPOTHESIS, they differ from their named siblings |
| 2C | address picker + unused screen | 13 functions, 6 data | dead copies of `SaveSenderAddr_RefreshSlotIcons` (5A12), `AddrPick_IsSlotUsed` (5CA3), `AddrPick_MoveNameHighlight` (5FB1) and the unreferenced screen `AddrScreenUnused_*` (741C Run, 746F InitScreen, two text-line drawers with 4 helpers) with its graphics |
| 2D, 2F | HDMA helper copies | 2 functions | `Gfx_StartHDMAAtVBlank_2D_6C8C`, `Gfx_StartHDMAAtVBlank_2F_7365`: byte-identical to the other copies of the routine (25:538A and its bank-local copies), both executed (16 and 6 scenarios): CONFIRMED |
| 2E | mail-server tidy | 2 functions | `MailServerMgr_TimeWarningPopup` (48F8) and `MailServerMgr_TimeWarningPopupChoice` (4A7D, executed once in `time_warnings`) |
| 2F | address book | 7 + 2 labels, 6 data | `Abook_Run_*` state labels (executed), `AbookList_Run_Loop`/`AbookAddr_Edit_Loop`, graphics of the name editor and view screens |

### Mail-server delete menus (banks 22, 23)

* **Time-warning popups.**  `23:50CC`, `23:5137`, `23:54B1` (delete-all first pass, second pass, delete-completely) and `2E:48F8`, `2E:4A7D` have the body of the popup at the end of the executed
  `MailSession_CheckTimeWarning` (26:4EC3): `Sprites_SaveSlotsToBank3`, fade out, `Function_7F_6218` (dialog 50:4000, result `$FF` = stop -> `A=$80`), else redraw the screen, restore the sprites.  Each is entered by
  `call nz` right after the connection-time check (`wTimerEnable` bit 4, `wRam_C26E/C26F`, timer A) that sets `A=$FF`.  `2E:4A7D` was executed once, in the `time_warnings` scenario (`callgraph.tsv` call
  `2E:44C7 -> 2E:4A7D`), the stop answer path.  This corrects the note in `config/symbols/bank2E.tsv` ("never executed"); the other four were not reached in the 64 scenarios and stay PROBABLE.
* **Dead three-number print** `22:48CD` / `23:47BC` (byte-identical to each other): reads `wRam_C2D7`, `wTimerAMinutes`, `wTimerASeconds`, formats each with a decimal-string builder and renders it into the
  WRAM2 tile buffer.  The helpers are byte-identical to executed routines (`MailServerStatus_FormatNumber_M0`, `MailSrvDel_NumberTileOffset`), hence the names `*_FormatDecimalStr`, `*_NumberTileOffset`,
  `*_UploadDecimalTiles`.  The name `*_DrawTimerNumbers` states what the code reads; that the three numbers are hours/minutes/seconds on a screen is still only a HYPOTHESIS (nothing calls it).
* **Sprite counters.**  `23:58C4/5FA2/6699` are the `ret`-patched stubs `SpriteCounter_StubA/B/C`; behind each lies a complete 5-digit counter: `Divide16` by 10000/1000/100/10, one digit-place routine per place
  (108 instructions each, identical except slot and position).  Counter A (slots DA10-DA50) first subtracts the word at `$D631`, B (slots DA60-DAA0) first resets its five slots, C has no pre-step.  Named
  `SpriteCounter_<A|B|C>_DrawNumber` and `_DrawDigit<10000|1000|100|10|1>` (object rows are `Table_SpriteCounter_Digits`, 23:7990).

### Unreferenced screens and libraries

* `2C:741C-7740` is a whole screen with no caller (tiles, tilemap, palettes, object table, three text lines from `wEditAddressBuf` (D4C0), D4D4, D4EC with 21/25/21 cells, a 60-frame wait and a `Dialog_Show`
  answered yes/no).  Named `AddrScreenUnused_*`; the claim is limited to what the code draws.  Its graphics (`Data_2C_7740/7860/7B30/7B70`, `Palette_2C_7C00`, `Table_2C_7C40`) are renamed after it.
* `29:5090-5376`: see the table.  `call $7BB7` inside lands in bank-29 padding and the PRNG uses `$0C0E/$0C0F` (ROM addresses), so it cannot run in place; names describe the code only.
* `27:4EC0..`: the tail of an unreferenced variant of `CommTime_DrawSummaryScreen`.  Only the byte-identical helpers were named; `Function_27_4EC0` itself is a fall-through fragment and stays neutral.

## Graphics and data named

CONFIRMED (loader executed): `Gfx_AbookName_Tiles9300/9700/8800` (`Tiles_2F_61F0/65F0/66F0`), `Gfx_AbookName_Tiles8000` (`Data_29_5B10`), `Palette_AbookName_Bg` (`Palette_2F_6CC0`, to `$D800`),
`Palette_AbookName_Obj` (`Palette_29_5E10`, to `$D840`), `Data_MailServerStatus_NumberTemplate_M0/M2` (`Data_29_49DA`, `Data_29_4F6C`: five full-width zeros, the digit templates of the executed formatters).
PROBABLE: the bank-29 blocks of `AbookView_SetupScreen` and `CommTime_DrawHMSScreen` (call sites not executed), `Table_MailBody_CursorObjects` (`Table_29_6350`, eight rows loaded by
`MailBody_PlaceCursorSprites`), `MailServerStatus_Txt_Unknown_M1/M2`, the three decimal templates and the `AddrScreenUnused_*` graphics.  Destination naming follows `STYLE.md` (`Gfx_<Screen>_Tiles<VRAM>`,
`Palette_<Screen>_Bg|Obj` by the WRAM buffer `$D800`/`$D840`).

Labels: the executed state machine of `Abook_Run` (2F:7EBF): `Abook_Run_List` (list, result dispatch), `_EditAddress`/`_EditAddressA1`, `_EditName`/`_EditNameA1`, `_View`, `_BackToList`; the meaning of the `A=1`
argument of `AbookAddr_Edit`/`AbookName_Edit` is not decoded (hence the `A1` suffix).

## Kept neutral on purpose (HYPOTHESIS rows, 41)

* tiny stubs: `24:53FC/53FD`, `26:5343`, `2E:4EB1` (single `ret`), `2E:4EB2`, `2E:4F9A`, `23:6D61`, `29:5090`;
* helpers whose fields are not decoded: `04:4DD3/4DDF/4E04/4E34`, `26:5106` (counter comparison), `2D:4E42/4E54/4F03`, `2F:4496`, `29:511E`;
* near-twins that differ from the named routine (not identical): `2B:687C`, `2B:6CF5`, `2B:64F1`, `2C:5CD2`, `2C:60B3`;
* `24:42B0` (copies two strings to buffers of unknown role), `27:4EC0` (fragment);
* 12 sound command handlers (opcode table documented in the manifest), four data rows whose loader is missing or ambiguous (`Table_29_6290`, `Data_23_7C03`, `Data_2E_75C0`, `Palette_26_7AC0`).

## Gaps (not attempted)

* About 240 sprite data blocks (animation entry tables, frame tables, frame records, scripts) in `gfx/*` of these banks (`gfx/browser/page_list.asm`, `gfx/mail/comm_result.asm`, `compose_objects.asm`,
  `gfx/mail_server/delete_progress.asm`, `gfx/address_book/save_sender_address.asm` ...): the structure is understood (entry -> frame table -> frame record, script), but the consumers load them by raw immediate
  (`ld de,$6350` with `a=$29`), so a name per block would need a per-entry mapping to its screen state; only the one table with a clear consumer was named.
* Split string fragments (`String_24_4B21..4BC3`, the 45-byte messages of `PageList_MessageTable` cut at label boundaries; blank padding strings of banks 22/23/2E) and the many `Data_` bytes that are
  single `ret`/padding.
* The 118 remaining non-alias `Label_BB_AAAA` (interior jump targets kept global by cross jumps: sound command handlers, dispatch targets in `MailSendRecv_Main`, `Profile_*`, `MailTitle_*`).
* Sound command semantics (`$BD`, `$C0`-`$C6`, `$C9`, `$CA`, `$CE`, `$CF`) need a proper decode of the track record fields (+$12, +$19, +$1A, +$1F ...), see `naming_g1.md` section 7.

## Corrections to earlier notes

* `config/symbols/bank2C.tsv` says `2C:5FB1` is a twin "drawing names at x=$28"; the instruction list (with 16-bit operands wildcarded) is identical to `AddrPick_MoveNameHighlight`, so the difference is in the data it is given, not in the code.
* `config/symbols/bank2E.tsv` lists `2E:4A7D` as never executed; `analysis/coverage_union.tsv` has it (count 1, scenario `time_warnings`).
