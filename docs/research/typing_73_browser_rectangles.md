# Original bank 73 browser rectangles

Only the four existing original rectangles receive CONFIRMED source headers. Their fixed consumers and complete natural reads support this bounded refinement; no representation or graphics bytes change.

| Original interval | Bytes | Geometry | Source role | WRAM7 destination | Natural whole / union |
| --- | ---: | --- | --- | --- | --- |
| 4367-438F | 40 | 4 rows x10 | top normal tile indices | D089 | 8 /8 |
| 43AD-43D5 | 40 | 4 rows x10 | top normal attributes | D489 | 8 /8 |
| 441B-4439 | 30 | 3 rows x10 | bottom selected tile indices | D129 | 8 /8 |
| 4461-447F | 30 | 3 rows x10 | bottom selected attributes | D529 | 8 /8 |

The original 27-byte setups at73:6220 and623B establish BC040A/030A, source bank 73, the map pointer, destination and C10E/C10F attribute pointer. Each has nine source instruction/macro starts, including a six-byte farcall at6235/6250 to00:16A2. Each caller has83 executions across eight original natural scenarios. Every byte in each interval is read in all eight.

The 24-byte loop00:0904 reads consecutive source bytes and advances destination rows by32 for these fixed dimensions.
