# SRAM layout (first cut, evidence-graded)

**Addresses (`bank:addr`) remain valid**: find the code with `grep -rn '; BB:AAAA' --include=*.asm .` or in `build/mobile_trainer.sym`.

Cartridge: MBC5+RAM+BATTERY, header RAM-size code 3 = 32 KiB = four 8 KiB banks (`A000-BFFF`).

Evidence: CONFIRMED / PROBABLE / HYPOTHESIS as defined in `ram_map.md`.

## 1. Access mechanics (CONFIRMED)

SRAM bank `ld [$4000],a` (`00:1647`, `00:0633`), shadow `FF8C`.

The disassembled access routines follow two   patterns, and neither is universal: (a) select the bank (`ldh [FF8C],a ; ld [$4000],a`), enable RAM, access, disable   RAM, WITHOUT saving the previous FF8C (e.g.

Some routines leave RAM enabled on return   (`25:4A90-4AF4` enables RAM at `4A97-4A9B` and every return path skips the disable), which is why enables outnumber   disables.

* Bank-0 helpers reaching SRAM by address: `00:0622` (A=bank, H=$A0-$BF selects the SRAM bank), `00:1620` (read one   byte `[hl]` of bank A, region chosen by H: WRAM/SRAM/ROM; SRAM branch enables RAM, reads, disables, returns the   byte, `00:163E-1668`), `00:1686` (block copy from bank D via the setter, `00:1686-16A1`), `00:173x`   (two-bank copy).

* Byte helpers used on SRAM text: `00:14BF` strcpy, `00:14C6` strncpy(bc), `00:14D1` strncpy variant that, when bc=0 on entry, stores a 0 at `[hl]`, `00:14E0`/`00:14EA` **XOR-$A5 decoders** (`ld a,[hli] ; xor $A5 ; ld [de],a`, the second   stops at a decoded 0; `00:14E0` stops when the *stored* byte is 0), `00:1533` strlen (`bc` = length), `00:1509` strcmp (`de` vs `hl`).

* `68:4054-408D` converts an 8-byte **packed-BCD number to ASCII**: per byte the high nibble then the low nibble is   mapped through the table `"0123456789#*"` at `68:408E` (nibbles $A/$B = `#`/`*`), nibble `$F` (or 8 bytes) ends the   string with a 0; the table occupies `68:408E-4099` (`30..39`, `23`, `2A`), so `68:409A-40B4` is the matching text-to-BCD   direction (CONFIRMED by the code, PROBABLE that the data are phone numbers).

## 2. Save-integrity and mirroring code (CONFIRMED by disassembly)

Cross-check (PROBABLE): the bank-2 block has exactly the container format that libmobile verifies for the
adapter's own 192-byte configuration (`config.c: config_internal_verify`: bytes 0/1 = 'M','A', 16-bit big-endian
sum of the first `$BE` bytes stored at offset `$BE`), so bank 2 `A000-A0BF` is most likely a Game Boy-side copy of
that configuration image. libmobile itself does not define the field meaning inside it.

## 3. Proven layout

Status column: C = CONFIRMED (bytes/disassembly cited), P = PROBABLE, H = HYPOTHESIS.

### SRAM bank 0 (two mirrored 4 KiB pages)

