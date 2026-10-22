# Japanese local operation labels: Mobile SDK, sprite counters and image blitter (2026-10-22)

This pass replaces **282 address-derived local labels** in three Japanese ASM
owners with operation names. It covers 20 labels in the Mobile SDK, 135 labels
across 15 sprite-counter routines, and 127 labels in the inline image blitter.
The names describe local instruction and branch behavior only; their
interpretations are **PROBABLE** static descriptions, not evidence of natural
entry, runtime behavior, or hardware behavior.

The exact address-to-name mapping, owner, source line, and old local-reference
count are recorded in [`local_label_mapping_20261022.tsv`](local_label_mapping_20261022.tsv).
It contains one row per renamed definition. Original snapshots for the three
owners were independently hashed before integration. The active checkout's
three source diffs contain only label-token substitutions; instruction bytes,
data, comments, operands, whitespace and line count are unchanged.

| File | Preimage SHA-256 |
|---|---|
| `lib/mobile/main.asm` | `f4b1fb32edbaa682d9ad589cccf6911ca752f6889c8426088895a68b4f4fa438` |
| `engine/mail_server/delete_sprite_counters.asm` | `94298ab38d430439460fd349479e9fa548f3830640b12397e66e6055869b3a28` |
| `engine/browser/inline_image_blit.asm` | `a3e595fcc22c9060fcbadec7e226009e2eacb73c972865db214478a666ab8629` |

| Source owner | Renamed definitions | References | Decision notes |
|---|---:|---:|---|
| `lib/mobile/main.asm` | 20 | 43 | Independent review accepted 19 proposals, adjusted `$75:42F1` to `.append_size_plus_one_and_copy_chunk`, and accepted retaining `$75:418E` as `.l418E`. |
| `engine/mail_server/delete_sprite_counters.asm` | 135 | 135 | 15 routines each use `.check_value_1` through `.check_value_8` and `.use_default_entry`. The last target loads `Entry36` after the value 8 check; it is not named as digit 9. Independent review accepted all 135. |
| `engine/browser/inline_image_blit.asm` | 127 | 182 | Independent review accepted all 127 names. Names distinguish local source/mask/store paths and shift dispatches without inferring pixel-plane or color semantics. `.l72D4` and `.l7383` remain neutral because the related object/value contracts are not established. |
| **Total** | **282** | **360** | Repeated local names remain scoped to their respective owners. |

The integrated source hashes are:

| File | SHA-256 |
|---|---|
| `lib/mobile/main.asm` | `dc50b8badf2cc12d6f91e91105b183bf879d2bb3a6422abb49c129b72dc3c904` |
| `engine/mail_server/delete_sprite_counters.asm` | `884f823fbee964cd961e4c9b71815a76b864c3967a941cb4715a67e2f2c9e041` |
| `engine/browser/inline_image_blit.asm` | `50abb5fbfb8a114488e2fa379cfbc7a92f5da1bb9317bbdd7d2f41b6bdaf9ba7` |
| Mapping TSV | `053a7a90f58ba2d5c1f7fbc8bc4ba5987d6aa5817513743ffa93a34eee35a725` |

The tracked Japanese ASM/INC census, excluding the protected
`engine/mail/sample_data.asm`, has 4,491 `.lAAAA` local labels in 333 files
across the six maintained roots, down from 4,773 immediately before this pass.
The same bounded census has zero address-form `Function_BB_AAAA`,
`Func_BB_AAAA`, `Sub_BB_AAAA`, `Label_BB_AAAA`, and `Font_BB_AAAA` definitions, plus 13 exact
`Data_BB_AAAA` labels. Those 13 remain neutral pending evidence; this lexical
census does not establish that all functions, data, assets or resources are
semantically closed. The English overlay is outside this census and remained
paused.

Verification on the Japanese checkout:

- `make`: SHA-256 OK; 2,097,152 bytes; `RESULT: IDENTICAL` to the original ROM,
  SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
- `make sym-check`: 335 source files, 12,185 labels, 51 constants; OK.
- `make palette-check`: 162 loads in 116 arrays, two documented over-reads,
  zero errors.
- `make png-check`: 408 tile sheets, four raw byte views, 37 font sheets, and
  95 screen PNGs; OK.
- `python3 tools/gfx_export.py check`: 978 assets; OK.
- `make test`: all generator, SM83, CFG, PNG, palette-reader and retype tests
  passed. One existing `ResourceWarning` reports an unclosed ROM fixture
  reader in `tools/test_cfg.py`; the suite returned OK.

These checks confirm static naming and byte-identical reconstruction. They do
not establish runtime, natural reachability, or hardware behavior.
