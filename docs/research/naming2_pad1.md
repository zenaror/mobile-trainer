# Joypad masks (pad1): 306 button tests written as `PADB_*` / `PADF_*` names (ROM unchanged)

> Status: **reference (current)**.  The three joypad variables `hJoyHeld`, `hJoyPressed` and `hJoyPressedRepeat` hold one bit per button; the code tested them with bare numbers (`bit 4, a`, `and a, $F0`, `cp a, $16`).  The tests that follow a read of one of
> the three variables are now written with the names of `constants/hardware.inc` (`PADB_A` ... `PADB_DOWN`, `PADF_A` ... `PADF_DOWN`, `PADF_DPAD`).  The proof is local and byte-checked (section 3); the bit order is confirmed three ways (section 2).
> Records: `constants/hardware.inc` (the constants), `tools/apply_pad_masks.py` (22 tests in `tools/test_pad_masks.py`); independent verification: [`naming2_verify_pad1.md`](naming2_verify_pad1.md).

## 1. Result

| item | count |
|---|---|
| tests written as names | **306** in 61 files: 105 `bit PADB_n, a`, 197 `and a, PADF_...` (3 of them the first half of a `$16` pair), 3 `cp a, PADF_B \| PADF_SELECT \| PADF_RIGHT` and 1 `xor a, PADF_SELECT \| PADF_LEFT` (`engine/main/navigation.asm`) |
| constants used | `PADB_A` 30, `PADB_B` 27, `PADB_RIGHT` 15, `PADB_LEFT` 15, `PADB_UP` 6, `PADB_DOWN` 6, `PADB_START` 4, `PADB_SELECT` 2; `PADF_B` 78, `PADF_A` 46, `PADF_RIGHT` 21, `PADF_DPAD` 18, `PADF_DOWN` 16, `PADF_LEFT` 16, `PADF_UP` 16, `PADF_SELECT` 9 (`PADF_START` and `PADF_BUTTONS` are defined and unused) |
| reads of the three variables | 254 (58 `hJoyHeld`, 95 `hJoyPressed`, 101 `hJoyPressedRepeat`); 239 of them head a chain of tests; 15 get no name (section 5) |
| executed | the "pressed" path of 206 sites ran in at least one natural scenario; at 136 sites the first execution of each scenario was checked frame by frame against the button script (982 checks, 0 contradictions); 94 sites have no button-identity evidence from the traces (57 ran but were never pressed, 37 are in code that never ran) |
| ROM | byte-identical (`make compare`: `RESULT: IDENTICAL`; every audit passes) |

## 2. The bit order (CONFIRMED, three independent ways)

`1 = pressed`, in all three variables: bit 0 A, 1 B, 2 Select, 3 Start, 4 Right, 5 Left, 6 Up, 7 Down.  This is the ROM's own layout (the buttons nibble of `rP1` in bits 3-0, the directions nibble in bits 7-4), the same order as the community `hardware.inc`; it is **not** the layout of `rP1`.

* ROM bytes, the polling routine `7D:7B7C-7BED` (`engine/input/joypad.asm`): `rP1 = $20` selects the directions (two reads, `and $0F`, `swap`: Right, Left, Up, Down in bits 4-7); `rP1 = $10` selects the buttons (six reads, `and $0F`, `or b`, `xor $FF`:
  A, B, Select, Start in bits 0-3); held = new (`7D:7BCB`), pressed = (old xor new) and new (`7BC4-7BC8`), repeat = pressed or E (`7BEA-7BED`) where E is built by the loop `7BD4-7BE8` (`rl b` most significant bit first, so bit n of E is counter 7-n and E is a subset of held).
