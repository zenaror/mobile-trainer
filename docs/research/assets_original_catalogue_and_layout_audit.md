# Original asset catalogue and layout audit

## Scope and evidence

This documentation-only audit starts from published 88b4bca2665b96b77b941b18c19f802fc499276c. Its fresh clone already passed ROOT make/compare/symbol/palette validation; this pass runs no new build or gates. Own stdlib scripts read the private original ROM (SHA-256 6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570), active catalogues and PNG bytes without importing or executing repository helpers, native captures or the ROM. New image files below are explanatory outputs and are not build inputs. No new natural/forced/hardware evidence or semantic alias is added.

| active type | files |
|---|---:|
| 2bpp tiles |405|
| RGB555 palettes |143|
| tilemaps / attributes |180 /180|
| font8x16 / font12 / font6x12 spans |27 /10 /1|
| SJIS validity bitmap |1|
| all |947|

All 947 assets reemit 607,576 original-ROM bytes. Palette text was independently reemitted as little-endian RGB555; all other assets match their ROM slice directly. This tests active catalogue identity, not classification of every ROM resource. Retired bank73 tile/palette guesses remain historical files outside the active catalogue. The rules contain 946 rows, 443 editable rows and 442 unique PNGs; 38 font binaries share 37 font sheets. Own PNG decoding reproduces every stored tile/font bit, and all 92 screen index vectors/resolved counts plus final known palette words. The bitmap view is present but not an editable source.

## Editing views are conditional

There are 92 screens: 20 PROBABLE and 72 HYPOTHESIS. Twenty-two have some default palette words: 14 have no known palette words and 8 only partial loads. Palette slots follow the last load, as VRAM loads do. Pink/hatched cells are unresolved by the declared model, not proof that their ROM data is absent. The 88 tilemaps without an editing view also include pointer-driven, subrectangle and externally-loaded cases.

The 11 bank 41–46 gaps have a bounded cause. Eight windows —41:5AA0/67F0,42:5AA0,43:4D50/67F0,44:4D50,45:4D50,46:67F0— resolve 114 or 144 of 360 cells under 160 tiles→VRAM1:$8000 unsigned. Three other bank 42 windows 4000/4D50/67F0 resolve 360 under the whole ROM-window hypothesis, but the catalogue splits their tiles into fragments, inline bytes and padding. derive_records requires one 2560-byte tile asset; it does not combine those fragments. Reading all 2560 bytes as tiles remains HYPOTHESIS, without a proven loader. Two additional gaps47:4B00/65A0 are separate.

The two models are not interchangeable. The editing model loads 160 tiles into VRAM1:$8000 unsigned. The preview model loads 128 BG tiles into VRAM1:$9000/$9400, 32 OBJ tiles into VRAM0:$8000 and BrowserMenu3_Tiles0 (72:6C10) into VRAM1:$8800. Coverage chooses a mode; it is not an observed LCDC value. Some maps/attrs violate an unconditional “allbank 1/allindex<160” claim. The 24 old preview metadata rows have best_capture='-' and their loaded pixels match the chosen conditional model. The suggestion that accidental capture selection caused those 24 images is refuted by those current rows; it remains a general tool risk, not an established defect here.

## Provenance and preserved negatives

Own sealed private audit 8c817094 includes 653 explanatory PNGs (405 literal grayscale tile extractions, model comparisons, palettes and contacts), not a new build or 671-output gate. Finite bank 53 consumer study 4c945020 and47:68F0 supplement 38e949cc keep mapping/reachability unknown. Their results are qualified in the companion note. ROOT independently read guarded stage data; future documentation adoption/publication is separate.

An auditor initially compared intermediate palette loads, yielding six provisional colour differences for comm_time_summary_a. The next palette load overwrites those slots; final last-load-wins reproduces all 92 known PNG palettes. Scripts/logs/provisional results are preserved, not an asset defect. Initial own preview colour conversion floor(c*255/31) could differ one RGB level; exactRGB5 outputs use(c<<3)|(c>>2). A source-scan assertion initially conflated 343 ASM with 348 maintained sources; the latter includes five INC files. No gate was replayed.

Inherited local 2B case headers still carry 141-byte prefix wording, qualified by the corrected complete 158-byte root header and notes. This asset documentation pass does not edit them. The account 4A highlight header correction is a separate bounded future source change. No tool, source, asset, rule, layout or frozen metadata mutation belongs to this pass.

## Final finite baseline reconciliation (2026-10-15; source8dee0a63)

