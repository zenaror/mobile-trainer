# reference 2, group g1_home: adversarial reference

* Callers: `grep -rnw NewName` over the tree (excluding definitions and comments); caller contexts were read for the families (`Gfx_Upload*`, `Tilemap_ApplyMaskRect`, `Sprite_SetHook`, `StringAppend`, `Html_*`, `HtmlStore_*`, `Sound_*`).

* Data: ROM bytes (`Mobile Trainer (Japan).gbc`) for `Palette_AllWhite` (64 bytes of `FF 7F`), `Table_Random_XorBytes` (166 distinct values) and the bank 3F record store (`file://di/`, `contents.htm`, NUL, length word, `<HTML>`).

## Unverified by me

* The correctness of the target names (`SoundDrv_*`, `Canvas_BlitGlyph`, `Settings_GetHiddenModeFlag`, ...) that the stubs and wrappers mirror belongs to other passes; the `Sound_*` stub names are exactly as reliable as those.
* Units of the fixed text positions of control bytes `$04-$07`.
