# Settings menu HDMA tail at bank 4A:51B0

## Finding

`4A:51B0–51CF` is confirmed as source data included in the settings menu's 1024-byte HDMA upload; this does not establish a palette table or dedicated palette read.

`SettingsMenu_StateInit` at `68:50F5` supplies source `4A:4E40`, `C=$40` blocks, destination `VRAM bank 1:$9400`; `Gfx_StartHDMAWithService` at `00:0787` programs HDMA length as `(C * 16)` bytes and selects the VRAM bank from `E`.

The candidate begins `$370` bytes after the upload source, so it lands at VRAM bank 1 `$9770–$978F`, two 16-byte 2bpp tile patterns.

The two 20×18 tilemaps used by `SettingsMenu_DrawItems` contain neither `$77` nor `$78`. The first 20 tile-index bytes of the five 2×5 cursor-overlay records at `4A:5770, 5798, 57C0, 57E8, 5810` contain neither value; the cursor OAM records use tile indices `$00` and `$10`. Under signed BG tile-data addressing, `$77/$78` resolve to VRAM `$9770/$9780`. This bounds the finding to the inspected screen and cursor records; it does not prove global non-use, explain why the two patterns are loaded, or establish palette-slot assignment. Keep the purpose HYPOTHESIS.
