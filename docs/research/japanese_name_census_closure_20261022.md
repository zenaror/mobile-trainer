# Consolidated Japanese name and path census — 2026-10-22

## Scope and result

This pass reconciles name searches across the migrated Japanese checkout at base commit `7973e1993152c10987a164a3f5968133312a1611`. It covers all **350 tracked ASM/INC files** in the maintained source roots plus three root support files; the protected `engine/mail/sample_data.asm` is included only in counts, not inspected for payload. It excludes `languages/` and the Operator ZIP. The source census found **6,693 global labels**, **3,891 numeric local `.lAAAA` definitions** (3,872 without protected sample data), and **786 address-only RAM equates**.

The exact anchored global-symbol scan now finds **13 `Data_BB_AAAA` labels** and no exact-address `Function`, `Func`, `Sub`, `Unknown`, `Unk`, `Code`, `Label`, `Font`, `Tiles`, `Tilemap`, `Attrmap`, `Palette`, `String`, `Table`, `SpriteFrame`, or `SpriteScript` definitions. The GFX/font inventory covers **1,950 tracked files** (1,859 GFX and 91 fonts), 116 directories, 87 GFX owners, and 12 font owners. It found no pure `bankNN` directory or basename, no address-only basename, and no strict type/address-only basename. Functional names may retain a bank suffix as provenance.

These are lexical/static inventories, not proof of semantic completeness, computed-reference absence, natural execution, visual identity, or hardware behavior.

## Adversarial follow-up at `ae6b9ccef65207421f832ff856afe1659ece9865`

The 13-label review was rechecked against the original ROM, all six maintained
source roots, 72 existing `dataaccess.tsv` reports (69 natural and three
forced), coverage unions, forced coverage, far-call targets and xrefs. Two
positive byte-level matches emerged:

- `Data_24_6520` is exactly the first 16-byte row of
  `PageListProto_ObjTable` at `7F:6DB0`; the sequence occurs only at those
  two ROM locations. It is now named
  `ByteMatch_PageListProto_ObjTableFirstRow_24_6520`. The match is
  **CONFIRMED**; its use or origin remains **HYPOTHESIS**.
- `Data_26_5062` is exactly the five-byte tail of `MailSession_Cancel`
  at `26:505D–5062`; that full sequence occurs only at the two locations.
  It is now named `ByteMatch_MailSessionCancelTail_26_5062`. Again, only the
  byte equality is **CONFIRMED**.

The current exact `Data_BB_AAAA` count is therefore **11**, not 13. No
function, active table, causal origin, or natural consumer was established for
the two matched spans. The remaining eleven labels stay address-neutral:
the combined scan did not support a stronger name, and computed/unobserved
access is outside its coverage. The per-label evidence and limits are in
[`generic_data_name_followup_20261023.md`](generic_data_name_followup_20261023.md).

The same checkpoint rechecked Bank 53 names and frame assets. All declared
assets and PNGs remain present and consistent; 2,416 inline bytes in owner 42
are outside the exported catalog by design (partial `db` tails plus zero-fill),
not missing PNGs. Name-to-frame matching and natural selection remain open;
see [`bank53_names_frames_assets_audit_20261023.md`](bank53_names_frames_assets_audit_20261023.md).

## Source changes from this pass

Six `_Unknown` names in `engine/mail/result_screens.asm` were renamed using direct content and consumer evidence. The three text blocks at bank `29`, addresses `47B2`, `4AC4`, and `4D80`, each contain exactly five full-width question marks and a NUL (`81 48` repeated five times, then `00`). Each text block has an associated wrapper; each wrapper passes its corresponding block to `TextTiles_RenderLine` three times and uploads the staged question-mark tiles. The upload helper is now named `MailServerStatus_UploadQuestionMarkTileStage`; its static consumers are exactly these three wrappers. The labels now say `FiveQuestionMarks`; the associated branch labels say `QuestionMarks`. This identifies the rendered glyphs and behavior without claiming why the program chooses them. The private patch proof and reverse-diff receipt are retained at `.tmp/jp-comprehensive-census-7973/entries/RENAME_PROOF/`.

The graphics audit identified three payloads previously called candidates whose exact byte intervals are fully covered by static HDMA requests. Labels and asset paths now describe them as HDMA source slices:

