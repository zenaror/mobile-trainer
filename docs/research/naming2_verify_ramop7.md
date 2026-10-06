# Banked WRAM pointer operands (ramop7): independent verification of the first version

> Status: **reference (current)** for the corrections it lists.  The corrected pass: [`naming2_ramop7.md`](naming2_ramop7.md); rules and records: [`analysis/naming2/wramx_consumers.tsv`](../../analysis/naming2/wramx_consumers.tsv),
> [`analysis/naming2/wramx_calls.tsv`](../../analysis/naming2/wramx_calls.tsv), [`analysis/naming2/ramop7_manual.tsv`](../../analysis/naming2/ramop7_manual.tsv).

Verification of the first version of the pass (1,516 operands, 525 expressions; tool `tools/apply_ram_operands.py` with the area `wramx` and the mode `--elements`) on 2026-10-05 by a reader with a fresh context that had not seen the reasoning behind the rules.  The reader was told to attack every
claim from the code and from `analysis/rambank/observed_banks.tsv`, to re-derive the straight line at ROM-byte level, to try to break the tool and to judge the documents; the repository stayed read-only (builds only in a private copy).  The reader could not write its report as a file (the harness asks
subagents to return findings as text), so the text of its final reply is reproduced below, with the harness frame removed and its private scratch paths named in general terms.  The reader's own helper scripts (a byte-level marker builder, a dataflow over the bank register, an attack script and a fuzzer) were
in its scratch directory and are not kept.

## 1. Result

**Rules: 7 of 8 upheld, 1 corrected.  Operands: 1,516 of 1,516 upheld.  Expression rewrites: 523 of 525 upheld, 2 dropped.**  Two findings that nobody had listed: the tool had false-accept classes (two real in the tree), and the explanation of `page_list.asm:2531-2535` in the first draft of the note was wrong.
Integration (what was done with it; the corrected pass is in `naming2_ramop7.md`):

* the two dropped rewrites (`engine/mail/mail_viewer_sender.asm:84,85`) were reverted; the proof text of the `ConnIcon_UpdateState` rule, the `DEF` comments of `wSpriteSlot0`, `wPaletteBufBg`, `wPaletteBufObj`, `wSpriteSlotBackup` and `wSpriteSlots`, the research note (the mechanism at `page_list.asm:2531-2535`,
  "writes single palettes", "596 were +0 or +1"), the STYLE.md paragraph and the tool's docstring were corrected as the reader listed;
* the tool got a stricter proof: a table of the bank effect of routines (`wramx_calls.tsv`: 27 rows at that commit, `keeps` or `sets W7`; an unlisted routine, a conditional call, `rst` or a macro ends the proof), an unconditional `ret`/`jp`/`jr` ends the scan, a loop head is passed only when its body keeps the bank, numeric
  spellings of the bank register and upper-case operands are seen, a macro line between the load and the call is not transparent, the rule file has a sixth column (the name family: `wSpriteSlot[0-9]+`, `wPaletteBuf(Bg|Obj)`), and an expression that is part of a larger one (`N + 16 * 3`) is left alone;
  8 new tests reproduce R1-R5, R12, R13 and E16; the reader's attack script, run again against the new tool, leaves every false accept unchanged;
* data: the 16 `CopyBytes` palette sites and `connect_dialog_screen.asm:451` are now derived by the tool (two new rules, `Palette_LoadToBuffer sets W7`); `type_helpers.asm:205` and `palette.asm:213,227` were written by hand; the 89 `wSpriteSlots + N` expressions that the reader proved to run under bank 7
  (dataflow plus reading of the routine) were rewritten by hand, each with its proof in `ramop7_manual.tsv`; 50 expressions keep the old spelling (4 seen under bank 1, 20 expected under bank 1 after `Dialog_Show`, 23 with no known entry, 1 PROBABLE, 2 reverted).

## 2. The reader's report

### 0. Verdict counts

| item | UPHELD | CORRECTED | DROPPED |
|---|---|---|---|
| Rule rows (8) | 7 | 1 (`ConnIcon_UpdateState` proof text) | 0 |
| Operands (1,516 = 1,506 tool + 10 hand) | 1,516 | 0 | 0 |
| `wSpriteSlots + N` rewritten (525) | 523 | 0 | 2 (`engine/mail/mail_viewer_sender.asm:84,85`) |
| `wSpriteSlots + N` left as is (4 "other bank") | 4 correct to leave | | |
| `wSpriteSlots + N` left as is (133 "bank not shown") | 89 are provable bank 7, 1 is PROBABLE, 20 expected bank 1, 23 have no known entry | | |

