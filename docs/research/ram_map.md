# RAM map: first-cut static census (generated)

**Addresses (`bank:addr`) remain valid**: find the code with `grep -rn '; BB:AAAA' --include=*.asm .` or in `build/mobile_trainer.sym`.

Evidence vocabulary: **CONFIRMED** = shown by cited bytes/disassembly; **PROBABLE** = strong but not
conclusive; **HYPOTHESIS** = interpretation only. Addresses `BB:PPPP` are CPU addresses (bank 00 =
0000-3FFF, banks 01-7F = 4000-7FFF).

* **Tier 1 (proven flow).** Recursive descent from the entry point `0100` (-> `0278`), the five interrupt   vectors `0040-0060` (which jump into WRAM trampolines, see 2.6) and the targets of those trampolines.

Inline table dispatchers are understood: `call $0545` (word table follows, index in A) and `call $056A`   (exactly 5 words follow, chosen by the button bits in FFA5/FFA7), both CONFIRMED by their code   (00:0545-0550, 00:056A-059C).

* **Tier 2 (heuristic, counted separately in the `_t1` columns).** (a) raw `call <routine>` byte patterns of   the most-called bank-0 routines (including the 5274 raw `call $06D1` sites) used as anchors; (b) the byte after   a terminator (`ret/jp/jr/jp hl`) or after a data run; (c) runs of >= 3 words that all decode as clean code   entries.

Every probe is transactional: an illegal opcode, a run of >= 4 `nop`/`rst $38`, overlap with data,   4 consecutive register ALU opcodes, `rst`, `stop`, self-moves (`ld b,b`), accesses to echo/unusable memory or   unnamed I/O, a `jp hl` without H/L set-up, or too little positive evidence (calls to known code, accesses to   HRAM/WRAM/named IO; score >= 3) discards the whole probe.

`ld r16,imm16` with imm >= $8000 is an *address load* (`n_addr_loads`);   it can be a pointer or a plain 16-bit constant.

Register state is not merged across branches: accesses   through pointers set in another basic block are not attributed (under-count), a label keeps the state of the   first path that reached it, and a backward conditional branch drops every register the loop body modifies   (`loop_kill`; the first version kept the first-iteration state after the loop and mis-attributed post-loop   `[hl]/[de]` accesses: 32 of the 2804 pointer-based accesses of the first version were removed by the review).

Result of this run: **101953** instructions reached (tier 1 = proven flow: 70652, tier 2 = heuristic: 31301); **25626** memory accesses/address loads extracted; **1648** distinct addresses >= $8000 (plus MBC writes).

RAM vector trampolines recovered from constant-tracked `C3 lo hi` stores (bank of the storing code, vector, jp target): 00:$CBF1->$03BA, 00:$CBF7->$01ED, 00:$CBFA->$01B7, 48:$CBF1->$16D4, 48:$CBF4->$16C4, 57:$CBF4->$16DC, 6B:$CBF1->$4D1F, 7F:$CBF4->$0E93.

Calls to bank-0 routines called >= 10 times from tier-1 code used as tier-2 anchors: 06D1(x3847), 0464(x375), 20AC(x316), 0A65(x306), 0392(x147), 082C(x100), 044B(x98), 04D8(x78), 1620(x78), 050C(x54), 20E8(x51), 0622(x44), 047A(x42), 09E6(x32), 0545(x23), 0ED3(x19), 056A(x17), 063D(x16), 0A45(x14), 20A6(x12), 0749(x12), 14BF(x12), 07CB(x10).

### Per-bank coverage (bytes)

`nonzero` = bytes that are not $00; `t1`/`t2` = bytes covered by tier-1/tier-2 decoded instructions (zero operand bytes inside instructions included);
`inline` = bytes classified as inline data (farcall operands, jump tables, RAM-address tables).
Banks not listed are entirely $00. Banks listed with 0 covered bytes are treated as data (graphics,
text, HTML pages) or as code not reachable by the seeds; **no RAM access is counted for them**.