* The emulator (a private probe linked to the mGBA fork of the harness, ROM unmodified): each key alone on the no-adapter screen gives `$01` A, `$02` B, `$04` Select, `$08` Start, `$10` Right, `$20` Left, `$40` Up, `$80` Down in all three variables; B + Select + Right gives `$16`, Select + Left `$24`.
* The dispatcher `00:056A` (`home/jump_table.asm`), re-derived from the 22 `call JoypadDispatch` sites with their inline words read from the ROM: the handler of word 0 / 1 / 2 / 3 ran in 275 / 120 / 106 / 106 (site, scenario) pairs only in scenarios whose script presses A / B / Select / Start (0
  contradictions; 517 of 517 first-frame checks).

Corrections that came with it (`ram/wram.asm`, `ram/hram.asm`): the eight repeat counters `wJoyRepeatCounters` are in **reverse** order (counter i = bit 7-i: `C2E5` Down ... `C2EC` A; `Joypad_ClearAndResetRepeat` reloads only `C2E5-C2E8`, the D-pad), and `hJoyPressed` is not only "newly pressed" (next paragraph).

Writers of the three variables: the poll (`7D:7BC8`, `7BCB`, `7BED`); the clears (`Joypad_Init` `7D:7BF0`, `Joypad_ClearAndResetRepeat` `2D:70F4`, the boot `FillBytes` at `4F:4738` and `4F:47AF`, seven `xor a / ldh [hJoyPressed], a` sites); and **five injections into
`hJoyPressed`**: `$80` (a Down press) at `2C:59C0`, `2F:427C`, `2F:42C4`, `2F:462C` and `$40` (an Up press) at `2A:418B` (`address_picker.asm`, `list.asm` x3, `save_sender_address.asm`; executed 12 / 1 / 1 / 40 / 19 times in 7 / 1 / 1 / 10 / 6
scenarios).  Each precedes a call to a routine that ends in `and a, PADF_UP | PADF_DOWN / call nz`, so the names stay true (the same layout), but "newly pressed" is not the whole truth for `hJoyPressed`.  `hRam_FFA7` is only OR-ed into the value by the dispatcher.

## 3. The proof and the rules of the tool

`python3 tools/apply_pad_masks.py` rewrites a test only when the register A still holds one of the three variables: the scan starts at `ldh a, [hJoyHeld|hJoyPressed|hJoyPressedRepeat]`, keeps A across `bit`, conditional jumps and returns and `push af`, and
stops at a label, a call, an unconditional jump, a write of A, a `; raw` line or any line it does not know.  It writes `bit n, a`, `and a, $NN`, the `cp a, $NN` or `xor a, $NN` after it only when an equality branch follows (`jr|jp|call|ret z|nz`: a `cp` followed by `jr c` is a magnitude
compare, not a button set), and leaves `$FF` and `$00` numeric.  An already written `bit PADB_A, a` is transparent to the scan.  It builds, compares the SHA-256, runs `sym_check`, restores every file on failure, and is idempotent (`--check`, `--dry-run`).

Byte checks on all 305 original chains (reader P1): each decodes as `F0 A4|A5|A6` of the named variable followed only by `bit n, a` and `jr cc` (the three `and $16` before the `cp` pairs are the only other instructions); no `push af`, `jp cc`, `ret cc` or call
inside a window; no `.sym` label inside a window; no numeric branch target, `Label + N` or numeric `dw` lands in a window.  A byte-level scan from the 254 heads finds 306 tests: the 305 plus `and a, $FF` at `2E:451A` (left numeric on purpose).

## 4. The hidden-mode combination (`$16` = B + Select + Right)

Three pairs `and a, PADF_B | PADF_SELECT | PADF_RIGHT` / `cp a, PADF_B | PADF_SELECT | PADF_RIGHT` test **all three held** in `hJoyHeld` (every other button is ignored, so the A that dismisses the page or confirms a menu entry may be held too):

* `engine/startup/registration.asm` `Registration_IntroPage` (`65:42B3-42B9`): when the first notice page is left, the hold sets `wHiddenModeFlag := 1` and enters `Registration_NoticePages_Hidden` (`65:42BB`).  61 executions of the test in 10 scenarios; the success path ran twice, in
  `register_hidden` and `register_hidden_manual` (the script holds the three buttons at frame 415 of both).
