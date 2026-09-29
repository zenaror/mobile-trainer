# Ghidra + GhidraBoy evaluation for Mobile Trainer (Japan)

Status of this document: written by the Ghidra-evaluation task. Evidence vocabulary as in the project rules
(CONFIRMED / PROBABLE / HYPOTHESIS). Addresses are `bank:addr` CPU addresses. Everything Ghidra itself
outputs is a HYPOTHESIS source only (see "Trust rules").

## 1. Verdict (short)

* CONFIRMED: an SM83 language for Ghidra 12.1.3 is available (GhidraBoy, built locally, no GUI steps) and
  a fully scripted, isolated, reproducible headless pipeline works: `tools/ghidra/setup.sh` then
  `tools/ghidra/import.sh` (about 30 s) then optionally `tools/ghidra/decompile_function.sh <bank:addr>` (about 5 s).
* PROBABLE (downgraded by the verifier from CONFIRMED): for **finding code, classifying code/data, tracking banks and naming**,
  Ghidra adds nothing over `tools/sm83.py` + `tools/cfg.py`. CONFIRMED part: with the same seeds it reaches exactly the same
  bytes as `cfg.py` (section 6, re-run by the verifier: ROM0 735 when cfg.py is also seeded at the eight rst slots, 6B 155, 4F 142)
  and it cannot follow this ROM's main far-call mechanism (section 5); `cfg.py --inline` can. The universal 'adds nothing' is a
  judgement: only recursive descent from seeds was compared; Ghidra's other analyzers (data-reference, scalar/operand analysis,
  'Undefined code' search) were not evaluated.
* CONFIRMED: Ghidra is useful as (a) a **decompiler view of an individual routine** (section 7 has two real
  outputs), (b) an independent **cross-check of the SM83 opcode table** (510 of 511 opcode rows agree with
  `sm83.py` on length, flow and operand text; the one difference is STOP), (c) HYPOTHESIS: an interactive xref/data-type
  browser if someone opens the project in the GUI (not tested here: headless only).
* It must never be the source of truth for the rebuildable source tree. Never copy Ghidra function
  names, sizes or boundaries into `config/` without verifying the bytes.

## 2. What was installed and what is missing

Ghidra: `/home/rafael/Tools/Open-GBP/ghidra_12.1.3_PUBLIC` (application.version 12.1.3, PUBLIC, build 2026-Aug-17,
git revision 8b4c91d4d5bd1549622bfbade0df199585b98365, requires Java 21; java 21.0.12.1 present).

* CONFIRMED: no SM83 / Game Boy language is bundled. `Ghidra/Processors/Z80/data/languages/z80.ldefs` defines
  only `z80:LE:16:default`, `z8401x:LE:16:default`, `z180:LE:16:default`, `z182:LE:16:default`; no `.ldefs`
  under `Ghidra/Processors/*/data/languages/` mentions sm83, gameboy or lr35902. `Extensions/Ghidra/` holds only
  stock extensions (BSim, Jython, Lisa, sample, ...) and `Ghidra/Extensions/GameCubeLoader` is an unrelated third-party extension.
* CONFIRMED (verifier ran it: `GbOpcodeDump.java` on a `BinaryLoader` + `z80:LE:16:default` program, compared with `check_language.py`:
  34 of 511 opcode rows differ from `sm83.py`, 20 of them in instruction length, e.g. E0 = `RET PO` (1 byte) vs `ldh [n],a`, D9 = `EXX`
  vs `reti`, CB30 = `SLL B` vs `swap b`): Z80 is not usable for this ROM as-is. SM83 removes IX/IY, the shadow registers and I/O ports and
  reuses opcodes (08, 10, D9, E0, E2, E8, EA, F0, F2, F8, FA, and the whole CB page has SWAP at CB30-37 where the
  Z80 has SLL). `tools/ghidra/check_language.sh` compares the SM83 language with `sm83.py` (section 6).

GhidraBoy (SM83 language + Game Boy loader + bank-switch analyzer):

