# ROM pointers inside blocks and in front of data lines (romop2): 61 operands, 16 new labels, the offset form `Label + $offset` (ROM unchanged)

Second pass over the raw ROM pointers `ld hl|de|bc, $XXXX` ([`naming2_romop1.md`](naming2_romop1.md) did the pointers that are exactly a label).  romop2 writes the pointers that point **into** a block or at the start of a data line that no label starts: a neutral label in front of the > data (`String_2A_4A6F`, `Palette_71_66C0`) or `Label + $offset`; it also writes the inline word of the far call to the palette copier as a label (`dw CopyBytes`).

## 2. What romop2 adds to the rules

The rules file has six columns: consumer, register, bank kind, **data** (palette, tiles, tilemap, string, data, table or `-`), **length** (`bc`, `de`, `b`, `c16`, `rowscols`, `rowscols2` or `-`) and the proof.  The length is what the routine reads, from the constants before the call (`ld bc, $0018`, `ld c, $30`, `ld bc, $0A14`).
The checks, all of which refuse and count instead of guessing:

* the read must be **proven**: every register of the length is a constant (a call, a loop, `ld c, a`, `inc`, `dec`, a shift, a macro that clobbers BC, a conditional skip or a join after a local label makes it unknown); a count of 0 is not "no bytes" (the copy loops count down before they test; `CopyBytes` with BC = 0 copies 256 bytes) and is refused;
* every line of the read, from the line that holds the pointer to the line that holds the last byte, must be data of that kind: an asset of that type (`gfx/assets.tsv`) or an untyped `db` / `ds` line; code, a macro, a `dw` table or an asset of another type refuses (`block kind` for the first line, `read crosses` for a later one);
* the read ends inside the bank (`$8000`, `$4000` for bank 0); an HDMA source is on a 16-byte tile; the Ptr tilemap routine reads the tile half here and the attribute half from its own pointer, so its read must stay in the `.tilemap` half;
* the **anchor** of an offset is the nearest label that is on the unit of the data (16 bytes for tiles, 8 for palettes): a label that cuts a tile or a palette is passed over (`Data_22_5CEA + $4E6`, which hid that the address is tile-aligned, became `Gfx_AddrBook_TilesBank22 + $500`);
* a tile sheet label that states its VRAM address (`...Tiles9400Vb1`) is the anchor of a window only when the call loads exactly that destination (`de` and the offset): `Gfx_Registration_Delete_Tiles9400Vb1 + $3C0` loads to `$8801`, so the label named another load of the sheet and the 15 such windows stay numeric;
* a new neutral label in front of a data line needs the form of the data: a string a `db` line, a table a `dw` or `db` line, data a `db`, `dw` or `ds` line; for palette, tile and tilemap data the same read check as an offset runs from the start.

The rule applies to what was found and no more: `Palette_LoadToBuffer` (HL, length BC), `Gfx_StartHDMA` and its variants (HL, C blocks of 16 bytes), `Tilemap_CopyRectAndAttrPtr` (HL, B x C), `TextTiles_RenderLine` and `Grid` (HL, a string that ends at its NUL) and `CopyBytes` (HL, BC) are the consumers with a data kind.

## 3. The inline word

`call FarCall_Inline16` (`00:06BC`) reads the word that follows the call as the address of the routine to run and takes the bank of the far call from `hFarBank`; at `4F:4008` (`Palette_LoadToBuffer`) the word was `$050C`, now `dw CopyBytes` (`CopyBytes` is the only name at `00:050C`, it ran 65,777 times in 69 scenarios; this is the only `call FarCall_Inline16` of the ROM, so no other site was left alone).
The bank of the far call is the bank of the **data** that `CopyBytes` reads; a pointer below `$4000` in the word needs no bank.

## 4. What stays numeric

* 22 palettes and tilemaps that lie **inside blocks typed as tiles** (11 blocks of `gfx/account` and `gfx/settings`, and the four wrongly typed blocks `Data_4D_5510`, `Palette_Account_ConfirmScreen_Bg`, `Palette_Account_ConfirmManualScreen_Bg`, `Tilemap_ConnectDialog_ConnectConfirm_56_526A` that the earlier notes list): in each the HDMA request copies a whole blob of 1,024 bytes into
  VRAM, tiles followed by a palette and a tilemap, so the sheet and its PNG carry a few non-tile "tiles" at the end.  They need the **graphics retyping** (split the `INCBIN`, `gfx/assets.tsv`, `make png-check`), which is a separate front; the rows are in the report of the tool (`--report`).
* `Palette_4B_5870` (`engine/account/result_page.asm`): the 40-byte read starts in a `db` line and runs on into `tiles_5878.2bpp`, a block typed as tiles whose bytes are four more palettes: refused (`read crosses`) until that block is retyped.
* 15 HDMA windows whose sheet label states another VRAM destination (above); 2 operands with no label; 3 vectors; the rest has no rule or no proven length.
* The label `Palette_71_66C0` is true (8 bytes, `7C00 7FFF 01FF 001F`) but the block it splits still carries heuristic headers (`data $66A0-$66C1`, `tiles-2bpp $66C1-$66C8`): a comment above it says so; the retyping of `gfx/account/screens_bank71.asm` will make one palette array of `$6688-$66C8`.

**Since the graphics retyping** (`naming2_retype1.md`): the 22 palettes and tilemaps inside blocks typed as tiles, the four wrongly typed blocks, `Palette_4B_5870` and `Palette_71_66C0` are retyped; 25 operands became exact labels (23 by this tool); what stays numeric is 14 `anchor names another destination`, 2 `no label`, 1 `read crosses` (`engine/settings/confirm_screen.asm:42`), 3 `vector null` and the operands with no rule.
