# Audio driver: six existing function names and their contracts

## 1. Scope, confidence and namespace

This 2026-10-15 pass retires six inactive `Function_04_*` aliases from `audio/engine.asm`.
It preserves the existing `SoundDrv_*` names, bytes, instructions, operands, physical source rows
and local-label spellings. It adds no independent function entry and makes no runtime or hardware
claim. The other four audio helpers are covered by `audio_format.md` section 13; they are outside
this six-row change. Removing aliases is not proof that all original analysis is complete.

| Address | Historical alias retired | Existing name retained | Evidence and limits |
|---|---|---|---|
| `04:415A` | `Function_04_415A` | `SoundDrv_SelectAllTracks` | Operation name PROBABLE; entry/code classification HYPOTHESIS |
| `04:430A` | `Function_04_430A` | `SoundDrv_LoadSongHeader` | Normal record loading CONFIRMED; invalid-ID frame/gateway limits below |
| `04:4433` | `Function_04_4433` | `SoundDrv_PauseMusicCore` | CONFIRMED pause operation |
| `04:453A` | `Function_04_453A` | `SoundDrv_UpdateFade` | Entry/early exits CONFIRMED; active fade PROBABLE, demonstrated (synthetic) |
| `04:455A` | `Function_04_455A` | `SoundDrv_ApplyTrackUpdates` | Entry/output operation CONFIRMED; individual unused branches keep their limits |
| `04:4BC9` | `Function_04_4BC9` | `SoundDrv_ServiceChannelSfx` | CONFIRMED SFX gate wrapper and shared-tail operation |

The current code-reference census found zero active operands or qualified local references using
these six old names, across 348 maintained ASM/inc inputs. Thus no operand rewrite is required.
Four linked local names change namespace when the old global definitions disappear:

| Address | Before | After |
|---|---|---|
| `04:4315` | `Function_04_430A.loop` | `SoundDrv_LoadSongHeader.loop` |
| `04:4319` | `Function_04_430A.l4319` | `SoundDrv_LoadSongHeader.l4319` |
| `04:431D` | `Function_04_430A.l431D` | `SoundDrv_LoadSongHeader.l431D` |
| `04:443B` | `Function_04_4433.loop` | `SoundDrv_PauseMusicCore.loop` |

Their `.loop` / `.l4319` / `.l431D` declarations and relative branches are unchanged. Frozen mapper
and rename records keep their historical names. `tools/test_apply_renames.py` uses
`Function_04_430A` only as a neutral-name regex example, not as a required live definition.

All conditional static contracts below assume ROM bank 4, WRAM bank 1, coherent sound-driver
records/pointers and a readable, writable, non-overlapping stack. None of these entries selects
WRAM bank 1 itself. The gateway maintains bank-save/guard state; arbitrary direct entry, pending
interrupts, re-entrancy and aliasing writes are not covered by a universal preservation claim.
Let S be SP on entry to a directly called core, pointing at its return word. A normal RET reads
PC=word[S] and leaves SP=S+2. Shared tail jumps keep that frame unless stated otherwise.
The register notes identify visible effects, not a C ABI or a supported new public interface.

## 2. SelectAllTracks: operation PROBABLE, entry HYPOTHESIS

`04:415A-415F` is a five-byte prefix: `ld de,$D040; ld a,$08`, falling into the existing
`SoundDrv_SetTrackIterator` at `415F-4167`. The tail stores count A at WRAM1 `$D00F` and pointer DE
at `$D010/$D011`, then returns. If entered with the stated prerequisites, the result is:

- `wSoundDrv_TrackCount=8`, `wSoundDrv_TrackPtr=$D040`.
- DE=`$D040`, HL=`$D011`, A=`$40`; BC and F are unchanged by this prefix/shared tail.
- No PUSH or CALL occurs; the shared RET uses the entry return word, with no additional stack use.

