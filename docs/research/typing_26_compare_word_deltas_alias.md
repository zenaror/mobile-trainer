# Typing 26 compare word deltas alias

# Bank 26: proposed word-delta comparison alias

Let Wxx be the little-endian word at WRAM1[wMailSessionBlock+xx]. The 98 original bytes contain 72 instruction starts. With an ordinary valid nonaliasing stack and no relevant interrupt/bank interference, the arithmetic compares `(W05 - W03)` with `(W0B - W0D)`, modulo 65536. The `xor $FF`/`inc bc` pairs negate loaded words; they do not prove the stored fields use a one's-complement representation. Equality does not establish signed ordering or absence of wrap. Both paths explicitly select hWRAMBank/rSVBK 1 twice and leave 1 selected; they do not restore the incoming selector. Word reads and the two-byte copy are not atomic.

The equality arm 26:514D–5168 is a static PROBABLE contract: it copies W0B into W0D, returns HL=W05 and A=1, and restores BC/DE.

Available callgraphs show 39 calls from26:4737 and 39 normal returns at 26:514C in four scenarios.

## Representation and chronology

A future build must retain the original ROM bytes, add exactly the new symbol at 26:5106 and preserve every existing symbol/address and local scope.
