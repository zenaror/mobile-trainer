# Original bank22 remaining naturally read data

CONFIRMED only for two text blocks and three opaque session-block templates through their original bounded consumers. The published baseline13107655b2f37dcbe836d30ada4a76fd89d82265 already contains the address-book tile-header pass and a documentation-only future language-build note. That future target is not implemented here. The first original-data unit preserves all other classes and the separate object-palette catalogue follow-up.

| Original ROM22 data | Bytes | Consumer format | Natural whole / union |
|---|---:|---|---|
| 43E0..444D | 109 | 54 double-byte Shift-JIS glyph codes plus NUL | 3 / 3 |
| 4515..4582 | 109 | 54 double-byte Shift-JIS glyph codes plus NUL | 1 / 1 |
| 4C5B..4C62 | 7 | opaque bytewise session-block copy | 2 / 2 |
| 4DA6..4DAD | 7 | opaque bytewise session-block copy | 1 / 1 |
| 4EE9..4EF0 | 7 | opaque bytewise session-block copy | 1 / 1 |

Each text setup passes its original pointer and source bank22 to TextTiles_RenderLine at48:403E, with two WRAM2 tile buffers. The complete65-unit renderer saves the string bank and calls ReadByteFar twice per double-byte glyph, stopping at a NUL. ReadByteFar's complete ROM path selects bank22, reads and increments HL, then restores the prior bank48. The outer far-call machinery returns to original bank22. Source bank and callee bank are different state, despite both belonging to the same text operation.

Every109-byte source block was compared with its unchanged maintained Shift-JIS directive and immutable original ROM; all54 two-byte codes round-trip independently and the sole final NUL terminates the block. The complete369-byte font owner at48:4728..4899 was mapped, including its27 five-byte glyph-run records and FFFF terminator. All108 glyph-code selections across both strings resolve through the original lookup to bounded16-byte glyph data, copied as two eight-byte halves to the destination buffers. This proves the original data format and bounded consumer path, not a visual rendering result or language translation. Original text payload is not reproduced in these notes.

Each template's complete eleven-unit setup/loop selects WRAMbank1, HL=wMailSessionBlock D624, DE=the original template and B=7. The loop reads [DE], writes [HLI], increments DE and decrements B until zero. The three original seven-byte sequences are equal and fully read in their respective natural cohorts. They remain opaque bytes: no meaning is assigned to their protocol fields and no deletion safety or hardware behavior is inferred from the labels or copy loop.

Exactly five existing headers change PROBABLE to CONFIRMED with bounded consumer notes. Their existing text/data kinds, all raw directives, physical boundaries, names and source line counts remain unchanged. No macro or new alias/reference is introduced. The entire bank22 physical inventory becomes15 CONFIRMED,2 PROBABLE and1 HYPOTHESIS headers; this is a count of physical headers, not whole-bank semantic completion.

Scientific correction: the prior coordinator appendix described616 raw bytes. The correct measure is616 unexecuted raw SM83 instruction starts, from1773 total starts minus1157 naturally executed starts. This differs from588 unexecuted maintained instruction/macro source units, from1717 minus1129. The published old appendix and its seal remain preserved as negative evidence; this pass replaces the inaccurate phrase in the maintained verification note. Raw starts, source units and byte sizes are distinct quantities.

Palette_CommProgress_Obj22:5C90..5CD0 already has a CONFIRMED source header but retains PROBABLE catalogue/README status. Its separate proof is64 original bytes,32 RGB555 words and16 whole/16 union scenarios through the original palette-buffer consumer. The two status rows are unchanged in this first unit and require a later published-baseline rebase before correction. No asset, PNG, exporter, generated make or frozen configuration change occurs here.

KEEP preserves the unread37-byte blank-string candidate,11-byte decimal-template candidate, five literal-zero bytes,6448 literal-zero tail and unresolved/unexecuted paths. Absence of natural reads establishes no unused or padding purpose. Existing69 natural traces provide aggregate per-byte evidence; no new emulator scenario, forced trace or hardware run is claimed. The ordered original queue continues with the separate palette status unit and auditable bank22 limits before25 and26.

## Published object-palette catalogue follow-up

Commit99f2ca1465e2cfba5218a2511e37f938e52dbf05 completes the separately reviewed palette-status unit after the first five-header pass. Only the existing status fields in gfx/assets.tsv and gfx/README.md change from PROBABLE to CONFIRMED. Palette_CommProgress_Obj remains32 RGB555 words /64 original bytes at22:5C90..5CD0, with its existing CONFIRMED source header and16 whole/16 union original scenarios. The bank26 request at51DD..51EE passes BC64, DE D840, HL5C90 and A22 to Palette_LoadToBuffer through the far-call path; the bounded home CopyBytes target reads ROM22 and writes WRAM7:D840. This does not claim WRAM-bank restoration or a global promotion of the hFarBank hypothesis. Assets, PNGs, generated rules, frozen configuration, source line counts and namespace remain unchanged.

The maintained first-unit evidence and its historical next-step wording above are preserved. The completed follow-up closes this specific catalogue discrepancy; bank22 unread37/11, zero5/6448, unresolved paths and unexecuted588 source units /616 raw instruction starts retain KEEP. The next bounded original work is bank25, then26. These are original aggregate trace observations, with no new emulator, English-rendering or hardware result.
