# HelpScript picture records 01–26

## Scope and evidence

This source representation replaces the historical clipped tile leaves in banks60/61 with the 26 complete picture windows selected by `HelpScript_PictureTable` at6C:5F6E. The reader at6C:5E6E selects the five-byte record by `5 * (id - 1)`, reads its bank byte and two little-endian source words, uploads1152 tile bytes to VRAM0:$8800–$8C7F, and copies8 palette bytes into BG palette6. The setup supplies the sequential12×6 tile rectangle. This is a finite static consumer/format contract; it adds no proof that every ID is selected naturally or displayed on hardware. IDs27–31/bank5B are outside the asset unit and retain their original numerical fields. Out-of-range IDs remain unvalidated.

The old immediate-loader-only search missed this table. The former owner comments and inventory rows saying “no loader found” were incomplete; they are superseded by the positive reader above. Several clips cross actual picture boundaries, and the starts60:4455 and61:4F63 were misphased by5 and3 bytes. They must not be presented as independent picture objects.

## Representation and confidence

Two source owners remain pinned at their original banks, addresses and15080-byte extents: `gfx/help/script_illustrations_01_13.asm` in bank61 and `gfx/help/script_illustrations_14_26.asm` in bank60. Each has13×1152 tile bytes followed by13×8 palette bytes. The26 new editable grayscale PNGs are96×48 pixels,12×6 tiles, with no padding. Their embedded shade order converts directly to the original2bpp bytes. No screen tilemap/attribute editing row is fabricated.

The new source/catalogue role remains **PROBABLE**, while the original byte identity and finite table fields are directly checked. The old four HYPOTHESIS clip typings are retained in the historical range map, not silently promoted into natural-display claims. Structural picture IDs are used instead of assigning an unproved visual identity or tutorial purpose.

The active catalogue replaces22 tile leaves and2 grouped palettes (15312 logical bytes) with26 whole tile objects and26 individual palettes (30160 bytes). Exactly14848 image bytes already present inline become editable/catalogued. The complete picture payload is29952 tile bytes plus208 palette bytes. The active catalogue now has979 entries/622434 logical ROM bytes; there are408 tile-sheet PNGs,167 palette files and978 rules. Fonts, RAW views and95 conditional screen models are unchanged.

## Migration and labels

[`help_script_picture_resource_map.tsv`](help_script_picture_resource_map.tsv) maps every retired binary/palette byte to its new whole object and offset. This is a recomposition, so the former22 PNGs are replaced by26 whole-object PNGs; their PNG encodings and sheet geometry are not claimed to be unchanged. All original ROM indices/palette words are preserved. The direct path map keeps266 one-to-one rows, including the two new owner paths;46 former asset/PNG rename rows are superseded by the explicit range map. Frozen config, dated analysis and historical previews retain their own locators.

Thirty-eight generic owner labels and the redundant `Data_6C_5F6E` alias are retired after checking active sources/tools. The new52 labels name actual table-backed tiles and palettes. [`help_script_picture_label_map.tsv`](help_script_picture_label_map.tsv) records every retired label and its containing new object/offset. The first26 table records use `BANK` and `dw` operands for those new labels, and the indexing load uses `HelpScript_PictureTable`. The bank5B records stay byte-exact numeric data.

## Whole-object identities

