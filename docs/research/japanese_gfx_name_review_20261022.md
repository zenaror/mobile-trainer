# Japanese GFX names and paths reference

## Generic-name findings

The former is now named `ByteMatch_PageListProto_ObjTableFirstRow_24_6520` because its 16 bytes exactly match the first prototype row in bank 7F; this does not establish bank-24 table use.

The expanded review also checked optional separators/bank markers and hex suffixes to distinguish type/address-only names from descriptive names that happen to end in an address. - `Font_GlyphRun_824F` is not an address label: `824F` is the SJIS code key, while the glyph bytes are stored at `48:4ADB`.

The `GlyphFont_Jis12x12_*` family encodes font format, bank and physical fragment. - The frame-design owners use 91 `FrameDesignCandidate_*` names with descriptive family/context.

## Corrected Profile transfer slice

The separate 624-byte resource previously called `CandidateTiles_26_7840` is included in a static Profile_InitScreen HDMA request beginning at `26:7820`.
