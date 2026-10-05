# Reverse engineering status

Evidence levels: **CONFIRMED** (demonstrated), **PROBABLE** (strong evidence, not conclusive), **HYPOTHESIS** (unverified).  Names without evidence stay neutral
(`Function_<bank>_<addr>`, `Data_...`, `wRam_XXXX`; `STYLE.md` section 4).  Detailed, per-topic notes live in `docs/research/` (index: `docs/README.md`).
Numbers marked "frozen" describe `config/` at the freeze and are not updated any more; numbers marked "source" were counted in the `.asm` tree when this file was written
(the tree is edited by hand, so recount with the command given).

## Source state: hand-maintained tree, frozen bootstrap pipeline

The source tree (`home/ engine/ data/ gfx/ audio/ lib/`, `ram.asm`, `ram/`, `consts.asm`, `zero_labels.asm`, `includes.asm`, `layout.link`, `constants/`) was produced once by the
bootstrap generator (`tools/gen_asm.py`, tables `config/`, layout `analysis/layout/layout.tsv`, all kept unchanged as history) and is now the **maintained source of truth**: future
work edits the `.asm` files directly.  `make` needs only RGBDS 1.0.3 and GNU make (no reference ROM, no generation step; `rgbgfx` and Python are optional); `make regen` refuses to run.
The generated tree was then refined in place, keeping the ROM identical: a `[STATUS]` note under every function label, local labels for jump targets, Shift-JIS text as readable strings through
a charmap, and 917 graphics blocks extracted to asset files that the `.asm` files `INCBIN`/`INCLUDE` (`gfx/README.md`).  How to work on it: `README.md`, `STYLE.md`, `INSTALL.md`.

Where evidence lives now:

* **In the source**: the `[CONFIRMED]`/`[PROBABLE]`/`[HYPOTHESIS]` note under each code label; the `; ---- <kind> $a-$b (n bytes) [STATUS] note` header of each data/words/ptrtable/text/gfx/zero block; the status word and note
  after the value of RAM names (`ram/*.asm`) and constants (`consts.asm`).  Source counts (`grep -rhE '^\s+; \[CONFIRMED\]' --include=*.asm home engine data gfx audio lib | wc -l`, likewise `PROBABLE`, `HYPOTHESIS`; headers
  with `grep -rhE '^; ---- .*\[STATUS\]'`): code notes 2,465 CONFIRMED / 1,297 PROBABLE / 124 HYPOTHESIS; block headers 718 / 1,810 / 146 (on 2026-10-05, 120 graphics block headers went from PROBABLE to CONFIRMED because their load call site executed in the 64 natural scenarios).
* **Frozen tables** (full evidence text, not updated): `config/symbols/bankNN.tsv` (per-symbol status and evidence), `config/regions/bankNN.tsv` (per-region status and note), `config/ram/*.tsv`, `config/xrefs.tsv`; `docs/PROGRESS.md` is generated from them.
* **Research notes**: `docs/research/*.md` (reasoning, method, retractions), dynamic evidence in `traces/` and `analysis/`.
* **New findings** go into `docs/research/*.md` and into the comment at the code; `config/` and `docs/PROGRESS.md` are not updated.

## Build / comparison state

* `make` assembles the tree (334 objects, one per `.asm` file, `rgbasm -P includes.asm -I .`), links with `layout.link` (`rgblink -p 0x00`) and the result has SHA-256 `6d802e66...6570`, identical to the reference; with the reference ROM present it also
  compares byte-for-byte: **IDENTICAL**.  CONFIRMED (`make`, `make compare`, `make sym-check`; the only `INCBIN` lines read the extracted asset files under `gfx/` and `data/fonts/`, never the ROM).
