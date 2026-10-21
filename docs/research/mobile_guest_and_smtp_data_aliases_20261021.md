# Mobile guest string and SMTP argument aliases — 2026-10-21

Two exact bank-54 `Data_*` aliases were retired from maintained source:

| retired spelling | retained spelling | address | basis |
|---|---|---:|---|
| `Data_54_413B` | `String_Mobile_GuestLogin` | `54:413B` | same six bytes; the existing CONFIRMED string name and source comment record its two uses as login ID and password |
| `Data_54_475A` | `Data_Smtp_HeaderComposeArgs` | `54:475A` | same ten-byte argument seed copied by `Smtp_StartMailFrom`; the existing structural name, RAM evidence and confidence limit are unchanged |

The active SRAM annotation now refers to `Data_Smtp_HeaderComposeArgs`. The obsolete numeric hypothesis entry was removed from `tools/data_consumers.py`, whose output no longer treats the old name as a neutral candidate. Historical `config/`, `analysis/`, and naming-pass snapshots keep their original spellings. This change does not upgrade the SMTP source block's existing `PROBABLE` grade or claim every later mutation field is understood.

`data_consumers.py --stats` reports 287 neutral groups and zero candidate rows; `make test` passes. The normal dry-run included the protected sample after the SRAM comment edit, so the checked build used `make -o ram/banked.asm -o engine/mail/sample_data.asm`, with the existing sample object reused and no RGBASM invocation for that source. Its link reports `RESULT: IDENTICAL` (2 MiB, SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`); the same overrides pass `sym-check` (12,312 labels, 51 constants) and `palette-check` (162 loads, 116 arrays, two documented over-reads, zero errors). An earlier unqualified `make` invocation was interrupted after the normal plan was found to include the protected source; because its output was truncated, it is unknown whether RGBASM reached that target. The override validation does not resolve that uncertainty.
