# Bounded typing of original page-cache records

`Table_PageCache_Slots` and `Table_4C_4CEA` name the same twelve original bytes at `4C:4CEA–4CF6`. Both aliases and the whole-unit **PROBABLE** status are preserved. Only the two naturally read address fields become words; SRAM bank bytes and the six unread bytes remain raw.

| Physical record | Original address/bank | Natural reads | Representation |
| --- | --- | --- | --- |
| 0 | `$A000`, SRAM 2 | All three bytes, 14 scenarios | `dw $A000`, `db $02` |
| 1 | `$B000`, SRAM 2 | All three bytes, 2 scenarios | `dw $B000`, `db $02` |
| 2 | `$A000`, SRAM 3 | None | Three raw bytes |
| 3 | `$B000`, SRAM 3 | None | Three raw bytes |

Push and Pop load the table base at `4C:4CB4` and `4C:4D4A` and add the slot three times. Each reads address low byte, high byte and SRAM bank in that order. Push uses the address as destination DE and passes the bank through `hPageCache_DestBank`; Pop reconstructs the source address and passes its bank through `hPageCache_SourceBank`. The shared long-copy routine selects the source/destination SRAM banks while copying. This consumer chain, not the value pattern, demonstrates the front fields.

The initialized logical ring uses positions zero through two: reset clears the index/count; Push increments and wraps at three; Pop decrements and wraps to two. The fourth physical record does not create a fourth ring position. The third is statically selectable but unobserved. No pre-lookup clamp establishes safe behavior for arbitrary corrupted indices. Push's source is SRAM3 `$B000` with length `$1000`; Pop accepts its callers' lengths. This pass asserts no universal output capacity, arbitrary-input safety or new dynamic behavior.

The preceding header said only the first record was naturally read. The second also has natural evidence. The corrected header records first/second counts separately and leaves `4CF0–4CF5` unread. All twelve original bytes and the following instruction at `4CF6` retain their exact addresses.

The source gains eight lines. Twelve active records in `ram12_sram_manual.tsv` move by eight lines; every operand, bank, proof, context, status and row order is preserved. The complete census is 289 maintained TSVs, 43 matching rows and 31 active physical locators, with 19 stable and 12 moved. Historical records are not rewritten by assuming a global line delta.

Independent executable review passed 1,821 checks, including all 295 owner instructions and the exact twelve line-only updates. Six independently repeated lookup probes use SYNTHETIC indices and do not promote unread storage or natural coverage. The original packet was sealed at `27e545b`; integration rebases only the disjoint `page_loader.asm` guard after published `e4ddc9c`. Its eight-byte dialog representation preserves all 646 instructions. Original seals remain untouched and the explicit rebase receipt preserves provenance.

No new natural execution, PPU or hardware evidence is asserted. Frozen configuration, generator, assets and shared macros are unchanged. See `typing_4c_page_cache_verify.md` for full-ROM and final integration gates.
