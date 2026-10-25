# Natural HomePage HelpScript route

## Result

The unlocked Help menu path to the HomePage topic is now **CONFIRMED** for the observed natural save state. From the `browser_pagelist` save, ordinary buttons open Help page 3 and select its first item. `HelpMenu_OnA` returns ID `$11` for page 3, cursor 1; the script displays 14 consecutive HomePage screens, then the next A returns to the page-3 menu. The final menu-return screenshot is at frame 12678. No `force`, `ramset`, SRAM poke, or ROM change was used.

This supplies a natural menu entry and full rendered sequence for the HomePage Help topic on this state. It does not establish the first-use gate variant (`$91`), other HelpScript topics, every conditional branch, or hardware behavior.

The seed's SRAM bank 1 bytes `$A684–$A68B` are `92 01 01 01 01 01 00 00`; after the route they are `11 01 01 01 01 01 00 00`. Only file offset `$2684` changed, from the selected script ID `$92` to `$11`; the HomePage flag at `$A688` was already 1 in the seed. The dynamic data-access output reports a write span at bank 1 `$A688–$A689`; the source tail at `6C:56EE` stores script variable 4, which maps to `$A688`. The rendered topic title, selected menu item, source store, dynamic write span, and return to the menu together confirm the `sHelpSeenHomepage` association. The saved state does not demonstrate a 0-to-1 transition because the input save already had that flag set. The existing `sHelpSeenPageList` confidence remains unchanged.

The completed macro generated 15 captures: 14 topic screens (`page_00`–`page_13`) and the return menu (`page_14`).

It records the command, ROM/tool/library/save/config/input/output hashes, all 15 screenshot hashes, counters, and observed SRAM bytes.
