# Independent verification of the joypad mask pass (pad1)

> Status: **reference (current)**.  One reader with a fresh context (P1) checked the pass: all 305 rewrites of the first version (not a sample), the bit order, the executed evidence, the hidden-mode combination, counterexamples against the tool and what stays numeric.  It worked in private copies and handed back
> text and two patches, both integrated (the corrected tool and tests, the header and comment fixes, one more rule).  What the tree contains is the result after the corrections: [`naming2_pad1.md`](naming2_pad1.md).

## 1. Verdicts

| item | verdict |
|---|---|
| the 305 rewrites | **UPHELD 305, CORRECTED 0, DROPPED 0**: every chain decoded from the ROM bytes (`F0 A4|A5|A6`, then only `bit n, a` and `jr cc`; no `push af`, `jp cc`, `ret cc`, call or label inside a window); 136 sites also checked frame by frame against the traces |
| the names | each new name equals its old number under the reader's own table (305 of 305); the 18 constants are right; the three variable names are true at all 254 reads (58 / 95 / 101), with the caveat of the five injections into `hJoyPressed` (`naming2_pad1.md` section 2) |
| the tool | build identical, `sym_check` OK, no false rewrite on the tree; five latent defects found (section 3) |
| one more rule (`xor a, $NN` before an equality branch) | proposed by the reader, integrated: it names `engine/main/navigation.asm` (`PADF_SELECT \| PADF_LEFT`, `7C:7D08`, run 89 times in 15 scenarios; the equal path ran in `mail_server_hidden`, `mail_server_hidden2` and `time_warnings` with Select + Left held) |

## 2. Answers of the reader to the questions of the brief

1. **Layout**: confirmed three ways (ROM bytes of the polling routine, each key alone in the emulator, the dispatcher re-derived from the 22 `call JoypadDispatch` sites).  Documentation errors it found, fixed in this commit: `ram/wram.asm` said the repeat counters are "in bit order from bit 0" (they are reversed: counter i = bit
   7-i), and `ram/hram.asm` said "bits 0-3" for `hJoyPressed` and omitted the five injections.
2. **The 305 rewrites** in natural traces: the pressed path ran in at least one scenario at 206 sites and in every such scenario the script presses the named button(s) (0 contradictions); frame-level at 136 sites (982 checks): single-button sites with evidence B 50, A 45, Left 11, Right 10, Down 7, Up 6, Select 4, Start 1.
   94 sites have no button-identity evidence (57 ran but were never pressed, 37 are in never-executed code: 32 in PROBABLE blocks, 1 in a HYPOTHESIS block at `engine/gfx/unreferenced_palette_library.asm`, 4 with no nearby tag).  Rare classes, all upheld: `$16` 3 + 3, `$C0` 6, `$F0` 18, `$04` 2, Select bit tests 2, Start bit
   tests 4, non-first tests in a chain 66 (63 `bit` + 3 `cp`).
3. **`$16`**: B + Select + Right is the hidden-mode combination (`naming2_pad1.md` section 4); the counts, the scenarios that executed the success paths and the frames at which the scripts hold the buttons were re-derived; the brief was imprecise about `monkey_camp_reg2`, which never holds the combination.
4. **Counterexamples against the tool**: a label not in column 0, upper case, a space indent, `bit n, b`, a conditional call, `dec a` / `swap a`, `; raw` lines, CRLF, `data/` all stop the scan or are left numeric (safe).  The only real faults are the defects below.
5. **What stays numeric**: 15 of the 254 reads get no name (list in `naming2_pad1.md` section 5); the only one nameable with the same local proof was `navigation.asm` `xor a, $24` (now done); 30 + 10 more need an interprocedural or register-copy proof.
6. **Naming**: `PADF_*` / `PADB_*` have exactly the names and values of the community `hardware.inc`; `PADF_DPAD` (18 uses) and `PADF_BUTTONS` (0 uses) are project-local, and `PADF_START` has 0 uses.  The header of `constants/hardware.inc` ("every value is a hardware fact") was corrected to name the exception, and the two composites are
   derived from the single flags.

## 3. Defects found in `tools/apply_pad_masks.py` (all latent: none changed the tree) and what was done

| defect | fix |
|---|---|
| the `cp` extension never looked at the branch after the `cp`: `[ldh a,[hJoyPressed] / and a,$0F / cp a,$04 / jr c,.x]` gave `cp a, PADF_SELECT`, a magnitude compare shown as a button set (the 3 real `cp` are all `jr nz`) | `cp` / `xor` are written only before `jr|jp|call|ret z|nz` |
| `BIT` accepted digits only, so an already written `bit PADB_A, a` stopped the scan; a half-edited chain kept a numeric test and `--check` exited 0 | a written `bit PADB_*, a` is transparent |
| file handles were not closed (`ResourceWarning`); a dead label test (equivalent mutant) | closed; the dead test stays harmless |
| a branch to a raw address or `Label + N` inside a window is not detected | by design; none exists in the tree (checked) |
| 38 mutants of the tool against the 12 tests: 23 killed, 15 alive (2 equivalent, 13 real gaps: a conditional `call` let through, `bit N, b` accepted, `hRam_FFA7` added as a joypad variable, a `cp` accepted on partial overlap, `push af` / `jp cc` / `jr c|nc` never exercised between tests, `cp` not found across a blank line, `--check`
  exit code and `home/` skipped untested; a PADB-only swap of bits 5 / 6 is caught by the build only) | 22 tests now (a literal bit table anchored to `constants/hardware.inc`, CRLF / `main` / `--check`, the dangerous mutants); the reader's 21 tests kill 41 of 43 mutants, the two survivors are the equivalent ones; none of the mutants changes the output on the real tree |

## 4. Limits

The dynamic evidence is emulated (mGBA fork, CGB model), not real hardware; 94 sites have no button-identity evidence from the traces, only the chain proof and the global layout; the reader did not check what each button does in the interface, only that the bit name is right; jumps built from raw `db` bytes or register arithmetic cannot be excluded by its
method (the windows hold no label); the reader's trace snapshot was the 64-scenario state (the union now has 69).  `tools/test_mapper.py` (a test of the frozen bootstrap pipeline, not part of `make test`) fails three tests on the tree before and after this pass: it is unrelated (section 5 of `REVERSE_ENGINEERING.md`).
The scripts of the reader (ROM byte checks, dynamic checks, mutation runs, the emulator probe) live in a private scratch directory and are not part of the repository.
