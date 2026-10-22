# Japanese generic-name census reconciliation (2026-10-22)

## Scope and result

This live census reconciles the Japanese naming snapshots against `main` at
`fdac32971fae5ed4500315d9d8c5e970d99d917d` and the reviewed bank-48 source
boundary change in this checkpoint. It reads tracked `.asm`/`.inc` files,
excluding `languages/` and the protected `engine/mail/sample_data.asm`. The
inventory contains 349 files across the maintained source roots, support
includes, constants and `zero_labels.asm`.

The pre-change exact address-form census contained 14 `Data_BB_AAAA`
definitions: 13 in the maintained source roots and `Data_48_69AB` in
`zero_labels.asm`. The additional bank-48 review established that the two
keyboard preview values `$FF82`/`$FF83`, when passed through the normal
static reader path, select 16-byte sources at `48:[69AB,69BB)` and
`48:[69BB,69CB)`. Both are outside the declared 80-byte
`Font_GlyphRun_83BF` `INCBIN` at `48:[5D7B,5DCB)`. The name is now
`FontReader_OutOfRunSource_48_69AB`; it identifies this source relationship,
not the bytes' original object identity or intent. The declared `INCBIN`
length is verified against the matching 80 ROM bytes, and the separate 32
zero bytes match the original ROM and pinned layout.

After that rename, 13 exact `Data_BB_AAAA` names remain. Their independent
bounded review found no justified semantic identity or entry; all stay
neutral and HYPOTHESIS. The exact address-form scan found no definitions for
`Function`, `Func`, `Sub`, `Unknown`, `Code`, `Label`, `String`, `Font`,
`Tiles`, `Tilemap`, `Attrmap`, `Palette` or `Table` prefixes. These counts do
not include local branch labels, which are not global function definitions.

The tracked GFX tree has no `bankNN` path component and no strict
`tiles_AAAA`, `tilemap_AAAA`, `attrmap_AAAA`, `palette_AAAA`, `font_AAAA`,
`data_AAAA`, `string_AAAA` or `table_AAAA` filename. Qualified candidate and
unresolved names remain where evidence does not establish a specific role.

## Limits and evidence

The 13 retained data labels and their byte-level limits are enumerated in
[`generic_data_name_followup_20261023.md`](generic_data_name_followup_20261023.md)
and [`japanese_sprite_data_followup_20261022.md`](japanese_sprite_data_followup_20261022.md).
The independent bank-48 review, input bytes, calculations, declared section
boundary, and unresolved semantic limits are in
[`font_reader_69ab_bounds_20261020.md`](font_reader_69ab_bounds_20261020.md#structural-name-correction-2026-10-22).
The earlier 337-file/13-label snapshot in
[`japanese_generic_name_census_20261023.md`](japanese_generic_name_census_20261023.md)
has a narrower owner exclusion and remains valid at its stated source
revision. None of these lexical/static results proves all ROM code is
semantically understood, all candidate assets are unused, or all computed
references are absent. The English overlay and Operator ZIP were not
inspected.
