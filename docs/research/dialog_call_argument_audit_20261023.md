# Bank 72 dialog call arguments — static audit (2026-10-23)

## Result and limits

The maintained source has 44 external far-call sites to `Dialog_Open`, `Dialog_Show` or `Dialog_ShowMonitored`, plus the two pass-through calls from the `Dialog_Show*` wrappers to `Dialog_Open` in `engine/dialog/dialog.asm`. All 44 external sites use `D=1` or `D=2`. The literal and branch-composed `E` arguments fit the corresponding 23-entry and 44-entry lists in `data/text/dialog_messages.asm`. The one page-view call that supplies `E` from `wBrowserPendingMessage` is also bounded for the identified source entry paths: its call-time domain is `$00,$01,$06,$0B,$0C,$10,$11`.

This is a bound on the arguments at the identified source call sites, not a callee guarantee. `Dialog_Open` indexes `Dialog_ListTable` directly with `D`, then indexes the selected list directly with `E`; neither index is checked against a list length. The results do not prove natural execution of every call site, and do not define behavior for other inputs or a future caller. `Dialog_List0` and `Dialog_List3` each have one entry but no direct caller selecting `D=0` or `D=3` was found in this census.

The two wrappers at `72:4000` and `72:4015` forward `DE` unchanged to `Dialog_Open`. Four additional source sites are in `engine/unreferenced/page_list_prototype.asm`; they are itemized separately below because that source is explicitly a prototype and this audit makes no reachability claim for it.

## Maintained external call sites

The table records the incoming `DE` value at each call, using hexadecimal `D:E`. Ranges separated by `/` are mutually exclusive branches. The dynamic page-view argument lists every explicit project-source store found for `wBrowserPendingMessage`; these stores are not a bound on arbitrary RAM entry state and are not a hardware or natural-run observation.

| Source site(s) | Target | Supplied `DE` |
| --- | --- | --- |
| `engine/address_book/view.asm:64` | `Dialog_Show` | `$020B` (call lies in a region whose separate entry remains HYPOTHESIS) |
| `engine/address_book/save_sender_address.asm:442` | `Dialog_Show` | `$0208` |
| `engine/address_book/save_confirm.asm:53` | `Dialog_Show` | `$020B` |
| `engine/address_book/confirm_screen_candidate.asm:29` | `Dialog_Show` | `$0204` (candidate/forced-only context; no natural-use claim) |
| `engine/address_book/list.asm:328` | `Dialog_Show` | `$020D` |
| `engine/address_book/address_editor.asm:101,192,244` | `Dialog_Show` | `$0205`, `$0217`, `$0218` respectively |
| `engine/profile/profile_editor.asm:130,193,272` | `Dialog_Show` | `$0214` at each site |
| `engine/mail_server/tidy.asm:347,864,1164` | `Dialog_Open`, `Dialog_Show`, `Dialog_Open` | `$0228`, `$022A`, `$0229` respectively |
| `engine/mail_server/delete_menu.asm:45`; `engine/mail_server/delete_hidden.asm:45` | `Dialog_Show` | `$0227` at each site |
| `engine/browser/page_list.asm:167,1681,2061,2434` | `Dialog_Open` twice, then `Dialog_Show` twice | `$0110`, `$0110`, `$0109`, `$0108` respectively |
| `engine/browser/page_view.asm:66` | `Dialog_ShowMonitored` | `D=$01`; `E=wBrowserPendingMessage`, domain `$00,$01,$06,$0B,$0C,$10,$11` on identified source paths |
| `engine/browser/page_view.asm:372,626,671,701,941` | `Dialog_ShowMonitored`, `Dialog_ShowMonitored`, `Dialog_Open`, `Dialog_ShowMonitored`, `Dialog_ShowMonitored` | `$0113`, `$0101`, `$010F`, `$0105/$0114`, `$0110` respectively |
| `engine/comm/notice_dialog.asm:28,32` | `Dialog_Open`, `Dialog_Show` | `$010F`, `$0110` respectively |
| `engine/main/navigation.asm:128` | `Dialog_Show` | `$021F` |
| `engine/mail/draft_menu.asm:139` | `Dialog_Show` | `$0209` |
| `engine/mail/mailbox.asm:283,483,633,868` | `Dialog_Show` | `$0206`, `$0221`, `$0213`, `$021E/$022B` respectively |
| `engine/mail/result_screens.asm:682` | `Dialog_Show` | `$0224`, `$0225` or `$0226`, selected by the preceding branches |
| `engine/mail/mail_viewer_sender.asm:74` | `Dialog_Show` | `$0206` |
| `engine/mail/body_editor.asm:94,151,2752,3000` | `Dialog_Show` | `$0200/$0211/$020F`, `$0202`, `$0202`, `$0200/$0211/$020F` respectively |
| `engine/mail/address_editor.asm:102,189,229,431` | `Dialog_Show` | `$0205`, `$0211`, `$020F`, `$0200` respectively |

