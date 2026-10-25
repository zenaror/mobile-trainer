# Japanese sample-data generic aliases

The five `Data_2D_AAAA` labels at `2D:42B2`, `42F8`, `436A`, `441B` and
`44D3` were exact-address aliases of the existing descriptive labels
`MailSample0_Header` through `MailSample4_Header`.

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

This closes the specific address-form aliases only. It does not claim that the
sample records' field meanings are known.
