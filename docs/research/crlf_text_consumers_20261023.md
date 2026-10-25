# CR/LF bytes in Japanese text sources

## Finding for `19:447C`

`String_DebugFlags_Help` at `19:447C` is rendered by `DebugFlags_LoadHelpText` (`engine/debug/debug_flags.asm:503-510`) through `TextTiles_RenderGrid` (`48:40A9`), not through `TextEngine_Run` (`00:0ED3`). In `TextTiles_RenderGrid`, `ReadByteFar` reads the CR and advances `HL`; the `$0D` branch at `48:40D3` reaches `48:4141`, where `inc hl` skips exactly one following byte without checking its value. Thus the source pair `$0D,$0A` makes this renderer start the next row after consuming both bytes. The `$0A` does not reach the glyph lookup and is not dispatched through the main text-control table.

The same renderer is the direct consumer for the CR/LF text records in `data/text/connect_dialog.asm` (`engine/comm/connect_dialog_screen.asm`, including the call at line 123) and `String_DebugErrorTest_Help` at `19:4C1F` (`engine/debug/error_screen_test.asm:269-275`). Their `$0A` bytes are likewise consumed by the post-CR `inc hl` in `TextTiles_RenderGrid`.

## Boundary between readers

The main `TextEngine_Run` control table at `00:0EF0` still maps `$0A` to `TextEngine_Cmd00_End` at `00:0F9D`. If that interpreter receives `$0A` as its next control byte, it takes the end handler; `$0A` is not a second newline in that table. This does not describe the strings above because their proven callers use `TextTiles_RenderGrid`.

The built-in HTML pages use the HTML parser instead: its ordinary text path has separate CR and LF handling (`engine/html/parser.asm:288-304`), and the parser's preformatted path consumes CRLF explicitly (`engine/html/tags.asm:1553-1564`). SMTP and other protocol strings in `lib/mobile/` are network data, not text-engine input. No conclusion here changes the bytes or claims that every `$0D,$0A` pair in every ROM region has the same consumer.
