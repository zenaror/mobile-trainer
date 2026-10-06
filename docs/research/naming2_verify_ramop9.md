# Tile staging windows, account work area, dialog tile stage and palette fade buffers (ramop9): independent verification

> Status: **reference (current)** for the corrections it lists.  The corrected pass: [`naming2_ramop9.md`](naming2_ramop9.md); records: [`analysis/naming2/wramx_consumers.tsv`](../../analysis/naming2/wramx_consumers.tsv),
> [`analysis/naming2/wramx_calls.tsv`](../../analysis/naming2/wramx_calls.tsv), [`analysis/naming2/ramop9_manual.tsv`](../../analysis/naming2/ramop9_manual.tsv).

Verification of the first versions of the two parts of the pass on 2026-10-05 by two readers with a fresh context, working in parallel, that had not seen the reasoning behind the rules.  Part A: the 17 names of the bank 2/3 tile staging windows, the account work area and the dialog tile stage, the rules, the effects and the
675 operands (597 by the tool, 78 by hand).  Part B: the three palette fade buffers, the `(direct)` mechanism, the text line drawer rows, the 60 neutral names and 19 by-hand rows.  The readers were told to attack every claim from the code and from `analysis/rambank/observed_banks.tsv`, to re-derive every rewritten operand (a stratified
sample in part A, every changed line in part B), to try to break the new logic and to judge the documents; the repository stayed read-only (builds only in private copies).  The readers could not write their reports as files (the harness asks subagents to return findings as text), so the text of their final replies is reproduced below,
with the harness frame removed and their private scratch paths named in general terms.  Their helper scripts (an SM83 interpreter that ran the ROM's own fade routines, a property test over 21,000 random programs with an abstract machine of A, the real bank, the shadow, `hTextTiles_DestBank` and the stack, mutation and fuzz drivers, an independent
re-derivation of all consumers at ROM level) were in their scratch directories and are not kept.

## 1. Result and integration

**Part A: names 16 upheld, 1 corrected; consumer rules 65 of 67 upheld, 2 corrected; effect rows 42 of 43 upheld, 1 corrected; operands 674 of 675 upheld, 1 corrected; the 14 sites left numeric were right.  Part B: names 3 upheld (wording of two `DEF` lines and one stale neighbouring one); 329 of 335 changed lines upheld, 6 went back to numeric
(3 dropped, 3 corrected); the `(direct)` mechanism had no false accept in the tree, but the synthetic attacks found three spellings of a bank write that a scan missed.**  No false accept in the real tree, in either part.  What was done with it (the corrected pass is in `naming2_ramop9.md`):

