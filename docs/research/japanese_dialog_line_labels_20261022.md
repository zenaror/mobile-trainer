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

| Old label | New label | Bank:address | Structural basis |
| --- | --- | --- | --- |
| `String_Dialog_CandidatePhoneDisconnectedText` | `String_Dialog_Msg0102_Line2` | `72:51B0` | Second NUL-terminated line after the `Msg0102` header/blank line |
| `String_Dialog_CandidateF9DMinuteText` | `String_Dialog_Msg010A_Line1Suffix_53C5` | `72:53C5` | Continuation of first line in `Msg010A`; `$F9,"D"` bytes remain uninterpreted |
| `String_Dialog_CandidateCallDurationExceededTail` | `String_Dialog_Msg010A_Line2` | `72:53D8` | Second line of the `Msg010A` record |
| `String_Dialog_CandidateBlankLineRecord_541D` | `String_Dialog_Msg010B_Line2` | `72:541D` | Blank second line of `Msg010B`; next header starts at `72:543E` |
| `String_Dialog_CandidatePhoneDisconnectingText` | `String_Dialog_Msg010D_Line2` | `72:54A7` | Second line of `Msg010D` |
| `String_Dialog_CandidatePhoneDisconnectedText_Duplicate` | `String_Dialog_Msg010E_Line2` | `72:54EC` | Second line of `Msg010E`; no duplicate-content claim |
| `String_Dialog_CandidatePhoneDisconnectingText_Duplicate` | `String_Dialog_Msg010F_Line2` | `72:5531` | Second line of `Msg010F`; no duplicate-content claim |
| `String_Dialog_CandidateBlankLineRecord_5576` | `String_Dialog_Msg0110_Line2` | `72:5576` | Blank second line of `Msg0110`; next header starts at `72:5597` |
| `String_Dialog_CandidateNoPreviousPageText` | `String_Dialog_Msg0112_Line2` | `72:5600` | Second line of `Msg0112` |

The labels identify record layout only. They do not promote natural-use
confidence or assign semantics to the `$F9,"D"` control bytes.
