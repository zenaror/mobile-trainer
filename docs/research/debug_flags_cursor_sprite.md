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