| item | value |
|---|---|
| upstream | https://github.com/Gekkio/GhidraBoy (README lists Ghidra 11.1 to 11.4.2; no 12.x release) |
| used | fork https://github.com/kabili207/GhidraBoy, branch `main` (identical to branch `bank-analyzer-and-ram-layout`) |
| pinned commit | `cc9f5652c57f9c429a0d961a34fa836e98e20d7d` (2026-08-11, "Fix bank tracking and resolve far calls through helpers") |
| GitHub releases / tags | none exist on the fork |
| sha256 of `git archive --format=tar` of that commit | `03c1821bd3573ce649950fad3c5beae6387c58678e3346c664e18c9337a1f1bd` |
| sha256 of built `sm83.sla` | `333b44d0c6f11f2409e96db6312996b815aaa0fd9d26bf6bc3a70734ec11953e` |
| sha256 of built `GhidraBoy.jar` | `e66aa44d5b0141f42cda1403bc8d13aea6e3c330ff001c619e74d69bf6ee3438` (jar entries dated 2000-01-01, rebuilds are byte-identical) |
| license | Apache-2.0 |

The authoritative record of what a given checkout built is `.cache/ghidra-setup.json` (written by setup.sh).
The fork adds over upstream (from its commit log): the bank-switching analyzer (`GameBoyBankSwitchAnalyzer`),
MBC detection, CGB WRAM/VRAM bank 0/1 as normal blocks, interrupt-vector entry seeding.

Compatibility with Ghidra 12.1.3 (CONFIRMED by doing it, no source patch needed):

* `extension.properties` is generated at build time with `version=<Ghidra application.version>`; setup.sh writes
  `version=12.1.3`. There is no hard-coded version list in the code; the README list is only what upstream tested.
* The Java sources (`fi.gekkio.ghidraboy.*`, 8 files) compile with `javac --release 17` against the 12.1.3 jars.
* `sm83.slaspec` compiles with 12.1.3's `SleighCompile` (1 warning: "NOP constructor" at `sm83_instructions.sinc:456`).
* Ghidra's class searcher finds `fi.gekkio.ghidraboy.GameBoyLoader`; the analyzer runs ("Game Boy bank switching" in
  the analysis timings); the loader imports `baserom.gbc` as `SM83:LE:16:default`.
* Upstream's own gradle build also works: `./gradlew -Pghidra.dir=<install> assemble` (gradle 9.0.0, Kotlin 2.2.10,
  ktlint from the network) produced `ghidra_12.1.3_PUBLIC_<date>_GhidraBoy.zip` and an `sm83.sla` with the same sha256 as
  ours. Its `test` task crashed (Gradle "Test Executor" exit value 255, so the upstream
  unit tests, including the emulator-based instruction tests, are UNVERIFIED on 12.1.3). Cause found by the verifier in
  `~/.config/ghidra/ghidra_12.1.3_PUBLIC/application.log` (13:49:42): the test JVM dies while initialising Ghidra
  (`fi.gekkio.ghidraboy.GhidraApplication.initialize` -> `HeadlessGhidraApplicationConfiguration.initializeApplication` ->
  `GhidraSerialFilterFactory.getOrInstallInstance`): `IllegalStateException: Cannot replace filter factory:
  java.io.ObjectInputFilter$Config$BuiltinFilterFactory`. That is a test-harness/JDK-serial-filter initialisation failure, not a
  sleigh or loader failure. Whether it is specific to Ghidra 12.1.3 was not tested (no other Ghidra version tried). This is why setup.sh does not use gradle: gradle+Kotlin+ktlint downloads
  are only needed for tests/lint; the runtime artifact is javac output + compiled sleigh.

## 3. Setup and use

(Verifier re-ran everything from scratch: deleted `.cache/GhidraBoy`, `.cache/ghidraboy-build`, `.cache/ghidra-user*`, `.cache/ghidra-setup.json` and
`tools/ghidra/project`, then `setup.sh` (4.7 s incl. clone) and `import.sh` (35 s). Hashes in `.cache/ghidra-setup.json` and all four
`analysis/ghidra_*` exports were byte-identical to the first run. CONFIRMED. `import.sh` was also fixed to fail loudly: the original
swallowed every error with `|| true` and printed the project path with exit code 0; it now deletes stale exports first and dies if
they are not rewritten.)

