# Bank 72 dialog call arguments — static reference

## Result and limits

The maintained source has 44 external far-call sites to `Dialog_Open`, `Dialog_Show` or `Dialog_ShowMonitored`, plus the two pass-through calls from the `Dialog_Show*` wrappers to `Dialog_Open` in `engine/dialog/dialog.asm`. All 44 external sites use `D=1` or `D=2`. The literal and branch-composed `E` arguments fit the corresponding 23-entry and 44-entry lists in `data/text/dialog_messages.asm`. The one page-view call that supplies `E` from `wBrowserPendingMessage` is also bounded for the identified source entry paths: its call-time domain is `$00,$01,$06,$0B,$0C,$10,$11`.

## Maintained external call sites

The table records the incoming `DE` value at each call, using hexadecimal `D:E`. Ranges separated by `/` are mutually exclusive branches. The dynamic page-view argument lists every explicit project-source store found for `wBrowserPendingMessage`; these stores are not a bound on arbitrary RAM entry state and are not a hardware or natural-run observation.

The literal/branch-composed D=1 arguments use E no greater than `$14` (20); the variable site has a statically closed call-time domain no greater than `$11` (17) on the identified paths. The D=2 sites use E no greater than `$2B` (43). The exact record counts are 23 for `Dialog_List1_Browser` and 44 for `Dialog_List2_Mail`; every identified call-time value fits those extents.

The variable-domain derivation covers all source entries to `Browser_PageView_Enter`: the result table in `engine/browser/session_start.asm` is reached through `Browser_LoadAndDispatch`, which clears the field before `Browser_LoadPage`; the remaining entries are the 11 direct `jp Browser_PageView_Enter` sites in `engine/browser/page_view.asm`.

`Browser_LoadPage`/its loader helpers can set `$0C`, the inline-image paths can set `$01` or `$06`, and the page-view paths can set `$0B`, `$10` or `$11`; the remaining writes clear the byte.

`Browser_PageView_Enter_StartLoop` clears it after the dialog dispatch, before normal input-loop reentry.

## Prototype and raw-byte cross-check

| Source site | Target | Supplied `DE` |
| --- | --- | --- |
| `engine/unreferenced/page_list_prototype.asm:535,1762` | `Dialog_Open` | `$0110` at each site |
| `engine/unreferenced/page_list_prototype.asm:2190,2555` | `Dialog_Show` | `$0104`, `$0103` respectively |

A byte-pattern count for `CALL $06D1 ; dw target ; db $72` yielded 10 matches for `$402A`, 35 for `$4015` and 5 for `$4000`.
