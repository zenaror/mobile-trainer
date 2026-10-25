# Banked WRAM pointer operands (ramop7): sprite slots and the palette buffer written as names

## 1. Result

| item | count |
|---|---|
| banked WRAM pointer operands `ld hl\|de\|bc, $Dxxx` written as the name of their object | **1,535** in 85 files: 1,300 sprite slot pointers (`ld hl, wSpriteSlot3`, `ld hl, wSpriteSlot2 + $0B`), 229 palette buffer pointers (`ld de, wPaletteBufBg`, `ld de, wPaletteBufObj + $28`), 6 array bases and backup pages (`ld hl, wSpriteSlots`, `ld de, wSpriteSlotBackup`); 1,523 are what the tool derives from the rules (`connect_dialog_screen.asm:451` included), 12 were written by hand after reading (`ramop7_manual.tsv`) |
| `wSpriteSlots + N` expressions of the generated code written as `wSpriteSlotK + $xx` | **612** of 662 in 32 files: 522 by the tool, 90 proven by reading (`ramop7_manual.tsv`); 50 keep the old spelling: 4 ran under bank 1 in the replays, 46 have no proof of bank 7 (section 4) |
| new names in `ram/banked.asm` | 17: `wSpriteSlot0` .. `wSpriteSlot13` (bank W7, `$DA00 + 16 n`), `wPaletteBufBg` (W7, `$D800`, 64 bytes), `wPaletteBufObj` (W7, `$D840`, 64 bytes), `wSpriteSlotBackup` (W3, `$D900`, 256 bytes) |
| banked WRAM operands left numeric | 1,793 of 3,328: 1,723 without a consumer rule, 41 whose bank is proven but have no name yet (all `CopyBytes`), 15 `CopyBytes` whose bank is not 7, 14 values (`ld de, $D048` for `Sprite_SetPosition`) |
| ROM | byte-identical (`make`: `RESULT: IDENTICAL`; `sym-check`, the audits and the 30 tool tests pass; every changed line is an operand or an expression replaced by one of the same value) |

## 2. Why banked WRAM needs a rule and not a table

* bank 7: the first of the 14 sprite slots (`Sprite_InitSlot` and its siblings select bank 7 themselves);
* bank 6: the start of a 1,536-byte dictionary history area (`engine/help/mobile_dictionary_view.asm`: `ld a, $06 / ldh [hWRAMBank], a / ldh [rSVBK], a / ld hl, $DA00 / ld bc, $0600 / call FillBytes`);
* bank 2: a text tile buffer (`ld a, $02 / ldh [hTextTiles_DestBank], a ... ld bc, $DA00 / ld de, $DB40 / farcall TextTiles_RenderLine`, three sites).

`$D800` has the same story: the palette staging buffer in bank 7 (`Palette_LoadToBuffer`, `Palette_UploadBuffer`), and the source of an HDMA tile copy to `$8800` under another bank (bank 2 at 15 sites, bank 3 at one).  A name from the number would have been wrong for some of the sites.
The pass therefore rewrites an operand only when the *routine that receives the pointer* proves the bank.

The name is the innermost object of `ram/banked.asm` for that bank.

| consumer | register | bank | needs | sites |
|---|---|---|---|---|
| `Sprite_InitSlot` (00:0A82), `Sprite_SetPosition` (00:0A65), `Sprite_ClearSlot` (00:09E6), `Sprite_SetHook` (00:0A45) | hl | 7 | - (each saves the bank shadow, selects bank 7 and restores the saved bank) | 712 + 525 + 44 + 15 |
| `Palette_LoadToBuffer` (4F:4000) | de | 7 | - (selects bank 7 and leaves it) | 173 |
| `Palette_UploadBuffer` (4F:404B), `Palette_ReadHardwareToBuffer` (4F:400E) | hl | 7 | switch (observed: bank 7 only, 41 and 21 scenarios) | 31 + 5 |
| `ConnIcon_UpdateState` (69:4034) | hl | 7 | switch (called by `ConnIcon_Refresh` after it selects bank 7; also run by `Sprite_StepAndDrawSlot` as the hook of slot 8, with bank 7 selected) | 1 |
| `CopyBytes` (00:050C) | hl, de | 7 | switch, family `wPaletteBuf*` only | 16 |

**The bank proof for expressions** (`--elements wSpriteSlots --observed`): the generator wrote the byte `$DA11` as `wSpriteSlots + 17` wherever it saw it, without knowing the bank.

