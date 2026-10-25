# Four Japanese candidate entry roots: byte-construction follow-up

The only generic ROM0 dispatch gateways are `JumpTableInline` (`00:0545`, same-bank 16-bit table) and `FarJumpTable` (`00:0551`, banked three-byte entries).

A byte scan of the immutable Japanese ROM found no `CALL $0551` or `JP $0551` instruction starts.

A whole-ROM search for exact banked target triples (`addr16 LE, bank` and `bank, addr16 LE`) found zero instances for `2B:6CF5`, `2D:4E42`, `2D:4E54`, and `29:511E`.

### Ordinary call-return continuation check

An additional original-ROM byte check tested whether an ordinary three-byte `CALL` in the same physical bank could return directly to each candidate after the preceding `RET`. The three bytes at `candidate-3` are `E0 55 C9` (2B:6CF5), `00 00 C9` (2D:4E42), `F1 C1 C9` (2D:4E54), and `20 FA C9` (29:511E); none begins with a conditional or unconditional `CALL` opcode. The byte at `candidate-1` is `$C9` in each case, so it is not a one-byte `RST` whose return PC would be the candidate. This excludes only those ordinary encoded call/RST return shapes. It does not exclude a stack word constructed at runtime, a bank mismatch, or other control-flow mechanisms; the existing direct CALL to `2D:4E54` remains classified as the known internal wrapper edge.
