# Save-sender address table aliases (2026-10-21)

Retired seven generic `Table_2A_AAAA` aliases from
`engine/address_book/save_sender_address.asm`. Six were exact-address aliases
of existing `Table_SaveSenderAddr_*` symbols: record and slot address lists
used at different steps. The seventh, at `2A:4A66`, was a generic `Table_*`
label over the existing Japanese caption string `String_SaveSenderAddr_Caption`.
An exact-token scan of maintained ASM found only these declarations. The
original 12-word / six-word lists and Shift-JIS bytes are unchanged, as are
comments, confidence and emitted bytes.
