# Original bank22 remaining naturally read data

| Original ROM22 data | Bytes | Consumer format | Natural whole / union |
|---|---:|---|---|
| 43E0..444D | 109 | 54 double-byte Shift-JIS glyph codes plus NUL | 3 / 3 |
| 4515..4582 | 109 | 54 double-byte Shift-JIS glyph codes plus NUL | 1 / 1 |
| 4C5B..4C62 | 7 | opaque bytewise session-block copy | 2 / 2 |
| 4DA6..4DAD | 7 | opaque bytewise session-block copy | 1 / 1 |
| 4EE9..4EF0 | 7 | opaque bytewise session-block copy | 1 / 1 |

Each text setup passes its original pointer and source bank22 to TextTiles_RenderLine at48:403E, with two WRAM2 tile buffers. The complete65-unit renderer saves the string bank and calls ReadByteFar twice per double-byte glyph, stopping at a NUL. ReadByteFar's complete ROM path selects bank22, reads and increments HL, then restores the prior bank48. The outer far-call machinery returns to original bank22. Source bank and callee bank are different state, despite both belonging to the same text operation.

The complete369-byte font owner at48:4728..4899 was mapped, including its27 five-byte glyph-run records and FFFF terminator.

Each template's complete eleven-unit setup/loop selects WRAMbank1, HL=wMailSessionBlock D624, DE=the original template and B=7. The loop reads [DE], writes [HLI], increments DE and decrements B until zero. The three original seven-byte sequences are equal and fully read in their respective natural cohorts. They remain opaque bytes: no meaning is assigned to their protocol fields and no deletion safety or hardware behavior is inferred from the labels or copy loop.

Exactly five existing headers change PROBABLE to CONFIRMED with bounded consumer notes. Their existing text/data kinds, all raw directives, physical boundaries, names and source line counts remain unchanged. No macro or new alias/reference is introduced. The entire bank22 physical inventory becomes15 CONFIRMED,2 PROBABLE and1 HYPOTHESIS headers; this is a count of physical headers, not whole-bank semantic completion.

Palette_CommProgress_Obj22:5C90..5CD0 already has a CONFIRMED source header but retains PROBABLE catalogue/README status.

Palette_CommProgress_Obj remains32 RGB555 words /64 original bytes at22:5C90..5CD0, with its existing CONFIRMED source header and16 whole/16 union original scenarios.

The bank26 request at51DD..51EE passes BC64, DE D840, HL5C90 and A22 to Palette_LoadToBuffer through the far-call path; the bounded home CopyBytes target reads ROM22 and writes WRAM7:D840.

This does not claim WRAM-bank restoration or a global promotion of the hFarBank hypothesis.
