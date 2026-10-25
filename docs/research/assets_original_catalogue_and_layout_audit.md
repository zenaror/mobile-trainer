# Original asset catalogue and layout reference

| active type | files |
|---|---:|
| 2bpp tiles |405|
| RGB555 palettes |143|
| tilemaps / attributes |180 /180|
| font8x16 / font12 / font6x12 spans |27 /10 /1|
| SJIS validity bitmap |1|
| all |947|

## Editing views are conditional

There are 92 screens: 20 PROBABLE and 72 HYPOTHESIS. Twenty-two have some default palette words: 14 have no known palette words and 8 only partial loads. Palette slots follow the last load, as VRAM loads do. Pink/hatched cells are unresolved by the declared model, not proof that their ROM data is absent. The 88 tilemaps without an editing view also include pointer-driven, subrectangle and externally-loaded cases.

The 11 bank 41–46 gaps have a bounded cause. Eight windows —41:5AA0/67F0,42:5AA0,43:4D50/67F0,44:4D50,45:4D50,46:67F0— resolve 114 or 144 of 360 cells under 160 tiles→VRAM1:$8000 unsigned. Three other bank 42 windows 4000/4D50/67F0 resolve 360 under the whole ROM-window hypothesis, but the catalogue splits their tiles into fragments, inline bytes and padding. derive_records requires one 2560-byte tile asset; it does not combine those fragments. Reading all 2560 bytes as tiles remains HYPOTHESIS, without a proven loader. Two additional gaps47:4B00/65A0 are separate.

The editing model loads 160 tiles into VRAM1:$8000 unsigned.

The preview model loads 128 BG tiles into VRAM1:$9000/$9400, 32 OBJ tiles into VRAM0:$8000 and BrowserMenu3_Tiles0 (72:6C10) into VRAM1:$8800.

## Provenance and preserved negatives

Finite bank 53 consumer study 4c945020 and47:68F0 supplement 38e949cc keep mapping/reachability unknown.

An auditor initially compared intermediate palette loads, yielding six provisional colour differences for comm_time_summary_a. The next palette load overwrites those slots; final last-load-wins reproduces all 92 known PNG palettes. Scripts/logs/provisional results are preserved, not an asset defect. Initial own preview colour conversion floor(c*255/31) could differ one RGB level; exactRGB5 outputs use(c<<3)|(c>>2). A source-scan assertion initially conflated 343 ASM with 348 maintained sources; the latter includes five INC files. No gate was replayed.

Eight candidate-window editing views remain KEEP:41:5AA0,41:67F0,42:5AA0,43:4D50,43:67F0,44:4D50,45:4D50 and46:67F0. Original backing exists; complete justified VRAM placement and reversible editing are different questions. At42:5AA0,416B in26 chunks underlie38 cells without aligned imports:368B are already in the rephased5F92 catalogue asset and48B are `db`/`ds` outside it. Only the latter48B are a subset of the576B outside the catalogue. The246 unprovided U160 keys remain a separate limit. Across the25 windows, the current outside-catalogue tile bytes total2416B, versus2496B before the80B RAW representation. No storage is retyped or PNG added by these statements.

On published72a3464b, maintained source and the active catalogue/rules include the10-byte span7C:[57C3,57CD) between6083-byte and9135-byte spans, all sharing the existing846-cell `data/fonts/jis12x12_rows_25_33.png` sheet.

Current migrated editing-PNG links appear in the companion [address-only window table](assets_pokemon_frames_and_name_limits.md).
