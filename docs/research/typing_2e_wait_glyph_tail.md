# Typing 2e wait glyph tail

# Pesquisa limitada pós75: 2E:4EB2 / 2E:4F9A

## Derivação antes dos headers

| ponto | intervalo | bytes | fluxo |
|---|---|---|---|
| 2E:4EB2 | [4EB2,4EBD) | 11 | B=$3C; pushBC; call0464; popBC; decB; JRNZ4EB4; RET4EBC |
| 2E:4F9A | [4F9A,4FA9) | 15 | A=[C2EE]; cp0; RETZ; decA; [C2EE]=A; call4FA9; JR4F99 |

## Operation alias for the counted wait calls

With LCD disabled, 00:0464 skips EI/HALT/waiting, clears `wVBlankFlag` and returns immediately.

## One current glyph with an explicit jump to RET4F99

`BlitOneGlyphIfCellsLeft_JumpToRet4F99` is a PROBABLE local-operation alias for `Function_2E_4F9A`, preserving that neutral definition.

Physical offset0xB8F9A contains the candidate15 bytes/seven CPU starts in[2E:4F9A,4FA9): `FA EE C2 FE 00 C8 3D EA EE C2 CD A9 4F 18 F0`.

### Executed prefix and exact wrapper comparison

Its first ten bytes match exactly; its CALL goes to24:49EC, whose complete20-byte wrapper is identical to2E:4FA9.

A preliminary comparison incorrectly supposed that2D:4FFE was also an identical wrapper. Direct original-byte comparison refutes that supposition:2D:4FFE first saves BC/DE/HL, then explicitly sets B2/C0 and calls7F:42CA (`Canvas_BlitGlyphNoRemap`);2E:4FA9 leaves B/C as supplied and calls7F:42C3 (`Canvas_BlitGlyph`, with color remap). The positive exact-wrapper comparison used here is24:49EC. The related2D:4FDB prefix still has18F1 and loops, but neither its forced colors nor its no-remap consumer is inherited by the candidate.

### Conditional return and effects

On the zero path, A=0 and CP0 leaves Z1/N1/H0/C0; BC/DE/HL remain unchanged by the local instructions, with no local counter store or blitter call. This path does not explicitly select WRAM.

On the nonzero path, C2EE is decremented once before the CALL. The wrapper saves BC/DE/HL, sets HL=C0A0 and invokes7F:42C3, then restores those pairs and performs LD A,6; ADD A,E; LD E,A; RET. Under normal nonaliasing execution, the final E and A are(E_initial+6) modulo256, D receives no carry, BC/HL/D retain their saved values, and final flags are those of the8-bit ADD (Z for the sum, N0, H/C for that addition). The result is not a count or Boolean status. JR preserves those flags and reaches RET4F99.

The blitter can remap that glyph in place, writes C0D0/C0D1 masks, and selects WRAM2 or3 for canvas data without restoring the old WRAM bank.