* **The six reversals of part B**: `tidy_screen.asm:421,429,437` (the data is the POP3 TOP summary that bank 54 stages, not the mail body or address edit buffers) and the three debug-screen `wTileStage2` pointers went back to numeric with `; raw`; the row `MailServerMgr_DrawFieldText` and the `Body` alternative of the drawer family were dropped.  Of part A: `phone_number_entry.asm:292`
  (a wipe of three phone fields) went back to `$DEDD ; raw` and the family of `FillBytes hl` lost `wAcctNumberInternet`.  The coordinator also marked the two uses of `wAcctNumberSelfPage` as the number-to-dial scratch in `password_change.asm` as `; raw` (part A's policy question), and all 14 lines that stay numeric, so that no later rule renames them.
* **Names and texts**: the `DEF` lines of `wDialogTileStage` (40 blocks, not 41), `wKbdGlyphPreviewTiles`, `wTileStage2`, `wTileStage3` (extent and debug sentence) and the three fade names were corrected; `CAVEAT:` was added to `wEditBodyBuf` and `wMail_ItemListPointer`, a note to `wMailSessionBlock` (its second meaning in the address book); `wPalFadeMode` ("always 0") and the header of `Dial_EntryNumberBuffers` ("WRAM1") were
  corrected; the proof texts of `TextTiles_HdmaBlock` (rule and effect), `Wram3_CopyString`, `Dial_CopySelectedNumber` and the headers of the two rule files were rewritten; `LCDOn` is at 00:05B6.
* **Tool**: `BANK_REGS` knows every spelling (`[c]`, `[$70]`, lower case, the bare register names); `read_rules` rejects a `(direct)` row that needs a bank (it crashed `plan()`); the caveat counts appear in `--check` and in the elements summary; the report has the consumer and the bank; the docstring and a comment were corrected; 9 tests were added (58 in all), and the two mutants that survived the first
  version are killed.  `tools/apply_manual_sites.py` evaluates the proposed name against the `DEF` lines (name, value, bank), handles data words and the uses of neutral names, and is idempotent (`already written`).
* **By hand**: the 44 neutral uses that part B's reader proved (`menus.asm`, `tidy_screen.asm`), the 19 fade buffer bases, the 3 item list pointers of the mail library (the `CAVEAT` keeps the tool from writing them) and the 12 words of the two address tables that part A's reader named: 78 rows, appended to `analysis/naming2/ramop9_manual.tsv` with their proofs (170 rows in all).
* **Documents**: `naming2_ramop9.md`, this note, `STYLE.md`, `REVERSE_ENGINEERING.md` and `docs/README.md`.

## 2. Reader of part A: report

### 0. Verdicts

| item | UPHELD | CORRECTED | DROPPED |
|---|---|---|---|
| names (17) | 16 | 1 (`wDialogTileStage` text) | 0 |
| consumer rules (83 rows; 67 new or widened) | 65 | 2 (`FillBytes hl` family; `TextTiles_HdmaBlock` proof) | 0 |
| effect rows (43 new) | 42 | 1 (`TextTiles_HdmaBlock` proof) | 0 |
| operands (675 = 597 tool + 78 manual) | 674 | 1 (`engine/settings/phone_number_entry.asm:292`) | 0 |
| 14 rows left numeric | 14 right to leave | | |

No false accept was found.  The ROM is byte-identical.  Every defect is a name or wording, a proof text, one policy inconsistency, one dead-code crash, or two missing tests.

### 1. The 17 names

The reader re-derived address, size, bank and kind from the code.  Every `BB:AAAA` cited is an instruction start, every routine name next to an address matches `.sym`, and every scenario count matches `observed_banks.tsv` or `coverage_union.tsv`.  One range end, `6C:5AAA`, is not an instruction start (the call is 5AA9-5AAB).

* **`wTileStage2` (W2 `$D000`, 4096): UPHELD.**  It is the whole bank 2 window.  Canvas rows 0-11 end at `$DEFF`: `Canvas_BlitGlyphNoRemap` 7F:42CA-42F7 selects bank 2 and goes to bank 3 when `H >= $DF`, observed `{2}` in 33 scenarios.  The uploaders send `$D000-$DFFF` (`MailView_BodyPage_UploadTextTiles` 2B:7D92, `c = $3F` four times).
  `TextTiles_ClearBuffers` 2D:4E06 wipes `$1000`.  `Font_BlitGlyph8x16`'s store loops (48:47D6-47F1) run only in banks `{2,3,7}`, which are exactly the three `hTextTiles_DestBank` values (37 scenarios).  The 123 dest operands, 105 executed and 103 replayed, match the DEF text.  Wording only: "written by TileCanvas_UploadRect" is wrong, because UploadRect only passes the source to `Gfx_StartHDMAWithService` (4F:45B1).
* **`wTileStage3` (W3 `$D000`, 2304): UPHELD.**  The extent matches everything that executes: 6 canvas rows end at `$D77F` (`$0780` cleared at 2D:4E1F and 24:430A).  `HelpScript_ShowPicture` zero-fills `$0900` (6C:5EA7-5EB4) so that the live `wSpriteSlotBackup` at `$D900` survives.  Only `debug_flags.asm` reaches `$DBFF` (`FillBytes bc=$0C00` at 19:43F6-43FD, HDMA sources `$D000/$D400/$D800`
  at 19:4418/442A/443C), and it never runs; `error_screen_test.asm` and `sound_test.asm` stay below `$D800`.  The DEF said "the debug screens ... up to $DBFF" without saying that only one file does.
* **`wKbdGlyphPreviewTiles`: UPHELD.**  `Kbd_DrawGlyphPreview` pushes dest1 `$DE00`, dest2 `$DE10` and bank word 3 (55:6C4C-6C59), and the HDMA has `c = 2`.  Wording: it is one 8x16 glyph = two 8x8 tiles, not "two 8x16 tiles".
* **`wTextEntryBuf` (20) and `wTextEntryBuf2` (8): UPHELD.**  The layout is a 3-byte header plus text: `TextBuf_Init` 67:6731 writes B, B-1, 0, 0; `AppendChar` decrements [1] (free) and increments [2] (cursor); `GetLength` = [0]-[1]-1.  The 20 and 8 bytes come from the five `TextBuf_Init` callers (b = $11, $09, $09/$05, $0A, $11).  Text starts at +3.
* **Account fields: UPHELD.**  Sizes 9/5/9/9/9/9/17/17/17 are contiguous from `$DEAB` to `$DF0F` and equal the TextBuf and SRAM field sizes; earlier group proposals agree (`analysis/naming/ram_g7.tsv`).  `wAcctPasswordNew` is in fact demonstrated: `&NEWPASSWD=` plus `$DEC2` at 67:5EA7-5EB3, executed in 2 scenarios, so PROBABLE is conservative.
  `wAcctPasswordConfirm` is also the temporary for the 2nd and 3rd typed entries of the change flow (67:591C, 595E).
* **`wAcctNumberSelfPage` / `wAcctNumberInternet` (PROBABLE): UPHELD.**  `$DEEE` is also filled with the default dial-number string (68:46F2-4705) and is the number to dial in `PasswordChange_State_Connect` (67:5B27-5B3C, observed bank 3 in 2 scenarios); the DEF discloses the reuse.
* **`wDialEntries` (153 = 3 x $33): UPHELD.**  `Config_LoadMirrorToWram` 68:4608-46C7 writes +0 (`PhoneNumber_UnpackBcd`), +$11 (`DecodeXorA5`) and +$22 (`CopyStringMax_ZeroSrcOnEmpty`, bc=$10) at `$DF10 + $33n`; `SettingsPhone_SlotMenu_FieldTable` 67:50A5 is `$DF10,$DF43,$DF76,$DF21,$DF54,$DF87,$DF32,$DF65,$DF98`.
* **`wAcctHostScratch` (21): UPHELD.**  "mail." 5 + subdomain 4 + ".dion.ne.jp" 11 + NUL = 21 (68:6D29-6D74, 5 scenarios).
* **`wDialogTileStage` (W7 `$DC00`, 1024): CORRECTED text.**  `BrowserMenu_Open*` sends 40 blocks, not 41: `ld c, $28` at `engine/browser/menus.asm:450` and `Gfx_StartHDMAWithService` sends C blocks; those 40 blocks are 20 upper plus 20 lower tiles (bc=`$DC00`, de=`$DD40`).  Nothing else in the tree touches bank 7 `$DC00-$DFFF`.
* **Statuses.**  Every CONFIRMED name has the demonstrating code executed under the right bank (`observed_banks.tsv`); the PROBABLE ones are justified by label provenance.

### 2. Rules

* **`-` rows (all 17 read).**  Each routine selects bank 3 before its first dereference and restores the shadow on every exit: `TextBuf_*` (including the early exits at 67:678D and 67:67CE), `Wram3_*` 68:4021 and 68:403B, `TextEntry_InsertString`/`CopyText`, and `Settings_StoreStringField` 68:4A52-4A99.  `TextEntry_UpdateCursorSprite` selects nothing itself: its first action is
  `farcall TextBuf_GetCount`.  None of these rows uses the replay branch, so the caller's-bank trap does not apply.
* **`a` rows.**  `Account_LoginId_PrintField` (68:5584), `PhoneComment_PrintText` (67:4C16) and `PhoneKeypad_PrintText` (67:45D4) do their own `ld a,$03` before `call TextEngine_Run`; `Account_MailLocal_PrintField`, `Account_MailDomain_PrintField` and `Account_Password_PrintField` pass the caller's A through `pop af`; `TextEngine_Run` (00:0ED3) selects WRAM bank A for `H >= $C0` and never restores it.
* **`switch` rows.**  `CopyString`, `CopyStringMax*`, `StringAppend`, `CompareString`, `Encode/DecodeXorA5`, `FillBytes` and `PhoneNumber_*` write no bank register.  The observed masks at their entries match the proof texts.
* **`Dial_CopySelectedNumber de`: UPHELD, proof incomplete.**  Its hidden-mode path (00:15BD-1619) selects bank 3 itself before `DecodeXorA5`, so DE is bank 3 on that path whatever the caller's bank; it is safe only because the tool needs bank 3 at the load.  The text of the proof says "observed banks 3 and 7 (callers)" and not this.
* **17 local HDMA starters: UPHELD.**  All are pure except `TextTiles_HdmaBlock` (below).  Each of the ~100 call sites loads HL from a `wTileStage2` pointer under a `ld a,$02` idiom; all 15 starters that execute run only under `{2}` at their entries (`Gfx_StartHDMAAtVBlank_2B_5994` and the two unreferenced 7F routines never run).
* **`dest` rows: UPHELD.**  The dereference is `Font_BlitGlyph8x16`: `call BankSwitch_H` at 48:47CD (dest1) and 48:47E9 (dest2), with the bank word pushed by `RenderLine` from `hTextTiles_DestBank` (read at 48:405F, 40AC, 41B8, 41C7; all cited addresses verified); `RenderLine` bc = dest1 and de = dest2, `RenderGrid` and `RenderGridRows` de = grid base.  The 147 operands split 123 / 10 / 14 as `$02` / `$03` / `$07`.
* **CORRECTED: `FillBytes hl` family.**  The row says a wipe that runs on over its neighbours "is left raw on purpose", and `helpers.asm:222` (`$DE80`, bc=`$0163`) is left raw; but the family added `wAcctNumberInternet` for `phone_number_entry.asm:292`: `ld bc, $0033 / ld hl, wAcctNumberInternet / call FillBytes` (67:420B-4212), which wipes Internet, SelfPage and Comment, 3 x 17 bytes.  Remove it from the family and leave `$DEDD ; raw`, or document the exception.
* **CORRECTED: `TextTiles_HdmaBlock` proof, in both TSVs.**  "it writes no bank register" is false: it saves `rSVBK`, writes bank 1 to `hWRAMBank` and `rSVBK` to read `wStatSplitLine`, then writes both back from the saved value before `ldh [rHDMA5],a` (2D:5069-507A, `engine/mail/body_editor.asm:1434-1443`), observed bank 1 only there in 17 scenarios.  The effect `keeps` still holds, but the shadow is left as the value read back from `rSVBK` (for example `$FA`).
* **Smaller points.**  `Wram3_CopyString` proof: the mask at 00:14BF is the union of all callers; the bank-3-only evidence is at 68:402E.  5 new rows have no site in the tree (`TextBuf_GetCount hl`, `CopyStringMax de`, `CopyStringMax_ZeroSrcOnEmpty hl`, `EncodeXorA5 de`, `DecodeXorA5 hl`): kept, mechanically true.  The `wramx_consumers.tsv` header described only `-`, `switch` and `a`: now it has `dest`, `*`, the replays and `(direct)`.

### 3. Effects (43 rows, all `keeps`)

The reader read every routine and everything it calls: `Multiply8x16`, `ReadByteFar` (restores the shadow), `Font_BlitGlyph8x16` (restores the shadow, 48:47F5-4808), `Sprite_SetPosition` and `EncodeXorA5` are bank-neutral.  All 43 hold in the shadow sense only, as the file's wording says.  Empirically, comparing the replay mask before each call with the mask at the next instruction (join points excluded):
263 call sites the same, 59 after a subset of before, 80 unobserved, **5 contradictions**: `TextBuf_DeleteLast` at `engine/account/login_id_entry.asm:246`, `mail_address_entry.asm:340` and `password_entry.asm:274` (mask `$84` -> `$C4`), `TextTiles_RenderLine` at `engine/mail_server/delete_hidden.asm:469` (`$80` -> `$04`) and `engine/mail/result_screens.asm:329` (`$80` -> `$82`): the stale-shadow mechanism of
`naming2_verify_ramop7.md` section 4c (the old rows show the same pattern: `Gfx_StartHDMAWithService` 11, `Sprite_InitSlot` 6, `Sound_FrameService` 4).  No rewritten operand follows such a call with a bank-dependent consumer.  One old row had a wrong address: `LCDOn` is at 00:05B6, not 00:05C4.

### 4. The 675 operands

* **Consumer re-derivation.**  The reader decoded the ROM bytes (`tools/sm83.py`) for all 597 tool rows: the consumer equals the tool's in 597 of 597, the register is untouched and there is no bank-register write or label in between.
* **Bank-proof paths of the 597:** self-selecting consumer 128; `dest` 147; `a` with constant A 27; static only 77; static plus replay, in agreement 192; replay only (patch B) 26.  The rewritten `switch`/`a` operands show **0 static versus replay contradictions** (only the 3 boot wipes conflict, and they stay numeric).
* **Read by hand:** all 77 static-only rows (66 are in the three debug screens); all 26 replay-only rows; all 24 `wDialogTileStage`; the 44 password-buffer sites; the 9 `wDialEntries`; the 8 `wAcctHostScratch`; the census of the account and text-buffer operands by consumer and offset; every dest store (where the store sits, what lies between it and the call).
* **Replay-only rows (patch B).**  9 of the 26 use the old names `wScreenTileMap` (4) and `wScreenAttrMap` (5), all bank 7 only in 4 to 21 scenarios (the `connect_dialog_screen.asm` sites and `help_script.asm:705` that the earlier reader had called "bank 7 by control flow plus replays"); the others have the idiom more than 60 lines up, or an unmodelled call or `pop af` pair in between.
* **Patch A count.**  32 of 147 operands need it, not "29" : the scan from the load proves 115, the scan from the call proves 147.
* **Manual rows (78): all UPHELD.**  Name, bank and value agree with the DEF table in 78 of 78.  19 clear loops (the idiom is right above and the loop writes through `[hli]`); 30 computed destinations (`DestBank = 2` is stored between the load and the render call in every case, with no call in between); the `[bc]` dereferences in `MailSession_DrawNumber` are under bank 1 but belong to the `$D525` scratch string, a different BC;
  3 config-build rows are dominated by the idiom at 68:6D23-6D27.  Remark: `inline_image_blit.asm:519` `wTileStage3 + $01` is an arithmetic artifact (`dec de` at 51:7386, then `ld hl,$D001 / add hl,de`), not a field offset.
* **CORRECTED operand: `phone_number_entry.asm:292`.**  See the `FillBytes` finding.
* **Extent check.**  The reader compared the length loaded before each fill, copy or DMA with the named object and found three operands whose transfer exceeds the object: `debug_flags.asm:501` and `:525` (to `$DBFF`, documented in the DEF) and `phone_number_entry.asm:292`.
* **Policy judgement.**  `password_change.asm:286,290` (`wAcctNumberSelfPage`) is the field reused as the dial-number scratch, and STYLE.md's `; raw` convention names "a scratch use of a named buffer"; the 5 debug string-scratch rows were left numeric for that reason.  Whether to keep the names is the coordinator's call.
* **The 14 stays-numeric rows.**  All 14 reasons check out, but none of the 14 source lines carried `; raw`, although `ramop9_manual.tsv` itself said "STYLE: mark `; raw`" for the dead load at `mail_session_screen.asm:1137`: a later rule (such as the `(direct)` rows the tool already has) would rewrite them.

### 5. Sites left numeric (815 at the time = 749 no rule + 30 no object + 14 value + 8 wrong family + 14 manual)

* **Right to leave.**  The 13 "bank not shown" were 9 resolved by hand and 4 correct to leave.  The 30 "no object" are all old-object addresses in other banks.  The 8 "wrong family" are `helpers.asm:222`, six `pop3_top.asm` bank-1 `wEditBodyBuf` sites, and `far_string.asm:37` (a one-byte bank-5 name used as a string scratch).
* **Nameable with the new names, with proof: none.**  The reader looked at every numeric `$Dxxx` immediate whose bank is shown by the idiom or the replays and which lies in a new extent: 16, none nameable (1 is the `$DE80` wipe, 3 are debug string scratch, `mail_session_screen.asm:1137` is the dead load, `mailbox_screen.asm:540` is dereferenced under bank 1 after `ld a,$01` at 25:4F5B, and 10 are string-pointer loads for the `*_DrawLine*` wrappers
  (`engine/mail/draft_menu.asm:373-388`, `engine/mail/address_editor.asm:533-538,1623`, `engine/address_book/address_editor.asm:533,537`, `engine/browser/page_list.asm:1162`): the replays show bank 2 at the load, but the wrapper selects bank 1 itself, so naming them `wTileStage2` would be a false name, and the missing rule is what protects them).
* **Outside `ld` operands:** 12 `dw` words could become `wDialEntries + $xx` (`Dial_EntryNumberBuffers` at `engine/account/helpers.asm:955`, 3 words, and `SettingsPhone_SlotMenu_FieldTable` at `engine/settings/slot_menu.asm:529-530`, 9 words).  The proof is the bank 3 idiom at 68:4570-4574 and `ld a,$03 / call TextEngine_Run` at 67:4FEF-4FF1.
* **Still pending from the ramop8 note (existing names):** `engine/keyboard/keyboard.asm:2196,2215,2254,2273` (the `Kbd_TypeWaitsWithService` pattern) and `engine/dialog/dialog.asm:445,448`.

### 6. Tool and tests

* **No false accept.**  Property test: random structured programs, the tool's `plan()` against an abstract machine of A, real bank, shadow, `hTextTiles_DestBank` and stack, with conditional and unconditional jumps, loops, calls, unknown calls and fragment entries: 21,000 programs, about 12,500 accepted operands, 0 false accepts.  Targeted attacks are refused (a store followed by `jp`, `jr` or `jp hl` and an unlabeled fragment, a call between, a conditional call, a label,
  and A=0 with a multi-bank replay).  Fuzz: 250 mutated real trees, with and without masks, 0 crashes.
