# ROM pointer operands (romop1): 708 pointers written as labels, 1,367 bank loads written as `BANK(label)`

> Status: **reference (current)** for the operands it rewrites.  First pass over the raw `ld hl|de|bc, $XXXX` operands whose value is an address below `$8000` (the ROM); the RAM operands were done in
> [`naming2_ramop6.md`](naming2_ramop6.md) to [`naming2_ramop10.md`](naming2_ramop10.md).  The idea is the same as in the banked WRAM passes: a number proves nothing, a *consumer rule* that says how the routine
> receiving the register reads it does.
> Record: [`analysis/naming2/rom_consumers.tsv`](../../analysis/naming2/rom_consumers.tsv) (23 rules); tools: `tools/apply_rom_operands.py`, `tools/test_rom_operands.py` (47 tests), `tools/sprite_chain_check.py` (reads
> `BANK(label)` and checks the new labels), `tools/render_screens.py` (reads `BANK(label)`); independent verification: [`naming2_verify_romop1.md`](naming2_verify_romop1.md).

## 1. Result

| item | count |
|---|---|
| ROM pointer operands (`ld hl\|de\|bc, $XXXX`) written as labels | **708** (606 in DE, 99 in HL, 3 in BC): 705 by the tool, 3 by hand (section 5); 701 in `$4000-$7FFF` with the bank shown, 7 in ROM0; 431 of them lie in code that ran in the natural traces |
| by consumer | `Sprite_InitSlot` 592, `Palette_LoadToBuffer` 22, `Gfx_StartHDMA` 14, `Sprite_SetHook` 13, `SampleData_CopyString` 13, `MobileSDK_CopyString` 9, `StringAppend` 7, `TextTiles_RenderGrid` 5, `TextTiles_RenderLine` 4, `Gfx_StartHDMAWithService` 3, `CopyString` 3, `MobileSDK_CopyBytes` 3, `Html_ScanAttributes` 3, `Mobile_PacketSendBytes` 3, `CopyBytes` 2, `Mail_FindKeywordValue` 2, `Mail_EmitStringAndSuffix` 2, `Mobile_PacketSendEmptyBody` 2, `Mobile_PacketSendReadConfig` 2, `Tilemap_CopyRectAndAttr` 1, `Tilemap_CopyRectAndAttrPtr` 1, `Mobile_PacketSendExpect` 1, `MobileSDK_MatchPrefix` 1 |
| bank loads `ld a, $NN` written `ld a, BANK(Label)` | **1,367**: 648 next to a pointer that this pass wrote, 719 next to a pointer that already was a label (`Gfx_StartHDMAWithService` 296, `Tilemap_CopyRectAndAttr` 132, `Sprite_InitSlot` 120, `Palette_LoadToBuffer` 101, `TextTiles_RenderLine` 33, `Gfx_StartHDMA` 32, `Tilemap_CopyRectAndAttrPtr` 5); 634 of the 719 ran in the natural traces |
| new labels | **161**: 159 `<Table>_Entry<N>` (22 parent tables: `MailSession_ObjTable_72FB` 38, `Mailbox_ObjTable` 13, `MailResult_ObjTable` 13, `MailConnect_ObjTable` 11, ...) and 2 neutral `Table_BB_AAAA` names for object-table entries kept as `db` / `ds` |
| files changed | 109: 86 of code (`engine/` 84, `lib/` 2) and 23 of `gfx/` that received labels |
| rules | `analysis/naming2/rom_consumers.tsv`: 23 rows: 9 of bank kind `A` (the routine takes the ROM bank in A), 10 of kind `mapped` (it reads the bank that is mapped), 4 of a fixed bank (`75`) |
| left numeric | 82 `no label`, 18 `not a table entry`, 3 `vector or null` among the operands of a consumer that has a rule (section 6); 3,143 operands whose consumer has no rule: 1,449 of them lie in `$0150-$7FFF` (1,694 below), most are counts, pairs and divisors |
| tests | `python3 tools/test_rom_operands.py`: 47 tests (a synthetic tree in memory and `main()` on a mini tree: no build needed) |
| ROM | byte-identical (`make compare`: `RESULT: IDENTICAL`; `sym-check`, the form checks, `sprite_chain_check`, `apply_banked_names --check`, `invariants_check` and every other audit of the repository pass); every changed line is an operand or a bank load replaced by an expression of the same value, or one of the 161 inserted labels |

