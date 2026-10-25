# Bank 29 candidate library: header evidence limits

## Raw facts and the former absence claim

Scanning overlapping little-endian pairs outside the span finds 4,001 raw matches to those start addresses.

Preceding CALL/JP opcode bytes produce 189 raw opcode-plus-target patterns, none in physical bank 29.

These counts contradict the former literal claim that no outside word/CALL/JP match exists.

They do not classify the bytes as instructions, pointers or callers, and do not establish the selected ROMX bank.

No non-overlapping outside match was found for any of the 719 consecutive 24-byte windows.

This is a bounded raw-window result, not proof of unique semantics or exhaustive absence of another implementation.

## Fetch, memory and loop contracts

Physical `29:7BB7–8000` contains zero bytes. That observation applies to the literal physical bank, while the bank-selection writes at `29:510F` (`$2000/$3000`) can change later ROMX fetches. Entry, selected bank, copying and relocation are unestablished. The padding does not prove that every leaf is unable to execute in place, and a conditional decode does not establish a valid execution path through a bank switch.

The PRNG-like sequence at `29:50DA` reads `$0C0E/$0C0F` in ROM0 (reference bytes `CD 18`) and writes those cartridge-address locations. They are ROM/mapper space, not WRAM seed storage. Arithmetic resemblance does not establish a live PRNG or an intended mapper operation.

`29:520D` explicitly writes real SVBK=1 (`3E 01 E0 70`) before its banked buffer use. Standalone entries at `29:523F`, `529F`, `52ED` and `5335` have no local bank selection. Their `$DBD0` buffer interpretation requires an incoming bank contract that the existing evidence does not supply.

At `29:526D`, the BG loop loads B=$40 and writes zeros. The OBJ loop starts B=$00, reads `[DE]`, and uses DEC/JR NZ; under the intact conditional instruction interpretation, the counter wraps through 256 iterations. This is not a symmetric 64-byte zero clear. The incoming DE, selected WRAM bank and intended behavior remain unknown.

The owner was rebuilt and passed the current byte-identity and symbol gates; see [the closure follow-up](original_closure_followup_20261021.md).

## MBC5 RAM-enable commands at `29:50DA`

The immutable ROM has cartridge type `$1B` (MBC5+RAM+BATTERY). ROM0 bytes at
`$0C0E/$0C0F` are `CD 18`, so the routine reads `$18CD`; its arithmetic
`5*$18CD+$3711` produces `$B312`. It writes `$12` to `$0C0E`, then
`$B3+LY` to `$0C0F`. Both addresses lie in the MBC5 RAM-enable register
region `$0000-$1FFF`; the documented MBC5 decode enables RAM when the written
value's low nibble is `$A`, and disables it otherwise. Thus the first command
disables RAM, and the second command enables it only when `LY & $0F == 7`.
This is a static register-command result from ROM bytes and the declared MBC5
map, not evidence that the operation is called naturally, what LY was at any
runtime call, physical-cartridge behavior, or application purpose. The name
`PalLibCandidate_DisableMbc5RamThenWriteLyDerivedGateValue` records only the
bounded operation; the candidate prefix and entry/purpose uncertainty remain.