* **Bug (dead code).**  A rule row `(direct)\thl\t*\ta\t.*\tx` (or `dest`), with `ld hl,$D100 / ld a,[hl]`, makes `plan()` raise `TypeError` (`ci` is `None`) in `a_before` and in `dest_bank_before`; `read_rules` should reject a `(direct)` row whose needs is not `switch`.
* **Test gaps.**  12 mutants of the new logic: 5 killed by the unit tests, 5 equivalent, 2 survive the 49 tests and change behaviour: a dest scan that passes an unconditional `jp`, `jr` or `jp hl` rewrites an unlabeled fragment as `wTileStage2 + $780`; an `a` row with A = 0, idiom 7 and a replay mask `$82` is rewritten as `wScreenAttrMap`.  Both are one-line tests.
* **`apply_manual_sites.py`.**  It does not check `proposed text` against `ram/banked.asm` (bank or value): the SHA gate cannot see a name of another bank with the same number (all 78 rows pass the check the reader wrote).  The docstring says "code line" for the context: it is physical lines, with a comment-only line as the empty string.
* **Docstring and comment fixes:** `apply_ram_operands.py:18-20` says `--observed` serves "the `(direct)` rows" (it also serves `switch` and A=0 rows); the comment at `:590` says 29 operands, not 32.