This sets an iterator; it does not itself visit eight records. The semantic name has independent
static support: SFX starts at `$D040`, music at `$D130=$D040+4*$3C`, so eight records from `$D040`
cover both groups. `naming2_verify_g3_apps_a.md` independently upheld that operation with PROBABLE
as its ceiling. The existing source still marks the entry HYPOTHESIS. No new caller, table entry,
execution or negative reference search is claimed by this pass, and alias retirement does not
promote the entry/code classification.

## 3. LoadSongHeader: record fields and exceptional return

The two direct callers are `SoundDrv_PlaySfx` and `SoundDrv_PlayMusic`. Both handle BC=0 before
calling the loader: stop all SFX or pause music. They otherwise use the generic eight-byte driver
record for either music or effects, so the existing `LoadSongHeader` name does not mean music only.

The low-level guard at `430A-431D` checks B=0 and C<`$47`; it has no independent C!=0 check.
Thus ordinary API ids 1..`$46` must be distinguished from directly entering the loader with BC=0.
Before validation it writes B to `wSoundDrv_ReqBC+1`; rejection is not side-effect-free.

On the normal path, the record address is `$5515+8*BC` (the first ordinary record is at `$551D`).
The body stores the requested id and reads:

| Record offset | Field | Destination |
|---|---|---|
| +0/+1 | Stream-header pointer | `wSoundDrv_HeaderPtr=pointer+2`, skipping the header's initial word |
| +2/+3 | ROM-bank word | `wBank4ReadBank` |
| +4 | Priority | `wSoundDrv_HeaderPriority` |
| +5 | Flags | `wSoundDrv_HeaderFlags` |
| +6 | Track count | `wSoundDrv_HeaderTrackCount` |

Byte +7 is not loaded by this routine. The normal path RETs through word[S], with no local
PUSH/CALL. BC becomes `$5515`, DE the stream-header pointer+2 and HL the record+6; AF is working
state. No preserved-register or status-flags interface is implied.

When B!=0 or C>=$47, POP HL at4315 discards the loader's immediate return word
at[S], then JP Bank4_GateLeave enters the gateway with SP=S+2. Assume its ordinary outer
caller frame, coherent WRAM1 guard/saved-bank state, valid nonaliasing stack and no interfering
interrupt or mapping change. If D000.bit6 is clear, GateLeave restores the saved ROM bank,
clears busy bit7 and RETs through word[S+2], leaving SP=S+4. If bit6 is set, it instead PUSHes
the saved deferred-stub address from D003/D004, clears bit6, and RETs to that saved address
with SP=S+2; word[S+2] remains stacked. This deferred branch neither restores the saved ROM
bank nor clears busy bit7 at that point. Eventual outer completion depends on the deferred
gateway path; the no-pending PC/SP formula is not its immediate result. No standalone
error-return ABI or newly observed invalid-ID execution is established.

Evidence: `audio_format.md` section 3.1; `naming_g1.md` bank-04 table; the source callers/body;
`home/audio.asm` `Bank4_GateLeave`; `audio2_verify_dynamic.md` V1.3 song-record experiment.
The recorded synthetic experiment accepted ids `$01/$28/$46` and rejected `$47/$48/$FF/$0128`
through the public stubs; id 0 exercised stop/pause. Those observations do not constitute a direct
BC=0 loader test, a universal stack test, or new runtime evidence from this pass.

## 4. PauseMusicCore: four track flags, preserved stream positions

`04:4433-444B` sets `wSoundDrv_MusicPaused=$FF`, selects the four music tracks, clears only bit 7
of their flag bytes, and RETs. The records are `$D130`, `$D16C`, `$D1A8`, `$D1E4` (stride `$3C`).
Their stream pointers and other flags remain. `SoundDrv_ResumeMusic` can later reactivate eligible
records without restarting their streams; the recorded control experiment retained pointer
`$400C` and changed flags `$C0->$40` for its selected music track.

The direct caller at `4429` continues with `jp Bank4_GateLeave`; `SoundDrv_FadeFinished` at `442F`
can clear fade speed and fall into this core. The core and its iterator calls use at most two
additional stack bytes at a time, then RET through the entry frame. BC is unchanged in the visible
core/iterator chain; DE is overwritten by the music base and HL/A/F are working state. It does not
write APU registers or immediately silence every hardware channel: subsequent gate/channel
processing responds to the paused track flags.

