# Japanese ROM closure audit (2026-10-23)

## Delivery on main (2026-10-24)

The audited Japanese work is integrated and published on `main` at
`b49d725ca042d2006d04ee4e41977f857da4397e`. The 197-commit fast-forward
from `f186820f` is complete; it is not an outstanding integration task.
Eleven delivery commands passed at that exact revision: `make`, `make sym-check`,
`make palette-check`, `make png-check`, `gfx_export.py check`,
`png_rules.py mk-check`, `make test`, `test_mapper.py`,
`japanese_name_census.py`, `mapper.py --check`, and `sprite_chain_check.py`.
The ROM is byte-identical with the SHA-256 recorded below. The known nonfatal
`test_cfg.py:398` ResourceWarning remains documented; raw adapter logs retain
their original whitespace. These are build/static/tool-test results, not new
natural-ROM or hardware observations.

There is no outstanding concrete correction in the reconciled Japanese task
inventory. This closes the **verifiable delivery scope**, including naming,
frame/PNG inventories, integration and cleanup. It does not resolve the retained
semantic questions listed below. In particular, no universal natural-entry or
unused classification, executable Pokémon-name/frame association, or complete
VRAM placement for the eight KEEP compositions has been established. Do not
rename those findings as proven facts or count them as unperformed inventories.

