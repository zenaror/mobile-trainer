# ROM-wide code/data map (`tools/mapper.py`)

> **Historical note.** Written when the source was one generated `src/bankNN.asm` per bank with generic `Label_BB_AAAA` labels.  In the current tree (`home/ engine/ data/ gfx/ audio/ lib/`) a `Label_BB_AAAA` that is only used inside its own function is a local label of that function (`.lAAAA`, `AAAA` = the address, or `.loop`/`.done`/`.skip`); one referenced from elsewhere keeps its global name; `Function_BB_AAAA`, `Data_BB_AAAA`, ... are unchanged, and where a semantic name was adopted the neutral name often remains as an alias label under it.  **Addresses (`bank:addr`) remain valid**: find the code with `grep -rn '; BB:AAAA' --include=*.asm .` or in `build/mobile_trainer.sym`.  Commands of the frozen bootstrap pipeline quoted here (`make regen`, `make verify`, `make tree*`, `tools/gen_asm.py ...`) no longer apply to the source (`gen_asm.py` only runs into a temp dir, `make legacy-check`); see `README.md`, "History", and `docs/README.md`.

Evidence vocabulary: **CONFIRMED** (demonstrated: executed in a trace, byte-exact against documented code or bytes, checked by
hand), **PROBABLE** (strong evidence, not conclusive), **HYPOTHESIS** (unverified).  Addresses are CPU addresses
(`bank:addr`, bank 00 = `0000-3FFF`, banks 01-7F = `4000-7FFF`, file offset = `bank*0x4000 + (addr & 0x3FFF)`).

This stage turns every piece of evidence the earlier stages produced into a **region proposal for each of the 84 non-empty
banks other than bank 00** (`analysis/mapper/bankNN.tsv`, `config/regions` format, tiling the bank window exactly).
Nothing in `config/` was written by the mapper: the orchestrator merges with `tools/merge_proposals.py` after verification.

```
python3 tools/mapper.py                  # ~17 s: writes analysis/mapper/* (deterministic: byte-identical over runs and hash seeds)
python3 tools/mapper.py --holdout        # ~7 s: hold-out experiment -> analysis/mapper/holdout.md
python3 tools/mapper.py --banks 04,23    # write only these bank files (the analysis is always ROM-wide)
python3 tools/merge_proposals.py --dry-run   # temp copies of config/: rebuild proof for both convention modes
python3 tools/merge_proposals.py             # merge banks that have no config/regions file yet (verified, rolled back on failure)
```

