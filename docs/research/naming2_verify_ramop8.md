# The two screen buffers of WRAM bank 7 (ramop8): independent reference of the first version

### 2. Rules

| row | verdict | note |
|---|---|---|
| `CopyBytes hl`, `CopyBytes de` (`00:050C`) | UPHELD | Writes no bank register and calls nothing.  Proof text still mentions only the palette buffer (cosmetic). |
| `FillBytes hl` (`00:04D8`) | UPHELD | Same. |
| `Gfx_StartHDMA`, `Gfx_StartHDMAWithService` (`needs=a`) | UPHELD | `ldh [hFarBank],a / call BankSwitch_H` (`00:0622`: `or a / ret z`).  For H>=$C0 it sets `hWRAMBank` and `rSVBK` to A, for $80-$BF the SRAM bank, for <$80 the ROM bank.  For a `$Dxxx` operand it is always WRAM.  `a_before` reads the right A: A at entry equals A before `call`, `jp`, or `farcall` (FarCall keeps it in `hFarCallA`, `00:06D1`). |
| `Tilemap_CopyRectAndAttr`, `...SplitSrc`, `...Ptr` (`de`) | CORRECTED, family only | See below. |
| `Tilemap_FillRectSequential` (`hl`) | CORRECTED, family only | Selects bank 7 itself via `wTilemapFill_WramBank` (WRAM0, `$07` stored at `48:467C`).  The ApplyMaskRect pass at HL+$0400 runs with A=0. |
| `Tilemap_FillAscendingWithAttr` (`hl`) | CORRECTED, family only | Selects bank 7 itself.  The attribute is stored at H+4. |

### 3. The 276 operands

| consumer | sites |
|---|---|
| `Tilemap_CopyRectAndAttr` | 163 |
| `Tilemap_FillAscendingWithAttr` | 43 |
| `Tilemap_FillRectSequential` | 19 |
| `Tilemap_CopyRectAndAttrPtr` | 17 |
| `CopyBytes` | 25 |
| `FillBytes` | 5 |
| `Gfx_StartHDMAWithService` | 4 |

### 4. Left numeric

* 14 are bank 7, provable by reading, and missed (all `Gfx_StartHDMA` with `xor a`).

* 8 more are bank 7 by control flow plus replays: `connect_dialog_screen.asm:540,546,865,871,1063,1069,1139,1145`, HDMA of rows to `$9C00`/`$9880`.

* Missed because the bank comes back through a `pop af / ldh [hWRAMBank],a / ldh [rSVBK],a` pair, or through a label with several predecessors (all five entry paths of `Function_57_510F` pass `Tilemap_CopyRectAndAttr`).

* 6 are bank 7 at `$DC00`, which has no name: HDMA at `menus.asm:447,917` and `dialog.asm:138,289,310`, plus FillBytes at `dialog.asm:261`.

* 68 HDMA plus 37 FillBytes show idiom bank 2 or 3.

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

### 5. Other spellings of the buffers

Ordered by how much code reads them through the old names.

* **Neutral names `wRam_Dxxx` in bank 7.**  100 uses in 5 files (tile cell `wRam_D1A6` pairs with attr cell `wRam_D5A6`):   * `tidy_screen.asm` 36   * `menus.asm` 32 (lines 53-82, 506-535)   * `connect_dialog_screen.asm` 20   * `mail_session_screen.asm` 6   * `delete_messages.asm` 6   * Evidence is observed bank 7 only (50) or idiom 7 earlier in the function (50).

* **`dw` table** `engine/comm/notice_dialog.asm:480` (`Table_CommNotice_DigitCells`): 8 words `$D0A3,$D083,$D0E4,$D0C4` x2.

* **Bank-wide wipes** (`ld hl,$D000 / ld bc,$1000`, banks 2-7): `home/init.asm:51`, `engine/startup/boot_stage2.asm:43,112`.

* **Not buffers:**   * 61 `audio/engine.asm` uses of neutral names are bank 1.

* `lib/mobile/mail.asm` uses are bank 6.

* `mail_viewer_sender.asm` `$D525/$D526` and `mailbox_screen.asm:1412-1459` are bank 1.

High-byte spellings (`ld a,$D0` and similar, 81 occurrences) are mostly Y or WY values.

The ones that build pointers are `ticker.asm:55` (bank 2), `help_script.asm:925` (bank 3) and `tile_canvas.asm:51,153` (banks 2/3), so they are not these buffers.

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

### 8. Claims in the tool docstring and STYLE.md

* **Stale statements in `docs/research`.**  The row and test counts and the sentence "all select bank 7 themselves" of `naming2_ramop7.md`, the row count of `naming2_verify_ramop7.md`, and the count of numeric operands in `REVERSE_ENGINEERING.md`.

* **TSV headers.**  The header of `wramx_calls.tsv` did not describe `keeps if A=0`, and the one of `wramx_consumers.tsv` did not describe `a`.