Example (`gfx/mail/draft_menu.asm` and its caller):

```
	ld de, Table_MailDraftMenu_Anims_Entry16        ; was: ld de, $5210
	ld a, BANK(Table_MailDraftMenu_Anims_Entry16)   ; was: ld a, $2B
	ld b, $81
	farcall Sprite_InitSlot
...
Table_MailDraftMenu_Anims_Entry16:: ; 2B:5210
	sprite_object_entry ...
```

## 2. What the rules say

The proof of a rule is the code of the consumer, read in the source and decoded from the ROM bytes (`tools/sm83.py`); the last column is the evidence that the consumer ran in the natural traces
(`analysis/coverage_union.tsv`: executions in how many of the 64 scenarios).  A rule is a statement about the *register*: where the register is a pointer into the ROM, the operand is the address of a label.
A consumer that never ran (`SampleData_CopyString`, `Mail_EmitStringAndSuffix`) gives a rule that is as good as the reading, and the labels it writes are as good as the data they name (PROBABLE).

| consumer | register | bank | what the routine does with it | executed |
|---|---|---|---|---|
| `Sprite_InitSlot` (00:0A82) | DE | A | stores A as the ROM bank of the slot (`+$0E`), selects it and fills the slot from the 4-byte object entry at `DE + 4 * (B & $3F)` (`Sprite_LoadObjectEntry`, 00:0AB8-0AC4 keeps `(B & $7F) * 4` in 8 bits: the carry is lost; bit 7 of B is the loop flag kept at slot `+$0F`): DE is the object table, A its bank, B the id | 63 |
| `Palette_LoadToBuffer` (4F:4000) | HL | A | stores A in `hFarBank` and farcalls `CopyBytes` through `FarCall_Inline16`: HL is the palette source, read in bank A | 63 |
| `Gfx_StartHDMA` (00:0749), `Gfx_StartHDMAWithService` (00:0787) | HL | A | A = source bank (region by H), HL = source, DE = destination (E bit 0 = VRAM bank), C = number of 16-byte blocks | 63, 63 |
| `TextTiles_RenderLine` (48:403E), `TextTiles_RenderGrid` (48:40A9) | HL | A | the string is read with `ReadByteFar` in bank A: a ROM string when H < `$80` (`RenderGrid` also takes WRAM strings: the rule speaks of immediates below `$8000` only) | 50, 33 |
| `Tilemap_CopyRectAndAttr` (00:08EA), `Tilemap_CopyRectAndAttrPtr` (00:16A2) | HL | A | `call BankSwitch_H` (A = bank of the source, region by H), then the rectangle copy reads from [HL]; the `Ptr` variant takes its second source from `wRam_C10E/C10F` | 63, 46 |
| `Sprite_SetHook` (00:0A45) | DE | A | stores E, D and A at the slot: the hook is the function at DE in ROM bank A (no hook = bank byte `$FF`, or bank 0 with DE = 0) | 34 |
| `CopyBytes` (00:050C), `CopyString` (00:14BF) | HL | mapped | reads [HL++] in the ROM bank that is mapped (they select none) | 64, 50 |
| `StringAppend` (00:14F3) | HL | mapped | copies the string at HL to the end of the string at DE, in ROM0 | 13 |
| `MobileSDK_CopyBytes` (75:4000), `MobileSDK_CopyString` (75:4007), `MobileSDK_MatchPrefix` (75:72AB) | HL (DE for the prefix) | mapped | the SDK's own copy and compare helpers, in bank 75 | 62, 40, 13 |
| `SampleData_CopyString` (2D:42AA) | HL | mapped | `ld a, [hli] / ld [de], a / inc de / cp a, $00 / jr nz` in bank 2D (the sample records of the mail screens: only the label is written, never the text) | never (PROBABLE) |
| `Mail_FindKeywordValue` (0F:4AD3), `Mail_EmitStringAndSuffix` (0F:521B) | HL | mapped | compare / copy `[HL++]` of a string of the library's own bank (0F), no bank selected | 6, never |
| `Html_ScanAttributes` (00:1119) | BC | mapped | hands BC to `Html_MatchKeyword` (00:10E9: `ld a, [bc] / inc bc`): a table of string pointers in the caller's bank | 15 |
| `Mobile_PacketSendBytes` (75:5F10), `...Expect` (75:5F0B), `...EmptyBody` (75:5F08), `...ReadConfig` (75:6371) | HL | 75 | stores HL in `wMobileSDK_TxPointer`; the bytes are read by `MobileSDK_TxNextByte` (75:5B2B) from the timer interrupt, which selects bank 75 first: a packet template of bank 75 whoever calls | 63, 62, 62, 62 |

