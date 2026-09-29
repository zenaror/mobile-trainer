# Formats and usage of the source generator

`tools/gen_asm.py` turns **ROM bytes + `config/` tables** into one RGBDS file per bank (`src/bankNN.asm`)
plus `src/ram.inc`.  Every stage of the reverse engineering rebuilds the ROM **byte-identically**: a table
entry can only change *how* bytes are written (`db`, an instruction, a label), never *which* bytes.

```
baserom.gbc ──┐
config/regions/bankNN.tsv ──┤
config/symbols/bankNN.tsv ──┼─► tools/gen_asm.py ─► src/bankNN.asm, src/ram.inc ─► rgbasm/rgblink ─► ROM == baserom.gbc
config/ram/*.tsv ───────────┤
config/conventions.tsv ─────┤
config/xrefs.tsv ───────────┘        constants/hardware.inc (hardware register names)
```

Evidence vocabulary (the `status` column everywhere): `CONFIRMED` (demonstrated, cite the bytes/trace),
`PROBABLE` (strong, not conclusive), `HYPOTHESIS` (unconfirmed).  Addresses are CPU addresses in hex
(`$`/`0x` prefixes optional): bank 00 = `0000-3FFF`, banks 01-7F = `4000-7FFF`; file offset =
`bank*0x4000 + (addr & 0x3FFF)`.  All files are UTF-8 (a BOM is tolerated), TAB-separated, one record per line; a line whose first
non-blank character is `#` and blank lines are ignored; a header line starting with `start` / `addr` / `bank`
is skipped.  Names are `[A-Za-z_][A-Za-z0-9_]*` (no dots), not an rgbasm keyword/register/function token (`div`, `strlen`, `endu`, ...), not any
`DEF` name of `constants/hardware.inc` (address-like or not, e.g. `LCDCF_ON`), and unique across the whole ROM (labels, consts, RAM names share one namespace).

## config/regions/bankNN.tsv

`NN` = bank number, 2 hex digits.  One region per line:

```
start	end	kind	label	status	note
```

`end` is exclusive.  Regions of a bank must lie inside the bank window and must not overlap (hard errors).
Bytes not covered by any region are filled automatically with a `raw` region ("gap").  `label` may be empty
or `-`; otherwise it becomes an exported label at `start` (a *named* label; it beats generic names).  The
`note` (rest of the line) is copied into the generated source as a comment.

| kind | emitted as | remarks |
|---|---|---|
| `code` | one instruction per line (`tools/sm83.py`); illegal opcodes as `db $xx ; illegal opcode` | an instruction crossing the region end is an **error**; labels and name substitution, see below; the bytes after a call to a convention entry are inline data, see *Inline-data conventions* |
| `data` | `db` lines, 16 bytes per line | |
| `words` | `dw` lines, 8 little-endian words per line (`dw $4A21`) | even size; a `dw` value becomes a label only if a *named* label (symbol/region label) exists at that address (same bank or ROM0); the value `$0000` is **never** substituted (null slot, not a pointer to 00:0000) unless an `xref word` row says so |
| `ptrtable` | `dw`, one word per line | like `words`, documented as a pointer table: also generic labels of code targets (`dw Label_05_4A21`); `$0000` slots stay numeric; a `$4000-$7FFF` value is assumed to mean the table's own bank (heuristic, see Known limitations) |
| `text` | `db` lines, 16 per line | raw bytes only; charmap comes later |
| `gfx` | `db` lines, 16 per line (= one 2bpp tile) | |
| `zero` | `ds N, $00` | error if any byte is non-zero |
| `raw` | `INCBIN "baserom.gbc", offset, size` | the not-yet-analysed default |
| `ramcode` | disassembled like `code`, wrapped in an rgbasm `LOAD` block | bytes stored here, executed elsewhere; needs `runaddr=$XXXX` in the note |

