# Main title-choice dispatch tail at 1C:4016 — 2026-10-21

`1C:4016` is the three-byte instruction `JP $4007`, immediately after the
three-word `Table_Main_TitleChoices` at `1C:4010–4016`. The fixed-bank
`JumpTableInline` helper at `00:0545` pops the inline-table address and jumps
through the selected word; it does not return to the byte after the table.
The maintained navigation dispatchers use the same shape: an inline pointer
table followed by a `JP` back to its loop head.

The source now names this operation `Main_TitleChoices_JumpToLoop` and emits
`jp Main_TitleLoop` instead of the raw bytes. The operation and target are
**CONFIRMED by disassembly**; its relationship to the dispatch table is
**PROBABLE** by position and the repeated local pattern. No execution of this
three-byte span, invalid-index behavior, or default-handler role is claimed.
`Data_1C_401C` remains neutral: its single `$C9` byte decodes as `RET`, but no
caller or code-entry evidence establishes its role.

The change preserves the three bytes and all addresses. The original ROM hash
is `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; build
reported `SHA-256 OK` and `RESULT: IDENTICAL`; `sym-check` passed with 12,152
labels and 51 constants, and `palette-check` found zero errors. The bounded
`data_consumers.py --stats` pass still rejects all 93 immediate candidates
and creates no rename rows. The protected mail sample was not opened by the
incremental build.