| range | size | contents | st |
| --- | --- | --- | --- |
| `A000-AFFD` / `B000-BFFD` | `$FFE` | page payload, checksummed | C |
| `AFFE-AFFF` / `BFFE-BFFF` | 2 | LE additive checksum of the payload | C |
| page 1 `B000-BFFF` | `$1000` | mirror of page 0, refreshed by the repair routine | C |
| `A000-A03F` | `$40` | staged with WRAM `D4C0` (WRAM bank 1: `2D:403C-4040` / `2D:408F-4093` select SVBK=1) | C |
| `A040-A0FF` | `$C0` | staged with WRAM `D400` | C |
| `A100-A113` | `$14` | staged with WRAM `D500` | C |
| `A114-A123` | `$10` | staged with WRAM `D514` | C |
| `A124-AF3F` | 12 x `$12D` | array of 12 records at `A124 + i*$12D` (`i=0..11`) | C |
| record `+00` | 1 | in-use flag: a record is "used" while its first byte is non-zero (scan stops at the first zero) | C |
| record `+00..+08` | 9 | header: `+00` is the in-use flag (see above); the extent 9 bytes follows from the text field starting at `+09` (P). Meaning of `+01..+08` is a HYPOTHESIS: the five default records hold `01 00 00 20 00 06 28 12 30`, `01 00 00 20 00 06 29 20 46`, `... 07 10 17 50`, `... 07 11 00 44`, `... 07 12 19 28`; the last four bytes look like BCD month/day/hour/minute, but no code that decodes them was checked | P (extent) / H (fields) |
| record `+09..+C8` | `$C0` | text body (Shift-JIS, NUL-terminated); staged with `D400` | P |
| record `+C9..+D8` | `$10` | short text (default: `マリオ`, `クッパだいおう`, `ＧＢセンター`) | P |
| record `+D9..+EC` | `$14` | short text (default: `またあそぼうね`, `やきゅうやるぞ`, `だいじなおしらせ`) | P |
| record `+ED..+12C` | `$40` | ASCII text (default: `mario@mario.ne.jp`, `kuppa@mario.ne.jp`, `ieve@makopi.ne.jp`) | P |
| `AF40-AF4F` | `$10` | staged with WRAM `D514` | C |
| `AF50-AF8F` | `$40` | staged with WRAM `D4C0` | C |