`Sprite_SetPosition` takes a Y,X *pair* in DE (`$5A47`): it has no rule, and neither has any routine whose DE, HL or BC is a count, a length, a divisor or a coordinate (section 6).

## 3. How the tool proves the operand

`tools/apply_rom_operands.py` (its docstring is the specification) reads `build/mobile_trainer.sym` and one marked build of the tree (`tools/line_addresses.py`: every source line mapped to its ROM address) and decides each
`ld hl|de|bc, $XXXX` with a value below `$8000` in this order:

1. **consumer**: the first `call`, `farcall` or tail `jp Label` of the straight line after the load, with only plain instructions that do not touch the register in between (`find_consumer_ex` of
   `apply_ram_operands.py`).  No rule for (consumer, register) means *no rule*: the operand stays numeric.
2. **value**: `$0000` and everything below `$0150` (the restart and interrupt vectors and the cartridge header) is a number: `ld de, $0000` for `Sprite_SetHook` is "no hook", not `Rst_00`.
3. **bank**: for kind `A`, the constant of the nearest write of A before the call (`ld a, $NN`, or `xor a`; any other source, or a value outside `1..$7F`, stops the proof: *bank not shown*; A = 0 never means bank 0
   for a pointer of `$4000` and above, because `BankSwitch_H` does nothing for 0); a pointer below `$4000` is in bank 0 whatever A is.  For kind `mapped`, the bank of the code that holds the load (a plain `call` or a
   tail `jp` keeps it, and so does a `farcall` to a ROM0 label: its inline bank byte is `BANK(Label)` = 0 and `BankSwitch_H` does nothing for 0), or the bank of the routine after a `farcall` to a target of `$4000`
   and above (the macro writes `BANK(Label)`); the code must be in a ROMX bank, the routine in ROM0 or in the same bank, and no write of a ROM bank register (`ld [$2xxx], a`, `ld [$3xxx], a`, `rROMB0/1`, any
   spelling) may lie between the load and the call.  A kind that is a two-digit number (`75`) fixes the bank whoever calls.
4. **target**: the label of that bank at that address (a semantic name before a generic `Table_BB_AAAA`), or, when no label is there and a `sprite_object_entry` line starts at the address, a new global label
   `<Table>_Entry<N>` in front of that line (N = number of `sprite_object_entry` lines between the label of the table and this line; a label `<X>_Entry<N>` whose stem `<X>` is a label of the run above was written by
   an earlier run and counts as part of the table, any other label that ends in `_Entry<N>` is a real table label).  Anything else is counted as `no label` (no source line starts there: the pointer is inside a block) or
   `not a table entry` (a line starts there but is not an object entry), and stays numeric.
5. **write**: the operand becomes the label; the nearest `ld a, $NN`, when it is the live write of A, its value is the bank of the target and no instruction between it and the call reads A (`ld [wCount], a`,
   `ld b, a`, `cp a, c`, `push af`: the constant may then be a number of its own), becomes `ld a, BANK(Label)`; for an operand that already was a label (`ld hl, Label`) only the `ld a, $NN` is rewritten when the
   consumer takes A as the bank and its value is the bank of the label.  `; raw` lines are never rewritten, the `ld a` line included.

Why the bytes cannot change: the label is the same number (the linker puts it there), `BANK(Label)` is the bank of the section that holds it; `make` compares the SHA-256 and the tool restores the files when it differs
and also when it is interrupted or fails while building.  `--check` exits 1 when a rule still proves an operand, 2 when the lines could not be mapped.  Idempotent: a second run writes nothing.

The label names a *position*: `<Table>_Entry<N>` is the address of entry N of that table, used as the base DE of a call; the call starts entry `N + (B & $3F)`, not entry N (in 653 of the 704 sites with a constant B
the object that starts is the entry after the labelled one, and in `Kbd_ObjTable` the labelled entries 3, 8, 14, 16 and 18 are the null entries that open each set).  `tools/sprite_chain_check.py` checks every
`<Table>_Entry<N>` against its parent (address = parent + 4 N in the same bank) and the `BANK(Label)` loads against the table that DE names.

## 4. What the independent readers changed