| Source slice | Covered request | Derived destination for the slice | Important limit |
|---|---|---|---|
| `24:55D0–5800` (560 bytes) | `24:5400–5800` to VRAM1 `9300–9700` | VRAM1 `94D0–9700` | 16-byte aligned within the transfer; static inclusion does not establish display. |
| `24:5EF1–62D1` (992 bytes) | `24:5EE0–62E0` to VRAM0 `8000–8400` | VRAM0 `8011–83F1` | Starts at byte phase +1; name does not assert aligned tiles or PNG appearance. |
| `25:6BD1–6CE1` (272 bytes) | `25:69F0–6CF0` to VRAM0 `8000–8300` | VRAM0 `81E1–82F1` | Starts at byte phase +1; no arrow/label visual identity or natural display claim. |

The binary and PNG payload hashes are unchanged by path renames. The independent full graphics matrix, including all original hashes and evidence boundaries, is retained under `.tmp/jp-comprehensive-census-7973/gfx/audit/` (`AGENT_REPORT.md`, `transfer_slices.tsv`, and `scoped_sha256.json`). The earlier statement that neighboring HDMA blocks did not prove these exact spans was corrected in `mixed_candidate_graphics_paths_20261021.md`.

## Names intentionally left unresolved

All 13 remaining `Data_BB_AAAA` labels were reviewed together. Each is an isolated byte span or unclassified block whose entry, reader, or content type lacks positive proof. Their exact locations, bytes, and reasons are documented in [`generic_data_name_followup_20261023.md`](generic_data_name_followup_20261023.md). In particular, the three `$C9`/opcode-like bytes and the jump-like bytes remain data labels until an entry or resource boundary is shown; adjacency and opcode resemblance do not justify function names.

The broad token inventory identified 244 labels containing `Candidate`. Four begin with the word itself: `CandidateTiles_51_5EE1`, `CandidatePalette_29_5376`, `CandidatePalette_26_73E0`, and `CandidateMapData_23_7C03`; other occurrences qualify otherwise descriptive owner/resource names. These are uncertainty markers, not a claim that their display/consumer is known. `UnresolvedTiles_7F_7830` has a visual 2bpp-sized backing but no located reader. They remain tracked with evidence status rather than receiving invented semantic names.

Other non-address-pattern names reviewed in the same sweep:

- `ReturnOnly_68_5D2F` identifies a single observed `RET`; entry and purpose remain HYPOTHESIS, so no surrounding password routine is attributed to it.
- `Settings_ReadData_UnknownContent_7271` spans confirmed read bytes whose content class and consumer are unresolved; the name preserves those limits.
- `BrowserMenu_PlaceholderText` and `CommErr_Msg_GenericCommError` describe the known placeholder and generic-error roles.
- The 3,872 `.lAAAA` names are local branch labels, not a count of unidentified functions. Some were deliberately renamed where static operation evidence supported it; the remainder are retained where it did not.
- The 786 `wRam_AAAA`/`hRam_AAAA`/`sSram_AAAA` definitions were reconciled with operand uses and overlay scopes. Existing aliases cover 364 scoped views of 104 bases; the census found no remaining base-name operand inside those declared scopes. It did not justify globally renaming any remaining base because the RAM locations are reused, phase-dependent, banked, or lack a stable role.

The frozen `config/` directory contains 3,262 historical exact bank/address name records (3,233 unique names) and 859 historical neutral RAM records. Those tables are not live source or a current rename backlog and remain frozen.

## Remaining closure work

This census closes the **search inventory**, not the Japanese ROM's semantic review. Four natural-entry questions remain unresolved in the existing bounded report: `2B:6CF5`, `2D:4E42`, `2D:4E54`, and `29:511E`. A broader word such as `Candidate` also does not automatically mean the role can be named; each needs a positive consumer, transfer, table, or entry boundary. The Japanese Pokémon-name/frame review and final gates/docs remain open. The English overlay and ZIP remain untouched and paused.

## Verification

The census used immutable base `7973e199`; after integration, `make` reports `SHA-256 OK` and `RESULT: IDENTICAL` against the original SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. `make sym-check` passes with 12,185 labels and 51 constants; `make palette-check` passes with 162 loads, 116 arrays, two documented over-reads and zero errors. `python3 tools/png_rules.py mk-check` passes for 977 rules and `python3 tools/png_check.py` passes for 408 tile sheets, four raw byte views, 37 font sheets and 95 screen PNGs. These gates validate reconstruction and index consistency, not the semantic hypotheses above.
