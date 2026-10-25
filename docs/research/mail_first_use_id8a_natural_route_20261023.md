# Natural second-entry Mail gate: HelpScript $8A

## Finding

The natural route rendered 13 consecutive Address Book tutorial screens, then returned to the Mail submenu.

This confirms the behavior of the second-entry gate on this save, not every branch or every save state.

The starting save has SRAM bank 1 `$A684-$A68B = 89 01 01 00 00 00 00 00`, `sTutorialGateMailMenu` at `$A89A = 1`, and `sTutorialGateTopMenu` at `$A89B = 1`. After the route, both complete replays have `8A 01 01 01 00 00 00 00`, `A89A = 2`, and `A89B = 2`. The route crosses both gates, so these are two distinct one-byte counters, not a single two-byte counter. Dynamic traces record bank-1 writes `$A687-$A688` and `$A89A-$A89C`; `sHelpSeenAddressBook` changes 0 to 1, and each gate counter advances 1 to 2. The `$A686` Mail flag remains 1.

Two complete replays produced 14 screenshots each: captures `page_00` through `page_12` show the tutorial sequence, and `page_13` shows return to the Mail submenu. All 14 captures match byte-for-byte between runs. The macro uses normal A inputs and passive captures; no `force`, `ramset`, SRAM poke, or ROM patch was used.

This is a bounded emulator observation using the existing registered adapter save and fake Internet. It is not hardware evidence. Separate natural-route reports confirm first-use HelpScript `$81` and `$91/$92` for their recorded saves ([`$81`](help_script_id81_natural_route_20261023.md), [`$91/$92`](help_script_homepage_first_use_ids91_92_natural_routes_20261023.md)); this report remains scoped to `$8A` and does not establish every conditional branch or hardware behavior.