The 523 upheld element rewrites break down as:

* 481 proven by the reader's dataflow (292 of them also observed under bank 7 only);
* 41 observation-only (the dataflow cannot prove them; by `analysis/rambank/inference_report.md` that is PROBABLE);
* 1 by reading: `mail_session.asm:531`.  The tool's idiom scan accepted it without looking at `MailSession_UpdateTimerDisplay`, which returns in bank 7.

Two new findings that were not listed:

* The tool has false-accept classes.  Two are real in the tree (point 4b).
* The explanation of `page_list.asm:2531-2535` in `docs/research/naming2_ramop7.md` is wrong (point 4c).

### 1. Rule file

Each routine was read and cross-checked with `observed_banks.tsv`.

| row | verdict | evidence |
|---|---|---|
| Sprite_InitSlot 00:0A82 | UPHELD | Idiom 00:0A92-0A96 (`home/sprites.asm:248-250`) precedes every use of HL: FillBytes call 00:0A9C, store at HL+$0E 00:0AA7, Sprite_LoadObjectEntry. Restore 00:0AB0-0AB3. Mask {7} on 00:0A98-0AB3, n=41. |
| Sprite_SetPosition 00:0A65 | UPHELD | Idiom 00:0A6D-0A71, stores 00:0A74/0A76, mask {7}, n=41. |
| Sprite_ClearSlot 00:09E6 | UPHELD | Idiom 00:09EF-09F3, FillBytes 00:09FA, mask {7}, n=31. |
| Sprite_SetHook 00:0A45 | UPHELD | Idiom 00:0A4E-0A52, stores 00:0A55/57/5A, mask {7}, n=18. All 15 sites use slot+$0B (DA2B x7, DA8B x1, DACB x7). |
| Palette_LoadToBuffer 4F:4000 | UPHELD | Idiom 4F:4002-4006. `call $06BC` (FarCall_Inline16) with inline `dw $050C`. No restore, so it leaves bank 7. All 173 destinations lie inside $D800-$D87F. |
| Palette_UploadBuffer 4F:404B | UPHELD | Derefs 4F:406F-407D. Mask {7} at 4F:404B-4082, n=41. |
| Palette_ReadHardwareToBuffer 4F:400E | UPHELD | Stores 4F:402B/4032/403F/4046. Mask {7}, n=21 (not stated in the proof, consistent). |
| ConnIcon_UpdateState 69:4034 | CORRECTED | See below. |

**ConnIcon_UpdateState.**  The bank-7 claim holds (mask {7} on 69:4034-4042, n=6; deref `ld a,[hl]` at 69:4038).  The text "its only caller ConnIcon_Refresh (69:401A)" is false.

* `ConnIcon_StartSprite` installs it as the per-frame hook of slot 8 (`engine/browser/status_sprites.asm:107-110`: `ld hl, wSpriteSlot8 + $0B / ld de, $4034 / ld a, $69 / call Sprite_SetHook`).
* `Sprite_StepAndDrawSlot` enters it through the push/ret trick at 00:0B36-0B53, with HL = the slot and bank 7 selected by `Sprite_UpdateAll`.
* In a replay of browser_bookmarks the call graph shows `ret_unmatched 00:0B53 -> 69:4034` 3,255 times.  Bank 7 holds on both paths.

Wording notes, no verdict change:

* "restores the caller's bank" is exactly "restores the `hWRAMBank` shadow saved at entry".  That differs from the caller's real bank when the two are out of sync (point 4c).
* 311 executed `needs=-` sites run with the caller under a bank other than 7: 175 never under 7, 136 under several banks.  The names are right for the consumer, not for the caller's bank.  One STYLE sentence would help.

### 2. Operands

The straight line was re-derived at ROM-byte level for all 3,328 loads, with the reader's own marker builder and `tools/sm83.py`.  It is independent of the tool's text scan.  For each of the 1,506 tool-applied sites:

* The load is `ld R,$Dxxx`.
* The only instructions before the first call are 0 to 3 immediate loads of other registers (HL: `ld a`, `ld de`, `ld b`; DE: `ld hl`, `ld a`, `ld bc`).  Zero instructions use or touch the register.
* No `.sym` label sits between the load and the call.  There is no conditional flow.
* The call is `call`, farcall or `jp`, and its target bank:address equals the rule's routine (`.sym`).  Inline `dw`/`db` of `call $06D1` were read.

The reader's independent text scan also agrees with the tool on all 3,328 outcomes (0 disagreements).

Dynamic check on the 20 executed `switch` loads (18 UploadBuffer, 1 ReadHardware, 1 ConnIcon): all have mask exactly {7}.  The other 18 are never executed.  The reader's dataflow proves bank 7 at all 38 `switch` loads (37 applied + the hand edit at `connect_dialog_screen.asm:451`).

Of the 37 applied `switch` loads, 30 have only `call VBlank_WaitStartDI` between idiom and load.  The 7 in the fade routines (`palette.asm:516,550,614,647,710,772,815,857`, `palette_fade_*`) have bank-neutral calls: CopyBytes, PalFade_Start/Step, LCDOn, Sound_FrameService.

177 sites were read: all 15 SetHook, the 37 `switch` sites with their idiom-to-load segments, 25 LoadToBuffer including all 8 distinct addresses, 40 InitSlot, 40 SetPosition, 20 ClearSlot.  All 8 values were seen, and every destination is on an 8-byte palette boundary.  Nothing was wrong.  Slot pointers are bases (`DA00`..`DAD0`), except SetHook at `+$0B`.

The 14 `value` outcomes are Y,X pairs (`ld de, $D0xx` before Sprite_SetPosition).  Correct.

The 10 hand edits are all justified:

* `home/sprites.asm:27,90` and `engine/sprites/slot_backup.asm:17,18,50,51`: the idiom is right above, and the bank-3 idiom precedes the `[de]`/`[hl]` access in the loop.
* `connect_dialog_screen.asm:1160,1178`: a conditional jump sits between load and `farcall Sprite_SetPosition`, but nothing touches HL on either path.
* `connect_dialog_screen.asm:451`: `Palette_LoadToBuffer` (line 446) leaves bank 7, and `VBlank_WaitStartDI` keeps it.  Observed {7}.
* `engine/browser/scrollbar.asm:530`: `ld a,$07 / ldh [rSVBK],a` at 4E:5E80-5E82 (no shadow write).  Stores `[hli]` at 4E:5EB5/5EB7 are bank 7 only, n=9.

Re-applying the tool to a fresh copy of the pre-pass tree (real build: SHA-256 OK, `sym_check` OK, both passes) reproduces the working tree exactly, except the 10 hand edits.

After the call, the first use of the register is never a `[hl]` deref in the caller's bank.  Outcomes are: kill, another consumer, `push`/`pop`, or a jump.

### 3. Sites left numeric in `$DA00-$DAFF` and `$D800-$D87F`

In the BEFORE data the reader counts 11 non-applied sites in `$DA00-$DAFF`, not 15 (the missing 4 were not found).

* 7 were hand-edited afterwards.
* 4 remain numeric, and all four are right:

| site | what it is |
|---|---|
| `save_sender_address.asm:1313`, `page_list.asm:1503`, `mailbox_screen.asm:1300` | `bc=$DA00` to TextTiles_RenderLine; `hTextTiles_DestBank` = $02 is set a few lines above each, so bank 2 |
| `mobile_dictionary_view.asm:21` | bank 6 idiom, FillBytes of $600 |

In `$D800-$D87F` there are 42 numeric sites after the pass (the BEFORE list has 43; the hand edit at `connect_dialog_screen.asm:451` is the 43rd).  The coordinator's reading holds for 23 of them and fails for 19.

Confirmed other bank (23):

* 15 HDMA/GDMA sources with the bank-2 idiom before them: `address_picker.asm:2424`, `save_confirm.asm:391`, `page_list.asm:1397`, `mobile_dictionary.asm:543`, `body_editor.asm:1406`, `draft_menu.asm:950`, `mail_viewer_body.asm:311`, `mail_viewer_sender.asm:1203`, `mailbox_screen.asm:1247`, `delete_hidden.asm:1237`, `delete_menu.asm:1158`, `tidy_screen.asm:1159,1318`, `canvas.asm:2053`, `page_list_prototype.asm:1618`.
* 6 computed pointers with `hTextTiles_DestBank`=2: `delete_hidden.asm:896,930,959`, `delete_menu.asm:817,851,880`.
* `tidy_screen.asm:1308` (RenderLine dest, bank 2).
* `debug_flags.asm:525`: **bank 3**, not 2 or 6.