Four readers (fresh context, one scope each) verified the first version; their corrections are in the tree and in [`naming2_verify_romop1.md`](naming2_verify_romop1.md): no pointer operand was a false accept; the entry
formula of `Sprite_LoadObjectEntry` was wrong in every earlier note (`DE + 4 * (id & $7F)`: the carry of the shifts is lost, so it is `& $3F`; corrected in `home/sprites.asm`, `constants/sprite_macros.inc`,
`docs/research/sprite_format.md` and the headers of 7 files of `gfx/`); bit 7 of the id is the loop flag, not a flip bit; the far-call reason for ROM0 targets was wrong (the bank byte is 0); the counts of the first
note (22 parents became 21, the rules per kind, 1,567 became 1,464); the tool kept a stale rule (`; raw`), a dead `ld a` for an unusual spelling, one spelling of a ROM bank write, and left files modified when interrupted; `render_screens.py` could not read `ld a, BANK(Label)`;
three live object-table entries kept as `db` / `ds` were left numeric; 7 consumers with 15 operands were added; 25 tests were added after mutating the tool (26 of 65 mutants were killed by the first 19 tests,
56 of 65 by the 44 of reader R1; 47 tests now).

## 5. Findings and open points

* **The id of an object is 6 bits.**  `Sprite_LoadObjectEntry` (00:0AB8) computes `DE + ((4 * (id & $7F)) mod 256)`: an id of 64-127 reads the entry of id - 64 (no site uses one: the largest constant is 11).  A table of
  more than 64 entries (`MailSession_ObjTable_72FB` has 164, `..._6F20` 72, `Table_SpriteCounter_Digits` 80) is reachable only through bases that start at an entry N: that is why 38 + 9 + 9 of the new labels exist.
  Bit 7 of the id is stored at slot `+$0F` and decides whether the script restarts (set) or stops on its last frame (clear); 499 of the 706 constant ids have it set.
* **Dynamic evidence of the rule `Sprite_InitSlot`** (reader R2, a tracer hook at 00:0A82 in 21 of the natural scenarios, byte-identical coverage): 33,739 executions of 435 sites, every one with DE = the label address,
  A = its bank and HL = the slot, and the slot filled with the entry read at `DE + ((4 * (B & $7F)) & $FF)` of bank A.  The 277 pointer operands in code that never ran rest on the static proof.
* **Three object-table entries kept as `db` / `ds`** were refused by the tool (the line is not a `sprite_object_entry`) and are live code (`register_config.asm:63`, `help_menu.asm:128`, `mobile_dictionary.asm:415`):
  they are written by hand with `Table_5D_7318` (the all-zero entry 0 of a table whose entry 1 is `Data_5D_731C`), `Table_6A_64AE` (an entry that crosses the end of its block: three bytes here, the fourth in the next
  block) and `Objects_MobileDict_Entry2` (entry 2 of the 13 entries of `Objects_MobileDict`).  Two roots of `sprite_chain_check` that had no entries walked now have 2 and 1.
* **Blocks typed as tiles that also hold a palette or a tilemap** (reader R3, R4): `Palette_LoadToBuffer` and `Tilemap_CopyRectAndAttr` read their source inside a `.2bpp` block that its own `Gfx_StartHDMA` loads whole: 13
  palette and 9 tilemap pointers lie in such blocks (for example 5E:72C0 is +800 and 5E:7300 is +864 of the 1,024-byte block at 5E:6FA0, `gfx/account/screens_bank5e.asm:139`).  Four labels have the wrong kind of block
  behind them: `Data_4D_5510` (`gfx/settings/screens_bank4d.asm:55`: tiles, then the BG palette `$5510`, the OBJ palette `$5538` and a tilemap `$5540`), `Palette_Account_ConfirmScreen_Bg` (5D:65F0) and
  `Palette_Account_ConfirmManualScreen_Bg` (4A:5C70) declared as `.2bpp`, and `Tilemap_ConnectDialog_ConnectConfirm_56_526A` (a 20x2 tilemap declared as `.2bpp`).  They are not renamed here: the next graphics pass
  splits the blocks by the evidence of their consumers.
* `ld hl, $013F` (`lib/mobile/main.asm`, copied by `MobileSDK_CopyBytes`) is the 4-byte game code of the cartridge header: below `$0150`, so a number; the header has the single label `Header` (00:0104), and
  `Header + $3B` is the faithful spelling for a later pass.
