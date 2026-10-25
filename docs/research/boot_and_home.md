# Boot path and ROM0 ("home") of Mobile Trainer (Japan)

In the current tree (`home/ engine/ data/ gfx/ audio/ lib/`) a `Label_BB_AAAA` that is only used inside its own function is a local label of that function (`.lAAAA`, `AAAA` = the address, or `.loop`/`.done`/`.skip`); one referenced from elsewhere keeps its global name; `Function_BB_AAAA`, `Data_BB_AAAA`, ... are unchanged, and where a semantic name was adopted the neutral name often remains as an alias label under it.

**Addresses (`bank:addr`) remain valid**: find the code with `grep -rn '; BB:AAAA' --include=*.asm .` or in `build/mobile_trainer.sym`.

## 2. Layout of bank 00

| range | content | status |
|---|---|---|
| `0000-003F` | 8 rst slots: `ret` + 7 zero bytes (no reached code uses `rst`) | CONFIRMED |
| `0040-0063` | 5 hardware vectors (`jp $CBxx ; reti ; 4 x 00`) | CONFIRMED |
| `0064-00FF` | zero | CONFIRMED |
| `0100-0103` | `nop ; jp $0278` | CONFIRMED |
| `0104-014F` | cartridge header (see `docs/ROM_INFO.md`) | CONFIRMED |
| `0150-01B6` | `MobileAPI`, `ReturnMobileAPI` (bank-75 API shim) | CONFIRMED code, PROBABLE names |
| `01B7-0246` | `Int_Serial`, `Int_Timer` | CONFIRMED |
| `0247-0277` | wrapper calling `0F:4247` (no static caller) | PROBABLE |
| `0278-0391` | `Boot`, palette upload helpers, `Data_00_0352` (32 x `$7FFF`) | CONFIRMED |
| `0392-04A0` | frame service, `Int_VBlank`, three VBlank-wait variants | CONFIRMED |
| `04A0-05B5` | vector install, fill/copy, jump tables, joypad dispatch, OAM DMA image | CONFIRMED |
| `05B6-0683` | LCD on/off, CPU speed, bank-switch primitives | CONFIRMED |
| `0684-0748` | HRAM state init, far-call family | CONFIRMED |
| `0749-093A` | HDMA start, tilemap upload / rectangle helpers | CONFIRMED |
| `093B-0BBC` | sprite-object engine (14 slots in WRAM bank 7) | CONFIRMED code, layout HYPOTHESIS |
| `0BBD-0D33` | pixel/tile helper, multiply, `Random`, `Table_00_0C34` (256 bytes) | CONFIRMED |
| `0D34-0E92` | odd routine that writes ROM bank `$F0` and then loads a WRAM byte `[$C200+E]`, 32-bit multiply/divide, bank-7F data converters | CONFIRMED/PROBABLE |
| `0E93-1027` | alternative STAT handler, text byte-stream interpreter + `Table_00_0EF0` (32 pointers) | CONFIRMED |
| `1028-1353` | glyph drawing (far calls into bank 7F), keyword lookup, token scanner, bank-3F string lookup | CONFIRMED code, purposes PROBABLE/HYPOTHESIS |
| `1354-16A1` | string search, measure, copy/compare/xor-A5 helpers, far string getters, `Table_00_161A`, far byte read | CONFIRMED |
| `16A2-176F` | rect copy, three alternative interrupt handlers, `4F:47A5` wrapper, far-to-far copy | CONFIRMED |
| `1770-209F` | zero | CONFIRMED |
| `20A0-2182` | bank-04 gateway: 13 stubs, bank save/restore helpers, far-byte readers | CONFIRMED code, role PROBABLE |
| `2183-3FFF` | zero | CONFIRMED |

## 3. Boot flow (`Boot` = `00:0278`)

1. `0100 nop ; jp $0278`.
2. `0278`: `nop ; ldh [$FFA3],a` (A at entry: `$11` on a CGB); `call LCDOff` (`05BD`): LCD is on after the boot ROM, so it waits for
   LY in `$91-$97`, clears LCDC bit 7, `ei`, and **calls the frame service `0392` before any RAM has been initialised** (CONFIRMED: mGBA executes `05FE call $0392` at instruction 22).
   Whether `0392` then really enters `04:4082` depends on the power-on WRAM, which is undefined: `0392` needs `[C2BF]==0` and the stub guard `2129` needs `[D000]` bit7 clear.
   With zero-filled WRAM (our interpreter) it switches to bank 4 before the rKEY1 write; in mGBA (non-zero WRAM at power on) the guard sees D000 bits 7 and 6 set and returns `A=$FF` at `2125`,
   so `04:4082` first runs only after `04:4000`. Treat "bank 04 code runs before RAM init" as state-dependent (PROBABLE at best).
3. `027E`: `di ; TAC=IF=IE=0 ; [C2DF]=0 ; sp=$FFFE`.
4. `028C`: if `hBootA==$11`: `A=$80 ; call SwitchCPUSpeed` (`0602`: rKEY1=1, IF=IE=0, P1=`$30`, **STOP**, IF=0, IE restored) -> CGB double speed.
5. `0295`: `[$0000]=0` (SRAM disabled), `[$4000]=0` (SRAM bank 0).
6. `029C`: `hBootA!=$11` -> `02A2`: `ROM bank=6B ; call 6B:4C80 ; jr` **forever** (non-CGB error screen; interpreter: 6B:4C80 sets LCDC=`$81`, IE=1, halts). CGB continues at `02AE`.
7. `02AE`: rVBK=1, clear `8000-9FFF`; `for e=2..7: rSVBK=e, clear D000-DFFF` (0x1000 each); rSVBK=0, rVBK=0; clear `C000-DFFF`
   (WRAM0 + bank 1); clear VRAM bank 0; `sp=$CFFF`; clear HRAM `FF80-FFFD` (0x7E bytes; this also clears `hBootA`). All through `FillBytes` (`04D8`).
8. `02F7 call 059F`: copy the OAM-DMA routine to `$FF80`.
9. `02FA`: `hFFFC=0 ; [C2BF]=0`. `0300`: save `hWRAMBank`, `rSVBK=1` (mirror not updated), **`call 20A0`** = `call 20EE` (save ROM bank, select bank 4) + `jp 04:4000`; restore rSVBK.
   `04:4000` (interpreter run): `[D000]=$FF`, clears `D001-D03F` (keeping D001/D002), sets a few pointers (`D005=4A ...`), clears 8 x `$3C`-byte records at `D040` and 4 x `$18` at `D220`,
   writes `rNR52=$80, rNR51=0, rNR12/22/42=8, rNR14/24/44=$80, rNR30=0, rNR51=$FF, rNR50=$77`, `[D000]=0`, `jp 210B` (restore bank).
10. `030D`: `ROM bank=4F` (FF8A + `[$2100]`; bit 8 assumed 0), `call 4F:4717` (second-stage init; not analysed here in depth):
    `SCY=SCX=0, WY=$90, WX=$A7, BGP=OBP0=OBP1=$E4`, clear `C000-CAEF`, `FFA4-FFFD`, VRAM1, WRAM 2-7, VRAM0, APU (`NR50=$77, NR51=$FF, NR52=$80`),
    **`call 0684`** (HRAM bank state + trampoline), **`call 04A0`** (RAM vector stubs), `call 059F`, `[C2F5]=0`, `FarCall 7D:7BF0`,
    `call 0331` (BG+OBJ palettes all `$7FFF`), `LCDC=$83`, `IF=0`, `IE=1` (VBlank only), `ei ; halt ; nop ; ret`.
11. `0317`: `bc=1 ; di ; ROM bank = 0001 (FF8A/[2100]=1, FF8B/[3000]=0) ; ei`.
12. **Main loop** `0328: call FarCall ; dw $4000 ; db $1C ; jp $0328`. `1C:4000` (a 0x33-byte program): `FarCall 65:4000` once, then loop
    `FarCall 0E:4000` -> `call JumpTableInline` (A = index, no bounds check) with words `4019, 401D, 4028`: 0 = `jp 4007` (loop), 1 = `FarCall 7C:7B7C ; ld a,1 ; jp 4007`, 2 = `FarCall 7C:7D1F ; ld a,1 ; jp 4007`. CONFIRMED (bytes; `tools/cfg.py --seed 1C:4000 --table 00:0545` decodes it the same way).
    That `0E:4000` returns only 0..2 is an inference (HYPOTHESIS): `JumpTableInline` does not check the range. `A` is passed through `FarCall` into `0E:4000` (0 on the first call, `$19` after state 0 because `JumpTableInline` leaves `A=L` of the target, 1 after states 1/2); whether `0E:4000` reads it is unknown.
    Bytes `4016-4018` (`jp $4007`) and `401C` (`ret`) are unreferenced.

## 4. RAM code

All four kinds of RAM code found in reached code were reconstructed and executed on the interpreter.  There is no other copy loop in reached code (`tools/cfg.py`: only jumps into
`FFA8`, `FF80`, `CBF1-CBFD`, `C133`).

**RAM interrupt stubs `CBF1-CBFD`** (written by `00:04A0`, immediates verbatim):

```
CBF1: jp $03BA        ; VBlank   (vector 0040)
CBF4: reti            ; STAT     (vector 0048)
CBF5: 00 00
CBF7: jp $01ED        ; Timer    (vector 0050)
CBFA: jp $01B7        ; Serial   (vector 0058)
CBFD: reti            ; Joypad   (vector 0060)
```

**OAM DMA routine** (image at `00:05AC`, copied to `FF80-FF89` by `00:059F`: `ld hl,$05AC ; ld bc,$0A80` = count 10, `ldh [c]` destination `$80`), runs at `FF80`, called by `Int_VBlank` at `03C1`:

```
FF80: ld a,$C0
FF82: ldh [rDMA],a
FF84: ld a,$28
FF86: dec a ; jr nz,FF86
FF89: ret
```

**Far-call trampoline `FFA8-FFAF`** (initial bytes written by `00:0684`; the operands are patched by the far-call routines, see 7.3):

```
FFA8: ld a,$00        ; FFA9 = hFarCallA
FFAA: ld hl,$0000     ; FFAB/FFAC = hFarCallHL
FFAD: jp $06B7        ; FFAE/FFAF = hFarCallTarget   ($06B7 = idle loop: call 044B ; jr)
```