| output | content |
|---|---|
| `analysis/mapper/bankNN.tsv` | regions `start end kind label status note` of 84 banks (5 938 regions) |
| `analysis/mapper/conventions_proposed.tsv` | `config/conventions.tsv` rows with the census that supports them |
| `analysis/mapper/inline_tables.tsv` | the 49 inline jump tables of `call $0545` / `call $056A` (no layout exists for them) with their proof |
| `analysis/mapper/unknown_spans.tsv` | every UNCLASSIFIED span: `bank start end length hint`, largest first (1 497 spans, 118 271 bytes) |
| `analysis/mapper/code_candidates.tsv` | the unknown spans that look like code, with the start of each decode chain (HYPOTHESIS input for a later stage) |
| `analysis/mapper/report.md` | statistics per bank, far-call census, discarded walks, collision log, suspicious spots, validation |
| `analysis/mapper/audit.md`, `audit_samples.txt` | the hand audit (30 PROBABLE code regions, 30 unknown spans; second sample and the verifier's own 12+8 regions) and the deterministic sample it reads |
| `analysis/mapper/holdout.md`, `stats.json` | hold-out experiment; the numbers of the report in machine-readable form |

## 1. Method

### 1.1 Code: layered recursive descent

`tools/cfg.py` (the recursive-descent explorer of the ROM0 stage) is run **layer by layer**: `CFG.run()` is re-entrant, and every
layer runs to completion before the next one starts, so a weaker layer can never take bytes from a stronger one (first come, first
owns).  Inline bytes after a call to an inline-data helper are recorded as data and never decoded; the ROM0 conventions of
`analysis/rom0_analysis.py` are used unchanged (`06D1` FarCall 3 bytes, `06BC` 2 bytes, `0545` variable table, `056A` five words,
`072E`/`0716` far jumps, the 13 bank-4 stubs, the RAM interrupt thunks).

| layer | seeds | what it adds |
|---|---|---|
| 0 | the 43 265 executed instruction starts of `analysis/coverage_union.tsv` (ROM rows; WRAM/HRAM rows are reported, not mapped) and the boot/vector seeds of `rom0_analysis.PROVEN_SEEDS` | static flow from executed code: conditional branch sides, call targets, far-call targets, jump-table entries |
| 1 | raw `call $06D1 / $06BC / $0545 / $056A` byte patterns in bytes layer 0 did not reach (5274 `CD D1 06` sites exist; 7 are in ROM0, 4428 ROMX sites are reached from executed code, **839 are not**) | the code around each site. A site is accepted only if its far target agrees: a ROM0 target must be a known ROM0 instruction start, a ROMX target must be in a used bank and decode cleanly. 826 of the 839 targets already land on a known instruction start (independent agreement); the other 13 decode as ordinary code |
| 2 | (a) the 34 API entries, 37 SDK states and 13 mail selectors of `analysis/mobile_candidates.json` (decoded from ROM tables), (b) tables of code pointers found by scanning every bank at every alignment, (c) tables behind the local dispatch idiom `ld hl,TABLE ; ... ; ld a,[hli] ; ld h,[hl] ; ld l,a ; jp hl` of a layer 0-1 `jp hl` (2 new tables: 4E:589B, 55:66D9) | entries that decode cleanly. A scanned table needs: start = operand of a `ld r16` **or** a survey pointer-table extent with >= 3 hits **or** >= 6 words with >= 5 hits at >= 70%, where a *hit* is a word `>= $4000` that lands on an instruction start of the table's own bank in layer 0-1 code (never of table-derived code: no self-amplification; ROM0 words are tolerated inside a table but are no evidence); tables never overlap known code, inline bytes or CONFIRMED data. **22 tables (198 entries, including the two dispatch-idiom tables)** are accepted (verifier-corrected, see section 6: a hit only counts when the word points into the table's own bank, `>= $4000`; the first version accepted 137 tables, 102 of which were tile-map bytes whose words are ROM0 "code starts" by chance) |

Not used as a seed: `sdk_function_map` (Crystal opcode alignment).  It also "aligns" text such as `RCPT TO:<` (75:60AB decodes as
`ld d,d ; ld b,e ...` in both ROMs), so identity of an opcode stream is not evidence of code (108 of its entries were rejected for decoding into padding or illegal opcodes
and others decoded into text).

Layers 1-2 iterate to a fixpoint; ROM0 -> ROMX call-site banks learned from MBC writes (`cfg.infer_call_banks`) restart the whole run.
Only **executed** instruction starts are protected; nothing else is trusted:

* **Bans.**  After each round every walk that ended in trouble is discarded and the run restarts without it: a straight-line run that
  falls into an illegal opcode or into padding (the walk origin is banned), a call/jump target that is itself junk (the *target* is
  banned, the calling instruction stays code), two conflicting decodings (the weaker walk by layer, then by discovery hops, is banned).
  Executed code is never banned.  5 walk origins are banned in 2 rounds (`report.md` section 5 lists them with the reason: the
  `call $21A0` in 65:4843/4872 that lands in ROM0 padding, `call $58C4` / `$5FA2` / `$6DD0` in 2E:4A15/4A1B/4A2C that land in junk, and `call $4441` in
  2A:5760 that enters the middle of the `ld a,$00` at 2A:4440: the aligned decoding wins).  A banned node is only a *marker* that stops a walk
  arriving at exactly that address (`BanOwner`); it does not block an instruction that merely contains the address (verifier fix, section 6).
  The first version banned 16 origins; 11 of them were walks into the false ROM0-word tables.

### 1.2 Status of a code byte

* **CONFIRMED** = executed in a trace (or *guaranteed* to execute right after executed code: fall-through of a non-branching
  instruction, target of an unconditional `jp/jr/call`; the closure `certain_closure` also refuses to cross an MBC ROM-bank write in
  ROMX code).  In the 84 mapped banks the closure adds **no** instruction beyond the executed ones (the traces run every basic block to
  its end); it adds only 13 instructions, all in bank 00 or in RAM images.  CONFIRMED code bytes = 80 235 executed instruction bytes + 6 548 inline
  far-call bytes (executed sites: the inline bytes are read as data at run time, which is the demonstration that they are data).