### 7. Equivalence

* A clean `make` in the reader's copy gives SHA-256 OK / `RESULT: IDENTICAL`, and `make sym-check` is OK (15,001 labels).
* Every changed line pair, 675 in 58 files, is `ld hl|de|bc, $XXXX` -> `NAME[ + $HH]` with the same value (values evaluated from the DEFs), same prefix and same comment: 0 problems.
* `apply_banked_names --check` (177 names, 0 errors), `apply_overlay_aliases --check` (0 errors), `--areas wram0,hram,io --check` and `--areas wramx --observed --check` (rc 0) all pass; `localize_labels --check` and `tidy_comments --check` exit 0; the tool tests and the neighbouring suites pass.
* Re-running the tool and then the manual script on the tree of before reproduces the working tree exactly; running the manual script first and the tool second gives the same tree, and a second run changes nothing.

### 8. Docs

The tool docstring has the stale `--observed` line and the "29", and its `dest` description does not say that the scan starts at the consumer call.  `STYLE.md` (not touched by the pass) is missing or stale at the paragraph that lists only `-`/`switch`/`a` (nothing on `dest`, bank `*`, `--areas wramx --observed`, the `TextBuf`/`Wram3`/`TextEntry`/`Settings_StoreStringField` rows that select bank 3, `apply_manual_sites.py` and `ramop9_manual.tsv`; it still says that a site proven by reading goes into `ramop7_manual.tsv`),
at the check line (it should read `--areas wramx --observed --check`: the plain check gives 28 "no object" and 773 pending instead of 30 and 771) and at the paragraph on applying (nothing on the manual tool).  `docs/research/naming2_ramop9.md`, the note that the `[ramop9]` tag of the 17 DEFs points to, does not exist (the same defect `[ramop8]` had); `docs/README.md` and `REVERSE_ENGINEERING.md` are not updated; the header of `wramx_consumers.tsv` and the `keeps` definition in the header of `wramx_calls.tsv` should say the shadow caveat and the 5 observed counterexamples.

