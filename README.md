# Mobile Trainer (Japan) — reverse engineering / recompilable source

Goal: a reproducible RGBDS build that regenerates the original
*Mobile Trainer (Japan)* Game Boy Color ROM byte-for-byte, with code, data and
structures progressively identified and named.

* Reference ROM identity: [`docs/ROM_INFO.md`](docs/ROM_INFO.md), [`roms.sha256`](roms.sha256)
* Progress / evidence / open questions: [`REVERSE_ENGINEERING.md`](REVERSE_ENGINEERING.md)

## Building

The committed `src/` is self-contained: `make` needs only RGBDS 1.0.3 and GNU make. It links the ROM and
checks its SHA-256 against `roms.sha256`; if the original ROM is present (as
`Mobile Trainer (Japan).gbc`, git-ignored, copied to `baserom.gbc`) it also does a byte-for-byte comparison.

```
make                 # assemble + link src/, SHA-256 check (+ byte compare if the reference ROM is present)
make regen           # regenerate src/ from baserom.gbc + config/ (tools/gen_asm.py; needs the ROM)
make verify          # regenerate into a temp dir and prove it rebuilds the reference ROM
make test            # decoder / explorer / generator self tests
make progress        # rewrite docs/PROGRESS.md
```

`src/` is generated from `config/` (regions, symbols, RAM names, xrefs, conventions; see `docs/FORMATS.md`).
Naming and classification changes are made in `config/` and re-generated; the generator refuses to write
unless the result is byte-identical. `rgbfix` is deliberately not run: the header is part of the reproduced bytes.

## Layout

| path | purpose |
|---|---|
| `src/` | RGBDS sources, one file per 16 KiB bank, fixed addresses (offsets preserved) |
| `config/` | region map / symbol tables that drive `tools/gen_asm.py` |
| `tools/` | disassembler, generator, comparison and analysis scripts |
| `docs/` | ROM identification, memory map, research notes |
| `constants/` | hardware / RAM constant definitions |
