# Bank 4B notice-header graphics sources at 6590 and 6810

Date: 2026-10-23. Original reference: `Mobile Trainer (Japan).gbc`, 2 MiB, SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.

## Classification and evidence

The former `4B:6590..6A90` DB block is two descriptor-selected, contiguous 640-byte windows.
`Notice_LoadHeaderGfx` at `65:4A37` computes `3*A` into the 24-entry table at `65:4A81`;
descriptor `$14` contains source `$6590`, bank `$4B`, and descriptor `$15` contains `$6810`, bank
`$4B`. The loader requests `$28` HDMA blocks (40 × 16 = 640 bytes) to VRAM bank 1 at `$9300`.
These are static source/destination contracts; the natural selection of either descriptor is not
established.

Each source independently decodes to 40 Game Boy 2bpp tiles in a 10×4 sheet (80×32 pixels).
The pixel arrangement forms Japanese notice-header artwork. The sheet dimensions, indexed palette
order, and pixel indices were compared to the existing descriptor `$16`/`$17` Bank 71 PNGs.
Both PNGs were rebuilt to `.2bpp` through `rgbgfx -c embedded`; each output matched its source
640-byte file exactly. Each binary was extracted from the original-ROM offsets and matched the
former 1,280-byte source DB span byte for byte.

The manually maintained source now includes two owner-qualified assets:

- `Notice_HeaderGfxSourceDescriptor14_6590`: `4B:6590..6810`, 640 bytes.
- `Notice_HeaderGfxSourceDescriptor15_6810`: `4B:6810..6A90`, 640 bytes.

This establishes data format and header-art character, not a complete message transcription, screen
composition, natural runtime use, or hardware behavior.