| bank | nonzero | t1 | t2 | inline | covered (% of 16 KiB) |
|---|---|---|---|---|---|
| 00 | 5799 | 4231 | 1027 | 47 | 32% |
| 04 | 15403 | 2966 | 1078 | 100 | 25% |
| 05 | 10291 | 0 | 0 | 0 | 0% |
| 0E | 7413 | 139 | 694 | 98 | 6% |
| 0F | 7420 | 25 | 3068 | 10 | 19% |
| 19 | 3210 | 0 | 2735 | 242 | 18% |
| 1A | 4568 | 962 | 0 | 97 | 6% |
| 1B | 1026 | 0 | 844 | 91 | 6% |
| 1C | 49 | 29 | 0 | 18 | 0% |
| 1D | 7644 | 858 | 0 | 112 | 6% |
| 1E | 7873 | 0 | 0 | 0 | 0% |
| 1F | 1570 | 1479 | 0 | 154 | 10% |
| 22 | 8653 | 2818 | 605 | 405 | 23% |
| 23 | 15221 | 4799 | 5356 | 1314 | 70% |
| 24 | 13059 | 4510 | 0 | 354 | 30% |
| 25 | 13928 | 5642 | 0 | 483 | 37% |
| 26 | 12292 | 5165 | 286 | 723 | 38% |
| 27 | 12756 | 2809 | 793 | 541 | 25% |
| 28 | 11147 | 572 | 0 | 123 | 4% |
| 29 | 8187 | 3524 | 0 | 387 | 24% |
| 2A | 13759 | 6456 | 444 | 787 | 47% |
| 2B | 14195 | 4476 | 1678 | 737 | 42% |
| 2C | 13752 | 5174 | 1575 | 601 | 45% |
| 2D | 13851 | 7027 | 819 | 622 | 52% |
| 2E | 12266 | 4431 | 223 | 576 | 32% |
| 2F | 14942 | 9197 | 162 | 931 | 63% |
| 3D | 4464 | 0 | 0 | 0 | 0% |
| 3E | 13677 | 0 | 0 | 0 | 0% |
| 3F | 260 | 0 | 0 | 0 | 0% |
| 41 | 8700 | 0 | 0 | 0 | 0% |
| 42 | 9453 | 0 | 0 | 0 | 0% |
| 43 | 7747 | 0 | 0 | 0 | 0% |
| 44 | 9422 | 0 | 0 | 0 | 0% |
| 45 | 9357 | 0 | 0 | 0 | 0% |
| 46 | 9147 | 0 | 0 | 0 | 0% |
| 47 | 6680 | 0 | 0 | 0 | 0% |
| 48 | 5228 | 2366 | 154 | 114 | 16% |
| 4A | 10705 | 0 | 0 | 0 | 0% |
| 4B | 13630 | 0 | 0 | 0 | 0% |
| 4C | 4570 | 4146 | 55 | 492 | 29% |
| 4D | 11326 | 0 | 0 | 0 | 0% |
| 4E | 9082 | 4919 | 2300 | 820 | 49% |
| 4F | 1960 | 1354 | 563 | 128 | 12% |
| 50 | 8893 | 793 | 0 | 97 | 5% |
| 51 | 9066 | 1391 | 0 | 58 | 9% |
| 52 | 1787 | 0 | 0 | 0 | 0% |
| 53 | 344 | 0 | 0 | 0 | 0% |
| 54 | 4832 | 4385 | 107 | 381 | 30% |
| 55 | 8795 | 2707 | 1525 | 375 | 28% |
| 56 | 11106 | 0 | 0 | 0 | 0% |
| 57 | 5304 | 5128 | 101 | 444 | 35% |
| 58 | 12029 | 0 | 0 | 0 | 0% |
| 5B | 5169 | 0 | 0 | 0 | 0% |
| 5C | 7849 | 849 | 0 | 97 | 6% |
| 5D | 12529 | 0 | 0 | 0 | 0% |
| 5E | 11145 | 0 | 0 | 0 | 0% |
| 5F | 7856 | 0 | 0 | 0 | 0% |
| 60 | 13419 | 0 | 0 | 0 | 0% |
| 61 | 13584 | 0 | 0 | 0 | 0% |
| 62 | 8604 | 0 | 0 | 0 | 0% |
| 63 | 4649 | 45 | 269 | 48 | 2% |
| 65 | 6619 | 751 | 1472 | 472 | 16% |
| 66 | 10774 | 0 | 0 | 0 | 0% |
| 67 | 9812 | 6490 | 2410 | 1074 | 61% |
| 68 | 14117 | 4222 | 8872 | 1230 | 87% |
| 69 | 2074 | 281 | 0 | 57 | 2% |
| 6A | 11231 | 0 | 0 | 0 | 0% |
| 6B | 1640 | 156 | 0 | 0 | 1% |
| 6C | 8304 | 3609 | 28 | 329 | 24% |
| 70 | 11753 | 167 | 1696 | 111 | 12% |
| 71 | 12195 | 0 | 0 | 0 | 0% |
| 72 | 12909 | 3623 | 0 | 377 | 24% |
| 73 | 5864 | 845 | 0 | 127 | 6% |
| 74 | 7061 | 3174 | 3319 | 215 | 41% |
| 75 | 15763 | 2591 | 11984 | 94 | 90% |
| 76 | 8820 | 0 | 0 | 0 | 0% |
| 77 | 14124 | 0 | 0 | 0 | 0% |
| 78 | 14102 | 0 | 0 | 0 | 0% |
| 79 | 14074 | 0 | 0 | 0 | 0% |
| 7A | 13190 | 0 | 0 | 0 | 0% |
| 7B | 14042 | 0 | 0 | 0 | 0% |
| 7C | 14562 | 391 | 84 | 172 | 4% |
| 7D | 14125 | 150 | 0 | 0 | 1% |
| 7E | 8275 | 655 | 152 | 10 | 5% |
| 7F | 13468 | 2834 | 5201 | 494 | 52% |

## 2. Memory-mapper and runtime infrastructure (CONFIRMED unless marked)

**Registers for the three switchable memories (CONFIRMED).** ROM bank: low 8 bits `ld [$2100],a` with the shadow    `FF8A`, bit 8 `ld [$3000],a` with shadow `FF8B` (00:0637-063C, 00:2101-2109).

SRAM bank `ld [$4000],a` with    shadow `FF8C` (00:0631-0636).

CGB WRAM bank `ldh [$FF70],a` with shadow `FF8D` (00:062C-062F). 2.

**Region-generic bank setter `00:0622` (CONFIRMED).** `A` = bank, `H` = high byte of the address that will be    used: H<$80 -> ROM bank (FF8A/$2100); $80<=H<$C0 (bit 6 clear) -> SRAM bank (FF8C/$4000); H>=$C0 -> WRAM    bank (FF8D/FF70).

Variants take the address high byte in D (`00:063D`) or B    (`00:0658`); `00:0673` is the matching getter (returns the current shadow for the region of H). 3.

**Farcall `00:06D1` (CONFIRMED).** `call $06D1` is followed by three inline bytes `dw address, db bank`.

The    routine stores A/HL into an 8-byte HRAM stub, sets the bank for the region of the target address with the    setter above, calls the stub, and restores the previous bank.

A raw byte scan finds 5274    `CD D1 06` sites (2239 with target bank $00, 623 -> bank 7F, 658 -> bank 4F, 241 -> bank 7D, ...).

**Bank-4 thunk block `00:20A0-2180` (CONFIRMED).** Entries `call 00:2116 ; jp $4xxx` (`00:20AC..20E8`) and    `call 00:2129 ; jp $4082` first save the current ROM bank in `D001/D002` (`00:20EE-20F5`), select bank 04    (`00:20FF-2104`, `ld [$2000],a`: the same ROMB0 register range as `$2100`) and set the flags in `D000`; `00:2141`    restores.

`D000-D004` are in the banked WRAM window: the two callers checked (`00:03AB-03AF`, `2A:5F28-5F2F`)    select WRAM bank 1 first; the other thunk callers were not checked.

So bank 04 is the target of these thunks (`04:4000`, `04:4082`, `04:41C0`, ...). 5.

**Inline dispatchers (CONFIRMED).** `call $0545` = jump through a word table that follows the call (A = index).

`call $056A` = read buttons and dispatch through exactly five following words (A/B/Select/Start/none).

**Interrupt vectors are RAM trampolines (CONFIRMED).** ROM `0040/48/50/58/60` = `jp $CBF1/CBF4/CBF7/CBFA/CBFD`.

`00:04A0-04D6` writes `C3 BA 03` (jp $03BA, VBlank), `D9` (reti, STAT), `C3 ED 01` (jp $01ED, timer),    `C3 B7 01` (jp $01B7, serial), `D9` (reti, joypad) to those addresses.

The VBlank (`CBF1`) and STAT    (`CBF4`) trampolines are re-pointed at run time by banks 48 (`48:4413-4452`, `48:44AE-44CB`: save/replace with    `jp $16D4` / `jp $16C4`), 57 (`57:4525-4543`, `57:46ED-46FB`: `jp $16DC`), 6B (`6B:4CD8-4CE2`: `jp $4D1F`, a    banked address, valid only while that bank is mapped - HYPOTHESIS) and 7F (`7F:727F-72B6`: `jp $0E93`, later    restored to `D9`).