```
tools/ghidra/setup.sh              # clone pinned commit into .cache/GhidraBoy, sleigh-compile, javac, install (idempotent, ~5 s once cloned)
tools/ghidra/setup.sh --force      # rebuild
tools/ghidra/import.sh             # new project tools/ghidra/project/MobileTrainer + analysis + exports (~30 s)
tools/ghidra/import.sh --regions   # also seed/clear from config/regions/bankNN.tsv (see below)
tools/ghidra/decompile_function.sh 00:06D1     # C for one function; 6B:4C80 for banked code
tools/ghidra/check_language.sh     # SM83 language vs tools/sm83.py, all opcodes
```

Environment: `GHIDRA_INSTALL_DIR` (default: the Open-GBP install above), `GHIDRA_MAXMEM` (default 4G), `JAVA_HOME`.
Needs a JDK (javac + jar), git, network only for the first clone.

Isolation (CONFIRMED): `tools/ghidra/env.sh` starts the JVM directly, with the same command line as
`support/launch.sh` but `-Dapplication.settingsdir/cachedir/tempdir` pointing into `.cache/`. It never runs
`launch.sh`/`ghidraRun` (which would rewrite `~/.config/ghidra/.../java_home.save`). Ghidra appends a per-user
sub-directory, so the real settings dir is `.cache/ghidra-user/<user>-ghidra/ghidra_12.1.3_PUBLIC/` and the
extension lives in its `Extensions/GhidraBoy/`. Nothing is installed into the Ghidra install dir. Disclosure (corrected by the verifier): `~/.config/ghidra/ghidra_12.1.3_PUBLIC/application.log` was appended to twice by this work,
not by the pipeline scripts: (1) 2026-09-29 13:35:18, an early `SleighCompile` run before the settings dir was overridden (3 lines);
(2) 13:49:41, the upstream gradle `test` run (about 85 lines, the stack trace above). The original report attributed the log
changes only to `SleighCompile` runs. No other file under `~/.config/ghidra` has a modification time from this work, the Ghidra install
dir has no file newer than 2026-09-29 00:00, and re-running setup.sh, import.sh, decompile_function.sh and check_language.sh
from scratch left `application.log` untouched (mtime 13:49:42).

Constraints found while building this (CONFIRMED): the headless `-loader` argument is the *simple class name*
(`GameBoyLoader`, not "Game Boy"); Ghidra rejects any project path element that starts with `.`, so the
project and scratch copies live under `tools/ghidra/project/`, not `.cache/`; the repo must not itself be checked
out below a dot-directory.

Files:

| file | purpose |
|---|---|
| `tools/ghidra/env.sh`, `setup.sh`, `import.sh`, `decompile_function.sh`, `check_language.sh` | pipeline |
| `tools/ghidra/scripts/GbSeed.java` | pre-analysis: extra blocks, entry-point seeding (0100 target, vectors, `seeds.tsv`, optional regions) |
| `tools/ghidra/scripts/GbExport.java` | post-analysis exports |
| `tools/ghidra/scripts/DecompileFunction.java`, `GbOpcodeDump.java` | decompile one function; dump the decoder for every opcode |
| `tools/ghidra/check_language.py` | compares `GbOpcodeDump` output with `tools/sm83.py` |
| `tools/ghidra/seeds.tsv` | hand-maintained extra seeds, `bank<TAB>addr<TAB>label` (empty; only add proven code) |

`--regions` reads `config/regions/bankNN.tsv` (format from the project rules): `code` regions become entry points
(function roots) and every other kind except `ramcode` is cleared before analysis. The `label` column (4th field) names the seeded function (only if it is a valid identifier). Clearing is only a start state, not an
authoritative override: the verifier's own synthetic run marked 0331-0400 as `data` and Ghidra still re-created `FUN_0331` there
because it is a call target reached by flow. It is off by default so that
the default output is the raw, unbiased Ghidra view. Tested against synthetic regions files only (author's and verifier's, both
PROBABLE-level evidence; the real files did not exist yet; verifier's run seeded `Boot`@0278, `Memset`@04D8, `ErrScreen`@6B:4C80,
`Poll`@6B:4CF6 and both banked calls still resolved); a `code` region in bank 00 at an address >= 4000 is skipped with a warning.

