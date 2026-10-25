# Original bank 4C result table and complete string reads

The result storage occupies 37 bytes at `4C:4DD6–4DFB`, with both table aliases preserved and whole-unit **PROBABLE** status. `Browser_MapErrorToResult` admits A=`$10..$33`, then indexes by A minus `$10`: only positions 0 through 35 are reachable through that guard. The final physical byte at `4DFA` would require rejected A=`$34`. A=`$26` also bypasses the lookup when session kind is one; that special branch has no natural execution proof.

| Naturally read address | Other storage |
| --- | --- |
| `4DD6` | The other 34 bytes remain unread |
| `4DEA` | No confidence from synthetic lookup inputs |
| `4DF8` | `4DFA` remains outside the input guard |

The existing strings receive precise **CONFIRMED** headers from their own complete reads, including terminators:

The original operands point at those exact units. `CopyString` is in fixed ROM0 at `00:14BF`; its far-call bank argument zero makes `BankSwitch_H` return without changing the selected ROMX bank. The source remains bank4C. CopyString reads and copies through the NUL. Existing SJIS literal encoding uses the original ASCII bytes here and remains byte-identical. These 69 complete source bytes do not establish complete execution or output safety of the surrounding image wrapper.