The reader traced why with a write watch on   `hWRAMBank` and `rSVBK`: the routine selects bank 7 at 24:51FF and is in bank 7 at the call (24:5237), but on return it is in bank 1.

`Sound_FrameService` sets `rSVBK` = 1 while the shadow `hWRAMBank` still says 7; `Stat_ScrollSplitHandler` fires in that window, saves the real `rSVBK` ($F9: bank 1)   and on exit writes it into both the shadow and the register; `Dialog_Close` later restores that stale shadow into both.

So the four stores that restore three X positions and a Y after the dialog write the bank 1 bytes `$DA31/$DA21/$DA11/$DA00`.

* The sprite slot record is now stated where it can be checked: `+0`, `+1` the position pair (`Sprite_SetPosition` stores D, E: PROBABLE as Y, X), `+$0B..+$0D` the per-frame hook (`Sprite_SetHook` stores E, D, A; `Sprite_StepAndDrawSlot` enters it with HL = the slot: `ConnIcon_UpdateState` is the hook of slot 8),   `+$0E` the ROM bank of the animation table (`Sprite_InitSlot`), `+$0F` tested for `$FF` (the free-slot value that `Sprite_ResetAll` stores) and for `0` by `Sprite_StepAndDrawSlot` and `ConnIcon_UpdateState`; the rest of the layout in `home/sprites.asm` stays HYPOTHESIS.

* `Sprites_SaveSlotsToBank3` / `Sprites_RestoreSlotsFromBank3` copy 256 bytes, not the 224 of the slots: the whole page `$DA00-$DAFF` of bank 7, to `$D900-$D9FF` of bank 3 (`wSpriteSlotBackup`).

* The palette staging buffer is `wPaletteBufBg` (8 palettes of 8 bytes) followed by `wPaletteBufObj`; `Palette_LoadToBuffer` copies 8 to 64 bytes (132 of its 173 sites copy a whole 64-byte half, 15 one palette: `de = wPaletteBufObj + $28` is object palette 5).

`$D880-$D9FF` of bank 7 hold three more 128-byte   buffers used by the fade code (`PalFade_*`); they stay numeric until that code is read as a whole.

* `Palette_LoadToBuffer` leaves bank 7 selected, so a later `Palette_UploadBuffer` or `CopyBytes` without its own bank switch (`connect_dialog_screen.asm:451`) is in bank 7: the table `wramx_calls.tsv` lets the tool use that.

## 5. Left numeric after this pass: 1,793 operands (the next pass, [`naming2_ramop8.md`](naming2_ramop8.md), names the two screen buffers: 1,490 are left)

| family | sites | what is needed |
|---|---|---|
| no consumer found in the straight line (the register is used directly, a loop or a branch comes first) | 608 | per-site reading; the observed bank at the load is available for part of them |
| `Tilemap_*` (`CopyRectAndAttr` 163, `FillAscendingWithAttr` 43, ...) | 248 | five select bank 7 themselves, `Tilemap_ApplyMaskRect` takes the bank in A: the buffers are the two screen buffers `$D000-$D3FF` (tile numbers) and `$D400-$D7FF` (attributes) of bank 7, which have no name yet (named in the next pass, `naming2_ramop8.md`) |
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

Verdicts: 7 of 8 rules upheld and one corrected (the proof text of `ConnIcon_UpdateState` said "its only caller": it is also a sprite hook); all 1,516 operands upheld; of the 525 expression rewrites 523 upheld and 2 dropped (`mail_viewer_sender.asm:84,85`); the 4 left as "other bank" correct; 133 left as "bank not shown": 89 provable bank 7, 1 PROBABLE, 20 expected bank 1, 23 with no known entry.

The tool had false-accept classes: a call between the idiom and the site was never looked at (the stores after `farcall Dialog_Show` were taken as bank 7), the scan crossed an unconditional `ret`/`jp` into unlabeled fragments, a loop head was passed although its body called a routine that leaves another bank, `farcall_raw` and numeric `[$FF70]` were invisible, upper-case registers were not seen, and a sprite rule would have written a palette name for `$D800`.

The DEF comments of the palette buffers and the backup page had wrong counts and a false sentence (`Palette_LoadToBuffer fills one palette`) and are corrected.

`python3 tools/apply_ram_operands.py --elements wSpriteSlots --observed [--dry-run|--check]` does the same for the expressions (it builds a marked copy of the tree for the address mapping, about five seconds).

`python3 tools/line_addresses.py file.asm:LINE ...` prints the bank and address of source lines.
