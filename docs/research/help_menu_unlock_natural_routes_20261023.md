# Help menu unlocks on natural save routes

## Finding

The inspected Help menu locks are driven by four persisted bytes in SRAM bank 1.

`HelpMenu_ItemIsLocked` returns unlocked for page 1 item 2 when either `sHelpSeenMail` or `sHelpSeenAddressBook` is nonzero; page 1 item 3 when either `sHelpSeenHomepage` or `sHelpSeenPageList` is nonzero; page 2 item 2 when `sHelpSeenAddressBook` is nonzero; and page 3 item 2 when `sHelpSeenPageList` is nonzero. `HelpMenu_ShowItemText` selects `HelpMenu_LockedTickerTable` when the item is locked. These branch conditions and table selection are **CONFIRMED** by source. The Mail, HomePage, PageList and AddressBook flag/topic associations are now **CONFIRMED** by their natural topic routes: [`mail_help_script_natural_route_20261023.md`](mail_help_script_natural_route_20261023.md), [`homepage_help_script_natural_route_20261023.md`](homepage_help_script_natural_route_20261023.md), [`pagelist_help_script_natural_route_20261023.md`](pagelist_help_script_natural_route_20261023.md) and [`addressbook_help_script_natural_route_20261023.md`](addressbook_help_script_natural_route_20261023.md). The Mail seed already had `$A686=1`, so this route does not show a 0-to-1 flag transition. The natural first-use gate ID `$89` is separately confirmed from `register`: Mail runs through its 31 common pages plus the gate-only nickname prompt at `6C:5177`, and `$A686` transitions `0 -> 1`; see [`mail_first_use_id89_natural_route_20261023.md`](mail_first_use_id89_natural_route_20261023.md).

## State and output

For an SRAM image with two 16 KiB banks, bank 1 address `$A684` is file offset `$2684`. The eight bytes at `$A684–$A68B` are:

| Natural seed | Bytes at `$A684–$A68B` | Relevant flags |
|---|---|---|
| `tutorial_profile` | `89 01 01 00 00 00 00 00` | Mail=1; AddressBook=0; Homepage=0; PageList=0 |
| `browser_pagelist` | `92 01 01 01 01 01 00 00` | Mail=1; AddressBook=1; Homepage=1; PageList=1 |

This is emulator evidence for two natural save states plus static source evidence. It does not establish hardware behavior, exact causality beyond the stored gates, every HelpScript topic's natural entry, or all rendered text and bounds in Bank 6C. Those questions remain open.