Interpretation (HYPOTHESIS): records are mail messages (sender name, subject, address, body, timestamp) and the
`A000-A123` staging area is the mail being composed; `AF40/AF50` hold a second copy of the same two field types
(likely the user's own name/address). Only sizes, offsets, counts, copy directions and the in-use test are proven;
the meanings come from the default record contents and from the reply routine that fills the WRAM buffers from a
record (`25:54B5-5527`: clears `D400` `$124` bytes, then copies record `+ED` ($40) to `D4C0` and `+C9` ($10) to
`D514`). Record deletion is `2D:4133-4179` (shift records down by `$12D`, zero the last one).
Default records are installed by `2D:4195-42A9` (five records, indices 0-4).

### SRAM bank 1 (settings, counters, small flags)

The `B0xx` fields are read by `68:4693-46AB` and `68:4C92-4CD7` into two WRAM tables (`DEA0-DEFF` and
`DF10-DF9F`). The three `DF10` entries have stride `$33` and pair a bank-2 BCD number (`A076+$18*i`, 8 bytes, decoded to ASCII by `68:4054`), a bank-1 XOR-decoded 17-byte string
(`B014+$11*i`) and a 16-byte bank-2 text field (`A07E+$18*i`): CONFIRMED copy pattern (`68:462A-46AB`). Meaning is a
HYPOTHESIS: three connection entries of the form (phone number, text, text) where the XOR-obfuscated string is a
credential; nothing in the code names them.

### SRAM bank 2

| range | size | contents | st |
| --- | --- | --- | --- |
| `A000-A0BD` | `$BE` | configuration image (magic `4D 41 81 00`, then fields) | C |
| `A0BE-A0BF` | 2 | big-endian additive checksum | C |
| `A00C`, `A02C` | field spacing `$20` | NUL-terminated strings copied (`00:14BF`) to WRAM `DEA0` and `DFAA` | C |
| `A076`,`A08E`,`A0A6` | 8 each | **packed-BCD numbers** (nibbles 0-9,`#`,`*`, `$F` = end), stride `$18`, decoded to ASCII (`68:4054`) into WRAM `DF10/DF43/DF76` | C (decoding) / P (phone numbers) |
| `A07E`,`A096`,`A0AE` | `$10` each | text fields (stride `$18`, i.e. directly after each BCD number, `A076+8=A07E`) copied (`00:14D1`, bc=`$10`) to WRAM `DF32/DF65/DF98` | C |
| `A100-A1FF` | `$100` | cleared by `68:4260-4281`; the registration traces also read and write `A100-A11D` (section 5) | C (clear) |
| `A200-A287` | `$88` | read/written by the registration scenarios (`A200-A220`, `A222-A287`, section 5); no static field description | P (in use) |
| rest of bank | - | wiped (`68:4283-42E3`, `68:42E4-4319`, `4C:4C66-4C74`); other users not identified | - |

### SRAM bank 3

Only sparse evidence: `A000` (text/NUL-terminated strings copied by `54:4611-4626`, cleared by `4C:4C7E-4C88`),
`A100` (`4E:48B6`), `A200` (`67:5AFE`), `B000-B001` (LE length word) with data from `B002` upward (`4C:4E53-4F04`:
the routine first searches the WRAM `D500` text (WRAM bank 6) for a `.bmp` terminator (`4C:4E04-4E31`: `.`, `B/b`, `M/m`,
`P/p`, then a NUL), scans backwards for `'/'` ($2F) (`4C:4E36-4E39`), builds a `[length16][strings]` record at `C380`, moves
older data up with the backward copy `00:0526` and stores the record at `B000`, limit `B000+len < C000` (`4C:4ED7-4EDA`);
PROBABLE: a variable-length list of records derived from file names/paths ending in `.bmp`; HYPOTHESIS: what the list is
used for), `B009-B00C` (`54:4E89-4E91`) and a 256-byte block `B400-B4FF` (`B400` 6 bytes, `B410` `$1A`
bytes, `B430`, `B450`, `B470`, flag `B4FF`; `54:4A28-4BBE`, cleared with `bc=$FA` at `54:4A2B`). All four SRAM banks
are wiped by `68:42E4-4319` (loop over banks 0..3, `$1000` bytes at `A000` and `B000` each).

## 5. Dynamic cross-check (emulator traces, CONFIRMED for the 18 scenarios that were run)

Some scenarios start from a factory-fresh SRAM (`docs/research/dynamic_tracing.md` F8: the first run writes all of bank 0) and some contain bulk wipes (e.g.

`title_settings` writes `A000-BFFF` of banks 1-3), so wide ranges do not by themselves prove field use.

* Confirmed: bank 1 reads `A000-A693`, `A69D-A8B9`, `A8D7-A8D8`, `A9E4-A9F7`, `B000-B1FF`, `BF00`, `BF05` (the   checksummed spans, the scheme-1/3/4 words, the `B000/B100` page); bank 0 staging writes `A000-A123` (compose),   `AF40-AF8F`/`AF50-AF68` (profile/tutorial), `AFFE-BFFF` (checksum/mirror); bank 2 `A000-A0BF` read in most scenarios   (`hotplug`, `monkey_blank` read only `A000`).

So the static claim   (checksum stored at `A8D7/A8D8`, written by `22:5077`) rests on disassembly only and the boot behaviour on a   non-blank bank 1 is not demonstrated dynamically.

| access | SRAM bank |
| --- | --- |
| read | 0 |
| read | 1 |
| read | 2 |
| read | 3 |
| write | 0 |
| write | 1 |
| write | 2 |
| write | 3 |

* DOWNGRADED: the object sizes of the 6 x `$16`, 6 x `$100`, 6 x `$50` arrays are PROBABLE (six-entry address tables with these   strides are confirmed; the object size is only bounded by the stride, and the tiling of the checksummed spans is   consistent with equality); the record-header field meanings (`01 00 00 20 00 MM DD hh mm`, "BCD year") are a   HYPOTHESIS.

* CORRECTED: text-to-BCD routine starts at `68:409A`, the bytes at `68:4098-4099` belong to the character table.

## Inventory: accessors per SRAM bank (recomputed)

| tracked SRAM bank | accesses | tier-1 | address span | accessor ROM banks |
|---|---|---|---|---|
| 0 | 66 | 62 | A000-AF50 | 25,27,2A,2D,54,68,7C |
| 1 | 158 | 94 | A000-BF05 | 00,0E,22,48,4C,4E,51,55,65,67-68,70,7C |
| 2 | 14 | 3 | A000-A200 | 4C,67-68 |
| 3 | 23 | 17 | A000-B400 | 4C,4E,54,67-68 |
| ? | 346 | 187 | A000-BF05 | 04,0E,1D,1F,22,2A,2D-2E,48,4C,4E,54-55,57,65,67-68,6C,70,73-74,7E |

("?" = the SRAM bank could not be derived by constant tracking at that instruction.)
