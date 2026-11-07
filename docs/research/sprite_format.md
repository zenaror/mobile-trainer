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
table             entry k at base + 4k;  k = object id & $3F
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
| 0-2 | 913 / 707 / 719 | CGB palette number (OBJ palette RAM is uploaded by `Palette_UploadBuffer` 4F:404B from `$D840`) |
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

The maintained source uses these macros for recognized sprite structures; unrelated bytes remain `db` or `ds`. `tools/sprite_to_macros.py` checks that the pointer walk and source blocks agree.

A target that has no label gets a role label `SpriteFrameTable_BB_AAAA:: ; BB:AAAA`, `SpriteFrame_BB_AAAA` or    `SpriteScript_BB_AAAA` (the kind of the structure is CONFIRMED, the name says nothing about the screen).

### ROM inventory

The ROM contains 924 object-table entries (20 null), 291 frame tables, 560 frame records and 291 scripts: 2,066 structures across 17,587 bytes. The pointer walk identifies reachable structures; other byte sequences remain unclassified unless a separate reference chain establishes their role.

## 9. Open questions

- Some sprite-shaped bytes have no known object-table reference; resemblance alone does not establish use.
- No whole-ROM writer search has established whether code changes slot attributes +09/+0A after initialization.
- Delay and frame-pass timing is inferred from static code; no frame-by-frame runtime measurement is claimed.
- Twenty-three of 49 tables contain four identical entries per row, while callers select `4r+1`; the reason is unknown.
- Frame tables have no explicit length field. A new table requires a boundary check against its records and scripts.

## Example: settings-menu sprite data (bank 4A)

The four OAM pieces at `4A:5855-5865` and two animation steps at `4A:5866-586A` are CONFIRMED by their structure and selected-entry pointer; the five trailing zero bytes at `4A:586B-586F` remain PROBABLE padding.

## AdapterCheck object data

The 80-byte AdapterCheck item has CONFIRMED object-data structure. This classification does not establish its runtime use.

The object entry at `1D:63B6` points to a nine-word frame table at `1D:62B0`; its targets are nine six-piece frame records from `1D:62C2` through `1D:638A`.

The unreferenced `2A:545C` candidate retains HYPOTHESIS; similarity alone does not supply its consumer.
