# Consolidated Japanese local-label naming census (2026-10-22)

## Scope and decision

This checkpoint consolidates the Japanese source review instead of treating each subsystem as a separate discovery. It is based on source commit `2d264633c846d44986ad42f15480c283261d3b91` in `/home/rafael/_PROJETOS/Mobile Trainer`; a previously used checkout was stale and is excluded. The English overlay and Operator ZIP were neither read nor changed; the English branch remains paused pending the Operator's explicit approval.

The census enumerated every address-only local definition of the form `.lAAAA` in the maintained Japanese ASM/INC source set (333 files, excluding protected `engine/mail/sample_data.asm`). It counted **3,871 definitions** in three exhaustive partitions:

| Partition | `.lAAAA` definitions | Renamed | Kept neutral/cosmetic |
|---|---:|---:|---:|
| HOME, audio and mobile library | 553 | 409 | 144 |
| Remaining symbol-census subsystems | 2,136 | 112 | 2,024 |
| Engine path-review subsystems | 1,182 | 25 | 1,157 |
| **Total** | **3,871** | **546** | **3,325** |

The mapping contains one row per rename, with path, local owner, old token, banked address, replacement, confidence, independent audit decision, and the review basis. It is the exact checklist for this pass: [Japanese local-label batch mapping](japanese_local_label_batch_mapping_20261022.tsv).

## Review and corrections

All 546 rows were checked against the current definition, owner, block, and in-owner references. Three independent review partitions reported:

- **HOME/audio/mobile library:** 409 rows checked; 405 accepted exactly as proposed. Four overly broad names were rejected and replaced with narrower ones: clear only `ContentLengthDigits`; restore the input-bank variable (not the active hardware bank); and test whether the remaining chunk is final in the Base64 encoder and decoder.
- **Remaining symbol-census subsystems:** 112 accepted, with zero owner/definition mismatches, collisions, or missing references.
- **Engine path-review subsystems:** 25 accepted, with zero owner/definition/reference mismatches or collisions.

The corrected 112-row review also found 24 proposal evidence notes that needed wording fixes, without changing the names: eight gave the wrong LY immediate, four claimed a counter for NUL-terminated scans, and twelve copied an unrelated candidate-screen caveat. The final mapping records the reviewed evidence; the curated proposal/review tables in ignored `.tmp/jp-generic-name-batch-20261022-evidence/` preserve the audit trail and input hashes after the private build worktree was removed.

The resulting 546 names are operational local labels only. Confidence describes static instruction evidence, not natural reachability, hardware execution, product purpose, or a full caller contract. The four replacements and all remaining uncertainties retain narrow wording.

## What remains generic, and why

The 3,325 remaining `.lAAAA` definitions are explicitly accounted for by owner and disposition in the three census reports: short cosmetic anchors or blocks where a more useful name still depends on unresolved branch/dispatch meaning, data boundaries, or phase distinctions. This is **not** a claim that every remaining anchor has received semantic review or that Japanese ROM understanding is 100% closed. It does close the inventory and prevents another pass from claiming broad coverage without reconciling the full count.

The maintained-source global census still has **ten** `Data_BB_AAAA` labels. Prior byte/source review found no positive evidence to name their type, entry role, or reader; renaming them by nearby opcodes or negative literal-reference searches would overstate the evidence. No exact address-form `Function`, `Font`, `Tiles`, `Tilemap`, `Palette`, or similar global family remains in the reviewed Japanese source set. See [the earlier global census and per-label dispositions](japanese_generic_name_census_followup_20261023.md); this checkpoint does not silently reclassify those ten data spans.

## Verification

The change is limited to local label/reference tokens plus this mapping and documentation. The inverse mapping was applied within each local owner and reproduced every pre-change source scope byte-for-byte. On the isolated validation worktree at the above base commit, all gates passed after the four corrections:

- `make`: reference SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`, `RESULT: IDENTICAL`.
- `make sym-check`: 335 source files, 12,185 labels, 51 constants; all addresses match.
- `make palette-check`: 162 loads, 116 arrays, two documented over-reads, zero errors.
- `make png-check`: 408 tile sheets, four raw views, 37 font sheets and 95 screen PNGs; OK.
- `git diff --check`: OK.

The generated output remains a build artifact. No ROM bytes, graphics payloads, translation source, or frozen generator/config files were changed. The complete machine-readable mapping SHA-256 is recorded in the evidence ledger and commit.

## Audit digests

The exact proposal/review inputs and final mapping were hashed in the ignored validation worktree. These identify the source material behind the consolidated mapping without adding transient review dumps to the maintained tree:

| Artifact | SHA-256 |
|---|---|
| HOME/audio/library proposals (409) | `36a5534afb9cd48efb836011dbe170274f00700926738fa0f5c77e1fa7505bec` |
| HOME/audio/library independent review (409) | `a5fae65600b7c600fbde0a93902686829060ac65f5754e8387dcfbb56c8f0638` |
| Symbol-census proposals (112) | `bb495144e3f2a2bf949c3688149d577bcb14972c97f8be3eabe53f297e12e802` |
| Symbol-census independent review (112) | `b838819464dd48f08cdb0e4ec9f162b03ea8ca04d30024f503285f319215e19` |
| Engine path-review proposals (25) | `78ad21559db11fab3ca918812aac4847776d745b9e09822b16f5a5f6cf1a5315` |
| Engine path independent review (25) | `8cd5c83a41d89ed885d438e16b5e5997ea2ea1048bd03c6a36ae09ae669342c7` |
| Maintained 546-row final mapping | `d3dc8e1e19e82be59d8f4b977c3ab96c71ef6b71fbc14d1e3e8f480e0ae7fa1d` |
