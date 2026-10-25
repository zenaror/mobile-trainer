# Bank 6C HelpScript stream map

The primary HelpScript byte stream occupies `6C:4809–58C6`, with exclusive end `6C:58C7`.

Evidence is the primary parser and continuation in
[`engine/help/help_script.asm`](../../engine/help/help_script.asm): dispatcher
at lines 178–314, page setup at 335–396, post-text continuation at 537–546,
and byte-text controls at 769–1035. The reader's implementation establishes
the command widths and branch mechanics below. It does not prove that every
branch is naturally taken, that every topic is reachable through ordinary
menus, or what glyphs were displayed at runtime.

A separate natural route through the first Help-menu item selects ID `$01`, displays 18 distinct tutorial pages, and returns to Help page 1. Two bounded runs reproduced all 20 captures (initial menu, 18 pages, return) byte-for-byte; the seed already had script var1 at `$A685` set, so no 0-to-1 change is claimed. See [`help_script_id01_natural_route_20261023.md`](help_script_id01_natural_route_20261023.md). This route adds an observed ordinary menu entry to the static map, but does not close its alternate branches or prove hardware rendering.

## Primary command grammar

After a `$03` page command, text is consumed by `HelpScript_StepText`. Its
control bytes include `$10` line advance, `$30` caption transition, and `$40`
delay followed by one argument. This layer has a separate parser and is not
counted as primary commands above. The located numeric glyph lookup and
`A0–FF` mapping are described in section 6 of
[`text_encoding.md`](text_encoding.md).

## Label and boundary map

All intervals below are half-open and end at the next annotated boundary.
Command-sequence labels identify a region beginning at a primary command; they
do not imply one indivisible record. The maintained assembly keeps byte
declarations and original addresses unchanged.

The `$06` and `$18` branch targets encountered in the walk land on command
boundaries. Entry labels are region boundaries, not an assertion that the
region's every byte is code: text, caption payloads, arguments and command
bytes are mixed. The five caption addresses are `4845`, `4BC9`, `51B1`, `543A`,
and `56FB`.

This map replaces the earlier interpretation of `$06 xx FF $03 aa bb` as a
message-record header. The bytes are decoded by the located primary command
reader as a `$06` branch followed later by a `$03` page command. In particular,
`6C:58BA–58C6` contains 13 bytes of final-topic commands; the lookup begins at
`58C7`. The `$533A` interval contains four, not five, branch/page pairs.