The Japanese deliverables for later ZIP parity are indexed in
[the reuse contract](../TRANSLATION.md#japanese-baseline-and-reuse-contract-2026-10-24).
That contract requires explicit authorization before English work resumes;
this closure does not itself grant that authorization. Later documentation-only
commits do not invalidate these source checks.

## Reading the status correctly (review of 2026-10-24, baseline `979fc0a5`)

This is the entry point for the Japanese review. Dated sections below are
historical evidence snapshots, not additive task queues. The current evidence
matrix and the source classifications take precedence over older prose.

| Reviewed scope | Disposition | What would justify reopening |
|---|---|---|
| Naming/path/local/RAM inventories | Completed within the 16 declared coverage families; no outstanding unmatched row in the recorded census | A concrete unmatched case or relevant source change |
| Operation-boundary TSV | All 21 rows already have named operations/fragments in their owner files, including the colonless local label at `55:5DF5`; not 21 unnamed functions | New entry/consumer evidence or a specific error in a row's mechanics |
| Auxiliary spans | `26:5344` and `28:4BA6` are named PROBABLE code; `4B:76CC` is PROBABLE alignment padding | New caller, reader or contradictory byte/format evidence |
| Bank 42 candidates and dictionary padding | Six tile candidates already have exact PNGs; `1A:4A85` is PROBABLE padding | New natural loader/consumer evidence; no repeated extraction |
| Bank 53 and frame inventory | Finite audit completed; current inventory is 143 assets and 77 PNG references | A changed inventory, missing referenced file or positive name/selector link |
| Eight KEEP compositions | Reviewed limitations of editable placement; bytes, backing assets and previews retained | Evidence supplying the missing placement keys/state |
| Global used/unused claims | Not established by the bounded trace corpus | Evidence covering the relevant consumers; absence of observations alone is insufficient |

**No new actionable defect was identified by this report reconciliation.**
That is not a proof that every byte's semantics or every natural entry is known.
The five highlighted candidate roots are a subset of the recorded uncertainty,
not an exhaustive count of unidentified functions. The 21 operation rows, two
additional code fragments, eight data/GFX intervals, 25 associations and eight
KEEP views must not be added up as an outstanding implementation backlog.
These groups describe different, sometimes overlapping, evidence limits.
The earlier conversational estimate of 40–80 hours is withdrawn: these records
do not support a remaining-work total, percentage or completion date.

For any proposed new task, first state the affected source/evidence revision,
the specific unsatisfied requirement, the new evidence or changed scope, and
an acceptance criterion. Consult the existing row and receipt before proposing
another scan. Keep completed checks closed unless that trigger applies. A user
request can reopen a bounded question, but does not invalidate prior results.
English/ZIP work remains paused until a separate explicit user authorization.
This review changed documentation only; it did not rerun the ROM or gates.

## Current consolidated status at `e65b07ba` (2026-10-24)

The Japanese review has closed the finite, verifiable inventories and gates
listed below, but the ROM is **not semantically 100% closed**. The live
`tools/japanese_name_census.py` reports all 16 coverage families matched with
zero open families; 2,764/2,764 local anchors, 106/106 strict bank/address
suffix rows, 545/545 broad dispositions, and 786/786 RAM rows matched. It
finds zero strict address-only globals, generic function prefixes,
unreviewed generic-marker labels, short local placeholders, bare `bankNN`
paths or address-only asset basenames. `tools/mapper.py --check` reports
78,114 executed starts, zero missing starts, zero sweep failures, zero
boundary crossings and zero tiling problems at HEAD `e65b07ba`. No remaining
generic address-only function/data/font labels or bare `bankNN` asset paths
were found in the reconciled naming families; the operation-boundary clues,
local/RAM ledgers, scoped Bank 41–47 assets, Bank 53 name block, PNG manifests,
and declared frame-window files have documented evidence and limits. The
current checkout passed `make` (`SHA-256 OK`, `RESULT: IDENTICAL`),
`make sym-check` (335 source files, 12,223 labels, 51 constants),
`make palette-check` (162 loads, 116 arrays, two documented over-reads, zero
errors), `make png-check` (424 tile sheets, four raw views, 37 font sheets, 95
screens), `gfx_export.py check` (994 assets), and `png_rules.py mk-check`
(993 rules). The rebuilt ROM and protected Japanese reference are both 2 MiB
with SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.

The retained uncertainties are evidence limits, not unperformed repetitions of the
closed inventories: five bounded candidate roots still lack a demonstrated
natural producer/entry; some GFX spans lack a proven natural consumer or load
phase; and all 25 Bank 53 name-to-frame links, including Porygon/Porygon2,
remain unresolved. The eight `KEEP` views are not classified as globally
unused, and no global used/unused conclusion is made. Preserve the mechanical
names and confidence levels already documented; do not invent callers,
associations, or reachability claims. The English overlay and Operator ZIP
remain paused pending a separate explicit authorization.

The asset/build gates above ran immediately before the documentation-only
commit `e65b07ba`; the Japanese source and assets are unchanged from the
validated `8af7675e` checkpoint. The live census and mapper checks ran at
`e65b07ba`.

This consolidation is tied to current Japanese source/assets, which have no
diff from the validated `8af7675e` source checkpoint. A current tracked-source
search for `Table_PokemonNamePointers` and `PokemonName00..24` finds only the
table definition and its 25 internal `dw` operands. The only Bank 53 source
change since the older `b9a591ce` consumer-route receipt is a comment wording
change; the intervening changed source owners do not add name-table references.
This is a direct-symbol check only and does not exclude computed addresses,
indirect tables, stack/RAM values, copied data, or runtime-created flow. See
[`japanese_frame_bank53_revalidation_20261024.md`](japanese_frame_bank53_revalidation_20261024.md)
and [`japanese_remaining_semantics_batch_20261024.md`](japanese_remaining_semantics_batch_20261024.md)
for the retained evidence and bounded limits.

## Scope and result

This report consolidates the verifiable Japanese-ROM requirements. The
original audit was recorded at `91e1c957437e24b3837e87fdf0a210c9abac54f3`;
the latest gate summary is the `e65b07ba` section above, recorded in
`979fc0a5`, on
`codex/japanese-census-ram-ledger`. It uses only the canonical checkout
`/home/rafael/_PROJETOS/Mobile Trainer`; the English overlay and Operator ZIP
remain paused and were not examined.

| Requirement | Current evidence | Status and limit |
|---|---|---|
| Reconstruct the original ROM byte for byte | `make` compares the 2 MiB output against ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570` | **PASS — `RESULT: IDENTICAL`** |
| Avoid generic function labels | Current Japanese census: zero strict address-only globals, zero generic function prefixes, zero unreviewed generic-marker labels; 16 coverage families, zero open | **CLOSED for the audited lexical families.** This does not identify every unlabelled or unreachable code span. |
| Reconcile generic-looking data, local, RAM and resource names | Current ledgers match 2,764 local anchors, 106 strict bank/address suffix rows, 545 broad union rows (440 address-suffix and 267 Candidate labels, with 162 overlapping), and 786 RAM rows; 58 owner-qualified bank-suffix path names are individually dispositioned. The current rebuilt-symbol-map recognizer in `data_consumers.py --stats` finds zero neutral data groups and zero generated rename rows. The RAM partition has 104 exact bank overlays and 56 container interiors. | **CLOSED for the census and ledgers.** Retained neutral names and `Candidate` qualifiers reflect documented evidence limits; they are not bare address-only names. |
| Reconcile function/operation-boundary clues | The 19 current comment clues map to named bounded operations; coverage row is `CLOSED` | **CLOSED.** They are not evidence of 19 separately callable or naturally reachable functions. |
| Identify candidate operations with no proven natural root | The five rows at 2B:6CF5, 2D:4E42/4E54, 29:511E and 70:4740 have bounded mechanical names and explicit UNKNOWN/HYPOTHESIS entry or role status in the worklist. A new full-ROM literal-target scan for `70:[4740,477F)` reconciled all same-bank and bank-qualified matches as data overlaps or graphics bytes; it found no aligned pointer to an instruction start. | **Evidence-limited.** Natural entry and role remain UNKNOWN/HYPOTHESIS; computed/stack-derived targets and execution outside the retained corpus remain open. No generic `Function_*` label remains; do not invent a root or purpose. |
| Track additional code/data spans outside the five highlighted candidate roots | The three spans were checked against the 70 paired natural coverage, callgraph, and dataaccess reports at 1c9224e8 and then extended by processing only the newly added zzzz_mailbox_cursor_count reports. Across the current 71-scenario union (78,128 starts), each has zero exact instruction starts, zero direct call/rst/jphl edges, and zero intersecting ROM data-read ranges. This finite result is for these auxiliary spans only; it does not establish global unreachability or unused status. Separate static evidence already classifies 26:5344–537C as the PROBABLE code fragment `MailSession_WriteVram1TileAndWram7ScreenRows`; its entry and intended role remain unknown. | **Finite corpus check closed.** `28:4BA6–4BC2` is now the PROBABLE coherent routine `ClearWram0AndFillWram7WithFF`; its entry and intended purpose remain unknown. `4B:76CC–76D0` is PROBABLE alignment padding (`Padding_SettingsPhone_ContinuePromptTiles_Alignment`), with the fourth-record alternative only HYPOTHESIS. These supersede the earlier unclassified-span wording. The bounded negative does not establish global unreachability or unused status; see the result and manifest in `japanese_open_questions_followup_20261023.md` and the classification evidence in `naming2_verify_fn4.md`. |
| Verify Bank 53 Pokémon names and candidate frames | The 369-byte pointer/string block and 25 candidate windows (85,200 bytes) reproduce the original; the current bank 41–47 inventory contains 143 assets (93,360 emitted bytes), 77 PNGs, 24 previews and 17 editable views; this includes six additional Bank 42 16-byte tile candidates | **Finite extraction/presence check closed.** The 25 name-to-window associations and natural selection remain unknown. |
| Check unused frames and asset/PNG omissions | Eight incomplete editable compositions remain `KEEP` because the declared view model lacks backing keys. The source bytes and legacy previews exist; the scoped inventory found no missing referenced files or orphan asset/PNG files. | **No omitted ROM asset or referenced PNG found in scope.** The eight incomplete compositions are not missing ROM data or missing referenced PNGs. No frame is classified globally unused. |
| Reconcile GFX-plan residuals | The bounded GFX plan has seven residual spans totaling 82 bytes: six Bank 42 tails (71 bytes) and `1A:4A85–4A90` (11 zero bytes). Six Bank 42 spans now have separate 16-byte PROBABLE tile-candidate assets with exact PNG sources; the former Bank 51 tail `51:70D1–70E0` is separately bounded and no longer a plan residual. | **Byte extents and owner boundaries are reconciled;** the six tile-candidate identities remain PROBABLE, and natural loader phase/consumption remain unproved. The 11-byte zero run is not promoted to a tile. |
| Verify current PNG/catalog manifests | At the current source snapshot: `make png-check` checks 424 tile sheets, 4 raw views, 37 fonts and 95 screens; GFX catalog: 994 assets; PNG rules: 993 | **PASS** for current manifests and declared source models; this does not prove natural display on hardware. |

## Current Japanese gate revalidation at `7c19214d` (2026-10-24)

The gate commands below were run on the canonical checkout at
`7c19214d556829ece4ad213820cb6b20b423c90f`. The Japanese source and assets
match source baseline `b9a591ce`; changes after that baseline are documentation
only. `make` reports `SHA-256 OK` and `RESULT: IDENTICAL` for the protected
2 MiB original (SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`).
`make sym-check` passes with 335 source files, 12,221 labels and 51 constants;
`make palette-check` passes with 162 loads, 116 arrays, two documented
over-reads and zero errors. `make png-check` checks 424 tile sheets, four raw
byte views, 37 font sheets and 95 screens. `gfx_export.py check` accepts 994
assets (424 exact tile PNG sources, four raw byte-view PNG sources, 39 font
binary rows using 37 unique sheets, one view-only PNG, and 526 assets without
PNG); `png_rules.py mk-check` accepts 993 rules.

