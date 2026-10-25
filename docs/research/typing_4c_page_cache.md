# Bounded typing of original page-cache records

`Table_PageCache_Slots` and `Table_4C_4CEA` name the same twelve original bytes at `4C:4CEA–4CF6`. Both aliases and the whole-unit **PROBABLE** status are preserved. Only the two naturally read address fields become words; SRAM bank bytes and the six unread bytes remain raw.

| Physical record | Original address/bank | Natural reads | Representation |
| --- | --- | --- | --- |
| 0 | `$A000`, SRAM 2 | All three bytes, 14 scenarios | `dw $A000`, `db $02` |
| 1 | `$B000`, SRAM 2 | All three bytes, 2 scenarios | `dw $B000`, `db $02` |
| 2 | `$A000`, SRAM 3 | None | Three raw bytes |
| 3 | `$B000`, SRAM 3 | None | Three raw bytes |

Push and Pop load the table base at `4C:4CB4` and `4C:4D4A` and add the slot three times. Each reads address low byte, high byte and SRAM bank in that order. Push uses the address as destination DE and passes the bank through `hPageCache_DestBank`; Pop reconstructs the source address and passes its bank through `hPageCache_SourceBank`. The shared long-copy routine selects the source/destination SRAM banks while copying. This consumer chain, not the value pattern, demonstrates the front fields.

The preceding header said only the first record was naturally read. The second also has natural evidence. The corrected header records first/second counts separately and leaves `4CF0–4CF5` unread. All twelve original bytes and the following instruction at `4CF6` retain their exact addresses.

Twelve active records in `ram12_sram_manual.tsv` move by eight lines; every operand, bank, proof, context, status and row order is preserved.
