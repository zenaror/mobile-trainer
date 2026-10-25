# Prepared reference: original bank 55 lookup comments

The [analysis note](naming_keyboard_55_lookup.md) preserves PROBABLE lookup and data classification, HYPOTHESIS caller/handler entries and consumer purpose, and the explicit conditional-entry versus unconditional-CALL correction.

## Completed static preparation

* `docs/research/naming_keyboard_55_verify_lookup.md` — new preparation record.

Static arithmetic over all byte indices agrees with `HL=$6EF7+unsigned A`
and the ADC-derived F=$00; indices 0–10 yield the eleven stored bytes, and
index 11 accesses opcode $21 at 55:6F02. This arithmetic check is not forced
emulation, a natural run or proof of a keyboard input domain.

Physical bytes and static arithmetic are separately checked: the 11-byte lookup and 11-byte table remain exact, all 256 unsigned inputs compute 6EF7+A without bank change and with ADC-derived F00; index 11 reads opcode 21. Conditional handler selection and unconditional CALL 5F2A once entered remain distinct. Caller/handler purpose and entry remain HYPOTHESIS; neutral PROBABLE function/data are unchanged.
