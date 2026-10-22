# Verification — Bank 53 names and browser-frame assets (2026-10-23)

## Independent review

An independent reviewer checked the private snapshot and reproduced the baseline manifest (595 files, zero divergence), the 369-byte Bank 53 name block, all 25 `$D50` windows (85,200 bytes), 137 Bank 41–47 assets, 53 PNG inversions, 17 views, 24 preview PNGs, and the 208-file directory inventory. The reviewer found no missing or orphaned asset in the audited scope. The name-to-window mapping and runtime-unused status remain unproved.

The selector description is bounded to 27 indexed words and five 31-byte descriptors; a negative result for that chain is not a universal no-reader proof. The source comment was corrected to distinguish the 27 selector indices from the five descriptors.

## Japanese build gates

After the generated screen-catalog ID refresh and this source-comment clarification:

| Gate | Result |
|---|---|
| `make` | PASS — SHA-256 OK; `RESULT: IDENTICAL` |
| `make sym-check` | PASS — 335 files, 12,185 labels, 51 constants |
| `make palette-check` | PASS — 162 loads, 116 arrays, 2 overreads, 0 errors |
| `make png-check` | PASS — 408 tile sheets, 4 raw views, 37 font sheets, 95 screen PNGs |
| `gfx_export check` | PASS — 978 assets |
| `make test` | PASS — generator, SM83, CFG (48), PNG, palette-read (24), and retype-parts (6) suites |

`make test` emitted the existing `ResourceWarning` at `tools/test_cfg.py:398` for an unclosed `baserom.gbc` reader; all 48 CFG tests passed. No runtime emulator, hardware, or natural play scenario was run for this audit.