Any label (symbol, region label, generic) that falls inside a non-code region splits it there
(`INCBIN`/`ds`/`db`/`dw` lines are cut at the label).  Labels must sit on instruction boundaries in
`code`/`ramcode` regions and on word boundaries in `words`/`ptrtable` regions (otherwise: error).

### ramcode

`note` must contain `runaddr=$CBF1` (runtime address of the first byte); optional `runbank=N` (`BANK[N]`
for WRAMX/SRAM/VRAM).  The runtime range must fit one of `VRAM $8000-9FFF`, `SRAM $A000-BFFF`,
`WRAM0 $C000-CFFF`, `WRAMX $D000-DFFF`, `OAM $FE00-FE9F`, `HRAM $FF80-FFFE`.  Emitted as

```
	LOAD "RAM_05_4123", WRAM0[$CBF1]        ; stored at 05:4123, runs at $CBF1
Function_05_CBF1:: ; 05:4123 (runs at $CBF1)
	...
	ENDL
```

Verified with RGBDS 1.0.3 (`tools/selftest_gen.py`, tests `kinds` and `ramareas`): the bytes are stored at the
ROM address, every label inside resolves to its **runtime** address (see the linker `.sym`), relative `jr`
offsets are decoded against the runtime address, and `jp`/`call` inside the block are exact.
Regions whose runtime ranges overlap (overlays) must start at the same `runaddr`; they are emitted as
`LOAD UNION "RAMOVL_CC00", ...` (same union name, one per overlay), partial overlaps are an error.
Generic names for RAM code are `<Prefix>_<storage bank>_<runtime address>` (e.g. `Function_00_CBF1`); two
overlays of the same bank with the same runaddr would collide and must then be named with symbols.

## config/symbols/bankNN.tsv

```
addr	name	type	status	evidence
```

`type`: `function data table string label const`.  `addr` is the CPU address of a location in bank `NN`
(for `ramcode`, the *storage* address in the ROM; the label lands at the runtime address).  Symbols become
exported labels (`Name::`) and override generic names; several names at one address are allowed (aliases,
the first one is used for references, the others are emitted too).  Names that look generic
(`Function_05_4A21`) are only accepted at the address they encode.  `const` symbols are numeric equates:
`addr` is the value, emitted as `DEF name EQU $value` + `EXPORT name` in that bank's file (never substituted
into operands).  A symbol in the middle of an instruction is an error.

## config/ram/*.tsv

```
addr	name	size	type	status	evidence
```

WRAM/SRAM/HRAM/IO variables (`$8000-$FFFF`); `size` in bytes (decimal, or `$`/`0x` hex); `type` is free text
(`byte`, `word`, `array`, ...).  Emitted as `DEF name EQU $addr` in `src/ram.inc`, which every bank includes.
Used for `ldh` operands and `ld [a16]` operands only: an address inside a variable prints as `name` or
`name + k`.  Never for `ld hl, $xxxx`-style immediates (see xrefs).  A hardware register name always wins.

## config/xrefs.tsv

```
bank	addr	operand_kind	target_bank	target_addr	[status	evidence]
```

Forces symbol substitution at one instruction / word (`bank:addr` = where the operand *is*, `addr` is the
first byte of the instruction, or of the `dw` slot):

| operand_kind | operand |
|---|---|
| `branch` | target of `jp/jr/call/rst` (needed for ROM0 or RAM code jumping into `$4000-$7FFF`, whose bank is otherwise unknown) |
| `imm` | `ld r16, $xxxx` |
| `mem` | `ld [$xxxx], a` / `ld a, [$xxxx]` / `ld [$xxxx], sp` |
| `word` | one `dw` inside a `words`/`ptrtable` region |