**Boot sequence (CONFIRMED by 00:0278-02F7).** Saves the boot A in `FFA3` (compared with $11 for CGB),    `di`, clears rTAC/rIF/rIE, clears `C2DF`, `sp=$FFFE`, switches VRAM bank 1 and clears $8000-9FFF, clears    WRAM banks 2-7 ($D000-DFFF each) via rSVBK, selects bank 1, clears $C000-DFFF and VRAM bank 0, sets    `sp=$CFFF`, clears HRAM `FF80-FFFD`, copies the OAM DMA routine to `FF80` (`00:059F`), calls the bank-4 thunk    `00:20A0` (-> `04:4000`, with SVBK=1 selected around it) and `4F:4717`, sets ROM bank 1/0 (`00:0317-0327`),    `ei`, and loops forever at `00:0328`: `call $06D1 ; dw $4000, db $1C ; jp $0328`, i.e. a farcall to `1C:4000`,    which itself farcalls `65:4000` and `0E:4000` and dispatches through a `call $0545` table. 8.

**Joypad.** `7D:7B7C-7BF0` polls rP1, computes held (FFA4), newly pressed (FFA5), pressed+repeat (FFA6) (all CONFIRMED    by the disassembly).

`FFA7` is read and cleared by `00:056A` and its bits are OR-ed with the FFA5 value in a register    (not stored back).

Six producers explicitly store zero; 51:41D3 stores returned A.

**Serial/timer.** Only banks 00 and 75 touch rSB/rSC/rTIMA/rTMA/rTAC/rKEY1; the timer/serial ISRs at    `00:01ED` / `00:01B7` are reached through the RAM trampolines above. (Bank 75 is therefore the serial-link    driver, HYPOTHESIS: this is the Mobile Adapter GB transport.)

## 3. HRAM (FF80-FFFE)

`r`/`w` = static read/write instruction counts, `l` = `ld r16,$FFxx` loads (some are 16-bit
constants, not pointers: e.g. `ld de,$FFFF` = -1 sentinel), `banks` = number of distinct ROM banks
(0 = fixed bank) containing accessors. Proposed names: only where evidence is listed.

| addr | name | r | w | l | banks | status |
|---|---|---|---|---|---|---|
| FF80 | hOamDmaRoutine | 0 | 1 | 1 | 1 | CONFIRMED |
| FF8A | hRomBankLo | 13 | 39 | 11 | 4 | CONFIRMED |
| FF8B | hRomBankHi | 7 | 12 | 0 | 3 | CONFIRMED |
| FF8C | hSramBank | 78 | 337 | 0 | 24 | CONFIRMED |
| FF8D | hWramBank | 606 | 1498 | 0 | 42 | CONFIRMED |
| FF9C | hRam_FF9C | 0 | 0 | 5 | 4 |  |
| FFA0 | hRam_FFA0 | 0 | 0 | 1 | 1 |  |
| FFA3 | hBootA | 3 | 1 | 0 | 1 | CONFIRMED |
| FFA4 | hJoyHeld | 57 | 3 | 2 | 17 | CONFIRMED |
| FFA5 | hJoyPressed | 94 | 13 | 0 | 20 | CONFIRMED |
| FFA6 | hJoyPressedRepeat | 101 | 3 | 0 | 30 | PROBABLE |
| FFA7 | hJoyDispatchExtraMask | 1 | 7 | 0 | 6 | one-shot consumer mask; see bounded producer qualification below |
| FFA8 | hFarCallTrampoline | 0 | 1 | 0 | 1 | CONFIRMED |
| FFA9 | hRam_FFA9 | 0 | 6 | 0 | 1 |  |
| FFAA | hRam_FFAA | 0 | 1 | 0 | 1 |  |
| FFAB | hRam_FFAB | 0 | 6 | 0 | 1 |  |
| FFAC | hRam_FFAC | 0 | 6 | 0 | 1 |  |
| FFAD | hRam_FFAD | 0 | 1 | 0 | 1 |  |
| FFAE | hFarCallTarget | 0 | 7 | 0 | 1 | CONFIRMED |
| FFAF | hRam_FFAF | 2 | 7 | 0 | 1 |  |
| FFB0 | hRam_FFB0 | 80 | 189 | 1 | 30 |  |
| FFB1 | hRam_FFB1 | 63 | 68 | 3 | 12 |  |
| FFB2 | hRam_FFB2 | 41 | 29 | 0 | 9 |  |
| FFB3 | hRam_FFB3 | 15 | 25 | 0 | 6 |  |
| FFB4 | hRam_FFB4 | 32 | 17 | 0 | 7 |  |
| FFB5 | hRam_FFB5 | 17 | 7 | 0 | 5 |  |
| FFB6 | hRam_FFB6 | 5 | 6 | 0 | 3 |  |
| FFB7 | hRam_FFB7 | 9 | 6 | 0 | 3 |  |
| FFB8 | hRam_FFB8 | 8 | 6 | 0 | 2 |  |
| FFB9 | hRam_FFB9 | 8 | 6 | 0 | 3 |  |
| FFBA | hRam_FFBA | 17 | 41 | 0 | 9 |  |
| FFBB | hRam_FFBB | 14 | 44 | 0 | 8 |  |
| FFBC | hRam_FFBC | 13 | 47 | 0 | 7 |  |
| FFBD | hRam_FFBD | 25 | 49 | 0 | 7 |  |
| FFBE | hRam_FFBE | 10 | 44 | 0 | 7 |  |
| FFBF | hRam_FFBF | 5 | 5 | 0 | 2 |  |
| FFC0 | hRam_FFC0 | 6 | 44 | 0 | 6 |  |
| FFC1 | hRam_FFC1 | 7 | 44 | 0 | 7 |  |
| FFC2 | hRam_FFC2 | 14 | 39 | 0 | 7 |  |
| FFC3 | hRam_FFC3 | 14 | 39 | 0 | 7 |  |
| FFC4 | hRam_FFC4 | 19 | 44 | 0 | 7 |  |
| FFC5 | hRam_FFC5 | 18 | 44 | 0 | 6 |  |
| FFC6 | hRam_FFC6 | 14 | 44 | 0 | 7 |  |
| FFC7 | hRam_FFC7 | 10 | 51 | 0 | 6 |  |
| FFC8 | hRam_FFC8 | 14 | 5 | 0 | 2 |  |
| FFC9 | hRam_FFC9 | 14 | 5 | 0 | 2 |  |
| FFCA | hRam_FFCA | 10 | 9 | 0 | 2 |  |
| FFCB | hRam_FFCB | 10 | 9 | 0 | 2 |  |
| FFCC | hRam_FFCC | 9 | 3 | 0 | 3 |  |
| FFCD | hRam_FFCD | 9 | 3 | 0 | 3 |  |
| FFCE | hRam_FFCE | 9 | 3 | 0 | 3 |  |
| FFCF | hRam_FFCF | 8 | 3 | 0 | 3 |  |
| FFD0 | hRam_FFD0 | 5 | 5 | 0 | 3 |  |
| FFD1 | hRam_FFD1 | 5 | 5 | 1 | 4 |  |
| FFD2 | hRam_FFD2 | 10 | 7 | 1 | 4 |  |
| FFD3 | hRam_FFD3 | 4 | 7 | 1 | 3 |  |
| FFD4 | hRam_FFD4 | 8 | 6 | 0 | 3 |  |
| FFD5 | hRam_FFD5 | 2 | 3 | 0 | 1 |  |
| FFD6 | hRam_FFD6 | 10 | 8 | 0 | 2 |  |
| FFD7 | hRam_FFD7 | 10 | 11 | 0 | 2 |  |
| FFD8 | hRam_FFD8 | 6 | 15 | 0 | 1 |  |
| FFD9 | hRam_FFD9 | 8 | 9 | 0 | 1 |  |
| FFDA | hRam_FFDA | 2 | 3 | 0 | 1 |  |
| FFDB | hRam_FFDB | 2 | 3 | 0 | 1 |  |
| FFDC | hRam_FFDC | 1 | 4 | 0 | 1 |  |
| FFDD | hRam_FFDD | 1 | 4 | 0 | 1 |  |
| FFDE | hRam_FFDE | 7 | 4 | 0 | 2 |  |
| FFDF | hRam_FFDF | 6 | 6 | 0 | 2 |  |
| FFE0 | hRam_FFE0 | 1 | 3 | 0 | 1 |  |
| FFE1 | hRam_FFE1 | 13 | 1 | 0 | 2 |  |
| FFE2 | hRam_FFE2 | 13 | 1 | 2 | 4 |  |
| FFE3 | hRam_FFE3 | 12 | 5 | 0 | 1 |  |
| FFE4 | hRam_FFE4 | 12 | 5 | 0 | 1 |  |
| FFE5 | hRam_FFE5 | 13 | 1 | 0 | 2 |  |
| FFE6 | hRam_FFE6 | 13 | 1 | 0 | 2 |  |
| FFE7 | hRam_FFE7 | 6 | 1 | 0 | 1 |  |
| FFE8 | hRam_FFE8 | 6 | 1 | 0 | 1 |  |
| FFE9 | hRam_FFE9 | 1 | 4 | 0 | 1 |  |
| FFEA | hRam_FFEA | 0 | 4 | 0 | 1 |  |
| FFEB | hRam_FFEB | 6 | 1 | 0 | 2 |  |
| FFEC | hRam_FFEC | 6 | 1 | 0 | 2 |  |
| FFED | hRam_FFED | 5 | 2 | 0 | 2 |  |
| FFEE | hRam_FFEE | 5 | 2 | 1 | 3 |  |
| FFEF | hRam_FFEF | 33 | 2 | 0 | 3 |  |
| FFF0 | hRam_FFF0 | 1 | 2 | 3 | 2 |  |
| FFF1 | hRam_FFF1 | 3 | 4 | 0 | 2 |  |
| FFF2 | hBankSwitchTemp | 596 | 598 | 0 | 30 | PROBABLE |
| FFF3 | hRam_FFF3 | 6 | 3 | 0 | 2 |  |
| FFF4 | hRam_FFF4 | 0 | 7 | 2 | 6 |  |
| FFF5 | hSramEnable | 52 | 405 | 1 | 26 | CONFIRMED |
| FFF6 | hRam_FFF6 | 30 | 43 | 8 | 8 |  |
| FFF7 | hRam_FFF7 | 2 | 2 | 0 | 2 |  |
| FFF8 | hRam_FFF8 | 1 | 1 | 2 | 2 |  |
| FFF9 | hRam_FFF9 | 1 | 1 | 1 | 2 |  |
| FFFA | hRam_FFFA | 0 | 0 | 3 | 1 |  |
| FFFB | hRam_FFFB | 0 | 0 | 2 | 2 |  |
| FFFC | hRam_FFFC | 2 | 3 | 0 | 1 |  |
| FFFD | hRam_FFFD | 1 | 1 | 0 | 1 |  |
| FFFE | hRam_FFFE | 1 | 1 | 2 | 2 |  |