**VBlank chain copy `C130-C135` / `jp $C133`**: `48:4413-4452` saves the current STAT stub (`CBF4-CBF6`) to `C130-C132` and the VBlank stub (`CBF1-CBF3`) to `C133-C135`, installs `jp $16C4` (STAT) and `jp $16D4` (VBlank);
`00:16D4` clears SCX and `jp $C133` runs the saved original VBlank stub. `48:44A7-44C5` restores both.  CONFIRMED (bytes).

## 5. Interrupts

| vector | stub | default target | run-time replacements found (reached code) |
|---|---|---|---|
| `0040` VBlank | `CBF1` | `00:03BA` `Int_VBlank` | `jp $16D4` (48:4448, chained to the saved stub at `C133`); `jp $4D1F` (6B:4CD6) |
| `0048` STAT | `CBF4` | `reti` | `jp $16C4` (48:4437), `jp $16DC` (57:4537), `jp $0E93` (7F:727D); restored from `C130-C132` by 48 (`48:44A7`) and 57 (`57:46ED`); 7F (`7F:72B0`) just writes `reti` (`$D9`) to `CBF4` and leaves `CBF5/CBF6` stale |
| `0050` Timer | `CBF7` | `00:01ED` `Int_Timer` | none found |
| `0058` Serial | `CBFA` | `00:01B7` `Int_Serial` | none found |
| `0060` Joypad | `CBFD` | `reti` | none found |

* **`Int_VBlank` (`03BA`)**: unless `[C2F5]!=0` (`wOAMDMASuppress`) `call $FF80`; increments `[C2DF]` (`wVBlankFlag`, saturating at `$FF`); two frame->second->minute clocks   (`C2D4-C2D6` gated by bit 4 of `[C69F]`: when the minutes reach `$46` they are set back to `$3C`, seconds/frames to 0 and bit 1 of `[C26F]` is cleared; `C266-C268` gated by bit 0 of `[C69F]`: minutes saturate at `[C26D]`); `FFFC` counts frames in which the frame service did not run   (`C2BF==0`), `C2BF` cleared every frame.

* **`Int_Serial` (`01B7`)**: save AF/BC/DE/HL, save the 16-bit ROM bank, switch to bank `75`, `call 75:56D2`, restore bank, `reti`.

* **`Int_Timer` (`01ED`)**: `TAC=0`, `IF&=$1B` (clears the timer, and also bits 5-7 of IF); **if `[C709]==0` it returns at once (`01FE jr z,$0242`): `TIMA`/`TAC` are then NOT restarted, the timer stays stopped**.

Otherwise, if bit 1 of `[C6C1]` is clear and `rSC` bit 7 is clear: save ROM bank, `call 75:58EA`, restore; in every non-`C709==0` case then `TIMA=TMA`, `TAC=6` (enabled, clock select 10 = 65536 Hz, doubled in the CGB double-speed mode that Boot selects).

## 6. The main loop and frame structure

The ROM0 loop is only `FarCall(1C:4000)` repeated (section 3).  Frames are paced by the wait routines above (`ei ; halt` until the VBlank counter changes), which
also run the bank-04 service once per frame.  There is no polling of `rP1` in ROM0 (`hFFA5/hFFA7` are consumed by `JoypadDispatch` but produced in bank 7D / other banks, see 13).

### 7.1 Registers and mirrors (CONFIRMED)

| write | meaning | mirror in HRAM | ROM0 sites |
|---|---|---|---|
| `[$0000]` | RAM enable (`$0A` on / `0` off) | `FFF5` (only when enabled by the SRAM helpers) | see 7.7 |
| `[$2000]`/`[$2100]` | ROM bank low 8 bits | `FF8A` | see 7.7 |
| `[$3000]` | ROM bank bit 8 | `FF8B` | interrupt shims, `Boot`, `20EE/2105` only |
| `[$4000]` | SRAM bank | `FF8C` | see 7.7 |
| `rSVBK` | WRAM bank (not MBC, same convention) | `FF8D` | `BankSwitch_*`, `Boot`, ... |
| `rVBK` | VRAM bank | `FFF4` | `0684`, `0749`, `0787` |

Both `$2000` (interrupt shims, `20FF`) and `$2100` (everything else) are used for the low byte; MBC5 decodes `$2000-$2FFF`.  With 128 banks bit 8 is always 0; the code nevertheless saves/restores it (16-bit bank) in `MobileAPI`, `Int_Serial`, `Int_Timer`, `0247`, `20EE`.

### 7.2 Primitives selecting the register from the address region (CONFIRMED on the interpreter)

`BankSwitch_H (0622)`: **A=bank, H=high byte of the address about to be accessed**. `A==0` -> **no change**. H `<$80` -> ROM (`FF8A`,`[$2100]`); H `$80-$BF` -> SRAM (`FF8C`,`[$4000]`); H `>=$C0` -> WRAM (`FF8D`, rSVBK).
`BankSwitch_D (063D)` and `BankSwitch_B (0658)` are the same with D or B holding the address high byte. `GetBank_H (0673)` returns the current bank of H's region.
(One byte of "bank" therefore names a ROM, SRAM **or** WRAM bank depending on the address it is used with; this is what makes `FarCall` work for code in SRAM/WRAM banks.)

### 7.3 Far calls (all use the HRAM trampoline)

| routine | convention | notes |
|---|---|---|
| **`FarCall` `06D1`** | `call $06D1 ; dw target ; db bank` | A and HL reach the callee unchanged and the callee's A/HL come back; BC/DE pass through; **flags are clobbered** (`or a` in `BankSwitch_H`); continues after the 3 inline bytes. **The** far call. |
| `FarCall_Reg 06E5` | A=bank, HL=target, no inline data | no static caller found; callee sees stale `hFarCallA/HL` |
| `06BC` | `call $06BC ; dw target`, bank from `hFFF3` | 1 caller: `call $06BC` at `4F:4008` (inline word at `4F:400B` -> `00:050C` `CopyBytes`), bank byte from `hFFF3` |
| `FarJump 072E` | `call $072E ; dw target ; db bank` | tail jump, never returns here; no static caller found |
| `0716` | `call $0716 ; dw target`, bank from `hFFF3` | tail jump; no static caller |
| `JumpTableBank 0540` | A=bank of table, HL=table (words), C=index | switch then `jp [HL+2C]` |
| `JumpTableInline 0545` | A=index, **table of words inline after the call** | 27 raw call/jp patterns in other banks; e.g. `1C:400D`; does not return |
| `FarJumpTable 0551` | A=bank, HL=table of `(addr16, bank)`, C=index | switch to table bank, then to the entry's bank, `jp` |
| `JoypadDispatch 056A` | 5 inline words after the call | index = lowest set bit 0-3 of `(FFA5\|FFA7)`; `FFA7` is cleared |

For `FarCall_Reg`, the exact entry `00:06E5–06EE` writes FFF2 and FFAE/FFAF, then pops the return address; it does not write FFA9 or FFAB/FFAC. **CONFIRMED static effects:** with the trampoline opcodes installed by `00:0684` intact, `call $FFA8` in the common path therefore loads its previously stored A/HL operands, not the incoming bank/target pair. The common return path stores the callee's A/HL there. This explains the table's “stale” operands. The register-entry convention remains **PROBABLE**, without an identified caller or observed execution of its six entry instructions; arbitrary HRAM/interrupt contexts are not covered.

`FarCall` (`06D1-06E4`, common tail `FarCall_Common = 06EE`, exact sequence, verified by `rom0_selftest`):

```
06D1: hFarCallA<-A ; hFarCallHL<-HL ; pop hl (=address of inline data)
      hFarCallTarget<-[hl+] (lo,hi) ; hFFF2<-[hl+] (bank)
06EE: push hl                       ; return address after the inline bytes
      call GetBank_H  (H = return address high byte)   ; bank of the region the CALLER runs in
      push (H, bank)
      A=hFFF2, H=target hi: call BankSwitch_H            ; select the callee bank in the callee's region
      call $FFA8                                          ; trampoline: A/HL restored, jp target
      hFarCallA<-A ; hFarCallHL<-HL                       ; callee results
      pop hl ; A=L ; call BankSwitch_H                    ; back to the caller's bank (region of the return address)
      pop hl ; hFarCallTarget<-HL                         ; return address
      jp $FFA8                                            ; A/HL restored, jump to the return address
```

Consequences: (a) the bank restored is the bank of the region of the *return address*; for a ROM0 caller that is the ROM bank that was selected when the call was made; (b) a callee that changes the ROM bank
without restoring it (e.g. the sprite/bytecode routines of ROM0 that do `ldh [FF8A],a ; ld [$2100],a`) can be called safely from any bank **through FarCall with bank byte 0** (target in ROM0, `A==0` = no switch): 2239 of the 5274 static `FarCall` sites do exactly that (`0A82` x712, `0787` x456, `0956` x340, `08EA` x164, `0D67` x154, `09B6` x126, ...);
(c) only the low 8 bits of the ROM bank are handled by `FarCall` (bit 8 is not saved/restored by it).

### 7.4 Bank-04 gateway (`20A0-2182`, PROBABLE role)

Thirteen stubs `call <guard> ; jp 04:xxxx` (`20A0 -> 4000` init, `20A6 -> 4082` per-frame service, `20AC..20EB` -> `41C0 4287 42C0 43DC 4429 42EC 444B 44B1 452C 445C 42D6`, 368 raw call sites of `20AC`, 61 of `20E8`, ...). The guard `2116` sets bit 7 of `[D000]` and
selects bank 4 through `20EE` (saving `FF8B/FF8A` in `D002/D001`); if bit 7 is already set the stub **returns `A=$FF` to its caller** without running (`2125`). `20A6` uses `2129`: if bank-4 code is already active it sets bit 6 and stores the
stub address for later (`D003/D004`) instead of nesting; `2141` (15 call sites inside bank 04) ends a bank-04 routine: it restores the bank, or, if a deferred stub is pending, `ret`s into it. `215E/216F` read 1/2 bytes from an arbitrary 9-bit ROM bank held in `D026/D027` and
return to bank 4. Bank 04 looks like a sound driver (APU writes in `04:4000`, per-frame update through the frame service, note/song data read from other banks through `215E`), but this is not proven.
**Caveat**: `D000-D004`/`D026/D027` are banked WRAM (`rSVBK`), so the guard state is that of whichever WRAM bank is selected when a stub is called; `Boot` and `0392` select bank 1 first, other callers must do the same for the guard to be consistent (not checked here).

