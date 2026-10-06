# The two screen buffers of WRAM bank 7 (ramop8): independent verification of the first version

> Status: **reference (current)** for the corrections it lists.  The corrected pass: [`naming2_ramop8.md`](naming2_ramop8.md); records: [`analysis/naming2/wramx_consumers.tsv`](../../analysis/naming2/wramx_consumers.tsv),
> [`analysis/naming2/wramx_calls.tsv`](../../analysis/naming2/wramx_calls.tsv).

Verification of the first version of the pass (276 operands: `wScreenTileMap` and `wScreenAttrMap`, the rule type `needs = a` and the effect `keeps if A=0`) on 2026-10-05 by a reader with a fresh context that had not seen the reasoning behind the rules.  The reader was told to attack every claim from the code
and from `analysis/rambank/observed_banks.tsv`, to re-derive every rewritten operand, to try to break the new logic and to judge the documents; the repository stayed read-only (builds only in a private copy).  The reader could not write its report as a file (the harness asks subagents to return findings as text),
so the text of its final reply is reproduced below, with the harness frame removed and its private scratch paths named in general terms.  The reader's helper scripts (an independent re-derivation of all 276 sites, a 56-case attack script and a property test over 93,000 random programs with an abstract machine of A,
the real bank and the stack) were in its scratch directory and are not kept.

## 1. Result

**Consumer rows: 5 upheld, 5 corrected (the family of the five `Tilemap_*` rows).  Effect rows: 8 of 8 upheld, one missing.  Operands: 276 of 276 upheld.**  Integration (what was done with it; the corrected pass is in `naming2_ramop8.md`):

* the family of the five `Tilemap_*` rows was narrowed to `wScreenTileMap`; the proof texts of the `Tilemap_CopyRectAndAttr*` and `CopyBytes` rows were corrected; the missing effect row `Gfx_WaitForFrameTop keeps` was added (+14 operands, 7 + 7); the reader's optional package was applied
  (`CopyBytesBackward` and `Tilemap_ApplyMaskRect`: +13 operands); 303 operands in all;
* the `DEF` comments of `wScreenTileMap` and `wScreenAttrMap`, the comments of the five uploaders in `home/gfx_upload.asm` and a comment at `frame_graphics.asm` were corrected as the reader listed;
* the tool got the reader's one-line fix of `a_before` (a one-operand `add` writes A) and its three tests (36 in all); the headers of the two rule files, the STYLE.md paragraph, the previous notes and `REVERSE_ENGINEERING.md` were brought up to date.

## 2. The reader's report

### 0. Verdicts

| item | UPHELD | CORRECTED | DROPPED |
|---|---|---|---|
| consumer rows (2 widened + 8 new = 10) | 5 | 5 | 0 |
| effect rows (8 new) | 8 | 0 | 0 |
| rewritten operands (276) | 276 | 0 | 0 |

* The 5 CORRECTED rows are the five `Tilemap_*` rows.  Only the `family` column is wrong (section 2); no operand changes.
* One effect row is missing: `Gfx_WaitForFrameTop keeps`.  It costs 14 sites (section 4).
* The tool has one latent false-accept class that does not occur in the tree (section 6).
* Two numbers in the brief are off.  `bank not shown` for `Gfx_StartHDMAWithService` is 117, not 118 (117+14+42+15 = 188).  The strata sizes are 19 `Tilemap_FillRectSequential` and 43 `Tilemap_FillAscendingWithAttr`, not 5 and 10.  All 276 sites were checked, not a sample.

### 1. Facts behind the two names

* **The layout is right.**  `home/gfx_upload.asm:96-253` (`Gfx_UploadBgMapBuffers*`, `Gfx_UploadWinMapBuffers*`) does the following:
  * It selects bank 7 first.
  * It runs `Gfx_StartHDMA` with HL=$D000 and E=0, then HL=$D400 and E=1.
  * D=$98 or $9C (LCDC bit 3 or 6) and E&1 goes to rVBK, so $D000 goes to the VRAM bank 0 map and $D400 to the VRAM bank 1 map (`00:0749` ff).
  * The buffers are 1024 bytes each with a row stride of $20 (`Tilemap_CopyRect` `00:0904`, the `and $1F` stride).
  * The attribute pass is always +$0400 (`00:08F2` ff, `00:16A2`, `48:4679`, `4F:45C6`).
