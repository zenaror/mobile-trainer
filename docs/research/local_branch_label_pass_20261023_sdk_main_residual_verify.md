# Verification: Japanese Mobile SDK main residual local labels (2026-10-23)

## Proposal review

An independent reviewer audited all 413 rows and 534 local references, checked definition/reference coverage, duplicate names, collisions, unresolved symbols and instruction widths for 524 local labels. The final proposal SHA-256 is 532772c4742fcefbf6918b85f15c72e9304cfaff22086732cfd888ccf649c692; verdict: PASS, with 376 renames and 37 KEEP decisions. The reviewer specifically retained 75:418E, 75:7EC5, and 75:7F11 as neutral. Names remain static instruction/branch roles; they do not prove natural execution, external consumers, buffer guards, or termination.

## Source integrity

Base SHA-256: dc50b8badf2cc12d6f91e91105b183bf879d2bb3a6422abb49c129b72dc3c904.

Integrated SHA-256: 95d4d27de264c20f6a5f8429bbe4306f8fd49a215061e337faa57fb902255867.

The transformation renamed 376 definitions and 482 references. Reverse normalization by lexical owner reproduced the exact base source.

## Private validation gates

The private tree contained the page-list pass plus these two Japanese local-label batches. All gates passed:

| Gate | Result |
|---|---|
| make | PASS; SHA-256 OK and RESULT: IDENTICAL; 2,097,152-byte ROM hash 6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570 |
| make sym-check | PASS; 335 source files, 12,185 labels and 51 constants |
| make palette-check | PASS; 162 loads, 116 arrays, 2 documented over-reads, 0 errors |
| make png-check | PASS; 408 tile sheets, 4 raw byte views, 37 font sheets and 95 screen PNGs |
| python3 tools/gfx_export.py check | PASS; 978 assets |
| make test | PASS; generator suite, SM83, CFG (48), PNG, palette-read (24) and retype-parts (6) checks |

The run emitted the existing ResourceWarning in tools/test_cfg.py:398 for reading baserom.gbc; tests returned success. Byte identity verifies reconstruction for this Japanese source state only; it does not establish semantic completeness or runtime behavior.
