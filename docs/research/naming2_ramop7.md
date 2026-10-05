# Banked WRAM pointer operands (ramop7): sprite slots and the palette buffer written as names

> Status: **reference (current)** for the operands and expressions it rewrites.  Follows [`naming2_ramop6.md`](naming2_ramop6.md) (WRAM0, HRAM and register operands), which left the banked WRAM `$D000-$DFFF` and said why.
> Rules: [`analysis/naming2/wramx_consumers.tsv`](../../analysis/naming2/wramx_consumers.tsv), bank effects of routines: [`analysis/naming2/wramx_calls.tsv`](../../analysis/naming2/wramx_calls.tsv), edits made by reading:
> [`analysis/naming2/ramop7_manual.tsv`](../../analysis/naming2/ramop7_manual.tsv); tool: `tools/apply_ram_operands.py --areas wramx` and `--elements`; line to address mapper: `tools/line_addresses.py`;
> independent verification: [`naming2_verify_ramop7.md`](naming2_verify_ramop7.md).

## 1. Result

| item | count |
|---|---|
| banked WRAM pointer operands `ld hl\|de\|bc, $Dxxx` written as the name of their object | **1,535** in 85 files: 1,300 sprite slot pointers (`ld hl, wSpriteSlot3`, `ld hl, wSpriteSlot2 + $0B`), 229 palette buffer pointers (`ld de, wPaletteBufBg`, `ld de, wPaletteBufObj + $28`), 6 array bases and backup pages (`ld hl, wSpriteSlots`, `ld de, wSpriteSlotBackup`); 1,523 are what the tool derives from the rules (`connect_dialog_screen.asm:451` included), 12 were written by hand after reading (`ramop7_manual.tsv`) |
| `wSpriteSlots + N` expressions of the generated code written as `wSpriteSlotK + $xx` | **612** of 662 in 32 files: 522 by the tool, 90 proven by reading (`ramop7_manual.tsv`); 50 keep the old spelling: 4 ran under bank 1 in the replays, 46 have no proof of bank 7 (section 4) |
| new names in `ram/banked.asm` | 17: `wSpriteSlot0` .. `wSpriteSlot13` (bank W7, `$DA00 + 16 n`), `wPaletteBufBg` (W7, `$D800`, 64 bytes), `wPaletteBufObj` (W7, `$D840`, 64 bytes), `wSpriteSlotBackup` (W3, `$D900`, 256 bytes) |
| banked WRAM operands left numeric | 1,793 of 3,328: 1,723 without a consumer rule, 41 whose bank is proven but have no name yet (all `CopyBytes`), 15 `CopyBytes` whose bank is not 7, 14 values (`ld de, $D048` for `Sprite_SetPosition`) |
| ROM | byte-identical (`make`: `RESULT: IDENTICAL`; `sym-check`, the audits and the 30 tool tests pass; every changed line is an operand or an expression replaced by one of the same value) |

## 2. Why banked WRAM needs a rule and not a table

`$D000-$DFFF` is switched by `rSVBK`; the same address is another variable in every bank, so `ld hl, $DA00` alone proves nothing.  The sources show three different meanings of that very number:

* bank 7: the first of the 14 sprite slots (`Sprite_InitSlot` and its siblings select bank 7 themselves);
* bank 6: the start of a 1,536-byte dictionary history area (`engine/help/mobile_dictionary_view.asm`: `ld a, $06 / ldh [hWRAMBank], a / ldh [rSVBK], a / ld hl, $DA00 / ld bc, $0600 / call FillBytes`);
* bank 2: a text tile buffer (`ld a, $02 / ldh [hTextTiles_DestBank], a ... ld bc, $DA00 / ld de, $DB40 / farcall TextTiles_RenderLine`, three sites).

`$D800` has the same story: the palette staging buffer in bank 7 (`Palette_LoadToBuffer`, `Palette_UploadBuffer`), and the source of an HDMA tile copy to `$8800` under another bank (bank 2 at 15 sites, bank 3 at one).  A name from the number would have been wrong for some of the sites.
The pass therefore rewrites an operand only when the *routine that receives the pointer* proves the bank.