* **Independent corroboration.**
  * `engine/browser/frame_style_chooser.asm:346-358` restores a snapshot cell by cell: `$D000+bc` from `sBrowserFramePreview` and `$D400+bc` from `+$400`.
  * `engine/browser/frame_graphics.asm:277` saves `$0800` bytes from `$D000`.
  * `CommScene_UploadBackgroundMap` (`70:4638`, `ld c,$40` = 64 blocks) sends all $400 of each buffer.
  * `Dialog_SaveBackground` (`dialog.asm:928-934`) uses rows 23-31 ($D2E0+$120 = $D400) as a save area.
  * `keyboard.asm` (10 sites) uses rows 18-30.
  * 109 of the 242 `Tilemap_*` sites are full 18x20 copies at offset 0, which supports "20x18 is the top left corner".
  * Nothing else uses bank 7 `$D000-$D7FF`.  The bank-7 text tile staging is `$DC00-$DFFF` (`hTextTiles_DestBank`=7 only with BC/DE=$DC00..).  The `$D000` operands seen under bank 7 for `TextTiles_*` are bank 2 pointers (`hTextTiles_DestBank`=2).
* **CONFIRMED is justified by execution.**
  * `00:082C` ran in 63/64 scenarios of `coverage_union.tsv` and in 41/41 bank-observed replays.  Bank is 7 only from `00:0833` on (mask 80).
  * `00:07CB` ran in 59/64 and 37/41.
  * `00:08EA` ran in 63/64 and `00:0904` in 63/64.  Both run under bank 7 only inside, in 41/41 replays.
  * `00:16A2` ran in 46/64 and 27 replays, `48:4679` in 49/64 and 30 replays, `4F:45C6` in 53/64 and 33 replays.  All run under bank 7 only inside.
  * `70:4638` ran in 13/64.
* **False or stronger than the code in the two DEF lines (`ram/banked.asm`):**
  1. "send it by HDMA" is stronger than the code.  `Gfx_UploadBgMapBuffers`, `...Di`, `...NoService` and `Gfx_UploadWinMapBuffers` use C=$24, which is 36 blocks = $240 bytes = 18 rows, not $400.  Only `CommScene_UploadBackgroundMap` sends all $400.  `docs/research/naming2_verify_g1_home.md:54` already said so.
  2. "(executed in 37 scenarios)" is the bank-observed count of `00:07CB` alone, copied from the generator comment at `gfx_upload.asm:101`.  `coverage_union` says 59 for `07CB` and 63 for `082C`.
  3. The evidence list cites two routines that have no caller and never ran: `Tilemap_ClearBuffers` `00:093B` and `Tilemap_CopyRectAndAttrSplitSrc` `00:08CA`.  `Gfx_UploadWinMapBuffersDi` `00:07FB` is also caller-less, but the DEF does not cite it.
  4. Minor: the code starts the DMA with HDMA5 bit 7 = 0, so it is general-purpose DMA.  The project calls the routine "HDMA".

### 2. Rules

**Consumer rows**

| row | verdict | note |
|---|---|---|
| `CopyBytes hl`, `CopyBytes de` (`00:050C`) | UPHELD | Writes no bank register and calls nothing.  Proof text still mentions only the palette buffer (cosmetic). |
| `FillBytes hl` (`00:04D8`) | UPHELD | Same. |
| `Gfx_StartHDMA`, `Gfx_StartHDMAWithService` (`needs=a`) | UPHELD | `ldh [hFarBank],a / call BankSwitch_H` (`00:0622`: `or a / ret z`).  For H>=$C0 it sets `hWRAMBank` and `rSVBK` to A, for $80-$BF the SRAM bank, for <$80 the ROM bank.  For a `$Dxxx` operand it is always WRAM.  `a_before` reads the right A: A at entry equals A before `call`, `jp`, or `farcall` (FarCall keeps it in `hFarCallA`, `00:06D1`). |
| `Tilemap_CopyRectAndAttr`, `...SplitSrc`, `...Ptr` (`de`) | CORRECTED, family only | See below. |
| `Tilemap_FillRectSequential` (`hl`) | CORRECTED, family only | Selects bank 7 itself via `wTilemapFill_WramBank` (WRAM0, `$07` stored at `48:467C`).  The ApplyMaskRect pass at HL+$0400 runs with A=0. |
| `Tilemap_FillAscendingWithAttr` (`hl`) | CORRECTED, family only | Selects bank 7 itself.  The attribute is stored at H+4. |

