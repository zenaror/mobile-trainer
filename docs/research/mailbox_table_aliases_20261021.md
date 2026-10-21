# Mailbox table aliases (2026-10-21)

Retired eight generic `Table_25_AAAA` globals from
`engine/mail/mailbox_screen.asm`. They were exact-address aliases of existing
`Mailbox_RecordAddrs_*`, `Mailbox_HintTable`, or `Mailbox_IconBarAttrTable`
labels. The first seven name mailbox record address lists (the 12-word values
and physical SRAM mapping are already documented in the retained comments);
the last names the icon-bar attribute table. Exact-token scans across
maintained ASM found no consumers beyond the declarations. No values, targets,
interpretations, confidence levels, or ROM bytes changed.
