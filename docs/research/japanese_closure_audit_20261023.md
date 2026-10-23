# Japanese ROM closure audit (2026-10-23)

## Scope and result

This report consolidates the currently verifiable Japanese-ROM requirements at
`a488786c44f69fdc1e040a591c9fabaa204425fd` on
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
| Reconcile generic-looking data, local, RAM and resource names | Current ledgers match 2,764 local anchors, 109 bank/address suffix rows, 544 broad candidate rows, and 786 RAM rows; 58 owner-qualified bank-suffix path names are individually dispositioned | **CLOSED for the census and ledgers.** Retained neutral names and `Candidate` qualifiers reflect documented evidence limits; they are not bare address-only names. |
| Reconcile function/operation-boundary clues | The 19 current comment clues map to named bounded operations; coverage row is `CLOSED` | **CLOSED.** They are not evidence of 19 separately callable or naturally reachable functions. |
| Identify candidate operations with no proven natural root | The five rows at 2B:6CF5, 2D:4E42/4E54, 29:511E and 70:4740 have bounded mechanical names and explicit UNKNOWN/HYPOTHESIS entry or role status in the worklist | **Evidence-limited.** The worklist calls for new positive caller/producer/trace evidence before reopening. No generic `Function_*` label remains; do not invent a root or purpose. |
| Verify Bank 53 Pokémon names and candidate frames | The 369-byte pointer/string block and 25 candidate windows (85,200 bytes) reproduce the original; the scoped inventory contains 137 assets, 71 PNGs, 24 previews and 17 editable views | **Finite extraction/presence check closed.** The 25 name-to-window associations and natural selection remain unknown. |
| Check unused frames and asset/PNG omissions | Eight incomplete editable compositions remain `KEEP` because the declared view model lacks backing keys. The source bytes and legacy previews exist; the scoped inventory found no missing referenced files or orphan asset/PNG files. | **No omitted ROM asset or referenced PNG found in scope.** The eight incomplete compositions are not missing ROM data or missing referenced PNGs. No frame is classified globally unused. |
| Reconcile GFX-plan residuals | The current `gfx_export.py plan` contains 13 residual GFX spans, all under 16 bytes; the owner-source boundary/length review is in `japanese_graphics_asset_completeness_followup_20261023.md`. The relevant owner ASM files are unchanged since that reconciliation. | **CLOSED for byte extent and owner-boundary reconciliation.** There is no remaining complete-tile PNG candidate in this plan. Keep the original source spans and confidence; this does not identify every purpose or prove unused status. |
| Verify current PNG/catalog manifests | `make png-check`: 416 tile sheets, 4 raw views, 37 fonts, 95 screens; GFX catalog: 986 assets; PNG rules: 985 | **PASS** for current manifests and declared source models; this does not prove natural display on hardware. |

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
- `make png-check`: 416 tile sheets, 4 raw byte views, 37 font sheets, 95 screen PNGs; OK.
- `python3 tools/gfx_export.py check`: 986 catalog rows; OK.
- `python3 tools/png_rules.py mk-check`: 985 rules; OK.
- `python3 tools/japanese_name_census.py`: all current family counts and rows match; 0 explicitly open families.
- `make test`: all suites passed, including 48 CFG, 24 palette-read and 6 retype-parts tests. It emitted the known `ResourceWarning` for the open `baserom.gbc` reader at `tools/test_cfg.py:398`; the test result was `OK`.
- `git diff --check`: clean. No maintained RGBDS source or binary asset changed between `d13131ff` and this checkpoint; intervening work corrected path instructions, census wording and documentation.

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
