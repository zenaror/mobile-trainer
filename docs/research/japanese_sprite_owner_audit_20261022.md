# Japanese sprite owner audit and structural labels (2026-10-22)

## Scope and result

This pass reviewed 503 typed, address-suffixed sprite labels in 12 Japanese graphics owners and replaced them with structural labels. Names express the source owner, object-table entry ordinal, and frame ordinal where applicable; they intentionally do not claim visual identity or runtime reachability. The 503 declarations have 1,670 source references in the audited owners. The translation tree and ZIP inputs were not part of this pass.

The reviewed source macros reconstruct 7,719 bytes at the audited original-ROM addresses with zero mismatches. This is a bounded byte-level static comparison, not evidence that each object is displayed during natural play. The normal ROM identity build remains a separate required gate.

| Owner | Renamed labels |
|---|---:|
| `gfx/mail/session_objects.asm` | 202 |
| `gfx/browser/page_list_candidate.asm` | 49 |
| `gfx/mailbox/objects.asm` | 46 |
| `gfx/browser/menus.asm` | 44 |
| `gfx/mail/connect_screen.asm` | 44 |
| `gfx/address_book/shared_tiles_bank28.asm` | 31 |
| `gfx/text_cursor/objects.asm` | 24 |
| `gfx/comm/connect_dialog_bank56.asm` | 24 |
| `gfx/mail_server/tidy_screen.asm` | 20 |
| `gfx/browser/start_choice.asm` | 10 |
| `gfx/mail_server/delete_method_screen.asm` | 7 |
| `gfx/address_book/address_screen_candidate_bank2c.asm` | 2 |

The independent source-macro comparison covered 7,719 bytes total: 2,877 bytes in `session_objects.asm`, 2,649 bytes across the four browser/mail owners (`page_list_candidate`, `mailbox/objects`, `browser/menus`, `mail/connect_screen`), and 2,193 bytes across the other seven owners. All compared bytes matched the original ROM; the grouped figures do not claim per-file allocation for the latter groups.

## Selector behavior and comment corrections

`Sprite_LoadObjectEntry` at `00:0AB8` masks the input with `$7F`, performs two 8-bit doublings, then adds the table base. The high bit produced by the second doubling is discarded, so the effective offset is `DE + 4*(B&$3F)`. The original bit 7 is separately retained by the caller as repeat state. This is why comments describing the selector as `B&$7F` were corrected; the assembly logic itself was not changed. The source routine and caller contract are the evidence for this behavior.

Comments for three additional tables outside the 12-owner label pass were corrected to use the same effective selector: `gfx/mail/mail_title_entry.asm`, `gfx/address_book/list.asm`, and `gfx/address_book/address_picker.asm`.

## Evidence and limits

The Japanese ROM reference SHA-256 is `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. The 12 original owner hashes and the generated exact-label/reference manifest are retained in the ignored task evidence under `PLAN.json` (review artifact); the task-owned audit snapshots and cleanup manifests are recorded under `cleanup-20261022-jp-sprite-audits` (review artifact). These are provenance records, not source authority.

The static walk established 116 frame tables, 249 frames, 138 scripts, and 139 rooted non-null groups among these owners. It did not establish a visual identity for every frame or prove global unreachability. In particular, retain as unresolved: `7F:70F0–70FD` (13-byte raw tail outside the walked page-list script), browser `72:79C2` (raw `$00`, not confirmed padding), and script-shaped unrooted tails at `28:5433`, `28:6F12`, `7F:7BAB`, and `7F:7BC7`. `MailServerMgr` at `2E:795C` remains a five-byte script-shaped hypothesis; `$7710–$77FA` remains a probable format with hypothetical use. Do not label these as unused without further evidence.

Three static audits independently checked naming/ownership or reconstructed byte extents. The results are source-analysis evidence, not emulator hardware observations. The English overlay remains paused pending the Operator's explicit confirmation.