Outputs (deterministic: two consecutive runs produced byte-identical files):

* `analysis/ghidra_functions.json`: `functions[]` with `block` (`rom0`, `romN`, `hram`, ...), `bank`, `addr` (CPU,
  hex), `name`, `default_name`, `size` (bytes in body), `instructions`, `ranges`; plus `function_count`,
  `functions_per_block`, `evidence_level: "HYPOTHESIS"`.
* `analysis/ghidra_disasm_bank00.txt`: sanity listing of ROM0 in Ghidra syntax (not RGBDS), undefined runs summarised.
* `analysis/ghidra_coverage.tsv`: per block bytes decoded as code / typed data / undefined, and function count.
* `analysis/ghidra_bank_refs.tsv`: every flow reference leaving its block (how Ghidra represents a cross-bank call).
* `analysis/ghidra_language_check.tsv`: per-opcode comparison with `sm83.py` (from `check_language.sh`).
* Logs stay in `tools/ghidra/project/` (git-ignored).

## 4. Memory model

The GhidraBoy loader detects a CGB ROM (logo hash + header byte 0143 = C0) and creates (CONFIRMED, block list in
`analysis/ghidra_coverage.tsv`, 148 blocks):

| block | CPU range | kind |
|---|---|---|
| `rom0` | 0000-3FFF | initialized, default address space, mapped once |
| `rom1` ... `rom127` | 4000-7FFF | one **overlay address space per bank**, named `romN` (N decimal); all 127 are created, padding banks included |
| `xram` | A000-BFFF | cartridge SRAM bank 0 (default space, uninitialized) |
| `xram1`..`xram3` | A000-BFFF | added by `GbSeed.java`: SRAM banks 1-3 as overlays (header 0149 = 03 means 32 KiB) |
| `vram0` / `vram1` | 8000-9FFF | bank 0 in default space, bank 1 overlay |
| `wram0` | C000-CFFF | default space |
| `wram1` | D000-DFFF | default space (bank 1, the boot mapping) |
| `wram2`..`wram7` | D000-DFFF | overlays |
| `echo` | E000-FDFF | added by `GbSeed.java` |
| `oam`, `unusable`, `io`, `hram`, `ie` | FE00-FE9F, FEA0-FEFF, FF00-FF7F, FF80-FFFE, FFFF | `unusable` added; hardware register labels (P1, SB, SC, LCDC, ..., KEY1, VBK, HDMA1-5, BCPS...) by the loader |

The block names differ from the ROMX_XX suggested in the task on purpose: the bank analyzer looks up the address
space named `rom<N>`, so renaming would silently disable it. Bank 0 (`rom0`) is not an overlay, so the string
form of an address in bank N is `romN::4C80`; exports carry `block`, `bank` and the plain CPU `addr` instead.

Cross-bank calls, how they work in this model (CONFIRMED from the analyzer source and from the run):

* A `call $4C80` has a 16-bit target only. The default-space reference points at a location with no block
  (shown as block `?` in `ghidra_bank_refs.tsv`). The GhidraBoy analyzer replaces it with a reference into overlay
  `romN` when it can prove N: propagated constants for `ld a,N ; ld [$2xxx],a ; call $4xxx` in the same function, or `ld a,N ; call
  <helper that writes the bank register from A>` where the helper is recognised by a bounded scan (24 instructions, depth 2), or
  `ld a,N ; ld hl,X ; rst/call <far-call helper ending in jp hl>`. Flows *inside* a bank stay in that bank.
* Result on this ROM (CONFIRMED, `analysis/ghidra_bank_refs.tsv`): exactly two banked calls were resolved, both
  from the boot code: `00:02A9 call $4C80` to bank 6B (`ld a,$6B` at 02A2, `ld [$2100],a` at 02A6) and
  `00:0314 call $4717` to bank 4F (`ld a,$4F` at 030D, `ld [$2100],a` at 0311). `cfg.py` infers the same banks
  independently. MBC5 low bank byte is at $2000-$2FFF and the ROM writes $2100; $3000 is written at 0324.