* **Family correction (the 5 `Tilemap_*` rows).**  `wScreen(Tile|Attr)Map` should be `wScreenTileMap`.  The second pass writes at +$0400, so a pointer in `wScreenAttrMap` would write into `wPaletteBufBg` ($D800).  A tool run showed `ld de,$D400` / `ld hl,$D400` would be named `wScreenAttrMap`.  No current site is affected: 242 `Tilemap_*` operands are all in the tile map.
* **`Tilemap_CopyRectAndAttrSplitSrc` is vacuous.**  It has no caller and no table word anywhere, and it never ran.  Its proof text "the same two copies" glosses over the second source being HL+$0400.
* **The `Tilemap_CopyRectAndAttr*` rows hold only for D>=$C0.**  `BankSwitch_D` (`00:063D`) picks the region from D: <$80 sets the ROM bank, $80-$BF the SRAM bank, >=$C0 the WRAM bank.  All 189 call sites of the family pass a DE in `$D000-$DFFF`: 180 as the rewritten operands, and 9 computed from a `$D000`-based sum (`help_menu.asm:463/537/610/736/810/883`, `mail_menu.asm:324/400`, `settings_menu.asm:360/366`).

**Effect rows**

* All 8 new rows are UPHELD:
  * `Tilemap_FillRectSequential` keeps: it saves the shadow at `tilemap_fill.asm:14` and restores it at `:52`.
  * `Tilemap_FillAscendingWithAttr` keeps: `tile_canvas.asm:78-118`.
  * `Tilemap_ClearBuffers`, `...NoService`, `Gfx_UploadWinMapBuffers` and `Gfx_UploadWinMapBuffersDi` all set W7.
  * `keeps if A=0` for `Gfx_StartHDMA` and `Gfx_StartHDMAWithService`: with A=0 every `BankSwitch_H` returns at once.  That covers the first call, the `.l077A` path (`00:077A-0785`) and the `.l07BB` path (`00:07BB-07C8`).
  * `hFarBank` is written only by `palette.asm:11` and the two HDMA routines.  No interrupt-context code writes it.
  * `Sound_FrameService` keeps the bank in the same shadow sense as in the previous pass.
* **Missing row:** `Gfx_WaitForFrameTop` (`00:08B7`) writes no bank register and calls nothing, but is not listed.  See section 4.

### 3. The 276 operands

Result: 276 UPHELD, 0 CORRECTED, 0 DROPPED.  That is 261 `wScreenTileMap` and 15 `wScreenAttrMap`, in 69 files.

| consumer | sites |
|---|---|
| `Tilemap_CopyRectAndAttr` | 163 |
| `Tilemap_FillAscendingWithAttr` | 43 |
| `Tilemap_FillRectSequential` | 19 |
| `Tilemap_CopyRectAndAttrPtr` | 17 |
| `CopyBytes` | 25 |
| `FillBytes` | 5 |
| `Gfx_StartHDMAWithService` | 4 |

* **The 15 `wScreenAttrMap`:**
  * `comm_scene.asm:888,922`, with HDMA to `$9800` via `xor a` and the idiom.
  * `dialog.asm:152,153,324,325,932,933,945,946,958,959,971,972`.
  * `gfx_upload.asm:379`.
* **Method.**  All 276 were re-derived with the reader's own parser: the consumer, the register not touched in between, and the bank.
  * 275 agree by mechanical scan.
  * `debug_flags.asm:136` agrees through `Sprite_InitSlot` and `Sprite_SetPosition`, which the table lists as `keeps`.
