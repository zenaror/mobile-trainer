# Natural AddressBook HelpScript route

## Result

The AddressBook HelpScript route is **CONFIRMED** for the observed natural `browser_pagelist` save. Ordinary inputs open Help page 2, move to cursor 2, and select the unlocked AddressBook topic. `HelpMenu_OnA` returns ID `$0A`; 13 consecutive AddressBook screens render, and the next A returns to the Help page-2 menu. The bounded run stops on that first return. No `force`, `ramset`, SRAM poke, or ROM change was used.

Its terminal block at `6C:542D` stores script variable 3 (`10 03 01`), mapped to SRAM bank 1 `$A687`, before the stream ends at `6C:58C6`.

An early B press at the introductory page also returns to the menu, but it skips the rest of the topic and does not exercise the terminal store. A separate exploratory run with an invalid adapter-config path rendered unrelated login-ID/email forms; it is excluded from this result. A corrected longer exploration continued after the first return and re-entered the topic; only the first 14 captures are counted here.

This does not establish the first-use gate variant (`$8A`), every conditional branch, or hardware behavior.

The natural seed's bank-1 bytes `$A684–$A68B` are `92 01 01 01 01 01 00 00`; after the bounded route they are `0a 01 01 01 01 01 00 00`.

The bounded run contains 14 screenshots: 13 AddressBook topic screens (`page_00`–`page_12`) and the page-2 menu return (`page_13`).

The emulator exited 0 at frame 12064 after 55,317,248 instructions. It used the original Japanese ROM, the naturally obtained `browser_pagelist` SRAM/config, mobile on, fake network and ordinary A/D-pad inputs. This is emulator evidence, not hardware evidence.
