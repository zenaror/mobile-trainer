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


## Top Menu graphics path migration (2026-10-22)

The seven address-only Top Menu tile names now record their statically
confirmed VRAM destinations and banks. The two tilemap/attribute pairs are
named by confirmed 20×16 and 12×9 dimensions; palette files follow existing
BG/OBJ labels, retaining PROBABLE role classification. Renamed 21 file paths
including PNG views, palettes, maps and the screen preview. All new files match
their previous Git blobs byte-for-byte. Owner/catalogue paths and generated
PNG metadata were synchronized. No source or ROM bytes changed. The English
tree remains paused and untouched; whether it shares old paths is UNKNOWN. Full
evidence and gates: `docs/research/top_menu_resource_paths_20261022.md`.


## Bank 58 registration notice asset paths (2026-10-22)

Twenty-seven address-only paths in `gfx/registration/registration_notice_art_bank58/` now follow the existing notice labels and static Bank 65 readers. The directly loaded 58:4000 prefix and paired 20×18 tilemap paths carry CONFIRMED static roles; header/footer tile families and the palette retain PROBABLE/candidate wording. Payload hashes, source extents and evidence levels are unchanged. The English tree was not accessed. See [`registration_notice_bank58_resource_paths_20261022.md`](registration_notice_bank58_resource_paths_20261022.md).


## Keyboard panel tile paths (2026-10-22)

Nine generic `tiles_<address>` pairs in the T4, T5, T9 and shared Bank 5D/5F panel groups now name their confirmed VRAM1 destinations and keyboard type where applicable. Their existing CONFIRMED transfer classifications, payloads and source extents are unchanged. The English tree was not accessed. See [`keyboard_panel_tile_paths_20261022.md`](keyboard_panel_tile_paths_20261022.md).


## Japanese type/address asset filename census (10-pass snapshot; 2026-10-22)

At the 10-pass checkpoint, a lexical census of the Japanese `gfx/` tree found 1,859 files and no directory component named exactly `bankNN`. It initially found 107 address-only stems (`tiles_XXXX`, `tilemap_XXXX`, `attrmap_XXXX`, `palette_XXXX`) across 20 descriptive directories, spanning 216 physical files: 60 `.2bpp`, 60 `.png`, 29 `.tilemap`, 36 `.attrmap`, 21 `.screen.png` and 10 `.pal`. The 2026-10-22 Page List pass renamed three tile pairs whose maintained labels and static owner already identify them: `tiles_5810`, `tiles_6301` and `tiles_63e0` are now `page_list_tiles_5810`, `page_list_tiles_6301` and `page_list_tiles_63e0`. A following error-screen pass renamed the confirmed `NoAdapter_Gfx_8800_TailTiles` pair and the `NonCgb_Tilemap_Continuation_4060` map; the unreferenced HYPOTHESIS span `NonCgb_CandidateTileData_4240` is now explicitly candidate-qualified in its path. The browser-scrollbar pass aligned six further tile pairs with confirmed static consumers and VRAM0 destinations. The ConnectDialog pass aligned six loaded maps and one palette to their named static consumers; five maps have screen previews, while the forget-confirm map has no preview in this directory. The MailView pass aligned one confirmed 20x18 map/attribute pair to its existing symbol and static reader. The MailSession pass named the 240-byte tile slice and PNG from its existing CONFIRMED owner label and bounded transfer. The MailServer pass named the 1008-byte tail slice and PNG from its existing CONFIRMED label and parent transfer. The CommTimeHMS pass aligned one tile pair, a 20x18 tilemap/attribute pair, a palette and the screen preview with their existing owner labels; their prior PROBABLE/HYPOTHESIS statuses remain unchanged. All 53 renamed files across these eight passes preserve their original payload hashes. The Mailbox Profile pass named the PROBABLE object palette from its existing `Palette_Profile_Obj` label and static consumer. All 54 renamed files across these nine passes preserve their original payload hashes. The TextCursor pass named the PROBABLE 64-byte object-palette resource from its existing `Palette_TextCursor_Obj` label; the known static load requests 40 bytes, and the classification was not promoted. All 55 renamed files across these ten passes preserve their original payload hashes. That checkpoint's lexical inventory left 80 address-only stems across 9 directories and 161 associated files (46 `.2bpp`, 46 `.png`, 20 `.tilemap`, 28 `.attrmap`, 15 `.screen.png` and 6 `.pal`). These include 100 logical payload entries; 99 have `gfx/assets.tsv` rows (75 CONFIRMED and 24 PROBABLE), while the 15 screen previews are companion renderings and are not payload catalogue rows. The 16-byte `tiles_5860` byte-view is the one address-only payload without a catalogue row. The status counts are inherited catalogue evidence; the lexical scan did not revalidate each loader or visual role. The remaining files include previews and one byte-view pair, so absence from the payload catalogue does not make a file disposable.

