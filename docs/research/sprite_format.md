# Sprite object data format (object tables, frame tables, frame records, scripts) and its macro form

The sprite-object engine in bank 00 (`home/sprites.asm`: `Sprite_InitSlot` 00:0A82, `Sprite_LoadObjectEntry` 00:0AB8, `Sprite_StepAndDrawSlot` 00:0AE8, `Sprite_UpdateAll` 00:0956) reads four kinds of data from a switchable ROM bank.

## 1. Summary

| question | result | status |
|---|---|---|
| object table entry | 4 bytes: `dw frame_table, dw script`; entry used = `DE + 4 * (id & $3F)` (`(id & $7F) * 4` is kept in 8 bits: the carry of the two `add a, a` is lost, so an id of 64-127 reads the entry of id - 64; no site uses one) | CONFIRMED (00:0AB8-0ABF, 0AC5-0ACA, 0ACE-0AD4) |
| bank of the pointers | none stored: the ROM bank passed in `A` to `Sprite_InitSlot` is selected (`ld [$2100],a`, 00:0A8F) and stored at slot+0E; all four structures are read from that bank | CONFIRMED (00:0A82-0AB7 and 0AA1-0AA7; 00:097D-098A: slot+0E is fed to `BankSwitch_B` before each slot is stepped) |
| frame table | array of `dw`, word *k* = address of the frame record of frame index *k* (`HL = table + 2*index`) | CONFIRMED (00:0B91-0B99) |
| frame table length | not stored; implied | PROBABLE (see section 4) |
| frame record | `db n`, then `n x (db y, db x, db tile, db attr)` = `1 + 4n` bytes | CONFIRMED (00:0B9A-0BB8) |
| y, x | added (mod 256) to slot Y + 16 and slot X + 8 to give OAM Y / X | CONFIRMED (00:0B80-0B87, 0B9E-0BA5) |
| tile | copied to the OAM tile byte unchanged | CONFIRMED (00:0BA6-0BA8) |
| attr | OAM attribute byte = `(attr AND slot+0A) OR slot+09`; the slot masks are `$FF` / `$00` after `Sprite_LoadObjectEntry` | CONFIRMED (00:0AD5-0AD9, 0B75-0B7D, 0BB0-0BB3); writers of the masks elsewhere: not searched (open question 2) |
| meaning of the attr bits | standard CGB OAM attribute: bits 0-2 palette, bit 3 VRAM bank, bit 5 X flip, bit 6 Y flip (bits 4 and 7 never occur) | PROBABLE (section 5) |
| script | `db n`, then `n x (db frame_index, db delay)` = `1 + 2n` bytes | CONFIRMED (00:0B0A-0B35, 0ADA-0AE0) |
| script end | bit 7 of the object id (stored at slot+0F) set: wrap to step 0; clear: stop stepping | CONFIRMED by the code (00:0B13-0B21); data: 499 of 706 Sprite_InitSlot sites with an immediate `B` set bit 7 |
| frame index `$FF` | draws nothing | CONFIRMED (00:0B8D-0B8F); no script of the ROM uses it |
| what the numbers mean on screen (which object is a cursor, an icon, ...) | not derived here | out of scope; the names of the blocks (`<Stem>_Anim<N>...`) are PROBABLE (naming pass 2) |

## 2. Where the engine reads what (slot layout as the code uses it)

A slot is 16 bytes in WRAM bank 7 (`wSpriteSlots`, 14 slots at D:DA00, walked by `Sprite_UpdateAll`).

| slot | used as |
| --- | --- |
| +00 Y, +01 X | position of the object (screen coordinates; the record offsets are added to Y+16, X+8) |
| +02..03 | frame-table pointer (from entry word 0) |
| +04 | current frame index (`$FF` = none), first loaded from script byte 1 |
| +05 | delay counter, first loaded from script byte 2 |
| +06..07 | script pointer (from entry word 1); cleared when a non-looping script ends |
| +08 | index of the current script step |
| +09 / +0A | attribute OR mask / AND mask (initial `$00` / `$FF`) |
| +0B..0D | hook: address (lo, hi) and bank, called through a push-return trick, `$FF` bank or zero address = none |
| +0E | ROM bank of all the structures (the `A` of `Sprite_InitSlot`) |
| +0F | the object id including bit 7; `$FF` = empty slot, `$00` = slot that is not stepped |

One pass of `Sprite_UpdateAll` does, for each slot: select the slot's ROM bank, `Sprite_StepAndDrawSlot`.  The draw part (from 00:0B71) runs for every slot, also for one
whose stepping has stopped (+0F = 0): the last frame keeps being drawn (PROBABLE: static reading, the draw code never tests +0F); a slot filled with `$FF` (`Sprite_ClearSlot`,
`Sprite_ResetAll`) has frame index `$FF` and draws nothing.  OAM entries are written from shadow OAM `C004` upward (00:096F: `ld de,$C004`), `C000-C003` is not written by this engine,
and there is no bound check against the 40 OAM entries.

