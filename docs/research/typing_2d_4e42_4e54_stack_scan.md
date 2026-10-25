# Static contracts and reference at 2D:4E42 and 2D:4E54

| Original span | Bytes | Instruction starts |
| --- | ---: | ---: |
| `[2D:4E42,4E54)` | 18 | 11 |
| `[2D:4E54,4E8C)` | 56 | 38 |
| Combined `[2D:4E42,4E8C)` | 74 | 49 |

## Operation aliases with the saved-BC transfer explicit

Only after a balanced helper return does the wrapper PUSH the helper's AF, XOR A, write0 toRAMG at0000, POP that AF, POP its own input BC and RET. Thus it preserves helper AF and input BC on that ordinary completion, not incoming AF. It explicitly selects WRAM1 throughFF8D/FF70 before the call and leaves that selection in place. RAMG0 is a hardware write without an update to FFF5 (`hSRAMEnable`), so an earlier enabled software shadow can remain stale. It does not restore previous WRAM selection, RAM-gate state or SRAM-bank state. The IfBalancedReturn clause does not promise that the abnormal path reaches or completes cleanup.

Positive existing context is `MailBody_GetRowPtr` at2D:4EC0 in the same maintained owner: it selects WRAM1, starts atD400 and scans two-byte cells with width12.

Direct4E54 entry uses whichever WRAM bank is mapped atD400; only4E42 selects WRAM1.

## Mail-body locator roles and distinct E results

The current function names are `MailBody_LocateCell` at2D:4E42 and `MailBody_LocateCellInMappedWram` at2D:4E54. Their domain roles are PROBABLE, supported by the actual mail-body format consumers: InsertChar5198..519B stores (writes at5199/519B) a two-byte cell, Backspace5413..5418 copies pairs, and GetRowPtr4EC0 scans D400 under WRAM1 with CR/twelve-cell rows. The helper uses the currently mapped WRAM; only the wrapper selects WRAM1. This domain evidence supports proper operation names without claiming a natural caller, a caller-enforced input domain, author intent or a repaired early return.

The sole same-bank CALL4E49 now names MailBody_LocateCellInMappedWram.

The locator returns E=actual two-byte positions traversed in the selected row, stopping at an encountered CR/NUL or exhaustion of input C. It preserves input BC on the ordinary POP/RET path. This differs from the actively used MailBody_GetCharPtr4E8C: GetRowPtr computes the complete row length capped at11 in E, and GetCharPtr preserves that result. In a coherent two-row body with three ordinary cells plus CRLF in row0 and an ordinary cell plus NUL in row1, the B0/C0 lookup returns E0 from the locator but E3 from GetCharPtr. The real CursorLeft consumer at48CE/48CF/48D2 decrements B, calls GetCharPtr with C0, then copies E to C to move to the preceding row's end. Substituting the locator would put C0 there. This is a static counterexample from original instructions, not a new runtime observation.

A sufficient conditional domain requires coherent body rows, an existing requested row, all traversed/selected bytes within WRAM1:D400..D4BF, a valid nonaliasing stack, coherent ROM2D and no interfering mapping/IRQ changes. The code does not enforce eight-row, twelve-cell or192-byte bounds. Nominal B0..7/C0..11 alone do not validate malformed row contents. Input FF means255 requested units; it is not zero. C0 selects the row start without a marker pretest. On ordinary completion HL is the selected cell, A is its first byte, E is traversed distance, BC is restored, and the final SUB supplies N1/C0/Z(distance0) with H from the low-nibble borrow. D has no uniform preservation contract.

Prior-row NUL in cells1..11 follows the original abnormal RET4E72: A/E/HL=FF/FF/FFFF immediately before PC becomes saved entry BC; SP returns only to helper-entry SP and the real return remains stacked. NUL in cell12 instead takes the width branch. Through the wrapper, the real return4E4C and its saved BC/outer return remain on the stack after that transfer. Only an ordinary helper return reaches wrapper RAMG0 cleanup; that path preserves helper AF/input BC, leaves WRAM1 selected, and does not update FFF5. The name does not make the exceptional transfer a normal missing-row return.
