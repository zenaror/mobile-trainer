# Help menu unlocks on natural save routes (2026-10-23)

## Finding

The inspected Help menu locks are driven by four persisted bytes in SRAM bank 1. Static control flow in `engine/help/help_menu.asm` (`HelpMenu_ItemIsLocked`, `6C:4798–4807`) and natural mGBA replays from two existing scenario saves agree on the visible captions. This closes the old claim that all feature-based unlocks were only a hypothesis, but only for the listed menu positions and states.

`HelpMenu_ItemIsLocked` returns unlocked for page 1 item 2 when either `sHelpSeenMail` or `sHelpSeenAddressBook` is nonzero; page 1 item 3 when either `sHelpSeenHomepage` or `sHelpSeenPageList` is nonzero; page 2 item 2 when `sHelpSeenAddressBook` is nonzero; and page 3 item 2 when `sHelpSeenPageList` is nonzero. `HelpMenu_ShowItemText` selects `HelpMenu_LockedTickerTable` when the item is locked. These branch conditions and table selection are **CONFIRMED** by source. The HomePage and PageList flag/topic associations are now **CONFIRMED** by their natural full-topic routes: [`homepage_help_script_natural_route_20261023.md`](homepage_help_script_natural_route_20261023.md) and [`pagelist_help_script_natural_route_20261023.md`](pagelist_help_script_natural_route_20261023.md). The mail and address-book flag/topic names retain the confidence recorded in the RAM ledger.

The test used ordinary menu/button input after the harness's normal `reset`; it did not use `force`, `ramset`, SRAM pokes, or altered ROM bytes. The two seed saves come from the natural `tutorial_profile` and `browser_pagelist` scenario paths in `traces/scenarios.tsv`. Their parent chain is `browser_pagelist -> browser_pages -> browser_bookmarks -> addressbook_full -> mail_inbox -> tutorial_profile`.

## State and output

For an SRAM image with two 16 KiB banks, bank 1 address `$A684` is file offset `$2684`. The eight bytes at `$A684–$A68B` are:

| Natural seed | Bytes at `$A684–$A68B` | Relevant flags |
|---|---|---|
| `tutorial_profile` | `89 01 01 00 00 00 00 00` | Mail=1; AddressBook=0; Homepage=0; PageList=0 |
| `browser_pagelist` | `92 01 01 01 01 01 00 00` | Mail=1; AddressBook=1; Homepage=1; PageList=1 |

The four relevant flag bytes are `$A686–$A689`; their labels and topic associations are documented at `ram/banked.asm:121–124`. Both scenarios use the same 512-byte adapter configuration image (SHA-256 `45fdd476f1adf5c1d87aedaeda675d11f610ab7d7d056231f955aff71c4769ef`).

On the baseline save, page 1 item 3 visibly shows `????` (PNG SHA-256 `44407a63d507b799af9043ccbc43c69d3c02b22935c24be5d9b26a59c19cf8d3`) and page 2 item 2 shows `????` (`54b77c2ade0648fd0e70e7f5d54ac9a6738c9f6f257a5ba3e9b0d797451a7fac`). On the browser/page-list save, page 1 item 3 shows `ホームページって?` (`437c95b9722e165c7740ebe1a0688adc757607b321664623db94e87c62c730c0`), page 2 item 2 shows `アドレスちょう` (`0efbd8419685c26205beefe29b052db8ddfce3ff8244603201db6016a77bf2fd`), and page 3 item 2 shows `ページリスト` (`8a054f988dffc6f0eb29716912dd7bec9097fb90e1e180bff7820b14fedf96a3`). All screenshot hashes are for the corresponding PNGs under `.tmp/jp-help-unlock-followup-20261023/`.

The baseline macro cannot reach page 3: page 1 item 3 is still locked, so the attempted navigation remains on page 1. Its captures named `page3_item1/2` are actually page 1 item 4 and are excluded from the evidence. Likewise, an earlier setup attempt that missed the second A input entered Mobile Settings; its outputs are preserved in the private task directory and excluded. The valid pair uses the corrected route and matching frame recordings.

## Reproduction and evidence

