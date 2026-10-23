# Bank 6C HelpScript stream map (2026-10-20)

## Scope and result

The primary HelpScript byte stream occupies `6C:4809–58C6`, with exclusive end
`6C:58C7`. The independent 192-byte numeric glyph lookup begins at `6C:58C7`.
An over-approximate static walk derived from the maintained readers covers all
4,286 stream bytes without gaps or overlapping classifications. It finds 203
primary commands: 90 opcode `$06`, 85 opcode `$03`, 11 opcode `$18`, 6 opcode
`$04`, 5 opcode `$08`, 5 opcode `$10`, and one terminal `$00`. The 85 `$03`
commands begin page/text sequences; five of those sequences enter a caption
parser. These counts describe the static graph, not naturally visited paths.

Evidence is the primary parser and continuation in
[`engine/help/help_script.asm`](../../engine/help/help_script.asm): dispatcher
at lines 178–314, page setup at 335–396, post-text continuation at 537–546,
and byte-text controls at 769–1035. The reader's implementation establishes
the command widths and branch mechanics below. It does not prove that every
branch is naturally taken, that every topic is reachable through ordinary
menus, or what glyphs were displayed at runtime.

## Bounded emulator scenario evidence

The tracked `help` macro (`traces/inputs/help.macro`, resolved frames in
`traces/inputs/help.txt`) starts from the saved state produced by
`tutorial_profile`, with the Mobile Adapter emulated and the fake network
selected. It uses ordinary button inputs through the title, top menu, help menu,
first-use tutorial, and several help entries; it contains no `force` or
`ramset` directives. A replay on 2026-10-20 against the original ROM reproduced
`traces/coverage_help.tsv` and `traces/detail/help/dataaccess.tsv` byte for byte.
The original ROM SHA-256 is
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
The replayed tracked inputs and outputs have SHA-256 values:
`help.macro` `0fabd869f55168defd3315ebd5d273493c19a3e8e45ec2fc7dd204b0ccd7ed88`,
`help.txt` `26a5435a370be4eaa1cd4aaa8647dffa74459e3d7abc26d6f8faf12877a23160`,
`coverage_help.tsv` `0014768a7ac05ea90af98553f2c7b37d3f1417603ae3563c059435d817e4b049`,
and `dataaccess.tsv`
`ebe9eff200807479b544674285aee3f4e62b16ba300c0ef35076f414a60eba73`.

The replayed screen captures are retained under the ignored
`.tmp/jp-help-runtime-review-20261020/shots/help/`: frames 2426 (help menu),
3937 (first-use tutorial page), 5443/6711 (second entry), 8687 (third entry),
10029/10663 (fourth entry), and 11931 (back at the title). The captures show
Japanese text and graphics on these visited screens. At frame 10663 the fourth
entry includes `??????` placeholders; this is recorded as rendered output, not
interpreted as a successful or complete text page.

A separate natural route through the first Help-menu item selects ID `$01`, displays 18 distinct tutorial pages, and returns to Help page 1. Two bounded runs reproduced all 20 captures (initial menu, 18 pages, return) byte-for-byte; the seed already had script var1 at `$A685` set, so no 0-to-1 change is claimed. See [`help_script_id01_natural_route_20261023.md`](help_script_id01_natural_route_20261023.md). This route adds an observed ordinary menu entry to the static map, but does not close its alternate branches or prove hardware rendering.

The recorded bank-6C reads include `4809–4813`, `483E–48D6`, `4BB9–4BBC`,
`4BC2–4C36`, `51A1–51A4`, `58C6–58C7`, and lookup accesses in `58C9–597D`.
The trace also records instruction execution at `59B2`, `5B47`, `5C36`, `5CC5`,
`5E25`, `607A`, `60AF`, and `60EB` in bank 6C. These are observations of
this one seeded emulator scenario; they do not prove every topic, branch,
variable value, screen, or menu route is naturally reachable, nor do they prove
behavior on physical hardware. The trace tables and captures are emulator
evidence, not ROM-source changes.

## Primary command grammar

| Opcode | Width / observed behavior | Evidence limit |
|---|---|---|
| `$00` | One-byte terminal for the current HelpScript stream. | The terminal byte at `6C:58C6` was read in the bounded `help` scenario; this does not establish all terminal paths. |
| `$03 a b` | Three-byte page command. Prepares the text page, consumes two arguments, then reads text beginning at the following byte. The located reader ignores `a`; nonzero `b` selects a picture. | This describes the located consumer, not the intended meaning of the ignored argument. |
| `$04 lo hi` | Three-byte unconditional relative jump; the little-endian displacement is added to the pointer after both operand bytes. | Static edge only. |
| `$06 lo hi` | Three-byte relative conditional branch. The little-endian displacement is added to the post-command pointer only when advance mode equals 2; otherwise execution falls through. | Not a record header. A byte pattern resembling `$FF` is part of the signed/relative displacement, not a marker by itself. |
| `$08 lo hi` | Three-byte alternate-pointer registration in the current HelpScript state. | Does not alone establish later natural selection. |
| `$10 v x` | Three-byte variable store in the current script state. | Does not establish the whole state lifecycle. |
| `$18 v x lo hi` | Five-byte variable comparison and conditional relative branch: compare one script variable to an immediate byte, then conditionally apply a little-endian displacement. | Branch condition and edge are established by the reader; natural state values are not. |
| `$19 a b lo hi` | Five-byte variable-to-variable comparison and conditional relative branch, with a little-endian displacement. | Static edge only. |

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

