# RAM pointer operands (ramop6): WRAM0, HRAM and hardware register operands written as names

> Status: **reference (current)** for the operands it rewrites.  Follows [`naming2_ram3.md`](naming2_ram3.md) (operands that matched a ROM label) and [`naming2_sram4.md`](naming2_sram4.md) (SRAM).  Mapping record:
> [`analysis/naming2/ramop6_names.tsv`](../../analysis/naming2/ramop6_names.tsv); tool: `tools/apply_ram_operands.py` (`--check` audits); independent verification: [`naming2_verify_ramop6.md`](naming2_verify_ramop6.md).

## 1. Result

| item | count |
|---|---|
| pointer operands `ld hl\|de\|bc, $XXXX` written as the name of their object | **1,394** in 95 files (WRAM0 1,348, HRAM 18, hardware registers 28): 1,393 by the tool, 1 by hand (`$C819`); 201 of them are `name + $XX` inside a larger object; 194 use a neutral name (`wRam_C480`, `wRam_C240`, ...) |
| distinct objects named | 122 (the largest groups: `wGlyphBufLeft` 198, `wMobileSDK_PacketBuffer` 190, `wTimerAWarnFlags` 95, `wTimerEnable` 75, `wGlyphBufRight` 74, `wAttrUrlBuf` 62, `wMobileSDK_Window` 50) |
| operands left numeric on purpose | 65: 5 at an overlay alias base inside the alias's files, **39 values** (36 negative numbers in HRAM and the hardware registers, 3 sprite position pairs), 21 marked `; raw` with a reason |
| RAM definitions corrected | `wMobileSDK_PopServerName` size 24 -> 20 and a new 4-byte object `wMobileSDK_ServerIp` (`$C705`, PROBABLE); four phantom HRAM objects removed (`hRam_FF9C`, `hRam_FFA0`, `hRam_FFFA`, `hRam_FFFB`: no access anywhere, only loaded as numbers) |
| ROM | byte-identical (`make`: `RESULT: IDENTICAL`; `sym-check`, `tidy_comments --check`, `localize_labels --check`, `tree_check`, the overlay and banked audits and the tool tests pass) |

## 2. Method and rules