### 9. Limits

* Dynamic evidence is only the repository's 41 bank-observed and 64 coverage scenarios; the mGBA tracer and hardware were not run.
* The property test models A, the real and shadow banks, `hTextTiles_DestBank` and the stack; effects were read and checked against replay masks, not modelled.
* Of the roughly 190 static-plus-replay operands the reader verified consumer and register at ROM level and read the call sites, but did not re-prove each bank by an independent control-flow dataflow: their bank proof is the tool's scan in agreement with the replay.
* `engine/mail/sample_data.asm` was not opened, and no sample values were copied.  Only STYLE.md, the tool docstring, the TSV headers and the DEF lines were checked for claims; the research notes were not.

## 3. Reader of part B: report

### 0. Verdicts

| item | UPHELD | CORRECTED | DROPPED |
|---|---|---|---|
| names (3) | 3 (CONFIRMED is justified for all three) | 0 (wording of 2 `DEF` lines, 1 stale neighbouring `DEF`) | 0 |
| consumer rows | 3 `(direct)`, 5 widened generic rows, 20 of 21 drawer rows | `MailServerMgr_DrawFieldText` (its flow is bank 2E header staging), `Tilemap_ApplyMaskRect` (text only) | 0 |
| 16 `CopyBytes` rewrites | 16 | | |
| 138 `(direct)` rewrites | 135 | 3 (debug `wTileStage2`) | |
| 102 drawer rewrites | 99 | | 3 (`tidy_screen.asm`) |
| 19 manual rows | 19 | | |
| 60 neutral uses | 60 | | |

Overall 329 of 335 changed lines were upheld and 6 had to go back to numeric.  The brief's "22 drawer rows" was 21 drawer rows plus the `Tilemap_ApplyMaskRect` row (`rules_optional.tsv` had 22 rows).

### 1. The 3 names: UPHELD

* **Layout and `BB:AAAA`.**  Every quoted label address matches the `.sym` file; the unlabelled ones (4F:42FF, 4F:43B8, 4F:41CA, 48:44E0, 48:4540) match the source labels.
* **Blend formula.**  The reader ran the ROM's own `PalFade_BlendColor` (4F:4083, with `ScaledDelta` and `Mul8x8`) in a small SM83 interpreter on 4,000 random cases: 0 mismatches against `From + (To - From) * progress / 256`, with both signs of `To - From` for all three components; the delta magnitude is truncated toward From; progress word 0 gives From and a non-zero high byte gives To.
* **Start and Step modes.**  Run in the same interpreter: mode 0 uses colours 0-63, mode 1 uses 0-31, mode 2 uses 32-63, mode 3 uses 56-59 (offset `$70`); the progress word starts at 0, or at `$0100` for a negative step, so a fade-in starts at `wPaletteFadeTo` and walks back to `wPaletteFadeFrom`.
* **Masked fades.**  48:44E0 and 48:4540 copy `wPaletteBufBg` into both From and To; `Palette_SetFadeTargetMasked` then overwrites To only for the selected groups.
* **Counts** (`coverage_union.tsv`, scenarios column): 4F:42B4 and 4F:4370 63 each; 4F:42FF 55; 4F:43B8 11; 48:46C6 47; 48:44E0 27; 48:4540 11; 4F:4269 213,287 executions in 63 scenarios; 4F:4083, 4F:4166, 4F:41E0 and 4F:4269 run under bank 7 only in all 41 bank-observed replays; 4F:4257 944 executions in 11 scenarios.
* **Drivers.**  Exactly 11.  A ROM-wide byte scan (call, jp, farcall, `dw`) finds no other reference to 4F:4166, 4F:41E0, 48:459D or 4F:4083.  All 11 select bank 7 at entry.  The 8 drivers in `palette.asm` are called from the title screen, the browser and so on; the black, ObjPal and Capture variants have no caller anywhere.
* **Page screens.**  `page_view.asm:386` (4E:4CA3), `mobile_dictionary_view.asm:143` and `:171` (4C:5091, 4C:50D4) copy From back after `Palette_FadeOutToWhite`; nothing writes From after the initial copy.
* **Overlap.**  No other code touches `$D880-$D9FF` of bank 7.  The two `$D8F0` hits in `lib/mobile/main.asm` are the number -10000 added with `add hl, bc`.
* **Four-colour mismatch: real.**  ROM bytes: 4F:41A4 is `11 F0 D9 / 21 70 D9 / 06 04` and 4F:4243 is `11 60 00 / 21 F0 D9 / 06 04`.  In mode 3 `Start` fills To and Levels for colours 56-59 (offset `$70`); `Step` writes the level words for colours 56-59 but blends colours 48-51 (DE = `$60`..`$66`).  It is almost certainly a typo in one immediate (HYPOTHESIS): every other mode uses the same X for DE and for the Levels pointer, and only mode 3 breaks the pattern.  It is harmless today: the two ObjPal drivers that select mode 3 (4F:44DF, 4F:452A) have no caller.  Alternatively `Start`'s `$70` is the wrong one and the intended palette is OBJ 4; that cannot be decided.