Sprite_UpdateAll is followed by `VBlank_WaitAndService` in the wait loops that call it (for example `Sprite_WaitFrames` 4C:5111), so one pass is one frame there (PROBABLE).

## 3. Object table

```
entry (4 bytes)   dw FrameTable, dw Script
table             entry k at base + 4k;  k = object id & $3F (the id & $7F of earlier notes is wrong for ids of 64 and above: 00:0ABB-0AC4 loses the carry)
```

* `Sprite_LoadObjectEntry` (00:0AB8): `id & $7F`, times 4 **in 8 bits** (so `id & $3F` in effect), added to `DE`; word 0 -> slot+02/03, word 1 -> slot+06/07; then `inc bc` past the script's count byte and
  script byte 1 / 2 (first frame index, first delay) -> slot+04/05; slot+08 = 0, slot+09 = 0, slot+0A = `$FF`; the whole id (bit 7 included) -> slot+0F.  CONFIRMED.
* The id selects the pair (frame table, script) and nothing else does: in the walked data the pair is 1:1 (no frame table with two scripts, no script with two frame tables).
  CONFIRMED for the data of this ROM (`sprite_chain_check.py`).
* **Entry 0.**  An id of `$00` stores +0F = 0, which the step code treats as a slot that is never stepped (00:0AF3-0AF4); entry 0 can still be used as id `$80`
  (12 sites of `Sprite_InitSlot` load an immediate `B = $80`).  So "entry 0 is unused" is **not** true of every table: of the 49 tables, 14 have a null entry 0 (`dw 0, 0`)
  and 35 a real one.  (The region headers that say "entry 0 is unused (zero)" describe the first kind only.)
* Object tables of this ROM: 712 call sites of `Sprite_InitSlot` (= the 712 `CD xx xx 82 0A 00` byte patterns), 47 tables with entries found by the chain walk plus 2 more
  (5D:7318 and 6A:64AE) that the converter finds from the exact `ld de,imm` operand because the checker's group-start rule fails for them; 924 entries in all, 20 of them null.
  Many tables have **rows of four identical entries** (ids `4r..4r+3`, `MailResult`, `Mailbox`, ...): the code loads the row with `B = $81` from `table + 16*row`, i.e. id `4r+1`; why the
  ROM has four copies is unknown (open question 5).
* Macro: `sprite_object_entry FrameTable, Script` (`dw`, `dw`); a null entry is `sprite_object_entry 0, 0`.  The generator appends `; entry N` (N = index from the start of the table).

## 4. Frame table and frame record

```
frame table        dw Record0, Record1, ...              (no count byte)
frame record       db n ; n x ( db y, db x, db tile, db attr )
```

* `Sprite_StepAndDrawSlot` (00:0B8C-0B99): `frame index` (slot+04) `* 2 + frame-table pointer` (slot+02/03) gives the address of a word; the word is the record pointer.  CONFIRMED.
* Record loop (00:0B9D-0BB8), one iteration per piece: `OAM.y = byte0 + (slot.Y + 16)`, `OAM.x = byte1 + (slot.X + 8)`, `OAM.tile = byte2`, `OAM.attr = (byte3 AND [FFB1]) OR [FFB0]`
  where FFB0/FFB1 are slot+09 / slot+0A copied at 00:0B79-0B7D.  A count of 0 returns at once (00:0B9B-0B9C); the data has 11 such records.  CONFIRMED.
* The byte order (y, x, tile, attr) is the hardware's OAM order, so each piece is a raw OAM entry whose position bytes are offsets.  Offsets wrap mod 256; 591 of 2,704 y bytes and
  186 x bytes are `>= $80`, and the records look like small negative offsets (for example `$F2` = -14), so the macro writes them as signed numbers.  That is a display choice; the byte is the same.
* **Frame-table length** has no field.  Evidence used: every table is directly followed by its first record (the first word points at `table + 2*length`), and every frame index
  of every script paired with the table is below that length (0 violations over 291 tables).  PROBABLE: a table whose first record is not adjacent would be misread; none exists
  among the 291 (all 291 have an adjacent first record).  The macro `sprite_frame_table` therefore carries no count.
