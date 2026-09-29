# Mobile Trainer (Japan) — reverse engineering / recompilable source

Goal: a reproducible RGBDS build that regenerates the original
*Mobile Trainer (Japan)* Game Boy Color ROM byte-for-byte, with code, data and
structures progressively identified and named.

* Reference ROM identity: [`docs/ROM_INFO.md`](docs/ROM_INFO.md), [`roms.sha256`](roms.sha256)
* Progress / evidence / open questions: [`REVERSE_ENGINEERING.md`](REVERSE_ENGINEERING.md)

## Building

The original ROM is **not** versioned. Put it in the repo root as
`Mobile Trainer (Japan).gbc` (SHA-256 in `roms.sha256`); `make` copies it to
`baserom.gbc` (git-ignored) and verifies the hash.

```
make            # assemble + link + byte-compare against the reference ROM
make regen      # regenerate src/*.asm from config/ (see tools/gen_asm.py)
make test       # exhaustive SM83 decoder round-trip test
```

Toolchain: RGBDS v1.0.3 (`rgbasm`, `rgblink`), Python 3.12, GNU make.
`rgbfix` is deliberately **not** run: the header (logo, checksums) is part of
the reproduced bytes.

## Layout

| path | purpose |
|---|---|
| `src/` | RGBDS sources, one file per 16 KiB bank, fixed addresses (offsets preserved) |
| `config/` | region map / symbol tables that drive `tools/gen_asm.py` |
| `tools/` | disassembler, generator, comparison and analysis scripts |
| `docs/` | ROM identification, memory map, research notes |
| `constants/` | hardware / RAM constant definitions |