| Directory at the 10-pass checkpoint | Address-only stems |
|---|---|
| `gfx/account/account_entry_mail_and_action_screens_bank5e/` | `palette_4d00`; `tilemap_4d40`, `tilemap_6000`, `tilemap_68d0`, `tilemap_75d0`; `tiles_4800`, `tiles_4c00`, `tiles_4e10`, `tiles_5210`, `tiles_57e0`, `tiles_5800`, `tiles_5c00`, `tiles_60d0`, `tiles_64d0`, `tiles_6ba0`, `tiles_6fa0` |
| `gfx/account/comm_panel_and_registration_delete_bank71/` | `tilemap_4c98`, `tilemap_4f68`, `tilemap_66c8`, `tilemap_6998`, `tilemap_6c68`; `tiles_4000`, `tiles_4300`, `tiles_4500`, `tiles_4890`, `tiles_5340`, `tiles_5740`, `tiles_5b40`, `tiles_5dc0`, `tiles_61c0`, `tiles_6440`, `tiles_6580` |
| `gfx/account/password_and_registration_config_bank5d/` | `tilemap_5b20`, `tilemap_6630`; `tiles_4800`, `tiles_4c00`, `tiles_5320`, `tiles_5720`, `tiles_5df0`, `tiles_61f0`, `tiles_63f0`, `tiles_6900`, `tiles_6c00`, `tiles_6e00` |
| `gfx/account/result_page_bank4b/` | `tiles_5080`, `tiles_5420` |
| `gfx/account/settings_menu_and_manual_confirm_bank4a/` | `tiles_5860` |
| `gfx/browser/page_list_candidate/` | `palette_6aa0`, `palette_6d70`; `tilemap_67d0`; `tiles_62b0`, `tiles_66b0`, `tiles_6ae0` |
| `gfx/comm/notice_dialog/` | `attrmap_4502`, `attrmap_47d2`, `attrmap_4aa2`, `attrmap_4d72`, `attrmap_5042`, `attrmap_5312`, `attrmap_55e2`, `attrmap_58b2`; `palette_6bc0`; `tiles_5a20`, `tiles_5e20`, `tiles_5fc0`, `tiles_5fd0`, `tiles_62f0`, `tiles_66f0`, `tiles_6890`, `tiles_68a0` |
| `gfx/keyboard/panels_bank5f/` | `palette_4cd0`, `palette_6bb8`; `tilemap_4810`, `tilemap_4ecb`, `tilemap_50d3`, `tilemap_52db`, `tilemap_54e3`, `tilemap_56eb`, `tilemap_69b0` |
| `gfx/settings/registration_delete_anim_and_password_save_confirm_bank71/` | `tilemap_6f6f` |

At that checkpoint, some remaining address-only basenames already had semantic catalogue or owner labels. For example, `palette_4d00.pal` still maps to `Palette_SharedEntryUi_Bg` (CONFIRMED). The TextCursor palette path was aligned to its existing `Palette_TextCursor_Obj` label while retaining PROBABLE status. The two `tilemap_4810` files in the keyboard folder have different source addresses despite sharing a stem. Candidate tiles `tiles_5080` and `tiles_5420` remain PROBABLE. Names alone do not establish consumer, extent or natural use; each rename still requires owner, catalogue, loader and destination reconciliation.

The tracked `gfx/account/settings_menu_and_manual_confirm_bank4a/tiles_5860.2bpp` and `.png` are intentionally retained as a byte-view outside the active graphics catalogue. Their 16-byte backing is the ROM range `4A:5860–4A:586F`, which overlaps the maintained cursor-frame OAM record, its animation script at `4A:5866`, and following zero bytes; it is not a tile resource. This prior reclassification is recorded in [`EDITING_IMAGES.md`](../EDITING_IMAGES.md). The old path is not grounds for deleting it during generic temp cleanup.

