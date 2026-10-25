# Japanese audio stream reader bank domain

## Finding

**CONFIRMED for the maintained sound-ID and song-table route:** the dynamic
ROM reader used by the audio driver selects only physical banks 04 and 05 for
all 70 accepted nonzero song IDs. It does not provide a maintained route to
Bank 53 or the candidate graphics spans.

`SoundDrv_PlayMusic` (`audio/engine.asm:4287`) and `SoundDrv_PlaySfx`
(`:41C0`) handle `BC=0` before `SoundDrv_LoadSongHeader`: music pauses and SFX
stops. The loader is called only at those two maintained sites. It rejects a
nonzero high ID byte and low IDs `>= $47`; for the two callers' nonzero route,
the selected table IDs are therefore 1–70. The table starts at
`04:551D` (`$5515 + 8*id`) and contains 70 eight-byte rows.

All 70 header pointers lie in `$4000-$7FFF`; all bank words are 04 or 05 (24 rows select bank 04, 46 select bank 05), representing 59 distinct header/bank pairs.

`SoundDrv_LoadSongHeader` copies that bank into `wBank4ReadBank`; `SoundDrv_InitTrackRuntime` carries it into each track record.

`Bank4_ReadStreamByte/Word` (`home/audio.asm:200-227`) select this recorded 9-bit bank before each stream read.

Existing stream-format evidence is in [`audio_format.md`](audio_format.md), sections 2–4.

## Limits

This closes the indexed, maintained song-table route only. It does not prove
that corrupted track records, direct entry to the ROM0 reader, arbitrary
external code or unmodeled execution cannot choose another bank. It is not a
global unused-bank conclusion. No source code or ROM bytes changed; no runtime
or hardware run was made.
