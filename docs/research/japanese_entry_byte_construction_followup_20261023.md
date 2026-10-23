# Four Japanese candidate entry roots: byte-construction follow-up (2026-10-23)

This static follow-up expands the existing bounded review of `2B:6CF5`, `2D:4E42`, `2D:4E54`, and `29:511E`. Base checkout: `da32b5ae5ff28d1c375614915eeb4a10b16dc96d`. Original ROM SHA-256: `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570` (2 MiB). The earlier entry-return report remains the source for stack contracts, opcode boundaries, direct/raw-word inventory, and trace limits.

## Additional checks

The earlier 104,200-instruction index was checked byte-for-byte against the original ROM before use. This pass searched decoded immediate operands for each exact candidate and for adjacent `LD L,low` / `LD H,high` construction of its 16-bit address. It also searched both byte orders in the same finite ROM owner-range allowlist used by the prior report. This tests direct/split immediate construction and possible literal pairs; it does not model arbitrary arithmetic, RAM-built pointers, copied code, or every unclassified byte sequence.

| Candidate | Exact decoded immediate mention | Adjacent L/H construction | Little-endian raw pairs | High/low raw pairs | Result |
|---|---|---:|---:|---:|---|
| `2B:6CF5` | None | 0 | 0 | 0 | No new static route. |
| `2D:4E42` | `4C:4E39: JR Z,$4E42` only | 0 | 4 | 6 | The JR is a relative branch in bank `4C`, not an entry to bank `2D`. Raw pairs occur in font/graphic owners; no pointer producer is established. |
| `2D:4E54` | `2D:4E49: CALL $4E54` | 0 | 14 | 8 | The call is the known internal wrapper-to-helper edge. Other raw pairs occur in code/data from other banks; no natural root for the wrapper is established. |
| `29:511E` | `29:50CE: CALL $511E` | 0 | 3 | 2 | The call is the known internal library edge. Other raw pairs occur in font/graphic data; no natural root for the wrapper is established. |

The two internal CALLs remain conditional edges inside code whose outer root is unknown. The exact-address hits are interpreted with physical bank context; a 16-bit address or matching bytes alone do not identify a caller. Existing 69-scenario natural coverage has no starts/read overlaps for the candidate intervals, while forced runs remain forced-only as documented in the parent audit. Absence in those finite sources and traces does not prove unreachability.

## Disposition

All four natural-entry questions remain **UNKNOWN**. No function, table, caller, or runtime status is inferred from this pass. The operation names remain bounded descriptions of their local mechanics. Further progress needs a concrete natural producer of the stack/bank state or a trace that records the actual source caller and selected bank.

The machine-readable receipt is retained at `.tmp/jp-entry-byte-construction-20261023/RESULT.json` (SHA-256 `7bd621bfe65ff9a2e71e148c6b8e317553b88af636f411394d275ab878a50248`). It records the instruction-index, allowlist and parent-report hashes, the original ROM hash, all 104,200 byte checks, and every bounded raw-pair hit. No source or ROM bytes were modified.

## Indirect-dispatch review at Japanese main `40cb409b` (2026-10-23)

To test computed dispatch separately from the completed immediate/raw-word scans, a fresh source census searched all 349 tracked Japanese ASM/INC files (excluding language overlays and the protected mail sample) for `JP HL`. It found 32 sites. None belongs to physical banks `2B`, `2D`, or `29`, the banks containing the four candidate roots. The only generic ROM0 dispatch gateways are `JumpTableInline` (`00:0545`, same-bank 16-bit table) and `FarJumpTable` (`00:0551`, banked three-byte entries). A byte scan of the immutable Japanese ROM found no `CALL $0551` or `JP $0551` instruction starts. This does not exclude entering either gateway by a computed pointer or another unmodeled route.

A whole-ROM search for exact banked target triples (`addr16 LE, bank` and `bank, addr16 LE`) found zero instances for `2B:6CF5`, `2D:4E42`, `2D:4E54`, and `29:511E`. The ROM identity was rechecked before the scan: 2,097,152 bytes, SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. This narrows the known static indirect-dispatch possibilities but does not model runtime-computed HL values, return-stack pivots, or pointer fields assembled from separate sources. All four natural-entry classifications therefore remain **UNKNOWN**; no name, boundary, or reachability claim changes.

### Ordinary call-return continuation check

An additional original-ROM byte check tested whether an ordinary three-byte `CALL` in the same physical bank could return directly to each candidate after the preceding `RET`. The three bytes at `candidate-3` are `E0 55 C9` (2B:6CF5), `00 00 C9` (2D:4E42), `F1 C1 C9` (2D:4E54), and `20 FA C9` (29:511E); none begins with a conditional or unconditional `CALL` opcode. The byte at `candidate-1` is `$C9` in each case, so it is not a one-byte `RST` whose return PC would be the candidate. This excludes only those ordinary encoded call/RST return shapes. It does not exclude a stack word constructed at runtime, a bank mismatch, or other control-flow mechanisms; the existing direct CALL to `2D:4E54` remains classified as the known internal wrapper edge.
