# Title logo resource alias retirement

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
