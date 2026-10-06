# Structural names for the sound data (audio6): 316 neutral labels of the song and effect streams (ROM unchanged)

> Status: **reference (current)**.  The song and effect streams (`audio/music/music_01..1d.asm`, `audio/sfx.asm`) still carried 316 neutral `Data_BB_AAAA` / `Table_BB_AAAA` labels: the loop point and the "address after the final jump" of every looping track, the patterns that `sound_call` enters, and the pointer
> tables behind the headers.  They are named by **structure** now: what the label is in the stream (a loop target, a call target, a table), in which song and track.  The names claim no music: which song or effect is which is still unknown (open question 7).  213 rows are CONFIRMED, 103 PROBABLE.
> Records: `analysis/naming2/audio6_renames.tsv` (applied by `tools/apply_renames.py`, the old neutral name stays below each renamed label as an alias); independent verification: [`naming2_verify_audio6.md`](naming2_verify_audio6.md).

## 1. Result

| name | count | what the label is | status |
|---|---|---|---|
| `SoundSongNN_TrackK_Loop` | 86 | the target of the final `sound_jump` of track K: entry K of the second pointer set of `SoundSongNN_Header` (22 headers, every track of them; the only `$B2` of the track); 15 of them are also `sound_call` targets (65 call sites, all above the label in the same track) and keep this name | CONFIRMED 82, PROBABLE 4 (song `$19`: no track of it reaches its final jump in a natural scenario) |
| `SoundSongNN_TrackK_AfterJump` | 86 | the first byte after that final jump: entry K of the third pointer set of the header; the jump never falls through, so no path reaches it (83 times a bare `sound_end`, 3 times a short coda that ends in `sound_end`: `05:4535`, `05:4766`, `05:52D7`) | PROBABLE (the claim is an absence: nothing reads or reaches it) |
| `SoundSongNN_TrackK_SubN` | 98 | a `sound_call` target; K is the track whose byte range (from its `Track` label to the next track label or the header) contains the label, N counts 1.. in address order inside that track; every one ends in a `sound_ret` and is **also played once in line** by the track before its calls (the `sound_ret` there pops nothing) | CONFIRMED 97, PROBABLE 1 (`SoundSong19_Track3_Sub1`) |
| `SoundSongNN_TrackPtrs` | 16 | the pointer words that follow `SoundSongNN_Header` in the songs of bank 05: the track stream pointers (read by the driver), and in 11 of the 16 songs also the loop and after-jump words (read by no code) | CONFIRMED 5 (songs `$13 $15 $18 $1B $1D`, which have no extra words), PROBABLE 11 |
| `SoundSfxNN_TrackPtrs` | 30 | the channel-pointer table that follows `SoundSfxNN_Header` (the track stream pointers, read by the driver) | CONFIRMED 29, PROBABLE 1 (`SoundSfx37`: effect `$37` is never loaded in a natural scenario) |
| left neutral | 8 | `Data_05_4024`, `Data_05_41D0` (song `$0E`), `Data_05_4E22`, `Data_05_4F6A`, `Data_05_4FD5`, `Data_05_5085` (song `$14`), `Data_05_5E23`, `Data_05_609A` (song `$1A`): a position inside a stream that nothing references (five sit at a `sound_call` site, three at a note or a wait) | - |
| code references renamed | 534 in 28 files (86 `sound_jump`, 276 `sound_call`, 172 header `dw`); 316 aliases added; ROM byte-identical (`make compare`: `RESULT: IDENTICAL`; `audio_driver_check.py`, `sym-check` and every audit pass) | - |

## 2. Why these names and why these statuses

* The stream decode is CONFIRMED (every byte of the stream ranges is explained, `docs/research/audio_format.md` sections 3 to 6): the operand of each `$B2` (`sound_jump`) and `$B3` (`sound_call`) is the address of the label, and the macros have the semantics that the driver code demonstrates
  (`SoundDrv_ReadNextCommand` `04:459B`, `audio_driver_check.py`).  That is the structural fact; the reader re-derived it for 316 of 316 rows from the ROM bytes alone (own decoder: 70 song records, 59 headers, 152 tracks, 11,916 commands, 86 `$B2`, 276 `$B3`, 113 `$B4`, no `$B5`).
* **CONFIRMED needs the demonstrating code executed in the natural traces**, and for 213 rows it was: `SoundDrv_CmdJump` (`04:479B`) took the final `$B2` of 82 of the 86 tracks in natural scenarios (836 scenario / track pairs; all 3 bytes of the jump read, and the driver's executed count is 22,766 in 65 scenarios): those labels are the operand of an executed jump;
  97 of the 98 call sites were read together with the byte after them (call and return observed); the driver read the track pointers of 45 of the 46 tables.  The first version of this note said that no natural trace reaches the final jumps; that was wrong, the reader's join of `traces/` showed it.
* PROBABLE stays for: the 86 `AfterJump` rows (their claim is that nothing reaches the address: "absence proves nothing"), the four tracks of song `$19` (it plays in four scenarios but only reads 36 to 94 bytes of each track, never the final jump), `SoundSong19_Track3_Sub1`, `SoundSfx37` and the 11 tables whose loop and after-jump words no code reads.
* Nothing here says what a pattern plays.  A `Sub` is a pattern that `sound_call` enters and `sound_ret` leaves, and which the track also plays in line once; a `Loop` is where a track jumps back to at its end.  A name such as `SoundSong14_Track3_Loop` appears at 21 `sound_call` sites (song `$14`, tracks 2 and 3): true (the label is the operand of the track's only `$B2`), but it reads oddly there.

## 3. How the rows were made

`gen_audio_names.py` (a scratch script; the rules above are its whole logic) reads only the source: for each song file the track labels, the header and its `dw` sets (the pointer words may sit after a `Table_` label in bank 05 songs), the `sound_call` / `sound_jump` operands and the labels with an address comment; it numbers the `Sub` labels
per track in address order and gives a label with several roles the first of Loop, AfterJump, Sub.  It checked on all 86 tracks that the last `sound_jump` targets exactly the label of the second set and that the label of the third set follows it with only comments in between.  The manifest is the record: the evidence column of each row says which jump, which header entry or which call sites,
and why the status is what it is.

## 4. Reproduce

```
python3 tools/apply_renames.py --manifest analysis/naming2/audio6_renames.tsv --dry-run   # 316 rows: all already applied
python3 tools/audio_driver_check.py
make && make sym-check
```