HRAM addresses never touched by any reached instruction: FF81, FF82, FF83, FF84, FF85, FF86, FF87, FF88, FF89, FF8E, FF8F, FF90, FF91, FF92, FF93, FF94, FF95, FF96, FF97, FF98, FF99, FF9A, FF9B, FF9D, FF9E, FF9F, FFA1, FFA2.

## 4. I/O registers used, per bank

| addr | reg | r | w | banks | constants stored (A tracked) |
|---|---|---|---|---|---|
| FF00 | rP1 | 8 | 4 | 00,7D | 30 x2,20 x1,10 x1 |
| FF01 | rSB | 5 | 2 | 75 | 4B x1 |
| FF02 | rSC | 2 | 2 | 00,75 | 03 x1,83 x1 |
| FF05 | rTIMA | 0 | 2 | 00,75 |  |
| FF06 | rTMA | 1 | 1 | 00,75 |  |
| FF07 | rTAC | 0 | 15 | 00,75 | 00 x12,06 x2,02 x1 |
| FF0F | rIF | 2 | 27 | 00,22-23,27,48,4F,57,75,7F | 00 x24 |
| FF12 | rNR12 | 0 | 1 | 04 | 08 x1 |
| FF14 | rNR14 | 0 | 1 | 04 | 80 x1 |
| FF17 | rNR22 | 0 | 1 | 04 | 08 x1 |
| FF19 | rNR24 | 0 | 1 | 04 | 80 x1 |
| FF1A | rNR30 | 1 | 3 | 04 | 00 x2,80 x1 |
| FF1B | rNR31 | 0 | 1 | 04 |  |
| FF1E | rNR34 | 0 | 2 | 04 | 40 x1 |
| FF20 | rNR41 | 0 | 1 | 04 |  |
| FF21 | rNR42 | 0 | 1 | 04 | 08 x1 |
| FF23 | rNR44 | 1 | 3 | 04 | 80 x1 |
| FF24 | rNR50 | 0 | 2 | 04,4F | 77 x2 |
| FF25 | rNR51 | 1 | 4 | 04,4F | FF x2,00 x1 |
| FF26 | rNR52 | 0 | 2 | 04,4F | 80 x2 |
| FF30 | rWave_30 | 0 | 1 | 04 |  |
| FF40 | rLCDC | 247 | 84 | 00,0E,19-1B,1D,1F,22-2F,4E-51,55,57,5C,63,65,67-68,6B-6C,70,72-73,7F | 83 x2,81 x1 |
| FF41 | rSTAT | 2 | 5 | 48,57,7F | 44 x2,08 x1 |
| FF42 | rSCY | 2 | 50 | 00,19-1B,1D,1F,24,26-27,2A,2C-2D,2F,4E-51,57,5C,63,65,68,6B-6C,72-73,7F | 00 x46 |
| FF43 | rSCX | 12 | 41 | 00,19-1B,1D,1F,23,26-27,29,2E,4E-51,57,5C,63,65,68,6B-6C,70,73 | 00 x27 |
| FF44 | rLY | 75 | 0 | 00,24-26,28-2F,57,6B-6C,7F |  |
| FF45 | rLYC | 0 | 8 | 00,2D,48,57,7F | 00 x2,1A x2,8E x1,80 x1 |
| FF47 | rBGP | 0 | 3 | 4F,6B | E4 x1,00 x1 |
| FF48 | rOBP0 | 0 | 1 | 4F | E4 x1 |
| FF49 | rOBP1 | 0 | 1 | 4F | E4 x1 |
| FF4A | rWY | 16 | 50 | 00,19-1B,1D,1F,23,26-27,29-2A,2C-2F,4E-51,55,57,5C,65,68,6B-6C,70,72-73 | 90 x30,F0 x5,D0 x4,70 x2 |
| FF4B | rWX | 0 | 31 | 19-1B,1D,1F,26-27,2C-2D,2F,4E-51,55,57,5C,65,68,6B-6C,70,72-73 | 07 x27,B0 x2,00 x1,A7 x1 |
| FF4D | rKEY1 | 2 | 1 | 00,75 | 01 x1 |
| FF4F | rVBK | 0 | 114 | 00,22-27,29-2F,4F,57,6B-6C,7F | 00 x59,02 x28,01 x20 |
| FF51 | rHDMA1 | 0 | 24 | 00,24-26,29-2F,57,7F | D8 x1 |
| FF52 | rHDMA2 | 0 | 24 | 00,24-26,29-2F,57,7F | 00 x1 |
| FF53 | rHDMA3 | 0 | 24 | 00,24-26,29-2F,57,7F | 88 x1 |
| FF54 | rHDMA4 | 0 | 24 | 00,24-26,29-2F,57,7F | 00 x1 |
| FF55 | rHDMA5 | 0 | 24 | 00,24-26,29-2F,57,7F |  |
| FF68 | rBCPS | 0 | 5 | 00,4F,7F | 80 x2 |
| FF69 | rBCPD | 2 | 1 | 4F,7F |  |
| FF6A | rOCPS | 0 | 5 | 00,4F,55 | 80 x1,B2 x1 |
| FF6B | rOCPD | 2 | 2 | 4F,55 |  |
| FF70 | rSVBK | 211 | 2406 | 00,0E,19-1B,1D,1F,22-2F,48,4C,4E-51,54-55,57,5C,65,67-69,6C,70,72-74,7C,7F | 01 x963,07 x292,03 x104,02 x87 |
| FFFF | rIE | 25 | 28 | 00,22-23,27,48,4C,4E-4F,54,57,5C,65,67-68,6B,74-75,7F | 00 x2,01 x2 |

