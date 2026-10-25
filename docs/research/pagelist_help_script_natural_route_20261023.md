# Natural PageList HelpScript route

## Result

The PageList HelpScript menu route is **CONFIRMED** for the observed natural `browser_pagelist` save. Ordinary inputs open Help page 3, move to cursor 2, and select the unlocked PageList item. `HelpMenu_OnA` returns ID `$12`; seven consecutive PageList screens render, and the next A returns to the Help page-3 menu. The bounded run stops on that return screen. No `force`, `ramset`, SRAM poke, or ROM change was used.

The selected topic title and sequence match the static stream beginning at `6C:56F4`; its end block at `6C:58C0` stores script variable 5 (`10 05 01`), mapped to SRAM bank 1 `$A689`.

This does not establish the first-use gate variant (`$92`), other HelpScript topics, every conditional branch, or hardware behavior.

The natural seed's bank-1 bytes `$A684–$A68B` are `92 01 01 01 01 01 00 00`; after the bounded route they are `12 01 01 01 01 01 00 00`.

The output contains eight screenshots: seven PageList screens (`page_00`–`page_06`) followed by the return menu (`page_07`).

The emulator exited 0 at frame 8938 after 44,083,707 instructions. It used the original ROM and a naturally obtained `browser_pagelist` save/config, with mobile on, fake network and ordinary A/D-pad inputs. This is emulator evidence, not hardware evidence.
