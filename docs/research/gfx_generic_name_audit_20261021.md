# Static GFX generic-name reference

The Mailbox Profile pass named the PROBABLE object palette from its existing `Palette_Profile_Obj` label and static consumer.

The TextCursor pass named the PROBABLE 64-byte object-palette resource from its existing `Palette_TextCursor_Obj` label; the known static load requests 40 bytes, and the classification was not promoted.

The 16-byte `tiles_5860` byte-view is the one address-only payload without a catalogue row.

For example, `palette_4d00.pal` still maps to `Palette_SharedEntryUi_Bg` (CONFIRMED).

The TextCursor palette path was aligned to its existing `Palette_TextCursor_Obj` label while retaining PROBABLE status.

Candidate tiles `tiles_5080` and `tiles_5420` remain PROBABLE.

The tracked `gfx/account/settings_menu_and_manual_confirm_bank4a/tiles_5860.2bpp` and `.png` are intentionally retained as a byte-view outside the active graphics catalogue. Their 16-byte backing is the ROM range `4A:5860–4A:586F`, which overlaps the maintained cursor-frame OAM record, its animation script at `4A:5866`, and following zero bytes; it is not a tile resource. This prior reclassification is recorded in [`EDITING_IMAGES.md`](../EDITING_IMAGES.md). The old path is not grounds for deleting it during generic temp cleanup.

## Bank 4B candidate tile paths

The two probable result-page candidate tile spans at `4B:5080` and `4B:5420` now have path names matching their existing candidate-qualified labels.

## Bank 7F browser prototype page-list candidate paths

Seven address-only payload paths in `gfx/browser/page_list_candidate/` now use source-role names: three tile spans include their static VRAM destination and VBK, the 20×18 BG tilemap and attribute map share a candidate-qualified name, and the BG/OBJ palettes are identified by role.

`PageListProto_InitScreen` loads `7F:62B0` (64 tiles) and `7F:66B0` (18 tiles) to VRAM1 at `$9000` and `$9400`, `7F:6AE0` (41 tiles) to VRAM0 at `$8000`, transfers the tilemap from `7F:67D0`, and loads palettes at `7F:6AA0` and `7F:6D70`.

## Bank 5D/5E account graphics path mapping

The static owner/reader mapping supplies the resource family and VRAM/VBK roles; all 34 payload catalog rows remain CONFIRMED, while their six associated screen previews remain HYPOTHESIS.

The shared `5E:4D00` BG palette is named `shared_entry_ui_bg` because its source label and readers show broader reuse.

In particular, `5E:5210` has 768 bytes although its HDMA requests 1,024; `5E:6FA0` has 800 bytes for a 1,024-byte request; and `5D:6E00` has 512 bytes for a 1,024-byte request.

## Bank 4A legacy sprite-byte view path

It is a retained byte-view of two OAM frames, a two-step animation script, and five trailing zero bytes at `4A:5860–5870`, not tile art or an active asset.
