# Bank27 computed tile-pair table and bounded padding interpretation

This original-JP unit uses published30ed7f2f9e6c09d80b9935794bd747d337b900c7, after original26 was published ineecbd6407241705778e3a7f9a4fe39f76bf416b1 and its documentation follow-up. The earlier readonly proposal useda368dabb; the fresh rebase preserves the bank27 owner byte for byte. Exactly the existing comments at engine/mail/send_receive.asm:2013/2020 change. Both labels, both raw db rows, the ds row, source line counts and every emitted byte remain unchanged.

## Computed reader and exact original pairs

Original ROM27:5048..505C contains ten two-byte pairs. CommTime_PutDigit_27_5021 at27:5021..5048 computes DE=$5048+((2*A)&$FF). It saves BC/DE, copies the input destination into HL, reads the first byte through DE and stores it at the destination, then reads DE+1 and stores it at destination+$20. It writes attribute$08 at destination+$400 and destination+$420. The selected code bank is27; no ROM-bank switch occurs inside this consumer. The computed address contradicts the former no-reference hypothesis. The two-byte-per-index access contradicts treating this table as one20-column tilemap row with established four-byte row padding.

| index | first | second | second = first +$10 |
|---:|---|---|---|
|0|67|77|yes|
|1|68|78|yes|
|2|69|79|yes|
|3|69|6F|no: +$06|
|4|6A|7A|yes|
|5|6B|7B|yes|
|6|6C|7C|yes|
|7|6D|7D|yes|
|8|6E|7E|yes|
|9|6E|7F|no: +$11|

Exactly8 of10 pairs have the stated+$10 relationship, correcting the former9/10 assertion. Both exceptions and the repeated first byte6E remain exact; visual digit appearance is unvalidated. The existing Table_CommTime_DigitTiles_27_5048 and Data_27_5048 aliases retain their names and addresses.

## Caller bounds and unchanged unknowns

The three original direct writer calls are27:4F94,4FA9 and500D, corresponding to source lines1890,1900 and1964. The formatter at27:4FFB..5021 has calls at4F8A,4F90 and4FA5. The minutes caller locally clamps values at60 or above to59 and then stores59 as seconds; the lower-minutes branch does not locally clamp seconds. The digit consumer itself does not clamp A. Supplementary static arithmetic across the256 input values proves that A=0..9 selects the ten pairs; A=128..137 aliases them through8-bit doubling. Inputs outside that set may read outside the20-byte table. This arithmetic is not a runtime trace or promotion of arbitrary-input safety.

The four zero bytes at27:505C..5060 are preserved between the pair table and the aligned tile block beginning5060. Their storage and position are explicit; their former row-padding role is not established. The original69 coverage/dataaccess pairs contain zero consumer entries, zero entries at all three direct writer calls and zero natural reads of any byte in5048..5060. Absence is a limit of the existing scenarios, not proof of permanent unreachability. The table interpretation and padding comment therefore remain PROBABLE.

Function_27_4EC0 stays neutral, its entry remains unresolved, and no other function or header is renamed or promoted. Palette27:7520, neighboring bank24 resources, request templates, fonts and graphics retain their current status and representation. No frozen config regeneration, locator remapping, ROM operand substitution, English runtime/layout, emulator scenario, PPU, visual or hardware result is introduced. This bounded unit does not establish whole-bank semantic closure.
