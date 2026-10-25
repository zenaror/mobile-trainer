# Joypad masks (pad1): 306 button tests written as `PADB_*` / `PADF_*` names (ROM unchanged)

## 3. The proof and the rules of the tool

`python3 tools/apply_pad_masks.py` rewrites a test only when the register A still holds one of the three variables: the scan starts at `ldh a, [hJoyHeld|hJoyPressed|hJoyPressedRepeat]`, keeps A across `bit`, conditional jumps and returns and `push af`, and stops at a label, a call, an unconditional jump, a write of A, a `; raw` line or any line it does not know.

It writes `bit n, a`, `and a, $NN`, the `cp a, $NN` or `xor a, $NN` after it only when an equality branch follows (`jr|jp|call|ret z|nz`: a `cp` followed by `jr c` is a magnitude compare, not a button set), and leaves `$FF` and `$00` numeric.

An already written `bit PADB_A, a` is transparent to the scan.

Byte checks on all 305 original chains (reader P1): each decodes as `F0 A4|A5|A6` of the named variable followed only by `bit n, a` and `jr cc` (the three `and $16` before the `cp` pairs are the only other instructions); no `push af`, `jp cc`, `ret cc` or call
inside a window; no `.sym` label inside a window; no numeric branch target, `Label + N` or numeric `dw` lands in a window.  A byte-level scan from the 254 heads finds 306 tests: the 305 plus `and a, $FF` at `2E:451A` (left numeric on purpose).

## 4. The hidden-mode combination (`$16` = B + Select + Right)

Three pairs `and a, PADF_B | PADF_SELECT | PADF_RIGHT` / `cp a, PADF_B | PADF_SELECT | PADF_RIGHT` test **all three held** in `hJoyHeld` (every other button is ignored, so the A that dismisses the page or confirms a menu entry may be held too):

* `engine/startup/registration.asm` `Registration_IntroPage` (`65:42B3-42B9`): when the first notice page is left, the hold sets `wHiddenModeFlag := 1` and enters `Registration_NoticePages_Hidden` (`65:42BB`).  61 executions of the test in 10 scenarios; the success path ran twice, in   `register_hidden` and `register_hidden_manual` (the script holds the three buttons at frame 415 of both).

* The same test on the back path of the second page (`65:42D3-42D9`): 25 executions in 2 scenarios, never equal: PROBABLE.

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

```
python3 tools/apply_pad_masks.py --check     # exit 0: nothing left to write
python3 tools/apply_pad_masks.py --dry-run   # what a run would write
python3 tools/test_pad_masks.py              # 22 tests
```

Limits: the dynamic evidence is emulated (mGBA fork, CGB model), not real hardware; 94 sites have no button-identity evidence from the traces, only the chain proof plus the global layout; what each button does in the interface was not checked, only that the bit name is right.
