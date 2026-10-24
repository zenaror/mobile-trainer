# Japanese ROM closure audit (2026-10-23)

## Scope and result

This report consolidates the verifiable Japanese-ROM requirements. The
original audit was recorded at `91e1c957437e24b3837e87fdf0a210c9abac54f3`;
the latest source and gate revalidation is recorded below at
`9f077cd0d64cbfb6869b80d7278f771749b61f67` on
`codex/japanese-census-ram-ledger`. It uses only the canonical checkout
`/home/rafael/_PROJETOS/Mobile Trainer`; the English overlay and Operator ZIP
remain paused and were not examined.

| Requirement | Current evidence | Status and limit |
|---|---|---|
| Reconstruct the original ROM byte for byte | `make` compares the 2 MiB output against ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570` | **PASS — `RESULT: IDENTICAL`** |
| Avoid generic function labels | Current Japanese census: zero strict address-only globals, zero generic function prefixes, zero unreviewed generic-marker labels; 15 coverage families, zero open | **CLOSED for the audited lexical families.** This does not identify every unlabelled or unreachable code span. |
| Reconcile generic-looking data, local, RAM and resource names | Current ledgers match 2,764 local anchors, 106 strict bank/address suffix rows, 540 broad union rows (434 address-suffix and 269 Candidate labels, with 163 overlapping), and 786 RAM rows; 58 owner-qualified bank-suffix path names are individually dispositioned. The RAM partition has 104 exact bank overlays and 56 container interiors. | **CLOSED for the census and ledgers.** Retained neutral names and `Candidate` qualifiers reflect documented evidence limits; they are not bare address-only names. |
| Reconcile function/operation-boundary clues | The 19 current comment clues map to named bounded operations; coverage row is `CLOSED` | **CLOSED.** They are not evidence of 19 separately callable or naturally reachable functions. |
| Identify candidate operations with no proven natural root | The five rows at 2B:6CF5, 2D:4E42/4E54, 29:511E and 70:4740 have bounded mechanical names and explicit UNKNOWN/HYPOTHESIS entry or role status in the worklist. A new full-ROM literal-target scan for `70:[4740,477F)` reconciled all same-bank and bank-qualified matches as data overlaps or graphics bytes; it found no aligned pointer to an instruction start. | **Evidence-limited.** Natural entry and role remain UNKNOWN/HYPOTHESIS; computed/stack-derived targets and execution outside the retained corpus remain open. No generic `Function_*` label remains; do not invent a root or purpose. |
| Track additional code/data spans outside that five-row operation worklist | `26:5344–537C`, `28:4BA6–4BC2`, and `4B:76CC–76D0` were checked against all 70 paired natural coverage, callgraph, and dataaccess reports at `1c9224e8`; each has zero exact instruction starts, zero direct call/rst/jphl edges, and zero overlapping data-read ranges in that corpus | **Finite corpus check closed; interpretation remains open.** This does not establish global unreachability or unused status; see the bounded result and manifest in `japanese_open_questions_followup_20261023.md`. |
| Verify Bank 53 Pokémon names and candidate frames | The 369-byte pointer/string block and 25 candidate windows (85,200 bytes) reproduce the original; the scoped inventory contains 137 assets, 71 PNGs, 24 previews and 17 editable views | **Finite extraction/presence check closed.** The 25 name-to-window associations and natural selection remain unknown. |
| Check unused frames and asset/PNG omissions | Eight incomplete editable compositions remain `KEEP` because the declared view model lacks backing keys. The source bytes and legacy previews exist; the scoped inventory found no missing referenced files or orphan asset/PNG files. | **No omitted ROM asset or referenced PNG found in scope.** The eight incomplete compositions are not missing ROM data or missing referenced PNGs. No frame is classified globally unused. |
| Reconcile GFX-plan residuals | At source checkpoint `6befa324`, `gfx_export.py plan` contains eight residual GFX spans, all under 16 bytes: `51:70D1`, six Bank 42 fragments, and `1A:4A85`. The earlier 13-span list was reconciled after full Page List, mail-title, and mailbox DMA windows were represented as assets; see `japanese_graphics_asset_completeness_followup_20261023.md`. | **CLOSED for byte extent and owner-boundary reconciliation.** There is no remaining complete-tile PNG candidate in this plan. Keep the original source spans and confidence; this does not identify every purpose or prove unused status. |
| Verify current PNG/catalog manifests | `make png-check`: 418 tile sheets, 4 raw views, 37 fonts, 95 screens; GFX catalog: 988 assets; PNG rules: 987 | **PASS** for current manifests and declared source models; this does not prove natural display on hardware. |

The census and ledgers are detailed in
[`japanese_generic_name_sweep_20261023.md`](japanese_generic_name_sweep_20261023.md),
[`japanese_name_audit_coverage_20261023.tsv`](japanese_name_audit_coverage_20261023.tsv),
and [`japanese_operation_boundary_worklist_20261023.tsv`](japanese_operation_boundary_worklist_20261023.tsv).
The bounded Bank 53/frame evidence and limits are in
[`bank53_names_frames_assets_audit_20261023.md`](bank53_names_frames_assets_audit_20261023.md).

## Current Japanese verification at `9a44ec66` (2026-10-24)

At canonical checkout `/home/rafael/_PROJETOS/Mobile Trainer`, commit
`9a44ec66c0003d6ead80420b76c0ad545a0f3fb7`, the Japanese source still builds
byte-for-byte to the protected 2 MiB original (SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`).
`make sym-check` passes with 335 source files, 12,214 labels and 51 constants;
`make palette-check` passes with 162 loads, 116 arrays, two documented
over-reads and zero errors; `make png-check` checks 418 tile sheets, four raw
byte views, 37 unique font PNGs and 95 screens. `gfx_export.py check` accepts
988 assets, including 39 font-binary rows using those 37 unique sheets, and
`png_rules.py mk-check` accepts 987 rules.