* `build/mobile_trainer.sym` has 12,022 entries (source: 6,535 global labels, of which 1,022 are neutral alias labels behind a semantic name; 5,456 local labels; 31 exported constants); `tools/sym_check.py` cross-checks them against the source
  (every label defined exactly once, comments give the linker's address).
* Far calls are `farcall <Label>` macros (5,274 sites, `constants/macros.inc`); the cartridge header (logo, checksums) is part of the source bytes, `rgbfix` is not used.
* Frozen classification (`config/regions`, `docs/PROGRESS.md`): 100% of the ROM is classified into regions: code 221,784 B (**162,635 CONFIRMED** = 73.3%, executed in the 64 natural mGBA scenarios of `analysis/coverage_union.tsv`
  (77,979 executed instruction starts; 67 scenarios with 3 forced-execution runs, `dynamic_tracing.md` section 11) or otherwise proven; 55,704 PROBABLE = statically reached; 3,445 HYPOTHESIS), gfx 491 KB (149,600 B CONFIRMED),
  data 196 KB, text 45 KB (Shift-JIS), words/ptrtable 9 KB, zero 1.13 MB.  Bytes still HYPOTHESIS: data 1,959, gfx 2,235, text 37, words 14, zero 4,694 (the region status is per region).
* Frozen symbol tables: 3,020 symbol rows (1,405 CONFIRMED, 1,395 PROBABLE, 220 generic-name HYPOTHESIS notes), 1,155 xrefs.  RAM names (source, `ram/{wram,sram,hram}.asm`): 1,084 (44 CONFIRMED, 213 PROBABLE, 827 neutral/HYPOTHESIS), plus
  56 bank-qualified WRAM/SRAM names in `ram/banked.asm` (5 CONFIRMED, 51 PROBABLE; naming pass ram3 added five: `wKbdSlideDeltaRow` and the SRAM variable page `sVarPage` ... `sKbdInputMode`); other banked addresses stay neutral.
* Naming pass 2 (`analysis/naming2/*_renames.tsv`, notes in `docs/research/naming2_*.md`): 700 rows, 595 applied (174 CONFIRMED, 421 PROBABLE; 105 stayed HYPOTHESIS ideas) and then adversarially re-checked by four verifiers (`analysis/naming2/verify_*_fixes.tsv`, `docs/research/naming2_verify_*.md`): none refuted, 19 renamed to more honest names, about 25 statuses lowered (recorded in the verifier docs; the source carries no per-name status).  Names are applied with `tools/apply_renames.py` (hash-verified, neutral names kept as aliases).
* Audio (`docs/research/audio_format.md`): all sound data is written as macros (`constants/audio_macros.inc`): 59 stream headers (11,916 commands), the 112 instrument records, the 120-entry note table, the durations and the 10 wave patterns; 0 audio bytes stay `db`.  The format was checked twice: by re-executing the driver code on all 152 tracks plus synthetic effect tests in a small SM83 interpreter (`tools/audio_driver_check.py`), and on 2026-10-05 independently by two verifiers (`docs/research/audio2_verify_static.md`, code and data only; `audio2_verify_dynamic.md`, the ROM's own driver on mGBA: 35,351 executed commands, 0 divergences from an independent decode; `analysis/audio2_verify_dyn/reproduce.sh`), whose corrections to the prose are applied in `docs/research/audio_format.md` section 12.  Commands are named by demonstrated effect; the commands no song uses (`$C0` pan, `$C6`, `$C9` detune, `$CD`, `$B5`) are PROBABLE, demonstrated with synthetic streams only (a synthetic run does not raise a status), and `$CA` and `$CD` keep neutral names (`sound_cmd_CA/CD`; `$CA` stores a byte nothing reads).  Songs are named by id only (`SoundSongNN_*` for ids `$01`-`$1D`, `SoundSfxNN_*` for the effects `$29`-`$46`); which tune is which is unknown.
* Naming pass 3 (`analysis/naming2/ram2_renames.tsv`, `data2_renames.tsv`; notes `docs/research/naming2_ram2.md`, `naming2_data2.md`): 49 RAM variables (14 CONFIRMED, 35 PROBABLE; bank-independent addresses only) and 780 data/table/graphics/sprite labels (203 CONFIRMED, 577 PROBABLE) applied, then re-checked by three verifiers (`docs/research/naming2_verify_ram2.md`, `_data2a.md`, `_data2b.md`): none refuted, 16 renames (for example the shared-root correction `BrowserShared_*` in bank 72), a few statuses changed (recorded in the verifier documents).  `tools/sprite_chain_check.py` walks every sprite object table and checks that each sprite block name is the block the chain reaches (0 mismatches).
* Naming pass 4 (`analysis/naming2/fn4_renames.tsv`; notes `docs/research/naming2_fn4.md`, verification `naming2_verify_fn4.md`): the 59 neutral `Function_*` labels left by pass 2 were read one by one; 32 are named (14 CONFIRMED, 18 PROBABLE: nine one-`ret` stubs `Stub_Nop_<bank>_<addr>`, the pieces of the glyph routines of the text engine, three Mobile SDK helpers, two steps of the HTML line layout, screen helpers), 27 stay neutral (unreferenced code without an executed twin, or a role not determined).  An independent reader re-derived every row: of the first 31, 17 upheld, 12 corrected (the corrections are merged), 1 downgraded, 1 retracted; the two layout rows were both corrected (one renamed).  Two `call nz` after `ldh a, [hJoyHeld]` can never be taken (LDH sets no flags; Z is the farcall's).
* Still neutral (source, 6,477 global labels with an address comment, recounted on 2026-10-05 after pass 4): 1,497 have a neutral name (Function 27, Label 438, Data 673, Table 94, String 135, graphics kinds 130), 4,980 have a semantic name (some end in the original position, e.g. `Gfx_StartHDMAAtVBlank_2B_4723`, when one name applies to several places).  Every neutral
  name is a claim of ignorance, not an error (`STYLE.md` section 4).

## Reference ROM (CONFIRMED, `docs/ROM_INFO.md`)

2 MiB, MBC5+RAM+BATTERY (0x1B), CGB-only (0xC0), 128 banks, 32 KiB SRAM, Japan, header and global checksums valid.  85 banks hold data, 43 are entirely 0x00.

## What is known

| topic | status | where |
|---|---|---|
| Boot flow, RAM interrupt stubs (`jp $CBF1..CBFD` written at `00:04A0`), OAM-DMA copy, MBC5 bookkeeping in HRAM (`FF8A-FF8D`, `FFF4/FFF5`) | CONFIRMED | `docs/research/boot_and_home.md` |
| Far-call convention `call $06D1 ; dw addr ; db bank` (5,274 static sites), inline jump tables (`$0545/$0540/$056A/$0551`) | CONFIRMED | same |
| Bank 75 is the Mobile Adapter GB SDK (= Pokémon Crystal bank 44 code, byte-identical modulo relocation); bank 0F is the mail library (= Crystal 45).  Crystal community names are PROBABLE-only imports | CONFIRMED (code identity) / PROBABLE (names) | `docs/research/crystal_xref.md` |
| Adapter protocol (libmobile) and the Trainer's serial/timer path: `Int_Serial 00:01B7 -> 75:56D2`, `Int_Timer 00:01ED -> 75:58EA`, 16 packet templates verified, checksum routine verified | CONFIRMED mostly | `mobile_protocol.md`, `mobile_trainer_serial.md` |
| Text is Shift-JIS with NUL terminators; JIS X 0208 12x12 1bpp font in banks 76-7E; 55 HTML files in banks 3D/3E (index in 3F); graphics loaded raw (no compression proven) | CONFIRMED / PROBABLE | `text_encoding.md`, `bank_survey.md` |
| SRAM: five integrity schemes (mirrored pages + checksum, `MOBILE TRAINER00` magic, big-endian checksum image in bank 2) | CONFIRMED (disassembly) | `sram_layout.md` |
| Dynamic evidence: union of executed instruction starts over 64 natural mGBA scenarios (+3 forced-execution runs kept separate), 77,979 ROM starts | CONFIRMED | `dynamic_tracing.md` (round 1: 18 scenarios / 43,265 starts; round 2: 41 / 72,224; round 3: 67 / 77,979), `analysis/coverage_union.tsv` |
| Ghidra 12.1.3 + GhidraBoy (cc9f565) builds and runs headlessly; it adds no code/data classification beyond `tools/cfg.py`; useful for decompiler views of single routines | CONFIRMED | `docs/research/ghidra.md` |

## Open questions (selected)

* Purpose of `65:4000`, `0E:4000`, `7C:7B7C/7D1F`.  (The role of bank 04 is settled: it is the sound driver, CONFIRMED: `SoundDrv_FrameTick` ran 3,420,468 times in 63 of the 64 natural scenarios, writes the APU registers of all four channels, loads song records and starts tracks; see `docs/research/audio_format.md`.)
* Joypad read is in bank 7D (`7D:7B7C`); `hFFA7` writer unknown.  Serial/timer IE is enabled in bank 75 (`75:4390`, PROBABLE).
* Text reader of bank 6C (second text convention, `sjis_hw` charmap only names the bytes), record reader of bank 72.
* 06D1-family variants (`06BC`, `06E5`, `0716`, `072E`) barely used; inline bytes of unrecognised conventions may be mis-decoded by the analysis tools.
* Graphics blocks still `db` (no proven type: unknown content class, sprite/OAM records, animation scripts, object tables): listed in `gfx/README.md`, "Still `db`".

## What remains

1. Promote PROBABLE code to CONFIRMED with more traces or by disassembly reasoning recorded in `docs/research/` and in the `[STATUS]` comment (the frozen `tools/apply_coverage.py` only updates `config/`); ~1 KB of PROBABLE/HYPOTHESIS code
   has no proven entry (reached only through RAM pointers / unresolved `jp hl`).
2. More semantic names for the neutral labels (`docs/research/naming_g*.md`, `naming_sdk.md` list HYPOTHESES and open questions); bank-qualified WRAM/SRAM names for the many neutral `wRam_XXXX`/`sSram_XXXX`.
3. Further presentation of the maintained source: constants for magic numbers, more macros, splitting `code` blocks where evidence shows data, typing the remaining `db` graphics blocks.  Done so far: local labels, `[STATUS]` function notes,
   readable Shift-JIS strings, `INCBIN` graphics assets.
4. Keep the address comments honest after edits (`tools/sym_check.py --fix`) and record new evidence at the code.

Every claim above has an evidence trail in the linked documents; anything not listed there is not established.
