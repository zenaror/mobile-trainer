# Notice record-type-4 tilemap paths

The single owner formerly named `gfx/registration/screen_bank4b.asm` contains the pair at 4B:4000–42D0. The proposed owner and folder are `gfx/registration/notice_tilemap_bank4b.asm` and `gfx/registration/notice_tilemap_bank4b/`. Its components become `notice_page_type4.tilemap` (360 bytes at 4B:4000) and `notice_page_type4.attrmap` (360 bytes at 4B:4168). Both original binary hashes are retained. These are structural resource names, not recovered original game terminology.

## Positive static reader and extent

`Notice_ShowPage` in `engine/startup/notice_pages.asm` computes a six-byte record address from `wNotice_PageArg` and 65:4BDE.

It later compares the **first byte of that record** with `$04`.

Only that branch selects `Tilemap_Notice_4B_4000`; `type4` does not mean `PageArg == 4`.

In the finite physical slice of 24 six-byte records starting at 65:4BDE, first-byte value 4 occurs at indices 5 and 6.

The branch at 65:4908 sets BC=$1214, DE=$D000, HL=$4000 and A=$4B, then invokes `Tilemap_CopyRectAndAttr` through FarCall at 65:4913. Its 17 original ROM bytes are `01 14 12 11 00 D0 21 00 40 3E 4B CD D1 06 EA 08 00`. The helper at 00:08EA selects source bank A and WRAM bank 7, copies B rows of C cells with destination stride 32, then continues from the advanced source pointer into the attribute destination $400 bytes higher. This yields 18×20 = 360 indices followed by 360 attributes, into $D000/$D400. Both current raw files match their exact original ROM slices.

## Path and editing contracts

The owner header and floating SECTION name move together with the one corresponding `layout.link` entry at bank $4B, org $4000. The two INCBINs use the new component paths. Two keyed catalogue rows change only `path` and `asm`; two PNG-rule rows change only `out`. Their types, sizes, coordinates, statuses, labels, `png=-`, dimensions and binary hashes are held. Exactly three lines of the current `gfx/README.md` asset index follow the migration.