The current Japanese name census matches all 15 coverage families with zero
open families: 2,764/2,764 local anchors, 106/106 strict bank/address-suffix
rows, 540/540 broad name dispositions and 786/786 RAM equates. It reports zero
strict address-shaped globals, zero generic function prefixes, zero
unreviewed generic markers and zero generic `gfx/bankNN/` paths. `make test`
passes all suites (including 48 CFG, 24 palette-read and six retype-parts
tests); it emits the existing non-fatal `ResourceWarning` at
`tools/test_cfg.py:398`.

This checkpoint verifies the current build, audited naming families, declared
asset catalogs and tests. It does not turn the five bounded natural-entry
questions, the 25 Bank 53 name-to-window associations, natural frame selection
or universal used/unused status into confirmed results. Those remain
UNKNOWN/HYPOTHESIS until positive evidence is available. English/ZIP remain
paused.

## Validation records

### Revalidation at `9f077cd0` (2026-10-24)

The current published source adds only bank-1 scoped aliases for the frame,
second and minute bytes in the existing connection-time SRAM mirror; its fourth
byte remains without a semantic field alias. The Bank 53/frames/assets audit
was already finite and complete at its documented checkpoint: 25 Japanese
names and 25 candidate windows re-emit their bytes, its scoped 137-asset/71-PNG
inventory found no missing referenced or orphan files, and eight incomplete
editable compositions remain `KEEP`. This source change touched no Bank 53,
frame, asset or PNG files, so those unresolved name-to-window and global
used/unused questions were not reopened or promoted.