* `rP1` is polled only by the joypad routine (bank 7D) and set to `$30` before the speed switch (`00:0617`).

* `rLCDC` is the most accessed register (reads 247, writes 84): most code touches it through helper routines   `00:05B6` (turn LCD on), `00:05BD` (turn off, waiting for VBlank) and inline `ldh a,[rLCDC]` tests.

* `rVBK` is written 114 times (values $00/$01/$02 tracked; `$02` is not a valid VBK value but only bit 0 is used).

### 5.2 WRAM bank selection (CGB SVBK)

Constants written to rSVBK (`ldh [$FF70],a`, A tracked): 01 x963,07 x292,03 x104,02 x87,06 x51,14 x19,05 x16,04 x5,00 x2.
Constants written to the shadow FF8D: 01 x513,07 x291,03 x104,02 x84,06 x51,14 x19,05 x16,04 x5.

### 5.3 Hottest WRAM addresses (r+w)

`D000` is the base of many `ld hl,$D000 ; ... ld [hli],a` clears, not only the bank-thunk flag byte).

| addr | name | r | w | l | banks | const stores |
|---|---|---|---|---|---|---|
| C69F |  | 292 | 94 | 74 | 19 | 00 x5 |
| C2EE |  | 141 | 167 | 0 | 12 | 10 x8,19 x6,14 x4 |
| C26F |  | 124 | 85 | 95 | 13 | 00 x19 |
| C27C |  | 47 | 114 | 0 | 6 | 00 x47,01 x21,02 x8 |
| C27D |  | 73 | 76 | 0 | 5 | 00 x21,01 x17,02 x7 |
| C0E5 |  | 94 | 41 | 1 | 8 | 01 x7,00 x3,02 x3 |
| C26E |  | 87 | 48 | 34 | 13 | 09 x19 |
| C709 |  | 48 | 65 | 2 | 3 | 02 x12,04 x7,0F x6 |
| C6C1 |  | 65 | 40 | 35 | 3 | 00 x1 |
| D824 |  | 1 | 96 | 0 | 13 | 01 x49,00 x47 |
| C70A |  | 25 | 64 | 16 | 1 | 00 x18,01 x11,02 x4 |
| D725 |  | 8 | 75 | 0 | 15 | 00 x62,0B x8,0A x5 |
| D724 |  | 2 | 75 | 0 | 16 | 0B x46,15 x14,10 x13 |
| C0D2 |  | 3 | 62 | 0 | 4 | 00 x31,08 x2,40 x1 |
| C27E |  | 33 | 30 | 0 | 5 | 00 x12,01 x6 |
| D000 | wBankThunkFlags | 18 | 43 | 412 | 39 | 00 x20,81 x3,FF x1 |
| DA31 |  | 22 | 37 | 0 | 7 | 10 x7,06 x5,05 x5 |
| C2D5 |  | 46 | 11 | 2 | 16 | 00 x11 |
| C2D6 |  | 46 | 10 | 6 | 17 | 00 x10 |
| C0D8 |  | 42 | 14 | 0 | 6 | 01 x4,02 x2,00 x1 |
| C0D6 |  | 17 | 37 | 0 | 6 | 01 x4,02 x3,09 x3 |
| C0D3 |  | 24 | 29 | 0 | 6 | 00 x19,24 x1,28 x1 |
| DA10 |  | 10 | 42 | 193 | 23 | 16 x6,5F x5,E0 x3 |
| DA20 |  | 6 | 44 | 152 | 18 | 53 x5,22 x5,64 x4 |
| DA40 |  | 10 | 40 | 168 | 15 | 3B x5,3A x5,4C x4 |
| DA41 |  | 11 | 39 | 0 | 9 | 00 x8,10 x7,06 x5 |
| D62A |  | 22 | 28 | 0 | 6 | FF x13 |
| C2AB |  | 49 | 1 | 0 | 1 |  |
| C6A7 |  | 15 | 35 | 4 | 1 | 06 x8,03 x6,02 x5 |
| D629 |  | 22 | 27 | 21 | 6 | FF x13 |
| C2C3 |  | 28 | 20 | 0 | 11 | 00 x19,01 x1 |
| D010 |  | 38 | 8 | 4 | 5 | 00 x3,01 x1 |
| D019 |  | 27 | 19 | 0 | 2 |  |
| D011 |  | 39 | 5 | 3 | 2 |  |
| C0D4 |  | 23 | 21 | 10 | 10 | 00 x3,08 x2,01 x2 |
| C10E |  | 10 | 33 | 3 | 8 | B1 x1,E1 x1,00 x1 |
| C70D |  | 19 | 22 | 11 | 1 | FF x3,02 x3,1F x1 |
| D625 |  | 16 | 22 | 30 | 7 | FF x11,00 x5 |
| C2AD |  | 30 | 8 | 1 | 8 | 00 x4,20 x2,40 x1 |
| C264 |  | 16 | 21 | 0 | 8 | 00 x7,01 x6,02 x5 |

