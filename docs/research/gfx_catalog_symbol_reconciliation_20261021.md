# GFX catalog symbol reconciliation (2026-10-21)

## Result

A comparison of `gfx/assets.tsv` labels against the current RGBDS symbols found 31 stale catalog labels. The corresponding Japanese sources in `gfx/comm/comm_scene.asm`, `gfx/comm/connect_dialog_bank56.asm`, and `gfx/comm/notice_dialog.asm` contain unique replacement symbols at the relevant bank and address. The catalog now uses those source names: 22 direct symbol matches and nine CommScene attribute-map rows paired with their owning tilemap symbol.

This is a catalog and generated README correction only. Asset payloads, assembly sources, addresses, sizes, and confidence values are unchanged. The paired attribute-map rows intentionally retain the symbol of the tilemap block that starts before the attribute bytes, matching the existing catalog convention.

## Evidence and limits

The mapping was checked against source labels with explicit bank/address comments and against the built symbol file. `make` reports the reference ROM and rebuilt ROM have the same SHA-256 and `RESULT: IDENTICAL`. `make sym-check`, `make palette-check`, `make png-check`, and the graphics exporter checks validate the catalog and generated views. These checks establish reconstruction integrity, not natural runtime use of each resource.

No English-language assets or sources were consulted or changed; that workstream remains paused pending the Operator's explicit authorization.
