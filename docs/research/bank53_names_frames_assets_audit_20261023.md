# Bank 53 names and browser-frame asset reference

## Current-main refresh at `60204c03e8637ee62577a90d68c58affea11761c`

The intervening `gfx/assets.tsv` and `gfx/png_rules.tsv` edits concern other owners; they add or refine Mail and Notice-header rows and do not change the eight Bank 41–47 resource directories or the Bank 53 source.

## Scenario data-read corpus recheck at `5e6d275`

Re-reading the data-access reports found 81,995 `rom_read`, 762 `sram_read` and 896 `sram_write` merged ranges, with zero `rom_read` ranges intersecting the Bank 53 name/pointer interval `53:4000–4171` (end-exclusive).

## Direct Bank 53 immediate-selector census at `7393820d`

A path-scoped scan covered 333 tracked `.asm`/`.inc` files in `home/`, `engine/`, `data/`, `gfx/`, `audio/` and `lib/`, excluding `engine/mail/sample_data.asm` before reading and excluding `languages/`. It enumerated `ld a, immediate` values written in hexadecimal, decimal, or binary whose value is `$53`. The six matches are bounded assignments in `engine/account/confirm_screens.asm` (to `hTextY`) and `engine/browser/page_list.asm` (to `wSpriteSlot2` fields); none writes a ROM-bank selector. The scan also found no external symbolic references to `Table_PokemonNamePointers` or `PokemonName00..24` in that source set.

This closes only the direct immediate-`A` selector check for the declared source set. It does not exclude values computed at runtime, other instruction forms, pointers or tables, or accesses outside this set. It does not link any Pokémon name to a candidate frame, identify natural Bank 53 selection, or establish used/unused status. No Japanese source, asset, or ROM bytes changed.

## Inline far-call/dispatch byte-pattern census at `ac751d20`

The whole-file scan found 5,274 raw FarCall opcode-pattern matches and zero whose following inline bank byte is `$53`; it found zero patterns for the other three helper entries.

It also found no FarCall-pattern target word equal to ROM0 jump-table helpers `$0540`, `$0545`, `$0551`, or `$056A`.

## Whole-ROM raw far-pointer-shaped byte scan at `8d8f024c`

A distinct static check scanned every byte offset of the immutable Japanese ROM for both literal triple layouts that could encode a Bank 53 far pointer to the name block: `[addr16 little-endian, bank=$53]` and `[bank=$53, addr16 little-endian]`, with the candidate address restricted to `53:[4000,4171)`.

The coincidences resolve to two adjacent same-bank word-table boundaries
(Mail header pointers and the HTML tag-pointer list), five graphics assets,
five font-data locations, six ASCII HTTP strings, three Japanese dialogue
strings, four instruction-opcode sequences, and five opcode/operand overlaps.
The repeated code bytes are ordinary SM83 instructions such as `LD D,E; LD
E,B; LD B,C`; the overlaps include same-bank `CALL` operands and `LD HL,d16`
/`LDH A,[a8]` immediates. These classifications explain the raw triples; they
do not establish that computed or indirect reads of Bank 53 never occur.

This is a bounded negative result for literal inline encodings only. It does
not cover computed bank/address values, registers or stack-derived targets,
indirect tables that do not contain the bank byte inline, runtime copies, or
other encodings. It therefore does not establish natural selection, global
reachability, or used/unused status for the names or frame assets. No Japanese
ASM, graphics, or ROM bytes changed. After rebuilding the current checkout,
`make` reports `RESULT: IDENTICAL` at the pinned ROM hash and `make sym-check`
passes (335 source files, 12,214 labels, 51 constants).