| Start | Current label | Structural role at start |
|---|---|---|
| `4809` | `HelpScript_TopicDispatchAndFirstPage` | Entry dispatch: ten `$18` compares, `$04`, topic setup `$08`, initial page `$03`, then text control `$30`. |
| `4845` | `HelpScript_PageCaption_4845` | Caption data, followed by the welcome text at `485A`. |
| `485A` | `String_HelpScript_MobileTrainerWelcome` | NUL-terminated welcome text with `$40` and `$10` controls. |
| `4899` | `HelpScript_CommandSequence_4899` | Three branch/page sequences. |
| `493B` | `Data_HelpScript_BranchPage_493B` | One `$06` branch and one `$03` page/text sequence. |
| `4964` | `HelpScript_CommandSequence_4964` | One branch/page sequence. |
| `499B` | `Data_HelpScript_TwoBranchPages_499B` | Two branch/page sequences. |
| `4A09` | `HelpScript_CommandSequence_4A09` | Three branch/page sequences. |
| `4A78` | `Data_HelpScript_BranchPage_4A78` | One branch/page sequence. |
| `4AA0` | `HelpScript_CommandSequence_4AA0` | Three branch/page sequences. |
| `4B2C` | `Data_HelpScript_BranchPage_4B2C` | One branch/page sequence. |
| `4B68` | `HelpScript_CommandSequence_4B68` | One branch/page sequence. |
| `4B92` | `Data_HelpScript_PageAndTopicTail_4B92` | Page/text, topic tail, and next caption setup. |
| `4BC9` | `HelpScript_PageCaption_4BC9` | Caption data followed by page/text sequences. |
| `4C5F` | `Data_HelpScript_BranchPage_4C5F` | One branch/page sequence. |
| `4C9D` | `HelpScript_CommandSequence_4C9D` | Two branch/page sequences. |
| `4CDE` | `Data_HelpScript_TwoBranchPages_4CDE` | Two branch/page sequences. |
| `4D2E` | `HelpScript_CommandSequence_4D2E` | Four branch/page sequences. |
| `4DDC` | `Data_HelpScript_BranchPage_4DDC` | One branch/page sequence. |
| `4E03` | `HelpScript_CommandSequence_4E03` | Five branch/page sequences. |
| `4F12` | `Data_HelpScript_BranchPage_4F12` | One branch/page sequence. |
| `4F4C` | `HelpScript_CommandSequence_4F4C` | Twelve branch/page sequences. |
| `516F` | `Data_HelpScript_AdvanceAndVarBranch_516F` | `$06` branch followed by `$18` variable branch. |
| `5177` | `HelpScript_Page_5177` | `$03` page/text sequence. |
| `519E` | `Data_HelpScript_TopicTailAndCaption_519E` | Topic tail, next topic setup, then caption transition. |
| `51B1` | `HelpScript_PageCaption_51B1` | Caption data and page/text sequences. |
| `5213` | `Data_HelpScript_ConditionalBranch_5213` | A single `$06` branch; page command begins at `5216`. |
| `5216` | `HelpScript_Page_5216` | `$03` page/text sequence. |
| `5236` | `HelpScript_CommandSequence_5236` | Two branch/page sequences. |
| `52B2` | `HelpScript_CommandSequence_52B2` | One branch/page sequence. |
| `52E3` | `HelpScript_CommandSequence_52E3` | Two branch/page sequences. |
| `533A` | `HelpScript_CommandSequence_533A` | Four branch/page sequences (not five records). |
| `53F7` | `HelpScript_CommandSequence_53F7` | One branch/page sequence. |
| `5427` | `Data_HelpScript_TopicTailAndCaption_5427` | Topic tail, next topic setup, and caption transition. |
| `543A` | `HelpScript_PageCaption_543A` | Caption data and page/text sequences. |
| `54D3` | `HelpScript_CommandSequence_54D3` | One branch/page sequence. |
| `5505` | `HelpScript_CommandSequence_5505` | Two branch/page sequences. |
| `556B` | `HelpScript_CommandSequence_556B` | One branch/page sequence. |
| `5594` | `HelpScript_CommandSequence_5594` | Seven branch/page sequences. |
| `56E8` | `Data_HelpScript_TopicTailAndCaption_56E8` | Topic tail, next topic setup, and caption transition. |
| `56FB` | `HelpScript_PageCaption_56FB` | Caption data and page/text sequences. |
| `58BA` | `Data_HelpScript_FinalTopicTail_58BA` | Five primary commands, ending at terminal `$00` at `58C6`. |
| `58C7` | `HelpScript_SingleByteToSjis` | Independent 192-byte numeric glyph lookup, outside the primary stream. |

The `$06` and `$18` branch targets encountered in the walk land on command
boundaries. Entry labels are region boundaries, not an assertion that the
region's every byte is code: text, caption payloads, arguments and command
bytes are mixed. The five caption addresses are `4845`, `4BC9`, `51B1`, `543A`,
and `56FB`.

## Corrections and retained limits

This map replaces the earlier interpretation of `$06 xx FF $03 aa bb` as a
message-record header. The bytes are decoded by the located primary command
reader as a `$06` branch followed later by a `$03` page command. In particular,
`6C:58BA–58C6` contains 13 bytes of final-topic commands; the lookup begins at
`58C7`. The `$533A` interval contains four, not five, branch/page pairs.

The map is a static over-approximation from the maintained parser, not a trace
of every runtime path. The bounded `help` scenario establishes execution and
rendered samples for only the recorded input/state; it does not establish all
menu reachability, all possible variable values, every rendered page, final
glyph appearance for every string, or hardware behavior. Captions remain
identified as parser inputs; text interpretation is PROBABLE where the existing
source convention says so. Frozen `config/` and
`analysis/mapper` artifacts retain historical boundaries and names and are not
rewritten by this source-level correction.