* Verified by the verifier with a dumper script (not in the repo) that compared every byte of every overlay block to `baserom.gbc`:
  all 128 banks (rom0 + rom1..rom127) x 16384 bytes match, 0 differences; `rom107::4c80` is bank 0x6B; `rom0` lives in the default
  space (named `ram`), rom1..127 are overlay spaces with permissions r-x. CONFIRMED.
* `00:20A3 jp $4000` and `00:20A9 jp $4082` (inside the 6-byte functions `20A0` and `20A6`) stay unresolved (block `?`).

## 5. Why raw Ghidra output cannot be trusted for this ROM

1. **Inline data after a call is decoded as code (CONFIRMED).** `00:0328 call $06D1` is followed by `00 40 1C`, then
   `jp $0328`. Routine `06D1` starts `ldh [$A9],a ... pop hl ; ld a,[hl+] ; ldh [$AE],a ; ld a,[hl+] ; ldh [$AF],a ; ld a,[hl+] ;
   ldh [$F2],a`, i.e. it consumes the three bytes at the return address (the decompiler shows this as
   `unaff_retaddr[0..2]`). Ghidra lists 032B-032D as `NOP`, `LD B,B`, `INC E`. Reading them as a far-call operand
   (lo, hi, bank = $4000 in bank $1C) is PROBABLE (matches the `far_addr_bank` convention that `tools/cfg.py --inline 00:06D1=3:far` uses, and
   with that option cfg.py walks 11 banks instead of 3 and its output flags two `suspicious` items, `1C:4056 runs_into_padding` and
   `4F:4194 jp nz,$B841 -> sram`; the far target 1C:4000 decodes as further `call $06D1` + 3 inline bytes, which supports the reading but does not prove it), but Ghidra has no notion of it: none of the far calls that go through `06D1` are
   resolved, which is most of the ROM's inter-bank structure.
2. **Runtime code is invisible (CONFIRMED).** All five interrupt vectors are `jp $CBxx ; reti` (bytes at 0040,
   0048, 0050, 0058, 0060) into WRAM, and `00:06FC` is `call $FFA8` and `00:0713` is `jp $FFA8` (bytes `C3 A8 FF`; `analysis/ghidra_bank_refs.tsv` labels both
   `UNCONDITIONAL_CALL` because Ghidra turns a jump to a function into a call-return; corrected by the verifier) in HRAM. WRAM/HRAM blocks are uninitialized, so Ghidra
   creates empty stubs (function `FFA8` has 0 instructions) and cannot analyse the real handlers until the
   copy routine and its image are modelled (not located yet at the time of writing).
3. **The analyzer only sees function bodies, and only constant bank writes (CONFIRMED from source).** Documented limits in
   `GameBoyBankSwitchAnalyzer`: code not owned by a function is not visited (this is why `GbSeed.java` seeds the target of
   `0100: nop ; jp $0278`; verifier's run without GbSeed: the boot code IS disassembled by flow (554 code bytes in ROM0, 15 functions) but
   no function owns 0278, so the two calls above stay unresolved (block `?`) and 0039-00FF including the vectors stays undefined. The
   original wording 'the whole boot code is ignored' was too strong and is retracted); far calls with inline
   operands are not handled; data-driven jump tables are not resolved; bank tracking follows the propagator's walk, not each path.
4. **MBC5 is only approximated (CONFIRMED from source, consequence PROBABLE).** All writes to 2000-3FFF are treated as
   "the bank number", masked with 0x1FF. On MBC5 a write to $3000 is the ninth bit, not the bank. This ROM does `ld [$3000],a` (0324). Bytes 0317-0324 are `ld bc,$0001 ; di ; ld a,c ; ldh [$8A],a ; ld [$2100],a ; ld a,b ;
   ldh [$8B],a ; ld [$3000],a`, i.e. exactly the pattern in question (constant low byte 1 to $2100, then constant 0 = B to $3000): the
   analyzer's pending bank becomes 0 there (from the source; not observed in the run). It has no visible effect in this ROM because the only
   flows that follow in that function (`call $06D1`, `jp $0328`) target ROM0 and are not bank-resolved; a later constant-bank call in similar
   code would be left unresolved (unknown values already reset it to "unknown"). PROBABLE. Banks above 255 are not modelled (irrelevant here: 128 banks).
