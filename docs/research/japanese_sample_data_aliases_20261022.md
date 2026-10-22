# Japanese sample-data generic aliases (2026-10-22)

The five `Data_2D_AAAA` labels at `2D:42B2`, `42F8`, `436A`, `441B` and
`44D3` were exact-address aliases of the existing descriptive labels
`MailSample0_Header` through `MailSample4_Header`.

A broader address-form label census found eleven `String_2D_AAAA` aliases in
the same owner. Each was co-located with an existing sample field label:

| Removed alias | Existing label at the same address |
|---|---|
| `String_2D_42BB` | `MailSample0_Body` |
| `String_2D_42D0` | `MailSample0_Name` |
| `String_2D_42D7` | `MailSample0_Subject` |
| `String_2D_4301` | `MailSample1_Body` |
| `String_2D_4373` | `MailSample2_Body` |
| `String_2D_4424` | `MailSample3_Body` |
| `String_2D_44DC` | `MailSample4_Body` |
| `String_2D_45A6` | `AbookSample0_Name` |
| `String_2D_45B7` | `AbookSample1_Name` |
| `String_2D_462A` | `AbookSample4_Address` |
| `String_2D_465E` | `SampleData_Name` |

Removed these sixteen redundant symbol definitions from
`engine/mail/sample_data.asm`; the existing descriptive labels and all sample
record/string bytes and layout remain unchanged. The source crosswalk and
absence of consumers outside the owner were checked before removal; the
rebuilt linker map is the final address check. Blank source lines preserve the
physical line numbers.

The Japanese rebuild remains byte-identical to the reference ROM
(`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`). The
rebuilt symbol file contains 14 exact `Data_BB_AAAA` names and none of the five
retired `Data_` aliases; no `String_2D_AAAA` aliases remain. `sym-check` passes
with 12,184 labels; `palette-check` passes
with 162 loads in 116 arrays, two documented over-reads and zero errors.

This closes the specific address-form aliases only. It does not claim that the
sample records' field meanings are known.