The six added Bank 42 tile candidates account for the increase from the earlier
418/988/987 PNG/catalog/rule snapshots to the current 424/994/993 checks. These
checks validate the declared files and manifests, not natural display, loader
phase, the Pokémon-name/frame associations, or global used/unused status. No
full Japanese name census or retained trace corpus was rerun for this
documentation reconciliation.

The census and ledgers are detailed in
[`japanese_generic_name_sweep_20261023.md`](japanese_generic_name_sweep_20261023.md),
[`japanese_name_audit_coverage_20261023.tsv`](japanese_name_audit_coverage_20261023.tsv),
and [`japanese_operation_boundary_worklist_20261023.tsv`](japanese_operation_boundary_worklist_20261023.tsv).
The bounded Bank 53/frame evidence and limits are in
[`bank53_names_frames_assets_audit_20261023.md`](bank53_names_frames_assets_audit_20261023.md).

## Japanese verification snapshot at `9a44ec66` (2026-10-24)

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
rows, 539/539 broad name dispositions and 786/786 RAM equates. It reports zero
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

## Revalidation at `e6119102` (2026-10-24)

At the canonical checkout `/home/rafael/_PROJETOS/Mobile Trainer`, commit
`e6119102b820fd54bbda007bcba98604a9a3785a` refines the Bank 51 GFX boundary:
`51:5EE1..70D1` is the 4,592-byte candidate tile source, `51:70D1..70E0` is
fifteen zero bytes, and confirmed code `Bmp_Validate` starts at `51:70E0`.
The alignment-padding role is **PROBABLE**; the exact reader/use and global
non-use remain unknown. The current bounded GFX plan therefore has seven
short spans (six Bank 42 fragments and `1A:4A85`), not the eight listed in the
earlier checkpoint table. The residual audit found no complete-tile PNG
candidate for those remaining spans; it does not prove global asset or use
completeness.

