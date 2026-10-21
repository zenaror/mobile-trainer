# Audio track-pointer alias cleanup (2026-10-21)

The generic `Table_05_AAAA` symbols in `audio/sfx.asm` and
`audio/music/music_*.asm` were exact-address aliases of the existing
`SoundSfxNN_TrackPtrs` / `SoundSongNN_TrackPtrs` labels. A source-wide exact
token search found no operands or qualified references to these generic names;
all 44 occurrences were declarations: 29 in `audio/sfx.asm` and 15 in the song
files. The word tables, pointer targets, comments, stream classification, and
confidence levels are unchanged. Only the redundant generic symbols were
retired. This resolves that bounded naming debt; it does not identify unrelated
generic tables elsewhere in the disassembly.

The retained names describe the demonstrated role documented at each block:
the audio driver reads these word tables as track-stream pointers. Their exact
lengths and the status of the header/table interpretation remain as stated in
the adjacent source comments. Validation passed: `make` reports `RESULT:
IDENTICAL` with SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`,
`make sym-check` reports 334 source files and 13,458 labels, and
`make palette-check` reports 162 loads, 116 arrays, 2 documented over-reads,
and zero errors.
