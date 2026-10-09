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
