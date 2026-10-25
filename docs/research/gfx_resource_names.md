# Descriptive graphics resource paths

This path migration replaces 235 generic graphics file paths: ten grouped ASM owners, 142 active asset files and 83 existing PNGs. It preserves the ten bank/address extents, all generic global aliases, the 142 original asset statuses and lengths, and all 95 screen model qualifiers. No image, loader, species association or whole-ROM completeness claim is added. The project instruction remains: “É uma reconstrução, não uma reescrita.”

The page-list prototype message resource has a positive static consumer: `PageListProto_ShowMessage` at 7F:591E selects 40-tile loads from 52:4080/4380/4680/4980 into VRAM1:9580. This does not prove a natural entry. Logo/window art names in5B remain locally qualified. The later [HelpScript picture recovery](help_script_picture_assets.md) supersedes the immediate-loader-only interpretation of banks60/61: a positive table consumer identifies26 complete1152-byte picture windows and their palettes. Whole-object IDs replace the arbitrary clips; no natural display or purpose beyond the static consumer is asserted.

The four RAW backings retain their exact 80 bytes, hashes, extents and raw/HYPOTHESIS status. Their physical design prefix groups files; the explicit byte codec and its two conditional models remain scoped in `raw_png.py`. A byte view does not establish original tile purpose. Fragment alignment and PNG sheet padding still limit import; the 2,416 bank42 bytes outside the active catalogue remain exact inline source.

Paired tile/raw PNGs keep the binary basename; editing views keep the tilemap basename with `.screen.png`. Attribute maps are explicit fields in the catalogue and need not share the tilemap basename. All original PNG bytes are copied unchanged. `assets.tsv`, `screens.tsv`, `png_rules.tsv`, `png.mk`, INCBIN/INCLUDE paths, SECTION/layout strings and the RAW allowlist migrate together. `pnglib` reads PNG bytes rather than filenames; `test_png` uses rule/screen paths and copies the graphics tree, so neither requires a filename-specific behavior change.

The Japanese label review subsequently qualified all bank41/43/44/45/46
frame-design resource symbols as `FrameDesignCandidate_*`, tied to their
filename-derived motifs. This removes type/address-only names without
claiming natural screen use. Static consumers also support resource names for
bank58 Notice graphics, the first three bank47 browser-frame packages, the
page-list slices, and help-script picture tiles in bank5B. See
`gfx_generic_name_audit_20261021.md` and
`original_closure_followup_20261021.md`; unresolved bank47 package4 and bank7F
source ranges remain explicitly candidate/unresolved.
