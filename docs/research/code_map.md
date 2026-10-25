# ROM-wide code/data map (`tools/mapper.py`)

**Addresses (`bank:addr`) remain valid**: find the code with `grep -rn '; BB:AAAA' --include=*.asm .` or in `build/mobile_trainer.sym`.

### 1.1 Code: layered recursive descent

Not used as a seed: `sdk_function_map` (Crystal opcode alignment).  It also "aligns" text such as `RCPT TO:<` (75:60AB decodes as
`ld d,d ; ld b,e ...` in both ROMs), so identity of an opcode stream is not evidence of code (108 of its entries were rejected for decoding into padding or illegal opcodes
and others decoded into text).

Layers 1-2 iterate to a fixpoint; ROM0 -> ROMX call-site banks learned from MBC writes (`cfg.infer_call_banks`) restart the whole run.
Only **executed** instruction starts are protected; nothing else is trusted:

### 1.2 Status of a code byte

* Labels: `Function_BB_ADDR` only where the region starts at an address with executed proof (target of a `call`/`rst`/interrupt in the   dynamic call graph, or the far target of an executed far call); everything else stays unnamed (the generator makes generic names).

### 1.3 Data claims and precedence

Claims are painted after the code, highest priority first; a claim only takes bytes that no higher claim took, and every lost byte is
logged (`report.md` section 6).  Order: **executed/guaranteed code > inline bytes of conventions > statically reached code >
verified data (CONFIRMED gfx/tilemap loads of `gfx_candidates.tsv`, CONFIRMED strings, survey structures marked "verified structure":
HTML store, JIS font banks) > code-pointer tables > PROBABLE data (strings, survey text/gfx/palette/tables) > bytes read as data by
executed code (kind `data`, CONFIRMED, "content class unknown") > padding**.  HYPOTHESIS survey items are not used, except that `zero`
proposals are kept when the bytes really are all zero.  Survey `ptrtable` claims of 3-byte far pointers (HTML index) become `data`;
`ptrtable` fragments keep the original 16-bit grid (misaligned leftovers fall to unclassified).

Inline jump tables (`call $0545` variable length, `call $056A` five words) are emitted as separate `ptrtable` regions right after the call (generic labels `dw Label_BB_ADDR` then come from the generator, in the right bank).

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

(b) **Rebuild**: merging the 84 proposals into a temp copy of `config/` and running `tools/gen_asm.py verify` prints `RESULT: IDENTICAL` for **both** modes (`merge_proposals.py --dry-run`): conventions ON (inline bytes inside their code region, the repo's `config/conventions.tsv`) and conventions OFF with the inline bytes split into `data` regions.

`gen_asm.py check --strict` also passes, and `tools/conventions_check.py --strict` reports 5275 convention sites, 5268 ok in my regions + 7 adopted in bank 00, 0 ERROR.

(c) **No instruction crosses a region boundary**: every code region is re-swept with the generator's rule (`sweep_region`) and lands
exactly on its end (2 319 regions, 0 failures); no decoded instruction has a region boundary inside it; regions tile every bank
(no gap, no overlap, no odd `ptrtable`, every `zero` region all-zero).

(d) **Statistics**: section 2 above and `report.md` sections 2-3 (per bank: non-zero bytes, code C/P, ptrtable, text, gfx, data, zero,
FF, UNCLASSIFIED, executed instructions and executed bytes / non-zero bytes).

## 5. Limits and unresolved constructs

* **Unknown spans hide code**: ~11 KB of the unclassified bytes are code-like (`code_candidates.tsv`), typically function prologues in   front of the first far-call site (linear decode is legal and lands exactly on the following code, often with a `call` to a known function:   the hint `code-prefix-like` was right in 5 of 5 audited spans; `code-prefix-weak` only in 1 of 3; `text-like` in 3 of 5; `ptrtable-like` in 1 of 1).

`push bc ; push de ;   ret` at 00:0B4E is the only computed call resolved by hand (bank 00).

* **Bank of `jp`/`call` from ROM0** into `$4000-$7FFF` is inferred from the MBC write before the call (`cfg.infer_call_banks`, PROBABLE).

* **Dead code with stale targets** exists (`call $21A0` into ROM0 padding at 65:4843 and 65:4872; `call $58C4`, `$5FA2`, `$6DD0` at   2E:4A15/4A1B/4A2C whose targets are junk, padding and a table of tile numbers).

* **Mid-instruction entries**: `call $4441` at 2A:5760 enters the second byte of `ld a,$00` at 2A:4440 (an idiom that skips an instruction).

* Executed code that is also read as data outside the far-call inline bytes: none in the mapped banks except 2 bytes of PROBABLE code at   5C:5479 (suspect).

Result: 22    tables (198 entries); code bytes unchanged (0 lost, the removed tables added no code), 11 bogus walk bans disappeared (16 -> 5), the removed tables' bytes are    now UNCLASSIFIED or gfx (about +2 KB unclassified) and would no longer make `dw Label_00_xxxx` labels inside bank 00. 2.

`call $4441` (2A:5760, an instruction-skipping entry into `ld a,$00` at 2A:4440) was banned and the    aligned loop 2A:4440-4457, the fall-through of executed-flow code at 2A:443D, was left as an UNCLASSIFIED span while the report claimed "the    aligned decoding wins".

Fixed (`BanOwner`); 2A:4312-445F is now one PROBABLE code region (+23 bytes of code).

**Bug: zero "padding" overlapped bytes executed code read.**  Survey `zero` claims outranked read-as-data claims: 8 zero runs (22:5FB0, 29:5B10,    29:5DA0, 2C:4DF0, 48:69AB-69CA inside "trailing padding", 5D:7B70, 68:67EC, 22:66CF) were read by executed instructions.

**Corrected numbers:** "144 KB read as data" was really 77 KB (the rest were call-site claims); the text note of bank 6C claimed Shift-JIS, but that bank uses the    PROBABLE second convention (note changed); `code_candidates.tsv` header no longer says "a fifth of the spans are code" (two samples: 6/30 and 5/30 spans,    8 % and 2.4 % of the sampled bytes). 6.

**Not found, checked:** any CONFIRMED call/jump/table edge into a span the map labels data/unknown (the only targets that are not code starts are the five discarded junk walks 00:21A0 (padding), 2E:58C4 / 2E:5FA2 / 2E:6DD0 (illegal opcode / padding), and the 2A:4441 mid-instruction entry); a code region ending in something other than a terminator a following inline table (the 50 non-terminator run ends are all `call $0545/$056A` with their table, plus one `seq` at 2A:4440, now fixed).

## Current executed-start precedence revalidation

The mapper instead retained the unexecuted `CALL $4441` path from `2A:5760`, assigning the immediate byte as a one-byte `nop` and leaving `4440` unclassified.
