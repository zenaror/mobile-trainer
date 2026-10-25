# Bank 72 dialog line labels — 2026-10-22

The nine remaining `String_Dialog_Candidate*` labels in
`data/text/dialog_messages.asm` now use structural message-index and line
positions. No text bytes, headers, offsets, table words or section layout
changed.

`Dialog_Open` indexes one of the four lists through `Dialog_ListTable`, reads
the selected record's header, then issues two sequential
`TextTiles_RenderLine` calls. Within `Dialog_List1_Browser`, table entries map
to message IDs by their ordered indices: for example `Msg0102` points at
`72:518C`, `Msg010A` at `72:53B4`, and `Msg0112` at `72:55DC`. These pointers
and the record headers/line boundaries establish the structural labels below.
This is static source evidence; it does not prove a particular message is
naturally selected or displayed.

The labels identify record layout only. They do not promote natural-use
confidence or assign semantics to the `$F9,"D"` control bytes.
