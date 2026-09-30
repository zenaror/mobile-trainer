# Boot path and ROM0 ("home") of Mobile Trainer (Japan)

> **Historical note.** Written when the source was one generated `src/bankNN.asm` per bank with generic `Label_BB_AAAA` labels.  In the current tree (`home/ engine/ data/ gfx/ audio/ lib/`) a `Label_BB_AAAA` that is only used inside its own function is a local label of that function (`.lAAAA`, `AAAA` = the address, or `.loop`/`.done`/`.skip`); one referenced from elsewhere keeps its global name; `Function_BB_AAAA`, `Data_BB_AAAA`, ... are unchanged, and where a semantic name was adopted the neutral name often remains as an alias label under it.  **Addresses (`bank:addr`) remain valid**: find the code with `grep -rn '; BB:AAAA' --include=*.asm .` or in `build/mobile_trainer.sym`.  Commands of the frozen bootstrap pipeline quoted here (`make regen`, `make verify`, `make tree*`, `tools/gen_asm.py ...`) no longer apply to the source (`gen_asm.py` only runs into a temp dir, `make legacy-check`); see `README.md`, "History", and `docs/README.md`.

Scope: everything that lives in bank 00 (`0000-3FFF`, only 5799 non-zero bytes) plus the RAM code it builds.
Evidence vocabulary: **CONFIRMED** (bytes/disassembly/trace you can cite), **PROBABLE**, **HYPOTHESIS**.
Addresses are CPU addresses (`bank:addr`, bank 00 = `0000-3FFF`, others `4000-7FFF`).
This file was adversarially re-verified (independent re-disassembly, the mGBA build with Mobile Adapter support driven through its CLI debugger, whole-ROM byte scans):
what was corrected or downgraded is listed in section 15; the statuses below already include those corrections.

Everything below is reproducible:

```
python3 tools/test_cfg.py                 # unit tests of the explorer (synthetic ROMs + real ROM + regs_written vs interpreter)
python3 analysis/rom0_selftest.py         # executable checks of the claims below (interpreter runs the ORIGINAL bytes)
python3 analysis/rom0_analysis.py         # regenerates analysis/proposals/*bank00*, ram_symbols, xrefs, entrypoints.json, farcall_targets.tsv
python3 tools/cfg.py --seed 00:0100 --inline 00:06D1=3:far --banks 00 --listing 00:0100-0340   # the tool itself
python3 tools/gen_asm.py verify --config <dir with the proposals>                                # byte-identical rebuild (checked, see 12)
```

## 1. Summary of findings

