# Bank 73 ticker pointer pairs — bounded original table

The original table at 73:4001–4009 contains four little-endian pointers:4009,4016,4065 and4072. They form two physical title/body pairs, not four independent menu entries. The existing `dw` statements already represent that format. This pass changes only the bounded header from PROBABLE to CONFIRMED and replaces the following blank line with a scoped reader/coverage note. Both labels and every later source line retain their positions.

`BrowserStart_ShowDescription` supplies HL=4000 and A=73 at 73:62C6 to `Ticker_Start`48:42D4. `ReadByteFar`00:1620 reads the preceding immutable source-bank byte 73 and advances HL to 4001. The ticker adds four times B, then reads a title pointer and a body pointer from that pair. Its bank-aware reads restore the preceding ROM bank; the stored text bank is also 73. NUL-terminated text scans and rendering use those pointer values. The four pointer words and their original bytes remain unchanged.

All eight bytes are naturally read across the original 69-scenario corpus. Nineteen scenarios read at least one table byte; eight read every byte. The first pair has 19 per-byte scenario hits and the second pair eight. These counts distinguish union coverage from whole-table scenario intersections; they are not inferred from caller counts.

The upstream selector takes the cursor's lowest set bit. Optional state adjustments can yield indices 4,5 or6, while the physical table has only two pairs. Saved nonzero cursor bytes are accepted without a universal clamp. This pass confirms the bounded data format and its natural consumers, not arbitrary index safety or every unentered caller branch.

The separate 142-byte string header remains PROBABLE. The bank byte4000, all other 23 physical data headers, every sprite/map/attribute unit, the unread49E0 block and zero tail, all assets and metadata remain unchanged. The complete inventory and correction annexes remain separate sealed evidence. No forced or synthetic run contributes to the confidence change.