Evidence: source `4153-4177`, `4429-444B`; `naming_g1.md` bank-04 pause/resume rows;
`audio2_verify_static.md` correction from TrackEnded to TrackNotRunning;
`audio2_verify_dynamic.md` control-entry table and recorded `v13_ctrl.txt`. The existing operation
name is upheld; no new caller or runtime result is added here.

## 5. UpdateFade: entry confidence and active-path confidence differ

`SoundDrv_FrameTick` calls `453A` before SFX/music processing. The entry's six instructions and its
observed early returns are CONFIRMED. The old natural scenarios did not organically start a fade.
The active path remains PROBABLE, demonstrated (synthetic) by the independent mGBA experiment;
`audio2_verify_dynamic.md` explicitly says forced/synthetic execution does not raise source status.

The local mechanism is:

1. Return if music is paused or `FadeSpeed=0`.
2. Decrement `FadeCounter`; return while nonzero. At zero, reload the counter from FadeSpeed.
3. Subtract four from FadeLevel. Without underflow, store the result and tail to parameter 2,
   passing the level in B and DE=`$00FF`. The mask builder selects all four music tracks and no
   SFX tracks; the parameter byte store affects only selected tracks whose active bit is set.
4. Parameter 2 marks volume dirty and writes track+$16 (volume scale). Its shared tail RET uses
   the UpdateFade entry frame. A level of zero is stored before a later subtraction underflows.
5. Underflow jumps to FadeFinished, clears FadeSpeed, then falls into PauseMusicCore and RETs.

The active path uses working AF/BC/DE/HL and shared request/dirty-mask scratch. It is not a
preserving wrapper. It adds no persistent return word of its own; helper CALLs have ordinary
balanced frames. The caller FrameTick saves BC/DE around its larger operation; that does not make
UpdateFade independently preserve them. Mapping, stack and no-interference assumptions still apply.

Evidence: source `452C-455A`, `44B7-452C`, `4947-4955`; `naming_g1.md` fade row and downgrade note;
`audio_format.md` section 5.1; `audio2_verify_dynamic.md` V1.3 parameter experiment. Its recorded
`v13_param.txt` fade initiated at frame 6 with speed 1 and wrote `$3C,$38,...,$00`, leaving music
active at level zero on frame 21 and paused on frame 22. This is an existing synthetic setup,
not a newly found natural fade caller or a hardware measurement.

## 6. ApplyTrackUpdates: derived fields, not direct APU output

At `455A-456C`, the entry loads `wSoundDrv_TrackPtr`, reads its flag byte and returns if flags<`$C0`.
Otherwise it copies the flag byte to `wSoundDrv_UpdateFlags` and jumps to the shared
`SoundDrv_ComputeTrackOutput` at `4668-46E8`. That body uses dirty bits to compute:

| Dirty bit | Derived track field |
|---|---|
| 2 | Pitch-offset word +$2C/+$2D from the existing offset components and enabled vibrato |
| 0 | Pan byte +$2E from +$17 and +$18 |
| 1 | Quantized volume +$2F from the two volume components |

It stores the update flag byte at the track base before RET. This entry does not advance the
command stream or write APU registers; those belong to other sequencer/channel phases. Its two
call sites are the pending-update loops for the SFX and music groups. The historical source
annotation of 120 instructions is a coverage-region count spanning later labels; the entry prefix
itself is 18 bytes / nine instructions. It must not be read as a self-contained 120-instruction body.

HL is restored to the track base by the shared body; AF/BC/DE are working registers with
path-dependent effects. The local stack has no save frame; the volume branch's MulNibbles CALL
uses an ordinary temporary return word. RET therefore uses the original caller frame. Exact output
flags and unselected-field preservation should not be generalized beyond the visible branches.
The source's PROBABLE pan branch and synthetic/unused parameter paths retain their confidence.