* **HDMA sites.**  All four destinations are maps: DE=$9800, or D=$98/$9C from LCDC bit 6.  Observed bank 7 only at load and call, in 6 replays.
* **Bank evidence.**  235 of the 276 consumer calls ran in the bank-observed replays.  Every `switch`/`a` site shows mask 80 at the call, and every `-` consumer shows mask 80 inside (section 1).  41 never ran in the replays and 27 never ran in the whole 64-scenario union.  Those are debug screens
  and rarely used screens: `debug_flags/error_screen_test/sound_test` FillBytes, `gfx_upload.asm:375,379`, `frame_graphics.asm:277`.  They rest on the idiom in the same routine (3 lines above `frame_graphics.asm:277`).
* **Geometry.**  All 242 `Tilemap_*` rectangles fit in 32x32 (`col+C <= 32`, `off+32*(B-1)+C <= $400`).  No attribute pass leaves `$D400-$D7FF`.  Oddities that are fine:
  * C=32 full-width rows: `start_choice.asm:102`, `help_menu.asm:144`, `mail_menu.asm:101`, `top_menu.asm:132`, `comm_scene.asm:807`, `send_receive.asm:1569`.
  * Rows beyond 18: `keyboard.asm` x10 (rows 18-30), `dialog.asm:65` and `:214`.
* **One naming caveat.**  `frame_graphics.asm:277` does `ld hl, wScreenTileMap` with `bc=$0800`, which reads both buffers through the first name.  A comment is suggested.

### 4. Left numeric

**The 188 `bank not shown`**

* 14 are bank 7, provable by reading, and missed (all `Gfx_StartHDMA` with `xor a`).  The idiom sits 8-12 lines up with one `call Gfx_WaitForFrameTop` between, and the scan gives up there.  The sites are `home/gfx_upload.asm:116,122,148,154,179,185,211,217,242,248` and `engine/dialog/dialog.asm:990,996,1018,1024`.
  * Adding `Gfx_WaitForFrameTop keeps` names exactly these 14 (7 `wScreenTileMap`, 7 `wScreenAttrMap`).  The tool applied on a copy gives SHA-256 OK and sym_check OK.
  * These are the routines that define the buffers, so they should read `ld hl, wScreenTileMap`.
* 8 more are bank 7 by control flow plus replays: `connect_dialog_screen.asm:540,546,865,871,1063,1069,1139,1145`, HDMA of rows to `$9C00`/`$9880`.
  * Missed because the bank comes back through a `pop af / ldh [hWRAMBank],a / ldh [rSVBK],a` pair, or through a label with several predecessors (all five entry paths of `Function_57_510F` pass `Tilemap_CopyRectAndAttr`).
  * Observed 80 only, in 4 replays.
  * These need a push/pop-pair or dominator extension, so they were left out of the mechanical proposals.
* 6 are bank 7 at `$DC00`, which has no name: HDMA at `menus.asm:447,917` and `dialog.asm:138,289,310`, plus FillBytes at `dialog.asm:261`.
* 160 were correctly left:
  * 5 have A=2 or A=3 explicit.
  * 68 HDMA plus 37 FillBytes show idiom bank 2 or 3.
  * 20 are observed in bank 2 (mask 04).
  * 11 `debug_*` sites are bank 3 by function-level idiom, beyond the 60-line window.
  * 3 are the boot wipes of banks 2-7: `home/init.asm:51`, `boot_stage2.asm:43,112`.
  * 13 `CopyBytes` are banks 1, 4 or 6, plus 1 observed bank 3 and `dev_test_config.asm:92` with no evidence.

**The 20 `no object`** (`$D880` x14, `$D900` x2, `$DC00` x4): bank 7 shown, no name exists.  Correctly numeric.

**`no rule` (1,295):** bank-7 screen-buffer pointers with no rule yet.  No consumer that selects bank 7 itself is left without a rule.

* `Tilemap_ApplyMaskRect` (6): `debug_flags.asm:138`, `error_screen_test.asm:127`, `sound_test.asm:136`, `comm_error_screen.asm:370`, `help_script.asm:705`, `mobile_dictionary.asm:376`.
  * It is the sixth `Tilemap_*` consumer of the 248 counted in `naming2_ramop7.md`.
  * It does not select bank 7.  It takes A like the HDMA routines.
  * The new `a` machinery names 5 of the 6.  `help_script.asm:705` stays, because `xor a` follows a `pop af` restore.
  * The sentence "all select bank 7 themselves" in `naming2_ramop7.md` is therefore not exact.