`target_addr` must equal the numeric operand (a name can never change bytes: mismatches are errors) and
`target_bank` says which bank it means (`RAM` = look the address up in `config/ram`).  If nothing is
named at the target a generic label is created there (`Function_/Label_` in code, `Data_/Table_/String_`
elsewhere); a target in the middle of an instruction is an error.  Stale rows (no such instruction, wrong
operand kind) are errors.  Far-call analyses should emit rows in this format; feed them with
`gen_asm.py --xrefs FILE` (repeatable) or merge them into `config/xrefs.tsv`.

## config/conventions.tsv

```
bank	addr	layout	status	note
```

Inline-data call conventions: `(bank, addr)` is the **entry address of the callee** that reads bytes stored right
after the `call`/`jp`/`rst` that reached it.  `layout` says how many bytes and what they are:

| layout | bytes | emitted as |
|---|---|---|
| `farptr` | 3: little-endian address word, then a bank byte | `dw <Label or $xxxx>` + `db <BANK(Label) or $bb>` |
| `inline_dw` | 2 | `dw $xxxx` (a label only through an `xref word` row on the slot, see below) |
| `inline_db` | 1 | `db $xx` |

Same file rules as the other tables (TAB-separated, `#` comments, optional `bank` header line, hex numbers with
optional `$`/`0x`, statuses `CONFIRMED|PROBABLE|HYPOTHESIS`; the rest of the line is the note).  Errors: unknown layout,
bank/address outside the ROM/bank window, bad hex, bad status, two rows for one entry.  The entry is not required to be
inside a `code` region, but if it is and is not on an instruction boundary there is a warning (error with `--strict`).
Seed rows (CONFIRMED / documented in `docs/research/boot_and_home.md`):

```
00	06D1	farptr	CONFIRMED	FarCall: call $06D1 ; dw target ; db bank
00	06BC	inline_dw	CONFIRMED	call $06BC ; dw target (the bank comes from hFFF3, so no bank byte)
```

### Inline-data conventions (generator behaviour)

* **What counts as a call.**  An unconditional `call`, `jp` or `rst` inside a `code`/`ramcode` region whose target is
  the entry.  Conditional forms never consume (the not-taken path would fall into the data).  The target is compared as
  `(bank, address)` with the usual bank visibility rules: `$0000-$3FFF` is bank 0 from anywhere, `$4000-$7FFF` is the
  caller's own bank from a ROMX bank, and from ROM0 or RAM code it has no known bank (so a row for `75:4030` is only
  matched from bank 75, or from ROM0/RAM code through a `branch` xref row that says `75`).