| ID | bank:tile source | palette source | tile SHA-256 | palette SHA-256 |
|---:|---|---|---|---|
| 01 | `61:4000` | `61:7A80` | `c2cdc85693364d923dc0e9071f1b00b1bb1adf7af292ced07a30c1666889418a` | `fe4fdcf11148dc4f4b7c24dfa3bf47000272a7f78ceaeb21f189b61ead9bbfea` |
| 02 | `61:4480` | `61:7A88` | `accdada5931b2702cbb46b758a65a4895753b0a7ba40770a243ef2d18bb7c99b` | `58d9dd93b0190051457e382ce088ba53d49f016f5b1b2d05c4b58b39dcd71d8d` |
| 03 | `61:4900` | `61:7A90` | `a2b35c7f233112c1a179027c181ae4815c017b3ac3df207d9e6d2f3825206554` | `f871eabda6e36bf5c569702210a6494e07ac6f48488391eeef268dafdbcd0dba` |
| 04 | `61:4D80` | `61:7A98` | `f6cc64336edb824d40c0b68bd378e6fe5ab60019f59742fd74b27606ea4e6af2` | `a63849c5e0b28ebe683b424fdcce2872035b168415fb8c2d06e188667d86f5cf` |
| 05 | `61:5200` | `61:7AA0` | `5c803ec7a0a257aa689e9882f0e26fae7b4ee013691598ce5b85e56b3b268219` | `eac03f58ab42fea8363a3ddeef13a9a384ae5fb7fdf760767cc7af4f772ff93b` |
| 06 | `61:5680` | `61:7AA8` | `cee03c8cca5e89af520176e73254417f448607cdb0ec37d0305583bf9d5aa185` | `9373103aa7ab9c81dc0c1426d2866795602abecc3673ded228a00fd56c9fae16` |
| 07 | `61:5B00` | `61:7AB0` | `71ed22d2bace9adc06c282e7ce8cbc364f4440002843c002061fd876b24dfc0b` | `3d40db6a484406597c407615908ff799e595caf9da073fabd0f7badd4af6d984` |
| 08 | `61:5F80` | `61:7AB8` | `811ec663db8e4749ca6aa768151351adc6aef4e5c423ec43a1dfe6aaf46d1d67` | `fb941576a5d9e1678e26cc944567e9ac5828629949a46059c42fbbc036444ee8` |
| 09 | `61:6400` | `61:7AC0` | `10dd3a8aa44424782fbef1bf8a6ba674ab66f3f5a8e501299c27d5d3ab695539` | `d9c1beec200b16bc99077e129e91e1f66f5f8c437c854a9803a1afcce7331b6d` |
| 10 | `61:6880` | `61:7AC8` | `ca5b06a42f9cea0cf979792797f7064d256b7dbf7d27ff10c740bd0cc2e90f7b` | `d9c1beec200b16bc99077e129e91e1f66f5f8c437c854a9803a1afcce7331b6d` |
| 11 | `61:6D00` | `61:7AD0` | `0c652661faa9370202d8f8f242398248af4687337cec39076e4b09b8c54bf07b` | `3d40db6a484406597c407615908ff799e595caf9da073fabd0f7badd4af6d984` |
| 12 | `61:7180` | `61:7AD8` | `2c38b0aa84b6e9130ec7c8ce014543dbd5da9f6b88c59dcb5207632a41e5b8a9` | `5c8fd6a7670bb5efe69c9a55cc6be6e5b93899e9a3e1a8a39b86c3bda714d762` |
| 13 | `61:7600` | `61:7AE0` | `66ca50acbd2bfdddd00a008224330eb7318a7802b06117ea35267affe8aaa0bb` | `3d40db6a484406597c407615908ff799e595caf9da073fabd0f7badd4af6d984` |
| 14 | `60:4000` | `60:7A80` | `26ed045e94ba4970f70e1c1f0c8ef45574dabdd34baef9b1f8d559dc042bce93` | `b9796f334caf9acb8bf740f8cb667025543f557bfcafb7fb880263828da8b48e` |
| 15 | `60:4480` | `60:7A88` | `57c827e1e11c358c7f24a4a3f9a7f24bd2a4d6cedcf15a3eb9cd062849cdbd44` | `9793a2120fa44bc99d1908013b05b4b636d426993c760a8439eb3535eb3955e3` |
| 16 | `60:4900` | `60:7A90` | `644875430e360494f40844391e78b4546b1283030a991885d1313f77949a2772` | `9f250d1aa5078102654e86352e72e0f6ee4eaf166b1853687c54374b009b387c` |
| 17 | `60:4D80` | `60:7A98` | `519ce5d69df445963a9c3264c1274467dd44d436f4ea276bd47b72b973054166` | `0f8988926b625136cff7b11170a565c71960522a3b2d7c3783b1e44860650e2b` |
| 18 | `60:5200` | `60:7AA0` | `83c524d4a283c6c3ec1a895c1ec92a452838ec5687494f525a14416731e366d2` | `070efa35911217555d478f5c5ef0adcc0ae0302d085abf6461ea3f9155746168` |
| 19 | `60:5680` | `60:7AA8` | `85efce0eee13375c40f974b3e3453ff4525ac37872fc8ebbd254f37462ac8ab8` | `070efa35911217555d478f5c5ef0adcc0ae0302d085abf6461ea3f9155746168` |
| 20 | `60:5B00` | `60:7AB0` | `eb4a7c437eb9da9e52e3671652b7ca752c4636b9ccf0a7e84eaaed6b7fa22c17` | `3015c9f2c382c27f3994c48fe7f411762328f88ad073f7142e0b9ca8f6ae60f0` |
| 21 | `60:5F80` | `60:7AB8` | `9162669a1e86598b3e127be9e852744bf2e951f9aa8b28240759d151dad5bd1f` | `49374ff6871f77eb37a33a2daa274116e5da9ab3ff1615daa335fdd3e6d45b48` |
| 22 | `60:6400` | `60:7AC0` | `a6c71176315d89356f44a4c5f1b9f56604801f605aba981ece1f60adc8336bee` | `4ac418e4397057cd51863d34ac4a450a3e8163596870f1c858278d236c8f1088` |
| 23 | `60:6880` | `60:7AC8` | `9fd449da457271a6dce8c76a40269f72af70e807f3443bb4f74c71822103379b` | `8973fc8ec6b452b5fe10d9b4b884192cafc8bc2b3de83f1a7ed3784525088c74` |
| 24 | `60:6D00` | `60:7AD0` | `70d3729893b7ee1213d3419826ea91e4189eaf7e90828be3ce2eff2df657e71e` | `8973fc8ec6b452b5fe10d9b4b884192cafc8bc2b3de83f1a7ed3784525088c74` |
| 25 | `60:7180` | `60:7AD8` | `9f093ed3b7fd8ab73329c3ba9f2bfbda554e82d547f12015fa5e1932502203a1` | `97ae303482f1eccc635a88e275659ef5e55782213d3ea01425235ab0aca6051c` |
| 26 | `60:7600` | `60:7AE0` | `5db3317fd47a9004997350536da4e9dccba483497c5f82f409533546e367013f` | `4ec34d6517f798072d947790903b0296aabf5ce1d2b12c4f4bc3607786195ff8` |

## Validation boundary

This note accompanies a private proposal based on Japanese main `9c46d5512dbbf6b8f25bae201bb8e8ac0c046d13`. The private tree passed `make -j8` with `RESULT: IDENTICAL` and the original SHA-256, `make sym-check` (334 source files,14715 labels,51 constants), `make palette-check` (162 loads/116 arrays/two documented overreads/zero errors), `make png-check` (408 tile sheets/four RAW views/37 font sheets/95 screens), `gfx_export.py check` (979 assets) and `png_rules.py mk-check` (978 rules). The private receipt records source/asset hashes; integration still requires an independent review and the original-ROM comparison on the integrated tree. No English work or runtime execution belongs to this unit.
