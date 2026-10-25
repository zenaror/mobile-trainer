# Bank 70 communication-scene graphics path reference

## Conservative basename plan

The table gives proposed basenames within `gfx/comm/comm_scene/`; extensions
remain unchanged and each `.png` follows its `.2bpp` source.

Static transfer arguments are in `engine/comm/comm_scene.asm:652–720`;
the text-box pointer table is `gfx/comm/comm_scene.asm:9–18`, and the loader is
`engine/comm/comm_scene.asm:1055–1074`. `home/gfx_upload.asm:52–85` establishes
VRAM-bank selection and block length; its rectangle-pair copier at `300–340`
explains the second `$400`-offset attribute pass. The fixed owner section remains
at `layout.link:727–731`; basename-only changes need no section or caller change.

If these basenames are migrated later, update all six Japanese references:
`gfx/comm/comm_scene.asm`, `gfx/assets.tsv`, `gfx/png_rules.tsv`, `gfx/png.mk`,
`gfx/screens.tsv`, and the generated catalog in `gfx/README.md`. The PNG build
rules are generated from `tools/png_rules.py`; preserve that ownership. Do not
rewrite the stale line references in `gfx/previews/screen_ops.tsv` as loader
evidence.

The `tiles_vram1_9400_prefix` name deliberately reflects the 512-byte source file, not the full 1,024-byte DMA read.

The full build and relevant graphics gates must pass before equivalence or
completion is claimed. The paused English tree and ZIP inputs remain outside
this work; whether any language overlay references the old paths is still
UNKNOWN and requires a later, explicit authorization to resume that work.