The reviewed published-source snapshot `8dee0a6342c5c9b7a9b06e35444c309bdc5b0195` has951 active asset rows,607656 emitted original-ROM bytes in62 banks. Each row has one maintained Japanese `INCBIN` or palette `INCLUDE`, its declared owner/size, a nonoverlapping declared ROM interval and original-exact bytes. All143 textual palettes were independently parsed as RGB555. This is the finite active catalogue, not proof that no other ROM bytes have a graphical role. The older947/607576 snapshot above remains historical: the difference is four raw/HYPOTHESIS byte-view assets totalling80B, with UNKNOWN original purpose.

There are950 PNG rules:447 PNG-backed outputs share446 editable sheets, while503 rules have no PNG. Palette-rule sizes are text-file sizes and their hashes represent emitted RGB555 bytes. The current95 screen rows resolve26631 of30704 cells under their declared models:41 complete rows and54 partial, with resource references and slice bounds checked. The852 original-tree PNGs partition into446 editable sources,95 screen views,one validity-bitmap view,309 separate previews/evidence PNGs and one retired historical PNG. The retired bank73 tile/palette interpretations remain inactive files. The other282 English PNGs and11 research illustrations were counted separately, not audited for their content. None of these counts is a global display, inverse-conversion or semantic-completeness claim.

The companion [frame/name reconciliation](assets_pokemon_frames_and_name_limits.md#final-finite-frame-name-and-png-reconciliation-2026-10-15-source8dee0a63) gives an address-only25-window PNG inventory. All25 physical windows retain85200 original bytes. Their39 tile sheets and four RAW sheets reemit their physical asset bytes;17 existing editing PNGs match391680 indices/RGB and24 legacy-unused previews match552960 RGB pixels under their distinct conditional models. The fourth bank47 window68F0 has an editing view at map72F0 but is outside that24-preview family. No bank53 name-index/species assignment follows from order, matching counts, filenames or visual resemblance.

Eight candidate-window editing views remain KEEP:41:5AA0,41:67F0,42:5AA0,43:4D50,43:67F0,44:4D50,45:4D50 and46:67F0. Original backing exists; complete justified VRAM placement and reversible editing are different questions. At42:5AA0,416B in26 chunks underlie38 cells without aligned imports:368B are already in the rephased5F92 catalogue asset and48B are `db`/`ds` outside it. Only the latter48B are a subset of the576B outside the catalogue. The246 unprovided U160 keys remain a separate limit. Across the25 windows, the current outside-catalogue tile bytes total2416B, versus2496B before the80B RAW representation. No storage is retyped or PNG added by these statements.

The25-entry bank53 table independently reemits50 pointer bytes plus319 string bytes,369B total using the maintained charmap. This closes that known block, not all names in the ROM. The separate27 selector words and five31B descriptors reemit209B and select three bank47 resource sets, encoding no bank53 name pointer/ordinal. Names, selector rows, descriptors, candidate windows and preview/editing models remain distinct structures.

A separate positive audit identifies an editable font gap outside the951-row baseline:7C:[57C3,57CD),10 original bytes and80 pink/UNSTORED pixels in the existing846-cell JIS sheet, split8/72 across slots337/338. The two existing font binaries sum15218B rather than the continuous15228B font body. All121744 stored glyph pixels match original bits. Adding the third span and completing those80 known pixels is a separate correction; it was not adopted in this audited baseline and no future952/607666 count is substituted here.

Reviewed provenance: global `REPORT.json` SHA-256 `9acfb056aa30b01894e6b1a10e6ead7579e2210626e9e27585261c930c44fb1e`; frame `REPORT.md` `faf8dab88ccbb5d9e42ec2a9e9c581c372edfa0f67aaf21c0a02d8ec192cf661`; bank53 V2 `REPORT.md` `0bf1d95a19d860f1ef2343c09c21635bdb3cd88a75ceca6469d5f2f6c8c0b5b2`; font7C `REPORT.md` `abee5223b4ef7be54a3ccf7db8b32ea0c088ee3ae77532871f7295782023d547`. The global reader's initial EN293 assertion was corrected before sealing to282 English plus11 research PNGs; bank53 V2 corrected the416B/576B wording without changing inventory evidence. These DATA-reader errata are not source/asset failures or gate replays.

CONFIRMED covers finite bytes, paths and the scoped representation checks. Conditional composition and context remain qualified; no new natural loader, LCDC/VBK/VRAM reaching state, E7 full-path persistence, species association, rendering/hardware observation or ALL completeness follows. Historical dated findings remain intact. This documentation reconciliation runs no build/gate, regeneration, caller hunt, emulator, PNG export/import or English work.