* **PROBABLE** = decoded by static flow from anything above: from executed code (conditional-branch sides that never ran, callees of
  unexecuted branches), from a validated raw far-call site or table entry.  The region note says which seed class and, for the first
  instruction of the run, why the run starts there (`entered by call from 04:4123 (executed)`, `fall-through of the jrcc at 04:409D
  (executed)`, `run starts at a raw CD D1 06 pattern site ...`).
* A code region never mixes statuses: a run is cut where the status changes (about 2 300 code regions; `merge_proposals.py --coalesce`
  joins contiguous code regions with status = the weakest member if a less fragmented source is preferred).
* Labels: `Function_BB_ADDR` only where the region starts at an address with executed proof (target of a `call`/`rst`/interrupt in the
  dynamic call graph, or the far target of an executed far call); everything else stays unnamed (the generator makes generic names).

### 1.3 Data claims and precedence

Claims are painted after the code, highest priority first; a claim only takes bytes that no higher claim took, and every lost byte is
logged (`report.md` section 6).  Order: **executed/guaranteed code > inline bytes of conventions > statically reached code >
verified data (CONFIRMED gfx/tilemap loads of `gfx_candidates.tsv`, CONFIRMED strings, survey structures marked "verified structure":
HTML store, JIS font banks) > code-pointer tables > PROBABLE data (strings, survey text/gfx/palette/tables) > bytes read as data by
executed code (kind `data`, CONFIRMED, "content class unknown") > padding**.  HYPOTHESIS survey items are not used, except that `zero`
proposals are kept when the bytes really are all zero.  Survey `ptrtable` claims of 3-byte far pointers (HTML index) become `data`;
`ptrtable` fragments keep the original 16-bit grid (misaligned leftovers fall to unclassified).

Inline jump tables (`call $0545` variable length, `call $056A` five words) are emitted as separate `ptrtable` regions right after the
call (generic labels `dw Label_BB_ADDR` then come from the generator, in the right bank).  Their length is CONFIRMED only when an
executed instruction starts exactly at their end and every byte was read as data in a trace (the `056A` tables have a fixed length of five words); 8 of
the 27 `0545` tables have their end pinned by an executed instruction and 7 ends are heuristic guesses (`inline_tables.tsv`).

Everything left is `data` + `Data_BB_ADDR` + HYPOTHESIS + note `UNCLASSIFIED ...` (search for that word).  Runs of >= 16 x `00` inside
unclassified bytes (and any `00` run to the end of a bank) become `zero` "padding?" HYPOTHESIS; runs of >= 16 x `FF` become `data`
"run of x $FF (padding?)".

## 2. Results (mapped banks: 84 x 16 KiB = 1 376 256 bytes; 785 741 non-zero)

| kind | CONFIRMED | PROBABLE | HYPOTHESIS |
|---|---|---|---|
| code | 86 783 | 122 432 | |
| ptrtable | 270 | 1 406 | |
| text | 20 582 | 20 364 | |
| gfx | 144 432 | 271 617 | |
| data | 115 868 | 41 298 | |
| zero | | 413 034 | 18 959 |
| UNCLASSIFIED data | | | 118 271 |
| FF runs | | | 917 |

* **Code:** 209 238 bytes (10 % of the ROM) = 86 783 CONFIRMED + 122 455 PROBABLE; 2 319 code regions.  Of the 5274 far-call sites of
  the ROM every one lies in a code region, and every far pointer targets a code region of the merged map (0 exceptions,
  `tools/conventions_check.py`).
* **Unclassified:** 118 271 bytes (15.1 % of the non-zero bytes) in 1 497 spans; the biggest are tile/tile-map data without any
  call-site evidence (banks 41-47, 5B, 60, 4B ...).  Per bank and per kind: `report.md` section 3.
* Bank 00 is untouched; cross-check: the 2 934 ROM0 instructions reached by the exploration are all code starts of the hand-reviewed
  `config/regions/bank00.tsv` (0 outside), which has 3 325 code starts (the rest is hand-classified code not reachable from the seeds).

## 3. Validation