At `9f077cd0`, `make` returned `SHA-256 OK` and `RESULT: IDENTICAL` for the
2 MiB original (SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`).
`make sym-check` passed (335 source files, 12,214 labels, 51 constants);
`make palette-check` passed (162 loads, 116 arrays, two documented over-reads,
zero errors); `make png-check` passed (418 tile sheets, 4 raw views, 37 font
sheets, 95 screens); the GFX catalog passed (988 assets), PNG rules passed
(987), the RAM ledger passed (786/786), the name census matched all 15
families with zero explicitly open, and the banked-name check passed (240
names, 171 overlapping pairs, zero errors, 10 notes). This validates the
current rebuild and declared inventories, not runtime behavior or semantic
closure.

The follow-up also scanned the Japanese ROM for every `CE 50` byte pair as a
possible direct literal reference to the `29:50CE` wrapper. All four matches
were accounted for as three `ADC A,$50` immediates and bytes inside the
`4B:6A90–6E90` graphics asset; none is a direct pointer or control-flow target.
The retained 70-scenario coverage/callgraph corpus also has no exact start or
recorded destination at `29:50CE`. This does not rule out computed dispatch or
prove global unreachability; the candidate's natural root remains unknown. See
the bounded scan in
[`japanese_open_questions_followup_20261023.md`](japanese_open_questions_followup_20261023.md#bank-2950ce-exact-target-scan-at-9f077cd0-2026-10-24).

### Original closure-checkpoint validations (2026-10-23)

- `make`: original ROM SHA-256 OK; `RESULT: IDENTICAL`.
- `make sym-check`: 335 source files, 12,212 labels, 51 constants; OK.
- `make palette-check`: 162 loads, 116 arrays, 2 documented over-reads, 0 errors.
- `make png-check`: 418 tile sheets, 4 raw byte views, 37 font sheets, 95 screen PNGs; OK.
- `python3 tools/gfx_export.py check`: 988 catalog rows; OK.
- `python3 tools/png_rules.py mk-check`: 987 rules; OK.
- `python3 tools/japanese_name_census.py`: all current family counts and rows match; 0 explicitly open families.
- `make test`: all suites passed, including 48 CFG, 24 palette-read and 6 retype-parts tests. It emitted the known `ResourceWarning` for the open `baserom.gbc` reader at `tools/test_cfg.py:398`; the test result was `OK`.
- `git diff --check`: clean. No maintained RGBDS source or binary asset changed between `d13131ff` and this checkpoint; intervening work corrected path instructions, census wording and documentation.

## Current documentation-only revalidation at `91e1c957`

The live census was rerun at `91e1c957` after the documentation reconciliation and passes with 349 Japanese ASM/INC inputs, 1,879 tracked GFX paths, 2,210 active source/resource paths, 2,764/2,764 local anchors, 108/108 strict suffix rows, 542/542 broad union rows (436 suffix and 269 Candidate labels, overlapping by 163), and 786/786 RAM equates. All 15 coverage families match; no stale, missing, duplicate, incomplete, or address-mismatched disposition rows remain. The difference from the older 109/544 checkpoints reflects the 3d971282 GFX source-label/extent changes. Commit `91e1c957` changes only documentation; the last byte-identical build and other Japanese gates remain those recorded above at their explicitly named source checkpoint.

## Current revalidation and ledger correction at `8051e779` (2026-10-23)

After the 3d971282 static-DMA asset alignment, a fresh `python3 tools/japanese_name_census.py` exposed stale coordinates and three retired Mailbox source labels in the broad disposition ledger, plus the renamed Page List sources. Those rows and the coverage counts were reconciled to current source declarations and addresses. The census now passes with 349 tracked Japanese ASM/INC inputs, 1,879 GFX paths, all 15 families matched, 2,764/2,764 local anchors, 108/108 strict bank/address-suffix rows, 542/542 broad-name rows (436 address suffix and 269 Candidate, overlapping by 163), and 786/786 RAM equates. The retired Mailbox fragment names are absent because their former spans are now inside the full 25:69F0..6CF0 and 25:6CF0..6EF0 assets; no ROM bytes changed.

At the same checkout, `make` reports `SHA-256 OK` and `RESULT: IDENTICAL` for the original 2 MiB ROM; `sym-check` passes with 335 files, 12,212 labels and 51 constants; `palette-check` passes with 162 loads, 116 arrays, two documented over-reads and zero errors; `make png-check` passes with 418 tile sheets, four raw views, 37 font sheets and 95 screens; GFX catalog and PNG rules pass at 988 assets and 987 rules. `make test` passes all suites (including 48 CFG, 24 palette-read and six retype-parts tests); the known `ResourceWarning` for `baserom.gbc` remains non-fatal. `gfx_export.py plan` returns eight residual spans, all under 16 bytes.

The correction changes only documentation ledgers and counts. It does not add semantic claims, modify Japanese source/assets, or resume the English overlay/ZIP.

## Current direct-call entry-to-symbol reconciliation at `90c2a6e4` (2026-10-23)

A fresh `tools/mapper.py` run against the immutable Japanese ROM and the current 70-scenario trace corpus produced 414 bank-qualified `Function_BB_AAAA` rows for decoded direct-call/far-call entry candidates; all 414 carry the mapper note `entry proven: target of an executed call/far call`. Each row maps to an exact global symbol in the current Japanese `build/mobile_trainer.sym`; a separate comparison found 414/414 matches, zero missing global symbols, and zero generic function-prefix symbols among those matches. `make` confirms the 2,097,152-byte rebuild is `RESULT: IDENTICAL` to original SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; `make sym-check` passes with 335 source files, 12,212 labels and 51 constants.

The mapper exits with status 1 because it reports one executed-start mismatch at `2A:4440`; it has zero sweep failures, boundary crossings or tiling problems. This is the previously documented mid-instruction edge `2A:5760 CALL $4441`, which targets the second byte of the executed `ld a,$00` at `2A:4440`. The current source label `.l4440` and the trace's length-2 instruction row at `2A:4440` preserve the aligned loop decode; `2A:4441` is not established as an independent function. See [`code_map.md`](code_map.md#5-limits-and-unresolved-constructs) and [`original_closure_followup_20261021.md`](original_closure_followup_20261021.md#current-numeric-call-target-review-2026-10-22).

This reconciliation establishes symbol coverage only for the mapper's 414 direct call/far-call entry candidates. It does not validate the semantics of every name, identify every unlabelled code span, or close computed/indirect entry paths. Reproduction and pinned inputs/outputs are retained in `.tmp/jp-current-code-map-20261023/` and `.tmp/jp-code-entry-symbol-reconciliation-20261023/` (`MANIFEST.json` SHA-256 `97c2b028b24e294039ef2df1ccd467dac9d30f68220da1b8b18dabd19d619cfc`).

## Closure boundary

This closes the current **verifiable Japanese naming census and finite Bank
53/frame asset-presence audit**. It does not claim the whole ROM is semantically
understood or that every code fragment is naturally reachable. Five entry/role
questions remain evidence-limited as listed above; the Bank 53 name/frame
mapping, computed readers outside the inspected selector chain, natural frame
selection, and universal used/unused status also remain unknown. Reopen those
items only when a new source, caller, producer, trace, or other positive
evidence appears. The English translation remains paused until the Japanese
review is complete and the Operator explicitly authorizes resumption.

## Revalidation at canonical checkout `303acbaa` (2026-10-23)

The audit was revalidated in `/home/rafael/_PROJETOS/Mobile Trainer` at
`303acbaa591be7590bb6635893e89a334260e018`. The original build again reports
`SHA-256 OK` and `RESULT: IDENTICAL` for ROM SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`;
`sym-check` passes with 335 source files, 12,212 labels and 51 constants;
`palette-check` passes with 162 loads, 116 arrays, two documented over-reads
and zero errors. PNG, GFX-catalog, PNG-rule and Japanese-name-census checks
also pass with the counts above; all 15 census families are closed and all
current ledger rows match. `make test` passes all suites (48 CFG, 24 palette
read and 6 retype-parts tests, plus generator and SM83 checks). It emits the
known `ResourceWarning` for the open `baserom.gbc` reader in
`tools/test_cfg.py:398`; the command exits successfully. No assembly source,
asset or ROM input changed. This revalidation confirms the documented finite
scopes and byte identity; it does not promote any UNKNOWN/HYPOTHESIS item or
resume the English work.


## Bank 7C font pixel-inverse verification (2026-10-23)

At documentation commit `df4945b664fa5f6e8db15b69987be42de2e571c0`, the
current 846-cell bank-7C sheet was checked against `tools/font_png.py` rendering
from all three maintained spans (`7C:4000`, `7C:57C3`, `7C:57CD`). All 15,228
span bytes match the immutable original ROM at physical bank-7C offset
`0x1F0000`; decoded RGB pixels match the tracked 1221x116 PNG exactly
(141,636 pixels, zero differences), and decoding the PNG reconstructs each
span byte-for-byte. The old 10-byte/80-pixel gap is historical, not open in the
current source. Full method and PNG hash: [frame/name asset reconciliation](assets_pokemon_frames_and_name_limits.md#dated-verification-bank-7c-font-sheet-pixel-inverse-2026-10-23).

This is an asset-representation check only. No assembly, asset, ROM, build output,
or runtime claim changed; the earlier build gates remain tied to the unchanged
source checkpoint. All UNKNOWN/HYPOTHESIS entry, natural-selection, and
name-to-window relationships above remain unresolved.

## Direct Bank 48 read-PC witness (2026-10-23)

A bounded GDB hardware-watchpoint run on the ordinary-input `kbd_abook`
scenario captured one ROM read at bank `48`, physical offset `29AB` (CPU
address `69AB`), frame 4416, with the pre-instruction PC at `48:47D6`.
That instruction is `ld a,[bc]` inside `Font_BlitGlyph8x16`. The capture
An expanded capture records `BC=69AB` and shadow return `55:6C5C`; original
ROM bytes at `55:6C59` encode `farcall 48:4748`, the call from
`Kbd_DrawGlyphPreview`. This confirms the caller chain for this one event.
The older aggregate remains address-only, so this does not attribute every
event in its historical rows. The font-code argument, zero-byte
identity/intention, rendered output, global reachability, and hardware
behavior remain unknown. This is synthetic mGBA evidence, not a hardware
test. Full command, tool/input/output hashes, and limits are recorded in [the
Bank 48 reader note](font_reader_69ab_bounds_20261020.md#direct-read-pc-witness-2026-10-23) and
`.tmp/jp-zero48-pc-trace-20261023/RESULT-caller.json`.

## Japanese census and build gates at `d88444c2` (2026-10-23)

This section is a historical checkpoint, not the current count. The latest census at `91e1c957` matches all live ledgers: 2,764 local anchors, 108/108 strict suffix rows, 542/542 broad union rows (436 suffix and 269 Candidate labels, overlapping by 163), and 786/786 RAM equates; all 15 coverage families match. See the current reconciliation near the beginning of this report.

The maintained Japanese source and GFX paths were re-censused at the current
published checkout after the HelpScript and SRAM documentation updates.
`python3 tools/japanese_name_census.py` scanned 349 tracked Japanese ASM/INC
files and 1,875 tracked GFX paths. At that historical checkpoint, all ledgers
matched: 2,764/2,764 local anchors, 109/109 bank/address-suffix rows,
544/544 broad name dispositions, and 786/786 numeric RAM equates; all 15
coverage families were closed, with
zero unreviewed generic markers, address-shaped global definitions, or
generic bare `gfx/bankNN/` paths.

## Follow-up: indexed keyboard palette data name (2026-10-23)

At source snapshot `ba385306`, the direct indexed reads in `55:6F46` support a
PROBABLE four-word palette / four-byte C2B1 reload-count layout at `55:6F95`.
The maintained label now says `Kbd_Candidate_PaletteWordsAndReloadCounts`; the
`Candidate` qualifier remains because natural entry, caller, and visible effect
are unproved. The candidate-name inventory and row ledger therefore move from
268 to 269 and from 544 to 545 dispositions, respectively; other Japanese
audits are unchanged. This update does not alter ROM bytes or claim runtime
behavior.

At the same checkout, `make` verified the original ROM SHA-256 and reported
`RESULT: IDENTICAL`; `make sym-check` passed with 335 source files, 12,212
labels and 51 constants; `make palette-check` passed with 162 loads, 116
arrays, two documented over-reads and zero errors. `make test` also passed:
all generator self-tests, SM83 round-trip (1,786 instructions), 48 CFG tests,
PNG rules, 24 palette-read tests and six retype-parts tests. The CFG suite
emitted its existing `ResourceWarning` for an unclosed ROM reader at
`tools/test_cfg.py:398`, then exited successfully. These results update the
current lexical census and byte/build gates. They do not resolve the remaining
bounded entry/reachability questions or prove semantic identity, frame
selection, natural use, or global unused status.

The Bank 53 name source, frame directories, asset catalogue and PNG rules are
unchanged from checkpoint `7b5e2376`; the finite inventory and asset-presence
conclusions above remain current for that source scope. Current graphics gates
also pass: `make png-check` checked 416 tile sheets, four raw byte views, 37
font sheets and 95 screen PNGs; `python3 tools/gfx_export.py check` accepted
986 assets; `python3 tools/png_rules.py mk-check` accepted 985 rules. The
English overlay and Operator ZIP remain paused and were not inspected.

## Historical gate revalidation at `826dbdec` (2026-10-23)

The canonical checkout `/home/rafael/_PROJETOS/Mobile Trainer` was revalidated
at `826dbdec66b9ce1d3ba82ef32d9149e52430226a`. `make` reports SHA-256 OK and
`RESULT: IDENTICAL` for the protected 2 MiB Japanese ROM. `make sym-check`
passes with 335 source files, 12,212 labels and 51 constants; `make
palette-check` passes with 162 loads, 116 arrays, two documented over-reads
and zero errors. `make png-check` checks 416 tile sheets, four raw byte views,
37 font sheets and 95 screen PNGs; the GFX catalog accepts 986 assets and the
PNG rules manifest accepts 985 rules. The Japanese name census matches all 15
coverage families and ledgers: 2,764/2,764 local anchors, 109/109
bank/address-suffix rows, 545/545 broad dispositions, and 786/786 RAM
equates; no source/GFX changes were present at this checkpoint. These results
revalidate the finite checks only. They do not promote UNKNOWN/HYPOTHESIS
entry, purpose, name-to-window association, natural frame selection, or global
used/unused claims. Its 109/545 census counts were superseded by the current
108/542 reconciliation at `91e1c957`. English/ZIP remain paused and untouched.

## Current Japanese gate revalidation at `3f55d26e` (2026-10-23)

At the canonical checkout `/home/rafael/_PROJETOS/Mobile Trainer`, `make`
passed with SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`
and `RESULT: IDENTICAL` for the 2,097,152-byte original ROM. `make sym-check`
passed with 335 source files, 12,212 labels and 51 constants. `make
palette-check` passed with 162 loads in 116 arrays, two documented over-reads
and zero errors. The working tree was clean at the tested revision before
running these gates. This revalidates only the build, symbol and palette gates;
it does not resolve the remaining natural-entry, code/data-span, computed
Bank 53 selection, frame-association or global used/unused questions. The
English overlay and ZIP remain paused.

## Reconciliation of retained Ghidra function names at `c39c1ddc` (2026-10-23)

The retained ROM-hash-pinned `analysis/ghidra_functions.json` has 29 entries.
A read-only reconciliation against the current Japanese linker symbols maps
all 28 ROM function starts to exact current source symbols; this includes the
entries whose old Ghidra names are `FUN_*`. The remaining entry is Ghidra's
zero-instruction stub at HRAM `FFA8`, whose current source identity is
`hFarCallTrampoline` (`ram/hram.asm`), initialized by `Bank_InitState`
(`home/bank_switch.asm`). It is not an unnamed ROM routine. The bounded result
and input hashes are in
`.tmp/jp-ghidra-current-symbol-audit-20261023/RESULT.json` (SHA-256
`ce76e2a4233f325d46414efdf2ba2099fd06ab6fd3eab79ad85c1c7b937d8e8c`),
reproduced by `audit.py` (SHA-256
`b0811989c3942e0cac391e88baabbda12f5f227d9663eefe5fa8dabb3d4d95f5`).
This closes only the retained 29-entry Ghidra crosswalk; it is not a complete
ROM function census or proof that every code span has been identified.

## Bank 4B confirm-screen slot-cell record names (2026-10-23)

Static source at `67:53B7–53DC` selects among three four-byte records in
`4B:76C0–76D0`: `76C0`, `76C4`, and `76C8`. The fourth four-byte record at
`76CC` contains only zero bytes and is outside this three-entry selector table;
no broader purpose or use is claimed. The assembly now names the two later
selected records and the zero record, and the pointer table uses symbolic
targets. The source rebuild remains byte-identical to the original; `sym-check`
passes with 12,215 labels. Exact offsets, bytes, commands, and classification
limits are recorded in
[`japanese_confirm_screen_slot_records_20261023.md`](japanese_confirm_screen_slot_records_20261023.md).

## Gate revalidation at canonical Japanese HEAD `e8efde2f` (2026-10-23)

At `/home/rafael/_PROJETOS/Mobile Trainer`, branch
`codex/japanese-census-ram-ledger`, HEAD `e8efde2f82e8fad660dffc76f133a36d4b6237ce`,
the worktree was clean before the checks. `make` verified the immutable
2,097,152-byte original (SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`),
reported `SHA-256 OK`, and produced `RESULT: IDENTICAL`. `make sym-check`
passed with 335 source files, 12,215 labels and 51 constants. `make
palette-check` passed with 162 loads in 116 arrays, two documented over-reads
and zero errors. `make png-check` passed with 418 tile sheets, four raw byte
views, 37 font sheets and 95 screen PNGs.
`python3 tools/gfx_export.py check` accepted 988 catalog assets (418 exact tile
PNG sources, four raw byte-view PNG sources, 39 font binaries using 37 unique
font-sheet PNGs, one view-only PNG and 526 assets without PNG); `python3
tools/png_rules.py mk-check` accepted 987 rules. The difference between the 39
font binaries and 37 unique sheets is one sheet shared by three binaries;
`make png-check` counts unique sheet PNGs, while `gfx_export.py check` counts
font-binary catalog rows.

These gates confirm the current byte reconstruction, symbol address agreement,
declared palette reads and PNG manifests. They do not establish semantic
closure. In particular, the finite Bank 53 inventory still does not link the
25 Pokémon names to the 25 candidate windows or prove natural selection or
global used/unused status. The exact 70-scenario corpus result for
`26:5344–537C`, `28:4BA6–4BC2` and `4B:76CC–76D0` remains a bounded negative,
not a global reachability claim; the Bank 4B fourth zero record is now
structurally named as PROBABLE, with purpose/use unknown. The remaining
entry/role questions and limits are listed in the current worklists and
cross-referenced above. Do not repeat those finite scans absent new positive
evidence or changed scope. No source/assets/ROM bytes changed in this
revalidation; English and the Operator ZIP remain paused.

## Japanese name-disposition ledger reconciliation at `19ad6ba1` (2026-10-23)

Running `python3 tools/japanese_name_census.py` at the current HEAD found one
stale and one missing row in each address-suffix ledger view. The cause was a
six-line source shift in
`gfx/settings/notice_headers_and_phone_confirm_continue_bank4b.asm` after the
four slot-cell record labels were split out: the existing
`Tilemap_SettingsPhone_ContinuePrompt_4B_7D10` label moved from source line 77
to line 83, with its bank/address and semantics unchanged. Both the 108-row
strict suffix ledger and the 542-row broad union ledger were corrected to
line 83; no ROM source or asset changed.

The census then passed at HEAD `19ad6ba17cdd120558967fba44a7dee70aaf9b30`:
349 Japanese ASM/INC files, 1,879 GFX paths, 2,210 active source/resource
paths, 15/15 coverage families, 2,764/2,764 local anchors, 108/108 strict
suffix rows, 542/542 broad rows (436 suffix and 269 `Candidate`, overlapping
by 163), and 786/786 RAM equates. All ledgers have zero missing, stale,
duplicate, incomplete, flag-mismatched, or address-mismatched rows; there are
zero generic function prefixes, zero address-only global labels, and zero
unreviewed generic-marker labels. This closes the declared census scope only;
it does not prove that every code span, entry, data purpose, or frame is
semantically known.

## Bank 4E frame-preview cursor layout at the current source checkpoint

Static review found a consumer missed by the earlier direct-reference search:
the unreferenced `Browser_FrameStylePreview_Run` initializes an HRAM cursor to
`4E:41E0`, passes it in `HL` to `Browser_FrameStylePreview_RevealStep`, and
stores each returned cursor. The reader walks the table through computed
register state, copies tile/attribute pairs from the SRAM3 snapshot to WRAM7
maps, and terminates when the word after the final group increment is `$FFFF`.
This corrects the stale “consumer not located” statement; it does not add a
natural caller or execution.

The reader consumes 41 groups and 441 map offsets through `4E:45F6`. Three
words at `4E:45F8–45FE` (`$0000,$FFFF,$FFFF`) remain outside this reader and
are now represented by a separate qualified source label; their other use and
purpose are unknown. The table/remainder split preserves the original 1,054
bytes exactly. `make` reports `RESULT: IDENTICAL`; `sym-check` passes with
12,216 labels; the direct 1,054-byte ROM/build slice matches at file offset
`0x1381E0` (SHA-256
`d779aa0f59b5faef50c97fce11282d81eccbd44e81701dc7cf686aee35baed74`). See
[`japanese_frame_wipe_cursor_contract_20261023.md`](japanese_frame_wipe_cursor_contract_20261023.md)
for the operation and evidence limits. Bank 53 name/frame mapping, natural
frame selection, global used/unused status, and the preview root remain
unresolved.

## Bank 70:4740 check against retained trace corpus

The earlier bank-70 boundary note had not inspected natural coverage for the
second operation. At the current source checkpoint, a focused read-only check
covered all 70 tracked `coverage_*.tsv` files and their 70 paired callgraphs.
The corpus validation report lists 78,122 unique instruction starts and no
ERROR entries. No instruction start or recorded control-flow destination
(including calls, restarts, indirect jumps, IRQ entries and returns) falls in
the physical-bank range `[70:4740,70:477F)`. The neighboring `70:477F` block
is outside the query. Aggregate hashes of the sorted coverage and callgraph
lists, respectively, are
`9e2efa12f4e95ed048a6a93b8fea90e2bc68f3a0a55830c8064e45d4ce3b9d91` and
`5531e17069d7ce12ad7b8e797a88df26267d8a84571301e009d66973522e0387`.

This supersedes only the earlier “coverage not inspected” statement for this
span. It does not prove global unreachability or explain A9ED. The operation
name remains `SaveCheck_GetStateBlockBit7` [PROBABLE local mechanics], with
entry and field purpose HYPOTHESIS. Reproduction and caveats are in
[`japanese_open_questions_followup_20261023.md`](japanese_open_questions_followup_20261023.md#bank-704740-against-the-retained-70-scenario-corpus-at-abb8e757).

## Current mapper executed-start correction (2026-10-24)

At base revision `0a7e68e1`, a fresh read-only
`python3 tools/mapper.py --check` found one of 78,108 executed starts missing from the proposed map:
`2A:4440`, where six scenarios execute the two-byte `ld a,$00`. The
speculative unexecuted call target `2A:4441` had previously claimed the
immediate byte. The mapper's conflict resolver skipped the comparison because
the observed instruction was an explicit seed with no predecessor in
`cfg.disc`. It now discards that conflicting walk only after confirming the
coverage row, legal ROM decode, matching instruction length, and an
unexecuted conflicting origin. A focused regression case and all 21 mapper
tests pass. The corrected read-only mapper check reports zero missing
executed starts, zero sweep failures, zero boundary crossings and zero tiling
problems. The maintained ROM source remains byte-identical; the five natural
entry questions and the Bank 53 name/window associations remain
evidence-limited. This is an analysis-tool correction, not a promotion of
those UNKNOWN/HYPOTHESIS claims.

## Latest finite-audit revalidation at `f82692de` (2026-10-24)

The Japanese source checkpoint remains `25501d4b80a8370ab2b7482dd8388f99ca4df417`; this is a documentation-only revalidation after the preceding docs HEAD `f82692de63b35fb271dfa9fd6ef6c0eb4d00184e`. On that source, `make` returns `RESULT: IDENTICAL` for the protected 2 MiB ROM (SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`); `make sym-check` passes (335 files, 12,214 labels, 51 constants); `make palette-check` passes (162 loads, 116 arrays, two documented over-reads, zero errors); `make png-check` passes (418 tile sheets, four raw views, 37 font sheets, 95 screens). `gfx_export.py check` accepts 988 assets, `png_rules.py mk-check` accepts 987 rules, and `make test` passes all suites. The test suite emits its known non-fatal `ResourceWarning` for the `baserom.gbc` reader in `tools/test_cfg.py:398`.

The current Japanese name census passes all 15 coverage families with zero open rows: 2,764/2,764 local anchors, 106/106 strict suffix rows, 540/540 broad dispositions, and 786/786 RAM equates. It finds zero strict address-shaped definitions, generic function prefixes, bare GFX `bankNN` directories, and address-only asset basenames. The mapper/symbol/map follow-up records all 264 candidate spans under current linked sections (104 owners), 187 spans with a symbol start, and 77 bounded by adjacent same-bank symbols. The current `Data_AbookList_CandidateJpRun_4094` name is reconciled; its code-versus-stub status remains HYPOTHESIS.

The finite, verifiable source-name, ledger, mapper-owner, asset-presence and PNG-manifest checks are closed at this checkpoint. This is not a claim of complete semantic code census or universal reachability: five listed function-root questions and the separate local fragment `55:5DF5` retain unknown natural entry/role, three auxiliary spans retain code/data or purpose uncertainty, Bank 53's 25 name-to-window associations and natural frame selection remain unknown, the Porygon entries remain unassigned, and no frame is classified globally unused. The English overlay and Operator ZIP remain paused pending explicit Operator approval.
