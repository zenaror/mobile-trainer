# Natural Mail HelpScript route

## Finding

The Mail HelpScript topic is **CONFIRMED** on the observed natural `browser_pagelist` save. Ordinary menu inputs select Help page 2 cursor 1 and enter Mail topic ID `$09`. Thirty-one consecutive Mail screens render (`page_00`–`page_30`); the next A returns to the Help page-2 menu (`page_31`). No `force`, `ramset`, SRAM poke or ROM modification was used.

Its terminal block at `6C:51A4` stores script variable 2 (`10 02 01`) to SRAM bank 1 `$A686`; the following `$04,$1C,$07` branch reaches END at `6C:58C6`.

Together, the natural menu entry, title, complete topic sequence, terminal store, SRAM write span and return confirm the Mail flag/topic association.

The seed already contained `$A686=1`; it remains 1 after the route. This evidence does not demonstrate a 0-to-1 transition. The selected script ID changes from `$92` to `$09` at `$A684`; the other bytes in `$A684–$A68B` do not change. This is emulator evidence, not hardware evidence, and it does not establish the first-use gate variant `$89` or every conditional branch.
