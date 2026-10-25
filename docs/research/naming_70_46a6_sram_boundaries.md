# Bank70:46A6 and the unlabelled segment at4740

### Generic copy-route extension

| Route | Destination contract in the reviewed flow | Relation to SRAM1:`$A9ED-$A9EE` |
|---|---|---|
| `Config_BuildImageFromAccount` | `$A000-$A0BF`, SRAM bank 2; the following fill is `$A0C0-$A0FF`, bank 2 | Different bank and address range |
| settings-page initialization, clear, and backup | `$B000-$B1FF`, SRAM bank 1; copy destinations are `$B000` or `$B100` | Above `$A9FF` |
| browser history push/pop | `$AA00-$AFFF`, SRAM bank 1, when the maintained ring index is in its natural `0..5` domain | Above `$A9FF`; an arbitrary/corrupt index is not bounded by this natural-state result |
| page-cache push/pop | table-selected `$A000`/`$B000` blocks in SRAM banks 2/3; the ring writers maintain indices `0..2` | Different banks; the fourth physical table record is outside the natural ring |
| HTML page load | the two maintained callers are in `MobileDictView`; the load destination is the bank-3 page buffer at `$B000`, with `$0FFC` capacity | Different bank and address range |
| page-result wrapper move | SRAM bank 3 is selected; the normal page-length guard limits the backward move to the `$B000-$BFFF` page buffer | Different bank and address range; malformed pre-existing lengths are outside the normal-input claim |

### Exact direct-operand census for SRAM1:A9ED/A9EE

It does not close writes through register-indirect helpers, far pointers, arbitrary API arguments, stack-derived destinations, malformed or external SRAM, or dynamic control flow.

### `FillBytes` caller census and SRAM destination matrix

A grouped scan of the maintained Japanese callers found 105 direct
`call FillBytes` sites in `home/`, `engine/`, and `lib/`, with 29 distinct
nearby HL setup forms. The 24 SRAM-writing sites resolve to the following
destination contracts; the remaining 81 sites use the explicit HRAM/WRAM/VRAM
destinations or the five additional input-HL cases described below.

| Destination family | Sites | Bank/range and write value | Relation to A9ED/A9EE |
|---|---:|---|---|
| `_SRAM` / `$B000` whole-bank clears | 8 | `Browser_ClearCaches` clears banks 2/3; `Sram_WipeBanks2And3` clears both 4 KiB windows in banks 2/3; `Sram_WipeAllBanks` loops banks 0–3. Every fill writes zero. | Bank 1's A9ED/A9EE are cleared to zero by the all-bank loop; the other clear routes select only banks 2/3 |
| `sSaveCheckStateBlock` | 1 | SRAM1 `$A9E8-$A9F7`, zero | Includes A9ED/A9EE; subsequent direct checksum stores affect only `$A9E8-$A9EB` |
| `sPageList` | 1 | SRAM1 `$A000-$A683`, zero | Ends before `$A9E8` |
| `sBrowserHistory` | 1 | SRAM1 `$AA00-$AFFF`, zero | Starts above `$A9FF` |
| `sSettingsPage` / `sVarPage` | 3 | SRAM1 `$B000-$B1FF` initialization and `$BF00-$BFFF` variable-page clear; initialization uses `$A5`, variable clear uses zero | Starts above `$A9FF` |
| `sConfigImage` / `sConfigImagePad` | 2 | SRAM2 `$A000-$A0FF`; zero image clear and `$FF` pad fill | Different SRAM bank and range |
| `sNetWorkPage` | 2 | SRAM3 `$A000-$BFFF`, zero in two 8 KiB request initializers | Different SRAM bank |
| `sBrowserPageBuf` | 5 | SRAM3 `$B000-$BFFF`, zero before load/parse flows | Different SRAM bank |
| `PageCache_Pop` caller-supplied HL | 1 | All six maintained callers set `DE=$B000`, `A=3`; `BankSwitch_H` selects SRAM3, then the `$1000`-byte page buffer is zero-filled before cache copy | Different SRAM bank |

Five of the six input-HL sites are also bounded outside SRAM: the two sprite
slot helpers select WRAM bank 7, the browser scrollbar fill targets
`wTileStage2` in WRAM bank 2, and the two `Html_ParseSource` clears use
`wHtmlPage` in WRAM bank 4 and `wHtmlTextStream` in WRAM bank 5. The HTML
page pointer/bank and text-stream pointer/bank are initialized by the two
maintained parser entry wrappers; they do not inherit an arbitrary SRAM
destination. The nearby-HL scan is used only to find cases requiring this
manual contract review; it is not treated as proof by itself.

This closes the direct `FillBytes` caller family for the reviewed maintained
routes: no normal fill assigns a nonzero value to SRAM1:A9ED, and the only
fill that covers it writes zero. It does not close `CopyString`, XOR codecs,
register-indirect byte/block writers, arbitrary API descriptors, malformed
inputs or dynamic control transfer. The broader A9ED/A9EE writer question
therefore remains open. Source locations include `engine/account/helpers.asm`,
`engine/account/settings_page.asm`, `engine/account/register_config.asm`,
`engine/browser/history_cache.asm`, `engine/browser/page_loader.asm`,
`engine/html/parser.asm`, and `engine/sram/save_block_check.asm`; RAM extents
and bank identities are cross-checked against `ram/banked.asm`.

ReadByteFar's SRAM branch restores bank shadow but forces enable0, a distinct contract.

## Conditional random-range write alias and separate bit-reader fragment

`TrySetA9EEFromRandom16_ByA9EDFlags` is a PROBABLE operation alias for the existing `Function_70_46A6`. It replaces only the earlier neutral-name recommendation for the154-byte/75-start conditional operation; entry, natural caller, field domain and application purpose remain HYPOTHESIS. The alias occupies blank869, retaining the neutral on870 and every emitting/locator row and local scope. It neither names a game event nor asserts uniform randomness, independence, frequency, seeding or a live feature.

The prologue saves twoAF pairs from FFF5(SRAM-enable) andFF8C(SRAM-bank), usingFFF2 scratch, then selectsSRAM1 and enablesRAMG0A. It testsSRAM1:A9ED.bit6, requires `(A9ED &30)!=0`, and requiresA9EE=0. Under stable fields, failed tests do not writeA9EE. The success choice rereadsA9ED.bit7: clear calls ROM0 Random16 twice, discards the firstHL and divides the second unsignedHL by3, storing2+remainder (2..4); set callsRandom16 once and divides by6, storing0A+remainder (0A..0F). Both calls are fixed ROM0 addresses0C0E/0D67; no ROMX callee identity is borrowed. The zero guard and bit conditions are specific tests, not a complete field-type interpretation.

Under a hypothetical full entry and ordinary stack/state assumptions, it selectsSRAM1/RAMG0A, testsA9ED.bit7, places0/1 inB, restores the saved SRAM shadows/registers and returnsA=B.
