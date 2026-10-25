# Bank 73: bounded split returns at 6143

## Raw bytes and conditional decode

| Segment | Instruction starts | Byte extent | Ordinary terminal |
|---|---|---|---|
| [6143,6149) | 6143 LD A,[C0F8]; 6146 XOR01; 6148 RET | six bytes | RET6148 |
| [6149,614F) | 6149 LD A,[C0F9]; 614C XOR01; 614E RET | six bytes | RET614E |

## Established neighboring consumers

A full-ROM overlapping two-byte search finds eleven occurrences of the little-endian word6143 and four of6149. They are raw byte occurrences at bank-qualified physical offsets, not established direct/far/table callers. The source header's absolute statement that the address word does not exist anywhere is contradicted at this raw level; the occurrences do not prove any entry into bank73. A separate finite whole348 ASM/inc search finds only the neutral definition and these field-read contexts for the selected symbol/fields, alongside same numeric addresses in other banks. It cannot exclude computed targets, alternate decoding, indirect consumers or external state.

Exactly seven existing header comment rows235–241 change in engine/browser/start_choice.asm.

FillBytes00:04D8 supplied A0,BC00FC,HLC0D4 at73:5F33 clears252 bytes in[C0D4,C1D0), including both fields by indexed stores.

## Operation alias for reading C0F8 XOR1

`ReadC0F8_Xor1` is a PROBABLE description of the six-byte local operation at73:6143, preserving `Function_73_6143`.

A complete six-byte parametrized twin occurs at50:4304..430A exclusive: `FA D4 C0 EE 01 C9`.

The sibling's source path reaches4304 from `CommNotice_Input_ButtonA` when its mode argument is nonzero.

`CommNotice_ShowDialog` tests the returned A after CALL RunDialog using OR A/JR NZ (`engine/comm/notice_dialog.asm:23..25`).

That store path has no claimed natural execution here.

Neither the sibling's cursor meaning nor the caller's disconnect/continue interpretation is assigned to C0F8/C0F9.

At73:62D2/62D5/62D6 (`engine/browser/start_choice.asm:429..431`) C0F8 is read, tested with OR A and returns on zero.

The earlier documented FillBytes initialization beginning73:5F33 clears[C0D4,C1D0), including both fields, through indexed stores.

For arbitrary input byte x, the operation returns A=x XOR1, toggling bit0 of the returned value while retaining its other seven bits. Z is set exactly for x=1; N/H/C are cleared. BC/DE/HL are unchanged by the three instructions. There is no memory store, bank selection or normalization to0/1. Under stable ROM73 mapping, readable fixed WRAM0, a valid nonaliasing ordinary return stack and no relevant interrupt interference, RET consumes the normal return word. This is not a generic calling convention or interrupt/atomicity proof. A name implying a persistent toggle or general Boolean negation would be unsupported.