### 5.4 Bulk operations with constant arguments (fill/copy helpers, CONFIRMED semantics)

Helper semantics (bank 0): 04D8 fill(hl,bc,a); 04EE fill-word; 050C copy(hl->de,bc); 0526 copy backwards;
14BF strcpy; 14C6 strncpy. Rows show the tracked arguments at the call site (tier in brackets).

Fills of >= $40 bytes in WRAM/HRAM/SRAM:

| site | helper | dest | count | value | tier |
|---|---|---|---|---|---|
| 6B:4C87 | fill | C0D4 | 252 | 0 | 1 |
| 00:02CA | fill | D000 | 4096 | 0 | 1 |
| 00:02DD | fill | C000 | 8192 | 0 | 1 |
| 00:02F4 | fill | FF80 | 126 | 0 | 1 |
| 00:09D6 | fill | DA00 | 224 | 255 | 1 |
| 68:411A | fill | DE80 | 355 | 0 | 1 |
| 5C:5159 | fill | C0D4 | 252 | 0 | 1 |
| 72:4106 | fill | DC00 | 1024 | 0 | 1 |
| 72:4287 | fill | DC00 | 1024 | 0 | 1 |
| 72:42F0 | fill | DC00 | 1024 | 0 | 1 |
| 50:4069 | fill | C0D4 | 252 | 0 | 1 |
| 4E:5CA1 | fill | D000 | 320 | 0 | 1 |
| 72:66E5 | fill | DC00 | 1024 | 0 | 1 |
| 72:6A39 | fill | DC00 | 1024 | 0 | 1 |
| 74:42AD | fill | D300 | 256 | 0 | 1 |
| 57:4009 | fill | C0D4 | 252 | 0 | 1 |
| 57:4FA0 | fill | D000 | 2560 | 0 | 1 |
| 57:4FE4 | fill | D000 | 1024 | 0 | 1 |
| 57:4EBB | fill | D000 | 2560 | 0 | 1 |
| 57:4EFF | fill | D000 | 1024 | 0 | 1 |
| 57:4DAE | fill | D000 | 2560 | 0 | 1 |
| 57:4DF2 | fill | D000 | 1024 | 0 | 1 |
| 57:4B50 | fill | D000 | 2560 | 0 | 1 |
| 57:4B94 | fill | D000 | 1024 | 0 | 1 |
| 57:4C51 | fill | D000 | 2560 | 0 | 1 |
| 57:4C95 | fill | D000 | 1024 | 0 | 1 |
| 57:49E2 | fill | D000 | 2560 | 0 | 1 |
| 57:4A26 | fill | D000 | 1024 | 0 | 1 |
| 57:4866 | fill | D000 | 2560 | 0 | 1 |
| 57:48AA | fill | D000 | 1024 | 0 | 1 |
| 6C:59BA | fill | C0D4 | 252 | 0 | 1 |
| 6C:5AA9 | fill | D000 | 1024 |  | 1 |
| 6C:5C85 | fill | D000 | 1536 | 0 | 1 |
| 6C:5E3A | fill | D000 | 384 | 0 | 1 |
| 6C:5EB4 | fill | D000 | 2304 | 0 | 1 |
| 1A:4007 | fill | C0D4 | 252 | 0 | 1 |
| 1A:40E4 | fill | D000 | 2560 | 0 | 1 |
| 1A:43A5 | fill | D000 | 2560 | 0 | 1 |
| 4C:4F82 | fill | DA00 | 1536 | 0 | 1 |
| 6C:4008 | fill | C0D4 | 252 | 0 | 1 |
| 6C:4171 | fill | D000 | 1024 | 0 | 1 |
| 48:4474 | fill | D000 | 2048 | 0 | 1 |
| 4F:4735 | fill | C000 | 2800 | 0 | 1 |
| 4F:473F | fill | FFA4 | 90 | 0 | 1 |
| 4F:475E | fill | D000 | 4096 | 0 | 1 |
| 73:5F3A | fill | C0D4 | 252 | 0 | 1 |
| 73:603C | fill | D000 | 1024 | 0 | 1 |
| 1D:400A | fill | C0D4 | 252 | 0 | 1 |
| 1D:4124 | fill | D000 | 1024 | 0 | 1 |
| 1F:400A | fill | C0D4 | 252 | 0 | 1 |
| 1F:417C | fill | D000 | 1024 | 0 | 1 |
| 4F:47B6 | fill | FFA4 | 90 | 0 | 1 |
| 4F:47C0 | fill | C000 | 2800 | 0 | 1 |
| 4F:47E8 | fill | D000 | 4096 | 0 | 1 |
| 00:0952 | fill | D400 | 1024 | 0 | 2 |
| 19:4040 | fill | D000 | 2048 | 0 | 2 |
| 19:4153 | fill | D000 | 1024 | 128 | 2 |
| 19:4546 | fill | D000 | 1024 | 0 | 2 |
| 19:459E | fill | D000 | 1024 | 0 | 2 |
| 19:43FD | fill | D000 | 3072 | 0 | 2 |

Copies of >= $40 bytes (src, dest, count):

