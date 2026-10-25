# Bank 7C:7D8D — static choreography and entry limits

## Calling and polling sequence

| CALL site | Inline bytes | Target | Continuation |
|---|---|---|---|
| 7D8D | 00 40 70 | 70:4000, incoming A | 7D93 |
| 7D95 | 23 40 70 | 70:4023, A=0 | 7D9B |
| 7DA7 | 23 40 70 | 70:4023, A=1 | 7DAD |
| 7DB2 | 00 40 70 | 70:4000, A=1 | 7DB8 |
| 7DBA | 23 40 70 | 70:4023, A=0 | 7DC0 |
| 7DCC | 23 40 70 | 70:4023, A=1 | 7DD2 |
| 7DD7 | 00 40 70 | 70:4000, A=2 | 7DDD |
| 7DDF | 23 40 70 | 70:4023, A=0 | 7DE5 |
| 7DF1 | 23 40 70 | 70:4023, A=1 | 7DF7 |

## Registers, flags, banks and stack

Each ordinary far call is balanced: the adjusted return, saved region/bank and trampoline return are three two-byte stack items at callee entry relative to SP before CALL. Callee RET returns to `00:06FF`; wrapper cleanup restores the caller SP and continuation. The final JR does not create a return address. Eventual settings dispatch to `7D6F: RET` depends on the surrounding caller frame. Maximum full-call-tree stack depth is not derived.

The six settings table words at `7D60..7D6B` are `7D6F,7D70,7D79,7D82,7DFF,7E08`; none enters the candidate or its adjacent fragments. `00:0545` indexes `2*A` and jumps via HL without a bounds check. Malformed indices are not demonstrated natural entry.

Only one same-bank/ROM0 direct candidate exists: `7C:6A37 C2 90 7D`.

Coherent ROM mapping/shadow, initialized HRAM trampoline, valid stack and normal synchronous returns qualify the wrapper.

## Entry-A/1/2 init-step sequence operation alias

`InitStep70_EntryAThen1Then2_Jump7D82` is a PROBABLE operation alias for `Function_7C_7D8D`. It replaces only the prior neutral-name recommendation; entry, caller, application purpose and valid initial-kind domain remain HYPOTHESIS. The alias occupies blank300 between the separate prefix instruction and the neutral definition301, preserving all original instruction/data/locator rows and local-label scopes. It does not name a demo, a three-kinds-from-zero feature or a terminating function.

For each initialized phase, calls70:4023 withA0 continue until returnedA2, or FFA6.bit0 selects theA1 step loop, which continues until returnedA0.

There is no localPOP instruction in the39-start body. The POPs relevant to the nine calls belong to ROM0 FarCall and its cleanup; D1 in the CD D1 06 call encoding is an operand byte, not a POPDE instruction here. Each normal farcall consumes its inline return pointer, preserves an adjusted continuation and saved region/bank, calls the initializedFFA8 trampoline and restores the caller mapping before resuming. Those balanced frames and normal callee returns are prerequisites, not a proven arbitrary-entry stack contract. The body adds no separate return frame for the finalJR, and any eventual surrounding settings-loopRET requires the original caller frame to be valid. Full transitive stack depth is not derived.

The initialization stores its supplied kind inC27D and clears state/result fields; subsequent state dispatch uses a three-word kind table without a bound check. Passing incomingA does not prove it lies0..2. Init/Step callees can affect registers, memory, WRAM/VRAM selectors, inputs, timers and interrupt state; no broad preservation is inferred. Under the existing normal synchronous FarCall/coherent MBC5-high0/shadow/trampoline assumptions, cleanup overwrites callee flags; the source CP/OR/BIT tests determine local branches. At the finalJR shortcut, A2/F C0 comes fromCP2; theStep(1) completion hasA0/F80 fromOR0. These are internal transfer states before the usage-fee call, not an external return ABI.
