# Orphan browser-start graphics artifacts

Three tracked files previously under `gfx/browser/start_choice/` had no current owner include or catalog entry. They are retained under `gfx/unresolved/` with names that state their limited provenance; no bytes were deleted or edited.

- `browser_start_mixed_data_73_4530.bin` is 176 bytes and byte-identical to ROM bank 73 at $4530.

Current Japanese source instead identifies `SpriteFrameTable_73_5E60` and the following object frames/scripts, with natural reads through the chain.

## Data-read report recheck at Japanese HEAD `3d971282`

Nineteen reports contain a data-read interval overlapping the browser-start frame/attribute region; the union covers all 350 bytes at `73:447F..45DD`.