* **What happens to the bytes.**  The layout's bytes after the call are not decoded; they are emitted on the following
  lines.  They are never instruction starts: a label there is an error ("inside the inline data of the convention call
  at ...").  `jp` sites print their blank separator line after the inline bytes.
* **Where the bytes may live.**  (1) Inside the same `code`/`ramcode` region as the call (the normal case).  (2) Tolerated
  for `code` only, so already-split proposals keep working: the call is the last instruction of the region and the bytes
  are a `data` region that starts exactly at the end of the call and has at least the layout's size; the first bytes of
  that region are then written with the convention (`stats: inline_adopted`); a label at the region start is fine, one
  inside the inline bytes is not; merging the region into the code region is cleaner.  (3) Everything else is an **error
  naming the region edge to move**: the bytes cross the region end ("move that region edge to $XXXX"), start in a
  `code`/`ramcode`/`zero`/`raw`/`words`/... region ("move the end of this code region ... to $XXXX so the inline bytes
  belong to it"), or would leave the bank.  A cut is never silently accepted.
* **Far pointers (`farptr`).**  With word `W` and bank byte `B`: `B = 0` designates ROM0 and needs `W < $4000`;
  otherwise `B` must exist as a ROM bank and `W` lie in its window `$4000-$7FFF` (a `$8000+` word selects a WRAM/SRAM bank,
  a ROM0 address with `B != 0` is not a ROM location).  If a label exists at **exactly** `(B, W)` the bytes are written as
  `dw Label` / `db BANK(Label)` and rgbasm/rgblink compute them (the compare proves both bytes); otherwise as `dw $xxxx`
  / `db $bb`.  A label at the same address in another bank is never used.  Bytes stored in a `ramcode` region are never a
  target: their labels live at the RAM address and `BANK()` of a label inside a `LOAD` block is the RAM section's bank.
  A far pointer counts as a `call` xref: a target on an instruction start of a `code` region gets `Function_<bank>_<addr>`
  (a target in a non-code region gets no generic label, a target inside an instruction is counted as
  `targets_mid_instruction` and stays numeric).
* **`inline_dw`.**  Numeric unless an `xref word` row (`bank addr word target_bank target_addr`) names the slot
  (`addr` = the address of the first inline byte, which is what the row's `bank:addr` means for a words slot).  A
  `word` xref on a `farptr` slot is an error (far pointers label themselves).
* **Bank resolution through xrefs.**  A `branch` xref row on a call from ROM0/RAM code into `$4000-$7FFF` decides
  which `(bank, address)` the call means, also for matching a convention entry.
* **Tools.**  `tools/conventions_check.py` (below) reports, for a region proposal, sites whose inline bytes are outside
  the region / in a non-code region and far pointers whose target is not inside a code region;
  `tools/progress.py` counts the inline bytes as "data via conventions" (they stay part of their code region's bytes);
  `tools/lib/conv.py` holds the scanner shared by all three.

### tools/conventions_check.py

```
tools/conventions_check.py [--regions DIR] [--conventions FILE] [--xrefs FILE ...] [--rom FILE] [--max N] [--strict]
make conventions-check
```

`--regions` is any directory of `bankNN.tsv` tables (default `config/regions`, so a proposal directory of another
agent works).  Every `code`/`ramcode` region is swept with the generator's own scanner; the report has (1) the
convention call sites with `ok` / `adopted` (tolerated data region right after the call) / `ERROR` (the generator would
refuse: bytes cross the region end or lie in a non-code region or outside the bank; the line names the region edge to
move), (2) far pointers whose `(bank, address)` is not on an instruction start of a `code` region, grouped by target
with the kind of region that holds it (`unclassified (raw gap ...)` = classify it as code, `data region` = the pointer
targets data or the region proposal is wrong, `inside an instruction`, `not a ROM location`), (3) a byte-pattern census
of `CD/C3 <entry>` anywhere in the ROM by region kind (sites in raw regions are what a future classification has to
respect).  Exit status 1 with `--strict` only when section 1 has an ERROR.

## Labels and names

* `call/callcc/rst` targets -> `Function_<bank>_<addr>`; targets only reached by `jp/jr` -> `Label_<bank>_<addr>`;
  data/table/text targets created by an xref -> `Data_/Table_/String_<bank>_<addr>` (bank/addr uppercase hex).
  All are global (`::`), so any bank can reference them.
* A target gets a generic label only if it lies in a `code`/`ramcode` region **on an instruction boundary**.
  Otherwise the operand stays numeric (counted in the progress report).
* Priority at an address: symbols (file order) > region label > generic.
* Bank visibility: a reference from bank 0 to `$0000-$3FFF` is bank 0; from ROMX bank N to `$4000-$7FFF`
  is bank N (code in bank N cannot switch itself away); from ROMX bank N to `$0000-$3FFF` is bank 0.
  A reference from ROM0 or from RAM code into `$4000-$7FFF` has no defined bank and stays numeric unless an
  xref names it.  References to `$8000+` resolve only into a **unique** `ramcode` runtime range (or inside the
  referencing ramcode region itself).  A ROM address whose bytes belong to a `ramcode` region is never a label
  target (those bytes run elsewhere).
* `rst $xx` uses the vector's label when there is one.

## Operand names (never change bytes)

* `ldh` / `ld [a16]` with `$FF00-$FF7F`, `$FFFF`: hardware names from `constants/hardware.inc`
  (`rLCDC`, `rIE`, ...; wave RAM as `_AUD3WAVERAM + n`).  The generator parses the `DEF rNAME EQU $FFxx` lines
  of that file, so it is the single source of truth.
* `ld [$0000|$2000|$3000|$4000], a` (writes only, exact address): `rRAMG rROMB0 rROMB1 rRAMB`
  (MBC5 as declared by header type $1B; the name asserts the register, not that the cartridge really is MBC5).
  Reads (`ld a, [$2000]`), `ld [$xxxx], sp` and other addresses in the ranges stay numeric.
* `ldh`/`ld [a16]` RAM addresses: names from `config/ram` (see above).
* `ld r16, imm16`: **never** substituted, except by an xref.
* Every substitution is asserted to have exactly the numeric value of the operand while generating.

## Checks

* **Structural round trip (always, inside `gen_asm.py`)**: every `db/dw/ds/INCBIN` line is parsed back and
  compared with the ROM bytes at its position, every instruction's bytes are compared with the ROM, every
  substituted name is evaluated and compared with the operand, and each bank must tile exactly 16384 bytes.
  A failure aborts generation; nothing is written.
* **Assembler round trip (`regen` unless `--fast`, and `verify`)**: the generated files are assembled and
  linked in a temp dir (`rgbasm`, `rgblink -p 0x00`; `rgbfix` is deliberately not run, the header is ROM data)
  and compared with `baserom.gbc`.  `regen` writes into `src/` only if this passes.  Differences are mapped to
  regions with `tools/compare_rom.py`.
* Hard errors (all reported with `file:line`): unknown kind/status/type, bad hex, region outside the bank
  window or overlapping, odd `words`/`ptrtable` size, `zero` with non-zero bytes, `code` instruction crossing the
  region end, `ramcode` without `runaddr`/outside RAM/partial overlay overlap, label not on an instruction/word
  boundary, inline data of a convention call that crosses/leaves its code region or holds a label, duplicate or colliding names (also with hardware/RAM/const names), generic-looking name at the wrong
  address, xref stale/mismatching/unlabelable, ROM size not a multiple of 16 KiB.  `--strict` also turns
  warnings (missing status, config files not named bankNN.tsv, hardware-name shadowing, a convention entry inside an instruction) into errors.
* Output is deterministic (no dates, sorted, files whose content is unchanged are not rewritten).

## Commands

```
make                 regenerate src/ if config/ or the tools changed, assemble, link, compare -> "RESULT: IDENTICAL"
make regen           python3 tools/gen_asm.py regen        (checked; writes src/ only if everything passes)
make verify          python3 tools/gen_asm.py verify       (temp build + compare, src/ untouched)
make test            tools/selftest_gen.py + tools/test_sm83.py + tools/test_cfg.py
make conventions-check   python3 tools/conventions_check.py   (far pointers / inline sites vs config/regions)
make progress        python3 tools/progress.py             (writes docs/PROGRESS.md)

tools/gen_asm.py [regen|verify|check] [--config DIR] [--out DIR] [--rom FILE] [--fast] [--strict]
                 [--xrefs FILE ...] [--keep DIR] [-q]
tools/compare_rom.py REFERENCE BUILT [--max-runs N] [--config DIR]
tools/progress.py [--config DIR] [--rom FILE] [--out FILE | --no-write]
tools/conventions_check.py [--regions DIR] [--conventions FILE] [--xrefs FILE ...] [--rom FILE] [--max N] [--strict]
tools/selftest_gen.py [-k NAME] [--no-sweep] [--keep]
```

`make` notes: deleting/adding a config file is detected (`build/.config.list`); `src/` is a generated artefact
committed for review.  Requirements: `rgbasm`/`rgblink` 1.0.x, Python 3.12, `baserom.gbc` (`make baserom`).

## Generated file layout

```
; Generated by tools/gen_asm.py -- DO NOT EDIT (edit config/ and run `make regen`).
INCLUDE "constants/hardware.inc"
INCLUDE "ram.inc"                 ; resolved through `-I src`
SECTION "Bank05", ROMX[$4000], BANK[$05]

; ---- code $4000-$4123 (291 bytes) [CONFIRMED] note text
Function_05_4000:: ; 05:4000
	...
```

Bank 00 uses `ROM0[$0000]`.  Sections are fixed-address, one per bank, so offsets can never drift.

## Self test (`tools/selftest_gen.py`, all in a temp dir; the real config/src are not touched)

`sweep_code` marks every non-zero range of every bank of the real ROM as `code` (plus sampled symbols, RAM names and
xrefs) and proves the rebuild is byte-identical; `sweep_kinds` does the same with every non-code kind and random cuts;
`kinds`, `ramareas`, `hw_names`, `extra_xrefs` cover each kind, ramcode/LOAD (labels at runtime addresses), labels,
name substitution and MBC/hardware names; `failures` (49 cases) checks every hard error; `safety` proves nothing is
written when the structural or assembler check fails; plus `determinism`, `compare_rom`, `progress`.

Inline-data conventions: `conv_kinds` (synthetic 4-bank ROM: `farptr`/`inline_dw`/`inline_db`, `call` and `jp`, ROM0 vs ROMX
entries and bank resolution by `branch` xref, a caller in `ramcode`, labels found / missing / at another bank / numeric
for bank byte 0 with `$4000+`, nonexistent bank, WRAM word, mid-instruction target, ramcode-stored target, conditional call
that must not consume; the linker resolves every `BANK()`), `conv_boundaries` (26 cases: exact fit, crossing by 1/2 bytes,
adopted data region, code/zero/raw/words after the call, bank end, labels inside inline data, ramcode, `rst` entry),
`conv_config` (15 cases: `conventions.tsv` errors, `--strict`, CLI, `conventions_check.py`), `sweep_conv` (the real ROM with
every non-zero range as code and the real `config/conventions.tsv`; a second implementation of the site rule (it does not
use `lib/conv.py`, but shares `sm83.decode` and the same linear sweep) finds 5274 sites = 5273 `farptr` + 1 `inline_dw`;
the generator must consume exactly those, rebuild identically and pair every `dw X` with `db BANK(X)`.  Note: the raw
census has 5274 `CD D1 06` patterns, so 5273 (not 5274) are `farptr` sites in this sweep: the pattern at 68:784E is
not an instruction start in the linear sweep, and the total 5274 is a coincidence of 5273 + 1; whether 68:784E is a real
call is unknown (HYPOTHESIS: data or an operand)) and `sweep_conv_cuts`
(real sites: a region edge through the inline bytes is refused with the edge to move, a wrong next region is refused, an
adopted `data` region rebuilds identically).

## Known limitations

* `code` regions are a linear sweep: bytes that are really data inside a `code` region are still emitted
  byte-exactly, just as (possibly nonsensical) instructions; split the region when the evidence says so.  The one
  exception is the inline data of the call conventions in `config/conventions.tsv` (only those rows are known; other
  inline-data callees keep showing their data as instructions until a row is added).
* A convention says what the *callee* reads; it cannot tell whether a particular `call` byte pattern in a `code` region is
  a real call (the linear sweep is as reliable as the region classification).  The `jp` and `rst` forms are accepted
  because the callee reads the bytes that follow the transfer instruction; a row for an entry that is only ever reached
  by a tail `jp` whose following bytes are ordinary code would mis-render them.
* `rst` operands are named only through the vector label; `jp hl`/computed jumps are opaque.
* Mid-instruction jump targets (jumping into an operand byte) stay numeric.
* A symbol/label in the middle of an instruction is rejected instead of being emitted as an alias.
* Bank assumption for `words`/`ptrtable`: a value in `$4000-$7FFF` is resolved in the table's own bank, which is only
  right when the table points into its own bank.  For a table holding cross-bank or far pointers the generic labels it
  creates (`Label_<own bank>_<addr>`) are cosmetic **and possibly misleading** (bytes stay exact); give such slots an
  explicit `xref word` row with the real target bank, and treat unsupported generic labels as HYPOTHESIS.
* `analysis/farcall_targets.tsv` (`caller_bank caller_addr routine target_bank target_addr confidence`) is not loaded
  automatically; its rows map to xrefs as `caller_bank caller_addr branch target_bank target_addr` only after
  checking that `caller_addr` is the first byte of a decoded instruction (stale rows are hard errors).
* Deleting a config file changes the result; `make` notices (file list), an edited-in-place file via timestamps.

## Verification notes (adversarial review of this generator)

Re-run from a clean copy: `make`, `make regen`, `make verify`, `tools/selftest_gen.py` and extra scratch configs (overlapping
regions, a region ending mid-instruction, illegal opcodes inside code, ramcode `LOAD` and `LOAD UNION` across banks, colliding
and generic-looking names, CRLF/BOM files, a whole-ROM all-code config with 128 banks of random cuts and symbols, cross-bank
xref words) all ended in an identical ROM or a loud error.  Corrections made:

* Retracted: "53330 dw label substitutions" in the `sweep_kinds` evidence.  About 43000 of them were `dw $0000` slots turned into a
  label because something was named at 00:0000; `$0000` is no longer substituted (now 10007).
* Retracted: MBC register names for `ld [a16], sp` (an sp store is not a bank-switch write); only `ld [a16], a` gets them.
* Added: rgbasm function tokens (`div`, `strlen`, `endu`, ...) and every non-address `DEF` name of `hardware.inc` are rejected
  as names at load time (previously they failed late, inside rgbasm, with a syntax error).
* Timing claims (4.3 s for a full regen) hold only for a config that leaves the zero padding alone; a config that decodes
  every byte of the 2 MiB ROM (zero bytes as `nop`) takes about 11 s on the same machine, generation alone.
* `--strict` did not reach the warnings raised while the model is built (RAM-name shadowing of a hardware register); `Model` now
  gets the flag, so those warnings and the convention-entry warning are errors under `--strict` (`selftest_gen.py`, `conv_config`).
* Retracted (conventions review): "the 5274 sites match the recon count of 5274 `CD D1 06` patterns".  The sweep has 5273
  `farptr` + 1 `inline_dw` = 5274 sites; the census has 5274 `CD D1 06` (+1 `CD BC 06`) patterns, one of which (68:784E) is
  not an instruction start in the sweep.  The equal totals are a coincidence.  The site "oracle" of `sweep_conv` is a
  second implementation of the rule, not an independent decoder.
* Downgraded (conventions review): `jp`/`rst` consumption of inline bytes is a generator choice, HYPOTHESIS for `farptr`
  (FarCall reads its bytes through the return address popped from the stack, which only a `call` pushes); the ROM has 0
  `jp $06D1` / `jp $06BC` patterns, so it has never been exercised on real data (only on synthetic tests).  Bytes stay
  exact either way (they are re-emitted as `dw`/`db`), only the rendering could mislead.
* Verified (conventions review): `make verify` IDENTICAL, `selftest_gen.py` all pass; duplicate rows, unknown layout/status,
  entry outside the bank window, an adopted `data` region cut to 2 bytes, a label inside the inline bytes, and a merged
  code region all fail loudly on a copy of the real config (exit 1, message names the edge); the real ROM has no far
  pointer whose bank byte disagrees with its `dw` window (2239 bank byte 0 with `dw < $4000`, 3035 in-window), so those
  cases are covered by synthetic tests only; a mutated `far_loc` that pairs a ROM0 label with a non-zero bank byte makes
  `conv_kinds` fail at assembly/compare.