The generator wrote RAM names where code reads or writes a variable (`ld a, [wTimerEnable]`) but left every pointer *immediate* numeric (`ld hl, $C0A0`), because an immediate can be a constant.  `tools/apply_ram_operands.py` rewrites
the operand only (`ld hl, $C0A0` -> `ld hl, wGlyphBufLeft`, `ld de, $C0A3` -> `ld de, wGlyphBufLeft + $03`): the name is the same number, so no ROM byte changes.  Rules (the tool's docstring is the specification):

* the object is the innermost *semantic* object of `ram/wram.asm` / `ram/hram.asm` (`DEF name EQU $addr ; size N`, start <= address < start + N), the neutral name only when nothing semantic covers the address and the address is exactly theirs;
  the hardware registers use the names of `constants/hardware.inc`;
* **values stay numeric**: in HRAM and the registers an operand whose first use is `add hl, rr` (`ld bc, $FF9C ; add hl, bc` adds the number -100: 36 operands), a DE that goes to `Sprite_SetPosition` (a Y, X pair: 3 operands) and a BC that goes
  to `CommTime_DrawNumber` (the addend of a digit loop);
* an address that has a screen-local alias in `ram/overlays.asm` stays numeric inside the files of that alias (a window base such as `ld hl, $C0D4` clears 252 bytes, it is not the byte the alias names); a line whose trailing comment
  starts with `; raw` is a human decision and says why (21 lines: 8 more window wipes, 7 dead loads of `$C0A9` whose DE nobody reads, 2 scratch uses of `$C0A0` that are not glyph data, 2 bases of a mail-address string buffer at `$C27F`,
  2 bases of a 16-byte buffer at `$C10E`).

## 3. What the first version got wrong

The first version assumed that an immediate in HRAM is never a count and rewrote 1,431 operands.  The independent reader found 46 wrong ones: 30 HRAM/hardware-register constants (`ld bc, hRandomState ; add hl, bc` in the sound driver was the worst:
the number -2), three `wShadowOAM + $28/$40/$58` that are the X of a sprite position, seven dead loads written as `wGlyphBufLeft + $09`, two scratch uses of `$C0A0` (a password source, nine bytes copied from `$D524`), three `PopServerName + $14`
that are really a server IP, and one end-of-window pointer that had picked the name of a different variable.  The rules of section 2 came from those findings (the tool's first version had none of them); the corrected tree equals the reader's list
site by site, except that the three `$C705` operands use the new name `wMobileSDK_ServerIp` instead of staying numeric.  A phantom-object check followed: four HRAM names (`hRam_FF9C`, `hRam_FFA0`, `hRam_FFFA`, `hRam_FFFB`) existed only because the census had read those constants as addresses.

## 4. Findings on the way (the objects, not the operands)

* `wTimerEnable` and `wMobileFlags`: 33 of the 75 `wTimerEnable` sites test or set bits 1, 2, 3 and 7 as SDK state and error flags, while the `DEF` knows only bits 0 and 4 (timer enables): the name is narrower than its use.
* `wMobileSDK_PacketBuffer`: 79 of its 190 operands (`75:768F-75:7D47`, `MobileSDK_AuthBuildResponse` and the MD5 and Base64 helpers) use the tail of the buffer as MD5/Base64 scratch (state at `+$A0`, saved copy `+$D1`, state-pointer
  table `+$B0..B6`, temporaries `+$B8` (19 sites) and `+$BC`, pointers `+$C0/+$C2`, round tables `+$C5/+$C7`, flags `+$E1`): address-wise correct, and a name such as `wMobileSDK_Md5Work` would be PROBABLE (not applied).
* `wAttrUrlBuf` is also a bounce buffer of up to `$200` bytes (`Sram_CopyLongBlock`, `4C:4C03`), so it overruns its 256-byte `DEF` into `wRam_C480`; `wMobileSDK_ReplyTail` (4 bytes) is read as 5 at `75:67FA`.
* New: `wMobileSDK_ServerIp` (`$C705`, PROBABLE): the SDK copy of the config image is 20 (SMTP name) + 20 (POP name) + 4 bytes (`ld b, $2C` at `75:62D6`); the last 4 are tested for non-zero in `MobileSDK_HttpConnect` and `UrlMeasurePath` and copied
  with b = 4 into the Open-TCP packet.
* Neutral names that the sites suggest a role for (hypotheses, kept neutral): `wRam_C480` (44 operands: a mail wire/line buffer of at least `$200` bytes, the charset converters' HL/DE, a CR LF at +0), `wRam_C580` (its Shift-JIS twin, but also the
  6-byte BCD date record of `Mail_ParseDate`), `wRam_C240` (37: a request/command block), `wRam_C28F` (21: a settings scratch string), `wRam_C241/C243` (running totals of `Mail_BuildHeaderField`).
* The idiom `ld bc, $FF9C ; ... add hl, bc` (-100) and `ld bc, $FFF6` (-10) is the decimal digit extraction (subtract 100 until the sign bit shows, `CommTime_DrawNumber` and the loops at `74:49AC` and `75:4D8A`): the numbers are `-(256 - xx)`; `ld bc, -100` would assemble to the same bytes.

## 5. Not covered, and why

* **Banked WRAM `$D000-$DFFF`** (3,328 raw operands, 275 distinct values, about 2,000 at an address that has some name): the name depends on the bank, and for a pointer handed to a routine that switches the bank itself (`Sprite_InitSlot` with `hl = $DAxx`)
  the bank that counts is the callee's, not the site's; it needs the per-consumer reading of the SRAM pass and a proof of the bank (`analysis/rambank/observed_banks.tsv`, `config/ram_context.tsv`), not a rule.
* **ROM-range immediates** (3,954 operands, 767 distinct values): pointers into data that has no label at that address, or plain constants; the 43 that equal a label were read in `naming2_ram3.md` section 4.
* **VRAM** (709 operands): tile destinations carry the VRAM bank in bit 0 (`$8801` = `$8800` bank 1) and tilemap positions are addresses inside `$9800/$9C00`: a different, macro-sized question.

## 6. Reproduce

`python3 tools/apply_ram_operands.py --areas wram0,hram,io --dry-run` shows what it would do; without `--dry-run` it rewrites, builds, checks the SHA-256 and `sym_check` and restores every file on failure; `--check` lists the raw operands that are neither
values, overlay bases nor marked `; raw`; `python3 tools/test_ram_operands.py` runs the 14 tests.
