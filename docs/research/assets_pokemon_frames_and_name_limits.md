# Frame resources and Pokémon names

## Browser frame selection

`Browser_LoadFrameGraphics` indexes a 27-word table at `4E:654B`. There are five
descriptors but three distinct graphic sets in Bank47:

| Style indices | Descriptor | Background tiles | Map/attributes | Background palette |
|---|---|---|---|---|
| 0 | `4E:6581` | `47:4100` | `47:4B00` | `47:4DD0` |
| 1 | `4E:65A0` | `47:4E50` | `47:5850` | `47:5B20` |
| 2–22 | `4E:65BF` or `4E:65DE` | `47:5BA0` | `47:65A0` | `47:6870` |
| 23–26 | `4E:65FD` | `47:4E50` | `47:5850` | `47:5B20` |

Descriptors also contain object tiles/palettes and timing/icon parameters.
Background tiles go to VRAM1 `$9000/$9400`, object tiles to VRAM0 `$8000`, and
20×18 maps/attributes pass through WRAM7 `$D000/$D400`. Masking the style with
`$7F` does not by itself check the 27-entry table bound.

Source: [frame loader](../../engine/browser/frame_graphics.asm) and
[style chooser](../../engine/browser/frame_style_chooser.asm).

## Candidate frame families and names

`53:4000–4170` contains 25 little-endian pointers followed by NUL-terminated
Pokémon names. The table contains no separate graphic bank/address fields.

The candidate art windows are distinct from the normal graphic sets above.
Name indices 01–23 have a PROBABLE visual/index correspondence; index24 has a
separate PROBABLE Porygon2 association with Bank51 art. Index00, Porygon, has no
demonstrated visual match. No executable producer linking a Bank53 ordinal to a
candidate frame descriptor is established. Visual similarity is not a runtime
selection contract or proof that a frame is unused.

The scoped graphics/PNG inventory is accounted for. Eight incomplete editing
compositions retain their backing data; a partial composition does not imply
missing original bytes. Use [the graphics catalogue](../../gfx/README.md),
`gfx/assets.tsv`, `gfx/screens.tsv` and the sprite resources in `gfx/` for distributed resources.

## Bank23 mail-status panels

`23:7C03–7F30` has a PROBABLE layout of 13 leading zero bytes and four 200-byte
records. Each record has 100 tile indices and 100 attributes, forming a 20×5
panel. With the MailSession graphics, the captions read sending mail, mail sent,
receiving mail and mail received, with a B-cancel footer.

These captions use VRAM1 atlas tiles. The active mail-status implementation
instead rasterizes strings into WRAM2 and uploads them to VRAM0 `$9400`.
The atlas also supplies other used cells. No natural Bank23 reader/selector is
established, so neither an obsolete implementation nor global non-use is proven.
