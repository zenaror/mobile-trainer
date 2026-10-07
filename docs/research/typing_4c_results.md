# Original bank 4C result table and complete string reads

This pass changes four evidence headers in `engine/browser/page_results.asm`. The existing byte table and three encoded strings keep their representation, bytes and names. The source gains seven comment lines; no new data typing, alias or instruction is introduced.

The result storage occupies 37 bytes at `4C:4DD6–4DFB`, with both table aliases preserved and whole-unit **PROBABLE** status. `Browser_MapErrorToResult` admits A=`$10..$33`, then indexes by A minus `$10`: only positions 0 through 35 are reachable through that guard. The final physical byte at `4DFA` would require rejected A=`$34`. A=`$26` also bypasses the lookup when session kind is one; that special branch has no natural execution proof.

| Naturally read address | Scenarios | Other storage |
| --- | --- | --- |
| `4DD6` | 1 | The other 34 bytes remain unread |
| `4DEA` | 5 | No confidence from synthetic lookup inputs |
| `4DF8` | 5 | `4DFA` remains outside the input guard |

The existing strings receive precise **CONFIRMED** headers from their own complete reads, including terminators:

| Unit | Bytes including NUL | Source load / CopyString call | Natural evidence |
| --- | --- | --- | --- |
| `4F11–4F25` | 20 | `4E63 / 4E66` | 1 hit, 1 `browser_pages` scenario |
| `4F25–4F45` | 32 | `4E75 / 4E78` | 1 hit, 1 `browser_pages` scenario |
| `4F45–4F56` | 17 | `4E89 / 4E8C` | 1 hit, 1 `browser_pages` scenario |

The original operands point at those exact units. `CopyString` is in fixed ROM0 at `00:14BF`; its far-call bank argument zero makes `BankSwitch_H` return without changing the selected ROMX bank. The source remains bank4C. CopyString reads and copies through the NUL. Existing SJIS literal encoding uses the original ASCII bytes here and remains byte-identical. These 69 complete source bytes do not establish complete execution or output safety of the surrounding image wrapper.

The wrapper has two located literal callers: `4C:4537` has 84 natural hits in 16 scenarios, and the dictionary view at `4C:5178` has 200 in 8. Their sum matches 284 observed wrapper entries. This comparison does not establish universal runtime caller closure. The first independent summary incorrectly described one as the sole caller, although its complete caller census already contained both. A separate sealed errata corrects the summary without rewriting the original derivation.

The metadata census covers 289 maintained TSVs and nine matching rows. There is no active physical source-line locator into this owner requiring an update. Five completed historical prose lines use basename coordinates; they are a separate predicate from full-owner-path matches and are preserved. All eleven unit identifier references, broader reference context and consumer-bank chains were reviewed.

Remaining bank4C partial tables are retained: the already typed scheme table has 2 of 6 bytes naturally read, the fetch-result dispatch table 4 of 14, page-cache storage 6 of 12, and this error table 3 of 37. Other previously represented inline tables retain their existing evidence. This pass does not close those partial semantics or promote unread units. Frozen configuration, assets and shared macros are unchanged. No new natural execution, PPU or hardware evidence is asserted.
