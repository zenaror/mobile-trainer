# Independent reference of the mail-library names (ramop11)

One reader with a fresh context (N1) checked the 121 rows of the first record against the ROM: every row, the offsets, invariant L5 for the library, the meaning of `$D023` and `$D624`, the names that were not used and the neutral uses that were left.

## 1. Verdicts (121 rows of `lib/mobile/mail.asm`)

Same defect outside the record: `mail.asm` `Mail_Base64DecodeChar`'s invalid-character exit (`0F:5D40`, selectors 6 and 12) was already named `wMail_ComposeState` in the tree: one more row corrects it.

## 2. What the reader re-derived

The entry, the twelve farcalls and their bank idiom, the selectors the application passes, the library's 4,262 instruction starts, 232 calls to 76 targets, no bank-register writes, 4,230 reachable instructions from 13 entries, 16 unreached in three    fragments; `tools/invariants_check.py` ALL PASS on the base tree, the patched tree and the head; all 2,115 observed starts of bank 0F have mask `$20`. 2.

**Offsets**: all 121 correct: 20 distinct offsets `$05-$1C`, 50 reads and 71 writes; at each mapped ROM address the operand value equals the old name and the new name; every name is W5 in `ram/banked.asm`; the rows are exactly the 121 neutral mentions in the code of `mail.asm` (none in comments); no `hl / de / bc`, `inc` or `bit` forms; synthetic tests of    `apply_manual_sites`: a wrong value, an undefined neutral name and a row without `+ N` on a line that has `+ N` are all refused; two byte immediates remain (`ld a, $D6` at `0F:4DE5`, `ld a, $D0` at `0F:53EB`). 3.

**The tool and the record**: `apply_manual_sites --dry-run` 121 to write, 0 skipped on the base tree and on the patched tree 0 to write, 121 already written; a real write on a copy gives a `mail.asm` byte-identical to the patched tree, `make compare` IDENTICAL, `sym-check` OK, a second run writes nothing.

## 4. Limits

No emulator tracer was run; `observed_banks.tsv` and `coverage_union.tsv` were taken as given (the rows of banks 0F, 04 and 25 were re-read).

`wMailReplyRecord` rests on static reading plus presence and bank in the replays; `wSoundDrv_ParamDirtyMask` is a static reading of a family that never executed.
