# Installation

To build the ROM you need two things: **RGBDS 1.0.3** and **GNU make**.  Nothing else is required: no Python, no reference ROM, no
graphics tools (`rgbgfx`, shipped with RGBDS, is only needed if you want to regenerate `.2bpp` files from the PNGs under `gfx/`; the committed `.2bpp` binaries are what the build uses).  (Python 3.12 is only needed for the optional tools in `tools/`: `make test`, `make sym-check`, `make compare`, the analysis scripts.)

## Toolchain

| tool | version | needed for |
|---|---|---|
| [RGBDS](https://rgbds.gbdev.io/) (`rgbasm`, `rgblink`) | **1.0.3** (developed and verified with it; other 1.0.x are expected to work, the Makefile warns when `rgbasm --version` is not `v1.0.x`) | the build |
| GNU make | 4.x (verified with 4.3) | the build |
| `sha256sum` (or `shasum -a 256`) | any | the hash check `make` prints |
| Python | 3.12 (standard library only) | `make compare`, `make sym-check`, `make test`, `tools/*.py` |

`rgbfix` is not used: the cartridge header is part of the source (`home/header.asm`).  RGBDS 0.x is **not** supported (the source uses `DEF`, `MACRO`,
`-P`/`--preinclude`, and the 1.0 linker-script syntax).

### Linux

Install `make` and a C++ compiler or package, then RGBDS 1.0.3: use your distribution's package if it is 1.0.3 (`apt install rgbds` on recent Debian/Ubuntu may
be older), otherwise build from source, see <https://rgbds.gbdev.io/install#building-from-source>:

```bash
sudo apt-get install make git build-essential cmake bison pkg-config libpng-dev
git clone --branch v1.0.3 https://github.com/gbdev/rgbds
cd rgbds && cmake -S . -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build && sudo cmake --install build
```

### macOS

Install `make` with the Xcode command line tools and RGBDS 1.0.3 (Homebrew's `rgbds` formula if it provides that version, otherwise build from source as above); check `rgbasm --version`.

### Windows

Use WSL (Ubuntu) and follow the Linux instructions inside it, or Cygwin/MSYS2 with `make` and RGBDS 1.0.3.  Keep the repository on the WSL file system for speed.

### Checking

```bash
rgbasm --version     # rgbasm v1.0.3
rgblink --version    # rgblink v1.0.3
make --version       # GNU Make 4.x
```

If RGBDS is not on your `PATH`, run `make RGBDS=/path/to/rgbds/bin/` (with the trailing slash).

## Build

```bash
git clone <this repository>
cd "Mobile Trainer"
make -j8
```

Expected end of the output:

```
rgblink -> mobile_trainer.gbc
SHA-256 OK: 6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570
(reference ROM not present: byte compare skipped; the SHA-256 check above is authoritative)
```

`mobile_trainer.gbc` is the original *Mobile Trainer (Japan)* ROM.  `build/` holds the objects, `mobile_trainer.map` and `mobile_trainer.sym`.

## The reference ROM (optional, for comparison only)

The original cartridge image is a commercial ROM and is not distributed with the repository.  The build does not read it; the SHA-256 in `roms.sha256` is the reference of truth.
If you own the game and dump it from your own cartridge (2 MiB, MBC5+RAM+BATTERY, "M-TRAINER", `B9AJ`), you can verify that it is the same image and compare byte for byte:

```bash
sha256sum "Mobile Trainer (Japan).gbc"
# 6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570   (also SHA-1 ecc0579edeaf9eccd722d605cc288cd023c8576a, MD5 aef9b41fbc898a58fd2aaaeabc2787e9; docs/ROM_INFO.md)
```

Put the file in the repository root as `Mobile Trainer (Japan).gbc` (or as `baserom.gbc`; `make baserom` copies the former to the latter, for the tools that expect `baserom.gbc`).  Both names
are git-ignored (`*.gbc`), and no make target modifies them.  With the ROM present, `make` also runs `make compare`, which ends with

```
RESULT: IDENTICAL
```

`tools/compare_rom.py REFERENCE BUILT` (used by `make compare`) prints the first differing regions (with the region names of the frozen analysis tables, `config/`) when the two files differ.

## Other checks

```bash
make sym-check      # labels of the source vs build/mobile_trainer.sym (needs Python)
make test           # analysis-tool tests (needs Python and the reference ROM as baserom.gbc)
make clean          # remove mobile_trainer.gbc and build/
```
