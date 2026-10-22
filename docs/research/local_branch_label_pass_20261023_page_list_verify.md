# Verification: Japanese page-list prototype local labels (2026-10-23)

## Static proposal review

The independent reviewer audited all 117 proposed rows, all local reference sites, owner/address assignments, proposed-name collisions, and the full 2,787-line source snapshot. The initial review requested correction of two names implying a frame count/duration and two evidence statements that described an unsigned greater-than comparison as generic inequality. The corrected proposal was re-reviewed and accepted. Its final SHA-256 is `9d99b614d60741f6f6bf58268cf32f0ede9cab009b45c856c7ee88e088f7dba6`.

## Source integrity

Base source SHA-256: `51337dbe489a2cbd0250624761e036c551ad31a2599c9f4097f6e2e1c16f2f06`.

Integrated source SHA-256: `bc931af9e0c4eca94115dc3cbe85be7900e119c594a43fce9b840680fdbd4104`.

The deterministic transformation renamed 116 definitions, changed 162 references, preserved one KEEP definition/reference, and reconstructed the exact source when the label map was reversed by lexical owner. Address comments, instructions, operands and data bytes were left unchanged.

## Build and project gates

All gates ran on the active checkout after source integration:

| Gate | Result |
|---|---|
| `make` | PASS; SHA-256 OK and `RESULT: IDENTICAL`; both reference and build are 2,097,152 bytes with SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570` |
| `make sym-check` | PASS; 335 source files, 12,185 labels, 51 constants |
| `make palette-check` | PASS; 162 loads, 116 arrays, 2 documented over-reads, 0 errors |
| `make png-check` | PASS; 408 tile sheets, 4 raw byte views, 37 font sheets, 95 screen PNGs |
| `python3 tools/gfx_export.py check` | PASS; 978 assets |
| `make test` | PASS; generator, SM83, CFG (48 tests), PNG, palette-read (24 tests) and retype-parts (6 tests) checks all passed |

The test run emitted the existing `ResourceWarning` in `tools/test_cfg.py:398` for reading `baserom.gbc`; the suite returned success. A byte-identical build confirms reconstruction identity for the checked Japanese source and ROM hash; it does not establish semantic completeness, reachability, natural execution or hardware behavior.
