# Tile staging windows, account work area, dialog tile stage and palette fade buffers (ramop9): independent reference

### 0. Verdicts

| item | UPHELD | CORRECTED | DROPPED |
|---|---|---|---|
| names (17) | 16 | 1 (`wDialogTileStage` text) | 0 |
| consumer rules (83 rows; 67 new or widened) | 65 | 2 (`FillBytes hl` family; `TextTiles_HdmaBlock` proof) | 0 |
| effect rows (43 new) | 42 | 1 (`TextTiles_HdmaBlock` proof) | 0 |
| operands (675 = 597 tool + 78 manual) | 674 | 1 (`engine/settings/phone_number_entry.asm:292`) | 0 |
| 14 rows left numeric | 14 right to leave | | |

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

### 3. The 138 `(direct)` rewrites

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
