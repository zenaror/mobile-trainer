# HelpScript picture records 01–26

The reader at6C:5E6E selects the five-byte record by `5 * (id - 1)`, reads its bank byte and two little-endian source words, uploads1152 tile bytes to VRAM0:$8800–$8C7F, and copies8 palette bytes into BG palette6.

## Representation and confidence

Two source owners remain pinned at their original banks, addresses and15080-byte extents: `gfx/help/script_illustrations_01_13.asm` in bank61 and `gfx/help/script_illustrations_14_26.asm` in bank60. Each has13×1152 tile bytes followed by13×8 palette bytes. The26 new editable grayscale PNGs are96×48 pixels,12×6 tiles, with no padding. Their embedded shade order converts directly to the original2bpp bytes. No screen tilemap/attribute editing row is fabricated.

The active catalogue replaces22 tile leaves and2 grouped palettes (15312 logical bytes) with26 whole tile objects and26 individual palettes (30160 bytes). Exactly14848 image bytes already present inline become editable/catalogued. The complete picture payload is29952 tile bytes plus208 palette bytes. The active catalogue now has979 entries/622434 logical ROM bytes; there are408 tile-sheet PNGs,167 palette files and978 rules. Fonts, RAW views and95 conditional screen models are unchanged.

## Migration and labels

The first26 table records use `BANK` and `dw` operands for those new labels, and the indexing load uses `HelpScript_PictureTable`.