* `CopyBytesBackward` (8, `dialog.asm:521,522,525,526,579,580,583,584`): idiom 7 above, observed bank 7 only.
* `ConnectDialog_UploadMapRow` (6, `connect_dialog_screen.asm:524,529,534,849,854,859`): `switch` plus the pair problem.
* `Dialog_DrawButtonTiles` (`dialog.asm:445,448`, and `:469` which falls into the label): `switch`, observed bank 7 in 12 replays.
* `Kbd_TypeWaitsWithService` (4, `keyboard.asm:2196,2215,2254,2273`):
  * It is not the consumer.  It is a table lookup that preserves HL.
  * The consumer is the `Gfx_StartHDMA*` after `or a / jr z`, with A=0 on both branches and idiom 7 above.
  * The tool takes the helper as the consumer, so it falls into `no rule`.
* About 57 direct uses and base-register patterns with bank-7 evidence: `address_picker.asm:935-1382` (16), `help_menu.asm` x6 and `mail_menu.asm` x2 (`ld de,$D000 / add hl,de`), `frame_graphics.asm:382,392`, `frame_style_chooser.asm:346,354`, `connect_dialog_screen.asm:1035-1083`, `time_summary.asm`.
  * A few of the 57 are other banks: `$D524` bank 1, `far_string.asm:49` bank 5.

An optional rule package was validated on a copy: `CopyBytesBackward keeps` plus two `CopyBytesBackward switch` rows, `Tilemap_ApplyMaskRect keeps if A=0`, and an `a` row for `Tilemap_ApplyMaskRect`.  With the `Gfx_WaitForFrameTop` row that gives 27 operands, SHA-256 OK, sym_check OK, and 33 tests pass.

### 5. Other spellings of the buffers

Ordered by how much code reads them through the old names.

* **Neutral names `wRam_Dxxx` in bank 7.**  100 uses in 5 files (tile cell `wRam_D1A6` pairs with attr cell `wRam_D5A6`):
  * `tidy_screen.asm` 36
  * `menus.asm` 32 (lines 53-82, 506-535)
  * `connect_dialog_screen.asm` 20
  * `mail_session_screen.asm` 6
  * `delete_messages.asm` 6
  * Evidence is observed bank 7 only (50) or idiom 7 earlier in the function (50).
* **`dw` table** `engine/comm/notice_dialog.asm:480` (`Table_CommNotice_DigitCells`): 8 words `$D0A3,$D083,$D0E4,$D0C4` x2.  `CommNotice_DrawMinuteDigit` (`50:4352-4389`) reads them under bank 7 only (1 replay).
* **Bank-wide wipes** (`ld hl,$D000 / ld bc,$1000`, banks 2-7): `home/init.asm:51`, `engine/startup/boot_stage2.asm:43,112`.  Correctly numeric.
* **Not buffers:**
  * 61 `audio/engine.asm` uses of neutral names are bank 1.
  * `lib/mobile/mail.asm` uses are bank 6.
  * `html/tags.asm` and `browser/entry.asm` neutral names are bank 6.
  * `mail_viewer_sender.asm` `$D525/$D526` and `mailbox_screen.asm:1412-1459` are bank 1.
  * `audio/engine.asm:807 dw $D040...` is the sound driver.
* **No** `[$D1xx]` numeric operands and no `$D000 + expr` forms exist.  High-byte spellings (`ld a,$D0` and similar, 81 occurrences) are mostly Y or WY values.  The ones that build pointers are `ticker.asm:55` (bank 2), `help_script.asm:925` (bank 3) and `tile_canvas.asm:51,153` (banks 2/3), so they are not these buffers.

### 6. Tool and tests

* `python3 tools/test_ram_operands.py` passes: 33 tests OK.
* 56 synthetic cases (real rules) gave no crash and no false accept.  They cover: a call between the A write and the call; `ld a,$07` before another call; `ld a,[hl]`; `push af / pop af`; `ldh a,[..]`; `xor a` after `ld a,$07`; a jump or label; `call nz,`; a loop with variable A; a conditional A write before a `keeps if A=0` call; `farcall` and `jp` forms;
  CRLF, empty file, last line without newline; malformed rule rows exit 2.