5. **Auto-analysis decodes what it reaches, and only that.** ROM0 decoded code bytes: 735 of 16384; everything else is
   undefined. On a ROM with 85 non-padding banks (task census), any widening (for example "Undefined code" search) would decode data as code; the
   reverse mistake (code left as undefined) is what happens by default.
6. **Decoder differences (CONFIRMED).** Ghidra's `STOP` is 1 byte, `sm83.py` (and RGBDS) treat it as 2 bytes (`10 00`). No
   other opcode differs (section 6). Illegal opcodes (D3 DB DD E3 E4 EB EC ED F4 FC FD) are "bad instruction" in both.
7. **Default naming and signatures are meaningless.** Function names are `FUN_<addr>` / `FUN_rom107__4c80` (Ghidra style, not the project
   `Function_<bank>_<addr>` convention); the `asm` calling convention treats every register as input and output, so decompiled
   parameters are guesses.

Trust rules for this project: Ghidra output is a HYPOTHESIS. Before it influences `config/` or source, confirm the bytes with
`tools/sm83.py`/`tools/cfg.py` or a trace. `analysis/ghidra_*` files are generated evidence to read, not inputs to the build.

## 6. Comparison with tools/sm83.py and tools/cfg.py

Same seeds on both sides: `00:0100`, the five vectors, and the boot call graph.

