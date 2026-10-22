# Browser graphics asset paths (2026-10-21)

## Result

Renamed 24 files in the Japanese browser frame packages under `gfx/browser/frames_0_1/` and `gfx/browser/frames_2_3/`. Address-only basenames now identify the scrollbar candidate slice, browser frames 0–2, or explicitly candidate frame-3 resources. Both assembly owners, `gfx/assets.tsv`, `gfx/screens.tsv`, the generated graphics README, and generated PNG rules were updated. The classification of the unselected frame-3 resources remains candidate/PROBABLE; this path cleanup does not claim that frame 3 is naturally selected.

The source owners contain the three frame-block descriptors with pointers to the tile, map, and palette spans for frames 0–2. Executed-code evidence reads the full second and third blocks in named scenarios; the division into tile/map/palette pieces retains its existing PROBABLE status. No loader reference was established for the standalone 64-byte scrollbar candidate slice. The existing confidence values and source comments are unchanged.

## Integrity and validation

SHA-256 was computed for each of the 24 files before the rename and matched after it. No payload bytes changed. The rebuilt Japanese ROM remains byte-identical to the reference. Both affected whole-screen PNGs pass the reversible render/import check; all tile PNG, font PNG, palette-read, symbol, graphics-catalog, and generated-rule checks pass.

Evidence limits: descriptor pointers and executed block reads support resource identity and bounded reads; they do not prove a frame-3 selection, device display, or a complete runtime route for the standalone candidate slice.