### 7.5 Call sites of the primitives inside ROM0

| routine | ROM0 sites (`addr` = call/jp instruction; constant arguments recovered by back-scan) |
|---|---|
| `BankSwitch_H` (`0622`) | `0540`, `0551`, `0566`, `06F9`, `0709`, `0728`, `0743`, `074B`, `0782`, `0789`, `07C6`, `08CA`, `08EA`, `091C`, `0EDA`, `131A`, `1408`, `168E`, `16A2`, `1742` |
| `BankSwitch_D` (`063D`) | `08CF` [A=07], `08EF` [A=07], `0B45`, `0B6E`, `135E`, `16A7` [A=07], `1752` |
| `BankSwitch_B` (`0658`) | `098A` |
| `GetBank_H` (`0673`) | `06EF` |
| `FarCall` (`06D1`) | `0328` -> 1C:4000, `1053` -> 7F:405F, `1073` -> 7F:42C3, `109D` -> 7F:42C3, `10C0` -> 7F:4007, `10D5` -> 7F:42C3, `1587` -> 68:44FC |
| `FarCall_Inline16` (`06BC`) | (none in ROM0) |
| `FarCall_Reg` (`06E5`) | (none in ROM0) |
| `JumpTableBank` (`0540`) | (none in ROM0) |
| `FarJumpTable` (`0551`) | (none in ROM0) |
| `JumpTableInline` (`0545`) | `0589`, `058E`, `0593`, `0598`, `059C` |
| `JoypadDispatch` (`056A`) | (none in ROM0) |
| `FarJump` (`072E`) | (none in ROM0) |
| `FarJump_Inline16` (`0716`) | (none in ROM0) |

### 7.6 Other direct bank switching in ROM0

| ROM0 site | bank | target | use |
|---|---|---|---|
| `0182` (`MobileAPI`) | `75` | `75:4030` | API entry |
| `01CD` (`Int_Serial`) | `75` | `75:56D2` | serial handler body |
| `021F` (`Int_Timer`) | `75` | `75:58EA` | timer handler body |
| `025B` | `0F` | `0F:4247` | wrapper `0247` |
| `02A6` | `6B` | `6B:4C80` | non-CGB screen |
| `0311` | `4F` | `4F:4717` | second-stage init |
| `031E` | `01` | (bank 1 selected for the main loop) | |
| `0D3B` | `F0` | none (a `ld a,[de]` follows) | odd routine `0D34`: writes ROM bank `$F0` (wraps to `$70` on 128 banks) but then loads `[$C200+E]`, a **WRAM** byte, so the bank write is useless |
| `0E2E, 0E7A` | `7F` | restored by bank-7F data converters | |
| `1325, 136F, 13C1` | `3F` | data `3F:4000` (word table) | string lookups |
| `1556` | `65` | data `65:567F` (word table) | `153D` |
| `159C` | `68` | data `68:67AE` (word table) | `1586` |
| `171C` (`1711`) | `4F` | `4F:47A5` | wrapper |

## 8. Hardware register accesses in ROM0 (from `analysis/rom0_hw_accesses.tsv`)

| register | access | sites |
|---|---|---|
| rP1 `FF00` | W | `0617` (`$30` before STOP); never read in ROM0 |
| rSB `FF01` | none | ROM0 never touches the serial data register |
| rSC `FF02` | R | `0207` (timer handler: skip when a transfer is running) |
| rTIMA/rTMA/rTAC | W/R/W | `023C, 023A, 01F2/0240/0280` |
| rIF `FF0F` | R/W | `01F4, 01F8, 0282, 05CE, 05E3, 0611, 061C` |
| rIE `FFFF` | R/W | `0284, 05C9, 05D0, 05E6, 0603, 0613, 061F` |
| rLCDC `FF40` | R/W | `044C, 0465, 047B, 05B6/05BA, 05BD, 05DC/05E0, 05F7/05FB, 0764, 07A2, 08B7` |
| rSCY/rSCX/rLYC/rWY | W (WY R) | `0EAE, 0EB8, 16FB, 1709` / `16D0, 16D6` / `0EA6, 0EBB, 1703, 170D` / `16E3` |
| rLY `FF44` | R | 12 sites (VBlank waits, HDMA start, STAT handlers) |
| rDMA `FF46` | W | only inside the HRAM routine (`05AE`) |
| rKEY1 `FF4D` | R/W | `0606, 060E` (speed switch) |
| rVBK `FF4F` | W | `02B0, 02D4, 06B4, 0761, 079F` |
| rHDMA1-5 `FF51-55` | W | `074F-0774` and `078D-07B2` (two copies of the HDMA start routine) |
| rBCPS/rOCPS `FF68/6A` | W | `0333`, `033F` (data via `ldh [c]` at `034D`) |
| rSVBK `FF70` | R/W | 41 writes |
| sound registers | none | the APU is programmed by banks 04/4F |

Serial-related observations (facts only): the serial *interrupt* is routed to `75:56D2`; the timer interrupt (`TAC=6`: 65536 Hz, 131072 Hz in double speed; reloaded from `rTMA` unless `[C709]==0`) is routed to `75:58EA` and is skipped while `rSC` bit 7 is set (transfer in progress);
`MobileAPI` gets its index in A. There is no evidence in ROM0 that the API has anything to do with the Mobile Adapter beyond the structural match with pokecrystal's Mobile SDK shims (finding 7).

## 9. Text/bytecode interpreter (`0ED3`, PROBABLE) and lead bytes (CONFIRMED)

`0ED3`: A=bank, HL=string pointer; bytes `<$20` jump through `Table_00_0EF0` (handlers entered with the string pointer on the stack), others are characters.  Control bytes (from the table):
`00,08,0A-0C,0E-1B` -> `0F9D` (end / return from a sub-string), `01` -> `0F83` (call sub-string: addr16+bank, depth `FFBF`), `02` -> Y=next byte, `03` -> X=next byte, `04-07` -> fixed positions (Y,X)=(3,0),(1,0),(2,0),(0,2),
`09` -> X+=`$30` (tab), `0D` -> `0F68` (newline: X=`FFC1/2`, Y+=`FFC6`, stop when past `FFC3`), `1C` X=word, `1D` Y=byte, `1E` X+=word, `1F` Y+=byte.
Character test (`0F30`, `1028`, `10B1`, `1408`): **lead bytes `$81-$9F`, `$E0-$EF`, `$F8-$F9` take a second byte** (double-width glyph, 12 px) - a Shift-JIS-style encoding; other bytes are single width (6 px); tab = `$30` px.
Glyph drawing goes through far calls into bank 7F (`7F:405F`, `7F:42C3`, `7F:4007`) with coordinates in `FFBC/FFBD` and parameters in `FFBA/FFBB` (`hTextY`, `hTextX` are PROBABLE names).
`1119/10E9` scan an ASCII-like stream (`>`=`$3E` and `=`=`$3D`, quotes `$22/$27`) with case-insensitive keyword lists: HYPOTHESIS that this is an HTML-like tag parser (the product is known to ship HTML-like web pages, see `MobileAdapterGB/Mobile_Trainer_Web_Pages.7z`; nothing here proves it).

HRAM: `FF8A ROM lo`, `FF8B ROM hi`, `FF8C SRAM`, `FF8D WRAM`, `FFA3 A-at-boot`, `FFA8-FFAF trampoline`, `FFF2 A scratch`, `FFF3 far-bank arg`, `FFF4 VBK mirror`, `FFF5 SRAM-enable mirror`, `FFFC/FFFD/FFFE` service starvation counter / PRNG index / PRNG state,
`FFBA-FFC6` text cursor/limits, `FFB0/FFB1/FFB9/FFBF` scratch/state of the text interpreter, `FFF0/FFF1` (added by `0A1A`, cleared by the sprite reset).
WRAM0: `C000-C09F` shadow OAM (`C004` first slot written by the sprite engine), `C0A0-C0CF` glyph half buffers (`0E7E`, `1044`, `10B1`), `C0D3/C0EF/C0F6` STAT-handler variables, `C10E-C11D` 16-byte copy buffer (`172D`), `C12E` scratch (`1620`),
`C130-C135` saved vector stubs, `C266-C268/C26D` and `C2D4-C2D6` clocks, `C2BF/C2DF/C2F3/C2F5` frame service / VBlank / OAM pointer / DMA suppress, `C380` token output buffer, `C6C1/C69F/C709` flag bytes, `C820-C825` API argument save (`C825` index), `CBF1-CBFD` vector stubs.
WRAM1: `D000-D004`, `D026/D027` (bank-04 gateway), `D724/D824` (STAT handler variables). WRAM7: `D000-D3FF` tilemap buffer, `D400-D7FF` attribute buffer (uploaded with HDMA to VRAM bank 0/1 at `$9800/$9C00`), `DA00-DADF` 14 sprite slots. WRAM5: `D000` string buffer (`153D`). SRAM bank 1: `B013`, strings at `B014/B025/B036/B047` XOR-`$A5`-obfuscated (`EncodeXorA5/DecodeXorA5`).