* A property test ran 93,000 random programs, about 134,700 sites, 32,165 rewrites, with an abstract machine of A, real bank and stack.  It found 0 false accepts.  It detects all 5 mutants injected into the new logic.
* **Latent bug found (one-operand ALU form not seen as a write of A).**  `a_before` treats `add` as writing A only when ops[0]=='a'.  Repros, both rewritten when they should not be:
  * `ld hl,$D400 / ld a,$07 / add $01 / call Gfx_StartHDMA` -> `wScreenAttrMap`, but A = 8 (bank 1).
  * `[idiom 7] ld hl,$D400 / xor a / add b / call Gfx_StartHDMA`.
  * The tree has 0 occurrences of any one-operand ALU form, so no rewritten operand is wrong.
  * Fix: `(m == 'add' and not (ops and ops[0] in ('hl','sp')))`.
* **Test gaps.**  The author's 3 new tests kill only 2 of the reader's 5 mutants.  They miss: `pop af` ignored as a write of A; a non-immediate `ld a,X` skipped; a label ignored in `a_before`.  Three tests were added (36 in all, all pass with the fix; one fails on the unfixed tool).

### 7. Equivalence

* A clean `make` in the reader's copy gives `SHA-256 OK` and `RESULT: IDENTICAL`.  `make sym-check` is OK (15,001 labels).
* By script, the 276 changed lines are exactly the 276 `apply` rows of the decision table, with the same replacement in each.  Each is `ld hl|de|bc, $XXXX` replaced by `NAME[ + $HH]` of the same value, and the prefix and comment are unchanged.  Line counts are equal in all 69 files, and the other 5 changed files are the rule files, `ram/banked.asm`, the tool and its tests.
* `apply_banked_names.py --check`, `apply_overlay_aliases.py --check` and `apply_ram_operands.py --areas wram0,hram,io --check` all exit 0 with 0 errors.  `--areas wramx --check` and `--elements ... --observed --check` also exit 0.  `test_banked_names` (21), `test_overlay_aliases` (30) and `localize_labels`/`tidy_comments --check` pass.
* Re-running the code-identical tool on the pre-pass tree reproduces the author's 1,793-row table exactly.  A second run on the edited tree finds nothing (idempotent).

### 8. Claims in the tool docstring and STYLE.md

* **Tool docstring (4 claims):**
  * `needs = a` definition: true.
  * Rule for `a`: true.  The nearest `ld a,$NN` or `xor a` must equal the bank, and 0 uses the idiom.
  * `keeps if A=0` and the "unknown routine, conditional call, rst or macro ends the proof" wording: true.
  * `read_calls` and `a_before` docstrings: true, with the single-operand `add` caveat above.
* **STYLE.md** said nothing about this pass, but its Banked WRAM paragraph was incomplete: it listed only `-` and `switch`, and "keeping the bank" only.
* **Stale statements in `docs/research`.**  The row and test counts and the sentence "all select bank 7 themselves" of `naming2_ramop7.md`, the row count of `naming2_verify_ramop7.md`, and the count of numeric operands in `REVERSE_ENGINEERING.md`.
* **TSV headers.**  The header of `wramx_calls.tsv` did not describe `keeps if A=0`, and the one of `wramx_consumers.tsv` did not describe `a`.
* **`[ramop8]` tag.**  The `[ramop8]` tag in the DEF lines pointed to a note that did not exist yet.

### Limits of the reader's check

* Dynamic evidence is only the 41 bank-observed replays and the 64-scenario union.  The 27 call sites that never ran in the union are proven by reading only.
* All bank proofs, the reader's and the tool's, assume `hWRAMBank == rSVBK`.  The stale-shadow mechanism found in the previous pass (`Sound_FrameService` plus `Stat_ScrollSplitHandler`) can break that at run time.  It was not re-investigated.
* The property test models A, the real bank and the stack.  The effect rows are assumed, and were checked only by reading.
* The census of numeric high-byte `$D0..$D7` spellings is by pattern, not by data flow.
* No emulator was run.
* The no-rule population was not recounted beyond the groups named above.
