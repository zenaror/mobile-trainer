# Notice record-type-4 tilemap paths

2026-10-18 — private original-ROM path proposal; not adopted or runtime validated.

The single owner formerly named `gfx/registration/screen_bank4b.asm` contains the pair at 4B:4000–42D0. The proposed owner and folder are `gfx/registration/notice_tilemap_bank4b.asm` and `gfx/registration/notice_tilemap_bank4b/`. Its components become `notice_page_type4.tilemap` (360 bytes at 4B:4000) and `notice_page_type4.attrmap` (360 bytes at 4B:4168). Both original binary hashes are retained. These are structural resource names, not recovered original game terminology.

## Positive static reader and extent

`Notice_ShowPage` in `engine/startup/notice_pages.asm` computes a six-byte record address from `wNotice_PageArg` and 65:4BDE. It later compares the **first byte of that record** with `$04`. Only that branch selects `Tilemap_Notice_4B_4000`; `type4` does not mean `PageArg == 4`. In the finite physical slice of 24 six-byte records starting at 65:4BDE, first-byte value 4 occurs at indices 5 and 6. No global PageArg bound, exhaustive caller coverage or natural display is established here.

The branch at 65:4908 sets BC=$1214, DE=$D000, HL=$4000 and A=$4B, then invokes `Tilemap_CopyRectAndAttr` through FarCall at 65:4913. Its 17 original ROM bytes are `01 14 12 11 00 D0 21 00 40 3E 4B CD D1 06 EA 08 00`. The helper at 00:08EA selects source bank A and WRAM bank 7, copies B rows of C cells with destination stride 32, then continues from the advanced source pointer into the attribute destination $400 bytes higher. This yields 18×20 = 360 indices followed by 360 attributes, into $D000/$D400. Both current raw files match their exact original ROM slices.

The source's existing `CONFIRMED` header, both `Tilemap_Notice_4B_4000` and `Data_4B_4000`, their order, bank/address comments, and all emitted data remain unchanged in this proposal. There are no local labels. No confidence level is promoted and no page text, footer interpretation or association with another screen is inferred.

## Path and editing contracts

The owner header and floating SECTION name move together with the one corresponding `layout.link` entry at bank $4B, org $4000. The two INCBINs use the new component paths. Two keyed catalogue rows change only `path` and `asm`; two PNG-rule rows change only `out`. Their types, sizes, coordinates, statuses, labels, `png=-`, dimensions and binary hashes are held. Exactly three lines of the current `gfx/README.md` asset index follow the migration.

No PNG exists in this two-component folder, neither component has a PNG rule, and no current screen editing model names either old component path. No PNG or model is created, renamed, rendered, reclassified or removed. This finite check is not a claim that every possible graphic has an editing model. The current editing tools obtain these paths from the catalogue/rules and discover the owner from the maintained tree; no resource-specific helper change is needed. `gfx/png.mk` has no target for this map/attribute pair and stays byte-held. No exporter, derivation tool or regeneration is run.

The historical/current path map appends three exact old-to-new mappings while holding all previous 235 rows byte-for-byte. Dated research, the 22 historical analysis/preview metadata files, frozen config and legacy generator layouts retain their old locators. In particular `analysis/layout/layout.tsv`, `section_order.tsv`, `layout.link.draft` and its README remain historical. Static inspection of `tree_check.py`, `gen_asm.load_model`/`Model.generate_tree` and layout parsing shows that the legacy tree check constructs a separate source tree from ROM/config/layout; it does not require the maintained owner to exist at the old historical path. This is a source analysis, not an executed tree-check result.

## Validation boundary

The private package records the three file renames/deletions, bounded cell edits, BEFORE pins and a finite reference scan. It changes no maintained files. It has not assembled or compared a rebuilt ROM, run helpers/tests, generated PNGs, imported editing scripts, executed an emulator, or inspected hardware. Unchanged raw ROM slices and an unchanged source label set do not by themselves establish a byte-identical rebuilt ROM. Future adoption belongs to ROOT after independent review and actual checks.

English manifest/override/payload/fallback work remains suspended. The original-only proposal does not migrate or validate language-specific path pins. Shared `docs/README.md` and `REVERSE_ENGINEERING.md` are not copied; ROOT must compose their current text and add this note to the research index if adopted. The existing 235-path migration narrative remains historical; this is a separate three-path unit.