* Data: 291 frame tables (1-9 words, 146 of them with one word), 560 records (2,704 pieces, at most 31 per record).
* Macros: `sprite_frame n` followed by `n` lines `sprite_oam y, x, tile, attr`; `sprite_frame_table` with a label list (written four labels per line; several lines in a row are one table).
  The macros count the lines at assembly time (`_sprite_oam_left`): a missing or extra `sprite_oam` is an assembly error in the same file, so the byte stream cannot shift silently.

## 5. The attribute byte

The shadow OAM entries are copied to OAM by the OAM DMA routine (`OAMDMARoutine` 00:05AC: `ld a,$C0 ; ldh [rDMA],a`, CONFIRMED in `home/lcd.asm`), so the `attr` byte of a record reaches
the OAM attribute byte after the AND / OR masks (both are identity unless something changes slot+09 / +0A).  Bits that occur in the 2,704 pieces:

| bit | pieces | hardware meaning |
| --- | ---: | --- |
| 0-2 | 913 / 707 / 719 | CGB palette number (OBJ palette RAM is uploaded by `Palette_UploadBuffer` 4F:404B from `$D840`, `naming2_data2.md`) |
| 3 | 404 | VRAM bank 1 |
| 4 | 0 | (DMG palette: ignored on CGB) |
| 5 | 291 | X flip |
| 6 | 131 | Y flip |
| 7 | 0 | BG priority |

44 distinct attr values occur, all of the form `palette | bank1 | xflip | yflip`.  The corner patterns make the flip meaning PROBABLE (the geometry only works if the
hardware semantics apply); it is not CONFIRMED because no execution of a flipped sprite was looked at.  `sprite_oam` therefore writes the attr operand as `OAMF_XFLIP | OAMF_YFLIP | OAMF_BANK1`
(constants of `constants/hardware.inc`) plus the palette number as a plain number (a value below 8 is just the number).  The expression assembles to the same byte as the original.

## 6. Script

```
script       db n ; n x ( db frame_index, db delay )
```

* Step code (00:0AF6-0B35): slot+05 (delay counter) is decremented once per pass; when it is zero (or already zero) the step advances: index = slot+08 + 1; if it is below `n`
  the pair `(frame_index, delay)` at `script + 1 + 2*index` is loaded into slot+04 / slot+05.  CONFIRMED.
* When the index would reach `n`: if bit 7 of slot+0F is set the index wraps to 0 (00:0B13-0B1A, `bit 7,[hl]` then `jr nz`); if it is clear, slot+0F, slot+08 and the script pointer
  are cleared (00:0B1C-0B20) and stepping stops.  CONFIRMED (static).  The sites: 499 of 706 immediate `B` values have bit 7 (`$81` alone: 458 sites), 207 do not (`B = 1`: 196), for example
  the address-book list, whose entries 4-16 are loaded with `B = 1`; the one-step scripts (155 of 289: `01 00 04` and similar) are consistent with "show one frame, then stop".
* Delay: the step lasts `delay` passes (PROBABLE: static reading; a delay of 0 or 1 would both advance on the next pass and neither occurs: the delays are 2-120, 8 and 4 being the most common).
  The first step is loaded by `Sprite_LoadObjectEntry` rather than by the step code, so it is shown for one pass less (PROBABLE, same reading).
* Frame index `$FF`: not drawn.  No script uses a frame index above 8.
* Data: 291 scripts, 1-9 steps (155 with one step).  Macros: `sprite_anim n` followed by `n` lines `sprite_anim_step frame, delay` (counted at assembly time like the records).

## 7. The macro form and the generator

`constants/sprite_macros.inc` is pre-included by `includes.asm` (one `INCLUDE` line after `audio_macros.inc`).  Every macro emits exactly the bytes of the format above and nothing else.
Macro names say what the bytes are, not what a screen shows.

| macro | bytes | form |
|---|---|---|
| `sprite_object_entry FrameTable, Script` | 4 | `dw`, `dw` |
| `sprite_frame_table Rec0 [, Rec1 ...]` | 2 per label | `dw` list |
| `sprite_frame n` + `n` x `sprite_oam y, x, tile, attr` | `1 + 4n` | `db n`, then `db y, x, tile, attr` (y, x signed decimal, tile hex, attr as above) |
| `sprite_anim n` + `n` x `sprite_anim_step frame, delay` | `1 + 2n` | `db n`, then `db frame, delay` |

1. finds the structures with the walk of `tools/sprite_chain_check.py` (sites of `Sprite_InitSlot` -> object tables -> frame tables -> records and scripts, read from the original ROM) and    refuses to go on if two items overlap or a pointer does not land on an item of the right kind; 2. parses every region block (`; ---- kind $a-$b (n bytes)`, its labels, its db/dw/ds/macro lines) of `home/ engine/ lib/ gfx/ data/`, and regenerates the blocks that hold items: items become    macro lines, the other bytes stay `db` (comment "not reached by any walked sprite chain") or `ds` for zero runs of 8 bytes or more.