| # | finding | status |
|---|---|---|
| 1 | Entry `0100: nop ; jp $0278`. The five interrupt vectors `0040/48/50/58/60` are `jp $CBF1/F4/F7/FA/FD ; reti`: **RAM stubs** written by `00:04A0` (called from `4F:4783`). Defaults: VBlank -> `00:03BA`, STAT -> `reti`, Timer -> `00:01ED`, Serial -> `00:01B7`, Joypad -> `reti`. | CONFIRMED (bytes + interpreter, `rom0_selftest`) |
| 2 | Boot: CGB test on the value of A at entry (`$11`), CGB double-speed request, SRAM off, VRAM/WRAM/HRAM cleared, OAM-DMA routine copied to HRAM, `04:4000` initialised (APU registers), second stage `4F:4717`, ROM bank 1, then the **main loop `call FarCall(1C:4000)` forever**. Non-CGB hardware loops on `6B:4C80` and never reaches the main loop. | CONFIRMED (static + interpreter + mGBA: `PC=00:0328` with ROM bank 1 is reached from reset; forcing `A=$01` at `0100` ends in `6B:4C80`) |
| 3 | There is **no copy loop for interrupt code**: `00:04A0` stores the 13 bytes of the vector stubs one immediate at a time; `00:059F` copies the 10-byte OAM DMA routine (`00:05AC`) to `$FF80`; `00:0684` builds the 8-byte far-call trampoline at `$FFA8`. Banks 48/57/6B/7F patch the stubs at run time (table in 5). | CONFIRMED (bytes; mGBA memory at `00:0328`: `CBF1..CBFD = C3 BA 03 D9 00 00 C3 ED 01 C3 B7 01 D9`, `FF80..FF89 = 3E C0 E0 46 3E 28 3D 20 FD C9`); "no *other* writer of RAM code" is PROBABLE (a whole-ROM literal scan finds writes to `CBF7-CBFD` only at `00:04B6-04D4`, but indirect writes cannot be excluded) |
| 4 | ROM bank switching (MBC5) is centralised in ROM0: mirrors `FF8A/8B` (ROM lo/hi), `FF8C` (SRAM), `FF8D` (WRAM, rSVBK); the primitives `00:0622/063D/0658` pick the register from the **address region** of H/D/B; **`FarCall` (`call $06D1 ; dw addr ; db bank`)** is the universal far call (5274 raw byte-pattern matches of `CD D1 06`, 439 distinct `(bank,addr)` targets, 44 distinct bank bytes; 2239 matches have bank byte 0 = a ROM0 routine; the counts are exact but a match is only a *site* where the bytes really are code: 2189 of the matches were seen executing in mGBA with the inline target equal to the bytes, and only 23 are reached by structural links alone, see 7.7). | CONFIRMED (mechanism, primitives); the counts are a byte-pattern census |
| 5 | In the ROMX code reached by `tools/cfg.py` the only direct ROM-bank write is `68:424E` (inside a private copy of the tail of the bank-switch routine at `68:4239`, *without* the `or a ; ret z` A=0 shortcut). A whole-ROM byte scan for `ld [$2000-$3FFF],a` finds exactly one more sequence, `29:510F` (`ld [$2000],a ; xor a ; ld [$3000],a ; ret`), in unreferenced code of bank 29 (no `call/jp $510F` inside bank 29). SRAM, in contrast, is switched/enabled directly by ROMX code (257 RAM-enable and 165 SRAM-bank writes in reached code). | PROBABLE (register-indirect writes such as `ld [hl],a` with `hl=$2xxx` were not excluded) |
| 6 | ROM0 is a *library*: frame wait/service, LCD on/off, bank switching, far calls, HDMA/tilemap upload, a 14-slot sprite-object engine, arithmetic, PRNG, a byte-stream text interpreter with Shift-JIS-style lead bytes, string helpers, far read/copy helpers, and a 13-stub gateway into bank 04. | CONFIRMED (disassembly); purposes of groups are PROBABLE |
| 7 | The serial and timer interrupt handlers and the `MobileAPI` entry (`00:0150`) are thin shims that switch to **bank 75** (`75:56D2`, `75:58EA`, `75:4030`). They are structurally identical to `MobileReceive/MobileTimer/MobileAPI/ReturnMobileAPI` of pokecrystal `home/mobile.asm`, and `75:4030` matches pokecrystal `_MobileAPI` (`44:4030`) instruction for instruction (checked byte-wise against `pokecrystal.gbc`: 64 bytes, differing only in WRAM addresses, the `$018D` return address and one immediate, `ld a,$35` here vs `$36`). ROM0 itself never touches `rSB` and reads `rSC` only in the timer handler. (`tools/crystal_match.py`, `analysis/crystal_symbol_map.tsv`, places `MobileAPI`, `ReturnMobileAPI`, `MobileTimer` at the same addresses but only rates the ROM0 shims HYPOTHESIS: 18/23, 14/17 and 31/40 instructions aligned; it rates `_MobileAPI` at 75:4030 PROBABLE.) mGBA executes `00:0150 -> 75:4030 -> 00:018D`, `00:01B7 -> 75:56D2` and `00:01ED -> 75:58EA` within the first 3 M instructions. | PROBABLE (structural match with pokecrystal), roles of the shims CONFIRMED (disassembly + mGBA) |
| 8 | Bank 04 (`04:4000`, `04:4082` and 11 stub targets) is entered only through ROM0 stubs at `20A0-20EB`; `04:4000` programs the APU registers and clears 8x`$3C` + 4x`$18` byte structures. | PROBABLE: bank 04 is the sound driver |

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

Classification of all 16384 bytes (`analysis/proposals/bank00.tsv`, tiling verified, see 12): code 5502 (2276 CONFIRMED by a
structural path from proven entries, 3226 PROBABLE), data 341 (palette 64, PRNG table 256, 7 inline far-call argument blocks 21),
words 70 (`Table_00_0EF0`, `Table_00_161A`), ramcode 10, header 76, zero 10385.

## 3. Boot flow (`Boot` = `00:0278`)