The isolated build command
`make BUILD=/tmp/mobile-trainer-bank51-tail-check-20261024/BUILD ROM=/tmp/mobile-trainer-bank51-tail-check-20261024/mobile_trainer.gbc`
returned `SHA-256 OK` and `RESULT: IDENTICAL` against the protected original
ROM SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
`make sym-check` passed with 335 source files, 12,215 labels and 51 constants;
`make png-check`, `gfx_export.py check` (988 assets), and `png_rules.py
mk-check` (987 rules) also passed. The change did not touch the Bank 53 name
table, frame-window binaries or PNG assets, so their previous finite inventory
remains a scoped result rather than a newly repeated test.

Japanese semantic review remains incomplete. The five bounded natural-entry
questions, Bank 53 name-to-window associations, natural frame selection, and
universal used/unused status remain UNKNOWN/HYPOTHESIS absent distinct positive
evidence. No missing referenced asset or PNG was found in the previously
audited finite inventory; that result does not establish global ROM asset
completeness. English/ZIP remains paused pending Japanese closure and explicit
Operator approval.

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

## Finite-audit gate revalidation at source baseline `25501d4b` (2026-10-24; superseded by the following ledger correction)

The Japanese source checkpoint remains `25501d4b80a8370ab2b7482dd8388f99ca4df417`; this is a documentation-only revalidation after the preceding docs HEAD `f82692de63b35fb271dfa9fd6ef6c0eb4d00184e`. On that source, `make` returns `RESULT: IDENTICAL` for the protected 2 MiB ROM (SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`); `make sym-check` passes (335 files, 12,214 labels, 51 constants); `make palette-check` passes (162 loads, 116 arrays, two documented over-reads, zero errors); `make png-check` passes (418 tile sheets, four raw views, 37 font sheets, 95 screens). `gfx_export.py check` accepts 988 assets, `png_rules.py mk-check` accepts 987 rules, and `make test` passes all suites. The test suite emits its known non-fatal `ResourceWarning` for the `baserom.gbc` reader in `tools/test_cfg.py:398`.

At this source baseline, the Japanese name census passed all 15 coverage families with zero open rows: 2,764/2,764 local anchors, 106/106 strict suffix rows, 540/540 broad dispositions, and 786/786 RAM equates. The later Bank 4A:51B0 rename left one stale ledger row; see the current 539-row reconciliation below. It finds zero strict address-shaped definitions, generic function prefixes, bare GFX `bankNN` directories, and address-only asset basenames. The mapper/symbol/map follow-up records all 264 candidate spans under current linked sections (104 owners), 187 spans with a symbol start, and 77 bounded by adjacent same-bank symbols. The current `Data_AbookList_CandidateJpRun_4094` name is reconciled; its code-versus-stub status remains HYPOTHESIS.

The finite, verifiable source-name, ledger, mapper-owner, asset-presence and PNG-manifest checks are closed at this checkpoint. This is not a claim of complete semantic code census or universal reachability: five listed function-root questions and the separate local fragment `55:5DF5` retain unknown natural entry/role, three auxiliary spans retain code/data or purpose uncertainty, Bank 53's 25 name-to-window associations and natural frame selection remain unknown, the Porygon entries remain unassigned, and no frame is classified globally unused. The English overlay and Operator ZIP remain paused pending explicit Operator approval.

## Follow-up: indirect entry and local boundary review (2026-10-24)

At documentation HEAD `6e2a5437ea3b8876dd8df3c91265878e2092015b`, three bounded static reviews checked the remaining Japanese operation-entry questions against alternative stack-hook, interrupt-stub, HRAM trampoline, dispatch, copy/restore and code/data-boundary mechanisms. The source and slice provenance, exact finite domains, and limitations are recorded in [the review report](japanese_indirect_entry_boundary_review_20261024.md). The original ROM hash remains `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; key original-ROM spans were independently hashed in the canonical checkout.

The sprite callback trampoline at `00:0B36–0B53` is confirmed as a stack-based computed transfer; its 15 examined textual producers use a bounded set of target pairs, but buffer copies and unexamined writes prevent a global absence claim. The Bank 70 indexed table's examined domains do not select `70:4740`; the reviewed stubs and trampolines add no producer for the unresolved mail/palette candidates. The keyboard fragment and three auxiliary spans gained no natural root. The valid Bank 4B slot selector has three entries and does not select the zero record at `4B:76CC`; that local result does not establish global non-use.

**Closure impact: no candidate natural-entry or semantic-purpose question was promoted to resolved.** The Japanese ROM is not yet 100% semantically closed. Existing function/data naming census results remain closed for their declared lexical families; candidate roots, auxiliary spans, Bank 53 name/frame links, Porygon assignments and global frame-use status retain their documented limits. English/ZIP translation remains paused pending Japanese closure and explicit Operator approval.


## Fresh Japanese gate audit at `a88a540e` (2026-10-24)

On the canonical checkout and current documentation HEAD `a88a540e3c485367cb36c4537e39a7818f390d82`, the Japanese build and declared finite gates were rerun. `make` returned `SHA-256 OK` and `RESULT: IDENTICAL`; reference and build are 2,097,152 bytes with SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. `make sym-check` passed 335 source files, 12,214 labels and 51 constants. `make palette-check` passed 162 loads / 116 arrays / two documented over-reads / zero errors. `make png-check` passed 418 tile sheets, four raw views, 37 font sheets and 95 screen PNGs. `make test` exited 0: generator selftests, 1,786 SM83 instructions, 48 CFG tests, 24 palette-read tests, six retype-parts tests and the remaining suites passed. It emitted the existing non-fatal `ResourceWarning` at `tools/test_cfg.py:398`. `gfx_export.py check` passed 988 assets; `png_rules.py mk-check` passed 987 rules.

`tools/japanese_name_census.py` passed all 15 coverage families with zero open rows: 2,764/2,764 local anchors, 106/106 strict bank/address-suffix rows, 540/540 broad dispositions and 786/786 RAM equates. It found zero strict address-shaped globals, zero generic function prefixes, zero unreviewed generic-marker labels, zero short local placeholders, zero bare `gfx/bankNN` paths and zero address-only asset basenames. `tools/mapper.py --check` reported 78,108 executed starts, zero missing starts, zero sweep failures, zero boundary crossings and zero tiling problems. These gates establish byte reconstruction and the declared census/mapping checks, not semantic identification of every possible code/data byte.

The frame/name/asset inventory remains closed for its documented finite scope; no missing referenced PNG or orphan asset was found, and the eight incomplete editable compositions remain `KEEP`. The 25 name-to-window links (including both Porygon rows), natural selection and global unused status remain unknown. The indirect-entry review likewise found no positive natural root for the remaining bounded candidates. Do not restart those completed scans without new evidence. Japanese semantic closure is still not 100%; English/ZIP remains paused pending explicit Operator approval.


## Current ledger revalidation after the Bank 4A tail rename (2026-10-24)

At published source HEAD `f4ff5e2b0ce84dd9f1a775ffbbf753f034fc4739`, the fresh name census exposed one stale broad-ledger row for the former `Palette_SettingsMenu_ObjRampCandidates` label at `4A:51B0`, now named `Data_SettingsMenu_HdmaTailVram9770`. The stale row incorrectly retained the `Candidate` flag; the current source label has no `Candidate` token. Removed that obsolete row and changed the coverage family from 269 to 268. The reconciled broad union is 539 rows: 434 address-suffix rows plus 268 `Candidate` labels minus 163 shared rows. All 15 name-audit families now reconcile.

The current build gates at the same Japanese source HEAD pass: `make` reports `SHA-256 OK` and `RESULT: IDENTICAL` for the 2,097,152-byte original (SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`); `make sym-check` reports 335 source files, 12,214 labels and 51 constants; `make palette-check` reports 162 loads, 116 arrays, two documented over-reads and zero errors; `make png-check` checks 418 tile sheets, four raw views, 37 font sheets and 95 screen PNGs; GFX export accepts 988 assets and PNG rules accept 987 rows. This corrects a documentation-ledger mismatch only; it does not change the Japanese ROM or promote any unresolved semantic, natural-entry, Pokémon/frame-association or global frame-use question. English/ZIP remains paused.

## Natural mailbox coverage and full name-ledger reconciliation (2026-10-24)

At source checkpoint `07b0c0dd`, a new ordinary-button scenario `zzzz_mailbox_cursor_count` starts from the retained `mail_receive` SRAM/adapter state and reproduces a mailbox cursor-count path. The macro has no `force` or `ramset` directives. Two direct replays produced byte-identical coverage, callgraph, data-access and stats files; the standard harness `--verify-determinism` also reported all 18 output files identical. `waitstable` hit its 600-frame cap at four checkpoints, so the record proves observed instruction execution, not that every intended screen transition settled. The scenario executes `25:491B,491D,491F,4921,4923,4925` at frame 3174 and then `25:4929`; it does not execute the final jump at `25:4927`.

The scenario was added to `traces/scenarios.tsv` and `traces/inputs/zzzz_mailbox_cursor_count.macro`. It sorts last in the trace union to avoid renumbering scenario indexes. `tools/trace/merge_coverage.py --strict` now reports 78,128 unique instruction starts (78,114 ROM and 14 RAM) with zero decoder errors. A reviewed `tools/apply_coverage.py --apply --split --in-place` reconciliation changed three region statuses and split three partial regions into nine pieces: `25:4594–4659`, `25:491B–4929`, and `74:58C2–58F4`. The executed runs are `CONFIRMED`; unexecuted runs remain `PROBABLE`. The three full-range promotions are `25:555C–5569` (7 starts), `2D:6726–676F` (36), and `74:4C5F–4C6B` (7). This replaces stale “never executed” notes with current evidence. The related source comment in `engine/mail/mailbox.asm` was corrected; no opcode or data byte changed.

The same full-source census exposed a ledger drift that prior checkpoint text missed: `Padding_BmpValidateEntryAlignment_51_70D1` was already a descriptive owner-qualified label but absent from both address-suffix ledgers. Its row now records the 15 original zero bytes, the PROBABLE alignment interpretation and the unknown exact use. Current `tools/japanese_name_census.py` passes with 15/15 families: 107 strict bank/address suffix labels, 540 broad dispositions (435 address-suffix rows plus 268 `Candidate` rows with 163 overlaps), 2,764 local anchors, 786 RAM equates, and zero missing, stale, duplicate or incomplete rows. There are zero strict address-only globals, generic function prefixes, unreviewed generic markers, bare `gfx/bankNN` paths or address-only asset basenames. The ledger correction does not establish every symbol's semantic purpose or close the Japanese ROM review.

Replay and reconciliation receipts, commands and hashes are retained under `.tmp/jp-mail-natural-explore-20261024/RESULT.json`. The unresolved function-entry candidates, auxiliary spans, Bank 53 name/frame associations, natural frame selection, Porygon assignments and global used/unused status remain open as previously bounded. English/ZIP remains paused pending completion of the Japanese review and explicit Operator approval.


## Consolidated residual matrix

The row-level grouped status and re-entry criteria are maintained in the standalone [consolidated residual matrix](japanese_remaining_semantics_batch_20261024.md). It merges three independent reviews without repeating the closed lexical, asset, or corpus scans.


## Current broad-name census reconciliation (2026-10-24; source snapshot `0d1dc2da`)

The fresh `tools/japanese_name_census.py` run detected drift in the broad name ledger after source edits: 25 line-number updates among existing Bank 42 frame-design rows, six new Bank 42 tail-tile candidate rows, and one renamed dictionary padding label. The ledger and 15-family coverage matrix are reconciled at this documentation checkpoint: 2,764/2,764 local anchors, 107/107 strict suffix rows, 546/546 broad union rows (441 suffix labels plus 268 `Candidate` labels, 163 overlap), and 786/786 RAM equates. Broad rows now match current source path/line/address/flags with zero missing, stale, duplicate, incomplete, flag or address mismatches. The six tail tiles remain qualified candidates; their original load/phase/consumer and global use are unknown. `MobileDict_AlignmentPaddingBeforeTiles_4A85` retains PROBABLE alignment status, not proof that no other reader exists. This ledger correction changes no assembly bytes and does not close the Japanese semantic questions. The English/ZIP work remains paused.


## Current mapper and neutral-data check (2026-10-24; Japanese source unchanged at `2ac09d3b`)

The doc-only ledger checkpoint did not change ASM/INC sources. `python3 tools/mapper.py --check` on the canonical checkout discovered 103,440 instructions and reconciled the retained executed-start map: 78,114 executed starts, zero missing starts, zero sweep failures, zero boundary crossings and zero tiling problems. `python3 tools/data_consumers.py --stats` read the rebuilt `build/mobile_trainer.sym` and reported zero neutral data groups and zero generated manifest rows under its exact address-form recognizer. This does not cover every typed or non-address-suffixed data symbol and does not establish semantic closure. The same checkpoint's `make` returned `SHA-256 OK` / `RESULT: IDENTICAL`; `make sym-check` passed 335 files / 12,221 labels / 51 constants; `make palette-check` passed 162 loads / 116 arrays / two documented over-reads / zero errors; and `make test` exited 0 across all suites, with the known non-fatal `ResourceWarning` at `tools/test_cfg.py:398`.
