# Japanese local operation labels: Mobile SDK and keyboard (2026-10-23)

This pass replaces 72 numeric local labels with operation names in
`lib/mobile/main.asm` (23), `lib/mobile/mail.asm` (25), and
`engine/keyboard/keyboard.asm` (24). Names describe visible local instruction
flow only. They do not establish product-level meaning, a caller, or natural
execution; the operation interpretations are **PROBABLE** static descriptions.

The candidate snapshots were based on `a691d5560153c974fafd1ed18ee6d8e7ec81f521`.
An independent reviewer accepted all 72 names, checked their owners, local
references and collisions, and found no qualified external references to the
old local names in the reviewed ASM/INC sources. Reversing only the 72 symbol
tokens exactly reproduces the three preimages: address and confidence comments,
instructions, operands, data, and whitespace are unchanged. The `.sym` delta is
exactly 72 removed and 72 added names at the same addresses, with no other
symbol-address changes. Per-name mapping, input/output hashes, and reviewed
diffs are retained in the ignored task evidence under
`.tmp/local-label-pass-20261023/`.

| Source owner | Count | Address range | Examples of adopted operation labels |
|---|---:|---|---|
| `lib/mobile/main.asm` | 23 | Bank 75 | `.restore_bc_and_return`, `.compare_length_limit`, `.write_thousands_digit`, `.scan_leading_zeroes` |
| `lib/mobile/mail.asm` | 25 | Bank 0F | `.copy_header_byte`, `.return_output_length`, `.check_saved_paren_opener`, `.check_saved_quote_opener` |
| `engine/keyboard/keyboard.asm` | 24 | Bank 55 | `.set_up_window_and_panel`, `.check_instant_mode`, `.dispatch_buttons`, `.move_left`, `.check_type5_select_arg_b` |

The keyboard label at `55:5DF5`, `.CheckTypeThenContinueOrHide`, was not changed;
its existing note that natural entry is unproved remains. The other 89 numeric
local labels in that keyboard owner remain outside this pass. A separate bounded
review of 12 neutral `Data_BB_AAAA` names found insufficient evidence to infer
code entry or resource type; those labels remain neutral. This is consistent
with the retained findings in
[`generic_data_name_audit_20261020.md`](generic_data_name_audit_20261020.md),
not a claim that all other data has been identified.

The tracked Japanese ASM/INC census, excluding the protected
`engine/mail/sample_data.asm`, found 4,845 `.lAAAA` definitions at the base
revision and 4,773 after this pass (333 files in the six maintained source
roots). These are local branch labels, not unidentified functions. They remain
for further evidence-based review.

Validation on the official Japanese checkout:

- `make`: SHA-256 OK; 2,097,152 bytes; `RESULT: IDENTICAL` to the original ROM,
  SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
- `make sym-check`: 335 sources, 12,185 labels, 51 constants; OK.
- `make palette-check`: 162 loads, 116 arrays, two documented over-reads, zero
  errors.
- `make png-check`: 408 tile sheets, four raw byte views, 37 font sheets, and
  95 screen PNGs; OK.
- `python3 tools/gfx_export.py check`: 978 assets; OK.
- `make test`: all generator, opcode, config, PNG, palette-reader, and retype
  tests passed. One existing `ResourceWarning` reports an unclosed fixture
  reader in `tools/test_cfg.py`; the suite still returned OK.

These are static naming and reconstruction checks. They do not establish
runtime or hardware behavior.
