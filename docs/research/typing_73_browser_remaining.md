# Original browser remaining rectangles and ticker bank field

## Consumer-derived rectangles — CONFIRMED

| ROM73 range | Meaning | Geometry | WRAM7 destination | Caller |
|---|---|---|---|---|
| 438F..43AD | tile indices | 3x10 | D129 | 61F0 |
| 43D5..43F3 | BG attributes | 3x10 | D529 | 61F0 |
| 43F3..441B | tile indices | 4x10 | D089 | 620B |
| 4439..4461 | BG attributes | 4x10 | D489 | 620B |

ROM bank 73 is selected by 00:16A2; WRAM bank 7 is selected separately.

The bounded uploader uses VRAM bank 0 for indices and bank 1 for attributes; LCDC bit 3 chooses 9800 or 9C00.

## Text bank byte — CONFIRMED

73:62C6 loads HL=4000 and A=73, then farcalls 48:42D4 at 73:62CB. Ticker_Start first copies A into D (the table source bank), calls ReadByteFar, stores the returned byte into C0EB, and copies it into scratch. The selected ROM branch of ReadByteFar reads at 00:1678 with HL increment, restoring the previous bank afterward. Thus the field at 73:4000 controls subsequent text reads; table source bank and text bank are separate fields even though both equal 73 here. Existing BrowserStart_Strings at 73:4009 permits db BANK(BrowserStart_Strings), emitting the same single byte without a new symbol.

The whole Ticker_Start body 42D4..440A was read: all 153 maintained units have natural execution.

## Auditable remainder — KEEP

49E0..4DE0 remains a 1024-byte PROBABLE tile heuristic without an established consumer or natural reads. Animation tail 45DD..45E0 remains three raw bytes with HYPOTHESIS purpose. Tail 62EF..8000 contains 7441 literal zero bytes, but its purpose is HYPOTHESIS. Neither absence of reads nor zero content proves unused data or padding. The cleanly decoded 6143..614F twelve-byte fragment has no established entry and remains HYPOTHESIS. Optional paths near 60A6/60EA/62D7/62DA/62E2 retain PROBABLE status without matching natural execution. Dynamic selector paths are not generalized.

## Maintained representation and limits

Existing BANK(BrowserStart_Strings) emits73 because the immutable symbol is73:4009.