Traced statically and on the interpreter (`analysis/rom0_trace.py`, checks in `rom0_selftest.py`).  Interpreter model: MBC5, SVBK/VBK banks,
LY synthesized, LCDC=`$91` at entry (boot-ROM state), a VBlank IRQ delivered at each `halt`.

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

Facts derived for later work: the WRAM clear at step 7 runs with the vector stubs **not yet installed** (RAM vectors are written in step 10);
`IE` is set to VBlank only at the end of the second stage; nothing in ROM0 enables the serial or timer interrupt bits, so that is done by other banks: found during verification, `75:4390` = `ld c,$FF ; ldh a,[c] ; or $0C ; ldh [c],a ; ret` (`IE |= $0C`, timer|serial; a write watchpoint on `[$FFFF]` in mGBA sees IE go `01 -> 0D` on the write at `75:4395` and back to `01` right after a write at `75:569A`, PC `75:569C`), and `75:4388` = `ld a,$2D ; ld [$C709],a` sets the timer-shim enable `[C709]` (PROBABLE: roles inferred from these sequences).

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

* **`Int_VBlank` (`03BA`)**: unless `[C2F5]!=0` (`wOAMDMASuppress`) `call $FF80`; increments `[C2DF]` (`wVBlankFlag`, saturating at `$FF`); two frame->second->minute clocks
  (`C2D4-C2D6` gated by bit 4 of `[C69F]`: when the minutes reach `$46` they are set back to `$3C`, seconds/frames to 0 and bit 1 of `[C26F]` is cleared; `C266-C268` gated by bit 0 of `[C69F]`: minutes saturate at `[C26D]`); `FFFC` counts frames in which the frame service did not run
  (`C2BF==0`), `C2BF` cleared every frame. Ends with `reti`. CONFIRMED (disassembly); what the clocks measure is unknown.
* **Wait routines**: `044B` (wait VBlank flag, then frame service), `0464` (flag only), `047A` (flag, returns with IME=0 right after VBlank).  They `ei ; halt` until `C2DF != 0`, then clear it. If the LCD is off they do not wait.
* **Frame service `0392`**: runs at most once per frame (`C2BF`), enters `04:4082` through stub `20A6` with `rSVBK=1`.  It is called from every wait routine, `LCDOff`, the text interpreter after each character, the HDMA waits and from other banks (14 call sites in ROM0, 173 raw call/jp patterns elsewhere).
* **`Int_Serial` (`01B7`)**: save AF/BC/DE/HL, save the 16-bit ROM bank, switch to bank `75`, `call 75:56D2`, restore bank, `reti`. CONFIRMED.
* **`Int_Timer` (`01ED`)**: `TAC=0`, `IF&=$1B` (clears the timer, and also bits 5-7 of IF); **if `[C709]==0` it returns at once (`01FE jr z,$0242`): `TIMA`/`TAC` are then NOT restarted, the timer stays stopped**. Otherwise, if bit 1 of `[C6C1]` is clear and `rSC` bit 7 is clear: save ROM bank, `call 75:58EA`, restore; in every non-`C709==0` case then `TIMA=TMA`, `TAC=6` (enabled, clock select 10 = 65536 Hz, doubled in the CGB double-speed mode that Boot selects). CONFIRMED (disassembly, `rom0_selftest`; mGBA executes `01ED -> 0227 -> 75:58EA` and the `023A` path). (The first version of this file said the timer was always restarted: retracted.)
* **Alternative STAT handlers**: `16C4` (if LY==`$80`: SCX=`[C0EF]`), `16DC` (raster effect with WY, `C0F6`, LYC), `0E93` (LY==0: LYC=`[D724]`, SCY=0; else SCY=`[C0D3]`, LYC=0, optional `call 0392` if `[D824]`).

## 6. The main loop and frame structure

The ROM0 loop is only `FarCall(1C:4000)` repeated (section 3).  Frames are paced by the wait routines above (`ei ; halt` until the VBlank counter changes), which
also run the bank-04 service once per frame.  There is no polling of `rP1` in ROM0 (`hFFA5/hFFA7` are consumed by `JoypadDispatch` but produced in bank 7D / other banks, see 13).

## 7. MBC5 bank switching

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

<!--CALLSITES-->
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
<!--/CALLSITES-->

### 7.6 Other direct bank switching in ROM0

