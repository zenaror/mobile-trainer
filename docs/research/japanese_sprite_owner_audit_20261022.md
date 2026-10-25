# Japanese sprite owner reference and structural labels

The reviewed source macros reconstruct 7,719 bytes at the audited original-ROM addresses with zero mismatches. This is a bounded byte-level static comparison, not evidence that each object is displayed during natural play. The normal ROM identity build remains a separate required gate.

`Sprite_LoadObjectEntry` at `00:0AB8` masks the input with `$7F`, performs two 8-bit doublings, then adds the table base. The high bit produced by the second doubling is discarded, so the effective offset is `DE + 4*(B&$3F)`. The original bit 7 is separately retained by the caller as repeat state. This is why comments describing the selector as `B&$7F` were corrected; the assembly logic itself was not changed. The source routine and caller contract are the evidence for this behavior.

Comments for three additional tables outside the 12-owner label pass were corrected to use the same effective selector: `gfx/mail/mail_title_entry.asm`, `gfx/address_book/list.asm`, and `gfx/address_book/address_picker.asm`.

`MailServerMgr` at `2E:795C` remains a five-byte script-shaped hypothesis; `$7710–$77FA` remains a probable format with hypothetical use.
