# Bank 53, Pokémon frame and PNG revalidation (2026-10-24)

This finite Japanese-only recheck uses documentation HEAD `8dd8d59d0246b2c5c7f2f042cca7c26c33b9ac96` and the unchanged maintained-source baseline `25501d4b80a8370ab2b7482dd8388f99ca4df417`. The original `Mobile Trainer (Japan).gbc` is 2,097,152 bytes with SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Comparing the baseline to HEAD found documentation-only changes; no ASM/INC, GFX asset, PNG, language overlay, or ROM source changed.

## Bank 53 name block

A read-only decode of the original bank at physical bank `53` confirms the range `53:4000-4171` contains 25 little-endian pointers and 25 NUL-terminated Japanese strings: 50 pointer bytes plus 319 string bytes, 369 bytes total. All pointers are strictly increasing and target the string interval `53:4032-4171`. The remainder of bank 53 through `53:8000` is zero. The rebuilt `mobile_trainer.gbc` has the same whole-ROM SHA-256 as the protected original.

These facts confirm the complete encoded name table and its byte placement. They do not establish a reader, natural selection, or association between any name ordinal and a frame image.

## Bank 41–47 assets and PNGs

The current `gfx/assets.tsv` has 137 rows across eight owner directories for physical banks `41–47`, totaling 93,264 bytes: 49 tile assets, 28 palettes, 28 tilemaps, 28 attribute maps, and four raw-byte views. Every file exists and reconstructs exactly the corresponding original-ROM slice. The audit interprets the catalog bank column as hexadecimal and uses file offset `bank * 0x4000 + address - 0x4000`; palette text is decoded with the project's `tools.gfx_export.palette_bytes` implementation. This cross-check found zero missing assets and zero source-to-ROM byte mismatches.

The eight owner directories contain 71 PNGs. The asset catalog resolves 53 source PNGs, and `gfx/screens.tsv` accounts for the remaining 18 screen compositions. Their union equals the files present in scope: zero missing and zero orphan PNGs. This is a bounded inventory; it does not claim every ROM graphic has been discovered or naturally displayed.

At this HEAD, `make png-check` accepts 418 tile sheets, four raw byte views, 37 font sheets, and 95 screen PNGs; `python3 tools/gfx_export.py check` accepts 988 assets; `python3 tools/png_rules.py mk-check` accepts 987 rules.

## Remaining frame questions

Visual inspection identifies species-like artwork for 23 of the 25 names (PROBABLE visual identities); both Porygon entries remain unassigned. All 25 ordinal-to-window links remain HYPOTHESIS. Eight windows remain KEEP as editable compositions because their complete VRAM placement is not justified; their original bytes and backing assets exist. No frame is classified globally unused, and natural frame selection remains unknown. Do not assign the two geometric windows to Porygon/Porygon2 by elimination, synthesize unresolved VRAM keys, or treat a missing editable composition as a missing ROM asset.

The broader Japanese source review remains separate from this finite frame inventory: the current name census has no strict address-only `Function_`, `Data_`, or `Font_` placeholders and all 15 finite coverage families reconcile, while five named operation-entry candidates still lack proven natural roots. Those entry/purpose uncertainties do not imply that an unnamed generic function remains in the maintained source.

## Reproduction and validation

The focused source-to-ROM and PNG inventory receipt is `.tmp/jp-bank53-frame-reconcile-20261024/RESULT.json` (SHA-256 `4679a38fbfb7d8d651d9b0d1f56d432f839ba559d9cace1c0065e7a8bcd8184a`); its read-only script is `.tmp/jp-bank53-frame-reconcile-20261024/audit.py` (SHA-256 `2fbd8d7a38085495ef29d2702b45fecec8958fcb2ff7cd246f957a72306126f5`). Run from the canonical checkout with `python3 .tmp/jp-bank53-frame-reconcile-20261024/audit.py`.

On this same HEAD, `make` reports `SHA-256 OK` and `RESULT: IDENTICAL`; `make sym-check` passes with 335 source files, 12,214 labels, and 51 constants; `make palette-check` reports 162 loads, 116 arrays, two documented over-reads, and zero errors; the Japanese name census passes all 15 families with zero open rows; the graphics catalog and PNG-rule checks pass. `make test` passes the generator, SM83, CFG (48 tests), PNG, palette-read (24 tests), and retype-parts (6 tests) suites. It emits the existing non-fatal `ResourceWarning` for the `baserom.gbc` reader at `tools/test_cfg.py:398`.

No ROM, Japanese source, image, or translation file changed in this audit. The English overlay and Operator ZIP remain paused pending the Operator's explicit approval.