Straight-line "literal bank" sequences (`ld a,N ; ldh [FF8A],a ; ld [$2100],a`) select fixed banks for a call or a table access (all are seeds for later analysis; see `analysis/farcall_targets.tsv`, `analysis/proposals/xrefs_bank00.tsv`):

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

### 7.7 Direct MBC writes and usage statistics

ROM0 writers (from `analysis/rom0_hw_accesses.tsv`): `[0000]`: `0296, 06AD, 15D7, 1614, 164E, 1658`; `[2000]`: `0182, 01A1, 01CD, 01E1, 021F, 0233, 2101`; `[2100]`: 35 sites; `[3000]`: `0187, 01A5, 01D2, 01E5, 0224, 0237, 025F, 0271, 0324, 2107`; `[4000]`: `0299, 0633, 064E, 0669, 06A7, 15D0, 160A, 1647, 1660`.
Reached ROMX code contains **one** ROM-bank write (`68:424E`, inside a private copy of the tail of `BankSwitch_H` at `68:4239` that lacks the `or a ; ret z` shortcut; mGBA only ever executes its SRAM path `68:4246-424B`), plus `29:510F` in unreferenced bank-29 code found by a whole-ROM scan (PROBABLE, see finding 5), 257 RAM-enable writes and 165 SRAM-bank writes (banks 0E, 0F, 22-2F, ...): SRAM is managed directly by the banks (helpers such as `0E:4030` "write B to `[HL]` in SRAM bank 1"), not through ROM0.
Static `FarCall` census (`analysis/farcall_targets.tsv`): 5274 sites, 439 distinct targets, 44 distinct bank bytes (00 = ROM0 target); top targets `00:0A82, 00:0787, 00:0956, 4F:4370, 4F:4000, 00:08EA, 00:0D67, 7F:72B0, 7D:7BB7`.
Confidence: 23 sites CONFIRMED (in code reached by structural links only), 3861 PROBABLE (site in code reached through inferred links: bank guessed from an MBC write, heuristic table), 1390 HYPOTHESIS (byte pattern only).

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

## 10. RAM map fragments (justified names in `analysis/proposals/ram_symbols.tsv`)

HRAM: `FF8A ROM lo`, `FF8B ROM hi`, `FF8C SRAM`, `FF8D WRAM`, `FFA3 A-at-boot`, `FFA8-FFAF trampoline`, `FFF2 A scratch`, `FFF3 far-bank arg`, `FFF4 VBK mirror`, `FFF5 SRAM-enable mirror`, `FFFC/FFFD/FFFE` service starvation counter / PRNG index / PRNG state,
`FFBA-FFC6` text cursor/limits, `FFB0/FFB1/FFB9/FFBF` scratch/state of the text interpreter, `FFF0/FFF1` (added by `0A1A`, cleared by the sprite reset).
WRAM0: `C000-C09F` shadow OAM (`C004` first slot written by the sprite engine), `C0A0-C0CF` glyph half buffers (`0E7E`, `1044`, `10B1`), `C0D3/C0EF/C0F6` STAT-handler variables, `C10E-C11D` 16-byte copy buffer (`172D`), `C12E` scratch (`1620`),
`C130-C135` saved vector stubs, `C266-C268/C26D` and `C2D4-C2D6` clocks, `C2BF/C2DF/C2F3/C2F5` frame service / VBlank / OAM pointer / DMA suppress, `C380` token output buffer, `C6C1/C69F/C709` flag bytes, `C820-C825` API argument save (`C825` index), `CBF1-CBFD` vector stubs.
WRAM1: `D000-D004`, `D026/D027` (bank-04 gateway), `D724/D824` (STAT handler variables). WRAM7: `D000-D3FF` tilemap buffer, `D400-D7FF` attribute buffer (uploaded with HDMA to VRAM bank 0/1 at `$9800/$9C00`), `DA00-DADF` 14 sprite slots. WRAM5: `D000` string buffer (`153D`). SRAM bank 1: `B013`, strings at `B014/B025/B036/B047` XOR-`$A5`-obfuscated (`EncodeXorA5/DecodeXorA5`).

## 11. Function inventory (generated from `analysis/proposals/bank00.tsv`)

<!--INVENTORY-->
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
| `0AB8-0AE7` | `Function_00_0AB8` | code | CONFIRMED | fills slot fields from the 4-byte table entry at DE+4*(A&$7F) (used by 0A82) |
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
<!--/INVENTORY-->

