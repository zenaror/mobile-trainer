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
| `55:6F46–6F95` | 79 | `661b5aa7b41b46856203cd72457160d8929736cea3f9e4a50a1f3e3877dd7a8c` | `Kbd_Candidate_DecrementC2B1OrAdvanceC2B0AndWriteOcpd` | Decrements C2B1 and returns when nonzero; otherwise waits, advances C2B0 modulo four, reads one of four indexed words and one of four C2B1 reload counts, writes the word to OCPD, services sound, and copies the word into the WRAM7 palette buffer. | The direct indexed layout is PROBABLE; natural entry, caller, and visible effect remain HYPOTHESIS. |
| `73:6149–614F` | 6 | `3429ac2c9c4a332cdea438704519f2897ba1239d970c00d80f536854b3338045` | `ReadC0F9_Xor1` | Reads C0F9, XORs bit 0, and returns without storing. | Entry, input domain, and purpose HYPOTHESIS; adjacent RET at 614E prevents ordinary fall-through into 614F. |

The slice hashes bind each description to original bytes. The 2C and 55 spans
were decoded previously in `classify_g2.md` and `naming2_verify_fn4.md`; the 73
split was independently decoded in `naming_73_6143_split_returns.md`. The labels
do not promote the original HYPOTHESIS entry evidence. Existing direct-entry
searches remain closed; reopen them only with a distinct positive caller or
producer source.

## Bank-55 indexed data clarification (2026-10-23)

At source snapshot `ba385306`, the bounded reader at `55:6F46` directly forms
two indexes from the same `wRam_C2B0` value after masking it to `0..3`: `2*i`
selects a two-byte word at `55:6F95`, while `i` selects a byte at `55:6F9D`.
The routine sends the selected word to `rOCPD` and copies that word into
`wPaletteBufObj+$32`; it writes the selected byte to `wRam_C2B1`. The bytes are
`54 7F FF 7F 54 7F 12 7E 06 0C 06 06` (original ROM offset `0x156F95`,
slice SHA-256 `b1b7edfe6be9672ba955c62dde9ff198f07a7d00dea570d7a04423ff0b1f3338`).

A separate source census found the field producer: executed-entry routine
`Kbd_Open` initializes `wRam_C2B0` to `$FF` and `wRam_C2B1` to `$01`
(`engine/keyboard/keyboard.asm:33,35`). Across maintained ASM/INC, those stores
and the candidate reader are the only references to the two fields. This is a
positive producer/context link for the candidate state contract, but no source
call or other incoming edge to `55:6F46` was found. The RAM equates stay neutral
because that missing edge leaves their use conditional; this producer does not
prove natural entry to the reader.

The source label is now `Kbd_Candidate_PaletteWordsAndReloadCounts`, with a
`[PROBABLE]` data header. This names the statically observed layout and preserves
the `Candidate` qualifier. It does not establish that the routine is naturally
entered, who calls it, what screen or sprite is affected, or whether the words
are ever displayed. Those remain HYPOTHESIS. Original bytes and the enclosing
operation extent are unchanged; this is a source/documentation naming update,
not a new trace or a claim of runtime behavior.

The post-change gates passed: `make` returned `SHA-256 OK` and `RESULT: IDENTICAL`
for the 2 MiB Japanese ROM; `make sym-check` passed with 335 source
files, 12,212 labels and 51 constants; `make palette-check` reported 162 loads
in 116 arrays, two documented over-reads and zero errors. The name census
reconciled all 15 families, including 269 `Candidate` labels and 545 broad
dispositions; the 2,764 local-anchor, 109 suffix and 786 RAM ledgers matched.
`git diff --check` passed. These checks establish reconstruction and metadata
consistency, not execution or visible palette behavior.

## Validation

After adding the labels and updating the owner-boundary comment, `make` returned
`RESULT: IDENTICAL` against the reference ROM. `make sym-check` passed with 335
source files and 12,211 labels; palette check reported 162 loads in 116 arrays,
two documented over-reads and zero errors; PNG check passed 410 tile sheets,
four raw views, 37 font sheets, and 95 screen PNGs. The full Japanese name census
and local-anchor ledger reconciliation were rerun. No English overlay or ZIP
material was inspected, modified, built, or tested.
