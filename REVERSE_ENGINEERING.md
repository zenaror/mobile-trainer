# Reverse engineering status

Evidence levels: **CONFIRMED** (demonstrated), **PROBABLE** (strong evidence, not conclusive),
**HYPOTHESIS** (unverified). Generic names (`Function_<bank>_<addr>`) are kept until evidence exists.
Detailed, per-topic notes live in `docs/research/`; machine-generated progress metrics in `docs/PROGRESS.md`.

## Build / comparison state

* `make` assembles the committed `src/` (no INCBIN, no reference ROM needed) and the result has SHA-256 `6d802e66…6570`, identical to the reference; with the reference ROM present it also compares byte-for-byte: **IDENTICAL**. CONFIRMED (`make`, `make verify`, `make test`, `tools/selftest_gen.py`; a clean clone rebuilds the hash)
* 100% of the ROM is classified into regions: code 221,783 B (105,600 CONFIRMED = executed in 41 mGBA scenarios; 112,738 PROBABLE = statically reached; 3,445 HYPOTHESIS), gfx 491 KB, data 196 KB, text 45 KB (Shift-JIS, one string per line with decoded comments), words/ptrtable 9 KB, zero 1.13 MB. Only ~1.8 KB remain UNCLASSIFIED (HYPOTHESIS data).
* ~3,000 symbol rows (1,405 CONFIRMED, 1,395 PROBABLE, 220 generic-name HYPOTHESIS notes), ~1,150 xrefs, ~1,080 RAM names (44 CONFIRMED, 213 PROBABLE, 827 neutral/HYPOTHESIS; banked WRAM/SRAM addresses stay neutral because the generator cannot see the bank).
* Far calls are `farcall <Label>` macros (5,274 sites), config drives `tools/gen_asm.py` (`docs/FORMATS.md`); the header (logo, checksums) is part of the reproduced bytes, `rgbfix` is not used. Current numbers: `docs/PROGRESS.md`.

## Reference ROM (CONFIRMED, `docs/ROM_INFO.md`)

2 MiB, MBC5+RAM+BATTERY (0x1B), CGB-only (0xC0), 128 banks, 32 KiB SRAM, Japan, header and global checksums valid. 85 banks hold data, 43 are entirely 0x00.

## What is known

| topic | status | where |
|---|---|---|
| Boot flow, RAM interrupt stubs (`jp $CBF1..CBFD` written at `00:04A0`), OAM-DMA copy, MBC5 bookkeeping in HRAM (`FF8A-FF8D`, `FFF4/FFF5`) | CONFIRMED | `docs/research/boot_and_home.md` |
| Far-call convention `call $06D1 ; dw addr ; db bank` (5274 static sites), inline jump tables (`$0545/$0540/$056A/$0551`) | CONFIRMED | same |
| Bank 75 is the Mobile Adapter GB SDK (= Pokémon Crystal bank 44 code, byte-identical modulo relocation); bank 0F is the mail library (= Crystal 45). Crystal community names are PROBABLE-only imports | CONFIRMED (code identity) / PROBABLE (names) | `docs/research/crystal_xref.md` |
| Adapter protocol (libmobile) and the Trainer's serial/timer path: `Int_Serial 00:01B7 → 75:56D2`, `Int_Timer 00:01ED → 75:58EA`, 16 packet templates verified, checksum routine verified | CONFIRMED mostly | `mobile_protocol.md`, `mobile_trainer_serial.md` |
| Text is Shift-JIS with NUL terminators; JIS X 0208 12×12 1bpp font in banks 76-7E; 55 HTML files in banks 3D/3E (index in 3F); graphics loaded raw (no compression proven) | CONFIRMED / PROBABLE | `text_encoding.md`, `bank_survey.md` |
| SRAM: five integrity schemes (mirrored pages + checksum, `MOBILE TRAINER00` magic, big-endian checksum image in bank 2) | CONFIRMED (disassembly) | `sram_layout.md` |
| Dynamic evidence: 43k executed instruction starts over 18 mGBA scenarios (`analysis/coverage_union.tsv`) | CONFIRMED | `dynamic_tracing.md` |
| Ghidra 12.1.3 + GhidraBoy (cc9f565) builds and runs headlessly; it adds no code/data classification beyond `tools/cfg.py`; useful for decompiler views of single routines | CONFIRMED | `docs/research/ghidra.md` |

## Open questions (selected)

* Role of bank 04 (APU init confirmed; "sound driver" is PROBABLE at best). Purpose of `65:4000`, `0E:4000`, `7C:7B7C/7D1F`.
* Joypad read is in bank 7D (`7D:7B7C`); `hFFA7` writer unknown. Serial/timer IE is enabled in bank 75 (`75:4390`, PROBABLE).
* Text reader of bank 6C (second text convention), record reader of bank 72.
* 06D1-family variants (`06BC`, `06E5`, `0716`, `072E`) barely used; inline bytes of unrecognised conventions may be mis-decoded by the analysis tools.

## What remains

1. Promote PROBABLE code to CONFIRMED with more traces (`tools/apply_coverage.py` after new scenarios); ~1 KB of PROBABLE/HYPOTHESIS code has no proven entry (reached only through RAM pointers / unresolved `jp hl`).
2. More semantic names (`docs/research/naming_g*.md`, `naming_sdk.md` list HYPOTHESES and open questions); bank-aware WRAM/SRAM names need generator support for banked names.
3. Replace `db` graphics/text blocks by extracted assets + INCBIN only if byte-identity is preserved (not started; current form is exact and self-contained).
4. Optional presentation refinement: more macros, constants for magic numbers, local labels.

Every claim above has an evidence trail in the linked documents; anything not listed there is not established.