## 12. Verification performed

* `tools/test_cfg.py`: 48 tests, all passing (flow, blocks, bank resolution/inference, inline conventions, tables, suspicious detection, overlays, back-scan, hardware accesses, CLI, `regs_written` vs interpreter for every non-branching opcode, real-ROM boot path).
* `analysis/rom0_selftest.py`: 71 checks, all passing, on the interpreter running the original bytes (boot to `1C:4000`, DMG path, RAM stubs, OAM DMA, bank primitives, `FarCall`/`JumpTableInline`/`JumpTableBank` conventions with test code patched into a private in-memory ROM copy, multiply/divide/PRNG/string helpers).
* `analysis/rom0_analysis.py`: regions tile `0000-3FFF` exactly; every byte of every `code` region is reached by the CFG (or is a `reti` after a vector `jp`); regions re-emitted through `tools/sm83.py` and assembled with rgbasm/rgblink equal `baserom.gbc[0000:4000]`.
* `python3 tools/gen_asm.py verify --strict --config <dir>` with the proposals (`bank00.tsv`, `symbols_bank00.tsv`, `ram_symbols.tsv`, `xrefs_bank00.tsv`) rebuilds the full 2 MiB ROM: `RESULT: IDENTICAL`.
* `python3 analysis/rom0_mgba_check.py` (added by the adversarial review): the same claims on a real emulator (mGBA CLI debugger), see section 15.

## 13. Open questions / unknowns

