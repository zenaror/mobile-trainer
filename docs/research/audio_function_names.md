# Audio driver: six existing function names and their contracts

| Address | Before | After |
|---|---|---|
| `04:4315` | `Function_04_430A.loop` | `SoundDrv_LoadSongHeader.loop` |
| `04:4319` | `Function_04_430A.l4319` | `SoundDrv_LoadSongHeader.l4319` |
| `04:431D` | `Function_04_430A.l431D` | `SoundDrv_LoadSongHeader.l431D` |
| `04:443B` | `Function_04_4433.loop` | `SoundDrv_PauseMusicCore.loop` |

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

`naming2_verify_g3_apps_a.md` independently upheld that operation with PROBABLE as its ceiling.

## 3. LoadSongHeader: record fields and exceptional return

The two direct callers are `SoundDrv_PlaySfx` and `SoundDrv_PlayMusic`. Both handle BC=0 before
calling the loader: stop all SFX or pause music. They otherwise use the generic eight-byte driver
record for either music or effects, so the existing `LoadSongHeader` name does not mean music only.

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

Evidence: `audio_format.md` section 3.1; `naming_g1.md` bank-04 table; the source callers/body; `home/audio.asm` `Bank4_GateLeave`; `audio2_verify_dynamic.md` V1.3 song-record experiment.

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

Evidence: source `4153-4177`, `4429-444B`; `naming_g1.md` bank-04 pause/resume rows; `audio2_verify_static.md` correction from TrackEnded to TrackNotRunning; `audio2_verify_dynamic.md` control-entry table and recorded `v13_ctrl.txt`.

## 5. UpdateFade: entry confidence and active-path confidence differ

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

No CALL or PUSH occurs in this prefix/gate/stop chain; shared tail jumps RET through the original
entry return word. On stop, the silence path writes the channel's APU registers. AF/BC/DE/HL have
path-dependent scratch effects; coherent ChannelPtr, owner track and ChannelReg are prerequisites,
not arbitrary independently chosen inputs. The source's 90-instruction annotation spans shared
channel code; it is not the size of this wrapper. The direct caller is inside the SFX sequencer tick
loop, which may run a different number of ticks per video frame; this does not assert one service
per VBlank.

## 8. Provenance and remaining work

Unresolved semantics remain visible: SelectAllTracks has no demonstrated entry; +$1E has no
established musical role, so `CmdStoreTrackByte1E` names only the operation; ParamStoreTrackWord27
likewise does not assert a natural caller; +$27/+28 tail behavior is synthetic/PROBABLE; and
CmdUnassigned is an interpretation of a JP-to-End table slot. These and the remaining original-ROM
questions are not closed by reducing a Function-alias count.
