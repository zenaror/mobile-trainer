# Font glyph-run and default configuration resource names

This bounded original-ROM source migration retires 33 historical aliases while retaining
the existing semantic labels, addresses, bytes and evidence levels. It moves 27 glyph
binary/PNG pairs without rendering them. The mapping below and
[glyph-run path map](font_glyph_run_path_map.tsv) preserve original provenance.

## Glyph storage and caller contract

The bank48 run storage remains **PROBABLE**. The existing record interpretation at
48:4810 is **CONFIRMED**: 27 five-byte records (SJIS lower-bound key16, bank byte,
pointer16), in descending key order, followed by `$FFFF`; 27 x 5 + 2 = 137 bytes.
`data/fonts/font_8x16.asm` retains 303 glyphs, 16 bytes each, total4848 bytes.
Physical order differs from key order. For example, key824F names the run at48:4ADB;
`sjis_824f.1bpp` is not a claim that the physical address is824F. The `start` field
in `gfx/png_rules.tsv` retains4adb; it remains the physical font codec origin.

Static source contract: `engine/text/font_8x16.asm`, 48:4748-480F, reads five caller
words at entry SP+6: SJIS (trail low, lead high), destination1 pointer, destination1
bank word, destination2 pointer, destination2 bank word. It skips the high byte of
each bank word. The positive text renderer callers in `engine/text/text_tiles.asm`
push five words and remove10 argument bytes after the farcall.

The search chooses a descending lower-bound key and scales the trail-byte difference
by16. There is no per-run upper-bound check: arbitrary SJIS values are not established
as safe. All27 record bank bytes are48. The byte is read intoD, which is later
overwritten by the destination bank before `BankSwitch_H`; this is not an established
general source-bank-switching table ABI. Source reads throughBC require ROM48 to
remain selected, including during destination switches and interrupts. The supported
caller destinations are RAM; selecting a ROM destination that switches away from48
is outside this proved contract.

Two eight-byte loops duplicate each source byte into equal2bpp planes (32 writes for
16 source bytes). SRAM is enabled during the copy and disabled on exit; previous
WRAM/SRAM banks are restored from their HRAM shadows. Shadow/hardware coherence,
destination accessibility and interrupt continuity remain caller/state assumptions;
this migration repairs none of those behaviors. An executed renderer entry does not
prove natural reads of every run. The preserved PNG hashes prove an exact file move,
not a new render or original display observation. Earlier rendered-content evidence
in `naming2_verify_data2a.md` remains historical.

## Default configuration images

`data/account/default_config_images.asm` retains four192-byte immutable source images
at68:67E0,68A0,6960,6A20. Existing image0 storage has historical **CONFIRMED** read
evidence; images1-3 retain **PROBABLE** storage evidence. The default-image role is
**PROBABLE**, supported by the existing table and its static consumers; no new image2
read or natural execution is claimed.

`Config_DefaultImageTable` at68:67D8 has four pointer words. Static
`Config_BuildImageFromAccount` (68:6CF0 in `engine/account/register_config.asm`) indexes
it using `wMobileAdapterType`, copiesC0 bytes to `sConfigImage` under callers' SRAM2
enable/bank setup, then modifies account fields and restores the prior byte+3.
The built SRAM result is not necessarily identical to its immutable template.
ROM68 must remain mapped while table/image bytes are read. Index0..3 is a precondition:
no range guard is present in the shown consumers; the SDK's type-minus88 handling
does not establish validation. SRAM shadow/hardware coherence and interrupt continuity
remain assumptions.

`Dial_LoadDefaultsForAdapterType` (68:46C8, `engine/account/helpers.asm`) also indexes
the table, reads interior+76 for the number conversion and+7E for the bounded comment
copy. Images0/1 are equal and images2/3 are equal; pair equality does not identify a
provider, model, color undisclosed field. No sample account/dial/password contents
are reproduced here. See the historical `naming_g7.md` record for earlier interpretation.

## Historical alias map

Retirement replaces only each obsolete alias declaration with a blank line; no locals
belong to these33 aliases. Active font INCBIN paths, asset labels/paths and PNG rules
are updated together. Frozen configuration, earlier analysis, fixtures and translation
history remain receipts of their original state.

| old alias | retained name | original address |
|---|---|---|
| `Font_48_4ADB` | `Font_GlyphRun_824F` | 48:4ADB |
| `Font_48_4B7B` | `Font_GlyphRun_8260` | 48:4B7B |
| `Font_48_4D1B` | `Font_GlyphRun_8281` | 48:4D1B |
| `Font_48_4EBB` | `Font_GlyphRun_829F` | 48:4EBB |
| `Font_48_53EB` | `Font_GlyphRun_8340` | 48:53EB |
| `Font_48_593B` | `Font_GlyphRun_8140` | 48:593B |
| `Font_48_59FB` | `Font_GlyphRun_814F` | 48:59FB |
| `Font_48_5A2B` | `Font_GlyphRun_815E` | 48:5A2B |
| `Font_48_5A3B` | `Font_GlyphRun_8160` | 48:5A3B |
| `Font_48_5A4B` | `Font_GlyphRun_8162` | 48:5A4B |
| `Font_48_5A6B` | `Font_GlyphRun_8165` | 48:5A6B |
| `Font_48_5A8B` | `Font_GlyphRun_8168` | 48:5A8B |
| `Font_48_5A9B` | `Font_GlyphRun_8169` | 48:5A9B |
| `Font_48_5ABB` | `Font_GlyphRun_816D` | 48:5ABB |
| `Font_48_5AFB` | `Font_GlyphRun_8175` | 48:5AFB |
| `Font_48_5B7B` | `Font_GlyphRun_817E` | 48:5B7B |
| `Font_48_5B8B` | `Font_GlyphRun_8180` | 48:5B8B |
| `Font_48_5BAB` | `Font_GlyphRun_8183` | 48:5BAB |
| `Font_48_5BCB` | `Font_GlyphRun_8189` | 48:5BCB |
| `Font_48_5BEB` | `Font_GlyphRun_818F` | 48:5BEB |
| `Font_48_5C0B` | `Font_GlyphRun_8193` | 48:5C0B |
| `Font_48_5C5B` | `Font_GlyphRun_8199` | 48:5C5B |
| `Font_48_5C9B` | `Font_GlyphRun_819E` | 48:5C9B |
| `Font_48_5CFB` | `Font_GlyphRun_81A6` | 48:5CFB |
| `Font_48_5D5B` | `Font_GlyphRun_81F4` | 48:5D5B |
| `Font_48_5D6B` | `Font_GlyphRun_815B` | 48:5D6B |
| `Font_48_5D7B` | `Font_GlyphRun_83BF` | 48:5D7B |
| `Data_68_67E0` | `Config_DefaultImage0` | 68:67E0 |
| `Data_68_68A0` | `Config_DefaultImage1` | 68:68A0 |
| `Data_68_6960` | `Config_DefaultImage2` | 68:6960 |
| `Data_68_6A20` | `Config_DefaultImage3` | 68:6A20 |
| `Table_48_4810` | `Font_GlyphRunTable` | 48:4810 |
| `Table_68_67D8` | `Config_DefaultImageTable` | 68:67D8 |