| site | helper | src | dest | count | tier |
|---|---|---|---|---|---|
| 6B:4CB6 | copy | 4480 | 8800 | 2048 | 1 |
| 6B:4CC2 | copy | 4000 | 9800 | 576 | 1 |
| 4F:4386 | copy | D800 | D880 | 128 | 1 |
| 4F:42CA | copy | D800 | D880 | 128 | 1 |
| 68:49E7 | copy | B000 | B100 | 256 | 1 |
| 72:4776 | copy | D2E0 | D120 | 288 | 1 |
| 72:4794 | copy | D2A0 | D0E0 | 352 | 1 |
| 72:4169 | copy | D180 | D120 | 288 | 1 |
| 72:4175 | copy | D580 | D520 | 288 | 1 |
| 72:473A | copy | D120 | D2E0 | 288 | 1 |
| 72:4332 | copy | D140 | D0E0 | 352 | 1 |
| 72:433E | copy | D540 | D4E0 | 352 | 1 |
| 72:4758 | copy | D0E0 | D2A0 | 352 | 1 |
| 4E:4BBF | copy | D500 | D400 | 256 | 1 |
| 4E:4C01 | copy | C380 | D500 | 256 | 1 |
| 4E:4C2F | copy | D500 | C380 | 256 | 1 |
| 4C:4D41 | copy | C380 | D500 | 256 | 1 |
| 4C:42A0 | copy | C380 | D400 | 256 | 1 |
| 4C:43DF | copy | D400 | C380 | 256 | 1 |
| 4C:43EB | copy | D400 | D500 | 256 | 1 |
| 4C:485B | copy | D500 | C380 | 256 | 1 |
| 4C:4870 | copy | C380 | DD00 | 256 | 1 |
| 74:59A7 | copy | ? | C380 | 256 | 1 |
| 4E:4CA6 | copy | D880 | D800 | 128 | 1 |
| 48:44F8 | copy | D800 | D880 | 128 | 1 |
| 48:4504 | copy | D800 | D900 | 128 | 1 |
| 48:4558 | copy | D800 | D880 | 128 | 1 |
| 48:4564 | copy | D800 | D900 | 128 | 1 |
| 4C:50D7 | copy | D880 | D800 | 128 | 1 |
| 4C:5156 | copy | C380 | D500 | 256 | 1 |
| 4C:51BC | copy | D500 | C380 | 256 | 1 |
| 4C:51CE | copy | C380 | DD00 | 256 | 1 |
| 4C:5094 | copy | D880 | D800 | 128 | 1 |
| 48:46E1 | copy | D800 | D880 | 128 | 1 |
| 4F:4705 | copy | ? | C380 | 256 | 1 |
| 4F:4315 | copy | D800 | D880 | 128 | 2 |
| 4F:43CE | copy | D800 | D880 | 128 | 2 |
| 4E:4E46 | copy | ? | C380 | 256 | 2 |
| 68:4923 | copy | B100 | B000 | 256 | 2 |
| 68:4E73 | copy | 4EA7 | D000 | 192 | 2 |
| 68:6D0A | copy | ? | A000 | 192 | 2 |
| 72:4470 | copyback | D23F | D29F | 288 | 1 |
| 72:447C | copyback | D63F | D69F | 288 | 1 |
| 72:44FC | copyback | D1FF | D25F | 288 | 1 |
| 72:4508 | copyback | D5FF | D65F | 288 | 1 |

## 6. VRAM (8000-9FFF)

Direct absolute VRAM stores are rare; VRAM is written through pointers (`ld hl/de,$8xxx/$9xxx`), the
HDMA registers (FF51-FF55, 24 static writes in 13 banks) and the copy helpers above. Address loads:

| addr | r | w | l | banks | callee after load |
|---|---|---|---|---|---|
| 8000 | 0 | 2 | 65 | 31 | 06D1 x58,04D8 x4 |
| 8001 | 0 | 0 | 21 | 11 | 06D1 x21 |
| 8010 | 0 | 1 | 3 | 3 | 0A65 x2 |
| 8050 | 0 | 0 | 1 | 1 | 0A65 x1 |
| 80A0 | 0 | 0 | 4 | 2 | 0A65 x4 |
| 8101 | 0 | 0 | 1 | 1 | 06D1 x1 |
| 81A1 | 0 | 0 | 1 | 1 |  |
| 8200 | 0 | 0 | 2 | 1 | 06D1 x2 |
| 8241 | 0 | 0 | 1 | 1 | 6F2E x1 |
| 83BF | 0 | 0 | 1 | 1 |  |
| 83C0 | 0 | 0 | 1 | 1 |  |
| 83E6 | 0 | 0 | 1 | 1 | 063D x1 |
| 8400 | 0 | 0 | 11 | 10 | 06D1 x11 |
| 8401 | 0 | 0 | 6 | 5 | 06D1 x6 |
| 8600 | 0 | 0 | 2 | 1 | 06D1 x2 |
| 8700 | 0 | 0 | 3 | 1 | 06D1 x2 |
| 8800 | 0 | 2 | 54 | 30 | 06D1 x41,4A54 x1 |
| 8801 | 0 | 0 | 49 | 13 | 06D1 x48,6F2E x1 |
| 8808 | 0 | 0 | 1 | 1 | 0A65 x1 |
| 8A80 | 0 | 0 | 2 | 1 | 06D1 x2 |
| 8A81 | 0 | 0 | 1 | 1 | 06D1 x1 |
| 8AD0 | 0 | 0 | 1 | 1 |  |
| 8AF1 | 0 | 0 | 1 | 1 | 06D1 x1 |
| 8B01 | 0 | 0 | 2 | 2 | 06D1 x2 |
| 8B40 | 0 | 0 | 2 | 2 | 06D1 x2 |
| 8C00 | 0 | 0 | 24 | 16 | 06D1 x17,4A54 x1 |
| 8C01 | 0 | 0 | 40 | 11 | 06D1 x40 |
| 8C10 | 0 | 0 | 2 | 1 | 06D1 x2 |
| 8C80 | 0 | 0 | 1 | 1 | 06D1 x1 |
| 8D00 | 0 | 0 | 2 | 1 | 06D1 x2 |
| 8E00 | 0 | 0 | 2 | 2 | 06D1 x2 |
| 8E80 | 0 | 0 | 2 | 1 | 06D1 x2 |
| 8F00 | 0 | 0 | 3 | 2 | 06D1 x3 |
| 8F01 | 0 | 0 | 3 | 2 | 06D1 x3 |
| 8FF0 | 0 | 0 | 3 | 1 | 06D1 x3 |
| 9000 | 0 | 0 | 82 | 28 | 06D1 x62,4C20 x3 |
| 9001 | 0 | 0 | 68 | 26 | 06D1 x68 |
| 9010 | 0 | 1 | 1 | 1 |  |
| 9080 | 0 | 0 | 1 | 1 | 06D1 x1 |
| 90F0 | 0 | 0 | 1 | 1 | 06D1 x1 |
| 9100 | 0 | 0 | 3 | 1 | 06D1 x3 |
| 9101 | 0 | 0 | 4 | 1 | 06D1 x4 |
| 9200 | 0 | 0 | 3 | 2 | 06D1 x3 |
| 9281 | 0 | 0 | 1 | 1 | 06D1 x1 |
| 9301 | 0 | 0 | 26 | 12 | 06D1 x26 |
| 9400 | 0 | 0 | 51 | 25 | 06D1 x36,4A54 x1 |
| 9401 | 0 | 0 | 52 | 21 | 06D1 x52 |
| 9501 | 0 | 0 | 1 | 1 | 06D1 x1 |
| 9540 | 0 | 0 | 1 | 1 | 4C20 x1 |
| 9581 | 0 | 0 | 5 | 2 | 06D1 x5 |
| 9600 | 0 | 0 | 7 | 4 | 06D1 x7 |
| 9701 | 0 | 0 | 15 | 9 | 06D1 x15 |
| 97D0 | 0 | 0 | 3 | 1 | 06D1 x3 |
| 9800 | 1 | 2 | 7 | 5 | 53C6 x2,050C x1 |
| 9801 | 0 | 1 | 1 | 1 |  |
| 9802 | 0 | 1 | 0 | 1 |  |
| 9803 | 0 | 1 | 0 | 1 |  |
| 9804 | 0 | 1 | 0 | 1 |  |
| 9806 | 0 | 1 | 0 | 1 |  |
| 9807 | 0 | 1 | 0 | 1 |  |
| 9809 | 0 | 1 | 0 | 1 |  |
| 980A | 0 | 1 | 0 | 1 |  |
| 980C | 0 | 1 | 0 | 1 |  |
| 980D | 0 | 1 | 0 | 1 |  |
| 980F | 0 | 1 | 0 | 1 |  |
| 9810 | 0 | 1 | 0 | 1 |  |
| 9820 | 0 | 0 | 2 | 1 | 53C6 x2 |
| 9840 | 0 | 0 | 2 | 1 | 53C6 x2 |
| 9866 | 0 | 1 | 2 | 1 |  |
| 9867 | 0 | 1 | 0 | 1 |  |
| 9868 | 0 | 1 | 0 | 1 |  |
| 9869 | 0 | 1 | 0 | 1 |  |
| 986A | 0 | 1 | 0 | 1 |  |
| 986B | 0 | 1 | 0 | 1 |  |
| 986C | 0 | 1 | 0 | 1 |  |
| 986D | 0 | 1 | 0 | 1 |  |
| 986E | 0 | 1 | 0 | 1 |  |
| 986F | 0 | 1 | 0 | 1 |  |
| 9870 | 0 | 1 | 0 | 1 |  |
| 9871 | 0 | 1 | 0 | 1 |  |

