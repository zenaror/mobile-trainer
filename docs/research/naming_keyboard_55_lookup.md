# Prepared original bank 55 lookup evidence limits

## Bounded static contract

`Function_55_6EEC` remains neutral and PROBABLE. With physical ROM bank 55
stable, ordinary uninterrupted flow and a valid, nonaliasing return stack,
its eight instructions occupy exactly eleven bytes:
`21 f7 6e 85 6f 3e 00 8c 67 7e c9` at 55:6EEC–6EF7 (exclusive).
They compute `HL = $6EF7 + unsigned entry A` and return `A = ROM55[HL]`.
BC and DE have no explicit writes. HL and A change; the routine makes one
indexed ROM read, no data or mapper write, and no local push/pop. Ordinary
RET consumes the caller's return address and advances SP by two.

The ADD establishes the low-byte carry, and the intervening LD instructions
preserve it. `ADC A,H` adds zero, $6E and that carry, producing $6E or $6F
with Z=N=H=C=0 for all 256 byte inputs. The final LD and RET preserve F=$00.
A returned zero therefore does not itself set Z. These are static facts
under the stated execution conditions, not a runtime or hardware result.

`Data_55_6EF7` remains neutral and its whole eleven-byte storage remains
PROBABLE. Bytes at 55:6EF7–6F02 are `00 00 00 00 00 00 01 01 01 01 01`:
indices 0–5 yield zero and 6–10 yield one. They match the bytes at 55:6EB5
but occupy distinct addresses; matching bytes do not establish a shared
purpose. There is no bounds check. Input 11 reads $21 at 55:6F02, the next
routine's opcode, and inputs 11–255 read neighbouring ROM through $6FF6.
The zero/one description is limited to the table's eleven indices. Neither
the universal entry domain nor the field/consumer purpose is demonstrated.

The sole maintained symbolic CALL is at 55:5DF8 in the HYPOTHESIS block
55:5DF5–5E02. It loads `wKbdType`, calls the lookup, executes OR A and selects
55:5E5A for zero or 55:5F29 for nonzero. The preceding unconditional JP at
55:5DF2 targets 55:5E5A and bypasses this block; this proves that local
predecessor has no fall-through, not that every possible entry is unreachable.
The caller supplies no local range clamp.

Physical bytes and static arithmetic are separately checked: the 11-byte lookup and 11-byte table remain exact, all 256 unsigned inputs compute 6EF7+A without bank change and with ADC-derived F00; index 11 reads opcode 21. Conditional handler selection and unconditional CALL 5F2A once entered remain distinct. Caller/handler purpose and entry remain HYPOTHESIS; neutral PROBABLE function/data are unchanged.