Evidence: source `455A-456C`, `4668-46E8`; `naming_g1.md` bank-04 output row;
`audio2_verify_static.md` parameter/pan/volume analysis; `audio2_verify_dynamic.md` V1.2 pitch/volume
and V1.3 parameter experiments. Existing synthetic results supplement the natural-path evidence;
alias retirement does not turn every parameter combination into a naturally observed case.

## 7. ServiceChannelSfx: ownership filter and common gate tail

The 18-byte / eleven-instruction prefix at `4BC9-4BDB` loads the current channel pointer and returns
unless the channel's active bit 7 and its owner marker at channel+2 bit 7 are both set. It then
jumps to `SoundDrv_ServiceChannelGate` at `4BEB`. The music sibling at `4BDB` accepts the opposite
owner marker and shares the same tail. This is an explicit SFX-ownership filter, not a name inferred
from the surrounding screen.

The common tail reads the owning track pointer at channel+4/+5. Owner flags<`$C0` take the
TrackNotRunning stop/silence path. That condition includes ended, paused and restarting tracks;
it must not be renamed TrackEnded. Otherwise channel+7=0 means a held note. A nonzero gate counter
is decremented; expiry reaches NoteGateExpired, which either marks the release transition or stops
an already pending-transition channel. The source bits and existing state-machine interpretation
remain the authority for these cases.

No CALL or PUSH occurs in this prefix/gate/stop chain; shared tail jumps RET through the original
entry return word. On stop, the silence path writes the channel's APU registers. AF/BC/DE/HL have
path-dependent scratch effects; coherent ChannelPtr, owner track and ChannelReg are prerequisites,
not arbitrary independently chosen inputs. The source's 90-instruction annotation spans shared
channel code; it is not the size of this wrapper. The direct caller is inside the SFX sequencer tick
loop, which may run a different number of ticks per video frame; this does not assert one service
per VBlank.

Evidence: source `40AC-40D0`, `4BC9-4C14`, `4FD4-4FEA`; `audio2_verify_static.md` gate and corrected
TrackNotRunning rows; `audio_format.md` note-gate description; `audio2_verify_dynamic.md` V1.2 gate
measurements. The existing timing experiment measured notes in its scenarios; no new sweep,
re-entrancy test or hardware execution was performed for these alias changes.

## 8. Provenance and remaining work

The six names already existed in the accepted original-ROM reconstruction. Input authority is the
source and its existing verification notes, not the existence of descriptive aliases alone. This
proposal was prepared on top of the separate four-helper audio proposal, whose `audio/engine.asm`
SHA-256 is `ff658ac01126b64503a72dff4b927c3a5b6dff6f11296f707f7f75f674ebd877`. That dependency must be integrated or reconciled before adopting this file.
The original root revision is `245961f64363a27e57c99b3fbad906bf8d400ca2`; the immutable original ROM
SHA-256 is `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.

The read-only inventory, its per-file pins, four-local namespace map and candidate/exclusion ledger
are in the supporting `mt-jp-audio-naming-inventory-20261015/DATA` material, with INVENTORY SHA-256
`4e294f4303f45e7f27806e0103b3be09db81148785f62c3c27e3cb9131b6f3f6`. The proposal DATA records BEFORE/after hashes, the exact six-line text patch and a
comment-stripped source comparison. No instruction, operand or local spelling changes are proposed.
Assembler, symbol and original-ROM checks remain required at integration; no new equivalence claim
follows from this text inspection. No test, build, emulation, hardware, English work or OMM write was
performed by this proposal.

Unresolved semantics remain visible: SelectAllTracks has no demonstrated entry; +$1E has no
established musical role, so `CmdStoreTrackByte1E` names only the operation; ParamStoreTrackWord27
likewise does not assert a natural caller; +$27/+28 tail behavior is synthetic/PROBABLE; and
CmdUnassigned is an interpretation of a JP-to-End table slot. These and the remaining original-ROM
questions are not closed by reducing a Function-alias count.
