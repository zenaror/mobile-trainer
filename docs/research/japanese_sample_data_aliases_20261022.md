# Japanese sample-data generic aliases (2026-10-22)

The five `Data_2D_AAAA` labels at `2D:42B2`, `42F8`, `436A`, `441B` and
`44D3` were exact-address aliases of the existing descriptive labels
`MailSample0_Header` through `MailSample4_Header`. Removed only those five
redundant symbol definitions from `engine/mail/sample_data.asm`; all record
bytes, layout, comments and descriptive labels remain unchanged. The address
crosswalk was verified in the rebuilt linker symbol file.

The Japanese rebuild remains byte-identical to the reference ROM
(`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`). The
rebuilt symbol file contains 14 exact `Data_BB_AAAA` names and none of the five
retired aliases. `sym-check` passes with 12,195 labels; `palette-check` passes
with 162 loads in 116 arrays, two documented over-reads and zero errors.

This closes the specific address-form aliases only. It does not claim that the
sample records' field meanings are known.
