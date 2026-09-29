# Reverse engineering status

Evidence levels: **CONFIRMED** (demonstrated), **PROBABLE** (strong evidence, not conclusive),
**HYPOTHESIS** (unverified). Generic names (`Function_<bank>_<addr>`) are kept until evidence exists.

## State (initial)

* Build: `make` reproduces the reference ROM **byte-identically** (all regions still `raw` INCBIN). — CONFIRMED
* Reference: 2 MiB, MBC5+RAM+BATTERY, CGB-only, 128 banks, 32 KiB SRAM, header + global checksum valid. — CONFIRMED (`docs/ROM_INFO.md`)
* Toolchain: RGBDS 1.0.3; SM83 decoder in `tools/sm83.py` round-trips every opcode through rgbasm. — CONFIRMED (`make test`)

## Early observations

* 0x0000-0x003F: `ret` (0xC9) at every `rst` vector. — CONFIRMED (bytes)
* 0x0040/48/50/58/60: `jp $CBF1 / $CBF4 / $CBF7 / $CBFA / $CBFD` → interrupt vectors jump into WRAM (code is copied to RAM at boot). — CONFIRMED (bytes); copy routine: TODO
* 0x0100: `nop; jp $0278`. — CONFIRMED (bytes)
* Only ~85 of 128 banks contain data; the rest are 0x00-filled. — CONFIRMED (byte census)

## Next steps

See the workflow results appended below as the analysis progresses.