(a) **Executed starts**: all 43 265 executed instruction starts lie at an instruction start of a proposed code region of the right bank
(bank 00: `config/regions/bank00.tsv`); 0 missing.  `mapper.py` runs this on every execution and exits 1 otherwise.  Two more cross-checks against
earlier stages: all 5 290 rows of `analysis/farcall_targets.tsv` (23 CONFIRMED, 3 877 PROBABLE, 1 390 HYPOTHESIS) target an instruction start of a
code region, and 1 378 of the 1 379 ROM entries of `analysis/entrypoints.json` are code starts of the map (the exception is the mid-instruction
`call` target 2A:4441, see the limits).

(b) **Rebuild**: merging the 84 proposals into a temp copy of `config/` and running `tools/gen_asm.py verify` prints `RESULT: IDENTICAL`
for **both** modes (`merge_proposals.py --dry-run`): conventions ON (inline bytes inside their code region, the repo's
`config/conventions.tsv`) and conventions OFF with the inline bytes split into `data` regions.  `gen_asm.py check --strict` also passes,
and `tools/conventions_check.py --strict` reports 5275 convention sites, 5268 ok in my regions + 7 adopted in bank 00, 0 ERROR.  The real
merge was exercised on temp copies: full merge, refusal to touch existing files and bank 00, `--force`, `--legacy-split`, `--coalesce`, and
a deliberately broken proposal that was rolled back (file removed, exit 1).

(c) **No instruction crosses a region boundary**: every code region is re-swept with the generator's rule (`sweep_region`) and lands
exactly on its end (2 319 regions, 0 failures); no decoded instruction has a region boundary inside it; regions tile every bank
(no gap, no overlap, no odd `ptrtable`, every `zero` region all-zero).

(d) **Statistics**: section 2 above and `report.md` sections 2-3 (per bank: non-zero bytes, code C/P, ptrtable, text, gfx, data, zero,
FF, UNCLASSIFIED, executed instructions and executed bytes / non-zero bytes).

(e) **False-positive audits** (`analysis/mapper/audit.md`, hand-checked): 30 PROBABLE code regions with no executed instruction
(10 reached from executed code, 10 from raw far-call sites, 10 from tables): 30/30 plausible (legal decode, terminators, 309/309 direct
targets sane and on instruction starts, coherent register use), two with a register-use doubt (04:4997 and 04:4B66, an `inc de` with no
obvious purpose) and one open question (7F:4284 starts with `pop hl`).  30 unknown spans (author's sample, of the pre-fix population): 6 real
code (five short prologues/stubs and one 213-byte routine; 8 % of the sampled bytes).  The verifier's own sample of 30 unknown spans (post-fix
population, `audit.md` section B): 5 real code (95 of 4 014 sampled bytes = 2.4 %), 4 text, 21 data.  About 11 KB of the 118 KB are
`code-like` / `code-prefix-*` by the hint, an upper bound (the hints are heuristics and were wrong about half of the time in the verifier's sample).

**Hold-out experiment** (`--holdout`, independent of my judgement): the map is rebuilt from the 9 even-position scenarios only; the
8 519 instructions (bank != 00) executed *only* by the other 9 scenarios are ground truth code.  97.5 % (8 306) are found as PROBABLE code
at the right instruction start, 2.5 % (213) fall in unclassified bytes, **0 are misaligned**; of the PROBABLE instruction starts of that
partial map, 8 306 are confirmed by the full traces and **0 are contradicted** (none falls inside an executed instruction).  This
measures alignment precision and recall of the static discovery in code that some run reaches; it says nothing about code that no trace
reaches (such code has no ground truth).

## 4. Conventions and inline data

`analysis/mapper/conventions_proposed.tsv`: `00:06D1 farptr` and `00:06BC inline_dw` (both already in `config/conventions.tsv`; the
mapper repeats them with its census: 5274 `CD D1 06` sites, 2189 executed, all decoded; 1 `CD BC 06` site, executed).  **No further
convention is proposed, on purpose:**

* `072E` FarJump, `0716`, `06E5`, `0540`, `0551`: no `call`/`jp` byte pattern for any of them exists in the ROM (scan of all banks).
* `0545` JumpTableInline (27 sites) and `056A` JoypadDispatch (22 sites) read variable/10-byte tables: no layout can express them;
  emitted as `ptrtable` regions instead (18 of the 49 tables are CONFIRMED, 31 PROBABLE).
* Helper candidates (a call target whose first instruction is `pop rr`): the only one among all reached call targets is `00:0545`
  itself.  The traces show exactly six callee groups whose fall-through never ran: `06D1`, `0545`, `056A`, `06BC` and two ordinary
  functions (23:4B51, 2D:5691) that never returned in any trace; their fall-through bytes decode as ordinary code.

## 5. Limits and unresolved constructs

* **Coverage is not exhaustive and absence of coverage proves nothing.**  PROBABLE code is static flow only; the hold-out result shows the
  method is sound where a trace can check it, not that it holds where nothing can.
* **Unknown spans hide code**: ~11 KB of the unclassified bytes are code-like (`code_candidates.tsv`), typically function prologues in
  front of the first far-call site (linear decode is legal and lands exactly on the following code, often with a `call` to a known function:
  the hint `code-prefix-like` was right in 5 of 5 audited spans; `code-prefix-weak` only in 1 of 3; `text-like` in 3 of 5; `ptrtable-like` in 1 of 1).
  They are deliberately **not** promoted (a hand audit found real code in 6 of 30 spans, text and tables/data in the rest).
* **Indirect transfers are not followed**: 34 `jp hl` / `push rr ; ret` sites in decoded code (per bank in `report.md` section 7); their
  targets are known only when the executed ones appear in the dynamic call graph or a code-pointer table is found.  `push bc ; push de ;
  ret` at 00:0B4E is the only computed call resolved by hand (bank 00).  Tables of unknown length: the 7 heuristic inline-table ends; scanned
  tables are cut at the first implausible word and never extended beyond survey extents.
* **Bank of `jp`/`call` from ROM0** into `$4000-$7FFF` is inferred from the MBC write before the call (`cfg.infer_call_banks`, PROBABLE).
* **RAM code**: the only executed RAM code is bank 00's (interrupt thunks CBF1-CBFD, `C133` thunk installed by 48:440A, OAM DMA at FF80,
  the far-call trampoline at FFA8); no ROMX bank stores RAM code that any trace runs; a copier the traces never reach would be invisible.