* ROM0 hooks (`ld de, Sprite_HookAddSlideOffset / ld a, $00`, 7 sites) keep `ld a, $00`: A = 0 means "keep the bank" for `Gfx_StartHDMA` and `Tilemap_CopyRect*`, and a hook of ROM0 needs no bank.
* 51 calls pass an HL that was derived from a table (`ld hl, Table / add / ld a, [hli] / ld h, [hl]`) and about 25 pairs store the two halves of a ROM pointer as bytes (`ld a, LOW(...)` into `wRam_C10E/C10F`,
  the attribute source of `Tilemap_CopyRectAndAttrPtr`): neither is an immediate that a rule can name.
* `MailResult_SetReceivedSprite` (29:4374) keeps HL (push/pop) and reads the pointer after the call: a pass-through consumer, not written.

## 6. Left numeric

* **103 operands of a consumer that has a rule**: 82 `no label` (the target is inside a block) + 18 `not a table entry` + 3 `vector or null` (below `$0150`).  The 100 pointers by target (readers R3 and R4, about 85 distinct targets): 43 inside a `.2bpp`
  block (21 HDMA tile ranges at multiples of 16 bytes, 22 palettes and tilemaps inside a tile block: see section 5), 23 inside a `.pal` file (22 at multiples of 8: palette k of a bigger file, for example `Palette_5F_4CD0 + $10`
  at 8 sites), 10 sub-rectangles of a `.tilemap` (the help screens), 6 inside a `db` line (3 HDMA, 2 `CopyString`, 1 palette), 16 string `db` lines that no label starts (`TextTiles_Render*`: `String_ConnectDialog_Messages`
  + $47 and so on) and 2 palette `db` rows.  A label before the line (the last 18) and `Label + offset` or a line split (the others) are the next pass.
* **1,449 operands in `$0150-$7FFF` whose consumer has no rule**, by reading (R3): 410 Y,X pairs of `Sprite_SetPosition`; 164 + 17 + 7 + 19 (rows, columns) of the `Tilemap_*` routines; 72 `FillBytes`, 9 `CopyBytes` and
  6 `PageCache_Pop` counts; 49 `Divide16` divisors; 57 `Tilemap_FillAscendingWithAttr`; `TileCanvas_UploadRect` / `FillRect` (HL 41 + 35 is a (row, column) pair that the routine turns into a `$D000`-based address,
  BC 37 + 37 counts); 208 operands of the `*_DrawLine*` families (BC a canvas descriptor, DE Y,X pixels); and the loads without a call after them (`(none)`: 237 operands).  Reader R4 read the 237: 126 are not pointers
  (45 byte counts, 39 (list, entry) index pairs for `Dialog_Show` / `Dialog_Open`, 17 offsets, 8 Y,X pairs, ...) and 111 are ROM pointers (38 read directly through `[hl]` / `[hli]` / `[de]`, 56 table bases with an index
  added, 8 attribute-map sources stored in WRAM, 4 return addresses, 5 behind a join); about 44 of those pointers already have an exact label.  They need new proof classes (a direct read of the mapped ROM bank, a
  base added to an index, a pushed address, a conditional call in front of a consumer) and are the work of the next pass, with the far pointer of `ConnectDialog_Run` (bank in D, 1 site) and the interior pointers of
  `Dialog_SlideIn` / `Dialog_SlideOut` (2 sites).

## 7. Reproduce

```
make && python3 tools/apply_rom_operands.py --check      # exit 0: nothing left that a rule proves
python3 tools/apply_rom_operands.py --dry-run --report out.tsv   # what a run would write, one row per candidate (builds a marked copy in a temp directory, needs rgbasm; writes nothing in the tree)
python3 tools/test_rom_operands.py                       # 47 tests (no build needed)
python3 tools/sprite_chain_check.py                      # exit 0: the 712 sites, the 49 roots and the 159 entry labels
```

On the tree of commit 1c16727 (before the pass): the three manual sites (a patch of `gfx/` and `engine/`, section 5) and `python3 tools/apply_rom_operands.py` (it needs rgbasm, builds a marked copy and the tree) write the 705
pointers, 1,367 - 3 bank loads and 158 labels and end with `SHA-256 OK`.  `gfx/previews/` is not regenerated (it needs emulator captures); its `screen_ops.tsv` would differ from `render_screens.py ops` only in the
label column of the loads that this pass names.