Boot clears VRAM banks 0 and 1 (00:02B2-02B9, 02E0-02E7) - see section 2.

## 7. SRAM (A000-BFFF)

158 distinct SRAM addresses are referenced by reached code (direct, pointer use or address load).

### 7.1 MBC5 register writes (static)

| addr | register | writes | banks | A values (tracked) |
|---|---|---|---|---|
| 0000 | RAMG | 422 | 00,0E-0F,22,24-25,27,2A-2D,2F,48,4C,4E-4F,51,54-55,65,67-68,70,74,7C,7F | 0A x215,00 x153 |
| 2000 | ROMB0 | 7 | 00 | 75 x3 |
| 2100 | ROMB0 | 30 | 00,68 | 3F x3,4F x2,7F x2,0F x1,6B x1,01 x1 |
| 3000 | ROMB1 | 10 | 00 | 00 x5 |
| 4000 | RAMB | 337 | 00,0E-0F,22,24-25,27,2A-2D,2F,48,4C,4E,51,54-55,65,67-68,70,7C,7F | 01 x132,00 x49,03 x23,02 x12 |

* `RAMG` writes: `$0A` enables cartridge RAM, `$00` disables it; the value is usually loaded from the shadow   `FFF5` when restoring a previous state (unknown-value rows).

The SRAM access routines that were disassembled   select a bank and enable RAM before accessing it, but the enable/disable pairing is NOT universal: enables outnumber   disables and e.g.

`25:4A90-4AF4` returns with RAM still enabled (see `sram_layout.md` section 1).

## 8. Immediates in echo RAM / unusable areas (not treated as RAM variables)

| value | area | r | w | l | sample sites |
|---|---|---|---|---|---|
| EE11 | ECHO | 0 | 0 | 1 | 04:4F6D |
| F000 | ECHO | 0 | 0 | 1 | 1A:40BF |
| F001 | ECHO | 0 | 0 | 2 | 19:4AC8,1B:418B |
| F008 | ECHO | 0 | 0 | 1 | 5C:5430 |
| F00E | ECHO | 0 | 0 | 2 | 57:4C31,57:4F80 |
| F400 | ECHO | 0 | 0 | 2 | 22:419F,22:430C |
| F448 | ECHO | 0 | 0 | 1 | 75:5370 |
| F800 | ECHO | 0 | 0 | 1 | 1A:42E4 |
| F801 | ECHO | 0 | 0 | 1 | 1A:4306 |
| F806 | ECHO | 0 | 0 | 1 | 6C:5F1A |
| FC00 | ECHO | 0 | 0 | 2 | 23:418D,23:42B7 |
| FC18 | ECHO | 0 | 0 | 2 | 75:4D6E,75:537E |
| FC20 | ECHO | 0 | 0 | 2 | 27:5038,51:4215 |
| FED4 | UNUSED | 0 | 0 | 1 | 75:538C |
| FEF0 | UNUSED | 0 | 0 | 1 | 6C:6154 |

These are `ld r16,imm16` constants (e.g. fixed-point offsets such as $F800/$FC00); they never occur in a
memory operand, so they are **not** proposed as RAM symbols. (Direct memory accesses into $E000-$FEFF are
rejected by the tier-2 filter; none occur in tier-1 code.)

## 9. Open questions

`$FFFF`, `$F800`) are still counted as address loads.

* Only `call $06D1` (dw + bank) is treated as an inline-argument farcall.

The sibling entries `00:06BC`, `00:06E5`,   `00:0716`, `00:072E` (`dw` only, bank in `FFF3`, or other operand shapes) are not: their inline bytes are decoded as code   (e.g.

`4C:4E15 ld a,[hli]` counted as a read of `D501` although HL comes out of a   scan loop, and `68:45C1`/`68:45C3`/`68:4605`/`68:4606` counted as accesses of `A001`/`A002` although they read/write the   checksum bytes `A0BE/A0BF` after a sum loop).

Fixed by `loop_kill`; the affected pointer-based counts and the   `sram_census` rows were regenerated.

It was still decoded as tier-2 code (`73:5ED1-5EF7`   is a table of sprite frame records, bytes read as data in the traces) and produced false `rNR10`/`rNR12` accesses in bank 73   and `$F800/$F801/$F803/$F8F8` echo-RAM immediates.

Six source producers explicitly store zero;   `51:41D3` stores returned A.

Its two ordinary source routes conditionally yield A=0: the early   call at `51:4069`, OR test at `51:406C` and JP Z at `51:406D` branch only with A=0; ordinary close at `51:41C7` exits   FadeOutToWhite through PalFade_Step with A=0 before Sprite_ResetAll preserves AF.

* CORRECTED: "every SRAM access is bracketed by save/enable/restore/disable" (false, see `sram_layout.md` section 1).   (Unchanged: "only banks 00 and 75 touch rSB/rSC" is limited to reached code but the traces agree,   `traces/detail/*/serialsum.tsv` lists only `00:0207/023C` and bank 75.) * CORRECTED: hard-coded usage numbers in the `hBankSwitchTemp` note (547/548/26 banks) were stale; the appended   `[usage ...]` counts are the computed ones.

* DOWNGRADED: `D000-D004` bank qualifier ("WRAM bank 1") is verified for two callers only; the two thunk claims that the   flags live in WRAM bank 1 are PROBABLE, the instruction sequences are CONFIRMED.
