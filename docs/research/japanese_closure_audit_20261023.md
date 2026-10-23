# Japanese ROM closure audit (2026-10-23)

## Scope and result

This report consolidates the currently verifiable Japanese-ROM requirements at
`91e1c957437e24b3837e87fdf0a210c9abac54f3` on
`codex/japanese-census-ram-ledger`. It uses only the canonical checkout
`/home/rafael/_PROJETOS/Mobile Trainer`; the English overlay and Operator ZIP
remain paused and were not examined in this pass. Build and test gates below
were run at source checkpoint `f2bcbdaaec93c3b1cc81d62b2314b6ac314639d3`;
the intervening commit only reconciles documentation, with no ASM, asset, or
ROM-source changes.

| Requirement | Current evidence | Status and limit |
|---|---|---|
| Reconstruct the original ROM byte for byte | `make` compares the 2 MiB output against ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570` | **PASS — `RESULT: IDENTICAL`** |
| Avoid generic function labels | Current Japanese census: zero strict address-only globals, zero generic function prefixes, zero unreviewed generic-marker labels; 15 coverage families, zero open | **CLOSED for the audited lexical families.** This does not identify every unlabelled or unreachable code span. |
| Reconcile generic-looking data, local, RAM and resource names | Current ledgers match 2,764 local anchors, 108 strict bank/address suffix rows, 542 broad union rows (436 address-suffix and 269 Candidate labels, with 163 overlapping), and 786 RAM rows; 58 owner-qualified bank-suffix path names are individually dispositioned | **CLOSED for the census and ledgers.** Retained neutral names and `Candidate` qualifiers reflect documented evidence limits; they are not bare address-only names. |
| Reconcile function/operation-boundary clues | The 19 current comment clues map to named bounded operations; coverage row is `CLOSED` | **CLOSED.** They are not evidence of 19 separately callable or naturally reachable functions. |
| Identify candidate operations with no proven natural root | The five rows at 2B:6CF5, 2D:4E42/4E54, 29:511E and 70:4740 have bounded mechanical names and explicit UNKNOWN/HYPOTHESIS entry or role status in the worklist | **Evidence-limited.** The worklist calls for new positive caller/producer/trace evidence before reopening. No generic `Function_*` label remains; do not invent a root or purpose. |
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

## Validation at the current source state

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

## Current gate revalidation at `826dbdec` (2026-10-23)

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
used/unused claims. English/ZIP remain paused and untouched.