ROM SHA-256: `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Tracer SHA-256: `c3a4ac33ea322822c3f1b0f44d8f1e4f7343ac4f39ec9f328f97d98c4ad48867`. Linked `libmgba.so.0.11.0` SHA-256: `4c221287ee524eeb8fcd21ae45c330a70fe10c162637b284e1f9d87fd7dc8923`. Each run used the ROM above, `--frames 4920`, its listed macro, `--mobile on`, `--net fake`, the same adapter image, the seed SRAM image, and a separate ignored output/screenshot directory. The emulator returned exit status 0 for both.

Baseline invocation:

```sh
./.cache/trace/mgba_trace --rom 'Mobile Trainer (Japan).gbc' --scenario help_before_feature_use_repro --outdir .tmp/jp-help-unlock-followup-20261023/repro-before --frames 4920 --macro .tmp/jp-help-unlock-followup-20261023/inputs-repro/help_before_feature_use_repro.macro --record-input .tmp/jp-help-unlock-followup-20261023/inputs-repro/help_before_feature_use_repro.txt --mobile on --net fake --mobile-config-in .tmp/jp-help-unlock-followup-20261023/state/help_before_feature_use.cfg --save-in .tmp/jp-help-unlock-followup-20261023/state/help_before_feature_use.sav --shots .tmp/jp-help-unlock-followup-20261023/repro-before/shots
```

After-browser invocation:

```sh
./.cache/trace/mgba_trace --rom 'Mobile Trainer (Japan).gbc' --scenario help_after_page_list_repro --outdir .tmp/jp-help-unlock-followup-20261023/repro-after --frames 4920 --macro .tmp/jp-help-unlock-followup-20261023/inputs/help_after_page_list_v2.macro --record-input .tmp/jp-help-unlock-followup-20261023/inputs-repro/help_after_page_list_repro.txt --mobile on --net fake --mobile-config-in .tmp/jp-help-unlock-followup-20261023/state/help_after_page_list_v2.cfg --save-in .tmp/jp-help-unlock-followup-20261023/state/help_after_page_list_v2.sav --shots .tmp/jp-help-unlock-followup-20261023/repro-after/shots
```

Both replays regenerated the captured screenshots byte-for-byte. The baseline and after-browser stats also match the earlier preserved runs in every metric; only the `scenario=` identifier differs. Each ran 4,920 frames; instruction counts were 29,860,544 and 30,006,906 respectively. The runtime reported `waitstable` reaching its documented 600-frame cap on blinking-cursor screens; the fixed-frame input sequence then continued normally.

Selected preserved evidence hashes:

| Artifact | SHA-256 |
|---|---|
| `state/help_before_feature_use.sav` | `b3d0495409ba6fdacd76d74a8b3a9cf7b547a71d88c203b49f9875d937d8e251` |
| `state/help_after_page_list_v2.sav` | `7ad305f31a96c3726e5d319741be0b780eb38d4664b5518346da2a072ca52f19` |
| Adapter configuration (both `.cfg` files) | `45fdd476f1adf5c1d87aedaeda675d11f610ab7d7d056231f955aff71c4769ef` |
| `inputs-repro/help_before_feature_use_repro.macro` | `f3c9404ed2a89cd742f5df680e98a63b82303d13c619d82a7f125fef71f2ccbb` |
| `inputs/help_after_page_list_v2.macro` | `dca907ef25572b0b165e3aa8422b67bc6ce4df3b4469b98a5afe82abbf6fc7b6` |
| Reproduced baseline input recording | `bafec9255986b157a4f31d1eaa90871bba637ab43426b3936b7a777f0258badd` |
| Reproduced after-browser input recording | `b1fc5979e453f4e3a071cef7ed1c4d8461626b0af06ca63d6a2cb2ae16d34358` |
| `run-baseline/stats_help_before_feature_use.txt` | `b1d3d0db25185b56b14520b378fd1f3d95c951711197ade13210af15d5872aeb` |
| `run-v2/stats_help_after_page_list_v2.txt` | `ba160f369091d13d051912dd4f71d973f149d643764bb8745afdb2954ac42e7b` |
| Baseline coverage | `dc483d0071dc63288d2cd8020ded3f177b86d8b313ca76ddad16f6c25f621fcc` |
| After-browser coverage | `0afe8fedc9ff3b9eced287801c36a2224a9e503ce0a3a62b42a757ed4a38bf8f` |
| Baseline data access | `555b510de909e2b13e29fea48031fb0bb1a98a42eb2baa73d658771bd6b37c10` |
| After-browser data access | `f8a9c0d6bd8c052c04b25fbe31ed5fb178609b1493681b70d5085097f35f1226` |

This is emulator evidence for two natural save states plus static source evidence. It does not establish hardware behavior, exact causality beyond the stored gates, every HelpScript topic's natural entry, or all rendered text and bounds in Bank 6C. Those questions remain open.
