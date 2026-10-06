# Independent verification of the mail-library names (ramop11)

> Status: **reference (current)**.  One reader with a fresh context (N1) checked the 121 rows of the first record against the ROM: every row, the offsets, invariant L5 for the library, the meaning of `$D023` and `$D624`, the names that were not used and the neutral uses that were left.  It worked in private copies (nothing was written in the repository), validated its corrected record on the tree
> of commit 3ef6d37 (ROM identical) and returned text and TSV files, all integrated.  What the tree contains is the result after its corrections: [`naming2_ramop11.md`](naming2_ramop11.md).

## 1. Verdicts (121 rows of `lib/mobile/mail.asm`)

| verdict | rows |
|---|---|
| UPHELD | 107: 91 `wMail_Work + $XX`, 13 `wMail_ComposeState` (composer 5, encoder 8), 3 `wMail_TextBuf2` |
| CORRECTED | 14: the Base64 **decoder** uses of `$D023` (`mail.asm` lines 4753 4780 4803 4864 4910 4920 4926 4949 4963 5032 5040 5044 5108 5211 of the tree before this pass) are `wMail_Work + $23`, not `wMail_ComposeState` (the DEF says composer or encoder) |
| DROPPED | 0 |
| text-only fixes in the proof column of upheld rows | 20 (the text "the fields have CAVEATs" is empty where no field covers the byte: `+$15 +$16 +$19 +$1A +$1B +$1C`; one row must say "unreached fragment"); cosmetic: 103 proofs cite the alias `Function_0F_xxxx` instead of the semantic label above it |

Same defect outside the record: `mail.asm` `Mail_Base64DecodeChar`'s invalid-character exit (`0F:5D40`, selectors 6 and 12) was already named `wMail_ComposeState` in the tree: one more row corrects it.

## 2. What the reader re-derived

1. **L5 for these sites** (`naming2_ramop11.md` section 2): holds at every reachable site; one site is unreachable (`0F:47B8`).  The entry, the twelve farcalls and their bank idiom, the selectors the application passes, the library's 4,262 instruction starts, 232 calls to 76 targets, no bank-register writes, 4,230 reachable instructions from 13 entries, 16 unreached in three
   fragments; `tools/invariants_check.py` ALL PASS on the base tree, the patched tree and the head; all 2,115 observed starts of bank 0F have mask `$20`.
2. **Offsets**: all 121 correct: 20 distinct offsets `$05-$1C`, 50 reads and 71 writes; at each mapped ROM address the operand value equals the old name and the new name; every name is W5 in `ram/banked.asm`; the rows are exactly the 121 neutral mentions in the code of `mail.asm` (none in comments); no `hl / de / bc`, `inc` or `bit` forms; synthetic tests of
   `apply_manual_sites`: a wrong value, an undefined neutral name and a row without `+ N` on a line that has `+ N` are all refused; two byte immediates remain (`ld a, $D6` at `0F:4DE5`, `ld a, $D0` at `0F:53EB`).
3. **`$D023` (27 first uses) and `$D624` (3)**: the census (39 accesses of `$D023`, all in bank 0F), the composer / encoder / decoder split and the three sites of `$D624` in `Mail_ExtractAddresses`.
4. **Names not used** and the **field names** that are true per site (`naming2_ramop11.md` section 4): the reader validated 14 optional rows and the `Mail_Base64DecodeChar` row on ROM-identical trees.
5. **What stays neutral**: `$D526` got a name, `$D01E` and (beyond the question) `$D03C` too, `$D525` stays (`naming2_ramop11.md` section 5); with the two DEF lines and the rows added, the neutral check reports 0 / 0 / 2 (only `wRam_D525`).
6. **The tool and the record**: `apply_manual_sites --dry-run` 121 to write, 0 skipped on the base tree and on the patched tree 0 to write, 121 already written; a real write on a copy gives a `mail.asm` byte-identical to the patched tree, `make compare` IDENTICAL, `sym-check` OK, a second run writes nothing.  Chaining a second record would make the first report
   14 rows as skipped, so the field-name rows were merged **in place** into one record.

## 3. Things the reader noted outside the rows (all handled)

`ram/banked.asm` quoted `ld [wRam_D00F], a`, `ld [wRam_D010], a` (`wMail_ComposeItem`), `wRam_D624` (`wMail_TextBuf2`) and `wRam_D525 / D526` (`wMailTextScratch`): the quotes follow the source now.  `STYLE.md` said `wMail_OutputStream` is hand-written "in selectors 4 and 8": the tree also uses it in 9 and 10 (fixed).  The head had moved while the reader worked
(romop1, trace round 4, the sound macro): `mail_viewer_sender.asm` shifted by -21 lines, so the `$D526` rows there are lines 1293, 1326 and 1333 of the head; the merged record uses the line numbers of the head.

## 4. Limits

No emulator or tracer was run; `observed_banks.tsv` and `coverage_union.tsv` were taken as given (the rows of banks 0F, 04 and 25 were re-read).  The interrupt side of L5 (`Int_Serial`, `Int_Timer`, the STAT handlers, `Sound_FrameService`) is the earlier readers' reading, not re-derived; the ROM-wide entry scans are byte-pattern supersets plus `invariants_check`; the callers of every
ROM0 bank-switch helper were not traced for a computed `$0F`; the selector range is guarded only by the 12 constant `ld a, N`.  Roles in selectors 3, 5, 7 and 9-12 (every `$D023` judgement there) are static readings; nothing in them ran.  `wMailReplyRecord` rests on static reading plus presence and bank in the replays; `wSoundDrv_ParamDirtyMask` is a static reading of a family that never executed.
Judgement call: the decoder rows are corrected because the name says "compose"; if a broader name is preferred, the DEF and all 39 `$D023` sites must change together.
