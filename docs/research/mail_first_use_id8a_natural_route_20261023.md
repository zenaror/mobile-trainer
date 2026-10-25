# Natural second-entry Mail gate: HelpScript $8A (2026-10-23)

## Finding

The second ordinary entry into the Mail menu on the existing `tutorial_profile` save dispatches HelpScript ID `$8A` through `Tutorial_GateMailMenu` at `48:4A29`. The natural route rendered 13 consecutive Address Book tutorial screens, then returned to the Mail submenu. This confirms the behavior of the second-entry gate on this save, not every branch or every save state.

The starting save has SRAM bank 1 `$A684-$A68B = 89 01 01 00 00 00 00 00`, `sTutorialGateMailMenu` at `$A89A = 1`, and `sTutorialGateTopMenu` at `$A89B = 1`. After the route, both complete replays have `8A 01 01 01 00 00 00 00`, `A89A = 2`, and `A89B = 2`. The route crosses both gates, so these are two distinct one-byte counters, not a single two-byte counter. Dynamic traces record bank-1 writes `$A687-$A688` and `$A89A-$A89C`; `sHelpSeenAddressBook` changes 0 to 1, and each gate counter advances 1 to 2. The `$A686` Mail flag remains 1.

Two complete replays produced 14 screenshots each: captures `page_00` through `page_12` show the tutorial sequence, and `page_13` shows return to the Mail submenu. All 14 captures match byte-for-byte between runs. The macro uses normal A inputs and passive captures; no `force`, `ramset`, SRAM poke, or ROM patch was used.

This is a bounded emulator observation using the existing registered adapter save and fake Internet. It is not hardware evidence. Separate natural-route reports confirm first-use HelpScript `$81` and `$91/$92` for their recorded saves ([`$81`](help_script_id81_natural_route_20261023.md), [`$91/$92`](help_script_homepage_first_use_ids91_92_natural_routes_20261023.md)); this report remains scoped to `$8A` and does not establish every conditional branch or hardware behavior.

## Reproduction and evidence

ROM SHA-256: `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
Tracer SHA-256: `c3a4ac33ea322822c3f1b0f44d8f1e4f7343ac4f39ec9f328f97d98c4ad48867`.
The run macro, runtime identities, two trace summaries/data-access tables, SRAM outputs, and all capture hashes are recorded in the private ignored manifest `MANIFEST.json` (review artifact).

The first exploratory run stopped before the terminal input and is excluded from the result. The two complete runs are `recheck` and `recheck2`; each ended at frame 10,724 after 47,025,651 instructions.