Wording and stale-text corrections (rows of the reader's fixes table): `wPaletteFadeTo`: "the mask in A" is wrong at 48:459D (A is the step there; the mask is the drivers' A, kept in `hRam_FFB0`; only the 8 BG groups can be selected because `hRam_FFB1` is 0 after 8 `sla`); `wPaletteFadeLevels`: "stores 0 for the colours its mask leaves out" is true but overwritten, because `PalFade_Step_UpdateRange` rewrites every word of the mode before the first blend (a masked-out colour stays unchanged because its To colour is the copy of the buffer); `wPaletteFadeFrom`: "unchanged" should read "the start colour, unblended"; `wPalFadeMode` (`ram/wram.asm`): "always 0 in executed code" is stale (`Palette_FadeOutMasked` 48:4540 sets mode 1 and 4F:4257 runs 944 times in 11 scenarios); a dangling citation of `naming2_ramop9.md`.

### 2. The `(direct)` mechanism

**No false accept in the real tree.**  For all 138 applied sites the reader decoded the ROM at the mapped address: the first use of the register is a dereference, there is no flow instruction or bank write in between, and the mask at the load equals the mask at the first use.  Its own marker mapper and `tools/line_addresses.py` agree on all 256 + 60 + 19 sites, and every ROM instruction at a mapped address is the expected `ld rr, imm16` or `ld [imm16], a` with the same operand.

**Where the bank proof comes from.**  75 sites have both an idiom and replays; 35 are replay only (audio 6, n = 40-41; `address_picker.asm:1312-1382` 6, n = 3, straight-line code; `comm_error_screen.asm:502` 1; the mail library 22, bank 5, n = 2-4); 28 are idiom only (unobserved).  A strict scan (the nearest bank write is a canonical idiom of the claimed bank, with no label, jump or call in between) confirms 108 of 138 directly.  The other 30 are the 29 replay-only sites that start at a routine entry or after a call (22 mail library, 6 audio, `comm_error_screen.asm:502`) plus `debug_flags.asm:633`, which has a conditional `jp z` that falls through.

**Synthetic false accepts** (none reachable in the tree; 50 attack cases, `BANK7` = `ld a,$07 / ldh [hWRAMBank],a / ldh [rSVBK],a`):

* **R1.** `BANK7; ld hl,$D400; ld c,$70; ld a,3; ldh [c],a; ld a,[hl]` became `ld hl, wScreenAttrMap`.
* **R2.** The same with `ld de,$FF70 / ld [de],a`, or `ld bc,$FF70 / ld [bc],a`.
* **R3.** The write is `ldh [$70],a` or lower-case `[$ff70]`, between the load and the dereference or before the load (`BANK7; ld a,3; ldh [$70],a; ld hl,$D400; ld a,[hl]`): `bank_at` skips the unknown spelling and takes the older bank-7 idiom.
* **R4.** A cross-scope `call D.loop` into a loop head passes `loop_head_keeps_bank` (0 such references in the tree).
* **Fix.**  Extend `BANK_REGS` with the short numeric and lower-case spellings, `[c]` and the bare `rSVBK`, `hWRAMBank`, `$FF70`, `$FF8D` (an instruction that materialises the address of the register ends the proof too).  It removes R1-R3 and costs nothing: the dry run still gives exactly 256 rewrites and the 52 tests still pass.  R4 stays a limit (0 references in the tree).
* Stay numeric (checked): macro, `rst`, `call`, a label, `pop af` plus `rSVBK`, `inc hl`, `add hl,de`, `ld h,a`, `ld l,a`, `swap h`, `push hl / pop hl`, `ld sp,hl`, `ld a,h`, a conditional jump, a reload, a `db` line, `halt`, `stop`, a shadow-only write, no idiom, and the `bc` / `de` variants; loops whose body switches banks or calls an unknown routine, a forward-jump entry, a fragment after `ret`, and an idiom more than 60 lines back.

**Fuzz.**  1,500 random programs in 4 modes: 0 crashes, 7-column reports, idempotent output, no leak of a CAVEAT name.  **Mutation of `first_use_is_deref`:** mutants that ignore non-plain instructions, drop `[hld]` from `DEREF`, or shrink the scan window survived the 52 tests (no test covers `rst`, `jr`, a macro, `halt`, `bc`, `[hld]` or the numeric spellings).

