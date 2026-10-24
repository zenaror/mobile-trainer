# ROMX mapper writes and the following instruction fetch

## Scope and evidence

CONFIRMED static result on source based on `b4863f2a7916936ac75da56088c6773a6618d403`: 333 maintained ASM/INC files contain 55 resolved textual `ld [absolute], a|sp` stores into $2000–$3FFF. Three sites belong to ROMX owners. All recognized absolute expressions resolved. This is not an exhaustive census of computed writes, macro/data-emitted instructions, or execution outside declared owners.

Original ROM SHA-256: `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. The three instruction encodings were checked against this ROM. Reproduction script, source hashes and rows are retained in `.tmp/jp-romx-mapper-write-20261024/`; these are static evidence, not new runtime observations.

| Physical source | Instruction bytes | Next fetch | Interpretation |
| --- | --- | --- | --- |
| 68:424E | EA 00 21 | 4251 | A ROM-bank change can replace the lexical Bank68 RET. |
| 29:510F | EA 00 20 | 5112 | A ROM-bank change can replace the lexical XOR A and remaining sequence. |
| 29:5113 | EA 00 30 | 5116 | A high-bank change can replace the lexical RET; reaching this store itself is conditional. |

## Producer and continuation contracts

`Profile_Edit` supplies A=0 and HL=`sProfileAddress` ($AF50) to `Account_CopyMailAddressToFar`. That routine saves and reloads the arguments before calling `BankSwitch_H_Local`. With those saved arguments intact, H=$AF selects the SRAM branch and cannot reach 68:424E. This bounded producer contract does not prove behavior for corrupted saved state or all possible callers. The local helper differs from the ROM0 helper: it has no A=0 early return.

`PalLibCandidate_WriteRomBankLowAAndZeroHigh` describes the physical byte sequence, not an unconditional runtime contract. The first store may replace the bytes fetched at $5112 before the high-bank clear. Its natural entry and selector domain remain HYPOTHESIS. The earlier `typing_29_leaf_lcdc_ly_limits.md` already identifies this remapping concern; this pass consolidates the direct-store scope and corrects the source annotation, rather than claiming a new natural entry.

## Consequence for semantic closure

An indirect-jump census alone cannot close these transitions: mapper writes change instruction provenance without a JP HL. This pass establishes the above three sites and the bounded Profile_Edit producer. It does not establish unused code or a Pokémon/frame association.

Remaining distinct analysis: callers of the ROM0 bank-switch helpers and their return-bank contracts, computed mapper writes, and producers of copied executable RAM. Do not repeat the completed direct textual-store census unless the source or its parsing scope changes.

## Verification

`make`: RESULT: IDENTICAL (2,097,152 bytes, original SHA-256 above). `make sym-check`: 335 source files, 12,223 labels, 51 exported constants, OK. `make palette-check`: 162 loads, 116 arrays, two documented over-reads, zero errors. Only source comments changed. Small script/results/logs are retained as the reproducible evidence for this pass; no historical directories were recreated.
