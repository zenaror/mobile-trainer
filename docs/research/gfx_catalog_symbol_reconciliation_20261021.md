# GFX catalog symbol reconciliation

## Result

A comparison of `gfx/assets.tsv` labels against the current RGBDS symbols found 31 stale catalog labels. The corresponding Japanese sources in `gfx/comm/comm_scene.asm`, `gfx/comm/connect_dialog_bank56.asm`, and `gfx/comm/notice_dialog.asm` contain unique replacement symbols at the relevant bank and address. The catalog now uses those source names: 22 direct symbol matches and nine CommScene attribute-map rows paired with their owning tilemap symbol.