| range | name | kind | status | description |
|---|---|---|---|---|
| `0000-0000` | `Rst_00` | code | CONFIRMED | rst $00 slot: ret (never used as a call target in reached code) |
| `0008-0008` | `Rst_08` | code | CONFIRMED | rst $08 slot: ret (never used as a call target in reached code) |
| `0010-0010` | `Rst_10` | code | CONFIRMED | rst $10 slot: ret (never used as a call target in reached code) |
| `0018-0018` | `Rst_18` | code | CONFIRMED | rst $18 slot: ret (never used as a call target in reached code) |
| `0020-0020` | `Rst_20` | code | CONFIRMED | rst $20 slot: ret (never used as a call target in reached code) |
| `0028-0028` | `Rst_28` | code | CONFIRMED | rst $28 slot: ret (never used as a call target in reached code) |
| `0030-0030` | `Rst_30` | code | CONFIRMED | rst $30 slot: ret (never used as a call target in reached code) |
| `0038-0038` | `Rst_38` | code | CONFIRMED | rst $38 slot: ret (never used as a call target in reached code) |
| `0040-0043` | `Vector_VBlank` | code | CONFIRMED | hardware vector: jp $CBF1 (RAM stub, see 00:04A0); reti |
| `0048-004B` | `Vector_STAT` | code | CONFIRMED | hardware vector: jp $CBF4 (RAM stub, see 00:04A0); reti |
| `0050-0053` | `Vector_Timer` | code | CONFIRMED | hardware vector: jp $CBF7 (RAM stub, see 00:04A0); reti |
| `0058-005B` | `Vector_Serial` | code | CONFIRMED | hardware vector: jp $CBFA (RAM stub, see 00:04A0); reti |
| `0060-0063` | `Vector_Joypad` | code | CONFIRMED | hardware vector: jp $CBFD (RAM stub, see 00:04A0); reti |
| `0100-0103` | `Entry` | code | CONFIRMED | reset entry: nop ; jp $0278 |
| `0104-014F` | `Header` | raw | CONFIRMED | cartridge header 0104-014F (logo, title M-TRAINER, CGB-only, MBC5+RAM+BATTERY, checksums); see docs/ROM_INFO.md |
| `0150-018C` | `MobileAPI` | code | PROBABLE | API entry with index in A (cp 2; args in HL/BC): stores A->C825, HL->C823/C824; if A==2 also FF8A/FF8B<-HL (the bank pushed below, i.e. restored on return) and C820/21<-BC; sets bit6 of C6C1; saves the current 16-bit ROM bank (... |
| `018D-01B6` | `ReturnMobileAPI` | code | PROBABLE | return path of MobileAPI: 75:4054-4057 pushes $018D before dispatching; saves A/HL to C823-C825, pops saved ROM bank -> FF8A/FF8B + MBC, res 6,[C6C1], reloads HL/A, ret [candidate; no static referrer] |
| `01B7-01EC` | `Int_Serial` | code | CONFIRMED | serial interrupt handler (RAM vector CBFA -> jp $01B7): push af/bc/de/hl; save 16-bit ROM bank; switch to bank 75; call 75:56D2; restore bank; reti. Same shape as pokecrystal MobileReceive |
| `01ED-0246` | `Int_Timer` | code | CONFIRMED | timer interrupt handler (RAM vector CBF7 -> jp $01ED): TAC=0; IF&=$1B; if [C709]==0 return at once (01FE jr z,$0242: TIMA/TAC are NOT restarted, the timer stays stopped); else, unless C6C1.bit1 or rSC.bit7 is set (then the bank... |
| `0247-0277` | `Function_00_0247` | code | PROBABLE | wrapper: saves A to D002, pushes 16-bit ROM bank (FF8A/8B), selects bank 000F, calls 0F:4247, restores bank and A. No static caller found [reached via inferred links; raw refs 6] |
| `0278-032A` | `Boot` | code | CONFIRMED | boot: see docs/research/boot_and_home.md. A(boot)->FFA3; LCD off (05BD); di; clear TAC/IF/IE; sp=$FFFE; CGB: request double speed (0602); SRAM off+bank0; non-CGB: forever show bank 6B:4C80; clear VRAM1, WRAM banks 2-7, WRAM0/1,... |
| `032B-032D` | `Data_00_032B` | data | CONFIRMED | inline data of FarCall at 0328: dw $4000 ; db $1C -> 1C:4000 |
| `032E-0330` | `Function_00_032E` | code | CONFIRMED | continuation |
| `0331-0349` | `Function_00_0331` | code | PROBABLE | writes 64 bytes of $7FFF x32 (Data_00_0352) into BG palette RAM (rBCPS=$80 auto-inc) and OBJ palette RAM (rOCPS=$80): all 16 palettes white [reached via inferred links; raw refs 8] |
| `034A-0351` | `Function_00_034A` | code | PROBABLE | copies 64 bytes from [HL] to the I/O port at $FF00+C (palette data port helper) [reached via inferred links; raw refs 4] |
| `0352-0391` | `Data_00_0352` | data | CONFIRMED | 32 x $7FFF (white) = 64 bytes, source for Function_00_0331 (ld hl,$0352 at 0335/0341) |
| `0392-03B9` | `Function_00_0392` | code | CONFIRMED | frame service, at most once per frame: skips if C2BF!=0, sets C2BF=1 (Int_VBlank clears it), saves BC/DE/HL and the WRAM bank, rSVBK=1 (FF8D is not updated), call 04:4082 through stub 20A6 (the stub returns A=$FF without enteri... |
| `03BA-044A` | `Int_VBlank` | code | CONFIRMED | VBlank interrupt handler (RAM vector CBF1 -> jp $03BA): unless [C2F5]!=0 run OAM DMA (call $FF80); increments the saturating VBlank counter C2DF; advances two frame/second/minute clocks (C2D4-C2D6 gated by C69F.bit4: at 70 minu... |
| `044B-0463` | `Function_00_044B` | code | CONFIRMED | wait for VBlank then run the frame service: if LCD on {ei; halt} until C2DF!=0; clear C2DF; call 0392 |
| `0464-0479` | `Function_00_0464` | code | PROBABLE | wait for VBlank flag only (ei; halt until C2DF!=0; clear C2DF); no frame service. Most referenced helper of the ROM (401 raw call sites) [reached via inferred links; raw refs 404] |
| `047A-049F` | `Function_00_047A` | code | CONFIRMED | wait for VBlank; returns with IME=0 right after the VBlank interrupt (LY>=$90); if woken late (LY<$90) clears the flag, calls 0392 and waits again |
| `04A0-04D7` | `Function_00_04A0` | code | PROBABLE | installs the RAM interrupt stubs: CBF1=jp $03BA, CBF4=reti, CBF7=jp $01ED, CBFA=jp $01B7, CBFD=reti (bytes written one by one; verified on interpreter) [reached via inferred links; raw refs 12] |
| `04D8-04ED` | `FillBytes` | code | CONFIRMED | fill BC bytes at HL with A (BC=0 fills 256 bytes when B=0); used to clear VRAM/WRAM/HRAM in Boot |
| `04EE-050B` | `FillWords` | code | PROBABLE | fill BC bytes at HL with the repeating 16-bit pattern E,D (2 bytes per step, BC counts bytes) [candidate; raw refs 16] |
| `050C-0525` | `CopyBytes` | code | CONFIRMED | copy BC bytes from [HL++] to [DE++] (BC=0 with B=0 copies 256) |
| `0526-053F` | `CopyBytesBackward` | code | PROBABLE | copy BC bytes from [HL--] to [DE--] [reached via inferred links; raw refs 43] |
| `0540-0550` | `JumpTableBank` | code | PROBABLE | A=bank, HL=table of 16-bit pointers, C=index: bank switch via 0622, then jp [HL+2*C] (0545 is the entry that takes A=index and the table inline) [candidate; raw refs 33] |
| `0551-0569` | `FarJumpTable` | code | PROBABLE | A=bank, HL=table of 3-byte entries (addr16, bank), C=index: switch to the table bank, read entry, switch to the entry bank, jp to it [candidate; raw refs 4] |
| `056A-059E` | `JoypadDispatch` | code | PROBABLE | inline table (5 words) follows the call: index = lowest set bit among bits0-3 of (FFA5/FFA7) (FFA7 is cleared), 4 if none; jumps through 0545 (call sites in other banks). FFA5 = newly pressed buttons computed by 7D:7BC1 ((old x... |
| `059F-05AB` | `Function_00_059F` | code | CONFIRMED | copies the 10-byte OAM DMA routine from 05AC to HRAM $FF80 (ld bc,$0A80: B=count, C=dest) |
| `05AC-05B5` | `OAMDMARoutine` | ramcode | CONFIRMED | runaddr=$FF80 ; OAM DMA routine image: ld a,$C0 ; ldh [rDMA],a ; ld a,$28 ; .w dec a ; jr nz,.w ; ret. Copied by 059F, called at 03C1 as call $FF80 |
| `05B6-05BC` | `LCDOn` | code | CONFIRMED | LCDC /= $80 |
| `05BD-0601` | `LCDOff` | code | CONFIRMED | if LCD on: wait for LY in [$91,$98), clear LCDC bit7, ei, call 0392. Two variants selected by FFA3==$11 (CGB path does not touch IE/IF) |
| `0602-0621` | `SwitchCPUSpeed` | code | CONFIRMED | A bit7 = requested speed: if rKEY1 bit7 differs, rKEY1=1, IF=IE=0, P1=$30, STOP, restore IE (CGB double-speed switch). Boot calls it with A=$80 |
| `0622-063C` | `BankSwitch_H` | code | CONFIRMED | A=bank, H=high byte of the address being accessed: A=0 -> no change; H<$80 ROM: FF8A<-A,[$2100]<-A; H $80-$BF: SRAM bank FF8C<-A,[$4000]<-A; H>=$C0: WRAM bank FF8D<-A,rSVBK<-A |
| `063D-0657` | `BankSwitch_D` | code | CONFIRMED | same as BankSwitch_H with the region taken from D |
| `0658-0672` | `BankSwitch_B` | code | CONFIRMED | same as BankSwitch_H with the region taken from B |
| `0673-0683` | `GetBank_H` | code | CONFIRMED | returns in A the current bank of the region selected by H (FF8A / FF8C / FF8D) |
| `0684-06B6` | `Function_00_0684` | code | PROBABLE | initialises HRAM bank state and the far-call trampoline: FFA8..FFAF = `ld a,0 ; ld hl,0 ; jp $06B7`; FF8D=rSVBK=1; FF8C=1,[4000]=1 (SRAM bank 1); FFF5=0,[0000]=0 (SRAM disabled); FFF4=0, rVBK=0 [reached via inferred links; raw ... |
| `06B7-06BB` | `Function_00_06B7` | code | PROBABLE | default target of the trampoline (jp $06B7 written by 0684 to FFAD-FFAF): forever call 044B (wait for VBlank + frame service). Reached only if the trampoline is entered without a patched target; never executed in mGBA (20 M ins... |
| `06BC-06D0` | `Function_00_06BC` | code | CONFIRMED | far call with inline 16-bit address (2 bytes after the call); bank comes from hFFF3. Entry to the common far-call path (06EE). One caller: `call $06BC` at 4F:4008 (inline word at 4F:400B = 00:050C CopyBytes, with hFFF3=A and WR... |
| `06D1-06E4` | `FarCall` | code | CONFIRMED | THE far call: call $06D1 ; dw addr ; db bank. Saves A/HL (FFA9/FFAB), pops the return address to read the 3 inline bytes, remembers the caller bank, switches to `bank` (region by target address), runs the target through the HRA... |
| `06E5-0715` | `FarCall_Reg` | code | PROBABLE | like FarCall but bank in A and target address in HL (no inline data); shares the common path at 06EE. No static caller found [candidate; raw refs 18] |
| `0716-072D` | `Function_00_0716` | code | PROBABLE | far JUMP (tail call, no return) with inline 16-bit address and bank from hFFF3; no static caller found [candidate; raw refs 6] |
| `072E-0748` | `FarJump` | code | PROBABLE | far JUMP (tail call, no return): call $072E ; dw addr ; db bank; A/HL passed through. No static caller found [candidate; raw refs 3] |
| `0749-0786` | `Function_00_0749` | code | CONFIRMED | general-purpose HDMA start (rHDMA5=C-1, bit7=0): A=source bank (region by H), HL=source, DE=dest (E bit0 = VRAM bank via rVBK/FFF4, E&$F0 = low dest byte), C=number of 16-byte blocks, B=LY limit: waits until LY>=$91 and LY<B, e... |
| `0787-07CA` | `Function_00_0787` | code | CONFIRMED | variant of 0749 that calls the frame service (0392) while waiting |
| `07CB-07FA` | `Function_00_07CB` | code | PROBABLE | uploads the two 1 KiB screen buffers of WRAM bank 7 to VRAM with two HDMA transfers (0749, B=$95, C=$24 blocks): D000 -> VRAM bank 0, D400 -> VRAM bank 1, map $9800 or $9C00 selected by A bit3; di before the wait, ei + frame se... |
| `07FB-082B` | `Function_00_07FB` | code | PROBABLE | uploads the two 1 KiB screen buffers of WRAM bank 7 to VRAM with two HDMA transfers (0749, B=$95, C=$24 blocks): D000 -> VRAM bank 0, D400 -> VRAM bank 1, map $9800 or $9C00 selected by A bit6; di before the wait, ei + frame se... |
| `082C-085A` | `Function_00_082C` | code | CONFIRMED | uploads the two 1 KiB screen buffers of WRAM bank 7 to VRAM with two HDMA transfers (0749, B=$95, C=$24 blocks): D000 -> VRAM bank 0, D400 -> VRAM bank 1, map $9800 or $9C00 selected by A bit3; no di, ei + frame service after |
| `085B-0886` | `Function_00_085B` | code | PROBABLE | uploads the two 1 KiB screen buffers of WRAM bank 7 to VRAM with two HDMA transfers (0749, B=$95, C=$24 blocks): D000 -> VRAM bank 0, D400 -> VRAM bank 1, map $9800 or $9C00 selected by A bit3; no di, ei + ret (no frame service... |
| `0887-08B6` | `Function_00_0887` | code | PROBABLE | uploads the two 1 KiB screen buffers of WRAM bank 7 to VRAM with two HDMA transfers (0749, B=$95, C=$24 blocks): D000 -> VRAM bank 0, D400 -> VRAM bank 1, map $9800 or $9C00 selected by A bit6; no di, ei + frame service after [... |
| `08B7-08C9` | `Function_00_08B7` | code | CONFIRMED | if LCD on: waits until LY < $87 (i.e. rides out VBlank/late lines, ei while waiting) so an HDMA transfer started afterwards fits in VBlank |
| `08CA-08E9` | `Function_00_08CA` | code | PROBABLE | copy B rows of C bytes from [HL] (bank A) into the WRAM bank 7 buffer at DE (row stride 32), twice: second pass HL+=$400, DE+=$400 [candidate; raw refs 7] |
| `08EA-0903` | `Function_00_08EA` | code | CONFIRMED | like 08CA but the second pass continues with the same source pointer |
| `0904-091B` | `Function_00_0904` | code | CONFIRMED | rectangle copy: B rows x C bytes from [HL] to [DE], DE row stride 32 (uses FFB0 as row length) |
| `091C-093A` | `Function_00_091C` | code | PROBABLE | rectangle AND/OR: for B rows x C bytes: [HL] = ([HL] & D) / E, HL row stride 32 (bank A) [reached via inferred links; raw refs 1] |
| `093B-0955` | `Function_00_093B` | code | PROBABLE | clears the two 1 KiB screen buffers D000-D3FF and D400-D7FF of WRAM bank 7 [candidate; raw refs 6] |
| `0956-09B5` | `Function_00_0956` | code | CONFIRMED | sprite-object engine pass: sets C2F5=1 (no OAM DMA), clears shadow OAM C000-C09F (0A09), walks the 14 slots at D:DA00 (16 bytes each, WRAM bank 7) writing OAM entries from C004, C2F3=next OAM ptr, C2F5=0 |
| `09B6-09E5` | `Function_00_09B6` | code | CONFIRMED | sprite engine reset: clears C000-C09F, FFF0=FFF1=0 and fills the 14 slots DA00-DADF with $FF |
| `09E6-0A08` | `Function_00_09E6` | code | PROBABLE | fill 16 bytes at HL (one sprite slot) with $FF in WRAM bank 7 [reached via inferred links; raw refs 50] |
| `0A09-0A19` | `Function_00_0A09` | code | CONFIRMED | clears the shadow OAM buffer C000-C09F (160 bytes) |
| `0A1A-0A29` | `Function_00_0A1A` | code | PROBABLE | adds FFF1 (lo) / FFF0 (hi) to the 16-bit word at [HL] [candidate; raw refs 28] |
| `0A2A-0A44` | `Function_00_0A2A` | code | PROBABLE | stores DE at [HL],[HL+1] in WRAM bank 7 (preserves A) [candidate; raw refs 4] |
| `0A45-0A64` | `Function_00_0A45` | code | PROBABLE | stores E,D,A at [HL..HL+2] in WRAM bank 7 [reached via inferred links; raw refs 28] |
| `0A65-0A81` | `Function_00_0A65` | code | CONFIRMED | stores D,E (big-endian) at [HL],[HL+1] in WRAM bank 7; most referenced helper of the sprite code (520 raw call sites) |
| `0A82-0AB7` | `Function_00_0A82` | code | CONFIRMED | initialise sprite slot HL: zero 16 bytes, slot+0E=A(bank), then fill the fields from the animation table at DE via 0AB8 |
| `0AB8-0AE7` | `Function_00_0AB8` | code | CONFIRMED | fills slot fields from the 4-byte table entry at DE+4*(A&$3F) (used by 0A82; the shifted index is 8 bits wide, see sprite_format.md) |
| `0AE8-0BBC` | `Function_00_0AE8` | code | CONFIRMED | per-slot animation step + OAM writer (layout inferred, HYPOTHESIS): slot [0]=Y [1]=X [2..3]=frame table ptr [4]=frame index ($FF none) [5]=delay [6..7]=script ptr [8]=script index [9..A]=OR/AND attr masks [B..D]=hook (addr16, b... |
| `0BBD-0BD3` | `Function_00_0BBD` | code | PROBABLE | HL = BG map offset -> C = (L&31)*8 (x pixel), B = ((HL>>5)&31)*8 (y pixel); verified on interpreter [candidate; raw refs 5] |
| `0BD4-0BDD` | `Function_00_0BD4` | code | PROBABLE | HL = A*E (calls 0BFC with D=0), preserves AF and DE [candidate; no static referrer] |
| `0BDE-0BE7` | `Function_00_0BDE` | code | PROBABLE | HL = BC*DE (calls 0BE8), preserves AF, BC, DE [candidate; raw refs 3] |
| `0BE8-0BFB` | `Multiply16` | code | PROBABLE | HL = BC * DE (low 16 bits); verified on interpreter [reached via inferred links; raw refs 5] |
| `0BFC-0C0D` | `Multiply8x16` | code | PROBABLE | HL = A * DE (low 16 bits); verified on interpreter [reached via inferred links; raw refs 12] |
| `0C0E-0C17` | `Random16` | code | PROBABLE | HL = (Random, Random) : H=first byte, L=second byte [candidate; raw refs 4] |
| `0C18-0C33` | `Random` | code | PROBABLE | A(hFFFE) = (5*hFFFE + 2) xor Table_00_0C34[++hFFFD] ; returns in hFFFE (index hFFFD wraps at 256). No seeding code in ROM0 [candidate; raw refs 26] |
| `0C34-0D33` | `Table_00_0C34` | data | CONFIRMED | 256 bytes indexed by hFFFD, xor operand of Random (0C2F) |
| `0D34-0D4C` | `Function_00_0D34` | code | PROBABLE | push af; ld d,$C2; writes ROM bank $F0 (FF8A/[2100]); ld a,[de] = the WRAM byte at $C200+E (NOT a ROM read: $C2xx is WRAM, so the ROM bank write has no effect on the load; $F0 would wrap to bank $70 on a 128-bank cart); DE = si... |
| `0D4D-0D66` | `Multiply16x16to32` | code | PROBABLE | BC:HL = DE * HL (32-bit product); verified on interpreter [reached via inferred links; raw refs 4] |
| `0D67-0D91` | `Divide16` | code | PROBABLE | HL = HL / DE, DE = HL % DE (unsigned 16/16); verified on interpreter [reached via inferred links; raw refs 12] |
| `0D92-0DB8` | `Divide32by15` | code | PROBABLE | BC:DE / HL -> DE = quotient, BC = remainder (unsigned; exact for HL<$8000 and BC<HL); verified on 200 random cases on interpreter [reached via inferred links; raw refs 6] |
| `0DB9-0DCD` | `Function_00_0DB9` | code | CONFIRMED | A=bank, DE=src, HL=dst, C=restore bank: switch ROM bank via FF8A/[2100], copy 12 bytes each written twice, restore bank C |
| `0DCE-0DE1` | `Function_00_0DCE` | code | PROBABLE | like 0DB9 without duplicating (12 bytes) [candidate; raw refs 8] |
| `0DE2-0E31` | `Function_00_0DE2` | code | CONFIRMED | A=bank, DE=src (18 bytes), HL=dst1, BC=dst2: two bit-shuffling passes that unpack 4 six-bit values per 3 source bytes (value<<2), pass 1 -> HL, pass 2 -> BC, each output byte written twice; ends by selecting ROM bank $7F. Calle... |
| `0E32-0E7D` | `Function_00_0E32` | code | PROBABLE | same unpacking as 0DE2 but each output byte is written once; ends with ROM bank $7F. Called only from bank 7F [candidate; raw refs 6] |
| `0E7E-0E92` | `Function_00_0E7E` | code | PROBABLE | A=bank, DE=src, B=count, C=restore bank: copies B bytes into C0A0 (buffer directly after the shadow OAM, also used as glyph buffer by 1044) [candidate; no static referrer] |
| `0E93-0ED2` | `Function_00_0E93` | code | PROBABLE | alternative STAT interrupt handler (installed into RAM vector CBF4 by 7F:727D): if LY==0: LYC=[D724], SCY=0; else SCY=[C0D3], LYC=0 and, if [D824]!=0, call 0392; saves/restores rSVBK (uses WRAM bank 1) [candidate; raw refs 1] |
| `0ED3-0EEF` | `Function_00_0ED3` | code | PROBABLE | byte-stream (text) interpreter: A=bank of string, HL=pointer. Bytes <$20 dispatch through Table_00_0EF0 (handler entered with the string pointer on the stack), bytes >=$20 are characters (see 0F30). FFB9=current bank, FFBF=call... |
| `0EF0-0F2F` | `Table_00_0EF0` | words | CONFIRMED | 32 handler pointers for control bytes $00-$1F (indexed at 0EE3-0EEF) |
| `0F30-0F67` | `Function_00_0F30` | code | CONFIRMED | character output: C=byte; lead bytes $81-$9F,$E0-$EF,$F8-$F9 take a second byte and draw a double-byte glyph (1044), others a single glyph (10B1); then call 0392, wrap when x(FFBD) exceeds limit FFC4 (newline at 0F69) |
| `0F68-0F82` | `Function_00_0F68` | code | CONFIRMED | control byte $0D (newline): X(FFBD/E)=FFC1/FFC2; if FFC6==$FF return (end of text, 0F73-0F75); else Y(FFBC)+=FFC6 and continue only while Y<=FFC3 (0F7E cp, jp nc,$0ED8), otherwise return |
| `0F83-0F9C` | `Function_00_0F83` | code | CONFIRMED | control byte $01: call sub-string: reads addr16 + bank, pushes return pointer and bank, depth++ (FFBF), continues in the new string |
| `0F9D-0FAB` | `Function_00_0F9D` | code | CONFIRMED | control byte $00/$08/$0A-$0C/$0E-$1B: end of string: at depth 0 return to caller, else pop the saved pointer/bank and continue |
| `0FAC-0FB2` | `Function_00_0FAC` | code | CONFIRMED | control byte $02: FFBC = next byte |
| `0FB3-0FB9` | `Function_00_0FB3` | code | CONFIRMED | control byte $03: FFBD = next byte |
| `0FBA-0FC5` | `Function_00_0FBA` | code | CONFIRMED | control byte $04: FFBC=3, FFBD=0 |
| `0FC6-0FD1` | `Function_00_0FC6` | code | CONFIRMED | control byte $05: FFBC=1, FFBD=0 |
| `0FD2-0FDD` | `Function_00_0FD2` | code | CONFIRMED | control byte $06: FFBC=2, FFBD=0 |
| `0FDE-0FE9` | `Function_00_0FDE` | code | CONFIRMED | control byte $07: FFBC=0, FFBD=2 |
| `0FEA-0FF3` | `Function_00_0FEA` | code | CONFIRMED | control byte $1C: FFBD/FFBE = next word |
| `0FF4-0FFA` | `Function_00_0FF4` | code | CONFIRMED | control byte $1D: FFBC = next byte |
| `0FFB-100C` | `Function_00_0FFB` | code | CONFIRMED | control byte $1E: FFBD/FFBE += next word |
| `100D-1017` | `Function_00_100D` | code | CONFIRMED | control byte $1F: FFBC += next byte |
| `1018-1027` | `Function_00_1018` | code | CONFIRMED | control byte $09: FFBD/FFBE += $30 |
| `1028-1055` | `Function_00_1028` | code | PROBABLE | draw character C: same lead-byte test as 0F30, then 10B1 (single) or 1044 (double: far calls into bank 7F glyph routines; y limit $90, x limit $A0) [candidate; raw refs 50] |
| `1056-1058` | `Data_00_1056` | data | CONFIRMED | inline data of FarCall at 1053: dw $405F ; db $7F -> 7F:405F |
| `1059-1075` | `Function_00_1059` | code | CONFIRMED | continuation of Function_00_1028 |
| `1076-1078` | `Data_00_1076` | data | CONFIRMED | inline data of FarCall at 1073: dw $42C3 ; db $7F -> 7F:42C3 |
| `1079-109F` | `Function_00_1079` | code | CONFIRMED | continuation of Function_00_1028 |
| `10A0-10A2` | `Data_00_10A0` | data | CONFIRMED | inline data of FarCall at 109D: dw $42C3 ; db $7F -> 7F:42C3 |
| `10A3-10B0` | `Function_00_10A3` | code | CONFIRMED | continuation |
| `10B1-10C2` | `Function_00_10B1` | code | CONFIRMED | draw single-byte glyph (far calls into bank 7F: 7F:4007, 7F:42C3) |
| `10C3-10C5` | `Data_00_10C3` | data | CONFIRMED | inline data of FarCall at 10C0: dw $4007 ; db $7F -> 7F:4007 |
| `10C6-10D7` | `Function_00_10C6` | code | CONFIRMED | continuation of Function_00_10B1 |
| `10D8-10DA` | `Data_00_10D8` | data | CONFIRMED | inline data of FarCall at 10D5: dw $42C3 ; db $7F -> 7F:42C3 |
| `10DB-10E8` | `Function_00_10DB` | code | CONFIRMED | continuation |
| `10E9-1118` | `Function_00_10E9` | code | PROBABLE | keyword lookup: BC = table of word pointers to strings (0 terminates); compares [HL] with each ignoring ASCII case; returns A = byte after the matched keyword [reached via inferred links; raw refs 30] |
| `1119-1319` | `Function_00_1119` | code | PROBABLE | token/attribute scanner over an ASCII-like stream: stops at $00 or $3E (>), handles $3D (=), quotes $22/$27, skips bytes <$21; uses 10E9 for keywords, DE=$C380 output. HYPOTHESIS: HTML-like tag parser [reached via inferred link... |
| `131A-1353` | `Function_00_131A` | code | PROBABLE | two-level string lookup in bank 3F: pointer table at 3F:4000 indexed by B -> copy string to HL; then 3-byte entries (addr,bank) indexed by BC -> copy second string [reached via inferred links; raw refs 43] |
| `1354-1407` | `Function_00_1354` | code | PROBABLE | keyword search in bank 3F: walks the word-pointer list at 3F:4000 comparing each string with the text at HL; on a match stores the byte after it in C2DC, walks the entry list (addr16 + bank byte) and copies the matching payload... |
| `1408-14BE` | `Function_00_1408` | code | PROBABLE | text measure: A=bank, HL=string, BC=limit, DE=x: adds 6 per single-byte char, 12 per double-byte, $30 per tab; stops at 00/0A/0D; returns BC = bytes that fit [candidate; raw refs 13] |
| `14BF-14C5` | `CopyString` | code | PROBABLE | copy [HL++] to [DE++] up to and including the $00 terminator [reached via inferred links; raw refs 33] |
| `14C6-14D0` | `CopyStringMax` | code | PROBABLE | copy at most BC bytes, stop after the terminator [reached via inferred links; raw refs 6] |
| `14D1-14DF` | `Function_00_14D1` | code | PROBABLE | like 14C6; when BC==0 writes a $00 at [HL] (source pointer) [reached via inferred links; raw refs 4] |
| `14E0-14E9` | `EncodeXorA5` | code | PROBABLE | copy [HL++] to [DE++] XOR $A5 until the source byte is $00 (terminator is stored as $A5) [candidate; raw refs 6] |
| `14EA-14F2` | `DecodeXorA5` | code | PROBABLE | copy [HL++] XOR $A5 to [DE++] until the decoded byte is $00 (inverse of EncodeXorA5) [reached via inferred links; raw refs 23] |
| `14F3-1508` | `Function_00_14F3` | code | PROBABLE | string append: finds the first byte equal to A in the string at DE and copies the string at HL there (A=0: strcat) [reached via inferred links; raw refs 19] |
| `1509-1519` | `CompareString` | code | PROBABLE | strcmp(HL, DE): A = [HL]-[DE] at the first difference (0 only if both strings end together); verified on interpreter [reached via inferred links; raw refs 11] |
| `151A-1532` | `CompareStringN` | code | PROBABLE | like CompareString but compares at most B bytes (A = [HL]-[DE]); verified on interpreter [candidate; raw refs 2] |
| `1533-153C` | `StringLength` | code | PROBABLE | BC = length of the $00-terminated string at HL [reached via inferred links; raw refs 5] |
| `153D-1585` | `Function_00_153D` | code | PROBABLE | A=index: copies the string from 65:567F[A] (word table) to D000 (WRAM bank 5), returns HL=$D000, A=5 [reached via inferred links; raw refs 11] |
| `1586-1589` | `Function_00_1586` | code | PROBABLE | far-calls 68:44FC; if it returns 0 copies string 68:67AE[C271] to DE, else decodes the SRAM string (bank 1, XOR $A5) selected by [B013] via Table_00_161A [reached via inferred links; raw refs 0] |
| `158A-158C` | `Data_00_158A` | data | CONFIRMED | inline data of FarCall at 1587: dw $44FC ; db $68 -> 68:44FC |
| `158D-1619` | `Function_00_158D` | code | PROBABLE | continuation [reached via inferred links; raw refs 11] |
| `161A-161F` | `Table_00_161A` | words | CONFIRMED | 3 pointers into SRAM bank 1 (B014, B025, B036) indexed by ([B013] xor $A5) |
| `1620-1685` | `ReadByteFar` | code | PROBABLE | A=bank, HL=address: returns [HL++] read from the right bank/region (ROM: FF8A; SRAM: enables SRAM around the read; WRAM: FF8D); restores the previous bank [reached via inferred links; raw refs 92] |
| `1686-16A1` | `Function_00_1686` | code | PROBABLE | copy E bytes from far HL (bank D, region by H) to [BC++]; restores only the ROM bank [candidate; raw refs 1] |
| `16A2-16C3` | `Function_00_16A2` | code | PROBABLE | like 08CA but the second source pointer comes from C10E/C10F [reached via inferred links; raw refs 3] |
| `16C4-16D3` | `Function_00_16C4` | code | PROBABLE | alternative STAT handler (installed by 48:4437 into CBF4): if LY==$80 then SCX=[C0EF] [candidate; raw refs 4] |
| `16D4-16DB` | `Function_00_16D4` | code | PROBABLE | alternative VBlank handler prologue (installed by 48:4446 into CBF1): SCX=0 then jp $C133 (copy of the original VBlank stub saved by 48:4425) [candidate; no static referrer] |
| `16DC-1710` | `Function_00_16DC` | code | PROBABLE | alternative STAT handler (installed by 57:4537 into CBF4): raster effect using WY, C0F6, LYC [candidate; raw refs 1] |
| `1711-172C` | `Function_00_1711` | code | CONFIRMED | wrapper: preserves A, switches ROM bank to $4F, call 4F:47A5, restores |
| `172D-176F` | `Function_00_172D` | code | PROBABLE | far-to-far copy of BC bytes: source (bank A, HL), destination bank in [C10E], DE; staged through a 16-byte buffer at C10E [candidate; raw refs 7] |
| `20A0-20A5` | `Function_00_20A0` | code | CONFIRMED | stub: call 20EE (select ROM bank 4 and remember previous) ; jp 04:4000. Called once from Boot with SVBK=1 |
| `20A6-20AB` | `Function_00_20A6` | code | CONFIRMED | stub: call 2129 (re-entrancy guard) ; jp 04:4082. Called from the frame service 0392 |
| `20AC-20B1` | `Function_00_20AC` | code | CONFIRMED | stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx |
| `20B2-20B7` | `Function_00_20B2` | code | PROBABLE | stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [reached via inferred links; raw refs 65] |
| `20B8-20BD` | `Function_00_20B8` | code | PROBABLE | stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 14] |
| `20BE-20C3` | `Function_00_20BE` | code | PROBABLE | stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 3] |
| `20C4-20C9` | `Function_00_20C4` | code | CONFIRMED | stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx |
| `20CA-20CF` | `Function_00_20CA` | code | PROBABLE | stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 10] |
| `20D0-20D5` | `Function_00_20D0` | code | PROBABLE | stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; no static referrer] |
| `20D6-20DB` | `Function_00_20D6` | code | PROBABLE | stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 3] |
| `20DC-20E1` | `Function_00_20DC` | code | PROBABLE | stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; no static referrer] |
| `20E2-20E7` | `Function_00_20E2` | code | PROBABLE | stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx [candidate; raw refs 1] |
| `20E8-20ED` | `Function_00_20E8` | code | CONFIRMED | stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx |
| `20EE-2104` | `Function_00_20EE` | code | CONFIRMED | saves ROM bank hi/lo (FF8B->D002, FF8A->D001), selects ROM bank 4 (hi=0, lo=4 via [2000]); 20F8/20FF are the shared restore-bank-4 tail |
| `2105-210A` | `Function_00_2105` | code | CONFIRMED | ROM bank hi byte: FF8B <- A, [$3000] <- A |
| `210B-2115` | `Function_00_210B` | code | PROBABLE | restores the ROM bank saved at D001/D002 [reached via inferred links; raw refs 10] |
| `2116-2128` | `Function_00_2116` | code | CONFIRMED | stub guard used by 20AC..20EB: see stubs. D000 is banked WRAM: the guard state lives in whichever WRAM bank is selected at the call (Boot and 0392 select bank 1 first) |
| `2129-2140` | `Function_00_2129` | code | CONFIRMED | stub guard used by 20A6: if bank-4 already active (D000.bit7) and not pending, sets D000.bit6 and saves the return address at D003/D004 (deferred call); else returns A=$FF |
| `2141-215D` | `Function_00_2141` | code | PROBABLE | return from bank 04: if D000.bit6 clear restore bank and clear bit7; else re-queue the deferred stub address from D003/D004 (ret jumps to it) and clear bit6. 15 call sites in bank 04 [reached via inferred links; raw refs 29] |
| `215E-216E` | `Function_00_215E` | code | PROBABLE | reads C=[DE] from ROM bank ([D027]:[D026]) then returns to bank 4 (20F8); 9-bit bank number [reached via inferred links; raw refs 7] |
| `216F-2182` | `Function_00_216F` | code | PROBABLE | like 215E but reads C=[DE], B=[DE+1] [reached via inferred links; raw refs 9] |

* `tools/test_cfg.py`: 48 tests, all passing (flow, blocks, bank resolution/inference, inline conventions, tables, suspicious detection, overlays, back-scan, hardware accesses, CLI, `regs_written` vs interpreter for every non-branching opcode, real-ROM boot path).

## 13. Open questions / unknowns

* What the frame service (`04:4082`) and `04:4000` really are (sound driver is the working hypothesis); what `65:4000`, `0E:4000`, `7C:7B7C`, `7C:7D1F`, `7D:7BF0` do (the top-level state machine in `1C:4000`).

The latter has two ordinary routes yielding A=0 under coherent mapping/stack and uninterrupted shared scratch: the TimerAIsNonZero early exit and the close path through FadeOutToWhite then Sprite_ResetAll.

* Purpose of the two clocks in `Int_VBlank` (`C2D4-C2D6`, `C266-C268`), the odd routine `0D34` (writes ROM bank `$F0`, reads `[$C200+E]`; its only visible effect is the sign-extended WRAM byte in DE) and the unreferenced `0247`, `06E5`, `0716`, `072E`.

* Bank 75 is the Mobile SDK library (`75:4030` = `_MobileAPI`); a byte-level alignment against pokecrystal `lib/mobile` belongs to the bank-75 analysis (`tools/crystal_match.py`).

* Indirect transfers left in ROM0 (`CFG.unresolved`): `0550` (`JumpTableBank/Inline`, targets live in the callers' tables), `0569` (`FarJumpTable`), `0EEF` (text control bytes: resolved by seeding the 32 words of `Table_00_0EF0`, correct because `0EDE cp $20 ; jr nc` bounds the index), `0B53` (`push bc ; push de ; ret` at `0B4E`: an indirect call to the sprite hook in DE whose return address is the constant `$0B54`; `0B54` was added as a seed by hand).

* `tools/cfg.py` limitations: inline word tables are parsed heuristically (`CFG.tables` lists them); `jp hl` targets other than `Table_00_0EF0` are not resolved (`CFG.unresolved`).

## Bank25 mailbox HDMA windows and unclassified fragments

The maintained mailbox loader has three matching HDMA requests in each of its two branches. Original ROM sequences at the six call sites and the primary Gfx_StartHDMA body at 00:0749 establish A=$25, C blocks of 16 bytes and VRAM bank E&1=0. BankSwitch_H selects ROM bank 25 for these source addresses. rHDMA5 receives C-1 with bit7=0 (general-purpose DMA), while E&$F0 supplies the aligned destination low byte.

`Mailbox_HDMASourceFragment_6AC8` is a 265-byte CONFIRMED source fragment inside the first HDMA request. Its whole interval [$6AC8,$6BD1) maps to VRAM0 [$80D8,$81E1); its first 56 bytes also map through the second request to [$87C8,$8800). The physical 16-byte phases are 8 at the start and 1 at the exclusive end. `Mailbox_HDMASourceFragment_6E71` is a 127-byte CONFIRMED source fragment inside the third request; [$6E71,$6EF0) maps to VRAM0 [$8E81,$8F00), with phases 1 and 0. The names record source-transfer role only: content class remains unknown and the boundaries cut tile-sized units, so neither is an independently aligned tile asset. The adjacent 672-byte region beginning $6BD1 retains its PROBABLE header and existing INCBIN/db layout.

Upload into VRAM bank 0 alone establishes no title art, species or sprite/OAM purpose.

The KEEP decision in this section records the state before the bounded
`Profile_InitScreen` transfer-tail evidence was integrated below. The later
follow-up supersedes that label decision; the original limitations on display
and sprite/OAM attribution still apply.

Data_26_7AB0 remains the twelve literal zero bytes at [$7AB0,$7ABC), classified as CONFIRMED data of unknown content class.

The separate four zero bytes at [$7ABC,$7AC0) retain their PROBABLE header and ds directive.

The twelve-byte fragment maps to [$8290,$829C).

The finite scan of all 343 maintained ASM files finds eleven immediate named direct HDMA requests with source bank 26; this is the sole one that intersects the fragment.

The 56 entries, 14 frame tables, 19 count-prefixed frames and 14 scripts exactly partition [$7B00,$7D41); the scripts select in-range named frames, and none of these structures intersects [$7AB0,$7ABC).

The generic primary frame reader at 00:0B97..0BBA follows a pointer and reads one count byte plus four bytes per OAM piece without checking a physical frame extent.

KEEP: neutral Data_26_7AB0, its current data/CONFIRMED/unknown classification, the separate four-byte region and all original directives and boundaries.

### Superseding bank26 Profile_InitScreen tail label

Profile_InitScreen passes bank 26, HL=7820, DE=8000 and C=2A to the HDMA routine; the 672-byte transfer ends at source 7AC0 / VRAM0 82A0.

### Conditional saved-vector reaching boundary (static audit)

The ticker stores a complete three-byte executable VBlank stub in `C133-C135`; if it copies `C3 BA 03`, `CBF1 → 00:16D4 → C133` reaches the default handler `00:03BA`. Ticker installation tests `IE.bit1` in its caller, and restoration also depends on that bit; neither local test proves the identity or lifetime of the saved opcode. The STAT save buffer `C130-C132` is shared with the keyboard raster installer. The direct default/ticker/keyboard/scroll handler instructions do not write LCDC; scroll STAT can call the audio frame service, whose transitive IO remains a separate boundary.

It does not demonstrate a naturally reached ticker-active failure: the known ordinary startup chain enters through `Boot_ClearAndInit`, which installs the default VBlank stub before `Main_Run → Startup_Run → 00:1711 → 4F:47A5`; the default handler bypasses `C133`.

### Conditional audio I/O destination boundary (static audit)

Its single computed jump at `04:45DA` uses the union of three bounded dispatch tables: 31 command entries selected by bytes B1..CF, 12 extended entries selected by 0..0B, and seven parameter entries selected by 0..06.

The normal channel selectors at `04:4177..41C0` install the pairs `D220/12`, `D238/17`, `D250/1C` and `D268/21`. The all-channel iterator starts with count four; `NextChannel` decrements that count and returns Z before advancing beyond the final channel. Earlier advances add $18 to the record pointer and $05 to the register base. `StartNote` selects one of these four entries for every instrument-class byte, using the `<08`, `<10` and `<40` comparisons. Thus instrument bytes alone do not select an arbitrary I/O base under this mechanism. This is a bounded producer argument; the lifetime of physical WRAM1 `D012-D015` against indirect stores, callbacks and interrupts remains unproved.

Under stable normal bases `12/17/1C/21`, the five channel writers contain all 26 LDH write sites in the finite graph: 18 use C and eight have fixed immediate ports. The normal C formulas are base, base±1, base±2, fixed 25 for pan, or 30+i for the 16-byte waveform loop. Branch comparisons determine the applicable base at each site; this is not a claim that every formula applies to every channel. The waveform loop initializes C=$30 and B=$10, writes before incrementing C and decrementing B, and exits when B becomes zero; its last write is FF3F, so the subsequent C=$40 is not used by another loop write. The normal destinations are audio ports FF10-FF14, FF16-FF1E, FF20-FF23, FF25 and FF30-FF3F, plus the explicit unused/nonexistent register address **FF15**. Data bytes and waveform indices affect reads and values, not these destination formulas. None of these conditional destination sets includes FF40.

The unsafe counterexample is also artificial: entry to `SilenceChannel` at `04:4FD4` with D015=$40 writes FF40 at `04:4FDE` and FF42 at `04:4FE3`.

The normal `call 00:2129` at `00:20A6` supplies the saved return word 20A9 in the selected WRAM bank's D003/D004; under unchanged word/bank/stack conditions, the pending consumer at `00:2141` returns to `jp 04:4082`.

Under valid stable iterator/record/gateway state, the audited audio LDH boundary preserves LCDC.

Complete indirect-write, callback, timer/serial SDK and inherited-LCDC provenance remains open.

It binds all 178 indirect write/update PCs in the admitted `04:4082` graph to maintained source lines and original opcodes, then reviews their literal pointer/field arithmetic: 99 track sites, 43 channel sites and 36 fixed-global sites.

The graph's 43 absolute EA stores stay in `D000-D03F`; only `04:4C27/4C2C` rewrite iterator bytes, restoring D010/D011 from the active channel's link.

The ordinary SFX/music track loops select count four and stride $3C.

The four individual channel selectors use count one; the all-channel selector uses count four and stride $18 with register-base increment $05.

Normal initialization clears track/channel active flags. A link in an inactive channel is not consumed. `StartNote` copies a currently selected valid track pointer into channel offsets +4/+5 at `04:4B3D/4B3F`; these are the only record-write sites in the graph that touch those link fields. The service gate and UpdateChannel consume the link only after the channel active flag admits that path. A forty-byte runtime initializer covers track +09..30 and writes zero to +26 at `04:43CE`. The only other depth writers are Call at `04:478B` and Return at `04:47B6`: Call adds two only when the old depth is below $0A; Return subtracts two only when nonzero. Starting at zero, depths remain {0,2,4,6,8,10}, and the two Call stores occupy track +32..3B. Shared parameter/command BC producers and other field writes do not touch the depth or link fields. Corrupt active links, odd depths and arbitrary BC entries invalidate these bounds.

Within the ordinary frame body, fade/track preparation and channel service phases reset the iterators before their respective loops; final ChannelPhase resets all channels again. The service/update I/O callees do not select or advance another channel iterator internally. StartNote and NoteOff select channels during track processing; those selectors do not run inside the channel service loops. Under initialized valid records, exact normal loop entry/counts, serialized gateway execution, stable physical WRAM1/ROM4 and a valid separate CPU stack, these body writes preserve the admitted iterator/link families. Combining that conditional lifetime with the preceding 26 I/O-site formulas keeps D015 at 12/17/1C/21 when the admitted channel writers use it; pan uses 25 and wave copying uses 30..3F. Thus this admitted audio body does not write FF40. The earlier artificial SilenceChannel/D015=$40 counterexample remains valid outside the invariant.

External/computed writes, WRAM-bank changes, SDK/IRQ interleaving, real CPU stack integrity, deferred return-word/bank restoration and all invalid-entry states remain open boundaries.

### SDK interrupt boundaries and the literal API cohort

The known home serial/timer wrappers save and restore AF, BC, DE, HL and the ROM bank. SDK EI sites still permit nesting; bank restoration is not a proof that all SDK writes exclude audio state, LCDC or SVBK. The previously accepted conditional audio iterator proof and deferred C2BF gateway remain conditional on valid records, banks, stack and serialized service entry. These SDK results do not turn that internal iterator proof into a global interrupt-safety invariant.

### Browser destination roots and their limits

The initial Browser receive allocation uses SRAM bank3 with DE=B000 and BC=0FFC, after a separate $1000 (4096-byte) allocation clear.

Conditional on intact task arguments, SRAM enabling/bank, saved SDK words and coherent counters, the two-byte prefix leaves the body interval [B002,BFFC), with 4090 bytes.

ReturnMobileAPI at00:0198 pops the saved ROM bank into DE. In the consistent ordinary HTTP bank54 context that yields DE=0054, not the receive-buffer pointer. The polling loops include communication/UI work without an unconditional buffer-DE reload. Their separate DE-return families therefore cannot be treated as one preserved buffer contract. Initial URL/password copying, redirect strings, inline-pointer admission and all non-Browser API argument lifetimes retain their own bounds.

### Corrected BC=0 branch and the conditional paused interval

A separate conditional pause invariant applies to ordinary states13/14: ordered HTTP backpressure has produced Timer.bit2=1 and Substep3; the previous body response is processed; no stale or pending body95 completion is in flight; resend.bit3 and peer.bit4 are clear; status-only97/existingFF transactions are coherent; and no reentrant API/callback rewrites context. When the HTTP handler is actually selected by StateDispatch, Substep3 becomes4 and the local handler restores3 without the length publisher. The timer tail under these predicates does not create a fresh body95 request: the fresh95 branches require the excluded peer path and cached resend requires the excluded resend bit. The 32768 branch-predicate combinations are static arithmetic, not timer executions.

### Special states1F/21/24 and ordered close

Reaching partial-line LF/source preconditions, ReceivedLength/DestRemaining coherence, admitted nonzero copy counts, reentry, stale/retry packets, special-state high flags and actual caller/vector/LCDC provenance remain open; the following section derives their selected local mechanics.

### Header window, line scans and strict partial-line bounds

CopyBytes at75:4000 copies before decrementing B: B0 copies256, while B1..255 copies B. FindLineEnd at72A0 similarly treats input B0 as up to256 reads. With positive count n it returns HL after the first LF, remaining B=n-consumed and carry clear; no LF in n bytes returns carry. Thus LF at offset249 of the full Window leaves HL=C819. HeaderEnd70C1 reads [HL] without first checking B, so that lookahead is outside the physical 250-byte Window. Complete blank CRLF with at least two remaining bytes aligns the two pointer increments with BodyStart's two B decrements. A lone blank LF does not; an admitted no-LF/Rx9F continuation reaches BodyStart with B0 and its two decrements produce FE. These are local artificial/static cases, not naturally observed malformed-input failures. The synthetic CR/LF fallback at Window+248/+249 does not supply separator bytes after every LF.

JoinPartialLine71E1 scans backwards from offset249 without a lower-bound test. A nearest LF at j in0..248 yields tail r=249-j; final LF yields r0 and skips the first copy. The second source is Packet+4+(255-q), with q bytes, ending Packet+259 for positive q. It agrees with the actual final-q payload source Packet+5+p-q exactly when p254 (Packet[3]=FF). A consistent join requires that bounded LF, q1..254, remaining high byte0, coherent counters/pointers and p254, with no intervening clobber. It also requires **r+q<250**, rather than equality: the zero fill writes before testing its end. At r+q250 its first write is C819 and the modulo pointer formula requires65536 increments to return there. The complete wrap was not executed. For q0 the second CopyBytes instead copies256.

Recognized Date/GbAuthId/Uri/Location value readers run before the generic LF check and lack their own physical end bound. Bounded status delimiters, LF availability, CRLF format and destination capacities/nonaliasing remain required. Date and the second auth copy need room for the following NUL. Uri/Location strips two bytes with two DEC B operations: an empty CRLF value gives L2→B0, followed by256 copies and a NUL. The selected body-overflow copies similarly require positive output counts: capacity K2 gives K-2=0 in the Window overflow branch, and remaining0 gives zero in the packet overflow branch; the local calls then copy256. Zero-capacity/state20/22/23 exits avoid the admitted body copies, but do not prove those aligned overflow cases impossible. When buffered body B-before710E equals2, it skips the output-DE reload; an admitted early packet exit can carry incoming DE into the C6C8/C6C9 pointer stores at7188. This is distinct from the length publisher's C6C6/C6C7 or C717/C718 destination selection. The reaching origin of that incoming register value requires a separate proof.
