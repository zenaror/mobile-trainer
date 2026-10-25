# Japanese generic-name census reconciliation

It reads tracked `.asm`/`.inc` files, excluding `languages/` and the protected `engine/mail/sample_data.asm`.

The additional bank-48 review established that the two keyboard preview values `$FF82`/`$FF83`, when passed through the normal static reader path, select 16-byte sources at `48:[69AB,69BB)` and `48:[69BB,69CB)`.

Both are outside the declared 80-byte `Font_GlyphRun_83BF` `INCBIN` at `48:[5D7B,5DCB)`.

The tracked GFX tree has no `bankNN` path component and no strict
`tiles_AAAA`, `tilemap_AAAA`, `attrmap_AAAA`, `palette_AAAA`, `font_AAAA`,
`data_AAAA`, `string_AAAA` or `table_AAAA` filename. Qualified candidate and
unresolved names remain where evidence does not establish a specific role.

The 13 retained data labels and their byte-level limits are enumerated in [`generic_data_name_followup_20261023.md`](generic_data_name_followup_20261023.md) and [`japanese_sprite_data_followup_20261022.md`](japanese_sprite_data_followup_20261022.md).
