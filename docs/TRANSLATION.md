# Editing text and language resources

Mobile Trainer uses both font-rendered strings and text embedded in graphics.
Changing one does not update the other.

## Text forms

| Form | Source | Editing constraint |
|---|---|---|
| Rendered strings | `data/text/` and text blocks in `engine/` | Preserve the renderer's encoding, controls and allocated byte extent |
| Built-in pages | `data/html/` | Keep record lengths and pointer targets consistent |
| Graphic labels and banners | `gfx/` tile sheets, maps and attributes | Preserve tile placement, palette selection and source extents |
| Glyphs | `data/fonts/` | Keep the font's cell dimensions and glyph order |

The main font renderer supports narrow ASCII and wide Shift-JIS glyphs. The
Bank48 8×16 renderer has a different glyph set: full-width Latin is available,
but its repertoire must not be inferred from the main font. The Bank6C help
script has its own byte convention. See [text encoding](research/text_encoding.md).

## Record and layout constraints

- Connect-dialog lines use 16 glyph cells.
- Bank72 dialog records commonly contain two 16-wide-character lines plus a
  record header; some records have a different line count.
- Bank5C communication-message strings use `$0D` line separators. Original
  lines are typically twelve wide characters; the setup and renderer determine
  the actual drawing window.
- HTML records carry explicit body lengths.
- A label drawn from tiles is limited by the map and loaded tile set, not by
  the capacity of a nearby string buffer.

These are separate formats. Preserve each source's documented padding,
terminator and control bytes; do not apply one global translation limit.

## Graphics

A language change can require sprites, tiles, box borders, tilemaps, attributes,
palettes and font glyphs. Edit their source PNGs and mappings together. See
[editing images](EDITING_IMAGES.md) and the [graphics catalogue](../gfx/README.md).
A composed screen preview shows a specified graphics context; it may not include
text or sprites generated at runtime.

## English resource sources

English overrides are maintained under `languages/en/`. Edit those inputs,
not the generated copy in `build/en/source`.

- [HTML records and index](../languages/en/data/html/index.asm) use symbolic
  body lengths and banked record targets. A record can continue across two
  pinned sections; preserve its byte length and continuation labels.
- [Dictionary entries](../languages/en/data/text/mobile_dictionary_entries_en.asm)
  use the Bank48 full-width font. Keep category counts, page indices and the
  sixteen-cell entry limit consistent with the dictionary reader.
- [Registration text](../languages/en/data/text/registration_english_tail.asm)
  keeps the original notice metadata and prompt tables, with symbolic targets
  for strings stored in additional sections.
- [Help text](../languages/en/data/text/help_script_english_relocated.asm)
  uses the shared interpreter and graphics. Its body buffer has sixteen
  columns and three rows. Count rows that receive glyphs: a trailing newline
  immediately before NUL moves the cursor without drawing another row.
- [Sample-mail text](../languages/en/data/text/sample_mail_english_tail.asm)
  preserves the existing record layout. Sample names occupy sixteen-byte
  fields; preserve the encoded-byte limit and adjacent fields.

The two English canvas demonstration sentences in the
[page-list prototype](../languages/en/engine/unreferenced/page_list_prototype.asm)
retain twenty-four full-width glyphs. Its original drawing loops advance an
eight-bit X coordinate without line wrapping, so those sentences exceed the
visible row width and wrap the coordinate. A natural entry to this prototype
has not been established.

Additional language sections declare their bank and address explicitly. Keep
all consumers pointed at the intended symbolic label, and preserve the original
storage outside the selected text and pointer ranges. A code point accepted by
an encoding is not sufficient: the selected renderer must have its glyph.

## Language builds

The default `make` builds the original Japanese ROM. The existing English
overlay uses explicit file selection and hash pins; see
[the language build interface](LANGUAGE_BUILDS.md).

The English overlay is incomplete. A successful build does not establish
complete translation, original-game behavior, correct rendering or hardware
compatibility. Pokémon-name/frame associations and other uncertain Japanese
resources retain their documented limits.
