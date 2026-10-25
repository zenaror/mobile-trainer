# Typing 29 number templates

| Mode | Template, end exclusive | Copy/format routine, end exclusive |
| --- | --- | --- |
| M0 | `29:49DA–49E5` | `29:48C3–49DA` |
| M1 | `29:4C96–4CA1` | `29:4B7F–4C96` |
| M2 | `29:4F6C–4F77` | `29:4E55–4F6C` |

## Copy, decimal formatting and later render

The first 21 bytes of each formatter have twelve instruction starts. They save HL and BC, write A=1 to `hWRAMBank`/`rSVBK` (`FF8D`/`FF70`), load HL with the bank-29 template and DE with `wMailTextScratch` (`D524`). The five-instruction loop loads `[HL++]`, stores through DE, increments DE, compares the stored byte with zero and branches back while nonzero. It copies the NUL itself.

After copying, the routine restores the input HL and BC, saves BC again and uses BC=`D525`, the low byte of the first SJIS cell. The full routine is 279 bytes and has 177 instruction starts; a `farcall` contributes one CALL instruction plus three inline data bytes. There are ten statically present `farcall Divide16` sites in each routine, all targeting `00:0D67`, for thirty sites across the three bodies. Divisor loads are `$2710`, `$03E8`, `$0064`, `$000A` (10000, 1000, 100, 10), repeated in the shorter leading-zero branches. Ten static call sites do not mean ten divisions on one execution.

The contract is a template copy to WRAM bank 1 at `D524`, followed by formatting there; later callers render that buffer.

| Mode | Local formatter CALL sites | Later `TextTiles_RenderLine` farcall sites |
|---|---|---|
| M0 | `29:47D7`, `482E`, `4897` | `29:47F4`, `484B`, `48B4` |
| M1 | `29:4AD1`, `4B10`, `4B53` | `29:4AEE`, `4B2D`, `4B70` |
| M2 | `29:4DA5`, `4DD8`, `4E29` | `29:4DC2`, `4DF5`, `4E46` |

Its eighteen instruction starts show the formatter call, `NumberOffset`, destination setup and A=1/HL=`D524` before the farcall to `48:403E TextTiles_RenderLine`.

That renderer stores the string bank in `FFBB` and calls `00:1620 ReadByteFar` for the character bytes.

With a `D524` pointer, ReadByteFar reads the selected WRAM bank given in A, increments HL and restores the previous bank.

`D524` is text scratch in these consumers; the overlapping compose-mode alias is retained and is not a global description of these bytes.

## Representation and preserved uncertainty

Charmap stacks are balanced and restored; no instruction lies within either new text block.

This is a static byte-representation proof, not a rebuilt-ROM comparison.

The unrelated library `29:5090–5376` and object regions `29:6290–64F4` retain their existing HYPOTHESIS/PROBABLE status.
