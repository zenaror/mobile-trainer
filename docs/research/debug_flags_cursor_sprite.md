# Debug Flags cursor sprite names

The single object in `Table_DebugFlags_Objects` is loaded by the debug-flags
screen initializer through `Sprite_InitSlot`, then positioned in sprite slot 1
with `Sprite_SetPosition`. `DebugFlags_PlaceCursor` writes the slot's vertical
position from `wDebugFlags_Cursor` for modes 1 and 2. The table's object record
points to `DebugFlags_ObjAnimData` and `DebugFlags_CursorScript`.

At `19:4821`, `DebugFlags_ObjAnimData` contains the frame-table pointer to
`DebugFlags_CursorFrame0` at `19:4823`, followed by one OAM record
`(0, 0, tile 0, attr 1)`. `DebugFlags_CursorScript` at `19:4828` contains one
step selecting frame 0 for four ticks. The frame, script, and table boundaries
are CONFIRMED by the source layout and macros. Their association with the debug
cursor is PROBABLE from the initializer, table, and cursor update code.

The former neutral labels `Table_19_481D`, `Data_19_4821`,
`SpriteFrame_19_4823`, and `SpriteScript_19_4828` were retired after checking
maintained-source references. Their addresses and replacement names are
recorded in `analysis/naming2/debug_sprite_renames.tsv`; frozen analysis/config
snapshots retain historical spellings. The debug-flags routine is documented
as forced execution only in the current traces. This naming pass adds no claim
that the screen or cursor runs naturally.