* What the frame service (`04:4082`) and `04:4000` really are (sound driver is the working hypothesis); what `65:4000`, `0E:4000`, `7C:7B7C`, `7C:7D1F`, `7D:7BF0` do (the top-level state machine in `1C:4000`).
* `IE |= $0C` is done by `75:4390` and `[C709]=$2D` by `75:4388` (found by the verification, see 3 step 12 note); still open: who calls those two sequences, what the value `$2D` means, and what sets `C6C1` bit 1.
* `hFFA5` is produced by bank 7D (found during verification): `7D:7B7C` reads `rP1` (`$20` selects the D-pad -> high nibble, `$10` selects the buttons -> low nibble, result inverted to active high), `7D:7BB7 -> 7BC1` stores `(old xor new) and new` (newly pressed) in `FFA5`, the current state in `FFA4` and `FFA5|auto-repeat` in `FFA6` (repeat counters at `C2E5-C2EC`, delays `C2E1=$14`, `C2E2=2`; `7D:7BF0` initialises them: this is the `FarCall 7D:7BF0` of the boot). So `JoypadDispatch` indices 0..3 are A, B, Select, Start (rP1 layout, PROBABLE). Still open: who writes `hFFA7` (raw `ldh [$FFA7],a` byte patterns in many banks: `1D:5F3F`, `2D:70FD`, `4A:62DF`, ...; not checked whether they are code) and with what meaning. ROM0 itself never reads `rP1`.
* Purpose of the two clocks in `Int_VBlank` (`C2D4-C2D6`, `C266-C268`), the odd routine `0D34` (writes ROM bank `$F0`, reads `[$C200+E]`; its only visible effect is the sign-extended WRAM byte in DE) and the unreferenced `0247`, `06E5`, `0716`, `072E`.
* Exact slot layout of the sprite engine (`0AE8`), meaning of the bank-7F far calls in the glyph routines, and whether `1119` is really an HTML-like parser.
* Bank 75 is the Mobile SDK library (`75:4030` = `_MobileAPI`); a byte-level alignment against pokecrystal `lib/mobile` belongs to the bank-75 analysis (`tools/crystal_match.py`).
* Indirect transfers left in ROM0 (`CFG.unresolved`): `0550` (`JumpTableBank/Inline`, targets live in the callers' tables), `0569` (`FarJumpTable`), `0EEF` (text control bytes: resolved by seeding the 32 words of `Table_00_0EF0`, correct because `0EDE cp $20 ; jr nc` bounds the index), `0B53` (`push bc ; push de ; ret` at `0B4E`: an indirect call to the sprite hook in DE whose return address is the constant `$0B54`; `0B54` was added as a seed by hand).
* `tools/cfg.py` limitations: inline word tables are parsed heuristically (`CFG.tables` lists them); `jp hl` targets other than `Table_00_0EF0` are not resolved (`CFG.unresolved`).

## 14. Files

`tools/cfg.py`, `tools/test_cfg.py`, `analysis/rom0_analysis.py`, `analysis/rom0_trace.py`, `analysis/rom0_selftest.py`, `analysis/entrypoints.json`, `analysis/farcall_targets.tsv`, `analysis/rom0_hw_accesses.tsv`, `analysis/rom0_ram_usage.tsv`,
`analysis/proposals/bank00.tsv`, `analysis/proposals/symbols_bank00.tsv`, `analysis/proposals/ram_symbols.tsv`, `analysis/proposals/xrefs_bank00.tsv`, `analysis/rom0_mgba_check.py`, this file.

## 15. Adversarial verification: what was re-derived, corrected, retracted

Method: every cited address was re-disassembled with `tools/sm83.py` from the raw ROM; the boot path, the RAM code, the bank-switch primitives, `FarCall`, `JumpTableInline`, `JoypadDispatch`, the arithmetic/string helpers and the interrupt shims
were executed on **mGBA** (the Mobile-Adapter fork built on this machine, driven through `mgba -d`; 20 M instructions traced, plus a patched ROM copy for the calling conventions); whole-ROM byte scans re-counted the call-site, MBC-write and vector-write claims;
`tools/cfg.py` was compared with 42 442 distinct instruction starts executed in 18 mGBA scenarios (`analysis/coverage_union.tsv`, another agent's trace) and with an mGBA trace of this review: 0 length mismatches and 0 overlapping decodes; every executed ROM0
instruction lies at an instruction start of a `code` region of `analysis/proposals/bank00.tsv`, whose regions tile `0000-3FFF` with no instruction crossing a region boundary (re-checked with an independent script). Re-running `analysis/rom0_analysis.py` reproduces every generated file byte for byte;
`gen_asm.py verify --strict` on a temporary config built from the proposals gives `RESULT: IDENTICAL`.

**Upheld (independently re-derived)**: vectors and RAM stubs (C1); OAM DMA copy, trampoline bytes, the patchers in banks 48/57/6B/7F (C2, C17, whole-ROM scan of `CBF1-CBFD` writes); boot flow and both CGB/DMG outcomes (C3); `1C:4000` program (C4); `BankSwitch_*`/`GetBank_H` and the HRAM mirrors
(C5; `FF8E` is not used by any executed code: the two raw `F0 8E` byte pairs, at `46:44AF` and `65:520B`, sit in tile-like data and never execute); `FarCall`, `JumpTableInline`, `JoypadDispatch` semantics (C6, C7; mGBA); `MobileAPI`/`Int_Serial`/`Int_Timer` shims (C8, apart from the correction below);
the helper semantics of C10 (Multiply16, Multiply8x16, Multiply16x16to32, Divide16, Divide32by15, `0BBD`, Random, Random16, StringLength, CompareString, CompareStringN, Encode/DecodeXorA5, CopyString, `14F3`, FillBytes: 15-60 random cases each on mGBA);
region tiling (C11); hardware-register census of ROM0 (C14: independent decode of all `code` regions gives the same address lists); text interpreter tables and lead-byte ranges (C15); frame-service logic (C19); no static callers of `0247/06E5/0716/072E/0D34` (C20).

**Corrected / downgraded / retracted**

| id | original statement | correction | new status |
|---|---|---|---|
| C3 | the first LCDOff "runs the frame service (bank 04 code) before any RAM init" | it always *calls* `0392`; entering `04:4082` needs `[C2BF]==0` and `[D000]` bit7 clear. With zero WRAM (our interpreter) it does; in mGBA (non-zero power-on WRAM) `2129` returns `A=$FF` and `04:4082` first runs after `04:4000`. `rom0_selftest.py` now labels the assertion as a zero-WRAM model assumption | PROBABLE (state-dependent) |
| C8 | `Int_Timer` always finishes with `TIMA=TMA`, `TAC=6` | when `[C709]==0` it returns at `01FE` **without** restarting the timer (TAC stays 0); only the `C6C1.bit1`/`rSC.bit7` skip paths still restart it. Frequency `65536 Hz` holds for single speed only (Boot selects double speed: 131072 Hz). `rom0_selftest.py` gained two checks | CONFIRMED (corrected text) |
| C2 | "No copy loop exists for interrupt code" | positive facts stand; the negative "no other RAM-code writer" rests on a whole-ROM literal scan plus the reached-code census, indirect writers cannot be excluded | PROBABLE (negative part) |
| C6 | "5274 static sites" of `FarCall` | exact count of the byte pattern `CD D1 06` (5274; 2239 with bank byte 0; 439 targets; 44 bank bytes); only 23 sites are reached by structural links alone, 2189 were seen executing (all with matching target), 1390 are pattern-only | CONFIRMED (mechanism) / PROBABLE (sites) |
| C13 | "the only direct ROM-bank write in reached ROMX code is `68:424E` (a private copy of BankSwitch_H)" | `68:4239` is a copy of the *tail* of `BankSwitch_H` without the `or a ; ret z` shortcut; a whole-ROM scan also finds `29:510F` (`ld [$2000],a ; xor a ; ld [$3000],a ; ret`) in unreferenced bank-29 code; register-indirect writes are not excluded | PROBABLE |
| C20 | `0D34` "reads bank `$F0`" | it writes ROM bank `$F0` but then loads `[$C200+E]`, a WRAM byte; the bank write cannot influence the load | PROBABLE (corrected text) |
| C4 | `0E:4000` "returns A in 0..2" | inferred only: `JumpTableInline` has no bounds check; `A` is also *passed into* `0E:4000` (0, `$19` or 1) | HYPOTHESIS for the range |
| C9 | `MobileAPI`... "same instruction sequences with different WRAM addresses" | true against pokecrystal English (`pokecrystal.gbc`: WRAM addresses, `$018D`/`$3E60`, and one immediate `$35`/`$36` differ for `_MobileAPI`); `tools/crystal_match.py` rates the ROM0 shims only HYPOTHESIS (18/23, 14/17, 31/40 instructions aligned) | PROBABLE (kept) |
| §5 | 7F "restores the STAT stub from `C130-C132`" | only 48 and 57 do; 7F writes `reti` to `CBF4` | fixed |
| §7.3 | `06BC` caller `4F:400B` | the `call` is at `4F:4008`; `4F:400B` is its inline word | fixed |
| RAM | `hWRAMBank` "every access paired with `ldh [rSVBK]`"; `wFrameServiceRan` "set when the service runs"; `wBank4State` "WRAM bank 1" | Boot and `0392` write `rSVBK` without updating `FF8D`; `0392` sets `C2BF` whenever it *attempts* the service; the `D000` guard state lives in whichever WRAM bank is selected | text fixed |
| misc | `0F68` newline | `FFC6==$FF` returns at once (end of text); otherwise `Y+=FFC6` and continue only while `Y<=FFC3` | text fixed |
| misc | `Function_00_06B7` CONFIRMED (structural path through the trampoline's default `jp $06B7`) | only reached if the trampoline is entered without a patched target; never executed in 20 M mGBA instructions; code CONFIRMED count 2281 -> 2276 bytes | PROBABLE |
| misc | `rom0_ram_usage.tsv` row `FFF6` | `0AF6 ld de,$FFF6` is an immediate (-10), not an access; header comment added | noted |

**New facts found during verification** (PROBABLE unless marked): `7D:7B7C/7BC1` is the joypad reader that feeds `FFA5` (see 13; the byte sequence is CONFIRMED, the A/B/Select/Start mapping follows the rP1 layout); `75:4390` `IE |= $0C` and `75:4388` `[C709] = $2D` (bank 75 enables the serial and timer interrupts; mGBA watchpoint: IE `01 -> 0D`); `1C:4000` state 0 passes `A=$19` into `0E:4000` (CONFIRMED by bytes);
`04:4000` sets `[D000]=$FF` (bits 7 and 6 both set) while it runs and `0` when done (CONFIRMED by bytes); `0E93` STAT handler updates `FF8D` while it forces WRAM bank 1.

**Not verified** (kept at their original status): the sprite-object slot layout (`0AE8`, HYPOTHESIS), the HTML-like scanner (`1119`, HYPOTHESIS), the sound-driver role of bank 04 (`04:4000` does write `rNR52/NR51/NR12/NR22/NR42/NR14/NR24/NR44/NR30/NR50`: CONFIRMED; the role stays a hypothesis), `analysis/farcall_targets.tsv` per-row confidence tiers beyond the 2189 executed sites, and the interpreter itself (`analysis/rom0_trace.py`), which was validated only through the mGBA cross-checks above.