A target that has no label gets a role label `SpriteFrameTable_BB_AAAA:: ; BB:AAAA`, `SpriteFrame_BB_AAAA` or    `SpriteScript_BB_AAAA` (the kind of the structure is CONFIRMED, the name says nothing about the screen).

### Result (the state this note describes)

| | items | bytes |
|---|---:|---:|
| sprite items in the ROM (4 kinds) | 2,066 (entries 924, frame tables 291, records 560, scripts 291) | 17,587 |
| written as macros | 1,962 (entries 901, frame tables 270, records 520, scripts 271) | 16,233 |
| kept as `db` | 104 | 1,331 |
| bytes in the regenerated blocks that no walked chain reaches (kept `db`/`ds`; includes the tails of the 5 items that cross a block boundary) | | 343 |
| labels created | 580 | |

They are now `CommNotice_Anim{0,1}Frame0`, matching their index in the corresponding frame table; the following labels remain `...Frame1`.

This also makes the local extent agree with the one-record boundaries checked by `sprite_chain_check.py`.

* `home/sprites.asm` comment of `Sprite_StepAndDrawSlot`: the stale "layout inferred, HYPOTHESIS" annotation is removed.

* `gfx/address_book/address_picker.asm`, `$7354-$735F`: the formerly split count/first pair plus `$7357` data label are one confirmed five-pair script.

The last four pairs at `$7357-$735F` had been mislabeled as the start of a larger object-animation block; entries 12-15 in `Table_AddrSlotIcon_Anims` point to the script at `$7354`.

The full record is now expressed by `sprite_anim` macros and the broad misleading label is removed; the next structure begins at the frame-pointer table `$735F`.

* `tools/sprite_chain_check.py`: the `ObjAnimData` reach test omitted `Walk.rec_at`, so a block containing a reached frame record could be reported as unchained.

## 9. Open questions

**Unreached sprite data.**  343 bytes in regenerated blocks and part of the 1,331 bytes above are not reached by any walked chain (for example `01 00 04` scripts that no entry points to,    the candidate-format stream `MailServerMgr_CandidateSpriteData_2E_7710` through `_7720`).

**Who changes slot+09 / +0A** (the attribute OR / AND masks) after initialisation: only `Sprite_LoadObjectEntry` was found in the sprite engine; the whole ROM was not searched, so a screen    may still recolour or flip its sprites through them. 3.

**Delay and pass counts** (section 6) were read, not measured; "one pass is one frame" is PROBABLE for the wait loops that call `Sprite_UpdateAll`. 5.

**Why four identical entries per row** in 23 of the 49 tables: the code always loads id `4r+1` (`B = $81`), never `4r`; a per-direction or per-state variant that was never filled in is a HYPOTHESIS without evidence. 6.

**Frame-table length** has no field (section 4): any new table found later must be checked against its first record and its scripts before `sprite_frame_table` is used for it. 8.

```
make
python3 tools/sprite_to_macros.py --check          # exit 0: the tree is in macro form
python3 tools/sprite_to_macros.py --dry-run -v     # what a run would change / keep as db
python3 tools/sprite_chain_check.py                # 0 hard mismatches
```

## Bank 4A settings-menu sprite span retyped

`4A:5855-5870` is now represented by source macros and zero bytes rather than three slices of a 16-byte 2bpp asset.

The four OAM pieces at `4A:5855-5865` and two animation steps at `4A:5866-586A` are CONFIRMED by their structure and selected-entry pointer; the five trailing zero bytes at `4A:586B-586F` remain PROBABLE padding.

The legacy `.2bpp` and PNG remain unchanged outside the active catalogue, as a byte-view record; their hashes are documented in `docs/EDITING_IMAGES.md`.

## Adendo: item AdapterCheck de 80 bytes tipado

O antigo BIN/PNG deixou o catálogo e as regras ativas na tipagem, mas foi preservado como byte-view legada; nesta migração passa à subpasta legacy_byteviews sem mudança de bytes/pixels. A [nota de tipagem](adapter_check_object_data_80b.md) e o [mapa antigo→atual](gfx_resource_path_map.tsv) preservam a navegação. Isso fecha somente aquele item histórico, não os demais blocos listados, e não reescreve as contagens do passe original.

The former `gfx/mail_menu/mail_menu/palette_62b0.pal` was not a loaded palette.

The object entry at `1D:63B6` points to a nine-word frame table at `1D:62B0`; its targets are nine six-piece frame records from `1D:62C2` through `1D:638A`.

The unreferenced `2A:545C` candidate retains HYPOTHESIS; similarity alone does not supply its consumer.
