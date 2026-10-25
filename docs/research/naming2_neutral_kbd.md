# Keyboard default-cursor flags and unobserved siblings

## Numerical operation alias for 55:6EEC

The eleven original table bytes at 55:6EF7 are `00 00 00 00 00 00 01 01 01 01 01`. For indices 0..10, the result is therefore exactly 0 for 0..5 and 1 for 6..10. There is no bounds check: index 11 reads $21, the next routine's opcode at 55:6F02; indices 11..255 continue into neighbouring ROM through $6FF6. The alias is not an unrestricted Boolean comparison over all byte inputs, a safe indexing API or evidence that every possible caller supplies a valid type.

A complete executed structural twin is `Function_55_6EAA`: its eleven code bytes are `21 B5 6E 85 6F 3E 00 8C 67 7E C9`.

Only the table-base operand differs.

Its distinct eleven-byte table at 55:6EB5 equals the candidate table byte for byte.

This is direct positive evidence for the parameterized lookup operation; it does not transfer the sibling's default-cursor role, observed table reads or natural entry to 6EEC.

The two tables remain separate physical objects.

The candidate's own static consumer at 55:5DF5 is `FA AB C2 CD EC 6E B7 CA 5A 5E C3 29 5F`: load `wKbdType`, call 6EEC, OR A, jump to 5E5A for zero or 5F29 otherwise. OR A is needed to test the returned byte because the lookup returns F=$00. Entry of that consumer remains HYPOTHESIS, and the preceding JP bypasses it in ordinary fall-through. If 5F29 is entered, it clears A before an unconditional call to `Kbd_SlideOut`; only ordinary callee return permits the later mode-zero store and return value nine. This conditional static chain is not a demonstrated live input policy or purpose for the lookup.

The current source replaces `Data_55_6EF7` with `Table_Kbd_Type6To10Flag_ByType`, **PROBABLE** as a structural label for the direct reader's 11-byte input-A table on indices 0..10.

## Operation alias for the hide sequence with return value nine

`Kbd_HideAndReturn9` is a PROBABLE operation alias for `Label_55_5F29`.

Its original twelve bytes are `AF CD 27 64 3E 00 EA AF C2 3E 09 C9`: XOR A, unconditional CALL 55:6427 (`Kbd_SlideOut`), load zero, store it at fixed WRAM $C2AF (`wKbdMode`), load nine and RET.

Its first nine bytes match the candidate exactly; its next byte is RET, whereas the candidate inserts `LD A,$09` before RET.

The complete entries differ in return A and length, and execution of the sibling does not establish execution of 5F29. - The path at 55:5E4B also starts with the same nine bytes, followed by `C3 26 5F` (JP 5F26).

Its destination 55:5F26 contains `3E 0A C9`, so this sibling returns ten instead of the candidate's explicit nine.

`Kbd_SlideOut` explicitly calls the sprite-slot clear helper for slots10..13 and a sprite-update farcall, reads keyboard type to choose waits, and may take type-dependent preparation/step farcalls, window-position writes, sound calls and LCDC updates.

It can return early when sampled WY is already at least $90, or wait/loop on other paths.

The caller at 55:5DF5 selects 5F29 only after a nonzero lookup result; once 5F29 itself is entered, CALL6427 is unconditional. The hypothetical interior entry 5F2A skips XOR A and is not included in a proved entry contract. The earlier functional-role KEEP decisions and qualifications are retained as history; these two new aliases describe only a numerical flag and a local hide-call/store/return sequence. They do not turn the static caller chain into a natural return-nine policy.