**Interrupts.**  `Int_VBlank` never touches `rSVBK`.  `Int_Serial` and `Int_Timer` call bank 75 SDK code; `lib/` never writes `rSVBK` or `hWRAMBank`, and a static sweep of both call trees (34 and 111 blocks) reaches no ROM0 routine.  The STAT handler saves the real `rSVBK` and restores it to both the shadow and the register, so the real bank never changes across it.  Only `Sound_FrameService` (real bank 1, shadow unchanged) is a window, and it is a `call`, which ends the `(direct)` scan.  The shadow-desync mechanism of `naming2_verify_ramop7.md` section 4c can still make the shadow differ from the real bank; it was not re-investigated.

**Is `[c]` ever a write to `rSVBK`?**  No, in two ways.  Static: C holds only these ports: the APU registers in `audio/engine.asm` (`wSoundDrv_ChannelReg` `$12`-`$21`, `$25`, `$30`-`$3F`), the palette ports `$69` / `$6B` in `palette.asm`, `type_helpers.asm` and `home/init.asm`, `$80` in `home/lcd.asm`, `$07` and `$FF` in `lib/mobile/main.asm`; the source has only the spellings `ldh [rSVBK], a` (2,437) and `ldh [hWRAMBank], a` (1,522), no `ld c,$70`, no `ld de|bc|hl, rSVBK` and no numeric spelling.  Dynamic: the reader re-ran all 41 bank-observed replays with the repository's compiled tracer (inputs and state copied, outputs in scratch, deleted afterwards): a write watch on `$FF70` / `$FF8D` found 1,734 `rSVBK` writer instructions, all `ldh [$FF70], a`, and 1,068 shadow writers, all `ldh [$FF8D], a`; the single exception is 00:04DC (`FillBytes`), which wipes HRAM at boot and writes `$00` into the shadow.

### 3. The 138 `(direct)` rewrites

By register and bank: 89 `hl`, 35 `de`, 14 `bc`; 91 bank 1, 22 bank 7, 22 bank 5, 3 bank 2.  The reader read all of them for what the name says at the site.

* **Audio, 6 sites.**  The names match the `DEF` text and the code at 04:408C, 04:40D5, 04:415F, 04:4167, 04:4374, 04:4379 (`wSoundDrv_HeaderTrackCount` is the header count here; its `DEF` discloses the other use).
* **Edit-buffer sites, 14.**  All in the edit screens; `+ $3F`, `+ $0E` and `+ $12` are the last cells.
* **Screen buffers, 22.**  Fine; `comm_error_screen.asm:502` is called with bank 7 selected.
* **`wMailSessionBlock`, 72 sites.**  All are mail session, result and delete flows: the `+0` sites write the send result (1, 2 or `$FF`), `+1`, `+3`, `+5` are word counters set to `$FFFF` or incremented.  The name is an address in the block.  `list.asm:488,532` and `address_editor.asm:170` (earlier-pass names, not among the 138) use `$D624` as a one-byte mode flag:.
* **Mail library, 22 sites.**  `wMail_ItemListPointer` at `lib/mobile/mail.asm:2756` (0F:4F30, in the routine before `Mail_FetchComposeItem`), `:2772` and `:2791` (0F:4F3D, 0F:4F53) is the pointer use; the parse routines use `$D00D/$D00E` as one-byte values (lines 776-809, 1217-1228, 1284, 1506-1658, 1921, 1992).  `wMail_OutputBankVar` (17 sites) is the first byte of a 5-byte output cursor (bank, pointer, remaining length): the name is narrow but not wrong.  `wMail_KeywordValue` is consistent.

**CORRECTED (3): `wTileStage2` at the debug screens** (`debug_flags.asm:633` 19:45B4, `error_screen_test.asm:333` 19:4C91, `sound_test.asm:367` 1B:438E).  The code builds a Shift-JIS string at `$D000` of bank 2 and renders it with `TextTiles_RenderGrid`; the `wTileStage2` `DEF` itself says the debug screens use it as string scratch.  The matching `ld hl, $D000` source pointers (`debug_flags.asm:753`, `error_screen_test.asm:444`, `sound_test.asm:446`) and the string builders at `debug_flags.asm:776` and `:886` stay numeric, so the files were inconsistent.  Fix: `ld de, $D000 ; raw: debug string scratch ...`.

### 4. The text line drawers

* **Template.**  All 21 routines share it: `ld a,N / ld [wTextCellsLeft],a` at the entry, then at the loop head `ld a,$01 / ldh [hWRAMBank],a / ldh [rSVBK],a / ld a,[hli]`.  No HL use comes first, and the loop head reselects bank 1 on every pass.  `Profile_RedrawNickname` is a wrapper whose idiom is in `Profile_DrawNickname` (2A:5952).
* **Bank on exit.**  None restores the caller's bank: they leave 1, or 2 or 3 after the canvas blitter 7F:42CA.  This does not matter for the rewrite, because the string is read only after the idiom on every pass; because the drawers are not in `wramx_calls.tsv`, a call to one ends later proofs.
* **Offsets** agree with the cell counts: mail 20/24/20 at +0/+$14/+$2C, address book 16/24/24 at +0/+$10/+$28, profile +0/+9.
* **Family regex** too wide in one place only: `Body` lets through exactly 2 rewrites, both wrong.
* **DROPPED (3): `engine/mail_server/tidy_screen.asm:421`, `:429`, `:437`** (2E:4ECB, 2E:4EE2, 2E:4EF9, `MailServerMgr_DrawMailFields`).  They were rewritten to `wEditBodyBuf + $06`, `wEditAddressBuf` and `wEditBodyBuf + $1B`, but the data is the POP3 TOP summary staged by bank 54: `54:4B78` (`ld de,$D400`: date), `54:4B87` (`$D406`: source label), `54:4B93` (`$D41B`: subject), `54:4BA2` (`$D4C0`: sender name, or address when the name is empty).  The `wEditBodyBuf` `DEF` itself says "bank 2E reuses D400 for mail-header staging", and these sites ran under bank 1 in 3 replays.  Fix: three `; raw` marks, or drop that row and `Body` from the family.
* **The 10 `wrong family` rows** are `account/helpers.asm:222`, `received_mail_grid.asm:562` and `:584` (`$D524`, `MailGrid_DrawTextLine12`: exactly where the family blocks `wMailComposeMode`), `pop3_top.asm:210`, `:214`, `:217`, `:410`, `:414`, `:417` and `home/far_string.asm:37`: all correctly left.
* **`Tilemap_ApplyMaskRect` row.**  `mk_tierB.py` replaced the base row, which has a better proof text, with the shorter one of `rules_optional.tsv`.  Drop it from that file.