The literal/branch-composed D=1 arguments use E no greater than `$14` (20); the variable site has a statically closed call-time domain no greater than `$11` (17) on the identified paths. The D=2 sites use E no greater than `$2B` (43). The exact record counts are 23 for `Dialog_List1_Browser` and 44 for `Dialog_List2_Mail`; every identified call-time value fits those extents.

The variable-domain derivation covers all source entries to `Browser_PageView_Enter`: the result table in `engine/browser/session_start.asm` is reached through `Browser_LoadAndDispatch`, which clears the field before `Browser_LoadPage`; the remaining entries are the 11 direct `jp Browser_PageView_Enter` sites in `engine/browser/page_view.asm`. `Browser_LoadPage`/its loader helpers can set `$0C`, the inline-image paths can set `$01` or `$06`, and the page-view paths can set `$0B`, `$10` or `$11`; the remaining writes clear the byte. `Browser_PageView_Enter_StartLoop` clears it after the dialog dispatch, before normal input-loop reentry. A complete source search finds no other named store outside the separately listed prototype. This is CONFIRMED static source-flow coverage of identified entries, not proof of natural execution, arbitrary pointer aliases, or an input check in the dialog routine.

## Prototype and raw-byte cross-check

| Source site | Target | Supplied `DE` |
| --- | --- | --- |
| `engine/unreferenced/page_list_prototype.asm:535,1762` | `Dialog_Open` | `$0110` at each site |
| `engine/unreferenced/page_list_prototype.asm:2190,2555` | `Dialog_Show` | `$0104`, `$0103` respectively |

The original ROM file used for the read-only signature scan has SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`, matching `roms.sha256`. A byte-pattern count for `CALL $06D1 ; dw target ; db $72` yielded 10 matches for `$402A`, 35 for `$4015` and 5 for `$4000`. Those counts equal the 46 maintained-source call instructions plus these four prototype sites. This count is a consistency check only: byte-pattern matching is not site-by-site disassembly proof and does not classify runtime reachability.

## Reproduction scope

- Source census: inspect `farcall Dialog_Open`, `farcall Dialog_Show` and `farcall Dialog_ShowMonitored` in `home/`, `engine/`, `data/`, `gfx/`, `audio/` and `lib/`; keep `engine/unreferenced/page_list_prototype.asm` separate and do not inspect or include `languages/en/` while the English branch is paused.
- Argument derivation: follow the last live assignment to `DE` across the local bank/WRAM preservation sequences and each conditional branch. For the `$0100` page-view argument, enumerate every `Browser_PageView_Enter` entry and every project-source store to `wBrowserPendingMessage`; distinguish the prototype-only source.
- List lengths and the unchecked indexing behavior: `data/text/dialog_messages.asm` and `engine/dialog/dialog.asm` (`72:402A` onward).
- ROM identity: `sha256sum 'Mobile Trainer (Japan).gbc'` compared with `roms.sha256`; no ROM bytes were written.

**Evidence class:** CONFIRMED for the source call-site census, stated literal/branch argument derivations, list lengths, source indexing mechanics, ROM hash and raw byte-pattern counts. No natural-execution claim is added.
