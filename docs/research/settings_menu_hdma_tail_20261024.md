# Settings menu HDMA tail at bank 4A:51B0

## Finding

`4A:51B0–51CF` is confirmed as source data included in the settings menu's 1024-byte HDMA upload; this does not establish a palette table or dedicated palette read. `SettingsMenu_StateInit` at `68:50F5` supplies source `4A:4E40`, `C=$40` blocks, destination `VRAM bank 1:$9400`; `Gfx_StartHDMAWithService` at `00:0787` programs HDMA length as `(C * 16)` bytes and selects the VRAM bank from `E`. The call instruction is present in the existing coverage corpus (538 hits across 15 scenarios at `68:50F5`).

The candidate begins `$370` bytes after the upload source, so it lands at VRAM bank 1 `$9770–$978F`, two 16-byte 2bpp tile patterns. Source bytes at file offset `$1291B0` are `00 00 4A 29 B5 56 FF 7F`, repeated four times; their SHA-256 is `ab3a6e1e1965b057f262ee0e522792d3b416d50edbe66e1501a916c0854e80b3`. The full HDMA source window at file offset `$128E40`, length `$400`, hashes to `15b09fab6435ada9097b3b5e4a5c7c4b5d840f1eb789cf304dd1f5e3c3c0f76b`.

The two 20×18 tilemaps used by `SettingsMenu_DrawItems` contain neither `$77` nor `$78`. The first 20 tile-index bytes of the five 2×5 cursor-overlay records at `4A:5770, 5798, 57C0, 57E8, 5810` contain neither value; the cursor OAM records use tile indices `$00` and `$10`. Under signed BG tile-data addressing, `$77/$78` resolve to VRAM `$9770/$9780`. This bounds the finding to the inspected screen and cursor records; it does not prove global non-use, explain why the two patterns are loaded, or establish palette-slot assignment. Keep the purpose HYPOTHESIS.

## Provenance and limits

- ROM: `Mobile Trainer (Japan).gbc`, 2,097,152 bytes, SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570` (matches `roms.sha256`). Bank 4A maps at file offset `$128000`.
- Source: `engine/account/settings_menu.asm` (`SettingsMenu_StateInit`, `SettingsMenu_DrawItems`, `SettingsMenu_UpdateCursorSprite`) and `home/gfx_upload.asm` (`Gfx_StartHDMAWithService`).
- Tilemaps: `gfx/account/settings_menu_and_manual_confirm_bank4a/settings_menu_4a_51d0.tilemap`, file offset `$1291D0`, SHA-256 `88120297c77700e9f9dfebf02496ad4e194a9a8daa23d74a5e3b2488b674e4b0`; `settings_menu_flag_set_background.tilemap`, file offset `$1294A0`, SHA-256 `cfa744483e04bd4307fb11dd0e35130a406f15ec0bcb4ae5b0d9eed626b5dd28`. The five 40-byte overlay records at file offsets `$129770, $129798, $1297C0, $1297E8, $129810` have SHA-256 values `65f33db8a15f3c1cecec7e5c89110cab0767d26ee1bf346f120152c1781f1cc8`, `6b68d0f73610c16f246bbc2681608e0f34595e5bf6789716aecd1a756d1b51c5`, `e2249ee8eee3aaf4fa24d25e0115668073b0e5623dc9a1995d8c186b2a4b88b8`, `c23757d3c5a16f9f72c102010512a2fc3a24a1ce30c96b3606400f8fe65baae6`, and `5f2996e577079a8401c3a3d4536221c758bf5106eef0f8830e1ca1d9fd1f1648` in that order.
- This is static source/original-byte plus existing scenario-coverage evidence. It is not a new visual, emulator, hardware, or global reachability claim.