### 5. The 19 manual rows: UPHELD

All 19 are `ld rr, $XXXX` at the mapped ROM address, and each value equals name + offset.  11 rows run under bank 7 only (n = 41 for 4F:4083-4F:4131 and 4F:41C2-4F:41C5; n = 7 for 4F:425A; n = 21 for 48:45C5 and 48:45C8; 4F:4264 also n = 41).  The 8 rows in never-run code (the mode 1-3 `Start` entries and the mode 2-3 `Step` entries) rest on the callers, which all select bank 7.  The `ld de, $0040/$0060/$0000` in `Step_*` rightly stay numeric.  The three-line comment above `PalFade_Step_FourColors` is accurate (emulated); it only had the dangling citation.

### 6. The 60 neutral uses: UPHELD

All are `ld [wRam_Dxxx], a`, and the tile and attribute pairs are `$400` apart.  28 are idiom plus replay (one bank), 22 are replay only (20 in `connect_dialog_screen.asm`, which has `ReadByteFar` in between, and 2 in `tidy_screen.asm`), 10 are idiom only: the bank was shown by replays for 50 of them.  The 220 `bank not shown` have no replay at all (115 `lib/mobile/mail.asm`, 61 `audio/engine.asm`, 28 `tidy_screen.asm`, 16 `menus.asm`); the 63 `no object` are 44 `lib/mobile/mail.asm` and 19 elsewhere.

**44 can be named now with proof** (`config/ram_context.tsv` independently reaches the same bank 7, PROBABLE):

* `engine/browser/menus.asm` lines 71, 73, 75, 77, 79, 80, 81, 82 and 524, 526, 528, 530, 532-535 (16): the idiom at 47-49 and 497-499 dominates the only jump (`jr z`) to `.l6476` and `.l67B2`; nothing writes a bank register in between, and each label has one reference.
* `engine/mail_server/tidy_screen.asm` lines 895-1052 (28 sites): `MailServerMgr_DrawMailNumber` (2E:5184) selects bank 7 at entry (idiom 2E:5186-518A); the only calls on the way are `farcall Divide16`, which writes no bank register (00:0D67-0D91); `.l51FD`, `.l525A`, `.l52A0`, `.l52CF` each have one reference, a `jp z` from the block before, and that block ends in `jp .l52DC`.  The tool cannot see this because of the local labels.

### 7. The `CAVEAT` refusal and the report columns

* **Mutation.**  Dropping the check in `plan` is killed by `test_direct_rows`; in `plan_neutral` by `test_neutral_names`; in `plan_elements` it survives (that branch has no test).  No way was found to write or crash a CAVEAT name through `plan`, `plan_elements` or `plan_neutral`.
* **Accounting.**  `--check` does not print the caveat count and the elements summary has none (a reporting gap only).
* **Per-site marks.**  `; raw` is honoured only for `ld hl|de|bc` operands; `plan_neutral` and `plan_elements` ignore it.  `apply_banked_names.py` and `apply_manual_sites.py` do not consult CAVEAT.
* **The convention.**  A text match on the `DEF` line is workable but fragile: overlays described in other words are missed.  Cases found: `wEditBodyBuf` (2E header staging, 2 wrong rewrites), `wTileStage2` (debug string scratch, 3 wrong rewrites), `wMail_ItemListPointer` (parse routines), and `wMailSessionBlock` (a one-byte mode flag in the address book).  Proposed: `CAVEAT:` on `wEditBodyBuf` and `wMail_ItemListPointer`, and `; raw` for the debug sites; a CAVEAT on `wTileStage2` would block legitimate `dest` rows.  The `wMailComposeMode` case at `mailbox_screen.asm:830` is right: that code copies the digit buffer to VRAM.

### 8. Equivalence and limits

* `make` in the before tree, the tree with the tool and rules but no rewrite, the final tree, the reader's fixed copy and a fresh `run_tierB.sh` run: all `RESULT: IDENTICAL`, and the `run_tierB.sh` output equals the package state file for file.
* 335 changed lines.  The set equals the union of the apply rows (256 + 60) and the manual rows (19); each differs only in the operand (prefix, suffix and trailing comment byte-identical), and name + offset equals the old value (the `DEF`s evaluated from `ram/*.asm`).  The only other change is the three comment lines.  `decisions_wramx.tsv` (816 rows) and `decisions_neutral.tsv` (344 rows) are reproduced exactly by the tool.  Audits (banked names, overlay aliases, wram0/hram/io, wramx `--observed`, neutral `--observed`, localize, tidy): 0 errors; the final tree is idempotent under all three tools.
* **Limits.**  The bank proofs assume the shadow equals the real `rSVBK` (the `Sound_FrameService` plus STAT desync of `naming2_verify_ramop7.md` can break that; the fade loops call `Sound_FrameService` between blends).  The dynamic evidence is the repository's 41 bank-observed replays; per-site semantics are by reading, and the 72 session-block and 102 drawer sites repeat a few identical patterns.  The `bank not shown` rows outside `menus.asm` and `tidy_screen.asm` were not examined.