Historical `gfx/bankNN/...` paths in `gfx_resource_path_map.tsv` are migration provenance, not current directories. This census is lexical only and does not claim that the remaining stems are all wrong or unused; the next Japanese pass should resolve them from positive static ownership and readers, keeping candidate confidence explicit.

## Bank 4B candidate tile paths (2026-10-22)

The two probable result-page candidate tile spans at `4B:5080` and `4B:5420`
now have path names matching their existing candidate-qualified labels. Their
2bpp and exact PNG payloads are byte-identical to the pre-move manifest. This
reduced the 10-pass address-only filename census from 80 stems/161 files to 78
stems/157 files across eight directories; the 97 remaining address-only asset
rows comprise 75 CONFIRMED and 22 PROBABLE entries. This is a lexical path
count, not a semantic or runtime completion measure. The 5080/5420 labels keep
their PROBABLE level.


## Bank 7F browser prototype page-list candidate paths (2026-10-22)

Seven address-only payload paths in `gfx/browser/page_list_candidate/` now use
source-role names: three tile spans include their static VRAM destination and
VBK, the 20×18 BG tilemap and attribute map share a candidate-qualified name,
and the BG/OBJ palettes are identified by role. `PageListProto_InitScreen`
loads `7F:62B0` (64 tiles) and `7F:66B0` (18 tiles) to VRAM1 at `$9000` and
`$9400`, `7F:6AE0` (41 tiles) to VRAM0 at `$8000`, transfers the tilemap from
`7F:67D0`, and loads palettes at `7F:6AA0` and `7F:6D70`. These are positive
static source/consumer mappings in `engine/unreferenced/page_list_prototype.asm`
and `gfx/browser/page_list_candidate.asm`; they do not establish natural entry,
visible composition, or user-facing meaning. All seven catalog rows remain
PROBABLE. The ten moved files retain their raw hashes and payload hashes in
`.tmp/jp-page-list-candidate-paths-20261022/PRE_MOVE.json` and `POST_MOVE.json`.

The maintained Japanese GFX filename census after this pass is 72 address-only
stems in 7 directories and 147 associated files; 90 catalog rows remain (75
CONFIRMED, 15 PROBABLE). This lexical count is not a reachability or closure
claim.


## Bank 5D/5E account graphics path mapping (2026-10-22)

Twenty-eight address-only stems were renamed across the account Login ID, mail,
password, confirmation, and registration-write-config graphics folders. The
static owner/reader mapping supplies the resource family and VRAM/VBK roles;
all 34 payload catalog rows remain CONFIRMED, while their six associated screen
previews remain HYPOTHESIS. The shared `5E:4D00` BG palette is named
`shared_entry_ui_bg` because its source label and readers show broader reuse.
The `5E:75D0` map name explicitly means the branch selected when the variant
value is nonzero; it does not imply a particular nonzero value. The two `5D:5DF0`
and `5D:61F0` resources retain the plural `confirm_screens` because both are
shared by confirm and manual-confirm layouts.

The names preserve the exact backed-up extents. In particular, `5E:5210` has
768 bytes although its HDMA requests 1,024; `5E:6FA0` has 800 bytes for a
1,024-byte request; and `5D:6E00` has 512 bytes for a 1,024-byte request. They
were not expanded or reclassified. `5D:6C00` is the second half of the upload
starting at `5D:6A00` and maps to VRAM1 `$8A00`, so its filename includes
`slice` and the actual destination. Six generated screen previews remain
HYPOTHESIS: their cell coverage is incomplete, and the 5D confirm preview has
a signed/unsigned tie with different rendered tiles. Static path mapping does
not establish natural rendering or resolve those screen models.

All 61 raw files retained their pre-move hashes. Asset payload hashes and raw
file hashes are recorded in `.tmp/jp-account-5d5e-paths-20261022/PRE_MOVE.json`
and `POST_MOVE.json`; the old-to-new path ledger is in
`gfx_resource_path_map.tsv`. The maintained Japanese GFX filename census is now
44 address-only stems in five directories / 86 files, with 56 address-only
catalog rows (41 CONFIRMED / 15 PROBABLE). This is a lexical inventory, not a
reachability or semantic-completion claim.
