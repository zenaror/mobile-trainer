# Prepared reference: original 6C:61AC header

The [analysis](naming_6c_61ac.md) retains neutral PROBABLE classification,
HYPOTHESIS live entry/field purpose, bitfield rather than assumed boolean
input, and bank-shadow/trampoline/stack qualifications. It distinguishes entry
zero wrapping to $FF from entry one reaching expiry. No universal A/F contract
or `wHelpScript_DeferredTextSfx` purpose is imported into this routine.

* `engine/help/help_script.asm` — three existing header comments only.

* `docs/research/naming_6c_verify_61ac.md` — new preparation record.

Own original-ROM bytes confirm the counter address C0DA through 21 DA C0 and the unchanged operand wRam_C0DA.

The helper selects WRAM7 and writes D/E to DA20/21; it restores SVBK from the software shadow.

Coherent mapping/shadow, initialized HRAM trampoline, valid nonaliasing stack and uninterrupted, non-reentrant flow remain material preconditions.

Three comment rows in help_script.asm qualify the unobserved31-byte fragment at6C:61AC.
