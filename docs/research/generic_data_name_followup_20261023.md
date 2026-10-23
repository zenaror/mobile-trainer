# Follow-up: neutral generic data labels retained (2026-10-23)

At Japanese base `a691d5560153c974fafd1ed18ee6d8e7ec81f521`, the original
independent static audit covered 12 `Data_BB_AAAA` definitions across six
maintained roots (excluding `languages/`, the ZIP, and protected
`engine/mail/sample_data.asm`). The six-root lexical census also contained
`Data_75_6D62`, which was separately reviewed, for 13 spans in this
disposition. The adversarial follow-up at `ae6b9ccef65207421f832ff856afe1659ece9865`
rechecked all 13 against the original ROM and existing access/coverage records.
No demonstrated read, call, or reference established a better functional
name for the remaining spans. Neighboring bytes and linear opcode decoding
were not treated as proof of a function or resource. The result does not
exclude computed access or a consumer outside the scanned source set.
Two exact cross-bank byte matches and one unique masked code match were found;
their labels describe only those correspondences. They do not prove code entry,
active table use, or causal origin in the Trainer.

| Label / source | Observed bytes or structure | Why the current evidence does not support a semantic rename |
|---|---|---|
| `Data_2F_4094` — `engine/address_book/list.asm:94` | `C3 00 40` | The preceding path already jumps to `AbookList_Run_ButtonRow`; the stored bytes decode as `JP AbookList_Run` but no entry at `4094` is demonstrated. |
| `Data_23_46CC` — `engine/mail_server/delete_menu.asm:664` | `C9` | It follows a jump to `.l4608`; the named routine begins at `46CD`. No entry at `46CC` is known. |
| `Data_24_4BCC` — `engine/browser/page_list.asm:1574` | `C9` | It follows the last NUL-terminated Japanese line; the next named action begins at `4BCD`. |
| `Data_72_6711` — `engine/browser/menus.asm:406` | `AF` | It follows a `ret`; `BrowserMenu_OpenThreeItem` starts at `6712`. |
| `Data_4E_5390` — `engine/browser/page_render.asm:315` | `C1` | Adjacent branches leave this byte outside their paths; no entry is shown. |
| `Data_7F_4C77` — `engine/text/canvas.asm:2121` | `C9` | The dotted-line copy reads exactly `[4C57,4C77)`, excluding this byte; no other consumer is known. |
| `Data_7F_51ED` — `engine/unreferenced/page_list_prototype.asm:667` | `C9` | A preceding jump leaves it outside the shown path; the next named entry is `51EE`. |
| `Data_1C_401C` — `engine/main/main_program.asm:36` | `C9` | It follows a jump to the title loop; the nearby pointer table contains no pointer to `401C`. |
| `ByteMatch_MailSessionCancelTail_26_5062` — `engine/mail/mail_session.asm:2028` | `3E FF 3E 7F C9`, byte-identical to `MailSession_Cancel[505D,5062)`; the full 5-byte sequence occurs only at those two ROM locations. | The match is **CONFIRMED**; whether the duplicate is executable, data, or residual bytes is **HYPOTHESIS**. No entry or reader is demonstrated. |
| `Data_72_63D7` — `data/text/dialog_messages.asm:620` | `AF` | It follows a text terminator; the known two-item menu entry begins at `63D8`. |
| `ByteMatch_PageListProto_ObjTableFirstRow_24_6520` — `gfx/browser/page_list.asm:87` | 16 bytes byte-identical to the first row of `PageListProto_ObjTable` at `7F:6DB0`; the full sequence occurs only at those two ROM locations. | Equality is **CONFIRMED**; a residual prototype row is **HYPOTHESIS**. The referenced addresses lie inside bank-24 tile data; no bank-24 reader establishes table use. |
| `Data_5F_6980` — `gfx/keyboard/panels_bank5f.asm:469` | 48 bytes of `$06` | The known T5 tile and tilemap/attribute copies exclude this span. A similarly numbered address in bank `71` is unrelated. |
| `MaskedMatch_CrystalSDK_Local112D4C_75_6D62` — `lib/mobile/main.asm:7420` | `[6D62,6D63)`, byte `$C9`; offset `+$19` in a unique 558-byte masked code match to Crystal SDK local `.asm_112d4c`, marked unreferenced in the Crystal source. | The match is **CONFIRMED** (275/275 instructions; 382 unmasked bytes). Trainer entry/purpose remains **HYPOTHESIS**; the label states correspondence only. |

The three correspondence labels describe confirmed static matches only. The
other ten remain address-neutral and **HYPOTHESIS/UNCLASSIFIED**. This is a
bounded disposition, not a claim that all data has been
identified. A future semantic rename needs positive evidence such as a reader,
table position, proven entry, or exact resource boundary. The audit specifically
rejects opcode resemblance, adjacency, or lack of a lexical reference as sole
evidence.

The Crystal correspondence is independently represented by
`analysis/crystal_matches.tsv:411`, `analysis/crystal_symbol_map.tsv:926–927`,
and `analysis/crystal_coverage.tsv:97`. Its 558-byte block has 152 raw
differences, all in masked operands. The Crystal ENG, JP, and PT-BR ROMs are
byte-identical for this evidence and are not independent lineages.
