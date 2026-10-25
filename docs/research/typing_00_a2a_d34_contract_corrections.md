# Bank 00: contracts of 00:0A2A and 00:0D34

## 00:0D34

The original 25 bytes decode to 15 starts. PUSH AF precedes the read at WRAM0[$C200+entry E]. E receives the read byte; RLA tests its bit 7, selecting D=$00/$FF, so ordinary DE is its signed 8-to-16 extension. Entry AF is popped back; BC/HL have no explicit modification. A read that aliases pushed stack bytes observes them, not necessarily the pre-entry byte. The ordinary contract requires a valid nonaliasing stack and no relevant interrupt interference.

The code writes hROMBankLo/[$2100] first $F0, then entry A. It does not save the previous low selector; the caller must supply its intended low value in A. There is no explicit hROMBankHi/high-register write, which does not establish a high-selector value or exclude implicit stack aliases. Fixed WRAM0 C2xx is the read source; this does not erase all ROM-selection effects. The former unconditional physical $F0-to-$70 wrap claim is unvalidated.

Six overlapping little-endian 34 0D words were independently measured in the whole ROM; standard raw immediate CALL/JP prefixes occur zero times. The 348 maintained source files contain only the symbolic definition. Purpose, entry contracts and computed callers remain unresolved.

## Operation alias from an exact structural twin

The raw comparison is CONFIRMED; execution of the sibling does not establish execution or a caller of `00:0A2A`.

`StoreDEAtHL_SelectWramBank7` is a PROBABLE operation alias, retaining `Function_00_0A2A` at its old physical definition line and all instruction locators.

## Operation alias from the complete static contract of 00:0D34

`LoadSignedC200E_WriteRomLowF0ThenEntryA` is a PROBABLE operation alias for `Function_00_0D34`. The previous neutral-name recommendation is revised by distinguishing a statically defined operation from an unproved caller or application purpose. The earlier assessment that no additional executed twin or natural caller had been established does not refute the complete local operation already derived from the bytes. This alias rests on that existing derivation; it is not a newly discovered twin, dynamic observation, physical-bank experiment or proof of entry. Entry and application purpose remain HYPOTHESIS. The neutral definition stays on its original physical line, the existing local `.skip` remains under that neutral label, and all instruction/locator positions are retained.

The original 25 bytes are `F5 16 C2 3E F0 E0 8A EA 00 21 1A 5F 16 00 17 30 01 15 F1 E0 8A EA 00 21 C9`, with fifteen instruction starts. In their actual order: PUSH AF saves the incoming A/flags; D becomes C2; A becomes F0; FF8A and2100 receive F0; the byte at WRAM0[$C200+entry E] is read into A and then E; D becomes00; RLA places the read byte's old bit7 into carry; JR NC skips DEC D for nonnegative bytes, while the other path makes D=FF. RLA's dependence on the incoming low carry bit does not affect this sign decision because carry after RLA is the original bit7. POP AF then restores incoming A/flags, FF8A and2100 receive that A, and RET follows. Under the ordinary contract DE is the read byte's signed8-to16 extension, and AF/BC/HL are preserved.

`WriteRomLowF0ThenEntryA` names the explicit FF8A software-shadow and2100 register writes. The second value is incoming A supplied by the entry state; the code never samples a previous low selector for restoration. It does not sample the high selector and emits no explicit high-selector write. Neither the name nor this contract chooses a physical bank, establishes the high selector asserts a physical F0-to70 wrap. The WRAM0 source address remains C2xx; that fact does not erase the mapper/shadow effects. No mathematical purpose beyond the local sign extension, natural caller or application role is assigned.
