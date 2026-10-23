# Japanese operation-boundary follow-up (2026-10-23)

This batch consolidates three operation spans that were already described in
current research notes but still lacked an operation label in maintained source.
It is separate from the closed lexical generic-name census: these candidates were
found in bounded static operation reviews, not by repeating token searches.
Each new label names byte-level behavior only. A descriptive operation label does
not assert a natural entry, caller, application role, or reachability.

The immutable Japanese ROM is 2,097,152 bytes with SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Offsets
use physical bank mapping `bank * 0x4000 + address - 0x4000` for ROMX.

| Bank:range (end exclusive) | Bytes | Original ROM slice SHA-256 | Source label | Directly observed mechanics | Remaining limit |
|---|---:|---|---|---|---|
| `2C:6100–614D` | 77 | `a2318b577b6787de667d88ccb22f881cde56293e2fc23568e2b5248aa0abc24e` | `AddrPick_DrawSixSlotNamesAtX30` | Enables SRAM bank 1; iterates six entries from `Table_AddrPick_SlotAddrs`, calls `AddrBook_DrawSlotName` at X=`$30`, then disables SRAM. | Entry and caller HYPOTHESIS; raw bounds/static calls do not establish natural entry. |
| `55:6F46–6F95` | 79 | `661b5aa7b41b46856203cd72457160d8929736cea3f9e4a50a1f3e3877dd7a8c` | `Kbd_Candidate_DecrementC2B1OrAdvanceC2B0AndWriteOcpd` | Decrements C2B1 and returns when nonzero; otherwise waits, advances C2B0 modulo four, loads the indexed delay and pair, writes OCPD, services sound, and copies the pair into the WRAM7 palette buffer. | Entry, caller, and exact table role HYPOTHESIS; the existing 12-byte table association remains conditional on this reader. |
| `73:6149–614F` | 6 | `3429ac2c9c4a332cdea438704519f2897ba1239d970c00d80f536854b3338045` | `ReadC0F9_Xor1` | Reads C0F9, XORs bit 0, and returns without storing. | Entry, input domain, and purpose HYPOTHESIS; adjacent RET at 614E prevents ordinary fall-through into 614F. |

The slice hashes bind each description to original bytes. The 2C and 55 spans
were decoded previously in `classify_g2.md` and `naming2_verify_fn4.md`; the 73
split was independently decoded in `naming_73_6143_split_returns.md`. The labels
do not promote the original HYPOTHESIS entry evidence. Existing direct-entry
searches remain closed; reopen them only with a distinct positive caller or
producer source.

## Validation

After adding the labels and updating the owner-boundary comment, `make` returned
`RESULT: IDENTICAL` against the reference ROM. `make sym-check` passed with 335
source files and 12,211 labels; palette check reported 162 loads in 116 arrays,
two documented over-reads and zero errors; PNG check passed 410 tile sheets,
four raw views, 37 font sheets, and 95 screen PNGs. The full Japanese name census
and local-anchor ledger reconciliation were rerun. No English overlay or ZIP
material was inspected, modified, built, or tested.
