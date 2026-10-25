# Independent reference of the structural names of the sound data (audio6)

## 2. What the reader showed

**ROM decode** (own decoder; command lengths from the driver's table at `04:46E8`): 70 song records, 59 headers (22 with the two extra pointer sets, 37 without), 152 tracks, 11,916 commands (4,871 waits, 4,325 notes, 152 `$B1`, 86 `$B2`, 276 `$B3`, 113 `$B4`, 2 `$CF`, 2,091 one-byte commands, no `$B5`) that tile `04:574D-7E8C` and `05:4000-68C3` exactly; every track range ends in a `$B1` and no flow leaves its range.

**Loop** (86 of 86): the address is entry K of the second set; the `$B2` that ends at entry K of the third set has this operand; it is the only `$B2` of the track, reachable from the track start, below the jump; none of the 86 looping tracks has a reachable `$B1` (they loop forever) and all 66 other tracks reach one.

**Sub** (98 of 98): the address is the operand of at least one `$B3`; all call sites are in the same song and in the same track range (no cross-song or cross-track call); K and N are right by the ROM ranges (43 tracks, each numbered 1..n without a gap; two subs lie below their track's loop label, numbering is by address).

**TrackPtrs** (46 of 46): the address is header + 2, the value `SoundDrv_LoadSongHeader` stores in `wSoundDrv_HeaderPtr`; the driver reads the first `tracks` words from there. 3.

**Calls**: 113 distinct call targets = 98 `Sub` + 15 `Loop`; all 276 calls are backward, nesting depth is at most 1, each target owns a distinct `$B4`; 65 `sound_call ..._Loop` sites exist (20 and 21 calls of one label in song `$14`, tracks 2 and 3); there is no non-final `$B2`, so the generator's `_JumpN` case never applied.

All 113 call targets are **also executed in line** with an empty call stack (the `$B4` is a no-op there): 50 of the 98 `Sub` follow a non-terminating command.

**The 8 neutral labels**: nothing references them (not by name, not by number, not as an operand, not in a header word); five sit at a `sound_call` site, three at an interior note or wait: no structural name would be true.

**Natural traces**: all 29 songs `$01-$1D` played (3 to 68 scenarios), 29 of 30 effects (not `$37`); tracks that reached their final jump: 82 of 86 (never song `$19`, all four tracks); `Sub` call sites read with the byte after them: 97 of 98; track pointers read: 45 of 46 tables; the loop and after-jump words of the 22 extra-set headers: 0 of 22 read.
