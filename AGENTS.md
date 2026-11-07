# Mobile Trainer

This repository contains a byte-accurate RGBDS reconstruction of **Mobile Trainer (Japan)** for Game Boy Color. It is a disassembly, not a rewrite.

## Source and build

- Maintained assembly and assets are in `home/`, `engine/`, `lib/`, `data/`, `gfx/`, `audio/` and `ram/`.
- Read [INSTALL.md](INSTALL.md) to set up RGBDS and build. The default `make` target builds the Japanese ROM; `make english` builds the existing English overlay.
- After source changes, run `make` and `make sym-check`; when the original ROM is available, require `RESULT: IDENTICAL`.
- `tools/gen_asm.py` and `config/` describe the frozen bootstrap process. Do not run `make regen` against the maintained source.

## Reverse-engineering conventions

- Treat the original ROM as immutable. It is not distributed in this repository.
- Use `CONFIRMED`, `PROBABLE` and `HYPOTHESIS` in source comments. Keep neutral names such as `Function_<bank>_<address>` or `Data_<bank>_<address>` when evidence does not support a more specific name.
- Interpret addresses in their bank context and distinguish code from data. A matching build proves byte identity, not semantic understanding or runtime behavior.
- See [STYLE.md](STYLE.md) and [the documentation index](docs/README.md) for public project conventions and references.