## 3. Method

**Consumer rules** (`analysis/naming2/wramx_consumers.tsv`; the tool's docstring is the specification).  The consumer of `ld hl|de|bc, $Dxxx` is the first `call`, `farcall` or tail `jp Label` of the straight line after the load, with only plain instructions in between that touch
neither the register nor a bank register (no label, jump, macro or data line).  A rule row says that this routine dereferences that register in bank N: `needs = -` when the routine selects the bank itself, `switch` when its caller does and the tool must show the bank
(below); `family` is a regular expression for the chosen name, so that a sprite rule can never write a palette name.  The name is the innermost object of `ram/banked.asm` for that bank.  A name states the bank in which the *consumer* dereferences the pointer; the caller's own
bank may be another one (311 of the executed `needs = -` sites run with the caller under a bank other than 7).

| consumer | register | bank | needs | sites |
|---|---|---|---|---|
| `Sprite_InitSlot` (00:0A82), `Sprite_SetPosition` (00:0A65), `Sprite_ClearSlot` (00:09E6), `Sprite_SetHook` (00:0A45) | hl | 7 | - (each saves the bank shadow, selects bank 7 and restores the saved bank) | 712 + 525 + 44 + 15 |
| `Palette_LoadToBuffer` (4F:4000) | de | 7 | - (selects bank 7 and leaves it) | 173 |
| `Palette_UploadBuffer` (4F:404B), `Palette_ReadHardwareToBuffer` (4F:400E) | hl | 7 | switch (observed: bank 7 only, 41 and 21 scenarios) | 31 + 5 |
| `ConnIcon_UpdateState` (69:4034) | hl | 7 | switch (called by `ConnIcon_Refresh` after it selects bank 7; also run by `Sprite_StepAndDrawSlot` as the hook of slot 8, with bank 7 selected) | 1 |
| `CopyBytes` (00:050C) | hl, de | 7 | switch, family `wPaletteBuf*` only | 16 |

**The bank proof** (`needs = switch`, and the `wSpriteSlots + N` expressions).  The tool scans the straight line backwards from the site, at most 60 lines.  The nearest write of the bank register must be the idiom `ld a, $0N / ldh [hWRAMBank], a / ldh [rSVBK], a`, or a call to a routine that
*sets* the bank.  The scan gives up at a global label; at an unconditional `ret`, `jp` or `jr` (what follows is another path, a fragment with its own entry); at a call to a routine that is not known to *keep* the bank, a conditional call, `rst`, a macro or a data line; and at a local label unless it
heads a loop whose body writes no bank register and calls only routines that keep it.  The routines it knows are in `analysis/naming2/wramx_calls.tsv` (27 rows: `keeps` = writes no bank register, or saves the shadow at entry and restores it at exit; `sets W7` = selects bank 7 and
does not restore: `Palette_LoadToBuffer`, `Tilemap_CopyRectAndAttr` and its two siblings, `Gfx_UploadBgMapBuffers(Di)`); an unlisted routine is unknown.  The first version of the tool ignored calls and fragments; the independent reader found the false accepts (section 6) and the table is the answer.

**The bank proof for expressions** (`--elements wSpriteSlots --observed`): the generator wrote the byte `$DA11` as `wSpriteSlots + 17` wherever it saw it, without knowing the bank.  An expression is re-expressed as `wSpriteSlot1 + $01` when the bank 7 is shown by the scan above (392
of 662), or because every replayed execution of the instruction ran under bank 7 only (`analysis/rambank/observed_banks.tsv`, `wram_mask` = `80`; 333 of 662; 203 are shown both ways): 522 in all.  `tools/line_addresses.py` gives the ROM address of a source line: it builds a
copy of the tree with a local label in front of every wanted line (a local label adds no byte) and reads the addresses from the `.sym` file; the build is proven unchanged by the SHA-256.  90 more were proven by the independent reader (dataflow over the routine and reading: the idiom
dominates every path, or the sole caller runs under bank 7) and are written by hand, each with its proof in `ramop7_manual.tsv`.

## 4. What the evidence changed

* **Four of the generator's names were wrong.**  `engine/browser/page_list.asm:2531,2532,2533,2535` (`ld [wSpriteSlots + 49], a` ... `ld [wSpriteSlots], a`, right after `farcall Dialog_Show`) ran under WRAM bank 1 in the one replay that executes them (`browser_bookmarks`), while the old name claimed bank 7.  The reader traced why with a write watch on
  `hWRAMBank` and `rSVBK`: the routine selects bank 7 at 24:51FF and is in bank 7 at the call (24:5237), but on return it is in bank 1.  `Sound_FrameService` sets `rSVBK` = 1 while the shadow `hWRAMBank` still says 7; `Stat_ScrollSplitHandler` fires in that window, saves the real `rSVBK` ($F9: bank 1)
  and on exit writes it into both the shadow and the register; `Dialog_Close` later restores that stale shadow into both.  So the four stores that restore three X positions and a Y after the dialog write the bank 1 bytes `$DA31/$DA21/$DA11/$DA00`.  The author's intent was bank 7 (HYPOTHESIS); the effective bank
  in the replay is 1 (CONFIRMED, the mechanism CONFIRMED by the write log); that it happens on hardware is HYPOTHESIS (it depends on where the STAT interrupt falls).  The same sequence exists, never executed, at `page_list.asm:2144-2148`, `save_sender_address.asm:481-484`, `page_list_prototype.asm:2263-2286, 2628-2633`
  and at `mail_viewer_sender.asm:84,85` (reverted: the first run had rewritten them): they keep the old spelling.
* The sprite slot record is now stated where it can be checked: `+0`, `+1` the position pair (`Sprite_SetPosition` stores D, E: PROBABLE as Y, X), `+$0B..+$0D` the per-frame hook (`Sprite_SetHook` stores E, D, A; `Sprite_StepAndDrawSlot` enters it with HL = the slot: `ConnIcon_UpdateState` is the hook of slot 8),
  `+$0E` the ROM bank of the animation table (`Sprite_InitSlot`), `+$0F` tested for `$FF` (the free-slot value that `Sprite_ResetAll` stores) and for `0` by `Sprite_StepAndDrawSlot` and `ConnIcon_UpdateState`; the rest of the layout in `home/sprites.asm` stays HYPOTHESIS.  Of the 647 decimal offsets of the old
  expressions, 596 address byte 0 or 1 of a slot (offset modulo 16): the code mostly moves objects (only 7 are literally `+0` or `+1`).
* `Sprites_SaveSlotsToBank3` / `Sprites_RestoreSlotsFromBank3` copy 256 bytes, not the 224 of the slots: the whole page `$DA00-$DAFF` of bank 7, to `$D900-$D9FF` of bank 3 (`wSpriteSlotBackup`).
* The palette staging buffer is `wPaletteBufBg` (8 palettes of 8 bytes) followed by `wPaletteBufObj`; `Palette_LoadToBuffer` copies 8 to 64 bytes (132 of its 173 sites copy a whole 64-byte half, 15 one palette: `de = wPaletteBufObj + $28` is object palette 5).  `$D880-$D9FF` of bank 7 hold three more 128-byte
  buffers used by the fade code (`PalFade_*`); they stay numeric until that code is read as a whole.
* `Palette_LoadToBuffer` leaves bank 7 selected, so a later `Palette_UploadBuffer` or `CopyBytes` without its own bank switch (`connect_dialog_screen.asm:451`) is in bank 7: the table `wramx_calls.tsv` lets the tool use that.

## 5. Left numeric: 1,793 operands

| family | sites | what is needed |
|---|---|---|
| no consumer found in the straight line (the register is used directly, a loop or a branch comes first) | 608 | per-site reading; the observed bank at the load is available for part of them |
| `Tilemap_*` (`CopyRectAndAttr` 163, `FillAscendingWithAttr` 43, ...) | 248 | all select bank 7 themselves: the buffers are the two screen buffers `$D000-$D3FF` (tile numbers) and `$D400-$D7FF` (attributes) of bank 7, which have no name yet (`Tilemap_ClearBuffers`, `Gfx_UploadBgMapBuffersDi`) |
| `Gfx_*` HDMA / GDMA sources (`Gfx_StartHDMAWithService` 121, ...) | 192 | the bank is the A argument (`BankSwitch_H`: A = 0 keeps the bank in force) or the idiom; then a name for the tile staging buffers |
| `TextTiles_*` (`RenderLine` 145, `RenderGrid` 23) | 175 | the bank is the value stored in `hTextTiles_DestBank` just before (a second idiom); the buffers of banks 2 and 3 are unnamed |
| generic memory routines (`CopyBytes`, `FillBytes`, `CopyString`, ...) | 123 | the bank in force: by the idiom, then a name for the object |
| mail, address book, text entry, account (`Mail*` 94, `Text*` 92, `Abook*` 47, `Wram3_*` 35, `Settings_*` 11) | 279 | banks 1, 3 and 5 hold named objects already (`wEditBodyBuf`, `wMailSessionBlock`, `wMail_*`, `wAcct*`); many sites would take a name once the bank is shown |
| other routines, `PageList*` | 98 | |
| proven bank 7 but no name (`CopyBytes`: `$D180`, `$D120`, ... in `engine/dialog/dialog.asm`, `frame_graphics.asm`) | 41 | names |
| `CopyBytes` whose bank is not 7 (15) and values (14) | 29 | |

By the bank that the replays saw at the load (a first estimate, not a proof): bank 7 about 430 sites (`$D000` x108 tile staging, `$DC00`, `$DE80`, `$D800`, `$D880`), bank 1 about 360 (`$D4C0`, `$D524`, `$D625`, `$D514`, `$D624`: the named mail edit and session buffers),
bank 2 about 255 (`$D000` x115), bank 3 about 185, bank 5 70, about 300 never executed with no idiom, about 110 under several banks.  The next step is names: the buffers of banks 2, 3 and 7 below `$D800` are unnamed.

## 6. What the independent reader found in the first version

Verdicts: 7 of 8 rules upheld and one corrected (the proof text of `ConnIcon_UpdateState` said "its only caller": it is also a sprite hook); all 1,516 operands upheld; of the 525 expression rewrites 523 upheld and 2 dropped (`mail_viewer_sender.asm:84,85`); the 4 left as "other bank" correct;
133 left as "bank not shown": 89 provable bank 7, 1 PROBABLE, 20 expected bank 1, 23 with no known entry.  The tool had false-accept classes: a call between the idiom and the site was never looked at (the stores after `farcall Dialog_Show` were taken as bank 7), the scan crossed an unconditional
`ret`/`jp` into unlabeled fragments, a loop head was passed although its body called a routine that leaves another bank, `farcall_raw` and numeric `[$FF70]` were invisible, upper-case registers were not seen, and a sprite rule would have written a palette name for `$D800`.  All are fixed (the
scan above, the family column, 8 new tests that reproduce them); the reader's attack script now leaves every case unchanged except the two safe ones.  The DEF comments of the palette buffers and the backup page had wrong counts and a false sentence (`Palette_LoadToBuffer fills one palette`) and are corrected.

## 7. Reproduce

`python3 tools/apply_ram_operands.py --areas wramx --dry-run` lists what the rules would rewrite and, by consumer, what has no rule; without `--dry-run` it rewrites, builds, checks the SHA-256 and `sym_check`, and restores every file on failure; `--check` lists the operands a rule proves that are still numeric.
`python3 tools/apply_ram_operands.py --elements wSpriteSlots --observed [--dry-run|--check]` does the same for the expressions (it builds a marked copy of the tree for the address mapping, about five seconds).  `python3 tools/test_ram_operands.py` runs the 30 tests.
`python3 tools/line_addresses.py file.asm:LINE ...` prints the bank and address of source lines.
