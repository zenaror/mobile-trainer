# Title logo resource alias retirement

This finite original-ROM pass retires four historical aliases already colocated with
existing descriptive resource labels in `gfx/title/logo.asm`. It introduces no new
proper name, caller, visual interpretation or independent runtime entry. The source
owner remains pinned by `layout.link` at bank0E:$60A0-$6BB0; its2832 bytes, physical
lines, retained labels, includes and all editable resources remain unchanged.

## Current consumer and bounded contracts

`Title_LoadLogoScreen` in `engine/title/title_screen.asm` is the positive current
consumer. It loads each retained source pointer and `BANK(source)` before its helper:

- `Gfx_TitleLogo_Tiles0` at0E:60A0 and `Gfx_TitleLogo_Tiles1` at0E:64A0 each provide
  1024 bytes. Calls at0E:436B/437D use C=$40, B=$92 and DE=$9001/$9401 with
  `Gfx_StartHDMAWithService`:64 units of16 bytes to VRAM bank1 at$9000/$9400.
- `Tilemap_TitleLogo_Screen` at0E:68A0 provides720 bytes. The0E:439F call passes
  BC=$1214 and destination `wScreenTileMap` to `Tilemap_CopyRectAndAttr`:18 rows by
  20 bytes, then a second pass continuing the source pointer. The360-byte tilemap
  is followed by360 attribute bytes at0E:6A08. Destination banking/row layout follow
  the existing helper contract, not a new arbitrary-destination promise.
- `Palette_TitleLogo` at0E:6B70 provides64 bytes. The0E:438E call passes BC=$0040
  and destination `wPaletteBufBg` to `Palette_LoadToBuffer`, which selects WRAM7 and
  composes a source-bank `CopyBytes` through `FarCall_Inline16`.

The source's three CONFIRMED headers and palette PROBABLE header are retained.
A positive static palette consumer does not silently upgrade the inherited storage
status. The existing screen catalog also remains PROBABLE. Mapping/shadow coherence,
valid visible stack, destination accessibility, CGB state, interrupt continuity and
the helpers' timing/input domains remain prerequisites. The HDMA service helper's
LCD-on window is $91<=LY<B; its C=$01..$80 domain includes these C=$40 calls.
No universal bank/register/IME preservation, original displayed scene, complete
runtime safety or new execution evidence is asserted by retiring aliases.

## Finite transformation and historical lookup

| Retired alias | Existing retained name | Original position | Inherited status |
|---|---|---|---|
| Data_0E_60A0 | Gfx_TitleLogo_Tiles0 |0E:60A0|CONFIRMED|
| Data_0E_64A0 | Gfx_TitleLogo_Tiles1 |0E:64A0|CONFIRMED|
| Data_0E_68A0 | Tilemap_TitleLogo_Screen |0E:68A0|CONFIRMED|
| Data_0E_6B70 | Palette_TitleLogo |0E:6B70|PROBABLE|

Only the four obsolete declaration lines become blank lines. No locals belong to
these aliases and no maintained ASM operand/comment or current asset/preview
metadata uses them. Current metadata already names the retained identities. Frozen
config/xref/analysis records retain old labels as provenance, not operational names.
The two tile binaries/PNGs, tilemap, attrmap, palette source and screen PNG keep their
existing paths and bytes. No image is rendered, decoded or moved in this pass.

The static delta removes exactly four globals from the unchanged Q3 symbol inventory:
14921 to14917 predicted names, with every remaining name/value pair and all51 exported
constants held. This prediction is not a new linked result. ROOT must review the
current BASE, original fallback inventory, linked symbols and required native ROM
comparisons before asserting byte identity or publishing the migration. No build,
emulator, natural scenario or hardware evidence is supplied by this source rename.