* **Dead code with stale targets** exists (`call $21A0` into ROM0 padding at 65:4843 and 65:4872; `call $58C4`, `$5FA2`, `$6DD0` at
  2E:4A15/4A1B/4A2C whose targets are junk, padding and a table of tile numbers).  Those calls are kept as code (their bytes are valid instructions), their targets are left out; the
  suspicious spots are listed in `report.md` sections 5 and 7.
* **Mid-instruction entries**: `call $4441` at 2A:5760 enters the second byte of `ld a,$00` at 2A:4440 (an idiom that skips an instruction).
  One decoding is emitted (the aligned one, 2A:4312-445F, PROBABLE; before the verifier fix the loop 4440-4457 was wrongly left UNCLASSIFIED);
  the generator keeps such operands numeric.
* **Heuristic data classes stay PROBABLE**: the survey's tile-coherence gfx and palette/tile-map classes are not proven by this
  stage; only call-site loads from an **executed** call site (144 KB gfx) are CONFIRMED (the 133 claims whose call site no trace executed are
  downgraded to PROBABLE by the verifier).  A `gfx` region is "looks like 2bpp tiles", `data` is "bytes", `text` is
  "Shift-JIS/ASCII".  Fixed-length record structures (e.g. the 69-byte messages of bank 72) are not modelled here.
* **`read as data` regions** (77 KB, CONFIRMED; the first version of this file said 144 KB, which mixed in the call-site claims) prove that executed code read those bytes, not what they are; the same bytes could be part
  of a bigger structure whose other bytes were never read.
* Executed code that is also read as data outside the far-call inline bytes: none in the mapped banks except 2 bytes of PROBABLE code at
  5C:5479 (suspect).
* The mapper assumes the generator's conventions: inline bytes after `call/jp/rst` to a convention entry.  With conventions off,
  `merge_proposals.py` splits them into `data` regions (verified).

## 6. Verification pass (adversarial verifier) - corrections and retractions