* The same test on the back path of the second page (`65:42D3-42D9`): 25 executions in 2 scenarios, never equal: PROBABLE.
* `engine/account/settings_menu.asm` (`68:4FC0-4FC6`): at the entry of the Mobile Settings menu the hold stores the flag in SRAM (`Settings_SetHiddenModeFlag`, then `Settings_UpdateChecksumAndBackup`).  538 executions in 15 scenarios; the success path (`68:4FC8`) ran 4 times
  in `settings_phone` (frame 1176) and `fuzz_register` (frame 1652; only B + Select + Right was held there, so A is indeed ignored).

The script of `monkey_camp_reg2` never holds the combination (it only starts from `register_hidden`); the count of scripted holds (1 / 1 / 3 / 1) equals the count of times the equal path ran.

## 5. What stays numeric

* 15 of the 254 reads get no name: three joypad-driver lines (`or a, a`, `or a, e`, `xor a, b` in `engine/input/joypad.asm`), the dispatcher's `or a, l`, `connect_dialog.asm` (`or a, a / ret z / ld b, a`), three hold-timer `cp a, b` with a store to WRAM (`debug_flags.asm`,
  `error_screen_test.asm`, `sound_test.asm`), two reads whose A is passed to a callee (`error_screen_test.asm`, `sound_test.asm`), two `call nz, Stub_Nop_*` that are never taken (`page_list.asm`, `page_list_prototype.asm`), `body_editor.asm` (`cp $00 / ret z / ret`), `tidy.asm` (`and $FF`).
* **Nameable only with an interprocedural or register-copy proof** (a possible follow-up): 30 `bit 4-7` tests in eight `*_HandleDpad` routines that each have exactly one caller (`BrowserStart` `73:6180`, `DebugFlags` `19:4333`, `HelpMenu` `6C:429F`, `MobileDict` `1A:41E5`,
  `MailMenu` `1D:4229`, `TopMenu` `1F:4291`, `DebugErrorTest` `19:4B4A`, `SoundTest` `1B:4261`: Up / Down / Right / Left = bits 6 / 7 / 4 / 5 of the value they receive), and 10 `bit 4 / 5, b` tests in `connect_dialog.asm` where B is a copy of the variable made near the top of the routine.
  The four dispatcher tests `bit 0-3, a` after `or a, l` stay numeric because `hRam_FFA7` is unproven.
* The five `ld a, $80|$40 / ldh [hJoyPressed], a` stores are writes, not tests.  `cp` of a single-button value: 0 sites; `$0F`: 0 sites; `cpl`: 0.

## 6. Defects found by the reader and closed

`cp` extended without looking at the branch after it (a `cp a, $04 / jr c` would have become a button name); a written `bit PADB_A, a` stopped the scan, leaving a half-edited chain that `--check` accepted; file handles were not closed; 38 mutants of the tool against the 12 tests of the first version
left 15 alive (13 real gaps: a conditional call let through, `bit n, b` accepted, `hRam_FFA7` added as a joypad variable, a `cp` accepted on partial overlap).  The tool and its tests (now 22) are the corrected versions; the 21 tests of the reader kill 41 of 43 mutants (the two survivors are equivalent).  A branch to a raw
address or `Label + N` inside a window is not detected by design; none exists in the tree.

## 7. Reproduce

```
python3 tools/apply_pad_masks.py --check     # exit 0: nothing left to write
python3 tools/apply_pad_masks.py --dry-run   # what a run would write
python3 tools/test_pad_masks.py              # 22 tests
```

Limits: the dynamic evidence is emulated (mGBA fork, CGB model), not real hardware; 94 sites have no button-identity evidence from the traces, only the chain proof plus the global layout; what each button does in the interface was not checked, only that the bit name is right.
