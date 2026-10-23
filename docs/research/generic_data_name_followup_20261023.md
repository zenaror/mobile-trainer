# Follow-up: neutral generic data labels retained (2026-10-23)

At Japanese base `a691d5560153c974fafd1ed18ee6d8e7ec81f521`, an independent
static audit reviewed 12 `Data_BB_AAAA` definitions across six maintained
roots (excluding `languages/`, the ZIP, and protected
`engine/mail/sample_data.asm`). The bounded scan found no co-located semantic
alias, no second global definition at the same bank/address, no exact literal
`$AAAA` operand targeting those starts, and no demonstrated read/call/reference
that establishes a better name. Neighboring bytes and linear opcode decoding
were not treated as proof of a function or resource. All 12 therefore remain
neutral and **HYPOTHESIS/UNCLASSIFIED**. This negative result does not exclude
computed access or a consumer outside the scanned source set.

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
| `Data_26_5062` — `engine/mail/mail_session.asm:2028` | `3E FF 3E 7F C9` | Linear decoding resembles two loads and a return, but the prior path already returns and no entry or reader is demonstrated. |
| `Data_72_63D7` — `data/text/dialog_messages.asm:620` | `AF` | It follows a text terminator; the known two-item menu entry begins at `63D8`. |
| `Data_24_6520` — `gfx/browser/page_list.asm:87` | Repeated word pairs | The referenced addresses lie inside a named tile interval; the preceding palette copy ends at `6520` and the next object table starts at `6530`. No reader establishes this span's type. |
| `Data_5F_6980` — `gfx/keyboard/panels_bank5f.asm:469` | 48 bytes of `$06` | The known T5 tile and tilemap/attribute copies exclude this span. A similarly numbered address in bank `71` is unrelated. |

The current six-root lexical census also includes
`Data_75_6D62` (`lib/mobile/main.asm:7420`, byte `$C9`). The instruction path
immediately before it ends in an unconditional jump to
`MobileState_HttpExchange_Substep3_CheckStatus`; the next named entry begins at
`75:6D63`. Since this item was outside the 12-label audit above and no entry or
consumer was established, it also remains neutral and **HYPOTHESIS/UNCLASSIFIED**.

The result is a bounded disposition, not a claim that all data has been
identified. A future semantic rename needs positive evidence such as a reader,
table position, proven entry, or exact resource boundary. The audit specifically
rejects opcode resemblance, adjacency, or lack of a lexical reference as sole
evidence.