| block | Ghidra code bytes (`ghidra_coverage.tsv`) | `python3 tools/cfg.py --seed 00:0100 --seed 00:0040 --seed 00:0048 --seed 00:0050 --seed 00:0058 --seed 00:0060 --summary` |
|---|---|---|
| ROM0 | 735 | 727 (the difference of 8 equals the eight `ret` bytes at 0000, 0008, ... 0038 that appear in Ghidra's listing; cfg.py was not seeded with them) |
| bank 6B | 155 | 155 |
| bank 4F | 142 | 142 |

CONFIRMED: two independent recursive-descent implementations reach the same instructions when given the same seeds (that they are
implementations of the same idea, not two independent oracles, is the caveat: it validates the SM83 decoder and flow model, not the
seed set). `cfg.py --seed 00:0100 --inline 00:06D1=3:far` reaches 1978 instructions in 11 banks, which Ghidra cannot without new machinery.

Language check (`tools/ghidra/check_language.sh`, CONFIRMED, re-run by the verifier with identical output; it checks decode length, flow class
and operand text ONLY. Sleigh P-code semantics (flag effects, pointer arithmetic) are NOT compared, and the upstream tests that would
exercise them crashed, so the semantics behind the decompiler output are unverified): 511 rows (255 single-byte opcodes excluding CB + 256 CB opcodes; 11 illegal
ones included): 510 identical on instruction length, flow class and operand text after normalising syntax (`(hl)` vs `[hl]`, `ADD B`
vs `add a, b`, `$FF34` vs `0x34`); the only difference is STOP (length 1 vs 2).

## 7. Decompiler samples (HYPOTHESIS output, generated by `decompile_function.sh`)

`00:06D1` (about 5 s): the decompiler renders the inline-argument read correctly, which is a useful hint, not a proof:

```c
void FUN_06d1(undefined1 param_1,undefined2 param_2)
{ ...
  DAT_ffab = (undefined1)param_2;   DAT_ffac = (undefined1)((uint)param_2 >> 8);
  DAT_ffae = *unaff_retaddr;  DAT_ffaf = unaff_retaddr[1];  DAT_fff2 = unaff_retaddr[2];
  DAT_ffa9 = param_1;
  uVar1 = FUN_0673();  FUN_0622(DAT_fff2);  uVar2 = FUN_ffa8(); ...
  DAT_ffae = SUB21(unaff_retaddr + 3,0);  ...  FUN_ffa8();
```

`6B:4C80` (the function called when the CGB check at `00:028C..02A0` fails; the bytes show `ldh a,[$A3]` compared against `$11`; treating
$A3 as the boot-time A register / CGB flag and this as a "requires Game Boy Color" screen is PROBABLE, not confirmed. Verifier's bytes: the
first instructions at 00:0278 are `00 E0 A3` (`nop ; ldh [$A3],a`, i.e. A at entry is stored to $A3, CONFIRMED) and `call $4C80` at 02A9 runs
only when `$A3 != $11` (`jr z,$02AE` at 02A0, CONFIRMED); the routine never returns (it ends in `halt` loops), so the `jr $02A2` at 02AC is
not reached in normal flow): the output shows PPU register setup
(LCDC, SCX/SCY, WX/WY, VBK, BGP), two tile/map copies via `FUN_050c`, IE = VBLANK only, `DAT_cbf1 = 0xC3, DAT_cbf2 = 0x1F, DAT_cbf3 = 0x4D` (the WRAM
vblank vector becomes `jp $4D1F`, CONFIRMED as a code fact) and a `halt` loop. This is more readable than a raw listing for register-level
routines like this. Caution seen by the verifier in the same output: the decompiler mis-types register arguments. `FUN_050c` is a plain
memcpy (`hl`=source, `de`=destination, `bc`=length, bytes at 050C-0523), and the second call in `6B:4C80` is `bc=$0240 de=$9800 hl=$4000`, but the
C shows `FUN_050c(0x4000,&UNK_0240,0x9800)`, i.e. the length $0240 is rendered as a pointer to ROM0 address 0240. Treat every decompiled
parameter as a guess.

## 8. Best uses and next steps

* Use the decompiler for a single routine when the assembly is hard to read; treat the C as a sketch.
* Use `analysis/ghidra_functions.json` only as a cross-check list ("Ghidra also sees a function here").
* GUI browsing (UNTESTED here): start Ghidra with the same `-Dapplication.settingsdir` as `env.sh` (so the SM83 extension is present)
  and open `tools/ghidra/project/MobileTrainer`.
* Possible future work, only if it pays off: a pre-script that turns `cfg.py --json` xrefs (including `--inline` far calls) into
  Ghidra references, so Ghidra follows the project's own proven call graph; a patch to the analyzer to treat $3000 as MBC5's high bit.
* Suggested `.gitignore` addition: none needed (`.cache/` and `tools/ghidra/project/` are already ignored).

## 9. Retracted or corrected by the adversarial verifier

| original statement | verdict |
|---|---|
| "Ghidra adds nothing for code/data/bank/naming" was CONFIRMED | downgraded to PROBABLE (comparison covered recursive descent from seeds only) |
| "`0713` calls `$FFA8`" | wrong instruction: it is `jp $FFA8` (bytes `C3 A8 FF`); `call` only at 06FC |
| "without the seed the whole boot code is ignored" | too strong; the code is disassembled but not owned by a function (see section 5, item 3) |
| gradle `test` crash "cause not investigated" | cause is in `~/.config/ghidra/.../application.log` (serial filter factory init), still unverified whether 12.1.3-specific |
| "only `SleighCompile` runs touched `~/.config/ghidra`" | also the gradle test run (13:49) appended a stack trace to `application.log` |
| `import.sh` "works unattended" | it exited 0 even when Ghidra failed to start; fixed |
| `seeds.tsv` comment "0100 and the vectors are already seeded by the loader" | wrong for headless runs; `GbSeed.java` does it |
| the "24 functions after seeding" figure in the review report | current runs give 29 functions (5 vectors + `entry` + boot code + callees); it is not stated in the repo files |

Upheld unchanged after re-derivation: no SM83 language shipped with Ghidra 12.1.3 (C1); GhidraBoy commit `cc9f565` builds and runs on 12.1.3 with
identical hashes from a wiped cache (C2); upstream `assemble` output has the same `sm83.sla` sha256 as ours (C3, scratch copy inspected);
deterministic exports (C4); memory map incl. byte-exact banked ROM overlays (C5); exactly two resolved banked calls, `00:02A9` -> bank 0x6B
and `00:0314` -> bank 0x4F, bytes verified (C6); inline far-call operand not modelled (C8); ROM0/6B/4F code-byte parity with `cfg.py` (C9); 510/511
opcode rows (C10); vector bytes (C11); `-loader` simple class name and the dot-path restriction (C15).