Refuted, bank 7 (19).  The palette buffer, with a name available:

* 16 sites with consumer `CopyBytes`, which has no rule.  The bank-7 idiom is a few lines above in every case: `palette.asm:505,539,604,637,699,762,801,844` (`hl`), `palette_fade_masked.asm:19,23,59,63`, `palette_fade_ticker.asm:20`, `page_view.asm:385` (`de`), `mobile_dictionary_view.asm:142,170` (`de`).  Two rows (`CopyBytes hl W7 switch`, `CopyBytes de W7 switch`) would catch all 16.
* `type_helpers.asm:205` (`ld de,$D872`): direct deref after the idiom, bank 7, `wPaletteBufObj + $32`.
* `palette.asm:213,227` (`ld hl,$D800 / add hl,de` in PalFade_BlendColor): bank 7 by contract, mask {7}, n=41 at 4F:4126.

All 19 are proposed as OPTIONAL rows.  The neighbours `$D880/$D900/$D980` (128-byte fade buffers, the same instructions) stay unnamed.

### 4. `wSpriteSlots + N`

**4a. Census.**  Recomputed independently (the reader's own marker mapper agrees with `tools/line_addresses.py` on all 662 lines, 0 differences):

* 662 expressions, all `ld [X],a` (561) or `ld a,[X]` (101).
* Idiom 386, observed bank 7 only 333, both 194, union 525.  Never executed: 325 (192 idiom-only + 133).  4 observed under bank 1.
* All 525 changed lines have the same value and the same comment.  Slot arithmetic N=16k+o is correct.
* Sample of 60 (20 idiom+observed, 20 idiom-only, 20 observed-only): 0 problems on arithmetic, dataflow/observation and `config/ram_context.tsv`.
* Cross-check with `config/ram_context.tsv`: 508 of 525 have a bank-7 claim (206 CONFIRMED, 301 PROBABLE, 1 mixed).  17 have no claim.  There are 0 contradictions.

**4b. False accepts of the tool (2 real in the tree).**

* `mail_viewer_sender.asm:84,85` (`Function_2B_64F1`, never executed): the idiom at 68 is followed by `farcall Dialog_Show` at 81.  The stores `ld [wSpriteSlot1],a` and `ld [wSpriteSlot2],a` come right after it, with no new idiom.  This is the same sequence as `page_list.asm:2515-2535`, which ran under bank 1.  The tool
  accepted it because its backward scan ignores calls.  Proposed: revert to `wSpriteSlots + 16` / `+ 32`.
* `mail_session.asm:531` also has calls between idiom and access, but it is correct (see section 0).

All other never-executed idiom-accepted sites have no call between idiom and access, or only bank-neutral ones.

**4c. `page_list.asm:2500-2560`.**

* The routine selects bank 7 at 24:51FF (lines 2486-2488) and saves/hides X of slots 3/2/1 and Y of slot 0 under it.
* At 24:5237 (`farcall Dialog_Show`) the bank is 7.  On return at 24:523D it is **1**.  The four restoring stores (24:5255-525F) therefore write bank-1 bytes `$DA31/$DA21/$DA11/$DA00`.
* It is not a replay artifact, and "the caller runs under bank 1" is not the reason.
* browser_bookmarks (the only replayed scenario that runs this code, n=1) was replayed with the repository's compiled tracer and `--watch FF8D FF70`; it reproduces the masks.

Mechanism, from the write log (frame 18410, then 19418):

* `Sound_FrameService` (00:03AD) sets rSVBK=1 while hWRAMBank=07.
* `Stat_ScrollSplitHandler` fires inside that window (00:0E9F-0EAB).  It saves the real rSVBK ($F9 = bank 1) and on exit writes it into **both** hWRAMBank and rSVBK.
* `Sound_FrameService` exit (00:03B3) writes rSVBK:=07 from the pushed shadow, and never repairs hWRAMBank.  State: shadow $F9, real 07.
* Later, `Dialog_Close` (`dialog.asm:513-519`, 566-567) saves and restores the shadow.  At frame 19418, 72:44DF/44E1 write $F9 to both, so the bank on return is 1.
* At 72:4021 (the `Dialog_Close` call in `Dialog_Show`) all 13 scenarios show mask exactly {1}.  Those 13 are not independent evidence: callers under bank 1 return 1 by design.  Only the PageList_DeleteSlot run enters with 7 and leaves with 1.

Verdicts:

* Author's intent: bank 7 (HYPOTHESIS).
* Effective bank: 1 (CONFIRMED by the replay; mechanism CONFIRMED by the write log).
* Generalisation to hardware timing: HYPOTHESIS.
* The old name `wSpriteSlots + N` is wrong in effect at 2531-2535.  Same pattern, never run, correctly left alone: `page_list.asm:2144-2148`, `save_sender_address.asm:481-484`, `page_list_prototype.asm:2263-2268, 2628-2633`.
* The research note's reason ("bank 1 in effect when the caller runs under bank 1") is wrong.

**4d. The 133 "bank not shown", by file.**  "Proven" below means the reader's dataflow, with a hand check of the routine.  Per routine the idiom line is given.  The two caller-based rows are interprocedural (sole caller).

| file | n | routine and proof |
|---|---|---|
| `address_picker.asm` | 22 | 701-727 (14): `AddrPick_RefreshSlotIcons_2C_5A12` idiom at 435-437 dominates every path to `.l5C5B`. Only Sprite_InitSlot and AddrPick_TestSlotEmpty on the way. **Proven.** 2321-2386 (8): `AddrPick_CursorMoveEffect` has no idiom, but its sole caller 2184 runs under bank 7 (idiom 1847-1849). **Proven.** |
| `save_sender_address.asm` | 14 | 481-484 (4): `SaveSenderAddr_SaveToSlot`, the Dialog_Show pattern, **expected bank 1, keep**. 1169-1261 (10): `SaveSenderAddr_CursorMoveEffect`, sole caller 1072 under bank 7 (idiom 780-782). **Proven.** |
| `frame_style_chooser.asm` | 2 | 368,370: idiom 331-333, loop without calls, only exit is the `jr z,.l4637`. **Proven**; `ram_context` PROBABLE 7. |
| `page_list.asm` | 20 | 831-950 (12): `PageList_HighlightRowSprite` idiom 734-736 dominates. **Proven.** 2144-2148 (4): Dialog pattern, expected bank 1. 2531-2535 (4): observed bank 1. |
| `start_choice.asm` | 1 | 175: `BrowserStart_Idle`, a dispatch handler; `ram_context` PROBABLE 7, no static proof. |
| `scroll_split.asm` | 2 | 106,136: idiom inside the fragment (92-94, 122-124). **Proven.** |
| `body_editor.asm` | 16 | 832-984: an unlabeled fragment after the `ret` of `MailBody_PlaceCursorSprites`, entry not located, no idiom. **No proof; keep.** |
| `send_receive.asm` | 1 | 1479: idiom at loop head 1453-1455. **Proven.** |
| `page_list_prototype.asm` | 59 | 949-966 (12), 1017-1184 (22), 2082-2103 (6): idiom at the routine start (825, 980, 2055), only Sprite_InitSlot calls. **Proven (40).** 2123-2162 (7): fragment with no entry. 2263-2286 (8) and 2628-2633 (4): Dialog pattern. |

Totals: 89 provable, 1 PROBABLE, 20 expected bank 1, 23 no entry.  Plus the 4 "other bank".

### 5. New DEF lines

The arithmetic of all 14 slot DEFs is right (address, size 16, "at $DA00 + $xx"), and there are no overlaps.  Findings:

* `wPaletteBufBg`: "executed in 63 scenarios, bank 7 in every observed run" mixes two bases.  63 is `coverage_union` (of 64); the bank-observed replays are 41, the number the rule file uses.
* `wPaletteBufObj`: "Palette_LoadToBuffer fills one palette" is false.  BC is 8 to 64 bytes.  Of 173 sites, 132 copy a whole 64-byte half and 15 copy one palette; of the 76 object destinations, 51 copy 64.
* `wSpriteSlotBackup`: "executed in up to 2 of 18 scenarios" is stale.  Observed: 7 scenarios (`7F:624F-62A8`, bank 7 only between the 7-idiom and the push, bank 3 only after the 3-idiom); `coverage_union`: 15.  Copy of 256 bytes `$DA00-$DAFF` to `$D900-$D9FF` is true.
* `wSpriteSlot0`: "(the Y, X pair)" is stated flat, but the layout is HYPOTHESIS in `home/sprites.asm`.  Mark it PROBABLE.  Add that the hook is entered by Sprite_StepAndDrawSlot with HL = slot (e.g. ConnIcon_UpdateState as slot 8's hook).
* `wSpriteSlots` (`ram/wram.asm:791`): "have no proof of bank 7" is a statement about the pass.  89 of the 133 are provable.
* Convention: a bank-7 name whose comment claims bank 7 lives in the bank-agnostic `ram/wram.asm`.  This is inherited, but now explicit.
* CONFIRMED on the slot, palette and backup names is justified by execution (Sprite_* 18/31/41 scenarios, Palette_* 41, backup 7, all with bank observed).

### 6. Tool and tests

Results in the reader's copy:

* `python3 tools/test_ram_operands.py`: 22 tests OK.
* `--areas wramx --check`: rc 0 ("0 raw operand(s) with an object, 14 values; 1798 without a rule or a shown bank").
* `--elements wSpriteSlots --observed --check`: rc 0 ("0 expression(s) ... 133 with the bank not shown, 4 seen in another bank").
* `apply_banked_names --check`: 0 errors.  `apply_overlay_aliases --check`: 0 errors.
* Also OK: `make`, `make sym-check`, `tidy_comments --check`, `localize_labels --check`.

Fuzz: 600 random trees x 4 modes (wramx apply, `--elements`, `--check`, `--dry-run`): 0 crashes.

False accepts (reproduced in a temp tree; the reproductions use the test files plus a rules file with Sprite_InitSlot, Sprite_SetPosition and Palette_UploadBuffer `switch`):

| id | minimal input | tool result | note |
|---|---|---|---|
| R1 | `ld a,$07 / ldh [hWRAMBank],a / ldh [rSVBK],a / call SwitchToBank3 / ld hl,$D800 / farcall Palette_UploadBuffer`, with `SwitchToBank3:: ld a,$03 / ldh [hWRAMBank],a / ldh [rSVBK],a / ret` | `ld hl, wPaletteBufBg` | Calls between idiom and site are never checked.  Elements variant: `ld [wSpriteSlots + 17],a` after the call becomes `wSpriteSlot1 + $01`.  Real case: `mail_viewer_sender.asm:84-85`. |
| R2 | same idiom, `.loop / ld hl,$D800 / farcall Palette_UploadBuffer / call SwitchToBank3 / jr nz,.loop` | rewritten | `loop_head_keeps_bank` only looks for direct `rSVBK` writes. |
| R3 | idiom, `ret`, blank, `push bc / ld hl,$D800 / farcall Palette_UploadBuffer` | rewritten | The scan crosses an unconditional `ret`/`jp X`/`jr X` into a fragment with its own entry.  The tree has such fragments (`MailBody_PlaceCursorSprites`, `Gfx_GdmaAtVBlankNoDi`), though none hit. |
| R4 | `ld hl,$DA10 / farcall_raw $4123,$20 / call Sprite_SetPosition` | `wSpriteSlot1` | `farcall_raw` is not a transfer.  Unused today (0 sites). |
| R5 | `ld hl,$D800 / call Sprite_InitSlot` | `wPaletteBufBg` | A rule knows consumer and bank, not the family of object.  Real data: only `$DA00-$DAD0` reach the Sprite_* consumers. |
| R12 | idiom, then `ld a,$03 / ldh [$FF70],a` | rewritten | Numeric spelling of rSVBK is not seen.  Only in comments today. |
| R13 | `ld hl,$DA10 / ld a,[HL] / call Sprite_InitSlot` | rewritten | Upper-case operand is not seen.  Lower-case everywhere today. |
| E16 | `ld a,[wSpriteSlots + 16 * 3]` | `wSpriteSlot1 * 3` | The value changes.  The ROM compare would catch it.  Also `wSpriteSlots - 1` becomes `wSpriteSlot0 - 1` (same value, wrong object). |

Safe cases (no false accept): `call nz, Sprite_InitSlot`, `jp hl`, `call .local`, comments holding the idiom, idiom for another bank, `ld a,$07 / inc a / ldh ...`, two loads of the same register, a label in between, CRLF, same local label in two routines.

Suggested fixes:

* (1) In `bank_switch_before`, after finding the idiom, re-scan the segment before the site and refuse on: an unconditional `ret/jp/jr`; `call`/`farcall` to a routine not on a bank-neutral allow-list (or with a computed summary); `call BankSwitch_*`; `[$FF70]`/`[$FF8D]`.  Apply the same to the loop body in `loop_head_keeps_bank`.
* (2) Treat `farcall_raw` as an unknown consumer.
* (3) Lower-case operands and add `[c]` to the bc family.
* (4) In `plan_elements`, refuse a match followed by an operator or preceded by `-`/`*`/`/`.
* (5) Add an optional "name family" column to the rule file.

The reader's patched variant of (1) with an allow-list, on the real tree, drops exactly 7 idiom-only elements and 0 operands: `mail_viewer_sender.asm:84,85` (correct) and 5 `mail_session.asm` ones (197, 447, 531, 1471, 1550) that are fine once `MailSession_UpdateTimerDisplay` is allow-listed.  The executed ones among them stay via the observation.

Missing tests: none of R1-R13/E16 is covered by `test_ram_operands.py`.

`tools/line_addresses.py`: no bug found.  It matches the reader's mapper on 662/662 lines.  Limitations: it fails (RuntimeError, exit 1) if a requested line precedes any global label (local label with no parent); only an unlikely case.

### 7. Equivalence

* `make`: RESULT: IDENTICAL.
* The reader's own diff script over `git diff -U0` (1,857 hunks, 2,041 line pairs): 1,516 pointer operands and 525 element expressions, all the same value after normalising names (DEF values from `ram/*.asm`), comments unchanged, 0 problems.
* Audits, tests and checks as in section 6.

### 8. Documentation claims

Tool docstring:

* `--elements`: "`N + 128` becomes `<element> + $00`-style" is inexact.  Offset 0 gives the bare name `wSpriteSlot8`.
* "first `call`/`farcall`": omits the tail `jp Label` that the code accepts.
* "(no label in between)": loop heads are passed.
* "the idiom earlier in the same straight line": the scan is limited to 60 lines, and calls, `ret` and `jp` in between are not checked (R1, R3).
* The module docstring never says that `--elements` needs bank proof (idiom or `--observed`), and its usage line lacks `--observed`.
* "memory operand or pointer with an offset" overstates the filter.  Any tab-indented line without a quote is matched.

STYLE.md new paragraph:

* "of that bank must stand earlier in the same routine" has the same 60-line and no-call-check gaps.
* The loop-head sentence is accurate.
* Everything else that was checked is true, including the bank-6 and bank-2 meanings of `$DA00`.
* `line_addresses.py` prints two columns (bank, address), not "bank:address" (trivial).

`docs/research/naming2_ramop7.md` (first draft):

* Section 4, first bullet: "in every replay" means one replay.  The reason given is wrong (4c).
* "`Palette_LoadToBuffer` writes single palettes" is false (132 of 173 sites copy 64 bytes).
* "596 were `+0` or `+1`" means slot bytes 0 or 1 (offset mod 16); literally `+0`/`+1` only 7.
* The counts 386/333/194/525, 85 files, 1,300 + 210 + 6, 1,798 + 14, 611 and the 22 tests are all right.

### Limits of the reader's check

* The reader's dataflow is independent but approximate.  It tracks A only, summarises calls, and treats BankSwitch_* and dispatch tables as unknown.  It proves; it does not disprove.  It contradicts none of the 961 executed sites where it claims a single bank.
* Dynamic evidence is the 41 replays, plus one re-run of browser_bookmarks with a write watch.  Hardware timing of the shadow-desync mechanism was not tested.
* The 1,812 numeric banked operands outside the two ranges were not examined, and only the new paragraph of STYLE.md was checked.
* The research note and STYLE.md were read from the repository, because they appeared after the snapshot.
* No memory-service writes, no commits, no repository writes.  The replay outputs that could hold save-RAM or adapter data were deleted from the reader's scratch directory.
