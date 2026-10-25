# reference 2, group 3 (apps A): adversarial reference

## Errors found (most important first)

The evidence says "byte-identical (41 insn) to executed `MailSrvDel_NumberTileOffset` (23:5829)".

They are not: the executed routine returns    `BC=$D010/$D020/$D030` (buffer addresses), the dead ones `BC=$0000/$0010`.

Both dead copies *are* byte-identical (constants included) to the executed family    `MailServerStatus_NumberOffset_M0/M1/M2`.

The suffix form `MailSrvDel_NumberTileOffset_23_4986` announced a copy of a routine it differs from.

The code returns `A=$FF` when `[slot+$10]==0` (empty) and `A=0` when used; callers    do `inc a / jr z` to *skip* the used-slot icon for empty slots.

**`SaveSenderAddr_RefreshSlotIcons_2C_5A12`**: presented as a "dead copy of the save-sender screen inside bank 2C".

It lives in `address_picker.asm`, calls the bank-2C `AddrPick_IsSlotUsed_2C_5CA3`, and differs from    both `SaveSenderAddr_RefreshSlotIcons` (2A:4573) and the live `AddrPick_RefreshSlotIcons` (2C:620D): other object bank/table (`$2C:7220/7230` vs `$28:5220/5230`), other y values (`$30,$3C..` vs `$28,$34..`), other tile    value (`$0D` vs `$10`), no `inc c`, no trailing `hJoyPressed & $C0` test.

The evidence text ("`MailBody_PlaceCursorSprites` loads rows") attributes dead code to the live function and "cursor" is not    established.

No CONFIRMED row had to be lowered: the CONFIRMED rows are executed (HDMA copies 16/6 scenarios, `Abook_Run_*` 1-10 scenarios, the `AbookName` loaders, the M0/M2 number templates) or byte-identical to
executed code (verified).

* `AbookView_DrawAddrLine1/2` (executed) are byte-identical to the generic 17/25-cell text-line drawers that exist in `MailDraft_*` and `AddrBook_SaveConfirm_*`; their "Addr" names are subsystem-local, not wrong.
* Several sources still load a label through a raw immediate (`ld hl, $573A`, `ld hl, $6E73`, `ld hl, $7220`) although a named label exists; cosmetic, no naming consequence.
* `Data_MailServerStatus_NumberTemplate_M0/M2` use the `Data_` prefix and `_M1` the `String_` prefix for the same kind of content (header classes differ); cosmetic.
