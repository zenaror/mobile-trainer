# Independent verification of the structural names of the sound data (audio6)

> Status: **reference (current)**.  One reader with a fresh context (Q6) re-derived the 316 rows **from the ROM alone** (an own decoder of the streams that reads only `Mobile Trainer (Japan).gbc`; the build symbol file only maps names to addresses), joined the natural traces, attacked the precedence rules and ran the tools in a private copy.
> It found no false name; it found the status reasoning of the first version wrong (too low) and a few texts to fix; both are integrated.  What the tree contains is the result after that: [`naming2_audio6.md`](naming2_audio6.md).

## 1. Verdicts

| item | verdict |
|---|---|
| names | **UPHELD 316, WRONG NAME 0**: every row agrees with the ROM-only decode (316 of 316); old and new name have the same bank:address; 316 distinct new names and addresses, no clash with an existing symbol |
| statuses | the first version wrote PROBABLE everywhere with the reason "no natural trace reaches the final jumps": **false**.  The final jump (all 3 bytes) of 82 of the 86 tracks was executed in natural scenarios (836 scenario / track pairs; the per-scenario coverage of `04:479B` agrees in all 836).  Now 213 CONFIRMED (82 `Loop`, 97 `Sub`, 34 `TrackPtrs`) and 103 PROBABLE (86 `AfterJump`, 4 `Loop` of song `$19`, `SoundSong19_Track3_Sub1`, 12 `TrackPtrs`) |
| the tool and the tree | `make` SHA-256 OK, `sym-check`, `audio_driver_check`, `tidy_comments`, `localize_labels`, `tree_check`, `audio_to_macros.py --check`, `test_apply_renames.py` and `invariants_check` pass; `apply_renames --dry-run` says 316 already applied; the generator run on `git archive HEAD audio` reproduces the manifest exactly |

## 2. What the reader showed

1. **ROM decode** (own decoder; command lengths from the driver's table at `04:46E8`): 70 song records, 59 headers (22 with the two extra pointer sets, 37 without), 152 tracks, 11,916 commands (4,871 waits, 4,325 notes, 152 `$B1`, 86 `$B2`, 276 `$B3`, 113 `$B4`, 2 `$CF`, 2,091 one-byte commands, no `$B5`) that tile `04:574D-7E8C` and `05:4000-68C3` exactly; every track range ends in a `$B1` and no flow leaves its range.
   Cross-checks: `tools/audio_to_macros.py` decodes the same 11,916 commands and 59 headers; `tools/audio_driver_check.py` runs the driver code on all 152 tracks (299,518 commands; the 93 commands never executed are exactly the commands behind the 86 final jumps).
2. **Loop** (86 of 86): the address is entry K of the second set; the `$B2` that ends at entry K of the third set has this operand; it is the only `$B2` of the track, reachable from the track start, below the jump; none of the 86 looping tracks has a reachable `$B1` (they loop forever) and all 66 other tracks reach one.
   **AfterJump** (86 of 86): the command that ends there is `$B2`; the address is the operand of no `$B2` / `$B3` / `$B5` of the ROM and no flow visits it; 83 are a bare `$B1`, three are `05:4535` (`BE 64, D3 27 11, 8C, D2 24 0B, 83, B1`), `05:4766` (`CF 42, B1`) and `05:52D7` (`8C, B1`); none of the 99 bytes behind the final jumps is read as data in any natural scenario although the jump bytes before them were.
   **Sub** (98 of 98): the address is the operand of at least one `$B3`; all call sites are in the same song and in the same track range (no cross-song or cross-track call); K and N are right by the ROM ranges (43 tracks, each numbered 1..n without a gap; two subs lie below their track's loop label, numbering is by address).
   **TrackPtrs** (46 of 46): the address is header + 2, the value `SoundDrv_LoadSongHeader` stores in `wSoundDrv_HeaderPtr`; the driver reads the first `tracks` words from there.
3. **Calls**: 113 distinct call targets = 98 `Sub` + 15 `Loop`; all 276 calls are backward, nesting depth is at most 1, each target owns a distinct `$B4`; 65 `sound_call ..._Loop` sites exist (20 and 21 calls of one label in song `$14`, tracks 2 and 3); there is no non-final `$B2`, so the generator's `_JumpN` case never applied.  All 113 call targets are **also executed in line** with an empty call stack (the `$B4` is a no-op there): 50 of the 98 `Sub` follow a non-terminating command.
   The definition in the first version ("entered by `sound_call`, left by `sound_ret`") is true but incomplete; the note says so now.
4. **The 8 neutral labels**: nothing references them (not by name, not by number, not as an operand, not in a header word); five sit at a `sound_call` site, three at an interior note or wait: no structural name would be true.  Side finding: their headers say "unread interior" although the first byte of each region was read in 7 to 14 natural scenarios; of the 41 regions headed "unread interior" in the audio files, 16 have bytes read in the natural union (1,183 of 1,250 bytes).  The headers come from the frozen pipeline and were not changed here (open item).
5. **Natural traces**: all 29 songs `$01-$1D` played (3 to 68 scenarios), 29 of 30 effects (not `$37`); tracks that reached their final jump: 82 of 86 (never song `$19`, all four tracks); `Sub` call sites read with the byte after them: 97 of 98; track pointers read: 45 of 46 tables; the loop and after-jump words of the 22 extra-set headers: 0 of 22 read.

## 3. Defects and what was done

| defect | done |
|---|---|
| the status reason in the note was false and 213 rows were under-rated | statuses raised in the manifest (`CONFIRMED` where the demonstrating code executed), the note rewritten (`naming2_audio6.md` section 2) |
| the evidence text of the 5 bank-05 songs without extra sets said "in 0 more word(s) per track, the loop target ..." (a template artifact), and the note said all 16 song tables hold loop and after-jump words (true for 11) | texts fixed |
| `docs/research/audio_format.md` section 10 still showed the neutral names in its example and said "the 333 that were missing are `Data_BB_AAAA`" | rewritten with the new names |
| 42 header `dw` lines are now over 160 columns (longest 195) | left: `STYLE.md` sets no column limit |
| the "unread interior" headers are stale for 16 of 41 regions | left (open item) |

## 4. Limits

The reader did not rerun the emulator traces (it used the committed `traces/` files: `analysis/coverage_union.tsv`, `traces/coverage_*.tsv` and `traces/detail/*/dataaccess.tsv`); "read by no code" for the header sets 1 and 2 rests on the driver source and the 69 natural scenarios, not on a search of other banks for a reader; no claim is made about what any song or effect sounds like.
