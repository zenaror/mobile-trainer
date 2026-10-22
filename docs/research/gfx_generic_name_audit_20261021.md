# Static GFX generic-name audit (2026-10-21)

An isolated read-only audit examined 85 maintained `gfx/**/*.asm` sources,
1,856 files under `gfx/`, and 2,817 global label definitions. It found no
current directory named `bankNN`; the historical bank41/bank42 paths map to
the descriptive owners `gfx/frame_designs/foliage_ribbon_and_beveled_panels_41.asm`
and `gfx/frame_designs/metal_flame_and_creature_borders_42.asm`.

The exact `Type_BB_AAAA` pattern matches 1,495 labels: 605 were classified as
lexically generic with evidence in the copied source context, 648 as legitimate
address provenance or co-located aliases, and 242 as indeterminate. Of these,
550 have an adjacent descriptive alias and 945 do not. The inventory separately
lists 62 semantic labels that retain a bank/address suffix. File-path inventory
covered 996 candidate assets: 598 type-plus-address basenames and 398
semantically qualified names with coordinates. The file candidates were
classified as 504 with clear lexical evidence, 14 semantically suggestive but
incomplete, 384 where address provenance is legitimate, and 94 indeterminate.
None of those classes is an automatic rename decision.

These counts are a lexical triage, not a completion claim. The source context
was copied from the same checkout before this audit; asset binaries were
inventoried by path but not decoded or viewed, and comments about consumers
were not revalidated in engine code. Keep names neutral where role is
unproven, and verify each candidate's bank, exact address, references, local
scope and file/path ownership before editing.

The complete 625,149-byte private report is retained at
`.tmp/agent-gfx-name-audit-private-20261021/REPORT.md` (SHA-256
`7b511ddde653b245b02623e8f0bf8fcb25d24b63728e9b4fa2887f65d68c576e`). Its
85-source aggregate SHA-256 is
`9ce4241d25bbff70fc454a9a3fdcb43814ab7b6c61bae6193fd60bde127e9c5c`.

## Bank 42 candidate-owner names (2026-10-21)

Follow-up inspection of `gfx/frame_designs/metal_flame_and_creature_borders_42.asm`
revalidated the four filename-derived families in the source and catalog:
metal screw, jagged flame, blue bubble creature, and orange double line. The
27 bank/address-only `Tiles_42_*`, `Tilemap_42_*`, `Palette_42_*` and
`Data_42_*` globals now use `FrameDesignCandidate_*` names keyed to those
families and their bounded source ranges. The prefix is important: bank 42 has
no demonstrated natural loader, and the edits do not assert that these assets
form complete screens, are used by the game, or have a verified visual role.
Existing CONFIRMED/PROBABLE/HYPOTHESIS comments and byte extents remain. The
catalog labels were synchronized; the raw-image metadata guard for the
`42:69A0` backing now expects its candidate raw-backing name. No asset bytes,
directories, or binary views changed.


## Japanese generic graphic-label follow-up (2026-10-21)

Owner-level review resolved all 64 exact `Tiles_BB_AAAA`, `Tilemap_BB_AAAA`,
`Palette_BB_AAAA` and `Attrmap_BB_AAAA` labels in banks 41/43/44/45/46 using
`FrameDesignCandidate_*` names tied to existing motifs and asset files. These
names do not assert natural selection or complete-screen use. A separate
static consumer audit renamed 25 labels for computed Notice transfers, browser
frame descriptors 0-3, page-list loads, and help-script picture IDs 27-31.
Four further unconsumed or partly unexplained spans retain explicit
candidate/unresolved wording: browser package 4 at 47:68F0, its map and
palette, and the 5B palette block tail. The orphan 7F:7830 graphics remain
`UnresolvedTiles_7F_7830`, not marked unused. Nine owner files with consumer-supported
labels were updated together with their assembly labels.

Current source-bounded grep finds no exact generic address-form `Tiles`,
`Tilemap`, `Palette` or `Attrmap` definitions. The remaining exact generic
`Data_BB_AAAA` names are a separate audited inventory; see the final exact
Data-name section and its individually bounded evidence. No bytes, asset files,
layout boundaries, frozen `config/` files or English sources changed.

## Address-only unresolved graphics path update (2026-10-22)

A fresh maintained-tree filename scan found no `bankNN` directories and one
exact type/bank/address owner path: `gfx/unresolved/tiles_7f_7830.asm`. It is
now `gfx/unresolved/tile_graphics_candidate.asm`; the backing folder and files
are `gfx/unresolved/tile_graphics_candidate/tiles_candidate.{2bpp,png}`.
The 720-byte 45-tile span remains **HYPOTHESIS** and keeps the provenance label
`UnresolvedTiles_7F_7830`. Its owner comment still records no symbolic source
reference or load address in the reviewed code. This names the resource
structure while preserving the unknown role; it does not associate the tiles
with the neighboring page-list prototype or claim global non-use. The backing
2bpp and PNG bytes are unchanged. Layout, asset catalog, PNG rules and the
generated graphics README now use the descriptive path.

The current-tree reconciliation also found one stale catalogue label at
`73:49E0`: `gfx/assets.tsv` still said `Data_73_49E0` although the owner already
defined `BrowserStart_CandidateTiles_49E0`. The row now uses the source label,
and the backing/PNG are `browser_start_candidate_tiles.{2bpp,png}`. The resource
remains PROBABLE; its candidate wording does not promote it to a confirmed
browser-start load or screen role.