An independent re-derivation (own sweeper over the TSVs, own edge/coverage checks; scratch scripts not committed) re-ran the mapper from scratch
(bit-identical outputs, all 15 unit tests pass) and **confirmed**: tiling of all 128 banks, 0 illegal opcodes and 0 region-boundary crossings in any code
region, all 43 265 executed starts at an instruction start of a code region, every CONFIRMED code instruction executed, no PROBABLE region containing an
executed instruction, all direct `jp/jr/call/rst` targets and all 5 290 far-call targets of the code map landing on code starts (only the five banned
walk targets and the 2A:4441 mid-instruction entry do not), every `entered by X from A` / `fall-through of the X at A (executed)` note
(1 063 checked) consistent with the cited instruction, the 49 inline tables (`call $0545`/`$056A` before the table, all words on code starts, 8 ends pinned
by an executed instruction), the two counts of raw byte patterns (`072E`, `0716`, `06E5`, `0540`, `0551`: none; `0545`: 27 calls; `056A`: 22),
the executed-code-read-as-data count (only 5C:5479, 2 bytes) and an opcode histogram of PROBABLE vs CONFIRMED code (same shape, 0.005 % implausible
I/O or MBC-area stores).  What it **found wrong** and what was changed:

1. **Retracted: "137 code-pointer tables accepted" (claim C13).**  102 of the 137 had every word in `$0150-$3FFF`: tile-map / attribute bytes such as
   `0A 0A`, `10 10`, `11 11` (43:5907.., 50:43D4.., 71:5067.., 41:6657 with 140 "entries") that hit one of bank 00's ~3 300 instruction starts by chance
   (20 % density), plus stride tables such as 4E:4578 (`0194 01B3 01D2 ...`).  The dense-run rule now counts only hits on the table's own bank.  Result: 22
   tables (198 entries); code bytes unchanged (0 lost, the removed tables added no code), 11 bogus walk bans disappeared (16 -> 5), the removed tables' bytes are
   now UNCLASSIFIED or gfx (about +2 KB unclassified) and would no longer make `dw Label_00_xxxx` labels inside bank 00.
2. **Bug: the ban marker blocked legitimate code.**  A banned node was entered as `owner[node] = (-99, 0)`, which also made every instruction *containing*
   that address an `overlaps_instruction` clash.  `call $4441` (2A:5760, an instruction-skipping entry into `ld a,$00` at 2A:4440) was banned and the
   aligned loop 2A:4440-4457, the fall-through of executed-flow code at 2A:443D, was left as an UNCLASSIFIED span while the report claimed "the
   aligned decoding wins".  Fixed (`BanOwner`); 2A:4312-445F is now one PROBABLE code region (+23 bytes of code).  Only bank 2A was affected.
3. **Bug: zero "padding" overlapped bytes executed code read.**  Survey `zero` claims outranked read-as-data claims: 8 zero runs (22:5FB0, 29:5B10,
   29:5DA0, 2C:4DF0, 48:69AB-69CA inside "trailing padding", 5D:7B70, 68:67EC, 22:66CF) were read by executed instructions.  They are now cut out of the zero claims and
   become `data` (CONFIRMED, read as data).  Banks 22, 29, 2C, 48, 5D, 68.
4. **Downgrade: 133 CONFIRMED gfx/data claims** (90 KB) came from `extract_gfx` call-site immediates whose call site no trace executed; they are PROBABLE now
   (CONFIRMED gfx 205 696 -> 144 432 bytes).  The status of an inherited claim is only as good as its code.
5. **Corrected numbers:** "144 KB read as data" was really 77 KB (the rest were call-site claims); the text note of bank 6C claimed Shift-JIS, but that bank uses the
   PROBABLE second convention (note changed); `code_candidates.tsv` header no longer says "a fifth of the spans are code" (two samples: 6/30 and 5/30 spans,
   8 % and 2.4 % of the sampled bytes).
6. **Wording:** in a PROBABLE region the note `seeds: exec xN` is the class of the walk's root seed (an executed instruction is the root), not a statement that
   the N instructions were executed; PROBABLE regions never contain an executed instruction.

**Not found, checked:** any CONFIRMED call/jump/table edge into a span the map labels data/unknown (the only targets that are not code starts are the five
discarded junk walks 00:21A0 (padding), 2E:58C4 / 2E:5FA2 / 2E:6DD0 (illegal opcode / padding), and the 2A:4441 mid-instruction entry); a
code region ending in something other than a terminator or a following inline table (the 50 non-terminator run ends are all `call $0545/$056A` with their table, plus
one `seq` at 2A:4440, now fixed).  **Still open (unchanged):** PROBABLE code reached from no trace has no ground truth (87.7 % of PROBABLE starts); the audit
samples are a reading, not proof.
