# Bank 28: seven palette staging blocks

ROMX offset is bank * $4000 + CPU address - $4000.

Palette_LoadToBuffer stores A in hFarBank, selects WRAM bank 7 through hWRAMBank/rSVBK, and uses FarCall_Inline16 with the inline word 00:050C.

## Palettes and natural reads

| range in bank 28 | existing label | loaders (call addresses) |
| --- | --- | --- |
| $4AF0-$4B30 | `MailBody_BgPalette` | 28:4065, 2B:7BBC |
| $4B30-$4B70 | `MailBody_ObjPalette` | 28:4076, 2B:7BCD |
| $51D0-$5210 | `Palette_AbookList_Bg` | 2F:460C |
| $5EA0-$5EE0 | `MailServerDeleteAll_BgPalette` | 22:45C2, 23:44B1 |
| $5EE0-$5F20 | `MailServerDeleteAll_ObjPalette` | 22:45D6, 23:44C5 |
| $6E00-$6E40 | `MailServerDeleteMethod_BgPalette` | 22:424E, 23:41FD |
| $6E40-$6E80 | `MailServerDeleteMethod_ObjPalette` | 22:4262, 23:4211 |
