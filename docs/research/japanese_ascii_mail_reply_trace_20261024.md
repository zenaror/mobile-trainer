# Natural reply to the second mailbox record (2026-10-24)

## Question and method

The existing inbox trace replied to another received message. This separate natural scenario starts from the retained `mail_receive` save/configuration, opens mailbox row 2 (the fixture's ASCII message), and follows the ordinary reply, address, title, body and save controls. It uses the CGB HLE mGBA Mobile Adapter harness and fake POP3 fixture, not hardware. The protected Japanese ROM is SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; the mGBA source revision used by the tracer is `22506cf00`.

## Observations

The natural trace executes the mailbox copy loops at `25:54F6` and `25:5506`, then takes the normal editor route through `25:5527` and `25:5536`. It reads the two bytes at `25:556B–556C`, which decode little-endian as `$A251`, the second entry in `Mailbox_RecordAddrs_5569` (`25:5569–5580`). The retained parent save (`.cache/trace/state/mail_receive.sav`, SHA-256 `200142acb469a5ff4ffedd05ad7c3d5fae7ddc9f26ea2c9715df860c81f8b741`) has the ASCII sender `someone@example.test` at SRAM `$A33E` (file offset `$33E`), matching `$A251+$ED`; the adjacent name buffer is zero-filled. The table is indexed by the selected mailbox record number; for row 2 this is index 1. The reply routine then uses record offsets `+$ED` and `+$C9` for the address and sender-name copies. This is positive natural evidence for selection and use of the second SRAM record's address-table entry in this fixture.

The run does not execute `2B:6CF5`, and its callgraph adds no edge absent from the prior 71-scenario corpus. Comparing instruction starts likewise finds no new starts. The two-byte table read is the one novel ROM data-access interval: `25:556B–556D`. Therefore this narrows the exercised mailbox-record variant but does not identify a caller or entry for the separate `2B:6CF5` candidate, and does not prove that the candidate is unreachable. A proposed separate reply-via-viewer scenario is not a distinct natural route in the inspected controls: `MailView_SenderPage` maps A to opening `MailView_BodyPage`, B to leaving, and SELECT to `SaveSenderAddr_Menu`; the body page maps A/B to return/exit. These bounded user controls expose no reply action. This rules out only that ordinary viewer route, not computed or otherwise unmodeled entry.

## Reproduction and evidence

The scenario is `mail_reply_ascii` in `traces/scenarios.tsv`; source controls are `traces/inputs/mail_reply_ascii.macro` and the resolved replay is `traces/inputs/mail_reply_ascii.txt`. It was generated with:

```sh
BASEROM="$PWD/Mobile Trainer (Japan).gbc" python3 tools/trace/run_trace.py --from-macro --only mail_reply_ascii --reuse-state
```

The parent state is the existing `mail_receive` trace state. The run produced 8,514 frames and 41,922,002 executed instructions; 14,270 ROM and 14 RAM instruction starts; 24 physical ROM banks. `stats.txt` records zero dropped serial events and the final mapped ROM bank `1D`. The scope is one ordinary emulator scenario and its instrumented ROM reads.

Key SHA-256 values:

| Artifact | SHA-256 |
|---|---|
| `traces/coverage_mail_reply_ascii.tsv` | `301bdeee447aea4c82f59f0775f6465b2c5ae51373a4604cb92d0d80467942b5` |
| `traces/detail/mail_reply_ascii/dataaccess.tsv` | `12973269e0d32858203dfa3212e1769b13e761e04f597c32c37343307cffc560` |
| `traces/detail/mail_reply_ascii/callgraph.tsv` | `958d583dd961d518760b75c0e7546bcc85fce8a90c486b183c51365631d530e0` |
| `traces/detail/mail_reply_ascii/stats.txt` | `87d1fb5633b988eff563e385eb40d450703281f0e3f26efda5e8972ee659345e` |
| `traces/inputs/mail_reply_ascii.macro` | `1426960667e7d1e9a40067f4380c9f4a9fe89d34a5f7c30310eed3eb034bba0d` |
| `traces/inputs/mail_reply_ascii.txt` | `03a5cd747db70d4c13d0e016734216ce154b6a17ba2f00226c4fd0556d7704d6` |

The retained natural corpus now has 72 scenarios and 78,128 unique instruction starts (78,114 ROM and 14 RAM); it has 0 validation errors, 4,046 `FALL_MISSING` warnings and 704 `COND_ALWAYS_TAKEN` informational flags. The union, validation report and trace summary were regenerated from the retained scenario files without rerunning the prior corpus. The union SHA-256 is `0c1986ea507df1172474f07f4a8959b6a872b2fd49912c31bafd551c1dfa37ae`; validation report SHA-256 is `3cc3159ee2ddaf083495c62c330e0349a151c4d29a8ae2845e2aaa4c095ff79d`. The unique-start set did not grow. The run adds a distinct data-read observation only; no global non-use or semantic-completion claim follows.
